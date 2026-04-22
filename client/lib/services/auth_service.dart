import 'dart:convert';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'api_client.dart';
import '../models/player.dart';
import 'notification_service.dart';

class AuthSessionException implements Exception {
  final String reason;
  final bool unauthorized;
  final int? statusCode;

  const AuthSessionException({
    required this.reason,
    required this.unauthorized,
    this.statusCode,
  });

  @override
  String toString() => 'AuthSessionException(reason: $reason, unauthorized: $unauthorized, statusCode: $statusCode)';
}

class AuthService {
  final ApiClient _apiClient;
  static const Set<String> _terminalAuthReasons = {
    'MISSING_TOKEN',
    'INVALID_TOKEN',
    'TOKEN_EXPIRED',
    'SESSION_REPLACED',
    'PLAYER_NOT_FOUND',
  };

  AuthService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  // Public getter for apiClient
  ApiClient get apiClient => _apiClient;

  Future<void> clearStoredSession() async {
    await _apiClient.clearToken();
  }

  /// Get device language code (en or nl)
  String _getDeviceLanguage() {
    final locale = ui.PlatformDispatcher.instance.locale;
    final languageCode = locale.languageCode.toLowerCase();
    // Only support 'nl' and 'en', default to 'en'
    return (languageCode == 'nl') ? 'nl' : 'en';
  }

  Future<AuthResult> login(String username, String password) async {
    try {
      final response = await _apiClient.post('/auth/login', {
        'username': username,
        'password': password,
      }, includeAuth: false);

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
              await NotificationService().syncAuthorizedSession();
              print('ℹ️ Web push session synchronized after login.');
            }
          } catch (e) {
            print('⚠️ Push notifications failed: $e');
            // Don't fail login if notifications fail
          }

          return AuthResult(success: true, player: player);
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

        return AuthResult(success: false, error: errorMessage);
      }
    } catch (e) {
      print('[AuthService] Login exception: $e');
      return AuthResult(success: false, error: 'Connection error: $e');
    }
  }

  Future<AuthResult> register(
    String username,
    String password, {
    String? email,
    String? language,
  }) async {
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
          try {
            if (kIsWeb) {
              await NotificationService().syncAuthorizedSession();
              print('ℹ️ Web push session synchronized after registration.');
            }
          } catch (e) {
            print('⚠️ Push notifications failed after registration: $e');
          }
          return AuthResult(success: true, player: player);
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

        return AuthResult(success: false, error: errorMessage);
      }
    } catch (e) {
      print('[AuthService] Register exception: $e');
      return AuthResult(success: false, error: 'Connection error: $e');
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

      if (response.statusCode == 401) {
        final reason = _extractAuthReason(response.body);
        throw AuthSessionException(
          reason: reason,
          unauthorized: _isTerminalAuthReason(reason),
          statusCode: response.statusCode,
        );
      }

      if (response.statusCode == 403) {
        throw AuthSessionException(
          reason: _extractAuthReason(response.body),
          unauthorized: false,
          statusCode: response.statusCode,
        );
      }

      throw AuthSessionException(
        reason: 'PLAYER_FETCH_FAILED_${response.statusCode}',
        unauthorized: false,
        statusCode: response.statusCode,
      );
    } catch (e) {
      if (e is AuthSessionException) {
        rethrow;
      }

      throw AuthSessionException(
        reason: 'PLAYER_FETCH_ERROR',
        unauthorized: false,
      );
    }
  }

  String _extractAuthReason(String rawBody) {
    try {
      final data = jsonDecode(rawBody) as Map<String, dynamic>;
      if (data['event'] == 'auth.unauthorized') {
        final params = data['params'];
        if (params is Map<String, dynamic>) {
          final reason = params['reason']?.toString();
          if (reason != null && reason.isNotEmpty) {
            return reason;
          }
        }
      }

      final message = data['message']?.toString();
      if (message != null && message.isNotEmpty) {
        return message;
      }
    } catch (_) {
      // Ignore parse failures and fall back to generic auth reason.
    }

    return 'UNAUTHORIZED';
  }

  bool _isTerminalAuthReason(String reason) {
    return _terminalAuthReasons.contains(reason);
  }

  Future<void> requestPasswordReset(String email) async {
    try {
      final response = await _apiClient.post('/auth/request-password-reset', {
        'email': email,
      }, includeAuth: false);

      if (response.statusCode == 200) {
        return;
      }

      final data = jsonDecode(response.body);
      final reason = data['params'] is Map<String, dynamic>
          ? data['params']['reason'] as String?
          : null;

      throw Exception(reason ?? 'REQUEST_PASSWORD_RESET_FAILED');
    } catch (e) {
      print('[AuthService] Request password reset exception: $e');
      rethrow;
    }
  }

  Future<void> resetPassword(String token, String newPassword) async {
    try {
      final response = await _apiClient.post('/auth/reset-password', {
        'token': token,
        'newPassword': newPassword,
      }, includeAuth: false);

      if (response.statusCode == 200) {
        return;
      }

      final data = jsonDecode(response.body);
      final reason = data['params'] is Map<String, dynamic>
          ? data['params']['reason'] as String?
          : null;

      throw Exception(reason ?? 'RESET_PASSWORD_FAILED');
    } catch (e) {
      print('[AuthService] Reset password exception: $e');
      rethrow;
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
