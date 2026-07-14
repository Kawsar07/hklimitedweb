import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../core/content.dart';

class StatItemWidget extends StatelessWidget {
  final StatItem stat;
  final bool dark;
  const StatItemWidget({super.key, required this.stat, this.dark = true});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          stat.value,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: dark ? Colors.white : AppColors.ink,
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          stat.label,
          style: TextStyle(
            color: dark ? Colors.white70 : AppColors.inkMuted,
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
