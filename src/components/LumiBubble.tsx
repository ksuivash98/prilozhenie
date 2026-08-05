import { LUMI } from '../game/data';

interface LumiBubbleProps {
  tone?: keyof typeof LUMI;
  text?: string;
  seed?: number;
}

export function LumiBubble({ tone = 'greet', text, seed = 0 }: LumiBubbleProps) {
  const list = LUMI[tone];
  const message = text ?? list[seed % list.length];

  return (
    <div className="lumi">
      <div className="lumi-avatar" aria-hidden>
        ✦
      </div>
      <div className="lumi-bubble">{message}</div>
    </div>
  );
}
