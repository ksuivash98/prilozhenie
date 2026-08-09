/**
 * Озвучка через SpeechSynthesis.
 * Для учебных заданий не вызывается до первой попытки ребёнка.
 */
export class SpeechSynthesisService {
  /** Произносит текст на русском. */
  speak(text: string, rate = 0.9): void {
    if (typeof window === 'undefined' || !('speechSynthesis' in window)) return;
    window.speechSynthesis.cancel();
    const u = new SpeechSynthesisUtterance(text);
    u.lang = 'ru-RU';
    u.rate = rate;
    window.speechSynthesis.speak(u);
  }

  /** Останавливает речь. */
  stop(): void {
    if (typeof window === 'undefined' || !('speechSynthesis' in window)) return;
    window.speechSynthesis.cancel();
  }

  isSupported(): boolean {
    return typeof window !== 'undefined' && 'speechSynthesis' in window;
  }
}

export const speechSynthesisService = new SpeechSynthesisService();
