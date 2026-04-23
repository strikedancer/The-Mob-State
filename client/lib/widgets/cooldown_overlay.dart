// ignore_for_file: unused_element
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/cooldown_info.dart';
import '../l10n/app_localizations.dart';
import '../services/auth_service.dart';
import '../utils/formatters.dart';
import '../utils/web_asset_helper.dart';

/// Full-screen overlay showing cooldown timer with cartoon and countdown
/// Similar to JailOverlay but for action cooldowns
class CooldownOverlay extends StatefulWidget {
  final String actionType; // 'crime', 'job', 'travel', 'heist', 'appeal'
  final String? cooldownActionType; // technical type used for credit reset
  final int remainingSeconds;
  final VoidCallback? onExpired;
  final String? resultMessage; // Optional result message to show
  final bool? isSuccess; // Whether the action was successful
  final bool embedded;

  const CooldownOverlay({
    super.key,
    required this.actionType,
    this.cooldownActionType,
    required this.remainingSeconds,
    this.onExpired,
    this.resultMessage,
    this.isSuccess,
    this.embedded = false,
  });

  @override
  State<CooldownOverlay> createState() => _CooldownOverlayState();
}

class _CooldownOverlayState extends State<CooldownOverlay> {
  late int _secondsLeft;
  Timer? _timer;
  late CooldownInfo _cooldownInfo;
  bool _loadingCreditAction = false;
  bool _redeemingCreditAction = false;
  bool _canRedeemNow = false;
  String? _cooldownResetItemKey;
  int _cooldownResetCost = 0;
  int _creditBalance = 0;
  String? _cooldownUnavailableReason;

  String get _effectiveCooldownActionType =>
      (widget.cooldownActionType ?? widget.actionType).trim();

  @override
  void initState() {
    super.initState();
    _secondsLeft = widget.remainingSeconds;
    _cooldownInfo = CooldownInfo(
      actionType: widget.actionType,
      remainingSeconds: widget.remainingSeconds,
    );
    _startCountdown();
    _loadCooldownCreditAction();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft <= 0) {
        timer.cancel();
        if (mounted) {
          widget.onExpired?.call(); // Call callback when expired
        }
      } else {
        setState(() {
          _secondsLeft--;
        });
      }
    });
  }

  String _formatTime() {
    final localeName = AppLocalizations.of(context)?.localeName;
    return formatAdaptiveDurationFromSeconds(
      _secondsLeft,
      localeName: localeName,
    );
  }

  String _tr(String nl, String en) => localeOf(context) == 'nl' ? nl : en;

  String localeOf(BuildContext context) =>
      AppLocalizations.of(context)?.localeName ?? 'en';

  Future<void> _loadCooldownCreditAction() async {
    final actionType = _effectiveCooldownActionType;
    if (actionType.isEmpty) return;

    setState(() {
      _loadingCreditAction = true;
      _cooldownResetItemKey = null;
      _cooldownResetCost = 0;
      _canRedeemNow = false;
      _cooldownUnavailableReason = null;
    });

    try {
      final apiClient = AuthService().apiClient;
      final response = await apiClient.get('/subscriptions/credits/overview');
      if (response.statusCode != 200) return;

      final payload = jsonDecode(response.body) as Map<String, dynamic>;
      final items = (payload['items'] as List<dynamic>? ?? const [])
          .whereType<Map<String, dynamic>>();
      final match = items
          .where((item) {
            final effectType = (item['effectType'] ?? '').toString();
            final itemActionType = (item['actionType'] ?? '').toString();
            return effectType == 'ACTION_COOLDOWN_RESET' &&
                itemActionType == actionType;
          })
          .cast<Map<String, dynamic>>()
          .toList();

      if (!mounted) return;
      if (match.isEmpty) {
        setState(() {
          _creditBalance = (payload['balance'] as num?)?.toInt() ?? 0;
        });
        return;
      }

      final item = match.first;
      final fallbackCost = (item['creditCost'] as num?)?.toInt() ?? 0;
      final effectiveCost =
          (item['effectiveCreditCost'] as num?)?.toInt() ?? fallbackCost;
      setState(() {
        _cooldownResetItemKey = (item['key'] ?? '').toString();
        _cooldownResetCost = effectiveCost;
        _canRedeemNow = item['canRedeemNow'] == true;
        _cooldownUnavailableReason = (item['unavailableReason'] ?? '')
            .toString();
        _creditBalance = (payload['balance'] as num?)?.toInt() ?? 0;
      });
    } catch (_) {
      // Keep overlay functional when credits endpoint is unavailable.
    } finally {
      if (mounted) {
        setState(() {
          _loadingCreditAction = false;
        });
      }
    }
  }

  String _redeemDisabledReason() {
    if (_cooldownResetItemKey == null || _cooldownResetItemKey!.isEmpty) {
      return '';
    }
    if (_secondsLeft <= 0) {
      return _tr('Cooldown is al klaar.', 'Cooldown already finished.');
    }
    if (_creditBalance < _cooldownResetCost) {
      return _tr('Onvoldoende credits.', 'Not enough credits.');
    }
    if (!_canRedeemNow) {
      if (_cooldownUnavailableReason == 'ACTION_COOLDOWN_NOT_ACTIVE') {
        return _tr(
          'Geen actieve cooldown om te resetten.',
          'No active cooldown to reset.',
        );
      }
      return _tr('Nu niet beschikbaar.', 'Not available right now.');
    }
    return '';
  }

  Future<void> _redeemCooldownWithCredits() async {
    if (_redeemingCreditAction || _cooldownResetItemKey == null) return;
    setState(() => _redeemingCreditAction = true);

    try {
      final apiClient = AuthService().apiClient;
      final response = await apiClient.post('/subscriptions/credits/redeem', {
        'itemKey': _cooldownResetItemKey,
        'actionType': _effectiveCooldownActionType,
      });

      final payload = response.body.isNotEmpty
          ? jsonDecode(response.body) as Map<String, dynamic>
          : <String, dynamic>{};

      if (!mounted) return;
      if (response.statusCode != 200) {
        final fallback = _tr(
          'Versnellen met credits mislukt.',
          'Failed to speed up with credits.',
        );
        final message = (payload['error'] ?? payload['message'] ?? fallback)
            .toString();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.red),
        );
        await _loadCooldownCreditAction();
        return;
      }

      final successMessage =
          (payload['message'] ??
                  _tr(
                    'Cooldown direct afgerond.',
                    'Cooldown finished instantly.',
                  ))
              .toString();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(successMessage), backgroundColor: Colors.green),
      );

      _timer?.cancel();
      setState(() {
        _secondsLeft = 0;
      });
      widget.onExpired?.call();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _tr(
              'Versnellen met credits mislukt.',
              'Failed to speed up with credits.',
            ),
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _redeemingCreditAction = false);
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = l10n.localeName;

    // Determine which background image to use
    String? backgroundImagePath;
    if (widget.actionType == 'crime') {
      backgroundImagePath = 'assets/images/cooldown_crimes.png';
    } else if (widget.actionType == 'job') {
      backgroundImagePath = 'assets/images/cooldown_jobs.png';
    } else if (widget.actionType == 'travel') {
      backgroundImagePath = 'assets/images/cooldown_airfield.png';
    } else if (widget.actionType == 'school') {
      backgroundImagePath = 'assets/images/cooldown_school.png';
    }

    final canShowCooldownCreditAction =
        _cooldownResetItemKey != null && _cooldownResetItemKey!.isNotEmpty;
    final redeemDisabledReason = _redeemDisabledReason();
    final redeemDisabled =
        _loadingCreditAction ||
        _redeemingCreditAction ||
        !canShowCooldownCreditAction ||
        redeemDisabledReason.isNotEmpty;

    Widget timerChip({required bool compactWidth}) {
      return Container(
        padding: EdgeInsets.symmetric(
          horizontal: compactWidth ? 12 : 16,
          vertical: compactWidth ? 8 : 10,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.18),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.35)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              locale == 'nl' ? 'Resterende tijd' : 'Time left',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              _formatTime(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: compactWidth ? 20 : 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
              ),
            ),
          ],
        ),
      );
    }

    Widget buildResultCard(bool compactWidth) {
      if (widget.resultMessage == null) {
        return const SizedBox.shrink();
      }

      final isSuccess = widget.isSuccess == true;
      final toneColor = isSuccess ? Colors.green : Colors.red;
      final textColor = isSuccess ? Colors.green[900] : Colors.red[900];

      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(compactWidth ? 12 : 14),
        decoration: BoxDecoration(
          color: toneColor.withOpacity(0.18),
          border: Border.all(color: toneColor, width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 1),
              child: Icon(
                isSuccess ? Icons.check_circle : Icons.cancel,
                color: toneColor,
                size: compactWidth ? 20 : 22,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                widget.resultMessage!,
                style: TextStyle(
                  fontSize: compactWidth ? 13 : 14,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final mediaSize = MediaQuery.of(context).size;
        final availableWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : mediaSize.width;
        final availableHeight = constraints.maxHeight.isFinite
            ? constraints.maxHeight
            : mediaSize.height;
        final compactWidth = availableWidth < 430;
        final compactHeight = availableHeight < 760;
        final tabletWidth = availableWidth >= 700;
        final desktopWidth = availableWidth >= 1100;
        final horizontalMargin = compactWidth
            ? 12.0
            : tabletWidth
            ? 24.0
            : 18.0;
        final verticalMargin = compactHeight ? 12.0 : 24.0;
        final maxCardWidth = desktopWidth
            ? 920.0
            : tabletWidth
            ? 760.0
            : 620.0;
        final maxCardHeight = (availableHeight - (verticalMargin * 2)).clamp(
          280.0,
          double.infinity,
        );
        final headerStacks = compactWidth || availableWidth < 560;

        final overlayCard = Card(
          margin: EdgeInsets.symmetric(
            horizontal: horizontalMargin,
            vertical: verticalMargin,
          ),
          elevation: 12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          clipBehavior: Clip.antiAlias,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: maxCardWidth,
              maxHeight: maxCardHeight,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(
                    compactWidth ? 16 : 20,
                    compactWidth ? 16 : 18,
                    compactWidth ? 16 : 20,
                    compactWidth ? 14 : 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[850],
                    border: Border(
                      bottom: BorderSide(color: Colors.grey[700]!, width: 1),
                    ),
                  ),
                  child: headerStacks
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  _cooldownInfo.getIcon(),
                                  style: TextStyle(
                                    fontSize: compactWidth ? 22 : 26,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    '${_cooldownInfo.getActionName(locale)} Cooldown',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: compactWidth ? 18 : 21,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: timerChip(compactWidth: compactWidth),
                            ),
                          ],
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Text(
                                    _cooldownInfo.getIcon(),
                                    style: const TextStyle(fontSize: 28),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      '${_cooldownInfo.getActionName(locale)} Cooldown',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            timerChip(compactWidth: false),
                          ],
                        ),
                ),
                Flexible(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(color: Colors.black),
                      if (backgroundImagePath != null)
                        Positioned.fill(
                          child: WebAssetHelper.image(
                            backgroundImagePath,
                            fit: BoxFit.cover,
                          ),
                        ),
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(0.18),
                                Colors.black.withOpacity(0.32),
                                Colors.black.withOpacity(0.74),
                              ],
                              stops: const [0.0, 0.45, 1.0],
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: SingleChildScrollView(
                          padding: EdgeInsets.all(compactWidth ? 16 : 20),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth: double.infinity,
                              minHeight: compactHeight ? 140 : 180,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                if (widget.resultMessage != null) ...[
                                  buildResultCard(compactWidth),
                                  const SizedBox(height: 14),
                                ],
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: compactWidth ? 14 : 16,
                                    vertical: compactWidth ? 12 : 14,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.12),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _getWaitMessage(locale),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: compactWidth ? 14 : 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        locale == 'nl'
                                            ? 'Je moet wachten voordat je deze actie opnieuw kunt uitvoeren.'
                                            : 'You must wait before you can perform this action again.',
                                        style: TextStyle(
                                          fontSize: compactWidth ? 13 : 15,
                                          color: Colors.grey[200],
                                          height: 1.35,
                                        ),
                                        textAlign: compactWidth
                                            ? TextAlign.left
                                            : TextAlign.center,
                                      ),
                                      if (_loadingCreditAction) ...[
                                        const SizedBox(height: 10),
                                        Row(
                                          children: [
                                            const SizedBox(
                                              width: 14,
                                              height: 14,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                _tr(
                                                  'Credits-opties laden...',
                                                  'Loading credit options...',
                                                ),
                                                style: TextStyle(
                                                  color: Colors.grey[300],
                                                  fontSize: compactWidth
                                                      ? 12
                                                      : 13,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ] else if (canShowCooldownCreditAction) ...[
                                        const SizedBox(height: 10),
                                        SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton.icon(
                                            onPressed: redeemDisabled
                                                ? null
                                                : _redeemCooldownWithCredits,
                                            icon: _redeemingCreditAction
                                                ? const SizedBox(
                                                    width: 14,
                                                    height: 14,
                                                    child:
                                                        CircularProgressIndicator(
                                                          strokeWidth: 2,
                                                          color: Colors.black,
                                                        ),
                                                  )
                                                : const Icon(
                                                    Icons.flash_on,
                                                    size: 18,
                                                  ),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color(
                                                0xFFFFC107,
                                              ),
                                              foregroundColor: Colors.black,
                                            ),
                                            label: Text(
                                              _tr(
                                                'Versnel nu (-$_cooldownResetCost credits)',
                                                'Speed up now (-$_cooldownResetCost credits)',
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          _tr(
                                            'Saldo: $_creditBalance credits',
                                            'Balance: $_creditBalance credits',
                                          ),
                                          style: TextStyle(
                                            color: Colors.grey[300],
                                            fontSize: compactWidth ? 11 : 12,
                                          ),
                                        ),
                                        if (redeemDisabledReason
                                            .isNotEmpty) ...[
                                          const SizedBox(height: 4),
                                          Text(
                                            redeemDisabledReason,
                                            style: TextStyle(
                                              color: Colors.orange[200],
                                              fontSize: compactWidth ? 11 : 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ],
                                  ),
                                ),
                              ],
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
        );

        if (widget.embedded) {
          return Center(child: overlayCard);
        }

        return Scaffold(
          backgroundColor: Colors.black87,
          body: SafeArea(child: Center(child: overlayCard)),
        );
      },
    );
  }

  IconData _getIconData() {
    switch (widget.actionType) {
      case 'crime':
        return Icons.accessible; // Zittende persoon (cartoonachtig)
      case 'job':
        return Icons.coffee; // Pauze/rust icon
      case 'travel':
        return Icons.airport_shuttle; // Wachtend op vliegtuig
      case 'heist':
        return Icons.psychology; // Planning/strategie
      case 'appeal':
        return Icons.hourglass_empty; // Wachten op rechtbank
      default:
        return Icons.timer;
    }
  }

  List<Color> _getGradientColors() {
    switch (widget.actionType) {
      case 'crime':
        return [Colors.deepOrange[700]!, Colors.red[900]!]; // Donker rood thema
      case 'job':
        return [Colors.blue[600]!, Colors.blue[900]!]; // Blauw werk thema
      case 'travel':
        return [Colors.teal[500]!, Colors.cyan[700]!]; // Reizen thema
      case 'heist':
        return [
          Colors.purple[700]!,
          Colors.deepPurple[900]!,
        ]; // Mysterieus thema
      case 'appeal':
        return [Colors.grey[700]!, Colors.grey[900]!]; // Formeel thema
      default:
        return [Colors.grey[600]!, Colors.grey[800]!];
    }
  }

  String _getWaitMessage(String locale) {
    switch (widget.actionType) {
      case 'crime':
        return locale == 'nl'
            ? 'De heat is te hoog...'
            : 'The heat is too high...';
      case 'job':
        return locale == 'nl'
            ? 'Neemt rust voordat je weer kan werken'
            : 'Taking a rest before you can work again';
      case 'travel':
        return locale == 'nl'
            ? 'Volgende vlucht vertrekt over'
            : 'Next flight departs in';
      case 'heist':
        return locale == 'nl'
            ? 'Plan wordt voorbereid...'
            : 'Planning the heist...';
      case 'appeal':
        return locale == 'nl' ? 'Rechtbank is bezet...' : 'Court is busy...';
      default:
        return locale == 'nl' ? 'Even geduld...' : 'Please wait...';
    }
  }
}

/// Custom painter voor mafia stripfiguur die nerveus om de hoek kijkt
class _MafiaCharacterPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Muur (rechter kant)
    paint.color = Colors.white.withOpacity(0.2);
    final wallRect = Rect.fromLTWH(
      size.width * 0.65,
      0,
      size.width * 0.35,
      size.height,
    );
    canvas.drawRect(wallRect, paint);

    // Muur rand
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 3;
    paint.color = Colors.white.withOpacity(0.3);
    canvas.drawLine(
      Offset(size.width * 0.65, 0),
      Offset(size.width * 0.65, size.height),
      paint,
    );
    paint.style = PaintingStyle.fill;

    // Lichaam (half verscholen achter muur)
    paint.color = const Color(0xFF2C2C2C); // Donker pak
    final bodyPath = Path()
      ..moveTo(size.width * 0.55, size.height * 0.5)
      ..lineTo(size.width * 0.65, size.height * 0.5)
      ..lineTo(size.width * 0.65, size.height * 0.9)
      ..lineTo(size.width * 0.55, size.height * 0.9)
      ..close();
    canvas.drawPath(bodyPath, paint);

    // Jas kraag
    paint.color = Colors.black87;
    final collarPath = Path()
      ..moveTo(size.width * 0.55, size.height * 0.5)
      ..lineTo(size.width * 0.58, size.height * 0.48)
      ..lineTo(size.width * 0.62, size.height * 0.5)
      ..lineTo(size.width * 0.6, size.height * 0.55)
      ..close();
    canvas.drawPath(collarPath, paint);

    // Hoofd (cartoon stijl)
    final headCenter = Offset(size.width * 0.45, size.height * 0.35);
    paint.color = const Color(0xFFFFDBB5); // Huidskleur
    canvas.drawCircle(headCenter, 45, paint);

    // Hoed (fedora - mafia stijl)
    paint.color = Colors.black87;
    // Rand van hoed
    final hatBrim = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(headCenter.dx, headCenter.dy - 45),
        width: 100,
        height: 12,
      ),
      const Radius.circular(6),
    );
    canvas.drawRRect(hatBrim, paint);

    // Kroon van hoed
    final hatCrown = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(headCenter.dx, headCenter.dy - 60),
        width: 70,
        height: 35,
      ),
      const Radius.circular(5),
    );
    canvas.drawRRect(hatCrown, paint);

    // Hoed band (accent)
    paint.color = const Color(0xFF8B0000); // Donker rood
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(headCenter.dx, headCenter.dy - 52),
          width: 70,
          height: 8,
        ),
        const Radius.circular(4),
      ),
      paint,
    );

    // Ogen (nerveus/alert)
    paint.color = Colors.white;
    // Linker oog (wit)
    canvas.drawCircle(Offset(headCenter.dx - 12, headCenter.dy - 8), 8, paint);
    // Rechter oog (groter - kijkt om hoek)
    canvas.drawCircle(Offset(headCenter.dx + 15, headCenter.dy - 5), 10, paint);

    // Pupillen (kijkend naar rechts)
    paint.color = Colors.black;
    canvas.drawCircle(Offset(headCenter.dx - 8, headCenter.dy - 8), 4, paint);
    canvas.drawCircle(Offset(headCenter.dx + 19, headCenter.dy - 5), 5, paint);

    // Wenkbrauwen (bezorgd)
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 3;
    paint.strokeCap = StrokeCap.round;
    paint.color = const Color(0xFF8B4513); // Bruin

    final leftBrow = Path()
      ..moveTo(headCenter.dx - 20, headCenter.dy - 20)
      ..quadraticBezierTo(
        headCenter.dx - 12,
        headCenter.dy - 22,
        headCenter.dx - 4,
        headCenter.dy - 20,
      );
    canvas.drawPath(leftBrow, paint);

    final rightBrow = Path()
      ..moveTo(headCenter.dx + 8, headCenter.dy - 18)
      ..quadraticBezierTo(
        headCenter.dx + 16,
        headCenter.dy - 20,
        headCenter.dx + 24,
        headCenter.dy - 18,
      );
    canvas.drawPath(rightBrow, paint);

    // Neus (cartoon stijl)
    paint.style = PaintingStyle.fill;
    paint.color = const Color(0xFFE8C4A0);
    canvas.drawCircle(Offset(headCenter.dx + 5, headCenter.dy + 5), 8, paint);

    // Mond (nerveus - klein)
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 2;
    paint.color = const Color(0xFF8B0000);
    final mouthPath = Path()
      ..moveTo(headCenter.dx - 5, headCenter.dy + 18)
      ..quadraticBezierTo(
        headCenter.dx + 3,
        headCenter.dy + 15,
        headCenter.dx + 10,
        headCenter.dy + 18,
      );
    canvas.drawPath(mouthPath, paint);

    // Zweetdruppels (nerveus!)
    paint.style = PaintingStyle.fill;
    paint.color = const Color(0xFF87CEEB); // Licht blauw

    // Druppel 1
    final sweat1 = Path()
      ..moveTo(headCenter.dx + 30, headCenter.dy - 15)
      ..quadraticBezierTo(
        headCenter.dx + 32,
        headCenter.dy - 10,
        headCenter.dx + 30,
        headCenter.dy - 5,
      )
      ..quadraticBezierTo(
        headCenter.dx + 28,
        headCenter.dy - 10,
        headCenter.dx + 30,
        headCenter.dy - 15,
      );
    canvas.drawPath(sweat1, paint);

    // Druppel 2
    final sweat2 = Path()
      ..moveTo(headCenter.dx + 35, headCenter.dy)
      ..quadraticBezierTo(
        headCenter.dx + 37,
        headCenter.dy + 4,
        headCenter.dx + 35,
        headCenter.dy + 8,
      )
      ..quadraticBezierTo(
        headCenter.dx + 33,
        headCenter.dy + 4,
        headCenter.dx + 35,
        headCenter.dy,
      );
    canvas.drawPath(sweat2, paint);

    // Hand die om de hoek grijpt
    paint.color = const Color(0xFFFFDBB5);
    canvas.drawCircle(Offset(size.width * 0.65, size.height * 0.55), 18, paint);

    // Vingers
    paint.strokeWidth = 8;
    paint.strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(size.width * 0.65, size.height * 0.5),
      Offset(size.width * 0.65, size.height * 0.58),
      paint,
    );

    // Snor (optional - mafia accent)
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 2;
    paint.color = Colors.black87;
    final mustachePath = Path()
      ..moveTo(headCenter.dx - 15, headCenter.dy + 12)
      ..quadraticBezierTo(
        headCenter.dx - 10,
        headCenter.dy + 8,
        headCenter.dx,
        headCenter.dy + 11,
      )
      ..quadraticBezierTo(
        headCenter.dx + 10,
        headCenter.dy + 8,
        headCenter.dx + 18,
        headCenter.dy + 12,
      );
    canvas.drawPath(mustachePath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Custom painter voor mafia stripfiguur slapend in bed (job cooldown)
class _MafiaSleepingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Bed (basis)
    final bedCenter = Offset(size.width * 0.5, size.height * 0.7);
    paint.color = const Color(0xFF8B4513); // Bruin hout
    final bedFrame = RRect.fromRectAndRadius(
      Rect.fromCenter(center: bedCenter, width: 200, height: 40),
      const Radius.circular(5),
    );
    canvas.drawRRect(bedFrame, paint);

    // Matras
    paint.color = Colors.white;
    final mattress = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(bedCenter.dx, bedCenter.dy - 15),
        width: 190,
        height: 30,
      ),
      const Radius.circular(8),
    );
    canvas.drawRRect(mattress, paint);

    // Deken (blauw)
    paint.color = const Color(0xFF4682B4);
    final blanket = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(bedCenter.dx + 10, bedCenter.dy - 10),
        width: 140,
        height: 50,
      ),
      const Radius.circular(10),
    );
    canvas.drawRRect(blanket, paint);

    // Kussen
    paint.color = Colors.white.withOpacity(0.9);
    final pillow = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(bedCenter.dx - 50, bedCenter.dy - 25),
        width: 60,
        height: 30,
      ),
      const Radius.circular(15),
    );
    canvas.drawRRect(pillow, paint);

    // Hoofd (slapend op kussen)
    final headCenter = Offset(bedCenter.dx - 50, bedCenter.dy - 35);
    paint.color = const Color(0xFFFFDBB5);
    canvas.drawCircle(headCenter, 35, paint);

    // Hoed (fedora op nachtkastje naast bed)
    paint.color = Colors.black87;
    final hatPos = Offset(bedCenter.dx + 90, bedCenter.dy - 10);
    final nightstandHat = RRect.fromRectAndRadius(
      Rect.fromCenter(center: hatPos, width: 40, height: 8),
      const Radius.circular(4),
    );
    canvas.drawRRect(nightstandHat, paint);

    // Ogen (dicht - slapend)
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 3;
    paint.strokeCap = StrokeCap.round;
    paint.color = Colors.black87;

    // Linker oog (gesloten)
    canvas.drawLine(
      Offset(headCenter.dx - 15, headCenter.dy - 5),
      Offset(headCenter.dx - 5, headCenter.dy - 5),
      paint,
    );

    // Rechter oog (gesloten)
    canvas.drawLine(
      Offset(headCenter.dx + 5, headCenter.dy - 5),
      Offset(headCenter.dx + 15, headCenter.dy - 5),
      paint,
    );

    // Mond (tevreden slapend)
    paint.strokeWidth = 2;
    final sleepMouth = Path()
      ..moveTo(headCenter.dx - 8, headCenter.dy + 12)
      ..quadraticBezierTo(
        headCenter.dx,
        headCenter.dy + 15,
        headCenter.dx + 8,
        headCenter.dy + 12,
      );
    canvas.drawPath(sleepMouth, paint);

    // Snor
    final sleepMustache = Path()
      ..moveTo(headCenter.dx - 12, headCenter.dy + 8)
      ..quadraticBezierTo(
        headCenter.dx - 6,
        headCenter.dy + 6,
        headCenter.dx,
        headCenter.dy + 8,
      )
      ..quadraticBezierTo(
        headCenter.dx + 6,
        headCenter.dy + 6,
        headCenter.dx + 12,
        headCenter.dy + 8,
      );
    canvas.drawPath(sleepMustache, paint);

    // Z's (slaap symbool)
    paint.style = PaintingStyle.fill;
    paint.color = Colors.white.withOpacity(0.8);

    final textPainter = TextPainter(
      text: const TextSpan(
        text: 'Z',
        style: TextStyle(
          fontSize: 30,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(headCenter.dx + 30, headCenter.dy - 50));

    final textPainter2 = TextPainter(
      text: const TextSpan(
        text: 'Z',
        style: TextStyle(
          fontSize: 24,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter2.layout();
    textPainter2.paint(canvas, Offset(headCenter.dx + 50, headCenter.dy - 65));

    final textPainter3 = TextPainter(
      text: const TextSpan(
        text: 'Z',
        style: TextStyle(
          fontSize: 18,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter3.layout();
    textPainter3.paint(canvas, Offset(headCenter.dx + 65, headCenter.dy - 75));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Custom painter voor mafia stripfiguur wachtend op vliegveld (travel cooldown)
class _MafiaAirportPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Vliegveld bank/stoel
    final seatCenter = Offset(size.width * 0.5, size.height * 0.65);
    paint.color = const Color(0xFF4A4A4A); // Grijs metaal

    // Stoel frame
    final seatFrame = RRect.fromRectAndRadius(
      Rect.fromCenter(center: seatCenter, width: 100, height: 50),
      const Radius.circular(8),
    );
    canvas.drawRRect(seatFrame, paint);

    // Rugleuning
    final backrest = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(seatCenter.dx, seatCenter.dy - 40),
        width: 100,
        height: 60,
      ),
      const Radius.circular(8),
    );
    canvas.drawRRect(backrest, paint);

    // Lichaam (zittend)
    final bodyCenter = Offset(seatCenter.dx, seatCenter.dy - 10);
    paint.color = const Color(0xFF2C2C2C); // Donker pak
    final body = RRect.fromRectAndRadius(
      Rect.fromCenter(center: bodyCenter, width: 70, height: 80),
      const Radius.circular(15),
    );
    canvas.drawRRect(body, paint);

    // Hoofd
    final headCenter = Offset(seatCenter.dx, seatCenter.dy - 60);
    paint.color = const Color(0xFFFFDBB5);
    canvas.drawCircle(headCenter, 35, paint);

    // Hoed (fedora)
    paint.color = Colors.black87;
    final hatBrim = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(headCenter.dx, headCenter.dy - 35),
        width: 80,
        height: 10,
      ),
      const Radius.circular(5),
    );
    canvas.drawRRect(hatBrim, paint);

    final hatCrown = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(headCenter.dx, headCenter.dy - 47),
        width: 60,
        height: 28,
      ),
      const Radius.circular(5),
    );
    canvas.drawRRect(hatCrown, paint);

    // Ogen (verveeld wachtend)
    paint.color = Colors.white;
    canvas.drawCircle(Offset(headCenter.dx - 12, headCenter.dy - 5), 7, paint);
    canvas.drawCircle(Offset(headCenter.dx + 12, headCenter.dy - 5), 7, paint);

    paint.color = Colors.black;
    canvas.drawCircle(Offset(headCenter.dx - 12, headCenter.dy - 5), 4, paint);
    canvas.drawCircle(Offset(headCenter.dx + 12, headCenter.dy - 5), 4, paint);

    // Wenkbrauwen (verveeld)
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 3;
    paint.strokeCap = StrokeCap.round;
    paint.color = const Color(0xFF8B4513);

    canvas.drawLine(
      Offset(headCenter.dx - 18, headCenter.dy - 15),
      Offset(headCenter.dx - 6, headCenter.dy - 15),
      paint,
    );
    canvas.drawLine(
      Offset(headCenter.dx + 6, headCenter.dy - 15),
      Offset(headCenter.dx + 18, headCenter.dy - 15),
      paint,
    );

    // Neus
    paint.style = PaintingStyle.fill;
    paint.color = const Color(0xFFE8C4A0);
    canvas.drawCircle(Offset(headCenter.dx, headCenter.dy + 3), 7, paint);

    // Mond (neutraal/verveeld)
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 2;
    paint.color = const Color(0xFF8B0000);
    canvas.drawLine(
      Offset(headCenter.dx - 10, headCenter.dy + 15),
      Offset(headCenter.dx + 10, headCenter.dy + 15),
      paint,
    );

    // Snor
    final airportMustache = Path()
      ..moveTo(headCenter.dx - 15, headCenter.dy + 10)
      ..quadraticBezierTo(
        headCenter.dx - 8,
        headCenter.dy + 8,
        headCenter.dx,
        headCenter.dy + 10,
      )
      ..quadraticBezierTo(
        headCenter.dx + 8,
        headCenter.dy + 8,
        headCenter.dx + 15,
        headCenter.dy + 10,
      );
    canvas.drawPath(airportMustache, paint);

    // Koffer naast hem
    paint.style = PaintingStyle.fill;
    paint.color = const Color(0xFF8B4513); // Bruin leer
    final suitcase = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(seatCenter.dx + 65, seatCenter.dy + 10),
        width: 40,
        height: 50,
      ),
      const Radius.circular(5),
    );
    canvas.drawRRect(suitcase, paint);

    // Handvat koffer
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 4;
    paint.color = Colors.black87;
    final handle = Path()
      ..moveTo(seatCenter.dx + 55, seatCenter.dy - 15)
      ..quadraticBezierTo(
        seatCenter.dx + 65,
        seatCenter.dy - 22,
        seatCenter.dx + 75,
        seatCenter.dy - 15,
      );
    canvas.drawPath(handle, paint);

    // Vliegtuig icon (in de lucht)
    paint.style = PaintingStyle.fill;
    paint.color = Colors.white.withOpacity(0.6);
    final plane = Path()
      ..moveTo(size.width * 0.2, size.height * 0.15)
      ..lineTo(size.width * 0.25, size.height * 0.13)
      ..lineTo(size.width * 0.3, size.height * 0.15)
      ..lineTo(size.width * 0.27, size.height * 0.17)
      ..close();
    canvas.drawPath(plane, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
