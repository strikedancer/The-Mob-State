import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/vehicle.dart';
import '../config/app_config.dart';
import '../l10n/app_localizations.dart';
import '../utils/country_helper.dart';
import '../utils/top_right_notification.dart';

class PlayerProfileScreen extends StatefulWidget {
  final int playerId;
  final String username;

  const PlayerProfileScreen({
    super.key,
    required this.playerId,
    required this.username,
  });

  @override
  State<PlayerProfileScreen> createState() => _PlayerProfileScreenState();
}

class _PlayerProfileScreenState extends State<PlayerProfileScreen> {
  bool _isLoading = true;
  Map<String, dynamic>? _playerData;
  List<VehicleInventoryItem> _playerListings = [];
  String? _error;

  bool get _isNl => Localizations.localeOf(context).languageCode == 'nl';
  String _tr(String nl, String en) => _isNl ? nl : en;

  @override
  void initState() {
    super.initState();
    _loadPlayerProfile();
  }

  Future<void> _loadPlayerProfile() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      const storage = FlutterSecureStorage();
      final token = await storage.read(key: 'auth_token');

      if (token == null) {
        setState(() {
          _error = 'Niet ingelogd';
          _isLoading = false;
        });
        return;
      }

      // Fetch player profile
      final profileResponse = await http.get(
        Uri.parse('${AppConfig.apiBaseUrl}/players/${widget.playerId}/profile'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (profileResponse.statusCode == 200) {
        final responseBody = profileResponse.body;
        print('Profile response: $responseBody');
        _playerData = jsonDecode(responseBody);
        print('Parsed player data: $_playerData');
      } else {
        print('Failed to load profile: ${profileResponse.statusCode}');
        print('Response body: ${profileResponse.body}');
        setState(() {
          _error =
              'Profiel kon niet worden geladen (${profileResponse.statusCode})';
          _isLoading = false;
        });
        return;
      }

      // Fetch player's market listings (don't fail if this fails)
      try {
        final listingsResponse = await http.get(
          Uri.parse(
            '${AppConfig.apiBaseUrl}/market/player/${widget.playerId}/listings',
          ),
          headers: {'Authorization': 'Bearer $token'},
        );

        if (listingsResponse.statusCode == 200) {
          final data = jsonDecode(listingsResponse.body);
          _playerListings = (data['listings'] as List)
              .map((json) => VehicleInventoryItem.fromJson(json))
              .toList();
        } else {
          print('Failed to load listings: ${listingsResponse.statusCode}');
        }
      } catch (listingsError) {
        print('Error loading listings (non-critical): $listingsError');
        // Continue anyway - listings are optional
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e, stackTrace) {
      print('Error loading profile: $e');
      print('Stack trace: $stackTrace');
      setState(() {
        _error = 'Fout bij laden: $e';
        _isLoading = false;
      });
    }
  }

  void _sendMessage() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${_tr('Bericht naar', 'Message to')} ${widget.username}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: _tr('Bericht', 'Message'),
                hintText: _tr('Typ je bericht...', 'Type your message...'),
              ),
              maxLines: 3,
              onChanged: (value) {
                // Store message
              },
            ),
            const SizedBox(height: 16),
            Text(
              _tr('Berichtensysteem komt binnenkort!', 'Messaging system coming soon!'),
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(_tr('Sluiten', 'Close')),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('👤 ${widget.username}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadPlayerProfile,
            tooltip: 'Ververs',
          ),
        ],
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
                    onPressed: _loadPlayerProfile,
                    child: Text(_tr('Opnieuw proberen', 'Try again')),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPlayerHeader(),
                  const SizedBox(height: 24),
                  _buildPlayerStats(),
                  const SizedBox(height: 24),
                  _buildCrewInfo(),
                  const SizedBox(height: 24),
                  _buildPlayerListings(),
                ],
              ),
            ),
    );
  }

  Widget _buildPlayerHeader() {
    final avatar = _playerData?['avatar'] ?? 'default_1';
    final isVip = _playerData?['isVip'] ?? false;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.blue[700],
                  child: Text(
                    avatar.toString().isNotEmpty
                        ? avatar.toString()[0].toUpperCase()
                        : '?',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (isVip)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.amber, Colors.orange],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.star,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.username,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.star, size: 16, color: Colors.yellow[700]),
                      const SizedBox(width: 4),
                      Text(
                        'Reputatie: ${_playerData?['reputation'] ?? 0}',
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ElevatedButton.icon(
              onPressed: _sendMessage,
              icon: const Icon(Icons.message, size: 18),
              label: Text(_tr('Bericht', 'Message')),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerStats() {
    final l10n = AppLocalizations.of(context);
    final level = _playerData?['level'] ?? 0;
    final rankTitle = _playerData?['rankTitle'] ?? 'Unknown';
    final rankIcon = _playerData?['rankIcon'] ?? '❓';
    final reputation = _playerData?['reputation'] ?? 0;
    final currentCountry = _playerData?['currentCountry'] ?? 'unknown';
    final countryName = l10n != null
        ? CountryHelper.getLocalizedCountryName(currentCountry.toString(), l10n)
        : currentCountry.toString();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _tr('Speler Statistieken', 'Player Statistics'),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildStatRow('Level', level.toString()),
            _buildStatRow(_tr('Rang', 'Rank'), '$rankIcon $rankTitle'),
            _buildStatRow(_tr('Reputatie', 'Reputation'), reputation.toString()),
            _buildStatRow(_tr('Land', 'Country'), countryName),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[400])),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildCrewInfo() {
    final crewName = _playerData?['crewName'];
    final crewRole = _playerData?['crewRole'];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _tr('Crew Informatie', 'Crew Information'),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            if (crewName != null) ...[
              Row(
                children: [
                  Icon(Icons.group, color: Colors.purple[300], size: 20),
                  const SizedBox(width: 8),
                  Text(
                    crewName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              if (crewRole != null) ...[
                const SizedBox(height: 4),
                Text(
                  '${_tr('Rol', 'Role')}: $crewRole',
                  style: TextStyle(color: Colors.grey[400]),
                ),
              ],
            ] else
              Text(
                _tr('Geen crew', 'No crew'),
                style: TextStyle(
                  color: Colors.grey[400],
                  fontStyle: FontStyle.italic,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerListings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              _tr('Te Koop Items', 'Items for Sale'),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue[700],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${_playerListings.length}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (_playerListings.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Text(
                  _tr('Geen items te koop', 'No items for sale'),
                  style: TextStyle(color: Colors.grey[400]),
                ),
              ),
            ),
          )
        else
          ..._playerListings.map((listing) => _buildListingCard(listing)),
      ],
    );
  }

  Widget _buildListingCard(VehicleInventoryItem vehicle) {
    final selectedImage = vehicle.conditionImage;
    final askingPrice = vehicle.askingPrice ?? 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(8),
              ),
              child: selectedImage != null
                  ? Image.asset(
                      'images/vehicles/$selectedImage',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        vehicle.vehicleType == 'car'
                            ? Icons.directions_car
                            : Icons.directions_boat,
                        color: Colors.grey[600],
                      ),
                    )
                  : Icon(
                      vehicle.vehicleType == 'car'
                          ? Icons.directions_car
                          : Icons.directions_boat,
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    vehicle.definition?.name ?? 'Unknown',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '€${askingPrice.toStringAsFixed(0)}',
                    style: const TextStyle(color: Colors.green),
                  ),
                  Text(
                    '${_tr('Conditie', 'Condition')}: ${vehicle.condition}%',
                    style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () => _buyVehicleFromProfile(vehicle),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: Text(_tr('Koop', 'Buy')),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _buyVehicleFromProfile(VehicleInventoryItem vehicle) async {
    try {
      const storage = FlutterSecureStorage();
      final token = await storage.read(key: 'auth_token');

      if (token == null) {
        if (mounted) {
          showTopRightFromSnackBar(context, 
            SnackBar(
              content: Text(_tr('Niet ingelogd', 'Not logged in')),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      final response = await http.post(
        Uri.parse('${AppConfig.apiBaseUrl}/market/buy/${vehicle.id}'),
        headers: {'Authorization': 'Bearer $token'},
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && mounted) {
        showTopRightFromSnackBar(context, 
          SnackBar(
              content: Text(_tr('Voertuig succesvol gekocht!', 'Vehicle purchased successfully!')),
            backgroundColor: Colors.green,
          ),
        );
        // Refresh listings
        _loadPlayerProfile();
      } else if (mounted) {
        showTopRightFromSnackBar(context, 
          SnackBar(
            content: Text(data['params']?['reason'] ?? 'Aankoop mislukt'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        showTopRightFromSnackBar(context, 
          SnackBar(content: Text('${_tr('Fout', 'Error')}: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }
}
