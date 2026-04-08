import 'package:flutter/material.dart';
import '../models/carried_tool.dart';
import '../models/storage_info.dart';
import '../services/inventory_service.dart';
import '../l10n/app_localizations.dart';
import '../utils/top_right_notification.dart';

class TransferDialog extends StatefulWidget {
  final CarriedTool tool;
  final String fromLocation;
  final VoidCallback onTransferSuccess;

  const TransferDialog({
    super.key,
    required this.tool,
    required this.fromLocation,
    required this.onTransferSuccess,
  });

  @override
  State<TransferDialog> createState() => _TransferDialogState();
}

class _TransferDialogState extends State<TransferDialog> {
  final InventoryService _inventoryService = InventoryService();
  List<StorageInfo> _storageList = [];
  String? _selectedDestination;
  int _quantity = 1;
  bool _isLoading = true;
  bool _isTransferring = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _quantity = widget.tool.quantity;
    _loadDestinations();
  }

  Future<void> _loadDestinations() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    // If transferring FROM carried, load storage options
    if (widget.fromLocation == 'carried') {
      final result = await _inventoryService.getStorageOverview();
      if (mounted) {
        setState(() {
          _isLoading = false;
          if (result['success']) {
            _storageList = result['storage'];
            if (_storageList.isNotEmpty) {
              _selectedDestination = 'property_${_storageList[0].propertyId}';
            }
          } else {
            _error = result['error'];
          }
        });
      }
    } else {
      // Transferring TO carried from storage
      setState(() {
        _isLoading = false;
        _selectedDestination = 'carried';
      });
    }
  }

  Future<void> _transfer() async {
    if (_selectedDestination == null) return;

    setState(() {
      _isTransferring = true;
      _error = null;
    });

    final result = await _inventoryService.transferTool(
      toolId: widget.tool.toolId,
      fromLocation: widget.fromLocation,
      toLocation: _selectedDestination!,
      quantity: _quantity,
    );

    if (mounted) {
      setState(() {
        _isTransferring = false;
      });

      if (result['success']) {
        showTopRightFromSnackBar(context, 
          SnackBar(
            content: Text(AppLocalizations.of(context)!.transferSuccess(
              widget.tool.name,
              _selectedDestination == 'carried' 
                  ? AppLocalizations.of(context)!.carried 
                  : AppLocalizations.of(context)!.storage,
            )),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
        widget.onTransferSuccess();
      } else {
        setState(() {
          _error = result['error'];
        });
      }
    }
  }

  String _getPropertyName(String propertyType) {
    return propertyType[0].toUpperCase() + propertyType.substring(1);
  }

  String _getPropertyIcon(String propertyType) {
    switch (propertyType.toLowerCase()) {
      case 'apartment':
        return '🏢';
      case 'house':
        return '🏠';
      case 'villa':
        return '🏰';
      case 'warehouse':
        return '🏭';
      case 'safehouse':
        return '🔒';
      case 'penthouse':
        return '🌆';
      default:
        return '🏗️';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      backgroundColor: Colors.grey[850],
      title: Text(
        l10n.transferTool,
        style: const TextStyle(color: Colors.white),
      ),
      content: _isLoading
          ? const SizedBox(
              height: 100,
              child: Center(child: CircularProgressIndicator(color: Colors.amber)),
            )
          : _error != null
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error, color: Colors.red, size: 48),
                    const SizedBox(height: 16),
                    Text(
                      _error!,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ],
                )
              : SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tool info
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[800],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.build, color: Colors.amber, size: 32),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.tool.name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    '${l10n.quantity}: ${widget.tool.quantity}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[400],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Quantity selector (if more than 1)
                      if (widget.tool.quantity > 1) ...[
                        Text(
                          l10n.selectQuantity,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[400],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            IconButton(
                              onPressed: _quantity > 1
                                  ? () => setState(() => _quantity--)
                                  : null,
                              icon: const Icon(Icons.remove_circle),
                              color: Colors.amber,
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  _quantity.toString(),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: _quantity < widget.tool.quantity
                                  ? () => setState(() => _quantity++)
                                  : null,
                              icon: const Icon(Icons.add_circle),
                              color: Colors.amber,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Destination selector
                      Text(
                        l10n.destination,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[400],
                        ),
                      ),
                      const SizedBox(height: 8),

                      if (widget.fromLocation == 'carried')
                        // Select property
                        _storageList.isEmpty
                            ? Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.red),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.error, color: Colors.red),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        l10n.noProperties,
                                        style: const TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : DropdownButtonFormField<String>(
                                initialValue: _selectedDestination,
                                dropdownColor: Colors.grey[800],
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey[800],
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                items: _storageList.map((storage) {
                                  return DropdownMenuItem<String>(
                                    value: 'property_${storage.propertyId}',
                                    child: Row(
                                      children: [
                                        Text(
                                          _getPropertyIcon(storage.propertyType),
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                        const SizedBox(width: 8),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              _getPropertyName(storage.propertyType),
                                              style: const TextStyle(color: Colors.white),
                                            ),
                                            Text(
                                              '${storage.usage}/${storage.capacity} ${l10n.slots}',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[400],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedDestination = value;
                                  });
                                },
                              )
                      else
                        // Transfer to carried
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.backpack, color: Colors.amber),
                              const SizedBox(width: 12),
                              Text(
                                l10n.carried,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
      actions: [
        TextButton(
          onPressed: _isTransferring ? null : () => Navigator.pop(context),
          child: Text(
            l10n.cancel,
            style: const TextStyle(color: Colors.grey),
          ),
        ),
        ElevatedButton(
          onPressed: _isTransferring || _selectedDestination == null || (_storageList.isEmpty && widget.fromLocation == 'carried')
              ? null
              : _transfer,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber,
            foregroundColor: Colors.black,
          ),
          child: _isTransferring
              ? const SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.black,
                  ),
                )
              : Text(l10n.transfer),
        ),
      ],
    );
  }
}
