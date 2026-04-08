import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../config/app_config.dart';

class ApiClient {
  final http.Client _client;
  final FlutterSecureStorage _storage;
  static String? _tokenCache; // In-memory cache for web
  
  static const String _tokenKey = 'auth_token';

  ApiClient({
    http.Client? client,
    FlutterSecureStorage? storage,
  })  : _client = client ?? http.Client(),
        _storage = storage ?? const FlutterSecureStorage();

  Future<String?> getToken() async {
    try {
      // On web, use in-memory cache first
      if (kIsWeb && _tokenCache != null) {
        return _tokenCache;
      }
      
      // Try to read from storage
      final token = await _storage.read(key: _tokenKey);
      
      // Cache it if on web
      if (kIsWeb && token != null) {
        _tokenCache = token;
      }
      
      return token;
    } catch (e) {
      print('[ApiClient] Error reading token: $e');
      // Return cached token if storage fails
      if (kIsWeb && _tokenCache != null) {
        print('[ApiClient] Returning cached token after storage read error');
        return _tokenCache;
      }
      return null;
    }
  }

  Future<void> setToken(String token) async {
    try {
      // Always cache in memory (especially important for web)
      _tokenCache = token;
      
      // Try to persist to storage
      if (!kIsWeb) {
        // Only write to FlutterSecureStorage on mobile
        await _storage.write(key: _tokenKey, value: token);
      } else {
        // On web, try to store anyway but don't fail if it doesn't work
        try {
          await _storage.write(key: _tokenKey, value: token);
        } catch (e) {
          print('[ApiClient] Warning: Could not write to storage on web: $e');
          print('[ApiClient] Token is cached in memory, this is OK for web');
        }
      }
      print('[ApiClient] Token saved successfully');
    } catch (e) {
      print('[ApiClient] Error saving token: $e');
    }
  }

  Future<void> clearToken() async {
    try {
      // Clear cache
      _tokenCache = null;
      
      // Try to clear from storage
      await _storage.delete(key: _tokenKey);
      print('[ApiClient] Token cleared successfully');
    } catch (e) {
      print('[ApiClient] Error clearing token: $e');
    }
  }

  Future<Map<String, String>> _getHeaders({bool includeAuth = true}) async {
    final headers = {
      'Content-Type': 'application/json',
    };

    if (includeAuth) {
      final token = await getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  Future<http.Response> get(
    String endpoint, {
    bool includeAuth = true,
  }) async {
    final url = Uri.parse('${AppConfig.apiBaseUrl}$endpoint');
    final headers = await _getHeaders(includeAuth: includeAuth);

    print('[ApiClient] GET $url');

    try {
      final response = await _client
          .get(url, headers: headers)
          .timeout(AppConfig.apiTimeout);
      
      print('[ApiClient] GET Response status: ${response.statusCode}');
      
      return response;
    } catch (e) {
      print('[ApiClient] GET error: $e');
      rethrow;
    }
  }

  Future<http.Response> post(
    String endpoint,
    Map<String, dynamic> body, {
    bool includeAuth = true,
  }) async {
    final url = Uri.parse('${AppConfig.apiBaseUrl}$endpoint');
    final headers = await _getHeaders(includeAuth: includeAuth);

    print('[ApiClient] POST $url');
    print('[ApiClient] Headers: $headers');
    print('[ApiClient] Body: $body');

    try {
      final response = await _client
          .post(
            url,
            headers: headers,
            body: jsonEncode(body),
          )
          .timeout(AppConfig.apiTimeout);
      
      print('[ApiClient] Response status: ${response.statusCode}');
      print('[ApiClient] Response body: ${response.body}');
      
      return response;
    } catch (e) {
      print('[ApiClient] POST error: $e');
      rethrow;
    }
  }

  Future<http.Response> put(
    String endpoint,
    Map<String, dynamic> body, {
    bool includeAuth = true,
  }) async {
    final url = Uri.parse('${AppConfig.apiBaseUrl}$endpoint');
    final headers = await _getHeaders(includeAuth: includeAuth);

    try {
      return await _client
          .put(
            url,
            headers: headers,
            body: jsonEncode(body),
          )
          .timeout(AppConfig.apiTimeout);
    } catch (e) {
      rethrow;
    }
  }

  Future<http.Response> delete(
    String endpoint, {
    Map<String, dynamic>? body,
    bool includeAuth = true,
  }) async {
    final url = Uri.parse('${AppConfig.apiBaseUrl}$endpoint');
    final headers = await _getHeaders(includeAuth: includeAuth);

    try {
      return await _client
          .delete(
            url,
            headers: headers,
            body: body == null ? null : jsonEncode(body),
          )
          .timeout(AppConfig.apiTimeout);
    } catch (e) {
      rethrow;
    }
  }
}
