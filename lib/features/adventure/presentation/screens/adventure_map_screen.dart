import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:readquest/core/constants/app_routes.dart';
import 'package:readquest/core/theme/app_colors.dart';
import 'package:readquest/core/theme/app_spacing.dart';
import 'package:readquest/core/theme/app_typography.dart';
import 'package:readquest/core/widgets/game_screen.dart';
import 'package:readquest/features/adventure/domain/entities/adventure_location.dart';
import 'package:readquest/features/home/presentation/providers/game_providers.dart';

/// Прокручиваемая карта мира с живыми и закрытыми локациями.
class AdventureMapScreen extends ConsumerWidget {
  const AdventureMapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final world = ref.watch(gameControllerProvider).world;
    return GameScreen(
      title: 'Карта приключений',
      vitality: world.vitalityScore,
      child: SingleChildScrollView(
        padding: AppSpacing.screenPadding,
        child: SizedBox(
          height: 820,
          child: Stack(
            children: [
              Positioned.fill(child: CustomPaint(painter: _MapPathPainter())),
              ...WorldCatalog.locations.map((location) {
                final unlocked = world.unlockedLocationIds.contains(location.id);
                return Positioned(
                  left: location.mapX * 270,
                  top: location.mapY * 690,
                  child: _LocationNode(
                    location: location,
                    unlocked: unlocked,
                    onTap: () => unlocked
                        ? context.push(AppRoutes.locationPath(location.id))
                        : ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Сначала оживи предыдущую локацию!')),
                          ),
                  ),
                );
              }),
              Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: QuestCard(
                  child: Text('🌱 Мир жив на ${(world.vitalityScore * 100).round()}%. Читай, чтобы открыть новые дороги!', style: AppTypography.body(), textAlign: TextAlign.center),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LocationNode extends StatelessWidget {
  const _LocationNode({required this.location, required this.unlocked, required this.onTap});
  final AdventureLocation location;
  final bool unlocked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final icon = switch (location.type) {
      LocationType.village => '🏘️', LocationType.forest => '🌳', LocationType.cave => '💎',
      LocationType.castle => '🏰', LocationType.desert => '🏜️', LocationType.ice => '❄️',
      LocationType.volcano => '🌋', LocationType.sky => '☁️', LocationType.underwater => '🐠',
      LocationType.cosmos => '🌌',
    };
    return Semantics(
      button: true,
      label: location.name,
      child: GestureDetector(
        onTap: onTap,
        child: Opacity(
          opacity: unlocked ? 1 : .55,
          child: Container(
            width: 110,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: unlocked ? AppColors.cream : AppColors.worldGray, borderRadius: AppSpacing.borderMd, border: Border.all(color: unlocked ? AppColors.magicGold : Colors.white, width: 2), boxShadow: AppShadows.soft()),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text(unlocked ? icon : '🔒', style: const TextStyle(fontSize: 36)),
              Text(location.name, style: AppTypography.label(size: 12, color: unlocked ? AppColors.ink : Colors.white), textAlign: TextAlign.center),
            ]),
          ),
        ),
      ),
    );
  }
}

class _MapPathPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.sand.withValues(alpha: .8)..style = PaintingStyle.stroke..strokeWidth = 10..strokeCap = StrokeCap.round;
    final path = Path()..moveTo(65, 470)..quadraticBezierTo(180, 350, 115, 240)..quadraticBezierTo(240, 160, 200, 80)..quadraticBezierTo(150, 35, 250, 20);
    canvas.drawPath(path, paint);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
