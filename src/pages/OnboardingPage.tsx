import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { LumiBubble } from '../components/LumiBubble';
import { useGame } from '../game/store';

export function OnboardingPage() {
  const navigate = useNavigate();
  const { state, setState, speak } = useGame();
  const [name, setName] = useState(state.playerName || '');

  function start() {
    const playerName = name.trim() || 'Герой';
    setState((s) => ({
      ...s,
      playerName,
      onboardingDone: true,
      dragonName: 'Искорка',
    }));
    speak(`Привет, ${playerName}! Давай вернём силу слов!`);
    navigate('/home', { replace: true });
  }

  return (
    <div className="page stack" style={{ maxWidth: 560 }}>
      <div className="center">
        <div style={{ fontSize: '4rem' }}>🐉✨</div>
        <h1 className="brand">Добро пожаловать</h1>
        <p className="slogan">Мир потерял силу слов. Ты можешь её вернуть.</p>
      </div>
      <LumiBubble tone="greet" />
      <div className="card stack">
        <label htmlFor="name">
          <strong>Как тебя зовут?</strong>
        </label>
        <input
          id="name"
          className="input"
          value={name}
          onChange={(e) => setName(e.target.value)}
          placeholder="Имя героя"
          maxLength={20}
        />
        <p className="muted center">
          У тебя появится дракончик. Он растёт, когда ты читаешь.
        </p>
        <button className="btn" type="button" onClick={start}>
          Начать приключение
        </button>
      </div>
    </div>
  );
}
