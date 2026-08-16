import 'dart:convert';

import 'package:flutter/material.dart';

import '../screens/black_market_screen.dart';
import '../services/auth_service.dart';

class MarketTeaserTile extends StatefulWidget {
  final VoidCallback? onOpenMarket;

  const MarketTeaserTile({super.key, this.onOpenMarket});

  @override
  State<MarketTeaserTile> createState() => _MarketTeaserTileState();
}

class _MarketTeaserTileState extends State<MarketTeaserTile> {
  int _count = 0;
  List<String> _newest = const [];
  bool _loading = true;

  bool get _isNl => Localizations.localeOf(context).languageCode == 'nl';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final response = await AuthService().apiClient.get('/market/unified');
      if (response.statusCode != 200) {
        if (mounted) setState(() => _loading = false);
        return;
      }
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final vehicles = (data['listings'] as List?) ?? const [];
      final items = (data['itemListings'] as List?) ?? const [];
      final newest = items.take(8).map((row) {
        if (row is! Map) return '';
        return (row['title'] ??
                row['itemLabel'] ??
                row['kind'] ??
                row['goodType'] ??
                'listing')
            .toString();
      }).where((label) => label.isNotEmpty).toList();
      if (!mounted) return;
      setState(() {
        _count = vehicles.length + items.length;
        _newest = newest;
        _loading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _open() {
    if (widget.onOpenMarket != null) {
      widget.onOpenMarket!();
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const BlackMarketScreen(initialTabIndex: 1),
      ),
    ).then((_) => _load());
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.storefront),
        title: Text(_isNl ? 'Markt' : 'Market'),
        subtitle: Text(
          _loading
              ? '…'
              : _count == 0
                  ? (_isNl
                      ? 'Zet een tool of drugs online'
                      : 'List a tool or drugs for sale')
                  : (_isNl
                      ? '$_count actieve listings${_newest.isEmpty ? '' : ' · ${_newest.take(3).join(', ')}'}'
                      : '$_count active listings${_newest.isEmpty ? '' : ' · ${_newest.take(3).join(', ')}'}'),
        ),
        trailing: TextButton(
          onPressed: _open,
          child: Text(_isNl ? 'Open' : 'Open'),
        ),
        onTap: _open,
      ),
    );
  }
}
