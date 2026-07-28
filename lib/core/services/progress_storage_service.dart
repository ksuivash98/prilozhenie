import 'dart:convert';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:readquest/core/config/app_config.dart';
import 'package:readquest/core/utils/app_logger.dart';
import 'package:readquest/features/achievements/domain/entities/achievement.dart';
import 'package:readquest/features/adaptive_learning/domain/entities/adaptive_profile.dart';
import 'package:readquest/features/dragon/domain/entities/dragon.dart';
import 'package:readquest/features/home/domain/entities/player_progress.dart';
import 'package:readquest/features/inventory/domain/entities/inventory.dart';
import 'package:readquest/features/statistics/domain/entities/reading_statistics.dart';
import 'package:readquest/features/world/domain/entities/world_state.dart';

/// Единый сервис локальной персистентности (Hive).
class ProgressStorageService {
  Box<dynamic> get _progress => Hive.box<dynamic>(AppConfig.progressBox);
  Box<dynamic> get _dragon => Hive.box<dynamic>(AppConfig.dragonBox);
  Box<dynamic> get _world => Hive.box<dynamic>(AppConfig.worldBox);
  Box<dynamic> get _stats => Hive.box<dynamic>(AppConfig.statisticsBox);
  Box<dynamic> get _inventory => Hive.box<dynamic>(AppConfig.inventoryBox);
  Box<dynamic> get _achievements => Hive.box<dynamic>(AppConfig.achievementsBox);
  Box<dynamic> get _adaptive => Hive.box<dynamic>(AppConfig.adaptiveBox);

  /// Загружает прогресс игрока.
  PlayerProgress loadProgress() {
    final raw = _progress.get('player');
    if (raw is Map) return PlayerProgress.fromMap(raw);
    return PlayerProgress.initial();
  }

  /// Сохраняет прогресс игрока.
  Future<void> saveProgress(PlayerProgress progress) async {
    await _progress.put('player', progress.toMap());
  }

  /// Загружает дракона.
  Dragon loadDragon() {
    final raw = _dragon.get('main');
    if (raw is Map) return Dragon.fromMap(raw);
    return Dragon.initial();
  }

  /// Сохраняет дракона.
  Future<void> saveDragon(Dragon dragon) async {
    await _dragon.put('main', dragon.toMap());
  }

  /// Загружает мир.
  WorldState loadWorld() {
    final raw = _world.get('state');
    if (raw is Map) return WorldState.fromMap(raw);
    return WorldState.initial();
  }

  /// Сохраняет мир.
  Future<void> saveWorld(WorldState state) async {
    await _world.put('state', state.toMap());
  }

  /// Загружает статистику.
  ReadingStatistics loadStatistics() {
    final raw = _stats.get('reading');
    if (raw is Map) return ReadingStatistics.fromMap(raw);
    return ReadingStatistics.empty();
  }

  /// Сохраняет статистику.
  Future<void> saveStatistics(ReadingStatistics stats) async {
    await _stats.put('reading', stats.toMap());
  }

  /// Загружает инвентарь.
  Inventory loadInventory() {
    final raw = _inventory.get('main');
    if (raw is Map) return Inventory.fromMap(raw);
    return Inventory.initial();
  }

  /// Сохраняет инвентарь.
  Future<void> saveInventory(Inventory inventory) async {
    await _inventory.put('main', inventory.toMap());
  }

  /// Загружает достижения.
  List<Achievement> loadAchievements() {
    final raw = _achievements.get('list');
    if (raw is! List) return AchievementCatalog.seed();
    final seed = AchievementCatalog.seed();
    return seed.map((a) {
      final saved = raw.cast<Map>().where((m) => m['id'] == a.id).firstOrNull;
      if (saved == null) return a;
      return a.copyWith(
        currentValue: saved['currentValue'] as int? ?? a.currentValue,
        isUnlocked: saved['isUnlocked'] as bool? ?? a.isUnlocked,
        unlockedAt: DateTime.tryParse(saved['unlockedAt'] as String? ?? ''),
      );
    }).toList();
  }

  /// Сохраняет достижения.
  Future<void> saveAchievements(List<Achievement> list) async {
    await _achievements.put('list', list.map((e) => e.toMap()).toList());
  }

  /// Загружает адаптивный профиль.
  AdaptiveProfile loadAdaptiveProfile() {
    final raw = _adaptive.get('profile');
    if (raw is Map) return AdaptiveProfile.fromMap(raw);
    return AdaptiveProfile.initial();
  }

  /// Сохраняет адаптивный профиль.
  Future<void> saveAdaptiveProfile(AdaptiveProfile profile) async {
    await _adaptive.put('profile', profile.toMap());
  }

  /// Экспортирует статистику в JSON-строку (для родителей).
  String exportStatisticsJson(ReadingStatistics stats) {
    return const JsonEncoder.withIndent('  ').convert(stats.toMap());
  }

  /// Хеширует PIN без внешних зависимостей (SHA-like упрощённый для локального PIN).
  String hashPin(String pin) {
    final salt = 'readquest_parent_v1';
    final data = utf8.encode('$salt::$pin');
    var hash = 0;
    for (final b in data) {
      hash = (hash * 31 + b) & 0x7fffffff;
    }
    final rnd = Random(hash);
    final bytes = List<int>.generate(16, (_) => rnd.nextInt(256));
    return base64Url.encode(bytes);
  }

  /// Сбрасывает весь прогресс (осторожно).
  Future<void> clearAll() async {
    AppLogger.w('Clearing all ReadQuest progress');
    await _progress.clear();
    await _dragon.clear();
    await _world.clear();
    await _stats.clear();
    await _inventory.clear();
    await _achievements.clear();
    await _adaptive.clear();
  }
}
