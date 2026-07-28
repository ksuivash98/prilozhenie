import 'package:flutter/material.dart';

/// Палитра ReadQuest — живой, насыщенный мир без минимализма.
///
/// Вдохновение: Animal Crossing, Mario Wonder, Rayman, Dragon City.
/// Избегаем фиолетовых AI-клише и плоских однотонных фонов.
abstract final class AppColors {
  // ——— Основные ———
  static const Color skyDawn = Color(0xFF7EC8E3);
  static const Color skyMid = Color(0xFF4FA3D1);
  static const Color skyDusk = Color(0xFFFF8A65);
  static const Color meadow = Color(0xFF7CB342);
  static const Color meadowDeep = Color(0xFF558B2F);
  static const Color soil = Color(0xFF8D6E63);
  static const Color sand = Color(0xFFFFE082);

  // ——— Магия и акценты ———
  static const Color magicGold = Color(0xFFFFD54F);
  static const Color magicAmber = Color(0xFFFFB300);
  static const Color dragonCoral = Color(0xFFFF6F61);
  static const Color dragonTeal = Color(0xFF26A69A);
  static const Color lumiGlow = Color(0xFFFFF59D);
  static const Color runeCyan = Color(0xFF4DD0E1);
  static const Color berryPink = Color(0xFFEC407A);
  static const Color leafLime = Color(0xFFCDDC39);

  // ——— Мир / серость (без чтения) ———
  static const Color worldAlive = Color(0xFF81C784);
  static const Color worldFading = Color(0xFFB0BEC5);
  static const Color worldGray = Color(0xFF78909C);
  static const Color fog = Color(0xFF90A4AE);

  // ——— UI ———
  static const Color cream = Color(0xFFFFF8E7);
  static const Color parchment = Color(0xFFFFF3E0);
  static const Color ink = Color(0xFF3E2723);
  static const Color inkSoft = Color(0xFF5D4037);
  static const Color cardWarm = Color(0xFFFFECB3);
  static const Color success = Color(0xFF66BB6A);
  static const Color warning = Color(0xFFFFA726);
  static const Color danger = Color(0xFFEF5350);

  // ——— Контрастная доступность ———
  static const Color contrastBg = Color(0xFF121212);
  static const Color contrastFg = Color(0xFFFFFFF0);
  static const Color contrastAccent = Color(0xFFFFEB3B);

  // ——— Локации ———
  static const Color villageWarm = Color(0xFFFFCC80);
  static const Color forestMyst = Color(0xFF66BB6A);
  static const Color caveShadow = Color(0xFF5C6BC0);
  static const Color castleRoyal = Color(0xFFEF5350);
  static const Color desertSun = Color(0xFFFFCA28);
  static const Color iceFrost = Color(0xFF81D4FA);
  static const Color volcanoFire = Color(0xFFFF7043);
  static const Color skyCloud = Color(0xFFB3E5FC);
  static const Color oceanDeep = Color(0xFF29B6F6);
  static const Color cosmosNight = Color(0xFF3949AB);

  /// Градиент неба главного экрана.
  static const LinearGradient heroSky = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [skyDawn, skyMid, Color(0xFFA5D6A7)],
    stops: [0.0, 0.45, 1.0],
  );

  /// Градиент магической награды.
  static const LinearGradient rewardGlow = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [magicGold, magicAmber, dragonCoral],
  );

  /// Градиент кнопки CTA.
  static const LinearGradient ctaGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFF8A65), dragonCoral],
  );

  /// Градиент «ожившего» мира.
  static const LinearGradient worldAliveGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [meadow, dragonTeal, runeCyan],
  );
}
