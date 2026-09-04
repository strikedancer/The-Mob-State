import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/vehicle_provider.dart';
import '../providers/auth_provider.dart';
import '../models/vehicle.dart';
import '../models/drug_models.dart';
import '../l10n/app_localizations.dart';
import 'backpack_shop_screen.dart';
import 'materials_shop_screen.dart';
import 'weapons_market_screen.dart';
import 'ammo_market_screen.dart';
import 'trade_goods_tab.dart';
import 'tools_screen.dart';
import 'security_screen.dart';
import '../utils/top_right_notification.dart';
import '../utils/web_asset_helper.dart';
import '../widgets/responsive_modal.dart';
import '../widgets/market_compact.dart';
import '../models/player_tool_market_listing.dart';
import '../models/carried_tool.dart';
import '../services/inventory_service.dart';
import '../services/drug_service.dart';
import '../services/crypto_service.dart';
import '../services/api_client.dart';
class BlackMarketScreen extends StatefulWidget {
  static const int tabTrade = 0;
  static const int tabMarketplace = 1;
  static const int tabMyListings = 2;
  static const int tabBackpacks = 3;
  static const int tabMaterials = 4;
  static const int tabWeapons = 5;
  static const int tabAmmo = 6;
  static const int tabTools = 7;
  static const int tabSecurity = 8;
  static const int tabCount = 9;

  final int initialTabIndex;

  const BlackMarketScreen({super.key, this.initialTabIndex = 0});

  @override
  State<BlackMarketScreen> createState() => _BlackMarketScreenState();
}

class _BlackMarketScreenState extends State<BlackMarketScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? _filterCountry;
  String? _filterVehicleType;
  double _minPrice = 0;
  double _maxPrice = 1000000;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: BlackMarketScreen.tabCount,
      vsync: this,
      initialIndex: widget.initialTabIndex.clamp(0, BlackMarketScreen.tabCount - 1),
    );
    _tabController.addListener(() {
      if (mounted && !_tabController.indexIsChanging) setState(() {});
    });
    _loadData();
  }

  @override
  void didUpdateWidget(covariant BlackMarketScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialTabIndex == widget.initialTabIndex) {
      return;
    }
    final next = widget.initialTabIndex.clamp(0, BlackMarketScreen.tabCount - 1);
    if (_tabController.index != next) {
      _tabController.animateTo(next);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final vehicleProvider = Provider.of<VehicleProvider>(
      context,
      listen: false,
    );
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final currentCountry = authProvider.currentPlayer?.currentCountry;

    await vehicleProvider.fetchMarketListings(country: currentCountry);
    await vehicleProvider.fetchMyToolMarketListings();
  }

  List<MarketListing> _getFilteredListings(List<MarketListing> listings) {
    return listings.where((listing) {
      // Filter by country
      if (_filterCountry != null &&
          listing.vehicle.currentLocation != _filterCountry) {
        return false;
      }

      // Filter by vehicle type
      if (_filterVehicleType != null &&
          listing.vehicle.vehicleType != _filterVehicleType) {
        return false;
      }

      // Filter by price
      final price = listing.vehicle.askingPrice ?? 0;
      if (price < _minPrice || price > _maxPrice) {
        return false;
      }

      return true;
    }).toList();
  }

  List<PlayerToolMarketListing> _getFilteredToolListings(
    List<PlayerToolMarketListing> listings,
  ) {
    return listings.where((listing) {
      if (_filterCountry != null &&
          listing.countryCode != _filterCountry) {
        return false;
      }
      final price = listing.price.toDouble();
      if (price < _minPrice || price > _maxPrice) {
        return false;
      }
      return true;
    }).toList();
  }

  static const Color _shopGold = Color(0xFFFFB347);
  static const Color _shopPanel = Color(0xFF1B1212);
  static const Color _shopChip = Color(0xFF241616);
  static const Color _shopChipSelected = Color(0xFF3A2A14);
  static const Color _shopChipBorder = Color(0xFF4A3030);

  void _selectDepartment(int index) {
    if (_tabController.index == index) {
      return;
    }
    _tabController.animateTo(index);
  }

  Widget _departmentChip({
    required IconData icon,
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: selected ? _shopChipSelected : _shopChip,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? _shopGold : _shopChipBorder,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 14,
                color: selected ? _shopGold : Colors.white70,
              ),
              const SizedBox(width: 5),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  color: selected ? _shopGold : Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _departmentGroup({
    required String title,
    required List<(int index, IconData icon, String label)> items,
  }) {
    final selected = _tabController.index;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontSize: 11,
              letterSpacing: 0.8,
              fontWeight: FontWeight.w700,
              color: _shopGold,
            ),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final item in items)
                _departmentChip(
                  icon: item.$2,
                  label: item.$3,
                  selected: selected == item.$1,
                  onTap: () => _selectDepartment(item.$1),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _departmentBar(AppLocalizations l10n) {
    return Container(
      width: double.infinity,
      color: _shopPanel,
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.blackMarketSubtitle,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFFD8C4B0),
            ),
          ),
          const SizedBox(height: 10),
          _departmentGroup(
            title: l10n.blackMarketShops,
            items: [
              (BlackMarketScreen.tabTrade, Icons.shopping_bag, l10n.tradeGoods),
              (BlackMarketScreen.tabWeapons, Icons.gavel, l10n.weaponsMarket),
              (BlackMarketScreen.tabAmmo, Icons.bolt, l10n.ammoMarket),
              (BlackMarketScreen.tabTools, Icons.build, l10n.tools),
              (BlackMarketScreen.tabSecurity, Icons.shield, l10n.security),
              (BlackMarketScreen.tabMaterials, Icons.science, l10n.materials),
              (BlackMarketScreen.tabBackpacks, Icons.backpack, l10n.backpacks),
            ],
          ),
          _departmentGroup(
            title: l10n.blackMarketPlayerMarket,
            items: [
              (
                BlackMarketScreen.tabMarketplace,
                Icons.storefront,
                l10n.marketplace,
              ),
              (
                BlackMarketScreen.tabMyListings,
                Icons.receipt_long,
                l10n.myListings,
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vehicleProvider = Provider.of<VehicleProvider>(context);
    final l10n = AppLocalizations.of(context)!;
    final showMarketFilter =
        _tabController.index == BlackMarketScreen.tabMarketplace ||
        _tabController.index == BlackMarketScreen.tabMyListings;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.blackMarket),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadData),
          if (showMarketFilter)
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: _showFilterDialog,
            ),
        ],
      ),
      body: Column(
        children: [
          _departmentBar(l10n),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                const TradeGoodsTab(),
                _buildMarketListings(vehicleProvider),
                _buildMyListings(vehicleProvider),
                const BackpackShopScreen(),
                const MaterialsShopScreen(),
                const WeaponsMarketScreen(),
                const AmmoMarketScreen(),
                const ToolsScreen(embedded: true),
                const SecurityScreen(embedded: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMarketListings(VehicleProvider provider) {
    final l10n = AppLocalizations.of(context)!;

    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(l10n.hitError(provider.error!)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadData,
              child: Text(l10n.retryAgain),
            ),
          ],
        ),
      );
    }

    final filteredVehicles =
        _getFilteredListings(provider.marketListings);
    final filteredTools =
        _getFilteredToolListings(provider.toolMarketListings);

    if (filteredVehicles.isEmpty && filteredTools.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.storefront, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              l10n.bmHubNoMarketListingsTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.bmHubNoMarketListingsBody,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.bmHubAdjustFiltersHint,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      );
    }

    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: _loadData,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 88),
            children: [
              ...filteredVehicles.map(_buildMarketListingCard),
              ...filteredTools.map(_buildToolMarketListingCard),
            ],
          ),
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton.extended(
            onPressed: () => _showSellItemKindPicker(provider),
            icon: const Icon(Icons.sell_outlined),
            label: Text(l10n.bmHubSellCarriedItem),
          ),
        ),
      ],
    );
  }

  Widget _buildMyListings(VehicleProvider provider) {
    final l10n = AppLocalizations.of(context)!;
    final myVehicles = provider.inventory
        .where((vehicle) => vehicle.marketListing)
        .toList();
    final myTools = provider.myToolMarketListings;

    if (myVehicles.isEmpty && myTools.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.list_alt, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              l10n.noListings,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.bmHubEmptyMyListingsHint,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView(
        padding: marketListPadding,
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          ...myVehicles.map(_buildMyListingCard),
          ...myTools.map(_buildMyToolMarketListingCard),
        ],
      ),
    );
  }

  Widget _vehicleListingThumb(VehicleInventoryItem vehicle) {
    final selectedImage = vehicle.conditionImage;
    final icon = vehicle.vehicleType == 'car'
        ? Icons.directions_car
        : Icons.directions_boat;
    return marketThumbBox(
      width: 56,
      height: 40,
      color: Colors.grey[800],
      child: selectedImage != null
          ? WebAssetHelper.image(
              'assets/images/vehicles/$selectedImage',
              fit: BoxFit.cover,
              width: 56,
              height: 40,
              errorBuilder: (context, error, stackTrace) {
                return Icon(icon, size: 22, color: Colors.grey[600]);
              },
            )
          : Icon(icon, size: 22, color: Colors.grey[600]),
    );
  }

  Widget _buildMarketListingCard(MarketListing listing) {
    final l10n = AppLocalizations.of(context)!;
    final vehicle = listing.vehicle;
    final askingPrice = vehicle.askingPrice ?? 0;
    final marketValue = vehicle.getMarketValue();
    final priceDifference = ((askingPrice - marketValue) / marketValue * 100);
    final conditionColor = vehicle.getConditionColor() == 'green'
        ? Colors.teal.shade700
        : vehicle.getConditionColor() == 'orange'
        ? Colors.orange.shade800
        : Colors.red.shade700;

    return MarketCompactRow(
      leading: _vehicleListingThumb(vehicle),
      info: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            vehicle.definition?.name ?? l10n.unknown,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 4,
            runSpacing: 3,
            children: [
              MarketInfoPill(
                label: listing.sellerUsername,
                color: Colors.blueGrey.shade700,
                icon: Icons.person,
              ),
              MarketInfoPill(
                label: vehicle.currentLocation?.toUpperCase() ??
                    l10n.bmHubLocationUnknown,
                color: Colors.blueGrey.shade700,
                icon: Icons.location_on,
              ),
              MarketInfoPill(
                label: '${vehicle.condition}%',
                color: conditionColor,
                icon: Icons.build,
              ),
              if (priceDifference.abs() > 5)
                MarketInfoPill(
                  label:
                      '${priceDifference > 0 ? '+' : ''}${priceDifference.toStringAsFixed(0)}%',
                  color: priceDifference > 0
                      ? Colors.red.shade700
                      : Colors.green.shade700,
                ),
            ],
          ),
        ],
      ),
      meta: Text(
        '€${askingPrice.toStringAsFixed(0)}',
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Colors.green,
        ),
      ),
      action: FilledButton(
        onPressed: () => _buyVehicle(listing),
        style: marketBuyButtonStyle(),
        child: Text(l10n.bmHubBuyNow),
      ),
    );
  }

  Widget _buildItemListingThumbnail(
    PlayerToolMarketListing listing, {
    double iconSize = 40,
  }) {
    switch (listing.kind) {
      case 'drug_lot':
        final drugType = listing.drugLot?.drugType;
        if (drugType != null && drugType.isNotEmpty) {
          return WebAssetHelper.image(
            'assets/images/drugs/$drugType.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            errorBuilder: (context, error, stackTrace) {
              return Center(
                child: Icon(Icons.medication_liquid, size: iconSize),
              );
            },
          );
        }
        return Center(child: Icon(Icons.medication_liquid, size: iconSize));
      case 'crypto_lot':
        return Center(
          child: Icon(
            Icons.currency_bitcoin,
            size: iconSize,
            color: Colors.amber,
          ),
        );
      case 'trade_good_lot':
        return Center(
          child: Icon(Icons.inventory_2_outlined, size: iconSize),
        );
      case 'event_item':
        return Center(
          child: Icon(Icons.emoji_events_outlined, size: iconSize),
        );
      default:
        final toolId = listing.playerTool?.toolId;
        if (toolId != null) {
          return WebAssetHelper.image(
            'assets/images/tools/${toolId}_tool.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            errorBuilder: (context, error, stackTrace) {
              return Center(
                child: Icon(Icons.build_circle_outlined, size: iconSize),
              );
            },
          );
        }
        return Center(child: Icon(Icons.build_circle_outlined, size: iconSize));
    }
  }

  String _bmL10n(AppLocalizations l10n, String key, String fallback) {
    final dynamic d = l10n;
    final Object? value = switch (key) {
      'bmHubSellKindTool' => d.bmHubSellKindTool,
      'bmHubSellKindDrug' => d.bmHubSellKindDrug,
      'bmHubSellKindCrypto' => d.bmHubSellKindCrypto,
      'bmHubSellKindTrade' => d.bmHubSellKindTrade,
      'bmHubNoDrugsToSell' => d.bmHubNoDrugsToSell,
      'bmHubNoCryptoToSell' => d.bmHubNoCryptoToSell,
      'bmHubNoTradeGoodsToSell' => d.bmHubNoTradeGoodsToSell,
      'bmHubListDrugTitle' => d.bmHubListDrugTitle,
      'bmHubListDrugSelectLabel' => d.bmHubListDrugSelectLabel,
      'bmHubListCryptoTitle' => d.bmHubListCryptoTitle,
      'bmHubListCryptoSelectLabel' => d.bmHubListCryptoSelectLabel,
      'bmHubListTradeTitle' => d.bmHubListTradeTitle,
      'bmHubListTradeSelectLabel' => d.bmHubListTradeSelectLabel,
      'bmHubQuantityGrams' => d.bmHubQuantityGrams,
      'bmHubQuantityCrypto' => d.bmHubQuantityCrypto,
      'bmHubQuantityUnits' => d.bmHubQuantityUnits,
      _ => null,
    };
    if (value is String && value.isNotEmpty) return value;
    return fallback;
  }

  List<Map<String, dynamic>> _parseCryptoHoldings(Map<String, dynamic> portfolio) {
    final raw = portfolio['holdings'] ?? portfolio['assets'];
    if (raw is! List) return [];
    return raw
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .where((row) => ((row['quantity'] as num?)?.toDouble() ?? 0) > 0)
        .toList();
  }

  String _cryptoHoldingSymbol(Map<String, dynamic> row) {
    return (row['symbol'] ?? row['assetSymbol'] ?? row['asset_symbol'] ?? '')
        .toString()
        .toUpperCase();
  }

  Widget _buildToolMarketListingCard(PlayerToolMarketListing listing) {
    final l10n = AppLocalizations.of(context)!;
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final isSelf = auth.currentPlayer?.id == listing.sellerId;
    final name = listing.displayName;
    final pt = listing.playerTool;
    final maxD = listing.toolDefinition?.maxDurability ?? 1;
    final pct = pt != null && maxD > 0
        ? ((pt.durability / maxD) * 100).round()
        : 0;
    final detailText = listing.kind == 'player_tool' && pt != null
        ? l10n.bmHubToolQtyDurability(pt.quantity, pct)
        : listing.subtitle;

    return MarketCompactRow(
      leading: marketThumbBox(
        width: 56,
        height: 40,
        color: Colors.grey[800],
        child: _buildItemListingThumbnail(listing, iconSize: 22),
      ),
      info: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 4,
            runSpacing: 3,
            children: [
              MarketInfoPill(
                label: listing.sellerUsername,
                color: Colors.blueGrey.shade700,
                icon: Icons.person,
              ),
              MarketInfoPill(
                label: (listing.countryCode ?? l10n.bmHubLocationUnknown)
                    .toUpperCase(),
                color: Colors.blueGrey.shade700,
                icon: Icons.location_on,
              ),
              if (detailText.isNotEmpty)
                MarketInfoPill(
                  label: detailText,
                  color: Colors.teal.shade700,
                ),
            ],
          ),
        ],
      ),
      meta: Text(
        '€${listing.price}',
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Colors.green,
        ),
      ),
      action: isSelf
          ? null
          : FilledButton(
              onPressed: () => _buyToolListing(listing),
              style: marketBuyButtonStyle(),
              child: Text(l10n.bmHubBuyNow),
            ),
    );
  }

  Widget _buildMyToolMarketListingCard(PlayerToolMarketListing listing) {
    final l10n = AppLocalizations.of(context)!;
    final name = listing.displayName;
    final subtitle = listing.subtitle;

    return MarketCompactRow(
      leading: marketThumbBox(
        width: 56,
        height: 40,
        color: Colors.grey[800],
        child: _buildItemListingThumbnail(listing, iconSize: 22),
      ),
      info: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
          if (subtitle.isNotEmpty) ...[
            const SizedBox(height: 4),
            MarketInfoPill(label: subtitle, color: Colors.blueGrey.shade700),
          ],
        ],
      ),
      meta: Text(
        '€${listing.price}',
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Colors.green,
        ),
      ),
      action: FilledButton(
        onPressed: () => _delistToolListing(listing),
        style: marketBuyButtonStyle(background: Colors.red),
        child: Text(l10n.bmHubDelist),
      ),
    );
  }

  Future<void> _buyToolListing(PlayerToolMarketListing listing) async {
    final l10n = AppLocalizations.of(context)!;
    final vehicleProvider = Provider.of<VehicleProvider>(
      context,
      listen: false,
    );
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final playerMoney = authProvider.currentPlayer?.money ?? 0;
    if (playerMoney < listing.price) {
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(l10n.tuneShopErrorInsufficientFunds),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final name = listing.displayName;
    final priceStr = '€${listing.price}';

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.confirmAction),
        content: ResponsiveDialogContent(
          phoneMaxWidth: 320,
          tabletMaxWidth: 380,
          desktopMaxWidth: 420,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.bmHubBuyToolTitle,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(l10n.bmHubBuyToolConfirm(name, priceStr)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: Text(l10n.buy),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    final newMoney =
        await vehicleProvider.buyPlayerToolListing(listing.listingId);

    if (!mounted) return;

    if (newMoney != null) {
      authProvider.updatePlayerStats(money: newMoney);
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(l10n.bmHubToolPurchased),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(
            vehicleProvider.error ?? l10n.bmHubToolPurchaseFailed,
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _delistToolListing(PlayerToolMarketListing listing) async {
    final l10n = AppLocalizations.of(context)!;
    final name = listing.displayName;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.confirmAction),
        content: ResponsiveDialogContent(
          phoneMaxWidth: 320,
          tabletMaxWidth: 380,
          desktopMaxWidth: 420,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.bmHubDelistToolTitle,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(l10n.bmHubDelistToolConfirm(name)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(l10n.bmHubDelist),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    final vehicleProvider = Provider.of<VehicleProvider>(
      context,
      listen: false,
    );
    final ok =
        await vehicleProvider.delistPlayerToolListing(listing.listingId);

    if (!mounted) return;

    if (ok) {
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(l10n.bmHubToolDelisted),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(
            vehicleProvider.error ?? l10n.bmHubDelistFailed,
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _showSellItemKindPicker(VehicleProvider vehicleProvider) async {
    final l10n = AppLocalizations.of(context)!;

    final kind = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.bmHubSellCarriedItem),
        content: ResponsiveDialogContent(
          phoneMaxWidth: 320,
          tabletMaxWidth: 380,
          desktopMaxWidth: 420,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.build_circle_outlined),
                title: Text(_bmL10n(l10n, 'bmHubSellKindTool', 'Tool')),
                onTap: () => Navigator.pop(dialogContext, 'tool'),
              ),
              ListTile(
                leading: const Icon(Icons.medication_liquid),
                title: Text(_bmL10n(l10n, 'bmHubSellKindDrug', 'Drugs')),
                onTap: () => Navigator.pop(dialogContext, 'drug'),
              ),
              ListTile(
                leading: const Icon(Icons.currency_bitcoin),
                title: Text(_bmL10n(l10n, 'bmHubSellKindCrypto', 'Crypto')),
                onTap: () => Navigator.pop(dialogContext, 'crypto'),
              ),
              ListTile(
                leading: const Icon(Icons.inventory_2_outlined),
                title: Text(_bmL10n(l10n, 'bmHubSellKindTrade', 'Trade goods')),
                onTap: () => Navigator.pop(dialogContext, 'trade'),
              ),
              ListTile(
                leading: const Icon(Icons.emoji_events_outlined),
                title: Text(_bmL10n(l10n, 'bmHubSellKindEvent', 'Event items')),
                onTap: () => Navigator.pop(dialogContext, 'event'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.cancel),
          ),
        ],
      ),
    );

    if (!mounted || kind == null) return;

    switch (kind) {
      case 'tool':
        await _showListCarriedToolDialog(vehicleProvider);
      case 'drug':
        await _showListDrugLotDialog(vehicleProvider);
      case 'crypto':
        await _showListCryptoLotDialog(vehicleProvider);
      case 'trade':
        await _showListTradeGoodDialog(vehicleProvider);
      case 'event':
        await _showListEventItemDialog(vehicleProvider);
    }
  }

  Future<void> _showListDrugLotDialog(VehicleProvider vehicleProvider) async {
    final l10n = AppLocalizations.of(context)!;
    final inventory = await DrugService().getDrugInventory();
    if (!mounted) return;

    if (inventory.isEmpty) {
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(
            _bmL10n(l10n, 'bmHubNoDrugsToSell', 'No drugs to sell'),
          ),
        ),
      );
      return;
    }

    final priceController = TextEditingController();
    final qtyController = TextEditingController(text: '1');
    final selectedRef = <DrugInventory>[inventory.first];

    final submitted = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(_bmL10n(l10n, 'bmHubListDrugTitle', 'List drugs')),
              content: ResponsiveDialogContent(
                phoneMaxWidth: 320,
                tabletMaxWidth: 400,
                desktopMaxWidth: 440,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<DrugInventory>(
                      decoration: InputDecoration(
                        labelText: _bmL10n(
                          l10n,
                          'bmHubListDrugSelectLabel',
                          'Drug stack',
                        ),
                      ),
                      value: selectedRef[0],
                      items: inventory
                          .map(
                            (item) => DropdownMenuItem(
                              value: item,
                              child: Text(
                                '${item.drugName} (${item.qualityLabel}) • ${item.quantity}g',
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (v) {
                        if (v != null) {
                          setState(() => selectedRef[0] = v);
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: qtyController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: _bmL10n(
                          l10n,
                          'bmHubQuantityGrams',
                          'Quantity (g)',
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: l10n.bmHubNewPriceEuro,
                        hintText: l10n.bmHubEnterNewPriceHint,
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext, false),
                  child: Text(l10n.cancel),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(dialogContext, true),
                  child: Text(l10n.bmHubListToolSubmit),
                ),
              ],
            );
          },
        );
      },
    );

    if (submitted != true || !mounted) return;

    final quantity = int.tryParse(qtyController.text.trim());
    final price = int.tryParse(priceController.text.trim());
    if (quantity == null ||
        quantity <= 0 ||
        quantity > selectedRef[0].quantity) {
      showTopRightFromSnackBar(
        context,
        SnackBar(content: Text(l10n.bmHubInvalidToolPrice)),
      );
      return;
    }
    if (price == null || price <= 0) {
      showTopRightFromSnackBar(
        context,
        SnackBar(content: Text(l10n.bmHubInvalidToolPrice)),
      );
      return;
    }

    final ok = await vehicleProvider.listDrugLotOnMarket(
      selectedRef[0].id,
      quantity,
      price,
    );
    if (!mounted) return;

    if (ok) {
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(l10n.bmHubToolListedMessage),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(
            vehicleProvider.error ?? l10n.bmHubListToolFailed,
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _showListCryptoLotDialog(VehicleProvider vehicleProvider) async {
    final l10n = AppLocalizations.of(context)!;
    final portfolio = await CryptoService().getPortfolio();
    if (!mounted) return;

    if (portfolio['success'] == false) {
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(
            portfolio['message']?.toString() ?? l10n.bmHubListToolFailed,
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final holdings = _parseCryptoHoldings(portfolio);
    if (holdings.isEmpty) {
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(
            _bmL10n(l10n, 'bmHubNoCryptoToSell', 'No crypto to sell'),
          ),
        ),
      );
      return;
    }

    final priceController = TextEditingController();
    final qtyController = TextEditingController(
      text: (holdings.first['quantity'] as num?)?.toString() ?? '0',
    );
    final selectedRef = <Map<String, dynamic>>[holdings.first];

    final submitted = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                _bmL10n(l10n, 'bmHubListCryptoTitle', 'List crypto'),
              ),
              content: ResponsiveDialogContent(
                phoneMaxWidth: 320,
                tabletMaxWidth: 400,
                desktopMaxWidth: 440,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<Map<String, dynamic>>(
                      decoration: InputDecoration(
                        labelText: _bmL10n(
                          l10n,
                          'bmHubListCryptoSelectLabel',
                          'Asset',
                        ),
                      ),
                      value: selectedRef[0],
                      items: holdings
                          .map(
                            (row) => DropdownMenuItem(
                              value: row,
                              child: Text(
                                '${_cryptoHoldingSymbol(row)} • ${row['quantity']}',
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (v) {
                        if (v != null) {
                          setState(() {
                            selectedRef[0] = v;
                            qtyController.text =
                                (v['quantity'] as num?)?.toString() ?? '0';
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: qtyController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: InputDecoration(
                        labelText: _bmL10n(
                          l10n,
                          'bmHubQuantityCrypto',
                          'Quantity',
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: l10n.bmHubNewPriceEuro,
                        hintText: l10n.bmHubEnterNewPriceHint,
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext, false),
                  child: Text(l10n.cancel),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(dialogContext, true),
                  child: Text(l10n.bmHubListToolSubmit),
                ),
              ],
            );
          },
        );
      },
    );

    if (submitted != true || !mounted) return;

    final assetSymbol = _cryptoHoldingSymbol(selectedRef[0]);
    final quantity = double.tryParse(qtyController.text.trim());
    final maxQty = (selectedRef[0]['quantity'] as num?)?.toDouble() ?? 0;
    final price = int.tryParse(priceController.text.trim());
    if (assetSymbol.isEmpty ||
        quantity == null ||
        quantity <= 0 ||
        quantity > maxQty + 1e-8) {
      showTopRightFromSnackBar(
        context,
        SnackBar(content: Text(l10n.bmHubInvalidToolPrice)),
      );
      return;
    }
    if (price == null || price <= 0) {
      showTopRightFromSnackBar(
        context,
        SnackBar(content: Text(l10n.bmHubInvalidToolPrice)),
      );
      return;
    }

    final ok = await vehicleProvider.listCryptoLotOnMarket(
      assetSymbol,
      quantity,
      price,
    );
    if (!mounted) return;

    if (ok) {
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(l10n.bmHubToolListedMessage),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(
            vehicleProvider.error ?? l10n.bmHubListToolFailed,
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _showListTradeGoodDialog(VehicleProvider vehicleProvider) async {
    final l10n = AppLocalizations.of(context)!;
    final apiClient = ApiClient();

    try {
      final response = await apiClient.get('/trade/inventory');
      if (!mounted) return;

      if (response.statusCode != 200) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(l10n.bmHubListToolFailed),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final data = json.decode(response.body) as Map<String, dynamic>;
      final goods = ((data['inventory'] as List?) ?? const [])
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .where((item) {
            final qty = (item['quantity'] as num?)?.toInt() ?? 0;
            final spoiled = item['spoiled'] as bool? ?? false;
            final id = (item['id'] as num?)?.toInt();
            return qty > 0 && !spoiled && id != null && id > 0;
          })
          .toList();

      if (goods.isEmpty) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(
              _bmL10n(
                l10n,
                'bmHubNoTradeGoodsToSell',
                'No trade goods to sell',
              ),
            ),
          ),
        );
        return;
      }

      final priceController = TextEditingController();
      final qtyController = TextEditingController(text: '1');
      final selectedRef = <Map<String, dynamic>>[goods.first];

      final submitted = await showDialog<bool>(
        context: context,
        builder: (dialogContext) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text(
                  _bmL10n(l10n, 'bmHubListTradeTitle', 'List trade goods'),
                ),
                content: ResponsiveDialogContent(
                  phoneMaxWidth: 320,
                  tabletMaxWidth: 400,
                  desktopMaxWidth: 440,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButtonFormField<Map<String, dynamic>>(
                        decoration: InputDecoration(
                          labelText: _bmL10n(
                            l10n,
                            'bmHubListTradeSelectLabel',
                            'Good',
                          ),
                        ),
                        value: selectedRef[0],
                        items: goods
                            .map(
                              (item) => DropdownMenuItem(
                                value: item,
                                child: Text(
                                  '${item['goodName'] ?? item['goodType']} (${item['quantity']})',
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (v) {
                          if (v != null) {
                            setState(() => selectedRef[0] = v);
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: qtyController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: _bmL10n(
                            l10n,
                            'bmHubQuantityUnits',
                            'Quantity',
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: priceController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: l10n.bmHubNewPriceEuro,
                          hintText: l10n.bmHubEnterNewPriceHint,
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext, false),
                    child: Text(l10n.cancel),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(dialogContext, true),
                    child: Text(l10n.bmHubListToolSubmit),
                  ),
                ],
              );
            },
          );
        },
      );

      if (submitted != true || !mounted) return;

      final inventoryId = (selectedRef[0]['id'] as num).toInt();
      final quantity = int.tryParse(qtyController.text.trim());
      final maxQty = (selectedRef[0]['quantity'] as num?)?.toInt() ?? 0;
      final price = int.tryParse(priceController.text.trim());
      if (quantity == null || quantity <= 0 || quantity > maxQty) {
        showTopRightFromSnackBar(
          context,
          SnackBar(content: Text(l10n.bmHubInvalidToolPrice)),
        );
        return;
      }
      if (price == null || price <= 0) {
        showTopRightFromSnackBar(
          context,
          SnackBar(content: Text(l10n.bmHubInvalidToolPrice)),
        );
        return;
      }

      final ok = await vehicleProvider.listTradeGoodLotOnMarket(
        inventoryId,
        quantity,
        price,
      );
      if (!mounted) return;

      if (ok) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(l10n.bmHubToolListedMessage),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(
              vehicleProvider.error ?? l10n.bmHubListToolFailed,
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (_) {
      if (!mounted) return;
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(l10n.bmHubListToolFailed),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _showListEventItemDialog(VehicleProvider vehicleProvider) async {
    final l10n = AppLocalizations.of(context)!;
    final apiClient = ApiClient();

    try {
      final response = await apiClient.get('/game-events/my-items');
      if (!mounted) return;

      if (response.statusCode != 200) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(l10n.bmHubListToolFailed),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final data = json.decode(response.body) as Map<String, dynamic>;
      final items = ((data['items'] as List?) ?? const [])
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .where(
            (e) =>
                e['transferable'] == true &&
                ((e['quantity'] as num?)?.toInt() ?? 0) > 0,
          )
          .toList();

      if (items.isEmpty) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(
              _bmL10n(l10n, 'bmHubNoEventItemsToSell', 'No event items to sell'),
            ),
          ),
        );
        return;
      }

      final selectedRef = <Map<String, dynamic>>[items.first];
      final qtyController = TextEditingController(
        text: '${(items.first['quantity'] as num?)?.toInt() ?? 1}',
      );
      final priceController = TextEditingController();

      final submitted = await showDialog<bool>(
        context: context,
        builder: (dialogContext) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text(
                  _bmL10n(l10n, 'bmHubListEventItemTitle', 'Sell event item'),
                ),
                content: ResponsiveDialogContent(
                  phoneMaxWidth: 360,
                  tabletMaxWidth: 420,
                  desktopMaxWidth: 460,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButtonFormField<Map<String, dynamic>>(
                        initialValue: selectedRef[0],
                        items: items
                            .map(
                              (row) => DropdownMenuItem(
                                value: row,
                                child: Text(
                                  '${row['nameEn'] ?? row['itemKey']} • ${row['quantity']}',
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (v) {
                          if (v != null) {
                            setState(() {
                              selectedRef[0] = v;
                              qtyController.text =
                                  '${(v['quantity'] as num?)?.toInt() ?? 1}';
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: qtyController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: _bmL10n(
                            l10n,
                            'bmHubQuantityEvent',
                            'Quantity',
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: priceController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: l10n.bmHubNewPriceEuro,
                          hintText: l10n.bmHubEnterNewPriceHint,
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext, false),
                    child: Text(l10n.cancel),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(dialogContext, true),
                    child: Text(l10n.bmHubListToolSubmit),
                  ),
                ],
              );
            },
          );
        },
      );

      if (submitted != true || !mounted) return;

      final eventItemId = (selectedRef[0]['id'] as num).toInt();
      final quantity = int.tryParse(qtyController.text.trim());
      final maxQty = (selectedRef[0]['quantity'] as num?)?.toInt() ?? 0;
      final price = int.tryParse(priceController.text.trim());
      if (quantity == null || quantity <= 0 || quantity > maxQty) {
        showTopRightFromSnackBar(
          context,
          SnackBar(content: Text(l10n.bmHubInvalidToolPrice)),
        );
        return;
      }
      if (price == null || price <= 0) {
        showTopRightFromSnackBar(
          context,
          SnackBar(content: Text(l10n.bmHubInvalidToolPrice)),
        );
        return;
      }

      final ok = await vehicleProvider.listEventItemOnMarket(
        eventItemId,
        quantity,
        price,
      );
      if (!mounted) return;

      if (ok) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(l10n.bmHubToolListedMessage),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(
              vehicleProvider.error ?? l10n.bmHubListToolFailed,
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (_) {
      if (!mounted) return;
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(l10n.bmHubListToolFailed),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _showListCarriedToolDialog(VehicleProvider vehicleProvider) async {
    final l10n = AppLocalizations.of(context)!;
    final inv = InventoryService();
    final carried = await inv.getCarriedTools();
    if (!mounted) return;
    if (carried['success'] != true) {
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(l10n.bmHubLoadCarriedToolsFailed),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final tools = (carried['tools'] as List)
        .map((e) => e is CarriedTool ? e : CarriedTool.fromJson(e as Map<String, dynamic>))
        .toList();
    final listedIds = vehicleProvider.myToolMarketListings
        .where((e) => e.playerTool != null)
        .map((e) => e.playerTool!.id)
        .toSet();

    final eligible = tools
        .where((t) => !t.isBroken && !listedIds.contains(t.id))
        .toList();

    if (eligible.isEmpty) {
      showTopRightFromSnackBar(
        context,
        SnackBar(content: Text(l10n.bmHubNoCarriedToolsToSell)),
      );
      return;
    }

    final priceController = TextEditingController();
    final selectedRef = <CarriedTool>[eligible.first];

    final submitted = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(l10n.bmHubListToolTitle),
              content: ResponsiveDialogContent(
                phoneMaxWidth: 320,
                tabletMaxWidth: 400,
                desktopMaxWidth: 440,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<CarriedTool>(
                      decoration: InputDecoration(
                        labelText: l10n.bmHubListToolSelectLabel,
                      ),
                      value: selectedRef[0],
                      items: eligible
                          .map(
                            (t) => DropdownMenuItem(
                              value: t,
                              child: Text(t.name),
                            ),
                          )
                          .toList(),
                      onChanged: (v) {
                        if (v != null) {
                          setState(() => selectedRef[0] = v);
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: l10n.bmHubNewPriceEuro,
                        hintText: l10n.bmHubEnterNewPriceHint,
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext, false),
                  child: Text(l10n.cancel),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(dialogContext, true),
                  child: Text(l10n.bmHubListToolSubmit),
                ),
              ],
            );
          },
        );
      },
    );

    if (submitted != true || !mounted) return;

    final playerToolId = selectedRef[0].id;
    final price = int.tryParse(priceController.text.trim());
    if (price == null || price <= 0) {
      showTopRightFromSnackBar(
        context,
        SnackBar(content: Text(l10n.bmHubInvalidToolPrice)),
      );
      return;
    }

    final ok = await vehicleProvider.listPlayerToolOnMarket(playerToolId, price);
    if (!mounted) return;

    if (ok) {
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(l10n.bmHubToolListedMessage),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(
            vehicleProvider.error ?? l10n.bmHubListToolFailed,
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildMyListingCard(VehicleInventoryItem vehicle) {
    final l10n = AppLocalizations.of(context)!;
    final askingPrice = vehicle.askingPrice ?? 0;
    final marketValue = vehicle.getMarketValue();

    return MarketCompactRow(
      leading: _vehicleListingThumb(vehicle),
      info: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            vehicle.definition?.name ?? l10n.unknown,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 4,
            runSpacing: 3,
            children: [
              MarketInfoPill(
                label:
                    '${l10n.bmHubMarketValueShort}: €${marketValue.toStringAsFixed(0)}',
                color: Colors.blueGrey.shade700,
              ),
            ],
          ),
        ],
      ),
      meta: Text(
        '€${askingPrice.toStringAsFixed(0)}',
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Colors.green,
        ),
      ),
      action: Wrap(
        spacing: 6,
        children: [
          OutlinedButton(
            onPressed: () => _editPrice(vehicle),
            style: OutlinedButton.styleFrom(
              visualDensity: VisualDensity.compact,
              minimumSize: const Size(0, 34),
            ),
            child: Text(l10n.bmHubEditPrice),
          ),
          FilledButton(
            onPressed: () => _delistVehicle(vehicle),
            style: marketBuyButtonStyle(background: Colors.red),
            child: Text(l10n.bmHubDelist),
          ),
        ],
      ),
    );
  }

  Future<void> _showFilterDialog() async {
    String? tempCountry = _filterCountry;
    String? tempVehicleType = _filterVehicleType;
    double tempMinPrice = _minPrice;
    double tempMaxPrice = _maxPrice;

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        final l10n = AppLocalizations.of(dialogContext)!;
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
          title: Text(l10n.bmHubFilterListingsTitle),
          content: ResponsiveDialogContent(
            phoneMaxWidth: 340,
            tabletMaxWidth: 420,
            desktopMaxWidth: 500,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String?>(
                  initialValue: tempCountry,
                  decoration: InputDecoration(labelText: l10n.bmHubLabelCountry),
                  items: [
                    DropdownMenuItem(
                      value: null,
                      child: Text(l10n.bmHubAllCountries),
                    ),
                    ...[
                      'netherlands',
                      'belgium',
                      'france',
                      'germany',
                      'italy',
                      'spain',
                      'switzerland',
                      'austria',
                    ].map(
                      (c) => DropdownMenuItem(
                        value: c,
                        child: Text(c.toUpperCase()),
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      tempCountry = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String?>(
                  initialValue: tempVehicleType,
                  decoration: InputDecoration(labelText: l10n.bmHubLabelVehicleType),
                  items: [
                    DropdownMenuItem(value: null, child: Text(l10n.bmHubAllTypes)),
                    DropdownMenuItem(value: 'car', child: Text(l10n.bmHubCars)),
                    DropdownMenuItem(value: 'boat', child: Text(l10n.bmHubBoats)),
                  ],
                  onChanged: (value) {
                    setState(() {
                      tempVehicleType = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  '${l10n.bmHubPriceRange}: €${tempMinPrice.toInt()} - €${tempMaxPrice.toInt()}',
                ),
                RangeSlider(
                  values: RangeValues(tempMinPrice, tempMaxPrice),
                  min: 0,
                  max: 1000000,
                  divisions: 100,
                  labels: RangeLabels(
                    '€${tempMinPrice.toInt()}',
                    '€${tempMaxPrice.toInt()}',
                  ),
                  onChanged: (values) {
                    setState(() {
                      tempMinPrice = values.start;
                      tempMaxPrice = values.end;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  tempCountry = null;
                  tempVehicleType = null;
                  tempMinPrice = 0;
                  tempMaxPrice = 1000000;
                });
              },
              child: Text(l10n.bmHubClearFilters),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(l10n.bmHubApply),
            ),
          ],
          ),
        );
      },
    );

    if (result == true) {
      setState(() {
        _filterCountry = tempCountry;
        _filterVehicleType = tempVehicleType;
        _minPrice = tempMinPrice;
        _maxPrice = tempMaxPrice;
      });
    }
  }

  Future<void> _buyVehicle(MarketListing listing) async {
    final l10n = AppLocalizations.of(context)!;
    final vehicleProvider = Provider.of<VehicleProvider>(
      context,
      listen: false,
    );
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final playerMoney = authProvider.currentPlayer?.money ?? 0;
    final askingPrice = listing.vehicle.askingPrice ?? 0;

    if (playerMoney < askingPrice) {
      showTopRightFromSnackBar(context, 
        SnackBar(
          content: Text(l10n.tuneShopErrorInsufficientFunds),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final name =
        listing.vehicle.definition?.name ?? l10n.vehicleHeistGenericVehicle;
    final priceStr = '€${askingPrice.toStringAsFixed(0)}';

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.confirmAction),
        content: ResponsiveDialogContent(
          phoneMaxWidth: 320,
          tabletMaxWidth: 380,
          desktopMaxWidth: 420,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.bmHubBuyVehicleTitle,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.bmHubBuyVehicleForConfirm(name, priceStr),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: Text(l10n.buy),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    final success = await vehicleProvider.buyVehicle(listing.id);

    if (!mounted) return;

    if (success) {
      showTopRightFromSnackBar(context, 
        SnackBar(
          content: Text(l10n.bmHubVehiclePurchased),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      showTopRightFromSnackBar(context, 
        SnackBar(
          content: Text(
            vehicleProvider.error ?? l10n.bmHubVehiclePurchaseFailed,
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _editPrice(VehicleInventoryItem vehicle) async {
    final l10n = AppLocalizations.of(context)!;
    final priceController = TextEditingController(
      text: vehicle.askingPrice?.toString() ?? '',
    );

    final newPrice = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.bmHubEditPrice),
        content: ResponsiveDialogContent(
          phoneMaxWidth: 320,
          tabletMaxWidth: 380,
          desktopMaxWidth: 440,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${l10n.bmHubCurrentPrice}: €${vehicle.askingPrice?.toStringAsFixed(0) ?? '0'}',
              ),
              const SizedBox(height: 16),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: l10n.bmHubNewPriceEuro,
                  hintText: l10n.bmHubEnterNewPriceHint,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              final price = int.tryParse(priceController.text);
              Navigator.pop(context, price);
            },
            child: Text(l10n.bmHubUpdateButton),
          ),
        ],
      ),
    );

    if (newPrice == null || !mounted) return;

    final vehicleProvider = Provider.of<VehicleProvider>(
      context,
      listen: false,
    );

    // Delist then relist with new price
    final success = await vehicleProvider.listVehicleOnMarket(
      vehicle.id,
      newPrice,
    );

    if (!mounted) return;

    if (success) {
      showTopRightFromSnackBar(context, 
        SnackBar(
          content: Text(l10n.bmHubPriceUpdated),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      showTopRightFromSnackBar(context, 
        SnackBar(
          content: Text(
            vehicleProvider.error ?? l10n.bmHubPriceUpdateFailed,
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _delistVehicle(VehicleInventoryItem vehicle) async {
    final l10n = AppLocalizations.of(context)!;
    final removeName =
        vehicle.definition?.name ?? l10n.vehicleHeistGenericVehicle;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.confirmAction),
        content: ResponsiveDialogContent(
          phoneMaxWidth: 320,
          tabletMaxWidth: 380,
          desktopMaxWidth: 420,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.bmHubDelistVehicleTitle,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.bmHubRemoveFromMarketConfirm(removeName),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(l10n.bmHubDelist),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    final vehicleProvider = Provider.of<VehicleProvider>(
      context,
      listen: false,
    );
    final success = await vehicleProvider.delistVehicle(vehicle.id);

    if (!mounted) return;

    if (success) {
      showTopRightFromSnackBar(context, 
        SnackBar(
          content: Text(l10n.bmHubVehicleDelisted),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      showTopRightFromSnackBar(context, 
        SnackBar(
          content: Text(
            vehicleProvider.error ?? l10n.bmHubDelistFailed,
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
