import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../services/api_client.dart';
import '../utils/top_right_notification.dart';
import '../widgets/market_compact.dart';
import '../widgets/mobile_load_error.dart';
class AmmoMarketScreen extends StatefulWidget {
  const AmmoMarketScreen({super.key});

  @override
  State<AmmoMarketScreen> createState() => _AmmoMarketScreenState();
}

class _AmmoMarketScreenState extends State<AmmoMarketScreen> {
  final ApiClient _apiClient = ApiClient();
  List<dynamic> _marketStock = [];
  List<dynamic> _inventory = [];
  bool _isLoading = true;
  String? _loadError;
  DateTime? _lastAmmoPurchaseAt;
  Timer? _cooldownTimer;

  static const ammoPurchaseCooldownMinutes = 30;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
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
        _loadError = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _loadError = AppLocalizations.of(context)!.connectionErrorGeneric;
      });
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

          return AlertDialog(
            title: Text(l10n?.confirmAction ?? 'Are you sure?'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n?.buyAmmo ?? 'Buy Ammo',
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
      width: 44,
      height: 44,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return const Icon(Icons.circle, size: 44, color: Colors.amber);
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
    if (_loadError != null && _marketStock.isEmpty && _inventory.isEmpty) {
      return MobileLoadError(message: _loadError!, onRetry: _loadData);
    }

    final cooldownText = _getCooldownText();
    final isCooldownActive = cooldownText.isNotEmpty;

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/backgrounds/ammo_factory_bg.png'),
          fit: BoxFit.cover,
          opacity: 0.15,
        ),
      ),
      child: RefreshIndicator(
        onRefresh: _loadData,
        child: ListView(
          padding: marketListPadding,
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            if (isCooldownActive)
              Card(
                color: Colors.orange.shade50,
                margin: const EdgeInsets.only(bottom: 8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: Row(
                    children: [
                      Icon(Icons.timer, size: 18, color: Colors.orange[900]),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${l10n?.nextAmmoPurchase ?? "Next purchase available in"}: $cooldownText',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange[900],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            for (final ammo in _marketStock)
              _buildShopAmmoRow(ammo, l10n, isCooldownActive),
            marketSectionHeader(
              context,
              label: l10n?.inventory ?? 'Inventory',
            ),
            if (_inventory.isEmpty)
              marketEmptyHint(l10n?.noItemsInInventory ?? 'No items')
            else
              for (final ammo in _inventory) _buildOwnedAmmoRow(ammo, l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildShopAmmoRow(
    dynamic ammo,
    AppLocalizations? l10n,
    bool isCooldownActive,
  ) {
    final quantity = ammo['quantity'] ?? 0;
    final boxSize = ammo['boxSize'] ?? 50;
    final pricePerRound = ammo['pricePerRound'] ?? 1;
    final quality = ((ammo['quality'] as num?) ?? 1.0).toStringAsFixed(2);
    final name = ammo['name'] ?? ammo['ammoType'] ?? (l10n?.ammoGeneric ?? 'Ammo');
    final stockLabel =
        '${l10n?.ammoStock ?? 'Stock'}: $quantity ${l10n?.ammoRounds ?? 'rounds'}';
    return MarketCompactRow(
      leading: _buildAmmoImage('${ammo['ammoType']}'),
      info: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$name',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 4,
            runSpacing: 3,
            children: [
              MarketInfoPill(
                label: stockLabel,
                color: quantity > 0 ? Colors.teal.shade700 : Colors.red.shade700,
                icon: Icons.inventory_2,
              ),
              MarketInfoPill(
                label: '$boxSize/${l10n?.ammoBoxesUnit ?? 'box'}',
                color: Colors.blueGrey.shade700,
              ),
              MarketInfoPill(
                label: '${l10n?.ammoQuality ?? 'Quality'} $quality',
                color: Colors.purple.shade700,
              ),
            ],
          ),
        ],
      ),
      meta: Text(
        '€$pricePerRound',
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Colors.green,
        ),
      ),
      action: FilledButton(
        onPressed: (quantity > 0 && !isCooldownActive)
            ? () => _buyAmmo(ammo['ammoType'], boxSize, pricePerRound)
            : null,
        style: marketBuyButtonStyle(),
        child: Text(l10n?.buy ?? 'Buy'),
      ),
    );
  }

  Widget _buildOwnedAmmoRow(dynamic ammo, AppLocalizations? l10n) {
    final quantity = ammo['quantity'] ?? 0;
    final boxSize = ammo['boxSize'] ?? 50;
    final quality = ((ammo['quality'] as num?) ?? 1.0).toStringAsFixed(2);
    final boxes = (quantity / boxSize).floor();
    final remaining = quantity % boxSize;
    final name = ammo['name'] ?? ammo['ammoType'] ?? (l10n?.ammoGeneric ?? 'Ammo');
    return MarketCompactRow(
      leading: _buildAmmoImage('${ammo['ammoType']}'),
      info: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$name',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 4,
            runSpacing: 3,
            children: [
              MarketInfoPill(
                label: '$quantity ${l10n?.ammoRounds ?? 'rounds'}',
                color: Colors.teal.shade700,
                icon: Icons.inventory_2,
              ),
              MarketInfoPill(
                label:
                    '$boxes ${l10n?.ammoBoxesUnit ?? 'boxes'}${remaining > 0 ? ' + $remaining' : ''}',
                color: Colors.blueGrey.shade700,
              ),
              MarketInfoPill(
                label: '${l10n?.ammoQuality ?? 'Quality'} $quality',
                color: Colors.purple.shade700,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
