import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/app_theme.dart';
import '../core/content.dart';
import '../core/responsive.dart';
import '../widgets/cta_button.dart';
import '../widgets/fade_slide_in.dart';
import '../widgets/hover_builder.dart';
import '../widgets/page_scaffold.dart';
import '../widgets/section.dart';
import '../widgets/sourcing_route.dart';
import '../widgets/stat_item_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      sections: [
        const _Hero(),
        Section(
          background: Colors.white,
          child: Column(
            children: [
              const SectionHeading(
                eyebrow: 'How sourcing works',
                title: 'One route, three manufacturing hubs',
                subtitle: 'We built the sourcing network first, so you get '
                    'reliable supply from day one \u2014 not a promise to '
                    'figure it out later.',
                align: TextAlign.center,
              ),
              const SizedBox(height: 28),
              const SourcingRoute(),
            ],
          ),
        ),
        const _Highlights(),
        const _CtaBanner(),
      ],
    );
  }
}

class _StatStrip extends StatelessWidget {
  final List<StatItem> stats;
  const _StatStrip({required this.stats});

  static const _icons = [
    Icons.flag_rounded,
    Icons.public_rounded,
    Icons.widgets_rounded,
    Icons.alt_route_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 30, vertical: isMobile ? 20 : 26),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: Colors.white.withOpacity(0.12)),
      ),
      child: Wrap(
        spacing: isMobile ? 28 : 0,
        runSpacing: 22,
        children: [
          for (int i = 0; i < stats.length; i++) ...[
            _StatEntry(stat: stats[i], icon: _icons[i % _icons.length]),
            if (!isMobile && i != stats.length - 1)
              Container(
                width: 1,
                height: 36,
                margin: const EdgeInsets.symmetric(horizontal: 30),
                color: Colors.white.withOpacity(0.12),
              ),
          ],
        ],
      ),
    );
  }
}

class _StatEntry extends StatelessWidget {
  final StatItem stat;
  final IconData icon;
  const _StatEntry({required this.stat, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: AppColors.amber.withOpacity(0.14),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.amber, size: 18),
        ),
        const SizedBox(width: 12),
        StatItemWidget(stat: stat),
      ],
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero();

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final hPad = Responsive.pagePadding(context);

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.navy, AppColors.navyDeep],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: EdgeInsets.fromLTRB(hPad, isMobile ? 20 : 28, hPad, isMobile ? 32 : 56),
      child: MaxWidthBox(
        maxWidth: 1240,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white24),
              ),
              child: Text(
                'HONG KONG \u00b7 LAUNCHING ${Company.founded}',
                style: const TextStyle(
                  color: AppColors.amber,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  letterSpacing: 1.1,
                ),
              ),
            ),
            const SizedBox(height: 24),
            FadeSlideIn(
              child: Text(
                Company.tagline,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: Colors.white,
                      fontSize: isMobile ? 34 : 56,
                    ),
              ),
            ),
            const SizedBox(height: 20),
            FadeSlideIn(
              delay: const Duration(milliseconds: 90),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 620),
                child: Text(
                  Company.heroSubhead,
                  style: const TextStyle(color: Colors.white70, fontSize: 16.5, height: 1.6),
                ),
              ),
            ),
            const SizedBox(height: 24),
            FadeSlideIn(
              delay: const Duration(milliseconds: 180),
              child: Wrap(
                spacing: 16,
                runSpacing: 12,
                children: [
                  CtaButton(
                    label: 'Explore Products',
                    icon: Icons.arrow_forward_rounded,
                    onPressed: () => context.go('/products'),
                  ),
                  CtaButton(
                    label: 'Contact Us',
                    style: CtaStyle.outline,
                    onPressed: () => context.go('/contact'),
                  ),
                ],
              ),
            ),
            SizedBox(height: isMobile ? 28 : 40),
            FadeSlideIn(
              delay: const Duration(milliseconds: 240),
              child: _StatStrip(stats: Company.stats),
            ),
          ],
        ),
      ),
    );
  }
}

class _Highlights extends StatelessWidget {
  const _Highlights();

  static const _items = [
    (
      Icons.public_rounded,
      'Multi-country sourcing',
      'China, Germany and the Netherlands today \u2014 a network built to '
          'keep expanding.',
    ),
    (
      Icons.verified_rounded,
      'Trusted, quality-first',
      'We work only with manufacturers we would put our own name behind.',
    ),
    (
      Icons.handshake_rounded,
      'Built for the world',
      'A single reliable point of contact for installers, EPCs and '
          'retailers, wherever you are.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Section(
      background: AppColors.paper,
      child: Column(
        children: [
          const SectionHeading(
            eyebrow: 'Why it works',
            title: 'Sourcing, simplified',
            align: TextAlign.center,
          ),
          const SizedBox(height: 28),
          Wrap(
            spacing: 24,
            runSpacing: 24,
            alignment: WrapAlignment.center,
            children: [
              for (final item in _items)
                SizedBox(
                  width: 340,
                  height: 210,
                  child: _HighlightCard(
                    icon: item.$1,
                    title: item.$2,
                    body: item.$3,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HighlightCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;
  const _HighlightCard({required this.icon, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return HoverBuilder(
      cursor: MouseCursor.defer, // informational card, not a link
      builder: (context, hovering) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          transform: Matrix4.translationValues(0, hovering ? -5 : 0, 0),
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 22),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(
              color: hovering ? AppColors.amber : AppColors.line,
              width: hovering ? 1.4 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.navy.withOpacity(hovering ? 0.10 : 0.04),
                blurRadius: hovering ? 26 : 14,
                offset: Offset(0, hovering ? 14 : 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: AppColors.reed.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Icon(icon, color: AppColors.reed, size: 23),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 17),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(body, style: Theme.of(context).textTheme.bodyMedium),
              const Spacer(),
              Container(
                height: 3,
                width: hovering ? 40 : 22,
                decoration: BoxDecoration(
                  color: AppColors.amber,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CtaBanner extends StatelessWidget {
  const _CtaBanner();

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final hPad = Responsive.pagePadding(context);
    return Section(
      background: AppColors.navy,
      verticalPaddingOverride:
          EdgeInsets.fromLTRB(hPad, isMobile ? 32 : 40, hPad, isMobile ? 32 : 40),
      child: Container(
        padding: EdgeInsets.all(isMobile ? 28 : 40),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.navyDeep, AppColors.navy],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: AppColors.amber.withOpacity(0.35)),
          boxShadow: [
            BoxShadow(
              color: AppColors.amber.withOpacity(0.10),
              blurRadius: 40,
              offset: const Offset(0, 18),
            ),
          ],
        ),
        child: Flex(
          direction: isMobile ? Axis.vertical : Axis.horizontal,
          crossAxisAlignment: isMobile ? CrossAxisAlignment.start : CrossAxisAlignment.center,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.amber.withOpacity(0.14),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.bolt_rounded, color: AppColors.amber, size: 26),
            ),
            SizedBox(width: isMobile ? 0 : 22, height: isMobile ? 18 : 0),
            Expanded(
              child: Text(
                  'Looking for reliable solar hardware & accessories, anywhere in the world?',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white),
              ),
            ),
            SizedBox(width: isMobile ? 0 : 32, height: isMobile ? 24 : 0),
            CtaButton(
              label: 'Talk to Us',
              icon: Icons.arrow_forward_rounded,
              onPressed: () => context.go('/contact'),
            ),
          ],
        ),
      ),
    );
  }
}
