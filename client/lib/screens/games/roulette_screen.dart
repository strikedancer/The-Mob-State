import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import 'dart:convert';
import 'dart:math';
import '../../services/api_client.dart';
import '../../models/casino_game.dart';
import '../../utils/formatters.dart';
import '../../utils/top_right_notification.dart';

class RouletteScreen extends StatefulWidget {
  final CasinoGame game;

  const RouletteScreen({super.key, required this.game});

  @override
  State<RouletteScreen> createState() => _RouletteScreenState();
}

class _RouletteScreenState extends State<RouletteScreen>
    with SingleTickerProviderStateMixin {
  final ApiClient _apiClient = ApiClient();

  int _betAmount = 100;
  bool _isSpinning = false;
  String _betType = 'red';
  int? _betNumber;
  int _result = 0;

  late AnimationController _spinController;
  late Animation<double> _spinAnimation;

  final _redNumbers = [
    1,
    3,
    5,
    7,
    9,
    12,
    14,
    16,
    18,
    19,
    21,
    23,
    25,
    27,
    30,
    32,
    34,
    36,
  ];

  @override
  void initState() {
    super.initState();
    _betAmount = widget.game.minBet;
    _spinController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _spinAnimation = CurvedAnimation(
      parent: _spinController,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _spinController.dispose();
    super.dispose();
  }

  Future<void> _spin() async {
    if (_isSpinning) return;

    setState(() {
      _isSpinning = true;
    });

    _spinController.reset();
    _spinController.forward();

    try {
      final response = await _apiClient.post('/casino/roulette/spin', {
        'betAmount': _betAmount,
        'betType': _betType,
        'betValue': _betNumber ?? (_betType == 'red' ? 'red' : _betType),
      });
      final data = jsonDecode(response.body);

      await Future.delayed(const Duration(seconds: 3));

      if (data['event'] != null && data['params'] != null) {
        if (data['event'] == 'casino.error') {
          setState(() {
            _isSpinning = false;
          });
          String errorReason = data['params']['reason'] ?? 'Fout bij draaien';
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
        final result = params['result'] ?? 0;
        final payout = params['payout'] ?? 0;
        final profit =
            params['profit'] ?? (won ? payout - _betAmount : -_betAmount);
        final casinoBankrupt = params['casinoBankrupt'] ?? false;

        setState(() {
          _result = result;
          _isSpinning = false;
        });

        if (casinoBankrupt) {
          await Future.delayed(const Duration(milliseconds: 500));
          _showBankruptcyDialog();
          return;
        }

        await Future.delayed(const Duration(milliseconds: 500));
        _showResultDialog(won, payout, profit, result);
      } else {
        setState(() {
          _isSpinning = false;
        });
        _showError(data['params']?['reason'] ?? 'Fout bij draaien');
      }
    } catch (e) {
      setState(() {
        _isSpinning = false;
      });
      _showError('Netwerkfout: $e');
    }
  }

  void _showResultDialog(bool won, int payout, int profit, int result) {
    final isRed = _redNumbers.contains(result);
    final color = result == 0 ? 'groen' : (isRed ? 'rood' : 'zwart');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(won ? 'Gewonnen!' : 'Verloren'),
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
            const SizedBox(height: 16),
            Text(
              'Nummer: $result ($color)',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              won
                  ? 'Je hebt EUR ${formatCompactNumber(payout)} gewonnen!'
                  : 'Je hebt EUR ${formatCompactNumber(_betAmount)} verloren',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              '${profit >= 0 ? AppLocalizations.of(context)!.profit : AppLocalizations.of(context)!.loss}: EUR ${formatCompactNumber(profit.abs())}',
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
            child: const Text('OK'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _spin();
            },
            child: const Text('Opnieuw'),
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
        title: const Text(
          'Casino Failliet!',
          style: TextStyle(color: Colors.red),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/casino/bankrupt.png',
              width: 300,
              height: 200,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.warning, color: Colors.red, size: 100),
            ),
            const SizedBox(height: 16),
            const Text(
              'Het casino is failliet gegaan!\n\n'
              'De eigenaar had niet genoeg geld in de kas om alle uitbetalingen te dekken.\n\n'
              'Het casino is nu gesloten en kan opnieuw gekocht worden.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('Terug naar Casino'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final contentMaxWidth = width > 720 ? 620.0 : width - 24;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.game.name),
        backgroundColor: Colors.red[900],
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF0F3A2D),
                    Color(0xFF0A2B22),
                    Color(0xFF071A15),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: contentMaxWidth),
                  child: Column(
                    children: [
                      _buildRouletteTable(),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.black45,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.white24),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'Kies je inzet',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              alignment: WrapAlignment.center,
                              children: [
                                _buildBetTypeButton('Rood', 'red', Colors.red),
                                _buildBetTypeButton(
                                  'Zwart',
                                  'black',
                                  Colors.black,
                                ),
                                _buildBetTypeButton(
                                  'Even',
                                  'even',
                                  Colors.blue,
                                ),
                                _buildBetTypeButton(
                                  'Oneven',
                                  'odd',
                                  Colors.orange,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.black45,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.white24),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'Inzet',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'EUR ${formatCompactNumber(_betAmount)}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              alignment: WrapAlignment.center,
                              spacing: 8,
                              runSpacing: 8,
                              children: _getBetButtons(),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isSpinning ? null : _spin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: _isSpinning
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'DRAAI!',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (_result != 0 && !_isSpinning)
                        Text(
                          'Laatste resultaat: $_result',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRouletteTable() {
    final width = MediaQuery.of(context).size.width;
    final wheelSize = width < 420 ? 220.0 : 280.0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.brown.shade700, Colors.brown.shade900],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF6E3F1A), width: 3),
        boxShadow: const [
          BoxShadow(
            color: Colors.black45,
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: wheelSize + 26,
          height: wheelSize + 26,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF1B1B1B),
            border: Border.all(color: Colors.amber.shade700, width: 3),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedBuilder(
                animation: _spinAnimation,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _spinAnimation.value * 2 * pi * 5,
                    alignment: Alignment.center,
                    child: child,
                  );
                },
                child: Image.asset(
                  'assets/images/casino/roulette_wheel.png',
                  width: wheelSize,
                  height: wheelSize,
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.high,
                ),
              ),
              if (!_isSpinning && _result != 0)
                Container(
                  width: 84,
                  height: 84,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black87,
                    border: Border.all(color: Colors.amber, width: 2.5),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/casino/roulette_ball.png',
                          width: 26,
                          height: 26,
                        ),
                        Text(
                          _result.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBetTypeButton(String label, String type, Color color) {
    final isSelected = _betType == type;
    return ElevatedButton(
      onPressed: () => setState(() {
        _betType = type;
        _betNumber = null;
      }),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? color : Colors.white24,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildAmountButton(String label, int amount) {
    final isSelected = _betAmount == amount;
    return ElevatedButton(
      onPressed: () => setState(() => _betAmount = amount),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.amber : Colors.white24,
        foregroundColor: isSelected ? Colors.black : Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
            'EUR ${(amount / 1000000).toStringAsFixed(amount % 1000000 == 0 ? 0 : 1)}M';
      } else if (amount >= 1000) {
        label =
            'EUR ${(amount / 1000).toStringAsFixed(amount % 1000 == 0 ? 0 : 1)}K';
      } else {
        label = 'EUR $amount';
      }
      return _buildAmountButton(label, amount);
    }).toList();
  }
}
