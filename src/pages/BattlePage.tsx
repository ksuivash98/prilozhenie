import { useMemo, useState } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { Page } from '../components/Page';
import { ReadingChallenge } from '../components/ReadingChallenge';
import { Meter } from '../components/Meter';
import { locationById, registerCorrectWord, unlockNextLocation, useGame } from '../game/store';

const STRIKE_WORDS = ['искра', 'радуга', 'дракон', 'приключение', 'смелость'];

export function BattlePage() {
  const { locationId = 'village' } = useParams();
  const loc = locationById(locationId as never);
  const { setState } = useGame();
  const navigate = useNavigate();
  const [hp, setHp] = useState(loc?.bossHp ?? 30);
  const [combo, setCombo] = useState(0);
  const [victory, setVictory] = useState(false);
  const word = useMemo(() => STRIKE_WORDS[combo % STRIKE_WORDS.length], [combo]);

  if (!loc) {
    return (
      <Page title="Бой">
        <div className="card">Босс не найден</div>
      </Page>
    );
  }

  return (
    <Page title="Битва слов" backTo={`/adventure/${loc.id}`}>
      <div className="card stack center" style={{ background: 'rgba(62,39,35,0.88)', color: 'white' }}>
        <div style={{ fontSize: '4.5rem' }}>{victory ? '🎉' : '👹'}</div>
        <h2 style={{ color: victory ? 'var(--gold)' : 'white' }}>
          {victory ? 'Победа!' : loc.boss}
        </h2>
        {!victory ? (
          <>
            <Meter label="HP" value={hp / loc.bossHp} trailing={`${hp}/${loc.bossHp}`} variant="coral" />
            <p>Комбо ×{combo}. Чем длиннее слово — тем сильнее удар!</p>
          </>
        ) : (
          <p>Тьма отступает. Новая дорога открыта!</p>
        )}
      </div>

      {!victory ? (
        <ReadingChallenge
          key={`${word}-${combo}`}
          prompt="Прочитай ударное слово"
          target={word.toUpperCase()}
          storyBeat="Длинные слова дают больше силы"
          xp={8 + word.length}
          coins={word.length}
          onSuccess={({ xp, coins }) => {
            const damage = Math.max(3, word.length + Math.floor(combo / 2));
            const nextHp = Math.max(0, hp - damage);
            setHp(nextHp);
            setCombo((c) => c + 1);
            setState((s) => registerCorrectWord(s, word, { xp, coins }));
            if (nextHp === 0) {
              setVictory(true);
              setState((s) => unlockNextLocation({ ...s, currentLocation: loc.id }));
            }
          }}
          onFail={() => setCombo(0)}
        />
      ) : (
        <button type="button" className="btn" onClick={() => navigate('/adventure')}>
          Вернуться к карте
        </button>
      )}
    </Page>
  );
}
