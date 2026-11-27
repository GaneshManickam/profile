import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Dark translucent card with a hairline border and optional accent glow.
class GlassPanel extends StatelessWidget {
  const GlassPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24),
    this.radius = 20,
    this.glow,
    this.borderColor,
    this.color,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final Color? glow;
  final Color? borderColor;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: color ?? AppColors.surface.withValues(alpha: 0.72),
        gradient:
            color == null
                ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withValues(alpha: 0.045),
                    Colors.white.withValues(alpha: 0.015),
                  ],
                )
                : null,
        border: Border.all(color: borderColor ?? AppColors.border),
        boxShadow: [
          if (glow != null)
            BoxShadow(
              color: glow!.withValues(alpha: 0.18),
              blurRadius: 40,
              spreadRadius: -8,
            ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 30,
            offset: const Offset(0, 16),
            spreadRadius: -12,
          ),
        ],
      ),
      child: child,
    );
  }
}

/// Text painted with the cyan → violet accent gradient.
class GradientText extends StatelessWidget {
  const GradientText(
    this.text, {
    super.key,
    required this.style,
    this.textAlign,
    this.gradient = AppColors.accentGradient,
  });

  final String text;
  final TextStyle style;
  final TextAlign? textAlign;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback:
          (bounds) => gradient.createShader(
            Rect.fromLTWH(0, 0, bounds.width, bounds.height),
          ),
      child: Text(text, style: style, textAlign: textAlign),
    );
  }
}

/// Small mono-spaced chip used for tags and metadata.
class TagChip extends StatelessWidget {
  const TagChip({
    super.key,
    required this.label,
    this.color = AppColors.textSecondary,
    this.icon,
    this.selected = false,
    this.dense = false,
  });

  final String label;
  final Color color;
  final Widget? icon;
  final bool selected;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      padding: EdgeInsets.symmetric(
        horizontal: dense ? 8 : 12,
        vertical: dense ? 4 : 7,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: color.withValues(alpha: selected ? 0.18 : 0.06),
        border: Border.all(
          color: color.withValues(alpha: selected ? 0.7 : 0.22),
        ),
        boxShadow:
            selected
                ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.25),
                    blurRadius: 18,
                  ),
                ]
                : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[icon!, const SizedBox(width: 6)],
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.mono(
                dense ? 10.5 : 12,
                color: selected ? AppColors.textPrimary : color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Pulsing status dot.
class StatusDot extends StatefulWidget {
  const StatusDot({super.key, this.color = AppColors.green, this.size = 8});

  final Color color;
  final double size;

  @override
  State<StatusDot> createState() => _StatusDotState();
}

class _StatusDotState extends State<StatusDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.maybeDisableAnimationsOf(context) ?? false) {
      _c.value = 0.5;
    } else if (!_c.isAnimating) {
      _c.repeat();
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.size;
    return SizedBox(
      width: s * 2.4,
      height: s * 2.4,
      child: AnimatedBuilder(
        animation: _c,
        builder:
            (context, _) => Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: s + s * 1.4 * _c.value,
                  height: s + s * 1.4 * _c.value,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.color.withValues(
                      alpha: 0.35 * (1 - _c.value),
                    ),
                  ),
                ),
                Container(
                  width: s,
                  height: s,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.color,
                  ),
                ),
              ],
            ),
      ),
    );
  }
}
