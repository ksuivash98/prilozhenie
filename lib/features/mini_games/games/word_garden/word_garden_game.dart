import 'package:flutter/material.dart';
import 'package:readquest/features/mini_games/games/mini_game_base.dart';

/// Выращивает цветы кнопками со словами.
class WordGardenGame extends MiniGameBoard {
  const WordGardenGame({required super.onScore, required super.onNeedRead, super.key});
  @override State<WordGardenGame> createState() => _WordGardenGameState();
}
class _WordGardenGameState extends State<WordGardenGame> {
  int _grown = 0;
  void _water(String word) { if (word != 'цветок') return; setState(() => _grown++); widget.onNeedRead(MiniGameChallenges.word('garden_flower', 'Прочитай воду-слово', word)); if (_grown == 3) widget.onScore(15, 'Сад расцвёл!'); }
  @override Widget build(BuildContext context) => MechanicScaffold(emoji: '🌷', title: 'Сад слов', subtitle: 'Полей цветы словом «цветок».', child: Column(children: [
    AnimatedScale(scale: 1 + _grown * .1, duration: const Duration(milliseconds: 250), child: Text(List.filled(3 - _grown.clamp(0, 3) as int, '🌱').join() + List.filled(_grown.clamp(0, 3) as int, '🌸').join(), style: const TextStyle(fontSize: 36))),
    Wrap(spacing: 8, children: ['цветок', 'камень', 'дождь'].map((w) => FilledButton(onPressed: _grown < 3 ? () => _water(w) : null, child: Text(w))).toList()),
  ]));
}
