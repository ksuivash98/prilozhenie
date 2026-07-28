import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:readquest/core/theme/app_colors.dart';
import 'package:readquest/core/theme/app_spacing.dart';
import 'package:readquest/core/theme/app_typography.dart';

/// Тема приложения ReadQuest.
abstract final class AppTheme {
  /// Светлая «живая» тема для детей.
  static ThemeData light({
    bool largeText = false,
    bool highContrast = false,
    bool openDyslexic = false,
    double animationSpeed = 1.0,
  }) {
    final textTheme = _buildTextTheme(
      largeText: largeText,
      openDyslexic: openDyslexic,
      highContrast: highContrast,
    );

    final colorScheme = ColorScheme.light(
      primary: AppColors.dragonCoral,
      onPrimary: Colors.white,
      secondary: AppColors.dragonTeal,
      onSecondary: Colors.white,
      tertiary: AppColors.magicAmber,
      surface: AppColors.cream,
      onSurface: highContrast ? AppColors.ink : AppColors.inkSoft,
      error: AppColors.danger,
      outline: AppColors.soil.withValues(alpha: 0.35),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.cream,
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.ink,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: AppTypography.headline(
          openDyslexic: openDyslexic,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 4,
          shadowColor: AppColors.ink.withValues(alpha: 0.25),
          backgroundColor: AppColors.dragonCoral,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: AppSpacing.borderLg,
          ),
          textStyle: AppTypography.label(openDyslexic: openDyslexic),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.dragonTeal,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: AppSpacing.borderLg,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.parchment,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: AppSpacing.borderLg,
        ),
        margin: const EdgeInsets.all(AppSpacing.sm),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.cardWarm,
        selectedColor: AppColors.magicGold,
        labelStyle: AppTypography.label(size: 14, openDyslexic: openDyslexic),
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.parchment,
        shape: const RoundedRectangleBorder(
          borderRadius: AppSpacing.borderXl,
        ),
        titleTextStyle: AppTypography.headline(openDyslexic: openDyslexic),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.ink,
        contentTextStyle: AppTypography.body(color: Colors.white),
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(
          borderRadius: AppSpacing.borderMd,
        ),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
      extensions: [
        ReadQuestThemeExtension(
          animationSpeed: animationSpeed,
          readingStyle: AppTypography.reading(
            openDyslexic: openDyslexic,
            largeText: largeText,
          ),
        ),
      ],
    );
  }

  /// Высококонтрастная тема доступности.
  static ThemeData highContrast() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.contrastBg,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.contrastAccent,
        onPrimary: Colors.black,
        secondary: AppColors.runeCyan,
        surface: AppColors.contrastBg,
        onSurface: AppColors.contrastFg,
        error: AppColors.danger,
      ),
      textTheme: _buildTextTheme(
        largeText: true,
        openDyslexic: false,
        highContrast: true,
      ),
    );
  }

  static TextTheme _buildTextTheme({
    required bool largeText,
    required bool openDyslexic,
    required bool highContrast,
  }) {
    final color = highContrast ? AppColors.contrastFg : AppColors.ink;
    return TextTheme(
      displayLarge: AppTypography.display(
        size: largeText ? 40 : 36,
        color: color,
        openDyslexic: openDyslexic,
      ),
      displayMedium: AppTypography.display(
        size: largeText ? 34 : 30,
        color: color,
        openDyslexic: openDyslexic,
      ),
      headlineLarge: AppTypography.headline(
        size: largeText ? 28 : 24,
        color: color,
        openDyslexic: openDyslexic,
      ),
      headlineMedium: AppTypography.headline(
        size: largeText ? 24 : 20,
        color: color,
        openDyslexic: openDyslexic,
      ),
      titleLarge: AppTypography.label(
        size: largeText ? 20 : 18,
        color: color,
        openDyslexic: openDyslexic,
      ),
      bodyLarge: AppTypography.body(
        size: largeText ? 18 : 16,
        color: color,
        openDyslexic: openDyslexic,
        largeText: largeText,
      ),
      bodyMedium: AppTypography.body(
        size: largeText ? 16 : 14,
        color: color,
        openDyslexic: openDyslexic,
        largeText: largeText,
      ),
      labelLarge: AppTypography.label(
        size: largeText ? 18 : 16,
        color: color,
        openDyslexic: openDyslexic,
      ),
    );
  }
}

/// Расширение темы с игровыми параметрами ReadQuest.
@immutable
class ReadQuestThemeExtension extends ThemeExtension<ReadQuestThemeExtension> {
  const ReadQuestThemeExtension({
    required this.animationSpeed,
    required this.readingStyle,
  });

  final double animationSpeed;
  final TextStyle readingStyle;

  @override
  ReadQuestThemeExtension copyWith({
    double? animationSpeed,
    TextStyle? readingStyle,
  }) {
    return ReadQuestThemeExtension(
      animationSpeed: animationSpeed ?? this.animationSpeed,
      readingStyle: readingStyle ?? this.readingStyle,
    );
  }

  @override
  ReadQuestThemeExtension lerp(
    ThemeExtension<ReadQuestThemeExtension>? other,
    double t,
  ) {
    if (other is! ReadQuestThemeExtension) return this;
    return ReadQuestThemeExtension(
      animationSpeed:
          animationSpeed + (other.animationSpeed - animationSpeed) * t,
      readingStyle: TextStyle.lerp(readingStyle, other.readingStyle, t)!,
    );
  }
}

/// Удобный доступ к расширению темы.
extension ReadQuestThemeX on BuildContext {
  /// Параметры темы ReadQuest.
  ReadQuestThemeExtension get rqTheme =>
      Theme.of(this).extension<ReadQuestThemeExtension>() ??
      ReadQuestThemeExtension(
        animationSpeed: 1,
        readingStyle: AppTypography.reading(),
      );
}
