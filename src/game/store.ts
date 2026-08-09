import { createContext, useContext } from 'react';
import {
  type DragonStage,
  type GameState,
  type LocationId,
  LOCATIONS,
} from './data';

const STORAGE_KEY = 'readquest_web_v2';

export const initialState = (): GameState => ({
  playerName: '',
  onboardingDone: false,
  wordsRead: 0,
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
    return { ...initialState(), ...(JSON.parse(raw) as Partial<GameState>) };
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

export function registerCorrectWord(
  state: GameState,
  word: string,
  reward: { xp: number; coins: number; crystals?: number } = { xp: 10, coins: 3 },
  unitId?: string,
): GameState {
  let next: GameState = {
    ...state,
    wordsRead: state.wordsRead + 1,
    xp: state.xp + reward.xp,
    coins: state.coins + reward.coins,
    crystals: state.crystals + (reward.crystals ?? 0),
    correct: state.correct + 1,
    attempts: state.attempts + 1,
    vitality: Math.min(1, state.vitality + 0.04),
    lastReadAt: Date.now(),
    dragonXp: state.dragonXp + reward.xp,
    completedUnits: unitId && !state.completedUnits.includes(unitId)
      ? [...state.completedUnits, unitId]
      : state.completedUnits,
  };

  // Адаптив: повышаем readingLevel после серии успехов
  if (next.correct > 0 && next.correct % 8 === 0 && next.readingLevel < 6) {
    next = { ...next, readingLevel: next.readingLevel + 1 };
  }

  while (next.xp >= xpToNextLevel(next.level)) {
    next = {
      ...next,
      xp: next.xp - xpToNextLevel(next.level),
      level: next.level + 1,
    };
  }

  const need = dragonXpNeed(next.dragonStage);
  if (need > 0 && next.dragonXp >= need && next.dragonStage !== 'legendary') {
    next = {
      ...next,
      dragonStage: nextStage(next.dragonStage),
      dragonXp: next.dragonXp - need,
    };
  }

  void word;
  return next;
}

export function registerWrongWord(state: GameState, word: string): GameState {
  const hardWords = { ...state.hardWords };
  hardWords[word] = (hardWords[word] ?? 0) + 1;
  const hardLetters = { ...state.hardLetters };
  for (const ch of word.toLowerCase()) {
    if (/[а-яa-z]/i.test(ch)) {
      hardLetters[ch] = (hardLetters[ch] ?? 0) + 1;
    }
  }
  return {
    ...state,
    errors: state.errors + 1,
    attempts: state.attempts + 1,
    hardWords,
    hardLetters,
  };
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

export function unlockNextLocation(state: GameState): GameState {
  const order = LOCATIONS.map((l) => l.id);
  const idx = order.indexOf(state.currentLocation);
  if (idx < 0 || idx >= order.length - 1) return state;
  const nextId = order[idx + 1];
  if (state.unlockedLocations.includes(nextId)) return state;
  return {
    ...state,
    unlockedLocations: [...state.unlockedLocations, nextId],
    currentLocation: nextId,
    bossesDefeated: state.bossesDefeated + 1,
    xp: state.xp + 100,
    coins: state.coins + 25,
    crystals: state.crystals + 1,
  };
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
  return Math.round((state.correct / state.attempts) * 100);
}
