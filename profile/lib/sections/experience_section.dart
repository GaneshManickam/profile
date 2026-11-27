import 'package:flutter/material.dart';

import '../core/motion.dart';
import '../data/models.dart';
import '../data/portfolio_data.dart';
import '../theme/app_theme.dart';
import '../widgets/section_header.dart';
import '../widgets/surfaces.dart';

const _months = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

String _fmt(DateTime d) => '${_months[d.month - 1]} ${d.year}';

String _period(Experience e) =>
    '${_fmt(e.start)} — ${e.end == null ? 'Present' : _fmt(e.end!)}';

/// Inclusive tenure, e.g. "2 yrs 10 mos".
String _tenure(Experience e) {
  final end = e.end ?? DateTime.now();
  var months = (end.year - e.start.year) * 12 + end.month - e.start.month + 1;
  if (months < 1) months = 1;
  final y = months ~/ 12;
  final m = months % 12;
  final parts = <String>[
    if (y > 0) '$y yr${y > 1 ? 's' : ''}',
    if (m > 0) '$m mo${m > 1 ? 's' : ''}',
  ];
  return parts.join(' ');
}

class ExperienceSection extends StatefulWidget {
  const ExperienceSection({super.key});

  @override
  State<ExperienceSection> createState() => _ExperienceSectionState();
}

class _ExperienceSectionState extends State<ExperienceSection> {
  int? _expanded = 0;

  @override
  Widget build(BuildContext context) {
    final items = PortfolioData.experiences;
    final desktop = Breakpoints.of(context) == ScreenSize.desktop;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          index: '03',
          eyebrow: 'Career Journey',
          title: 'A decade of shipping\nmobile products.',
          lede: 'From iOS Developer to Staff Engineer. Tap a role for details.',
        ),
        SizedBox(height: desktop ? 56 : 32),
        Column(
          children: [
            for (var i = 0; i < items.length; i++)
              _TimelineRow(
                experience: items[i],
                promoted:
                    i + 1 < items.length &&
                    items[i + 1].company == items[i].company,
                expanded: _expanded == i,
                isLast: i == items.length - 1,
                desktop: desktop,
                onToggle:
                    () => setState(() => _expanded = _expanded == i ? null : i),
              ),
          ],
        ),
      ],
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({
    required this.experience,
    required this.promoted,
    required this.expanded,
    required this.isLast,
    required this.desktop,
    required this.onToggle,
  });

  final Experience experience;
  final bool promoted;
  final bool expanded;
  final bool isLast;
  final bool desktop;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final e = experience;
    final railW = desktop ? 56.0 : 32.0;

    final dateW = desktop ? 150.0 : 0.0;
    // The card sizes itself; the rail is a positioned overlay stretched to
    // the row's real height. (IntrinsicHeight under-measured the expanded
    // card, letting its content spill outside.)
    return Stack(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (desktop)
              SizedBox(
                width: 150,
                child: Padding(
                  padding: const EdgeInsets.only(top: 22),
                  child: Reveal(
                    offset: const Offset(-16, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          e.isCurrent ? 'Now' : '${e.end!.year}',
                          style: AppText.title(
                            22,
                            color:
                                e.isCurrent
                                    ? AppColors.cyan
                                    : AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(_tenure(e), style: AppText.mono(11)),
                      ],
                    ),
                  ),
                ),
              ),
            SizedBox(width: railW),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
                child: Reveal(
                  offset: const Offset(24, 0),
                  child: _ExperienceCard(
                    experience: e,
                    promoted: promoted,
                    expanded: expanded,
                    onToggle: onToggle,
                  ),
                ),
              ),
            ),
          ],
        ),
        Positioned(
          left: dateW,
          top: 0,
          bottom: 0,
          width: railW,
          child: _RailSegment(isCurrent: e.isCurrent, isLast: isLast),
        ),
      ],
    );
  }
}

/// One slice of the rail: base line, glowing fill driven by scroll, and the
/// node that lights up once the fill reaches it.
class _RailSegment extends StatefulWidget {
  const _RailSegment({required this.isCurrent, required this.isLast});

  final bool isCurrent;
  final bool isLast;

  @override
  State<_RailSegment> createState() => _RailSegmentState();
}

class _RailSegmentState extends State<_RailSegment> with ViewportAwareMixin {
  final _fill = ValueNotifier<double>(0);

  @override
  void onViewportChanged(double top, double bottom, double viewportHeight) {
    if (Motion.reduced(context)) {
      _fill.value = 1;
      return;
    }
    final h = bottom - top;
    if (h <= 0) return;
    _fill.value = ((viewportHeight * 0.65 - top) / h).clamp(0.0, 1.0);
  }

  @override
  void dispose() {
    _fill.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: _fill,
      builder:
          (context, f, _) => CustomPaint(
            painter: _RailPainter(
              fill: f,
              isCurrent: widget.isCurrent,
              isLast: widget.isLast,
            ),
          ),
    );
  }
}

class _RailPainter extends CustomPainter {
  _RailPainter({
    required this.fill,
    required this.isCurrent,
    required this.isLast,
  });

  final double fill;
  final bool isCurrent;
  final bool isLast;

  static const _nodeY = 34.0;

  @override
  void paint(Canvas canvas, Size size) {
    final x = size.width / 2;
    final end = isLast ? _nodeY : size.height;

    canvas.drawLine(
      Offset(x, 0),
      Offset(x, end),
      Paint()
        ..color = AppColors.border
        ..strokeWidth = 2,
    );

    final fillY = (size.height * fill).clamp(0.0, end);
    if (fillY > 0) {
      final rect = Rect.fromLTRB(x - 1, 0, x + 1, fillY);
      final glow =
          Paint()
            ..shader = const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.cyan, AppColors.violet],
            ).createShader(rect)
            ..strokeWidth = 2;
      canvas.drawLine(Offset(x, 0), Offset(x, fillY), glow);
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, fillY),
        Paint()
          ..color = AppColors.cyan.withValues(alpha: 0.12)
          ..strokeWidth = 6
          ..strokeCap = StrokeCap.round,
      );
    }

    final lit = fillY >= _nodeY - 2;
    final c = Offset(x, _nodeY);
    if (lit) {
      canvas.drawCircle(
        c,
        isCurrent ? 14 : 11,
        Paint()
          ..color = (isCurrent ? AppColors.green : AppColors.cyan).withValues(
            alpha: 0.15,
          ),
      );
    }
    canvas.drawCircle(c, 7, Paint()..color = AppColors.background);
    canvas.drawCircle(
      c,
      7,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color =
            lit
                ? (isCurrent ? AppColors.green : AppColors.cyan)
                : AppColors.borderStrong,
    );
    if (lit) {
      canvas.drawCircle(
        c,
        3,
        Paint()..color = isCurrent ? AppColors.green : AppColors.cyan,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _RailPainter old) =>
      old.fill != fill || old.isCurrent != isCurrent || old.isLast != isLast;
}

class _ExperienceCard extends StatelessWidget {
  const _ExperienceCard({
    required this.experience,
    required this.promoted,
    required this.expanded,
    required this.onToggle,
  });

  final Experience experience;
  final bool promoted;
  final bool expanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final e = experience;
    final mobile = Breakpoints.of(context) == ScreenSize.mobile;
    final projects =
        PortfolioData.projects
            .where((p) => e.relatedProjects.contains(p.title))
            .toList();
    final accent = e.isCurrent ? AppColors.green : AppColors.cyan;

    return Semantics(
      button: true,
      expanded: expanded,
      label: '${e.role} at ${e.company}, ${_period(e)}',
      child: TiltCard(
        maxTilt: 0.04,
        onTap: onToggle,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow:
                expanded
                    ? [
                      BoxShadow(
                        color: accent.withValues(alpha: 0.12),
                        blurRadius: 40,
                      ),
                    ]
                    : null,
          ),
          child: GlassPanel(
            padding: EdgeInsets.all(mobile ? 16 : 20),
            borderColor: expanded ? accent.withValues(alpha: 0.35) : null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.borderStrong),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(11),
                        child: Image.asset(
                          e.logoAsset,
                          width: mobile ? 42 : 48,
                          height: mobile ? 42 : 48,
                          fit: BoxFit.cover,
                          cacheWidth: 120,
                          semanticLabel: '${e.company} logo',
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            e.role,
                            style: AppText.title(mobile ? 15.5 : 17.5),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            e.company,
                            style: AppText.body(
                              13.5,
                              color: AppColors.textSecondary,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(_period(e), style: AppText.mono(11)),
                        ],
                      ),
                    ),
                    if (e.isCurrent && !mobile) ...[
                      const TagChip(
                        label: 'Current',
                        color: AppColors.green,
                        dense: true,
                      ),
                      const SizedBox(width: 10),
                    ],
                    AnimatedRotation(
                      turns: expanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 300),
                      child: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 380),
                  curve: Motion.emphasized,
                  alignment: Alignment.topCenter,
                  child:
                      expanded
                          ? Padding(
                            padding: const EdgeInsets.only(top: 18),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(height: 1, color: AppColors.border),
                                const SizedBox(height: 16),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    TagChip(
                                      label: _tenure(e),
                                      color: accent,
                                      dense: true,
                                      icon: Icon(
                                        Icons.schedule_rounded,
                                        size: 12,
                                        color: accent,
                                      ),
                                    ),
                                    if (e.isCurrent && mobile)
                                      const TagChip(
                                        label: 'Current',
                                        color: AppColors.green,
                                        dense: true,
                                      ),
                                    if (promoted)
                                      const TagChip(
                                        label: 'Promoted internally',
                                        color: AppColors.violet,
                                        dense: true,
                                        icon: Icon(
                                          Icons.trending_up_rounded,
                                          size: 12,
                                          color: AppColors.violet,
                                        ),
                                      ),
                                  ],
                                ),
                                if (e.highlights.isNotEmpty) ...[
                                  const SizedBox(height: 14),
                                  for (final h in e.highlights)
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 6),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              top: 7,
                                              right: 10,
                                            ),
                                            child: Container(
                                              width: 4,
                                              height: 4,
                                              color: accent,
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              h,
                                              style: AppText.body(14),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                                if (projects.isNotEmpty) ...[
                                  const SizedBox(height: 14),
                                  Text(
                                    projects.length > 1
                                        ? '// related apps'
                                        : '// related app',
                                    style: AppText.mono(11),
                                  ),
                                  const SizedBox(height: 8),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: [
                                      for (final p in projects)
                                        TagChip(
                                          label: '${p.title} · ${p.domain}',
                                          color: p.color,
                                          icon: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
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
                          )
                          : const SizedBox(width: double.infinity),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
