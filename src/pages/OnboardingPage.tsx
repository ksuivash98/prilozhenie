import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { LumiBubble } from '../components/LumiBubble';
import { ReadingChallenge } from '../features/reading/ReadingChallenge';
import { registerCorrectWord, registerWrongWord, useGame } from '../game/store';

/**
 * Онбординг: имя → первое слово «КОТ» голосом → карта.
 */
export function OnboardingPage() {
  const navigate = useNavigate();
  const { state, setState } = useGame();
  const [name, setName] = useState(state.playerName || '');
  const [step, setStep] = useState<'name' | 'firstWord'>(
    state.playerName && !state.onboardingDone ? 'firstWord' : 'name',
  );

  function saveName() {
    const playerName = name.trim() || 'Герой';
    setState((s) => ({
      ...s,
      playerName,
      dragonName: 'Искорка',
    }));
    setStep('firstWord');
  }

  if (step === 'firstWord') {
    return (
      <div className="page stack" style={{ maxWidth: 560 }}>
        <div className="center">
          <h1 className="brand" style={{ fontSize: '2rem' }}>
            Первое слово
          </h1>
          <p className="slogan">Луми и дракончик рядом</p>
        </div>
        <LumiBubble
          tone="guide"
          text={`${state.playerName || name || 'Герой'}, попробуй прочитать это слово сам!`}
        />
        <ReadingChallenge
          prompt="Попробуй прочитать это слово"
          target="КОТ"
          emoji="🐱"
          storyBeat="Нажми 🎤 и прочитай вслух"
          xp={12}
          coins={5}
          onSuccess={({ xp, coins }) => {
            setState((s) => ({
              ...registerCorrectWord(s, 'кот', { xp, coins, crystals: 1 }),
              onboardingDone: true,
              crystals: s.crystals + 1,
            }));
            navigate('/home', { replace: true });
          }}
          onFail={() => setState((s) => registerWrongWord(s, 'кот'))}
        />
      </div>
    );
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
        <button className="btn" type="button" onClick={saveName}>
          Дальше
        </button>
      </div>
    </div>
  );
}
