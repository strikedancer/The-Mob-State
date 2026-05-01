import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/judge.dart';
import '../providers/auth_provider.dart';
import '../services/api_client.dart';
import '../l10n/app_localizations.dart';
import '../utils/top_right_notification.dart';
import '../utils/formatters.dart';

class CourtScreen extends StatefulWidget {
  const CourtScreen({super.key});

  @override
  State<CourtScreen> createState() => _CourtScreenState();
}

class _CourtScreenState extends State<CourtScreen> {
  static const String _backgroundAsset =
      'assets/images/backgrounds/courtroom_background.png';
  static const String _backgroundAssetMobile =
      'assets/images/backgrounds/courtroom_background_mobile.png';

  final ApiClient _apiClient = ApiClient();

  bool _isLoading = true;
  bool _sentenceFailed = false;
  bool _recordFailed = false;
  JailSentence? _currentSentence;
  int _totalConvictions = 0;
  List<Map<String, dynamic>> _recentCrimes = [];
  String? _error;
  bool _isProcessing = false;

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
      sentence = sentenceJson == null
          ? null
          : JailSentence.fromJson(sentenceJson);
    } catch (e) {
      _sentenceFailed = true;
      debugPrint('[CourtScreen] Failed loading /trial/current-sentence: $e');
    }

    try {
      final response = await _apiClient.get('/trial/record');
      final recordData = jsonDecode(response.body) as Map<String, dynamic>;
      final recordParams =
          (recordData['params'] as Map<String, dynamic>?) ?? {};
      final recentCrimesRaw =
          (recordParams['recentCrimes'] as List?) ?? const [];

      totalConvictions =
          (recordParams['totalConvictions'] as num?)?.toInt() ?? 0;
      recentCrimes = recentCrimesRaw.whereType<Map<String, dynamic>>().toList();
    } catch (e) {
      _recordFailed = true;
      debugPrint('[CourtScreen] Failed loading /trial/record: $e');
    }

    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;

    setState(() {
      _currentSentence = sentence;
      _totalConvictions = totalConvictions;
      _recentCrimes = recentCrimes;
      _isLoading = false;

      if (_sentenceFailed && _recordFailed) {
        _error = l10n.courtLoadFailed;
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
    final l10nRoot = AppLocalizations.of(context)!;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return AlertDialog(
          title: Text(l10n.confirmAction),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.appeal,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.courtAppealDialogIntro,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.courtCostLine(formatCurrency(appealCost)),
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.courtJudgeNamed(_currentSentence!.judge.name),
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
              Text(
                l10n.courtCorruptibilityPercent(
                  _currentSentence!.judge.corruptibility.toString(),
                ),
                style: TextStyle(
                  fontSize: 14,
                  color: _currentSentence!.judge.corruptibilityColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.courtAppealSuccessHint,
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
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2A4E7F),
                foregroundColor: Colors.white,
              ),
              child: Text(l10n.submitAppeal),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    setState(() => _isProcessing = true);

    try {
      final response = await _apiClient.post('/trial/appeal', {
        'crimeAttemptId': _currentSentence!.crimeAttemptId,
      });

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
                  ? l10nRoot.courtAppealGrantedMinutes(
                      '${newSentence ?? 0}',
                    )
                  : l10nRoot.courtAppealDenied,
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
            content: Text(l10nRoot.hitError(e.toString())),
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
    final l10nRoot = AppLocalizations.of(context)!;

    final confirmed = await showDialog<int>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          final l10n = AppLocalizations.of(context)!;
          return AlertDialog(
            title: Text(l10n.bribeJudge),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.courtBribeOfferIntro,
                  style: TextStyle(fontSize: 15, color: Colors.grey[800]),
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.courtJudgeNamed(_currentSentence!.judge.name),
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
                Text(
                  l10n.courtCorruptibilityPercent(
                    _currentSentence!.judge.corruptibility.toString(),
                  ),
                  style: TextStyle(
                    fontSize: 14,
                    color: _currentSentence!.judge.corruptibilityColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.courtBribeAmountFormatted(formatCurrency(bribeAmount)),
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
                  label: l10n.courtBribeSliderLabel('${bribeAmount ~/ 1000}'),
                  onChanged: (value) {
                    setDialogState(() {
                      bribeAmount = value.toInt();
                    });
                  },
                ),
                const SizedBox(height: 8),
                Text(
                  _getSuccessChanceText(bribeAmount, l10n),
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
                child: Text(l10n.cancel),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, bribeAmount),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8A2121),
                  foregroundColor: Colors.white,
                ),
                child: Text(l10n.bribe),
              ),
            ],
          );
        },
      ),
    );

    if (confirmed == null) return;

    setState(() => _isProcessing = true);

    try {
      final response = await _apiClient.post('/trial/bribe', {
        'crimeAttemptId': _currentSentence!.crimeAttemptId,
        'amount': confirmed,
      });

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final success = data['success'] as bool? ?? false;

      if (mounted) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(
              success
                  ? l10nRoot.courtBribeSuccessReleased
                  : l10nRoot.courtBribeFailedDebited,
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
            content: Text(l10nRoot.hitError(e.toString())),
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

  String _getSuccessChanceText(int bribeAmount, AppLocalizations l10n) {
    if (_currentSentence == null) return '';

    final baseChance = _currentSentence!.judge.corruptibility;
    final bribeBonus = ((bribeAmount - 50000) / 150000 * 40).toInt();
    final totalChance = (baseChance + bribeBonus).clamp(0, 90);

    return l10n.courtEstimatedSuccessChance(totalChance.toString());
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

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String _recordStatusLabel(String status, AppLocalizations l10n) {
    switch (status) {
      case 'active':
        return l10n.courtRecordActive;
      default:
        return l10n.courtRecordServed;
    }
  }

  Color _recordStatusColor(String status) {
    switch (status) {
      case 'active':
        return const Color(0xFFE6B85C);
      default:
        return const Color(0xFF72C48F);
    }
  }

  Color _historyColor(String type) {
    switch (type) {
      case 'appeal_granted':
        return const Color(0xFF8AB4F8);
      case 'appeal_denied':
        return const Color(0xFFE5967A);
      case 'bribe_failed':
        return const Color(0xFFD98989);
      default:
        return const Color(0xFFB9C4D6);
    }
  }

  String _historyLabel(Map<String, dynamic> entry, AppLocalizations l10n) {
    final type = entry['type'] as String? ?? 'conviction';
    final originalSentence = (entry['originalSentence'] as num?)?.toInt();
    final newSentence = (entry['newSentence'] as num?)?.toInt();
    final amount = (entry['amount'] as num?)?.toInt();

    switch (type) {
      case 'appeal_granted':
        return l10n.courtHistoryAppealGranted(
          '${originalSentence ?? 0}',
          '${newSentence ?? 0}',
        );
      case 'appeal_denied':
        return l10n.courtHistoryAppealDenied('${originalSentence ?? 0}');
      case 'bribe_failed':
        return l10n.courtHistoryBribeFailedPaid(
          formatCurrency(amount ?? 0),
        );
      default:
        return l10n.courtHistoryConvictedMinutes('${originalSentence ?? 0}');
    }
  }

  Widget _buildHistoryEntry(Map<String, dynamic> entry, AppLocalizations l10n) {
    final type = entry['type'] as String? ?? 'conviction';
    final createdAtRaw = entry['createdAt'] as String?;
    final createdAt = createdAtRaw == null
        ? null
        : DateTime.tryParse(createdAtRaw)?.toLocal();

    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 4),
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: _historyColor(type),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _historyLabel(entry, l10n),
                  style: const TextStyle(fontSize: 12.5, color: Colors.white),
                ),
                if (createdAt != null)
                  Text(
                    l10n.courtDateLabeled(_formatDateTime(createdAt)),
                    style: TextStyle(fontSize: 11.5, color: Colors.grey[500]),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadWarning(AppLocalizations l10n) {
    if (!_sentenceFailed && !_recordFailed) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF53360E).withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFD1A857).withValues(alpha: 0.6),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.warning_amber_rounded, color: Color(0xFFFFD27A)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              l10n.courtPartialLoadWarning,
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
        border: Border.all(
          color: const Color(0xFFB8894E).withValues(alpha: 0.55),
        ),
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

  Widget _buildCurrentSentenceCard(AppLocalizations l10n) {
    if (_currentSentence == null) {
      return _buildPanel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.courtNoActiveSentence,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF83DFA4),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.courtNotJailedHint,
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
                  l10n.courtActiveSentenceTitle,
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
            '${l10n.courtDelictLabel}: ${_currentSentence!.crime}',
            style: TextStyle(color: Colors.grey[100]),
          ),
          Text(
            l10n.courtTotalSentenceMinutes(
              _currentSentence!.sentenceMinutes.toString(),
            ),
            style: TextStyle(color: Colors.grey[100]),
          ),
          Text(
            l10n.courtRemainingMinutes(
              _currentSentence!.remainingMinutes.toString(),
            ),
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: Color(0xFFFFD27A),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.courtJudgeNamed(_currentSentence!.judge.name),
            style: TextStyle(color: Colors.grey[100]),
          ),
          Text(
            l10n.courtCorruptibilityPercent(
              _currentSentence!.judge.corruptibility.toString(),
            ),
            style: TextStyle(
              color: _currentSentence!.judge.corruptibilityColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.courtAppealCostCurrent(formatCurrency(appealCost)),
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
                label: Text(l10n.courtButtonAppeal),
              ),
              ElevatedButton.icon(
                onPressed: _isProcessing ? null : _bribeJudge,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8A2121),
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.payments),
                label: Text(l10n.courtButtonBribeJudge),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecordItem(Map<String, dynamic> crime, AppLocalizations l10n) {
    final crimeName =
        crime['crimeName'] as String? ??
        (crime['crimeId'] as String? ?? l10n.courtUnknownCrime);
    final jailTime = (crime['jailTime'] as num?)?.toInt() ?? 0;
    final originalJailTime =
        (crime['originalJailTime'] as num?)?.toInt() ?? jailTime;
    final appealed = crime['appealed'] as bool? ?? false;
    final status = crime['status'] as String? ?? 'served';
    final createdAtRaw = crime['createdAt'] as String?;
    final createdAt = createdAtRaw == null
        ? null
        : DateTime.tryParse(createdAtRaw)?.toLocal();
    final history = ((crime['history'] as List?) ?? const [])
        .whereType<Map<String, dynamic>>()
        .toList();

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF111723).withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFF32506C).withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  crimeName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _recordStatusColor(status).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: _recordStatusColor(status).withValues(alpha: 0.45),
                  ),
                ),
                child: Text(
                  _recordStatusLabel(status, l10n),
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: _recordStatusColor(status),
                  ),
                ),
              ),
            ],
          ),
          Text(
            originalJailTime == jailTime
                ? l10n.courtSentenceMinutesOnly(jailTime.toString())
                : l10n.courtSentenceReducedMinutes(
                    originalJailTime.toString(),
                    jailTime.toString(),
                  ),
            style: TextStyle(color: Colors.grey[200]),
          ),
          if (createdAt != null)
            Text(
              l10n.courtDateLabeled(_formatDateTime(createdAt)),
              style: TextStyle(fontSize: 12, color: Colors.grey[400]),
            ),
          if (history.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              l10n.courtHistoryHeading,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Colors.grey[300],
              ),
            ),
            ...history.map((e) => _buildHistoryEntry(e, l10n)),
          ] else if (appealed)
            Text(
              l10n.courtAppealSubmitted,
              style: const TextStyle(fontSize: 12, color: Color(0xFF8AB4F8)),
            ),
        ],
      ),
    );
  }

  Widget _buildRecordCard(AppLocalizations l10n) {
    return _buildPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.courtCriminalRecordTitle,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.courtTotalConvictions(_totalConvictions.toString()),
            style: TextStyle(color: Colors.grey[100]),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.courtRecordBribeNote,
            style: TextStyle(fontSize: 12.5, color: Colors.grey[400]),
          ),
          const SizedBox(height: 12),
          if (_recentCrimes.isEmpty)
            Text(
              l10n.courtNoConvictionsYet,
              style: TextStyle(color: Colors.grey[300]),
            )
          else
            ..._recentCrimes.take(8).map((c) => _buildRecordItem(c, l10n)),
        ],
      ),
    );
  }

  Widget _buildBackgroundLayer() {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final preferredAsset = isPortrait
        ? _backgroundAssetMobile
        : _backgroundAsset;
    final fallbackAsset = isPortrait
        ? _backgroundAsset
        : _backgroundAssetMobile;

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
                      colors: [Color(0xFF283445), Color(0xFF161D27)],
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
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.court),
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
                                    color: const Color(
                                      0xFF601D1D,
                                    ).withValues(alpha: 0.82),
                                    border: Border.all(
                                      color: const Color(
                                        0xFFE58B8B,
                                      ).withValues(alpha: 0.6),
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    _error!,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                )
                              else ...[
                                _buildLoadWarning(l10n),
                                _buildCurrentSentenceCard(l10n),
                                const SizedBox(height: 12),
                                _buildRecordCard(l10n),
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
