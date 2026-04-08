// ignore_for_file: unused_element
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/auth_provider.dart';
import '../services/api_client.dart';

/// Widget shown when player is in jail
/// Shows a cartoon prisoner with countdown timer
class JailOverlay extends StatefulWidget {
  final int remainingSeconds;
  final int? wantedLevel; // For bail calculation
  final VoidCallback? onReleased;
  final bool embedded;

  const JailOverlay({
    super.key,
    required this.remainingSeconds,
    this.wantedLevel,
    this.onReleased,
    this.embedded = false,
  });

  @override
  State<JailOverlay> createState() => _JailOverlayState();
}

class _JailOverlayState extends State<JailOverlay> {
  late int _remainingSeconds;
  Timer? _timer;
  bool _isPayingBail = false;
  final ApiClient _apiClient = ApiClient();
  OverlayEntry? _notificationEntry;
  Timer? _notificationTimer;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.remainingSeconds; // Already in seconds from backend
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _notificationTimer?.cancel();
    _notificationEntry?.remove();
    super.dispose();
  }

  void _showTopRightNotification(
    String message, {
    Color backgroundColor = const Color(0xFF323232),
    IconData icon = Icons.info_outline,
  }) {
    final overlay = Overlay.of(context, rootOverlay: true);
    if (overlay == null) {
      return;
    }

    _notificationTimer?.cancel();
    _notificationEntry?.remove();

    final entry = OverlayEntry(
      builder: (context) {
        final screenWidth = MediaQuery.of(context).size.width;
        final toastWidth = screenWidth < 440 ? screenWidth - 24 : 380.0;

        return Positioned(
          top: 16,
          right: 12,
          child: SafeArea(
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: toastWidth,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(icon, color: Colors.white, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        message,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    overlay.insert(entry);
    _notificationEntry = entry;
    _notificationTimer = Timer(const Duration(seconds: 3), () {
      _notificationEntry?.remove();
      _notificationEntry = null;
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          timer.cancel();
          widget.onReleased?.call();
        }
      });
    });
  }

  String _formatTime() {
    final hours = _remainingSeconds ~/ 3600;
    final minutes = (_remainingSeconds % 3600) ~/ 60;
    final seconds = _remainingSeconds % 60;

    if (hours > 0) {
      return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '$minutes:${seconds.toString().padLeft(2, '0')}';
    }
  }

  Future<void> _payBail() async {
    setState(() {
      _isPayingBail = true;
    });

    try {
      final response = await _apiClient.post('/player/pay-bail', {});
      final data = jsonDecode(response.body);

      if (data['event'] == 'bail.paid') {
        // Update player stats
        if (mounted) {
          final authProvider = Provider.of<AuthProvider>(context, listen: false);
          final playerData = data['player'] as Map<String, dynamic>?;
          if (playerData != null) {
            authProvider.updatePlayerStats(
              money: playerData['money'] as int?,
              wantedLevel: playerData['wantedLevel'] as int?,
            );
          }

          final amount = data['params']?['amount'] as int? ?? 0;
          final l10n = AppLocalizations.of(context)!;
          final isDutch = l10n.localeName == 'nl';

          _showTopRightNotification(
            isDutch
                ? '🎉 Je bent vrij! Borg betaald: €$amount'
                : '🎉 You\'re free! Bail paid: €$amount',
            backgroundColor: Colors.green.shade700,
            icon: Icons.check_circle_outline,
          );

          // Call onReleased callback
          widget.onReleased?.call();
        }
      } else if (data['event'] == 'error.insufficient_funds') {
        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
          final isDutch = l10n.localeName == 'nl';
          _showTopRightNotification(
            isDutch ? 'Niet genoeg geld voor borg' : 'Not enough money for bail',
            backgroundColor: Colors.red.shade700,
            icon: Icons.error_outline,
          );
        }
      } else if (data['event'] == 'error.cooldown') {
        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
          final isDutch = l10n.localeName == 'nl';
          final params = data['params'] as Map<String, dynamic>?;
          final remainingSeconds = (params?['remainingSeconds'] as num?)?.toInt() ?? 0;
          _showTopRightNotification(
            isDutch
                ? 'Cooldown actief: wacht nog ${remainingSeconds}s'
                : 'Cooldown active: wait ${remainingSeconds}s',
            backgroundColor: Colors.orange.shade700,
            icon: Icons.hourglass_top,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        _showTopRightNotification(
          'Error: $e',
          backgroundColor: Colors.red.shade700,
          icon: Icons.error_outline,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isPayingBail = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDutch = l10n.localeName == 'nl';
    final screenSize = MediaQuery.of(context).size;

    final card = Card(
      margin: const EdgeInsets.all(24),
      elevation: 12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 560,
          maxHeight: screenSize.height - 96,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[850],
                border: Border(
                  bottom: BorderSide(color: Colors.grey[700]!, width: 1),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text(
                        '🔒',
                        style: TextStyle(fontSize: 28),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        isDutch ? 'Je zit in de cel' : 'You are in jail',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white.withOpacity(0.35)),
                    ),
                    child: Column(
                      children: [
                        Text(
                          isDutch ? 'Resterende tijd' : 'Time left',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          _formatTime(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'images/cooldown_jail.png',
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.15),
                          Colors.black.withOpacity(0.75),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.white24),
                          ),
                          child: Text(
                            isDutch
                                ? 'Je kunt geen misdaden plegen, werken of reizen tijdens je celstraf.'
                                : 'You cannot commit crimes, work, or travel while serving your sentence.',
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (widget.wantedLevel != null && widget.wantedLevel! > 0)
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _isPayingBail ? null : _payBail,
                              icon: _isPayingBail
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Icon(Icons.attach_money),
                              label: Text(
                                isDutch
                                    ? 'Betaal Borg €${widget.wantedLevel! * 1000}'
                                    : 'Pay Bail €${widget.wantedLevel! * 1000}',
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    if (widget.embedded) {
      return Center(child: card);
    }

    return Scaffold(
      backgroundColor: Colors.black87,
      body: Center(child: card),
    );
  }
}

/// Custom painter for prison bars effect
class _PrisonBarsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey[700]!
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke;

    // Draw vertical bars
    const barCount = 5;
    final spacing = size.width / (barCount + 1);
    
    for (int i = 1; i <= barCount; i++) {
      final x = spacing * i;
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Custom painter voor mafia stripfiguur in de gevangenis
class _MafiaPrisonerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Lichaam (oranje gevangenis pak)
    final bodyCenter = Offset(size.width * 0.5, size.height * 0.65);
    paint.color = const Color(0xFFFF8C00); // Oranje gevangenis pak
    
    final bodyRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: bodyCenter,
        width: 80,
        height: 90,
      ),
      const Radius.circular(20),
    );
    canvas.drawRRect(bodyRect, paint);

    // Strepen op gevangenis pak
    paint.color = Colors.white;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 3;
    for (int i = 0; i < 4; i++) {
      final y = bodyCenter.dy - 35 + (i * 20);
      canvas.drawLine(
        Offset(bodyCenter.dx - 35, y),
        Offset(bodyCenter.dx + 35, y),
        paint,
      );
    }
    paint.style = PaintingStyle.fill;

    // Hoofd
    final headCenter = Offset(size.width * 0.5, size.height * 0.35);
    paint.color = const Color(0xFFFFDBB5); // Huidskleur
    canvas.drawCircle(headCenter, 40, paint);

    // Hoed (fedora - mafia stijl, maar nu verfrommeld/triest)
    paint.color = Colors.grey[800]!;
    final hatBrim = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(headCenter.dx, headCenter.dy - 40),
        width: 90,
        height: 10,
      ),
      const Radius.circular(5),
    );
    canvas.drawRRect(hatBrim, paint);
    
    final hatCrown = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(headCenter.dx, headCenter.dy - 52),
        width: 65,
        height: 30,
      ),
      const Radius.circular(5),
    );
    canvas.drawRRect(hatCrown, paint);

    // Ogen (verdrietig/verslagen)
    paint.color = Colors.white;
    canvas.drawCircle(Offset(headCenter.dx - 12, headCenter.dy - 5), 7, paint);
    canvas.drawCircle(Offset(headCenter.dx + 12, headCenter.dy - 5), 7, paint);
    
    // Pupillen (kijkend naar beneden - verslagen)
    paint.color = Colors.black;
    canvas.drawCircle(Offset(headCenter.dx - 12, headCenter.dy - 2), 4, paint);
    canvas.drawCircle(Offset(headCenter.dx + 12, headCenter.dy - 2), 4, paint);

    // Wenkbrauwen (verdrietig)
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 3;
    paint.strokeCap = StrokeCap.round;
    paint.color = const Color(0xFF8B4513);
    
    final leftBrow = Path()
      ..moveTo(headCenter.dx - 20, headCenter.dy - 15)
      ..quadraticBezierTo(
        headCenter.dx - 12, headCenter.dy - 18,
        headCenter.dx - 4, headCenter.dy - 15,
      );
    canvas.drawPath(leftBrow, paint);
    
    final rightBrow = Path()
      ..moveTo(headCenter.dx + 4, headCenter.dy - 15)
      ..quadraticBezierTo(
        headCenter.dx + 12, headCenter.dy - 18,
        headCenter.dx + 20, headCenter.dy - 15,
      );
    canvas.drawPath(rightBrow, paint);

    // Neus
    paint.style = PaintingStyle.fill;
    paint.color = const Color(0xFFE8C4A0);
    canvas.drawCircle(Offset(headCenter.dx, headCenter.dy + 5), 7, paint);

    // Mond (verdrietig - omgekeerd)
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 2;
    paint.color = const Color(0xFF8B0000);
    final mouthPath = Path()
      ..moveTo(headCenter.dx - 10, headCenter.dy + 20)
      ..quadraticBezierTo(
        headCenter.dx, headCenter.dy + 16,
        headCenter.dx + 10, headCenter.dy + 20,
      );
    canvas.drawPath(mouthPath, paint);

    // Snor (mafia accent - maar nu droeviger)
    paint.strokeWidth = 2;
    paint.color = Colors.black87;
    final mustachePath = Path()
      ..moveTo(headCenter.dx - 15, headCenter.dy + 12)
      ..quadraticBezierTo(
        headCenter.dx - 8, headCenter.dy + 10,
        headCenter.dx, headCenter.dy + 11,
      )
      ..quadraticBezierTo(
        headCenter.dx + 8, headCenter.dy + 10,
        headCenter.dx + 15, headCenter.dy + 12,
      );
    canvas.drawPath(mustachePath, paint);

    // Traan (verdrietig in gevangenis)
    paint.style = PaintingStyle.fill;
    paint.color = const Color(0xFF87CEEB);
    final tear = Path()
      ..moveTo(headCenter.dx - 15, headCenter.dy + 2)
      ..quadraticBezierTo(
        headCenter.dx - 16, headCenter.dy + 8,
        headCenter.dx - 15, headCenter.dy + 12,
      )
      ..quadraticBezierTo(
        headCenter.dx - 14, headCenter.dy + 8,
        headCenter.dx - 15, headCenter.dy + 2,
      );
    canvas.drawPath(tear, paint);

    // Armen/handen (hangend - verslagen houding)
    paint.color = const Color(0xFFFFDBB5);
    canvas.drawCircle(Offset(bodyCenter.dx - 45, bodyCenter.dy + 10), 12, paint);
    canvas.drawCircle(Offset(bodyCenter.dx + 45, bodyCenter.dy + 10), 12, paint);

    // Benen/voeten
    paint.color = const Color(0xFFFF8C00);
    final leftLeg = RRect.fromRectAndRadius(
      Rect.fromLTWH(bodyCenter.dx - 30, bodyCenter.dy + 35, 20, 40),
      const Radius.circular(10),
    );
    canvas.drawRRect(leftLeg, paint);
    
    final rightLeg = RRect.fromRectAndRadius(
      Rect.fromLTWH(bodyCenter.dx + 10, bodyCenter.dy + 35, 20, 40),
      const Radius.circular(10),
    );
    canvas.drawRRect(rightLeg, paint);

    // Schoenen (zwart)
    paint.color = Colors.black87;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(bodyCenter.dx - 20, bodyCenter.dy + 78),
        width: 25,
        height: 12,
      ),
      paint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(bodyCenter.dx + 20, bodyCenter.dy + 78),
        width: 25,
        height: 12,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
