import 'package:flutter/material.dart';

/// Shared noir/gold chrome for the player dashboard shell and home panels.
const Color dashboardGold = Color(0xFFFFB347);
const Color dashboardBgStart = Color(0xFF120808);
const Color dashboardBgMid = Color(0xFF1C1010);
const Color dashboardBgEnd = Color(0xFF0C0606);
const Color dashboardPanelDark = Color(0xFF161010);
const Color dashboardPanelLight = Color(0xFF221616);
const Color dashboardHairline = Color(0x33FFB347);
const Color dashboardMuted = Color(0x99FFFFFF);

BoxDecoration dashboardPanelDecoration({
  Color accent = dashboardGold,
  double radius = 10,
}) {
  return BoxDecoration(
    color: dashboardPanelDark,
    borderRadius: BorderRadius.circular(radius),
    border: Border.all(color: accent.withValues(alpha: 0.32)),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.22),
        blurRadius: 10,
        offset: const Offset(0, 3),
      ),
    ],
  );
}

class DashboardSectionTitle extends StatelessWidget {
  const DashboardSectionTitle(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 2),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 12,
            decoration: BoxDecoration(
              color: dashboardGold,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label.toUpperCase(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: dashboardGold,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardHudCell extends StatelessWidget {
  const DashboardHudCell({
    super.key,
    required this.label,
    required this.value,
    this.valueColor = Colors.white,
    this.progress,
    this.barColor,
    this.compact = false,
  });

  final String label;
  final String value;
  final Color valueColor;
  final double? progress;
  final Color? barColor;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final padH = compact ? 4.0 : 8.0;
    final valueSize = compact ? 12.0 : 13.0;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padH, vertical: compact ? 1 : 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: dashboardMuted,
              fontSize: 9,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
          SizedBox(height: compact ? 2 : 3),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: valueColor,
              fontSize: valueSize,
              fontWeight: FontWeight.w700,
              height: 1.15,
            ),
          ),
          if (progress != null) ...[
            SizedBox(height: compact ? 4 : 5),
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: progress!.clamp(0.0, 1.0),
                minHeight: 3,
                backgroundColor: Colors.white.withValues(alpha: 0.08),
                valueColor: AlwaysStoppedAnimation<Color>(
                  barColor ?? dashboardGold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class DashboardHudDivider extends StatelessWidget {
  const DashboardHudDivider({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: compact ? 22 : 28,
      color: dashboardHairline,
    );
  }
}
