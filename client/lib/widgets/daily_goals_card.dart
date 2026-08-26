import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../providers/auth_provider.dart';
import '../services/auth_service.dart';
import '../utils/formatters.dart';
import '../utils/top_right_notification.dart';

const Color _gold = Color(0xFFFFB347);
const Color _panelDark = Color(0xFF1B1212);
const Color _panelLight = Color(0xFF2A1A1A);

class DailyGoalsCard extends StatefulWidget {
  final VoidCallback? onClaimed;

  const DailyGoalsCard({super.key, this.onClaimed});

  @override
  State<DailyGoalsCard> createState() => _DailyGoalsCardState();
}

class _DailyGoalsCardState extends State<DailyGoalsCard> {
  Map<String, dynamic>? _data;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final response = await AuthService().apiClient.get('/daily-goals/daily');
      if (!mounted) return;
      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      if (decoded['success'] == true && decoded['data'] is Map) {
        setState(() {
          _data = Map<String, dynamic>.from(decoded['data'] as Map);
          _loading = false;
        });
        return;
      }
    } catch (_) {}
    if (mounted) setState(() => _loading = false);
  }

  String _title(AppLocalizations l10n, String key) {
    switch (key) {
      case 'crime_3':
        return l10n.dailyGoalTitle_crime_3;
      case 'job_2':
        return l10n.dailyGoalTitle_job_2;
      case 'vehicle_theft_1':
        return l10n.dailyGoalTitle_vehicle_theft_1;
      case 'travel_1':
        return l10n.dailyGoalTitle_travel_1;
      case 'training_combo_1':
        return l10n.dailyGoalTitle_training_combo_1;
      default:
        return key;
    }
  }

  Future<void> _claim(String goalKey) async {
    try {
      final response = await AuthService().apiClient.post(
        '/daily-goals/daily/claim',
        {'goalKey': goalKey},
      );
      if (!mounted) return;
      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final l10n = AppLocalizations.of(context)!;
      if (decoded['success'] == true) {
        final data = (decoded['data'] as Map?)?.cast<String, dynamic>() ?? {};
        final cash = (data['rewardCash'] as num?)?.toInt() ?? 0;
        final xp = (data['rewardXp'] as num?)?.toInt() ?? 0;
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(
              '${l10n.dailyGoalClaimed} ${l10n.dailyGoalReward(formatCurrency(cash), xp.toString())}',
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.zero,
            duration: const Duration(seconds: 4),
          ),
        );
        final auth = context.read<AuthProvider>();
        if (data['money'] != null || data['xp'] != null) {
          auth.updatePlayerStats(
            money: (data['money'] as num?)?.toInt(),
            xp: (data['xp'] as num?)?.toInt(),
            rank: (data['rank'] as num?)?.toInt(),
          );
        }
        widget.onClaimed?.call();
        await _load();
        return;
      }
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(l10n.failed),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.zero,
        ),
      );
    } catch (_) {
      if (!mounted) return;
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(AppLocalizations.of(context)!.failedPleaseTryAgain),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.zero,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final goals = (_data?['goals'] as List?) ?? const [];
    final streak = (_data?['streak'] as num?)?.toInt() ?? 0;
    if (goals.isEmpty && !_loading) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_panelLight, _panelDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.lightGreenAccent.withOpacity(0.45)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.28),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(Icons.task_alt, color: Colors.lightGreenAccent, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.dailyGoals,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (streak > 0)
                Text(
                  Localizations.localeOf(context).languageCode == 'nl'
                      ? '$streak dagen streak'
                      : '$streak day streak',
                  style: const TextStyle(color: _gold, fontSize: 12),
                ),
              if (_loading) ...[
                const SizedBox(width: 8),
                const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ],
            ],
          ),
          const SizedBox(height: 10),
          ...goals.whereType<Map>().map((raw) {
            final g = Map<String, dynamic>.from(raw);
            final key = g['key']?.toString() ?? '';
            final title = _title(l10n, key);
            final progress = (g['progress'] as num?)?.toInt() ?? 0;
            final target = (g['target'] as num?)?.toInt() ?? 0;
            final claimable = g['claimable'] == true;
            final claimed = g['claimed'] == true;
            final rewardCash = (g['rewardCash'] as num?)?.toInt() ?? 0;
            final rewardXp = (g['rewardXp'] as num?)?.toInt() ?? 0;
            final ratio = target <= 0 ? 0.0 : (progress / target).clamp(0.0, 1.0);
            final reward = l10n.dailyGoalReward(
              formatCurrency(rewardCash),
              rewardXp.toString(),
            );

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        if (claimed)
                          Text(
                            l10n.claimed,
                            style: TextStyle(
                              color: Colors.greenAccent.withOpacity(0.9),
                              fontWeight: FontWeight.w800,
                              fontSize: 12,
                            ),
                          )
                        else if (claimable)
                          Text(
                            l10n.ready,
                            style: TextStyle(
                              color: Colors.lightGreenAccent.withOpacity(0.9),
                              fontWeight: FontWeight.w800,
                              fontSize: 12,
                            ),
                          )
                        else
                          Text(
                            '$progress/$target',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.75),
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        value: ratio,
                        minHeight: 8,
                        backgroundColor: Colors.white.withOpacity(0.12),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          claimable ? Colors.lightGreenAccent : _gold.withOpacity(0.9),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            claimed ? '${l10n.claimed} · $reward' : reward,
                            style: TextStyle(
                              color: claimable
                                  ? _gold
                                  : Colors.white.withOpacity(0.75),
                              fontSize: 12,
                              fontWeight: claimable ? FontWeight.w700 : FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        if (!claimed)
                          OutlinedButton(
                            onPressed: claimable && key.isNotEmpty
                                ? () => _claim(key)
                                : null,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: BorderSide(
                                color: (claimable
                                        ? Colors.lightGreenAccent
                                        : Colors.white24)
                                    .withOpacity(0.8),
                              ),
                            ),
                            child: Text(l10n.claim),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
