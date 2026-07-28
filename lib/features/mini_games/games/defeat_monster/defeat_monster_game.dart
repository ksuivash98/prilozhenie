import 'package:flutter/material.dart';
import 'package:readquest/features/mini_games/games/mini_game_base.dart';

/// Побеждает монстра силой длинных прочитанных слов.
class DefeatMonsterGame extends MiniGameBoard {
  const DefeatMonsterGame({required super.onScore, required super.onNeedRead, super.key});
  @override State<DefeatMonsterGame> createState() => _DefeatMonsterGameState();
}
class _DefeatMonsterGameState extends State<DefeatMonsterGame> {
  int _hp = 20, _combo = 0; final _words = const ['луч', 'смелость', 'дракон'];
  void _hit(String word) { final dmg = word.length; setState(() { _hp = (_hp - dmg).clamp(0, 20) as int; _combo++; }); widget.onNeedRead(MiniGameChallenges.word('monster_$word', 'Прочитай заклинание удара', word)); if (_hp == 0) widget.onScore(20 + _combo, 'Монстр побеждён комбо $_combo!'); }
  @override Widget build(BuildContext context) => MechanicScaffold(emoji: '👾', title: 'Победи монстра', subtitle: 'Длинное слово наносит больше урона.', child: Column(children: [
    Text('❤️ ${List.filled(_hp, '█').join()}${List.filled(20 - _hp, '░').join()}', style: const TextStyle(color: Colors.red)),
    Text('Комбо: $_combo 🔥'), Wrap(spacing: 8, children: _words.map((w) => FilledButton(onPressed: _hp > 0 ? () => _hit(w) : null, child: Text(w))).toList()),
  ]));
}
