import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/core/page_scope.dart';
import 'package:profile/data/portfolio_data.dart';
import 'package:profile/main.dart';
import 'package:profile/sections/experience_section.dart';
import 'package:profile/sections/projects_section.dart';
import 'package:profile/sections/skills_section.dart';
import 'package:profile/widgets/tech_logos.dart';

/// Hosts a single section inside the page services it expects.
Widget _host(Widget child) {
  return MaterialApp(
    // Reduced motion stops the looping animations so the tests can settle.
    builder:
        (context, app) => MediaQuery(
          data: MediaQuery.of(context).copyWith(disableAnimations: true),
          child: app!,
        ),
    home: PageScope(
      scrollController: ScrollController(),
      pointer: ValueNotifier(Offset.zero),
      sectionKeys: {for (final id in SectionId.values) id: GlobalKey()},
      child: Scaffold(body: SingleChildScrollView(child: child)),
    ),
  );
}

void main() {
  testWidgets('content is preserved in the data layer', (tester) async {
    expect(PortfolioData.profile.name, 'Ganesh Manickam');
    expect(PortfolioData.experiences, hasLength(7));
    expect(PortfolioData.projects.map((p) => p.title), [
      'ZebPay',
      'AJIO',
      'Auro',
      'Fullerton',
      'Cakap',
      'SOS Method',
      'Orca Media Player',
    ]);
    expect(PortfolioData.socials, hasLength(3));
  });

  testWidgets('projects coverflow renders and navigates', (tester) async {
    tester.view.physicalSize = const Size(1400, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(_host(const ProjectsSection()));
    await tester.pump(const Duration(milliseconds: 100));

    // The detail panel starts on the first project.
    expect(
      find.text('Crypto Exchange App for buying/selling Bitcoin & Ether.'),
      findsWidgets,
    );

    await tester.tap(find.byTooltip('Next project'));
    await tester.pumpAndSettle();
    expect(
      find.text('Top fashion and lifestyle shopping platform by Reliance.'),
      findsWidgets,
    );

    // Jump straight to Orca from the icon strip.
    await tester.tap(find.bySemanticsLabel('Orca Media Player'));
    await tester.pumpAndSettle();
    expect(
      find.text('Privacy-focused offline video and audio player.'),
      findsWidgets,
    );
    expect(find.byType(FlutterMonochromeIcon), findsWidgets);
    expect(find.text('Android'), findsOneWidget);
  });

  testWidgets('skills detail updates on selection', (tester) async {
    tester.view.physicalSize = const Size(1400, 2000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(_host(const SkillsSection()));
    await tester.pump(const Duration(milliseconds: 100));

    final chip = find.bySemanticsLabel('Flutter').last;
    await tester.ensureVisible(chip);
    await tester.tap(chip);
    await tester.pumpAndSettle();
    expect(
      find.text('Cross-platform apps from a single codebase.'),
      findsOneWidget,
    );
  });

  testWidgets('timeline lists every role', (tester) async {
    tester.view.physicalSize = const Size(400, 3000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(_host(const ExperienceSection()));
    await tester.pump(const Duration(milliseconds: 100));

    for (final e in PortfolioData.experiences) {
      expect(find.text(e.role), findsWidgets);
    }
  });

  testWidgets('full page builds on mobile and desktop', (tester) async {
    for (final size in const [Size(390, 844), Size(1440, 900)]) {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      await tester.pumpWidget(const PortfolioApp());
      await tester.pump(const Duration(seconds: 1));
      expect(tester.takeException(), isNull);
      expect(find.text('Ganesh'), findsWidgets);
    }
    tester.view.reset();
  });
}
