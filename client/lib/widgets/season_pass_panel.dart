import 'dart:convert';

import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../services/auth_service.dart';
import '../utils/formatters.dart';
import '../utils/season_pass_reward_assets.dart';
import '../utils/top_right_notification.dart';

/// Monthly Season Pass — 50 category goals with event + premium reward columns.
class SeasonPassPanel extends StatefulWidget {
  const SeasonPassPanel({super.key, this.onBuyPremium});

  final VoidCallback? onBuyPremium;

  @override
  State<SeasonPassPanel> createState() => _SeasonPassPanelState();
}

class _SeasonPassPanelState extends State<SeasonPassPanel> {
  static const Color _gold = Color(0xFFD4AF37);
  static const Color _panelBg = Color(0xFF151B28);
  static const Color _accent = Color(0xFFB388FF);
  static const Color _eventCol = Color(0xFF4FC3F7);
  static const Color _premiumCol = Color(0xFFD4AF37);

  final _api = AuthService().apiClient;
  Map<String, dynamic>? _status;
  bool _loading = true;
  bool _claiming = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final res = await _api.get('/season-pass/status');
      if (res.statusCode == 200 && mounted) {
        setState(() {
          _status = jsonDecode(res.body) as Map<String, dynamic>;
          _loading = false;
        });
        return;
      }
    } catch (_) {}
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _claim(int level, String track) async {
    if (_claiming) return;
    setState(() => _claiming = true);
    final l10n = AppLocalizations.of(context)!;
    try {
      final res = await _api.post('/season-pass/claim', {
        'level': level,
        'track': track,
      });
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        if (mounted) {
          setState(() {
            _status = data;
            _claiming = false;
          });
          showTopRightFromSnackBar(
            context,
            SnackBar(
              content: Text(l10n.seasonPassClaimSuccess),
              backgroundColor: Colors.green,
            ),
          );
        }
        return;
      }
      if (mounted) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(l10n.seasonPassClaimFailed),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (_) {
      if (mounted) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(l10n.seasonPassClaimFailed),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
    if (mounted) setState(() => _claiming = false);
  }

  String _goalDescription(AppLocalizations l10n, Map<String, dynamic> level) {
    final cat = level['goalCategory']?.toString() ?? '';
    final target = (level['goalTarget'] as num?)?.toInt() ?? 0;
    final progress = (level['progress'] as num?)?.toInt() ?? 0;
    final remaining = (level['remaining'] as num?)?.toInt() ?? 0;
    final base = switch (cat) {
      'crime' => l10n.seasonPassGoalCrime(target),
      'vehicles' => l10n.seasonPassGoalVehicles(target),
      'smuggling' => l10n.seasonPassGoalSmuggling(target),
      'drugs' => l10n.seasonPassGoalDrugs(target),
      'money' => l10n.seasonPassGoalMoney(formatCurrency(target)),
      'xp' => l10n.seasonPassGoalXp(target),
      _ => l10n.seasonPassGoalGeneric(target),
    };
    if (level['unlocked'] == true) return base;
    return '$base · ${l10n.seasonPassGoalProgress(progress, remaining)}';
  }

  SeasonPassRewardDisplay _display(
    Map<String, dynamic>? rewards,
    AppLocalizations l10n,
  ) {
    return seasonPassRewardDisplay(
      rewards,
      formatCash: formatCurrency,
      formatCredits: (n) => l10n.gameScreenPrizeCredits(n.toString()),
      ammoLabel: l10n.seasonPassRewardAmmo,
      vehicleLabel: l10n.seasonPassRewardVehicle,
      weaponLabel: l10n.seasonPassRewardWeapon,
      partsLabel: l10n.seasonPassRewardParts,
      bundleLabel: l10n.seasonPassRewardBundle,
      xpLabel: l10n.seasonPassRewardXp,
    );
  }

  Widget _rewardCell({
    required SeasonPassRewardDisplay display,
    required Color accent,
    required String columnLabel,
    required bool claimable,
    required bool claimed,
    required bool locked,
    required VoidCallback onClaim,
    required AppLocalizations l10n,
  }) {
    return Expanded(
      child: Column(
        children: [
          Text(
            columnLabel,
            style: TextStyle(
              color: accent.withValues(alpha: 0.85),
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Image.asset(
            display.imagePath,
            width: 44,
            height: 44,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => Icon(Icons.card_giftcard, color: accent, size: 36),
          ),
          const SizedBox(height: 2),
          Text(
            display.label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white, fontSize: 10.5, fontWeight: FontWeight.w600),
          ),
          if (display.subtitle != null)
            Text(
              display.subtitle!,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white54, fontSize: 9.5),
            ),
          const SizedBox(height: 4),
          if (claimed)
            Text(l10n.seasonPassClaimed, style: TextStyle(color: accent, fontSize: 10))
          else if (locked)
            const Icon(Icons.lock, size: 14, color: Colors.white38)
          else if (claimable)
            TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: _claiming ? null : onClaim,
              child: Text(l10n.seasonPassClaim, style: TextStyle(color: accent, fontSize: 11)),
            )
          else
            Text(l10n.seasonPassLocked, style: const TextStyle(color: Colors.white38, fontSize: 10)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (_loading && _status == null) {
      return Container(
        margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _panelBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _accent.withValues(alpha: 0.35)),
        ),
        child: const Center(
          child: SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2)),
        ),
      );
    }

    final status = _status;
    if (status == null) return const SizedBox.shrink();

    final premium = status['premiumUnlocked'] == true;
    final seasonKey = status['seasonKey']?.toString() ?? '';
    final totalGoals = (status['totalGoals'] as num?)?.toInt() ?? 50;
    final levels = ((status['levels'] as List?) ?? const [])
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
    final completed = levels.where((l) => l['unlocked'] == true).length;

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _panelBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _accent.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.workspace_premium, color: _accent, size: 22),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.seasonPassTitle(seasonKey),
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: premium ? _accent.withValues(alpha: 0.2) : Colors.white12,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  premium ? l10n.seasonPassPremiumActive : l10n.seasonPassFreeTrack,
                  style: TextStyle(
                    color: premium ? _accent : Colors.white70,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(l10n.seasonPassSubtitle, style: const TextStyle(color: Colors.white70, fontSize: 12.5)),
          const SizedBox(height: 8),
          Text(
            l10n.seasonPassGoalsProgress(completed.toString(), totalGoals.toString()),
            style: const TextStyle(color: _gold, fontWeight: FontWeight.w700, fontSize: 13),
          ),
          if (!premium) ...[
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: widget.onBuyPremium,
                icon: const Icon(Icons.lock_open, size: 18),
                label: Text(l10n.seasonPassBuyCta),
                style: OutlinedButton.styleFrom(
                  foregroundColor: _accent,
                  side: BorderSide(color: _accent.withValues(alpha: 0.7)),
                ),
              ),
            ),
          ],
          const SizedBox(height: 10),
          Row(
            children: [
              const SizedBox(width: 36),
              Expanded(
                flex: 3,
                child: Text(
                  l10n.seasonPassColumnGoal,
                  style: const TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.w600),
                ),
              ),
              Expanded(
                child: Text(
                  l10n.seasonPassColumnEvent,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: _eventCol.withValues(alpha: 0.9), fontSize: 10, fontWeight: FontWeight.w600),
                ),
              ),
              Expanded(
                child: Text(
                  l10n.seasonPassColumnPremium,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: _premiumCol.withValues(alpha: 0.9), fontSize: 10, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ...levels.map((level) {
            final lvl = (level['level'] as num?)?.toInt() ?? 0;
            final unlocked = level['unlocked'] == true;
            final progress = (level['progress'] as num?)?.toInt() ?? 0;
            final target = (level['goalTarget'] as num?)?.toInt() ?? 1;
            final free = level['free'] is Map
                ? Map<String, dynamic>.from(level['free'] as Map)
                : <String, dynamic>{};
            final prem = level['premium'] is Map
                ? Map<String, dynamic>.from(level['premium'] as Map)
                : <String, dynamic>{};
            final freeRewards = free['rewards'] is Map
                ? Map<String, dynamic>.from(free['rewards'] as Map)
                : null;
            final premRewards = prem['rewards'] is Map
                ? Map<String, dynamic>.from(prem['rewards'] as Map)
                : null;
            final freeDisplay = _display(freeRewards, l10n);
            final premDisplay = _display(premRewards, l10n);

            return Container(
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: unlocked ? 0.22 : 0.12),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: unlocked ? _accent.withValues(alpha: 0.3) : Colors.white10,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 28,
                        child: Text(
                          '$lvl',
                          style: TextStyle(
                            color: unlocked ? _gold : Colors.white38,
                            fontWeight: FontWeight.w800,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _goalDescription(l10n, level),
                              style: TextStyle(
                                color: unlocked ? Colors.white : Colors.white70,
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                                height: 1.25,
                              ),
                            ),
                            const SizedBox(height: 4),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(3),
                              child: LinearProgressIndicator(
                                value: target > 0 ? (progress / target).clamp(0.0, 1.0) : 0,
                                minHeight: 4,
                                backgroundColor: Colors.white12,
                                color: unlocked ? Colors.greenAccent : _accent,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(width: 28),
                      _rewardCell(
                        display: freeDisplay,
                        accent: _eventCol,
                        columnLabel: l10n.seasonPassTrackFree,
                        claimable: free['claimable'] == true,
                        claimed: free['claimed'] == true,
                        locked: !unlocked,
                        onClaim: () => _claim(lvl, 'free'),
                        l10n: l10n,
                      ),
                      const SizedBox(width: 6),
                      _rewardCell(
                        display: premDisplay,
                        accent: _premiumCol,
                        columnLabel: l10n.seasonPassTrackPremium,
                        claimable: prem['claimable'] == true,
                        claimed: prem['claimed'] == true,
                        locked: !unlocked || !premium,
                        onClaim: () => _claim(lvl, 'premium'),
                        l10n: l10n,
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
