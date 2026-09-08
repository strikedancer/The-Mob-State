import 'dart:convert';

import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../services/api_client.dart';
import '../utils/formatters.dart';
import '../widgets/action_result_toast.dart';

class DonScreen extends StatefulWidget {
  const DonScreen({super.key, this.embedded = false});

  final bool embedded;

  @override
  State<DonScreen> createState() => _DonScreenState();
}

class _DonScreenState extends State<DonScreen> with SingleTickerProviderStateMixin {
  final ApiClient _api = ApiClient();
  final _borrowerController = TextEditingController();
  final _principalController = TextEditingController();

  late final TabController _tabs;
  bool _loading = true;
  String? _error;
  Map<String, dynamic>? _overview;
  bool _busy = false;
  bool _bidFromCrew = false;
  bool _bidGreedy = false;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 4, vsync: this);
    _load();
  }

  @override
  void dispose() {
    _tabs.dispose();
    _borrowerController.dispose();
    _principalController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final response = await _api.get('/don/overview');
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
      });
    } catch (_) {
      setState(() {
        _loading = false;
        _error = AppLocalizations.of(context)?.donErrorGeneric ?? '';
      });
    }
  }

  String _errorFromPayload(Map<String, dynamic> data) {
    final l10n = AppLocalizations.of(context)!;
    final params = (data['params'] as Map?)?.cast<String, dynamic>() ?? {};
    final reason = (params['reason'] ?? '').toString();
    switch (reason) {
      case 'DISABLED':
        return l10n.donErrorDisabled;
      case 'JAILED':
        return l10n.donErrorJailed;
      case 'WRONG_COUNTRY':
        return l10n.donErrorWrongCountry;
      case 'INSUFFICIENT_FUNDS':
        return l10n.donErrorFunds;
      case 'COLLECT_COOLDOWN':
        return l10n.donErrorCooldown;
      case 'RACKET_OWNED':
        return l10n.donErrorOwned;
      case 'RACKET_CAP':
        return l10n.donErrorCap;
      case 'NOT_OWNER':
        return l10n.donErrorNotOwner;
      case 'CONTEST_ACTIVE':
        return l10n.donErrorContest;
      case 'NO_CREW_BANK_PERM':
        return l10n.donErrorCrewBank;
      case 'ALDERMAN_REQUIRED':
        return l10n.donErrorAlderman;
      case 'ENGINEERING':
        return l10n.donErrorEngineering((params['requiredLevel'] as num?)?.toInt() ?? 0);
      case 'RANK_TOO_LOW':
        return l10n.donRankGate((params['requiredRank'] as num?)?.toInt() ?? 7);
      case 'INTIMIDATION':
        return l10n.donIntimidationNeed(
          (params['needed'] as num?)?.toInt() ?? 0,
          (params['have'] as num?)?.toInt() ?? 0,
        );
      default:
        return l10n.donErrorGeneric;
    }
  }

  Future<void> _post(String path, [Map<String, dynamic> body = const {}]) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final response = await _api.post(path, body);
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if (!mounted) return;
      if (response.statusCode != 200) {
        showActionResultToast(
          context,
          title: _errorFromPayload(data),
          success: false,
        );
        return;
      }
      final fled = data['result'] is Map && (data['result']['fled'] == true);
      showActionResultToast(
        context,
        title: fled
            ? AppLocalizations.of(context)!.donSqueezeFled
            : AppLocalizations.of(context)!.donSqueezeHeld,
        success: !fled,
      );
      await _load();
    } catch (_) {
      if (!mounted) return;
      showActionResultToast(
        context,
        title: AppLocalizations.of(context)!.donErrorGeneric,
        success: false,
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _postQuietSuccess(String path, [Map<String, dynamic> body = const {}]) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final response = await _api.post(path, body);
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if (!mounted) return;
      if (response.statusCode != 200) {
        showActionResultToast(
          context,
          title: _errorFromPayload(data),
          success: false,
        );
        return;
      }
      final result = data['result'] is Map ? data['result'] as Map : const {};
      final amount = result['amount'] ?? result['collected'] ?? result['repaid'] ?? result['payout'];
      showActionResultToast(
        context,
        title: AppLocalizations.of(context)!.donMenuLabel,
        moneyDelta: amount is num ? formatCurrency(amount) : null,
      );
      await _load();
    } catch (_) {
      if (!mounted) return;
      showActionResultToast(
        context,
        title: AppLocalizations.of(context)!.donErrorGeneric,
        success: false,
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  String _businessName(AppLocalizations l10n, String key) {
    switch (key) {
      case 'cafe':
        return l10n.donBusinessCafe;
      case 'garage':
        return l10n.donBusinessGarage;
      case 'warehouse':
        return l10n.donBusinessWarehouse;
      case 'night_shop':
        return l10n.donBusinessNightShop;
      case 'port_office':
        return l10n.donBusinessPortOffice;
      case 'laundry':
        return l10n.donBusinessLaundry;
      default:
        return key;
    }
  }

  String _npcName(AppLocalizations l10n, String key) {
    switch (key) {
      case 'street_dealer':
        return l10n.donNpcStreetDealer;
      case 'dock_worker':
        return l10n.donNpcDockWorker;
      case 'club_host':
        return l10n.donNpcClubHost;
      default:
        return key;
    }
  }

  String _officeName(AppLocalizations l10n, String key) {
    switch (key) {
      case 'judge':
        return l10n.donOfficeJudge;
      case 'commissioner':
        return l10n.donOfficeCommissioner;
      case 'alderman':
        return l10n.donOfficeAlderman;
      default:
        return key;
    }
  }

  String _contractName(AppLocalizations l10n, String key) {
    switch (key) {
      case 'street_repair':
        return l10n.donContractStreetRepair;
      case 'harbor_crane':
        return l10n.donContractHarborCrane;
      case 'city_hall_wing':
        return l10n.donContractCityHallWing;
      default:
        return key;
    }
  }

  IconData _businessIcon(String key) {
    switch (key) {
      case 'cafe':
        return Icons.local_cafe;
      case 'garage':
        return Icons.garage;
      case 'warehouse':
        return Icons.warehouse;
      case 'night_shop':
        return Icons.storefront;
      case 'port_office':
        return Icons.anchor;
      case 'laundry':
        return Icons.local_laundry_service;
      default:
        return Icons.store;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (_loading && _overview == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null && _overview == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_error!, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              FilledButton(onPressed: _load, child: Text(l10n.retry)),
            ],
          ),
        ),
      );
    }

    final overview = _overview ?? const <String, dynamic>{};
    final money = (overview['money'] as num?)?.toInt() ?? 0;
    final wanted = (overview['wantedLevel'] as num?)?.toInt() ?? 0;
    final intimidation = (overview['intimidation'] as num?)?.toInt() ?? 0;
    final canCrew = overview['canTributeToCrew'] == true;

    final body = Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: Wrap(
                      spacing: 16,
                      runSpacing: 8,
                      children: [
                        Text('${l10n.cash}: ${formatCurrency(money)}'),
                        Text('${l10n.wantedLevel}: $wanted'),
                        Text('${l10n.donCommandStrip}: $intimidation'),
                        if (canCrew) Text(l10n.donTributeCrew),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: _busy ? null : _load,
                    icon: const Icon(Icons.refresh),
                  ),
                ],
              ),
            ),
          ),
        ),
        TabBar(
          controller: _tabs,
          isScrollable: true,
          labelColor: const Color(0xFFFFB347),
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(text: l10n.donTabRackets),
            Tab(text: l10n.donTabLoans),
            Tab(text: l10n.donTabInfluence),
            Tab(text: l10n.donTabContracts),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabs,
            children: [
              _buildRackets(l10n, overview, canCrew),
              _buildLoans(l10n, overview),
              _buildOfficials(l10n, overview),
              _buildContracts(l10n, overview),
            ],
          ),
        ),
      ],
    );

    if (widget.embedded) return body;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.donMenuLabel)),
      body: body,
    );
  }

  Widget _buildRackets(AppLocalizations l10n, Map<String, dynamic> overview, bool canCrew) {
    final rackets = (overview['rackets'] as List?) ?? const [];
    final crewRackets = (overview['crewRackets'] as List?) ?? const [];
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        for (final raw in rackets)
          _racketCard(l10n, Map<String, dynamic>.from(raw as Map), canCrew),
        if (crewRackets.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(l10n.donCrewOverview, style: Theme.of(context).textTheme.titleMedium),
          for (final raw in crewRackets)
            ListTile(
              leading: const Icon(Icons.groups),
              title: Text(_businessName(l10n, (raw as Map)['businessKey']?.toString() ?? '')),
              subtitle: Text(
                '${raw['countryCode'] ?? ''} · ${l10n.donOwnedBy(raw['ownerUsername']?.toString() ?? '-')}',
              ),
            ),
        ],
      ],
    );
  }

  Widget _racketCard(AppLocalizations l10n, Map<String, dynamic> racket, bool canCrew) {
    final id = (racket['id'] as num).toInt();
    final key = racket['businessKey']?.toString() ?? '';
    final mine = racket['isMine'] == true;
    final owner = racket['ownerUsername']?.toString();
    final contestUntil = racket['contestUntil']?.toString();
    final squeezed = racket['squeezed'] == true;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(child: Icon(_businessIcon(key))),
              title: Text(_businessName(l10n, key)),
              subtitle: Text(
                owner == null || owner.isEmpty
                    ? l10n.donFree
                    : l10n.donOwnedBy(owner),
              ),
              trailing: Text(formatCurrency((racket['nextTribute'] as num?) ?? 0)),
            ),
            Text(
              l10n.donIntimidationNeed(
                (racket['minIntimidation'] as num?)?.toInt() ?? 0,
                (overviewIntimidation()),
              ),
            ),
            if (squeezed) Text(l10n.donSqueezeHeld),
            if (contestUntil != null) Text('${l10n.donContest}: $contestUntil'),
            Wrap(
              spacing: 8,
              children: [
                if (!mine && owner == null)
                  FilledButton(
                    onPressed: _busy ? null : () => _postQuietSuccess('/don/rackets/$id/claim'),
                    child: Text(l10n.donClaim),
                  ),
                if (mine)
                  FilledButton(
                    onPressed: _busy ? null : () => _postQuietSuccess('/don/rackets/$id/collect'),
                    child: Text(l10n.donCollect),
                  ),
                if (mine)
                  OutlinedButton(
                    onPressed: _busy ? null : () => _post('/don/rackets/$id/squeeze'),
                    child: Text(l10n.donSqueeze),
                  ),
                if (!mine && owner != null)
                  OutlinedButton(
                    onPressed: _busy ? null : () => _postQuietSuccess('/don/rackets/$id/contest'),
                    child: Text(l10n.donContest),
                  ),
                if (mine && contestUntil != null)
                  OutlinedButton(
                    onPressed: _busy ? null : () => _postQuietSuccess('/don/rackets/$id/hold'),
                    child: Text(l10n.donHold),
                  ),
              ],
            ),
            if (mine && canCrew)
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.donTributeCrew),
                value: racket['tributeToCrew'] == true,
                onChanged: _busy
                    ? null
                    : (value) => _postQuietSuccess('/don/rackets/$id/tribute', {
                          'tributeToCrew': value,
                        }),
              ),
          ],
        ),
      ),
    );
  }

  int overviewIntimidation() => (_overview?['intimidation'] as num?)?.toInt() ?? 0;

  Widget _buildLoans(AppLocalizations l10n, Map<String, dynamic> overview) {
    final npcs = (overview['npcs'] as List?) ?? const [];
    final loans = (overview['loans'] as List?) ?? const [];
    final minP = (overview['loanMinPrincipal'] as num?)?.toInt() ?? 2000;
    final maxP = (overview['loanMaxPrincipal'] as num?)?.toInt() ?? 50000;
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        Text('${l10n.donLoanPrincipalHint}: ${formatCurrency(minP)}–${formatCurrency(maxP)}'),
        const SizedBox(height: 8),
        TextField(
          controller: _principalController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(labelText: l10n.donLoanPrincipalHint),
        ),
        const SizedBox(height: 8),
        for (final raw in npcs)
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: Text(_npcName(l10n, (raw as Map)['key']?.toString() ?? '')),
            trailing: FilledButton(
              onPressed: _busy
                  ? null
                  : () => _postQuietSuccess('/don/loans/npc', {
                        'npcKey': raw['key'],
                        'principal': int.tryParse(_principalController.text) ?? minP,
                      }),
              child: Text(l10n.donLoanNpc),
            ),
          ),
        const Divider(),
        TextField(
          controller: _borrowerController,
          decoration: InputDecoration(labelText: l10n.donLoanBorrowerHint),
        ),
        const SizedBox(height: 8),
        FilledButton(
          onPressed: _busy
              ? null
              : () => _postQuietSuccess('/don/loans/offer', {
                    'borrowerUsername': _borrowerController.text.trim(),
                    'principal': int.tryParse(_principalController.text) ?? minP,
                  }),
          child: Text(l10n.donLoanOffer),
        ),
        const SizedBox(height: 12),
        for (final raw in loans) _loanTile(l10n, Map<String, dynamic>.from(raw as Map)),
      ],
    );
  }

  Widget _loanTile(AppLocalizations l10n, Map<String, dynamic> loan) {
    final id = (loan['id'] as num).toInt();
    final status = loan['status']?.toString() ?? '';
    final isLender = loan['isLender'] == true;
    final npc = loan['npcKey']?.toString();
    final title = npc != null && npc.isNotEmpty
        ? _npcName(l10n, npc)
        : (isLender ? loan['borrowerUsername'] : loan['lenderUsername'])?.toString() ?? '';
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(
          '$status · ${formatCurrency((loan['dueAmount'] as num?) ?? 0)} · ${loan['dueAt'] ?? ''}',
        ),
        trailing: Wrap(
          spacing: 4,
          children: [
            if (!isLender && status == 'offered')
              TextButton(
                onPressed: _busy ? null : () => _postQuietSuccess('/don/loans/$id/accept'),
                child: Text(l10n.donLoanAccept),
              ),
            if (!isLender && status == 'active')
              TextButton(
                onPressed: _busy ? null : () => _postQuietSuccess('/don/loans/$id/repay'),
                child: Text(l10n.donLoanRepay),
              ),
            if (isLender && (status == 'defaulted' || status == 'active'))
              TextButton(
                onPressed: _busy ? null : () => _postQuietSuccess('/don/loans/$id/collect'),
                child: Text(l10n.donLoanCollect),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildOfficials(AppLocalizations l10n, Map<String, dynamic> overview) {
    final officials = (overview['officials'] as List?) ?? const [];
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        for (final raw in officials)
          Builder(
            builder: (_) {
              final row = Map<String, dynamic>.from(raw as Map);
              final office = row['office']?.toString() ?? '';
              final patron = row['patronUsername']?.toString();
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    child: Icon(
                      office == 'judge'
                          ? Icons.gavel
                          : office == 'commissioner'
                              ? Icons.local_police
                              : Icons.account_balance,
                    ),
                  ),
                  title: Text(_officeName(l10n, office)),
                  subtitle: Text(
                    patron == null || patron.isEmpty
                        ? l10n.donFree
                        : '${l10n.donOwnedBy(patron)} · ${row['paidUntil'] ?? ''}',
                  ),
                  trailing: FilledButton(
                    onPressed: _busy
                        ? null
                        : () => _postQuietSuccess('/don/officials/$office/bribe'),
                    child: Text('${l10n.donBribe} ${formatCurrency((row['nextBid'] as num?) ?? 0)}'),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildContracts(AppLocalizations l10n, Map<String, dynamic> overview) {
    final contracts = (overview['contracts'] as List?) ?? const [];
    final canCrew = overview['canTributeToCrew'] == true;
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        if (canCrew)
          SwitchListTile(
            title: Text(l10n.donBidFromCrew),
            value: _bidFromCrew,
            onChanged: (value) => setState(() => _bidFromCrew = value),
          ),
        SwitchListTile(
          title: Text(l10n.donBidGreedy),
          value: _bidGreedy,
          onChanged: (value) => setState(() => _bidGreedy = value),
        ),
        for (final raw in contracts)
          Builder(
            builder: (_) {
              final row = Map<String, dynamic>.from(raw as Map);
              final id = (row['id'] as num).toInt();
              final open = row['status'] == 'open';
              return Card(
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.engineering)),
                  title: Text(_contractName(l10n, row['contractKey']?.toString() ?? '')),
                  subtitle: Text(
                    '${formatCurrency((row['payout'] as num?) ?? 0)} · bid ${formatCurrency((row['bidCost'] as num?) ?? 0)}'
                    '${row['bidderUsername'] != null ? ' · ${row['bidderUsername']}' : ''}',
                  ),
                  trailing: open
                      ? FilledButton(
                          onPressed: _busy
                              ? null
                              : () => _postQuietSuccess('/don/contracts/$id/bid', {
                                    'fromCrew': _bidFromCrew,
                                    'greedy': _bidGreedy,
                                  }),
                          child: Text(l10n.donBid),
                        )
                      : Text(row['status']?.toString() ?? ''),
                ),
              );
            },
          ),
      ],
    );
  }
}
