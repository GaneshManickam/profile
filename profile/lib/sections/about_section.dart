import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../core/motion.dart';
import '../core/scene_3d.dart';
import '../data/portfolio_data.dart';
import '../theme/app_theme.dart';
import '../widgets/device_frames.dart';
import '../widgets/phone_screens.dart';
import '../widgets/section_header.dart';
import '../widgets/surfaces.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final size = Breakpoints.of(context);
    final header = const SectionHeader(
      index: '01',
      eyebrow: 'About',
      title: 'Engineering apps that\nfeel effortless.',
    );

    if (size == ScreenSize.desktop) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          header,
          const SizedBox(height: 56),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 10, child: _Workspace(height: 520)),
              SizedBox(width: 48),
              Expanded(flex: 11, child: _AboutContent()),
            ],
          ),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        header,
        const SizedBox(height: 24),
        _Workspace(height: size == ScreenSize.mobile ? 300 : 440),
        const SizedBox(height: 24),
        const _AboutContent(),
      ],
    );
  }
}

class _AboutContent extends StatelessWidget {
  const _AboutContent();

  @override
  Widget build(BuildContext context) {
    final p = PortfolioData.profile;
    final mobile = Breakpoints.of(context) == ScreenSize.mobile;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Reveal(
          child: Text(
            p.summary,
            style: AppText.body(
              mobile ? 16 : 18,
              color: AppColors.textPrimary.withValues(alpha: 0.86),
              height: 1.7,
            ),
          ),
        ),
        const SizedBox(height: 28),
        Reveal(
          delay: const Duration(milliseconds: 100),
          child: LayoutBuilder(
            builder: (context, c) {
              final stats = [
                (
                  '${p.yearsOfExperience.toStringAsFixed(1)}+',
                  'Years building',
                ),
                (p.appsShipped, 'Apps delivered'),
                (p.domainsCount, 'Domains'),
              ];
              // Equal-width, equal-height cards on every screen size.
              return Row(
                children: [
                  for (var i = 0; i < stats.length; i++) ...[
                    if (i > 0) SizedBox(width: mobile ? 10 : 12),
                    Expanded(
                      child: _Stat(
                        value: stats[i].$1,
                        label: stats[i].$2,
                        compact: mobile,
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 28),
        Reveal(
          delay: const Duration(milliseconds: 150),
          child: GlassPanel(
            glow: AppColors.violet,
            padding: const EdgeInsets.all(22),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '“',
                  style: AppText.display(
                    48,
                    color: AppColors.violet,
                  ).copyWith(height: 0.9),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'DEVELOPMENT PHILOSOPHY',
                        style: AppText.mono(10.5, letterSpacing: 2),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        PortfolioData.philosophy,
                        style: AppText.title(
                          mobile ? 16 : 18,
                          weight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 28),
        Reveal(
          delay: const Duration(milliseconds: 200),
          child: _Facet(
            label: 'Areas of expertise',
            children: [
              for (final e in PortfolioData.expertise)
                TagChip(label: e, color: AppColors.cyan),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Reveal(
          delay: const Duration(milliseconds: 250),
          child: _Facet(
            label: 'Industries',
            children: [
              for (final i in PortfolioData.industries)
                TagChip(label: i, color: AppColors.pink),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Reveal(
          delay: const Duration(milliseconds: 300),
          child: _Facet(
            label: 'Core technologies',
            children: [
              for (final s in const [
                'Swift',
                'SwiftUI',
                'UIKit',
                'Objective-C',
                'Flutter',
                'Firebase',
              ])
                TagChip(label: s, color: AppColors.violet),
            ],
          ),
        ),
      ],
    );
  }
}

class _Facet extends StatelessWidget {
  const _Facet({required this.label, required this.children});

  final String label;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('// $label', style: AppText.mono(12)),
        const SizedBox(height: 10),
        Wrap(spacing: 8, runSpacing: 8, children: children),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label, this.compact = false});

  final String value;
  final String label;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return TiltCard(
      borderRadius: 16,
      child: SizedBox(
        width: double.infinity,
        height: compact ? 96 : 104,
        child: GlassPanel(
          radius: 16,
          padding: EdgeInsets.symmetric(
            vertical: compact ? 14 : 18,
            horizontal: compact ? 12 : 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // Top-aligned so the numbers line up even when a label wraps.
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: GradientText(
                  value,
                  style: AppText.display(compact ? 26 : 30),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppText.mono(compact ? 10 : 11).copyWith(height: 1.3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 3D workspace: laptop + tablet + phone
// -----------------------------------------------------------------------------

class _Workspace extends StatelessWidget {
  const _Workspace({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final k = math.min(c.maxWidth / 600, height / 520).clamp(0.5, 1.1);
        final laptopW = 330 * k;
        final tabletW = 190 * k;
        final phoneW = 92 * k;
        return Semantics(
          label:
              'Illustration of a developer workspace with laptop, tablet and phone',
          child: ExcludeSemantics(
            child: Reveal(
              scale: 0.92,
              child: ViewportTickerGate(
                child: SizedBox(
                  height: height,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: laptopW * 1.6,
                        height: laptopW * 1.6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              AppColors.violet.withValues(alpha: 0.14),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Scene3D(
                          baseRotateX: -0.12,
                          baseRotateY: 0.22,
                          orbitAmplitude: 0.14,
                          pointerInfluence: 0.18,
                          period: const Duration(seconds: 18),
                          nodes: [
                            SceneNode(
                              y: -20 * k,
                              depth: 0,
                              bob: 3,
                              child: LaptopFrame(
                                width: laptopW,
                                child: const _EditorScreen(),
                              ),
                            ),
                            SceneNode(
                              x: -170 * k,
                              y: 90 * k,
                              depth: 90,
                              bob: 7,
                              bobPhase: 1.2,
                              thickness: 6 * k,
                              edge: TabletFrame.edge(tabletW),
                              child: TabletFrame(
                                width: tabletW,
                                child: const _DashboardScreen(),
                              ),
                            ),
                            SceneNode(
                              x: 180 * k,
                              y: 80 * k,
                              depth: 140,
                              bob: 9,
                              bobPhase: 2.5,
                              thickness: 6 * k,
                              edge: PhoneFrame.edge(phoneW),
                              child: PhoneFrame(
                                width: phoneW,
                                child: ProjectLaunchScreen(
                                  project: PortfolioData.projects.firstWhere(
                                    (p) => p.title == 'Orca Media Player',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Abstract code editor: file tree + colour-coded lines.
class _EditorScreen extends StatelessWidget {
  const _EditorScreen();

  static const _lines = <List<(double, Color)>>[
    [(0.18, Color(0xFFFF7AB2)), (0.3, Color(0xFF6BDFFF))],
    [
      (0.08, Colors.transparent),
      (0.22, Color(0xFFFF7AB2)),
      (0.34, Color(0xFFD7DCE6)),
    ],
    [
      (0.08, Colors.transparent),
      (0.16, Color(0xFFB281EB)),
      (0.4, Color(0xFFFFB86C)),
    ],
    [
      (0.16, Colors.transparent),
      (0.3, Color(0xFF6BDFFF)),
      (0.2, Color(0xFFD7DCE6)),
    ],
    [(0.16, Colors.transparent), (0.42, Color(0xFF7EE787))],
    [(0.08, Colors.transparent), (0.06, Color(0xFFD7DCE6))],
    [],
    [
      (0.18, Color(0xFFFF7AB2)),
      (0.26, Color(0xFF6BDFFF)),
      (0.14, Color(0xFFD7DCE6)),
    ],
    [(0.08, Colors.transparent), (0.36, Color(0xFFB281EB))],
    [
      (0.16, Colors.transparent),
      (0.24, Color(0xFF6BDFFF)),
      (0.24, Color(0xFFFFB86C)),
    ],
    [(0.08, Colors.transparent), (0.06, Color(0xFFD7DCE6))],
    [(0.06, Color(0xFFD7DCE6))],
  ];

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.cover,
      child: SizedBox(
        width: 400,
        height: 250,
        child: ColoredBox(
          color: const Color(0xFF0D1017),
          child: Row(
            children: [
              // Sidebar
              Container(
                width: 92,
                color: const Color(0xFF11151E),
                padding: const EdgeInsets.fromLTRB(10, 12, 8, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final f in const [
                      'App',
                      '  Features',
                      '  Core',
                      '  Services',
                      '  Resources',
                      'Tests',
                    ])
                      Padding(
                        padding: const EdgeInsets.only(bottom: 7),
                        child: Text(
                          f,
                          style: AppText.mono(
                            8,
                            color: const Color(0xFF8B93A6),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 12, 12, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A2030),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'FeatureView.swift',
                              style: AppText.mono(
                                7.5,
                                color: const Color(0xFFD7DCE6),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      for (var i = 0; i < _lines.length; i++)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6.5),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 16,
                                child: Text(
                                  '${i + 1}',
                                  style: AppText.mono(
                                    7,
                                    color: const Color(0xFF4A5165),
                                  ),
                                ),
                              ),
                              for (final seg in _lines[i])
                                Container(
                                  width: 230 * seg.$1,
                                  height: 5,
                                  margin: const EdgeInsets.only(right: 5),
                                  decoration: BoxDecoration(
                                    color: seg.$2.withValues(
                                      alpha:
                                          seg.$2 == Colors.transparent
                                              ? 0
                                              : 0.75,
                                    ),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                            ],
                          ),
                        ),
                    ],
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

/// Abstract analytics dashboard for the tablet.
class _DashboardScreen extends StatelessWidget {
  const _DashboardScreen();

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.cover,
      child: SizedBox(
        width: 320,
        height: 228,
        child: ColoredBox(
          color: const Color(0xFF0A0D14),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 7,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: 18,
                      height: 18,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppColors.accentGradient,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    for (final c in const [
                      AppColors.cyan,
                      AppColors.violet,
                      AppColors.green,
                    ])
                      Expanded(
                        child: Container(
                          height: 46,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: c.withValues(alpha: 0.12),
                            border: Border.all(
                              color: c.withValues(alpha: 0.35),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white.withValues(alpha: 0.04),
                    ),
                    child: CustomPaint(
                      painter: _ChartPainter(),
                      size: Size.infinite,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final pts = [0.7, 0.55, 0.62, 0.4, 0.46, 0.28, 0.34, 0.18];
    final path = Path();
    for (var i = 0; i < pts.length; i++) {
      final o = Offset(size.width * i / (pts.length - 1), size.height * pts[i]);
      i == 0 ? path.moveTo(o.dx, o.dy) : path.lineTo(o.dx, o.dy);
    }
    final fill =
        Path.from(path)
          ..lineTo(size.width, size.height)
          ..lineTo(0, size.height)
          ..close();
    canvas.drawPath(
      fill,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.cyan.withValues(alpha: 0.3), Colors.transparent],
        ).createShader(Offset.zero & size),
    );
    canvas.drawPath(
      path,
      Paint()
        ..color = AppColors.cyan
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
