import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../core/responsive.dart';

/// The one signature graphic on the site: a literal trade route, since
/// that is what this business actually does — it does not decorate the
/// content, it *is* the content.
class SourcingRoute extends StatelessWidget {
  const SourcingRoute({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    final origins = const [
      ('China', 'High-volume manufacturing'),
      ('Germany', 'Engineering-grade quality'),
      ('Netherlands', 'Specialised accessories'),
    ];

    final originNodes = [
      for (final o in origins) _RouteNode(title: o.$1, subtitle: o.$2),
    ];

    final hub = _RouteNode(
      title: 'Solar PV HK Limited',
      subtitle: 'Hong Kong \u2014 sourcing hub',
      emphasize: true,
    );

    final destination = _RouteNode(
      title: 'Bangladesh',
      subtitle: 'Installers \u00b7 EPCs \u00b7 Retailers',
      emphasize: false,
      isDestination: true,
    );

    if (isMobile) {
      return Column(
        children: [
          for (final n in originNodes) ...[n, const _RouteArrow(vertical: true)],
          hub,
          const _RouteArrow(vertical: true),
          destination,
        ],
      );
    }

    // Centered, fixed-width composition — deliberately NOT stretched with
    // Expanded, so the route reads as one compact diagram instead of
    // spreading across the full section width with dead space in between.
    return Center(
      child: IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 208,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (int i = 0; i < originNodes.length; i++) ...[
                    originNodes[i],
                    if (i != originNodes.length - 1) const SizedBox(height: 14),
                  ],
                ],
              ),
            ),
            const _RouteArrow(vertical: false),
            hub,
            const _RouteArrow(vertical: false),
            destination,
          ],
        ),
      ),
    );
  }
}

class _RouteNode extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool emphasize;
  final bool isDestination;

  const _RouteNode({
    required this.title,
    required this.subtitle,
    this.emphasize = false,
    this.isDestination = false,
  });

  @override
  Widget build(BuildContext context) {
    final bg = emphasize ? AppColors.amber : Colors.white;
    final titleColor = emphasize ? AppColors.navy : AppColors.ink;

    final badgeBg = emphasize ? AppColors.navy : AppColors.reed.withOpacity(0.12);
    final badgeIconColor = emphasize ? AppColors.amber : AppColors.reed;

    return Container(
      width: 200,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 18),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: emphasize ? AppColors.amberDeep : AppColors.line,
          width: emphasize ? 1.6 : 1,
        ),
        boxShadow: emphasize
            ? [
                BoxShadow(
                  color: AppColors.amber.withOpacity(0.32),
                  blurRadius: 26,
                  offset: const Offset(0, 12),
                ),
              ]
            : [
                BoxShadow(
                  color: AppColors.navy.withOpacity(0.05),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: badgeBg, shape: BoxShape.circle),
            child: Icon(
              isDestination
                  ? Icons.flag_rounded
                  : emphasize
                      ? Icons.hub_rounded
                      : Icons.factory_rounded,
              color: badgeIconColor,
              size: 21,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 15,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              height: 1.4,
              color: emphasize ? AppColors.navy.withOpacity(0.75) : AppColors.inkMuted,
            ),
          ),
        ],
      ),
    );
  }
}

/// A short connecting line with an arrowhead — reads as a route segment
/// rather than a generic navigation arrow.
class _RouteArrow extends StatelessWidget {
  final bool vertical;
  const _RouteArrow({required this.vertical});

  @override
  Widget build(BuildContext context) {
    final line = Container(
      width: vertical ? 2 : 18,
      height: vertical ? 20 : 2,
      color: AppColors.amber.withOpacity(0.45),
    );
    final icon = Icon(
      vertical ? Icons.keyboard_arrow_down_rounded : Icons.keyboard_arrow_right_rounded,
      color: AppColors.amber,
      size: 20,
    );

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: vertical ? 2 : 0,
        horizontal: vertical ? 0 : 2,
      ),
      child: vertical
          ? Column(mainAxisSize: MainAxisSize.min, children: [line, icon])
          : Row(mainAxisSize: MainAxisSize.min, children: [line, icon]),
    );
  }
}
