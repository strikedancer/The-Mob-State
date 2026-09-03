import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:math';
import '../../services/api_client.dart';
import '../../models/casino_game.dart';
import '../../utils/formatters.dart';
import '../../utils/top_right_notification.dart';
import '../../utils/casino_play_l10n.dart';

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

    final l10n = AppLocalizations.of(context)!;

    try {
      final response = await _apiClient.post('/casino/dice/roll', {
        'betAmount': _betAmount,
        'prediction': _prediction,
      });
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
            errorReason =
                'Casino niet gevonden. Zorg dat het casino gekocht is in dit land.';
          } else if (errorReason == 'INSUFFICIENT_FUNDS') {
            errorReason = 'Niet genoeg geld';
          } else if (errorReason == 'INSUFFICIENT_BANKROLL') {
            errorReason = 'Casino kas te laag voor deze uitbetaling';
          } else if (errorReason == 'MAX_BET') {
            errorReason = l10n.casinoErrMaxBet(widget.game.maxBet.toString());
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
        final profit =
            params['profit'] ?? (won ? payout - _betAmount : -_betAmount);
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
        _showError(
          mapCasinoPlayError(
            l10n,
            data['params']?['reason']?.toString(),
            fallback: l10n.casinoErrThrowFailed,
          ),
        );
      }
    } catch (e) {
      _rollTimer?.cancel();
      setState(() {
        _isRolling = false;
      });
      _showError(l10n.casinoErrNetwork(e.toString()));
    }
  }

  void _showResultDialog(bool won, int payout, int profit, int total) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          won ? l10n.casinoResultYouWonCelebrate : l10n.casinoResultYouLost,
        ),
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
              l10n.casinoDiceTotalShowing('$total'),
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              won
                  ? l10n.casinoWonEuroAmount(formatCompactNumber(payout))
                  : l10n.casinoLostEuroAmount(
                      formatCompactNumber(_betAmount),
                    ),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              '${profit >= 0 ? l10n.profit : l10n.loss}: €${formatCompactNumber(profit.abs())}',
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
            child: Text(l10n.ok),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _roll();
            },
            child: Text(l10n.casinoAgain),
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
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(
          l10n.casinoBankruptTitle,
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
                  Icon(Icons.warning, color: Colors.red, size: 100),
            ),
            SizedBox(height: 16),
            Text(
              l10n.casinoBankruptBody,
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
            child: Text(l10n.casinoBackToCasino),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text('🎲 ${localizedCasinoGameName(l10n, widget.game.id)}'),
        backgroundColor: Colors.blue[900],
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
                      Container(color: const Color(0xFF0D2630)),
                );
              },
            ),
          ),
          Positioned.fill(
            child: Container(color: Colors.black.withValues(alpha: 0.30)),
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
                    // Dice Display
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 16,
                      runSpacing: 16,
                      children: [_buildDice(_dice1), _buildDice(_dice2)],
                    ),
                    SizedBox(height: 20),
                    Text(
                      l10n.casinoDiceTotalShowing('${_dice1 + _dice2}'),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 26),

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
                          Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              _buildPredictionButton(l10n.casinoDiceLowLabel, 'low'),
                              _buildPredictionButton(l10n.casinoDiceHighLabel, 'high'),
                            ],
                          ),
                          SizedBox(height: 10),
                          Text(
                            l10n.casinoDiceOddsHint,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),

                    // Bet Amount
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 8),
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.black45,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          Text(
                            l10n.casinoBetLabel,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
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
                    const SizedBox(height: 18),

                    // Roll Button
                    ElevatedButton(
                      onPressed: _isRolling ? null : _roll,
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
                      child: _isRolling
                          ? SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(
                              l10n.casinoDiceRollButton,
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

  Widget _buildDice(int value) {
    return SizedBox(
      width: 100,
      height: 100,
      child: Image.asset(
        'assets/images/casino/dice/dice_$value.png',
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
      case 1:
        return '⚀';
      case 2:
        return '⚁';
      case 3:
        return '⚂';
      case 4:
        return '⚃';
      case 5:
        return '⚄';
      case 6:
        return '⚅';
      default:
        return '⚀';
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
        label =
            '€${(amount / 1000000).toStringAsFixed(amount % 1000000 == 0 ? 0 : 1)}M';
      } else if (amount >= 1000) {
        label =
            '€${(amount / 1000).toStringAsFixed(amount % 1000 == 0 ? 0 : 1)}K';
      } else {
        label = '€$amount';
      }
      return _buildAmountButton(label, amount);
    }).toList();
  }
}
