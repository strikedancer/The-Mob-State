import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import '../models/drug_models.dart';
import '../services/drug_service.dart';
import '../providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'drug_facility_screen.dart';
import '../utils/top_right_notification.dart';

class DrugProductionScreen extends StatefulWidget {
  const DrugProductionScreen({super.key});

  @override
  State<DrugProductionScreen> createState() => _DrugProductionScreenState();
}

class _DrugProductionScreenState extends State<DrugProductionScreen>
    with TickerProviderStateMixin {
  static const _legendPrefKey = 'drug_production_incident_legend_visible';
  final DrugService _drugService = DrugService();
  List<DrugDefinition> _drugs = [];
  List<MaterialDefinition> _materialDefinitions = [];
  List<PlayerMaterial> _playerMaterials = [];
  List<DrugProduction> _activeProductions = [];
  List<DrugFacilityInfo> _facilities = [];
  bool _isLoading = true;
  Timer? _productionTimer;
  DrugStats? _stats;
  bool _togglingAutoCollect = false;
  bool _showIncidentLegend = true;

  bool get _isNl => Localizations.localeOf(context).languageCode == 'nl';
  String _tr(String nl, String en) => _isNl ? nl : en;

  String _backgroundAsset(double width) {
    return 'assets/images/backgrounds/drug_production_bg.png';
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
      boxShadow: const [
        BoxShadow(
          color: Color(0x44000000),
          blurRadius: 24,
          offset: Offset(0, 12),
        ),
      ],
    );
  }

  Widget _buildLegendItem(IconData icon, Color color, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadLegendPreference();
    _loadData();
    _startProductionTimer();
  }

  Future<void> _loadLegendPreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final value = prefs.getBool(_legendPrefKey);
      if (!mounted || value == null) return;
      setState(() {
        _showIncidentLegend = value;
      });
    } catch (_) {
      // Keep default value when preferences are unavailable.
    }
  }

  Future<void> _setLegendPreference(bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_legendPrefKey, value);
    } catch (_) {
      // Non-blocking preference save.
    }
  }

  @override
  void dispose() {
    _productionTimer?.cancel();
    super.dispose();
  }

  Future<void> _openFacilities() async {
    if (kIsWeb) {
      if (!mounted) return;
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(
            _tr(
              'Gebruik de terugknop en open daarna Faciliteiten in Drugs Omgeving.',
              'Use the back button and then open Facilities in Drug Environment.',
            ),
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const DrugFacilityScreen()));
    _loadData();
  }

  void _startProductionTimer() {
    _productionTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_activeProductions.isNotEmpty) {
        _loadActiveProductions();
      }
    });
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final results = await Future.wait([
        _drugService.getDrugCatalog(),
        _drugService.getMaterials(),
        _drugService.getPlayerMaterials(),
        _drugService.getActiveProductions(),
        _drugService.getMyFacilities(),
        _drugService.getDrugStats(),
      ]);

      setState(() {
        _drugs = results[0] as List<DrugDefinition>;
        _materialDefinitions = results[1] as List<MaterialDefinition>;
        _playerMaterials = results[2] as List<PlayerMaterial>;
        _activeProductions = results[3] as List<DrugProduction>;
        _facilities = results[4] as List<DrugFacilityInfo>;
        _stats = results[5] as DrugStats?;
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

  String? _getFacilityTypeForDrug(String drugId) {
    const greenhouseDrugs = {'white_widow', 'amnesia_haze', 'og_kush', 'hash'};
    const labDrugs = {'cocaine', 'speed', 'heroin', 'xtc'};
    const crackKitchenDrugs = {'crystal_meth', 'fentanyl'};
    const darkwebDrugs = {'lsd'};
    const mushroomDrugs = {'magic_mushrooms'};
    if (greenhouseDrugs.contains(drugId)) return 'greenhouse';
    if (labDrugs.contains(drugId)) return 'drug_lab';
    if (crackKitchenDrugs.contains(drugId)) return 'crack_kitchen';
    if (darkwebDrugs.contains(drugId)) return 'darkweb_storefront';
    if (mushroomDrugs.contains(drugId)) return 'mushroom_farm';
    return null;
  }

  DrugFacilityInfo? _getFacilityForDrug(String drugId) {
    final facilityType = _getFacilityTypeForDrug(drugId);
    if (facilityType == null) return null;
    for (final facility in _facilities) {
      if (facility.facilityType == facilityType) return facility;
    }
    return null;
  }

  int _getAdjustedProductionMinutes(
    DrugDefinition drug,
    DrugFacilityInfo? facility,
  ) {
    final speedBonus = facility?.speedBonus ?? 0.0;
    final multiplier = (1 - speedBonus).clamp(0.05, 1.0);
    return (drug.productionTime * multiplier).round();
  }

  String _formatMinutes(int minutes) {
    final hourWord = _isNl ? 'uur' : 'hr';
    if (minutes < 60) return '$minutes min';
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    if (mins == 0) return '$hours $hourWord';
    return '$hours $hourWord $mins min';
  }

  String _getAdjustedTimeFormatted(
    DrugDefinition drug,
    DrugFacilityInfo? facility,
  ) {
    return _formatMinutes(_getAdjustedProductionMinutes(drug, facility));
  }

  String _getAdjustedYieldFormatted(
    DrugDefinition drug,
    DrugFacilityInfo? facility,
  ) {
    final yieldBonus = facility?.yieldBonus ?? 0.0;
    final minYield = (drug.yieldMin * (1 + yieldBonus)).round();
    final maxYield = (drug.yieldMax * (1 + yieldBonus)).round();
    return '$minYield-$maxYield';
  }

  String _getFacilityDisplayName(String facilityType) {
    switch (facilityType) {
      case 'greenhouse':
        return _tr('Kas', 'Greenhouse');
      case 'crack_kitchen':
        return _tr('Crack Kitchen', 'Crack Kitchen');
      case 'darkweb_storefront':
        return _tr('Darkweb Storefront', 'Darkweb Storefront');
      case 'mushroom_farm':
        return _tr('Paddenstoelenkweekhuis', 'Mushroom Farm');
      default:
        return _tr('Drugslab', 'Drug Lab');
    }
  }

  Future<void> _loadActiveProductions() async {
    try {
      final productions = await _drugService.getActiveProductions();
      if (mounted) {
        setState(() {
          _activeProductions = productions;
        });
      }
    } catch (e) {
      // Silent fail for background updates
    }
  }

  String _getMaterialName(String materialId) {
    // Look up the Dutch name from material definitions
    final materialDef = _materialDefinitions.firstWhere(
      (m) => m.id == materialId,
      orElse: () => MaterialDefinition(
        id: materialId,
        name: '',
        description: '',
        price: 0,
        category: '',
      ),
    );

    // Return Dutch name if found, otherwise format the materialId
    if (materialDef.name.isNotEmpty && !materialDef.name.contains('_')) {
      return materialDef.name;
    }

    // Fallback: Convert "grow_lamp" to "Grow Lamp"
    return materialId
        .split('_')
        .map(
          (word) => word.isEmpty
              ? ''
              : '${word[0].toUpperCase()}${word.substring(1)}',
        )
        .join(' ');
  }

  bool _hasRequiredMaterials(DrugDefinition drug) {
    for (final entry in drug.materials.entries) {
      final materialId = entry.key;
      final required = entry.value;

      final playerMaterial = _playerMaterials.firstWhere(
        (m) => m.materialId == materialId,
        orElse: () => PlayerMaterial(
          id: 0,
          materialId: materialId,
          name: '',
          description: '',
          quantity: 0,
          price: 0,
        ),
      );

      if (playerMaterial.quantity < required) {
        return false;
      }
    }
    return true;
  }

  String _getMissingMaterials(DrugDefinition drug) {
    List<String> missing = [];

    for (final entry in drug.materials.entries) {
      final materialId = entry.key;
      final required = entry.value;

      final playerMaterial = _playerMaterials.firstWhere(
        (m) => m.materialId == materialId,
        orElse: () => PlayerMaterial(
          id: 0,
          materialId: materialId,
          name: '',
          description: '',
          quantity: 0,
          price: 0,
        ),
      );

      if (playerMaterial.quantity < required) {
        final shortage = required - playerMaterial.quantity;
        final displayName = _getMaterialName(materialId);
        missing.add('$displayName: $shortage');
      }
    }

    return missing.isEmpty
        ? ''
        : '${_tr('Tekort', 'Missing')}: ${missing.join(', ')}';
  }

  Future<void> _startProduction(DrugDefinition drug) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (authProvider.currentPlayer!.rank < drug.requiredRank) {
      if (mounted) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(
              _tr(
                'Je hebt rank ${drug.requiredRank} nodig',
                'You need rank ${drug.requiredRank}',
              ),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    if (!_hasRequiredMaterials(drug)) {
      if (mounted) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(_getMissingMaterials(drug)),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          Localizations.localeOf(context).languageCode == 'nl'
              ? 'Weet je het zeker?'
              : 'Are you sure?',
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Localizations.localeOf(context).languageCode == 'nl'
                  ? 'Start ${drug.displayName} productie?'
                  : 'Start ${drug.displayName} production?',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '${_tr('Tijd', 'Time')}: ${_getAdjustedTimeFormatted(drug, _getFacilityForDrug(drug.id))}',
            ),
            Text(
              '${_tr('Opbrengst', 'Yield')}: ${_getAdjustedYieldFormatted(drug, _getFacilityForDrug(drug.id))} ${_tr('gram', 'grams')}',
            ),
            const SizedBox(height: 10),
            Text(
              _tr(
                'Productie kan soms tegenvallen. Betere upgrades verlagen het risico, hoge drug heat verhoogt het risico.',
                'Production can sometimes suffer setbacks. Better upgrades lower the risk, high drug heat increases it.',
              ),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[700],
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _tr('Benodigde materialen:', 'Required materials:'),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            ...drug.materials.entries.map((entry) {
              final displayName = _getMaterialName(entry.key);
              return Text('${entry.value}x $displayName');
            }),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(_tr('Annuleren', 'Cancel')),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: Text(_tr('Start Productie', 'Start Production')),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final result = await _drugService.startProduction(drug.id, null);

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
              result['message'] ??
                  _tr('Productie mislukt', 'Production failed'),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _collectProduction(DrugProduction production) async {
    final result = await _drugService.collectProduction(
      production.id.toString(),
    );

    if (mounted) {
      if (result['success'] == true) {
        _applyCollectedProductionLocally(production);
        unawaited(_syncProductionContextAfterCollect());

        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(result['message']),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(
              result['message'] ?? _tr('Collecteren mislukt', 'Collect failed'),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _applyCollectedProductionLocally(DrugProduction production) {
    setState(() {
      _activeProductions = _activeProductions
          .where((p) => p.id != production.id)
          .toList();

      final facilityId = production.facilityId;
      if (facilityId != null) {
        _facilities = _facilities.map((facility) {
          if (facility.id != facilityId) return facility;

          final nextActive = facility.activeProductions > 0
              ? facility.activeProductions - 1
              : 0;

          return DrugFacilityInfo(
            id: facility.id,
            facilityType: facility.facilityType,
            displayName: facility.displayName,
            slots: facility.slots,
            activeProductions: nextActive,
            purchasedAt: facility.purchasedAt,
            upgrades: facility.upgrades,
            qualityBonus: facility.qualityBonus,
            yieldBonus: facility.yieldBonus,
            speedBonus: facility.speedBonus,
            nextSlotCost: facility.nextSlotCost,
            isMaxSlots: facility.isMaxSlots,
          );
        }).toList();
      }
    });
  }

  Future<void> _syncProductionContextAfterCollect() async {
    try {
      final results = await Future.wait([
        _drugService.getActiveProductions(),
        _drugService.getMyFacilities(),
        _drugService.getDrugStats(),
      ]);

      if (!mounted) return;

      setState(() {
        _activeProductions = results[0] as List<DrugProduction>;
        _facilities = results[1] as List<DrugFacilityInfo>;
        _stats = results[2] as DrugStats?;
      });
    } catch (_) {
      // Local optimistic state already applied; ignore sync failures.
    }
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
            title: Text(_tr('Drug Productie', 'Drug Production')),
            actions: [
              if (!_isLoading) ..._buildProductionKpis(),
              if (_stats?.isVip == true)
                Tooltip(
                  message: _stats?.autoCollectEnabled == true
                      ? _tr('Auto-ophalen aan (VIP)', 'Auto-collect on (VIP)')
                      : _tr('Auto-ophalen uit (VIP)', 'Auto-collect off (VIP)'),
                  child: IconButton(
                    icon: Icon(
                      Icons.autorenew,
                      color: _stats?.autoCollectEnabled == true
                          ? Colors.greenAccent
                          : Colors.grey,
                    ),
                    onPressed: _togglingAutoCollect ? null : _toggleAutoCollect,
                  ),
                ),
              IconButton(
                icon: const Icon(Icons.factory_outlined),
                onPressed: _openFacilities,
              ),
              IconButton(icon: const Icon(Icons.refresh), onPressed: _loadData),
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
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.all(padding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(isMobile ? 16 : 20),
                                decoration: _glassPanelDecoration(
                                  borderColor: const Color(0x5535C46A),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Productielijn',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      _tr(
                                        'Start batches, bewaak slotcapaciteit en stuur je kwaliteit via kas- en labupgrades.',
                                        'Start batches, monitor slot capacity and tune quality via greenhouse and lab upgrades.',
                                      ),
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.74),
                                        fontSize: isMobile ? 13 : 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 18),
                              // Active Productions
                              if (_activeProductions.isNotEmpty) ...[
                                Text(
                                  _tr(
                                    'Actieve Producties',
                                    'Active Productions',
                                  ),
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                GestureDetector(
                                  onTap: () {
                                    final nextValue = !_showIncidentLegend;
                                    setState(
                                      () => _showIncidentLegend = nextValue,
                                    );
                                    _setLegendPreference(nextValue);
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 10,
                                    ),
                                    margin: const EdgeInsets.only(bottom: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.42),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: const Color(0x33FFFFFF),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          _showIncidentLegend
                                              ? Icons.expand_less
                                              : Icons.expand_more,
                                          color: Colors.white70,
                                          size: 18,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            _tr(
                                              'Incidenten legenda',
                                              'Incident legend',
                                            ),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          _showIncidentLegend
                                              ? _tr('Verberg', 'Hide')
                                              : _tr('Toon', 'Show'),
                                          style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                if (_showIncidentLegend)
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 10,
                                    ),
                                    margin: const EdgeInsets.only(bottom: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.42),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: const Color(0x33FFFFFF),
                                      ),
                                    ),
                                    child: Wrap(
                                      spacing: 10,
                                      runSpacing: 8,
                                      children: [
                                        _buildLegendItem(
                                          Icons.schedule,
                                          Colors.amberAccent,
                                          _tr('Vertraging', 'Delay'),
                                        ),
                                        _buildLegendItem(
                                          Icons.bug_report_outlined,
                                          const Color(0xFF81C784),
                                          _tr('Besmetting', 'Contamination'),
                                        ),
                                        _buildLegendItem(
                                          Icons.inventory_2_outlined,
                                          Colors.deepOrangeAccent,
                                          _tr('Opbrengstverlies', 'Yield loss'),
                                        ),
                                        _buildLegendItem(
                                          Icons.science_outlined,
                                          const Color(0xFFD1C4E9),
                                          _tr('Instabiliteit', 'Instability'),
                                        ),
                                        _buildLegendItem(
                                          Icons.warning_amber_rounded,
                                          Colors.redAccent,
                                          _tr('Combinatie', 'Combined issue'),
                                        ),
                                      ],
                                    ),
                                  ),
                                LayoutBuilder(
                                  builder: (context, sectionConstraints) {
                                    final maxWidth =
                                        sectionConstraints.maxWidth;
                                    final cardWidth = maxWidth < 760
                                        ? maxWidth
                                        : (maxWidth >= 1200
                                              ? (maxWidth - 24) / 3
                                              : (maxWidth - 12) / 2);

                                    return Wrap(
                                      spacing: 12,
                                      runSpacing: 12,
                                      children: _activeProductions.map((
                                        production,
                                      ) {
                                        return SizedBox(
                                          width: cardWidth,
                                          child: Card(
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
                                                        radius: 21,
                                                        backgroundColor:
                                                            Colors.grey[200],
                                                        child: Image.asset(
                                                          production
                                                              .getImagePath(),
                                                          width: 26,
                                                          height: 26,
                                                          errorBuilder:
                                                              (
                                                                context,
                                                                error,
                                                                stackTrace,
                                                              ) => const Icon(
                                                                Icons.science,
                                                                size: 22,
                                                              ),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 10),
                                                      Expanded(
                                                        child: Text(
                                                          production.drugName,
                                                          style:
                                                              const TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Text(
                                                    '${_tr('Opbrengst', 'Yield')}: ${production.quantity} ${_tr('gram', 'grams')}',
                                                  ),
                                                  const SizedBox(height: 6),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 8,
                                                          vertical: 3,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: Color(
                                                        int.parse(
                                                          production
                                                              .qualityColor
                                                              .replaceFirst(
                                                                '#',
                                                                '0xff',
                                                              ),
                                                        ),
                                                      ).withOpacity(0.18),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            999,
                                                          ),
                                                    ),
                                                    child: Text(
                                                      production.qualityLabel,
                                                      style: TextStyle(
                                                        color: Color(
                                                          int.parse(
                                                            production
                                                                .qualityColor
                                                                .replaceFirst(
                                                                  '#',
                                                                  '0xff',
                                                                ),
                                                          ),
                                                        ),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  if (production.incidentNote !=
                                                          null &&
                                                      production
                                                          .incidentNote!
                                                          .isNotEmpty) ...[
                                                    const SizedBox(height: 10),
                                                    Container(
                                                      width: double.infinity,
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 10,
                                                            vertical: 8,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color:
                                                            production
                                                                    .incidentType ==
                                                                'contamination'
                                                            ? const Color(
                                                                0xFF2E7D32,
                                                              ).withOpacity(
                                                                0.20,
                                                              )
                                                            : production
                                                                      .incidentType ==
                                                                  'yield_loss'
                                                            ? Colors.deepOrange
                                                                  .withOpacity(
                                                                    0.18,
                                                                  )
                                                            : production
                                                                      .incidentType ==
                                                                  'instability'
                                                            ? Colors.purple
                                                                  .withOpacity(
                                                                    0.18,
                                                                  )
                                                            : production
                                                                      .incidentType ==
                                                                  'mixed'
                                                            ? Colors.red
                                                                  .withOpacity(
                                                                    0.17,
                                                                  )
                                                            : Colors.amber
                                                                  .withOpacity(
                                                                    0.14,
                                                                  ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              10,
                                                            ),
                                                        border: Border.all(
                                                          color:
                                                              production
                                                                      .incidentType ==
                                                                  'contamination'
                                                              ? const Color(
                                                                  0xFF43A047,
                                                                ).withOpacity(
                                                                  0.55,
                                                                )
                                                              : production
                                                                        .incidentType ==
                                                                    'yield_loss'
                                                              ? Colors
                                                                    .deepOrange
                                                                    .withOpacity(
                                                                      0.55,
                                                                    )
                                                              : production
                                                                        .incidentType ==
                                                                    'instability'
                                                              ? Colors.purple
                                                                    .withOpacity(
                                                                      0.55,
                                                                    )
                                                              : production
                                                                        .incidentType ==
                                                                    'mixed'
                                                              ? Colors.red
                                                                    .withOpacity(
                                                                      0.55,
                                                                    )
                                                              : Colors.amber
                                                                    .withOpacity(
                                                                      0.4,
                                                                    ),
                                                        ),
                                                      ),
                                                      child: Text(
                                                        production
                                                            .incidentNote!,
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                  const SizedBox(height: 10),
                                                  if (production.isReady)
                                                    SizedBox(
                                                      width: double.infinity,
                                                      child: ElevatedButton(
                                                        onPressed: () =>
                                                            _collectProduction(
                                                              production,
                                                            ),
                                                        style:
                                                            ElevatedButton.styleFrom(
                                                              backgroundColor:
                                                                  Colors.green,
                                                              foregroundColor:
                                                                  Colors.white,
                                                            ),
                                                        child: Text(
                                                          _tr(
                                                            'Ophalen',
                                                            'Collect',
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  else ...[
                                                    Row(
                                                      children: [
                                                        const Icon(
                                                          Icons
                                                              .hourglass_bottom,
                                                          color: Colors.orange,
                                                          size: 20,
                                                        ),
                                                        const SizedBox(
                                                          width: 6,
                                                        ),
                                                        Text(
                                                          production
                                                              .getTimeRemainingFormatted(),
                                                          style:
                                                              const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .orange,
                                                                fontSize: 15,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 8),
                                                    LinearProgressIndicator(
                                                      value: production
                                                          .getProgress(),
                                                      backgroundColor:
                                                          Colors.grey[300],
                                                      valueColor:
                                                          const AlwaysStoppedAnimation<
                                                            Color
                                                          >(Colors.green),
                                                    ),
                                                  ],
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    );
                                  },
                                ),
                                const SizedBox(height: 24),
                              ],

                              // Available Drugs
                              Text(
                                _tr('Beschikbare Drugs', 'Available Drugs'),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 12),

                              if (_drugs.isEmpty)
                                Center(
                                  child: Text(
                                    _tr(
                                      'Geen drugs beschikbaar',
                                      'No drugs available',
                                    ),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                )
                              else
                                LayoutBuilder(
                                  builder: (context, sectionConstraints) {
                                    final maxWidth =
                                        sectionConstraints.maxWidth;
                                    final cardWidth = maxWidth < 760
                                        ? maxWidth
                                        : (maxWidth >= 1200
                                              ? (maxWidth - 24) / 3
                                              : (maxWidth - 12) / 2);

                                    return Wrap(
                                      spacing: 12,
                                      runSpacing: 12,
                                      children: _drugs.map((drug) {
                                        final hasRank =
                                            authProvider.currentPlayer!.rank >=
                                            drug.requiredRank;
                                        final hasMaterials =
                                            _hasRequiredMaterials(drug);
                                        final facilityType =
                                            _getFacilityTypeForDrug(drug.id);
                                        final facility = _getFacilityForDrug(
                                          drug.id,
                                        );
                                        final adjustedTime =
                                            _getAdjustedTimeFormatted(
                                              drug,
                                              facility,
                                            );
                                        final adjustedYield =
                                            _getAdjustedYieldFormatted(
                                              drug,
                                              facility,
                                            );
                                        final hasFacility =
                                            facilityType == null ||
                                            facility != null;
                                        final hasFreeSlot =
                                            facility == null ||
                                            facility.activeProductions <
                                                facility.slots;
                                        final canProduce =
                                            hasRank &&
                                            hasMaterials &&
                                            hasFacility &&
                                            hasFreeSlot;

                                        return SizedBox(
                                          width: cardWidth,
                                          child: Card(
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
                                                        radius: 21,
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
                                                          drug.displayName,
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
                                                  const SizedBox(height: 8),
                                                  Text(
                                                    _isNl
                                                        ? drug.description
                                                        : drug.descriptionEn,
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      color: Colors.white
                                                          .withOpacity(0.85),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 6),
                                                  Text(
                                                    '${_tr('Tijd', 'Time')}: $adjustedTime | ${_tr('Opbrengst', 'Yield')}: ${adjustedYield}g',
                                                    style: TextStyle(
                                                      color: Colors.grey[300],
                                                    ),
                                                  ),
                                                  if (facilityType != null) ...[
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      hasFacility
                                                          ? '${_getFacilityDisplayName(facilityType)}: ${facility!.activeProductions}/${facility.slots} ${_tr('plekken gebruikt', 'slots used')}'
                                                          : '${_getFacilityDisplayName(facilityType)} ${_tr('vereist', 'required')}',
                                                      style: TextStyle(
                                                        color: hasFacility
                                                            ? Colors
                                                                  .lightBlueAccent
                                                            : Colors.orange,
                                                      ),
                                                    ),
                                                  ],
                                                  const SizedBox(height: 8),
                                                  Wrap(
                                                    spacing: 6,
                                                    runSpacing: 6,
                                                    children: drug.materials.entries.map((
                                                      entry,
                                                    ) {
                                                      final material =
                                                          _playerMaterials.firstWhere(
                                                            (m) =>
                                                                m.materialId ==
                                                                entry.key,
                                                            orElse: () =>
                                                                PlayerMaterial(
                                                                  id: 0,
                                                                  materialId:
                                                                      entry.key,
                                                                  name:
                                                                      entry.key,
                                                                  description:
                                                                      '',
                                                                  quantity: 0,
                                                                  price: 0,
                                                                ),
                                                          );
                                                      final hasEnough =
                                                          material.quantity >=
                                                          entry.value;
                                                      return Container(
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              horizontal: 8,
                                                              vertical: 4,
                                                            ),
                                                        decoration: BoxDecoration(
                                                          color:
                                                              (hasEnough
                                                                      ? Colors
                                                                            .green
                                                                      : Colors
                                                                            .red)
                                                                  .withOpacity(
                                                                    0.14,
                                                                  ),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                999,
                                                              ),
                                                          border: Border.all(
                                                            color:
                                                                (hasEnough
                                                                        ? Colors
                                                                              .green
                                                                        : Colors
                                                                              .red)
                                                                    .withOpacity(
                                                                      0.35,
                                                                    ),
                                                          ),
                                                        ),
                                                        child: Text(
                                                          '${_getMaterialName(entry.key)} ${material.quantity}/${entry.value}',
                                                          style: TextStyle(
                                                            fontSize: 11,
                                                            color: hasEnough
                                                                ? Colors
                                                                      .lightGreenAccent
                                                                : Colors
                                                                      .orangeAccent,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      );
                                                    }).toList(),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  if (!hasRank)
                                                    Text(
                                                      _tr(
                                                        'Rank ${drug.requiredRank} vereist',
                                                        'Rank ${drug.requiredRank} required',
                                                      ),
                                                      style: const TextStyle(
                                                        color: Colors.redAccent,
                                                      ),
                                                    ),
                                                  if (hasFacility &&
                                                      !hasFreeSlot)
                                                    Text(
                                                      _tr(
                                                        'Geen vrije productieslot beschikbaar',
                                                        'No free production slot available',
                                                      ),
                                                      style: const TextStyle(
                                                        color:
                                                            Colors.orangeAccent,
                                                      ),
                                                    ),
                                                  if (!hasMaterials)
                                                    Text(
                                                      _getMissingMaterials(
                                                        drug,
                                                      ),
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                        color:
                                                            Colors.orangeAccent,
                                                      ),
                                                    ),
                                                  if (facilityType != null &&
                                                      !hasFacility) ...[
                                                    const SizedBox(height: 8),
                                                    SizedBox(
                                                      width: double.infinity,
                                                      child: OutlinedButton.icon(
                                                        onPressed:
                                                            _openFacilities,
                                                        icon: const Icon(
                                                          Icons
                                                              .factory_outlined,
                                                          size: 16,
                                                        ),
                                                        label: Text(
                                                          _tr(
                                                            'Open faciliteiten',
                                                            'Open facilities',
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                  const SizedBox(height: 8),
                                                  SizedBox(
                                                    width: double.infinity,
                                                    child: ElevatedButton(
                                                      onPressed: canProduce
                                                          ? () =>
                                                                _startProduction(
                                                                  drug,
                                                                )
                                                          : null,
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor:
                                                            Colors.green,
                                                        foregroundColor:
                                                            Colors.white,
                                                        disabledBackgroundColor:
                                                            Colors.white24,
                                                        disabledForegroundColor:
                                                            Colors.white54,
                                                      ),
                                                      child: Text(
                                                        _tr(
                                                          'Start productie',
                                                          'Start production',
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    );
                                  },
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _toggleAutoCollect() async {
    setState(() => _togglingAutoCollect = true);
    try {
      final result = await _drugService.toggleAutoCollect();
      if (mounted) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(
              result['message'] ??
                  _tr('Auto-ophalen bijgewerkt', 'Auto-collect updated'),
            ),
            backgroundColor: result['success'] == true
                ? Colors.green
                : Colors.red,
          ),
        );
        _loadData();
      }
    } catch (_) {
      setState(() => _togglingAutoCollect = false);
    }
  }

  List<Widget> _buildProductionKpis() {
    final readyCount = _activeProductions.where((p) => p.isReady).length;
    return [
      _KpiChip(
        value: '${_activeProductions.length}',
        label: _tr('actief', 'active'),
        icon: Icons.timelapse,
        color: const Color(0xFF35C46A),
      ),
      if (readyCount > 0)
        _KpiChip(
          value: '$readyCount',
          label: _tr('klaar', 'ready'),
          icon: Icons.check_circle_outline,
          color: Colors.amber,
        ),
    ];
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
