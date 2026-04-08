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
import '../utils/top_right_notification.dart';

class BlackMarketScreen extends StatefulWidget {
  const BlackMarketScreen({super.key});

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
    _tabController = TabController(length: 6, vsync: this);
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

  String _tr(String nl, String en) {
    return Localizations.localeOf(context).languageCode == 'nl' ? nl : en;
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
            Tab(icon: const Icon(Icons.directions_car), text: l10n.vehicles),
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
        children: [
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
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${_tr('Fout', 'Error')}: ${provider.error}'),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _loadData, child: Text(_tr('Opnieuw proberen', 'Retry'))),
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
              _tr('Geen voertuigen beschikbaar', 'No vehicles available'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              _tr('Probeer je filters aan te passen', 'Try adjusting your filters'),
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
              _tr('Geen actieve listings', 'No active listings'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              _tr('Ga naar Garage of Marina om voertuigen te plaatsen', 'Go to Garage or Marina to list vehicles'),
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
                            Image.asset(
                              'images/vehicles/$selectedImage',
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
                        vehicle.definition?.name ?? _tr('Onbekend voertuig', 'Unknown vehicle'),
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${_tr('Verkoper', 'Seller')}: ${listing.sellerUsername}',
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
                            vehicle.currentLocation?.toUpperCase() ?? _tr('ONBEKEND', 'UNKNOWN'),
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
                      _tr('Vraagprijs', 'Asking Price'),
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
                      _tr('Marktwaarde', 'Market Value'),
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
                label: Text(_tr('Nu kopen', 'Buy now')),
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
                      ? Image.asset(
                          'images/vehicles/$selectedImage',
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
                        vehicle.definition?.name ?? _tr('Onbekend voertuig', 'Unknown vehicle'),
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${_tr('Geplaatst voor', 'Listed for')}: €${askingPrice.toStringAsFixed(0)}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${_tr('Marktwaarde', 'Market value')}: €${marketValue.toStringAsFixed(0)}',
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
                    label: Text(_tr('Prijs aanpassen', 'Edit price')),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _delistVehicle(vehicle),
                    icon: const Icon(Icons.remove_circle, size: 18),
                    label: Text(_tr('Verwijderen', 'Delist')),
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
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(_tr('Listings filteren', 'Filter listings')),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Country Filter
                DropdownButtonFormField<String?>(
                  initialValue: tempCountry,
                  decoration: InputDecoration(labelText: _tr('Land', 'Country')),
                  items: [
                    DropdownMenuItem(
                      value: null,
                      child: Text(_tr('Alle landen', 'All countries')),
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

                // Vehicle Type Filter
                DropdownButtonFormField<String?>(
                  initialValue: tempVehicleType,
                  decoration: InputDecoration(labelText: _tr('Voertuigtype', 'Vehicle type')),
                  items: [
                    DropdownMenuItem(value: null, child: Text(_tr('Alle types', 'All types'))),
                    DropdownMenuItem(value: 'car', child: Text(_tr('Auto\'s', 'Cars'))),
                    DropdownMenuItem(value: 'boat', child: Text(_tr('Boten', 'Boats'))),
                  ],
                  onChanged: (value) {
                    setState(() {
                      tempVehicleType = value;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Price Range
                Text(
                  '${_tr('Prijsbereik', 'Price range')}: €${tempMinPrice.toInt()} - €${tempMaxPrice.toInt()}',
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
              child: Text(_tr('Filters wissen', 'Clear filters')),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(_tr('Annuleren', 'Cancel')),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(_tr('Toepassen', 'Apply')),
            ),
          ],
        ),
      ),
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
          content: Text(_tr('Onvoldoende geld', 'Insufficient funds')),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_tr('Weet je het zeker?', 'Are you sure?')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _tr('Voertuig kopen', 'Buy vehicle'),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              _tr(
                'Koop ${listing.vehicle.definition?.name ?? 'voertuig'} voor €${askingPrice.toStringAsFixed(0)}?',
                'Buy ${listing.vehicle.definition?.name ?? 'vehicle'} for €${askingPrice.toStringAsFixed(0)}?',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(_tr('Annuleren', 'Cancel')),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: Text(_tr('Kopen', 'Buy')),
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
          content: Text(_tr('Voertuig succesvol gekocht!', 'Vehicle purchased successfully!')),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      showTopRightFromSnackBar(context, 
        SnackBar(
          content: Text(vehicleProvider.error ?? _tr('Voertuig kopen mislukt', 'Failed to buy vehicle')),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _editPrice(VehicleInventoryItem vehicle) async {
    final priceController = TextEditingController(
      text: vehicle.askingPrice?.toString() ?? '',
    );

    final newPrice = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_tr('Prijs aanpassen', 'Edit price')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${_tr('Huidige prijs', 'Current price')}: €${vehicle.askingPrice?.toStringAsFixed(0) ?? '0'}',
            ),
            const SizedBox(height: 16),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: _tr('Nieuwe prijs (€)', 'New price (€)'),
                hintText: _tr('Vul nieuwe prijs in', 'Enter new price'),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(_tr('Annuleren', 'Cancel')),
          ),
          ElevatedButton(
            onPressed: () {
              final price = int.tryParse(priceController.text);
              Navigator.pop(context, price);
            },
            child: Text(_tr('Bijwerken', 'Update')),
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
          content: Text(_tr('Prijs succesvol aangepast!', 'Price updated successfully!')),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      showTopRightFromSnackBar(context, 
        SnackBar(
          content: Text(vehicleProvider.error ?? _tr('Prijs aanpassen mislukt', 'Failed to update price')),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _delistVehicle(VehicleInventoryItem vehicle) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_tr('Weet je het zeker?', 'Are you sure?')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _tr('Voertuig van markt halen', 'Delist vehicle'),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              _tr(
                'Verwijder ${vehicle.definition?.name ?? 'voertuig'} van de markt?',
                'Remove ${vehicle.definition?.name ?? 'vehicle'} from the market?',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(_tr('Annuleren', 'Cancel')),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(_tr('Verwijderen', 'Delist')),
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
          content: Text(_tr('Voertuig succesvol van de markt gehaald!', 'Vehicle delisted successfully!')),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      showTopRightFromSnackBar(context, 
        SnackBar(
          content: Text(vehicleProvider.error ?? _tr('Voertuig verwijderen mislukt', 'Failed to delist vehicle')),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
