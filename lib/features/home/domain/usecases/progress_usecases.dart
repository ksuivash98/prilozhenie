import 'package:readquest/core/domain/usecases/use_case.dart';
import 'package:readquest/core/result/result.dart';
import 'package:readquest/features/home/domain/entities/player_progress.dart';
import 'package:readquest/features/home/data/repositories/progress_repository_impl.dart';

/// Загружает прогресс игрока.
class GetPlayerProgressUseCase extends UseCase<PlayerProgress> {
  GetPlayerProgressUseCase(this._repository);

  final ProgressRepository _repository;

  @override
  Future<Result<PlayerProgress>> call() => _repository.getProgress();
}

/// Сохраняет прогресс игрока.
class SavePlayerProgressUseCase
    extends UseCaseWithParams<bool, PlayerProgress> {
  SavePlayerProgressUseCase(this._repository);

  final ProgressRepository _repository;

  @override
  Future<Result<bool>> call(PlayerProgress params) =>
      _repository.saveProgress(params);
}
