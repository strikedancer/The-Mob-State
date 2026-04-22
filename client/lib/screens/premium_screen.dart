import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/app_localizations.dart';
import '../services/auth_service.dart';
import '../utils/top_right_notification.dart';

class PremiumScreen extends StatefulWidget {
  const PremiumScreen({super.key, this.embedded = false});

  final bool embedded;

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
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
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
      ),
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
    WidgetsBinding.instance.addPostFrameCallback((_) => _showRedirectFeedback());
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

      if (statusResponse.statusCode != 200 || productResponse.statusCode != 200 || creditResponse.statusCode != 200) {
        throw Exception('premium_load_failed');
      }

      final statusData = jsonDecode(statusResponse.body) as Map<String, dynamic>;
      final productData = jsonDecode(productResponse.body) as Map<String, dynamic>;
      final creditData = jsonDecode(creditResponse.body) as Map<String, dynamic>;

      setState(() {
        _status = statusData;
        _products = (productData['products'] as List<dynamic>? ?? const [])
            .whereType<Map<String, dynamic>>()
            .toList();
        _creditItems = (creditData['items'] as List<dynamic>? ?? const [])
            .whereType<Map<String, dynamic>>()
            .toList();
        _entitlements = (creditData['entitlements'] as List<dynamic>? ?? const [])
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
        message = _tr('Aankoop mislukt of verlopen.', 'Purchase failed or expired.');
      } else {
        message = _tr('Betaling mislukt of verlopen.', 'Payment failed or expired.');
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
        _tr('Openen van de betaalpagina mislukt.', 'Failed to open the payment page.'),
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
    if (effectType == 'VEHICLE_REPAIR_FINISH' || effectType == 'VEHICLE_TUNE_RESET') {
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
        if ((item['actionType'] ?? '').toString().isNotEmpty) 'actionType': item['actionType'],
      });

      final payload = response.body.isNotEmpty ? jsonDecode(response.body) as Map<String, dynamic> : <String, dynamic>{};
      if (response.statusCode != 200) {
        throw Exception((payload['error'] ?? 'redeem_failed').toString());
      }

      if (!mounted) return;
      _showTopRightMessage(
        (payload['message'] ?? _tr('Credits ingewisseld.', 'Credits redeemed.')).toString(),
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
    return '€$value/${_tr('mnd', 'mo')}';
  }

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
      .where((product) => ((product['reward'] as Map?)?['type'] ?? '').toString() == 'credits')
      .toList();

  Widget _buildStatusStrip() {
    final playerVip = (_status?['playerVip'] as Map?)?.cast<String, dynamic>() ?? const {};
    final crewVip = (_status?['crewVip'] as Map?)?.cast<String, dynamic>();

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _buildKpiCard(_tr('Speler VIP', 'Player VIP'), playerVip['isVip'] == true ? _tr('Actief', 'Active') : _tr('Inactief', 'Inactive'), Icons.workspace_premium),
        _buildKpiCard(_tr('Crew VIP', 'Crew VIP'), crewVip == null ? _tr('Geen crew', 'No crew') : (crewVip['isVip'] == true ? _tr('Actief', 'Active') : _tr('Inactief', 'Inactive')), Icons.groups),
        _buildKpiCard(_tr('Credits', 'Credits'), _creditBalance.toString(), Icons.token),
      ],
    );
  }

  Widget _buildKpiCard(String label, String value, IconData icon) {
    return Container(
      constraints: const BoxConstraints(minWidth: 180, maxWidth: 260),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: Theme.of(context).textTheme.labelMedium),
                const SizedBox(height: 4),
                Text(value, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVipPlans() {
    final playerVip = (_status?['playerVip'] as Map?)?.cast<String, dynamic>() ?? const {};
    final crewVip = (_status?['crewVip'] as Map?)?.cast<String, dynamic>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(_tr('VIP abonnementen', 'VIP subscriptions'), style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _buildPlanCard(
              title: _tr('Speler VIP', 'Player VIP'),
              subtitle: _tr('Exclusieve voordelen en avatar unlocks voor jouw account.', 'Exclusive perks and avatar unlocks for your account.'),
              price: _priceLabel(playerVip['monthlyPriceEur']),
              activeUntil: playerVip['expiresAt'] == null ? null : _formatDate(playerVip['expiresAt']),
              actionLabel: playerVip['isVip'] == true ? _tr('Verlengen', 'Extend') : _tr('Abonneren', 'Subscribe'),
              color: Colors.amber,
              icon: Icons.person,
              onPressed: _processingCheckout ? null : () => _startCheckout('player_vip'),
            ),
            _buildPlanCard(
              title: _tr('Crew VIP', 'Crew VIP'),
              subtitle: crewVip == null
                  ? _tr('Je moet eerst in een crew zitten om Crew VIP te activeren.', 'You must be in a crew before you can activate Crew VIP.')
                  : _tr('Voor crew-upgrades, side buildings level 11-15 en gedeelde perks.', 'For crew upgrades, side buildings level 11-15 and shared perks.'),
              price: _priceLabel(crewVip?['monthlyPriceEur']),
              activeUntil: crewVip?['expiresAt'] == null ? null : _formatDate(crewVip?['expiresAt']),
              actionLabel: crewVip == null ? _tr('Crew vereist', 'Crew required') : (crewVip['isVip'] == true ? _tr('Verlengen', 'Extend') : _tr('Activeren', 'Activate')),
              color: Colors.purple,
              icon: Icons.groups,
              onPressed: crewVip == null || _processingCheckout ? null : () => _startCheckout('crew_vip'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPlanCard({
    required String title,
    required String subtitle,
    required String price,
    required String actionLabel,
    required Color color,
    required IconData icon,
    required VoidCallback? onPressed,
    String? activeUntil,
  }) {
    return Container(
      constraints: const BoxConstraints(minWidth: 280, maxWidth: 420),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [color.withOpacity(0.18), Theme.of(context).colorScheme.surface],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: color.withOpacity(0.45)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(backgroundColor: color.withOpacity(0.18), child: Icon(icon, color: color)),
              const SizedBox(width: 12),
              Expanded(child: Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold))),
              Text(price, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: color)),
            ],
          ),
          const SizedBox(height: 12),
          Text(subtitle),
          const SizedBox(height: 12),
          if (activeUntil != null) ...[
            Text(_tr('Actief tot: $activeUntil', 'Active until: $activeUntil'), style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 12),
          ],
          FilledButton(onPressed: onPressed, style: FilledButton.styleFrom(backgroundColor: color), child: Text(actionLabel)),
        ],
      ),
    );
  }

  Widget _buildCreditPurchases() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(_tr('Credits kopen', 'Buy credits'), style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(_tr('Koop creditbundels met echte betaling. De prijs en hoeveelheid zijn admin-beheerbaar.', 'Buy credit bundles with real payments. Price and amount stay admin-controlled.')),
        const SizedBox(height: 12),
        if (_creditPurchaseOffers.isEmpty)
          Text(_tr('Er zijn nu geen creditbundels actief.', 'There are no active credit bundles right now.'))
        else
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _creditPurchaseOffers.map((product) => _buildCreditOfferCard(product)).toList(),
          ),
      ],
    );
  }

  Widget _buildCreditOfferCard(Map<String, dynamic> product) {
    final reward = (product['reward'] as Map?)?.cast<String, dynamic>() ?? const {};
    final amount = (reward['amount'] as num?)?.toInt() ?? 0;
    final title = _isNl ? (product['titleNl'] ?? '') : (product['titleEn'] ?? '');
    final description = _isNl ? (product['descriptionNl'] ?? '') : (product['descriptionEn'] ?? '');

    return Container(
      constraints: const BoxConstraints(minWidth: 240, maxWidth: 320),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title.toString(), style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(description.toString().isEmpty ? _tr('Direct credits voor je premium wallet.', 'Instant credits for your premium wallet.') : description.toString()),
          const SizedBox(height: 12),
          Text(_tr('$amount credits', '$amount credits'), style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text('€${product['priceEur'] ?? '0.00'}'),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: _processingCheckout ? null : () => _startCheckout('one_time', productKey: (product['key'] ?? '').toString()),
            child: Text(_tr('Koop credits', 'Buy credits')),
          ),
        ],
      ),
    );
  }

  Widget _buildCreditShop() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(_tr('Credit shop', 'Credit shop'), style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(_tr('Wissel credits in voor directe voordelen. Sommige voertuiggebonden items worden in het bijbehorende scherm afgerond.', 'Redeem credits for direct perks. Some vehicle-bound items are completed inside the matching vehicle screen.')),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _creditItems.map((item) {
            final cost = (item['creditCost'] as num?)?.toInt() ?? 0;
            final title = _isNl ? (item['titleNl'] ?? '') : (item['titleEn'] ?? '');
            final description = _isNl ? (item['descriptionNl'] ?? '') : (item['descriptionEn'] ?? '');
            final disabled = _processingRedeem || _creditBalance < cost;
            return Container(
              constraints: const BoxConstraints(minWidth: 240, maxWidth: 320),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Theme.of(context).dividerColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title.toString(), style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(description.toString()),
                  const SizedBox(height: 10),
                  Text(_tr('$cost credits', '$cost credits'), style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                  if ((item['actionType'] ?? '').toString().isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(_tr('Actie: ${item['actionType']}', 'Action: ${item['actionType']}'), style: Theme.of(context).textTheme.bodySmall),
                    ),
                  const SizedBox(height: 12),
                  FilledButton.tonal(
                    onPressed: disabled ? null : () => _redeemCreditItem(item),
                    child: Text(_creditBalance < cost ? _tr('Niet genoeg credits', 'Not enough credits') : _tr('Inwisselen', 'Redeem')),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
        if (_entitlements.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(_tr('Actieve premium effecten', 'Active premium effects'), style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _entitlements.map((entitlement) {
              final key = (entitlement['key'] ?? '').toString();
              final expiresAt = entitlement['expiresAt'];
              return Chip(label: Text(expiresAt == null ? key : '$key • ${_formatDate(expiresAt)}'));
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
            FilledButton(onPressed: _loadData, child: Text(_tr('Opnieuw proberen', 'Retry'))),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(_tr('Premium & Credits', 'Premium & Credits'), style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(_tr('Hier beheren spelers hun VIP abonnementen, creditbundels en credit-shop items.', 'Players manage VIP subscriptions, credit bundles and credit shop items here.')),
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
      appBar: AppBar(title: Text(_tr('Premium & Credits', 'Premium & Credits'))),
      body: _buildBody(),
    );
  }
}