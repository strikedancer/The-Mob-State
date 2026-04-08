import 'package:flutter/material.dart';
import '../models/vehicle.dart';
import '../l10n/app_localizations.dart';
import 'overlay_image.dart';
import '../utils/formatters.dart';

class VehicleCard extends StatelessWidget {
  final VehicleInventoryItem vehicle;
  final VoidCallback? onSell;
  final VoidCallback? onScrap;
  final VoidCallback? onRepair;
  final VoidCallback? onRefuel;
  final VoidCallback? onList;
  final VoidCallback? onSelectForCrimes;
  final VoidCallback? onDeselectForCrimes;
  final bool isSelectedForCrimes;

  const VehicleCard({
    super.key,
    required this.vehicle,
    this.onSell,
    this.onScrap,
    this.onRepair,
    this.onRefuel,
    this.onList,
    this.onSelectForCrimes,
    this.onDeselectForCrimes,
    this.isSelectedForCrimes = false,
  });

  Color _getConditionColor() {
    final colorName = vehicle.getConditionColor();
    switch (colorName) {
      case 'green':
        return Colors.green;
      case 'orange':
        return Colors.orange;
      case 'red':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getFuelColor() {
    final colorName = vehicle.getFuelColor();
    switch (colorName) {
      case 'green':
        return Colors.green;
      case 'orange':
        return Colors.orange;
      case 'red':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getTimeRemaining(DateTime? arrival, BuildContext context) {
    if (arrival == null) return '';

    final now = DateTime.now();
    final diff = arrival.difference(now);

    if (diff.isNegative) return '';

    return formatAdaptiveDuration(
      diff,
      localeName: Localizations.localeOf(context).languageCode,
      includeSeconds: diff.inHours == 0,
    );
  }

  bool _isInTransit() {
    return vehicle.transportStatus != null;
  }

  bool _isUnderRepair() {
    return vehicle.repairInProgress;
  }

  String _formatLocation(String location) {
    // Capitalize first letter of each word
    return location
        .split(' ')
        .map((word) {
          if (word.isEmpty) return word;
          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        })
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final selectedImage = vehicle.conditionImage;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = MediaQuery.of(context).size.width < 600;
        final imageHeight = isSmallScreen ? 120.0 : 200.0;
        final padding = isSmallScreen ? 8.0 : 12.0;

        return Card(
          elevation: 4,
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Vehicle Image with Stats Overlay
                SizedBox(
                  height: imageHeight,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      // Image
                      selectedImage != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: OverlayImageBuilder()
                                  .base('images/vehicles/$selectedImage')
                                  .inTransit(
                                    when: vehicle.transportStatus != null,
                                  )
                                  .width(double.infinity)
                                  .height(double.infinity)
                                  .fit(BoxFit.contain)
                                  .build(),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[800],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: _buildPlaceholder(),
                            ),
                    ],
                  ),
                ),
                SizedBox(height: isSmallScreen ? 6 : 12),

                // Transport Status Badge
                if (vehicle.transportStatus != null) ...[
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: isSmallScreen ? 2 : 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.orange, width: 1),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.local_shipping,
                          size: 12,
                          color: Colors.orange,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'In transport • ${_getTimeRemaining(vehicle.transportArrivalTime, context)}',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Colors.orange,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
                if (_isUnderRepair()) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.purple.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.purple, width: 1),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.build_circle,
                          size: 12,
                          color: Colors.purple,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'In reparatie • ${_getTimeRemaining(vehicle.repairCompletesAt, context)}',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Colors.purple,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                ],

                // Vehicle Name
                Text(
                  vehicle.definition?.name ?? 'Unknown Vehicle',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: isSmallScreen ? 6 : 12),

                // Condition Bar
                _buildStatusBar(
                  label: 'Conditie',
                  value: vehicle.condition,
                  color: _getConditionColor(),
                ),
                const SizedBox(height: 8),

                // Fuel Bar
                _buildStatusBar(
                  label: 'Brandstof',
                  value: vehicle.fuelLevel,
                  color: _getFuelColor(),
                ),
                const SizedBox(height: 8),

                // Market Value
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Waarde:', style: theme.textTheme.bodySmall),
                    Text(
                      '€${vehicle.getMarketValue().toStringAsFixed(0)}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                // Location
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Locatie:', style: theme.textTheme.bodySmall),
                    Text(
                      _isInTransit()
                          ? 'Onderweg → ${_formatLocation(vehicle.transportDestination ?? vehicle.currentLocation ?? 'Unknown')}'
                          : _formatLocation(
                              vehicle.currentLocation ?? 'Unknown',
                            ),
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: _isInTransit() ? Colors.orange : null,
                      ),
                    ),
                  ],
                ),

                // Stats and Actions sections
                SizedBox(height: isSmallScreen ? 6 : 12),
                // Stats Badges
                if (vehicle.definition?.stats != null) ...[
                  Center(
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: isSmallScreen ? 4.0 : 8.0,
                      runSpacing: isSmallScreen ? 4.0 : 8.0,
                      children: [
                        _buildStatBadge(
                          icon: Icons.speed,
                          value: vehicle.definition!.stats!.speed ?? 0,
                          tooltip: 'Snelheid',
                        ),
                        _buildStatBadge(
                          icon: Icons.shield,
                          value: vehicle.definition!.stats!.armor ?? 0,
                          tooltip: 'Pantser',
                        ),
                        _buildStatBadge(
                          icon: Icons.inventory_2,
                          value: vehicle.definition!.stats!.cargo ?? 0,
                          tooltip: 'Lading',
                        ),
                        _buildStatBadge(
                          icon: Icons.visibility_off,
                          value: vehicle.definition!.stats!.stealth ?? 0,
                          tooltip: 'Stealth',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 6 : 12),
                ],

                // Action Buttons
                Center(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 0,
                    runSpacing: 0,
                    children: [
                      if (isSelectedForCrimes && onDeselectForCrimes != null)
                        _buildActionButton(
                          label: l10n.deselectButton,
                          icon: Icons.cancel,
                          color: Colors.deepOrange,
                          onPressed: vehicle.isBusy
                              ? null
                              : onDeselectForCrimes!,
                        )
                      else if (onSelectForCrimes != null)
                        _buildActionButton(
                          label: l10n.selectButton,
                          icon: Icons.gavel,
                          color: Colors.red,
                          onPressed: vehicle.isBusy ? null : onSelectForCrimes!,
                        ),
                      if (onRefuel != null && vehicle.fuelLevel < 100)
                        _buildActionButton(
                          label: 'Tanken',
                          icon: Icons.local_gas_station,
                          color: Colors.amber,
                          onPressed: vehicle.isBusy ? null : onRefuel!,
                        ),
                      if (onRepair != null && vehicle.condition < 100)
                        _buildActionButton(
                          label: 'Repareer',
                          icon: Icons.build,
                          color: Colors.purple,
                          onPressed: vehicle.isBusy ? null : onRepair!,
                        ),
                      if (onList != null && !vehicle.marketListing)
                        _buildActionButton(
                          label: 'Adverteer',
                          icon: Icons.storefront,
                          color: Colors.blue,
                          onPressed: vehicle.isBusy ? null : onList!,
                        ),
                      if (onSell != null)
                        _buildActionButton(
                          label: 'Verkoop',
                          icon: Icons.sell,
                          color: Colors.green,
                          onPressed: vehicle.isBusy ? null : onSell!,
                        ),
                      if (onScrap != null)
                        _buildActionButton(
                          label: 'Sloop',
                          icon: Icons.recycling,
                          color: Colors.red,
                          onPressed: vehicle.isBusy ? null : onScrap!,
                        ),
                    ],
                  ),
                ),

                // Market listing indicator
                if (vehicle.marketListing) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.storefront,
                          size: 16,
                          color: Colors.blue,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Te koop voor €${vehicle.askingPrice}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPlaceholder() {
    return Center(
      child: Icon(
        vehicle.vehicleType == 'car'
            ? Icons.directions_car
            : Icons.directions_boat,
        size: 48,
        color: Colors.grey[600],
      ),
    );
  }

  Widget _buildStatusBar({
    required String label,
    required int value,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 12)),
            Text(
              '$value%',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: value / 100,
          backgroundColor: Colors.grey[700],
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: 6,
        ),
      ],
    );
  }

  Widget _buildStatBadge({
    required IconData icon,
    required int value,
    required String tooltip,
  }) {
    const goldColor = Color(0xFFD4AF37);
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = MediaQuery.of(context).size.width < 600;
        final iconSize = isSmallScreen ? 12.0 : 14.0;
        final fontSize = isSmallScreen ? 10.0 : 12.0;
        final padding = isSmallScreen
            ? const EdgeInsets.symmetric(horizontal: 4, vertical: 2)
            : const EdgeInsets.symmetric(horizontal: 6, vertical: 4);

        return Tooltip(
          message: tooltip,
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: goldColor, width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: iconSize, color: goldColor),
                SizedBox(width: isSmallScreen ? 2 : 4),
                Text(
                  value.toString(),
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback? onPressed,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = MediaQuery.of(context).size.width < 600;
        final iconSize = isSmallScreen ? 14.0 : 20.0;

        return Tooltip(
          message: label,
          child: IconButton(
            icon: Icon(icon),
            color: onPressed != null ? color : Colors.grey,
            onPressed: onPressed,
            iconSize: iconSize,
            constraints: BoxConstraints(
              minWidth: isSmallScreen ? 28 : 40,
              minHeight: isSmallScreen ? 28 : 40,
            ),
            style: IconButton.styleFrom(
              padding: EdgeInsets.all(isSmallScreen ? 2 : 8),
            ),
          ),
        );
      },
    );
  }
}
