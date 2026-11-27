import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../core/motion.dart';
import '../core/page_scope.dart';
import '../core/scene_3d.dart';
import '../data/portfolio_data.dart';
import '../theme/app_theme.dart';
import '../widgets/buttons.dart';
import '../widgets/device_frames.dart';
import '../widgets/phone_screens.dart';
import '../widgets/surfaces.dart';
import '../widgets/tech_logos.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final size = Breakpoints.of(context);
    final viewport = MediaQuery.sizeOf(context);
    final topInset = MediaQuery.paddingOf(context).top + 96;

    if (size == ScreenSize.desktop) {
      return ConstrainedBox(
        constraints: BoxConstraints(minHeight: math.max(viewport.height, 760)),
        child: Padding(
          padding: EdgeInsets.only(top: topInset, bottom: 40),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(flex: 11, child: _HeroCopy()),
              SizedBox(width: 24),
              Expanded(flex: 10, child: _HeroScene(height: 660)),
            ],
          ),
        ),
      );
    }

    final mobile = size == ScreenSize.mobile;
    return Padding(
      padding: EdgeInsets.only(top: topInset - 16),
      child: Column(
        children: [
          const _HeroCopy(centered: false),
          SizedBox(height: mobile ? 8 : 24),
          _HeroScene(height: mobile ? 480 : 600),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Copy column
// -----------------------------------------------------------------------------

class _HeroCopy extends StatelessWidget {
  const _HeroCopy({this.centered = false});

  final bool centered;

  @override
  Widget build(BuildContext context) {
    final p = PortfolioData.profile;
    final size = Breakpoints.of(context);
    final scope = PageScope.of(context);
    final reduce = Motion.reduced(context);
    final nameSize = switch (size) {
      ScreenSize.mobile => 50.0,
      ScreenSize.tablet => 72.0,
      ScreenSize.desktop => 84.0,
    };
    final names = p.name.split(' ');
    final first = names.first;
    final rest = names.skip(1).join(' ');

    Widget staged(int i, Widget child) => Reveal(
      delay: Duration(milliseconds: 120 + i * 110),
      offset: const Offset(0, 22),
      child: child,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        staged(0, const _IdentityPill()),
        const SizedBox(height: 28),
        staged(
          1,
          Text(
            p.title.toUpperCase(),
            style: AppText.mono(
              size == ScreenSize.mobile ? 11.5 : 13,
              color: AppColors.cyan,
              letterSpacing: 3,
            ),
          ),
        ),
        const SizedBox(height: 14),
        staged(
          2,
          Semantics(
            header: true,
            label: p.name,
            excludeSemantics: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(first, style: AppText.display(nameSize)),
                GradientText(rest, style: AppText.display(nameSize)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 22),
        staged(
          3,
          Text(
            p.headline,
            style: AppText.title(
              size == ScreenSize.mobile ? 16 : 19,
              color: AppColors.textPrimary.withValues(alpha: 0.9),
              weight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 14),
        staged(
          4,
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 470),
            child: Text(
              p.intro,
              style: AppText.body(size == ScreenSize.mobile ? 15.5 : 17),
            ),
          ),
        ),
        const SizedBox(height: 34),
        staged(
          5,
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              AppButton(
                label: 'Explore My Work',
                icon: Icons.arrow_forward_rounded,
                onPressed:
                    () => scope.scrollTo(
                      SectionId.projects,
                      reduceMotion: reduce,
                    ),
              ),
              if (p.resumeUrl != null)
                AppButton(
                  label: 'Download Resume',
                  icon: Icons.download_rounded,
                  style: AppButtonStyle.ghost,
                  url: p.resumeUrl,
                )
              else
                AppButton(
                  label: 'Get in Touch',
                  icon: Icons.north_east_rounded,
                  style: AppButtonStyle.ghost,
                  onPressed:
                      () => scope.scrollTo(
                        SectionId.contact,
                        reduceMotion: reduce,
                      ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        staged(
          6,
          Row(
            children: [
              for (final s in PortfolioData.socials) ...[
                IconCircleButton(
                  icon: SocialGlyph(s.kind),
                  tooltip: s.label,
                  url: s.url,
                ),
                const SizedBox(width: 10),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _IdentityPill extends StatelessWidget {
  const _IdentityPill();

  @override
  Widget build(BuildContext context) {
    final p = PortfolioData.profile;
    return Container(
      padding: const EdgeInsets.fromLTRB(4, 4, 16, 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: Colors.white.withValues(alpha: 0.04),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.accentGradient,
            ),
            child: ClipOval(
              child: Image.asset(
                p.avatarAsset,
                width: 38,
                height: 38,
                fit: BoxFit.cover,
                cacheWidth: 120,
                semanticLabel: 'Portrait of ${p.name}',
              ),
            ),
          ),
          const SizedBox(width: 10),
          const StatusDot(size: 7),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              p.currentStatus,
              overflow: TextOverflow.ellipsis,
              style: AppText.mono(12, color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 3D scene
// -----------------------------------------------------------------------------

class _HeroScene extends StatelessWidget {
  const _HeroScene({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    final size = Breakpoints.of(context);
    final mobile = size == ScreenSize.mobile;
    final phoneW = switch (size) {
      ScreenSize.mobile => 176.0,
      ScreenSize.tablet => 230.0,
      ScreenSize.desktop => 260.0,
    };
    final k = phoneW / 260; // scale factor for satellite positions
    // Pull satellites inward on phones so nothing clips at the screen edge.
    final sx = mobile ? 0.8 : 1.0;

    final nodes = <SceneNode>[
      SceneNode(
        depth: 0,
        bob: 6,
        thickness: 12 * k,
        edge: PhoneFrame.edge(phoneW),
        child: RepaintBoundary(
          child: PhoneFrame(
            width: phoneW,
            glow: AppColors.cyan,
            child: const HomeScreenUI(),
          ),
        ),
      ),
      SceneNode(
        x: -205 * k * sx,
        y: -205 * k,
        depth: 110,
        bob: 12,
        bobPhase: 0.4,
        spin: 0.25,
        child: LogoBadge(
          size: 66 * k,
          label: 'Swift',
          gradient: const [Color(0xFFFFA04D), Color(0xFFF0513A)],
          child: SwiftGlyph(size: 36 * k),
        ),
      ),
      SceneNode(
        x: 215 * k * sx,
        y: -170 * k,
        depth: 70,
        bob: 10,
        bobPhase: 1.6,
        spin: 0.25,
        child: LogoBadge(
          size: 64 * k,
          label: 'Flutter',
          gradient: const [Color(0xFF233558), Color(0xFF0C1424)],
          glow: const Color(0xFF42A5F5),
          child: FlutterLogo(size: 34 * k),
        ),
      ),
      SceneNode(
        x: -235 * k * sx,
        y: 150 * k,
        depth: -70,
        bob: 9,
        bobPhase: 2.4,
        spin: 0.3,
        child: LogoBadge(
          size: 58 * k,
          label: 'iOS',
          gradient: const [Color(0xFF3A3E4A), Color(0xFF111318)],
          glow: Colors.white,
          child: Icon(Icons.apple, color: Colors.white, size: 32 * k),
        ),
      ),
      SceneNode(
        x: 205 * k * sx,
        y: 245 * k,
        depth: 120,
        bob: 11,
        bobPhase: 3.3,
        spin: 0.3,
        child: LogoBadge(
          size: 60 * k,
          label: 'Android',
          gradient: const [Color(0xFF3DDC84), Color(0xFF168A4D)],
          child: Icon(Icons.android, color: Colors.white, size: 32 * k),
        ),
      ),
      SceneNode(
        x: 200 * k * sx,
        y: 40 * k,
        depth: 160,
        bob: 7,
        bobPhase: 1.1,
        child: _CodeCard(scale: mobile ? k * 0.85 : k),
      ),
      if (!mobile) ...[
        SceneNode(
          x: -190 * k * sx,
          y: -20 * k,
          depth: 140,
          bob: 8,
          bobPhase: 2.0,
          child: _ArchitectureCard(scale: k),
        ),
        SceneNode(
          x: -150 * k * sx,
          y: 290 * k,
          depth: 190,
          bob: 6,
          bobPhase: 0.8,
          child: _BuildToast(scale: k),
        ),
        SceneNode(
          x: 120 * k * sx,
          y: -290 * k,
          depth: 30,
          bob: 8,
          bobPhase: 2.8,
          child: _ControlsCard(scale: k),
        ),
      ],
    ];

    final scope = PageScope.of(context);

    return Semantics(
      label:
          'Interactive 3D phone showing apps from the portfolio, surrounded by '
          'Swift, Flutter, iOS and Android badges',
      child: ExcludeSemantics(
        child: Reveal(
          delay: const Duration(milliseconds: 250),
          duration: const Duration(milliseconds: 1200),
          scale: 0.88,
          offset: const Offset(0, 40),
          child: ViewportTickerGate(
            child: SizedBox(
              height: height,
              child: ListenableBuilder(
                listenable: scope.scrollController,
                builder: (context, child) {
                  // Only the desktop hero is fully in the first viewport;
                  // elsewhere the scene sits below the fold, so don't fade it.
                  if (size != ScreenSize.desktop) return child!;
                  final off =
                      scope.scrollController.hasClients
                          ? scope.scrollController.offset
                          : 0.0;
                  // Gentle scroll parallax. Translate only: an Opacity here
                  // would force an offscreen render of the whole 3D scene
                  // on every scroll frame.
                  return Transform.translate(
                    offset: Offset(0, off * 0.18),
                    child: child,
                  );
                },
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    // Ambient glow behind the device
                    IgnorePointer(
                      child: Container(
                        width: phoneW * 2.6,
                        height: phoneW * 2.6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              AppColors.cyan.withValues(alpha: 0.16),
                              AppColors.violet.withValues(alpha: 0.08),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Floor shadow
                    Positioned(
                      bottom: height * 0.04,
                      child: Container(
                        width: phoneW * 1.2,
                        height: 26,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          gradient: RadialGradient(
                            colors: [
                              Colors.black.withValues(alpha: 0.7),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Scene3D(
                        nodes: nodes,
                        orbitAmplitude: mobile ? 0.22 : 0.18,
                        pointerInfluence: 0.28,
                      ),
                    ),
                    if (mobile)
                      Positioned(
                        bottom: 0,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.swipe_rounded,
                              size: 14,
                              color: AppColors.textTertiary,
                            ),
                            const SizedBox(width: 6),
                            Text('drag to rotate', style: AppText.mono(10.5)),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Swift snippet with lightweight syntax colouring.
class _CodeCard extends StatelessWidget {
  const _CodeCard({required this.scale});

  final double scale;

  @override
  Widget build(BuildContext context) {
    final fs = 10.5 * scale;
    TextSpan t(String s, Color c) => TextSpan(
      text: s,
      style: AppText.mono(fs, color: c, weight: FontWeight.w500),
    );
    const kw = Color(0xFFFF7AB2);
    const ty = Color(0xFF6BDFFF);
    const fn = Color(0xFFB281EB);
    const str = Color(0xFFFFB86C);
    const plain = Color(0xFFD7DCE6);

    return _FloatingCard(
      width: 228 * scale,
      padding: EdgeInsets.all(14 * scale),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              for (final c in const [
                Color(0xFFFF5F57),
                Color(0xFFFEBC2E),
                Color(0xFF28C840),
              ])
                Container(
                  width: 7 * scale,
                  height: 7 * scale,
                  margin: EdgeInsets.only(right: 5 * scale),
                  decoration: BoxDecoration(color: c, shape: BoxShape.circle),
                ),
              const Spacer(),
              Text('AppView.swift', style: AppText.mono(9 * scale)),
            ],
          ),
          SizedBox(height: 10 * scale),
          Text.rich(
            TextSpan(
              children: [
                t('struct ', kw),
                t('AppView', ty),
                t(': ', plain),
                t('View', ty),
                t(' {\n', plain),
                t('  @State ', kw),
                t('var ', kw),
                t('model = ', plain),
                t('ViewModel', ty),
                t('()\n', plain),
                t('  var ', kw),
                t('body', fn),
                t(': ', plain),
                t('some ', kw),
                t('View', ty),
                t(' {\n', plain),
                t('    Text', ty),
                t('(', plain),
                t('"Hello, world"', str),
                t(')\n  }\n}', plain),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Miniature View → ViewModel → Repository diagram.
class _ArchitectureCard extends StatelessWidget {
  const _ArchitectureCard({required this.scale});

  final double scale;

  @override
  Widget build(BuildContext context) {
    Widget box(String label, Color c) => Container(
      width: 120 * scale,
      padding: EdgeInsets.symmetric(vertical: 6 * scale),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8 * scale),
        color: c.withValues(alpha: 0.12),
        border: Border.all(color: c.withValues(alpha: 0.5)),
      ),
      child: Text(label, style: AppText.mono(10 * scale, color: c)),
    );
    Widget arrow() => Icon(
      Icons.arrow_downward_rounded,
      size: 12 * scale,
      color: AppColors.textTertiary,
    );
    return _FloatingCard(
      width: 152 * scale,
      padding: EdgeInsets.all(14 * scale),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('// architecture', style: AppText.mono(9 * scale)),
          SizedBox(height: 8 * scale),
          box('View', AppColors.cyan),
          arrow(),
          box('ViewModel', AppColors.violet),
          arrow(),
          box('Repository', AppColors.green),
        ],
      ),
    );
  }
}

class _BuildToast extends StatelessWidget {
  const _BuildToast({required this.scale});

  final double scale;

  @override
  Widget build(BuildContext context) {
    return _FloatingCard(
      width: 220 * scale,
      padding: EdgeInsets.symmetric(
        horizontal: 14 * scale,
        vertical: 12 * scale,
      ),
      child: Row(
        children: [
          Container(
            width: 30 * scale,
            height: 30 * scale,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.green.withValues(alpha: 0.15),
            ),
            child: Icon(
              Icons.check_rounded,
              size: 17 * scale,
              color: AppColors.green,
            ),
          ),
          SizedBox(width: 10 * scale),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Build Succeeded',
                  style: AppText.title(12 * scale, weight: FontWeight.w600),
                ),
                Text('Release · iOS & Android', style: AppText.mono(9 * scale)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A tiny cluster of native-style UI controls.
class _ControlsCard extends StatelessWidget {
  const _ControlsCard({required this.scale});

  final double scale;

  @override
  Widget build(BuildContext context) {
    Widget toggle(bool on) => Container(
      width: 34 * scale,
      height: 20 * scale,
      padding: EdgeInsets.all(2 * scale),
      alignment: on ? Alignment.centerRight : Alignment.centerLeft,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: on ? AppColors.green : Colors.white24,
      ),
      child: Container(
        width: 16 * scale,
        height: 16 * scale,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
      ),
    );
    return _FloatingCard(
      width: 168 * scale,
      padding: EdgeInsets.all(12 * scale),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text('Dark Mode', style: AppText.body(10.5 * scale, height: 1)),
              const Spacer(),
              toggle(true),
            ],
          ),
          SizedBox(height: 10 * scale),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: SizedBox(
              height: 4 * scale,
              child: Row(
                children: [
                  Expanded(
                    flex: 6,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: AppColors.accentGradient,
                      ),
                    ),
                  ),
                  Expanded(flex: 4, child: Container(color: Colors.white12)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FloatingCard extends StatelessWidget {
  const _FloatingCard({
    required this.child,
    required this.width,
    required this.padding,
  });

  final Widget child;
  final double width;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xE6121520),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.45),
            blurRadius: 14,
            offset: const Offset(0, 10),
            spreadRadius: -6,
          ),
        ],
      ),
      child: child,
    );
  }
}
