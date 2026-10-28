import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Pure Flutter painter; independent of Rive assets and refresh rate.
/// Shows over-target values in text while capping only the painted arc.
class ProgressRing extends StatelessWidget {
  const ProgressRing({
    required this.consumed,
    required this.target,
    required this.centerText,
    required this.caption,
    super.key,
  });

  final int consumed;
  final int target;
  final String centerText;
  final String caption;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ratio = target == 0 ? 0.0 : consumed / target;
    final reducedMotion = MediaQuery.disableAnimationsOf(context);
    return Semantics(
      label: 'Kalori: $consumed / $target kilokalori',
      child: SizedBox(
        width: 214,
        height: 214,
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(end: ratio.clamp(0.0, 1.0).toDouble()),
          duration: reducedMotion
              ? Duration.zero
              : const Duration(milliseconds: 850),
          curve: Curves.easeOutCubic,
          builder: (context, progress, child) => CustomPaint(
            painter: _RingPainter(
              value: progress,
              background: scheme.primary.withValues(alpha: 0.12),
              start: scheme.primary,
              end: scheme.tertiary,
            ),
            child: child,
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  centerText,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -1.4,
                  ),
                ),
                const SizedBox(height: 3),
                Text(caption, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  const _RingPainter({
    required this.value,
    required this.background,
    required this.start,
    required this.end,
  });

  final double value;
  final Color background;
  final Color start;
  final Color end;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 13;
    final rect = Rect.fromCircle(center: center, radius: radius);
    final base = Paint()
      ..color = background
      ..strokeWidth = 13
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, radius, base);
    if (value <= 0) {
      return;
    }
    final foreground = Paint()
      ..shader = SweepGradient(
        startAngle: -math.pi / 2,
        endAngle: 3 * math.pi / 2,
        colors: [start, end, start],
      ).createShader(rect)
      ..strokeWidth = 13
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawArc(rect, -math.pi / 2, 2 * math.pi * value, false, foreground);
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) =>
      oldDelegate.value != value ||
      oldDelegate.background != background ||
      oldDelegate.start != start ||
      oldDelegate.end != end;
}
