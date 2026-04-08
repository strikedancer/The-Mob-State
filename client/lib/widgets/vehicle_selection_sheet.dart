import 'dart:convert';
import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';  // Unused
import '../l10n/app_localizations.dart';
import '../models/vehicle_crime.dart';
// import '../providers/vehicle_provider.dart';  // Unused
import '../services/api_client.dart';
import 'vehicle_stats_display.dart';
import '../utils/top_right_notification.dart';

/// Bottom sheet for selecting a vehicle for crimes
class VehicleSelectionSheet extends StatefulWidget {
  final Vehicle? currentSelected;
  final Function(Vehicle) onVehicleSelected;

  const VehicleSelectionSheet({
    super.key,
    this.currentSelected,
    required this.onVehicleSelected,
  });

  @override
  State<VehicleSelectionSheet> createState() => _VehicleSelectionSheetState();
}

class _VehicleSelectionSheetState extends State<VehicleSelectionSheet> {
  bool _isLoading = true;
  List<Vehicle> _vehicles = [];
  String? _error;
  Vehicle? _selectedVehicle;

  @override
  void initState() {
    super.initState();
    _selectedVehicle = widget.currentSelected;
    _loadVehicles();
  }

  Future<void> _loadVehicles() async {
    try {
      final apiClient = ApiClient();
      final response = await apiClient.get('/garage/vehicles');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final List<dynamic> data = responseData['vehicles'] ?? [];
        setState(() {
          _vehicles = data
              .map((v) => Vehicle.fromJson(v as Map<String, dynamic>))
              .toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Failed to load vehicles';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Kon voertuigen niet laden';
        _isLoading = false;
      });
    }
  }

  Future<void> _selectVehicle(Vehicle vehicle) async {
    try {
      final apiClient = ApiClient();
      final response = await apiClient.post('/garage/crime-vehicle', {
        'vehicleId': vehicle.id,
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        widget.onVehicleSelected(vehicle);
        if (mounted) {
          showTopRightFromSnackBar(
            context,
            SnackBar(
              content: Text(
                '${vehicle.vehicleType} ${AppLocalizations.of(context)!.selectCrimeVehicle}',
              ),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
          Navigator.pop(context);
        }
      }
    } catch (e) {
      if (mounted) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text('Er is een fout opgetreden'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.selectCrimeVehicle,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // Content
          if (_isLoading)
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: CircularProgressIndicator(),
            )
          else if (_error != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(_error!, style: TextStyle(color: Colors.red)),
            )
          else if (_vehicles.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                l10n.noVehicleSelected,
                style: TextStyle(color: Colors.grey),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                itemCount: _vehicles.length,
                itemBuilder: (context, index) {
                  final vehicle = _vehicles[index];
                  final isSelected = _selectedVehicle?.id == vehicle.id;
                  return VehicleStatsDisplay(
                    vehicle: vehicle,
                    isSelected: isSelected,
                    onTap: () => _selectVehicle(vehicle),
                  );
                },
              ),
            ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

/// Wrapper function to show vehicle selection sheet
Future<Vehicle?> showVehicleSelection(
  BuildContext context, {
  Vehicle? currentSelected,
  required Function(Vehicle) onVehicleSelected,
}) async {
  final result = await showModalBottomSheet<Vehicle>(
    context: context,
    builder: (context) => VehicleSelectionSheet(
      currentSelected: currentSelected,
      onVehicleSelected: (vehicle) {
        onVehicleSelected(vehicle);
        Navigator.pop(context, vehicle);
      },
    ),
    isScrollControlled: true,
  );
  return result;
}
