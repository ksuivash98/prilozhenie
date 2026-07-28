import 'package:flutter/material.dart';
import 'package:readquest/core/theme/app_colors.dart';
import 'package:readquest/core/theme/app_spacing.dart';
import 'package:readquest/core/theme/app_typography.dart';

/// Главная игровая кнопка CTA.
class QuestButton extends StatefulWidget {
  const QuestButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.icon,
    this.gradient = AppColors.ctaGradient,
    this.enabled = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Gradient gradient;
  final bool enabled;

  @override
  State<QuestButton> createState() => _QuestButtonState();
}

class _QuestButtonState extends State<QuestButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 120),
    lowerBound: 0.96,
    upperBound: 1,
    value: 1,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.enabled && widget.onPressed != null;
    return ScaleTransition(
      scale: _controller,
      child: GestureDetector(
        onTapDown: enabled ? (_) => _controller.reverse() : null,
        onTapUp: enabled
            ? (_) {
                _controller.forward();
                widget.onPressed?.call();
              }
            : null,
        onTapCancel: enabled ? () => _controller.forward() : null,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: enabled ? 1 : 0.5,
          child: Container(
            constraints: const BoxConstraints(minHeight: 56),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            decoration: BoxDecoration(
              gradient: widget.gradient,
              borderRadius: AppSpacing.borderLg,
              boxShadow: [
                BoxShadow(
                  color: AppColors.dragonCoral.withValues(alpha: 0.35),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.icon != null) ...[
                  Icon(widget.icon, color: Colors.white, size: 24),
                  const SizedBox(width: AppSpacing.sm),
                ],
                Flexible(
                  child: Text(
                    widget.label,
                    textAlign: TextAlign.center,
                    style: AppTypography.label(color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
