import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../core/content.dart';

/// Renders the company logo (assets/images/logo-icon-only.png), sized to
/// its real (non-square) aspect ratio, plus the "Solar PV HK" wordmark
/// rendered in code so it can switch color for light/dark backgrounds.
///
/// The icon itself is dark navy + amber, so on a dark background it needs
/// a small light chip behind it to stay visible \u2014 set [onDark] to true
/// for that (e.g. in the footer).
class BrandLogo extends StatelessWidget {
  /// The icon's rendered height. Width follows automatically from the
  /// source image's real aspect ratio, so the mark is never squashed.
  final double size;
  final bool showWordmark;
  final Color? wordmarkColor;
  final bool onDark;

  const BrandLogo({
    super.key,
    this.size = 40,
    this.showWordmark = true,
    this.wordmarkColor,
    this.onDark = false,
  });

  // Real width/height ratio of assets/images/logo-icon-only.png.
  static const double _iconAspect = 1029 / 761;

  @override
  Widget build(BuildContext context) {
    final iconHeight = size * 0.68;
    final iconWidth = iconHeight * _iconAspect;

    Widget mark = Image.asset(
      Company.logoAsset,
      height: iconHeight,
      width: iconWidth,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) => Icon(
        Icons.wb_sunny_rounded,
        color: AppColors.amber,
        size: iconHeight,
      ),
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: size,
          width: size,
          alignment: Alignment.center,
          decoration: onDark
              ? BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(size * 0.24),
                )
              : null,
          child: mark,
        ),
        if (showWordmark) ...[
          SizedBox(width: size * 0.28),
          Text(
            Company.shortName,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: wordmarkColor ?? AppColors.ink,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ],
    );
  }
}
