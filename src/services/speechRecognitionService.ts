import type { SpeechErrorCode, SpeechRecognitionResult } from '../types/speech';
import { isSpeechMatch, normalizeSpeech } from './fuzzyMatch';

type BrowserSpeechRecognition = SpeechRecognition;

interface ListenOptions {
  expected: string;
  lang?: string;
  timeoutMs?: number;
}

function getRecognitionCtor(): (new () => BrowserSpeechRecognition) | null {
  if (typeof window === 'undefined') return null;
  const w = window as Window & {
    SpeechRecognition?: new () => BrowserSpeechRecognition;
    webkitSpeechRecognition?: new () => BrowserSpeechRecognition;
  };
  return w.SpeechRecognition ?? w.webkitSpeechRecognition ?? null;
}

/** Поддерживает ли браузер Web Speech Recognition. */
export function isSpeechRecognitionSupported(): boolean {
  return getRecognitionCtor() !== null;
}

/**
 * Сервис распознавания речи для проверки чтения вслух.
 * Не сохраняет и не отправляет аудио — только transcript в браузере.
 */
export class SpeechRecognitionService {
  private recognition: BrowserSpeechRecognition | null = null;
  private active = false;

  /** Доступно ли распознавание. */
  isSupported(): boolean {
    return isSpeechRecognitionSupported();
  }

  /**
   * Слушает речь ребёнка и сравнивает с expected.
   * Запускать только после жеста пользователя (клик).
   */
  async listen(options: ListenOptions): Promise<SpeechRecognitionResult> {
    const Ctor = getRecognitionCtor();
    const started = Date.now();

    if (!Ctor) {
      return {
        transcript: '',
        confidence: 0,
        isCorrect: false,
        error: 'unsupported',
        duration: 0,
        similarity: 0,
      };
    }

    this.stop();

    return new Promise((resolve) => {
      const recognition = new Ctor();
      this.recognition = recognition;
      this.active = true;

      recognition.lang = options.lang ?? 'ru-RU';
      recognition.interimResults = false;
      recognition.maxAlternatives = 3;
      recognition.continuous = false;

      let settled = false;
      const timeoutMs = options.timeoutMs ?? 8000;

      const finish = (result: SpeechRecognitionResult) => {
        if (settled) return;
        settled = true;
        this.active = false;
        try {
          recognition.stop();
        } catch {
          /* ignore */
        }
        resolve(result);
      };

      const timer = window.setTimeout(() => {
        finish({
          transcript: '',
          confidence: 0,
          isCorrect: false,
          error: 'timeout',
          duration: Date.now() - started,
          similarity: 0,
        });
      }, timeoutMs);

      recognition.onresult = (event: SpeechRecognitionEvent) => {
        window.clearTimeout(timer);
        const alt = event.results[0]?.[0];
        const transcript = alt?.transcript ?? '';
        const confidence = alt?.confidence ?? 0.5;
        const match = isSpeechMatch(transcript, options.expected);

        finish({
          transcript: normalizeSpeech(transcript),
          confidence,
          isCorrect: match.isCorrect,
          error: transcript.trim() ? null : 'no_speech',
          duration: Date.now() - started,
          similarity: match.similarity,
        });
      };

      recognition.onerror = (event: SpeechRecognitionErrorEvent) => {
        window.clearTimeout(timer);
        const map: Record<string, SpeechErrorCode> = {
          'not-allowed': 'permission_denied',
          'service-not-allowed': 'permission_denied',
          'audio-capture': 'unavailable',
          'no-speech': 'no_speech',
          network: 'network',
          aborted: 'aborted',
        };
        finish({
          transcript: '',
          confidence: 0,
          isCorrect: false,
          error: map[event.error] ?? 'unknown',
          duration: Date.now() - started,
          similarity: 0,
        });
      };

      recognition.onend = () => {
        if (!settled) {
          window.clearTimeout(timer);
          finish({
            transcript: '',
            confidence: 0,
            isCorrect: false,
            error: 'no_speech',
            duration: Date.now() - started,
            similarity: 0,
          });
        }
      };

      try {
        recognition.start();
      } catch {
        window.clearTimeout(timer);
        finish({
          transcript: '',
          confidence: 0,
          isCorrect: false,
          error: 'unavailable',
          duration: Date.now() - started,
          similarity: 0,
        });
      }
    });
  }

  /** Останавливает текущее прослушивание. */
  stop(): void {
    if (!this.recognition) return;
    try {
      this.recognition.onresult = null;
      this.recognition.onerror = null;
      this.recognition.onend = null;
      this.recognition.abort();
    } catch {
      /* ignore */
    }
    this.recognition = null;
    this.active = false;
  }

  /** Идёт ли сейчас запись. */
  isListening(): boolean {
    return this.active;
  }
}

export const speechRecognitionService = new SpeechRecognitionService();
