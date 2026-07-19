import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:go_router/go_router.dart';
import 'core/app_theme.dart';
import 'core/content.dart';
import 'firebase_options.dart';
import 'pages/about_page.dart';
import 'pages/admin_chat_page.dart';
import 'pages/contact_page.dart';
import 'pages/home_page.dart';
import 'pages/product_detail_page.dart';
import 'pages/products_page.dart';
import 'pages/why_us_page.dart';
import 'widgets/live_chat/live_chat_overlay.dart';

/// Flips to true once Firebase.initializeApp() has actually succeeded. The
/// live-chat bubble listens to this and simply stays hidden until Firebase is
/// ready (or if it isn't configured / fails), instead of crashing the site.
///
/// It's a [ValueNotifier] rather than a plain bool so that Firebase can be
/// initialised in the background — the UI paints immediately and the chat
/// bubble appears reactively when Firebase finishes connecting.
final ValueNotifier<bool> firebaseReady = ValueNotifier<bool>(false);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Removes the "#" from web URLs (e.g. /#/home -> /home) by switching
  // Flutter web from hash-based routing to normal path-based routing.
  usePathUrlStrategy();

  // Paint the app straight away — don't block the first frame on a network
  // round-trip to Firebase. Firebase initialises in the background below and
  // the live-chat bubble switches on once it's ready.
  runApp(
    // ProviderScope must sit above everything that reads a Riverpod
    // provider — the contact form's state lives behind this.
    const ProviderScope(child: SolarPvHkApp()),
  );

  if (firebaseIsConfigured) {
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
        .then((_) => firebaseReady.value = true)
        .catchError((_) {
      // Config present but invalid/unreachable (e.g. Firestore not enabled
      // yet) — keep the rest of the site working without live chat.
      firebaseReady.value = false;
    });
  }
}

/// Wraps every route in a quick fade + gentle rise so navigating between
/// pages feels intentional instead of a hard cut — the small production
/// detail that a static swap is missing.
CustomTransitionPage<void> _fadePage(Widget child) {
  return CustomTransitionPage<void>(
    child: child,
    transitionDuration: const Duration(milliseconds: 240),
    reverseTransitionDuration: const Duration(milliseconds: 160),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved =
          CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.02),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        ),
      );
    },
  );
}

final GoRouter _router = GoRouter(
  initialLocation: '/home',
  routes: [
    GoRoute(
      path: '/',
      redirect: (context, state) => '/home',
    ),
    GoRoute(
      path: '/home',
      pageBuilder: (context, state) => _fadePage(const HomePage()),
    ),
    GoRoute(
      path: '/about',
      pageBuilder: (context, state) => _fadePage(const AboutPage()),
    ),
    GoRoute(
      path: '/products',
      pageBuilder: (context, state) => _fadePage(const ProductsPage()),
    ),
    GoRoute(
      path: '/products/:slug',
      pageBuilder: (context, state) => _fadePage(
        ProductDetailPage(slug: state.pathParameters['slug']!),
      ),
    ),
    GoRoute(
      path: '/why-us',
      pageBuilder: (context, state) => _fadePage(const WhyUsPage()),
    ),
    GoRoute(
      path: '/contact',
      pageBuilder: (context, state) => _fadePage(const ContactPage()),
    ),
    GoRoute(
      // Not in navItems / the nav bar on purpose — only reachable by
      // typing the URL. See lib/pages/admin_chat_page.dart.
      path: '/admin',
      pageBuilder: (context, state) => _fadePage(const AdminChatPage()),
    ),
  ],
  errorBuilder: (context, state) => const _NotFoundPage(),
);

class SolarPvHkApp extends StatelessWidget {
  const SolarPvHkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: Company.name,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: _router,
      builder: (context, child) {
        // Overlays the floating live-chat bubble above every route except
        // /admin, without every page needing to know about it.
        return Stack(
          children: [
            if (child != null) child,
            Overlay(
              initialEntries: [
                OverlayEntry(
                  builder: (context) =>
                      ValueListenableBuilder<RouteInformation>(
                    valueListenable: _router.routeInformationProvider,
                    builder: (context, routeInfo, _) {
                      final location = routeInfo.uri.path;
                      if (location.startsWith('/admin')) {
                        return const SizedBox.shrink();
                      }
                      return ValueListenableBuilder<bool>(
                        valueListenable: firebaseReady,
                        builder: (context, ready, _) =>
                            LiveChatOverlay(firebaseReady: ready),
                      );
                    },
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

class _NotFoundPage extends StatelessWidget {
  const _NotFoundPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded,
                size: 48, color: AppColors.inkMuted),
            const SizedBox(height: 16),
            Text('Page not found',
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () => _router.go('/home'),
              child: const Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
