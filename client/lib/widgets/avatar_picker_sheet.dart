import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../config/app_config.dart';
import '../l10n/app_localizations.dart';
import '../providers/auth_provider.dart';
import '../utils/portrait_download.dart';
import '../utils/top_right_notification.dart';
import '../utils/web_asset_helper.dart';
import 'portrait_tile_action_glyphs.dart';

/// Shared avatar / selfie-portrait picker used from Settings and own Profile.
class AvatarPickerSheet {
  static Future<void> show(
    BuildContext context, {
    VoidCallback? onChanged,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _AvatarPickerSheetBody(onChanged: onChanged),
    );
  }
}

class _AvatarPickerSheetBody extends StatefulWidget {
  final VoidCallback? onChanged;

  const _AvatarPickerSheetBody({this.onChanged});

  @override
  State<_AvatarPickerSheetBody> createState() => _AvatarPickerSheetBodyState();
}

class _AvatarPickerSheetBodyState extends State<_AvatarPickerSheetBody> {
  static const List<String> _kPortraitStyleIds = [
    'classic_noir',
    'street_casual',
    'sharp_suit',
    'velvet_charm',
  ];

  Map<String, dynamic>? _settings;
  List<String> _freeAvatars = [];
  List<String> _vipAvatars = [];
  List<Map<String, dynamic>> _portraits = [];
  bool _loading = true;
  bool _portraitSubmitting = false;
  String _selectedPortraitStyleId = 'classic_noir';

  int get _portraitCreditCost =>
      (_settings?['portraitSelfieCreditCost'] as num?)?.toInt() ?? 100;

  int? get _activePortraitId =>
      (_settings?['activePortraitId'] as num?)?.toInt();

  List<String> _portraitStyleIdsResolved() {
    final raw = _settings?['portraitStyleIds'];
    if (raw is List && raw.isNotEmpty) {
      final out = <String>[];
      for (final e in raw) {
        final s = e.toString();
        if (_kPortraitStyleIds.contains(s)) out.add(s);
      }
      if (out.isNotEmpty) return out;
    }
    return _kPortraitStyleIds;
  }

  String _portraitStyleLabel(AppLocalizations l10n, String id) {
    switch (id) {
      case 'classic_noir':
        return l10n.settingsPortraitStyleClassicNoir;
      case 'street_casual':
        return l10n.settingsPortraitStyleStreetCasual;
      case 'sharp_suit':
        return l10n.settingsPortraitStyleSharpSuit;
      case 'velvet_charm':
        return l10n.settingsPortraitStyleVelvetCharm;
      default:
        return l10n.settingsPortraitStyleClassicNoir;
    }
  }

  @override
  void initState() {
    super.initState();
    _loadLibrary();
  }

  Future<void> _loadLibrary() async {
    try {
      const storage = FlutterSecureStorage();
      final token = await storage.read(key: 'auth_token');
      if (token == null) {
        if (mounted) setState(() => _loading = false);
        return;
      }

      final settingsResponse = await http.get(
        Uri.parse('${AppConfig.apiBaseUrl}/settings'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (settingsResponse.statusCode == 200) {
        _settings = jsonDecode(settingsResponse.body) as Map<String, dynamic>;
        final pIds = _settings?['portraitStyleIds'];
        if (pIds is List && pIds.isNotEmpty) {
          final allowed = pIds.map((e) => e.toString()).toSet();
          if (!allowed.contains(_selectedPortraitStyleId)) {
            _selectedPortraitStyleId = allowed.first;
          }
        }
      }

      final avatarsResponse = await http.get(
        Uri.parse('${AppConfig.apiBaseUrl}/settings/avatars'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (avatarsResponse.statusCode == 200) {
        final data = jsonDecode(avatarsResponse.body) as Map<String, dynamic>;
        _freeAvatars = List<String>.from(data['free'] ?? []);
        _vipAvatars = List<String>.from(data['vip'] ?? []);
      }

      final portraitsResponse = await http.get(
        Uri.parse('${AppConfig.apiBaseUrl}/settings/portraits'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (portraitsResponse.statusCode == 200) {
        final pdata = jsonDecode(portraitsResponse.body) as Map<String, dynamic>;
        final params = pdata['params'] as Map<String, dynamic>?;
        final raw = params?['portraits'];
        if (raw is List) {
          _portraits = raw
              .map((e) => Map<String, dynamic>.from(e as Map))
              .toList();
        }
      }

      if (mounted) setState(() => _loading = false);
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _afterAvatarChanged() async {
    await _loadLibrary();
    if (mounted) {
      await context.read<AuthProvider>().refreshPlayer();
    }
    widget.onChanged?.call();
  }

  Future<void> _changeAvatar(String avatar) async {
    try {
      const storage = FlutterSecureStorage();
      final token = await storage.read(key: 'auth_token');
      final response = await http.post(
        Uri.parse('${AppConfig.apiBaseUrl}/settings/avatar'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'avatar': avatar}),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && mounted) {
        final l10n = AppLocalizations.of(context)!;
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(l10n.avatarUpdated),
            backgroundColor: Colors.green,
          ),
        );
        await _afterAvatarChanged();
        if (mounted) Navigator.of(context).pop();
      } else if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(
              data['event'] == 'error.avatar_cooldown'
                  ? l10n.settingsAvatarChangeWeeklyLimit
                  : l10n.avatarChangeFailed,
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(AppLocalizations.of(context)!.error(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _selectPortrait(int portraitId) async {
    try {
      const storage = FlutterSecureStorage();
      final token = await storage.read(key: 'auth_token');
      if (token == null) return;
      final response = await http.post(
        Uri.parse('${AppConfig.apiBaseUrl}/settings/portraits/select'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'portraitId': portraitId}),
      );
      if (response.statusCode == 200 && mounted) {
        final l10n = AppLocalizations.of(context)!;
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(l10n.avatarUpdated),
            backgroundColor: Colors.green,
          ),
        );
        await _afterAvatarChanged();
      } else if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(l10n.avatarChangeFailed),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(AppLocalizations.of(context)!.error(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _downloadCustomPortrait(int portraitId) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      await downloadOwnedPortraitPng(portraitId);
      if (!mounted) return;
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(l10n.settingsPortraitDownloaded),
          backgroundColor: Colors.green,
        ),
      );
    } catch (_) {
      if (!mounted) return;
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(l10n.settingsPortraitDownloadFailed),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _portraitCornerAction({
    required Widget glyph,
    required VoidCallback onPressed,
    required Color backgroundColor,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: backgroundColor,
        shape: const CircleBorder(),
        elevation: 2,
        shadowColor: Colors.black54,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: SizedBox(
            width: 34,
            height: 34,
            child: Center(child: glyph),
          ),
        ),
      ),
    );
  }

  Future<void> _confirmDeletePortrait(int portraitId) async {
    final l10n = AppLocalizations.of(context)!;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.settingsPortraitDelete),
        content: Text(l10n.settingsPortraitDeleteConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;

    try {
      const storage = FlutterSecureStorage();
      final token = await storage.read(key: 'auth_token');
      if (token == null) return;
      final response = await http.delete(
        Uri.parse('${AppConfig.apiBaseUrl}/settings/portraits/$portraitId'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200 && mounted) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(l10n.avatarUpdated),
            backgroundColor: Colors.green,
          ),
        );
        await _afterAvatarChanged();
      }
    } catch (e) {
      if (mounted) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(AppLocalizations.of(context)!.error(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _pickSelfieAndGenerate() async {
    final l10n = AppLocalizations.of(context)!;
    final balance = (_settings?['premiumCredits'] as num?)?.toInt() ?? 0;
    final cost = _portraitCreditCost;

    if (balance < cost) {
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(l10n.settingsPortraitInsufficientCredits(cost, balance)),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final maxP = (_settings?['maxPlayerPortraits'] as num?)?.toInt() ?? 20;
    if (_portraits.length >= maxP) {
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(l10n.settingsPortraitLimitReached(maxP)),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final confirmCost = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.settingsPortraitFromSelfieTitle),
        content: Text(l10n.settingsPortraitUploadConfirm(_portraitCreditCost)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.change),
          ),
        ],
      ),
    );
    if (confirmCost != true || !mounted) return;

    var consent = false;
    final consentOk = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSt) => AlertDialog(
          title: Text(l10n.settingsPortraitFromSelfieTitle),
          content: CheckboxListTile(
            value: consent,
            onChanged: (v) => setSt(() => consent = v ?? false),
            controlAffinity: ListTileControlAffinity.leading,
            title: Text(l10n.settingsPortraitConsentLabel),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: consent ? () => Navigator.pop(ctx, true) : null,
              child: Text(l10n.change),
            ),
          ],
        ),
      ),
    );
    if (consentOk != true || !mounted) return;

    final picker = ImagePicker();
    final xfile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 2048,
      maxHeight: 2048,
      imageQuality: 92,
    );
    if (xfile == null || !mounted) return;

    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'auth_token');
    if (token == null || !mounted) return;

    setState(() => _portraitSubmitting = true);
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => PopScope(
        canPop: false,
        child: AlertDialog(
          content: Row(
            children: [
              const SizedBox(
                width: 36,
                height: 36,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              const SizedBox(width: 16),
              Expanded(child: Text(l10n.settingsPortraitGenerating)),
            ],
          ),
        ),
      ),
    );
    try {
      final bytes = await xfile.readAsBytes();
      final ct = xfile.mimeType != null
          ? MediaType.parse(xfile.mimeType!)
          : MediaType('image', 'jpeg');

      final req = http.MultipartRequest(
        'POST',
        Uri.parse('${AppConfig.apiBaseUrl}/settings/portraits/from-selfie'),
      );
      req.headers['Authorization'] = 'Bearer $token';
      req.fields['consent'] = 'true';
      req.fields['portraitStyle'] = _selectedPortraitStyleId;
      req.files.add(
        http.MultipartFile.fromBytes(
          'selfie',
          bytes,
          filename: xfile.name.isNotEmpty ? xfile.name : 'selfie.jpg',
          contentType: ct,
        ),
      );

      final streamed = await req.send();
      final resp = await http.Response.fromStream(streamed);
      final data =
          resp.body.isNotEmpty ? jsonDecode(resp.body) : <String, dynamic>{};

      if (resp.statusCode == 200 && mounted) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(l10n.settingsPortraitCreated),
            backgroundColor: Colors.green,
          ),
        );
        await _afterAvatarChanged();
      } else if (mounted) {
        final ev = data['event'] as String?;
        if (ev == 'error.insufficient_credits') {
          final p = data['params'] as Map<String, dynamic>? ?? {};
          showTopRightFromSnackBar(
            context,
            SnackBar(
              content: Text(
                l10n.settingsPortraitInsufficientCredits(
                  (p['required'] as num?)?.toInt() ?? cost,
                  (p['available'] as num?)?.toInt() ?? 0,
                ),
              ),
              backgroundColor: Colors.orange,
            ),
          );
        } else {
          showTopRightFromSnackBar(
            context,
            SnackBar(
              content: Text(l10n.settingsPortraitGenerationFailed),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (_) {
      if (mounted) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(l10n.settingsPortraitGenerationFailed),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        Navigator.of(context).pop();
        setState(() => _portraitSubmitting = false);
      }
    }
  }

  Widget _buildAvatarTile(String avatar, bool isVip) {
    final isSelected = (_settings?['activePortraitId'] == null) &&
        avatar == _settings?['avatar'];
    final isLocked = isVip && !(_settings?['isVip'] ?? false);

    return GestureDetector(
      onTap: isLocked ? null : () => _changeAvatar(avatar),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey[800]!,
            width: isSelected ? 3 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(7),
                child: WebAssetHelper.imageHttpFirst(
                  'assets/images/avatars/$avatar.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return ColoredBox(
                      color: Colors.grey[900]!,
                      child: Icon(
                        Icons.broken_image_outlined,
                        size: 28,
                        color: isLocked ? Colors.grey[700] : Colors.grey[600],
                      ),
                    );
                  },
                ),
              ),
            ),
            if (isLocked)
              Container(
                color: Colors.black54,
                child: const Center(
                  child: Icon(Icons.lock, color: Colors.amber),
                ),
              ),
            if (isSelected)
              const Positioned(
                top: 4,
                right: 4,
                child: Icon(Icons.check_circle, color: Colors.blue, size: 20),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              l10n.chooseAvatar,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(16),
                    children: [
                      Text(
                        l10n.settingsMyPortraits,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        l10n.settingsPortraitFromSelfieSubtitle(
                          _portraitCreditCost,
                        ),
                        style: TextStyle(color: Colors.grey[500], fontSize: 12),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        l10n.settingsPortraitStyleSection,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.settingsPortraitStyleHint,
                        style: TextStyle(color: Colors.grey[500], fontSize: 11),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          for (final id in _portraitStyleIdsResolved())
                            ChoiceChip(
                              label: Text(_portraitStyleLabel(l10n, id)),
                              selected: _selectedPortraitStyleId == id,
                              onSelected: (_) {
                                setState(() => _selectedPortraitStyleId = id);
                              },
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      OutlinedButton.icon(
                        onPressed: _portraitSubmitting
                            ? null
                            : _pickSelfieAndGenerate,
                        icon: _portraitSubmitting
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.add_a_photo_outlined),
                        label: Text(l10n.settingsPortraitFromSelfieTitle),
                      ),
                      if (_portraits.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          l10n.settingsPortraitDeleteHint,
                          style:
                              TextStyle(color: Colors.grey[500], fontSize: 12),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          l10n.settingsPortraitLaterDownloadHint,
                          style:
                              TextStyle(color: Colors.grey[500], fontSize: 12),
                        ),
                        if (_activePortraitId != null) ...[
                          const SizedBox(height: 10),
                          FilledButton.icon(
                            onPressed: () =>
                                _downloadCustomPortrait(_activePortraitId!),
                            icon: const Icon(Icons.download_outlined),
                            label: Text(l10n.profileDownloadPortrait),
                          ),
                        ],
                        const SizedBox(height: 14),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                          itemCount: _portraits.length,
                          itemBuilder: (context, index) {
                            final p = _portraits[index];
                            final id = (p['id'] as num).toInt();
                            final path = p['imagePath'] as String? ?? '';
                            final isSel = _activePortraitId == id;
                            return Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Positioned.fill(
                                  child: GestureDetector(
                                    onTap: () => _selectPortrait(id),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: isSel
                                              ? Colors.blue
                                              : Colors.grey[800]!,
                                          width: isSel ? 3 : 1,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(7),
                                        child: Image.network(
                                          WebAssetHelper.toPublicUrl(
                                            'assets/images/$path',
                                          ),
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  ColoredBox(
                                            color: Colors.grey[900]!,
                                            child: const Icon(
                                              Icons.broken_image_outlined,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 4,
                                  left: 4,
                                  child: _portraitCornerAction(
                                    tooltip:
                                        l10n.settingsPortraitDownloadTooltip,
                                    glyph: const PortraitTileDownloadGlyph(
                                      color: Colors.white,
                                      size: 17,
                                    ),
                                    backgroundColor: const Color(0xFF1565C0),
                                    onPressed: () =>
                                        _downloadCustomPortrait(id),
                                  ),
                                ),
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: _portraitCornerAction(
                                    tooltip: l10n.settingsPortraitDeleteTooltip,
                                    glyph: const PortraitTileTrashGlyph(
                                      color: Colors.white,
                                      size: 17,
                                    ),
                                    backgroundColor: const Color(0xFFC62828),
                                    onPressed: () =>
                                        _confirmDeletePortrait(id),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                      const SizedBox(height: 24),
                      Text(
                        l10n.settingsPresetAvatars,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.freeAvatars,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemCount: _freeAvatars.length,
                        itemBuilder: (context, index) =>
                            _buildAvatarTile(_freeAvatars[index], false),
                      ),
                      if (_vipAvatars.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Text(
                              l10n.vipAvatars,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Colors.amber, Colors.orange],
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                l10n.vip,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                          itemCount: _vipAvatars.length,
                          itemBuilder: (context, index) =>
                              _buildAvatarTile(_vipAvatars[index], true),
                        ),
                      ],
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
