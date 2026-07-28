import 'package:equatable/equatable.dart';

/// Прогресс игрока — центральная агрегирующая сущность.
class PlayerProgress extends Equatable {
  const PlayerProgress({
    required this.playerId,
    required this.displayName,
    required this.level,
    required this.xp,
    required this.coins,
    required this.wordsReadTotal,
    required this.questsCompleted,
    required this.bossesDefeated,
    required this.currentLocationId,
    required this.lastActiveAt,
  });

  final String playerId;
  final String displayName;
  final int level;
  final int xp;
  final int coins;
  final int wordsReadTotal;
  final int questsCompleted;
  final int bossesDefeated;
  final String currentLocationId;
  final DateTime lastActiveAt;

  int get xpForNextLevel => 100 + (level * 50);

  double get levelProgress {
    final need = xpForNextLevel;
    return (xp / need).clamp(0.0, 1.0);
  }

  factory PlayerProgress.initial({String name = 'Герой'}) {
    return PlayerProgress(
      playerId: 'player_1',
      displayName: name,
      level: 1,
      xp: 0,
      coins: 0,
      wordsReadTotal: 0,
      questsCompleted: 0,
      bossesDefeated: 0,
      currentLocationId: 'village',
      lastActiveAt: DateTime.now(),
    );
  }

  PlayerProgress copyWith({
    String? displayName,
    int? level,
    int? xp,
    int? coins,
    int? wordsReadTotal,
    int? questsCompleted,
    int? bossesDefeated,
    String? currentLocationId,
    DateTime? lastActiveAt,
  }) {
    return PlayerProgress(
      playerId: playerId,
      displayName: displayName ?? this.displayName,
      level: level ?? this.level,
      xp: xp ?? this.xp,
      coins: coins ?? this.coins,
      wordsReadTotal: wordsReadTotal ?? this.wordsReadTotal,
      questsCompleted: questsCompleted ?? this.questsCompleted,
      bossesDefeated: bossesDefeated ?? this.bossesDefeated,
      currentLocationId: currentLocationId ?? this.currentLocationId,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
    );
  }

  Map<String, dynamic> toMap() => {
        'playerId': playerId,
        'displayName': displayName,
        'level': level,
        'xp': xp,
        'coins': coins,
        'wordsReadTotal': wordsReadTotal,
        'questsCompleted': questsCompleted,
        'bossesDefeated': bossesDefeated,
        'currentLocationId': currentLocationId,
        'lastActiveAt': lastActiveAt.toIso8601String(),
      };

  factory PlayerProgress.fromMap(Map<dynamic, dynamic> map) {
    return PlayerProgress(
      playerId: map['playerId'] as String? ?? 'player_1',
      displayName: map['displayName'] as String? ?? 'Герой',
      level: map['level'] as int? ?? 1,
      xp: map['xp'] as int? ?? 0,
      coins: map['coins'] as int? ?? 0,
      wordsReadTotal: map['wordsReadTotal'] as int? ?? 0,
      questsCompleted: map['questsCompleted'] as int? ?? 0,
      bossesDefeated: map['bossesDefeated'] as int? ?? 0,
      currentLocationId: map['currentLocationId'] as String? ?? 'village',
      lastActiveAt:
          DateTime.tryParse(map['lastActiveAt'] as String? ?? '') ??
              DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [
        playerId,
        displayName,
        level,
        xp,
        coins,
        wordsReadTotal,
        questsCompleted,
        bossesDefeated,
        currentLocationId,
      ];
}
