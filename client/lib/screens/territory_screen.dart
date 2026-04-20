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
  int? _myCrewId;
  String? _myCrewName;
  String? _svgTemplate;
  String? _renderedSvgMap;
  Rect? _svgViewBox;
  List<_SvgRegionShape> _svgRegionShapes = const [];
  String? _hoveredSvgElementId;
  String? _mapTooltipLabel;
  Offset? _mapTooltipOffset;
  Timer? _mapTooltipTimer;
  final ValueNotifier<Map<String, dynamic>?> _regionDetailNotifier = ValueNotifier<Map<String, dynamic>?>(null);

  // ── Selection ─────────────────────────────────────────────────────────────
  Map<String, dynamic>? _selectedRegion;
  bool _isActing = false;
  bool _isRegionSheetOpen = false;

  // ── Tabs ──────────────────────────────────────────────────────────────────
  late TabController _tabController;

  bool get _isNl => Localizations.localeOf(context).languageCode == 'nl';
  bool get _hasCrew => _myCrewId != null;
  String _t(String nl, String en) => _isNl ? nl : en;
  int get _actionCooldownSeconds => (_overview['config']?['actionCooldownSeconds'] as num?)?.toInt() ?? 0;

  String _countryDisplayName(Map<String, dynamic> country) {
    return _isNl
        ? (country['displayNameNl'] as String? ?? (country['countryCode'] as String? ?? ''))
        : (country['displayNameEn'] as String? ?? (country['countryCode'] as String? ?? ''));
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData(reloadCountries: true);
  }

  @override
  void dispose() {
    _mapTooltipTimer?.cancel();
    _regionDetailNotifier.dispose();
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

    final previousRegionKey = _selectedRegion?['regionKey'] as String?;

    final [mapData, overview, leaderboard, myCrew] = await Future.wait([
      _service.getMap(targetCountryCode),
      _service.getOverview(),
      _service.getLeaderboard(),
      _service.getMyCrew(),
    ]);

    final mapDataMap = mapData as Map<String, dynamic>;
    final mapCountry = mapDataMap['country'] as Map<String, dynamic>?;
    final resolvedCountryCode = (mapCountry?['countryCode'] as String?)?.toLowerCase() ?? targetCountryCode;
    final svgAssetKey = mapCountry?['svgAssetKey'] as String?;
    final svgTemplate = await _loadSvgTemplateForCountry(resolvedCountryCode, svgAssetKey);
    final parsedSvg = _parseSvgMap(svgTemplate);
    final myCrewMap = myCrew as Map<String, dynamic>?;
    final myCrewIdRaw = myCrewMap?['id'];
    final myCrewId = myCrewIdRaw is num ? myCrewIdRaw.toInt() : int.tryParse(myCrewIdRaw?.toString() ?? '');
    final regions = (mapDataMap['regions'] as List<dynamic>?) ?? const <dynamic>[];
    final selectedRegion = previousRegionKey == null
        ? null
        : regions.whereType<Map<String, dynamic>>().cast<Map<String, dynamic>?>().firstWhere(
              (region) => region?['regionKey'] == previousRegionKey,
              orElse: () => null,
            );

    if (!mounted) return;
    setState(() {
      _countries = countries;
      _selectedCountryCode = resolvedCountryCode;
      _mapData = mapDataMap;
      _overview = overview as Map<String, dynamic>;
      _leaderboard = leaderboard as List<dynamic>;
      _isTerritoryEnabled = (_overview['config']?['enabled'] as bool?) ?? false;
      _myCrewId = myCrewId;
      _myCrewName = myCrewMap?['name'] as String?;
      _svgTemplate = svgTemplate;
      _svgViewBox = parsedSvg?.viewBox;
      _svgRegionShapes = parsedSvg?.shapes ?? const [];
      _hoveredSvgElementId = null;
      _mapTooltipLabel = null;
      _mapTooltipOffset = null;
      _selectedRegion = selectedRegion;
      _renderedSvgMap = _renderSvgWithOwnership((_mapData['regions'] as List<dynamic>?) ?? const <dynamic>[]);
      _isLoading = false;
    });
    _regionDetailNotifier.value = selectedRegion;
  }

  bool _isMyCrewRegion(Map<String, dynamic> region) {
    if (_myCrewId == null) return false;
    final ownerCrewId = region['ownerCrewId'];
    final resolvedOwnerCrewId = ownerCrewId is num ? ownerCrewId.toInt() : int.tryParse(ownerCrewId?.toString() ?? '');
    return resolvedOwnerCrewId == _myCrewId;
  }

  String _displayContestStatus(String status) {
    switch (status.toLowerCase()) {
      case 'preparing':
        return _t('Voorbereiding', 'Preparation');
      case 'active':
        return _t('Actief', 'Active');
      case 'lockdown':
        return _t('Lockdown', 'Lockdown');
      case 'resolved':
        return _t('Afgerond', 'Resolved');
      case 'cancelled':
        return _t('Geannuleerd', 'Cancelled');
      default:
        return status;
    }
  }

  String? _contestHint(String? status) {
    switch (status?.toLowerCase()) {
      case 'preparing':
        return _t(
          'De contest loopt nu in voorbereiding. Zodra de prep-tijd voorbij is, wordt dit gebied automatisch actief en kun je acties uitvoeren.',
          'This contest is currently in preparation. Once prep time ends, the region automatically becomes active and actions unlock.',
        );
      case 'lockdown':
        return _t(
          'Deze contest zit in lockdown. Er kunnen nu geen nieuwe acties meer worden gedaan; de uitkomst volgt automatisch.',
          'This contest is in lockdown. No new actions can be taken now; the outcome resolves automatically.',
        );
      default:
        return null;
    }
  }

  DateTime? _parseApiDate(dynamic rawValue) {
    if (rawValue == null) return null;
    return DateTime.tryParse(rawValue.toString())?.toLocal();
  }

  String _formatDuration(Duration duration) {
    final safeDuration = duration.isNegative ? Duration.zero : duration;
    final totalHours = safeDuration.inHours;
    final minutes = safeDuration.inMinutes.remainder(60);
    final seconds = safeDuration.inSeconds.remainder(60);

    if (totalHours > 0) {
      return '${totalHours}u ${minutes}m';
    }
    if (safeDuration.inMinutes > 0) {
      return '${safeDuration.inMinutes}m';
    }
    return '${seconds}s';
  }

  String _countdownLabel(DateTime? targetAt) {
    if (targetAt == null) {
      return _t('Onbekend', 'Unknown');
    }
    final remaining = targetAt.difference(DateTime.now());
    if (remaining.isNegative || remaining.inSeconds <= 0) {
      return _t('Nu', 'Now');
    }
    return _formatDuration(remaining);
  }

  DateTime? _contestTimestampFromFallback({
    required DateTime? startedAt,
    required DateTime? primary,
    required int offsetMinutes,
  }) {
    if (primary != null) return primary;
    if (startedAt == null || offsetMinutes <= 0) return null;
    return startedAt.add(Duration(minutes: offsetMinutes));
  }

  Map<String, dynamic>? _findRegionByKey(String regionKey) {
    final regions = (_mapData['regions'] as List<dynamic>?) ?? const <dynamic>[];
    return regions
        .whereType<Map<String, dynamic>>()
        .cast<Map<String, dynamic>?>()
        .firstWhere(
          (region) => (region?['regionKey'] as String?) == regionKey,
          orElse: () => null,
        );
  }

  Future<Map<String, dynamic>?> _reloadRegionState(String regionKey) async {
    await _loadData();
    if (!mounted) return null;
    final refreshedRegion = _findRegionByKey(regionKey);
    if (refreshedRegion != null) {
      _selectedRegion = refreshedRegion;
      _regionDetailNotifier.value = refreshedRegion;
    }
    return refreshedRegion;
  }

  String _displayContestRole(String role) {
    switch (role.toLowerCase()) {
      case 'attacker':
        return _t('Aanvaller', 'Attacker');
      case 'defender':
        return _t('Verdediger', 'Defender');
      default:
        return role;
    }
  }

  String _valueTierLabel(int tier) {
    switch (tier) {
      case 1:
        return _t('Laag', 'Low');
      case 2:
        return _t('Gemiddeld', 'Average');
      case 3:
        return _t('Hoog', 'High');
      default:
        return _t('Top', 'Top');
    }
  }

  String _valueTierYieldSummary(int tier) {
    switch (tier) {
      case 1:
        return _t('Laag passief inkomen en kleine seizoenswaarde', 'Low passive income and modest seasonal value');
      case 2:
        return _t('Gemiddeld passief inkomen en seizoenswaarde', 'Average passive income and seasonal value');
      case 3:
        return _t('Hoog passief inkomen en sterke seizoenswaarde', 'High passive income and strong seasonal value');
      default:
        return _t('Top passief inkomen en maximale seizoenswaarde', 'Top passive income and maximum seasonal value');
    }
  }

  String _territoryErrorMessage(Object? rawEvent) {
    final event = rawEvent?.toString() ?? '';
    switch (event) {
      case 'error.not_in_crew':
        return _t('Je moet eerst in een crew zitten om territorium aan te vallen.', 'You must join a crew before you can attack territory.');
      case 'territory.contest_already_active':
        return _t('Voor dit gebied loopt al een contest. De kaart wordt ververst met de actuele status.', 'A contest is already running for this region. Refreshing the map to the latest state.');
      case 'territory.crew_contest_limit_reached':
        return _t('Je crew heeft al het maximum aantal gelijktijdige contests bereikt.', 'Your crew has already reached the concurrent contest limit.');
      case 'territory.regions_cap_reached':
        return _t('Je crew bezit al het maximum aantal gebieden.', 'Your crew already owns the maximum number of regions.');
      case 'territory.contest_not_active':
        return _t('Deze contest is nog niet actief. Wacht tot de voorbereidingsfase voorbij is.', 'This contest is not active yet. Wait for the preparation phase to finish.');
      case 'territory.action_cooldown':
        return _t('Je moet even wachten voor je opnieuw een territory-actie kunt doen.', 'You need to wait before performing another territory action.');
      case 'territory.action_role_mismatch':
        return _t('Deze actie hoort bij de andere kant van de contest.', 'This action belongs to the other side of the contest.');
      case 'territory.daily_cap_reached':
        return _t('Je hebt je dagelijkse limiet voor territory-acties bereikt.', 'You have reached your daily limit for territory actions.');
      default:
        return event.isEmpty ? _t('Onbekende territory-fout.', 'Unknown territory error.') : event;
    }
  }

  bool _shouldReloadAfterTerritoryError(Object? rawEvent) {
    switch (rawEvent?.toString()) {
      case 'territory.contest_already_active':
      case 'territory.contest_not_active':
      case 'territory.contest_not_joinable':
      case 'territory.contest_not_found':
      case 'territory.contest_already_resolved':
      case 'territory.not_in_contest':
      case 'territory.action_role_mismatch':
        return true;
      default:
        return false;
    }
  }

  Widget _buildInfoNotice(String text, {Color? borderColor, Color? backgroundColor, IconData icon = Icons.info_outline}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.blueGrey.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor ?? Colors.blueGrey.withValues(alpha: 0.28)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 1),
            child: Icon(icon, size: 16, color: borderColor ?? Colors.blueGrey.shade700),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 12.5, height: 1.35),
            ),
          ),
        ],
      ),
    );
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
    if (matchedRegion != null) {
      _regionDetailNotifier.value = matchedRegion;
    }

    if (matchedRegion != null) {
      unawaited(_showRegionDetailModal(matchedRegion));
    }

    _mapTooltipTimer = Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {
        _mapTooltipLabel = null;
        _mapTooltipOffset = null;
      });
    });
  }

  Future<void> _showRegionDetailModal(Map<String, dynamic> region) async {
    if (_isRegionSheetOpen) return;

    _regionDetailNotifier.value = region;

    setState(() {
      _isRegionSheetOpen = true;
    });

    try {
      await showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (sheetContext) {
          final mediaQuery = MediaQuery.of(sheetContext);
          final maxHeight = mediaQuery.size.height * 0.88;

          return SafeArea(
            top: false,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: maxHeight),
              child: SingleChildScrollView(
                padding: EdgeInsets.only(bottom: mediaQuery.viewInsets.bottom),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 10),
                    Container(
                      width: 44,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Theme.of(sheetContext).dividerColor,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    ValueListenableBuilder<Map<String, dynamic>?>(
                      valueListenable: _regionDetailNotifier,
                      builder: (context, liveRegion, _) {
                        if (liveRegion == null) {
                          return const SizedBox.shrink();
                        }
                        return _buildRegionDetail(
                          liveRegion,
                          onClose: () => Navigator.of(sheetContext).pop(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    } finally {
      if (!mounted) return;
      setState(() {
        _isRegionSheetOpen = false;
        _selectedRegion = null;
      });
      _regionDetailNotifier.value = null;
    }
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
        strokeHex: '#000000',
        strokeWidth: '1.1',
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
          if (RegExp(r'(^|;)\s*fill\s*:', caseSensitive: false).hasMatch(styleValue)) {
            styleValue = styleValue.replaceAllMapped(
              RegExp(r'(^|;)\s*fill\s*:[^;]*', caseSensitive: false),
              (m) => '${m.group(1) ?? ';'}fill:$fillHex',
            );
          } else {
            if (styleValue.isNotEmpty && !styleValue.trim().endsWith(';')) {
              styleValue = '$styleValue;';
            }
            styleValue = '$styleValue fill:$fillHex;';
          }

          if (RegExp(r'(^|;)\s*stroke\s*:', caseSensitive: false).hasMatch(styleValue)) {
            styleValue = styleValue.replaceAllMapped(
              RegExp(r'(^|;)\s*stroke\s*:[^;]*', caseSensitive: false),
              (m) => '${m.group(1) ?? ';'}stroke:$strokeHex',
            );
          } else {
            styleValue = '$styleValue stroke:$strokeHex;';
          }

          if (RegExp(r'(^|;)\s*stroke-width\s*:', caseSensitive: false).hasMatch(styleValue)) {
            styleValue = styleValue.replaceAllMapped(
              RegExp(r'(^|;)\s*stroke-width\s*:[^;]*', caseSensitive: false),
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
              icon: const Icon(Icons.language),
              onSelected: (countryCode) {
                if (countryCode == _selectedCountryCode) return;
                setState(() => _selectedRegion = null);
                _loadData(countryCode: countryCode);
              },
              itemBuilder: (context) => _countries
                  .map(
                    (country) {
                      final countryCode = ((country['countryCode'] as String?) ?? '').toLowerCase();
                      return PopupMenuItem<String>(
                        value: countryCode,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              countryCode == _selectedCountryCode ? Icons.language : Icons.flag,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Flexible(child: Text(_countryDisplayName(country), overflow: TextOverflow.ellipsis)),
                          ],
                        ),
                      );
                    },
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
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
            child: Text(
              _t(
                'Tik op een gebied op de kaart om gebiedsinformatie en de aanvalsknop in een modal te openen.',
                'Tap a region on the map to open territory information and the attack button in a modal.',
              ),
              style: TextStyle(color: Colors.grey[700], fontSize: 12),
            ),
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
                final isWideLayout = maxWidth >= 980;
                final mapHeight = maxWidth >= 900
                    ? 420.0
                    : (maxWidth >= 600 ? 340.0 : 300.0);
                final mapWidget = SizedBox(
                  height: mapHeight,
                  width: double.infinity,
                  child: MouseRegion(
                    onHover: (event) => _handleMapHover(event, Size(isWideLayout ? maxWidth * 0.58 : maxWidth, mapHeight), regions),
                    onExit: (_) => _handleMapHoverExit(),
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTapDown: (details) => _handleMapTap(details, Size(isWideLayout ? maxWidth * 0.58 : maxWidth, mapHeight), regions),
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
                              left: (_mapTooltipOffset!.dx + 10).clamp(8, (isWideLayout ? (maxWidth * 0.58) : maxWidth) - 180),
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
                final infoWidget = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _t(
                        'Klik op een gebied om direct de modal met gebiedsinformatie en aanvalsacties te openen.',
                        'Tap a region to directly open the modal with territory information and attack actions.',
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
                    const SizedBox(height: 12),
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
                    const SizedBox(height: 12),
                    Text(
                      _t(
                        'Jouw crew: ${_myCrewName ?? '-'}',
                        'Your crew: ${_myCrewName ?? '-'}',
                      ),
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                    ),
                  ],
                );

                if (isWideLayout) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: infoWidget,
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: mapWidget,
                      ),
                    ],
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    mapWidget,
                    const SizedBox(height: 8),
                    infoWidget,
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegionDetail(Map<String, dynamic> region, {VoidCallback? onClose}) {
    final regionName = _isNl ? (region['nameNl'] as String? ?? '') : (region['nameEn'] as String? ?? '');
    final ownerName = region['ownerCrewName'] as String?;
    final stability = (region['stability'] as num?)?.toInt() ?? 100;
    final controlPercent = (region['controlPercent'] as num?)?.toDouble() ?? 0;
    final contestId = region['contestId'] as int?;
    final contestStatus = region['contestStatus'] as String?;
    final contestRole = region['viewerContestRole'] as String?;
    final attackerCrewName = region['attackerCrewName'] as String?;
    final defenderCrewName = region['defenderCrewName'] as String?;
    final contestStartedAt = _parseApiDate(region['contestStartedAt']);
    final prepMinutes = (_overview['config']?['contestPrepMinutes'] as num?)?.toInt() ?? 0;
    final activeMinutes = (_overview['config']?['contestActiveMinutes'] as num?)?.toInt() ?? 0;
    final lockdownMinutes = (_overview['config']?['contestLockdownMinutes'] as num?)?.toInt() ?? 0;
    final contestActiveAt = _contestTimestampFromFallback(
      startedAt: contestStartedAt,
      primary: _parseApiDate(region['contestActiveAt']),
      offsetMinutes: prepMinutes,
    );
    final contestLockdownAt = _contestTimestampFromFallback(
      startedAt: contestStartedAt,
      primary: _parseApiDate(region['contestLockdownAt']),
      offsetMinutes: prepMinutes + activeMinutes,
    );
    final contestResolveAt = _contestTimestampFromFallback(
      startedAt: contestStartedAt,
      primary: _parseApiDate(region['contestResolveAt']),
      offsetMinutes: prepMinutes + activeMinutes + lockdownMinutes,
    );
    final viewerCooldownSecondsRemaining = (region['viewerCooldownSecondsRemaining'] as num?)?.toInt() ?? 0;
    final tier = (region['valueTier'] as num?)?.toInt() ?? 1;
    final isMyCrewRegion = _isMyCrewRegion(region);
    final contestHint = _contestHint(contestStatus);
    final isAttacker = contestRole == 'attacker';
    final isDefender = contestRole == 'defender';
    final hasContest = contestId != null && contestStatus != null;
    final incomeTierLabel = _valueTierLabel(tier);
    final incomeSummary = _valueTierYieldSummary(tier);

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
              if (onClose != null)
                IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: onClose,
                ),
            ],
          ),
          const SizedBox(height: 8),
          _detailRow(_t('Eigenaar', 'Owner'), ownerName ?? _t('Neutraal', 'Neutral')),
          _detailRow(_t('Stabiliteit', 'Stability'), '$stability%'),
          _detailRow(_t('Controle', 'Control'), '${controlPercent.toStringAsFixed(controlPercent.truncateToDouble() == controlPercent ? 0 : 1)}%'),
          _detailRow(_t('Waarde', 'Value tier'), '⭐' * tier),
          _detailRow(_t('Opbrengst', 'Yield'), incomeTierLabel),
          _detailRow(_t('Levert op', 'Yields'), incomeSummary),
          if (_myCrewName != null) _detailRow(_t('Jouw crew', 'Your crew'), _myCrewName!),
          if (contestStatus != null) _detailRow(_t('Contest status', 'Contest status'), _displayContestStatus(contestStatus)),
          if (attackerCrewName != null) _detailRow(_t('Aanvaller', 'Attacker'), attackerCrewName),
          if (defenderCrewName != null) _detailRow(_t('Verdediger', 'Defender'), defenderCrewName),
          if (contestRole != null) _detailRow(_t('Jouw rol', 'Your role'), _displayContestRole(contestRole)),
          if (contestStatus == 'preparing') _detailRow(_t('Acties starten over', 'Actions unlock in'), _countdownLabel(contestActiveAt)),
          if (contestStatus == 'active') _detailRow(_t('Acties sluiten over', 'Actions close in'), _countdownLabel(contestLockdownAt)),
          if (hasContest) _detailRow(_t('Contest eindigt over', 'Contest ends in'), _countdownLabel(contestResolveAt)),
          if (_actionCooldownSeconds > 0) _detailRow(_t('Cooldown per actie', 'Cooldown per action'), _formatDuration(Duration(seconds: _actionCooldownSeconds))),
          if (viewerCooldownSecondsRemaining > 0)
            _detailRow(
              _t('Jouw cooldown', 'Your cooldown'),
              _formatDuration(Duration(seconds: viewerCooldownSecondsRemaining)),
            ),
          const SizedBox(height: 16),
          if (!_hasCrew)
            _buildInfoNotice(
              _t(
                'Territorium is alleen speelbaar voor crewleden. Maak eerst een crew aan of sluit je bij een crew aan, daarna kun je neutrale gebieden aanvallen.',
                'Territory is only playable for crew members. Create or join a crew first, then you can attack neutral regions.',
              ),
              borderColor: Colors.orange.shade700,
              backgroundColor: Colors.orange.withValues(alpha: 0.1),
              icon: Icons.groups_rounded,
            ),
          if (contestHint != null) ...[
            _buildInfoNotice(
              contestHint,
              borderColor: Colors.amber.shade700,
              backgroundColor: Colors.amber.withValues(alpha: 0.1),
              icon: Icons.schedule,
            ),
            const SizedBox(height: 12),
          ],
          if (contestStatus == null && isMyCrewRegion)
            _buildInfoNotice(
              _t('Je crew controleert dit gebied al.', 'Your crew already controls this region.'),
              borderColor: Colors.green.shade700,
              backgroundColor: Colors.green.withValues(alpha: 0.1),
              icon: Icons.verified,
            ),
          if (contestStatus == 'preparing' && isDefender) ...[
            _buildInfoNotice(
              _t(
                'Jouw crew verdedigt dit gebied. Zodra de actieve fase start, krijg je alleen verdedigende acties te zien.',
                'Your crew is defending this region. Once the active phase starts, you will only see defensive actions.',
              ),
              borderColor: Colors.blue.shade700,
              backgroundColor: Colors.blue.withValues(alpha: 0.1),
              icon: Icons.shield,
            ),
            const SizedBox(height: 12),
            _buildActionButton(
              label: _t('Verdediging bevestigen', 'Confirm defense'),
              icon: Icons.shield,
              color: Colors.blue[700]!,
              onTap: () => _joinDefense(contestId),
            ),
          ],
          // Actions
          if (contestStatus == null && _hasCrew && !isMyCrewRegion)
            _buildActionButton(
              label: _t('Aanvallen', 'Attack'),
              icon: Icons.gps_fixed,
              color: Colors.red[700]!,
              onTap: () => _confirmStartContest(region['regionKey'] as String),
            ),
          if (contestId != null && contestStatus == 'active') ...[
            const SizedBox(height: 8),
            Text(
              isAttacker
                  ? _t('Aanvalsacties', 'Attacker actions')
                  : (isDefender ? _t('Verdedigingsacties', 'Defender actions') : _t('Contestacties', 'Contest actions')),
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (isAttacker) ...[
                  _smallActionButton(_t('Intel', 'Intel scan'), 'intel_scan', contestId),
                  _smallActionButton(_t('Sabotage', 'Sabotage'), 'sabotage', contestId),
                  _smallActionButton(_t('Inval', 'Raid'), 'Raid', contestId),
                ],
                if (isDefender) ...[
                  _smallActionButton(_t('Patrouille', 'Patrol'), 'patrol', contestId),
                  _smallActionButton(_t('Bevoorrading', 'Supply run'), 'supply_run', contestId),
                  _smallActionButton(_t('Verdedigen', 'Defense'), 'defense', contestId),
                ],
              ],
            ),
          ],
          if (contestId != null && contestStatus == 'active' && !isAttacker && !isDefender)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: _buildInfoNotice(
                _t(
                  'Je zit niet aan deze contest gekoppeld, dus je kunt hier geen acties uitvoeren.',
                  'You are not part of this contest, so you cannot perform actions here.',
                ),
                borderColor: Colors.blueGrey.shade600,
                backgroundColor: Colors.blueGrey.withValues(alpha: 0.1),
                icon: Icons.lock_outline,
              ),
            ),
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
    if (!_hasCrew) {
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(_t('Sluit je eerst aan bij een crew om territorium aan te vallen.', 'Join a crew first to attack territory.')),
          backgroundColor: Colors.orange,
          duration: const Duration(seconds: 4),
        ),
      );
      return;
    }

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
      final contestStatus = _displayContestStatus((result['status'] as String?) ?? 'preparing');
      await _reloadRegionState(regionKey);
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(
            _t(
              'Contest gestart. Status: $contestStatus. Wacht tot de voorbereidingsfase voorbij is voor acties.',
              'Contest started. Status: $contestStatus. Wait for the preparation phase to finish before taking actions.',
            ),
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 5),
        ),
      );
    } else {
      final rawEvent = result['event'] ?? result['message'];
      final refreshedRegion = await _reloadRegionState(regionKey);
      final refreshedStatus = refreshedRegion?['contestStatus'] as String?;
      if (refreshedRegion?['contestId'] != null && refreshedStatus != null) {
        final liveStatus = _displayContestStatus(refreshedStatus);
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(
              _t(
                'De contest is al gestart en de kaart is ververst. Status: $liveStatus.',
                'The contest is already started and the map has been refreshed. Status: $liveStatus.',
              ),
            ),
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 5),
          ),
        );
        return;
      }
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(_territoryErrorMessage(rawEvent)),
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
      final rawEvent = result['event'] ?? result['message'];
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(_territoryErrorMessage(rawEvent)),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
      if (_shouldReloadAfterTerritoryError(rawEvent)) {
        await _loadData();
      }
    }
  }

  Future<void> _joinDefense(int? contestId) async {
    if (contestId == null) return;

    final regionKey = _regionDetailNotifier.value?['regionKey'] as String? ?? _selectedRegion?['regionKey'] as String?;

    setState(() => _isActing = true);
    final result = await _service.defendContest(contestId);
    if (!mounted) return;
    setState(() => _isActing = false);

    if (result['success'] == true) {
      if (regionKey != null) {
        await _reloadRegionState(regionKey);
      } else {
        await _loadData();
      }
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(
            _t(
              'Verdediging bevestigd. Zodra de actieve fase start, kun je verdedigingsacties uitvoeren.',
              'Defense confirmed. Once the active phase starts, you can perform defensive actions.',
            ),
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 4),
        ),
      );
    } else {
      final rawEvent = result['event'] ?? result['message'];
      if (regionKey != null) {
        final refreshedRegion = await _reloadRegionState(regionKey);
        final refreshedStatus = refreshedRegion?['contestStatus'] as String?;
        if (refreshedRegion?['contestId'] != null && refreshedStatus != null) {
          showTopRightFromSnackBar(
            context,
            SnackBar(
              content: Text(
                _t(
                  'De conteststatus is ververst. Je ziet nu direct de actuele verdedigingsfase.',
                  'The contest state has been refreshed. You can now immediately see the current defense phase.',
                ),
              ),
              backgroundColor: Colors.orange,
              duration: const Duration(seconds: 4),
            ),
          );
          return;
        }
      } else if (_shouldReloadAfterTerritoryError(rawEvent)) {
        await _loadData();
      }
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(_territoryErrorMessage(rawEvent)),
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
