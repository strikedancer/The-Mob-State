// ignore_for_file: unused_field, unused_element
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/judge.dart';
import '../providers/auth_provider.dart';
import '../services/api_client.dart';
import '../l10n/app_localizations.dart';
import '../utils/top_right_notification.dart';

class CourtScreen extends StatefulWidget {
  const CourtScreen({super.key});

  @override
  State<CourtScreen> createState() => _CourtScreenState();
}

class _CourtScreenState extends State<CourtScreen> {
  final ApiClient _apiClient = ApiClient();
  
  bool _isLoading = true;
  JailSentence? _currentSentence;
  String? _error;
  bool _isProcessing = false;

  bool get _isNl => Localizations.localeOf(context).languageCode == 'nl';
  String _tr(String nl, String en) => _isNl ? nl : en;

  @override
  void initState() {
    super.initState();
    _loadCurrentSentence();
  }

  Future<void> _loadCurrentSentence() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Check player's jail status
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final player = authProvider.currentPlayer;
      
      if (player == null) {
        setState(() {
          _error = 'Niet ingelogd';
          _isLoading = false;
        });
        return;
      }

      // Get current jail sentence (if any)
      final response = await _apiClient.get('/player/status');
      final data = jsonDecode(response.body);
      
      if (data['jailTime'] != null && data['jailTime'] > 0) {
        // Player is in jail - for now just show message
        setState(() {
          _isLoading = false;
        });
        
        if (mounted) {
          showTopRightFromSnackBar(context, 
            const SnackBar(
              content: Text(
                'Rechtbank systeem is nog niet volledig geïmplementeerd. '
                'Je kunt nu alleen wachten tot je vrijkomt.',
              ),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 3),
            ),
          );
        }
        return;
      }

      setState(() {
        _currentSentence = null;
        _isLoading = false;
      });
    } catch (e) {
      print('[CourtScreen] Error loading sentence: $e');
      setState(() {
        _error = 'Kon rechtbankinfo niet laden: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _appealSentence() async {
    if (_currentSentence == null) return;

    final confirmed = await showDialog<bool>(
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
              AppLocalizations.of(context)!.appeal,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Wil je in hoger beroep gaan tegen je veroordeling?',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(
              'Kosten: €10.000',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Rechter: ${_currentSentence!.judge.name}',
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
            Text(
              'Corruptibiliteit: ${_currentSentence!.judge.corruptibility}%',
              style: TextStyle(
                fontSize: 14,
                color: _currentSentence!.judge.corruptibilityColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Bij succes: 50% strafvermindering',
              style: TextStyle(
                fontSize: 13,
                color: Colors.green,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(_tr('Annuleren', 'Cancel')),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            child: Text(AppLocalizations.of(context)!.submitAppeal),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isProcessing = true);

    try {
      final response = await _apiClient.post(
        '/trial/appeal',
        {'crimeAttemptId': _currentSentence!.crimeAttemptId},
      );

      final data = jsonDecode(response.body);
      
      // Handle both event-based and direct responses
      final params = data['params'] as Map<String, dynamic>? ?? data;
      final success = params['success'] as bool? ?? false;
      final newSentence = params['newSentence'] as int?;
      final newBalance = params['newBalance'] as int?;

      if (mounted) {
        showTopRightFromSnackBar(context, 
          SnackBar(
            content: Text(
              success
                  ? _tr('✅ Hoger beroep geslaagd! Straf verminderd naar $newSentence minuten', '✅ Appeal successful! Sentence reduced to $newSentence minutes')
                  : _tr('❌ Hoger beroep afgewezen', '❌ Appeal rejected'),
            ),
            backgroundColor: success ? Colors.green : Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );

        if (success) {
          // Update player stats
          final authProvider = Provider.of<AuthProvider>(context, listen: false);
          authProvider.updatePlayerStats(
            money: newBalance,
          );
          
          // Reload to get updated jail time
          await _loadCurrentSentence();
        } else {
          // Money still deducted on failure
          final authProvider = Provider.of<AuthProvider>(context, listen: false);
          authProvider.updatePlayerStats(
            money: newBalance,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        showTopRightFromSnackBar(context, 
          SnackBar(
            content: Text('${_tr('Fout', 'Error')}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  Future<void> _bribeJudge() async {
    if (_currentSentence == null) return;

    // Show bribe amount selector
    int bribeAmount = 50000;
    final confirmed = await showDialog<int>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('💰 ${AppLocalizations.of(context)!.bribeJudge}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bied geld aan om je zaak te laten vallen.',
                style: TextStyle(fontSize: 16, color: Colors.grey[800]),
              ),
              const SizedBox(height: 16),
              Text(
                'Rechter: ${_currentSentence!.judge.name}',
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
              Text(
                'Corruptibiliteit: ${_currentSentence!.judge.corruptibility}%',
                style: TextStyle(
                  fontSize: 14,
                  color: _currentSentence!.judge.corruptibilityColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Omkoopsom: €${bribeAmount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Slider(
                value: bribeAmount.toDouble(),
                min: 50000,
                max: 200000,
                divisions: 30,
                label: '€${bribeAmount ~/ 1000}k',
                onChanged: (value) {
                  setDialogState(() {
                    bribeAmount = value.toInt();
                  });
                },
              ),
              const SizedBox(height: 8),
              Text(
                _getSuccessChanceText(bribeAmount),
                style: TextStyle(
                  fontSize: 13,
                  color: _getSuccessChanceColor(bribeAmount),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, bribeAmount),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: Text(AppLocalizations.of(context)!.bribe),
            ),
          ],
        ),
      ),
    );

    if (confirmed == null) return;

    setState(() => _isProcessing = true);

    try {
      final response = await _apiClient.post(
        '/trial/bribe',
        {
          'crimeAttemptId': _currentSentence!.crimeAttemptId,
          'amount': confirmed,
        },
      );

      final data = jsonDecode(response.body);
      final success = data['success'] as bool? ?? false;

      if (mounted) {
        showTopRightFromSnackBar(context, 
          SnackBar(
            content: Text(
              success
                  ? '✅ Rechter omgekocht! Zaak geseponeerd'
                  : '❌ Rechter weigerde de omkoopsom',
            ),
            backgroundColor: success ? Colors.green : Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );

        if (success) {
          // Update player stats
          final authProvider = Provider.of<AuthProvider>(context, listen: false);
          authProvider.updatePlayerStats(
            money: data['newBalance'] as int?,
          );
          
          // Return to dashboard
          Navigator.pop(context);
        } else {
          // Money still deducted even on failure
          final authProvider = Provider.of<AuthProvider>(context, listen: false);
          authProvider.updatePlayerStats(
            money: data['newBalance'] as int?,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        showTopRightFromSnackBar(context, 
          SnackBar(
            content: Text('${_tr('Fout', 'Error')}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  String _getSuccessChanceText(int bribeAmount) {
    if (_currentSentence == null) return '';
    
    final baseChance = _currentSentence!.judge.corruptibility;
    final bribeBonus = ((bribeAmount - 50000) / 150000 * 40).toInt();
    final totalChance = (baseChance + bribeBonus).clamp(0, 90);
    
    return _tr('Slagingskans: ~$totalChance%', 'Success chance: ~$totalChance%');
  }

  Color _getSuccessChanceColor(int bribeAmount) {
    if (_currentSentence == null) return Colors.grey;
    
    final baseChance = _currentSentence!.judge.corruptibility;
    final bribeBonus = ((bribeAmount - 50000) / 150000 * 40).toInt();
    final totalChance = (baseChance + bribeBonus).clamp(0, 90);
    
    if (totalChance < 40) return Colors.red;
    if (totalChance < 70) return Colors.orange;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('⚖️ ${AppLocalizations.of(context)!.court}'),
        backgroundColor: Colors.brown[700],
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.gavel,
                size: 100,
                color: Colors.brown[300],
              ),
              const SizedBox(height: 24),
              Text(
                'Rechtbank Systeem',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Binnenkort beschikbaar',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info, color: Colors.blue[700], size: 20),
                        const SizedBox(width: 8),
                        const Text(
                          'Geplande Features',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '• Hoger beroep indienen tegen je veroordeling\n'
                      '• Rechters omkopen voor strafvermindering\n'
                      '• Bekijk je criminele geschiedenis\n'
                      '• Verlaag je straf met slimme advocaten',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
