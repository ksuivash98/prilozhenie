import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:readquest/core/constants/app_routes.dart';
import 'package:readquest/core/theme/app_colors.dart';
import 'package:readquest/core/theme/app_spacing.dart';
import 'package:readquest/core/theme/app_typography.dart';
import 'package:readquest/core/widgets/game_screen.dart';
import 'package:readquest/features/home/presentation/providers/game_providers.dart';
import 'package:readquest/features/mini_games/domain/entities/mini_game.dart';

/// Аркада из двадцати игр, открываемых прочитанными словами.
class MiniGamesHubScreen extends ConsumerWidget {
  const MiniGamesHubScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final words = ref.watch(gameControllerProvider).progress.wordsReadTotal;
    return GameScreen(title: 'Поляна игр', child: GridView.builder(
      padding: AppSpacing.screenPadding,
      itemCount: MiniGameCatalog.all.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: .86),
      itemBuilder: (context, index) {
        final game = MiniGameCatalog.all[index];
        final unlocked = words >= game.unlockWords;
        return InkWell(
          onTap: unlocked ? () => context.push(AppRoutes.miniGamePath(game.id)) : null,
          borderRadius: AppSpacing.borderMd,
          child: Ink(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(color: unlocked ? AppColors.cream : AppColors.worldGray, borderRadius: AppSpacing.borderMd, boxShadow: AppShadows.soft()),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(unlocked ? _icon(index) : '🔒', style: const TextStyle(fontSize: 40)),
              const SizedBox(height: 5),
              Text(game.title, style: AppTypography.label(size: 14, color: unlocked ? AppColors.ink : Colors.white), textAlign: TextAlign.center),
              const SizedBox(height: 3),
              Text(unlocked ? game.description : 'Нужно ${game.unlockWords} слов', style: AppTypography.body(size: 11, color: unlocked ? AppColors.inkSoft : Colors.white), textAlign: TextAlign.center, maxLines: 2),
            ]),
          ),
        );
      },
    ));
  }
  String _icon(int index) => const ['🍎','🔤','🧲','👾','🧰','🔎','🎣','🌱','🌲','🪽','🧩','🔍','🔮','🗼','⚒️','🌀','🌷','⛵','🐿️','📚'][index];
}
