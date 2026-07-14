import 'package:flutter/material.dart';
import 'footer.dart';
import 'nav_bar.dart';

/// Every page on the site is: nav bar (fixed) + scrollable content that
/// ends with the shared footer. Kept in one place so all five pages stay
/// visually consistent.
class PageScaffold extends StatelessWidget {
  final List<Widget> sections;

  const PageScaffold({super.key, required this.sections});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NavBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ...sections,
            const SiteFooter(),
          ],
        ),
      ),
    );
  }
}
