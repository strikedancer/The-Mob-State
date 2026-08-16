import 'dart:async';

import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

import '../models/prostitute.dart';
import '../models/achievement.dart';
import '../services/prostitution_service.dart';
import '../utils/achievement_notifier.dart';
import '../widgets/jail_screen.dart';
import '../widgets/prostitution/empire_kpi_strip.dart';
import '../widgets/prostitution/prostitution_empty_error.dart';
import '../widgets/prostitution/prostitution_section_header.dart';
import '../widgets/prostitution/prostitution_social_tab.dart';
import 'red_light_districts_screen.dart';
import '../utils/top_right_notification.dart';
import '../utils/country_helper.dart';

class ProstitutionScreen extends StatefulWidget {
  final int initialTabIndex;

  const ProstitutionScreen({super.key, this.initialTabIndex = 0});

  @override
  State<ProstitutionScreen> createState() => _ProstitutionScreenState();
}

class _ProstitutionScreenState extends State<ProstitutionScreen>
    with SingleTickerProviderStateMixin {
  final ProstitutionService _service = ProstitutionService();

  List<Prostitute> _prostitutes = [];
  ProstituteHousingSummary? _housingSummary;
  ProstituteStats? _stats;
  bool _loadFailed = false;
  bool _isCollecting = false;

  List<VipEvent> _activeEvents = [];
  List<VipEvent> _upcomingEvents = [];
  List<EventParticipation> _myParticipations = [];
  SabotageHistoryItem? _latestIncomingSabotage;

  bool _isLoading = true;
  bool _isRecruiting = false;
  bool _isWorkingAll = false;
  int? _cooldownSeconds;
  int? _jailSeconds;
  int? _wantedLevel;
  String _currentCountry = 'NL';
  Timer? _cooldownTimer;
  late TabController _tabController;

  int get _availableWorkCount => _prostitutes.where(_canStartWorkShift).length;

  bool _isNightclubProstitute(Prostitute prostitute) =>
      prostitute.location == 'nightclub';

  Duration? _getWorkShiftRemaining(Prostitute prostitute) {
    if (prostitute.lastWorkedAt == null) return null;
    final availableAt = prostitute.lastWorkedAt!.add(const Duration(hours: 8));
    final remaining = availableAt.difference(DateTime.now());
    return remaining.isNegative ? null : remaining;
  }

  bool _canStartWorkShift(Prostitute prostitute) {
    if (prostitute.isCurrentlyBusted) return false;
    return _getWorkShiftRemaining(prostitute) == null;
  }

  String _resolveWorkLocation(Prostitute prostitute) {
    if (_isNightclubProstitute(prostitute)) return 'nightclub';
    if (prostitute.isInRedLight) return 'redlight';
    return 'street';
  }

  String _formatDurationHoursMinutes(
    AppLocalizations l10n,
    Duration duration,
  ) {
    final totalMinutes = duration.inMinutes;
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;
    return l10n.prostitutionTimeHoursMinutes(hours, minutes);
  }

  String _happinessLabelForCode(AppLocalizations l10n, String? code) {
    switch (code) {
      case 'ecstatic':
        return l10n.prostitutionHappinessEcstatic;
      case 'happy':
        return l10n.prostitutionHappinessHappy;
      case 'stable':
        return l10n.prostitutionHappinessStable;
      case 'stressed':
        return l10n.prostitutionHappinessStressed;
      case 'miserable':
        return l10n.prostitutionHappinessMiserable;
      default:
        return code ?? '-';
    }
  }

  @override
  void initState() {
    super.initState();
    final safeInitialTab = widget.initialTabIndex.clamp(0, 3);
    _tabController = TabController(
      length: 4,
      vsync: this,
      initialIndex: safeInitialTab,
    );
    _loadData();
    _checkRecruitmentStatus();
  }

  @override
  void dispose() {
    _cooldownTimer?.cancel();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _loadFailed = false;
    });

    final playerResult = await _service.getCurrentPlayer();
    if (playerResult['success'] == true) {
      final player = playerResult['player'] as Map<String, dynamic>?;
      final country = player?['currentCountry']?.toString();
      if (country != null && country.isNotEmpty) {
        _currentCountry = country;
      }
      final wantedLevelValue = player?['wantedLevel'];
      if (wantedLevelValue is int) {
        _wantedLevel = wantedLevelValue;
      }
    }

    final result = await _service.getProstitutes();
    if (result['success'] == true) {
      _prostitutes = result['prostitutes'] as List<Prostitute>;
      _housingSummary = result['housingSummary'] as ProstituteHousingSummary?;
      _stats = result['stats'] as ProstituteStats?;
      _loadFailed = false;

      if (mounted && _housingSummary?.betrayalTriggered == true) {
        final l10n = AppLocalizations.of(context)!;
        final msg =
            _housingSummary?.betrayalMessage ??
            l10n.prostitutionBetrayalDefaultMessage;
        showTopRightFromSnackBar(
          context,
          SnackBar(content: Text(msg), backgroundColor: Colors.red),
        );
      }
    } else if (mounted) {
      _loadFailed = true;
      final l10n = AppLocalizations.of(context)!;
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(
            result['message']?.toString() ?? l10n.prostitutionLoadError,
          ),
        ),
      );
    }

    await _loadVipEvents();

    final player = playerResult['player'] as Map<String, dynamic>?;
    final playerId = player?['id'] as int?;
    if (playerId != null) {
      final historyResult = await _service.getRivalryHistory(limit: 25);
      final historyJson = (historyResult['history'] as List?) ?? [];
      final history = historyJson
          .whereType<Map<String, dynamic>>()
          .map(SabotageHistoryItem.fromJson)
          .toList();

      final recentIncoming =
          history
              .where((item) => item.victimId == playerId)
              .where(
                (item) =>
                    DateTime.now().difference(item.createdAt) <=
                    const Duration(hours: 24),
              )
              .toList()
            ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

      _latestIncomingSabotage = recentIncoming.isNotEmpty
          ? recentIncoming.first
          : null;
    } else {
      _latestIncomingSabotage = null;
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadVipEvents() async {
    final activeResult = await _service.getActiveEvents(_currentCountry);
    final upcomingResult = await _service.getUpcomingEvents();
    final participationsResult = await _service.getMyParticipations();

    final activeJson = (activeResult['events'] as List?) ?? [];
    final upcomingJson = (upcomingResult['events'] as List?) ?? [];
    final participationsJson =
        (participationsResult['participations'] as List?) ?? [];

    _activeEvents = activeJson
        .whereType<Map<String, dynamic>>()
        .map(VipEvent.fromJson)
        .toList();
    _upcomingEvents = upcomingJson
        .whereType<Map<String, dynamic>>()
        .map(VipEvent.fromJson)
        .toList();
    _myParticipations = participationsJson
        .whereType<Map<String, dynamic>>()
        .map(EventParticipation.fromJson)
        .toList();
  }

  Future<void> _moveProstituteToCurrentCountryRld(Prostitute prostitute) async {
    final l10n = AppLocalizations.of(context)!;

    if (prostitute.isInRedLight || prostitute.isCurrentlyBusted) {
      return;
    }

    final district = await _service.getDistrictByCountry(
      _currentCountry.trim().toLowerCase(),
    );

    if (district == null) {
      if (!mounted) return;
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(l10n.prostitutionNoDistrictInCountry),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final result = await _service.moveToRedLightInDistrict(
      prostitute.id,
      district.id,
    );

    if (!mounted) return;

    showTopRightFromSnackBar(
      context,
      SnackBar(
        content: Text(
          result['message']?.toString() ?? l10n.prostitutionMoveToRedLight,
        ),
        backgroundColor: result['success'] == true ? Colors.green : Colors.red,
      ),
    );

    if (result['success'] == true) {
      await _loadData();
    }
  }

  Future<void> _moveProstituteToStreet(Prostitute prostitute) async {
    final l10n = AppLocalizations.of(context)!;
    final result = await _service.moveToStreet(prostitute.id);

    if (!mounted) return;

    showTopRightFromSnackBar(
      context,
      SnackBar(
        content: Text(
          result['message']?.toString() ?? l10n.prostitutionMovedToStreet,
        ),
        backgroundColor: result['success'] == true ? Colors.green : Colors.red,
      ),
    );

    if (result['success'] == true) {
      await _loadData();
    }
  }

  Future<void> _assignProstituteToNightclub(Prostitute prostitute) async {
    final l10n = AppLocalizations.of(context)!;
    if (prostitute.isCurrentlyBusted) {
      if (!mounted) return;
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(l10n.prostitutionArrestedCannotAssign),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final venues = await _service.getMyNightclubVenues();
    if (!mounted) return;

    if (venues.isEmpty) {
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(l10n.prostitutionNoNightclubVenue),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    int? venueId;
    if (venues.length == 1) {
      venueId = (venues.first['id'] as num?)?.toInt();
    } else {
      venueId = await showModalBottomSheet<int>(
        context: context,
        builder: (ctx) {
          final sheetL10n = AppLocalizations.of(ctx)!;
          return SafeArea(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: venues.length,
              itemBuilder: (context, index) {
                final venue = venues[index];
                final id = (venue['id'] as num?)?.toInt();
                final venueLabel = id == null
                    ? sheetL10n.prostitutionNightclubVenueName
                    : sheetL10n.prostitutionNightclubVenueNumbered(id);
                final rawCountry = venue['country']?.toString();
                final country = rawCountry == null || rawCountry.isEmpty
                    ? sheetL10n.unknown
                    : CountryHelper.getLocalizedCountryName(
                        CountryHelper.normalizeCountryId(rawCountry),
                        sheetL10n,
                      );
                return ListTile(
                  enabled: id != null,
                  title: Text(venueLabel),
                  subtitle: Text(country),
                  onTap: id == null ? null : () => Navigator.of(ctx).pop(id),
                );
              },
            ),
          );
        },
      );
    }

    if (venueId == null) return;

    final result = await _service.assignProstituteToNightclub(
      venueId: venueId,
      prostituteId: prostitute.id,
    );

    if (!mounted) return;

    showTopRightFromSnackBar(
      context,
      SnackBar(
        content: Text(
          result['message']?.toString() ?? l10n.prostitutionAssignedNightclub,
        ),
        backgroundColor: result['success'] == true ? Colors.green : Colors.red,
      ),
    );

    if (result['success'] == true) {
      await _loadData();
    }
  }

  Future<void> _executeWorkShift(Prostitute prostitute) async {
    if (prostitute.isCurrentlyBusted) {
      if (!mounted) return;
      final l10nBusted = AppLocalizations.of(context)!;
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(l10nBusted.prostitutionArrestedCannotWork),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final l10n = AppLocalizations.of(context)!;
    final shiftRemaining = _getWorkShiftRemaining(prostitute);
    if (shiftRemaining != null) {
      if (!mounted) return;
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(
            l10n.prostitutionShiftRestNeeded(
              _formatDurationHoursMinutes(l10n, shiftRemaining),
            ),
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final location = _resolveWorkLocation(prostitute);
    final result = await _service.workShift(prostitute.id, location: location);

    if (!mounted) return;

    showTopRightFromSnackBar(
      context,
      SnackBar(
        content: Text(
          result['message']?.toString() ?? l10n.prostitutionWorkShiftCompleted,
        ),
        backgroundColor: result['success'] == true ? Colors.green : Colors.red,
      ),
    );

    if (result['success'] == true) {
      await _loadData();
    }
  }

  Future<void> _executeWorkShiftForAllAvailable() async {
    if (_isWorkingAll) return;

    final available = _prostitutes.where(_canStartWorkShift).toList();
    final l10nEmpty = AppLocalizations.of(context)!;

    if (available.isEmpty) {
      if (!mounted) return;
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(l10nEmpty.prostitutionNoWorkersToAssign),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isWorkingAll = true);

    int successCount = 0;
    int failedCount = 0;

    for (final prostitute in available) {
      final location = _resolveWorkLocation(prostitute);
      final result = await _service.workShift(
        prostitute.id,
        location: location,
      );
      if (result['success'] == true) {
        successCount++;
      } else {
        failedCount++;
      }
    }

    await _loadData();

    if (!mounted) return;

    setState(() => _isWorkingAll = false);

    final l10nBatch = AppLocalizations.of(context)!;
    showTopRightFromSnackBar(
      context,
      SnackBar(
        content: Text(
          failedCount == 0
              ? l10nBatch.prostitutionWorkAllSentCount(successCount)
              : l10nBatch.prostitutionWorkAllPartial(successCount, failedCount),
        ),
        backgroundColor: successCount > 0 ? Colors.green : Colors.red,
      ),
    );
  }

  Future<void> _checkRecruitmentStatus() async {
    final result = await _service.canRecruit();
    setState(() {
      _cooldownSeconds = result['cooldownRemaining'] as int?;
      _jailSeconds = result['jailRemaining'] as int?;
    });

    if ((_cooldownSeconds != null && _cooldownSeconds! > 0) ||
        (_jailSeconds != null && _jailSeconds! > 0)) {
      _startCooldownTimer();
    }
  }

  void _startCooldownTimer() {
    _cooldownTimer?.cancel();
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final hasRecruitCooldown =
          _cooldownSeconds != null && _cooldownSeconds! > 0;
      final hasJailCooldown = _jailSeconds != null && _jailSeconds! > 0;

      if (hasRecruitCooldown || hasJailCooldown) {
        setState(() {
          if (hasRecruitCooldown) {
            _cooldownSeconds = _cooldownSeconds! - 1;
          }
          if (hasJailCooldown) {
            _jailSeconds = _jailSeconds! - 1;
          }
        });
      } else {
        timer.cancel();
        setState(() {
          _cooldownSeconds = null;
          _jailSeconds = null;
        });
      }
    });
  }

  Future<void> _recruitProstitute() async {
    if (_isRecruiting ||
        (_cooldownSeconds != null && _cooldownSeconds! > 0) ||
        (_jailSeconds != null && _jailSeconds! > 0)) {
      return;
    }

    setState(() => _isRecruiting = true);
    try {
      final result = await _service.recruitProstitute();

      if (result['success'] == true) {
        final newAchievements = result['newAchievements'] as List?;
        final achievements =
            newAchievements != null && newAchievements.isNotEmpty
            ? newAchievements.map((json) => Achievement.fromJson(json)).toList()
            : <Achievement>[];

        await _loadData();
        await _checkRecruitmentStatus();

        if (!mounted) return;

        final l10nRecruit = AppLocalizations.of(context)!;
        final recruitMessage =
            result['message']?.toString() ?? l10nRecruit.prostitutionRecruitedDefault;

        if (!mounted) return;

        _finishRecruitPresentation(recruitMessage, achievements);
      } else if (mounted) {
        final jailRemaining = result['jailRemaining'] as int?;
        if (jailRemaining != null && jailRemaining > 0) {
          setState(() {
            _jailSeconds = jailRemaining;
          });
          _startCooldownTimer();
        }

        final l10nFail = AppLocalizations.of(context)!;
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(
              result['message']?.toString() ?? l10nFail.prostitutionRecruitFailed,
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (_) {
      if (!mounted) return;
      final l10nCatch = AppLocalizations.of(context)!;
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(l10nCatch.prostitutionRecruitConnectionError),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isRecruiting = false);
      }
    }
  }

  void _finishRecruitPresentation(
    String? message,
    List<Achievement> achievements,
  ) {
    if (!mounted) return;

    final newest = _prostitutes.isNotEmpty ? _prostitutes.last : null;
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        final l10n = AppLocalizations.of(ctx)!;
        return AlertDialog(
          backgroundColor: Colors.grey.shade900,
          title: Text(
            l10n.prostitutionRecruitCeremonyTitle,
            style: const TextStyle(color: kProstitutionGold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  'assets/images/prostitution/animation/recruitment_anim_frame5_success.png',
                  height: 140,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.person_add,
                    size: 64,
                    color: kProstitutionGold,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              if (newest != null)
                Text(
                  newest.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              if (message != null && message.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade300),
                ),
              ],
            ],
          ),
          actions: [
            FilledButton(
              onPressed: () => Navigator.pop(ctx),
              style: FilledButton.styleFrom(
                backgroundColor: kProstitutionGold,
                foregroundColor: Colors.black,
              ),
              child: Text(l10n.ok),
            ),
          ],
        );
      },
    );

    if (achievements.isNotEmpty) {
      Future.delayed(const Duration(milliseconds: 400), () {
        if (mounted) {
          AchievementNotifier.showMultipleAchievements(context, achievements);
        }
      });
    }
  }

  Future<void> _collectEarnings() async {
    if (_isCollecting) return;
    final l10n = AppLocalizations.of(context)!;
    final potential = _stats?.potentialEarnings ?? 0;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        title: Text(l10n.prostitutionCollect),
        content: Text(
          potential > 0
              ? l10n.prostitutionCollectConfirm(potential.toString())
              : l10n.prostitutionCollectEmpty,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          if (potential > 0)
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              style: FilledButton.styleFrom(
                backgroundColor: kProstitutionGold,
                foregroundColor: Colors.black,
              ),
              child: Text(l10n.prostitutionCollect),
            ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _isCollecting = true);
    try {
      final result = await _service.settleEarnings();
      if (!mounted) return;
      final earnings = (result['earnings'] as num?)?.toInt() ?? 0;
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(
            result['success'] == true
                ? (earnings > 0
                    ? l10n.prostitutionCollectSuccess(earnings.toString())
                    : l10n.prostitutionCollectEmpty)
                : (result['message']?.toString() ??
                    l10n.prostitutionCollectFailed),
          ),
          backgroundColor:
              result['success'] == true ? Colors.green : Colors.red,
        ),
      );
      if (result['success'] == true) {
        await _loadData();
      }
    } finally {
      if (mounted) setState(() => _isCollecting = false);
    }
  }

  Widget _buildEmpireKpiStrip(AppLocalizations l10n) {
    int street = 0;
    int rld = 0;
    int nightclub = 0;
    double hourly = 0;
    for (final p in _prostitutes) {
      if (p.isCurrentlyBusted) continue;
      hourly += _calculateHourlyEarningsForProstitute(p);
      if (p.location == 'nightclub') {
        nightclub++;
      } else if (p.isInRedLight) {
        rld++;
      } else {
        street++;
      }
    }
    final potential = _stats?.potentialEarnings ?? 0;
    final slots = _housingSummary == null
        ? '—'
        : '${_housingSummary!.occupiedSlots}/${_housingSummary!.totalCapacity}';
    final recruitCd = _cooldownSeconds != null && _cooldownSeconds! > 0
        ? _formatCooldown(_cooldownSeconds!)
        : l10n.prostitutionRecruitReady;

    return EmpireKpiStrip(
      items: [
        EmpireKpiItem(
          label: l10n.prostitutionWorkersKpi,
          value: '$street / $rld / $nightclub',
          icon: Icons.groups,
        ),
        EmpireKpiItem(
          label: l10n.prostitutionHourlyKpi,
          value: '€${hourly.toStringAsFixed(0)}/h',
          icon: Icons.payments,
          accent: Colors.teal.shade300,
        ),
        EmpireKpiItem(
          label: l10n.prostitutionPotentialEarnings,
          value: '€$potential',
          icon: Icons.savings,
          accent: Colors.green.shade300,
        ),
        EmpireKpiItem(
          label: l10n.prostitutionHousingSlots,
          value: slots,
          icon: Icons.home_work,
        ),
        EmpireKpiItem(
          label: l10n.prostitutionRecruit,
          value: recruitCd,
          icon: Icons.timer,
          accent: Colors.orange.shade300,
        ),
      ],
    );
  }

  Future<void> _leaveEvent(EventParticipation participation) async {
    if (participation.event == null || participation.prostitute == null) return;

    final result = await _service.leaveEvent(
      participation.event!.id,
      participation.prostitute!.id,
    );

    if (!mounted) return;

    final l10nLeave = AppLocalizations.of(context)!;
    showTopRightFromSnackBar(
      context,
      SnackBar(
        content: Text(
          result['message']?.toString() ?? l10nLeave.prostitutionEventUpdate,
        ),
        backgroundColor: result['success'] == true ? Colors.green : Colors.red,
      ),
    );

    if (result['success'] == true) {
      await _loadData();
    }
  }

  Future<void> _participateInEvent(int eventId, int prostituteId) async {
    final result = await _service.participateInEvent(eventId, prostituteId);

    if (!mounted) return;

    final l10nPart = AppLocalizations.of(context)!;
    showTopRightFromSnackBar(
      context,
      SnackBar(
        content: Text(
          result['message']?.toString() ?? l10nPart.prostitutionEventUpdate,
        ),
        backgroundColor: result['success'] == true ? Colors.green : Colors.red,
      ),
    );

    if (result['success'] == true) {
      await _loadData();
    }
  }

  void _showAssignDialog(VipEvent event) {
    final l10n = AppLocalizations.of(context)!;
    final eligible = _prostitutes
        .where(
          (prostitute) =>
              !prostitute.isCurrentlyBusted &&
              prostitute.level >= event.minLevelRequired,
        )
        .toList();

    if (eligible.isEmpty) {
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(
            l10n.vipEventNoEligible(event.minLevelRequired, event.countryCode),
          ),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${l10n.vipEventAssignDialogTitle} ${event.title}'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: eligible.length,
            itemBuilder: (context, index) {
              final prostitute = eligible[index];
              return ListTile(
                title: Text(prostitute.name),
                subtitle: Text('${l10n.prostitutionLevel} ${prostitute.level}'),
                onTap: () {
                  Navigator.pop(context);
                  _participateInEvent(event.id, prostitute.id);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: _jailSeconds != null && _jailSeconds! > 0
          ? JailOverlay(
              embedded: true,
              remainingSeconds: _jailSeconds!,
              wantedLevel: _wantedLevel,
              onReleased: () {
                if (!mounted) return;
                setState(() {
                  _jailSeconds = null;
                });
                _checkRecruitmentStatus();
                _loadData();
              },
            )
          : NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverAppBar(
                  title: Text(l10n.prostitutionTitle),
                  pinned: false,
                  floating: false,
                ),
                if (_latestIncomingSabotage != null)
                  SliverToBoxAdapter(
                    child: _buildUnderAttackBanner(_latestIncomingSabotage!),
                  ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed:
                                (_housingSummary == null ||
                                        _housingSummary!.freeSlots > 0) &&
                                    (_cooldownSeconds == null ||
                                        _cooldownSeconds == 0) &&
                                    (_jailSeconds == null ||
                                        _jailSeconds == 0) &&
                                    !_isRecruiting
                                ? _recruitProstitute
                                : null,
                            icon: _isRecruiting
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.person_add),
                            label: Text(
                              _housingSummary != null &&
                                      _housingSummary!.freeSlots <= 0
                                  ? l10n.prostitutionBuyPropertyFirst
                                  : _jailSeconds != null && _jailSeconds! > 0
                                  ? '${l10n.jail} (${_formatCooldown(_jailSeconds!)})'
                                  : _cooldownSeconds != null &&
                                        _cooldownSeconds! > 0
                                  ? '${l10n.prostitutionRecruit} (${_formatCooldown(_cooldownSeconds!)})'
                                  : l10n.prostitutionRecruit,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _isWorkingAll || _availableWorkCount == 0
                                ? null
                                : _executeWorkShiftForAllAvailable,
                            icon: _isWorkingAll
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.groups_2),
                            label: Text(
                              l10n.prostitutionWorkAll(_availableWorkCount),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _isCollecting ? null : _collectEarnings,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kProstitutionGold,
                              foregroundColor: Colors.black,
                            ),
                            icon: _isCollecting
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.savings),
                            label: Text(l10n.prostitutionCollect),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_prostitutes.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        () {
                          final latest = _prostitutes
                              .map((p) => p.lastEarningsAt)
                              .reduce((a, b) => a.isAfter(b) ? a : b);
                          final local = latest.toLocal();
                          final stamp =
                              '${local.day}/${local.month} ${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
                          return Localizations.localeOf(context).languageCode == 'nl'
                              ? 'Laatst verrekend: $stamp'
                              : 'Last settled: $stamp';
                        }(),
                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ),
                ),
                if (_housingSummary != null && _housingSummary!.freeSlots <= 0)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                      child: Text(
                        l10n.prostitutionNoHousingForRecruit,
                        style: TextStyle(
                          color: Colors.orange.shade300,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                    child: _buildEmpireKpiStrip(l10n),
                  ),
                ),
                if (_housingSummary != null)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                      child: _buildHousingSummaryBox(),
                    ),
                  ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: TabBar(
                      controller: _tabController,
                      labelColor: kProstitutionGold,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: kProstitutionGold,
                      isScrollable: true,
                      tabs: [
                        Tab(text: l10n.prostitutionTabWorkers),
                        Tab(text: l10n.prostitutionTabRld),
                        Tab(text: l10n.prostitutionTabEvents),
                        Tab(text: l10n.prostitutionTabSocial),
                      ],
                    ),
                  ),
                ),
              ],
              body: TabBarView(
                controller: _tabController,
                children: [
                  _buildProstitutesTab(),
                  const RedLightDistrictsScreen(embedded: true),
                  _buildEventsTab(),
                  const ProstitutionSocialTab(),
                ],
              ),
            ),
    );
  }

  Widget _buildProstitutesTab() {
    if (_isLoading) return const Center(child: CircularProgressIndicator());

    final l10n = AppLocalizations.of(context)!;
    if (_loadFailed) {
      return ProstitutionEmptyError(
        icon: Icons.cloud_off,
        message: l10n.prostitutionLoadError,
        actionLabel: l10n.prostitutionRetry,
        onAction: _loadData,
        isError: true,
      );
    }

    if (_prostitutes.isEmpty) {
      return ProstitutionEmptyError(
        icon: Icons.person_add_alt_1,
        message: l10n.prostitutionNoProstitutes,
        actionLabel: l10n.prostitutionRecruit,
        onAction:
            (_cooldownSeconds != null && _cooldownSeconds! > 0) ||
                    (_jailSeconds != null && _jailSeconds! > 0) ||
                    (_housingSummary != null && _housingSummary!.freeSlots <= 0)
                ? null
                : _recruitProstitute,
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final useListLayout = constraints.maxWidth < 720;

          if (useListLayout) {
            return ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: _prostitutes.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) =>
                  _buildProstituteCard(_prostitutes[index]),
            );
          }

          const spacing = 12.0;
          final targetCardWidth = constraints.maxWidth >= 1200 ? 280.0 : 320.0;
          final estimatedColumns =
              ((constraints.maxWidth + spacing) / (targetCardWidth + spacing))
                  .floor()
                  .clamp(1, 6);
          final cardWidth =
              (constraints.maxWidth - (estimatedColumns - 1) * spacing) /
              estimatedColumns;

          return ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            children: [
              Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: _prostitutes
                    .map(
                      (prostitute) => SizedBox(
                        width: cardWidth,
                        child: _buildProstituteCard(prostitute),
                      ),
                    )
                    .toList(),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHousingSummaryBox() {
    if (_housingSummary == null) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.35),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.prostitutionHousingTitle,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.prostitutionHousingRentRule(_housingSummary!.graceDays),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildHousingChip(
                l10n.prostitutionHousingSlots,
                '${_housingSummary!.occupiedSlots}/${_housingSummary!.totalCapacity}',
              ),
              _buildHousingChip(
                l10n.prostitutionHousingFree,
                '${_housingSummary!.freeSlots}',
              ),
              _buildHousingChip(
                l10n.prostitutionHousingHomes,
                '${_housingSummary!.residentialProperties}',
              ),
              _buildHousingChip(
                l10n.prostitutionHousingAvgUpgrade,
                _housingSummary!.averageResidentialUpgrade.toStringAsFixed(1),
              ),
              _buildHousingChip(
                l10n.prostitutionHousingHappinessBonus,
                '+${_housingSummary!.housingHappinessBonusPercent}%',
              ),
              _buildHousingChip(
                l10n.prostitutionHousingWeeklyRent,
                '€${_housingSummary!.totalWeeklyRent}',
              ),
              _buildHousingChip(
                l10n.prostitutionHousingAtRisk,
                '${_housingSummary!.atRiskCount}',
              ),
              _buildHousingChip(
                l10n.prostitutionHousingSafe,
                '${_housingSummary!.safeCount}',
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildEarningsInsightBox(),
          if (_housingSummary!.betrayalTriggered) ...[
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.18),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.redAccent),
              ),
              child: Text(
                l10n.prostitutionBetrayalActiveDetail(
                  _housingSummary!.seizedDrugsGrams,
                  _housingSummary!.nightclubLicensesRevoked,
                ),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  double _calculateHourlyEarningsForProstitute(Prostitute prostitute) {
    final base = prostitute.isInRedLight
        ? (prostitute.redLightRoom != null
              ? _getTierGrossEarnings(prostitute.redLightRoom!.tier)
              : 40.0)
        : 40.0;
    final levelBonus = base * (prostitute.level - 1) * 0.05;
    final vipBonus = prostitute.isVipProstitute ? base * 0.5 : 0;
    final gross = base + levelBonus + vipBonus;
    return gross * prostitute.happinessEarningsMultiplier;
  }

  Widget _buildEarningsInsightBox() {
    final l10n = AppLocalizations.of(context)!;
    int streetCount = 0;
    int redLightCount = 0;
    int nightclubCount = 0;
    double streetEarnings = 0;
    double redLightEarnings = 0;
    double nightclubEarnings = 0;

    for (final prostitute in _prostitutes) {
      if (prostitute.isCurrentlyBusted) continue;
      final hourly = _calculateHourlyEarningsForProstitute(prostitute);
      if (prostitute.location == 'nightclub') {
        nightclubCount++;
        nightclubEarnings += hourly;
      } else if (prostitute.isInRedLight) {
        redLightCount++;
        redLightEarnings += hourly;
      } else {
        streetCount++;
        streetEarnings += hourly;
      }
    }

    final totalEarnings = streetEarnings + redLightEarnings + nightclubEarnings;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.prostitutionEarningsInsightTitle,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.prostitutionEarningsStreetDetail(
              streetCount,
              streetEarnings.round(),
            ),
            style: const TextStyle(fontSize: 12),
          ),
          Text(
            l10n.prostitutionEarningsRldDetail(
              redLightCount,
              redLightEarnings.round(),
            ),
            style: const TextStyle(fontSize: 12),
          ),
          Text(
            l10n.prostitutionEarningsNightclubDetail(
              nightclubCount,
              nightclubEarnings.round(),
            ),
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.prostitutionEarningsTotalDetail(totalEarnings.round()),
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: Colors.lightGreenAccent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHousingChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: Colors.white70),
          ),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _buildProstituteCard(Prostitute prostitute) {
    final l10n = AppLocalizations.of(context)!;
    final isBusted = prostitute.isCurrentlyBusted;
    final isVip = prostitute.isVipProstitute;
    final String portraitPath = _getPortraitPath(prostitute.variant);
    final currentLevelXp = prostitute.experience % 100;
    final happinessLabel = _happinessLabelForCode(
      l10n,
      prostitute.happinessLabel,
    );
    final housingRemaining = prostitute.housingTimeRemaining;
    final housingLabel = prostitute.isHousingExpired
        ? l10n.prostitutionHousingExpired
        : housingRemaining == null
        ? '-'
        : housingRemaining.inDays >= 1
        ? l10n.prostitutionHousingDaysLeft(housingRemaining.inDays)
        : l10n.prostitutionHousingLessThanOneDay;

    // Calculate hourly earnings
    final base = prostitute.isInRedLight
        ? (prostitute.redLightRoom != null
              ? _getTierGrossEarnings(prostitute.redLightRoom!.tier)
              : 40.0)
        : 40.0;
    final levelBonus = base * (prostitute.level - 1) * 0.05;
    final vipBonus = isVip ? base * 0.5 : 0;
    final hourlyEarnings = base + levelBonus + vipBonus;
    final shiftRemaining = _getWorkShiftRemaining(prostitute);
    final canWorkNow = !isBusted && shiftRemaining == null;

    return Card(
      color: Colors.grey.shade900,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isBusted
              ? Colors.red.withOpacity(0.45)
              : kProstitutionGold.withOpacity(0.28),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 1.05,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Portrait image
                Image.asset(
                  portraitPath,
                  fit: BoxFit.contain,
                  alignment: Alignment.bottomCenter,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey.shade800,
                      child: Icon(
                        Icons.person,
                        size: 48,
                        color: Colors.grey.shade600,
                      ),
                    );
                  },
                ),
                // Grayscale filter if busted
                if (isBusted)
                  Container(
                    color: Colors.black54,
                    child: const Center(
                      child: Icon(Icons.block, size: 48, color: Colors.red),
                    ),
                  ),
                // Level badge
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.amber, width: 2),
                    ),
                    child: Text(
                      'L${prostitute.level}',
                      style: const TextStyle(
                        color: Colors.amber,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                // VIP badge
                if (isVip)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade700,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'VIP',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // Info section
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  prostitute.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (isBusted)
                  Text(
                    l10n.prostitutionBusted,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            _isNightclubProstitute(prostitute)
                                ? Icons.local_bar
                                : prostitute.isInRedLight
                                ? Icons.business
                                : Icons.location_on,
                            size: 12,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              _isNightclubProstitute(prostitute)
                                  ? l10n.prostitutionNightclubShort
                                  : prostitute.isInRedLight
                                  ? l10n.prostitutionRedLight
                                  : l10n.prostitutionStreet,
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey.shade400,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            'XP: $currentLevelXp/100',
                            style: TextStyle(
                              fontSize: 9,
                              color: Colors.blue.shade300,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      if (!isBusted) ...[
                        const SizedBox(height: 4),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: PopupMenuButton<String>(
                            tooltip: l10n.prostitutionMove,
                            onSelected: (value) {
                              switch (value) {
                                case 'street':
                                  _moveProstituteToStreet(prostitute);
                                  break;
                                case 'rld':
                                  _moveProstituteToCurrentCountryRld(
                                    prostitute,
                                  );
                                  break;
                                case 'nightclub':
                                  _assignProstituteToNightclub(prostitute);
                                  break;
                              }
                            },
                            itemBuilder: (context) {
                              final items = <PopupMenuEntry<String>>[];
                              if (prostitute.isInRedLight ||
                                  _isNightclubProstitute(prostitute)) {
                                items.add(
                                  PopupMenuItem(
                                    value: 'street',
                                    child: Text(
                                      l10n.prostitutionMoveToStreetButton,
                                    ),
                                  ),
                                );
                              }
                              if (!prostitute.isInRedLight &&
                                  !_isNightclubProstitute(prostitute)) {
                                items.add(
                                  PopupMenuItem(
                                    value: 'rld',
                                    child: Text(
                                      l10n.prostitutionMoveToRldShort,
                                    ),
                                  ),
                                );
                              }
                              if (!_isNightclubProstitute(prostitute)) {
                                items.add(
                                  PopupMenuItem(
                                    value: 'nightclub',
                                    child: Text(
                                      l10n.prostitutionMoveToNightclubButton,
                                    ),
                                  ),
                                );
                              }
                              return items;
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: kProstitutionGold.withOpacity(0.45),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.swap_horiz,
                                    size: 14,
                                    color: kProstitutionGold,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    l10n.prostitutionMove,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: kProstitutionGold,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 4),
                      Text(
                        l10n.prostitutionEuroPerHour(
                          (hourlyEarnings * prostitute.happinessEarningsMultiplier)
                              .toStringAsFixed(0),
                        ),
                        style: const TextStyle(
                          color: Colors.green,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        l10n.prostitutionHappinessDetail(
                          happinessLabel,
                          prostitute.happinessScore,
                          '${prostitute.happinessEarningsBonusPercent >= 0 ? '+' : ''}${prostitute.happinessEarningsBonusPercent}%',
                        ),
                        style: TextStyle(
                          fontSize: 10,
                          color: prostitute.happinessScore >= 70
                              ? Colors.lightGreenAccent
                              : Colors.orangeAccent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: prostitute.isHousingAtRisk
                              ? Colors.orange.withOpacity(0.18)
                              : Colors.blue.withOpacity(0.14),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: prostitute.isHousingAtRisk
                                ? Colors.orangeAccent
                                : Colors.blueAccent,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.prostitutionHousingStatus(housingLabel),
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              l10n.prostitutionWeeklyRentEuro(
                                prostitute.weeklyHousingCost,
                              ),
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (!isBusted) ...[
                        const SizedBox(height: 6),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: canWorkNow
                                ? () => _executeWorkShift(prostitute)
                                : null,
                            icon: const Icon(Icons.work, size: 14),
                            label: Text(
                              shiftRemaining == null
                                  ? l10n.prostitutionWork8h
                                  : l10n.prostitutionRestFor(
                                      _formatDurationHoursMinutes(
                                        l10n,
                                        shiftRemaining,
                                      ),
                                    ),
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kProstitutionGold,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              minimumSize: const Size(0, 28),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                          ),
                        ),
                        if (shiftRemaining != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                              l10n.prostitutionNextShiftIn(
                                _formatDurationHoursMinutes(
                                  l10n,
                                  shiftRemaining,
                                ),
                              ),
                              style: const TextStyle(
                                fontSize: 9,
                                color: Colors.white70,
                              ),
                            ),
                          ),
                        const SizedBox(height: 4),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: prostitute.levelProgress,
                            minHeight: 6,
                            backgroundColor: Colors.black38,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              kProstitutionGold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getPortraitPath(int variant) {
    if (variant >= 6 && variant <= 10) {
      // VIP portraits (variants 6-10)
      final vipIndex = variant - 6;
      final vipNames = [
        'vip_prostitute_platinum_gala',
        'vip_prostitute_redcarpet_icon',
        'vip_prostitute_emerald_penthouse',
        'vip_prostitute_eastern_luxe',
        'vip_prostitute_velvet_executive',
      ];
      return 'assets/images/prostitution/vip_portraits/${vipNames[vipIndex]}.png';
    } else {
      // Regular portraits (variants 1-5)
      final regularIndex = (variant - 1) % 5;
      final regularNames = [
        'prostitute_blonde_red_dress',
        'prostitute_brunette_black_lingerie',
        'prostitute_redhead_purple_latex',
        'prostitute_asian_cheongsam',
        'prostitute_latina_green_dress',
      ];
      return 'assets/images/prostitution/portraits/${regularNames[regularIndex]}.png';
    }
  }

  double _getTierGrossEarnings(int tier) {
    switch (tier) {
      case 1:
        return 75.0;
      case 2:
        return 100.0;
      case 3:
        return 150.0;
      default:
        return 75.0;
    }
  }

  Widget _buildUnderAttackBanner(SabotageHistoryItem item) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.12),
        border: Border.all(color: Colors.red.shade400),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(Icons.warning_amber_rounded, color: Colors.red),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.prostitutionUnderAttackTitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.prostitutionUnderAttackBody(
                    item.attackerUsername,
                    _localizedRivalryAction(item.actionType, l10n),
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => _tabController.animateTo(3),
                  child: Text(l10n.prostitutionUnderAttackAction),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventsTab() {
    final l10n = AppLocalizations.of(context)!;

    if (_isLoading) return const Center(child: CircularProgressIndicator());

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ProstitutionSectionHeader(
            icon: Icons.celebration,
            title: l10n.vipEventsActive,
            subtitle: l10n.vipEventsDescription,
          ),
          if (_activeEvents.isEmpty)
            _buildEventsPlaceholder(l10n.vipEventNoActive)
          else
            ..._activeEvents.map(_buildEventCard),
          const SizedBox(height: 16),
          ProstitutionSectionHeader(
            icon: Icons.upcoming,
            title: l10n.vipEventsUpcoming,
          ),
          if (_upcomingEvents.isEmpty)
            _buildEventsPlaceholder(l10n.vipEventNoUpcoming)
          else
            ..._upcomingEvents.map(_buildEventCard),
          const SizedBox(height: 16),
          if (_myParticipations.isNotEmpty) ...[
            ProstitutionSectionHeader(
              icon: Icons.assignment_ind,
              title: l10n.vipEventsMyParticipations,
            ),
            ..._myParticipations.map(_buildParticipationCard),
          ],
        ],
      ),
    );
  }

  Widget _buildEventCard(VipEvent event) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kProstitutionGold.withOpacity(0.28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${event.eventTypeIcon} ${event.title}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: kProstitutionGold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${_localizedEventType(event.eventType, l10n)} • ${event.bonusText} ${l10n.vipEventBonus}',
            style: TextStyle(color: Colors.grey.shade300),
          ),
          const SizedBox(height: 4),
          Text(
            '${l10n.vipEventParticipants}: ${event.currentParticipants}/${event.maxParticipants}',
            style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
          ),
          if (event.isActive) ...[
            const SizedBox(height: 4),
            Text(
              '${l10n.vipEventEndsIn}: ${_formatIsoRelative(event.endTime)}',
              style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
            ),
          ] else ...[
            const SizedBox(height: 4),
            Text(
              '${l10n.vipEventStartsIn}: ${_formatIsoRelative(event.startTime)}',
              style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
            ),
          ],
          const SizedBox(height: 10),
          if (event.isActive && !event.isFull)
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => _showAssignDialog(event),
                style: FilledButton.styleFrom(
                  backgroundColor: kProstitutionGold,
                  foregroundColor: Colors.black,
                ),
                child: Text(l10n.vipEventAssignProstitute),
              ),
            )
          else if (event.isFull)
            Text(
              l10n.vipEventFull,
              style: const TextStyle(
                color: Colors.orangeAccent,
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildParticipationCard(EventParticipation participation) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24),
      ),
      child: ListTile(
        title: Text(participation.event?.title ?? l10n.vipEventTypeTitle),
        subtitle: Text(
          '${l10n.vipEventAssigned}: ${participation.prostitute?.name ?? '-'}',
        ),
        trailing: TextButton(
          onPressed: () => _leaveEvent(participation),
          style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
          child: Text(l10n.vipEventLeave),
        ),
      ),
    );
  }

  Widget _buildEventsPlaceholder(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white24),
      ),
      child: Text(
        message,
        style: TextStyle(color: Colors.grey.shade300),
      ),
    );
  }

  String _formatIsoRelative(DateTime? dt) {
    if (dt == null) return '—';
    final diff = dt.difference(DateTime.now());
    if (diff.isNegative) return '0:00';
    final hours = diff.inHours;
    final minutes = diff.inMinutes % 60;
    if (hours > 0) {
      return '$hours:${minutes.toString().padLeft(2, '0')}';
    }
    return '0:${minutes.toString().padLeft(2, '0')}';
  }

  String _formatCooldown(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  String _localizedEventType(String eventType, AppLocalizations l10n) {
    switch (eventType) {
      case 'celebrity_visit':
        return l10n.vipEventCelebrity;
      case 'bachelor_party':
        return l10n.vipEventBachelor;
      case 'convention':
        return l10n.vipEventConvention;
      case 'festival':
        return l10n.vipEventFestival;
      default:
        return l10n.vipEventTypeTitle;
    }
  }

  String _localizedRivalryAction(String actionType, AppLocalizations l10n) {
    switch (actionType) {
      case 'tip_police':
        return l10n.rivalryActionTipPolice;
      case 'steal_customer':
        return l10n.rivalryActionStealCustomer;
      case 'damage_reputation':
        return l10n.rivalryActionDamageReputation;
      case 'bribe_employee':
        return l10n.rivalryActionBribeEmployee;
      default:
        return actionType;
    }
  }
}
