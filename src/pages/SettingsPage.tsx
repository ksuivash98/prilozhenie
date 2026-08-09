import { Page } from '../components/Page';
import { useGame } from '../game/store';

export function SettingsPage() {
  const { state, setState } = useGame();

  return (
    <Page title="Настройки">
      <div className="card stack">
        <p>
          <strong>Безопасность</strong>
        </p>
        <p className="muted">
          Нет рекламы. Нет покупок. Голос не записывается и не отправляется на сервер.
        </p>
      </div>

      <div className="card stack">
        <p>
          <strong>Звук и доступность</strong>
        </p>
        <label className="row">
          <input
            type="checkbox"
            checked={state.soundEnabled}
            onChange={(e) => setState((s) => ({ ...s, soundEnabled: e.target.checked }))}
          />
          Звук озвучки
        </label>
        <label className="row">
          <input
            type="checkbox"
            checked={state.largeText}
            onChange={(e) => setState((s) => ({ ...s, largeText: e.target.checked }))}
          />
          Крупный текст
        </label>
        <label className="row">
          <input
            type="checkbox"
            checked={state.highContrast}
            onChange={(e) => setState((s) => ({ ...s, highContrast: e.target.checked }))}
          />
          Высокий контраст
        </label>
        <label className="row">
          <input
            type="checkbox"
            checked={state.reduceMotion}
            onChange={(e) => setState((s) => ({ ...s, reduceMotion: e.target.checked }))}
          />
          Меньше анимаций
        </label>
      </div>
    </Page>
  );
}
