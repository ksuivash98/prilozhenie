import 'package:flutter/material.dart';
import 'package:readquest/features/mini_games/games/mini_game_base.dart';

/// Кует меч ударами молота в такт слогам.
class ForgeGame extends MiniGameBoard {
  const ForgeGame({required super.onScore, required super.onNeedRead, super.key});
  @override State<ForgeGame> createState() => _ForgeGameState();
}
class _ForgeGameState extends State<ForgeGame> {
  int _heat = 0, _beat = 0;
  void _hammer() { if (_heat < 2) return; setState(() { _heat = 0; _beat++; }); if (_beat == 3) { widget.onNeedRead(MiniGameChallenges.word('forge_sword', 'Прочитай выкованное слово', 'меч')); widget.onScore(19, 'Меч выкован!'); } }
  @override Widget build(BuildContext context) => MechanicScaffold(emoji: '⚒️', title: 'Кузница', subtitle: 'Разогрей металл, затем ударь по слогу.', child: Column(children: [
    LinearProgressIndicator(value: _heat / 2, color: Colors.orange), Text('Такт: $_beat/3'),
    Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [FilledButton(onPressed: () => setState(() => _heat = (_heat + 1).clamp(0, 2) as int), child: const Text('🔥 Нагреть')), FilledButton(onPressed: _beat < 3 ? _hammer : null, child: const Text('🔨 Ударить'))]),
  ]));
}
