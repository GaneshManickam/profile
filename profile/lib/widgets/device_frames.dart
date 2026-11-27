import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Modern phone body (9 : 19.5) with titanium rim, black bezel, dynamic
/// island and a soft screen glare.
class PhoneFrame extends StatelessWidget {
  const PhoneFrame({
    super.key,
    required this.width,
    required this.child,
    this.glow,
  });

  final double width;
  final Widget child;
  final Color? glow;

  static double heightFor(double width) => width * 2.08;

  /// A single slice of the phone's side wall, used for 3D extrusion.
  static Widget edge(double width) =>
      _EdgeSlice(width: width, height: heightFor(width), radius: width * 0.17);

  @override
  Widget build(BuildContext context) {
    final h = heightFor(width);
    final outerRadius = width * 0.17;
    final rim = width * 0.018;
    final bezel = width * 0.035;
    final screenRadius = outerRadius - rim - bezel * 0.6;

    return Container(
      width: width,
      height: h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(outerRadius),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF5B6070),
            AppColors.metalDark,
            Color(0xFF444957),
            AppColors.metalDark,
          ],
          stops: [0, 0.35, 0.7, 1],
        ),
        boxShadow: [
          if (glow != null)
            BoxShadow(
              color: glow!.withValues(alpha: 0.35),
              blurRadius: width * 0.5,
              spreadRadius: -width * 0.08,
            ),
        ],
      ),
      padding: EdgeInsets.all(rim),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(outerRadius - rim),
        ),
        padding: EdgeInsets.all(bezel),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(screenRadius),
          child: Stack(
            fit: StackFit.expand,
            children: [
              child,
              // Dynamic island
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: EdgeInsets.only(top: width * 0.03),
                  width: width * 0.3,
                  height: width * 0.085,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(width),
                  ),
                ),
              ),
              // Glass glare
              IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withValues(alpha: 0.10),
                        Colors.white.withValues(alpha: 0.0),
                        Colors.white.withValues(alpha: 0.0),
                        Colors.white.withValues(alpha: 0.04),
                      ],
                      stops: const [0, 0.35, 0.75, 1],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Tablet body (4 : 3 landscape-ish portrait 3 : 4).
class TabletFrame extends StatelessWidget {
  const TabletFrame({super.key, required this.width, required this.child});

  final double width;
  final Widget child;

  static double heightFor(double width) => width * 0.74;

  static Widget edge(double width) =>
      _EdgeSlice(width: width, height: heightFor(width), radius: width * 0.06);

  @override
  Widget build(BuildContext context) {
    final r = width * 0.06;
    return Container(
      width: width,
      height: heightFor(width),
      padding: EdgeInsets.all(width * 0.03),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(r),
        color: Colors.black,
        border: Border.all(color: AppColors.metalLight, width: width * 0.008),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(r * 0.55),
        child: child,
      ),
    );
  }
}

/// Laptop: screen lid plus a keyboard deck drawn in perspective.
class LaptopFrame extends StatelessWidget {
  const LaptopFrame({super.key, required this.width, required this.child});

  final double width;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final screenH = width * 0.62;
    return SizedBox(
      width: width * 1.16,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: width,
            height: screenH,
            padding: EdgeInsets.fromLTRB(
              width * 0.02,
              width * 0.025,
              width * 0.02,
              width * 0.02,
            ),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(width * 0.035),
              ),
              border: Border.all(color: AppColors.metalLight, width: 1.5),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(width * 0.008),
              child: child,
            ),
          ),
          // Keyboard deck — a trapezoid for depth.
          SizedBox(
            width: width * 1.16,
            height: width * 0.05,
            child: CustomPaint(painter: _DeckPainter()),
          ),
        ],
      ),
    );
  }
}

class _DeckPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final inset = size.width * 0.07;
    final path =
        Path()
          ..moveTo(inset, 0)
          ..lineTo(size.width - inset, 0)
          ..lineTo(size.width, size.height * 0.75)
          ..quadraticBezierTo(
            size.width,
            size.height,
            size.width - 8,
            size.height,
          )
          ..lineTo(8, size.height)
          ..quadraticBezierTo(0, size.height, 0, size.height * 0.75)
          ..close();
    canvas.drawPath(
      path,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF5A5F6E), Color(0xFF20232C)],
        ).createShader(Offset.zero & size),
    );
    // Trackpad notch
    final notchW = size.width * 0.16;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(size.width / 2, 2),
          width: notchW,
          height: 4,
        ),
        const Radius.circular(2),
      ),
      Paint()..color = const Color(0xFF2A2D36),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _EdgeSlice extends StatelessWidget {
  const _EdgeSlice({
    required this.width,
    required this.height,
    required this.radius,
  });

  final double width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: const Color(0xFF2A2E39),
        border: Border.all(color: const Color(0xFF4A4F5E), width: 1),
      ),
    );
  }
}
