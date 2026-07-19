import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../core/responsive.dart';

/// "How sourcing works" as a numbered 01 · 02 · 03 process timeline — a
/// clean step flow, kept deliberately different from the world map used on
/// the Why Us page.
class SourcingRoute extends StatelessWidget {
  const SourcingRoute({super.key});

  static const List<_StepData> _steps = [
    _StepData(
      icon: Icons.public_rounded,
      color: AppColors.reed,
      title: 'Global sourcing',
      subtitle: 'We buy directly from trusted manufacturers worldwide.',
    ),
    _StepData(
      icon: Icons.hub_rounded,
      color: AppColors.amber,
      title: 'Hong Kong hub',
      subtitle: 'Solar PV HK consolidates and quality-checks every order.',
      emphasize: true,
    ),
    _StepData(
      icon: Icons.local_shipping_rounded,
      color: AppColors.amberDeep,
      title: 'Global delivery',
      subtitle: 'Shipped to installers, EPCs and retailers, worldwide.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 940),
      child: isMobile ? const _VerticalSteps(_steps) : const _HorizontalSteps(_steps),
    );
  }
}

class _StepData {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final bool emphasize;
  const _StepData({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    this.emphasize = false,
  });
}

const double _badge = 68;

class _HorizontalSteps extends StatelessWidget {
  final List<_StepData> steps;
  const _HorizontalSteps(this.steps);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final w = c.maxWidth;
        return Stack(
          children: [
            // Connecting track, sitting behind the badges at their centre.
            Positioned(
              left: w / (steps.length * 2),
              right: w / (steps.length * 2),
              top: _badge / 2 - 1.5,
              child: Container(
                height: 3,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    AppColors.reed.withOpacity(0.4),
                    AppColors.amber,
                    AppColors.amberDeep.withOpacity(0.6),
                  ]),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final s in steps)
                  Expanded(
                    child: Column(
                      children: [
                        _Badge(data: s),
                        const SizedBox(height: 16),
                        _StepText(data: s),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _VerticalSteps extends StatelessWidget {
  final List<_StepData> steps;
  const _VerticalSteps(this.steps);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < steps.length; i++) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Badge(data: steps[i]),
              const SizedBox(width: 18),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: _StepText(data: steps[i], alignStart: true),
                ),
              ),
            ],
          ),
          // Connector between steps, aligned under the badge centre.
          if (i != steps.length - 1)
            Padding(
              padding: EdgeInsets.only(
                  left: _badge / 2 - 1.5, top: 8, bottom: 8),
              child: Container(
                width: 3,
                height: 26,
                color: AppColors.amber.withOpacity(0.35),
              ),
            ),
        ],
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  final _StepData data;
  const _Badge({required this.data});

  @override
  Widget build(BuildContext context) {
    final emphasize = data.emphasize;
    return Container(
      width: _badge,
      height: _badge,
      decoration: BoxDecoration(
        color: emphasize ? data.color : Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: emphasize ? data.color : data.color.withOpacity(0.35),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: data.color.withOpacity(emphasize ? 0.40 : 0.16),
            blurRadius: emphasize ? 20 : 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Icon(
        data.icon,
        color: emphasize ? AppColors.navy : data.color,
        size: 30,
      ),
    );
  }
}

class _StepText extends StatelessWidget {
  final _StepData data;
  final bool alignStart;
  const _StepText({required this.data, this.alignStart = false});

  @override
  Widget build(BuildContext context) {
    final align = alignStart ? TextAlign.start : TextAlign.center;
    return Column(
      crossAxisAlignment:
          alignStart ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Text(
          data.title,
          textAlign: align,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 16,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(height: 6),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 240),
          child: Text(
            data.subtitle,
            textAlign: align,
            style: const TextStyle(
              fontSize: 13,
              height: 1.5,
              color: AppColors.inkMuted,
            ),
          ),
        ),
      ],
    );
  }
}
