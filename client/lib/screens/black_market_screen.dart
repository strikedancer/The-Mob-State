import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/vehicle_provider.dart';
import '../providers/auth_provider.dart';
import '../models/vehicle.dart';
import '../l10n/app_localizations.dart';
import 'backpack_shop_screen.dart';
import 'materials_shop_screen.dart';
import 'weapons_market_screen.dart';
import 'ammo_market_screen.dart';
import 'trade_goods_tab.dart';
import '../utils/top_right_notification.dart';
import '../utils/web_asset_helper.dart';
import '../widgets/responsive_modal.dart';

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

    final filteredListings = _getFilteredListings(provider.marketListings);

    if (filteredListings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.storefront, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              l10n.noVehiclesAvailable,
              style: Theme.of(context).textTheme.titleMedium,
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

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filteredListings.length,
        itemBuilder: (context, index) {
          final listing = filteredListings[index];
          return _buildMarketListingCard(listing);
        },
      ),
    );
  }

  Widget _buildMyListings(VehicleProvider provider) {
    final l10n = AppLocalizations.of(context)!;
    final myListings = provider.inventory
        .where((vehicle) => vehicle.marketListing)
        .toList();

    if (myListings.isEmpty) {
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
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: myListings.length,
      itemBuilder: (context, index) {
        final vehicle = myListings[index];
        return _buildMyListingCard(vehicle);
      },
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
