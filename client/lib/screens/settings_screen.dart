import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../config/app_config.dart';
import '../providers/locale_provider.dart';
import '../l10n/app_localizations.dart';
import '../services/user_preferences_service.dart';
import '../utils/top_right_notification.dart';

class SettingsScreen extends StatefulWidget {
  final bool embedded;

  const SettingsScreen({super.key, this.embedded = false});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isLoading = true;
  Map<String, dynamic>? _settings;
  List<String> _freeAvatars = [];
  List<String> _vipAvatars = [];
  bool _allowMessages = true;
  bool _showVideos = true;
  bool _pushCryptoTrade = true;
  bool _pushCryptoPriceAlert = true;
  bool _pushCryptoOrder = true;
  bool _pushCryptoMission = true;
  bool _pushCryptoLeaderboard = true;
  bool _inAppCryptoTrade = true;
  bool _inAppCryptoPriceAlert = true;
  bool _inAppCryptoOrder = true;
  bool _inAppCryptoMission = true;
  bool _inAppCryptoLeaderboard = true;
  String _selectedLanguage = 'nl';
  String? _error;

  bool get _isDutch => Localizations.localeOf(context).languageCode == 'nl';

  @override
  void initState() {
    super.initState();
    _loadSettings();
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

        final notificationPreferences =
            (_settings?['notificationPreferences'] as Map<String, dynamic>?) ??
            <String, dynamic>{};
        _pushCryptoTrade = notificationPreferences['pushCryptoTrade'] ?? true;
        _pushCryptoPriceAlert =
            notificationPreferences['pushCryptoPriceAlert'] ?? true;
        _pushCryptoOrder = notificationPreferences['pushCryptoOrder'] ?? true;
        _pushCryptoMission =
            notificationPreferences['pushCryptoMission'] ?? true;
        _pushCryptoLeaderboard =
            notificationPreferences['pushCryptoLeaderboard'] ?? true;
        _inAppCryptoTrade = notificationPreferences['inAppCryptoTrade'] ?? true;
        _inAppCryptoPriceAlert =
            notificationPreferences['inAppCryptoPriceAlert'] ?? true;
        _inAppCryptoOrder = notificationPreferences['inAppCryptoOrder'] ?? true;
        _inAppCryptoMission =
            notificationPreferences['inAppCryptoMission'] ?? true;
        _inAppCryptoLeaderboard =
            notificationPreferences['inAppCryptoLeaderboard'] ?? true;
      }

      _showVideos = await UserPreferencesService.getShowVideosEnabled();

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

      setState(() {
        _isLoading = false;
      });
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
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(
              data['event'] == 'error.avatar_cooldown'
                  ? 'Je kunt maar 1x per week je avatar wijzigen'
                  : 'Avatar wijzigen mislukt',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        showTopRightFromSnackBar(
          context,
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
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
            content: Text('Language change failed (${response.statusCode})'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('[Settings] Language change error: $e');
      if (mounted) {
        showTopRightFromSnackBar(
          context,
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
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
                  'Je kunt maar 1x per maand je naam wijzigen',
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
                            ? 'Je kunt maar 1x per maand je naam wijzigen'
                            : 'Naam wijzigen mislukt',
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
                      content: Text('Error: $e'),
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
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _updateVideoSettings(bool value) async {
    await UserPreferencesService.setShowVideosEnabled(value);
    if (!mounted) return;

    setState(() {
      _showVideos = value;
    });

    final l10n = AppLocalizations.of(context)!;
    showTopRightFromSnackBar(
      context,
      SnackBar(
        content: Text(l10n.settingsSaved),
        backgroundColor: Colors.green,
      ),
    );
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
          _pushCryptoTrade = prefs['pushCryptoTrade'] ?? _pushCryptoTrade;
          _pushCryptoPriceAlert =
              prefs['pushCryptoPriceAlert'] ?? _pushCryptoPriceAlert;
          _pushCryptoOrder = prefs['pushCryptoOrder'] ?? _pushCryptoOrder;
          _pushCryptoMission = prefs['pushCryptoMission'] ?? _pushCryptoMission;
          _pushCryptoLeaderboard =
              prefs['pushCryptoLeaderboard'] ?? _pushCryptoLeaderboard;
          _inAppCryptoTrade = prefs['inAppCryptoTrade'] ?? _inAppCryptoTrade;
          _inAppCryptoPriceAlert =
              prefs['inAppCryptoPriceAlert'] ?? _inAppCryptoPriceAlert;
          _inAppCryptoOrder = prefs['inAppCryptoOrder'] ?? _inAppCryptoOrder;
          _inAppCryptoMission =
              prefs['inAppCryptoMission'] ?? _inAppCryptoMission;
          _inAppCryptoLeaderboard =
              prefs['inAppCryptoLeaderboard'] ?? _inAppCryptoLeaderboard;
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
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
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
                    l10n.freeAvatars,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
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
    final isSelected = avatar == _settings?['avatar'];
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
            // Avatar image
            ClipRRect(
              borderRadius: BorderRadius.circular(7),
              child: Image.asset(
                'assets/images/avatars/$avatar.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback to letter if image not found
                  return Center(
                    child: Text(
                      avatar[0].toUpperCase(),
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: isLocked ? Colors.grey[600] : Colors.white,
                      ),
                    ),
                  );
                },
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
                  subtitle: Text(_settings?['avatar'] ?? 'default_1'),
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
                    _selectedLanguage == 'nl'
                        ? '🇳🇱 ${l10n.dutch}'
                        : '🇬🇧 ${l10n.english}',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(l10n.chooseLanguage),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: const Text(
                                '🇳🇱',
                                style: TextStyle(fontSize: 24),
                              ),
                              title: Text(l10n.dutch),
                              trailing: _selectedLanguage == 'nl'
                                  ? const Icon(Icons.check, color: Colors.green)
                                  : null,
                              onTap: () {
                                _changeLanguage('nl');
                                Navigator.of(context).pop();
                              },
                            ),
                            ListTile(
                              leading: const Text(
                                '🇬🇧',
                                style: TextStyle(fontSize: 24),
                              ),
                              title: Text(l10n.english),
                              trailing: _selectedLanguage == 'en'
                                  ? const Icon(Icons.check, color: Colors.green)
                                  : null,
                              onTap: () {
                                _changeLanguage('en');
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
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
                child: SwitchListTile(
                  secondary: const Icon(Icons.movie, color: Colors.redAccent),
                  title: Text(
                    Localizations.localeOf(context).languageCode == 'nl'
                        ? 'Video\'s tonen'
                        : 'Show videos',
                  ),
                  subtitle: Text(
                    Localizations.localeOf(context).languageCode == 'nl'
                        ? 'Uit = direct resultaat zonder afspeelvideo'
                        : 'Off = show result directly without playback video',
                  ),
                  value: _showVideos,
                  onChanged: _updateVideoSettings,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _isDutch ? 'Crypto Notificaties' : 'Crypto Notifications',
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
                      title: Text(_isDutch ? 'Push: Trades' : 'Push: Trades'),
                      subtitle: Text(
                        _isDutch
                            ? 'Pushmelding bij koop/verkoop'
                            : 'Push notification for buy/sell trades',
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
                        _isDutch ? 'Push: Prijsalerts' : 'Push: Price alerts',
                      ),
                      subtitle: Text(
                        _isDutch
                            ? 'Pushmelding bij belangrijke prijsbewegingen'
                            : 'Push notification for relevant price moves',
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
                      title: Text(_isDutch ? 'Push: Orders' : 'Push: Orders'),
                      subtitle: Text(
                        _isDutch
                            ? 'Pushmelding wanneer order triggert of gevuld is'
                            : 'Push notification when order is triggered or filled',
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
                        _isDutch ? 'Push: Missies' : 'Push: Missions',
                      ),
                      subtitle: Text(
                        _isDutch
                            ? 'Pushmelding wanneer een crypto missie voltooid is'
                            : 'Push notification when a crypto mission is completed',
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
                        _isDutch ? 'Push: Leaderboard' : 'Push: Leaderboard',
                      ),
                      subtitle: Text(
                        _isDutch
                            ? 'Pushmelding bij crypto leaderboard beloningen'
                            : 'Push notification for crypto leaderboard rewards',
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
                        _isDutch ? 'In-app: Trades' : 'In-app: Trades',
                      ),
                      subtitle: Text(
                        _isDutch
                            ? 'Toon trade-events in je event feed'
                            : 'Show trade events in your event feed',
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
                        _isDutch
                            ? 'In-app: Prijsalerts'
                            : 'In-app: Price alerts',
                      ),
                      subtitle: Text(
                        _isDutch
                            ? 'Toon prijsalert-events in je event feed'
                            : 'Show price alert events in your event feed',
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
                        _isDutch ? 'In-app: Orders' : 'In-app: Orders',
                      ),
                      subtitle: Text(
                        _isDutch
                            ? 'Toon order-events in je event feed'
                            : 'Show order events in your event feed',
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
                        _isDutch ? 'In-app: Missies' : 'In-app: Missions',
                      ),
                      subtitle: Text(
                        _isDutch
                            ? 'Toon missie-voltooiingen in je event feed'
                            : 'Show mission completions in your event feed',
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
                        _isDutch
                            ? 'In-app: Leaderboard'
                            : 'In-app: Leaderboard',
                      ),
                      subtitle: Text(
                        _isDutch
                            ? 'Toon leaderboard beloningen in je event feed'
                            : 'Show leaderboard rewards in your event feed',
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
                          ? 'Active until ${DateTime.parse(_settings!['vipExpiresAt']).toLocal().toString().split(' ')[0]}'
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
