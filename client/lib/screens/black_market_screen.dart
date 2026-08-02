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
import '../utils/top_right_notification.dart';
import '../utils/web_asset_helper.dart';
import '../widgets/responsive_modal.dart';
import '../models/player_tool_market_listing.dart';
import '../models/carried_tool.dart';
import '../services/inventory_service.dart';
import '../services/drug_service.dart';
import '../services/crypto_service.dart';
import '../services/api_client.dart';
class BlackMarketScreen extends StatefulWidget {
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
      length: 7,
      vsync: this,
      initialIndex: widget.initialTabIndex.clamp(0, 6),
    );
    _loadData();
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

  @override
  Widget build(BuildContext context) {
    final vehicleProvider = Provider.of<VehicleProvider>(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.blackMarket),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: [
            Tab(
              icon: const Icon(Icons.shopping_bag),
              text: l10n.tradeGoods,
            ),
            Tab(icon: const Icon(Icons.directions_car), text: l10n.marketplace),
            Tab(
              icon: const Icon(Icons.directions_car_outlined),
              text: l10n.myListings,
            ),
            Tab(icon: const Icon(Icons.backpack), text: l10n.backpacks),
            Tab(icon: const Icon(Icons.science), text: l10n.materials),
            Tab(icon: const Icon(Icons.gavel), text: l10n.weaponsMarket),
            Tab(icon: const Icon(Icons.bolt), text: l10n.ammoMarket),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadData),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: TabBarView(
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
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
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

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ...myVehicles.map(_buildMyListingCard),
        ...myTools.map(_buildMyToolMarketListingCard),
      ],
    );
  }

  Widget _buildMarketListingCard(MarketListing listing) {
    final l10n = AppLocalizations.of(context)!;
    final vehicle = listing.vehicle;
    final selectedImage = vehicle.conditionImage;
    final askingPrice = vehicle.askingPrice ?? 0;
    final marketValue = vehicle.getMarketValue();
    final priceDifference = ((askingPrice - marketValue) / marketValue * 100);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Vehicle Image
                Container(
                  width: 120,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: selectedImage != null
                      ? Stack(
                          children: [
                            WebAssetHelper.image(
                              'assets/images/vehicles/$selectedImage',
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Icon(
                                    vehicle.vehicleType == 'car'
                                        ? Icons.directions_car
                                        : Icons.directions_boat,
                                    size: 40,
                                    color: Colors.grey[600],
                                  ),
                                );
                              },
                            ),
                          ],
                        )
                      : Center(
                          child: Icon(
                            vehicle.vehicleType == 'car'
                                ? Icons.directions_car
                                : Icons.directions_boat,
                            size: 40,
                            color: Colors.grey[600],
                          ),
                        ),
                ),
                const SizedBox(width: 12),

                // Vehicle Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vehicle.definition?.name ?? l10n.unknown,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${l10n.bmHubSellerLabel}: ${listing.sellerUsername}',
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            vehicle.currentLocation?.toUpperCase() ??
                                l10n.bmHubLocationUnknown,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(width: 12),
                          Icon(
                            Icons.build,
                            size: 14,
                            color: vehicle.getConditionColor() == 'green'
                                ? Colors.green
                                : vehicle.getConditionColor() == 'orange'
                                ? Colors.orange
                                : Colors.red,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${vehicle.condition}%',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24),

            // Pricing Info
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.bmHubAskingPriceLabel,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                    ),
                    Text(
                      '€${askingPrice.toStringAsFixed(0)}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      l10n.bmHubMarketValueShort,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                    ),
                    Text(
                      '€${marketValue.toStringAsFixed(0)}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    if (priceDifference.abs() > 5)
                      Text(
                        '${priceDifference > 0 ? '+' : ''}${priceDifference.toStringAsFixed(0)}%',
                        style: TextStyle(
                          fontSize: 12,
                          color: priceDifference > 0
                              ? Colors.red
                              : Colors.green,
                        ),
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Buy Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _buyVehicle(listing),
                icon: const Icon(Icons.shopping_cart),
                label: Text(l10n.bmHubBuyNow),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
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

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 120,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _buildItemListingThumbnail(listing),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${l10n.bmHubSellerLabel}: ${listing.sellerUsername}',
                        style: Theme.of(context).textTheme.bodySmall
                            ?.copyWith(color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            (listing.countryCode ?? l10n.bmHubLocationUnknown)
                                .toUpperCase(),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          if (detailText.isNotEmpty) ...[
                            const SizedBox(width: 12),
                            Flexible(
                              child: Text(
                                detailText,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.bmHubAskingPriceLabel,
                      style: Theme.of(context).textTheme.bodySmall
                          ?.copyWith(color: Colors.grey),
                    ),
                    Text(
                      '€${listing.price.toString()}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                    ),
                  ],
                ),
                if (listing.toolDefinition != null)
                  Text(
                    l10n.bmHubToolBaseValue(
                      listing.toolDefinition!.basePrice,
                    ),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
              ],
            ),
            const SizedBox(height: 12),
            if (!isSelf)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _buyToolListing(listing),
                  icon: const Icon(Icons.shopping_cart),
                  label: Text(l10n.bmHubBuyNow),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMyToolMarketListingCard(PlayerToolMarketListing listing) {
    final l10n = AppLocalizations.of(context)!;
    final name = listing.displayName;
    final subtitle = listing.subtitle;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 100,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _buildItemListingThumbnail(listing, iconSize: 32),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: Theme.of(context).textTheme.titleSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      if (subtitle.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                      const SizedBox(height: 4),
                      Text(
                        '${l10n.bmHubListedFor}: €${listing.price}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _delistToolListing(listing),
                icon: const Icon(Icons.remove_circle, size: 18),
                label: Text(l10n.bmHubDelist),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
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
    final selectedImage = vehicle.conditionImage;
    final askingPrice = vehicle.askingPrice ?? 0;
    final marketValue = vehicle.getMarketValue();

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Vehicle Image
                Container(
                  width: 100,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: selectedImage != null
                      ? WebAssetHelper.image(
                          'assets/images/vehicles/$selectedImage',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Icon(
                                vehicle.vehicleType == 'car'
                                    ? Icons.directions_car
                                    : Icons.directions_boat,
                                size: 32,
                                color: Colors.grey[600],
                              ),
                            );
                          },
                        )
                      : Center(
                          child: Icon(
                            vehicle.vehicleType == 'car'
                                ? Icons.directions_car
                                : Icons.directions_boat,
                            size: 32,
                            color: Colors.grey[600],
                          ),
                        ),
                ),
                const SizedBox(width: 12),

                // Vehicle Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vehicle.definition?.name ?? l10n.unknown,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${l10n.bmHubListedFor}: €${askingPrice.toStringAsFixed(0)}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${l10n.bmHubMarketValueShort}: €${marketValue.toStringAsFixed(0)}',
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _editPrice(vehicle),
                    icon: const Icon(Icons.edit, size: 18),
                    label: Text(l10n.bmHubEditPrice),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _delistVehicle(vehicle),
                    icon: const Icon(Icons.remove_circle, size: 18),
                    label: Text(l10n.bmHubDelist),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
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
