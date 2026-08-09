import { useState } from 'react';
import { Page } from '../components/Page';
import { hashPin, useGame } from '../game/store';

export function ParentsPage() {
  const { state, setState } = useGame();
  const [pin, setPin] = useState('');
  const [unlocked, setUnlocked] = useState(false);
  const [error, setError] = useState('');

  function press(d: string) {
    if (pin.length >= 4) return;
    const next = pin + d;
    setPin(next);
    setError('');
    if (next.length === 4) {
      const hashed = hashPin(next);
      if (!state.parentPin) {
        setState((s) => ({ ...s, parentPin: hashed }));
        setUnlocked(true);
        setPin('');
        return;
      }
      if (hashed === state.parentPin) {
        setUnlocked(true);
        setPin('');
      } else {
        setError('PIN не совпал. Попробуйте ещё раз.');
        setPin('');
      }
    }
  }

  function exportStats() {
    const payload = {
      wordsRead: state.wordsRead,
      correct: state.correct,
      errors: state.errors,
      attempts: state.attempts,
      accuracy: state.attempts === 0 ? 1 : state.correct / state.attempts,
      readingLevel: state.readingLevel,
      level: state.level,
      bossesDefeated: state.bossesDefeated,
      dragonStage: state.dragonStage,
      hardWords: state.hardWords,
      hardLetters: state.hardLetters,
      exportedAt: new Date().toISOString(),
    };
    void navigator.clipboard.writeText(JSON.stringify(payload, null, 2));
    alert('Статистика скопирована в буфер обмена');
  }

  if (!unlocked) {
    return (
      <Page title="Родительский вход">
        <div className="card stack center">
          <div style={{ fontSize: '3.5rem' }}>🔐</div>
          <h2>{state.parentPin ? 'Введите PIN' : 'Создайте PIN'}</h2>
          <p className="muted">
            {state.parentPin
              ? 'Раздел для взрослых'
              : 'Первый вход: придумайте 4 цифры'}
          </p>
          <div className="pin-dots">
            {[0, 1, 2, 3].map((i) => (
              <span key={i} className={`pin-dot ${pin.length > i ? 'on' : ''}`} />
            ))}
          </div>
          {error && <p className="feedback bad">{error}</p>}
          <div className="pad">
            {['1', '2', '3', '4', '5', '6', '7', '8', '9', '⌫', '0', 'C'].map((k) => (
              <button
                key={k}
                type="button"
                onClick={() => {
                  if (k === '⌫') setPin((p) => p.slice(0, -1));
                  else if (k === 'C') setPin('');
                  else press(k);
                }}
              >
                {k}
              </button>
            ))}
          </div>
        </div>
      </Page>
    );
  }

  const total = state.attempts;
  const accuracy = total === 0 ? 100 : Math.round((state.correct / total) * 100);
  const hard = Object.entries(state.hardWords)
    .sort((a, b) => b[1] - a[1])
    .slice(0, 5)
    .map(([w]) => w);
  const hardLetters = Object.entries(state.hardLetters)
    .sort((a, b) => b[1] - a[1])
    .slice(0, 5)
    .map(([l]) => l.toUpperCase());

  return (
    <Page title="Для родителей">
      <div className="stats">
        <div className="card warm stat">
          <div className="value">{state.wordsRead}</div>
          <div className="muted">слов</div>
        </div>
        <div className="card warm stat">
          <div className="value">{accuracy}%</div>
          <div className="muted">успех</div>
        </div>
        <div className="card warm stat">
          <div className="value">{state.attempts}</div>
          <div className="muted">попыток</div>
        </div>
        <div className="card warm stat">
          <div className="value">{state.readingLevel}</div>
          <div className="muted">ур. чтения</div>
        </div>
      </div>
      <div className="card stack">
        <strong>Наблюдение</strong>
        <p>
          Успешных чтений: {state.correct}. Повторных попыток: {state.errors}.
        </p>
        <p>
          {hard.length === 0
            ? 'Сложных слов пока нет — отличный старт!'
            : `Стоит мягко повторить: ${hard.join(', ')}.`}
        </p>
        {hardLetters.length > 0 && (
          <p className="muted">Буквы для тренировки: {hardLetters.join(', ')}</p>
        )}
        <p className="muted">
          Голос ребёнка не сохраняется. Рекламы и покупок нет.
        </p>
      </div>
      <button type="button" className="btn secondary" onClick={exportStats}>
        Экспорт статистики
      </button>
    </Page>
  );
}
