import 'package:flutter/material.dart';
import 'package:readquest/features/mini_games/games/mini_game_base.dart';

/// Открывает сундук выравниванием букв пароля.
class OpenChestGame extends MiniGameBoard {
  const OpenChestGame({required super.onScore, required super.onNeedRead, super.key});
  @override State<OpenChestGame> createState() => _OpenChestGameState();
}
class _OpenChestGameState extends State<OpenChestGame> {
  final _password = 'ключ', _alphabet = ['к', 'л', 'ю', 'ч', 'а']; late List<int> _rings = List.filled(4, 4); bool _open = false;
  void _turn(int i) { setState(() => _rings[i] = (_rings[i] + 1) % _alphabet.length); if (_rings.map((n) => _alphabet[n]).join() == _password) { setState(() => _open = true); widget.onNeedRead(MiniGameChallenges.word('chest_key', 'Прочитай пароль', _password)); widget.onScore(18, 'Сундук открыт!'); } }
  @override Widget build(BuildContext context) => MechanicScaffold(emoji: _open ? '💎' : '🧰', title: 'Открой сундук', subtitle: 'Крути кольца, чтобы собрать пароль.', child: Column(children: [
    Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(4, (i) => InkWell(onTap: () => _turn(i), child: Container(margin: const EdgeInsets.all(4), padding: const EdgeInsets.all(12), decoration: BoxDecoration(border: Border.all(), shape: BoxShape.circle), child: Text(_alphabet[_rings[i]], style: const TextStyle(fontSize: 26))))),
    Text(_open ? 'Сокровище найдено!' : 'Нажимай на кольца'),
  ]));
}
