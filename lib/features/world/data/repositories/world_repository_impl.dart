import 'package:readquest/core/result/result.dart';
import 'package:readquest/core/services/progress_storage_service.dart';
import 'package:readquest/features/world/domain/entities/world_state.dart';

/// Контракт репозитория мира.
abstract interface class WorldRepository {
  /// Загружает состояние мира.
  Future<Result<WorldState>> getWorld();

  /// Сохраняет состояние мира.
  Future<Result<bool>> saveWorld(WorldState state);
}

/// Локальная реализация репозитория мира.
class WorldRepositoryImpl implements WorldRepository {
  WorldRepositoryImpl(this._storage);

  final ProgressStorageService _storage;

  @override
  Future<Result<WorldState>> getWorld() async {
    try {
      return Result.success(_storage.loadWorld());
    } catch (e) {
      return Result.failure(
        StorageFailure(message: 'Не удалось загрузить мир', cause: e),
      );
    }
  }

  @override
  Future<Result<bool>> saveWorld(WorldState state) async {
    try {
      await _storage.saveWorld(state);
      return const Result.success(true);
    } catch (e) {
      return Result.failure(
        StorageFailure(message: 'Не удалось сохранить мир', cause: e),
      );
    }
  }
}
