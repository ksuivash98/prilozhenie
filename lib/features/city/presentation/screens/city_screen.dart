import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readquest/core/theme/app_colors.dart';
import 'package:readquest/core/theme/app_spacing.dart';
import 'package:readquest/core/theme/app_typography.dart';
import 'package:readquest/core/widgets/game_screen.dart';
import 'package:readquest/features/city/domain/entities/city.dart';
import 'package:readquest/features/home/presentation/providers/game_providers.dart';

/// Город, который строится по мере прочитанных слов.
class CityScreen extends ConsumerWidget {
  const CityScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final city = ref.watch(gameControllerProvider).city;
    final words = ref.watch(gameControllerProvider).progress.wordsReadTotal;
    return GameScreen(title: 'Город историй', child: ListView(padding: AppSpacing.screenPadding, children: [
      QuestCard(color: AppColors.cardWarm, child: Column(children: [
        Text('🏡', style: const TextStyle(fontSize: 70)),
        Text('Красота города ${(city.beautyScore * 100).round()}%', style: AppTypography.headline(size: 22)),
        Text('Прочитано слов: $words', style: AppTypography.body()),
      ])),
      const SizedBox(height: AppSpacing.lg),
      Wrap(spacing: 10, runSpacing: 10, children: city.buildings.map((building) => SizedBox(
        width: 155,
        child: QuestCard(color: building.isUnlocked ? AppColors.cream : AppColors.worldFading, child: Column(children: [
          Text(building.isUnlocked ? _icon(building.type) : '🔒', style: const TextStyle(fontSize: 42)),
          Text(building.name, style: AppTypography.label(), textAlign: TextAlign.center),
          Text(building.isUnlocked ? 'Уровень ${building.level}' : 'Нужно ${building.unlockWordsRequired} слов', style: AppTypography.body(size: 12), textAlign: TextAlign.center),
        ])),
      )).toList()),
    ]));
  }
  String _icon(BuildingType type) => switch (type) { BuildingType.house => '🏠', BuildingType.park => '🌳', BuildingType.library => '📚', BuildingType.tower => '🗼', BuildingType.fountain => '⛲', BuildingType.school => '🏫', BuildingType.port => '⚓', BuildingType.castle => '🏰' };
}
