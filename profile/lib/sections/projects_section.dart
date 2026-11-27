import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/motion.dart';
import '../data/models.dart';
import '../data/portfolio_data.dart';
import '../theme/app_theme.dart';
import '../widgets/buttons.dart';
import '../widgets/device_frames.dart';
import '../widgets/phone_screens.dart';
import '../widgets/section_header.dart';
import '../widgets/surfaces.dart';
import '../widgets/tech_logos.dart';

class ProjectsSection extends StatefulWidget {
  const ProjectsSection({super.key});

  @override
  State<ProjectsSection> createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends State<ProjectsSection>
    with SingleTickerProviderStateMixin {
  static const _projects = PortfolioData.projects;

  PageController? _pages;
  double _fraction = 0;
  int _index = 0;

  late final AnimationController _idle = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 8),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final fraction = switch (Breakpoints.of(context)) {
      ScreenSize.mobile => 0.66,
      ScreenSize.tablet => 0.42,
      ScreenSize.desktop => 0.3,
    };
    if (fraction != _fraction) {
      _fraction = fraction;
      _pages?.dispose();
      _pages = PageController(viewportFraction: fraction, initialPage: _index);
    }
    if (Motion.reduced(context)) {
      _idle.stop();
    } else if (!_idle.isAnimating) {
      _idle.repeat();
    }
  }

  @override
  void dispose() {
    _pages?.dispose();
    _idle.dispose();
    super.dispose();
  }

  void _go(int i) {
    final target = i.clamp(0, _projects.length - 1);
    if (Motion.reduced(context)) {
      _pages!.jumpToPage(target);
    } else {
      _pages!.animateToPage(
        target,
        duration: const Duration(milliseconds: 650),
        curve: Motion.emphasized,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = Breakpoints.of(context);
    final phoneW = switch (size) {
      ScreenSize.mobile => 196.0,
      ScreenSize.tablet => 220.0,
      ScreenSize.desktop => 236.0,
    };
    final stageH = PhoneFrame.heightFor(phoneW) + 60;
    final project = _projects[_index];

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.arrowLeft):
            () => _go(_index - 1),
        const SingleActivator(LogicalKeyboardKey.arrowRight):
            () => _go(_index + 1),
      },
      child: Focus(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(
              index: '04',
              eyebrow: 'Featured Work',
              title: "Products I've helped\nbring to life.",
              lede:
                  '${_projects.length} shipped apps across FinTech, commerce, '
                  'health, education and media. Swipe, drag or use the arrows.',
            ),
            SizedBox(height: size == ScreenSize.mobile ? 24 : 40),
            Reveal(
              scale: 0.94,
              child: ViewportTickerGate(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Ambient identity colour of the focused project.
                    IgnorePointer(
                      child: TweenAnimationBuilder<Color?>(
                        tween: ColorTween(end: project.color),
                        duration: const Duration(milliseconds: 700),
                        builder:
                            (context, c, _) => Container(
                              width: phoneW * 3.2,
                              height: stageH,
                              decoration: BoxDecoration(
                                gradient: RadialGradient(
                                  radius: 0.6,
                                  colors: [
                                    (c ?? project.color).withValues(alpha: 0.2),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                      ),
                    ),
                    SizedBox(
                      height: stageH,
                      child: PageView.builder(
                        controller: _pages,
                        itemCount: _projects.length,
                        clipBehavior: Clip.none,
                        onPageChanged: (i) => setState(() => _index = i),
                        itemBuilder:
                            (context, i) => _CoverflowItem(
                              controller: _pages!,
                              idle: _idle,
                              index: i,
                              project: _projects[i],
                              phoneWidth: phoneW,
                              onTap: () => _go(i),
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            _Selector(
              current: _index,
              onSelect: _go,
              onPrev: _index > 0 ? () => _go(_index - 1) : null,
              onNext:
                  _index < _projects.length - 1 ? () => _go(_index + 1) : null,
            ),
            const SizedBox(height: 24),
            _ProjectDetail(project: project),
          ],
        ),
      ),
    );
  }
}

/// One phone in the coverflow, rotated in 3D by its distance from centre.
class _CoverflowItem extends StatelessWidget {
  const _CoverflowItem({
    required this.controller,
    required this.idle,
    required this.index,
    required this.project,
    required this.phoneWidth,
    required this.onTap,
  });

  final PageController controller;
  final Animation<double> idle;
  final int index;
  final Project project;
  final double phoneWidth;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final device = RepaintBoundary(
      child: PhoneFrame(
        width: phoneWidth,
        glow: project.color,
        child:
            project.screenshots.isNotEmpty
                ? Image.asset(project.screenshots.first, fit: BoxFit.cover)
                : ProjectLaunchScreen(
                  project: project,
                  // Focused phone opens the store; a side phone slides into
                  // focus first.
                  onStoreTap: () {
                    final page =
                        controller.hasClients
                            ? (controller.page ??
                                controller.initialPage.toDouble())
                            : controller.initialPage.toDouble();
                    if (page.round() == index) {
                      openExternal(context, project.url);
                    } else {
                      onTap();
                    }
                  },
                ),
      ),
    );
    final edge = PhoneFrame.edge(phoneWidth);

    return AnimatedBuilder(
      animation: Listenable.merge([controller, idle]),
      builder: (context, _) {
        double page = index.toDouble();
        if (controller.hasClients && controller.position.hasContentDimensions) {
          page = controller.page ?? controller.initialPage.toDouble();
        } else {
          page = controller.initialPage.toDouble();
        }
        final delta = (index - page).clamp(-3.0, 3.0);
        final focus = (1 - delta.abs()).clamp(0.0, 1.0);
        final idleT = idle.value * 2 * math.pi;

        final ry = -delta * 0.62 + focus * math.sin(idleT) * 0.14;
        final rx = focus * -0.04;
        final scale = 1 - math.min(delta.abs(), 2) * 0.16;
        final depth = -delta.abs() * 120;
        final lift = focus * math.sin(idleT * 2) * 6;

        Matrix4 m(double z) =>
            Matrix4.identity()
              ..setEntry(3, 2, 0.0012)
              ..translateByDouble(0, lift, -depth, 1)
              ..rotateX(rx)
              ..rotateY(ry)
              ..translateByDouble(0, 0, z, 1)
              ..scaleByDouble(scale, scale, 1, 1);

        // Side wall slices — towards the camera is negative z in Flutter.
        final slices = <Widget>[
          for (var i = 8; i >= 1; i--)
            Transform(
              transform: m(i * 1.5),
              alignment: Alignment.center,
              child: edge,
            ),
        ];

        final dim = (delta.abs() * 0.45).clamp(0.0, 0.7);
        return Center(
          child: Semantics(
            button: true,
            label: '${project.title} — ${project.domain}',
            excludeSemantics: true,
            child: MouseRegion(
              cursor:
                  focus > 0.9 ? MouseCursor.defer : SystemMouseCursors.click,
              child: GestureDetector(
                onTap: onTap,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ...slices,
                    Transform(
                      transform: m(0),
                      alignment: Alignment.center,
                      child: device,
                    ),
                    if (dim > 0.01)
                      IgnorePointer(
                        child: Transform(
                          transform: m(0),
                          alignment: Alignment.center,
                          child: Container(
                            width: phoneWidth,
                            height: PhoneFrame.heightFor(phoneWidth),
                            decoration: BoxDecoration(
                              color: AppColors.background.withValues(
                                alpha: dim,
                              ),
                              borderRadius: BorderRadius.circular(
                                phoneWidth * 0.17,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Selector extends StatelessWidget {
  const _Selector({
    required this.current,
    required this.onSelect,
    required this.onPrev,
    required this.onNext,
  });

  final int current;
  final ValueChanged<int> onSelect;
  final VoidCallback? onPrev;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    final projects = PortfolioData.projects;
    final mobile = Breakpoints.of(context) == ScreenSize.mobile;
    Widget arrow(IconData icon, String label, VoidCallback? onTap) =>
        AnimatedOpacity(
          opacity: onTap == null ? 0.3 : 1,
          duration: const Duration(milliseconds: 200),
          child: IconCircleButton(
            icon: Icon(icon),
            tooltip: label,
            size: 40,
            onPressed: onTap ?? () {},
          ),
        );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        arrow(Icons.chevron_left_rounded, 'Previous project', onPrev),
        const SizedBox(width: 12),
        Flexible(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (var i = 0; i < projects.length; i++)
                  Semantics(
                    button: true,
                    selected: i == current,
                    label: projects[i].title,
                    excludeSemantics: true,
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () => onSelect(i),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Motion.emphasized,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              width: 1.5,
                              color:
                                  i == current
                                      ? projects[i].color
                                      : Colors.transparent,
                            ),
                          ),
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 300),
                            opacity: i == current ? 1 : 0.45,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(9),
                              child: Image.asset(
                                projects[i].iconAsset,
                                width: mobile ? 30 : 36,
                                height: mobile ? 30 : 36,
                                cacheWidth: 96,
                                fit: BoxFit.cover,
                                excludeFromSemantics: true,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        arrow(Icons.chevron_right_rounded, 'Next project', onNext),
      ],
    );
  }
}

class _ProjectDetail extends StatelessWidget {
  const _ProjectDetail({required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    final mobile = Breakpoints.of(context) == ScreenSize.mobile;
    final index = PortfolioData.projects.indexOf(project) + 1;
    final total = PortfolioData.projects.length;
    // Company where this app was built, from the career data.
    final builtAt =
        PortfolioData.experiences
            .where((e) => e.relatedProjects.contains(project.title))
            .map((e) => e.company)
            .firstOrNull;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 760),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 420),
          switchInCurve: Motion.emphasized,
          switchOutCurve: Curves.easeIn,
          transitionBuilder:
              (child, anim) => FadeTransition(
                opacity: anim,
                child: SlideTransition(
                  position: Tween(
                    begin: const Offset(0, 0.06),
                    end: Offset.zero,
                  ).animate(anim),
                  child: child,
                ),
              ),
          layoutBuilder:
              (current, previous) => Stack(
                alignment: Alignment.topCenter,
                children: [...previous, if (current != null) current],
              ),
          child: GlassPanel(
            key: ValueKey(project.title),
            glow: project.color,
            borderColor: project.color.withValues(alpha: 0.28),
            padding: EdgeInsets.all(mobile ? 20 : 28),
            child: Semantics(
              liveRegion: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '${index.toString().padLeft(2, '0')} / ${total.toString().padLeft(2, '0')}',
                        style: AppText.mono(11, color: project.color),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          project.domain.toUpperCase(),
                          style: AppText.mono(11, letterSpacing: 1.8),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Flex(
                    direction: mobile ? Axis.vertical : Axis.horizontal,
                    crossAxisAlignment:
                        mobile
                            ? CrossAxisAlignment.start
                            : CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        flex: mobile ? 0 : 1,
                        fit: FlexFit.loose,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              project.title,
                              style: AppText.display(mobile ? 28 : 34),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              project.description,
                              style: AppText.body(mobile ? 15 : 16.5),
                            ),
                            if (builtAt != null) ...[
                              const SizedBox(height: 10),
                              Text(
                                'Built at $builtAt',
                                style: AppText.mono(12, color: project.color),
                              ),
                            ],
                            if (project.role != null) ...[
                              const SizedBox(height: 10),
                              Text(
                                'Role: ${project.role}',
                                style: AppText.body(
                                  14,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                            const SizedBox(height: 16),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                for (final pl in project.platforms)
                                  TagChip(
                                    label: pl,
                                    color: project.color,
                                    dense: true,
                                    icon: platformIcon(
                                      pl,
                                      size: 12,
                                      color: project.color,
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: mobile ? 0 : 24, height: mobile ? 20 : 0),
                      AppButton(
                        label: 'View on ${project.storeLabel}',
                        icon: Icons.north_east_rounded,
                        url: project.url,
                      ),
                    ],
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
