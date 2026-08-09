/** Результат распознавания и проверки чтения. */
export interface SpeechRecognitionResult {
  transcript: string;
  confidence: number;
  isCorrect: boolean;
  error: SpeechErrorCode | null;
  duration: number;
  similarity: number;
}

export type SpeechErrorCode =
  | 'unsupported'
  | 'permission_denied'
  | 'unavailable'
  | 'timeout'
  | 'no_speech'
  | 'network'
  | 'aborted'
  | 'unknown';

export type ReadingChallengeState =
  | 'idle'
  | 'requestingPermission'
  | 'listening'
  | 'processing'
  | 'success'
  | 'retry'
  | 'help'
  | 'unsupported'
  | 'manual'
  | 'error';

export type ReadingUnitKind =
  | 'letter'
  | 'syllable'
  | 'word'
  | 'sentence'
  | 'story';

export interface ReadingUnit {
  id: string;
  kind: ReadingUnitKind;
  text: string;
  emoji?: string;
  imageHint?: string;
  level: number;
  xp: number;
  coins: number;
}
