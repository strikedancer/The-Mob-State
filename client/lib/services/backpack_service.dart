import 'dart:convert';
import '../models/backpack.dart';
import 'api_client.dart';

class BackpackService {
  final ApiClient _apiClient;

  BackpackService(this._apiClient);

  /// Get all backpacks (catalog)
  Future<List<Backpack>> getAllBackpacks() async {
    final response = await _apiClient.get('/backpacks/all');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['backpacks'] as List)
          .map((json) => Backpack.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load backpacks');
    }
  }

  /// Get player's current backpack
  Future<Backpack?> getMyBackpack() async {
    final response = await _apiClient.get('/backpacks/mine');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['backpack'] != null) {
        return Backpack.fromJson(data['backpack']);
      }
      return null;
    } else {
      throw Exception('Failed to load backpack');
    }
  }

  /// Get backpacks available for purchase/upgrade
  Future<AvailableBackpacksResponse> getAvailableBackpacks() async {
    final response = await _apiClient.get('/backpacks/available');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return AvailableBackpacksResponse.fromJson(data);
    } else {
      throw Exception('Failed to load available backpacks');
    }
  }

  /// Get player's total carrying capacity
  Future<BackpackCapacity> getCarryingCapacity() async {
    final response = await _apiClient.get('/backpacks/capacity');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return BackpackCapacity.fromJson(data);
    } else {
      throw Exception('Failed to load capacity');
    }
  }

  /// Purchase a backpack
  Future<Map<String, dynamic>> purchaseBackpack(String backpackId) async {
    final response = await _apiClient.post('/backpacks/purchase/$backpackId', {});

    final data = jsonDecode(response.body);
    
    if (response.statusCode == 200) {
      return {
        'success': true,
        'event': data['event'],
        'params': data['params'],
        'backpack': data['backpack'] != null ? Backpack.fromJson(data['backpack']) : null,
      };
    } else {
      return {
        'success': false,
        'event': data['event'],
        'params': data['params'],
      };
    }
  }

  /// Upgrade to a better backpack
  Future<Map<String, dynamic>> upgradeBackpack(String backpackId) async {
    final response = await _apiClient.post('/backpacks/upgrade/$backpackId', {});

    final data = jsonDecode(response.body);
    
    if (response.statusCode == 200) {
      return {
        'success': true,
        'event': data['event'],
        'params': data['params'],
        'backpack': data['backpack'] != null ? Backpack.fromJson(data['backpack']) : null,
      };
    } else {
      return {
        'success': false,
        'event': data['event'],
        'params': data['params'],
      };
    }
  }
}
