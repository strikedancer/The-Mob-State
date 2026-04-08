import 'package:flutter/foundation.dart';
import '../models/player.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();

  Player? _currentPlayer;
  bool _isAuthenticated = false;
  bool _isLoading = true;
  String? _error;

  Player? get currentPlayer => _currentPlayer;
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void clearError() {
    if (_error == null) {
      return;
    }

    _error = null;
    notifyListeners();
  }

  Future<void> checkAuthStatus() async {
    _isLoading = true;
    notifyListeners();

    try {
      final isLoggedIn = await _authService.isLoggedIn();
      if (isLoggedIn) {
        _currentPlayer = await _authService.getCurrentPlayer();
        _isAuthenticated = _currentPlayer != null;
      } else {
        _isAuthenticated = false;
        _currentPlayer = null;
      }
    } catch (e) {
      _isAuthenticated = false;
      _currentPlayer = null;
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> login(String username, String password) async {
    print('[AuthProvider] Starting login for: $username');
    _isLoading = true;
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
        _isLoading = false;
        print('[AuthProvider] ✅ Login successful!');
        print('[AuthProvider]    isAuthenticated: $_isAuthenticated');
        print('[AuthProvider]    currentPlayer: ${_currentPlayer?.username}');
        print('[AuthProvider]    Calling notifyListeners()...');
        notifyListeners();
        print('[AuthProvider]    notifyListeners() called!');
        return true;
      } else {
        _error = result.error;
        _isAuthenticated = false;
        _currentPlayer = null;
        _isLoading = false;
        print('[AuthProvider] ❌ Login failed: ${result.error}');
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = e.toString();
      _isAuthenticated = false;
      _currentPlayer = null;
      _isLoading = false;
      print('[AuthProvider] ❌ Login exception: $e');
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(
    String username,
    String password, {
    String? email,
    String? language,
  }) async {
    print('[AuthProvider] Starting registration for: $username');
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _authService.register(
        username,
        password,
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
        _isLoading = false;
        print(
          '[AuthProvider] Registration successful! isAuthenticated=$_isAuthenticated',
        );
        notifyListeners();
        return true;
      } else if (result.success && result.requiresEmailVerification) {
        _currentPlayer = null;
        _isAuthenticated = false;
        _error = result.error;
        _isLoading = false;
        print('[AuthProvider] Registration successful, email verification required');
        notifyListeners();
        return true;
      } else {
        _error = result.error;
        _isAuthenticated = false;
        _currentPlayer = null;
        _isLoading = false;
        print('[AuthProvider] Registration failed: ${result.error}');
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = e.toString();
      _isAuthenticated = false;
      _currentPlayer = null;
      _isLoading = false;
      print('[AuthProvider] Registration exception: $e');
      notifyListeners();
      return false;
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
      _currentPlayer = await _authService.getCurrentPlayer();
      _isAuthenticated = _currentPlayer != null;
      if (!_isAuthenticated) {
        _error = null;
      }
      notifyListeners();
    } catch (e) {
      _error = e.toString();
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
      createdAt: _currentPlayer!.createdAt,
      updatedAt: _currentPlayer!.updatedAt,
      lastTickAt: _currentPlayer!.lastTickAt,
    );

    notifyListeners();
  }
}
