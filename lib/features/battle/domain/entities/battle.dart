import 'package:equatable/equatable.dart';

/// Тип врага.
enum EnemyType { monster, miniboss, boss }

/// Враг / босс.
class Enemy extends Equatable {
  const Enemy({
    required this.id,
    required this.name,
    required this.type,
    required this.maxHp,
    required this.locationId,
    required this.introText,
    required this.defeatText,
    this.currentHp,
    this.spriteKey = 'monster_default',
  });

  final String id;
  final String name;
  final EnemyType type;
  final int maxHp;
  final int? currentHp;
  final String locationId;
  final String introText;
  final String defeatText;
  final String spriteKey;

  int get hp => currentHp ?? maxHp;

  double get hpRatio => maxHp == 0 ? 0 : hp / maxHp;

  bool get isDefeated => hp <= 0;

  Enemy copyWith({int? currentHp}) {
    return Enemy(
      id: id,
      name: name,
      type: type,
      maxHp: maxHp,
      currentHp: currentHp ?? this.currentHp,
      locationId: locationId,
      introText: introText,
      defeatText: defeatText,
      spriteKey: spriteKey,
    );
  }

  @override
  List<Object?> get props => [id, name, type, maxHp, hp, locationId];
}

/// Состояние боевой сцены.
class BattleState extends Equatable {
  const BattleState({
    required this.battleId,
    required this.enemy,
    required this.turn,
    required this.playerCombo,
    required this.wordsRead,
    required this.isVictory,
    required this.isDefeat,
  });

  final String battleId;
  final Enemy enemy;
  final int turn;
  final int playerCombo;
  final int wordsRead;
  final bool isVictory;
  final bool isDefeat;

  /// Урон = длина слова * (1 + combo/10), минимум 1.
  static int damageForWord(String word, int combo) {
    final base = word.trim().length.clamp(1, 24);
    final bonus = 1 + (combo / 10);
    return (base * bonus).round().clamp(1, 99);
  }

  BattleState copyWith({
    Enemy? enemy,
    int? turn,
    int? playerCombo,
    int? wordsRead,
    bool? isVictory,
    bool? isDefeat,
  }) {
    return BattleState(
      battleId: battleId,
      enemy: enemy ?? this.enemy,
      turn: turn ?? this.turn,
      playerCombo: playerCombo ?? this.playerCombo,
      wordsRead: wordsRead ?? this.wordsRead,
      isVictory: isVictory ?? this.isVictory,
      isDefeat: isDefeat ?? this.isDefeat,
    );
  }

  @override
  List<Object?> get props =>
      [battleId, enemy, turn, playerCombo, wordsRead, isVictory, isDefeat];
}
