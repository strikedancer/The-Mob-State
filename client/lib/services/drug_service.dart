import 'dart:convert';
import './api_client.dart';
import '../models/drug_models.dart';

class DrugService {
  final ApiClient _apiClient = ApiClient();

  int _facilityOrder(String facilityType) {
    switch (facilityType) {
      case 'greenhouse':
        return 0;
      case 'mushroom_farm':
        return 1;
      case 'drug_lab':
        return 2;
      case 'crack_kitchen':
        return 3;
      case 'darkweb_storefront':
        return 4;
      default:
        return 999;
    }
  }

  // Get all available drugs
  Future<List<DrugDefinition>> getDrugCatalog() async {
    try {
      final response = await _apiClient.get('/drugs/catalog');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          final List<dynamic> drugsJson = data['drugs'] ?? [];
          return drugsJson
              .map((json) => DrugDefinition.fromJson(json))
              .toList();
        }
      }
      return [];
    } catch (e) {
      print('Error loading drug catalog: $e');
      return [];
    }
  }

  // Get all production materials
  Future<List<MaterialDefinition>> getMaterials() async {
    try {
      final response = await _apiClient.get('/drugs/materials');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          final List<dynamic> materialsJson = data['materials'] ?? [];
          return materialsJson
              .map((json) => MaterialDefinition.fromJson(json))
              .toList();
        }
      }
      return [];
    } catch (e) {
      print('Error loading materials: $e');
      return [];
    }
  }

  // Get player's materials
  Future<List<PlayerMaterial>> getPlayerMaterials() async {
    try {
      final response = await _apiClient.get('/drugs/my-materials');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          final List<dynamic> materialsJson = data['materials'] ?? [];
          return materialsJson
              .map((json) => PlayerMaterial.fromJson(json))
              .toList();
        }
      }
      return [];
    } catch (e) {
      print('Error loading player materials: $e');
      return [];
    }
  }

  // Buy material
  Future<Map<String, dynamic>> buyMaterial(
    String materialId,
    int quantity,
  ) async {
    try {
      final response = await _apiClient.post(
        '/drugs/materials/buy/$materialId',
        {'quantity': quantity},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      }
      return {'success': false, 'message': 'Failed to buy material'};
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  // Start production
  Future<Map<String, dynamic>> startProduction(
    String drugId,
    int? propertyId,
  ) async {
    try {
      final Map<String, dynamic> body = {'drugId': drugId};
      if (propertyId != null) body['propertyId'] = propertyId;

      final response = await _apiClient.post('/drugs/start-production', body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      }
      return {'success': false, 'message': 'Failed to start production'};
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  // Get active productions
  Future<List<DrugProduction>> getActiveProductions() async {
    try {
      final response = await _apiClient.get('/drugs/productions');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          final List<dynamic> productionsJson = data['productions'] ?? [];
          return productionsJson
              .map((json) => DrugProduction.fromJson(json))
              .toList();
        }
      }
      return [];
    } catch (e) {
      print('Error loading productions: $e');
      return [];
    }
  }

  // Collect production
  Future<Map<String, dynamic>> collectProduction(String productionId) async {
    try {
      final response = await _apiClient.post(
        '/drugs/collect/$productionId',
        {},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      }
      return {'success': false, 'message': 'Failed to collect production'};
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  // Get drug inventory
  Future<List<DrugInventory>> getDrugInventory() async {
    try {
      final response = await _apiClient.get('/drugs/inventory');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          final List<dynamic> inventoryJson = data['inventory'] ?? [];
          return inventoryJson
              .map((json) => DrugInventory.fromJson(json))
              .where((item) => item.quantity > 0)
              .toList();
        }
      }
      return [];
    } catch (e) {
      print('Error loading drug inventory: $e');
      return [];
    }
  }

  // Sell drugs (with quality selection)
  Future<Map<String, dynamic>> sellDrugs(
    String drugType,
    int quantity, {
    String quality = 'C',
  }) async {
    try {
      final response = await _apiClient.post('/drugs/sell', {
        'drugType': drugType,
        'quantity': quantity,
        'quality': quality,
      });
      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      }
      return {'success': false, 'message': 'Failed to sell drugs'};
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  // --- Drug Facility methods ---

  Future<Map<String, dynamic>> getFacilityConfig() async {
    try {
      final response = await _apiClient.get('/drug-facilities/config');
      if (response.statusCode == 200) return json.decode(response.body);
      return {};
    } catch (e) {
      return {};
    }
  }

  Future<List<DrugFacilityInfo>> getMyFacilities() async {
    try {
      final response = await _apiClient.get('/drug-facilities');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          final facilities = (data['facilities'] as List<dynamic>? ?? [])
              .map((f) => DrugFacilityInfo.fromJson(f))
              .toList();
          facilities.sort((a, b) {
            final orderA = _facilityOrder(a.facilityType);
            final orderB = _facilityOrder(b.facilityType);
            if (orderA != orderB) return orderA.compareTo(orderB);
            return a.facilityType.compareTo(b.facilityType);
          });
          return facilities;
        }
      }
      return [];
    } catch (e) {
      print('Error loading facilities: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> buyFacility(String facilityType) async {
    try {
      final response = await _apiClient.post('/drug-facilities/buy', {
        'facilityType': facilityType,
      });
      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      }
      final data = json.decode(response.body);
      return {'success': false, 'message': data['message'] ?? 'Fout'};
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  Future<Map<String, dynamic>> upgradeSlots(int facilityId) async {
    try {
      final response = await _apiClient.post(
        '/drug-facilities/$facilityId/upgrade-slots',
        {},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      }
      final data = json.decode(response.body);
      return {'success': false, 'message': data['message'] ?? 'Fout'};
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  Future<Map<String, dynamic>> upgradeEquipment(
    int facilityId,
    String upgradeType,
  ) async {
    try {
      final response = await _apiClient.post(
        '/drug-facilities/$facilityId/upgrade-equipment',
        {'upgradeType': upgradeType},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      }
      final data = json.decode(response.body);
      return {'success': false, 'message': data['message'] ?? 'Fout'};
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  // --- Market prices ---

  Future<Map<String, DrugMarketPrice>> getMarketPrices() async {
    try {
      final response = await _apiClient.get('/drugs/market-prices');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          final Map<String, dynamic> raw = data['prices'] ?? {};
          return raw.map(
            (id, v) => MapEntry(id, DrugMarketPrice.fromJson(id, v)),
          );
        }
      }
      return {};
    } catch (e) {
      return {};
    }
  }

  // --- Heat ---

  Future<DrugHeatInfo> getDrugHeat() async {
    try {
      final response = await _apiClient.get('/drugs/heat');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) return DrugHeatInfo.fromJson(data);
      }
      return DrugHeatInfo(heat: 0, level: 'Laag', raidChance: 0);
    } catch (e) {
      return DrugHeatInfo(heat: 0, level: 'Laag', raidChance: 0);
    }
  }

  // --- Stats ---

  Future<DrugStats?> getDrugStats() async {
    try {
      final response = await _apiClient.get('/drugs/stats');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) return DrugStats.fromJson(data['stats']);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // --- Cut drugs ---

  Future<Map<String, dynamic>> cutDrugs(
    String drugType,
    String quality,
    int quantity,
  ) async {
    try {
      final response = await _apiClient.post('/drugs/cut', {
        'drugType': drugType,
        'quality': quality,
        'quantity': quantity,
      });
      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      }
      return {'success': false, 'message': 'Failed to cut drugs'};
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  // --- Auto-collect toggle (VIP) ---

  Future<Map<String, dynamic>> toggleAutoCollect() async {
    try {
      final response = await _apiClient.post('/drugs/auto-collect-toggle', {});
      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      }
      return {'success': false, 'message': 'Failed'};
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  // --- Smuggling ---

  Future<Map<String, dynamic>> sendSmugglingShipment({
    required String destinationCountry,
    required String drugType,
    required int quantity,
    String quality = 'C',
  }) async {
    try {
      final response = await _apiClient.post('/drugs/smuggling/send', {
        'destinationCountry': destinationCountry,
        'drugType': drugType,
        'quantity': quantity,
        'quality': quality,
      });
      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      }
      return {'success': false, 'message': 'Failed to send shipment'};
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  Future<Map<String, dynamic>> getSmugglingOverview() async {
    try {
      final response = await _apiClient.get('/drugs/smuggling/overview');
      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      }
      return {'success': false, 'shipments': [], 'depots': []};
    } catch (e) {
      return {'success': false, 'shipments': [], 'depots': []};
    }
  }

  Future<Map<String, dynamic>> claimCurrentDepotShipments() async {
    try {
      final response = await _apiClient.post(
        '/drugs/smuggling/claim-current',
        {},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      }
      return {'success': false, 'message': 'Failed to claim depot shipments'};
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }
}
