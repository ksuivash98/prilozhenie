import 'package:flutter/material.dart';
import 'package:readquest/features/mini_games/games/mini_game_base.dart';

/// Ловит падающие целевые буквы с анимацией.
class CatchLetterGame extends MiniGameBoard {
  const CatchLetterGame({required super.onScore, required super.onNeedRead, super.key});
  @override State<CatchLetterGame> createState() => _CatchLetterGameState();
}
class _CatchLetterGameState extends State<CatchLetterGame> with SingleTickerProviderStateMixin {
  late final AnimationController _fall = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();
  final _letters = ['Л', 'Р', 'Л', 'М']; int _at = 0, _caught = 0, _misses = 0;
  @override void dispose() { _fall.dispose(); super.dispose(); }
  void _tap() { final correct = _letters[_at] == 'Л'; setState(() { correct ? _caught++ : _misses++; _at = (_at + 1) % _letters.length; }); if (_caught == 3) { widget.onNeedRead(MiniGameChallenges.word('catch_l', 'Прочитай слово с буквой Л', 'лес')); widget.onScore(14, 'Все буквы пойманы!'); } }
  @override Widget build(BuildContext context) => MechanicScaffold(emoji: '🧲', title: 'Поймай букву Л', subtitle: 'Не трогай другие буквы.', child: Column(children: [
    Text('Поймано: $_caught/3 · Промахи: $_misses'),
    SizedBox(height: 150, child: AnimatedBuilder(animation: _fall, builder: (_, __) => Align(
      alignment: Alignment(0, -1 + _fall.value * 2), child: GestureDetector(onTap: _tap, child: CircleAvatar(radius: 28, child: Text(_letters[_at], style: const TextStyle(fontSize: 28))))))),
  ]));
}
