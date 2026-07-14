import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../core/content.dart';
import 'category_icon.dart';
import 'hover_builder.dart';

class ProductCard extends StatelessWidget {
  final ProductCategory category;
  const ProductCard({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return HoverBuilder(
      cursor: MouseCursor.defer, // not tappable — no click affordance needed
      builder: (context, hovering) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(28),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.navy,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(
                  categoryIcon(category.icon),
                  color: AppColors.amber,
                  size: 26,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                category.title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Text(
                  category.detail,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
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
