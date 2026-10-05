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

  Future<List<Map<String, dynamic>>> getRiskWire({int limit = 10}) async {
    try {
      final response = await _api.get('/territory/risk/wire?limit=$limit');
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final captures = data['params']?['captures'];
        if (captures is! List) return const [];
        return captures
            .whereType<Map>()
            .map((e) => Map<String, dynamic>.from(e))
            .toList(growable: false);
      }
      return const [];
    } catch (_) {
      return const [];
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

  Future<Map<String, dynamic>> doHoldAction(String regionKey, String actionType) async {
    try {
      final response = await _api.post('/territory/action', {
        'regionKey': regionKey,
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

  Future<Map<String, dynamic>> startProject(
    String regionKey, {
    required String projectType,
  }) async {
    try {
      final response = await _api.post('/territory/projects/start', {
        'regionKey': regionKey,
        'projectType': projectType,
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

  Future<Map<String, dynamic>> deployGarrison(String regionKey) async {
    try {
      final response = await _api.post('/territory/garrison/deploy', {
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

  Future<Map<String, dynamic>> abandonRegion({
    required String regionKey,
    required String confirm,
  }) async {
    try {
      final response = await _api.post('/territory/abandon', {
        'regionKey': regionKey,
        'confirm': confirm,
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

  Future<Map<String, dynamic>> abandonCountry({
    required String countryCode,
    required String confirm,
  }) async {
    try {
      final response = await _api.post('/territory/abandon-country', {
        'countryCode': countryCode,
        'confirm': confirm,
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

  Future<Map<String, dynamic>> commitArsenal({
    required String regionKey,
    required String kind,
    required String itemKey,
    required int quantity,
  }) async {
    try {
      final response = await _api.post('/territory/arsenal/commit', {
        'regionKey': regionKey,
        'kind': kind,
        'itemKey': itemKey,
        'quantity': quantity,
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

  Future<Map<String, dynamic>> recallArsenal({
    required String regionKey,
    required String kind,
    required String itemKey,
    required int quantity,
  }) async {
    try {
      final response = await _api.post('/territory/arsenal/recall', {
        'regionKey': regionKey,
        'kind': kind,
        'itemKey': itemKey,
        'quantity': quantity,
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

  // ── Classic Risk (NL-first ownership path) ───────────────────────────────

  Future<Map<String, dynamic>> riskClaimReinforce(String countryCode) async {
    try {
      final response = await _api.post('/territory/risk/reinforce/claim', {
        'countryCode': countryCode,
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

  Future<Map<String, dynamic>> riskPlaceReinforce({
    required String regionKey,
    required int amount,
  }) async {
    try {
      final response = await _api.post('/territory/risk/reinforce/place', {
        'regionKey': regionKey,
        'amount': amount,
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

  Future<Map<String, dynamic>> riskAttack({
    required String fromRegionKey,
    required String toRegionKey,
    required int commitArmies,
  }) async {
    try {
      final response = await _api.post('/territory/risk/attack', {
        'fromRegionKey': fromRegionKey,
        'toRegionKey': toRegionKey,
        'commitArmies': commitArmies,
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

  Future<Map<String, dynamic>> riskInvade({
    required String toRegionKey,
  }) async {
    try {
      final response = await _api.post('/territory/risk/invade', {
        'toRegionKey': toRegionKey,
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

  Future<Map<String, dynamic>> riskFortify({
    required String fromRegionKey,
    required String toRegionKey,
    required int amount,
  }) async {
    try {
      final response = await _api.post('/territory/risk/fortify', {
        'fromRegionKey': fromRegionKey,
        'toRegionKey': toRegionKey,
        'amount': amount,
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
