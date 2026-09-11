import 'package:flutter/foundation.dart';
import '../models/player.dart';
import '../services/auth_service.dart';
import '../services/notification_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();

  Player? _currentPlayer;
  bool _isAuthenticated = false;
  /// True only while restoring a stored session (AuthWrapper splash).
  bool _isInitializing = true;
  /// True while login/register/Facebook submit is in flight (form spinner).
  bool _isSubmitting = false;
  String? _error;

  Player? get currentPlayer => _currentPlayer;
  bool get isAuthenticated => _isAuthenticated;
  bool get isInitializing => _isInitializing;
  bool get isSubmitting => _isSubmitting;
  bool get isLoading => _isInitializing || _isSubmitting;
  String? get error => _error;

  void clearError() {
    if (_error == null) {
      return;
    }

    _error = null;
    notifyListeners();
  }

  Future<void> checkAuthStatus() async {
    _isInitializing = true;
    notifyListeners();

    try {
      final isLoggedIn = await _authService.isLoggedIn();
      if (isLoggedIn) {
        try {
          _currentPlayer = await _authService.getCurrentPlayer();
          _isAuthenticated = _currentPlayer != null;
          if (_isAuthenticated) {
            NotificationService().syncAuthorizedSession().catchError((e) {
              debugPrint('[AuthProvider] Push session sync failed: $e');
              return false;
            });
          }
        } on AuthSessionException catch (e) {
          if (e.unauthorized) {
            await _authService.clearStoredSession();
            _isAuthenticated = false;
            _currentPlayer = null;
            _error = null;
          } else {
            _error = e.reason;
          }
        }
      } else {
        _isAuthenticated = false;
        _currentPlayer = null;
      }
    } catch (e) {
      _isAuthenticated = false;
      _currentPlayer = null;
      _error = e.toString();
    } finally {
      _isInitializing = false;
      notifyListeners();
    }
  }

  Future<bool> login(String username, String password) async {
    print('[AuthProvider] Starting login for: $username');
    _isSubmitting = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _authService.login(username, password);
      print(
        '[AuthProvider] Login result: success=${result.success}, player=${result.player?.username}',
      );

      if (result.success && result.player != null) {
        _currentPlayer = result.player;
        _isAuthenticated = true;
        _error = null;
        print('[AuthProvider] ✅ Login successful!');
        print('[AuthProvider]    isAuthenticated: $_isAuthenticated');
        print('[AuthProvider]    currentPlayer: ${_currentPlayer?.username}');
        return true;
      }

      _error = result.error;
      _isAuthenticated = false;
      _currentPlayer = null;
      print('[AuthProvider] ❌ Login failed: ${result.error}');
      return false;
    } catch (e) {
      _error = e.toString();
      _isAuthenticated = false;
      _currentPlayer = null;
      print('[AuthProvider] ❌ Login exception: $e');
      return false;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  Future<bool> register(
    String username,
    String password, {
    required String gender,
    String? email,
    String? language,
  }) async {
    print('[AuthProvider] Starting registration for: $username');
    _isSubmitting = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _authService.register(
        username,
        password,
        gender: gender,
        email: email,
        language: language,
      );
      print(
        '[AuthProvider] Register result: success=${result.success}, player=${result.player?.username}',
      );

      if (result.success && result.player != null) {
        _currentPlayer = result.player;
        _isAuthenticated = true;
        _error = null;
        print(
          '[AuthProvider] Registration successful! isAuthenticated=$_isAuthenticated',
        );
        return true;
      }
      if (result.success && result.requiresEmailVerification) {
        _currentPlayer = null;
        _isAuthenticated = false;
        _error = result.error;
        print(
          '[AuthProvider] Registration successful, email verification required',
        );
        return true;
      }

      _error = result.error;
      _isAuthenticated = false;
      _currentPlayer = null;
      print('[AuthProvider] Registration failed: ${result.error}');
      return false;
    } catch (e) {
      _error = e.toString();
      _isAuthenticated = false;
      _currentPlayer = null;
      print('[AuthProvider] Registration exception: $e');
      return false;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  Future<bool> loginWithToken(String token) async {
    _isSubmitting = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _authService.loginWithToken(token);
      if (result.success && result.player != null) {
        _currentPlayer = result.player;
        _isAuthenticated = true;
        _error = null;
        return true;
      }
      _error = result.error;
      _isAuthenticated = false;
      _currentPlayer = null;
      return false;
    } catch (e) {
      _error = e.toString();
      _isAuthenticated = false;
      _currentPlayer = null;
      return false;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  Future<bool> completeFacebook({
    required String pendingToken,
    required String username,
    required String gender,
    required bool acceptedTerms,
    String? language,
  }) async {
    _isSubmitting = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _authService.completeFacebook(
        pendingToken: pendingToken,
        username: username,
        gender: gender,
        acceptedTerms: acceptedTerms,
        language: language,
      );
      if (result.success && result.player != null) {
        _currentPlayer = result.player;
        _isAuthenticated = true;
        _error = null;
        return true;
      }
      _error = result.error;
      _isAuthenticated = false;
      _currentPlayer = null;
      return false;
    } catch (e) {
      _error = e.toString();
      _isAuthenticated = false;
      _currentPlayer = null;
      return false;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    _currentPlayer = null;
    _isAuthenticated = false;
    _error = null;
    notifyListeners();
  }

  Future<void> refreshPlayer() async {
    try {
      final refreshedPlayer = await _authService.getCurrentPlayer();
      _currentPlayer = refreshedPlayer;
      _isAuthenticated = refreshedPlayer != null;
      if (_isAuthenticated) {
        _error = null;
      }
      notifyListeners();
    } on AuthSessionException catch (e) {
      if (e.unauthorized) {
        await _authService.clearStoredSession();
        _currentPlayer = null;
        _isAuthenticated = false;
        _error = null;
        notifyListeners();
        return;
      }

      _error = e.reason;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Update specific player fields (useful after actions like crimes, jobs, etc.)
  void updatePlayerStats({
    int? money,
    int? xp,
    int? rank,
    int? health,
    int? wantedLevel,
    int? fbiHeat,
    String? currentCountry,
  }) {
    if (_currentPlayer == null) return;

    _currentPlayer = Player(
      id: _currentPlayer!.id,
      username: _currentPlayer!.username,
      money: money ?? _currentPlayer!.money,
      health: health ?? _currentPlayer!.health,
      rank: rank ?? _currentPlayer!.rank,
      xp: xp ?? _currentPlayer!.xp,
      wantedLevel: wantedLevel ?? _currentPlayer!.wantedLevel,
      fbiHeat: fbiHeat ?? _currentPlayer!.fbiHeat,
      currentCountry: currentCountry ?? _currentPlayer!.currentCountry,
      avatar: _currentPlayer!.avatar,
      activePortraitId: _currentPlayer!.activePortraitId,
      activePortraitPath: _currentPlayer!.activePortraitPath,
      premiumCredits: _currentPlayer!.premiumCredits,
      gender: _currentPlayer!.gender,
      isVip: _currentPlayer!.isVip,
      preferredLanguage: _currentPlayer!.preferredLanguage,
      wealthStatus: _currentPlayer!.wealthStatus,
      wealthIcon: _currentPlayer!.wealthIcon,
      createdAt: _currentPlayer!.createdAt,
      updatedAt: _currentPlayer!.updatedAt,
      lastTickAt: _currentPlayer!.lastTickAt,
    );

    notifyListeners();
  }
}
