import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/app_theme.dart';
import '../core/content.dart';
import '../core/responsive.dart';
import 'brand_logo.dart';
import 'cta_button.dart';
import 'hover_builder.dart';

class NavBar extends StatelessWidget implements PreferredSizeWidget {
  const NavBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(76);

  @override
  Widget build(BuildContext context) {
    final currentPath = GoRouterState.of(context).uri.path;
    final isDesktop = Responsive.isDesktop(context);
    final hPad = Responsive.pagePadding(context);

    return Container(
      height: preferredSize.height,
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: hPad),
      child: MaxWidthBox(
        maxWidth: 1320,
        child: Row(
          children: [
            InkWell(
              onTap: () => context.go('/home'),
              child: const BrandLogo(size: 48),
            ),
            const Spacer(),
            if (isDesktop) ...[
              for (final item in Company.navItems)
                _NavLink(
                  item: item,
                  isActive: currentPath == item.path ||
                      currentPath.startsWith('${item.path}/'),
                ),
              const SizedBox(width: 16),
              CtaButton.small(
                label: 'Get In Touch',
                onPressed: () => context.go('/contact'),
              ),
            ] else
              IconButton(
                icon: const Icon(Icons.menu_rounded, color: AppColors.ink),
                onPressed: () => _openMobileMenu(context),
              ),
          ],
        ),
      ),
    );
  }

  void _openMobileMenu(BuildContext context) {
    final currentPath = GoRouterState.of(context).uri.path;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.line,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 8),
              for (final item in Company.navItems)
                ListTile(
                  title: Text(
                    item.label,
                    style: TextStyle(
                      fontWeight: currentPath == item.path
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color: currentPath == item.path
                          ? AppColors.navy
                          : AppColors.ink,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    context.go(item.path);
                  },
                ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavLink extends StatelessWidget {
  final NavItem item;
  final bool isActive;
  const _NavLink({required this.item, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return HoverBuilder(
      builder: (context, hovering) {
        final color =
            isActive || hovering ? AppColors.navy : AppColors.inkMuted;

        // Sized to the navbar's own height so the whole column (not just
        // the text glyphs) is a reliable, full-height tap target.
        return SizedBox(
          height: 76,
          child: InkWell(
            onTap: () => context.go(item.path),
            hoverColor: Colors.transparent,
            splashColor: AppColors.amber.withOpacity(0.08),
            highlightColor: AppColors.amber.withOpacity(0.05),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    item.label,
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w600,
                      fontSize: 14.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 3,
                    child: Center(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        curve: Curves.easeOut,
                        width: isActive ? 22 : 0,
                        height: 3,
                        decoration: BoxDecoration(
                          color: AppColors.amber,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
