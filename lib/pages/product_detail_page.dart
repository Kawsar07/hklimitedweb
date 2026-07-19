import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/app_theme.dart';
import '../core/content.dart';
import '../core/responsive.dart';
import '../widgets/cta_button.dart';
import '../widgets/hover_builder.dart';
import '../widgets/page_scaffold.dart';
import '../widgets/section.dart';

class ProductDetailPage extends StatelessWidget {
  final String slug;
  const ProductDetailPage({super.key, required this.slug});

  @override
  Widget build(BuildContext context) {
    final product = Company.productBySlug(slug);
    if (product == null) return const _UnknownProduct();

    return PageScaffold(
      sections: [
        _Header(product: product),
        _Body(product: product),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  final ProductCategory product;
  const _Header({required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.navy,
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.pagePadding(context),
        vertical: 40,
      ),
      child: MaxWidthBox(
        maxWidth: 1240,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.title,
              style: Theme.of(context)
                  .textTheme
                  .displayMedium
                  ?.copyWith(color: Colors.white),
            ),
            if (product.brand != null) ...[
              const SizedBox(height: 14),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.amber,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Featured brand · ${product.brand}',
                  style: const TextStyle(
                    color: AppColors.navy,
                    fontWeight: FontWeight.w800,
                    fontSize: 12.5,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final ProductCategory product;
  const _Body({required this.product});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    final image = ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: AspectRatio(
        aspectRatio: 16 / 10,
        child: Image.asset(product.heroImage, fit: BoxFit.cover),
      ),
    );

    final info = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.overview ?? product.detail,
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(height: 1.7),
        ),
        if (product.features.isNotEmpty) ...[
          const SizedBox(height: 28),
          Text(
            'Key features',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          for (final f in product.features)
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.check_circle_rounded,
                      color: AppColors.reed, size: 21),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(f,
                        style: Theme.of(context).textTheme.bodyMedium),
                  ),
                ],
              ),
            ),
        ],
        const SizedBox(height: 28),
        CtaButton(
          label: 'Request a quote',
          icon: Icons.arrow_forward_rounded,
          onPressed: () => context.go('/contact'),
        ),
      ],
    );

    final content = isMobile
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [image, const SizedBox(height: 28), info],
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 5, child: image),
              const SizedBox(width: 48),
              Expanded(flex: 6, child: info),
            ],
          );

    return Section(
      background: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _BackLink(),
          const SizedBox(height: 24),
          content,
        ],
      ),
    );
  }
}

/// A quiet breadcrumb-style back link at the top of the content area.
class _BackLink extends StatelessWidget {
  const _BackLink();

  @override
  Widget build(BuildContext context) {
    return HoverBuilder(
      cursor: SystemMouseCursors.click,
      builder: (context, hovering) {
        final color = hovering ? AppColors.amberDeep : AppColors.inkMuted;
        return GestureDetector(
          onTap: () => context.go('/products'),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.arrow_back_rounded, color: color, size: 17),
              const SizedBox(width: 7),
              Text(
                'Back to all products',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 13.5,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _UnknownProduct extends StatelessWidget {
  const _UnknownProduct();

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      sections: [
        Section(
          background: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Product not found',
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 16),
              CtaButton(
                label: 'Back to products',
                icon: Icons.arrow_back_rounded,
                onPressed: () => context.go('/products'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
