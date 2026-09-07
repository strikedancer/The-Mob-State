import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../services/nightclub_service.dart';
import '../utils/drug_localizations.dart';

class NightclubPlayerSupplyDialog extends StatefulWidget {
  final String drugType;
  final String quality;
  final int quantity;
  final String drugName;
  final NightclubService service;

  const NightclubPlayerSupplyDialog({
    super.key,
    required this.drugType,
    required this.quality,
    required this.quantity,
    required this.drugName,
    required this.service,
  });

  @override
  State<NightclubPlayerSupplyDialog> createState() =>
      _NightclubPlayerSupplyDialogState();
}

class _NightclubPlayerSupplyDialogState
    extends State<NightclubPlayerSupplyDialog> {
  late final TextEditingController _controller;
  List<Map<String, dynamic>> _venues = [];
  int? _venueId;
  Map<String, dynamic>? _quote;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: '${widget.quantity}');
    _loadVenues();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int get _quantity => int.tryParse(_controller.text.trim()) ?? 0;

  Future<void> _loadVenues() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final result = await widget.service.listPlayerSupplyVenues();
    if (!mounted) return;
    if (result['success'] != true) {
      setState(() {
        _loading = false;
        _error = (result['message'] as String?) ?? '';
        _venues = [];
      });
      return;
    }
    final venues = (result['venues'] as List<dynamic>? ?? [])
        .whereType<Map>()
        .map((row) => Map<String, dynamic>.from(row))
        .toList();
    setState(() {
      _venues = venues;
      _venueId = venues.isEmpty ? null : (venues.first['venueId'] as num).toInt();
      _loading = venues.isEmpty;
    });
    if (_venueId != null) {
      await _loadQuote();
    } else {
      setState(() => _loading = false);
    }
  }

  Future<void> _loadQuote() async {
    final venueId = _venueId;
    if (venueId == null) return;
    setState(() => _loading = true);
    final qty = _quantity > 0 ? _quantity : widget.quantity;
    final result = await widget.service.quotePlayerSupply(
      venueId: venueId,
      drugType: widget.drugType,
      quality: widget.quality,
      quantity: qty,
    );
    if (!mounted) return;
    setState(() {
      _quote = result;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final quoteOk = _quote?['success'] == true;
    return AlertDialog(
      title: Text(l10n.nightclubPlayerSupplySellTitle),
      content: SizedBox(
        width: 360,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.nightclubPlayerSupplySellHint(widget.drugName)),
            const SizedBox(height: 12),
            if (_loading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_venues.isEmpty)
              Text(
                (_error != null && _error!.isNotEmpty)
                    ? localizeDrugClientMessage(l10n, _error!)
                    : l10n.nightclubPlayerSupplyNoneOpen,
              )
            else ...[
              DropdownButtonFormField<int>(
                value: _venueId,
                items: _venues
                    .map(
                      (venue) => DropdownMenuItem<int>(
                        value: (venue['venueId'] as num).toInt(),
                        child: Text('${venue['ownerName']}'),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() => _venueId = value);
                  _loadQuote();
                },
                decoration: InputDecoration(
                  labelText: l10n.nightclubPlayerSupplyClubLabel,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: l10n.nightclubPlayerSupplyGramsLabel,
                ),
                onSubmitted: (_) => _loadQuote(),
              ),
              TextButton(
                onPressed: _loadQuote,
                child: Text(l10n.nightclubPlayerSupplyRefreshQuote),
              ),
              if (quoteOk)
                Text(
                  l10n.nightclubPlayerSupplyQuote(
                    '${_quote!['unitPrice']}',
                    '${_quote!['totalPrice']}',
                    '${_quote!['ownerName']}',
                  ),
                )
              else if (_quote?['message'] != null)
                Text(
                  localizeDrugClientMessage(
                    l10n,
                    _quote!['message'].toString(),
                  ),
                ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          onPressed: quoteOk && _venueId != null
              ? () => Navigator.pop(context, {
                    'venueId': _venueId,
                    'quantity': _quantity,
                  })
              : null,
          child: Text(l10n.nightclubPlayerSupplyConfirm),
        ),
      ],
    );
  }
}
