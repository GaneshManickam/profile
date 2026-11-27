import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'models.dart';

/// Single source of truth for all portfolio content.
///
/// Everything here was carried over from the previous version of the site.
/// To update the portfolio, edit this file only.
class PortfolioData {
  PortfolioData._();

  static final profile = Profile(
    name: 'Ganesh Manickam',
    title: 'Mobile Application Developer',
    headline: 'Staff Engineer – iOS · Mobile App Architect',
    currentStatus: 'Currently building at ZebPay',
    intro:
        'I design, build and ship high-performance iOS apps and SDKs — '
        '15+ apps across FinTech, E-Commerce, Health and Streaming.',
    summary:
        'Results-driven Staff Engineer designing, developing, and deploying '
        'high-performance iOS apps and SDKs. Expert in Swift, Objective-C, '
        'SwiftUI, and architecture patterns like VIPER, MVVM, and MVC. '
        'Proven leader in optimizing app performance, integrating third-party '
        'SDKs, and mentoring teams. Delivered 15+ apps across domains '
        'including FinTech, E-Commerce, Health, and Streaming.',
    avatarAsset: 'assets/profile.jpg',
    careerStart: DateTime(2016, 5),
    appsShipped: '15+',
    domainsCount: '5+',
    // Set these to enable the "Download Resume" and e-mail CTAs.
    email: null,
    resumeUrl: null,
  );

  static const socials = <SocialLink>[
    SocialLink(
      label: 'GitHub',
      url: 'https://github.com/GaneshManickam',
      kind: SocialKind.github,
      handle: '@GaneshManickam',
    ),
    SocialLink(
      label: 'LinkedIn',
      url: 'https://linkedin.com/in/ganeshmanickam',
      kind: SocialKind.linkedin,
      handle: 'in/ganeshmanickam',
    ),
    SocialLink(
      label: 'Stack Overflow',
      url: 'https://stackoverflow.com/users/6540962/ganesh-manickam',
      kind: SocialKind.stackOverflow,
      handle: 'ganesh-manickam',
    ),
  ];

  static const expertise = <String>[
    'App performance optimization',
    'Third-party SDK integration',
    'SDK development',
    'Scalable app architecture',
    'Mentoring engineering teams',
  ];

  static const industries = <String>[
    'FinTech',
    'E-Commerce',
    'HealthTech',
    'EduTech',
    'Streaming',
  ];

  static const philosophy =
      'Architecture first, pixels second, performance always. I treat every '
      'app as a long-lived product — readable code, predictable state, and '
      'interfaces that feel effortless.';

  // ---------------------------------------------------------------------------
  // Skills
  // ---------------------------------------------------------------------------

  static const skillCategories = <SkillCategory>[
    SkillCategory(
      id: 'languages',
      label: 'Languages',
      color: AppColors.cyan,
      skills: [
        Skill(
          name: 'Swift',
          blurb:
              'Primary language for native iOS — protocol-oriented design, '
              'value types and modern concurrency.',
        ),
        Skill(
          name: 'Objective-C',
          blurb:
              'Maintaining and modernising long-lived codebases and bridging '
              'legacy modules with Swift.',
        ),
        Skill(
          name: 'Dart',
          blurb: 'The language behind Flutter apps.',
          relatedProjects: ['Orca Media Player'],
        ),
      ],
    ),
    SkillCategory(
      id: 'frameworks',
      label: 'Frameworks',
      color: AppColors.violet,
      skills: [
        Skill(
          name: 'SwiftUI',
          blurb: 'Declarative, state-driven interfaces for modern iOS.',
        ),
        Skill(
          name: 'UIKit',
          blurb:
              'Fine-grained control for complex, performance-sensitive '
              'screens.',
        ),
        Skill(
          name: 'Flutter',
          blurb: 'Cross-platform apps from a single codebase.',
          relatedProjects: ['Orca Media Player'],
        ),
        Skill(
          name: 'Firebase',
          blurb: 'Analytics, messaging, crash reporting and remote config.',
        ),
        Skill(
          name: 'Socket.IO',
          blurb: 'Real-time, bidirectional data streams.',
        ),
        Skill(
          name: 'SPM',
          blurb: 'Swift Package Manager for modular code and SDK distribution.',
        ),
        Skill(
          name: 'KMM',
          blurb: 'Kotlin Multiplatform Mobile — shared business logic.',
        ),
        Skill(
          name: 'CMP',
          blurb: 'Compose Multiplatform — shared UI across platforms.',
        ),
      ],
    ),
    SkillCategory(
      id: 'architecture',
      label: 'Architecture',
      color: AppColors.green,
      skills: [
        Skill(
          name: 'VIPER',
          blurb:
              'Strict separation of View, Interactor, Presenter, Entity and '
              'Router for large teams.',
        ),
        Skill(
          name: 'MVVM',
          blurb: 'Testable view models with clear, observable state.',
        ),
        Skill(
          name: 'MVC',
          blurb: "Apple's classic pattern, kept lean and well-factored.",
        ),
      ],
    ),
    SkillCategory(
      id: 'domains',
      label: 'Domains',
      color: AppColors.pink,
      skills: [
        Skill(
          name: 'FinTech',
          blurb: 'Crypto exchange and trading products.',
          relatedProjects: ['ZebPay', 'Fullerton'],
        ),
        Skill(
          name: 'HealthTech',
          blurb: 'Fitness and mindfulness experiences.',
          relatedProjects: ['Auro', 'SOS Method'],
        ),
        Skill(
          name: 'EduTech',
          blurb: 'Live, interactive learning.',
          relatedProjects: ['Cakap'],
        ),
        Skill(
          name: 'E-Commerce',
          blurb: 'Large-scale shopping platforms.',
          relatedProjects: ['AJIO'],
        ),
        Skill(name: 'iOS', blurb: 'The platform I know inside out.'),
        Skill(name: 'IoT', blurb: 'Apps that talk to connected hardware.'),
        Skill(
          name: 'Bluetooth',
          blurb: 'CoreBluetooth device discovery and data exchange.',
        ),
        Skill(name: 'GPS', blurb: 'Location-aware features and tracking.'),
        Skill(
          name: 'HLS Streaming',
          blurb: 'Adaptive HTTP Live Streaming playback.',
        ),
        Skill(
          name: 'SDK Development',
          blurb: 'Building and shipping reusable SDKs for other teams.',
        ),
      ],
    ),
  ];

  // ---------------------------------------------------------------------------
  // Experience
  // ---------------------------------------------------------------------------

  static final experiences = <Experience>[
    Experience(
      company: 'ZebPay',
      role: 'Staff Engineer',
      start: DateTime(2026, 7),
      logoAsset: 'assets/zebpay_logo.jpeg',
      relatedProjects: const ['ZebPay'],
    ),
    Experience(
      company: 'ZebPay',
      role: 'Senior Software Developer-2',
      start: DateTime(2023, 9),
      end: DateTime(2026, 6),
      logoAsset: 'assets/zebpay_logo.jpeg',
      relatedProjects: const ['ZebPay'],
    ),
    Experience(
      company: 'Jio Platforms Limited',
      role: 'SDE-3',
      start: DateTime(2021, 5),
      end: DateTime(2023, 9),
      logoAsset: 'assets/jio_logo.jpeg',
      relatedProjects: const ['AJIO'],
    ),
    Experience(
      company: 'Flexible Fitness Online',
      role: 'Tech Lead - iOS',
      start: DateTime(2020, 4),
      end: DateTime(2021, 4),
      logoAsset: 'assets/auro_logo.png',
      relatedProjects: const ['Auro'],
    ),
    Experience(
      company: 'Ailoitte Technologies',
      role: 'Senior iOS Developer',
      start: DateTime(2018, 8),
      end: DateTime(2020, 4),
      logoAsset: 'assets/ailoitte_logo.jpeg',
      relatedProjects: const ['SOS Method', 'Fullerton'],
    ),
    Experience(
      company: 'Socedge Technologies',
      role: 'iOS Developer',
      start: DateTime(2017, 6),
      end: DateTime(2018, 8),
      logoAsset: 'assets/socedge_logo.jpeg',
    ),
    Experience(
      company: 'Red Web Solutions',
      role: 'iOS Developer',
      start: DateTime(2016, 5),
      end: DateTime(2017, 5),
      logoAsset: 'assets/redweb_logo.png',
    ),
  ];

  // ---------------------------------------------------------------------------
  // Projects
  // ---------------------------------------------------------------------------

  static const projects = <Project>[
    Project(
      title: 'ZebPay',
      description: 'Crypto Exchange App for buying/selling Bitcoin & Ether.',
      iconAsset: 'assets/zebpay_app_icon.png',
      url:
          'https://apps.apple.com/in/app/zebpay-buy-bitcoin-crypto/id944854686',
      platforms: ['iOS'],
      domain: 'FinTech · Crypto',
      color: Color(0xFF3D7BFF),
      motif: ProjectMotif.candles,
    ),
    Project(
      title: 'AJIO',
      description: 'Top fashion and lifestyle shopping platform by Reliance.',
      iconAsset: 'assets/ajio_app_icon.png',
      url:
          'https://apps.apple.com/in/app/ajio-online-shopping-app/id1113425372',
      platforms: ['iOS'],
      domain: 'E-Commerce · Fashion',
      color: Color(0xFFD9B26F),
      motif: ProjectMotif.storefront,
    ),
    Project(
      title: 'Auro',
      description: 'Audio-guided fitness workouts for home & outdoors.',
      iconAsset: 'assets/auro_app_icon.jpg',
      url:
          'https://apps.apple.com/gb/app/auro-home-outdoor-workouts/id1200805964',
      platforms: ['iOS'],
      domain: 'HealthTech · Fitness',
      color: Color(0xFFFF7A59),
      motif: ProjectMotif.pulse,
    ),
    Project(
      title: 'Fullerton',
      description: 'Enhanced trading app for global markets.',
      iconAsset: 'assets/fullerton_app_icon.png',
      url: 'https://apps.apple.com/us/app/fullerton-markets/id1458847859',
      platforms: ['iOS'],
      domain: 'FinTech · Trading',
      color: Color(0xFF2DD4BF),
      motif: ProjectMotif.candles,
    ),
    Project(
      title: 'Cakap',
      description: 'Live language learning with native teachers.',
      iconAsset: 'assets/cakap_app_icon.png',
      url:
          'https://apps.apple.com/us/app/cakap-online-language-learning/id1434645453',
      platforms: ['iOS'],
      domain: 'EduTech · Languages',
      color: Color(0xFFFFB020),
      motif: ProjectMotif.chat,
    ),
    Project(
      title: 'SOS Method',
      description: 'Mindfulness app for stress and anxiety relief.',
      iconAsset: 'assets/sos_method_app_icon.png',
      url:
          'https://apps.apple.com/in/app/sos-method-stress-anxiety/id1363278866',
      platforms: ['iOS'],
      domain: 'HealthTech · Mindfulness',
      color: Color(0xFFA78BFA),
      motif: ProjectMotif.breathe,
    ),
    Project(
      title: 'Orca Media Player',
      description: 'Privacy-focused offline video and audio player.',
      iconAsset: 'assets/orca_app_icon.png',
      url:
          'https://play.google.com/store/apps/details?id=com.gapsen.orcaplayer',
      platforms: ['Flutter', 'Android'],
      domain: 'Media · Offline Player',
      color: Color(0xFF38BDF8),
      motif: ProjectMotif.media,
    ),
  ];

  // ---------------------------------------------------------------------------
  // How I build
  // ---------------------------------------------------------------------------

  static const process = <ProcessStep>[
    ProcessStep(
      title: 'Understand',
      summary:
          'Clarify the problem, the users and the constraints before a single '
          'line of code.',
      icon: Icons.lightbulb_outline_rounded,
    ),
    ProcessStep(
      title: 'Plan UI/UX',
      summary:
          'Map flows, states and edge cases so the interface has an answer '
          'for every moment.',
      icon: Icons.gesture_rounded,
    ),
    ProcessStep(
      title: 'Architect',
      summary:
          'Choose boundaries — VIPER, MVVM or MVC — that keep features '
          'isolated and testable.',
      icon: Icons.account_tree_outlined,
    ),
    ProcessStep(
      title: 'Build',
      summary:
          'Ship small, reviewable increments with reusable components and a '
          'clear module graph.',
      icon: Icons.code_rounded,
    ),
    ProcessStep(
      title: 'Integrate',
      summary:
          'Wire up APIs, real-time sockets and third-party SDKs behind clean '
          'service layers.',
      icon: Icons.hub_outlined,
    ),
    ProcessStep(
      title: 'Test & Debug',
      summary:
          'Profile memory, frames and network; catch regressions before '
          'users do.',
      icon: Icons.bug_report_outlined,
    ),
    ProcessStep(
      title: 'Ship & Maintain',
      summary:
          'Release, monitor crash-free rates and keep iterating long after '
          'launch.',
      icon: Icons.rocket_launch_outlined,
    ),
  ];

  static const architecture = <ArchitectureLayer>[
    ArchitectureLayer(
      label: 'UI Layer',
      detail: 'SwiftUI / UIKit / Flutter views — render state, emit intents.',
      color: AppColors.cyan,
    ),
    ArchitectureLayer(
      label: 'Business Logic',
      detail: 'View models, presenters and use cases — pure and testable.',
      color: AppColors.violet,
    ),
    ArchitectureLayer(
      label: 'Data Layer',
      detail: 'Repositories that decide between network and cache.',
      color: AppColors.green,
    ),
  ];

  static const services = <ArchitectureLayer>[
    ArchitectureLayer(
      label: 'API Services',
      detail: 'REST + Socket.IO clients',
      color: AppColors.cyan,
    ),
    ArchitectureLayer(
      label: 'Local Storage',
      detail: 'Offline-first caching',
      color: AppColors.green,
    ),
    ArchitectureLayer(
      label: 'Authentication',
      detail: 'Secure sessions & keychain',
      color: AppColors.amber,
    ),
    ArchitectureLayer(
      label: 'Deployment',
      detail: 'Signing, release & monitoring',
      color: AppColors.pink,
    ),
  ];
}
