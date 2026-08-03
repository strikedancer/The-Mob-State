import 'package:flutter/material.dart';
import '../models/prostitute.dart';
import '../services/prostitution_service.dart';

import '../l10n/app_localizations.dart';
import '../utils/top_right_notification.dart';
import '../utils/country_helper.dart';
import '../widgets/prostitution/prostitution_section_header.dart';

class RedLightDistrictDetailScreen extends StatefulWidget {
  final int districtId;
  final bool embedded;
  final VoidCallback? onBack;

  const RedLightDistrictDetailScreen({
    super.key,
    required this.districtId,
    this.embedded = false,
    this.onBack,
  });

  @override
  State<RedLightDistrictDetailScreen> createState() =>
      _RedLightDistrictDetailScreenState();
}

class _RedLightDistrictDetailScreenState
    extends State<RedLightDistrictDetailScreen> {
  final ProstitutionService _service = ProstitutionService();
  RedLightDistrict? _district;
  List<Prostitute> _allProstitutes = [];
  Map<String, dynamic>? _upgradeInfo;
  Map<String, dynamic>? _raidStats;
  bool _isLoading = true;
  bool _isUpgrading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    try {
      final district = await _service.getDistrictById(widget.districtId);
      final prostitutesResult = await _service.getProstitutes();
      final prostitutes = prostitutesResult['success'] == true
          ? (prostitutesResult['prostitutes'] as List<Prostitute>)
          : <Prostitute>[];
      final upgradeInfo = await _service.getUpgradeInfo(widget.districtId);
      final raidStats = await _service.getRaidStats();

      setState(() {
        _district = district;
        _allProstitutes = prostitutes;
        _upgradeInfo = upgradeInfo;
        _raidStats = raidStats;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(l10n.error(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _assignProstitute(RedLightDistrict district) async {
    final l10n = AppLocalizations.of(context)!;

    final streetProstitutes =
        _allProstitutes.where((p) => p.location == 'street').toList();

    if (streetProstitutes.isEmpty) {
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(l10n.prostitutionNoStreetProstitutes),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final selectedProstitute = await showDialog<Prostitute>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        title: Text(l10n.prostitutionSelectProstitute),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: streetProstitutes.length,
            itemBuilder: (context, index) {
              final prostitute = streetProstitutes[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: kProstitutionGold.withOpacity(0.2),
                  child: const Icon(Icons.person, color: kProstitutionGold),
                ),
                title: Text(prostitute.name),
                subtitle: Text(l10n.prostitutionOnStreet),
                onTap: () => Navigator.pop(context, prostitute),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
        ],
      ),
    );

    if (selectedProstitute == null) return;

    final result = await _service.moveToRedLightInDistrict(
      selectedProstitute.id,
      district.id,
    );

    if (result['success'] == true) {
      await _loadData();

      if (mounted) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(result['message'] ?? l10n.prostitutionMoveSuccess),
            backgroundColor: Colors.green,
          ),
        );
      }
    } else {
      if (mounted) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(result['message'] ?? l10n.prostitutionMoveFailed),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _tierLabel(int tier, AppLocalizations l10n) {
    switch (tier) {
      case 2:
        return l10n.prostitutionTierLuxury;
      case 3:
        return l10n.prostitutionTierVip;
      default:
        return l10n.prostitutionTierBasic;
    }
  }

  Future<void> _confirmUpgradeTier() async {
    final l10n = AppLocalizations.of(context)!;
    final tier = _upgradeInfo?['tier'] as Map<String, dynamic>?;
    if (tier == null || tier['canUpgrade'] != true) return;

    final cost = (tier['upgradeCost'] as num?)?.toInt() ?? 0;
    final nextName = tier['nextTierName']?.toString() ??
        _tierLabel((tier['nextTier'] as num?)?.toInt() ?? 2, l10n);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        title: Text(l10n.prostitutionUpgradeTier),
        content: Text(l10n.prostitutionUpgradeTierConfirm(nextName, '$cost')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
              backgroundColor: kProstitutionGold,
              foregroundColor: Colors.black,
            ),
            child: Text(l10n.prostitutionUpgradeTier),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await _runUpgrade(isTier: true);
  }

  Future<void> _confirmUpgradeSecurity() async {
    final l10n = AppLocalizations.of(context)!;
    final security = _upgradeInfo?['security'] as Map<String, dynamic>?;
    if (security == null || security['canUpgrade'] != true) return;

    final cost = (security['upgradeCost'] as num?)?.toInt() ?? 0;
    final nextLevel = (security['nextLevel'] as num?)?.toInt() ?? 1;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        title: Text(l10n.prostitutionUpgradeSecurity),
        content: Text(
          l10n.prostitutionUpgradeSecurityConfirm('$nextLevel', '$cost'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
              backgroundColor: kProstitutionGold,
              foregroundColor: Colors.black,
            ),
            child: Text(l10n.prostitutionUpgradeSecurity),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await _runUpgrade(isTier: false);
  }

  Future<void> _runUpgrade({required bool isTier}) async {
    if (_isUpgrading || _district == null) return;
    final l10n = AppLocalizations.of(context)!;
    setState(() => _isUpgrading = true);
    try {
      final result = isTier
          ? await _service.upgradeTier(_district!.id)
          : await _service.upgradeSecurity(_district!.id);
      if (!mounted) return;
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(
            result['success'] == true
                ? (result['message']?.toString() ??
                    l10n.prostitutionUpgradeSuccess)
                : (result['message']?.toString() ??
                    l10n.prostitutionUpgradeFailed),
          ),
          backgroundColor:
              result['success'] == true ? Colors.green : Colors.red,
        ),
      );
      if (result['success'] == true) {
        await _loadData();
      }
    } finally {
      if (mounted) setState(() => _isUpgrading = false);
    }
  }

  Widget _panel({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kProstitutionGold.withOpacity(0.28)),
      ),
      child: child,
    );
  }

  Widget _statChip(String label, String value, {Color? accent}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: accent ?? Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (_isLoading) {
      if (widget.embedded) {
        return const Center(child: CircularProgressIndicator());
      }

      return Scaffold(
        appBar: AppBar(title: Text(l10n.prostitutionDistrictManagement)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_district == null) {
      if (widget.embedded) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(l10n.prostitutionDistrictNotFound),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (widget.onBack != null) {
                    widget.onBack!();
                  }
                },
                child: Text(l10n.back),
              ),
            ],
          ),
        );
      }

      return Scaffold(
        appBar: AppBar(title: Text(l10n.prostitutionDistrictManagement)),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(l10n.prostitutionDistrictNotFound),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text(l10n.back),
              ),
            ],
          ),
        ),
      );
    }

    final district = _district!;
    final countryLabel = CountryHelper.getLocalizedCountryName(
      district.countryCode,
      l10n,
    );
    final rooms = district.rooms ?? const <RedLightRoom>[];
    final occupied = rooms.where((r) => r.occupied).length;
    final tierInfo = _upgradeInfo?['tier'] as Map<String, dynamic>?;
    final securityInfo = _upgradeInfo?['security'] as Map<String, dynamic>?;
    final currentNet =
        (tierInfo?['currentEarnings'] as Map?)?['net']?.toString() ?? '—';
    final nextNet =
        (tierInfo?['nextEarnings'] as Map?)?['net']?.toString();

    final content = RefreshIndicator(
      onRefresh: _loadData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProstitutionSectionHeader(
              icon: Icons.apartment,
              title: countryLabel,
              subtitle: l10n.prostitutionRoomsOccupied(
                '$occupied',
                '${rooms.length}',
              ),
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _statChip(
                  l10n.prostitutionTier,
                  _tierLabel(district.tier, l10n),
                  accent: kProstitutionGold,
                ),
                _statChip(
                  l10n.prostitutionSecurityLevel,
                  '${district.securityLevel}',
                ),
                _statChip(
                  l10n.prostitutionRooms,
                  '$occupied / ${rooms.length}',
                ),
              ],
            ),
            const SizedBox(height: 16),
            _panel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProstitutionSectionHeader(
                    icon: Icons.upgrade,
                    title: l10n.prostitutionUpgradeTier,
                    subtitle: l10n.prostitutionCurrentEarningsNet(currentNet),
                  ),
                  if (tierInfo?['canUpgrade'] == true) ...[
                    if (nextNet != null)
                      Text(
                        l10n.prostitutionNextEarnings(nextNet),
                        style: TextStyle(color: Colors.grey.shade300),
                      ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: _isUpgrading ? null : _confirmUpgradeTier,
                        icon: const Icon(Icons.trending_up),
                        label: Text(
                          '${l10n.prostitutionUpgradeTier} · €${tierInfo?['upgradeCost'] ?? '—'}',
                        ),
                        style: FilledButton.styleFrom(
                          backgroundColor: kProstitutionGold,
                          foregroundColor: Colors.black,
                        ),
                      ),
                    ),
                  ] else
                    Text(
                      l10n.prostitutionMaxTier,
                      style: TextStyle(color: Colors.grey.shade400),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _panel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProstitutionSectionHeader(
                    icon: Icons.security,
                    title: l10n.prostitutionUpgradeSecurity,
                    subtitle: l10n.prostitutionRaidReduction(
                      securityInfo?['raidReduction']?.toString() ?? '0%',
                    ),
                  ),
                  if (securityInfo?['canUpgrade'] == true)
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed:
                            _isUpgrading ? null : _confirmUpgradeSecurity,
                        icon: const Icon(Icons.shield),
                        label: Text(
                          '${l10n.prostitutionUpgradeSecurity} · €${securityInfo?['upgradeCost'] ?? '—'}',
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: kProstitutionGold,
                          side: BorderSide(
                            color: kProstitutionGold.withOpacity(0.6),
                          ),
                        ),
                      ),
                    )
                  else
                    Text(
                      l10n.prostitutionMaxSecurity,
                      style: TextStyle(color: Colors.grey.shade400),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            if (_raidStats != null)
              _panel(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProstitutionSectionHeader(
                      icon: Icons.local_police,
                      title: l10n.prostitutionRaidStatsTitle,
                    ),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _statChip(
                          l10n.prostitutionFbiHeat,
                          '${_raidStats!['fbiHeat'] ?? 0}',
                          accent: Colors.orangeAccent,
                        ),
                        _statChip(
                          l10n.prostitutionRaidChance,
                          '${_raidStats!['raidChance'] ?? 0}%',
                          accent: Colors.redAccent,
                        ),
                        _statChip(
                          l10n.prostitutionSecurity,
                          '${_raidStats!['maxSecurity'] ?? 0}',
                        ),
                        _statChip(
                          l10n.prostitutionRaidStatsDistricts,
                          '${_raidStats!['districtCount'] ?? 0}',
                        ),
                        _statChip(
                          l10n.prostitutionRaidStatsBusted,
                          '${_raidStats!['bustedProstitutes'] ?? 0}',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _assignProstitute(district),
                icon: const Icon(Icons.person_add_alt_1),
                label: Text(l10n.prostitutionSelectProstitute),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kProstitutionGold,
                  foregroundColor: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ProstitutionSectionHeader(
              icon: Icons.meeting_room,
              title: l10n.prostitutionRooms,
            ),
            if (rooms.isEmpty)
              _panel(child: Text(l10n.prostitutionNoAvailableDistricts))
            else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: rooms.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1.35,
                ),
                itemBuilder: (context, index) {
                  final room = rooms[index];
                  final occupiedRoom = room.occupied;
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade900,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: occupiedRoom
                            ? kProstitutionGold.withOpacity(0.55)
                            : Colors.white24,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              occupiedRoom
                                  ? Icons.person
                                  : Icons.meeting_room_outlined,
                              color: occupiedRoom
                                  ? kProstitutionGold
                                  : Colors.grey.shade400,
                              size: 18,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                '${l10n.prostitutionRoom} ${room.roomNumber}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          occupiedRoom
                              ? room.prostitute?.name ??
                                  l10n.prostitutionInRedLight
                              : l10n.prostitutionAvailable,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade300,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Spacer(),
                        if (!occupiedRoom)
                          Align(
                            alignment: Alignment.bottomRight,
                            child: TextButton(
                              onPressed: () => _assignProstitute(district),
                              style: TextButton.styleFrom(
                                foregroundColor: kProstitutionGold,
                                visualDensity: VisualDensity.compact,
                              ),
                              child: Text(l10n.prostitutionSelectProstitute),
                            ),
                          )
                        else
                          Text(
                            l10n.prostitutionOccupiedShort,
                            style: const TextStyle(
                              fontSize: 11,
                              color: kProstitutionGold,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );

    if (widget.embedded) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Row(
              children: [
                IconButton(
                  onPressed: widget.onBack,
                  icon: const Icon(Icons.arrow_back),
                  tooltip: l10n.back,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    countryLabel,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: content),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.prostitutionRldAppBarTitle(countryLabel))),
      body: content,
    );
  }
}
