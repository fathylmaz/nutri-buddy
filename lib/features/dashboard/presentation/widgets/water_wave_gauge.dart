import 'dart:math' as math;

import 'package:flutter/material.dart';

class WaterWaveGauge extends StatefulWidget {
  const WaterWaveGauge({required this.fraction, super.key});

  final double fraction;

  @override
  State<WaterWaveGauge> createState() => _WaterWaveGaugeState();
}

class _WaterWaveGaugeState extends State<WaterWaveGauge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _wave = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2400),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _wave.stop();
    } else if (!_wave.isAnimating) {
      _wave.repeat();
    }
  }

  @override
  void dispose() {
    _wave.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final disabled = MediaQuery.disableAnimationsOf(context);
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      label: 'Su hedefinin yüzde ${(widget.fraction * 100).round()} kadarı',
      child: SizedBox(
        height: 158,
        width: 112,
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(end: widget.fraction.clamp(0.0, 1.0).toDouble()),
          duration: disabled
              ? Duration.zero
              : const Duration(milliseconds: 650),
          curve: Curves.easeOut,
          builder: (context, value, child) => CustomPaint(
            painter: _WavePainter(
              fraction: value,
              wave: _wave,
              outline: scheme.outlineVariant,
              water: const Color(0xFF30A5D9),
            ),
          ),
        ),
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  _WavePainter({
    required this.fraction,
    required this.wave,
    required this.outline,
    required this.water,
  }) : super(repaint: wave);

  final double fraction;
  final Animation<double> wave;
  final Color outline;
  final Color water;

  @override
  void paint(Canvas canvas, Size size) {
    final bottle = RRect.fromRectAndRadius(
      Rect.fromLTWH(9, 5, size.width - 18, size.height - 10),
      const Radius.circular(25),
    );
    canvas.drawRRect(
      bottle,
      Paint()
        ..color = outline
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke,
    );
    canvas.save();
    canvas.clipRRect(bottle);
    final height = (size.height - 10) * fraction;
    if (height > 0) {
      final top = size.height - 5 - height;
      final path = Path()..moveTo(9, top);
      for (var x = 9.0; x <= size.width - 9; x += 2.0) {
        final y =
            top +
            math.sin(
                  (x / size.width * 2 * math.pi) + wave.value * 2 * math.pi,
                ) *
                3.5;
        path.lineTo(x, y);
      }
      path
        ..lineTo(size.width - 9, size.height)
        ..lineTo(9, size.height)
        ..close();
      canvas.drawPath(path, Paint()..color = water.withValues(alpha: 0.86));
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _WavePainter oldDelegate) =>
      oldDelegate.fraction != fraction ||
      oldDelegate.water != water ||
      oldDelegate.outline != outline;
}
