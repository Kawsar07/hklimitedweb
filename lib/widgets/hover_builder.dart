import 'package:flutter/material.dart';

/// Tracks mouse-hover state and hands it to [builder].
///
/// Before this, every interactive widget on the site (CTA buttons, product
/// cards, nav links, footer links, social icons, back-to-top) each carried
/// its own `StatefulWidget` + `bool _hovering` + `MouseRegion` boilerplate.
/// That's ~10 lines duplicated 7+ times for identical behaviour. This
/// widget is that logic written once; everything else becomes a plain
/// `StatelessWidget` again.
class HoverBuilder extends StatefulWidget {
  final Widget Function(BuildContext context, bool hovering) builder;
  final MouseCursor cursor;

  const HoverBuilder({
    super.key,
    required this.builder,
    this.cursor = SystemMouseCursors.click,
  });

  @override
  State<HoverBuilder> createState() => _HoverBuilderState();
}

class _HoverBuilderState extends State<HoverBuilder> {
  bool _hovering = false;

  void _setHover(bool value) {
    // Guards against redundant setState calls (e.g. duplicate enter
    // events), so we only ever rebuild when the value actually flips.
    if (_hovering != value) setState(() => _hovering = value);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.cursor,
      onEnter: (_) => _setHover(true),
      onExit: (_) => _setHover(false),
      child: widget.builder(context, _hovering),
    );
  }
}
