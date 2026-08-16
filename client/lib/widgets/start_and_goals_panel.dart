import 'dart:convert';

import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../screens/crime_screen.dart';
import '../screens/crew_screen.dart';
import '../screens/jobs_screen.dart';
import '../services/auth_service.dart';

class StartAndGoalsPanel extends StatefulWidget {
  final bool compact;
  final int playerRank;

  const StartAndGoalsPanel({
    super.key,
    this.compact = false,
    this.playerRank = 1,
  });

  @override
  State<StartAndGoalsPanel> createState() => _StartAndGoalsPanelState();
}

class _StartAndGoalsPanelState extends State<StartAndGoalsPanel> {
  Map<String, dynamic>? _onboarding;
  Map<String, dynamic>? _daily;
  Map<String, dynamic>? _crewWeek;
  bool _loading = true;

  bool get _isNl => Localizations.localeOf(context).languageCode == 'nl';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final api = AuthService().apiClient;
      final results = await Future.wait([
        api.get('/player/onboarding'),
        api.get('/daily-goals/daily'),
        api.get('/crews/weekly-goal'),
      ]);
      if (!mounted) return;
      setState(() {
        _onboarding = _json(results[0].body)['data'] as Map<String, dynamic>?;
        _daily = _json(results[1].body)['data'] as Map<String, dynamic>?;
        _crewWeek = _json(results[2].body)['data'] as Map<String, dynamic>?;
        _loading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Map<String, dynamic> _json(String body) {
    try {
      return jsonDecode(body) as Map<String, dynamic>;
    } catch (_) {
      return {};
    }
  }

  void _openCta(String route) {
    Widget page;
    switch (route) {
      case '/jobs':
        page = const JobsScreen();
        break;
      case '/crew':
        page = const CrewScreen();
        break;
      default:
        page = const CrimeScreen();
    }
    Navigator.push(context, MaterialPageRoute(builder: (_) => page)).then((_) => _load());
  }

  Future<void> _claimDaily(String key) async {
    final api = AuthService().apiClient;
    await api.post('/daily-goals/daily/claim', {'goalKey': key});
    await _load();
  }

  Future<void> _claimCrewWeek() async {
    final api = AuthService().apiClient;
    await api.post('/crews/weekly-goal/claim', {});
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
        ),
      );
    }

    final l10n = AppLocalizations.of(context);
    final completed = _onboarding?['completed'] == true;
    final featured = _daily?['featured'] as Map<String, dynamic>?;
    final streak = (_daily?['streak'] as num?)?.toInt() ?? 0;
    final crewIn = _crewWeek?['inCrew'] == true;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!completed && _onboarding != null)
          Card(
            color: const Color(0xFF2A1A12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isNl ? 'Jouw start' : 'Your start',
                    style: const TextStyle(
                      color: Color(0xFFD4AF37),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _isNl
                        ? (_onboarding!['titleNl'] as String? ?? '')
                        : (_onboarding!['titleEn'] as String? ?? ''),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _isNl
                        ? (_onboarding!['bodyNl'] as String? ?? '')
                        : (_onboarding!['bodyEn'] as String? ?? ''),
                    style: TextStyle(color: Colors.white.withOpacity(0.75)),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => _openCta(_onboarding!['ctaRoute'] as String? ?? '/crimes'),
                    child: Text(_isNl ? 'Nu doen' : 'Do this now'),
                  ),
                ],
              ),
            ),
          ),
        if (featured != null)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        l10n?.dailyGoals ?? (_isNl ? 'Dagdoelen' : 'Daily goals'),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      if (streak > 0) ...[
                        const SizedBox(width: 8),
                        Text(
                          _isNl ? '$streak dagen streak' : '$streak day streak',
                          style: const TextStyle(color: Color(0xFFD4AF37), fontSize: 12),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isNl
                        ? (featured['titleNl'] as String? ?? featured['key'] as String? ?? '')
                        : (featured['titleEn'] as String? ?? featured['key'] as String? ?? ''),
                  ),
                  Text(
                    '${featured['progress'] ?? 0}/${featured['target'] ?? 0}',
                    style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12),
                  ),
                  if (featured['claimable'] == true)
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => _claimDaily(featured['key'] as String),
                        child: Text(_isNl ? 'Claim' : 'Claim'),
                      ),
                    ),
                ],
              ),
            ),
          ),
        if (crewIn)
          Card(
            child: ListTile(
              title: Text(
                _isNl
                    ? (_crewWeek!['titleNl'] as String? ?? 'Crew weekdoel')
                    : (_crewWeek!['titleEn'] as String? ?? 'Crew weekly goal'),
              ),
              subtitle: Text(
                '${_crewWeek!['progress'] ?? 0}/${_crewWeek!['target'] ?? 1}'
                '${_crewWeek!['claimed'] == true ? (_isNl ? ' · geclaimd' : ' · claimed') : ''}',
              ),
              trailing: _crewWeek!['claimable'] == true
                  ? TextButton(
                      onPressed: _claimCrewWeek,
                      child: Text(_isNl ? 'Claim' : 'Claim'),
                    )
                  : null,
            ),
          ),
      ],
    );
  }
}
