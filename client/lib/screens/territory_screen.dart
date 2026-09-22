import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform;
import 'package:flutter/gestures.dart'
    show
        PointerCancelEvent,
        PointerDownEvent,
        PointerHoverEvent,
        PointerMoveEvent,
        PointerUpEvent;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_drawing/path_drawing.dart';

import '../providers/auth_provider.dart';
import '../services/territory_service.dart';
import '../l10n/app_localizations.dart';
import '../utils/formatters.dart';
import '../utils/pwa_install.dart';
import '../utils/top_right_notification.dart';
import '../widgets/mobile_load_error.dart';
import '../widgets/game_page_info.dart';
import '../widgets/empire_page_hero.dart';
import '../widgets/jail_gate.dart';
// ---------------------------------------------------------------------------
// TerritoryScreen â€” Responsive crew territory map (NL-first)
// Layout: desktop = split (map | side panel), tablet = stacked collapsible,
//         mobile  = map card + action bottom sheet.
// Pinch-zoom/pan is mobile+tablet only; desktop keeps a fixed map (no wheel zoom).
// ---------------------------------------------------------------------------

class TerritoryScreen extends StatefulWidget {
  const TerritoryScreen({super.key, this.embedded = false});

  final bool embedded;

  @override
  State<TerritoryScreen> createState() => _TerritoryScreenState();
}

class _TerritoryScreenState extends State<TerritoryScreen>
    with SingleTickerProviderStateMixin {
  final TerritoryService _service = TerritoryService();
  static const String _fallbackNlMapSvgAsset =
      'assets/images/maps/netherlandsLow.svg';
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
  static const Map<String, String> _territoryCountryCodeByTravelCountry = {
    'ar': 'ar',
    'argentina': 'ar',
    'au': 'au',
    'australia': 'au',
    'be': 'be',
    'belgium': 'be',
    'br': 'br',
    'brazil': 'br',
    'ch': 'ch',
    'switzerland': 'ch',
    'cn': 'cn',
    'china': 'cn',
    'co': 'co',
    'colombia': 'co',
    'de': 'de',
    'germany': 'de',
    'es': 'es',
    'spain': 'es',
    'fr': 'fr',
    'france': 'fr',
    'gb': 'gb',
    'uk': 'gb',
    'unitedkingdom': 'gb',
    'united_kingdom': 'gb',
    'united-kingdom': 'gb',
    'it': 'it',
    'italy': 'it',
    'jp': 'jp',
    'japan': 'jp',
    'mx': 'mx',
    'mexico': 'mx',
    'nl': 'nl',
    'netherlands': 'nl',
    'ru': 'ru',
    'russia': 'ru',
    'tr': 'tr',
    'turkey': 'tr',
    'us': 'us',
    'usa': 'us',
    'unitedstates': 'us',
    'united_states': 'us',
    'united-states': 'us',
    'za': 'za',
    'southafrica': 'za',
    'south_africa': 'za',
    'south-africa': 'za',
  };

  bool _isLoading = true;
  String? _loadError;
  bool _isTerritoryEnabled = false;

  // â”€â”€ Data â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  Map<String, dynamic> _mapData = {};
  List<Map<String, dynamic>> _countries = [];
  List<dynamic> _leaderboard = [];
  Map<String, dynamic> _overview = {};
  Map<String, dynamic>? _crewTerritory;
  bool _leaderboardShowSeason = false;
  String _selectedCountryCode = 'nl';
  bool _userPickedCountry = false;
  AuthProvider? _auth;
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
  final TransformationController _mapTransformController =
      TransformationController();
  final ValueNotifier<Map<String, dynamic>?> _regionDetailNotifier =
      ValueNotifier<Map<String, dynamic>?>(null);
  final ValueNotifier<DateTime> _nowNotifier = ValueNotifier<DateTime>(
    DateTime.now(),
  );
  Timer? _liveTimer;
  bool _silentRefreshInFlight = false;
  String? _lastSilentRefreshKey;
  DateTime? _lastSilentRefreshAt;
  Offset? _mapPointerDownPosition;
  bool _mapPointerMoved = false;
  int _activeMapPointers = 0;
  int _maxMapPointersDuringGesture = 0;

  /// Pinch-zoom/pan for phones and tablets only. Desktop mouse-wheel zoom is off.
  bool _mapPinchZoomEnabled() {
    if (pwaLooksLikeMobileWeb()) return true;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
        return true;
      default:
        return false;
    }
  }

  void _resetMapTransformIfNeeded({required bool allowZoom}) {
    if (allowZoom) return;
    if (_mapTransformController.value == Matrix4.identity()) return;
    _mapTransformController.value = Matrix4.identity();
  }

  // â”€â”€ Selection â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  Map<String, dynamic>? _selectedRegion;
  bool _isActing = false;
  bool _isRegionSheetOpen = false;
  bool _overlayContest = true;
  bool _overlayProject = true;
  bool _overlayEvent = true;
  bool _overlayWar = true;

  // â”€â”€ Tabs â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  late TabController _tabController;

  bool get _hasCrew => _myCrewId != null;

  AppLocalizations get _l10n => AppLocalizations.of(context)!;
  int get _actionCooldownSeconds =>
      (_overview['config']?['actionCooldownSeconds'] as num?)?.toInt() ?? 0;

  int get _projectContributeCooldownSeconds {
    final project = (_overview['config']?['projectContributeCooldownSeconds']
            as num?)
        ?.toInt();
    if (project != null && project > 0) return project;
    return _actionCooldownSeconds > 0 ? _actionCooldownSeconds : 900;
  }

  String _countryDisplayName(Map<String, dynamic> country) {
    final lang = Localizations.localeOf(context).languageCode.toLowerCase();
    if (lang == 'nl') {
      return (country['displayNameNl'] as String?) ??
          (country['displayNameEn'] as String?) ??
          (country['countryCode'] as String? ?? '');
    }
    return (country['displayNameEn'] as String?) ??
        (country['displayNameNl'] as String?) ??
        (country['countryCode'] as String? ?? '');
  }

  String _localizedRegionNameFromMap(Map<String, dynamic> region) {
    final lang = Localizations.localeOf(context).languageCode.toLowerCase();
    if (lang == 'nl') {
      return (region['nameNl'] as String?) ??
          (region['nameEn'] as String?) ??
          '';
    }
    return (region['nameEn'] as String?) ??
        (region['nameNl'] as String?) ??
        '';
  }

  String _bonusApiLabel(Map<dynamic, dynamic> rawBonus) {
    final lang = Localizations.localeOf(context).languageCode.toLowerCase();
    if (lang == 'nl') {
      return (rawBonus['labelNl'] as String?)?.trim() ?? '';
    }
    return (rawBonus['labelEn'] as String?)?.trim() ?? '';
  }

  String _countryDisplayNameByCode(String countryCode) {
    for (final country in _countries) {
      final code = (country['countryCode'] as String?)?.toLowerCase();
      if (code == countryCode.toLowerCase()) {
        return _countryDisplayName(country);
      }
    }
    return countryCode.toUpperCase();
  }

  String _territoryCodeForTravelCountry(String? currentCountry) {
    final normalized = currentCountry?.trim().toLowerCase();
    if (normalized == null || normalized.isEmpty) {
      return 'nl';
    }
    return _territoryCountryCodeByTravelCountry[normalized] ?? normalized;
  }

  String _territoryCodeForPlayer() {
    return _territoryCodeForTravelCountry(
      context.read<AuthProvider>().currentPlayer?.currentCountry,
    );
  }

  String _currentTerritoryCountryCode() {
    final currentCountry = context.select<AuthProvider, String?>(
      (auth) => auth.currentPlayer?.currentCountry,
    );
    return _territoryCodeForTravelCountry(currentCountry);
  }

  bool _canActInSelectedCountry() {
    return _currentTerritoryCountryCode() == _selectedCountryCode.toLowerCase();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _auth = context.read<AuthProvider>();
    _auth!.addListener(_onAuthChanged);
    _liveTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _onLiveTick();
    });
    _loadData(reloadCountries: true, countryCode: _territoryCodeForPlayer());
  }

  void _onAuthChanged() {
    if (!mounted || _userPickedCountry) return;
    final playerCountry = _territoryCodeForPlayer();
    if (playerCountry == _selectedCountryCode.toLowerCase()) return;
    _loadData(countryCode: playerCountry);
  }

  @override
  void dispose() {
    _auth?.removeListener(_onAuthChanged);
    _mapTooltipTimer?.cancel();
    _liveTimer?.cancel();
    _mapTransformController.dispose();
    _regionDetailNotifier.dispose();
    _nowNotifier.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData({
    String? countryCode,
    bool reloadCountries = false,
    bool silent = false,
  }) async {
    if (silent) {
      if (_silentRefreshInFlight || _isActing || _isLoading) return;
      _silentRefreshInFlight = true;
    } else {
      setState(() {
        _isLoading = _mapData.isEmpty;
        _loadError = null;
      });
    }

    try {
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
        targetCountryCode =
            (countries.first['countryCode'] as String?)?.toLowerCase() ??
            targetCountryCode;
      }
    }

    final previousRegionKey = _selectedRegion?['regionKey'] as String? ??
        _regionDetailNotifier.value?['regionKey'] as String?;

    final [mapData, overview, leaderboard, myCrew] = await Future.wait([
      _service.getMap(targetCountryCode),
      _service.getOverview(),
      _service.getLeaderboard(),
      _service.getMyCrew(),
    ]);

    final mapDataMap = mapData as Map<String, dynamic>;
    final overviewMap = overview as Map<String, dynamic>;
    _stampViewerCooldowns(
      mapDataMap,
      DateTime.now(),
      projectContributeCooldownSeconds:
          (overviewMap['config']?['projectContributeCooldownSeconds'] as num?)
              ?.toInt(),
    );
    final mapCountry = mapDataMap['country'] as Map<String, dynamic>?;
    final resolvedCountryCode =
        (mapCountry?['countryCode'] as String?)?.toLowerCase() ??
        targetCountryCode;
    final svgAssetKey = mapCountry?['svgAssetKey'] as String?;
    final reuseSvg = silent &&
        _svgTemplate != null &&
        _svgRegionShapes.isNotEmpty &&
        resolvedCountryCode == _selectedCountryCode.toLowerCase();
    final svgTemplate = reuseSvg
        ? _svgTemplate!
        : await _loadSvgTemplateForCountry(
            resolvedCountryCode,
            svgAssetKey,
          );
    final parsedSvg = reuseSvg ? null : _parseSvgMap(svgTemplate);
    final myCrewMap = myCrew as Map<String, dynamic>?;
    final myCrewIdRaw = myCrewMap?['id'];
    final myCrewId = myCrewIdRaw is num
        ? myCrewIdRaw.toInt()
        : int.tryParse(myCrewIdRaw?.toString() ?? '');
    final crewTerritory = myCrewId == null
        ? null
        : await _service.getCrewTerritory(myCrewId);
    final regions =
        (mapDataMap['regions'] as List<dynamic>?) ?? const <dynamic>[];
    final selectedRegion = previousRegionKey == null
        ? null
        : regions
              .whereType<Map<String, dynamic>>()
              .cast<Map<String, dynamic>?>()
              .firstWhere(
                (region) => region?['regionKey'] == previousRegionKey,
                orElse: () => null,
              );

    if (!mounted) return;
    setState(() {
      _countries = countries;
      _selectedCountryCode = resolvedCountryCode;
      _mapData = mapDataMap;
      _overview = overviewMap;
      _leaderboard = leaderboard as List<dynamic>;
      _crewTerritory = crewTerritory;
      _isTerritoryEnabled = (_overview['config']?['enabled'] as bool?) ?? false;
      _myCrewId = myCrewId;
      _myCrewName = myCrewMap?['name'] as String?;
      _svgTemplate = svgTemplate;
      if (!reuseSvg) {
        _svgViewBox = parsedSvg?.viewBox;
        _svgRegionShapes = parsedSvg?.shapes ?? const [];
      }
      if (!silent) {
        _hoveredSvgElementId = null;
        _mapTooltipLabel = null;
        _mapTooltipOffset = null;
      }
      _selectedRegion = selectedRegion;
      _renderedSvgMap = _renderSvgWithOwnership(
        (_mapData['regions'] as List<dynamic>?) ?? const <dynamic>[],
      );
      _isLoading = false;
    });
    if (!silent) {
      _resetMapTransform();
      _lastSilentRefreshKey = null;
    }
    _regionDetailNotifier.value = selectedRegion ??
        (silent ? _regionDetailNotifier.value : null);
    } catch (e) {
      if (silent) {
        _lastSilentRefreshKey = null;
        return;
      }
      if (!mounted) return;
      final t = AppLocalizations.of(context)!;
      setState(() {
        _loadError = t.connectionErrorGeneric;
        _isLoading = false;
      });
    } finally {
      if (silent) {
        _silentRefreshInFlight = false;
      }
    }
  }

  void _stampViewerCooldowns(
    Map<String, dynamic> mapData,
    DateTime fetchedAt, {
    int? projectContributeCooldownSeconds,
  }) {
    final regions = mapData['regions'];
    if (regions is! List) return;
    final projectCooldown = projectContributeCooldownSeconds != null &&
            projectContributeCooldownSeconds > 0
        ? projectContributeCooldownSeconds
        : 900;
    for (final raw in regions) {
      if (raw is! Map) continue;
      final nextAt = _parseApiDate(raw['viewerNextActionAt']);
      final remaining =
          (raw['viewerCooldownSecondsRemaining'] as num?)?.toInt() ?? 0;
      if (remaining > 0) {
        // Prefer server-reported remaining (avoids client/server clock skew).
        raw['viewerCooldownUntil'] =
            fetchedAt.add(Duration(seconds: remaining)).toIso8601String();
      } else if (nextAt != null && nextAt.isAfter(fetchedAt)) {
        raw['viewerCooldownUntil'] = nextAt.toIso8601String();
      } else {
        raw.remove('viewerCooldownUntil');
      }

      final projectRaw = raw['regionProject'];
      if (projectRaw is! Map) continue;
      final project = Map<String, dynamic>.from(projectRaw);
      raw['regionProject'] = project;
      _stampProjectContributeCooldown(
        project,
        fetchedAt: fetchedAt,
        fallbackCooldownSeconds: projectCooldown,
      );
    }
  }

  /// Stamps [projectContributeUntil] from server remaining seconds first, then
  /// absolute timestamps, so the Bevoorraad button can show a live countdown.
  void _stampProjectContributeCooldown(
    Map<String, dynamic> project, {
    required DateTime fetchedAt,
    int? fallbackCooldownSeconds,
    int? remainingOverride,
  }) {
    final cooldownSeconds = fallbackCooldownSeconds != null &&
            fallbackCooldownSeconds > 0
        ? fallbackCooldownSeconds
        : _projectContributeCooldownSeconds;
    var remaining =
        remainingOverride ??
        (project['contributeCooldownSecondsRemaining'] as num?)?.toInt() ??
        0;
    final projectNextAt = _parseApiDate(project['nextContributeAt']);
    final lastContributeAt = _parseApiDate(project['lastContributeAt']);

    DateTime? contributeUntil;
    if (remaining > 0) {
      contributeUntil = fetchedAt.add(Duration(seconds: remaining));
    } else if (projectNextAt != null && projectNextAt.isAfter(fetchedAt)) {
      contributeUntil = projectNextAt;
      remaining = projectNextAt.difference(fetchedAt).inSeconds;
    } else if (lastContributeAt != null && cooldownSeconds > 0) {
      final candidate =
          lastContributeAt.add(Duration(seconds: cooldownSeconds));
      if (candidate.isAfter(fetchedAt)) {
        contributeUntil = candidate;
        remaining = candidate.difference(fetchedAt).inSeconds;
      }
    }

    if (contributeUntil != null && remaining > 0) {
      project['projectContributeUntil'] = contributeUntil.toIso8601String();
      project['contributeCooldownSecondsRemaining'] = remaining;
    } else {
      project.remove('projectContributeUntil');
      project['contributeCooldownSecondsRemaining'] = 0;
    }
  }

  void _applyProjectContributeCooldownToOpenRegion({
    required String regionKey,
    Map<String, dynamic>? projectUpdate,
    int? remainingOverride,
  }) {
    final now = DateTime.now();
    final open = _regionDetailNotifier.value;
    if (open != null && open['regionKey'] == regionKey) {
      final patched = Map<String, dynamic>.from(open);
      final existing =
          (patched['regionProject'] as Map?)?.cast<String, dynamic>() ??
          <String, dynamic>{};
      final project = Map<String, dynamic>.from(existing);
      if (projectUpdate != null) {
        project.addAll(projectUpdate);
      }
      _stampProjectContributeCooldown(
        project,
        fetchedAt: now,
        remainingOverride: remainingOverride,
      );
      patched['regionProject'] = project;
      _regionDetailNotifier.value = patched;
      _selectedRegion = patched;
    }

    final mapRegion = _findRegionByKey(regionKey);
    if (mapRegion != null) {
      final existing =
          (mapRegion['regionProject'] as Map?)?.cast<String, dynamic>() ??
          <String, dynamic>{};
      final project = Map<String, dynamic>.from(existing);
      if (projectUpdate != null) {
        project.addAll(projectUpdate);
      }
      _stampProjectContributeCooldown(
        project,
        fetchedAt: now,
        remainingOverride: remainingOverride,
      );
      mapRegion['regionProject'] = project;
    }
  }

  void _onLiveTick() {
    if (!mounted) return;
    final now = DateTime.now();
    _nowNotifier.value = now;
    unawaited(_maybeSilentRefreshExpiredTimers(now));
  }

  Future<void> _maybeSilentRefreshExpiredTimers([DateTime? clock]) async {
    if (!mounted || _isActing || _isLoading || _silentRefreshInFlight) return;
    final now = clock ?? DateTime.now();
    String? key;
    final regions = (_mapData['regions'] as List<dynamic>?) ?? [];
    for (final raw in regions) {
      if (raw is! Map) continue;
      key = _expiredTimerRefreshKey(Map<String, dynamic>.from(raw), now);
      if (key != null) break;
    }
    if (key == null) {
      final open = _regionDetailNotifier.value ?? _selectedRegion;
      if (open != null) {
        key = _expiredTimerRefreshKey(open, now);
      }
    }
    if (key == null) return;
    if (key == _lastSilentRefreshKey) {
      final lastAt = _lastSilentRefreshAt;
      if (lastAt != null &&
          now.difference(lastAt) < const Duration(seconds: 12)) {
        return;
      }
    }
    _lastSilentRefreshKey = key;
    _lastSilentRefreshAt = now;
    await _loadData(silent: true);
  }

  String? _expiredTimerRefreshKey(
    Map<String, dynamic> region,
    DateTime now,
  ) {
    final regionKey = (region['regionKey'] as String?) ?? '';
    final status = (region['contestStatus'] as String?)?.toLowerCase();
    final contestStartedAt = _parseApiDate(region['contestStartedAt']);
    final prepMinutes =
        (_overview['config']?['contestPrepMinutes'] as num?)?.toInt() ?? 0;
    final activeMinutes =
        (_overview['config']?['contestActiveMinutes'] as num?)?.toInt() ?? 0;
    final lockdownMinutes =
        (_overview['config']?['contestLockdownMinutes'] as num?)?.toInt() ?? 0;
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

    if (status == 'preparing' &&
        contestActiveAt != null &&
        !contestActiveAt.isAfter(now)) {
      return '$regionKey:contest-active';
    }
    if (status == 'active' &&
        contestLockdownAt != null &&
        !contestLockdownAt.isAfter(now)) {
      return '$regionKey:contest-lockdown';
    }
    if (status == 'lockdown' &&
        contestResolveAt != null &&
        !contestResolveAt.isAfter(now)) {
      return '$regionKey:contest-resolve';
    }

    final cooldownUntil = _parseApiDate(region['viewerCooldownUntil']);
    final remainingSnap =
        (region['viewerCooldownSecondsRemaining'] as num?)?.toInt() ?? 0;
    if (remainingSnap > 0 &&
        cooldownUntil != null &&
        !cooldownUntil.isAfter(now)) {
      return '$regionKey:cooldown';
    }

    final project = (region['regionProject'] as Map?)?.cast<String, dynamic>();
    final contributeUntil = _parseApiDate(project?['projectContributeUntil']);
    if (contributeUntil != null && !contributeUntil.isAfter(now)) {
      return '$regionKey:project-contribute';
    }

    final garrison = (region['garrison'] as Map?)?.cast<String, dynamic>();
    if (garrison != null && garrison['active'] == true) {
      final endsAt = _parseApiDate(garrison['endsAt']);
      if (endsAt != null && !endsAt.isAfter(now)) {
        return '$regionKey:garrison';
      }
    }

    final warPressure = (region['activeWarPressure'] as Map?)
        ?.cast<String, dynamic>();
    if (warPressure != null) {
      final endsAt = _parseApiDate(warPressure['endsAt']);
      if (endsAt != null && !endsAt.isAfter(now)) {
        return '$regionKey:war-pressure';
      }
    }

    final holdDueAt = _parseApiDate(region['holdDueAt']);
    if (holdDueAt != null && !holdDueAt.isAfter(now)) {
      return '$regionKey:hold-due';
    }

    return null;
  }

  bool _isMyCrewRegion(Map<String, dynamic> region) {
    if (_myCrewId == null) return false;
    final ownerCrewId = region['ownerCrewId'];
    final resolvedOwnerCrewId = ownerCrewId is num
        ? ownerCrewId.toInt()
        : int.tryParse(ownerCrewId?.toString() ?? '');
    return resolvedOwnerCrewId == _myCrewId;
  }

  String _displayContestStatus(String status) {
    final t = _l10n;
    switch (status.toLowerCase()) {
      case 'preparing':
        return t.territoryContestStatusPreparing;
      case 'active':
        return t.territoryContestStatusActive;
      case 'lockdown':
        return t.territoryContestStatusLockdown;
      case 'resolved':
        return t.territoryContestStatusResolved;
      case 'cancelled':
        return t.territoryContestStatusCancelled;
      default:
        return status;
    }
  }

  String? _contestHint(String? status) {
    final t = _l10n;
    switch (status?.toLowerCase()) {
      case 'preparing':
        return t.territoryContestHintPreparing;
      case 'lockdown':
        return t.territoryContestHintLockdown;
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

  String _formatLiveDuration(Duration duration) {
    final safeDuration = duration.isNegative ? Duration.zero : duration;
    final hours = safeDuration.inHours;
    final minutes = safeDuration.inMinutes.remainder(60);
    final seconds = safeDuration.inSeconds.remainder(60);
    if (hours > 0) {
      return '${hours}u ${minutes.toString().padLeft(2, '0')}m ${seconds.toString().padLeft(2, '0')}s';
    }
    if (safeDuration.inMinutes > 0) {
      return '${safeDuration.inMinutes}m ${seconds.toString().padLeft(2, '0')}s';
    }
    return '${seconds}s';
  }

  String _countdownLabel(DateTime? targetAt, [DateTime? now]) {
    final t = _l10n;
    if (targetAt == null) {
      return t.unknown;
    }
    final remaining = targetAt.difference(now ?? _nowNotifier.value);
    if (remaining.isNegative || remaining.inSeconds <= 0) {
      return t.territoryNow;
    }
    return _formatLiveDuration(remaining);
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
    final regions =
        (_mapData['regions'] as List<dynamic>?) ?? const <dynamic>[];
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
    final t = _l10n;
    switch (role.toLowerCase()) {
      case 'attacker':
        return t.territoryRoleAttacker;
      case 'defender':
        return t.territoryRoleDefender;
      default:
        return role;
    }
  }

  String _valueTierLabel(int tier) {
    final t = _l10n;
    switch (tier) {
      case 1:
        return t.territoryValueLow;
      case 2:
        return t.territoryValueAverage;
      case 3:
        return t.territoryValueHigh;
      default:
        return t.territoryValueTop;
    }
  }

  String _incomeIntervalLabel(int minutes) {
    final t = _l10n;
    if (minutes <= 0) {
      return t.dashboardTerritoryIncomeNotConfigured;
    }
    if (minutes == 60) {
      return t.dashboardTerritoryIncomeEveryHours(1);
    }
    if (minutes % 60 == 0) {
      final hours = minutes ~/ 60;
      return t.dashboardTerritoryIncomeEveryHours(hours);
    }
    return t.dashboardTerritoryIncomeEveryMinutes(minutes);
  }

  String _strategicTagLabel(String tag) {
    final t = _l10n;
    switch (tag.toLowerCase()) {
      case 'capital':
        return t.territoryTagCapital;
      case 'harbor':
        return t.territoryTagHarbor;
      case 'industry':
        return t.territoryTagIndustry;
      case 'border':
        return t.territoryTagBorder;
      case 'logistics':
        return t.territoryTagLogistics;
      case 'airhub':
        return t.territoryTagAirhub;
      default:
        return tag;
    }
  }

  String _actionTypeLabel(String rawActionType) {
    final t = _l10n;
    switch (rawActionType.toLowerCase()) {
      case 'patrol':
        return t.territoryActionPatrol;
      case 'intel_scan':
        return t.territoryActionIntelScan;
      case 'sabotage':
        return t.territoryActionSabotage;
      case 'supply_run':
        return t.territoryActionSupplyRun;
      case 'raid':
        return t.territoryActionRaid;
      case 'defense':
        return t.territoryActionDefense;
      default:
        return rawActionType;
    }
  }

  String _bonusSourceLabel(String rawSource) {
    final t = _l10n;
    switch (rawSource.toLowerCase()) {
      case 'strategic-tag':
        return t.territoryBonusStrategicRegion;
      case 'adjacency':
        return t.territoryBonusAdjacentSupport;
      case 'war-aftermath':
        return t.territoryBonusWarPressure;
      case 'hq-level':
        return t.territoryBonusHqLevel;
      case 'crew-mission-level':
        return t.territoryBonusCrewMissionLevel;
      case 'crew-building':
        return t.territoryBonusCrewBuildings;
      case 'region-project':
        return t.territoryBonusRegionProject;
      case 'garrison':
        return t.territoryBonusGarrison;
      case 'arsenal':
        return t.territoryBonusArsenal;
      case 'region-event':
        return t.territoryBonusOther;
      default:
        return t.territoryBonusOther;
    }
  }

  Map<String, int> _actionUnlockHqLevels(Map<String, dynamic> region) {
    final raw = region['actionUnlockHqLevels'];
    if (raw is! Map) {
      return const <String, int>{
        'patrol': 0,
        'intel_scan': 0,
        'sabotage': 0,
        'supply_run': 0,
        'raid': 0,
        'defense': 0,
      };
    }
    return <String, int>{
      'patrol': (raw['patrol'] as num?)?.toInt() ?? 0,
      'intel_scan': (raw['intel_scan'] as num?)?.toInt() ?? 0,
      'sabotage': (raw['sabotage'] as num?)?.toInt() ?? 0,
      'supply_run': (raw['supply_run'] as num?)?.toInt() ?? 0,
      'raid': (raw['raid'] as num?)?.toInt() ?? 0,
      'defense': (raw['defense'] as num?)?.toInt() ?? 0,
    };
  }

  int _actionBasePoints(String rawActionType) {
    switch (rawActionType.toLowerCase()) {
      case 'patrol':
        return 4;
      case 'intel_scan':
        return 3;
      case 'sabotage':
        return 8;
      case 'supply_run':
        return 5;
      case 'raid':
        return 12;
      case 'defense':
        return 6;
      default:
        return 4;
    }
  }

  String _strategicBonusesByActionLabel(List<dynamic> rawBonuses) {
    final orderedActionTypes = <String>[
      'patrol',
      'intel_scan',
      'sabotage',
      'supply_run',
      'raid',
      'defense',
    ];
    final pointsByAction = <String, int>{};
    final sourceLabelsByAction = <String, Map<String, int>>{};
    final sourceTypesByAction = <String, Map<String, int>>{};

    for (final rawBonus in rawBonuses) {
      if (rawBonus is! Map) continue;
      final actionType = (rawBonus['actionType'] as String?)
          ?.trim()
          .toLowerCase();
      if (actionType == null || actionType.isEmpty) continue;
      final bonusPoints = (rawBonus['bonusPoints'] as num?)?.toInt() ?? 0;
      if (bonusPoints <= 0) continue;
      final sourceLabel = _bonusApiLabel(rawBonus);
      final sourceType = (rawBonus['source'] as String?)?.trim().toLowerCase();
      if (sourceLabel.isEmpty) continue;

      pointsByAction.update(
        actionType,
        (current) => current + bonusPoints,
        ifAbsent: () => bonusPoints,
      );
      final sourceLabelMap = sourceLabelsByAction.putIfAbsent(
        actionType,
        () => <String, int>{},
      );
      sourceLabelMap.update(
        sourceLabel,
        (current) => current + bonusPoints,
        ifAbsent: () => bonusPoints,
      );
      if (sourceType != null && sourceType.isNotEmpty) {
        final sourceTypeMap = sourceTypesByAction.putIfAbsent(
          actionType,
          () => <String, int>{},
        );
        sourceTypeMap.update(
          sourceType,
          (current) => current + bonusPoints,
          ifAbsent: () => bonusPoints,
        );
      }
    }

    if (pointsByAction.isEmpty) return '';

    final actionLabels = <String>[];
    for (final actionType in orderedActionTypes) {
      final totalPoints = pointsByAction[actionType];
      if (totalPoints == null || totalPoints <= 0) continue;
      final sourceLabelMap =
          sourceLabelsByAction[actionType] ?? const <String, int>{};
      final sourceLabel = sourceLabelMap.entries
          .where((entry) => entry.value > 0)
          .map((entry) => '+${entry.value} ${entry.key}')
          .join(', ');
      final sourceTypeMap =
          sourceTypesByAction[actionType] ?? const <String, int>{};
      final sourceTypeLabel = sourceTypeMap.entries
          .where((entry) => entry.value > 0)
          .map((entry) => '+${entry.value} ${_bonusSourceLabel(entry.key)}')
          .join(', ');
      final details = [
        sourceTypeLabel,
        sourceLabel,
      ].where((entry) => entry.trim().isNotEmpty).join(' | ');
      final basePoints = _actionBasePoints(actionType);
      final totalPointsWithBase = basePoints + totalPoints;
      final pointsLogicLabel = _l10n.territoryPointsLogicLine(
        basePoints,
        totalPoints,
        totalPointsWithBase,
      );
      actionLabels.add(
        details.isEmpty
            ? '${_actionTypeLabel(actionType)}: $pointsLogicLabel'
            : '${_actionTypeLabel(actionType)}: $pointsLogicLabel ($details)',
      );
    }

    return actionLabels.join('\n');
  }

  _SvgRegionShape? _shapeForRegion(Map<String, dynamic> region) {
    final svgElementId = (region['svgElementId'] as String?)?.trim();
    if (svgElementId == null || svgElementId.isEmpty) return null;

    for (final shape in _svgRegionShapes) {
      if (shape.id.toLowerCase() == svgElementId.toLowerCase()) {
        return shape;
      }
    }
    return null;
  }

  String _territoryErrorMessage(Object? rawEvent) {
    final t = _l10n;
    final event = rawEvent?.toString() ?? '';
    switch (event) {
      case 'error.not_in_crew':
        return t.territoryErrorNotInCrew;
      case 'territory.contest_already_active':
        return t.territoryErrorContestAlreadyActive;
      case 'territory.crew_contest_limit_reached':
        return t.territoryErrorCrewContestLimit;
      case 'territory.regions_cap_reached':
        return t.territoryErrorRegionsCap;
      case 'territory.contest_not_active':
        return t.territoryErrorContestNotActive;
      case 'territory.action_cooldown':
        return t.territoryErrorActionCooldown;
      case 'territory.action_role_mismatch':
        return t.territoryErrorActionRoleMismatch;
      case 'territory.hq_level_required':
        return t.territoryErrorHqLevelRequired;
      case 'territory.daily_cap_reached':
        return t.territoryErrorDailyCap;
      case 'territory.action_outside_current_country':
        return t.territoryErrorWrongCountry;
      case 'territory.project_hq_level_required':
        return t.territoryErrorProjectHq;
      case 'territory.project_not_owner':
        return t.territoryErrorProjectNotOwner;
      case 'territory.project_already_exists':
        return t.territoryErrorProjectExists;
      case 'territory.project_not_found':
        return t.territoryErrorProjectNotFound;
      case 'territory.project_destroyed':
        return t.territoryErrorProjectDestroyed;
      case 'territory.project_already_active':
        return t.territoryErrorProjectActive;
      case 'territory.project_contribute_cooldown':
        return t.territoryErrorProjectCooldown;
      case 'territory.project_invalid_type':
        return t.territoryErrorProjectInvalidType;
      case 'territory.project_tag_mismatch':
        return t.territoryErrorProjectTagMismatch;
      case 'territory.garrison_not_owner':
        return t.territoryErrorGarrisonNotOwner;
      case 'territory.garrison_already_active':
        return t.territoryErrorGarrisonAlreadyActive;
      case 'territory.garrison_crew_limit':
        return t.territoryErrorGarrisonCrewLimit;
      case 'territory.garrison_hq_level_required':
        return t.territoryErrorGarrisonHq;
      case 'territory.garrison_insufficient_funds':
        return t.territoryErrorGarrisonFunds;
      case 'territory.region_encircled':
        return t.territoryErrorRegionEncircled;
      case 'territory.arsenal_officer_only':
        return t.territoryErrorArsenalOfficerOnly;
      case 'territory.arsenal_cache_required':
        return t.territoryErrorArsenalCacheRequired;
      case 'territory.arsenal_not_owner':
        return t.territoryErrorArsenalNotOwner;
      case 'territory.arsenal_cache_full':
        return t.territoryErrorArsenalCacheFull;
      case 'territory.arsenal_insufficient_stock':
        return t.territoryErrorArsenalInsufficientStock;
      case 'territory.arsenal_recall_locked':
        return t.territoryErrorArsenalRecallLocked;
      case 'territory.arsenal_invalid_quantity':
        return t.territoryErrorArsenalInvalidQuantity;
      case 'territory.arsenal_weapon_storage_full':
        return t.territoryErrorArsenalWeaponStorageFull;
      case 'territory.arsenal_ammo_storage_full':
        return t.territoryErrorArsenalAmmoStorageFull;
      case 'territory.hold_not_owner':
        return t.territoryErrorHoldNotOwner;
      case 'territory.hold_not_due':
        return t.territoryErrorHoldNotDue;
      case 'territory.hold_contest_active':
        return t.territoryErrorHoldContestActive;
      default:
        return event.isEmpty ? t.territoryErrorUnknown : event;
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
      case 'territory.action_cooldown':
        return true;
      default:
        return false;
    }
  }

  Widget _buildInfoNotice(
    String text, {
    Color? borderColor,
    Color? backgroundColor,
    IconData icon = Icons.info_outline,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.blueGrey.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: borderColor ?? Colors.blueGrey.withValues(alpha: 0.28),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 1),
            child: Icon(
              icon,
              size: 16,
              color: borderColor ?? Colors.blueGrey.shade700,
            ),
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

  List<String> _buildMapAssetCandidates(
    String countryCode,
    String? svgAssetKey,
  ) {
    final candidates = <String>[];

    if (svgAssetKey != null && svgAssetKey.trim().isNotEmpty) {
      final key = svgAssetKey.trim();
      if (key.startsWith('assets/')) {
        candidates.add(key.toLowerCase().endsWith('.svg') ? key : '$key.svg');
      } else {
        final normalized = key.toLowerCase().endsWith('.svg')
            ? key
            : '$key.svg';
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

  Future<String?> _loadSvgTemplateForCountry(
    String countryCode,
    String? svgAssetKey,
  ) async {
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
    final lang = Localizations.localeOf(context).languageCode.toLowerCase();
    final label = lang == 'nl'
        ? (country['displayNameNl'] as String?)
        : (country['displayNameEn'] as String?);
    if (label != null && label.trim().isNotEmpty) {
      return label.trim();
    }
    return (country['countryCode'] as String?)?.toUpperCase() ??
        _selectedCountryCode.toUpperCase();
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
    if (viewBoxParts == null ||
        viewBoxParts.length != 4 ||
        viewBoxParts.any((v) => v == null)) {
      return null;
    }

    final minX = viewBoxParts[0]!;
    final minY = viewBoxParts[1]!;
    final width = viewBoxParts[2]!;
    final height = viewBoxParts[3]!;
    if (width <= 0 || height <= 0) return null;

    final pathTagRegex = RegExp(
      r'<path\b[^>]*>',
      caseSensitive: false,
      dotAll: true,
    );
    final shapes = <_SvgRegionShape>[];

    for (final match in pathTagRegex.allMatches(svg)) {
      final tag = match.group(0);
      if (tag == null) continue;

      final id = _extractSvgAttr(tag, 'id');
      final d = _extractSvgAttr(tag, 'd');
      if (id == null || id.trim().isEmpty || d == null || d.trim().isEmpty) {
        continue;
      }

      final name = _extractSvgAttr(tag, 'data-name')?.trim();

      try {
        final path = parseSvgPathData(d);
        shapes.add(_SvgRegionShape(id: id.trim(), name: name, path: path));
      } catch (_) {
        // Ignore malformed individual paths and continue.
      }
    }

    if (shapes.isEmpty) return null;
    return _SvgMapParseResult(
      viewBox: Rect.fromLTWH(minX, minY, width, height),
      shapes: shapes,
    );
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
    final destination = Alignment.center.inscribe(
      fitted.destination,
      Offset.zero & renderSize,
    );
    if (!destination.contains(local) ||
        destination.width <= 0 ||
        destination.height <= 0) {
      return null;
    }

    final dx = (local.dx - destination.left) / destination.width;
    final dy = (local.dy - destination.top) / destination.height;
    return Offset(
      viewBox.left + (dx * viewBox.width),
      viewBox.top + (dy * viewBox.height),
    );
  }

  _SvgRegionShape? _findShapeAtLocalPoint(Offset local, Size renderSize) {
    final viewBox = _svgViewBox;
    if (viewBox == null || _svgRegionShapes.isEmpty) return null;

    final svgPoint = _localToSvgPoint(
      local: local,
      renderSize: renderSize,
      viewBox: viewBox,
    );
    if (svgPoint == null) return null;

    for (var i = _svgRegionShapes.length - 1; i >= 0; i--) {
      if (_svgRegionShapes[i].path.contains(svgPoint)) {
        return _svgRegionShapes[i];
      }
    }
    return null;
  }

  Map<String, dynamic>? _findRegionBySvgElementId(
    List<dynamic> regions,
    String svgElementId,
  ) {
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

  String _regionDisplayName(
    Map<String, dynamic>? region,
    _SvgRegionShape shape,
  ) {
    if (region == null) return shape.name ?? shape.id;
    final lang = Localizations.localeOf(context).languageCode.toLowerCase();
    if (lang == 'nl') {
      return (region['nameNl'] as String? ??
          region['regionKey'] as String? ??
          shape.name ??
          shape.id);
    }
    return (region['nameEn'] as String? ??
        region['regionKey'] as String? ??
        shape.name ??
        shape.id);
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
      _renderedSvgMap = _renderSvgWithOwnership(
        (_mapData['regions'] as List<dynamic>?) ?? const <dynamic>[],
      );
    });
  }

  void _handleMapHover(
    PointerHoverEvent event,
    Size renderSize,
    List<dynamic> regions,
  ) {
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
      _renderedSvgMap = _renderSvgWithOwnership(
        (_mapData['regions'] as List<dynamic>?) ?? const <dynamic>[],
      );
    });
  }

  void _handleMapHoverExit() {
    _mapTooltipTimer?.cancel();
    _updateHoveredRegion(null, clearTooltip: true);
  }

  void _handleMapTap(
    Offset localPosition,
    Size renderSize,
    List<dynamic> regions,
  ) {
    final hit = _findShapeAtLocalPoint(localPosition, renderSize);
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
      _mapTooltipOffset = localPosition;
      _renderedSvgMap = _renderSvgWithOwnership(
        (_mapData['regions'] as List<dynamic>?) ?? const <dynamic>[],
      );
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

  void _handleMapPointerDown(PointerDownEvent event) {
    _activeMapPointers += 1;
    if (_activeMapPointers == 1) {
      _mapPointerDownPosition = event.localPosition;
      _mapPointerMoved = false;
      _maxMapPointersDuringGesture = 1;
      return;
    }

    _maxMapPointersDuringGesture = math.max(
      _maxMapPointersDuringGesture,
      _activeMapPointers,
    );
    _mapPointerMoved = true;
  }

  void _handleMapPointerMove(PointerMoveEvent event) {
    final pointerDownPosition = _mapPointerDownPosition;
    if (pointerDownPosition == null || _mapPointerMoved) return;
    if ((event.localPosition - pointerDownPosition).distance > 12) {
      _mapPointerMoved = true;
    }
  }

  void _handleMapPointerEnd() {
    _activeMapPointers = math.max(0, _activeMapPointers - 1);
    if (_activeMapPointers == 0) {
      _mapPointerDownPosition = null;
      _mapPointerMoved = false;
      _maxMapPointersDuringGesture = 0;
    }
  }

  void _handleMapPointerUp(
    PointerUpEvent event,
    Size renderSize,
    List<dynamic> regions,
  ) {
    final shouldTreatAsTap =
        _activeMapPointers == 1 &&
        _maxMapPointersDuringGesture == 1 &&
        !_mapPointerMoved;
    final pointerDownPosition = _mapPointerDownPosition;
    _handleMapPointerEnd();

    if (!shouldTreatAsTap || pointerDownPosition == null) {
      return;
    }

    if ((event.localPosition - pointerDownPosition).distance > 12) {
      return;
    }

    _handleMapTap(event.localPosition, renderSize, regions);
  }

  void _handleMapPointerCancel(PointerCancelEvent event) {
    _handleMapPointerEnd();
  }

  void _resetMapTransform() {
    _mapTransformController.value = Matrix4.identity();
  }

  Future<void> _showRegionDetailModal(Map<String, dynamic> region) async {
    if (_isRegionSheetOpen) return;

    _regionDetailNotifier.value = region;
    unawaited(_maybeSilentRefreshExpiredTimers());

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
                        return ValueListenableBuilder<DateTime>(
                          valueListenable: _nowNotifier,
                          builder: (context, now, _) {
                            return _buildRegionDetail(
                              liveRegion,
                              onClose: () =>
                                  Navigator.of(sheetContext).pop(),
                              now: now,
                            );
                          },
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
      if (mounted) {
        setState(() {
          _isRegionSheetOpen = false;
          _selectedRegion = null;
        });
      }
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
    final overlayChunks = <String>[];
    for (final shape in shapes) {
      final region = regionBySvgId[shape.id.toLowerCase()];
      var fillHex = region != null ? _hexColorForRegion(region) : '#D1D5DB';
      if (_hoveredSvgElementId?.toLowerCase() == shape.id.toLowerCase()) {
        fillHex = _darkenHex(fillHex, 0.18);
      }
      final strokeWidth = _strokeWidthForRegion(region);
      svg = _applyRegionStyleToElement(
        svg,
        shape.id,
        fillHex,
        strokeHex: '#000000',
        strokeWidth: strokeWidth,
      );
      if (region != null) {
        final marker = _buildSvgOverlayMarker(shape, region);
        if (marker != null) overlayChunks.add(marker);
      }
    }
    if (overlayChunks.isNotEmpty) {
      final overlayGroup =
          '<g id="territory-fase-e-overlays" pointer-events="none">${overlayChunks.join()}</g>';
      final closeIdx = svg.toLowerCase().lastIndexOf('</svg>');
      if (closeIdx >= 0) {
        svg = '${svg.substring(0, closeIdx)}$overlayGroup${svg.substring(closeIdx)}';
      }
    }
    return svg;
  }

  String _strokeWidthForRegion(Map<String, dynamic>? region) {
    if (region == null) return '1.1';
    final ownerAdjacent =
        (region['ownerAdjacentOwnedRegions'] as num?)?.toInt() ??
            (region['adjacentOwnedRegions'] as num?)?.toInt() ??
            0;
    final ownerCrewId = region['ownerCrewId'];
    if (ownerCrewId == null) return '1.1';
    if (ownerAdjacent >= 2) return '2.4';
    if (ownerAdjacent <= 1) return '0.85';
    return '1.1';
  }

  String? _buildSvgOverlayMarker(
    _SvgRegionShape shape,
    Map<String, dynamic> region,
  ) {
    final bounds = shape.path.getBounds();
    if (bounds.isEmpty) return null;
    final cx = bounds.center.dx;
    final cy = bounds.center.dy;
    final parts = <String>[];
    final contestStatus = (region['contestStatus'] as String?)?.toLowerCase();
    final contestLive = contestStatus != null &&
        contestStatus != 'resolved' &&
        contestStatus != 'cancelled';
    if (_overlayContest && contestLive) {
      final atk = (region['contestAttackerPoints'] as num?)?.toInt() ?? 0;
      final def = (region['contestDefenderPoints'] as num?)?.toInt() ?? 0;
      parts.add(
        '<circle cx="$cx" cy="${cy - 10}" r="9" fill="#111827" fill-opacity="0.82" stroke="#F59E0B" stroke-width="1.2"/>'
        '<text x="$cx" y="${cy - 7}" text-anchor="middle" font-size="7" fill="#FDE68A" font-family="Arial,sans-serif">$atk:$def</text>',
      );
    }
    final project = (region['regionProject'] as Map?)?.cast<String, dynamic>();
    final projectStatus = project?['status'] as String?;
    if (_overlayProject &&
        project != null &&
        projectStatus != null &&
        projectStatus != 'destroyed') {
      final type = project['projectType'] as String? ?? '';
      final letter = switch (type) {
        'surveillance_grid' => 'V',
        'arms_cache' => 'W',
        _ => 'S',
      };
      final color = switch (projectStatus) {
        'damaged' => '#F97316',
        'building' => '#EAB308',
        _ => '#14B8A6',
      };
      parts.add(
        '<circle cx="${cx - 11}" cy="${cy + 10}" r="7" fill="$color" stroke="#111827" stroke-width="0.9"/>'
        '<text x="${cx - 11}" y="${cy + 13}" text-anchor="middle" font-size="8" fill="#111827" font-family="Arial,sans-serif" font-weight="700">$letter</text>',
      );
    }
    if (_overlayEvent && region['regionEvent'] != null) {
      parts.add(
        '<circle cx="${cx + 11}" cy="${cy + 10}" r="7" fill="#7C3AED" stroke="#111827" stroke-width="0.9"/>'
        '<text x="${cx + 11}" y="${cy + 13}" text-anchor="middle" font-size="9" fill="#F8FAFC" font-family="Arial,sans-serif" font-weight="700">!</text>',
      );
    }
    final warPressure = (region['activeWarPressure'] as Map?)?.cast<String, dynamic>();
    if (_overlayWar && warPressure != null) {
      final role = (warPressure['regionRole'] as String?) ?? 'target';
      final letter = role == 'theater' ? 'T' : (role == 'adjacent' ? 'F' : 'W');
      final color = role == 'theater' ? '#DC2626' : '#F97316';
      parts.add(
        '<circle cx="$cx" cy="${cy + 22}" r="7" fill="$color" stroke="#111827" stroke-width="0.9"/>'
        '<text x="$cx" y="${cy + 25}" text-anchor="middle" font-size="8" fill="#FFF7ED" font-family="Arial,sans-serif" font-weight="700">$letter</text>',
      );
    }
    final garrison = (region['garrison'] as Map?)?.cast<String, dynamic>();
    if (garrison?['active'] == true) {
      parts.add(
        '<circle cx="${cx + 22}" cy="${cy - 10}" r="7" fill="#64748B" stroke="#111827" stroke-width="0.9"/>'
        '<text x="${cx + 22}" y="${cy - 7}" text-anchor="middle" font-size="8" fill="#F8FAFC" font-family="Arial,sans-serif" font-weight="700">G</text>',
      );
    }
    if (region['encircled'] == true) {
      parts.add(
        '<circle cx="${cx - 22}" cy="${cy - 10}" r="7" fill="#0F172A" stroke="#94A3B8" stroke-width="0.9"/>'
        '<text x="${cx - 22}" y="${cy - 7}" text-anchor="middle" font-size="8" fill="#E2E8F0" font-family="Arial,sans-serif" font-weight="700">I</text>',
      );
    }
    final badge = (region['arsenalBadge'] as Map?)?.cast<String, dynamic>();
    if (badge?['hasCache'] == true) {
      final level = (badge?['fillLevel'] as String?) ?? 'empty';
      final color = switch (level) {
        'full' => '#22C55E',
        'half' => '#EAB308',
        _ => '#64748B',
      };
      parts.add(
        '<circle cx="${cx + 22}" cy="${cy + 22}" r="6" fill="$color" stroke="#111827" stroke-width="0.8"/>'
        '<text x="${cx + 22}" y="${cy + 25}" text-anchor="middle" font-size="7" fill="#0F172A" font-family="Arial,sans-serif" font-weight="700">A</text>',
      );
    }
    if (region['holdDueAt'] != null) {
      parts.add(
        '<circle cx="${cx - 22}" cy="${cy + 22}" r="7" fill="#F59E0B" stroke="#111827" stroke-width="0.9"/>'
        '<text x="${cx - 22}" y="${cy + 25}" text-anchor="middle" font-size="8" fill="#111827" font-family="Arial,sans-serif" font-weight="700">P</text>',
      );
    } else if (region['holdUnrest'] == true) {
      parts.add(
        '<circle cx="${cx - 22}" cy="${cy + 22}" r="7" fill="#B91C1C" stroke="#111827" stroke-width="0.9"/>'
        '<text x="${cx - 22}" y="${cy + 25}" text-anchor="middle" font-size="8" fill="#FEF2F2" font-family="Arial,sans-serif" font-weight="700">U</text>',
      );
    }
    if (parts.isEmpty) return null;
    return '<g>${parts.join()}</g>';
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
    if (contestStatus != null &&
        contestStatus != 'resolved' &&
        contestStatus != 'cancelled') {
      return '#F59E0B';
    }

    final ownerCrewId = region['ownerCrewId'];
    if (ownerCrewId == null) {
      return '#D1D5DB';
    }

    final crewId = ownerCrewId is num
        ? ownerCrewId.toInt()
        : int.tryParse(ownerCrewId.toString());
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
      if (ownerCrewIdRaw == null ||
          ownerCrewName == null ||
          ownerCrewName.isEmpty) {
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
      _TerritoryLegendEntry(
        label: _l10n.territoryLegendUnderContest,
        colorHex: '#F59E0B',
      ),
      _TerritoryLegendEntry(
        label: _l10n.territoryLegendNeutral,
        colorHex: '#D1D5DB',
      ),
      _TerritoryLegendEntry(
        label: _l10n.territoryLegendPocket,
        colorHex: '#9CA3AF',
      ),
      _TerritoryLegendEntry(
        label: _l10n.territoryLegendCluster,
        colorHex: '#374151',
      ),
      _TerritoryLegendEntry(
        label: _l10n.territoryArsenalLegendEmpty,
        colorHex: '#64748B',
      ),
      _TerritoryLegendEntry(
        label: _l10n.territoryArsenalLegendHalf,
        colorHex: '#EAB308',
      ),
      _TerritoryLegendEntry(
        label: _l10n.territoryArsenalLegendFull,
        colorHex: '#22C55E',
      ),
      _TerritoryLegendEntry(
        label: _l10n.territoryLegendHoldDue,
        colorHex: '#F59E0B',
      ),
      _TerritoryLegendEntry(
        label: _l10n.territoryLegendHoldUnrest,
        colorHex: '#B91C1C',
      ),
      ...crewEntries,
    ];
  }

  Widget _buildLegendChip(_TerritoryLegendEntry entry) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.45),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: _colorFromHex(entry.colorHex),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            entry.label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
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
    final tagRegex = RegExp(
      '(<[^>]*\\bid="$escapedId"[^>]*>)',
      caseSensitive: false,
    );

    return svg.replaceFirstMapped(tagRegex, (match) {
      final tag = match.group(1) ?? '';

      if (tag.contains('style="')) {
        final styleRegex = RegExp('style="([^"]*)"', caseSensitive: false);
        return tag.replaceFirstMapped(styleRegex, (styleMatch) {
          var styleValue = styleMatch.group(1) ?? '';
          if (RegExp(
            r'(^|;)\s*fill\s*:',
            caseSensitive: false,
          ).hasMatch(styleValue)) {
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

          if (RegExp(
            r'(^|;)\s*stroke\s*:',
            caseSensitive: false,
          ).hasMatch(styleValue)) {
            styleValue = styleValue.replaceAllMapped(
              RegExp(r'(^|;)\s*stroke\s*:[^;]*', caseSensitive: false),
              (m) => '${m.group(1) ?? ';'}stroke:$strokeHex',
            );
          } else {
            styleValue = '$styleValue stroke:$strokeHex;';
          }

          if (RegExp(
            r'(^|;)\s*stroke-width\s*:',
            caseSensitive: false,
          ).hasMatch(styleValue)) {
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
        updatedTag = updatedTag.replaceFirst(
          RegExp('fill="[^"]*"', caseSensitive: false),
          'fill="$fillHex"',
        );
      } else {
        updatedTag = updatedTag.replaceFirst('>', ' fill="$fillHex">');
      }

      if (RegExp('\\sstroke="', caseSensitive: false).hasMatch(updatedTag)) {
        updatedTag = updatedTag.replaceFirst(
          RegExp('stroke="[^"]*"', caseSensitive: false),
          'stroke="$strokeHex"',
        );
      } else {
        updatedTag = updatedTag.replaceFirst('>', ' stroke="$strokeHex">');
      }

      if (RegExp(
        '\\sstroke-width="',
        caseSensitive: false,
      ).hasMatch(updatedTag)) {
        updatedTag = updatedTag.replaceFirst(
          RegExp('stroke-width="[^"]*"', caseSensitive: false),
          'stroke-width="$strokeWidth"',
        );
      } else {
        updatedTag = updatedTag.replaceFirst(
          '>',
          ' stroke-width="$strokeWidth">',
        );
      }

      return updatedTag;
    });
  }

  // â”€â”€ Build â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  @override
  Widget build(BuildContext context) {
    return JailGate(
      embedded: widget.embedded,
      child: GamePageInfoHost(
        topicId: 'territory',
        showOverlay: false,
        child: _buildPageInfoChild(context),
      ),
    );
  }

  Widget _buildPageInfoChild(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final showCountryPicker = !_isLoading &&
        _isTerritoryEnabled &&
        _countries.length > 1 &&
        !(_loadError != null && _mapData.isEmpty);

    Widget body;
    TabBar? tabBar;
    if (_isLoading) {
      body = const Center(child: CircularProgressIndicator());
    } else if (_loadError != null && _mapData.isEmpty) {
      body = MobileLoadError(
        message: _loadError!,
        onRetry: () => _loadData(reloadCountries: true),
      );
    } else if (!_isTerritoryEnabled) {
      body = Center(
        child: Text(
          t.territoryUnavailableMessage,
          style: const TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        ),
      );
    } else {
      tabBar = empireGoldTabBar(
        controller: _tabController,
        tabs: [
          Tab(text: t.territoryTabMap),
          Tab(text: t.territoryTabLeaderboard),
          Tab(text: t.territoryTabSeason),
        ],
      );
      body = TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: [_buildMapTab(), _buildLeaderboardTab(), _buildSeasonTab()],
      );
    }

    return EmpireHubScaffold(
      embedded: widget.embedded,
      title: t.territory,
      imageAsset: 'assets/images/backgrounds/login_background.png',
      topicId: 'territory',
      onRefresh: _isLoading ? null : _loadData,
      refreshEnabled: !_isLoading,
      fallbackIcon: Icons.map,
      extraHeaderSlivers: [
        if (showCountryPicker)
          SliverToBoxAdapter(child: _buildCountryPickerBar(t)),
      ],
      tabBar: tabBar,
      body: body,
    );
  }

  Widget _buildCountryPickerBar(AppLocalizations t) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      child: Material(
        color: kEmpireBgMid,
        child: Row(
          children: [
            const Icon(Icons.language, color: kEmpireGold, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _currentCountryLabel(),
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            PopupMenuButton<String>(
              tooltip: t.territorySelectCountryTooltip,
              icon: const Icon(Icons.arrow_drop_down, color: kEmpireGold),
              onSelected: (countryCode) {
                if (countryCode == _selectedCountryCode) return;
                setState(() {
                  _selectedRegion = null;
                  _userPickedCountry = true;
                });
                _loadData(countryCode: countryCode);
              },
              itemBuilder: (context) => _countries
                  .map((country) {
                    final countryCode =
                        ((country['countryCode'] as String?) ?? '')
                            .toLowerCase();
                    return PopupMenuItem<String>(
                      value: countryCode,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            countryCode == _selectedCountryCode
                                ? Icons.language
                                : Icons.flag,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              _countryDisplayName(country),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  })
                  .toList(growable: false),
            ),
          ],
        ),
      ),
    );
  }

  // â”€â”€ Map Tab â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  Widget _buildMapTab() {
    final regions = (_mapData['regions'] as List<dynamic>?) ?? [];
    final viewerCaps = (_mapData['viewerCaps'] as Map?)?.cast<String, dynamic>();

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          if (viewerCaps != null) _buildViewerCapsChips(viewerCaps),
          _buildHoldDutyChip(),
          _buildNextActionChip(),
          if (_crewTerritory != null) _buildCrewStatsCard(_crewTerritory!),
          _buildSvgMapOverview(regions),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
            child: Text(
              _l10n.territoryMapHintTapMain,
              style: TextStyle(color: Colors.grey[700], fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextActionChip() {
    return ValueListenableBuilder<DateTime>(
      valueListenable: _nowNotifier,
      builder: (context, now, _) {
        final nextAt = _soonestViewerUnlockAt(now);
        if (nextAt == null) return const SizedBox.shrink();
        final remaining = nextAt.difference(now);
        final ready = remaining.isNegative || remaining.inSeconds <= 0;
        final label = ready
            ? _l10n.territoryMapActionsReady
            : _l10n.territoryMapNextUnlock(_formatLiveDuration(remaining));
        return Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
          child: Chip(
            avatar: Icon(
              ready ? Icons.lock_open : Icons.timer_outlined,
              size: 16,
              color: ready ? Colors.green[200] : Colors.amber[200],
            ),
            label: Text(label),
            backgroundColor: const Color(0xFF1E1414),
            side: BorderSide(
              color: ready ? Colors.green.shade700 : Colors.amber.shade800,
            ),
          ),
        );
      },
    );
  }

  Widget _buildHoldDutyChip() {
    return ValueListenableBuilder<DateTime>(
      valueListenable: _nowNotifier,
      builder: (context, now, _) {
        final regions = (_mapData['regions'] as List<dynamic>?) ?? [];
        Map<String, dynamic>? dueRegion;
        for (final raw in regions) {
          if (raw is! Map) continue;
          final region = Map<String, dynamic>.from(raw);
          if (region['holdDueAt'] == null) continue;
          if (!_isMyCrewRegion(region)) continue;
          dueRegion = region;
          break;
        }
        if (dueRegion == null) return const SizedBox.shrink();
        final dueAt = _parseApiDate(dueRegion['holdDueAt']);
        final remaining = dueAt == null ? '' : _countdownLabel(dueAt, now);
        final name = _localizedRegionNameFromMap(dueRegion);
        return Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
          child: Chip(
            avatar: Icon(
              Icons.directions_walk,
              size: 16,
              color: Colors.amber[200],
            ),
            label: Text(_l10n.territoryHoldDashboardChip(name, remaining)),
            backgroundColor: const Color(0xFF1E1414),
            side: BorderSide(color: Colors.amber.shade800),
          ),
        );
      },
    );
  }

  DateTime? _soonestViewerUnlockAt(DateTime now) {
    final regions = (_mapData['regions'] as List<dynamic>?) ?? [];
    DateTime? soonest;
    for (final raw in regions) {
      if (raw is! Map) continue;
      final region = Map<String, dynamic>.from(raw);
      final status = (region['contestStatus'] as String?)?.toLowerCase();
      final contestStartedAt = _parseApiDate(region['contestStartedAt']);
      final prepMinutes =
          (_overview['config']?['contestPrepMinutes'] as num?)?.toInt() ?? 0;
      if (status == 'preparing') {
        final contestActiveAt = _contestTimestampFromFallback(
          startedAt: contestStartedAt,
          primary: _parseApiDate(region['contestActiveAt']),
          offsetMinutes: prepMinutes,
        );
        if (contestActiveAt != null &&
            (soonest == null || contestActiveAt.isBefore(soonest))) {
          soonest = contestActiveAt;
        }
      }
      final cooldownUntil = _parseApiDate(region['viewerCooldownUntil']);
      if (cooldownUntil != null &&
          cooldownUntil.isAfter(now) &&
          (soonest == null || cooldownUntil.isBefore(soonest))) {
        soonest = cooldownUntil;
      }
    }
    return soonest;
  }

  Widget _buildViewerCapsChips(Map<String, dynamic> viewerCaps) {
    final owned = (viewerCaps['ownedRegions'] as num?)?.toInt() ?? 0;
    final maxRegions =
        (viewerCaps['effectiveMaxRegions'] as num?)?.toInt() ?? 0;
    final active = (viewerCaps['activeContests'] as num?)?.toInt() ?? 0;
    final maxContests =
        (viewerCaps['effectiveMaxContests'] as num?)?.toInt() ?? 0;
    final hqSlots = (viewerCaps['hqSlots'] as num?)?.toInt() ?? maxRegions;
    final memberSlots =
        (viewerCaps['memberSlots'] as num?)?.toInt() ?? maxRegions;
    final memberCount = (viewerCaps['memberCount'] as num?)?.toInt() ?? 0;
    final nextHqLevel = (viewerCaps['nextHqLevel'] as num?)?.toInt();
    final nextMemberCount = (viewerCaps['nextMemberCount'] as num?)?.toInt();
    final hardCap = (viewerCaps['regionHardCap'] as num?)?.toInt() ?? 10;
    final breakdown = _territoryCapsBreakdown(
      hqSlots: hqSlots,
      memberSlots: memberSlots,
      memberCount: memberCount,
      nextHqLevel: nextHqLevel,
      nextMemberCount: nextMemberCount,
      hardCap: hardCap,
      effectiveMax: maxRegions,
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      child: Semantics(
        label:
            '${_l10n.territoryCapsLine(owned, maxRegions, active, maxContests)}. $breakdown',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildCapChip(
                  icon: Icons.map_outlined,
                  label: _l10n.territoryCapsRegionsChip(owned, maxRegions),
                  used: owned,
                  max: maxRegions,
                ),
                _buildCapChip(
                  icon: Icons.gavel_outlined,
                  label: _l10n.territoryCapsContestsChip(active, maxContests),
                  used: active,
                  max: maxContests,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              breakdown,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 12,
                height: 1.35,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _territoryCapsBreakdown({
    required int hqSlots,
    required int memberSlots,
    required int memberCount,
    required int? nextHqLevel,
    required int? nextMemberCount,
    required int hardCap,
    required int effectiveMax,
  }) {
    final parts = <String>[
      _l10n.territoryCapsHqSlots(hqSlots),
      _l10n.territoryCapsMemberSlots(memberSlots),
    ];
    if (effectiveMax >= hardCap) {
      parts.add(_l10n.territoryCapsAtHardCap);
      return parts.join(' · ');
    }
    final membersLimit = memberSlots <= hqSlots;
    final hqLimits = hqSlots <= memberSlots;
    if (membersLimit &&
        nextMemberCount != null &&
        nextMemberCount > memberCount) {
      parts.add(
        _l10n.territoryCapsNextMembers(
          nextMemberCount - memberCount,
          memberSlots + 1,
        ),
      );
    }
    if (hqLimits && nextHqLevel != null) {
      parts.add(_l10n.territoryCapsNextHq(nextHqLevel, hqSlots + 1));
    }
    return parts.join(' · ');
  }

  Widget _buildCapChip({
    required IconData icon,
    required String label,
    required int used,
    required int max,
  }) {
    final atCap = max > 0 && used >= max;
    final nearCap = max > 0 && !atCap && used >= (max * 0.8).ceil();
    final accent = atCap
        ? Colors.red.shade700
        : nearCap
            ? Colors.amber.shade800
            : const Color(0xFFB8860B);
    final bg = atCap
        ? Colors.red.shade50
        : nearCap
            ? Colors.amber.shade50
            : const Color(0xFFFFF8E7);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: accent.withValues(alpha: 0.55)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: accent),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: accent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectMeter({
    required String label,
    required int value,
    required int max,
    required Color color,
    bool asPercent = false,
  }) {
    final safeMax = max <= 0 ? 1 : max;
    final ratio = (value / safeMax).clamp(0.0, 1.0);
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                asPercent ? '$value%' : '$value / $max',
                style: TextStyle(
                  color: Colors.grey.shade800,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 8,
              backgroundColor: Colors.grey.shade300,
              color: color,
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
              _l10n.territoryMapOverviewTitle(_currentCountryLabel()),
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
                  child: LayoutBuilder(
                    builder: (context, mapConstraints) {
                      final mapWidth = mapConstraints.maxWidth;
                      final allowMapZoom = _mapPinchZoomEnabled();
                      _resetMapTransformIfNeeded(allowZoom: allowMapZoom);

                      return Stack(
                        children: [
                          Positioned.fill(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: InteractiveViewer(
                                transformationController:
                                    _mapTransformController,
                                minScale: 1,
                                maxScale: allowMapZoom ? 6 : 1,
                                panEnabled: allowMapZoom,
                                scaleEnabled: allowMapZoom,
                                constrained: false,
                                boundaryMargin: EdgeInsets.symmetric(
                                  horizontal: mapWidth,
                                  vertical: mapHeight,
                                ),
                                child: SizedBox(
                                  width: mapWidth,
                                  height: mapHeight,
                                  child: MouseRegion(
                                    onHover: (event) => _handleMapHover(
                                      event,
                                      Size(mapWidth, mapHeight),
                                      regions,
                                    ),
                                    onExit: (_) => _handleMapHoverExit(),
                                    child: Listener(
                                      behavior: HitTestBehavior.opaque,
                                      onPointerDown: _handleMapPointerDown,
                                      onPointerMove: _handleMapPointerMove,
                                      onPointerUp: (event) =>
                                          _handleMapPointerUp(
                                            event,
                                            Size(mapWidth, mapHeight),
                                            regions,
                                          ),
                                      onPointerCancel: _handleMapPointerCancel,
                                      child: Stack(
                                        children: [
                                          Positioned.fill(
                                            child: SvgPicture.string(
                                              svgMarkup,
                                              fit: BoxFit.contain,
                                              placeholderBuilder: (_) =>
                                                  const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                            ),
                                          ),
                                          if (_mapTooltipLabel != null &&
                                              _mapTooltipOffset != null)
                                            Positioned(
                                              left: (_mapTooltipOffset!.dx + 10)
                                                  .clamp(8, mapWidth - 180),
                                              top: (_mapTooltipOffset!.dy - 36)
                                                  .clamp(8, mapHeight - 32),
                                              child: Container(
                                                constraints:
                                                    const BoxConstraints(
                                                      maxWidth: 170,
                                                    ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 6,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: Colors.black87,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Text(
                                                  _mapTooltipLabel!,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                );
                final allowMapZoomHint = _mapPinchZoomEnabled();
                final infoWidget = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _l10n.territoryMapHintTapPanel,
                    ),
                    if (allowMapZoomHint) ...[
                      const SizedBox(height: 8),
                      Text(
                        _l10n.territoryMapHintMobile,
                        style: TextStyle(color: Colors.grey[700], fontSize: 12),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Text(
                      _l10n.territoryMapHintColors,
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        FilterChip(
                          label: Text(_l10n.territoryOverlayContest),
                          selected: _overlayContest,
                          onSelected: (value) {
                            setState(() {
                              _overlayContest = value;
                              _renderedSvgMap = _renderSvgWithOwnership(
                                (_mapData['regions'] as List<dynamic>?) ??
                                    const [],
                              );
                            });
                          },
                        ),
                        FilterChip(
                          label: Text(_l10n.territoryOverlayProject),
                          selected: _overlayProject,
                          onSelected: (value) {
                            setState(() {
                              _overlayProject = value;
                              _renderedSvgMap = _renderSvgWithOwnership(
                                (_mapData['regions'] as List<dynamic>?) ??
                                    const [],
                              );
                            });
                          },
                        ),
                        FilterChip(
                          label: Text(_l10n.territoryOverlayEvent),
                          selected: _overlayEvent,
                          onSelected: (value) {
                            setState(() {
                              _overlayEvent = value;
                              _renderedSvgMap = _renderSvgWithOwnership(
                                (_mapData['regions'] as List<dynamic>?) ??
                                    const [],
                              );
                            });
                          },
                        ),
                        FilterChip(
                          label: Text(_l10n.territoryOverlayWar),
                          selected: _overlayWar,
                          onSelected: (value) {
                            setState(() {
                              _overlayWar = value;
                              _renderedSvgMap = _renderSvgWithOwnership(
                                (_mapData['regions'] as List<dynamic>?) ??
                                    const [],
                              );
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _l10n.territoryLegendTitle,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: legendEntries
                          .map(_buildLegendChip)
                          .toList(growable: false),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _l10n.territoryYourCrewLine(_myCrewName ?? '-'),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
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
                      Expanded(flex: 3, child: mapWidget),
                    ],
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [mapWidget, const SizedBox(height: 8), infoWidget],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegionDetail(
    Map<String, dynamic> region, {
    VoidCallback? onClose,
    DateTime? now,
  }) {
    final clock = now ?? _nowNotifier.value;
    final regionName = _localizedRegionNameFromMap(region);
    final ownerName = region['ownerCrewName'] as String?;
    final stability = (region['stability'] as num?)?.toInt() ?? 100;
    final controlPercent = (region['controlPercent'] as num?)?.toDouble() ?? 0;
    final contestId = region['contestId'] as int?;
    final contestStatus = region['contestStatus'] as String?;
    final contestRole = region['viewerContestRole'] as String?;
    final attackerCrewName = region['attackerCrewName'] as String?;
    final defenderCrewName = region['defenderCrewName'] as String?;
    final contestStartedAt = _parseApiDate(region['contestStartedAt']);
    final prepMinutes =
        (_overview['config']?['contestPrepMinutes'] as num?)?.toInt() ?? 0;
    final activeMinutes =
        (_overview['config']?['contestActiveMinutes'] as num?)?.toInt() ?? 0;
    final lockdownMinutes =
        (_overview['config']?['contestLockdownMinutes'] as num?)?.toInt() ?? 0;
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
    final viewerCooldownUntil = _parseApiDate(region['viewerCooldownUntil']);
    final viewerCooldownSecondsRemaining = viewerCooldownUntil != null
        ? viewerCooldownUntil.difference(clock).inSeconds
        : ((region['viewerCooldownSecondsRemaining'] as num?)?.toInt() ?? 0);
    final holdDueAt = _parseApiDate(region['holdDueAt']);
    final holdMissStreak = (region['holdMissStreak'] as num?)?.toInt() ?? 0;
    final holdIncomePercent =
        (region['holdIncomePercent'] as num?)?.toInt() ?? 100;
    final holdUnrest = region['holdUnrest'] == true;
    final holdCanAct = region['holdCanAct'] == true;
    final tier = (region['valueTier'] as num?)?.toInt() ?? 1;
    final isMyCrewRegion = _isMyCrewRegion(region);
    final encircled = region['encircled'] == true;
    final contestHint = _contestHint(contestStatus);
    final isAttacker = contestRole == 'attacker';
    final isDefender = contestRole == 'defender';
    final canActInSelectedCountry = _canActInSelectedCountry();
    final playerCountryLabel = _countryDisplayNameByCode(
      _currentTerritoryCountryCode(),
    );
    final hasContest = contestId != null && contestStatus != null;
    final incomeTierLabel = _valueTierLabel(tier);
    final passiveIncomeCash =
        (region['passiveIncomeCash'] as num?)?.toInt() ?? 0;
    final passiveIncomeCashHourly =
        (region['passiveIncomeCashHourly'] as num?)?.toInt() ??
        passiveIncomeCash;
    final passiveIncomeCashDaily =
        (region['passiveIncomeCashDaily'] as num?)?.toInt() ??
        (passiveIncomeCashHourly * 24);
    final passiveIncomeIntervalMinutes =
        (region['passiveIncomeIntervalMinutes'] as num?)?.toInt() ?? 60;
    final strategicTags =
        ((region['strategicTags'] as List<dynamic>?) ?? const <dynamic>[])
            .map((tag) => _strategicTagLabel(tag.toString()))
            .where((tag) => tag.trim().isNotEmpty)
            .toList(growable: false);
    final adjacentOwnedRegions =
        (region['adjacentOwnedRegions'] as num?)?.toInt() ?? 0;
    final strategicActionBonuses =
        (region['strategicActionBonuses'] as List<dynamic>?) ??
        const <dynamic>[];
    final viewerHqGlobalLevel =
        (region['viewerHqGlobalLevel'] as num?)?.toInt() ?? 0;
    final actionUnlockHqLevels = _actionUnlockHqLevels(region);
    final strategicBonusesLabel = _strategicBonusesByActionLabel(
      strategicActionBonuses,
    );
    final effectiveStability =
        (region['effectiveStability'] as num?)?.toInt() ?? stability;
    final activeWarPressure = (region['activeWarPressure'] as Map?)
        ?.cast<String, dynamic>();
    final warPressureEndsAt = _parseApiDate(activeWarPressure?['endsAt']);
    final warPressureBonus =
        (activeWarPressure?['attackBonusPoints'] as num?)?.toInt() ?? 0;
    final warPressurePenalty =
        (activeWarPressure?['stabilityPenalty'] as num?)?.toInt() ?? 0;
    final warPressureRegionRole =
        (activeWarPressure?['regionRole'] as String?) ?? 'target';
    final warPressureCrewName =
        (activeWarPressure?['favoredCrewName'] as String?) ??
        activeWarPressure?['favoredCrewId']?.toString();
    final regionProject =
        (region['regionProject'] as Map?)?.cast<String, dynamic>();
    final regionEvent =
        (region['regionEvent'] as Map?)?.cast<String, dynamic>();
    final projectIncomeBonusPercent =
        (region['projectIncomeBonusPercent'] as num?)?.toInt() ??
        (regionProject?['incomeBonusPercent'] as num?)?.toInt() ??
        0;
    final projectStatus = regionProject?['status'] as String?;
    final projectProgress = (regionProject?['progress'] as num?)?.toInt() ?? 0;
    final projectHp = (regionProject?['hp'] as num?)?.toInt() ?? 0;
    final projectMaxHp = (regionProject?['maxHp'] as num?)?.toInt() ?? 100;
    final projectOptions =
        ((region['projectOptions'] as List<dynamic>?) ?? const <dynamic>[])
            .whereType<Map>()
            .map((item) => item.cast<String, dynamic>())
            .toList(growable: false);
    final canManageProject =
        isMyCrewRegion && _hasCrew && canActInSelectedCountry && !_isActing;
    final canStartProject =
        canManageProject &&
        contestStatus == null &&
        (regionProject == null || projectStatus == 'destroyed');
    final canContributeProject =
        canManageProject &&
        contestStatus == null &&
        regionProject != null &&
        (projectStatus == 'building' || projectStatus == 'damaged');
    DateTime? projectContributeUntil = _parseApiDate(
      regionProject?['projectContributeUntil'],
    );
    if (projectContributeUntil == null) {
      final nextAt = _parseApiDate(regionProject?['nextContributeAt']);
      if (nextAt != null && nextAt.isAfter(clock)) {
        projectContributeUntil = nextAt;
      } else {
        final lastContributeAt =
            _parseApiDate(regionProject?['lastContributeAt']);
        if (lastContributeAt != null &&
            _projectContributeCooldownSeconds > 0) {
          final candidate = lastContributeAt.add(
            Duration(seconds: _projectContributeCooldownSeconds),
          );
          if (candidate.isAfter(clock)) {
            projectContributeUntil = candidate;
          }
        }
      }
    }
    final projectContributeRemaining = projectContributeUntil == null
        ? 0
        : projectContributeUntil.difference(clock).inSeconds;
    final projectContributeOnCooldown = projectContributeRemaining > 0;
    final contestAttackerPoints =
        (region['contestAttackerPoints'] as num?)?.toInt() ?? 0;
    final contestDefenderPoints =
        (region['contestDefenderPoints'] as num?)?.toInt() ?? 0;
    final projectTypeKey = regionProject?['projectType'] as String?;
    final garrison = (region['garrison'] as Map?)?.cast<String, dynamic>();
    final garrisonOffer =
        (region['garrisonOffer'] as Map?)?.cast<String, dynamic>();
    final garrisonActive = garrison?['active'] == true;
    final garrisonEndsAt = _parseApiDate(garrison?['endsAt']);
    final garrisonDefenseBonus =
        (garrison?['defenseBonusPoints'] as num?)?.toInt() ??
        (garrisonOffer?['defenseBonusPoints'] as num?)?.toInt() ??
        0;
    final garrisonCaptureBonus =
        (garrison?['captureThresholdBonus'] as num?)?.toInt() ??
        (garrisonOffer?['captureThresholdBonus'] as num?)?.toInt() ??
        0;
    final garrisonCost = (garrisonOffer?['cashCost'] as num?)?.toInt() ?? 0;
    final garrisonHours = (garrisonOffer?['hours'] as num?)?.toInt() ?? 8;
    final garrisonMinHq = (garrisonOffer?['minHqLevel'] as num?)?.toInt() ?? 0;
    final garrisonHqLocked =
        isMyCrewRegion &&
        _hasCrew &&
        canActInSelectedCountry &&
        !garrisonActive &&
        viewerHqGlobalLevel < garrisonMinHq;
    final canDeployGarrison =
        isMyCrewRegion &&
        _hasCrew &&
        canActInSelectedCountry &&
        !garrisonActive &&
        !garrisonHqLocked;
    final regionShape = _shapeForRegion(region);
    final regionPreview = regionShape == null
        ? null
        : _buildRegionPreviewCard(
            region: region,
            regionName: regionName,
            regionShape: regionShape,
            ownerName: ownerName,
            contestStatus: contestStatus,
          );
    final attackerActions = const <String>['intel_scan', 'sabotage', 'raid'];
    final defenderActions = const <String>['patrol', 'supply_run', 'defense'];
    final lockedAttackerActions = attackerActions
        .where((actionType) {
          final required = actionUnlockHqLevels[actionType] ?? 0;
          return required > viewerHqGlobalLevel;
        })
        .toList(growable: false);
    final lockedDefenderActions = defenderActions
        .where((actionType) {
          final required = actionUnlockHqLevels[actionType] ?? 0;
          return required > viewerHqGlobalLevel;
        })
        .toList(growable: false);

    final t = _l10n;
    final detailContent = <Widget>[
      if (hasContest) ...[
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.amber.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.amber.shade700),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                t.territoryContestHudTitle,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                t.territoryContestHudScore(
                  contestAttackerPoints,
                  contestDefenderPoints,
                ),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              Text(
                '${t.territoryDetailContestStatus}: ${_displayContestStatus(contestStatus)}',
              ),
              if (contestRole != null)
                Text(
                  '${t.territoryDetailYourRole}: ${_displayContestRole(contestRole)}',
                ),
              if (contestStatus == 'preparing')
                Text(
                  '${t.territoryDetailActionsUnlockIn}: ${_countdownLabel(contestActiveAt, clock)}',
                ),
              if (contestStatus == 'active')
                Text(
                  '${t.territoryDetailActionsCloseIn}: ${_countdownLabel(contestLockdownAt, clock)}',
                ),
              Text(
                '${t.territoryDetailContestEndsIn}: ${_countdownLabel(contestResolveAt, clock)}',
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
      ],
      _detailRow(
        t.territoryDetailOwner,
        ownerName ?? t.territoryDetailNeutral,
      ),
      _detailRow(t.territoryDetailStability, '$stability%'),
      if (effectiveStability != stability)
        _detailRow(
          t.territoryDetailEffectiveStability,
          '$effectiveStability%',
        ),
      _detailRow(
        t.territoryDetailControl,
        '${controlPercent.toStringAsFixed(controlPercent.truncateToDouble() == controlPercent ? 0 : 1)}%',
      ),
      _detailRow(
        t.territoryDetailValueTier,
        '$incomeTierLabel (${('⭐' * tier)})',
      ),
      _detailRow(
        t.territoryDetailPayout,
        '${formatCurrency(passiveIncomeCash)} · ${_incomeIntervalLabel(passiveIncomeIntervalMinutes)}',
      ),
      if (strategicTags.isNotEmpty)
        _detailRow(
          t.territoryDetailStrategicRole,
          strategicTags.join(' · '),
        ),
      if (adjacentOwnedRegions > 0)
        _detailRow(
          t.territoryDetailAdjacentOwned,
          '$adjacentOwnedRegions',
        ),
      ..._buildArsenalSection(region),
      if (strategicBonusesLabel.isNotEmpty)
        _detailRow(
          t.territoryDetailActionBonuses,
          strategicBonusesLabel,
        ),
      if (strategicBonusesLabel.isNotEmpty)
        _detailRow(
          t.territoryDetailBonusInfo,
          t.territoryDetailBonusInfoBody,
        ),
      if (activeWarPressure != null)
        _detailRow(
          t.territoryDetailWarPressure,
          '${warPressureCrewName ?? t.unknown} · +$warPressureBonus ${t.territoryDetailAttackPressure} · -$warPressurePenalty ${t.territoryDetailStabilityWord} · ${warPressureRegionRole == 'theater'
              ? t.territoryWarRoleTheater
              : warPressureRegionRole == 'adjacent'
              ? t.territoryWarRoleAdjacent
              : t.territoryWarRoleTarget}',
        ),
      if (activeWarPressure != null && warPressureEndsAt != null)
        _detailRow(
          t.territoryWarPressureEndsIn,
          _countdownLabel(warPressureEndsAt, clock),
        ),
      _detailRow(
        t.territoryDetailIncomeHour,
        formatCurrency(passiveIncomeCashHourly),
      ),
      _detailRow(
        t.territoryDetailIncomeDay,
        formatCurrency(passiveIncomeCashDaily),
      ),
      if (holdDueAt != null || holdUnrest || holdMissStreak > 0) ...[
        _detailRow(
          t.territoryHoldDueTitle,
          holdDueAt != null
              ? t.territoryHoldDueLine(regionName, _countdownLabel(holdDueAt, clock))
              : t.territoryHoldIncomeCut(holdIncomePercent),
        ),
        if (holdIncomePercent < 100)
          _detailRow(
            t.territoryHoldUnrestBadge,
            t.territoryHoldIncomeCut(holdIncomePercent),
          ),
        if (holdUnrest || holdMissStreak >= 2)
          Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 4),
            child: _buildInfoNotice(
              t.territoryHoldUnrestLine,
              borderColor: Colors.red.shade700,
              backgroundColor: Colors.red.withValues(alpha: 0.12),
              icon: Icons.warning_amber_outlined,
            ),
          ),
        if (holdDueAt != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 4),
            child: _buildInfoNotice(
              t.territoryHoldPatrolHint,
              borderColor: Colors.amber.shade700,
              backgroundColor: Colors.amber.withValues(alpha: 0.12),
              icon: Icons.directions_walk,
            ),
          ),
      ],
      if (regionProject != null) ...[
        _detailRow(
          t.territoryDetailProject,
          '${_projectTypeLabel(projectTypeKey)} · ${_projectStatusLabel(projectStatus)}'
          '${projectIncomeBonusPercent > 0 ? ' · ${t.territoryProjectIncomeBonusPct(projectIncomeBonusPercent)}' : ''}',
        ),
        if (projectStatus == 'building')
          _buildProjectMeter(
            label: t.territoryProjectProgress,
            value: projectProgress.clamp(0, 100),
            max: 100,
            color: Colors.amber.shade700,
            asPercent: true,
          ),
        if (projectStatus == 'active' || projectStatus == 'damaged')
          _buildProjectMeter(
            label: t.territoryProjectHp,
            value: projectHp.clamp(0, projectMaxHp),
            max: projectMaxHp,
            color: projectStatus == 'damaged'
                ? Colors.orange.shade700
                : Colors.teal.shade700,
          ),
      ],
      if (garrisonActive)
        _detailRow(
          t.territoryGarrisonTitle,
          '${t.territoryGarrisonActiveUntil(_countdownLabel(garrisonEndsAt, clock))} · +$garrisonDefenseBonus / +$garrisonCaptureBonus',
        ),
      if (regionEvent != null)
        _detailRow(
          t.territoryDetailRegionEvent,
          _regionEventLabel(regionEvent),
        ),
      if (_myCrewName != null)
        _detailRow(t.territoryDetailYourCrew, _myCrewName!),
      if (contestStatus != null)
        _detailRow(
          t.territoryDetailContestStatus,
          _displayContestStatus(contestStatus),
        ),
      if (attackerCrewName != null)
        _detailRow(t.territoryRoleAttacker, attackerCrewName),
      if (defenderCrewName != null)
        _detailRow(t.territoryRoleDefender, defenderCrewName),
      if (contestRole != null)
        _detailRow(
          t.territoryDetailYourRole,
          _displayContestRole(contestRole),
        ),
      _detailRow(t.territoryDetailYourHqLevel, '$viewerHqGlobalLevel'),
      if (contestStatus == 'preparing')
        _detailRow(
          t.territoryDetailActionsUnlockIn,
          _countdownLabel(contestActiveAt, clock),
        ),
      if (contestStatus == 'active')
        _detailRow(
          t.territoryDetailActionsCloseIn,
          _countdownLabel(contestLockdownAt, clock),
        ),
      if (hasContest)
        _detailRow(
          t.territoryDetailContestEndsIn,
          _countdownLabel(contestResolveAt, clock),
        ),
      if (_actionCooldownSeconds > 0)
        _detailRow(
          t.territoryDetailCooldownPerAction,
          _formatDuration(Duration(seconds: _actionCooldownSeconds)),
        ),
      if (viewerCooldownSecondsRemaining > 0)
        _detailRow(
          t.territoryDetailYourCooldown,
          _formatLiveDuration(
            Duration(seconds: viewerCooldownSecondsRemaining),
          ),
        ),
      const SizedBox(height: 16),
      if (!_hasCrew)
        _buildInfoNotice(
          t.territoryNoticeCrewOnly,
          borderColor: Colors.orange.shade700,
          backgroundColor: Colors.orange.withValues(alpha: 0.1),
          icon: Icons.groups_rounded,
        ),
      if (_hasCrew && !canActInSelectedCountry)
        _buildInfoNotice(
          t.territoryNoticeWrongCountry(
            _currentCountryLabel(),
            playerCountryLabel,
          ),
          borderColor: Colors.blueGrey.shade700,
          backgroundColor: Colors.blueGrey.withValues(alpha: 0.08),
          icon: Icons.travel_explore,
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
      if (encircled)
        _buildInfoNotice(
          t.territoryNoticeEncircled,
          borderColor: Colors.blueGrey.shade800,
          backgroundColor: Colors.blueGrey.withValues(alpha: 0.1),
          icon: Icons.lock_outline,
        ),
      if (contestStatus == null && isMyCrewRegion)
        _buildInfoNotice(
          t.territoryNoticeOwnRegion,
          borderColor: Colors.green.shade700,
          backgroundColor: Colors.green.withValues(alpha: 0.1),
          icon: Icons.verified,
        ),
      if (isMyCrewRegion && contestStatus == null) ...[
        const SizedBox(height: 8),
        _buildInfoNotice(
          t.territoryProjectHint,
          borderColor: Colors.teal.shade700,
          backgroundColor: Colors.teal.withValues(alpha: 0.08),
          icon: Icons.home_work_outlined,
        ),
        if (canStartProject) ...[
          const SizedBox(height: 12),
          Text(
            t.territoryProjectPickTitle,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            t.territoryProjectPickSubtitle,
            style: TextStyle(color: Colors.grey[700], fontSize: 12),
          ),
          const SizedBox(height: 8),
          ..._buildProjectTypePicker(
            regionKey: region['regionKey'] as String,
            options: projectOptions,
          ),
        ],
        if (canContributeProject) ...[
          const SizedBox(height: 12),
          _buildActionButton(
            label: projectContributeOnCooldown
                ? '${t.territoryProjectContribute} · ${_formatLiveDuration(Duration(seconds: projectContributeRemaining))}'
                : t.territoryProjectContribute,
            icon: Icons.local_shipping_outlined,
            color: Colors.teal[700]!,
            onTap: projectContributeOnCooldown
                ? null
                : () => _contributeProject(region['regionKey'] as String),
            forceDisabled: projectContributeOnCooldown,
          ),
        ],
        ..._buildArsenalMoveButtons(region),
      ],
      if (isMyCrewRegion && (canDeployGarrison || garrisonHqLocked)) ...[
        const SizedBox(height: 12),
        _buildInfoNotice(
          t.territoryGarrisonDesc,
          borderColor: Colors.blueGrey.shade700,
          backgroundColor: Colors.blueGrey.withValues(alpha: 0.08),
          icon: Icons.security,
        ),
        const SizedBox(height: 12),
        _buildActionButton(
          label: garrisonHqLocked
              ? t.territoryHqButtonLocked(
                  t.territoryGarrisonDeploy,
                  garrisonMinHq,
                )
              : '${t.territoryGarrisonDeploy} · ${t.territoryGarrisonCostHours(formatCurrency(garrisonCost), garrisonHours)}',
          icon: Icons.military_tech_outlined,
          color: Colors.blueGrey[800]!,
          onTap: garrisonHqLocked
              ? null
              : () => _deployGarrison(
                  region['regionKey'] as String,
                  cashCost: garrisonCost,
                  hours: garrisonHours,
                ),
        ),
      ],
      if (contestStatus == 'preparing' &&
          isDefender &&
          canActInSelectedCountry) ...[
        _buildInfoNotice(
          t.territoryNoticeDefenderPrep,
          borderColor: Colors.blue.shade700,
          backgroundColor: Colors.blue.withValues(alpha: 0.1),
          icon: Icons.shield,
        ),
        const SizedBox(height: 12),
        _buildActionButton(
          label: t.territoryConfirmDefense,
          icon: Icons.shield,
          color: Colors.blue[700]!,
          onTap: () => _joinDefense(contestId),
        ),
      ],
      if (contestStatus == null &&
          _hasCrew &&
          !isMyCrewRegion &&
          canActInSelectedCountry &&
          !encircled)
        _buildActionButton(
          label: t.territoryAttack,
          icon: Icons.gps_fixed,
          color: Colors.red[700]!,
          onTap: () => _confirmStartContest(region['regionKey'] as String),
        ),
      if (contestId != null &&
          contestStatus == 'active' &&
          canActInSelectedCountry) ...[
        const SizedBox(height: 8),
        Text(
          isAttacker
              ? t.territoryAttackerActions
              : (isDefender
                    ? t.territoryDefenderActions
                    : t.territoryContestActions),
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            if (isAttacker) ...[
              _smallActionButton(
                t.territoryIntelShort,
                'intel_scan',
                contestId,
                requiredHqLevel: actionUnlockHqLevels['intel_scan'] ?? 0,
                viewerHqLevel: viewerHqGlobalLevel,
                region: region,
              ),
              _smallActionButton(
                t.territoryActionSabotage,
                'sabotage',
                contestId,
                requiredHqLevel: actionUnlockHqLevels['sabotage'] ?? 0,
                viewerHqLevel: viewerHqGlobalLevel,
                region: region,
              ),
              _smallActionButton(
                t.territoryActionRaid,
                'raid',
                contestId,
                requiredHqLevel: actionUnlockHqLevels['raid'] ?? 0,
                viewerHqLevel: viewerHqGlobalLevel,
                region: region,
              ),
            ],
            if (isDefender) ...[
              _smallActionButton(
                t.territoryActionPatrol,
                'patrol',
                contestId,
                requiredHqLevel: actionUnlockHqLevels['patrol'] ?? 0,
                viewerHqLevel: viewerHqGlobalLevel,
                region: region,
              ),
              _smallActionButton(
                t.territoryActionSupplyRun,
                'supply_run',
                contestId,
                requiredHqLevel: actionUnlockHqLevels['supply_run'] ?? 0,
                viewerHqLevel: viewerHqGlobalLevel,
                region: region,
              ),
              _smallActionButton(
                t.territoryActionDefense,
                'defense',
                contestId,
                requiredHqLevel: actionUnlockHqLevels['defense'] ?? 0,
                viewerHqLevel: viewerHqGlobalLevel,
                region: region,
              ),
            ],
          ],
        ),
        if (isAttacker && lockedAttackerActions.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: _buildInfoNotice(
              t.territoryHqLockedNotice(
                lockedAttackerActions.map(_actionTypeLabel).join(', '),
              ),
              borderColor: Colors.orange.shade700,
              backgroundColor: Colors.orange.withValues(alpha: 0.12),
              icon: Icons.lock_outline,
            ),
          ),
        if (isDefender && lockedDefenderActions.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: _buildInfoNotice(
              t.territoryHqLockedNotice(
                lockedDefenderActions.map(_actionTypeLabel).join(', '),
              ),
              borderColor: Colors.orange.shade700,
              backgroundColor: Colors.orange.withValues(alpha: 0.12),
              icon: Icons.lock_outline,
            ),
          ),
      ],
      if (contestId != null &&
          contestStatus == 'active' &&
          canActInSelectedCountry &&
          !isAttacker &&
          !isDefender)
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: _buildInfoNotice(
            t.territoryNotInContestNotice,
            borderColor: Colors.blueGrey.shade600,
            backgroundColor: Colors.blueGrey.withValues(alpha: 0.1),
            icon: Icons.lock_outline,
          ),
        ),
      if (contestId != null &&
          contestStatus == 'active' &&
          !canActInSelectedCountry)
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: _buildInfoNotice(
            t.territoryContestOtherCountryNotice(_currentCountryLabel()),
            borderColor: Colors.blueGrey.shade600,
            backgroundColor: Colors.blueGrey.withValues(alpha: 0.1),
            icon: Icons.lock_outline,
          ),
        ),
      if (holdCanAct && holdDueAt != null && !hasContest) ...[
        const SizedBox(height: 10),
        Text(
          t.territoryHoldDueTitle,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _smallHoldActionButton(
              t.territoryActionPatrol,
              'patrol',
              region,
              requiredHqLevel: actionUnlockHqLevels['patrol'] ?? 0,
              viewerHqLevel: viewerHqGlobalLevel,
            ),
            _smallHoldActionButton(
              t.territoryActionSupplyRun,
              'supply_run',
              region,
              requiredHqLevel: actionUnlockHqLevels['supply_run'] ?? 0,
              viewerHqLevel: viewerHqGlobalLevel,
            ),
          ],
        ),
        if (!canActInSelectedCountry)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: _buildInfoNotice(
              t.territoryErrorWrongCountry,
              borderColor: Colors.blueGrey.shade600,
              backgroundColor: Colors.blueGrey.withValues(alpha: 0.1),
              icon: Icons.lock_outline,
            ),
          ),
      ],
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWideLayout =
              constraints.maxWidth >= 760 && regionPreview != null;
          final detailsColumn = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!isWideLayout && regionPreview != null) ...[
                regionPreview,
                const SizedBox(height: 16),
              ],
              ...detailContent,
            ],
          );

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      regionName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (onClose != null)
                    IconButton(
                      icon: const Icon(Icons.close, size: 18),
                      onPressed: onClose,
                    ),
                ],
              ),
              const SizedBox(height: 8),
              if (isWideLayout)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 3, child: detailsColumn),
                    const SizedBox(width: 18),
                    Expanded(flex: 2, child: regionPreview),
                  ],
                )
              else
                detailsColumn,
            ],
          );
        },
      ),
    );
  }

  Widget _buildRegionPreviewCard({
    required Map<String, dynamic> region,
    required String regionName,
    required _SvgRegionShape regionShape,
    required String? ownerName,
    required String? contestStatus,
  }) {
    final fillColor = _colorFromHex(_hexColorForRegion(region));
    final accentColor =
        contestStatus != null &&
            contestStatus != 'resolved' &&
            contestStatus != 'cancelled'
        ? Colors.amber.shade700
        : fillColor;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accentColor.withValues(alpha: 0.55)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _l10n.territoryDetailRegionPreviewTitle,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            _l10n.territoryDetailRegionPreviewSubtitle,
            style: TextStyle(color: Colors.grey[600], fontSize: 11.5),
          ),
          const SizedBox(height: 12),
          AspectRatio(
            aspectRatio: 1.0,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    accentColor.withValues(alpha: 0.14),
                    Theme.of(context).colorScheme.surfaceContainerHighest
                        .withValues(alpha: 0.55),
                  ],
                ),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: Theme.of(context).dividerColor.withValues(alpha: 0.35),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: CustomPaint(
                  painter: _RegionShapePainter(
                    path: regionShape.path,
                    fillColor: fillColor,
                    strokeColor: Colors.black,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            regionName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            ownerName ?? _l10n.territoryNeutralTerritory,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.grey[700], fontSize: 12.5),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic>? _arsenalMap(Map<String, dynamic> region) {
    final raw = region['arsenal'];
    if (raw is Map) return raw.cast<String, dynamic>();
    return null;
  }

  Map<String, dynamic>? _arsenalPreview(
    Map<String, dynamic>? region,
    String actionType,
  ) {
    final arsenal = region == null ? null : _arsenalMap(region);
    final previews = arsenal?['actionPreviews'];
    if (previews is! List) return null;
    for (final raw in previews) {
      if (raw is! Map) continue;
      if ((raw['actionType'] as String?) == actionType) {
        return raw.cast<String, dynamic>();
      }
    }
    return null;
  }

  String? _arsenalCostLabel(Map<String, dynamic>? region, String actionType) {
    final preview = _arsenalPreview(region, actionType);
    if (preview == null) return null;
    final amount = (preview['ammoCost'] as num?)?.toInt() ?? 0;
    if (amount <= 0) return null;
    final ammoType = (preview['ammoType'] as String?) ?? 'ammo';
    return _l10n.territoryArsenalCost(amount, ammoType);
  }

  String? _arsenalFormulaLabel(Map<String, dynamic>? region, String actionType) {
    if (region == null) return null;
    final base = _actionBasePoints(actionType);
    final bonuses = region['strategicActionBonuses'];
    var bonus = 0;
    if (bonuses is List) {
      for (final raw in bonuses) {
        if (raw is! Map) continue;
        if ((raw['actionType'] as String?) != actionType) continue;
        bonus += (raw['bonusPoints'] as num?)?.toInt() ?? 0;
      }
    }
    if (bonus <= 0) return null;
    return _l10n.territoryArsenalFormula(base, bonus, base + bonus);
  }

  List<Widget> _buildArsenalSection(Map<String, dynamic> region) {
    final t = _l10n;
    final arsenal = _arsenalMap(region);
    if (arsenal == null) return const [];
    final fill = (arsenal['fillPercent'] as num?)?.toInt() ?? 0;
    final weapons = (arsenal['weapons'] as num?)?.toInt() ?? 0;
    final ammo = (arsenal['ammo'] as num?)?.toInt() ?? 0;
    final hqWeapons = (arsenal['hqWeapons'] as num?)?.toInt() ?? 0;
    final hqAmmo = (arsenal['hqAmmo'] as num?)?.toInt() ?? 0;
    final longSupply = arsenal['longSupply'] == true;
    final hasCache = arsenal['hasCache'] == true;
    return [
      const SizedBox(height: 8),
      Text(
        t.territoryArsenalTitle,
        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
      ),
      const SizedBox(height: 4),
      ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: LinearProgressIndicator(
          value: (fill / 100).clamp(0, 1),
          minHeight: 8,
          backgroundColor: Colors.blueGrey.withValues(alpha: 0.2),
          color: fill >= 70
              ? Colors.green
              : (fill <= 15 ? Colors.blueGrey : Colors.amber[700]),
        ),
      ),
      const SizedBox(height: 4),
      Text(t.territoryArsenalFill(fill), style: const TextStyle(fontSize: 12)),
      Text(
        t.territoryArsenalCache(weapons, ammo),
        style: const TextStyle(fontSize: 12),
      ),
      Text(
        t.territoryArsenalHq(hqWeapons, hqAmmo),
        style: const TextStyle(fontSize: 12),
      ),
      if (!hasCache || longSupply)
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            hasCache ? t.territoryArsenalLongSupply : t.territoryArsenalEmptyCache,
            style: TextStyle(fontSize: 12, color: Colors.orange[800]),
          ),
        ),
      Text(
        t.territoryArsenalWear,
        style: TextStyle(fontSize: 11.5, color: Colors.grey[700]),
      ),
    ];
  }

  List<Widget> _buildArsenalMoveButtons(Map<String, dynamic> region) {
    final arsenal = _arsenalMap(region);
    if (arsenal == null || arsenal['viewerIsOfficer'] != true) {
      return const [];
    }
    if (arsenal['hasCache'] != true) return const [];
    final t = _l10n;
    final regionKey = region['regionKey'] as String? ?? '';
    return [
      const SizedBox(height: 8),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          OutlinedButton.icon(
            icon: const Icon(Icons.south, size: 16),
            label: Text(t.territoryArsenalCommit),
            onPressed: _isActing
                ? null
                : () => _openArsenalMoveDialog(
                      regionKey: regionKey,
                      commit: true,
                      arsenal: arsenal,
                    ),
          ),
          OutlinedButton.icon(
            icon: const Icon(Icons.north, size: 16),
            label: Text(t.territoryArsenalRecall),
            onPressed: _isActing
                ? null
                : () => _openArsenalMoveDialog(
                      regionKey: regionKey,
                      commit: false,
                      arsenal: arsenal,
                    ),
          ),
        ],
      ),
    ];
  }

  Future<void> _openArsenalMoveDialog({
    required String regionKey,
    required bool commit,
    required Map<String, dynamic> arsenal,
  }) async {
    final t = _l10n;
    final rawStacks = commit ? arsenal['hqStacks'] : arsenal['cacheStacks'];
    final stacks = <Map<String, dynamic>>[];
    if (rawStacks is List) {
      for (final raw in rawStacks) {
        if (raw is Map) stacks.add(raw.cast<String, dynamic>());
      }
    }
    if (stacks.isEmpty) {
      showTopRightFromSnackBar(
        context,
        SnackBar(content: Text(t.territoryErrorArsenalInsufficientStock)),
      );
      return;
    }
    var selectedKey =
        '${stacks.first['kind']}:${stacks.first['itemKey']}';
    final quantityController = TextEditingController(text: '1');
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(
                commit ? t.territoryArsenalCommitTitle : t.territoryArsenalRecallTitle,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    value: selectedKey,
                    items: [
                      for (final stack in stacks)
                        DropdownMenuItem(
                          value: '${stack['kind']}:${stack['itemKey']}',
                          child: Text(
                            '${stack['kind'] == 'weapon' ? t.territoryArsenalKindWeapon : t.territoryArsenalKindAmmo}: ${stack['name']} (${stack['quantity']})',
                          ),
                        ),
                    ],
                    onChanged: (value) {
                      if (value == null) return;
                      setDialogState(() => selectedKey = value);
                    },
                    decoration: InputDecoration(labelText: t.territoryArsenalPickItem),
                  ),
                  TextField(
                    controller: quantityController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: t.territoryArsenalQuantity),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(t.cancel),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text(commit ? t.territoryArsenalCommit : t.territoryArsenalRecall),
                ),
              ],
            );
          },
        );
      },
    );
    final quantity = int.tryParse(quantityController.text.trim()) ?? 0;
    quantityController.dispose();
    if (confirmed != true || quantity <= 0) return;
    final parts = selectedKey.split(':');
    if (parts.length < 2) return;
    final kind = parts.first;
    final itemKey = parts.sublist(1).join(':');
    setState(() => _isActing = true);
    final result = commit
        ? await _service.commitArsenal(
            regionKey: regionKey,
            kind: kind,
            itemKey: itemKey,
            quantity: quantity,
          )
        : await _service.recallArsenal(
            regionKey: regionKey,
            kind: kind,
            itemKey: itemKey,
            quantity: quantity,
          );
    if (!mounted) return;
    setState(() => _isActing = false);
    if (result['success'] == true) {
      final moved = (result['moved'] as num?)?.toInt() ?? quantity;
      showTopRightFromSnackBar(
        context,
        SnackBar(content: Text(t.territoryArsenalMoved(moved))),
      );
      await _reloadOpenRegionOrMap();
      return;
    }
    showTopRightFromSnackBar(
      context,
      SnackBar(
        content: Text(_territoryErrorMessage(result['event'])),
        backgroundColor: Colors.red,
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    VoidCallback? onTap,
    bool forceDisabled = false,
  }) {
    final disabled = _isActing || onTap == null || forceDisabled;
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 16),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: disabled ? Colors.blueGrey.shade700 : color,
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.blueGrey.shade700,
          disabledForegroundColor: Colors.white70,
        ),
        onPressed: disabled ? null : onTap,
      ),
    );
  }

  Widget _smallActionButton(
    String label,
    String actionType,
    int contestId, {
    required int requiredHqLevel,
    required int viewerHqLevel,
    Map<String, dynamic>? region,
  }) {
    final t = _l10n;
    final isLocked = requiredHqLevel > viewerHqLevel;
    final costLabel = _arsenalCostLabel(region, actionType);
    final bonusLabel = _arsenalFormulaLabel(region, actionType);
    final buttonLabel = isLocked
        ? t.territoryHqButtonLocked(label, requiredHqLevel)
        : (costLabel == null ? label : '$label · $costLabel');
    final tooltipMessage = isLocked
        ? t.territoryHqTooltipLocked(requiredHqLevel, viewerHqLevel)
        : ([bonusLabel, costLabel].whereType<String>().join('\n'));
    final button = OutlinedButton(
      onPressed: _isActing || isLocked
          ? null
          : () => _doAction(contestId, actionType),
      child: Text(
        buttonLabel,
        style: const TextStyle(fontSize: 11),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
      ),
    );

    if (tooltipMessage.isEmpty) return button;
    return Tooltip(message: tooltipMessage, child: button);
  }

  Widget _smallHoldActionButton(
    String label,
    String actionType,
    Map<String, dynamic> region, {
    required int requiredHqLevel,
    required int viewerHqLevel,
  }) {
    final t = _l10n;
    final isLocked = requiredHqLevel > viewerHqLevel;
    final canAct = _canActInSelectedCountry();
    final costLabel = _arsenalCostLabel(region, actionType);
    final bonusLabel = _arsenalFormulaLabel(region, actionType);
    final buttonLabel = isLocked
        ? t.territoryHqButtonLocked(label, requiredHqLevel)
        : (costLabel == null ? label : '$label · $costLabel');
    final tooltipMessage = isLocked
        ? t.territoryHqTooltipLocked(requiredHqLevel, viewerHqLevel)
        : ([bonusLabel, costLabel].whereType<String>().join('\n'));
    final regionKey = (region['regionKey'] as String?) ?? '';
    final button = OutlinedButton(
      onPressed: _isActing || isLocked || !canAct || regionKey.isEmpty
          ? null
          : () => _doHoldAction(regionKey, actionType),
      child: Text(
        buttonLabel,
        style: const TextStyle(fontSize: 11),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
      ),
    );

    if (tooltipMessage.isEmpty) return button;
    return Tooltip(message: tooltipMessage, child: button);
  }

  // â”€â”€ Leaderboard Tab â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  String _formatHoldDuration(int seconds) {
    final t = _l10n;
    final safe = seconds < 0 ? 0 : seconds;
    final days = safe ~/ 86400;
    final hours = (safe % 86400) ~/ 3600;
    final minutes = (safe % 3600) ~/ 60;
    if (days > 0) return t.territoryHoldDurationDaysHours(days, hours);
    if (hours > 0) return t.territoryHoldDurationHoursMinutes(hours, minutes);
    return t.territoryHoldDurationMinutes(minutes);
  }

  Map<String, dynamic>? _statsMapFromEntry(
    Map<String, dynamic> entry, {
    required bool season,
  }) {
    final raw = season ? entry['season'] : entry['allTime'];
    if (raw is Map) return raw.cast<String, dynamic>();
    return null;
  }

  Widget _buildCrewStatsCard(Map<String, dynamic> crewTerritory) {
    final t = _l10n;
    final stats = (crewTerritory['stats'] as Map?)?.cast<String, dynamic>();
    if (stats == null) return const SizedBox.shrink();
    final allTime = (stats['allTime'] as Map?)?.cast<String, dynamic>();
    final season = (stats['season'] as Map?)?.cast<String, dynamic>();
    final currentHold = (stats['currentHoldSeconds'] as num?)?.toInt() ?? 0;
    final ownedNow = (stats['regionsOwned'] as num?)?.toInt() ?? 0;

    Widget scopeBlock(String title, Map<String, dynamic>? row) {
      if (row == null) {
        return Text('$title: -', style: TextStyle(color: Colors.grey[700]));
      }
      final won = (row['regionsWon'] as num?)?.toInt() ?? 0;
      final defended = (row['regionsDefended'] as num?)?.toInt() ?? 0;
      final lost = (row['regionsLost'] as num?)?.toInt() ?? 0;
      final contests = (row['contestsPlayed'] as num?)?.toInt() ?? 0;
      final hold = (row['holdSecondsTotal'] as num?)?.toInt() ?? 0;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(
            '${t.territoryStatsWon}: $won · ${t.territoryStatsDefended}: $defended · ${t.territoryStatsLost}: $lost',
          ),
          Text('${t.territoryStatsContests}: $contests'),
          Text(
            '${t.territoryStatsHoldTotal}: ${_formatHoldDuration(hold)}',
          ),
        ],
      );
    }

    return Card(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t.territoryStatsTitle,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
            ),
            const SizedBox(height: 8),
            Text(
              '${t.territoryStatsOwnedNow}: $ownedNow · ${t.territoryStatsHoldCurrent}: ${_formatHoldDuration(currentHold)}',
            ),
            const SizedBox(height: 10),
            scopeBlock(t.territoryStatsAllTime, allTime),
            if (season != null) ...[
              const SizedBox(height: 10),
              scopeBlock(t.territoryStatsSeason, season),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLeaderboardTab() {
    final t = _l10n;
    if (_leaderboard.isEmpty) {
      return Center(child: Text(t.territoryLeaderboardEmpty));
    }
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: SegmentedButton<bool>(
            segments: [
              ButtonSegment(
                value: false,
                label: Text(t.territoryLeaderboardScopeAllTime),
              ),
              ButtonSegment(
                value: true,
                label: Text(t.territoryLeaderboardScopeSeason),
              ),
            ],
            selected: {_leaderboardShowSeason},
            onSelectionChanged: (value) {
              setState(() => _leaderboardShowSeason = value.first);
            },
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: _leaderboard.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final entry = _leaderboard[i] as Map<String, dynamic>;
              final stats = _statsMapFromEntry(
                entry,
                season: _leaderboardShowSeason,
              );
              final won = (stats?['regionsWon'] as num?)?.toInt() ?? 0;
              final defended =
                  (stats?['regionsDefended'] as num?)?.toInt() ?? 0;
              final lost = (stats?['regionsLost'] as num?)?.toInt() ?? 0;
              final holdTotal =
                  (stats?['holdSecondsTotal'] as num?)?.toInt() ?? 0;
              final currentHold =
                  (entry['currentHoldSeconds'] as num?)?.toInt() ?? 0;
              final holdLabel = _leaderboardShowSeason
                  ? _formatHoldDuration(holdTotal + currentHold)
                  : _formatHoldDuration(holdTotal + currentHold);
              return ListTile(
                leading: CircleAvatar(
                  child: Text(
                    '${i + 1}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                title: Text(entry['crewName'] as String? ?? ''),
                subtitle: Text(
                  t.territoryLeaderboardStatsLine(
                    won,
                    defended,
                    lost,
                    holdLabel,
                  ),
                ),
                trailing: Text(
                  t.territoryLeaderboardRegionsCount(
                    (entry['regionsOwned'] as num?)?.toInt() ?? 0,
                  ),
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // â”€â”€ Season Tab â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  Widget _buildSeasonTab() {
    return ValueListenableBuilder<DateTime>(
      valueListenable: _nowNotifier,
      builder: (context, now, _) {
        return _buildSeasonTabBody(now);
      },
    );
  }

  Widget _buildSeasonTabBody(DateTime now) {
    final t = _l10n;
    final season = _overview['activeSeason'] as Map<String, dynamic>?;
    final drama = (_overview['drama'] as Map?)?.cast<String, dynamic>();
    final events =
        (drama?['activeRegionEvents'] as List<dynamic>?) ??
        (_overview['activeRegionEvents'] as List<dynamic>?) ??
        const [];
    final hottest =
        (drama?['hottestContests'] as List<dynamic>?) ?? const [];
    final captures =
        (drama?['recentCaptures'] as List<dynamic>?) ?? const [];
    final rising = (drama?['risingCrews'] as List<dynamic>?) ?? const [];
    final wars = (drama?['activeWarTheaters'] as List<dynamic>?) ?? const [];
    final hasDrama = hottest.isNotEmpty ||
        captures.isNotEmpty ||
        events.isNotEmpty ||
        rising.isNotEmpty ||
        wars.isNotEmpty;

    if (season == null && !hasDrama) {
      return Center(
        child: Text(t.territorySeasonNone, style: TextStyle(color: Colors.grey[400])),
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
      children: [
        if (season != null) _buildSeasonHeroCard(season, now),
        if (season != null) const SizedBox(height: 18),
        Text(
          t.territoryDramaTitle,
          style: const TextStyle(
            color: kEmpireGold,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 12),
        if (!hasDrama)
          _seasonEmptyCard(t.territoryDramaEmpty)
        else ...[
          if (captures.isNotEmpty)
            _seasonSection(
              icon: Icons.flag,
              title: t.territoryDramaRecentCaptures,
              children: [
                for (final raw in captures.whereType<Map>().take(5))
                  _seasonFeedTile(
                    icon: Icons.emoji_events_outlined,
                    accent: kEmpireGold,
                    title: t.territoryDramaCaptureTook(
                      (raw['winnerCrewName'] as String?)?.trim().isNotEmpty == true
                          ? raw['winnerCrewName'] as String
                          : t.unknown,
                      _dramaRegionName(raw),
                    ),
                    subtitle: _formatShortDate(raw['resolvedAt']),
                  ),
              ],
            ),
          if (events.isNotEmpty)
            _seasonSection(
              icon: Icons.bolt,
              title: t.territoryDramaRegionEvents,
              children: [
                for (final raw in events.whereType<Map>().take(5))
                  _seasonEventTile(Map<String, dynamic>.from(raw), now),
              ],
            ),
          if (hottest.isNotEmpty)
            _seasonSection(
              icon: Icons.local_fire_department,
              title: t.territoryDramaHotContests,
              children: [
                for (final raw in hottest.whereType<Map>().take(5))
                  _seasonFeedTile(
                    icon: Icons.whatshot,
                    accent: Colors.orange.shade400,
                    title: t.territoryDramaContestVs(
                      (raw['attackerCrewName'] as String?)?.trim().isNotEmpty == true
                          ? raw['attackerCrewName'] as String
                          : t.unknown,
                      (raw['defenderCrewName'] as String?)?.trim().isNotEmpty == true
                          ? raw['defenderCrewName'] as String
                          : t.territoryNeutralTerritory,
                    ),
                    subtitle: _dramaRegionName(raw),
                    trailing: _contestStatusChip(raw['status']?.toString()),
                  ),
              ],
            ),
          if (rising.isNotEmpty)
            _seasonSection(
              icon: Icons.trending_up,
              title: t.territoryDramaRisingCrews,
              children: [
                for (var i = 0; i < rising.length && i < 5; i++)
                  _seasonFeedTile(
                    icon: Icons.groups_2_outlined,
                    accent: const Color(0xFF8BC34A),
                    title: (rising[i] as Map)['crewName']?.toString() ?? t.unknown,
                    subtitle: t.territoryDramaRisingCaptures(
                      ((rising[i] as Map)['captures'] as num?)?.toInt() ?? 0,
                    ),
                    leadingLabel: '${i + 1}',
                  ),
              ],
            ),
          if (wars.isNotEmpty)
            _seasonSection(
              icon: Icons.military_tech_outlined,
              title: t.territoryDramaWarTheaters,
              children: [
                for (final raw in wars.whereType<Map>().take(5))
                  _seasonFeedTile(
                    icon: Icons.public,
                    accent: Colors.red.shade300,
                    title: t.territoryDramaContestVs(
                      (raw['attackerCrewName'] as String?)?.trim().isNotEmpty == true
                          ? raw['attackerCrewName'] as String
                          : t.unknown,
                      (raw['defenderCrewName'] as String?)?.trim().isNotEmpty == true
                          ? raw['defenderCrewName'] as String
                          : t.unknown,
                    ),
                    subtitle: _dramaRegionName(
                      raw,
                      fallbackKey: raw['theaterRegionKey']?.toString(),
                    ),
                  ),
              ],
            ),
        ],
      ],
    );
  }

  Widget _buildSeasonHeroCard(Map<String, dynamic> season, DateTime now) {
    final t = _l10n;
    final key = season['seasonKey'] as String? ?? '';
    final status = (season['status'] as String? ?? '').toLowerCase();
    final startsAt = _parseApiDate(season['startsAt']);
    final endsAt = _parseApiDate(season['endsAt']);
    final remaining = endsAt?.difference(now);
    final live = status == 'active';
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2A1616), Color(0xFF140A0A)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kEmpireGold.withValues(alpha: 0.45)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.calendar_month, color: kEmpireGold, size: 22),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _seasonPrettyTitle(key),
                  style: const TextStyle(
                    color: kEmpireGold,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              _seasonStatusChip(status),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            t.territorySeasonBlurb,
            style: TextStyle(color: Colors.grey[300], height: 1.35, fontSize: 13),
          ),
          if (live && remaining != null) ...[
            const SizedBox(height: 16),
            Text(
              t.territorySeasonEndsIn(_formatSeasonCountdown(remaining)),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
          if (startsAt != null) ...[
            const SizedBox(height: 8),
            Text(
              t.territorySeasonStartedOn(_formatShortDate(startsAt.toIso8601String()) ?? ''),
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }

  Widget _seasonStatusChip(String status) {
    final t = _l10n;
    final label = switch (status) {
      'active' => t.territorySeasonStatusActive,
      'closed' => t.territorySeasonStatusClosed,
      'scheduled' => t.territorySeasonStatusScheduled,
      _ => status,
    };
    final color = switch (status) {
      'active' => const Color(0xFF2E7D32),
      'closed' => Colors.grey,
      _ => Colors.blueGrey,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 12),
      ),
    );
  }

  Widget _contestStatusChip(String? status) {
    final raw = (status ?? '').toLowerCase();
    final label = switch (raw) {
      'preparing' => _l10n.territoryContestStatusPreparing,
      'active' => _l10n.territoryContestStatusActive,
      'lockdown' => _l10n.territoryContestStatusLockdown,
      _ => status ?? '',
    };
    if (label.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _seasonSection({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: kEmpireGold, size: 18),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }

  Widget _seasonEmptyCard(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1010),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Text(text, style: TextStyle(color: Colors.grey[500])),
    );
  }

  Widget _seasonFeedTile({
    required IconData icon,
    required Color accent,
    required String title,
    String? subtitle,
    Widget? trailing,
    String? leadingLabel,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1010),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accent.withValues(alpha: 0.28)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: accent.withValues(alpha: 0.18),
            child: leadingLabel != null
                ? Text(
                    leadingLabel,
                    style: TextStyle(color: accent, fontWeight: FontWeight.w800),
                  )
                : Icon(icon, color: accent, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                if (subtitle != null && subtitle.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(color: Colors.grey[400], fontSize: 12),
                  ),
                ],
              ],
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }

  Widget _seasonEventTile(Map<String, dynamic> event, DateTime now) {
    final t = _l10n;
    final attack = (event['attackBonusPoints'] as num?)?.toInt() ?? 0;
    final penalty = (event['incomePenaltyPercent'] as num?)?.toInt() ?? 0;
    final endsAt = _parseApiDate(event['endsAt']);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1010),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.flash_on, color: Colors.amber, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _regionEventTitle(event),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            _dramaRegionName(event),
            style: TextStyle(color: Colors.grey[300], fontSize: 13),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              if (attack > 0)
                _seasonInfoChip(t.territoryEventAttackBonusChip(attack)),
              if (penalty > 0)
                _seasonInfoChip(t.territoryEventIncomePenaltyChip(penalty)),
              if (endsAt != null)
                _seasonInfoChip(
                  t.territorySeasonEndsIn(_countdownLabel(endsAt, now)),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _seasonInfoChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }

  String _seasonPrettyTitle(String key) {
    final match = RegExp(r'^(\d{4})-(\d{2})$').firstMatch(key);
    if (match == null) return key;
    final year = int.tryParse(match.group(1)!);
    final month = int.tryParse(match.group(2)!);
    if (year == null || month == null || month < 1 || month > 12) return key;
    return MaterialLocalizations.of(context).formatMonthYear(DateTime(year, month));
  }

  String _formatSeasonCountdown(Duration remaining) {
    final safe = remaining.isNegative ? Duration.zero : remaining;
    if (safe.inDays >= 1) {
      return _l10n.territoryHoldDurationDaysHours(
        safe.inDays,
        safe.inHours.remainder(24),
      );
    }
    return _formatLiveDuration(safe);
  }

  String? _formatShortDate(dynamic raw) {
    final parsed = raw is DateTime ? raw.toLocal() : _parseApiDate(raw);
    if (parsed == null) return null;
    return MaterialLocalizations.of(context).formatMediumDate(parsed);
  }

  String _dramaRegionName(Map raw, {String? fallbackKey}) {
    final lang = Localizations.localeOf(context).languageCode.toLowerCase();
    final nl = raw['regionNameNl'] as String?;
    final en = raw['regionNameEn'] as String?;
    final key = (raw['regionKey'] as String?) ?? fallbackKey ?? '';
    if (lang == 'nl') return (nl?.trim().isNotEmpty == true) ? nl! : (en ?? key);
    return (en?.trim().isNotEmpty == true) ? en! : (nl ?? key);
  }

  String _regionEventTitle(Map<String, dynamic> event) {
    final key = (event['eventKey'] as String?) ?? 'event';
    return switch (key) {
      'police_offensive' => _l10n.territoryEventPoliceOffensive,
      'harbor_strike' => _l10n.territoryEventHarborStrike,
      'blackout_rumor' => _l10n.territoryEventBlackoutRumor,
      _ => key,
    };
  }

  // â”€â”€ Actions â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  Future<void> _confirmStartContest(String regionKey) async {
    final t = _l10n;
    final target = _findRegionByKey(regionKey);
    if (target?['encircled'] == true) {
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(t.territoryErrorRegionEncircled),
          backgroundColor: Colors.orange,
          duration: const Duration(seconds: 4),
        ),
      );
      return;
    }
    if (!_hasCrew) {
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(t.territorySnackJoinCrewFirst),
          backgroundColor: Colors.orange,
          duration: const Duration(seconds: 4),
        ),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(t.territoryDialogAttackTitle),
        content: Text(t.territoryDialogAttackBody(regionKey)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(t.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(t.territoryAttack),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    setState(() => _isActing = true);
    final result = await _service.startContest(regionKey);
    if (!mounted) return;
    setState(() => _isActing = false);

    if (result['success'] == true) {
      final contestStatus = _displayContestStatus(
        (result['status'] as String?) ?? 'preparing',
      );
      await _reloadRegionState(regionKey);
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(t.territorySnackContestStarted(contestStatus)),
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
            content: Text(t.territorySnackContestAlreadyLive(liveStatus)),
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
          content: Text(
            _l10n.territoryPointsDelta(pts.toString()),
          ),
          backgroundColor: Colors.blue,
          duration: const Duration(seconds: 3),
        ),
      );
      await _reloadOpenRegionOrMap();
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
        await _reloadOpenRegionOrMap();
      }
    }
  }

  Future<void> _doHoldAction(String regionKey, String actionType) async {
    setState(() => _isActing = true);
    final result = await _service.doHoldAction(regionKey, actionType);
    if (!mounted) return;
    setState(() => _isActing = false);

    if (result['success'] == true) {
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(_l10n.territoryHoldSnackOk),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );
      await _reloadOpenRegionOrMap();
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
        await _reloadOpenRegionOrMap();
      }
    }
  }

  Future<void> _reloadOpenRegionOrMap() async {
    final regionKey = (_selectedRegion?['regionKey'] as String?) ??
        (_regionDetailNotifier.value?['regionKey'] as String?);
    if (regionKey != null && regionKey.isNotEmpty) {
      await _reloadRegionState(regionKey);
      return;
    }
    await _loadData();
  }

  String _projectTypeLabel(String? projectType) {
    switch (projectType) {
      case 'surveillance_grid':
        return _l10n.territoryProjectSurveillance;
      case 'arms_cache':
        return _l10n.territoryProjectArmsCache;
      case 'safehouse_network':
      default:
        return _l10n.territoryProjectSafehouse;
    }
  }

  String _projectTypeDescription(String projectType) {
    switch (projectType) {
      case 'surveillance_grid':
        return _l10n.territoryProjectSurveillanceDesc;
      case 'arms_cache':
        return _l10n.territoryProjectArmsCacheDesc;
      case 'safehouse_network':
      default:
        return _l10n.territoryProjectSafehouseDesc;
    }
  }

  List<Widget> _buildProjectTypePicker({
    required String regionKey,
    required List<Map<String, dynamic>> options,
  }) {
    final orderedTypes = const [
      'safehouse_network',
      'surveillance_grid',
      'arms_cache',
    ];
    final byType = {
      for (final option in options)
        (option['projectType'] as String? ?? ''): option,
    };
    return orderedTypes.map((projectType) {
      final option = byType[projectType] ??
          <String, dynamic>{
            'projectType': projectType,
            'allowed': false,
            'lockedByHq': true,
            'lockedByTags': false,
            'minHqLevel': 0,
          };
      final allowed = option['allowed'] == true;
      final lockedByHq = option['lockedByHq'] == true;
      final lockedByTags = option['lockedByTags'] == true;
      final minHq = (option['minHqLevel'] as num?)?.toInt() ?? 0;
      final subtitle = lockedByTags
          ? _l10n.territoryProjectLockedTags
          : (lockedByHq
              ? _l10n.territoryProjectLockedHq(minHq)
              : _projectTypeDescription(projectType));
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildActionButton(
              label:
                  '${_projectTypeLabel(projectType)} · ${_l10n.territoryProjectStartGeneric}',
              icon: Icons.construction,
              color: allowed ? Colors.teal[700]! : Colors.blueGrey,
              onTap: allowed
                  ? () => _startProject(regionKey, projectType: projectType)
                  : null,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(color: Colors.grey[700], fontSize: 12),
            ),
          ],
        ),
      );
    }).toList(growable: false);
  }

  Future<void> _startProject(
    String regionKey, {
    required String projectType,
  }) async {
    setState(() => _isActing = true);
    final result = await _service.startProject(
      regionKey,
      projectType: projectType,
    );
    if (!mounted) return;
    setState(() => _isActing = false);

    if (result['success'] == true) {
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(_l10n.territorySnackProjectStarted),
          backgroundColor: Colors.teal,
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
    }
  }

  Future<void> _deployGarrison(
    String regionKey, {
    required int cashCost,
    required int hours,
  }) async {
    final t = _l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(t.territoryGarrisonDialogTitle),
        content: Text(
          t.territoryGarrisonDialogBody(formatCurrency(cashCost), hours),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(t.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(t.territoryGarrisonDeploy),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    setState(() => _isActing = true);
    final result = await _service.deployGarrison(regionKey);
    if (!mounted) return;
    setState(() => _isActing = false);

    if (result['success'] == true) {
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(t.territorySnackGarrisonDeployed),
          backgroundColor: Colors.blueGrey,
          duration: const Duration(seconds: 3),
        ),
      );
      await _reloadRegionState(regionKey);
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
    }
  }

  Future<void> _contributeProject(String regionKey) async {
    setState(() => _isActing = true);
    final result = await _service.contributeProject(regionKey);
    if (!mounted) return;

    if (result['success'] == true) {
      final projectPayload =
          (result['project'] as Map?)?.cast<String, dynamic>();
      final serverRemaining =
          (projectPayload?['contributeCooldownSecondsRemaining'] as num?)
              ?.toInt();
      // Stamp cooldown immediately so the open sheet shows the timer before
      // the map reload finishes (and while isActing is still true).
      _applyProjectContributeCooldownToOpenRegion(
        regionKey: regionKey,
        projectUpdate: projectPayload,
        remainingOverride: (serverRemaining != null && serverRemaining > 0)
            ? serverRemaining
            : _projectContributeCooldownSeconds,
      );
      if (mounted) setState(() => _isActing = false);
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(_l10n.territorySnackProjectContributed),
          backgroundColor: Colors.teal,
          duration: const Duration(seconds: 3),
        ),
      );
      await _reloadRegionState(regionKey);
    } else {
      if (mounted) setState(() => _isActing = false);
      final rawEvent = result['event'] ?? result['message'];
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

  String _projectStatusLabel(String? status) {
    switch (status) {
      case 'building':
        return _l10n.territoryProjectStatusBuilding;
      case 'active':
        return _l10n.territoryProjectStatusActive;
      case 'damaged':
        return _l10n.territoryProjectStatusDamaged;
      case 'destroyed':
        return _l10n.territoryProjectStatusDestroyed;
      default:
        return status ?? '-';
    }
  }

  String _regionEventLabel(Map<String, dynamic> event) {
    final key = (event['eventKey'] as String?) ?? 'event';
    final attack = (event['attackBonusPoints'] as num?)?.toInt() ?? 0;
    final penalty = (event['incomePenaltyPercent'] as num?)?.toInt() ?? 0;
    final keyLabel = switch (key) {
      'police_offensive' => _l10n.territoryEventPoliceOffensive,
      'harbor_strike' => _l10n.territoryEventHarborStrike,
      'blackout_rumor' => _l10n.territoryEventBlackoutRumor,
      _ => key,
    };
    final parts = <String>[keyLabel];
    if (attack > 0) parts.add('+$attack pt');
    if (penalty > 0) parts.add('-$penalty%');
    return parts.join(' · ');
  }

  Future<void> _joinDefense(int? contestId) async {
    if (contestId == null) return;

    final regionKey =
        _regionDetailNotifier.value?['regionKey'] as String? ??
        _selectedRegion?['regionKey'] as String?;

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
          content: Text(_l10n.territorySnackDefenseConfirmed),
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
              content: Text(_l10n.territorySnackContestRefreshed),
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
  const _SvgRegionShape({
    required this.id,
    required this.name,
    required this.path,
  });

  final String id;
  final String? name;
  final Path path;
}

class _RegionShapePainter extends CustomPainter {
  const _RegionShapePainter({
    required this.path,
    required this.fillColor,
    required this.strokeColor,
  });

  final Path path;
  final Color fillColor;
  final Color strokeColor;

  @override
  void paint(Canvas canvas, Size size) {
    final bounds = path.getBounds();
    if (bounds.isEmpty || size.isEmpty) return;

    final fittedWidth = size.width / bounds.width;
    final fittedHeight = size.height / bounds.height;
    final scale = math.min(fittedWidth, fittedHeight) * 0.82;
    if (scale <= 0) return;

    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    canvas.scale(scale, scale);
    canvas.translate(-bounds.center.dx, -bounds.center.dy);

    canvas.drawShadow(path, Colors.black.withValues(alpha: 0.26), 12, false);

    final fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;
    final strokePaint = Paint()
      ..color = strokeColor.withValues(alpha: 0.78)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4 / scale;

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, strokePaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _RegionShapePainter oldDelegate) {
    return oldDelegate.path != path ||
        oldDelegate.fillColor != fillColor ||
        oldDelegate.strokeColor != strokeColor;
  }
}
