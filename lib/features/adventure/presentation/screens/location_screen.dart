import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:readquest/core/constants/app_routes.dart';
import 'package:readquest/core/theme/app_colors.dart';
import 'package:readquest/core/theme/app_spacing.dart';
import 'package:readquest/core/theme/app_typography.dart';
import 'package:readquest/core/widgets/game_screen.dart';
import 'package:readquest/core/widgets/quest_button.dart';
import 'package:readquest/core/widgets/reading_challenge_panel.dart';
import 'package:readquest/features/adventure/domain/entities/adventure_location.dart';
import 'package:readquest/features/home/presentation/providers/game_providers.dart';
import 'package:readquest/features/quests/data/quest_catalog.dart';

/// Экран локации с заданиями, боссом и быстрым восстановлением мира.
class LocationScreen extends ConsumerWidget {
  const LocationScreen({required this.locationId, super.key});
  final String locationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = WorldCatalog.byId(locationId);
    if (location == null) return const Scaffold(body: Center(child: Text('Локация не найдена')));
    final game = ref.watch(gameControllerProvider);
    final quests = QuestCatalog.starter.where((q) => q.locationId == locationId).toList();
    final challenge = quests.isNotEmpty ? quests.first.challenges.first : QuestCatalog.starter.first.challenges.first;
    return GameScreen(
      title: location.name,
      vitality: game.world.vitalityScore,
      child: ListView(
        padding: AppSpacing.screenPadding,
        children: [
          QuestCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(_emoji(location.type), style: const TextStyle(fontSize: 66)),
            Text(location.description, style: AppTypography.body(size: 18)),
            const SizedBox(height: AppSpacing.sm),
            QuestMeter(label: 'Локация оживает', value: game.world.vitalityScore, color: AppColors.success),
          ])),
          const SizedBox(height: AppSpacing.lg),
          Text('Задания жителей', style: AppTypography.headline(color: AppColors.cream)),
          const SizedBox(height: AppSpacing.sm),
          ...quests.map((quest) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: QuestCard(child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const CircleAvatar(backgroundColor: AppColors.lumiGlow, child: Icon(Icons.assignment_turned_in_rounded)),
              title: Text(quest.title, style: AppTypography.label()),
              subtitle: Text('${quest.npcName}: ${quest.description}', style: AppTypography.body()),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => context.push(AppRoutes.questPath(quest.id)),
            )),
          )),
          const SizedBox(height: AppSpacing.sm),
          ReadingChallengePanel(
            challenge: challenge,
            storyBeat: 'Быстрое действие: почини мост чтением',
            onResult: (evaluation) {
              if (evaluation.isCorrect) {
                ref.read(gameControllerProvider.notifier).registerReading(challenge: challenge, evaluation: evaluation, durationMs: 0);
              }
            },
          ),
          const SizedBox(height: AppSpacing.lg),
          QuestButton(label: 'Вызвать босса', icon: Icons.shield_moon_rounded, onPressed: () => context.push(AppRoutes.bossPath(location.bossId))),
        ],
      ),
    );
  }

  String _emoji(LocationType type) => switch (type) {
    LocationType.village => '🏘️', LocationType.forest => '🌳', LocationType.cave => '💎',
    LocationType.castle => '🏰', LocationType.desert => '🏜️', LocationType.ice => '❄️',
    LocationType.volcano => '🌋', LocationType.sky => '☁️', LocationType.underwater => '🐠',
    LocationType.cosmos => '🌌',
  };
}
