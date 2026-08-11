/** Запись об изучении конкретного слова. */
export interface ReadingRecord {
  id: string;
  wordId: string;
  word: string;
  attemptCount: number;
  successCount: number;
  failCount: number;
  firstSuccessfulAt: number | null;
  lastAttemptAt: number;
  lastSuccessfulAt: number | null;
  /** Даты сессий (YYYY-MM-DD), в которых было успешное чтение. */
  successfulSessionDates: string[];
  isMastered: boolean;
  difficulty: 'easy' | 'medium' | 'hard';
}

/** Дневная учебная сессия. */
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

export type RewardKind =
  | 'NEW_WORD'
  | 'REPEATED_WORD'
  | 'NEW_SENTENCE'
  | 'NEW_STORY'
  | 'DAILY_GOAL';

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

export const STATISTICS_VERSION = 2;
