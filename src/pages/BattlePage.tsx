import { useMemo, useState } from 'react';
import { Navigate, useNavigate, useParams } from 'react-router-dom';
import { Page } from '../components/Page';
import { ReadingChallenge } from '../components/ReadingChallenge';
import { Meter } from '../components/Meter';
import { LumiBubble } from '../components/LumiBubble';
import { chapterByLocation } from '../data/chapters';
import {
  completeChapter,
  locationById,
  registerCorrectWordDetailed,
  registerWrongWord,
  useGame,
} from '../game/store';
import {
  markChapterPrepared,
  markMinibossComplete,
} from '../services/readingStatsService';
import {
  type FightMode,
  type SelectedWord,
  canUnlockFinalBoss,
  getNextWord,
  selectPrepareWords,
  selectWordsForFinalBoss,
  selectWordsForMiniBoss,
} from '../services/wordSelectionService';

function modeFromStage(stage?: string): FightMode {
  if (stage === 'mini1' || stage === 'mini2' || stage === 'mini3') return stage;
  if (stage === 'prepare') return 'prepare';
  return 'boss';
}

export function BattlePage() {
  const { locationId = 'village', stage = 'boss' } = useParams();
  const loc = locationById(locationId as never);
  const chapter = chapterByLocation(locationId as never);
  const { state, setState } = useGame();
  const navigate = useNavigate();
  const mode = modeFromStage(stage);

  const mini = chapter?.miniBosses.find((m) => `mini${m.index}` === stage);
  const sequence = useMemo(() => {
    if (!chapter) return [] as SelectedWord[];
    if (mode === 'mini1' || mode === 'mini2' || mode === 'mini3') {
      return selectWordsForMiniBoss(state, chapter.id, Number(mode.slice(-1)) as 1 | 2 | 3);
    }
    if (mode === 'prepare') {
      return selectPrepareWords(state, chapter.id, 4).map((w) => ({
        ...w,
        origin: 'new' as const,
        hard: true,
      }));
    }
    return selectWordsForFinalBoss(state, chapter.id);
    // sequence фиксируется на старте боя
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [chapter?.id, mode, state.readingSessionId]);

  const [index, setIndex] = useState(0);
  const [hits, setHits] = useState(0);
  const [fails, setFails] = useState(0);
  const [victory, setVictory] = useState(false);
  const [lastFail, setLastFail] = useState(false);

  const total = Math.max(1, sequence.length);
  const word: SelectedWord | undefined = chapter
    ? getNextWord({
        state,
        chapterId: chapter.id,
        mode,
        usedWordIds: sequence.slice(0, index).map((w) => w.id),
        lastWordId: index > 0 ? sequence[index - 1]?.id : undefined,
        lastWasFail: lastFail,
        sequence,
        index,
      })
    : undefined;

  if (!loc || !chapter) {
    return (
      <Page title="Бой">
        <div className="card">Бой не найден</div>
      </Page>
    );
  }

  const allMinis = chapter.miniBosses.every((m) =>
    state.completedMinibosses.includes(m.id),
  );
  const prepared = state.preparedChapters.includes(chapter.id);
  const chapterDone = state.completedChapters.includes(chapter.id);
  const unlock = canUnlockFinalBoss(state, chapter.id);

  if (!chapterDone) {
    if (mini && mini.index > 1) {
      const prev = chapter.miniBosses[mini.index - 2];
      if (prev && !state.completedMinibosses.includes(prev.id)) {
        return <Navigate to={`/adventure/${loc.id}`} replace />;
      }
    }
    if (mode === 'prepare' && !allMinis) {
      return <Navigate to={`/adventure/${loc.id}`} replace />;
    }
    if (mode === 'boss' && (!unlock.ok || !allMinis || !prepared)) {
      return <Navigate to={`/adventure/${loc.id}/prepare`} replace />;
    }
  }

  if (!word) {
    return (
      <Page title="Бой" backTo={`/adventure/${loc.id}`}>
        <div className="card">Слова для боя ещё готовятся. Попробуй чуть позже.</div>
      </Page>
    );
  }

  const title =
    mode === 'boss'
      ? chapter.bossName
      : mode === 'prepare'
        ? 'Подготовка к боссу'
        : mini?.name ?? 'Предбосс';
  const emoji =
    victory ? '🎉' : mode === 'prepare' ? '✨' : mini?.emoji ?? chapter.bossEmoji;
  const back = `/adventure/${loc.id}`;

  return (
    <Page title={mode === 'boss' ? 'Битва слов' : title} backTo={back}>
      <div
        className="card stack center"
        style={{ background: 'rgba(62,39,35,0.88)', color: 'white' }}
      >
        <div style={{ fontSize: '4.5rem' }}>{emoji}</div>
        <h2 style={{ color: victory ? 'var(--gold)' : 'white' }}>
          {victory ? 'Победа!' : title}
        </h2>
        {!victory ? (
          <Meter
            label={mode === 'prepare' ? 'Проверка' : 'Сила'}
            value={hits / total}
            trailing={`${hits}/${total}`}
            variant="coral"
          />
        ) : (
          <p>
            {mode === 'boss'
              ? `Тьма отступает. ${chapter.unlock.emoji} ${chapter.unlock.name} теперь с тобой!`
              : mode === 'prepare'
                ? 'Слова готовы. Можно идти к главному боссу!'
                : 'Страж отступил. Путь дальше открыт!'}
          </p>
        )}
      </div>

      {mode === 'prepare' && !victory && (
        <LumiBubble
          tone="guide"
          text="Ты почти у цели! Давай проверим слова, которые помогут победить босса."
        />
      )}

      {!victory ? (
        <ReadingChallenge
          key={`${word.id}-${index}-${fails}`}
          prompt="Прочитай слово"
          target={word.text}
          storyBeat={word.origin === 'new' ? 'Новое слово главы' : 'Вспомни знакомое слово'}
          xp={10}
          coins={5}
          onSuccess={() => {
            let result = { xp: 0, coins: 0, isNewWord: false, message: '' };
            const nextHits = hits + 1;
            const won = nextHits >= total;
            setState((s) => {
              const r = registerCorrectWordDetailed(s, word.text, { xp: 10, coins: 5 });
              result = {
                xp: r.xp,
                coins: r.coins,
                isNewWord: r.isNewWord,
                message: r.message,
              };
              let next = r.state;
              if (won) {
                if (mini) next = markMinibossComplete(next, mini.id);
                else if (mode === 'prepare') next = markChapterPrepared(next, chapter.id);
                else next = completeChapter(next, loc.id);
              }
              return next;
            });
            setHits(nextHits);
            setLastFail(false);
            if (won) setVictory(true);
            else setIndex((i) => Math.min(i + 1, total - 1));
            return result;
          }}
          onFail={() => {
            setFails((n) => n + 1);
            setLastFail(true);
            setState((s) => registerWrongWord(s, word.text));
          }}
        />
      ) : (
        <button
          type="button"
          className="btn"
          onClick={() => navigate(back)}
        >
          Вернуться к главе
        </button>
      )}
    </Page>
  );
}
