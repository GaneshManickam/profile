import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart' as ul;

import '../core/motion.dart';
import '../core/page_scope.dart';
import '../core/scene_3d.dart';
import '../data/models.dart';
import '../data/portfolio_data.dart';
import '../theme/app_theme.dart';
import '../widgets/buttons.dart';
import '../widgets/device_frames.dart';
import '../widgets/phone_screens.dart';
import '../widgets/surfaces.dart';
import '../widgets/tech_logos.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    final size = Breakpoints.of(context);
    final desktop = size == ScreenSize.desktop;

    final copy = const _ContactCopy();
    final scene = _ContactScene(
      height: desktop ? 560 : (size == ScreenSize.mobile ? 420 : 500),
    );

    return Column(
      children: [
        Reveal(
          scale: 0.97,
          child: Container(
            padding: EdgeInsets.all(
              desktop ? 56 : (size == ScreenSize.mobile ? 20 : 36),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(desktop ? 40 : 28),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.cyan.withValues(alpha: 0.07),
                  AppColors.surface.withValues(alpha: 0.6),
                  AppColors.violet.withValues(alpha: 0.08),
                ],
              ),
              border: Border.all(color: AppColors.border),
            ),
            child:
                desktop
                    ? Row(
                      children: [
                        Expanded(flex: 12, child: copy),
                        const SizedBox(width: 32),
                        Expanded(flex: 9, child: scene),
                      ],
                    )
                    : Column(
                      children: [copy, const SizedBox(height: 16), scene],
                    ),
          ),
        ),
        const SizedBox(height: 56),
        const _Footer(),
        SizedBox(height: MediaQuery.paddingOf(context).bottom + 32),
      ],
    );
  }
}

class _ContactCopy extends StatelessWidget {
  const _ContactCopy();

  @override
  Widget build(BuildContext context) {
    final p = PortfolioData.profile;
    final size = Breakpoints.of(context);
    final titleSize = switch (size) {
      ScreenSize.mobile => 38.0,
      ScreenSize.tablet => 52.0,
      ScreenSize.desktop => 62.0,
    };
    final links = <SocialLink>[
      if (p.email != null)
        SocialLink(
          label: 'Email',
          url: 'mailto:${p.email}',
          kind: SocialKind.email,
          handle: p.email,
        ),
      ...PortfolioData.socials,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('06', style: AppText.mono(12, color: AppColors.cyan)),
            Container(
              width: 28,
              height: 1,
              margin: const EdgeInsets.symmetric(horizontal: 12),
              color: AppColors.cyan.withValues(alpha: 0.5),
            ),
            Text(
              'CONTACT',
              style: AppText.mono(
                12,
                color: AppColors.textSecondary,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Semantics(
          header: true,
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "Let's Build Something ",
                  style: AppText.display(titleSize),
                ),
                WidgetSpan(
                  alignment: PlaceholderAlignment.baseline,
                  baseline: TextBaseline.alphabetic,
                  child: GradientText(
                    'Great',
                    style: AppText.display(titleSize),
                  ),
                ),
                TextSpan(text: ' Together.', style: AppText.display(titleSize)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Text(
            'Building a new product, scaling an existing app, or need a hand '
            'with architecture and performance? I’d love to hear about it.',
            style: AppText.body(size == ScreenSize.mobile ? 15.5 : 17),
          ),
        ),
        const SizedBox(height: 28),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            AppButton(
              label: p.email != null ? 'Say hello' : 'Connect on LinkedIn',
              icon: Icons.north_east_rounded,
              url:
                  p.email != null
                      ? 'mailto:${p.email}'
                      : PortfolioData.socials
                          .firstWhere((s) => s.kind == SocialKind.linkedin)
                          .url,
            ),
            if (p.resumeUrl != null)
              AppButton(
                label: 'Download Resume',
                icon: Icons.download_rounded,
                style: AppButtonStyle.ghost,
                url: p.resumeUrl,
              ),
          ],
        ),
        const SizedBox(height: 32),
        for (final l in links) _ContactRow(link: l),
      ],
    );
  }
}

class _ContactRow extends StatefulWidget {
  const _ContactRow({required this.link});

  final SocialLink link;

  @override
  State<_ContactRow> createState() => _ContactRowState();
}

class _ContactRowState extends State<_ContactRow> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final l = widget.link;
    return ul.Link(
      uri: Uri.parse(l.url),
      target: ul.LinkTarget.blank,
      builder:
          (context, open) => Semantics(
            link: true,
            label: '${l.label}: ${l.handle ?? l.url}',
            excludeSemantics: true,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              onEnter: (_) => setState(() => _hover = true),
              onExit: (_) => setState(() => _hover = false),
              child: GestureDetector(
                onTap: open,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 4,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color:
                            _hover
                                ? AppColors.cyan.withValues(alpha: 0.5)
                                : AppColors.border,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      SocialGlyph(
                        l.kind,
                        size: 18,
                        color:
                            _hover ? AppColors.cyan : AppColors.textSecondary,
                      ),
                      const SizedBox(width: 14),
                      SizedBox(
                        width: 120,
                        child: Text(l.label, style: AppText.title(15)),
                      ),
                      Expanded(
                        child: Text(
                          l.handle ?? '',
                          overflow: TextOverflow.ellipsis,
                          style: AppText.mono(
                            12.5,
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ),
                      AnimatedSlide(
                        offset: _hover ? const Offset(0.2, -0.2) : Offset.zero,
                        duration: const Duration(milliseconds: 220),
                        child: Icon(
                          Icons.north_east_rounded,
                          size: 18,
                          color:
                              _hover ? AppColors.cyan : AppColors.textTertiary,
                        ),
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

class _ContactScene extends StatelessWidget {
  const _ContactScene({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    final mobile = Breakpoints.of(context) == ScreenSize.mobile;
    final phoneW = mobile ? 170.0 : 210.0;
    final k = phoneW / 210;
    final socials = PortfolioData.socials;

    return Semantics(
      label: 'Phone displaying a contact screen',
      child: ExcludeSemantics(
        child: ViewportTickerGate(
          child: SizedBox(
            height: height,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Connection rings radiating from the phone.
                const IgnorePointer(child: _Ripples()),
                Positioned.fill(
                  child: Scene3D(
                    baseRotateY: 0.3,
                    baseRotateX: -0.05,
                    orbitAmplitude: 0.16,
                    nodes: [
                      SceneNode(
                        bob: 6,
                        thickness: 10 * k,
                        edge: PhoneFrame.edge(phoneW),
                        child: PhoneFrame(
                          width: phoneW,
                          glow: AppColors.violet,
                          child: const ContactScreenUI(),
                        ),
                      ),
                      for (var i = 0; i < socials.length; i++)
                        SceneNode(
                          x: (i.isEven ? -1 : 1) * (mobile ? 112 : 150) * k,
                          y: (-140 + i * 130) * k,
                          depth: 90 + i * 30,
                          bob: 9,
                          bobPhase: i * 1.7,
                          spin: 0.25,
                          child: LogoBadge(
                            size: 54 * k,
                            gradient: const [
                              Color(0xFF1D2233),
                              Color(0xFF0B0D14),
                            ],
                            glow: i.isEven ? AppColors.cyan : AppColors.violet,
                            child: SocialGlyph(
                              socials[i].kind,
                              size: 24 * k,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Ripples extends StatefulWidget {
  const _Ripples();

  @override
  State<_Ripples> createState() => _RipplesState();
}

class _RipplesState extends State<_Ripples>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 4),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (Motion.reduced(context)) {
      _c.value = 0.5;
    } else if (!_c.isAnimating) {
      _c.repeat();
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder:
          (context, _) => CustomPaint(
            size: const Size(460, 460),
            painter: _RipplePainter(_c.value),
          ),
    );
  }
}

class _RipplePainter extends CustomPainter {
  _RipplePainter(this.t);

  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    for (var i = 0; i < 3; i++) {
      final f = (t + i / 3) % 1.0;
      canvas.drawCircle(
        c,
        60 + f * 170,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2
          ..color = Color.lerp(
            AppColors.cyan,
            AppColors.violet,
            f,
          )!.withValues(alpha: 0.35 * (1 - f)),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _RipplePainter old) => old.t != t;
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    final p = PortfolioData.profile;
    final scope = PageScope.of(context);
    final reduce = Motion.reduced(context);
    return Column(
      children: [
        Container(
          height: 1,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                AppColors.borderStrong,
                Colors.transparent,
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 16,
          runSpacing: 16,
          children: [
            Text.rich(
              TextSpan(
                style: AppText.mono(12, color: AppColors.textTertiary),
                children: [
                  const TextSpan(text: '// built with Flutter & '),
                  const WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: Icon(
                      Icons.favorite_rounded,
                      size: 13,
                      color: AppColors.pink,
                      semanticLabel: 'love',
                    ),
                  ),
                  TextSpan(text: ' by ${p.name} © ${DateTime.now().year}'),
                ],
              ),
            ),
            TextButton.icon(
              onPressed:
                  () => scope.scrollTo(SectionId.home, reduceMotion: reduce),
              icon: const Icon(
                Icons.arrow_upward_rounded,
                size: 16,
                color: AppColors.textSecondary,
              ),
              label: Text(
                'Back to top',
                style: AppText.mono(12, color: AppColors.textSecondary),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
