import 'package:flutter/material.dart';

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

  List<dynamic> _destinations = [];
  List<dynamic> _channels = ['package', 'courier', 'container'];
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

  bool get _isNl => Localizations.localeOf(context).languageCode == 'nl';
  String _tr(String nl, String en) => _isNl ? nl : en;

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
    final defaultItems =
        (categories[_selectedCategory] as List<dynamic>?) ?? [];

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
      _canUseCrewNetwork = catalog['canUseCrewNetwork'] == true;
      final selectedNetwork = catalog['selectedNetworkScope']?.toString();
      if (selectedNetwork == 'crew' || selectedNetwork == 'personal') {
        _selectedNetworkScope = selectedNetwork!;
      }
      if (!_canUseCrewNetwork) {
        _selectedNetworkScope = 'personal';
      }
      if (!_channels.contains(_selectedChannel)) {
        _selectedChannel = 'courier';
      }
      _shipments = (overview['shipments'] as List<dynamic>?) ?? [];
      _depots = (overview['depots'] as List<dynamic>?) ?? [];

      _selectedItemKey = defaultItems.isNotEmpty
          ? defaultItems.first['itemKey']?.toString()
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

  Future<void> _sendShipment() async {
    final selectedItem = _selectedItem;
    if (selectedItem == null || _selectedDestination == null) {
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(
            _tr('Selecteer item en bestemming', 'Select item and destination'),
          ),
        ),
      );
      return;
    }

    final maxQty = (selectedItem['quantity'] as num?)?.toInt() ?? 1;
    int qty = int.tryParse(_quantityController.text.trim()) ?? 0;
    if (_selectedCategory == 'vehicle') {
      qty = 1;
    }

    if (_selectedCategory == 'trade' && _selectedNetworkScope == 'crew') {
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(
            _tr(
              'Crew-smokkel voor handelswaar is nog niet beschikbaar',
              'Crew smuggling for trade goods is not available yet',
            ),
          ),
        ),
      );
      return;
    }

    if (qty <= 0 || qty > maxQty) {
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(_tr('Ongeldige hoeveelheid', 'Invalid quantity')),
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
      metadata: metadata,
    );

    if (!mounted) return;

    setState(() => _isSending = false);

    showTopRightFromSnackBar(
      context,
      SnackBar(
        content: Text(
          result['message']?.toString() ??
              _tr('Actie verwerkt', 'Action processed'),
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
    setState(() => _isClaiming = true);
    final result = await _smugglingService.claimCurrentDepot(scope: scope);

    if (!mounted) return;

    setState(() => _isClaiming = false);

    showTopRightFromSnackBar(
      context,
      SnackBar(
        content: Text(
          result['message']?.toString() ??
              _tr('Actie verwerkt', 'Action processed'),
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
      metadata: metadata,
    );

    if (!mounted) return;

    setState(() {
      _isQuoteLoading = false;
      _quote = result;
    });
  }

  String _categoryLabel(String category) {
    switch (category) {
      case 'drug':
        return _tr('Drugs', 'Drugs');
      case 'trade':
        return _tr('Handelswaar', 'Trade Goods');
      case 'vehicle':
        return _tr('Auto/Boot', 'Car/Boat');
      case 'weapon':
        return _tr('Wapens', 'Weapons');
      case 'ammo':
        return _tr('Munitie', 'Ammo');
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

  String _channelLabel(String channel) {
    switch (channel) {
      case 'package':
        return _tr('Pakket', 'Package');
      case 'courier':
        return _tr('Koerier', 'Courier');
      case 'container':
        return _tr('Container', 'Container');
      default:
        return channel;
    }
  }

  String _networkLabel(String network) {
    return network == 'crew'
        ? _tr('Crew', 'Crew')
        : _tr('Persoonlijk', 'Personal');
  }

  String _channelHintFor(String category) {
    switch (category) {
      case 'vehicle':
        return _tr(
          'Tip: voertuigen werken het best met Koerier of Container.',
          'Tip: vehicles work best with Courier or Container.',
        );
      case 'weapon':
        return _tr(
          'Tip: grote wapenladingen beter via Container.',
          'Tip: larger weapon loads are better via Container.',
        );
      case 'ammo':
        return _tr(
          'Tip: veel munitie via Container voor lager risico.',
          'Tip: bulk ammo via Container for lower risk.',
        );
      case 'drug':
        return _tr(
          'Tip: kleine batches via Pakket, bulk via Container.',
          'Tip: small batches via Package, bulk via Container.',
        );
      default:
        return _tr(
          'Tip: test kanaalkeuze met live quote.',
          'Tip: compare channels with the live quote.',
        );
    }
  }

  String _backgroundAssetForWidth(double width) {
    if (width >= 1200)
      return 'assets/images/backgrounds/smuggling_hub_bg_desktop.png';
    if (width >= 700)
      return 'assets/images/backgrounds/smuggling_hub_bg_tablet.png';
    return 'assets/images/backgrounds/smuggling_hub_bg_mobile.png';
  }

  String _emblemAssetForWidth(double width) {
    if (width >= 1200)
      return 'assets/images/ui/smuggling_hub_emblem_desktop.png';
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
                    _buildHeader(),
                    const SizedBox(height: 12),
                    _buildSendPanel(),
                    const SizedBox(height: 12),
                    _buildDepotsPanel(),
                    const SizedBox(height: 12),
                    _buildShipmentsPanel(),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildHeader() {
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
            errorBuilder: (_, __, ___) =>
                const Icon(Icons.local_shipping, size: 42, color: Colors.amber),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _tr('Smokkel Hub', 'Smuggling Hub'),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  _tr(
                    '1 systeem voor drugs, handelswaar, voertuigen, wapens en munitie. Reis leeg en claim veilig uit depot.',
                    'One system for drugs, trade goods, vehicles, weapons and ammo. Travel empty and claim safely from depot.',
                  ),
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
                label: Text(_tr('Claim Persoonlijk', 'Claim Personal')),
              ),
              if (_canUseCrewNetwork)
                ElevatedButton.icon(
                  onPressed: _isClaiming
                      ? null
                      : () => _claimCurrentDepot('crew'),
                  icon: const Icon(Icons.groups),
                  label: Text(_tr('Claim Crew', 'Claim Crew')),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSendPanel() {
    final width = MediaQuery.of(context).size.width;
    final selected = _selectedItem;
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
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.inventory_2, color: Colors.white),
              ),
              const SizedBox(width: 8),
              Text(
                _tr('Nieuwe zending', 'New shipment'),
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
                label: Text(_categoryLabel(c)),
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
              _tr(
                'Geen beschikbare items in deze categorie.',
                'No available items in this category.',
              ),
              style: const TextStyle(color: Colors.orangeAccent),
            )
          else ...[
            DropdownButtonFormField<String>(
              value: _selectedItemKey,
              dropdownColor: Colors.black87,
              decoration: InputDecoration(
                labelText: _tr('Item', 'Item'),
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
                labelText: _tr('Bestemming', 'Destination'),
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
              _tr('Netwerk', 'Network'),
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ChoiceChip(
                  selected: _selectedNetworkScope == 'personal',
                  label: Text(_tr('Persoonlijk', 'Personal')),
                  onSelected: (_) async {
                    if (_selectedNetworkScope == 'personal') return;
                    setState(() => _selectedNetworkScope = 'personal');
                    await _loadData();
                  },
                ),
                if (_canUseCrewNetwork)
                  ChoiceChip(
                    selected: _selectedNetworkScope == 'crew',
                    label: Text(_tr('Crew', 'Crew')),
                    onSelected: (_) async {
                      if (_selectedNetworkScope == 'crew') return;
                      setState(() => _selectedNetworkScope = 'crew');
                      await _loadData();
                    },
                  ),
              ],
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _selectedChannel,
              dropdownColor: Colors.black87,
              decoration: InputDecoration(
                labelText: _tr('Smokkelkanaal', 'Smuggling channel'),
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
                    _channelLabel(channel),
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
            Text(
              _channelHintFor(_selectedCategory),
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
              enabled: !isVehicle,
              onChanged: (_) => _loadQuote(),
              decoration: InputDecoration(
                labelText: _tr('Hoeveelheid', 'Quantity'),
                helperText: isVehicle
                    ? _tr(
                        'Voertuigen gaan per stuk',
                        'Vehicles are shipped one by one',
                      )
                    : '${_tr('Max', 'Max')}: $maxQty',
                filled: true,
                fillColor: Colors.black45,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            _buildQuotePanel(),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: _isSending ? null : _sendShipment,
                icon: const Icon(Icons.send),
                label: Text(_tr('Start Smokkel', 'Start Smuggling')),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildQuotePanel() {
    if (_isQuoteLoading) {
      return const LinearProgressIndicator(minHeight: 2);
    }

    if (_quote == null) {
      return Text(
        _tr(
          'Selecteer item en bestemming voor een live quote.',
          'Select item and destination for a live quote.',
        ),
        style: const TextStyle(color: Colors.white70),
      );
    }

    if (_quote!['success'] != true) {
      return Text(
        _quote!['message']?.toString() ??
            _tr('Quote niet beschikbaar', 'Quote unavailable'),
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
            _tr('Live Quote', 'Live Quote'),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '€$fee • $eta ${_tr('min', 'min')} • $risk% ${_tr('risico', 'risk')}',
            style: const TextStyle(color: Colors.white70),
          ),
          if (cooldown > 0)
            Text(
              _tr(
                'Cooldown actief: nog ${formatAdaptiveDurationFromSeconds(cooldown, localeName: 'nl')}',
                'Cooldown active: ${formatAdaptiveDurationFromSeconds(cooldown, localeName: 'en')}',
              ),
              style: const TextStyle(color: Colors.orangeAccent),
            ),
          if (recommended != null && recommended.isNotEmpty)
            Text(
              _tr(
                'Aanbevolen kanaal: ${_channelLabel(recommended)}',
                'Recommended channel: ${_channelLabel(recommended)}',
              ),
              style: const TextStyle(color: Colors.lightBlueAccent),
            ),
          if (!canAfford)
            Text(
              _tr(
                'Onvoldoende cash voor deze zending',
                'Insufficient cash for this shipment',
              ),
              style: const TextStyle(color: Colors.redAccent),
            ),
        ],
      ),
    );
  }

  Widget _buildDepotsPanel() {
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
            _tr('Depots per land', 'Country depots'),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          if (_depots.isEmpty)
            Text(
              _tr(
                'Geen pakketten klaar in depots.',
                'No packages ready in depots.',
              ),
              style: const TextStyle(color: Colors.white70),
            )
          else
            ..._depots.map((d) {
              final depot = d as Map<String, dynamic>;
              final canClaimHere = depot['canClaimHere'] == true;
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
                  '${depot['packages']} ${_tr('pakketten', 'packages')} • ${depot['totalQuantity']} ${_tr('eenheden', 'units')}',
                  style: const TextStyle(color: Colors.white70),
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _networkLabel(
                        depot['networkScope']?.toString() ?? 'personal',
                      ),
                      style: const TextStyle(
                        color: Colors.amberAccent,
                        fontSize: 12,
                      ),
                    ),
                    if (canClaimHere)
                      Text(
                        _tr('Hier ophalen', 'Claim here'),
                        style: const TextStyle(color: Colors.lightGreenAccent),
                      ),
                  ],
                ),
              );
            }).toList(),
        ],
      ),
    );
  }

  Widget _buildShipmentsPanel() {
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
            _tr('Smokkelstatus', 'Smuggling status'),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          if (_shipments.isEmpty)
            Text(
              _tr('Nog geen zendingen.', 'No shipments yet.'),
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

              return Card(
                color: Colors.black38,
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  title: Text(
                    '${shipment['itemLabel']} • ${shipment['quantity']} ${shipment['unitTag'] ?? ''}',
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    '${shipment['originCountryName']} → ${shipment['destinationCountryName']} • ${_networkLabel(shipment['networkScope']?.toString() ?? 'personal')} • ${_channelLabel(shipment['channel']?.toString() ?? 'courier')} • €${shipment['shippingFee']} • ${((double.tryParse(shipment['seizureChance'].toString()) ?? 0) * 100).toStringAsFixed(1)}% ${_tr('risico', 'risk')}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  trailing: Text(
                    status.toUpperCase(),
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }).toList(),
        ],
      ),
    );
  }
}
