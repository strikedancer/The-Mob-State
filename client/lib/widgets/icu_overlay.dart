import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../services/api_client.dart';
import 'responsive_modal.dart';

class ICUOverlay extends StatefulWidget {
  const ICUOverlay({super.key});

  @override
  State<ICUOverlay> createState() => _ICUOverlayState();
}

class _ICUOverlayState extends State<ICUOverlay> {
  final ApiClient _apiClient = ApiClient();
  Timer? _checkTimer;
  Timer? _countdownTimer;
  int _remainingSeconds = 0;
  bool _isInICU = false;

  @override
  void initState() {
    super.initState();
    _checkICUStatus();
    // Check every 30 seconds
    _checkTimer = Timer.periodic(const Duration(seconds: 30), (_) => _checkICUStatus());
    // Countdown timer
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      }
    });
  }

  @override
  void dispose() {
    _checkTimer?.cancel();
    _countdownTimer?.cancel();
    super.dispose();
  }

  Future<void> _checkICUStatus() async {
    try {
      final response = await _apiClient.get('/icu/status');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final icuData = data['data'];
        
        if (mounted) {
          setState(() {
            _isInICU = icuData['inICU'] == true;
            _remainingSeconds = icuData['remainingSeconds'] ?? 0;
          });
        }
      }
    } catch (e) {
      // Silently fail - don't interrupt user experience
    }
  }

  String _formatTime(int seconds) {
    final hours = seconds ~/ 3600;
    final mins = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;
    
    if (hours > 0) {
      return '$hours:${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    }
    return '$mins:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInICU || _remainingSeconds <= 0) {
      return const SizedBox.shrink();
    }

    final isDutch = Localizations.localeOf(context).languageCode == 'nl';

    return ResponsiveModalLayout(
      backgroundColor: Colors.black.withOpacity(0.95),
      phoneMaxWidth: 560,
      tabletMaxWidth: 680,
      desktopMaxWidth: 760,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compactWidth = constraints.maxWidth < 430;
          final compactHeight = constraints.maxHeight < 720;
          final compact = compactWidth || compactHeight;

          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF1B1B1B), Color(0xFF111111)],
              ),
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.all(compact ? 16 : 24),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - (compact ? 32 : 48),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.8, end: 1.2),
                      duration: const Duration(milliseconds: 1000),
                      curve: Curves.easeInOut,
                      builder: (context, scale, child) {
                        return Transform.scale(
                          scale: scale,
                          child: Icon(
                            Icons.favorite,
                            color: Colors.red[300],
                            size: compact ? 88 : 120,
                          ),
                        );
                      },
                      onEnd: () {
                        if (mounted) {
                          setState(() {});
                        }
                      },
                    ),
                    SizedBox(height: compact ? 24 : 40),
                    Text(
                      isDutch ? '🏥 INTENSIVE CARE' : '🏥 INTENSIVE CARE',
                      style: TextStyle(
                        fontSize: compact ? 24 : 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: compact ? 1.2 : 2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(compact ? 16 : 20),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.red, width: 2),
                      ),
                      child: Column(
                        children: [
                          Text(
                            isDutch
                                ? 'Je bent ernstig gewond geraakt tijdens je criminele activiteiten.'
                                : 'You were seriously injured during your criminal activities.',
                            style: TextStyle(
                              fontSize: compact ? 14 : 16,
                              color: Colors.white70,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: compact ? 14 : 20),
                          Text(
                            isDutch
                                ? 'Je ligt nu op de intensive care en bent buiten bewustzijn.'
                                : 'You are now in intensive care and unconscious.',
                            style: TextStyle(
                              fontSize: compact ? 13 : 14,
                              color: Colors.white60,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: compact ? 20 : 30),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              horizontal: compact ? 18 : 32,
                              vertical: compact ? 14 : 16,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  isDutch ? 'Herstel tijd:' : 'Recovery time:',
                                  style: TextStyle(
                                    fontSize: compact ? 13 : 14,
                                    color: Colors.white54,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _formatTime(_remainingSeconds),
                                  style: TextStyle(
                                    fontSize: compact ? 30 : 42,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.redAccent,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            isDutch
                                ? 'Je komt bij met 10 HP'
                                : 'You wake up with 10 HP',
                            style: TextStyle(
                              fontSize: compact ? 11 : 12,
                              color: Colors.green[300],
                              fontStyle: FontStyle.italic,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: compact ? 20 : 32),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(compact ? 14 : 16),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.orange.withOpacity(0.3)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.orange[300],
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              isDutch
                                  ? 'Tijdens deze tijd kun je geen acties uitvoeren.\nWees voorzichtiger met je gezondheid!'
                                  : 'You cannot perform actions during this time.\nBe more careful with your health!',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white60,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
