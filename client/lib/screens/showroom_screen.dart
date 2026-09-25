import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../models/property.dart';
import '../providers/vehicle_provider.dart';
import '../services/showroom_service.dart';
import '../utils/formatters.dart';
import '../utils/top_right_notification.dart';
import '../utils/web_asset_helper.dart';
import '../widgets/empire_page_hero.dart';
import '../widgets/game_page_info.dart';
import '../widgets/jail_gate.dart';
import '../widgets/vehicle_catalog_dialog.dart';

class ShowroomScreen extends StatefulWidget {
  final Property property;
  final bool embedded;
  final VoidCallback? onClose;

  const ShowroomScreen({
    super.key,
    required this.property,
    this.embedded = false,
    this.onClose,
  });

  @override
  State<ShowroomScreen> createState() => _ShowroomScreenState();
}

class _ShowroomScreenState extends State<ShowroomScreen>
    with SingleTickerProviderStateMixin {
  final ShowroomService _service = ShowroomService();
  late final TabController _tabController;
  Map<String, dynamic>? _showroom;
  bool _loading = true;
  String? _error;
  int? _busyInventoryId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _load();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String get _propertyType => widget.property.type ?? widget.property.propertyId;

  String get _heroAsset {
    switch (_propertyType) {
      case 'motorcycle_showroom':
        return 'assets/images/properties/motorcycle_showroom.png';
      case 'boat_harbor':
        return 'assets/images/properties/boat_harbor.png';
      default:
        return 'assets/images/properties/car_showroom.png';
    }
  }

  IconData get _fallbackIcon {
    switch (_propertyType) {
      case 'motorcycle_showroom':
        return Icons.two_wheeler;
      case 'boat_harbor':
        return Icons.directions_boat;
      default:
        return Icons.directions_car;
    }
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final result = await _service.getShowroom(widget.property.id);
    if (!mounted) return;
    if (result['event'] == 'showroom.loaded' && result['showroom'] is Map) {
      setState(() {
        _showroom = Map<String, dynamic>.from(result['showroom'] as Map);
        _loading = false;
      });
      return;
    }
    setState(() {
      _loading = false;
      _error = _errorMessage(
        AppLocalizations.of(context)!,
        result['params'] is Map
            ? (result['params'] as Map)['reason']?.toString()
            : null,
      );
    });
  }

  String _errorMessage(AppLocalizations l10n, String? reason) {
    switch (reason) {
      case 'WRONG_COUNTRY':
      case 'SHOWROOM_WRONG_COUNTRY':
        return l10n.showroomNeedSameCountry;
      case 'SHOWROOM_CONDITION':
        return l10n.showroomNeedPerfectCondition;
      case 'SHOWROOM_GARAGE_FULL':
        return l10n.showroomNeedGarageSpace;
      case 'SHOWROOM_DUPLICATE_MODEL':
        return l10n.showroomDuplicateModel;
      case 'SHOWROOM_FULL':
        return l10n.showroomFull;
      case 'SHOWROOM_WRONG_TYPE':
        return l10n.showroomWrongType;
      case 'SHOWROOM_VEHICLE_BUSY':
      case 'VEHICLE_IN_SHOWROOM':
        return l10n.showroomVehicleBusy;
      default:
        return l10n.showroomLoadError;
    }
  }

  Future<void> _refreshVehicleStorage() async {
    final country = _showroom?['countryId']?.toString() ??
        widget.property.countryId;
    if (country.isEmpty) return;
    final provider = context.read<VehicleProvider>();
    final category = _showroom?['category']?.toString() ??
        (_propertyType == 'boat_harbor'
            ? 'boat'
            : _propertyType == 'motorcycle_showroom'
                ? 'motorcycle'
                : 'car');
    await provider.fetchInventory();
    if (category == 'boat') {
      await provider.fetchMarinaStatus(country);
    } else {
      await provider.fetchGarageStatus(
        country,
        vehicleType: category == 'motorcycle' ? 'motorcycle' : 'car',
      );
    }
  }

  Future<void> _place(int inventoryId) async {
    setState(() => _busyInventoryId = inventoryId);
    final result = await _service.placeVehicle(
      propertyId: widget.property.id,
      vehicleInventoryId: inventoryId,
    );
    if (!mounted) return;
    setState(() => _busyInventoryId = null);
    if (result['event'] == 'showroom.placed' && result['showroom'] is Map) {
      setState(() {
        _showroom = Map<String, dynamic>.from(result['showroom'] as Map);
      });
      await _refreshVehicleStorage();
      if (!mounted) return;
      showTopRightFromSnackBar(
        context,
        SnackBar(content: Text(AppLocalizations.of(context)!.showroomPlaced)),
      );
      return;
    }
    showTopRightFromSnackBar(
      context,
      SnackBar(
        content: Text(
          _errorMessage(
            AppLocalizations.of(context)!,
            result['params'] is Map
                ? (result['params'] as Map)['reason']?.toString()
                : null,
          ),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> _remove(int inventoryId) async {
    setState(() => _busyInventoryId = inventoryId);
    final result = await _service.removeVehicle(
      propertyId: widget.property.id,
      vehicleInventoryId: inventoryId,
    );
    if (!mounted) return;
    setState(() => _busyInventoryId = null);
    if (result['event'] == 'showroom.removed' && result['showroom'] is Map) {
      setState(() {
        _showroom = Map<String, dynamic>.from(result['showroom'] as Map);
      });
      await _refreshVehicleStorage();
      if (!mounted) return;
      showTopRightFromSnackBar(
        context,
        SnackBar(content: Text(AppLocalizations.of(context)!.showroomRemoved)),
      );
      return;
    }
    showTopRightFromSnackBar(
      context,
      SnackBar(
        content: Text(
          _errorMessage(
            AppLocalizations.of(context)!,
            result['params'] is Map
                ? (result['params'] as Map)['reason']?.toString()
                : null,
          ),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _handleBack() {
    if (widget.onClose != null) {
      widget.onClose!();
      return;
    }
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return JailGate(
      embedded: widget.embedded,
      child: GamePageInfoHost(
        topicId: 'properties',
        showOverlay: false,
        child: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final used = '${_showroom?['slotsUsed'] ?? 0}';
    final max = '${_showroom?['slotsMax'] ?? 0}';
    final catalog = '${_showroom?['catalogSize'] ?? 0}';
    final heroSubtitle =
        '${l10n.showroomSlots(used, max)} · ${l10n.showroomCatalogProgress(used, catalog)}';
    final tabBar = TabBar(
      controller: _tabController,
      isScrollable: true,
      labelColor: kEmpireGold,
      unselectedLabelColor: Colors.white70,
      indicatorColor: kEmpireGold,
      dividerColor: kEmpireGold.withValues(alpha: 0.22),
      tabs: [
        Tab(text: l10n.showroomCollectionTab),
        Tab(text: l10n.showroomPlaceTab),
      ],
    );

    late final Widget hub;
    if (_loading) {
      hub = Column(
        children: [
          _buildTopBar(l10n, heroSubtitle),
          const Expanded(child: Center(child: CircularProgressIndicator())),
        ],
      );
    } else if (_error != null) {
      hub = Column(
        children: [
          _buildTopBar(l10n, heroSubtitle),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _error!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: _load,
                      child: Text(l10n.showroomRefresh),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      hub = NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverToBoxAdapter(child: _buildTopBar(l10n, heroSubtitle)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: _buildStatsCard(l10n),
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: PinnedTabBarDelegate(tabBar: tabBar),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildVehicleGrid(
              l10n,
              List<Map<String, dynamic>>.from(
                (_showroom?['exhibits'] as List?)?.whereType<Map>() ??
                    const [],
              ),
              empty: l10n.showroomEmptyCollection,
              actionLabel: l10n.showroomRemoveAction,
              onAction: _remove,
            ),
            _buildVehicleGrid(
              l10n,
              List<Map<String, dynamic>>.from(
                (_showroom?['eligible'] as List?)?.whereType<Map>() ??
                    const [],
              ),
              empty: (_showroom?['canManage'] == true)
                  ? l10n.showroomEmptyEligible
                  : l10n.showroomWrongCountryManage,
              actionLabel: l10n.showroomPlaceAction,
              onAction: _place,
            ),
          ],
        ),
      );
    }

    final painted = empireHubPainted(child: hub);
    if (widget.embedded) return painted;
    return Scaffold(
      backgroundColor: kEmpireBgEnd,
      body: painted,
    );
  }

  Widget _buildTopBar(AppLocalizations l10n, String subtitle) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 12, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            tooltip: MaterialLocalizations.of(context).backButtonTooltip,
            onPressed: _handleBack,
            icon: const Icon(Icons.arrow_back, color: kEmpireGold),
          ),
          Expanded(
            child: EmpirePageHero(
              title: l10n.showroomTitle,
              subtitle: subtitle,
              imageAsset: _heroAsset,
              topicId: 'properties',
              onRefresh: _load,
              fallbackIcon: _fallbackIcon,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard(AppLocalizations l10n) {
    final country =
        _showroom?['countryId']?.toString() ?? widget.property.countryId;
    final totalValue = (_showroom?['totalValue'] as num?)?.toInt() ?? 0;
    final rarityRaw = _showroom?['rarityCounts'];
    final rarityCounts = <String, int>{};
    if (rarityRaw is Map) {
      for (final entry in rarityRaw.entries) {
        rarityCounts[entry.key.toString()] = (entry.value as num?)?.toInt() ?? 0;
      }
    }
    const rarityOrder = ['common', 'uncommon', 'rare', 'epic', 'legendary'];

    return Card(
      color: Colors.black.withValues(alpha: 0.35),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (country.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  country,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            Text(
              l10n.showroomTotalValue(formatCurrency(totalValue)),
              style: const TextStyle(
                color: kEmpireGold,
                fontWeight: FontWeight.w800,
                fontSize: 16,
              ),
            ),
            if (rarityCounts.isNotEmpty) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final rarity in rarityOrder)
                    if ((rarityCounts[rarity] ?? 0) > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: rarityColor(rarity).withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: rarityColor(rarity).withValues(alpha: 0.55),
                          ),
                        ),
                        child: Text(
                          '${rarityLabel(l10n, rarity)} × ${rarityCounts[rarity]}',
                          style: TextStyle(
                            color: rarityColor(rarity),
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                      ),
                ],
              ),
            ],
            const SizedBox(height: 10),
            Text(
              l10n.showroomRules,
              style: const TextStyle(color: Colors.white70, height: 1.35),
            ),
          ],
        ),
      ),
    );
  }

  int _gridColumns(double width) {
    if (width >= 1280) return 4;
    if (width >= 900) return 3;
    if (width >= 560) return 2;
    return 1;
  }

  Widget _buildVehicleGrid(
    AppLocalizations l10n,
    List<Map<String, dynamic>> vehicles, {
    required String empty,
    required String actionLabel,
    required Future<void> Function(int inventoryId) onAction,
  }) {
    if (vehicles.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            empty,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _load,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final columns = _gridColumns(constraints.maxWidth);
          return GridView.builder(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              // Taller cards: image + rarity + value + action.
              childAspectRatio: columns == 1 ? 0.86 : 0.68,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: vehicles.length,
            itemBuilder: (context, index) {
              final vehicle = vehicles[index];
              final inventoryId = (vehicle['inventoryId'] as num?)?.toInt();
              final name = vehicle['name']?.toString() ?? l10n.unknown;
              final condition = (vehicle['condition'] as num?)?.toInt() ?? 0;
              final image = vehicle['image']?.toString();
              final rarity =
                  (vehicle['rarity']?.toString() ?? 'common').toLowerCase();
              final value = (vehicle['value'] as num?)?.toInt() ??
                  (vehicle['baseValue'] as num?)?.toInt() ??
                  0;
              final busy =
                  inventoryId != null && _busyInventoryId == inventoryId;
              final canManage = _showroom?['canManage'] == true;
              final tone = rarityColor(rarity);

              return Card(
                clipBehavior: Clip.antiAlias,
                color: Colors.black.withValues(alpha: 0.4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          _vehicleSquareImage(image),
                          Positioned(
                            top: 8,
                            left: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.72),
                                borderRadius: BorderRadius.circular(999),
                                border: Border.all(
                                  color: tone.withValues(alpha: 0.7),
                                ),
                              ),
                              child: Text(
                                rarityLabel(l10n, rarity),
                                style: TextStyle(
                                  color: tone,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${l10n.condition}: $condition%',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            formatCurrency(value),
                            style: const TextStyle(
                              color: kEmpireGold,
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (inventoryId != null)
                            FilledButton(
                              onPressed: busy || !canManage
                                  ? null
                                  : () => onAction(inventoryId),
                              child: busy
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Text(actionLabel),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _vehicleSquareImage(String? image) {
    if (image == null || image.isEmpty) {
      return ColoredBox(
        color: Colors.black45,
        child: Center(
          child: Icon(_fallbackIcon, size: 48, color: Colors.white38),
        ),
      );
    }
    return ColoredBox(
      color: Colors.black45,
      child: WebAssetHelper.image(
        'assets/images/vehicles/$image',
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (_, _, _) => Center(
          child: Icon(_fallbackIcon, size: 48, color: Colors.white38),
        ),
      ),
    );
  }
}
