/** Уровень освоения слова: 0 не изучалось … 4 освоено. */
export type MasteryLevel = 0 | 1 | 2 | 3 | 4;

/** Запись об изучении конкретного слова. */
export interface ReadingRecord {
  id: string;
  wordId: string;
  word: string;
  chapterId?: number;
  attemptCount: number;
  successCount: number;
  failCount: number;
  errorCount: number;
  accuracy: number;
  firstSeenAt: number;
  firstSuccessfulAt: number | null;
  lastAttemptAt: number;
  lastSuccessfulAt: number | null;
  /** Даты (YYYY-MM-DD), в которых было успешное чтение. */
  successfulSessionDates: string[];
  /** Игровые сессии (readingSessionId), в которых было успешное чтение. */
  successfulSessionIds: string[];
  masteryLevel: MasteryLevel;
  isMastered: boolean;
  difficulty: 'easy' | 'medium' | 'hard';
}

/** Дневная учебная сессия (агрегат за календарный день). */
export interface ReadingSession {
  id: string;
  date: string;
  durationMs: number;
  attempts: number;
  successfulAttempts: number;
  uniqueWords: number;
  newWords: number;
  repeatedWords: number;
}

/** Прохождения мини-игры: playCount ≠ rewardedPlayCount. */
export interface MiniGamePlayRecord {
  gameId: string;
  date: string;
  playCount: number;
  rewardedPlayCount: number;
}

export type RewardKind =
  | 'NEW_WORD'
  | 'REPEATED_WORD'
  | 'NEW_SENTENCE'
  | 'NEW_STORY'
  | 'DAILY_GOAL'
  | 'MINI_GAME'
  | 'CHAPTER_CLEAR';

export interface RewardPayload {
  xp: number;
  coins: number;
  crystals: number;
}

export interface ReadingOutcome {
  state: import('../game/data').GameState;
  isNewWord: boolean;
  isRepeat: boolean;
  reward: RewardPayload;
  message: string;
  wordId: string;
}

export const STATISTICS_VERSION = 3;

export const MAX_REWARDED_MINI_GAME_PLAYS = 3;

export const SESSION_GAP_MS = 30 * 60 * 1000;
