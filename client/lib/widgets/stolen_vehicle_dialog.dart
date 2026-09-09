import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../models/vehicle.dart';
import '../providers/auth_provider.dart';
import '../providers/vehicle_provider.dart';
import '../utils/formatters.dart';
import '../utils/top_right_notification.dart';
import 'overlay_image.dart';
import 'responsive_modal.dart';

const Color _gold = Color(0xFFD4AF37);
const Color _panelDark = Color(0xFF1B1212);
const Color _panelLight = Color(0xFF2A1A1A);
const Color _vehicleAccent = Color(0xFFF0A04B);
const Color _failAccent = Color(0xFFE85D4C);
const Color _xpGreen = Color(0xFF86EFAC);

String _rarityLabel(AppLocalizations l10n, String? rarity) {
  switch ((rarity ?? 'common').toLowerCase()) {
    case 'uncommon':
      return l10n.vehicleHeistRarityUncommon;
    case 'rare':
      return l10n.vehicleHeistRarityRare;
    case 'epic':
      return l10n.vehicleHeistRarityEpic;
    case 'legendary':
      return l10n.vehicleHeistRarityLegendary;
    default:
      return l10n.vehicleHeistRarityCommon;
  }
}

Color _rarityColor(String? rarity) {
  switch ((rarity ?? 'common').toLowerCase()) {
    case 'uncommon':
      return Colors.greenAccent;
    case 'rare':
      return const Color(0xFF64B5F6);
    case 'epic':
      return const Color(0xFFBA68C8);
    case 'legendary':
      return _gold;
    default:
      return Colors.white70;
  }
}

String _typeLabel(AppLocalizations l10n, String? vehicleType) {
  switch (vehicleType) {
    case 'motorcycle':
      return l10n.motorcycle;
    case 'boat':
      return l10n.vehicleTypeBoat;
    default:
      return l10n.vehicleTypeCar;
  }
}

IconData _fallbackIcon(String? vehicleType) {
  switch (vehicleType) {
    case 'motorcycle':
      return Icons.two_wheeler;
    case 'boat':
      return Icons.sailing;
    default:
      return Icons.directions_car;
  }
}

String _statText(int? value) {
  if (value == null) return '-';
  return value.toString();
}

/// Full-screen / embedded result card for vehicle theft (success with image+specs, or fail with message).
class VehicleTheftResultOverlay extends StatelessWidget {
  const VehicleTheftResultOverlay({
    super.key,
    required this.isSuccess,
    required this.onContinue,
    this.vehicle,
    this.title,
    this.message,
    this.xpGained = 0,
    this.embedded = false,
    this.onDisposeFeedback,
  });

  final bool isSuccess;
  final VehicleInventoryItem? vehicle;
  final String? title;
  final String? message;
  final int xpGained;
  final bool embedded;
  final VoidCallback onContinue;

  /// Called before [onContinue] after a sell/scrap attempt so the parent can
  /// show a toast on a still-mounted context.
  final void Function(String message, {required bool success})? onDisposeFeedback;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (isSuccess && vehicle != null) {
      return _buildSuccess(context, l10n, vehicle!);
    }
    return _buildFailOrPlainSuccess(context, l10n);
  }

  Widget _shell({
    required BuildContext context,
    required Color accent,
    required Color panelLight,
    required Color panelDark,
    required Widget child,
  }) {
    return ResponsiveModalLayout(
      embedded: embedded,
      phoneMaxWidth: 520,
      tabletMaxWidth: 620,
      desktopMaxWidth: 720,
      cardColor: panelDark,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compactWidth = constraints.maxWidth < 430;
          return Container(
            padding: EdgeInsets.all(compactWidth ? 18 : 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [panelLight, panelDark],
              ),
              border: Border.all(color: accent.withValues(alpha: 0.7), width: 1.2),
            ),
            child: SingleChildScrollView(child: child),
          );
        },
      ),
    );
  }

  Widget _buildFailOrPlainSuccess(BuildContext context, AppLocalizations l10n) {
    final accent = isSuccess ? _gold : _failAccent;
    final panelLight = isSuccess ? _panelLight : const Color(0xFF2A1515);
    final panelDark = isSuccess ? _panelDark : const Color(0xFF1B1010);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final compactWidth = screenWidth < 430;

    return _shell(
      context: context,
      accent: accent,
      panelLight: panelLight,
      panelDark: panelDark,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: compactWidth ? 56 : 64,
            height: compactWidth ? 56 : 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: accent.withValues(alpha: 0.16),
              border: Border.all(color: accent, width: 1.4),
            ),
            child: Icon(
              isSuccess ? Icons.emoji_events : Icons.cancel_outlined,
              size: compactWidth ? 30 : 34,
              color: accent,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            isSuccess
                ? l10n.vehicleHeistStolenHeadline
                : l10n.jobOutcomeFailed,
            style: TextStyle(
              fontSize: compactWidth ? 20 : 22,
              fontWeight: FontWeight.w800,
              color: accent,
            ),
            textAlign: TextAlign.center,
          ),
          if (title != null && title!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              title!,
              style: TextStyle(
                fontSize: compactWidth ? 15 : 16,
                fontWeight: FontWeight.w600,
                color: Colors.white.withValues(alpha: 0.92),
              ),
              textAlign: TextAlign.center,
            ),
          ],
          if (message != null && message!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              l10n.jobResultFlavorLabel,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Colors.white.withValues(alpha: 0.55),
                letterSpacing: 0.4,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              message!,
              style: TextStyle(
                fontSize: compactWidth ? 13 : 14,
                height: 1.35,
                color: Colors.white.withValues(alpha: 0.82),
              ),
              textAlign: TextAlign.center,
            ),
          ],
          if (isSuccess && xpGained > 0) ...[
            const SizedBox(height: 12),
            Text(
              l10n.xpReward(xpGained.toString()),
              style: const TextStyle(
                color: _xpGreen,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ],
          const SizedBox(height: 24),
          _continueButton(l10n, accent, compactWidth),
        ],
      ),
    );
  }

  Widget _buildSuccess(
    BuildContext context,
    AppLocalizations l10n,
    VehicleInventoryItem vehicle,
  ) {
    final definition = vehicle.definition;
    final stats = definition?.stats;
    final rarity = definition?.rarity;
    final rarityColor = _rarityColor(rarity);
    final image = vehicle.conditionImage;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final imageHeight = screenWidth < 600 ? 160.0 : 220.0;
    final compactWidth = screenWidth < 430;
    final type = _typeLabel(l10n, vehicle.vehicleType);
    final icon = _fallbackIcon(vehicle.vehicleType);
    final name = definition?.name ?? title ?? l10n.unknownVehicleType(type);

    return _shell(
      context: context,
      accent: _gold,
      panelLight: _panelLight,
      panelDark: _panelDark,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _vehicleAccent.withValues(alpha: 0.16),
              border: Border.all(color: _vehicleAccent, width: 1.4),
            ),
            child: Icon(icon, size: 30, color: _vehicleAccent),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.vehicleHeistStolenHeadline,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: _gold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 6,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: rarityColor.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: rarityColor.withValues(alpha: 0.55)),
                ),
                child: Text(
                  _rarityLabel(l10n, rarity),
                  style: TextStyle(
                    color: rarityColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: Colors.white24),
                ),
                child: Text(
                  type,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          if (message != null && message!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              message!,
              style: TextStyle(
                fontSize: compactWidth ? 13 : 14,
                height: 1.35,
                color: Colors.white.withValues(alpha: 0.82),
              ),
              textAlign: TextAlign.center,
            ),
          ],
          if (xpGained > 0) ...[
            const SizedBox(height: 10),
            Text(
              l10n.xpReward(xpGained.toString()),
              style: const TextStyle(
                color: _xpGreen,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ],
          const SizedBox(height: 14),
          if (image != null && image.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: _gold.withValues(alpha: 0.35)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: OverlayImageBuilder()
                    .base('assets/images/vehicles/$image')
                    .width(double.infinity)
                    .height(imageHeight)
                    .fit(BoxFit.contain)
                    .build(),
              ),
            )
          else
            Container(
              width: double.infinity,
              height: imageHeight,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white12),
              ),
              child: Icon(icon, size: 52, color: Colors.white38),
            ),
          const SizedBox(height: 14),
          LayoutBuilder(
            builder: (context, constraints) {
              final statItems = [
                (
                  label: l10n.vehicleStatSpeed,
                  value: _statText(stats?.speed),
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
                  value: _statText(stats?.armor),
                  icon: Icons.shield,
                ),
                (
                  label: l10n.vehicleStatCargo,
                  value: _statText(stats?.cargo),
                  icon: Icons.inventory_2,
                ),
                (
                  label: l10n.vehicleStatStealth,
                  value: _statText(stats?.stealth),
                  icon: Icons.visibility_off,
                ),
              ];
              final columns = constraints.maxWidth < 520 ? 1 : 2;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: statItems.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 3.6,
                ),
                itemBuilder: (context, index) {
                  final stat = statItems[index];
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: Row(
                      children: [
                        Icon(stat.icon, size: 16, color: _gold),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            stat.label,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          stat.value,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
          const SizedBox(height: 18),
          _StolenVehicleQuickActions(
            vehicle: vehicle,
            compactWidth: compactWidth,
            onKeep: onContinue,
            onDisposeFeedback: onDisposeFeedback,
          ),
        ],
      ),
    );
  }

  Widget _continueButton(AppLocalizations l10n, Color accent, bool compact) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onContinue,
        style: ElevatedButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: const Color(0xFF1B1212),
          elevation: 0,
          minimumSize: Size.fromHeight(compact ? 48 : 54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          l10n.continueAction,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}

class _StolenVehicleQuickActions extends StatefulWidget {
  const _StolenVehicleQuickActions({
    required this.vehicle,
    required this.compactWidth,
    required this.onKeep,
    this.onDisposeFeedback,
  });

  final VehicleInventoryItem vehicle;
  final bool compactWidth;
  final VoidCallback onKeep;
  final void Function(String message, {required bool success})? onDisposeFeedback;

  @override
  State<_StolenVehicleQuickActions> createState() =>
      _StolenVehicleQuickActionsState();
}

class _StolenVehicleQuickActionsState extends State<_StolenVehicleQuickActions> {
  bool _busy = false;

  Future<bool> _confirm({
    required String title,
    required String body,
    required String confirmLabel,
    required Color confirmColor,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: ElevatedButton.styleFrom(backgroundColor: confirmColor),
            child: Text(confirmLabel),
          ),
        ],
      ),
    );
    return confirmed == true;
  }

  void _finish({required String message, required bool success}) {
    if (success) {
      widget.onDisposeFeedback?.call(message, success: true);
      widget.onKeep();
      return;
    }
    if (!mounted) return;
    showTopRightFromSnackBar(
      context,
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  Future<void> _sell() async {
    if (_busy || widget.vehicle.isBusy) return;
    final l10n = AppLocalizations.of(context)!;
    final isBoat = widget.vehicle.vehicleType == 'boat';
    final confirmed = await _confirm(
      title: l10n.confirmAction,
      body: isBoat ? l10n.confirmSellBoat : l10n.confirmSellVehicle,
      confirmLabel: l10n.sell,
      confirmColor: Colors.green,
    );
    if (!confirmed || !mounted) return;

    setState(() => _busy = true);
    final provider = context.read<VehicleProvider>();
    final soldFor = await provider.sellVehicle(widget.vehicle.id);
    if (!mounted) return;

    if (soldFor != null) {
      try {
        await context.read<AuthProvider>().refreshPlayer();
      } catch (_) {}
      if (!mounted) return;
      setState(() => _busy = false);
      _finish(
        message: soldFor > 0
            ? l10n.vehicleSoldFor(formatCurrency(soldFor))
            : (isBoat ? l10n.boatSold : l10n.vehicleSold),
        success: true,
      );
      return;
    }

    setState(() => _busy = false);
    _finish(
      message: provider.error ?? l10n.saleFailed,
      success: false,
    );
  }

  Future<void> _scrap() async {
    if (_busy || widget.vehicle.isBusy) return;
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await _confirm(
      title: l10n.confirmAction,
      body: l10n.vehicleGarageScrapConfirm,
      confirmLabel: l10n.vehicleGarageScrapAction,
      confirmColor: Colors.red,
    );
    if (!confirmed || !mounted) return;

    setState(() => _busy = true);
    final provider = context.read<VehicleProvider>();
    final result = await provider.scrapVehicle(widget.vehicle.id);
    if (!mounted) return;

    if (result != null) {
      try {
        await context.read<AuthProvider>().refreshPlayer();
      } catch (_) {}
      if (!mounted) return;
      final gained = result['partsGained'] as int? ?? 0;
      final partsType =
          (result['partsType'] as String? ?? widget.vehicle.vehicleType ?? 'car')
              .toLowerCase();
      final typeLabel = switch (partsType) {
        'motorcycle' => l10n.vehicleGaragePartsTypeMotorcycle,
        'boat' => l10n.vehicleGaragePartsTypeBoat,
        _ => l10n.vehicleGaragePartsTypeCar,
      };
      final scrapPrice = result['scrapPrice'] as int? ?? 0;
      setState(() => _busy = false);
      _finish(
        message: scrapPrice > 0
            ? l10n.vehicleGarageScrapSuccessCash(
                formatCurrency(scrapPrice),
                gained.toString(),
                typeLabel,
              )
            : l10n.vehicleGarageScrapSuccess(gained.toString(), typeLabel),
        success: true,
      );
      return;
    }

    setState(() => _busy = false);
    _finish(
      message: provider.error ?? l10n.vehicleGarageScrapFailed,
      success: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final sellValue = widget.vehicle.getMarketValue();
    final sellLabel = sellValue > 0
        ? l10n.vehicleHeistSellFor(formatCurrency(sellValue))
        : l10n.sell;
    final buttonHeight = widget.compactWidth ? 48.0 : 54.0;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _busy ? null : _sell,
                icon: _busy
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.sell, size: 18),
                label: Text(
                  sellLabel,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: const Color(0xFF2E7D32)
                      .withValues(alpha: 0.4),
                  elevation: 0,
                  minimumSize: Size.fromHeight(buttonHeight),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _busy ? null : _scrap,
                icon: const Icon(Icons.recycling, size: 18),
                label: Text(
                  l10n.vehicleGarageScrapAction,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC62828),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: const Color(0xFFC62828)
                      .withValues(alpha: 0.4),
                  elevation: 0,
                  minimumSize: Size.fromHeight(buttonHeight),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: _busy ? null : widget.onKeep,
            style: OutlinedButton.styleFrom(
              foregroundColor: _gold,
              side: const BorderSide(color: _gold, width: 1.2),
              minimumSize: Size.fromHeight(buttonHeight),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              l10n.vehicleHeistKeepVehicle,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
        ),
      ],
    );
  }
}

/// Legacy dialog wrapper (garage / marina) — same success content with image + specs.
Future<void> showStolenVehicleDialog(
  BuildContext context,
  VehicleInventoryItem vehicle, {
  int xpGained = 0,
  String? message,
}) async {
  var feedbackMessage = '';
  var feedbackSuccess = false;
  await showDialog<void>(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withValues(alpha: 0.88),
    builder: (dialogContext) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: VehicleTheftResultOverlay(
          isSuccess: true,
          vehicle: vehicle,
          xpGained: xpGained,
          message: message,
          onContinue: () => Navigator.of(dialogContext).pop(),
          onDisposeFeedback: (message, {required bool success}) {
            feedbackMessage = message;
            feedbackSuccess = success;
          },
        ),
      );
    },
  );
  if (!context.mounted || feedbackMessage.isEmpty) return;
  showTopRightFromSnackBar(
    context,
    SnackBar(
      content: Text(feedbackMessage),
      backgroundColor: feedbackSuccess ? Colors.green : Colors.red,
    ),
  );
}
