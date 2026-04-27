import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/api_client.dart';
import '../utils/web_asset_helper.dart';
import '../utils/top_right_notification.dart';

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

  bool get _isNl => Localizations.localeOf(context).languageCode == 'nl';
  String _tr(String nl, String en) => _isNl ? nl : en;

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
        setState(() => _message = _tr('Kon status niet laden.', 'Could not load status.'));
      }
    } catch (_) {
      setState(() => _message = _tr('Kon status niet laden.', 'Could not load status.'));
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

  String _seasonWindowLabel() {
    final startsAtRaw = _status?['startsAt'];
    final endsAtRaw = _status?['endsAt'];
    if (startsAtRaw == null || endsAtRaw == null) return '';

    final startsAt = DateTime.tryParse(startsAtRaw.toString());
    final endsAt = DateTime.tryParse(endsAtRaw.toString());
    if (startsAt == null || endsAt == null) return '';

    final locale = _isNl ? 'nl_NL' : 'en_US';
    final fmt = DateFormat('d MMM', locale);
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
    if (_submitting) return;
    final code = _codeController.text.trim();
    if (!RegExp(r'^\d{4}$').hasMatch(code)) {
      _showTopMessage(
        _tr('Voer een 4-cijferige code in.', 'Enter a 4-digit code.'),
        success: false,
      );
      setState(() {
        _message = _tr('Voer een 4-cijferige code in.', 'Enter a 4-digit code.');
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
        final msg = _isNl ? (data['messageNl'] ?? '') : (data['messageEn'] ?? '');
        final text =
            msg.toString().trim().isNotEmpty ? msg.toString() : _tr('Gelukt.', 'Success.');
        final isSuccess = data['correct'] == true;
        _showTopMessage(text, success: isSuccess);
        setState(() {
          _message = text;
          _messageSuccess = isSuccess;
        });
        // Refresh status for updated balance + wrong codes
        await _loadStatus();
      } else {
        final params = (decoded['params'] as Map<String, dynamic>?) ?? const {};
        final msgNl = params['messageNl']?.toString();
        final msgEn = params['messageEn']?.toString();
        final text = _isNl
            ? (msgNl ?? _tr('Mislukt.', 'Failed.'))
            : (msgEn ?? _tr('Mislukt.', 'Failed.'));
        _showTopMessage(text, success: false);
        setState(() {
          _message = text;
          _messageSuccess = false;
        });
      }
    } catch (_) {
      _showTopMessage(
        _tr('Mislukt. Probeer opnieuw.', 'Failed. Please try again.'),
        success: false,
      );
      setState(() {
        _message = _tr('Mislukt. Probeer opnieuw.', 'Failed. Please try again.');
        _messageSuccess = false;
      });
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Widget _buildVaultHero(BuildContext context) {
    final isSmall = MediaQuery.of(context).size.width < 700;
    final height = isSmall ? 190.0 : 220.0;
    final seasonWindow = _seasonWindowLabel();

    // Prefer external image library path on web/prod (served via nginx),
    // fall back to bundled Flutter asset.
    final externalBannerUrl = Uri.base.resolve('/client/images/vault/vault_banner.png').toString();

    Widget banner() {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.network(
          externalBannerUrl,
          width: double.infinity,
          height: height,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return WebAssetHelper.image(
              'assets/images/vault/vault_banner.png',
              width: double.infinity,
              height: height,
              fit: BoxFit.cover,
              errorBuilder: (ctx, err, st) {
                return Container(
                  width: double.infinity,
                  height: height,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF0F0F12).withOpacity(0.94),
                        const Color(0xFF1B1324).withOpacity(0.92),
                        const Color(0xFF101820).withOpacity(0.9),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                );
              },
            );
          },
        ),
      );
    }

    Widget keypadButton({
      required String label,
      required VoidCallback onPressed,
      Color? accent,
    }) {
      final color = accent ?? const Color(0xFFD4AF37);
      return OutlinedButton(
        onPressed: _submitting ? null : onPressed,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          side: BorderSide(color: color.withOpacity(0.55)),
          foregroundColor: Colors.white,
          backgroundColor: Colors.black.withOpacity(0.22),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: color,
            letterSpacing: 0.4,
          ),
        ),
      );
    }

    void pushDigit(String d) {
      final raw = _codeController.text.replaceAll(RegExp(r'[^\d]'), '');
      if (raw.length >= 4) return;
      final next = (raw + d).substring(0, (raw.length + 1).clamp(0, 4));
      _codeController.text = next;
      _codeController.selection = TextSelection.collapsed(offset: next.length);
      setState(() {});
    }

    void backspace() {
      final raw = _codeController.text.replaceAll(RegExp(r'[^\d]'), '');
      if (raw.isEmpty) return;
      final next = raw.substring(0, raw.length - 1);
      _codeController.text = next;
      _codeController.selection = TextSelection.collapsed(offset: next.length);
      setState(() {});
    }

    void clear() {
      _codeController.clear();
      setState(() {});
    }

    final keypad = Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.38),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.45)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            _tr('Codepaneel', 'Keypad'),
            style: const TextStyle(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.35),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white12),
            ),
            child: Text(
              (_codeController.text.replaceAll(RegExp(r'[^\d]'), '').padRight(4, '•'))
                  .split('')
                  .take(4)
                  .join('  '),
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                letterSpacing: 2.2,
                color: Color(0xFFD4AF37),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 10),
          GridView.count(
            crossAxisCount: 3,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.45,
            children: [
              for (final n in ['1', '2', '3', '4', '5', '6', '7', '8', '9'])
                keypadButton(label: n, onPressed: () => pushDigit(n)),
              keypadButton(label: 'C', onPressed: clear, accent: Colors.white70),
              keypadButton(label: '0', onPressed: () => pushDigit('0')),
              keypadButton(label: '⌫', onPressed: backspace, accent: Colors.redAccent),
            ],
          ),
        ],
      ),
    );

    final keypadWidth = isSmall ? 210.0 : 280.0;
    final keypadTopPadding = isSmall ? 10.0 : 14.0;
    final keypadRightPadding = isSmall ? 10.0 : 14.0;

    return Container(
      height: height,
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
        gradient: LinearGradient(
          colors: [
            const Color(0xFF0F0F12).withOpacity(0.94),
            const Color(0xFF1B1324).withOpacity(0.92),
            const Color(0xFF101820).withOpacity(0.9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(child: banner()),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.62),
                    Colors.black.withOpacity(0.22),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _tr('Kraak de Kluis', 'Crack the Vault'),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.2,
                    ),
              ),
              const SizedBox(height: 6),
              Text(
                _tr(
                  'Raad de code en win flinke prijzen.',
                  'Guess the code and win big prizes.',
                ),
                style: const TextStyle(color: Colors.white70),
              ),
              if (seasonWindow.isNotEmpty) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    color: Colors.black.withOpacity(0.28),
                    border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.55)),
                  ),
                  child: Text(
                    _tr('Ronde: ', 'Season: ') + seasonWindow,
                    style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFFD4AF37)),
                  ),
                ),
              ],
            ],
          ),
          Positioned(
            right: keypadRightPadding,
            top: keypadTopPadding,
            bottom: keypadTopPadding,
            child: Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                width: keypadWidth,
                child: keypad,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isSmall = MediaQuery.of(context).size.width < 700;
    final tiers = _tiers();
    final wrongCodes = _wrongCodes();
    final balance = _creditsBalance();
    final reward = _rewardForStake(_stakeTier);

    final content = ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        _buildVaultHero(context),
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
                  const Icon(Icons.bolt, color: Color(0xFFD4AF37), size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _tr('Jouw credits', 'Your credits'),
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
                _tr('Kies je inzet', 'Choose your stake'),
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
                    label: Text(_tr('$stake credit', '$stake credit')),
                    onSelected: _submitting
                        ? null
                        : (_) => setState(() => _stakeTier = stake),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
              Text(
                _tr('Verwachte prijs: +$reward credits', 'Expected prize: +$reward credits'),
                style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 14),
              Text(
                _tr('Code', 'Code'),
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
                  hintText: _tr('0000', '0000'),
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
                  label: Text(_tr('Inzet', 'Submit stake')),
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
                      _tr('Foute codes (deze maand)', 'Wrong codes (this month)'),
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                  TextButton(
                    onPressed: wrongCodes.isEmpty
                        ? null
                        : () => setState(() => _showWrongCodes = !_showWrongCodes),
                    child: Text(_showWrongCodes ? _tr('Verberg', 'Hide') : _tr('Toon', 'Show')),
                  ),
                ],
              ),
              if (wrongCodes.isEmpty)
                Text(
                  _tr('Nog geen foute codes opgeslagen.', 'No wrong codes saved yet.'),
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
              label: Text(_tr('Ververs', 'Refresh')),
            ),
          ),
        if (isSmall && widget.embedded) const SizedBox(height: 20),
      ],
    );

    if (widget.embedded) {
      return content;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_tr('Kraak de Kluis', 'Crack the Vault')),
        actions: [
          IconButton(
            onPressed: _loadStatus,
            icon: const Icon(Icons.refresh),
            tooltip: _tr('Ververs', 'Refresh'),
          ),
        ],
      ),
      body: content,
    );
  }
}

