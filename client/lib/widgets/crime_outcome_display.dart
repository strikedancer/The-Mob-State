import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

/// Displays crime outcome with detailed information
class CrimeOutcomeDisplay extends StatelessWidget {
  final String outcome;
  final String message;
  final bool success;
  final int reward;
  final int xpGained;
  final double? vehicleConditionLoss;
  final int? toolDamageSustained;
  final VoidCallback? onDismiss;

  const CrimeOutcomeDisplay({
    super.key,
    required this.outcome,
    required this.message,
    required this.success,
    required this.reward,
    required this.xpGained,
    this.vehicleConditionLoss,
    this.toolDamageSustained,
    this.onDismiss,
  });

  /// Get icon and color for outcome
  ({IconData icon, Color color, String emoji}) _getOutcomeStyle() {
    switch (outcome) {
      case 'success':
        return (emoji: '✅', icon: Icons.check_circle, color: Colors.green);
      case 'caught':
        return (emoji: '🚨', icon: Icons.error, color: Colors.red);
      case 'out_of_fuel':
        return (
          emoji: '⛽',
          icon: Icons.local_gas_station,
          color: Colors.orange,
        );
      case 'vehicle_breakdown_before':
      case 'vehicle_breakdown_during':
        return (emoji: '🔧', icon: Icons.build_circle, color: Colors.orange);
      case 'tool_broke':
        return (emoji: '🔨', icon: Icons.build, color: Colors.deepOrange);
      case 'fled_no_loot':
        return (emoji: '💨', icon: Icons.directions_run, color: Colors.yellow);
      default:
        return (emoji: '❓', icon: Icons.help_outline, color: Colors.grey);
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = _getOutcomeStyle();
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: style.color, width: 2),
        borderRadius: BorderRadius.circular(12),
        color: Colors.black87,
        boxShadow: [
          BoxShadow(color: style.color.withOpacity(0.5), blurRadius: 15),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Outcome Header
            Row(
              children: [
                Icon(style.icon, color: style.color, size: 32),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        success
                            ? l10n.crimeOutcomeSuccess
                            : _getOutcomeTitle(l10n),
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              color: style.color,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        message,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[300],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Outcome Details
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  _OutcomeRow(
                    label: 'Reward:',
                    value: '€${reward.toStringAsFixed(0)}',
                    valueColor: reward > 0 ? Colors.green : Colors.red,
                  ),
                  const SizedBox(height: 8),
                  _OutcomeRow(
                    label: 'XP:',
                    value: '+$xpGained',
                    valueColor: Colors.blue,
                  ),
                  if (vehicleConditionLoss != null) ...[
                    const SizedBox(height: 8),
                    _OutcomeRow(
                      label: '${l10n.vehicleCondition}:',
                      value: '-${vehicleConditionLoss!.toStringAsFixed(2)}%',
                      valueColor: Colors.orange,
                    ),
                  ],
                  if (toolDamageSustained != null) ...[
                    const SizedBox(height: 8),
                    _OutcomeRow(
                      label: 'Tools:',
                      value: '-$toolDamageSustained% durability',
                      valueColor: Colors.deepOrange,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Dismiss Button
            if (onDismiss != null)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onDismiss,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: style.color,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    'OK',
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _getOutcomeTitle(AppLocalizations l10n) {
    switch (outcome) {
      case 'caught':
        return l10n.crimeOutcomeCaught;
      case 'out_of_fuel':
        return l10n.crimeOutcomeOutOfFuel;
      case 'vehicle_breakdown_before':
        return l10n.crimeOutcomeVehicleBreakdownBefore;
      case 'vehicle_breakdown_during':
        return l10n.crimeOutcomeVehicleBreakdownDuring;
      case 'tool_broke':
        return l10n.crimeOutcomeToolBroke;
      case 'fled_no_loot':
        return l10n.crimeOutcomeFledNoLoot;
      default:
        return 'Crime Result';
    }
  }
}

/// Single row in outcome details
class _OutcomeRow extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const _OutcomeRow({
    required this.label,
    required this.value,
    this.valueColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.grey[300]),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: valueColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
