import { useNavigate } from 'react-router-dom';
import { Page } from '../components/Page';
import { LOCATIONS } from '../game/data';
import { useGame } from '../game/store';

export function AdventurePage() {
  const { state } = useGame();
  const navigate = useNavigate();

  return (
    <Page title="Карта приключений">
      <div className="card center">
        Мир жив на {Math.round(state.vitality * 100)}%. Читай, чтобы открыть новые дороги!
      </div>
      <div className="map">
        {LOCATIONS.map((loc) => {
          const unlocked = state.unlockedLocations.includes(loc.id);
          return (
            <button
              key={loc.id}
              type="button"
              className={`map-node ${unlocked ? '' : 'locked'}`}
              style={{ left: `${loc.x}%`, top: `${loc.y}%` }}
              onClick={() => unlocked && navigate(`/adventure/${loc.id}`)}
              disabled={!unlocked}
            >
              <span className="icon">{loc.emoji}</span>
              <span className="label">{loc.name}</span>
            </button>
          );
        })}
      </div>
    </Page>
  );
}
