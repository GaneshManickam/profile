import 'dart:ui';

import 'package:flutter/material.dart';

import '../core/motion.dart';
import '../core/page_scope.dart';
import '../data/portfolio_data.dart';
import '../theme/app_theme.dart';
import 'buttons.dart';

/// Floating glass navigation pill with a scroll-progress hairline.
class NavBar extends StatelessWidget {
  const NavBar({super.key});

  static const _links = [
    SectionId.about,
    SectionId.skills,
    SectionId.experience,
    SectionId.projects,
    SectionId.process,
  ];

  @override
  Widget build(BuildContext context) {
    final scope = PageScope.of(context);
    final size = Breakpoints.of(context);
    final compact = size != ScreenSize.desktop;
    final reduce = Motion.reduced(context);

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          compact ? 12 : 24,
          compact ? 10 : 16,
          compact ? 12 : 24,
          0,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: Breakpoints.maxContentWidth,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                child: Container(
                  height: compact ? 54 : 60,
                  decoration: BoxDecoration(
                    color: AppColors.background.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: Row(
                          children: [
                            _Brand(
                              onTap:
                                  () => scope.scrollTo(
                                    SectionId.home,
                                    reduceMotion: reduce,
                                  ),
                            ),
                            const Spacer(),
                            if (!compact)
                              for (final id in _links)
                                _NavLink(
                                  label: id.label,
                                  onTap:
                                      () => scope.scrollTo(
                                        id,
                                        reduceMotion: reduce,
                                      ),
                                ),
                            const SizedBox(width: 8),
                            if (size != ScreenSize.mobile)
                              AppButton(
                                label: "Let's talk",
                                compact: true,
                                icon: Icons.arrow_forward_rounded,
                                onPressed:
                                    () => scope.scrollTo(
                                      SectionId.contact,
                                      reduceMotion: reduce,
                                    ),
                              ),
                            if (compact) ...[
                              const SizedBox(width: 6),
                              IconCircleButton(
                                icon: const Icon(Icons.menu_rounded),
                                tooltip: 'Open menu',
                                size: 40,
                                onPressed:
                                    () => _openMenu(context, scope, reduce),
                              ),
                            ],
                          ],
                        ),
                      ),
                      Positioned(
                        left: 24,
                        right: 24,
                        bottom: 0,
                        child: _ScrollProgress(
                          controller: scope.scrollController,
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
    );
  }

  void _openMenu(BuildContext context, PageScope scope, bool reduce) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      barrierColor: Colors.black54,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder:
          (sheetContext) => SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: AppColors.borderStrong,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  for (final id in [..._links, SectionId.contact])
                    InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () {
                        Navigator.of(sheetContext).pop();
                        scope.scrollTo(id, reduceMotion: reduce);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 8,
                        ),
                        child: Row(
                          children: [
                            Text(
                              '0${SectionId.values.indexOf(id)}',
                              style: AppText.mono(12, color: AppColors.cyan),
                            ),
                            const SizedBox(width: 16),
                            Text(id.label, style: AppText.title(20)),
                            const Spacer(),
                            const Icon(
                              Icons.arrow_forward_rounded,
                              size: 18,
                              color: AppColors.textTertiary,
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

class _Brand extends StatelessWidget {
  const _Brand({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final profile = PortfolioData.profile;
    final initials = profile.name.split(' ').map((p) => p[0]).take(2).join();
    return Semantics(
      button: true,
      label: '${profile.name}, back to top',
      excludeSemantics: true,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColors.accentGradient,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.cyan.withValues(alpha: 0.35),
                      blurRadius: 16,
                    ),
                  ],
                ),
                child: Text(
                  initials,
                  style: AppText.title(
                    14,
                    color: AppColors.background,
                    weight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(profile.name, style: AppText.title(15)),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavLink extends StatefulWidget {
  const _NavLink({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: widget.label,
      excludeSemantics: true,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 180),
                  style: AppText.body(
                    14,
                    weight: FontWeight.w500,
                    height: 1,
                    color:
                        _hover
                            ? AppColors.textPrimary
                            : AppColors.textSecondary,
                  ),
                  child: Text(widget.label),
                ),
                const SizedBox(height: 6),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  height: 1.5,
                  width: _hover ? 18 : 0,
                  color: AppColors.cyan,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ScrollProgress extends StatelessWidget {
  const _ScrollProgress({required this.controller});

  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        double p = 0;
        if (controller.hasClients && controller.position.hasContentDimensions) {
          final max = controller.position.maxScrollExtent;
          p = max <= 0 ? 0 : (controller.offset / max).clamp(0.0, 1.0);
        }
        return Align(
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: p,
            child: Container(
              height: 1.5,
              decoration: const BoxDecoration(
                gradient: AppColors.accentGradient,
              ),
            ),
          ),
        );
      },
    );
  }
}
