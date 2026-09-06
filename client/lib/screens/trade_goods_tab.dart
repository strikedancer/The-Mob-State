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
import '../utils/trade_good_l10n.dart';
import '../utils/country_helper.dart';

enum _TradeMarketFilter { all, here, starter, bulk, luxury, dangerous }

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
  List<InventoryItem> _storedElsewhere = [];
  String _currentCountry = '';
  String? _errorMessage;
  String? _goodsLoadError;
  String? _pricesLoadError;
  String? _inventoryLoadError;
  final Map<String, int> _buyQuantities = {};
  final Map<String, int> _sellQuantities = {};
  _TradeMarketFilter _marketFilter = _TradeMarketFilter.all;
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
    List<InventoryItem> nextElsewhere = _storedElsewhere;
    var nextCountry = _currentCountry;
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
        nextInventory = (inventoryData['inventory'] as List? ?? const [])
            .map((i) => InventoryItem.fromJson(i as Map<String, dynamic>))
            .toList();
        nextElsewhere = (inventoryData['storedElsewhere'] as List? ?? const [])
            .map((i) => InventoryItem.fromJson(i as Map<String, dynamic>))
            .toList();
        nextCountry = inventoryData['currentCountry'] as String? ?? nextCountry;
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
      _storedElsewhere = nextElsewhere;
      _currentCountry = nextCountry;
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
          String message = l10n.errorBuying;
          try {
            final body = jsonDecode(response.body);
            if (body is Map) {
              if (body['error'] == 'GOOD_NOT_AVAILABLE_IN_COUNTRY') {
                message = l10n.tradeGoodNotAvailableHere;
              } else if (body['message'] != null) {
                message = body['message'].toString();
              }
            }
          } catch (_) {}
          showTopRightFromSnackBar(context, 
            SnackBar(
              content: Text(message),
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
          final body = jsonDecode(response.body);
          final apiMessage = body is Map ? body['message']?.toString() : null;
          final xpGained = body is Map ? body['xpGained'] : null;
          final snackText = (apiMessage != null && apiMessage.isNotEmpty)
              ? apiMessage
              : (xpGained is num && xpGained > 0)
                  ? '${l10n.sold} (+$xpGained XP)'
                  : l10n.sold;
          showTopRightFromSnackBar(context, 
            SnackBar(content: Text(snackText), backgroundColor: Colors.green),
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
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          ..._buildMarketHeaderChildren(l10n),
          ..._buildBuyableGoodCards(l10n),
          ..._buildUnavailableGoodsSection(l10n),
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
      Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(
          l10n.tradeGoodsCountryLockedHint,
          style: TextStyle(
            fontSize: 13,
            height: 1.35,
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.75),
          ),
        ),
      ),
      ..._buildLocalStockSection(l10n),
      ..._buildStoredElsewhereSection(l10n),
      _buildTradeRiskGuide(l10n),
      _buildMarketFilterBar(l10n),
      if (_buyableGoods.isEmpty && _goods.isNotEmpty)
        Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.flight_takeoff, color: Colors.blue.shade700),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    l10n.tradeNoBuyableGoodsInCountry,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.35,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
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

  List<Widget> _buildLocalStockSection(AppLocalizations l10n) {
    return [
      const SizedBox(height: 4),
      Row(
        children: [
          Icon(
            Icons.storefront_outlined,
            size: 18,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.tradeSellHereTitle,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  _currentCountry.isEmpty
                      ? l10n.tradeSellHereSubtitle
                      : '${l10n.tradeSellHereSubtitle} (${CountryHelper.getLocalizedCountryName(_currentCountry, l10n)})',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.65),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      const SizedBox(height: 8),
      if (_inventory.isEmpty)
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 8, 0, 16),
          child: Text(
            l10n.tradeNoStockHere,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
            ),
          ),
        )
      else
        for (final item in _inventory)
          _buildInventoryCard(
            _resolveGood(item.goodType),
            _priceForGood(item.goodType),
            item,
          ),
    ];
  }

  List<Widget> _buildStoredElsewhereSection(AppLocalizations l10n) {
    if (_storedElsewhere.isEmpty) return const [];

    final byCountry = <String, List<InventoryItem>>{};
    for (final item in _storedElsewhere) {
      final key = item.country.isEmpty ? 'unknown' : item.country;
      byCountry.putIfAbsent(key, () => []).add(item);
    }
    final countries = byCountry.keys.toList()..sort();

    return [
      const SizedBox(height: 4),
      Divider(color: Theme.of(context).colorScheme.outlineVariant),
      const SizedBox(height: 6),
      Row(
        children: [
          Icon(
            Icons.public,
            size: 18,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.tradeStoredElsewhereTitle,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  l10n.tradeStoredElsewhereHint,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.65),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      const SizedBox(height: 8),
      for (final countryId in countries) ...[
        Padding(
          padding: const EdgeInsets.only(bottom: 6, top: 4),
          child: Text(
            l10n.tradeStoredInCountry(
              CountryHelper.getLocalizedCountryName(countryId, l10n),
            ),
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
        ),
        for (final item in byCountry[countryId]!)
          _buildStoredElsewhereCard(item, l10n),
      ],
      const SizedBox(height: 8),
    ];
  }

  Widget _buildStoredElsewhereCard(InventoryItem item, AppLocalizations l10n) {
    final good = _resolveGood(item.goodType);
    final localizedName = TradeGoodL10n.name(l10n, good.id);
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
        child: Row(
          children: [
            Opacity(opacity: 0.85, child: _goodHeaderArt(good, size: 40)),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localizedName,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    l10n.ownedQuantity(item.quantity.toString()),
                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  GoodPrice _priceForGood(String goodId) {
    return _prices.firstWhere(
      (p) => p.goodType == goodId,
      orElse: () {
        final g = _resolveGood(goodId);
        return GoodPrice(
          goodType: goodId,
          currentPrice: g.basePrice,
          sellPrice: (g.basePrice * 0.9).floor(),
          multiplier: 1.0,
        );
      },
    );
  }

  List<TradableGood> get _sortedGoods {
    final list = List<TradableGood>.from(_goods);
    list.sort((a, b) {
      final tierCmp = a.tier.compareTo(b.tier);
      if (tierCmp != 0) return tierCmp;
      return a.basePrice.compareTo(b.basePrice);
    });
    return list;
  }

  bool _matchesMarketFilter(TradableGood good) {
    switch (_marketFilter) {
      case _TradeMarketFilter.all:
        return true;
      case _TradeMarketFilter.here:
        return _priceForGood(good.id).availableToBuy;
      case _TradeMarketFilter.starter:
        return good.category == 'starter';
      case _TradeMarketFilter.bulk:
        return good.category == 'bulk';
      case _TradeMarketFilter.luxury:
        return good.category == 'luxury';
      case _TradeMarketFilter.dangerous:
        return good.category == 'dangerous';
    }
  }

  List<TradableGood> get _buyableGoods {
    return _sortedGoods
        .where(
          (good) =>
              _priceForGood(good.id).availableToBuy &&
              _matchesMarketFilter(good),
        )
        .toList();
  }

  List<TradableGood> get _unavailableGoods {
    return _sortedGoods
        .where(
          (good) =>
              !_priceForGood(good.id).availableToBuy &&
              _matchesMarketFilter(good),
        )
        .toList();
  }

  Widget _buildMarketFilterBar(AppLocalizations l10n) {
    final buyableHere =
        _goods.where((g) => _priceForGood(g.id).availableToBuy).length;

    Widget chip(_TradeMarketFilter filter, String label) {
      final selected = _marketFilter == filter;
      return Padding(
        padding: const EdgeInsets.only(right: 6),
        child: FilterChip(
          label: Text(label, style: const TextStyle(fontSize: 12)),
          selected: selected,
          onSelected: (_) => setState(() => _marketFilter = filter),
          visualDensity: VisualDensity.compact,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          labelPadding: const EdgeInsets.symmetric(horizontal: 6),
          padding: EdgeInsets.zero,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.tradeMarketCatalogSummary(
              _goods.length.toString(),
              buyableHere.toString(),
            ),
            style: TextStyle(
              fontSize: 11,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 6),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                chip(_TradeMarketFilter.all, l10n.tradeCategoryAll),
                chip(_TradeMarketFilter.here, l10n.tradeFilterAvailableHere),
                chip(_TradeMarketFilter.starter, l10n.tradeCategoryStarter),
                chip(_TradeMarketFilter.bulk, l10n.tradeCategoryBulk),
                chip(_TradeMarketFilter.luxury, l10n.tradeCategoryLuxury),
                chip(_TradeMarketFilter.dangerous, l10n.tradeCategoryDangerous),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildBuyableGoodCards(AppLocalizations l10n) {
    return [
      for (final good in _buyableGoods)
        _buildGoodCard(good, _priceForGood(good.id)),
    ];
  }

  List<Widget> _buildUnavailableGoodsSection(AppLocalizations l10n) {
    final unavailable = _unavailableGoods;
    if (unavailable.isEmpty) {
      return const [];
    }

    return [
      const SizedBox(height: 8),
      Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            dense: true,
            visualDensity: VisualDensity.compact,
            tilePadding: const EdgeInsets.symmetric(horizontal: 10),
            title: Text(
              l10n.tradeUnavailableGoodsTitle,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              l10n.tradeUnavailableGoodsSubtitle(unavailable.length.toString()),
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            children: [
              for (final good in unavailable)
                ListTile(
                  dense: true,
                  leading: _goodHeaderArt(good),
                  title: Text(TradeGoodL10n.name(l10n, good.id)),
                  subtitle: Text(l10n.tradeTravelToSourceHint),
                ),
            ],
          ),
        ),
      ),
    ];
  }

  Widget _buildTradeRiskGuide(AppLocalizations l10n) {
    final scheme = Theme.of(context).colorScheme;
    final bodyColor = scheme.onSurface.withValues(alpha: 0.92);
    final subtitleColor = scheme.onSurfaceVariant.withValues(alpha: 0.95);

    return Card(
      margin: const EdgeInsets.only(bottom: 6),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          dense: true,
          visualDensity: VisualDensity.compact,
          tilePadding: const EdgeInsets.symmetric(horizontal: 10),
          childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
          iconColor: scheme.onSurface,
          collapsedIconColor: scheme.onSurfaceVariant,
          title: Text(
            l10n.tradeRiskPanelTitle,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: scheme.onSurface,
            ),
          ),
          children: [
            Text(
              l10n.tradeRiskPanelSubtitle,
              style: TextStyle(fontSize: 12, color: subtitleColor),
            ),
            const SizedBox(height: 6),
            Text(
              l10n.tradeRiskInsightBody,
              style: TextStyle(
                fontSize: 12,
                height: 1.4,
                color: bodyColor,
                fontWeight: FontWeight.w500,
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
      final hours = good.spoilageHours!.round().toString();
      chips.add(
        _riskPill(
          icon: Icons.timer,
          label: '${hours}h',
          color: Colors.orange.shade800,
          tooltip: l10n.tradeRiskSpoilageHours(hours),
        ),
      );
    }
    if (good.priceVolatility != null && good.priceVolatility! > 0) {
      final pct = (good.priceVolatility! * 100).round();
      chips.add(
        _riskPill(
          icon: Icons.show_chart,
          label: '±$pct%',
          color: Colors.purple.shade700,
          tooltip: l10n.tradeRiskVolatilityPct(pct.toString()),
        ),
      );
    }
    if (good.confiscationChance != null && good.confiscationChance! > 0) {
      final pct = (good.confiscationChance! * 100).round();
      chips.add(
        _riskPill(
          icon: Icons.gavel,
          label: '$pct%',
          color: Colors.red.shade700,
          tooltip: l10n.tradeRiskConfiscationPct(pct.toString()),
        ),
      );
    }
    if (good.damageChancePerTrip != null && good.damageChancePerTrip! > 0) {
      final pct = (good.damageChancePerTrip! * 100).round();
      chips.add(
        _riskPill(
          icon: Icons.build_circle_outlined,
          label: '$pct%',
          color: Colors.brown.shade700,
          tooltip: l10n.tradeRiskDamageTripPct(pct.toString()),
        ),
      );
    }
    if (good.weight >= 3) {
      chips.add(
        _riskPill(
          icon: Icons.fitness_center,
          label: '${good.weight}',
          color: Colors.blueGrey.shade700,
          tooltip: l10n.tradeRiskHeavyWeight(good.weight.toString()),
        ),
      );
    }
    return chips;
  }

  Widget _riskPill({
    required IconData icon,
    required String label,
    required Color color,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.28)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _goodHeaderArt(TradableGood good, {double size = 44}) {
    final colors = switch (good.id) {
      'contraband_flowers' => [Colors.pink.shade100, Colors.orange.shade200],
      'contraband_electronics' => [Colors.blue.shade100, Colors.indigo.shade200],
      'contraband_diamonds' => [Colors.cyan.shade100, Colors.teal.shade200],
      'contraband_weapons' => [Colors.red.shade200, Colors.grey.shade800],
      'contraband_pharmaceuticals' => [Colors.green.shade100, Colors.lightGreen.shade200],
      'contraband_spirits' => [Colors.amber.shade100, Colors.orange.shade300],
      'contraband_tobacco' => [Colors.brown.shade100, Colors.brown.shade400],
      'contraband_art' => [Colors.deepPurple.shade100, Colors.purple.shade300],
      'contraband_spices' => [Colors.orange.shade100, Colors.red.shade200],
      'contraband_coffee' => [Colors.brown.shade200, Colors.amber.shade100],
      'contraband_fur_leather' => [Colors.grey.shade400, Colors.brown.shade300],
      'contraband_perfume' => [Colors.pink.shade100, Colors.purple.shade200],
      'contraband_counterfeit_cash' => [Colors.green.shade200, Colors.grey.shade700],
      'contraband_rare_wine' => [Colors.red.shade100, Colors.purple.shade200],
      'contraband_luxury_watches' => [Colors.blueGrey.shade200, Colors.amber.shade100],
      'contraband_gold' => [Colors.amber.shade200, Colors.yellow.shade600],
      _ => [Colors.grey.shade300, Colors.grey.shade500],
    };
    final assetPath = 'assets/images/trade_goods/cards/${good.id}.png';

    Widget emojiFallback() => Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: LinearGradient(
              colors: colors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          alignment: Alignment.center,
          child: Text(good.icon, style: TextStyle(fontSize: size * 0.46)),
        );

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: size,
        height: size,
        child: WebAssetHelper.image(
          assetPath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => emojiFallback(),
        ),
      ),
    );
  }

  String _formatEuro(int value) {
    return '€${value.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}';
  }

  Widget _qtyStepper({
    required int quantity,
    required int max,
    required ValueChanged<int> onChanged,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.remove_circle_outline),
          iconSize: 20,
          visualDensity: VisualDensity.compact,
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          padding: EdgeInsets.zero,
          onPressed: () => onChanged((quantity - 1).clamp(1, max)),
        ),
        SizedBox(
          width: 22,
          child: Text(
            '$quantity',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.add_circle_outline),
          iconSize: 20,
          visualDensity: VisualDensity.compact,
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          padding: EdgeInsets.zero,
          onPressed: () => onChanged((quantity + 1).clamp(1, max)),
        ),
      ],
    );
  }

  Widget _buildGoodCard(TradableGood good, GoodPrice price) {
    final l10n = AppLocalizations.of(context)!;
    final quantity = _buyQuantities[good.id] ?? 1;
    final totalCost = price.currentPrice * quantity;
    final localizedName = TradeGoodL10n.name(l10n, good.id);
    final localizedDescription = TradeGoodL10n.description(l10n, good.id);
    final riskChips = _riskChipsForGood(good, l10n);
    final categoryLabel = TradeGoodL10n.categoryLabel(l10n, good.category);
    final narrow = MediaQuery.sizeOf(context).width < 700;

    final info = Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 6,
            children: [
              Text(
                localizedName,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (good.category != null)
                Text(
                  categoryLabel,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
            ],
          ),
          if (riskChips.isNotEmpty) ...[
            const SizedBox(height: 4),
            Wrap(spacing: 4, runSpacing: 3, children: riskChips),
          ],
        ],
      ),
    );

    final priceBlock = Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          _formatEuro(price.currentPrice),
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        Text(
          '${price.multiplier.toStringAsFixed(1)}x',
          style: TextStyle(
            fontSize: 11,
            color: price.multiplier > 1.0 ? Colors.red : Colors.blue,
          ),
        ),
        if (quantity > 1)
          Text(
            '${l10n.total}: ${_formatEuro(totalCost)}',
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
          ),
      ],
    );

    final actions = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _qtyStepper(
          quantity: quantity,
          max: good.maxInventory,
          onChanged: (next) => setState(() => _buyQuantities[good.id] = next),
        ),
        const SizedBox(width: 4),
        FilledButton(
          onPressed: () => _buyGood(good.id, quantity),
          style: FilledButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            visualDensity: VisualDensity.compact,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            minimumSize: const Size(0, 34),
          ),
          child: Text(l10n.buy),
        ),
      ],
    );

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Tooltip(
        message: localizedDescription,
        waitDuration: const Duration(milliseconds: 500),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
          child: narrow
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _goodHeaderArt(good),
                        const SizedBox(width: 10),
                        info,
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        priceBlock,
                        const Spacer(),
                        actions,
                      ],
                    ),
                  ],
                )
              : Row(
                  children: [
                    _goodHeaderArt(good),
                    const SizedBox(width: 10),
                    info,
                    const SizedBox(width: 10),
                    priceBlock,
                    const SizedBox(width: 8),
                    actions,
                  ],
                ),
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
    final localizedName = TradeGoodL10n.name(l10n, good.id);

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

    final narrow = MediaQuery.sizeOf(context).width < 700;
    final info = Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localizedName,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              decoration: isSpoiled ? TextDecoration.lineThrough : null,
            ),
          ),
          Wrap(
            spacing: 8,
            runSpacing: 2,
            children: [
              Text(
                l10n.ownedQuantity(item.quantity.toString()),
                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
              ),
              if (item.condition < 100)
                Text(
                  '${l10n.condition}: ${item.condition}%',
                  style: TextStyle(
                    fontSize: 11,
                    color: item.condition < 50 ? Colors.red : Colors.orange,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              if (timeWarning != null)
                Text(
                  timeWarning,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.orange,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              if (isSpoiled)
                Text(
                  l10n.spoiledWorthless,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
            ],
          ),
          if (!isSpoiled && riskChips.isNotEmpty) ...[
            const SizedBox(height: 4),
            Wrap(spacing: 4, runSpacing: 3, children: riskChips),
          ],
        ],
      ),
    );

    final priceBlock = Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          _formatEuro(effectiveSellPrice),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        Text(
          '${l10n.boughtFor}: ${_formatEuro(item.purchasePrice)}',
          style: TextStyle(fontSize: 11, color: Colors.grey[600]),
        ),
        if (!isSpoiled)
          Text(
            profit >= 0
                ? '${l10n.profit}: €${formatMoney(profit)}'
                : '${l10n.loss}: €${formatMoney(-profit)}',
            style: TextStyle(
              fontSize: 11,
              color: profit >= 0 ? Colors.green : Colors.red,
              fontWeight: FontWeight.w700,
            ),
          ),
        if (quantity > 1 && !isSpoiled)
          Text(
            '${l10n.total}: €${formatMoney(totalValue)}',
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
          ),
      ],
    );

    final actions = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _qtyStepper(
          quantity: quantity,
          max: maxSell,
          onChanged: (next) => setState(() => _sellQuantities[good.id] = next),
        ),
        const SizedBox(width: 4),
        FilledButton(
          onPressed: () => _sellGood(good.id, quantity),
          style: FilledButton.styleFrom(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            visualDensity: VisualDensity.compact,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            minimumSize: const Size(0, 34),
          ),
          child: Text(l10n.sell),
        ),
      ],
    );

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: isSpoiled ? Colors.grey[300] : null,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
        child: isSpoiled
            ? Row(
                children: [
                  Opacity(opacity: 0.45, child: _goodHeaderArt(good)),
                  const SizedBox(width: 10),
                  info,
                ],
              )
            : narrow
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _goodHeaderArt(good),
                          const SizedBox(width: 10),
                          info,
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          priceBlock,
                          const Spacer(),
                          actions,
                        ],
                      ),
                    ],
                  )
                : Row(
                    children: [
                      _goodHeaderArt(good),
                      const SizedBox(width: 10),
                      info,
                      const SizedBox(width: 10),
                      priceBlock,
                      const SizedBox(width: 8),
                      actions,
                    ],
                  ),
      ),
    );
  }
}
