import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:readquest/core/constants/app_routes.dart';
import 'package:readquest/core/theme/app_colors.dart';
import 'package:readquest/core/theme/app_typography.dart';
import 'package:readquest/core/widgets/living_background.dart';
import 'package:readquest/features/settings/presentation/providers/settings_providers.dart';

/// Стартовая заставка, выбирающая первый маршрут ребёнка.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), _navigate);
  }

  void _navigate() {
    if (!mounted) return;
    final settings = ref.read(appSettingsProvider);
    context.go(settings.onboardingComplete ? AppRoutes.home : AppRoutes.onboarding);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LivingBackground(
      child: Center(
        child: AnimatedBuilder(
          animation: _pulse,
          builder: (context, _) => Transform.scale(
            scale: 1 + _pulse.value * .04,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('🥚', style: TextStyle(fontSize: 92)),
                Text('ReadQuest', style: AppTypography.display(size: 48, color: AppColors.cream)),
                const SizedBox(height: 12),
                Text(
                  'Читай — и мир оживёт!',
                  style: AppTypography.headline(size: 22, color: AppColors.lumiGlow),
                ),
                const SizedBox(height: 34),
                const SizedBox(
                  height: 28,
                  width: 28,
                  child: CircularProgressIndicator(color: AppColors.magicGold, strokeWidth: 4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
