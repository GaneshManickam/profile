import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../core/motion.dart';
import '../theme/app_theme.dart';

/// Fixed backdrop: drifting aurora light, a faint dot grid and slow
/// particles. Painted on a single canvas with one controller, isolated in a
/// [RepaintBoundary] so it never forces the content to repaint.
class AmbientBackground extends StatefulWidget {
  const AmbientBackground({super.key, required this.scroll});

  final ScrollController scroll;

  @override
  State<AmbientBackground> createState() => _AmbientBackgroundState();
}

class _AmbientBackgroundState extends State<AmbientBackground>
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
    final count = mobile ? 22 : 48;
    if (_particles.length != count) {
      final rnd = math.Random(42);
      _particles = List.generate(
        count,
        (_) => _Particle(
          x: rnd.nextDouble(),
          y: rnd.nextDouble(),
          radius: 0.6 + rnd.nextDouble() * 1.4,
          speed: 0.2 + rnd.nextDouble() * 0.8,
          phase: rnd.nextDouble() * math.pi * 2,
          tint: rnd.nextDouble() < 0.5 ? AppColors.cyan : AppColors.violet,
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
    return RepaintBoundary(
      child: CustomPaint(
        painter: _AmbientPainter(
          time: _controller,
          scroll: widget.scroll,
          particles: _particles,
        ),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _Particle {
  const _Particle({
    required this.x,
    required this.y,
    required this.radius,
    required this.speed,
    required this.phase,
    required this.tint,
  });

  final double x;
  final double y;
  final double radius;
  final double speed;
  final double phase;
  final Color tint;
}

class _AmbientPainter extends CustomPainter {
  _AmbientPainter({
    required this.time,
    required this.scroll,
    required this.particles,
  }) : super(repaint: Listenable.merge([time, scroll]));

  final Animation<double> time;
  final ScrollController scroll;
  final List<_Particle> particles;

  double get _scrollOffset =>
      scroll.hasClients && scroll.positions.length == 1 ? scroll.offset : 0;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = AppColors.background);

    final t = time.value * 2 * math.pi;
    final s = _scrollOffset;

    void orb(Offset c, double r, Color color, double alpha) {
      canvas.drawCircle(
        c,
        r,
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
    orb(
      Offset(
        w * 0.78 + math.sin(t) * 60,
        h * 0.18 + math.cos(t) * 40 - s * 0.08 % h,
      ),
      math.max(w, h) * 0.45,
      AppColors.cyan,
      0.09,
    );
    orb(
      Offset(w * 0.12 + math.cos(t * 2) * 50, h * 0.7 + math.sin(t) * 50),
      math.max(w, h) * 0.5,
      AppColors.violet,
      0.10,
    );

    // Dot grid, parallaxing slightly with scroll.
    const spacing = 44.0;
    final grid = Paint()..color = Colors.white.withValues(alpha: 0.035);
    final dy = -(s * 0.15) % spacing;
    for (double x = spacing / 2; x < w; x += spacing) {
      for (double y = dy; y < h; y += spacing) {
        canvas.drawCircle(Offset(x, y), 0.8, grid);
      }
    }

    // Particles drifting upward with a gentle twinkle.
    for (final p in particles) {
      final travel = (p.y - time.value * p.speed - s * 0.0002 * p.speed) % 1.0;
      final x = p.x * w + math.sin(t * 3 + p.phase) * 12;
      final y = travel * h;
      final alpha = 0.25 + 0.35 * (0.5 + 0.5 * math.sin(t * 6 + p.phase));
      canvas.drawCircle(
        Offset(x, y),
        p.radius,
        Paint()..color = p.tint.withValues(alpha: alpha),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _AmbientPainter old) =>
      old.particles != particles;
}
