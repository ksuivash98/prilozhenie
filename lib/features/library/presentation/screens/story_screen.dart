import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readquest/core/theme/app_colors.dart';
import 'package:readquest/core/theme/app_spacing.dart';
import 'package:readquest/core/theme/app_typography.dart';
import 'package:readquest/core/widgets/game_screen.dart';
import 'package:readquest/core/widgets/quest_button.dart';
import 'package:readquest/features/library/domain/entities/story.dart';

/// Просмотр истории как раскрывающейся книжки.
class StoryScreen extends ConsumerStatefulWidget {
  const StoryScreen({required this.storyId, super.key});
  final String storyId;
  @override
  ConsumerState<StoryScreen> createState() => _StoryScreenState();
}
class _StoryScreenState extends ConsumerState<StoryScreen> {
  int _page = 0;
  @override
  Widget build(BuildContext context) {
    final stories = StoryCatalog.seed();
    final story = stories.where((story) => story.id == widget.storyId).isEmpty ? stories.first : stories.firstWhere((story) => story.id == widget.storyId);
    return GameScreen(title: story.title, child: Padding(
      padding: AppSpacing.screenPadding,
      child: Column(children: [
        Expanded(child: QuestCard(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(['🌅', '🐿️', '✨', '🐉'][_page], style: const TextStyle(fontSize: 88)),
          const SizedBox(height: AppSpacing.lg),
          Text(story.pages[_page], style: AppTypography.reading(size: 28), textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.lg),
          Text('Страница ${_page + 1} / ${story.pages.length}', style: AppTypography.label(color: AppColors.dragonTeal)),
        ]))),
        const SizedBox(height: AppSpacing.md),
        Row(children: [
          Expanded(child: QuestButton(label: 'Назад', icon: Icons.arrow_back_rounded, onPressed: _page == 0 ? null : () => setState(() => _page--))),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: QuestButton(label: _page == story.pages.length - 1 ? 'Сначала' : 'Дальше', icon: Icons.arrow_forward_rounded, onPressed: () => setState(() => _page = _page == story.pages.length - 1 ? 0 : _page + 1))),
        ]),
      ]),
    ));
  }
}
