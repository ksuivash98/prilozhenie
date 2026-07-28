import 'package:flutter/material.dart';
import 'package:readquest/features/mini_games/games/mini_game_base.dart';

/// Расставляет книги по полкам, читая названия.
class LibraryGame extends MiniGameBoard {
  const LibraryGame({required super.onScore, required super.onNeedRead, super.key});
  @override State<LibraryGame> createState() => _LibraryGameState();
}
class _LibraryGameState extends State<LibraryGame> {
  final _books = ['сказка', 'карта', 'звери']; String? _selected; int _placed = 0;
  void _shelf(String kind) { if (_selected == null || (_selected == 'сказка') != (kind == 'Сказки')) return; widget.onNeedRead(MiniGameChallenges.word('library_$_placed', 'Прочитай название книги', _selected!)); setState(() { _selected = null; _placed++; }); if (_placed == 3) widget.onScore(18, 'Библиотека в порядке!'); }
  @override Widget build(BuildContext context) => MechanicScaffold(emoji: '📚', title: 'Библиотека', subtitle: 'Выбери книгу, затем положи на подходящую полку.', child: Column(children: [
    Wrap(spacing: 8, children: _books.map((b) => ChoiceChip(label: Text('📖 $b'), selected: _selected == b, onSelected: _placed < 3 ? (_) => setState(() => _selected = b) : null)).toList()),
    const SizedBox(height: 10), Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: ['Сказки', 'Не сказки'].map((s) => ElevatedButton(onPressed: () => _shelf(s), child: Text('🗄️ $s'))).toList()),
  ]));
}
