import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../config/app_config.dart';
import '../l10n/app_localizations.dart';
import '../providers/locale_provider.dart';
import '../utils/web_asset_helper.dart';
import '../widgets/guest_legal_footer.dart';
import 'login_screen.dart';

const Color _landingGold = Color(0xFFC0A060);

void showLandingAuthDialog(BuildContext context, {required bool register}) {
  showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (dialogContext) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: LoginScreen(
          embeddedModal: true,
          initialRegister: register,
          onEmbeddedAuthSuccess: () {
            Navigator.of(dialogContext).pop();
            Navigator.of(context).pushReplacementNamed('/dashboard');
          },
        ),
      );
    },
  );
}

int? _decodeInt(dynamic v) {
  if (v is int) return v;
  if (v is num) return v.round();
  return null;
}

class _PublicPlayerRow {
  _PublicPlayerRow({required this.rank, required this.username});

  final int rank;
  final String username;

  static _PublicPlayerRow? tryParse(Map<String, dynamic> json) {
    final rank = _decodeInt(json['rank']);
    final username = json['username'];
    if (rank == null || username is! String) return null;
    return _PublicPlayerRow(rank: rank, username: username);
  }
}

class _PublicCrewRow {
  _PublicCrewRow({
    required this.rank,
    required this.crewName,
    required this.regionsOwned,
  });

  final int rank;
  final String crewName;
  final int regionsOwned;

  static _PublicCrewRow? tryParse(Map<String, dynamic> json) {
    final rank = _decodeInt(json['rank']);
    final regionsOwned = _decodeInt(json['regionsOwned']);
    final crewName = json['crewName'];
    if (rank == null || crewName is! String || regionsOwned == null)
      return null;
    return _PublicCrewRow(
      rank: rank,
      crewName: crewName,
      regionsOwned: regionsOwned,
    );
  }
}

/// Marketing home: hero, public rankings, legal links, guest language (no server).
class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  List<_PublicPlayerRow> _players = [];
  List<_PublicCrewRow> _crews = [];
  bool _loading = true;
  bool _loadFailed = false;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<LocaleProvider>().initGuestLocale();
      _fetchPublicHome();
    });
  }

  Future<void> _fetchPublicHome() async {
    setState(() {
      _loading = true;
      _loadFailed = false;
    });
    try {
      final uri = Uri.parse('${AppConfig.apiBaseUrl}/public/home');
      final response = await http.get(uri).timeout(AppConfig.apiTimeout);
      if (!mounted) return;
      if (response.statusCode != 200) {
        setState(() {
          _loading = false;
          _loadFailed = true;
          _players = [];
          _crews = [];
        });
        return;
      }
      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) {
        setState(() {
          _loading = false;
          _loadFailed = true;
        });
        return;
      }
      final data = decoded['data'];
      if (data is! Map<String, dynamic>) {
        setState(() {
          _loading = false;
          _loadFailed = true;
        });
        return;
      }
      final rawPlayers = data['topPlayers'];
      final rawCrews = data['topCrews'];
      final players = <_PublicPlayerRow>[];
      final crews = <_PublicCrewRow>[];
      if (rawPlayers is List) {
        for (final e in rawPlayers) {
          if (e is Map<String, dynamic>) {
            final row = _PublicPlayerRow.tryParse(e);
            if (row != null) players.add(row);
          }
        }
      }
      if (rawCrews is List) {
        for (final e in rawCrews) {
          if (e is Map<String, dynamic>) {
            final row = _PublicCrewRow.tryParse(e);
            if (row != null) crews.add(row);
          }
        }
      }
      setState(() {
        _loading = false;
        _loadFailed = false;
        _players = players;
        _crews = crews;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _loadFailed = true;
        _players = [];
        _crews = [];
      });
    }
  }

  Widget _buildBackgroundFallback() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.grey[900]!, Colors.black, Colors.grey[850]!],
        ),
      ),
    );
  }

  Widget _buildBackground(bool isPortrait) {
    final preferredAsset = isPortrait
        ? 'assets/images/backgrounds/login_background_mobile.png'
        : 'assets/images/backgrounds/login_background.png';
    final canonicalWebAsset = isPortrait
        ? 'assets/assets/images/backgrounds/login_background_mobile.png'
        : 'assets/assets/images/backgrounds/login_background.png';
    final staticWebFallback = isPortrait
        ? 'images/backgrounds/login_background_mobile.png'
        : 'images/backgrounds/login_background.png';
    final directPath = isPortrait
        ? WebAssetHelper.toPublicUrl(
            'assets/images/backgrounds/login_background_mobile.png',
          )
        : WebAssetHelper.toPublicUrl(
            'assets/images/backgrounds/login_background.png',
          );
    final oppositeStaticFallback = isPortrait
        ? 'images/backgrounds/login_background.png'
        : 'images/backgrounds/login_background_mobile.png';

    return Image.asset(
      preferredAsset,
      fit: BoxFit.cover,
      alignment: isPortrait ? Alignment.topCenter : Alignment.topLeft,
      errorBuilder: (context, error, stackTrace) {
        return Image.network(
          WebAssetHelper.toPublicUrl(canonicalWebAsset),
          fit: BoxFit.cover,
          alignment: isPortrait ? Alignment.topCenter : Alignment.topLeft,
          errorBuilder: (context, error, stackTrace) {
            return Image.network(
              WebAssetHelper.toPublicUrl(staticWebFallback),
              fit: BoxFit.cover,
              alignment: isPortrait ? Alignment.topCenter : Alignment.topLeft,
              errorBuilder: (context, error, stackTrace) {
                return Image.network(
                  directPath,
                  fit: BoxFit.cover,
                  alignment: isPortrait
                      ? Alignment.topCenter
                      : Alignment.topLeft,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.network(
                      WebAssetHelper.toPublicUrl(oppositeStaticFallback),
                      fit: BoxFit.cover,
                      alignment: isPortrait
                          ? Alignment.topCenter
                          : Alignment.topLeft,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildBackgroundFallback();
                      },
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _rankingsPanel(AppLocalizations l10n) {
    if (_loading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator(color: _landingGold)),
      );
    }
    if (_loadFailed) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Text(
          l10n.landingLoadError,
          style: const TextStyle(color: Colors.white70),
          textAlign: TextAlign.center,
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, c) {
        final wide = c.maxWidth >= 720;
        final playersCard = _leaderCard(
          title: l10n.landingTopPlayersTitle,
          child: _players.isEmpty
              ? Text(
                  l10n.landingEmptyLeaderboard,
                  style: const TextStyle(color: Colors.white54),
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 44,
                            child: Text(
                              l10n.landingRankLabel,
                              style: const TextStyle(
                                color: Colors.white38,
                                fontSize: 11,
                              ),
                            ),
                          ),
                          const Expanded(child: SizedBox.shrink()),
                        ],
                      ),
                    ),
                    for (final p in _players)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 44,
                              child: Text(
                                '#${p.rank}',
                                style: const TextStyle(
                                  color: _landingGold,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                p.username,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
        );
        final crewsCard = _leaderCard(
          title: l10n.landingTopCrewsTitle,
          child: _crews.isEmpty
              ? Text(
                  l10n.landingEmptyLeaderboard,
                  style: const TextStyle(color: Colors.white54),
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 44,
                            child: Text(
                              l10n.landingRankLabel,
                              style: const TextStyle(
                                color: Colors.white38,
                                fontSize: 11,
                              ),
                            ),
                          ),
                          const Expanded(child: SizedBox.shrink()),
                          Text(
                            l10n.landingRegionsLabel,
                            style: const TextStyle(
                              color: Colors.white38,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    for (final c in _crews)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 44,
                              child: Text(
                                '#${c.rank}',
                                style: const TextStyle(
                                  color: _landingGold,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                c.crewName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              '${c.regionsOwned}',
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
        );

        if (wide) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: playersCard),
              const SizedBox(width: 16),
              Expanded(child: crewsCard),
            ],
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [playersCard, const SizedBox(height: 16), crewsCard],
        );
      },
    );
  }

  Widget _leaderCard({required String title, required Widget child}) {
    return Card(
      color: Colors.black.withOpacity(0.45),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.amber.shade800.withOpacity(0.35)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: _landingGold,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(color: Colors.white24),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildTopRightCtas(
    BuildContext context,
    AppLocalizations l10n,
    bool compact,
  ) {
    final pad = compact
        ? const EdgeInsets.symmetric(horizontal: 12, vertical: 10)
        : const EdgeInsets.symmetric(horizontal: 20, vertical: 12);
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _landingGold,
              foregroundColor: Colors.black,
              padding: pad,
              minimumSize: compact ? const Size(0, 40) : const Size(0, 44),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => showLandingAuthDialog(context, register: false),
            child: Text(l10n.landingCtaLogin),
          ),
          SizedBox(width: compact ? 8 : 12),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: _landingGold,
              side: const BorderSide(color: _landingGold, width: 1.5),
              padding: pad,
              minimumSize: compact ? const Size(0, 40) : const Size(0, 44),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => showLandingAuthDialog(context, register: true),
            child: Text(l10n.landingCtaRegister),
          ),
        ],
      ),
    );
  }

  /// Pushes copy out from the left so it does not sit on top of the artwork title on the background.
  double _contentLeadingInset(double width) {
    if (width >= 1100) return width * 0.42;
    if (width >= 840) return width * 0.36;
    if (width >= 640) return width * 0.20;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;
    final isPortrait = size.height > size.width;
    final isMobile = size.width < 600;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (isMobile) Container(color: Colors.black),
          Positioned.fill(child: _buildBackground(isPortrait)),
          Container(color: Colors.black.withOpacity(isMobile ? 0.45 : 0.38)),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    isMobile ? 8 : 16,
                    4,
                    isMobile ? 8 : 16,
                    0,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Spacer(),
                      _buildTopRightCtas(context, l10n, isMobile),
                    ],
                  ),
                ),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final innerW = constraints.maxWidth;
                      final innerLead = _contentLeadingInset(innerW);
                      final innerMax = math
                          .min(
                            560.0,
                            innerW - innerLead - (innerW < 600 ? 20 : 40),
                          )
                          .clamp(260.0, 560.0);
                      final panel = innerW < 640;
                      Widget copyColumn = Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            l10n.landingHeroTitle,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isMobile ? 30 : 40,
                              fontWeight: FontWeight.w800,
                              shadows: const [
                                Shadow(
                                  blurRadius: 12,
                                  color: Colors.black87,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            l10n.landingHeroSubtitle,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.88),
                              fontSize: isMobile ? 15 : 17,
                              height: 1.45,
                              shadows: const [
                                Shadow(
                                  blurRadius: 8,
                                  color: Colors.black87,
                                  offset: Offset(0, 1),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),
                          Text(
                            l10n.landingAboutTitle,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: _landingGold,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            l10n.landingAboutBody,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white70,
                              height: 1.45,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 32),
                          _rankingsPanel(l10n),
                        ],
                      );
                      if (panel) {
                        copyColumn = DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.58),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: Colors.amber.shade800.withOpacity(0.35),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 18,
                            ),
                            child: copyColumn,
                          ),
                        );
                      }
                      return SingleChildScrollView(
                        padding: EdgeInsets.fromLTRB(
                          isMobile ? 12 : 24,
                          12,
                          isMobile ? 12 : 24,
                          24,
                        ),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: EdgeInsets.only(left: innerLead),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: innerMax),
                              child: copyColumn,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SafeArea(top: false, child: GuestLegalFooter()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
