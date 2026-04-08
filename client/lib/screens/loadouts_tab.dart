import 'package:flutter/material.dart';
import '../models/loadout.dart';
import '../services/loadout_service.dart';
import '../widgets/loadout_card.dart';
import 'create_loadout_screen.dart';
import '../l10n/app_localizations.dart';
import '../utils/top_right_notification.dart';

class LoadoutsTab extends StatefulWidget {
  final int playerId;

  const LoadoutsTab({
    super.key,
    required this.playerId,
  });

  @override
  State<LoadoutsTab> createState() => _LoadoutsTabState();
}

class _LoadoutsTabState extends State<LoadoutsTab> {
  final LoadoutService _loadoutService = LoadoutService();
  List<Loadout> _loadouts = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState()  {
    super.initState();
    _loadLoadouts();
  }

  Future<void> _loadLoadouts() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final result = await _loadoutService.getLoadouts();

    if (mounted) {
      setState(() {
        _isLoading = false;
        if (result['success']) {
          _loadouts = result['loadouts'];
        } else {
          _error = result['error'];
        }
      });
    }
  }

  Future<void> _equipLoadout(Loadout loadout) async {
    if (loadout.isActive) return;

    final result = await _loadoutService.equipLoadout(loadout.id);

    if (mounted) {
      if (result['success']) {
        showTopRightFromSnackBar(context, 
          SnackBar(
            content: Text(AppLocalizations.of(context)!.loadoutEquipped),
            backgroundColor: Colors.green,
          ),
        );
        await _loadLoadouts();
      } else {
        showTopRightFromSnackBar(context, 
          SnackBar(
            content: Text(result['error'] ?? 'Failed to equip loadout'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _deleteLoadout(Loadout loadout) async {
    final l10n = AppLocalizations.of(context)!;
    
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[850],
        title: Text(
          Localizations.localeOf(context).languageCode == 'nl'
              ? 'Weet je het zeker?'
              : 'Are you sure?',
          style: const TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.deleteLoadout,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '${l10n.confirmDeleteLoadout} "${loadout.name}"?',
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
        contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
        actionsPadding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel, style: const TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final result = await _loadoutService.deleteLoadout(loadout.id);

    if (mounted) {
      if (result['success']) {
        showTopRightFromSnackBar(context, 
          SnackBar(
            content: Text(l10n.loadoutDeleted),
            backgroundColor: Colors.green,
          ),
        );
        await _loadLoadouts();
      } else {
        showTopRightFromSnackBar(context, 
          SnackBar(
            content: Text(result['error'] ?? 'Failed to delete loadout'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _createLoadout() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => CreateLoadoutScreen(
          playerId: widget.playerId,
        ),
      ),
    );

    if (result == true) {
      await _loadLoadouts();
    }
  }

  void _editLoadout(Loadout loadout) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => CreateLoadoutScreen(
          playerId: widget.playerId,
          loadout: loadout,
        ),
      ),
    );

    if (result == true) {
      await _loadLoadouts();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    const maxLoadouts = 5;

    return RefreshIndicator(
      onRefresh: _loadLoadouts,
      child: Column(
        children: [
          // Create loadout button
          if (_loadouts.length < maxLoadouts)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[850],
                border: Border(
                  bottom: BorderSide(color: Colors.grey[700]!),
                ),
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _createLoadout,
                  icon: const Icon(Icons.add),
                  label: Text(l10n.createLoadout),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),

          // Loadouts list
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: Colors.amber))
                : _error != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error, color: Colors.red, size: 64),
                            const SizedBox(height: 16),
                            Text(
                              _error!,
                              style: const TextStyle(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: _loadLoadouts,
                              icon: const Icon(Icons.refresh),
                              label: Text(l10n.retry),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amber,
                                foregroundColor: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      )
                    : _loadouts.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.dashboard_customize_outlined, size: 80, color: Colors.grey[600]),
                                const SizedBox(height: 16),
                                Text(
                                  l10n.noLoadouts,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[400],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  l10n.createLoadoutToStart,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 24),
                                ElevatedButton.icon(
                                  onPressed: _createLoadout,
                                  icon: const Icon(Icons.add),
                                  label: Text(l10n.createLoadout),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.amber,
                                    foregroundColor: Colors.black,
                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(8),
                            itemCount: _loadouts.length,
                            itemBuilder: (context, index) {
                              final loadout = _loadouts[index];
                              return LoadoutCard(
                                loadout: loadout,
                                onEquip: () => _equipLoadout(loadout),
                                onEdit: () => _editLoadout(loadout),
                                onDelete: () => _deleteLoadout(loadout),
                              );
                            },
                          ),
          ),

          // Max loadouts info
          if (_loadouts.length >= maxLoadouts)
            Container(
              padding: const EdgeInsets.all(12),
              color: Colors.grey[850],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.info_outline, color: Colors.orange, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    l10n.loadoutMaxReached,
                    style: const TextStyle(
                      color: Colors.orange,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
