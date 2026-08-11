import { Page } from '../components/Page';
import { useGame } from '../game/store';
import {
  getTodayStats,
  getWeekNewWords,
  skillBreakdown,
} from '../services/readingStatsService';

const WEEKDAY = ['Вс', 'Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб'];

export function StatisticsPage() {
  const { state } = useGame();
  const today = getTodayStats(state);
  const week = getWeekNewWords(state);
  const skills = skillBreakdown(state);
  const success = state.successfulAttempts || state.correct;
  const accuracy =
    state.attempts === 0 ? 100 : Math.round((success / state.attempts) * 100);

  return (
    <Page title="Статистика чтения">
      <div className="stats">
        <div className="card warm stat">
          <div className="value">📚 {state.uniqueWords}</div>
          <div className="muted">выучено слов</div>
        </div>
        <div className="card warm stat">
          <div className="value">🔄 {state.repeatedWords}</div>
          <div className="muted">повторений</div>
        </div>
        <div className="card warm stat">
          <div className="value">🎯 {accuracy}%</div>
          <div className="muted">точность</div>
        </div>
        <div className="card warm stat">
          <div className="value">🎤 {state.attempts}</div>
          <div className="muted">попыток</div>
        </div>
      </div>

      <div className="card stack">
        <strong>Сегодня</strong>
        <p>📖 Новых слов: {today.newWords}</p>
        <p>🔄 Повторений: {today.repeatedWords}</p>
        <p>🎤 Попыток: {today.attempts}</p>
        <p>✅ Успешных чтений: {today.successfulAttempts}</p>
        <p>🎯 Точность: {today.accuracy}%</p>
        <p>
          ⏱ Время чтения: {Math.round(today.durationMs / 60_000)} мин
        </p>
      </div>

      <div className="card stack">
        <strong>Новые слова за неделю</strong>
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
        <p className="muted">
          Успешных чтений всего: {success}. Освоено: {skills.mastered}.
        </p>
        {state.legacyWordsRead ? (
          <p className="muted">
            Прежняя оценка до обновления статистики: {state.legacyWordsRead}{' '}
            (legacy).
          </p>
        ) : null}
      </div>

      <div className="card center">
        {state.uniqueWords === 0
          ? 'Первое выученное слово появится здесь как росток!'
          : `Ты выучил ${state.uniqueWords} слов и потренировался ${success} раз!`}
      </div>
    </Page>
  );
}
