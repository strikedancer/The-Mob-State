import 'dart:async';
import 'dart:math' as math;

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
import '../utils/top_right_notification.dart';
// ---------------------------------------------------------------------------
// TerritoryScreen â€” Responsive crew territory map (NL-first)
// Layout: desktop = split (map | side panel), tablet = stacked collapsible,
//         mobile  = map card + action bottom sheet.
// ---------------------------------------------------------------------------

class TerritoryScreen extends StatefulWidget {
  const TerritoryScreen({super.key});

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
  bool _isTerritoryEnabled = false;

  // â”€â”€ Data â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
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
  final TransformationController _mapTransformController =
      TransformationController();
  final ValueNotifier<Map<String, dynamic>?> _regionDetailNotifier =
      ValueNotifier<Map<String, dynamic>?>(null);
  Offset? _mapPointerDownPosition;
  bool _mapPointerMoved = false;
  int _activeMapPointers = 0;
  int _maxMapPointersDuringGesture = 0;

  // â”€â”€ Selection â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  Map<String, dynamic>? _selectedRegion;
  bool _isActing = false;
  bool _isRegionSheetOpen = false;

  // â”€â”€ Tabs â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  late TabController _tabController;

  bool get _hasCrew => _myCrewId != null;

  AppLocalizations get _l10n => AppLocalizations.of(context)!;
  int get _actionCooldownSeconds =>
      (_overview['config']?['actionCooldownSeconds'] as num?)?.toInt() ?? 0;

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

  String _currentTerritoryCountryCode() {
    final currentCountry = context.select<AuthProvider, String?>(
      (auth) => auth.currentPlayer?.currentCountry,
    );
    final normalized = currentCountry?.trim().toLowerCase();
    if (normalized == null || normalized.isEmpty) {
      return 'nl';
    }
    return _territoryCountryCodeByTravelCountry[normalized] ?? normalized;
  }

  bool _canActInSelectedCountry() {
    return _currentTerritoryCountryCode() == _selectedCountryCode.toLowerCase();
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
    _mapTransformController.dispose();
    _regionDetailNotifier.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData({
    String? countryCode,
    bool reloadCountries = false,
  }) async {
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
        targetCountryCode =
            (countries.first['countryCode'] as String?)?.toLowerCase() ??
            targetCountryCode;
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
    final resolvedCountryCode =
        (mapCountry?['countryCode'] as String?)?.toLowerCase() ??
        targetCountryCode;
    final svgAssetKey = mapCountry?['svgAssetKey'] as String?;
    final svgTemplate = await _loadSvgTemplateForCountry(
      resolvedCountryCode,
      svgAssetKey,
    );
    final parsedSvg = _parseSvgMap(svgTemplate);
    final myCrewMap = myCrew as Map<String, dynamic>?;
    final myCrewIdRaw = myCrewMap?['id'];
    final myCrewId = myCrewIdRaw is num
        ? myCrewIdRaw.toInt()
        : int.tryParse(myCrewIdRaw?.toString() ?? '');
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
      _renderedSvgMap = _renderSvgWithOwnership(
        (_mapData['regions'] as List<dynamic>?) ?? const <dynamic>[],
      );
      _isLoading = false;
    });
    _resetMapTransform();
    _regionDetailNotifier.value = selectedRegion;
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

  String _countdownLabel(DateTime? targetAt) {
    final t = _l10n;
    if (targetAt == null) {
      return t.unknown;
    }
    final remaining = targetAt.difference(DateTime.now());
    if (remaining.isNegative || remaining.inSeconds <= 0) {
      return t.territoryNow;
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
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (!_isTerritoryEnabled) {
      final t = AppLocalizations.of(context)!;
      return Scaffold(
        appBar: AppBar(title: Text(t.territory)),
        body: Center(
          child: Text(
            t.territoryUnavailableMessage,
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final t = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(t.territory),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: t.territoryTabMap),
            Tab(text: t.territoryTabLeaderboard),
            Tab(text: t.territoryTabSeason),
          ],
        ),
        actions: [
          if (_countries.length > 1)
            PopupMenuButton<String>(
              tooltip: t.territorySelectCountryTooltip,
              icon: const Icon(Icons.language),
              onSelected: (countryCode) {
                if (countryCode == _selectedCountryCode) return;
                setState(() => _selectedRegion = null);
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
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: t.refresh,
            onPressed: _loadData,
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: [_buildMapTab(), _buildLeaderboardTab(), _buildSeasonTab()],
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
          if (viewerCaps != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: Text(
                _l10n.territoryCapsLine(
                  (viewerCaps['ownedRegions'] as num?)?.toInt() ?? 0,
                  (viewerCaps['effectiveMaxRegions'] as num?)?.toInt() ?? 0,
                  (viewerCaps['activeContests'] as num?)?.toInt() ?? 0,
                  (viewerCaps['effectiveMaxContests'] as num?)?.toInt() ?? 0,
                ),
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
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

                      return Stack(
                        children: [
                          Positioned.fill(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: InteractiveViewer(
                                transformationController:
                                    _mapTransformController,
                                minScale: 1,
                                maxScale: 6,
                                panEnabled: true,
                                scaleEnabled: true,
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
                final infoWidget = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _l10n.territoryMapHintTapPanel,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _l10n.territoryMapHintMobile,
                      style: TextStyle(color: Colors.grey[700], fontSize: 12),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _l10n.territoryMapHintColors,
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                    const SizedBox(height: 12),
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
  }) {
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
    final viewerCooldownSecondsRemaining =
        (region['viewerCooldownSecondsRemaining'] as num?)?.toInt() ?? 0;
    final tier = (region['valueTier'] as num?)?.toInt() ?? 1;
    final isMyCrewRegion = _isMyCrewRegion(region);
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
    final projectIncomeBonusPercent =
        (region['projectIncomeBonusPercent'] as num?)?.toInt() ??
        (regionProject?['incomeBonusPercent'] as num?)?.toInt() ??
        0;
    final projectStatus = regionProject?['status'] as String?;
    final projectProgress = (regionProject?['progress'] as num?)?.toInt() ?? 0;
    final projectHp = (regionProject?['hp'] as num?)?.toInt() ?? 0;
    final projectMaxHp = (regionProject?['maxHp'] as num?)?.toInt() ?? 100;
    final viewerCaps =
        (_mapData['viewerCaps'] as Map?)?.cast<String, dynamic>();
    final projectMinHq =
        (viewerCaps?['projectSafehouseMinHqLevel'] as num?)?.toInt() ?? 4;
    final canManageProject =
        isMyCrewRegion && _hasCrew && canActInSelectedCountry && !_isActing;
    final canStartProject =
        canManageProject &&
        contestStatus == null &&
        (regionProject == null || projectStatus == 'destroyed') &&
        viewerHqGlobalLevel >= projectMinHq;
    final canContributeProject =
        canManageProject &&
        contestStatus == null &&
        regionProject != null &&
        (projectStatus == 'building' || projectStatus == 'damaged');
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
        '$incomeTierLabel (${('â­' * tier)})',
      ),
      _detailRow(
        t.territoryDetailPayout,
        '${formatCurrency(passiveIncomeCash)} Â· ${_incomeIntervalLabel(passiveIncomeIntervalMinutes)}',
      ),
      if (strategicTags.isNotEmpty)
        _detailRow(
          t.territoryDetailStrategicRole,
          strategicTags.join(' Â· '),
        ),
      if (adjacentOwnedRegions > 0)
        _detailRow(
          t.territoryDetailAdjacentOwned,
          '$adjacentOwnedRegions',
        ),
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
          '${warPressureCrewName ?? t.unknown} Â· +$warPressureBonus ${t.territoryDetailAttackPressure} Â· -$warPressurePenalty ${t.territoryDetailStabilityWord} Â· ${warPressureRegionRole == 'theater'
              ? t.territoryWarRoleTheater
              : warPressureRegionRole == 'adjacent'
              ? t.territoryWarRoleAdjacent
              : t.territoryWarRoleTarget}',
        ),
      if (activeWarPressure != null && warPressureEndsAt != null)
        _detailRow(
          t.territoryWarPressureEndsIn,
          _countdownLabel(warPressureEndsAt),
        ),
      _detailRow(
        t.territoryDetailIncomeHour,
        formatCurrency(passiveIncomeCashHourly),
      ),
      _detailRow(
        t.territoryDetailIncomeDay,
        formatCurrency(passiveIncomeCashDaily),
      ),
      if (regionProject != null) ...[
        _detailRow(
          t.territoryDetailProject,
          '${t.territoryProjectSafehouse} · ${_projectStatusLabel(projectStatus)}'
          '${projectIncomeBonusPercent > 0 ? ' · ${t.territoryProjectIncomeBonusPct(projectIncomeBonusPercent)}' : ''}',
        ),
        if (projectStatus == 'building')
          _detailRow(t.territoryProjectProgress, '$projectProgress%'),
        if (projectStatus == 'active' || projectStatus == 'damaged')
          _detailRow(t.territoryProjectHp, '$projectHp / $projectMaxHp'),
      ],
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
          _countdownLabel(contestActiveAt),
        ),
      if (contestStatus == 'active')
        _detailRow(
          t.territoryDetailActionsCloseIn,
          _countdownLabel(contestLockdownAt),
        ),
      if (hasContest)
        _detailRow(
          t.territoryDetailContestEndsIn,
          _countdownLabel(contestResolveAt),
        ),
      if (_actionCooldownSeconds > 0)
        _detailRow(
          t.territoryDetailCooldownPerAction,
          _formatDuration(Duration(seconds: _actionCooldownSeconds)),
        ),
      if (viewerCooldownSecondsRemaining > 0)
        _detailRow(
          t.territoryDetailYourCooldown,
          _formatDuration(Duration(seconds: viewerCooldownSecondsRemaining)),
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
          _buildActionButton(
            label: t.territoryProjectStart,
            icon: Icons.construction,
            color: Colors.teal[700]!,
            onTap: () => _startProject(region['regionKey'] as String),
          ),
        ] else if (canManageProject &&
            (regionProject == null || projectStatus == 'destroyed') &&
            viewerHqGlobalLevel < projectMinHq) ...[
          const SizedBox(height: 8),
          Text(
            t.territoryProjectHqRequired(projectMinHq),
            style: TextStyle(color: Colors.grey[700], fontSize: 12),
          ),
        ],
        if (canContributeProject) ...[
          const SizedBox(height: 12),
          _buildActionButton(
            label: t.territoryProjectContribute,
            icon: Icons.local_shipping_outlined,
            color: Colors.teal[700]!,
            onTap: () => _contributeProject(region['regionKey'] as String),
          ),
        ],
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
          canActInSelectedCountry)
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
              ),
              _smallActionButton(
                t.territoryActionSabotage,
                'sabotage',
                contestId,
                requiredHqLevel: actionUnlockHqLevels['sabotage'] ?? 0,
                viewerHqLevel: viewerHqGlobalLevel,
              ),
              _smallActionButton(
                t.territoryActionRaid,
                'raid',
                contestId,
                requiredHqLevel: actionUnlockHqLevels['raid'] ?? 0,
                viewerHqLevel: viewerHqGlobalLevel,
              ),
            ],
            if (isDefender) ...[
              _smallActionButton(
                t.territoryActionPatrol,
                'patrol',
                contestId,
                requiredHqLevel: actionUnlockHqLevels['patrol'] ?? 0,
                viewerHqLevel: viewerHqGlobalLevel,
              ),
              _smallActionButton(
                t.territoryActionSupplyRun,
                'supply_run',
                contestId,
                requiredHqLevel: actionUnlockHqLevels['supply_run'] ?? 0,
                viewerHqLevel: viewerHqGlobalLevel,
              ),
              _smallActionButton(
                t.territoryActionDefense,
                'defense',
                contestId,
                requiredHqLevel: actionUnlockHqLevels['defense'] ?? 0,
                viewerHqLevel: viewerHqGlobalLevel,
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
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 16),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
        ),
        onPressed: _isActing ? null : onTap,
      ),
    );
  }

  Widget _smallActionButton(
    String label,
    String actionType,
    int contestId, {
    required int requiredHqLevel,
    required int viewerHqLevel,
  }) {
    final t = _l10n;
    final isLocked = requiredHqLevel > viewerHqLevel;
    final buttonLabel = isLocked
        ? t.territoryHqButtonLocked(label, requiredHqLevel)
        : label;
    final tooltipMessage = isLocked
        ? t.territoryHqTooltipLocked(requiredHqLevel, viewerHqLevel)
        : '';
    final button = OutlinedButton(
      onPressed: _isActing || isLocked
          ? null
          : () => _doAction(contestId, actionType),
      child: Text(buttonLabel, style: const TextStyle(fontSize: 12)),
    );

    if (!isLocked) return button;
    return Tooltip(message: tooltipMessage, child: button);
  }

  // â”€â”€ Leaderboard Tab â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  Widget _buildLeaderboardTab() {
    if (_leaderboard.isEmpty) {
      return Center(
        child: Text(
          _l10n.territoryLeaderboardEmpty,
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _leaderboard.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, i) {
        final entry = _leaderboard[i] as Map<String, dynamic>;
        return ListTile(
          leading: CircleAvatar(
            child: Text(
              '${i + 1}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          title: Text(entry['crewName'] as String? ?? ''),
          trailing: Text(
            _l10n.territoryLeaderboardRegionsCount(
              (entry['regionsOwned'] as num?)?.toInt() ?? 0,
            ),
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        );
      },
    );
  }

  // â”€â”€ Season Tab â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  Widget _buildSeasonTab() {
    final season = _overview['activeSeason'] as Map<String, dynamic>?;
    if (season == null) {
      return Center(
        child: Text(
          _l10n.territorySeasonNone,
        ),
      );
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
            _l10n.territorySeasonCurrent,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _detailRow(_l10n.territorySeasonKey, key),
          _detailRow(_l10n.territorySeasonStatus, status),
          _detailRow(_l10n.territorySeasonStart, startsAt),
          _detailRow(_l10n.territorySeasonEnd, endsAt),
        ],
      ),
    );
  }

  // â”€â”€ Actions â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  Future<void> _confirmStartContest(String regionKey) async {
    final t = _l10n;
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

  Future<void> _startProject(String regionKey) async {
    setState(() => _isActing = true);
    final result = await _service.startProject(regionKey);
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

  Future<void> _contributeProject(String regionKey) async {
    setState(() => _isActing = true);
    final result = await _service.contributeProject(regionKey);
    if (!mounted) return;
    setState(() => _isActing = false);

    if (result['success'] == true) {
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(_l10n.territorySnackProjectContributed),
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
