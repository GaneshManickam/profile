import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../core/motion.dart';
import '../data/models.dart';
import '../data/portfolio_data.dart';
import '../theme/app_theme.dart';
import '../widgets/section_header.dart';
import '../widgets/surfaces.dart';
import '../widgets/tech_logos.dart';

class SkillsSection extends StatefulWidget {
  const SkillsSection({super.key});

  @override
  State<SkillsSection> createState() => _SkillsSectionState();
}

class _SkillsSectionState extends State<SkillsSection> {
  late Skill _selected = PortfolioData.skillCategories.first.skills.first;

  SkillCategory get _selectedCategory => PortfolioData.skillCategories
      .firstWhere((c) => c.skills.contains(_selected));

  void _select(Skill s) => setState(() => _selected = s);

  @override
  Widget build(BuildContext context) {
    final size = Breakpoints.of(context);
    const header = SectionHeader(
      index: '02',
      eyebrow: 'Skills',
      title: 'A universe of tools,\nmastered in production.',
      lede:
          'Tap any orbiting badge or chip to see where it fits. Expertise is '
          'shown through the work, not percentage bars.',
    );

    final orbit = Reveal(
      scale: 0.9,
      child: _SkillOrbit(selected: _selected, onSelect: _select),
    );
    final detail = Reveal(
      delay: const Duration(milliseconds: 120),
      child: _SkillDetail(skill: _selected, category: _selectedCategory),
    );
    final clusters = _Clusters(selected: _selected, onSelect: _select);

    if (size == ScreenSize.desktop) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          header,
          const SizedBox(height: 48),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(flex: 11, child: orbit),
              const SizedBox(width: 40),
              Expanded(
                flex: 10,
                child: Column(
                  children: [detail, const SizedBox(height: 20), clusters],
                ),
              ),
            ],
          ),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        header,
        const SizedBox(height: 28),
        orbit,
        const SizedBox(height: 16),
        detail,
        const SizedBox(height: 20),
        clusters,
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// Orbit
// -----------------------------------------------------------------------------

class _Ring {
  const _Ring({
    required this.category,
    required this.radius,
    required this.tilt,
    required this.roll,
    required this.speed,
  });

  final SkillCategory category;

  /// Fraction of the half-extent.
  final double radius;

  /// Rotation about X (how flat the ellipse looks).
  final double tilt;

  /// Rotation about Z (in-screen angle of the ellipse).
  final double roll;

  /// Radians per second (sign = direction).
  final double speed;
}

class _Projected {
  const _Projected(this.offset, this.z);

  final Offset offset;

  /// Normalised depth in [-1, 1]; positive is toward the viewer.
  final double z;
}

_Projected _project(_Ring ring, double angle, double half) {
  final r = ring.radius * half;
  final x0 = r * math.cos(angle);
  final y0 = r * math.sin(angle);
  // Tilt about X.
  final y1 = y0 * math.cos(ring.tilt);
  final z1 = y0 * math.sin(ring.tilt);
  // Roll about Z.
  final x2 = x0 * math.cos(ring.roll) - y1 * math.sin(ring.roll);
  final y2 = x0 * math.sin(ring.roll) + y1 * math.cos(ring.roll);
  return _Projected(Offset(x2, y2), (z1 / half).clamp(-1.0, 1.0));
}

class _SkillOrbit extends StatefulWidget {
  const _SkillOrbit({required this.selected, required this.onSelect});

  final Skill selected;
  final ValueChanged<Skill> onSelect;

  @override
  State<_SkillOrbit> createState() => _SkillOrbitState();
}

class _SkillOrbitState extends State<_SkillOrbit>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker = createTicker(_tick);
  final _time = ValueNotifier<double>(0);
  Duration _last = Duration.zero;
  bool _paused = false;
  bool _reduced = false;

  static final _rings = <_Ring>[
    _Ring(
      category: _cat('languages'),
      radius: 0.3,
      tilt: 0.62,
      roll: -0.55,
      speed: 0.32,
    ),
    _Ring(
      category: _cat('architecture'),
      radius: 0.52,
      tilt: 0.72,
      roll: 0.5,
      speed: -0.24,
    ),
    _Ring(
      category: _cat('frameworks'),
      radius: 0.74,
      tilt: 0.8,
      roll: -0.22,
      speed: 0.16,
    ),
    _Ring(
      category: _cat('domains'),
      radius: 0.98,
      tilt: 0.86,
      roll: 0.18,
      speed: -0.1,
    ),
  ];

  static SkillCategory _cat(String id) =>
      PortfolioData.skillCategories.firstWhere((c) => c.id == id);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reduced = Motion.reduced(context);
    if (_reduced) {
      if (_ticker.isActive) _ticker.stop();
    } else if (!_ticker.isActive) {
      _last = Duration.zero;
      _ticker.start();
    }
  }

  void _tick(Duration elapsed) {
    final dt = (elapsed - _last).inMicroseconds / 1e6;
    _last = elapsed;
    if (!_paused) _time.value += dt.clamp(0, 0.05);
  }

  @override
  void dispose() {
    _ticker.dispose();
    _time.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final side = math.min(c.maxWidth, 600.0);
        final mobile = side < 420;
        // Without the outer ring, phones can spread the inner rings wider.
        final half = mobile ? (side / 2 - 52) * 1.25 : side / 2 - 44;
        final height = side * (mobile ? 0.78 : 0.92);
        // Phones show the three inner rings only; every skill (including
        // domains) is still listed in the cluster cards below.
        final rings =
            mobile
                ? _rings.where((r) => r.category.id != 'domains').toList()
                : _rings;

        return ViewportTickerGate(
          child: MouseRegion(
            onEnter: (_) => _paused = true,
            onExit: (_) => _paused = false,
            child: SizedBox(
              width: side,
              height: height,
              child: ValueListenableBuilder<double>(
                valueListenable: _time,
                builder: (context, t, _) {
                  final items = <(double, Widget)>[];
                  final center = Offset(side / 2, height / 2);

                  for (final ring in rings) {
                    final skills = ring.category.skills;
                    for (var i = 0; i < skills.length; i++) {
                      final skill = skills[i];
                      final angle =
                          t * ring.speed + i * 2 * math.pi / skills.length;
                      final p = _project(ring, angle, half);
                      final selected = skill == widget.selected;
                      final scale =
                          (0.78 + (p.z + 1) * 0.16) * (mobile ? 0.82 : 1);
                      items.add((
                        p.z,
                        Positioned(
                          left: center.dx + p.offset.dx,
                          top: center.dy + p.offset.dy,
                          child: FractionalTranslation(
                            translation: const Offset(-0.5, -0.5),
                            child: Transform.scale(
                              scale: selected ? scale * 1.15 : scale,
                              child: Opacity(
                                opacity:
                                    selected
                                        ? 1
                                        : (0.4 + (p.z + 1) * 0.3).clamp(
                                          0.0,
                                          1.0,
                                        ),
                                child: _OrbitBadge(
                                  skill: skill,
                                  color: ring.category.color,
                                  selected: selected,
                                  onTap: () => widget.onSelect(skill),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ));
                    }
                  }
                  // Core sits at depth 0 so back badges pass behind it.
                  items.add((
                    0,
                    Positioned(
                      left: center.dx,
                      top: center.dy,
                      child: FractionalTranslation(
                        translation: const Offset(-0.5, -0.5),
                        child: _Core(size: mobile ? 76 : 104),
                      ),
                    ),
                  ));
                  items.sort((a, b) => a.$1.compareTo(b.$1));

                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned.fill(
                        child: CustomPaint(
                          painter: _OrbitPainter(
                            rings: rings,
                            half: half,
                            time: t,
                            selected: widget.selected,
                          ),
                        ),
                      ),
                      for (final item in items) item.$2,
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class _OrbitPainter extends CustomPainter {
  _OrbitPainter({
    required this.rings,
    required this.half,
    required this.time,
    required this.selected,
  });

  final List<_Ring> rings;
  final double half;
  final double time;
  final Skill selected;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    for (final ring in rings) {
      final path = Path();
      for (var i = 0; i <= 96; i++) {
        final p = _project(ring, i / 96 * 2 * math.pi, half);
        final o = center + p.offset;
        i == 0 ? path.moveTo(o.dx, o.dy) : path.lineTo(o.dx, o.dy);
      }
      canvas.drawPath(
        path,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1
          ..color = ring.category.color.withValues(alpha: 0.18),
      );

      // Connection line from the core to the selected badge.
      final idx = ring.category.skills.indexOf(selected);
      if (idx >= 0) {
        final angle =
            time * ring.speed + idx * 2 * math.pi / ring.category.skills.length;
        final p = _project(ring, angle, half);
        final end = center + p.offset;
        canvas.drawLine(
          center,
          end,
          Paint()
            ..strokeWidth = 1.4
            ..shader = LinearGradient(
              colors: [
                ring.category.color.withValues(alpha: 0.0),
                ring.category.color.withValues(alpha: 0.8),
              ],
            ).createShader(Rect.fromPoints(center, end)),
        );
        // Travelling pulse along the connection.
        final f = (time * 0.8) % 1.0;
        canvas.drawCircle(
          Offset.lerp(center, end, f)!,
          2.6,
          Paint()..color = ring.category.color,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _OrbitPainter old) =>
      old.time != time || old.selected != selected || old.half != half;
}

class _Core extends StatelessWidget {
  const _Core({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const RadialGradient(
          center: Alignment(-0.35, -0.4),
          colors: [Color(0xFF3B4566), Color(0xFF12151F), Color(0xFF07080C)],
          stops: [0, 0.6, 1],
        ),
        border: Border.all(color: AppColors.cyan.withValues(alpha: 0.35)),
        boxShadow: [
          BoxShadow(
            color: AppColors.cyan.withValues(alpha: 0.3),
            blurRadius: size * 0.6,
          ),
          BoxShadow(
            color: AppColors.violet.withValues(alpha: 0.25),
            blurRadius: size,
            spreadRadius: size * 0.1,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.phone_iphone_rounded,
            color: AppColors.cyan,
            size: size * 0.3,
          ),
          SizedBox(height: size * 0.04),
          Text(
            'MOBILE',
            style: AppText.mono(
              size * 0.1,
              color: AppColors.textPrimary,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _OrbitBadge extends StatefulWidget {
  const _OrbitBadge({
    required this.skill,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final Skill skill;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<_OrbitBadge> createState() => _OrbitBadgeState();
}

class _OrbitBadgeState extends State<_OrbitBadge> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final active = widget.selected || _hover;
    return Semantics(
      button: true,
      selected: widget.selected,
      label: widget.skill.name,
      excludeSemantics: true,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              color: Color.alphaBlend(
                widget.color.withValues(alpha: active ? 0.22 : 0.1),
                AppColors.surface,
              ),
              border: Border.all(
                color: widget.color.withValues(alpha: active ? 0.9 : 0.35),
              ),
              boxShadow:
                  active
                      ? [
                        BoxShadow(
                          color: widget.color.withValues(alpha: 0.45),
                          blurRadius: 18,
                        ),
                      ]
                      : null,
            ),
            child: Text(
              widget.skill.name,
              style: AppText.mono(
                12,
                color: active ? AppColors.textPrimary : widget.color,
                weight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Detail + clusters
// -----------------------------------------------------------------------------

class _SkillDetail extends StatelessWidget {
  const _SkillDetail({required this.skill, required this.category});

  final Skill skill;
  final SkillCategory category;

  @override
  Widget build(BuildContext context) {
    final projects =
        PortfolioData.projects
            .where((p) => skill.relatedProjects.contains(p.title))
            .toList();
    return GlassPanel(
      glow: category.color,
      borderColor: category.color.withValues(alpha: 0.3),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        switchInCurve: Motion.emphasized,
        transitionBuilder:
            (child, anim) => FadeTransition(
              opacity: anim,
              child: SlideTransition(
                position: Tween(
                  begin: const Offset(0, 0.08),
                  end: Offset.zero,
                ).animate(anim),
                child: child,
              ),
            ),
        layoutBuilder:
            (current, previous) => Stack(
              alignment: Alignment.topLeft,
              children: [...previous, if (current != null) current],
            ),
        child: Semantics(
          key: ValueKey(skill.name),
          liveRegion: true,
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: category.color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      category.label.toUpperCase(),
                      style: AppText.mono(
                        11,
                        color: category.color,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(skill.name, style: AppText.display(32)),
                const SizedBox(height: 10),
                Text(skill.blurb, style: AppText.body(15.5)),
                if (projects.isNotEmpty) ...[
                  const SizedBox(height: 18),
                  Text('// shipped in', style: AppText.mono(11)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final p in projects)
                        TagChip(
                          label: p.title,
                          color: p.color,
                          icon: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Image.asset(
                              p.iconAsset,
                              width: 16,
                              height: 16,
                              cacheWidth: 48,
                              excludeFromSemantics: true,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Clusters extends StatelessWidget {
  const _Clusters({required this.selected, required this.onSelect});

  final Skill selected;
  final ValueChanged<Skill> onSelect;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final cols = c.maxWidth > 520 ? 2 : 1;
        final w = (c.maxWidth - (cols - 1) * 16) / cols;
        final cats = PortfolioData.skillCategories;
        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            for (var i = 0; i < cats.length; i++)
              SizedBox(
                width: w,
                child: Reveal(
                  delay: Duration(milliseconds: 80 * i),
                  child: TiltCard(
                    maxTilt: 0.06,
                    child: GlassPanel(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(cats[i].label, style: AppText.title(15)),
                              const Spacer(),
                              Text(
                                cats[i].skills.length.toString().padLeft(
                                  2,
                                  '0',
                                ),
                                style: AppText.mono(11, color: cats[i].color),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: [
                              for (final s in cats[i].skills)
                                Semantics(
                                  button: true,
                                  selected: s == selected,
                                  label: s.name,
                                  excludeSemantics: true,
                                  child: MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: GestureDetector(
                                      onTap: () => onSelect(s),
                                      child: TagChip(
                                        label: s.name,
                                        color: cats[i].color,
                                        selected: s == selected,
                                        dense: true,
                                        icon:
                                            s.name == 'Flutter'
                                                ? FlutterMonochromeIcon(
                                                  size: 10,
                                                  color: cats[i].color,
                                                )
                                                : null,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
