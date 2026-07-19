import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/app_theme.dart';
import '../core/content.dart';
import '../core/responsive.dart';
import 'hover_builder.dart';

class ProductCard extends StatelessWidget {
  final ProductCategory category;
  const ProductCard({super.key, required this.category});

  String get _imagePath => category.cardImage;

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return HoverBuilder(
      cursor: SystemMouseCursors.click,
      builder: (context, hovering) {
        return GestureDetector(
          onTap: () => context.go('/products/${category.slugOrIcon}'),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: EdgeInsets.all(isMobile ? 14 : 28),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(
                color: hovering ? AppColors.amber : AppColors.line,
                width: hovering ? 1.4 : 1,
              ),
              boxShadow: hovering
                  ? [
                      BoxShadow(
                        color: AppColors.navy.withOpacity(0.08),
                        blurRadius: 24,
                        offset: const Offset(0, 12),
                      ),
                    ]
                  : [],
            ),
            transform: Matrix4.translationValues(0, hovering ? -4 : 0, 0),
            child: isMobile ? _mobile(context) : _desktop(context),
          ),
        );
      },
    );
  }

  // Compact horizontal layout: small thumbnail on the left, text on the
  // right — so the illustration never balloons to full phone width.
  Widget _mobile(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          child: SizedBox(
            width: 116,
            height: 88,
            child: Image.asset(_imagePath, fit: BoxFit.cover),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                category.title,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontSize: 16),
              ),
              const SizedBox(height: 5),
              Text(
                category.detail,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Full illustration header stacked above the text.
  Widget _desktop(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          child: AspectRatio(
            aspectRatio: 16 / 10,
            child: Image.asset(_imagePath, fit: BoxFit.cover),
          ),
        ),
        const SizedBox(height: 18),
        Text(category.title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 10),
        Expanded(
          child: Text(
            category.detail,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        Container(
          height: 3,
          width: 22,
          decoration: BoxDecoration(
            color: AppColors.amber,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }
}
