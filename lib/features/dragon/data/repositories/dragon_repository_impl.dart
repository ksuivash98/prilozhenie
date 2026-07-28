import 'package:readquest/core/result/result.dart';
import 'package:readquest/core/services/progress_storage_service.dart';
import 'package:readquest/features/dragon/domain/entities/dragon.dart';

/// Контракт репозитория дракона.
abstract interface class DragonRepository {
  /// Загружает дракона.
  Future<Result<Dragon>> getDragon();

  /// Сохраняет дракона.
  Future<Result<bool>> saveDragon(Dragon dragon);
}

/// Локальная реализация репозитория дракона.
class DragonRepositoryImpl implements DragonRepository {
  DragonRepositoryImpl(this._storage);

  final ProgressStorageService _storage;

  @override
  Future<Result<Dragon>> getDragon() async {
    try {
      return Result.success(_storage.loadDragon());
    } catch (e) {
      return Result.failure(
        StorageFailure(message: 'Не удалось загрузить дракона', cause: e),
      );
    }
  }

  @override
  Future<Result<bool>> saveDragon(Dragon dragon) async {
    try {
      await _storage.saveDragon(dragon);
      return const Result.success(true);
    } catch (e) {
      return Result.failure(
        StorageFailure(message: 'Не удалось сохранить дракона', cause: e),
      );
    }
  }
}
