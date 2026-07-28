import 'package:equatable/equatable.dart';
import 'package:readquest/features/adventure/domain/entities/adventure_location.dart';

/// Глобальное состояние мира — оживает от чтения.
class WorldState extends Equatable {
  const WorldState({
    required this.vitalityScore,
    required this.lastReadAt,
    required this.unlockedLocationIds,
    required this.restoredEffects,
    required this.totalWordsRead,
    required this.chapterIndex,
  });

  /// 0.0 = серый мир, 1.0 = полностью живой.
  final double vitalityScore;
  final DateTime lastReadAt;
  final Set<String> unlockedLocationIds;
  final Set<String> restoredEffects;
  final int totalWordsRead;
  final int chapterIndex;

  WorldVitality get vitalityLevel {
    if (vitalityScore >= 0.75) return WorldVitality.thriving;
    if (vitalityScore >= 0.45) return WorldVitality.alive;
    if (vitalityScore >= 0.2) return WorldVitality.fading;
    return WorldVitality.gray;
  }

  WorldState copyWith({
    double? vitalityScore,
    DateTime? lastReadAt,
    Set<String>? unlockedLocationIds,
    Set<String>? restoredEffects,
    int? totalWordsRead,
    int? chapterIndex,
  }) {
    return WorldState(
      vitalityScore: vitalityScore ?? this.vitalityScore,
      lastReadAt: lastReadAt ?? this.lastReadAt,
      unlockedLocationIds: unlockedLocationIds ?? this.unlockedLocationIds,
      restoredEffects: restoredEffects ?? this.restoredEffects,
      totalWordsRead: totalWordsRead ?? this.totalWordsRead,
      chapterIndex: chapterIndex ?? this.chapterIndex,
    );
  }

  factory WorldState.initial() {
    return WorldState(
      vitalityScore: 0.55,
      lastReadAt: DateTime.now(),
      unlockedLocationIds: const {'village'},
      restoredEffects: const {},
      totalWordsRead: 0,
      chapterIndex: 0,
    );
  }

  Map<String, dynamic> toMap() => {
        'vitalityScore': vitalityScore,
        'lastReadAt': lastReadAt.toIso8601String(),
        'unlockedLocationIds': unlockedLocationIds.toList(),
        'restoredEffects': restoredEffects.toList(),
        'totalWordsRead': totalWordsRead,
        'chapterIndex': chapterIndex,
      };

  factory WorldState.fromMap(Map<dynamic, dynamic> map) {
    return WorldState(
      vitalityScore: (map['vitalityScore'] as num?)?.toDouble() ?? 0.55,
      lastReadAt: DateTime.tryParse(map['lastReadAt'] as String? ?? '') ??
          DateTime.now(),
      unlockedLocationIds: {
        ...((map['unlockedLocationIds'] as List<dynamic>?)?.cast<String>() ??
            const ['village']),
      },
      restoredEffects: {
        ...((map['restoredEffects'] as List<dynamic>?)?.cast<String>() ??
            const <String>[]),
      },
      totalWordsRead: map['totalWordsRead'] as int? ?? 0,
      chapterIndex: map['chapterIndex'] as int? ?? 0,
    );
  }

  @override
  List<Object?> get props => [
        vitalityScore,
        lastReadAt,
        unlockedLocationIds,
        restoredEffects,
        totalWordsRead,
        chapterIndex,
      ];
}

/// Визуальный эффект оживления мира.
enum WorldEffect {
  flowersBloom,
  birdsReturn,
  treesAwaken,
  housesBuild,
  villagersAppear,
  rainbow,
  fogClears,
  butterflies,
}

/// Описание эффекта для UI.
extension WorldEffectX on WorldEffect {
  String get label => switch (this) {
        WorldEffect.flowersBloom => 'Цветы распускаются',
        WorldEffect.birdsReturn => 'Птицы возвращаются',
        WorldEffect.treesAwaken => 'Деревья оживают',
        WorldEffect.housesBuild => 'Строятся дома',
        WorldEffect.villagersAppear => 'Появляются жители',
        WorldEffect.rainbow => 'Появляется радуга',
        WorldEffect.fogClears => 'Туман рассеивается',
        WorldEffect.butterflies => 'Бабочки порхают',
      };
}
