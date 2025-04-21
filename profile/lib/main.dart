import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart'; // Import google_fonts

// --- Main App Setup ---
void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Define the retro pastel color scheme

    final ColorScheme retroPastelScheme = ColorScheme.light(
      primary: const Color(0xFF007AFF), // iOS System Blue
      secondary: const Color(0xFF34C759), // iOS System Green
      background: const Color(0xFFF2F2F7), // System Gray6 (very light gray)
      surface: const Color(0xFFFFFFFF), // Pure white (used in cards and sheets)
      onPrimary: Colors.white, // Text/icons on primary
      onSecondary: Colors.white, // Text/icons on secondary
      onBackground: const Color(0xFF1C1C1E), // System Gray1 (dark text)
      onSurface: const Color(0xFF1C1C1E), // Text on white surfaces
      error: const Color(0xFFFF3B30), // iOS System Red
      onError: Colors.white,
      brightness: Brightness.light,
    );

    return MaterialApp(
      title: 'Ganesh Manickam | Portfolio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: retroPastelScheme,
        useMaterial3: true, // Keep M3 features but override styles
        // Use a monospaced font for the retro tech feel
        fontFamily: GoogleFonts.sourceCodePro().fontFamily,
        scaffoldBackgroundColor: retroPastelScheme.background,
        appBarTheme: AppBarTheme(
          backgroundColor: retroPastelScheme.surface,
          foregroundColor: retroPastelScheme.onSurface,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: retroPastelScheme.primary,
            foregroundColor: retroPastelScheme.onPrimary,
            shape: RoundedRectangleBorder(
              // Sharper corners for buttons
              borderRadius: BorderRadius.circular(4),
            ),
            elevation: 2, // Reduced elevation
          ),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: retroPastelScheme.secondary,
          labelStyle: TextStyle(color: retroPastelScheme.onSecondary),
          shape: RoundedRectangleBorder(
            // Sharper corners for chips
            borderRadius: BorderRadius.circular(4),
          ),
          side: BorderSide.none,
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        ),
        cardTheme: CardTheme(
          // Default card theme (though we override in BentoCard)
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
            side: BorderSide(
              color: retroPastelScheme.primary.withOpacity(0.5),
              width: 1,
            ),
          ),
          color: retroPastelScheme.surface,
        ),
        textTheme: TextTheme(
          // Ensure text uses the font
          displayLarge: GoogleFonts.sourceCodePro(
            color: retroPastelScheme.onBackground,
          ),
          displayMedium: GoogleFonts.sourceCodePro(
            color: retroPastelScheme.onBackground,
          ),
          displaySmall: GoogleFonts.sourceCodePro(
            color: retroPastelScheme.onBackground,
          ),
          headlineLarge: GoogleFonts.sourceCodePro(
            color: retroPastelScheme.onBackground,
            fontWeight: FontWeight.bold,
          ),
          headlineMedium: GoogleFonts.sourceCodePro(
            color: retroPastelScheme.onBackground,
            fontWeight: FontWeight.bold,
          ),
          headlineSmall: GoogleFonts.sourceCodePro(
            color: retroPastelScheme.onBackground,
            fontWeight: FontWeight.bold,
          ),
          titleLarge: GoogleFonts.sourceCodePro(
            color: retroPastelScheme.onBackground,
            fontWeight: FontWeight.bold,
          ),
          titleMedium: GoogleFonts.sourceCodePro(
            color: retroPastelScheme.onSurface,
          ),
          titleSmall: GoogleFonts.sourceCodePro(
            color: retroPastelScheme.onSurface,
          ),
          bodyLarge: GoogleFonts.sourceCodePro(
            color: retroPastelScheme.onBackground,
          ),
          bodyMedium: GoogleFonts.sourceCodePro(
            color: retroPastelScheme.onSurface,
          ),
          bodySmall: GoogleFonts.sourceCodePro(
            color: retroPastelScheme.onSurface.withOpacity(0.8),
          ),
          labelLarge: GoogleFonts.sourceCodePro(
            color: retroPastelScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ), // For buttons
          labelMedium: GoogleFonts.sourceCodePro(
            color: retroPastelScheme.onSecondary,
          ), // For chips
          labelSmall: GoogleFonts.sourceCodePro(
            color: retroPastelScheme.onBackground,
          ),
        ),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24), // Slightly more padding
        child: Center(
          // Center content horizontally
          child: ConstrainedBox(
            // Limit max width for better readability on wide screens
            constraints: const BoxConstraints(maxWidth: 1000),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.center, // Center align sections
              children: [
                const ProfileCard(),
                const SizedBox(height: 32),
                const HeroSection(),
                const SizedBox(height: 32),
                const SkillsAndAboutSection(),
                const SizedBox(height: 40),
                const SectionTitle(title: '// Experience'), // Add comment style
                const SizedBox(height: 16),
                const ExperienceSection(),
                const SizedBox(height: 40),
                const SectionTitle(
                  title: '// Notable Projects',
                ), // Add comment style
                const SizedBox(height: 16),
                const ProjectsSection(),
                const SizedBox(height: 40),
                const FooterSection(),
              ],
            ),
          ),
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
        color: Theme.of(context).colorScheme.primary, // Use primary color
        // letterSpacing: 1.5, // Optional: Add letter spacing
      ),
    );
  }
}

// --- Hero Section ---
class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Text styles from theme
    final headlineStyle = Theme.of(context).textTheme.headlineLarge;
    final subheadlineStyle = Theme.of(context).textTheme.titleLarge;

    return Column(
      // Keep column but center text within it
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Ganesh Manickam',
          style: headlineStyle,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'TechLead-iOS | Mobile App Architect',
          style: subheadlineStyle?.copyWith(
            fontWeight: FontWeight.normal,
          ), // Make subtitle slightly lighter
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.center, // Center the wrap content
          children: [
            _socialButton('GitHub', 'https://github.com/GaneshManickam'),
            _socialButton('LinkedIn', 'https://linkedin.com/in/ganeshmanickam'),
            _socialButton(
              'Stack Overflow',
              'https://stackoverflow.com/users/6540962/ganesh-manickam',
            ),
          ],
        ),
      ],
    );
  }

  // Use ElevatedButton with theme styling
  Widget _socialButton(String label, String url) {
    return ElevatedButton(
      onPressed: () => launchUrl(Uri.parse(url)),
      child: Text(label), // Theme handles text style via labelLarge
    );
  }
}

// --- Profile Card ---
class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: 160,
      height: 160,
      decoration: BoxDecoration(
        // Make it slightly less round, more retro-boxy
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(8), // Small radius
        image: const DecorationImage(
          image: AssetImage(
            'assets/profile.jpg',
          ), // ENSURE THIS PATH IS CORRECT
          fit: BoxFit.cover,
        ),
        // Replace shadow with border
        border: Border.all(
          color: colorScheme.primary, // Use primary color for border
          width: 3, // Make border noticeable
        ),
      ),
    );
  }
}

// --- Skills And About Section ---
class SkillsAndAboutSection extends StatelessWidget {
  const SkillsAndAboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Changed Wrap to Column
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.stretch, // Make children fill width
      children: const [
        BentoCard(
          title: '/* About Me */', // Comment style title
          content:
              'Results-driven Senior iOS Developer with 8+ years of experience designing, developing, and deploying high-performance iOS apps and SDKs. Expert in Swift, Objective-C, SwiftUI, and architecture patterns like VIPER, MVVM, and MVC. Proven leader in optimizing app performance, integrating third-party SDKs, and mentoring teams. Delivered 15+ apps across domains including FinTech, E-Commerce, Health, and Streaming.',
        ),
        SizedBox(height: 24), // Add vertical spacing between cards
        SkillsSection(),
      ],
    );
  }
}

// --- Skills Section ---
class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  final skills = const [
    'Swift', 'Objective-C', 'SwiftUI', 'UIKit', 'Flutter', 'Firebase',
    'Socket.IO', 'iOS', 'IoT', 'Bluetooth', 'GPS', 'HLS Streaming',
    'SDK Development', 'SPM', // Added a few more
  ];

  @override
  Widget build(BuildContext context) {
    return BentoCard(
      title: '/* Skills */', // Comment style title
      contentWidget: Wrap(
        spacing: 8,
        runSpacing: 8,
        children:
            skills
                .map(
                  (skill) => Chip(
                    label: Text(skill),
                    // Theme handles chip styling now
                  ),
                )
                .toList(),
      ),
    );
  }
}

// --- Experience Section ---
class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 24,
      runSpacing: 24,
      alignment: WrapAlignment.center,
      children: const [
        // Using a common card for consistency
        InfoCard(
          title: 'ZebPay',
          subtitle: 'Senior Software Developer-2',
          details: 'Sep 2023 - Present',
          imageAsset: 'assets/zebpay_logo.jpeg', // Example icon
        ),
        InfoCard(
          title: 'Jio Platforms Limited',
          subtitle: 'SDE-3',
          details: 'May 2021 - Sep 2023',
          imageAsset: 'assets/jio_logo.jpeg',
        ),
        InfoCard(
          title: 'Flexible Fitness Online Pvt Ltd',
          subtitle: 'Tech Lead - iOS',
          details: 'April 2020 - April 2021',
          imageAsset: 'assets/auro_logo.png', // Example icon
        ),
        InfoCard(
          title: 'Ailoitte Technologies',
          subtitle: 'Senior iOS Developer',
          details: 'Aug 2018 - April 2020',
          imageAsset: 'assets/ailoitte_logo.jpeg', // Example icon
        ),
        InfoCard(
          title: 'Socedge Technologies',
          subtitle: 'iOS Developer',
          details: 'June 2017 - Aug 2018',
          imageAsset: 'assets/socedge_logo.jpeg', // Example icon
        ),
        InfoCard(
          title: 'Red Web\nSolutions',
          subtitle: 'iOS Developer',
          details: 'May 2016 - May 2017',
          imageAsset: 'assets/redweb_logo.png', // Example icon
        ),
      ],
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
        'url':
            'https://apps.apple.com/in/app/zebpay-buy-bitcoin-crypto/id944854686',
        'desc':
            'ZebPay is a user-friendly cryptocurrency exchange app for buying, selling, and trading various cryptocurrencies like Bitcoin and Ethereum. It suits both beginners and experienced traders with its intuitive interface.',
        'image': 'assets/zebpay_app_icon.png',
      },
      {
        'title': 'AJIO',
        'url':
            'https://apps.apple.com/in/app/ajio-online-shopping-app/id1113425372',
        'desc':
            'AJIO is an online fashion and lifestyle shopping platform from Reliance Retail in India. It offers a wide selection of clothing, footwear, accessories, beauty products, gadgets, and home furnishings.',
        'image': 'assets/ajio_app_icon.png',
      },
      {
        'title': 'Auro',
        'url':
            'https://apps.apple.com/gb/app/auro-home-outdoor-workouts/id1200805964',
        'desc':
            'Auro provides audio-guided fitness workouts for various activities and goals, led by expert trainers. Exercise at home, outdoors, or in the gym without constant screen monitoring. Integrates with music and wearables.',
        'image': 'assets/auro_app_icon.jpg',
      },
      {
        'title': 'Fullerton Markets',
        'url': 'https://apps.apple.com/us/app/fullerton-markets/id1458847859',
        'desc':
            'Fullerton Markets offers an iOS app for enhanced trading on iPhones and iPads. It features an intuitive interface, fast deposit/withdrawal, real-time market alerts, news, and convenient document uploads.',
        'image': 'assets/fullerton_app_icon.png',
      },
      {
        'title': 'Cakap',
        'url':
            'https://apps.apple.com/us/app/cakap-online-language-learning/id1434645453',
        'desc':
            'Cakap is an online language learning platform connecting Indonesian students with native teachers for English and other languages via video calls. It offers live one-on-one and group classes for all levels.',
        'image': 'assets/cakap_app_icon.png',
      },
      {
        'title': 'SOS Method',
        'url':
            'https://apps.apple.com/in/app/sos-method-stress-anxiety/id1363278866',
        'desc':
            'SOSmethod helps users manage stress, anxiety, depression, and trauma by addressing "Generational Trauma." It offers programs and meditations using music, tones, and words for inner well-being.',
        'image': 'assets/sos_method_app_icon.png',
      },
    ];

    return Wrap(
      spacing: 24,
      runSpacing: 24,
      alignment: WrapAlignment.center,
      children:
          projects
              .map(
                (project) => ProjectCard(
                  title: project['title'] as String,
                  link: project['url'] as String,
                  description: project['desc'] as String,
                  imageAsset: project['image'] as String?, // Pass icon
                ),
              )
              .toList(),
    );
  }
}

// --- Project Card --- (Modified to look similar to InfoCard/Bento)
class ProjectCard extends StatelessWidget {
  final String title;
  final String description;
  final String link;
  final IconData? icon; // Optional icon
  final String? imageAsset; // Optional asset image

  const ProjectCard({
    super.key,
    required this.title,
    required this.description,
    required this.link,
    this.icon,
    this.imageAsset,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: () => launchUrl(Uri.parse(link)),
      child: Container(
        width: 280,
        height: 255,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: colorScheme.primary, width: 1.5),
        ),
        child: Stack(
          children: [
            // Main content
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (imageAsset != null)
                  SizedBox(
                    height: 48,
                    child: Image.asset(imageAsset!, fit: BoxFit.contain),
                  )
                else if (icon != null)
                  Icon(icon, size: 48, color: colorScheme.primary),

                const SizedBox(height: 12),
                Text(title, style: textTheme.titleLarge),
                const SizedBox(height: 4),
                Text(description, style: textTheme.bodySmall),
              ],
            ),

            // Positioned link icon at top-right
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                icon: Icon(Icons.open_in_new, color: colorScheme.primary),
                iconSize: 20,
                tooltip: 'Open Project',
                onPressed: () => launchUrl(Uri.parse(link)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Bento Card (Base card style) ---
class BentoCard extends StatelessWidget {
  final String title;
  final String? content;
  final Widget? contentWidget;
  final IconData? icon; // Optional icon

  const BentoCard({
    super.key,
    required this.title,
    this.content,
    this.contentWidget,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: 300, // Keep consistent width or make responsive
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface, // Use surface color from theme
        borderRadius: BorderRadius.circular(4), // Sharper corners
        border: Border.all(
          // Add border instead of shadow
          color: colorScheme.primary, // Use primary color for border
          width: 1.5,
        ),
        // Removed boxShadow
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            // Row for icon and title
            children: [
              if (icon != null) ...[
                Icon(icon, color: colorScheme.primary, size: 24),
                const SizedBox(width: 8),
              ],
              Expanded(
                // Allow title to take remaining space
                child: Text(
                  title,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12), // Increased spacing
          if (content != null) Text(content!, style: textTheme.bodyMedium),
          if (contentWidget != null) contentWidget!,
        ],
      ),
    );
  }
}

// --- Info Card (For Experience/Education) ---
// Simplified card using the same styling principles as BentoCard
class InfoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String details;
  final IconData? icon; // Optional icon
  final String? imageAsset; // Optional image asset path

  const InfoCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.details,
    this.icon,
    this.imageAsset,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: 280,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: colorScheme.primary, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Display asset image if available, else fallback to icon
          if (imageAsset != null)
            SizedBox(
              height: 48,
              child: Image.asset(imageAsset!, fit: BoxFit.contain),
            )
          else if (icon != null)
            Icon(icon, size: 48, color: colorScheme.primary),

          const SizedBox(height: 12),
          Text(title, style: textTheme.titleLarge),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.secondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(details, style: textTheme.bodySmall),
        ],
      ),
    );
  }
}

// --- Footer Section ---
class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 24.0,
      ), // More vertical padding
      child: Text(
        '// © ${DateTime.now().year} M. Ganesh Manickam. Built with Flutter. ✨',
        style: textTheme.bodySmall?.copyWith(
          color: colorScheme.onBackground.withOpacity(
            0.7,
          ), // Slightly faded text
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
