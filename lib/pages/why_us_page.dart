import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../core/content.dart';
import '../core/responsive.dart';
import '../widgets/equal_height_grid.dart';
import '../widgets/page_scaffold.dart';
import '../widgets/section.dart';
import '../widgets/sourcing_map.dart';

class WhyUsPage extends StatelessWidget {
  const WhyUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PageScaffold(
      sections: [
        _PageHeader(),
        _SourcingCountries(),
        _TargetMarkets(),
        _WhyChooseUs(),
      ],
    );
  }
}

class _PageHeader extends StatelessWidget {
  const _PageHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.navy,
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.pagePadding(context),
        vertical: 48,
      ),
      child: MaxWidthBox(
        maxWidth: 1240,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Why Choose Us',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 12),
            const Text(
              'A sourcing network built before the first sale, not after.',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class _SourcingCountries extends StatelessWidget {
  const _SourcingCountries();

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    return Section(
      background: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeading(
            eyebrow: 'Global network',
            title: 'Where we source from',
            subtitle: 'We work directly with trusted manufacturers across '
                'every inhabited continent — all routed through our Hong '
                'Kong hub and delivered worldwide.',
          ),
          const SizedBox(height: 28),
          const _SourcingMapPanel(),
          const SizedBox(height: 28),
          EqualHeightGrid(
            columnsForWidth: (w) => w >= 900 ? 3 : (w >= 600 ? 2 : 1),
            children: [
              for (final r in Company.sourcingRegions) _RegionCard(region: r),
            ],
          ),
          SizedBox(height: isMobile ? 4 : 8),
        ],
      ),
    );
  }
}

/// The world map, framed on a soft panel with a small legend so the two
/// marker types read clearly.
class _SourcingMapPanel extends StatelessWidget {
  const _SourcingMapPanel();

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 16 : 28),
      decoration: BoxDecoration(
        color: AppColors.paper,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        children: [
          // Cap the map width so it never becomes an oversized strip on
          // very wide screens, while still filling narrow ones.
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 820),
            child: const SourcingMap(),
          ),
          SizedBox(height: isMobile ? 12 : 18),
          const Wrap(
            alignment: WrapAlignment.center,
            spacing: 20,
            runSpacing: 8,
            children: [
              _LegendDot(color: AppColors.amber, label: 'Hong Kong hub'),
              _LegendDot(color: AppColors.navy, label: 'Sourcing continents'),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.inkMuted,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _RegionCard extends StatelessWidget {
  final SourcingRegion region;
  const _RegionCard({required this.region});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.paper,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: AppColors.reed,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.public_rounded,
                    color: Colors.white, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(region.region,
                        style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 2),
                    Text(
                      region.examples,
                      style: const TextStyle(
                        color: AppColors.reed,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(region.detail, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _TargetMarkets extends StatelessWidget {
  const _TargetMarkets();

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    final primary = _MarketCard(
      title: 'Global Market',
      body: 'Worldwide \u2014 installers, EPC companies, retailers and '
          'end-users in every market we serve.',
      emphasize: true,
    );
    final secondary = _MarketCard(
      title: 'Expanding Reach',
      body: 'New countries added continuously as the sourcing and '
          'distribution network grows.',
      emphasize: false,
    );

    return Section(
      background: AppColors.paper,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeading(
            eyebrow: 'Who we serve',
            title: 'Target markets',
          ),
          const SizedBox(height: 28),
          isMobile
              ? Column(children: [primary, const SizedBox(height: 20), secondary])
              : IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(child: primary),
                      const SizedBox(width: 24),
                      Expanded(child: secondary),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}

class _MarketCard extends StatelessWidget {
  final String title;
  final String body;
  final bool emphasize;
  const _MarketCard({required this.title, required this.body, required this.emphasize});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: emphasize ? AppColors.navy : Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: emphasize ? AppColors.navy : AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: TextStyle(
              color: emphasize ? AppColors.amber : AppColors.navy,
              fontWeight: FontWeight.w800,
              fontSize: 12.5,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            body,
            style: TextStyle(
              color: emphasize ? Colors.white : AppColors.inkMuted,
              fontSize: 16,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

class _WhyChooseUs extends StatelessWidget {
  const _WhyChooseUs();

  @override
  Widget build(BuildContext context) {
    return Section(
      background: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeading(
            eyebrow: 'The difference',
            title: 'What sets us apart',
          ),
          const SizedBox(height: 28),
          for (final point in Company.whyChooseUs)
            Padding(
              padding: const EdgeInsets.only(bottom: 18),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.check_circle_rounded, color: AppColors.reed, size: 22),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(point, style: Theme.of(context).textTheme.bodyLarge),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
