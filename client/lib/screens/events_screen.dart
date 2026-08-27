import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../providers/auth_provider.dart';
import '../screens/player_profile_screen.dart';
import '../services/auth_service.dart';
import '../utils/avatar_helper.dart';
import '../utils/formatters.dart';
import '../utils/game_event_rewards.dart';
import '../utils/localized_game_event_template.dart';
import '../utils/top_right_notification.dart';

class EventsScreen extends StatefulWidget {
  /// When true (e.g. web dashboard panel), no [AppBar] — parent provides chrome.
  final bool embedded;

  const EventsScreen({super.key, this.embedded = false});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  static const Color _gold = Color(0xFFD4AF37);
  static const Color _panelBg = Color(0xFF151B28);
  static const Color _panelBorder = Color(0xFF2A3344);

  final _apiClient = AuthService().apiClient;

  bool _isLoading = true;
  String? _error;
  List<Map<String, dynamic>> _active = const [];
  List<Map<String, dynamic>> _upcoming = const [];
  List<Map<String, dynamic>> _upcomingPreview = const [];
  Map<int, Map<String, dynamic>> _progressByEvent = const {};
  DateTime _now = DateTime.now();
  Timer? _tickTimer;

  @override
  void initState() {
    super.initState();
    _loadOverview();
    _tickTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _tickTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadOverview() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await _apiClient.get('/game-events/overview');
      if (response.statusCode != 200) {
        throw Exception('failed');
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final activeList = ((data['active'] as List?) ?? const <dynamic>[])
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
      final upcomingList = ((data['upcoming'] as List?) ?? const <dynamic>[])
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
      final upcomingPreviewList =
          ((data['upcomingPreview'] as List?) ?? const <dynamic>[])
              .whereType<Map>()
              .map((item) => Map<String, dynamic>.from(item))
              .toList();
      final progressList = ((data['myProgress'] as List?) ?? const <dynamic>[])
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();

      final progressByEvent = <int, Map<String, dynamic>>{};
      for (final item in progressList) {
        final eventId = (item['liveEventId'] as num?)?.toInt();
        if (eventId != null) {
          progressByEvent[eventId] = item;
        }
      }

      if (!mounted) return;
      setState(() {
        _active = activeList;
        _upcoming = upcomingList;
        _upcomingPreview = upcomingPreviewList;
        _progressByEvent = progressByEvent;
        _isLoading = false;
        _error = null;
        _now = DateTime.now();
      });
    } catch (_) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context);
      setState(() {
        _isLoading = false;
        _error = l10n?.connectionErrorGeneric;
      });
      if (l10n == null) return;
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(l10n.gameScreenLoadError),
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

  Future<Map<String, dynamic>?> _loadEventDetails(int eventId) async {
    try {
      final response = await _apiClient.get('/game-events/$eventId');
      if (response.statusCode != 200) {
        return null;
      }
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final raw = data['gameEvent'];
      if (raw is! Map) {
        return null;
      }
      return Map<String, dynamic>.from(raw);
    } catch (_) {
      return null;
    }
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

  Widget _eventDetailsPanel({required Widget child}) {
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

  Widget _buildPrizeTierRow(AppLocalizations l10n, GameEventPrizeTier tier) {
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

  Widget _buildLeaderboardRow(
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
                    fontWeight:
                        highlight ? FontWeight.w700 : FontWeight.w500,
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

  Future<void> _openEventDetails(Map<String, dynamic> event) async {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) {
      return;
    }

    final isPreview = event['preview'] == true;
    final eventId = (event['id'] as num?)?.toInt();
    Map<String, dynamic>? details;

    if (isPreview || eventId == null) {
      details = Map<String, dynamic>.from(event);
    } else {
      details = await _loadEventDetails(eventId);
      if (!mounted) {
        return;
      }
      if (details == null) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(l10n.gameScreenDetailsLoadError),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }

    if (!mounted) return;

    final eventDetails = details;
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

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
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
        final prizeTiers = parseGameEventPrizeTiers(
          (eventDetails['rewardRules'] as List?) ?? const <dynamic>[],
        );

        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
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
                          onPressed: () => Navigator.of(dialogContext).pop(),
                          icon: const Icon(Icons.close, color: Colors.white54),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(18, 0, 18, 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _eventDetailsPanel(
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
                            _eventDetailsPanel(
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
                            _eventDetailsPanel(
                              child: Text(
                                l10n.gameScreenNoPrizes,
                                style: const TextStyle(color: Colors.white60),
                              ),
                            )
                          else
                            ...prizeTiers.map(
                              (tier) => _buildPrizeTierRow(l10n, tier),
                            ),
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
                              _eventDetailsPanel(
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
                                final rank =
                                    (entry['rank'] as num?)?.toInt() ??
                                    (indexed.key + 1);
                                final score =
                                    (entry['score'] as num?)?.toDouble() ?? 0;
                                final playerId =
                                    (player['id'] as num?)?.toInt();
                                return _buildLeaderboardRow(
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
                        onPressed: () => Navigator.of(dialogContext).pop(),
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
      },
    );
  }

  String _formatCountdown(DateTime? at, AppLocalizations l10n) {
    if (at == null) return l10n.gameScreenDash;
    final diff = at.difference(_now);
    if (diff.inSeconds <= 0) return l10n.gameScreenCountdownNow;
    final d = diff.inDays;
    final h = diff.inHours.remainder(24);
    final m = diff.inMinutes.remainder(60);
    final s = diff.inSeconds.remainder(60);
    if (d > 0) {
      return l10n.gameScreenCountdownDays(
        d.toString(),
        h.toString().padLeft(2, '0'),
        m.toString().padLeft(2, '0'),
      );
    }
    if (h > 0) {
      return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
    }
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  ({String asset, IconData icon, Color accent}) _categoryTheme(
    Map<String, dynamic>? template,
  ) {
    final category = (template?['category']?.toString() ?? '').toLowerCase();
    switch (category) {
      case 'crime':
        return (
          asset: 'assets/images/backgrounds/crime_background.png',
          icon: Icons.warning_amber_rounded,
          accent: const Color(0xFFE85D4C),
        );
      case 'drugs':
        return (
          asset: 'assets/images/backgrounds/drug_production_bg.png',
          icon: Icons.science,
          accent: const Color(0xFF5CC8A0),
        );
      case 'smuggling':
        return (
          asset: 'assets/images/backgrounds/smuggling_hub_bg.png',
          icon: Icons.local_shipping,
          accent: const Color(0xFF5B9BD5),
        );
      case 'vehicles':
        return (
          asset: 'assets/images/backgrounds/garage_background.png',
          icon: Icons.directions_car,
          accent: const Color(0xFFF0A04B),
        );
      case 'trade':
        return (
          asset: 'assets/images/backgrounds/weapon_shop_bg.png',
          icon: Icons.storefront,
          accent: const Color(0xFFD4AF37),
        );
      case 'allround':
        return (
          asset: 'assets/images/backgrounds/crime_background.png',
          icon: Icons.emoji_events,
          accent: const Color(0xFFB388FF),
        );
      default:
        return (
          asset: 'assets/images/backgrounds/crime_background.png',
          icon: Icons.emoji_events,
          accent: _gold,
        );
    }
  }

  String? _topPrizeTeaser(AppLocalizations l10n, Map<String, dynamic> event) {
    final tiers = parseGameEventPrizeTiers(
      (event['rewardRules'] as List?) ?? const <dynamic>[],
    );
    if (tiers.isEmpty) return null;
    final top = tiers.first;
    final parts = <String>[];
    if (top.cash > 0) parts.add(formatCurrency(top.cash));
    if (top.premiumCredits > 0) {
      parts.add(l10n.gameScreenPrizeCredits(top.premiumCredits.toString()));
    }
    final extras = top.extendedPrizeLines(l10n);
    if (extras.isNotEmpty) {
      parts.add(extras.first);
    }
    if (parts.isEmpty && top.xp > 0) {
      parts.add(l10n.gameScreenPrizeXp(top.xp.toString()));
    }
    if (parts.isEmpty) return null;
    return l10n.gameCardTopPrize(parts.join(' · '));
  }

  Widget _buildEventCard(
    AppLocalizations l10n,
    Map<String, dynamic> event, {
    required bool isActive,
  }) {
    final template = event['template'] is Map
        ? Map<String, dynamic>.from(event['template'] as Map)
        : null;
    final eventId = (event['id'] as num?)?.toInt();
    final isPreview = event['preview'] == true;
    final progress = eventId != null ? _progressByEvent[eventId] : null;
    final score = (progress?['score'] as num?)?.toDouble();
    final rank = (progress?['rank'] as num?)?.toInt();
    final theme = _categoryTheme(template);
    final endsAt = DateTime.tryParse(event['endsAt']?.toString() ?? '')?.toLocal();
    final startsAt =
        DateTime.tryParse(event['startedAt']?.toString() ?? '')?.toLocal();
    final prizeTeaser = _topPrizeTeaser(l10n, event);
    final title = localizedGameEventTitle(l10n, template);
    final desc = localizedGameEventShortDescription(l10n, template);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isActive
              ? theme.accent.withValues(alpha: 0.55)
              : _gold.withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.accent.withValues(alpha: 0.18),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _openEventDetails(event),
            child: SizedBox(
              height: 210,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    theme.asset,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: const Color(0xFF1A1210),
                    ),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.35),
                          Colors.black.withValues(alpha: 0.82),
                          const Color(0xFF0A0808).withValues(alpha: 0.96),
                        ],
                        stops: const [0.0, 0.45, 1.0],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: theme.accent.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: theme.accent.withValues(alpha: 0.5),
                                ),
                              ),
                              child: Icon(
                                theme.icon,
                                color: theme.accent,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 17,
                                  height: 1.15,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: isActive
                                    ? Colors.green.withValues(alpha: 0.22)
                                    : Colors.orange.withValues(alpha: 0.22),
                                borderRadius: BorderRadius.circular(999),
                                border: Border.all(
                                  color: isActive
                                      ? Colors.greenAccent
                                      : Colors.orangeAccent,
                                ),
                              ),
                              child: Text(
                                isActive
                                    ? l10n.gameCardActive
                                    : l10n.gameCardScheduled,
                                style: TextStyle(
                                  color: isActive
                                      ? Colors.greenAccent
                                      : Colors.orangeAccent,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (desc.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            desc,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                              height: 1.3,
                            ),
                          ),
                        ],
                        const Spacer(),
                        if (isActive) ...[
                          Row(
                            children: [
                              Icon(
                                Icons.timer_outlined,
                                size: 16,
                                color: theme.accent,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                l10n.gameCardEndsIn(
                                  _formatCountdown(endsAt, l10n),
                                ),
                                style: TextStyle(
                                  color: theme.accent,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12.5,
                                ),
                              ),
                            ],
                          ),
                          if (progress != null) ...[
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                _statChip(
                                  l10n.gameCardYourScore(
                                    (score ?? 0).toStringAsFixed(0),
                                  ),
                                  theme.accent,
                                ),
                                const SizedBox(width: 8),
                                _statChip(
                                  l10n.gameCardYourRank(
                                    rank?.toString() ?? l10n.gameScreenDash,
                                  ),
                                  _gold,
                                ),
                              ],
                            ),
                          ],
                        ] else ...[
                          Row(
                            children: [
                              const Icon(
                                Icons.schedule,
                                size: 16,
                                color: Colors.orangeAccent,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  l10n.gameCardStartsIn(
                                    _formatCountdown(startsAt, l10n),
                                  ),
                                  style: const TextStyle(
                                    color: Colors.orangeAccent,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                        if (prizeTeaser != null) ...[
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(
                                Icons.emoji_events,
                                size: 16,
                                color: _gold,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  prizeTeaser,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: _gold,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 7,
                            ),
                            decoration: BoxDecoration(
                              color: theme.accent.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: theme.accent.withValues(alpha: 0.55),
                              ),
                            ),
                            child: Text(
                              isPreview
                                  ? l10n.gameCardViewPrizes
                                  : l10n.gameCardJoinCta,
                              style: TextStyle(
                                color: theme.accent,
                                fontWeight: FontWeight.w800,
                                fontSize: 12.5,
                              ),
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
        ),
      ),
    );
  }

  Widget _statChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(999),
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

  Widget _buildPageHero(AppLocalizations l10n) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF4A2814).withValues(alpha: 0.95),
            const Color(0xFF120808),
          ],
        ),
        border: Border.all(color: _gold.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _gold.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _gold.withValues(alpha: 0.4)),
                ),
                child: const Icon(Icons.emoji_events, color: _gold, size: 28),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.gameScreenHeroTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.gameScreenHeroSubtitle,
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
                l10n.gameScreenActiveCount(_active.length.toString()),
                Colors.greenAccent,
              ),
              _statChip(
                l10n.gameScreenUpcomingCount(
                  (_upcoming.length + _upcomingPreview.length).toString(),
                ),
                Colors.orangeAccent,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 4),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final upcomingCombined = [..._upcoming, ..._upcomingPreview];

    Widget body;
    if (_isLoading) {
      body = const Center(child: CircularProgressIndicator(color: _gold));
    } else if (_error != null) {
      body = Center(
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
                onPressed: _loadOverview,
                icon: const Icon(Icons.refresh),
                label: Text(l10n.retry),
              ),
            ],
          ),
        ),
      );
    } else {
      body = RefreshIndicator(
        color: _gold,
        onRefresh: _loadOverview,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 28),
          children: [
            _buildPageHero(l10n),
            _sectionTitle(l10n.gameScreenSectionLive),
            if (_active.isEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  l10n.gameScreenNoActive,
                  style: const TextStyle(color: Colors.white70),
                ),
              )
            else
              ..._active.map(
                (event) => _buildEventCard(l10n, event, isActive: true),
              ),
            _sectionTitle(l10n.gameScreenSectionUpcoming),
            if (upcomingCombined.isEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF151010),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white12),
                ),
                child: Text(
                  l10n.gameScreenNoUpcoming,
                  style: const TextStyle(color: Colors.white70),
                ),
              )
            else
              ...upcomingCombined.map(
                (event) => _buildEventCard(l10n, event, isActive: false),
              ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0C0A0A),
      appBar: widget.embedded ? null : AppBar(title: Text(l10n.events)),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1A0A0A), Color(0xFF0C0A0A)],
          ),
        ),
        child: body,
      ),
    );
  }
}
