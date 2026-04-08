import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:math';
import '../../services/api_client.dart';
import '../../models/casino_game.dart';
import '../../utils/formatters.dart';
import '../../utils/top_right_notification.dart';

class DiceScreen extends StatefulWidget {
  final CasinoGame game;

  const DiceScreen({super.key, required this.game});

  @override
  State<DiceScreen> createState() => _DiceScreenState();
}

class _DiceScreenState extends State<DiceScreen> {
  final ApiClient _apiClient = ApiClient();
  
  int _betAmount = 100;
  bool _isRolling = false;
  String _prediction = 'high';
  int _dice1 = 1;
  int _dice2 = 1;
  Timer? _rollTimer;

  @override
  void initState() {
    super.initState();
    _betAmount = widget.game.minBet;
  }

  @override
  void dispose() {
    _rollTimer?.cancel();
    super.dispose();
  }

  Future<void> _roll() async {
    if (_isRolling) return;

    setState(() {
      _isRolling = true;
    });

    // Animate dice rolling
    _rollTimer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      setState(() {
        _dice1 = Random().nextInt(6) + 1;
        _dice2 = Random().nextInt(6) + 1;
      });
    });

    try {
      final response = await _apiClient.post(
        '/casino/dice/roll',
        {
          'betAmount': _betAmount,
          'prediction': _prediction,
        },
      );
      final data = jsonDecode(response.body);

      await Future.delayed(Duration(seconds: 2));
      _rollTimer?.cancel();

      if (data['event'] != null && data['params'] != null) {
        // Check for error event
        if (data['event'] == 'casino.error') {
          setState(() {
            _isRolling = false;
          });
          String errorReason = data['params']['reason'] ?? 'Fout bij gooien';
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
        final dice1 = params['dice1'] ?? 1;
        final dice2 = params['dice2'] ?? 1;
        final total = params['total'] ?? 2;
        final payout = params['payout'] ?? 0;
        final profit = params['profit'] ?? (won ? payout - _betAmount : -_betAmount);
        final casinoBankrupt = params['casinoBankrupt'] ?? false;

        setState(() {
          _dice1 = dice1;
          _dice2 = dice2;
          _isRolling = false;
        });

        if (casinoBankrupt) {
          await Future.delayed(Duration(milliseconds: 500));
          _showBankruptcyDialog();
          return;
        }

        _showResultDialog(won, payout, profit, total);
      } else {
        setState(() {
          _isRolling = false;
        });
        _showError(data['params']?['reason'] ?? 'Fout bij gooien');
      }
    } catch (e) {
      _rollTimer?.cancel();
      setState(() {
        _isRolling = false;
      });
      _showError('Netwerkfout: $e');
    }
  }

  void _showResultDialog(bool won, int payout, int profit, int total) {
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
              'Totaal: $total',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
              _roll();
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
        title: Text('🎲 ${widget.game.name}'),
        backgroundColor: Colors.blue[900],
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue[900]!,
              Colors.blue[700]!,
              Colors.indigo[900]!,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Dice Display
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildDice(_dice1),
                  SizedBox(width: 20),
                  _buildDice(_dice2),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Totaal: ${_dice1 + _dice2}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 40),

              // Prediction Selection
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
                      'Voorspel',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildPredictionButton('Laag (2-6)', 'low'),
                        SizedBox(width: 10),
                        _buildPredictionButton('Hoog (8-12)', 'high'),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Laag/Hoog betaalt 2x • Exacte score betaalt 6x',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
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

              // Roll Button
              ElevatedButton(
                onPressed: _isRolling ? null : _roll,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: _isRolling
                    ? SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        'GOOI!',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDice(int value) {
    return SizedBox(
      width: 100,
      height: 100,
      child: Image.asset(
        'images/casino/dice/dice_$value.png',
        width: 100,
        height: 100,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          // Fallback naar Unicode symbool als afbeelding niet gevonden wordt
          return Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black45,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Center(
              child: Text(
                _getDiceSymbol(value),
                style: TextStyle(fontSize: 48),
              ),
            ),
          );
        },
      ),
    );
  }

  String _getDiceSymbol(int value) {
    switch (value) {
      case 1: return '⚀';
      case 2: return '⚁';
      case 3: return '⚂';
      case 4: return '⚃';
      case 5: return '⚄';
      case 6: return '⚅';
      default: return '⚀';
    }
  }

  Widget _buildPredictionButton(String label, String prediction) {
    final isSelected = _prediction == prediction;
    return ElevatedButton(
      onPressed: () => setState(() => _prediction = prediction),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.amber : Colors.white24,
        foregroundColor: isSelected ? Colors.black : Colors.white,
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
