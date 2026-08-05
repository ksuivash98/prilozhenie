import { useMemo, type ReactNode } from 'react';

interface LivingBackgroundProps {
  vitality: number;
  children?: ReactNode;
}

export function LivingBackground({ vitality, children }: LivingBackgroundProps) {
  const clouds = useMemo(
    () =>
      Array.from({ length: 5 }, (_, i) => ({
        id: i,
        top: 8 + i * 12,
        width: 110 + i * 28,
        height: 34 + (i % 2) * 10,
        duration: 28 + i * 6,
        delay: -i * 5,
      })),
    [],
  );

  const sparks = useMemo(
    () =>
      Array.from({ length: Math.round(6 + vitality * 14) }, (_, i) => ({
        id: i,
        left: (i * 17) % 100,
        top: (i * 23) % 90,
        delay: (i % 5) * 0.4,
      })),
    [vitality],
  );

  return (
    <div className="app-shell">
      <div className={`living-bg ${vitality < 0.3 ? 'gray' : ''}`}>
        {clouds.map((c) => (
          <div
            key={c.id}
            className="cloud"
            style={{
              top: `${c.top}%`,
              width: c.width,
              height: c.height,
              animationDuration: `${c.duration}s`,
              animationDelay: `${c.delay}s`,
            }}
          />
        ))}
        {vitality >= 0.25 &&
          sparks.map((s) => (
            <span
              key={s.id}
              className="spark"
              style={{
                left: `${s.left}%`,
                top: `${s.top}%`,
                animationDelay: `${s.delay}s`,
              }}
            />
          ))}
      </div>
      {children}
    </div>
  );
}
