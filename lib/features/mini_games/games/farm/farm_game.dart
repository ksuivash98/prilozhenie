import 'package:flutter/material.dart';
import 'package:readquest/features/mini_games/games/mini_game_base.dart';

/// Выращивает слово, поливая посаженные слоги.
class FarmGame extends MiniGameBoard {
  const FarmGame({required super.onScore, required super.onNeedRead, super.key});
  @override State<FarmGame> createState() => _FarmGameState();
}
class _FarmGameState extends State<FarmGame> {
  final _syllables = ['ма', 'ма', 'лу']; final _watered = <int>{};
  void _water(int i) { if (i > 0 && !_watered.contains(i - 1)) return; setState(() => _watered.add(i)); if (_watered.length == 2) { widget.onNeedRead(MiniGameChallenges.word('farm_mama', 'Прочитай урожай', 'мама')); widget.onScore(14, 'Урожай созрел!'); } }
  @override Widget build(BuildContext context) => MechanicScaffold(emoji: '🌱', title: 'Словесная ферма', subtitle: 'Поливай грядки со слогами слова «мама».', child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: List.generate(3, (i) => GestureDetector(onTap: () => _water(i), child: Column(children: [Text(_watered.contains(i) ? '🌻' : '🟫', style: const TextStyle(fontSize: 38)), Text(_syllables[i])])))));
}
