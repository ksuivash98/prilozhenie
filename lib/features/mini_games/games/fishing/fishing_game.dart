import 'package:flutter/material.dart';
import 'package:readquest/features/mini_games/games/mini_game_base.dart';

/// Ловит буквы движущимся крючком и собирает слово.
class FishingGame extends MiniGameBoard {
  const FishingGame({required super.onScore, required super.onNeedRead, super.key});
  @override State<FishingGame> createState() => _FishingGameState();
}
class _FishingGameState extends State<FishingGame> {
  final _word = 'рыба'; int _hook = 0, _caught = 0;
  void _cast() { if (_hook == _caught) setState(() => _caught++); setState(() => _hook = (_hook + 1) % 4); if (_caught == 4) { widget.onNeedRead(MiniGameChallenges.word('fish_word', 'Прочитай улов', _word)); widget.onScore(17, 'Слово выловлено!'); } }
  @override Widget build(BuildContext context) => MechanicScaffold(emoji: '🎣', title: 'Рыбалка букв', subtitle: 'Нажми «заброс», когда крючок под нужной буквой.', child: Column(children: [
    Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: List.generate(4, (i) => Text(_word[i], style: TextStyle(fontSize: 34, color: i == _hook ? Colors.red : Colors.blue)))),
    const SizedBox(height: 18), FilledButton(onPressed: _caught < 4 ? _cast : null, child: const Text('Забросить крючок')),
    Text('В корзине: ${_word.substring(0, _caught.clamp(0, 4) as int)}'),
  ]));
}
