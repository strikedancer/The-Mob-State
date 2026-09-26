import 'dart:convert';

import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../services/api_client.dart';
import '../utils/formatters.dart';
import '../utils/player_profile_navigation.dart';
import '../widgets/mobile_load_error.dart';

/// Weekly / all-time boards for crimes, jail minutes, vehicle thefts, crime loot.
class StatsLeaderboardScreen extends StatefulWidget {
  final bool embedded;

  const StatsLeaderboardScreen({super.key, this.embedded = false});

  @override
  State<StatsLeaderboardScreen> createState() => _StatsLeaderboardScreenState();
}

class _StatsLeaderboardScreenState extends State<StatsLeaderboardScreen> {
  final ApiClient _api = ApiClient();
  String _metric = 'crimes';
  String _period = 'weekly';
  bool _loading = true;
  String? _error;
  List<_StatsEntry> _entries = const [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final response = await _api.get(
        '/leaderboards/stats/$_metric?period=$_period&limit=50',
      );
      if (response.statusCode != 200) {
        throw Exception('HTTP ${response.statusCode}');
      }
      final data = json.decode(response.body) as Map<String, dynamic>;
      final raw = data['entries'];
      final list = raw is List
          ? raw
              .whereType<Map>()
              .map(
                (row) => _StatsEntry(
                  rank: (row['rank'] as num?)?.toInt() ?? 0,
                  playerId: (row['playerId'] as num?)?.toInt() ?? 0,
                  username: (row['username'] ?? '').toString(),
                  score: (row['score'] as num?)?.toInt() ?? 0,
                  isMe: row['isCurrentPlayer'] == true,
                ),
              )
              .toList()
          : <_StatsEntry>[];
      if (!mounted) return;
      setState(() {
        _entries = list;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  String _formatScore(AppLocalizations l10n, int score) {
    if (_metric == 'jail') {
      final hours = score ~/ 60;
      final mins = score % 60;
      return l10n.statsBoardJailScore(hours.toString(), mins.toString());
    }
    if (_metric == 'crime_income') {
      return formatCurrency(score);
    }
    return score.toString();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final body = Column(
      children: [
        if (!widget.embedded)
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: Text(
              l10n.statsBoardHelpHow,
              style: const TextStyle(color: Colors.white60, fontSize: 12, height: 1.35),
            ),
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final m in const [
                'crimes',
                'jail',
                'vehicle_thefts',
                'crime_income',
              ])
                ChoiceChip(
                  label: Text(
                    m == 'jail'
                        ? l10n.statsBoardMetricJail
                        : m == 'vehicle_thefts'
                            ? l10n.statsBoardMetricThefts
                            : m == 'crime_income'
                                ? l10n.statsBoardMetricCrimeIncome
                                : l10n.statsBoardMetricCrimes,
                  ),
                  selected: _metric == m,
                  onSelected: (_) {
                    setState(() => _metric = m);
                    _load();
                  },
                ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
          child: Row(
            children: [
              ChoiceChip(
                label: Text(l10n.statsBoardPeriodWeekly),
                selected: _period == 'weekly',
                onSelected: (_) {
                  setState(() => _period = 'weekly');
                  _load();
                },
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                label: Text(l10n.statsBoardPeriodAllTime),
                selected: _period == 'all_time',
                onSelected: (_) {
                  setState(() => _period = 'all_time');
                  _load();
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
                  ? MobileLoadError(
                      message: _error!,
                      onRetry: _load,
                    )
                  : _entries.isEmpty
                      ? Center(
                          child: Text(
                            l10n.statsBoardEmpty,
                            style: const TextStyle(color: Colors.white54),
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _load,
                          child: ListView.separated(
                            padding: const EdgeInsets.all(12),
                            itemCount: _entries.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 6),
                            itemBuilder: (context, index) {
                              final e = _entries[index];
                              return ListTile(
                                tileColor: e.isMe
                                    ? const Color(0x332A4A2A)
                                    : const Color(0xFF161616),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                leading: CircleAvatar(
                                  backgroundColor: const Color(0xFF2A2A2A),
                                  child: Text(
                                    '#${e.rank}',
                                    style: const TextStyle(
                                      color: Color(0xFFD4AF37),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  e.username,
                                  style: TextStyle(
                                    color: e.isMe
                                        ? const Color(0xFFD4AF37)
                                        : Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                trailing: Text(
                                  _formatScore(l10n, e.score),
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                onTap: e.playerId > 0
                                    ? () => PlayerProfileNavigation.open(
                                          context,
                                          e.playerId,
                                          e.username,
                                        )
                                    : null,
                              );
                            },
                          ),
                        ),
        ),
      ],
    );

    if (widget.embedded) {
      return ColoredBox(color: const Color(0xFF0D0D0D), child: body);
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        title: Text(l10n.statsBoardTitle),
        backgroundColor: const Color(0xFF1A1A1A),
      ),
      body: body,
    );
  }
}

class _StatsEntry {
  final int rank;
  final int playerId;
  final String username;
  final int score;
  final bool isMe;

  const _StatsEntry({
    required this.rank,
    required this.playerId,
    required this.username,
    required this.score,
    required this.isMe,
  });
}
