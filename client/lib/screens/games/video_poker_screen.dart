import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';

import '../../models/casino_game.dart';
import '../../services/api_client.dart';
import '../../utils/formatters.dart';
import '../../utils/top_right_notification.dart';

class VideoPokerScreen extends StatefulWidget {
  final CasinoGame game;

  const VideoPokerScreen({super.key, required this.game});

  @override
  State<VideoPokerScreen> createState() => _VideoPokerScreenState();
}

class _VideoPokerScreenState extends State<VideoPokerScreen> {
  final ApiClient _apiClient = ApiClient();

  int _betAmount = 100;
  bool _isDrawing = false;
  List<Map<String, dynamic>> _cards = [];
  String _handRank = '';

  @override
  void initState() {
    super.initState();
    _betAmount = widget.game.minBet;
    _cards = List.generate(5, (_) => {'rank': 0, 'suit': 'spades'});
  }

  String _t(String nl, String en) {
    final isNl = Localizations.localeOf(
      context,
    ).languageCode.toLowerCase().startsWith('nl');
    return isNl ? nl : en;
  }

  String _mapSuit(String suit) {
    switch (suit) {
      case 'hearts':
        return '♥';
      case 'diamonds':
        return '♦';
      case 'clubs':
        return '♣';
      default:
        return '♠';
    }
  }

  String _mapRank(int rank) {
    switch (rank) {
      case 11:
        return 'J';
      case 12:
        return 'Q';
      case 13:
        return 'K';
      case 14:
        return 'A';
      default:
        return rank.toString();
    }
  }

  String _labelForHandRank(String rank) {
    switch (rank) {
      case 'royal_flush':
        return _t('Royal Flush', 'Royal Flush');
      case 'straight_flush':
        return _t('Straight Flush', 'Straight Flush');
      case 'four_kind':
        return _t('Four of a Kind', 'Four of a Kind');
      case 'full_house':
        return _t('Full House', 'Full House');
      case 'flush':
        return _t('Flush', 'Flush');
      case 'straight':
        return _t('Straight', 'Straight');
      case 'three_kind':
        return _t('Three of a Kind', 'Three of a Kind');
      case 'two_pair':
        return _t('Two Pair', 'Two Pair');
      case 'jacks_or_better':
        return _t('Jacks or Better', 'Jacks or Better');
      default:
        return _t('Geen winnende hand', 'No winning hand');
    }
  }

  Future<void> _draw() async {
    if (_isDrawing) return;

    setState(() {
      _isDrawing = true;
      _handRank = '';
    });

    for (int i = 0; i < 5; i++) {
      await Future.delayed(const Duration(milliseconds: 120));
      if (!mounted) return;
      setState(() {
        _cards[i] = {
          'rank': Random().nextInt(13) + 2,
          'suit': [
            'hearts',
            'diamonds',
            'clubs',
            'spades',
          ][Random().nextInt(4)],
        };
      });
    }

    try {
      final response = await _apiClient.post('/casino/video-poker/play', {
        'betAmount': _betAmount,
      });
      final data = jsonDecode(response.body);

      if (data['event'] == 'casino.error') {
        setState(() => _isDrawing = false);
        _showError(_mapError(data['params']?['reason']));
        return;
      }

      final params = data['params'] ?? {};
      final won = params['won'] ?? false;
      final payout = params['payout'] ?? 0;
      final profit =
          params['profit'] ?? (won ? payout - _betAmount : -_betAmount);

      setState(() {
        _cards = List<Map<String, dynamic>>.from(params['cards'] ?? []);
        _handRank = params['handRank']?.toString() ?? 'none';
        _isDrawing = false;
      });

      if ((params['casinoBankrupt'] ?? false) == true) {
        _showError(_t('Casino is failliet gegaan', 'The casino went bankrupt'));
        if (mounted) Navigator.pop(context);
        return;
      }

      _showResultDialog(won, payout, profit, _handRank);
    } catch (e) {
      setState(() => _isDrawing = false);
      _showError('Netwerkfout: $e');
    }
  }

  String _mapError(dynamic reason) {
    final value = reason?.toString() ?? '';
    if (value == 'INSUFFICIENT_FUNDS') {
      return _t('Niet genoeg geld', 'Not enough money');
    }
    if (value == 'INSUFFICIENT_BANKROLL') {
      return _t('Casino kas te laag', 'Casino bankroll too low');
    }
    return value.isNotEmpty
        ? value
        : _t('Er ging iets mis', 'Something went wrong');
  }

  void _showError(String message) {
    showTopRightFromSnackBar(
      context,
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showResultDialog(bool won, int payout, int profit, String handRank) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(won ? _t('Gewonnen!', 'You won!') : _t('Verloren', 'Lost')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _labelForHandRank(handRank),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              won
                  ? '${_t('Uitbetaling', 'Payout')}: €${formatCompactNumber(payout)}'
                  : _t('Geen uitbetaling', 'No payout'),
            ),
            const SizedBox(height: 8),
            Text(
              '${_t('Resultaat', 'Result')}: €${formatCompactNumber(profit.abs())}',
              style: TextStyle(
                color: profit >= 0 ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
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
              _draw();
            },
            child: Text(_t('Opnieuw', 'Again')),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(Map<String, dynamic> card) {
    final rank = (card['rank'] ?? 0) as int;
    final suit = (card['suit'] ?? 'spades').toString();
    final suitSymbol = _mapSuit(suit);
    final isRed = suit == 'hearts' || suit == 'diamonds';
    return Container(
      width: 68,
      height: 98,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blueGrey.shade200, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _mapRank(rank),
            style: TextStyle(
              color: isRed ? Colors.red : Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              suitSymbol,
              style: TextStyle(
                color: isRed ? Colors.red : Colors.black,
                fontSize: 24,
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
        final scale = min(
          constraints.maxWidth / width,
          constraints.maxHeight / height,
        );
        final safeScale = scale.clamp(0.55, 1.0);
        return Center(
          child: Transform.scale(
            scale: safeScale,
            child: SizedBox(width: width, height: height, child: child),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final bg = isPortrait
        ? 'assets/images/casino/casino_background_portrait.png'
        : 'assets/images/casino/casino_background_landscape.png';

    return Scaffold(
      appBar: AppBar(
        title: Text('🃍 ${_t('Video Poker', 'Video Poker')}'),
        backgroundColor: const Color(0xFF123158),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              bg,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Container(color: const Color(0xFF151B24)),
            ),
          ),
          Positioned.fill(
            child: Container(color: Colors.black.withValues(alpha: 0.45)),
          ),
          SafeArea(
            child: _buildScaledGameCanvas(
              width: 640,
              height: 900,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.45),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.lightBlue.withValues(alpha: 0.6),
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            _handRank.isEmpty
                                ? _t('Trek je hand', 'Draw your hand')
                                : _labelForHandRank(_handRank),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 8,
                            runSpacing: 8,
                            children: _cards.map(_buildCard).toList(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.42),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '${_t('Inzet', 'Bet')}: €${formatCompactNumber(_betAmount)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [10, 50, 100, 500, 1000, 5000].map((
                              chip,
                            ) {
                              final selected = _betAmount == chip;
                              return ChoiceChip(
                                label: Text(
                                  '€${chip >= 1000 ? '${chip ~/ 1000}K' : chip}',
                                ),
                                selected: selected,
                                onSelected: _isDrawing
                                    ? null
                                    : (_) => setState(() => _betAmount = chip),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: 260,
                      child: ElevatedButton(
                        onPressed: _isDrawing ? null : _draw,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightBlueAccent,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(26),
                          ),
                        ),
                        child: Text(
                          _isDrawing
                              ? _t('Delen...', 'Dealing...')
                              : _t('TREK KAARTEN', 'DRAW CARDS'),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _t(
                          'Uitbetalingstabel: Jacks+ 1x • Two Pair 2x • Trips 3x • Straight 4x • Flush 6x • Full House 9x • Four 25x • Straight Flush 50x • Royal 250x',
                          'Payout table: Jacks+ 1x • Two Pair 2x • Trips 3x • Straight 4x • Flush 6x • Full House 9x • Four 25x • Straight Flush 50x • Royal 250x',
                        ),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
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
}
