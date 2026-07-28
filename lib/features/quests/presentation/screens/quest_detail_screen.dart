import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readquest/core/theme/app_colors.dart';
import 'package:readquest/core/theme/app_spacing.dart';
import 'package:readquest/core/theme/app_typography.dart';
import 'package:readquest/core/widgets/game_screen.dart';
import 'package:readquest/core/widgets/reading_challenge_panel.dart';
import 'package:readquest/features/home/presentation/providers/game_providers.dart';
import 'package:readquest/features/quests/data/quest_catalog.dart';

/// Подробности квеста и его текущая читательская задача.
class QuestDetailScreen extends ConsumerWidget {
  const QuestDetailScreen({required this.questId, super.key});
  final String questId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quest = QuestCatalog.byId(questId);
    if (quest == null) return const Scaffold(body: Center(child: Text('Квест не найден')));
    final challenge = quest.currentChallenge ?? quest.challenges.first;
    return GameScreen(title: quest.title, child: ListView(padding: AppSpacing.screenPadding, children: [
      QuestCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('🧑‍🌾 ${quest.npcName}', style: AppTypography.headline(size: 22)),
        const SizedBox(height: AppSpacing.xs),
        Text(quest.description, style: AppTypography.body(size: 17)),
        const SizedBox(height: AppSpacing.sm),
        LinearProgressIndicator(value: quest.progress, minHeight: 12, color: AppColors.dragonTeal, borderRadius: AppSpacing.borderSm),
        const SizedBox(height: AppSpacing.xs),
        Text('Награда: ${quest.rewards.map((reward) => '${reward.amount} ${reward.type.name}').join(', ')}', style: AppTypography.label(size: 13, color: AppColors.magicAmber)),
      ])),
      const SizedBox(height: AppSpacing.lg),
      ReadingChallengePanel(challenge: challenge, storyBeat: quest.storyBeat, onResult: (result) {
        if (result.isCorrect) ref.read(gameControllerProvider.notifier).registerReading(challenge: challenge, evaluation: result, durationMs: 0);
      }),
    ]));
  }
}
