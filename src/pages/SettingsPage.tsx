import { Page } from '../components/Page';
import { initialState, useGame } from '../game/store';

export function SettingsPage() {
  const { setState } = useGame();

  return (
    <Page title="Настройки">
      <div className="card stack">
        <p>
          <strong>Безопасность продукта</strong>
        </p>
        <p className="muted">
          Нет рекламы. Нет покупок. Нет внешних ссылок. Нет всплывающих окон.
        </p>
      </div>
      <div className="card stack">
        <p>
          <strong>Доступность</strong>
        </p>
        <p className="muted">
          Озвучивание работает через кнопку 🔊. Крупный текст уже включён в дизайн для детей 5–9 лет.
        </p>
      </div>
      <button
        type="button"
        className="btn ghost"
        onClick={() => {
          if (confirm('Сбросить весь прогресс?')) {
            setState(() => initialState());
          }
        }}
      >
        Сбросить прогресс
      </button>
    </Page>
  );
}
