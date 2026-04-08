# Crime Outcome System - Frontend UI Implementation

## Overview

Three new Flutter widgets have been created to support the vehicle/tool degradation crime system:

1. **VehicleStatsDisplay** - Shows vehicle stats with visual bars and action buttons
2. **CrimeOutcomeDisplay** - Shows detailed crime outcome results
3. **VehicleSelectionSheet** - Bottom sheet for selecting vehicles for crimes

## Widget Files

### 1. VehicleStatsDisplay (`vehicle_stats_display.dart`)

**Purpose**: Display vehicle stats with condition/fuel indicators

**Key Features**:
- Shows vehicle type
- Displays 4 stat bars: Speed, Armor, Stealth, Cargo
- Condition and fuel status bars with color coding
- Repair and Refuel buttons
- Selected vehicle highlight (amber border)

**Usage Example**:
```dart
VehicleStatsDisplay(
  vehicle: myVehicle,
  isSelected: true,
  onTap: () => selectVehicle(myVehicle),
  onRepair: () => repairVehicle(myVehicle),
  onRefuel: () => refuelVehicle(myVehicle),
)
```

### 2. CrimeOutcomeDisplay (`crime_outcome_display.dart`)

**Purpose**: Show crime result with details

**Key Features**:
- Color-coded outcome display (success=green, caught=red, etc.)
- Shows reward, XP gained
- Displays vehicle condition loss
- Displays tool damage
- Emoji indicators for quick recognition
- Dismiss button

**Usage Example**:
```dart
showDialog(
  context: context,
  builder: (context) => AlertDialog(
    content: CrimeOutcomeDisplay(
      outcome: crimeResult['outcome'],
      message: crimeResult['outcomeMessage'],
      success: crimeResult['success'],
      reward: crimeResult['reward'],
      xpGained: crimeResult['xpGained'],
      vehicleConditionLoss: crimeResult['vehicleConditionLoss'],
      toolDamageSustained: crimeResult['toolDamageSustained'],
      onDismiss: () => Navigator.pop(context),
    ),
  ),
);
```

### 3. VehicleSelectionSheet (`vehicle_selection_sheet.dart`)

**Purpose**: Allow player to select vehicle for crimes

**Key Features**:
- Bottom sheet UI
- Shows all player vehicles
- Highlights currently selected vehicle
- Sets vehicle via API call
- Error handling and loading states

**Usage Example**:
```dart
final selection = await showVehicleSelection(
  context,
  currentSelected: currentVehicle,
  onVehicleSelected: (vehicle) {
    print('Selected: ${vehicle.vehicleType}');
  },
);
```

## Integration Steps

### Step 1: Update Crime Screen

In `crime_screen.dart`, add these imports:

```dart
import '../models/vehicle.dart';
import '../widgets/vehicle_stats_display.dart';
import '../widgets/crime_outcome_display.dart';
import '../widgets/vehicle_selection_sheet.dart';
```

### Step 2: Add State Variables

In `_CrimeScreenState`, add:

```dart
class _CrimeScreenState extends State<CrimeScreen> {
  // ... existing variables ...
  
  // NEW: Vehicle selection
  Vehicle? _selectedCrimeVehicle;
  bool _loadingCrimeVehicle = true;
  
  // NEW: Outcome tracking
  String? _lastCrimeOutcome;
  Map<String, dynamic>? _lastCrimeResult;
}
```

### Step 3: Load Selected Vehicle on Init

In `initState()`:

```dart
@override
void initState() {
  super.initState();
  _checkJailStatusAndLoadCrimes();
  _loadTools();
  _loadCrimeVehicle();  // NEW
}

Future<void> _loadCrimeVehicle() async {
  try {
    final response = await _apiClient.get('/garage/crime-vehicle');
    if (response.statusCode == 200 && response.data != null) {
      setState(() {
        _selectedCrimeVehicle = Vehicle.fromJson(response.data);
        _loadingCrimeVehicle = false;
      });
    } else {
      setState(() => _loadingCrimeVehicle = false);
    }
  } catch (e) {
    setState(() => _loadingCrimeVehicle = false);
  }
}
```

### Step 4: Add Vehicle Selection UI

In the `build()` method, add above the crime cards list:

```dart
// Vehicle Selection Card
if (!_loadingCrimeVehicle) ...[
  Padding(
    padding: const EdgeInsets.all(12.0),
    child: Card(
      color: Colors.grey[800],
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Icon(Icons.directions_car, color: Colors.cyan),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Crime Vehicle',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _selectedCrimeVehicle?.vehicleType ?? 'None Selected',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: _selectedCrimeVehicle != null ? Colors.cyan : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton.icon(
              onPressed: _selectVehicle,
              icon: Icon(Icons.edit),
              label: Text('Select'),
            ),
          ],
        ),
      ),
    ),
  ),
  const SizedBox(height: 8),
],

// Condition warnings
if (_selectedCrimeVehicle != null) ...[
  if (_selectedCrimeVehicle!.condition! < 30)
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.orange.withOpacity(0.2),
          border: Border.all(color: Colors.orange),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Icon(Icons.warning, color: Colors.orange, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Vehicle condition low (${_selectedCrimeVehicle!.condition!.toStringAsFixed(1)}%)',
                style: TextStyle(color: Colors.orange, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    ),
  if (_selectedCrimeVehicle!.fuel! < 15)
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.2),
          border: Border.all(color: Colors.red),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Icon(Icons.warning, color: Colors.red, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Fuel critically low (${_selectedCrimeVehicle!.fuel}/${_selectedCrimeVehicle!.maxFuel})',
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    ),
],
```

### Step 5: Add Vehicle Selection Method

Add to `_CrimeScreenState`:

```dart
Future<void> _selectVehicle() async {
  final selected = await showVehicleSelection(
    context,
    currentSelected: _selectedCrimeVehicle,
    onVehicleSelected: (vehicle) {
      setState(() => _selectedCrimeVehicle = vehicle);
    },
  );
  
  if (selected != null) {
    // Vehicle already saved via API in the sheet
    // Just update local state if needed
  }
}
```

### Step 6: Update Crime Attempt Method

Modify the crime attempt call in `_attemptCrime()`:

```dart
Future<void> _attemptCrime(Crime crime) async {
  // ... existing checks ...
  
  try {
    // Add outcome tracking to response
    final response = await _apiClient.post('/crimes/attempt', {
      'crimeId': crime.id,
      // vehicleId is now automatic from selected vehicle
    });

    if (response.statusCode == 200) {
      final result = response.data;
      
      // NEW: Store outcome details
      setState(() {
        _lastCrimeOutcome = result['outcome'];
        _lastCrimeResult = result;
      });

      // Show outcome display instead of simple alert
      if (mounted) {
        _showCrimeOutcome(result);
      }
      
      // ... rest of existing logic ...
    }
  } catch (e) {
    // Error handling
    print('[CrimeScreen] Crime attempt error: $e');
  }
}

void _showCrimeOutcome(Map<String, dynamic> result) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.grey[900],
      contentPadding: const EdgeInsets.all(20),
      content: CrimeOutcomeDisplay(
        outcome: result['outcome'] as String,
        message: result['outcomeMessage'] as String? ?? 'Crime completed',
        success: result['success'] as bool,
        reward: result['reward'] is int 
          ? result['reward'] as int 
          : (result['reward'] as num).toInt(),
        xpGained: result['xpGained'] is int
          ? result['xpGained'] as int
          : (result['xpGained'] as num).toInt(),
        vehicleConditionLoss: result['vehicleConditionLoss'] as double?,
        toolDamageSustained: result['toolDamageSustained'] as int?,
        onDismiss: () {
          Navigator.pop(context);
          // Refresh vehicle and player data
          _loadCrimeVehicle();
          final authProvider = Provider.of<AuthProvider>(context, listen: false);
          authProvider.refreshPlayer();
        },
      ),
    ),
  );
}
```

### Step 7: Add Localization Keys (if needed)

Verify these exist in `app_en.arb` and `app_nl.arb`:
```json
"selectCrimeVehicle": "Select Vehicle for Crimes",
"noVehicleSelected": "No vehicle selected",
"vehicleSpeed": "Speed",
"vehicleArmor": "Armor",
"vehicleStealth": "Stealth",
"vehicleCargo": "Cargo",
"vehicleCondition": "Condition",
"vehicleFuel": "Fuel",
"vehicleRepair": "Repair",
"vehicleRefuel": "Refuel",
"crimeOutcomeSuccess": "Crime Successful",
"crimeOutcomeCaught": "Caught by Police",
"etc...": "all outcome messages"
```

## Example: Full Integration in Crime Screen

Here's a simplified example of how to integrate into the crime cards section:

```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    // ... existing AppBar, etc. ...
    body: _isLoading
        ? Center(child: CircularProgressIndicator())
        : _buildContent(),
  );
}

Widget _buildContent() {
  return ListView(
    children: [
      // NEW: Vehicle Selection
      if (!_loadingCrimeVehicle)
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: _buildVehicleCard(),
        ),
      
      // NEW: Warning messages
      if (_selectedCrimeVehicle != null)
        ..._buildWarnings(),
      
      // Existing: Crime cards
      ..._crimes.map((crime) => CrimeCard(crime: crime)),
    ],
  );
}

Widget _buildVehicleCard() {
  return Card(
    child: ListTile(
      leading: Icon(Icons.directions_car),
      title: Text(_selectedCrimeVehicle?.vehicleType ?? 'No Vehicle'),
      subtitle: Text('Condition: ${_selectedCrimeVehicle?.condition?.toStringAsFixed(1)}%'),
      trailing: Icon(Icons.edit),
      onTap: _selectVehicle,
    ),
  );
}

List<Widget> _buildWarnings() {
  final warnings = <Widget>[];
  
  if (_selectedCrimeVehicle!.condition! < 30) {
    warnings.add(_buildWarning('Condition Low', Colors.orange));
  }
  
  if (_selectedCrimeVehicle!.fuel! < 15) {
    warnings.add(_buildWarning('Fuel Critical', Colors.red));
  }
  
  return warnings;
}
```

## Testing Checklist

After integration:

- [ ] Vehicle selection button appears on crime screen
- [ ] Clicking button opens vehicle selection sheet
- [ ] Can select a vehicle
- [ ] Selected vehicle shows with highlight
- [ ] Warning appears for low condition (<30%)
- [ ] Warning appears for low fuel (<15%)
- [ ] Crime outcome display shows after attempting crime
- [ ] Outcome shows correct icons and colors
- [ ] Vehicle condition loss displays correctly
- [ ] Tool damage displays correctly
- [ ] Dismiss button closes dialog

## Common Issues

### Issue: "Vehicle not loading"
- Check API endpoint `/garage/crime-vehicle` returns data
- Verify player has vehicles

### Issue: "Outcome not displaying"
- Check API response includes `outcome` field
- Verify crime response maps correctly

### Issue: "Widgets not appearing"
- Rebuild app: `flutter pub get`, then `flutter run`
- Check imports are correct

## Next Steps

1. Integrate vehicle selection into crime screen
2. Test vehicle selection
3. Test crime outcomes display
4. Add vehicle selection to garage repair/refuel
5. Polish UI animations
