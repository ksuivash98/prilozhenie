import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:readquest/core/theme/app_colors.dart';
import 'package:readquest/core/theme/app_spacing.dart';
import 'package:readquest/core/theme/app_typography.dart';
import 'package:readquest/core/widgets/living_background.dart';
// AppShadows объявлен в app_spacing.dart

/// Базовая сцена ReadQuest с живым фоном и кнопкой возврата.
class GameScreen extends StatelessWidget {
  const GameScreen({
    required this.title,
    required this.child,
    super.key,
    this.vitality = .8,
    this.actions,
  });

  final String title;
  final Widget child;
  final double vitality;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return LivingBackground(
      vitality: vitality,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.sm,
                AppSpacing.sm,
                AppSpacing.sm,
                0,
              ),
              child: Row(
                children: [
                  IconButton.filledTonal(
                    onPressed: () => context.canPop()
                        ? context.pop()
                        : context.go('/home'),
                    icon: const Icon(Icons.arrow_back_rounded),
                    color: AppColors.ink,
                    tooltip: 'Назад',
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: Text(
                      title,
                      style: AppTypography.headline(
                        size: 25,
                        color: AppColors.cream,
                      ),
                    ),
                  ),
                  ...?actions,
                ],
              ),
            ),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}

/// Тёплая карточка игрового интерфейса.
class QuestCard extends StatelessWidget {
  const QuestCard({required this.child, super.key, this.color});

  final Widget child;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: color ?? AppColors.parchment,
        borderRadius: AppSpacing.borderLg,
        border: Border.all(color: Colors.white.withValues(alpha: .65), width: 2),
        boxShadow: AppShadows.soft(),
      ),
      child: child,
    );
  }
}

/// Полоса игрового показателя с подписью.
class QuestMeter extends StatelessWidget {
  const QuestMeter({
    required this.label,
    required this.value,
    required this.color,
    super.key,
    this.trailing,
  });

  final String label;
  final double value;
  final Color color;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    final safeValue = value.clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label, style: AppTypography.label(size: 14)),
            const Spacer(),
            if (trailing != null) Text(trailing!, style: AppTypography.label(size: 13)),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        ClipRRect(
          borderRadius: AppSpacing.borderSm,
          child: LinearProgressIndicator(
            minHeight: 13,
            value: safeValue,
            backgroundColor: AppColors.inkSoft.withValues(alpha: .15),
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
      ],
    );
  }
}
