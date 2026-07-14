import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'core/app_theme.dart';
import 'core/content.dart';
import 'pages/about_page.dart';
import 'pages/contact_page.dart';
import 'pages/home_page.dart';
import 'pages/products_page.dart';
import 'pages/why_us_page.dart';

void main() {
  runApp(
    // ProviderScope must sit above everything that reads a Riverpod
    // provider — the contact form's state lives behind this.
    const ProviderScope(child: SolarPvHkApp()),
  );
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
      final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
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
      path: '/why-us',
      pageBuilder: (context, state) => _fadePage(const WhyUsPage()),
    ),
    GoRoute(
      path: '/contact',
      pageBuilder: (context, state) => _fadePage(const ContactPage()),
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
            const Icon(Icons.error_outline_rounded, size: 48, color: AppColors.inkMuted),
            const SizedBox(height: 16),
            Text('Page not found', style: Theme.of(context).textTheme.headlineMedium),
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
