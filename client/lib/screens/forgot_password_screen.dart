import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../utils/top_right_notification.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submitResetRequest() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Call backend API to send password reset email
      // await authService.requestPasswordReset(_emailController.text.trim());

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() {
          _emailSent = true;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        showTopRightFromSnackBar(context, 
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isPortrait = screenHeight > screenWidth;
    final isMobile = screenWidth < 600;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Black background for mobile
          if (isMobile) Container(color: Colors.black),
          // Background image
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
          // Dark overlay
          Container(color: Colors.black.withOpacity(isMobile ? 0.4 : 0.3)),
          // Back button
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Color(0xFFD4A574),
                size: 28,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          // Reset password form
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
                    child: _emailSent
                        ? _buildSuccessMessage(l10n, isMobile)
                        : _buildResetForm(l10n, isMobile),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResetForm(AppLocalizations l10n, bool isMobile) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Title
          Text(
            l10n.forgotPasswordTitle,
            style: TextStyle(
              color: Color(0xFFD4A574),
              fontSize: isMobile ? 24 : 28,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: isMobile ? 12 : 16),
          // Description
          Text(
            l10n.forgotPasswordDescription,
            style: TextStyle(
              color: Colors.white70,
              fontSize: isMobile ? 13 : 14,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: isMobile ? 24 : 32),
          // Email field
          TextFormField(
            controller: _emailController,
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
                borderSide: BorderSide(color: Colors.white10, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: Colors.amber[700]!, width: 1),
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
              final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
              if (!emailRegex.hasMatch(value)) {
                return l10n.emailInvalid;
              }
              return null;
            },
          ),
          SizedBox(height: isMobile ? 24 : 28),
          // Submit button
          Container(
            height: isMobile ? 48 : 52,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
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
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: _isLoading ? null : _submitResetRequest,
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
                      l10n.resetPasswordButton,
                      style: TextStyle(
                        fontSize: isMobile ? 15 : 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
            ),
          ),
          SizedBox(height: isMobile ? 16 : 20),
          // Back to login
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              l10n.backToLogin,
              style: TextStyle(
                color: Color(0xFFD4A574),
                fontSize: isMobile ? 13 : 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessMessage(AppLocalizations l10n, bool isMobile) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Icon(
          Icons.check_circle_outline,
          color: Color(0xFFD4A574),
          size: isMobile ? 64 : 80,
        ),
        SizedBox(height: isMobile ? 16 : 24),
        Text(
          l10n.emailSent,
          style: TextStyle(
            color: Color(0xFFD4A574),
            fontSize: isMobile ? 18 : 20,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: isMobile ? 12 : 16),
        Text(
          l10n.forgotPasswordDescription,
          style: TextStyle(color: Colors.white70, fontSize: isMobile ? 13 : 14),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: isMobile ? 24 : 32),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            l10n.backToLogin,
            style: TextStyle(
              color: Color(0xFFD4A574),
              fontSize: isMobile ? 14 : 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
