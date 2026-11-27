import 'dart:async';

import 'package:flutter/material.dart';

import '../core/motion.dart';
import '../data/models.dart';
import '../data/portfolio_data.dart';
import '../theme/app_theme.dart';
import '../widgets/section_header.dart';
import '../widgets/surfaces.dart';

class ProcessSection extends StatelessWidget {
  const ProcessSection({super.key});

  @override
  Widget build(BuildContext context) {
    final size = Breakpoints.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          index: '05',
          eyebrow: 'How I Build',
          title: 'Engineering mindset,\nnot just code.',
          lede:
              'Every app follows the same disciplined path — from understanding '
              'the problem to keeping it healthy in production.',
        ),
        SizedBox(height: size == ScreenSize.mobile ? 28 : 48),
        const Reveal(child: _Pipeline()),
        SizedBox(height: size == ScreenSize.mobile ? 56 : 88),
        const _ArchitectureBlock(),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// Lifecycle pipeline
// -----------------------------------------------------------------------------

class _Pipeline extends StatefulWidget {
  const _Pipeline();

  @override
  State<_Pipeline> createState() => _PipelineState();
}

class _PipelineState extends State<_Pipeline>
    with SingleTickerProviderStateMixin {
  static const _steps = PortfolioData.process;
  int _active = 0;
  Timer? _auto;
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (Motion.reduced(context)) {
      _auto?.cancel();
      _pulse.stop();
    } else {
      _auto ??= Timer.periodic(const Duration(milliseconds: 3600), (_) {
        if (mounted) setState(() => _active = (_active + 1) % _steps.length);
      });
      if (!_pulse.isAnimating) _pulse.repeat();
    }
  }

  void _select(int i) {
    _auto?.cancel(); // the visitor has taken control
    setState(() => _active = i);
  }

  @override
  void dispose() {
    _auto?.cancel();
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mobile = Breakpoints.of(context) == ScreenSize.mobile;
    return ViewportTickerGate(child: mobile ? _vertical() : _horizontal());
  }

  Widget _horizontal() {
    final step = _steps[_active];
    return Column(
      children: [
        SizedBox(
          height: 112,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                right: 0,
                top: 28,
                height: 2,
                child: AnimatedBuilder(
                  animation: _pulse,
                  builder:
                      (context, _) => CustomPaint(
                        painter: _LinePainter(
                          progress: _active / (_steps.length - 1),
                          pulse: _pulse.value,
                          inset: 1 / (_steps.length * 2),
                        ),
                      ),
                ),
              ),
              Row(
                children: [
                  for (var i = 0; i < _steps.length; i++)
                    Expanded(
                      child: _StepNode(
                        step: _steps[i],
                        index: i,
                        active: i == _active,
                        done: i < _active,
                        onTap: () => _select(i),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _StepPanel(step: step, index: _active),
      ],
    );
  }

  Widget _vertical() {
    return Column(
      children: [
        for (var i = 0; i < _steps.length; i++)
          _VerticalStep(
            step: _steps[i],
            index: i,
            active: i == _active,
            done: i < _active,
            isLast: i == _steps.length - 1,
            onTap: () => _select(i),
          ),
      ],
    );
  }
}

class _LinePainter extends CustomPainter {
  _LinePainter({
    required this.progress,
    required this.pulse,
    required this.inset,
  });

  final double progress;
  final double pulse;
  final double inset;

  @override
  void paint(Canvas canvas, Size size) {
    final x0 = size.width * inset;
    final x1 = size.width * (1 - inset);
    final y = size.height / 2;
    canvas.drawLine(
      Offset(x0, y),
      Offset(x1, y),
      Paint()
        ..color = AppColors.border
        ..strokeWidth = 2,
    );
    final xp = x0 + (x1 - x0) * progress;
    if (xp > x0) {
      canvas.drawLine(
        Offset(x0, y),
        Offset(xp, y),
        Paint()
          ..strokeWidth = 2
          ..shader = const LinearGradient(
            colors: [AppColors.cyan, AppColors.violet],
          ).createShader(Rect.fromLTRB(x0, 0, x1, size.height)),
      );
      // Data packet travelling along the completed path.
      final px = x0 + (xp - x0) * pulse;
      canvas.drawCircle(
        Offset(px, y),
        6,
        Paint()
          ..color = AppColors.cyan.withValues(alpha: 0.35)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
      );
      canvas.drawCircle(Offset(px, y), 2.5, Paint()..color = Colors.white);
    }
  }

  @override
  bool shouldRepaint(covariant _LinePainter old) =>
      old.progress != progress || old.pulse != pulse;
}

class _StepNode extends StatefulWidget {
  const _StepNode({
    required this.step,
    required this.index,
    required this.active,
    required this.done,
    required this.onTap,
  });

  final ProcessStep step;
  final int index;
  final bool active;
  final bool done;
  final VoidCallback onTap;

  @override
  State<_StepNode> createState() => _StepNodeState();
}

class _StepNodeState extends State<_StepNode> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final lit = widget.active || widget.done;
    return Semantics(
      button: true,
      selected: widget.active,
      label: 'Step ${widget.index + 1}: ${widget.step.title}',
      excludeSemantics: true,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onTap,
          child: Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 350),
                curve: Motion.emphasized,
                width: 56,
                height: 56,
                transform: Matrix4.translationValues(
                  0,
                  widget.active ? -4 : 0,
                  0,
                ),
                transformAlignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      widget.active
                          ? Color.alphaBlend(
                            AppColors.cyan.withValues(alpha: 0.16),
                            AppColors.surface,
                          )
                          : AppColors.surface,
                  border: Border.all(
                    color:
                        widget.active
                            ? AppColors.cyan
                            : lit || _hover
                            ? AppColors.cyan.withValues(alpha: 0.4)
                            : AppColors.borderStrong,
                    width: widget.active ? 1.6 : 1,
                  ),
                  boxShadow:
                      widget.active
                          ? [
                            BoxShadow(
                              color: AppColors.cyan.withValues(alpha: 0.4),
                              blurRadius: 24,
                            ),
                          ]
                          : null,
                ),
                child: Icon(
                  widget.step.icon,
                  size: 22,
                  color:
                      widget.active
                          ? AppColors.cyan
                          : lit
                          ? AppColors.textPrimary
                          : AppColors.textTertiary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '0${widget.index + 1}',
                style: AppText.mono(
                  10,
                  color:
                      widget.active ? AppColors.cyan : AppColors.textTertiary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                widget.step.title,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.body(
                  13,
                  weight: FontWeight.w600,
                  height: 1.2,
                  color:
                      widget.active
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepPanel extends StatelessWidget {
  const _StepPanel({required this.step, required this.index});

  final ProcessStep step;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 380),
          transitionBuilder:
              (child, anim) => FadeTransition(
                opacity: anim,
                child: ScaleTransition(
                  scale: Tween(begin: 0.97, end: 1.0).animate(anim),
                  child: child,
                ),
              ),
          child: GlassPanel(
            key: ValueKey(index),
            glow: AppColors.cyan,
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 22),
            child: Semantics(
              liveRegion: true,
              child: Row(
                children: [
                  Icon(step.icon, color: AppColors.cyan, size: 28),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(step.title, style: AppText.title(19)),
                        const SizedBox(height: 4),
                        Text(step.summary, style: AppText.body(15)),
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
  }
}

class _VerticalStep extends StatelessWidget {
  const _VerticalStep({
    required this.step,
    required this.index,
    required this.active,
    required this.done,
    required this.isLast,
    required this.onTap,
  });

  final ProcessStep step;
  final int index;
  final bool active;
  final bool done;
  final bool isLast;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final lit = active || done;
    return Semantics(
      button: true,
      selected: active,
      label: 'Step ${index + 1}: ${step.title}. ${step.summary}',
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: 44,
                child: Column(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.surface,
                        border: Border.all(
                          color:
                              active
                                  ? AppColors.cyan
                                  : lit
                                  ? AppColors.cyan.withValues(alpha: 0.4)
                                  : AppColors.borderStrong,
                        ),
                        boxShadow:
                            active
                                ? [
                                  BoxShadow(
                                    color: AppColors.cyan.withValues(
                                      alpha: 0.4,
                                    ),
                                    blurRadius: 18,
                                  ),
                                ]
                                : null,
                      ),
                      child: Icon(
                        step.icon,
                        size: 18,
                        color: lit ? AppColors.cyan : AppColors.textTertiary,
                      ),
                    ),
                    if (!isLast)
                      Expanded(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: 2,
                          color:
                              done
                                  ? AppColors.cyan.withValues(alpha: 0.6)
                                  : AppColors.border,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: isLast ? 0 : 18, top: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '0${index + 1}  ${step.title}',
                        style: AppText.title(
                          16,
                          color:
                              active
                                  ? AppColors.textPrimary
                                  : AppColors.textSecondary,
                        ),
                      ),
                      AnimatedSize(
                        duration: const Duration(milliseconds: 320),
                        curve: Motion.emphasized,
                        child:
                            active
                                ? Padding(
                                  padding: const EdgeInsets.only(top: 6),
                                  child: Text(
                                    step.summary,
                                    style: AppText.body(14.5),
                                  ),
                                )
                                : const SizedBox(width: double.infinity),
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

// -----------------------------------------------------------------------------
// Isometric architecture stack
// -----------------------------------------------------------------------------

class _ArchitectureBlock extends StatefulWidget {
  const _ArchitectureBlock();

  @override
  State<_ArchitectureBlock> createState() => _ArchitectureBlockState();
}

class _ArchitectureBlockState extends State<_ArchitectureBlock> {
  int _focus = 0;

  @override
  Widget build(BuildContext context) {
    final desktop = Breakpoints.of(context) == ScreenSize.desktop;
    final mobile = Breakpoints.of(context) == ScreenSize.mobile;
    final stack = Reveal(
      scale: 0.92,
      child: _IsoStack(
        focus: _focus,
        onFocus: (i) => setState(() => _focus = i),
        compact: mobile,
      ),
    );
    final legend = _Legend(
      focus: _focus,
      onFocus: (i) => setState(() => _focus = i),
    );

    final content =
        desktop
            ? Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(flex: 10, child: stack),
                const SizedBox(width: 48),
                Expanded(flex: 11, child: legend),
              ],
            )
            : Column(children: [stack, const SizedBox(height: 24), legend]);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Reveal(
          child: Text(
            '// app architecture',
            style: AppText.mono(13, color: AppColors.cyan),
          ),
        ),
        const SizedBox(height: 10),
        Reveal(
          child: Text(
            'Clear layers. Predictable data flow.',
            style: AppText.title(mobile ? 24 : 32),
          ),
        ),
        SizedBox(height: mobile ? 16 : 32),
        content,
      ],
    );
  }
}

class _IsoStack extends StatefulWidget {
  const _IsoStack({
    required this.focus,
    required this.onFocus,
    required this.compact,
  });

  final int focus;
  final ValueChanged<int> onFocus;
  final bool compact;

  @override
  State<_IsoStack> createState() => _IsoStackState();
}

class _IsoStackState extends State<_IsoStack>
    with SingleTickerProviderStateMixin {
  late final AnimationController _flow = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2400),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (Motion.reduced(context)) {
      _flow.stop();
    } else if (!_flow.isAnimating) {
      _flow.repeat();
    }
  }

  @override
  void dispose() {
    _flow.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final layers = PortfolioData.architecture;
    final slab = widget.compact ? 170.0 : 230.0;
    final gap = widget.compact ? 66.0 : 88.0;
    final height = slab * 0.9 + gap * (layers.length - 1) + 40;

    final iso =
        Matrix4.identity()
          ..setEntry(3, 2, 0.0008)
          ..rotateX(0.96)
          ..rotateZ(-0.72);

    return ViewportTickerGate(
      child: SizedBox(
        height: height,
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            // Bottom layer is painted first.
            for (var i = layers.length - 1; i >= 0; i--)
              AnimatedPositioned(
                duration: const Duration(milliseconds: 400),
                curve: Motion.emphasized,
                top: i * gap + (widget.focus == i ? -12 : 0),
                child: Semantics(
                  button: true,
                  selected: widget.focus == i,
                  label: '${layers[i].label}: ${layers[i].detail}',
                  excludeSemantics: true,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    onEnter: (_) => widget.onFocus(i),
                    child: GestureDetector(
                      onTap: () => widget.onFocus(i),
                      child: Transform(
                        transform: iso,
                        alignment: Alignment.center,
                        child: _Slab(
                          size: slab,
                          layer: layers[i],
                          focused: widget.focus == i,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            // Data packets flowing between layers.
            IgnorePointer(
              child: AnimatedBuilder(
                animation: _flow,
                builder:
                    (context, _) => CustomPaint(
                      size: Size(slab, height),
                      painter: _FlowPainter(
                        t: _flow.value,
                        gap: gap,
                        count: layers.length,
                        top: slab * 0.33,
                      ),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Slab extends StatelessWidget {
  const _Slab({required this.size, required this.layer, required this.focused});

  final double size;
  final ArchitectureLayer layer;
  final bool focused;

  @override
  Widget build(BuildContext context) {
    final c = layer.color;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.1),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.alphaBlend(
              c.withValues(alpha: focused ? 0.32 : 0.14),
              AppColors.surface,
            ),
            Color.alphaBlend(
              c.withValues(alpha: focused ? 0.12 : 0.04),
              AppColors.background,
            ),
          ],
        ),
        border: Border.all(
          color: c.withValues(alpha: focused ? 0.95 : 0.4),
          width: focused ? 2 : 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: c.withValues(alpha: focused ? 0.45 : 0.12),
            blurRadius: focused ? 50 : 24,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Grid texture
          Positioned.fill(child: CustomPaint(painter: _GridPainter(c))),
          Padding(
            padding: EdgeInsets.all(size * 0.09),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                layer.label,
                style: AppText.title(
                  size * 0.085,
                  color: focused ? AppColors.textPrimary : c,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  _GridPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final p =
        Paint()
          ..color = color.withValues(alpha: 0.12)
          ..strokeWidth = 1;
    final step = size.width / 8;
    for (var i = 1; i < 8; i++) {
      canvas.drawLine(Offset(i * step, 0), Offset(i * step, size.height), p);
      canvas.drawLine(Offset(0, i * step), Offset(size.width, i * step), p);
    }
  }

  @override
  bool shouldRepaint(covariant _GridPainter old) => old.color != color;
}

class _FlowPainter extends CustomPainter {
  _FlowPainter({
    required this.t,
    required this.gap,
    required this.count,
    required this.top,
  });

  final double t;
  final double gap;
  final int count;
  final double top;

  @override
  void paint(Canvas canvas, Size size) {
    final x = size.width / 2;
    final y0 = top + 20;
    final y1 = top + 20 + gap * (count - 1) + size.width * 0.1;
    final line =
        Paint()
          ..color = AppColors.cyan.withValues(alpha: 0.25)
          ..strokeWidth = 1.2;
    // Dashed spine.
    for (double y = y0; y < y1; y += 8) {
      canvas.drawLine(Offset(x, y), Offset(x, y + 4), line);
    }
    for (var k = 0; k < 3; k++) {
      final f = (t + k / 3) % 1.0;
      // Requests travel down, responses travel back up.
      final down = Offset(x - 6, y0 + (y1 - y0) * f);
      final up = Offset(x + 6, y1 - (y1 - y0) * f);
      for (final (o, c) in [(down, AppColors.cyan), (up, AppColors.violet)]) {
        canvas.drawCircle(
          o,
          6,
          Paint()
            ..color = c.withValues(alpha: 0.35)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
        );
        canvas.drawCircle(o, 2.4, Paint()..color = c);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _FlowPainter old) => old.t != t;
}

class _Legend extends StatelessWidget {
  const _Legend({required this.focus, required this.onFocus});

  final int focus;
  final ValueChanged<int> onFocus;

  @override
  Widget build(BuildContext context) {
    final layers = PortfolioData.architecture;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < layers.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Reveal(
              delay: Duration(milliseconds: 80 * i),
              child: Semantics(
                button: true,
                selected: focus == i,
                label: layers[i].label,
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  onEnter: (_) => onFocus(i),
                  child: GestureDetector(
                    onTap: () => onFocus(i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color:
                            focus == i
                                ? layers[i].color.withValues(alpha: 0.08)
                                : Colors.white.withValues(alpha: 0.02),
                        border: Border.all(
                          color:
                              focus == i
                                  ? layers[i].color.withValues(alpha: 0.5)
                                  : AppColors.border,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              color: layers[i].color,
                              boxShadow: [
                                BoxShadow(
                                  color: layers[i].color.withValues(alpha: 0.6),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  layers[i].label,
                                  style: AppText.title(15.5),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  layers[i].detail,
                                  style: AppText.body(13.5, height: 1.45),
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
            ),
          ),
        const SizedBox(height: 14),
        Text('// cross-cutting services', style: AppText.mono(12)),
        const SizedBox(height: 10),
        LayoutBuilder(
          builder: (context, c) {
            final cols = c.maxWidth > 420 ? 2 : 1;
            final w = (c.maxWidth - (cols - 1) * 10) / cols;
            return Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (var i = 0; i < PortfolioData.services.length; i++)
                  SizedBox(
                    width: w,
                    child: Reveal(
                      delay: Duration(milliseconds: 60 * i),
                      child: TiltCard(
                        maxTilt: 0.08,
                        borderRadius: 14,
                        child: GlassPanel(
                          radius: 14,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          child: Row(
                            children: [
                              StatusDot(
                                color: PortfolioData.services[i].color,
                                size: 6,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      PortfolioData.services[i].label,
                                      style: AppText.title(13.5),
                                    ),
                                    Text(
                                      PortfolioData.services[i].detail,
                                      style: AppText.mono(10.5),
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
              ],
            );
          },
        ),
      ],
    );
  }
}
