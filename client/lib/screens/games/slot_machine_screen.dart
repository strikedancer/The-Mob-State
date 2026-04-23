import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import '../../services/api_client.dart';
import '../../models/casino_game.dart';
import '../../utils/formatters.dart';
import '../../utils/top_right_notification.dart';

class SlotMachineScreen extends StatefulWidget {
  final CasinoGame game;

  const SlotMachineScreen({super.key, required this.game});

  @override
  State<SlotMachineScreen> createState() => _SlotMachineScreenState();
}

class _SlotMachineScreenState extends State<SlotMachineScreen>
    with TickerProviderStateMixin {
  final ApiClient _apiClient = ApiClient();

  int _betAmount = 100;
  bool _isSpinning = false;
  List<String> _reels = ['🍒', '🍒', '🍒'];

  final List<String> _symbols = ['🍒', '🍋', '🍊', '🍇', '💎', '7️⃣'];

  late AnimationController _animationController;
  Timer? _spinTimer;

  @override
  void initState() {
    super.initState();
    _betAmount = widget.game.minBet;
    _animationController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _spinTimer?.cancel();
    super.dispose();
  }

  Future<void> _spin() async {
    if (_isSpinning) return;

    setState(() {
      _isSpinning = true;
    });

    // Animate reels spinning
    _spinTimer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      setState(() {
        _reels = [
          _symbols[Random().nextInt(_symbols.length)],
          _symbols[Random().nextInt(_symbols.length)],
          _symbols[Random().nextInt(_symbols.length)],
        ];
      });
    });

    // Call backend
    try {
      final response = await _apiClient.post('/casino/slots/spin', {
        'betAmount': _betAmount,
      });
      final data = jsonDecode(response.body);

      // Stop spinning after result
      await Future.delayed(Duration(seconds: 2));
      _spinTimer?.cancel();

      // Parse event-based response
      if (data['event'] != null && data['params'] != null) {
        // Check for error event
        if (data['event'] == 'casino.error') {
          setState(() {
            _isSpinning = false;
          });
          String errorReason = data['params']['reason'] ?? 'Fout bij gokken';
          if (errorReason == 'CASINO_NOT_FOUND') {
            errorReason =
                'Casino niet gevonden. Zorg dat het casino gekocht is in dit land.';
          } else if (errorReason == 'INSUFFICIENT_FUNDS') {
            errorReason = 'Niet genoeg geld';
          } else if (errorReason == 'INSUFFICIENT_BANKROLL') {
            errorReason = 'Casino kas te laag voor deze uitbetaling';
          }
          _showError(errorReason);
          return;
        }

        final params = data['params'];
        final won = params['won'] ?? false;
        final resultReels = params['result'];
        final payout = params['payout'] ?? 0;
        final profit =
            params['profit'] ?? (won ? payout - _betAmount : -_betAmount);
        final casinoBankrupt = params['casinoBankrupt'] ?? false;

        // Debug logging
        print('[SlotMachine] Backend response: $data');
        print('[SlotMachine] Result reels: $resultReels');

        // Parse reels array
        List<String> finalReels = ['🍒', '🍒', '🍒']; // Default fallback
        if (resultReels != null &&
            resultReels is List &&
            resultReels.isNotEmpty) {
          finalReels = List<String>.from(resultReels);
        }

        setState(() {
          _reels = finalReels;
          _isSpinning = false;
        });

        print('[SlotMachine] Final reels set to: $_reels');

        // Check for casino bankruptcy
        if (casinoBankrupt) {
          await Future.delayed(Duration(milliseconds: 500));
          _showBankruptcyDialog();
          return;
        }

        // Show result dialog
        await Future.delayed(Duration(milliseconds: 500));
        _showResultDialog(won, payout, profit);
      } else {
        setState(() {
          _isSpinning = false;
        });
        _showError(data['params']?['reason'] ?? 'Fout bij gokken');
      }
    } catch (e) {
      _spinTimer?.cancel();
      setState(() {
        _isSpinning = false;
      });
      _showError('Netwerkfout: $e');
    }
  }

  void _showResultDialog(bool won, int payout, int profit) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(won ? '🎉 Gewonnen!' : 'Verloren'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              won
                  ? 'assets/images/casino/win_effect.png'
                  : 'assets/images/casino/lose_effect.png',
              width: 200,
              height: 150,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Icon(
                won ? Icons.celebration : Icons.sentiment_dissatisfied,
                size: 100,
                color: won ? Colors.amber : Colors.grey,
              ),
            ),
            SizedBox(height: 16),
            Text(
              won
                  ? 'Je hebt €${formatCompactNumber(payout)} gewonnen!'
                  : 'Je hebt €${formatCompactNumber(_betAmount)} verloren',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              '${profit >= 0 ? AppLocalizations.of(context)!.profit : AppLocalizations.of(context)!.loss}: €${formatCompactNumber(profit.abs())}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: won ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _spin();
            },
            child: Text('Opnieuw'),
          ),
        ],
      ),
    );
  }

  void _showError(String message) {
    showTopRightFromSnackBar(
      context,
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showBankruptcyDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Casino Failliet!', style: TextStyle(color: Colors.red)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/casino/bankrupt.png',
              width: 300,
              height: 200,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) =>
                  Icon(Icons.warning, color: Colors.red, size: 100),
            ),
            SizedBox(height: 16),
            Text(
              '🎰 Het casino is failliet gegaan!\n\n'
              'De eigenaar had niet genoeg geld in de kas om alle uitbetalingen te dekken.\n\n'
              'Het casino is nu gesloten en kan opnieuw gekocht worden.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Return to casino screen
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: Text('Terug naar Casino'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🎰 ${widget.game.name}'),
        backgroundColor: Colors.purple[900],
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
            Positioned.fill(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isPortrait =
                      constraints.maxHeight > constraints.maxWidth;
                  return Image.asset(
                    isPortrait
                        ? 'assets/images/casino/casino_background_portrait.png'
                        : 'assets/images/casino/casino_background_landscape.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Container(color: const Color(0xFF1A1A1A)),
                  );
                },
              ),
            ),
            Positioned.fill(
              child: Container(color: Colors.black.withValues(alpha: 0.35)),
            ),
            SafeArea(
              child: _buildScaledGameCanvas(
                width: 560,
                height: 880,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildSlotMachine(),
                      const SizedBox(height: 20),
                      _buildBetControls(),
                      const SizedBox(height: 14),
                      _buildSpinButton(),
                      const SizedBox(height: 14),
                      _buildPaytable(),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildScaledGameCanvas({
    required Widget child,
    required double width,
    required double height,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Center(
          child: FittedBox(
            fit: BoxFit.contain,
            child: SizedBox(width: width, height: height, child: child),
          ),
        );
      },
    );
  }

  Widget _buildSlotMachine() {
    final width = MediaQuery.of(context).size.width;
    final isNarrow = width < 420;
    final reelFontSize = isNarrow ? 36.0 : 48.0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      constraints: const BoxConstraints(maxWidth: 430),
      child: AspectRatio(
        aspectRatio: 1.45,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.asset(
                  'assets/images/casino/slot_machine.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.amber[700]!, Colors.amber[900]!],
                      ),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.amber[900]!, width: 4),
                    ),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.orange.shade900, width: 3),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black45,
                      blurRadius: 16,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: const Alignment(0, -0.05),
              child: FractionallySizedBox(
                widthFactor: 0.66,
                heightFactor: 0.33,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.38),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white24, width: 1.5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: _reels
                        .map((symbol) => _buildReelCell(symbol, reelFontSize))
                        .toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReelCell(String symbol, double fontSize) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.grey.shade200],
          ),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade400, width: 1.5),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            symbol,
            style: TextStyle(
              fontSize: fontSize,
              shadows: const [
                Shadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(0, 1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBetControls() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black38,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text('Inzet', style: TextStyle(color: Colors.white70, fontSize: 14)),
          SizedBox(height: 8),
          Text(
            '€${formatCompactNumber(_betAmount)}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: _getBetButtons(),
          ),
        ],
      ),
    );
  }

  Widget _buildBetButton(String label, int amount) {
    final isSelected = _betAmount == amount;
    return ElevatedButton(
      onPressed: _isSpinning
          ? null
          : () {
              setState(() {
                _betAmount = amount.clamp(
                  widget.game.minBet,
                  widget.game.maxBet,
                );
              });
            },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.green : Colors.grey[700],
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      child: Text(label),
    );
  }

  List<Widget> _getBetButtons() {
    final minBet = widget.game.minBet;
    final maxBet = widget.game.maxBet;

    List<int> amounts = [];
    amounts.add(minBet);

    if (maxBet >= 100) amounts.add(100);
    if (maxBet >= 500) amounts.add(500);
    if (maxBet >= 1000) amounts.add(1000);
    if (maxBet >= 5000) amounts.add(5000);
    if (maxBet >= 10000) amounts.add(10000);
    if (maxBet >= 25000) amounts.add(25000);
    if (maxBet >= 50000) amounts.add(50000);
    if (maxBet >= 100000) amounts.add(100000);

    if (!amounts.contains(maxBet)) {
      amounts.add(maxBet);
    }

    amounts = amounts.toSet().toList()..sort();

    return amounts.map((amount) {
      String label;
      if (amount >= 1000000) {
        label =
            '€${(amount / 1000000).toStringAsFixed(amount % 1000000 == 0 ? 0 : 1)}M';
      } else if (amount >= 1000) {
        label =
            '€${(amount / 1000).toStringAsFixed(amount % 1000 == 0 ? 0 : 1)}K';
      } else {
        label = '€$amount';
      }
      return _buildBetButton(label, amount);
    }).toList();
  }

  Widget _buildSpinButton() {
    return SizedBox(
      width: 200,
      height: 60,
      child: ElevatedButton(
        onPressed: _isSpinning ? null : _spin,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 8,
        ),
        child: _isSpinning
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                'SPIN!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }

  Widget _buildPaytable() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            'Uitbetalingstabel',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          _buildPaytableRow('7️⃣ 7️⃣ 7️⃣', '100x'),
          _buildPaytableRow('💎 💎 💎', '50x'),
          _buildPaytableRow('🍇 🍇 🍇', '10x'),
          _buildPaytableRow('🍊 🍊 🍊', '5x'),
          _buildPaytableRow('🍋 🍋 🍋', '3x'),
          _buildPaytableRow('🍒 🍒 🍒', '2x'),
        ],
      ),
    );
  }

  Widget _buildPaytableRow(String symbols, String multiplier) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(symbols, style: TextStyle(color: Colors.white, fontSize: 16)),
          Text(
            multiplier,
            style: TextStyle(
              color: Colors.amber[300],
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
