import 'package:flutter/material.dart';

import 'prostitution_section_header.dart';

class ProstitutionCountdownChip extends StatelessWidget {
  final String label;
  final Color? accent;

  const ProstitutionCountdownChip({
    super.key,
    required this.label,
    this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final color = accent ?? kProstitutionGold;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
