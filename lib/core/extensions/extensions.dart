import 'package:flutter/foundation.dart';

/// Расширения для [String].
extension StringX on String {
  /// Первая буква заглавная.
  String get capitalized =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';

  /// Безопасный trim с проверкой на пустоту.
  bool get isBlank => trim().isEmpty;

  /// Непустая строка после trim.
  bool get isNotBlank => !isBlank;
}

/// Расширения для [DateTime].
extension DateTimeX on DateTime {
  /// Часы с момента [this] до сейчас.
  int hoursSinceNow() => DateTime.now().difference(this).inHours;

  /// Дни с момента [this] до сейчас.
  int daysSinceNow() => DateTime.now().difference(this).inDays;
}

/// Расширения для nullable.
extension NullableX<T> on T? {
  /// Возвращает значение или бросает с сообщением.
  T orThrow(String message) {
    if (this == null) {
      throw StateError(message);
    }
    return this as T;
  }
}

/// Логирование только в debug.
void debugLog(String message) {
  if (kDebugMode) {
    debugPrint('[ReadQuest] $message');
  }
}
