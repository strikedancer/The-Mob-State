import 'dart:convert';

import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../services/api_client.dart';
import '../utils/formatters.dart';
import '../utils/web_asset_helper.dart';
import '../widgets/action_result_toast.dart';

const Color _donGold = Color(0xFFFFB347);
const Color _donBgStart = Color(0xFF160707);
const Color _donBgMid = Color(0xFF261010);
const Color _donBgEnd = Color(0xFF100505);
const Color _donPanelDark = Color(0xFF1B1212);
const Color _donPanelLight = Color(0xFF2A1A1A);

class DonScreen extends StatefulWidget {
  const DonScreen({super.key, this.embedded = false});

  final bool embedded;

  @override
  State<DonScreen> createState() => _DonScreenState();
}

class _DonScreenState extends State<DonScreen> with SingleTickerProviderStateMixin {
  final ApiClient _api = ApiClient();
  final _borrowerController = TextEditingController();
  final _principalController = TextEditingController();

  late final TabController _tabs;
  bool _loading = true;
  String? _error;
  Map<String, dynamic>? _overview;
  bool _busy = false;
  bool _bidFromCrew = false;
  bool _bidGreedy = false;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 4, vsync: this);
    _load();
  }

  @override
  void dispose() {
    _tabs.dispose();
    _borrowerController.dispose();
    _principalController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final response = await _api.get('/don/overview');
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode != 200) {
        setState(() {
          _loading = false;
          _error = _errorFromPayload(data);
        });
        return;
      }
      setState(() {
        _overview = data;
        _loading = false;
      });
    } catch (_) {
      setState(() {
        _loading = false;
        _error = AppLocalizations.of(context)?.donErrorGeneric ?? '';
      });
    }
  }

  String _errorFromPayload(Map<String, dynamic> data) {
    final l10n = AppLocalizations.of(context)!;
    final params = (data['params'] as Map?)?.cast<String, dynamic>() ?? {};
    final reason = (params['reason'] ?? '').toString();
    switch (reason) {
      case 'DISABLED':
        return l10n.donErrorDisabled;
      case 'JAILED':
        return l10n.donErrorJailed;
      case 'WRONG_COUNTRY':
        return l10n.donErrorWrongCountry;
      case 'INSUFFICIENT_FUNDS':
        return l10n.donErrorFunds;
      case 'COLLECT_COOLDOWN':
        return l10n.donErrorCooldown;
      case 'RACKET_OWNED':
        return l10n.donErrorOwned;
      case 'RACKET_CAP':
        return l10n.donErrorCap;
      case 'NOT_OWNER':
        return l10n.donErrorNotOwner;
      case 'CONTEST_ACTIVE':
        return l10n.donErrorContest;
      case 'NO_CREW_BANK_PERM':
        return l10n.donErrorCrewBank;
      case 'ALDERMAN_REQUIRED':
        return l10n.donErrorAlderman;
      case 'ENGINEERING':
        return l10n.donErrorEngineering((params['requiredLevel'] as num?)?.toInt() ?? 0);
      case 'RANK_TOO_LOW':
        return l10n.donRankGate((params['requiredRank'] as num?)?.toInt() ?? 7);
      case 'INTIMIDATION':
        return l10n.donIntimidationNeed(
          (params['needed'] as num?)?.toInt() ?? 0,
          (params['have'] as num?)?.toInt() ?? 0,
        );
      default:
        return l10n.donErrorGeneric;
    }
  }

  Future<void> _post(String path, [Map<String, dynamic> body = const {}]) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final response = await _api.post(path, body);
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if (!mounted) return;
      if (response.statusCode != 200) {
        showActionResultToast(
          context,
          title: _errorFromPayload(data),
          success: false,
        );
        return;
      }
      final fled = data['result'] is Map && (data['result']['fled'] == true);
      showActionResultToast(
        context,
        title: fled
            ? AppLocalizations.of(context)!.donSqueezeFled
            : AppLocalizations.of(context)!.donSqueezeHeld,
        success: !fled,
      );
      await _load();
    } catch (_) {
      if (!mounted) return;
      showActionResultToast(
        context,
        title: AppLocalizations.of(context)!.donErrorGeneric,
        success: false,
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _postQuietSuccess(String path, [Map<String, dynamic> body = const {}]) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final response = await _api.post(path, body);
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if (!mounted) return;
      if (response.statusCode != 200) {
        showActionResultToast(
          context,
          title: _errorFromPayload(data),
          success: false,
        );
        return;
      }
      final result = data['result'] is Map ? data['result'] as Map : const {};
      final amount = result['amount'] ?? result['collected'] ?? result['repaid'] ?? result['payout'];
      showActionResultToast(
        context,
        title: AppLocalizations.of(context)!.donMenuLabel,
        moneyDelta: amount is num ? formatCurrency(amount) : null,
      );
      await _load();
    } catch (_) {
      if (!mounted) return;
      showActionResultToast(
        context,
        title: AppLocalizations.of(context)!.donErrorGeneric,
        success: false,
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  String _businessName(AppLocalizations l10n, String key) {
    switch (key) {
      case 'cafe':
        return l10n.donBusinessCafe;
      case 'garage':
        return l10n.donBusinessGarage;
      case 'warehouse':
        return l10n.donBusinessWarehouse;
      case 'night_shop':
        return l10n.donBusinessNightShop;
      case 'port_office':
        return l10n.donBusinessPortOffice;
      case 'laundry':
        return l10n.donBusinessLaundry;
      default:
        return key;
    }
  }

  String _npcName(AppLocalizations l10n, String key) {
    switch (key) {
      case 'street_dealer':
        return l10n.donNpcStreetDealer;
      case 'dock_worker':
        return l10n.donNpcDockWorker;
      case 'club_host':
        return l10n.donNpcClubHost;
      default:
        return key;
    }
  }

  String _officeName(AppLocalizations l10n, String key) {
    switch (key) {
      case 'judge':
        return l10n.donOfficeJudge;
      case 'commissioner':
        return l10n.donOfficeCommissioner;
      case 'alderman':
        return l10n.donOfficeAlderman;
      default:
        return key;
    }
  }

  String _contractName(AppLocalizations l10n, String key) {
    switch (key) {
      case 'street_repair':
        return l10n.donContractStreetRepair;
      case 'harbor_crane':
        return l10n.donContractHarborCrane;
      case 'city_hall_wing':
        return l10n.donContractCityHallWing;
      default:
        return key;
    }
  }

  IconData _businessIcon(String key) {
    switch (key) {
      case 'cafe':
        return Icons.local_cafe;
      case 'garage':
        return Icons.garage;
      case 'warehouse':
        return Icons.warehouse;
      case 'night_shop':
        return Icons.storefront;
      case 'port_office':
        return Icons.anchor;
      case 'laundry':
        return Icons.local_laundry_service;
      default:
        return Icons.store;
    }
  }

  IconData _npcIcon(String key) {
    switch (key) {
      case 'dock_worker':
        return Icons.anchor;
      case 'club_host':
        return Icons.star;
      default:
        return Icons.person_outline;
    }
  }

  IconData _officeIcon(String key) {
    switch (key) {
      case 'judge':
        return Icons.gavel;
      case 'commissioner':
        return Icons.local_police;
      default:
        return Icons.account_balance;
    }
  }

  String _donAsset(String key) => 'assets/images/don/$key.png';

  String _formatStamp(String? raw) {
    if (raw == null || raw.isEmpty) return '';
    final dt = DateTime.tryParse(raw);
    if (dt == null) return raw;
    final local = dt.toLocal();
    String two(int n) => n.toString().padLeft(2, '0');
    return '${local.year}-${two(local.month)}-${two(local.day)} ${two(local.hour)}:${two(local.minute)}';
  }

  BoxDecoration _panelDecoration() {
    return BoxDecoration(
      gradient: const LinearGradient(
        colors: [_donPanelLight, _donPanelDark],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: _donGold.withValues(alpha: 0.45)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.28),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  int _donGridCols(double width) {
    if (width >= 1040) return 4;
    if (width >= 700) return 3;
    if (width >= 480) return 2;
    return 1;
  }

  double _donCardImageHeight(int cols) {
    switch (cols) {
      case 4:
        return 112;
      case 3:
        return 124;
      default:
        return 148;
    }
  }

  Widget _donWrapGrid({
    required double width,
    required List<Widget> children,
  }) {
    const gap = 12.0;
    final cols = _donGridCols(width);
    final cardW = cols <= 1 ? width : (width - gap * (cols - 1)) / cols;
    return Wrap(
      spacing: gap,
      runSpacing: gap,
      crossAxisAlignment: WrapCrossAlignment.start,
      children: [
        for (final child in children)
          SizedBox(width: cardW, child: child),
      ],
    );
  }

  ButtonStyle get _goldFill => FilledButton.styleFrom(
        backgroundColor: _donGold,
        foregroundColor: const Color(0xFF1A0C0C),
        disabledBackgroundColor: _donGold.withValues(alpha: 0.28),
        disabledForegroundColor: const Color(0xFF1A0C0C).withValues(alpha: 0.55),
        visualDensity: VisualDensity.compact,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      );

  ButtonStyle get _goldOutline => OutlinedButton.styleFrom(
        foregroundColor: _donGold,
        side: BorderSide(color: _donGold.withValues(alpha: 0.75)),
        visualDensity: VisualDensity.compact,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      );

  InputDecoration _fieldDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.72)),
      filled: true,
      fillColor: Colors.black.withValues(alpha: 0.28),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: _donGold.withValues(alpha: 0.35)),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(color: _donGold),
      ),
    );
  }

  Widget _donImage(
    String assetPath, {
    required IconData fallback,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
  }) {
    return WebAssetHelper.image(
      assetPath,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: width,
          height: height,
          color: const Color(0xFF1E1414),
          alignment: Alignment.center,
          child: Icon(fallback, color: _donGold.withValues(alpha: 0.55), size: 36),
        );
      },
    );
  }

  Widget _sceneStack({
    required String asset,
    required IconData icon,
    required double height,
    List<Widget> overlays = const [],
  }) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          _donImage(asset, fallback: icon),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x14000000),
                  Color(0xB8000000),
                ],
              ),
            ),
          ),
          ...overlays,
        ],
      ),
    );
  }

  Widget _badge(String text, {Color color = _donGold}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.7)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _statChip({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _donGold.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: _donGold),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 4),
      child: Text(
        text,
        style: const TextStyle(
          color: _donGold,
          fontWeight: FontWeight.w700,
          fontSize: 15,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (_loading && _overview == null) {
      return _shell(
        child: const Center(child: CircularProgressIndicator(color: _donGold)),
      );
    }
    if (_error != null && _overview == null) {
      return _shell(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _error!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 12),
                FilledButton(
                  style: _goldFill,
                  onPressed: _load,
                  child: Text(l10n.retry),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final overview = _overview ?? const <String, dynamic>{};
    final money = (overview['money'] as num?)?.toInt() ?? 0;
    final wanted = (overview['wantedLevel'] as num?)?.toInt() ?? 0;
    final intimidation = (overview['intimidation'] as num?)?.toInt() ?? 0;
    final canCrew = overview['canTributeToCrew'] == true;

    final body = Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
          child: _buildHero(l10n, money, wanted, intimidation, canCrew),
        ),
        if (_busy)
          const LinearProgressIndicator(
            minHeight: 2,
            color: _donGold,
            backgroundColor: Color(0x33FFB347),
          ),
        TabBar(
          controller: _tabs,
          isScrollable: true,
          labelColor: _donGold,
          unselectedLabelColor: Colors.white70,
          indicatorColor: _donGold,
          dividerColor: _donGold.withValues(alpha: 0.22),
          tabs: [
            Tab(text: l10n.donTabRackets),
            Tab(text: l10n.donTabLoans),
            Tab(text: l10n.donTabInfluence),
            Tab(text: l10n.donTabContracts),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabs,
            children: [
              _buildRackets(l10n, overview, canCrew),
              _buildLoans(l10n, overview),
              _buildOfficials(l10n, overview),
              _buildContracts(l10n, overview),
            ],
          ),
        ),
      ],
    );

    return _shell(child: body);
  }

  Widget _shell({required Widget child}) {
    final painted = DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [_donBgStart, _donBgMid, _donBgEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: child,
    );
    if (widget.embedded) return painted;
    return Scaffold(
      backgroundColor: _donBgEnd,
      appBar: AppBar(
        backgroundColor: _donBgStart,
        foregroundColor: _donGold,
        title: Text(AppLocalizations.of(context)!.donMenuLabel),
      ),
      body: painted,
    );
  }

  Future<void> _showDonGuide(BuildContext context) async {
    final media = MediaQuery.of(context);
    final maxWidth = media.size.width >= 900
        ? 640.0
        : media.size.width >= 600
            ? 520.0
            : media.size.width - 24;
    final maxHeight = media.size.height * 0.82;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        final l10n = AppLocalizations.of(dialogContext)!;
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
          child: SafeArea(
            child: SizedBox(
              width: maxWidth,
              height: maxHeight,
              child: DecoratedBox(
                decoration: _panelDecoration(),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: ColoredBox(
                    color: _donPanelDark,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.info_outline, color: _donGold),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  l10n.donInfoTitle,
                                  style: const TextStyle(
                                    color: _donGold,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              IconButton(
                                tooltip: l10n.close,
                                onPressed: () => Navigator.of(dialogContext).pop(),
                                color: _donGold,
                                icon: const Icon(Icons.close),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  _guideBanner('hub', Icons.account_balance),
                                  const SizedBox(height: 12),
                                  Text(
                                    l10n.donInfoIntro,
                                    style: TextStyle(
                                      color: Colors.white.withValues(alpha: 0.86),
                                      height: 1.4,
                                    ),
                                  ),
                                  _guideSection(
                                    title: l10n.donInfoRacketsTitle,
                                    body: l10n.donInfoRacketsBody,
                                    imageKey: 'cafe',
                                    icon: Icons.local_cafe,
                                  ),
                                  _guideSection(
                                    title: l10n.donInfoLoansTitle,
                                    body: l10n.donInfoLoansBody,
                                    imageKey: 'street_dealer',
                                    icon: Icons.person_outline,
                                  ),
                                  _guideSection(
                                    title: l10n.donInfoInfluenceTitle,
                                    body: l10n.donInfoInfluenceBody,
                                    imageKey: 'judge',
                                    icon: Icons.gavel,
                                  ),
                                  _guideSection(
                                    title: l10n.donInfoContractsTitle,
                                    body: l10n.donInfoContractsBody,
                                    imageKey: 'harbor_crane',
                                    icon: Icons.engineering,
                                  ),
                                  _guideSection(
                                    title: l10n.donInfoCrewTitle,
                                    body: l10n.donInfoCrewBody,
                                    imageKey: 'alderman',
                                    icon: Icons.groups,
                                  ),
                                  _guideSection(
                                    title: l10n.donInfoTipsTitle,
                                    body: l10n.donInfoTipsBody,
                                    imageKey: 'laundry',
                                    icon: Icons.star,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerRight,
                            child: FilledButton(
                              style: _goldFill,
                              onPressed: () => Navigator.of(dialogContext).pop(),
                              child: Text(l10n.close),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _guideBanner(String imageKey, IconData icon) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        height: 140,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            _donImage(_donAsset(imageKey), fallback: icon),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x11000000), Color(0x66000000)],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _guideSection({
    required String title,
    required String body,
    required String imageKey,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: _donGold,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              height: 120,
              width: double.infinity,
              child: _donImage(_donAsset(imageKey), fallback: icon),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.86),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHero(
    AppLocalizations l10n,
    int money,
    int wanted,
    int intimidation,
    bool canCrew,
  ) {
    final wide = MediaQuery.sizeOf(context).width >= 720;
    final height = wide ? 176.0 : 154.0;
    return Container(
      decoration: _panelDecoration(),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            _donImage(_donAsset('hub'), fallback: Icons.account_balance),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.black.withValues(alpha: 0.82),
                    Colors.black.withValues(alpha: 0.42),
                    Colors.black.withValues(alpha: 0.18),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: wide ? 108 : 84,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: _donGold.withValues(alpha: 0.7)),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: _donImage(
                      'assets/images/avatars/vip_don_1920s.png',
                      fallback: Icons.person,
                      width: wide ? 108 : 84,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                l10n.donMenuLabel,
                                style: const TextStyle(
                                  color: _donGold,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.4,
                                ),
                              ),
                            ),
                            Tooltip(
                              message: l10n.donInfoTooltip,
                              child: Material(
                                color: Colors.black.withValues(alpha: 0.55),
                                shape: const CircleBorder(),
                                child: InkWell(
                                  customBorder: const CircleBorder(),
                                  onTap: () => _showDonGuide(context),
                                  child: Container(
                                    width: 36,
                                    height: 36,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: _donGold.withValues(alpha: 0.8),
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.info_outline,
                                      color: _donGold,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            IconButton(
                              onPressed: _busy ? null : _load,
                              color: _donGold,
                              icon: const Icon(Icons.refresh),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _statChip(icon: Icons.attach_money, label: formatCurrency(money)),
                            _statChip(icon: Icons.warning, label: '${l10n.wantedLevel}: $wanted'),
                            _statChip(
                              icon: Icons.security,
                              label: '${l10n.donCommandStrip}: $intimidation',
                            ),
                            if (canCrew)
                              _statChip(icon: Icons.groups, label: l10n.donTributeCrew),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRackets(AppLocalizations l10n, Map<String, dynamic> overview, bool canCrew) {
    final rackets = (overview['rackets'] as List?) ?? const [];
    final crewRackets = (overview['crewRackets'] as List?) ?? const [];
    return LayoutBuilder(
      builder: (context, constraints) {
        const pad = 12.0;
        final paneW = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;
        final innerW = (paneW - pad * 2).clamp(0.0, double.infinity);
        final imageH = _donCardImageHeight(_donGridCols(innerW));
        return ListView(
          padding: const EdgeInsets.all(pad),
          children: [
            _donWrapGrid(
              width: innerW,
              children: [
                for (final raw in rackets)
                  _racketCard(
                    l10n,
                    Map<String, dynamic>.from(raw as Map),
                    canCrew,
                    imageHeight: imageH,
                  ),
              ],
            ),
            if (crewRackets.isNotEmpty) ...[
              const SizedBox(height: 16),
              _sectionTitle(l10n.donCrewOverview),
              _donWrapGrid(
                width: innerW,
                children: [
                  for (final raw in crewRackets)
                    _crewRacketTile(l10n, Map<String, dynamic>.from(raw as Map)),
                ],
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _crewRacketTile(AppLocalizations l10n, Map<String, dynamic> raw) {
    final key = raw['businessKey']?.toString() ?? '';
    return Container(
      decoration: _panelDecoration(),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          SizedBox(
            width: 92,
            height: 72,
            child: _donImage(_donAsset(key), fallback: _businessIcon(key)),
          ),
          Expanded(
            child: ListTile(
              title: Text(
                _businessName(l10n, key),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
              ),
              subtitle: Text(
                '${raw['countryCode'] ?? ''} · ${l10n.donOwnedBy(raw['ownerUsername']?.toString() ?? '-')}',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.72)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _racketCard(
    AppLocalizations l10n,
    Map<String, dynamic> racket,
    bool canCrew, {
    double imageHeight = 148,
  }) {
    final id = (racket['id'] as num).toInt();
    final key = racket['businessKey']?.toString() ?? '';
    final mine = racket['isMine'] == true;
    final owner = racket['ownerUsername']?.toString();
    final contestUntil = racket['contestUntil']?.toString();
    final squeezed = racket['squeezed'] == true;
    final free = owner == null || owner.isEmpty;
    final badgeText = mine
        ? l10n.donOwnedBy(owner ?? '')
        : free
            ? l10n.donFree
            : l10n.donOwnedBy(owner);
    final badgeColor = mine
        ? _donGold
        : free
            ? const Color(0xFF8FDF9A)
            : const Color(0xFFFF8A80);

    return Container(
      decoration: _panelDecoration(),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sceneStack(
            asset: _donAsset(key),
            icon: _businessIcon(key),
            height: imageHeight,
            overlays: [
              Positioned(top: 8, left: 8, child: _badge(badgeText, color: badgeColor)),
              Positioned(
                top: 8,
                right: 8,
                child: _badge(formatCurrency((racket['nextTribute'] as num?) ?? 0)),
              ),
              if (contestUntil != null)
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: _badge('${l10n.donContest}: ${_formatStamp(contestUntil)}', color: const Color(0xFFFFCC80)),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _businessName(l10n, key),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.donIntimidationNeed(
                    (racket['minIntimidation'] as num?)?.toInt() ?? 0,
                    overviewIntimidation(),
                  ),
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.74), fontSize: 12),
                ),
                if (squeezed) ...[
                  const SizedBox(height: 4),
                  Text(
                    l10n.donSqueezeHeld,
                    style: const TextStyle(color: _donGold, fontSize: 12),
                  ),
                ],
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (!mine && free)
                      FilledButton(
                        style: _goldFill,
                        onPressed: _busy ? null : () => _postQuietSuccess('/don/rackets/$id/claim'),
                        child: Text(l10n.donClaim),
                      ),
                    if (mine)
                      FilledButton(
                        style: _goldFill,
                        onPressed: _busy ? null : () => _postQuietSuccess('/don/rackets/$id/collect'),
                        child: Text(l10n.donCollect),
                      ),
                    if (mine)
                      OutlinedButton(
                        style: _goldOutline,
                        onPressed: _busy ? null : () => _post('/don/rackets/$id/squeeze'),
                        child: Text(l10n.donSqueeze),
                      ),
                    if (!mine && !free)
                      OutlinedButton(
                        style: _goldOutline,
                        onPressed: _busy ? null : () => _postQuietSuccess('/don/rackets/$id/contest'),
                        child: Text(l10n.donContest),
                      ),
                    if (mine && contestUntil != null)
                      OutlinedButton(
                        style: _goldOutline,
                        onPressed: _busy ? null : () => _postQuietSuccess('/don/rackets/$id/hold'),
                        child: Text(l10n.donHold),
                      ),
                  ],
                ),
                if (mine && canCrew)
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    activeColor: _donGold,
                    title: Text(
                      l10n.donTributeCrew,
                      style: const TextStyle(color: Colors.white),
                    ),
                    value: racket['tributeToCrew'] == true,
                    onChanged: _busy
                        ? null
                        : (value) => _postQuietSuccess('/don/rackets/$id/tribute', {
                              'tributeToCrew': value,
                            }),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  int overviewIntimidation() => (_overview?['intimidation'] as num?)?.toInt() ?? 0;

  Widget _buildLoans(AppLocalizations l10n, Map<String, dynamic> overview) {
    final npcs = (overview['npcs'] as List?) ?? const [];
    final loans = (overview['loans'] as List?) ?? const [];
    final minP = (overview['loanMinPrincipal'] as num?)?.toInt() ?? 2000;
    final maxP = (overview['loanMaxPrincipal'] as num?)?.toInt() ?? 50000;
    return LayoutBuilder(
      builder: (context, constraints) {
        const pad = 12.0;
        final paneW = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;
        final innerW = (paneW - pad * 2).clamp(0.0, double.infinity);
        return ListView(
          padding: const EdgeInsets.all(pad),
          children: [
            Container(
              decoration: _panelDecoration(),
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle(l10n.donTabLoans),
                  Text(
                    '${l10n.donLoanPrincipalHint}: ${formatCurrency(minP)}–${formatCurrency(maxP)}',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.78)),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _principalController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white),
                    cursorColor: _donGold,
                    decoration: _fieldDecoration(l10n.donLoanPrincipalHint),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _donWrapGrid(
              width: innerW,
              children: [
                for (final raw in npcs)
                  _npcCard(l10n, Map<String, dynamic>.from(raw as Map), minP),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              decoration: _panelDecoration(),
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle(l10n.donLoanOffer),
                  TextField(
                    controller: _borrowerController,
                    style: const TextStyle(color: Colors.white),
                    cursorColor: _donGold,
                    decoration: _fieldDecoration(l10n.donLoanBorrowerHint),
                  ),
                  const SizedBox(height: 10),
                  FilledButton(
                    style: _goldFill,
                    onPressed: _busy
                        ? null
                        : () => _postQuietSuccess('/don/loans/offer', {
                              'borrowerUsername': _borrowerController.text.trim(),
                              'principal': int.tryParse(_principalController.text) ?? minP,
                            }),
                    child: Text(l10n.donLoanOffer),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            for (final raw in loans) ...[
              _loanTile(l10n, Map<String, dynamic>.from(raw as Map)),
              const SizedBox(height: 10),
            ],
          ],
        );
      },
    );
  }

  Widget _npcCard(AppLocalizations l10n, Map<String, dynamic> raw, int minP) {
    final key = raw['key']?.toString() ?? '';
    return Container(
      decoration: _panelDecoration(),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: 112,
              height: 148,
              child: _donImage(
                _donAsset(key),
                fallback: _npcIcon(key),
                width: 112,
                height: 148,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _npcName(l10n, key),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    Align(
                      alignment: Alignment.centerRight,
                      child: FilledButton(
                        style: _goldFill,
                        onPressed: _busy
                            ? null
                            : () => _postQuietSuccess('/don/loans/npc', {
                                  'npcKey': raw['key'],
                                  'principal': int.tryParse(_principalController.text) ?? minP,
                                }),
                        child: Text(l10n.donLoanNpc),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _loanTile(AppLocalizations l10n, Map<String, dynamic> loan) {
    final id = (loan['id'] as num).toInt();
    final status = loan['status']?.toString() ?? '';
    final isLender = loan['isLender'] == true;
    final npc = loan['npcKey']?.toString();
    final title = npc != null && npc.isNotEmpty
        ? _npcName(l10n, npc)
        : (isLender ? loan['borrowerUsername'] : loan['lenderUsername'])?.toString() ?? '';
    return Container(
      decoration: _panelDecoration(),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        subtitle: Text(
          '$status · ${formatCurrency((loan['dueAmount'] as num?) ?? 0)} · ${_formatStamp(loan['dueAt']?.toString())}',
          style: TextStyle(color: Colors.white.withValues(alpha: 0.72)),
        ),
        trailing: Wrap(
          spacing: 4,
          children: [
            if (!isLender && status == 'offered')
              TextButton(
                onPressed: _busy ? null : () => _postQuietSuccess('/don/loans/$id/accept'),
                child: Text(l10n.donLoanAccept, style: const TextStyle(color: _donGold)),
              ),
            if (!isLender && status == 'active')
              TextButton(
                onPressed: _busy ? null : () => _postQuietSuccess('/don/loans/$id/repay'),
                child: Text(l10n.donLoanRepay, style: const TextStyle(color: _donGold)),
              ),
            if (isLender && (status == 'defaulted' || status == 'active'))
              TextButton(
                onPressed: _busy ? null : () => _postQuietSuccess('/don/loans/$id/collect'),
                child: Text(l10n.donLoanCollect, style: const TextStyle(color: _donGold)),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildOfficials(AppLocalizations l10n, Map<String, dynamic> overview) {
    final officials = (overview['officials'] as List?) ?? const [];
    return LayoutBuilder(
      builder: (context, constraints) {
        const pad = 12.0;
        final paneW = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;
        final innerW = (paneW - pad * 2).clamp(0.0, double.infinity);
        final imageH = _donCardImageHeight(_donGridCols(innerW));
        return ListView(
          padding: const EdgeInsets.all(pad),
          children: [
            _donWrapGrid(
              width: innerW,
              children: [
                for (final raw in officials)
                  _officialCard(
                    l10n,
                    Map<String, dynamic>.from(raw as Map),
                    imageHeight: imageH,
                  ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _officialCard(
    AppLocalizations l10n,
    Map<String, dynamic> row, {
    double imageHeight = 148,
  }) {
    final office = row['office']?.toString() ?? '';
    final patron = row['patronUsername']?.toString();
    final free = patron == null || patron.isEmpty;
    return Container(
      decoration: _panelDecoration(),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sceneStack(
            asset: _donAsset(office),
            icon: _officeIcon(office),
            height: imageHeight,
            overlays: [
              Positioned(
                top: 8,
                left: 8,
                child: _badge(
                  free ? l10n.donFree : l10n.donOwnedBy(patron),
                  color: free ? const Color(0xFF8FDF9A) : _donGold,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _officeName(l10n, office),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (!free) ...[
                  const SizedBox(height: 4),
                  Text(
                    _formatStamp(row['paidUntil']?.toString()),
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.72), fontSize: 12),
                  ),
                ],
                const SizedBox(height: 10),
                FilledButton(
                  style: _goldFill,
                  onPressed: _busy
                      ? null
                      : () => _postQuietSuccess('/don/officials/$office/bribe'),
                  child: Text('${l10n.donBribe} ${formatCurrency((row['nextBid'] as num?) ?? 0)}'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContracts(AppLocalizations l10n, Map<String, dynamic> overview) {
    final contracts = (overview['contracts'] as List?) ?? const [];
    final canCrew = overview['canTributeToCrew'] == true;
    return LayoutBuilder(
      builder: (context, constraints) {
        const pad = 12.0;
        final paneW = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;
        final innerW = (paneW - pad * 2).clamp(0.0, double.infinity);
        final imageH = _donCardImageHeight(_donGridCols(innerW));
        return ListView(
          padding: const EdgeInsets.all(pad),
          children: [
            Container(
              decoration: _panelDecoration(),
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
              child: Column(
                children: [
                  if (canCrew)
                    SwitchListTile(
                      activeColor: _donGold,
                      title: Text(
                        l10n.donBidFromCrew,
                        style: const TextStyle(color: Colors.white),
                      ),
                      value: _bidFromCrew,
                      onChanged: (value) => setState(() => _bidFromCrew = value),
                    ),
                  SwitchListTile(
                    activeColor: _donGold,
                    title: Text(
                      l10n.donBidGreedy,
                      style: const TextStyle(color: Colors.white),
                    ),
                    value: _bidGreedy,
                    onChanged: (value) => setState(() => _bidGreedy = value),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _donWrapGrid(
              width: innerW,
              children: [
                for (final raw in contracts)
                  _contractCard(
                    l10n,
                    Map<String, dynamic>.from(raw as Map),
                    imageHeight: imageH,
                  ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _contractCard(
    AppLocalizations l10n,
    Map<String, dynamic> row, {
    double imageHeight = 148,
  }) {
    final id = (row['id'] as num).toInt();
    final open = row['status'] == 'open';
    final key = row['contractKey']?.toString() ?? '';
    final bidder = row['bidderUsername']?.toString();
    return Container(
      decoration: _panelDecoration(),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sceneStack(
            asset: _donAsset(key),
            icon: Icons.engineering,
            height: imageHeight,
            overlays: [
              Positioned(
                top: 8,
                left: 8,
                child: _badge(
                  row['status']?.toString() ?? '',
                  color: open ? const Color(0xFF8FDF9A) : _donGold,
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: _badge(formatCurrency((row['payout'] as num?) ?? 0)),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _contractName(l10n, key),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${l10n.donBid} ${formatCurrency((row['bidCost'] as num?) ?? 0)}'
                  '${bidder != null && bidder.isNotEmpty ? ' · $bidder' : ''}',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.74), fontSize: 12),
                ),
                const SizedBox(height: 10),
                if (open)
                  FilledButton(
                    style: _goldFill,
                    onPressed: _busy
                        ? null
                        : () => _postQuietSuccess('/don/contracts/$id/bid', {
                              'fromCrew': _bidFromCrew,
                              'greedy': _bidGreedy,
                            }),
                    child: Text(l10n.donBid),
                  )
                else
                  Text(
                    row['status']?.toString() ?? '',
                    style: const TextStyle(color: _donGold, fontWeight: FontWeight.w700),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
