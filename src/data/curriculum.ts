import type { ReadingUnit } from '../types/speech';

/** Учебная лестница: буква → слог → слово → предложение. */
export const CURRICULUM: ReadingUnit[] = [
  // Уровень 1 — буквы
  { id: 'l1_a', kind: 'letter', text: 'А', emoji: '🅰️', level: 1, xp: 8, coins: 3 },
  { id: 'l1_o', kind: 'letter', text: 'О', emoji: '🟠', level: 1, xp: 8, coins: 3 },
  { id: 'l1_m', kind: 'letter', text: 'М', emoji: 'Ⓜ️', level: 1, xp: 8, coins: 3 },
  { id: 'l1_s', kind: 'letter', text: 'С', emoji: '✨', level: 1, xp: 8, coins: 3 },
  { id: 'l1_r', kind: 'letter', text: 'Р', emoji: '🚗', level: 1, xp: 8, coins: 3 },
  // Уровень 2 — слоги
  { id: 'l2_ma', kind: 'syllable', text: 'МА', emoji: '🎵', level: 2, xp: 10, coins: 4 },
  { id: 'l2_mo', kind: 'syllable', text: 'МО', emoji: '🎵', level: 2, xp: 10, coins: 4 },
  { id: 'l2_sa', kind: 'syllable', text: 'СА', emoji: '🎵', level: 2, xp: 10, coins: 4 },
  { id: 'l2_so', kind: 'syllable', text: 'СО', emoji: '🎵', level: 2, xp: 10, coins: 4 },
  // Уровень 3 — короткие слова
  { id: 'l3_mama', kind: 'word', text: 'МАМА', emoji: '👩', level: 3, xp: 12, coins: 5 },
  { id: 'l3_kot', kind: 'word', text: 'КОТ', emoji: '🐱', level: 3, xp: 12, coins: 5 },
  { id: 'l3_dom', kind: 'word', text: 'ДОМ', emoji: '🏠', level: 3, xp: 12, coins: 5 },
  { id: 'l3_som', kind: 'word', text: 'СОМ', emoji: '🐟', level: 3, xp: 12, coins: 5 },
  // Уровень 4 — длинные слова
  { id: 'l4_mashina', kind: 'word', text: 'МАШИНА', emoji: '🚗', level: 4, xp: 16, coins: 7 },
  { id: 'l4_korova', kind: 'word', text: 'КОРОВА', emoji: '🐮', level: 4, xp: 16, coins: 7 },
  { id: 'l4_samolet', kind: 'word', text: 'САМОЛЕТ', emoji: '✈️', level: 4, xp: 16, coins: 7 },
  // Уровень 5 — предложения
  { id: 'l5_sent', kind: 'sentence', text: 'МАМА ИДЕТ ДОМОЙ', emoji: '🏡', level: 5, xp: 22, coins: 10 },
];

export function unitsForLevel(level: number): ReadingUnit[] {
  return CURRICULUM.filter((u) => u.level === level);
}

export function nextCurriculumUnit(
  completedIds: string[],
  readingLevel: number,
): ReadingUnit | null {
  const pool = CURRICULUM.filter((u) => u.level <= readingLevel);
  return pool.find((u) => !completedIds.includes(u.id)) ?? null;
}

export const KIND_LABEL: Record<ReadingUnit['kind'], string> = {
  letter: 'Буква',
  syllable: 'Слог',
  word: 'Слово',
  sentence: 'Предложение',
  story: 'Рассказ',
};
