import { useEffect, useMemo, useState, type ReactNode } from 'react';
import { GameContext, applyTimeDecay, loadState, saveState } from '../game/store';
import type { GameState } from '../game/data';
import { LivingBackground } from '../components/LivingBackground';

export function GameProvider({ children }: { children: ReactNode }) {
  const [state, setStateRaw] = useState<GameState>(() => applyTimeDecay(loadState()));

  useEffect(() => {
    saveState(state);
  }, [state]);

  const value = useMemo(
    () => ({
      state,
      setState: (updater: (s: GameState) => GameState) => {
        setStateRaw((prev) => updater(prev));
      },
      speak: (text: string) => {
        if (!('speechSynthesis' in window)) return;
        window.speechSynthesis.cancel();
        const u = new SpeechSynthesisUtterance(text);
        u.lang = 'ru-RU';
        u.rate = 0.9;
        window.speechSynthesis.speak(u);
      },
    }),
    [state],
  );

  return (
    <GameContext.Provider value={value}>
      <LivingBackground vitality={state.vitality}>{children}</LivingBackground>
    </GameContext.Provider>
  );
}
