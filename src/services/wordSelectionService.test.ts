import { describe, expect, it } from 'vitest';
import { initialState } from '../game/store';
import type { GameState } from '../game/data';
import { makeWordId } from './wordId';
import {
  recordFailedReading,
  recordSuccessfulReading,
} from './readingStatsService';
import {
  appearanceCounts,
  calculateWordPriority,
  canUnlockFinalBoss,
  fightRatios,
  getChapterNewWords,
  maxRunLength,
  selectWordsForFinalBoss,
  selectWordsForMiniBoss,
} from './wordSelectionService';

function succeed(state: GameState, word: string, times = 1, sessionPrefix?: string): GameState {
  let s = state;
  for (let i = 0; i < times; i += 1) {
    if (sessionPrefix) {
      s = { ...s, readingSessionId: `${sessionPrefix}_${i}`, lastSessionAt: Date.now() };
    }
    s = recordSuccessfulReading(s, word).state;
  }
  return s;
}

function fail(state: GameState, word: string, times = 1): GameState {
  let s = state;
  for (let i = 0; i < times; i += 1) s = recordFailedReading(s, word);
  return s;
}

function masterWord(state: GameState, word: string): GameState {
  return succeed(state, word, 3, `master_${word}`);
}

describe('WordSelectionService', () => {
  it('4. повтор одного слова не увеличивает uniqueWords', () => {
    let s = initialState();
    s = succeed(s, 'КОТ', 5);
    expect(s.uniqueWords).toBe(1);
    expect(s.successfulAttempts).toBe(5);
    expect(s.repeatedWords).toBe(4);
  });

  it('5 и 16. сложные и ошибочные слова получают больший приоритет', () => {
    let s = initialState();
    s = fail(s, 'ДЕРЕВО', 3);
    s = succeed(s, 'ДЕРЕВО', 1);
    s = masterWord(s, 'КОТ');
    const hard = calculateWordPriority(
      { id: makeWordId('ДЕРЕВО'), text: 'ДЕРЕВО', chapterId: 3 },
      s,
      3,
    );
    const easy = calculateWordPriority(
      { id: makeWordId('КОТ'), text: 'КОТ', chapterId: 1 },
      s,
      3,
    );
    expect(hard).toBeGreaterThan(easy);
  });

  it('6. старые слова возвращаются в новой главе', () => {
    const seq = selectWordsForFinalBoss(initialState(), 3);
    const oldIds = new Set(seq.filter((w) => w.origin === 'old').map((w) => w.id));
    expect(oldIds.size).toBeGreaterThan(0);
    expect([...oldIds].some((id) => getChapterNewWords(1).some((w) => w.id === id))).toBe(true);
  });

  it('7. новые слова главы имеют больший вес', () => {
    const now = Date.now();
    let s = initialState();
    const fresh = {
      id: makeWordId('ГРИБ'),
      text: 'ГРИБ',
      chapterId: 3,
    };
    const old = {
      id: makeWordId('КОТ'),
      text: 'КОТ',
      chapterId: 1,
    };
    s = succeed(s, 'КОТ', 3, 'old');
    const newScore = calculateWordPriority(fresh, s, 3, now);
    const oldScore = calculateWordPriority(old, s, 3, now);
    expect(newScore).toBeGreaterThan(oldScore);
  });

  it('8. предбосс №1 использует 80/20', () => {
    const seq = selectWordsForMiniBoss(initialState(), 3, 1);
    const { newRatio } = fightRatios(seq);
    expect(seq).toHaveLength(10);
    expect(newRatio).toBeCloseTo(0.8, 5);
  });

  it('9. предбосс №2 использует 75/25', () => {
    const seq = selectWordsForMiniBoss(initialState(), 3, 2);
    const { newRatio } = fightRatios(seq);
    expect(seq).toHaveLength(8);
    expect(newRatio).toBeCloseTo(0.75, 5);
  });

  it('10. предбосс №3 использует 70/30', () => {
    const seq = selectWordsForMiniBoss(initialState(), 3, 3);
    const { newRatio } = fightRatios(seq);
    expect(seq).toHaveLength(10);
    expect(newRatio).toBeCloseTo(0.7, 5);
  });

  it('11. главный босс использует примерно 65–70% новых', () => {
    const seq = selectWordsForFinalBoss(initialState(), 3);
    const { newRatio } = fightRatios(seq);
    expect(seq).toHaveLength(10);
    expect(newRatio).toBeGreaterThanOrEqual(0.65);
    expect(newRatio).toBeLessThanOrEqual(0.7);
  });

  it('12. одно слово не появляется подряд', () => {
    const seq = selectWordsForMiniBoss(initialState(), 3, 1);
    expect(maxRunLength(seq)).toBeLessThanOrEqual(1);
  });

  it('13. одно слово не появляется слишком много раз за бой', () => {
    const seq = selectWordsForFinalBoss(initialState(), 3);
    const counts = appearanceCounts(seq);
    expect(Math.max(...Object.values(counts))).toBeLessThanOrEqual(2);
  });

  it('14. главный босс недоступен при слабом освоении', () => {
    let s = initialState();
    s = succeed(s, 'ЛЕС', 1);
    const unlock = canUnlockFinalBoss(s, 3);
    expect(unlock.ok).toBe(false);
    expect(unlock.childMessage).not.toMatch(/accuracy|mastery/i);
    expect(unlock.childMessage).toContain('потренируем');
  });

  it('15. главный босс доступен после условий', () => {
    let s = initialState();
    for (const w of getChapterNewWords(3)) {
      s = succeed(s, w.text, 2, `ok_${w.id}`);
    }
    const unlock = canUnlockFinalBoss(s, 3);
    expect(unlock.ok).toBe(true);
  });

  it('17. освоенные слова появляются реже (ниже приоритет)', () => {
    let s = initialState();
    s = masterWord(s, 'МАМА');
    s = succeed(s, 'СОН', 1);
    const mastered = calculateWordPriority(
      { id: makeWordId('МАМА'), text: 'МАМА', chapterId: 1 },
      s,
      3,
    );
    const learning = calculateWordPriority(
      { id: makeWordId('СОН'), text: 'СОН', chapterId: 1 },
      s,
      3,
    );
    expect(mastered).toBeLessThan(learning);
  });

  it('18. слово не mastered после 10 повторов в одной сессии', () => {
    let s = initialState();
    s = { ...s, readingSessionId: 'one', lastSessionAt: Date.now() };
    s = succeed(s, 'КОТ', 10);
    const rec = s.readingRecords[makeWordId('КОТ')];
    expect(rec.successCount).toBe(10);
    expect(rec.successfulSessionIds).toHaveLength(1);
    expect(rec.masteryLevel).toBeLessThan(4);
    expect(rec.isMastered).toBe(false);
  });
});
