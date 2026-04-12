import 'dart:async';

import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

import '../models/prostitute.dart';
import '../models/achievement.dart';
import '../services/prostitution_service.dart';
import '../utils/achievement_notifier.dart';
import '../widgets/jail_screen.dart';
import 'prostitution_leaderboard_screen.dart';
import 'prostitution_rivalry_screen.dart';
import '../utils/top_right_notification.dart';

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

  List<VipEvent> _activeEvents = [];
  List<VipEvent> _upcomingEvents = [];
  List<EventParticipation> _myParticipations = [];
  SabotageHistoryItem? _latestIncomingSabotage;

  bool _isLoading = true;
  bool _isRecruiting = false;
  int? _cooldownSeconds;
  int? _jailSeconds;
  int? _wantedLevel;
  String _currentCountry = 'NL';
  Timer? _cooldownTimer;
  late TabController _tabController;

  bool get _isNl => Localizations.localeOf(context).languageCode == 'nl';
  String _tr(String nl, String en) => _isNl ? nl : en;

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
    setState(() => _isLoading = true);

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

      if (mounted && _housingSummary?.betrayalTriggered == true) {
        final msg =
            _housingSummary?.betrayalMessage ??
            _tr(
              'Verraad! Je nightclub is geraakt door een leak.',
              'Betrayal! Your nightclub was hit by an intel leak.',
            );
        showTopRightFromSnackBar(
          context,
          SnackBar(content: Text(msg), backgroundColor: Colors.red),
        );
      }
    } else if (mounted) {
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(result['message']?.toString() ?? 'Fout bij laden'),
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
          content: Text(
            _tr(
              'Geen Red Light District gevonden in dit land',
              'No Red Light District found in this country',
            ),
          ),
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

  Future<void> _executeWorkShift(Prostitute prostitute) async {
    final l10n = AppLocalizations.of(context)!;

    if (prostitute.isCurrentlyBusted) {
      if (!mounted) return;
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(
            _tr(
              'Deze hoer is gearresteerd en kan niet werken',
              'This prostitute is arrested and cannot work',
            ),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final location = prostitute.isInRedLight ? 'redlight' : 'street';
    final result = await _service.workShift(prostitute.id, location: location);

    if (!mounted) return;

    showTopRightFromSnackBar(
      context,
      SnackBar(
        content: Text(
          result['message']?.toString() ??
              _tr('Work shift voltooid', 'Work shift completed'),
        ),
        backgroundColor: result['success'] == true ? Colors.green : Colors.red,
      ),
    );

    if (result['success'] == true) {
      await _loadData();
    }
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

        final recruitMessage = result['message']?.toString() ?? 'Geworven!';

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

        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(result['message']?.toString() ?? 'Werving mislukt'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (_) {
      if (!mounted) return;
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(
            _tr(
              'Werving mislukt door een verbindingsfout',
              'Recruitment failed due to a connection error',
            ),
          ),
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

    if (message != null && message.isNotEmpty) {
      showTopRightFromSnackBar(
        context,
        SnackBar(content: Text(message), backgroundColor: Colors.green),
      );
    }

    if (achievements.isNotEmpty) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          AchievementNotifier.showMultipleAchievements(context, achievements);
        }
      });
    }
  }

  Future<void> _leaveEvent(EventParticipation participation) async {
    if (participation.event == null || participation.prostitute == null) return;

    final result = await _service.leaveEvent(
      participation.event!.id,
      participation.prostitute!.id,
    );

    if (!mounted) return;

    showTopRightFromSnackBar(
      context,
      SnackBar(
        content: Text(result['message']?.toString() ?? 'Event update'),
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

    showTopRightFromSnackBar(
      context,
      SnackBar(
        content: Text(result['message']?.toString() ?? 'Event update'),
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
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.prostitutionTitle)),
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
          : Column(
              children: [
                if (_latestIncomingSabotage != null)
                  _buildUnderAttackBanner(_latestIncomingSabotage!),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed:
                          (_housingSummary == null ||
                                  _housingSummary!.freeSlots > 0) &&
                              (_cooldownSeconds == null ||
                                  _cooldownSeconds == 0) &&
                              (_jailSeconds == null || _jailSeconds == 0) &&
                              !_isRecruiting
                          ? _recruitProstitute
                          : null,
                      icon: _isRecruiting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.person_add),
                      label: Text(
                        _housingSummary != null &&
                                _housingSummary!.freeSlots <= 0
                            ? _tr(
                                'Koop eerst huis/appartement',
                                'Buy a house/apartment first',
                              )
                            : _jailSeconds != null && _jailSeconds! > 0
                            ? '${l10n.jail} (${_formatCooldown(_jailSeconds!)})'
                            : _cooldownSeconds != null && _cooldownSeconds! > 0
                            ? '${l10n.prostitutionRecruit} (${_formatCooldown(_cooldownSeconds!)})'
                            : l10n.prostitutionRecruit,
                      ),
                    ),
                  ),
                ),
                if (_housingSummary != null && _housingSummary!.freeSlots <= 0)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: Text(
                      _tr(
                        'Geen vrije woonplek. Koop of upgrade een huis/appartement voordat je nieuwe hoeren kunt pimpen.',
                        'No free housing slot. Buy or upgrade a house/apartment before recruiting more prostitutes.',
                      ),
                      style: TextStyle(
                        color: Colors.orange.shade300,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                const SizedBox(height: 12),
                TabBar(
                  controller: _tabController,
                  labelColor: theme.colorScheme.primary,
                  unselectedLabelColor: Colors.grey,
                  isScrollable: true,
                  tabs: [
                    Tab(text: l10n.prostitutionMyProstitutes),
                    Tab(text: l10n.vipEventsTabTitle),
                    Tab(text: l10n.prostitutionLeaderboardButton),
                    Tab(text: l10n.prostitutionRivalryButton),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildProstitutesTab(),
                      _buildEventsTab(),
                      const ProstitutionLeaderboardScreen(),
                      const ProstitutionRivalryScreen(),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildProstitutesTab() {
    if (_isLoading) return const Center(child: CircularProgressIndicator());

    if (_prostitutes.isEmpty) {
      return Center(
        child: Text(AppLocalizations.of(context)!.prostitutionNoProstitutes),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Responsive grid: 2 columns on mobile, 3 on tablet, 6 on desktop
          int crossAxisCount;
          if (constraints.maxWidth >= 1200) {
            crossAxisCount = 6; // Desktop
          } else if (constraints.maxWidth >= 800) {
            crossAxisCount = 3; // Tablet
          } else {
            crossAxisCount = 2; // Mobile
          }

          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_housingSummary != null) ...[
                  Container(
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
                          _tr('Huisvesting', 'Housing'),
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _tr(
                            'Elke hoer moet minstens 1 shift per ${_housingSummary!.graceDays} dagen werken om de huur te betalen.',
                            'Each prostitute must work at least 1 shift every ${_housingSummary!.graceDays} days to cover rent.',
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _buildHousingChip(
                              _tr('Plekken', 'Slots'),
                              '${_housingSummary!.occupiedSlots}/${_housingSummary!.totalCapacity}',
                            ),
                            _buildHousingChip(
                              _tr('Vrij', 'Free'),
                              '${_housingSummary!.freeSlots}',
                            ),
                            _buildHousingChip(
                              _tr('Woningen', 'Homes'),
                              '${_housingSummary!.residentialProperties}',
                            ),
                            _buildHousingChip(
                              _tr('Upgrade gem.', 'Avg upgrade'),
                              _housingSummary!.averageResidentialUpgrade
                                  .toStringAsFixed(1),
                            ),
                            _buildHousingChip(
                              _tr('Geluk bonus', 'Happiness bonus'),
                              '+${_housingSummary!.housingHappinessBonusPercent}%',
                            ),
                            _buildHousingChip(
                              _tr('Weekhuur', 'Weekly rent'),
                              '€${_housingSummary!.totalWeeklyRent}',
                            ),
                            _buildHousingChip(
                              _tr('Risico', 'At risk'),
                              '${_housingSummary!.atRiskCount}',
                            ),
                            _buildHousingChip(
                              _tr('Veilig', 'Safe'),
                              '${_housingSummary!.safeCount}',
                            ),
                          ],
                        ),
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
                              _tr(
                                'Verraad actief: ${_housingSummary!.seizedDrugsGrams}g drugs in beslag genomen, ${_housingSummary!.nightclubLicensesRevoked} nightclub vergunning(en) kwijt.',
                                'Betrayal triggered: ${_housingSummary!.seizedDrugsGrams}g drugs seized, ${_housingSummary!.nightclubLicensesRevoked} nightclub license(s) revoked.',
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
                  ),
                  const SizedBox(height: 12),
                ],
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    // Fixed tile height prevents card overflow on wide desktop layouts.
                    mainAxisExtent: 380,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: _prostitutes.length,
                  itemBuilder: (context, index) =>
                      _buildProstituteCard(_prostitutes[index]),
                ),
              ],
            ),
          );
        },
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
    final happinessLabel = _tr(
      prostitute.happinessLabel == 'ecstatic'
          ? 'Extatisch'
          : prostitute.happinessLabel == 'happy'
          ? 'Blij'
          : prostitute.happinessLabel == 'stable'
          ? 'Stabiel'
          : prostitute.happinessLabel == 'stressed'
          ? 'Gestrest'
          : 'Miserabel',
      prostitute.happinessLabel,
    );
    final housingRemaining = prostitute.housingTimeRemaining;
    final housingLabel = prostitute.isHousingExpired
        ? _tr('Verlopen', 'Expired')
        : housingRemaining == null
        ? '-'
        : housingRemaining.inDays >= 1
        ? _tr(
            '${housingRemaining.inDays}d over',
            '${housingRemaining.inDays}d left',
          )
        : _tr('minder dan 1 dag', 'less than 1 day');

    // Calculate hourly earnings
    final base = prostitute.isInRedLight
        ? (prostitute.redLightRoom != null
              ? _getTierGrossEarnings(prostitute.redLightRoom!.tier)
              : 40.0)
        : 40.0;
    final levelBonus = base * (prostitute.level - 1) * 0.05;
    final vipBonus = isVip ? base * 0.5 : 0;
    final hourlyEarnings = base + levelBonus + vipBonus;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 4,
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
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
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
                                prostitute.isInRedLight
                                    ? Icons.business
                                    : Icons.location_on,
                                size: 12,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  prostitute.isInRedLight
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
                              if (!prostitute.isInRedLight && !isBusted)
                                Semantics(
                                  button: true,
                                  label: l10n.prostitutionMoveToRedLight,
                                  child: Tooltip(
                                    message: l10n.prostitutionMoveToRedLight,
                                    child: TextButton(
                                      onPressed: () =>
                                          _moveProstituteToCurrentCountryRld(
                                            prostitute,
                                          ),
                                      style: TextButton.styleFrom(
                                        minimumSize: const Size(0, 22),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 0,
                                        ),
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        visualDensity: VisualDensity.compact,
                                      ),
                                      child: Text(
                                        l10n.prostitutionMoveToRldShort,
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '€${(hourlyEarnings * prostitute.happinessEarningsMultiplier).toStringAsFixed(0)}/uur',
                            style: const TextStyle(
                              color: Colors.green,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            _tr(
                              'Geluk $happinessLabel (${prostitute.happinessScore}%) • Opbrengst ${prostitute.happinessEarningsBonusPercent >= 0 ? '+' : ''}${prostitute.happinessEarningsBonusPercent}%',
                              'Happiness $happinessLabel (${prostitute.happinessScore}%) • Yield ${prostitute.happinessEarningsBonusPercent >= 0 ? '+' : ''}${prostitute.happinessEarningsBonusPercent}%',
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
                                  _tr(
                                    'Huisvesting: $housingLabel',
                                    'Housing: $housingLabel',
                                  ),
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _tr(
                                    'Weekhuur €${prostitute.weeklyHousingCost}',
                                    'Weekly rent €${prostitute.weeklyHousingCost}',
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
                                onPressed: () => _executeWorkShift(prostitute),
                                icon: const Icon(Icons.work, size: 14),
                                label: Text(
                                  _tr('Werk 8 uur', 'Work 8h'),
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue.shade700,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 6,
                                  ),
                                  minimumSize: const Size(0, 28),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
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
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.blue.shade600,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                  ],
                ),
              ),
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
          Text(
            l10n.vipEventsActive,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          if (_activeEvents.isEmpty)
            _buildEventsPlaceholder(l10n.vipEventNoActive)
          else
            ..._activeEvents.map(_buildEventCard),
          const SizedBox(height: 16),
          Text(
            l10n.vipEventsUpcoming,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          if (_upcomingEvents.isEmpty)
            _buildEventsPlaceholder(l10n.vipEventNoUpcoming)
          else
            ..._upcomingEvents.map(_buildEventCard),
          const SizedBox(height: 16),
          if (_myParticipations.isNotEmpty) ...[
            Text(
              l10n.vipEventsMyParticipations,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            ..._myParticipations.map(_buildParticipationCard),
          ],
        ],
      ),
    );
  }

  Widget _buildEventCard(VipEvent event) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${event.eventTypeIcon} ${event.title}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              '${_localizedEventType(event.eventType, l10n)} • ${event.bonusText} ${l10n.vipEventBonus}',
            ),
            const SizedBox(height: 4),
            Text(
              '${l10n.vipEventParticipants}: ${event.currentParticipants}/${event.maxParticipants}',
            ),
            const SizedBox(height: 8),
            if (event.isActive && !event.isFull)
              ElevatedButton(
                onPressed: () => _showAssignDialog(event),
                child: Text(l10n.vipEventAssignProstitute),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildParticipationCard(EventParticipation participation) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        title: Text(participation.event?.title ?? l10n.vipEventTypeTitle),
        subtitle: Text(
          '${l10n.vipEventAssigned}: ${participation.prostitute?.name ?? '-'}',
        ),
        trailing: TextButton(
          onPressed: () => _leaveEvent(participation),
          child: Text(l10n.vipEventLeave),
        ),
      ),
    );
  }

  Widget _buildEventsPlaceholder(String message) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(message),
    );
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
