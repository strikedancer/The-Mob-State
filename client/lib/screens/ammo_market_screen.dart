import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../services/api_client.dart';
import '../utils/top_right_notification.dart';

class AmmoMarketScreen extends StatefulWidget {
  const AmmoMarketScreen({super.key});

  @override
  State<AmmoMarketScreen> createState() => _AmmoMarketScreenState();
}

class _AmmoMarketScreenState extends State<AmmoMarketScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ApiClient _apiClient = ApiClient();
  List<dynamic> _marketStock = [];
  List<dynamic> _inventory = [];
  bool _isLoading = true;
  DateTime? _lastAmmoPurchaseAt;
  Timer? _cooldownTimer;

  static const ammoPurchaseCooldownMinutes = 30;

  bool get _isNl => Localizations.localeOf(context).languageCode == 'nl';
  String _tr(String nl, String en) => _isNl ? nl : en;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _cooldownTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final marketResponse = await _apiClient.get('/ammo/market');
      final inventoryResponse = await _apiClient.get('/ammo/inventory');
      final playerResponse = await _apiClient.get('/player/profile');

      final marketData = jsonDecode(marketResponse.body);
      final inventoryData = jsonDecode(inventoryResponse.body);
      final playerData = jsonDecode(playerResponse.body);

      setState(() {
        _marketStock = (marketData['stock'] as List<dynamic>? ?? []);
        _inventory = (inventoryData['ammo'] as List<dynamic>? ?? []);

        // Load last ammo purchase timestamp
        final lastAmmoPurchaseStr = playerData['player']?['lastAmmoPurchaseAt'];
        if (lastAmmoPurchaseStr != null) {
          _lastAmmoPurchaseAt = DateTime.parse(lastAmmoPurchaseStr.toString());
          _startCooldownTimer();
        }

        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _startCooldownTimer() {
    _cooldownTimer?.cancel();
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_lastAmmoPurchaseAt != null) {
        final now = DateTime.now();
        final elapsed = now.difference(_lastAmmoPurchaseAt!);
        final cooldownDuration = const Duration(
          minutes: ammoPurchaseCooldownMinutes,
        );

        if (elapsed >= cooldownDuration) {
          // Cooldown is over
          setState(() {
            _lastAmmoPurchaseAt = null;
          });
          _cooldownTimer?.cancel();
        } else {
          setState(() {}); // Update UI every second
        }
      }
    });
  }

  Future<void> _buyAmmo(String ammoType, int boxSize, int pricePerRound) async {
    final l10n = AppLocalizations.of(context);

    // Check if cooldown is active
    if (_lastAmmoPurchaseAt != null) {
      final now = DateTime.now();
      final elapsed = now.difference(_lastAmmoPurchaseAt!);
      final cooldownDuration = const Duration(
        minutes: ammoPurchaseCooldownMinutes,
      );

      if (elapsed < cooldownDuration) {
        final remaining = cooldownDuration - elapsed;
        final minutes = remaining.inMinutes;
        final seconds = remaining.inSeconds % 60;
        if (mounted) {
          showTopRightFromSnackBar(context, 
            SnackBar(
              content: Text(
                '${l10n?.purchaseCooldown ?? "You must wait before the next purchase"} ${minutes}m ${seconds}s',
              ),
              backgroundColor: Colors.orange,
            ),
          );
        }
        return;
      }
    }

    final controller = TextEditingController(text: '1');
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          final boxes = int.tryParse(controller.text) ?? 1;
          final totalRounds = boxes * boxSize;
          final totalCost = totalRounds * pricePerRound;
          final isDutch = Localizations.localeOf(context).languageCode == 'nl';

          return AlertDialog(
            title: Text(isDutch ? 'Weet je het zeker?' : 'Are you sure?'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n?.buyAmmo ?? (isDutch ? 'Munitie kopen' : 'Buy ammo'),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: l10n?.ammoBoxes ?? 'Boxes',
                    helperText:
                        l10n?.ammoRoundsPerBox(boxSize.toString()) ??
                        '$boxSize rounds per box',
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n?.ammoYouWillReceive(totalRounds.toString()) ??
                      'You will receive: $totalRounds rounds',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  l10n?.ammoTotalCost(
                        totalCost.toString().replaceAllMapped(
                          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                          (m) => '${m[1]}.',
                        ),
                      ) ??
                      'Total cost: €${totalCost.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}',
                  style: const TextStyle(color: Colors.green),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(l10n?.cancel ?? 'Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: Text(l10n?.buy ?? 'Buy'),
              ),
            ],
          );
        },
      ),
    );

    if (confirmed != true) return;

    final boxes = int.tryParse(controller.text) ?? 0;
    if (boxes < 1) {
      return;
    }

    try {
      final response = await _apiClient.post('/ammo/buy', {
        'ammoType': ammoType,
        'boxes': boxes,
      });
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        // Set cooldown on successful purchase
        setState(() {
          _lastAmmoPurchaseAt = DateTime.now();
        });
        _startCooldownTimer();

        if (mounted) {
          showTopRightFromSnackBar(context, 
            SnackBar(
              content: Text(l10n?.ammoPurchased ?? 'Ammo purchased'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3),
            ),
          );
        }
        _loadData();
      } else {
        // Handle localized error messages based on error type
        final reason = data['params']?['reason']?.toString();
        String message;

        switch (reason) {
          case 'PURCHASE_COOLDOWN_ACTIVE':
            message =
                l10n?.purchaseCooldown ??
                'You must wait before the next purchase';
            break;
          case 'INSUFFICIENT_MONEY':
            message = l10n?.notEnoughMoney ?? 'You don\'t have enough money';
            break;
          case 'INSUFFICIENT_STOCK':
            message = l10n?.insufficientStock ?? 'Not enough stock available';
            break;
          case 'MAX_INVENTORY_REACHED':
            message =
                l10n?.maxInventoryReached ??
                'Maximum inventory capacity reached';
            break;
          case 'INVALID_QUANTITY':
            message = l10n?.invalidQuantity ?? 'Invalid quantity';
            break;
          default:
            message =
                data['params']?['message']?.toString() ??
                (l10n?.hitError(data.toString()) ?? 'Error: $data');
        }

        if (mounted) {
          showTopRightFromSnackBar(context, 
            SnackBar(
              content: Text(message),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 4),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        showTopRightFromSnackBar(context, 
          SnackBar(
            content: Text(l10n?.unknownError ?? 'Er is een fout opgetreden'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  Widget _buildAmmoImage(String ammoType) {
    // Map ammo types to file names
    final fileName = ammoType.replaceAll(RegExp(r'[^a-z0-9]'), '');
    return Image.asset(
      'assets/images/ammo/$fileName.png',
      width: 48,
      height: 48,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return Icon(Icons.circle, size: 48, color: Colors.amber);
      },
    );
  }

  String _getCooldownText() {
    if (_lastAmmoPurchaseAt == null) return '';

    final now = DateTime.now();
    final elapsed = now.difference(_lastAmmoPurchaseAt!);
    final cooldownDuration = const Duration(
      minutes: ammoPurchaseCooldownMinutes,
    );

    if (elapsed >= cooldownDuration) return '';

    final remaining = cooldownDuration - elapsed;
    final minutes = remaining.inMinutes;
    final seconds = remaining.inSeconds % 60;

    return '${minutes}m ${seconds}s';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final cooldownText = _getCooldownText();
    final isCooldownActive = cooldownText.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const AssetImage('assets/images/backgrounds/ammo_factory_bg.png'),
          fit: BoxFit.cover,
          opacity: 0.15,
        ),
      ),
      child: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: l10n?.ammoShop ?? 'Market'),
              Tab(text: l10n?.myAmmo ?? 'My Ammo'),
            ],
          ),
          if (isCooldownActive)
            Container(
              padding: const EdgeInsets.all(12),
              color: Colors.orange[100],
              child: Row(
                children: [
                  Icon(Icons.timer, color: Colors.orange[900]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${l10n?.nextAmmoPurchase ?? "Next purchase available in"}: $cooldownText',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.orange[900],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _marketStock.length,
                  itemBuilder: (context, index) {
                    final ammo = _marketStock[index];
                    final quantity = ammo['quantity'] ?? 0;
                    final boxSize = ammo['boxSize'] ?? 50;
                    final pricePerRound = ammo['pricePerRound'] ?? 1;
                    final quality = ((ammo['quality'] as num?) ?? 1.0)
                        .toStringAsFixed(2);
                    return Card(
                      child: ListTile(
                        leading: _buildAmmoImage(ammo['ammoType']),
                        title: Text(ammo['name'] ?? ammo['ammoType'] ?? _tr('Munitie', 'Ammo')),
                        subtitle: Text(
                          '${l10n?.ammoStock ?? 'Stock'}: $quantity ${l10n?.ammoRounds ?? 'rounds'} • $boxSize/${l10n?.ammoBoxesUnit ?? 'box'} • €$pricePerRound/${l10n?.ammoRounds ?? 'round'}\n${l10n?.ammoQuality ?? 'Quality'}: $quality',
                        ),
                        trailing: ElevatedButton(
                          onPressed: (quantity > 0 && !isCooldownActive)
                              ? () => _buyAmmo(
                                  ammo['ammoType'],
                                  boxSize,
                                  pricePerRound,
                                )
                              : null,
                          child: Text(l10n?.buy ?? 'Buy'),
                        ),
                      ),
                    );
                  },
                ),
                ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _inventory.length,
                  itemBuilder: (context, index) {
                    final ammo = _inventory[index];
                    final quantity = ammo['quantity'] ?? 0;
                    final boxSize = ammo['boxSize'] ?? 50;
                    final quality = ((ammo['quality'] as num?) ?? 1.0)
                        .toStringAsFixed(2);
                    final boxes = (quantity / boxSize).floor();
                    final remaining = quantity % boxSize;
                    return Card(
                      child: ListTile(
                        leading: _buildAmmoImage(ammo['ammoType']),
                        title: Text(ammo['name'] ?? ammo['ammoType'] ?? _tr('Munitie', 'Ammo')),
                        subtitle: Text(
                          '$quantity ${l10n?.ammoRounds ?? 'rounds'} ($boxes ${l10n?.ammoBoxesUnit ?? 'boxes'}${remaining > 0 ? ' + $remaining' : ''}) • ${l10n?.ammoQuality ?? 'Quality'}: $quality',
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
