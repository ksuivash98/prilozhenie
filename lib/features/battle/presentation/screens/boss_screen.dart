import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:readquest/core/constants/app_routes.dart';
import 'package:readquest/core/theme/app_colors.dart';
import 'package:readquest/core/theme/app_spacing.dart';
import 'package:readquest/core/theme/app_typography.dart';
import 'package:readquest/core/widgets/game_screen.dart';
import 'package:readquest/core/widgets/quest_button.dart';
import 'package:readquest/features/battle/data/enemy_catalog.dart';

/// Драматичное вступление перед боем с боссом локации.
class BossScreen extends ConsumerWidget {
  const BossScreen({required this.bossId, super.key});
  final String bossId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boss = EnemyCatalog.byId(bossId);
    return GameScreen(
      title: 'Встреча с боссом',
      vitality: .35,
      child: Center(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: QuestCard(
            color: AppColors.ink.withValues(alpha: .9),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              const Text('👹', style: TextStyle(fontSize: 104)),
              Text(boss.name, style: AppTypography.display(size: 31, color: AppColors.magicGold), textAlign: TextAlign.center),
              const SizedBox(height: AppSpacing.sm),
              Text(boss.introText, style: AppTypography.reading(size: 20, color: Colors.white), textAlign: TextAlign.center),
              const SizedBox(height: AppSpacing.md),
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(color: AppColors.danger.withValues(alpha: .25), borderRadius: AppSpacing.borderMd),
                child: Text('❤️ ${boss.maxHp} · Босс получает урон от длины слова', style: AppTypography.label(color: AppColors.cream), textAlign: TextAlign.center),
              ),
              const SizedBox(height: AppSpacing.lg),
              QuestButton(label: 'Сразиться силой слов!', icon: Icons.bolt_rounded, onPressed: () => context.go(AppRoutes.battlePath(bossId))),
            ]),
          ),
        ),
      ),
    );
  }
}
