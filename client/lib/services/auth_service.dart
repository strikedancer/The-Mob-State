import 'dart:convert';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'api_client.dart';
import '../models/player.dart';
import 'notification_service.dart';

class AuthService {
  final ApiClient _apiClient;

  AuthService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  // Public getter for apiClient
  ApiClient get apiClient => _apiClient;

  /// Get device language code (en or nl)
  String _getDeviceLanguage() {
    final locale = ui.PlatformDispatcher.instance.locale;
    final languageCode = locale.languageCode.toLowerCase();
    // Only support 'nl' and 'en', default to 'en'
    return (languageCode == 'nl') ? 'nl' : 'en';
  }

  Future<AuthResult> login(String username, String password) async {
    try {
      final response = await _apiClient.post(
        '/auth/login',
        {
          'username': username,
          'password': password,
        },
        includeAuth: false,
      );

      print('[AuthService] Login response status: ${response.statusCode}');
      print('[AuthService] Login response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'] as String;
        final playerData = data['player'] as Map<String, dynamic>;
        
        print('[AuthService] Token: ${token.substring(0, 20)}...');
        print('[AuthService] Player data: $playerData');
        
        await _apiClient.setToken(token);
        
        try {
          final player = Player.fromJson(playerData);
          print('[AuthService] Player parsed successfully: ${player.username}');
          
          // Initialize push notifications
          try {
            if (!kIsWeb) {
              await NotificationService().initialize();
              print('✅ Push notifications initialized');
            } else {
              print('ℹ️ Web push permission is requested via explicit in-app prompt.');
            }
          } catch (e) {
            print('⚠️ Push notifications failed: $e');
            // Don't fail login if notifications fail
          }
          
          return AuthResult(
            success: true,
            player: player,
          );
        } catch (e) {
          print('[AuthService] Player parsing error: $e');
          return AuthResult(
            success: false,
            error: 'Failed to parse player data: $e',
          );
        }
      } else {
        final data = jsonDecode(response.body);
        
        // Handle event-based error responses
        String errorMessage = 'Login failed';
        if (data['event'] == 'auth.error' && data['params'] != null) {
          final reason = data['params']['reason'] as String?;
          if (reason == 'INVALID_CREDENTIALS') {
            errorMessage = 'Ongeldige gebruikersnaam of wachtwoord';
          } else if (reason == 'EMAIL_NOT_VERIFIED') {
            errorMessage =
                'Verifieer eerst je e-mailadres via de link in je e-mail.';
          } else if (reason == 'USERNAME_TAKEN') {
            errorMessage = 'Gebruikersnaam is al in gebruik';
          } else {
            errorMessage = reason ?? 'Login failed';
          }
        } else if (data['message'] != null) {
          errorMessage = data['message'];
        }
        
        return AuthResult(
          success: false,
          error: errorMessage,
        );
      }
    } catch (e) {
      print('[AuthService] Login exception: $e');
      return AuthResult(
        success: false,
        error: 'Connection error: $e',
      );
    }
  }

  Future<AuthResult> register(String username, String password, {String? email, String? language}) async {
    try {
      // Use provided language or detect device language
      final selectedLanguage = language ?? _getDeviceLanguage();
      
      final body = {
        'username': username,
        'password': password,
        'preferredLanguage': selectedLanguage,
      };
      if (email != null && email.isNotEmpty) {
        body['email'] = email;
      }
      
      final response = await _apiClient.post(
        '/auth/register',
        body,
        includeAuth: false,
      );

      print('[AuthService] Register response status: ${response.statusCode}');
      print('[AuthService] Register response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        if (data['requiresEmailVerification'] == true) {
          return AuthResult(
            success: true,
            requiresEmailVerification: true,
            error: 'Registratie gelukt! Controleer je e-mail om te verifiëren.',
          );
        }

        final token = data['token'] as String;
        final playerData = data['player'] as Map<String, dynamic>;
        
        print('[AuthService] Token: ${token.substring(0, 20)}...');
        print('[AuthService] Player data: $playerData');
        
        await _apiClient.setToken(token);
        
        try {
          final player = Player.fromJson(playerData);
          print('[AuthService] Player parsed successfully: ${player.username}');
          return AuthResult(
            success: true,
            player: player,
          );
        } catch (e) {
          print('[AuthService] Player parsing error: $e');
          return AuthResult(
            success: false,
            error: 'Failed to parse player data: $e',
          );
        }
      } else {
        final data = jsonDecode(response.body);
        
        // Handle event-based error responses
        String errorMessage = 'Registration failed';
        if (data['event'] == 'auth.error' && data['params'] != null) {
          final reason = data['params']['reason'] as String?;
          if (reason == 'USERNAME_TAKEN') {
            errorMessage = 'Deze gebruikersnaam is al in gebruik';
          } else if (reason == 'INVALID_CREDENTIALS') {
            errorMessage = 'Ongeldige gegevens';
          } else {
            errorMessage = reason ?? 'Registration failed';
          }
        } else if (data['message'] != null) {
          errorMessage = data['message'];
        }
        
        return AuthResult(
          success: false,
          error: errorMessage,
        );
      }
    } catch (e) {
      print('[AuthService] Register exception: $e');
      return AuthResult(
        success: false,
        error: 'Connection error: $e',
      );
    }
  }

  Future<void> logout() async {
    try {
      await NotificationService().unregisterCurrentToken();
    } catch (e) {
      print('[AuthService] Logout notification unregister failed: $e');
    }
    await _apiClient.clearToken();
  }

  Future<bool> isLoggedIn() async {
    final token = await _apiClient.getToken();
    return token != null && token.isNotEmpty;
  }

  Future<Player?> getCurrentPlayer() async {
    try {
      final response = await _apiClient.get('/player/me');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final playerData = data['player'] as Map<String, dynamic>;
        return Player.fromJson(playerData);
      }

      if (response.statusCode == 401 || response.statusCode == 403) {
        await _apiClient.clearToken();
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}

class AuthResult {
  final bool success;
  final Player? player;
  final bool requiresEmailVerification;
  final String? error;

  AuthResult({
    required this.success,
    this.player,
    this.requiresEmailVerification = false,
    this.error,
  });
}
