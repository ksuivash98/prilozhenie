import 'package:flutter/material.dart';
import 'package:readquest/features/mini_games/games/mini_game_base.dart';

/// Прокладывает светящуюся дорожку через лес словами.
class MagicForestGame extends MiniGameBoard {
  const MagicForestGame({required super.onScore, required super.onNeedRead, super.key});
  @override State<MagicForestGame> createState() => _MagicForestGameState();
}
class _MagicForestGameState extends State<MagicForestGame> {
  int _step = 0; final _answers = ['тропа', 'туман', 'камень'];
  void _choose(String s) { if (s != 'тропа') return; setState(() => _step++); widget.onNeedRead(MiniGameChallenges.word('forest_path', 'Прочитай слово для света', s)); if (_step == 4) widget.onScore(19, 'Тропа в лесу открыта!'); }
  @override Widget build(BuildContext context) => MechanicScaffold(emoji: '🌲', title: 'Магический лес', subtitle: 'Освети следующий камень словом «тропа».', child: Column(children: [
    Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(4, (i) => Text(i < _step ? '💡' : '🌫️', style: const TextStyle(fontSize: 32)))),
    Wrap(spacing: 8, children: _answers.map((s) => OutlinedButton(onPressed: _step < 4 ? () => _choose(s) : null, child: Text(s))).toList()),
  ]));
}
