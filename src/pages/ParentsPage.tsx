import { useState } from 'react';
import { Page } from '../components/Page';
import { hashPin, useGame } from '../game/store';
import {
  getTodayStats,
  getWeekNewWords,
  skillBreakdown,
} from '../services/readingStatsService';

const WEEKDAY = ['Вс', 'Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб'];

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
    const today = getTodayStats(state);
    const payload = {
      uniqueWords: state.uniqueWords,
      wordsRead: state.wordsRead,
      successfulAttempts: state.successfulAttempts || state.correct,
      repeatedWords: state.repeatedWords,
      masteredWords: state.masteredWords,
      attempts: state.attempts,
      errors: state.errors,
      accuracy:
        state.attempts === 0
          ? 1
          : (state.successfulAttempts || state.correct) / state.attempts,
      today,
      week: getWeekNewWords(state),
      skills: skillBreakdown(state),
      readingLevel: state.readingLevel,
      level: state.level,
      bossesDefeated: state.bossesDefeated,
      dragonStage: state.dragonStage,
      hardWords: state.hardWords,
      hardLetters: state.hardLetters,
      legacyWordsRead: state.legacyWordsRead,
      statisticsVersion: state.statisticsVersion,
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

  const today = getTodayStats(state);
  const week = getWeekNewWords(state);
  const skills = skillBreakdown(state);
  const success = state.successfulAttempts || state.correct;
  const accuracy =
    state.attempts === 0 ? 100 : Math.round((success / state.attempts) * 100);
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
      <div className="card stack">
        <strong>Сегодня</strong>
        <p>Новых слов: {today.newWords}</p>
        <p>Повторений: {today.repeatedWords}</p>
        <p>Попыток: {today.attempts}</p>
        <p>Успешных чтений: {today.successfulAttempts}</p>
        <p>Точность: {today.accuracy}%</p>
        <p>
          Время: {Math.max(0, Math.round(today.durationMs / 60_000))} минут
        </p>
      </div>

      <div className="stats">
        <div className="card warm stat">
          <div className="value">{state.uniqueWords}</div>
          <div className="muted">уникальных</div>
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
        <strong>Навыки</strong>
        <p>Освоено: {skills.mastered} слов</p>
        <p>Изучается: {skills.learning} слова</p>
        <p>Требуют практики: {skills.needsPractice} слов</p>
      </div>

      <div className="card stack">
        <strong>Неделя · новые слова</strong>
        <div className="row" style={{ flexWrap: 'wrap', gap: '0.5rem' }}>
          {week.map((d) => {
            const day = WEEKDAY[new Date(d.date + 'T12:00:00').getDay()];
            return (
              <div key={d.date} className="card warm center" style={{ minWidth: 52, padding: '0.5rem' }}>
                <div className="muted">{day}</div>
                <strong>{d.newWords}</strong>
              </div>
            );
          })}
        </div>
      </div>

      <div className="card stack">
        <strong>Наблюдение</strong>
        <p>
          Успешных чтений: {success}. Ошибок: {state.errors}. Повторений:{' '}
          {state.repeatedWords}.
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
