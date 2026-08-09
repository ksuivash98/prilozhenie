import { useMemo } from 'react';
import { Page } from '../components/Page';
import { LumiBubble } from '../components/LumiBubble';
import { ReadingChallenge } from '../features/reading/ReadingChallenge';
import { KIND_LABEL, nextCurriculumUnit } from '../data/curriculum';
import { adaptivePracticeWords, registerCorrectWord, registerWrongWord, useGame } from '../game/store';

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
              onSuccess={({ xp, coins }) =>
                setState((s) => registerCorrectWord(s, practice, { xp, coins }))
              }
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
        onSuccess={({ xp, coins }) =>
          setState((s) => registerCorrectWord(s, unit.text, { xp, coins }, unit.id))
        }
        onFail={() => setState((s) => registerWrongWord(s, unit.text))}
      />
    </Page>
  );
}
