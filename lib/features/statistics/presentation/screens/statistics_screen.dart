import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readquest/core/theme/app_colors.dart';
import 'package:readquest/core/theme/app_spacing.dart';
import 'package:readquest/core/theme/app_typography.dart';
import 'package:readquest/core/widgets/game_screen.dart';
import 'package:readquest/features/home/presentation/providers/game_providers.dart';

/// Наглядная статистика чтения без оценок и давления.
class StatisticsScreen extends ConsumerWidget {
  const StatisticsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(gameControllerProvider).statistics;
    final days = stats.daily.take(7).toList().reversed.toList();
    final maxWords = [...days.map((day) => day.wordsRead), 1].reduce((a, b) => a > b ? a : b);
    return GameScreen(title: 'Статистика чтения', child: ListView(padding: AppSpacing.screenPadding, children: [
      Wrap(spacing: 10, runSpacing: 10, children: [
        _metric('📚', '${stats.totalWords}', 'слов всего'),
        _metric('⏱️', '${(stats.totalSeconds / 60).round()}', 'минут'),
        _metric('🎯', '${(stats.accuracy * 100).round()}%', 'точность'),
        _metric('🔥', '${stats.bestStreak}', 'лучший ритм'),
      ]),
      const SizedBox(height: AppSpacing.lg),
      QuestCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Последние чтения', style: AppTypography.headline(size: 21)),
        const SizedBox(height: AppSpacing.md),
        if (days.isEmpty) Text('Первое прочитанное слово появится здесь как росток!', style: AppTypography.body(size: 16))
        else SizedBox(height: 150, child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: days.map((day) => Expanded(child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
            Expanded(child: FractionallySizedBox(heightFactor: day.wordsRead / maxWords, alignment: Alignment.bottomCenter, child: Container(decoration: BoxDecoration(color: AppColors.dragonTeal, borderRadius: AppSpacing.borderSm)))),
            const SizedBox(height: 5),
            Text('${day.wordsRead}', style: AppTypography.label(size: 11)),
          ]),
        )).toList())),
      ])),
      const SizedBox(height: AppSpacing.md),
      QuestCard(child: Text(stats.hardWords.isEmpty ? '🌟 Читай в своём темпе — ошибки помогают Луми выбрать следующее упражнение.' : 'Луми предложит повторить: ${stats.hardWords.keys.take(4).join(', ')}.', style: AppTypography.body(size: 16), textAlign: TextAlign.center)),
    ]));
  }
  Widget _metric(String icon, String value, String label) => SizedBox(width: 150, child: QuestCard(child: Column(children: [Text(icon, style: const TextStyle(fontSize: 32)), Text(value, style: AppTypography.headline(size: 21)), Text(label, style: AppTypography.body(size: 12))])));
}
