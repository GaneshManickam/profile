import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Motion helpers shared by every section.
class Motion {
  Motion._();

  /// Honour the OS "reduce motion" preference (maps to
  /// `prefers-reduced-motion` on the web).
  static bool reduced(BuildContext context) =>
      MediaQuery.maybeDisableAnimationsOf(context) ?? false;

  static const emphasized = Cubic(0.2, 0.0, 0.0, 1.0);
}

/// Mixin that watches the nearest [Scrollable] and reports how this widget
/// intersects the viewport. Used for scroll reveals and to pause off-screen
/// animations.
mixin ViewportAwareMixin<T extends StatefulWidget> on State<T> {
  ScrollPosition? _position;
  double _viewportHeight = 0;

  /// Called whenever the scroll position or layout may have changed.
  void onViewportChanged(double top, double bottom, double viewportHeight);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _viewportHeight = MediaQuery.sizeOf(context).height;
    final pos = Scrollable.maybeOf(context)?.position;
    if (pos != _position) {
      _position?.removeListener(_handleScroll);
      _position = pos;
      _position?.addListener(_handleScroll);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _handleScroll());
  }

  void stopWatchingViewport() {
    _position?.removeListener(_handleScroll);
    _position = null;
  }

  void _handleScroll() {
    if (!mounted) return;
    final ro = context.findRenderObject();
    if (ro is! RenderBox || !ro.attached || !ro.hasSize) return;
    final top = ro.localToGlobal(Offset.zero).dy;
    onViewportChanged(top, top + ro.size.height, _viewportHeight);
  }

  @override
  void dispose() {
    _position?.removeListener(_handleScroll);
    super.dispose();
  }
}

/// Fades and lifts its child into place the first time it scrolls into view.
class Reveal extends StatefulWidget {
  const Reveal({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.offset = const Offset(0, 28),
    this.duration = const Duration(milliseconds: 800),
    this.scale = 1.0,
  });

  final Widget child;
  final Duration delay;
  final Offset offset;
  final Duration duration;

  /// Starting scale (e.g. 0.96 for a subtle zoom-in).
  final double scale;

  @override
  State<Reveal> createState() => _RevealState();
}

class _RevealState extends State<Reveal>
    with SingleTickerProviderStateMixin, ViewportAwareMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  );
  late final Animation<double> _curve = CurvedAnimation(
    parent: _controller,
    curve: Motion.emphasized,
  );
  bool _triggered = false;
  Timer? _timer;

  @override
  void didChangeDependencies() {
    if (Motion.reduced(context) && !_triggered) {
      _triggered = true;
      _controller.value = 1;
    }
    super.didChangeDependencies();
    if (_triggered) stopWatchingViewport();
  }

  @override
  void onViewportChanged(double top, double bottom, double viewportHeight) {
    if (_triggered) return;
    if (top < viewportHeight * 0.92 && bottom > 0) {
      _triggered = true;
      stopWatchingViewport();
      _timer = Timer(widget.delay, () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _curve,
      child: widget.child,
      builder: (context, child) {
        final t = _curve.value;
        final s = widget.scale + (1 - widget.scale) * t;
        return Opacity(
          opacity: t.clamp(0.0, 1.0),
          child: Transform(
            transform: Matrix4.translationValues(
              widget.offset.dx * (1 - t),
              widget.offset.dy * (1 - t),
              0,
            )..scaleByDouble(s, s, 1, 1),
            alignment: Alignment.center,
            child: child,
          ),
        );
      },
    );
  }
}

/// Disables every ticker below it while it is off-screen, so looping
/// animations cost nothing when they cannot be seen.
class ViewportTickerGate extends StatefulWidget {
  const ViewportTickerGate({super.key, required this.child, this.margin = 200});

  final Widget child;
  final double margin;

  @override
  State<ViewportTickerGate> createState() => _ViewportTickerGateState();
}

class _ViewportTickerGateState extends State<ViewportTickerGate>
    with ViewportAwareMixin {
  bool _visible = true;

  @override
  void onViewportChanged(double top, double bottom, double viewportHeight) {
    final visible =
        bottom > -widget.margin && top < viewportHeight + widget.margin;
    if (visible != _visible) setState(() => _visible = visible);
  }

  @override
  Widget build(BuildContext context) =>
      TickerMode(enabled: _visible, child: widget.child);
}

/// Gentle, endless vertical bobbing.
class Floating extends StatefulWidget {
  const Floating({
    super.key,
    required this.child,
    this.amplitude = 8,
    this.period = const Duration(seconds: 6),
    this.phase = 0,
  });

  final Widget child;
  final double amplitude;
  final Duration period;
  final double phase;

  @override
  State<Floating> createState() => _FloatingState();
}

class _FloatingState extends State<Floating>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.period,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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
    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (context, child) {
        final dy =
            math.sin(_controller.value * 2 * math.pi + widget.phase) *
            widget.amplitude;
        return Transform.translate(offset: Offset(0, dy), child: child);
      },
    );
  }
}

/// Card that tilts toward the pointer in 3D with a soft moving glare.
/// On touch devices it tilts briefly toward the finger on press, so the
/// interaction never depends on hover.
class TiltCard extends StatefulWidget {
  const TiltCard({
    super.key,
    required this.child,
    this.maxTilt = 0.12,
    this.borderRadius = 20,
    this.glare = true,
    this.onTap,
  });

  final Widget child;
  final double maxTilt;
  final double borderRadius;
  final bool glare;
  final VoidCallback? onTap;

  @override
  State<TiltCard> createState() => _TiltCardState();
}

class _TiltCardState extends State<TiltCard> {
  Offset _tilt = Offset.zero; // normalised [-1, 1]
  bool _active = false;

  void _update(Offset local) {
    if (Motion.reduced(context)) return;
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;
    final size = box.size;
    setState(() {
      _active = true;
      _tilt = Offset(
        (local.dx / size.width) * 2 - 1,
        (local.dy / size.height) * 2 - 1,
      );
    });
  }

  void _reset() => setState(() {
    _active = false;
    _tilt = Offset.zero;
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor:
          widget.onTap != null ? SystemMouseCursors.click : MouseCursor.defer,
      onHover: (e) => _update(e.localPosition),
      onExit: (_) => _reset(),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (d) => _update(d.localPosition),
        onTapUp: (_) => _reset(),
        onTapCancel: _reset,
        onTap: widget.onTap,
        child: TweenAnimationBuilder<Offset>(
          tween: Tween(end: _tilt),
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          builder: (context, t, child) {
            final m =
                Matrix4.identity()
                  ..setEntry(3, 2, 0.0012)
                  ..rotateX(-t.dy * widget.maxTilt)
                  ..rotateY(t.dx * widget.maxTilt);
            return Transform(
              transform: m,
              alignment: Alignment.center,
              child: Stack(
                children: [
                  child!,
                  if (widget.glare)
                    Positioned.fill(
                      child: IgnorePointer(
                        child: AnimatedOpacity(
                          opacity: _active ? 1 : 0,
                          duration: const Duration(milliseconds: 250),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                widget.borderRadius,
                              ),
                              gradient: RadialGradient(
                                center: Alignment(t.dx, t.dy),
                                radius: 1.1,
                                colors: [
                                  Colors.white.withValues(alpha: 0.07),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
          child: widget.child,
        ),
      ),
    );
  }
}
