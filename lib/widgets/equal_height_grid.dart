import 'package:flutter/material.dart';

/// A responsive card grid where every card in the same row is forced to
/// the same height — the tallest card's own natural height, nothing more.
///
/// Why this instead of a hand-measured height:
/// This uses [IntrinsicHeight] + [CrossAxisAlignment.stretch], which asks
/// Flutter's real render tree how tall each card actually wants to be and
/// then stretches every card in the row to match the tallest one. Because
/// it reads real layout instead of re-estimating text size by hand, it can
/// never fall out of sync with what's actually on screen — at any font,
/// any font-loading timing, any accessibility text-scale setting, and any
/// screen size. That's what was causing the "RenderFlex overflowed" card
/// bug: a previous version computed each card's height itself before the
/// real text had necessarily finished laying out with its final font, so
/// the frozen height could end up a line short of the real content.
///
/// An incomplete last row (e.g. 7 cards at 3 columns) is padded with
/// invisible spacers rather than stretched, so the last row's real cards
/// keep the same width as every other row instead of growing wider.
class EqualHeightGrid extends StatelessWidget {
  final List<Widget> children;

  /// Given the available width, return how many columns to lay out.
  final int Function(double maxWidth) columnsForWidth;

  final double spacing;
  final double runSpacing;

  const EqualHeightGrid({
    super.key,
    required this.children,
    required this.columnsForWidth,
    this.spacing = 24,
    this.runSpacing = 24,
  });

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = columnsForWidth(constraints.maxWidth).clamp(1, children.length);

        final rows = <List<Widget>>[];
        for (var i = 0; i < children.length; i += columns) {
          final end = (i + columns < children.length) ? i + columns : children.length;
          rows.add(children.sublist(i, end));
        }

        return Column(
          children: [
            for (int r = 0; r < rows.length; r++) ...[
              if (r != 0) SizedBox(height: runSpacing),
              _EqualHeightRow(items: rows[r], columns: columns, spacing: spacing),
            ],
          ],
        );
      },
    );
  }
}

class _EqualHeightRow extends StatelessWidget {
  final List<Widget> items;
  final int columns;
  final double spacing;

  const _EqualHeightRow({required this.items, required this.columns, required this.spacing});

  @override
  Widget build(BuildContext context) {
    final rowChildren = <Widget>[];
    for (var c = 0; c < columns; c++) {
      if (c != 0) rowChildren.add(SizedBox(width: spacing));
      // Empty invisible spacer for a short trailing row — keeps real cards
      // at the same column width as full rows instead of stretching.
      rowChildren.add(Expanded(child: c < items.length ? items[c] : const SizedBox.shrink()));
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: rowChildren,
      ),
    );
  }
}
