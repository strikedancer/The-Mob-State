import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../providers/auth_provider.dart';
import '../screens/player_profile_screen.dart';
import '../services/auth_service.dart';
import '../screens/premium_screen.dart';
import '../utils/avatar_helper.dart';
import '../utils/formatters.dart';
import '../utils/game_event_rewards.dart';
import '../utils/game_event_theme.dart';
import '../utils/localized_game_event_template.dart';
import '../utils/top_right_notification.dart';
import 'season_pass_panel.dart';

const Color _gold = Color(0xFFD4AF37);
const Color _panelBg = Color(0xFF151B28);
const Color _panelBorder = Color(0xFF2A3344);

Future<void> showGameEventDetailsDialog({
  required BuildContext context,
  required Map<String, dynamic> event,
}) async {
  final l10n = AppLocalizations.of(context);
  if (l10n == null) return;

  final isPreview = event['preview'] == true;
  final eventId = (event['id'] as num?)?.toInt();

  await showDialog<void>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.62),
    builder: (dialogContext) {
      return _GameEventDetailsDialog(
        seedEvent: event,
        eventId: isPreview ? null : eventId,
      );
    },
  );
}

class _GameEventDetailsDialog extends StatefulWidget {
  const _GameEventDetailsDialog({
    required this.seedEvent,
    required this.eventId,
  });

  final Map<String, dynamic> seedEvent;
  final int? eventId;

  @override
  State<_GameEventDetailsDialog> createState() => _GameEventDetailsDialogState();
}

class _GameEventDetailsDialogState extends State<_GameEventDetailsDialog> {
  Map<String, dynamic>? _details;
  bool _loading = false;
  bool _loadFailed = false;

  @override
  void initState() {
    super.initState();
    if (widget.eventId == null) {
      _details = Map<String, dynamic>.from(widget.seedEvent);
    } else {
      _loading = true;
      _loadDetails(widget.eventId!);
    }
  }

  Future<void> _loadDetails(int eventId) async {
    final api = AuthService().apiClient;
    for (var attempt = 0; attempt < 2; attempt++) {
      try {
        final response = await api.get('/game-events/$eventId');
        if (response.statusCode != 200) {
          throw Exception('failed');
        }
        final data = jsonDecode(response.body);
        if (data is! Map<String, dynamic>) {
          throw const FormatException('invalid event details');
        }
        final raw = data['gameEvent'];
        if (raw is! Map) {
          throw const FormatException('missing gameEvent');
        }
        if (!mounted) return;
        setState(() {
          _details = Map<String, dynamic>.from(raw);
          _loading = false;
          _loadFailed = false;
        });
        return;
      } catch (_) {
        if (attempt == 0) {
          await Future<void>.delayed(const Duration(milliseconds: 500));
          continue;
        }
      }
    }
    if (!mounted) return;
    setState(() {
      _loading = false;
      _loadFailed = true;
      _details = Map<String, dynamic>.from(widget.seedEvent);
    });
    final l10n = AppLocalizations.of(context);
    if (l10n != null) {
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(l10n.gameScreenDetailsLoadError),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _formatDateTime(String? iso, AppLocalizations l10n) {
    if (iso == null || iso.isEmpty) {
      return l10n.gameScreenDash;
    }
    final parsed = DateTime.tryParse(iso);
    if (parsed == null) {
      return l10n.gameScreenDash;
    }
    final local = parsed.toLocal();
    final day = local.day.toString().padLeft(2, '0');
    final month = local.month.toString().padLeft(2, '0');
    final year = local.year.toString();
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    return '$day-$month-$year $hour:$minute';
  }

  Widget _panel({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _panelBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _panelBorder),
      ),
      child: child,
    );
  }

  Color _leaderboardRankColor(int rank) {
    switch (rank) {
      case 1:
        return const Color(0xFFFFD700);
      case 2:
        return const Color(0xFFC0C0C0);
      case 3:
        return const Color(0xFFCD7F32);
      default:
        return Colors.white70;
    }
  }

  Widget _prizeTierRow(AppLocalizations l10n, GameEventPrizeTier tier) {
    final parts = <String>[];
    if (tier.cash > 0) parts.add(formatCurrency(tier.cash));
    if (tier.premiumCredits > 0) {
      parts.add(l10n.gameScreenPrizeCredits(tier.premiumCredits.toString()));
    }
    if (tier.xp > 0) {
      parts.add(l10n.gameScreenPrizeXp(tier.xp.toString()));
    }

    IconData tierIcon;
    Color tierColor;
    if (tier.minRank == 1) {
      tierIcon = Icons.emoji_events;
      tierColor = const Color(0xFFFFD700);
    } else if (tier.minRank <= 3) {
      tierIcon = Icons.military_tech;
      tierColor = const Color(0xFFC0C0C0);
    } else {
      tierIcon = Icons.workspace_premium;
      tierColor = const Color(0xFFCD7F32);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.28),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: tierColor.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(tierIcon, color: tierColor, size: 20),
              const SizedBox(width: 8),
              Text(
                formatPrizeRankLabel(l10n, tier.minRank, tier.maxRank),
                style: TextStyle(
                  color: tierColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          if (parts.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              parts.join(' · '),
              style: const TextStyle(color: Colors.white, fontSize: 13.5),
            ),
          ],
          for (final item in tier.items) ...[
            const SizedBox(height: 4),
            Text(
              l10n.gameScreenPrizeItemLine(
                eventItemDisplayName(l10n, item.itemKey),
                item.quantity.toString(),
              ),
              style: const TextStyle(color: Colors.white70, fontSize: 12.5),
            ),
          ],
          for (final line in tier.extendedPrizeLines(l10n)) ...[
            const SizedBox(height: 4),
            Text(
              line,
              style: const TextStyle(color: Colors.white70, fontSize: 12.5),
            ),
          ],
        ],
      ),
    );
  }

  void _openPlayerProfile(int playerId, String username) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PlayerProfileScreen(
          playerId: playerId,
          username: username,
        ),
      ),
    );
  }

  Widget _leaderboardRow(
    AppLocalizations l10n, {
    required int rank,
    required double score,
    required Map<String, dynamic> player,
    required bool highlight,
  }) {
    final playerId = (player['id'] as num?)?.toInt();
    final username =
        player['username']?.toString() ?? l10n.gameScreenUnknownPlayer;
    final avatar = player['avatar']?.toString();
    final activePortraitPath = player['activePortraitPath']?.toString();
    final canOpenProfile = playerId != null;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: highlight
            ? _gold.withValues(alpha: 0.12)
            : Colors.black.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: highlight
              ? _gold.withValues(alpha: 0.45)
              : Colors.white.withValues(alpha: 0.08),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 34,
            child: Text(
              '#$rank',
              style: TextStyle(
                color: _leaderboardRankColor(rank),
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.grey.shade800,
            backgroundImage: AvatarHelper.getAvatarImageProvider(
              avatar,
              activePortraitPath: activePortraitPath,
            ),
            child: !AvatarHelper.hasAvatar(avatar) &&
                    (activePortraitPath == null || activePortraitPath.isEmpty)
                ? Text(
                    username.isNotEmpty ? username[0].toUpperCase() : '?',
                    style: const TextStyle(fontSize: 13, color: Colors.white),
                  )
                : null,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: InkWell(
              onTap: canOpenProfile
                  ? () => _openPlayerProfile(playerId, username)
                  : null,
              borderRadius: BorderRadius.circular(6),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text(
                  username,
                  style: TextStyle(
                    color: canOpenProfile
                        ? Colors.lightBlueAccent
                        : Colors.white70,
                    fontWeight: highlight ? FontWeight.w700 : FontWeight.w500,
                    decoration: canOpenProfile
                        ? TextDecoration.underline
                        : TextDecoration.none,
                    decorationColor: Colors.lightBlueAccent.withValues(
                      alpha: 0.6,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.lightBlueAccent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: Colors.lightBlueAccent.withValues(alpha: 0.35),
              ),
            ),
            child: Text(
              score.toStringAsFixed(0),
              style: const TextStyle(
                color: Colors.lightBlueAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final eventDetails = _details ?? widget.seedEvent;
    final template = eventDetails['template'] is Map
        ? Map<String, dynamic>.from(eventDetails['template'] as Map)
        : null;
    final currentPlayerId =
        Provider.of<AuthProvider>(context, listen: false).currentPlayer?.id;
    final statusLabel = localizedGameEventLiveStatus(
      l10n,
      eventDetails['status']?.toString(),
    );
    final isActive = eventDetails['status']?.toString() == 'active';
    final isPreview = eventDetails['preview'] == true;
    final participants =
        ((eventDetails['participants'] as List?) ?? const <dynamic>[])
            .whereType<Map>()
            .map((item) => Map<String, dynamic>.from(item))
            .toList();
    final myProgressRaw = eventDetails['myProgress'];
    final myProgress = myProgressRaw is Map<String, dynamic>
        ? myProgressRaw
        : (myProgressRaw is Map
              ? Map<String, dynamic>.from(myProgressRaw)
              : null);
    final isMonthly = isMonthlyEmpireEvent(eventDetails);
    final prizeTiers = parseGameEventPrizeTiers(
      (eventDetails['rewardRules'] as List?) ?? const <dynamic>[],
    );

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720, maxHeight: 720),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1A2233), Color(0xFF0E1219)],
            ),
            border: Border.all(color: _gold.withValues(alpha: 0.45)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.55),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 18, 12, 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            localizedGameEventTitle(l10n, template),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (localizedGameEventShortDescription(
                            l10n,
                            template,
                          ).isNotEmpty) ...[
                            const SizedBox(height: 6),
                            Text(
                              localizedGameEventShortDescription(
                                l10n,
                                template,
                              ),
                              style: const TextStyle(
                                color: Colors.white70,
                                height: 1.35,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close, color: Colors.white54),
                    ),
                  ],
                ),
              ),
              if (_loading)
                const Padding(
                  padding: EdgeInsets.fromLTRB(18, 24, 18, 40),
                  child: Center(
                    child: CircularProgressIndicator(color: _gold),
                  ),
                )
              else
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(18, 0, 18, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (isMonthly) ...[
                          SeasonPassPanel(
                            embedded: true,
                            onBuyPremium: () {
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) => const PremiumScreen(),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 12),
                        ],
                        _panel(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isActive
                                          ? Colors.green.withValues(alpha: 0.18)
                                          : Colors.orange.withValues(
                                              alpha: 0.18,
                                            ),
                                      borderRadius: BorderRadius.circular(999),
                                      border: Border.all(
                                        color: isActive
                                            ? Colors.greenAccent
                                            : Colors.orangeAccent,
                                      ),
                                    ),
                                    child: Text(
                                      statusLabel,
                                      style: TextStyle(
                                        color: isActive
                                            ? Colors.greenAccent
                                            : Colors.orangeAccent,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  if (_loadFailed) ...[
                                    const SizedBox(width: 8),
                                    Text(
                                      l10n.gameScreenDetailsLoadError,
                                      style: const TextStyle(
                                        color: Colors.orangeAccent,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                l10n.gameScreenStartLine(
                                  _formatDateTime(
                                    eventDetails['startedAt']?.toString(),
                                    l10n,
                                  ),
                                ),
                                style: const TextStyle(color: Colors.white70),
                              ),
                              Text(
                                l10n.gameScreenEndLine(
                                  _formatDateTime(
                                    eventDetails['endsAt']?.toString(),
                                    l10n,
                                  ),
                                ),
                                style: const TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                        if (myProgress != null) ...[
                          const SizedBox(height: 12),
                          _panel(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.gameScreenYourProgress,
                                  style: const TextStyle(
                                    color: _gold,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        l10n.gameScreenScore(
                                          ((myProgress['score'] as num?) ?? 0)
                                              .toStringAsFixed(0),
                                        ),
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        l10n.gameScreenRank(
                                          (myProgress['rank'] as num?)
                                                  ?.toInt()
                                                  .toString() ??
                                              l10n.gameScreenDash,
                                        ),
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                        if (!isMonthly) ...[
                          const SizedBox(height: 12),
                          Text(
                            l10n.gameScreenPrizePool,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l10n.gameScreenPrizePoolHint,
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (prizeTiers.isEmpty)
                            _panel(
                              child: Text(
                                l10n.gameScreenNoPrizes,
                                style: const TextStyle(color: Colors.white60),
                              ),
                            )
                          else
                            ...prizeTiers.map(
                              (tier) => _prizeTierRow(l10n, tier),
                            ),
                        ],
                        if (!isPreview) ...[
                          const SizedBox(height: 12),
                          Text(
                            l10n.gameScreenLeaderboard,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (participants.isEmpty)
                            _panel(
                              child: Text(
                                l10n.gameScreenNoLeaderboard,
                                style: const TextStyle(color: Colors.white60),
                              ),
                            )
                          else
                            ...participants.asMap().entries.map((indexed) {
                              final entry = indexed.value;
                              final player = entry['player'] is Map
                                  ? Map<String, dynamic>.from(
                                      entry['player'] as Map,
                                    )
                                  : <String, dynamic>{};
                              final rank = (entry['rank'] as num?)?.toInt() ??
                                  (indexed.key + 1);
                              final score =
                                  (entry['score'] as num?)?.toDouble() ?? 0;
                              final playerId = (player['id'] as num?)?.toInt();
                              return _leaderboardRow(
                                l10n,
                                rank: rank,
                                score: score,
                                player: player,
                                highlight: playerId != null &&
                                    playerId == currentPlayerId,
                              );
                            }),
                        ],
                      ],
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 8, 18, 16),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(foregroundColor: _gold),
                    child: Text(l10n.close),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
