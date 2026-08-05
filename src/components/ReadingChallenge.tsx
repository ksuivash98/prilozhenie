import { useState, type FormEvent } from 'react';
import { normalize, useGame } from '../game/store';

interface ReadingChallengeProps {
  prompt: string;
  target: string;
  storyBeat?: string;
  onSuccess: () => void;
  onFail?: () => void;
}

export function ReadingChallenge({
  prompt,
  target,
  storyBeat,
  onSuccess,
  onFail,
}: ReadingChallengeProps) {
  const { speak } = useGame();
  const [value, setValue] = useState('');
  const [feedback, setFeedback] = useState<string | null>(null);
  const [ok, setOk] = useState<boolean | null>(null);

  function submit(e?: FormEvent) {
    e?.preventDefault();
    const match = normalize(value) === normalize(target);
    if (match) {
      setOk(true);
      setFeedback('Отлично! Сила слова вернулась в мир!');
      speak('Ура!');
      onSuccess();
      setValue('');
    } else {
      setOk(false);
      setFeedback('Попробуй ещё раз — у тебя получится!');
      onFail?.();
    }
  }

  return (
    <div className="card stack">
      {storyBeat && (
        <p className="center" style={{ color: 'var(--teal)', fontWeight: 800 }}>
          {storyBeat}
        </p>
      )}
      <h3 className="center">{prompt}</h3>
      <div className="reading-box">
        <p className="muted">Прочитай вслух или введи слово</p>
        <div className="reading-word">{target}</div>
        <form className="stack" onSubmit={submit}>
          <div className="row">
            <button
              type="button"
              className="btn ghost"
              onClick={() => speak(target)}
              aria-label="Прослушать"
            >
              🔊
            </button>
            <input
              className="input grow"
              value={value}
              onChange={(e) => setValue(e.target.value)}
              placeholder="Введи слово"
              autoComplete="off"
              autoCapitalize="off"
            />
          </div>
          <button type="submit" className="btn">
            Готово!
          </button>
        </form>
      </div>
      {feedback && (
        <p className={`center feedback ${ok ? 'ok' : 'bad'}`}>{feedback}</p>
      )}
    </div>
  );
}
