/**
 * Нормализация и fuzzy-сравнение распознанной речи с ожидаемым словом.
 * Не требует идеального совпадения — учитывает повторы и мелкие ошибки STT.
 */

export function normalizeSpeech(text: string): string {
  return text
    .trim()
    .toLowerCase()
    .replace(/ё/g, 'е')
    .replace(/[^\p{L}\p{N}\s]/gu, ' ')
    .replace(/\s+/g, ' ')
    .trim();
}

/** Убирает повторы подряд: "кот кот" → "кот". */
export function collapseRepeats(text: string): string {
  const parts = text.split(' ').filter(Boolean);
  const out: string[] = [];
  for (const p of parts) {
    if (out[out.length - 1] !== p) out.push(p);
  }
  return out.join(' ');
}

function levenshtein(a: string, b: string): number {
  const m = a.length;
  const n = b.length;
  const dp: number[][] = Array.from({ length: m + 1 }, () =>
    Array.from({ length: n + 1 }, () => 0),
  );
  for (let i = 0; i <= m; i += 1) dp[i][0] = i;
  for (let j = 0; j <= n; j += 1) dp[0][j] = j;
  for (let i = 1; i <= m; i += 1) {
    for (let j = 1; j <= n; j += 1) {
      const cost = a[i - 1] === b[j - 1] ? 0 : 1;
      dp[i][j] = Math.min(
        dp[i - 1][j] + 1,
        dp[i][j - 1] + 1,
        dp[i - 1][j - 1] + cost,
      );
    }
  }
  return dp[m][n];
}

/** Сходство 0..1 (1 = полное совпадение). */
export function similarity(a: string, b: string): number {
  if (!a && !b) return 1;
  if (!a || !b) return 0;
  const dist = levenshtein(a, b);
  const maxLen = Math.max(a.length, b.length);
  return 1 - dist / maxLen;
}

/**
 * Проверяет, достаточно ли близко распознанный текст к ожидаемому.
 * "кот кот" и небольшие ошибки STT считаются успехом.
 */
export function isSpeechMatch(transcript: string, expected: string): {
  isCorrect: boolean;
  similarity: number;
  normalized: string;
} {
  const expectedN = normalizeSpeech(expected);
  let got = collapseRepeats(normalizeSpeech(transcript));

  if (!got) {
    return { isCorrect: false, similarity: 0, normalized: got };
  }

  // Если ребёнок сказал фразу, ищем целевое слово внутри
  if (got.includes(expectedN) || expectedN.includes(got)) {
    return { isCorrect: true, similarity: 1, normalized: got };
  }

  const tokens = got.split(' ');
  let best = similarity(got, expectedN);
  for (const token of tokens) {
    best = Math.max(best, similarity(token, expectedN));
  }

  // Порог мягче для коротких слов (буквы/слоги)
  const threshold = expectedN.length <= 2 ? 0.99 : expectedN.length <= 4 ? 0.75 : 0.7;

  return {
    isCorrect: best >= threshold,
    similarity: best,
    normalized: got,
  };
}
