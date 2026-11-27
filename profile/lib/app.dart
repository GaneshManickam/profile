import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'core/page_scope.dart';
import 'data/portfolio_data.dart';
import 'sections/about_section.dart';
import 'sections/contact_section.dart';
import 'sections/experience_section.dart';
import 'sections/hero_section.dart';
import 'sections/process_section.dart';
import 'sections/projects_section.dart';
import 'sections/skills_section.dart';
import 'theme/app_theme.dart';
import 'widgets/ambient_background.dart';
import 'widgets/nav_bar.dart';

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    final p = PortfolioData.profile;
    return MaterialApp(
      title: '${p.name} · ${p.title}',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      scrollBehavior: const _PortfolioScrollBehavior(),
      home: const PortfolioPage(),
    );
  }
}

/// Lets mouse and trackpad drag carousels on the web, not just touch.
class _PortfolioScrollBehavior extends MaterialScrollBehavior {
  const _PortfolioScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
    PointerDeviceKind.stylus,
  };
}

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({super.key});

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  final _scroll = ScrollController();
  final _pointer = ValueNotifier<Offset>(Offset.zero);
  final _keys = {for (final id in SectionId.values) id: GlobalKey()};

  @override
  void dispose() {
    _scroll.dispose();
    _pointer.dispose();
    super.dispose();
  }

  void _onHover(PointerHoverEvent e) {
    final size = MediaQuery.sizeOf(context);
    _pointer.value = Offset(
      (e.position.dx / size.width) * 2 - 1,
      (e.position.dy / size.height) * 2 - 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    final gutter = Breakpoints.gutter(context);
    final spacing = Breakpoints.sectionSpacing(context);

    Widget section(SectionId id, Widget child) => KeyedSubtree(
      key: _keys[id],
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: Breakpoints.maxContentWidth,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: gutter),
            child: child,
          ),
        ),
      ),
    );

    return PageScope(
      scrollController: _scroll,
      pointer: _pointer,
      sectionKeys: _keys,
      child: Scaffold(
        body: MouseRegion(
          onHover: _onHover,
          onExit: (_) => _pointer.value = Offset.zero,
          child: Stack(
            children: [
              Positioned.fill(child: AmbientBackground(scroll: _scroll)),
              Positioned.fill(
                child: Scrollbar(
                  controller: _scroll,
                  child: SingleChildScrollView(
                    controller: _scroll,
                    child: Column(
                      children: [
                        section(SectionId.home, const HeroSection()),
                        SizedBox(height: spacing * 0.6),
                        section(SectionId.about, const AboutSection()),
                        SizedBox(height: spacing),
                        section(SectionId.skills, const SkillsSection()),
                        SizedBox(height: spacing),
                        section(
                          SectionId.experience,
                          const ExperienceSection(),
                        ),
                        SizedBox(height: spacing),
                        section(SectionId.projects, const ProjectsSection()),
                        SizedBox(height: spacing),
                        section(SectionId.process, const ProcessSection()),
                        SizedBox(height: spacing),
                        section(SectionId.contact, const ContactSection()),
                      ],
                    ),
                  ),
                ),
              ),
              const Positioned(top: 0, left: 0, right: 0, child: NavBar()),
            ],
          ),
        ),
      ),
    );
  }
}
