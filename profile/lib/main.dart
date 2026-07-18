import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

// --- Main App Setup ---
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
        scaffoldBackgroundColor: Colors.black,
        primaryColor: const Color(0xFF007AFF),
        textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme),
        useMaterial3: true,
      ),
      home: const PortfolioHomePage(),
    );
  }
}

// --- Portfolio Home Page ---
class PortfolioHomePage extends StatelessWidget {
  const PortfolioHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // 1. Animated Liquid Background
          const LiquidBackground(),

          // 2. Scrollable Content
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: 24,
              vertical: MediaQuery.of(context).padding.top + 24,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    const HeroSection(),
                    const SizedBox(height: 48),

                    // Glass Divider
                    const GlassDivider(),
                    const SizedBox(height: 48),

                    const SectionTitle(title: 'About Me'),
                    const SizedBox(height: 16),
                    const AboutSection(),
                    const SizedBox(height: 48),

                    const SectionTitle(title: 'Skills'),
                    const SizedBox(height: 16),
                    const SkillsSection(),
                    const SizedBox(height: 48),

                    const SectionTitle(title: 'Experience'),
                    const SizedBox(height: 16),
                    const ExperienceSection(),
                    const SizedBox(height: 48),

                    const SectionTitle(title: 'Notable Projects'),
                    const SizedBox(height: 16),
                    const ProjectsSection(),

                    const SizedBox(height: 60),
                    const FooterSection(),
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

// --- 1. Liquid Background Logic ---
class LiquidBackground extends StatelessWidget {
  const LiquidBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Dark base
        Container(color: const Color(0xFF050510)),

        // Animated Blobs
        Positioned(
          top: -100,
          left: -100,
          child: _AnimatedBlob(
            color: const Color(0xFF007AFF).withOpacity(0.4),
            size: 500,
          ),
        ),
        Positioned(
          bottom: -200,
          right: -100,
          child: _AnimatedBlob(
            color: const Color(0xFFAF52DE).withOpacity(0.4),
            size: 600,
          ),
        ),
        Positioned(
          top: 200,
          right: -150,
          child: _AnimatedBlob(
            color: const Color(0xFF34C759).withOpacity(0.3),
            size: 400,
            duration: 6.seconds,
          ),
        ),

        // Overlay blur to mesh them together
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
          child: Container(color: Colors.transparent),
        ),
      ],
    );
  }
}

class _AnimatedBlob extends StatelessWidget {
  final Color color;
  final double size;
  final Duration duration;

  const _AnimatedBlob({
    required this.color,
    required this.size,
    this.duration = const Duration(seconds: 5),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            boxShadow: [
              BoxShadow(color: color, blurRadius: 100, spreadRadius: 50),
            ],
          ),
        )
        .animate(onPlay: (controller) => controller.repeat(reverse: true))
        .scale(
          begin: const Offset(1.0, 1.0),
          end: const Offset(1.2, 1.2),
          duration: duration,
          curve: Curves.easeInOut,
        )
        .move(
          begin: const Offset(0, 0),
          end: const Offset(30, -30),
          duration: duration,
          curve: Curves.easeInOut,
        );
  }
}

// --- 2. Glass Container (Core UI Component) ---
class GlassContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final Color? color;
  final double? width;
  final double? height;

  const GlassContainer({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24),
    this.borderRadius = 24,
    this.color,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          width: width,
          height: height,
          padding: padding,
          decoration: BoxDecoration(
            color: (color ?? Colors.white).withOpacity(0.08),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
          ),
          child: child,
        ),
      ),
    );
  }
}

class GlassDivider extends StatelessWidget {
  const GlassDivider({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      width: double.infinity,
      color: Colors.white.withOpacity(0.1),
    );
  }
}

// --- Hero Section ---
// --- Hero Section ---
class HeroSection extends StatefulWidget {
  const HeroSection({super.key});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> {
  AnimationController? _flipController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Profile Image with Glow
        GestureDetector(
          onTap: () {
            _flipController?.forward(from: 0);
          },
          child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 4,
                  ),
                  image: const DecorationImage(
                    image: AssetImage('assets/profile.jpg'),
                    fit: BoxFit.cover,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF007AFF).withOpacity(0.4),
                      blurRadius: 30,
                      spreadRadius: 10,
                    ),
                  ],
                ),
              )
              .animate(onInit: (controller) => _flipController = controller)
              .flip(
                duration: 400.ms,
                direction: Axis.horizontal,
                curve: Curves.linear,
                begin: 0,
                end: 1,
              )
              .then()
              .flip(
                duration: 600.ms,
                direction: Axis.horizontal,
                curve: Curves.linear,
                begin: 0,
                end: 1,
              )
              .then()
              .flip(
                duration: 1000.ms,
                direction: Axis.horizontal,
                curve: Curves.easeOut,
                begin: 0,
                end: 1,
              )
              .animate()
              .fadeIn(duration: 800.ms)
              .scale(curve: Curves.easeOutBack),
        ),

        const SizedBox(height: 24),

        JellyButton(
          onTap: () {},
          child: Text(
            'Ganesh Manickam',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
        ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.3, end: 0),

        const SizedBox(height: 8),

        JellyButton(
          onTap: () {},
          child: Text(
            'Staff Engineer - iOS | Mobile App Architect',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white.withOpacity(0.7),
              fontWeight: FontWeight.w300,
            ),
          ),
        ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.3, end: 0),

        const SizedBox(height: 32),

        Wrap(
          spacing: 16,
          runSpacing: 16,
          alignment: WrapAlignment.center,
          children: [
            _SocialButton(
              label: 'GitHub',
              url: 'https://github.com/GaneshManickam',
              icon: Icons.code,
            ),
            _SocialButton(
              label: 'LinkedIn',
              url: 'https://linkedin.com/in/ganeshmanickam',
              icon: Icons.work,
            ),
            _SocialButton(
              label: 'Stack Overflow',
              url: 'https://stackoverflow.com/users/6540962/ganesh-manickam',
              icon: Icons.question_answer,
            ),
          ],
        ).animate().fadeIn(delay: 600.ms),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String label;
  final String url;
  final IconData icon;

  const _SocialButton({
    required this.label,
    required this.url,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return JellyButton(
      onTap: () => launchUrl(Uri.parse(url)),
      borderRadius: BorderRadius.circular(50),
      child: GlassContainer(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        borderRadius: 50,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Section Title ---
class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    ).animate().fadeIn().slideX(begin: -0.1, end: 0);
  }
}

// --- About Section ---
class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  String get _calculatedExperience {
    final startDate = DateTime(2016, 5); // May 2016
    final now = DateTime.now();
    final difference = now.difference(startDate).inDays / 365.25;
    return difference.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      width: double.infinity,
      child: Text(
        'Results-driven Staff Engineer with $_calculatedExperience+ years of experience designing, developing, and deploying high-performance iOS apps and SDKs. Expert in Swift, Objective-C, SwiftUI, and architecture patterns like VIPER, MVVM, and MVC. Proven leader in optimizing app performance, integrating third-party SDKs, and mentoring teams. Delivered 15+ apps across domains including FinTech, E-Commerce, Health, and Streaming.',
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: Colors.white.withOpacity(0.9),
          height: 1.6,
        ),
      ),
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0);
  }
}

// --- Skills Section ---
class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  final skills = const [
    'Swift',
    'Objective-C',
    'SwiftUI',
    'UIKit',
    'Flutter',
    'Firebase',
    'Socket.IO',
    'iOS',
    'IoT',
    'Bluetooth',
    'GPS',
    'HLS Streaming',
    'SDK Development',
    'SPM',
    'KMM',
    'CMP',
    'Vibe Coding',
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: skills.map((skill) => _SkillChip(label: skill)).toList(),
    ).animate().fadeIn(delay: 200.ms);
  }
}

class _SkillChip extends StatelessWidget {
  final String label;
  const _SkillChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return JellyButton(
      onTap: () {},
      borderRadius: BorderRadius.circular(12),
      child: GlassContainer(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        borderRadius: 12,
        color: Colors.white.withOpacity(0.05),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

// --- Experience Section ---
class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  @override
  Widget build(BuildContext context) {
    final experiences = const [
      {
        'title': 'ZebPay',
        'role': 'Staff Engineer',
        'date': 'July 2026 - Present',
        'image': 'assets/zebpay_logo.jpeg',
      },
      {
        'title': 'ZebPay',
        'role': 'Senior Software Developer-2',
        'date': 'Sep 2023 - June 2026',
        'image': 'assets/zebpay_logo.jpeg',
      },
      {
        'title': 'Jio Platforms Limited',
        'role': 'SDE-3',
        'date': 'May 2021 - Sep 2023',
        'image': 'assets/jio_logo.jpeg',
      },
      {
        'title': 'Flexible Fitness Online',
        'role': 'Tech Lead - iOS',
        'date': 'April 2020 - April 2021',
        'image': 'assets/auro_logo.png',
      },
      {
        'title': 'Ailoitte Technologies',
        'role': 'Senior iOS Developer',
        'date': 'Aug 2018 - April 2020',
        'image': 'assets/ailoitte_logo.jpeg',
      },
      {
        'title': 'Socedge Technologies',
        'role': 'iOS Developer',
        'date': 'June 2017 - Aug 2018',
        'image': 'assets/socedge_logo.jpeg',
      },
      {
        'title': 'Red Web Solutions',
        'role': 'iOS Developer',
        'date': 'May 2016 - May 2017',
        'image': 'assets/redweb_logo.png',
      },
    ];

    return MasonryGridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: MediaQuery.of(context).size.width > 600 ? 2 : 1,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      itemCount: experiences.length,
      itemBuilder: (context, index) {
        final exp = experiences[index];
        return ExperienceCard(
          title: exp['title']!,
          role: exp['role']!,
          date: exp['date']!,
          image: exp['image']!,
        ).animate().fadeIn(delay: (100 * index).ms).slideY(begin: 0.2, end: 0);
      },
    );
  }
}

class ExperienceCard extends StatelessWidget {
  final String title;
  final String role;
  final String date;
  final String image;

  const ExperienceCard({
    super.key,
    required this.title,
    required this.role,
    required this.date,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return JellyButton(
      onTap: () {},
      borderRadius: BorderRadius.circular(24),
      child: GlassContainer(
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: AssetImage(image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    role,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    date,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Projects Section ---
class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final projects = [
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

    return MasonryGridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      itemCount: projects.length,
      itemBuilder: (context, index) {
        final project = projects[index];
        return ProjectCard(
              title: project['title']!,
              desc: project['desc']!,
              image: project['image']!,
              url: project['url']!,
            )
            .animate()
            .fadeIn(delay: (100 * index).ms)
            .scale(begin: const Offset(0.9, 0.9));
      },
    );
  }
}

class ProjectCard extends StatelessWidget {
  final String title;
  final String desc;
  final String image;
  final String url;

  const ProjectCard({
    super.key,
    required this.title,
    required this.desc,
    required this.image,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return JellyButton(
      onTap: () => launchUrl(Uri.parse(url)),
      borderRadius: BorderRadius.circular(
        24,
      ), // Keep consitent with GlassContainer default
      child: GlassContainer(
        padding: const EdgeInsets.all(16),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    image,
                    height: 60,
                    width: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  desc,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            const Positioned(
              top: 0,
              right: 0,
              child: Icon(Icons.apple, size: 25, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      '© ${DateTime.now().year} M. Ganesh Manickam. Built with Flutter. ✨',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.white.withOpacity(0.3),
        fontSize: 12,
        letterSpacing: 1,
      ),
    );
  }
}

// --- Jelly Button (Bouncy/Jelly Effect) ---
class JellyButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final BorderRadius? borderRadius;

  const JellyButton({
    super.key,
    required this.child,
    required this.onTap,
    this.borderRadius,
  });

  @override
  State<JellyButton> createState() => _JellyButtonState();
}

class _JellyButtonState extends State<JellyButton> {
  AnimationController? _controller;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _controller?.forward(from: 0);
        widget.onTap();
      },
      child: widget.child
          .animate(onInit: (controller) => _controller = controller)
          .scale(
            duration: 200.ms,
            begin: const Offset(1, 1),
            end: const Offset(0.9, 0.9),
            curve: Curves.easeInOut,
          )
          .then()
          .scale(
            duration: 200.ms,
            begin: const Offset(0.9, 0.9),
            end: const Offset(1.05, 1.05),
            curve: Curves.easeInOut,
          )
          .then()
          .scale(
            duration: 200.ms,
            begin: const Offset(1.05, 1.05),
            end: const Offset(0.95, 0.95),
            curve: Curves.easeInOut,
          )
          .then()
          .scale(
            duration: 200.ms,
            begin: const Offset(0.95, 0.95),
            end: const Offset(1, 1),
            curve: Curves.easeInOut,
          ),
    );
  }
}
