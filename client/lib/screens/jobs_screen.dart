import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../models/job.dart';
import '../providers/auth_provider.dart';
import '../services/api_client.dart';
import '../services/event_renderer.dart';
import '../services/jail_service.dart';
import '../utils/job_localization.dart';
import '../utils/job_flavor_localization.dart';
import '../utils/top_right_notification.dart';
import '../widgets/action_result_toast.dart';
import '../widgets/cooldown_overlay.dart';
import '../widgets/crime_result_overlay.dart';
import '../widgets/education_requirements_dialog.dart';
import '../widgets/jail_screen.dart';
import '../widgets/job_card.dart';
import '../utils/web_asset_helper.dart';
import 'school_screen.dart';

enum _JobListFilter { all, available }

enum _JobListSort { reward, rank, success }

class JobsScreen extends StatefulWidget {
  const JobsScreen({
    super.key,
    this.embedded = false,
    this.onOpenSchool,
  });

  /// When true (web dashboard), hide the page AppBar; the sidebar already names the page.
  final bool embedded;

  /// When set (e.g. web dashboard), opens the school section.
  final VoidCallback? onOpenSchool;

  @override
  State<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen> {
  static const Color _gold = Color(0xFFD4AF37);
  static const Color _panelBg = Color(0xFF151B28);
  static const Color _panelBorder = Color(0xFF2A3344);
  static const Color _jobAccent = Color(0xFF4A9FD4);

  final ApiClient _apiClient = ApiClient();
  final JailService _jailService = JailService();
  List<Job> _jobs = [];
  List<Map<String, dynamic>> _lockedJobs = [];
  bool _isLoading = true;
  bool _isWorking = false;
  String? _error;
  int? _jailTime;
  int? _cooldownSeconds;
  bool _showJobResult = false;
  bool _jobResultSuccess = true;
  String? _resultJobName;
  int _jobEarnings = 0;
  int _jobXpGained = 0;
  int _jobXpLost = 0;
  String? _resultFlavorLine;
  String? _resultTipBonusLabel;
  bool _resultIntelDropped = false;
  _JobListFilter _listFilter = _JobListFilter.available;
  _JobListSort _listSort = _JobListSort.reward;

  @override
  void initState() {
    super.initState();
    _checkJailStatusAndLoadJobs();
  }

  Future<void> _refreshJobsScreen() async {
    await _checkJailStatusAndLoadJobs();
  }

  void _openSchool() {
    if (widget.onOpenSchool != null) {
      widget.onOpenSchool!();
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const SchoolScreen()),
    );
  }

  List<Job> _visibleJobs(int playerRank) {
    final filtered = _jobs.where((job) {
      if (_listFilter == _JobListFilter.available) {
        return playerRank >= job.requiredRank;
      }
      return true;
    }).toList();

    filtered.sort((a, b) {
      switch (_listSort) {
        case _JobListSort.rank:
          final rankCmp = a.requiredRank.compareTo(b.requiredRank);
          if (rankCmp != 0) return rankCmp;
          return b.maxPay.compareTo(a.maxPay);
        case _JobListSort.success:
          final successCmp = (b.successChance ?? 85).compareTo(
            a.successChance ?? 85,
          );
          if (successCmp != 0) return successCmp;
          return b.maxPay.compareTo(a.maxPay);
        case _JobListSort.reward:
          return b.maxPay.compareTo(a.maxPay);
      }
    });

    return filtered;
  }

  Widget _panel({required Widget child, EdgeInsetsGeometry? padding}) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 10),
      padding: padding ?? const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _panelBg.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _panelBorder),
      ),
      child: child,
    );
  }

  Widget _statChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.45)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildPageHero(AppLocalizations l10n, int playerRank) {
    final availableCount =
        _jobs.where((j) => playerRank >= j.requiredRank).length;

    return _panel(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _jobAccent.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _jobAccent.withValues(alpha: 0.45),
                  ),
                ),
                child: const Icon(
                  Icons.work_outline,
                  color: _jobAccent,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.jobScreenHeroTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.jobScreenHeroSubtitle,
                      style: const TextStyle(
                        color: Colors.white70,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _statChip(
                '${_jobs.length} ${l10n.jobs.toLowerCase()}',
                _gold,
              ),
              _statChip(
                '$availableCount ${l10n.jobScreenFilterAvailable.toLowerCase()}',
                Colors.greenAccent,
              ),
              if (_lockedJobs.isNotEmpty)
                _statChip(
                  '${_lockedJobs.length} ${l10n.jobCardEducationRequired.toLowerCase()}',
                  const Color(0xFFFFC107),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPrepStrip(AppLocalizations l10n) {
    if (_lockedJobs.isEmpty) {
      return _panel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.jobScreenPrepTitle,
              style: const TextStyle(
                color: _gold,
                fontWeight: FontWeight.w800,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.jobScreenEducationNudge,
              style: const TextStyle(color: Colors.white60, fontSize: 12),
            ),
            const SizedBox(height: 6),
            Text(
              l10n.jobScreenRepeatPenaltyHint,
              style: const TextStyle(color: Colors.white54, fontSize: 11.5),
            ),
          ],
        ),
      );
    }

    final stripBody = Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _gold.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.school, color: _gold, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.jobScreenEducationStrip(_lockedJobs.length),
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ),
              if (widget.onOpenSchool != null)
                Icon(
                  Icons.chevron_right,
                  color: Colors.white.withValues(alpha: 0.45),
                  size: 18,
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            l10n.jobScreenEducationNudge,
            style: const TextStyle(color: Colors.white60, fontSize: 11.5),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.jobScreenRepeatPenaltyHint,
            style: const TextStyle(color: Colors.white54, fontSize: 11),
          ),
          if (widget.onOpenSchool != null) ...[
            const SizedBox(height: 4),
            Text(
              l10n.jobScreenOpenSchool,
              style: TextStyle(
                color: _gold.withValues(alpha: 0.85),
                fontSize: 11,
              ),
            ),
          ],
        ],
      ),
    );

    return _panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.jobScreenPrepTitle,
            style: const TextStyle(
              color: _gold,
              fontWeight: FontWeight.w800,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 12),
          if (widget.onOpenSchool == null)
            stripBody
          else
            InkWell(
              onTap: _openSchool,
              borderRadius: BorderRadius.circular(10),
              child: stripBody,
            ),
        ],
      ),
    );
  }

  Widget _buildFilterSortBar(AppLocalizations l10n) {
    return _panel(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          ChoiceChip(
            label: Text(l10n.jobScreenFilterAll),
            selected: _listFilter == _JobListFilter.all,
            onSelected: (_) =>
                setState(() => _listFilter = _JobListFilter.all),
            selectedColor: _gold.withValues(alpha: 0.25),
            labelStyle: TextStyle(
              color: _listFilter == _JobListFilter.all
                  ? _gold
                  : Colors.white70,
              fontWeight: FontWeight.w600,
            ),
            side: BorderSide(
              color: _listFilter == _JobListFilter.all
                  ? _gold.withValues(alpha: 0.6)
                  : _panelBorder,
            ),
          ),
          ChoiceChip(
            label: Text(l10n.jobScreenFilterAvailable),
            selected: _listFilter == _JobListFilter.available,
            onSelected: (_) =>
                setState(() => _listFilter = _JobListFilter.available),
            selectedColor: Colors.greenAccent.withValues(alpha: 0.18),
            labelStyle: TextStyle(
              color: _listFilter == _JobListFilter.available
                  ? Colors.greenAccent
                  : Colors.white70,
              fontWeight: FontWeight.w600,
            ),
            side: BorderSide(
              color: _listFilter == _JobListFilter.available
                  ? Colors.greenAccent.withValues(alpha: 0.55)
                  : _panelBorder,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            l10n.jobScreenSortLabel,
            style: const TextStyle(color: Colors.white54, fontSize: 12),
          ),
          DropdownButton<_JobListSort>(
            value: _listSort,
            dropdownColor: _panelBg,
            underline: const SizedBox.shrink(),
            iconEnabledColor: _gold,
            style: const TextStyle(color: Colors.white, fontSize: 12.5),
            items: [
              DropdownMenuItem(
                value: _JobListSort.reward,
                child: Text(l10n.jobScreenSortReward),
              ),
              DropdownMenuItem(
                value: _JobListSort.rank,
                child: Text(l10n.jobScreenSortRank),
              ),
              DropdownMenuItem(
                value: _JobListSort.success,
                child: Text(l10n.jobScreenSortSuccess),
              ),
            ],
            onChanged: (value) {
              if (value == null) return;
              setState(() => _listSort = value);
            },
          ),
        ],
      ),
    );
  }

  int? _readInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }

  Map<String, dynamic>? _asStringKeyedMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) {
      return value.map((key, val) => MapEntry(key.toString(), val));
    }
    return null;
  }

  Future<void> _checkJailStatusAndLoadJobs() async {
    final jailTime = await _jailService.checkJailStatus();

    if (jailTime > 0) {
      if (!mounted) return;
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.refreshPlayer();
      if (!mounted) return;

      setState(() {
        _jailTime = jailTime;
        _isLoading = false;
      });
      return;
    }

    await _loadJobs();
  }

  Future<void> _loadJobs() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Single call: player jobs + optional active job cooldown.
      final response = await _apiClient.get('/jobs/available');

      if (!mounted) return;

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final data = _asStringKeyedMap(decoded) ?? <String, dynamic>{};
        final jobsJson = data['jobs'];
        final lockedJobsJson = data['lockedJobs'];
        final jobs = <Job>[];
        if (jobsJson is List) {
          for (final entry in jobsJson) {
            final map = _asStringKeyedMap(entry);
            if (map == null) continue;
            try {
              jobs.add(Job.fromJson(map));
            } catch (e) {
              debugPrint('[JobsScreen] Skip invalid job payload: $e');
            }
          }
        }

        final lockedJobs = <Map<String, dynamic>>[];
        if (lockedJobsJson is List) {
          for (final entry in lockedJobsJson) {
            final map = _asStringKeyedMap(entry);
            if (map != null) lockedJobs.add(map);
          }
        }

        int? cooldownSeconds;
        final cooldownMap = _asStringKeyedMap(data['cooldown']);
        if (cooldownMap != null) {
          cooldownSeconds = _readInt(cooldownMap['remainingSeconds']);
          if (cooldownSeconds != null && cooldownSeconds <= 0) {
            cooldownSeconds = null;
          }
        }

        setState(() {
          _jobs = jobs;
          _lockedJobs = lockedJobs;
          _cooldownSeconds = cooldownSeconds;
          _isLoading = false;
          _error = null;
        });
      } else {
        debugPrint(
          '[JobsScreen] GET /jobs/available failed: ${response.statusCode} ${response.body}',
        );
        final l10n = AppLocalizations.of(context)!;
        setState(() {
          _error = l10n.errorLoadingJobs;
          _isLoading = false;
        });
      }
    } catch (e, st) {
      debugPrint('[JobsScreen] Load jobs error: $e\n$st');
      if (!mounted) return;
      final loc = AppLocalizations.of(context)!;
      setState(() {
        _error = loc.connectionErrorGeneric;
        _isLoading = false;
      });
    }
  }

  Future<void> _showLockedJobDetails(Map<String, dynamic> job) async {
    final l10n = AppLocalizations.of(context)!;
    final jobId = job['id']?.toString() ?? '';
    final rawName = job['name']?.toString() ?? l10n.jobs;
    final rawDesc = job['description']?.toString() ?? '';
    final locName = JobLocalization.name(jobId, l10n, fallback: rawName);
    final locDesc = JobLocalization.description(jobId, l10n, fallback: rawDesc);
    await EducationRequirementsDialog.show(
      context,
      title: '🔒 $locName',
      subtitle: locDesc.isNotEmpty ? locDesc : null,
      missingRequirements: (job['educationMissing'] as List?) ?? const [],
    );
  }

  _JobPayTier _lockedJobTier(int maxPay) {
    if (maxPay >= 2000) return _JobPayTier.high;
    if (maxPay >= 500) return _JobPayTier.mid;
    return _JobPayTier.low;
  }

  ({Color accent, Color border, String label}) _lockedTierStyle(
    AppLocalizations l10n,
    _JobPayTier tier,
  ) {
    switch (tier) {
      case _JobPayTier.high:
        return (
          accent: _jobAccent,
          border: _jobAccent,
          label: l10n.jobCardTierHigh,
        );
      case _JobPayTier.mid:
        return (
          accent: _gold,
          border: const Color(0xFFFFC107),
          label: l10n.jobCardTierMid,
        );
      case _JobPayTier.low:
        return (
          accent: Colors.white70,
          border: Colors.white24,
          label: l10n.jobCardTierLow,
        );
    }
  }

  Widget _buildLockedJobCard(Map<String, dynamic> job) {
    final l10n = AppLocalizations.of(context)!;
    final jobId = job['id']?.toString() ?? '';
    final rawName = job['name']?.toString() ?? l10n.jobs;
    final rawDesc = job['description']?.toString() ?? '';
    final locName = JobLocalization.name(jobId, l10n, fallback: rawName);
    final locDesc = JobLocalization.description(jobId, l10n, fallback: rawDesc);
    final imageAsset = 'assets/images/jobs/${job['id']}_job.png';
    final maxPay = (job['maxEarnings'] as num?)?.toInt() ?? 0;
    final tierStyle = _lockedTierStyle(l10n, _lockedJobTier(maxPay));
    final isWide = MediaQuery.sizeOf(context).width >= 900;

    return Material(
      color: const Color(0xFF151B28),
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _showLockedJobDetails(job),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  WebAssetHelper.image(
                    imageAsset,
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: const Color(0xFF1E2433),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.work_outline,
                          color: Colors.white54,
                          size: 26,
                        ),
                      );
                    },
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.08),
                          Colors.black.withValues(alpha: 0.72),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 6,
                    left: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.65),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: tierStyle.accent.withValues(alpha: 0.7),
                        ),
                      ),
                      child: Text(
                        tierStyle.label,
                        style: TextStyle(
                          color: tierStyle.accent,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.75),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFFFFC107)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.school,
                            color: Color(0xFFFFC107),
                            size: 11,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            l10n.jobCardEducationRequired,
                            style: const TextStyle(
                              color: Color(0xFFFFC107),
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(color: Colors.black.withValues(alpha: 0.48)),
                  const Center(
                    child: Icon(
                      Icons.lock,
                      color: Color(0xFFFFC107),
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: tierStyle.border.withValues(alpha: 0.45),
                    width: 1.1,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 7, 8, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      locName,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: Colors.white70,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (locDesc.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          locDesc,
                          style: const TextStyle(
                            fontSize: 9,
                            height: 1.2,
                            color: Colors.white54,
                          ),
                          maxLines: isWide ? 2 : 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    const SizedBox(height: 6),
                    Text(
                      l10n.educationLockedJobsSectionTitle,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFFFC107),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _doJob(Job job) async {
    setState(() {
      _isWorking = true;
      _error = null;
    });

    try {
      final response = await _apiClient.post('/jobs/${job.id}/work', {});

      final data = jsonDecode(response.body);
      final eventKey = data['event'] as String;
      final params = (data['params'] as Map<String, dynamic>?) ?? {};

      int readInt(dynamic value) {
        if (value is int) return value;
        if (value is num) return value.round();
        if (value is String) return int.tryParse(value) ?? 0;
        return 0;
      }

      if (eventKey == 'error.cooldown') {
        final remainingSeconds = readInt(params['remainingSeconds']);

        setState(() {
          _isWorking = false;
          _cooldownSeconds = remainingSeconds > 0 ? remainingSeconds : null;
        });
        return;
      }

      if (eventKey == 'error.jailed') {
        final remainingTime = readInt(params['remainingTime']);
        final l10n = AppLocalizations.of(context)!;
        final eventRenderer = EventRenderer(l10n);
        final message = eventRenderer.renderEvent(eventKey, params);

        setState(() {
          _isWorking = false;
          _jailTime = remainingTime;
        });

        if (mounted) {
          showTopRightFromSnackBar(
            context,
            SnackBar(
              content: Text(message),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: remainingTime > 60 ? 10 : 5),
            ),
          );
        }
        return;
      }

      final l10n = AppLocalizations.of(context)!;
      final eventRenderer = EventRenderer(l10n);
      final message = eventRenderer.renderEvent(eventKey, params);
      final success =
          eventKey.contains('completed') || eventKey.contains('success');
      final earnings = readInt(params['earnings']);
      final xpGained = readInt(params['xpGained']);
      final xpLost = readInt(params['xpLost']);
      final flavorKey = params['flavorKey']?.toString();
      final tipBonusAmount = readInt(params['tipBonusAmount']);
      final intelDropped = params['intelDropped'] == true;
      final flavorLine = jobFlavorText(l10n, flavorKey);
      final tipBonusLabel = tipBonusAmount > 0
          ? l10n.jobResultTipBonus(tipBonusAmount.toString())
          : null;

      int? cooldownSeconds;
      if (data.containsKey('cooldown') && data['cooldown'] != null) {
        final cooldownData = data['cooldown'] as Map<String, dynamic>;
        if (cooldownData['remainingSeconds'] != null) {
          cooldownSeconds = readInt(cooldownData['remainingSeconds']);
        }
      }

      if (mounted) {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        if (data.containsKey('player')) {
          final playerData = data['player'] as Map<String, dynamic>;
          authProvider.updatePlayerStats(
            money: playerData['money'] as int?,
            xp: playerData['xp'] as int?,
            rank: playerData['rank'] as int?,
          );
        } else {
          await authProvider.refreshPlayer();
        }
      }

      if (!mounted) return;

      if (success && (earnings > 0 || xpGained > 0)) {
        setState(() {
          _isWorking = false;
          _jobResultSuccess = true;
          _resultJobName = JobLocalization.name(
            job.id,
            l10n,
            fallback: job.name,
          );
          _jobEarnings = earnings;
          _jobXpGained = xpGained;
          _jobXpLost = 0;
          _resultFlavorLine = flavorLine;
          _resultTipBonusLabel = tipBonusLabel;
          _resultIntelDropped = intelDropped;
          _showJobResult = true;
          if (cooldownSeconds != null && cooldownSeconds > 0) {
            _cooldownSeconds = cooldownSeconds;
          }
        });
        return;
      }

      if (!success) {
        setState(() {
          _isWorking = false;
          _jobResultSuccess = false;
          _resultJobName = JobLocalization.name(
            job.id,
            l10n,
            fallback: job.name,
          );
          _jobEarnings = 0;
          _jobXpGained = 0;
          _jobXpLost = xpLost;
          _resultFlavorLine = flavorLine;
          _resultTipBonusLabel = null;
          _resultIntelDropped = false;
          _showJobResult = true;
          if (cooldownSeconds != null && cooldownSeconds > 0) {
            _cooldownSeconds = cooldownSeconds;
          }
        });
        return;
      }

      setState(() {
        _isWorking = false;
        if (cooldownSeconds != null && cooldownSeconds > 0) {
          _cooldownSeconds = cooldownSeconds;
        }
      });

      if (mounted) {
        showActionResultToast(
          context,
          title: message,
          success: success,
        );
      }
    } catch (e) {
      setState(() {
        final l10n = AppLocalizations.of(context)!;
        _error = l10n.error(e.toString());
        _isWorking = false;
      });
    }
  }

  SliverGrid _buildJobGrid({
    required List<Job> jobs,
    required int playerRank,
  }) {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).size.width < 480
            ? 2
            : MediaQuery.of(context).size.width < 900
            ? 3
            : 5,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.82,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final job = jobs[index];
          final canWork = playerRank >= job.requiredRank;
          final locName = JobLocalization.name(
            job.id,
            AppLocalizations.of(context)!,
            fallback: job.name,
          );
          final locDesc = JobLocalization.description(
            job.id,
            AppLocalizations.of(context)!,
            fallback: job.description ?? '',
          );

          return JobCard(
            job: job,
            canWork: canWork,
            isWorking: _isWorking,
            onTap: () => _doJob(job),
            jobName: locName,
            jobDescription: locDesc,
          );
        },
        childCount: jobs.length,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authProvider = Provider.of<AuthProvider>(context);
    final player = authProvider.currentPlayer;
    final playerRank = player?.rank ?? 1;

    return Scaffold(
      appBar: widget.embedded ? null : AppBar(title: Text(l10n.jobs)),
      backgroundColor: widget.embedded ? Colors.transparent : null,
      body: _showJobResult
          ? CrimeResultOverlay(
              embedded: kIsWeb,
              isSuccess: _jobResultSuccess,
              headline:
                  _jobResultSuccess ? l10n.jobOutcomeSuccess : null,
              crimeName: _resultJobName ?? l10n.jobs,
              reward: _jobEarnings,
              xpGained: _jobXpGained,
              xpLost: _jobXpLost,
              flavorLine: _resultFlavorLine,
              tipBonusLabel: _resultTipBonusLabel,
              intelDropped: _resultIntelDropped,
              onContinue: () {
                setState(() {
                  _showJobResult = false;
                  _jobResultSuccess = true;
                  _resultJobName = null;
                  _jobEarnings = 0;
                  _jobXpGained = 0;
                  _jobXpLost = 0;
                  _resultFlavorLine = null;
                  _resultTipBonusLabel = null;
                  _resultIntelDropped = false;
                });
              },
            )
          : _cooldownSeconds != null && _cooldownSeconds! > 0
          ? CooldownOverlay(
              actionType: 'job',
              cooldownActionType: 'job',
              remainingSeconds: _cooldownSeconds!,
              embedded: kIsWeb,
              onExpired: () {
                setState(() {
                  _cooldownSeconds = null;
                });
                _checkJailStatusAndLoadJobs();
              },
            )
          : _jailTime != null && _jailTime! > 0
          ? JailOverlay(
              embedded: kIsWeb,
              remainingSeconds: _jailTime!,
              wantedLevel: player?.wantedLevel,
              onReleased: () {
                setState(() {
                  _jailTime = null;
                });
                _loadJobs();
              },
            )
          : _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _error!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed:
                          _isWorking ? null : _checkJailStatusAndLoadJobs,
                      icon: const Icon(Icons.refresh),
                      label: Text(l10n.retry),
                    ),
                  ],
                ),
              ),
            )
          : RefreshIndicator(
              color: _gold,
              onRefresh: _refreshJobsScreen,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF101820), Color(0xFF0C0A0A)],
                  ),
                  image: DecorationImage(
                    image: AssetImage('assets/images/backgrounds/gym_bg.png'),
                    fit: BoxFit.cover,
                    opacity: 0.18,
                  ),
                ),
                child: CustomScrollView(
                  slivers: [
                    const SliverToBoxAdapter(child: SizedBox(height: 12)),
                    SliverToBoxAdapter(
                      child: _buildPageHero(l10n, playerRank),
                    ),
                    SliverToBoxAdapter(child: _buildPrepStrip(l10n)),
                    SliverToBoxAdapter(child: _buildFilterSortBar(l10n)),
                    Builder(
                      builder: (context) {
                        final visibleJobs = _visibleJobs(playerRank);
                        if (visibleJobs.isEmpty) {
                          return SliverToBoxAdapter(
                            child: _panel(
                              child: Text(
                                l10n.jobScreenNoMatches,
                                style: const TextStyle(color: Colors.white70),
                              ),
                            ),
                          );
                        }
                        return _buildJobGrid(
                          jobs: visibleJobs,
                          playerRank: playerRank,
                        );
                      },
                    ),
                    if (_lockedJobs.isNotEmpty) ...[
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                          child: Text(
                            l10n.educationLockedJobsSectionTitle,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 20),
                        sliver: SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:
                                MediaQuery.of(context).size.width < 480
                                ? 2
                                : MediaQuery.of(context).size.width < 900
                                ? 3
                                : 5,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 0.82,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) =>
                                _buildLockedJobCard(_lockedJobs[index]),
                            childCount: _lockedJobs.length,
                          ),
                        ),
                      ),
                    ] else
                      const SliverToBoxAdapter(child: SizedBox(height: 20)),
                  ],
                ),
              ),
            ),
    );
  }
}

enum _JobPayTier { low, mid, high }
