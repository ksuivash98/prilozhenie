import 'package:equatable/equatable.dart';

/// Стадия эволюции дракона.
enum DragonStage {
  egg,
  baby,
  teen,
  adult,
  legendary,
}

/// Внешний вид дракона — всё открывается чтением.
class DragonAppearance extends Equatable {
  const DragonAppearance({
    this.colorId = 'coral',
    this.wingsId = 'basic',
    this.hornsId = 'none',
    this.eyesId = 'amber',
    this.armorId = 'none',
    this.accessoryId = 'none',
  });

  final String colorId;
  final String wingsId;
  final String hornsId;
  final String eyesId;
  final String armorId;
  final String accessoryId;

  DragonAppearance copyWith({
    String? colorId,
    String? wingsId,
    String? hornsId,
    String? eyesId,
    String? armorId,
    String? accessoryId,
  }) {
    return DragonAppearance(
      colorId: colorId ?? this.colorId,
      wingsId: wingsId ?? this.wingsId,
      hornsId: hornsId ?? this.hornsId,
      eyesId: eyesId ?? this.eyesId,
      armorId: armorId ?? this.armorId,
      accessoryId: accessoryId ?? this.accessoryId,
    );
  }

  Map<String, dynamic> toMap() => {
        'colorId': colorId,
        'wingsId': wingsId,
        'hornsId': hornsId,
        'eyesId': eyesId,
        'armorId': armorId,
        'accessoryId': accessoryId,
      };

  factory DragonAppearance.fromMap(Map<dynamic, dynamic> map) {
    return DragonAppearance(
      colorId: map['colorId'] as String? ?? 'coral',
      wingsId: map['wingsId'] as String? ?? 'basic',
      hornsId: map['hornsId'] as String? ?? 'none',
      eyesId: map['eyesId'] as String? ?? 'amber',
      armorId: map['armorId'] as String? ?? 'none',
      accessoryId: map['accessoryId'] as String? ?? 'none',
    );
  }

  @override
  List<Object?> get props =>
      [colorId, wingsId, hornsId, eyesId, armorId, accessoryId];
}

/// Дракон-спутник ребёнка.
class Dragon extends Equatable {
  const Dragon({
    required this.id,
    required this.name,
    required this.stage,
    required this.xp,
    required this.happiness,
    required this.hunger,
    required this.appearance,
    required this.unlockedParts,
  });

  final String id;
  final String name;
  final DragonStage stage;
  final int xp;
  final double happiness;
  final double hunger;
  final DragonAppearance appearance;
  final Set<String> unlockedParts;

  /// XP, необходимый для следующей стадии.
  int get xpToNextStage => switch (stage) {
        DragonStage.egg => 50,
        DragonStage.baby => 200,
        DragonStage.teen => 600,
        DragonStage.adult => 1500,
        DragonStage.legendary => 0,
      };

  /// Прогресс до следующей стадии (0..1).
  double get stageProgress {
    final need = xpToNextStage;
    if (need <= 0) return 1;
    return (xp / need).clamp(0.0, 1.0);
  }

  Dragon copyWith({
    String? name,
    DragonStage? stage,
    int? xp,
    double? happiness,
    double? hunger,
    DragonAppearance? appearance,
    Set<String>? unlockedParts,
  }) {
    return Dragon(
      id: id,
      name: name ?? this.name,
      stage: stage ?? this.stage,
      xp: xp ?? this.xp,
      happiness: happiness ?? this.happiness,
      hunger: hunger ?? this.hunger,
      appearance: appearance ?? this.appearance,
      unlockedParts: unlockedParts ?? this.unlockedParts,
    );
  }

  /// Стартовый дракон (яйцо).
  factory Dragon.initial({String name = 'Искорка'}) {
    return Dragon(
      id: 'dragon_main',
      name: name,
      stage: DragonStage.egg,
      xp: 0,
      happiness: 0.8,
      hunger: 0.5,
      appearance: const DragonAppearance(),
      unlockedParts: const {'coral', 'basic', 'amber', 'none'},
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'stage': stage.name,
        'xp': xp,
        'happiness': happiness,
        'hunger': hunger,
        'appearance': appearance.toMap(),
        'unlockedParts': unlockedParts.toList(),
      };

  factory Dragon.fromMap(Map<dynamic, dynamic> map) {
    return Dragon(
      id: map['id'] as String? ?? 'dragon_main',
      name: map['name'] as String? ?? 'Искорка',
      stage: DragonStage.values.firstWhere(
        (s) => s.name == map['stage'],
        orElse: () => DragonStage.egg,
      ),
      xp: map['xp'] as int? ?? 0,
      happiness: (map['happiness'] as num?)?.toDouble() ?? 0.8,
      hunger: (map['hunger'] as num?)?.toDouble() ?? 0.5,
      appearance: DragonAppearance.fromMap(
        map['appearance'] as Map<dynamic, dynamic>? ?? {},
      ),
      unlockedParts: {
        ...((map['unlockedParts'] as List<dynamic>?)?.cast<String>() ??
            const <String>[]),
      },
    );
  }

  @override
  List<Object?> get props =>
      [id, name, stage, xp, happiness, hunger, appearance, unlockedParts];
}
