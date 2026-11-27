import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'motion.dart';
import 'page_scope.dart';

/// One object placed in a [Scene3D].
///
/// Coordinates are in logical pixels relative to the scene centre.
/// [depth] is positive toward the viewer.
class SceneNode {
  const SceneNode({
    required this.child,
    this.x = 0,
    this.y = 0,
    this.depth = 0,
    this.bob = 0,
    this.bobPhase = 0,
    this.spin = 0,
    this.thickness = 0,
    this.edge,
  });

  final Widget child;
  final double x;
  final double y;
  final double depth;

  /// Vertical floating amplitude in pixels.
  final double bob;
  final double bobPhase;

  /// Extra Y-rotation (radians) applied on top of the scene, oscillating.
  final double spin;

  /// For solid objects (devices): number of pixels of extruded depth and the
  /// widget used to paint each slice of the side wall.
  final double thickness;
  final Widget? edge;
}

/// A tiny real-time 3D stage built on [Transform] + [Matrix4].
///
/// Every node shares one perspective camera, so nodes at different depths
/// parallax naturally as the scene rotates. The scene slowly orbits on its
/// own, follows the mouse on desktop, and can be dragged horizontally on
/// touch screens. All motion stops when reduced motion is requested.
class Scene3D extends StatefulWidget {
  const Scene3D({
    super.key,
    required this.nodes,
    this.baseRotateX = -0.06,
    this.baseRotateY = -0.28,
    this.orbitAmplitude = 0.18,
    this.pointerInfluence = 0.22,
    this.period = const Duration(seconds: 14),
    this.perspective = 0.0011,
    this.draggable = true,
  });

  final List<SceneNode> nodes;
  final double baseRotateX;
  final double baseRotateY;
  final double orbitAmplitude;
  final double pointerInfluence;
  final Duration period;
  final double perspective;
  final bool draggable;

  @override
  State<Scene3D> createState() => _Scene3DState();
}

class _Scene3DState extends State<Scene3D> with SingleTickerProviderStateMixin {
  late final Ticker _ticker = createTicker(_tick);
  final ValueNotifier<int> _frame = ValueNotifier(0);
  Duration _elapsed = Duration.zero;
  Offset _smoothedPointer = Offset.zero;
  double _drag = 0;
  bool _reduced = false;
  ValueNotifier<Offset>? _pointer;

  late List<SceneNode> _sorted = _sortNodes();

  List<SceneNode> _sortNodes() =>
      [...widget.nodes]..sort((a, b) => a.depth.compareTo(b.depth));

  @override
  void didUpdateWidget(Scene3D oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.nodes != widget.nodes) _sorted = _sortNodes();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _pointer = PageScope.maybeOf(context)?.pointer;
    _reduced = Motion.reduced(context);
    if (_reduced) {
      if (_ticker.isActive) _ticker.stop();
      _frame.value++;
    } else if (!_ticker.isActive) {
      _ticker.start();
    }
  }

  void _tick(Duration elapsed) {
    _elapsed = elapsed;
    final target = _pointer?.value ?? Offset.zero;
    _smoothedPointer = Offset.lerp(_smoothedPointer, target, 0.06)!;
    _drag *= 0.97; // ease dragged rotation back to the resting pose
    _frame.value++;
  }

  @override
  void dispose() {
    _ticker.dispose();
    _frame.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget stage = AnimatedBuilder(
      animation: _frame,
      builder: (context, _) {
        final seconds = _elapsed.inMicroseconds / 1e6;
        final phase =
            _reduced
                ? 0.0
                : seconds / (widget.period.inMilliseconds / 1000) * 2 * math.pi;
        final ry =
            widget.baseRotateY +
            math.sin(phase) * widget.orbitAmplitude +
            _smoothedPointer.dx * widget.pointerInfluence +
            _drag;
        final rx =
            widget.baseRotateX +
            math.cos(phase * 0.5) * widget.orbitAmplitude * 0.25 -
            _smoothedPointer.dy * widget.pointerInfluence * 0.5;

        final children = <Widget>[];
        for (final node in _sorted) {
          final bobY =
              _reduced ? 0.0 : math.sin(phase * 2 + node.bobPhase) * node.bob;
          final nodeSpin =
              _reduced ? 0.0 : math.sin(phase + node.bobPhase) * node.spin;

          Matrix4 matrixAt(double extraDepth) =>
              Matrix4.identity()
                ..setEntry(3, 2, widget.perspective)
                ..rotateX(rx)
                ..rotateY(ry)
                ..translateByDouble(
                  node.x,
                  node.y + bobY,
                  -(node.depth + extraDepth),
                  1,
                )
                ..rotateY(nodeSpin);

          // Extruded side walls, back to front.
          if (node.thickness > 0 && node.edge != null) {
            const step = 1.5;
            final slices = (node.thickness / step).ceil();
            for (var i = slices; i >= 1; i--) {
              children.add(
                Center(
                  child: Transform(
                    transform: matrixAt(-i * step),
                    alignment: Alignment.center,
                    child: node.edge,
                  ),
                ),
              );
            }
          }
          children.add(
            Center(
              child: Transform(
                transform: matrixAt(0),
                alignment: Alignment.center,
                // Cache the node's drawing; only its transform changes
                // from frame to frame.
                child: RepaintBoundary(child: node.child),
              ),
            ),
          );
        }
        return Stack(clipBehavior: Clip.none, children: children);
      },
    );

    if (widget.draggable && !_reduced) {
      stage = GestureDetector(
        onHorizontalDragUpdate:
            (d) => _drag = (_drag + d.delta.dx * 0.008).clamp(-0.9, 0.9),
        child: stage,
      );
    }
    return RepaintBoundary(child: stage);
  }
}
