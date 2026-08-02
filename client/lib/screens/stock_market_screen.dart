import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../services/stock_market_service.dart';
import '../utils/top_right_notification.dart';

class StockMarketScreen extends StatefulWidget {
  const StockMarketScreen({super.key});

  @override
  State<StockMarketScreen> createState() => _StockMarketScreenState();
}

class _StockMarketScreenState extends State<StockMarketScreen> {
  final _service = StockMarketService();
  final _qtyController = TextEditingController(text: '1');
  bool _loading = true;
  bool _busy = false;
  String? _loadError;
  Map<String, dynamic> _market = {};

  AppLocalizations get _l10n => AppLocalizations.of(context)!;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _qtyController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _loadError = null;
    });
    try {
      final market = await _service.getMarket();
      if (!mounted) return;
      if (market['success'] == true) {
        setState(() {
          _loading = false;
          _market = market;
          _loadError = null;
        });
      } else {
        setState(() {
          _loading = false;
          _market = {};
          _loadError = _stockError(market['event']?.toString());
        });
      }
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _market = {};
        _loadError = _l10n.stockMarketLoadError;
      });
    }
  }

  Future<void> _trade(String symbol, String side) async {
    final qty = int.tryParse(_qtyController.text.trim()) ?? 0;
    if (qty <= 0) return;
    setState(() => _busy = true);
    final result = await _service.trade(symbol: symbol, side: side, quantity: qty);
    if (!mounted) return;
    setState(() => _busy = false);
    if (result['success'] == true) {
      setState(() => _market = result);
      showTopRightFromSnackBar(
        context,
        SnackBar(content: Text(_l10n.stockTradeSuccess), backgroundColor: Colors.green),
      );
    } else {
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(_stockError(result['event']?.toString())),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _stockError(String? event) {
    switch (event) {
      case 'error.insufficient_balance':
        return _l10n.stockErrorInsufficientBalance;
      case 'stock.insufficient_shares':
        return _l10n.stockErrorInsufficientShares;
      case 'stock.position_limit':
        return _l10n.stockErrorPositionLimit;
      case 'stock.disabled':
        return _l10n.stockErrorDisabled;
      default:
        return event?.isNotEmpty == true ? event! : _l10n.stockErrorUnknown;
    }
  }

  String _money(int value) {
    return value.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+$)'),
      (m) => '${m[1]}.',
    );
  }

  int _openPositions(List<dynamic> assets) {
    var count = 0;
    for (final raw in assets) {
      if (raw is Map && ((raw['holdingQuantity'] as num?)?.toInt() ?? 0) > 0) {
        count += 1;
      }
    }
    return count;
  }

  @override
  Widget build(BuildContext context) {
    final assets = (_market['assets'] as List<dynamic>?) ?? const [];
    final bankBalance = (_market['bankBalance'] as num?)?.toInt() ?? 0;
    final portfolioValue = (_market['portfolioValue'] as num?)?.toInt() ?? 0;
    final isNl = Localizations.localeOf(context).languageCode == 'nl';
    final openPositions = _openPositions(assets);

    return Scaffold(
      appBar: AppBar(
        title: Text(_l10n.stockMarketTitle),
        actions: [
          IconButton(onPressed: _busy || _loading ? null : _load, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _loadError != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.cloud_off, size: 48, color: Colors.grey.shade500),
                        const SizedBox(height: 12),
                        Text(
                          _loadError!,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey.shade300, fontSize: 15),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: _load,
                          icon: const Icon(Icons.refresh),
                          label: Text(_l10n.stockMarketRetry),
                        ),
                      ],
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      Text(
                        _l10n.stockMarketHint,
                        style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                      ),
                      const SizedBox(height: 14),
                      Card(
                        color: Colors.grey.shade900,
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _l10n.stockCashAvailable(_money(bankBalance)),
                                style: const TextStyle(
                                  color: Color(0xFFD4AF37),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '${_l10n.stockPortfolioValue}: €${_money(portfolioValue)}',
                                style: const TextStyle(color: Colors.white70),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _l10n.stockPositionsOpen(openPositions),
                                style: TextStyle(color: Colors.grey.shade400, fontSize: 12.5),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      TextField(
                        controller: _qtyController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: _l10n.stockQuantity,
                          labelStyle: TextStyle(color: Colors.grey.shade300),
                          filled: true,
                          fillColor: Colors.black54,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 16),
                      if (assets.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 32),
                          child: Column(
                            children: [
                              Icon(Icons.show_chart, size: 40, color: Colors.grey.shade600),
                              const SizedBox(height: 10),
                              Text(
                                _l10n.stockMarketEmpty,
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.grey.shade400),
                              ),
                              const SizedBox(height: 12),
                              TextButton(
                                onPressed: _load,
                                child: Text(_l10n.stockMarketRetry),
                              ),
                            ],
                          ),
                        )
                      else
                        for (final raw in assets)
                          if (raw is Map)
                            Card(
                              color: Colors.grey.shade900,
                              margin: const EdgeInsets.only(bottom: 10),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            '${raw['symbol']} · ${isNl ? raw['nameNl'] : raw['nameEn']}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          '${(raw['changePercent'] as num?)?.toStringAsFixed(1) ?? '0'}%',
                                          style: TextStyle(
                                            color: ((raw['changePercent'] as num?) ?? 0) >= 0
                                                ? Colors.green.shade300
                                                : Colors.red.shade300,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${_l10n.stockPrice}: €${(raw['price'] as num?)?.toStringAsFixed(2) ?? '-'}',
                                      style: TextStyle(color: Colors.grey.shade300),
                                    ),
                                    Text(
                                      '${_l10n.stockHolding}: ${(raw['holdingQuantity'] as num?)?.toInt() ?? 0}'
                                      ' · ${_l10n.stockValue}: €${_money((raw['marketValue'] as num?)?.toInt() ?? 0)}',
                                      style: TextStyle(color: Colors.grey.shade400, fontSize: 12.5),
                                    ),
                                    const SizedBox(height: 8),
                                    Wrap(
                                      spacing: 8,
                                      children: [
                                        ElevatedButton(
                                          onPressed: _busy
                                              ? null
                                              : () => _trade(raw['symbol'].toString(), 'BUY'),
                                          child: Text(_l10n.stockBuy),
                                        ),
                                        OutlinedButton(
                                          onPressed: _busy
                                              ? null
                                              : () => _trade(raw['symbol'].toString(), 'SELL'),
                                          child: Text(_l10n.stockSell),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
    );
  }
}
