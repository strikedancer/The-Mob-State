import 'dart:convert';

import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/player_tool_market_listing.dart';
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
  List<String> _kinds = const [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  String _kindLabel(String kind, AppLocalizations l10n) {
    switch (kind) {
      case 'player_tool':
        return l10n.bmHubSellKindTool;
      case 'drug_lot':
        return l10n.bmHubSellKindDrug;
      case 'crypto_lot':
        return l10n.bmHubSellKindCrypto;
      case 'trade_good_lot':
        return l10n.bmHubSellKindTrade;
      case 'event_item':
        return l10n.bmHubSellKindEvent;
      case 'vehicle':
        return l10n.marketTeaserKindVehicle;
      default:
        return '';
    }
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
      final kinds = <String>[];
      void addKind(String kind) {
        if (kind.isEmpty || kinds.contains(kind)) return;
        kinds.add(kind);
      }

      for (final row in items.take(8)) {
        if (row is! Map) continue;
        try {
          final listing = PlayerToolMarketListing.fromJson(
            Map<String, dynamic>.from(row),
          );
          addKind(listing.kind);
        } catch (_) {
          final kind = row['kind']?.toString() ?? '';
          addKind(kind);
        }
      }
      if (vehicles.isNotEmpty) {
        addKind('vehicle');
      }

      if (!mounted) return;
      setState(() {
        _count = vehicles.length + items.length;
        _kinds = kinds.take(3).toList();
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

  String _subtitle(AppLocalizations l10n) {
    if (_loading) return '…';
    if (_count == 0) return l10n.marketTeaserEmpty;
    final countText = l10n.marketTeaserActiveCount(_count);
    final kindLabels = _kinds
        .map((kind) => _kindLabel(kind, l10n))
        .where((label) => label.isNotEmpty)
        .toList();
    if (kindLabels.isEmpty) return countText;
    return '$countText · ${kindLabels.join(', ')}';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: ListTile(
        leading: const Icon(Icons.storefront),
        title: Text(l10n.marketTeaserTitle),
        subtitle: Text(_subtitle(l10n)),
        trailing: TextButton(
          onPressed: _open,
          child: Text(l10n.marketTeaserOpen),
        ),
        onTap: _open,
      ),
    );
  }
}
