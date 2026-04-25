import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/app_localizations.dart';
import '../services/auth_service.dart';
import '../utils/top_right_notification.dart';
import '../utils/web_asset_helper.dart';

class PremiumScreen extends StatefulWidget {
  const PremiumScreen({super.key, this.embedded = false});

  final bool embedded;

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  // Premium tiles are hosted in runtime external images (/images/*).
  static const String _premiumTilesBasePath = 'images/premium_tiles';
  static const String _premiumTilesCacheVersion = '20260423c';

  bool _loading = true;
  bool _processingCheckout = false;
  bool _processingRedeem = false;
  String _error = '';
  Map<String, dynamic>? _status;
  List<Map<String, dynamic>> _products = const [];
  List<Map<String, dynamic>> _creditItems = const [];
  List<Map<String, dynamic>> _entitlements = const [];
  int _creditBalance = 0;

  bool get _isNl => (AppLocalizations.of(context)?.localeName ?? 'en') == 'nl';

  void _showTopRightMessage(String message, Color backgroundColor) {
    showTopRightFromSnackBar(
      context,
      SnackBar(content: Text(message), backgroundColor: backgroundColor),
    );
  }

  Future<void> _openCheckoutUrl(String checkoutUrl) async {
    final uri = Uri.parse(checkoutUrl);
    final opened = kIsWeb
        ? await launchUrl(uri, webOnlyWindowName: '_self')
        : await launchUrl(uri, mode: LaunchMode.platformDefault);

    if (!opened) {
      throw Exception('checkout_launch_failed');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadData();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _showRedirectFeedback(),
    );
  }

  String _tr(String nl, String en) => _isNl ? nl : en;

  Future<void> _loadData() async {
    setState(() {
      _loading = true;
      _error = '';
    });

    try {
      final apiClient = AuthService().apiClient;
      final purchase = Uri.base.queryParameters['purchase'];
      final purchaseSuffix = purchase == null || purchase.isEmpty
          ? ''
          : '?purchase=${Uri.encodeQueryComponent(purchase)}';
      final responses = await Future.wait([
        apiClient.get('/subscriptions/status$purchaseSuffix'),
        apiClient.get('/subscriptions/checkout/one-time/catalog'),
        apiClient.get('/subscriptions/credits/overview$purchaseSuffix'),
      ]);

      final statusResponse = responses[0];
      final productResponse = responses[1];
      final creditResponse = responses[2];

      if (statusResponse.statusCode != 200 ||
          productResponse.statusCode != 200 ||
          creditResponse.statusCode != 200) {
        throw Exception('premium_load_failed');
      }

      final statusData =
          jsonDecode(statusResponse.body) as Map<String, dynamic>;
      final productData =
          jsonDecode(productResponse.body) as Map<String, dynamic>;
      final creditData =
          jsonDecode(creditResponse.body) as Map<String, dynamic>;

      setState(() {
        _status = statusData;
        _products = (productData['products'] as List<dynamic>? ?? const [])
            .whereType<Map<String, dynamic>>()
            .toList();
        _creditItems = (creditData['items'] as List<dynamic>? ?? const [])
            .whereType<Map<String, dynamic>>()
            .toList();
        _entitlements =
            (creditData['entitlements'] as List<dynamic>? ?? const [])
                .whereType<Map<String, dynamic>>()
                .toList();
        _creditBalance = (creditData['balance'] as num?)?.toInt() ?? 0;
      });
    } catch (_) {
      setState(() {
        _error = _tr(
          'Premiumgegevens konden niet worden geladen.',
          'Premium data could not be loaded.',
        );
      });
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  void _showRedirectFeedback() {
    if (!mounted) return;
    final status = Uri.base.queryParameters['status'];
    final purchase = Uri.base.queryParameters['purchase'];
    if (status == null || status.isEmpty) return;

    String? message;
    Color color = Colors.green;
    if (status == 'paid' || status == 'success') {
      if (purchase == 'one_time') {
        message = _tr(
          'Aankoop ontvangen. Je credits en premium-overzicht worden ververst.',
          'Purchase received. Refreshing your credits and premium overview.',
        );
      } else if (purchase == 'crew_vip') {
        message = _tr(
          'Crew VIP betaling ontvangen. Je premium-overzicht wordt ververst.',
          'Crew VIP payment received. Refreshing your premium overview.',
        );
      } else {
        message = _tr(
          'VIP betaling ontvangen. Je premium-overzicht wordt ververst.',
          'VIP payment received. Refreshing your premium overview.',
        );
      }
    } else if (status == 'cancelled') {
      if (purchase == 'one_time') {
        message = _tr('Aankoop geannuleerd.', 'Purchase cancelled.');
      } else {
        message = _tr('Betaling geannuleerd.', 'Payment cancelled.');
      }
      color = Colors.orange;
    } else if (status == 'failed' || status == 'expired') {
      if (purchase == 'one_time') {
        message = _tr(
          'Aankoop mislukt of verlopen.',
          'Purchase failed or expired.',
        );
      } else {
        message = _tr(
          'Betaling mislukt of verlopen.',
          'Payment failed or expired.',
        );
      }
      color = Colors.red;
    }

    if (message != null) {
      _showTopRightMessage(message, color);
    }
  }

  Future<void> _startCheckout(String type, {String? productKey}) async {
    setState(() => _processingCheckout = true);
    try {
      final apiClient = AuthService().apiClient;
      final crewVip = (_status?['crewVip'] as Map?)?.cast<String, dynamic>();
      final endpoint = type == 'crew_vip'
          ? '/subscriptions/checkout/crew-vip'
          : type == 'player_vip'
          ? '/subscriptions/checkout/player-vip'
          : '/subscriptions/checkout/one-time';
      final body = type == 'crew_vip'
          ? {'crewId': crewVip?['crewId']}
          : type == 'player_vip'
          ? <String, dynamic>{}
          : {'productKey': productKey};

      final response = await apiClient.post(endpoint, body);
      if (response.statusCode != 200) {
        throw Exception('checkout_failed');
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final checkoutUrl = data['url'] as String?;
      if (checkoutUrl == null || checkoutUrl.isEmpty) {
        throw Exception('checkout_missing_url');
      }

      await _openCheckoutUrl(checkoutUrl);
    } catch (_) {
      if (!mounted) return;
      _showTopRightMessage(
        _tr(
          'Openen van de betaalpagina mislukt.',
          'Failed to open the payment page.',
        ),
        Colors.red,
      );
    } finally {
      if (mounted) {
        setState(() => _processingCheckout = false);
      }
    }
  }

  Future<void> _redeemCreditItem(Map<String, dynamic> item) async {
    final effectType = (item['effectType'] ?? '').toString();
    if (effectType == 'VEHICLE_REPAIR_FINISH' ||
        effectType == 'VEHICLE_TUNE_RESET') {
      _showTopRightMessage(
        _tr(
          'Dit item vereist een voertuigkeuze en wordt straks vanuit het voertuigen-scherm ingewisseld.',
          'This item requires a vehicle selection and will be redeemed from the vehicle screen.',
        ),
        Colors.orange,
      );
      return;
    }

    setState(() => _processingRedeem = true);
    try {
      final apiClient = AuthService().apiClient;
      final response = await apiClient.post('/subscriptions/credits/redeem', {
        'itemKey': item['key'],
        if ((item['actionType'] ?? '').toString().isNotEmpty)
          'actionType': item['actionType'],
      });

      final payload = response.body.isNotEmpty
          ? jsonDecode(response.body) as Map<String, dynamic>
          : <String, dynamic>{};
      if (response.statusCode != 200) {
        throw Exception((payload['error'] ?? 'redeem_failed').toString());
      }

      if (!mounted) return;
      _showTopRightMessage(
        (payload['message'] ?? _tr('Credits ingewisseld.', 'Credits redeemed.'))
            .toString(),
        Colors.green,
      );
      await _loadData();
    } catch (_) {
      if (!mounted) return;
      _showTopRightMessage(
        _tr('Credits inwisselen mislukt.', 'Failed to redeem credits.'),
        Colors.red,
      );
    } finally {
      if (mounted) {
        setState(() => _processingRedeem = false);
      }
    }
  }

  String _priceLabel(dynamic raw) {
    final value = (raw ?? '0.00').toString();
    return '\u20AC$value/${_tr('mnd', 'mo')}';
  }

  String _oneTimePriceLabel(dynamic raw) =>
      '\u20AC${(raw ?? '0.00').toString()}';

  String _formatDate(dynamic raw) {
    if (raw == null) return '-';
    try {
      final dt = DateTime.parse(raw.toString()).toLocal();
      return '${dt.day.toString().padLeft(2, '0')}-${dt.month.toString().padLeft(2, '0')}-${dt.year}';
    } catch (_) {
      return raw.toString();
    }
  }

  List<Map<String, dynamic>> get _creditPurchaseOffers => _products
      .where(
        (product) =>
            ((product['reward'] as Map?)?['type'] ?? '').toString() ==
            'credits',
      )
      .toList();

  int _creditAmountFromProduct(Map<String, dynamic> product) {
    final reward =
        (product['reward'] as Map?)?.cast<String, dynamic>() ?? const {};
    return (reward['amount'] as num?)?.toInt() ?? 0;
  }

  Color _offerAccentColor(int amount) {
    if (amount >= 2500) return Colors.deepOrange.shade700;
    if (amount >= 1000) return Colors.amber.shade700;
    if (amount >= 500) return Colors.teal.shade600;
    return Colors.indigo.shade600;
  }

  String _offerImagePath(int amount) {
    if (amount >= 2500) return '$_premiumTilesBasePath/credits_2500.png';
    if (amount >= 1000) return '$_premiumTilesBasePath/credits_1000.png';
    if (amount >= 500) return '$_premiumTilesBasePath/credits_500.png';
    return '$_premiumTilesBasePath/credits_250.png';
  }

  Color _creditItemAccentColor(String effectType) {
    switch (effectType) {
      case 'CASH_BUNDLE':
        return Colors.green.shade700;
      case 'HIT_PROTECTION':
        return Colors.indigo.shade700;
      case 'VEHICLE_REPAIR_FINISH':
        return Colors.deepOrange.shade700;
      case 'VEHICLE_TUNE_RESET':
        return Colors.purple.shade600;
      case 'ACTION_COOLDOWN_RESET':
        return Colors.blueGrey.shade700;
      case 'EVENT_BOOST':
        return Colors.pink.shade600;
      default:
        return Colors.blueGrey.shade600;
    }
  }

  String _creditItemImagePath(Map<String, dynamic> item) {
    switch ((item['effectType'] ?? '').toString()) {
      case 'CASH_BUNDLE':
        return '$_premiumTilesBasePath/shop_cash_bundle.png';
      case 'HIT_PROTECTION':
        return '$_premiumTilesBasePath/shop_hit_protection.png';
      case 'VEHICLE_REPAIR_FINISH':
        return '$_premiumTilesBasePath/shop_vehicle_repair.png';
      case 'VEHICLE_TUNE_RESET':
        return '$_premiumTilesBasePath/shop_tune_reset.png';
      case 'ACTION_COOLDOWN_RESET':
        return '$_premiumTilesBasePath/shop_cooldown_reset.png';
      case 'EVENT_BOOST':
        return '$_premiumTilesBasePath/shop_event_boost.png';
      default:
        return '$_premiumTilesBasePath/credits_250.png';
    }
  }

  String _creditItemThemeLabel(Map<String, dynamic> item) {
    final effectType = (item['effectType'] ?? '').toString();
    final actionType = (item['actionType'] ?? '').toString();
    switch (effectType) {
      case 'CASH_BUNDLE':
        return _tr('Cash boost', 'Cash boost');
      case 'HIT_PROTECTION':
        return _tr('Security', 'Security');
      case 'VEHICLE_REPAIR_FINISH':
        return _tr('Garage', 'Garage');
      case 'VEHICLE_TUNE_RESET':
        return _tr('Tune Shop', 'Tune Shop');
      case 'ACTION_COOLDOWN_RESET':
        if (actionType.isNotEmpty) {
          return _tr('Cooldown: $actionType', 'Cooldown: $actionType');
        }
        return _tr('Cooldown reset', 'Cooldown reset');
      case 'EVENT_BOOST':
        return _tr('Events', 'Events');
      default:
        return _tr('Premium', 'Premium');
    }
  }

  Future<void> _showTileInfoDialog({
    required String title,
    required String body,
  }) async {
    if (!mounted) return;

    final media = MediaQuery.of(context);
    final maxWidth = media.size.width >= 900
        ? 560.0
        : media.size.width >= 600
        ? 500.0
        : media.size.width - 24;
    final maxHeight = media.size.height * 0.72;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        final colorScheme = Theme.of(dialogContext).colorScheme;
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 20,
          ),
          backgroundColor: colorScheme.surface,
          child: SafeArea(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: maxWidth,
                maxHeight: maxHeight,
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: Theme.of(dialogContext).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ),
                        IconButton(
                          tooltip: _tr('Sluiten', 'Close'),
                          onPressed: () => Navigator.of(dialogContext).pop(),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Text(
                          body,
                          style: Theme.of(dialogContext).textTheme.bodyMedium,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: FilledButton(
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        child: Text(_tr('Sluiten', 'Close')),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String _imageRelativePath(String imagePath) {
    if (_isAbsoluteUrl(imagePath)) {
      final uri = Uri.tryParse(imagePath);
      final fromPath = uri?.path ?? imagePath;
      return fromPath.startsWith('/') ? fromPath.substring(1) : fromPath;
    }

    final normalized = WebAssetHelper.normalizeAssetPath(imagePath);
    if (normalized.startsWith('assets/images/')) {
      return normalized.substring('assets/images/'.length);
    }
    if (normalized.startsWith('assets/assets/images/')) {
      return normalized.substring('assets/assets/images/'.length);
    }
    if (normalized.startsWith('images/')) {
      return normalized.substring('images/'.length);
    }
    if (normalized.startsWith('/images/')) {
      return normalized.substring('/images/'.length);
    }
    return normalized.startsWith('/') ? normalized.substring(1) : normalized;
  }

  String _withCacheVersion(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return url;

    final nextQuery = Map<String, String>.from(uri.queryParameters);
    nextQuery['v'] = _premiumTilesCacheVersion;
    return uri.replace(queryParameters: nextQuery).toString();
  }

  List<String> _premiumTileWebCandidates(String imagePath) {
    if (_isAbsoluteUrl(imagePath)) {
      return <String>[_withCacheVersion(imagePath)];
    }

    final suffix = _imageRelativePath(imagePath);
    final base = Uri.base;
    final isDefaultPort =
        (base.scheme == 'https' && base.port == 443) ||
        (base.scheme == 'http' && base.port == 80);
    final host = isDefaultPort ? base.host : '${base.host}:${base.port}';
    final origin = '${base.scheme}://$host';

    final rawCandidates = <String>[
      '$origin/images/$suffix',
      '$origin/assets/images/$suffix',
      WebAssetHelper.toPublicUrl('images/$suffix'),
      WebAssetHelper.toPublicUrl('assets/images/$suffix'),
      WebAssetHelper.toPublicUrl(imagePath),
    ];

    final unique = <String>{};
    final result = <String>[];
    for (final url in rawCandidates) {
      final resolved = _withCacheVersion(url);
      if (unique.add(resolved)) {
        result.add(resolved);
      }
    }
    return result;
  }

  bool _isAbsoluteUrl(String value) {
    final uri = Uri.tryParse(value);
    return uri != null && uri.hasScheme && uri.host.isNotEmpty;
  }

  Widget _buildWebNetworkChain({
    required List<String> urls,
    required int index,
    required Widget fallback,
  }) {
    if (index >= urls.length) {
      return fallback;
    }

    return Image.network(
      urls[index],
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return _buildWebNetworkChain(
          urls: urls,
          index: index + 1,
          fallback: fallback,
        );
      },
    );
  }

  Widget _buildTileImage({
    required String imagePath,
    required IconData icon,
    required Color accent,
    required Color fallbackBackground,
  }) {
    Widget fallback(
      BuildContext context,
      Object error,
      StackTrace? stackTrace,
    ) {
      return Container(
        color: fallbackBackground,
        child: Icon(icon, size: 56, color: accent.withOpacity(0.75)),
      );
    }

    if (kIsWeb) {
      return _buildWebNetworkChain(
        urls: _premiumTileWebCandidates(imagePath),
        index: 0,
        fallback: fallback(context, Exception('premium_image_missing'), null),
      );
    }

    return WebAssetHelper.image(
      imagePath,
      fit: BoxFit.cover,
      errorBuilder: fallback,
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color accent,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: accent.withOpacity(0.14),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: accent),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildResponsiveTileGrid({
    required List<Widget> children,
    double minTileWidth = 260,
    int maxColumns = 4,
    double spacing = 12,
  }) {
    if (children.isEmpty) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.of(context).size.width;
        final estimatedColumns = (maxWidth / minTileWidth).floor();
        final columns = estimatedColumns.clamp(1, maxColumns);
        final totalSpacing = spacing * (columns - 1);
        final tileWidth = (maxWidth - totalSpacing) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: children
              .map((child) => SizedBox(width: tileWidth, child: child))
              .toList(),
        );
      },
    );
  }

  Widget _buildVisualTile({
    required String title,
    required String subtitle,
    required String imagePath,
    required Color accent,
    required IconData icon,
    required String actionLabel,
    required VoidCallback? onPressed,
    String? primaryValue,
    String? secondaryValue,
    String? badgeLabel,
    String? infoTitle,
    String? infoBody,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final resolvedInfoTitle = (infoTitle ?? title).trim();
    final resolvedInfoBody = (infoBody ?? subtitle).trim();
    final hasTitle = title.trim().isNotEmpty;

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accent.withOpacity(0.35)),
        boxShadow: [
          BoxShadow(
            color: accent.withOpacity(0.1),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: AspectRatio(
        aspectRatio: 1,
        child: Stack(
          fit: StackFit.expand,
          children: [
            _buildTileImage(
              imagePath: imagePath,
              icon: icon,
              accent: accent,
              fallbackBackground: colorScheme.surfaceContainerHighest,
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.08),
                    Colors.black.withOpacity(0.68),
                  ],
                ),
              ),
            ),
            if (badgeLabel != null && badgeLabel.trim().isNotEmpty)
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.52),
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: Colors.white.withOpacity(0.35)),
                  ),
                  child: Text(
                    badgeLabel,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            if (resolvedInfoBody.isNotEmpty)
              Positioned(
                top: 10,
                left: 10,
                child: Material(
                  color: Colors.black.withOpacity(0.52),
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () => _showTileInfoDialog(
                      title: resolvedInfoTitle,
                      body: resolvedInfoBody,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(8),
                      child: Icon(
                        Icons.info_outline,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ),
            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final compact = constraints.maxWidth < 225;
                  return Container(
                    padding: EdgeInsets.all(compact ? 10 : 12),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (hasTitle)
                          Row(
                            children: [
                              Icon(
                                icon,
                                color: Colors.white,
                                size: compact ? 16 : 18,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.titleSmall
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        if (primaryValue != null &&
                            primaryValue.trim().isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            primaryValue,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ],
                        if (secondaryValue != null &&
                            secondaryValue.trim().isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            secondaryValue,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Colors.white.withOpacity(0.8),
                                ),
                          ),
                        ],
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: onPressed,
                            style: FilledButton.styleFrom(
                              backgroundColor: accent,
                              foregroundColor: Colors.white,
                              minimumSize: Size.fromHeight(compact ? 34 : 38),
                              padding: EdgeInsets.symmetric(
                                vertical: compact ? 8 : 10,
                              ),
                            ),
                            child: Text(
                              actionLabel,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusStrip() {
    final playerVip =
        (_status?['playerVip'] as Map?)?.cast<String, dynamic>() ?? const {};
    final crewVip = (_status?['crewVip'] as Map?)?.cast<String, dynamic>();

    return _buildResponsiveTileGrid(
      minTileWidth: 180,
      maxColumns: 3,
      children: [
        _buildKpiCard(
          _tr('Speler VIP', 'Player VIP'),
          playerVip['isVip'] == true
              ? _tr('Actief', 'Active')
              : _tr('Inactief', 'Inactive'),
          Icons.workspace_premium,
          accent: Colors.amber.shade700,
        ),
        _buildKpiCard(
          _tr('Crew VIP', 'Crew VIP'),
          crewVip == null
              ? _tr('Geen crew', 'No crew')
              : (crewVip['isVip'] == true
                    ? _tr('Actief', 'Active')
                    : _tr('Inactief', 'Inactive')),
          Icons.groups,
          accent: Colors.indigo.shade600,
        ),
        _buildKpiCard(
          _tr('Credits', 'Credits'),
          _creditBalance.toString(),
          Icons.token,
          accent: Colors.teal.shade600,
        ),
      ],
    );
  }

  Widget _buildKpiCard(
    String label,
    String value,
    IconData icon, {
    required Color accent,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: accent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accent.withOpacity(0.35)),
      ),
      child: Row(
        children: [
          Icon(icon, color: accent),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: accent,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVipPlans() {
    final playerVip =
        (_status?['playerVip'] as Map?)?.cast<String, dynamic>() ?? const {};
    final crewVip = (_status?['crewVip'] as Map?)?.cast<String, dynamic>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          title: _tr('VIP abonnementen', 'VIP subscriptions'),
          subtitle: _tr(
            'Professionele VIP-tiles met duidelijke prijzen, status en benefits.',
            'Professional VIP tiles with clear pricing, status and benefits.',
          ),
          icon: Icons.workspace_premium,
          accent: Colors.amber.shade700,
        ),
        const SizedBox(height: 12),
        _buildResponsiveTileGrid(
          minTileWidth: 300,
          maxColumns: 2,
          children: [
            _buildVisualTile(
              title: _tr('Speler VIP', 'Player VIP'),
              subtitle: _tr(
                'Exclusieve accountvoordelen, avatar unlocks en premium QoL.',
                'Exclusive account perks, avatar unlocks and premium QoL.',
              ),
              imagePath: '$_premiumTilesBasePath/player_vip.png',
              accent: Colors.amber.shade700,
              icon: Icons.person,
              primaryValue: _priceLabel(playerVip['monthlyPriceEur']),
              secondaryValue: playerVip['expiresAt'] == null
                  ? null
                  : _tr(
                      'Actief tot ${_formatDate(playerVip['expiresAt'])}',
                      'Active until ${_formatDate(playerVip['expiresAt'])}',
                    ),
              badgeLabel: playerVip['isVip'] == true
                  ? _tr('Actief', 'Active')
                  : _tr('VIP', 'VIP'),
              actionLabel: playerVip['isVip'] == true
                  ? _tr('Verleng VIP', 'Extend VIP')
                  : _tr('Koop VIP', 'Buy VIP'),
              infoTitle: _tr('Speler VIP voordelen', 'Player VIP benefits'),
              infoBody: _tr(
                'Player VIP voordelen:\n'
                    '- 10% kortere timeout/cooldowns op acties (gevangenistijd blijft gelijk).\n'
                    '- In Drugs Productie krijg je een VIP bliksemknop op de productiekaart om ontbrekende materialen in 1 klik te kopen (na kostenbevestiging).\n'
                    '- Bij moord verlies je contant geld, maar je herstart met EUR 500.000 cash.\n'
                    '- Je rank wordt gehalveerd in plaats van volledige reset.\n'
                    '- Opleidingen en vrijgespeelde achievements blijven behouden.\n'
                    '- Banksaldo en crypto blijven behouden.\n'
                    '- Eigendommen, voertuigen, prostituees, gedragen inventaris en opgeslagen items worden wel verwijderd.\n'
                    '- Drugsprogress en drugsvoorraad worden gereset.\n'
                    '- Je ontvangt wekelijks 100 premium credits zolang VIP actief is.',
                'Player VIP benefits:\n'
                    '- 10% shorter action timeouts/cooldowns (jail time stays unchanged).\n'
                    '- In Drug Production, you get a VIP lightning button on each production card to buy missing materials in one click (after cost confirmation).\n'
                    '- On death, you lose on-hand cash but restart with EUR 500,000 cash.\n'
                    '- Your rank is halved instead of a full reset.\n'
                    '- Education progress and unlocked achievements are preserved.\n'
                    '- Bank balance and crypto are preserved.\n'
                    '- Properties, vehicles, prostitutes, carried inventory and stored items are removed.\n'
                    '- Drug progress and drug stock are reset.\n'
                    '- You receive 100 premium credits weekly while VIP is active.',
              ),
              onPressed: _processingCheckout
                  ? null
                  : () => _startCheckout('player_vip'),
            ),
            _buildVisualTile(
              title: _tr('Crew VIP', 'Crew VIP'),
              subtitle: crewVip == null
                  ? _tr(
                      'Je moet eerst in een crew zitten om Crew VIP te activeren.',
                      'You must be in a crew before you can activate Crew VIP.',
                    )
                  : _tr(
                      'Voor crew-upgrades, side buildings level 11-15 en gedeelde perks.',
                      'For crew upgrades, side buildings level 11-15 and shared perks.',
                    ),
              imagePath: '$_premiumTilesBasePath/crew_vip.png',
              accent: Colors.indigo.shade600,
              icon: Icons.groups,
              primaryValue: _priceLabel(crewVip?['monthlyPriceEur']),
              secondaryValue: crewVip?['expiresAt'] == null
                  ? null
                  : _tr(
                      'Actief tot ${_formatDate(crewVip?['expiresAt'])}',
                      'Active until ${_formatDate(crewVip?['expiresAt'])}',
                    ),
              badgeLabel: crewVip == null
                  ? _tr('Crew nodig', 'Crew needed')
                  : (crewVip['isVip'] == true
                        ? _tr('Actief', 'Active')
                        : _tr('Crew VIP', 'Crew VIP')),
              actionLabel: crewVip == null
                  ? _tr('Crew vereist', 'Crew required')
                  : (crewVip['isVip'] == true
                        ? _tr('Verleng Crew VIP', 'Extend Crew VIP')
                        : _tr('Koop Crew VIP', 'Buy Crew VIP')),
              infoTitle: _tr('Crew VIP voordelen', 'Crew VIP benefits'),
              infoBody: crewVip == null
                  ? _tr(
                      'Je moet eerst lid zijn van een crew om Crew VIP te kopen. '
                          'Crew VIP unlockt crew-gerichte voordelen en hogere upgrade-progressie.',
                      'You must join a crew before buying Crew VIP. '
                          'Crew VIP unlocks crew-focused perks and higher upgrade progression.',
                    )
                  : _tr(
                      'Crew VIP geeft toegang tot extra crew-upgrades en gedeelde premium voordelen voor je crewflow. '
                          'Na aankoop wordt de actieve status en vervaldatum direct bijgewerkt.',
                      'Crew VIP grants access to extra crew upgrades and shared premium perks for your crew flow. '
                          'After purchase, active status and expiry are updated immediately.',
                    ),
              onPressed: crewVip == null || _processingCheckout
                  ? null
                  : () => _startCheckout('crew_vip'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCreditPurchases() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          title: _tr('Credits kopen', 'Buy credits'),
          subtitle: _tr(
            'Kies een bundel in tegelvorm. Populaire 1000-credit optie krijgt een eigen spotlight.',
            'Pick a bundle via visual tiles. Popular 1000-credit option gets its own spotlight.',
          ),
          icon: Icons.payments,
          accent: Colors.teal.shade600,
        ),
        const SizedBox(height: 8),
        if (_creditPurchaseOffers.isEmpty)
          Text(
            _tr(
              'Er zijn nu geen creditbundels actief.',
              'There are no active credit bundles right now.',
            ),
          )
        else
          _buildResponsiveTileGrid(
            minTileWidth: 230,
            maxColumns: 4,
            children: _creditPurchaseOffers
                .map((product) => _buildCreditOfferCard(product))
                .toList(),
          ),
      ],
    );
  }

  Widget _buildCreditOfferCard(Map<String, dynamic> product) {
    final amount = _creditAmountFromProduct(product);
    final title = _isNl
        ? (product['titleNl'] ?? '')
        : (product['titleEn'] ?? '');
    final description = _isNl
        ? (product['descriptionNl'] ?? '')
        : (product['descriptionEn'] ?? '');
    final accent = _offerAccentColor(amount);
    final configuredImage = (product['imageUrl'] ?? '').toString().trim();
    final imagePath = configuredImage.isNotEmpty
        ? configuredImage
        : _offerImagePath(amount);
    final isLargeOffer = amount >= 1000;
    final resolvedTitle = title.toString().trim().isEmpty
        ? _tr('Creditbundel', 'Credit bundle')
        : title.toString();
    final resolvedDescription = description.toString().trim().isEmpty
        ? _tr(
            'Direct credits voor je premium wallet.',
            'Instant credits for your premium wallet.',
          )
        : description.toString();
    final bundleCta = _tr('Koop $amount credits', 'Buy $amount credits');
    final bundlePrice = _oneTimePriceLabel(product['priceEur']);

    return _buildVisualTile(
      title: '',
      subtitle: resolvedDescription,
      imagePath: imagePath,
      accent: accent,
      icon: Icons.token,
      primaryValue: _tr('$amount credits', '$amount credits'),
      secondaryValue: bundlePrice,
      badgeLabel: amount >= 2500
          ? _tr('Ultra deal', 'Ultra deal')
          : (isLargeOffer
                ? _tr('Top deal', 'Top deal')
                : _tr('Credits', 'Credits')),
      actionLabel: bundleCta,
      infoTitle: resolvedTitle,
      infoBody: _tr(
        '$bundleCta voor $bundlePrice.\n\n$resolvedDescription',
        '$bundleCta for $bundlePrice.\n\n$resolvedDescription',
      ),
      onPressed: _processingCheckout
          ? null
          : () => _startCheckout(
              'one_time',
              productKey: (product['key'] ?? '').toString(),
            ),
    );
  }

  Widget _buildCreditShop() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          title: _tr('Credit shop', 'Credit shop'),
          subtitle: _tr(
            'Per item een themategel op basis van het effect dat je koopt.',
            'Each item uses a themed tile based on the effect you are buying.',
          ),
          icon: Icons.local_mall,
          accent: Colors.purple.shade500,
        ),
        const SizedBox(height: 8),
        _buildResponsiveTileGrid(
          minTileWidth: 240,
          maxColumns: 4,
          children: _creditItems.map((item) {
            final fallbackCost = (item['creditCost'] as num?)?.toInt() ?? 0;
            final effectiveCost =
                (item['effectiveCreditCost'] as num?)?.toInt() ?? fallbackCost;
            final canRedeemNow = item['canRedeemNow'] != false;
            final unavailableReason = (item['unavailableReason'] ?? '')
                .toString()
                .trim();
            final title = _isNl
                ? (item['titleNl'] ?? '')
                : (item['titleEn'] ?? '');
            final description = _isNl
                ? (item['descriptionNl'] ?? '')
                : (item['descriptionEn'] ?? '');
            final disabled =
                _processingRedeem ||
                _creditBalance < effectiveCost ||
                !canRedeemNow;
            final effectType = (item['effectType'] ?? '').toString();
            final accent = _creditItemAccentColor(effectType);
            final resolvedTitle = title.toString().trim().isEmpty
                ? _tr('Premium item', 'Premium item')
                : title.toString();
            final resolvedDescription = description.toString().trim().isEmpty
                ? _tr('Direct premium voordeel.', 'Direct premium perk.')
                : description.toString();
            final actionLabel =
                !canRedeemNow &&
                    unavailableReason == 'ACTION_COOLDOWN_NOT_ACTIVE'
                ? _tr('Geen actieve cooldown', 'No active cooldown')
                : (_creditBalance < effectiveCost
                      ? _tr('Niet genoeg credits', 'Not enough credits')
                      : _tr('Inwisselen', 'Redeem'));

            return _buildVisualTile(
              title: resolvedTitle,
              subtitle: resolvedDescription,
              imagePath: _creditItemImagePath(item),
              accent: accent,
              icon: Icons.auto_awesome,
              primaryValue: _tr(
                '$effectiveCost credits',
                '$effectiveCost credits',
              ),
              secondaryValue: _creditItemThemeLabel(item),
              badgeLabel: _tr('Shop', 'Shop'),
              actionLabel: actionLabel,
              infoTitle: resolvedTitle,
              infoBody: _tr(
                '$resolvedDescription\n\nThema: ${_creditItemThemeLabel(item)}\nKosten: $effectiveCost credits',
                '$resolvedDescription\n\nTheme: ${_creditItemThemeLabel(item)}\nCost: $effectiveCost credits',
              ),
              onPressed: disabled ? null : () => _redeemCreditItem(item),
            );
          }).toList(),
        ),
        if (_entitlements.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            _tr('Actieve premium effecten', 'Active premium effects'),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _entitlements.map((entitlement) {
              final key = (entitlement['key'] ?? '').toString();
              final expiresAt = entitlement['expiresAt'];
              return Chip(
                label: Text(
                  expiresAt == null ? key : '$key - ${_formatDate(expiresAt)}',
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_error),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: _loadData,
              child: Text(_tr('Opnieuw proberen', 'Retry')),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            _tr('Premium & Credits', 'Premium & Credits'),
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            _tr(
              'Hier beheren spelers hun VIP abonnementen, creditbundels en credit-shop items.',
              'Players manage VIP subscriptions, credit bundles and credit shop items here.',
            ),
          ),
          const SizedBox(height: 16),
          _buildStatusStrip(),
          const SizedBox(height: 24),
          _buildVipPlans(),
          const SizedBox(height: 24),
          _buildCreditPurchases(),
          const SizedBox(height: 24),
          _buildCreditShop(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.embedded) {
      return _buildBody();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_tr('Premium & Credits', 'Premium & Credits')),
      ),
      body: _buildBody(),
    );
  }
}
