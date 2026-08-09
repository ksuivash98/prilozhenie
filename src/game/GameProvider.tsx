import { useEffect, useMemo, useState, type ReactNode } from 'react';
import { GameContext, applyTimeDecay, loadState, saveState } from '../game/store';
import type { GameState } from '../game/data';
import { LivingBackground } from '../components/LivingBackground';
import { speechSynthesisService } from '../services/speechSynthesisService';

export function GameProvider({ children }: { children: ReactNode }) {
  const [state, setStateRaw] = useState<GameState>(() => applyTimeDecay(loadState()));

  useEffect(() => {
    saveState(state);
    document.documentElement.classList.toggle('high-contrast', state.highContrast);
    document.documentElement.classList.toggle('large-text', state.largeText);
    document.documentElement.classList.toggle('reduce-motion', state.reduceMotion);
  }, [state]);

  const value = useMemo(
    () => ({
      state,
      setState: (updater: (s: GameState) => GameState) => {
        setStateRaw((prev) => updater(prev));
      },
      speak: (text: string) => {
        if (!state.soundEnabled) return;
        speechSynthesisService.speak(text);
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
