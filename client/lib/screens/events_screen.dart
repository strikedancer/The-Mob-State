import 'dart:convert';

import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../utils/top_right_notification.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  final _apiClient = AuthService().apiClient;

  bool _isLoading = true;
  List<Map<String, dynamic>> _active = const [];
  List<Map<String, dynamic>> _upcoming = const [];
  Map<int, Map<String, dynamic>> _progressByEvent = const {};

  bool get _isNl => Localizations.localeOf(context).languageCode == 'nl';
  String _tr(String nl, String en) => _isNl ? nl : en;

  @override
  void initState() {
    super.initState();
    _loadOverview();
  }

  Future<void> _loadOverview() async {
    setState(() => _isLoading = true);

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
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(
            _tr('Events konden niet geladen worden.', 'Could not load events.'),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _eventTitle(Map<String, dynamic> event) {
    final template = event['template'] as Map<String, dynamic>?;
    if (template == null) return 'Event';
    final title = _isNl ? template['titleNl'] : template['titleEn'];
    return (title?.toString().trim().isNotEmpty ?? false)
        ? title.toString()
        : (template['titleEn']?.toString() ??
              template['key']?.toString() ??
              'Event');
  }

  String _eventShortDescription(Map<String, dynamic> event) {
    final template = event['template'] as Map<String, dynamic>?;
    if (template == null) return '';
    final value = _isNl
        ? template['shortDescriptionNl']
        : template['shortDescriptionEn'];
    return value?.toString() ?? '';
  }

  String _formatDateTime(String? iso) {
    if (iso == null || iso.isEmpty) return '-';
    final parsed = DateTime.tryParse(iso);
    if (parsed == null) return '-';
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
    final eventId = (event['id'] as num?)?.toInt();
    if (eventId == null) {
      return;
    }

    final details = await _loadEventDetails(eventId);
    if (!mounted) return;

    if (details == null) {
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(
            _tr(
              'Eventdetails konden niet geladen worden.',
              'Could not load event details.',
            ),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

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
            _eventTitle(details),
            style: const TextStyle(color: Colors.white),
          ),
          content: SizedBox(
            width: 640,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _eventShortDescription(details),
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${_tr('Status', 'Status')}: ${details['status'] ?? '-'}',
                    style: const TextStyle(color: Colors.white),
                  ),
                  Text(
                    '${_tr('Start', 'Start')}: ${_formatDateTime(details['startedAt']?.toString())}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  Text(
                    '${_tr('Einde', 'End')}: ${_formatDateTime(details['endsAt']?.toString())}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  if (myProgress != null) ...[
                    const SizedBox(height: 14),
                    Text(
                      _tr('Jouw voortgang', 'Your progress'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${_tr('Score', 'Score')}: ${((myProgress['score'] as num?) ?? 0).toStringAsFixed(0)}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    Text(
                      '${_tr('Rank', 'Rank')}: ${(myProgress['rank'] as num?)?.toInt() ?? '-'}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                  const SizedBox(height: 14),
                  Text(
                    _tr('Leaderboard (Top 10)', 'Leaderboard (Top 10)'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (topParticipants.isEmpty)
                    Text(
                      _tr(
                        'Nog geen leaderboard data.',
                        'No leaderboard data yet.',
                      ),
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
                          _tr('Onbekend', 'Unknown');
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
              child: Text(_tr('Sluiten', 'Close')),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEventCard(Map<String, dynamic> event, {required bool isActive}) {
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
                      _eventTitle(event),
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
                          ? _tr('Actief', 'Active')
                          : _tr('Gepland', 'Scheduled'),
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
              if (_eventShortDescription(event).isNotEmpty)
                Text(
                  _eventShortDescription(event),
                  style: const TextStyle(color: Colors.white70),
                ),
              const SizedBox(height: 10),
              Text(
                '${_tr('Start', 'Start')}: ${_formatDateTime(event['startedAt']?.toString())}',
                style: const TextStyle(color: Colors.white60, fontSize: 12),
              ),
              Text(
                '${_tr('Einde', 'End')}: ${_formatDateTime(event['endsAt']?.toString())}',
                style: const TextStyle(color: Colors.white60, fontSize: 12),
              ),
              if (progress != null) ...[
                const SizedBox(height: 10),
                Text(
                  '${_tr('Jouw score', 'Your score')}: ${(score ?? 0).toStringAsFixed(0)}',
                  style: const TextStyle(color: Colors.white),
                ),
                Text(
                  '${_tr('Jouw rank', 'Your rank')}: ${rank ?? '-'}',
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
                _tr(
                  'Tik voor details en leaderboard',
                  'Tap for details and leaderboard',
                ),
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
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: _loadOverview,
      child: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Text(
            _tr('Live Events', 'Live Events'),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          if (_active.isEmpty)
            Text(
              _tr(
                'Er zijn nu geen actieve events.',
                'There are no active events right now.',
              ),
              style: const TextStyle(color: Colors.white70),
            ),
          ..._active.map((event) => _buildEventCard(event, isActive: true)),
          const SizedBox(height: 18),
          Text(
            _tr('Aankomende Events', 'Upcoming Events'),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          if (_upcoming.isEmpty)
            Text(
              _tr(
                'Er zijn geen geplande events.',
                'There are no upcoming events.',
              ),
              style: const TextStyle(color: Colors.white70),
            ),
          ..._upcoming.map((event) => _buildEventCard(event, isActive: false)),
        ],
      ),
    );
  }
}
