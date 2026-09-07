import 'package:flutter/material.dart';
import '../models/property.dart';
import '../utils/formatters.dart';
import '../utils/web_asset_helper.dart';
import '../l10n/app_localizations.dart';
import 'responsive_modal.dart';

class PropertyCard extends StatelessWidget {
  final PropertyDefinition? definition;
  final Property? ownedProperty;
  final VoidCallback? onBuy;
  final VoidCallback? onUpgrade;
  final VoidCallback? onDevelop;
  final VoidCallback? onManage;
  final VoidCallback? onSell;
  final VoidCallback? onOpenStorage;
  final bool isLoading;
  final bool playerIsVip;
  final int vipBonusPerProperty;
  final String? buyLockedReason;
  final String? upgradeLockedReason;
  final bool expandToFill;

  const PropertyCard({
    super.key,
    this.definition,
    this.ownedProperty,
    this.onBuy,
    this.onUpgrade,
    this.onDevelop,
    this.onManage,
    this.onSell,
    this.onOpenStorage,
    this.isLoading = false,
    this.playerIsVip = false,
    this.vipBonusPerProperty = 5,
    this.buyLockedReason,
    this.upgradeLockedReason,
    this.expandToFill = false,
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
    final imagePath = _resolvedImagePath(propertyId);

    final imageHeight = expandToFill ? 140.0 : 150.0;
    final infoBody = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                name ?? l10n.unknown,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            IconButton(
              tooltip: l10n.propertyInfoTooltip,
              icon: const Icon(Icons.info_outline),
              visualDensity: VisualDensity.compact,
              onPressed: () => _showPropertyInfo(
                context,
                l10n,
                propertyId,
                name ?? l10n.unknown,
              ),
            ),
            if (isOwned)
              Chip(
                label: Text(
                  l10n.propertyLevel(ownedProperty!.level.toString()),
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
        const SizedBox(height: 4),
        Text(
          _getPropertyTypeLabel(propertyId, l10n),
          style: TextStyle(color: Colors.grey[600]),
        ),
        const SizedBox(height: 12),
        if (isOwned)
          ..._buildOwnedPropertyStats(l10n)
        else
          ..._buildAvailablePropertyStats(l10n),
        const SizedBox(height: 16),
        if (isOwned)
          ..._buildOwnedPropertyActions(l10n)
        else
          ..._buildAvailablePropertyActions(l10n),
      ],
    );

    return Card(
      elevation: 4,
      clipBehavior: Clip.antiAlias,
      margin: expandToFill
          ? EdgeInsets.zero
          : const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: isLoading
          ? _buildLoadingState()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (imagePath != null)
                  Container(
                    height: imageHeight,
                    width: double.infinity,
                    color: Colors.grey[300],
                    child: Stack(
                      children: [
                        _buildPropertyImage(imagePath),
                        if (isOwned && ownedProperty!.overlayKeys != null)
                          ..._buildOverlays(ownedProperty!.overlayKeys!),
                      ],
                    ),
                  )
                else
                  Container(
                    height: imageHeight,
                    width: double.infinity,
                    color: Colors.grey[300],
                    child: Icon(
                      _getPropertyIcon(propertyId),
                      size: 64,
                      color: Colors.grey[600],
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: infoBody,
                ),
              ],
            ),
    );
  }

  String? _resolvedImagePath(String? propertyId) {
    final ownedPath = ownedProperty?.imagePath;
    if (ownedPath != null && ownedPath.isNotEmpty) return ownedPath;
    final definitionPath = definition?.imagePath;
    if (definitionPath != null && definitionPath.isNotEmpty) {
      return definitionPath;
    }
    switch (propertyId) {
      case 'house':
      case 'apartment':
      case 'warehouse':
      case 'nightclub':
      case 'casino':
        return '$propertyId.png';
      default:
        return null;
    }
  }

  Widget _buildPropertyImage(String path) {
    // Construct full path with properties folder
    final fullPath = path.startsWith('assets/images/')
        ? path
        : 'assets/images/properties/$path';

    return WebAssetHelper.image(
      fullPath,
      fit: BoxFit.cover,
      width: double.infinity,
      height: expandToFill ? 140 : 150,
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
    return overlayKeys.where((key) => key != 'income_ready').map((key) {
      final overlayPath = 'assets/images/overlays/$key.png';

      // Position overlays based on type
      Alignment alignment;
      if (key.startsWith('upgraded_lvl')) {
        alignment = Alignment.topRight;
      } else if (key == 'new') {
        alignment = Alignment.topLeft;
      } else {
        alignment = Alignment.center;
      }

      return Positioned.fill(
        child: Align(
          alignment: alignment,
          child: Padding(
            padding: EdgeInsets.all(8),
            child: WebAssetHelper.image(
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
      case 'casino':
        return Icons.casino;
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
        return '🏢 ${l10n.propertyTypeApartment}';
      case 'warehouse':
        return '🏪 ${l10n.propertyTypeWarehouse}';
      case 'nightclub':
        return '🎵 ${l10n.propertyTypeNightclub}';
      case 'casino':
        return '🎰 ${l10n.propertyTypeCasino}';
      case 'shop':
        return '🛒 ${l10n.propertyTypeShop}';
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
      if (definition!.storageCapacity.isNotEmpty &&
          definition!.storageCapacity[0] > 0) ...[
        SizedBox(height: 8),
        _buildStatRow(
          l10n.propertyStatStorageLabel,
          l10n.propertyStatStorageSlotsRange(
            definition!.storageCapacity[0],
            definition!.storageCapacity.last,
          ),
        ),
      ],
      if ((definition!.id == 'house' || definition!.id == 'apartment') &&
          definition!.storageCapacity.isNotEmpty) ...[
        SizedBox(height: 8),
        _buildStatRow(
          l10n.propertyStatHousingCapacityLabel,
          l10n.propertyStatHousingWorkersRange(
            (definition!.storageCapacity.first / 5).floor().clamp(1, 999),
            (definition!.storageCapacity.last / 5).floor().clamp(1, 999),
          ),
        ),
      ],
      SizedBox(height: 8),
      _buildStatRow(l10n.propertyMaxLevel, '${definition!.maxLevel}'),
      if (definition!.unique) ...[
        SizedBox(height: 8),
        Text(
          definition!.countryAvailable
              ? l10n.propertyUniquePerCountry
              : l10n.propertyUniqueTaken,
          style: TextStyle(
            color: Colors.orange,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ],
      if (definition!.maxOwners != null && definition!.maxOwners! > 0) ...[
        SizedBox(height: 8),
        _buildStatRow(
          l10n.propertySlotsLabel,
          definition!.slotsAvailable != null
              ? l10n.propertySlotsInCountry(
                  definition!.slotsAvailable!,
                  definition!.maxOwners!,
                )
              : '${definition!.maxOwners}',
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
        l10n.level,
        '${ownedProperty!.level} / ${definition?.maxLevel ?? ownedProperty!.level}',
      ),
      SizedBox(height: 8),
      _buildStatRow(
        l10n.propertyDevelopLevel,
        '${ownedProperty!.developmentLevel} / ${ownedProperty!.developMaxLevel}',
      ),
      if (ownedProperty!.developIncomeBonusPercentPerLevel > 0) ...[
        SizedBox(height: 8),
        _buildStatRow(
          l10n.propertyDevelopIncomeBonusLabel,
          l10n.propertyDevelopIncomeBonus(
            ownedProperty!.developmentLevel *
                ownedProperty!.developIncomeBonusPercentPerLevel,
          ),
        ),
      ],
      if (ownedProperty!.baseIncome != null) ...[
        SizedBox(height: 8),
        _buildStatRow(
          l10n.propertyDevelopIncomeLabel,
          formatCurrency(ownedProperty!.baseIncome!),
        ),
      ],
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
                l10n.propertyVipExtraSlots(vipBonusPerProperty),
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
        _buildStatRow(
          l10n.propertyStatStorageLabel,
          l10n.propertyStatStorageAmountSlots(currentStorage),
        ),
      ],
      if (effectiveCapacity > 0) ...[
        SizedBox(height: 8),
        _buildStatRow(
          l10n.propertyStatHousingCapacityLabel,
          effectiveCapacity < effectiveMax
              ? l10n.propertyHousingCapacityWithMax(
                  effectiveCapacity,
                  effectiveMax,
                  definition!.maxLevel,
                )
              : l10n.propertyHousingCapacityMaxReached(effectiveCapacity),
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
    final locked = buyLockedReason != null;
    final priceLabel = definition != null
        ? l10n.propertyBuyActionCost(formatCurrency(definition!.basePrice))
        : l10n.propertyBuyAction;
    return [
      SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: locked ? null : onBuy,
          icon: const Icon(Icons.shopping_cart),
          label: Text(priceLabel),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
        ),
      ),
      if (locked) ...[
        const SizedBox(height: 6),
        Text(
          buyLockedReason!,
          style: TextStyle(
            color: Colors.orange[800],
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ];
  }

  String? _upgradeBenefitSummary(AppLocalizations l10n) {
    final owned = ownedProperty;
    if (owned == null) return null;
    final fromSlots = owned.nextUpgradeStorageFrom;
    final toSlots = owned.nextUpgradeStorageTo;
    if (fromSlots != null && toSlots != null && toSlots > fromSlots) {
      return l10n.propertyUpgradeNextStorage(fromSlots, toSlots);
    }
    final incomeBonus = owned.nextUpgradeIncomeBonus ?? 0;
    if (incomeBonus > 0) {
      return l10n.propertyUpgradeNextIncome(formatCurrency(incomeBonus));
    }
    return null;
  }

  List<Widget> _buildOwnedPropertyActions(AppLocalizations l10n) {
    final upgradeCost = ownedProperty?.nextUpgradeCost;
    final canUpgrade = upgradeCost != null;
    final upgradeLocked = upgradeLockedReason != null;
    final benefit = _upgradeBenefitSummary(l10n);

    return [
      if (onOpenStorage != null) ...[
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: onOpenStorage,
            icon: const Icon(Icons.inventory_2_outlined),
            label: Text(l10n.inventoryOpenStorage),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
      if (onManage != null) ...[
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: onManage,
            icon: const Icon(Icons.nightlife),
            label: Text(l10n.propertyManageNightclub),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple[700],
              foregroundColor: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
      SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: canUpgrade && !upgradeLocked ? onUpgrade : null,
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
                  benefit == null
                      ? formatCurrency(upgradeCost)
                      : '${formatCurrency(upgradeCost)} · $benefit',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 11),
                )
              else
                Text(l10n.propertyMax, style: TextStyle(fontSize: 11)),
            ],
          ),
        ),
      ),
      if (upgradeLocked) ...[
        const SizedBox(height: 6),
        Text(
          upgradeLockedReason!,
          style: TextStyle(
            color: Colors.orange[800],
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
      if (ownedProperty?.canDevelop == true &&
          ownedProperty?.nextDevelopCost != null) ...[
        SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: ownedProperty!.canDevelopNow ? onDevelop : null,
            icon: const Icon(Icons.construction),
            label: Text(
              ownedProperty!.developCooldownRemainingSeconds > 0
                  ? l10n.propertyDevelopCooldown(
                      formatDuration(
                        Duration(
                          seconds:
                              ownedProperty!.developCooldownRemainingSeconds,
                        ),
                      ),
                    )
                  : l10n.propertyDevelopActionCost(
                      formatCompactNumber(ownedProperty!.nextDevelopCost!),
                      ownedProperty!.developmentLevel + 1,
                    ),
            ),
          ),
        ),
      ],
      if (onSell != null && ownedProperty?.sellPrice != null) ...[
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: TextButton.icon(
            onPressed: onSell,
            icon: const Icon(Icons.attach_money, size: 18),
            label: Text(
              l10n.propertySellActionPrice(
                formatCurrency(ownedProperty!.sellPrice!),
              ),
            ),
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
      case 'casino':
        return l10n.propertyCasinoName;
      case 'shop':
        return l10n.propertyShopName;
      default:
        return null;
    }
  }

  String? _propertyRole(String? propertyId, AppLocalizations l10n) {
    switch (propertyId) {
      case 'house':
        return l10n.propertyRoleHouse;
      case 'apartment':
        return l10n.propertyRoleApartment;
      case 'warehouse':
        return l10n.propertyRoleWarehouse;
      case 'nightclub':
        return l10n.propertyRoleNightclub;
      case 'casino':
        return l10n.propertyRoleCasino;
      default:
        return null;
    }
  }

  String _propertyInfoBody(String? propertyId, AppLocalizations l10n) {
    switch (propertyId) {
      case 'house':
        return l10n.propertyInfoHouse;
      case 'apartment':
        return l10n.propertyInfoApartment;
      case 'warehouse':
        return l10n.propertyInfoWarehouse;
      case 'nightclub':
        return l10n.propertyInfoNightclub;
      case 'casino':
        return l10n.propertyInfoCasino;
      default:
        return _propertyRole(propertyId, l10n) ??
            (definition?.description ?? l10n.propertyInfoGeneric);
    }
  }

  void _showPropertyInfo(
    BuildContext context,
    AppLocalizations l10n,
    String? propertyId,
    String name,
  ) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        final dialogL10n = AppLocalizations.of(dialogContext)!;
        return AlertDialog(
          title: Text(name),
          content: ResponsiveDialogContent(
            phoneMaxWidth: 340,
            tabletMaxWidth: 420,
            desktopMaxWidth: 480,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_propertyInfoBody(propertyId, dialogL10n)),
                const SizedBox(height: 16),
                if (ownedProperty != null)
                  ..._buildOwnedPropertyStats(dialogL10n)
                else
                  ..._buildAvailablePropertyStats(dialogL10n),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(dialogL10n.close),
            ),
          ],
        );
      },
    );
  }
}
