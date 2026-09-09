import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../l10n/app_localizations.dart';
import '../services/api_client.dart';
import '../utils/localized_api_message.dart';
import '../utils/top_right_notification.dart';
import '../widgets/game_page_info.dart';
import '../widgets/empire_page_hero.dart';

class VaultScreen extends StatefulWidget {
  final bool embedded;

  const VaultScreen({super.key, this.embedded = false});

  @override
  State<VaultScreen> createState() => _VaultScreenState();
}

class _VaultScreenState extends State<VaultScreen> {
  final _api = ApiClient();
  final _codeController = TextEditingController();
  bool _loading = false;
  bool _submitting = false;
  bool _showWrongCodes = false;
  int _stakeTier = 1;

  Map<String, dynamic>? _status;
  String? _message;
  bool _messageSuccess = false;

  void _showTopMessage(String message, {required bool success}) {
    if (!mounted) return;
    showTopRightFromSnackBar(
      context,
      SnackBar(
        content: Text(message),
        backgroundColor: success ? Colors.green : Colors.orange,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.zero,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  String? _vaultMessageFromData(Map<String, dynamic> data) =>
      localizedApiMessage(context, data);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadStatus());
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _loadStatus() async {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    if (_loading) return;
    setState(() {
      _loading = true;
      _message = null;
    });
    try {
      final res = await _api.get('/vault/status');
      final decoded = jsonDecode(res.body) as Map<String, dynamic>;
      if (decoded['success'] == true) {
        setState(() => _status = decoded['data'] as Map<String, dynamic>);
      } else {
        setState(() => _message = l10n.couldNotLoadVaultStatus);
      }
    } catch (_) {
      setState(() => _message = l10n.couldNotLoadVaultStatus);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  int _creditsBalance() {
    final player = (_status?['player'] as Map<String, dynamic>?) ?? const {};
    return (player['premiumCredits'] as num?)?.toInt() ?? 0;
  }

  List<dynamic> _tiers() {
    return (_status?['tiers'] as List<dynamic>?) ?? const [];
  }

  List<String> _wrongCodes() {
    final player = (_status?['player'] as Map<String, dynamic>?) ?? const {};
    final raw = (player['wrongGuesses'] as List<dynamic>?) ?? const [];
    return raw.map((e) => e.toString()).where((e) => e.trim().isNotEmpty).toList();
  }

  String _seasonWindowLabel(BuildContext context) {
    final startsAtRaw = _status?['startsAt'];
    final endsAtRaw = _status?['endsAt'];
    if (startsAtRaw == null || endsAtRaw == null) return '';

    final startsAt = DateTime.tryParse(startsAtRaw.toString());
    final endsAt = DateTime.tryParse(endsAtRaw.toString());
    if (startsAt == null || endsAt == null) return '';

    final loc = Localizations.localeOf(context);
    final locStr = loc.countryCode != null && loc.countryCode!.isNotEmpty
        ? '${loc.languageCode}_${loc.countryCode}'
        : loc.languageCode;
    final fmt = DateFormat('d MMM', locStr);
    return '${fmt.format(startsAt)} – ${fmt.format(endsAt)}';
  }

  int _rewardForStake(int stake) {
    for (final t in _tiers()) {
      if ((t as Map<String, dynamic>)['stake'] == stake) {
        return ((t)['rewardCredits'] as num?)?.toInt() ?? 0;
      }
    }
    if (stake == 1) return 500;
    if (stake == 3) return 1500;
    if (stake == 5) return 2500;
    return 0;
  }

  Future<void> _submit() async {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    if (_submitting) return;
    final code = _codeController.text.trim();
    if (!RegExp(r'^\d{4}$').hasMatch(code)) {
      final msg = l10n.vaultEnterFourDigitCode;
      _showTopMessage(
        msg,
        success: false,
      );
      setState(() {
        _message = msg;
        _messageSuccess = false;
      });
      return;
    }

    setState(() {
      _submitting = true;
      _message = null;
    });

    try {
      final res = await _api.post('/vault/attempt', {'guess': code, 'stakeTier': _stakeTier});
      final decoded = jsonDecode(res.body) as Map<String, dynamic>;
      if (decoded['success'] == true) {
        final data = decoded['data'] as Map<String, dynamic>;
        final isSuccess = data['correct'] == true;
        final fromApi = _vaultMessageFromData(data);
        final text = fromApi ??
            (isSuccess ? l10n.vaultAttemptSuccessGeneric : l10n.vaultAttemptFailedGeneric);
        _showTopMessage(text, success: isSuccess);
        setState(() {
          _message = text;
          _messageSuccess = isSuccess;
        });
        await _loadStatus();
      } else {
        final event = decoded['event']?.toString();
        final params = (decoded['params'] as Map<String, dynamic>?) ?? const {};
        final String text;
        if (event == 'error.insufficient_credits') {
          text = l10n.crewUiTr19;
        } else {
          final fromApi = _vaultMessageFromData(params);
          text = fromApi ?? l10n.vaultAttemptFailedGeneric;
        }
        _showTopMessage(text, success: false);
        setState(() {
          _message = text;
          _messageSuccess = false;
        });
      }
    } catch (_) {
      _showTopMessage(
        l10n.vaultAttemptFailedRetry,
        success: false,
      );
      setState(() {
        _message = l10n.vaultAttemptFailedRetry;
        _messageSuccess = false;
      });
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GamePageInfoHost(
      topicId: 'vault',
      showOverlay: false,
      child: _buildPageInfoChild(context),
    );
  }

  Widget _buildPageInfoChild(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isSmall = MediaQuery.of(context).size.width < 700;
    final tiers = _tiers();
    final wrongCodes = _wrongCodes();
    final balance = _creditsBalance();
    final reward = _rewardForStake(_stakeTier);

    final seasonWindow = _seasonWindowLabel(context);
    final content = ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white12),
            color: Colors.black.withOpacity(0.18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.bolt, color: Color(0xFFD4AF37), size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l10n.vaultYourCredits,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                  Text(
                    '$balance',
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      color: Color(0xFFD4AF37),
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 6),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                l10n.vaultChooseStake,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: (tiers.isNotEmpty ? tiers : const [
                  {'stake': 1, 'rewardCredits': 500},
                  {'stake': 3, 'rewardCredits': 1500},
                  {'stake': 5, 'rewardCredits': 2500},
                ])
                    .map((tRaw) {
                  final t = (tRaw as Map<String, dynamic>);
                  final stake = (t['stake'] as num?)?.toInt() ?? 1;
                  final selected = _stakeTier == stake;
                  return ChoiceChip(
                    selected: selected,
                    label: Text(l10n.vaultStakeCredits(stake)),
                    onSelected: _submitting
                        ? null
                        : (_) => setState(() => _stakeTier = stake),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.vaultExpectedPrize(reward),
                style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 14),
              Text(
                l10n.vaultCodeLabel,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _codeController,
                enabled: !_submitting,
                keyboardType: TextInputType.number,
                maxLength: 4,
                decoration: InputDecoration(
                  counterText: '',
                  hintText: '0000',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.key),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _submitting ? null : _submit,
                  icon: _submitting
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.send),
                  label: Text(l10n.vaultSubmitStake),
                ),
              ),
              if (_message != null && _message!.trim().isNotEmpty) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: (_messageSuccess ? Colors.green : Colors.red).withOpacity(0.12),
                    border: Border.all(
                      color: (_messageSuccess ? Colors.greenAccent : Colors.redAccent).withOpacity(0.55),
                    ),
                  ),
                  child: Text(
                    _message!,
                    style: TextStyle(
                      color: _messageSuccess ? Colors.greenAccent : Colors.redAccent,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white12),
            color: Colors.black.withOpacity(0.18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.history, size: 18, color: Colors.white70),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l10n.vaultWrongCodesTitle,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                  TextButton(
                    onPressed: wrongCodes.isEmpty
                        ? null
                        : () => setState(() => _showWrongCodes = !_showWrongCodes),
                    child: Text(_showWrongCodes ? l10n.vaultHideWrongCodes : l10n.vaultShowWrongCodes),
                  ),
                ],
              ),
              if (wrongCodes.isEmpty)
                Text(
                  l10n.vaultNoWrongCodesYet,
                  style: const TextStyle(color: Colors.white70),
                )
              else if (_showWrongCodes) ...[
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: wrongCodes
                      .map(
                        (c) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(999),
                            color: Colors.black.withOpacity(0.25),
                            border: Border.all(color: Colors.white12),
                          ),
                          child: Text(
                            c,
                            style: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 14),
        if (_loading)
          const Center(child: CircularProgressIndicator())
        else
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: _loadStatus,
              icon: const Icon(Icons.refresh),
              label: Text(l10n.refresh),
            ),
          ),
        if (isSmall && widget.embedded) const SizedBox(height: 20),
      ],
    );

    return EmpireHubScaffold(
      embedded: widget.embedded,
      title: l10n.menuCrackVault,
      subtitle: l10n.vaultHeroTagline,
      imageAsset: 'assets/images/vault/vault_banner.png',
      topicId: 'vault',
      fallbackIcon: Icons.lock,
      onRefresh: _loadStatus,
      chips: [
        if (seasonWindow.isNotEmpty)
          EmpireStatChip(
            icon: Icons.calendar_month,
            label: l10n.vaultSeasonLabel(seasonWindow),
          ),
      ],
      body: content,
    );
  }
}
