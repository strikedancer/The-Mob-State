import 'dart:convert';
import 'api_client.dart';
import '../models/carried_tool.dart';
import '../models/storage_info.dart';

class InventoryService {
  final ApiClient _apiClient;

  InventoryService({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  // Get carried inventory
  Future<Map<String, dynamic>> getCarriedTools() async {
    try {
      final response = await _apiClient.get('/tools/carried');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final tools = (data['tools'] as List)
            .map((tool) => CarriedTool.fromJson(tool))
            .toList();
        final slots = InventorySlots.fromJson(data['params']);

        return {'success': true, 'tools': tools, 'slots': slots};
      } else {
        final error = json.decode(response.body);
        return {
          'success': false,
          'error': error['params']?['message'] ?? 'Failed to load inventory',
        };
      }
    } catch (e) {
      return {'success': false, 'error': 'Network error: $e'};
    }
  }

  // Get property storage
  Future<Map<String, dynamic>> getPropertyStorage(int propertyId) async {
    try {
      final response = await _apiClient.get('/tools/storage/$propertyId');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final tools = (data['tools'] as List)
            .map((tool) => CarriedTool.fromJson(tool))
            .toList();

        return {
          'success': true,
          'tools': tools,
          'propertyId': data['params']['propertyId'],
          'propertyType': data['params']['propertyType'],
          'usage': data['params']['usage'],
          'capacity': data['params']['capacity'],
          'percentFull': data['params']['percentFull'],
        };
      } else if (response.statusCode == 404) {
        return {'success': false, 'error': 'Property not found or not owned'};
      } else {
        final error = json.decode(response.body);
        return {
          'success': false,
          'error': error['params']?['message'] ?? 'Failed to load storage',
        };
      }
    } catch (e) {
      return {'success': false, 'error': 'Network error: $e'};
    }
  }

  // Get storage overview (all properties)
  Future<Map<String, dynamic>> getStorageOverview() async {
    try {
      final response = await _apiClient.get('/properties/storage-overview');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final storageList = (data['storage'] as List)
            .map((storage) => StorageInfo.fromJson(storage))
            .toList();

        return {'success': true, 'storage': storageList};
      } else {
        final error = json.decode(response.body);
        return {
          'success': false,
          'error':
              error['params']?['message'] ?? 'Failed to load storage overview',
        };
      }
    } catch (e) {
      return {'success': false, 'error': 'Network error: $e'};
    }
  }

  Future<Map<String, dynamic>> getPropertyStorageDetail(int propertyId) async {
    try {
      final response = await _apiClient.get('/properties/storage/$propertyId');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'success': true,
          'storage': data['storage'] as Map<String, dynamic>,
        };
      }

      final error = json.decode(response.body);
      return {
        'success': false,
        'error':
            error['params']?['reason'] ?? 'Failed to load property storage',
      };
    } catch (e) {
      return {'success': false, 'error': 'Network error: $e'};
    }
  }

  Future<Map<String, dynamic>> depositWeaponToProperty({
    required int propertyId,
    required String weaponId,
    required int quantity,
  }) async {
    try {
      final response = await _apiClient.post(
        '/properties/storage/$propertyId/weapons/deposit',
        {'weaponId': weaponId, 'quantity': quantity},
      );

      if (response.statusCode == 200) {
        return {'success': true};
      }

      final error = json.decode(response.body);
      return {
        'success': false,
        'error': error['params']?['reason'] ?? 'Failed to deposit weapon',
      };
    } catch (e) {
      return {'success': false, 'error': 'Network error: $e'};
    }
  }

  Future<Map<String, dynamic>> withdrawWeaponFromProperty({
    required int propertyId,
    required String weaponId,
    required int quantity,
  }) async {
    try {
      final response = await _apiClient.post(
        '/properties/storage/$propertyId/weapons/withdraw',
        {'weaponId': weaponId, 'quantity': quantity},
      );

      if (response.statusCode == 200) {
        return {'success': true};
      }

      final error = json.decode(response.body);
      return {
        'success': false,
        'error': error['params']?['reason'] ?? 'Failed to withdraw weapon',
      };
    } catch (e) {
      return {'success': false, 'error': 'Network error: $e'};
    }
  }

  Future<Map<String, dynamic>> depositCashToProperty({
    required int propertyId,
    required int amount,
  }) async {
    try {
      final response = await _apiClient.post(
        '/properties/storage/$propertyId/cash/deposit',
        {'amount': amount},
      );

      if (response.statusCode == 200) {
        return {'success': true};
      }

      final error = json.decode(response.body);
      return {
        'success': false,
        'error': error['params']?['reason'] ?? 'Failed to deposit cash',
      };
    } catch (e) {
      return {'success': false, 'error': 'Network error: $e'};
    }
  }

  Future<Map<String, dynamic>> withdrawCashFromProperty({
    required int propertyId,
    required int amount,
  }) async {
    try {
      final response = await _apiClient.post(
        '/properties/storage/$propertyId/cash/withdraw',
        {'amount': amount},
      );

      if (response.statusCode == 200) {
        return {'success': true};
      }

      final error = json.decode(response.body);
      return {
        'success': false,
        'error': error['params']?['reason'] ?? 'Failed to withdraw cash',
      };
    } catch (e) {
      return {'success': false, 'error': 'Network error: $e'};
    }
  }

  Future<Map<String, dynamic>> withdrawDrugsFromProperty({
    required int propertyId,
    required String drugType,
    required int quantity,
  }) async {
    try {
      final response = await _apiClient.post('/drugs/retrieve', {
        'propertyId': propertyId,
        'drugType': drugType,
        'quantity': quantity,
      });

      if (response.statusCode == 200) {
        return {'success': true};
      }

      final error = json.decode(response.body);
      return {
        'success': false,
        'error': error['message'] ?? 'Failed to retrieve drugs',
      };
    } catch (e) {
      return {'success': false, 'error': 'Network error: $e'};
    }
  }

  // Transfer tool between locations
  Future<Map<String, dynamic>> transferTool({
    required String toolId,
    required String fromLocation,
    required String toLocation,
    int quantity = 1,
  }) async {
    try {
      final response = await _apiClient.post('/tools/transfer', {
        'toolId': toolId,
        'fromLocation': fromLocation,
        'toLocation': toLocation,
        'quantity': quantity,
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'success': true,
          'event': data['event'],
          'params': data['params'],
        };
      } else {
        final error = json.decode(response.body);
        return {
          'success': false,
          'error': error['params']?['message'] ?? 'Transfer failed',
          'reason': error['params']?['reason'],
        };
      }
    } catch (e) {
      return {'success': false, 'error': 'Network error: $e'};
    }
  }
}
