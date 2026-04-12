import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../models/tradable_good.dart';
import '../models/vehicle.dart';
import '../providers/vehicle_provider.dart';
import '../providers/auth_provider.dart';
import '../services/api_client.dart';
import '../l10n/app_localizations.dart';
import '../config/app_config.dart';
import 'player_profile_screen.dart';
import 'backpack_shop_screen.dart';
import '../utils/top_right_notification.dart';

class TradeScreen extends StatefulWidget {
  const TradeScreen({super.key});

  @override
  State<TradeScreen> createState() => _TradeScreenState();
}

class _TradeScreenState extends State<TradeScreen>
    with SingleTickerProviderStateMixin {
  bool _isLoading = true;
  List<TradableGood> _goods = [];
  List<GoodPrice> _prices = [];
  List<InventoryItem> _inventory = [];
  String? _errorMessage;
  late TabController _tabController;
  final Map<String, int> _buyQuantities = {};
  final Map<String, int> _sellQuantities = {};
  late final ApiClient _apiClient;

  @override
  void initState() {
    super.initState();
    _apiClient = ApiClient();
    _tabController = TabController(length: 5, vsync: this);
    _loadMarketData();
    _loadVehicleMarket();
  }

  Future<void> _loadVehicleMarket() async {
    final vehicleProvider = Provider.of<VehicleProvider>(
      context,
      listen: false,
    );
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final currentCountry = authProvider.currentPlayer?.currentCountry;
    await Future.wait([
      vehicleProvider.fetchMarketListings(country: currentCountry),
      vehicleProvider.fetchInventory(),
    ]);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadMarketData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Check if user is authenticated via AuthProvider
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (!authProvider.isAuthenticated) {
        final l10n = AppLocalizations.of(context)!;
        setState(() {
          _errorMessage = l10n.notLoggedIn;
          _isLoading = false;
        });
        return;
      }

      // Get token from ApiClient (which has proper caching for web)
      final token = await _apiClient.getToken();
      if (token == null) {
        print(
          '[TradeScreen] Token is null but user is authenticated - attempting retry',
        );
        final l10n = AppLocalizations.of(context)!;
        setState(() {
          _errorMessage =
              '${l10n.notLoggedIn} (storage issue - try logging in again)';
          _isLoading = false;
        });
        return;
      }

      // Load goods
      final goodsResponse = await http.get(
        Uri.parse('${AppConfig.apiBaseUrl}/trade/goods'),
      );

      if (goodsResponse.statusCode == 200) {
        final goodsData = jsonDecode(goodsResponse.body);
        _goods = (goodsData['goods'] as List)
            .map((g) => TradableGood.fromJson(g))
            .toList();
      }

      // Load current prices
      final pricesResponse = await http.get(
        Uri.parse('${AppConfig.apiBaseUrl}/trade/prices'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (pricesResponse.statusCode == 200) {
        final pricesData = jsonDecode(pricesResponse.body);
        _prices = (pricesData['prices'] as List)
            .map((p) => GoodPrice.fromJson(p))
            .toList();
      }

      // Load inventory
      final inventoryResponse = await http.get(
        Uri.parse('${AppConfig.apiBaseUrl}/trade/inventory'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (inventoryResponse.statusCode == 200) {
        final inventoryData = jsonDecode(inventoryResponse.body);
        _inventory = (inventoryData['inventory'] as List)
            .map((i) => InventoryItem.fromJson(i))
            .toList();
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      final l10n = AppLocalizations.of(context)!;
      setState(() {
        _errorMessage = l10n.errorLoadingMarketData(e.toString());
        _isLoading = false;
      });
    }
  }

  Future<void> _buyGood(String goodType, int quantity) async {
    try {
      final token = await _apiClient.getToken();
      if (token == null) return;

      final response = await http.post(
        Uri.parse('${AppConfig.apiBaseUrl}/trade/buy'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'goodType': goodType, 'quantity': quantity}),
      );
      if (response.statusCode == 200) {
        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
          showTopRightFromSnackBar(context, 
            SnackBar(
              content: Text(l10n.purchased),
              backgroundColor: Colors.green,
            ),
          );
        }
        _loadMarketData();
        setState(() {
          _buyQuantities[goodType] = 1;
        });
      } else {
        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
          showTopRightFromSnackBar(context, 
            SnackBar(
              content: Text(l10n.errorBuying),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        showTopRightFromSnackBar(context, 
          SnackBar(
            content: Text(l10n.unknownError),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _sellGood(String goodType, int quantity) async {
    try {
      final token = await _apiClient.getToken();
      if (token == null) return;

      final response = await http.post(
        Uri.parse('${AppConfig.apiBaseUrl}/trade/sell'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'goodType': goodType, 'quantity': quantity}),
      );
      if (response.statusCode == 200) {
        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
          showTopRightFromSnackBar(context, 
            SnackBar(content: Text(l10n.sold), backgroundColor: Colors.green),
          );
        }
        _loadMarketData();
        setState(() {
          _sellQuantities[goodType] = 1;
        });
      } else {
        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
          showTopRightFromSnackBar(context, 
            SnackBar(
              content: Text(l10n.errorSelling),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        showTopRightFromSnackBar(context, 
          SnackBar(
            content: Text(l10n.unknownError),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final vehicleProvider = Provider.of<VehicleProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('🔫 ${AppLocalizations.of(context)!.blackMarket}'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: [
            Tab(
              text: AppLocalizations.of(context)!.goods,
              icon: const Icon(Icons.shopping_bag),
            ),
            Tab(
              text: AppLocalizations.of(context)!.marketplace,
              icon: const Icon(Icons.storefront),
            ),
            Tab(
              text: AppLocalizations.of(context)!.myListings,
              icon: const Icon(Icons.list_alt),
            ),
            Tab(
              text: AppLocalizations.of(context)!.inventory,
              icon: const Icon(Icons.inventory),
            ),
            Tab(text: 'Rugzakken', icon: const Icon(Icons.backpack)),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadMarketData,
                    child: Text(AppLocalizations.of(context)!.retryAgain),
                  ),
                ],
              ),
            )
          : TabBarView(
              controller: _tabController,
              children: [
                _buildMarketTab(),
                _buildVehicleMarketTab(vehicleProvider),
                _buildMyVehicleListingsTab(vehicleProvider),
                _buildInventoryTab(),
                const BackpackShopScreen(),
              ],
            ),
    );
  }

  Widget _buildVehicleMarketTab(VehicleProvider provider) {
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final listings = provider.marketListings;
    if (listings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.directions_car, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.noVehiclesAvailable,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadVehicleMarket,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: listings.length,
        itemBuilder: (context, index) {
          final listing = listings[index];
          return _buildVehicleListingCard(listing, provider);
        },
      ),
    );
  }

  Widget _buildMyVehicleListingsTab(VehicleProvider provider) {
    final myListings = provider.inventory
        .where((v) => v.marketListing)
        .toList();

    if (myListings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.list_alt, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.noListings,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: myListings.length,
      itemBuilder: (context, index) =>
          _buildMyListingCard(myListings[index], provider),
    );
  }

  Widget _buildVehicleListingCard(
    MarketListing listing,
    VehicleProvider provider,
  ) {
    final vehicle = listing.vehicle;
    final selectedImage = vehicle.conditionImage;
    final askingPrice = vehicle.askingPrice ?? 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(8),
              ),
              child: selectedImage != null
                  ? Image.asset(
                      'assets/images/vehicles/$selectedImage',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        vehicle.vehicleType == 'car'
                            ? Icons.directions_car
                            : Icons.directions_boat,
                        color: Colors.grey[600],
                      ),
                    )
                  : Icon(
                      vehicle.vehicleType == 'car'
                          ? Icons.directions_car
                          : Icons.directions_boat,
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    vehicle.definition?.name ??
                        AppLocalizations.of(context)!.unknown,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '€${askingPrice.toStringAsFixed(0)}',
                    style: const TextStyle(color: Colors.green),
                  ),
                  Text(
                    '${AppLocalizations.of(context)!.condition}: ${vehicle.condition}%',
                    style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                  ),
                  const SizedBox(height: 4),
                  GestureDetector(
                    onTap: () => _openPlayerProfile(
                      listing.sellerId,
                      listing.sellerUsername,
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.person, size: 14, color: Colors.blue[300]),
                        const SizedBox(width: 4),
                        Text(
                          listing.sellerUsername,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue[300],
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () => _buyVehicle(listing, provider),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: Text(AppLocalizations.of(context)!.buy),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMyListingCard(
    VehicleInventoryItem vehicle,
    VehicleProvider provider,
  ) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(
          vehicle.vehicleType == 'car'
              ? Icons.directions_car
              : Icons.directions_boat,
        ),
        title: Text(vehicle.definition?.name ?? l10n.unknown),
        subtitle: Text('€${vehicle.askingPrice?.toStringAsFixed(0) ?? "0"}'),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => _removeVehicleListing(vehicle, provider),
        ),
      ),
    );
  }

  Future<void> _buyVehicle(
    MarketListing listing,
    VehicleProvider provider,
  ) async {
    try {
      final l10n = AppLocalizations.of(context)!;
      final success = await provider.buyVehicle(listing.vehicle.id);
      if (success && mounted) {
        showTopRightFromSnackBar(context, 
          SnackBar(
            content: Text(l10n.vehicleBought),
            backgroundColor: Colors.green,
          ),
        );
        await provider.fetchMarketListings();
      } else if (mounted) {
        showTopRightFromSnackBar(context, 
          SnackBar(
            content: Text(provider.error ?? l10n.purchaseFailed),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        showTopRightFromSnackBar(context, 
          SnackBar(
            content: Text(l10n.unknownError),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _removeVehicleListing(
    VehicleInventoryItem vehicle,
    VehicleProvider provider,
  ) async {
    await provider.delistVehicle(vehicle.id);
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.listingRemoved)));
  }

  void _openPlayerProfile(int playerId, String username) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            PlayerProfileScreen(playerId: playerId, username: username),
      ),
    );
  }

  Widget _buildMarketTab() {
    return RefreshIndicator(
      onRefresh: _loadMarketData,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _goods.length,
        itemBuilder: (context, index) {
          final good = _goods[index];
          final price = _prices.firstWhere(
            (p) => p.goodType == good.id,
            orElse: () => GoodPrice(
              goodType: good.id,
              currentPrice: good.basePrice,
              sellPrice: (good.basePrice * 0.9).floor(),
              multiplier: 1.0,
            ),
          );

          return _buildGoodCard(good, price, true);
        },
      ),
    );
  }

  Widget _buildInventoryTab() {
    final l10n = AppLocalizations.of(context)!;
    if (_inventory.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.inventory_2_outlined,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.noItemsInInventory,
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.buyItemsInBuyTab,
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadMarketData,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _inventory.length,
        itemBuilder: (context, index) {
          final item = _inventory[index];
          final good = _goods.firstWhere((g) => g.id == item.goodType);
          final price = _prices.firstWhere(
            (p) => p.goodType == item.goodType,
            orElse: () => GoodPrice(
              goodType: item.goodType,
              currentPrice: good.basePrice,
              sellPrice: (good.basePrice * 0.9).floor(),
              multiplier: 1.0,
            ),
          );

          return _buildInventoryCard(good, price, item);
        },
      ),
    );
  }

  String _localizedGoodName(TradableGood good, AppLocalizations l10n) {
    switch (good.id) {
      case 'contraband_flowers':
        return l10n.contrabandFlowersName;
      case 'contraband_electronics':
        return l10n.contrabandElectronicsName;
      case 'contraband_diamonds':
        return l10n.contrabandDiamondsName;
      case 'contraband_weapons':
        return l10n.contrabandWeaponsName;
      case 'contraband_pharmaceuticals':
        return l10n.contrabandPharmaceuticalsName;
      default:
        return good.name;
    }
  }

  String _localizedGoodDescription(TradableGood good, AppLocalizations l10n) {
    switch (good.id) {
      case 'contraband_flowers':
        return l10n.contrabandFlowersDesc;
      case 'contraband_electronics':
        return l10n.contrabandElectronicsDesc;
      case 'contraband_diamonds':
        return l10n.contrabandDiamondsDesc;
      case 'contraband_weapons':
        return l10n.contrabandWeaponsDesc;
      case 'contraband_pharmaceuticals':
        return l10n.contrabandPharmaceuticalsDesc;
      default:
        return good.description;
    }
  }

  Widget _buildGoodCard(TradableGood good, GoodPrice price, bool isBuying) {
    final l10n = AppLocalizations.of(context)!;
    final quantity = _buyQuantities[good.id] ?? 1;
    final totalCost = price.currentPrice * quantity;
    final localizedName = _localizedGoodName(good, l10n);
    final localizedDescription = _localizedGoodDescription(good, l10n);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(good.icon, style: const TextStyle(fontSize: 32)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localizedName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        localizedDescription,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${l10n.price}: €${price.currentPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    Text(
                      '${l10n.multiplier}: ${price.multiplier.toStringAsFixed(1)}x',
                      style: TextStyle(
                        fontSize: 12,
                        color: price.multiplier > 1.0
                            ? Colors.red
                            : Colors.blue,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: () {
                        setState(() {
                          _buyQuantities[good.id] = (quantity - 1).clamp(
                            1,
                            999,
                          );
                        });
                      },
                    ),
                    Text(
                      quantity.toString(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: () {
                        setState(() {
                          _buyQuantities[good.id] = (quantity + 1).clamp(
                            1,
                            good.maxInventory,
                          );
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${l10n.total}: €${totalCost.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _buyGood(good.id, quantity),
                  icon: const Icon(Icons.shopping_cart),
                  label: Text(l10n.buy),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInventoryCard(
    TradableGood good,
    GoodPrice price,
    InventoryItem item,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final quantity = _sellQuantities[good.id] ?? 1;
    final maxSell = item.quantity.clamp(1, 999);
    final localizedName = _localizedGoodName(good, l10n);

    // Apply condition damage to sell price
    final effectiveSellPrice = (price.sellPrice * (item.condition / 100))
        .floor();
    final totalValue = effectiveSellPrice * quantity;
    final profit = (effectiveSellPrice - item.purchasePrice) * quantity;
    String formatMoney(int value) => value.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );

    // Check if spoiled
    bool isSpoiled = item.spoiled;

    // Calculate time since purchase for flowers
    String? timeWarning;
    if (good.id == 'contraband_flowers' && item.purchasedAt != null) {
      try {
        final purchasedTime = DateTime.parse(item.purchasedAt!);
        final hoursSince = DateTime.now().difference(purchasedTime).inHours;
        final hoursRemaining = 48 - hoursSince;
        if (hoursRemaining > 0 && hoursRemaining <= 12) {
          timeWarning = l10n.spoilsInHours(hoursRemaining.toString());
        }
      } catch (e) {
        // Ignore parsing errors
      }
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: isSpoiled ? Colors.grey[300] : null,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  good.icon,
                  style: TextStyle(
                    fontSize: 32,
                    color: isSpoiled ? Colors.grey : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localizedName,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          decoration: isSpoiled
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      Text(
                        l10n.ownedQuantity(item.quantity.toString()),
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      if (item.condition < 100)
                        Text(
                          '⚙️ ${l10n.condition}: ${item.condition}%',
                          style: TextStyle(
                            fontSize: 12,
                            color: item.condition < 50
                                ? Colors.red
                                : Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      if (timeWarning != null)
                        Text(
                          timeWarning,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      if (isSpoiled)
                        Text(
                          l10n.spoiledWorthless,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            if (!isSpoiled) ...[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${l10n.sellPrice}: €${effectiveSellPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      Text(
                        '${l10n.boughtFor}: €${item.purchasePrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () {
                          setState(() {
                            _sellQuantities[good.id] = (quantity - 1).clamp(
                              1,
                              maxSell,
                            );
                          });
                        },
                      ),
                      Text(
                        quantity.toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: () {
                          setState(() {
                            _sellQuantities[good.id] = (quantity + 1).clamp(
                              1,
                              maxSell,
                            );
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${l10n.total}: €${formatMoney(totalValue)}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        profit >= 0
                            ? '${l10n.profit}: €${formatMoney(profit)}'
                            : '${l10n.loss}: €${formatMoney(-profit)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: profit >= 0 ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _sellGood(good.id, quantity),
                    icon: const Icon(Icons.sell),
                    label: Text(l10n.sell),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ], // Close the if (!isSpoiled) spread operator
          ],
        ),
      ),
    );
  }
}
