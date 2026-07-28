import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readquest/core/theme/app_colors.dart';
import 'package:readquest/core/theme/app_spacing.dart';
import 'package:readquest/core/theme/app_typography.dart';
import 'package:readquest/core/widgets/game_screen.dart';
import 'package:readquest/core/widgets/quest_button.dart';
import 'package:readquest/features/home/presentation/providers/game_providers.dart';

/// Лавка косметики, в которой валюта зарабатывается только чтением.
class ShopScreen extends ConsumerWidget {
  const ShopScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coins = ref.watch(gameControllerProvider).inventory.coins;
    final items = [('🎨', 'Бирюзовая чешуя', 25), ('☁️', 'Облачные крылья', 45), ('💎', 'Кристальные рога', 70), ('⭐', 'Звёздные глаза', 100)];
    return GameScreen(title: 'Лавка Луми', child: ListView(padding: AppSpacing.screenPadding, children: [
      QuestCard(color: AppColors.cardWarm, child: Column(children: [
        Text('🪙 $coins читательских монет', style: AppTypography.headline(size: 23)),
        const SizedBox(height: 5),
        Text('Здесь нет покупок за настоящие деньги — монеты появляются только за чтение.', style: AppTypography.body(), textAlign: TextAlign.center),
      ])),
      const SizedBox(height: AppSpacing.lg),
      ...items.map((item) => Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.md),
        child: QuestCard(child: Row(children: [
          Text(item.$1, style: const TextStyle(fontSize: 44)),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: Text(item.$2, style: AppTypography.headline(size: 19))),
          Column(children: [
            Text('🪙 ${item.$3}', style: AppTypography.label()),
            const SizedBox(height: 5),
            SizedBox(width: 105, child: QuestButton(label: coins >= item.$3 ? 'Открыть' : 'Читай!', onPressed: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(coins >= item.$3 ? 'Этот образ откроется после добавления магазина в прогресс.' : 'Прочитай ещё ${item.$3 - coins} слов или заданий!'))))),
          ]),
        ])),
      )),
    ]));
  }
}
