import 'package:flutter/material.dart';
import 'package:readquest/core/theme/app_colors.dart';
import 'package:readquest/core/theme/app_spacing.dart';
import 'package:readquest/core/theme/app_typography.dart';
import 'package:readquest/features/lumi/domain/entities/lumi_message.dart';

/// Виджет ИИ-помощника Луми.
class LumiBubble extends StatefulWidget {
  const LumiBubble({
    required this.message,
    super.key,
    this.onSpeak,
  });

  final LumiMessage message;
  final VoidCallback? onSpeak;

  @override
  State<LumiBubble> createState() => _LumiBubbleState();
}

class _LumiBubbleState extends State<LumiBubble>
    with SingleTickerProviderStateMixin {
  late final AnimationController _bob = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _bob.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _bob,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, (_bob.value - 0.5) * 8),
          child: child,
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const RadialGradient(
                colors: [AppColors.lumiGlow, AppColors.magicGold],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.magicGold.withValues(alpha: 0.5),
                  blurRadius: 16,
                ),
              ],
            ),
            child: const Center(
              child: Text('✦', style: TextStyle(fontSize: 28)),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: GestureDetector(
              onTap: widget.onSpeak,
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.parchment,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                    bottomLeft: Radius.circular(6),
                  ),
                  border: Border.all(
                    color: AppColors.magicAmber.withValues(alpha: 0.5),
                    width: 2,
                  ),
                ),
                child: Text(
                  widget.message.text,
                  style: AppTypography.body(size: 15, color: AppColors.ink),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
