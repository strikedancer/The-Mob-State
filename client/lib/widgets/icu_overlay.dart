import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../services/api_client.dart';

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

    // Full screen overlay
    return Material(
      color: Colors.black.withOpacity(0.95),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Pulsing heart icon
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
                      size: 120,
                    ),
                  );
                },
                onEnd: () {
                  if (mounted) {
                    setState(() {}); // Trigger rebuild to restart animation
                  }
                },
              ),
              const SizedBox(height: 40),
              
              const Text(
                '🏥 INTENSIVE CARE',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red, width: 2),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Je bent ernstig gewond geraakt tijdens je criminele activiteiten.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Je ligt nu op de intensive care en bent buiten bewustzijn.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white60,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    
                    // Countdown
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Herstel tijd:',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white54,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _formatTime(_remainingSeconds),
                            style: const TextStyle(
                              fontSize: 42,
                              fontWeight: FontWeight.bold,
                              color: Colors.redAccent,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    Text(
                      'Je komt bij met 10 HP',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green[300],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              
              // Info message
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.orange[300],
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    const Flexible(
                      child: Text(
                        'Tijdens deze tijd kun je geen acties uitvoeren.\nWees voorzichtiger met je gezondheid!',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white60,
                        ),
                        textAlign: TextAlign.center,
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
  }
}
