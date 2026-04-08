import 'dart:convert';
import './api_client.dart';
import '../models/prostitute.dart';
import '../models/achievement.dart';

class ProstitutionService {
  final ApiClient _apiClient = ApiClient();

  Map<String, dynamic> _normalizeLeaderboardResponse(dynamic raw) {
    if (raw is! Map<String, dynamic>) {
      return {'success': false, 'leaderboard': []};
    }

    final leaderboard = _normalizeJsonObjectList(raw['leaderboard']);
    return {...raw, 'leaderboard': leaderboard};
  }

  Map<String, dynamic> _normalizeAchievementsResponse(dynamic raw) {
    if (raw is! Map<String, dynamic>) {
      return {'success': false, 'achievements': []};
    }

    final achievements = _normalizeJsonObjectList(raw['achievements']);
    return {...raw, 'achievements': achievements};
  }

  List<Map<String, dynamic>> _normalizeJsonObjectList(dynamic raw) {
    if (raw is! List) return const [];

    return raw
        .map<Map<String, dynamic>?>((item) => _asJsonMap(item))
        .whereType<Map<String, dynamic>>()
        .toList();
  }

  Map<String, dynamic>? _asJsonMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) {
      return value.map((key, val) => MapEntry('$key', val));
    }
    if (value is String && value.trim().isNotEmpty) {
      try {
        final decoded = json.decode(value);
        if (decoded is Map<String, dynamic>) return decoded;
        if (decoded is Map) {
          return decoded.map((key, val) => MapEntry('$key', val));
        }
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  // Get all prostitutes for player
  Future<Map<String, dynamic>> getProstitutes() async {
    try {
      final response = await _apiClient.get('/prostitutes');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          final List<dynamic> prostitutesJson = data['prostitutes'] ?? [];
          final prostitutes = prostitutesJson
              .map((json) => Prostitute.fromJson(json))
              .toList();

          final stats = data['stats'] != null
              ? ProstituteStats.fromJson(data['stats'])
              : null;
          final housingSummary = data['housingSummary'] != null
              ? ProstituteHousingSummary.fromJson(
                  Map<String, dynamic>.from(data['housingSummary'] as Map),
                )
              : null;

          return {
            'success': true,
            'prostitutes': prostitutes,
            'stats': stats,
            'housingSummary': housingSummary,
          };
        }
      }
      return {'success': false, 'message': 'Failed to load prostitutes'};
    } catch (e) {
      print('Error loading prostitutes: $e');
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  // Check if player can recruit
  Future<Map<String, dynamic>> canRecruit() async {
    try {
      final response = await _apiClient.get('/prostitutes/can-recruit');
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return {'canRecruit': false};
    } catch (e) {
      print('Error checking recruitment status: $e');
      return {'canRecruit': false};
    }
  }

  Future<Map<String, dynamic>> getCurrentPlayer() async {
    try {
      final response = await _apiClient.get('/player/me');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final player = data['player'];
        if (player is Map<String, dynamic>) {
          return {'success': true, 'player': player};
        }
      }
      return {'success': false};
    } catch (e) {
      print('Error loading current player: $e');
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  // Recruit a new prostitute
  Future<Map<String, dynamic>> recruitProstitute() async {
    try {
      final response = await _apiClient.post('/prostitutes/recruit', {});
      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        final prostitute = data['prostitute'] != null
            ? Prostitute.fromJson(data['prostitute'])
            : null;

        return {
          'success': true,
          'message': data['message'],
          'prostitute': prostitute,
          'newAchievements': data['newlyUnlockedAchievements'] ?? [],
        };
      }

      return {
        'success': false,
        'message': data['message'] ?? 'Failed to recruit',
        'cooldownRemaining': data['cooldownRemaining'],
        'jailRemaining': data['jailRemaining'],
      };
    } catch (e) {
      print('Error recruiting prostitute: $e');
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  // Move prostitute to red light district
  Future<Map<String, dynamic>> moveToRedLight(
    int prostituteId,
    int roomId,
  ) async {
    try {
      final response = await _apiClient.post(
        '/prostitutes/$prostituteId/move-to-redlight',
        {'redLightRoomId': roomId},
      );
      return json.decode(response.body);
    } catch (e) {
      print('Error moving to red light: $e');
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  // Move prostitute to red light district (auto-assign room, create new if full)
  Future<Map<String, dynamic>> moveToRedLightInDistrict(
    int prostituteId,
    int districtId,
  ) async {
    try {
      final response = await _apiClient.post(
        '/prostitutes/$prostituteId/move-to-redlight',
        {'redLightDistrictId': districtId},
      );
      return json.decode(response.body);
    } catch (e) {
      print('Error moving to red light district: $e');
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  // Move prostitute to street
  Future<Map<String, dynamic>> moveToStreet(int prostituteId) async {
    try {
      final response = await _apiClient.post(
        '/prostitutes/$prostituteId/move-to-street',
        {},
      );
      return json.decode(response.body);
    } catch (e) {
      print('Error moving to street: $e');
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  // Work shift: 8-hour work with XP and money earnings
  Future<Map<String, dynamic>> workShift(
    int prostituteId, {
    String location = 'street',
  }) async {
    try {
      final response = await _apiClient.post(
        '/prostitutes/$prostituteId/work-shift',
        {'location': location},
      );
      return json.decode(response.body);
    } catch (e) {
      print('Error executing work shift: $e');
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  // Settle earnings
  Future<Map<String, dynamic>> settleEarnings() async {
    try {
      final response = await _apiClient.post(
        '/prostitutes/settle-earnings',
        {},
      );
      return json.decode(response.body);
    } catch (e) {
      print('Error settling earnings: $e');
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  // Get available red light districts
  Future<List<RedLightDistrict>> getAvailableDistricts() async {
    try {
      final response = await _apiClient.get('/red-light-districts/available');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          final List<dynamic> districtsJson = data['districts'] ?? [];
          return districtsJson
              .map((json) => RedLightDistrict.fromJson(json))
              .toList();
        }
      }
      return [];
    } catch (e) {
      print('Error loading available districts: $e');
      return [];
    }
  }

  // Get player's owned districts
  Future<List<RedLightDistrict>> getMyDistricts() async {
    try {
      final response = await _apiClient.get(
        '/red-light-districts/my-districts',
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          final List<dynamic> districtsJson = data['districts'] ?? [];
          return districtsJson
              .map((json) => RedLightDistrict.fromJson(json))
              .toList();
        }
      }
      return [];
    } catch (e) {
      print('Error loading player districts: $e');
      return [];
    }
  }

  // Get district by country
  Future<RedLightDistrict?> getDistrictByCountry(String countryCode) async {
    try {
      final response = await _apiClient.get(
        '/red-light-districts/country/$countryCode',
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['district'] != null) {
          final districtJson = Map<String, dynamic>.from(
            data['district'] as Map<String, dynamic>,
          );
          if (data['stats'] != null) {
            districtJson['stats'] = data['stats'];
          }
          return RedLightDistrict.fromJson(districtJson);
        }
      }
      return null;
    } catch (e) {
      print('Error loading district: $e');
      return null;
    }
  }

  // Get district by ID
  Future<RedLightDistrict?> getDistrictById(int districtId) async {
    try {
      final response = await _apiClient.get('/red-light-districts/$districtId');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['district'] != null) {
          final districtJson = Map<String, dynamic>.from(
            data['district'] as Map<String, dynamic>,
          );
          if (data['stats'] != null) {
            districtJson['stats'] = data['stats'];
          }
          return RedLightDistrict.fromJson(districtJson);
        }
      }
      return null;
    } catch (e) {
      print('Error loading district by ID: $e');
      return null;
    }
  }

  // Purchase a red light district
  Future<Map<String, dynamic>> purchaseDistrict(String countryCode) async {
    try {
      final response = await _apiClient.post('/red-light-districts/purchase', {
        'countryCode': countryCode,
      });
      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        final district = data['district'] != null
            ? RedLightDistrict.fromJson(data['district'])
            : null;

        final newAchievements = data['newlyUnlockedAchievements'] != null
            ? (data['newlyUnlockedAchievements'] as List)
                  .map((json) => Achievement.fromJson(json))
                  .toList()
            : <Achievement>[];

        return {
          'success': true,
          'message': data['message'],
          'district': district,
          'newAchievements': newAchievements,
        };
      }

      return {
        'success': false,
        'message': data['message'] ?? 'Failed to purchase district',
      };
    } catch (e) {
      print('Error purchasing district: $e');
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  // Get available rooms in a district
  Future<List<RedLightRoom>> getAvailableRooms(int districtId) async {
    try {
      final response = await _apiClient.get(
        '/red-light-districts/$districtId/available-rooms',
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          final List<dynamic> roomsJson = data['rooms'] ?? [];
          return roomsJson.map((json) => RedLightRoom.fromJson(json)).toList();
        }
      }
      return [];
    } catch (e) {
      print('Error loading available rooms: $e');
      return [];
    }
  }

  // Get district stats
  Future<DistrictStats?> getDistrictStats(int districtId) async {
    try {
      final response = await _apiClient.get(
        '/red-light-districts/$districtId/stats',
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['stats'] != null) {
          return DistrictStats.fromJson(data['stats']);
        }
      }
      return null;
    } catch (e) {
      print('Error loading district stats: $e');
      return null;
    }
  }

  // Upgrade district tier (Basic -> Luxury -> VIP)
  Future<Map<String, dynamic>> upgradeTier(int districtId) async {
    try {
      final response = await _apiClient.post(
        '/red-light-districts/$districtId/upgrade-tier',
        {},
      );

      final data = json.decode(response.body);
      return data;
    } catch (e) {
      print('Error upgrading tier: $e');
      return {'success': false, 'message': 'Error upgrading tier'};
    }
  }

  // Upgrade district security
  Future<Map<String, dynamic>> upgradeSecurity(int districtId) async {
    try {
      final response = await _apiClient.post(
        '/red-light-districts/$districtId/upgrade-security',
        {},
      );

      final data = json.decode(response.body);
      return data;
    } catch (e) {
      print('Error upgrading security: $e');
      return {'success': false, 'message': 'Error upgrading security'};
    }
  }

  // Get upgrade information for a district
  Future<Map<String, dynamic>?> getUpgradeInfo(int districtId) async {
    try {
      final response = await _apiClient.get(
        '/red-light-districts/$districtId/upgrade-info',
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['upgradeInfo'] != null) {
          return data['upgradeInfo'];
        }
      }
      return null;
    } catch (e) {
      print('Error loading upgrade info: $e');
      return null;
    }
  }

  // Get police raid statistics
  Future<Map<String, dynamic>?> getRaidStats() async {
    try {
      final response = await _apiClient.get('/police-raids/stats');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['stats'] != null) {
          return data['stats'];
        }
      }
      return null;
    } catch (e) {
      print('Error loading raid stats: $e');
      return null;
    }
  }

  // Check for police raid (testing/manual trigger)
  Future<Map<String, dynamic>> checkRaid() async {
    try {
      final response = await _apiClient.post('/police-raids/check', {});
      final data = json.decode(response.body);
      return data;
    } catch (e) {
      print('Error checking raid: $e');
      return {'success': false, 'raidOccurred': false};
    }
  }

  // ============================================================================
  // VIP EVENTS API (Phase 2)
  // ============================================================================

  Future<Map<String, dynamic>> getActiveEvents(String countryCode) async {
    try {
      final response = await _apiClient.get('/vip-events/active/$countryCode');
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return {'success': false, 'events': []};
    } catch (e) {
      print('Error loading active events: $e');
      return {'success': false, 'message': 'Error: $e', 'events': []};
    }
  }

  Future<Map<String, dynamic>> getUpcomingEvents({String? countryCode}) async {
    try {
      final url = countryCode != null
          ? '/vip-events/upcoming?countryCode=$countryCode'
          : '/vip-events/upcoming';
      final response = await _apiClient.get(url);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return {'success': false, 'events': []};
    } catch (e) {
      print('Error loading upcoming events: $e');
      return {'success': false, 'message': 'Error: $e', 'events': []};
    }
  }

  Future<Map<String, dynamic>> getEventById(int eventId) async {
    try {
      final response = await _apiClient.get('/vip-events/$eventId');
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return {'success': false};
    } catch (e) {
      print('Error loading event details: $e');
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  Future<Map<String, dynamic>> participateInEvent(
    int eventId,
    int prostituteId,
  ) async {
    try {
      final response = await _apiClient.post(
        '/vip-events/$eventId/participate',
        {'prostituteId': prostituteId},
      );
      return json.decode(response.body);
    } catch (e) {
      print('Error participating in event: $e');
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  Future<Map<String, dynamic>> leaveEvent(int eventId, int prostituteId) async {
    try {
      final response = await _apiClient.post('/vip-events/$eventId/leave', {
        'prostituteId': prostituteId,
      });
      return json.decode(response.body);
    } catch (e) {
      print('Error leaving event: $e');
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  Future<Map<String, dynamic>> getMyParticipations() async {
    try {
      final response = await _apiClient.get('/vip-events/my/participations');
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return {'success': false, 'participations': []};
    } catch (e) {
      print('Error loading participations: $e');
      return {'success': false, 'message': 'Error: $e', 'participations': []};
    }
  }

  // ============================================================================
  // LEADERBOARDS API (Phase 2 - Week 2)
  // ============================================================================

  Future<Map<String, dynamic>> getLeaderboard(
    String period, {
    int limit = 20,
  }) async {
    try {
      final response = await _apiClient.get(
        '/leaderboards/$period?limit=$limit',
      );
      if (response.statusCode == 200) {
        return _normalizeLeaderboardResponse(json.decode(response.body));
      }
      return {'success': false, 'leaderboard': []};
    } catch (e) {
      print('Error loading leaderboard: $e');
      return {'success': false, 'message': 'Error: $e', 'leaderboard': []};
    }
  }

  Future<Map<String, dynamic>> getMyRank(String period) async {
    try {
      final response = await _apiClient.get('/leaderboards/my-rank/$period');
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return {'success': false};
    } catch (e) {
      print('Error loading player rank: $e');
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  Future<Map<String, dynamic>> getAchievements() async {
    try {
      final response = await _apiClient.get('/leaderboards/achievements/list');
      if (response.statusCode == 200) {
        return _normalizeAchievementsResponse(json.decode(response.body));
      }
      return {'success': false, 'achievements': []};
    } catch (e) {
      print('Error loading achievements: $e');
      return {'success': false, 'message': 'Error: $e', 'achievements': []};
    }
  }

  // ============================================================================
  // RIVALRY API (Phase 2 - Week 3)
  // ============================================================================

  Future<Map<String, dynamic>> getActiveRivals() async {
    try {
      final response = await _apiClient.get('/rivalries/active');
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return {'success': false, 'rivals': []};
    } catch (e) {
      print('Error loading rivals: $e');
      return {'success': false, 'message': 'Error: $e', 'rivals': []};
    }
  }

  Future<Map<String, dynamic>> startRivalry(int rivalPlayerId) async {
    try {
      final response = await _apiClient.post('/rivalries/start', {
        'rivalPlayerId': rivalPlayerId,
      });
      return json.decode(response.body);
    } catch (e) {
      print('Error starting rivalry: $e');
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  Future<Map<String, dynamic>> executeSabotage(
    int victimId,
    String actionType,
  ) async {
    try {
      final response = await _apiClient.post('/rivalries/sabotage', {
        'victimId': victimId,
        'actionType': actionType,
      });
      final data = json.decode(response.body);

      // Parse achievements if present
      if (data['newlyUnlockedAchievements'] != null) {
        final newAchievements = (data['newlyUnlockedAchievements'] as List)
            .map((json) => Achievement.fromJson(json))
            .toList();
        data['newAchievements'] = newAchievements;
      }

      return data;
    } catch (e) {
      print('Error executing sabotage: $e');
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  Future<Map<String, dynamic>> getRivalryHistory({int limit = 20}) async {
    try {
      final response = await _apiClient.get('/rivalries/history?limit=$limit');
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return {'success': false, 'history': []};
    } catch (e) {
      print('Error loading rivalry history: $e');
      return {'success': false, 'message': 'Error: $e', 'history': []};
    }
  }

  Future<Map<String, dynamic>> getProtectionStatus() async {
    try {
      final response = await _apiClient.get('/rivalries/protection/status');
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return {'success': false};
    } catch (e) {
      print('Error loading protection status: $e');
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  Future<Map<String, dynamic>> buyProtectionInsurance() async {
    try {
      final response = await _apiClient.post('/rivalries/protection/buy', {});
      return json.decode(response.body);
    } catch (e) {
      print('Error buying protection insurance: $e');
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  // ============================================================================
  // ACHIEVEMENTS API (Phase 3 - Week 3)
  // ============================================================================

  /// Recruit a prostitute and automatically check for newly unlocked achievements
  /// Returns both recruitment result and any new achievements
  Future<Map<String, dynamic>> recruitWithAchievementCheck() async {
    final recruitResult = await recruitProstitute();

    if (recruitResult['success'] == true) {
      // Check for new achievements in background
      final achievementResult = await checkAchievements();

      return {
        ...recruitResult,
        'newAchievements': achievementResult['newlyUnlocked'] ?? [],
      };
    }

    return recruitResult;
  }

  Future<Map<String, dynamic>> getAchievementsProgress() async {
    try {
      final response = await _apiClient.get('/achievements');
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return {'success': false, 'achievements': []};
    } catch (e) {
      print('Error loading achievements: $e');
      return {'success': false, 'message': 'Error: $e', 'achievements': []};
    }
  }

  Future<Map<String, dynamic>> checkAchievements() async {
    try {
      final response = await _apiClient.post('/achievements/check', {});
      return json.decode(response.body);
    } catch (e) {
      print('Error checking achievements: $e');
      return {'success': false, 'message': 'Error: $e', 'newlyUnlocked': []};
    }
  }

  Future<Map<String, dynamic>> getAchievementDefinitions() async {
    try {
      final response = await _apiClient.get('/achievements/definitions');
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return {'success': false, 'achievements': []};
    } catch (e) {
      print('Error loading achievement definitions: $e');
      return {'success': false, 'message': 'Error: $e', 'achievements': []};
    }
  }
}
