import type { GameState } from '../game/data';
import type { MiniGamePlayRecord, RewardPayload } from '../types/readingStats';
import { MAX_REWARDED_MINI_GAME_PLAYS } from '../types/readingStats';
import { applyRewardsToState, getReward } from './rewardService';
import { todayKey } from './wordId';

export interface MiniGamePlayOutcome {
  state: GameState;
  rewarded: boolean;
  playCount: number;
  rewardedPlayCount: number;
  reward: RewardPayload;
  message: string;
}

function emptyPlay(gameId: string, date: string): MiniGamePlayRecord {
  return { gameId, date, playCount: 0, rewardedPlayCount: 0 };
}

/**
 * Фиксирует прохождение мини-игры.
 * Полная награда только за первые 3 прохождения (lifetime).
 * Игру не блокирует.
 */
export function recordMiniGamePlay(state: GameState, gameId: string): MiniGamePlayOutcome {
  const date = todayKey();
  const plays = { ...(state.miniGamePlays ?? {}) };
  const prev = plays[gameId] ?? emptyPlay(gameId, date);
  const playCount = prev.playCount + 1;
  const canReward = prev.rewardedPlayCount < MAX_REWARDED_MINI_GAME_PLAYS;
  const rewardedPlayCount = prev.rewardedPlayCount + (canReward ? 1 : 0);
  const reward = canReward ? getReward('MINI_GAME') : { xp: 0, coins: 0, crystals: 0 };

  plays[gameId] = {
    gameId,
    date,
    playCount,
    rewardedPlayCount,
  };

  let next: GameState = {
    ...state,
    miniGamePlays: plays,
  };
  next = applyRewardsToState(next, reward);

  return {
    state: next,
    rewarded: canReward,
    playCount,
    rewardedPlayCount,
    reward,
    message: canReward
      ? '🎮 Отличная игра!'
      : 'Ты уже получил награду за эту игру. Попробуй другое приключение, чтобы получить новые награды!',
  };
}

export function getMiniGamePlay(state: GameState, gameId: string): MiniGamePlayRecord {
  return (
    state.miniGamePlays?.[gameId] ?? {
      gameId,
      date: todayKey(),
      playCount: 0,
      rewardedPlayCount: 0,
    }
  );
}
