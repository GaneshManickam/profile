import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

// ============================================================================
// DESIGN TOKENS
// ============================================================================

class AppColors {
  AppColors._();

  // Backgrounds
  static const background = Color(0xFF0A0A0F);
  static const surface = Color(0xFF12121A);
  static const surfaceElevated = Color(0xFF161622);

  // Borders
  static const border = Color(0xFF1E1E2E);
  static const borderLight = Color(0xFF2A2A3C);

  // Text
  static const textPrimary = Color(0xFFF1F5F9);
  static const textSecondary = Color(0xFF94A3B8);
  static const textTertiary = Color(0xFF64748B);

  // Accents
  static const accentIndigo = Color(0xFF6366F1);
  static const accentViolet = Color(0xFF8B5CF6);
  static const accentPink = Color(0xFFEC4899);
  static const accentCyan = Color(0xFF22D3EE);
  static const accentAmber = Color(0xFFFBBF24);
  static const accentGreen = Color(0xFF22C55E);

  // Gradient
  static const primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentIndigo, accentViolet, accentPink],
  );
}

// ============================================================================
// MAIN APP
// ============================================================================

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ganesh Manickam, Staff Engineer - iOS | Portfolio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.background,
        primaryColor: AppColors.accentIndigo,
        textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme),
        useMaterial3: true,
      ),
      home: const PortfolioHomePage(),
    );
  }
}

// ============================================================================
// PORTFOLIO HOME PAGE
// ============================================================================

class PortfolioHomePage extends StatelessWidget {
  const PortfolioHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          const MeshGradientBackground(),
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: 24,
              vertical: MediaQuery.of(context).padding.top + 40,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 960),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    HeroSection(),
                    SizedBox(height: 64),
                    SectionHeader(number: '_01', title: 'About Me'),
                    SizedBox(height: 24),
                    AboutSection(),
                    SizedBox(height: 64),
                    SectionHeader(number: '_02', title: 'Skills'),
                    SizedBox(height: 24),
                    SkillsSection(),
                    SizedBox(height: 64),
                    SectionHeader(number: '_03', title: 'Experience'),
                    SizedBox(height: 24),
                    ExperienceSection(),
                    SizedBox(height: 64),
                    SectionHeader(number: '_04', title: 'Notable Projects'),
                    SizedBox(height: 24),
                    ProjectsSection(),
                    SizedBox(height: 80),
                    FooterSection(),
                    SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// MESH GRADIENT BACKGROUND + DOT GRID
// ============================================================================

class MeshGradientBackground extends StatelessWidget {
  const MeshGradientBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: AppColors.background),

        // Aurora orb — indigo (top-left)
        Positioned(
          top: -200,
          left: -150,
          child: _AuroraOrb(
            color: AppColors.accentIndigo.withOpacity(0.07),
            size: 600,
            offset: const Offset(40, 25),
            duration: 8.seconds,
          ),
        ),

        // Aurora orb — violet (bottom-right)
        Positioned(
          bottom: -250,
          right: -200,
          child: _AuroraOrb(
            color: AppColors.accentViolet.withOpacity(0.05),
            size: 700,
            offset: const Offset(-35, -20),
            duration: 10.seconds,
          ),
        ),

        // Aurora orb — pink (mid-right)
        Positioned(
          top: 400,
          right: -100,
          child: _AuroraOrb(
            color: AppColors.accentPink.withOpacity(0.04),
            size: 500,
            offset: const Offset(25, -35),
            duration: 12.seconds,
          ),
        ),

        // Dot grid overlay
        Positioned.fill(
          child: CustomPaint(painter: _DotGridPainter()),
        ),
      ],
    );
  }
}

class _AuroraOrb extends StatelessWidget {
  final Color color;
  final double size;
  final Offset offset;
  final Duration duration;

  const _AuroraOrb({
    required this.color,
    required this.size,
    required this.offset,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color, Colors.transparent],
          stops: const [0.0, 0.7],
        ),
      ),
    )
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .move(
          begin: Offset.zero,
          end: offset,
          duration: duration,
          curve: Curves.easeInOut,
        );
  }
}

class _DotGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.border.withOpacity(0.25)
      ..style = PaintingStyle.fill;

    const spacing = 48.0;
    const dotRadius = 0.6;

    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), dotRadius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ============================================================================
// SHARED WIDGETS
// ============================================================================

/// Solid dark card with a subtle border — replaces the old glass container.
class SurfaceCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;

  const SurfaceCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24),
    this.borderRadius = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: child,
    );
  }
}

/// Subtle scale-down on press — replaces the old bouncy jelly button.
class ScaleOnTap extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;

  const ScaleOnTap({super.key, required this.child, this.onTap});

  @override
  State<ScaleOnTap> createState() => _ScaleOnTapState();
}

class _ScaleOnTapState extends State<ScaleOnTap> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap?.call();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        child: widget.child,
      ),
    );
  }
}

/// Text rendered with the primary indigo→violet→pink gradient.
class GradientText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;

  const GradientText({
    super.key,
    required this.text,
    this.style,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => AppColors.primaryGradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(text, style: style, textAlign: textAlign),
    );
  }
}

/// Numbered section header with a gradient underline.
class SectionHeader extends StatelessWidget {
  final String number;
  final String title;

  const SectionHeader({super.key, required this.number, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              number,
              style: GoogleFonts.jetBrainsMono(
                color: AppColors.accentCyan,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          height: 1,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.accentIndigo.withOpacity(0.4),
                AppColors.border.withOpacity(0.2),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ],
    ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.05, end: 0);
  }
}

// ============================================================================
// HERO SECTION
// ============================================================================

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 700;

    if (isWide) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: _HeroContent()),
          const SizedBox(width: 48),
          const _ProfileAvatar(),
        ],
      );
    }
    return Column(
      children: [
        const _ProfileAvatar(),
        const SizedBox(height: 32),
        _HeroContent(centered: true),
      ],
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: AppColors.primaryGradient,
      ),
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.background,
        ),
        child: Container(
          width: 120,
          height: 120,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage('assets/profile.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 600.ms)
        .scale(
          begin: const Offset(0.85, 0.85),
          end: const Offset(1, 1),
          duration: 600.ms,
          curve: Curves.easeOutBack,
        );
  }
}

class _HeroContent extends StatelessWidget {
  final bool centered;
  const _HeroContent({this.centered = false});

  @override
  Widget build(BuildContext context) {
    final align =
        centered ? CrossAxisAlignment.center : CrossAxisAlignment.start;
    final textAlign = centered ? TextAlign.center : TextAlign.left;
    final wrapAlign =
        centered ? WrapAlignment.center : WrapAlignment.start;

    return Column(
      crossAxisAlignment: align,
      children: [
        // Greeting
        Text(
          'Hi, I\'m',
          textAlign: textAlign,
          style: GoogleFonts.jetBrainsMono(
            color: AppColors.accentCyan,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1, end: 0),

        const SizedBox(height: 8),

        // Name — gradient
        GradientText(
          text: 'Ganesh Manickam',
          textAlign: textAlign,
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: -1,
                height: 1.1,
              ),
        ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0),

        const SizedBox(height: 12),

        // Role with terminal prompt
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '>_ ',
              style: GoogleFonts.jetBrainsMono(
                color: AppColors.accentViolet,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            Flexible(
              child: Text(
                'Staff Engineer - iOS | Mobile App Architect',
                textAlign: textAlign,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.2,
                    ),
              ),
            ),
          ],
        ).animate().fadeIn(delay: 350.ms).slideY(begin: 0.1, end: 0),

        const SizedBox(height: 20),

        // Status indicator
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.accentGreen,
              ),
            )
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .fade(begin: 0.4, end: 1.0, duration: 1500.ms),
            const SizedBox(width: 10),
            Text(
              'Currently building at ZebPay 🚀',
              style: GoogleFonts.jetBrainsMono(
                color: AppColors.textTertiary,
                fontSize: 13,
              ),
            ),
          ],
        ).animate().fadeIn(delay: 500.ms),

        const SizedBox(height: 28),

        // Social pills
        Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: wrapAlign,
          children: const [
            _SocialPill(
              label: 'GitHub',
              icon: Icons.code_rounded,
              url: 'https://github.com/GaneshManickam',
            ),
            _SocialPill(
              label: 'LinkedIn',
              icon: Icons.work_outline_rounded,
              url: 'https://linkedin.com/in/ganeshmanickam',
            ),
            _SocialPill(
              label: 'Stack Overflow',
              icon: Icons.question_answer_outlined,
              url: 'https://stackoverflow.com/users/6540962/ganesh-manickam',
            ),
          ],
        ).animate().fadeIn(delay: 600.ms),
      ],
    );
  }
}

class _SocialPill extends StatelessWidget {
  final String label;
  final IconData icon;
  final String url;

  const _SocialPill({
    required this.label,
    required this.icon,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return ScaleOnTap(
      onTap: () => launchUrl(Uri.parse(url)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: AppColors.borderLight, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.textSecondary, size: 16),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.outfit(
                color: AppColors.textSecondary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// ABOUT SECTION
// ============================================================================

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  String get _years {
    final start = DateTime(2016, 5);
    final diff = DateTime.now().difference(start).inDays / 365.25;
    return diff.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Stats row
        Row(
          children: [
            _StatCard(value: '$_years+', label: 'Years'),
            const SizedBox(width: 12),
            const _StatCard(value: '15+', label: 'Apps'),
            const SizedBox(width: 12),
            const _StatCard(value: '5+', label: 'Domains'),
          ],
        ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.05, end: 0),

        const SizedBox(height: 20),

        // Narrative
        SurfaceCard(
          child: Text(
            'Results-driven Staff Engineer with $_years+ years of experience '
            'designing, developing, and deploying high-performance iOS apps and '
            'SDKs. Expert in Swift, Objective-C, SwiftUI, and architecture '
            'patterns like VIPER, MVVM, and MVC. Proven leader in optimizing '
            'app performance, integrating third-party SDKs, and mentoring '
            'teams. Delivered 15+ apps across domains including FinTech, '
            'E-Commerce, Health, and Streaming.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.7,
                  letterSpacing: 0.2,
                ),
          ),
        ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.05, end: 0),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;

  const _StatCard({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SurfaceCard(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          children: [
            GradientText(
              text: value,
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                letterSpacing: -1,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.jetBrainsMono(
                color: AppColors.textTertiary,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// SKILLS SECTION — Categorised & Color-coded
// ============================================================================

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  static const _categories = <String, List<String>>{
    'Languages': ['Swift', 'Objective-C'],
    'Frameworks': [
      'SwiftUI',
      'UIKit',
      'Flutter',
      'Firebase',
      'Socket.IO',
      'SPM',
      'KMM',
      'CMP',
    ],
    'Domains': [
      'iOS',
      'IoT',
      'Bluetooth',
      'GPS',
      'HLS Streaming',
      'SDK Development',
    ],
    'Methodologies': ['Vibe Coding'],
  };

  static const _categoryColors = <String, Color>{
    'Languages': AppColors.accentCyan,
    'Frameworks': AppColors.accentViolet,
    'Domains': AppColors.accentPink,
    'Methodologies': AppColors.accentAmber,
  };

  @override
  Widget build(BuildContext context) {
    int delayIndex = 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _categories.entries.map((entry) {
        final color = _categoryColors[entry.key] ?? AppColors.accentIndigo;
        final delay = (delayIndex * 100).ms;
        delayIndex++;
        return _SkillCategory(
          category: entry.key,
          skills: entry.value,
          color: color,
          delay: delay,
        );
      }).toList(),
    );
  }
}

class _SkillCategory extends StatelessWidget {
  final String category;
  final List<String> skills;
  final Color color;
  final Duration delay;

  const _SkillCategory({
    required this.category,
    required this.skills,
    required this.color,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category label styled like a code comment
          Text(
            '// $category',
            style: GoogleFonts.jetBrainsMono(
              color: AppColors.textTertiary,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: skills
                .map((skill) => _SkillTag(label: skill, color: color))
                .toList(),
          ),
        ],
      ),
    ).animate().fadeIn(delay: delay).slideX(begin: -0.03, end: 0);
  }
}

class _SkillTag extends StatelessWidget {
  final String label;
  final Color color;

  const _SkillTag({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return ScaleOnTap(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3), width: 1),
          color: color.withOpacity(0.06),
        ),
        child: Text(
          label,
          style: GoogleFonts.jetBrainsMono(
            color: color,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// EXPERIENCE SECTION — Vertical Timeline
// ============================================================================

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  static const _experiences = [
    {
      'company': 'ZebPay',
      'role': 'Staff Engineer',
      'date': 'Jul 2026 — Present',
      'image': 'assets/zebpay_logo.jpeg',
      'current': true,
    },
    {
      'company': 'ZebPay',
      'role': 'Senior Software Developer-2',
      'date': 'Sep 2023 — Jun 2026',
      'image': 'assets/zebpay_logo.jpeg',
    },
    {
      'company': 'Jio Platforms Limited',
      'role': 'SDE-3',
      'date': 'May 2021 — Sep 2023',
      'image': 'assets/jio_logo.jpeg',
    },
    {
      'company': 'Flexible Fitness Online',
      'role': 'Tech Lead - iOS',
      'date': 'Apr 2020 — Apr 2021',
      'image': 'assets/auro_logo.png',
    },
    {
      'company': 'Ailoitte Technologies',
      'role': 'Senior iOS Developer',
      'date': 'Aug 2018 — Apr 2020',
      'image': 'assets/ailoitte_logo.jpeg',
    },
    {
      'company': 'Socedge Technologies',
      'role': 'iOS Developer',
      'date': 'Jun 2017 — Aug 2018',
      'image': 'assets/socedge_logo.jpeg',
    },
    {
      'company': 'Red Web Solutions',
      'role': 'iOS Developer',
      'date': 'May 2016 — May 2017',
      'image': 'assets/redweb_logo.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(_experiences.length, (i) {
        final exp = _experiences[i];
        final isLast = i == _experiences.length - 1;
        final isCurrent = exp['current'] == true;

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Timeline rail ──
              SizedBox(
                width: 24,
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    // Dot — filled for current, outlined for past
                    _TimelineDot(isCurrent: isCurrent),
                    // Connecting line
                    if (!isLast)
                      Expanded(
                        child: Container(
                          width: 1.5,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                isCurrent
                                    ? AppColors.accentIndigo.withOpacity(0.5)
                                    : AppColors.border,
                                AppColors.border,
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(width: 20),

              // ── Experience card ──
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
                  child: SurfaceCard(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        // Company logo
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            exp['image'] as String,
                            width: 44,
                            height: 44,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 14),

                        // Text content
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                exp['company'] as String,
                                style: GoogleFonts.outfit(
                                  color: AppColors.textPrimary,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                exp['role'] as String,
                                style: GoogleFonts.outfit(
                                  color: AppColors.textSecondary,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                exp['date'] as String,
                                style: GoogleFonts.jetBrainsMono(
                                  color: AppColors.textTertiary,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // "Current" badge
                        if (isCurrent)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: AppColors.accentGreen.withOpacity(0.1),
                              border: Border.all(
                                color: AppColors.accentGreen.withOpacity(0.3),
                              ),
                            ),
                            child: Text(
                              'Current',
                              style: GoogleFonts.jetBrainsMono(
                                color: AppColors.accentGreen,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
            .animate()
            .fadeIn(delay: (80 * i).ms)
            .slideY(begin: 0.05, end: 0);
      }),
    );
  }
}

class _TimelineDot extends StatelessWidget {
  final bool isCurrent;
  const _TimelineDot({required this.isCurrent});

  @override
  Widget build(BuildContext context) {
    final dot = Container(
      width: isCurrent ? 14 : 10,
      height: isCurrent ? 14 : 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isCurrent ? AppColors.accentIndigo : Colors.transparent,
        border: isCurrent
            ? null
            : Border.all(color: AppColors.borderLight, width: 2),
      ),
    );

    if (isCurrent) {
      // Pulse animation for the active role
      return dot
          .animate(onPlay: (c) => c.repeat(reverse: true))
          .scale(
            begin: const Offset(1, 1),
            end: const Offset(1.3, 1.3),
            duration: 1200.ms,
            curve: Curves.easeInOut,
          )
          .fade(begin: 0.6, end: 1.0, duration: 1200.ms);
    }
    return dot;
  }
}

// ============================================================================
// PROJECTS SECTION — Bento Grid
// ============================================================================

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  static const _projects = [
    {
      'title': 'ZebPay',
      'desc': 'Crypto Exchange App for buying/selling Bitcoin & Ether.',
      'image': 'assets/zebpay_app_icon.png',
      'url':
          'https://apps.apple.com/in/app/zebpay-buy-bitcoin-crypto/id944854686',
    },
    {
      'title': 'AJIO',
      'desc': 'Top fashion and lifestyle shopping platform by Reliance.',
      'image': 'assets/ajio_app_icon.png',
      'url':
          'https://apps.apple.com/in/app/ajio-online-shopping-app/id1113425372',
    },
    {
      'title': 'Auro',
      'desc': 'Audio-guided fitness workouts for home & outdoors.',
      'image': 'assets/auro_app_icon.jpg',
      'url':
          'https://apps.apple.com/gb/app/auro-home-outdoor-workouts/id1200805964',
    },
    {
      'title': 'Fullerton',
      'desc': 'Enhanced trading app for global markets.',
      'image': 'assets/fullerton_app_icon.png',
      'url': 'https://apps.apple.com/us/app/fullerton-markets/id1458847859',
    },
    {
      'title': 'Cakap',
      'desc': 'Live language learning with native teachers.',
      'image': 'assets/cakap_app_icon.png',
      'url':
          'https://apps.apple.com/us/app/cakap-online-language-learning/id1434645453',
    },
    {
      'title': 'SOS Method',
      'desc': 'Mindfulness app for stress and anxiety relief.',
      'image': 'assets/sos_method_app_icon.png',
      'url':
          'https://apps.apple.com/in/app/sos-method-stress-anxiety/id1363278866',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 600;
    final crossAxisCount = isDesktop ? 3 : 2;

    return StaggeredGrid.count(
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: List.generate(_projects.length, (i) {
        final project = _projects[i];
        final isFeatured = i == 0 && isDesktop;

        return StaggeredGridTile.fit(
          crossAxisCellCount: isFeatured ? 2 : 1,
          child: _ProjectCard(
            title: project['title']!,
            desc: project['desc']!,
            image: project['image']!,
            url: project['url']!,
            isFeatured: isFeatured,
          )
              .animate()
              .fadeIn(delay: (80 * i).ms)
              .scale(
                begin: const Offset(0.95, 0.95),
                end: const Offset(1, 1),
                curve: Curves.easeOut,
              ),
        );
      }),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  final String title;
  final String desc;
  final String image;
  final String url;
  final bool isFeatured;

  const _ProjectCard({
    required this.title,
    required this.desc,
    required this.image,
    required this.url,
    this.isFeatured = false,
  });

  @override
  Widget build(BuildContext context) {
    return ScaleOnTap(
      onTap: () => launchUrl(Uri.parse(url)),
      child: SurfaceCard(
        padding: EdgeInsets.all(isFeatured ? 20 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // App icon
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    image,
                    width: isFeatured ? 56 : 48,
                    height: isFeatured ? 56 : 48,
                    fit: BoxFit.cover,
                  ),
                ),
                const Spacer(),
                // iOS platform badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.apple,
                        size: 14,
                        color: AppColors.textTertiary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'iOS',
                        style: GoogleFonts.jetBrainsMono(
                          color: AppColors.textTertiary,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: isFeatured ? 18 : 14),
            Text(
              title,
              style: GoogleFonts.outfit(
                color: AppColors.textPrimary,
                fontSize: isFeatured ? 18 : 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              desc,
              style: GoogleFonts.outfit(
                color: AppColors.textTertiary,
                fontSize: isFeatured ? 14 : 12,
                height: 1.4,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// FOOTER
// ============================================================================

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Subtle gradient divider
        Container(
          height: 1,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                AppColors.border.withOpacity(0.5),
                Colors.transparent,
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          '// built with Flutter & ❤️ by Ganesh Manickam © ${DateTime.now().year}',
          textAlign: TextAlign.center,
          style: GoogleFonts.jetBrainsMono(
            color: AppColors.textTertiary.withOpacity(0.5),
            fontSize: 12,
            letterSpacing: 0.5,
          ),
        ),
      ],
    ).animate().fadeIn(delay: 200.ms);
  }
}
