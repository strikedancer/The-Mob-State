import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../l10n/app_localizations.dart';
import '../services/api_client.dart';
import '../utils/top_right_notification.dart';

/// Combined gym + shooting range (single entry from dashboard).
class TrainingHubScreen extends StatefulWidget {
  const TrainingHubScreen({super.key, this.onOpenCrimes});

  /// When set (e.g. embedded web dashboard), switches to the crimes section.
  final VoidCallback? onOpenCrimes;

  @override
  State<TrainingHubScreen> createState() => _TrainingHubScreenState();
}

class _TrainingHubScreenState extends State<TrainingHubScreen> {
  static const Color _hubGold = Color(0xFFD4AF37);
  static const Color _panelBg = Color(0xFF1A1210);
  static const Color _panelBorder = Color(0xFF3A2820);

  final ApiClient _apiClient = ApiClient();

  bool _isLoading = true;
  String? _trainingGymTrack;
  bool _trainingShooting = false;

  Map<String, dynamic>? _gymStatus;
  Map<String, dynamic>? _shootingStatus;
  bool _comboActive = false;
  double _comboBonusFraction = 0;

  Timer? _tickTimer;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadAll();
    _tickTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _now = DateTime.now());
      _maybeRefreshOnCooldownEnd();
    });
  }

  @override
  void dispose() {
    _tickTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadAll({bool showFullPageLoader = true}) async {
    if (showFullPageLoader) {
      setState(() => _isLoading = true);
    }
    try {
      final combined = await _apiClient.get('/training/status');
      if (combined.statusCode == 200) {
        final data = jsonDecode(combined.body) as Map<String, dynamic>?;
        if (!mounted) return;
        final combo = data?['trainingComboReadiness'] as Map<String, dynamic>?;
        final comboFrac =
            (combo?['bonusFraction'] as num?)?.toDouble() ?? 0.0;
        final comboOn = combo?['active'] == true && comboFrac > 0;
        setState(() {
          _gymStatus = data?['gym'] as Map<String, dynamic>?;
          _shootingStatus = data?['shootingRange'] as Map<String, dynamic>?;
          _comboActive = comboOn;
          _comboBonusFraction = comboFrac;
          _isLoading = false;
          _now = DateTime.now();
        });
        return;
      }
    } catch (_) {
      // Fall through to legacy dual fetch (older servers).
    }
    try {
      final results = await Future.wait([
        _apiClient.get('/gym/status'),
        _apiClient.get('/shooting-range/status'),
      ]);
      if (!mounted) return;
      final gymData = jsonDecode(results[0].body) as Map<String, dynamic>?;
      final shootData = jsonDecode(results[1].body) as Map<String, dynamic>?;
      setState(() {
        _gymStatus = gymData?['status'] as Map<String, dynamic>?;
        _shootingStatus = shootData?['status'] as Map<String, dynamic>?;
        _comboActive = false;
        _comboBonusFraction = 0;
        _isLoading = false;
        _now = DateTime.now();
      });
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _maybeRefreshOnCooldownEnd() {
    if (_isLoading || _trainingGymTrack != null || _trainingShooting) return;
    final gym = _gymStatus;
    final shooting = _shootingStatus;
    if (gym == null && shooting == null) return;

    bool wasBlocked(String? raw, bool canTrain) {
      if (canTrain) return false;
      final at = _parseAt(raw);
      if (at == null) return false;
      final diff = at.difference(_now);
      return diff.inSeconds <= 0 && diff.inSeconds > -2;
    }

    final gymBlocked = wasBlocked(
      gym?['nextTrainAtStrength']?.toString() ?? gym?['nextTrainAt']?.toString(),
      gym?['canTrainStrength'] == true,
    ) ||
        wasBlocked(
          gym?['nextTrainAtSpeed']?.toString(),
          gym?['canTrainSpeed'] == true,
        ) ||
        wasBlocked(
          gym?['nextTrainAtStamina']?.toString(),
          gym?['canTrainStamina'] == true,
        );
    final rangeBlocked = wasBlocked(
      shooting?['nextTrainAt']?.toString(),
      shooting?['canTrain'] == true,
    );

    if (gymBlocked || rangeBlocked) {
      _loadAll(showFullPageLoader: false);
    }
  }

  static DateTime? _parseAt(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    return DateTime.tryParse(raw)?.toLocal();
  }

  static (String? reason, DateTime? nextAt) _parseGymFailure(
    Map<String, dynamic>? data,
  ) {
    if (data == null) return (null, null);
    final params = data['params'] as Map<String, dynamic>?;
    final reason = params?['reason']?.toString();
    final raw = params?['nextTrainAt']?.toString();
    return (reason, _parseAt(raw));
  }

  static (String? reason, DateTime? nextAt) _parseShootingFailure(
    Map<String, dynamic>? data,
  ) {
    if (data == null) return (null, null);
    final reason = data['error']?.toString();
    final raw = data['nextTrainAt']?.toString();
    return (reason, _parseAt(raw));
  }

  String? _pickSmartTrainTrack() {
    final status = _gymStatus ?? {};
    if (status['canTrainStrength'] == true) return 'strength';
    if (status['canTrainSpeed'] == true) return 'speed';
    if (status['canTrainStamina'] == true) return 'stamina';
    return null;
  }

  Future<void> _trainGymTrack(String track) async {
    final l10n = AppLocalizations.of(context);
    setState(() => _trainingGymTrack = track);
    try {
      final response =
          await _apiClient.post('/gym/train', {'track': track});
      final data = jsonDecode(response.body) as Map<String, dynamic>?;
      if (response.statusCode == 200) {
        if (mounted) {
          showTopRightFromSnackBar(
            context,
            SnackBar(
              content: Text(l10n?.gymTrainSuccess ?? 'Training complete'),
            ),
          );
        }
        await _loadAll(showFullPageLoader: false);
      } else if (mounted) {
        final (reason, nextAt) = _parseGymFailure(data);
        final msg = _messageForGymFailure(l10n, reason, nextAt);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg)),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n?.unknownError ?? 'Error')),
        );
      }
    } finally {
      if (mounted) setState(() => _trainingGymTrack = null);
    }
  }

  Future<void> _smartTrainGym() async {
    final track = _pickSmartTrainTrack();
    if (track != null) await _trainGymTrack(track);
  }

  Future<void> _trainShooting() async {
    final l10n = AppLocalizations.of(context);
    setState(() => _trainingShooting = true);
    try {
      final response = await _apiClient.post('/shooting-range/train', {});
      Map<String, dynamic>? data;
      try {
        data = jsonDecode(response.body) as Map<String, dynamic>?;
      } catch (_) {
        data = null;
      }
      if (response.statusCode == 200) {
        if (mounted) {
          showTopRightFromSnackBar(
            context,
            SnackBar(
              content: Text(
                l10n?.shootingTrainSuccess ?? 'Training complete',
              ),
            ),
          );
        }
        await _loadAll(showFullPageLoader: false);
      } else if (mounted) {
        final (reason, nextAt) = _parseShootingFailure(data);
        final msg = _messageForShootingFailure(l10n, reason, nextAt, data);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg)),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n?.unknownError ?? 'Error')),
        );
      }
    } finally {
      if (mounted) setState(() => _trainingShooting = false);
    }
  }

  String _messageForGymFailure(
    AppLocalizations? l10n,
    String? reason,
    DateTime? nextAt,
  ) {
    switch (reason) {
      case 'MAX_SESSIONS':
        return l10n?.gymMaxSessionsReached ?? 'Maximum sessions reached';
      case 'COOLDOWN':
        final label =
            nextAt != null ? DateFormat('HH:mm').format(nextAt) : '-';
        return l10n?.gymCooldown(label) ?? 'Next session at $label';
      default:
        return l10n?.unknownError ?? 'Error';
    }
  }

  String _messageForShootingFailure(
    AppLocalizations? l10n,
    String? reason,
    DateTime? nextAt,
    Map<String, dynamic>? data,
  ) {
    switch (reason) {
      case 'MAX_SESSIONS':
        return l10n?.shootingMaxSessionsReached ??
            'Maximum training sessions reached';
      case 'COOLDOWN':
        final label =
            nextAt != null ? DateFormat('HH:mm').format(nextAt) : '-';
        return l10n?.shootingCooldownLabel(label) ?? 'Next session at: $label';
      default:
        return data?['message']?.toString() ??
            (l10n?.unknownError ?? 'Error');
    }
  }

  String _formatCountdown(DateTime? nextAt, AppLocalizations? l10n) {
    if (nextAt == null) return l10n?.gymCountdownReady ?? 'Ready';
    final diff = nextAt.difference(_now);
    if (diff.inSeconds <= 0) return l10n?.gymCountdownReady ?? 'Ready';
    final h = diff.inHours;
    final m = diff.inMinutes.remainder(60);
    final s = diff.inSeconds.remainder(60);
    final time = h > 0
        ? '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}'
        : '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
    return l10n?.gymCountdownLabel(time) ?? 'Next in $time';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final wide = MediaQuery.sizeOf(context).width >= 960;

    if (_isLoading) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1A0A0A), Color(0xFF120808)],
            ),
          ),
          child: Center(
            child: CircularProgressIndicator(color: _hubGold),
          ),
        ),
      );
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1A0A0A), Color(0xFF120808)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHubHeader(context, l10n),
                const SizedBox(height: 16),
                if (wide)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildGymColumn(context, l10n)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildShootingColumn(context, l10n)),
                    ],
                  )
                else ...[
                  _buildGymColumn(context, l10n),
                  const SizedBox(height: 20),
                  _buildShootingColumn(context, l10n),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHubHeader(BuildContext context, AppLocalizations? l10n) {
    final comboPct = (_comboBonusFraction * 100).toStringAsFixed(1);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF4A2814).withValues(alpha: 0.98),
            const Color(0xFF1A0A06),
          ],
        ),
        border: Border.all(
          color: _hubGold.withValues(alpha: 0.55),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _hubGold.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _hubGold.withValues(alpha: 0.35)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.fitness_center,
                      size: 30,
                      color: Colors.red.shade400,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(Icons.add, size: 16, color: Colors.white54),
                    ),
                    Icon(
                      Icons.gps_fixed,
                      size: 28,
                      color: Colors.deepOrange.shade300,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n?.trainingHubTitle ?? 'Training hub',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      l10n?.trainingHubSubtitle ??
                          'Strength at the gym and accuracy at the range both raise your crime success chance.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white70,
                            height: 1.35,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (_comboActive) ...[
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: Chip(
                avatar: Icon(
                  Icons.bolt,
                  size: 18,
                  color: Colors.amber.shade300,
                ),
                label: Text(
                  l10n?.trainingHubComboChip(comboPct) ??
                      'Combo active: +$comboPct% on crimes',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                backgroundColor: Colors.amber.withValues(alpha: 0.18),
                side: BorderSide(color: Colors.amber.withValues(alpha: 0.45)),
              ),
            ),
          ],
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              if (widget.onOpenCrimes != null)
                FilledButton.tonalIcon(
                  onPressed: widget.onOpenCrimes,
                  icon: const Icon(Icons.warning_amber_rounded, size: 20),
                  label: Text(l10n?.trainingHubOpenCrimes ?? 'Open crimes'),
                  style: FilledButton.styleFrom(
                    foregroundColor: Colors.orange.shade50,
                    backgroundColor: Colors.red.shade900.withValues(alpha: 0.55),
                  ),
                ),
              Tooltip(
                message: l10n?.trainingHubRefreshTooltip ??
                    'Reload status from the server',
                child: OutlinedButton.icon(
                  onPressed: _isLoading
                      ? null
                      : () => _loadAll(showFullPageLoader: false),
                  icon: const Icon(Icons.refresh, size: 20),
                  label: Text(l10n?.trainingHubRefreshStatus ?? 'Refresh'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: _hubGold),
                  ),
                ),
              ),
            ],
          ),
          Theme(
            data: Theme.of(context).copyWith(
              dividerColor: Colors.white24,
              splashColor: _hubGold.withValues(alpha: 0.12),
              highlightColor: _hubGold.withValues(alpha: 0.08),
            ),
            child: ExpansionTile(
              tilePadding: EdgeInsets.zero,
              childrenPadding: const EdgeInsets.only(bottom: 8),
              iconColor: _hubGold,
              collapsedIconColor: _hubGold,
              title: Text(
                l10n?.trainingHubMoreInfoTitle ?? 'More options',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              children: [
                ListTile(
                  leading: Icon(Icons.bolt, color: Colors.amber.shade300),
                  title: Text(
                    l10n?.trainingHubMoreInfoCombo ??
                        'Same UTC day: train both tracks for a small extra crime bonus.',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  dense: true,
                ),
                ListTile(
                  leading: Icon(Icons.schedule, color: Colors.orange.shade200),
                  title: Text(
                    l10n?.trainingHubMoreInfoSeparate ??
                        'Each track has its own cooldown and session cap.',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  dense: true,
                ),
                ListTile(
                  leading: Icon(Icons.gps_fixed, color: Colors.orange.shade200),
                  title: Text(
                    l10n?.trainingHubMoreInfoHitlist ??
                        'Shooting range progress also feeds hitlist calculations on the server.',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  dense: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGymColumn(BuildContext context, AppLocalizations? l10n) {
    final status = _gymStatus ?? {};
    final aggregateBonus = ((status['strengthBonus'] as num?) ?? 0) * 100;
    final canSmartTrain = _pickSmartTrainTrack() != null;

    return _sectionShell(
      context: context,
      bgAsset: 'assets/images/backgrounds/gym_bg.png',
      accent: Colors.red,
      sectionTitle: l10n?.trainingHubSectionGym ?? (l10n?.gym ?? 'Gym'),
      sectionIntro: l10n?.gymIntro ??
          'Train your strength and increase your crime success rate',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _darkPanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n?.gymAggregateBonusTitle ?? 'Total gym crime bonus',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '+${aggregateBonus.toStringAsFixed(1)}% / +8%',
                  style: TextStyle(
                    color: Colors.red.shade300,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n?.gymBonusAppliedToCrimes ??
                      'Applied to crime success chance.',
                  style: const TextStyle(color: Colors.white60, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _buildGymTrackCard(
            context,
            l10n,
            track: 'strength',
            title: l10n?.gymTrackStrengthTitle ?? 'Strength',
            sessions: status['sessionsCompleted'] ?? 0,
            trackBonus: status['strengthTrackBonus'],
            maxTrackBonus: 4.0,
            canTrain: status['canTrainStrength'] == true,
            nextTrainAt: _parseAt(
              status['nextTrainAtStrength']?.toString() ??
                  status['nextTrainAt']?.toString(),
            ),
            accent: Colors.red,
            icon: Icons.fitness_center,
          ),
          const SizedBox(height: 10),
          _buildGymTrackCard(
            context,
            l10n,
            track: 'speed',
            title: l10n?.gymTrackSpeedTitle ?? 'Speed',
            sessions: status['speedSessionsCompleted'] ?? 0,
            trackBonus: status['speedTrackBonus'],
            maxTrackBonus: 2.0,
            canTrain: status['canTrainSpeed'] == true,
            nextTrainAt: _parseAt(status['nextTrainAtSpeed']?.toString()),
            accent: Colors.orange,
            icon: Icons.directions_run,
          ),
          const SizedBox(height: 10),
          _buildGymTrackCard(
            context,
            l10n,
            track: 'stamina',
            title: l10n?.gymTrackStaminaTitle ?? 'Stamina',
            sessions: status['staminaSessionsCompleted'] ?? 0,
            trackBonus: status['staminaTrackBonus'],
            maxTrackBonus: 2.0,
            canTrain: status['canTrainStamina'] == true,
            nextTrainAt: _parseAt(status['nextTrainAtStamina']?.toString()),
            accent: Colors.deepOrange,
            icon: Icons.favorite,
          ),
          const SizedBox(height: 12),
          _darkPanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n?.gymSmartTrain ?? 'Smart train',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n?.gymSmartTrainHint ??
                      'Trains the first track that is ready.',
                  style: const TextStyle(color: Colors.white60, fontSize: 12),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: canSmartTrain && _trainingGymTrack == null
                        ? _smartTrainGym
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _hubGold,
                      foregroundColor: Colors.black87,
                      disabledBackgroundColor: Colors.grey.shade800,
                    ),
                    icon: _trainingGymTrack != null
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.auto_fix_high),
                    label: Text(l10n?.gymSmartTrain ?? 'Smart train'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _howItWorksCard(context, l10n, isGym: true),
        ],
      ),
    );
  }

  Widget _buildGymTrackCard(
    BuildContext context,
    AppLocalizations? l10n, {
    required String track,
    required String title,
    required num sessions,
    required dynamic trackBonus,
    required double maxTrackBonus,
    required bool canTrain,
    required DateTime? nextTrainAt,
    required Color accent,
    required IconData icon,
  }) {
    final bonusPct = ((trackBonus as num?) ?? 0) * 100;
    final progress = sessions / 100.0;
    final isTraining = _trainingGymTrack == track;

    return _darkPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(icon, color: accent, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
              Text(
                '$sessions/100',
                style: TextStyle(
                  color: accent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor: Colors.white12,
              valueColor: AlwaysStoppedAnimation<Color>(accent),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${l10n?.gymTrackBonusLabel ?? 'Track bonus'}: +${bonusPct.toStringAsFixed(2)}% / +${maxTrackBonus.toStringAsFixed(0)}%',
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
              Text(
                _formatCountdown(canTrain ? null : nextTrainAt, l10n),
                style: TextStyle(
                  color: canTrain ? Colors.green.shade300 : Colors.orange.shade200,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: canTrain && !isTraining && _trainingGymTrack == null
                  ? () => _trainGymTrack(track)
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: accent,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey.shade800,
              ),
              icon: isTraining
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Icon(icon, size: 18),
              label: Text(
                isTraining
                    ? (l10n?.gymTrainingInProgress ?? 'Training…')
                    : (l10n?.gymTrain ?? 'Train'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShootingColumn(BuildContext context, AppLocalizations? l10n) {
    final status = _shootingStatus ?? {};
    final sessions = status['sessionsCompleted'] ?? 0;
    final accuracyBonus = ((status['accuracyBonus'] as num?) ?? 0) * 100;
    final hitlistPct =
        (((status['hitlistAccuracy'] as num?) ?? 0) * 100).toStringAsFixed(1);
    final nextTrainAt = _parseAt(status['nextTrainAt']?.toString());
    final canTrain = status['canTrain'] == true;
    final progress = (sessions as num) / 100.0;
    const maxBonus = 10.0;

    return _sectionShell(
      context: context,
      bgAsset: 'assets/images/backgrounds/shooting_range_bg.png',
      accent: Colors.orange,
      sectionTitle:
          l10n?.trainingHubSectionShooting ?? (l10n?.shootingRange ?? 'Range'),
      sectionIntro: l10n?.shootingIntro ??
          'Improve accuracy and crime success chance.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _darkPanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n?.shootingTrainingProgressTitle ?? 'Training progress',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n?.shootingSessionsCompletedLabel ?? 'Sessions:',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    Text(
                      '$sessions/100',
                      style: TextStyle(
                        color: Colors.orange.shade300,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: progress.clamp(0.0, 1.0),
                    minHeight: 8,
                    backgroundColor: Colors.white12,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.orange.shade400),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _darkPanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n?.shootingCurrentBonusTitle ?? 'Current bonus',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '+${accuracyBonus.toStringAsFixed(1)}% / +${maxBonus.toStringAsFixed(0)}%',
                  style: TextStyle(
                    color: Colors.orange.shade300,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n?.shootingBonusAppliedToCrimes ??
                      'Applied to crime success chance.',
                  style: const TextStyle(color: Colors.white60, fontSize: 12),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n?.trainingHubHitlistAccuracy(hitlistPct) ??
                      'Hitlist accuracy: $hitlistPct%',
                  style: TextStyle(
                    color: Colors.deepOrange.shade200,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _darkPanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Icon(
                      canTrain ? Icons.check_circle : Icons.schedule,
                      color: canTrain ? Colors.green : Colors.orange,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        canTrain
                            ? (l10n?.shootingReadyToTrain ?? 'Ready to train')
                            : (l10n?.shootingTrainingCooldownTitle ??
                                'Cooldown'),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                if (!canTrain) ...[
                  const SizedBox(height: 6),
                  Text(
                    _formatCountdown(nextTrainAt, l10n),
                    style: TextStyle(color: Colors.orange.shade200),
                  ),
                ],
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: canTrain && !_trainingShooting
                        ? _trainShooting
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange.shade700,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey.shade800,
                    ),
                    icon: _trainingShooting
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.gps_fixed),
                    label: Text(
                      _trainingShooting
                          ? (l10n?.shootingTrainingInProgress ?? 'Training…')
                          : (l10n?.shootingTrain ?? 'Train'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _howItWorksCard(context, l10n, isGym: false),
        ],
      ),
    );
  }

  Widget _sectionShell({
    required BuildContext context,
    required String bgAsset,
    required Color accent,
    required String sectionTitle,
    required String sectionIntro,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accent.withValues(alpha: 0.35), width: 1),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: 0.12),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
        image: DecorationImage(
          image: AssetImage(bgAsset),
          fit: BoxFit.cover,
          opacity: 0.12,
        ),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.circle, size: 10, color: accent),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  sectionTitle,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            sectionIntro,
            style: const TextStyle(color: Colors.white60, fontSize: 13),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _darkPanel({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _panelBg.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _panelBorder),
      ),
      child: child,
    );
  }

  Widget _howItWorksCard(
    BuildContext context,
    AppLocalizations? l10n, {
    required bool isGym,
  }) {
    final bullets = isGym
        ? [
            l10n?.gymHowItWorksBullet1 ?? '',
            l10n?.gymHowItWorksBullet2 ?? '',
            l10n?.gymHowItWorksBullet3 ?? '',
            l10n?.gymHowItWorksBullet4 ?? '',
            l10n?.gymHowItWorksBullet5 ?? '',
          ]
        : [
            l10n?.shootingHowItWorksBullet1 ?? '',
            l10n?.shootingHowItWorksBullet2 ?? '',
            l10n?.shootingHowItWorksBullet3 ?? '',
            l10n?.shootingHowItWorksBullet4 ?? '',
            l10n?.shootingHowItWorksBullet5 ?? '',
          ];

    return _darkPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_outline, color: Colors.amber.shade300),
              const SizedBox(width: 8),
              Text(
                isGym
                    ? (l10n?.gymHowItWorksTitle ?? 'How it works')
                    : (l10n?.shootingHowItWorksTitle ?? 'How it works'),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          for (final b in bullets)
            if (b.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  b,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    height: 1.35,
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
