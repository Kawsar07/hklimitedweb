import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../core/content.dart';
import '../core/responsive.dart';
import '../widgets/equal_height_grid.dart';
import '../widgets/page_scaffold.dart';
import '../widgets/section.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PageScaffold(
      sections: [
        _PageHeader(),
        _Intro(),
        _MissionVision(),
        _BusinessModel(),
      ],
    );
  }
}

/// Hero header: about-specific headline on the left, a hand-drawn globe with
/// the Hong Kong hub marked on the right. No stock photography.
class _PageHeader extends StatelessWidget {
  const _PageHeader();

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    final text = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const _Eyebrow(text: 'WHO WE ARE', onDark: true),
        const SizedBox(height: 16),
        Text(
          'About ${Company.shortName}',
          style: Theme.of(context)
              .textTheme
              .displayMedium
              ?.copyWith(color: Colors.white),
        ),
        const SizedBox(height: 14),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Text(
            'Founded in Hong Kong to make authentic solar hardware easy to '
            'source — wherever in the world you build. This is who we are and '
            'what we set out to do.',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16.5,
              height: 1.6,
            ),
          ),
        ),
      ],
    );

    final globe = Image.asset(
      'assets/images/about_globe.png',
      fit: BoxFit.contain,
    );

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.navy, AppColors.navyDeep],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Responsive.pagePadding(context),
          vertical: isMobile ? 44 : 64,
        ),
        child: MaxWidthBox(
          maxWidth: 1240,
          child: isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    text,
                    const SizedBox(height: 28),
                    Center(
                      child: SizedBox(
                        width: 260,
                        height: 260,
                        child: globe,
                      ),
                    ),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(flex: 3, child: text),
                    const SizedBox(width: 32),
                    Expanded(
                      flex: 2,
                      child: SizedBox(height: 320, child: globe),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

/// Our story — about-specific copy, with quick facts.
class _Intro extends StatelessWidget {
  const _Intro();

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    final textBlock = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _Eyebrow(text: 'OUR STORY'),
        const SizedBox(height: 12),
        Text(
          'Making solar sourcing simple, anywhere',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 18),
        Text(Company.aboutIntro, style: Theme.of(context).textTheme.bodyLarge),
      ],
    );

    final facts = Column(
      children: const [
        _FactRow(
            icon: Icons.location_on_rounded,
            label: 'Headquarters',
            value: 'Hong Kong'),
        _FactRow(
            icon: Icons.travel_explore_rounded,
            label: 'Sourcing',
            value: '25+ countries'),
        _FactRow(
            icon: Icons.public_rounded,
            label: 'Reach',
            value: 'Worldwide'),
        _FactRow(
            icon: Icons.inventory_2_rounded,
            label: 'Product lines',
            value: '7+ categories'),
      ],
    );

    return Section(
      background: Colors.white,
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [textBlock, const SizedBox(height: 28), facts],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 3, child: textBlock),
                const SizedBox(width: 48),
                Expanded(flex: 2, child: facts),
              ],
            ),
    );
  }
}

class _FactRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _FactRow(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.paper,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.reed.withOpacity(0.12),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(icon, color: AppColors.reed, size: 21),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        color: AppColors.inkMuted,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(value,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontSize: 17)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Mission & Vision as two clean, icon-led cards.
class _MissionVision extends StatelessWidget {
  const _MissionVision();

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    const mission = _ValueCard(
      icon: Icons.rocket_launch_rounded,
      accent: AppColors.amber,
      label: 'Our mission',
      body: Company.mission,
    );
    const vision = _ValueCard(
      icon: Icons.visibility_rounded,
      accent: AppColors.reed,
      label: 'Our vision',
      body: Company.vision,
    );

    return Section(
      background: AppColors.paper,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeading(
            eyebrow: 'What drives us',
            title: 'Mission & vision',
          ),
          const SizedBox(height: 28),
          isMobile
              ? Column(children: [mission, SizedBox(height: 20), vision])
              : const IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(child: mission),
                      SizedBox(width: 24),
                      Expanded(child: vision),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}

class _ValueCard extends StatelessWidget {
  final IconData icon;
  final Color accent;
  final String label;
  final String body;
  const _ValueCard({
    required this.icon,
    required this.accent,
    required this.label,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: accent.withOpacity(0.14),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(icon, color: accent, size: 30),
          ),
          const SizedBox(height: 20),
          Text(label.toUpperCase(),
              style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 10),
          Text(body, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}

class _BusinessModel extends StatelessWidget {
  const _BusinessModel();

  static const _icons = [
    Icons.factory_rounded,
    Icons.support_agent_rounded,
    Icons.public_rounded,
    Icons.verified_rounded,
    Icons.handshake_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    final points = Company.businessModel;
    return Section(
      background: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeading(
            eyebrow: 'How we operate',
            title: 'Our business model',
          ),
          const SizedBox(height: 28),
          EqualHeightGrid(
            columnsForWidth: (w) => w >= 900 ? 2 : 1,
            children: [
              for (int i = 0; i < points.length; i++)
                _ModelCard(icon: _icons[i % _icons.length], body: points[i]),
            ],
          ),
        ],
      ),
    );
  }
}

class _ModelCard extends StatelessWidget {
  final IconData icon;
  final String body;
  const _ModelCard({required this.icon, required this.body});

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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: AppColors.reed,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(body, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}

class _Eyebrow extends StatelessWidget {
  final String text;
  final bool onDark;
  const _Eyebrow({required this.text, this.onDark = false});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: onDark ? AppColors.amber : AppColors.reed,
        fontWeight: FontWeight.w800,
        fontSize: 12.5,
        letterSpacing: 1.2,
      ),
    );
  }
}
