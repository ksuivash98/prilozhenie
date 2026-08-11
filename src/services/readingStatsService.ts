import type { GameState } from '../game/data';
import type {
  ReadingOutcome,
  ReadingRecord,
  ReadingSession,
} from '../types/readingStats';
import { STATISTICS_VERSION } from '../types/readingStats';
import { getReward, scaleNewWordReward } from './rewardService';
import { normalizeSpeech } from './fuzzyMatch';

/** Стабильный wordId по тексту (и опциональному unitId). */
export function makeWordId(word: string, unitId?: string): string {
  if (unitId && unitId.trim()) return unitId.trim();
  const normalized = normalizeSpeech(word).replace(/\s+/g, '_');
  return `word_${normalized || 'unknown'}`;
}

export function todayKey(date = new Date()): string {
  return date.toISOString().slice(0, 10);
}

function difficultyOf(word: string): ReadingRecord['difficulty'] {
  const len = normalizeSpeech(word).length;
  if (len <= 3) return 'easy';
  if (len <= 6) return 'medium';
  return 'hard';
}

function emptySession(date: string): ReadingSession {
  return {
    id: `session_${date}`,
    date,
    durationMs: 0,
    attempts: 0,
    successfulAttempts: 0,
    uniqueWords: 0,
    newWords: 0,
    repeatedWords: 0,
  };
}

function touchSession(
  sessions: Record<string, ReadingSession>,
  date: string,
  patch: Partial<ReadingSession>,
): Record<string, ReadingSession> {
  const current = sessions[date] ?? emptySession(date);
  return {
    ...sessions,
    [date]: { ...current, ...patch },
  };
}

function applyMastery(record: ReadingRecord): ReadingRecord {
  // Освоено: успехи в ≥3 разных учебных днях (не спам за минуту)
  const mastered = record.successfulSessionDates.length >= 3;
  return { ...record, isMastered: mastered };
}

function recountUnique(records: Record<string, ReadingRecord>): number {
  return Object.values(records).filter((r) => r.successCount > 0).length;
}

function applyXpRewards(
  state: GameState,
  reward: { xp: number; coins: number; crystals: number },
): GameState {
  let next: GameState = {
    ...state,
    xp: state.xp + reward.xp,
    coins: state.coins + reward.coins,
    crystals: state.crystals + reward.crystals,
    dragonXp: state.dragonXp + reward.xp,
  };

  // level-up helpers imported lazily via circular-safe inline
  const xpNeed = (level: number) => 100 + level * 50;
  while (next.xp >= xpNeed(next.level)) {
    next = {
      ...next,
      xp: next.xp - xpNeed(next.level),
      level: next.level + 1,
    };
  }

  const stageNeed = (stage: GameState['dragonStage']) => {
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
  };
  const stages: GameState['dragonStage'][] = [
    'egg',
    'baby',
    'teen',
    'adult',
    'legendary',
  ];
  const need = stageNeed(next.dragonStage);
  if (need > 0 && next.dragonXp >= need && next.dragonStage !== 'legendary') {
    const idx = stages.indexOf(next.dragonStage);
    next = {
      ...next,
      dragonStage: stages[Math.min(idx + 1, stages.length - 1)],
      dragonXp: next.dragonXp - need,
    };
  }

  return next;
}

export interface RecordSuccessOptions {
  unitId?: string;
  /** Базовая награда только для НОВОГО слова. */
  newWordReward?: { xp?: number; coins?: number; crystals?: number };
  kind?: 'NEW_WORD' | 'NEW_SENTENCE' | 'NEW_STORY';
}

/**
 * Фиксирует успешное чтение.
 * Уникальные слова и полные награды — только при первом успехе wordId.
 */
export function recordSuccessfulReading(
  state: GameState,
  word: string,
  options: RecordSuccessOptions = {},
): ReadingOutcome {
  const wordId = makeWordId(word, options.unitId);
  const display = word.trim() || wordId;
  const now = Date.now();
  const date = todayKey();
  const records = { ...state.readingRecords };
  const existing = records[wordId];
  const isNewWord = !existing || existing.successCount === 0;

  let record: ReadingRecord;
  if (!existing) {
    record = {
      id: `rec_${wordId}`,
      wordId,
      word: display,
      attemptCount: 1,
      successCount: 1,
      failCount: 0,
      firstSuccessfulAt: now,
      lastAttemptAt: now,
      lastSuccessfulAt: now,
      successfulSessionDates: [date],
      isMastered: false,
      difficulty: difficultyOf(display),
    };
  } else {
    const dates = existing.successfulSessionDates.includes(date)
      ? existing.successfulSessionDates
      : [...existing.successfulSessionDates, date];
    record = applyMastery({
      ...existing,
      word: display,
      attemptCount: existing.attemptCount + 1,
      successCount: existing.successCount + 1,
      lastAttemptAt: now,
      lastSuccessfulAt: now,
      firstSuccessfulAt: existing.firstSuccessfulAt ?? now,
      successfulSessionDates: dates,
    });
  }
  records[wordId] = record;

  const reward = isNewWord
    ? scaleNewWordReward(
        getReward(options.kind ?? 'NEW_WORD'),
        options.newWordReward,
      )
    : getReward('REPEATED_WORD');

  const uniqueWords = recountUnique(records);
  const repeatedWords = state.repeatedWords + (isNewWord ? 0 : 1);

  const prevSession = state.dailySessions[date];
  let sessions = touchSession(state.dailySessions, date, {
    attempts: (prevSession?.attempts ?? 0) + 1,
    successfulAttempts: (prevSession?.successfulAttempts ?? 0) + 1,
    newWords: (prevSession?.newWords ?? 0) + (isNewWord ? 1 : 0),
    repeatedWords: (prevSession?.repeatedWords ?? 0) + (isNewWord ? 0 : 1),
    uniqueWords: Object.values(records).filter(
      (r) =>
        r.successCount > 0 &&
        r.successfulSessionDates.includes(date),
    ).length,
    // Оценка длительности: ~20 сек на попытку чтения
    durationMs: (prevSession?.durationMs ?? 0) + 20_000,
  });

  const successfulAttempts = (state.successfulAttempts || state.correct || 0) + 1;

  let next: GameState = {
    ...state,
    statisticsVersion: STATISTICS_VERSION,
    readingRecords: records,
    dailySessions: sessions,
    uniqueWords,
    wordsRead: uniqueWords,
    successfulAttempts,
    correct: successfulAttempts,
    attempts: state.attempts + 1,
    repeatedWords,
    masteredWords: Object.values(records).filter((r) => r.isMastered).length,
    vitality: Math.min(1, state.vitality + (isNewWord ? 0.04 : 0.01)),
    lastReadAt: now,
    completedUnits:
      options.unitId && !state.completedUnits.includes(options.unitId)
        ? [...state.completedUnits, options.unitId]
        : state.completedUnits,
  };

  next = applyXpRewards(next, reward);

  if (
    isNewWord &&
    next.uniqueWords > 0 &&
    next.uniqueWords % 8 === 0 &&
    next.readingLevel < 6
  ) {
    next = { ...next, readingLevel: next.readingLevel + 1 };
  }

  return {
    state: next,
    isNewWord,
    isRepeat: !isNewWord,
    reward,
    message: isNewWord
      ? '🎉 Новое слово!'
      : '🔄 Отличное повторение!',
    wordId,
  };
}

/** Фиксирует неуспешную попытку (без наград). */
export function recordFailedReading(state: GameState, word: string, unitId?: string): GameState {
  const wordId = makeWordId(word, unitId);
  const display = word.trim() || wordId;
  const now = Date.now();
  const date = todayKey();
  const records = { ...state.readingRecords };
  const existing = records[wordId];

  records[wordId] = existing
    ? {
        ...existing,
        attemptCount: existing.attemptCount + 1,
        failCount: existing.failCount + 1,
        lastAttemptAt: now,
      }
    : {
        id: `rec_${wordId}`,
        wordId,
        word: display,
        attemptCount: 1,
        successCount: 0,
        failCount: 1,
        firstSuccessfulAt: null,
        lastAttemptAt: now,
        lastSuccessfulAt: null,
        successfulSessionDates: [],
        isMastered: false,
        difficulty: difficultyOf(display),
      };

  const hardWords = { ...state.hardWords };
  hardWords[display] = (hardWords[display] ?? 0) + 1;
  const hardLetters = { ...state.hardLetters };
  for (const ch of normalizeSpeech(display)) {
    if (/[а-яa-z]/i.test(ch)) {
      hardLetters[ch] = (hardLetters[ch] ?? 0) + 1;
    }
  }

  const sessions = touchSession(state.dailySessions, date, {
    attempts: (state.dailySessions[date]?.attempts ?? 0) + 1,
    durationMs: (state.dailySessions[date]?.durationMs ?? 0) + 20_000,
  });

  return {
    ...state,
    statisticsVersion: STATISTICS_VERSION,
    readingRecords: records,
    dailySessions: sessions,
    attempts: state.attempts + 1,
    errors: state.errors + 1,
    hardWords,
    hardLetters,
  };
}

/** Миграция со старой статистики (version < 2). */
export function migrateReadingStats(raw: Partial<GameState>): Partial<GameState> {
  const version = raw.statisticsVersion ?? 1;
  if (version >= STATISTICS_VERSION) {
    return {
      ...raw,
      wordsRead: raw.uniqueWords ?? Object.keys(raw.readingRecords ?? {}).length,
      uniqueWords: raw.uniqueWords ?? Object.keys(raw.readingRecords ?? {}).length,
      successfulAttempts: raw.successfulAttempts ?? raw.correct ?? 0,
    };
  }

  // Legacy: нельзя достоверно восстановить уникальные слова
  return {
    ...raw,
    statisticsVersion: STATISTICS_VERSION,
    legacyWordsRead: raw.wordsRead ?? 0,
    readingRecords: {},
    dailySessions: {},
    uniqueWords: 0,
    wordsRead: 0,
    successfulAttempts: raw.correct ?? 0,
    repeatedWords: 0,
    masteredWords: 0,
  };
}

export function getTodayStats(state: GameState) {
  const session = state.dailySessions[todayKey()];
  const attempts = session?.attempts ?? 0;
  const successful = session?.successfulAttempts ?? 0;
  return {
    newWords: session?.newWords ?? 0,
    repeatedWords: session?.repeatedWords ?? 0,
    attempts,
    successfulAttempts: successful,
    uniqueWords: session?.uniqueWords ?? 0,
    accuracy: attempts === 0 ? 100 : Math.round((successful / attempts) * 100),
    durationMs: session?.durationMs ?? 0,
  };
}

export function getWeekNewWords(state: GameState): { date: string; newWords: number }[] {
  const days: { date: string; newWords: number }[] = [];
  const now = new Date();
  for (let i = 6; i >= 0; i -= 1) {
    const d = new Date(now);
    d.setDate(now.getDate() - i);
    const key = todayKey(d);
    days.push({ date: key, newWords: state.dailySessions[key]?.newWords ?? 0 });
  }
  return days;
}

export function skillBreakdown(state: GameState) {
  const records = Object.values(state.readingRecords ?? {});
  const mastered = records.filter((r) => r.isMastered).length;
  const learning = records.filter(
    (r) => r.successCount > 0 && !r.isMastered,
  ).length;
  const needsPractice = records.filter(
    (r) => r.failCount > r.successCount || (r.successCount > 0 && r.failCount >= 2),
  ).length;
  return { mastered, learning, needsPractice };
}

/**
 * Для открытий города/мини-игр: не ломаем прогресс после миграции.
 * UI «выучено слов» по-прежнему показывает uniqueWords.
 */
export function unlockProgressWords(state: GameState): number {
  return Math.max(state.uniqueWords ?? 0, state.legacyWordsRead ?? 0);
}

/** Награда за рассказ (не считается новым учебным словом). */
export function applyStoryReward(state: GameState, storyId: string): GameState {
  if (state.storiesRead.includes(storyId)) return state;
  const reward = getReward('NEW_STORY');
  let next: GameState = {
    ...state,
    storiesRead: [...state.storiesRead, storyId],
    statisticsVersion: STATISTICS_VERSION,
  };
  next = applyXpRewards(next, reward);
  return next;
}
