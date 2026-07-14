import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import 'hover_builder.dart';

enum CtaStyle { filled, outline }

class CtaButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final CtaStyle style;
  final IconData? icon;
  final bool compact;

  const CtaButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.style = CtaStyle.filled,
    this.icon,
    this.compact = false,
  });

  factory CtaButton.small({
    required String label,
    required VoidCallback onPressed,
  }) =>
      CtaButton(label: label, onPressed: onPressed, compact: true);

  @override
  Widget build(BuildContext context) {
    final filled = style == CtaStyle.filled;

    return HoverBuilder(
      builder: (context, hovering) {
        final bg = filled
            ? (hovering ? AppColors.amberDeep : AppColors.amber)
            : Colors.transparent;
        final fg = filled ? AppColors.navy : Colors.white;
        final border = filled
            ? null
            : Border.all(
                color: hovering ? Colors.white : Colors.white70,
                width: 1.4,
              );

        return GestureDetector(
          onTap: onPressed,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: EdgeInsets.symmetric(
              horizontal: compact ? 18 : 26,
              vertical: compact ? 10 : 16,
            ),
            decoration: BoxDecoration(
              color: bg,
              border: border,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            transform: Matrix4.translationValues(0, hovering ? -1.5 : 0, 0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: fg,
                    fontWeight: FontWeight.w700,
                    fontSize: compact ? 13.5 : 15,
                  ),
                ),
                if (icon != null) ...[
                  const SizedBox(width: 8),
                  Icon(icon, color: fg, size: 18),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
