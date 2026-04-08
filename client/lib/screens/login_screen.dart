import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/auth_provider.dart';
import '../providers/locale_provider.dart';
import 'forgot_password_screen.dart';
import '../utils/top_right_notification.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isLogin = true;
  bool _obscurePassword = true;
  String _selectedLanguage = 'nl'; // Default to Dutch

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  String _localizeAuthError(AppLocalizations l10n, String? error) {
    if (error == null || error.isEmpty) {
      return '';
    }

    final normalized = error.trim();
    if (normalized == 'INVALID_CREDENTIALS' ||
        normalized == 'Ongeldige gebruikersnaam of wachtwoord') {
      return l10n.invalidCredentials;
    }

    if (normalized == 'USERNAME_TAKEN' ||
        normalized == 'Gebruikersnaam is al in gebruik' ||
        normalized == 'Deze gebruikersnaam is al in gebruik') {
      return l10n.usernameTaken;
    }

    return normalized;
  }

  void _clearAuthError() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.clearError();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final l10n = AppLocalizations.of(context)!;
    final username = _usernameController.text.trim();
    final password = _passwordController.text;
    final email = _emailController.text.trim();

    print(
      '[LoginScreen] Starting ${_isLogin ? 'login' : 'register'} for: $username',
    );

    bool success;
    if (_isLogin) {
      success = await authProvider.login(username, password);
    } else {
      success = await authProvider.register(
        username,
        password,
        email: email,
        language: _selectedLanguage,
      );
    }

    print(
      '[LoginScreen] Result: success=$success, isAuthenticated=${authProvider.isAuthenticated}, error=${authProvider.error}',
    );

    // Show feedback and navigate
    if (mounted) {
      if (success) {
        if (_isLogin || authProvider.isAuthenticated) {
          print(
            '[LoginScreen] ✅ Login/Register successful - navigating to dashboard',
          );

          // Load user's preferred language
          final localeProvider = Provider.of<LocaleProvider>(
            context,
            listen: false,
          );
          await localeProvider.loadLocale();

          showTopRightFromSnackBar(context,
            SnackBar(
              content: Text(
                _isLogin ? l10n.loginSuccessful : l10n.registrationSuccessful,
              ),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 1),
            ),
          );
          // Explicitly navigate to dashboard instead of relying on AuthWrapper rebuild
          await Future.delayed(const Duration(milliseconds: 100));
          if (mounted) {
            Navigator.of(context).pushReplacementNamed('/dashboard');
          }
        } else {
          showTopRightFromSnackBar(context,
            SnackBar(
              content: Text(
                authProvider.error ??
                    'Registratie gelukt! Controleer je e-mail om te verifiëren.',
              ),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 4),
            ),
          );
          setState(() {
            _isLogin = true;
          });
        }
      } else {
        final errorMessage = _localizeAuthError(l10n, authProvider.error);
        showTopRightFromSnackBar(context, 
          SnackBar(
            content: Text(errorMessage.isEmpty ? l10n.loginFailed : errorMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;
    final isPortrait = screenHeight > screenWidth; // Portrait or Landscape?
    final isMobile = screenWidth < 600;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Black background for mobile (behind image)
          if (isMobile) Container(color: Colors.black),
          // Background image - choose based on orientation
          Positioned.fill(
            child: Image.asset(
              isPortrait
                  ? 'images/backgrounds/login_background_mobile.png'
                  : 'images/backgrounds/login_background.png',
              fit: BoxFit.cover, // Always cover - fills entire screen
              alignment: isPortrait
                  ? Alignment.topCenter
                  : Alignment
                        .topLeft, // Start from top on portrait, top left on landscape
              errorBuilder: (context, error, stackTrace) {
                // Fallback gradient background
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.grey[900]!,
                        Colors.black,
                        Colors.grey[850]!,
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Dark overlay for better text readability
          Container(color: Colors.black.withOpacity(isMobile ? 0.4 : 0.3)),
          // Login form - centered on all screens
          Align(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(isMobile ? 16 : 24),
              child: Container(
                width: isMobile ? screenWidth * 0.9 : 420,
                margin: null,
                child: Card(
                  elevation: 8,
                  color: Colors.black.withOpacity(isMobile ? 0.50 : 0.35),
                  child: Padding(
                    padding: EdgeInsets.all(isMobile ? 20 : 28),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Username field
                          TextFormField(
                            controller: _usernameController,
                            onChanged: (_) => _clearAuthError(),
                            style: const TextStyle(color: Color(0xFFD4A574)),
                            decoration: InputDecoration(
                              hintText: l10n.usernamePlaceholder,
                              hintStyle: TextStyle(color: Color(0xFFD4A574)),
                              prefixIcon: const Icon(
                                Icons.person,
                                color: Color(0xFFD4A574),
                                size: 20,
                              ),
                              filled: true,
                              fillColor: Colors.black.withOpacity(0.3),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: BorderSide(
                                  color: Colors.white10,
                                  width: 1,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: BorderSide(
                                  color: Colors.amber[700]!,
                                  width: 1,
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return l10n.usernameRequired;
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: isMobile ? 16 : 20),

                          // Password field
                          TextFormField(
                            controller: _passwordController,
                            onChanged: (_) => _clearAuthError(),
                            style: const TextStyle(color: Color(0xFFD4A574)),
                            decoration: InputDecoration(
                              hintText: l10n.passwordPlaceholder,
                              hintStyle: TextStyle(color: Color(0xFFD4A574)),
                              prefixIcon: const Icon(
                                Icons.lock,
                                color: Color(0xFFD4A574),
                                size: 20,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Color(0xFFD4A574),
                                  size: 20,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                              filled: true,
                              fillColor: Colors.black.withOpacity(0.3),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: BorderSide(
                                  color: Colors.white10,
                                  width: 1,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: BorderSide(
                                  color: Colors.amber[700]!,
                                  width: 1,
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                            ),
                            obscureText: _obscurePassword,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return l10n.passwordRequired;
                              }
                              if (value.length < 6) {
                                return l10n.passwordTooShort;
                              }
                              return null;
                            },
                          ),

                          // Email field (only for registration)
                          if (!_isLogin) SizedBox(height: isMobile ? 16 : 20),
                          if (!_isLogin)
                            TextFormField(
                              controller: _emailController,
                              onChanged: (_) => _clearAuthError(),
                              style: const TextStyle(color: Color(0xFFD4A574)),
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                hintText: l10n.emailPlaceholder,
                                hintStyle: TextStyle(color: Color(0xFFD4A574)),
                                prefixIcon: const Icon(
                                  Icons.email,
                                  color: Color(0xFFD4A574),
                                  size: 20,
                                ),
                                filled: true,
                                fillColor: Colors.black.withOpacity(0.3),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide: BorderSide(
                                    color: Colors.white10,
                                    width: 1,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide: BorderSide(
                                    color: Colors.amber[700]!,
                                    width: 1,
                                  ),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return l10n.emailRequired;
                                }
                                // Basic email validation
                                final emailRegex = RegExp(
                                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                );
                                if (!emailRegex.hasMatch(value)) {
                                  return l10n.emailInvalid;
                                }
                                return null;
                              },
                            ),

                          // Language dropdown (only for registration)
                          if (!_isLogin) SizedBox(height: isMobile ? 16 : 20),
                          if (!_isLogin)
                            DropdownButtonFormField<String>(
                              initialValue: _selectedLanguage,
                              dropdownColor: Color(0xFF1a1a1a),
                              style: const TextStyle(color: Color(0xFFD4A574)),
                              decoration: InputDecoration(
                                hintText: 'Language / Taal',
                                hintStyle: TextStyle(color: Color(0xFFD4A574)),
                                prefixIcon: const Icon(
                                  Icons.language,
                                  color: Color(0xFFD4A574),
                                  size: 20,
                                ),
                                filled: true,
                                fillColor: Colors.black.withOpacity(0.3),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide: BorderSide(
                                    color: Colors.white10,
                                    width: 1,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide: BorderSide(
                                    color: Colors.amber[700]!,
                                    width: 1,
                                  ),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value: 'nl',
                                  child: Text('🇳🇱 Nederlands'),
                                ),
                                DropdownMenuItem(
                                  value: 'en',
                                  child: Text('🇬🇧 English'),
                                ),
                              ],
                              onChanged: (value) {
                                if (value != null) {
                                  _clearAuthError();
                                  setState(() {
                                    _selectedLanguage = value;
                                  });
                                }
                              },
                            ),
                          Consumer<AuthProvider>(
                            builder: (context, authProvider, _) {
                              final errorMessage = _localizeAuthError(
                                l10n,
                                authProvider.error,
                              );
                              if (errorMessage.isEmpty) {
                                return const SizedBox.shrink();
                              }

                              return Padding(
                                padding: EdgeInsets.only(top: isMobile ? 16 : 18),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF5C1D1D).withOpacity(0.88),
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: const Color(0xFFE07A7A),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(top: 1),
                                        child: Icon(
                                          Icons.error_outline,
                                          color: Color(0xFFFFB4B4),
                                          size: 18,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          errorMessage,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                            height: 1.3,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: isMobile ? 24 : 28),

                          // Submit button with gradient
                          Consumer<AuthProvider>(
                            builder: (context, authProvider, _) {
                              return Container(
                                height: isMobile ? 48 : 52,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFFD4A574),
                                      Color(0xFFB8945E),
                                      Color(0xFFD4A574),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.amber.withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                  onPressed: authProvider.isLoading
                                      ? null
                                      : _submit,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    foregroundColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  child: authProvider.isLoading
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  Colors.black,
                                                ),
                                          ),
                                        )
                                      : Text(
                                          _isLogin
                                              ? l10n.loginButton
                                              : l10n.registerButton,
                                          style: TextStyle(
                                            fontSize: isMobile ? 15 : 16,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 2,
                                          ),
                                        ),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: isMobile ? 16 : 20),

                          // Register and Forgot Password links
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  _clearAuthError();
                                  setState(() {
                                    _isLogin = !_isLogin;
                                  });
                                },
                                child: Text(
                                  _isLogin ? l10n.register : l10n.login,
                                  style: TextStyle(
                                    color: Color(0xFFD4A574),
                                    fontSize: isMobile ? 13 : 14,
                                  ),
                                ),
                              ),
                              if (_isLogin)
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const ForgotPasswordScreen(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    l10n.forgotPassword,
                                    style: TextStyle(
                                      color: Color(0xFFD4A574),
                                      fontSize: isMobile ? 13 : 14,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
