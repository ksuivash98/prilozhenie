import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readquest/core/theme/app_colors.dart';
import 'package:readquest/core/theme/app_spacing.dart';
import 'package:readquest/core/theme/app_typography.dart';
import 'package:readquest/core/widgets/game_screen.dart';
import 'package:readquest/features/home/presentation/providers/game_providers.dart';

/// Витрина достижений за чтение и исследование мира.
class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final achievements = ref.watch(gameControllerProvider).achievements;
    return GameScreen(title: 'Медали приключений', child: ListView(padding: AppSpacing.screenPadding, children: [
      QuestCard(color: AppColors.cardWarm, child: Text('🏆 Открыто ${achievements.where((item) => item.isUnlocked).length} из ${achievements.length}', style: AppTypography.headline(size: 21), textAlign: TextAlign.center)),
      const SizedBox(height: AppSpacing.lg),
      ...achievements.map((achievement) => Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
        child: Opacity(opacity: achievement.isUnlocked ? 1 : .72, child: QuestCard(child: Row(children: [
          Text(achievement.isUnlocked ? '🏅' : '🔒', style: const TextStyle(fontSize: 39)),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(achievement.title, style: AppTypography.label()),
            Text(achievement.description, style: AppTypography.body(size: 13)),
            const SizedBox(height: 5),
            LinearProgressIndicator(value: achievement.progress, color: AppColors.magicAmber, borderRadius: AppSpacing.borderSm),
          ])),
        ]))),
      )),
    ]));
  }
}
