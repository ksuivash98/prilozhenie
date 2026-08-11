import { Page } from '../components/Page';
import { Meter } from '../components/Meter';
import { ReadingChallenge } from '../components/ReadingChallenge';
import { STAGE_EMOJI, STAGE_LABEL } from '../game/data';
import { dragonXpNeed, registerCorrectWordDetailed, useGame } from '../game/store';

export function DragonPage() {
  const { state, setState } = useGame();
  const need = dragonXpNeed(state.dragonStage);

  return (
    <Page title="Твой дракон">
      <div className="card stack center">
        <div style={{ fontSize: '5rem' }}>{STAGE_EMOJI[state.dragonStage]}</div>
        <h2>
          {state.dragonName} · {STAGE_LABEL[state.dragonStage]}
        </h2>
        <Meter
          label="Опыт"
          value={need ? state.dragonXp / need : 1}
          trailing={need ? `${state.dragonXp}/${need} XP` : 'Легенда!'}
          variant="coral"
        />
        <p className="muted">Дракон растёт только от чтения. Никаких покупок.</p>
      </div>

      <ReadingChallenge
        prompt="Накорми дракона словом"
        target="ЯБЛОКО"
        emoji="🍎"
        storyBeat="Прочитай название еды"
        xp={15}
        coins={5}
        onSuccess={() => {
          let result = { xp: 0, coins: 0, isNewWord: false, message: '' };
          setState((s) => {
            const r = registerCorrectWordDetailed(s, 'яблоко', { xp: 15, coins: 5 });
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
      />
    </Page>
  );
}
