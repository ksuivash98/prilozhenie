import { useMemo, useState } from 'react';
import { useParams } from 'react-router-dom';
import { Page } from '../components/Page';
import { ReadingChallenge } from '../components/ReadingChallenge';
import { MINI_GAMES } from '../game/data';
import { registerCorrectWordDetailed, useGame } from '../game/store';
import { getMiniGamePlay, recordMiniGamePlay } from '../services/miniGameRewardService';
import { MAX_REWARDED_MINI_GAME_PLAYS } from '../types/readingStats';

function shuffle<T>(arr: T[]): T[] {
  return [...arr].sort(() => Math.random() - 0.5);
}

export function MiniGamePage() {
  const { gameId = '' } = useParams();
  const game = MINI_GAMES.find((g) => g.id === gameId) ?? MINI_GAMES[0];
  const { state, setState } = useGame();
  const [score, setScore] = useState(0);
  const [step, setStep] = useState(0);
  const [message, setMessage] = useState('Сделай ход!');
  const letters = useMemo(() => shuffle(game.word.split('')), [game.word, score]);
  const decoys = useMemo(
    () => shuffle([game.word, 'туман', 'камень', 'река']).slice(0, 3),
    [game.word, score],
  );

  const isSequence = ['collect_word', 'magic_runes', 'forge', 'library_game', 'puzzles'].includes(
    game.id,
  );

  function onLetter(letter: string) {
    const expected = game.word[step];
    if (letter !== expected) {
      setMessage('Другая буква — попробуй ещё!');
      setStep(0);
      return;
    }
    const next = step + 1;
    setStep(next);
    if (next >= game.word.length) {
      setScore((s) => s + 10);
      setMessage('Слово собрано! +10');
      setStep(0);
      setState((s) => ({
        ...s,
        bestScores: {
          ...s.bestScores,
          [game.id]: Math.max(s.bestScores[game.id] ?? 0, score + 10),
        },
      }));
    }
  }

  function chooseWord(w: string) {
    if (w !== game.word) {
      setMessage('Это не то слово. Ещё попытка!');
      return;
    }
    setScore((s) => s + 10);
    setMessage('Верно! +10');
  }

  const playInfo = getMiniGamePlay(state, game.id);
  const rewardsLeft = Math.max(0, MAX_REWARDED_MINI_GAME_PLAYS - playInfo.rewardedPlayCount);

  return (
    <Page title={game.title} backTo="/mini-games">
      <div className="card warm stack center">
        <div style={{ fontSize: '3.5rem' }}>{game.emoji}</div>
        <p>{game.description}</p>
        <strong>Счёт: {score}</strong>
        <p className="muted">{message}</p>
        {rewardsLeft === 0 && (
          <p>
            Ты уже получил награду за эту игру. Попробуй другое приключение, чтобы получить
            новые награды!
          </p>
        )}
      </div>

      <div className="card stack">
        {isSequence ? (
          <>
            <p className="center">Нажимай буквы по порядку: прогресс {step}/{game.word.length}</p>
            <div className="letters">
              {letters.map((letter, i) => (
                <button
                  key={`${letter}-${i}`}
                  type="button"
                  className="letter-chip"
                  onClick={() => onLetter(letter)}
                >
                  {letter.toUpperCase()}
                </button>
              ))}
            </div>
          </>
        ) : (
          <>
            <p className="center">Выбери правильное слово</p>
            <div className="row" style={{ justifyContent: 'center' }}>
              {decoys.map((w) => (
                <button key={w} type="button" className="btn secondary" onClick={() => chooseWord(w)}>
                  {w}
                </button>
              ))}
            </div>
          </>
        )}
      </div>

      <ReadingChallenge
        prompt="Закрепи победу чтением"
        target={game.word.toUpperCase()}
        storyBeat="Прочитай слово мини-игры"
        xp={10}
        coins={3}
        onSuccess={() => {
          let result = { xp: 0, coins: 0, isNewWord: false, message: '' };
          setState((s) => {
            const r = registerCorrectWordDetailed(s, game.word, { xp: 10, coins: 3 });
            const play = recordMiniGamePlay(r.state, game.id);
            result = {
              xp: r.xp + play.reward.xp,
              coins: r.coins + play.reward.coins,
              isNewWord: r.isNewWord,
              message: play.rewarded
                ? r.message
                : play.message,
            };
            return play.state;
          });
          if (!result.xp && !result.coins && !result.isNewWord) {
            setMessage(result.message);
          } else if (result.isNewWord) {
            setScore((s) => s + 5);
            setMessage('Новое слово!');
          } else if (result.xp > 0) {
            setScore((s) => s + 5);
            setMessage('🎮 Отличная игра!');
          } else {
            setMessage('Отличное повторение!');
          }
          return result;
        }}
      />
    </Page>
  );
}
