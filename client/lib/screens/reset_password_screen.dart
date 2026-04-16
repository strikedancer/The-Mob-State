import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../utils/top_right_notification.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String? initialToken;

  const ResetPasswordScreen({super.key, this.initialToken});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _authService = AuthService();

  bool _isLoading = false;
  bool _isSuccess = false;

  bool get _isDutch => Localizations.localeOf(context).languageCode == 'nl';

  String? get _token {
    final fromWidget = widget.initialToken?.trim();
    if (fromWidget != null && fromWidget.isNotEmpty) {
      return fromWidget;
    }

    final fromQuery = Uri.base.queryParameters['token']?.trim();
    if (fromQuery != null && fromQuery.isNotEmpty) {
      return fromQuery;
    }

    return null;
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final token = _token;
    if (token == null) {
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(
            _isDutch
                ? 'Ongeldige of ontbrekende resetlink.'
                : 'Invalid or missing reset link.',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _authService.resetPassword(token, _passwordController.text);

      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
        _isSuccess = true;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
      });

      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(_mapResetError(error)),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _mapResetError(Object error) {
    final message = error.toString();

    if (message.contains('INVALID_OR_EXPIRED_TOKEN')) {
      return _isDutch
          ? 'Deze resetlink is ongeldig of verlopen.'
          : 'This reset link is invalid or expired.';
    }

    if (message.contains('PASSWORD_TOO_SHORT')) {
      return _isDutch
          ? 'Wachtwoord moet minimaal 6 tekens zijn.'
          : 'Password must be at least 6 characters.';
    }

    if (message.contains('MISSING_FIELDS')) {
      return _isDutch
          ? 'Vul alle verplichte velden in.'
          : 'Please fill in all required fields.';
    }

    return _isDutch
        ? 'Wachtwoord resetten mislukt. Probeer het opnieuw.'
        : 'Failed to reset password. Please try again.';
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isPortrait = screenHeight > screenWidth;
    final isMobile = screenWidth < 600;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (isMobile) Container(color: Colors.black),
          Positioned.fill(
            child: Image.asset(
              isPortrait
                  ? 'assets/images/backgrounds/login_background_mobile.png'
                  : 'assets/images/backgrounds/login_background.png',
              fit: BoxFit.cover,
              alignment: isPortrait ? Alignment.topCenter : Alignment.topLeft,
              errorBuilder: (context, error, stackTrace) {
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
          Container(color: Colors.black.withOpacity(isMobile ? 0.4 : 0.3)),
          Align(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(isMobile ? 16 : 24),
              child: SizedBox(
                width: isMobile ? screenWidth * 0.9 : 420,
                child: Card(
                  elevation: 8,
                  color: Colors.black.withOpacity(isMobile ? 0.50 : 0.35),
                  child: Padding(
                    padding: EdgeInsets.all(isMobile ? 20 : 28),
                    child: _isSuccess
                        ? _buildSuccessMessage(isMobile)
                        : _buildForm(isMobile),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm(bool isMobile) {
    final token = _token;

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            _isDutch ? 'Nieuw wachtwoord' : 'New password',
            style: TextStyle(
              color: const Color(0xFFD4A574),
              fontSize: isMobile ? 24 : 28,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: isMobile ? 12 : 16),
          Text(
            token == null
                ? (_isDutch
                      ? 'Deze pagina heeft geen geldige reset-token ontvangen.'
                      : 'This page did not receive a valid reset token.')
                : (_isDutch
                      ? 'Kies hieronder een nieuw wachtwoord voor je account.'
                      : 'Choose a new password for your account below.'),
            style: TextStyle(
              color: Colors.white70,
              fontSize: isMobile ? 13 : 14,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: isMobile ? 24 : 32),
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            style: const TextStyle(color: Color(0xFFD4A574)),
            decoration: _buildInputDecoration(
              _isDutch ? 'Nieuw wachtwoord' : 'New password',
              Icons.lock,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return _isDutch
                    ? 'Voer een wachtwoord in'
                    : 'Please enter a password';
              }
              if (value.length < 6) {
                return _isDutch
                    ? 'Wachtwoord moet minimaal 6 tekens zijn'
                    : 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          SizedBox(height: isMobile ? 16 : 20),
          TextFormField(
            controller: _confirmPasswordController,
            obscureText: true,
            style: const TextStyle(color: Color(0xFFD4A574)),
            decoration: _buildInputDecoration(
              _isDutch ? 'Bevestig wachtwoord' : 'Confirm password',
              Icons.lock_outline,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return _isDutch
                    ? 'Bevestig je wachtwoord'
                    : 'Please confirm your password';
              }
              if (value != _passwordController.text) {
                return _isDutch
                    ? 'Wachtwoorden komen niet overeen'
                    : 'Passwords do not match';
              }
              return null;
            },
          ),
          SizedBox(height: isMobile ? 24 : 28),
          Container(
            height: isMobile ? 48 : 52,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: const [
                  Color(0xFFD4A574),
                  Color(0xFFB8945E),
                  Color(0xFFD4A574),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(
                  color: Colors.amber.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: _isLoading || token == null ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                      ),
                    )
                  : Text(
                      _isDutch ? 'WACHTWOORD OPSLAAN' : 'SAVE PASSWORD',
                      style: TextStyle(
                        fontSize: isMobile ? 15 : 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
            ),
          ),
          SizedBox(height: isMobile ? 16 : 20),
          TextButton(
            onPressed: () => Navigator.of(context).pushNamed('/login'),
            child: Text(
              _isDutch ? 'Terug naar inloggen' : 'Back to login',
              style: TextStyle(
                color: const Color(0xFFD4A574),
                fontSize: isMobile ? 13 : 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessMessage(bool isMobile) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Icon(
          Icons.check_circle_outline,
          color: const Color(0xFFD4A574),
          size: isMobile ? 64 : 80,
        ),
        SizedBox(height: isMobile ? 16 : 24),
        Text(
          _isDutch ? 'Wachtwoord bijgewerkt' : 'Password updated',
          style: TextStyle(
            color: const Color(0xFFD4A574),
            fontSize: isMobile ? 18 : 20,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: isMobile ? 12 : 16),
        Text(
          _isDutch
              ? 'Je kunt nu met je nieuwe wachtwoord opnieuw inloggen.'
              : 'You can now log in again with your new password.',
          style: TextStyle(color: Colors.white70, fontSize: isMobile ? 13 : 14),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: isMobile ? 24 : 32),
        TextButton(
          onPressed: () => Navigator.of(context).pushNamed('/login'),
          child: Text(
            _isDutch ? 'Terug naar inloggen' : 'Back to login',
            style: TextStyle(
              color: const Color(0xFFD4A574),
              fontSize: isMobile ? 14 : 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  InputDecoration _buildInputDecoration(String hintText, IconData icon) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Color(0xFFD4A574)),
      prefixIcon: Icon(icon, color: const Color(0xFFD4A574), size: 20),
      filled: true,
      fillColor: Colors.black.withOpacity(0.3),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: Colors.white10, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide(color: Colors.amber[700]!, width: 1),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
}
