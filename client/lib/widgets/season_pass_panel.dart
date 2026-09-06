import 'dart:convert';

import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../services/auth_service.dart';
import '../utils/formatters.dart';
import '../utils/season_pass_reward_assets.dart';
import '../utils/top_right_notification.dart';
import 'mobile_load_error.dart';

/// Monthly Season Pass — compact single-line goal rows with reward tiles.
class SeasonPassPanel extends StatefulWidget {
  const SeasonPassPanel({
    super.key,
    this.onBuyPremium,
    this.embedded = false,
    this.showGoalList = true,
  });

  final VoidCallback? onBuyPremium;

  /// Tighter chrome for the monthly event details dialog.
  final bool embedded;

  /// When false, only the ready-to-claim strip is shown.
  final bool showGoalList;

  @override
  State<SeasonPassPanel> createState() => _SeasonPassPanelState();
}

class _SeasonPassPanelState extends State<SeasonPassPanel> {
  static const Color _gold = Color(0xFFD4AF37);
  static const Color _panelBg = Color(0xFF151B28);
  static const Color _accent = Color(0xFFB388FF);
  static const Color _eventCol = Color(0xFF4FC3F7);
  static const Color _premiumCol = Color(0xFFE8C547);

  final _api = AuthService().apiClient;
  Map<String, dynamic>? _status;
  bool _loading = true;
  bool _loadFailed = false;
  bool _claiming = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = _status == null;
      _loadFailed = false;
    });
    try {
      final res = await _api.get('/season-pass/status');
      if (res.statusCode == 200 && mounted) {
        setState(() {
          _status = jsonDecode(res.body) as Map<String, dynamic>;
          _loading = false;
          _loadFailed = false;
        });
        return;
      }
      throw Exception('error.internal');
    } catch (_) {
      if (mounted) {
        setState(() {
          _loading = false;
          _loadFailed = _status == null;
        });
      }
    }
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
      Map<String, dynamic> data = const {};
      try {
        final decoded = jsonDecode(res.body);
        if (decoded is Map<String, dynamic>) {
          data = decoded;
        }
      } catch (_) {}

      if (res.statusCode == 200) {
        if (mounted) {
          final nextStatus = data['levels'] is List ? data : null;
          setState(() {
            if (nextStatus != null) {
              _status = nextStatus;
            }
            _claiming = false;
          });
          showTopRightFromSnackBar(
            context,
            SnackBar(
              content: Text(
                track == 'premium'
                    ? l10n.seasonPassClaimSuccessPremium
                    : l10n.seasonPassClaimSuccessFree,
              ),
              backgroundColor: Colors.green,
            ),
          );
        }
        if (data['levels'] is! List) {
          await _load();
        }
        return;
      }

      final reason = data['params'] is Map
          ? (data['params'] as Map)['reason']?.toString()
          : null;
      final message = switch (reason) {
        'ALREADY_CLAIMED' => l10n.seasonPassClaimed,
        'LOCKED' || 'PREMIUM_REQUIRED' => l10n.seasonPassLocked,
        _ => l10n.seasonPassClaimFailed,
      };
      if (mounted) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.orange,
          ),
        );
      }
      await _load();
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
      await _load();
    }
    if (mounted) setState(() => _claiming = false);
  }

  String _goalTitle(AppLocalizations l10n, Map<String, dynamic> level) {
    final cat = level['goalCategory']?.toString() ?? '';
    final target = (level['goalTarget'] as num?)?.toInt() ?? 0;
    return switch (cat) {
      'crime' => l10n.seasonPassGoalCrime(target),
      'vehicles' => l10n.seasonPassGoalVehicles(target),
      'smuggling' => l10n.seasonPassGoalSmuggling(target),
      'drugs' => l10n.seasonPassGoalDrugs(target),
      'money' => l10n.seasonPassGoalMoney(formatCurrency(target)),
      'xp' => l10n.seasonPassGoalXp(target),
      'prostitution' => l10n.seasonPassGoalProstitution(target),
      _ => l10n.seasonPassGoalGeneric(target),
    };
  }

  List<({int level, String track, Map<String, dynamic> rewards, String goalTitle})>
      _readyClaimables(
    List<Map<String, dynamic>> levels,
    AppLocalizations l10n, {
    required bool premium,
  }) {
    final out = <({
      int level,
      String track,
      Map<String, dynamic> rewards,
      String goalTitle,
    })>[];
    for (final level in levels) {
      final lvl = (level['level'] as num?)?.toInt() ?? 0;
      final goalTitle = _goalTitle(l10n, level);
      final free = level['free'] is Map
          ? Map<String, dynamic>.from(level['free'] as Map)
          : <String, dynamic>{};
      final prem = level['premium'] is Map
          ? Map<String, dynamic>.from(level['premium'] as Map)
          : <String, dynamic>{};
      if (free['claimable'] == true && free['claimed'] != true) {
        final rewards = free['rewards'] is Map
            ? Map<String, dynamic>.from(free['rewards'] as Map)
            : <String, dynamic>{};
        out.add((
          level: lvl,
          track: 'free',
          rewards: rewards,
          goalTitle: goalTitle,
        ));
      }
      if (premium &&
          prem['claimable'] == true &&
          prem['claimed'] != true) {
        final rewards = prem['rewards'] is Map
            ? Map<String, dynamic>.from(prem['rewards'] as Map)
            : <String, dynamic>{};
        out.add((
          level: lvl,
          track: 'premium',
          rewards: rewards,
          goalTitle: goalTitle,
        ));
      }
    }
    return out;
  }

  Widget _claimablesBlock({
    required AppLocalizations l10n,
    required List<
            ({
              int level,
              String track,
              Map<String, dynamic> rewards,
              String goalTitle,
            })>
        claimables,
    required bool showEmpty,
  }) {
    if (claimables.isEmpty) {
      if (!showEmpty) return const SizedBox.shrink();
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          l10n.seasonPassNoClaimables,
          style: const TextStyle(color: Colors.white60, fontSize: 13),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.seasonPassClaimablesTitle,
            style: const TextStyle(
              color: _gold,
              fontWeight: FontWeight.w800,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: claimables.map((item) {
              final premiumTrack = item.track == 'premium';
              return SizedBox(
                width: 220,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      '${item.level} · ${item.goalTitle}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    _rewardChip(
                      display: _display(item.rewards, l10n),
                      accent: premiumTrack ? _premiumCol : _eventCol,
                      claimable: true,
                      claimed: false,
                      locked: false,
                      onClaim: () => _claim(item.level, item.track),
                      l10n: l10n,
                      expanded: true,
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
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
      ammoWithLabel: l10n.seasonPassRewardAmmoWith,
      vehicleLabel: l10n.seasonPassRewardVehicle,
      weaponLabel: l10n.seasonPassRewardWeapon,
      partsLabel: l10n.seasonPassRewardParts,
      partsWithLabel: l10n.seasonPassRewardPartsWith,
      bundleLabel: l10n.seasonPassRewardBundle,
      xpLabel: l10n.seasonPassRewardXp,
    );
  }

  Widget _assetTile({
    required String path,
    required Color accent,
    double size = 46,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            accent.withValues(alpha: 0.22),
            Colors.black.withValues(alpha: 0.45),
          ],
        ),
        border: Border.all(color: accent.withValues(alpha: 0.55), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: 0.18),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Image.asset(
            path,
            fit: BoxFit.contain,
            filterQuality: FilterQuality.high,
            errorBuilder: (_, __, ___) =>
                Icon(Icons.redeem, color: accent, size: size * 0.55),
          ),
        ),
      ),
    );
  }

  Widget _rewardChip({
    required SeasonPassRewardDisplay display,
    required Color accent,
    required bool claimable,
    required bool claimed,
    required bool locked,
    required VoidCallback onClaim,
    required AppLocalizations l10n,
    bool expanded = false,
  }) {
    final canTap = claimable && !locked && !claimed;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: canTap && !_claiming ? onClaim : null,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          constraints: expanded
              ? const BoxConstraints(minHeight: 58)
              : const BoxConstraints(minWidth: 148, maxWidth: 168),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.35),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: claimed
                  ? Colors.greenAccent.withValues(alpha: 0.5)
                  : claimable
                      ? accent.withValues(alpha: 0.65)
                      : Colors.white12,
            ),
          ),
          child: Row(
            mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
            children: [
              _assetTile(path: display.imagePath, accent: accent),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      display.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        height: 1.1,
                      ),
                    ),
                    if (display.subtitle != null)
                      Text(
                        display.subtitle!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: accent.withValues(alpha: 0.85),
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    const SizedBox(height: 2),
                    if (claimed)
                      Text(
                        l10n.seasonPassClaimed,
                        style: const TextStyle(
                          color: Colors.greenAccent,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    else if (locked)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.lock, size: 12, color: Colors.white38),
                          const SizedBox(width: 3),
                          Text(
                            l10n.seasonPassLocked,
                            style: const TextStyle(
                              color: Colors.white38,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      )
                    else if (claimable)
                      Text(
                        l10n.seasonPassClaim,
                        style: TextStyle(
                          color: accent,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _goalRow({
    required Map<String, dynamic> level,
    required AppLocalizations l10n,
    required bool premium,
    required bool even,
  }) {
    final lvl = (level['level'] as num?)?.toInt() ?? 0;
    final unlocked = level['unlocked'] == true;
    final progress = (level['progress'] as num?)?.toInt() ?? 0;
    final target = (level['goalTarget'] as num?)?.toInt() ?? 1;
    final cat = level['goalCategory']?.toString() ?? '';
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

    final ratio = target > 0 ? (progress / target).clamp(0.0, 1.0) : 0.0;

    final goalBlock = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                _goalTitle(l10n, level),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: unlocked ? Colors.white : Colors.white70,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 6,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                l10n.seasonPassGoalRatio(progress, target),
                style: TextStyle(
                  color: unlocked ? Colors.greenAccent : _gold,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w800,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: LinearProgressIndicator(
            value: ratio,
            minHeight: 3,
            backgroundColor: Colors.white10,
            color: unlocked ? Colors.greenAccent : _accent,
          ),
        ),
      ],
    );

    Widget rewardsRow({required bool expanded}) {
      return Row(
        children: [
          Expanded(
            child: _rewardChip(
              display: _display(freeRewards, l10n),
              accent: _eventCol,
              claimable: free['claimable'] == true,
              claimed: free['claimed'] == true,
              locked: !unlocked,
              onClaim: () => _claim(lvl, 'free'),
              l10n: l10n,
              expanded: expanded,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: _rewardChip(
              display: _display(premRewards, l10n),
              accent: _premiumCol,
              claimable: prem['claimable'] == true,
              claimed: prem['claimed'] == true,
              locked: !unlocked || !premium,
              onClaim: () => _claim(lvl, 'premium'),
              l10n: l10n,
              expanded: expanded,
            ),
          ),
        ],
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 620;
        return Container(
          margin: const EdgeInsets.only(bottom: 4),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
          decoration: BoxDecoration(
            color: even
                ? Colors.black.withValues(alpha: 0.18)
                : Colors.black.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: unlocked
                  ? _accent.withValues(alpha: 0.28)
                  : Colors.white.withValues(alpha: 0.06),
            ),
          ),
          child: compact
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 26,
                          height: 26,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: unlocked
                                ? _gold.withValues(alpha: 0.2)
                                : Colors.white.withValues(alpha: 0.06),
                            border: Border.all(
                              color: unlocked
                                  ? _gold.withValues(alpha: 0.7)
                                  : Colors.white24,
                            ),
                          ),
                          child: Text(
                            '$lvl',
                            style: TextStyle(
                              color: unlocked ? _gold : Colors.white54,
                              fontWeight: FontWeight.w800,
                              fontSize: 11,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        _assetTile(
                          path: seasonPassGoalCategoryIcon(cat),
                          accent: _accent,
                          size: 36,
                        ),
                        const SizedBox(width: 10),
                        Expanded(child: goalBlock),
                      ],
                    ),
                    const SizedBox(height: 8),
                    rewardsRow(expanded: true),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 26,
                      height: 26,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: unlocked
                            ? _gold.withValues(alpha: 0.2)
                            : Colors.white.withValues(alpha: 0.06),
                        border: Border.all(
                          color: unlocked
                              ? _gold.withValues(alpha: 0.7)
                              : Colors.white24,
                        ),
                      ),
                      child: Text(
                        '$lvl',
                        style: TextStyle(
                          color: unlocked ? _gold : Colors.white54,
                          fontWeight: FontWeight.w800,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _assetTile(
                      path: seasonPassGoalCategoryIcon(cat),
                      accent: _accent,
                      size: 36,
                    ),
                    const SizedBox(width: 10),
                    Expanded(flex: 4, child: goalBlock),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 342,
                      child: rewardsRow(expanded: false),
                    ),
                  ],
                ),
        );
      },
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
          child: SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    final status = _status;
    if (status == null) {
      if (_loadFailed) {
        return Container(
          margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _panelBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _accent.withValues(alpha: 0.35)),
          ),
          child: MobileLoadError(
            message: l10n.connectionErrorGeneric,
            onRetry: _load,
          ),
        );
      }
      return const SizedBox.shrink();
    }

    final premium = status['premiumUnlocked'] == true;
    final seasonKey = status['seasonKey']?.toString() ?? '';
    final totalGoals = (status['totalGoals'] as num?)?.toInt() ?? 50;
    final levels = ((status['levels'] as List?) ?? const [])
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
    final completed = levels.where((l) => l['unlocked'] == true).length;
    final claimables = _readyClaimables(
      levels,
      l10n,
      premium: premium,
    );
    return Container(
      margin: widget.embedded
          ? EdgeInsets.zero
          : const EdgeInsets.fromLTRB(12, 0, 12, 12),
      padding: EdgeInsets.all(widget.embedded ? 12 : 14),
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
            l10n.seasonPassGoalsProgress(
              completed.toString(),
              totalGoals.toString(),
            ),
            style: const TextStyle(
              color: _gold,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
          if (!premium) ...[
            const SizedBox(height: 8),
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
          _claimablesBlock(
            l10n: l10n,
            claimables: claimables,
            showEmpty: !widget.showGoalList,
          ),
          if (widget.showGoalList) ...[
            LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 620;
              if (compact) {
                return const SizedBox(height: 2);
              }
              return Padding(
                padding: const EdgeInsets.only(left: 4, right: 4, bottom: 4),
                child: Row(
                  children: [
                    const SizedBox(width: 70),
                    Expanded(
                      flex: 4,
                      child: Text(
                        l10n.seasonPassColumnGoal,
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 168,
                      child: Text(
                        l10n.seasonPassColumnEvent,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _eventCol.withValues(alpha: 0.95),
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    SizedBox(
                      width: 168,
                      child: Text(
                        l10n.seasonPassColumnPremium,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _premiumCol.withValues(alpha: 0.95),
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
            ...levels.asMap().entries.map((entry) {
              return _goalRow(
                level: entry.value,
                l10n: l10n,
                premium: premium,
                even: entry.key.isEven,
              );
            }),
          ],
        ],
      ),
    );
  }
}
