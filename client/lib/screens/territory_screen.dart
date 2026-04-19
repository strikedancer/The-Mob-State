import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_svg/flutter_svg.dart';

import '../services/territory_service.dart';
import '../utils/top_right_notification.dart';

// ---------------------------------------------------------------------------
// TerritoryScreen — Responsive crew territory map (NL-first)
// Layout: desktop = split (map | side panel), tablet = stacked collapsible,
//         mobile  = map card + action bottom sheet.
// ---------------------------------------------------------------------------

class TerritoryScreen extends StatefulWidget {
  const TerritoryScreen({super.key});

  @override
  State<TerritoryScreen> createState() => _TerritoryScreenState();
}

class _TerritoryScreenState extends State<TerritoryScreen> with SingleTickerProviderStateMixin {
  final TerritoryService _service = TerritoryService();
  static const String _fallbackNlMapSvgAsset = 'assets/images/maps/netherlandsLow.svg';
  static const Map<String, String> _countryMapAssetFallbackByCode = {
    'nl': 'netherlandsLow.svg',
    'be': 'belgium.svg',
    'ar': 'argentinaLow.svg',
    'au': 'australiaLow.svg',
    'br': 'brazilLow.svg',
    'cn': 'chinaLow.svg',
    'co': 'colombiaLow.svg',
    'fr': 'franceLow.svg',
    'de': 'germanyLow.svg',
    'it': 'italyLow.svg',
    'jp': 'japanLow.svg',
    'mx': 'mexicoLow.svg',
    'ru': 'russiaLow.svg',
    'es': 'spainLow.svg',
    'ch': 'switzerlandLow.svg',
    'tr': 'turkeyLow.svg',
    'uk': 'ukLow.svg',
    'gb': 'ukLow.svg',
    'us': 'usaLow.svg',
  };

  bool _isLoading = true;
  bool _isTerritoryEnabled = false;

  // ── Data ──────────────────────────────────────────────────────────────────
  Map<String, dynamic> _mapData = {};
  List<Map<String, dynamic>> _countries = [];
  List<dynamic> _leaderboard = [];
  Map<String, dynamic> _overview = {};
  String _selectedCountryCode = 'nl';
  String? _svgTemplate;
  String? _renderedSvgMap;

  // ── Selection ─────────────────────────────────────────────────────────────
  Map<String, dynamic>? _selectedRegion;
  bool _isActing = false;

  // ── Tabs ──────────────────────────────────────────────────────────────────
  late TabController _tabController;

  bool get _isNl => Localizations.localeOf(context).languageCode == 'nl';
  String _t(String nl, String en) => _isNl ? nl : en;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData(reloadCountries: true);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData({String? countryCode, bool reloadCountries = false}) async {
    setState(() => _isLoading = true);

    List<Map<String, dynamic>> countries = _countries;
    if (reloadCountries || countries.isEmpty) {
      final rawCountries = await _service.getCountries();
      countries = rawCountries
          .whereType<Map<String, dynamic>>()
          .map((country) => Map<String, dynamic>.from(country))
          .toList(growable: false);
    }

    var targetCountryCode = (countryCode ?? _selectedCountryCode).toLowerCase();
    if (countries.isNotEmpty) {
      final countryCodes = countries
          .map((country) => (country['countryCode'] as String?)?.toLowerCase())
          .whereType<String>()
          .toSet();
      if (!countryCodes.contains(targetCountryCode)) {
        targetCountryCode = (countries.first['countryCode'] as String?)?.toLowerCase() ?? targetCountryCode;
      }
    }

    final [mapData, overview, leaderboard] = await Future.wait([
      _service.getMap(targetCountryCode),
      _service.getOverview(),
      _service.getLeaderboard(),
    ]);

    final mapDataMap = mapData as Map<String, dynamic>;
    final mapCountry = mapDataMap['country'] as Map<String, dynamic>?;
    final resolvedCountryCode = (mapCountry?['countryCode'] as String?)?.toLowerCase() ?? targetCountryCode;
    final svgAssetKey = mapCountry?['svgAssetKey'] as String?;
    final svgTemplate = await _loadSvgTemplateForCountry(resolvedCountryCode, svgAssetKey);

    if (!mounted) return;
    setState(() {
      _countries = countries;
      _selectedCountryCode = resolvedCountryCode;
      _mapData = mapDataMap;
      _overview = overview as Map<String, dynamic>;
      _leaderboard = leaderboard as List<dynamic>;
      _isTerritoryEnabled = (_overview['config']?['enabled'] as bool?) ?? false;
      _svgTemplate = svgTemplate;
      _renderedSvgMap = _renderSvgWithOwnership((_mapData['regions'] as List<dynamic>?) ?? const <dynamic>[]);
      _isLoading = false;
    });
  }

  List<String> _buildMapAssetCandidates(String countryCode, String? svgAssetKey) {
    final candidates = <String>[];

    if (svgAssetKey != null && svgAssetKey.trim().isNotEmpty) {
      final key = svgAssetKey.trim();
      if (key.startsWith('assets/')) {
        candidates.add(key.toLowerCase().endsWith('.svg') ? key : '$key.svg');
      } else {
        final normalized = key.toLowerCase().endsWith('.svg') ? key : '$key.svg';
        candidates.add('assets/images/maps/$normalized');
      }
    }

    final fallbackFile = _countryMapAssetFallbackByCode[countryCode];
    if (fallbackFile != null) {
      candidates.add('assets/images/maps/$fallbackFile');
    }

    candidates.add(_fallbackNlMapSvgAsset);
    return candidates.toSet().toList(growable: false);
  }

  Future<String?> _loadSvgTemplateForCountry(String countryCode, String? svgAssetKey) async {
    final candidates = _buildMapAssetCandidates(countryCode, svgAssetKey);
    for (final candidate in candidates) {
      try {
        return await rootBundle.loadString(candidate);
      } catch (_) {
        // Continue with the next candidate.
      }
    }
    return null;
  }

  String _currentCountryLabel() {
    final country = _mapData['country'] as Map<String, dynamic>?;
    if (country == null) return _selectedCountryCode.toUpperCase();
    final label = _isNl
        ? (country['displayNameNl'] as String?)
        : (country['displayNameEn'] as String?);
    if (label != null && label.trim().isNotEmpty) {
      return label.trim();
    }
    return (country['countryCode'] as String?)?.toUpperCase() ?? _selectedCountryCode.toUpperCase();
  }

  String? _renderSvgWithOwnership(List<dynamic> regions) {
    final template = _svgTemplate;
    if (template == null || template.isEmpty || regions.isEmpty) return template;

    var svg = template;
    for (final rawRegion in regions) {
      if (rawRegion is! Map<String, dynamic>) continue;
      final svgElementId = rawRegion['svgElementId'] as String?;
      if (svgElementId == null || svgElementId.trim().isEmpty) continue;

      final fillHex = _hexColorForRegion(rawRegion);
      svg = _applyFillToElement(svg, svgElementId.trim(), fillHex);
    }
    return svg;
  }

  String _hexColorForRegion(Map<String, dynamic> region) {
    final contestStatus = (region['contestStatus'] as String?)?.toLowerCase();
    if (contestStatus != null && contestStatus != 'resolved' && contestStatus != 'cancelled') {
      return '#F59E0B';
    }

    final ownerCrewId = region['ownerCrewId'];
    if (ownerCrewId == null) {
      return '#D1D5DB';
    }

    final crewId = ownerCrewId is num ? ownerCrewId.toInt() : int.tryParse(ownerCrewId.toString());
    if (crewId == null) {
      return '#D1D5DB';
    }

    return _hexColorForCrewId(crewId);
  }

  String _hexColorForCrewId(int crewId) {

    final palette = <String>[
      '#2563EB',
      '#059669',
      '#DC2626',
      '#7C3AED',
      '#EA580C',
      '#0891B2',
      '#65A30D',
      '#DB2777',
      '#4F46E5',
      '#0F766E',
    ];
    return palette[crewId.abs() % palette.length];
  }

  Color _colorFromHex(String hex) {
    final normalized = hex.replaceFirst('#', '').trim();
    if (normalized.length != 6) return Colors.grey;
    final value = int.tryParse(normalized, radix: 16);
    if (value == null) return Colors.grey;
    return Color(0xFF000000 | value);
  }

  List<_TerritoryLegendEntry> _buildLegendEntries(List<dynamic> regions) {
    final crewLegendById = <int, _TerritoryLegendEntry>{};

    for (final rawRegion in regions) {
      if (rawRegion is! Map<String, dynamic>) continue;
      final ownerCrewIdRaw = rawRegion['ownerCrewId'];
      final ownerCrewName = (rawRegion['ownerCrewName'] as String?)?.trim();
      if (ownerCrewIdRaw == null || ownerCrewName == null || ownerCrewName.isEmpty) {
        continue;
      }

      final ownerCrewId = ownerCrewIdRaw is num
          ? ownerCrewIdRaw.toInt()
          : int.tryParse(ownerCrewIdRaw.toString());
      if (ownerCrewId == null || crewLegendById.containsKey(ownerCrewId)) {
        continue;
      }

      crewLegendById[ownerCrewId] = _TerritoryLegendEntry(
        label: ownerCrewName,
        colorHex: _hexColorForCrewId(ownerCrewId),
      );
    }

    final crewEntries = crewLegendById.values.toList()
      ..sort((a, b) => a.label.toLowerCase().compareTo(b.label.toLowerCase()));

    return <_TerritoryLegendEntry>[
      _TerritoryLegendEntry(label: _t('In strijd', 'Under contest'), colorHex: '#F59E0B'),
      _TerritoryLegendEntry(label: _t('Neutraal', 'Neutral'), colorHex: '#D1D5DB'),
      ...crewEntries,
    ];
  }

  Widget _buildLegendChip(_TerritoryLegendEntry entry) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.45)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: _colorFromHex(entry.colorHex), shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(entry.label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  String _applyFillToElement(String svg, String elementId, String fillHex) {
    final escapedId = RegExp.escape(elementId);
    final tagRegex = RegExp('(<[^>]*\\bid="$escapedId"[^>]*>)', caseSensitive: false);

    return svg.replaceFirstMapped(tagRegex, (match) {
      final tag = match.group(1) ?? '';

      if (tag.contains('style="')) {
        final styleRegex = RegExp('style="([^"]*)"', caseSensitive: false);
        return tag.replaceFirstMapped(styleRegex, (styleMatch) {
          var styleValue = styleMatch.group(1) ?? '';
          if (RegExp(r'(^|;)\\s*fill\\s*:', caseSensitive: false).hasMatch(styleValue)) {
            styleValue = styleValue.replaceAllMapped(
              RegExp(r'(^|;)\\s*fill\\s*:[^;]*', caseSensitive: false),
              (m) => '${m.group(1) ?? ';'}fill:$fillHex',
            );
          } else {
            if (styleValue.isNotEmpty && !styleValue.trim().endsWith(';')) {
              styleValue = '$styleValue;';
            }
            styleValue = '$styleValue fill:$fillHex;';
          }
          return 'style="$styleValue"';
        });
      }

      if (RegExp('\\sfill="', caseSensitive: false).hasMatch(tag)) {
        return tag.replaceFirst(RegExp('fill="[^"]*"', caseSensitive: false), 'fill="$fillHex"');
      }

      return tag.replaceFirst('>', ' fill="$fillHex">');
    });
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (!_isTerritoryEnabled) {
      return Scaffold(
        appBar: AppBar(title: Text(_t('Territorium', 'Territory'))),
        body: Center(
          child: Text(
            _t('Territorium is momenteel niet beschikbaar.', 'Territory is currently unavailable.'),
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_t('Territorium', 'Territory')),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: _t('Kaart', 'Map')),
            Tab(text: _t('Ranglijst', 'Leaderboard')),
            Tab(text: _t('Seizoen', 'Season')),
          ],
        ),
        actions: [
          if (_countries.length > 1)
            PopupMenuButton<String>(
              tooltip: _t('Kies land', 'Select country'),
              icon: const Icon(Icons.public),
              onSelected: (countryCode) {
                if (countryCode == _selectedCountryCode) return;
                setState(() => _selectedRegion = null);
                _loadData(countryCode: countryCode);
              },
              itemBuilder: (context) => _countries
                  .map(
                    (country) => PopupMenuItem<String>(
                      value: ((country['countryCode'] as String?) ?? '').toLowerCase(),
                      child: Text(
                        _isNl
                            ? (country['displayNameNl'] as String? ?? (country['countryCode'] as String? ?? ''))
                            : (country['displayNameEn'] as String? ?? (country['countryCode'] as String? ?? '')),
                      ),
                    ),
                  )
                  .toList(growable: false),
            ),
          IconButton(icon: const Icon(Icons.refresh), tooltip: _t('Vernieuwen', 'Refresh'), onPressed: _loadData),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildMapTab(), _buildLeaderboardTab(), _buildSeasonTab()],
      ),
    );
  }

  // ── Map Tab ───────────────────────────────────────────────────────────────

  Widget _buildMapTab() {
    final regions = (_mapData['regions'] as List<dynamic>?) ?? [];

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 900;
        final isTablet = constraints.maxWidth >= 600 && constraints.maxWidth < 900;

        if (isDesktop) {
          return Row(
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    _buildSvgMapOverview(regions),
                    const SizedBox(height: 8),
                    Expanded(child: _buildRegionGrid(regions)),
                  ],
                ),
              ),
              const VerticalDivider(width: 1),
              SizedBox(
                width: 320,
                child: _selectedRegion != null ? _buildRegionDetail(_selectedRegion!) : _buildNoSelectionPlaceholder(),
              ),
            ],
          );
        }

        if (isTablet) {
          return Column(
            children: [
              _buildSvgMapOverview(regions),
              const SizedBox(height: 8),
              Expanded(child: _buildRegionGrid(regions)),
              if (_selectedRegion != null) SizedBox(height: 280, child: _buildRegionDetail(_selectedRegion!)),
            ],
          );
        }

        // Mobile
        return Stack(
          children: [
            Column(
              children: [
                _buildSvgMapOverview(regions),
                const SizedBox(height: 8),
                Expanded(child: _buildRegionGrid(regions)),
              ],
            ),
            if (_selectedRegion != null)
              DraggableScrollableSheet(
                initialChildSize: 0.35,
                minChildSize: 0.15,
                maxChildSize: 0.65,
                builder: (_, controller) => Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    boxShadow: const [BoxShadow(blurRadius: 8, spreadRadius: 2)],
                  ),
                  child: ListView(
                    controller: controller,
                    children: [
                      Center(
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(color: Colors.grey[400], borderRadius: BorderRadius.circular(2)),
                        ),
                      ),
                      _buildRegionDetail(_selectedRegion!),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildSvgMapOverview(List<dynamic> regions) {
    final svgMarkup = _renderedSvgMap;
    if (svgMarkup == null || svgMarkup.isEmpty) {
      return const SizedBox.shrink();
    }
    final legendEntries = _buildLegendEntries(regions);

    return Card(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _isNl
                  ? '${_currentCountryLabel()} kaart (crew controle)'
                  : '${_currentCountryLabel()} map (crew control)',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 220,
              width: double.infinity,
              child: SvgPicture.string(
                svgMarkup,
                fit: BoxFit.contain,
                placeholderBuilder: (_) => const Center(child: CircularProgressIndicator()),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _t(
                'Regio-kleuren tonen eigendom; oranje = actieve contest.',
                'Region colors show ownership; orange = active contest.',
              ),
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
            const SizedBox(height: 8),
            Text(
              _t('Legenda', 'Legend'),
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: legendEntries.map(_buildLegendChip).toList(growable: false),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegionGrid(List<dynamic> regions) {
    if (regions.isEmpty) {
      return Center(child: Text(_t('Geen regio\'s gevonden.', 'No regions found.')));
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          mainAxisExtent: 120,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: regions.length,
        itemBuilder: (context, i) => _buildRegionCard(regions[i] as Map<String, dynamic>),
      ),
    );
  }

  Widget _buildRegionCard(Map<String, dynamic> region) {
    final regionName = _isNl
        ? (region['nameNl'] as String? ?? region['regionKey'] as String? ?? '')
        : (region['nameEn'] as String? ?? region['regionKey'] as String? ?? '');
    final ownerName = region['ownerCrewName'] as String?;
    final controlPercent = (region['controlPercent'] as num?)?.toInt() ?? 0;
    final contestStatus = region['contestStatus'] as String?;
    final isSelected = _selectedRegion?['regionKey'] == region['regionKey'];

    final Color statusColor = contestStatus != null
        ? Colors.orange
        : (ownerName != null ? Colors.green[700]! : Colors.grey[600]!);

    return GestureDetector(
      onTap: () => setState(() => _selectedRegion = region),
      child: Card(
        elevation: isSelected ? 6 : 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: isSelected ? BorderSide(color: Theme.of(context).colorScheme.primary, width: 2) : BorderSide.none,
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                regionName,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                ownerName ?? _t('Neutraal', 'Neutral'),
                style: TextStyle(color: statusColor, fontSize: 11),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (controlPercent > 0) ...[
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: controlPercent / 100,
                  color: statusColor,
                  backgroundColor: Colors.grey[300],
                  minHeight: 4,
                ),
              ],
              if (contestStatus != null) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded, size: 12, color: Colors.orange),
                    const SizedBox(width: 2),
                    Text(_t('In strijd', 'Under contest'), style: const TextStyle(color: Colors.orange, fontSize: 10)),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRegionDetail(Map<String, dynamic> region) {
    final regionName = _isNl ? (region['nameNl'] as String? ?? '') : (region['nameEn'] as String? ?? '');
    final ownerName = region['ownerCrewName'] as String?;
    final stability = (region['stability'] as num?)?.toInt() ?? 100;
    final contestId = region['contestId'] as int?;
    final contestStatus = region['contestStatus'] as String?;
    final tier = (region['valueTier'] as num?)?.toInt() ?? 1;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(regionName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 18),
                onPressed: () => setState(() => _selectedRegion = null),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _detailRow(_t('Eigenaar', 'Owner'), ownerName ?? _t('Neutraal', 'Neutral')),
          _detailRow(_t('Stabiliteit', 'Stability'), '$stability%'),
          _detailRow(_t('Waarde', 'Value tier'), '⭐' * tier),
          if (contestStatus != null) _detailRow(_t('Contest status', 'Contest status'), contestStatus),
          const SizedBox(height: 16),
          // Actions
          if (contestStatus == null)
            _buildActionButton(
              label: _t('Aanvallen', 'Attack'),
              icon: Icons.gps_fixed,
              color: Colors.red[700]!,
              onTap: () => _confirmStartContest(region['regionKey'] as String),
            ),
          if (contestId != null && contestStatus == 'active') ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _smallActionButton(_t('Patrouille', 'Patrol'), 'patrol', contestId),
                _smallActionButton(_t('Sabotage', 'Sabotage'), 'sabotage', contestId),
                _smallActionButton(_t('Inval', 'Raid'), 'raid', contestId),
                _smallActionButton(_t('Verdedigen', 'Defense'), 'defense', contestId),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 16),
        label: Text(label),
        style: ElevatedButton.styleFrom(backgroundColor: color, foregroundColor: Colors.white),
        onPressed: _isActing ? null : onTap,
      ),
    );
  }

  Widget _smallActionButton(String label, String actionType, int contestId) {
    return OutlinedButton(
      onPressed: _isActing ? null : () => _doAction(contestId, actionType),
      child: Text(label, style: const TextStyle(fontSize: 12)),
    );
  }

  Widget _buildNoSelectionPlaceholder() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          _t('Selecteer een regio op de kaart.', 'Select a region on the map.'),
          style: const TextStyle(color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  // ── Leaderboard Tab ────────────────────────────────────────────────────────

  Widget _buildLeaderboardTab() {
    if (_leaderboard.isEmpty) {
      return Center(child: Text(_t('Nog geen territorium gecontroleerd.', 'No territory controlled yet.')));
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _leaderboard.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, i) {
        final entry = _leaderboard[i] as Map<String, dynamic>;
        return ListTile(
          leading: CircleAvatar(
            child: Text('${i + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          title: Text(entry['crewName'] as String? ?? ''),
          trailing: Text(
            '${entry['regionsOwned']} ${_t('regio\'s', 'regions')}',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        );
      },
    );
  }

  // ── Season Tab ─────────────────────────────────────────────────────────────

  Widget _buildSeasonTab() {
    final season = _overview['activeSeason'] as Map<String, dynamic>?;
    if (season == null) {
      return Center(child: Text(_t('Geen actief seizoen gevonden.', 'No active season found.')));
    }

    final key = season['seasonKey'] as String? ?? '';
    final status = season['status'] as String? ?? '';
    final startsAt = season['startsAt'] as String? ?? '';
    final endsAt = season['endsAt'] as String? ?? '';

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _t('Huidig seizoen', 'Current season'),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _detailRow(_t('Sleutel', 'Key'), key),
          _detailRow(_t('Status', 'Status'), status),
          _detailRow(_t('Start', 'Start'), startsAt),
          _detailRow(_t('Einde', 'End'), endsAt),
        ],
      ),
    );
  }

  // ── Actions ────────────────────────────────────────────────────────────────

  Future<void> _confirmStartContest(String regionKey) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(_t('Aanvallen?', 'Attack?')),
        content: Text(_t('Wil je een contest starten voor $regionKey?', 'Start a contest for $regionKey?')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(_t('Annuleer', 'Cancel'))),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: Text(_t('Aanvallen', 'Attack'))),
        ],
      ),
    );
    if (confirmed != true) return;

    setState(() => _isActing = true);
    final result = await _service.startContest(regionKey);
    if (!mounted) return;
    setState(() => _isActing = false);

    if (result['success'] == true) {
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(_t('Contest gestart!', 'Contest started!')),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );
      await _loadData();
    } else {
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(
            _t('Mislukt: ${result['event'] ?? result['message']}', 'Failed: ${result['event'] ?? result['message']}'),
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  Future<void> _doAction(int contestId, String actionType) async {
    setState(() => _isActing = true);
    final result = await _service.doAction(contestId, actionType);
    if (!mounted) return;
    setState(() => _isActing = false);

    if (result['success'] == true) {
      final pts = result['pointsDelta'] ?? 0;
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(_t('+$pts punten!', '+$pts points!')),
          backgroundColor: Colors.blue,
          duration: const Duration(seconds: 3),
        ),
      );
      await _loadData();
    } else {
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(
            _t(
              'Actie mislukt: ${result['event'] ?? result['message']}',
              'Action failed: ${result['event'] ?? result['message']}',
            ),
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }
}

class _TerritoryLegendEntry {
  const _TerritoryLegendEntry({required this.label, required this.colorHex});

  final String label;
  final String colorHex;
}
