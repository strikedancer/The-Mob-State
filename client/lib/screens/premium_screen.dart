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

  /// Catalog fields from API are provided as Dutch + English only.
  bool _useNlCatalogCopy(BuildContext context) =>
      Localizations.localeOf(context).languageCode == 'nl';

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
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      setState(() {
        _error = l10n.premiumUiLoadError;
      });
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  void _showRedirectFeedback() {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    final status = Uri.base.queryParameters['status'];
    final purchase = Uri.base.queryParameters['purchase'];
    if (status == null || status.isEmpty) return;

    String? message;
    Color color = Colors.green;
    if (status == 'paid' || status == 'success') {
      if (purchase == 'one_time') {
        message = l10n.premiumUiRedirectPaidOneTime;
      } else if (purchase == 'crew_vip') {
        message = l10n.premiumUiRedirectPaidCrewVip;
      } else {
        message = l10n.premiumUiRedirectPaidVip;
      }
    } else if (status == 'cancelled') {
      if (purchase == 'one_time') {
        message = l10n.premiumUiRedirectCancelledOneTime;
      } else {
        message = l10n.premiumUiRedirectCancelledSubscription;
      }
      color = Colors.orange;
    } else if (status == 'failed' || status == 'expired') {
      if (purchase == 'one_time') {
        message = l10n.premiumUiRedirectFailedOneTime;
      } else {
        message = l10n.premiumUiRedirectFailedSubscription;
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
      final l10n = AppLocalizations.of(context)!;
      _showTopRightMessage(
        l10n.premiumUiCheckoutOpenFailed,
        Colors.red,
      );
    } finally {
      if (mounted) {
        setState(() => _processingCheckout = false);
      }
    }
  }

  String _prestigeLabel(AppLocalizations l10n, String? tier) {
    switch ((tier ?? 'none').toLowerCase()) {
      case 'bronze':
        return l10n.premiumUiPrestigeBronze;
      case 'silver':
        return l10n.premiumUiPrestigeSilver;
      case 'gold':
        return l10n.premiumUiPrestigeGold;
      default:
        return l10n.premiumUiPrestigeNone;
    }
  }

  Future<void> _cancelVipRenewal(String target) async {
    final l10n = AppLocalizations.of(context)!;
    final vipMap = target == 'crew'
        ? (_status?['crewVip'] as Map?)?.cast<String, dynamic>()
        : (_status?['playerVip'] as Map?)?.cast<String, dynamic>();
    final expires = vipMap?['expiresAt'];
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.premiumUiCancelRenewal),
        content: Text(
          l10n.premiumUiCancelRenewalConfirm(
            expires == null ? '—' : _formatDate(expires),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.premiumUiCancelRenewal),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _processingCheckout = true);
    try {
      final response = await AuthService().apiClient.post(
        '/subscriptions/vip/cancel',
        {'target': target},
      );
      if (response.statusCode != 200) {
        throw Exception('cancel_failed');
      }
      await _loadData();
      if (!mounted) return;
      _showTopRightMessage(l10n.premiumUiCancelRenewalSuccess, Colors.green);
    } catch (_) {
      if (!mounted) return;
      _showTopRightMessage(l10n.premiumUiCancelRenewalFailed, Colors.red);
    } finally {
      if (mounted) setState(() => _processingCheckout = false);
    }
  }

  Future<void> _giftPlayerVip() async {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController();
    final username = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.premiumUiGiftVip),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.premiumUiGiftVipHint),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              autofocus: true,
              decoration: InputDecoration(
                labelText: l10n.premiumUiGiftVipUsername,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: Text(l10n.premiumUiGiftVipConfirm),
          ),
        ],
      ),
    );
    controller.dispose();
    if (username == null || username.isEmpty || !mounted) return;

    setState(() => _processingCheckout = true);
    try {
      final response = await AuthService().apiClient.post(
        '/subscriptions/checkout/gift-player-vip',
        {'recipientUsername': username},
      );
      if (response.statusCode != 200) {
        throw Exception('gift_failed');
      }
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final checkoutUrl = data['url'] as String?;
      if (checkoutUrl == null || checkoutUrl.isEmpty) {
        throw Exception('checkout_missing_url');
      }
      await _openCheckoutUrl(checkoutUrl);
    } catch (_) {
      if (!mounted) return;
      _showTopRightMessage(l10n.premiumUiGiftVipFailed, Colors.red);
    } finally {
      if (mounted) setState(() => _processingCheckout = false);
    }
  }

  Future<void> _giftCrewVip() async {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController();
    final crewName = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.premiumUiGiftCrewVip),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.premiumUiGiftCrewVipHint),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              autofocus: true,
              decoration: InputDecoration(
                labelText: l10n.premiumUiGiftCrewVipName,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: Text(l10n.premiumUiGiftVipConfirm),
          ),
        ],
      ),
    );
    controller.dispose();
    if (crewName == null || crewName.isEmpty || !mounted) return;

    setState(() => _processingCheckout = true);
    try {
      final response = await AuthService().apiClient.post(
        '/subscriptions/checkout/gift-crew-vip',
        {'recipientCrewName': crewName},
      );
      if (response.statusCode != 200) {
        throw Exception('gift_crew_failed');
      }
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final checkoutUrl = data['url'] as String?;
      if (checkoutUrl == null || checkoutUrl.isEmpty) {
        throw Exception('checkout_missing_url');
      }
      await _openCheckoutUrl(checkoutUrl);
    } catch (_) {
      if (!mounted) return;
      _showTopRightMessage(l10n.premiumUiGiftCrewVipFailed, Colors.red);
    } finally {
      if (mounted) setState(() => _processingCheckout = false);
    }
  }

  Future<void> _redeemCreditItem(Map<String, dynamic> item) async {
    final effectType = (item['effectType'] ?? '').toString();
    if (effectType == 'VEHICLE_REPAIR_FINISH' ||
        effectType == 'VEHICLE_TUNE_RESET') {
      final l10n = AppLocalizations.of(context)!;
      _showTopRightMessage(
        l10n.premiumUiRedeemNeedsVehicle,
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
      final l10n = AppLocalizations.of(context)!;
      _showTopRightMessage(
        (payload['message'] ?? l10n.premiumUiRedeemSuccessDefault).toString(),
        Colors.green,
      );
      await _loadData();
    } catch (_) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      _showTopRightMessage(
        l10n.premiumUiRedeemFailed,
        Colors.red,
      );
    } finally {
      if (mounted) {
        setState(() => _processingRedeem = false);
      }
    }
  }

  String _priceLabel(dynamic raw, AppLocalizations l10n) {
    final value = (raw ?? '0.00').toString();
    return '\u20AC$value/${l10n.premiumUiPerMonthShort}';
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

  String _creditItemThemeLabel(Map<String, dynamic> item, AppLocalizations l10n) {
    final effectType = (item['effectType'] ?? '').toString();
    final actionType = (item['actionType'] ?? '').toString();
    switch (effectType) {
      case 'CASH_BUNDLE':
        return l10n.premiumUiCreditThemeCashBoost;
      case 'HIT_PROTECTION':
        return l10n.premiumUiCreditThemeSecurity;
      case 'VEHICLE_REPAIR_FINISH':
        return l10n.premiumUiCreditThemeGarage;
      case 'VEHICLE_TUNE_RESET':
        return l10n.premiumUiCreditThemeTuneShop;
      case 'ACTION_COOLDOWN_RESET':
        if (actionType.isNotEmpty) {
          return l10n.premiumUiCreditThemeCooldown(actionType);
        }
        return l10n.premiumUiCreditThemeCooldownReset;
      case 'EVENT_BOOST':
        return l10n.premiumUiCreditThemeEvents;
      default:
        return l10n.premiumUiCreditThemePremium;
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
        final dlgL10n = AppLocalizations.of(dialogContext)!;
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
                          tooltip: dlgL10n.close,
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
                        child: Text(dlgL10n.close),
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

  Widget _buildStatusStrip(AppLocalizations l10n) {
    final playerVip =
        (_status?['playerVip'] as Map?)?.cast<String, dynamic>() ?? const {};
    final crewVip = (_status?['crewVip'] as Map?)?.cast<String, dynamic>();
    final lifetimeDays = (playerVip['lifetimeDays'] as num?)?.toInt() ?? 0;

    return _buildResponsiveTileGrid(
      minTileWidth: 180,
      maxColumns: 4,
      children: [
        _buildKpiCard(
          l10n.premiumUiKpiPlayerVip,
          playerVip['isVip'] == true
              ? l10n.premiumUiStatusActive
              : l10n.premiumUiStatusInactive,
          Icons.workspace_premium,
          accent: Colors.amber.shade700,
        ),
        _buildKpiCard(
          l10n.premiumUiKpiCrewVip,
          crewVip == null
              ? l10n.premiumUiNoCrew
              : (crewVip['isVip'] == true
                    ? l10n.premiumUiStatusActive
                    : l10n.premiumUiStatusInactive),
          Icons.groups,
          accent: Colors.indigo.shade600,
        ),
        _buildKpiCard(
          l10n.premiumUiCreditsLabel,
          _creditBalance.toString(),
          Icons.token,
          accent: Colors.teal.shade600,
        ),
        _buildKpiCard(
          l10n.premiumUiPrestigeLabel,
          '${_prestigeLabel(l10n, playerVip['prestigeTier']?.toString())} · ${l10n.premiumUiPrestigeDays(lifetimeDays)}',
          Icons.military_tech,
          accent: Colors.deepOrange.shade600,
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

  Widget _buildVipPlans(AppLocalizations l10n) {
    final playerVip =
        (_status?['playerVip'] as Map?)?.cast<String, dynamic>() ?? const {};
    final crewVip = (_status?['crewVip'] as Map?)?.cast<String, dynamic>();
    final playerAutoRenew = playerVip['autoRenewActive'] == true;
    final crewAutoRenew = crewVip?['autoRenewActive'] == true;

    String? playerSecondary() {
      final parts = <String>[];
      if (playerVip['expiresAt'] != null) {
        parts.add(
          l10n.premiumUiActiveUntil(_formatDate(playerVip['expiresAt'])),
        );
      }
      parts.add(
        playerAutoRenew
            ? l10n.premiumUiAutoRenewActive
            : l10n.premiumUiAutoRenewOff,
      );
      return parts.join(' · ');
    }

    String? crewSecondary() {
      if (crewVip == null) return null;
      final parts = <String>[];
      if (crewVip['expiresAt'] != null) {
        parts.add(
          l10n.premiumUiActiveUntil(_formatDate(crewVip['expiresAt'])),
        );
      }
      parts.add(
        crewAutoRenew
            ? l10n.premiumUiAutoRenewActive
            : l10n.premiumUiAutoRenewOff,
      );
      return parts.join(' · ');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          title: l10n.premiumUiSectionVipTitle,
          subtitle: l10n.premiumUiSectionVipSubtitle,
          icon: Icons.workspace_premium,
          accent: Colors.amber.shade700,
        ),
        const SizedBox(height: 12),
        _buildResponsiveTileGrid(
          minTileWidth: 300,
          maxColumns: 2,
          children: [
            _buildVisualTile(
              title: l10n.premiumUiKpiPlayerVip,
              subtitle: l10n.premiumUiPlayerVipSubtitle,
              imagePath: '$_premiumTilesBasePath/player_vip.png',
              accent: Colors.amber.shade700,
              icon: Icons.person,
              primaryValue: _priceLabel(playerVip['monthlyPriceEur'], l10n),
              secondaryValue: playerSecondary(),
              badgeLabel: playerVip['isVip'] == true
                  ? l10n.premiumUiStatusActive
                  : l10n.premiumUiBadgeVip,
              actionLabel: playerVip['isVip'] == true
                  ? l10n.premiumUiExtendVip
                  : l10n.premiumUiBuyVip,
              infoTitle: l10n.premiumUiPlayerVipBenefitsTitle,
              infoBody: l10n.premiumUiPlayerVipBenefitsBody,
              onPressed: _processingCheckout
                  ? null
                  : () => _startCheckout('player_vip'),
            ),
            _buildVisualTile(
              title: l10n.premiumUiKpiCrewVip,
              subtitle: crewVip == null
                  ? l10n.premiumUiCrewVipSubtitleNoCrew
                  : l10n.premiumUiCrewVipSubtitleInCrew,
              imagePath: '$_premiumTilesBasePath/crew_vip.png',
              accent: Colors.indigo.shade600,
              icon: Icons.groups,
              primaryValue: _priceLabel(crewVip?['monthlyPriceEur'], l10n),
              secondaryValue: crewSecondary(),
              badgeLabel: crewVip == null
                  ? l10n.premiumUiBadgeCrewNeeded
                  : (crewVip['isVip'] == true
                        ? l10n.premiumUiStatusActive
                        : l10n.premiumUiBadgeCrewVipLabel),
              actionLabel: crewVip == null
                  ? l10n.premiumUiCtaCrewRequired
                  : (crewVip['isVip'] == true
                        ? l10n.premiumUiExtendCrewVip
                        : l10n.premiumUiBuyCrewVip),
              infoTitle: l10n.premiumUiCrewVipBenefitsTitle,
              infoBody: crewVip == null
                  ? l10n.premiumUiCrewVipBenefitsNoCrewBody
                  : l10n.premiumUiCrewVipBenefitsInCrewBody,
              onPressed: crewVip == null || _processingCheckout
                  ? null
                  : () => _startCheckout('crew_vip'),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            OutlinedButton.icon(
              onPressed: _processingCheckout ? null : _giftPlayerVip,
              icon: const Icon(Icons.card_giftcard, size: 18),
              label: Text(l10n.premiumUiGiftVip),
            ),
            OutlinedButton.icon(
              onPressed: _processingCheckout ? null : _giftCrewVip,
              icon: const Icon(Icons.card_giftcard, size: 18),
              label: Text(l10n.premiumUiGiftCrewVip),
            ),
            if (playerAutoRenew)
              OutlinedButton.icon(
                onPressed: _processingCheckout
                    ? null
                    : () => _cancelVipRenewal('player'),
                icon: const Icon(Icons.cancel_schedule_send, size: 18),
                label: Text(l10n.premiumUiCancelRenewal),
              ),
            if (crewAutoRenew)
              OutlinedButton.icon(
                onPressed: _processingCheckout
                    ? null
                    : () => _cancelVipRenewal('crew'),
                icon: const Icon(Icons.cancel_schedule_send, size: 18),
                label: Text('${l10n.premiumUiCancelRenewal} (crew)'),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildCreditPurchases(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          title: l10n.premiumUiSectionBuyCreditsTitle,
          subtitle: l10n.premiumUiSectionBuyCreditsSubtitle,
          icon: Icons.payments,
          accent: Colors.teal.shade600,
        ),
        const SizedBox(height: 8),
        if (_creditPurchaseOffers.isEmpty)
          Text(
            l10n.premiumUiNoCreditBundles,
          )
        else
          _buildResponsiveTileGrid(
            minTileWidth: 230,
            maxColumns: 4,
            children: _creditPurchaseOffers
                .map((product) => _buildCreditOfferCard(product, l10n))
                .toList(),
          ),
      ],
    );
  }

  Widget _buildCreditOfferCard(
    Map<String, dynamic> product,
    AppLocalizations l10n,
  ) {
    final amount = _creditAmountFromProduct(product);
    final useNl = _useNlCatalogCopy(context);
    final title = useNl
        ? (product['titleNl'] ?? '')
        : (product['titleEn'] ?? '');
    final description = useNl
        ? (product['descriptionNl'] ?? '')
        : (product['descriptionEn'] ?? '');
    final accent = _offerAccentColor(amount);
    final configuredImage = (product['imageUrl'] ?? '').toString().trim();
    final imagePath = configuredImage.isNotEmpty
        ? configuredImage
        : _offerImagePath(amount);
    final isLargeOffer = amount >= 1000;
    final resolvedTitle = title.toString().trim().isEmpty
        ? l10n.premiumUiCreditBundleFallbackTitle
        : title.toString();
    final resolvedDescription = description.toString().trim().isEmpty
        ? l10n.premiumUiCreditBundleFallbackDescription
        : description.toString();
    final bundleCta = l10n.premiumUiBuyCredits(amount);
    final bundlePrice = _oneTimePriceLabel(product['priceEur']);

    return _buildVisualTile(
      title: '',
      subtitle: resolvedDescription,
      imagePath: imagePath,
      accent: accent,
      icon: Icons.token,
      primaryValue: l10n.premiumUiCreditsCount(amount),
      secondaryValue: bundlePrice,
      badgeLabel: amount >= 2500
          ? l10n.premiumUiBadgeUltraDeal
          : (isLargeOffer
                ? l10n.premiumUiBadgeTopDeal
                : l10n.premiumUiBadgeCredits),
      actionLabel: bundleCta,
      infoTitle: resolvedTitle,
      infoBody: l10n.premiumUiCreditOfferInfo(
        bundleCta,
        bundlePrice,
        resolvedDescription,
      ),
      onPressed: _processingCheckout
          ? null
          : () => _startCheckout(
              'one_time',
              productKey: (product['key'] ?? '').toString(),
            ),
    );
  }

  Widget _buildCreditShop(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          title: l10n.premiumUiSectionShopTitle,
          subtitle: l10n.premiumUiSectionShopSubtitle,
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
            final useNl = _useNlCatalogCopy(context);
            final title = useNl
                ? (item['titleNl'] ?? '')
                : (item['titleEn'] ?? '');
            final description = useNl
                ? (item['descriptionNl'] ?? '')
                : (item['descriptionEn'] ?? '');
            final disabled =
                _processingRedeem ||
                _creditBalance < effectiveCost ||
                !canRedeemNow;
            final effectType = (item['effectType'] ?? '').toString();
            final accent = _creditItemAccentColor(effectType);
            final resolvedTitle = title.toString().trim().isEmpty
                ? l10n.premiumUiShopItemFallbackTitle
                : title.toString();
            final resolvedDescription = description.toString().trim().isEmpty
                ? l10n.premiumUiShopItemFallbackDescription
                : description.toString();
            final themeLabel = _creditItemThemeLabel(item, l10n);
            final actionLabel =
                !canRedeemNow &&
                    unavailableReason == 'ACTION_COOLDOWN_NOT_ACTIVE'
                ? l10n.premiumUiShopNoActiveCooldown
                : (_creditBalance < effectiveCost
                      ? l10n.premiumUiShopNotEnoughCredits
                      : l10n.premiumUiShopRedeem);

            return _buildVisualTile(
              title: resolvedTitle,
              subtitle: resolvedDescription,
              imagePath: _creditItemImagePath(item),
              accent: accent,
              icon: Icons.auto_awesome,
              primaryValue: l10n.premiumUiCreditsCount(effectiveCost),
              secondaryValue: themeLabel,
              badgeLabel: l10n.premiumUiBadgeShop,
              actionLabel: actionLabel,
              infoTitle: resolvedTitle,
              infoBody: l10n.premiumUiShopItemInfo(
                resolvedDescription,
                themeLabel,
                effectiveCost,
              ),
              onPressed: disabled ? null : () => _redeemCreditItem(item),
            );
          }).toList(),
        ),
        if (_entitlements.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            l10n.premiumUiActiveEffectsTitle,
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
                  expiresAt == null
                      ? key
                      : l10n.premiumUiEntitlementChip(
                          key,
                          _formatDate(expiresAt),
                        ),
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildBody() {
    final l10n = AppLocalizations.of(context)!;

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
              child: Text(l10n.retry),
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
            l10n.premiumAndCredits,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.premiumUiIntroSubtitle,
          ),
          const SizedBox(height: 16),
          _buildStatusStrip(l10n),
          const SizedBox(height: 24),
          _buildVipPlans(l10n),
          const SizedBox(height: 24),
          _buildCreditPurchases(l10n),
          const SizedBox(height: 24),
          _buildCreditShop(l10n),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.embedded) {
      return _buildBody();
    }

    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.premiumAndCredits),
      ),
      body: _buildBody(),
    );
  }
}
