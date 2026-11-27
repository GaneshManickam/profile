import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';

import '../theme/app_theme.dart';

/// Opens [url] in a new tab, failing quietly with a snackbar instead of
/// throwing.
Future<void> openExternal(BuildContext context, String url) async {
  final messenger = ScaffoldMessenger.maybeOf(context);
  try {
    final ok = await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
      webOnlyWindowName: '_blank',
    );
    if (!ok) throw Exception('launch failed');
  } catch (_) {
    messenger?.showSnackBar(SnackBar(content: Text('Could not open $url')));
  }
}

enum AppButtonStyle { primary, ghost }

/// Minimal premium button. Pass [url] to render a real link (so browsers can
/// open it in a new tab and screen readers announce it as a link), or
/// [onPressed] for in-page actions.
class AppButton extends StatefulWidget {
  const AppButton({
    super.key,
    required this.label,
    this.icon,
    this.url,
    this.onPressed,
    this.style = AppButtonStyle.primary,
    this.compact = false,
  }) : assert(url != null || onPressed != null);

  final String label;
  final IconData? icon;
  final String? url;
  final VoidCallback? onPressed;
  final AppButtonStyle style;
  final bool compact;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _hover = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final primary = widget.style == AppButtonStyle.primary;
    final h = widget.compact ? 40.0 : 52.0;

    Widget body(VoidCallback? onTap) => Semantics(
      button: widget.url == null,
      link: widget.url != null,
      label: widget.label,
      excludeSemantics: true,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: GestureDetector(
          onTapDown: (_) => setState(() => _pressed = true),
          onTapUp: (_) => setState(() => _pressed = false),
          onTapCancel: () => setState(() => _pressed = false),
          onTap: onTap,
          child: AnimatedScale(
            scale: _pressed ? 0.97 : 1,
            duration: const Duration(milliseconds: 140),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOut,
              height: h,
              padding: EdgeInsets.symmetric(
                horizontal: widget.compact ? 16 : 24,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                color:
                    primary
                        ? (_hover
                            ? AppColors.textPrimary
                            : AppColors.textPrimary.withValues(alpha: 0.94))
                        : (_hover
                            ? Colors.white.withValues(alpha: 0.08)
                            : Colors.white.withValues(alpha: 0.03)),
                border: Border.all(
                  color:
                      primary
                          ? Colors.transparent
                          : (_hover
                              ? AppColors.cyan.withValues(alpha: 0.5)
                              : AppColors.borderStrong),
                ),
                boxShadow: [
                  if (primary)
                    BoxShadow(
                      color: AppColors.cyan.withValues(
                        alpha: _hover ? 0.45 : 0.22,
                      ),
                      blurRadius: _hover ? 36 : 24,
                      spreadRadius: -6,
                    ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      widget.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.body(
                        widget.compact ? 13.5 : 15,
                        weight: FontWeight.w600,
                        height: 1,
                        color:
                            primary
                                ? AppColors.background
                                : AppColors.textPrimary,
                      ),
                    ),
                  ),
                  if (widget.icon != null) ...[
                    AnimatedPadding(
                      duration: const Duration(milliseconds: 220),
                      padding: EdgeInsets.only(left: _hover ? 14 : 10),
                      child: Icon(
                        widget.icon,
                        size: widget.compact ? 16 : 18,
                        color:
                            primary
                                ? AppColors.background
                                : AppColors.textPrimary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );

    if (widget.url != null) {
      return Link(
        uri: Uri.parse(widget.url!),
        target: LinkTarget.blank,
        builder: (context, followLink) => body(followLink),
      );
    }
    return body(widget.onPressed);
  }
}

/// Round icon button used for social links and carousel arrows.
class IconCircleButton extends StatefulWidget {
  const IconCircleButton({
    super.key,
    required this.icon,
    required this.tooltip,
    this.url,
    this.onPressed,
    this.size = 44,
    this.accent = AppColors.cyan,
  });

  final Widget icon;
  final String tooltip;
  final String? url;
  final VoidCallback? onPressed;
  final double size;
  final Color accent;

  @override
  State<IconCircleButton> createState() => _IconCircleButtonState();
}

class _IconCircleButtonState extends State<IconCircleButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    Widget body(VoidCallback? onTap) => Tooltip(
      message: widget.tooltip,
      child: Semantics(
        label: widget.tooltip,
        button: widget.url == null,
        link: widget.url != null,
        excludeSemantics: true,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => _hover = true),
          onExit: (_) => setState(() => _hover = false),
          child: GestureDetector(
            onTap: onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: widget.size,
              height: widget.size,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: _hover ? 0.08 : 0.03),
                border: Border.all(
                  color:
                      _hover
                          ? widget.accent.withValues(alpha: 0.6)
                          : AppColors.borderStrong,
                ),
                boxShadow:
                    _hover
                        ? [
                          BoxShadow(
                            color: widget.accent.withValues(alpha: 0.3),
                            blurRadius: 20,
                          ),
                        ]
                        : null,
              ),
              child: IconTheme(
                data: IconThemeData(
                  color:
                      _hover ? AppColors.textPrimary : AppColors.textSecondary,
                  size: widget.size * 0.42,
                ),
                child: widget.icon,
              ),
            ),
          ),
        ),
      ),
    );

    if (widget.url != null) {
      return Link(
        uri: Uri.parse(widget.url!),
        target: LinkTarget.blank,
        builder: (context, followLink) => body(followLink),
      );
    }
    return body(widget.onPressed);
  }
}
