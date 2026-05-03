import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../l10n/app_localizations.dart';
import '../services/api_client.dart';
import '../utils/top_right_notification.dart';

/// Combined gym + shooting range (single entry from dashboard).
class TrainingHubScreen extends StatefulWidget {
  const TrainingHubScreen({super.key});

  @override
  State<TrainingHubScreen> createState() => _TrainingHubScreenState();
}

class _TrainingHubScreenState extends State<TrainingHubScreen> {
  final ApiClient _apiClient = ApiClient();

  bool _isLoading = true;
  bool _trainingGym = false;
  bool _trainingShooting = false;

  Map<String, dynamic>? _gymStatus;
  Map<String, dynamic>? _shootingStatus;

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  Future<void> _loadAll() async {
    setState(() => _isLoading = true);
    try {
      final combined = await _apiClient.get('/training/status');
      if (combined.statusCode == 200) {
        final data = jsonDecode(combined.body) as Map<String, dynamic>?;
        if (!mounted) return;
        setState(() {
          _gymStatus = data?['gym'] as Map<String, dynamic>?;
          _shootingStatus = data?['shootingRange'] as Map<String, dynamic>?;
          _isLoading = false;
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
        _isLoading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  /// Gym API: `{ event, params: { reason, nextTrainAt? } }` on failure.
  /// Shooting API: `{ error, message?, nextTrainAt? }` on failure.
  static (String? reason, DateTime? nextAt) _parseGymFailure(
    Map<String, dynamic>? data,
  ) {
    if (data == null) return (null, null);
    final params = data['params'] as Map<String, dynamic>?;
    final reason = params?['reason']?.toString();
    final raw = params?['nextTrainAt']?.toString();
    return (reason, DateTime.tryParse(raw ?? '')?.toLocal());
  }

  static (String? reason, DateTime? nextAt) _parseShootingFailure(
    Map<String, dynamic>? data,
  ) {
    if (data == null) return (null, null);
    final reason = data['error']?.toString();
    final raw = data['nextTrainAt']?.toString();
    return (reason, DateTime.tryParse(raw ?? '')?.toLocal());
  }

  Future<void> _trainGym() async {
    final l10n = AppLocalizations.of(context);
    setState(() => _trainingGym = true);
    try {
      final response = await _apiClient.post('/gym/train', {});
      final data = jsonDecode(response.body) as Map<String, dynamic>?;
      if (response.statusCode == 200) {
        if (mounted) {
          showTopRightFromSnackBar(
            context,
            SnackBar(content: Text(l10n?.gymTrainSuccess ?? 'Training complete')),
          );
        }
        await _loadAll();
      } else if (mounted) {
        final (reason, nextAt) = _parseGymFailure(data);
        final msg = _messageForGymFailure(l10n, reason, nextAt);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(msg)));
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              l10n?.unknownError ?? 'Error',
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _trainingGym = false);
    }
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
              content: Text(l10n?.shootingTrainSuccess ?? 'Training complete'),
            ),
          );
        }
        await _loadAll();
      } else if (mounted) {
        final (reason, nextAt) = _parseShootingFailure(data);
        final msg = _messageForShootingFailure(l10n, reason, nextAt, data);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(msg)));
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
        final label = nextAt != null ? DateFormat('HH:mm').format(nextAt) : '-';
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
        final label = nextAt != null ? DateFormat('HH:mm').format(nextAt) : '-';
        return l10n?.shootingCooldownLabel(label) ?? 'Next session at: $label';
      default:
        return data?['message']?.toString() ??
            (l10n?.unknownError ?? 'Error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final wide = MediaQuery.sizeOf(context).width >= 960;

    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1A0A0A),
              Color(0xFF120808),
            ],
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
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFFFB347).withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.fitness_center,
                    size: 30,
                    color: Colors.red.shade600,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Icon(
                      Icons.add,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  Icon(
                    Icons.adjust,
                    size: 28,
                    color: Colors.deepOrange.shade700,
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
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n?.trainingHubSubtitle ??
                        'Strength at the gym and accuracy at the range both raise your crime success chance.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[700],
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGymColumn(BuildContext context, AppLocalizations? l10n) {
    final status = _gymStatus ?? {};
    final sessions = status['sessionsCompleted'] ?? 0;
    final strengthBonus = ((status['strengthBonus'] as num?) ?? 0) * 100;
    final nextTrainAtRaw = status['nextTrainAt']?.toString();
    final nextTrainAt = nextTrainAtRaw != null
        ? DateTime.tryParse(nextTrainAtRaw)?.toLocal()
        : null;
    final nextTrainLabel = nextTrainAt != null
        ? DateFormat('HH:mm').format(nextTrainAt)
        : '-';
    final canTrain = status['canTrain'] == true;
    final progress = (sessions as num) / 100.0;
    const maxBonus = 8.0;

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
          _progressCard(
            context,
            title: l10n?.gymTrainingProgressTitle ?? 'Training progress',
            sessionsLabel: l10n?.gymSessionsCompletedLabel ?? 'Sessions:',
            sessions: sessions,
            progress: progress.clamp(0.0, 1.0),
            progressSuffix:
                l10n?.gymProgressCompleteSuffix ?? 'complete',
            progressColor: Colors.red,
          ),
          const SizedBox(height: 12),
          _bonusPairCard(
            context,
            currentLabel: l10n?.gymCurrentBonusTitle ?? 'Current bonus',
            currentValue: '+${strengthBonus.toStringAsFixed(1)}%',
            currentSubLabel:
                l10n?.gymStrengthBonusLabel ?? 'Strength bonus',
            maxValue: '+${maxBonus.toStringAsFixed(0)}%',
            maxLabel: l10n?.gymMaximumLabel ?? 'Maximum',
            gradient: [Colors.red.shade400, Colors.red.shade700],
            infoText: l10n?.gymBonusAppliedToCrimes ??
                'Applied to crime success chance.',
          ),
          const SizedBox(height: 12),
          _trainCard(
            context,
            canTrain: canTrain,
            isTraining: _trainingGym,
            readyLabel: l10n?.gymReadyToTrain ?? 'Ready to train',
            cooldownTitle:
                l10n?.gymTrainingCooldownTitle ?? 'Training cooldown',
            cooldownLine: l10n?.gymCooldown(nextTrainLabel) ??
                'Next session at $nextTrainLabel',
            cooldownHint: l10n?.gymCooldownHint ??
                'Wait 1 hour between sessions.',
            trainLabel: l10n?.gymTrain ?? 'Train',
            trainingLabel: l10n?.gymTrainingInProgress ?? 'Training…',
            accent: Colors.red,
            icon: Icons.fitness_center,
            onTrain: _trainGym,
          ),
          const SizedBox(height: 12),
          _howItWorksCard(
            context,
            title: l10n?.gymHowItWorksTitle ?? 'How it works',
            bullets: [
              l10n?.gymHowItWorksBullet1 ?? '',
              l10n?.gymHowItWorksBullet2 ?? '',
              l10n?.gymHowItWorksBullet3 ?? '',
              l10n?.gymHowItWorksBullet4 ?? '',
              l10n?.gymHowItWorksBullet5 ?? '',
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShootingColumn(BuildContext context, AppLocalizations? l10n) {
    final status = _shootingStatus ?? {};
    final sessions = status['sessionsCompleted'] ?? 0;
    final accuracyBonus = ((status['accuracyBonus'] as num?) ?? 0) * 100;
    final nextTrainAtRaw = status['nextTrainAt']?.toString();
    final nextTrainAt = nextTrainAtRaw != null
        ? DateTime.tryParse(nextTrainAtRaw)?.toLocal()
        : null;
    final nextTrainLabel = nextTrainAt != null
        ? DateFormat('HH:mm').format(nextTrainAt)
        : '-';
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
          _progressCard(
            context,
            title: l10n?.shootingTrainingProgressTitle ?? 'Training progress',
            sessionsLabel:
                l10n?.shootingSessionsCompletedLabel ?? 'Sessions:',
            sessions: sessions,
            progress: progress.clamp(0.0, 1.0),
            progressSuffix:
                l10n?.shootingProgressCompleteSuffix ?? 'complete',
            progressColor: Colors.orange,
          ),
          const SizedBox(height: 12),
          _bonusPairCard(
            context,
            currentLabel: l10n?.shootingCurrentBonusTitle ?? 'Current bonus',
            currentValue: '+${accuracyBonus.toStringAsFixed(1)}%',
            currentSubLabel:
                l10n?.shootingAccuracyBonusLabel ?? 'Accuracy bonus',
            maxValue: '+${maxBonus.toStringAsFixed(0)}%',
            maxLabel: l10n?.shootingMaximumLabel ?? 'Maximum',
            gradient: [Colors.orange.shade400, Colors.orange.shade700],
            infoText: l10n?.shootingBonusAppliedToCrimes ??
                'Applied to crime success chance.',
          ),
          const SizedBox(height: 12),
          _trainCard(
            context,
            canTrain: canTrain,
            isTraining: _trainingShooting,
            readyLabel: l10n?.shootingReadyToTrain ?? 'Ready to train',
            cooldownTitle:
                l10n?.shootingTrainingCooldownTitle ?? 'Cooldown',
            cooldownLine: l10n?.shootingCooldownLabel(nextTrainLabel) ??
                'Next: $nextTrainLabel',
            cooldownHint: l10n?.shootingCooldownHint ??
                'Wait 1 hour between sessions.',
            trainLabel: l10n?.shootingTrain ?? 'Train',
            trainingLabel: l10n?.shootingTrainingInProgress ?? 'Training…',
            accent: Colors.orange,
            icon: Icons.gps_fixed,
            onTrain: _trainShooting,
          ),
          const SizedBox(height: 12),
          _howItWorksCard(
            context,
            title: l10n?.shootingHowItWorksTitle ?? 'How it works',
            bullets: [
              l10n?.shootingHowItWorksBullet1 ?? '',
              l10n?.shootingHowItWorksBullet2 ?? '',
              l10n?.shootingHowItWorksBullet3 ?? '',
              l10n?.shootingHowItWorksBullet4 ?? '',
              l10n?.shootingHowItWorksBullet5 ?? '',
            ],
          ),
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
        border: Border.all(color: accent.withOpacity(0.35), width: 1),
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
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            sectionIntro,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[700],
                ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _progressCard(
    BuildContext context, {
    required String title,
    required String sessionsLabel,
    required num sessions,
    required double progress,
    required String progressSuffix,
    required Color progressColor,
  }) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(sessionsLabel, style: Theme.of(context).textTheme.bodyLarge),
                Text(
                  '$sessions/100',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: progressColor,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 10,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${(progress * 100).toStringAsFixed(0)}% $progressSuffix',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bonusPairCard(
    BuildContext context, {
    required String currentLabel,
    required String currentValue,
    required String currentSubLabel,
    required String maxValue,
    required String maxLabel,
    required List<Color> gradient,
    required String infoText,
  }) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              currentLabel,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: gradient,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Text(
                          currentValue,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          currentSubLabel,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Text(
                          maxValue,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          maxLabel,
                          style: const TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue.shade700, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      infoText,
                      style: TextStyle(fontSize: 12, color: Colors.blue.shade900),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _trainCard(
    BuildContext context, {
    required bool canTrain,
    required bool isTraining,
    required String readyLabel,
    required String cooldownTitle,
    required String cooldownLine,
    required String cooldownHint,
    required String trainLabel,
    required String trainingLabel,
    required Color accent,
    required IconData icon,
    required VoidCallback onTrain,
  }) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  canTrain ? Icons.check_circle : Icons.schedule,
                  color: canTrain ? Colors.green : Colors.orange,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    canTrain ? readyLabel : cooldownTitle,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
            if (!canTrain) ...[
              const SizedBox(height: 8),
              Text(cooldownLine, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 4),
              Text(
                cooldownHint,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
            ],
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: (!isTraining && canTrain) ? onTrain : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: accent,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey[300],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: isTraining
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Icon(icon),
                label: Text(
                  isTraining ? trainingLabel : trainLabel,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _howItWorksCard(
    BuildContext context, {
    required String title,
    required List<String> bullets,
  }) {
    return Card(
      elevation: 2,
      color: Colors.grey[100],
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.lightbulb_outline, color: Colors.amber[700]),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
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
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[800],
                      height: 1.35,
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
