import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readquest/core/constants/game_constants.dart';
import 'package:readquest/core/di/service_providers.dart';
import 'package:readquest/core/services/progress_storage_service.dart';
import 'package:readquest/core/services/reading_evaluation_service.dart';
import 'package:readquest/features/achievements/domain/entities/achievement.dart';
import 'package:readquest/features/adaptive_learning/domain/entities/adaptive_profile.dart';
import 'package:readquest/features/books/domain/entities/reading_challenge.dart';
import 'package:readquest/features/city/domain/entities/city.dart';
import 'package:readquest/features/dragon/domain/entities/dragon.dart';
import 'package:readquest/features/home/domain/entities/player_progress.dart';
import 'package:readquest/features/inventory/domain/entities/inventory.dart';
import 'package:readquest/features/statistics/domain/entities/reading_statistics.dart';
import 'package:readquest/features/world/domain/entities/world_state.dart';

/// Агрегированное игровое состояние.
class GameState {
  const GameState({
    required this.progress,
    required this.dragon,
    required this.world,
    required this.inventory,
    required this.statistics,
    required this.achievements,
    required this.adaptive,
    required this.city,
    required this.isLoaded,
  });

  final PlayerProgress progress;
  final Dragon dragon;
  final WorldState world;
  final Inventory inventory;
  final ReadingStatistics statistics;
  final List<Achievement> achievements;
  final AdaptiveProfile adaptive;
  final CityState city;
  final bool isLoaded;

  factory GameState.loading() {
    return GameState(
      progress: PlayerProgress.initial(),
      dragon: Dragon.initial(),
      world: WorldState.initial(),
      inventory: Inventory.initial(),
      statistics: ReadingStatistics.empty(),
      achievements: AchievementCatalog.seed(),
      adaptive: AdaptiveProfile.initial(),
      city: CityState.initial(),
      isLoaded: false,
    );
  }

  GameState copyWith({
    PlayerProgress? progress,
    Dragon? dragon,
    WorldState? world,
    Inventory? inventory,
    ReadingStatistics? statistics,
    List<Achievement>? achievements,
    AdaptiveProfile? adaptive,
    CityState? city,
    bool? isLoaded,
  }) {
    return GameState(
      progress: progress ?? this.progress,
      dragon: dragon ?? this.dragon,
      world: world ?? this.world,
      inventory: inventory ?? this.inventory,
      statistics: statistics ?? this.statistics,
      achievements: achievements ?? this.achievements,
      adaptive: adaptive ?? this.adaptive,
      city: city ?? this.city,
      isLoaded: isLoaded ?? this.isLoaded,
    );
  }
}

/// Центральный контроллер игрового прогресса.
class GameController extends StateNotifier<GameState> {
  GameController(this._storage, this._ref) : super(GameState.loading()) {
    load();
  }

  final ProgressStorageService _storage;
  final Ref _ref;

  /// Загружает состояние из хранилища.
  void load() {
    final worldService = _ref.read(worldVitalityServiceProvider);
    var world = _storage.loadWorld();
    world = worldService.applyTimeDecay(world);

    state = GameState(
      progress: _storage.loadProgress(),
      dragon: _storage.loadDragon(),
      world: world,
      inventory: _storage.loadInventory(),
      statistics: _storage.loadStatistics(),
      achievements: _storage.loadAchievements(),
      adaptive: _storage.loadAdaptiveProfile(),
      city: _unlockCityBuildings(
        CityState.initial(),
        _storage.loadProgress().wordsReadTotal,
      ),
      isLoaded: true,
    );
  }

  /// Регистрирует успешное/неуспешное чтение.
  Future<void> registerReading({
    required ReadingChallenge challenge,
    required ReadingEvaluation evaluation,
    required int durationMs,
  }) async {
    final adaptiveService = _ref.read(adaptiveLearningServiceProvider);
    final worldService = _ref.read(worldVitalityServiceProvider);

    var progress = state.progress;
    var dragon = state.dragon;
    var world = state.world;
    var stats = state.statistics;
    var achievements = [...state.achievements];
    var adaptive = state.adaptive;
    var inventory = state.inventory;

    adaptive = adaptiveService.updateProfile(
      profile: adaptive,
      challenge: challenge,
      evaluation: evaluation,
      durationMs: durationMs,
    );

    final today = DateTime.now();
    final dayKey = DateTime(today.year, today.month, today.day);
    var daily = [...stats.daily];
    final idx = daily.indexWhere(
      (d) =>
          d.date.year == dayKey.year &&
          d.date.month == dayKey.month &&
          d.date.day == dayKey.day,
    );
    final baseDaily = idx >= 0
        ? daily[idx]
        : DailyReadingStats(
            date: dayKey,
            wordsRead: 0,
            correctCount: 0,
            errorCount: 0,
            secondsSpent: 0,
            sessionsCount: 1,
          );

    if (evaluation.isCorrect) {
      final words = challenge.type == ReadingChallengeType.story
          ? challenge.targetText.split(RegExp(r'\s+')).length
          : 1;

      progress = progress.copyWith(
        wordsReadTotal: progress.wordsReadTotal + words,
        xp: progress.xp + challenge.xpReward,
        coins: progress.coins + challenge.wordPower,
        lastActiveAt: today,
      );

      if (progress.xp >= progress.xpForNextLevel) {
        progress = progress.copyWith(
          level: progress.level + 1,
          xp: progress.xp - progress.xpForNextLevel,
        );
      }

      dragon = _gainDragonXp(dragon, challenge.xpReward);
      world = worldService.onWordsRead(world, words);
      inventory = inventory.copyWith(
        coins: inventory.coins + challenge.wordPower,
      );

      final updatedDaily = baseDaily.copyWith(
        wordsRead: baseDaily.wordsRead + words,
        correctCount: baseDaily.correctCount + 1,
        secondsSpent: baseDaily.secondsSpent + (durationMs / 1000).round(),
      );
      if (idx >= 0) {
        daily[idx] = updatedDaily;
      } else {
        daily.add(updatedDaily);
      }

      stats = stats.copyWith(
        totalWords: stats.totalWords + words,
        totalCorrect: stats.totalCorrect + 1,
        totalSeconds: stats.totalSeconds + (durationMs / 1000).round(),
        currentStreak: stats.currentStreak + (idx < 0 ? 1 : 0),
        bestStreak: [
          stats.bestStreak,
          stats.currentStreak + (idx < 0 ? 1 : 0),
        ].reduce((a, b) => a > b ? a : b),
        daily: daily,
      );

      achievements = _updateAchievements(achievements, progress, dragon);
    } else {
      final hardLetters = Map<String, int>.from(stats.hardLetters);
      final hardSyllables = Map<String, int>.from(stats.hardSyllables);
      final hardWords = Map<String, int>.from(stats.hardWords);
      for (final l in evaluation.errorLetters) {
        hardLetters[l] = (hardLetters[l] ?? 0) + 1;
      }
      for (final s in evaluation.errorSyllables) {
        hardSyllables[s] = (hardSyllables[s] ?? 0) + 1;
      }
      hardWords[challenge.normalizedTarget] =
          (hardWords[challenge.normalizedTarget] ?? 0) + 1;

      final updatedDaily = baseDaily.copyWith(
        errorCount: baseDaily.errorCount + 1,
        secondsSpent: baseDaily.secondsSpent + (durationMs / 1000).round(),
      );
      if (idx >= 0) {
        daily[idx] = updatedDaily;
      } else {
        daily.add(updatedDaily);
      }

      stats = stats.copyWith(
        totalErrors: stats.totalErrors + 1,
        totalSeconds: stats.totalSeconds + (durationMs / 1000).round(),
        hardLetters: hardLetters,
        hardSyllables: hardSyllables,
        hardWords: hardWords,
        daily: daily,
      );
    }

    final city = _unlockCityBuildings(state.city, progress.wordsReadTotal);

    state = state.copyWith(
      progress: progress,
      dragon: dragon,
      world: world,
      inventory: inventory,
      statistics: stats,
      achievements: achievements,
      adaptive: adaptive,
      city: city,
    );

    await _persist();
  }

  /// Переименовывает игрока.
  Future<void> setPlayerName(String name) async {
    state = state.copyWith(
      progress: state.progress.copyWith(displayName: name),
    );
    await _storage.saveProgress(state.progress);
  }

  /// Открывает локацию.
  Future<void> unlockLocation(String locationId) async {
    final world = _ref
        .read(worldVitalityServiceProvider)
        .unlockNextLocation(state.world, locationId);
    state = state.copyWith(
      world: world,
      progress: state.progress.copyWith(currentLocationId: locationId),
    );
    await _persist();
  }

  /// Регистрирует победу над боссом и открывает следующую локацию.
  Future<void> defeatBoss({String? currentLocationId}) async {
    final order = LocationIds.storyOrder;
    final currentId = currentLocationId ?? state.progress.currentLocationId;
    final idx = order.indexOf(currentId);
    var world = state.world;
    if (idx >= 0 && idx < order.length - 1) {
      world = _ref
          .read(worldVitalityServiceProvider)
          .unlockNextLocation(world, order[idx + 1]);
    }

    final achievements = _updateAchievements(
      [...state.achievements],
      state.progress.copyWith(bossesDefeated: state.progress.bossesDefeated + 1),
      state.dragon,
    );

    state = state.copyWith(
      progress: state.progress.copyWith(
        bossesDefeated: state.progress.bossesDefeated + 1,
        xp: state.progress.xp + 100,
      ),
      world: world,
      achievements: achievements,
    );
    await _persist();
  }

  /// Обновляет состояние дракона после ухода или смены внешности.
  Future<void> updateDragon(Dragon dragon) async {
    state = state.copyWith(dragon: dragon);
    await _storage.saveDragon(dragon);
  }

  Dragon _gainDragonXp(Dragon dragon, int xp) {
    var next = dragon.copyWith(xp: dragon.xp + xp);
    if (next.xp >= next.xpToNextStage && next.stage != DragonStage.legendary) {
      final stages = DragonStage.values;
      final idx = stages.indexOf(next.stage);
      if (idx < stages.length - 1) {
        next = next.copyWith(
          stage: stages[idx + 1],
          xp: next.xp - next.xpToNextStage,
        );
      }
    }
    return next;
  }

  List<Achievement> _updateAchievements(
    List<Achievement> list,
    PlayerProgress progress,
    Dragon dragon,
  ) {
    return list.map((a) {
      if (a.isUnlocked) return a;
      var value = a.currentValue;
      switch (a.id) {
        case 'first_word':
        case 'words_50':
        case 'words_200':
          value = progress.wordsReadTotal;
          break;
        case 'dragon_hatch':
          value = dragon.stage.index >= DragonStage.baby.index ? 1 : 0;
          break;
        case 'first_boss':
          value = progress.bossesDefeated;
          break;
        case 'all_locations':
          value = state.world.unlockedLocationIds.length;
          break;
        default:
          break;
      }
      final unlocked = value >= a.targetValue;
      return a.copyWith(
        currentValue: value,
        isUnlocked: unlocked,
        unlockedAt: unlocked ? DateTime.now() : null,
      );
    }).toList();
  }

  CityState _unlockCityBuildings(CityState city, int words) {
    final buildings = city.buildings.map((b) {
      if (b.isUnlocked) return b;
      if (words >= b.unlockWordsRequired) {
        return b.copyWith(isUnlocked: true, level: 1);
      }
      return b;
    }).toList();
    final unlocked = buildings.where((b) => b.isUnlocked).length;
    return city.copyWith(
      buildings: buildings,
      beautyScore: (unlocked / buildings.length).clamp(0.0, 1.0),
    );
  }

  Future<void> _persist() async {
    await _storage.saveProgress(state.progress);
    await _storage.saveDragon(state.dragon);
    await _storage.saveWorld(state.world);
    await _storage.saveInventory(state.inventory);
    await _storage.saveStatistics(state.statistics);
    await _storage.saveAchievements(state.achievements);
    await _storage.saveAdaptiveProfile(state.adaptive);
  }
}

/// Provider игрового контроллера.
final gameControllerProvider =
    StateNotifierProvider<GameController, GameState>((ref) {
  final storage = ref.watch(progressStorageProvider);
  return GameController(storage, ref);
});
