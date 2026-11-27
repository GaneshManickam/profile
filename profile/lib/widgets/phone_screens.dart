import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../data/models.dart';
import '../data/portfolio_data.dart';
import '../theme/app_theme.dart';
import 'tech_logos.dart';

/// All phone screens are laid out on a fixed design canvas and scaled to
/// whatever device size they are shown in, so they stay crisp and identical
/// across breakpoints.
class _ScreenCanvas extends StatelessWidget {
  const _ScreenCanvas({required this.child, required this.background});

  static const size = Size(280, 618);

  final Widget child;
  final Decoration background;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.cover,
      child: SizedBox.fromSize(
        size: size,
        child: DecoratedBox(
          decoration: background,
          child: DefaultTextStyle(
            style: AppText.body(12, color: Colors.white),
            child: child,
          ),
        ),
      ),
    );
  }
}

class _StatusBar extends StatelessWidget {
  const _StatusBar();

  static const color = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(26, 14, 22, 0),
      child: Row(
        children: [
          Text(
            '9:41',
            style: AppText.body(12.5, color: color, weight: FontWeight.w600),
          ),
          const Spacer(),
          Icon(Icons.signal_cellular_alt_rounded, size: 13, color: color),
          const SizedBox(width: 4),
          Icon(Icons.wifi_rounded, size: 13, color: color),
          const SizedBox(width: 4),
          Icon(Icons.battery_full_rounded, size: 14, color: color),
        ],
      ),
    );
  }
}

/// Home screen whose icons are the real apps from the portfolio.
class HomeScreenUI extends StatelessWidget {
  const HomeScreenUI({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = PortfolioData.profile;
    return _ScreenCanvas(
      background: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0E1B3A), Color(0xFF1B1140), Color(0xFF07070D)],
        ),
      ),
      child: Stack(
        children: [
          // Wallpaper glows
          Positioned(top: -60, right: -80, child: _glow(AppColors.cyan, 260)),
          Positioned(
            bottom: 40,
            left: -100,
            child: _glow(AppColors.violet, 280),
          ),
          Column(
            children: [
              const _StatusBar(),
              const SizedBox(height: 26),
              // Profile widget
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    color: Colors.white.withValues(alpha: 0.09),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.12),
                    ),
                  ),
                  child: Row(
                    children: [
                      ClipOval(
                        child: Image.asset(
                          profile.avatarAsset,
                          width: 46,
                          height: 46,
                          fit: BoxFit.cover,
                          cacheWidth: 120,
                          excludeFromSemantics: true,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profile.name,
                              style: AppText.title(13.5, color: Colors.white),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              profile.title,
                              style: AppText.body(
                                10.5,
                                color: Colors.white70,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(
                                    color: AppColors.green,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  '${profile.yearsOfExperience.floor()}+ yrs · ${profile.appsShipped} apps',
                                  style: AppText.mono(
                                    9.5,
                                    color: Colors.white60,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // App grid built from real project icons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: GridView.count(
                  crossAxisCount: 4,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.78,
                  padding: EdgeInsets.zero,
                  children: [
                    for (final p in PortfolioData.projects)
                      _AppIcon(image: p.iconAsset, label: p.title),
                  ],
                ),
              ),
              const Spacer(),
              // Page dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0; i < 3; i++)
                    Container(
                      width: 6,
                      height: 6,
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(
                          alpha: i == 0 ? 0.9 : 0.3,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              // Dock
              Container(
                margin: const EdgeInsets.fromLTRB(12, 0, 12, 14),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  color: Colors.white.withValues(alpha: 0.12),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _DockIcon(
                      colors: [Color(0xFFFF8A3D), Color(0xFFF0513A)],
                      child: SwiftGlyph(size: 26),
                    ),
                    _DockIcon(
                      colors: [Color(0xFF1F2A44), Color(0xFF0E1525)],
                      child: FlutterLogo(size: 26),
                    ),
                    _DockIcon(
                      colors: [Color(0xFF2B2F3A), Color(0xFF101217)],
                      child: Icon(Icons.apple, color: Colors.white, size: 28),
                    ),
                    _DockIcon(
                      colors: [Color(0xFF3DDC84), Color(0xFF1E9E5A)],
                      child: Icon(Icons.android, color: Colors.white, size: 26),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget _glow(Color c, double size) => Container(
  width: size,
  height: size,
  decoration: BoxDecoration(
    shape: BoxShape.circle,
    gradient: RadialGradient(
      colors: [c.withValues(alpha: 0.35), c.withValues(alpha: 0)],
    ),
  ),
);

class _AppIcon extends StatelessWidget {
  const _AppIcon({required this.image, required this.label});

  final String image;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(13),
          child: Image.asset(
            image,
            width: 52,
            height: 52,
            fit: BoxFit.cover,
            cacheWidth: 128,
            excludeFromSemantics: true,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppText.body(9.5, color: Colors.white, height: 1.1),
        ),
      ],
    );
  }
}

class _DockIcon extends StatelessWidget {
  const _DockIcon({required this.colors, required this.child});

  final List<Color> colors;
  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
    width: 50,
    height: 50,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(13),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: colors,
      ),
    ),
    child: child,
  );
}

// -----------------------------------------------------------------------------
// Project launch screen
// -----------------------------------------------------------------------------

/// A branded launch screen built from the app's real icon, name and
/// description, tinted with a colour from its domain. This deliberately
/// isn't a fake screenshot.
class ProjectLaunchScreen extends StatelessWidget {
  const ProjectLaunchScreen({super.key, required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    final c = project.color;
    return _ScreenCanvas(
      background: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.lerp(c, Colors.black, 0.55)!,
            Color.lerp(c, Colors.black, 0.86)!,
            const Color(0xFF050608),
          ],
          stops: const [0, 0.55, 1],
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(painter: MotifPainter(project.motif, c)),
          ),
          Column(
            children: [
              const _StatusBar(),
              const SizedBox(height: 92),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: c.withValues(alpha: 0.6),
                      blurRadius: 60,
                      spreadRadius: -6,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.asset(
                    project.iconAsset,
                    width: 116,
                    height: 116,
                    fit: BoxFit.cover,
                    cacheWidth: 300,
                    semanticLabel: '${project.title} app icon',
                  ),
                ),
              ),
              const SizedBox(height: 26),
              Text(
                project.title,
                textAlign: TextAlign.center,
                style: AppText.display(26, color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                project.domain.toUpperCase(),
                style: AppText.mono(
                  9.5,
                  color: c,
                  letterSpacing: 1.6,
                  weight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  project.description,
                  textAlign: TextAlign.center,
                  style: AppText.body(12.5, color: Colors.white70, height: 1.5),
                ),
              ),
              const Spacer(),
              Container(
                margin: const EdgeInsets.fromLTRB(28, 0, 28, 14),
                height: 46,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(23),
                  color: c,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    platformIcon(
                      project.platforms.last,
                      size: 15,
                      color: Colors.black,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'Get it on ${project.storeLabel}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.body(
                          12.5,
                          color: Colors.black,
                          weight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Home indicator
              Container(
                width: 104,
                height: 4.5,
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Abstract, domain-specific background motif for a project screen.
class MotifPainter extends CustomPainter {
  const MotifPainter(this.motif, this.color);

  final ProjectMotif motif;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final faint =
        Paint()
          ..color = color.withValues(alpha: 0.16)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.4;
    final fill = Paint()..color = color.withValues(alpha: 0.12);
    final rnd = math.Random(motif.index + 7);
    final w = size.width;
    final h = size.height;

    switch (motif) {
      case ProjectMotif.candles:
        var y = h * 0.82;
        for (var i = 0; i < 14; i++) {
          final x = 12 + i * (w - 24) / 13;
          final delta = (rnd.nextDouble() - 0.42) * 36;
          final top = math.min(y, y - delta);
          final bottom = math.max(y, y - delta);
          canvas.drawLine(
            Offset(x, top - 10 - rnd.nextDouble() * 10),
            Offset(x, bottom + 10 + rnd.nextDouble() * 10),
            faint,
          );
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTRB(x - 5, top, x + 5, math.max(bottom, top + 4)),
              const Radius.circular(2),
            ),
            fill,
          );
          y -= delta;
        }
      case ProjectMotif.storefront:
        const cols = 3;
        final cell = (w - 40) / cols;
        for (var r = 0; r < 4; r++) {
          for (var c = 0; c < cols; c++) {
            canvas.drawRRect(
              RRect.fromRectAndRadius(
                Rect.fromLTWH(
                  14 + c * (cell + 6),
                  h * 0.62 + r * (cell * 1.25),
                  cell,
                  cell * 1.1,
                ),
                const Radius.circular(10),
              ),
              faint,
            );
          }
        }
      case ProjectMotif.pulse:
        final path = Path()..moveTo(0, h * 0.8);
        for (double x = 0; x <= w; x += 4) {
          final beat = (x % 70) < 14 ? math.sin((x % 70) / 14 * math.pi) : 0;
          path.lineTo(x, h * 0.8 - beat * 46 + math.sin(x / 9) * 2);
        }
        canvas.drawPath(path, faint..strokeWidth = 2);
      case ProjectMotif.chat:
        for (var i = 0; i < 5; i++) {
          final left = i.isEven;
          final bw = 90.0 + rnd.nextDouble() * 70;
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTWH(left ? 16 : w - 16 - bw, h * 0.64 + i * 34, bw, 26),
              const Radius.circular(13),
            ),
            left ? faint : fill,
          );
        }
      case ProjectMotif.breathe:
        for (var i = 1; i <= 6; i++) {
          canvas.drawCircle(
            Offset(w / 2, h * 0.27),
            30.0 + i * 26,
            faint..color = color.withValues(alpha: 0.18 - i * 0.022),
          );
        }
      case ProjectMotif.media:
        for (var i = 0; i < 34; i++) {
          final bh = 10 + rnd.nextDouble() * 60;
          final x = 10 + i * (w - 20) / 34;
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromCenter(
                center: Offset(x, h * 0.83),
                width: 3.5,
                height: bh,
              ),
              const Radius.circular(2),
            ),
            fill,
          );
        }
    }
  }

  @override
  bool shouldRepaint(covariant MotifPainter old) =>
      old.motif != motif || old.color != color;
}

// -----------------------------------------------------------------------------
// Contact screen
// -----------------------------------------------------------------------------

/// Messaging-style contact screen for the closing section.
class ContactScreenUI extends StatelessWidget {
  const ContactScreenUI({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = PortfolioData.profile;
    return _ScreenCanvas(
      background: const BoxDecoration(color: Color(0xFF08090E)),
      child: Column(
        children: [
          const _StatusBar(),
          const SizedBox(height: 22),
          ClipOval(
            child: Image.asset(
              profile.avatarAsset,
              width: 62,
              height: 62,
              fit: BoxFit.cover,
              cacheWidth: 160,
              excludeFromSemantics: true,
            ),
          ),
          const SizedBox(height: 8),
          Text(profile.name, style: AppText.title(14, color: Colors.white)),
          Text(
            profile.title,
            style: AppText.body(10.5, color: Colors.white54, height: 1.4),
          ),
          const SizedBox(height: 14),
          Container(height: 1, color: Colors.white10),
          const SizedBox(height: 14),
          const _Bubble(text: 'Hi there 👋', mine: false),
          const _Bubble(
            text:
                'Got an app idea, or a product that needs a senior mobile engineer?',
            mine: false,
          ),
          const _Bubble(
            text: 'Let’s build something great together.',
            mine: true,
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (final s in PortfolioData.socials)
                  Container(
                    width: 52,
                    height: 52,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.07),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: SocialGlyph(s.kind, size: 20, color: Colors.white),
                  ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(14, 6, 14, 12),
            padding: const EdgeInsets.symmetric(horizontal: 14),
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white24),
            ),
            child: Row(
              children: [
                Text(
                  'Message…',
                  style: AppText.body(12, color: Colors.white38),
                ),
                const Spacer(),
                Container(
                  width: 26,
                  height: 26,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppColors.accentGradient,
                  ),
                  child: const Icon(
                    Icons.arrow_upward_rounded,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 104,
            height: 4.5,
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ],
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.text, required this.mine});

  final String text;
  final bool mine;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 200),
        margin: const EdgeInsets.fromLTRB(14, 0, 14, 8),
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(mine ? 18 : 4),
            bottomRight: Radius.circular(mine ? 4 : 18),
          ),
          gradient: mine ? AppColors.accentGradient : null,
          color: mine ? null : Colors.white.withValues(alpha: 0.09),
        ),
        child: Text(
          text,
          style: AppText.body(12, color: Colors.white, height: 1.4),
        ),
      ),
    );
  }
}
