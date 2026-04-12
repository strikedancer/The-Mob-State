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
      final response = await _apiClient.post(
        '/casino/slots/spin',
        {'betAmount': _betAmount},
      );
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
        final resultReels = params['result'];
        final payout = params['payout'] ?? 0;
        final profit = params['profit'] ?? (won ? payout - _betAmount : -_betAmount);
        final casinoBankrupt = params['casinoBankrupt'] ?? false;

        // Debug logging
        print('[SlotMachine] Backend response: $data');
        print('[SlotMachine] Result reels: $resultReels');

        // Parse reels array
        List<String> finalReels = ['🍒', '🍒', '🍒']; // Default fallback
        if (resultReels != null && resultReels is List && resultReels.isNotEmpty) {
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
              won ? 'assets/images/casino/win_effect.png' : 'assets/images/casino/lose_effect.png',
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
    showTopRightFromSnackBar(context, 
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.purple[900]!,
              Colors.purple[700]!,
              Colors.red[900]!,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Slot Machine Display
              _buildSlotMachine(),
              SizedBox(height: 40),
              // Bet Controls
              _buildBetControls(),
              SizedBox(height: 20),
              // Spin Button
              _buildSpinButton(),
              SizedBox(height: 20),
              // Paytable
              _buildPaytable(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSlotMachine() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.amber[700],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.amber[900]!, width: 4),
        boxShadow: [
          BoxShadow(
            color: Colors.black45,
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _reels.map((symbol) {
          return Container(
            width: 80,
            height: 100,
            margin: EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[400]!, width: 2),
            ),
            child: Center(
              child: Text(
                symbol,
                style: TextStyle(fontSize: 50),
              ),
            ),
          );
        }).toList(),
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
          Text(
            'Inzet',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
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
                _betAmount = amount.clamp(widget.game.minBet, widget.game.maxBet);
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
        label = '€${(amount / 1000000).toStringAsFixed(amount % 1000000 == 0 ? 0 : 1)}M';
      } else if (amount >= 1000) {
        label = '€${(amount / 1000).toStringAsFixed(amount % 1000 == 0 ? 0 : 1)}K';
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
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
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
          Text(
            symbols,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
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
