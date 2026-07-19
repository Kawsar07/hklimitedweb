import 'package:flutter/material.dart';

/// Font family names, matching the `fonts:` entries registered in
/// pubspec.yaml (assets/fonts/Sora-Variable.ttf, assets/fonts/Manrope-Variable.ttf).
///
/// These used to come from the `google_fonts` package (GoogleFonts.sora(),
/// GoogleFonts.manrope()), which fetches the font file over the network the
/// first time it's used and renders with a fallback font in the meantime.
/// On Flutter *web* specifically, that fallback-then-swap is exactly what
/// caused the "why it works" cards to overflow: the swap to the real font
/// happens after first paint, and anything that had already fixed a card's
/// height based on the fallback font's (different) text-wrapping ends up a
/// line short once the real, usually-taller font swaps in.
///
/// Bundling the two font files locally removes the network fetch and the
/// fallback-font window entirely — the correct font is active from the very
/// first frame, on every device, every time, regardless of network speed.
/// This is also Google's own recommendation for production Flutter web
/// apps (see the "Self-hosting fonts" section of the google_fonts package
/// README) rather than fetching from Google's CDN at runtime.
class AppFonts {
  AppFonts._();
  static const String display = 'Sora'; // headings
  static const String body = 'Manrope'; // paragraphs, labels
}

/// Design tokens for Solar PV HK Limited.
///
/// Palette rationale:
/// - Deep circuit navy carries the "trusted trading house" weight of the
///   brand (Hong Kong HQ, B2B credibility).
/// - Solar amber is the single warm accent — the sun, the product itself —
///   used sparingly so it keeps its punch (CTAs, highlights, icon fills).
/// - A quiet reed-green stands in for the renewable/sourcing side of the
///   business without competing with the amber.
class AppColors {
  AppColors._();

  static const Color navy = Color(0xFF0B2545); // primary / hero bg
  static const Color navyDeep = Color(0xFF071A33); // gradients, footer
  static const Color amber = Color(0xFFF5A623); // signature accent
  static const Color amberDeep = Color(0xFFD98C0F);
  static const Color reed = Color(0xFF1B998B); // secondary accent
  static const Color paper = Color(0xFFF7F8FB); // page background
  static const Color card = Color(0xFFFFFFFF);
  static const Color ink = Color(0xFF14213D); // body text on paper
  static const Color inkMuted = Color(0xFF5B6478);
  static const Color line = Color(0xFFE3E7EF);
}

class AppRadius {
  AppRadius._();
  static const double sm = 10;
  static const double md = 16;
  static const double lg = 24;
}

/// Breakpoints used across the site. Kept in one place so every page
/// agrees on what "mobile / tablet / desktop" means.
class Breakpoints {
  Breakpoints._();
  static const double mobile = 640;
  static const double tablet = 1020;
  static const double desktop = 1320;
}

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.paper,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.navy,
        brightness: Brightness.light,
        primary: AppColors.navy,
        secondary: AppColors.amber,
        surface: AppColors.paper,
      ),
    );

    const display = TextStyle(fontFamily: AppFonts.display); // headings
    const body = TextStyle(fontFamily: AppFonts.body); // paragraphs, labels

    return base.copyWith(
      textTheme: base.textTheme
          .copyWith(
            displayLarge: display.copyWith(
              fontSize: 56,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
              height: 1.05,
              letterSpacing: -1.0,
            ),
            displayMedium: display.copyWith(
              fontSize: 40,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
              height: 1.1,
              letterSpacing: -0.6,
            ),
            headlineLarge: display.copyWith(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
              height: 1.15,
            ),
            headlineMedium: display.copyWith(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
            titleLarge: display.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.ink,
            ),
            titleMedium: body.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
            bodyLarge: body.copyWith(
              fontSize: 17,
              fontWeight: FontWeight.w400,
              color: AppColors.inkMuted,
              height: 1.6,
            ),
            bodyMedium: body.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: AppColors.inkMuted,
              height: 1.55,
            ),
            labelLarge: body.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.navy,
              letterSpacing: 1.1,
            ),
          )
          .apply(bodyColor: AppColors.ink, displayColor: AppColors.ink),
      dividerColor: AppColors.line,
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
    );
  }
}
