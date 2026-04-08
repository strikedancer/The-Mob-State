import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import 'dart:convert';
import '../../services/api_client.dart';
import '../../models/casino_game.dart';
import '../../utils/formatters.dart';
import '../../utils/top_right_notification.dart';

class BlackjackScreen extends StatefulWidget {
  final CasinoGame game;

  const BlackjackScreen({super.key, required this.game});

  @override
  State<BlackjackScreen> createState() => _BlackjackScreenState();
}

class _BlackjackScreenState extends State<BlackjackScreen> {
  final ApiClient _apiClient = ApiClient();
  
  int _betAmount = 100;
  bool _isPlaying = false;
  List<int> _playerCards = [];
  List<int> _dealerCards = [];
  int _playerTotal = 0;
  int _dealerTotal = 0;

  @override
  void initState() {
    super.initState();
    _betAmount = widget.game.minBet;
  }

  Future<void> _play() async {
    if (_isPlaying) return;

    setState(() {
      _isPlaying = true;
      _playerCards = [];
      _dealerCards = [];
    });

    try {
      final response = await _apiClient.post(
        '/casino/blackjack/play',
        {'betAmount': _betAmount, 'action': 'start'},
      );
      final data = jsonDecode(response.body);

      if (data['event'] != null && data['params'] != null) {
        // Check for error event
        if (data['event'] == 'casino.error') {
          setState(() {
            _isPlaying = false;
          });
          String errorReason = data['params']['reason'] ?? 'Fout bij spelen';
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
        print('🃏 Blackjack response params: $params');
        final won = params['won'] ?? false;
        final playerCards = List<int>.from(params['playerHand'] ?? params['playerCards'] ?? []);
        final dealerCards = List<int>.from(params['dealerHand'] ?? params['dealerCards'] ?? []);
        print('🃏 Parsed cards - Player: $playerCards, Dealer: $dealerCards');
        final playerTotal = params['playerTotal'] ?? 0;
        final dealerTotal = params['dealerTotal'] ?? 0;
        final payout = params['payout'] ?? 0;
        final profit = params['profit'] ?? (won ? payout - _betAmount : -_betAmount);
        final casinoBankrupt = params['casinoBankrupt'] ?? false;

        setState(() {
          _playerCards = playerCards;
          _dealerCards = dealerCards;
          _playerTotal = playerTotal;
          _dealerTotal = dealerTotal;
          _isPlaying = false;
        });

        if (casinoBankrupt) {
          await Future.delayed(Duration(milliseconds: 500));
          _showBankruptcyDialog();
          return;
        }

        await Future.delayed(Duration(milliseconds: 500));
        _showResultDialog(won, payout, profit, playerTotal, dealerTotal);
      } else {
        setState(() {
          _isPlaying = false;
        });
        _showError(data['params']?['reason'] ?? 'Fout bij spelen');
      }
    } catch (e) {
      setState(() {
        _isPlaying = false;
      });
      _showError('Netwerkfout: $e');
    }
  }

  String _getCardImage(int cardValue) {
    // Backend returns card values 1-10 (1=Ace, 2-9=number, 10=10/J/Q/K)
    // Pick a random suit for display (we just cycle through for variety)
    final suits = ['hearts', 'diamonds', 'clubs', 'spades'];
    final suit = suits[cardValue % 4];
    
    String filename;
    if (cardValue == 1) {
      filename = 'ace';
    } else if (cardValue == 10) {
      // For 10-value cards, randomly show 10, jack, queen, or king
      final faceCards = ['10', 'jack', 'queen', 'king'];
      filename = faceCards[DateTime.now().millisecondsSinceEpoch % 4];
    } else {
      filename = cardValue.toString();
    }
    
    return 'images/casino/cards/$suit/${filename}_$suit.png';
  }

  Widget _buildCardRow(List<int> cards, String label, int total) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: cards.map((card) => Padding(
            padding: EdgeInsets.symmetric(horizontal: 2),
            child: Image.asset(
              _getCardImage(card),
              width: 40,
              height: 60,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 40,
                height: 60,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(child: Text('$card', style: TextStyle(fontSize: 10))),
              ),
            ),
          )).toList(),
        ),
        SizedBox(height: 4),
        Text('Totaal: $total', style: TextStyle(fontSize: 12)),
      ],
    );
  }

  void _showResultDialog(bool won, int payout, int profit, int playerTotal, int dealerTotal) {
    String message = won 
        ? 'Je hebt €${formatCompactNumber(payout)} gewonnen!'
        : 'Je hebt verloren';
    
    if (playerTotal == 21) {
      message = '🎉 BLACKJACK! €${formatCompactNumber(payout)}';
    }

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
            _buildCardRow(_playerCards, 'Jouw kaarten', playerTotal),
            SizedBox(height: 12),
            _buildCardRow(_dealerCards, 'Dealer kaarten', dealerTotal),
            SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
              _play();
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
        title: Text('🃏 ${widget.game.name}'),
        backgroundColor: Colors.green[900],
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.green[900]!,
              Colors.green[700]!,
              Colors.green[900]!,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Dealer Cards
              if (_dealerCards.isNotEmpty) ...[
                Text(
                  'Dealer: $_dealerTotal',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _dealerCards.map((card) => _buildCard(card)).toList(),
                ),
                SizedBox(height: 30),
              ],
              
              // Player Cards
              if (_playerCards.isNotEmpty) ...[
                Text(
                  'Jij: $_playerTotal',
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _playerCards.map((card) => _buildCard(card)).toList(),
                ),
                SizedBox(height: 40),
              ],

              // Bet Controls
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

              // Play Button
              ElevatedButton(
                onPressed: _isPlaying ? null : _play,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: _isPlaying
                    ? SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        'SPELEN!',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(int value) {
    return Container(
      width: 60,
      height: 90,
      margin: EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          _getCardImage(value),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[400]!, width: 2),
            ),
            child: Center(
              child: Text(
                value.toString(),
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBetButton(String label, int amount) {
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
      return _buildBetButton(label, amount);
    }).toList();
  }
}
