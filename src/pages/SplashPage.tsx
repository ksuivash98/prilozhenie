import { useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { useGame } from '../game/store';

export function SplashPage() {
  const navigate = useNavigate();
  const { state } = useGame();

  useEffect(() => {
    const t = window.setTimeout(() => {
      navigate(state.onboardingDone ? '/home' : '/onboarding', { replace: true });
    }, 1800);
    return () => window.clearTimeout(t);
  }, [navigate, state.onboardingDone]);

  return (
    <div className="page center" style={{ paddingTop: '18vh' }}>
      <div style={{ fontSize: '5rem', animation: 'bounceSoft 1.4s ease-in-out infinite' }}>
        🥚
      </div>
      <h1 className="brand">ReadQuest</h1>
      <p className="slogan">Чтение превращается в настоящее приключение.</p>
    </div>
  );
}
