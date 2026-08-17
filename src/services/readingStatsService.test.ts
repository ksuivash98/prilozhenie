import { describe, expect, it } from 'vitest';
import { initialState } from '../game/store';
import { getReward } from './rewardService';
import {
  makeWordId,
  migrateReadingStats,
  recordFailedReading,
  recordSuccessfulReading,
} from './readingStatsService';

describe('readingStatsService', () => {
  it('тест 1: одно успешное чтение → uniqueWords = 1', () => {
    const r = recordSuccessfulReading(initialState(), 'КОТ');
    expect(r.state.uniqueWords).toBe(1);
    expect(r.state.wordsRead).toBe(1);
    expect(r.isNewWord).toBe(true);
    expect(r.reward.xp).toBeGreaterThan(0);
  });

  it('тест 2: три успеха одного слова → uniqueWords = 1', () => {
    let s = initialState();
    s = recordSuccessfulReading(s, 'КОТ').state;
    s = recordSuccessfulReading(s, 'КОТ').state;
    s = recordSuccessfulReading(s, 'КОТ').state;
    expect(s.uniqueWords).toBe(1);
    expect(s.wordsRead).toBe(1);
    expect(s.successfulAttempts).toBe(3);
    expect(s.repeatedWords).toBe(2);
    expect(s.readingRecords[makeWordId('КОТ')].successCount).toBe(3);
  });

  it('тест 3: три разных слова → uniqueWords = 3', () => {
    let s = initialState();
    s = recordSuccessfulReading(s, 'КОТ').state;
    s = recordSuccessfulReading(s, 'ДОМ').state;
    s = recordSuccessfulReading(s, 'МАМА').state;
    expect(s.uniqueWords).toBe(3);
  });

  it('тест 4: два fail + success → attempts=3, successful=1, unique=1', () => {
    let s = initialState();
    s = recordFailedReading(s, 'КОТ');
    s = recordFailedReading(s, 'КОТ');
    s = recordSuccessfulReading(s, 'КОТ').state;
    expect(s.attempts).toBe(3);
    expect(s.successfulAttempts).toBe(1);
    expect(s.uniqueWords).toBe(1);
  });

  it('тест 5: КОТ×2 + ДОМ → unique=2, successful=3', () => {
    let s = initialState();
    s = recordSuccessfulReading(s, 'КОТ').state;
    s = recordSuccessfulReading(s, 'КОТ').state;
    s = recordSuccessfulReading(s, 'ДОМ').state;
    expect(s.uniqueWords).toBe(2);
    expect(s.successfulAttempts).toBe(3);
  });

  it('тест 6: повтор не начисляет NEW_WORD награду', () => {
    const first = recordSuccessfulReading(initialState(), 'КОТ', {
      newWordReward: { xp: 10, coins: 5 },
    });
    expect(first.reward).toEqual({ xp: 10, coins: 5, crystals: 0 });
    expect(first.state.xp).toBe(10);
    expect(first.state.coins).toBe(5);

    const second = recordSuccessfulReading(first.state, 'КОТ', {
      newWordReward: { xp: 10, coins: 5 },
    });
    expect(second.isNewWord).toBe(false);
    expect(second.reward).toEqual(getReward('REPEATED_WORD'));
    expect(second.state.xp).toBe(10);
    expect(second.state.coins).toBe(5);
    expect(second.state.uniqueWords).toBe(1);
  });

  it('10 повторов подряд не делают слово mastered', () => {
    let s = initialState();
    for (let i = 0; i < 10; i += 1) {
      s = recordSuccessfulReading(s, 'КОТ').state;
    }
    const rec = s.readingRecords[makeWordId('КОТ')];
    expect(rec.successCount).toBe(10);
    expect(rec.isMastered).toBe(false);
    expect(rec.masteryLevel).toBeLessThan(4);
    expect(rec.successfulSessionIds).toHaveLength(1);
    expect(s.uniqueWords).toBe(1);
  });

  it('стабильный wordId', () => {
    expect(makeWordId('КОТ')).toBe(makeWordId('кот'));
    expect(makeWordId('КОТ')).toBe('word_кот');
  });

  it('миграция legacy не выдумывает уникальные слова', () => {
    const migrated = migrateReadingStats({
      wordsRead: 120,
      correct: 200,
      attempts: 250,
    });
    expect(migrated.statisticsVersion).toBe(3);
    expect(migrated.legacyWordsRead).toBe(120);
    expect(migrated.uniqueWords).toBe(0);
    expect(migrated.wordsRead).toBe(0);
    expect(migrated.successfulAttempts).toBe(200);
  });
});
