/// ReadQuest — архитектура продукта
///
/// Слои:
/// - presentation → viewmodels/providers/screens/widgets
/// - domain → entities/usecases/repositories (контракты)
/// - data → models/datasources/repositories/mappers
///
/// Каждая игровая механика = отдельный feature-модуль.
/// DI через Riverpod. Навигация через go_router.
/// Персистентность: Hive + SharedPreferences. Offline-first.
library;
