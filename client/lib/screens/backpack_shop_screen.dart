import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/backpack_service.dart';
import '../services/api_client.dart';
import '../models/backpack.dart';
import '../utils/formatters.dart';
import '../utils/top_right_notification.dart';
import '../widgets/responsive_modal.dart';
import '../l10n/app_localizations.dart';

class BackpackShopScreen extends StatefulWidget {
  final bool isTab;

  const BackpackShopScreen({super.key, this.isTab = true});

  @override
  State<BackpackShopScreen> createState() => _BackpackShopScreenState();
}

class _BackpackShopScreenState extends State<BackpackShopScreen> {
  late BackpackService _backpackService;
  bool _isLoading = true;
  AvailableBackpacksResponse? _backpacks;
  bool _loadFailed = false;

  static int _asInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is double) return v.floor();
    return int.tryParse(v.toString()) ?? 0;
  }

  @override
  void initState() {
    super.initState();
    print('[BackpackShopScreen] initState called');
    print('[BackpackShopScreen] Auth provider obtained');
    _backpackService = BackpackService(ApiClient());
    print('[BackpackShopScreen] BackpackService initialized');
    _loadBackpacks();
  }

  Future<void> _loadBackpacks() async {
    print('[BackpackShopScreen] _loadBackpacks called');
    setState(() {
      _isLoading = true;
      _loadFailed = false;
    });

    try {
      print('[BackpackShopScreen] Calling getAvailableBackpacks()');
      final backpacks = await _backpackService.getAvailableBackpacks();
      print(
        '[BackpackShopScreen] Got backpacks: owned=${backpacks.owned != null ? "yes" : "no"}, available=${backpacks.available.length}, canUpgrade=${backpacks.canUpgradeTo.length}',
      );
      setState(() {
        _backpacks = backpacks;
        _isLoading = false;
      });
    } catch (e) {
      print('[BackpackShopScreen] ERROR loading backpacks: $e');
      setState(() {
        _loadFailed = true;
        _isLoading = false;
      });
    }
  }

  String _getEventMessage(
    AppLocalizations l10n,
    String eventKey,
    Map<String, dynamic> params,
  ) {
    switch (eventKey) {
      case 'backpack.purchased':
        return l10n.backpackPurchasedEvent(
          '${params['name'] ?? ''}',
          _asInt(params['slots']),
        );

      case 'backpack.purchase_failed':
        final reason = params['reason']?.toString();
        switch (reason) {
          case 'not_found':
            return l10n.backpackPurchaseFailedNotFound;
          case 'already_has':
            return l10n.backpackPurchaseFailedAlready;
          case 'insufficient_rank':
            return l10n.backpackPurchaseFailedRank(
              _asInt(params['current']),
              _asInt(params['required']),
            );
          case 'insufficient_funds':
            return l10n.backpackPurchaseFailedFunds(
              _asInt(params['have']),
              _asInt(params['needed']),
            );
          case 'vip_only':
            return l10n.backpackPurchaseFailedVip;
          case 'player_not_found':
            return l10n.playerNotFound;
          default:
            return l10n.backpackPurchaseFailedGeneric;
        }

      case 'backpack.upgraded':
        return l10n.backpackUpgradedEvent(
          '${params['newName'] ?? ''}',
          _asInt(params['upgradeSlots']),
        );

      case 'backpack.upgrade_failed':
        final reason = params['reason']?.toString();
        switch (reason) {
          case 'not_found':
            return l10n.backpackPurchaseFailedNotFound;
          case 'no_backpack':
            return l10n.backpackUpgradeFailedNo;
          case 'not_an_upgrade':
            return l10n.backpackUpgradeFailedNotUpgrade;
          case 'insufficient_rank':
            return l10n.backpackUpgradeFailedRank(
              _asInt(params['current']),
              _asInt(params['required']),
            );
          case 'insufficient_funds':
            return l10n.backpackUpgradeFailedFunds(
              _asInt(params['have']),
              _asInt(params['needed']),
            );
          case 'vip_only':
            return l10n.backpackUpgradeFailedVip;
          case 'player_not_found':
            return l10n.playerNotFound;
          default:
            return l10n.backpackUpgradeFailedGeneric;
        }

      default:
        return l10n.backpackUnknownEvent;
    }
  }

  Future<void> _purchaseBackpack(Backpack backpack) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final l10n = AppLocalizations.of(context)!;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.confirmAction),
        content: ResponsiveDialogContent(
          phoneMaxWidth: 340,
          tabletMaxWidth: 420,
          desktopMaxWidth: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                backpack.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(backpack.description),
              const SizedBox(height: 16),
              Text('${l10n.price}: ${formatCurrency(backpack.price)}'),
              Text('${l10n.extraSlots}: +${backpack.slots}'),
              Text(
                l10n.backpackDialogTotalCapacity(5 + backpack.slots),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: Text(l10n.buyBackpack),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final result = await _backpackService.purchaseBackpack(backpack.id);

      if (!mounted) return;

      final l10nMsg = AppLocalizations.of(context)!;
      final rawParams = result['params'];
      final params = rawParams is Map
          ? Map<String, dynamic>.from(rawParams)
          : <String, dynamic>{};
      final message = _getEventMessage(
        l10nMsg,
        result['event']?.toString() ?? '',
        params,
      );

      if (result['success'] == true) {
        showTopRightFromSnackBar(
          context,
          SnackBar(content: Text(message), backgroundColor: Colors.green),
        );
        await authProvider.refreshPlayer();
        _loadBackpacks();
      } else {
        showTopRightFromSnackBar(
          context,
          SnackBar(content: Text(message), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (!mounted) return;
      final errL10n = AppLocalizations.of(context)!;
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(errL10n.hitError(e.toString())),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _upgradeBackpack(Backpack backpack) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final l10n = AppLocalizations.of(context)!;

    final owned = _backpacks?.owned;
    if (owned == null) return;

    final tradeInValue = (owned.price * 0.5).floor();
    final upgradeCost = backpack.price - tradeInValue;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.confirmAction),
        content: ResponsiveDialogContent(
          phoneMaxWidth: 340,
          tabletMaxWidth: 420,
          desktopMaxWidth: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                backpack.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.backpackDialogCurrentLine(owned.name, owned.slots),
              ),
              Text(
                l10n.backpackDialogNewLine(backpack.name, backpack.slots),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.backpackDialogUpgradeDelta(
                  backpack.slots - owned.slots,
                ),
              ),
              const Divider(),
              Text('${l10n.price}: ${formatCurrency(backpack.price)}'),
              Text(
                '${l10n.tradeInValue}: ${formatCurrency(tradeInValue)}',
              ),
              Text(
                '${l10n.upgradeCost}: ${formatCurrency(upgradeCost)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: Text(l10n.upgradeBackpack),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final result = await _backpackService.upgradeBackpack(backpack.id);

      if (!mounted) return;

      final l10nMsg = AppLocalizations.of(context)!;
      final rawParams = result['params'];
      final params = rawParams is Map
          ? Map<String, dynamic>.from(rawParams)
          : <String, dynamic>{};
      final message = _getEventMessage(
        l10nMsg,
        result['event']?.toString() ?? '',
        params,
      );

      if (result['success'] == true) {
        showTopRightFromSnackBar(
          context,
          SnackBar(content: Text(message), backgroundColor: Colors.green),
        );
        await authProvider.refreshPlayer();
        _loadBackpacks();
      } else {
        showTopRightFromSnackBar(
          context,
          SnackBar(content: Text(message), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (!mounted) return;
      final errL10n = AppLocalizations.of(context)!;
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(errL10n.hitError(e.toString())),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildBackpackCard(
    Backpack backpack, {
    bool isOwned = false,
    bool canUpgrade = false,
  }) {
    final l10n = AppLocalizations.of(context)!;
    final authProvider = Provider.of<AuthProvider>(context);
    final player = authProvider.currentPlayer;

    final canAfford = player != null && player.money >= backpack.price;
    final meetsRank = player != null && player.rank >= backpack.requiredRank;
    final isVip = false; // VIP not implemented yet
    final canPurchase = canAfford && meetsRank && (!backpack.vipOnly || isVip);

    return Card(
      color: isOwned ? Colors.green.shade900.withOpacity(0.3) : null,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(backpack.icon, style: const TextStyle(fontSize: 32)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            backpack.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (backpack.vipOnly)
                            const Padding(
                              padding: EdgeInsets.only(left: 8),
                              child: Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 20,
                              ),
                            ),
                          if (isOwned)
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Chip(
                                label: Text(
                                  l10n.backpackOwnedBadge,
                                  style: const TextStyle(fontSize: 12),
                                ),
                                backgroundColor: Colors.green,
                                padding: EdgeInsets.zero,
                              ),
                            ),
                        ],
                      ),
                      Text(
                        backpack.type,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(backpack.description),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.inventory_2, size: 16),
                const SizedBox(width: 4),
                Text('+${backpack.slots} ${l10n.slots}'),
                const Spacer(),
                Text(
                  formatCurrency(backpack.price),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(l10n.rankRequired(backpack.requiredRank)),
                if (!meetsRank)
                  const Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Icon(Icons.lock, size: 16, color: Colors.red),
                  ),
              ],
            ),
            if (!isOwned) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: canPurchase
                      ? () => canUpgrade
                            ? _upgradeBackpack(backpack)
                            : _purchaseBackpack(backpack)
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: canUpgrade ? Colors.blue : Colors.green,
                  ),
                  child: Text(
                    canUpgrade ? l10n.upgradeBackpack : l10n.buyBackpack,
                  ),
                ),
              ),
              if (!canAfford)
                Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    l10n.tuneShopErrorInsufficientFunds,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildContent(context);
  }

  Widget _buildContent(BuildContext context, {bool isStandalone = false}) {
    final l10n = AppLocalizations.of(context)!;
    final body = _isLoading
        ? const Center(child: CircularProgressIndicator())
        : _loadFailed
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(l10n.backpackLoadFailedGeneric),
                ElevatedButton(
                  onPressed: _loadBackpacks,
                  child: Text(l10n.retryAgain),
                ),
              ],
            ),
          )
        : RefreshIndicator(
            onRefresh: _loadBackpacks,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (_backpacks?.owned != null) ...[
                  Text(
                    l10n.yourBackpack,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _buildBackpackCard(_backpacks!.owned!, isOwned: true),
                  const SizedBox(height: 24),
                ],
                if (_backpacks?.canUpgradeTo.isNotEmpty ?? false) ...[
                  Text(
                    l10n.availableUpgrades,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ...(_backpacks!.canUpgradeTo.map(
                    (bp) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildBackpackCard(bp, canUpgrade: true),
                    ),
                  )),
                  const SizedBox(height: 24),
                ],
                if (_backpacks?.available.isNotEmpty ?? false) ...[
                  Text(
                    _backpacks?.owned == null
                        ? l10n.availableBackpacks
                        : l10n.otherBackpacks,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...(_backpacks!.available.map(
                    (bp) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildBackpackCard(bp),
                    ),
                  )),
                ],
                if ((_backpacks?.available.isEmpty == true ||
                        _backpacks?.available == null) &&
                    (_backpacks?.canUpgradeTo.isEmpty == true ||
                        _backpacks?.canUpgradeTo == null) &&
                    _backpacks?.owned != null) ...[
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.check_circle,
                            size: 64,
                            color: Colors.green,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            l10n.youHaveBestBackpack,
                            style: const TextStyle(fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );

    if (isStandalone) {
      return Scaffold(
        appBar: AppBar(
          title: Text('🎒 ${l10n.backpackShop}'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _loadBackpacks,
            ),
          ],
        ),
        body: body,
      );
    }

    return body;
  }
}
