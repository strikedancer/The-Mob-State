import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../models/property.dart';
import '../providers/vehicle_provider.dart';
import '../services/showroom_service.dart';
import '../utils/collection_view_layout_prefs.dart';
import '../utils/formatters.dart';
import '../utils/top_right_notification.dart';
import '../utils/web_asset_helper.dart';
import '../widgets/collection_view_layout_toolbar.dart';
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
  static const _layoutStorageKey = 'showroom_collection_view_layout_v1';

  final ShowroomService _service = ShowroomService();
  late final TabController _tabController;
  Map<String, dynamic>? _showroom;
  bool _loading = true;
  String? _error;
  int? _busyInventoryId;
  CollectionViewLayout _viewLayout = CollectionViewLayout.grid4;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadViewLayoutPref();
    _load();
  }

  Future<void> _loadViewLayoutPref() async {
    final layout = await CollectionViewLayoutPrefs.load(_layoutStorageKey);
    if (!mounted) return;
    setState(() => _viewLayout = layout);
  }

  Future<void> _setViewLayout(CollectionViewLayout layout) async {
    setState(() => _viewLayout = layout);
    await CollectionViewLayoutPrefs.save(_layoutStorageKey, layout);
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

  Widget _buildViewLayoutToolbar(AppLocalizations l10n) {
    return CollectionViewLayoutToolbar(
      selected: _viewLayout,
      onChanged: _setViewLayout,
      label: l10n.prostitutionWorkersLayoutLabel,
      listTooltip: l10n.prostitutionWorkersLayoutList,
      grid4Tooltip: l10n.prostitutionWorkersLayoutGrid4,
      grid7Tooltip: l10n.prostitutionWorkersLayoutGrid7,
      accent: kEmpireGold,
    );
  }

  Widget _buildVehicleGrid(
    AppLocalizations l10n,
    List<Map<String, dynamic>> vehicles, {
    required String empty,
    required String actionLabel,
    required Future<void> Function(int inventoryId) onAction,
  }) {
    return RefreshIndicator(
      onRefresh: _load,
      child: LayoutBuilder(
        builder: (context, constraints) {
          const spacing = 12.0;
          const minGridCardWidth = 120.0;
          const listHorizontalPadding = 32.0;

          if (vehicles.isEmpty) {
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              children: [
                _buildViewLayoutToolbar(l10n),
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: Text(
                    empty,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
              ],
            );
          }

          final toolbar = _buildViewLayoutToolbar(l10n);

          if (_viewLayout == CollectionViewLayout.list) {
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              children: [
                toolbar,
                ...vehicles.map(
                  (vehicle) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _buildVehicleListRow(
                      l10n,
                      vehicle,
                      actionLabel: actionLabel,
                      onAction: onAction,
                    ),
                  ),
                ),
              ],
            );
          }

          final columns = _viewLayout.preferredColumns!;
          final contentWidth = (constraints.maxWidth - listHorizontalPadding)
              .clamp(0.0, double.infinity);
          var cardWidth =
              (contentWidth - (columns - 1) * spacing) / columns;
          var gridWidth = contentWidth;
          if (cardWidth < minGridCardWidth) {
            cardWidth = minGridCardWidth;
            gridWidth = columns * cardWidth + (columns - 1) * spacing;
          }

          Widget grid = _buildFixedColumnCards(
            vehicles: vehicles,
            columns: columns,
            cardWidth: cardWidth,
            spacing: spacing,
            l10n: l10n,
            actionLabel: actionLabel,
            onAction: onAction,
          );
          if (gridWidth > contentWidth + 0.5) {
            grid = SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(width: gridWidth, child: grid),
            );
          }

          return ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            children: [
              toolbar,
              grid,
            ],
          );
        },
      ),
    );
  }

  Widget _buildFixedColumnCards({
    required List<Map<String, dynamic>> vehicles,
    required int columns,
    required double cardWidth,
    required double spacing,
    required AppLocalizations l10n,
    required String actionLabel,
    required Future<void> Function(int inventoryId) onAction,
  }) {
    final rows = <Widget>[];
    for (var start = 0; start < vehicles.length; start += columns) {
      final rowItems = vehicles.skip(start).take(columns).toList();
      final cells = <Widget>[];
      for (var col = 0; col < columns; col++) {
        if (col > 0) cells.add(SizedBox(width: spacing));
        cells.add(
          SizedBox(
            width: cardWidth,
            child: col < rowItems.length
                ? _buildVehicleCard(
                    l10n,
                    rowItems[col],
                    actionLabel: actionLabel,
                    onAction: onAction,
                    compact: columns >= 7,
                  )
                : const SizedBox.shrink(),
          ),
        );
      }
      rows.add(Row(crossAxisAlignment: CrossAxisAlignment.start, children: cells));
      if (start + columns < vehicles.length) {
        rows.add(SizedBox(height: spacing));
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: rows,
    );
  }

  Widget _buildVehicleListRow(
    AppLocalizations l10n,
    Map<String, dynamic> vehicle, {
    required String actionLabel,
    required Future<void> Function(int inventoryId) onAction,
  }) {
    final inventoryId = (vehicle['inventoryId'] as num?)?.toInt();
    final name = vehicle['name']?.toString() ?? l10n.unknown;
    final condition = (vehicle['condition'] as num?)?.toInt() ?? 0;
    final image = vehicle['image']?.toString();
    final rarity = (vehicle['rarity']?.toString() ?? 'common').toLowerCase();
    final value = (vehicle['value'] as num?)?.toInt() ??
        (vehicle['baseValue'] as num?)?.toInt() ??
        0;
    final busy = inventoryId != null && _busyInventoryId == inventoryId;
    final canManage = _showroom?['canManage'] == true;
    final tone = rarityColor(rarity);

    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: kEmpireGold.withValues(alpha: 0.28)),
      ),
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 72,
              height: 72,
              child: _vehicleSquareImage(image),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  rarityLabel(l10n, rarity),
                  style: TextStyle(
                    color: tone,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${l10n.condition}: $condition% · ${formatCurrency(value)}',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          if (inventoryId != null)
            FilledButton(
              onPressed: busy || !canManage ? null : () => onAction(inventoryId),
              child: busy
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(actionLabel),
            ),
        ],
      ),
    );
  }

  Widget _buildVehicleCard(
    AppLocalizations l10n,
    Map<String, dynamic> vehicle, {
    required String actionLabel,
    required Future<void> Function(int inventoryId) onAction,
    bool compact = false,
  }) {
    final inventoryId = (vehicle['inventoryId'] as num?)?.toInt();
    final name = vehicle['name']?.toString() ?? l10n.unknown;
    final condition = (vehicle['condition'] as num?)?.toInt() ?? 0;
    final image = vehicle['image']?.toString();
    final rarity = (vehicle['rarity']?.toString() ?? 'common').toLowerCase();
    final value = (vehicle['value'] as num?)?.toInt() ??
        (vehicle['baseValue'] as num?)?.toInt() ??
        0;
    final busy = inventoryId != null && _busyInventoryId == inventoryId;
    final canManage = _showroom?['canManage'] == true;
    final tone = rarityColor(rarity);

    return Card(
      clipBehavior: Clip.antiAlias,
      color: Colors.black.withValues(alpha: 0.4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 1,
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
                      border: Border.all(color: tone.withValues(alpha: 0.7)),
                    ),
                    child: Text(
                      rarityLabel(l10n, rarity),
                      style: TextStyle(
                        color: tone,
                        fontWeight: FontWeight.w800,
                        fontSize: compact ? 10 : 11,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              compact ? 8 : 10,
              compact ? 6 : 8,
              compact ? 8 : 10,
              compact ? 8 : 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: compact ? 12 : 13,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${l10n.condition}: $condition%',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: compact ? 11 : 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  formatCurrency(value),
                  style: TextStyle(
                    color: kEmpireGold,
                    fontWeight: FontWeight.w700,
                    fontSize: compact ? 12 : 13,
                  ),
                ),
                SizedBox(height: compact ? 6 : 8),
                if (inventoryId != null)
                  FilledButton(
                    style: compact
                        ? FilledButton.styleFrom(
                            visualDensity: VisualDensity.compact,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                          )
                        : null,
                    onPressed: busy || !canManage
                        ? null
                        : () => onAction(inventoryId),
                    child: busy
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(
                            actionLabel,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                  ),
              ],
            ),
          ),
        ],
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
