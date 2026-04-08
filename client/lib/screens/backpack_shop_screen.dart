import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/backpack_service.dart';
import '../services/api_client.dart';
import '../models/backpack.dart';
import '../utils/formatters.dart';
import '../utils/top_right_notification.dart';

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
  String? _error;

  String _tr(String nl, String en) {
    return Localizations.localeOf(context).languageCode == 'nl' ? nl : en;
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
      _error = null;
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
        _error = 'Er is een fout opgetreden';
        _isLoading = false;
      });
    }
  }

  String _getEventMessage(String eventKey, Map<String, dynamic> params) {
    switch (eventKey) {
      // Purchase success
      case 'backpack.purchased':
        return _tr(
          'Je hebt ${params['name']} gekocht! +${params['slots']} slots.',
          'You bought ${params['name']}! +${params['slots']} slots.',
        );

      // Purchase failures
      case 'backpack.purchase_failed':
        final reason = params['reason'];
        switch (reason) {
          case 'not_found':
            return _tr('Rugzak niet gevonden', 'Backpack not found');
          case 'already_has':
            return _tr(
              'Je hebt al een rugzak. Je kunt maar één tegelijk gebruiken.',
              'You already have a backpack. You can only use one at a time.',
            );
          case 'insufficient_rank':
            return _tr(
              'Je hebt rank ${params['required']} nodig (je bent rank ${params['current']})',
              'You need rank ${params['required']} (you are rank ${params['current']})',
            );
          case 'insufficient_funds':
            return _tr(
              'Je hebt €${params['needed']} nodig. Je hebt €${params['have']}',
              'You need €${params['needed']}. You have €${params['have']}',
            );
          case 'vip_only':
            return _tr(
              'Deze rugzak is alleen voor VIP leden',
              'This backpack is VIP only',
            );
          case 'player_not_found':
            return _tr('Speler niet gevonden', 'Player not found');
          default:
            return _tr(
              'Fout bij kopen van rugzak',
              'Error while buying backpack',
            );
        }

      // Upgrade success
      case 'backpack.upgraded':
        return _tr(
          'Geupgrade naar ${params['newName']}! +${params['upgradeSlots']} extra slots.',
          'Upgraded to ${params['newName']}! +${params['upgradeSlots']} extra slots.',
        );

      // Upgrade failures
      case 'backpack.upgrade_failed':
        final reason = params['reason'];
        switch (reason) {
          case 'not_found':
            return _tr('Rugzak niet gevonden', 'Backpack not found');
          case 'no_backpack':
            return _tr(
              'Je hebt geen rugzak om te upgraden',
              'You have no backpack to upgrade',
            );
          case 'not_an_upgrade':
            return _tr(
              'Dit is geen upgrade. Kies een grotere rugzak.',
              'This is not an upgrade. Choose a larger backpack.',
            );
          case 'insufficient_rank':
            return _tr(
              'Je hebt rank ${params['required']} nodig (je bent rank ${params['current']})',
              'You need rank ${params['required']} (you are rank ${params['current']})',
            );
          case 'insufficient_funds':
            return _tr(
              'Je hebt €${params['needed']} nodig. Je hebt €${params['have']}',
              'You need €${params['needed']}. You have €${params['have']}',
            );
          case 'vip_only':
            return _tr(
              'Deze rugzak is alleen voor VIP leden',
              'This backpack is VIP only',
            );
          case 'player_not_found':
            return _tr('Speler niet gevonden', 'Player not found');
          default:
            return _tr(
              'Fout bij upgraden van rugzak',
              'Error while upgrading backpack',
            );
        }

      default:
        return _tr('Onbekende actie', 'Unknown action');
    }
  }

  Future<void> _purchaseBackpack(Backpack backpack) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_tr('Weet je het zeker?', 'Are you sure?')),
        content: Column(
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
            Text('${_tr('Prijs', 'Price')}: ${formatCurrency(backpack.price)}'),
            Text('${_tr('Extra slots', 'Extra slots')}: +${backpack.slots}'),
            Text('${_tr('Totaal', 'Total')}: ${5 + backpack.slots} slots'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(_tr('Annuleren', 'Cancel')),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: Text(_tr('Kopen', 'Buy')),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final result = await _backpackService.purchaseBackpack(backpack.id);

      if (!mounted) return;

      final message = _getEventMessage(
        result['event'] ?? '',
        result['params'] ?? {},
      );

      if (result['success']) {
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
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(_tr('Fout: $e', 'Error: $e')),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _upgradeBackpack(Backpack backpack) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Calculate trade-in value
    final owned = _backpacks?.owned;
    if (owned == null) return;

    final tradeInValue = (owned.price * 0.5).floor();
    final upgradeCost = backpack.price - tradeInValue;

    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_tr('Weet je het zeker?', 'Are you sure?')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              backpack.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '${_tr('Huidige', 'Current')}: ${owned.name} (+${owned.slots} slots)',
            ),
            Text(
              '${_tr('Nieuw', 'New')}: ${backpack.name} (+${backpack.slots} slots)',
            ),
            const SizedBox(height: 16),
            Text(
              '${_tr('Upgrade', 'Upgrade')}: +${backpack.slots - owned.slots} slots',
            ),
            const Divider(),
            Text('${_tr('Prijs', 'Price')}: ${formatCurrency(backpack.price)}'),
            Text(
              '${_tr('Inruilwaarde', 'Trade-in value')}: ${formatCurrency(tradeInValue)}',
            ),
            Text(
              '${_tr('Upgrade kosten', 'Upgrade cost')}: ${formatCurrency(upgradeCost)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(_tr('Annuleren', 'Cancel')),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: Text(_tr('Upgraden', 'Upgrade')),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final result = await _backpackService.upgradeBackpack(backpack.id);

      if (!mounted) return;

      final message = _getEventMessage(
        result['event'] ?? '',
        result['params'] ?? {},
      );

      if (result['success']) {
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
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(_tr('Fout: $e', 'Error: $e')),
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
                                  _tr('Eigendom', 'Owned'),
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
                Text('+${backpack.slots} ${_tr('slots', 'slots')}'),
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
                Text(
                  _tr(
                    'Rank ${backpack.requiredRank} vereist',
                    'Rank ${backpack.requiredRank} required',
                  ),
                ),
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
                    canUpgrade
                        ? _tr('Upgraden', 'Upgrade')
                        : _tr('Kopen', 'Buy'),
                  ),
                ),
              ),
              if (!canAfford)
                Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    _tr('Niet genoeg geld', 'Not enough money'),
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
    final body = _isLoading
        ? const Center(child: CircularProgressIndicator())
        : _error != null
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(_tr('Fout: $_error', 'Error: $_error')),
                ElevatedButton(
                  onPressed: _loadBackpacks,
                  child: Text(_tr('Opnieuw proberen', 'Retry')),
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
                    _tr('Je rugzak', 'Your backpack'),
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _buildBackpackCard(_backpacks!.owned!, isOwned: true),
                  const SizedBox(height: 24),
                ],
                if (_backpacks?.canUpgradeTo.isNotEmpty ?? false) ...[
                  Text(
                    _tr('Upgrades beschikbaar', 'Upgrades available'),
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
                        ? _tr('Beschikbare rugzakken', 'Available backpacks')
                        : _tr('Andere rugzakken', 'Other backpacks'),
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
                            _tr(
                              'Je hebt de beste rugzak!',
                              'You already have the best backpack!',
                            ),
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
          title: Text(_tr('🎒 Rugzak Shop', '🎒 Backpack Shop')),
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
