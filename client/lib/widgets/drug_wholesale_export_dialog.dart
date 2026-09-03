import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/drug_models.dart';
import '../services/drug_service.dart';
import '../utils/drug_localizations.dart';

class DrugWholesaleExportDialog extends StatefulWidget {
  final String drugType;
  final String quality;
  final int quantity;
  final String drugName;
  final String scope;
  final DrugService service;

  const DrugWholesaleExportDialog({
    super.key,
    required this.drugType,
    required this.quality,
    required this.quantity,
    required this.drugName,
    required this.service,
    this.scope = 'personal',
  });

  @override
  State<DrugWholesaleExportDialog> createState() =>
      _DrugWholesaleExportDialogState();
}

class _DrugWholesaleExportDialogState extends State<DrugWholesaleExportDialog> {
  late final TextEditingController _controller;
  String? _destinationCountry;
  List<DrugWholesaleDestination> _destinations = [];
  Map<String, dynamic>? _quote;
  bool _loading = true;

  bool get _isCrew => widget.scope == 'crew';

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: '${widget.quantity}');
    _loadQuote();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int get _quantity => int.tryParse(_controller.text.trim()) ?? 0;

  Future<void> _loadQuote() async {
    setState(() => _loading = true);
    final qty = _quantity > 0 ? _quantity : widget.quantity;
    final result = await widget.service.quoteWholesaleExport(
      drugType: widget.drugType,
      quality: widget.quality,
      quantity: qty,
      destinationCountry: _destinationCountry,
      scope: widget.scope,
    );
    if (!mounted) return;
    final dests = (result['destinations'] as List<dynamic>? ?? [])
        .map((row) => DrugWholesaleDestination.fromJson(row as Map<String, dynamic>))
        .toList();
    setState(() {
      _quote = result;
      if (dests.isNotEmpty) {
        _destinations = dests;
        _destinationCountry ??= dests.first.id;
      }
      _loading = false;
    });
  }

  String _money(num value) {
    return value.round().toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final isNl = Localizations.localeOf(context).languageCode == 'nl';
    final quoteOk = _quote?['success'] == true;
    final canAfford = _quote?['canAfford'] != false;
    final seizurePct = (((_quote?['seizureChance'] as num?) ?? 0) * 100)
        .toStringAsFixed(1);
    final eta = '${_quote?['etaMinutes'] ?? '—'}';
    final confirmEnabled =
        quoteOk && canAfford && _quantity > 0 && _destinationCountry != null;

    return AlertDialog(
      title: Text(t.drugsExportDialogTitle(widget.drugName)),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_destinations.isNotEmpty) ...[
                Text(t.drugsExportDestLabel),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  value: _destinations.any((d) => d.id == _destinationCountry)
                      ? _destinationCountry
                      : _destinations.first.id,
                  items: _destinations
                      .map(
                        (d) => DropdownMenuItem(
                          value: d.id,
                          child: Text(
                            '${isNl ? d.labelNl : d.labelEn} · €${d.streetUnit}/g',
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() => _destinationCountry = value);
                    _loadQuote();
                  },
                ),
                const SizedBox(height: 12),
              ],
              TextField(
                controller: _controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: t.drugsQuantityGramsField,
                  border: const OutlineInputBorder(),
                  suffixText: '/ ${widget.quantity}',
                ),
                onSubmitted: (_) => _loadQuote(),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _loading ? null : _loadQuote,
                  child: Text(t.retry),
                ),
              ),
              if (_loading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: LinearProgressIndicator(),
                ),
              if (_quote != null && !quoteOk)
                Text(
                  localizeDrugClientMessage(
                    t,
                    _quote!['message']?.toString() ?? t.drugsExportFailed,
                  ),
                  style: const TextStyle(color: Colors.orangeAccent),
                ),
              if (quoteOk) ...[
                Text(t.drugsExportQuoteStreet(_money(_quote!['destStreetUnit'] ?? 0))),
                Text(t.drugsExportQuoteB2b(_money(_quote!['wholesaleUnit'] ?? 0))),
                if (_isCrew) ...[
                  Text(
                    t.drugsExportCrewPayout(
                      _money(_quote!['crewPayout'] ?? 0),
                      _money(_quote!['runnerPayout'] ?? 0),
                    ),
                  ),
                  Text(t.drugsExportCrewFeeHint),
                ] else
                  Text(t.drugsExportPayout(_money(_quote!['payout'] ?? 0))),
                Text(t.drugsExportFee(_money(_quote!['shippingFee'] ?? 0))),
                Text(t.drugsExportEta(eta)),
                Text(t.drugsExportSeizure(seizurePct)),
                Text(
                  t.drugsExportHeat(
                    '${_quote!['drugHeat'] ?? 0}',
                    '${_quote!['fbiHeat'] ?? 0}',
                  ),
                ),
                if (_quote!['harborBonus'] == true)
                  Text(
                    t.drugsExportHarbor,
                    style: const TextStyle(color: Colors.lightGreenAccent),
                  ),
                if (!canAfford)
                  Text(
                    _isCrew
                        ? t.drugsExportCannotAffordCrew
                        : t.drugsExportCannotAfford,
                    style: const TextStyle(color: Colors.redAccent),
                  ),
                Text(t.drugsExportMinHint('${_quote!['minGrams'] ?? 250}')),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(t.cancel),
        ),
        ElevatedButton(
          onPressed: confirmEnabled
              ? () => Navigator.pop(context, {
                    'quantity': _quantity,
                    'destinationCountry': _destinationCountry,
                  })
              : null,
          child: Text(t.drugsExportConfirm),
        ),
      ],
    );
  }
}
