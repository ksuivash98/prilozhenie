import 'package:equatable/equatable.dart';
import 'package:readquest/core/constants/game_constants.dart';

/// Тип здания города.
enum BuildingType {
  house,
  park,
  library,
  tower,
  fountain,
  school,
  port,
  castle,
}

/// Здание в городе игрока.
class CityBuilding extends Equatable {
  const CityBuilding({
    required this.id,
    required this.type,
    required this.name,
    required this.description,
    required this.unlockWordsRequired,
    required this.isUnlocked,
    required this.level,
    required this.featureUnlock,
  });

  final String id;
  final BuildingType type;
  final String name;
  final String description;
  final int unlockWordsRequired;
  final bool isUnlocked;
  final int level;

  /// Какую игровую возможность открывает здание.
  final String featureUnlock;

  CityBuilding copyWith({bool? isUnlocked, int? level}) {
    return CityBuilding(
      id: id,
      type: type,
      name: name,
      description: description,
      unlockWordsRequired: unlockWordsRequired,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      level: level ?? this.level,
      featureUnlock: featureUnlock,
    );
  }

  @override
  List<Object?> get props => [id, type, isUnlocked, level];
}

/// Каталог зданий.
abstract final class CityCatalog {
  static const List<CityBuilding> buildings = [
    CityBuilding(
      id: BuildingIds.house,
      type: BuildingType.house,
      name: 'Дом',
      description: 'Уютный дом героя. Здесь отдыхает дракон.',
      unlockWordsRequired: 0,
      isUnlocked: true,
      level: 1,
      featureUnlock: 'dragon_rest',
    ),
    CityBuilding(
      id: BuildingIds.park,
      type: BuildingType.park,
      name: 'Парк',
      description: 'Игровые площадки и бабочки из прочитанных слов.',
      unlockWordsRequired: 30,
      isUnlocked: false,
      level: 0,
      featureUnlock: 'mini_games_park',
    ),
    CityBuilding(
      id: BuildingIds.library,
      type: BuildingType.library,
      name: 'Библиотека',
      description: 'Все прочитанные рассказы живут здесь.',
      unlockWordsRequired: 80,
      isUnlocked: false,
      level: 0,
      featureUnlock: 'library',
    ),
    CityBuilding(
      id: BuildingIds.tower,
      type: BuildingType.tower,
      name: 'Башня',
      description: 'Башня знаний открывает сложные слова.',
      unlockWordsRequired: 150,
      isUnlocked: false,
      level: 0,
      featureUnlock: 'knowledge_tower',
    ),
    CityBuilding(
      id: BuildingIds.fountain,
      type: BuildingType.fountain,
      name: 'Фонтан',
      description: 'Магический фонтан восстанавливает мир быстрее.',
      unlockWordsRequired: 220,
      isUnlocked: false,
      level: 0,
      featureUnlock: 'world_boost',
    ),
    CityBuilding(
      id: BuildingIds.school,
      type: BuildingType.school,
      name: 'Школа',
      description: 'Тренировки с Луми и адаптивные уроки.',
      unlockWordsRequired: 300,
      isUnlocked: false,
      level: 0,
      featureUnlock: 'adaptive_lessons',
    ),
    CityBuilding(
      id: BuildingIds.port,
      type: BuildingType.port,
      name: 'Порт',
      description: 'Корабли ведут к новым островам.',
      unlockWordsRequired: 400,
      isUnlocked: false,
      level: 0,
      featureUnlock: 'ship_voyage',
    ),
    CityBuilding(
      id: BuildingIds.castle,
      type: BuildingType.castle,
      name: 'Замок',
      description: 'Сердце города. Открывает финальные главы.',
      unlockWordsRequired: 600,
      isUnlocked: false,
      level: 0,
      featureUnlock: 'final_chapters',
    ),
  ];
}

/// Состояние города.
class CityState extends Equatable {
  const CityState({
    required this.buildings,
    required this.beautyScore,
  });

  final List<CityBuilding> buildings;
  final double beautyScore;

  int get unlockedCount => buildings.where((b) => b.isUnlocked).length;

  factory CityState.initial() {
    return const CityState(
      buildings: CityCatalog.buildings,
      beautyScore: 0.2,
    );
  }

  CityState copyWith({
    List<CityBuilding>? buildings,
    double? beautyScore,
  }) {
    return CityState(
      buildings: buildings ?? this.buildings,
      beautyScore: beautyScore ?? this.beautyScore,
    );
  }

  @override
  List<Object?> get props => [buildings, beautyScore];
}
