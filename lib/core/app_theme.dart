import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

    final display = GoogleFonts.sora(); // display face — used for headings
    final body = GoogleFonts.manrope(); // body face — quiet, legible

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
