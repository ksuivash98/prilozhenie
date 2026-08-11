import { useMemo } from 'react';
import { Page } from '../components/Page';
import { LumiBubble } from '../components/LumiBubble';
import { ReadingChallenge } from '../features/reading/ReadingChallenge';
import { KIND_LABEL, nextCurriculumUnit } from '../data/curriculum';
import {
  adaptivePracticeWords,
  registerCorrectWordDetailed,
  registerWrongWord,
  useGame,
} from '../game/store';

/** Учебная лестница и адаптивные повторы сложных букв. */
export function LearnPage() {
  const { state, setState } = useGame();

  const unit = useMemo(
    () => nextCurriculumUnit(state.completedUnits, state.readingLevel),
    [state.completedUnits, state.readingLevel],
  );

  const practice = useMemo(() => adaptivePracticeWords(state)[0], [state]);

  if (!unit) {
    return (
      <Page title="Учёба">
        <div className="card center stack">
          <p style={{ fontSize: '3rem' }}>🏆</p>
          <h2>Ты прошёл все задания этого уровня!</h2>
          <p className="muted">Иди в приключение — там ждут новые слова.</p>
          {practice && (
            <ReadingChallenge
              prompt="Тренировка сложных букв"
              target={practice.toUpperCase()}
              emoji="💪"
              onSuccess={() => {
                let result = { xp: 0, coins: 0, isNewWord: false, message: '' };
                setState((s) => {
                  const r = registerCorrectWordDetailed(s, practice, {
                    xp: 10,
                    coins: 5,
                  });
                  result = {
                    xp: r.xp,
                    coins: r.coins,
                    isNewWord: r.isNewWord,
                    message: r.message,
                  };
                  return r.state;
                });
                return result;
              }}
              onFail={() => setState((s) => registerWrongWord(s, practice))}
            />
          )}
        </div>
      </Page>
    );
  }

  return (
    <Page title="Учёба">
      <LumiBubble
        tone="guide"
        text={`Сейчас: ${KIND_LABEL[unit.kind].toLowerCase()}. Сначала попробуй сам!`}
      />
      <div className="card warm center">
        Уровень чтения {state.readingLevel} · пройдено {state.completedUnits.length} заданий
      </div>
      <ReadingChallenge
        key={unit.id}
        prompt={`Прочитай: ${KIND_LABEL[unit.kind].toLowerCase()}`}
        target={unit.text}
        emoji={unit.emoji}
        xp={unit.xp}
        coins={unit.coins}
        onSuccess={() => {
          let result = { xp: 0, coins: 0, isNewWord: false, message: '' };
          setState((s) => {
            const r = registerCorrectWordDetailed(
              s,
              unit.text,
              { xp: unit.xp, coins: unit.coins },
              unit.id,
            );
            result = {
              xp: r.xp,
              coins: r.coins,
              isNewWord: r.isNewWord,
              message: r.message,
            };
            return r.state;
          });
          return result;
        }}
        onFail={() => setState((s) => registerWrongWord(s, unit.text))}
      />
    </Page>
  );
}
