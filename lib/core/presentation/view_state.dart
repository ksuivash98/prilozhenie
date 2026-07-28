/// Базовый класс состояния экрана (MVVM).
sealed class ViewState<T> {
  const ViewState();

  /// Начальная / пустая загрузка.
  const factory ViewState.initial() = ViewInitial<T>;

  /// Идёт загрузка.
  const factory ViewState.loading() = ViewLoading<T>;

  /// Данные загружены.
  const factory ViewState.ready(T data) = ViewReady<T>;

  /// Ошибка.
  const factory ViewState.error(String message) = ViewError<T>;
}

/// Начальное состояние.
final class ViewInitial<T> extends ViewState<T> {
  const ViewInitial();
}

/// Состояние загрузки.
final class ViewLoading<T> extends ViewState<T> {
  const ViewLoading();
}

/// Готовое состояние с данными.
final class ViewReady<T> extends ViewState<T> {
  const ViewReady(this.data);

  final T data;
}

/// Состояние ошибки.
final class ViewError<T> extends ViewState<T> {
  const ViewError(this.message);

  final String message;
}
