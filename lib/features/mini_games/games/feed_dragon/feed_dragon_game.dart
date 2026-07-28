import 'package:flutter/material.dart';
import 'package:readquest/features/mini_games/games/mini_game_base.dart';

/// Кормит дракона только после выбора прочитанной еды.
class FeedDragonGame extends MiniGameBoard {
  const FeedDragonGame({required super.onScore, required super.onNeedRead, super.key});
  @override State<FeedDragonGame> createState() => _FeedDragonGameState();
}
class _FeedDragonGameState extends State<FeedDragonGame> {
  final _foods = const ['яблоко', 'камень', 'сапог']; int _fed = 0;
  void _feed(String food) {
    if (food != 'яблоко') {
      setState(() => _fed = (_fed - 1).clamp(0, 3));
      return;
    }
    widget.onNeedRead(MiniGameChallenges.word('dragon_food', 'Прочитай еду для дракона', food));
    setState(() => _fed++);
    if (_fed == 3) widget.onScore(15, 'Дракон сыт и счастлив!');
  }
  @override Widget build(BuildContext context) => MechanicScaffold(
    emoji: '🐉', title: 'Накорми дракона', subtitle: 'Нажми на еду, которую он любит.',
    child: Column(children: [
      Text('Голод: ${List.filled(_fed, '🍖').join()}${List.filled(3 - _fed, '▫️').join()}', style: const TextStyle(fontSize: 30)),
      const SizedBox(height: 12),
      Wrap(spacing: 8, children: _foods.map((f) => Draggable<String>(
        data: f, feedback: Material(child: Text('🍎 $f', style: const TextStyle(fontSize: 22))),
        child: ActionChip(avatar: const Text('🍽️'), label: Text(f), onPressed: () => _feed(f)),
      )).toList()),
      DragTarget<String>(onAcceptWithDetails: (d) => _feed(d.data), builder: (_, __, ___) =>
        const Padding(padding: EdgeInsets.all(12), child: Text('Перетащи еду к пасти дракона 👄'))),
    ]),
  );
}
