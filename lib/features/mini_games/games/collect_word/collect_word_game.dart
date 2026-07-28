import 'package:flutter/material.dart';
import 'package:readquest/features/mini_games/games/mini_game_base.dart';

/// Собирает слово из перемешанных букв.
class CollectWordGame extends MiniGameBoard {
  const CollectWordGame({required super.onScore, required super.onNeedRead, super.key});
  @override State<CollectWordGame> createState() => _CollectWordGameState();
}
class _CollectWordGameState extends State<CollectWordGame> {
  final _word = 'лиса', _letters = ['с', 'а', 'л', 'и']; int _index = 0; bool _wrong = false;
  void _tap(String letter) {
    if (letter != _word[_index]) return setState(() => _wrong = true);
    setState(() { _wrong = false; _index++; });
    if (_index == _word.length) { widget.onNeedRead(MiniGameChallenges.word('collect_word', 'Прочитай собранное слово', _word)); widget.onScore(12, 'Слово собрано!'); }
  }
  @override Widget build(BuildContext context) => MechanicScaffold(emoji: '🔤', title: 'Собери слово', subtitle: 'Нажимай буквы по порядку.', child: Column(children: [
    AnimatedSlide(offset: _wrong ? const Offset(.08, 0) : Offset.zero, duration: const Duration(milliseconds: 90),
      child: Text(_word.substring(0, _index) + List.filled(_word.length - _index, '▢').join(), style: const TextStyle(fontSize: 30))),
    if (_wrong) const Text('Эта буква не следующая!', style: TextStyle(color: Colors.red)),
    Wrap(children: _letters.map((l) => LetterChip(letter: l, selected: _index > _word.indexOf(l), onTap: _index < _word.length ? () => _tap(l) : () {})).toList()),
  ]));
}
