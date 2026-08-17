import type { DragonStage, GameState } from '../game/data';
import type { RewardKind, RewardPayload } from '../types/readingStats';

/** Награды по типу действия — без бесконечной накрутки за повторы. */
export function getReward(kind: RewardKind): RewardPayload {
  switch (kind) {
    case 'NEW_WORD':
      return { xp: 10, coins: 5, crystals: 0 };
    case 'REPEATED_WORD':
      return { xp: 0, coins: 0, crystals: 0 };
    case 'NEW_SENTENCE':
      return { xp: 20, coins: 8, crystals: 0 };
    case 'NEW_STORY':
      return { xp: 50, coins: 15, crystals: 1 };
    case 'DAILY_GOAL':
      return { xp: 100, coins: 25, crystals: 2 };
    case 'MINI_GAME':
      return { xp: 15, coins: 5, crystals: 0 };
    case 'CHAPTER_CLEAR':
      return { xp: 80, coins: 20, crystals: 1 };
    default:
      return { xp: 0, coins: 0, crystals: 0 };
  }
}

/** Масштабирует базовую награду (если UI передаёт свои xp/coins для нового слова). */
export function scaleNewWordReward(
  base: RewardPayload,
  override?: { xp?: number; coins?: number; crystals?: number },
): RewardPayload {
  if (!override) return base;
  return {
    xp: override.xp ?? base.xp,
    coins: override.coins ?? base.coins,
    crystals: override.crystals ?? base.crystals,
  };
}

export function applyRewardsToState(state: GameState, reward: RewardPayload): GameState {
  if (reward.xp === 0 && reward.coins === 0 && reward.crystals === 0) return state;

  let next: GameState = {
    ...state,
    xp: state.xp + reward.xp,
    coins: state.coins + reward.coins,
    crystals: state.crystals + reward.crystals,
    dragonXp: state.dragonXp + reward.xp,
  };

  const xpNeed = (level: number) => 100 + level * 50;
  while (next.xp >= xpNeed(next.level)) {
    next = {
      ...next,
      xp: next.xp - xpNeed(next.level),
      level: next.level + 1,
    };
  }

  const stageNeed = (stage: DragonStage) => {
    switch (stage) {
      case 'egg':
        return 50;
      case 'baby':
        return 200;
      case 'teen':
        return 600;
      case 'adult':
        return 1500;
      default:
        return 0;
    }
  };
  const stages: DragonStage[] = ['egg', 'baby', 'teen', 'adult', 'legendary'];
  const need = stageNeed(next.dragonStage);
  if (need > 0 && next.dragonXp >= need && next.dragonStage !== 'legendary') {
    const idx = stages.indexOf(next.dragonStage);
    next = {
      ...next,
      dragonStage: stages[Math.min(idx + 1, stages.length - 1)],
      dragonXp: next.dragonXp - need,
    };
  }

  return next;
}
