import 'package:flutter/material.dart';
import 'package:readquest/features/mini_games/games/mini_game_base.dart';

/// Проводит игрока по лабиринту чтением указателей.
class LabyrinthGame extends MiniGameBoard {
  const LabyrinthGame({required super.onScore, required super.onNeedRead, super.key});
  @override State<LabyrinthGame> createState() => _LabyrinthGameState();
}
class _LabyrinthGameState extends State<LabyrinthGame> {
  final _route = ['право', 'вверх', 'лево']; int _step = 0;
  void _move(String dir) { if (dir != _route[_step]) return; widget.onNeedRead(MiniGameChallenges.word('maze_$_step', 'Прочитай указатель', dir)); setState(() => _step++); if (_step == 3) widget.onScore(20, 'Выход из лабиринта найден!'); }
  @override Widget build(BuildContext context) => MechanicScaffold(emoji: '🌀', title: 'Лабиринт', subtitle: _step < 3 ? 'Указатель: «${_route[_step]}»' : 'Свобода!', child: Column(children: [
    Text('🟩 ${List.filled(_step, '⬜ ').join()}🚪', style: const TextStyle(fontSize: 24)),
    Wrap(spacing: 8, children: ['лево', 'право', 'вверх'].map((d) => OutlinedButton(onPressed: _step < 3 ? () => _move(d) : null, child: Text(d))).toList()),
  ]));
}
