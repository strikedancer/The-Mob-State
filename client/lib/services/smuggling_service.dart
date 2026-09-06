import 'dart:convert';

import './api_client.dart';

class SmugglingService {
  final ApiClient _apiClient = ApiClient();

  String _failureMessage(Map<String, dynamic> data, String fallback) {
    final message = data['message']?.toString();
    if (message != null && message.trim().isNotEmpty) return message;
    final params = data['params'];
    if (params is Map && params['reason'] != null) {
      return params['reason'].toString();
    }
    final event = data['event']?.toString();
    if (event != null && event.isNotEmpty) return event;
    final error = data['error']?.toString();
    if (error != null && error.isNotEmpty) return error;
    return fallback;
  }

  String _categoryForItem(String category, String itemKey) {
    if (itemKey.startsWith('contraband_')) return 'trade';
    return category;
  }

  Future<Map<String, dynamic>> getCatalog({String networkScope = 'personal'}) async {
    try {
      final response = await _apiClient.get('/smuggling/catalog?networkScope=$networkScope');
      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      }
      return {'success': false, 'categories': {}};
    } catch (e) {
      return {'success': false, 'categories': {}, 'message': 'Error: $e'};
    }
  }

  Future<Map<String, dynamic>> sendShipment({
    required String category,
    required String itemKey,
    required int quantity,
    required String destinationCountry,
    String channel = 'courier',
    String networkScope = 'personal',
    String transportMode = 'commercial',
    String? ownedTransportKey,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final response = await _apiClient.post('/smuggling/send', {
        'category': _categoryForItem(category, itemKey),
        'itemKey': itemKey,
        'quantity': quantity,
        'destinationCountry': destinationCountry,
        'channel': channel,
        'networkScope': networkScope,
        'transportMode': transportMode,
        'ownedTransportKey': ownedTransportKey,
        'metadata': metadata ?? {},
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body) as Map<String, dynamic>;
      }

      final data = json.decode(response.body) as Map<String, dynamic>;
      return {
        'success': false,
        'message': _failureMessage(data, 'Shipment failed'),
      };
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  Future<Map<String, dynamic>> getQuote({
    required String category,
    required String itemKey,
    required int quantity,
    required String destinationCountry,
    String channel = 'courier',
    String networkScope = 'personal',
    String transportMode = 'commercial',
    String? ownedTransportKey,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final response = await _apiClient.post('/smuggling/quote', {
        'category': _categoryForItem(category, itemKey),
        'itemKey': itemKey,
        'quantity': quantity,
        'destinationCountry': destinationCountry,
        'channel': channel,
        'networkScope': networkScope,
        'transportMode': transportMode,
        'ownedTransportKey': ownedTransportKey,
        'metadata': metadata ?? {},
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body) as Map<String, dynamic>;
      }

      final data = json.decode(response.body) as Map<String, dynamic>;
      return {
        'success': false,
        'message': _failureMessage(data, 'Quote failed'),
      };
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  Future<Map<String, dynamic>> getOverview() async {
    try {
      final response = await _apiClient.get('/smuggling/overview');
      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      }
      return {'success': false, 'shipments': [], 'depots': []};
    } catch (e) {
      return {'success': false, 'shipments': [], 'depots': []};
    }
  }

  Future<Map<String, dynamic>> claimCurrentDepot({String scope = 'personal'}) async {
    try {
      final response = await _apiClient.post('/smuggling/claim-current', {'scope': scope});
      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body) as Map<String, dynamic>;
      }

      final data = json.decode(response.body) as Map<String, dynamic>;
      return {
        'success': false,
        'message': data['message'] ?? 'Claim failed',
      };
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }
}
