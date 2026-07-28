import 'package:flutter/material.dart';
import 'package:readquest/features/mini_games/games/mini_game_base.dart';

/// Охотится за картинками, чьи слова содержат нужную букву.
class LetterHuntGame extends MiniGameBoard {
  const LetterHuntGame({required super.onScore, required super.onNeedRead, super.key});
  @override State<LetterHuntGame> createState() => _LetterHuntGameState();
}
class _LetterHuntGameState extends State<LetterHuntGame> {
  final _scene = const [('🦉', 'сова'), ('🐱', 'кот'), ('☀️', 'солнце'), ('🐟', 'рыба')]; final _found = <int>{};
  void _hunt(int i) { if (!_scene[i].$2.contains('с')) return; setState(() => _found.add(i)); if (_found.length == 2) { widget.onNeedRead(MiniGameChallenges.word('hunt_s', 'Прочитай найденное слово', 'сова')); widget.onScore(15, 'Ты нашёл все буквы С!'); } }
  @override Widget build(BuildContext context) => MechanicScaffold(emoji: '🔍', title: 'Охота на букву', subtitle: 'Найди картинки со звуком С.', child: Wrap(spacing: 14, runSpacing: 14, children: List.generate(_scene.length, (i) => GestureDetector(onTap: () => _hunt(i), child: Opacity(opacity: _found.contains(i) ? 1 : .65, child: Column(children: [Text(_scene[i].$1, style: const TextStyle(fontSize: 42)), Text(_scene[i].$2)]))))));
}
