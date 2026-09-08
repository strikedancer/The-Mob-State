import 'dart:convert';

import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../services/api_client.dart';
import '../utils/formatters.dart';
import '../utils/web_asset_helper.dart';
import '../widgets/action_result_toast.dart';

const Color _raceGold = Color(0xFFFFB347);
const Color _raceBgStart = Color(0xFF160707);
const Color _raceBgMid = Color(0xFF261010);
const Color _raceBgEnd = Color(0xFF100505);
const Color _racePanelDark = Color(0xFF1B1212);
const Color _racePanelLight = Color(0xFF2A1A1A);

class RaceScreen extends StatefulWidget {
  const RaceScreen({super.key, this.embedded = false});

  final bool embedded;

  @override
  State<RaceScreen> createState() => _RaceScreenState();
}

class _RaceScreenState extends State<RaceScreen> {
  final ApiClient _api = ApiClient();
  final _stakeController = TextEditingController();
  final _betController = TextEditingController();

  bool _loading = true;
  String? _error;
  Map<String, dynamic>? _overview;
  bool _busy = false;
  bool _fixing = false;
  int? _selectedCarId;
  int? _selectedEntryId;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _stakeController.dispose();
    _betController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final response = await _api.get('/races/overview');
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode != 200) {
        setState(() {
          _loading = false;
          _error = _errorFromPayload(data);
        });
        return;
      }
      setState(() {
        _overview = data;
        _loading = false;
        _selectedCarId ??= ((data['eligibleCars'] as List?) ?? [])
            .cast<dynamic>()
            .map((row) => (row as Map)['inventoryId'] as int?)
            .firstWhere((id) => id != null, orElse: () => null);
      });
    } catch (_) {
      setState(() {
        _loading = false;
        _error = AppLocalizations.of(context)?.raceErrorGeneric ?? '';
      });
    }
  }

  String _errorFromPayload(Map<String, dynamic> data) {
    final l10n = AppLocalizations.of(context)!;
    final params = (data['params'] as Map?)?.cast<String, dynamic>() ?? {};
    final reason = (params['reason'] ?? '').toString();
    switch (reason) {
      case 'DISABLED':
        return l10n.raceErrorDisabled;
      case 'JAILED':
        return l10n.raceErrorJailed;
      case 'TRAVELING':
        return l10n.raceErrorTraveling;
      case 'FUNDS':
        return l10n.raceErrorFunds;
      case 'COOLDOWN':
        return l10n.raceErrorCooldown;
      case 'CLOSED':
        return l10n.raceErrorClosed;
      case 'ALREADY_ENTERED':
        return l10n.raceErrorEntered;
      case 'FULL':
        return l10n.raceErrorFull;
      case 'VEHICLE_INVALID':
        return l10n.raceErrorVehicle;
      case 'CONDITION':
        return l10n.raceErrorCondition;
      case 'BET_OWN':
        return l10n.raceErrorBetOwn;
      case 'BET_CAP':
        return l10n.raceErrorBetCap;
      case 'RANK_TOO_LOW':
        return l10n.raceErrorRank((params['requiredRank'] as num?)?.toInt() ?? 3);
      default:
        return l10n.raceErrorGeneric;
    }
  }

  Future<void> _post(String path, Map<String, dynamic> body) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final response = await _api.post(path, body);
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode != 200) {
        if (!mounted) return;
        showActionResultToast(context, title: _errorFromPayload(data), success: false);
        return;
      }
      if (!mounted) return;
      setState(() => _overview = data);
      showActionResultToast(context, title: AppLocalizations.of(context)!.raceActionOk);
    } catch (_) {
      if (!mounted) return;
      showActionResultToast(
        context,
        title: AppLocalizations.of(context)!.raceErrorGeneric,
        success: false,
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  BoxDecoration _panelDecoration({Color accent = _raceGold}) {
    return BoxDecoration(
      gradient: const LinearGradient(
        colors: [_racePanelLight, _racePanelDark],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: accent.withValues(alpha: 0.45)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.28),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  ButtonStyle get _goldFill => FilledButton.styleFrom(
        backgroundColor: _raceGold,
        foregroundColor: const Color(0xFF1A0C0C),
        disabledBackgroundColor: _raceGold.withValues(alpha: 0.28),
        disabledForegroundColor: const Color(0xFF1A0C0C).withValues(alpha: 0.55),
        visualDensity: VisualDensity.compact,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      );

  ButtonStyle get _goldOutline => OutlinedButton.styleFrom(
        foregroundColor: _raceGold,
        side: BorderSide(color: _raceGold.withValues(alpha: 0.75)),
        visualDensity: VisualDensity.compact,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      );

  InputDecoration _fieldDecoration(String label, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.72)),
      hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.4)),
      filled: true,
      fillColor: Colors.black.withValues(alpha: 0.28),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: _raceGold.withValues(alpha: 0.35)),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(color: _raceGold),
      ),
    );
  }

  int _gridCols(double width) {
    if (width >= 1040) return 4;
    if (width >= 700) return 3;
    if (width >= 480) return 2;
    return 1;
  }

  double _cardImageHeight(int cols) {
    switch (cols) {
      case 4:
        return 110;
      case 3:
        return 122;
      default:
        return 148;
    }
  }

  Widget _wrapGrid({required double width, required List<Widget> children}) {
    const gap = 12.0;
    final cols = _gridCols(width);
    final cardW = cols <= 1 ? width : (width - gap * (cols - 1)) / cols;
    return Wrap(
      spacing: gap,
      runSpacing: gap,
      crossAxisAlignment: WrapCrossAlignment.start,
      children: [
        for (final child in children)
          SizedBox(width: cardW, child: child),
      ],
    );
  }

  Widget _raceImage(
    String? assetPath, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
  }) {
    if (assetPath == null || assetPath.isEmpty) {
      return Container(
        width: width,
        height: height,
        color: const Color(0xFF1E1414),
        alignment: Alignment.center,
        child: Icon(Icons.directions_car, color: _raceGold.withValues(alpha: 0.55), size: 36),
      );
    }
    final isVehicle = assetPath.contains('/vehicles/');
    final loader = isVehicle ? WebAssetHelper.imageHttpFirst : WebAssetHelper.image;
    return loader(
      assetPath,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: width,
          height: height,
          color: const Color(0xFF1E1414),
          alignment: Alignment.center,
          child: Icon(Icons.directions_car, color: _raceGold.withValues(alpha: 0.55), size: 36),
        );
      },
    );
  }

  String? _vehicleAsset(Map<String, dynamic> row) {
    final image = row['image']?.toString();
    if (image == null || image.isEmpty) return null;
    return 'assets/images/vehicles/$image';
  }

  Widget _badge(String text, {Color color = _raceGold}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.7)),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _statChip({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _raceGold.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: _raceGold),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 4),
      child: Text(
        text,
        style: const TextStyle(
          color: _raceGold,
          fontWeight: FontWeight.w700,
          fontSize: 15,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    late final Widget child;
    if (_loading) {
      child = const Center(child: CircularProgressIndicator(color: _raceGold));
    } else if (_error != null) {
      child = Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_error!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white)),
              const SizedBox(height: 12),
              FilledButton(style: _goldFill, onPressed: _load, child: Text(l10n.retry)),
            ],
          ),
        ),
      );
    } else {
      child = RefreshIndicator(
        color: _raceGold,
        onRefresh: _load,
        child: _buildBody(l10n),
      );
    }
    return _shell(child: child);
  }

  Widget _shell({required Widget child}) {
    final painted = DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [_raceBgStart, _raceBgMid, _raceBgEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: child,
    );
    if (widget.embedded) return painted;
    return Scaffold(
      backgroundColor: _raceBgEnd,
      appBar: AppBar(
        backgroundColor: _raceBgStart,
        foregroundColor: _raceGold,
        title: Text(AppLocalizations.of(context)!.raceMenuLabel),
      ),
      body: painted,
    );
  }

  Widget _buildBody(AppLocalizations l10n) {
    final meeting = (_overview?['meeting'] as Map?)?.cast<String, dynamic>();
    final config = (_overview?['config'] as Map?)?.cast<String, dynamic>() ?? {};
    final cars = ((_overview?['eligibleCars'] as List?) ?? [])
        .whereType<Map>()
        .map((row) => row.cast<String, dynamic>())
        .toList();
    final last = (_overview?['lastResult'] as Map?)?.cast<String, dynamic>();
    final cooldownUntil = _overview?['cooldownUntil']?.toString();

    return LayoutBuilder(
      builder: (context, constraints) {
        const pad = 12.0;
        final paneW = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;
        final innerW = (paneW - pad * 2).clamp(0.0, double.infinity);
        final cols = _gridCols(innerW);
        final imageH = _cardImageHeight(cols);
        return ListView(
          padding: const EdgeInsets.all(pad),
          children: [
            _buildHero(l10n, meeting, cooldownUntil),
            const SizedBox(height: 12),
            Text(
              l10n.raceIntro,
              style: TextStyle(color: Colors.white.withValues(alpha: 0.74)),
            ),
            const SizedBox(height: 12),
            if (meeting == null)
              Container(
                decoration: _panelDecoration(),
                padding: const EdgeInsets.all(16),
                child: Text(
                  cooldownUntil != null ? l10n.raceCooldown : l10n.raceNoMeeting,
                  style: const TextStyle(color: Colors.white),
                ),
              )
            else ...[
              _meetingPanel(l10n, meeting, config, cars),
              if ((meeting['myEntry'] as Map?) == null && cars.isNotEmpty) ...[
                const SizedBox(height: 16),
                _sectionTitle(l10n.racePickCar),
                _wrapGrid(
                  width: innerW,
                  children: [
                    for (final car in cars)
                      _carCard(l10n, car, imageHeight: imageH),
                  ],
                ),
              ],
              const SizedBox(height: 16),
              _sectionTitle(l10n.raceField),
              _fieldGrid(l10n, meeting, config, innerW, imageH),
            ],
            if (last != null) ...[
              const SizedBox(height: 16),
              _sectionTitle(l10n.raceLastResult),
              _resultGrid(l10n, last, innerW, imageH),
            ],
          ],
        );
      },
    );
  }

  Widget _buildHero(AppLocalizations l10n, Map<String, dynamic>? meeting, String? cooldownUntil) {
    final wide = MediaQuery.sizeOf(context).width >= 720;
    final height = wide ? 168.0 : 148.0;
    final endsIn = (meeting?['endsInSeconds'] as num?)?.toInt();
    final rakeBps = (meeting?['rakeBps'] as num?)?.toInt();
    return Container(
      decoration: _panelDecoration(),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            _raceImage('assets/images/races/hub.png'),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.black.withValues(alpha: 0.82),
                    Colors.black.withValues(alpha: 0.42),
                    Colors.black.withValues(alpha: 0.18),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          l10n.raceMenuLabel,
                          style: const TextStyle(
                            color: _raceGold,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: _busy ? null : _load,
                        color: _raceGold,
                        icon: const Icon(Icons.refresh),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (meeting != null && endsIn != null)
                        _statChip(icon: Icons.timer, label: l10n.raceEndsIn(_formatSeconds(endsIn))),
                      if (meeting != null && rakeBps != null)
                        _statChip(icon: Icons.attach_money, label: l10n.raceRake((rakeBps / 100).round())),
                      if (meeting == null && cooldownUntil != null)
                        _statChip(icon: Icons.hourglass_bottom, label: l10n.raceCooldown),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _meetingPanel(
    AppLocalizations l10n,
    Map<String, dynamic> meeting,
    Map<String, dynamic> config,
    List<Map<String, dynamic>> cars,
  ) {
    final myEntry = (meeting['myEntry'] as Map?)?.cast<String, dynamic>();
    return Container(
      decoration: _panelDecoration(),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(l10n.raceLiveTitle),
          if (myEntry != null)
            Text(l10n.raceYouEntered, style: const TextStyle(color: Colors.white))
          else if (cars.isEmpty)
            Text(l10n.raceNeedCar, style: const TextStyle(color: Colors.white))
          else ...[
            TextField(
              controller: _stakeController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              cursorColor: _raceGold,
              decoration: _fieldDecoration(
                l10n.raceStake,
                hint: '${config['minStake']}-${config['maxStake']}',
              ),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              activeColor: _raceGold,
              title: Text(l10n.raceFixing, style: const TextStyle(color: Colors.white)),
              subtitle: Text(
                l10n.raceFixingHint,
                style: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
              ),
              value: _fixing,
              onChanged: (value) => setState(() => _fixing = value),
            ),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: _goldFill,
                onPressed: _busy || _selectedCarId == null
                    ? null
                    : () => _post('/races/enter', {
                          'vehicleInventoryId': _selectedCarId,
                          'stake': int.tryParse(_stakeController.text.trim()) ?? 0,
                          'fixing': _fixing,
                        }),
                child: Text(l10n.raceEnter),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _carCard(AppLocalizations l10n, Map<String, dynamic> car, {required double imageHeight}) {
    final id = car['inventoryId'] as int?;
    final selected = id != null && id == _selectedCarId;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: id == null ? null : () => setState(() => _selectedCarId = id),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: _panelDecoration(accent: selected ? _raceGold : _raceGold.withValues(alpha: 0.35)),
          foregroundDecoration: selected
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _raceGold, width: 2),
                )
              : null,
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: imageHeight,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _raceImage(_vehicleAsset(car)),
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0x14000000), Color(0xB8000000)],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: _badge('${car['condition']}%'),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      car['name']?.toString() ?? car['vehicleId']?.toString() ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${l10n.raceSpeedLabel}: ${car['speed']}',
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.74), fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _fieldGrid(
    AppLocalizations l10n,
    Map<String, dynamic> meeting,
    Map<String, dynamic> config,
    double innerW,
    double imageH,
  ) {
    final entries = ((meeting['entries'] as List?) ?? [])
        .whereType<Map>()
        .map((row) => row.cast<String, dynamic>())
        .toList();
    final myEntryId = (meeting['myEntry'] as Map?)?['id'] as int?;
    if (entries.isEmpty) {
      return Container(
        decoration: _panelDecoration(),
        padding: const EdgeInsets.all(16),
        child: Text(l10n.raceNoEntries, style: const TextStyle(color: Colors.white)),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _wrapGrid(
          width: innerW,
          children: [
            for (final entry in entries)
              _entryCard(l10n, entry, imageHeight: imageH),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: _panelDecoration(),
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _betController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                cursorColor: _raceGold,
                decoration: _fieldDecoration(
                  l10n.raceBetAmount,
                  hint: '${config['minBet']}-${config['maxBet']}',
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: _goldOutline,
                  onPressed: _busy ||
                          _selectedEntryId == null ||
                          _selectedEntryId == myEntryId
                      ? null
                      : () => _post('/races/bet', {
                            'entryId': _selectedEntryId,
                            'amount': int.tryParse(_betController.text.trim()) ?? 0,
                          }),
                  child: Text(l10n.racePlaceBet),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _entryCard(
    AppLocalizations l10n,
    Map<String, dynamic> entry, {
    required double imageHeight,
  }) {
    final id = entry['id'] as int?;
    final selected = id != null && id == _selectedEntryId;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: id == null ? null : () => setState(() => _selectedEntryId = id),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: _panelDecoration(accent: selected ? _raceGold : _raceGold.withValues(alpha: 0.35)),
          foregroundDecoration: selected
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _raceGold, width: 2),
                )
              : null,
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: imageHeight,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _raceImage(_vehicleAsset(entry)),
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0x14000000), Color(0xB8000000)],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: _badge(formatCurrency((entry['stake'] as num?)?.toInt() ?? 0)),
                    ),
                    if (entry['fixing'] == true)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: _badge(l10n.raceFixing, color: const Color(0xFFFF8A80)),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry['username']?.toString() ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      entry['name']?.toString() ?? entry['vehicleId']?.toString() ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.74), fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _resultGrid(
    AppLocalizations l10n,
    Map<String, dynamic> last,
    double innerW,
    double imageH,
  ) {
    final entries = ((last['entries'] as List?) ?? [])
        .whereType<Map>()
        .map((row) => row.cast<String, dynamic>())
        .toList();
    return _wrapGrid(
      width: innerW,
      children: [
        for (final entry in entries)
          _resultCard(entry, imageHeight: imageH),
      ],
    );
  }

  Widget _resultCard(Map<String, dynamic> entry, {required double imageHeight}) {
    final place = entry['finishPlace'];
    return Container(
      decoration: _panelDecoration(),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: imageHeight,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                _raceImage(_vehicleAsset(entry)),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0x14000000), Color(0xB8000000)],
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: _badge('#${place ?? '-'}'),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: _badge(formatCurrency((entry['payout'] as num?)?.toInt() ?? 0)),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: Text(
              entry['username']?.toString() ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }

  String _formatSeconds(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }
}
