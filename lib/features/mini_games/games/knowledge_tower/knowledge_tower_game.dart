import 'package:flutter/material.dart';
import 'package:readquest/features/mini_games/games/mini_game_base.dart';

/// Поднимает героя на башню за правильные слова.
class KnowledgeTowerGame extends MiniGameBoard {
  const KnowledgeTowerGame({required super.onScore, required super.onNeedRead, super.key});
  @override State<KnowledgeTowerGame> createState() => _KnowledgeTowerGameState();
}
class _KnowledgeTowerGameState extends State<KnowledgeTowerGame> {
  final _floors = ['дом', 'сова', 'смелость']; int _floor = 0;
  void _answer(String w) { if (w != _floors[_floor]) return; widget.onNeedRead(MiniGameChallenges.word('tower_$_floor', 'Прочитай слово этажа', w)); setState(() => _floor++); if (_floor == 3) widget.onScore(21, 'Ты на вершине башни!'); }
  @override Widget build(BuildContext context) => MechanicScaffold(emoji: '🗼', title: 'Башня знаний', subtitle: 'Выбирай слово для следующего этажа.', child: Column(children: [
    ...List.generate(3, (i) => Text(i < _floor ? '🏆 ${_floors[i]}' : '🧱 этаж ${i + 1}', style: const TextStyle(fontSize: 20))),
    Wrap(spacing: 8, children: ['дом', 'сова', 'смелость', 'туча'].map((w) => FilledButton(onPressed: _floor < 3 ? () => _answer(w) : null, child: Text(w))).toList()),
  ]));
}
