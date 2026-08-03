import 'package:flutter/material.dart';

import 'prostitution_section_header.dart';

class EmpireKpiItem {
  final String label;
  final String value;
  final IconData icon;
  final Color? accent;

  const EmpireKpiItem({
    required this.label,
    required this.value,
    required this.icon,
    this.accent,
  });
}

class EmpireKpiStrip extends StatelessWidget {
  final List<EmpireKpiItem> items;

  const EmpireKpiStrip({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 720;
        final children = items
            .map(
              (item) => _KpiCard(
                item: item,
                width: wide
                    ? (constraints.maxWidth - 24) / 3.0
                    : (constraints.maxWidth - 8) / 2.0,
              ),
            )
            .toList();

        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: children,
        );
      },
    );
  }
}

class _KpiCard extends StatelessWidget {
  final EmpireKpiItem item;
  final double width;

  const _KpiCard({required this.item, required this.width});

  @override
  Widget build(BuildContext context) {
    final accent = item.accent ?? kProstitutionGold;
    return Container(
      width: width,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accent.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Icon(item.icon, color: accent, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade400,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: accent,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
