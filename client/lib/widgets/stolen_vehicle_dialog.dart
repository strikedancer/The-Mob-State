import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/vehicle.dart';
import 'overlay_image.dart';

/// Result popup after a successful vehicle theft (garage / marina / heist).
Future<void> showStolenVehicleDialog(
  BuildContext context,
  VehicleInventoryItem vehicle, {
  int xpGained = 0,
}) async {
  final definition = vehicle.definition;
  final stats = definition?.stats;
  final l10n = AppLocalizations.of(context)!;

  String typeLabel() {
    switch (vehicle.vehicleType) {
      case 'motorcycle':
        return l10n.motorcycle;
      case 'boat':
        return l10n.vehicleTypeBoat;
      default:
        return l10n.vehicleTypeCar;
    }
  }

  String statText(int? value) {
    if (value == null) return '-';
    return value.toString();
  }

  IconData fallbackIcon() {
    switch (vehicle.vehicleType) {
      case 'motorcycle':
        return Icons.two_wheeler;
      case 'boat':
        return Icons.sailing;
      default:
        return Icons.directions_car;
    }
  }

  await showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
      final image = vehicle.conditionImage;
      final screenWidth = MediaQuery.of(dialogContext).size.width;
      final dialogWidth = screenWidth < 600
          ? screenWidth - 32
          : screenWidth < 1024
              ? 560.0
              : 680.0;
      final imageHeight = screenWidth < 600 ? 150.0 : 220.0;
      final type = typeLabel();

      return AlertDialog(
        title: Text(l10n.stolenVehicleTitle(type)),
        content: SizedBox(
          width: dialogWidth,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (image != null && image.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: OverlayImageBuilder()
                        .base('assets/images/vehicles/$image')
                        .width(double.infinity)
                        .height(imageHeight)
                        .fit(BoxFit.contain)
                        .build(),
                  )
                else
                  Container(
                    width: double.infinity,
                    height: imageHeight,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(fallbackIcon(), size: 48),
                  ),
                const SizedBox(height: 12),
                Text(
                  definition?.name ?? l10n.unknownVehicleType(type),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                  if (xpGained > 0) ...[
                    const SizedBox(height: 8),
                    Text(
                      l10n.xpReward(xpGained.toString()),
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                const SizedBox(height: 10),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final statItems = [
                      (
                        label: l10n.vehicleStatSpeed,
                        value: statText(stats?.speed),
                        icon: Icons.speed,
                      ),
                      (
                        label: l10n.vehicleStatFuel,
                        value: '${vehicle.fuelLevel}%',
                        icon: Icons.local_gas_station,
                      ),
                      (
                        label: l10n.condition,
                        value: '${vehicle.condition}%',
                        icon: Icons.build_circle,
                      ),
                      (
                        label: l10n.armor,
                        value: statText(stats?.armor),
                        icon: Icons.shield,
                      ),
                      (
                        label: l10n.vehicleStatCargo,
                        value: statText(stats?.cargo),
                        icon: Icons.inventory_2,
                      ),
                      (
                        label: l10n.vehicleStatStealth,
                        value: statText(stats?.stealth),
                        icon: Icons.visibility_off,
                      ),
                    ];

                    final columns = constraints.maxWidth < 600 ? 1 : 2;

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: statItems.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columns,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        childAspectRatio: 3.8,
                      ),
                      itemBuilder: (context, index) {
                        final stat = statItems[index];
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.04),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                stat.icon,
                                size: 16,
                                color: Colors.grey[700],
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  stat.label,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                stat.value,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.continueAction),
          ),
        ],
      );
    },
  );
}
