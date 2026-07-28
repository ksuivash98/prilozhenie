import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:readquest/core/constants/app_routes.dart';
import 'package:readquest/core/theme/app_colors.dart';
import 'package:readquest/core/theme/app_spacing.dart';
import 'package:readquest/core/theme/app_typography.dart';
import 'package:readquest/core/widgets/game_screen.dart';
import 'package:readquest/core/widgets/quest_button.dart';
import 'package:readquest/features/home/presentation/providers/game_providers.dart';
import 'package:readquest/features/settings/presentation/providers/settings_providers.dart';

/// Знакомит ребёнка с Луми, яйцом и его первым приключением.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _nameController = TextEditingController();
  int _step = 0;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    final name = _nameController.text.trim().isEmpty ? 'Друг' : _nameController.text.trim();
    await ref.read(gameControllerProvider.notifier).setPlayerName(name);
    await ref.read(appSettingsProvider.notifier).setPlayerName(name);
    await ref.read(appSettingsProvider.notifier).completeOnboarding();
    if (mounted) context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      ('Привет, я Луми!', '✨', 'Я буду рядом, пока ты оживляешь мир словами.'),
      ('Это драконье яйцо', '🥚', 'Ему нужны добрые истории и твой голос, чтобы вылупиться.'),
      ('Как тебя зовут?', '🧒', 'Напиши имя — так Луми будет обращаться к тебе.'),
    ];
    final page = pages[_step];
    return GameScreen(
      title: 'Начало приключения',
      child: Center(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: QuestCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(page.$2, style: const TextStyle(fontSize: 94)),
                Text(page.$1, style: AppTypography.display(size: 32), textAlign: TextAlign.center),
                const SizedBox(height: AppSpacing.sm),
                Text(page.$3, style: AppTypography.body(size: 18), textAlign: TextAlign.center),
                if (_step == 2) ...[
                  const SizedBox(height: AppSpacing.lg),
                  TextField(
                    controller: _nameController,
                    autofocus: true,
                    textCapitalization: TextCapitalization.words,
                    style: AppTypography.headline(size: 22),
                    decoration: InputDecoration(
                      hintText: 'Твоё имя',
                      prefixIcon: const Icon(Icons.star_rounded, color: AppColors.magicAmber),
                      filled: true,
                      fillColor: AppColors.cream,
                      border: OutlineInputBorder(borderRadius: AppSpacing.borderMd),
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.lg),
                QuestButton(
                  label: _step == 2 ? 'Начать путешествие!' : 'Дальше',
                  icon: _step == 2 ? Icons.rocket_launch_rounded : Icons.arrow_forward_rounded,
                  onPressed: _step == 2 ? _finish : () => setState(() => _step++),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
