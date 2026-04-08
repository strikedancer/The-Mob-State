import 'dart:convert';
import 'api_client.dart';

class JailService {
  final ApiClient _apiClient = ApiClient();

  /// Check if player is currently in jail
  /// Returns remaining SECONDS (not minutes!), or 0 if not jailed
  Future<int> checkJailStatus() async {
    try {
      final response = await _apiClient.get('/player/jail-status');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final jailed = data['jailed'] as bool? ?? false;
        final remainingTime = data['remainingTime'] as int? ?? 0; // This is SECONDS now
        
        return jailed ? remainingTime : 0;
      }
      
      return 0;
    } catch (e) {
      print('[JailService] Error checking jail status: $e');
      return 0;
    }
  }

  /// Parse jail error from API response
  /// Returns remaining SECONDS if jailed, null otherwise
  static int? parseJailError(Map<String, dynamic> responseData) {
    if (responseData['event'] == 'error.jailed') {
      final params = responseData['params'] as Map<String, dynamic>?;
      return params?['remainingTime'] as int? ?? 0; // This is SECONDS now
    }
    return null;
  }
}
