import type { GameState } from '../game/data';
import {
  type ChapterWord,
  chapterById,
  previousChapterWords,
  splitWordGroups,
} from '../data/chapters';
import type { ReadingRecord } from '../types/readingStats';
import { isCriticalWord } from './readingStatsService';
import { createRng, makeWordId } from './wordId';

export type FightMode = 'intro' | 'mini1' | 'mini2' | 'mini3' | 'boss' | 'prepare';

export interface SelectedWord extends ChapterWord {
  origin: 'new' | 'old';
  hard?: boolean;
}

export interface ChapterWordPool {
  chapterId: number;
  newWords: ChapterWord[];
  reviewWords: ChapterWord[];
  difficultWords: ChapterWord[];
  masteredWords: ChapterWord[];
}

export interface BossUnlockResult {
  ok: boolean;
  reason: 'ready' | 'need_practice';
  practiceWords: ChapterWord[];
  /** Сообщение ребёнку — без цифр accuracy/mastery. */
  childMessage: string;
}

const MAX_ERROR_WEIGHT = 4;
const MS_DAY = 86_400_000;

export function getChapterNewWords(chapterId: number): ChapterWord[] {
  return chapterById(chapterId)?.newWords ?? [];
}

export function getReviewWords(chapterId: number): ChapterWord[] {
  return previousChapterWords(chapterId);
}

export function getChapterWordPool(state: GameState, chapterId: number): ChapterWordPool {
  const newWords = getChapterNewWords(chapterId);
  const reviewWords = getReviewWords(chapterId);
  const all = [...newWords, ...reviewWords];
  const difficultWords = all.filter((w) => {
    const rec = state.readingRecords[w.id];
    return rec ? isDifficult(rec) : false;
  });
  const masteredWords = all.filter((w) => (state.readingRecords[w.id]?.masteryLevel ?? 0) >= 4);
  return { chapterId, newWords, reviewWords, difficultWords, masteredWords };
}

function isDifficult(rec: ReadingRecord): boolean {
  if (isCriticalWord(rec)) return true;
  if ((rec.masteryLevel ?? 0) <= 2 && rec.failCount > 0) return true;
  if (rec.successCount <= 1 && rec.attemptCount > 0) return true;
  return rec.accuracy < 0.7 && rec.attemptCount >= 2;
}

export function calculateWordPriority(
  word: ChapterWord,
  state: GameState,
  currentChapterId: number,
  now = Date.now(),
): number {
  const rec = state.readingRecords[word.id];
  const errors = rec?.errorCount ?? rec?.failCount ?? 0;
  const errorScore = Math.min(errors, MAX_ERROR_WEIGHT) * 25;

  const attempts = rec?.attemptCount ?? 0;
  const accuracy = rec && attempts > 0 ? rec.successCount / attempts : 0;
  const lowAccuracyScore = attempts > 0 ? (1 - accuracy) * 40 : 18;

  const mastery = rec?.masteryLevel ?? 0;
  const lowMasteryScore = (4 - mastery) * 16;

  const last = rec?.lastAttemptAt ?? rec?.lastSuccessfulAt ?? rec?.firstSeenAt;
  const days = last ? (now - last) / MS_DAY : 14;
  let forgettingScore = 0;
  if (days < 1) forgettingScore = 2;
  else if (days < 3) forgettingScore = 12;
  else if (days < 7) forgettingScore = 28;
  else if (days < 14) forgettingScore = 42;
  else forgettingScore = 58;

  const chapterRelevanceScore = word.chapterId === currentChapterId ? 32 : 8;
  const noveltyScore = !rec || rec.successCount <= 1 ? 22 : 0;
  const masteredPenalty = mastery >= 4 ? -48 : 0;
  const onceBonus = rec && rec.successCount === 1 ? 14 : 0;

  return Math.max(
    1,
    errorScore +
      lowAccuracyScore +
      lowMasteryScore +
      forgettingScore +
      chapterRelevanceScore +
      noveltyScore +
      onceBonus +
      masteredPenalty,
  );
}

function weightedPick<T>(
  items: { item: T; weight: number }[],
  rng: () => number,
): T | undefined {
  if (items.length === 0) return undefined;
  const total = items.reduce((s, i) => s + Math.max(0.01, i.weight), 0);
  let r = rng() * total;
  for (const it of items) {
    r -= Math.max(0.01, it.weight);
    if (r <= 0) return it.item;
  }
  return items[items.length - 1]?.item;
}

function pickUniqueWeighted(
  pool: ChapterWord[],
  count: number,
  state: GameState,
  chapterId: number,
  rng: () => number,
  extraBoost?: (w: ChapterWord) => number,
): ChapterWord[] {
  const picked: ChapterWord[] = [];
  const remaining = [...pool];
  while (picked.length < count && remaining.length > 0) {
    const weighted = remaining.map((item) => ({
      item,
      weight: calculateWordPriority(item, state, chapterId) + (extraBoost?.(item) ?? 0),
    }));
    const choice = weightedPick(weighted, rng);
    if (!choice) break;
    picked.push(choice);
    const idx = remaining.findIndex((w) => w.id === choice.id);
    if (idx >= 0) remaining.splice(idx, 1);
  }
  return picked;
}

function noConsecutive(words: SelectedWord[]): SelectedWord[] {
  const out = [...words];
  for (let i = 1; i < out.length; i += 1) {
    if (out[i].id !== out[i - 1].id) continue;
    const swap = out.findIndex((w, j) => j > i && w.id !== out[i].id && w.id !== out[i - 1].id);
    if (swap > 0) {
      const tmp = out[i];
      out[i] = out[swap];
      out[swap] = tmp;
    }
  }
  return out;
}

function interleave(newWords: SelectedWord[], oldWords: SelectedWord[]): SelectedWord[] {
  const result: SelectedWord[] = [];
  const n = [...newWords];
  const o = [...oldWords];
  const total = n.length + o.length;
  const oldEvery = o.length === 0 ? total + 1 : Math.max(2, Math.round(total / o.length));
  for (let i = 0; i < total; i += 1) {
    const wantOld = o.length > 0 && result.length > 0 && (result.length + 1) % oldEvery === 0;
    if (wantOld && o.length) result.push(o.shift()!);
    else if (n.length) result.push(n.shift()!);
    else if (o.length) result.push(o.shift()!);
  }
  return noConsecutive(result);
}

function countByOrigin(seq: SelectedWord[]): { newCount: number; oldCount: number } {
  return {
    newCount: seq.filter((w) => w.origin === 'new').length,
    oldCount: seq.filter((w) => w.origin === 'old').length,
  };
}

function tag(words: ChapterWord[], origin: 'new' | 'old', state: GameState): SelectedWord[] {
  return words.map((w) => {
    const rec = state.readingRecords[w.id];
    return {
      ...w,
      origin,
      hard: rec ? isDifficult(rec) : false,
    };
  });
}

function groupForMini(chapterId: number, miniIndex: 1 | 2 | 3, state: GameState): ChapterWord[] {
  const chapter = chapterById(chapterId);
  if (!chapter) return [];
  const groups = splitWordGroups(chapter.newWords, 3);
  const g1 = groups[0] ?? [];
  const g2 = groups[1] ?? [];
  const g3 = groups[2] ?? [];
  const hardFrom = (list: ChapterWord[]) =>
    list.filter((w) => {
      const rec = state.readingRecords[w.id];
      return rec ? isDifficult(rec) : false;
    });

  if (miniIndex === 1) return g1.length ? g1 : chapter.newWords;
  if (miniIndex === 2) return [...g2, ...hardFrom(g1)];
  return [...g3, ...hardFrom(g1), ...hardFrom(g2)];
}

export function selectWordsForMiniBoss(
  state: GameState,
  chapterId: number,
  miniIndex: 1 | 2 | 3,
  rng?: () => number,
): SelectedWord[] {
  const chapter = chapterById(chapterId);
  if (!chapter) return [];
  const mini = chapter.miniBosses.find((m) => m.index === miniIndex);
  if (!mini) return [];
  const roll = rng ?? createRng(`${state.readingSessionId}-mini-${chapterId}-${miniIndex}`);
  return selectForFight({
    state,
    chapterId,
    newRatio: mini.newRatio,
    taskCount: mini.taskCount,
    preferredNew: groupForMini(chapterId, miniIndex, state),
    rng: roll,
    allowHardRepeat: true,
  });
}

export function selectWordsForFinalBoss(
  state: GameState,
  chapterId: number,
  rng?: () => number,
): SelectedWord[] {
  const chapter = chapterById(chapterId);
  if (!chapter) return [];
  const roll = rng ?? createRng(`${state.readingSessionId}-boss-${chapterId}`);
  return selectForFight({
    state,
    chapterId,
    newRatio: chapter.bossNewRatio,
    taskCount: chapter.bossTaskCount,
    preferredNew: chapter.newWords,
    rng: roll,
    allowHardRepeat: true,
    keepEasyHits: true,
  });
}

export function selectPrepareWords(state: GameState, chapterId: number, count = 4): ChapterWord[] {
  const pool = getChapterWordPool(state, chapterId);
  const ranked = [...pool.newWords].sort(
    (a, b) =>
      calculateWordPriority(b, state, chapterId) - calculateWordPriority(a, state, chapterId),
  );
  const picked = ranked.slice(0, count);
  if (picked.length < count) {
    for (const w of pool.reviewWords) {
      if (picked.length >= count) break;
      if (!picked.some((p) => p.id === w.id)) picked.push(w);
    }
  }
  return picked;
}

function selectForFight(opts: {
  state: GameState;
  chapterId: number;
  newRatio: number;
  taskCount: number;
  preferredNew: ChapterWord[];
  rng: () => number;
  allowHardRepeat?: boolean;
  keepEasyHits?: boolean;
}): SelectedWord[] {
  const { state, chapterId, newRatio, taskCount, preferredNew, rng } = opts;
  const pool = getChapterWordPool(state, chapterId);
  const newCount = Math.round(taskCount * newRatio);
  const oldCount = Math.max(0, taskCount - newCount);

  const preferred = preferredNew.length ? preferredNew : pool.newWords;
  const newPool = uniqueById([...preferred, ...pool.newWords]);
  const newIds = new Set(pool.newWords.map((w) => w.id));
  const oldPool = pool.reviewWords.filter((w) => !newIds.has(w.id));

  const newPicks = pickUniqueWeighted(newPool, newCount, state, chapterId, rng);
  while (newPicks.length < newCount && newPool.length) {
    const extra = newPool[newPicks.length % newPool.length];
    if (!newPicks.some((w) => w.id === extra.id) || newPicks.length >= newPool.length) {
      newPicks.push(extra);
    } else break;
  }

  let oldPicks = pickUniqueWeighted(
    oldPool,
    oldCount,
    state,
    chapterId,
    rng,
    (w) => ((state.readingRecords[w.id]?.masteryLevel ?? 0) >= 4 ? -20 : 0),
  );

  if (opts.keepEasyHits && oldPicks.length) {
    const mastered = pool.masteredWords.filter((w) => oldPool.some((o) => o.id === w.id));
    if (mastered.length && !oldPicks.some((w) => (state.readingRecords[w.id]?.masteryLevel ?? 0) >= 4)) {
      oldPicks[oldPicks.length - 1] = mastered[0];
    }
  }

  if (oldPicks.length < oldCount) {
    const fillFrom = newPool.filter((w) => !newPicks.some((n) => n.id === w.id));
    while (oldPicks.length < oldCount && fillFrom.length) {
      oldPicks.push(fillFrom[oldPicks.length % fillFrom.length]);
    }
  }

  let seq = interleave(tag(newPicks, 'new', state), tag(oldPicks, 'old', state));

  if (opts.allowHardRepeat) {
    seq = maybeRepeatHardWord(seq, state, chapterId, taskCount);
  }

  seq = capAppearances(seq, 2);
  seq = noConsecutive(seq);
  return seq.slice(0, taskCount);
}

function maybeRepeatHardWord(
  seq: SelectedWord[],
  state: GameState,
  chapterId: number,
  taskCount: number,
): SelectedWord[] {
  if (seq.length >= taskCount) return seq;
  const hard = seq
    .filter((w) => w.origin === 'new' && w.hard)
    .sort(
      (a, b) =>
        calculateWordPriority(b, state, chapterId) - calculateWordPriority(a, state, chapterId),
    )[0];
  if (!hard) return seq;
  const idx = seq.findIndex((w) => w.id === hard.id);
  const insertAt = Math.min(seq.length, idx + 3);
  if (seq.filter((w) => w.id === hard.id).length >= 2) return seq;
  const copy = [...seq];
  copy.splice(insertAt, 0, { ...hard });
  return copy;
}

function capAppearances(seq: SelectedWord[], maxTimes: number): SelectedWord[] {
  const seen: Record<string, number> = {};
  const out: SelectedWord[] = [];
  for (const w of seq) {
    seen[w.id] = (seen[w.id] ?? 0) + 1;
    if (seen[w.id] <= maxTimes) out.push(w);
  }
  return out;
}

function uniqueById(words: ChapterWord[]): ChapterWord[] {
  const map = new Map<string, ChapterWord>();
  for (const w of words) map.set(w.id, w);
  return [...map.values()];
}

export function getDifficultWords(state: GameState, chapterId: number): ChapterWord[] {
  return getChapterWordPool(state, chapterId).difficultWords;
}

export function canUnlockFinalBoss(state: GameState, chapterId: number): BossUnlockResult {
  const chapter = chapterById(chapterId);
  const empty: BossUnlockResult = {
    ok: false,
    reason: 'need_practice',
    practiceWords: [],
    childMessage: 'Давай еще немного потренируем эти слова, и ворота откроются!',
  };
  if (!chapter) return empty;

  const words = chapter.newWords;
  const records = words.map((w) => state.readingRecords[w.id]);
  const seen = records.filter((r) => r && r.successCount > 0).length;
  const seenRatio = words.length === 0 ? 1 : seen / words.length;

  const keyWords = words.filter((w) => w.isKey !== false);
  const keysReady = keyWords.every((w) => (state.readingRecords[w.id]?.successCount ?? 0) >= 2);

  let succ = 0;
  let att = 0;
  for (const w of words) {
    const r = state.readingRecords[w.id];
    if (!r) continue;
    succ += r.successCount;
    att += r.attemptCount;
  }
  const accuracy = att === 0 ? 0 : succ / att;

  const critical = words.filter((w) => {
    const r = state.readingRecords[w.id];
    return r ? isCriticalWord(r) : false;
  });

  const ok = seenRatio >= 0.9 && keysReady && accuracy >= 0.7 && critical.length === 0;
  const practice = (ok ? [] : [...critical, ...keyWords.filter((w) => (state.readingRecords[w.id]?.successCount ?? 0) < 2)])
    .filter((w, i, arr) => arr.findIndex((x) => x.id === w.id) === i)
    .slice(0, 6);

  if (ok) {
    return {
      ok: true,
      reason: 'ready',
      practiceWords: [],
      childMessage: 'Ты почти у цели! Слова готовы к большому приключению.',
    };
  }
  return { ...empty, practiceWords: practice.length ? practice : words.slice(0, 4) };
}

export function getNextWord(input: {
  state: GameState;
  chapterId: number;
  mode: FightMode;
  usedWordIds: string[];
  lastWordId?: string;
  lastWasFail?: boolean;
  sequence?: SelectedWord[];
  index?: number;
}): SelectedWord {
  const { state, chapterId, mode, usedWordIds, lastWordId, lastWasFail, sequence, index } = input;

  if (sequence && typeof index === 'number' && sequence[index]) {
    let next = sequence[index];
    if (lastWordId && next.id === lastWordId && sequence[index + 1]) {
      next = sequence[index + 1];
    }
    return next;
  }

  if (mode === 'intro') {
    const pool = getChapterNewWords(chapterId).filter((w) => w.id !== lastWordId);
    const pick =
      pickUniqueWeighted(pool.length ? pool : getChapterNewWords(chapterId), 1, state, chapterId, createRng(`${state.readingSessionId}-intro-${usedWordIds.length}`))[0] ??
      getChapterNewWords(chapterId)[0];
    return { ...pick, origin: 'new' };
  }

  if (mode === 'prepare') {
    const prep = selectPrepareWords(state, chapterId, 6).filter((w) => w.id !== lastWordId);
    const word = prep[usedWordIds.length % Math.max(1, prep.length)] ?? prep[0];
    return { ...word, origin: 'new', hard: true };
  }

  let seq: SelectedWord[] = [];
  if (mode === 'mini1' || mode === 'mini2' || mode === 'mini3') {
    const n = Number(mode.slice(-1)) as 1 | 2 | 3;
    seq = selectWordsForMiniBoss(state, chapterId, n);
  } else {
    seq = selectWordsForFinalBoss(state, chapterId);
  }

  const unused = seq.filter((w) => !usedWordIds.includes(w.id) || (lastWasFail && w.hard));
  const candidate =
    unused.find((w) => w.id !== lastWordId) ??
    seq.find((w) => w.id !== lastWordId) ??
    seq[0];
  return candidate;
}

export function fightRatios(seq: SelectedWord[]): { newRatio: number; oldRatio: number } {
  const { newCount, oldCount } = countByOrigin(seq);
  const total = Math.max(1, newCount + oldCount);
  return { newRatio: newCount / total, oldRatio: oldCount / total };
}

export function maxRunLength(seq: SelectedWord[]): number {
  let max = 1;
  let run = 1;
  for (let i = 1; i < seq.length; i += 1) {
    if (seq[i].id === seq[i - 1].id) {
      run += 1;
      max = Math.max(max, run);
    } else run = 1;
  }
  return seq.length ? max : 0;
}

export function appearanceCounts(seq: SelectedWord[]): Record<string, number> {
  const c: Record<string, number> = {};
  for (const w of seq) c[w.id] = (c[w.id] ?? 0) + 1;
  return c;
}

export { makeWordId };
