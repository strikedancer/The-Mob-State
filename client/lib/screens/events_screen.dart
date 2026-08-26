import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../providers/auth_provider.dart';
import '../screens/player_profile_screen.dart';
import '../services/auth_service.dart';
import '../utils/avatar_helper.dart';
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
  Map<int, Map<String, dynamic>> _progressByEvent = const {};

  @override
  void initState() {
    super.initState();
    _loadOverview();
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
        _progressByEvent = progressByEvent;
        _isLoading = false;
        _error = null;
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

    final eventId = (event['id'] as num?)?.toInt();
    if (eventId == null) {
      return;
    }

    final details = await _loadEventDetails(eventId);
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

    final template = details['template'] is Map
        ? Map<String, dynamic>.from(details['template'] as Map)
        : null;
    final currentPlayerId =
        Provider.of<AuthProvider>(context, listen: false).currentPlayer?.id;
    final statusLabel = localizedGameEventLiveStatus(
      l10n,
      details['status']?.toString(),
    );
    final isActive = details['status']?.toString() == 'active';

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        final participants =
            ((details['participants'] as List?) ?? const <dynamic>[])
                .whereType<Map>()
                .map((item) => Map<String, dynamic>.from(item))
                .toList();

        final myProgressRaw = details['myProgress'];
        final myProgress = myProgressRaw is Map<String, dynamic>
            ? myProgressRaw
            : (myProgressRaw is Map
                  ? Map<String, dynamic>.from(myProgressRaw)
                  : null);

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
                                      details['startedAt']?.toString(),
                                      l10n,
                                    ),
                                  ),
                                  style: const TextStyle(color: Colors.white70),
                                ),
                                Text(
                                  l10n.gameScreenEndLine(
                                    _formatDateTime(
                                      details['endsAt']?.toString(),
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

  Widget _buildEventCard(
    AppLocalizations l10n,
    Map<String, dynamic> event, {
    required bool isActive,
  }) {
    final template = event['template'] is Map
        ? Map<String, dynamic>.from(event['template'] as Map)
        : null;
    final eventId = (event['id'] as num?)?.toInt();
    final progress = eventId != null ? _progressByEvent[eventId] : null;
    final score = (progress?['score'] as num?)?.toDouble();
    final rank = (progress?['rank'] as num?)?.toInt();
    final progressPercent = (progress?['progressPercent'] as num?)?.toDouble();

    return Card(
      color: const Color(0xFF1A1F2A),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _openEventDetails(event),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      localizedGameEventTitle(l10n, template),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
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
                          ? Colors.green.withOpacity(0.2)
                          : Colors.orange.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: isActive ? Colors.green : Colors.orange,
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
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (localizedGameEventShortDescription(
                l10n,
                template,
              ).isNotEmpty)
                Text(
                  localizedGameEventShortDescription(l10n, template),
                  style: const TextStyle(color: Colors.white70),
                ),
              const SizedBox(height: 10),
              Text(
                l10n.gameScreenStartLine(
                  _formatDateTime(event['startedAt']?.toString(), l10n),
                ),
                style: const TextStyle(color: Colors.white60, fontSize: 12),
              ),
              Text(
                l10n.gameScreenEndLine(
                  _formatDateTime(event['endsAt']?.toString(), l10n),
                ),
                style: const TextStyle(color: Colors.white60, fontSize: 12),
              ),
              if (progress != null) ...[
                const SizedBox(height: 10),
                Text(
                  l10n.gameCardYourScore(
                    (score ?? 0).toStringAsFixed(0),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                Text(
                  l10n.gameCardYourRank(
                    rank?.toString() ?? l10n.gameScreenDash,
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                if (progressPercent != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: LinearProgressIndicator(
                      value: (progressPercent / 100).clamp(0.0, 1.0),
                      backgroundColor: Colors.white12,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.lightBlueAccent,
                      ),
                    ),
                  ),
              ],
              const SizedBox(height: 10),
              Text(
                l10n.gameCardTapDetails,
                style: const TextStyle(
                  color: Colors.lightBlueAccent,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    Widget body;
    if (_isLoading) {
      body = const Center(child: CircularProgressIndicator());
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
        onRefresh: _loadOverview,
        child: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            Text(
              l10n.gameScreenSectionLive,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            if (_active.isEmpty)
              Text(
                l10n.gameScreenNoActive,
                style: const TextStyle(color: Colors.white70),
              ),
            ..._active.map(
              (event) => _buildEventCard(l10n, event, isActive: true),
            ),
            const SizedBox(height: 18),
            Text(
              l10n.gameScreenSectionUpcoming,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            if (_upcoming.isEmpty)
              Text(
                l10n.gameScreenNoUpcoming,
                style: const TextStyle(color: Colors.white70),
              ),
            ..._upcoming.map(
              (event) => _buildEventCard(l10n, event, isActive: false),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: widget.embedded ? null : AppBar(title: Text(l10n.events)),
      body: body,
    );
  }
}
