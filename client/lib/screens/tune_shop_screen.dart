import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/vehicle_provider.dart';
import '../utils/top_right_notification.dart';

class TuneShopScreen extends StatefulWidget {
  final bool embedded;

  const TuneShopScreen({super.key, this.embedded = false});

  @override
  State<TuneShopScreen> createState() => _TuneShopScreenState();
}

class _TuneShopScreenState extends State<TuneShopScreen> {
  bool _loading = false;
  Timer? _ticker;
  DateTime _cooldownSnapshotAt = DateTime.now();
  bool _cooldownRefreshInProgress = false;

  bool get _isNl => Localizations.localeOf(context).languageCode == 'nl';
  String _tr(String nl, String en) => _isNl ? nl : en;

  @override
  void initState() {
    super.initState();
    _startTicker();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _load();
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {});
      _maybeRefreshExpiredCooldowns();
    });
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    await context.read<VehicleProvider>().fetchTuningOverview();
    if (mounted) {
      setState(() {
        _loading = false;
        _cooldownSnapshotAt = DateTime.now();
      });
    }
  }

  Future<void> _upgrade(int inventoryId, String stat) async {
    final provider = context.read<VehicleProvider>();
    final ok = await provider.upgradeVehicleTuning(inventoryId, stat);
    if (!mounted) return;

    setState(() {
      _cooldownSnapshotAt = DateTime.now();
    });

    if (ok) {
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(_tr('Upgrade voltooid', 'Upgrade completed')),
          backgroundColor: Colors.green.shade700,
          duration: const Duration(seconds: 3),
        ),
      );
    } else {
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(
            provider.error ?? _tr('Upgrade mislukt', 'Upgrade failed'),
          ),
          backgroundColor: Colors.red.shade700,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  Color _typeColor(String type) {
    switch (type) {
      case 'boat':
        return const Color(0xFF26A69A);
      case 'motorcycle':
        return const Color(0xFFFFB74D);
      default:
        return const Color(0xFF64B5F6);
    }
  }

  String _typeLabel(String type) {
    switch (type) {
      case 'boat':
        return _tr('Boot', 'Boat');
      case 'motorcycle':
        return _tr('Motor', 'Motorcycle');
      default:
        return _tr('Auto', 'Car');
    }
  }

  String _statLabel(String stat) {
    switch (stat) {
      case 'stealth':
        return _tr('Stealth', 'Stealth');
      case 'armor':
        return _tr('Pantser', 'Armor');
      default:
        return _tr('Snelheid', 'Speed');
    }
  }

  IconData _statIcon(String stat) {
    switch (stat) {
      case 'stealth':
        return Icons.visibility_off;
      case 'armor':
        return Icons.shield;
      default:
        return Icons.speed;
    }
  }

  int _cooldownRemainingNow(Map<String, dynamic> vehicle) {
    final raw = (vehicle['tuneCooldownRemainingSeconds'] as num?)?.toInt() ?? 0;
    if (raw <= 0) return 0;
    final elapsed = DateTime.now().difference(_cooldownSnapshotAt).inSeconds;
    final remaining = raw - elapsed;
    return remaining > 0 ? remaining : 0;
  }

  bool _isVehicleLocked(Map<String, dynamic> vehicle) {
    final locked = vehicle['locked'] == true;
    if (!locked) return false;

    final lockReason = (vehicle['lockReason'] ?? '').toString();
    if (lockReason != 'TUNE_COOLDOWN_ACTIVE') {
      return true;
    }

    return _cooldownRemainingNow(vehicle) > 0;
  }

  Future<void> _maybeRefreshExpiredCooldowns() async {
    if (!mounted || _cooldownRefreshInProgress || _loading) return;

    final provider = context.read<VehicleProvider>();
    final hasExpiredCooldown = provider.tuningVehicles.any((v) {
      if ((v['lockReason'] ?? '').toString() != 'TUNE_COOLDOWN_ACTIVE') {
        return false;
      }
      return _cooldownRemainingNow(v) <= 0;
    });

    if (!hasExpiredCooldown) return;

    _cooldownRefreshInProgress = true;
    try {
      await provider.fetchTuningOverview();
      if (mounted) {
        setState(() {
          _cooldownSnapshotAt = DateTime.now();
        });
      }
    } finally {
      _cooldownRefreshInProgress = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<VehicleProvider>();
    final content = _buildContent(provider);

    if (widget.embedded) {
      return content;
    }

    return Scaffold(
      appBar: AppBar(title: Text(_tr('TuneShop', 'Tune Shop'))),
      body: content,
    );
  }

  Widget _buildContent(VehicleProvider provider) {
    return LayoutBuilder(
      builder: (context, outerConstraints) {
        final screenWidth = outerConstraints.maxWidth;
        final bgAsset = screenWidth < 700
            ? 'assets/images/tuneshop/tuneshop_bg_mobile.jpg'
            : screenWidth < 1100
            ? 'assets/images/tuneshop/tuneshop_bg_tablet.jpg'
            : 'assets/images/tuneshop/tuneshop_bg_desktop.jpg';
        return _buildWithBackground(bgAsset, provider);
      },
    );
  }

  Widget _buildWithBackground(String bgAsset, VehicleProvider provider) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(bgAsset),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.72),
            BlendMode.darken,
          ),
        ),
      ),
      child: SafeArea(
        child: RefreshIndicator(
          onRefresh: _load,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 1000;
              final horizontalPadding = constraints.maxWidth < 700
                  ? 12.0
                  : 20.0;

              if (_loading) {
                return const Center(child: CircularProgressIndicator());
              }

              return ListView(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  16,
                  horizontalPadding,
                  20,
                ),
                children: [
                  _buildHeaderCard(),
                  const SizedBox(height: 12),
                  _buildPartsSummary(provider),
                  const SizedBox(height: 16),
                  if (provider.tuningVehicles.isEmpty)
                    _buildEmptyState()
                  else if (isWide)
                    _buildGridVehicles(provider)
                  else
                    _buildListVehicles(provider),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.35),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.withOpacity(0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  'assets/images/tuneshop/tuneshop_emblem.png',
                  width: 48,
                  height: 48,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) =>
                      const SizedBox(width: 48, height: 48),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                _tr('TuneShop', 'Tune Shop'),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            _tr(
              'Sloop voertuigen voor onderdelen en upgrade snelheid, stealth en pantser. Onderdelen zijn per categorie gedeeld (auto/motor/boot), dus je kunt elk voertuig binnen dezelfde categorie tunen.',
              'Scrap vehicles for parts and upgrade speed, stealth and armor. Parts are shared per category (car/motorcycle/boat), so you can tune any vehicle within the same category.',
            ),
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 13,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPartsSummary(VehicleProvider provider) {
    final parts = provider.tuningParts;

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _partsChip(
          _tr('Auto onderdelen', 'Car parts'),
          parts['car'] ?? 0,
          const Color(0xFF64B5F6),
          Icons.directions_car,
        ),
        _partsChip(
          _tr('Motor onderdelen', 'Motorcycle parts'),
          parts['motorcycle'] ?? 0,
          const Color(0xFFFFB74D),
          Icons.two_wheeler,
        ),
        _partsChip(
          _tr('Boot onderdelen', 'Boat parts'),
          parts['boat'] ?? 0,
          const Color(0xFF26A69A),
          Icons.directions_boat,
        ),
      ],
    );
  }

  Widget _partsChip(String label, int value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.35),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.7)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Text(
            '$label: $value',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.35),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            Icons.build_circle_outlined,
            size: 42,
            color: Colors.white.withOpacity(0.7),
          ),
          const SizedBox(height: 10),
          Text(
            _tr(
              'Geen voertuigen om te tunen',
              'No vehicles available for tuning',
            ),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _tr(
              'Steel eerst een voertuig en sloop er een paar voor onderdelen.',
              'Steal some vehicles first and scrap a few for parts.',
            ),
            style: TextStyle(color: Colors.white.withOpacity(0.8)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildGridVehicles(VehicleProvider provider) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: provider.tuningVehicles.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.45,
      ),
      itemBuilder: (context, index) {
        return _vehicleCard(provider.tuningVehicles[index]);
      },
    );
  }

  Widget _buildListVehicles(VehicleProvider provider) {
    return Column(children: provider.tuningVehicles.map(_vehicleCard).toList());
  }

  Widget _vehicleCard(Map<String, dynamic> vehicle) {
    final vehicleType = (vehicle['vehicleType'] ?? 'car').toString();
    final levels =
        (vehicle['tuningLevels'] as Map<String, dynamic>? ?? const {});
    final costs =
        (vehicle['upgradeCosts'] as Map<String, dynamic>? ?? const {});
    final tunedMultiplier =
        ((vehicle['tunedValueMultiplier'] as num?)?.toDouble() ?? 1.0);
    final locked = _isVehicleLocked(vehicle);
    final lockReason = (vehicle['lockReason'] ?? '').toString();
    final cooldownRemaining = _cooldownRemainingNow(vehicle);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.38),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _typeColor(vehicleType).withOpacity(0.65)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 68,
                  height: 44,
                  child: Image.asset(
                    'assets/images/vehicles/${vehicle['image'] ?? ''}',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.black54,
                      child: const Icon(
                        Icons.image_not_supported,
                        color: Colors.white54,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (vehicle['name'] ?? '-').toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: _typeColor(vehicleType).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: _typeColor(vehicleType).withOpacity(0.8),
                            ),
                          ),
                          child: Text(
                            _typeLabel(vehicleType),
                            style: TextStyle(
                              color: _typeColor(vehicleType),
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${_tr('Waarde x', 'Value x')}${tunedMultiplier.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: Colors.amber.shade200,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _upgradeRow(vehicle, 'speed', levels, costs),
          const SizedBox(height: 8),
          _upgradeRow(vehicle, 'stealth', levels, costs),
          const SizedBox(height: 8),
          _upgradeRow(vehicle, 'armor', levels, costs),
          if (locked) ...[
            const SizedBox(height: 8),
            Text(
              lockReason == 'VEHICLE_IN_TRANSIT'
                  ? _tr(
                      'Tuning geblokkeerd: voertuig is onderweg.',
                      'Tuning locked: vehicle is in transit.',
                    )
                  : lockReason == 'TUNE_COOLDOWN_ACTIVE'
                  ? _tr(
                      'Tuning cooldown actief: nog ${_formatCooldown(cooldownRemaining)}.',
                      'Tuning cooldown active: ${_formatCooldown(cooldownRemaining)} remaining.',
                    )
                  : _tr(
                      'Tuning geblokkeerd: voertuig is in reparatie.',
                      'Tuning locked: vehicle is in repair.',
                    ),
              style: const TextStyle(
                color: Colors.orangeAccent,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _upgradeRow(
    Map<String, dynamic> vehicle,
    String stat,
    Map<String, dynamic> levels,
    Map<String, dynamic> costs,
  ) {
    final inventoryId = (vehicle['inventoryId'] as num?)?.toInt() ?? 0;
    final statLevel = (levels[stat] as num?)?.toInt() ?? 0;
    final statCost = (costs[stat] as Map<String, dynamic>? ?? const {});
    final locked = _isVehicleLocked(vehicle);
    final maxed = statCost['maxed'] == true;
    final partsCost = (statCost['partsCost'] as num?)?.toInt() ?? 0;
    final moneyCost = (statCost['moneyCost'] as num?)?.toInt() ?? 0;

    return Row(
      children: [
        Icon(_statIcon(stat), color: Colors.white70, size: 16),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            '${_statLabel(stat)} Lv.$statLevel',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        if (maxed)
          Text(
            _tr('MAX', 'MAX'),
            style: const TextStyle(
              color: Colors.greenAccent,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          )
        else ...[
          Text(
            '$partsCost ${_tr('ond', 'pts')} • €$moneyCost',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 11,
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            height: 28,
            child: ElevatedButton(
              onPressed: locked ? null : () => _upgrade(inventoryId, stat),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                backgroundColor: Colors.orange.shade700,
                foregroundColor: Colors.white,
              ),
              child: Text(
                _tr('Upgrade', 'Upgrade'),
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  String _formatCooldown(dynamic secondsValue) {
    final seconds = (secondsValue as num?)?.toInt() ?? 0;
    final safe = seconds < 0 ? 0 : seconds;
    final minutes = safe ~/ 60;
    final secs = safe % 60;
    if (minutes > 0) {
      return '${minutes}m ${secs}s';
    }
    return '${secs}s';
  }
}
