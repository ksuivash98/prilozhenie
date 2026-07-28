import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readquest/core/theme/app_colors.dart';
import 'package:readquest/core/theme/app_spacing.dart';
import 'package:readquest/core/theme/app_typography.dart';
import 'package:readquest/core/widgets/game_screen.dart';
import 'package:readquest/features/home/presentation/providers/game_providers.dart';

/// Рюкзак с найденными предметами и читательскими монетами.
class InventoryScreen extends ConsumerWidget {
  const InventoryScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inventory = ref.watch(gameControllerProvider).inventory;
    return GameScreen(title: 'Волшебный рюкзак', child: ListView(padding: AppSpacing.screenPadding, children: [
      QuestCard(color: AppColors.cardWarm, child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        _amount('🪙', inventory.coins, 'монет'),
        _amount('💎', inventory.gems, 'кристаллов'),
      ])),
      const SizedBox(height: AppSpacing.lg),
      if (inventory.items.isEmpty)
        QuestCard(child: Column(children: [
          const Text('🎒', style: TextStyle(fontSize: 70)),
          Text('Рюкзак пока ждёт находок!', style: AppTypography.headline(size: 20)),
          const SizedBox(height: 6),
          Text('Выполняй квесты, побеждай боссов и читай истории.', style: AppTypography.body(), textAlign: TextAlign.center),
        ]))
      else ...inventory.items.map((item) => Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
        child: QuestCard(child: ListTile(leading: const Text('✨', style: TextStyle(fontSize: 30)), title: Text(item.name, style: AppTypography.label()), subtitle: Text(item.description), trailing: Text('×${item.quantity}', style: AppTypography.headline(size: 20)))),
      )),
    ]));
  }
  Widget _amount(String icon, int amount, String name) => Column(children: [Text(icon, style: const TextStyle(fontSize: 34)), Text('$amount', style: AppTypography.display(size: 26)), Text(name, style: AppTypography.body(size: 13))]);
}
