import { useCallback, useEffect, useRef, useState } from 'react';
import { AnimatePresence, motion } from 'framer-motion';
import {
  isSpeechRecognitionSupported,
  speechRecognitionService,
} from '../../services/speechRecognitionService';
import { speechSynthesisService } from '../../services/speechSynthesisService';
import type { ReadingChallengeState } from '../../types/speech';

export interface ReadingSuccessMeta {
  xp: number;
  coins: number;
  isNewWord: boolean;
  message: string;
}

export interface ReadingChallengeProps {
  prompt?: string;
  target: string;
  emoji?: string;
  storyBeat?: string;
  /** После скольких неудач показать «Послушать». */
  helpAfterFails?: number;
  /**
   * Должен применить запись в store и вернуть фактическую награду
   * (0 XP/монет при повторе слова).
   */
  onSuccess: () => ReadingSuccessMeta;
  onFail?: () => void;
  /** Подсказка награды за НОВОЕ слово (фактическая награда приходит из onSuccess). */
  xp?: number;
  coins?: number;
}

const PRAISE = ['🎉 Отлично!', '✨ Супер!', '🌟 Ты молодец!', '🐲 Дракон гордится тобой!'];
const RETRY = [
  '💪 Почти получилось! Попробуй ещё раз.',
  '🌱 Ещё попытка — у тебя получится!',
  '✨ Давай вместе ещё раз!',
];

/**
 * Главный экран чтения: сначала ребёнок читает сам,
 * потом приложение проверяет голос, помощь — только при необходимости.
 */
export function ReadingChallenge({
  prompt = 'Прочитай это слово',
  target,
  emoji,
  storyBeat,
  helpAfterFails = 2,
  onSuccess,
  onFail,
  xp = 10,
  coins = 5,
}: ReadingChallengeProps) {
  const supported = isSpeechRecognitionSupported();
  const [phase, setPhase] = useState<ReadingChallengeState>(
    supported ? 'idle' : 'unsupported',
  );
  const [fails, setFails] = useState(0);
  const [heard, setHeard] = useState('');
  const [message, setMessage] = useState('');
  const [helped, setHelped] = useState(false);
  const [earnedXp, setEarnedXp] = useState(xp);
  const [earnedCoins, setEarnedCoins] = useState(coins);
  const mounted = useRef(true);

  useEffect(() => {
    mounted.current = true;
    return () => {
      mounted.current = false;
      speechRecognitionService.stop();
    };
  }, []);

  useEffect(() => {
    setPhase(supported ? 'idle' : 'unsupported');
    setFails(0);
    setHeard('');
    setMessage('');
    setHelped(false);
  }, [target, supported]);

  const finishSuccess = useCallback(() => {
    const result = onSuccess();
    setPhase('success');
    setEarnedXp(result.xp);
    setEarnedCoins(result.coins);
    setMessage(
      result.isNewWord
        ? result.message || PRAISE[fails % PRAISE.length]
        : result.message || '🔄 Отличное повторение!',
    );
  }, [fails, onSuccess]);

  const startListening = useCallback(async () => {
    if (!supported) {
      setPhase('manual');
      return;
    }

    setPhase('requestingPermission');
    setMessage('Прочитай слово вслух');
    setPhase('listening');

    const result = await speechRecognitionService.listen({ expected: target });
    if (!mounted.current) return;

    setPhase('processing');
    setHeard(result.transcript);

    if (result.error === 'permission_denied') {
      setPhase('error');
      setMessage('Микрофон нужен, чтобы проверить чтение. Можно разрешить в настройках браузера.');
      return;
    }

    if (result.error === 'unsupported') {
      setPhase('unsupported');
      return;
    }

    if (result.isCorrect) {
      finishSuccess();
      return;
    }

    const nextFails = fails + 1;
    setFails(nextFails);
    onFail?.();
    setPhase('retry');
    setMessage(RETRY[nextFails % RETRY.length]);
  }, [fails, finishSuccess, onFail, supported, target]);

  const playHelp = () => {
    setHelped(true);
    setPhase('help');
    speechSynthesisService.speak(target, 0.85);
    setMessage('Послушай, а потом попробуй сам!');
  };

  const showHelp = fails >= helpAfterFails || phase === 'help';

  return (
    <div className="card stack reading-challenge">
      {storyBeat && (
        <p className="center" style={{ color: 'var(--teal)', fontWeight: 800 }}>
          {storyBeat}
        </p>
      )}
      <h3 className="center">{prompt}</h3>

      <div className="reading-box">
        {emoji && (
          <div className="center" style={{ fontSize: '3.5rem', marginBottom: '0.4rem' }}>
            {emoji}
          </div>
        )}
        <div className="reading-word" aria-label={`Слово: ${target}`}>
          {target}
        </div>

        <AnimatePresence mode="wait">
          {phase === 'listening' && (
            <motion.p
              key="listen"
              className="center listening-pulse"
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              exit={{ opacity: 0 }}
            >
              🔴 Я слушаю… Прочитай слово вслух
            </motion.p>
          )}
          {phase === 'processing' && (
            <motion.p key="proc" className="center muted" initial={{ opacity: 0 }} animate={{ opacity: 1 }}>
              Проверяю…
            </motion.p>
          )}
          {phase === 'success' && (
            <motion.div
              key="ok"
              className="center stack"
              initial={{ scale: 0.8, opacity: 0 }}
              animate={{ scale: 1, opacity: 1 }}
            >
              <p className="feedback ok" style={{ fontSize: '1.35rem' }}>
                {message}
              </p>
              <p>
                {earnedXp > 0 || earnedCoins > 0
                  ? 'Ты выучил новое слово!'
                  : 'Ты потренировался — так закрепляется чтение!'}
              </p>
              {(earnedXp > 0 || earnedCoins > 0) && (
                <p className="reward-line">
                  +{earnedXp} ⭐ &nbsp; +{earnedCoins} 🪙
                </p>
              )}
            </motion.div>
          )}
          {(phase === 'retry' || phase === 'help') && (
            <motion.p
              key="retry"
              className="center feedback ok"
              style={{ color: 'var(--coral)' }}
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
            >
              {message}
            </motion.p>
          )}
          {heard && phase === 'retry' && (
            <p className="center muted">Я услышала: «{heard}»</p>
          )}
        </AnimatePresence>

        {phase === 'idle' && (
          <button type="button" className="btn mic-btn" onClick={() => void startListening()}>
            🎤 Я читаю
          </button>
        )}

        {(phase === 'retry' || phase === 'help') && (
          <div className="stack">
            <button type="button" className="btn mic-btn" onClick={() => void startListening()}>
              🎤 Ещё раз
            </button>
            {showHelp && (
              <button type="button" className="btn ghost" onClick={playHelp}>
                🔊 Послушать слово
              </button>
            )}
            {helped && phase === 'help' && (
              <button type="button" className="btn secondary" onClick={() => void startListening()}>
                🎤 Попробуй сам
              </button>
            )}
          </div>
        )}

        {phase === 'unsupported' && (
          <div className="stack center">
            <p className="muted">
              🎤 Голосовая проверка недоступна в этом браузере.
              Лучше всего работает в Chrome или Edge.
            </p>
            <p className="muted">Режим без автоматической проверки:</p>
            <button
              type="button"
              className="btn secondary"
              onClick={() => {
                setPhase('manual');
              }}
            >
              Продолжить без голоса
            </button>
          </div>
        )}

        {phase === 'manual' && (
          <div className="stack center">
            <p className="muted">Режим без голосовой проверки</p>
            <button type="button" className="btn" onClick={finishSuccess}>
              ✓ Я прочитал
            </button>
          </div>
        )}

        {phase === 'error' && (
          <div className="stack">
            <p className="center muted">{message}</p>
            <button type="button" className="btn mic-btn" onClick={() => void startListening()}>
              🎤 Попробовать снова
            </button>
            <button type="button" className="btn ghost" onClick={() => setPhase('manual')}>
              ✓ Режим без голоса
            </button>
          </div>
        )}

        {phase === 'listening' && (
          <button
            type="button"
            className="btn ghost"
            onClick={() => {
              speechRecognitionService.stop();
              setPhase('idle');
            }}
          >
            Отмена
          </button>
        )}
      </div>
    </div>
  );
}
