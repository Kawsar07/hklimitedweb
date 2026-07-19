import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/app_theme.dart';
import '../core/content.dart';
import '../core/responsive.dart';
import '../widgets/cta_button.dart';
import '../widgets/equal_height_grid.dart';
import '../widgets/page_scaffold.dart';
import '../widgets/product_card.dart';
import '../widgets/section.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      sections: [
        _PageHeader(),
        Section(
          background: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeading(
                eyebrow: 'What we supply',
                title: 'Product categories',
                subtitle: 'A catalogue built around what solar and '
                    'renewable energy projects worldwide actually need '
                    '\u2014 from the panel to the last MC4 connector.',
              ),
              const SizedBox(height: 28),
              EqualHeightGrid(
                columnsForWidth: (w) => w >= 980 ? 3 : (w >= 620 ? 2 : 1),
                children: [
                  for (final p in Company.products) ProductCard(category: p),
                ],
              ),
            ],
          ),
        ),
        _CtaStrip(),
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
              'Products',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 12),
            const Text(
              'Solar inverters, panels, mounting, cabling and accessories \u2014 '
              'sourced, not manufactured, so quality is chosen, not assumed.',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class _CtaStrip extends StatelessWidget {
  const _CtaStrip();

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final textBlock = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Need a quote or a spec sheet?', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 8),
        Text(
          'Tell us the project size and we\u2019ll match it to the right products.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
    final button = CtaButton(
      label: 'Contact Us',
      icon: Icons.arrow_forward_rounded,
      onPressed: () => context.go('/contact'),
    );

    return Section(
      background: AppColors.paper,
      // Two separate layouts instead of one Flex that flips direction:
      // an Expanded inside a vertical Flex needs bounded height, which a
      // shrink-wrapped Column doesn't have, so on mobile it overflowed.
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [textBlock, const SizedBox(height: 24), button],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: textBlock),
                const SizedBox(width: 32),
                button,
              ],
            ),
    );
  }
}
