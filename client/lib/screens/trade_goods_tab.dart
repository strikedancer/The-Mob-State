import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../models/tradable_good.dart';
import '../providers/auth_provider.dart';
import '../services/api_client.dart';
import '../l10n/app_localizations.dart';
import '../config/app_config.dart';
import '../utils/top_right_notification.dart';
import '../utils/web_asset_helper.dart';

/// Contraband handelswaren (market + inventory) embedded in [BlackMarketScreen].
class TradeGoodsTab extends StatefulWidget {
  const TradeGoodsTab({super.key});

  @override
  State<TradeGoodsTab> createState() => _TradeGoodsTabState();
}

class _TradeGoodsTabState extends State<TradeGoodsTab> {
  bool _isLoading = true;
  List<TradableGood> _goods = [];
  List<GoodPrice> _prices = [];
  List<InventoryItem> _inventory = [];
  String? _errorMessage;
  String? _goodsLoadError;
  String? _pricesLoadError;
  String? _inventoryLoadError;
  final Map<String, int> _buyQuantities = {};
  final Map<String, int> _sellQuantities = {};
  late final ApiClient _apiClient;

  @override
  void initState() {
    super.initState();
    _apiClient = ApiClient();
    _loadMarketData();
  }

  Future<void> _loadMarketData() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _goodsLoadError = null;
      _pricesLoadError = null;
      _inventoryLoadError = null;
    });

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (!authProvider.isAuthenticated) {
      setState(() {
        _errorMessage = l10n.notLoggedIn;
        _isLoading = false;
      });
      return;
    }

    final token = await _apiClient.getToken();
    if (token == null) {
      setState(() {
        _errorMessage =
            '${l10n.notLoggedIn} ${l10n.notLoggedInTokenStorageHint}';
        _isLoading = false;
      });
      return;
    }

    List<TradableGood> nextGoods = _goods;
    List<GoodPrice> nextPrices = _prices;
    List<InventoryItem> nextInventory = _inventory;
    String? goodsErr;
    String? pricesErr;
    String? invErr;

    try {
      final goodsResponse = await http.get(
        Uri.parse('${AppConfig.apiBaseUrl}/trade/goods'),
      );
      if (goodsResponse.statusCode == 200) {
        final goodsData = jsonDecode(goodsResponse.body) as Map<String, dynamic>;
        nextGoods = (goodsData['goods'] as List)
            .map((g) => TradableGood.fromJson(g as Map<String, dynamic>))
            .toList();
      } else {
        goodsErr = l10n.tradeLoadGoodsFailed;
      }
    } catch (_) {
      goodsErr = l10n.tradeLoadGoodsFailed;
    }

    try {
      final pricesResponse = await http.get(
        Uri.parse('${AppConfig.apiBaseUrl}/trade/prices'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (pricesResponse.statusCode == 200) {
        final pricesData = jsonDecode(pricesResponse.body) as Map<String, dynamic>;
        nextPrices = (pricesData['prices'] as List)
            .map((p) => GoodPrice.fromJson(p as Map<String, dynamic>))
            .toList();
      } else {
        pricesErr = l10n.tradeLoadPricesFailed;
      }
    } catch (_) {
      pricesErr = l10n.tradeLoadPricesFailed;
    }

    try {
      final inventoryResponse = await http.get(
        Uri.parse('${AppConfig.apiBaseUrl}/trade/inventory'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (inventoryResponse.statusCode == 200) {
        final inventoryData =
            jsonDecode(inventoryResponse.body) as Map<String, dynamic>;
        nextInventory = (inventoryData['inventory'] as List)
            .map((i) => InventoryItem.fromJson(i as Map<String, dynamic>))
            .toList();
      } else {
        invErr = l10n.tradeLoadInventoryFailed;
      }
    } catch (_) {
      invErr = l10n.tradeLoadInventoryFailed;
    }

    if (!mounted) return;

    final fatal =
        goodsErr != null && pricesErr != null && invErr != null;

    setState(() {
      _goods = nextGoods;
      _prices = nextPrices;
      _inventory = nextInventory;
      _goodsLoadError = goodsErr;
      _pricesLoadError = pricesErr;
      _inventoryLoadError = invErr;
      _isLoading = false;
      _errorMessage = fatal ? l10n.tradeMarketLoadAllFailed : null;
    });
  }

  TradableGood _resolveGood(String goodType) {
    for (final g in _goods) {
      if (g.id == goodType) return g;
    }
    return TradableGood(
      id: goodType,
      name: goodType,
      description: '',
      basePrice: 0,
      maxInventory: 9999,
      weight: 1,
    );
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
    final l10n = AppLocalizations.of(context)!;

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_errorMessage != null) {
      return Center(
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
              child: Text(l10n.retryAgain),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadMarketData,
      child: ListView(
        padding: const EdgeInsets.all(16),
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          ..._buildMarketHeaderChildren(l10n),
          for (final good in _goods)
            _buildGoodCard(
              good,
              _prices.firstWhere(
                (p) => p.goodType == good.id,
                orElse: () => GoodPrice(
                  goodType: good.id,
                  currentPrice: good.basePrice,
                  sellPrice: (good.basePrice * 0.9).floor(),
                  multiplier: 1.0,
                ),
              ),
              true,
            ),
          const SizedBox(height: 24),
          Divider(color: Theme.of(context).colorScheme.outlineVariant),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.inventory_2_outlined,
                size: 22,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                l10n.inventory,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (_inventory.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 48,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.noItemsInInventory,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            )
          else
            for (final item in _inventory)
              _buildInventoryCard(
                _resolveGood(item.goodType),
                _prices.firstWhere(
                  (p) => p.goodType == item.goodType,
                  orElse: () {
                    final g = _resolveGood(item.goodType);
                    return GoodPrice(
                      goodType: item.goodType,
                      currentPrice: g.basePrice,
                      sellPrice: (g.basePrice * 0.9).floor(),
                      multiplier: 1.0,
                    );
                  },
                ),
                item,
              ),
        ],
      ),
    );
  }

  /// Banners, risk panel, empty-goods message (same as former "Goederen" tab top).
  List<Widget> _buildMarketHeaderChildren(AppLocalizations l10n) {
    return [
      if (_goodsLoadError != null ||
          _pricesLoadError != null ||
          _inventoryLoadError != null)
        Card(
          color: Colors.orange.shade50,
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.warning_amber_rounded,
                        color: Colors.orange.shade800),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.tradePartialDataBanner,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.orange.shade900,
                        ),
                      ),
                    ),
                  ],
                ),
                if (_goodsLoadError != null)
                  Text('• $_goodsLoadError',
                      style: TextStyle(color: Colors.orange.shade900)),
                if (_pricesLoadError != null)
                  Text('• $_pricesLoadError',
                      style: TextStyle(color: Colors.orange.shade900)),
                if (_inventoryLoadError != null)
                  Text('• $_inventoryLoadError',
                      style: TextStyle(color: Colors.orange.shade900)),
              ],
            ),
          ),
        ),
      _buildTradeRiskGuide(l10n),
      if (_goods.isEmpty)
        Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 8),
          child: Center(
            child: Text(
              _goodsLoadError ?? l10n.tradeNoGoodsLoaded,
              textAlign: TextAlign.center,
            ),
          ),
        )
      else
        const SizedBox(height: 8),
    ];
  }

  Widget _buildTradeRiskGuide(AppLocalizations l10n) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          title: Text(
            l10n.tradeRiskPanelTitle,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            l10n.tradeRiskPanelSubtitle,
            style: TextStyle(fontSize: 12, color: Colors.grey[700]),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Text(
                l10n.tradeRiskInsightBody,
                style: TextStyle(fontSize: 13, height: 1.35, color: Colors.grey[800]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _riskChipsForGood(TradableGood good, AppLocalizations l10n) {
    final chips = <Widget>[];
    if (good.spoilageHours != null && good.spoilageHours! > 0) {
      chips.add(
        Chip(
          avatar: Icon(Icons.timer, size: 16, color: Colors.orange.shade800),
          label: Text(
            l10n.tradeRiskSpoilageHours(good.spoilageHours!.round().toString()),
            style: const TextStyle(fontSize: 11),
          ),
          visualDensity: VisualDensity.compact,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      );
    }
    if (good.priceVolatility != null && good.priceVolatility! > 0) {
      final pct = (good.priceVolatility! * 100).round();
      chips.add(
        Chip(
          avatar: Icon(Icons.show_chart, size: 16, color: Colors.purple.shade800),
          label: Text(
            l10n.tradeRiskVolatilityPct(pct.toString()),
            style: const TextStyle(fontSize: 11),
          ),
          visualDensity: VisualDensity.compact,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      );
    }
    if (good.confiscationChance != null && good.confiscationChance! > 0) {
      final pct = (good.confiscationChance! * 100).round();
      chips.add(
        Chip(
          avatar: Icon(Icons.gavel, size: 16, color: Colors.red.shade800),
          label: Text(
            l10n.tradeRiskConfiscationPct(pct.toString()),
            style: const TextStyle(fontSize: 11),
          ),
          visualDensity: VisualDensity.compact,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      );
    }
    if (good.damageChancePerTrip != null && good.damageChancePerTrip! > 0) {
      final pct = (good.damageChancePerTrip! * 100).round();
      chips.add(
        Chip(
          avatar: Icon(Icons.build_circle_outlined, size: 16, color: Colors.brown.shade800),
          label: Text(
            l10n.tradeRiskDamageTripPct(pct.toString()),
            style: const TextStyle(fontSize: 11),
          ),
          visualDensity: VisualDensity.compact,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      );
    }
    return chips;
  }

  Widget _goodHeaderArt(TradableGood good) {
    final colors = switch (good.id) {
      'contraband_flowers' => [Colors.pink.shade100, Colors.orange.shade200],
      'contraband_electronics' => [Colors.blue.shade100, Colors.indigo.shade200],
      'contraband_diamonds' => [Colors.cyan.shade100, Colors.teal.shade200],
      'contraband_weapons' => [Colors.red.shade200, Colors.grey.shade800],
      'contraband_pharmaceuticals' => [Colors.green.shade100, Colors.lightGreen.shade200],
      _ => [Colors.grey.shade300, Colors.grey.shade500],
    };
    final assetPath = 'assets/images/trade_goods/cards/${good.id}.png';

    Widget emojiFallback() => Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              colors: colors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          alignment: Alignment.center,
          child: Text(good.icon, style: const TextStyle(fontSize: 26)),
        );

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        width: 52,
        height: 52,
        child: WebAssetHelper.image(
          assetPath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => emojiFallback(),
        ),
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
    final riskChips = _riskChipsForGood(good, l10n);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _goodHeaderArt(good),
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
            if (riskChips.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: riskChips,
              ),
            ],
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
    final riskChips = _riskChipsForGood(good, l10n);

    // Calculate time since purchase for flowers
    String? timeWarning;
    if (good.id == 'contraband_flowers' && item.purchasedAt != null) {
      try {
        final purchasedTime = DateTime.parse(item.purchasedAt!);
        final hoursSince = DateTime.now().difference(purchasedTime).inHours;
        final spoilH = (good.spoilageHours ?? 48).round();
        final hoursRemaining = spoilH - hoursSince;
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
                Opacity(
                  opacity: isSpoiled ? 0.45 : 1,
                  child: _goodHeaderArt(good),
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
            if (!isSpoiled && riskChips.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(spacing: 8, runSpacing: 8, children: riskChips),
            ],
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
