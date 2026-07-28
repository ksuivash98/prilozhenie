import 'package:flutter/material.dart';
import 'package:readquest/features/mini_games/games/mini_game_base.dart';

/// Ищет предмет под туманными плитками по текстовой подсказке.
class FindItemGame extends MiniGameBoard {
  const FindItemGame({required super.onScore, required super.onNeedRead, super.key});
  @override State<FindItemGame> createState() => _FindItemGameState();
}
class _FindItemGameState extends State<FindItemGame> {
  final _items = ['🌲', '🏮', '🍄', '🪨', '🐦', '🌿']; final _open = <int>{};
  void _reveal(int i) { setState(() => _open.add(i)); if (i == 1) { widget.onNeedRead(MiniGameChallenges.word('find_lantern', 'Прочитай подсказку: найди фонарь', 'фонарь')); widget.onScore(16, 'Фонарь освещает путь!'); } }
  @override Widget build(BuildContext context) => MechanicScaffold(emoji: '🔎', title: 'Найди предмет', subtitle: 'Прочитай: «Найди фонарь» и открой туман.', child: GridView.count(shrinkWrap: true, crossAxisCount: 3, children: List.generate(6, (i) => GestureDetector(onTap: () => _reveal(i), child: Card(color: _open.contains(i) ? Colors.amber : Colors.blueGrey, child: Center(child: Text(_open.contains(i) ? _items[i] : '☁️', style: const TextStyle(fontSize: 30)))))));
}
