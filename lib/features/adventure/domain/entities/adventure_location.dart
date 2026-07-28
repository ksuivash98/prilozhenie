import 'package:equatable/equatable.dart';
import 'package:readquest/core/constants/game_constants.dart';

/// Тип локации мира.
enum LocationType {
  village,
  forest,
  cave,
  castle,
  desert,
  ice,
  volcano,
  sky,
  underwater,
  cosmos,
}

/// Состояние «живости» мира локации.
enum WorldVitality {
  thriving,
  alive,
  fading,
  gray,
}

/// Локация на карте приключений.
class AdventureLocation extends Equatable {
  const AdventureLocation({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.order,
    required this.isUnlocked,
    required this.completionPercent,
    required this.bossId,
    required this.questIds,
    required this.secretIds,
    required this.mapX,
    required this.mapY,
    this.vitality = WorldVitality.alive,
  });

  final String id;
  final String name;
  final String description;
  final LocationType type;
  final int order;
  final bool isUnlocked;
  final double completionPercent;
  final String bossId;
  final List<String> questIds;
  final List<String> secretIds;
  final double mapX;
  final double mapY;
  final WorldVitality vitality;

  AdventureLocation copyWith({
    bool? isUnlocked,
    double? completionPercent,
    WorldVitality? vitality,
  }) {
    return AdventureLocation(
      id: id,
      name: name,
      description: description,
      type: type,
      order: order,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      completionPercent: completionPercent ?? this.completionPercent,
      bossId: bossId,
      questIds: questIds,
      secretIds: secretIds,
      mapX: mapX,
      mapY: mapY,
      vitality: vitality ?? this.vitality,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'isUnlocked': isUnlocked,
        'completionPercent': completionPercent,
        'vitality': vitality.name,
      };

  @override
  List<Object?> get props => [
        id,
        name,
        type,
        order,
        isUnlocked,
        completionPercent,
        vitality,
      ];
}

/// Каталог локаций мира (статический контент).
abstract final class WorldCatalog {
  static const List<AdventureLocation> locations = [
    AdventureLocation(
      id: LocationIds.village,
      name: 'Деревня Слов',
      description: 'Здесь всё началось. Жители ждут возвращения книг.',
      type: LocationType.village,
      order: 0,
      isUnlocked: true,
      completionPercent: 0,
      bossId: 'boss_village_shade',
      questIds: ['q_village_bridge', 'q_village_well', 'q_village_library'],
      secretIds: ['sec_village_chest'],
      mapX: 0.18,
      mapY: 0.62,
    ),
    AdventureLocation(
      id: LocationIds.magicForest,
      name: 'Волшебный лес',
      description: 'Деревья шепчут слоги. Буквы прячутся в листве.',
      type: LocationType.forest,
      order: 1,
      isUnlocked: false,
      completionPercent: 0,
      bossId: 'boss_forest_wraith',
      questIds: ['q_forest_path', 'q_forest_fox', 'q_forest_runes'],
      secretIds: ['sec_forest_grove'],
      mapX: 0.35,
      mapY: 0.45,
    ),
    AdventureLocation(
      id: LocationIds.caves,
      name: 'Пещеры Эха',
      description: 'Каждое слово отдаётся эхом и зажигает кристаллы.',
      type: LocationType.cave,
      order: 2,
      isUnlocked: false,
      completionPercent: 0,
      bossId: 'boss_echo_golem',
      questIds: ['q_cave_light', 'q_cave_crystal'],
      secretIds: ['sec_cave_gem'],
      mapX: 0.22,
      mapY: 0.28,
    ),
    AdventureLocation(
      id: LocationIds.castle,
      name: 'Замок Букв',
      description: 'Древняя крепость, где хранились великие книги.',
      type: LocationType.castle,
      order: 3,
      isUnlocked: false,
      completionPercent: 0,
      bossId: 'boss_castle_knight',
      questIds: ['q_castle_gate', 'q_castle_throne'],
      secretIds: ['sec_castle_crown'],
      mapX: 0.55,
      mapY: 0.32,
    ),
    AdventureLocation(
      id: LocationIds.desert,
      name: 'Пустыня Песков',
      description: 'Слова погребены под дюнами. Найди их!',
      type: LocationType.desert,
      order: 4,
      isUnlocked: false,
      completionPercent: 0,
      bossId: 'boss_sand_serpent',
      questIds: ['q_desert_oasis', 'q_desert_pyramid'],
      secretIds: ['sec_desert_scarab'],
      mapX: 0.72,
      mapY: 0.55,
    ),
    AdventureLocation(
      id: LocationIds.iceValley,
      name: 'Ледяная долина',
      description: 'Мороз сковал сказки. Согрей их чтением.',
      type: LocationType.ice,
      order: 5,
      isUnlocked: false,
      completionPercent: 0,
      bossId: 'boss_frost_giant',
      questIds: ['q_ice_bridge', 'q_ice_aurora'],
      secretIds: ['sec_ice_flake'],
      mapX: 0.78,
      mapY: 0.22,
    ),
    AdventureLocation(
      id: LocationIds.volcano,
      name: 'Вулкан Пламени',
      description: 'Жаркие руны кипят в лаве.',
      type: LocationType.volcano,
      order: 6,
      isUnlocked: false,
      completionPercent: 0,
      bossId: 'boss_magma_drake',
      questIds: ['q_volcano_forge', 'q_volcano_peak'],
      secretIds: ['sec_volcano_ember'],
      mapX: 0.48,
      mapY: 0.72,
    ),
    AdventureLocation(
      id: LocationIds.skyIslands,
      name: 'Небесные острова',
      description: 'Облака несут летающие слова.',
      type: LocationType.sky,
      order: 7,
      isUnlocked: false,
      completionPercent: 0,
      bossId: 'boss_storm_eagle',
      questIds: ['q_sky_bridge', 'q_sky_temple'],
      secretIds: ['sec_sky_feather'],
      mapX: 0.62,
      mapY: 0.12,
    ),
    AdventureLocation(
      id: LocationIds.underwater,
      name: 'Подводный мир',
      description: 'Жемчужины-буквы сияют на дне.',
      type: LocationType.underwater,
      order: 8,
      isUnlocked: false,
      completionPercent: 0,
      bossId: 'boss_tide_kraken',
      questIds: ['q_ocean_reef', 'q_ocean_ship'],
      secretIds: ['sec_ocean_pearl'],
      mapX: 0.88,
      mapY: 0.70,
    ),
    AdventureLocation(
      id: LocationIds.cosmos,
      name: 'Космос Сказаний',
      description: 'Пожиратель Букв ждёт в сердце тьмы.',
      type: LocationType.cosmos,
      order: 9,
      isUnlocked: false,
      completionPercent: 0,
      bossId: 'boss_letter_devourer',
      questIds: ['q_cosmos_stars', 'q_cosmos_final'],
      secretIds: ['sec_cosmos_star'],
      mapX: 0.42,
      mapY: 0.08,
    ),
  ];

  /// Находит локацию по id.
  static AdventureLocation? byId(String id) {
    for (final loc in locations) {
      if (loc.id == id) return loc;
    }
    return null;
  }
}
