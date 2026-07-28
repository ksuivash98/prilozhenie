/// Идентификаторы локаций мира ReadQuest.
abstract final class LocationIds {
  static const String village = 'village';
  static const String magicForest = 'magic_forest';
  static const String caves = 'caves';
  static const String castle = 'castle';
  static const String desert = 'desert';
  static const String iceValley = 'ice_valley';
  static const String volcano = 'volcano';
  static const String skyIslands = 'sky_islands';
  static const String underwater = 'underwater';
  static const String cosmos = 'cosmos';

  /// Порядок открытия локаций по сюжету.
  static const List<String> storyOrder = [
    village,
    magicForest,
    caves,
    castle,
    desert,
    iceValley,
    volcano,
    skyIslands,
    underwater,
    cosmos,
  ];
}

/// Идентификаторы зданий города.
abstract final class BuildingIds {
  static const String house = 'house';
  static const String park = 'park';
  static const String library = 'library';
  static const String tower = 'tower';
  static const String fountain = 'fountain';
  static const String school = 'school';
  static const String port = 'port';
  static const String castle = 'castle';
}

/// Идентификаторы мини-игр.
abstract final class MiniGameIds {
  static const String feedDragon = 'feed_dragon';
  static const String collectWord = 'collect_word';
  static const String catchLetter = 'catch_letter';
  static const String defeatMonster = 'defeat_monster';
  static const String openChest = 'open_chest';
  static const String findItem = 'find_item';
  static const String fishing = 'fishing';
  static const String farm = 'farm';
  static const String magicForest = 'magic_forest';
  static const String flyingWords = 'flying_words';
  static const String puzzles = 'puzzles';
  static const String letterHunt = 'letter_hunt';
  static const String magicRunes = 'magic_runes';
  static const String knowledgeTower = 'knowledge_tower';
  static const String forge = 'forge';
  static const String labyrinth = 'labyrinth';
  static const String wordGarden = 'word_garden';
  static const String shipVoyage = 'ship_voyage';
  static const String saveCreature = 'save_creature';
  static const String libraryGame = 'library_game';

  /// Полный каталог мини-игр.
  static const List<String> all = [
    feedDragon,
    collectWord,
    catchLetter,
    defeatMonster,
    openChest,
    findItem,
    fishing,
    farm,
    magicForest,
    flyingWords,
    puzzles,
    letterHunt,
    magicRunes,
    knowledgeTower,
    forge,
    labyrinth,
    wordGarden,
    shipVoyage,
    saveCreature,
    libraryGame,
  ];
}

/// Ключи SharedPreferences / Hive.
abstract final class StorageKeys {
  static const String firstLaunch = 'first_launch';
  static const String onboardingComplete = 'onboarding_complete';
  static const String parentPinHash = 'parent_pin_hash';
  static const String playerName = 'player_name';
  static const String lastReadAt = 'last_read_at';
  static const String accessibilityProfile = 'accessibility_profile';
  static const String animationSpeed = 'animation_speed';
  static const String ttsEnabled = 'tts_enabled';
  static const String ttsRate = 'tts_rate';
  static const String highContrast = 'high_contrast';
  static const String openDyslexic = 'open_dyslexic';
  static const String largeText = 'large_text';
  static const String soundEnabled = 'sound_enabled';
  static const String musicEnabled = 'music_enabled';
}
