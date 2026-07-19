import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/app_theme.dart';
import '../core/content.dart';
import '../core/responsive.dart';
import 'brand_logo.dart';
import 'hover_builder.dart';

/// Site-wide footer.
///
/// Standard 3-part structure — brand/about, Quick Links, Contact — laid out
/// responsively:
///   desktop : the three parts in one aligned row
///   tablet  : brand full-width on top, then Links + Contact side by side
///   mobile  : same as tablet, so the two short lists sit next to each
///             other instead of stacking into one long, empty strip
/// then a thin divider and a bottom bar (copyright + back-to-top).
class SiteFooter extends StatelessWidget {
  const SiteFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final device = Responsive.deviceOf(context);
    final hPad = Responsive.pagePadding(context);

    final brand = const _BrandBlock();
    final links = const _LinksColumn();
    final contact = const _ContactColumn();

    final Widget body;
    switch (device) {
      case DeviceType.desktop:
        // No IntrinsicHeight: the columns are top-aligned, so they don't
        // need to share a height. Forcing a shared height is what made the
        // brand column overflow when its text rendered a line taller than
        // the initial measurement (font-swap timing) — a plain top-aligned
        // Row lets each column just be its own natural height.
        body = Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 5, child: brand),
            const SizedBox(width: 40),
            Expanded(flex: 3, child: links),
            const SizedBox(width: 40),
            Expanded(flex: 4, child: contact),
          ],
        );
        break;
      case DeviceType.tablet:
      case DeviceType.mobile:
        body = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            brand,
            const SizedBox(height: 40),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: links),
                const SizedBox(width: 24),
                Expanded(child: contact),
              ],
            ),
          ],
        );
        break;
    }

    return Container(
      width: double.infinity,
      color: AppColors.navyDeep,
      child: Column(
        children: [
          // Thin brand accent line across the very top of the footer.
          Container(
            height: 3,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.reed, AppColors.amber, AppColors.amberDeep],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              hPad,
              device == DeviceType.mobile ? 40 : 56,
              hPad,
              device == DeviceType.mobile ? 32 : 40,
            ),
            child: MaxWidthBox(maxWidth: 1200, child: body),
          ),
          _BottomBar(hPad: hPad),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Brand / about
// ---------------------------------------------------------------------------

class _BrandBlock extends StatelessWidget {
  const _BrandBlock();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const BrandLogo(size: 36, wordmarkColor: Colors.white, onDark: true),
        const SizedBox(height: 18),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: Text(
            Company.heroSubhead,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 13.5,
              height: 1.7,
            ),
          ),
        ),
        const SizedBox(height: 22),
        const _SocialRow(),
      ],
    );
  }
}

class _SocialRow extends StatelessWidget {
  const _SocialRow();

  Future<void> _open(String uri) async {
    final parsed = Uri.parse(uri);
    if (await canLaunchUrl(parsed)) await launchUrl(parsed);
  }

  @override
  Widget build(BuildContext context) {
    final phoneDigits = Company.phone.replaceAll(RegExp(r'[^0-9]'), '');
    return Row(
      children: [
        _SocialIcon(icon: Icons.call_rounded, onTap: () => _open('tel:${Company.phone}')),
        const SizedBox(width: 10),
        _SocialIcon(icon: Icons.email_rounded, onTap: () => _open('mailto:${Company.email}')),
        const SizedBox(width: 10),
        _SocialIcon(icon: Icons.chat_rounded, onTap: () => _open('https://wa.me/$phoneDigits')),
      ],
    );
  }
}

class _SocialIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _SocialIcon({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return HoverBuilder(
      builder: (context, hovering) {
        return GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: hovering ? AppColors.amber : Colors.white.withOpacity(0.06),
              shape: BoxShape.circle,
              border: Border.all(color: hovering ? AppColors.amber : Colors.white24),
            ),
            child: Icon(
              icon,
              size: 17,
              color: hovering ? AppColors.navy : Colors.white70,
            ),
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Quick links
// ---------------------------------------------------------------------------

class _LinksColumn extends StatelessWidget {
  const _LinksColumn();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _ColumnTitle('Quick Links'),
        for (final item in Company.navItems)
          _FooterLink(label: item.label, path: item.path),
      ],
    );
  }
}

class _FooterLink extends StatelessWidget {
  final String label;
  final String path;
  const _FooterLink({required this.label, required this.path});

  @override
  Widget build(BuildContext context) {
    return HoverBuilder(
      builder: (context, hovering) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GestureDetector(
            onTap: () => context.go(path),
            behavior: HitTestBehavior.opaque,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  width: hovering ? 12 : 0,
                  height: 1.5,
                  margin: EdgeInsets.only(right: hovering ? 8 : 0),
                  color: AppColors.amber,
                ),
                Flexible(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: hovering ? Colors.white : Colors.white60,
                      fontSize: 14,
                      fontWeight: hovering ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Contact
// ---------------------------------------------------------------------------

class _ContactColumn extends StatelessWidget {
  const _ContactColumn();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _ColumnTitle('Contact'),
        _ContactRow(icon: Icons.location_on_outlined, text: Company.registeredAddress),
        _ContactRow(icon: Icons.call_outlined, text: Company.phone),
        _ContactRow(icon: Icons.email_outlined, text: Company.email),
        _ContactRow(icon: Icons.language_outlined, text: Company.website),
      ],
    );
  }
}

class _ContactRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _ContactRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.amber, size: 17),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white60,
                fontSize: 13.5,
                height: 1.55,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Shared bits
// ---------------------------------------------------------------------------

class _ColumnTitle extends StatelessWidget {
  final String text;
  const _ColumnTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 8),
          Container(width: 26, height: 2.5, color: AppColors.amber),
        ],
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  final double hPad;
  const _BottomBar({required this.hPad});

  void _scrollToTop(BuildContext context) {
    final controller = PrimaryScrollController.maybeOf(context);
    controller?.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Colors.white12)),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Padding(
            padding: EdgeInsets.fromLTRB(hPad, 20, hPad, 20),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              runSpacing: 10,
              spacing: 16,
              children: [
                Text(
                  '\u00a9 ${Company.founded} ${Company.name}. All rights reserved.',
                  style: const TextStyle(color: Colors.white38, fontSize: 12.5),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
