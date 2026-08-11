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
