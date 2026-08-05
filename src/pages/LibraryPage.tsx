import { useState } from 'react';
import { Page } from '../components/Page';
import { STORIES } from '../game/data';
import { registerCorrectWord, useGame } from '../game/store';

export function LibraryPage() {
  const { state, setState, speak } = useGame();
  const [active, setActive] = useState<string | null>(null);
  const [page, setPage] = useState(0);
  const story = STORIES.find((s) => s.id === active);

  function finishStory() {
    if (!story) return;
    setState((s) => ({
      ...registerCorrectWord(s, story.title, { xp: 20, coins: 8 }),
      storiesRead: s.storiesRead.includes(story.id)
        ? s.storiesRead
        : [...s.storiesRead, story.id],
      wordsRead: s.wordsRead + story.pages.length,
    }));
    setActive(null);
    setPage(0);
  }

  if (story) {
    return (
      <Page title={story.title} backTo="/library">
        <div className="card stack center">
          <p className="reading-word" style={{ fontSize: '1.6rem' }}>
            {story.pages[page]}
          </p>
          <div className="row" style={{ justifyContent: 'center' }}>
            <button type="button" className="btn ghost" onClick={() => speak(story.pages[page])}>
              🔊 Слушать
            </button>
            {page < story.pages.length - 1 ? (
              <button type="button" className="btn" onClick={() => setPage((p) => p + 1)}>
                Дальше
              </button>
            ) : (
              <button type="button" className="btn secondary" onClick={finishStory}>
                Я прочитал(а)!
              </button>
            )}
          </div>
          <p className="muted">
            Страница {page + 1} / {story.pages.length}
          </p>
        </div>
      </Page>
    );
  }

  return (
    <Page title="Библиотека">
      <div className="card">Все прочитанные рассказы остаются здесь. После рассказа открывается иллюстрация-награда.</div>
      <div className="stack">
        {STORIES.map((s) => {
          const read = state.storiesRead.includes(s.id);
          return (
            <button
              key={s.id}
              type="button"
              className="card"
              style={{ textAlign: 'left', cursor: 'pointer' }}
              onClick={() => {
                setActive(s.id);
                setPage(0);
              }}
            >
              <strong>
                {read ? '🖼️ ' : '📖 '}
                {s.title}
              </strong>
              <p className="muted">{read ? 'Прочитано · иллюстрация открыта' : 'Новый рассказ'}</p>
            </button>
          );
        })}
      </div>
    </Page>
  );
}
