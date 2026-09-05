import 'dart:async';

import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../services/smuggling_service.dart';
import '../utils/formatters.dart';
import '../utils/top_right_notification.dart';
import '../widgets/smuggling_result_overlay.dart';
import '../widgets/mobile_load_error.dart';

class SmugglingScreen extends StatefulWidget {
  const SmugglingScreen({super.key});

  @override
  State<SmugglingScreen> createState() => _SmugglingScreenState();
}

class _SmugglingScreenState extends State<SmugglingScreen> {
  static const _gold = Color(0xFFD4A24D);
  static const _goldSoft = Color(0x66D4A24D);

  final SmugglingService _smugglingService = SmugglingService();
  final TextEditingController _quantityController = TextEditingController(
    text: '1',
  );

  bool _isLoading = true;
  String? _loadError;
  bool _isSending = false;
  bool _isClaiming = false;

  int _sendStep = 0;
  bool _shipmentsActiveOnly = true;

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

  Timer? _etaTicker;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _etaTicker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _now = DateTime.now());
    });
    _loadData();
  }

  @override
  void dispose() {
    _etaTicker?.cancel();
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = _destinations.isEmpty && _shipments.isEmpty;
      _loadError = null;
    });

    try {
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
      final availableOwnedTransport =
          ownedTransports.whereType<Map<String, dynamic>>().toList();
      if (availableOwnedTransport.isEmpty) {
        _selectedOwnedTransportKey = null;
        _selectedTransportMode = 'commercial';
      } else if (_selectedOwnedTransportKey == null ||
          !availableOwnedTransport.any(
            (transport) =>
                transport['transportKey']?.toString() ==
                _selectedOwnedTransportKey,
          )) {
        _selectedOwnedTransportKey =
            availableOwnedTransport.first['transportKey']?.toString();
      }
      _shipments = (overview['shipments'] as List<dynamic>?) ?? [];
      _depots = (overview['depots'] as List<dynamic>?) ?? [];

      final itemsForCategory =
          (_categories[_selectedCategory] as List<dynamic>?) ?? [];
      if (_selectedItemKey == null ||
          !itemsForCategory.any(
            (item) =>
                item is Map<String, dynamic> &&
                item['itemKey']?.toString() == _selectedItemKey,
          )) {
        _selectedItemKey = itemsForCategory.isNotEmpty
            ? itemsForCategory.first['itemKey']?.toString()
            : null;
      }
      if (_selectedDestination == null ||
          !destinations.any(
            (d) =>
                d is Map<String, dynamic> &&
                d['id']?.toString() == _selectedDestination,
          )) {
        _selectedDestination = destinations.isNotEmpty
            ? destinations.first['id']?.toString()
            : null;
      }
      _quote = null;
      _isLoading = false;
    });

    await _loadQuote();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loadError = AppLocalizations.of(context)!.connectionErrorGeneric;
        _isLoading = false;
      });
    }
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
      r'^(\d+) (?:crew-)?zending\(en\) opgehaald in (.+?)(?: \(\+\d+ XP\))?$',
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

  Future<void> _showResultOverlay({
    required String title,
    required String subtitle,
    int? fee,
    int? etaMinutes,
    int? xpGained,
    double? riskPercent,
    String? confiscationMessage,
  }) async {
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => SmugglingResultOverlay(
        title: title,
        subtitle: subtitle,
        fee: fee,
        etaMinutes: etaMinutes,
        xpGained: xpGained,
        riskPercent: riskPercent,
        confiscationMessage: confiscationMessage,
        onContinue: () => Navigator.of(ctx).pop(),
      ),
    );
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

    final localized = _localizeSmugglingApiMessage(
      l10n,
      result['message']?.toString(),
    );

    if (result['success'] == true) {
      _quantityController.text = '1';
      setState(() => _sendStep = 0);
      final fee = (result['shippingFee'] as num?)?.toInt();
      final eta = (result['etaMinutes'] as num?)?.toInt();
      final riskRaw = double.tryParse(result['seizureChance']?.toString() ?? '');
      final riskPct = riskRaw != null ? riskRaw * 100 : null;
      final confiscation = result['confiscationMessage']?.toString() ??
          (result['metadata'] is Map<String, dynamic>
              ? (result['metadata'] as Map<String, dynamic>)['confiscationMessage']
                    ?.toString()
              : null);

      await _showResultOverlay(
        title: l10n.smugglingResultSendTitle,
        subtitle: localized,
        fee: fee,
        etaMinutes: eta,
        riskPercent: riskPct,
        confiscationMessage: confiscation,
      );
      await _loadData();
    } else {
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(localized),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _claimCurrentDepot(String scope) async {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _isClaiming = true);
    final result = await _smugglingService.claimCurrentDepot(scope: scope);

    if (!mounted) return;

    setState(() => _isClaiming = false);

    final localized = _localizeSmugglingApiMessage(
      l10n,
      result['message']?.toString(),
    );

    if (result['success'] == true) {
      final xp = (result['xpGained'] as num?)?.toInt();
      final confiscation = result['confiscationMessage']?.toString();
      await _showResultOverlay(
        title: l10n.smugglingResultClaimTitle,
        subtitle: localized,
        xpGained: xp,
        confiscationMessage: confiscation,
      );
      await _loadData();
    } else {
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(localized),
          backgroundColor: Colors.red,
        ),
      );
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
    return network == 'crew' ? l10n.smugglingCrew : l10n.smugglingPersonal;
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

  Color _statusColor(String status) {
    switch (status) {
      case 'ready':
        return Colors.lightGreenAccent;
      case 'seized':
        return Colors.redAccent;
      case 'claimed':
        return Colors.blueAccent;
      case 'in_transit':
        return Colors.orangeAccent;
      default:
        return Colors.white70;
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

  InputDecoration _fieldDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      filled: true,
      fillColor: const Color(0x33241A0F),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: _goldSoft),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: _gold),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: _goldSoft),
      ),
    );
  }

  Widget _mafiaPanel({required Widget child, EdgeInsetsGeometry? padding}) {
    return Container(
      padding: padding ?? const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xCC110A0A), Color(0xCC24120A), Color(0xCC16110E)],
        ),
        border: Border.all(color: _goldSoft),
        boxShadow: const [
          BoxShadow(
            color: Color(0x66000000),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _kpiChip(String label, String value, {Color? valueColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color(0x33241A0F),
        border: Border.all(color: const Color(0x55D4A24D)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 11),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: valueColor ?? const Color(0xFFFFE3A0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyState({
    required double width,
    required String title,
    required String hint,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          Image.asset(
            _crateAssetForWidth(width),
            width: 64,
            height: 64,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.inventory_2, size: 48, color: _gold),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              color: Colors.orangeAccent,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            hint,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _etaLabel(AppLocalizations l10n, Map<String, dynamic> shipment) {
    final status = shipment['status']?.toString() ?? '';
    if (status == 'ready') return l10n.smugglingEtaReady;
    if (status != 'in_transit') return _shipmentStatusLabel(l10n, status);

    final etaRaw = shipment['etaAt']?.toString();
    if (etaRaw == null || etaRaw.isEmpty) {
      return _shipmentStatusLabel(l10n, status);
    }
    final eta = DateTime.tryParse(etaRaw)?.toLocal();
    if (eta == null) return _shipmentStatusLabel(l10n, status);

    final remaining = eta.difference(_now);
    if (remaining.inSeconds <= 0) return l10n.smugglingEtaReady;
    if (remaining.inMinutes >= 1) {
      return l10n.smugglingEtaMinutesLeft(remaining.inMinutes);
    }
    return l10n.smugglingEtaSecondsLeft(remaining.inSeconds);
  }

  bool _canAdvanceFromStep(int step) {
    switch (step) {
      case 0:
        return _selectedItem != null;
      case 1:
        return _selectedDestination != null;
      case 2:
        if (_selectedTransportMode == 'owned') {
          return _selectedOwnedTransportKey != null &&
              _selectedNetworkScope != 'crew';
        }
        return _selectedChannel.isNotEmpty;
      default:
        return true;
    }
  }

  List<Map<String, dynamic>> get _orderedShipments {
    final list = _shipments.whereType<Map<String, dynamic>>().toList();
    int rank(String status) {
      switch (status) {
        case 'ready':
          return 0;
        case 'in_transit':
          return 1;
        case 'seized':
          return 2;
        case 'claimed':
          return 3;
        default:
          return 4;
      }
    }

    list.sort((a, b) {
      final ra = rank(a['status']?.toString() ?? '');
      final rb = rank(b['status']?.toString() ?? '');
      if (ra != rb) return ra.compareTo(rb);
      return 0;
    });

    if (_shipmentsActiveOnly) {
      return list
          .where((s) {
            final status = s['status']?.toString() ?? '';
            return status == 'in_transit' || status == 'ready';
          })
          .toList();
    }
    return list;
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
            ? const Center(child: CircularProgressIndicator(color: _gold))
            : _loadError != null && _destinations.isEmpty && _shipments.isEmpty
            ? MobileLoadError(message: _loadError!, onRetry: _loadData)
            : RefreshIndicator(
                color: _gold,
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
    final narrow = width < 700;

    final claimButtons = Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        OutlinedButton.icon(
          onPressed: _isClaiming ? null : () => _claimCurrentDepot('personal'),
          icon: const Icon(Icons.inventory_2, size: 18),
          label: Text(l10n.smugglingClaimPersonal),
          style: OutlinedButton.styleFrom(
            foregroundColor: _gold,
            side: const BorderSide(color: _gold),
          ),
        ),
        if (_canUseCrewNetwork)
          ElevatedButton.icon(
            onPressed: _isClaiming ? null : () => _claimCurrentDepot('crew'),
            icon: const Icon(Icons.groups, size: 18),
            label: Text(l10n.smugglingClaimCrew),
            style: ElevatedButton.styleFrom(
              backgroundColor: _gold,
              foregroundColor: const Color(0xFF1B1212),
            ),
          ),
      ],
    );

    return _mafiaPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                _emblemAssetForWidth(width),
                width: 56,
                height: 56,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.local_shipping, size: 42, color: _gold),
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
                        color: _gold,
                      ),
                    ),
                    Text(
                      l10n.smugglingHubSubtitle,
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
              if (!narrow) claimButtons,
            ],
          ),
          if (narrow) ...[
            const SizedBox(height: 12),
            claimButtons,
          ],
        ],
      ),
    );
  }

  Widget _buildSendPanel(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final width = MediaQuery.of(context).size.width;
    final stepLabels = [
      l10n.smugglingStepCargo,
      l10n.smugglingStepRoute,
      l10n.smugglingStepTransport,
      l10n.smugglingStepConfirm,
    ];

    return _mafiaPanel(
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
                    const Icon(Icons.inventory_2, color: _gold),
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
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(stepLabels.length, (i) {
                final active = i == _sendStep;
                final done = i < _sendStep;
                return Padding(
                  padding: EdgeInsets.only(right: i < 3 ? 8 : 0),
                  child: InkWell(
                    onTap: () {
                      if (i <= _sendStep ||
                          (i == _sendStep + 1 &&
                              _canAdvanceFromStep(_sendStep))) {
                        setState(() => _sendStep = i);
                        if (i == 3) _loadQuote();
                      }
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: active
                            ? _gold.withOpacity(0.22)
                            : done
                                ? const Color(0x33241A0F)
                                : Colors.black26,
                        border: Border.all(
                          color: active || done ? _gold : _goldSoft,
                          width: active ? 1.4 : 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${i + 1}',
                            style: TextStyle(
                              color: active || done ? _gold : Colors.white54,
                              fontWeight: FontWeight.w800,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            stepLabels[i],
                            style: TextStyle(
                              color: active || done
                                  ? Colors.white
                                  : Colors.white54,
                              fontWeight:
                                  active ? FontWeight.w700 : FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 14),
          if (_sendStep == 0) _buildCargoStep(context),
          if (_sendStep == 1) _buildRouteStep(context),
          if (_sendStep == 2) _buildTransportStep(context),
          if (_sendStep == 3) _buildConfirmStep(context),
          const SizedBox(height: 14),
          Row(
            children: [
              if (_sendStep > 0)
                OutlinedButton(
                  onPressed: () => setState(() => _sendStep -= 1),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _gold,
                    side: const BorderSide(color: _goldSoft),
                  ),
                  child: Text(l10n.smugglingBackStep),
                ),
              const Spacer(),
              if (_sendStep < 3)
                ElevatedButton(
                  onPressed: _canAdvanceFromStep(_sendStep)
                      ? () {
                          setState(() => _sendStep += 1);
                          if (_sendStep == 3) _loadQuote();
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _gold,
                    foregroundColor: const Color(0xFF1B1212),
                    disabledBackgroundColor: _gold.withOpacity(0.35),
                  ),
                  child: Text(l10n.smugglingNextStep),
                )
              else
                ElevatedButton.icon(
                  onPressed: _isSending ||
                          (_selectedTransportMode == 'owned' &&
                              _selectedOwnedTransportKey == null)
                      ? null
                      : _sendShipment,
                  icon: _isSending
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Color(0xFF1B1212),
                          ),
                        )
                      : const Icon(Icons.send),
                  label: Text(l10n.smugglingStartSmuggling),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _gold,
                    foregroundColor: const Color(0xFF1B1212),
                    disabledBackgroundColor: _gold.withOpacity(0.35),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCargoStep(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final width = MediaQuery.of(context).size.width;
    final selected = _selectedItem;
    final isVehicle = _selectedCategory == 'vehicle';
    final maxQty = (selected is Map<String, dynamic>)
        ? ((selected['quantity'] as num?)?.toInt() ?? 1)
        : 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: ['drug', 'trade', 'vehicle', 'weapon', 'ammo'].map((c) {
            final selectedChip = c == _selectedCategory;
            return ChoiceChip(
              selected: selectedChip,
              label: Text(_categoryLabel(l10n, c)),
              avatar: Icon(
                _categoryIcon(c),
                size: 18,
                color: selectedChip ? const Color(0xFF1B1212) : _gold,
              ),
              selectedColor: _gold,
              backgroundColor: const Color(0x33241A0F),
              labelStyle: TextStyle(
                color: selectedChip ? const Color(0xFF1B1212) : Colors.white,
                fontWeight: FontWeight.w600,
              ),
              side: BorderSide(color: selectedChip ? _gold : _goldSoft),
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
        const SizedBox(height: 12),
        if (_currentItems.isEmpty)
          _emptyState(
            width: width,
            title: l10n.smugglingEmptyCargoTitle,
            hint: l10n.smugglingEmptyCargoHint,
          )
        else ...[
          DropdownButtonFormField<String>(
            value: _selectedItemKey,
            dropdownColor: const Color(0xFF1B1212),
            decoration: _fieldDecoration(l10n.smugglingFieldItem),
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
          TextField(
            controller: _quantityController,
            keyboardType: TextInputType.number,
            enabled: !isVehicle,
            onChanged: (_) => _loadQuote(),
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration(l10n.smugglingQuantity).copyWith(
              helperText: isVehicle
                  ? l10n.smugglingVehiclesOneByOne
                  : l10n.smugglingMaxQuantity(maxQty),
              helperStyle: const TextStyle(color: Colors.white54),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildRouteStep(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          value: _selectedDestination,
          dropdownColor: const Color(0xFF1B1212),
          decoration: _fieldDecoration(l10n.smugglingFieldDestination),
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
        const SizedBox(height: 12),
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
              selectedColor: _gold,
              backgroundColor: const Color(0x33241A0F),
              labelStyle: TextStyle(
                color: _selectedNetworkScope == 'personal'
                    ? const Color(0xFF1B1212)
                    : Colors.white,
                fontWeight: FontWeight.w600,
              ),
              side: BorderSide(
                color: _selectedNetworkScope == 'personal' ? _gold : _goldSoft,
              ),
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
                selectedColor: _gold,
                backgroundColor: const Color(0x33241A0F),
                labelStyle: TextStyle(
                  color: _selectedNetworkScope == 'crew'
                      ? const Color(0xFF1B1212)
                      : Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                side: BorderSide(
                  color: _selectedNetworkScope == 'crew' ? _gold : _goldSoft,
                ),
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
      ],
    );
  }

  Widget _buildTransportStep(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final selectedOwnedTransport = _selectedOwnedTransport;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
              selectedColor: _gold,
              backgroundColor: const Color(0x33241A0F),
              labelStyle: TextStyle(
                color: _selectedTransportMode == 'commercial'
                    ? const Color(0xFF1B1212)
                    : Colors.white,
                fontWeight: FontWeight.w600,
              ),
              side: BorderSide(
                color: _selectedTransportMode == 'commercial' ? _gold : _goldSoft,
              ),
              onSelected: (_) {
                if (_selectedTransportMode == 'commercial') return;
                setState(() => _selectedTransportMode = 'commercial');
                _loadQuote();
              },
            ),
            ChoiceChip(
              selected: _selectedTransportMode == 'owned',
              label: Text(l10n.smugglingOwnedVehicleAircraft),
              selectedColor: _gold,
              backgroundColor: const Color(0x33241A0F),
              labelStyle: TextStyle(
                color: _selectedTransportMode == 'owned'
                    ? const Color(0xFF1B1212)
                    : Colors.white,
                fontWeight: FontWeight.w600,
              ),
              side: BorderSide(
                color: _selectedTransportMode == 'owned' ? _gold : _goldSoft,
              ),
              onSelected: (_currentOwnedTransports.isEmpty ||
                      _selectedNetworkScope == 'crew')
                  ? null
                  : (_) {
                      if (_selectedTransportMode == 'owned') return;
                      setState(() => _selectedTransportMode = 'owned');
                      _loadQuote();
                    },
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (_selectedTransportMode == 'owned' &&
            _selectedNetworkScope != 'crew') ...[
          if (_currentOwnedTransports.isEmpty)
            Text(
              l10n.smugglingNoOwnedTransportInCountry,
              style: const TextStyle(color: Colors.orangeAccent),
            )
          else ...[
            DropdownButtonFormField<String>(
              value: _selectedOwnedTransportKey,
              dropdownColor: const Color(0xFF1B1212),
              decoration: _fieldDecoration(l10n.smugglingOwnedTransportFieldLabel),
              items: _currentOwnedTransports.map((transport) {
                final map = transport as Map<String, dynamic>;
                final key = map['transportKey']?.toString() ?? '';
                final slots = (map['cargoSlots'] as num?)?.toInt() ?? 0;
                final risk =
                    (((map['riskReduction'] as num?)?.toDouble() ?? 0) * 100)
                        .toStringAsFixed(0);
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
            if (selectedOwnedTransport != null) ...[
              const SizedBox(height: 8),
              Text(
                l10n.smugglingOwnedTransportCapacityLine(
                  (selectedOwnedTransport['cargoSlots'] as num?)?.toInt() ?? 0,
                  ((((selectedOwnedTransport['confiscationChance'] as num?)
                                  ?.toDouble() ??
                              0) *
                          100))
                      .toStringAsFixed(0),
                ),
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ],
        ],
        if (_selectedTransportMode == 'commercial') ...[
          DropdownButtonFormField<String>(
            value: _selectedChannel,
            dropdownColor: const Color(0xFF1B1212),
            decoration: _fieldDecoration(l10n.smugglingChannelField),
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
        ],
        const SizedBox(height: 10),
        Text(
          _channelHintFor(l10n, _selectedCategory, _selectedTransportMode),
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildConfirmStep(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final selected = _selectedItem;
    final itemLabel = selected is Map<String, dynamic>
        ? selected['itemLabel']?.toString() ?? ''
        : '';
    final qty = _selectedCategory == 'vehicle'
        ? 1
        : (int.tryParse(_quantityController.text.trim()) ?? 0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _kpiChip(l10n.smugglingFieldItem, '$itemLabel × $qty'),
            _kpiChip(
              l10n.smugglingFieldDestination,
              () {
                for (final d in _destinations) {
                  if (d is Map<String, dynamic> &&
                      d['id']?.toString() == _selectedDestination) {
                    return d['name']?.toString() ??
                        (_selectedDestination ?? '—');
                  }
                }
                return _selectedDestination ?? '—';
              }(),
            ),
            _kpiChip(
              l10n.smugglingNetwork,
              _networkLabel(l10n, _selectedNetworkScope),
            ),
            _kpiChip(
              l10n.smugglingTransport,
              _selectedTransportMode == 'owned'
                  ? (_selectedOwnedTransport?['transportLabel']?.toString() ??
                      l10n.smugglingChannelOwned)
                  : _channelLabel(l10n, _selectedChannel),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildQuotePanel(context),
      ],
    );
  }

  Widget _buildQuotePanel(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeName = Localizations.localeOf(context).toString();

    if (_isQuoteLoading) {
      return const LinearProgressIndicator(
        minHeight: 2,
        color: _gold,
        backgroundColor: _goldSoft,
      );
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
    final cargoSlotsAvailable =
        (_quote!['cargoSlotsAvailable'] as num?)?.toInt();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.smugglingQuoteLiveTitle,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _kpiChip(l10n.smugglingResultFeeLabel, formatCurrency(fee)),
            _kpiChip(l10n.smugglingResultEtaLabel, '${eta}m'),
            _kpiChip(
              l10n.smugglingResultRiskLabel,
              '$risk%',
              valueColor: Colors.orangeAccent,
            ),
            if (cargoSlotsRequired != null && cargoSlotsAvailable != null)
              _kpiChip(
                l10n.smugglingStepCargo,
                '$cargoSlotsRequired / $cargoSlotsAvailable',
              ),
          ],
        ),
        if (transportLabel != null && transportLabel.isNotEmpty) ...[
          const SizedBox(height: 6),
          Text(
            l10n.smugglingOwnedTransportCaption(transportLabel),
            style: const TextStyle(color: Colors.lightBlueAccent),
          ),
        ],
        if (_quote!['harborBonus'] == true) ...[
          const SizedBox(height: 6),
          Text(
            l10n.smugglingHarborBonus,
            style: const TextStyle(color: Colors.greenAccent),
          ),
        ],
        if (cooldown > 0) ...[
          const SizedBox(height: 6),
          Text(
            l10n.smugglingCooldownActive(
              formatAdaptiveDurationFromSeconds(
                cooldown,
                localeName: localeName,
              ),
            ),
            style: const TextStyle(color: Colors.orangeAccent),
          ),
        ],
        if (recommended != null && recommended.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            l10n.smugglingRecommendedChannel(_channelLabel(l10n, recommended)),
            style: const TextStyle(color: Colors.lightBlueAccent),
          ),
        ],
        if (!canAfford) ...[
          const SizedBox(height: 4),
          Text(
            l10n.smugglingInsufficientCash,
            style: const TextStyle(color: Colors.redAccent),
          ),
        ],
      ],
    );
  }

  Widget _buildDepotsPanel(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final width = MediaQuery.of(context).size.width;

    return _mafiaPanel(
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
            _emptyState(
              width: width,
              title: l10n.smugglingEmptyDepotsTitle,
              hint: l10n.smugglingEmptyDepotsHint,
            )
          else
            ..._depots.map((d) {
              final depot = d as Map<String, dynamic>;
              final canClaimHere = depot['canClaimHere'] == true;
              final packages = (depot['packages'] as num?)?.toInt() ?? 0;
              final totalQuantity =
                  (depot['totalQuantity'] as num?)?.toInt() ?? 0;
              final scope =
                  depot['networkScope']?.toString() ?? 'personal';

              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: const Color(0x33241A0F),
                  border: Border.all(
                    color: canClaimHere
                        ? Colors.lightGreenAccent.withOpacity(0.7)
                        : _goldSoft,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      canClaimHere ? Icons.check_circle : Icons.location_on,
                      color: canClaimHere
                          ? Colors.lightGreenAccent
                          : Colors.white70,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${depot['countryName']}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            l10n.smugglingDepotLine(packages, totalQuantity),
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            _networkLabel(l10n, scope),
                            style: const TextStyle(
                              color: _gold,
                              fontSize: 12,
                            ),
                          ),
                          if (canClaimHere)
                            Text(
                              l10n.smugglingClaimHere,
                              style: const TextStyle(
                                color: Colors.lightGreenAccent,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (canClaimHere)
                      ElevatedButton(
                        onPressed: _isClaiming
                            ? null
                            : () => _claimCurrentDepot(scope),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _gold,
                          foregroundColor: const Color(0xFF1B1212),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                        ),
                        child: Text(l10n.smugglingClaimThisDepot),
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
    final width = MediaQuery.of(context).size.width;
    final ordered = _orderedShipments;

    return _mafiaPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.smugglingStatusTitle,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SegmentedButton<bool>(
                segments: [
                  ButtonSegment(
                    value: true,
                    label: Text(l10n.smugglingActiveFilter),
                  ),
                  ButtonSegment(
                    value: false,
                    label: Text(l10n.smugglingShowAllFilter),
                  ),
                ],
                selected: {_shipmentsActiveOnly},
                onSelectionChanged: (value) {
                  setState(() => _shipmentsActiveOnly = value.first);
                },
                style: ButtonStyle(
                  visualDensity: VisualDensity.compact,
                  foregroundColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) {
                      return const Color(0xFF1B1212);
                    }
                    return Colors.white70;
                  }),
                  backgroundColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) {
                      return _gold;
                    }
                    return const Color(0x33241A0F);
                  }),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (ordered.isEmpty)
            _emptyState(
              width: width,
              title: l10n.smugglingEmptyShipmentsTitle,
              hint: l10n.smugglingEmptyShipmentsHint,
            )
          else
            ...ordered.take(20).map((shipment) {
              final status = shipment['status']?.toString() ?? 'unknown';
              final statusColor = _statusColor(status);
              final dense = status == 'claimed' || status == 'seized';
              final canClaimHere = shipment['canClaimHere'] == true;
              final scope =
                  shipment['networkScope']?.toString() ?? 'personal';

              final ownedExtra = (shipment['metadata'] is Map<String, dynamic> &&
                      (shipment['metadata'] as Map<String, dynamic>)[
                          'ownedTransport'] is Map<String, dynamic>)
                  ? ' • ${((shipment['metadata'] as Map<String, dynamic>)['ownedTransport'] as Map<String, dynamic>)['transportLabel']}'
                  : '';
              final riskPct =
                  ((double.tryParse(shipment['seizureChance'].toString()) ?? 0) *
                          100)
                      .toStringAsFixed(1);

              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: EdgeInsets.all(dense ? 10 : 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: const Color(0x33241A0F),
                  border: Border.all(
                    color: canClaimHere
                        ? Colors.lightGreenAccent.withOpacity(0.55)
                        : _goldSoft,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${shipment['itemLabel']} • ${shipment['quantity']} ${shipment['unitTag'] ?? ''}',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: dense ? 13 : 14,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(999),
                            color: statusColor.withOpacity(0.18),
                            border: Border.all(
                              color: statusColor.withOpacity(0.7),
                            ),
                          ),
                          child: Text(
                            _shipmentStatusLabel(l10n, status),
                            style: TextStyle(
                              color: statusColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (!dense) ...[
                      const SizedBox(height: 6),
                      Text(
                        '${shipment['originCountryName']} → ${shipment['destinationCountryName']} • ${_networkLabel(l10n, scope)} • ${_channelLabel(l10n, shipment['channel']?.toString() ?? 'courier')}$ownedExtra • €${shipment['shippingFee']} • ${l10n.smugglingSeizureRiskPercent(riskPct)}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.schedule,
                          size: 14,
                          color: status == 'ready'
                              ? Colors.lightGreenAccent
                              : _gold,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _etaLabel(l10n, shipment),
                          style: TextStyle(
                            color: status == 'ready'
                                ? Colors.lightGreenAccent
                                : const Color(0xFFFFE3A0),
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                        const Spacer(),
                        if (canClaimHere)
                          TextButton(
                            onPressed: _isClaiming
                                ? null
                                : () => _claimCurrentDepot(scope),
                            style: TextButton.styleFrom(
                              foregroundColor: _gold,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              visualDensity: VisualDensity.compact,
                            ),
                            child: Text(l10n.smugglingClaimThisDepot),
                          ),
                      ],
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }
}
