import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Centralised design tokens for the portfolio.
///
/// Deep charcoal surfaces, an electric-cyan primary accent and a violet
/// secondary accent. Everything else is derived from these.
class AppColors {
  AppColors._();

  // Backgrounds
  static const background = Color(0xFF06070B);
  static const backgroundRaised = Color(0xFF0B0D14);
  static const surface = Color(0xFF10131C);
  static const surfaceHigh = Color(0xFF161A26);

  // Lines
  static const border = Color(0x14FFFFFF); // 8% white
  static const borderStrong = Color(0x26FFFFFF); // 15% white

  // Text
  static const textPrimary = Color(0xFFF3F5F9);
  static const textSecondary = Color(0xFFA3ACBD);
  static const textTertiary = Color(0xFF6B7385);

  // Accents
  static const cyan = Color(0xFF3DE0FF);
  static const violet = Color(0xFF8B6CFF);
  static const green = Color(0xFF34D399);
  static const amber = Color(0xFFFBBF24);
  static const pink = Color(0xFFF472B6);

  static const accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [cyan, violet],
  );

  /// Device bezels / brushed metal.
  static const metalLight = Color(0xFF3A3F4D);
  static const metalDark = Color(0xFF15171E);
}

/// Typography: geometric display (Sora), neutral body (Inter), mono accents.
///
/// Every weight is a separate font file fetched at start-up, so weights are
/// snapped to a small set: Sora 600/700, Inter 400/600, JetBrains Mono 500.
class AppText {
  AppText._();

  static FontWeight _sora(FontWeight? w) =>
      (w ?? FontWeight.w600).value >= 700 ? FontWeight.w700 : FontWeight.w600;

  static FontWeight _inter(FontWeight? w) =>
      (w ?? FontWeight.w400).value >= 600 ? FontWeight.w600 : FontWeight.w400;

  static TextStyle display(double size, {Color? color, FontWeight? weight}) =>
      GoogleFonts.sora(
        fontSize: size,
        fontWeight: _sora(weight ?? FontWeight.w700),
        letterSpacing: -size * 0.035,
        height: 1.05,
        color: color ?? AppColors.textPrimary,
      );

  static TextStyle title(double size, {Color? color, FontWeight? weight}) =>
      GoogleFonts.sora(
        fontSize: size,
        fontWeight: _sora(weight),
        letterSpacing: -size * 0.015,
        height: 1.25,
        color: color ?? AppColors.textPrimary,
      );

  static TextStyle body(
    double size, {
    Color? color,
    FontWeight? weight,
    double height = 1.6,
  }) => GoogleFonts.inter(
    fontSize: size,
    fontWeight: _inter(weight),
    height: height,
    color: color ?? AppColors.textSecondary,
  );

  static TextStyle mono(
    double size, {
    Color? color,
    FontWeight? weight,
    double letterSpacing = 0,
  }) => GoogleFonts.jetBrainsMono(
    fontSize: size,
    // One mono weight only; emphasis comes from colour.
    fontWeight: FontWeight.w500,
    letterSpacing: letterSpacing,
    height: 1.4,
    color: color ?? AppColors.textTertiary,
  );
}

/// Responsive breakpoints.
enum ScreenSize { mobile, tablet, desktop }

class Breakpoints {
  Breakpoints._();

  static const mobile = 640.0;
  static const tablet = 1024.0;
  static const maxContentWidth = 1180.0;

  static ScreenSize of(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    if (w < mobile) return ScreenSize.mobile;
    if (w < tablet) return ScreenSize.tablet;
    return ScreenSize.desktop;
  }

  static double gutter(BuildContext context) => switch (of(context)) {
    ScreenSize.mobile => 20,
    ScreenSize.tablet => 32,
    ScreenSize.desktop => 48,
  };

  static double sectionSpacing(BuildContext context) => switch (of(context)) {
    ScreenSize.mobile => 96,
    ScreenSize.tablet => 128,
    ScreenSize.desktop => 168,
  };
}

ThemeData buildAppTheme() {
  final base = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.cyan,
      secondary: AppColors.violet,
      surface: AppColors.surface,
    ),
    splashFactory: NoSplash.splashFactory,
    highlightColor: Colors.transparent,
  );
  return base.copyWith(
    // Point the default text theme at Inter (regular) without pulling in
    // every weight the Material text theme declares.
    textTheme: base.textTheme.apply(fontFamily: GoogleFonts.inter().fontFamily),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: AppColors.surfaceHigh,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderStrong),
      ),
      textStyle: AppText.mono(11, color: AppColors.textPrimary),
    ),
  );
}
