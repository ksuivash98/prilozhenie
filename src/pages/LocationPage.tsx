import { useMemo, useState } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { Page } from '../components/Page';
import { ReadingChallenge } from '../components/ReadingChallenge';
import { LumiBubble } from '../components/LumiBubble';
import { chapterByLocation } from '../data/chapters';
import {
  locationById,
  registerCorrectWordDetailed,
  registerWrongWord,
  useGame,
} from '../game/store';
import { canUnlockFinalBoss, getNextWord } from '../services/wordSelectionService';

export function LocationPage() {
  const { locationId = 'village' } = useParams();
  const loc = locationById(locationId as never);
  const chapter = chapterByLocation(locationId as never);
  const { state, setState } = useGame();
  const navigate = useNavigate();
  const [introTick, setIntroTick] = useState(0);

  const introWord = useMemo(
    () =>
      chapter
        ? getNextWord({
            state,
            chapterId: chapter.id,
            mode: 'intro',
            usedWordIds: [],
          })
        : null,
    // eslint-disable-next-line react-hooks/exhaustive-deps -- новое слово после каждого успеха
    [chapter?.id, introTick, state.readingSessionId],
  );

  if (!loc || !chapter) {
    return (
      <Page title="Не найдено">
        <div className="card">Локация не найдена</div>
      </Page>
    );
  }

  const unlock = canUnlockFinalBoss(state, chapter.id);
  const allMinisDone = chapter.miniBosses.every((m) =>
    state.completedMinibosses.includes(m.id),
  );
  const prepared = state.preparedChapters.includes(chapter.id);
  const chapterDone = state.completedChapters.includes(chapter.id);
  const bossOpen = unlock.ok && allMinisDone && prepared && !chapterDone;

  return (
    <Page title={chapter.name} backTo="/adventure">
      <div className="card stack center">
        <div style={{ fontSize: '4rem' }}>{chapter.emoji}</div>
        <p>{loc.description}</p>
        {chapterDone && (
          <p>
            Награда главы: {chapter.unlock.emoji} {chapter.unlock.name}
          </p>
        )}
      </div>

      <div className="card stack">
        <strong>Новые слова главы</strong>
        <div className="word-chips">
          {chapter.newWords.map((w) => {
            const rec = state.readingRecords[w.id];
            const known = (rec?.successCount ?? 0) > 0;
            return (
              <span key={w.id} className={`word-chip ${known ? 'known' : ''}`}>
                {w.text}
              </span>
            );
          })}
        </div>
      </div>

      <LumiBubble
        tone="guide"
        text="Сначала познакомься с новыми словами. Потом тебя ждут стражи и главный босс!"
      />

      {introWord && !chapterDone && (
        <ReadingChallenge
          key={`${introWord.id}-${introTick}`}
          prompt="Новое слово главы"
          target={introWord.text}
          emoji={chapter.emoji}
          storyBeat="Знакомство"
          xp={10}
          coins={5}
          onSuccess={() => {
            let result = { xp: 0, coins: 0, isNewWord: false, message: '' };
            setState((s) => {
              const r = registerCorrectWordDetailed(s, introWord.text, { xp: 10, coins: 5 });
              result = {
                xp: r.xp,
                coins: r.coins,
                isNewWord: r.isNewWord,
                message: r.message,
              };
              return r.state;
            });
            setIntroTick((n) => n + 1);
            return result;
          }}
          onFail={() => setState((s) => registerWrongWord(s, introWord.text))}
        />
      )}

      <div className="card stack">
        <strong>Путь главы</strong>
        <div className="chapter-path">
          {chapter.miniBosses.map((mini, i) => {
            const unlocked = i === 0 || state.completedMinibosses.includes(chapter.miniBosses[i - 1].id);
            const done = state.completedMinibosses.includes(mini.id);
            return (
              <button
                key={mini.id}
                type="button"
                className={`path-node ${done ? 'done' : ''} ${unlocked ? '' : 'locked'}`}
                disabled={!unlocked || chapterDone}
                onClick={() => unlocked && navigate(`/battle/${loc.id}/mini${mini.index}`)}
              >
                <span className="emoji">{done ? '✅' : mini.emoji}</span>
                <span>Предбосс {mini.index}</span>
                <small>{mini.name}</small>
              </button>
            );
          })}
          <button
            type="button"
            className={`path-node ${prepared ? 'done' : ''} ${allMinisDone ? '' : 'locked'}`}
            disabled={!allMinisDone || chapterDone}
            onClick={() => allMinisDone && navigate(`/adventure/${loc.id}/prepare`)}
          >
            <span className="emoji">{prepared ? '✅' : '✨'}</span>
            <span>Подготовка</span>
            <small>Слова перед боссом</small>
          </button>
          <button
            type="button"
            className={`path-node ${chapterDone ? 'done' : ''} ${bossOpen ? '' : 'locked'}`}
            disabled={chapterDone || !allMinisDone}
            onClick={() => {
              if (chapterDone) return;
              if (bossOpen) navigate(`/battle/${loc.id}/boss`);
              else navigate(`/adventure/${loc.id}/prepare`);
            }}
          >
            <span className="emoji">{chapterDone ? '🏆' : chapter.bossEmoji}</span>
            <span>Главный босс</span>
            <small>{chapter.bossName}</small>
          </button>
        </div>
        {!chapterDone && allMinisDone && !unlock.ok && (
          <LumiBubble tone="encourage" text={unlock.childMessage} />
        )}
        {!chapterDone && allMinisDone && unlock.ok && !prepared && (
          <LumiBubble
            tone="guide"
            text="Ты почти у цели! Давай проверим слова, которые помогут победить босса."
          />
        )}
      </div>
    </Page>
  );
}
