import 'package:flutter/material.dart';

import '../data/models.dart';
import '../theme/app_theme.dart';

/// Monochrome Flutter mark (kept from the previous version of the site).
class FlutterMonochromeIcon extends StatelessWidget {
  const FlutterMonochromeIcon({
    super.key,
    this.size = 13,
    this.color = AppColors.textTertiary,
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _FlutterIconPainter(color)),
    );
  }
}

class _FlutterIconPainter extends CustomPainter {
  const _FlutterIconPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    canvas.save();
    canvas.scale(size.width / 24.0, size.height / 24.0);
    final p1 =
        Path()
          ..moveTo(14.314, 0)
          ..lineTo(2.3, 12)
          ..lineTo(6.0, 15.7)
          ..lineTo(21.684, 0.013)
          ..lineTo(14.327, 0.013)
          ..close();
    final p2 =
        Path()
          ..moveTo(14.328, 11.072)
          ..lineTo(7.857, 17.53)
          ..lineTo(14.327, 24.0)
          ..lineTo(21.7, 24.0)
          ..lineTo(15.24, 17.532)
          ..lineTo(21.7, 11.072)
          ..lineTo(14.33, 11.072)
          ..close();
    canvas.drawPath(p1, paint);
    canvas.drawPath(p2, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _FlutterIconPainter old) => old.color != color;
}

/// Stylised Swift bird.
class SwiftGlyph extends StatelessWidget {
  const SwiftGlyph({super.key, this.size = 24, this.color = Colors.white});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: size,
    height: size,
    child: CustomPaint(painter: _SwiftPainter(color)),
  );
}

class _SwiftPainter extends CustomPainter {
  const _SwiftPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 24, size.height / 24);
    final path =
        Path()
          ..moveTo(15.6, 2.6)
          ..cubicTo(20.6, 6.2, 22.0, 11.6, 19.6, 15.6)
          ..cubicTo(20.8, 17.0, 21.2, 18.6, 20.8, 19.8)
          ..cubicTo(19.6, 18.4, 17.9, 18.1, 16.6, 18.7)
          ..cubicTo(12.4, 21.0, 6.4, 19.6, 2.6, 15.0)
          ..cubicTo(6.6, 17.6, 11.0, 17.6, 14.2, 15.6)
          ..cubicTo(10.4, 12.8, 7.0, 9.0, 4.6, 5.6)
          ..cubicTo(8.0, 8.8, 11.6, 11.4, 13.4, 12.5)
          ..cubicTo(10.8, 9.8, 8.6, 7.0, 7.4, 4.8)
          ..cubicTo(11.0, 8.4, 14.6, 11.2, 16.8, 12.6)
          ..cubicTo(18.2, 9.2, 17.6, 5.6, 15.6, 2.6)
          ..close();
    canvas.drawPath(path, Paint()..color = color);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _SwiftPainter old) => old.color != color;
}

/// Simplified Stack Overflow mark: a tray with stacked bars.
class _StackOverflowPainter extends CustomPainter {
  const _StackOverflowPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 24, size.height / 24);
    final stroke =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.2
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(
      Path()
        ..moveTo(4, 14)
        ..lineTo(4, 21)
        ..lineTo(19, 21)
        ..lineTo(19, 14),
      stroke,
    );
    final bar = Paint()..color = color;
    void drawBar(double angle, double dy) {
      canvas.save();
      canvas.translate(11.5, 18 - dy);
      canvas.rotate(angle);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          const Rect.fromLTWH(-4.5, -1, 9, 2),
          const Radius.circular(1),
        ),
        bar,
      );
      canvas.restore();
    }

    drawBar(0, 0);
    drawBar(-0.2, 3.2);
    drawBar(-0.45, 6.4);
    drawBar(-0.8, 9.4);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _StackOverflowPainter old) => old.color != color;
}

/// Brand glyph for a social link, drawn without an icon font dependency.
class SocialGlyph extends StatelessWidget {
  const SocialGlyph(this.kind, {super.key, this.size = 18, this.color});

  final SocialKind kind;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = color ?? IconTheme.of(context).color ?? AppColors.textSecondary;
    return switch (kind) {
      SocialKind.github => Icon(Icons.code_rounded, size: size, color: c),
      SocialKind.linkedin => SizedBox(
        width: size,
        height: size,
        child: Center(
          child: Text(
            'in',
            style: AppText.title(
              size * 0.82,
              color: c,
              weight: FontWeight.w800,
            ).copyWith(height: 1, letterSpacing: -0.5),
          ),
        ),
      ),
      SocialKind.stackOverflow => SizedBox(
        width: size,
        height: size,
        child: CustomPaint(painter: _StackOverflowPainter(c)),
      ),
      SocialKind.email => Icon(
        Icons.mail_outline_rounded,
        size: size,
        color: c,
      ),
      SocialKind.other => Icon(Icons.link_rounded, size: size, color: c),
    };
  }
}

/// Platform badge icon (iOS / Android / Flutter).
Widget platformIcon(String platform, {double size = 13, Color? color}) {
  final c = color ?? AppColors.textSecondary;
  return switch (platform.toLowerCase()) {
    'flutter' => FlutterMonochromeIcon(size: size, color: c),
    'android' => Icon(Icons.android, size: size, color: c),
    _ => Icon(Icons.apple, size: size, color: c),
  };
}

/// Glossy floating badge with a logo, used around the 3D devices.
class LogoBadge extends StatelessWidget {
  const LogoBadge({
    super.key,
    required this.child,
    required this.gradient,
    this.size = 64,
    this.glow,
    this.label,
  });

  final Widget child;
  final List<Color> gradient;
  final double size;
  final Color? glow;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final badge = Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.26),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradient,
        ),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
        boxShadow: [
          BoxShadow(
            color: (glow ?? gradient.last).withValues(alpha: 0.4),
            blurRadius: size * 0.25,
            spreadRadius: -size * 0.08,
            offset: Offset(0, size * 0.12),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Specular highlight on the top edge.
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: size * 0.5,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(size * 0.26),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withValues(alpha: 0.22),
                    Colors.white.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
          ),
          child,
        ],
      ),
    );
    if (label == null) return badge;
    return Semantics(label: label, child: badge);
  }
}
