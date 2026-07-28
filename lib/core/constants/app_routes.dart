/// Маршруты приложения ReadQuest.
///
/// Единый источник путей для go_router и deep-link готовности.
abstract final class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String adventure = '/adventure';
  static const String location = '/adventure/location/:locationId';
  static const String battle = '/battle/:battleId';
  static const String boss = '/boss/:bossId';
  static const String dragon = '/dragon';
  static const String dragonCustomize = '/dragon/customize';
  static const String books = '/books';
  static const String bookReader = '/books/:bookId';
  static const String quests = '/quests';
  static const String questDetail = '/quests/:questId';
  static const String inventory = '/inventory';
  static const String shop = '/shop';
  static const String library = '/library';
  static const String story = '/library/:storyId';
  static const String achievements = '/achievements';
  static const String city = '/city';
  static const String miniGames = '/mini-games';
  static const String miniGame = '/mini-games/:gameId';
  static const String settings = '/settings';
  static const String parents = '/parents';
  static const String parentsPin = '/parents/pin';
  static const String statistics = '/statistics';
  static const String world = '/world';

  /// Собирает путь локации.
  static String locationPath(String locationId) =>
      '/adventure/location/$locationId';

  /// Собирает путь битвы.
  static String battlePath(String battleId) => '/battle/$battleId';

  /// Собирает путь босса.
  static String bossPath(String bossId) => '/boss/$bossId';

  /// Собирает путь книги.
  static String bookPath(String bookId) => '/books/$bookId';

  /// Собирает путь квеста.
  static String questPath(String questId) => '/quests/$questId';

  /// Собирает путь рассказа.
  static String storyPath(String storyId) => '/library/$storyId';

  /// Собирает путь мини-игры.
  static String miniGamePath(String gameId) => '/mini-games/$gameId';
}
