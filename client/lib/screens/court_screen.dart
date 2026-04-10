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
  int _totalConvictions = 0;
  List<Map<String, dynamic>> _recentCrimes = [];
  String? _error;
  bool _isProcessing = false;

  bool get _isNl => Localizations.localeOf(context).languageCode == 'nl';
  String _tr(String nl, String en) => _isNl ? nl : en;

  @override
  void initState() {
    super.initState();
    _loadCourtData();
  }

  Future<void> _loadCourtData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final responses = await Future.wait([
        _apiClient.get('/trial/current-sentence'),
        _apiClient.get('/trial/record'),
      ]);

      final sentenceData = jsonDecode(responses[0].body) as Map<String, dynamic>;
      final recordData = jsonDecode(responses[1].body) as Map<String, dynamic>;
      final recordParams = (recordData['params'] as Map<String, dynamic>?) ?? {};

      final sentenceJson = sentenceData['sentence'] as Map<String, dynamic>?;
      final sentence = sentenceJson == null ? null : JailSentence.fromJson(sentenceJson);
      final recentCrimesRaw = (recordParams['recentCrimes'] as List?) ?? const [];

      setState(() {
        _currentSentence = sentence;
        _totalConvictions = (recordParams['totalConvictions'] as num?)?.toInt() ?? 0;
        _recentCrimes = recentCrimesRaw
            .whereType<Map<String, dynamic>>()
            .toList();
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
          await _loadCourtData();
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
                'Omkoopsom: €${_formatMoney(bribeAmount)}',
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
          
          await _loadCourtData();
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

  String _formatMoney(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
  }

  Widget _buildCurrentSentenceCard() {
    if (_currentSentence == null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.green[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.green[200]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _tr('Geen actieve straf', 'No active sentence'),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.green[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _tr(
                'Je zit momenteel niet vast. Bekijk hieronder je strafblad.',
                'You are not jailed right now. Review your criminal record below.',
              ),
              style: TextStyle(color: Colors.grey[700]),
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.gavel, color: Colors.orange[800]),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _tr('Actieve veroordeling', 'Active sentence'),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[900],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text('${_tr('Delict', 'Crime')}: ${_currentSentence!.crime}'),
          Text('${_tr('Totale straf', 'Total sentence')}: ${_currentSentence!.sentenceMinutes} ${_tr('minuten', 'minutes')}'),
          Text(
            '${_tr('Resterend', 'Remaining')}: ${_currentSentence!.remainingMinutes} ${_tr('minuten', 'minutes')}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text('${_tr('Rechter', 'Judge')}: ${_currentSentence!.judge.name}'),
          Text(
            '${_tr('Corruptibiliteit', 'Corruptibility')}: ${_currentSentence!.judge.corruptibility}%',
            style: TextStyle(color: _currentSentence!.judge.corruptibilityColor),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              ElevatedButton.icon(
                onPressed: _isProcessing ? null : _appealSentence,
                icon: const Icon(Icons.rule),
                label: Text(_tr('Hoger beroep', 'Appeal')),
              ),
              ElevatedButton.icon(
                onPressed: _isProcessing ? null : _bribeJudge,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.payments),
                label: Text(_tr('Rechter omkopen', 'Bribe judge')),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecordCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blueGrey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blueGrey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _tr('Strafblad', 'Criminal record'),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey[900],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _tr('Totaal aantal veroordelingen: $_totalConvictions', 'Total convictions: $_totalConvictions'),
          ),
          const SizedBox(height: 12),
          if (_recentCrimes.isEmpty)
            Text(
              _tr('Nog geen veroordelingen geregistreerd.', 'No convictions recorded yet.'),
              style: TextStyle(color: Colors.grey[700]),
            )
          else
            ..._recentCrimes.take(8).map((crime) {
              final crimeName = crime['crimeName'] as String? ?? (crime['crimeId'] as String? ?? 'Onbekend');
              final jailTime = (crime['jailTime'] as num?)?.toInt() ?? 0;
              final appealed = crime['appealed'] as bool? ?? false;
              final createdAtRaw = crime['createdAt'] as String?;
              final createdAt = createdAtRaw == null ? null : DateTime.tryParse(createdAtRaw)?.toLocal();

              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blueGrey[100]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(crimeName, style: const TextStyle(fontWeight: FontWeight.w600)),
                    Text('${_tr('Straf', 'Sentence')}: $jailTime ${_tr('minuten', 'minutes')}'),
                    if (createdAt != null)
                      Text(
                        '${_tr('Datum', 'Date')}: ${createdAt.day.toString().padLeft(2, '0')}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.year} ${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                      ),
                    if (appealed)
                      Text(
                        _tr('Beroep ingediend', 'Appeal submitted'),
                        style: const TextStyle(fontSize: 12, color: Colors.blue),
                      ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('⚖️ ${AppLocalizations.of(context)!.court}'),
        backgroundColor: Colors.brown[700],
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: _loadCourtData,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          children: [
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.only(top: 120),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_error != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  border: Border.all(color: Colors.red[200]!),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(_error!, style: TextStyle(color: Colors.red[700])),
              )
            else ...[
              _buildCurrentSentenceCard(),
              const SizedBox(height: 12),
              _buildRecordCard(),
            ],
          ],
        ),
      ),
    );
  }
}
