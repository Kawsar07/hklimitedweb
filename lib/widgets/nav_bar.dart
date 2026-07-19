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
          children: isDesktop
              ? [
                  InkWell(
                    onTap: () => context.go('/home'),
                    child: const BrandLogo(size: 48),
                  ),
                  const Spacer(),
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
                ]
              : [
                  // Menu on the left, like most mobile apps.
                  SizedBox(
                    width: 44,
                    height: 44,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.menu_rounded,
                          color: AppColors.ink, size: 26),
                      onPressed: () => _openMobileMenu(context),
                    ),
                  ),
                  const SizedBox(width: 12),
                  InkWell(
                    onTap: () => context.go('/home'),
                    child: const BrandLogo(size: 46),
                  ),
                  const Spacer(),
                ],
        ),
      ),
    );
  }

  void _openMobileMenu(BuildContext context) {
    final currentPath = GoRouterState.of(context).uri.path;
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Menu',
      barrierColor: Colors.black.withOpacity(0.4),
      transitionDuration: const Duration(milliseconds: 260),
      pageBuilder: (dialogContext, _, __) {
        final width =
            (MediaQuery.of(dialogContext).size.width * 0.82).clamp(0.0, 320.0);
        return Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            width: width,
            height: double.infinity,
            child: _MobileDrawer(
              currentPath: currentPath,
              onClose: () => Navigator.of(dialogContext).pop(),
              onNavigate: (path) {
                Navigator.of(dialogContext).pop();
                context.go(path);
              },
            ),
          ),
        );
      },
      transitionBuilder: (context, anim, _, child) {
        final curved = CurvedAnimation(parent: anim, curve: Curves.easeOutCubic);
        return SlideTransition(
          position: Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero)
              .animate(curved),
          child: child,
        );
      },
    );
  }
}

/// A right-side slide-in navigation drawer for phones — the pattern
/// production apps use, instead of a bottom sheet.
class _MobileDrawer extends StatelessWidget {
  final String currentPath;
  final ValueChanged<String> onNavigate;
  final VoidCallback onClose;

  const _MobileDrawer({
    required this.currentPath,
    required this.onNavigate,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 16,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 8, 12),
              child: Row(
                children: [
                  const BrandLogo(size: 42),
                  const Spacer(),
                  IconButton(
                    onPressed: onClose,
                    icon: const Icon(Icons.close_rounded, color: AppColors.ink),
                    tooltip: 'Close',
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.line),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 4),
                children: [
                  for (final item in Company.navItems)
                    _DrawerItem(
                      label: item.label,
                      active: currentPath == item.path ||
                          currentPath.startsWith('${item.path}/'),
                      onTap: () => onNavigate(item.path),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: CtaButton(
                label: 'Get In Touch',
                icon: Icons.arrow_forward_rounded,
                onPressed: () => onNavigate('/contact'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        color: active ? AppColors.amber.withOpacity(0.10) : Colors.transparent,
        child: Row(
          children: [
            Container(
              width: 3,
              height: 20,
              margin: const EdgeInsets.only(right: 14),
              decoration: BoxDecoration(
                color: active ? AppColors.amber : Colors.transparent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                fontSize: 16,
                color: active ? AppColors.navy : AppColors.ink,
              ),
            ),
          ],
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
        // Active = navy; hovering an unselected tab warms to amber; otherwise
        // muted. The colour/weight fades smoothly (no snapping).
        final color = isActive
            ? AppColors.navy
            : (hovering ? AppColors.amberDeep : AppColors.inkMuted);

        // Underline shows only on the active tab; it animates in/out smoothly
        // on selection. Hovering an unselected tab never reveals it.
        final underlineWidth = isActive ? 24.0 : 0.0;

        // Sized to the navbar's own height so the whole column (not just
        // the text glyphs) is a reliable, full-height tap target. The label is
        // vertically centred (so it lines up with the Get In Touch button) and
        // the active underline sits as an overlay near the bottom, without
        // nudging the text off-centre.
        return SizedBox(
          height: 76,
          child: InkWell(
            onTap: () => context.go(item.path),
            hoverColor: Colors.transparent,
            splashColor: AppColors.amber.withOpacity(0.08),
            highlightColor: AppColors.amber.withOpacity(0.05),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                    style: TextStyle(
                      color: color,
                      fontWeight:
                          isActive ? FontWeight.w700 : FontWeight.w600,
                      fontSize: 14.5,
                    ),
                    child: Text(item.label),
                  ),
                  Positioned(
                    bottom: 18,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 240),
                        curve: Curves.easeOutCubic,
                        width: underlineWidth,
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
