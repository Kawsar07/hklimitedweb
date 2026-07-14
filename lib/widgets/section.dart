import 'package:flutter/material.dart';
import '../core/responsive.dart';

/// Consistent vertical rhythm + horizontal padding + max-width centering
/// for every section on every page.
class Section extends StatelessWidget {
  final Widget child;
  final Color? background;
  final EdgeInsets? verticalPaddingOverride;
  final double maxWidth;

  const Section({
    super.key,
    required this.child,
    this.background,
    this.verticalPaddingOverride,
    this.maxWidth = 1240,
  });

  @override
  Widget build(BuildContext context) {
    final hPad = Responsive.pagePadding(context);
    // Real 3-tier rhythm (mobile / tablet / desktop) instead of a mobile
    // vs. desktop split — tightened further so pages with several
    // back-to-back sections don't turn into a long scroll of dead space.
    final vPad = switch (Responsive.deviceOf(context)) {
      DeviceType.mobile => 32.0,
      DeviceType.tablet => 48.0,
      DeviceType.desktop => 56.0,
    };

    return Container(
      width: double.infinity,
      color: background,
      padding: verticalPaddingOverride ??
          EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
      child: MaxWidthBox(maxWidth: maxWidth, child: child),
    );
  }
}

/// An "eyebrow" label + heading + optional supporting copy, used to open
/// almost every section.
class SectionHeading extends StatelessWidget {
  final String eyebrow;
  final String title;
  final String? subtitle;
  final TextAlign align;

  const SectionHeading({
    super.key,
    required this.eyebrow,
    required this.title,
    this.subtitle,
    this.align = TextAlign.left,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final crossAxis = align == TextAlign.center
        ? CrossAxisAlignment.center
        : CrossAxisAlignment.start;

    return Column(
      crossAxisAlignment: crossAxis,
      children: [
        Text(
          eyebrow.toUpperCase(),
          textAlign: align,
          style: theme.textTheme.labelLarge,
        ),
        const SizedBox(height: 12),
        Text(
          title,
          textAlign: align,
          style: theme.textTheme.headlineLarge,
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 12),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Text(
              subtitle!,
              textAlign: align,
              style: theme.textTheme.bodyLarge,
            ),
          ),
        ],
      ],
    );
  }
}
