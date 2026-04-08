import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/vehicle_crime.dart';

/// Displays a vehicle's stats in a compact format
class VehicleStatsDisplay extends StatelessWidget {
  final Vehicle vehicle;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onRepair;
  final VoidCallback? onRefuel;

  const VehicleStatsDisplay({
    super.key,
    required this.vehicle,
    this.isSelected = false,
    this.onTap,
    this.onRepair,
    this.onRefuel,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected ? Colors.amber : Colors.grey,
          width: isSelected ? 3 : 1,
        ),
        borderRadius: BorderRadius.circular(8),
        color: Colors.black87,
        boxShadow: isSelected
            ? [BoxShadow(color: Colors.amber, blurRadius: 10)]
            : null,
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Vehicle Type + Selected Badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      vehicle.vehicleType ?? 'Unknown',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (isSelected)
                    Chip(
                      label: Text('✓ ${l10n.selectCrimeVehicle}'),
                      backgroundColor: Colors.amber,
                      labelStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 10,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),

              // Vehicle Stats Grid
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                children: [
                  _StatBar(
                    label: l10n.vehicleSpeed,
                    value: vehicle.speed?.toInt() ?? 50,
                    max: 100,
                    color: Colors.blue,
                  ),
                  _StatBar(
                    label: l10n.vehicleArmor,
                    value: vehicle.armor?.toInt() ?? 50,
                    max: 100,
                    color: Colors.red,
                  ),
                  _StatBar(
                    label: l10n.vehicleStealth,
                    value: vehicle.stealth?.toInt() ?? 50,
                    max: 100,
                    color: Colors.purple,
                  ),
                  _StatBar(
                    label: l10n.vehicleCargo,
                    value: vehicle.cargo?.toInt() ?? 50,
                    max: 100,
                    color: Colors.green,
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Condition and Fuel
              Row(
                children: [
                  Expanded(
                    child: _ConditionBar(
                      label: l10n.vehicleCondition,
                      value: vehicle.condition ?? 100,
                      isBroken: vehicle.isBroken ?? false,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _FuelBar(
                      label: l10n.vehicleFuel,
                      current: vehicle.fuel ?? 100,
                      max: vehicle.maxFuel ?? 100,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (onRepair != null)
                    ElevatedButton.icon(
                      onPressed: vehicle.condition! < 99 ? onRepair : null,
                      icon: const Icon(Icons.build, size: 16),
                      label: Text(l10n.vehicleRepair),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        backgroundColor: Colors.orange,
                      ),
                    ),
                  if (onRefuel != null)
                    ElevatedButton.icon(
                      onPressed: vehicle.fuel! < (vehicle.maxFuel! - 1)
                          ? onRefuel
                          : null,
                      icon: const Icon(Icons.local_gas_station, size: 16),
                      label: Text(l10n.vehicleRefuel),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        backgroundColor: Colors.lightBlue,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Individual stat bar (speed, armor, etc.)
class _StatBar extends StatelessWidget {
  final String label;
  final int value;
  final int max;
  final Color color;

  const _StatBar({
    required this.label,
    required this.value,
    required this.max,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '$value',
              style: TextStyle(
                fontSize: 11,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: LinearProgressIndicator(
            value: value / max,
            backgroundColor: Colors.grey[800]!,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}

/// Condition bar with warning colors
class _ConditionBar extends StatelessWidget {
  final String label;
  final double value;
  final bool isBroken;

  const _ConditionBar({
    required this.label,
    required this.value,
    required this.isBroken,
  });

  @override
  Widget build(BuildContext context) {
    Color getColor() {
      if (isBroken) return Colors.red;
      if (value < 20) return Colors.orange;
      if (value < 50) return Colors.yellow;
      return Colors.green;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${value.toStringAsFixed(1)}%',
              style: TextStyle(
                fontSize: 11,
                color: getColor(),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: LinearProgressIndicator(
            value: value / 100,
            backgroundColor: Colors.grey[800]!,
            valueColor: AlwaysStoppedAnimation<Color>(getColor()),
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}

/// Fuel bar with visual representation
class _FuelBar extends StatelessWidget {
  final String label;
  final int current;
  final int max;

  const _FuelBar({
    required this.label,
    required this.current,
    required this.max,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (current / max * 100).toInt();

    Color getColor() {
      if (percentage < 15) return Colors.red;
      if (percentage < 30) return Colors.orange;
      return Colors.lightBlue;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '$current/$max',
              style: TextStyle(
                fontSize: 11,
                color: getColor(),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: LinearProgressIndicator(
            value: percentage / 100,
            backgroundColor: Colors.grey[800]!,
            valueColor: AlwaysStoppedAnimation<Color>(getColor()),
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}
