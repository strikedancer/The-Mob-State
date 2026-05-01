import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';

import '../../models/casino_game.dart';
import '../../services/api_client.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/formatters.dart';
import '../../utils/top_right_notification.dart';
import '../../utils/casino_play_l10n.dart';

class BaccaratScreen extends StatefulWidget {
  final CasinoGame game;

  const BaccaratScreen({super.key, required this.game});

  @override
  State<BaccaratScreen> createState() => _BaccaratScreenState();
}

class _BaccaratScreenState extends State<BaccaratScreen> {
  final ApiClient _apiClient = ApiClient();
  final Random _random = Random();

  int _betAmount = 100;
  String _betType = 'player';
  bool _isDealing = false;
  List<int> _playerCards = [];
  List<int> _bankerCards = [];
  int _playerTotal = 0;
  int _bankerTotal = 0;
  Timer? _dealTimer;

  @override
  void initState() {
    super.initState();
    _betAmount = widget.game.minBet;
  }

  @override
  void dispose() {
    _dealTimer?.cancel();
    super.dispose();
  }

  Future<void> _play() async {
    if (_isDealing) return;

    setState(() {
      _isDealing = true;
      _playerCards = [];
      _bankerCards = [];
      _playerTotal = 0;
      _bankerTotal = 0;
    });

    _dealTimer = Timer.periodic(const Duration(milliseconds: 120), (_) {
      if (!mounted) return;
      setState(() {
        if (_playerCards.length < 3) {
          _playerCards = [..._playerCards, _random.nextInt(10)];
        }
        if (_bankerCards.length < 3) {
          _bankerCards = [..._bankerCards, _random.nextInt(10)];
        }
      });
    });

    final l10n = AppLocalizations.of(context)!;

    try {
      final response = await _apiClient.post('/casino/baccarat/play', {
        'betAmount': _betAmount,
        'betType': _betType,
      });
      final data = jsonDecode(response.body);

      await Future.delayed(const Duration(milliseconds: 1200));
      _dealTimer?.cancel();

      if (data['event'] == 'casino.error') {
        setState(() => _isDealing = false);
        _showError(
          mapCasinoPlayError(
            l10n,
            data['params']?['reason']?.toString(),
            fallback: l10n.casinoErrBetFailed,
          ),
        );
        return;
      }

      final params = data['params'] ?? {};
      final won = params['won'] ?? false;
      final payout = params['payout'] ?? 0;
      final profit =
          params['profit'] ?? (won ? payout - _betAmount : -_betAmount);
      final winner = params['winner'] ?? 'tie';

      setState(() {
        _playerCards = List<int>.from(params['playerCards'] ?? <int>[]);
        _bankerCards = List<int>.from(params['bankerCards'] ?? <int>[]);
        _playerTotal = params['playerTotal'] ?? 0;
        _bankerTotal = params['bankerTotal'] ?? 0;
        _isDealing = false;
      });

      if ((params['casinoBankrupt'] ?? false) == true) {
        _showError(l10n.casinoBankruptTitle);
        if (mounted) Navigator.pop(context);
        return;
      }

      _showResultDialog(won, payout, profit, winner.toString());
    } catch (e) {
      _dealTimer?.cancel();
      setState(() => _isDealing = false);
      _showError(l10n.casinoErrNetwork(e.toString()));
    }
  }

  String _baccaratWinnerLabel(AppLocalizations l10n, String winner) {
    switch (winner) {
      case 'player':
        return l10n.casinoBaccaratPlayer;
      case 'banker':
        return l10n.casinoBaccaratBanker;
      default:
        return l10n.casinoBaccaratTieBet;
    }
  }

  void _showResultDialog(bool won, int payout, int profit, String winner) {
    final l10n = AppLocalizations.of(context)!;
    final who = _baccaratWinnerLabel(l10n, winner);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          won ? l10n.casinoResultYouWon : l10n.casinoResultYouLost,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.casinoWinnerPrefix(who),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              won
                  ? l10n.casinoPayoutEuro(formatCompactNumber(payout))
                  : l10n.casinoNoPayout,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.casinoResultEuro(formatCompactNumber(profit.abs())),
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
            child: Text(l10n.ok),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _play();
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

  Widget _buildCard(int value) {
    return Container(
      width: 58,
      height: 84,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.amber.shade700, width: 1.2),
      ),
      alignment: Alignment.center,
      child: Text(
        value.toString(),
        style: const TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildCardsRow(
    AppLocalizations l10n,
    String title,
    List<int> cards,
    int total,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.42),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amber.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title • ${l10n.total}: $total',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: cards.map(_buildCard).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildBetTypeButton(String type, String label) {
    final selected = _betType == type;
    return Expanded(
      child: GestureDetector(
        onTap: _isDealing ? null : () => setState(() => _betType = type),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected
                ? Colors.amber
                : Colors.white.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.amber.withValues(alpha: 0.7)),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.black : Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
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
    final l10n = AppLocalizations.of(context)!;
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final bg = isPortrait
        ? 'assets/images/casino/casino_background_portrait.png'
        : 'assets/images/casino/casino_background_landscape.png';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '🃁 ${localizedCasinoGameName(l10n, widget.game.id)}',
        ),
        backgroundColor: const Color(0xFF7A120F),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              bg,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Container(color: const Color(0xFF1B1B1B)),
            ),
          ),
          Positioned.fill(
            child: Container(color: Colors.black.withValues(alpha: 0.45)),
          ),
          SafeArea(
            child: _buildScaledGameCanvas(
              width: 620,
              height: 900,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildCardsRow(
                      l10n,
                      l10n.casinoBaccaratPlayer,
                      _playerCards,
                      _playerTotal,
                    ),
                    const SizedBox(height: 14),
                    _buildCardsRow(
                      l10n,
                      l10n.casinoBaccaratBanker,
                      _bankerCards,
                      _bankerTotal,
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        _buildBetTypeButton(
                          'player',
                          l10n.casinoBaccaratPlayer,
                        ),
                        const SizedBox(width: 8),
                        _buildBetTypeButton(
                          'banker',
                          l10n.casinoBaccaratBanker,
                        ),
                        const SizedBox(width: 8),
                        _buildBetTypeButton('tie', l10n.casinoBaccaratTieBet),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.42),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '${l10n.casinoBetLabel}: €${formatCompactNumber(_betAmount)}',
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
                                onSelected: _isDealing
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
                      width: 230,
                      child: ElevatedButton(
                        onPressed: _isDealing ? null : _play,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber.shade700,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(26),
                          ),
                        ),
                        child: Text(
                          _isDealing
                              ? l10n.casinoDealing
                              : l10n.casinoDealCaps,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
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
}
