import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/vehicle.dart';
import 'overlay_image.dart';

const Color _gold = Color(0xFFD4AF37);
const Color _panelDark = Color(0xFF1B1212);
const Color _panelLight = Color(0xFF2A1A1A);
const Color _accent = Color(0xFFF0A04B);

enum VehicleDisposeKind { sell, scrap, chop, opsContract }

VehicleInventoryItem? chopContractCandidate({
  required Iterable<VehicleInventoryItem> inventory,
  required String vehicleType,
  required int minCondition,
}) {
  final type = vehicleType.toLowerCase();
  final eligible = inventory.where((item) {
    if ((item.vehicleType ?? '').toLowerCase() != type) return false;
    if (item.marketListing) return false;
    if (item.transportStatus != null) return false;
    if (item.showroomPropertyId != null) return false;
    if (item.repairInProgress) return false;
    return item.condition >= minCondition;
  }).toList();
  eligible.sort((a, b) {
    final byCondition = a.condition.compareTo(b.condition);
    if (byCondition != 0) return byCondition;
    return a.id.compareTo(b.id);
  });
  return eligible.isEmpty ? null : eligible.first;
}

Future<bool> showVehicleDisposeConfirmDialog({
  required BuildContext context,
  required VehicleDisposeKind kind,
  VehicleInventoryItem? vehicle,
  String? vehicleName,
  String? imageFile,
  String? payout,
  String? imageAssetPath,
  IconData? fallbackIcon,
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.72),
    builder: (dialogContext) {
      return _VehicleDisposeConfirmDialog(
        kind: kind,
        vehicle: vehicle,
        vehicleName: vehicleName,
        imageFile: imageFile,
        payout: payout,
        imageAssetPath: imageAssetPath,
        fallbackIcon: fallbackIcon,
      );
    },
  );
  return confirmed == true;
}

class _VehicleDisposeConfirmDialog extends StatelessWidget {
  const _VehicleDisposeConfirmDialog({
    required this.kind,
    this.vehicle,
    this.vehicleName,
    this.imageFile,
    this.payout,
    this.imageAssetPath,
    this.fallbackIcon,
  });

  final VehicleDisposeKind kind;
  final VehicleInventoryItem? vehicle;
  final String? vehicleName;
  final String? imageFile;
  final String? payout;
  final String? imageAssetPath;
  final IconData? fallbackIcon;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final name = (vehicleName ?? vehicle?.definition?.name ?? '').trim();
    final displayName = name.isEmpty ? l10n.vehicleHeistGenericVehicle : name;
    final type = vehicle?.vehicleType;
    final fileName = imageFile ?? vehicle?.conditionImage;
    final image = (imageAssetPath != null && imageAssetPath!.isNotEmpty)
        ? imageAssetPath
        : (fileName != null && fileName.isNotEmpty)
            ? 'assets/images/vehicles/$fileName'
            : null;
    final icon = fallbackIcon ??
        switch (type) {
          'motorcycle' => Icons.two_wheeler,
          'boat' => Icons.sailing,
          _ => Icons.directions_car,
        };

    final title = switch (kind) {
      VehicleDisposeKind.sell => l10n.vehicleDisposeSellTitle,
      VehicleDisposeKind.scrap => l10n.vehicleDisposeScrapTitle,
      VehicleDisposeKind.chop => l10n.vehicleDisposeChopTitle,
      VehicleDisposeKind.opsContract => l10n.vehicleDisposeOpsContractTitle,
    };
    final body = switch (kind) {
      VehicleDisposeKind.sell => l10n.vehicleDisposeSellBody(
          displayName,
          payout ?? '€0',
        ),
      VehicleDisposeKind.scrap => l10n.vehicleDisposeScrapBody(displayName),
      VehicleDisposeKind.chop => name.isEmpty
          ? l10n.vehicleDisposeChopBodyUnknown(payout ?? '€0')
          : l10n.vehicleDisposeChopBody(displayName, payout ?? '€0'),
      VehicleDisposeKind.opsContract => l10n.vehicleDisposeOpsContractBody,
    };
    final confirmLabel = switch (kind) {
      VehicleDisposeKind.sell => l10n.sell,
      VehicleDisposeKind.scrap => l10n.vehicleGarageScrapAction,
      VehicleDisposeKind.chop => l10n.vehicleHeistOpsClaimContractButton,
      VehicleDisposeKind.opsContract => l10n.vehicleHeistOpsOpsContractButton,
    };
    final showVehicleArt = kind != VehicleDisposeKind.opsContract;
    final destructive = kind != VehicleDisposeKind.opsContract;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [_panelLight, _panelDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _gold.withValues(alpha: 0.45)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _accent.withValues(alpha: 0.16),
                      border: Border.all(color: _accent, width: 1.4),
                    ),
                    child: Icon(
                      kind == VehicleDisposeKind.opsContract
                          ? Icons.assignment_turned_in
                          : icon,
                      size: 28,
                      color: _accent,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: _gold,
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    body,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white70,
                      height: 1.4,
                      fontSize: 14,
                    ),
                  ),
                  if (showVehicleArt) ...[
                    const SizedBox(height: 12),
                    if (image != null && image.isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: _gold.withValues(alpha: 0.35),
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: OverlayImageBuilder()
                              .base(image)
                              .width(double.infinity)
                              .height(132)
                              .fit(BoxFit.contain)
                              .build(),
                        ),
                      )
                    else
                      Container(
                        width: double.infinity,
                        height: 96,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.35),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white12),
                        ),
                        child: Icon(icon, size: 40, color: Colors.white38),
                      ),
                    if (vehicle != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        '${l10n.condition} ${vehicle!.condition}%',
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Text(
                      l10n.vehicleDisposeIrreversible,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: destructive
                            ? const Color(0xFFE85D4C)
                            : Colors.white54,
                        fontWeight: FontWeight.w700,
                        fontSize: 12.5,
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white70,
                            minimumSize: const Size.fromHeight(46),
                          ),
                          child: Text(l10n.cancel),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context, true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _gold,
                            foregroundColor: const Color(0xFF1B1212),
                            elevation: 0,
                            minimumSize: const Size.fromHeight(46),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            confirmLabel,
                            style: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
