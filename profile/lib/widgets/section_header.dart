import 'package:flutter/material.dart';

import '../core/motion.dart';
import '../theme/app_theme.dart';

/// Section opener: mono index + eyebrow, large title, optional lede.
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.index,
    required this.eyebrow,
    required this.title,
    this.lede,
    this.centered = false,
  });

  final String index;
  final String eyebrow;
  final String title;
  final String? lede;
  final bool centered;

  @override
  Widget build(BuildContext context) {
    final size = Breakpoints.of(context);
    final titleSize = switch (size) {
      ScreenSize.mobile => 34.0,
      ScreenSize.tablet => 44.0,
      ScreenSize.desktop => 54.0,
    };
    final align =
        centered ? CrossAxisAlignment.center : CrossAxisAlignment.start;
    final textAlign = centered ? TextAlign.center : TextAlign.start;

    return Reveal(
      child: Column(
        crossAxisAlignment: align,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(index, style: AppText.mono(12, color: AppColors.cyan)),
              Container(
                width: 28,
                height: 1,
                margin: const EdgeInsets.symmetric(horizontal: 12),
                color: AppColors.cyan.withValues(alpha: 0.5),
              ),
              Text(
                eyebrow.toUpperCase(),
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
            child: Text(
              // Hard line breaks are for wide layouts; let phones wrap freely.
              size == ScreenSize.mobile ? title.replaceAll('\n', ' ') : title,
              textAlign: textAlign,
              style: AppText.display(titleSize),
            ),
          ),
          if (lede != null) ...[
            const SizedBox(height: 18),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 620),
              child: Text(
                lede!,
                textAlign: textAlign,
                style: AppText.body(size == ScreenSize.mobile ? 15.5 : 17),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
