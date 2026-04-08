import 'dart:convert';
import 'api_client.dart';
import '../models/loadout.dart';

class LoadoutService {
  final ApiClient _apiClient;

  LoadoutService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  // Get all player loadouts
  Future<Map<String, dynamic>> getLoadouts() async {
    try {
      final response = await _apiClient.get('/loadouts');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final loadouts = (data['loadouts'] as List)
            .map((loadout) => Loadout.fromJson(loadout))
            .toList();
        
        return {
          'success': true,
          'loadouts': loadouts,
        };
      } else {
        final error = json.decode(response.body);
        return {
          'success': false,
          'error': error['params']?['message'] ?? 'Failed to load loadouts',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Network error: $e',
      };
    }
  }

  // Get active loadout
  Future<Map<String, dynamic>> getActiveLoadout() async {
    try {
      final response = await _apiClient.get('/loadouts/active');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final loadout = data['loadout'] != null 
            ? Loadout.fromJson(data['loadout']) 
            : null;
        
        return {
          'success': true,
          'loadout': loadout,
        };
      } else if (response.statusCode == 404) {
        return {
          'success': true,
          'loadout': null,
        };
      } else {
        final error = json.decode(response.body);
        return {
          'success': false,
          'error': error['params']?['message'] ?? 'Failed to load active loadout',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Network error: $e',
      };
    }
  }

  // Create new loadout
  Future<Map<String, dynamic>> createLoadout({
    required String name,
    String? description,
    required List<String> toolIds,
  }) async {
    try {
      final response = await _apiClient.post(
        '/loadouts/create',
        {
          'name': name,
          'description': description,
          'toolIds': toolIds,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final loadout = Loadout.fromJson(data['loadout']);
        return {
          'success': true,
          'loadout': loadout,
        };
      } else {
        final error = json.decode(response.body);
        return {
          'success': false,
          'error': error['params']?['message'] ?? 'Failed to create loadout',
          'reason': error['params']?['reason'],
          'missingTools': error['params']?['missingTools'],
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Network error: $e',
      };
    }
  }

  // Update loadout
  Future<Map<String, dynamic>> updateLoadout({
    required int loadoutId,
    required String name,
    String? description,
    required List<String> toolIds,
  }) async {
    try {
      final response = await _apiClient.put(
        '/loadouts/$loadoutId',
        {
          'name': name,
          'description': description,
          'toolIds': toolIds,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final loadout = Loadout.fromJson(data['loadout']);
        return {
          'success': true,
          'loadout': loadout,
        };
      } else {
        final error = json.decode(response.body);
        return {
          'success': false,
          'error': error['params']?['message'] ?? 'Failed to update loadout',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Network error: $e',
      };
    }
  }

  // Delete loadout
  Future<Map<String, dynamic>> deleteLoadout(int loadoutId) async {
    try {
      final response = await _apiClient.delete('/loadouts/$loadoutId');

      if (response.statusCode == 200) {
        return {'success': true};
      } else {
        final error = json.decode(response.body);
        return {
          'success': false,
          'error': error['params']?['message'] ?? 'Failed to delete loadout',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Network error: $e',
      };
    }
  }

  // Equip loadout
  Future<Map<String, dynamic>> equipLoadout(int loadoutId) async {
    try {
      final response = await _apiClient.post('/loadouts/$loadoutId/equip', {});

      if (response.statusCode == 200) {
        return {'success': true};
      } else {
        final error = json.decode(response.body);
        return {
          'success': false,
          'error': error['params']?['message'] ?? 'Failed to equip loadout',
          'reason': error['params']?['reason'],
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Network error: $e',
      };
    }
  }
}
