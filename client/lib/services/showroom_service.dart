import 'dart:convert';

import './api_client.dart';

class ShowroomService {
  final ApiClient _apiClient = ApiClient();

  Future<Map<String, dynamic>> getShowroom(int propertyId) async {
    try {
      final response = await _apiClient.get('/properties/$propertyId/showroom');
      return json.decode(response.body) as Map<String, dynamic>;
    } catch (e) {
      return {
        'event': 'showroom.load_failed',
        'params': {'reason': e.toString()},
      };
    }
  }

  Future<Map<String, dynamic>> placeVehicle({
    required int propertyId,
    required int vehicleInventoryId,
  }) async {
    try {
      final response = await _apiClient.post(
        '/properties/$propertyId/showroom/place',
        {'vehicleInventoryId': vehicleInventoryId},
      );
      return json.decode(response.body) as Map<String, dynamic>;
    } catch (e) {
      return {
        'event': 'showroom.place_failed',
        'params': {'reason': e.toString()},
      };
    }
  }

  Future<Map<String, dynamic>> removeVehicle({
    required int propertyId,
    required int vehicleInventoryId,
  }) async {
    try {
      final response = await _apiClient.post(
        '/properties/$propertyId/showroom/remove',
        {'vehicleInventoryId': vehicleInventoryId},
      );
      return json.decode(response.body) as Map<String, dynamic>;
    } catch (e) {
      return {
        'event': 'showroom.remove_failed',
        'params': {'reason': e.toString()},
      };
    }
  }
}
