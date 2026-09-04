import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import '../services/api_client.dart';
import '../widgets/hit_card.dart';
import '../l10n/app_localizations.dart';
import '../utils/top_right_notification.dart';
import 'player_profile_screen.dart';
import '../utils/formatters.dart';

String _resolveHitErrorMessage(dynamic data, AppLocalizations l10n) {
  final map = data is Map ? data : null;
  final code = map?['error']?.toString();
  switch (code) {
    case 'DIFFERENT_COUNTRY':
      return l10n.hitDifferentCountry;
    case 'MISSING_BOUNTY':
      return l10n.hitlistErrMissingBounty;
    case 'BOUNTY_TOO_LOW':
      return l10n.hitlistErrBountyTooLow;
    case 'CANNOT_HIT_YOURSELF':
      return l10n.hitlistErrCannotHitYourself;
    case 'HIT_ALREADY_EXISTS':
      return l10n.hitlistErrHitAlreadyExists;
    case 'INSUFFICIENT_MONEY':
      return l10n.hitlistErrInsufficientMoney;
    case 'MISSING_COUNTER_BOUNTY':
      return l10n.hitlistErrMissingCounterBounty;
    case 'HIT_NOT_FOUND':
      return l10n.hitlistErrHitNotFound;
    case 'NOT_TARGET':
      return l10n.hitlistErrNotTarget;
    case 'HIT_NOT_ACTIVE':
      return l10n.hitlistErrHitNotActive;
    case 'COUNTER_BOUNTY_MUST_BE_HIGHER':
      return l10n.hitlistErrCounterBountyMustBeHigher;
    case 'MISSING_WEAPON':
      return l10n.hitlistErrMissingWeapon;
    case 'WEAPON_NOT_FOUND':
      return l10n.hitlistErrWeaponNotFound;
    case 'WEAPON_NOT_OWNED':
      return l10n.hitlistErrWeaponNotOwned;
    case 'WEAPON_BROKEN':
      return l10n.hitlistErrWeaponBroken;
    case 'INSUFFICIENT_AMMO':
      return l10n.hitlistErrInsufficientAmmo;
    case 'INVALID_AMMO':
      return l10n.hitlistErrInvalidAmmoHit;
    case 'TARGET_UNDER_HIT_PROTECTION':
      return l10n.hitlistErrTargetUnderHitProtection;
    case 'INVALID_INVESTIGATION_TIER':
      return l10n.hitlistErrInvalidInvestigationTier;
    case 'INVESTIGATION_ALREADY_PENDING':
      return l10n.hitlistErrInvestigationAlreadyPending;
    case 'INVALID_CASE_ID':
      return l10n.hitlistErrInvalidCaseId;
    case 'MURDER_CASE_NOT_FOUND':
      return l10n.hitlistErrMurderCaseNotFound;
    case 'MURDER_CASE_EXPIRED':
      return l10n.hitlistErrMurderCaseExpired;
    case 'MURDER_CASE_ALREADY_REQUESTED':
      return l10n.hitlistErrMurderCaseAlreadyRequested;
    case 'NOT_PLACER':
      return l10n.hitlistErrNotPlacer;
    default:
      break;
  }

  final message = map?['message']?.toString();
  if (message != null && message.isNotEmpty) {
    return message;
  }

  final fallback = code ?? l10n.unknown;
  return l10n.hitError(fallback);
}

String? _hitCombatLine(dynamic combat, AppLocalizations l10n) {
  if (combat is! Map) return null;
  final armor = (combat['armorDefense'] as num?)?.toInt() ?? 0;
  final guards = (combat['bodyguardDefense'] as num?)?.toInt() ?? 0;
  final chance = (combat['winChancePercent'] as num?)?.toInt();
  if (chance == null) return null;
  return l10n.hitCombatBreakdown('$armor', '$guards', '$chance');
}

class HitlistScreen extends StatefulWidget {
  final VoidCallback? onOpenSecurity;

  const HitlistScreen({super.key, this.onOpenSecurity});

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _checkSecurityStatus();
      }
    });
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
        await _checkSecurityStatus();
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        showTopRightFromSnackBar(
          context,
          SnackBar(content: Text(l10n.hitlistLoadError(e.toString()))),
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
    if (widget.onOpenSecurity != null) {
      widget.onOpenSecurity!();
      return;
    }
    Navigator.pushNamed(context, '/security');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.hitlist),
        centerTitle: true,
        actions: [
          if (_isHunted)
            Tooltip(
              message: l10n.youAreTargeted,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Icon(Icons.warning, color: Colors.red[300]),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.security),
            tooltip: l10n.security,
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
                  Text(l10n.noActiveHits),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () async {
                      await _loadActiveHits();
                      await _checkSecurityStatus();
                    },
                    child: Text(l10n.retry),
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
                    onInvestigate: () => _showInvestigateOptions(hit['id']),
                    onOpenPlayerProfile: _openPlayerProfile,
                    onPlaceCounterBounty: () =>
                        _placeCounterBounty(hit['id'], hit['bounty']),
                    onCancelHit: () => _cancelHit(hit['id']),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showPlaceHitDialog(),
        tooltip: l10n.placeHitTitle,
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

  void _showInvestigateOptions(int hitId) {
    showDialog(
      context: context,
      builder: (context) => _InvestigateHitDialog(hitId: hitId),
    );
  }

  void _openPlayerProfile(int playerId, String? username) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FractionallySizedBox(
        heightFactor: 0.94,
        child: PlayerProfileScreen(
          playerId: playerId,
          username: (username != null && username.isNotEmpty)
              ? username
              : AppLocalizations.of(context)!.unknown,
          embedded: true,
        ),
      ),
    );
  }

  Future<void> _cancelHit(int hitId) async {
    final l10n = AppLocalizations.of(context)!;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.cancelHitConfirmTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Text(l10n.cancelHitConfirmBody)],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.no),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(l10n.yes),
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
          showTopRightFromSnackBar(
            context,
            SnackBar(content: Text(l10n.hitCancelled)),
          );
        }
        _loadActiveHits();
      } else if (mounted) {
        final errorMsg = _resolveHitErrorMessage(data, l10n);
        showTopRightFromSnackBar(context, SnackBar(content: Text(errorMsg)));
      }
    } catch (e) {
      if (mounted) {
        final errorMsg = AppLocalizations.of(context)!.hitError(e.toString());
        showTopRightFromSnackBar(context, SnackBar(content: Text(errorMsg)));
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
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        showTopRightFromSnackBar(
          context,
          SnackBar(content: Text(l10n.hitlistPlayersLoadError(e.toString()))),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final filtered = _players
        .where(
          (p) =>
              p['username']?.toString().toLowerCase().contains(
                _searchController.text.toLowerCase(),
              ) ??
              false,
        )
        .toList();

    return AlertDialog(
      title: Text(l10n.selectTarget),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: l10n.searchPlayer,
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
                          title: Text(player['username'] ?? l10n.unknown),
                          subtitle: Text(
                            '${l10n.level} ${player['level'] ?? 0}',
                          ),
                          onTap: () => widget.onTargetSelected(player['id']),
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
          child: Text(l10n.cancel),
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

  const _PlaceHitDialog({required this.targetId, required this.onComplete});

  @override
  State<_PlaceHitDialog> createState() => _PlaceHitDialogState();
}

class _PlaceHitDialogState extends State<_PlaceHitDialog> {
  final _bountyController = TextEditingController();
  final ApiClient _apiClient = ApiClient();
  bool _isLoading = false;

  Future<void> _placeHit() async {
    final l10n = AppLocalizations.of(context)!;
    final bounty = int.tryParse(_bountyController.text);
    if (bounty == null || bounty < 50000) {
      showTopRightFromSnackBar(
        context,
        SnackBar(content: Text(l10n.minimumBounty)),
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
          final msg = l10n.hitPlaced(bounty.toStringAsFixed(0));
          showTopRightFromSnackBar(context, SnackBar(content: Text(msg)));
        }
        widget.onComplete();
      } else if (mounted) {
        final errorMsg = _resolveHitErrorMessage(data, l10n);
        showTopRightFromSnackBar(context, SnackBar(content: Text(errorMsg)));
      }
    } catch (e) {
      if (mounted) {
        final errorMsg = AppLocalizations.of(context)!.hitError(e.toString());
        showTopRightFromSnackBar(context, SnackBar(content: Text(errorMsg)));
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(l10n.placeHitTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(l10n.minimumBounty),
          const SizedBox(height: 16),
          TextField(
            controller: _bountyController,
            decoration: InputDecoration(
              hintText: l10n.bountyAmount,
              prefixText: '€',
            ),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _placeHit,
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(l10n.place),
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
    final l10n = AppLocalizations.of(context)!;
    final bounty = int.tryParse(_counterBountyController.text);
    if (bounty == null || bounty <= widget.minimumBounty) {
      final msg = l10n.minimumAmount(widget.minimumBounty.toStringAsFixed(0));
      showTopRightFromSnackBar(context, SnackBar(content: Text(msg)));
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
          final msg = l10n.counterBountyPlaced(bounty.toStringAsFixed(0));
          showTopRightFromSnackBar(context, SnackBar(content: Text(msg)));
        }
        widget.onComplete();
      } else if (mounted) {
        final errorMsg = _resolveHitErrorMessage(data, l10n);
        showTopRightFromSnackBar(context, SnackBar(content: Text(errorMsg)));
      }
    } catch (e) {
      if (mounted) {
        final errorMsg = AppLocalizations.of(context)!.hitError(e.toString());
        showTopRightFromSnackBar(context, SnackBar(content: Text(errorMsg)));
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(l10n.counterBountyTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(l10n.minimumAmount(widget.minimumBounty.toStringAsFixed(0))),
          const SizedBox(height: 16),
          TextField(
            controller: _counterBountyController,
            decoration: InputDecoration(
              hintText: l10n.counterBountyAmount,
              prefixText: '€',
            ),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _placeCounterBounty,
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(l10n.place),
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

  const _AttemptHitDialog({required this.hitId, required this.onComplete});

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

  int _asInt(dynamic value, {required int fallback}) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value.trim()) ?? fallback;
    return fallback;
  }

  double _asDouble(dynamic value, {required double fallback}) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value.trim()) ?? fallback;
    return fallback;
  }

  Map<String, dynamic>? _normalizeMap(dynamic value) {
    if (value is Map) {
      return value.map(
        (key, mapValue) => MapEntry(key.toString(), mapValue),
      );
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _loadWeapons();
  }

  Future<void> _loadWeapons() async {
    final l10n = AppLocalizations.of(context)!;
    try {
      final weaponsResponse = await _apiClient.get('/weapons/inventory');
      final ammoResponse = await _apiClient.get('/ammo/inventory');
      final weaponsData = jsonDecode(weaponsResponse.body);
      final ammoData = jsonDecode(ammoResponse.body);
      final ammoRaw = ammoData is Map ? ammoData['ammo'] : null;
      final ammoList = ammoRaw is List ? ammoRaw : <dynamic>[];
      final ammoByType = <String, int>{
        for (final item in ammoList)
          if (_normalizeMap(item) != null)
            ((_normalizeMap(item)!['ammoType'] ?? _normalizeMap(item)!['type'] ?? '').toString()):
                _asInt(_normalizeMap(item)!['quantity'], fallback: 0),
      };
      final weaponsRaw = weaponsData is Map ? weaponsData['weapons'] : null;
      final rawWeapons = weaponsRaw is List ? weaponsRaw : <dynamic>[];
      final weapons = rawWeapons.map((weapon) {
        final normalizedWeapon = _normalizeMap(weapon);
        if (normalizedWeapon == null) {
          return <String, dynamic>{
            'weaponId': 'unknown',
            'weaponName': l10n.unknown,
            'ammoAvailable': 0,
            'quantity': 0,
            'condition': 0,
          };
        }
        final resolvedWeaponId =
            (normalizedWeapon['weaponId'] ?? normalizedWeapon['id'] ?? '').toString().trim();
        final ammoType = normalizedWeapon['ammoType']?.toString();
        final ammoAvailable = ammoType != null
            ? (ammoByType[ammoType] ?? 0)
            : 0;
        final weaponName =
            normalizedWeapon['name'] ??
            normalizedWeapon['weaponName'] ??
            normalizedWeapon['weaponId'] ??
            l10n.unknown;
        return {
          ...normalizedWeapon,
          'weaponId': resolvedWeaponId,
          'weaponName': weaponName,
          'ammoAvailable': ammoAvailable,
          'quantity': _asInt(normalizedWeapon['quantity'], fallback: 1),
          'condition': _asDouble(normalizedWeapon['condition'], fallback: 100),
        };
      }).toList();

      final usableWeapons = weapons
          .map(_normalizeMap)
          .whereType<Map<String, dynamic>>()
          .where((weapon) {
            final weaponId = (weapon['weaponId'] ?? '').toString().trim();
            final quantity = _asInt(weapon['quantity'], fallback: 1);
            final condition = _asDouble(weapon['condition'], fallback: 100);
            return weaponId.isNotEmpty && quantity > 0 && condition > 0;
          })
          .toList();

      if (mounted) {
        setState(() {
          _weapons = usableWeapons;
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
        final l10n = AppLocalizations.of(context)!;
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(l10n.hitlistWeaponsInventoryLoadError(e.toString())),
          ),
        );
      }
    }
  }

  Future<void> _attemptHit() async {
    final l10n = AppLocalizations.of(context)!;
    final selectedWeaponId = _selectedWeaponId?.trim();
    if (selectedWeaponId == null || selectedWeaponId.isEmpty) {
      showTopRightFromSnackBar(
        context,
        SnackBar(content: Text(l10n.selectWeapon)),
      );
      return;
    }

    final ammo = int.tryParse(_ammoController.text);
    if (ammo == null || ammo <= 0) {
      showTopRightFromSnackBar(
        context,
        SnackBar(content: Text(l10n.invalidAmmo)),
      );
      return;
    }

    setState(() => _isExecuting = true);
    try {
      final response = await _apiClient
          .post('/hitlist/attempt/${widget.hitId}', {
            'weaponId': selectedWeaponId,
            'ammoQuantity': ammo,
          })
          .timeout(const Duration(seconds: 15));
      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        if (mounted) {
          String msg = l10n.hitExecuted;
          if (data['loot'] is Map) {
            final loot = data['loot'] as Map;
            final cashAwarded = _asInt(loot['cashAwarded'], fallback: 0);
            final itemsAwarded = _asInt(loot['itemsAwarded'], fallback: 0);
            msg = l10n.hitlistHitSuccessWithLoot(
              formatCurrency(cashAwarded),
              itemsAwarded.toString(),
            );
          }
          final combatLine = _hitCombatLine(data['combat'], l10n);
          if (combatLine != null) {
            msg = '$msg\n$combatLine';
          }
          showTopRightFromSnackBar(context, SnackBar(content: Text(msg)));
        }
        widget.onComplete();
      } else if (data['defended'] == true && mounted) {
        final combatLine = _hitCombatLine(data['combat'], l10n);
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(
              combatLine == null
                  ? l10n.hitDefendedBySecurity
                  : '${l10n.hitDefendedBySecurity}\n$combatLine',
            ),
          ),
        );
        widget.onComplete();
      } else if (mounted) {
        final errorMsg = _resolveHitErrorMessage(data, l10n);
        showTopRightFromSnackBar(context, SnackBar(content: Text(errorMsg)));
      }
    } on TimeoutException {
      if (mounted) {
        showTopRightFromSnackBar(
          context,
          SnackBar(content: Text(l10n.hitlistAttemptTimeout)),
        );
      }
    } catch (e) {
      if (mounted) {
        final errorMsg = AppLocalizations.of(context)!.hitError(e.toString());
        showTopRightFromSnackBar(context, SnackBar(content: Text(errorMsg)));
      }
    } finally {
      setState(() => _isExecuting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (_isLoading) {
      return AlertDialog(
        title: Text(l10n.executeHit),
        content: const SizedBox(
          height: 50,
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    final weaponItems = _weapons
      .map(_normalizeMap)
      .whereType<Map<String, dynamic>>()
      .toList();

    if (weaponItems.isEmpty) {
      return AlertDialog(
        title: Text(l10n.executeHit),
        content: Text(l10n.hitlistNoUsableWeapons),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.close),
          ),
        ],
      );
    }

    final selectedWeapon = weaponItems.firstWhere(
      (w) => w['weaponId'] == _selectedWeaponId,
      orElse: () => weaponItems.first,
    );

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final infoCardColor = isDark
        ? Colors.black.withValues(alpha: 0.45)
        : Colors.white.withValues(alpha: 0.92);
    final infoBorderColor = isDark
        ? Colors.white.withValues(alpha: 0.14)
        : Colors.black.withValues(alpha: 0.10);
    final infoTitleStyle = theme.textTheme.titleSmall?.copyWith(
      color: colorScheme.onSurface,
      fontWeight: FontWeight.w700,
    );
    final infoLabelStyle = theme.textTheme.bodySmall?.copyWith(
      color: colorScheme.onSurfaceVariant,
      fontWeight: FontWeight.w600,
    );
    final infoValueStyle = theme.textTheme.bodySmall?.copyWith(
      color: colorScheme.onSurface,
      fontWeight: FontWeight.w700,
    );

    return AlertDialog(
      title: Text(l10n.executeHit),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.selectWeapon,
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
                    final weapon = _weapons.firstWhere(
                      (w) => w['weaponId'] == value,
                    );
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
                    '${weapon['weaponName']} (${l10n.condition}: ${(weapon['condition'] ?? 100).toStringAsFixed(1)}%)',
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            if (selectedWeapon['requiresAmmo'] != false) ...[
              Text(
                l10n.ammoQuantity,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _ammoController,
                decoration: InputDecoration(
                  hintText: l10n.ammoQuantity,
                  suffixText: '${selectedWeapon['ammoType'] ?? '?'}',
                  helperText: l10n.available(
                    selectedWeapon['ammoAvailable']?.toString() ?? '0',
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
            ] else ...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  l10n.noAmmoRequired,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                ),
              ),
            ],
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: infoCardColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: infoBorderColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.weaponStats,
                    style: infoTitleStyle,
                  ),
                  const SizedBox(height: 8),
                  _StatRow(
                    label: '${l10n.damage}:',
                    value: '${selectedWeapon['damage'] ?? 0}',
                    labelStyle: infoLabelStyle,
                    valueStyle: infoValueStyle,
                  ),
                  _StatRow(
                    label: '${l10n.intimidation}:',
                    value: '${selectedWeapon['intimidation'] ?? 0}',
                    labelStyle: infoLabelStyle,
                    valueStyle: infoValueStyle,
                  ),
                  _StatRow(
                    label: '${l10n.condition}:',
                    value:
                        '${(selectedWeapon['condition'] ?? 100).toStringAsFixed(1)}%',
                    labelStyle: infoLabelStyle,
                    valueStyle: infoValueStyle,
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
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          onPressed: _isExecuting ? null : _attemptHit,
          child: _isExecuting
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(l10n.execute),
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

class _InvestigateHitDialog extends StatefulWidget {
  final int hitId;

  const _InvestigateHitDialog({required this.hitId});

  @override
  State<_InvestigateHitDialog> createState() => _InvestigateHitDialogState();
}

class _InvestigateHitDialogState extends State<_InvestigateHitDialog> {
  final ApiClient _apiClient = ApiClient();
  bool _isLoading = false;

  Future<void> _runInvestigation(String tier) async {
    if (_isLoading) return;

    setState(() => _isLoading = true);
    try {
      final response = await _apiClient.post(
        '/hitlist/investigate/${widget.hitId}',
        {'tier': tier},
      );
      final data = jsonDecode(response.body);

      if (!mounted) return;

      final l10n = AppLocalizations.of(context)!;

      if (data['success'] == true && data['queue'] is Map) {
        final queue = data['queue'] as Map;
        final costVal = queue['cost'];
        final costStr = costVal is num
            ? formatCurrency(costVal)
            : formatCurrency(num.tryParse(costVal?.toString() ?? '') ?? 0);
        final etaMinutes = queue['etaMinutes']?.toString() ?? '?';
        final resolveAt = queue['resolveAt']?.toString() ?? '-';

        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(
              l10n.hitlistInvestigationQueued(costStr, etaMinutes, resolveAt),
            ),
          ),
        );
        Navigator.pop(context);
      } else {
        final message =
            data['message']?.toString() ?? l10n.hitlistInvestigationFailedGeneric;
        showTopRightFromSnackBar(context, SnackBar(content: Text(message)));
      }
    } catch (_) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(l10n.hitlistInvestigationCouldNotComplete),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(l10n.hitlistInvestigationOptions),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.hitlistInvestigationChooseSpeedPrice),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _isLoading ? null : () => _runInvestigation('quick'),
            child: Text(l10n.hitlistInvestigationQuick),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: _isLoading ? null : () => _runInvestigation('standard'),
            child: Text(l10n.hitlistInvestigationStandard),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: _isLoading ? null : () => _runInvestigation('deep'),
            child: Text(l10n.hitlistInvestigationSlow),
          ),
          if (_isLoading) ...[
            const SizedBox(height: 12),
            const Center(child: CircularProgressIndicator()),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: Text(l10n.close),
        ),
      ],
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;

  const _StatRow({
    required this.label,
    required this.value,
    this.labelStyle,
    this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    final defaultLabelStyle = Theme.of(context).textTheme.bodySmall;
    final defaultValueStyle = Theme.of(
      context,
    ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: labelStyle ?? defaultLabelStyle),
        Text(value, style: valueStyle ?? defaultValueStyle),
      ],
    );
  }
}
