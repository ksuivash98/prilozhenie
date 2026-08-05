import { Link } from 'react-router-dom';
import { Page } from '../components/Page';
import { MINI_GAMES } from '../game/data';
import { useGame } from '../game/store';

export function MiniGamesHubPage() {
  const { state } = useGame();

  return (
    <Page title="Мини-игры">
      <div className="card">
        20 игр. Каждая открывается чтением. Сейчас у тебя {state.wordsRead} слов.
      </div>
      <div className="grid hub">
        {MINI_GAMES.map((g) => {
          const unlocked = state.wordsRead >= g.unlockWords;
          return unlocked ? (
            <Link
              key={g.id}
              to={`/mini-games/${g.id}`}
              className="hub-tile"
              style={{ background: '#26a69a' }}
            >
              <span className="emoji">{g.emoji}</span>
              <span>{g.title}</span>
            </Link>
          ) : (
            <div
              key={g.id}
              className="hub-tile"
              style={{ background: '#90a4ae', cursor: 'not-allowed' }}
              title={`Нужно ${g.unlockWords} слов`}
            >
              <span className="emoji">🔒</span>
              <span>{g.title}</span>
              <small>{g.unlockWords} слов</small>
            </div>
          );
        })}
      </div>
    </Page>
  );
}
