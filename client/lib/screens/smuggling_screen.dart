import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../services/smuggling_service.dart';
import '../utils/formatters.dart';
import '../utils/top_right_notification.dart';

class SmugglingScreen extends StatefulWidget {
  const SmugglingScreen({super.key});

  @override
  State<SmugglingScreen> createState() => _SmugglingScreenState();
}

class _SmugglingScreenState extends State<SmugglingScreen> {
  final SmugglingService _smugglingService = SmugglingService();
  final TextEditingController _quantityController = TextEditingController(
    text: '1',
  );

  bool _isLoading = true;
  bool _isSending = false;
  bool _isClaiming = false;

  String _selectedCategory = 'drug';
  String? _selectedItemKey;
  String? _selectedDestination;
  String _selectedChannel = 'courier';
  String _selectedNetworkScope = 'personal';
  String _selectedTransportMode = 'commercial';
  String? _selectedOwnedTransportKey;

  List<dynamic> _destinations = [];
  List<dynamic> _channels = ['package', 'courier', 'container'];
  List<dynamic> _ownedTransports = [];
  bool _canUseCrewNetwork = false;
  Map<String, dynamic> _categories = {
    'drug': <dynamic>[],
    'trade': <dynamic>[],
    'vehicle': <dynamic>[],
    'weapon': <dynamic>[],
    'ammo': <dynamic>[],
  };

  List<dynamic> _shipments = [];
  List<dynamic> _depots = [];
  Map<String, dynamic>? _quote;
  bool _isQuoteLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    final catalog = await _smugglingService.getCatalog(
      networkScope: _selectedNetworkScope,
    );
    final overview = await _smugglingService.getOverview();

    if (!mounted) return;

    final categories = (catalog['categories'] is Map<String, dynamic>)
        ? (catalog['categories'] as Map<String, dynamic>)
        : <String, dynamic>{};

    final destinations = (catalog['destinations'] as List<dynamic>?) ?? [];
    final ownedTransports = (catalog['ownedTransports'] as List<dynamic>?) ?? [];

    setState(() {
      _categories = {
        'drug': categories['drug'] ?? <dynamic>[],
        'trade': categories['trade'] ?? <dynamic>[],
        'vehicle': categories['vehicle'] ?? <dynamic>[],
        'weapon': categories['weapon'] ?? <dynamic>[],
        'ammo': categories['ammo'] ?? <dynamic>[],
      };
      _destinations = destinations;
      _channels =
          (catalog['channels'] as List<dynamic>?) ??
          ['package', 'courier', 'container'];
      _ownedTransports = ownedTransports;
      _canUseCrewNetwork = catalog['canUseCrewNetwork'] == true;
      final selectedNetwork = catalog['selectedNetworkScope']?.toString();
      if (selectedNetwork == 'crew' || selectedNetwork == 'personal') {
        _selectedNetworkScope = selectedNetwork!;
      }
      if (!_canUseCrewNetwork) {
        _selectedNetworkScope = 'personal';
      }
      if (_selectedNetworkScope == 'crew') {
        _selectedTransportMode = 'commercial';
      }
      if (!_channels.contains(_selectedChannel)) {
        _selectedChannel = 'courier';
      }
      final availableOwnedTransport = ownedTransports.whereType<Map<String, dynamic>>().toList();
      if (availableOwnedTransport.isEmpty) {
        _selectedOwnedTransportKey = null;
        _selectedTransportMode = 'commercial';
      } else if (
          _selectedOwnedTransportKey == null ||
          !availableOwnedTransport.any(
            (transport) => transport['transportKey']?.toString() == _selectedOwnedTransportKey,
          )) {
        _selectedOwnedTransportKey = availableOwnedTransport.first['transportKey']?.toString();
      }
      _shipments = (overview['shipments'] as List<dynamic>?) ?? [];
      _depots = (overview['depots'] as List<dynamic>?) ?? [];

      final itemsForCategory =
          (_categories[_selectedCategory] as List<dynamic>?) ?? [];
      _selectedItemKey = itemsForCategory.isNotEmpty
          ? itemsForCategory.first['itemKey']?.toString()
          : null;
      _selectedDestination = destinations.isNotEmpty
          ? destinations.first['id']?.toString()
          : null;
      _quote = null;
      _isLoading = false;
    });

    await _loadQuote();
  }

  List<dynamic> get _currentItems =>
      (_categories[_selectedCategory] as List<dynamic>? ?? []);

  List<dynamic> get _currentOwnedTransports => _ownedTransports;

  dynamic get _selectedItem {
    if (_selectedItemKey == null) return null;
    for (final item in _currentItems) {
      if (item is Map<String, dynamic> &&
          item['itemKey']?.toString() == _selectedItemKey) {
        return item;
      }
    }
    return null;
  }

  Map<String, dynamic>? get _selectedOwnedTransport {
    if (_selectedOwnedTransportKey == null) return null;
    for (final item in _currentOwnedTransports) {
      if (item is Map<String, dynamic> &&
          item['transportKey']?.toString() == _selectedOwnedTransportKey) {
        return item;
      }
    }
    return null;
  }

  String _quoteMessage(AppLocalizations l10n, String? rawMessage) {
    switch (rawMessage) {
      case 'BOAT_CANNOT_FIT':
        return l10n.smugglingQuoteBoatCannotFit;
      case 'CARGO_OVERFLOW':
        return l10n.smugglingQuoteCargoOverflow;
      default:
        return rawMessage?.isNotEmpty == true
            ? rawMessage!
            : l10n.smugglingQuoteUnavailable;
    }
  }

  String _localizeSmugglingApiMessage(AppLocalizations l10n, String? raw) {
    if (raw == null || raw.trim().isEmpty) {
      return l10n.smugglingActionProcessed;
    }
    final s = raw.trim();

    final started = RegExp(
      r'^Smokkelzending \((\w+)\) naar (.+) gestart$',
    ).firstMatch(s);
    if (started != null) {
      final ch = started.group(1)!;
      final dest = started.group(2)!;
      return l10n.smugglingApiShipmentStarted(
        _channelLabel(l10n, ch),
        dest,
      );
    }

    final cooldown = RegExp(
      r'^Wacht (\d+)s voor een nieuwe ([\w]+)-zending$',
    ).firstMatch(s);
    if (cooldown != null) {
      final sec = int.parse(cooldown.group(1)!);
      final chCode = cooldown.group(2)!;
      return l10n.smugglingApiCooldownWait(
        sec,
        _channelLabel(l10n, chCode),
      );
    }

    final qtyHigh = RegExp(
      r'^Hoeveelheid te hoog voor ([\w]+)\. Max: (\d+)$',
    ).firstMatch(s);
    if (qtyHigh != null) {
      final chCode = qtyHigh.group(1)!;
      final max = int.parse(qtyHigh.group(2)!);
      return l10n.smugglingApiQuantityTooHighForChannel(
        _channelLabel(l10n, chCode),
        max,
      );
    }

    final claim = RegExp(
      r'^(\d+) (?:crew-)?zending\(en\) opgehaald in (.+)$',
    ).firstMatch(s);
    if (claim != null) {
      final count = int.parse(claim.group(1)!);
      final country = claim.group(2)!;
      final isCrew = s.contains('crew-');
      return isCrew
          ? l10n.smugglingApiClaimedCrew(count, country)
          : l10n.smugglingApiClaimedPersonal(count, country);
    }

    if (s == 'Shipment failed') return l10n.smugglingClientShipmentFailed;
    if (s == 'Quote failed') return l10n.smugglingClientQuoteFailed;
    if (s == 'Claim failed') return l10n.smugglingClientClaimFailed;
    if (s.startsWith('Error: ')) {
      return l10n.smugglingClientErrorPrefix(s.substring(7));
    }

    switch (s) {
      case 'Ongeldig smokkelkanaal':
        return l10n.smugglingApiInvalidChannel;
      case 'Ongeldige netwerkkeuze':
        return l10n.smugglingApiInvalidNetwork;
      case 'Ongeldige hoeveelheid':
        return l10n.smugglingApiInvalidQuantity;
      case 'Bestemmingsland bestaat niet':
        return l10n.smugglingApiInvalidDestination;
      case 'Speler niet gevonden':
        return l10n.smugglingApiPlayerNotFound;
      case 'Gebruik lokale inventory voor hetzelfde land':
        return l10n.smugglingApiSameCountryInventory;
      case 'Je zit niet in een crew':
        return l10n.smugglingApiNotInCrew;
      case 'Crew-smokkel voor handelswaar is nog niet beschikbaar':
        return l10n.smugglingApiCrewTradeUnavailable;
      case 'Eigen voertuigen werken alleen voor persoonlijke smokkel':
        return l10n.smugglingApiOwnedVehiclesPersonalOnly;
      case 'Kies een eigen voertuig of vliegtuig':
        return l10n.smugglingApiChooseOwnedTransport;
      case 'Gekozen eigen voertuig is niet beschikbaar':
        return l10n.smugglingApiChosenOwnedTransportUnavailable;
      case 'Je kunt hetzelfde voertuig niet als vracht en transport gebruiken':
        return l10n.smugglingApiSameVehicleCargoConflict;
      case 'Auto of motor kan geen ander voertuig vervoeren':
        return l10n.smugglingApiCarCannotCarryOtherVehicle;
      case 'Voertuigen kunnen niet via pakketkanaal':
        return l10n.smugglingApiVehiclesCannotUsePackageChannel;
      case 'BOAT_CANNOT_FIT':
        return l10n.smugglingApiBoatCannotFit;
      case 'CARGO_OVERFLOW':
        return l10n.smugglingApiCargoOverflow;
      case 'Niet genoeg geld voor smokkelkosten':
        return l10n.smugglingApiInsufficientMoney;
      case 'Niet genoeg handelswaar in crew inventory':
        return l10n.smugglingApiInsufficientTradeGoods;
      case 'Niet genoeg drugs in crew inventory':
        return l10n.smugglingApiInsufficientDrugsCrew;
      case 'Niet genoeg drugs in inventory':
        return l10n.smugglingApiInsufficientDrugs;
      case 'Niet genoeg handelswaar in inventory':
        return l10n.smugglingApiInsufficientTradeGoods;
      case 'Niet genoeg wapens in crew inventory':
        return l10n.smugglingApiInsufficientWeaponsCrew;
      case 'Niet genoeg wapens in inventory':
        return l10n.smugglingApiInsufficientWeapons;
      case 'Niet genoeg munitie in crew inventory':
        return l10n.smugglingApiInsufficientAmmoCrew;
      case 'Niet genoeg munitie in inventory':
        return l10n.smugglingApiInsufficientAmmo;
      case 'Ongeldig crew-voertuig':
        return l10n.smugglingApiInvalidCrewVehicle;
      case 'Crew-boot niet beschikbaar voor smokkel':
        return l10n.smugglingApiCrewBoatUnavailable;
      case 'Crew-motor niet beschikbaar voor smokkel':
        return l10n.smugglingApiCrewMotorcycleUnavailable;
      case 'Crew-auto niet beschikbaar voor smokkel':
        return l10n.smugglingApiCrewCarUnavailable;
      case 'Ongeldig voertuig':
        return l10n.smugglingApiInvalidVehicleKey;
      case 'Voertuig niet beschikbaar voor smokkel':
        return l10n.smugglingApiVehicleUnavailableForSmuggling;
      case 'Onvoldoende voorraad voor deze zending':
        return l10n.smugglingApiInsufficientStockForShipment;
      case 'Geen zendingen klaar in dit landdepot':
        return l10n.smugglingApiDepotNoShipmentsReady;
      default:
        return s;
    }
  }

  Future<void> _sendShipment() async {
    final l10n = AppLocalizations.of(context)!;
    final selectedItem = _selectedItem;
    if (selectedItem == null || _selectedDestination == null) {
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(l10n.smugglingSelectItemDestination),
        ),
      );
      return;
    }

    final maxQty = (selectedItem['quantity'] as num?)?.toInt() ?? 1;
    int qty = int.tryParse(_quantityController.text.trim()) ?? 0;
    if (_selectedCategory == 'vehicle') {
      qty = 1;
    }

    if (_selectedTransportMode == 'owned' && _selectedOwnedTransportKey == null) {
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(l10n.smugglingSelectOwnedTransportFirst),
        ),
      );
      return;
    }

    if (qty <= 0 || qty > maxQty) {
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(l10n.smugglingInvalidQuantity),
        ),
      );
      return;
    }

    setState(() => _isSending = true);

    final metadata = <String, dynamic>{};
    if (_selectedCategory == 'drug' && selectedItem['quality'] != null) {
      metadata['quality'] = selectedItem['quality'];
    }
    if (_selectedCategory == 'vehicle' &&
        selectedItem['metadata'] is Map<String, dynamic>) {
      metadata.addAll(selectedItem['metadata'] as Map<String, dynamic>);
    }

    final result = await _smugglingService.sendShipment(
      category: _selectedCategory,
      itemKey: _selectedItemKey!,
      quantity: qty,
      destinationCountry: _selectedDestination!,
      channel: _selectedChannel,
      networkScope: _selectedNetworkScope,
      transportMode: _selectedTransportMode,
      ownedTransportKey: _selectedOwnedTransportKey,
      metadata: metadata,
    );

    if (!mounted) return;

    setState(() => _isSending = false);

    showTopRightFromSnackBar(
      context,
      SnackBar(
        content: Text(
          _localizeSmugglingApiMessage(
            l10n,
            result['message']?.toString(),
          ),
        ),
        backgroundColor: result['success'] == true ? Colors.green : Colors.red,
      ),
    );

    if (result['success'] == true) {
      _quantityController.text = '1';
      await _loadData();
    }
  }

  Future<void> _claimCurrentDepot(String scope) async {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _isClaiming = true);
    final result = await _smugglingService.claimCurrentDepot(scope: scope);

    if (!mounted) return;

    setState(() => _isClaiming = false);

    showTopRightFromSnackBar(
      context,
      SnackBar(
        content: Text(
          _localizeSmugglingApiMessage(
            l10n,
            result['message']?.toString(),
          ),
        ),
        backgroundColor: result['success'] == true ? Colors.green : Colors.red,
      ),
    );

    if (result['success'] == true) {
      await _loadData();
    }
  }

  Future<void> _loadQuote() async {
    final selectedItem = _selectedItem;
    if (selectedItem == null ||
        _selectedDestination == null ||
        _selectedItemKey == null) {
      if (mounted) {
        setState(() => _quote = null);
      }
      return;
    }

    int qty = int.tryParse(_quantityController.text.trim()) ?? 0;
    if (_selectedCategory == 'vehicle') {
      qty = 1;
    }

    if (qty <= 0) {
      if (mounted) {
        setState(() => _quote = null);
      }
      return;
    }

    final metadata = <String, dynamic>{};
    if (_selectedCategory == 'drug' && selectedItem['quality'] != null) {
      metadata['quality'] = selectedItem['quality'];
    }
    if (_selectedCategory == 'vehicle' &&
        selectedItem['metadata'] is Map<String, dynamic>) {
      metadata.addAll(selectedItem['metadata'] as Map<String, dynamic>);
    }

    setState(() => _isQuoteLoading = true);

    final result = await _smugglingService.getQuote(
      category: _selectedCategory,
      itemKey: _selectedItemKey!,
      quantity: qty,
      destinationCountry: _selectedDestination!,
      channel: _selectedChannel,
      networkScope: _selectedNetworkScope,
      transportMode: _selectedTransportMode,
      ownedTransportKey: _selectedOwnedTransportKey,
      metadata: metadata,
    );

    if (!mounted) return;

    setState(() {
      _isQuoteLoading = false;
      _quote = result;
    });
  }

  String _categoryLabel(AppLocalizations l10n, String category) {
    switch (category) {
      case 'drug':
        return l10n.smugglingCategoryDrug;
      case 'trade':
        return l10n.smugglingCategoryTrade;
      case 'vehicle':
        return l10n.smugglingCategoryVehicle;
      case 'weapon':
        return l10n.smugglingCategoryWeapon;
      case 'ammo':
        return l10n.smugglingCategoryAmmo;
      default:
        return category;
    }
  }

  IconData _categoryIcon(String category) {
    switch (category) {
      case 'drug':
        return Icons.local_pharmacy;
      case 'trade':
        return Icons.inventory_2;
      case 'vehicle':
        return Icons.local_shipping;
      case 'weapon':
        return Icons.gps_fixed;
      case 'ammo':
        return Icons.bolt;
      default:
        return Icons.category;
    }
  }

  String _channelLabel(AppLocalizations l10n, String channel) {
    switch (channel) {
      case 'package':
        return l10n.smugglingChannelPackage;
      case 'courier':
        return l10n.smugglingChannelCourier;
      case 'container':
        return l10n.smugglingChannelContainer;
      case 'owned':
        return l10n.smugglingChannelOwned;
      default:
        return channel;
    }
  }

  String _networkLabel(AppLocalizations l10n, String network) {
    return network == 'crew'
        ? l10n.smugglingCrew
        : l10n.smugglingPersonal;
  }

  String _channelHintFor(
    AppLocalizations l10n,
    String category,
    String transportMode,
  ) {
    if (transportMode == 'owned') {
      return l10n.smugglingHintOwnedTransport;
    }

    switch (category) {
      case 'vehicle':
        return l10n.smugglingHintVehiclesChannel;
      case 'weapon':
        return l10n.smugglingHintWeaponsChannel;
      case 'ammo':
        return l10n.smugglingHintAmmoChannel;
      case 'drug':
        return l10n.smugglingHintDrugsChannel;
      default:
        return l10n.smugglingHintCompareChannels;
    }
  }

  String _shipmentStatusLabel(AppLocalizations l10n, String status) {
    switch (status) {
      case 'in_transit':
        return l10n.smugglingStatusInTransit;
      case 'ready':
        return l10n.smugglingStatusReady;
      case 'seized':
        return l10n.smugglingStatusSeized;
      case 'claimed':
        return l10n.smugglingStatusClaimed;
      default:
        return l10n.smugglingStatusUnknown;
    }
  }

  String _backgroundAssetForWidth(double width) {
    if (width >= 1200) {
      return 'assets/images/backgrounds/smuggling_hub_bg_desktop.png';
    }
    if (width >= 700) {
      return 'assets/images/backgrounds/smuggling_hub_bg_tablet.png';
    }
    return 'assets/images/backgrounds/smuggling_hub_bg_mobile.png';
  }

  String _emblemAssetForWidth(double width) {
    if (width >= 1200) {
      return 'assets/images/ui/smuggling_hub_emblem_desktop.png';
    }
    if (width >= 700) return 'assets/images/ui/smuggling_hub_emblem_tablet.png';
    return 'assets/images/ui/smuggling_hub_emblem_mobile.png';
  }

  String _crateAssetForWidth(double width) {
    if (width >= 1200) return 'assets/images/ui/smuggling_crate_desktop.png';
    if (width >= 700) return 'assets/images/ui/smuggling_crate_tablet.png';
    return 'assets/images/ui/smuggling_crate_mobile.png';
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(_backgroundAssetForWidth(width)),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        color: Colors.black.withOpacity(0.58),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: _loadData,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildHeader(context),
                    const SizedBox(height: 12),
                    _buildSendPanel(context),
                    const SizedBox(height: 12),
                    _buildDepotsPanel(context),
                    const SizedBox(height: 12),
                    _buildShipmentsPanel(context),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final width = MediaQuery.of(context).size.width;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.55),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        children: [
          Image.asset(
            _emblemAssetForWidth(width),
            width: 56,
            height: 56,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.local_shipping, size: 42, color: Colors.amber),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.smugglingHubTitle,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  l10n.smugglingHubSubtitle,
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ElevatedButton.icon(
                onPressed: _isClaiming
                    ? null
                    : () => _claimCurrentDepot('personal'),
                icon: const Icon(Icons.inventory_2),
                label: Text(l10n.smugglingClaimPersonal),
              ),
              if (_canUseCrewNetwork)
                ElevatedButton.icon(
                  onPressed: _isClaiming
                      ? null
                      : () => _claimCurrentDepot('crew'),
                  icon: const Icon(Icons.groups),
                  label: Text(l10n.smugglingClaimCrew),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSendPanel(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final width = MediaQuery.of(context).size.width;
    final selected = _selectedItem;
    final selectedOwnedTransport = _selectedOwnedTransport;
    final isVehicle = _selectedCategory == 'vehicle';
    final maxQty = (selected is Map<String, dynamic>)
        ? ((selected['quantity'] as num?)?.toInt() ?? 1)
        : 1;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.55),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                _crateAssetForWidth(width),
                width: 28,
                height: 28,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.inventory_2, color: Colors.white),
              ),
              const SizedBox(width: 8),
              Text(
                l10n.smugglingNewShipment,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ['drug', 'trade', 'vehicle', 'weapon', 'ammo'].map((c) {
              final selectedChip = c == _selectedCategory;
              return ChoiceChip(
                selected: selectedChip,
                label: Text(_categoryLabel(l10n, c)),
                avatar: Icon(_categoryIcon(c), size: 18),
                onSelected: (_) {
                        setState(() {
                          _selectedCategory = c;
                          final list = _currentItems;
                          _selectedItemKey = list.isNotEmpty
                              ? list.first['itemKey']?.toString()
                              : null;
                          _quantityController.text = '1';
                        });
                        _loadQuote();
                      },
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
          if (_currentItems.isEmpty)
            Text(
              l10n.smugglingNoItemsInCategory,
              style: const TextStyle(color: Colors.orangeAccent),
            )
          else ...[
            DropdownButtonFormField<String>(
              value: _selectedItemKey,
              dropdownColor: Colors.black87,
              decoration: InputDecoration(
                labelText: l10n.smugglingFieldItem,
                labelStyle: const TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.black45,
                border: const OutlineInputBorder(),
              ),
              items: _currentItems.map((item) {
                final map = item as Map<String, dynamic>;
                final key = map['itemKey']?.toString() ?? '';
                final qty = (map['quantity'] as num?)?.toInt() ?? 0;
                final label =
                    '${map['itemLabel']} • $qty ${map['unitTag'] ?? ''}';
                return DropdownMenuItem<String>(
                  value: key,
                  child: Text(
                    label,
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedItemKey = value;
                  _quantityController.text = '1';
                });
                _loadQuote();
              },
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _selectedDestination,
              dropdownColor: Colors.black87,
              decoration: InputDecoration(
                labelText: l10n.smugglingFieldDestination,
                labelStyle: const TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.black45,
                border: const OutlineInputBorder(),
              ),
              items: _destinations.map((d) {
                final map = d as Map<String, dynamic>;
                return DropdownMenuItem<String>(
                  value: map['id']?.toString(),
                  child: Text(
                    map['name']?.toString() ?? '',
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => _selectedDestination = value);
                _loadQuote();
              },
            ),
            const SizedBox(height: 10),
            Text(
              l10n.smugglingTransport,
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ChoiceChip(
                  selected: _selectedTransportMode == 'commercial',
                  label: Text(l10n.smugglingCommercialChannel),
                  onSelected: (_) {
                    if (_selectedTransportMode == 'commercial') return;
                    setState(() => _selectedTransportMode = 'commercial');
                    _loadQuote();
                  },
                ),
                ChoiceChip(
                  selected: _selectedTransportMode == 'owned',
                  label: Text(l10n.smugglingOwnedVehicleAircraft),
                  onSelected: (_currentOwnedTransports.isEmpty || _selectedNetworkScope == 'crew')
                      ? null
                      : (_) {
                          if (_selectedTransportMode == 'owned') return;
                          setState(() => _selectedTransportMode = 'owned');
                          _loadQuote();
                        },
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (_selectedTransportMode == 'owned' && _selectedNetworkScope != 'crew')
              if (_currentOwnedTransports.isEmpty)
                Text(
                  l10n.smugglingNoOwnedTransportInCountry,
                  style: const TextStyle(color: Colors.orangeAccent),
                )
              else ...[
                DropdownButtonFormField<String>(
                  value: _selectedOwnedTransportKey,
                  dropdownColor: Colors.black87,
                  decoration: InputDecoration(
                    labelText: l10n.smugglingOwnedTransportFieldLabel,
                    labelStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.black45,
                    border: const OutlineInputBorder(),
                  ),
                  items: _currentOwnedTransports.map((transport) {
                    final map = transport as Map<String, dynamic>;
                    final key = map['transportKey']?.toString() ?? '';
                    final slots = (map['cargoSlots'] as num?)?.toInt() ?? 0;
                    final risk = (((map['riskReduction'] as num?)?.toDouble() ?? 0) * 100).toStringAsFixed(0);
                    final label = l10n.smugglingOwnedTransportDropdownRow(
                      map['transportLabel']?.toString() ?? '',
                      slots,
                      risk,
                    );
                    return DropdownMenuItem<String>(
                      value: key,
                      child: Text(
                        label,
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => _selectedOwnedTransportKey = value);
                    _loadQuote();
                  },
                ),
                const SizedBox(height: 10),
                if (selectedOwnedTransport != null)
                  Text(
                    l10n.smugglingOwnedTransportCapacityLine(
                      (selectedOwnedTransport['cargoSlots'] as num?)?.toInt() ?? 0,
                      ((((selectedOwnedTransport['confiscationChance'] as num?)?.toDouble() ?? 0) * 100)).toStringAsFixed(0),
                    ),
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                const SizedBox(height: 10),
              ],
            Text(
              l10n.smugglingNetwork,
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ChoiceChip(
                  selected: _selectedNetworkScope == 'personal',
                  label: Text(l10n.smugglingPersonal),
                  onSelected: (_) async {
                    if (_selectedNetworkScope == 'personal') return;
                    setState(() => _selectedNetworkScope = 'personal');
                    await _loadData();
                  },
                ),
                if (_canUseCrewNetwork)
                  ChoiceChip(
                    selected: _selectedNetworkScope == 'crew',
                    label: Text(l10n.smugglingCrew),
                    onSelected: (_) async {
                      if (_selectedNetworkScope == 'crew') return;
                      setState(() {
                        _selectedNetworkScope = 'crew';
                        if (_selectedTransportMode == 'owned') {
                          _selectedTransportMode = 'commercial';
                        }
                      });
                      await _loadData();
                    },
                  ),
              ],
            ),
            const SizedBox(height: 10),
            if (_selectedTransportMode == 'commercial') ...[
              DropdownButtonFormField<String>(
                value: _selectedChannel,
                dropdownColor: Colors.black87,
                decoration: InputDecoration(
                  labelText: l10n.smugglingChannelField,
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.black45,
                  border: const OutlineInputBorder(),
                ),
                items: _channels.map((c) {
                  final channel = c.toString();
                  return DropdownMenuItem<String>(
                    value: channel,
                    child: Text(
                      _channelLabel(l10n, channel),
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value == null) return;
                  setState(() => _selectedChannel = value);
                  _loadQuote();
                },
              ),
              const SizedBox(height: 10),
            ],
            Text(
              _channelHintFor(l10n, _selectedCategory, _selectedTransportMode),
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
              enabled: !isVehicle,
              onChanged: (_) => _loadQuote(),
              decoration: InputDecoration(
                labelText: l10n.smugglingQuantity,
                helperText: isVehicle
                    ? l10n.smugglingVehiclesOneByOne
                    : l10n.smugglingMaxQuantity(maxQty),
                filled: true,
                fillColor: Colors.black45,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            _buildQuotePanel(context),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: _isSending || (_selectedTransportMode == 'owned' && _selectedOwnedTransportKey == null)
                    ? null
                    : _sendShipment,
                icon: const Icon(Icons.send),
                label: Text(l10n.smugglingStartSmuggling),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildQuotePanel(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeName = Localizations.localeOf(context).toString();

    if (_isQuoteLoading) {
      return const LinearProgressIndicator(minHeight: 2);
    }

    if (_quote == null) {
      return Text(
        l10n.smugglingQuotePrompt,
        style: const TextStyle(color: Colors.white70),
      );
    }

    if (_quote!['success'] != true) {
      return Text(
        _quoteMessage(l10n, _quote!['message']?.toString()),
        style: const TextStyle(color: Colors.orangeAccent),
      );
    }

    final fee = (_quote!['shippingFee'] as num?)?.toInt() ?? 0;
    final eta = (_quote!['etaMinutes'] as num?)?.toInt() ?? 0;
    final risk =
        ((double.tryParse(_quote!['seizureChance']?.toString() ?? '0') ?? 0) *
                100)
            .toStringAsFixed(1);
    final canAfford = _quote!['canAfford'] == true;
    final cooldown =
        (_quote!['cooldownRemainingSeconds'] as num?)?.toInt() ?? 0;
    final recommended = _quote!['recommendedChannel']?.toString();
    final transportLabel = _quote!['transportLabel']?.toString();
    final cargoSlotsRequired = (_quote!['cargoSlotsRequired'] as num?)?.toInt();
    final cargoSlotsAvailable = (_quote!['cargoSlotsAvailable'] as num?)?.toInt();

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.smugglingQuoteLiveTitle,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.smugglingQuoteSummaryLine(fee.toString(), eta, risk),
            style: const TextStyle(color: Colors.white70),
          ),
          if (transportLabel != null && transportLabel.isNotEmpty)
            Text(
              l10n.smugglingOwnedTransportCaption(transportLabel),
              style: const TextStyle(color: Colors.lightBlueAccent),
            ),
          if (cargoSlotsRequired != null && cargoSlotsAvailable != null)
            Text(
              l10n.smugglingCargoSlotsLine(cargoSlotsRequired, cargoSlotsAvailable),
              style: const TextStyle(color: Colors.white70),
            ),
          if (cooldown > 0)
            Text(
              l10n.smugglingCooldownActive(
                formatAdaptiveDurationFromSeconds(
                  cooldown,
                  localeName: localeName,
                ),
              ),
              style: const TextStyle(color: Colors.orangeAccent),
            ),
          if (recommended != null && recommended.isNotEmpty)
            Text(
              l10n.smugglingRecommendedChannel(_channelLabel(l10n, recommended)),
              style: const TextStyle(color: Colors.lightBlueAccent),
            ),
          if (!canAfford)
            Text(
              l10n.smugglingInsufficientCash,
              style: const TextStyle(color: Colors.redAccent),
            ),
        ],
      ),
    );
  }

  Widget _buildDepotsPanel(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.55),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.smugglingDepotsTitle,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          if (_depots.isEmpty)
            Text(
              l10n.smugglingDepotsEmpty,
              style: const TextStyle(color: Colors.white70),
            )
          else
            ..._depots.map((d) {
              final depot = d as Map<String, dynamic>;
              final canClaimHere = depot['canClaimHere'] == true;
              final packages = (depot['packages'] as num?)?.toInt() ?? 0;
              final totalQuantity = (depot['totalQuantity'] as num?)?.toInt() ?? 0;
              return ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  canClaimHere ? Icons.check_circle : Icons.location_on,
                  color: canClaimHere
                      ? Colors.lightGreenAccent
                      : Colors.white70,
                ),
                title: Text(
                  '${depot['countryName']}',
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  l10n.smugglingDepotLine(packages, totalQuantity),
                  style: const TextStyle(color: Colors.white70),
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _networkLabel(
                        l10n,
                        depot['networkScope']?.toString() ?? 'personal',
                      ),
                      style: const TextStyle(
                        color: Colors.amberAccent,
                        fontSize: 12,
                      ),
                    ),
                    if (canClaimHere)
                      Text(
                        l10n.smugglingClaimHere,
                        style: const TextStyle(color: Colors.lightGreenAccent),
                      ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildShipmentsPanel(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.55),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.smugglingStatusTitle,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          if (_shipments.isEmpty)
            Text(
              l10n.smugglingNoShipmentsYet,
              style: const TextStyle(color: Colors.white70),
            )
          else
            ..._shipments.take(20).map((s) {
              final shipment = s as Map<String, dynamic>;
              final status = shipment['status']?.toString() ?? 'unknown';
              final statusColor = status == 'ready'
                  ? Colors.lightGreenAccent
                  : status == 'seized'
                  ? Colors.redAccent
                  : status == 'claimed'
                  ? Colors.blueAccent
                  : Colors.orangeAccent;

              final ownedExtra = (shipment['metadata'] is Map<String, dynamic> &&
                      (shipment['metadata'] as Map<String, dynamic>)['ownedTransport'] is Map<String, dynamic>)
                  ? ' • ${((shipment['metadata'] as Map<String, dynamic>)['ownedTransport'] as Map<String, dynamic>)['transportLabel']}'
                  : '';
              final riskPct = ((double.tryParse(shipment['seizureChance'].toString()) ?? 0) * 100).toStringAsFixed(1);

              return Card(
                color: Colors.black38,
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  title: Text(
                    '${shipment['itemLabel']} • ${shipment['quantity']} ${shipment['unitTag'] ?? ''}',
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    '${shipment['originCountryName']} → ${shipment['destinationCountryName']} • ${_networkLabel(l10n, shipment['networkScope']?.toString() ?? 'personal')} • ${_channelLabel(l10n, shipment['channel']?.toString() ?? 'courier')}$ownedExtra • €${shipment['shippingFee']} • ${l10n.smugglingSeizureRiskPercent(riskPct)}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  trailing: Text(
                    _shipmentStatusLabel(l10n, status),
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }
}
