import { Page } from '../components/Page';
import { Meter } from '../components/Meter';
import { unlockProgressWords, useGame } from '../game/store';

const BUILDINGS = [
  { id: 'house', name: 'Дом', emoji: '🏠', need: 0, feature: 'Отдых дракона' },
  { id: 'park', name: 'Парк', emoji: '🏞️', need: 30, feature: 'Мини-игры' },
  { id: 'library', name: 'Библиотека', emoji: '📚', need: 80, feature: 'Рассказы' },
  { id: 'tower', name: 'Башня', emoji: '🗼', need: 150, feature: 'Сложные слова' },
  { id: 'fountain', name: 'Фонтан', emoji: '⛲', need: 220, feature: 'Ускорение мира' },
  { id: 'school', name: 'Школа', emoji: '🏫', need: 300, feature: 'Уроки с Луми' },
  { id: 'port', name: 'Порт', emoji: '⚓', need: 400, feature: 'Морские квесты' },
  { id: 'castle', name: 'Замок', emoji: '🏰', need: 600, feature: 'Финальные главы' },
];

export function CityPage() {
  const { state } = useGame();
  const progress = unlockProgressWords(state);
  const unlocked = BUILDINGS.filter((b) => progress >= b.need).length;

  return (
    <Page title="Твой город">
      <div className="card warm stack">
        <Meter
          label="Красота города"
          value={unlocked / BUILDINGS.length}
          trailing={`${unlocked}/${BUILDINGS.length}`}
        />
        <p className="muted">
          Здания открываются за выученные слова. Выучено: {state.uniqueWords}.
        </p>
      </div>
      <div className="grid hub">
        {BUILDINGS.map((b) => {
          const open = progress >= b.need;
          return (
            <div
              key={b.id}
              className="hub-tile"
              style={{ background: open ? '#7cb342' : '#90a4ae' }}
            >
              <span className="emoji">{open ? b.emoji : '🔒'}</span>
              <span>{b.name}</span>
              <small>{open ? b.feature : `${b.need} слов`}</small>
            </div>
          );
        })}
      </div>
    </Page>
  );
}
