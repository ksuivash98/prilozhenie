import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:readquest/core/constants/app_routes.dart';
import 'package:readquest/core/theme/app_colors.dart';
import 'package:readquest/core/theme/app_spacing.dart';
import 'package:readquest/core/theme/app_typography.dart';
import 'package:readquest/core/widgets/game_screen.dart';
import 'package:readquest/core/widgets/quest_button.dart';
import 'package:readquest/features/dragon/domain/entities/dragon.dart';
import 'package:readquest/features/home/presentation/providers/game_providers.dart';

/// Дом дракона: развитие, настроение и дружеский уход.
class DragonScreen extends ConsumerWidget {
  const DragonScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dragon = ref.watch(gameControllerProvider).dragon;
    return GameScreen(
      title: 'Дракон ${dragon.name}',
      child: ListView(padding: AppSpacing.screenPadding, children: [
        QuestCard(
          color: AppColors.cardWarm,
          child: Column(children: [
            Text(dragon.stage == DragonStage.egg ? '🥚' : '🐉', style: const TextStyle(fontSize: 112)),
            Text(_stage(dragon.stage), style: AppTypography.display(size: 28)),
            const SizedBox(height: AppSpacing.sm),
            _meter('Опыт эволюции', dragon.stageProgress, AppColors.dragonCoral, '${dragon.xp}/${dragon.xpToNextStage} XP'),
            const SizedBox(height: AppSpacing.md),
            _meter('Радость', dragon.happiness, AppColors.berryPink, '${(dragon.happiness * 100).round()}%'),
            const SizedBox(height: AppSpacing.md),
            _meter('Сытость', 1 - dragon.hunger, AppColors.meadow, '${((1 - dragon.hunger) * 100).round()}%'),
          ]),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text('Что сделаем?', style: AppTypography.headline(color: AppColors.cream)),
        const SizedBox(height: AppSpacing.sm),
        Row(children: [
          Expanded(child: QuestButton(label: 'Покормить', icon: Icons.restaurant_rounded, onPressed: () {
            ref.read(gameControllerProvider.notifier).updateDragon(
                  dragon.copyWith(
                    hunger: (dragon.hunger - .2).clamp(0.0, 1.0).toDouble(),
                    happiness:
                        (dragon.happiness + .05).clamp(0.0, 1.0).toDouble(),
                  ),
                );
          })),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: QuestButton(label: 'Нарядить', icon: Icons.auto_awesome_rounded, gradient: AppColors.worldAliveGradient, onPressed: () => context.push(AppRoutes.dragonCustomize))),
        ]),
        const SizedBox(height: AppSpacing.lg),
        QuestCard(child: Text('💡 Чтение даёт ${dragon.name} опыт. Когда шкала заполнится, он перейдёт на новую стадию!', style: AppTypography.body(size: 17), textAlign: TextAlign.center)),
      ]),
    );
  }

  Widget _meter(String title, double value, Color color, String trailing) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Row(children: [Text(title, style: AppTypography.label()), const Spacer(), Text(trailing, style: AppTypography.label(size: 13))]),
    const SizedBox(height: 5),
    LinearProgressIndicator(value: value, minHeight: 14, color: color, borderRadius: AppSpacing.borderSm),
  ]);
  String _stage(DragonStage stage) => switch (stage) { DragonStage.egg => 'Волшебное яйцо', DragonStage.baby => 'Дракончик', DragonStage.teen => 'Юный дракон', DragonStage.adult => 'Храбрый дракон', DragonStage.legendary => 'Легенда мира' };
}
