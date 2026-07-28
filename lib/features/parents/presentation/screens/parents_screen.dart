import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:readquest/core/constants/app_routes.dart';
import 'package:readquest/core/di/service_providers.dart';
import 'package:readquest/core/theme/app_colors.dart';
import 'package:readquest/core/theme/app_spacing.dart';
import 'package:readquest/core/theme/app_typography.dart';
import 'package:readquest/core/widgets/game_screen.dart';
import 'package:readquest/core/widgets/quest_button.dart';
import 'package:readquest/features/home/presentation/providers/game_providers.dart';

/// Родительский кабинет: статистика, прогресс, экспорт. Без рекламы и покупок.
class ParentsScreen extends ConsumerWidget {
  const ParentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final game = ref.watch(gameControllerProvider);
    final stats = game.statistics;
    final adaptive = game.adaptive;

    return GameScreen(
      title: 'Для родителей',
      child: ListView(
        padding: AppSpacing.screenPadding,
        children: [
          QuestCard(
            color: AppColors.cardWarm,
            child: Text(
              'Прогресс юного читателя',
              style: AppTypography.display(size: 26),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _card('📖', '${stats.totalWords}', 'слов'),
              _card('⏱️', '${(stats.totalSeconds / 60).round()}', 'минут'),
              _card('🎯', '${(stats.accuracy * 100).round()}%', 'точность'),
              _card('🔥', '${stats.currentStreak}', 'дней подряд'),
              _card('⭐', '${game.progress.level}', 'уровень'),
              _card('🐉', _dragonLabel(game.dragon.stage.name), 'дракон'),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          QuestCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Адаптивное обучение', style: AppTypography.headline(size: 20)),
                const SizedBox(height: 8),
                Text(
                  'Уровень сложности: ${adaptive.level}/10 · '
                  'Рекомендация: ${adaptive.recommendedDifficulty.name}',
                  style: AppTypography.body(size: 15),
                ),
                const SizedBox(height: 6),
                Text(
                  adaptive.topHardLetters().isEmpty
                      ? 'Сложных букв пока нет — отличный старт!'
                      : 'Буквы для мягкой тренировки: ${adaptive.topHardLetters().join(', ')}',
                  style: AppTypography.body(size: 14),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          QuestCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Наблюдение', style: AppTypography.headline(size: 20)),
                const SizedBox(height: 8),
                Text(
                  stats.hardWords.isEmpty
                      ? 'Пока нет сложных слов — ребёнок только начинает путь.'
                      : 'Стоит мягко повторить: ${stats.hardWords.keys.take(5).join(', ')}.',
                  style: AppTypography.body(size: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  'Все награды зарабатываются чтением. '
                  'В приложении нет рекламы, покупок и внешних ссылок.',
                  style: AppTypography.label(size: 13, color: AppColors.dragonTeal),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          QuestButton(
            label: 'Экспорт статистики',
            icon: Icons.copy_all_rounded,
            gradient: AppColors.worldAliveGradient,
            onPressed: () async {
              final json = ref
                  .read(progressStorageProvider)
                  .exportStatisticsJson(stats);
              await Clipboard.setData(ClipboardData(text: json));
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Статистика скопирована в буфер обмена'),
                  ),
                );
              }
            },
          ),
          const SizedBox(height: AppSpacing.sm),
          OutlinedButton.icon(
            onPressed: () => context.push(AppRoutes.statistics),
            icon: const Icon(Icons.analytics_rounded),
            label: const Text('Подробные графики'),
          ),
        ],
      ),
    );
  }

  String _dragonLabel(String stage) => switch (stage) {
        'egg' => 'яйцо',
        'baby' => 'малыш',
        'teen' => 'подросток',
        'adult' => 'взрослый',
        'legendary' => 'легенда',
        _ => stage,
      };

  Widget _card(String icon, String value, String label) {
    return SizedBox(
      width: 150,
      child: QuestCard(
        child: Column(
          children: [
            Text(icon, style: const TextStyle(fontSize: 32)),
            Text(value, style: AppTypography.headline(size: 20)),
            Text(label, style: AppTypography.body(size: 12)),
          ],
        ),
      ),
    );
  }
}
