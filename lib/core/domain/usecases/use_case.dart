import 'package:readquest/core/result/result.dart';

/// Контракт Use Case без параметров.
abstract class UseCase<T> {
  /// Выполняет сценарий и возвращает [Result].
  Future<Result<T>> call();
}

/// Контракт Use Case с параметрами типа [Params].
abstract class UseCaseWithParams<T, Params> {
  /// Выполняет сценарий с [params] и возвращает [Result].
  Future<Result<T>> call(Params params);
}

/// Контракт синхронного Use Case без параметров.
abstract class SyncUseCase<T> {
  /// Выполняет сценарий синхронно.
  Result<T> call();
}

/// Контракт синхронного Use Case с параметрами.
abstract class SyncUseCaseWithParams<T, Params> {
  /// Выполняет сценарий синхронно с [params].
  Result<T> call(Params params);
}

/// Маркер «параметры не нужны».
final class NoParams {
  const NoParams();
}
