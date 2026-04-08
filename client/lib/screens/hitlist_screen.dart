import 'dart:convert';
import 'package:flutter/material.dart';
import '../services/api_client.dart';
import '../widgets/hit_card.dart';
import '../l10n/app_localizations.dart';
import '../utils/top_right_notification.dart';

String _resolveHitErrorMessage(dynamic data, AppLocalizations? l10n) {
  final code = data is Map ? data['error']?.toString() : null;
  if (code == 'DIFFERENT_COUNTRY') {
    return l10n?.hitDifferentCountry ??
        'You must be in the same country as the target';
  }

  final message = data is Map ? data['message']?.toString() : null;
  if (message != null && message.isNotEmpty) {
    return message;
  }

  final fallback = code ?? 'Unknown error';
  return l10n?.hitError(fallback) ?? 'Error: $fallback';
}

class HitlistScreen extends StatefulWidget {
  const HitlistScreen({super.key});

  @override
  State<HitlistScreen> createState() => _HitlistScreenState();
}

class _HitlistScreenState extends State<HitlistScreen> {
  final ApiClient _apiClient = ApiClient();
  List<dynamic> _activeHits = [];
  bool _isLoading = false;
  bool _isHunted = false;
  final int _page = 0;

  @override
  void initState() {
    super.initState();
    _loadActiveHits();
  }

  Future<void> _loadActiveHits() async {
    setState(() => _isLoading = true);
    try {
      final response = await _apiClient.get('/hitlist/active?page=$_page');
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        setState(() {
          _activeHits = data['hits'] ?? [];
        });
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context);
        showTopRightFromSnackBar(context, 
          SnackBar(content: Text(l10n?.hitlistLoadError(e.toString()) ?? 'Error: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _checkSecurityStatus() async {
    try {
      final response = await _apiClient.get('/security/status');
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        final security = data['security'];
        setState(() {
          _isHunted = security['isTargeted'] ?? false;
        });
      }
    } catch (e) {
      // Silently handle - not critical
    }
  }

  void _placeHit(int targetId) {
    showDialog(
      context: context,
      builder: (context) => _PlaceHitDialog(
        targetId: targetId,
        onComplete: () {
          Navigator.pop(context);
          _loadActiveHits();
        },
      ),
    );
  }

  void _goToSecurity() {
    Navigator.pushNamed(context, '/security');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.hitlist ?? 'Hit List'),
        centerTitle: true,
        actions: [
          if (_isHunted)
            Tooltip(
              message: l10n?.youAreTargeted ?? 'You are on the hit list',
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Icon(Icons.warning, color: Colors.red[300]),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.security),
            tooltip: l10n?.security ?? 'Security',
            onPressed: _goToSecurity,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _activeHits.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.list_alt, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(l10n?.noActiveHits ?? 'No active hits'),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: _checkSecurityStatus,
                        child: Text(l10n?.refresh ?? 'Refresh'),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadActiveHits,
                  child: ListView.builder(
                    itemCount: _activeHits.length,
                    itemBuilder: (context, index) {
                      final hit = _activeHits[index];
                      return HitCard(
                        hit: hit,
                        onAttemptHit: () => _attemptHit(hit['id']),
                        onPlaceCounterBounty: () =>
                            _placeCounterBounty(hit['id'], hit['bounty']),
                        onCancelHit: () => _cancelHit(hit['id']),
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showPlaceHitDialog(),
        tooltip: l10n?.placeHitTitle ?? 'Place Hit',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showPlaceHitDialog() {
    showDialog(
      context: context,
      builder: (context) => _SelectTargetDialog(
        onTargetSelected: (targetId) {
          Navigator.pop(context);
          _placeHit(targetId);
        },
      ),
    );
  }

  Future<void> _attemptHit(int hitId) async {
    showDialog(
      context: context,
      builder: (context) => _AttemptHitDialog(
        hitId: hitId,
        onComplete: () {
          Navigator.pop(context);
          _loadActiveHits();
        },
      ),
    );
  }

  void _placeCounterBounty(int hitId, int originalBounty) {
    showDialog(
      context: context,
      builder: (context) => _PlaceCounterBountyDialog(
        hitId: hitId,
        minimumBounty: originalBounty + 1,
        onComplete: () {
          Navigator.pop(context);
          _loadActiveHits();
        },
      ),
    );
  }

  Future<void> _cancelHit(int hitId) async {
    final l10n = AppLocalizations.of(context);
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          Localizations.localeOf(context).languageCode == 'nl'
              ? 'Weet je het zeker?'
              : 'Are you sure?',
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Localizations.localeOf(context).languageCode == 'nl'
                  ? 'Contract annuleren'
                  : 'Cancel hit contract',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(l10n?.cancelHitConfirmBody ?? 'Your bounty will be refunded.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n?.no ?? 'No'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(l10n?.yes ?? 'Yes'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      final response = await _apiClient.post('/hitlist/cancel/$hitId', {});
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        if (mounted) {
          showTopRightFromSnackBar(context, 
            SnackBar(content: Text(l10n?.hitCancelled ?? 'Hit cancelled')),
          );
        }
        _loadActiveHits();
      } else if (mounted) {
        final errorMsg = _resolveHitErrorMessage(data, l10n);
        showTopRightFromSnackBar(context, 
          SnackBar(content: Text(errorMsg)),
        );
      }
    } catch (e) {
      if (mounted) {
        final errorMsg = AppLocalizations.of(context)?.hitError(e.toString()) ?? 'Error: $e';
        showTopRightFromSnackBar(context, 
          SnackBar(content: Text(errorMsg)),
        );
      }
    }
  }
}

class _SelectTargetDialog extends StatefulWidget {
  final Function(int) onTargetSelected;

  const _SelectTargetDialog({required this.onTargetSelected});

  @override
  State<_SelectTargetDialog> createState() => _SelectTargetDialogState();
}

class _SelectTargetDialogState extends State<_SelectTargetDialog> {
  final _searchController = TextEditingController();
  final ApiClient _apiClient = ApiClient();
  List<dynamic> _players = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadPlayers();
  }

  Future<void> _loadPlayers() async {
    setState(() => _isLoading = true);
    try {
      final response = await _apiClient.get('/player/list');
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        setState(() {
          _players = data['players'] ?? [];
        });
      }
    } catch (e) {
      // Handle error
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final filtered = _players
        .where((p) =>
            p['username']
                ?.toString()
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()) ??
            false)
        .toList();

    return AlertDialog(
      title: Text(l10n?.selectTarget ?? 'Select Target'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: l10n?.searchPlayer ?? 'Search player...',
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final player = filtered[index];
                        return ListTile(
                          title: Text(player['username'] ?? 'Unknown'),
                          subtitle: Text('${l10n?.level ?? 'Level'} ${player['level'] ?? 0}'),
                          onTap: () =>
                              widget.onTargetSelected(player['id']),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n?.cancel ?? 'Cancel'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class _PlaceHitDialog extends StatefulWidget {
  final int targetId;
  final Function onComplete;

  const _PlaceHitDialog({
    required this.targetId,
    required this.onComplete,
  });

  @override
  State<_PlaceHitDialog> createState() => _PlaceHitDialogState();
}

class _PlaceHitDialogState extends State<_PlaceHitDialog> {
  final _bountyController = TextEditingController();
  final ApiClient _apiClient = ApiClient();
  bool _isLoading = false;

  Future<void> _placeHit() async {
    final l10n = AppLocalizations.of(context);
    final bounty = int.tryParse(_bountyController.text);
    if (bounty == null || bounty < 50000) {
      showTopRightFromSnackBar(context, 
        SnackBar(
          content: Text(l10n?.minimumBounty ?? 'Minimum bounty is €50,000'),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final response = await _apiClient.post(
        '/hitlist/place/${widget.targetId}',
        {'bounty': bounty},
      );
      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        if (mounted) {
          final msg = l10n?.hitPlaced(bounty.toStringAsFixed(0)) ?? 'Hit placed for €$bounty';
          showTopRightFromSnackBar(context, 
            SnackBar(content: Text(msg)),
          );
        }
        widget.onComplete();
      } else if (mounted) {
        final errorMsg = _resolveHitErrorMessage(data, l10n);
        showTopRightFromSnackBar(context, 
          SnackBar(content: Text(errorMsg)),
        );
      }
    } catch (e) {
      if (mounted) {
        final errorMsg = AppLocalizations.of(context)?.hitError(e.toString()) ?? 'Error: $e';
        showTopRightFromSnackBar(context, 
          SnackBar(content: Text(errorMsg)),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return AlertDialog(
      title: Text(l10n?.placeHitTitle ?? 'Place Hit'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(l10n?.minimumBounty ?? 'Minimum bounty: €50,000'),
          const SizedBox(height: 16),
          TextField(
            controller: _bountyController,
            decoration: InputDecoration(
              hintText: l10n?.bountyAmount ?? 'Bounty amount',
              prefixText: '€',
            ),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n?.cancel ?? 'Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _placeHit,
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(l10n?.place ?? 'Place'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _bountyController.dispose();
    super.dispose();
  }
}

class _PlaceCounterBountyDialog extends StatefulWidget {
  final int hitId;
  final int minimumBounty;
  final Function onComplete;

  const _PlaceCounterBountyDialog({
    required this.hitId,
    required this.minimumBounty,
    required this.onComplete,
  });

  @override
  State<_PlaceCounterBountyDialog> createState() =>
      _PlaceCounterBountyDialogState();
}

class _PlaceCounterBountyDialogState extends State<_PlaceCounterBountyDialog> {
  final _counterBountyController = TextEditingController();
  final ApiClient _apiClient = ApiClient();
  bool _isLoading = false;

  Future<void> _placeCounterBounty() async {
    final l10n = AppLocalizations.of(context);
    final bounty = int.tryParse(_counterBountyController.text);
    if (bounty == null || bounty <= widget.minimumBounty) {
      final msg = l10n?.minimumAmount(widget.minimumBounty.toStringAsFixed(0)) ?? 
        'Minimum amount: €${widget.minimumBounty}';
      showTopRightFromSnackBar(context, 
        SnackBar(content: Text(msg)),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final response = await _apiClient.post(
        '/hitlist/counter-bounty/${widget.hitId}',
        {'counterBounty': bounty},
      );
      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        if (mounted) {
          final msg = l10n?.counterBountyPlaced(bounty.toStringAsFixed(0)) ?? 'Counter-bounty placed for €$bounty';
          showTopRightFromSnackBar(context, 
            SnackBar(content: Text(msg)),
          );
        }
        widget.onComplete();
      } else if (mounted) {
        final errorMsg = _resolveHitErrorMessage(data, l10n);
        showTopRightFromSnackBar(context, 
          SnackBar(content: Text(errorMsg)),
        );
      }
    } catch (e) {
      if (mounted) {
        final errorMsg = AppLocalizations.of(context)?.hitError(e.toString()) ?? 'Error: $e';
        showTopRightFromSnackBar(context, 
          SnackBar(content: Text(errorMsg)),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return AlertDialog(
      title: Text(l10n?.counterBountyTitle ?? 'Place Counter-Bounty'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(l10n?.minimumAmount(widget.minimumBounty.toStringAsFixed(0)) ?? 'Minimum amount'),
          const SizedBox(height: 16),
          TextField(
            controller: _counterBountyController,
            decoration: InputDecoration(
              hintText: l10n?.counterBountyAmount ?? 'Counter-bounty amount',
              prefixText: '€',
            ),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n?.cancel ?? 'Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _placeCounterBounty,
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(l10n?.place ?? 'Place'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _counterBountyController.dispose();
    super.dispose();
  }
}

class _AttemptHitDialog extends StatefulWidget {
  final int hitId;
  final Function onComplete;

  const _AttemptHitDialog({
    required this.hitId,
    required this.onComplete,
  });

  @override
  State<_AttemptHitDialog> createState() => _AttemptHitDialogState();
}

class _AttemptHitDialogState extends State<_AttemptHitDialog> {
  final ApiClient _apiClient = ApiClient();
  List<dynamic> _weapons = [];
  bool _isLoading = true;
  String? _selectedWeaponId;
  final _ammoController = TextEditingController();
  bool _isExecuting = false;

  @override
  void initState() {
    super.initState();
    _loadWeapons();
  }

  Future<void> _loadWeapons() async {
    try {
      final weaponsResponse = await _apiClient.get('/weapons/inventory');
      final ammoResponse = await _apiClient.get('/ammo/inventory');
      final weaponsData = jsonDecode(weaponsResponse.body);
      final ammoData = jsonDecode(ammoResponse.body);
      final ammoRaw = ammoData is Map ? ammoData['ammo'] : null;
      final ammoList = ammoRaw is List ? ammoRaw : <dynamic>[];
      final ammoByType = <String, int>{
        for (final item in ammoList)
          if (item is Map)
            (item['ammoType'] ?? item['type'] ?? '').toString():
                (item['quantity'] as num?)?.toInt() ?? 0,
      };
      final weaponsRaw = weaponsData is Map ? weaponsData['weapons'] : null;
      final rawWeapons = weaponsRaw is List ? weaponsRaw : <dynamic>[];
      final weapons = rawWeapons.map((weapon) {
        if (weapon is! Map) {
          return <String, dynamic>{
            'weaponId': 'unknown',
            'weaponName': 'Unknown',
            'ammoAvailable': 0,
          };
        }
        final ammoType = weapon['ammoType']?.toString();
        final ammoAvailable =
            ammoType != null ? (ammoByType[ammoType] ?? 0) : 0;
        final weaponName = weapon['name'] ??
            weapon['weaponName'] ??
            weapon['weaponId'] ??
            'Unknown';
        return {
          ...weapon,
          'weaponName': weaponName,
          'ammoAvailable': ammoAvailable,
        };
      }).toList();
      if (mounted) {
        setState(() {
          _weapons = weapons.whereType<Map<String, dynamic>>().toList();
          _isLoading = false;
          if (_weapons.isNotEmpty) {
            _selectedWeaponId = _weapons[0]['weaponId'];
            final weapon = _weapons[0];
            if (weapon['ammoAvailable'] != null) {
              _ammoController.text = weapon['ammoAvailable'].toString();
            }
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        final l10n = AppLocalizations.of(context);
        showTopRightFromSnackBar(context, 
          SnackBar(
            content: Text(l10n?.hitlistLoadError(e.toString()) ?? 'Error: $e'),
          ),
        );
      }
    }
  }

  Future<void> _attemptHit() async {
    final l10n = AppLocalizations.of(context);
    if (_selectedWeaponId == null) {
      showTopRightFromSnackBar(context, 
        SnackBar(
          content: Text(l10n?.selectWeapon ?? 'Please select a weapon'),
        ),
      );
      return;
    }

    final ammo = int.tryParse(_ammoController.text);
    if (ammo == null || ammo <= 0) {
      showTopRightFromSnackBar(context, 
        SnackBar(
          content: Text(l10n?.invalidAmmo ?? 'Please enter valid ammo quantity'),
        ),
      );
      return;
    }

    setState(() => _isExecuting = true);
    try {
      final response = await _apiClient.post(
        '/hitlist/attempt/${widget.hitId}',
        {
          'weaponId': _selectedWeaponId,
          'ammoQuantity': ammo,
        },
      );
      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        if (mounted) {
          final msg = l10n?.hitExecuted ?? 'Hit executed successfully!';
          showTopRightFromSnackBar(context, 
            SnackBar(content: Text(msg)),
          );
        }
        widget.onComplete();
      } else if (mounted) {
        final errorMsg = _resolveHitErrorMessage(data, l10n);
        showTopRightFromSnackBar(context, 
          SnackBar(content: Text(errorMsg)),
        );
      }
    } catch (e) {
      if (mounted) {
        final errorMsg = AppLocalizations.of(context)?.hitError(e.toString()) ?? 'Error: $e';
        showTopRightFromSnackBar(context, 
          SnackBar(content: Text(errorMsg)),
        );
      }
    } finally {
      setState(() => _isExecuting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (_isLoading) {
      return AlertDialog(
        title: Text(l10n?.executeHit ?? 'Execute Hit'),
        content: const SizedBox(
          height: 50,
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    final weaponItems = _weapons.whereType<Map<String, dynamic>>().toList();

    if (weaponItems.isEmpty) {
      return AlertDialog(
        title: Text(l10n?.executeHit ?? 'Execute Hit'),
        content: Text(l10n?.noWeapons ?? 'You have no weapons in your inventory'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n?.close ?? 'Close'),
          ),
        ],
      );
    }

    final selectedWeapon = weaponItems.firstWhere(
      (w) => w['weaponId'] == _selectedWeaponId,
      orElse: () => weaponItems.first,
    );

    return AlertDialog(
      title: Text(l10n?.executeHit ?? 'Execute Hit'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n?.selectWeapon ?? 'Select Weapon',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            DropdownButton<String>(
              isExpanded: true,
              value: _selectedWeaponId,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedWeaponId = value;
                    final weapon = _weapons.firstWhere((w) => w['weaponId'] == value);
                    if (weapon['ammoAvailable'] != null) {
                      _ammoController.text = weapon['ammoAvailable'].toString();
                    } else {
                      _ammoController.text = '0';
                    }
                  });
                }
              },
              items: weaponItems.map<DropdownMenuItem<String>>((weapon) {
                return DropdownMenuItem<String>(
                  value: weapon['weaponId'],
                  child: Text(
                    '${weapon['weaponName']} (${l10n?.condition ?? 'Condition'}: ${(weapon['condition'] ?? 100).toStringAsFixed(1)}%)',
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            if (selectedWeapon['requiresAmmo'] != false) ...[
              Text(
                l10n?.ammoQuantity ?? 'Ammo Quantity',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _ammoController,
                decoration: InputDecoration(
                  hintText: l10n?.ammoQuantity ?? 'Ammo quantity',
                  suffixText: '${selectedWeapon['ammoType'] ?? '?'}',
                  helperText: l10n?.available(selectedWeapon['ammoAvailable']?.toString() ?? '0') ??
                      'Available: ${selectedWeapon['ammoAvailable'] ?? 0}',
                ),
                keyboardType: TextInputType.number,
              ),
            ] else ...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  l10n?.noAmmoRequired ?? 'No ammunition required for this weapon',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n?.weaponStats ?? 'Weapon Stats',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  _StatRow(label: '${l10n?.damage ?? 'Damage'}:', value: '${selectedWeapon['damage'] ?? 0}'),
                  _StatRow(
                    label: '${l10n?.intimidation ?? 'Intimidation'}:',
                    value: '${selectedWeapon['intimidation'] ?? 0}',
                  ),
                  _StatRow(
                    label: '${l10n?.condition ?? 'Condition'}:',
                    value: '${(selectedWeapon['condition'] ?? 100).toStringAsFixed(1)}%',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isExecuting ? null : () => Navigator.pop(context),
          child: Text(l10n?.cancel ?? 'Cancel'),
        ),
        ElevatedButton(
          onPressed: _isExecuting ? null : _attemptHit,
          child: _isExecuting
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(l10n?.execute ?? 'Execute'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _ammoController.dispose();
    super.dispose();
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;

  const _StatRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        Text(value, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
