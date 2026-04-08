import 'package:flutter/material.dart';
import '../models/drug_models.dart';
import '../services/drug_service.dart';
import '../providers/auth_provider.dart';
import 'package:provider/provider.dart';
import '../utils/top_right_notification.dart';

class DrugInventoryScreen extends StatefulWidget {
  const DrugInventoryScreen({super.key});

  @override
  State<DrugInventoryScreen> createState() => _DrugInventoryScreenState();
}

class _DrugInventoryScreenState extends State<DrugInventoryScreen> {
  final DrugService _drugService = DrugService();
  List<DrugInventory> _inventory = [];
  List<DrugDefinition> _drugDefinitions = [];
  Map<String, DrugMarketPrice> _marketPrices = {};
  bool _isLoading = true;
  String? _currentCountry;

  bool get _isNl => Localizations.localeOf(context).languageCode == 'nl';
  String _tr(String nl, String en) => _isNl ? nl : en;

  String _backgroundAsset(double width) {
    return 'assets/images/backgrounds/drug_inventory_bg.png';
  }

  BoxDecoration _glassPanelDecoration({Color borderColor = Colors.white24}) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: borderColor),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.black.withOpacity(0.58),
          const Color(0xFF111111).withOpacity(0.72),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final inventory = await _drugService.getDrugInventory();
      final drugs = await _drugService.getDrugCatalog();
      Map<String, DrugMarketPrice> prices = {};
      try {
        prices = await _drugService.getMarketPrices();
      } catch (_) {}

      setState(() {
        _inventory = inventory;
        _drugDefinitions = drugs;
        _marketPrices = prices;
        _currentCountry =
            authProvider.currentPlayer?.currentCountry ?? 'netherlands';
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(_tr('Fout bij laden: $e', 'Error while loading: $e')),
          ),
        );
      }
    }
  }

  DrugDefinition? _getDrugDefinition(String drugType) {
    try {
      return _drugDefinitions.firstWhere((d) => d.id == drugType);
    } catch (e) {
      return null;
    }
  }

  int _getCurrentPrice(String drugType) {
    final drug = _getDrugDefinition(drugType);
    if (drug == null) return 0;
    return drug.getPriceForCountry(_currentCountry ?? 'netherlands');
  }

  Color _parseQualityColor(String hex) {
    return Color(int.parse(hex.replaceFirst('#', '0xff')));
  }

  Future<void> _cutDrugs(DrugInventory drug) async {
    if (drug.quality == 'D') {
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(
            _tr(
              'Kwaliteit D kan niet verder gesneden worden.',
              'Quality D cannot be cut further.',
            ),
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    final qtyToShow = drug.quantity;
    final result = await showDialog<Map<String, dynamic>?>(
      context: context,
      builder: (ctx) =>
          _CutDrugsDialog(drug: drug, isNl: _isNl, maxQuantity: qtyToShow),
    );
    if (result == null) return;
    final quantity = result['quantity'] as int;
    final cutResult = await _drugService.cutDrugs(
      drug.drugType,
      drug.quality,
      quantity,
    );
    if (mounted) {
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(
            cutResult['message'] ?? _tr('Snijden mislukt', 'Cutting failed'),
          ),
          backgroundColor: cutResult['success'] == true
              ? Colors.green
              : Colors.red,
        ),
      );
      if (cutResult['success'] == true) _loadData();
    }
  }

  Future<void> _sellDrugs(DrugInventory drug) async {
    final quantity = await _showSellDialog(drug);
    if (quantity == null || quantity <= 0) return;

    final result = await _drugService.sellDrugs(
      drug.drugType,
      quantity,
      quality: drug.quality,
    );

    if (mounted) {
      if (result['success'] == true) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(result['message']),
            backgroundColor: Colors.green,
          ),
        );

        _loadData();
      } else {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(
              result['message'] ?? _tr('Verkoop mislukt', 'Sale failed'),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<int?> _showSellDialog(DrugInventory drug) async {
    final controller = TextEditingController(text: '1');
    final baseCountryPrice = _getCurrentPrice(drug.drugType);
    final currentPrice = drug.effectivePrice > 0
        ? ((_getCurrentPrice(drug.drugType) * drug.qualityMultiplier).round())
        : baseCountryPrice;
    final drugDef = _getDrugDefinition(drug.drugType);

    return showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${_tr('Verkoop', 'Sell')} ${drug.drugName}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${_tr('Beschikbaar', 'Available')}: ${drug.quantity} ${_tr('gram', 'grams')}',
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: _parseQualityColor(drug.qualityColor).withOpacity(0.16),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                '${_tr('Kwaliteit', 'Quality')}: ${drug.qualityLabel}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _parseQualityColor(drug.qualityColor),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${_tr('Huidige prijs', 'Current price')}: €$currentPrice ${_tr('per gram', 'per gram')}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            if (drugDef != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[600]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _tr('Prijzen per land:', 'Prices by country:'),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    ...drugDef.countryPricing.entries
                        .take(5)
                        .map(
                          (entry) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Text(
                              '${_getCountryName(entry.key)}: €${(entry.value * drug.qualityMultiplier).round()}',
                              style: TextStyle(
                                fontSize: 13,
                                color: entry.key == _currentCountry
                                    ? Colors.lightGreenAccent
                                    : Colors.white,
                                fontWeight: entry.key == _currentCountry
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: _tr('Hoeveelheid (gram)', 'Quantity (grams)'),
                border: const OutlineInputBorder(),
                suffixText: '/ ${drug.quantity}',
              ),
            ),
            const SizedBox(height: 8),
            ValueListenableBuilder(
              valueListenable: controller,
              builder: (context, TextEditingValue value, _) {
                final qty = int.tryParse(value.text) ?? 0;
                final total = currentPrice * qty;
                return Text(
                  '${_tr('Totaal', 'Total')}: €${total.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(_tr('Annuleren', 'Cancel')),
          ),
          ElevatedButton(
            onPressed: () {
              final qty = int.tryParse(controller.text);
              if (qty != null && qty > 0 && qty <= drug.quantity) {
                Navigator.pop(context, qty);
              } else {
                showTopRightFromSnackBar(
                  context,
                  SnackBar(
                    content: Text(
                      _tr('Ongeldige hoeveelheid', 'Invalid quantity'),
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: Text(_tr('Verkoop', 'Sell')),
          ),
        ],
      ),
    );
  }

  String _getCountryName(String countryId) {
    final names = <String, ({String nl, String en})>{
      'netherlands': (nl: 'Nederland', en: 'Netherlands'),
      'belgium': (nl: 'België', en: 'Belgium'),
      'germany': (nl: 'Duitsland', en: 'Germany'),
      'spain': (nl: 'Spanje', en: 'Spain'),
      'france': (nl: 'Frankrijk', en: 'France'),
      'uk': (nl: 'VK', en: 'UK'),
      'united_kingdom': (nl: 'VK', en: 'UK'),
      'italy': (nl: 'Italië', en: 'Italy'),
      'usa': (nl: 'USA', en: 'USA'),
      'mexico': (nl: 'Mexico', en: 'Mexico'),
      'colombia': (nl: 'Colombia', en: 'Colombia'),
      'brazil': (nl: 'Brazilië', en: 'Brazil'),
      'argentina': (nl: 'Argentinië', en: 'Argentina'),
      'japan': (nl: 'Japan', en: 'Japan'),
      'china': (nl: 'China', en: 'China'),
      'russia': (nl: 'Rusland', en: 'Russia'),
      'turkey': (nl: 'Turkije', en: 'Turkey'),
      'united_arab_emirates': (nl: 'VAE', en: 'UAE'),
      'south_africa': (nl: 'Zuid-Afrika', en: 'South Africa'),
      'australia': (nl: 'Australië', en: 'Australia'),
      'switzerland': (nl: 'Zwitserland', en: 'Switzerland'),
    };
    final row = names[countryId];
    if (row == null) return countryId;
    return _isNl ? row.nl : row.en;
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isMobile = width < 700;
        final padding = isMobile ? 12.0 : 20.0;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xCC111111),
            title: Text(_tr('Drug Voorraad', 'Drug Inventory')),
            actions: [
              if (!_isLoading && _inventory.isNotEmpty)
                _KpiChip(
                  value: '${_inventory.fold(0, (s, i) => s + i.quantity)}g',
                  label: _tr('voorraad', 'inventory'),
                  icon: Icons.inventory_2,
                  color: const Color(0xFFC16CFF),
                ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    '€${authProvider.currentPlayer?.money.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.') ?? '0'}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  _backgroundAsset(width),
                  fit: BoxFit.cover,
                  alignment: isMobile
                      ? Alignment.topCenter
                      : Alignment.centerRight,
                  errorBuilder: (context, error, stackTrace) => Image.asset(
                    'assets/images/backgrounds/crime_background.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.34),
                        Colors.black.withOpacity(0.62),
                        Colors.black.withOpacity(0.82),
                      ],
                    ),
                  ),
                ),
              ),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SafeArea(
                      child: RefreshIndicator(
                        onRefresh: _loadData,
                        child: _inventory.isEmpty
                            ? Center(
                                child: Container(
                                  margin: EdgeInsets.all(padding),
                                  padding: const EdgeInsets.all(24),
                                  decoration: _glassPanelDecoration(
                                    borderColor: const Color(0x55F2B94B),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.inventory_2_outlined,
                                        size: 80,
                                        color: Colors.grey[300],
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        _tr(
                                          'Geen drugs in voorraad',
                                          'No drugs in inventory',
                                        ),
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        _tr(
                                          'Start productie om drugs te maken',
                                          'Start production to create drugs',
                                        ),
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white.withOpacity(0.68),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : ListView(
                                padding: EdgeInsets.all(padding),
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(isMobile ? 16 : 20),
                                    decoration: _glassPanelDecoration(
                                      borderColor: const Color(0x55F2B94B),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _tr(
                                            'Voorraad & distributie',
                                            'Inventory & distribution',
                                          ),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 24,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          _tr(
                                            'Verkoop je drugs per kwaliteit en benut prijsverschillen tussen landen.',
                                            'Sell drugs by quality and use price differences between countries.',
                                          ),
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(
                                              0.74,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 14),
                                        Container(
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Colors.blue[700]!,
                                                Colors.blue[500]!,
                                              ],
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Icons.location_on,
                                                color: Colors.white,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                '${_tr('Huidige locatie', 'Current location')}: ${_getCountryName(_currentCountry ?? 'netherlands')}',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 16),

                                  LayoutBuilder(
                                    builder: (context, gridConstraints) {
                                      final gridWidth =
                                          gridConstraints.maxWidth;
                                      final columns = gridWidth >= 1200
                                          ? 4
                                          : (gridWidth >= 860
                                                ? 3
                                                : (gridWidth >= 560 ? 2 : 1));

                                      return GridView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: _inventory.length,
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: columns,
                                              mainAxisExtent: columns == 1
                                                  ? 260
                                                  : 280,
                                              crossAxisSpacing: 12,
                                              mainAxisSpacing: 12,
                                            ),
                                        itemBuilder: (context, index) {
                                          final drug = _inventory[index];
                                          final currentPrice =
                                              (_getCurrentPrice(drug.drugType) *
                                                      drug.qualityMultiplier)
                                                  .round();
                                          final totalValue =
                                              currentPrice * drug.quantity;

                                          return Card(
                                            color: Colors.black.withOpacity(
                                              0.58,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                              side: const BorderSide(
                                                color: Color(0x33FFFFFF),
                                              ),
                                            ),
                                            margin: EdgeInsets.zero,
                                            child: Padding(
                                              padding: const EdgeInsets.all(14),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      CircleAvatar(
                                                        radius: 20,
                                                        backgroundColor:
                                                            Colors.grey[200],
                                                        child: Image.asset(
                                                          drug.getImagePath(),
                                                          width: 26,
                                                          height: 26,
                                                          errorBuilder:
                                                              (
                                                                context,
                                                                error,
                                                                stackTrace,
                                                              ) => const Icon(
                                                                Icons.science,
                                                              ),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 10),
                                                      Expanded(
                                                        child: Text(
                                                          drug.drugName,
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style:
                                                              const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Text(
                                                    '${_tr('Voorraad', 'Inventory')}: ${drug.quantity} ${_tr('gram', 'grams')}',
                                                  ),
                                                  const SizedBox(height: 6),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 8,
                                                          vertical: 3,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: _parseQualityColor(
                                                        drug.qualityColor,
                                                      ).withOpacity(0.16),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            999,
                                                          ),
                                                    ),
                                                    child: Text(
                                                      '${_tr('Kwaliteit', 'Quality')}: ${drug.qualityLabel}',
                                                      style: TextStyle(
                                                        color:
                                                            _parseQualityColor(
                                                              drug.qualityColor,
                                                            ),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Text(
                                                    '${_tr('Huidige waarde', 'Current value')}: €${totalValue.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                                                    style: const TextStyle(
                                                      color: Colors.green,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  if (_marketPrices.containsKey(
                                                    drug.drugType,
                                                  )) ...[
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      '${_tr('Markt', 'Market')}: ${_marketPrices[drug.drugType]!.trendEmoji} ${(_marketPrices[drug.drugType]!.multiplier * 100).round()}%',
                                                      style: TextStyle(
                                                        fontSize: 11,
                                                        color: Colors.white
                                                            .withOpacity(0.68),
                                                      ),
                                                    ),
                                                  ],
                                                  const Spacer(),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: ElevatedButton.icon(
                                                          onPressed: () =>
                                                              _sellDrugs(drug),
                                                          icon: const Icon(
                                                            Icons.sell,
                                                            size: 15,
                                                          ),
                                                          label: Text(
                                                            _tr(
                                                              'Verkoop',
                                                              'Sell',
                                                            ),
                                                            style:
                                                                const TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                          ),
                                                          style: ElevatedButton.styleFrom(
                                                            backgroundColor:
                                                                Colors.green,
                                                            foregroundColor:
                                                                Colors.white,
                                                            padding:
                                                                const EdgeInsets.symmetric(
                                                                  horizontal:
                                                                      10,
                                                                  vertical: 8,
                                                                ),
                                                            minimumSize:
                                                                const Size(
                                                                  0,
                                                                  36,
                                                                ),
                                                            tapTargetSize:
                                                                MaterialTapTargetSize
                                                                    .shrinkWrap,
                                                          ),
                                                        ),
                                                      ),
                                                      if (drug.quality !=
                                                          'D') ...[
                                                        const SizedBox(
                                                          width: 8,
                                                        ),
                                                        Expanded(
                                                          child: ElevatedButton.icon(
                                                            onPressed: () =>
                                                                _cutDrugs(drug),
                                                            icon: const Icon(
                                                              Icons.content_cut,
                                                              size: 15,
                                                            ),
                                                            label: Text(
                                                              _tr(
                                                                'Snijden',
                                                                'Cut',
                                                              ),
                                                              style: const TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                            style: ElevatedButton.styleFrom(
                                                              backgroundColor:
                                                                  Colors
                                                                      .deepOrange,
                                                              foregroundColor:
                                                                  Colors.white,
                                                              padding:
                                                                  const EdgeInsets.symmetric(
                                                                    horizontal:
                                                                        10,
                                                                    vertical: 8,
                                                                  ),
                                                              minimumSize:
                                                                  const Size(
                                                                    0,
                                                                    36,
                                                                  ),
                                                              tapTargetSize:
                                                                  MaterialTapTargetSize
                                                                      .shrinkWrap,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }
}

class _KpiChip extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color color;

  const _KpiChip({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: color.withOpacity(0.14),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: color.withOpacity(0.38)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 13),
            const SizedBox(width: 5),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    height: 1.1,
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(
                    color: color.withOpacity(0.7),
                    fontSize: 9,
                    height: 1.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CutDrugsDialog extends StatefulWidget {
  final DrugInventory drug;
  final bool isNl;
  final int maxQuantity;

  const _CutDrugsDialog({
    required this.drug,
    required this.isNl,
    required this.maxQuantity,
  });

  @override
  State<_CutDrugsDialog> createState() => _CutDrugsDialogState();
}

class _CutDrugsDialogState extends State<_CutDrugsDialog> {
  late TextEditingController _controller;

  String _tr(String nl, String en) => widget.isNl ? nl : en;

  String _nextQuality(String q) {
    const map = {'S': 'A', 'A': 'B', 'B': 'C', 'C': 'D'};
    return map[q] ?? q;
  }

  double _bonusMultiplier(String q) {
    const map = {'S': 0.60, 'A': 0.50, 'B': 0.40, 'C': 0.30};
    return map[q] ?? 0.0;
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.maxQuantity.toString());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bonus = _bonusMultiplier(widget.drug.quality);
    final nextQ = _nextQuality(widget.drug.quality);

    return AlertDialog(
      title: Text(_tr('Drugs snijden', 'Cut Drugs')),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.18),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange.withOpacity(0.6)),
            ),
            child: Text(
              _tr(
                'Kwaliteit ${widget.drug.quality} → $nextQ: +${(bonus * 100).round()}% meer eenheden',
                'Quality ${widget.drug.quality} → $nextQ: +${(bonus * 100).round()}% more units',
              ),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: _tr('Hoeveelheid (gram)', 'Quantity (grams)'),
              border: const OutlineInputBorder(),
              suffixText: '/ ${widget.maxQuantity}',
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 8),
          ValueListenableBuilder(
            valueListenable: _controller,
            builder: (context, TextEditingValue val, _) {
              final qty = int.tryParse(val.text) ?? 0;
              final result = (qty * (1 + bonus)).round();
              return Text(
                '${_tr('Resultaat', 'Result')}: $qty g $nextQ → $result g ${_nextQuality(nextQ) == nextQ ? '' : nextQ}',
                style: const TextStyle(color: Colors.white70),
              );
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(_tr('Annuleren', 'Cancel')),
        ),
        ElevatedButton(
          onPressed: () {
            final qty = int.tryParse(_controller.text);
            if (qty != null && qty > 0 && qty <= widget.maxQuantity) {
              Navigator.pop(context, {'quantity': qty});
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepOrange,
            foregroundColor: Colors.white,
          ),
          child: Text(_tr('Snijden', 'Cut')),
        ),
      ],
    );
  }
}
