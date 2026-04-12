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
  static const String _backgroundAsset = 'images/backgrounds/courtroom_background.png';
  static const String _backgroundAssetMobile = 'images/backgrounds/courtroom_background_mobile.png';

  final ApiClient _apiClient = ApiClient();

  bool _isLoading = true;
  bool _sentenceFailed = false;
  bool _recordFailed = false;
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
      _sentenceFailed = false;
      _recordFailed = false;
    });

    JailSentence? sentence;
    int totalConvictions = 0;
    List<Map<String, dynamic>> recentCrimes = [];

    try {
      final response = await _apiClient.get('/trial/current-sentence');
      final sentenceData = jsonDecode(response.body) as Map<String, dynamic>;
      final sentenceJson = sentenceData['sentence'] as Map<String, dynamic>?;
      sentence = sentenceJson == null ? null : JailSentence.fromJson(sentenceJson);
    } catch (e) {
      _sentenceFailed = true;
      debugPrint('[CourtScreen] Failed loading /trial/current-sentence: $e');
    }

    try {
      final response = await _apiClient.get('/trial/record');
      final recordData = jsonDecode(response.body) as Map<String, dynamic>;
      final recordParams = (recordData['params'] as Map<String, dynamic>?) ?? {};
      final recentCrimesRaw = (recordParams['recentCrimes'] as List?) ?? const [];

      totalConvictions = (recordParams['totalConvictions'] as num?)?.toInt() ?? 0;
      recentCrimes = recentCrimesRaw.whereType<Map<String, dynamic>>().toList();
    } catch (e) {
      _recordFailed = true;
      debugPrint('[CourtScreen] Failed loading /trial/record: $e');
    }

    setState(() {
      _currentSentence = sentence;
      _totalConvictions = totalConvictions;
      _recentCrimes = recentCrimes;
      _isLoading = false;

      if (_sentenceFailed && _recordFailed) {
        _error = _tr(
          'Kon rechtbankgegevens niet laden. Probeer opnieuw.',
          'Could not load court data. Please try again.',
        );
      }
    });
  }

  int _calculateAppealCost(int sentenceMinutes) {
    final rawCost = sentenceMinutes * 100;
    if (rawCost < 2000) return 2000;
    if (rawCost > 50000) return 50000;
    return rawCost;
  }

  Future<void> _appealSentence() async {
    if (_currentSentence == null) return;

    final appealCost = _calculateAppealCost(_currentSentence!.sentenceMinutes);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_tr('Weet je het zeker?', 'Are you sure?')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.appeal,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              _tr(
                'Wil je hoger beroep indienen voor deze veroordeling?',
                'Do you want to submit an appeal for this conviction?',
              ),
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            Text(
              _tr(
                'Kosten: €${_formatMoney(appealCost)}',
                'Cost: €${_formatMoney(appealCost)}',
              ),
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _tr('Rechter: ${_currentSentence!.judge.name}', 'Judge: ${_currentSentence!.judge.name}'),
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
            Text(
              _tr(
                'Corruptibiliteit: ${_currentSentence!.judge.corruptibility}%',
                'Corruptibility: ${_currentSentence!.judge.corruptibility}%',
              ),
              style: TextStyle(
                fontSize: 14,
                color: _currentSentence!.judge.corruptibilityColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _tr(
                'Bij succes: ongeveer 20-40% strafvermindering',
                'On success: roughly 20-40% sentence reduction',
              ),
              style: const TextStyle(
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
              backgroundColor: const Color(0xFF2A4E7F),
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

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final params = data['params'] as Map<String, dynamic>? ?? data;
      final success = params['success'] as bool? ?? false;
      final newSentence = params['newSentence'] as int?;
      final newBalance = params['newBalance'] as int?;

      if (mounted) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(
              success
                  ? _tr(
                      'Hoger beroep geslaagd. Nieuwe straf: $newSentence minuten.',
                      'Appeal granted. New sentence: $newSentence minutes.',
                    )
                  : _tr('Hoger beroep afgewezen.', 'Appeal denied.'),
            ),
            backgroundColor: success ? Colors.green : Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );

        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        authProvider.updatePlayerStats(money: newBalance);

        if (success) {
          await _loadCourtData();
        }
      }
    } catch (e) {
      if (mounted) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text('${_tr('Fout', 'Error')}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  Future<void> _bribeJudge() async {
    if (_currentSentence == null) return;

    int bribeAmount = 50000;
    final confirmed = await showDialog<int>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(AppLocalizations.of(context)!.bribeJudge),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _tr(
                  'Bied een bedrag aan. Het bedrag wordt altijd afgeschreven, ook bij mislukking.',
                  'Offer an amount. The amount is always deducted, even on failure.',
                ),
                style: TextStyle(fontSize: 15, color: Colors.grey[800]),
              ),
              const SizedBox(height: 12),
              Text(
                _tr('Rechter: ${_currentSentence!.judge.name}', 'Judge: ${_currentSentence!.judge.name}'),
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
              Text(
                _tr(
                  'Corruptibiliteit: ${_currentSentence!.judge.corruptibility}%',
                  'Corruptibility: ${_currentSentence!.judge.corruptibility}%',
                ),
                style: TextStyle(
                  fontSize: 14,
                  color: _currentSentence!.judge.corruptibilityColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _tr('Omkoopsom: €${_formatMoney(bribeAmount)}', 'Bribe amount: €${_formatMoney(bribeAmount)}'),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
              child: Text(_tr('Annuleren', 'Cancel')),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, bribeAmount),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8A2121),
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

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final success = data['success'] as bool? ?? false;

      if (mounted) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(
              success
                  ? _tr('Rechter omgekocht. Je bent direct vrij.', 'Judge bribed. You are released immediately.')
                  : _tr('Omkoping mislukt. Bedrag is wel afgeschreven.', 'Bribe failed. Amount was still deducted.'),
            ),
            backgroundColor: success ? Colors.green : Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );

        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        authProvider.updatePlayerStats(money: data['newBalance'] as int?);

        if (success) {
          await _loadCourtData();
        }
      }
    } catch (e) {
      if (mounted) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text('${_tr('Fout', 'Error')}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  String _getSuccessChanceText(int bribeAmount) {
    if (_currentSentence == null) return '';

    final baseChance = _currentSentence!.judge.corruptibility;
    final bribeBonus = ((bribeAmount - 50000) / 150000 * 40).toInt();
    final totalChance = (baseChance + bribeBonus).clamp(0, 90);

    return _tr('Geschatte slagingskans: ~$totalChance%', 'Estimated success chance: ~$totalChance%');
  }

  Color _getSuccessChanceColor(int bribeAmount) {
    if (_currentSentence == null) return Colors.grey;

    final baseChance = _currentSentence!.judge.corruptibility;
    final bribeBonus = ((bribeAmount - 50000) / 150000 * 40).toInt();
    final totalChance = (baseChance + bribeBonus).clamp(0, 90);

    if (totalChance < 40) return Colors.red.shade400;
    if (totalChance < 70) return Colors.orange.shade300;
    return Colors.green.shade300;
  }

  String _formatMoney(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
  }

  Widget _buildLoadWarning() {
    if (!_sentenceFailed && !_recordFailed) {
      return const SizedBox.shrink();
    }

    final warning = _tr(
      'Let op: een deel van de rechtbankdata kon niet laden. Vernieuw om opnieuw te proberen.',
      'Heads up: part of the court data could not be loaded. Pull to refresh to retry.',
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF53360E).withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD1A857).withValues(alpha: 0.6)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.warning_amber_rounded, color: Color(0xFFFFD27A)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              warning,
              style: const TextStyle(color: Colors.white, fontSize: 13.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPanel({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF141923).withValues(alpha: 0.84),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFB8894E).withValues(alpha: 0.55)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x80000000),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildCurrentSentenceCard() {
    if (_currentSentence == null) {
      return _buildPanel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _tr('Geen actieve straf', 'No active sentence'),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF83DFA4),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _tr(
                'Je zit momenteel niet vast. Je strafblad blijft hieronder zichtbaar.',
                'You are currently not jailed. Your criminal record remains visible below.',
              ),
              style: TextStyle(color: Colors.grey[200]),
            ),
          ],
        ),
      );
    }

    final appealCost = _calculateAppealCost(_currentSentence!.sentenceMinutes);

    return _buildPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.gavel, color: Color(0xFFD7B378)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _tr('Actieve veroordeling', 'Active sentence'),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '${_tr('Delict', 'Crime')}: ${_currentSentence!.crime}',
            style: TextStyle(color: Colors.grey[100]),
          ),
          Text(
            '${_tr('Totale straf', 'Total sentence')}: ${_currentSentence!.sentenceMinutes} ${_tr('minuten', 'minutes')}',
            style: TextStyle(color: Colors.grey[100]),
          ),
          Text(
            '${_tr('Resterend', 'Remaining')}: ${_currentSentence!.remainingMinutes} ${_tr('minuten', 'minutes')}',
            style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFFFFD27A)),
          ),
          const SizedBox(height: 8),
          Text(
            '${_tr('Rechter', 'Judge')}: ${_currentSentence!.judge.name}',
            style: TextStyle(color: Colors.grey[100]),
          ),
          Text(
            '${_tr('Corruptibiliteit', 'Corruptibility')}: ${_currentSentence!.judge.corruptibility}%',
            style: TextStyle(
              color: _currentSentence!.judge.corruptibilityColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _tr('Beroepskosten nu: €${_formatMoney(appealCost)}', 'Current appeal cost: €${_formatMoney(appealCost)}'),
            style: TextStyle(color: Colors.grey[300], fontSize: 13),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              ElevatedButton.icon(
                onPressed: _isProcessing ? null : _appealSentence,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2A4E7F),
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.rule),
                label: Text(_tr('Hoger beroep', 'Appeal')),
              ),
              ElevatedButton.icon(
                onPressed: _isProcessing ? null : _bribeJudge,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8A2121),
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

  Widget _buildRecordItem(Map<String, dynamic> crime) {
    final crimeName = crime['crimeName'] as String? ?? (crime['crimeId'] as String? ?? _tr('Onbekend', 'Unknown'));
    final jailTime = (crime['jailTime'] as num?)?.toInt() ?? 0;
    final appealed = crime['appealed'] as bool? ?? false;
    final createdAtRaw = crime['createdAt'] as String?;
    final createdAt = createdAtRaw == null ? null : DateTime.tryParse(createdAtRaw)?.toLocal();

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF111723).withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF32506C).withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            crimeName,
            style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
          ),
          Text(
            '${_tr('Straf', 'Sentence')}: $jailTime ${_tr('minuten', 'minutes')}',
            style: TextStyle(color: Colors.grey[200]),
          ),
          if (createdAt != null)
            Text(
              '${_tr('Datum', 'Date')}: ${createdAt.day.toString().padLeft(2, '0')}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.year} ${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}',
              style: TextStyle(fontSize: 12, color: Colors.grey[400]),
            ),
          if (appealed)
            Text(
              _tr('Beroep ingediend', 'Appeal submitted'),
              style: const TextStyle(fontSize: 12, color: Color(0xFF8AB4F8)),
            ),
        ],
      ),
    );
  }

  Widget _buildRecordCard() {
    return _buildPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _tr('Strafblad', 'Criminal record'),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _tr(
              'Totaal aantal veroordelingen: $_totalConvictions',
              'Total convictions: $_totalConvictions',
            ),
            style: TextStyle(color: Colors.grey[100]),
          ),
          const SizedBox(height: 12),
          if (_recentCrimes.isEmpty)
            Text(
              _tr('Nog geen veroordelingen geregistreerd.', 'No convictions recorded yet.'),
              style: TextStyle(color: Colors.grey[300]),
            )
          else
            ..._recentCrimes.take(8).map(_buildRecordItem),
        ],
      ),
    );
  }

  Widget _buildBackgroundLayer() {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    final preferredAsset = isPortrait ? _backgroundAssetMobile : _backgroundAsset;
    final fallbackAsset = isPortrait ? _backgroundAsset : _backgroundAssetMobile;

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          preferredAsset,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Image.asset(
              fallbackAsset,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF283445),
                        Color(0xFF161D27),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFF0B111C).withValues(alpha: 0.28),
                const Color(0xFF0B111C).withValues(alpha: 0.62),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.court),
        backgroundColor: const Color(0xFF2E2A24),
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          _buildBackgroundLayer(),
          RefreshIndicator(
            onRefresh: _loadCourtData,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              children: [
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 860),
                    child: _isLoading
                        ? const Padding(
                            padding: EdgeInsets.only(top: 120),
                            child: Center(child: CircularProgressIndicator()),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (_error != null)
                                Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF601D1D).withValues(alpha: 0.82),
                                    border: Border.all(
                                      color: const Color(0xFFE58B8B).withValues(alpha: 0.6),
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    _error!,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                )
                              else ...[
                                _buildLoadWarning(),
                                _buildCurrentSentenceCard(),
                                const SizedBox(height: 12),
                                _buildRecordCard(),
                              ],
                            ],
                          ),
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
