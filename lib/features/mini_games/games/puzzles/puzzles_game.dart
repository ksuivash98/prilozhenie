import 'package:flutter/material.dart';
import 'package:readquest/features/mini_games/games/mini_game_base.dart';

/// Собирает двухмерный пазл из слоговых плиток.
class PuzzlesGame extends MiniGameBoard {
  const PuzzlesGame({required super.onScore, required super.onNeedRead, super.key});
  @override State<PuzzlesGame> createState() => _PuzzlesGameState();
}
class _PuzzlesGameState extends State<PuzzlesGame> {
  var _tiles = ['ва', 'со', 'ко', 'ва']; int? _picked;
  void _tap(int i) { if (_picked == null) return setState(() => _picked = i); if ((_picked! - i).abs() != 1 && (_picked! - i).abs() != 2) return; setState(() { final t = _tiles[i]; _tiles[i] = _tiles[_picked!]; _tiles[_picked!] = t; _picked = null; }); if (_tiles.join() == 'со-ва'.replaceAll('-', '') + 'ко-ва'.replaceAll('-', '')) { widget.onNeedRead(MiniGameChallenges.word('puzzle_sova', 'Прочитай слово пазла', 'сова')); widget.onScore(16, 'Пазл собран!'); } }
  @override Widget build(BuildContext context) => MechanicScaffold(emoji: '🧩', title: 'Пазл слогов', subtitle: 'Меняй соседние плитки, начиная со слова «сова».', child: GridView.count(shrinkWrap: true, crossAxisCount: 2, children: List.generate(4, (i) => GestureDetector(onTap: () => _tap(i), child: Card(color: _picked == i ? Colors.amber : null, child: Center(child: Text(_tiles[i], style: const TextStyle(fontSize: 26))))))));
}
