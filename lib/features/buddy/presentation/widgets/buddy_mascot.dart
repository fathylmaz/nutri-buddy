import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nutri_buddy/features/buddy/domain/usecases/buddy_animation_timing.dart';
import 'package:rive/rive.dart' as rive;

/// Optional real Rive asset with a complete, animated offline fallback.
/// The Rive source must be exported separately from the Rive editor.
class BuddyMascot extends StatefulWidget {
  const BuddyMascot({
    required this.mood,
    required this.celebrationId,
    this.equippedAssetKeys = const {},
    super.key,
  });
  final String mood;
  final int celebrationId;
  final Set<String> equippedAssetKeys;

  @override
  State<BuddyMascot> createState() => _BuddyMascotState();
}

class _BuddyMascotState extends State<BuddyMascot> {
  rive.FileLoader? _loader;
  rive.RiveWidgetController? _controller;
  bool _fileFailed = false;
  Timer? _reactionTimer;

  @override
  void initState() {
    super.initState();
    _prepareRive();
  }

  Future<void> _prepareRive() async {
    // The native engine is initialized only if a usable asset was provided.
    try {
      final asset = await rootBundle.load('assets/rive/nutri_buddy.riv');
      debugPrint(
        '[Buddy/Rive] Asset bundle bulundu: ${asset.lengthInBytes} bytes',
      );
      await rive.RiveNative.init();
      if (!mounted) return;
      setState(() {
        _loader = rive.FileLoader.fromAsset(
          'assets/rive/nutri_buddy.riv',
          riveFactory: rive.Factory.flutter,
        );
      });
    } catch (error, stackTrace) {
      debugPrint(
        '[Buddy/Rive] Dosya acilamadi veya motor baslatilamadi: $error',
      );
      debugPrintStack(stackTrace: stackTrace);
      // Show the Flutter fallback, without hiding the actual error in logs.
    }
  }

  // Treat Happy/Energetic as one-time reactions, not permanent poses.
  // The Dart mood is still derived from today's real meal/water records;
  // only the Rive state-machine inputs return to false after the clip.
  void _setInputs() {
    _reactionTimer?.cancel();
    _reactionTimer = null;

    final sm = _controller?.stateMachine;
    if (sm == null) return;

    final energetic = widget.mood == 'energetic';
    final happy = widget.mood == 'happy' || energetic;
    // Keep legacy inputs until the Rive design migrates to Data Binding.
    // ignore: deprecated_member_use
    sm.boolean('happy')?.value = happy;
    // ignore: deprecated_member_use
    sm.boolean('energetic')?.value = energetic;

    final duration = buddyReactionDuration(widget.mood);
    if (duration == null) return;

    // The One-Shot clips use 100/60 and 64/60 seconds respectively.
    // A small buffer lets the last frame finish before transitioning.
    _reactionTimer = Timer(duration, () {
      _reactionTimer = null;
      if (!mounted) return;
      final current = _controller?.stateMachine;
      if (current == null) return;
      // Existing Happy/Energetic -> Idle transitions require both false.
      // ignore: deprecated_member_use
      current.boolean('energetic')?.value = false;
      // ignore: deprecated_member_use
      current.boolean('happy')?.value = false;
      debugPrint('[Buddy/Rive] One-Shot bitti: Idle durumuna donuluyor.');
    });
  }

  @override
  void didUpdateWidget(covariant BuddyMascot oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.mood != widget.mood) _setInputs();
    if (oldWidget.celebrationId != widget.celebrationId) {
      // Legacy input used only with an optional old-style .riv asset.
      // ignore: deprecated_member_use
      _controller?.stateMachine.trigger('celebrate')?.fire();
    }
  }

  @override
  void dispose() {
    _reactionTimer?.cancel();
    // RiveWidgetBuilder owns and disposes its controller; loader is ours.
    _loader?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 236,
      width: 236,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (_loader != null && !_fileFailed)
            rive.RiveWidgetBuilder(
              fileLoader: _loader!,
              onLoaded: (state) {
                debugPrint(
                  '[Buddy/Rive] RiveLoaded: Gercek .riv dosyasi yuklendi.',
                );
                _controller = state.controller;
                _setInputs();
              },
              onFailed: (error, stackTrace) {
                debugPrint('[Buddy/Rive] RiveFailed: $error');
                debugPrintStack(stackTrace: stackTrace);
                if (mounted) setState(() => _fileFailed = true);
              },
              builder: (context, state) {
                if (state is rive.RiveLoaded) {
                  return rive.RiveWidget(controller: state.controller);
                }
                return _paintedBuddy();
              },
            )
          else
            _paintedBuddy(),
          if (widget.equippedAssetKeys.contains('hat_leaf'))
            const Positioned(
              top: 0,
              child: Icon(Icons.spa, size: 36, color: Color(0xFF277F56)),
            ),
          if (widget.equippedAssetKeys.contains('glasses_sun'))
            const Positioned(
              top: 86,
              child: Icon(Icons.visibility, size: 40, color: Color(0xFF243540)),
            ),
          if (widget.equippedAssetKeys.contains('scarf_green'))
            const Positioned(
              bottom: 22,
              child: Icon(
                Icons.auto_awesome,
                size: 30,
                color: Color(0xFF247D66),
              ),
            ),
        ],
      ),
    );
  }

  Widget _paintedBuddy() => TweenAnimationBuilder<double>(
    key: const Key('buddy-animated-fallback'),
    duration: const Duration(milliseconds: 580),
    curve: Curves.easeOutBack,
    tween: Tween<double>(begin: 0, end: widget.celebrationId.toDouble()),
    builder: (context, phase, child) {
      final bounce = math.sin((phase % 1) * math.pi).abs();
      return Transform.translate(
        offset: Offset(0, -12 * bounce),
        child: Transform.scale(scale: 1 + bounce * 0.10, child: child),
      );
    },
    child: CustomPaint(
      size: const Size(220, 220),
      painter: _BuddyPainter(widget.mood),
    ),
  );
}

class _BuddyPainter extends CustomPainter {
  const _BuddyPainter(this.mood);
  final String mood;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 220, size.height / 220);
    final shadow = Paint()
      ..color = const Color(0xFF123F30).withValues(alpha: .12);
    canvas.drawOval(const Rect.fromLTWH(47, 194, 126, 18), shadow);

    final body = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFB6F4A3), Color(0xFF49BA8B)],
      ).createShader(const Rect.fromLTWH(40, 28, 148, 171));
    canvas.drawOval(const Rect.fromLTWH(41, 28, 138, 169), body);
    final ear = Paint()..color = const Color(0xFF64C795);
    canvas.drawOval(const Rect.fromLTWH(50, 27, 39, 62), ear);
    canvas.drawOval(const Rect.fromLTWH(128, 27, 39, 62), ear);
    canvas.drawOval(const Rect.fromLTWH(41, 83, 36, 58), ear);
    canvas.drawOval(const Rect.fromLTWH(143, 83, 36, 58), ear);
    final blush = Paint()
      ..color = const Color(0xFFFF9EA8).withValues(alpha: .5);
    canvas.drawOval(const Rect.fromLTWH(69, 127, 22, 12), blush);
    canvas.drawOval(const Rect.fromLTWH(129, 127, 22, 12), blush);
    final eye = Paint()..color = const Color(0xFF22483B);
    canvas.drawOval(const Rect.fromLTWH(80, 104, 10, 15), eye);
    canvas.drawOval(const Rect.fromLTWH(130, 104, 10, 15), eye);
    final mouth = Path();
    if (mood == 'neutral') {
      mouth.moveTo(105, 144);
      mouth.lineTo(120, 144);
    } else {
      mouth.moveTo(101, 139);
      mouth.quadraticBezierTo(111, 158, 126, 139);
    }
    canvas.drawPath(
      mouth,
      Paint()
        ..color = const Color(0xFF22483B)
        ..strokeWidth = 3.2
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke,
    );
    if (mood == 'energetic') {
      final shine = Paint()..color = const Color(0xFFFFC857);
      for (final p in [
        const Offset(40, 58),
        const Offset(182, 46),
        const Offset(192, 143),
      ]) {
        canvas.drawCircle(p, 5, shine);
      }
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _BuddyPainter oldDelegate) =>
      oldDelegate.mood != mood;
}
