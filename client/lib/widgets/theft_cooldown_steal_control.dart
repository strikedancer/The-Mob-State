import 'package:flutter/material.dart';

/// Steal knop: normaal een [OutlinedButton.icon]; bij actieve cooldown één omlijnde
/// control met timer + label (of alleen icon) en bliksem **binnen** dezelfde rand
/// (losse `OutlinedButton` met `onPressed: null` blokkeert buitenliggende taps op web).
class TheftCooldownStealControl extends StatelessWidget {
  const TheftCooldownStealControl({
    super.key,
    required this.cooldownActive,
    required this.actionInProgress,
    required this.foregroundColor,
    required this.borderColor,
    required this.leadingIcon,
    required this.label,
    required this.onSteal,
    required this.onCreditRedeem,
    required this.boltTooltip,
    this.compact = false,
    this.iconOnlyWhenCooldown = false,
    this.iconSize = 16,
  });

  final bool cooldownActive;
  final bool actionInProgress;
  final Color foregroundColor;
  final Color borderColor;
  final IconData leadingIcon;
  final String label;
  final VoidCallback onSteal;
  final VoidCallback onCreditRedeem;
  final String boltTooltip;
  final bool compact;
  /// Kleine header (garage/marina mobiel): alleen icon + bliksem, geen tekst.
  final bool iconOnlyWhenCooldown;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final style = OutlinedButton.styleFrom(
      foregroundColor: foregroundColor,
      side: BorderSide(color: borderColor),
      visualDensity: compact ? VisualDensity.compact : VisualDensity.standard,
      padding: compact
          ? const EdgeInsets.symmetric(horizontal: 10, vertical: 6)
          : const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );

    if (!cooldownActive) {
      return OutlinedButton.icon(
        onPressed: actionInProgress ? null : onSteal,
        icon: Icon(leadingIcon, size: iconSize),
        label: Text(label),
        style: style,
      );
    }

    final radius = compact ? 10.0 : 12.0;
    final verticalPad = compact ? 6.0 : 8.0;
    final leftPad = compact ? 10.0 : 12.0;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(radius),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(color: borderColor.withOpacity(0.9)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: leftPad,
                right: iconOnlyWhenCooldown ? 4 : 6,
                top: verticalPad,
                bottom: verticalPad,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(leadingIcon, size: iconSize, color: foregroundColor),
                  if (!iconOnlyWhenCooldown && label.isNotEmpty) ...[
                    SizedBox(width: compact ? 6 : 8),
                    Text(
                      label,
                      style: TextStyle(
                        color: foregroundColor,
                        fontWeight: FontWeight.w600,
                        fontSize: compact ? 12.5 : 14,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Tooltip(
              message: boltTooltip,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: actionInProgress ? null : onCreditRedeem,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(radius),
                    bottomRight: Radius.circular(radius),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: compact ? 8 : 10,
                      vertical: verticalPad,
                    ),
                    child: Icon(
                      Icons.bolt,
                      size: iconSize + 5,
                      color: Colors.amber.shade400,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
