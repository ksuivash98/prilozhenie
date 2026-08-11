import { Link } from 'react-router-dom';
import { LumiBubble } from '../components/LumiBubble';
import { Meter } from '../components/Meter';
import { STAGE_EMOJI, STAGE_LABEL } from '../game/data';
import { dragonXpNeed, useGame } from '../game/store';

const TILES = [
  { to: '/learn', emoji: '📖', label: 'Учёба', color: '#7cb342' },
  { to: '/adventure', emoji: '🗺️', label: 'Приключение', color: '#26a69a' },
  { to: '/dragon', emoji: '🐉', label: 'Дракон', color: '#ff6f61' },
  { to: '/mini-games', emoji: '🎮', label: 'Мини-игры', color: '#ec407a' },
  { to: '/library', emoji: '📚', label: 'Библиотека', color: '#5c6bc0' },
  { to: '/city', emoji: '🏘️', label: 'Город', color: '#ffb300' },
  { to: '/achievements', emoji: '🏆', label: 'Награды', color: '#ffd54f' },
  { to: '/settings', emoji: '⚙️', label: 'Настройки', color: '#8d6e63' },
  { to: '/parents', emoji: '👨‍👩‍👧', label: 'Родителям', color: '#4fa3d1' },
];

export function HomePage() {
  const { state } = useGame();
  const need = dragonXpNeed(state.dragonStage);

  return (
    <div className="page stack">
      <div className="row" style={{ justifyContent: 'space-between' }}>
        <div>
          <h1 className="brand">ReadQuest</h1>
          <p className="slogan">
            Привет, {state.playerName || 'исследователь'}!
          </p>
        </div>
        <Link to="/statistics" className="btn ghost">
          📊
        </Link>
      </div>

      <div className="card warm stack">
        <Meter
          label="Жизнь мира"
          value={state.vitality}
          trailing={`${Math.round(state.vitality * 100)}%`}
        />
        <p className="muted">🌱 Каждое прочитанное слово возвращает краски!</p>
      </div>

      <LumiBubble tone="celebrate" seed={state.uniqueWords} />

      <div className="card row">
        <div style={{ fontSize: '3.4rem' }}>
          {STAGE_EMOJI[state.dragonStage]}
        </div>
        <div className="grow stack" style={{ gap: '0.4rem' }}>
          <strong>
            {state.dragonName} · {STAGE_LABEL[state.dragonStage]}
          </strong>
          <Meter
            label="Рост дракона"
            value={need ? state.dragonXp / need : 1}
            trailing={need ? `${state.dragonXp}/${need}` : 'макс'}
            variant="coral"
          />
        </div>
      </div>

      <div className="row">
        <div className="card warm grow center stat">
          <div className="value">{state.uniqueWords}</div>
          <div className="muted">выучено</div>
        </div>
        <div className="card warm grow center stat">
          <div className="value">{state.level}</div>
          <div className="muted">уровень</div>
        </div>
        <div className="card warm grow center stat">
          <div className="value">{state.coins}</div>
          <div className="muted">монеты</div>
        </div>
        <div className="card warm grow center stat">
          <div className="value">{state.crystals}</div>
          <div className="muted">кристаллы</div>
        </div>
      </div>

      <div className="grid hub">
        {TILES.map((t) => (
          <Link
            key={t.to}
            to={t.to}
            className="hub-tile"
            style={{ background: t.color }}
          >
            <span className="emoji">{t.emoji}</span>
            <span>{t.label}</span>
          </Link>
        ))}
      </div>
    </div>
  );
}
