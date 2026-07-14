import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/app_theme.dart';
import '../core/content.dart';
import '../core/responsive.dart';
import 'brand_logo.dart';
import 'hover_builder.dart';

class SiteFooter extends StatelessWidget {
  const SiteFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final hPad = Responsive.pagePadding(context);

    final about = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const BrandLogo(size: 34, wordmarkColor: Colors.white, onDark: true),
        const SizedBox(height: 16),
        SizedBox(
          width: 280,
          child: Text(
            Company.heroSubhead,
            style: const TextStyle(color: Colors.white60, fontSize: 13, height: 1.7),
          ),
        ),
        const SizedBox(height: 20),
        const _SocialRow(),
      ],
    );

    final links = _FooterColumn(
      title: 'Quick Links',
      children: [
        for (final item in Company.navItems)
          _FooterLink(label: item.label, path: item.path),
      ],
    );

    final contact = _FooterColumn(
      title: 'Contact',
      children: [
        _FooterInfo(icon: Icons.location_on_outlined, text: Company.hq),
        _FooterInfo(icon: Icons.call_outlined, text: Company.phone),
        _FooterInfo(icon: Icons.email_outlined, text: Company.email),
        _FooterInfo(icon: Icons.language_outlined, text: Company.website),
      ],
    );

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.navyDeep, AppColors.navy],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        children: [
          // Soft decorative glows — purely atmospheric, clipped so they
          // never affect layout or scroll extent.
          Positioned(
            top: -80,
            right: -60,
            child: _GlowCircle(color: AppColors.amber.withOpacity(0.10), size: 260),
          ),
          Positioned(
            bottom: -100,
            left: -80,
            child: _GlowCircle(color: AppColors.reed.withOpacity(0.10), size: 280),
          ),
          Column(
            children: [
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
                padding: EdgeInsets.fromLTRB(hPad, 48, hPad, 0),
                child: MaxWidthBox(
                  maxWidth: 1240,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      isMobile
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                about,
                                const SizedBox(height: 28),
                                links,
                                const SizedBox(height: 28),
                                contact,
                              ],
                            )
                          : Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(flex: 2, child: about),
                                Expanded(child: links),
                                Expanded(child: contact),
                              ],
                            ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
              _BottomBar(hPad: hPad),
            ],
          ),
        ],
      ),
    );
  }
}

/// A blurred, softly-colored circle used purely as background atmosphere.
class _GlowCircle extends StatelessWidget {
  final Color color;
  final double size;
  const _GlowCircle({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color, color.withOpacity(0)],
          ),
        ),
      ),
    );
  }
}

/// The closing strip of the footer — copyright + a quiet way back to the
/// top of the page, set apart from the columns above by its own divider
/// so the footer reads as two clear tiers instead of one long block.
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
          constraints: const BoxConstraints(maxWidth: 1240),
          child: Padding(
            padding: EdgeInsets.fromLTRB(hPad, 22, hPad, 22),
            child: const Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              runSpacing: 12,
              children: [
                Wrap(
                  runSpacing: 4,
                  children: [
                    Text(
                      '\u00a9 ${Company.founded} ${Company.name}. '
                      'All rights reserved.',
                      style: TextStyle(color: Colors.white38, fontSize: 12.5),
                    ),

                  ],
                ),
              ],
            ),
          ),
        ),
      ),
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
    return Row(
      children: [
        _SocialIcon(
          icon: Icons.call_rounded,
          onTap: () => _open('tel:${Company.phone}'),
        ),
        const SizedBox(width: 10),
        _SocialIcon(
          icon: Icons.email_rounded,
          onTap: () => _open('mailto:${Company.email}'),
        ),
        const SizedBox(width: 10),
        _SocialIcon(
          icon: Icons.chat_rounded,
          onTap: () => _open('https://wa.me/${Company.phone.replaceAll(RegExp(r'[^0-9]'), '')}'),
        ),
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
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: hovering ? AppColors.amber : Colors.white.withOpacity(0.08),
              shape: BoxShape.circle,
              border: Border.all(color: hovering ? AppColors.amberDeep : Colors.white24),
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

class _FooterColumn extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _FooterColumn({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 14.5,
          ),
        ),
        const SizedBox(height: 4),
        Container(width: 24, height: 2, color: AppColors.amber),
        const SizedBox(height: 18),
        ...children,
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: HoverBuilder(
        builder: (context, hovering) {
          return GestureDetector(
            onTap: () => context.go(path),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  width: hovering ? 12 : 0,
                  height: 1.4,
                  margin: EdgeInsets.only(right: hovering ? 6 : 0),
                  color: AppColors.amber,
                ),
                Text(
                  label,
                  style: TextStyle(
                    color: hovering ? Colors.white : Colors.white60,
                    fontSize: 13.5,
                    fontWeight: hovering ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _FooterInfo extends StatelessWidget {
  final IconData icon;
  final String text;
  const _FooterInfo({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.06),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white12),
            ),
            child: Icon(icon, color: AppColors.amber, size: 14),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white60, fontSize: 13.5),
            ),
          ),
        ],
      ),
    );
  }
}
