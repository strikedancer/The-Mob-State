import 'dart:convert';

import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../services/auth_service.dart';
import '../utils/formatters.dart';
import '../utils/top_right_notification.dart';

/// Compact monthly Season Pass card for the Events screen.
class SeasonPassPanel extends StatefulWidget {
  const SeasonPassPanel({super.key, this.onBuyPremium});

  /// Optional: open Premium & Credits / checkout for `season_pass_monthly`.
  final VoidCallback? onBuyPremium;

  @override
  State<SeasonPassPanel> createState() => _SeasonPassPanelState();
}

class _SeasonPassPanelState extends State<SeasonPassPanel> {
  static const Color _gold = Color(0xFFD4AF37);
  static const Color _panelBg = Color(0xFF151B28);
  static const Color _accent = Color(0xFFB388FF);

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

  String _rewardTeaser(Map<String, dynamic>? rewards, AppLocalizations l10n) {
    if (rewards == null || rewards.isEmpty) return '—';
    final parts = <String>[];
    final cash = (rewards['cash'] as num?)?.toInt() ?? 0;
    final credits = (rewards['premiumCredits'] as num?)?.toInt() ?? 0;
    if (cash > 0) parts.add(formatCurrency(cash));
    if (credits > 0) {
      parts.add(l10n.gameScreenPrizeCredits(credits.toString()));
    }
    if (rewards['ammo'] is List && (rewards['ammo'] as List).isNotEmpty) {
      parts.add(l10n.seasonPassRewardAmmo);
    }
    if (rewards['vehicles'] is List &&
        (rewards['vehicles'] as List).isNotEmpty) {
      parts.add(l10n.seasonPassRewardVehicle);
    }
    if (rewards['weapons'] is List &&
        (rewards['weapons'] as List).isNotEmpty) {
      parts.add(l10n.seasonPassRewardWeapon);
    }
    if (rewards['vehicleParts'] is Map) {
      parts.add(l10n.seasonPassRewardParts);
    }
    if (parts.isEmpty) parts.add(l10n.seasonPassRewardBundle);
    return parts.take(3).join(' · ');
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
          child: SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    final status = _status;
    if (status == null) return const SizedBox.shrink();

    final score = (status['score'] as num?)?.toInt() ?? 0;
    final premium = status['premiumUnlocked'] == true;
    final seasonKey = status['seasonKey']?.toString() ?? '';
    final next = status['nextLevel'] is Map
        ? Map<String, dynamic>.from(status['nextLevel'] as Map)
        : null;
    final levels = ((status['levels'] as List?) ?? const [])
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();

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
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: premium
                      ? _accent.withValues(alpha: 0.2)
                      : Colors.white12,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  premium
                      ? l10n.seasonPassPremiumActive
                      : l10n.seasonPassFreeTrack,
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
          Text(
            l10n.seasonPassSubtitle,
            style: const TextStyle(color: Colors.white70, fontSize: 12.5),
          ),
          const SizedBox(height: 10),
          Text(
            l10n.seasonPassScore(score.toString()),
            style: const TextStyle(
              color: _gold,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
          if (next != null) ...[
            const SizedBox(height: 4),
            Text(
              l10n.seasonPassNextLevel(
                next['level'].toString(),
                next['remaining'].toString(),
              ),
              style: const TextStyle(color: Colors.white60, fontSize: 12),
            ),
          ],
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
          const SizedBox(height: 12),
          ...levels.map((level) {
            final lvl = (level['level'] as num?)?.toInt() ?? 0;
            final unlocked = level['unlocked'] == true;
            final free = level['free'] is Map
                ? Map<String, dynamic>.from(level['free'] as Map)
                : <String, dynamic>{};
            final prem = level['premium'] is Map
                ? Map<String, dynamic>.from(level['premium'] as Map)
                : <String, dynamic>{};
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.28),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: unlocked
                      ? _accent.withValues(alpha: 0.35)
                      : Colors.white12,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.seasonPassLevelLabel(
                      lvl.toString(),
                      (level['scoreRequired'] as num?)?.toInt().toString() ??
                          '0',
                    ),
                    style: TextStyle(
                      color: unlocked ? Colors.white : Colors.white54,
                      fontWeight: FontWeight.w700,
                      fontSize: 12.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  _trackRow(
                    l10n: l10n,
                    label: l10n.seasonPassTrackFree,
                    teaser: _rewardTeaser(
                      free['rewards'] is Map
                          ? Map<String, dynamic>.from(free['rewards'] as Map)
                          : null,
                      l10n,
                    ),
                    claimable: free['claimable'] == true,
                    claimed: free['claimed'] == true,
                    onClaim: () => _claim(lvl, 'free'),
                  ),
                  const SizedBox(height: 4),
                  _trackRow(
                    l10n: l10n,
                    label: l10n.seasonPassTrackPremium,
                    teaser: _rewardTeaser(
                      prem['rewards'] is Map
                          ? Map<String, dynamic>.from(prem['rewards'] as Map)
                          : null,
                      l10n,
                    ),
                    claimable: prem['claimable'] == true,
                    claimed: prem['claimed'] == true,
                    locked: !premium,
                    onClaim: () => _claim(lvl, 'premium'),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _trackRow({
    required AppLocalizations l10n,
    required String label,
    required String teaser,
    required bool claimable,
    required bool claimed,
    bool locked = false,
    required VoidCallback onClaim,
  }) {
    return Row(
      children: [
        SizedBox(
          width: 64,
          child: Text(
            label,
            style: const TextStyle(color: Colors.white60, fontSize: 11),
          ),
        ),
        Expanded(
          child: Text(
            teaser,
            style: const TextStyle(color: Colors.white70, fontSize: 11.5),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (claimed)
          Text(
            l10n.seasonPassClaimed,
            style: const TextStyle(color: Colors.greenAccent, fontSize: 11),
          )
        else if (locked)
          const Icon(Icons.lock, size: 14, color: Colors.white38)
        else if (claimable)
          TextButton(
            onPressed: _claiming ? null : onClaim,
            child: Text(l10n.seasonPassClaim),
          )
        else
          Text(
            l10n.seasonPassLocked,
            style: const TextStyle(color: Colors.white38, fontSize: 11),
          ),
      ],
    );
  }
}
