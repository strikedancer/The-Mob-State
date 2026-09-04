import 'package:flutter/material.dart';

class MarketInfoPill extends StatelessWidget {
  final String label;
  final Color color;
  final IconData? icon;
  final String? tooltip;

  const MarketInfoPill({
    super.key,
    required this.label,
    required this.color,
    this.icon,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final child = Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.28)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 3),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
    if (tooltip == null || tooltip!.isEmpty) return child;
    return Tooltip(message: tooltip!, child: child);
  }
}

class MarketCompactRow extends StatelessWidget {
  final Widget leading;
  final Widget info;
  final Widget? meta;
  final Widget? action;
  final String? tooltip;
  final Color? color;
  final double breakpoint;

  const MarketCompactRow({
    super.key,
    required this.leading,
    required this.info,
    this.meta,
    this.action,
    this.tooltip,
    this.color,
    this.breakpoint = 700,
  });

  @override
  Widget build(BuildContext context) {
    final narrow = MediaQuery.sizeOf(context).width < breakpoint;
    final row = Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: color,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
        child: narrow && action != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      leading,
                      const SizedBox(width: 10),
                      Expanded(child: info),
                      if (meta != null) ...[
                        const SizedBox(width: 8),
                        meta!,
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  Align(alignment: Alignment.centerRight, child: action!),
                ],
              )
            : Row(
                children: [
                  leading,
                  const SizedBox(width: 10),
                  Expanded(child: info),
                  if (meta != null) ...[
                    const SizedBox(width: 8),
                    meta!,
                  ],
                  if (action != null) ...[
                    const SizedBox(width: 8),
                    action!,
                  ],
                ],
              ),
      ),
    );
    if (tooltip == null || tooltip!.isEmpty) return row;
    return Tooltip(
      message: tooltip!,
      waitDuration: const Duration(milliseconds: 500),
      child: row,
    );
  }
}

ButtonStyle marketBuyButtonStyle({Color background = Colors.green}) {
  return FilledButton.styleFrom(
    backgroundColor: background,
    foregroundColor: Colors.white,
    disabledBackgroundColor: background.withValues(alpha: 0.35),
    visualDensity: VisualDensity.compact,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    minimumSize: const Size(0, 34),
  );
}

Tab marketInnerTab(String label) {
  return Tab(height: 36, text: label);
}

const marketListPadding = EdgeInsets.fromLTRB(12, 8, 12, 16);

Widget marketSectionHeader(
  BuildContext context, {
  required String label,
  IconData icon = Icons.inventory_2_outlined,
}) {
  return Padding(
    padding: const EdgeInsets.only(top: 4, bottom: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(color: Theme.of(context).colorScheme.outlineVariant),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 6),
            Text(
              label,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget marketEmptyHint(String message) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 24),
    child: Column(
      children: [
        Icon(Icons.inventory_2_outlined, size: 48, color: Colors.grey.shade400),
        const SizedBox(height: 12),
        Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
        ),
      ],
    ),
  );
}

Widget marketThumbBox({
  required Widget child,
  double width = 44,
  double height = 44,
  Color? color,
}) {
  return Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: color ?? const Color(0xFF1A1F2A),
      borderRadius: BorderRadius.circular(8),
    ),
    clipBehavior: Clip.antiAlias,
    child: child,
  );
}
