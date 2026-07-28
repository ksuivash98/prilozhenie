import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:readquest/core/constants/app_routes.dart';
import 'package:readquest/core/theme/app_colors.dart';
import 'package:readquest/core/theme/app_spacing.dart';
import 'package:readquest/core/theme/app_typography.dart';
import 'package:readquest/core/widgets/game_screen.dart';
import 'package:readquest/features/library/domain/entities/story.dart';

/// Библиотека восстановленных историй с коллекцией иллюстраций.
class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) => GameScreen(
    title: 'Библиотека историй',
    child: ListView(padding: AppSpacing.screenPadding, children: [
      QuestCard(color: AppColors.cardWarm, child: Text('🏛️ Каждая история — часть мира, которую вернули читатели.', style: AppTypography.body(size: 17), textAlign: TextAlign.center)),
      const SizedBox(height: AppSpacing.lg),
      ...StoryCatalog.seed().map((story) => Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.md),
        child: QuestCard(child: ListTile(
          leading: const Text('📜', style: TextStyle(fontSize: 42)),
          title: Text(story.title, style: AppTypography.headline(size: 20)),
          subtitle: Text('${story.wordsCount} слов · ${story.illustrationKeys.length} иллюстрации', style: AppTypography.body()),
          trailing: const Icon(Icons.auto_stories_rounded, color: AppColors.dragonTeal),
          onTap: () => context.push(AppRoutes.storyPath(story.id)),
        )),
      )),
    ]),
  );
}
