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

class _RouletteScreenState extends State<RouletteScreen> with SingleTickerProviderStateMixin {
  final ApiClient _apiClient = ApiClient();
  
  int _betAmount = 100;
  bool _isSpinning = false;
  String _betType = 'red';
  int? _betNumber;
  int _result = 0;
  
  late AnimationController _spinController;
  late Animation<double> _spinAnimation;

  final _redNumbers = [1, 3, 5, 7, 9, 12, 14, 16, 18, 19, 21, 23, 25, 27, 30, 32, 34, 36];

  @override
  void initState() {
    super.initState();
    _betAmount = widget.game.minBet;
    _spinController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );
    
    // Add easing curve for smooth deceleration
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
      final response = await _apiClient.post(
        '/casino/roulette/spin',
        {
          'betAmount': _betAmount,
          'betType': _betType,
          'betValue': _betNumber ?? (_betType == 'red' ? 'red' : _betType),
        },
      );
      final data = jsonDecode(response.body);

      await Future.delayed(Duration(seconds: 3));

      if (data['event'] != null && data['params'] != null) {
        // Check for error event
        if (data['event'] == 'casino.error') {
          setState(() {
            _isSpinning = false;
          });
          String errorReason = data['params']['reason'] ?? 'Fout bij draaien';
          if (errorReason == 'CASINO_NOT_FOUND') {
            errorReason = 'Casino niet gevonden. Zorg dat het casino gekocht is in dit land.';
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
        final profit = params['profit'] ?? (won ? payout - _betAmount : -_betAmount);
        final casinoBankrupt = params['casinoBankrupt'] ?? false;

        setState(() {
          _result = result;
          _isSpinning = false;
        });

        if (casinoBankrupt) {
          await Future.delayed(Duration(milliseconds: 500));
          _showBankruptcyDialog();
          return;
        }

        await Future.delayed(Duration(milliseconds: 500));
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
        title: Text(won ? '🎉 Gewonnen!' : 'Verloren'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              won ? 'images/casino/win_effect.png' : 'images/casino/lose_effect.png',
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
              'Nummer: $result ($color)',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
    showTopRightFromSnackBar(context, 
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
              'images/casino/bankrupt.png',
              width: 300,
              height: 200,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.warning,
                color: Colors.red,
                size: 100,
              ),
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
              Navigator.of(context).pop();
              Navigator.of(context).pop();
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
        title: Text('🎡 ${widget.game.name}'),
        backgroundColor: Colors.red[900],
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.red[900]!,
              Colors.red[700]!,
              Colors.black,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Roulette Wheel
              Stack(
                alignment: Alignment.center,
                children: [
                  // Spinning wheel with smooth animation
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
                      'images/casino/roulette_wheel.png',
                      width: 300,
                      height: 300,
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.high,
                    ),
                  ),
                  // Ball indicator (optional - shows result number)
                  if (!_isSpinning && _result != 0)
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black54,
                        border: Border.all(color: Colors.amber, width: 3),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'images/casino/roulette_ball.png',
                              width: 30,
                              height: 30,
                            ),
                            Text(
                              _result.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 40),

              // Bet Type Selection
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    Text(
                      'Kies je inzet',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    SizedBox(height: 15),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      alignment: WrapAlignment.center,
                      children: [
                        _buildBetTypeButton('Rood', 'red', Colors.red),
                        _buildBetTypeButton('Zwart', 'black', Colors.black),
                        _buildBetTypeButton('Even', 'even', Colors.blue),
                        _buildBetTypeButton('Oneven', 'odd', Colors.orange),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Bet Amount
              Container(
                margin: EdgeInsets.symmetric(horizontal: 40),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    Text(
                      'Inzet',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '€${formatCompactNumber(_betAmount)}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 10,
                      runSpacing: 10,
                      children: _getBetButtons(),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),

              // Spin Button
              ElevatedButton(
                onPressed: _isSpinning ? null : _spin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: _isSpinning
                    ? SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        'DRAAI!',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
      child: Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildAmountButton(String label, int amount) {
    final isSelected = _betAmount == amount;
    return ElevatedButton(
      onPressed: () => setState(() => _betAmount = amount),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.amber : Colors.white24,
        foregroundColor: isSelected ? Colors.black : Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      child: Text(label),
    );
  }

  List<Widget> _getBetButtons() {
    final minBet = widget.game.minBet;
    final maxBet = widget.game.maxBet;
    
    // Generate bet amounts based on min and max
    List<int> amounts = [];
    
    // Always add minBet
    amounts.add(minBet);
    
    // Add intermediate values
    if (maxBet >= 100) amounts.add(100);
    if (maxBet >= 500) amounts.add(500);
    if (maxBet >= 1000) amounts.add(1000);
    if (maxBet >= 5000) amounts.add(5000);
    if (maxBet >= 10000) amounts.add(10000);
    if (maxBet >= 25000) amounts.add(25000);
    if (maxBet >= 50000) amounts.add(50000);
    if (maxBet >= 100000) amounts.add(100000);
    
    // Always add maxBet if it's not already in the list
    if (!amounts.contains(maxBet)) {
      amounts.add(maxBet);
    }
    
    // Remove duplicates and sort
    amounts = amounts.toSet().toList()..sort();
    
    // Generate buttons
    return amounts.map((amount) {
      String label;
      if (amount >= 1000000) {
        label = '€${(amount / 1000000).toStringAsFixed(amount % 1000000 == 0 ? 0 : 1)}M';
      } else if (amount >= 1000) {
        label = '€${(amount / 1000).toStringAsFixed(amount % 1000 == 0 ? 0 : 1)}K';
      } else {
        label = '€$amount';
      }
      return _buildAmountButton(label, amount);
    }).toList();
  }
}
