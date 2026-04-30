import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../l10n/app_localizations.dart';
import '../services/api_client.dart';
import '../utils/top_right_notification.dart';

class GymScreen extends StatefulWidget {
  const GymScreen({super.key});

  @override
  State<GymScreen> createState() => _GymScreenState();
}

class _GymScreenState extends State<GymScreen> {
  final ApiClient _apiClient = ApiClient();
  bool _isLoading = true;
  bool _isTraining = false;
  Map<String, dynamic>? _status;

  @override
  void initState() {
    super.initState();
    _loadStatus();
  }

  Future<void> _loadStatus() async {
    setState(() => _isLoading = true);
    try {
      final response = await _apiClient.get('/gym/status');
      final data = jsonDecode(response.body);
      setState(() {
        _status = data['status'] as Map<String, dynamic>?;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _train() async {
    final l10n = AppLocalizations.of(context);
    setState(() => _isTraining = true);
    try {
      final response = await _apiClient.post('/gym/train', {});
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (mounted) {
          showTopRightFromSnackBar(
            context,
            SnackBar(
              content: Text(l10n?.gymTrainSuccess ?? 'Training complete'),
            ),
          );
        }
        await _loadStatus();
      } else if (mounted) {
        final reason = data['params']?['reason']?.toString();
        String message;

        switch (reason) {
          case 'MAX_SESSIONS':
            message =
                l10n?.gymMaxSessionsReached ?? 'Maximum sessions reached';
            break;
          case 'COOLDOWN':
            final nextTrainAtRaw = data['params']?['nextTrainAt']?.toString();
            final nextTrainAt = nextTrainAtRaw != null
                ? DateTime.tryParse(nextTrainAtRaw)?.toLocal()
                : null;
            final nextLabel = nextTrainAt != null
                ? DateFormat('HH:mm').format(nextTrainAt)
                : '-';
            message = l10n?.gymCooldown(nextLabel) ?? 'Next session at $nextLabel';
            break;
          default:
            message =
                l10n?.unknownError ?? (l10n?.hitError(data.toString()) ?? 'Error: $data');
        }
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      }
    } finally {
      if (mounted) {
        setState(() => _isTraining = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final status = _status ?? {};
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
    final progress = sessions / 100;
    final maxBonus = 8.0;

    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/images/backgrounds/gym_bg.png'),
            fit: BoxFit.cover,
            opacity: 0.15,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Card
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.fitness_center,
                              size: 32,
                              color: Colors.red,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n?.gym ?? 'Gym',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  l10n?.gymIntro ??
                                      'Train your strength and increase your crime success rate',
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Progress Card
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n?.gymTrainingProgressTitle ?? 'Training Progress',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n?.gymSessionsCompletedLabel ??
                                'Sessions completed:',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Text(
                            '$sessions/100',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 12,
                          backgroundColor: Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${(progress * 100).toStringAsFixed(0)}% ${l10n?.gymProgressCompleteSuffix ?? 'complete'}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Stats Card
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n?.gymCurrentBonusTitle ?? 'Current Bonus',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.red.shade400,
                                    Colors.red.shade700,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  const Icon(
                                    Icons.trending_up,
                                    size: 32,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '+${strengthBonus.toStringAsFixed(1)}%',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    l10n?.gymStrengthBonusLabel ??
                                        'Strength Bonus',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  const Icon(
                                    Icons.military_tech,
                                    size: 32,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '+${maxBonus.toStringAsFixed(0)}%',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    l10n?.gymMaximumLabel ?? 'Maximum',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blue.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Colors.blue.shade700,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                l10n?.gymBonusAppliedToCrimes ??
                                    'This bonus is applied to all your crime attempts',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.blue.shade900,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Training Card
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(20),
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
                          Text(
                            canTrain
                                ? (l10n?.gymReadyToTrain ?? 'Ready to train')
                                : (l10n?.gymTrainingCooldownTitle ??
                                      'Training Cooldown'),
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (!canTrain) ...[
                        Row(
                          children: [
                            const Icon(
                              Icons.access_time,
                              size: 16,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              l10n?.gymCooldown(nextTrainLabel) ??
                                  'Next session at $nextTrainLabel',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n?.gymCooldownHint ??
                              'You must wait 1 hour between training sessions',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 16),
                      ],
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: (!_isTraining && canTrain) ? _train : null,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: Colors.grey[300],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          icon: _isTraining
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : const Icon(Icons.fitness_center),
                          label: Text(
                            _isTraining
                                ? (l10n?.gymTrainingInProgress ??
                                      'Training...')
                                : (l10n?.gymTrain ?? 'Train'),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Info Card
              Card(
                elevation: 4,
                color: Colors.grey[100],
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.lightbulb_outline,
                            color: Colors.amber[700],
                          ),
                          const SizedBox(width: 8),
                          Text(
                            l10n?.gymHowItWorksTitle ?? 'How does it work?',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        l10n?.gymHowItWorksBullet1 ??
                            '• Train every hour for a strength boost',
                      ),
                      _buildInfoRow(
                        l10n?.gymHowItWorksBullet2 ??
                            '• Each session gives +0.08% bonus',
                      ),
                      _buildInfoRow(
                        l10n?.gymHowItWorksBullet3 ??
                            '• Maximum of 100 sessions (+8% total)',
                      ),
                      _buildInfoRow(
                        l10n?.gymHowItWorksBullet4 ??
                            '• Increases your crime success rate',
                      ),
                      _buildInfoRow(
                        l10n?.gymHowItWorksBullet5 ??
                            '• Permanent bonus, every session counts',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: TextStyle(fontSize: 14, color: Colors.grey[700], height: 1.4),
      ),
    );
  }
}
