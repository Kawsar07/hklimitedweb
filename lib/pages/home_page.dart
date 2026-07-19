import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/app_theme.dart';
import '../core/content.dart';
import '../core/responsive.dart';
import '../widgets/cta_button.dart';
import '../widgets/fade_slide_in.dart';
import '../widgets/hover_builder.dart';
import '../widgets/equal_height_grid.dart';
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
                title: 'One route, sourced worldwide',
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
        const _Belief(),
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
      color: AppColors.navy,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/hero_bg.jpg',
              fit: BoxFit.cover,
              filterQuality: FilterQuality.medium,
              // The hero is a wide panorama. On desktop it fills a wide area,
              // so decoding at the display width is enough. On a phone the hero
              // is a tall portrait area, so cover-cropping scales the image up
              // by its height — decoding at the screen width (~1200px) then
              // left it looking soft. Decode at the image's native width there
              // so it stays as sharp as the source allows.
              cacheWidth: isMobile
                  ? 1586
                  : (MediaQuery.of(context).size.width *
                          MediaQuery.of(context).devicePixelRatio)
                      .round(),
              // On a phone the hero is portrait, so a wide photo crops to a
              // slice — centre it (road + panels + sun) rather than the far
              // right edge. On desktop, feature the sun on the right.
              alignment:
                  isMobile ? Alignment.center : Alignment.centerRight,
            ),
          ),
          // Scrim for legibility. On mobile the hero is tall and text sits
          // over the whole image, so use an even top-to-bottom darkening;
          // on desktop a lighter left-to-right scrim keeps the sun visible.
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: isMobile
                    ? LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.navy.withOpacity(0.80),
                          AppColors.navy.withOpacity(0.58),
                          AppColors.navy.withOpacity(0.66),
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      )
                    : LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          AppColors.navy.withOpacity(0.92),
                          AppColors.navy.withOpacity(0.74),
                          AppColors.navy.withOpacity(0.34),
                          AppColors.navy.withOpacity(0.05),
                        ],
                        stops: const [0.0, 0.4, 0.72, 1.0],
                      ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
                hPad, isMobile ? 20 : 28, hPad, isMobile ? 32 : 56),
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
                'SOLAR PV HK · WORLDWIDE',
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
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.92),
                      fontSize: 16.5,
                      height: 1.6),
                ),
              ),
            ),
            const SizedBox(height: 20),
            FadeSlideIn(
              delay: const Duration(milliseconds: 130),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: const [
                  _HeroBadge(icon: Icons.verified_user_rounded, label: 'Authentic products'),
                  _HeroBadge(icon: Icons.sell_rounded, label: 'Low prices'),
                  _HeroBadge(icon: Icons.local_shipping_rounded, label: 'Faster delivery worldwide'),
                ],
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
          ),
        ],
      ),
    );
  }
}

class _HeroBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  const _HeroBadge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.16)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.amber, size: 15),
          const SizedBox(width: 7),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _Highlights extends StatelessWidget {
  const _Highlights();

  static const _items = [
    (
      Icons.verified_user_rounded,
      'Authentic products, low prices',
      'Every item is factory-sourced and genuine \u2014 competitive '
          'pricing, with zero counterfeit risk.',
    ),
    (
      Icons.local_shipping_rounded,
      'Faster delivery worldwide',
      'Established logistics routes get your order to you quickly, '
          'wherever in the world you are.',
    ),
    (
      Icons.verified_rounded,
      'Trusted, quality-first',
      'We work only with manufacturers we would put our own name behind.',
    ),
    (
      Icons.public_rounded,
      'Sourced worldwide',
      'A growing global network of manufacturers \u2014 not tied to any '
          'single country, and always expanding into new markets.',
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
          EqualHeightGrid(
            // 4 across on desktop (all cards, one row), 2 on tablet,
            // 1 on mobile.
            columnsForWidth: (w) => w >= 980 ? 4 : (w >= 620 ? 2 : 1),
            children: [
              for (final item in _items)
                _HighlightCard(icon: item.$1, title: item.$2, body: item.$3),
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
          padding: const EdgeInsets.fromLTRB(26, 26, 26, 22),
          // No height/constraints here on purpose: EqualHeightGrid already
          // stretches every card in a row to the same height (the tallest
          // card's own real, measured height), so this always fits exactly.
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
          // mainAxisSize.max (default): the Column always fills the exact
          // height the row hands this card. Title/body stay top-anchored;
          // the Spacer below absorbs any leftover room (a shorter card in
          // a row with a taller neighbour) so the amber accent bar still
          // lines up at the same bottom position on every card in the row.
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.amber.withOpacity(0.14),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AppColors.amberDeep, size: 23),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 17),
              ),
              const SizedBox(height: 10),
              Text(body, style: Theme.of(context).textTheme.bodyMedium),
              const Spacer(),
              const SizedBox(height: 16),
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

/// A quiet "what we believe" band — the brand's sustainability ethos,
/// set on a dark panel between the highlights grid and the closing CTA.
class _Belief extends StatelessWidget {
  const _Belief();

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return Section(
      background: AppColors.navy,
      child: FadeSlideIn(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              Company.philosophyEyebrow.toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.amber,
                fontWeight: FontWeight.w700,
                fontSize: 12.5,
                letterSpacing: 1.4,
              ),
            ),
            const SizedBox(height: 14),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: Text(
                Company.philosophyTitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: Colors.white,
                      fontSize: isMobile ? 26 : 34,
                    ),
              ),
            ),
            const SizedBox(height: 18),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Text(
                Company.philosophy,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16.5,
                  height: 1.7,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Compact closing CTA — a single slim strip instead of the tall boxed
/// banner it replaces, so it doesn't eat a whole screen of height before
/// the footer. One line on desktop (text + button side by side), stacks to
/// a short two-line block only on narrow phones.
class _CtaBanner extends StatelessWidget {
  const _CtaBanner();

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final hPad = Responsive.pagePadding(context);

    final text = Text(
      'Looking for reliable solar hardware, anywhere in the world?',
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontSize: isMobile ? 17 : 20,
          ),
    );
    final button = CtaButton(
      label: 'Talk to Us',
      icon: Icons.arrow_forward_rounded,
      onPressed: () => context.go('/contact'),
    );

    return Section(
      background: AppColors.navy,
      verticalPaddingOverride:
          EdgeInsets.fromLTRB(hPad, isMobile ? 28 : 32, hPad, isMobile ? 28 : 32),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                text,
                const SizedBox(height: 18),
                button,
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: text),
                const SizedBox(width: 28),
                button,
              ],
            ),
    );
  }
}
