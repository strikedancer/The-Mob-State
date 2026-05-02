import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../config/app_config.dart';
import '../config/supported_languages.dart';
import '../providers/locale_provider.dart';
import '../l10n/app_localizations.dart';
import '../services/notification_service.dart';
import '../utils/top_right_notification.dart';
import '../utils/theft_cooldown_confirm_prefs.dart';
import '../utils/web_asset_helper.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/auth_provider.dart';

class SettingsScreen extends StatefulWidget {
  final bool embedded;

  const SettingsScreen({super.key, this.embedded = false});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final NotificationService _notificationService = NotificationService();
  bool _isLoading = true;
  Map<String, dynamic>? _settings;
  List<String> _freeAvatars = [];
  List<String> _vipAvatars = [];
  List<Map<String, dynamic>> _portraits = [];
  bool _portraitSubmitting = false;
  /// Must match `PORTRAIT_STYLE_IDS` on the server.
  static const List<String> _kPortraitStyleIds = [
    'classic_noir',
    'street_casual',
    'sharp_suit',
    'velvet_charm',
  ];
  String _selectedPortraitStyleId = 'classic_noir';
  bool _allowMessages = true;
  bool _pushCryptoTrade = true;
  bool _pushCryptoPriceAlert = true;
  bool _pushCryptoOrder = true;
  bool _pushCryptoMission = true;
  bool _pushCryptoLeaderboard = true;
  bool _pushGameEvents = true;
  bool _inAppCryptoTrade = true;
  bool _inAppCryptoPriceAlert = true;
  bool _inAppCryptoOrder = true;
  bool _inAppCryptoMission = true;
  bool _inAppCryptoLeaderboard = true;
  String _selectedLanguage = 'nl';
  String? _error;
  AuthorizationStatus? _pushAuthorizationStatus;
  bool _pushTokenRegistered = false;
  bool _isEnablingPush = false;
  /// When true, show confirm dialog before spending credits on theft cooldown skip.
  bool _askTheftCooldownCreditConfirm = true;

  bool get _isDutch => Localizations.localeOf(context).languageCode == 'nl';

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
    _loadSettings();
  }

  bool _readPreferenceValue(dynamic value, bool fallback) {
    if (value is bool) {
      return value;
    }
    if (value is num) {
      return value != 0;
    }
    if (value is String) {
      final normalized = value.trim().toLowerCase();
      if (normalized == 'true' || normalized == '1') {
        return true;
      }
      if (normalized == 'false' || normalized == '0') {
        return false;
      }
    }
    return fallback;
  }

  Future<void> _loadSettings() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      const storage = FlutterSecureStorage();
      final token = await storage.read(key: 'auth_token');

      if (token == null) {
        if (mounted) {
          setState(() {
            _error = AppLocalizations.of(context)!.notLoggedIn;
            _isLoading = false;
          });
        }
        return;
      }

      // Load settings
      final settingsResponse = await http.get(
        Uri.parse('${AppConfig.apiBaseUrl}/settings'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (settingsResponse.statusCode == 200) {
        _settings = jsonDecode(settingsResponse.body);
        _allowMessages = _settings?['allowMessages'] ?? true;
        _selectedLanguage = _settings?['preferredLanguage'] ?? 'nl';
        final pIds = _settings?['portraitStyleIds'];
        if (pIds is List && pIds.isNotEmpty) {
          final allowed = pIds.map((e) => e.toString()).toSet();
          if (!allowed.contains(_selectedPortraitStyleId)) {
            _selectedPortraitStyleId = allowed.first;
          }
        }

        final notificationPreferences =
            (_settings?['notificationPreferences'] as Map<String, dynamic>?) ??
            <String, dynamic>{};
        _pushCryptoTrade = _readPreferenceValue(
          notificationPreferences['pushCryptoTrade'],
          true,
        );
        _pushCryptoPriceAlert =
            _readPreferenceValue(
              notificationPreferences['pushCryptoPriceAlert'],
              true,
            );
        _pushCryptoOrder = _readPreferenceValue(
          notificationPreferences['pushCryptoOrder'],
          true,
        );
        _pushCryptoMission =
            _readPreferenceValue(
              notificationPreferences['pushCryptoMission'],
              true,
            );
        _pushCryptoLeaderboard =
            _readPreferenceValue(
              notificationPreferences['pushCryptoLeaderboard'],
              true,
            );
        _pushGameEvents = _readPreferenceValue(
          notificationPreferences['pushGameEvents'],
          true,
        );
        _inAppCryptoTrade = _readPreferenceValue(
          notificationPreferences['inAppCryptoTrade'],
          true,
        );
        _inAppCryptoPriceAlert =
            _readPreferenceValue(
              notificationPreferences['inAppCryptoPriceAlert'],
              true,
            );
        _inAppCryptoOrder = _readPreferenceValue(
          notificationPreferences['inAppCryptoOrder'],
          true,
        );
        _inAppCryptoMission =
            _readPreferenceValue(
              notificationPreferences['inAppCryptoMission'],
              true,
            );
        _inAppCryptoLeaderboard =
            _readPreferenceValue(
              notificationPreferences['inAppCryptoLeaderboard'],
              true,
            );
      }

      // Load available avatars
      final avatarsResponse = await http.get(
        Uri.parse('${AppConfig.apiBaseUrl}/settings/avatars'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (avatarsResponse.statusCode == 200) {
        final data = jsonDecode(avatarsResponse.body);
        _freeAvatars = List<String>.from(data['free'] ?? []);
        _vipAvatars = List<String>.from(data['vip'] ?? []);
      }

      final portraitsResponse = await http.get(
        Uri.parse('${AppConfig.apiBaseUrl}/settings/portraits'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (portraitsResponse.statusCode == 200) {
        final pdata = jsonDecode(portraitsResponse.body);
        final params = pdata['params'] as Map<String, dynamic>?;
        final raw = params?['portraits'];
        if (raw is List) {
          _portraits = raw
              .map((e) => Map<String, dynamic>.from(e as Map))
              .toList();
        }
      }

      setState(() {
        _isLoading = false;
      });

      _askTheftCooldownCreditConfirm =
          !(await TheftCooldownConfirmPrefs.skipConfirmDialog);

      await _loadPushPermissionStatus();
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
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
        Navigator.of(context).pop();
        _loadSettings();
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

  int get _portraitCreditCost =>
      (_settings?['portraitSelfieCreditCost'] as num?)?.toInt() ?? 100;

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
        await _loadSettings();
        if (mounted) {
          await context.read<AuthProvider>().refreshPlayer();
        }
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

  Future<void> _confirmDeletePortrait(BuildContext context, int portraitId) async {
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
        Uri.parse(
          '${AppConfig.apiBaseUrl}/settings/portraits/$portraitId',
        ),
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
        await _loadSettings();
        if (mounted) {
          await context.read<AuthProvider>().refreshPlayer();
        }
      }
    } catch (e) {
      if (mounted) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(l10n.error(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _pickSelfieAndGenerate(BuildContext sheetContext) async {
    final l10n = AppLocalizations.of(sheetContext)!;
    final balance = (_settings?['premiumCredits'] as num?)?.toInt() ?? 0;
    final cost = _portraitCreditCost;

    if (balance < cost) {
      showTopRightFromSnackBar(
        sheetContext,
        SnackBar(
          content: Text(
            l10n.settingsPortraitInsufficientCredits(cost, balance),
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final maxP = (_settings?['maxPlayerPortraits'] as num?)?.toInt() ?? 20;
    if (_portraits.length >= maxP) {
      showTopRightFromSnackBar(
        sheetContext,
        SnackBar(
          content: Text(l10n.settingsPortraitLimitReached(maxP)),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final confirmCost = await showDialog<bool>(
      context: sheetContext,
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

    bool consent = false;
    final consentOk = await showDialog<bool>(
      context: sheetContext,
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
    if (!mounted) return;
    showDialog<void>(
      context: sheetContext,
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
      final data = resp.body.isNotEmpty ? jsonDecode(resp.body) : <String, dynamic>{};

      if (resp.statusCode == 200 && mounted) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(l10n.settingsPortraitCreated),
            backgroundColor: Colors.green,
          ),
        );
        await _loadSettings();
        if (mounted) {
          await context.read<AuthProvider>().refreshPlayer();
        }
        if (mounted) Navigator.of(sheetContext).pop();
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
    } catch (e) {
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
        Navigator.of(sheetContext).pop();
        setState(() => _portraitSubmitting = false);
      }
    }
  }

  Future<void> _changeLanguage(String language) async {
    try {
      const storage = FlutterSecureStorage();
      final token = await storage.read(key: 'auth_token');

      print('[Settings] Changing language to: $language');
      print('[Settings] Token: ${token?.substring(0, 20)}...');
      print('[Settings] URL: ${AppConfig.apiBaseUrl}/player/language');

      final response = await http.put(
        Uri.parse('${AppConfig.apiBaseUrl}/player/language'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'language': language}),
      );

      print('[Settings] Response status: ${response.statusCode}');
      print('[Settings] Response body: ${response.body}');

      if (response.statusCode == 200 && mounted) {
        setState(() {
          _selectedLanguage = language;
        });

        // Update the app's locale immediately
        final localeProvider = Provider.of<LocaleProvider>(
          context,
          listen: false,
        );
        localeProvider.setLocale(language);

        final l10n = AppLocalizations.of(context)!;
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(l10n.languageChanged),
            backgroundColor: Colors.green,
          ),
        );
      } else if (mounted) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.languageChangeFailed(
                response.statusCode.toString(),
              ),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('[Settings] Language change error: $e');
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

  Future<void> _changeUsername() async {
    final controller = TextEditingController();
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.changeUsername),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: l10n.username,
                hintText: l10n.usernameHint,
              ),
              maxLength: 20,
            ),
            if (!(_settings?['canChangeUsername'] ?? true))
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  l10n.settingsUsernameChangeMonthlyLimit,
                  style: TextStyle(color: Colors.orange[300], fontSize: 12),
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              final newUsername = controller.text.trim();
              if (newUsername.isEmpty || newUsername.length < 3) {
                final l10n = AppLocalizations.of(context)!;
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(l10n.minChars)));
                return;
              }

              try {
                const storage = FlutterSecureStorage();
                final token = await storage.read(key: 'auth_token');

                final response = await http.post(
                  Uri.parse('${AppConfig.apiBaseUrl}/settings/username'),
                  headers: {
                    'Authorization': 'Bearer $token',
                    'Content-Type': 'application/json',
                  },
                  body: jsonEncode({'username': newUsername}),
                );

                final data = jsonDecode(response.body);

                if (response.statusCode == 200 && mounted) {
                  final l10n = AppLocalizations.of(context)!;
                  showTopRightFromSnackBar(
                    context,
                    SnackBar(
                      content: Text(l10n.usernameUpdated),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.of(context).pop();
                  _loadSettings();
                } else if (mounted) {
                  final l10n = AppLocalizations.of(context)!;
                  showTopRightFromSnackBar(
                    context,
                    SnackBar(
                      content: Text(
                        data['event'] == 'error.username_taken'
                            ? l10n.usernameTaken
                            : data['event'] == 'error.username_cooldown'
                            ? l10n.settingsUsernameChangeMonthlyLimit
                            : l10n.usernameChangeFailed,
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
                      content: Text(
                        AppLocalizations.of(context)!.error(e.toString()),
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: Text(l10n.change),
          ),
        ],
      ),
    );
  }

  Future<void> _updateMessageSettings(bool value) async {
    try {
      const storage = FlutterSecureStorage();
      final token = await storage.read(key: 'auth_token');

      final response = await http.post(
        Uri.parse('${AppConfig.apiBaseUrl}/settings/messages'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'allowMessages': value}),
      );

      if (response.statusCode == 200) {
        setState(() {
          _allowMessages = value;
        });
        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
          showTopRightFromSnackBar(
            context,
            SnackBar(
              content: Text(l10n.settingsSaved),
              backgroundColor: Colors.green,
            ),
          );
        }
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

  Future<void> _updateCryptoNotificationPreference(
    String key,
    bool value,
  ) async {
    try {
      const storage = FlutterSecureStorage();
      final token = await storage.read(key: 'auth_token');

      final response = await http.post(
        Uri.parse('${AppConfig.apiBaseUrl}/settings/notifications'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({key: value}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final prefs =
            (data['notificationPreferences'] as Map<String, dynamic>?) ??
            <String, dynamic>{};

        setState(() {
          _pushCryptoTrade = _readPreferenceValue(
            prefs['pushCryptoTrade'],
            _pushCryptoTrade,
          );
          _pushCryptoPriceAlert =
              _readPreferenceValue(
                prefs['pushCryptoPriceAlert'],
                _pushCryptoPriceAlert,
              );
          _pushCryptoOrder = _readPreferenceValue(
            prefs['pushCryptoOrder'],
            _pushCryptoOrder,
          );
          _pushCryptoMission = _readPreferenceValue(
            prefs['pushCryptoMission'],
            _pushCryptoMission,
          );
          _pushCryptoLeaderboard =
              _readPreferenceValue(
                prefs['pushCryptoLeaderboard'],
                _pushCryptoLeaderboard,
              );
          _pushGameEvents = _readPreferenceValue(
            prefs['pushGameEvents'],
            _pushGameEvents,
          );
          _inAppCryptoTrade = _readPreferenceValue(
            prefs['inAppCryptoTrade'],
            _inAppCryptoTrade,
          );
          _inAppCryptoPriceAlert =
              _readPreferenceValue(
                prefs['inAppCryptoPriceAlert'],
                _inAppCryptoPriceAlert,
              );
          _inAppCryptoOrder = _readPreferenceValue(
            prefs['inAppCryptoOrder'],
            _inAppCryptoOrder,
          );
          _inAppCryptoMission =
              _readPreferenceValue(
                prefs['inAppCryptoMission'],
                _inAppCryptoMission,
              );
          _inAppCryptoLeaderboard =
              _readPreferenceValue(
                prefs['inAppCryptoLeaderboard'],
                _inAppCryptoLeaderboard,
              );
          _settings?['notificationPreferences'] = prefs;
        });

        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
          showTopRightFromSnackBar(
            context,
            SnackBar(
              content: Text(l10n.settingsSaved),
              backgroundColor: Colors.green,
            ),
          );
        }
        return;
      }

      if (mounted) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(
              _isDutch
                  ? 'Opslaan van notificatie-instelling mislukt'
                  : 'Failed to save notification preference',
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

  Future<void> _loadPushPermissionStatus() async {
    try {
      await _notificationService.syncAuthorizedSession();
      final settings = await _notificationService.getNotificationSettings();
      if (!mounted) return;
      setState(() {
        _pushAuthorizationStatus = settings.authorizationStatus;
        _pushTokenRegistered =
            _notificationService.fcmToken != null &&
            _notificationService.fcmToken!.isNotEmpty;
      });
    } catch (_) {
      // Leave existing status untouched if the platform does not expose it.
    }
  }

  Future<void> _enablePushNotifications() async {
    if (_isEnablingPush) return;

    setState(() {
      _isEnablingPush = true;
    });

    try {
      await _notificationService.initialize();
      await _notificationService.registerCurrentToken();
      await _loadPushPermissionStatus();

      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;

      final status = _pushAuthorizationStatus;
      final authorized =
          status == AuthorizationStatus.authorized ||
          status == AuthorizationStatus.provisional;

      if (authorized) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(
              l10n.settingsPushEnabledToast,
            ),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(
              l10n.settingsPushDisabledInSystem,
            ),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(
              l10n.settingsEnablePushFailed(e.toString()),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isEnablingPush = false;
        });
      }
    }
  }

  String _pushStatusText() {
    final hasToken = _pushTokenRegistered;
    final l10n = AppLocalizations.of(context)!;
    switch (_pushAuthorizationStatus) {
      case AuthorizationStatus.authorized:
        return hasToken
            ? l10n.settingsPushPermissionAllowedLinked
            : l10n.settingsPushPermissionAllowedRelinking;
      case AuthorizationStatus.provisional:
        return hasToken
            ? l10n.settingsPushPermissionProvisionalLinked
            : l10n.settingsPushPermissionProvisionalRelinking;
      case AuthorizationStatus.denied:
        return l10n.settingsPushPermissionDenied;
      case AuthorizationStatus.notDetermined:
        return l10n.settingsPushPermissionNotRequested;
      default:
        return l10n.settingsPushPermissionUnknown;
    }
  }

  void _showAvatarPicker() {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            Container(
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
              child: ListView(
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
                    l10n.settingsPortraitFromSelfieSubtitle(_portraitCreditCost),
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
                  StatefulBuilder(
                    builder: (context, setModalState) {
                      return Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          for (final id in _portraitStyleIdsResolved())
                            ChoiceChip(
                              label: Text(_portraitStyleLabel(l10n, id)),
                              selected: _selectedPortraitStyleId == id,
                              onSelected: (_) {
                                setState(() => _selectedPortraitStyleId = id);
                                setModalState(() {});
                              },
                            ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: _portraitSubmitting
                        ? null
                        : () => _pickSelfieAndGenerate(context),
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
                      style: TextStyle(color: Colors.grey[500], fontSize: 12),
                    ),
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
                        final isSel =
                            (_settings?['activePortraitId'] as num?)?.toInt() ==
                            id;
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
                              top: 2,
                              right: 2,
                              child: Material(
                                color: Colors.black54,
                                shape: const CircleBorder(),
                                child: InkWell(
                                  customBorder: const CircleBorder(),
                                  onTap: () =>
                                      _confirmDeletePortrait(context, id),
                                  child: const Padding(
                                    padding: EdgeInsets.all(4),
                                    child: Icon(
                                      Icons.delete_outline,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ),
                                ),
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
      ),
    );
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
            // Avatar image: web = HTTP-only (/images/avatars via nginx mount), no Image.asset (avoids assets/assets 404 spam)
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
              Positioned(
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
    final content = _isLoading
        ? const Center(child: CircularProgressIndicator())
        : _error != null
        ? Center(
            child: Text(_error!, style: const TextStyle(color: Colors.red)),
          )
        : ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (widget.embedded)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Text(
                        '⚙️ ${l10n.settings}',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: _loadSettings,
                        tooltip: l10n.refresh,
                      ),
                    ],
                  ),
                ),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.face, color: Colors.blue),
                  title: Text(l10n.avatar),
                  subtitle: Text(
                    _settings?['activePortraitId'] != null
                        ? l10n.settingsPortraitUsingCustom
                        : (_settings?['avatar'] ?? 'default_1'),
                  ),
                  trailing: Icon(
                    _settings?['canChangeAvatar'] ?? true
                        ? Icons.chevron_right
                        : Icons.lock_clock,
                    color: _settings?['canChangeAvatar'] ?? true
                        ? null
                        : Colors.orange,
                  ),
                  onTap: _showAvatarPicker,
                ),
              ),
              const SizedBox(height: 8),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.language, color: Colors.amber),
                  title: Text(l10n.changeLanguage),
                  subtitle: Text(
                    SupportedLanguages.menuSubtitle(_selectedLanguage),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(l10n.chooseLanguage),
                        content: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              for (final code in SupportedLanguages.codes)
                                ListTile(
                                  leading: Text(
                                    SupportedLanguages.flagFor(code) ?? '🌐',
                                    style: const TextStyle(fontSize: 24),
                                  ),
                                  title: Text(SupportedLanguages.labelFor(code)),
                                  trailing: _selectedLanguage == code
                                      ? const Icon(Icons.check, color: Colors.green)
                                      : null,
                                  onTap: () {
                                    _changeLanguage(code);
                                    Navigator.of(context).pop();
                                  },
                                ),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(l10n.cancel),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              Card(
                child: SwitchListTile(
                  secondary: const Icon(Icons.bolt, color: Colors.amber),
                  title: Text(l10n.settingsTheftCooldownConfirmTitle),
                  subtitle: Text(l10n.settingsTheftCooldownConfirmSubtitle),
                  value: _askTheftCooldownCreditConfirm,
                  onChanged: (value) async {
                    await TheftCooldownConfirmPrefs.setSkipConfirmDialog(!value);
                    if (mounted) {
                      setState(() {
                        _askTheftCooldownCreditConfirm = value;
                      });
                    }
                  },
                ),
              ),
              const SizedBox(height: 8),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.person, color: Colors.green),
                  title: Text(l10n.username),
                  subtitle: Text(l10n.oncePerMonth),
                  trailing: Icon(
                    _settings?['canChangeUsername'] ?? true
                        ? Icons.chevron_right
                        : Icons.lock_clock,
                    color: _settings?['canChangeUsername'] ?? true
                        ? null
                        : Colors.orange,
                  ),
                  onTap: _changeUsername,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.privacy,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Card(
                child: SwitchListTile(
                  secondary: const Icon(Icons.message, color: Colors.purple),
                  title: Text(l10n.allowMessages),
                  subtitle: Text(l10n.allowMessagesDesc),
                  value: _allowMessages,
                  onChanged: _updateMessageSettings,
                ),
              ),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.notifications_active,
                            color: Colors.lightBlue,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              l10n.settingsSystemNotificationsTitle,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(_pushStatusText()),
                      const SizedBox(height: 4),
                      Text(
                        _pushTokenRegistered
                            ? l10n.settingsDeviceTokenRegistered
                            : l10n.settingsDeviceTokenNotRegistered,
                        style: TextStyle(
                          color: _pushTokenRegistered
                              ? Colors.green
                              : Colors.orange,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        l10n.settingsPushHelpText,
                        style: TextStyle(color: Colors.grey[400], fontSize: 12),
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton.icon(
                          onPressed: _isEnablingPush
                              ? null
                              : _enablePushNotifications,
                          icon: const Icon(Icons.notifications),
                          label: Text(
                            _isEnablingPush
                                ? l10n.working
                                : l10n.settingsEnablePush,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.settingsPlayerEventsTitle,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Card(
                child: SwitchListTile(
                  secondary: const Icon(
                    Icons.emoji_events_outlined,
                    color: Colors.deepPurple,
                  ),
                  title: Text(
                    l10n.settingsPushLivePlayerEventsTitle,
                  ),
                  subtitle: Text(
                    l10n.settingsPushLivePlayerEventsSubtitle,
                  ),
                  value: _pushGameEvents,
                  onChanged: (value) => _updateCryptoNotificationPreference(
                    'pushGameEvents',
                    value,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.settingsCryptoNotificationsTitle,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Card(
                child: Column(
                  children: [
                    SwitchListTile(
                      secondary: const Icon(
                        Icons.campaign,
                        color: Colors.amber,
                      ),
                      title: Text(l10n.settingsCryptoPushTradesTitle),
                      subtitle: Text(
                        l10n.settingsCryptoPushTradesSubtitle,
                      ),
                      value: _pushCryptoTrade,
                      onChanged: (value) => _updateCryptoNotificationPreference(
                        'pushCryptoTrade',
                        value,
                      ),
                    ),
                    SwitchListTile(
                      secondary: const Icon(
                        Icons.price_check,
                        color: Colors.orange,
                      ),
                      title: Text(
                        l10n.settingsCryptoPushPriceAlertsTitle,
                      ),
                      subtitle: Text(
                        l10n.settingsCryptoPushPriceAlertsSubtitle,
                      ),
                      value: _pushCryptoPriceAlert,
                      onChanged: (value) => _updateCryptoNotificationPreference(
                        'pushCryptoPriceAlert',
                        value,
                      ),
                    ),
                    SwitchListTile(
                      secondary: const Icon(
                        Icons.fact_check,
                        color: Colors.deepOrange,
                      ),
                      title: Text(l10n.settingsCryptoPushOrdersTitle),
                      subtitle: Text(
                        l10n.settingsCryptoPushOrdersSubtitle,
                      ),
                      value: _pushCryptoOrder,
                      onChanged: (value) => _updateCryptoNotificationPreference(
                        'pushCryptoOrder',
                        value,
                      ),
                    ),
                    SwitchListTile(
                      secondary: const Icon(
                        Icons.emoji_events,
                        color: Colors.green,
                      ),
                      title: Text(
                        l10n.settingsCryptoPushMissionsTitle,
                      ),
                      subtitle: Text(
                        l10n.settingsCryptoPushMissionsSubtitle,
                      ),
                      value: _pushCryptoMission,
                      onChanged: (value) => _updateCryptoNotificationPreference(
                        'pushCryptoMission',
                        value,
                      ),
                    ),
                    SwitchListTile(
                      secondary: const Icon(
                        Icons.leaderboard,
                        color: Colors.cyan,
                      ),
                      title: Text(
                        l10n.settingsCryptoPushLeaderboardTitle,
                      ),
                      subtitle: Text(
                        l10n.settingsCryptoPushLeaderboardSubtitle,
                      ),
                      value: _pushCryptoLeaderboard,
                      onChanged: (value) => _updateCryptoNotificationPreference(
                        'pushCryptoLeaderboard',
                        value,
                      ),
                    ),
                    const Divider(height: 1),
                    SwitchListTile(
                      secondary: const Icon(
                        Icons.feed,
                        color: Colors.lightBlue,
                      ),
                      title: Text(
                        l10n.settingsCryptoInAppTradesTitle,
                      ),
                      subtitle: Text(
                        l10n.settingsCryptoInAppTradesSubtitle,
                      ),
                      value: _inAppCryptoTrade,
                      onChanged: (value) => _updateCryptoNotificationPreference(
                        'inAppCryptoTrade',
                        value,
                      ),
                    ),
                    SwitchListTile(
                      secondary: const Icon(
                        Icons.timeline,
                        color: Colors.blueAccent,
                      ),
                      title: Text(
                        l10n.settingsCryptoInAppPriceAlertsTitle,
                      ),
                      subtitle: Text(
                        l10n.settingsCryptoInAppPriceAlertsSubtitle,
                      ),
                      value: _inAppCryptoPriceAlert,
                      onChanged: (value) => _updateCryptoNotificationPreference(
                        'inAppCryptoPriceAlert',
                        value,
                      ),
                    ),
                    SwitchListTile(
                      secondary: const Icon(
                        Icons.list_alt,
                        color: Colors.indigo,
                      ),
                      title: Text(
                        l10n.settingsCryptoInAppOrdersTitle,
                      ),
                      subtitle: Text(
                        l10n.settingsCryptoInAppOrdersSubtitle,
                      ),
                      value: _inAppCryptoOrder,
                      onChanged: (value) => _updateCryptoNotificationPreference(
                        'inAppCryptoOrder',
                        value,
                      ),
                    ),
                    SwitchListTile(
                      secondary: const Icon(Icons.flag, color: Colors.teal),
                      title: Text(
                        l10n.settingsCryptoInAppMissionsTitle,
                      ),
                      subtitle: Text(
                        l10n.settingsCryptoInAppMissionsSubtitle,
                      ),
                      value: _inAppCryptoMission,
                      onChanged: (value) => _updateCryptoNotificationPreference(
                        'inAppCryptoMission',
                        value,
                      ),
                    ),
                    SwitchListTile(
                      secondary: const Icon(
                        Icons.workspace_premium,
                        color: Colors.cyanAccent,
                      ),
                      title: Text(
                        l10n.settingsCryptoInAppLeaderboardTitle,
                      ),
                      subtitle: Text(
                        l10n.settingsCryptoInAppLeaderboardSubtitle,
                      ),
                      value: _inAppCryptoLeaderboard,
                      onChanged: (value) => _updateCryptoNotificationPreference(
                        'inAppCryptoLeaderboard',
                        value,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              if (_settings?['isVip'] == true)
                Card(
                  color: Colors.amber[900],
                  child: ListTile(
                    leading: const Icon(Icons.star, color: Colors.amber),
                    title: Text(l10n.vipStatus),
                    subtitle: Text(
                      _settings?['vipExpiresAt'] != null
                          ? l10n.activeUntil(
                              DateTime.parse(_settings!['vipExpiresAt'])
                                  .toLocal()
                                  .toString()
                                  .split(' ')[0],
                            )
                          : l10n.unknown,
                    ),
                  ),
                ),
            ],
          );

    if (widget.embedded) {
      return content;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('⚙️ ${l10n.settings}'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadSettings),
        ],
      ),
      body: content,
    );
  }
}
