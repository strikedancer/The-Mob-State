import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../services/api_client.dart';
import '../utils/top_right_notification.dart';

class BankScreen extends StatefulWidget {
  const BankScreen({super.key});

  @override
  State<BankScreen> createState() => _BankScreenState();
}

class _BankScreenState extends State<BankScreen> {
  final ApiClient _apiClient = ApiClient();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _transferUsernameController =
      TextEditingController();
  final TextEditingController _transferAmountController =
      TextEditingController();
  Timer? _searchDebounce;

  bool _isLoading = true;
  bool _isSubmitting = false;
  bool _isLoadingTransactions = false;
  bool _isSearchingUsers = false;
  int _balance = 0;
  int _currentPage = 1;
  int _totalPages = 1;
  int _totalTransactions = 0;
  List<Map<String, dynamic>> _transactions = const [];
  List<Map<String, dynamic>> _transferSuggestions = const [];
  List<Map<String, dynamic>> _recentRecipients = const [];
  String? _error;

  bool get _isNl => Localizations.localeOf(context).languageCode == 'nl';
  String _tr(String nl, String en) => _isNl ? nl : en;

  @override
  void initState() {
    super.initState();
    _refreshAll();
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _amountController.dispose();
    _transferUsernameController.dispose();
    _transferAmountController.dispose();
    super.dispose();
  }

  void _onTransferUsernameChanged(String query) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 250), () {
      _searchTransferUsers(query);
    });
  }

  Future<void> _refreshAll({int page = 1}) async {
    await Future.wait([
      _loadBankAccount(),
      _loadTransactions(page: page),
      _loadRecentRecipients(),
    ]);
  }

  Future<void> _loadRecentRecipients() async {
    try {
      final response = await _apiClient.get('/bank/recent-recipients?limit=8');
      if (response.statusCode != 200) return;

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final params = data['params'] as Map<String, dynamic>?;
      final recipients = (params?['recipients'] as List<dynamic>? ?? [])
          .map((item) => Map<String, dynamic>.from(item as Map))
          .where((item) => (item['username']?.toString().isNotEmpty ?? false))
          .toList();

      if (!mounted) return;
      setState(() {
        _recentRecipients = recipients;
      });
    } catch (_) {
      // best effort only
    }
  }

  Future<void> _loadBankAccount() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await _apiClient.get('/bank/account');
      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        final params = data['params'] as Map<String, dynamic>?;
        final balance = (params?['balance'] as num?)?.toInt() ?? 0;
        setState(() {
          _balance = balance;
          _isLoading = false;
        });
      } else {
        setState(() {
          _error =
              data['params']?['reason']?.toString() ?? _tr('Bank laden mislukt', 'Failed to load bank');
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = _tr('Netwerkfout: $e', 'Network error: $e');
        _isLoading = false;
      });
    }
  }

  Future<void> _loadTransactions({int page = 1}) async {
    setState(() {
      _isLoadingTransactions = true;
    });

    try {
      final response = await _apiClient.get(
        '/bank/transactions?page=$page&limit=20',
      );
      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        final params = data['params'] as Map<String, dynamic>?;
        final tx = (params?['transactions'] as List<dynamic>? ?? [])
            .map((item) => Map<String, dynamic>.from(item as Map))
            .toList();

        setState(() {
          _transactions = tx;
          _currentPage = (params?['page'] as num?)?.toInt() ?? page;
          _totalPages = (params?['totalPages'] as num?)?.toInt() ?? 1;
          _totalTransactions = (params?['total'] as num?)?.toInt() ?? 0;
          _isLoadingTransactions = false;
        });
      } else {
        setState(() {
          _isLoadingTransactions = false;
        });
      }
    } catch (_) {
      setState(() {
        _isLoadingTransactions = false;
      });
    }
  }

  String _formatDate(String? isoDate) {
    if (isoDate == null || isoDate.isEmpty) return '-';
    final parsed = DateTime.tryParse(isoDate);
    if (parsed == null) return '-';

    final local = parsed.toLocal();
    final day = local.day.toString().padLeft(2, '0');
    final month = local.month.toString().padLeft(2, '0');
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    return '$day-$month $hour:$minute';
  }

  List<int> _visiblePages() {
    if (_totalPages <= 7) {
      return List<int>.generate(_totalPages, (index) => index + 1);
    }

    final start = (_currentPage - 2).clamp(1, _totalPages - 4);
    final end = (start + 4).clamp(1, _totalPages);
    return List<int>.generate(end - start + 1, (index) => start + index);
  }

  Widget _pageButton(int page) {
    final isActive = page == _currentPage;
    return InkWell(
      onTap: _isLoadingTransactions || isActive
          ? null
          : () => _loadTransactions(page: page),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFD4AF37) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFD4AF37)),
        ),
        child: Text(
          '$page',
          style: TextStyle(
            color: isActive ? Colors.black : const Color(0xFFD4AF37),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Future<void> _deposit() async {
    final amount = int.tryParse(_amountController.text.trim()) ?? 0;
    if (amount <= 0) return;

    setState(() => _isSubmitting = true);

    try {
      final response = await _apiClient.post('/bank/deposit', {
        'amount': amount,
      });
      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        final params = data['params'] as Map<String, dynamic>?;
        setState(() {
          _balance = (params?['bankBalance'] as num?)?.toInt() ?? _balance;
          _amountController.clear();
        });
        if (mounted) {
          await Provider.of<AuthProvider>(
            context,
            listen: false,
          ).refreshPlayer();
          await _refreshAll(page: 1);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(_tr('Storting gelukt', 'Deposit successful'))));
        }
      } else {
        if (mounted) {
          showTopRightFromSnackBar(context, 
            SnackBar(
              content: Text(
                data['params']?['reason']?.toString() ?? _tr('Storting mislukt', 'Deposit failed'),
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(_tr('Netwerkfout: $e', 'Network error: $e'))));
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  Future<void> _withdraw() async {
    final amount = int.tryParse(_amountController.text.trim()) ?? 0;
    if (amount <= 0) return;

    setState(() => _isSubmitting = true);

    try {
      final response = await _apiClient.post('/bank/withdraw', {
        'amount': amount,
      });
      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        final params = data['params'] as Map<String, dynamic>?;
        setState(() {
          _balance = (params?['bankBalance'] as num?)?.toInt() ?? _balance;
          _amountController.clear();
        });
        if (mounted) {
          await Provider.of<AuthProvider>(
            context,
            listen: false,
          ).refreshPlayer();
          await _refreshAll(page: 1);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(_tr('Opname gelukt', 'Withdrawal successful'))));
        }
      } else {
        if (mounted) {
          showTopRightFromSnackBar(context, 
            SnackBar(
              content: Text(
                data['params']?['reason']?.toString() ?? _tr('Opname mislukt', 'Withdrawal failed'),
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(_tr('Netwerkfout: $e', 'Network error: $e'))));
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  Future<void> _transfer() async {
    final recipientUsername = _transferUsernameController.text.trim();
    final amount = int.tryParse(_transferAmountController.text.trim()) ?? 0;
    if (recipientUsername.isEmpty || amount <= 0) return;

    setState(() => _isSubmitting = true);

    try {
      final response = await _apiClient.post('/bank/transfer', {
        'recipientUsername': recipientUsername,
        'amount': amount,
      });
      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        final params = data['params'] as Map<String, dynamic>?;
        setState(() {
          _balance = (params?['bankBalance'] as num?)?.toInt() ?? _balance;
          _transferAmountController.clear();
          _transferUsernameController.clear();
          _transferSuggestions = const [];
        });
        if (mounted) {
          await _refreshAll(page: 1);
          showTopRightFromSnackBar(context, 
            SnackBar(
              content: Text(_tr('€$amount overgemaakt naar $recipientUsername', '€$amount transferred to $recipientUsername')),
            ),
          );
        }
      } else {
        String message = _tr('Overmaken mislukt', 'Transfer failed');
        final event = data['event']?.toString();
        if (event == 'error.recipient_not_found') {
          message = _tr('Speler niet gevonden', 'Player not found');
        } else if (event == 'error.cannot_transfer_to_self') {
          message = _tr('Je kunt niet naar jezelf overmaken', 'You cannot transfer to yourself');
        } else if (event == 'error.insufficient_balance') {
          message = _tr('Onvoldoende banksaldo', 'Insufficient bank balance');
        } else if (event == 'error.invalid_amount') {
          message = _tr('Ongeldig bedrag', 'Invalid amount');
        }

        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(message)));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(_tr('Netwerkfout: $e', 'Network error: $e'))));
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  Future<void> _searchTransferUsers(String query) async {
    final trimmed = query.trim();

    if (trimmed.length < 2) {
      if (mounted) {
        setState(() {
          _isSearchingUsers = false;
          _transferSuggestions = const [];
        });
      }
      return;
    }

    setState(() {
      _isSearchingUsers = true;
    });

    try {
      final encoded = Uri.encodeComponent(trimmed);
      final response = await _apiClient.get('/friends/search?q=$encoded');

      if (!mounted) return;

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final params = data['params'] as Map<String, dynamic>?;
        final loweredQuery = trimmed.toLowerCase();
        final results = (params?['results'] as List<dynamic>? ?? [])
            .map((item) => Map<String, dynamic>.from(item as Map))
            .where((item) => (item['username']?.toString().isNotEmpty ?? false))
            .toList();

        results.sort((a, b) {
          final aName = (a['username']?.toString() ?? '').toLowerCase();
          final bName = (b['username']?.toString() ?? '').toLowerCase();
          final aExact = aName == loweredQuery;
          final bExact = bName == loweredQuery;
          final aStarts = aName.startsWith(loweredQuery);
          final bStarts = bName.startsWith(loweredQuery);

          if (aExact && !bExact) return -1;
          if (!aExact && bExact) return 1;
          if (aStarts && !bStarts) return -1;
          if (!aStarts && bStarts) return 1;
          return aName.compareTo(bName);
        });

        final limitedResults = results.take(8).toList();

        setState(() {
          _transferSuggestions = limitedResults;
          _isSearchingUsers = false;
        });
      } else {
        setState(() {
          _transferSuggestions = const [];
          _isSearchingUsers = false;
        });
      }
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _transferSuggestions = const [];
        _isSearchingUsers = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cash = Provider.of<AuthProvider>(context).currentPlayer?.money ?? 0;
    final screenWidth = MediaQuery.of(context).size.width;
    final transactionsListHeight = screenWidth < 600
        ? 240.0
        : screenWidth < 900
        ? 300.0
        : 380.0;

    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.amber),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, color: Colors.red, size: 48),
              const SizedBox(height: 12),
              Text(_error!, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _refreshAll,
                child: Text(_tr('Opnieuw proberen', 'Try again')),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshAll,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Bank',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: _isSubmitting ? null : _refreshAll,
                  color: Colors.amber,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Card(
              color: Colors.grey.shade900,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _tr('Bank (wereldwijd toegankelijk)', 'Bank (worldwide accessible)'),
                      style: const TextStyle(
                        color: Color(0xFFD4AF37),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _tr('Contant op zak: €$cash', 'Cash on hand: €$cash'),
                      style: const TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _tr('Bank saldo: €$_balance', 'Bank balance: €$_balance'),
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: _tr('Bedrag', 'Amount'),
                labelStyle: TextStyle(color: Colors.grey.shade300),
                filled: true,
                fillColor: Colors.grey.shade900,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isSubmitting ? null : _deposit,
                    icon: const Icon(Icons.arrow_downward),
                    label: Text(_tr('Storten', 'Deposit')),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isSubmitting ? null : _withdraw,
                    icon: const Icon(Icons.arrow_upward),
                    label: Text(_tr('Opnemen', 'Withdraw')),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Card(
              color: Colors.grey.shade900,
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _tr('Overmaken naar speler', 'Transfer to player'),
                      style: const TextStyle(
                        color: Color(0xFFD4AF37),
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _transferUsernameController,
                      onChanged: _onTransferUsernameChanged,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: _tr('Gebruikersnaam ontvanger', 'Recipient username'),
                        labelStyle: TextStyle(color: Colors.grey.shade300),
                        filled: true,
                        fillColor: Colors.grey.shade800,
                        suffixIcon: _isSearchingUsers
                            ? const Padding(
                                padding: EdgeInsets.all(12),
                                child: SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.amber,
                                  ),
                                ),
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    if (_transferSuggestions.isEmpty &&
                        _recentRecipients.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        _tr('Recente ontvangers', 'Recent recipients'),
                        style: const TextStyle(
                          color: Color(0xFFD4AF37),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _recentRecipients.map((recipient) {
                          final username =
                              recipient['username']?.toString() ?? '';
                          final isFriend = recipient['isFriend'] == true;
                          return InkWell(
                            onTap: () {
                              setState(() {
                                _transferUsernameController.text = username;
                                _transferSuggestions = const [];
                              });
                            },
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 7,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFFD4AF37,
                                ).withOpacity(0.16),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: const Color(0xFFD4AF37),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    username,
                                    style: const TextStyle(
                                      color: Color(0xFFD4AF37),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                  if (isFriend)
                                    const Padding(
                                      padding: EdgeInsets.only(left: 6),
                                      child: Icon(
                                        Icons.people_alt_rounded,
                                        size: 14,
                                        color: Color(0xFFD4AF37),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                    if (_transferSuggestions.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Container(
                        constraints: const BoxConstraints(maxHeight: 180),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade900,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white12),
                        ),
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemCount: _transferSuggestions.length,
                          separatorBuilder: (_, _) =>
                              const Divider(height: 1, color: Colors.white12),
                          itemBuilder: (context, index) {
                            final suggestion = _transferSuggestions[index];
                            final username =
                                suggestion['username']?.toString() ?? '';
                            final rank = suggestion['rank']?.toString();
                            final isFriend =
                                suggestion['friendStatus']?.toString() ==
                                'friends';

                            return ListTile(
                              dense: true,
                              title: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      username,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (isFriend)
                                    const Padding(
                                      padding: EdgeInsets.only(left: 8),
                                      child: Icon(
                                        Icons.people_alt_rounded,
                                        size: 16,
                                        color: Color(0xFFD4AF37),
                                      ),
                                    ),
                                ],
                              ),
                                  subtitle: rank != null
                                  ? Text(
                                      'Rank $rank',
                                      style: const TextStyle(
                                        color: Colors.white60,
                                        fontSize: 12,
                                      ),
                                    )
                                  : null,
                              onTap: () {
                                setState(() {
                                  _transferUsernameController.text = username;
                                  _transferSuggestions = const [];
                                });
                              },
                            );
                          },
                        ),
                      ),
                    ],
                    const SizedBox(height: 10),
                    TextField(
                      controller: _transferAmountController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: _tr('Bedrag', 'Amount'),
                        labelStyle: TextStyle(color: Colors.grey.shade300),
                        filled: true,
                        fillColor: Colors.grey.shade800,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _isSubmitting ? null : _transfer,
                        icon: const Icon(Icons.swap_horiz),
                        label: Text(_tr('Overmaken', 'Transfer')),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            Card(
              color: Colors.grey.shade900,
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _tr('Transacties', 'Transactions'),
                          style: const TextStyle(
                            color: Color(0xFFD4AF37),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          _tr('$_totalTransactions totaal', '$_totalTransactions total'),
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: transactionsListHeight,
                      child: _isLoadingTransactions
                          ? const Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                child: CircularProgressIndicator(
                                  color: Colors.amber,
                                ),
                              ),
                            )
                          : _transactions.isEmpty
                          ? Center(
                              child: Text(
                                _tr('Nog geen transacties', 'No transactions yet'),
                                style: const TextStyle(color: Colors.white70),
                              ),
                            )
                          : ListView.builder(
                              itemCount: _transactions.length,
                              itemBuilder: (context, index) {
                                final transaction = _transactions[index];
                                final type =
                                    (transaction['type']?.toString() ?? '')
                                        .toLowerCase();
                                final isDeposit = type == 'deposit';
                                final isWithdraw = type == 'withdraw';
                                final isTransferSent = type == 'transfer_sent';
                                final isIncoming =
                                    isDeposit || type == 'transfer_received';
                                final amount =
                                    (transaction['amount'] as num?)?.toInt() ??
                                    0;
                                final createdAt = _formatDate(
                                  transaction['createdAt']?.toString(),
                                );

                                return Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.25),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.white12),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        isIncoming
                                            ? Icons.add_circle_outline
                                            : Icons.remove_circle_outline,
                                        color: isIncoming
                                            ? Colors.greenAccent
                                            : Colors.redAccent,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              isDeposit
                                                  ? _tr('Storting', 'Deposit')
                                                  : isWithdraw
                                                  ? _tr('Opname', 'Withdrawal')
                                                  : isTransferSent
                                                  ? _tr('Overboeking verzonden', 'Transfer sent')
                                                  : _tr('Overboeking ontvangen', 'Transfer received'),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              createdAt,
                                              style: const TextStyle(
                                                color: Colors.white54,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        '${isIncoming ? '+' : '-'}€$amount',
                                        style: TextStyle(
                                          color: isIncoming
                                              ? Colors.greenAccent
                                              : Colors.redAccent,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
                    const SizedBox(height: 8),
                    if (_totalPages > 1)
                      Column(
                        children: [
                          Wrap(
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 6,
                            runSpacing: 6,
                            children: [
                              OutlinedButton(
                                onPressed:
                                    _currentPage > 1 && !_isLoadingTransactions
                                    ? () => _loadTransactions(
                                        page: _currentPage - 1,
                                      )
                                    : null,
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                    color: Color(0xFFD4AF37),
                                  ),
                                  foregroundColor: const Color(0xFFD4AF37),
                                ),
                                child: Text(_tr('Vorige', 'Previous')),
                              ),
                              if (_visiblePages().first > 1) ...[
                                _pageButton(1),
                                if (_visiblePages().first > 2)
                                  const Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 4,
                                    ),
                                    child: Text(
                                      '...',
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                  ),
                              ],
                              ..._visiblePages().map(_pageButton),
                              if (_visiblePages().last < _totalPages) ...[
                                if (_visiblePages().last < _totalPages - 1)
                                  const Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 4,
                                    ),
                                    child: Text(
                                      '...',
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                  ),
                                _pageButton(_totalPages),
                              ],
                              OutlinedButton(
                                onPressed:
                                    _currentPage < _totalPages &&
                                        !_isLoadingTransactions
                                    ? () => _loadTransactions(
                                        page: _currentPage + 1,
                                      )
                                    : null,
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                    color: Color(0xFFD4AF37),
                                  ),
                                  foregroundColor: const Color(0xFFD4AF37),
                                ),
                                child: Text(_tr('Volgende', 'Next')),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _tr('Pagina $_currentPage van $_totalPages', 'Page $_currentPage of $_totalPages'),
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
