import 'package:flutter/material.dart';
import 'app_theme.dart';

enum DeviceType { mobile, tablet, desktop }

class Responsive {
  Responsive._();

  static DeviceType deviceOf(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    if (w >= Breakpoints.tablet) return DeviceType.desktop;
    if (w >= Breakpoints.mobile) return DeviceType.tablet;
    return DeviceType.mobile;
  }

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < Breakpoints.mobile;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= Breakpoints.tablet;

  /// Horizontal page padding that grows gently with the viewport.
  static double pagePadding(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    if (w >= Breakpoints.tablet) return 96;
    if (w >= Breakpoints.mobile) return 40;
    return 20;
  }
}

/// Centers content and caps its width so lines don't stretch edge to edge
/// on large monitors.
class MaxWidthBox extends StatelessWidget {
  final Widget child;
  final double maxWidth;

  const MaxWidthBox({super.key, required this.child, this.maxWidth = 1240});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
