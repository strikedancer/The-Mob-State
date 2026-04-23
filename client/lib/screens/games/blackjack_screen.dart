import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import 'dart:convert';
import 'dart:math';
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
      _playerTotal = 0;
      _dealerTotal = 0;
    });

    try {
      final response = await _apiClient.post('/casino/blackjack/play', {
        'betAmount': _betAmount,
        'action': 'start',
      });
      final data = jsonDecode(response.body);

      if (data['event'] != null && data['params'] != null) {
        if (data['event'] == 'casino.error') {
          setState(() {
            _isPlaying = false;
          });
          String errorReason = data['params']['reason'] ?? 'Fout bij spelen';
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
        final playerCards = List<int>.from(
          params['playerHand'] ?? params['playerCards'] ?? [],
        );
        final dealerCards = List<int>.from(
          params['dealerHand'] ?? params['dealerCards'] ?? [],
        );
        final playerTotal = params['playerTotal'] ?? 0;
        final dealerTotal = params['dealerTotal'] ?? 0;
        final payout = params['payout'] ?? 0;
        final profit =
            params['profit'] ?? (won ? payout - _betAmount : -_betAmount);
        final casinoBankrupt = params['casinoBankrupt'] ?? false;

        await _animateDealSequence(
          playerCards: playerCards,
          dealerCards: dealerCards,
        );

        if (!mounted) return;

        setState(() {
          _playerTotal = playerTotal;
          _dealerTotal = dealerTotal;
          _isPlaying = false;
        });

        if (casinoBankrupt) {
          await Future.delayed(const Duration(milliseconds: 500));
          _showBankruptcyDialog();
          return;
        }

        await Future.delayed(const Duration(milliseconds: 500));
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

  Future<void> _animateDealSequence({
    required List<int> playerCards,
    required List<int> dealerCards,
  }) async {
    if (!mounted) return;

    setState(() {
      _playerCards = [];
      _dealerCards = [];
      _playerTotal = 0;
      _dealerTotal = 0;
    });

    final rounds = max(playerCards.length, dealerCards.length);

    for (int i = 0; i < rounds; i++) {
      if (!mounted) return;
      if (i < playerCards.length) {
        setState(() {
          _playerCards = [..._playerCards, playerCards[i]];
          _playerTotal = _calculateHandTotal(_playerCards);
        });
        await Future.delayed(const Duration(milliseconds: 260));
      }

      if (!mounted) return;
      if (i < dealerCards.length) {
        setState(() {
          _dealerCards = [..._dealerCards, dealerCards[i]];
          _dealerTotal = _calculateHandTotal(_dealerCards);
        });
        await Future.delayed(const Duration(milliseconds: 260));
      }
    }
  }

  int _calculateHandTotal(List<int> cards) {
    int total = cards.fold(0, (sum, card) => sum + card);
    int aces = cards.where((card) => card == 1).length;

    while (aces > 0 && total + 10 <= 21) {
      total += 10;
      aces--;
    }

    return total;
  }

  String _getCardImage(int cardValue) {
    final suits = ['hearts', 'diamonds', 'clubs', 'spades'];
    final suit = suits[cardValue % 4];

    String filename;
    if (cardValue == 1) {
      filename = 'ace';
    } else if (cardValue == 10) {
      final faceCards = ['10', 'jack', 'queen', 'king'];
      filename = faceCards[DateTime.now().millisecondsSinceEpoch % 4];
    } else {
      filename = cardValue.toString();
    }

    return 'assets/images/casino/cards/$suit/${filename}_$suit.png';
  }

  Widget _buildCardRow(List<int> cards, String label, int total) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: cards
              .map(
                (card) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
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
                      child: Center(
                        child: Text(
                          '$card',
                          style: const TextStyle(fontSize: 10),
                        ),
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 4),
        Text('Totaal: $total', style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  void _showResultDialog(
    bool won,
    int payout,
    int profit,
    int playerTotal,
    int dealerTotal,
  ) {
    String message = won
        ? 'Je hebt €${formatCompactNumber(payout)} gewonnen!'
        : 'Je hebt verloren';

    if (playerTotal == 21) {
      message = 'BLACKJACK! €${formatCompactNumber(payout)}';
    }

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
            _buildCardRow(_playerCards, 'Jouw kaarten', playerTotal),
            const SizedBox(height: 12),
            _buildCardRow(_dealerCards, 'Dealer kaarten', dealerTotal),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
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
            child: const Text('OK'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _play();
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.game.name),
        backgroundColor: Colors.green[900],
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isPortrait = constraints.maxHeight > constraints.maxWidth;
                return Image.asset(
                  isPortrait
                      ? 'assets/images/casino/casino_background_portrait.png'
                      : 'assets/images/casino/casino_background_landscape.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Container(color: const Color(0xFF113322)),
                );
              },
            ),
          ),
          Positioned.fill(
            child: Container(color: Colors.black.withValues(alpha: 0.32)),
          ),
          SafeArea(
            child: _buildScaledGameCanvas(
              width: 620,
              height: 880,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildBlackjackTable(),
                    const SizedBox(height: 24),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.black45,
                        borderRadius: BorderRadius.circular(15),
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
                          const SizedBox(height: 10),
                          Text(
                            '€${formatCompactNumber(_betAmount)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 10,
                            runSpacing: 10,
                            children: _getBetButtons(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    ElevatedButton(
                      onPressed: _isPlaying ? null : _play,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 60,
                          vertical: 20,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: _isPlaying
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text(
                              'SPELEN!',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
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

  Widget _buildBlackjackTable() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.green.shade800, Colors.green.shade900],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF7A4B1F), width: 4),
        boxShadow: const [
          BoxShadow(
            color: Colors.black45,
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Dealer: $_dealerTotal',
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
          const SizedBox(height: 10),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: _dealerCards
                .asMap()
                .entries
                .map((entry) => _buildCard(entry.value, entry.key, 'dealer'))
                .toList(),
          ),
          const SizedBox(height: 24),
          Text(
            'Jij: $_playerTotal',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: _playerCards
                .asMap()
                .entries
                .map((entry) => _buildCard(entry.value, entry.key, 'player'))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(int value, int index, String owner) {
    return Container(
      key: ValueKey('$owner-$index-$value'),
      width: 60,
      height: 90,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.72, end: 1.0),
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutBack,
        builder: (context, scale, child) {
          return Transform.scale(scale: scale, child: child);
        },
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
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
}
