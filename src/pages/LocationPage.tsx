import { Link, useNavigate, useParams } from 'react-router-dom';
import { Page } from '../components/Page';
import { ReadingChallenge } from '../components/ReadingChallenge';
import { LumiBubble } from '../components/LumiBubble';
import { locationById, registerCorrectWord, registerWrongWord, useGame } from '../game/store';

export function LocationPage() {
  const { locationId = 'village' } = useParams();
  const loc = locationById(locationId as never);
  const { setState } = useGame();
  const navigate = useNavigate();

  if (!loc) {
    return (
      <Page title="Не найдено">
        <div className="card">Локация не найдена</div>
      </Page>
    );
  }

  return (
    <Page title={loc.name} backTo="/adventure">
      <div className="card stack center">
        <div style={{ fontSize: '4rem' }}>{loc.emoji}</div>
        <p>{loc.description}</p>
        <p className="muted">Босс локации: {loc.boss}</p>
      </div>

      <LumiBubble
        tone="encourage"
        text={`Прочитай слово «${loc.word}» — и мост (или путь) оживёт!`}
      />

      <ReadingChallenge
        prompt="Почини путь силой слова"
        target={loc.word.toUpperCase()}
        emoji={loc.emoji}
        storyBeat="Прочитай → мир меняется"
        xp={12}
        coins={4}
        onSuccess={({ xp, coins }) => {
          setState((s) => registerCorrectWord(s, loc.word, { xp, coins }));
        }}
        onFail={() => setState((s) => registerWrongWord(s, loc.word))}
      />

      <div className="row" style={{ justifyContent: 'center' }}>
        <button
          type="button"
          className="btn secondary"
          onClick={() => navigate(`/battle/${loc.id}`)}
        >
          Вызвать босса
        </button>
        <Link to="/mini-games" className="btn ghost">
          Мини-игры
        </Link>
      </div>
    </Page>
  );
}
