import 'package:flutter/material.dart';
import 'package:readquest/features/mini_games/games/mini_game_base.dart';

/// Ведёт корабль флагами-словами к острову.
class ShipVoyageGame extends MiniGameBoard {
  const ShipVoyageGame({required super.onScore, required super.onNeedRead, super.key});
  @override State<ShipVoyageGame> createState() => _ShipVoyageGameState();
}
class _ShipVoyageGameState extends State<ShipVoyageGame> {
  int _distance = 0;
  void _flag(String f) { if (f != 'ветер') return; setState(() => _distance++); widget.onNeedRead(MiniGameChallenges.word('ship_wind', 'Прочитай флаг направления', f)); if (_distance == 4) widget.onScore(20, 'Корабль приплыл к острову!'); }
  @override Widget build(BuildContext context) => MechanicScaffold(emoji: '⛵', title: 'Морское путешествие', subtitle: 'Подними флаг «ветер», чтобы плыть к острову.', child: Column(children: [
    Align(alignment: Alignment(-1 + _distance * .5, 0), child: const Text('⛵', style: TextStyle(fontSize: 42))), const Text('🌊🌊🌊🌊🏝️'),
    Wrap(spacing: 8, children: ['ветер', 'штиль', 'туча'].map((f) => OutlinedButton(onPressed: _distance < 4 ? () => _flag(f) : null, child: Text('🚩 $f'))).toList()),
  ]));
}
