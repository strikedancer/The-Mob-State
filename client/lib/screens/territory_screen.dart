import 'dart:async';

import 'package:flutter/gestures.dart' show PointerHoverEvent;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_drawing/path_drawing.dart';

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
    'za': 'southAfricaLow.svg',
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
  Rect? _svgViewBox;
  List<_SvgRegionShape> _svgRegionShapes = const [];
  String? _hoveredSvgElementId;
  String? _mapTooltipLabel;
  Offset? _mapTooltipOffset;
  Timer? _mapTooltipTimer;

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
    _mapTooltipTimer?.cancel();
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
    final parsedSvg = _parseSvgMap(svgTemplate);

    if (!mounted) return;
    setState(() {
      _countries = countries;
      _selectedCountryCode = resolvedCountryCode;
      _mapData = mapDataMap;
      _overview = overview as Map<String, dynamic>;
      _leaderboard = leaderboard as List<dynamic>;
      _isTerritoryEnabled = (_overview['config']?['enabled'] as bool?) ?? false;
      _svgTemplate = svgTemplate;
      _svgViewBox = parsedSvg?.viewBox;
      _svgRegionShapes = parsedSvg?.shapes ?? const [];
      _hoveredSvgElementId = null;
      _mapTooltipLabel = null;
      _mapTooltipOffset = null;
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

  _SvgMapParseResult? _parseSvgMap(String? svg) {
    if (svg == null || svg.isEmpty) return null;

    final viewBoxMatch = RegExp(
      'viewBox="([^"]+)"',
      caseSensitive: false,
      dotAll: true,
    ).firstMatch(svg);
    if (viewBoxMatch == null) return null;

    final viewBoxParts = viewBoxMatch
        .group(1)
        ?.trim()
        .split(RegExp(r'\s+'))
        .map((part) => double.tryParse(part))
        .toList();
    if (viewBoxParts == null || viewBoxParts.length != 4 || viewBoxParts.any((v) => v == null)) {
      return null;
    }

    final minX = viewBoxParts[0]!;
    final minY = viewBoxParts[1]!;
    final width = viewBoxParts[2]!;
    final height = viewBoxParts[3]!;
    if (width <= 0 || height <= 0) return null;

    final pathTagRegex = RegExp(r'<path\b[^>]*>', caseSensitive: false, dotAll: true);
    final shapes = <_SvgRegionShape>[];

    for (final match in pathTagRegex.allMatches(svg)) {
      final tag = match.group(0);
      if (tag == null) continue;

      final id = _extractSvgAttr(tag, 'id');
      final d = _extractSvgAttr(tag, 'd');
      if (id == null || id.trim().isEmpty || d == null || d.trim().isEmpty) continue;

      final name = _extractSvgAttr(tag, 'data-name')?.trim();

      try {
        final path = parseSvgPathData(d);
        shapes.add(_SvgRegionShape(id: id.trim(), name: name, path: path));
      } catch (_) {
        // Ignore malformed individual paths and continue.
      }
    }

    if (shapes.isEmpty) return null;
    return _SvgMapParseResult(viewBox: Rect.fromLTWH(minX, minY, width, height), shapes: shapes);
  }

  String? _extractSvgAttr(String tag, String attr) {
    final regex = RegExp('$attr="([^"]*)"', caseSensitive: false, dotAll: true);
    return regex.firstMatch(tag)?.group(1);
  }

  Offset? _localToSvgPoint({
    required Offset local,
    required Size renderSize,
    required Rect viewBox,
  }) {
    final fitted = applyBoxFit(BoxFit.contain, viewBox.size, renderSize);
    final destination = Alignment.center.inscribe(fitted.destination, Offset.zero & renderSize);
    if (!destination.contains(local) || destination.width <= 0 || destination.height <= 0) {
      return null;
    }

    final dx = (local.dx - destination.left) / destination.width;
    final dy = (local.dy - destination.top) / destination.height;
    return Offset(viewBox.left + (dx * viewBox.width), viewBox.top + (dy * viewBox.height));
  }

  _SvgRegionShape? _findShapeAtLocalPoint(Offset local, Size renderSize) {
    final viewBox = _svgViewBox;
    if (viewBox == null || _svgRegionShapes.isEmpty) return null;

    final svgPoint = _localToSvgPoint(local: local, renderSize: renderSize, viewBox: viewBox);
    if (svgPoint == null) return null;

    for (var i = _svgRegionShapes.length - 1; i >= 0; i--) {
      if (_svgRegionShapes[i].path.contains(svgPoint)) {
        return _svgRegionShapes[i];
      }
    }
    return null;
  }

  Map<String, dynamic>? _findRegionBySvgElementId(List<dynamic> regions, String svgElementId) {
    return regions
        .whereType<Map<String, dynamic>>()
        .cast<Map<String, dynamic>?>()
        .firstWhere(
          (region) =>
              (region?['svgElementId'] as String?)?.trim().toLowerCase() ==
              svgElementId.trim().toLowerCase(),
          orElse: () => null,
        );
  }

  String _regionDisplayName(Map<String, dynamic>? region, _SvgRegionShape shape) {
    if (region == null) return shape.name ?? shape.id;
    return _isNl
        ? (region['nameNl'] as String? ?? region['regionKey'] as String? ?? shape.name ?? shape.id)
        : (region['nameEn'] as String? ?? region['regionKey'] as String? ?? shape.name ?? shape.id);
  }

  void _updateHoveredRegion(String? svgElementId, {bool clearTooltip = false}) {
    final normalized = svgElementId?.trim();
    final current = _hoveredSvgElementId;
    if (current == normalized && !clearTooltip) return;

    setState(() {
      _hoveredSvgElementId = normalized;
      if (clearTooltip) {
        _mapTooltipLabel = null;
        _mapTooltipOffset = null;
      }
      _renderedSvgMap = _renderSvgWithOwnership((_mapData['regions'] as List<dynamic>?) ?? const <dynamic>[]);
    });
  }

  void _handleMapHover(PointerHoverEvent event, Size renderSize, List<dynamic> regions) {
    final hit = _findShapeAtLocalPoint(event.localPosition, renderSize);
    if (hit == null) {
      _mapTooltipTimer?.cancel();
      _updateHoveredRegion(null, clearTooltip: true);
      return;
    }

    final matchedRegion = _findRegionBySvgElementId(regions, hit.id);
    _mapTooltipTimer?.cancel();
    setState(() {
      _hoveredSvgElementId = hit.id;
      _mapTooltipLabel = _regionDisplayName(matchedRegion, hit);
      _mapTooltipOffset = event.localPosition;
      _renderedSvgMap = _renderSvgWithOwnership((_mapData['regions'] as List<dynamic>?) ?? const <dynamic>[]);
    });
  }

  void _handleMapHoverExit() {
    _mapTooltipTimer?.cancel();
    _updateHoveredRegion(null, clearTooltip: true);
  }

  void _handleMapTap(TapDownDetails details, Size renderSize, List<dynamic> regions) {
    final hit = _findShapeAtLocalPoint(details.localPosition, renderSize);
    if (hit == null) return;

    final matchedRegion = _findRegionBySvgElementId(regions, hit.id);
    final regionName = _regionDisplayName(matchedRegion, hit);

    _mapTooltipTimer?.cancel();
    setState(() {
      if (matchedRegion != null) {
        _selectedRegion = matchedRegion;
      }
      _hoveredSvgElementId = hit.id;
      _mapTooltipLabel = regionName;
      _mapTooltipOffset = details.localPosition;
      _renderedSvgMap = _renderSvgWithOwnership((_mapData['regions'] as List<dynamic>?) ?? const <dynamic>[]);
    });

    _mapTooltipTimer = Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {
        _mapTooltipLabel = null;
        _mapTooltipOffset = null;
      });
    });
  }

  String? _renderSvgWithOwnership(List<dynamic> regions) {
    final template = _svgTemplate;
    if (template == null || template.isEmpty) return template;

    final regionBySvgId = <String, Map<String, dynamic>>{};
    for (final rawRegion in regions) {
      if (rawRegion is! Map<String, dynamic>) continue;
      final svgElementId = (rawRegion['svgElementId'] as String?)?.trim();
      if (svgElementId == null || svgElementId.isEmpty) continue;
      regionBySvgId[svgElementId.toLowerCase()] = rawRegion;
    }

    final shapes = _svgRegionShapes;
    if (shapes.isEmpty) return template;

    var svg = template;
    for (final shape in shapes) {
      final region = regionBySvgId[shape.id.toLowerCase()];
      var fillHex = region != null ? _hexColorForRegion(region) : '#D1D5DB';
      if (_hoveredSvgElementId?.toLowerCase() == shape.id.toLowerCase()) {
        fillHex = _darkenHex(fillHex, 0.18);
      }
      svg = _applyRegionStyleToElement(
        svg,
        shape.id,
        fillHex,
        strokeHex: '#FFFFFF',
        strokeWidth: '0.9',
      );
    }
    return svg;
  }

  String _darkenHex(String hex, double amount) {
    final normalized = hex.replaceFirst('#', '').trim();
    if (normalized.length != 6) return hex;
    final value = int.tryParse(normalized, radix: 16);
    if (value == null) return hex;

    int channel(int shift) {
      final base = (value >> shift) & 0xFF;
      final darkened = (base * (1.0 - amount)).round().clamp(0, 255);
      return darkened;
    }

    final r = channel(16).toRadixString(16).padLeft(2, '0');
    final g = channel(8).toRadixString(16).padLeft(2, '0');
    final b = channel(0).toRadixString(16).padLeft(2, '0');
    return '#$r$g$b'.toUpperCase();
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

  String _applyRegionStyleToElement(
    String svg,
    String elementId,
    String fillHex, {
    required String strokeHex,
    required String strokeWidth,
  }) {
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

          if (RegExp(r'(^|;)\\s*stroke\\s*:', caseSensitive: false).hasMatch(styleValue)) {
            styleValue = styleValue.replaceAllMapped(
              RegExp(r'(^|;)\\s*stroke\\s*:[^;]*', caseSensitive: false),
              (m) => '${m.group(1) ?? ';'}stroke:$strokeHex',
            );
          } else {
            styleValue = '$styleValue stroke:$strokeHex;';
          }

          if (RegExp(r'(^|;)\\s*stroke-width\\s*:', caseSensitive: false).hasMatch(styleValue)) {
            styleValue = styleValue.replaceAllMapped(
              RegExp(r'(^|;)\\s*stroke-width\\s*:[^;]*', caseSensitive: false),
              (m) => '${m.group(1) ?? ';'}stroke-width:$strokeWidth',
            );
          } else {
            styleValue = '$styleValue stroke-width:$strokeWidth;';
          }

          return 'style="$styleValue"';
        });
      }

      var updatedTag = tag;
      if (RegExp('\\sfill="', caseSensitive: false).hasMatch(updatedTag)) {
        updatedTag = updatedTag.replaceFirst(RegExp('fill="[^"]*"', caseSensitive: false), 'fill="$fillHex"');
      } else {
        updatedTag = updatedTag.replaceFirst('>', ' fill="$fillHex">');
      }

      if (RegExp('\\sstroke="', caseSensitive: false).hasMatch(updatedTag)) {
        updatedTag = updatedTag.replaceFirst(RegExp('stroke="[^"]*"', caseSensitive: false), 'stroke="$strokeHex"');
      } else {
        updatedTag = updatedTag.replaceFirst('>', ' stroke="$strokeHex">');
      }

      if (RegExp('\\sstroke-width="', caseSensitive: false).hasMatch(updatedTag)) {
        updatedTag = updatedTag.replaceFirst(
          RegExp('stroke-width="[^"]*"', caseSensitive: false),
          'stroke-width="$strokeWidth"',
        );
      } else {
        updatedTag = updatedTag.replaceFirst('>', ' stroke-width="$strokeWidth">');
      }

      return updatedTag;
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

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          _buildSvgMapOverview(regions),
          const SizedBox(height: 8),
          _buildRegionGrid(regions, embeddedInParentScroll: true),
          const SizedBox(height: 8),
          if (_selectedRegion != null)
            Card(
              margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: _buildRegionDetail(_selectedRegion!),
            )
          else
            Card(
              margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: _buildNoSelectionPlaceholder(),
            ),
        ],
      ),
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
            LayoutBuilder(
              builder: (context, constraints) {
                final maxWidth = constraints.maxWidth;
                final mapHeight = maxWidth >= 900
                    ? 420.0
                    : (maxWidth >= 600 ? 340.0 : 300.0);

                return SizedBox(
                  height: mapHeight,
                  width: double.infinity,
                  child: MouseRegion(
                    onHover: (event) => _handleMapHover(event, Size(maxWidth, mapHeight), regions),
                    onExit: (_) => _handleMapHoverExit(),
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTapDown: (details) => _handleMapTap(details, Size(maxWidth, mapHeight), regions),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: SvgPicture.string(
                              svgMarkup,
                              fit: BoxFit.contain,
                              placeholderBuilder: (_) => const Center(child: CircularProgressIndicator()),
                            ),
                          ),
                          if (_mapTooltipLabel != null && _mapTooltipOffset != null)
                            Positioned(
                              left: (_mapTooltipOffset!.dx + 10).clamp(8, maxWidth - 180),
                              top: (_mapTooltipOffset!.dy - 36).clamp(8, mapHeight - 32),
                              child: Container(
                                constraints: const BoxConstraints(maxWidth: 170),
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.black87,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  _mapTooltipLabel!,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(color: Colors.white, fontSize: 12),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            Text(
              _t(
                'Hover of klik op een gebied voor details; oranje = actieve contest.',
                'Hover or tap a region for details; orange = active contest.',
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

  Widget _buildRegionGrid(List<dynamic> regions, {bool embeddedInParentScroll = false}) {
    if (regions.isEmpty) {
      return Center(child: Text(_t('Geen regio\'s gevonden.', 'No regions found.')));
    }

    return GridView.builder(
      shrinkWrap: embeddedInParentScroll,
      physics: embeddedInParentScroll
          ? const NeverScrollableScrollPhysics()
          : const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        mainAxisExtent: 120,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: regions.length,
      itemBuilder: (context, i) => _buildRegionCard(regions[i] as Map<String, dynamic>),
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

class _SvgMapParseResult {
  const _SvgMapParseResult({required this.viewBox, required this.shapes});

  final Rect viewBox;
  final List<_SvgRegionShape> shapes;
}

class _SvgRegionShape {
  const _SvgRegionShape({required this.id, required this.name, required this.path});

  final String id;
  final String? name;
  final Path path;
}
