import 'package:flutter/material.dart';
import '../models/property.dart';
import '../utils/formatters.dart';
import '../l10n/app_localizations.dart';

class PropertyCard extends StatelessWidget {
  final PropertyDefinition? definition;
  final Property? ownedProperty;
  final VoidCallback? onBuy;
  final VoidCallback? onUpgrade;
  final VoidCallback? onCollectIncome;
  final VoidCallback? onManage;
  final bool isLoading;
  final bool playerIsVip;
  final int vipBonusPerProperty;

  const PropertyCard({
    super.key,
    this.definition,
    this.ownedProperty,
    this.onBuy,
    this.onUpgrade,
    this.onCollectIncome,
    this.onManage,
    this.isLoading = false,
    this.playerIsVip = false,
    this.vipBonusPerProperty = 5,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isOwned = ownedProperty != null;
    final propertyId = isOwned
        ? (ownedProperty!.type ?? ownedProperty!.propertyId)
        : definition?.id;
    final name =
        _localizedPropertyName(propertyId, l10n) ??
        (isOwned ? ownedProperty!.name : definition?.name);
    final imagePath = isOwned
        ? ownedProperty!.imagePath
        : definition?.imagePath;

    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: isLoading
          ? _buildLoadingState()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Property Image with Overlays
                if (imagePath != null)
                  Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(4),
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Base image
                        _buildPropertyImage(imagePath),
                        // Overlays
                        if (isOwned && ownedProperty!.overlayKeys != null)
                          ..._buildOverlays(ownedProperty!.overlayKeys!),
                      ],
                    ),
                  )
                else
                  Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(4),
                      ),
                    ),
                    child: Icon(
                      _getPropertyIcon(propertyId),
                      size: 64,
                      color: Colors.grey[600],
                    ),
                  ),

                // Property Info
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name and Type
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              name ?? l10n.unknown,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (isOwned)
                            Chip(
                              label: Text(
                                l10n.propertyLevel(
                                  ownedProperty!.level.toString(),
                                ),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              backgroundColor: Colors.blue[700],
                              side: BorderSide(color: Colors.blue[900]!),
                            ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text(
                        _getPropertyTypeLabel(propertyId, l10n),
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      SizedBox(height: 12),

                      // Stats
                      if (isOwned)
                        ..._buildOwnedPropertyStats(l10n)
                      else
                        ..._buildAvailablePropertyStats(l10n),

                      SizedBox(height: 16),

                      // Actions
                      if (isOwned)
                        ..._buildOwnedPropertyActions(l10n)
                      else
                        ..._buildAvailablePropertyActions(l10n),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildPropertyImage(String path) {
    // Construct full path with properties folder
    final fullPath = path.startsWith('images/')
        ? path
        : 'images/properties/$path';

    return Image.asset(
      fullPath,
      fit: BoxFit.cover,
      width: double.infinity,
      height: 150,
      errorBuilder: (context, error, stackTrace) {
        return Icon(
          _getPropertyIcon(ownedProperty?.type ?? definition?.type),
          size: 64,
          color: Colors.grey[600],
        );
      },
    );
  }

  List<Widget> _buildOverlays(List<String> overlayKeys) {
    return overlayKeys.map((key) {
      final overlayPath = 'images/overlays/$key.png';

      // Position overlays based on type
      Alignment alignment;
      if (key.startsWith('upgraded_lvl')) {
        alignment = Alignment.topRight;
      } else if (key == 'new') {
        alignment = Alignment.topLeft;
      } else if (key == 'income_ready') {
        alignment = Alignment.bottomRight;
      } else {
        alignment = Alignment.center;
      }

      return Positioned.fill(
        child: Align(
          alignment: alignment,
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Image.asset(
              overlayPath,
              width: 50,
              height: 50,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => SizedBox.shrink(),
            ),
          ),
        ),
      );
    }).toList();
  }

  IconData _getPropertyIcon(String? propertyId) {
    switch (propertyId) {
      case 'house':
        return Icons.home;
      case 'apartment':
        return Icons.apartment;
      case 'warehouse':
        return Icons.warehouse;
      case 'nightclub':
        return Icons.nightlife;
      case 'shop':
        return Icons.store;
      case 'hotel':
        return Icons.hotel;
      case 'factory':
        return Icons.factory;
      default:
        return Icons.business;
    }
  }

  String _getPropertyTypeLabel(String? propertyId, AppLocalizations l10n) {
    switch (propertyId) {
      case 'house':
        return '🏠 ${l10n.propertyTypeHouse}';
      case 'apartment':
        return '🏢 Appartement';
      case 'warehouse':
        return '🏪 ${l10n.propertyTypeWarehouse}';
      case 'nightclub':
        return '🎵 Nachtclub';
      case 'shop':
        return '🛒 Winkel';
      case 'hotel':
        return '🏨 ${l10n.propertyTypeHotel}';
      case 'factory':
        return '🏭 ${l10n.propertyTypeFactory}';
      default:
        return '🏢 ${l10n.propertyTypeBusiness}';
    }
  }

  List<Widget> _buildAvailablePropertyStats(AppLocalizations l10n) {
    if (definition == null) return [];

    return [
      _buildStatRow(l10n.propertyPrice, formatCurrency(definition!.basePrice)),
      if (definition!.minLevel > 0) ...[
        SizedBox(height: 8),
        _buildStatRow(l10n.propertyMinLevel, '${definition!.minLevel}'),
      ],
      if (definition!.baseIncome > 0) ...[
        SizedBox(height: 8),
        _buildStatRow(
          l10n.propertyIncomePerHour,
          formatCurrency(definition!.baseIncome),
        ),
      ],
      if (definition!.storageCapacity.isNotEmpty &&
          definition!.storageCapacity[0] > 0) ...[
        SizedBox(height: 8),
        _buildStatRow(
          '📦 Opslag',
          '${definition!.storageCapacity[0]} → ${definition!.storageCapacity.last} slots',
        ),
      ],
      if ((definition!.id == 'house' || definition!.id == 'apartment') &&
          definition!.storageCapacity.isNotEmpty) ...[
        SizedBox(height: 8),
        _buildStatRow(
          '👩 Wooncapaciteit',
          '${(definition!.storageCapacity.first / 5).floor().clamp(1, 999)} → ${(definition!.storageCapacity.last / 5).floor().clamp(1, 999)} hoeren',
        ),
      ],
      SizedBox(height: 8),
      _buildStatRow(l10n.propertyMaxLevel, '${definition!.maxLevel}'),
      if (definition!.unique) ...[
        SizedBox(height: 8),
        Text(
          l10n.propertyUniquePerCountry,
          style: TextStyle(
            color: Colors.orange,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ],
    ];
  }

  List<Widget> _buildOwnedPropertyStats(AppLocalizations l10n) {
    if (ownedProperty == null) return [];
    final ownedPropertyType = ownedProperty!.type ?? ownedProperty!.propertyId;

    // Get current storage capacity based on property level
    int currentStorage = 0;
    int currentHousingCapacity = 0;
    final isResidential =
        ownedPropertyType == 'house' || ownedPropertyType == 'apartment';
    if (definition != null && definition!.storageCapacity.isNotEmpty) {
      final levelIndex = (ownedProperty!.level - 1).clamp(
        0,
        definition!.storageCapacity.length - 1,
      );
      currentStorage = definition!.storageCapacity[levelIndex];

      if (isResidential) {
        currentHousingCapacity = (currentStorage / 5).floor().clamp(1, 999);
      }
    }

    // Max housing capacity (at max level) for upgrade hint
    int maxHousingCapacity = 0;
    if (currentHousingCapacity > 0 && definition!.storageCapacity.isNotEmpty) {
      maxHousingCapacity = (definition!.storageCapacity.last / 5).floor().clamp(
        1,
        999,
      );
    }

    // VIP bonus for this property
    final effectiveCapacity =
        isResidential && playerIsVip && vipBonusPerProperty > 0
        ? currentHousingCapacity + vipBonusPerProperty
        : currentHousingCapacity;
    final effectiveMax = isResidential && playerIsVip && vipBonusPerProperty > 0
        ? maxHousingCapacity + vipBonusPerProperty
        : maxHousingCapacity;

    return [
      _buildStatRow(
        l10n.propertyIncomePerHour,
        formatCurrency(ownedProperty!.currentIncome),
      ),
      SizedBox(height: 8),
      _buildStatRow(
        l10n.level,
        '${ownedProperty!.level} / ${definition?.maxLevel ?? ownedProperty!.level}',
      ),
      if (playerIsVip && isResidential) ...[
        SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: Colors.amber[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.amber),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.star, size: 14, color: Colors.amber[800]),
              const SizedBox(width: 4),
              Text(
                'VIP +$vipBonusPerProperty plekken',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.amber[900],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
      if (currentStorage > 0) ...[
        SizedBox(height: 8),
        _buildStatRow('📦 Opslag', '$currentStorage slots'),
      ],
      if (effectiveCapacity > 0) ...[
        SizedBox(height: 8),
        _buildStatRow(
          '👩 Wooncapaciteit',
          effectiveCapacity < effectiveMax
              ? '$effectiveCapacity hoeren  (max $effectiveMax bij lvl ${definition!.maxLevel})'
              : '$effectiveCapacity hoeren  ✅ max',
        ),
      ],
      if (ownedProperty!.canCollectIncome) ...[
        SizedBox(height: 8),
        Text(
          l10n.propertyIncomeReady,
          style: TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ] else if (ownedProperty!.timeUntilNextCollection != null) ...[
        SizedBox(height: 8),
        Text(
          l10n.propertyNextIncome(
            _formatDuration(ownedProperty!.timeUntilNextCollection!, l10n),
          ),
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),
      ],
    ];
  }

  Widget _buildStatRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[600])),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  List<Widget> _buildAvailablePropertyActions(AppLocalizations l10n) {
    return [
      SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: onBuy,
          icon: Icon(Icons.shopping_cart),
          label: Text(l10n.propertyBuyAction),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
        ),
      ),
    ];
  }

  List<Widget> _buildOwnedPropertyActions(AppLocalizations l10n) {
    final upgradeCost = ownedProperty?.nextUpgradeCost;
    final canUpgrade = upgradeCost != null;

    return [
      Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: ownedProperty!.canCollectIncome
                  ? onCollectIncome
                  : null,
              icon: Icon(Icons.attach_money),
              label: Text(l10n.propertyCollectAction),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: ElevatedButton(
              onPressed: canUpgrade ? onUpgrade : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.upgrade, size: 16),
                      SizedBox(width: 4),
                      Text(l10n.propertyUpgradeAction),
                    ],
                  ),
                  if (canUpgrade)
                    Text(
                      '€${formatCompactNumber(upgradeCost)}',
                      style: TextStyle(fontSize: 11),
                    )
                  else
                    Text(l10n.propertyMax, style: TextStyle(fontSize: 11)),
                ],
              ),
            ),
          ),
        ],
      ),
      if (ownedProperty?.propertyId == 'nightclub') ...[
        SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: onManage,
            icon: Icon(Icons.nightlife),
            label: Text('Beheer Nightclub'),
          ),
        ),
      ],
    ];
  }

  Widget _buildLoadingState() {
    return SizedBox(
      height: 200,
      child: Center(child: CircularProgressIndicator()),
    );
  }

  String _formatDuration(Duration duration, AppLocalizations l10n) {
    if (duration.inHours > 0) {
      return l10n.durationHoursMinutes(
        duration.inHours.toString(),
        duration.inMinutes.remainder(60).toString(),
      );
    } else {
      return l10n.durationMinutes(duration.inMinutes.toString());
    }
  }

  String? _localizedPropertyName(String? propertyId, AppLocalizations l10n) {
    switch (propertyId) {
      case 'warehouse':
        return l10n.propertyWarehouseName;
      case 'nightclub':
        return l10n.propertyNightclubName;
      case 'house':
        return l10n.propertyHouseName;
      case 'apartment':
        return l10n.propertyApartmentName;
      case 'shop':
        return l10n.propertyShopName;
      default:
        return null;
    }
  }
}
