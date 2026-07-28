import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:readquest/core/config/app_config.dart';
import 'package:readquest/core/utils/app_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Контейнер зависимостей уровня приложения.
///
/// Инициализирует инфраструктуру до запуска UI.
final class AppDependencies {
  AppDependencies._({
    required this.prefs,
  });

  final SharedPreferences prefs;

  /// Создаёт и инициализирует зависимости.
  static Future<AppDependencies> create() async {
    AppLogger.i('Initializing ReadQuest dependencies...');

    await Hive.initFlutter();
    await _openHiveBoxes();

    final prefs = await SharedPreferences.getInstance();

    AppLogger.i('Dependencies ready.');
    return AppDependencies._(prefs: prefs);
  }

  static Future<void> _openHiveBoxes() async {
    final boxes = [
      AppConfig.progressBox,
      AppConfig.settingsBox,
      AppConfig.statisticsBox,
      AppConfig.libraryBox,
      AppConfig.dragonBox,
      AppConfig.inventoryBox,
      AppConfig.worldBox,
      AppConfig.achievementsBox,
      AppConfig.adaptiveBox,
    ];

    for (final name in boxes) {
      if (!Hive.isBoxOpen(name)) {
        await Hive.openBox<dynamic>(name);
      }
    }
  }

  /// Закрывает ресурсы при завершении.
  Future<void> dispose() async {
    await Hive.close();
  }
}

/// Provider контейнера зависимостей.
final appDependenciesProvider = Provider<AppDependencies>((ref) {
  throw UnimplementedError(
    'AppDependencies must be overridden in ProviderScope.',
  );
});

/// Provider SharedPreferences.
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  return ref.watch(appDependenciesProvider).prefs;
});
