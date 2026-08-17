import 'dart:convert';

import 'api_client.dart';

class LaunderService {
  final ApiClient _api = ApiClient();

  Future<Map<String, dynamic>> getStatus() async {
    final response = await _api.get('/launder/status');
    final data = json.decode(response.body) as Map<String, dynamic>;
    if (response.statusCode == 200) {
      return {
        'success': true,
        ...(data['params'] as Map<String, dynamic>? ?? {}),
      };
    }
    return {'success': false, 'event': data['event']};
  }

  Future<Map<String, dynamic>> start(int amount) async {
    final response = await _api.post('/launder/start', {'amount': amount});
    final data = json.decode(response.body) as Map<String, dynamic>;
    if (response.statusCode == 200) {
      return {
        'success': true,
        ...(data['params'] as Map<String, dynamic>? ?? {}),
      };
    }
    return {
      'success': false,
      'event': data['event'],
      'params': data['params'] as Map<String, dynamic>? ?? const {},
    };
  }
}
