import 'package:flutter/widgets.dart';

/// Plain, immutable models for portfolio content. UI never hard-codes copy;
/// it reads from `portfolio_data.dart`.

class Profile {
  const Profile({
    required this.name,
    required this.title,
    required this.headline,
    required this.currentStatus,
    required this.intro,
    required this.summary,
    required this.avatarAsset,
    required this.careerStart,
    required this.appsShipped,
    required this.domainsCount,
    this.email,
    this.resumeUrl,
  });

  final String name;

  /// Short professional title, e.g. "Mobile Application Developer".
  final String title;

  /// Current seniority line, e.g. "Staff Engineer – iOS · Mobile App Architect".
  final String headline;
  final String currentStatus;
  final String intro;
  final String summary;
  final String avatarAsset;
  final DateTime careerStart;
  final String appsShipped;
  final String domainsCount;

  /// Optional — the contact section shows a mail CTA only when set.
  final String? email;

  /// Optional — the hero shows "Download Resume" only when set. Can be an
  /// absolute URL or a path relative to the site root (e.g. `resume.pdf`
  /// placed in `web/`).
  final String? resumeUrl;

  double get yearsOfExperience =>
      DateTime.now().difference(careerStart).inDays / 365.25;
}

enum SocialKind { github, linkedin, stackOverflow, email, other }

class SocialLink {
  const SocialLink({
    required this.label,
    required this.url,
    required this.kind,
    this.handle,
  });

  final String label;
  final String url;
  final SocialKind kind;
  final String? handle;
}

class Skill {
  const Skill({
    required this.name,
    required this.blurb,
    this.relatedProjects = const [],
  });

  final String name;
  final String blurb;

  /// Project titles (from [Project.title]) where this skill shows up.
  final List<String> relatedProjects;
}

class SkillCategory {
  const SkillCategory({
    required this.id,
    required this.label,
    required this.color,
    required this.skills,
  });

  final String id;
  final String label;
  final Color color;
  final List<Skill> skills;
}

class Experience {
  const Experience({
    required this.company,
    required this.role,
    required this.start,
    this.end,
    required this.logoAsset,
    this.highlights = const [],
    this.relatedProjects = const [],
  });

  final String company;
  final String role;
  final DateTime start;

  /// `null` means present.
  final DateTime? end;
  final String logoAsset;

  /// Responsibilities / achievements. Intentionally empty until real
  /// details are provided — the UI hides the list when empty.
  final List<String> highlights;
  final List<String> relatedProjects;

  bool get isCurrent => end == null;
}

/// Visual motif drawn behind a project's device preview, chosen from the
/// app's real domain.
enum ProjectMotif { candles, storefront, pulse, chat, breathe, media }

class Project {
  const Project({
    required this.title,
    required this.description,
    required this.iconAsset,
    required this.url,
    required this.platforms,
    required this.domain,
    required this.color,
    required this.motif,
    this.role,
    this.screenshots = const [],
  });

  final String title;
  final String description;
  final String iconAsset;
  final String url;
  final List<String> platforms;
  final String domain;
  final Color color;
  final ProjectMotif motif;

  /// Optional — shown when provided.
  final String? role;

  /// Optional real screenshots (asset paths). When empty the device shows
  /// a branded launch screen built from the real app icon instead.
  final List<String> screenshots;

  String get storeLabel =>
      url.contains('play.google.com') ? 'Google Play' : 'App Store';
}

class ProcessStep {
  const ProcessStep({
    required this.title,
    required this.summary,
    required this.icon,
  });

  final String title;
  final String summary;
  final IconData icon;
}

class ArchitectureLayer {
  const ArchitectureLayer({
    required this.label,
    required this.detail,
    required this.color,
  });

  final String label;
  final String detail;
  final Color color;
}
