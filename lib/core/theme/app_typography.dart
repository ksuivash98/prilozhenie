import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:readquest/core/theme/app_colors.dart';

/// Типографика ReadQuest — выразительные шрифты для детей 5–9 лет.
abstract final class AppTypography {
  static const String _openDyslexicFamily = 'OpenDyslexic';

  /// Заголовки приключений (display).
  static TextStyle display({
    double size = 36,
    FontWeight weight = FontWeight.w800,
    Color color = AppColors.ink,
    bool openDyslexic = false,
  }) {
    if (openDyslexic) {
      return TextStyle(
        fontFamily: _openDyslexicFamily,
        fontSize: size,
        fontWeight: weight,
        color: color,
        height: 1.25,
        letterSpacing: 0.4,
      );
    }
    return GoogleFonts.fredoka(
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: 1.2,
      letterSpacing: 0.2,
    );
  }

  /// Заголовки секций.
  static TextStyle headline({
    double size = 24,
    FontWeight weight = FontWeight.w700,
    Color color = AppColors.ink,
    bool openDyslexic = false,
  }) {
    if (openDyslexic) {
      return TextStyle(
        fontFamily: _openDyslexicFamily,
        fontSize: size,
        fontWeight: weight,
        color: color,
        height: 1.3,
      );
    }
    return GoogleFonts.nunito(
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: 1.25,
    );
  }

  /// Текст для чтения (крупный, читаемый).
  static TextStyle reading({
    double size = 28,
    FontWeight weight = FontWeight.w600,
    Color color = AppColors.ink,
    bool openDyslexic = false,
    bool largeText = false,
  }) {
    final resolved = largeText ? size * 1.25 : size;
    if (openDyslexic) {
      return TextStyle(
        fontFamily: _openDyslexicFamily,
        fontSize: resolved,
        fontWeight: weight,
        color: color,
        height: 1.55,
        letterSpacing: 1.2,
        wordSpacing: 2,
      );
    }
    return GoogleFonts.nunito(
      fontSize: resolved,
      fontWeight: weight,
      color: color,
      height: 1.5,
      letterSpacing: 0.6,
    );
  }

  /// UI-текст кнопок и подписей.
  static TextStyle label({
    double size = 16,
    FontWeight weight = FontWeight.w700,
    Color color = AppColors.ink,
    bool openDyslexic = false,
  }) {
    if (openDyslexic) {
      return TextStyle(
        fontFamily: _openDyslexicFamily,
        fontSize: size,
        fontWeight: weight,
        color: color,
      );
    }
    return GoogleFonts.nunito(
      fontSize: size,
      fontWeight: weight,
      color: color,
    );
  }

  /// Вспомогательный текст.
  static TextStyle body({
    double size = 15,
    FontWeight weight = FontWeight.w500,
    Color color = AppColors.inkSoft,
    bool openDyslexic = false,
    bool largeText = false,
  }) {
    final resolved = largeText ? size * 1.2 : size;
    if (openDyslexic) {
      return TextStyle(
        fontFamily: _openDyslexicFamily,
        fontSize: resolved,
        fontWeight: weight,
        color: color,
        height: 1.45,
      );
    }
    return GoogleFonts.nunito(
      fontSize: resolved,
      fontWeight: weight,
      color: color,
      height: 1.4,
    );
  }
}
