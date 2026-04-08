import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/vehicle.dart';
import '../services/auth_service.dart';
import '../config/app_config.dart';

class VehicleProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  static String get baseUrl => AppConfig.apiBaseUrl;

  List<VehicleInventoryItem> _inventory = [];
  GarageStatus? _garageStatus;
  MarinaStatus? _marinaStatus;
  List<VehicleDefinition> _availableVehicles = [];
  List<MarketListing> _marketListings = [];
  VehicleInventoryItem? _lastStolenVehicle;
  int _lastStealCooldownRemainingSeconds = 0;
  bool _lastStealArrested = false;
  int _lastStealJailMinutes = 0;
  double? _lastStealWantedLevel;
  int? _lastStealBailAmount;
  int _lastStealXpGained = 0;
  Map<String, dynamic>? _policeVehicleEvent;
  Map<String, int> _tuningParts = {'car': 0, 'motorcycle': 0, 'boat': 0};
  List<Map<String, dynamic>> _tuningVehicles = [];
  bool _isLoading = false;
  String? _error;

  List<VehicleInventoryItem> get inventory => _inventory;
  GarageStatus? get garageStatus => _garageStatus;
  MarinaStatus? get marinaStatus => _marinaStatus;
  List<VehicleDefinition> get availableVehicles => _availableVehicles;
  List<MarketListing> get marketListings => _marketListings;
  VehicleInventoryItem? get lastStolenVehicle => _lastStolenVehicle;
  int get lastStealCooldownRemainingSeconds =>
      _lastStealCooldownRemainingSeconds;
  bool get lastStealArrested => _lastStealArrested;
  int get lastStealJailMinutes => _lastStealJailMinutes;
  double? get lastStealWantedLevel => _lastStealWantedLevel;
  int? get lastStealBailAmount => _lastStealBailAmount;
  int get lastStealXpGained => _lastStealXpGained;
  Map<String, dynamic>? get policeVehicleEvent => _policeVehicleEvent;
  Map<String, int> get tuningParts => _tuningParts;
  List<Map<String, dynamic>> get tuningVehicles => _tuningVehicles;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Get road vehicles from inventory (cars + motorcycles)
  List<VehicleInventoryItem> get cars => _inventory
      .where((v) => v.vehicleType == 'car' || v.vehicleType == 'motorcycle')
      .toList();

  // Get boats from inventory
  List<VehicleInventoryItem> get boats =>
      _inventory.where((v) => v.vehicleType == 'boat').toList();

  int _extractCooldownSeconds(Map<String, dynamic> responseData) {
    final params = responseData['params'] as Map<String, dynamic>?;
    final fromParams = (params?['cooldownRemainingSeconds'] as num?)?.toInt();
    if (fromParams != null && fromParams > 0) {
      return fromParams;
    }

    final fromRoot = (responseData['cooldownRemainingSeconds'] as num?)
        ?.toInt();
    if (fromRoot != null && fromRoot > 0) {
      return fromRoot;
    }

    final message = [
      params?['reason']?.toString(),
      params?['message']?.toString(),
      responseData['message']?.toString(),
    ].whereType<String>().join(' ').toLowerCase();

    final minuteMatch = RegExp(
      r'(\d+)\s*(minuut|minuten|minute|minutes)',
    ).firstMatch(message);
    if (minuteMatch != null) {
      return (int.tryParse(minuteMatch.group(1) ?? '0') ?? 0) * 60;
    }

    final secondMatch = RegExp(
      r'(\d+)\s*(sec|secs|seconde|seconden|second|seconds)',
    ).firstMatch(message);
    if (secondMatch != null) {
      return int.tryParse(secondMatch.group(1) ?? '0') ?? 0;
    }

    return 0;
  }

  Future<Map<String, String>> _getHeaders() async {
    final token = await _authService.apiClient.getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  /// Fetch player's vehicle inventory
  Future<void> fetchInventory() async {
    print('[VehicleProvider] fetchInventory() called');
    _isLoading = true;
    _error = null;

    try {
      print('[VehicleProvider] Getting headers...');
      final headers = await _getHeaders();
      print('[VehicleProvider] Fetching from $baseUrl/vehicles/inventory');
      final response = await http.get(
        Uri.parse('$baseUrl/vehicles/inventory'),
        headers: headers,
      );

      print('[VehicleProvider] Response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> inventoryData = data['inventory'] ?? [];
        print('[VehicleProvider] Received ${inventoryData.length} vehicles');
        _inventory = inventoryData
            .map((item) => VehicleInventoryItem.fromJson(item))
            .toList();
        _error = null;
      } else {
        print('[VehicleProvider] Error response: ${response.body}');
        try {
          final err = json.decode(response.body) as Map<String, dynamic>;
          _error = _getErrorMessage(err['params']?['reason']?.toString());
        } catch (_) {
          _error = 'Kon inventaris niet laden';
        }
      }
    } catch (e) {
      print('[VehicleProvider] Exception: $e');
      _error = 'Er is een fout opgetreden';
    } finally {
      _isLoading = false;
      notifyListeners();
      print('[VehicleProvider] fetchInventory() complete - error: $_error');
    }
  }

  /// Fetch available vehicles in a country
  Future<void> fetchAvailableVehicles(String country) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/vehicles/available/$country'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> vehiclesData = data['vehicles'] ?? [];
        _availableVehicles = vehiclesData
            .map((item) => VehicleDefinition.fromJson(item))
            .toList();
        _policeVehicleEvent = data['policeVehicleEvent'] is Map<String, dynamic>
            ? data['policeVehicleEvent'] as Map<String, dynamic>
            : null;
        notifyListeners();
      }
    } catch (e) {
      _error = 'Er is een fout opgetreden';
      notifyListeners();
    }
  }

  /// Fetch global stealable vehicle catalog (all models, not player inventory)
  Future<void> fetchStealableCatalog({String category = 'road'}) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/vehicles'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final dynamic vehiclesNode = data['vehicles'];
        final List<dynamic> carsData = vehiclesNode is Map<String, dynamic>
            ? (vehiclesNode['cars'] as List<dynamic>? ?? <dynamic>[])
            : <dynamic>[];
        final List<dynamic> boatsData = vehiclesNode is Map<String, dynamic>
            ? (vehiclesNode['boats'] as List<dynamic>? ?? <dynamic>[])
            : <dynamic>[];
        final List<dynamic> motorcyclesData =
            vehiclesNode is Map<String, dynamic>
            ? ((vehiclesNode['motorcycles'] as List<dynamic>?) ??
                  (vehiclesNode['motorbikes'] as List<dynamic>?) ??
                  (vehiclesNode['bikes'] as List<dynamic>?) ??
                  <dynamic>[])
            : <dynamic>[];

        // Fallback: some payload versions may return a single list with mixed categories.
        final List<dynamic> allVehiclesData = vehiclesNode is List<dynamic>
            ? vehiclesNode
            : [...carsData, ...boatsData, ...motorcyclesData];
        final List<dynamic> inferredMotorcycles = allVehiclesData.where((item) {
          if (item is! Map<String, dynamic>) return false;
          final category = (item['vehicleCategory'] ?? item['type'] ?? '')
              .toString()
              .toLowerCase();
          if (category == 'motorcycle') return true;
          final id = (item['id'] ?? '').toString().toLowerCase();
          return id.contains('motorcycle') ||
              id.contains('moto') ||
              id.contains('bike');
        }).toList();
        final List<dynamic> normalizedMotorcycles = motorcyclesData.isNotEmpty
            ? motorcyclesData
            : inferredMotorcycles;

        List<dynamic> catalog;
        switch (category) {
          case 'car':
            catalog = carsData;
            break;
          case 'boat':
            catalog = boatsData;
            break;
          case 'motorcycle':
            catalog = normalizedMotorcycles;
            break;
          case 'road':
          default:
            catalog = [...carsData, ...normalizedMotorcycles];
            break;
        }

        _availableVehicles = catalog
            .map(
              (item) =>
                  VehicleDefinition.fromJson(item as Map<String, dynamic>),
            )
            .toList();
        _policeVehicleEvent = null;
        _error = null;
        notifyListeners();
      } else {
        _error = 'Kon catalogus niet laden';
        notifyListeners();
      }
    } catch (e) {
      _error = 'Er is een fout opgetreden';
      notifyListeners();
    }
  }

  /// Steal a vehicle
  Future<bool> stealVehicle(String country, String vehicleType) async {
    try {
      _lastStolenVehicle = null;
      _lastStealCooldownRemainingSeconds = 0;
      _lastStealArrested = false;
      _lastStealJailMinutes = 0;
      _lastStealWantedLevel = null;
      _lastStealBailAmount = null;
      _lastStealXpGained = 0;

      // Fetch available vehicles in the country from backend
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/vehicles/available/$country'),
        headers: headers,
      );

      if (response.statusCode != 200) {
        _error = 'Kon beschikbare voertuigen niet ophalen';
        notifyListeners();
        return false;
      }

      final data = json.decode(response.body);
      _policeVehicleEvent = data['policeVehicleEvent'] is Map<String, dynamic>
          ? data['policeVehicleEvent'] as Map<String, dynamic>
          : _policeVehicleEvent;
      final vehiclesData = data['vehicles'];

      if (vehiclesData == null) {
        _error = 'Geen voertuigen data ontvangen';
        notifyListeners();
        return false;
      }

      // Convert to list if needed
      List<dynamic> allVehicles;
      if (vehiclesData is List) {
        allVehicles = vehiclesData;
      } else {
        _error = 'Ongeldig voertuigen formaat';
        notifyListeners();
        return false;
      }

      if (allVehicles.isEmpty) {
        _error = 'Geen voertuigen beschikbaar in $country';
        notifyListeners();
        return false;
      }

      // Filter by exact vehicle category; do not mix car/motorcycle selections.
      final List<dynamic> availableVehicles = allVehicles.where((v) {
        if (v == null || v['id'] == null) return false;

        if (v['vehicleCategory'] != null) {
          final category = v['vehicleCategory'].toString().toLowerCase();
          final matches = category == vehicleType;
          print(
            '[VehicleProvider] Filter - id=${v['id']}, category=$category, want=$vehicleType, matches=$matches',
          );
          return matches;
        }

        // Fallback: old id-based detection for payloads without vehicleCategory.
        final id = v['id'].toString().toLowerCase();
        final isBoat =
            id.contains('boat') || id.contains('yacht') || id.contains('ship');
        final isMotorcycle =
            id.contains('moto') ||
            id.contains('bike') ||
            id.contains('motorcycle');

        if (vehicleType == 'boat') return isBoat;
        if (vehicleType == 'motorcycle') return isMotorcycle;
        return !isBoat && !isMotorcycle;
      }).toList();

      if (availableVehicles.isEmpty) {
        final typeLabel = vehicleType == 'car'
            ? 'auto\'s'
            : (vehicleType == 'boat' ? 'boten' : 'motoren');
        _error = 'Geen $typeLabel beschikbaar in $country';
        notifyListeners();
        return false;
      }

      // Pick random vehicle
      final randomIndex = DateTime.now().millisecond % availableVehicles.length;
      final vehicle = availableVehicles[randomIndex];
      final vehicleId = vehicle['id']?.toString() ?? '';

      print(
        '[VehicleProvider] Random vehicle selected: $vehicleId (${vehicle['name']})',
      );

      if (vehicleId.isEmpty) {
        _error = 'Ongeldig voertuig ID';
        notifyListeners();
        return false;
      }

      // Steal it
      final stealResponse = await http.post(
        Uri.parse('$baseUrl/vehicles/steal/$vehicleId'),
        headers: headers,
      );

      final stealData = json.decode(stealResponse.body);

      print(
        '[VehicleProvider] Steal response: statusCode=${stealResponse.statusCode}, event=${stealData['event']}, reason=${stealData['params']?['reason']}',
      );

      if (stealResponse.statusCode == 200 &&
          stealData['event'] == 'vehicles.stolen') {
        final arrested = stealData['params']?['arrested'] == true;
        _lastStealArrested = arrested;
        _lastStealJailMinutes =
            (stealData['params']?['jailTime'] as num?)?.toInt() ?? 0;
        _lastStealWantedLevel = (stealData['params']?['wantedLevel'] as num?)
            ?.toDouble();
        _lastStealBailAmount = (stealData['params']?['bail'] as num?)?.toInt();
        _lastStealXpGained =
            (stealData['params']?['xpGained'] as num?)?.toInt() ?? 0;

        // Theft can succeed but player can still be arrested immediately after.
        // In that case treat it as a failed action for UI flow.
        if (arrested) {
          await fetchInventory();

          _error =
              stealData['params']?['message']?.toString() ??
              stealData['message']?.toString() ??
              'Je bent opgepakt na de diefstal';
          notifyListeners();
          return false;
        }

        final vehicleJson = stealData['vehicle'];
        if (vehicleJson is Map<String, dynamic>) {
          try {
            _lastStolenVehicle = VehicleInventoryItem.fromJson(vehicleJson);
          } catch (_) {
            _lastStolenVehicle = null;
          }
        }

        // Refresh inventory
        await fetchInventory();
        return true;
      } else {
        // Get error message from response
        final reason = stealData['params']?['reason'];
        _lastStealCooldownRemainingSeconds = _extractCooldownSeconds(stealData);
        _lastStealArrested = stealData['params']?['arrested'] == true;
        _lastStealJailMinutes =
            (stealData['params']?['jailTime'] as num?)?.toInt() ?? 0;
        _lastStealWantedLevel = (stealData['params']?['wantedLevel'] as num?)
            ?.toDouble();
        _lastStealBailAmount = (stealData['params']?['bail'] as num?)?.toInt();
        _lastStealXpGained =
            (stealData['params']?['xpGained'] as num?)?.toInt() ?? 0;

        // Try to get a more descriptive message
        String errorMsg = _getErrorMessage(reason?.toString());
        if (stealData['message'] != null) {
          errorMsg = stealData['message'].toString();
        } else if (stealData['params']?['message'] != null) {
          errorMsg = stealData['params']['message'].toString();
        }

        print('[VehicleProvider] Error: $errorMsg');
        _error = errorMsg;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _lastStolenVehicle = null;
      _lastStealWantedLevel = null;
      _lastStealBailAmount = null;
      _lastStealXpGained = 0;
      _error = 'Er is een fout opgetreden';
      notifyListeners();
      return false;
    }
  }

  /// Sell a vehicle
  Future<bool> sellVehicle(int inventoryId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/vehicles/sell-stolen/$inventoryId'),
        headers: headers,
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200 &&
          data['event'] == 'vehicles.stolen_sold') {
        // Refresh inventory
        await fetchInventory();
        return true;
      } else {
        _error = _getErrorMessage(data['params']?['reason']?.toString());
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Er is een fout opgetreden';
      notifyListeners();
      return false;
    }
  }

  /// Scrap a vehicle for salvage value.
  /// Returns a map with `partsGained` (int) and `partsType` (String) on success, null on failure.
  Future<Map<String, dynamic>?> scrapVehicle(int inventoryId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/vehicles/scrap/$inventoryId'),
        headers: headers,
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['event'] == 'vehicles.scrapped') {
        final partsType =
            (data['params']?['partsType'] as String?)?.toLowerCase() ?? 'car';
        final rawGained = data['params']?['partsGained'];
        final partsGained = rawGained is num
            ? rawGained.toInt()
            : int.tryParse(rawGained?.toString() ?? '') ?? 0;
        if (_tuningParts.containsKey(partsType) && partsGained > 0) {
          _tuningParts[partsType] =
              (_tuningParts[partsType] ?? 0) + partsGained;
        }
        final partsData = (data['parts'] as Map<String, dynamic>?) ?? const {};
        if (partsData.isNotEmpty) {
          _tuningParts = {
            'car':
                (partsData['car'] as num?)?.toInt() ?? _tuningParts['car'] ?? 0,
            'motorcycle':
                (partsData['motorcycle'] as num?)?.toInt() ??
                _tuningParts['motorcycle'] ??
                0,
            'boat':
                (partsData['boat'] as num?)?.toInt() ??
                _tuningParts['boat'] ??
                0,
          };
        }
        // Refresh inventory only; avoid forcing TuneShop endpoint during Garage/Marina actions.
        await fetchInventory();
        return {'partsGained': partsGained, 'partsType': partsType};
      } else {
        final reason = data['params']?['reason']?.toString();
        _error = _getErrorMessage(reason);
        notifyListeners();
        return null;
      }
    } catch (e) {
      _error = 'Er is een fout opgetreden';
      notifyListeners();
      return null;
    }
  }

  Future<void> fetchTuningOverview() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/vehicles/tuning/overview'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final partsData = (data['parts'] as Map<String, dynamic>?) ?? const {};
        _tuningParts = {
          'car': (partsData['car'] as num?)?.toInt() ?? 0,
          'motorcycle': (partsData['motorcycle'] as num?)?.toInt() ?? 0,
          'boat': (partsData['boat'] as num?)?.toInt() ?? 0,
        };

        final vehiclesData =
            (data['vehicles'] as List<dynamic>? ?? <dynamic>[]);
        _tuningVehicles = vehiclesData
            .whereType<Map<String, dynamic>>()
            .toList();
        _error = null;
      } else {
        final data = json.decode(response.body) as Map<String, dynamic>;
        _error = _getErrorMessage(data['params']?['reason']?.toString());
      }
    } catch (e) {
      _error = 'Er is een fout opgetreden';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> upgradeVehicleTuning(int inventoryId, String stat) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/vehicles/tuning/$inventoryId/upgrade'),
        headers: headers,
        body: json.encode({'stat': stat}),
      );

      final data = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200 &&
          data['event'] == 'vehicles.tuning_upgraded') {
        final partsData = (data['parts'] as Map<String, dynamic>?) ?? const {};
        _tuningParts = {
          'car':
              (partsData['car'] as num?)?.toInt() ?? _tuningParts['car'] ?? 0,
          'motorcycle':
              (partsData['motorcycle'] as num?)?.toInt() ??
              _tuningParts['motorcycle'] ??
              0,
          'boat':
              (partsData['boat'] as num?)?.toInt() ?? _tuningParts['boat'] ?? 0,
        };

        await fetchTuningOverview();
        await fetchInventory();
        _error = null;
        notifyListeners();
        return true;
      }

      final reason = data['params']?['reason']?.toString();
      if (reason == 'TUNE_COOLDOWN_ACTIVE') {
        final remaining =
            (data['params']?['cooldownRemainingSeconds'] as num?)?.toInt() ?? 0;
        _error =
            'Tuning cooldown actief: nog ${_formatCooldownSeconds(remaining)}';
      } else {
        _error = _getErrorMessage(reason);
      }
      notifyListeners();
      return false;
    } catch (e) {
      _error = 'Er is een fout opgetreden';
      notifyListeners();
      return false;
    }
  }

  /// Fetch garage status
  Future<void> fetchGarageStatus(String location) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/garage/status/$location'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _garageStatus = GarageStatus.fromJson(data['status']);
        notifyListeners();
      }
    } catch (e) {
      _error = 'Er is een fout opgetreden';
      notifyListeners();
    }
  }

  /// Upgrade garage
  Future<bool> upgradeGarage(String location) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/garage/upgrade'),
        headers: headers,
        body: json.encode({'location': location}),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['event'] == 'garage.upgraded') {
        // Refresh garage status
        await fetchGarageStatus(location);
        return true;
      } else {
        _error = _getErrorMessage(data['params']?['reason']?.toString());
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Er is een fout opgetreden';
      notifyListeners();
      return false;
    }
  }

  /// Fetch marina status
  Future<void> fetchMarinaStatus(String location) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/garage/marina/status/$location'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _marinaStatus = MarinaStatus.fromJson(data['status']);
        notifyListeners();
      }
    } catch (e) {
      _error = 'Er is een fout opgetreden';
      notifyListeners();
    }
  }

  /// Upgrade marina
  Future<bool> upgradeMarina(String location) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/garage/marina/upgrade'),
        headers: headers,
        body: json.encode({'location': location}),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['event'] == 'marina.upgraded') {
        // Refresh marina status
        await fetchMarinaStatus(location);
        return true;
      } else {
        _error = _getErrorMessage(data['params']?['reason']?.toString());
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Er is een fout opgetreden';
      notifyListeners();
      return false;
    }
  }

  /// Fetch market listings
  Future<void> fetchMarketListings({String? country}) async {
    try {
      final headers = await _getHeaders();
      final url = country != null
          ? '$baseUrl/market/vehicles?country=$country'
          : '$baseUrl/market/vehicles';

      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> listingsData = data['listings'] ?? [];
        _marketListings = listingsData.map((item) {
          return MarketListing(
            id: item['id'],
            vehicle: VehicleInventoryItem.fromJson(item),
            sellerUsername: item['player']['username'],
            sellerId: item['player']['id'],
          );
        }).toList();
        notifyListeners();
      }
    } catch (e) {
      _error = 'Er is een fout opgetreden';
      notifyListeners();
    }
  }

  /// List vehicle on market
  Future<bool> listVehicleOnMarket(int inventoryId, int askingPrice) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/market/list/$inventoryId'),
        headers: headers,
        body: json.encode({'askingPrice': askingPrice}),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['event'] == 'market.listed') {
        await fetchInventory();
        return true;
      } else {
        _error = _getErrorMessage(data['params']?['reason']?.toString());
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Er is een fout opgetreden';
      notifyListeners();
      return false;
    }
  }

  /// Buy vehicle from market
  Future<bool> buyVehicle(int inventoryId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/market/buy/$inventoryId'),
        headers: headers,
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['event'] == 'market.purchased') {
        await fetchInventory();
        await fetchMarketListings();
        return true;
      } else {
        _error = _getErrorMessage(data['params']?['reason']?.toString());
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Er is een fout opgetreden';
      notifyListeners();
      return false;
    }
  }

  /// Delist vehicle from market
  Future<bool> delistVehicle(int inventoryId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/market/delist/$inventoryId'),
        headers: headers,
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['event'] == 'market.delisted') {
        await fetchInventory();
        return true;
      } else {
        _error = _getErrorMessage(data['params']?['reason']?.toString());
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Er is een fout opgetreden';
      notifyListeners();
      return false;
    }
  }

  /// Refuel vehicle
  Future<bool> refuelVehicle(int vehicleId, int fuelAmount) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/vehicles/$vehicleId/refuel'),
        headers: headers,
        body: json.encode({'amount': fuelAmount}),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['event'] == 'vehicles.refueled') {
        await fetchInventory();
        _error = null;
        notifyListeners();
        return true;
      } else {
        _error = _getErrorMessage(data['params']?['reason']);
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Er is een fout opgetreden';
      notifyListeners();
      return false;
    }
  }

  /// Repair vehicle
  Future<bool> repairVehicle(int vehicleId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/vehicles/$vehicleId/repair'),
        headers: headers,
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200 &&
          data['event'] == 'vehicles.repair_started') {
        await fetchInventory();
        _error = null;
        notifyListeners();
        return true;
      } else {
        _error = _getErrorMessage(data['params']?['reason']);
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Er is een fout opgetreden';
      notifyListeners();
      return false;
    }
  }

  String _getErrorMessage(String? reason) {
    switch (reason) {
      case 'VEHICLE_NOT_FOUND':
        return 'Voertuig niet gevonden';
      case 'INSUFFICIENT_FUNDS':
        return 'Niet genoeg geld';
      case 'FUEL_TANK_FULL':
        return 'Tank is al vol';
      case 'VEHICLE_NOT_BROKEN':
        return 'Voertuig is niet beschadigd';
      case 'VEHICLE_REPAIR_IN_PROGRESS':
        return 'Voertuig is al in reparatie';
      case 'REPAIR_CONCURRENCY_LIMIT_REACHED':
        return 'Limiet bereikt: zonder VIP max 1 reparatie tegelijk, met VIP max 5';
      case 'INSUFFICIENT_PARTS':
        return 'Niet genoeg onderdelen';
      case 'TUNE_STAT_MAXED':
        return 'Dit tuningniveau is maximaal';
      case 'TUNE_COOLDOWN_ACTIVE':
        return 'Tuning cooldown actief';
      case 'TUNE_CONCURRENCY_LIMIT_REACHED':
        return 'Limiet bereikt: zonder VIP max 1 tuning tegelijk, met VIP max 5';
      case 'INVALID_TUNE_STAT':
        return 'Ongeldige tuning keuze';
      case 'USE_SMUGGLING_HUB':
        return 'Gebruik de Smokkel Hub om voertuigen te verplaatsen';
      case 'INVALID_AMOUNT':
        return 'Ongeldig bedrag';
      default:
        return 'Er is een fout opgetreden';
    }
  }

  String _formatCooldownSeconds(int seconds) {
    final safe = seconds < 0 ? 0 : seconds;
    final minutes = safe ~/ 60;
    final secs = safe % 60;
    if (minutes > 0) {
      return '${minutes}m ${secs}s';
    }
    return '${secs}s';
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
