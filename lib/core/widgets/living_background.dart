import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:readquest/core/theme/app_colors.dart';

/// Живой фон с облаками, частицами и градиентом неба.
class LivingBackground extends StatefulWidget {
  const LivingBackground({
    required this.child,
    super.key,
    this.vitality = 0.7,
    this.gradient = AppColors.heroSky,
  });

  final Widget child;
  final double vitality;
  final Gradient gradient;

  @override
  State<LivingBackground> createState() => _LivingBackgroundState();
}

class _LivingBackgroundState extends State<LivingBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 18),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gray = 1 - widget.vitality.clamp(0.0, 1.0);
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(gradient: widget.gradient),
          child: ColorFiltered(
            colorFilter: ColorFilter.matrix(_grayMatrix(gray * 0.85)),
            child: Stack(
              fit: StackFit.expand,
              children: [
                CustomPaint(
                  painter: _CloudPainter(progress: _controller.value),
                ),
                CustomPaint(
                  painter: _ParticlePainter(
                    progress: _controller.value,
                    vitality: widget.vitality,
                  ),
                ),
                child!,
              ],
            ),
          ),
        );
      },
      child: widget.child,
    );
  }

  List<double> _grayMatrix(double amount) {
    final inv = 1 - amount;
    const r = 0.2126;
    const g = 0.7152;
    const b = 0.0722;
    return [
      inv + amount * r, amount * g, amount * b, 0, 0,
      amount * r, inv + amount * g, amount * b, 0, 0,
      amount * r, amount * g, inv + amount * b, 0, 0,
      0, 0, 0, 1, 0,
    ];
  }
}

class _CloudPainter extends CustomPainter {
  _CloudPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withValues(alpha: 0.35);
    for (var i = 0; i < 5; i++) {
      final x = ((progress + i * 0.2) % 1) * (size.width + 120) - 60;
      final y = 40.0 + i * 36;
      canvas.drawOval(
        Rect.fromCenter(center: Offset(x, y), width: 110 + i * 12, height: 36),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _CloudPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class _ParticlePainter extends CustomPainter {
  _ParticlePainter({required this.progress, required this.vitality});

  final double progress;
  final double vitality;

  @override
  void paint(Canvas canvas, Size size) {
    if (vitality < 0.25) return;
    final paint = Paint()..color = AppColors.lumiGlow.withValues(alpha: 0.55);
    final count = (8 + vitality * 16).round();
    final rnd = math.Random(42);
    for (var i = 0; i < count; i++) {
      final px = rnd.nextDouble() * size.width;
      final baseY = rnd.nextDouble() * size.height;
      final y = (baseY + math.sin((progress + i) * math.pi * 2) * 12) %
          size.height;
      canvas.drawCircle(Offset(px, y), 2 + rnd.nextDouble() * 2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.vitality != vitality;
}
