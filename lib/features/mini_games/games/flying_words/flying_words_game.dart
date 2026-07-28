import 'dart:math';
import 'package:flutter/material.dart';
import 'package:readquest/features/mini_games/games/mini_game_base.dart';

/// Ловит правильное слово среди летающих облаков.
class FlyingWordsGame extends MiniGameBoard {
  const FlyingWordsGame({required super.onScore, required super.onNeedRead, super.key});
  @override State<FlyingWordsGame> createState() => _FlyingWordsGameState();
}
class _FlyingWordsGameState extends State<FlyingWordsGame> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat(reverse: true);
  final _words = ['облако', 'ворона', 'ветер']; bool _done = false;
  @override void dispose() { _controller.dispose(); super.dispose(); }
  void _tap(String word) { if (word != 'облако' || _done) return; setState(() => _done = true); widget.onNeedRead(MiniGameChallenges.word('flying_cloud', 'Прочитай слово на облаке', word)); widget.onScore(13, 'Облако поймано!'); }
  @override Widget build(BuildContext context) => MechanicScaffold(emoji: '🪽', title: 'Летающие слова', subtitle: 'Поймай слово «облако».', child: SizedBox(height: 120, child: AnimatedBuilder(animation: _controller, builder: (_, __) => Stack(children: List.generate(_words.length, (i) => Transform.translate(offset: Offset(sin(_controller.value * pi * 2 + i) * 38, i * 36), child: Align(alignment: Alignment.topCenter, child: ActionChip(label: Text('☁️ ${_words[i]}'), onPressed: () => _tap(_words[i]))))))));
}
