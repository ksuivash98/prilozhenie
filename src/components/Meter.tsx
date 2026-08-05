interface MeterProps {
  label: string;
  value: number;
  trailing?: string;
  variant?: 'default' | 'coral';
}

export function Meter({ label, value, trailing, variant = 'default' }: MeterProps) {
  const pct = Math.max(0, Math.min(1, value)) * 100;
  return (
    <div className="stack" style={{ gap: '0.35rem' }}>
      <div className="row" style={{ justifyContent: 'space-between' }}>
        <strong>{label}</strong>
        {trailing && <span className="muted">{trailing}</span>}
      </div>
      <div className={`meter ${variant === 'coral' ? 'coral' : ''}`}>
        <span style={{ width: `${pct}%` }} />
      </div>
    </div>
  );
}
