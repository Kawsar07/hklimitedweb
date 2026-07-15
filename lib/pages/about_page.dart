import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../core/content.dart';
import '../core/responsive.dart';
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
              'About Us',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 12),
            const Text(
              'A new sourcing house for solar hardware, built for the world.',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class _Intro extends StatelessWidget {
  const _Intro();

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final text = Text(
      Company.aboutIntro,
      style: Theme.of(context).textTheme.bodyLarge,
    );

    final badge = Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.paper,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.flag_circle_rounded, color: AppColors.reed, size: 32),
          const SizedBox(height: 14),
          Text('Headquartered in ${Company.hq}', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 6),
          Text('Launching in ${Company.founded}', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 6),
          Text('Primary market: Worldwide', style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );

    return Section(
      background: Colors.white,
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [text, const SizedBox(height: 28), badge],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 3, child: text),
                const SizedBox(width: 48),
                Expanded(flex: 2, child: badge),
              ],
            ),
    );
  }
}

class _MissionVision extends StatelessWidget {
  const _MissionVision();

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    final mission = _ValueCard(
      icon: Icons.rocket_launch_rounded,
      label: 'Mission',
      body: Company.mission,
    );
    final vision = _ValueCard(
      icon: Icons.visibility_rounded,
      label: 'Vision',
      body: Company.vision,
    );

    return Section(
      background: AppColors.paper,
      child: isMobile
          ? Column(children: [mission, const SizedBox(height: 20), vision])
          : Row(
              children: [
                Expanded(child: mission),
                const SizedBox(width: 24),
                Expanded(child: vision),
              ],
            ),
    );
  }
}

class _ValueCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String body;
  const _ValueCard({required this.icon, required this.label, required this.body});

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
          Icon(icon, color: AppColors.amberDeep, size: 30),
          const SizedBox(height: 16),
          Text(label.toUpperCase(), style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 10),
          Text(body, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}

class _BusinessModel extends StatelessWidget {
  const _BusinessModel();

  @override
  Widget build(BuildContext context) {
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
          for (final point in Company.businessModel)
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 6),
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.amber,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 16),
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
