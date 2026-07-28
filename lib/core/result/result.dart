/// Универсальный контейнер результата операции без исключений в domain-слое.
sealed class Result<T> {
  const Result();

  /// Успешный результат.
  const factory Result.success(T data) = Success<T>;

  /// Ошибка с описанием.
  const factory Result.failure(AppFailure failure) = Failure<T>;

  /// Возвращает данные или null при ошибке.
  T? get dataOrNull => switch (this) {
        Success(:final data) => data,
        Failure() => null,
      };

  /// Возвращает failure или null при успехе.
  AppFailure? get failureOrNull => switch (this) {
        Success() => null,
        Failure(:final failure) => failure,
      };

  /// Успешна ли операция.
  bool get isSuccess => this is Success<T>;

  /// Есть ли ошибка.
  bool get isFailure => this is Failure<T>;

  /// Преобразует успешные данные.
  Result<R> map<R>(R Function(T data) transform) => switch (this) {
        Success(:final data) => Result.success(transform(data)),
        Failure(:final failure) => Result.failure(failure),
      };

  /// Выполняет [onSuccess] или [onFailure].
  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(AppFailure failure) onFailure,
  }) =>
      switch (this) {
        Success(:final data) => onSuccess(data),
        Failure(:final failure) => onFailure(failure),
      };
}

/// Успешный результат с данными [data].
final class Success<T> extends Result<T> {
  const Success(this.data);

  final T data;
}

/// Неуспешный результат с [failure].
final class Failure<T> extends Result<T> {
  const Failure(this.failure);

  final AppFailure failure;
}

/// Базовый тип ошибки приложения.
sealed class AppFailure {
  const AppFailure({
    required this.message,
    this.code,
    this.cause,
  });

  final String message;
  final String? code;
  final Object? cause;
}

/// Ошибка хранилища / персистентности.
final class StorageFailure extends AppFailure {
  const StorageFailure({
    required super.message,
    super.code,
    super.cause,
  });
}

/// Ошибка валидации входных данных.
final class ValidationFailure extends AppFailure {
  const ValidationFailure({
    required super.message,
    super.code,
    super.cause,
  });
}

/// Ошибка игровой логики.
final class GameLogicFailure extends AppFailure {
  const GameLogicFailure({
    required super.message,
    super.code,
    super.cause,
  });
}

/// Неизвестная / неожиданная ошибка.
final class UnexpectedFailure extends AppFailure {
  const UnexpectedFailure({
    required super.message,
    super.code,
    super.cause,
  });
}

/// Ошибка отсутствия ресурса.
final class NotFoundFailure extends AppFailure {
  const NotFoundFailure({
    required super.message,
    super.code,
    super.cause,
  });
}
