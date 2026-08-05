import { Page } from '../components/Page';
import { useGame } from '../game/store';

export function StatisticsPage() {
  const { state } = useGame();
  const total = state.correct + state.errors;
  const accuracy = total === 0 ? 100 : Math.round((state.correct / total) * 100);

  return (
    <Page title="Статистика чтения">
      <div className="stats">
        <div className="card warm stat">
          <div className="value">📚 {state.wordsRead}</div>
          <div className="muted">слов всего</div>
        </div>
        <div className="card warm stat">
          <div className="value">🎯 {accuracy}%</div>
          <div className="muted">точность</div>
        </div>
        <div className="card warm stat">
          <div className="value">⭐ {state.level}</div>
          <div className="muted">уровень</div>
        </div>
        <div className="card warm stat">
          <div className="value">🗺️ {state.unlockedLocations.length}</div>
          <div className="muted">локаций</div>
        </div>
      </div>
      <div className="card center">
        {state.wordsRead === 0
          ? 'Первое прочитанное слово появится здесь как росток!'
          : 'Читай в своём темпе — ошибки помогают Луми выбрать следующее упражнение.'}
      </div>
    </Page>
  );
}
