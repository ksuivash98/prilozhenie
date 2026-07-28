import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:readquest/core/constants/app_routes.dart';
import 'package:readquest/core/theme/app_colors.dart';
import 'package:readquest/core/theme/app_spacing.dart';
import 'package:readquest/core/theme/app_typography.dart';
import 'package:readquest/core/widgets/game_screen.dart';
import 'package:readquest/features/home/presentation/providers/game_providers.dart';
import 'package:readquest/features/library/domain/entities/story.dart';

/// Полка с короткими интерактивными книгами.
class BooksScreen extends ConsumerWidget {
  const BooksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final words = ref.watch(gameControllerProvider).progress.wordsReadTotal;
    final books = StoryCatalog.seed();
    return GameScreen(
      title: 'Книжная поляна',
      child: ListView(padding: AppSpacing.screenPadding, children: [
        QuestCard(color: AppColors.cardWarm, child: Text('📚 Здесь чтение оживляет истории. Уже прочитано слов: $words', style: AppTypography.body(size: 17), textAlign: TextAlign.center)),
        const SizedBox(height: AppSpacing.lg),
        ...books.map((book) => Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: QuestCard(child: InkWell(
            onTap: () => context.push(AppRoutes.bookPath(book.id)),
            child: Row(children: [
              const Text('📖', style: TextStyle(fontSize: 52)),
              const SizedBox(width: AppSpacing.md),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(book.title, style: AppTypography.headline(size: 20)),
                Text('${book.pages.length} страниц · ${book.wordsCount} слов', style: AppTypography.body()),
              ])),
              const Icon(Icons.play_circle_fill_rounded, color: AppColors.dragonTeal),
            ]),
          )),
        )),
      ]),
    );
  }
}
