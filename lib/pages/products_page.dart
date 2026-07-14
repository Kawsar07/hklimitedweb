import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/app_theme.dart';
import '../core/content.dart';
import '../core/responsive.dart';
import '../widgets/cta_button.dart';
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
                subtitle: 'A catalogue built around what solar projects in '
                    'Bangladesh actually need \u2014 from the panel to the '
                    'last MC4 connector.',
              ),
              const SizedBox(height: 28),
              LayoutBuilder(
                builder: (context, constraints) {
                  final columns = constraints.maxWidth >= 980
                      ? 3
                      : constraints.maxWidth >= 620
                          ? 2
                          : 1;
                  return Wrap(
                    spacing: 24,
                    runSpacing: 24,
                    children: [
                      for (final p in Company.products)
                        SizedBox(
                          width: (constraints.maxWidth - (columns - 1) * 24) / columns,
                          height: 272,
                          child: ProductCard(category: p),
                        ),
                    ],
                  );
                },
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
    return Section(
      background: AppColors.paper,
      child: Flex(
        direction: isMobile ? Axis.vertical : Axis.horizontal,
        crossAxisAlignment: isMobile ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Need a quote or a spec sheet?', style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 8),
                Text(
                  'Tell us the project size and we\u2019ll match it to the right products.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
          SizedBox(width: isMobile ? 0 : 32, height: isMobile ? 24 : 0),
          CtaButton(
            label: 'Contact Us',
            icon: Icons.arrow_forward_rounded,
            onPressed: () => context.go('/contact'),
          ),
        ],
      ),
    );
  }
}
