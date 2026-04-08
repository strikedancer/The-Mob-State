import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

import '../models/prostitute.dart';
import '../models/achievement.dart';
import '../services/prostitution_service.dart';
import '../utils/achievement_notifier.dart';
import '../utils/top_right_notification.dart';

class ProstitutionRivalryScreen extends StatefulWidget {
  const ProstitutionRivalryScreen({super.key});

  @override
  State<ProstitutionRivalryScreen> createState() =>
      _ProstitutionRivalryScreenState();
}

class _ProstitutionRivalryScreenState extends State<ProstitutionRivalryScreen> {
  final ProstitutionService _service = ProstitutionService();
  static const Duration _sabotageCooldown = Duration(hours: 4);

  bool _isLoading = true;
  List<Rivalry> _rivals = [];
  List<SabotageHistoryItem> _history = [];
  int? _myPlayerId;
  Duration _cooldownRemaining = Duration.zero;
  bool _protectionActive = false;
  String? _protectionUntil;
  bool _isBuyingProtection = false;
  final TextEditingController _challengeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _challengeController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    final playerResult = await _service.getCurrentPlayer();
    final rivalsResult = await _service.getActiveRivals();
    final historyResult = await _service.getRivalryHistory(limit: 25);
    final protectionResult = await _service.getProtectionStatus();

    setState(() {
      final player = playerResult['player'] as Map<String, dynamic>?;
      final rivalsJson = (rivalsResult['rivals'] as List?) ?? [];
      final historyJson = (historyResult['history'] as List?) ?? [];
      final protection =
          protectionResult['protection'] as Map<String, dynamic>? ?? {};

      _myPlayerId = player?['id'] as int?;

      _rivals = rivalsJson
          .whereType<Map<String, dynamic>>()
          .map(Rivalry.fromJson)
          .toList();

      _history = historyJson
          .whereType<Map<String, dynamic>>()
          .map(SabotageHistoryItem.fromJson)
          .toList();

      _protectionActive = protection['active'] == true;
      _protectionUntil = protection['activeUntil']?.toString();
      _cooldownRemaining = _calculateCooldownRemaining();

      _isLoading = false;
    });
  }

  Future<void> _buyProtectionInsurance() async {
    final l10n = AppLocalizations.of(context)!;
    if (_isBuyingProtection || _protectionActive) return;

    setState(() => _isBuyingProtection = true);
    final result = await _service.buyProtectionInsurance();

    if (!mounted) return;

    showTopRightFromSnackBar(context, 
      SnackBar(
        content: Text(
          result['message']?.toString() ?? l10n.rivalryProtectionActivated,
        ),
        backgroundColor: result['success'] == true ? Colors.green : Colors.red,
      ),
    );

    setState(() => _isBuyingProtection = false);

    if (result['success'] == true) {
      await _loadData();
    }
  }

  Duration _calculateCooldownRemaining() {
    if (_myPlayerId == null) return Duration.zero;

    final latestOwnAction = _history
        .where((item) => item.attackerId == _myPlayerId)
        .fold<DateTime?>(null, (latest, item) {
          if (latest == null || item.createdAt.isAfter(latest)) {
            return item.createdAt;
          }
          return latest;
        });

    if (latestOwnAction == null) return Duration.zero;

    final elapsed = DateTime.now().difference(latestOwnAction);
    if (elapsed >= _sabotageCooldown) return Duration.zero;
    return _sabotageCooldown - elapsed;
  }

  Future<void> _startRivalry() async {
    final l10n = AppLocalizations.of(context)!;
    final rivalId = int.tryParse(_challengeController.text.trim());
    if (rivalId == null) return;

    final result = await _service.startRivalry(rivalId);
    if (!mounted) return;

    showTopRightFromSnackBar(context, 
      SnackBar(
        content: Text(
          result['message']?.toString() ?? l10n.rivalryUpdateMessage,
        ),
        backgroundColor: result['success'] == true ? Colors.green : Colors.red,
      ),
    );

    if (result['success'] == true) {
      _challengeController.clear();
      await _loadData();
    }
  }

  Future<void> _executeSabotage(Rivalry rivalry, String actionType) async {
    final l10n = AppLocalizations.of(context)!;
    if (_cooldownRemaining > Duration.zero) {
      showTopRightFromSnackBar(context, 
        SnackBar(
          content: Text(
            l10n.rivalryCooldownIn(_formatDuration(_cooldownRemaining)),
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final result = await _service.executeSabotage(
      rivalry.rivalPlayerId,
      actionType,
    );
    if (!mounted) return;

    showTopRightFromSnackBar(context, 
      SnackBar(
        content: Text(
          result['message']?.toString() ?? l10n.rivalrySabotageExecuted,
        ),
        backgroundColor: result['success'] == true ? Colors.green : Colors.red,
      ),
    );

    // Show achievements from response if any
    if (result['success'] == true) {
      final newAchievements = result['newAchievements'] as List<Achievement>?;
      if (newAchievements != null && newAchievements.isNotEmpty) {
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          AchievementNotifier.showMultipleAchievements(
            context,
            newAchievements,
          );
        }
      }
    }

    await _loadData();
  }

  Future<void> _confirmAndExecuteSabotage(
    Rivalry rivalry,
    String actionType,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          Localizations.localeOf(context).languageCode == 'nl'
              ? 'Weet je het zeker?'
              : 'Are you sure?',
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.rivalryExecuteButton,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(l10n.rivalryConfirmTarget(rivalry.rivalUsername)),
            const SizedBox(height: 6),
            Text(l10n.rivalryConfirmAction(_actionLabel(actionType, l10n))),
            const SizedBox(height: 6),
            Text(l10n.rivalryConfirmCost(_sabotageCost(actionType))),
            const SizedBox(height: 6),
            Text(l10n.rivalryConfirmEffect(_effectLabel(actionType, l10n))),
            const SizedBox(height: 10),
            Text(
              l10n.rivalryConfirmWarning,
              style: const TextStyle(color: Colors.orange),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: Text(l10n.rivalryExecuteButton),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _executeSabotage(rivalry, actionType);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : RefreshIndicator(
            onRefresh: _loadData,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildChallengeCard(),
                const SizedBox(height: 16),
                _buildProtectionCard(),
                const SizedBox(height: 16),
                _buildRivalsSection(),
                const SizedBox(height: 16),
                _buildHistorySection(),
              ],
            ),
          );
  }

  Widget _buildChallengeCard() {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.rivalryChallengeTitle,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(l10n.rivalryChallengeHint),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _challengeController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: l10n.rivalryPlayerIdHint,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _startRivalry,
                  child: Text(l10n.rivalryStartButton),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProtectionCard() {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.rivalryProtectionTitle,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 6),
            Text(l10n.rivalryProtectionDescription),
            const SizedBox(height: 10),
            Text(
              _protectionActive
                  ? l10n.rivalryProtectionActive(
                      _protectionUntil == null
                          ? '-'
                          : _formatIsoDate(_protectionUntil!),
                    )
                  : l10n.rivalryProtectionInactive,
              style: TextStyle(
                color: _protectionActive ? Colors.green : Colors.orange,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _protectionActive || _isBuyingProtection
                  ? null
                  : _buyProtectionInsurance,
              icon: _isBuyingProtection
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.shield),
              label: Text(l10n.rivalryProtectionBuy),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRivalsSection() {
    final l10n = AppLocalizations.of(context)!;

    if (_rivals.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(l10n.rivalryNoActive),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.rivalryActiveTitle,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        ..._rivals.map(
          (rivalry) => Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${rivalry.rivalUsername} (Rank ${rivalry.rivalRank})',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text('${l10n.rivalryScoreLabel}: ${rivalry.rivalryScore}'),
                  const SizedBox(height: 4),
                  Text(
                    _cooldownRemaining > Duration.zero
                        ? l10n.rivalryCooldownIn(
                            _formatDuration(_cooldownRemaining),
                          )
                        : l10n.rivalryCooldownReady,
                    style: TextStyle(
                      color: _cooldownRemaining > Duration.zero
                          ? Colors.orange
                          : Colors.green,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _sabotageButton(
                        rivalry,
                        'tip_police',
                        l10n.rivalryActionTipPolice,
                      ),
                      _sabotageButton(
                        rivalry,
                        'steal_customer',
                        l10n.rivalryActionStealCustomer,
                      ),
                      _sabotageButton(
                        rivalry,
                        'damage_reputation',
                        l10n.rivalryActionDamageReputation,
                      ),
                      _sabotageButton(
                        rivalry,
                        'bribe_employee',
                        l10n.rivalryActionBribeEmployee,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _sabotageButton(Rivalry rivalry, String actionType, String label) {
    return OutlinedButton(
      onPressed: _cooldownRemaining > Duration.zero
          ? null
          : () => _confirmAndExecuteSabotage(rivalry, actionType),
      child: Text(label),
    );
  }

  Widget _buildHistorySection() {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.rivalryRecentActivity,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            if (_history.isEmpty)
              Text(l10n.rivalryNoActivity)
            else
              ..._history.take(10).map((item) {
                final state = item.success ? '✅' : '❌';
                return Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(
                    '$state ${item.attackerUsername} -> ${item.victimUsername} (${item.actionType})',
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final totalSeconds = duration.inSeconds;
    if (totalSeconds <= 0) return '0:00';
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;
    if (hours > 0) {
      return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  String _formatIsoDate(String iso) {
    final dt = DateTime.tryParse(iso);
    if (dt == null) return iso;
    final local = dt.toLocal();
    final y = local.year.toString().padLeft(4, '0');
    final m = local.month.toString().padLeft(2, '0');
    final d = local.day.toString().padLeft(2, '0');
    final hh = local.hour.toString().padLeft(2, '0');
    final mm = local.minute.toString().padLeft(2, '0');
    return '$y-$m-$d $hh:$mm';
  }

  int _sabotageCost(String actionType) {
    switch (actionType) {
      case 'tip_police':
        return 5000;
      case 'steal_customer':
        return 3000;
      case 'damage_reputation':
        return 10000;
      case 'bribe_employee':
        return 8000;
      default:
        return 0;
    }
  }

  String _actionLabel(String actionType, AppLocalizations l10n) {
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

  String _effectLabel(String actionType, AppLocalizations l10n) {
    switch (actionType) {
      case 'tip_police':
        return l10n.rivalryEffectTipPolice;
      case 'steal_customer':
        return l10n.rivalryEffectStealCustomer;
      case 'damage_reputation':
        return l10n.rivalryEffectDamageReputation;
      case 'bribe_employee':
        return l10n.rivalryEffectBribeEmployee;
      default:
        return actionType;
    }
  }
}
