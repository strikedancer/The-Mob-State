import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/auth_provider.dart';
import '../services/api_client.dart';
import '../services/event_renderer.dart';
import '../utils/top_right_notification.dart';

class CrewJailbreakScreen extends StatefulWidget {
  final int crewId;
  final String crewName;

  const CrewJailbreakScreen({
    super.key,
    required this.crewId,
    required this.crewName,
  });

  @override
  State<CrewJailbreakScreen> createState() => _CrewJailbreakScreenState();
}

class _CrewJailbreakScreenState extends State<CrewJailbreakScreen> {
  final ApiClient _apiClient = ApiClient();
  List<JailedMember> _jailedMembers = [];
  bool _isLoading = true;
  bool _isRescuing = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadJailedMembers();
  }

  Future<void> _loadJailedMembers() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await _apiClient.get('/heists/crew/${widget.crewId}/jailed');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final membersJson = data['jailedMembers'] as List? ?? [];
        
        setState(() {
          _jailedMembers = membersJson
              .map((m) => JailedMember.fromJson(m))
              .toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Failed to load jailed members';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _attemptJailbreak(JailedMember member) async {
    // Show confirmation dialog with risks
    final l10n = AppLocalizations.of(context)!;
    final isDutch = Localizations.localeOf(context).languageCode == 'nl';

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.warning, color: Colors.orange),
            const SizedBox(width: 10),
            Text(isDutch ? 'Weet je het zeker?' : 'Are you sure?'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isDutch
                  ? 'Uitbraakpoging voor ${member.username}:'
                  : 'Jailbreak attempt for ${member.username}:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            _buildRiskItem(
              Icons.check_circle,
              Colors.green,
              isDutch ? 'Bij succes: Speler vrij!' : 'If successful: Player freed!',
            ),
            _buildRiskItem(
              Icons.cancel,
              Colors.orange,
              isDutch ? 'Bij mislukking: 60% kans gepakt' : 'If failed: 60% chance caught',
            ),
            _buildRiskItem(
              Icons.dangerous,
              Colors.red,
              isDutch ? 'Gepakt: 30-60 min cel + wanted +10' : 'Caught: 30-60 min jail + wanted +10',
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                isDutch
                    ? 'Succes kans verhoogt met rank en crew bonus!'
                    : 'Success chance increases with rank and crew bonus!',
                style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(isDutch ? 'Annuleren' : 'Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
            ),
            child: Text(isDutch ? 'Probeer uitbraak' : 'Attempt Jailbreak'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() {
      _isRescuing = true;
    });

    try {
      final response = await _apiClient.post(
        '/player/jailbreak/${member.playerId}',
        {'crewId': widget.crewId},
      );

      final data = jsonDecode(response.body);
      final eventKey = data['event'] as String;
      final params = (data['params'] as Map<String, dynamic>?) ?? {};

      if (mounted) {
        final eventRenderer = EventRenderer(l10n);
        final message = eventRenderer.renderEvent(eventKey, params);

        showTopRightFromSnackBar(context, 
          SnackBar(
            content: Text(message),
            backgroundColor: eventKey.contains('success')
                ? Colors.green
                : eventKey.contains('caught')
                    ? Colors.red
                    : Colors.orange,
            duration: const Duration(seconds: 5),
          ),
        );

        // Refresh list
        await _loadJailedMembers();

        // If rescuer got caught, they might need to see their own jail screen
        if (eventKey == 'jailbreak.caught') {
          final authProvider = Provider.of<AuthProvider>(context, listen: false);
          await authProvider.refreshPlayer();
        }
      }
    } catch (e) {
      if (mounted) {
        showTopRightFromSnackBar(context, 
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isRescuing = false;
        });
      }
    }
  }

  Widget _buildRiskItem(IconData icon, Color color, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDutch = Localizations.localeOf(context).languageCode == 'nl';

    return Scaffold(
      appBar: AppBar(
        title: Text(isDutch ? '🚔 Gevangen Crew' : '🚔 Jailed Crew'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_error!, style: const TextStyle(color: Colors.red)),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadJailedMembers,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : _jailedMembers.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.celebration, size: 80, color: Colors.green),
                          const SizedBox(height: 20),
                          Text(
                            isDutch ? '🎉 Niemand in de cel!' : '🎉 No one in jail!',
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            isDutch
                                ? 'Alle crew members zijn vrij'
                                : 'All crew members are free',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _jailedMembers.length,
                      itemBuilder: (context, index) {
                        final member = _jailedMembers[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            leading: const CircleAvatar(
                              backgroundColor: Colors.orange,
                              child: Icon(Icons.person_off, color: Colors.white),
                            ),
                            title: Text(
                              member.username,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              isDutch
                                  ? '⏱️ ${member.jailTime} minuten cel'
                                  : '⏱️ ${member.jailTime} minutes in jail',
                            ),
                            trailing: ElevatedButton.icon(
                              onPressed: _isRescuing ? null : () => _attemptJailbreak(member),
                              icon: _isRescuing
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    )
                                  : const Icon(Icons.vpn_key),
                              label: Text(isDutch ? 'Bevrijd' : 'Rescue'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}

class JailedMember {
  final int playerId;
  final String username;
  final int jailTime;

  JailedMember({
    required this.playerId,
    required this.username,
    required this.jailTime,
  });

  factory JailedMember.fromJson(Map<String, dynamic> json) {
    return JailedMember(
      playerId: json['playerId'] as int,
      username: json['username'] as String,
      jailTime: json['jailTime'] as int,
    );
  }
}
