import 'package:flutter/material.dart';
import '../models/prostitute.dart';
import '../services/prostitution_service.dart';

import '../l10n/app_localizations.dart';
import '../utils/top_right_notification.dart';

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
  bool _isLoading = true;

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

      setState(() {
        _district = district;
        _allProstitutes = prostitutes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        showTopRightFromSnackBar(context, 
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _assignProstitute(RedLightDistrict district) async {
    final l10n = AppLocalizations.of(context)!;

    // Get street prostitutes
    final streetProstitutes = _allProstitutes
        .where((p) => p.location == 'street')
        .toList();

    if (streetProstitutes.isEmpty) {
      showTopRightFromSnackBar(context, 
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
                  backgroundColor: Colors.purple.withOpacity(0.2),
                  child: const Icon(Icons.person, color: Colors.purple),
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
        showTopRightFromSnackBar(context, 
          SnackBar(
            content: Text(result['message'] ?? l10n.prostitutionMoveSuccess),
            backgroundColor: Colors.green,
          ),
        );
      }
    } else {
      if (mounted) {
        showTopRightFromSnackBar(context, 
          SnackBar(
            content: Text(result['message'] ?? l10n.prostitutionMoveFailed),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _getCountryName(String code) {
    final countries = {
      'NL': 'Nederland',
      'BE': 'België',
      'DE': 'Duitsland',
      'FR': 'Frankrijk',
      'IT': 'Italië',
      'ES': 'Spanje',
      'PT': 'Portugal',
      'GB': 'Verenigd Koninkrijk',
      'IE': 'Ierland',
      'LU': 'Luxemburg',
      'CH': 'Zwitserland',
      'AT': 'Oostenrijk',
      'DK': 'Denemarken',
      'SE': 'Zweden',
      'NO': 'Noorwegen',
      'FI': 'Finland',
      'PL': 'Polen',
      'CZ': 'Tsjechië',
      'GR': 'Griekenland',
      'TR': 'Turkije',
    };
    return countries[code] ?? code;
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

    final content = RefreshIndicator(
      onRefresh: _loadData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // District Name
            Text(
              _getCountryName(district.countryCode),
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),

            // Basic Info
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(l10n.prostitutionMyDistricts),
                        Text(_getCountryName(district.countryCode)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _assignProstitute(district),
                icon: const Icon(Icons.person_add_alt_1),
                label: Text(l10n.prostitutionSelectProstitute),
              ),
            ),
            const SizedBox(height: 12),

            Text(
              l10n.prostitutionRooms,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),

            if ((district.rooms ?? const <RedLightRoom>[]).isEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(l10n.prostitutionNoAvailableDistricts),
                ),
              )
            else
              ...district.rooms!.map(
                (room) => Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: Icon(
                      room.occupied ? Icons.person : Icons.meeting_room,
                      color: room.occupied ? Colors.purple : Colors.grey,
                    ),
                    title: Text('${l10n.prostitutionRoom} ${room.roomNumber}'),
                    subtitle: Text(
                      room.occupied
                          ? room.prostitute?.name ?? l10n.prostitutionInRedLight
                          : l10n.prostitutionAvailable,
                    ),
                    trailing: room.occupied
                        ? null
                        : ElevatedButton(
                            onPressed: () => _assignProstitute(district),
                            child: Text(l10n.prostitutionSelectProstitute),
                          ),
                  ),
                ),
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
                    _getCountryName(district.countryCode),
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
      appBar: AppBar(title: Text(_getCountryName(district.countryCode))),
      body: content,
    );
  }
}
