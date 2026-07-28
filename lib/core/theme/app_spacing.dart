import 'package:flutter/material.dart';

/// Отступы и радиусы ReadQuest — «мягкий» игровой UI.
abstract final class AppSpacing {
  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
  static const double xxxl = 64;

  static const EdgeInsets screenPadding = EdgeInsets.symmetric(
    horizontal: lg,
    vertical: md,
  );

  static const EdgeInsets cardPadding = EdgeInsets.all(md);

  static const double radiusSm = 12;
  static const double radiusMd = 20;
  static const double radiusLg = 28;
  static const double radiusXl = 36;

  static const BorderRadius borderSm =
      BorderRadius.all(Radius.circular(radiusSm));
  static const BorderRadius borderMd =
      BorderRadius.all(Radius.circular(radiusMd));
  static const BorderRadius borderLg =
      BorderRadius.all(Radius.circular(radiusLg));
  static const BorderRadius borderXl =
      BorderRadius.all(Radius.circular(radiusXl));
}

/// Длительности анимаций с учётом скорости доступности.
abstract final class AppDurations {
  static const Duration instant = Duration(milliseconds: 100);
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 400);
  static const Duration slow = Duration(milliseconds: 700);
  static const Duration celebrate = Duration(milliseconds: 1200);
  static const Duration worldPulse = Duration(milliseconds: 2400);

  /// Масштабирует длительность по коэффициенту скорости анимаций.
  static Duration scaled(Duration base, double speed) {
    if (speed <= 0) return instant;
    return Duration(milliseconds: (base.inMilliseconds / speed).round());
  }
}

/// Тени — мягкие, «игровые», без тяжёлых multi-layer.
abstract final class AppShadows {
  static List<BoxShadow> soft({Color color = const Color(0x403E2723)}) => [
        BoxShadow(
          color: color,
          blurRadius: 12,
          offset: const Offset(0, 6),
        ),
      ];

  static List<BoxShadow> float({Color color = const Color(0x553E2723)}) => [
        BoxShadow(
          color: color,
          blurRadius: 18,
          offset: const Offset(0, 10),
        ),
      ];

  static List<BoxShadow> glow({
    Color color = const Color(0x66FFD54F),
  }) =>
      [
        BoxShadow(
          color: color,
          blurRadius: 24,
          spreadRadius: 2,
        ),
      ];
}
