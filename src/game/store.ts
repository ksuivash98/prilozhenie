import { createContext, useContext } from 'react';
import {
  type DragonStage,
  type GameState,
  type LocationId,
  LOCATIONS,
} from './data';
import { STATISTICS_VERSION } from '../types/readingStats';
import {
  completeChapter,
  ensureReadingSession,
  migrateReadingStats,
  recordFailedReading,
  recordSuccessfulReading,
  unlockProgressWords,
} from '../services/readingStatsService';

export { unlockProgressWords, completeChapter, ensureReadingSession };

const STORAGE_KEY = 'readquest_web_v2';

export const initialState = (): GameState => ({
  playerName: '',
  onboardingDone: false,
  wordsRead: 0,
  uniqueWords: 0,
  successfulAttempts: 0,
  repeatedWords: 0,
  masteredWords: 0,
  statisticsVersion: STATISTICS_VERSION,
  readingRecords: {},
  dailySessions: {},
  miniGamePlays: {},
  completedMinibosses: [],
  completedChapters: [],
  preparedChapters: [],
  worldUnlocks: [],
  readingSessionId: `sess_${Date.now()}`,
  lastSessionAt: Date.now(),
  xp: 0,
  coins: 0,
  crystals: 0,
  level: 1,
  readingLevel: 3,
  vitality: 0.55,
  lastReadAt: Date.now(),
  unlockedLocations: ['village'],
  currentLocation: 'village',
  dragonName: 'Искорка',
  dragonStage: 'egg',
  dragonXp: 0,
  bossesDefeated: 0,
  streak: 0,
  correct: 0,
  errors: 0,
  attempts: 0,
  hardWords: {},
  hardLetters: {},
  completedUnits: [],
  parentPin: null,
  storiesRead: [],
  completedQuests: [],
  bestScores: {},
  soundEnabled: true,
  highContrast: false,
  reduceMotion: false,
  largeText: false,
});

export function loadState(): GameState {
  try {
    const raw = localStorage.getItem(STORAGE_KEY) ?? localStorage.getItem('readquest_web_v1');
    if (!raw) return initialState();
    const parsed = JSON.parse(raw) as Partial<GameState>;
    const migrated = migrateReadingStats(parsed);
    return ensureReadingSession({ ...initialState(), ...migrated });
  } catch {
    return initialState();
  }
}

export function saveState(state: GameState): void {
  try {
    localStorage.setItem(STORAGE_KEY, JSON.stringify(state));
  } catch {
    /* storage unavailable */
  }
}

export function normalize(text: string): string {
  return text
    .trim()
    .toLowerCase()
    .replace(/ё/g, 'е')
    .replace(/\s+/g, ' ');
}

export function xpToNextLevel(level: number): number {
  return 100 + level * 50;
}

export function dragonXpNeed(stage: DragonStage): number {
  switch (stage) {
    case 'egg':
      return 50;
    case 'baby':
      return 200;
    case 'teen':
      return 600;
    case 'adult':
      return 1500;
    default:
      return 0;
  }
}

export function nextStage(stage: DragonStage): DragonStage {
  const order: DragonStage[] = ['egg', 'baby', 'teen', 'adult', 'legendary'];
  const i = order.indexOf(stage);
  return order[Math.min(i + 1, order.length - 1)];
}

export function applyTimeDecay(state: GameState): GameState {
  const hours = (Date.now() - state.lastReadAt) / 3_600_000;
  if (hours < 24) return state;
  const overdue = Math.min((hours - 24) / 48, 1);
  const vitality = Math.max(0.05, state.vitality * (1 - overdue * 0.7));
  return { ...state, vitality };
}

export type CorrectWordResult = {
  state: GameState;
  isNewWord: boolean;
  isRepeat: boolean;
  xp: number;
  coins: number;
  crystals: number;
  message: string;
};

/**
 * Успешное чтение: уникальные слова и полная награда — только при первом успехе.
 * Повторы увеличивают attempts/successfulAttempts, но не wordsRead/uniqueWords.
 */
export function registerCorrectWord(
  state: GameState,
  word: string,
  reward: { xp: number; coins: number; crystals?: number } = { xp: 10, coins: 5 },
  unitId?: string,
): GameState {
  return registerCorrectWordDetailed(state, word, reward, unitId).state;
}

export function registerCorrectWordDetailed(
  state: GameState,
  word: string,
  reward: { xp: number; coins: number; crystals?: number } = { xp: 10, coins: 5 },
  unitId?: string,
): CorrectWordResult {
  const outcome = recordSuccessfulReading(state, word, {
    unitId,
    newWordReward: {
      xp: reward.xp,
      coins: reward.coins,
      crystals: reward.crystals,
    },
  });
  return {
    state: outcome.state,
    isNewWord: outcome.isNewWord,
    isRepeat: outcome.isRepeat,
    xp: outcome.reward.xp,
    coins: outcome.reward.coins,
    crystals: outcome.reward.crystals,
    message: outcome.message,
  };
}

export function registerWrongWord(state: GameState, word: string, unitId?: string): GameState {
  return recordFailedReading(state, word, unitId);
}

/** Подбирает слова для тренировки сложных букв. */
export function adaptivePracticeWords(state: GameState): string[] {
  const hard = Object.entries(state.hardLetters)
    .sort((a, b) => b[1] - a[1])
    .slice(0, 3)
    .map(([l]) => l);
  if (hard.length === 0) return ['кот', 'дом', 'лес'];
  const bank = ['рыба', 'шапка', 'жук', 'щит', 'река', 'машина', 'солнце'];
  return bank.filter((w) => hard.some((l) => w.includes(l))).slice(0, 5);
}

export function unlockNextLocation(state: GameState, locationId?: LocationId): GameState {
  return completeChapter(state, locationId ?? state.currentLocation);
}

export function hashPin(pin: string): string {
  let h = 0;
  const s = `readquest_parent_v1::${pin}`;
  for (let i = 0; i < s.length; i += 1) h = (h * 31 + s.charCodeAt(i)) >>> 0;
  return h.toString(16);
}

export interface GameContextValue {
  state: GameState;
  setState: (updater: (s: GameState) => GameState) => void;
  speak: (text: string) => void;
}

export const GameContext = createContext<GameContextValue | null>(null);

export function useGame(): GameContextValue {
  const ctx = useContext(GameContext);
  if (!ctx) throw new Error('useGame must be used inside GameProvider');
  return ctx;
}

export function locationById(id: LocationId) {
  return LOCATIONS.find((l) => l.id === id);
}

export function successRate(state: GameState): number {
  if (state.attempts === 0) return 100;
  const success = state.successfulAttempts || state.correct;
  return Math.round((success / state.attempts) * 100);
}
