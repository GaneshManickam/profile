import 'package:flutter/material.dart';

/// Sections reachable from the navigation bar.
enum SectionId { home, about, skills, experience, projects, process, contact }

extension SectionIdLabel on SectionId {
  String get label => switch (this) {
    SectionId.home => 'Home',
    SectionId.about => 'About',
    SectionId.skills => 'Skills',
    SectionId.experience => 'Journey',
    SectionId.projects => 'Work',
    SectionId.process => 'Process',
    SectionId.contact => 'Contact',
  };
}

/// Page-wide services shared with every section without rebuilding them:
/// the main scroll controller, a normalised pointer position used for
/// parallax, and anchors for in-page navigation.
class PageScope extends InheritedWidget {
  const PageScope({
    super.key,
    required this.scrollController,
    required this.pointer,
    required this.sectionKeys,
    required super.child,
  });

  final ScrollController scrollController;

  /// Pointer position in the window, normalised to [-1, 1] on both axes.
  /// Stays at [Offset.zero] on touch devices.
  final ValueNotifier<Offset> pointer;
  final Map<SectionId, GlobalKey> sectionKeys;

  static PageScope of(BuildContext context) {
    final scope = context.getInheritedWidgetOfExactType<PageScope>();
    assert(scope != null, 'PageScope not found in context');
    return scope!;
  }

  static PageScope? maybeOf(BuildContext context) =>
      context.getInheritedWidgetOfExactType<PageScope>();

  Future<void> scrollTo(SectionId id, {bool reduceMotion = false}) async {
    final ctx = sectionKeys[id]?.currentContext;
    if (ctx == null) return;
    await Scrollable.ensureVisible(
      ctx,
      duration:
          reduceMotion ? Duration.zero : const Duration(milliseconds: 900),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  bool updateShouldNotify(PageScope oldWidget) => false;
}
