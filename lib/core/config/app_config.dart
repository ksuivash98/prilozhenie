/// Глобальная конфигурация приложения ReadQuest.
///
/// Централизует флаги окружения, лимиты безопасности и параметры продукта.
/// Firebase и сеть отключены по умолчанию — приложение работает офлайн-first.
abstract final class AppConfig {
  static const String appName = 'ReadQuest';
  static const String slogan = 'Чтение превращается в настоящее приключение.';
  static const String version = '1.0.0';

  /// Целевой возрастной диапазон игрока.
  static const int minAge = 5;
  static const int maxAge = 9;

  /// Режим сборки.
  static const bool isProduction = bool.fromEnvironment(
    'PRODUCTION',
    defaultValue: false,
  );

  /// Firebase готов к интеграции, но не активирован.
  static const bool firebaseEnabled = false;

  /// Реклама, покупки и внешние ссылки запрещены продуктовыми правилами.
  static const bool adsEnabled = false;
  static const bool inAppPurchasesEnabled = false;
  static const bool externalLinksEnabled = false;

  /// Максимальная длина PIN родительского режима.
  static const int parentPinLength = 4;

  /// Через сколько часов без чтения мир начинает сереть.
  static const int worldFadeHours = 24;

  /// Полное посерение мира без чтения (часы).
  static const int worldGrayHours = 72;

  /// Базовая длительность анимаций (мс).
  static const int baseAnimationMs = 400;

  /// Hive box names.
  static const String progressBox = 'progress';
  static const String settingsBox = 'settings';
  static const String statisticsBox = 'statistics';
  static const String libraryBox = 'library';
  static const String dragonBox = 'dragon';
  static const String inventoryBox = 'inventory';
  static const String worldBox = 'world';
  static const String achievementsBox = 'achievements';
  static const String adaptiveBox = 'adaptive';
}
