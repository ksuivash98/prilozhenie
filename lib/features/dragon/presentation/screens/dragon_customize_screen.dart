import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readquest/core/theme/app_colors.dart';
import 'package:readquest/core/theme/app_spacing.dart';
import 'package:readquest/core/theme/app_typography.dart';
import 'package:readquest/core/widgets/game_screen.dart';
import 'package:readquest/features/dragon/domain/entities/dragon.dart';
import 'package:readquest/features/home/presentation/providers/game_providers.dart';

/// Мастерская внешности: доступны только открытые чтением части.
class DragonCustomizeScreen extends ConsumerWidget {
  const DragonCustomizeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dragon = ref.watch(gameControllerProvider).dragon;
    final sets = <String, List<(String, String)>>{
      'Цвет': [('coral', 'Коралловый'), ('teal', 'Бирюзовый'), ('gold', 'Золотой')],
      'Крылья': [('basic', 'Листочки'), ('cloud', 'Облачные'), ('flame', 'Огненные')],
      'Рога': [('none', 'Без рогов'), ('small', 'Маленькие'), ('crystal', 'Кристальные')],
      'Глаза': [('amber', 'Янтарные'), ('mint', 'Мятные'), ('star', 'Звёздные')],
    };
    return GameScreen(
      title: 'Мастерская дракона',
      child: ListView(padding: AppSpacing.screenPadding, children: [
        QuestCard(color: AppColors.cardWarm, child: Column(children: [
          const Text('🐉', style: TextStyle(fontSize: 94)),
          Text('Выбирай то, что уже открыл чтением!', style: AppTypography.body(size: 17), textAlign: TextAlign.center),
        ])),
        const SizedBox(height: AppSpacing.lg),
        ...sets.entries.map((entry) => _Picker(
          title: entry.key,
          choices: entry.value,
          selected: switch (entry.key) { 'Цвет' => dragon.appearance.colorId, 'Крылья' => dragon.appearance.wingsId, 'Рога' => dragon.appearance.hornsId, _ => dragon.appearance.eyesId },
          unlocked: dragon.unlockedParts,
          onSelect: (id) {
            final appearance = switch (entry.key) {
              'Цвет' => dragon.appearance.copyWith(colorId: id),
              'Крылья' => dragon.appearance.copyWith(wingsId: id),
              'Рога' => dragon.appearance.copyWith(hornsId: id),
              _ => dragon.appearance.copyWith(eyesId: id),
            };
            ref.read(gameControllerProvider.notifier).updateDragon(dragon.copyWith(appearance: appearance));
          },
        )),
      ]),
    );
  }
}

class _Picker extends StatelessWidget {
  const _Picker({required this.title, required this.choices, required this.selected, required this.unlocked, required this.onSelect});
  final String title;
  final List<(String, String)> choices;
  final String selected;
  final Set<String> unlocked;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.md),
    child: QuestCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: AppTypography.headline(size: 20)),
      const SizedBox(height: AppSpacing.sm),
      Wrap(spacing: 8, runSpacing: 8, children: choices.map((choice) {
        final available = unlocked.contains(choice.$1);
        return ChoiceChip(
          selected: selected == choice.$1,
          label: Text(available ? choice.$2 : '🔒 ${choice.$2}'),
          onSelected: available ? (_) => onSelect(choice.$1) : null,
          selectedColor: AppColors.lumiGlow,
        );
      }).toList()),
    ])),
  );
}
