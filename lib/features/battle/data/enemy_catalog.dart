import 'package:readquest/features/battle/domain/entities/battle.dart';

/// Противники приключения. Побеждаются только силой прочитанных слов.
abstract final class EnemyCatalog {
  static const List<Enemy> bosses = [
    Enemy(id: 'boss_village_shade', name: 'Тень Молчания', type: EnemyType.boss, maxHp: 35, locationId: 'village', introText: 'Тень гасит фонари Деревни Слов!', defeatText: 'Тень растаяла, и мост засиял.', spriteKey: 'shade'),
    Enemy(id: 'boss_forest_wraith', name: 'Шелестящий дух', type: EnemyType.boss, maxHp: 55, locationId: 'magic_forest', introText: 'Дух запутал лесные тропы.', defeatText: 'Лес снова шепчет добрые слова.', spriteKey: 'wraith'),
    Enemy(id: 'boss_echo_golem', name: 'Голем Эха', type: EnemyType.boss, maxHp: 70, locationId: 'caves', introText: 'Голем повторяет только тишину.', defeatText: 'Кристаллы запели чистыми голосами.', spriteKey: 'golem'),
    Enemy(id: 'boss_castle_knight', name: 'Рыцарь Пустых Страниц', type: EnemyType.boss, maxHp: 90, locationId: 'castle', introText: 'Рыцарь охраняет замок без историй.', defeatText: 'Страницы наполнились сказками.', spriteKey: 'knight'),
    Enemy(id: 'boss_sand_serpent', name: 'Змей Забвения', type: EnemyType.boss, maxHp: 105, locationId: 'desert', introText: 'Змей прячет буквы в песке.', defeatText: 'Дюны вернули потерянные слова.', spriteKey: 'serpent'),
    Enemy(id: 'boss_frost_giant', name: 'Ледяной Великан', type: EnemyType.boss, maxHp: 125, locationId: 'ice_valley', introText: 'Великан заморозил все сказки.', defeatText: 'Лёд растаял от тёплых слов.', spriteKey: 'giant'),
    Enemy(id: 'boss_magma_drake', name: 'Лавовый Дрейк', type: EnemyType.boss, maxHp: 145, locationId: 'volcano', introText: 'Дрейк рычит над огненными рунами.', defeatText: 'Руны успокоили вулкан.', spriteKey: 'drake'),
    Enemy(id: 'boss_storm_eagle', name: 'Грозовой Орёл', type: EnemyType.boss, maxHp: 165, locationId: 'sky_islands', introText: 'Орёл разметал слова по облакам.', defeatText: 'Небо стало ясным.', spriteKey: 'eagle'),
    Enemy(id: 'boss_tide_kraken', name: 'Кракен Приливов', type: EnemyType.boss, maxHp: 185, locationId: 'underwater', introText: 'Щупальца закрыли подводную библиотеку.', defeatText: 'Жемчужины снова сияют.', spriteKey: 'kraken'),
    Enemy(id: 'boss_letter_devourer', name: 'Пожиратель Букв', type: EnemyType.boss, maxHp: 240, locationId: 'cosmos', introText: 'Последняя тьма пытается съесть все истории!', defeatText: 'Космос засиял миллионом букв.', spriteKey: 'devourer'),
  ];

  /// Ищет врага по идентификатору.
  static Enemy byId(String id) => bosses.firstWhere(
        (enemy) => enemy.id == id,
        orElse: () => bosses.first,
      );
}
