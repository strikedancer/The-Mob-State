import 'package:flutter/material.dart';

import '../utils/collection_view_layout_prefs.dart';

/// Drawn icons (no Material font) so Flutter web always shows list / 4 / 9 glyphs.
enum CollectionViewLayoutGlyph { list, grid4, grid9 }

class CollectionViewLayoutGlyphIcon extends StatelessWidget {
  final CollectionViewLayoutGlyph glyph;
  final Color color;

  const CollectionViewLayoutGlyphIcon({
    super.key,
    required this.glyph,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    switch (glyph) {
      case CollectionViewLayoutGlyph.list:
        return SizedBox(
          width: 20,
          height: 16,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              3,
              (_) => Container(
                height: 3,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ),
          ),
        );
      case CollectionViewLayoutGlyph.grid4:
        return _buildSquareGrid(cols: 2, rows: 2, gap: 2, cell: 8);
      case CollectionViewLayoutGlyph.grid9:
        return _buildSquareGrid(cols: 3, rows: 3, gap: 1.5, cell: 5);
    }
  }

  Widget _buildSquareGrid({
    required int cols,
    required int rows,
    required double gap,
    required double cell,
  }) {
    return SizedBox(
      width: cols * cell + (cols - 1) * gap,
      height: rows * cell + (rows - 1) * gap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(rows, (_) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              cols,
              (_) => Container(
                width: cell,
                height: cell,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class CollectionViewLayoutToolbar extends StatelessWidget {
  final CollectionViewLayout selected;
  final ValueChanged<CollectionViewLayout> onChanged;
  final String label;
  final String listTooltip;
  final String grid4Tooltip;
  final String grid7Tooltip;
  final Color accent;

  const CollectionViewLayoutToolbar({
    super.key,
    required this.selected,
    required this.onChanged,
    required this.label,
    required this.listTooltip,
    required this.grid4Tooltip,
    required this.grid7Tooltip,
    this.accent = const Color(0xFFFFB347),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: accent.withValues(alpha: 0.55)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _iconButton(
                      layout: CollectionViewLayout.list,
                      glyph: CollectionViewLayoutGlyph.list,
                      tooltip: listTooltip,
                    ),
                    _iconButton(
                      layout: CollectionViewLayout.grid4,
                      glyph: CollectionViewLayoutGlyph.grid4,
                      tooltip: grid4Tooltip,
                    ),
                    _iconButton(
                      layout: CollectionViewLayout.grid7,
                      glyph: CollectionViewLayoutGlyph.grid9,
                      tooltip: grid7Tooltip,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconButton({
    required CollectionViewLayout layout,
    required CollectionViewLayoutGlyph glyph,
    required String tooltip,
  }) {
    final isSelected = selected == layout;
    final color = isSelected ? accent : Colors.white;
    return Tooltip(
      message: tooltip,
      child: Material(
        color: isSelected ? accent.withValues(alpha: 0.28) : Colors.transparent,
        borderRadius: BorderRadius.circular(7),
        child: InkWell(
          borderRadius: BorderRadius.circular(7),
          onTap: () => onChanged(layout),
          child: SizedBox(
            width: 48,
            height: 40,
            child: Center(
              child: CollectionViewLayoutGlyphIcon(glyph: glyph, color: color),
            ),
          ),
        ),
      ),
    );
  }
}
