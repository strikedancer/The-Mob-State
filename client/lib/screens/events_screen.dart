import 'dart:convert';

import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../services/auth_service.dart';
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

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        final participants =
            ((details['participants'] as List?) ?? const <dynamic>[])
                .whereType<Map>()
                .map((item) => Map<String, dynamic>.from(item))
                .toList();
        final topParticipants = participants.take(10).toList();

        final myProgressRaw = details['myProgress'];
        final myProgress = myProgressRaw is Map<String, dynamic>
            ? myProgressRaw
            : (myProgressRaw is Map
                  ? Map<String, dynamic>.from(myProgressRaw)
                  : null);

        return AlertDialog(
          backgroundColor: const Color(0xFF111722),
          title: Text(
            localizedGameEventTitle(l10n, template),
            style: const TextStyle(color: Colors.white),
          ),
          content: SizedBox(
            width: 640,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localizedGameEventShortDescription(l10n, template),
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    l10n.gameScreenStatusPrefix(
                      localizedGameEventLiveStatus(
                        l10n,
                        details['status']?.toString(),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
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
                      _formatDateTime(details['endsAt']?.toString(), l10n),
                    ),
                    style: const TextStyle(color: Colors.white70),
                  ),
                  if (myProgress != null) ...[
                    const SizedBox(height: 14),
                    Text(
                      l10n.gameScreenYourProgress,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      l10n.gameScreenScore(
                        ((myProgress['score'] as num?) ?? 0).toStringAsFixed(0),
                      ),
                      style: const TextStyle(color: Colors.white70),
                    ),
                    Text(
                      l10n.gameScreenRank(
                        (myProgress['rank'] as num?)?.toInt().toString() ??
                            l10n.gameScreenDash,
                      ),
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                  const SizedBox(height: 14),
                  Text(
                    l10n.gameScreenLeaderboard,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (topParticipants.isEmpty)
                    Text(
                      l10n.gameScreenNoLeaderboard,
                      style: const TextStyle(color: Colors.white60),
                    )
                  else
                    ...topParticipants.map((entry) {
                      final player = entry['player'] is Map
                          ? Map<String, dynamic>.from(entry['player'] as Map)
                          : <String, dynamic>{};
                      final rank = (entry['rank'] as num?)?.toInt() ?? 0;
                      final score = (entry['score'] as num?)?.toDouble() ?? 0;
                      final username =
                          player['username']?.toString() ??
                          l10n.gameScreenUnknownPlayer;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 36,
                              child: Text(
                                '#$rank',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                username,
                                style: const TextStyle(color: Colors.white70),
                              ),
                            ),
                            Text(
                              score.toStringAsFixed(0),
                              style: const TextStyle(
                                color: Colors.lightBlueAccent,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(l10n.close),
            ),
          ],
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
