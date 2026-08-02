import 'dart:convert';

import './api_client.dart';

class TerritoryService {
  final ApiClient _api = ApiClient();

  // ── Countries ──────────────────────────────────────────────────────────────

  Future<List<dynamic>> getCountries() async {
    try {
      final response = await _api.get('/territory/countries');
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return (data['params']?['countries'] as List<dynamic>?) ?? [];
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  // ── Map ────────────────────────────────────────────────────────────────────

  Future<Map<String, dynamic>> getMap(String countryCode) async {
    try {
      final response = await _api.get('/territory/map/$countryCode');
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return (data['params'] as Map<String, dynamic>?) ?? {};
      }
      return {};
    } catch (_) {
      return {};
    }
  }

  // ── Overview ───────────────────────────────────────────────────────────────

  Future<Map<String, dynamic>> getOverview() async {
    try {
      final response = await _api.get('/territory/overview');
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return (data['params'] as Map<String, dynamic>?) ?? {};
      }
      return {};
    } catch (_) {
      return {};
    }
  }

  Future<Map<String, dynamic>?> getMyCrew() async {
    try {
      final response = await _api.get('/crews/mine');
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final params = data['params'] as Map<String, dynamic>?;
        final crew = params?['crew'];
        if (crew is Map<String, dynamic>) {
          return crew;
        }
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  // ── Contest ────────────────────────────────────────────────────────────────

  Future<Map<String, dynamic>> startContest(String regionKey) async {
    try {
      final response = await _api.post('/territory/contest/start', {'regionKey': regionKey});
      final data = json.decode(response.body) as Map<String, dynamic>;
      return {
        'success': response.statusCode == 200,
        ...data['params'] as Map<String, dynamic>? ?? {},
        'event': data['event'],
      };
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  Future<Map<String, dynamic>> defendContest(int contestId) async {
    try {
      final response = await _api.post('/territory/contest/defend', {'contestId': contestId});
      final data = json.decode(response.body) as Map<String, dynamic>;
      return {'success': response.statusCode == 200, 'event': data['event']};
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  // ── Action ─────────────────────────────────────────────────────────────────

  Future<Map<String, dynamic>> doAction(int contestId, String actionType) async {
    try {
      final response = await _api.post('/territory/action', {
        'contestId': contestId,
        'actionType': actionType,
      });
      final data = json.decode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        return {
          'success': true,
          ...data['params'] as Map<String, dynamic>? ?? {},
        };
      }
      return {'success': false, 'event': data['event'], 'message': data['message'] ?? ''};
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  Future<Map<String, dynamic>> startProject(String regionKey) async {
    try {
      final response = await _api.post('/territory/projects/start', {
        'regionKey': regionKey,
      });
      final data = json.decode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        return {
          'success': true,
          ...data['params'] as Map<String, dynamic>? ?? {},
          'event': data['event'],
        };
      }
      return {'success': false, 'event': data['event'], 'message': data['message'] ?? ''};
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  Future<Map<String, dynamic>> contributeProject(String regionKey) async {
    try {
      final response = await _api.post('/territory/projects/contribute', {
        'regionKey': regionKey,
      });
      final data = json.decode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        return {
          'success': true,
          ...data['params'] as Map<String, dynamic>? ?? {},
          'event': data['event'],
        };
      }
      return {'success': false, 'event': data['event'], 'message': data['message'] ?? ''};
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  // ── Crew ───────────────────────────────────────────────────────────────────

  Future<Map<String, dynamic>> getCrewTerritory(int crewId) async {
    try {
      final response = await _api.get('/territory/crew/$crewId');
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return (data['params'] as Map<String, dynamic>?) ?? {};
      }
      return {};
    } catch (_) {
      return {};
    }
  }

  // ── Leaderboard ────────────────────────────────────────────────────────────

  Future<List<dynamic>> getLeaderboard() async {
    try {
      final response = await _api.get('/territory/leaderboard');
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return (data['params']?['leaderboard'] as List<dynamic>?) ?? [];
      }
      return [];
    } catch (_) {
      return [];
    }
  }
}
