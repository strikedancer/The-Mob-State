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
    setState(() => _loading = true);
    final market = await _service.getMarket();
    if (!mounted) return;
    setState(() {
      _loading = false;
      _market = market['success'] == true ? market : {};
    });
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
    return '€${value.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (m) => '${m[1]}.')}';
  }

  @override
  Widget build(BuildContext context) {
    final assets = (_market['assets'] as List<dynamic>?) ?? const [];
    final bankBalance = (_market['bankBalance'] as num?)?.toInt() ?? 0;
    final portfolioValue = (_market['portfolioValue'] as num?)?.toInt() ?? 0;
    final isNl = Localizations.localeOf(context).languageCode == 'nl';

    return Scaffold(
      appBar: AppBar(
        title: Text(_l10n.stockMarketTitle),
        actions: [
          IconButton(onPressed: _busy ? null : _load, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text(_l10n.stockMarketHint, style: TextStyle(color: Colors.grey[700])),
                  const SizedBox(height: 12),
                  Text('${_l10n.stockBankBalance}: ${_money(bankBalance)}'),
                  Text('${_l10n.stockPortfolioValue}: ${_money(portfolioValue)}'),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _qtyController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: _l10n.stockQuantity,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  for (final raw in assets)
                    if (raw is Map)
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${raw['symbol']} · ${isNl ? raw['nameNl'] : raw['nameEn']}',
                                style: const TextStyle(fontWeight: FontWeight.w700),
                              ),
                              Text(
                                '${_l10n.stockPrice}: €${(raw['price'] as num?)?.toStringAsFixed(2) ?? '-'}'
                                ' (${(raw['changePercent'] as num?)?.toStringAsFixed(1) ?? '0'}%)',
                              ),
                              Text(
                                '${_l10n.stockHolding}: ${(raw['holdingQuantity'] as num?)?.toInt() ?? 0}'
                                ' · ${_l10n.stockValue}: ${_money((raw['marketValue'] as num?)?.toInt() ?? 0)}',
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
