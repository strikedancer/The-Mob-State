import 'dart:convert';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'api_client.dart';
import '../config/supported_languages.dart';
import '../models/player.dart';
import 'notification_service.dart';
import '../utils/referral_invite_store.dart';

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

class FacebookAuthStatus {
  final bool loginEnabled;
  final bool pageEnabled;

  const FacebookAuthStatus({
    required this.loginEnabled,
    required this.pageEnabled,
  });
}

class GoogleAuthStatus {
  final bool loginEnabled;

  const GoogleAuthStatus({required this.loginEnabled});
}

class DiscordAuthStatus {
  final bool loginEnabled;

  const DiscordAuthStatus({required this.loginEnabled});
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

  /// Map device locale to a supported player language code.
  String _getDeviceLanguage() {
    final locale = ui.PlatformDispatcher.instance.locale;
    return SupportedLanguages.resolveFromDeviceLanguage(
      locale.languageCode,
      fallbackCode: 'en',
    );
  }

  /// Push setup must never block login/register — FCM can hang on web.
  void _syncPushInBackground() {
    Future<void>(() async {
      try {
        if (!kIsWeb) {
          await NotificationService().initialize();
          print('✅ Push notifications initialized');
        } else {
          await NotificationService().syncAuthorizedSession();
          print('ℹ️ Web push session synchronized after auth.');
        }
      } catch (e) {
        print('⚠️ Push notifications failed: $e');
      }
    });
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

          _syncPushInBackground();
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
            errorMessage = 'EMAIL_NOT_VERIFIED';
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
    required String gender,
    String? email,
    String? language,
  }) async {
    try {
      // Use provided language or detect device language
      final selectedLanguage = language ?? _getDeviceLanguage();

      final body = <String, dynamic>{
        'username': username,
        'password': password,
        'preferredLanguage': selectedLanguage,
        'gender': gender,
      };
      if (email != null && email.isNotEmpty) {
        body['email'] = email;
      }
      final referralCode = await ReferralInviteStore.peek();
      if (referralCode != null) {
        body['referralCode'] = referralCode;
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
          await ReferralInviteStore.clear();
          return AuthResult(
            success: true,
            requiresEmailVerification: true,
            error: 'EMAIL_VERIFICATION_REQUIRED',
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
          await ReferralInviteStore.clear();
          _syncPushInBackground();
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
          } else if (reason == 'GENDER_REQUIRED') {
            errorMessage = 'GENDER_REQUIRED';
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

  Future<FacebookAuthStatus> facebookStatus() async {
    try {
      final response = await _apiClient.get(
        '/auth/facebook/status',
        includeAuth: false,
      );
      if (response.statusCode != 200) {
        return const FacebookAuthStatus(loginEnabled: false, pageEnabled: false);
      }
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final params = data['params'] is Map<String, dynamic>
          ? data['params'] as Map<String, dynamic>
          : data;
      return FacebookAuthStatus(
        loginEnabled: params['loginEnabled'] == true,
        pageEnabled: params['pageEnabled'] == true,
      );
    } catch (e) {
      print('[AuthService] Facebook status exception: $e');
      return const FacebookAuthStatus(loginEnabled: false, pageEnabled: false);
    }
  }

  Future<GoogleAuthStatus> googleStatus() async {
    try {
      final response = await _apiClient.get(
        '/auth/google/status',
        includeAuth: false,
      );
      if (response.statusCode != 200) {
        return const GoogleAuthStatus(loginEnabled: false);
      }
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final params = data['params'] is Map<String, dynamic>
          ? data['params'] as Map<String, dynamic>
          : data;
      return GoogleAuthStatus(loginEnabled: params['loginEnabled'] == true);
    } catch (e) {
      print('[AuthService] Google status exception: $e');
      return const GoogleAuthStatus(loginEnabled: false);
    }
  }

  Future<DiscordAuthStatus> discordStatus() async {
    try {
      final response = await _apiClient.get(
        '/auth/discord/status',
        includeAuth: false,
      );
      if (response.statusCode != 200) {
        return const DiscordAuthStatus(loginEnabled: false);
      }
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final params = data['params'] is Map<String, dynamic>
          ? data['params'] as Map<String, dynamic>
          : data;
      return DiscordAuthStatus(loginEnabled: params['loginEnabled'] == true);
    } catch (e) {
      print('[AuthService] Discord status exception: $e');
      return const DiscordAuthStatus(loginEnabled: false);
    }
  }

  Future<String?> discordLinkStartUrl() async {
    try {
      final response = await _apiClient.get('/auth/discord/link/start');
      if (response.statusCode != 200) return null;
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final params = data['params'] is Map<String, dynamic>
          ? data['params'] as Map<String, dynamic>
          : data;
      final url = params['url']?.toString().trim() ?? '';
      return url.isEmpty ? null : url;
    } catch (e) {
      print('[AuthService] Discord link start exception: $e');
      return null;
    }
  }

  Future<({bool show, int rewardCash})> discordPromptStatus() async {
    try {
      final response = await _apiClient.get('/auth/discord/prompt');
      if (response.statusCode != 200) {
        return (show: false, rewardCash: 0);
      }
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final params = data['params'] is Map<String, dynamic>
          ? data['params'] as Map<String, dynamic>
          : data;
      final reward = params['rewardCash'];
      return (
        show: params['show'] == true,
        rewardCash: reward is num ? reward.toInt() : 0,
      );
    } catch (e) {
      print('[AuthService] Discord prompt status exception: $e');
      return (show: false, rewardCash: 0);
    }
  }

  Future<void> discordPromptSeen() async {
    try {
      await _apiClient.post('/auth/discord/prompt/seen', {});
    } catch (e) {
      print('[AuthService] Discord prompt seen exception: $e');
    }
  }

  Future<void> discordPromptDecline() async {
    try {
      await _apiClient.post('/auth/discord/prompt/decline', {});
    } catch (e) {
      print('[AuthService] Discord prompt decline exception: $e');
    }
  }

  Future<String?> unlinkDiscord() async {
    try {
      final response = await _apiClient.delete('/auth/discord/link');
      if (response.statusCode == 200) return null;
      final data = jsonDecode(response.body);
      if (data is Map<String, dynamic>) {
        final params = data['params'];
        if (params is Map<String, dynamic> && params['reason'] != null) {
          return params['reason'].toString();
        }
      }
      return 'DISCORD_AUTH_FAILED';
    } catch (e) {
      print('[AuthService] Discord unlink exception: $e');
      return 'DISCORD_AUTH_FAILED';
    }
  }

  Future<AuthResult> loginWithToken(
    String token, {
    String fallbackError = 'FACEBOOK_AUTH_FAILED',
  }) async {
    try {
      await _apiClient.setToken(token);
      final player = await getCurrentPlayer();
      if (player == null) {
        await _apiClient.clearToken();
        return AuthResult(success: false, error: fallbackError);
      }
      _syncPushInBackground();
      return AuthResult(success: true, player: player);
    } catch (e) {
      print('[AuthService] Social token login exception: $e');
      await _apiClient.clearToken();
      return AuthResult(success: false, error: fallbackError);
    }
  }

  Future<AuthResult> completeFacebook({
    required String pendingToken,
    required String username,
    required String gender,
    required bool acceptedTerms,
    String? language,
  }) async {
    try {
      final selectedLanguage = language ?? _getDeviceLanguage();
      final body = <String, dynamic>{
        'pendingToken': pendingToken,
        'username': username,
        'gender': gender,
        'preferredLanguage': selectedLanguage,
        'acceptedTerms': acceptedTerms,
      };
      final referralCode = await ReferralInviteStore.peek();
      if (referralCode != null) {
        body['referralCode'] = referralCode;
      }
      final response = await _apiClient.post(
        '/auth/facebook/complete',
        body,
        includeAuth: false,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final token = data['token'] as String;
        final playerData = data['player'] as Map<String, dynamic>;
        await _apiClient.setToken(token);
        try {
          final player = Player.fromJson(playerData);
          await ReferralInviteStore.clear();
          _syncPushInBackground();
          return AuthResult(success: true, player: player);
        } catch (e) {
          return AuthResult(
            success: false,
            error: 'Failed to parse player data: $e',
          );
        }
      }

      final data = jsonDecode(response.body);
      String errorMessage = 'FACEBOOK_AUTH_FAILED';
      if (data['event'] == 'auth.error' && data['params'] != null) {
        errorMessage = (data['params']['reason'] as String?) ?? errorMessage;
      }
      return AuthResult(success: false, error: errorMessage);
    } catch (e) {
      print('[AuthService] Facebook complete exception: $e');
      return AuthResult(success: false, error: 'Connection error: $e');
    }
  }

  Future<AuthResult> completeGoogle({
    required String pendingToken,
    required String username,
    required String gender,
    required bool acceptedTerms,
    String? language,
  }) async {
    try {
      final selectedLanguage = language ?? _getDeviceLanguage();
      final body = <String, dynamic>{
        'pendingToken': pendingToken,
        'username': username,
        'gender': gender,
        'preferredLanguage': selectedLanguage,
        'acceptedTerms': acceptedTerms,
      };
      final referralCode = await ReferralInviteStore.peek();
      if (referralCode != null) {
        body['referralCode'] = referralCode;
      }
      final response = await _apiClient.post(
        '/auth/google/complete',
        body,
        includeAuth: false,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final token = data['token'] as String;
        final playerData = data['player'] as Map<String, dynamic>;
        await _apiClient.setToken(token);
        try {
          final player = Player.fromJson(playerData);
          await ReferralInviteStore.clear();
          _syncPushInBackground();
          return AuthResult(success: true, player: player);
        } catch (e) {
          return AuthResult(
            success: false,
            error: 'Failed to parse player data: $e',
          );
        }
      }

      final data = jsonDecode(response.body);
      String errorMessage = 'GOOGLE_AUTH_FAILED';
      if (data['event'] == 'auth.error' && data['params'] != null) {
        errorMessage = (data['params']['reason'] as String?) ?? errorMessage;
      }
      return AuthResult(success: false, error: errorMessage);
    } catch (e) {
      print('[AuthService] Google complete exception: $e');
      return AuthResult(success: false, error: 'Connection error: $e');
    }
  }

  Future<AuthResult> completeDiscord({
    required String pendingToken,
    required String username,
    required String gender,
    required bool acceptedTerms,
    String? language,
  }) async {
    try {
      final selectedLanguage = language ?? _getDeviceLanguage();
      final body = <String, dynamic>{
        'pendingToken': pendingToken,
        'username': username,
        'gender': gender,
        'preferredLanguage': selectedLanguage,
        'acceptedTerms': acceptedTerms,
      };
      final referralCode = await ReferralInviteStore.peek();
      if (referralCode != null) {
        body['referralCode'] = referralCode;
      }
      final response = await _apiClient.post(
        '/auth/discord/complete',
        body,
        includeAuth: false,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final token = data['token'] as String;
        final playerData = data['player'] as Map<String, dynamic>;
        await _apiClient.setToken(token);
        try {
          final player = Player.fromJson(playerData);
          await ReferralInviteStore.clear();
          _syncPushInBackground();
          return AuthResult(success: true, player: player);
        } catch (e) {
          return AuthResult(
            success: false,
            error: 'Failed to parse player data: $e',
          );
        }
      }

      final data = jsonDecode(response.body);
      String errorMessage = 'DISCORD_AUTH_FAILED';
      if (data['event'] == 'auth.error' && data['params'] != null) {
        errorMessage = (data['params']['reason'] as String?) ?? errorMessage;
      }
      return AuthResult(success: false, error: errorMessage);
    } catch (e) {
      print('[AuthService] Discord complete exception: $e');
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

  Future<AuthResult> resendVerification(String username, String password) async {
    try {
      final response = await _apiClient.post(
        '/auth/resend-verification',
        {
          'username': username,
          'password': password,
        },
        includeAuth: false,
      );
      if (response.statusCode == 200) {
        return AuthResult(success: true);
      }
      final data = jsonDecode(response.body);
      final reason = data['params'] is Map<String, dynamic>
          ? data['params']['reason'] as String?
          : null;
      return AuthResult(success: false, error: reason ?? 'EMAIL_SEND_FAILED');
    } catch (e) {
      return AuthResult(success: false, error: 'EMAIL_SEND_FAILED');
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
