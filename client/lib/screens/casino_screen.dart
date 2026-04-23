import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/api_client.dart';
import '../models/casino_game.dart';
import 'dart:convert';
import '../l10n/app_localizations.dart';
import 'games/slot_machine_screen.dart';
import 'games/blackjack_screen.dart';
import 'games/roulette_screen.dart';
import 'games/dice_screen.dart';
import 'games/baccarat_screen.dart';
import 'games/video_poker_screen.dart';
import 'casino_management_screen.dart';
import '../widgets/education_requirements_dialog.dart';
import '../utils/top_right_notification.dart';

class CasinoScreen extends StatefulWidget {
  const CasinoScreen({super.key});

  @override
  State<CasinoScreen> createState() => _CasinoScreenState();
}

class _CasinoScreenState extends State<CasinoScreen> {
  final ApiClient _apiClient = ApiClient();
  final GlobalKey<NavigatorState> _gameNavigatorKey =
      GlobalKey<NavigatorState>();
  List<CasinoGame> _games = [];
  bool _isLoading = true;
  String? _error;
  bool _isOwned = false;
  Map<String, dynamic>? _ownerInfo;
  int _casinoPrice = 0;
  bool _isOwner = false;
  Map<String, dynamic>? _casinoStats;
  bool _gameRouteActive = false;

  @override
  void initState() {
    super.initState();
    _checkOwnershipAndLoadGames();
  }

  Future<void> _checkOwnershipAndLoadGames() async {
    // First check casino ownership for current country
    await _checkOwnership();

    // Only load games if casino is owned
    if (_isOwned) {
      await _loadGames();
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _checkOwnership() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final currentCountry =
          authProvider.currentPlayer?.currentCountry ?? 'netherlands';

      print('[CasinoScreen] Checking ownership for country: $currentCountry');
      final response = await _apiClient.get(
        '/casino/ownership/$currentCountry',
      );
      print('[CasinoScreen] Ownership response: ${response.body}');

      final data = jsonDecode(response.body);

      if (data['event'] == 'casino.ownership.info' && data['params'] != null) {
        final params = data['params'];
        final playerId = authProvider.currentPlayer?.id;

        setState(() {
          _isOwned = params['owned'] ?? false;
          _ownerInfo = params['owner'];
          _casinoPrice = params['price'] ?? 0;
          _isOwner =
              _isOwned && _ownerInfo != null && _ownerInfo!['id'] == playerId;
        });

        print(
          '[CasinoScreen] Casino owned: $_isOwned, Is owner: $_isOwner, Price: $_casinoPrice',
        );

        // Load stats if we own this casino
        if (_isOwner) {
          await _loadCasinoStats();
        }
      }

      setState(() => _isLoading = false);
    } catch (e) {
      print('[CasinoScreen] Error checking ownership: $e');
      setState(() {
        final l10n = AppLocalizations.of(context)!;
        _error = l10n.errorLoadingCasinoStatus;
        _isLoading = false;
      });
    }
  }

  Future<void> _loadCasinoStats() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final currentCountry =
          authProvider.currentPlayer?.currentCountry ?? 'netherlands';

      final response = await _apiClient.get('/casino/stats/$currentCountry');
      final data = jsonDecode(response.body);

      if (data['event'] == 'casino.stats' && data['params'] != null) {
        setState(() {
          _casinoStats = data['params'];
        });
      }
    } catch (e) {
      print('[CasinoScreen] Error loading stats: $e');
    }
  }

  Future<void> _loadGames() async {
    print('[CasinoScreen] Loading games...');
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await _apiClient.get('/casino/games');
      print('[CasinoScreen] Response status: ${response.statusCode}');
      print('[CasinoScreen] Response body: ${response.body}');
      final data = jsonDecode(response.body);

      // Parse event-based response
      if (data['event'] == 'casino.games.list' && data['params'] != null) {
        print(
          '[CasinoScreen] Successfully parsed ${(data['params']['games'] as List).length} games',
        );
        setState(() {
          _games = (data['params']['games'] as List)
              .map((json) => CasinoGame.fromJson(json))
              .toList();
          _isLoading = false;
        });
        print('[CasinoScreen] Games loaded: $_games');
      } else {
        print('[CasinoScreen] Invalid response format: $data');
        setState(() {
          final l10n = AppLocalizations.of(context)!;
          _error = l10n.errorLoadingCasinoGames;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('[CasinoScreen] Error loading games: $e');
      setState(() {
        final l10n = AppLocalizations.of(context)!;
        _error = l10n.unknownError;
        _isLoading = false;
      });
    }
  }

  Future<void> _purchaseCasino() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final currentCountry =
        authProvider.currentPlayer?.currentCountry ?? 'netherlands';
    final minDeposit = (_casinoPrice * 0.20).floor();
    final depositController = TextEditingController(
      text: minDeposit.toString(),
    );
    final l10n = AppLocalizations.of(context)!;

    // Show deposit dialog
    final depositAmount = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.buyCasino),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.casinoPrice(
                _casinoPrice
                    .toStringAsFixed(0)
                    .replaceAllMapped(
                      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                      (Match m) => '${m[1]},',
                    ),
              ),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              l10n.minimumDeposit(
                minDeposit
                    .toStringAsFixed(0)
                    .replaceAllMapped(
                      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                      (Match m) => '${m[1]},',
                    ),
              ),
              style: TextStyle(color: Colors.orange),
            ),
            SizedBox(height: 16),
            TextField(
              controller: depositController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: l10n.startingCapital,
                prefixText: '€',
                border: OutlineInputBorder(),
                helperText: l10n.bankrollHelper,
              ),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[900],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info, size: 16, color: Colors.blue[100]),
                      SizedBox(width: 4),
                      Text(
                        l10n.casinoOwnershipInfoTitle,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    l10n.casinoInfo1,
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                  Text(
                    l10n.casinoInfo2,
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                  Text(
                    l10n.casinoInfo3,
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                  Text(
                    l10n.casinoInfo4,
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                  Text(
                    l10n.casinoInfo5,
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              final amount = int.tryParse(depositController.text);
              Navigator.pop(context, amount);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: Text(l10n.buy),
          ),
        ],
      ),
    );

    if (depositAmount == null || depositAmount < minDeposit) {
      if (mounted && depositAmount != null) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(l10n.minimumDeposit(minDeposit.toStringAsFixed(0))),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }

    var reloadedScreenState = false;

    try {
      setState(() => _isLoading = true);

      final response = await _apiClient.post(
        '/casino/purchase/$currentCountry',
        {'initialDeposit': depositAmount},
      );
      final data = jsonDecode(response.body);

      if (data['event'] == 'casino.purchased') {
        // Refresh player data
        await authProvider.refreshPlayer();

        // Show success message
        if (mounted) {
          showTopRightFromSnackBar(
            context,
            SnackBar(
              content: Text(l10n.casinoBought),
              backgroundColor: Colors.green,
            ),
          );
        }

        // Reload ownership and games
        await _checkOwnershipAndLoadGames();
        reloadedScreenState = true;
      } else if (data['event'] == 'casino.purchase.failed') {
        final params =
            (data['params'] as Map?)?.cast<String, dynamic>() ??
            <String, dynamic>{};
        final missing = (params['missing'] as List?) ?? const [];
        final isEducationLocked =
            params['code'] == 'EDUCATION_REQUIREMENTS_NOT_MET' ||
            params['reason'] == 'EDUCATION_REQUIREMENTS_NOT_MET' ||
            missing.isNotEmpty;

        if (mounted && isEducationLocked) {
          await EducationRequirementsDialog.show(
            context,
            title:
                '🔒 ${l10n.buyCasino} ${l10n.achievementLocked.toLowerCase()}',
            subtitle: params['reason']?.toString(),
            missingRequirements: missing,
          );
          setState(() => _isLoading = false);
          return;
        }

        final reason = params['reason'] ?? l10n.unknownResponse;
        if (mounted) {
          showTopRightFromSnackBar(
            context,
            SnackBar(content: Text(reason), backgroundColor: Colors.red),
          );
        }
        setState(() => _isLoading = false);
      } else {
        if (mounted) {
          showTopRightFromSnackBar(
            context,
            SnackBar(
              content: Text(l10n.unknownResponse),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      print('[CasinoScreen] Purchase error: $e');
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(l10n.errorBuyCasino),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted && !reloadedScreenState) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _playGame(CasinoGame game) {
    final navigator = _gameNavigatorKey.currentState;
    if (navigator == null) {
      return;
    }

    Widget? destination;
    switch (game.id) {
      case 'slots':
        destination = SlotMachineScreen(game: game);
        break;
      case 'blackjack':
        destination = BlackjackScreen(game: game);
        break;
      case 'roulette':
        destination = RouletteScreen(game: game);
        break;
      case 'dice':
        destination = DiceScreen(game: game);
        break;
      case 'baccarat':
        destination = BaccaratScreen(game: game);
        break;
      case 'video_poker':
        destination = VideoPokerScreen(game: game);
        break;
      default:
        destination = null;
    }

    if (destination == null) return;

    setState(() => _gameRouteActive = true);
    navigator.push(MaterialPageRoute(builder: (_) => destination!)).then((
      _,
    ) async {
      if (!mounted) return;
      setState(() => _gameRouteActive = false);
      await _checkOwnership();
    });
  }

  Widget _buildEmbeddedCasinoNavigator() {
    return Navigator(
      key: _gameNavigatorKey,
      onGenerateRoute: (_) =>
          MaterialPageRoute(builder: (_) => _buildGameGrid()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final backgroundImage = isPortrait
        ? 'assets/images/casino/casino_background_portrait.png'
        : 'assets/images/casino/casino_background_landscape.png';

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.casino),
            const SizedBox(width: 8),
            Text(l10n.casino),
          ],
        ),
      ),
      floatingActionButton:
          _isOwner && _casinoStats != null && !_gameRouteActive
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CasinoManagementScreen(
                      countryId:
                          Provider.of<AuthProvider>(
                            context,
                            listen: false,
                          ).currentPlayer?.currentCountry ??
                          'netherlands',
                      initialStats: _casinoStats!,
                    ),
                  ),
                ).then((_) => _loadCasinoStats());
              },
              icon: Icon(Icons.settings),
              label: Text(l10n.manageCasino),
              backgroundColor: Colors.orange,
            )
          : null,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(backgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(
              0.3,
            ), // Slight overlay for better text readability
          ),
          child: _isLoading
              ? Center(child: CircularProgressIndicator(color: Colors.white))
              : _error != null
              ? _buildError()
              : !_isOwned
              ? _buildClosedCasino()
              : _buildEmbeddedCasinoNavigator(),
        ),
      ),
    );
  }

  Widget _buildError() {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.white70),
          SizedBox(height: 16),
          Text(
            _error!,
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _checkOwnershipAndLoadGames,
            child: Text(l10n.retryAgain),
          ),
        ],
      ),
    );
  }

  Widget _buildClosedCasino() {
    final l10n = AppLocalizations.of(context)!;
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 700;
          final horizontalPadding = isNarrow ? 12.0 : 24.0;
          final cardPadding = isNarrow ? 16.0 : 32.0;

          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: 16,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight - 32,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 860),
                  child: Container(
                    padding: EdgeInsets.all(cardPadding),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.red[700]!, width: 3),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.lock,
                          size: isNarrow ? 60 : 80,
                          color: Colors.red[400],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          l10n.casinoClosedTitle,
                          style: TextStyle(
                            fontSize: isNarrow ? 22 : 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        if (_ownerInfo != null) ...[
                          Text(
                            l10n.casinoOwnedByLabel,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _ownerInfo!['username'] ?? l10n.unknown,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.amber,
                            ),
                          ),
                        ] else ...[
                          Text(
                            l10n.casinoNoOwner,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          Text(
                            l10n.casinoPurchasePriceLabel,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '€${_casinoPrice.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                            style: TextStyle(
                              fontSize: isNarrow ? 26 : 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.green[400],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _purchaseCasino,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green[700],
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.shopping_cart, size: 24),
                                  const SizedBox(width: 8),
                                  Text(
                                    l10n.buyCasino,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.blue[900]!.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: Colors.blue[300],
                                  size: 32,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  l10n.casinoOwnerInfo,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    height: 1.5,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGameGrid() {
    final l10n = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth < 560
        ? 1
        : screenWidth < 900
        ? 2
        : (screenWidth / 320).floor().clamp(2, 4);
    final aspectRatio = screenWidth < 560
        ? 1.2
        : (screenWidth < 900 ? 1.0 : 0.95);

    return RefreshIndicator(
      onRefresh: _checkOwnershipAndLoadGames,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.55),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.amber.withOpacity(0.65)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.casino, color: Colors.amber, size: 28),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.casino,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                Localizations.localeOf(context).languageCode
                                        .toLowerCase()
                                        .startsWith('nl')
                                    ? 'Kies een spel en plaats je inzet'
                                    : 'Choose a game and place your bet',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: aspectRatio,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _buildGameCard(_games[index]),
                    childCount: _games.length,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGameCard(CasinoGame game) {
    final l10n = AppLocalizations.of(context)!;
    final localizedName = _localizedGameName(game.id, l10n) ?? game.name;
    final localizedDescription =
        _localizedGameDescription(game.id, l10n) ?? game.description;
    final isMobile = MediaQuery.of(context).size.width < 600;

    // Map game ID to image file
    final iconImageMap = {
      'slots': 'assets/images/casino/slot_machine.png',
      'blackjack': 'assets/images/casino/blackjack.png',
      'roulette': 'assets/images/casino/roulette.png',
      'dice': 'assets/images/casino/dice.png',
      'baccarat': 'assets/images/casino/baccarat.png',
      'video_poker': 'assets/images/casino/video_poker.png',
    };

    return Card(
      elevation: 6,
      color: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: InkWell(
        onTap: () => _playGame(game),
        borderRadius: BorderRadius.circular(18),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.grey.shade900, Colors.black87],
            ),
            border: Border.all(
              color: Colors.amber.withOpacity(0.7),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.45),
                blurRadius: 14,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          padding: EdgeInsets.all(isMobile ? 12 : 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon - use image instead of emoji
              if (iconImageMap.containsKey(game.id))
                Flexible(
                  child: Image.asset(
                    iconImageMap[game.id]!,
                    width: isMobile ? 60 : 80,
                    height: isMobile ? 60 : 80,
                    fit: BoxFit.contain,
                  ),
                )
              else
                Text(game.icon, style: TextStyle(fontSize: isMobile ? 36 : 48)),
              SizedBox(height: isMobile ? 8 : 12),
              // Name
              Text(
                localizedName,
                style: TextStyle(
                  fontSize: isMobile ? 16 : 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber.shade100,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              // Description
              Flexible(
                child: Text(
                  localizedDescription,
                  style: TextStyle(
                    fontSize: isMobile ? 10 : 12,
                    color: Colors.white.withOpacity(0.82),
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 8),
              // Bet Range
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 8 : 12,
                  vertical: isMobile ? 4 : 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '€${game.minBet} - €${game.maxBet}',
                  style: TextStyle(
                    color: Colors.amber.shade50,
                    fontSize: isMobile ? 10 : 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 4),
              // Difficulty
              _buildDifficultyBadge(game.difficulty, l10n, isMobile),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _playGame(game),
                  icon: const Icon(Icons.play_arrow),
                  label: Text(
                    Localizations.localeOf(
                          context,
                        ).languageCode.toLowerCase().startsWith('nl')
                        ? 'Spelen'
                        : 'Play',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber.shade700,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDifficultyBadge(
    String difficulty,
    AppLocalizations l10n, [
    bool isMobile = false,
  ]) {
    Color color;
    String label;
    switch (difficulty.toLowerCase()) {
      case 'easy':
        color = Colors.green;
        label = l10n.difficultyEasy;
        break;
      case 'medium':
        color = Colors.orange;
        label = l10n.difficultyMedium;
        break;
      case 'hard':
        color = Colors.red;
        label = l10n.difficultyHard;
        break;
      default:
        color = Colors.grey;
        label = difficulty.toUpperCase();
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 6 : 8,
        vertical: isMobile ? 3 : 4,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontSize: isMobile ? 9 : 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String? _localizedGameName(String gameId, AppLocalizations l10n) {
    switch (gameId) {
      case 'slots':
        return l10n.casinoGameSlotsName;
      case 'blackjack':
        return l10n.casinoGameBlackjackName;
      case 'roulette':
        return l10n.casinoGameRouletteName;
      case 'dice':
        return l10n.casinoGameDiceName;
      case 'baccarat':
        return Localizations.localeOf(
              context,
            ).languageCode.toLowerCase().startsWith('nl')
            ? 'Baccarat'
            : 'Baccarat';
      case 'video_poker':
        return Localizations.localeOf(
              context,
            ).languageCode.toLowerCase().startsWith('nl')
            ? 'Video Poker'
            : 'Video Poker';
      default:
        return null;
    }
  }

  String? _localizedGameDescription(String gameId, AppLocalizations l10n) {
    switch (gameId) {
      case 'slots':
        return l10n.casinoGameSlotsDesc;
      case 'blackjack':
        return l10n.casinoGameBlackjackDesc;
      case 'roulette':
        return l10n.casinoGameRouletteDesc;
      case 'dice':
        return l10n.casinoGameDiceDesc;
      case 'baccarat':
        return Localizations.localeOf(
              context,
            ).languageCode.toLowerCase().startsWith('nl')
            ? 'Zet in op speler, bankier of gelijkspel met strategische odds.'
            : 'Bet on player, banker, or tie with strategic odds.';
      case 'video_poker':
        return Localizations.localeOf(
              context,
            ).languageCode.toLowerCase().startsWith('nl')
            ? 'Trek 5 kaarten en scoor combo’s tot Royal Flush.'
            : 'Draw 5 cards and hit combos up to Royal Flush.';
      default:
        return null;
    }
  }
}
