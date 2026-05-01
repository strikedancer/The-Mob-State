import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/achievement.dart';
import '../services/crypto_service.dart';
import '../utils/achievement_notifier.dart';
import '../utils/top_right_notification.dart';

String _localizeCryptoApiMessage(AppLocalizations l10n, String? raw) {
  if (raw == null || raw.trim().isEmpty) {
    return l10n.cryptoActionProcessed;
  }
  final s = raw.trim();
  if (s.startsWith('Error: ')) {
    return l10n.cryptoClientErrorPrefix(s.substring(7));
  }

  final buyM = RegExp(r'^Je kocht ([\d.]+) (\w+) voor €([\d.]+)\.$').firstMatch(s);
  if (buyM != null) {
    return l10n.cryptoApiBuySuccess(buyM.group(1)!, buyM.group(2)!, buyM.group(3)!);
  }
  final sellM = RegExp(r'^Je verkocht ([\d.]+) (\w+) voor €([\d.]+)\.$').firstMatch(s);
  if (sellM != null) {
    return l10n.cryptoApiSellSuccess(sellM.group(1)!, sellM.group(2)!, sellM.group(3)!);
  }
  final orderPlaced = RegExp(
    r'^Order geplaatst: (BUY|SELL) ([\d.]+) (\w+) @ ([\d.]+)\.$',
  ).firstMatch(s);
  if (orderPlaced != null) {
    final sideCode = orderPlaced.group(1)!;
    final sideLabel =
        sideCode == 'SELL' ? l10n.cryptoSideSell : l10n.cryptoSideBuy;
    return l10n.cryptoApiOrderPlaced(
      sideLabel,
      orderPlaced.group(2)!,
      orderPlaced.group(3)!,
      orderPlaced.group(4)!,
    );
  }
  final cancelM = RegExp(r'^Order (\d+) geannuleerd\.$').firstMatch(s);
  if (cancelM != null) {
    return l10n.cryptoApiOrderCancelledDetail(int.parse(cancelM.group(1)!));
  }

  switch (s) {
    case 'Kon crypto markt niet laden.':
      return l10n.cryptoApiCouldNotLoadMarket;
    case 'Crypto niet gevonden.':
      return l10n.cryptoApiAssetNotFound;
    case 'Kon crypto grafiekdata niet laden.':
      return l10n.cryptoApiCouldNotLoadChart;
    case 'Niet ingelogd.':
      return l10n.cryptoApiNotLoggedIn;
    case 'Kon portfolio niet laden.':
      return l10n.cryptoApiCouldNotLoadPortfolio;
    case 'Kon crypto transactiehistorie niet laden.':
      return l10n.cryptoApiCouldNotLoadTransactions;
    case 'Ongeldige hoeveelheid.':
      return l10n.cryptoApiInvalidQuantity;
    case 'Niet genoeg geld.':
      return l10n.cryptoApiInsufficientFunds;
    case 'Aankoop mislukt.':
      return l10n.cryptoApiPurchaseFailed;
    case 'Niet genoeg crypto in bezit.':
      return l10n.cryptoApiNotEnoughCrypto;
    case 'Verkoop mislukt.':
      return l10n.cryptoApiSellFailed;
    case 'Kon crypto orders niet laden.':
      return l10n.cryptoApiCouldNotLoadOrders;
    case 'Ongeldige doelprijs.':
      return l10n.cryptoApiInvalidTargetPrice;
    case 'Ongeldig ordertype.':
      return l10n.cryptoApiInvalidOrderType;
    case 'Ongeldige orderrichting.':
      return l10n.cryptoApiInvalidOrderSide;
    case 'Deze combinatie van ordertype en richting is niet toegestaan.':
      return l10n.cryptoApiInvalidOrderCombination;
    case 'Order plaatsen mislukt.':
      return l10n.cryptoApiPlaceOrderFailed;
    case 'Speler niet gevonden.':
      return l10n.cryptoApiPlayerNotFound;
    case 'Ongeldig order-id.':
      return l10n.cryptoApiInvalidOrderId;
    case 'Order niet gevonden of niet meer actief.':
      return l10n.cryptoApiOrderNotFoundOrClosed;
    case 'Order annuleren mislukt.':
      return l10n.cryptoApiCancelOrderFailed;
    default:
      return s;
  }
}

String _tradeSuccessSnackMessage(
  AppLocalizations l10n,
  bool buy,
  String? rawMessage,
) {
  if (rawMessage == null || rawMessage.trim().isEmpty) {
    return buy ? l10n.cryptoPurchaseCompleted : l10n.cryptoSaleCompleted;
  }
  final s = rawMessage.trim();
  final buyM = RegExp(r'^Je kocht ([\d.]+) (\w+) voor €([\d.]+)\.$').firstMatch(s);
  if (buyM != null) {
    return l10n.cryptoApiBuySuccess(buyM.group(1)!, buyM.group(2)!, buyM.group(3)!);
  }
  final sellM = RegExp(r'^Je verkocht ([\d.]+) (\w+) voor €([\d.]+)\.$').firstMatch(s);
  if (sellM != null) {
    return l10n.cryptoApiSellSuccess(sellM.group(1)!, sellM.group(2)!, sellM.group(3)!);
  }
  return buy ? l10n.cryptoPurchaseCompleted : l10n.cryptoSaleCompleted;
}

List<Achievement> _parseAchievementsPayload(dynamic payload) {
  if (payload is! List) {
    return const <Achievement>[];
  }

  return payload
      .whereType<Map>()
      .map((item) => Achievement.fromJson(Map<String, dynamic>.from(item)))
      .toList();
}

class CryptoScreen extends StatefulWidget {
  const CryptoScreen({super.key});

  @override
  State<CryptoScreen> createState() => _CryptoScreenState();
}

class _CryptoScreenState extends State<CryptoScreen> {
  final CryptoService _cryptoService = CryptoService();

  bool _loading = true;
  List<Map<String, dynamic>> _market = const [];
  List<Map<String, dynamic>> _holdings = const [];
  Map<String, double> _holdingQtyBySymbol = const {};
  Map<String, dynamic> _totals = const {};
  Map<String, dynamic> _marketSignals = const {};
  int _openOrdersCount = 0;
  String? _selectedSymbol;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _loadAll();
    _refreshTimer = Timer.periodic(const Duration(seconds: 20), (_) {
      if (!mounted) return;
      _loadAll(silent: true);
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  String _backgroundAssetForWidth(double width) {
    if (width >= 1200) {
      return 'assets/images/backgrounds/crypto_market_bg_desktop.png';
    }
    if (width >= 700) {
      return 'assets/images/backgrounds/crypto_market_bg_tablet.png';
    }
    return 'assets/images/backgrounds/crypto_market_bg_mobile.png';
  }

  Future<void> _loadAll({bool silent = false}) async {
    if (!silent) {
      setState(() => _loading = true);
    }

    final marketResult = await _cryptoService.getMarket();
    final portfolioResult = await _cryptoService.getPortfolio();
    final ordersResult = await _cryptoService.getOrders();

    if (!mounted) return;

    final marketList = ((marketResult['market'] as List?) ?? const <dynamic>[])
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();

    final holdingsList =
        ((portfolioResult['holdings'] as List?) ?? const <dynamic>[])
            .whereType<Map>()
            .map((item) => Map<String, dynamic>.from(item))
            .toList();

    final nextHoldingQtyBySymbol = <String, double>{
      for (final row in holdingsList)
        (row['symbol']?.toString() ?? '').toUpperCase():
            (row['quantity'] as num?)?.toDouble() ?? 0,
    };

    final allOrders = ((ordersResult['orders'] as List?) ?? const <dynamic>[])
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();

    final openOrders = allOrders
        .where((item) => item['status']?.toString() == 'OPEN')
        .toList();

    final currentSelection = _selectedSymbol;
    final nextSelection =
        (currentSelection != null &&
            marketList.any((row) => row['symbol'] == currentSelection))
        ? currentSelection
        : (marketList.isNotEmpty
              ? marketList.first['symbol']?.toString()
              : null);

    setState(() {
      _market = marketList;
      _holdings = holdingsList;
      _holdingQtyBySymbol = nextHoldingQtyBySymbol;
      _totals = Map<String, dynamic>.from(
        portfolioResult['totals'] as Map? ?? const {},
      );
      _marketSignals = Map<String, dynamic>.from(
        marketResult['marketSignals'] as Map? ?? const {},
      );
      _openOrdersCount = openOrders.length;
      _selectedSymbol = nextSelection;
      _loading = false;
    });
  }

  Future<void> _onSelectSymbol(String symbol) async {
    setState(() {
      _selectedSymbol = symbol;
    });

    final selectedMarketRow = _market.cast<Map<String, dynamic>?>().firstWhere(
      (row) => row?['symbol']?.toString() == symbol,
      orElse: () => null,
    );

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => _CryptoHistoryDialog(
        symbol: symbol,
        service: _cryptoService,
        coinName: selectedMarketRow?['name']?.toString() ?? symbol,
      ),
    );

    await _loadAll(silent: true);
  }

  String _regimeLabel(AppLocalizations l10n, String regime) {
    switch (regime) {
      case 'BULL':
        return l10n.cryptoRegimeBull;
      case 'BEAR':
        return l10n.cryptoRegimeBear;
      default:
        return l10n.cryptoRegimeSideways;
    }
  }

  Color _regimeColor(String regime) {
    switch (regime) {
      case 'BULL':
        return Colors.greenAccent;
      case 'BEAR':
        return Colors.redAccent;
      default:
        return Colors.amberAccent;
    }
  }

  Widget _buildMarketCard() {
    final l10n = AppLocalizations.of(context)!;
    if (_market.isEmpty) {
      return Center(
        child: Text(
          l10n.cryptoMarketNoData,
          style: const TextStyle(color: Colors.white70),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.cryptoMarketTitle,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            Builder(
              builder: (context) {
                final regime =
                    (_marketSignals['regime']?.toString() ?? 'SIDEWAYS')
                        .toUpperCase();
                final movePct =
                    (_marketSignals['marketMovePct'] as num?)?.toDouble() ?? 0;
                final color = _regimeColor(regime);
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: color.withOpacity(0.55)),
                  ),
                  child: Text(
                    '${_regimeLabel(l10n, regime)} (${movePct >= 0 ? '+' : ''}${movePct.toStringAsFixed(2)}%)',
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                );
              },
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: Colors.white24),
              ),
              child: Text(
                l10n.cryptoMarketOpenOrdersCount(_openOrdersCount),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Expanded(
          child: ListView.separated(
            itemCount: _market.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final row = _market[index];
              final symbol = row['symbol']?.toString() ?? '-';
              final name = row['name']?.toString() ?? '-';
              final price = (row['currentPrice'] as num?)?.toDouble() ?? 0;
              final change = (row['change24hPct'] as num?)?.toDouble() ?? 0;
              final selected = symbol == _selectedSymbol;
              final iconPath =
                  'assets/images/crypto/icons/${symbol.toLowerCase()}.png';
              final ownedQuantity =
                  _holdingQtyBySymbol[symbol.toUpperCase()] ?? 0;

              return InkWell(
                onTap: () => _onSelectSymbol(symbol),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: selected
                        ? Colors.white.withOpacity(0.18)
                        : Colors.black.withOpacity(0.35),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: selected ? Colors.amber.shade300 : Colors.white24,
                      width: selected ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.white12,
                        child: Image.asset(
                          iconPath,
                          width: 24,
                          height: 24,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => Text(
                            symbol.length >= 2
                                ? symbol.substring(0, 2)
                                : symbol,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              symbol,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              name,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                            if (ownedQuantity > 0)
                              Text(
                                l10n.cryptoOwnedAmountLine(
                                  ownedQuantity.toStringAsFixed(6),
                                ),
                                style: const TextStyle(
                                  color: Colors.greenAccent,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '€${price.toStringAsFixed(4)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            '${change >= 0 ? '+' : ''}${change.toStringAsFixed(2)}%',
                            style: TextStyle(
                              color: change >= 0
                                  ? Colors.greenAccent
                                  : Colors.redAccent,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPortfolioCard() {
    final l10n = AppLocalizations.of(context)!;
    final marketValue = (_totals['marketValue'] as num?)?.toDouble() ?? 0;
    final costBasis = (_totals['costBasis'] as num?)?.toDouble() ?? 0;
    final unrealized = (_totals['unrealizedProfit'] as num?)?.toDouble() ?? 0;
    final realized = (_totals['realizedProfit'] as num?)?.toDouble() ?? 0;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.36),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.cryptoPortfolioTitle,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 10),
          _infoRow(
            l10n.cryptoLabelValue,
            '€${marketValue.toStringAsFixed(2)}',
            Colors.white,
          ),
          _infoRow(
            l10n.cryptoLabelCostBasis,
            '€${costBasis.toStringAsFixed(2)}',
            Colors.white70,
          ),
          _infoRow(
            l10n.cryptoLabelUnrealized,
            '€${unrealized.toStringAsFixed(2)}',
            unrealized >= 0 ? Colors.greenAccent : Colors.redAccent,
          ),
          _infoRow(
            l10n.cryptoLabelRealized,
            '€${realized.toStringAsFixed(2)}',
            realized >= 0 ? Colors.greenAccent : Colors.redAccent,
          ),
          const SizedBox(height: 10),
          const Divider(color: Colors.white24),
          const SizedBox(height: 8),
          Expanded(
            child: _holdings.isEmpty
                ? Center(
                    child: Text(
                      l10n.cryptoNoPositionsYet,
                      style: const TextStyle(color: Colors.white70),
                    ),
                  )
                : ListView.separated(
                    itemCount: _holdings.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final row = _holdings[index];
                      final symbol = row['symbol']?.toString() ?? '-';
                      final quantity =
                          (row['quantity'] as num?)?.toDouble() ?? 0;
                      final pnl =
                          (row['unrealizedProfit'] as num?)?.toDouble() ?? 0;
                      return Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.06),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white12),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                '$symbol  •  ${quantity.toStringAsFixed(6)}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Text(
                              '€${pnl.toStringAsFixed(2)}',
                              style: TextStyle(
                                color: pnl >= 0
                                    ? Colors.greenAccent
                                    : Colors.redAccent,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: const TextStyle(color: Colors.white70)),
          ),
          Text(
            value,
            style: TextStyle(color: color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isWide = width >= 1100;
        final bgAsset = _backgroundAssetForWidth(width);

        return Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                bgAsset,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF07121E),
                          Color(0xFF0F2438),
                          Color(0xFF09131F),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Positioned.fill(
              child: Container(color: Colors.black.withOpacity(0.45)),
            ),
            if (_loading)
              const Center(child: CircularProgressIndicator())
            else
              Padding(
                padding: const EdgeInsets.all(16),
                child: isWide
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(flex: 3, child: _buildMarketCard()),
                          const SizedBox(width: 14),
                          Expanded(flex: 2, child: _buildPortfolioCard()),
                        ],
                      )
                    : Column(
                        children: [
                          Expanded(flex: 3, child: _buildMarketCard()),
                          const SizedBox(height: 12),
                          Expanded(flex: 2, child: _buildPortfolioCard()),
                        ],
                      ),
              ),
          ],
        );
      },
    );
  }
}

class _CryptoHistoryDialog extends StatefulWidget {
  const _CryptoHistoryDialog({
    required this.symbol,
    required this.service,
    required this.coinName,
  });

  final String symbol;
  final CryptoService service;
  final String coinName;

  @override
  State<_CryptoHistoryDialog> createState() => _CryptoHistoryDialogState();
}

class _CryptoHistoryDialogState extends State<_CryptoHistoryDialog> {
  final TextEditingController _quantityController = TextEditingController(
    text: '0.10',
  );
  final TextEditingController _orderQuantityController = TextEditingController(
    text: '0.10',
  );
  final TextEditingController _targetPriceController = TextEditingController();

  List<Map<String, dynamic>> _points = const [];
  List<Map<String, dynamic>> _openOrders = const [];
  List<Map<String, dynamic>> _transactions = const [];
  Map<String, dynamic> _stats = const {};
  Map<String, dynamic> _historySummary = const {};
  bool _loading = true;
  bool _detailsLoading = true;
  bool _processing = false;
  String? _error;
  _ChartRange _range = _ChartRange.day;
  double? _hoverX;
  double _currentPrice = 0;
  double _ownedQuantity = 0;
  double _avgBuyPrice = 0;
  String _selectedOrderType = 'LIMIT';
  String _selectedOrderSide = 'BUY';

  AppLocalizations get _l10n => AppLocalizations.of(context)!;

  @override
  void initState() {
    super.initState();
    _loadHistory();
    _loadDetails();
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _orderQuantityController.dispose();
    _targetPriceController.dispose();
    super.dispose();
  }

  Future<void> _loadHistory() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final result = await widget.service.getHistory(
      symbol: widget.symbol,
      points: _range.points,
      hours: _range.hours,
    );

    if (!mounted) {
      return;
    }

    final points = ((result['points'] as List?) ?? const <dynamic>[])
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();

    setState(() {
      _points = points;
      _stats = Map<String, dynamic>.from(result['stats'] as Map? ?? const {});
      _loading = false;
      _error = result['success'] == false
          ? (result['message']?.toString().trim().isNotEmpty == true
                ? result['message']!.toString()
                : '')
          : null;
    });
  }

  Future<void> _changeRange(_ChartRange range) async {
    if (_range == range) {
      return;
    }

    setState(() {
      _range = range;
      _hoverX = null;
    });

    await _loadHistory();
  }

  Future<void> _loadDetails() async {
    setState(() {
      _detailsLoading = true;
    });

    final marketResult = await widget.service.getMarket();
    final portfolioResult = await widget.service.getPortfolio();
    final ordersResult = await widget.service.getOrders();
    final transactionsResult = await widget.service.getTransactions(
      symbol: widget.symbol,
      limit: 12,
    );

    if (!mounted) {
      return;
    }

    final marketList = ((marketResult['market'] as List?) ?? const <dynamic>[])
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
    final holdingsList =
        ((portfolioResult['holdings'] as List?) ?? const <dynamic>[])
            .whereType<Map>()
            .map((item) => Map<String, dynamic>.from(item))
            .toList();
    final orders = ((ordersResult['orders'] as List?) ?? const <dynamic>[])
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .where(
          (item) =>
              item['status']?.toString() == 'OPEN' &&
              item['symbol']?.toString().toUpperCase() ==
                  widget.symbol.toUpperCase(),
        )
        .toList();

    final marketRow = marketList.cast<Map<String, dynamic>?>().firstWhere(
      (row) =>
          row?['symbol']?.toString().toUpperCase() ==
          widget.symbol.toUpperCase(),
      orElse: () => null,
    );
    final holdingRow = holdingsList.cast<Map<String, dynamic>?>().firstWhere(
      (row) =>
          row?['symbol']?.toString().toUpperCase() ==
          widget.symbol.toUpperCase(),
      orElse: () => null,
    );

    final transactions =
        ((transactionsResult['transactions'] as List?) ?? const <dynamic>[])
            .whereType<Map>()
            .map((item) => Map<String, dynamic>.from(item))
            .toList();

    setState(() {
      _currentPrice = (marketRow?['currentPrice'] as num?)?.toDouble() ?? 0;
      _ownedQuantity = (holdingRow?['quantity'] as num?)?.toDouble() ?? 0;
      _avgBuyPrice = (holdingRow?['avgBuyPrice'] as num?)?.toDouble() ?? 0;
      _openOrders = orders;
      _transactions = transactions;
      _historySummary = Map<String, dynamic>.from(
        transactionsResult['summary'] as Map? ?? const {},
      );
      _detailsLoading = false;
    });
  }

  String _formatDateTime(String isoValue) {
    if (isoValue.isEmpty) {
      return _l10n.cryptoUnknownTime;
    }

    final parsed = DateTime.tryParse(isoValue)?.toLocal();
    if (parsed == null) {
      return isoValue;
    }

    final twoDigitMonth = parsed.month.toString().padLeft(2, '0');
    final twoDigitDay = parsed.day.toString().padLeft(2, '0');
    final twoDigitHour = parsed.hour.toString().padLeft(2, '0');
    final twoDigitMinute = parsed.minute.toString().padLeft(2, '0');
    return '$twoDigitDay-$twoDigitMonth $twoDigitHour:$twoDigitMinute';
  }

  String _orderTypeLabel(String type) {
    switch (type) {
      case 'STOP_LOSS':
        return _l10n.cryptoOrderTypeStopLoss;
      case 'TAKE_PROFIT':
        return _l10n.cryptoOrderTypeTakeProfit;
      default:
        return _l10n.cryptoOrderTypeLimit;
    }
  }

  String _orderSideLabel(String side) {
    return side == 'SELL' ? _l10n.cryptoSideSell : _l10n.cryptoSideBuy;
  }

  bool get _orderUsesOwnedPosition =>
      _selectedOrderSide == 'SELL' || _selectedOrderType != 'LIMIT';

  String _formatQuantityInput(double value) {
    final fixed = value.toStringAsFixed(6);
    return fixed.contains('.')
        ? fixed
              .replaceFirst(RegExp(r'0+$'), '')
              .replaceFirst(RegExp(r'\.$'), '')
        : fixed;
  }

  void _fillDirectQuantityAll() {
    if (_ownedQuantity <= 0) {
      return;
    }

    final value = _formatQuantityInput(_ownedQuantity);
    setState(() {
      _quantityController.text = value;
      _quantityController.selection = TextSelection.fromPosition(
        TextPosition(offset: value.length),
      );
    });
  }

  void _fillOrderQuantityAll() {
    if (_ownedQuantity <= 0) {
      return;
    }

    final value = _formatQuantityInput(_ownedQuantity);
    setState(() {
      _orderQuantityController.text = value;
      _orderQuantityController.selection = TextSelection.fromPosition(
        TextPosition(offset: value.length),
      );
    });
  }

  Future<void> _executeTrade({required bool buy}) async {
    final quantity = double.tryParse(
      _quantityController.text.trim().replaceAll(',', '.'),
    );
    if (quantity == null || quantity <= 0) {
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(_l10n.cryptoInvalidQuantity),
        ),
      );
      return;
    }

    setState(() => _processing = true);

    final result = buy
        ? await widget.service.buy(symbol: widget.symbol, quantity: quantity)
        : await widget.service.sell(symbol: widget.symbol, quantity: quantity);

    if (!mounted) {
      return;
    }

    setState(() => _processing = false);

    final success = result['success'] == true;
    final message = success
        ? _tradeSuccessSnackMessage(
            _l10n,
            buy,
            result['message']?.toString(),
          )
        : _localizeCryptoApiMessage(
            _l10n,
            result['message']?.toString(),
          );

    showTopRightFromSnackBar(
      context,
      SnackBar(
        content: Text(message),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );

    if (!success) {
      return;
    }

    final achievements = _parseAchievementsPayload(
      result['newlyUnlockedAchievements'],
    );
    if (achievements.isNotEmpty) {
      AchievementNotifier.showMultipleAchievements(context, achievements);
    }

    await _loadDetails();
    await _loadHistory();
  }

  Future<void> _placeOpenOrder() async {
    final quantity = double.tryParse(
      _orderQuantityController.text.trim().replaceAll(',', '.'),
    );
    final targetPrice = double.tryParse(
      _targetPriceController.text.trim().replaceAll(',', '.'),
    );

    if (quantity == null || quantity <= 0) {
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(_l10n.cryptoInvalidQuantity),
        ),
      );
      return;
    }

    if (targetPrice == null || targetPrice <= 0) {
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(_l10n.cryptoInvalidTargetPrice),
        ),
      );
      return;
    }

    if (_orderUsesOwnedPosition && quantity > _ownedQuantity) {
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(
            _l10n.cryptoCannotSellMoreThanOwned,
          ),
        ),
      );
      return;
    }

    setState(() => _processing = true);

    final result = await widget.service.placeOrder(
      symbol: widget.symbol,
      orderType: _selectedOrderType,
      side: _selectedOrderSide,
      quantity: quantity,
      targetPrice: targetPrice,
    );

    if (!mounted) {
      return;
    }

    setState(() => _processing = false);

    final success = result['success'] == true;
    final rawMsg = result['message']?.toString() ?? '';
    final snackText = success
        ? (rawMsg.trim().isNotEmpty
              ? _localizeCryptoApiMessage(_l10n, rawMsg)
              : _l10n.cryptoOpenOrderPlaced)
        : (rawMsg.trim().isNotEmpty
              ? _localizeCryptoApiMessage(_l10n, rawMsg)
              : _l10n.cryptoOpenOrderFailed);
    showTopRightFromSnackBar(
      context,
      SnackBar(
        content: Text(snackText),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );

    if (!success) {
      return;
    }

    _orderQuantityController.clear();
    _targetPriceController.clear();
    await _loadDetails();
  }

  Future<void> _cancelOpenOrder(int orderId) async {
    setState(() => _processing = true);

    final result = await widget.service.cancelOrder(orderId: orderId);

    if (!mounted) {
      return;
    }

    setState(() => _processing = false);

    final success = result['success'] == true;
    final cancelRaw = result['message']?.toString() ?? '';
    final cancelSnack = success
        ? (cancelRaw.trim().isNotEmpty
              ? _localizeCryptoApiMessage(_l10n, cancelRaw)
              : _l10n.cryptoOrderCancelled)
        : (cancelRaw.trim().isNotEmpty
              ? _localizeCryptoApiMessage(_l10n, cancelRaw)
              : _l10n.cryptoCancelOrderFailed);
    showTopRightFromSnackBar(
      context,
      SnackBar(
        content: Text(cancelSnack),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );

    if (success) {
      await _loadDetails();
    }
  }

  Widget _buildTradeSection() {
    final cp = _currentPrice.toStringAsFixed(6);
    final ab = _avgBuyPrice.toStringAsFixed(6);
    final String helperText;
    if (_avgBuyPrice > 0) {
      helperText = _ownedQuantity > 0
          ? _l10n.cryptoDirectTradeHelperWithAvgAndAll(cp, ab)
          : _l10n.cryptoDirectTradeHelperWithAvgOnly(cp, ab);
    } else {
      helperText = _ownedQuantity > 0
          ? _l10n.cryptoDirectTradeHelperPriceAndAll(cp)
          : _l10n.cryptoDirectTradeHelperPriceOnly(cp);
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.28),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _l10n.cryptoDirectTradeTitle,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _quantityController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: _l10n.cryptoLabelQuantity,
              helperText: helperText,
              helperStyle: const TextStyle(color: Colors.white54),
              labelStyle: const TextStyle(color: Colors.white70),
              filled: true,
              fillColor: Colors.white.withOpacity(0.08),
              suffixIcon: _ownedQuantity > 0
                  ? TextButton(
                      onPressed: _processing ? null : _fillDirectQuantityAll,
                      child: Text(
                        'ALL',
                        style: TextStyle(
                          color: Colors.amber.shade200,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    )
                  : null,
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white30),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.amber.shade300),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _processing
                      ? null
                      : () => _executeTrade(buy: true),
                  icon: const Icon(Icons.add_shopping_cart),
                  label: Text(_l10n.cryptoSideBuy),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _processing
                      ? null
                      : () => _executeTrade(buy: false),
                  icon: const Icon(Icons.sell),
                  label: Text(_l10n.cryptoSideSell),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionHistorySection() {
    final latestBuyPrice =
        (_historySummary['latestBuyPrice'] as num?)?.toDouble() ?? 0;
    final latestBuyAt = _historySummary['latestBuyAt']?.toString() ?? '';
    final totalBuySpent =
        (_historySummary['totalBuySpent'] as num?)?.toDouble() ?? 0;
    final totalSellValue =
        (_historySummary['totalSellValue'] as num?)?.toDouble() ?? 0;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.28),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _l10n.cryptoYourHistoryForSymbol(widget.symbol),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildInfoChip(
                label: _l10n.cryptoLabelAvgBuy,
                value: _avgBuyPrice > 0
                    ? '€${_avgBuyPrice.toStringAsFixed(6)}'
                    : '-',
                color: Colors.amber.shade200,
              ),
              _buildInfoChip(
                label: _l10n.cryptoLabelLastBuy,
                value: latestBuyPrice > 0
                    ? '€${latestBuyPrice.toStringAsFixed(6)}'
                    : '-',
                color: Colors.lightBlueAccent,
              ),
              _buildInfoChip(
                label: _l10n.cryptoLabelBuyVolume,
                value: '€${totalBuySpent.toStringAsFixed(2)}',
                color: Colors.greenAccent,
              ),
              _buildInfoChip(
                label: _l10n.cryptoLabelSellVolume,
                value: '€${totalSellValue.toStringAsFixed(2)}',
                color: Colors.redAccent,
              ),
            ],
          ),
          if (latestBuyAt.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              _l10n.cryptoLastBuyAt(_formatDateTime(latestBuyAt)),
              style: const TextStyle(color: Colors.white60, fontSize: 12),
            ),
          ],
          const SizedBox(height: 12),
          if (_detailsLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            )
          else if (_transactions.isEmpty)
            Text(
              _l10n.cryptoNoTradesForCoinYet,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _transactions.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final row = _transactions[index];
                final side = row['side']?.toString() ?? 'BUY';
                final quantity = (row['quantity'] as num?)?.toDouble() ?? 0;
                final price = (row['price'] as num?)?.toDouble() ?? 0;
                final totalValue = (row['totalValue'] as num?)?.toDouble() ?? 0;
                final realizedProfit =
                    (row['realizedProfit'] as num?)?.toDouble() ?? 0;
                final createdAt = row['createdAt']?.toString() ?? '';
                final isBuy = side == 'BUY';

                return Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: (isBuy ? Colors.greenAccent : Colors.redAccent)
                              .withOpacity(0.14),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isBuy ? Icons.south_west : Icons.north_east,
                          color: isBuy ? Colors.greenAccent : Colors.redAccent,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${isBuy ? _l10n.cryptoSideBuy : _l10n.cryptoSideSell} • ${quantity.toStringAsFixed(6)}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${_l10n.cryptoLabelPrice}: €${price.toStringAsFixed(6)} • ${_l10n.cryptoLabelTotal}: €${totalValue.toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              _formatDateTime(createdAt),
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (!isBuy)
                        Text(
                          '${realizedProfit >= 0 ? '+' : ''}€${realizedProfit.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: realizedProfit >= 0
                                ? Colors.greenAccent
                                : Colors.redAccent,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildOpenOrdersSection() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.28),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _l10n.cryptoOpenOrdersForSymbol(widget.symbol),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _l10n.cryptoOpenOrdersSectionHint,
            style: const TextStyle(color: Colors.white60, fontSize: 12),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedOrderType,
                  dropdownColor: const Color(0xFF1B2330),
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: _l10n.cryptoLabelOrderType,
                    labelStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.08),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white30),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.amber.shade300),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: 'LIMIT',
                      child: Text(_l10n.cryptoOrderTypeLimit),
                    ),
                    DropdownMenuItem(
                      value: 'STOP_LOSS',
                      child: Text(_l10n.cryptoOrderTypeStopLoss),
                    ),
                    DropdownMenuItem(
                      value: 'TAKE_PROFIT',
                      child: Text(_l10n.cryptoOrderTypeTakeProfit),
                    ),
                  ],
                  onChanged: _processing
                      ? null
                      : (value) {
                          if (value == null) {
                            return;
                          }
                          setState(() {
                            _selectedOrderType = value;
                            if (value != 'LIMIT') {
                              _selectedOrderSide = 'SELL';
                            }
                          });
                        },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedOrderSide,
                  dropdownColor: const Color(0xFF1B2330),
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: _l10n.cryptoLabelSide,
                    labelStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.08),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white30),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.amber.shade300),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: 'BUY',
                      child: Text(_l10n.cryptoSideBuy),
                    ),
                    DropdownMenuItem(
                      value: 'SELL',
                      child: Text(_l10n.cryptoSideSell),
                    ),
                  ],
                  onChanged: (_processing || _selectedOrderType != 'LIMIT')
                      ? null
                      : (value) {
                          if (value == null) {
                            return;
                          }
                          setState(() => _selectedOrderSide = value);
                        },
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _orderQuantityController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: _l10n.cryptoLabelOrderQuantity,
              helperText: _orderUsesOwnedPosition
                  ? _l10n.cryptoOrderQtyHelperOwned(
                      _ownedQuantity.toStringAsFixed(6),
                    )
                  : _l10n.cryptoOrderQtyHelperStandalone,
              helperStyle: const TextStyle(color: Colors.white54),
              labelStyle: const TextStyle(color: Colors.white70),
              filled: true,
              fillColor: Colors.white.withOpacity(0.08),
              suffixIcon: _orderUsesOwnedPosition && _ownedQuantity > 0
                  ? TextButton(
                      onPressed: _processing ? null : _fillOrderQuantityAll,
                      child: Text(
                        'ALL',
                        style: TextStyle(
                          color: Colors.amber.shade200,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    )
                  : null,
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white30),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.amber.shade300),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _targetPriceController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: _l10n.cryptoLabelTargetPrice,
              prefixText: '€ ',
              prefixStyle: const TextStyle(color: Colors.white70),
              labelStyle: const TextStyle(color: Colors.white70),
              filled: true,
              fillColor: Colors.white.withOpacity(0.08),
              helperText: _selectedOrderType == 'LIMIT'
                  ? _l10n.cryptoTargetPriceHelperLimit
                  : _selectedOrderType == 'STOP_LOSS'
                  ? _l10n.cryptoTargetPriceHelperStopLoss
                  : _l10n.cryptoTargetPriceHelperTakeProfit,
              helperStyle: const TextStyle(color: Colors.white54),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white30),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.amber.shade300),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _processing ? null : _placeOpenOrder,
              icon: const Icon(Icons.pending_actions),
              label: Text(_l10n.cryptoPlaceOpenOrder),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.amber.shade200,
                side: BorderSide(color: Colors.amber.shade300),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          const SizedBox(height: 12),
          if (_detailsLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            )
          else if (_openOrders.isEmpty)
            Text(
              _l10n.cryptoNoOpenOrdersYet,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _openOrders.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final order = _openOrders[index];
                final orderId = (order['id'] as num?)?.toInt() ?? 0;
                final orderType = order['orderType']?.toString() ?? 'LIMIT';
                final side = order['side']?.toString() ?? 'BUY';
                final quantity = (order['quantity'] as num?)?.toDouble() ?? 0;
                final targetPrice =
                    (order['targetPrice'] as num?)?.toDouble() ?? 0;

                return Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${_orderTypeLabel(orderType)} • ${_orderSideLabel(side)}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${_l10n.cryptoLabelQuantity}: ${quantity.toStringAsFixed(6)}',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              '${_l10n.cryptoLabelTargetPrice}: €${targetPrice.toStringAsFixed(6)}',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: (_processing || orderId <= 0)
                            ? null
                            : () => _cancelOpenOrder(orderId),
                        child: Text(_l10n.cryptoLabelCancel),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final windowHours = (_stats['windowHours'] as num?)?.toInt();
    final lastPrice =
        (_stats['lastPrice'] as num?)?.toDouble() ??
        (_points.isNotEmpty
            ? (_points.last['price'] as num?)?.toDouble() ?? 0
            : 0);
    final changePct = (_stats['changePct'] as num?)?.toDouble() ?? 0;

    return Dialog(
      backgroundColor: const Color(0xFF111827),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 820, maxHeight: 760),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _l10n.cryptoDetailsTitleWithSymbol(widget.symbol),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: Text(
                        _range.liveBanner(_l10n),
                        style: const TextStyle(
                          color: Colors.greenAccent,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close, color: Colors.white70),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildInfoChip(
                      label: _l10n.cryptoLabelCoin,
                      value: widget.coinName,
                      color: Colors.white,
                    ),
                    _buildInfoChip(
                      label: _l10n.cryptoLabelPrice,
                      value: '€${_currentPrice.toStringAsFixed(6)}',
                      color: Colors.amber.shade200,
                    ),
                    _buildInfoChip(
                      label: _l10n.cryptoLabelOwned,
                      value: _ownedQuantity.toStringAsFixed(6),
                      color: Colors.greenAccent,
                    ),
                    _buildInfoChip(
                      label: _l10n.cryptoLabelAvgBuy,
                      value: _avgBuyPrice > 0
                          ? '€${_avgBuyPrice.toStringAsFixed(6)}'
                          : '-',
                      color: Colors.amberAccent,
                    ),
                    _buildInfoChip(
                      label: _l10n.cryptoLabelOpenOrders,
                      value: _openOrders.length.toString(),
                      color: Colors.lightBlueAccent,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _ChartRange.values
                      .map((range) {
                        final selected = range == _range;
                        return ChoiceChip(
                          label: Text(range.shortLabel(_l10n)),
                          selected: selected,
                          onSelected: (_) => _changeRange(range),
                          selectedColor: Colors.amber.withOpacity(0.22),
                          backgroundColor: Colors.white.withOpacity(0.08),
                          labelStyle: TextStyle(
                            color: selected
                                ? Colors.amber.shade200
                                : Colors.white70,
                            fontWeight: selected
                                ? FontWeight.w700
                                : FontWeight.w500,
                            fontSize: 12,
                          ),
                          side: BorderSide(
                            color: selected
                                ? Colors.amber.shade300
                                : Colors.white24,
                          ),
                        );
                      })
                      .toList(growable: false),
                ),
                const SizedBox(height: 16),
                if (_loading)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 60),
                    child: Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                else if (_error != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 60),
                    child: Center(
                      child: Text(
                        _error!.isEmpty
                            ? _l10n.cryptoChartDataUnavailable
                            : _localizeCryptoApiMessage(_l10n, _error),
                        style: const TextStyle(
                          color: Colors.redAccent,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                else if (_points.length < 2)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 60),
                    child: Center(
                      child: Text(
                        _l10n.cryptoNotEnoughHistory,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  )
                else ...[
                  Container(
                    height: 260,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.28),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final maxWidth = constraints.maxWidth;
                        return MouseRegion(
                          onExit: (_) {
                            if (_hoverX != null) {
                              setState(() => _hoverX = null);
                            }
                          },
                          onHover: (event) {
                            final nextX = event.localPosition.dx.clamp(
                              0.0,
                              maxWidth,
                            );
                            if (_hoverX != nextX) {
                              setState(() => _hoverX = nextX);
                            }
                          },
                          child: CustomPaint(
                            painter: _SparklinePainter(
                              _points,
                              hoverX: _hoverX,
                            ),
                            child: const SizedBox.expand(),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        '€${lastPrice.toStringAsFixed(6)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${changePct >= 0 ? '+' : ''}${changePct.toStringAsFixed(2)}%',
                        style: TextStyle(
                          color: changePct >= 0
                              ? Colors.greenAccent
                              : Colors.redAccent,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        windowHours == null
                            ? _l10n.cryptoChartDataCaptionFullHistory(
                                _points.length,
                                _l10n.cryptoChartPointsWord,
                              )
                            : _l10n.cryptoChartDataCaptionHours(
                                _points.length,
                                _l10n.cryptoChartPointsWord,
                                '$windowHours${_l10n.cryptoChartHourAbbrev}',
                              ),
                        style: const TextStyle(
                          color: Colors.white60,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 14),
                _buildTradeSection(),
                const SizedBox(height: 12),
                _buildTransactionHistorySection(),
                const SizedBox(height: 12),
                _buildOpenOrdersSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip({
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white24),
      ),
      child: RichText(
        text: TextSpan(
          text: '$label: ',
          style: const TextStyle(color: Colors.white70, fontSize: 12),
          children: [
            TextSpan(
              text: value,
              style: TextStyle(color: color, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}

enum _ChartRange {
  hour(hours: 1, points: 60),
  fourHours(hours: 4, points: 96),
  eightHours(hours: 8, points: 120),
  day(hours: 24, points: 180),
  week(hours: 24 * 7, points: 240),
  month(hours: 24 * 30, points: 320),
  all(hours: 0, points: 360);

  const _ChartRange({required this.hours, required this.points});

  final int hours;
  final int points;
}

extension _ChartRangeL10n on _ChartRange {
  String shortLabel(AppLocalizations l10n) {
    switch (this) {
      case _ChartRange.hour:
        return l10n.cryptoChartRange1h;
      case _ChartRange.fourHours:
        return l10n.cryptoChartRange4h;
      case _ChartRange.eightHours:
        return l10n.cryptoChartRange8h;
      case _ChartRange.day:
        return l10n.cryptoChartRange24h;
      case _ChartRange.week:
        return l10n.cryptoChartRange7d;
      case _ChartRange.month:
        return l10n.cryptoChartRange30d;
      case _ChartRange.all:
        return l10n.cryptoChartRangeAll;
    }
  }

  String liveBanner(AppLocalizations l10n) {
    switch (this) {
      case _ChartRange.hour:
        return l10n.cryptoChartLive1h;
      case _ChartRange.fourHours:
        return l10n.cryptoChartLive4h;
      case _ChartRange.eightHours:
        return l10n.cryptoChartLive8h;
      case _ChartRange.day:
        return l10n.cryptoChartLive24h;
      case _ChartRange.week:
        return l10n.cryptoChartLive7d;
      case _ChartRange.month:
        return l10n.cryptoChartLive30d;
      case _ChartRange.all:
        return l10n.cryptoChartLiveAll;
    }
  }
}

class _SparklinePainter extends CustomPainter {
  _SparklinePainter(this.points, {this.hoverX});

  final List<Map<String, dynamic>> points;
  final double? hoverX;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;

    final prices = points
        .map((point) => (point['price'] as num?)?.toDouble() ?? 0)
        .toList(growable: false);

    final minPrice = prices.reduce(math.min);
    final maxPrice = prices.reduce(math.max);
    final range = (maxPrice - minPrice).abs() < 1e-9
        ? 1.0
        : (maxPrice - minPrice);

    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (var i = 1; i <= 3; i += 1) {
      final y = size.height * (i / 4);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final path = Path();
    for (var i = 0; i < prices.length; i += 1) {
      final x = (i / (prices.length - 1)) * size.width;
      final normalized = (prices[i] - minPrice) / range;
      final y = size.height - (normalized * size.height);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    final positive = prices.last >= prices.first;
    final lineColor = positive ? Colors.greenAccent : Colors.redAccent;

    final areaPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final areaPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [lineColor.withOpacity(0.35), lineColor.withOpacity(0.03)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    canvas.drawPath(areaPath, areaPaint);

    final linePaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(path, linePaint);

    if (hoverX != null) {
      final pointCount = prices.length;
      final rawIndex = ((hoverX! / size.width) * (pointCount - 1)).round();
      final index = rawIndex.clamp(0, pointCount - 1);
      final pointX = (index / (pointCount - 1)) * size.width;
      final normalized = (prices[index] - minPrice) / range;
      final pointY = size.height - (normalized * size.height);

      final crosshairPaint = Paint()
        ..color = Colors.white.withOpacity(0.55)
        ..strokeWidth = 1;
      canvas.drawLine(
        Offset(pointX, 0),
        Offset(pointX, size.height),
        crosshairPaint,
      );

      final pointPaint = Paint()..color = Colors.white;
      final pointStrokePaint = Paint()
        ..color = lineColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawCircle(Offset(pointX, pointY), 4.5, pointPaint);
      canvas.drawCircle(Offset(pointX, pointY), 4.5, pointStrokePaint);

      final priceLabel = 'EUR ${prices[index].toStringAsFixed(6)}';
      final textPainter = TextPainter(
        text: TextSpan(
          text: priceLabel,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      const horizontalPadding = 8.0;
      const verticalPadding = 6.0;
      final tooltipWidth = textPainter.width + (horizontalPadding * 2);
      final tooltipHeight = textPainter.height + (verticalPadding * 2);
      final tooltipLeft = math.min(
        math.max(0.0, pointX - (tooltipWidth / 2)),
        size.width - tooltipWidth,
      );
      final tooltipTop = pointY < 40
          ? math.min(size.height - tooltipHeight, pointY + 12)
          : math.max(0.0, pointY - tooltipHeight - 12);

      final tooltipRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(tooltipLeft, tooltipTop, tooltipWidth, tooltipHeight),
        const Radius.circular(8),
      );
      final tooltipPaint = Paint()..color = const Color(0xEE0F172A);
      canvas.drawRRect(tooltipRect, tooltipPaint);
      canvas.drawRRect(
        tooltipRect,
        Paint()
          ..color = Colors.white.withOpacity(0.18)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
      );

      textPainter.paint(
        canvas,
        Offset(tooltipLeft + horizontalPadding, tooltipTop + verticalPadding),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter oldDelegate) {
    return oldDelegate.points != points || oldDelegate.hoverX != hoverX;
  }
}
