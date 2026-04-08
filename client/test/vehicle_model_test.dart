import 'dart:convert';
import 'package:mafia_game_client/models/vehicle.dart';

void main() {
  // Test data from backend
  final testJson = '''
  {
    "id": 4,
    "playerId": 2,
    "vehicleType": "car",
    "vehicleId": "sports_car",
    "stolenInCountry": "switzerland",
    "currentLocation": "switzerland",
    "condition": 100,
    "fuelLevel": 25,
    "marketListing": false,
    "askingPrice": null,
    "stolenAt": "2026-01-31T16:17:45.214Z",
    "definition": {
      "id": "sports_car",
      "name": "Ferrari 458",
      "type": "speed",
      "image": "ferrari.png",
      "stats": {
        "speed": 95,
        "armor": 15,
        "cargo": 10,
        "stealth": 30
      },
      "description": "Extreem snel",
      "availableInCountries": ["italy", "france", "switzerland"],
      "baseValue": 250000,
      "marketValue": {
        "netherlands": 280000,
        "belgium": 275000,
        "germany": 260000,
        "france": 250000,
        "italy": 245000,
        "switzerland": 290000
      },
      "fuelCapacity": 40,
      "requiredRank": 15
    }
  }
  ''';

  try {
    final json = jsonDecode(testJson) as Map<String, dynamic>;
    final vehicle = VehicleInventoryItem.fromJson(json);
    
    print('✅ Successfully parsed vehicle:');
    print('  ID: ${vehicle.id}');
    print('  Type: ${vehicle.vehicleType}');
    print('  Vehicle ID: ${vehicle.vehicleId}');
    print('  Location: ${vehicle.currentLocation}');
    print('  Stolen At: ${vehicle.createdAt}');
    print('  Definition: ${vehicle.definition?.name}');
    print('\n✅ All fields parsed correctly!');
  } catch (e, stackTrace) {
    print('❌ Error parsing vehicle:');
    print(e);
    print(stackTrace);
  }
}
