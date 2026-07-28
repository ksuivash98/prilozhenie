import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:readquest/core/constants/app_routes.dart';
import 'package:readquest/core/theme/app_colors.dart';
import 'package:readquest/core/theme/app_spacing.dart';
import 'package:readquest/core/theme/app_typography.dart';
import 'package:readquest/core/widgets/game_screen.dart';
import 'package:readquest/core/widgets/living_background.dart';
import 'package:readquest/core/widgets/lumi_bubble.dart';
import 'package:readquest/core/widgets/quest_button.dart';
import 'package:readquest/features/dragon/domain/entities/dragon.dart';
import 'package:readquest/features/home/presentation/providers/game_providers.dart';
import 'package:readquest/features/lumi/domain/entities/lumi_message.dart';

/// Главный живой хаб с доступом ко всем приключениям ReadQuest.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final game = ref.watch(gameControllerProvider);
    final shortcuts = <(IconData, String, String, Color)>[
      (Icons.explore_rounded, 'Приключение', AppRoutes.adventure, AppColors.dragonTeal),
      (Icons.pets_rounded, 'Дракон', AppRoutes.dragon, AppColors.dragonCoral),
      (Icons.location_city_rounded, 'Город', AppRoutes.city, AppColors.magicAmber),
      (Icons.sports_esports_rounded, 'Игры', AppRoutes.miniGames, AppColors.berryPink),
      (Icons.menu_book_rounded, 'Книги', AppRoutes.books, AppColors.caveShadow),
      (Icons.assignment_rounded, 'Квесты', AppRoutes.quests, AppColors.meadowDeep),
      (Icons.emoji_events_rounded, 'Награды', AppRoutes.achievements, AppColors.magicAmber),
      (Icons.settings_rounded, 'Настройки', AppRoutes.settings, AppColors.inkSoft),
      (Icons.family_restroom_rounded, 'Родителям', AppRoutes.parentsPin, AppColors.skyMid),
    ];
    return LivingBackground(
      vitality: game.world.vitalityScore,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(child: Text('ReadQuest', style: AppTypography.display(size: 36, color: AppColors.cream))),
                  IconButton.filled(
                    onPressed: () => context.push(AppRoutes.statistics),
                    icon: const Icon(Icons.bar_chart_rounded),
                    tooltip: 'Статистика',
                  ),
                ],
              ),
              Text('Привет, ${game.progress.displayName.isEmpty ? 'исследователь' : game.progress.displayName}!', style: AppTypography.headline(color: AppColors.lumiGlow)),
              const SizedBox(height: AppSpacing.md),
              QuestCard(
                color: AppColors.cream.withValues(alpha: .92),
                child: Column(
                  children: [
                    QuestMeter(label: 'Жизнь мира', value: game.world.vitalityScore, color: AppColors.success, trailing: '${(game.world.vitalityScore * 100).round()}%'),
                    const SizedBox(height: AppSpacing.sm),
                    Text('🌱 Каждое прочитанное слово возвращает краски!', style: AppTypography.body(size: 14)),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              LumiBubble(message: LumiCatalog.pick(LumiTone.guide)),
              const SizedBox(height: AppSpacing.md),
              QuestCard(
                color: AppColors.cardWarm,
                child: Row(
                  children: [
                    Text(game.dragon.stage == DragonStage.egg ? '🥚' : '🐉', style: const TextStyle(fontSize: 58)),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('${game.dragon.name} · ${_stageName(game.dragon.stage)}', style: AppTypography.headline(size: 19)),
                        QuestMeter(label: 'Рост', value: game.dragon.stageProgress, color: AppColors.dragonCoral, trailing: '${game.dragon.xp}/${game.dragon.xpToNextStage} XP'),
                      ]),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              QuestButton(label: 'Продолжить приключение', icon: Icons.auto_awesome_rounded, onPressed: () => context.go(AppRoutes.adventure)),
              const SizedBox(height: AppSpacing.lg),
              Text('Куда отправимся?', style: AppTypography.headline(color: AppColors.cream)),
              const SizedBox(height: AppSpacing.sm),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: shortcuts.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: .92),
                itemBuilder: (context, index) {
                  final item = shortcuts[index];
                  return InkWell(
                    onTap: () => context.push(item.$3),
                    borderRadius: AppSpacing.borderMd,
                    child: Ink(
                      decoration: BoxDecoration(color: AppColors.cream.withValues(alpha: .95), borderRadius: AppSpacing.borderMd, boxShadow: AppShadows.soft()),
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Icon(item.$1, color: item.$4, size: 31),
                        const SizedBox(height: 5),
                        Text(item.$2, style: AppTypography.label(size: 12), textAlign: TextAlign.center),
                      ]),
                    ),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              Text('📖 Слов прочитано: ${game.progress.wordsReadTotal} · 🪙 ${game.inventory.coins}', style: AppTypography.label(color: AppColors.cream), textAlign: TextAlign.center),
            ],
          ),
        ),
        ),
      ),
    );
  }

  String _stageName(DragonStage stage) => switch (stage) {
        DragonStage.egg => 'яйцо',
        DragonStage.baby => 'малыш',
        DragonStage.teen => 'подросток',
        DragonStage.adult => 'взрослый',
        DragonStage.legendary => 'легенда',
      };
}
