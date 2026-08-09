import { describe, expect, it } from 'vitest';
import {
  collapseRepeats,
  isSpeechMatch,
  normalizeSpeech,
  similarity,
} from './fuzzyMatch';

describe('normalizeSpeech', () => {
  it('нижний регистр и ё→е', () => {
    expect(normalizeSpeech('  КЁТ! ')).toBe('кет');
  });

  it('убирает пунктуацию', () => {
    expect(normalizeSpeech('мама, дом.')).toBe('мама дом');
  });
});

describe('collapseRepeats', () => {
  it('убирает повторы слова', () => {
    expect(collapseRepeats('кот кот')).toBe('кот');
  });
});

describe('isSpeechMatch', () => {
  it('точное совпадение', () => {
    expect(isSpeechMatch('кот', 'кот').isCorrect).toBe(true);
  });

  it('повтор слова — успех', () => {
    expect(isSpeechMatch('кот кот', 'кот').isCorrect).toBe(true);
  });

  it('совсем другое слово — неудача', () => {
    expect(isSpeechMatch('дом', 'кот').isCorrect).toBe(false);
  });

  it('близкое распознавание длинного слова', () => {
    const r = isSpeechMatch('машина', 'машина');
    expect(r.isCorrect).toBe(true);
    expect(r.similarity).toBe(1);
  });
});

describe('similarity', () => {
  it('одинаковые строки = 1', () => {
    expect(similarity('мама', 'мама')).toBe(1);
  });

  it('разные строки < 1', () => {
    expect(similarity('мама', 'папа')).toBeLessThan(1);
  });
});
