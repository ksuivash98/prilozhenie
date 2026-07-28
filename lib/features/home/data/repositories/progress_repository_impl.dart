import 'package:readquest/core/result/result.dart';
import 'package:readquest/core/services/progress_storage_service.dart';
import 'package:readquest/features/home/domain/entities/player_progress.dart';

/// Контракт репозитория прогресса игрока.
abstract interface class ProgressRepository {
  /// Загружает прогресс.
  Future<Result<PlayerProgress>> getProgress();

  /// Сохраняет прогресс. Возвращает true при успехе.
  Future<Result<bool>> saveProgress(PlayerProgress progress);
}

/// Реализация репозитория прогресса через локальное хранилище.
class ProgressRepositoryImpl implements ProgressRepository {
  ProgressRepositoryImpl(this._storage);

  final ProgressStorageService _storage;

  @override
  Future<Result<PlayerProgress>> getProgress() async {
    try {
      return Result.success(_storage.loadProgress());
    } catch (e) {
      return Result.failure(
        StorageFailure(message: 'Не удалось загрузить прогресс', cause: e),
      );
    }
  }

  @override
  Future<Result<bool>> saveProgress(PlayerProgress progress) async {
    try {
      await _storage.saveProgress(progress);
      return const Result.success(true);
    } catch (e) {
      return Result.failure(
        StorageFailure(message: 'Не удалось сохранить прогресс', cause: e),
      );
    }
  }
}
