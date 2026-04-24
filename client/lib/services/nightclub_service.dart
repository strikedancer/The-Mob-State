import 'dart:convert';

import './api_client.dart';

class NightclubService {
  final ApiClient _apiClient = ApiClient();

  Future<List<dynamic>> getMyVenues() async {
    try {
      final response = await _apiClient.get('/nightclub/mine');
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return List<dynamic>.from(data['data'] ?? const []);
      }
      return const [];
    } catch (_) {
      return const [];
    }
  }

  Future<Map<String, dynamic>> setupForProperty(int propertyId) async {
    try {
      final response = await _apiClient.post('/nightclub/setup', {
        'propertyId': propertyId,
      });
      return json.decode(response.body) as Map<String, dynamic>;
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  Future<Map<String, dynamic>> getVenueStats(int venueId) async {
    try {
      final response = await _apiClient.get('/nightclub/$venueId/stats');
      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      }
      return {'success': false, 'message': 'Kon stats niet laden'};
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  Future<List<dynamic>> getAvailableDjs() async {
    try {
      final response = await _apiClient.get('/nightclub/dj/available');
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return List<dynamic>.from(data['data'] ?? const []);
      }
      return const [];
    } catch (_) {
      return const [];
    }
  }

  Future<Map<String, dynamic>> hireDj({
    required int venueId,
    required int djId,
    required int hoursCount,
    required DateTime startTime,
  }) async {
    try {
      final response = await _apiClient.post('/nightclub/$venueId/dj/hire', {
        'djId': djId,
        'hoursCount': hoursCount,
        'startTime': startTime.toIso8601String(),
      });
      return json.decode(response.body) as Map<String, dynamic>;
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  Future<Map<String, dynamic>> hireResidentDj({
    required int venueId,
    required int djId,
    required int days,
  }) async {
    try {
      final response = await _apiClient.post(
        '/nightclub/$venueId/dj/resident',
        {'djId': djId, 'days': days},
      );
      return json.decode(response.body) as Map<String, dynamic>;
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  Future<List<dynamic>> getAvailableSecurity() async {
    try {
      final response = await _apiClient.get('/nightclub/security/available');
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return List<dynamic>.from(data['data'] ?? const []);
      }
      return const [];
    } catch (_) {
      return const [];
    }
  }

  Future<Map<String, dynamic>> hireSecurity({
    required int venueId,
    required int guardId,
    required DateTime shiftDate,
  }) async {
    try {
      final response = await _apiClient.post(
        '/nightclub/$venueId/security/hire',
        {'guardId': guardId, 'shiftDate': shiftDate.toIso8601String()},
      );
      return json.decode(response.body) as Map<String, dynamic>;
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  Future<Map<String, dynamic>> scheduleEvent({
    required int venueId,
    required String eventType,
    required DateTime startsAt,
  }) async {
    try {
      final response = await _apiClient.post(
        '/nightclub/$venueId/events/schedule',
        {'eventType': eventType, 'startsAt': startsAt.toIso8601String()},
      );
      return json.decode(response.body) as Map<String, dynamic>;
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  Future<Map<String, dynamic>> investMarketing({
    required int venueId,
    required int amount,
  }) async {
    try {
      final response = await _apiClient.post(
        '/nightclub/$venueId/upgrades/marketing',
        {'amount': amount},
      );
      return json.decode(response.body) as Map<String, dynamic>;
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  Future<Map<String, dynamic>> applyUpgrade({
    required int venueId,
    required String upgradeType,
  }) async {
    try {
      final response = await _apiClient.post(
        '/nightclub/$venueId/upgrades/apply',
        {'upgradeType': upgradeType},
      );
      return json.decode(response.body) as Map<String, dynamic>;
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  Future<Map<String, dynamic>> respondIncident({
    required int venueId,
    required String actionType,
  }) async {
    try {
      final response = await _apiClient.post(
        '/nightclub/$venueId/incidents/respond',
        {'actionType': actionType},
      );
      return json.decode(response.body) as Map<String, dynamic>;
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  Future<List<dynamic>> searchRivalsByName(String name) async {
    try {
      final encoded = Uri.encodeQueryComponent(name);
      final response = await _apiClient.get(
        '/nightclub/rivals/search?name=$encoded',
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return List<dynamic>.from(data['data'] ?? const []);
      }
      return const [];
    } catch (_) {
      return const [];
    }
  }

  Future<Map<String, dynamic>> rivalAction({
    required int venueId,
    required String targetName,
    required String actionType,
  }) async {
    try {
      final response = await _apiClient.post(
        '/nightclub/$venueId/rivals/action',
        {'targetName': targetName, 'actionType': actionType},
      );
      return json.decode(response.body) as Map<String, dynamic>;
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  Future<Map<String, dynamic>> storeDrugs({
    required int venueId,
    required String drugType,
    required String quality,
    required int quantity,
  }) async {
    try {
      final response = await _apiClient.post(
        '/nightclub/$venueId/drugs/store',
        {'drugType': drugType, 'quality': quality, 'quantity': quantity},
      );
      return json.decode(response.body) as Map<String, dynamic>;
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  Future<List<dynamic>> getAssignableProstitutes(int venueId) async {
    try {
      final response = await _apiClient.get(
        '/nightclub/$venueId/prostitutes/available',
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return List<dynamic>.from(data['data'] ?? const []);
      }
      return const [];
    } catch (_) {
      return const [];
    }
  }

  Future<Map<String, dynamic>> assignProstitute({
    required int venueId,
    required int prostituteId,
  }) async {
    try {
      final response = await _apiClient.post(
        '/nightclub/$venueId/prostitutes/assign',
        {'prostituteId': prostituteId},
      );
      return json.decode(response.body) as Map<String, dynamic>;
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  Future<Map<String, dynamic>> unassignProstitute({
    required int venueId,
    required int prostituteId,
  }) async {
    try {
      final response = await _apiClient.post(
        '/nightclub/$venueId/prostitutes/unassign',
        {'prostituteId': prostituteId},
      );
      return json.decode(response.body) as Map<String, dynamic>;
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  Future<Map<String, dynamic>> getLeaderboard({
    String scope = 'global',
    int limit = 10,
  }) async {
    try {
      final response = await _apiClient.get(
        '/nightclub/leaderboard?scope=$scope&limit=$limit',
      );
      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      }
      return {'success': false, 'message': 'Kon leaderboard niet laden'};
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  Future<Map<String, dynamic>> getSeasonSummary() async {
    try {
      final response = await _apiClient.get('/nightclub/season');
      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      }
      return {'success': false, 'message': 'Kon season ranking niet laden'};
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }
}
