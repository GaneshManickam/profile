import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../core/motion.dart';
import '../theme/app_theme.dart';

/// Fixed backdrop: soft aurora light, a faint dot grid and slow particles.
///
/// Performance notes: the aurora + grid are static and painted once into
/// their own layer (they never repaint while scrolling). Only the small
/// particle layer animates, drawn with a single `drawPoints` call per colour.
class AmbientBackground extends StatelessWidget {
  const AmbientBackground({super.key, required this.scroll});

  /// Kept for API compatibility; the backdrop no longer reacts to scroll so
  /// it never has to repaint while the page moves.
  final ScrollController scroll;

  @override
  Widget build(BuildContext context) {
    return const Stack(
      fit: StackFit.expand,
      children: [
        RepaintBoundary(child: CustomPaint(painter: _StaticBackdropPainter())),
        RepaintBoundary(child: _Particles()),
      ],
    );
  }
}

class _StaticBackdropPainter extends CustomPainter {
  const _StaticBackdropPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = AppColors.background);

    void orb(Offset c, double r, Color color, double alpha) {
      canvas.drawRect(
        Offset.zero & size,
        Paint()
          ..shader = RadialGradient(
            colors: [
              color.withValues(alpha: alpha),
              color.withValues(alpha: 0),
            ],
          ).createShader(Rect.fromCircle(center: c, radius: r)),
      );
    }

    final w = size.width;
    final h = size.height;
    final r = math.max(w, h);
    orb(Offset(w * 0.8, h * 0.15), r * 0.45, AppColors.cyan, 0.08);
    orb(Offset(w * 0.1, h * 0.75), r * 0.5, AppColors.violet, 0.09);

    // Dot grid in a single draw call.
    const spacing = 44.0;
    final points = <Offset>[
      for (double x = spacing / 2; x < w; x += spacing)
        for (double y = spacing / 2; y < h; y += spacing) Offset(x, y),
    ];
    canvas.drawPoints(
      ui.PointMode.points,
      points,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.035)
        ..strokeWidth = 1.6
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _Particles extends StatefulWidget {
  const _Particles();

  @override
  State<_Particles> createState() => _ParticlesState();
}

class _ParticlesState extends State<_Particles>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 60),
  );
  List<_Particle> _particles = const [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final mobile = Breakpoints.of(context) == ScreenSize.mobile;
    final count = mobile ? 16 : 36;
    if (_particles.length != count) {
      final rnd = math.Random(42);
      _particles = List.generate(
        count,
        (_) => _Particle(
          x: rnd.nextDouble(),
          y: rnd.nextDouble(),
          speed: 0.2 + rnd.nextDouble() * 0.8,
          phase: rnd.nextDouble() * math.pi * 2,
          cyan: rnd.nextBool(),
        ),
      );
    }
    if (Motion.reduced(context)) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ParticlePainter(time: _controller, particles: _particles),
      child: const SizedBox.expand(),
    );
  }
}

class _Particle {
  const _Particle({
    required this.x,
    required this.y,
    required this.speed,
    required this.phase,
    required this.cyan,
  });

  final double x;
  final double y;
  final double speed;
  final double phase;
  final bool cyan;
}

class _ParticlePainter extends CustomPainter {
  _ParticlePainter({required this.time, required this.particles})
    : super(repaint: time);

  final Animation<double> time;
  final List<_Particle> particles;

  @override
  void paint(Canvas canvas, Size size) {
    final t = time.value * 2 * math.pi;
    final cyan = <Offset>[];
    final violet = <Offset>[];
    for (final p in particles) {
      final travel = (p.y - time.value * p.speed) % 1.0;
      final o = Offset(
        p.x * size.width + math.sin(t * 3 + p.phase) * 12,
        travel * size.height,
      );
      (p.cyan ? cyan : violet).add(o);
    }
    Paint dot(Color c) =>
        Paint()
          ..color = c.withValues(alpha: 0.45)
          ..strokeWidth = 2.4
          ..strokeCap = StrokeCap.round;
    canvas.drawPoints(ui.PointMode.points, cyan, dot(AppColors.cyan));
    canvas.drawPoints(ui.PointMode.points, violet, dot(AppColors.violet));
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter old) =>
      old.particles != particles;
}
