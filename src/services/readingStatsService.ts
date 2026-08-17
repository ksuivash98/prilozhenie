import type { GameState, LocationId } from '../game/data';
import { LOCATIONS } from '../game/data';
import { chapterById, chapterByLocation, introducingChapterId } from '../data/chapters';
import type {
  MasteryLevel,
  ReadingOutcome,
  ReadingRecord,
  ReadingSession,
} from '../types/readingStats';
import { SESSION_GAP_MS, STATISTICS_VERSION } from '../types/readingStats';
import { applyRewardsToState, getReward, scaleNewWordReward } from './rewardService';
import { normalizeSpeech } from './fuzzyMatch';
import { makeWordId, todayKey } from './wordId';

export { makeWordId, todayKey };

function difficultyOf(word: string): ReadingRecord['difficulty'] {
  const len = normalizeSpeech(word).length;
  if (len <= 3) return 'easy';
  if (len <= 6) return 'medium';
  return 'hard';
}

function accuracyOf(success: number, attempts: number): number {
  if (attempts <= 0) return 0;
  return success / attempts;
}

/**
 * Освоение по разным сессиям, а не по спаму в одну минуту.
 * 10 успехов подряд в одной сессии → максимум «изучается».
 */
export function computeMasteryLevel(record: ReadingRecord): MasteryLevel {
  const success = record.successCount;
  if (success <= 0) return 0;

  const sessionCount = new Set([
    ...(record.successfulSessionIds ?? []),
  ]).size;
  const dateCount = new Set(record.successfulSessionDates ?? []).size;
  const distinct = Math.max(sessionCount, dateCount);
  const accuracy = accuracyOf(success, record.attemptCount);
  const errors = record.errorCount ?? record.failCount ?? 0;

  if (distinct >= 3 && success >= 3 && accuracy >= 0.7 && errors < success) {
    return 4;
  }
  if (distinct >= 2 && success >= 2) return 3;
  if (success >= 2) return 2;
  return 1;
}

export function applyMastery(record: ReadingRecord): ReadingRecord {
  const masteryLevel = computeMasteryLevel(record);
  return {
    ...record,
    masteryLevel,
    isMastered: masteryLevel === 4,
    accuracy: accuracyOf(record.successCount, record.attemptCount),
    errorCount: record.failCount,
  };
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

function recountUnique(records: Record<string, ReadingRecord>): number {
  return Object.values(records).filter((r) => r.successCount > 0).length;
}

export function ensureReadingSession(state: GameState, now = Date.now()): GameState {
  const last = state.lastSessionAt ?? 0;
  if (state.readingSessionId && now - last < SESSION_GAP_MS) {
    return { ...state, lastSessionAt: now };
  }
  return {
    ...state,
    readingSessionId: `sess_${now}`,
    lastSessionAt: now,
  };
}

function blankRecord(wordId: string, display: string, now: number, chapterId?: number): ReadingRecord {
  return {
    id: `rec_${wordId}`,
    wordId,
    word: display,
    chapterId,
    attemptCount: 0,
    successCount: 0,
    failCount: 0,
    errorCount: 0,
    accuracy: 0,
    firstSeenAt: now,
    firstSuccessfulAt: null,
    lastAttemptAt: now,
    lastSuccessfulAt: null,
    successfulSessionDates: [],
    successfulSessionIds: [],
    masteryLevel: 0,
    isMastered: false,
    difficulty: difficultyOf(display),
  };
}

export interface RecordSuccessOptions {
  unitId?: string;
  chapterId?: number;
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
  state = ensureReadingSession(state);
  const wordId = makeWordId(word);
  const display = word.trim() || wordId;
  const now = Date.now();
  const date = todayKey();
  const sessionId = state.readingSessionId;
  const records = { ...state.readingRecords };
  const existing = records[wordId];
  const isNewWord = !existing || existing.successCount === 0;
  const chapterId =
    existing?.chapterId ?? options.chapterId ?? introducingChapterId(wordId);

  let record: ReadingRecord;
  if (!existing) {
    record = applyMastery({
      ...blankRecord(wordId, display, now, chapterId),
      attemptCount: 1,
      successCount: 1,
      firstSuccessfulAt: now,
      lastSuccessfulAt: now,
      successfulSessionDates: [date],
      successfulSessionIds: sessionId ? [sessionId] : [],
    });
  } else {
    const dates = existing.successfulSessionDates.includes(date)
      ? existing.successfulSessionDates
      : [...existing.successfulSessionDates, date];
    const ids = sessionId && !(existing.successfulSessionIds ?? []).includes(sessionId)
      ? [...(existing.successfulSessionIds ?? []), sessionId]
      : (existing.successfulSessionIds ?? (sessionId ? [sessionId] : []));
    record = applyMastery({
      ...existing,
      word: display,
      chapterId: existing.chapterId ?? chapterId,
      attemptCount: existing.attemptCount + 1,
      successCount: existing.successCount + 1,
      lastAttemptAt: now,
      lastSuccessfulAt: now,
      firstSuccessfulAt: existing.firstSuccessfulAt ?? now,
      successfulSessionDates: dates,
      successfulSessionIds: ids,
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
  const repeatedWords = (state.repeatedWords ?? 0) + (isNewWord ? 0 : 1);

  const prevSession = state.dailySessions[date];
  const sessions = touchSession(state.dailySessions, date, {
    attempts: (prevSession?.attempts ?? 0) + 1,
    successfulAttempts: (prevSession?.successfulAttempts ?? 0) + 1,
    newWords: (prevSession?.newWords ?? 0) + (isNewWord ? 1 : 0),
    repeatedWords: (prevSession?.repeatedWords ?? 0) + (isNewWord ? 0 : 1),
    uniqueWords: Object.values(records).filter(
      (r) =>
        r.successCount > 0 &&
        r.successfulSessionDates.includes(date),
    ).length,
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

  next = applyRewardsToState(next, reward);

  if (
    isNewWord &&
    next.uniqueWords > 0 &&
    next.uniqueWords % 8 === 0 &&
    next.readingLevel < 6
  ) {
    next = { ...next, readingLevel: next.readingLevel + 1 };
  }

  const repeatMessage =
    record.successCount >= 2
      ? `Ты потренировал слово ${display.toUpperCase()} ${record.successCount} раз.`
      : '🔄 Отличное повторение!';

  return {
    state: next,
    isNewWord,
    isRepeat: !isNewWord,
    reward,
    message: isNewWord ? '🎉 Новое слово!' : repeatMessage,
    wordId,
  };
}

/** Фиксирует неуспешную попытку (без наград). */
export function recordFailedReading(state: GameState, word: string, unitId?: string): GameState {
  void unitId;
  state = ensureReadingSession(state);
  const wordId = makeWordId(word);
  const display = word.trim() || wordId;
  const now = Date.now();
  const date = todayKey();
  const records = { ...state.readingRecords };
  const existing = records[wordId];
  const chapterId = existing?.chapterId ?? introducingChapterId(wordId);
  const base = existing ?? blankRecord(wordId, display, now, chapterId);

  records[wordId] = applyMastery({
    ...base,
    word: display,
    chapterId: base.chapterId ?? chapterId,
    attemptCount: base.attemptCount + 1,
    failCount: base.failCount + 1,
    errorCount: (base.errorCount ?? base.failCount) + 1,
    lastAttemptAt: now,
  });

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

function upgradeRecord(raw: Partial<ReadingRecord> & { wordId: string }): ReadingRecord {
  const fail = raw.failCount ?? raw.errorCount ?? 0;
  const success = raw.successCount ?? 0;
  const attempts = raw.attemptCount ?? success + fail;
  const rec: ReadingRecord = {
    id: raw.id ?? `rec_${raw.wordId}`,
    wordId: raw.wordId,
    word: raw.word ?? raw.wordId,
    chapterId: raw.chapterId,
    attemptCount: attempts,
    successCount: success,
    failCount: fail,
    errorCount: fail,
    accuracy: accuracyOf(success, attempts),
    firstSeenAt: raw.firstSeenAt ?? raw.firstSuccessfulAt ?? raw.lastAttemptAt ?? Date.now(),
    firstSuccessfulAt: raw.firstSuccessfulAt ?? null,
    lastAttemptAt: raw.lastAttemptAt ?? Date.now(),
    lastSuccessfulAt: raw.lastSuccessfulAt ?? null,
    successfulSessionDates: raw.successfulSessionDates ?? [],
    successfulSessionIds: raw.successfulSessionIds ?? [],
    masteryLevel: 0,
    isMastered: false,
    difficulty: raw.difficulty ?? 'medium',
  };
  return applyMastery(rec);
}

/** Миграция со старой статистики. */
export function migrateReadingStats(raw: Partial<GameState>): Partial<GameState> {
  const version = raw.statisticsVersion ?? 1;

  if (version < 2) {
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
      miniGamePlays: {},
      completedMinibosses: [],
      completedChapters: [],
      preparedChapters: [],
      worldUnlocks: [],
      readingSessionId: `sess_${Date.now()}`,
      lastSessionAt: Date.now(),
    };
  }

  const records: Record<string, ReadingRecord> = {};
  for (const [id, rec] of Object.entries(raw.readingRecords ?? {})) {
    records[id] = upgradeRecord({ ...rec, wordId: rec.wordId || id });
  }
  const uniqueWords =
    raw.uniqueWords ?? Object.values(records).filter((r) => r.successCount > 0).length;

  return {
    ...raw,
    statisticsVersion: STATISTICS_VERSION,
    readingRecords: records,
    uniqueWords,
    wordsRead: uniqueWords,
    successfulAttempts: raw.successfulAttempts ?? raw.correct ?? 0,
    miniGamePlays: raw.miniGamePlays ?? {},
    completedMinibosses: raw.completedMinibosses ?? [],
    completedChapters: raw.completedChapters ?? [],
    preparedChapters: raw.preparedChapters ?? [],
    worldUnlocks: raw.worldUnlocks ?? [],
    readingSessionId: raw.readingSessionId ?? `sess_${Date.now()}`,
    lastSessionAt: raw.lastSessionAt ?? Date.now(),
    masteredWords: Object.values(records).filter((r) => r.isMastered).length,
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
  const mastered = records.filter((r) => r.masteryLevel === 4 || r.isMastered).length;
  const learning = records.filter(
    (r) => r.successCount > 0 && r.masteryLevel < 4 && !r.isMastered,
  ).length;
  const needsPractice = records.filter((r) => isCriticalWord(r)).length;
  return { mastered, learning, needsPractice };
}

export function isCriticalWord(record: ReadingRecord): boolean {
  const accuracy = accuracyOf(record.successCount, record.attemptCount);
  const errors = record.errorCount ?? record.failCount;
  const unstable = errors >= 3 && record.successCount < 2;
  return (record.attemptCount > 0 && accuracy < 0.5) || unstable;
}

export function unlockProgressWords(state: GameState): number {
  return Math.max(state.uniqueWords ?? 0, state.legacyWordsRead ?? 0);
}

export function applyStoryReward(state: GameState, storyId: string): GameState {
  if (state.storiesRead.includes(storyId)) return state;
  const reward = getReward('NEW_STORY');
  let next: GameState = {
    ...state,
    storiesRead: [...state.storiesRead, storyId],
    statisticsVersion: STATISTICS_VERSION,
  };
  next = applyRewardsToState(next, reward);
  return next;
}

/** Победа над главным боссом: глава завершена, уникальная награда один раз. */
export function completeChapter(state: GameState, locationId: LocationId): GameState {
  const chapter = chapterByLocation(locationId);
  if (!chapter) return state;
  if (state.completedChapters.includes(chapter.id)) return state;

  const order = LOCATIONS.map((l) => l.id);
  const idx = order.indexOf(locationId);
  const nextId = idx >= 0 && idx < order.length - 1 ? order[idx + 1] : null;
  const unlocked = nextId && !state.unlockedLocations.includes(nextId)
    ? [...state.unlockedLocations, nextId]
    : state.unlockedLocations;

  let next: GameState = {
    ...state,
    completedChapters: [...state.completedChapters, chapter.id],
    unlockedLocations: unlocked,
    currentLocation: nextId ?? state.currentLocation,
    bossesDefeated: state.bossesDefeated + 1,
    worldUnlocks: state.worldUnlocks.includes(chapter.unlock.id)
      ? state.worldUnlocks
      : [...state.worldUnlocks, chapter.unlock.id],
  };
  next = applyRewardsToState(next, getReward('CHAPTER_CLEAR'));
  return next;
}

export function markMinibossComplete(state: GameState, miniBossId: string): GameState {
  if (state.completedMinibosses.includes(miniBossId)) return state;
  return {
    ...state,
    completedMinibosses: [...state.completedMinibosses, miniBossId],
  };
}

export function markChapterPrepared(state: GameState, chapterId: number): GameState {
  if (state.preparedChapters.includes(chapterId)) return state;
  return {
    ...state,
    preparedChapters: [...state.preparedChapters, chapterId],
  };
}

export { chapterById, chapterByLocation };
