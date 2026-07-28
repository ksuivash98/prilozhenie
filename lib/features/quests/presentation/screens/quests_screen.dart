import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:readquest/core/constants/app_routes.dart';
import 'package:readquest/core/theme/app_colors.dart';
import 'package:readquest/core/theme/app_spacing.dart';
import 'package:readquest/core/theme/app_typography.dart';
import 'package:readquest/core/widgets/game_screen.dart';
import 'package:readquest/features/quests/data/quest_catalog.dart';
import 'package:readquest/features/quests/domain/entities/quest.dart';

/// Журнал заданий героев мира.
class QuestsScreen extends ConsumerWidget {
  const QuestsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) => GameScreen(
    title: 'Журнал квестов',
    child: ListView(padding: AppSpacing.screenPadding, children: [
      QuestCard(color: AppColors.cardWarm, child: Text('🤝 Жители ждут твоих слов. Выполняй задания, чтобы мир становился ярче!', style: AppTypography.body(size: 17))),
      const SizedBox(height: AppSpacing.lg),
      ...QuestCatalog.starter.map((quest) => Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
        child: QuestCard(child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(backgroundColor: quest.status == QuestStatus.locked ? AppColors.worldGray : AppColors.lumiGlow, child: Icon(quest.status == QuestStatus.locked ? Icons.lock : Icons.assignment_turned_in_rounded)),
          title: Text(quest.title, style: AppTypography.headline(size: 19)),
          subtitle: Text('${quest.npcName} · ${quest.description}', style: AppTypography.body()),
          trailing: const Icon(Icons.chevron_right_rounded),
          onTap: quest.status == QuestStatus.locked ? null : () => context.push(AppRoutes.questPath(quest.id)),
        )),
      )),
    ]),
  );
}
