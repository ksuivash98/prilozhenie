import 'package:flutter/material.dart';
import 'package:readquest/core/theme/app_colors.dart';
import 'package:readquest/core/theme/app_spacing.dart';
import 'package:readquest/core/theme/app_typography.dart';
import 'package:readquest/core/widgets/game_screen.dart';
import 'package:readquest/core/widgets/quest_button.dart';
import 'package:readquest/features/books/domain/entities/reading_challenge.dart';

/// Контракт мини-игры: уникальная механика + чтение как ключ победы.
abstract class MiniGameBoard extends StatefulWidget {
  const MiniGameBoard({
    required this.onScore,
    required this.onNeedRead,
    super.key,
  });

  /// Вызывается при игровом успехе (очки).
  final void Function(int points, String message) onScore;

  /// Запрашивает чтение для завершения механики.
  final void Function(ReadingChallenge challenge) onNeedRead;
}

/// Базовая оболочка механики.
class MechanicScaffold extends StatelessWidget {
  const MechanicScaffold({
    required this.title,
    required this.subtitle,
    required this.child,
    super.key,
    this.emoji = '✨',
  });

  final String title;
  final String subtitle;
  final String emoji;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return QuestCard(
      color: AppColors.cream.withValues(alpha: 0.95),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(emoji, textAlign: TextAlign.center, style: const TextStyle(fontSize: 48)),
          Text(title, style: AppTypography.headline(size: 20), textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.xs),
          Text(subtitle, style: AppTypography.body(size: 14), textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.md),
          child,
        ],
      ),
    );
  }
}

/// Кнопка-буква для сборки слов.
class LetterChip extends StatelessWidget {
  const LetterChip({
    required this.letter,
    required this.onTap,
    super.key,
    this.selected = false,
    this.highlight = false,
  });

  final String letter;
  final VoidCallback onTap;
  final bool selected;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Material(
        color: highlight
            ? AppColors.magicGold
            : selected
                ? AppColors.dragonTeal
                : AppColors.parchment,
        borderRadius: AppSpacing.borderMd,
        elevation: 3,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppSpacing.borderMd,
          child: SizedBox(
            width: 48,
            height: 56,
            child: Center(
              child: Text(
                letter.toUpperCase(),
                style: AppTypography.headline(
                  size: 24,
                  color: selected || highlight ? Colors.white : AppColors.ink,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Фабрика челленджей для мини-игр.
abstract final class MiniGameChallenges {
  static ReadingChallenge word(String id, String prompt, String text) {
    return ReadingChallenge(
      id: id,
      type: ReadingChallengeType.word,
      prompt: prompt,
      targetText: text,
      difficulty: ChallengeDifficulty.easy,
      wordPower: text.length.clamp(2, 12) as int,
      xpReward: 8 + text.length,
    );
  }
}

/// Общий результат-баннер.
class MiniGameWinBanner extends StatelessWidget {
  const MiniGameWinBanner({required this.message, super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return QuestCard(
      color: AppColors.lumiGlow,
      child: Column(
        children: [
          Text(message, style: AppTypography.headline(size: 18), textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.sm),
          const QuestButton(label: 'Ещё раз!', onPressed: null),
        ],
      ),
    );
  }
}
