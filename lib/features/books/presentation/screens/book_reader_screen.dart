import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readquest/core/theme/app_colors.dart';
import 'package:readquest/core/theme/app_spacing.dart';
import 'package:readquest/core/theme/app_typography.dart';
import 'package:readquest/core/widgets/game_screen.dart';
import 'package:readquest/core/widgets/quest_button.dart';
import 'package:readquest/core/widgets/reading_challenge_panel.dart';
import 'package:readquest/features/books/domain/entities/reading_challenge.dart';
import 'package:readquest/features/home/presentation/providers/game_providers.dart';
import 'package:readquest/features/library/domain/entities/story.dart';

/// Читалка с постраничной историей и проверкой прочитанной фразы.
class BookReaderScreen extends ConsumerStatefulWidget {
  const BookReaderScreen({required this.bookId, super.key});
  final String bookId;

  @override
  ConsumerState<BookReaderScreen> createState() => _BookReaderScreenState();
}

class _BookReaderScreenState extends ConsumerState<BookReaderScreen> {
  int _page = 0;
  @override
  Widget build(BuildContext context) {
    final books = StoryCatalog.seed();
    final book = books.any((item) => item.id == widget.bookId)
        ? books.firstWhere((item) => item.id == widget.bookId)
        : books.first;
    final text = book.pages[_page];
    final challenge = ReadingChallenge(id: '${book.id}_$_page', type: ReadingChallengeType.story, prompt: 'Прочитай страницу вслух или введи её', targetText: text, difficulty: ChallengeDifficulty.easy, xpReward: 12, wordPower: text.split(' ').length);
    return GameScreen(
      title: book.title,
      child: ListView(padding: AppSpacing.screenPadding, children: [
        QuestCard(color: AppColors.parchment, child: Column(children: [
          Text('Страница ${_page + 1} из ${book.pages.length}', style: AppTypography.label(color: AppColors.dragonTeal)),
          const SizedBox(height: AppSpacing.lg),
          Text(text, style: AppTypography.reading(size: 27), textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.lg),
          Row(children: [
            IconButton.filledTonal(onPressed: _page == 0 ? null : () => setState(() => _page--), icon: const Icon(Icons.arrow_back_rounded)),
            const Spacer(),
            Text('✨', style: TextStyle(fontSize: 38 + _page * 3)),
            const Spacer(),
            IconButton.filledTonal(onPressed: _page == book.pages.length - 1 ? null : () => setState(() => _page++), icon: const Icon(Icons.arrow_forward_rounded)),
          ]),
        ])),
        const SizedBox(height: AppSpacing.lg),
        ReadingChallengePanel(challenge: challenge, storyBeat: 'Верно прочитанная страница добавит света в книгу.', onResult: (result) {
          if (result.isCorrect) ref.read(gameControllerProvider.notifier).registerReading(challenge: challenge, evaluation: result, durationMs: 0);
        }),
        if (_page == book.pages.length - 1) ...[
          const SizedBox(height: AppSpacing.md),
          QuestButton(label: 'История прочитана!', icon: Icons.celebration_rounded, onPressed: () {}),
        ],
      ]),
    );
  }
}
