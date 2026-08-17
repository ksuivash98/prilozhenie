import { describe, expect, it } from 'vitest';
import { initialState } from '../game/store';
import { getReward } from './rewardService';
import { recordMiniGamePlay } from './miniGameRewardService';

describe('лимит наград мини-игр', () => {
  it('1. первые 3 прохождения дают награду', () => {
    let s = initialState();
    const xp0 = s.xp;
    const r1 = recordMiniGamePlay(s, 'feed_dragon');
    expect(r1.rewarded).toBe(true);
    expect(r1.reward).toEqual(getReward('MINI_GAME'));
    expect(r1.state.xp).toBe(xp0 + getReward('MINI_GAME').xp);
    s = r1.state;

    const r2 = recordMiniGamePlay(s, 'feed_dragon');
    expect(r2.rewarded).toBe(true);
    s = r2.state;

    const r3 = recordMiniGamePlay(s, 'feed_dragon');
    expect(r3.rewarded).toBe(true);
    expect(r3.playCount).toBe(3);
    expect(r3.rewardedPlayCount).toBe(3);
  });

  it('2. 4-е прохождение не даёт XP', () => {
    let s = initialState();
    for (let i = 0; i < 3; i += 1) s = recordMiniGamePlay(s, 'farm').state;
    const xp = s.xp;
    const coins = s.coins;
    const r4 = recordMiniGamePlay(s, 'farm');
    expect(r4.rewarded).toBe(false);
    expect(r4.reward.xp).toBe(0);
    expect(r4.state.xp).toBe(xp);
    expect(r4.state.coins).toBe(coins);
    expect(r4.playCount).toBe(4);
    expect(r4.rewardedPlayCount).toBe(3);
  });

  it('3. 5-е прохождение не даёт XP', () => {
    let s = initialState();
    for (let i = 0; i < 4; i += 1) s = recordMiniGamePlay(s, 'farm').state;
    const xp = s.xp;
    const r5 = recordMiniGamePlay(s, 'farm');
    expect(r5.reward.xp).toBe(0);
    expect(r5.state.xp).toBe(xp);
    expect(r5.playCount).toBe(5);
    expect(r5.rewardedPlayCount).toBe(3);
    expect(r5.message).toContain('уже получил награду');
  });

  it('разные мини-игры имеют отдельные лимиты', () => {
    let s = initialState();
    for (let i = 0; i < 3; i += 1) s = recordMiniGamePlay(s, 'farm').state;
    const r = recordMiniGamePlay(s, 'fishing');
    expect(r.rewarded).toBe(true);
    expect(r.reward.xp).toBeGreaterThan(0);
  });
});
