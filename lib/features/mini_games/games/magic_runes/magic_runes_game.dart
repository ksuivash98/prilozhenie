import 'package:flutter/material.dart';
import 'package:readquest/features/mini_games/games/mini_game_base.dart';

/// Активирует магические руны в прочитанной последовательности.
class MagicRunesGame extends MiniGameBoard {
  const MagicRunesGame({required super.onScore, required super.onNeedRead, super.key});
  @override State<MagicRunesGame> createState() => _MagicRunesGameState();
}
class _MagicRunesGameState extends State<MagicRunesGame> with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(vsync: this, duration: const Duration(milliseconds: 500))..repeat(reverse: true);
  final _runes = ['РУ', 'НА', '✨']; int _at = 0;
  @override void dispose() { _pulse.dispose(); super.dispose(); }
  void _tap(int i) { if (i != _at) return setState(() => _at = 0); setState(() => _at++); if (_at == 3) { widget.onNeedRead(MiniGameChallenges.word('rune_word', 'Прочитай порядок рун', 'руна')); widget.onScore(18, 'Круг рун засиял!'); } }
  @override Widget build(BuildContext context) => MechanicScaffold(emoji: '🔮', title: 'Магические руны', subtitle: 'Активируй РУ → НА → ✨.', child: AnimatedBuilder(animation: _pulse, builder: (_, __) => Wrap(alignment: WrapAlignment.center, children: List.generate(3, (i) => Transform.scale(scale: i == _at ? 1 + _pulse.value * .12 : 1, child: Padding(padding: const EdgeInsets.all(8), child: OutlinedButton(onPressed: _at < 3 ? () => _tap(i) : null, child: Text(_runes[i], style: const TextStyle(fontSize: 22))))))));
}
