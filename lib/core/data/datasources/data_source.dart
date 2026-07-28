/// Базовый интерфейс локального источника данных.
abstract interface class LocalDataSource {
  /// Инициализирует хранилище.
  Future<void> init();

  /// Очищает все данные источника.
  Future<void> clear();
}

/// Базовый интерфейс удалённого источника (Firebase-ready).
abstract interface class RemoteDataSource {
  /// Доступен ли удалённый источник.
  bool get isAvailable;
}
