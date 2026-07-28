import 'package:flutter/material.dart';
import 'package:readquest/features/mini_games/games/mini_game_base.dart';

/// Освобождает существо сбором слогов заклинания.
class SaveCreatureGame extends MiniGameBoard {
  const SaveCreatureGame({required super.onScore, required super.onNeedRead, super.key});
  @override State<SaveCreatureGame> createState() => _SaveCreatureGameState();
}
class _SaveCreatureGameState extends State<SaveCreatureGame> {
  final _spell = ['дру', 'жба']; int _at = 0;
  void _collect(String s) { if (s != _spell[_at]) return; setState(() => _at++); if (_at == 2) { widget.onNeedRead(MiniGameChallenges.word('rescue_friendship', 'Прочитай заклинание свободы', 'дружба')); widget.onScore(22, 'Существо свободно!'); } }
  @override Widget build(BuildContext context) => MechanicScaffold(emoji: _at == 2 ? '🐿️' : '🦋', title: 'Спаси существо', subtitle: 'Собери слоги «дру» и «жба» по порядку.', child: Column(children: [
    Text(_at == 2 ? '✨ Клетка сломана!' : '🗝️ ${List.filled(2 - _at, '🔒').join()}'),
    Wrap(spacing: 8, children: ['дру', 'ба', 'жба'].map((s) => FilledButton(onPressed: _at < 2 ? () => _collect(s) : null, child: Text(s))).toList()),
  ]));
}
