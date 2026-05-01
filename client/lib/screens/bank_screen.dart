import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../services/api_client.dart';
import '../utils/top_right_notification.dart';
import '../l10n/app_localizations.dart';

class BankScreen extends StatefulWidget {
  const BankScreen({super.key});

  @override
  State<BankScreen> createState() => _BankScreenState();
}

class _BankScreenState extends State<BankScreen> {
  final ApiClient _apiClient = ApiClient();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _amountDescriptionController =
      TextEditingController();
  final TextEditingController _transferUsernameController =
      TextEditingController();
  final TextEditingController _transferAmountController =
      TextEditingController();
  final TextEditingController _transferDescriptionController =
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
  Map<String, int> _transactionSummary = const {
    'deposits': 0,
    'withdrawals': 0,
    'transfersSent': 0,
    'transfersReceived': 0,
  };
  List<Map<String, dynamic>> _transactions = const [];
  List<Map<String, dynamic>> _transferSuggestions = const [];
  List<Map<String, dynamic>> _recentRecipients = const [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _refreshAll();
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _amountController.dispose();
    _amountDescriptionController.dispose();
    _transferUsernameController.dispose();
    _transferAmountController.dispose();
    _transferDescriptionController.dispose();
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
    final l10n = AppLocalizations.of(context)!;
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
              data['params']?['reason']?.toString() ??
              l10n.bankScreenLoadFailed;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = l10n.bankScreenErrNetwork(e.toString());
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
          _transactionSummary = {
            'deposits': (params?['summary']?['deposits'] as num?)?.toInt() ?? 0,
            'withdrawals':
                (params?['summary']?['withdrawals'] as num?)?.toInt() ?? 0,
            'transfersSent':
                (params?['summary']?['transfersSent'] as num?)?.toInt() ?? 0,
            'transfersReceived':
                (params?['summary']?['transfersReceived'] as num?)?.toInt() ??
                0,
          };
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

  String? _transactionCounterpartyLabel(
    AppLocalizations l10n,
    Map<String, dynamic> transaction,
  ) {
    final type = (transaction['type']?.toString() ?? '').toLowerCase();
    final username = transaction['counterpartyUsername']?.toString().trim();
    if (username == null || username.isEmpty) {
      return null;
    }

    if (type == 'transfer_sent') {
      return l10n.bankScreenCounterpartyTo(username);
    }

    if (type == 'transfer_received') {
      return l10n.bankScreenCounterpartyFrom(username);
    }

    return null;
  }

  String? _transactionDescription(Map<String, dynamic> transaction) {
    final description = transaction['description']?.toString().trim();
    if (description == null || description.isEmpty) {
      return null;
    }

    return description;
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
    final l10n = AppLocalizations.of(context)!;
    final amount = int.tryParse(_amountController.text.trim()) ?? 0;
    final description = _amountDescriptionController.text.trim();
    if (amount <= 0) return;

    setState(() => _isSubmitting = true);

    try {
      final response = await _apiClient.post('/bank/deposit', {
        'amount': amount,
        'description': description.isEmpty ? null : description,
      });
      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        final params = data['params'] as Map<String, dynamic>?;
        setState(() {
          _balance = (params?['bankBalance'] as num?)?.toInt() ?? _balance;
          _amountController.clear();
          _amountDescriptionController.clear();
        });
        if (mounted) {
          await Provider.of<AuthProvider>(
            context,
            listen: false,
          ).refreshPlayer();
          await _refreshAll(page: 1);
          showTopRightFromSnackBar(
            context,
            SnackBar(
              content: Text(l10n.bankScreenDepositSuccess),
            ),
          );
        }
      } else {
        if (mounted) {
          showTopRightFromSnackBar(
            context,
            SnackBar(
              content: Text(
                data['params']?['reason']?.toString() ??
                    l10n.bankScreenDepositFailed,
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(l10n.bankScreenErrNetwork(e.toString())),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  Future<void> _withdraw() async {
    final l10n = AppLocalizations.of(context)!;
    final amount = int.tryParse(_amountController.text.trim()) ?? 0;
    final description = _amountDescriptionController.text.trim();
    if (amount <= 0) return;

    setState(() => _isSubmitting = true);

    try {
      final response = await _apiClient.post('/bank/withdraw', {
        'amount': amount,
        'description': description.isEmpty ? null : description,
      });
      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        final params = data['params'] as Map<String, dynamic>?;
        setState(() {
          _balance = (params?['bankBalance'] as num?)?.toInt() ?? _balance;
          _amountController.clear();
          _amountDescriptionController.clear();
        });
        if (mounted) {
          await Provider.of<AuthProvider>(
            context,
            listen: false,
          ).refreshPlayer();
          await _refreshAll(page: 1);
          showTopRightFromSnackBar(
            context,
            SnackBar(
              content: Text(l10n.bankScreenWithdrawSuccess),
            ),
          );
        }
      } else {
        if (mounted) {
          showTopRightFromSnackBar(
            context,
            SnackBar(
              content: Text(
                data['params']?['reason']?.toString() ??
                    l10n.bankScreenWithdrawFailed,
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(l10n.bankScreenErrNetwork(e.toString())),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  Future<void> _transfer() async {
    final l10n = AppLocalizations.of(context)!;
    final recipientUsername = _transferUsernameController.text.trim();
    final amount = int.tryParse(_transferAmountController.text.trim()) ?? 0;
    final description = _transferDescriptionController.text.trim();
    if (recipientUsername.isEmpty || amount <= 0) return;

    setState(() => _isSubmitting = true);

    try {
      final response = await _apiClient.post('/bank/transfer', {
        'recipientUsername': recipientUsername,
        'amount': amount,
        'description': description.isEmpty ? null : description,
      });
      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        final params = data['params'] as Map<String, dynamic>?;
        setState(() {
          _balance = (params?['bankBalance'] as num?)?.toInt() ?? _balance;
          _transferAmountController.clear();
          _transferDescriptionController.clear();
          _transferUsernameController.clear();
          _transferSuggestions = const [];
        });
        if (mounted) {
          await _refreshAll(page: 1);
          showTopRightFromSnackBar(
            context,
            SnackBar(
              content: Text(
                l10n.bankScreenTransferSuccess(
                  amount.toString(),
                  recipientUsername,
                ),
              ),
            ),
          );
        }
      } else {
        String message = l10n.bankScreenTransferFailed;
        final event = data['event']?.toString();
        if (event == 'error.recipient_not_found') {
          message = l10n.bankScreenErrRecipientNotFound;
        } else if (event == 'error.cannot_transfer_to_self') {
          message = l10n.bankScreenErrCannotTransferToSelf;
        } else if (event == 'error.insufficient_balance') {
          message = l10n.bankScreenErrInsufficientBalance;
        } else if (event == 'error.invalid_amount') {
          message = l10n.bankScreenErrInvalidAmount;
        }

        if (mounted) {
          showTopRightFromSnackBar(context, SnackBar(content: Text(message)));
        }
      }
    } catch (e) {
      if (mounted) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(l10n.bankScreenErrNetwork(e.toString())),
          ),
        );
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
    final l10n = AppLocalizations.of(context)!;
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
                child: Text(l10n.bankScreenTryAgain),
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
                Text(
                  l10n.bank,
                  style: const TextStyle(
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
                      l10n.bankScreenWorldwideSubtitle,
                      style: const TextStyle(
                        color: Color(0xFFD4AF37),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      l10n.bankScreenCashOnHand(cash),
                      style: const TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      l10n.bankScreenBalanceLine(_balance),
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
                labelText: l10n.bankScreenAmountLabel,
                labelStyle: TextStyle(color: Colors.grey.shade300),
                filled: true,
                fillColor: Colors.grey.shade900,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _amountDescriptionController,
              maxLength: 160,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: l10n.bankScreenDescriptionOptional,
                helperText: l10n.bankScreenDescriptionDepositHint,
                helperStyle: TextStyle(color: Colors.grey.shade500),
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
                    label: Text(l10n.bankScreenDepositButton),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isSubmitting ? null : _withdraw,
                    icon: const Icon(Icons.arrow_upward),
                    label: Text(l10n.bankScreenWithdrawButton),
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
                      l10n.bankScreenTransferSectionTitle,
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
                        labelText: l10n.bankScreenRecipientUsername,
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
                        l10n.bankScreenRecentRecipients,
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
                                      l10n.bankScreenRankLabel(rank),
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
                        labelText: l10n.bankScreenAmountLabel,
                        labelStyle: TextStyle(color: Colors.grey.shade300),
                        filled: true,
                        fillColor: Colors.grey.shade800,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _transferDescriptionController,
                      maxLength: 160,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: l10n.bankScreenDescriptionOptional,
                        helperText: l10n.bankScreenDescriptionTransferHint,
                        helperStyle: TextStyle(color: Colors.grey.shade500),
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
                        label: Text(l10n.bankScreenTransferButton),
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
                          l10n.bankScreenTransactionsTitle,
                          style: const TextStyle(
                            color: Color(0xFFD4AF37),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          l10n.bankScreenTransactionsTotal(_totalTransactions),
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildTransactionSummaryChip(
                          label: l10n.bankScreenSummaryDeposits,
                          value: _transactionSummary['deposits'] ?? 0,
                          color: Colors.greenAccent,
                        ),
                        _buildTransactionSummaryChip(
                          label: l10n.bankScreenSummaryWithdrawals,
                          value: _transactionSummary['withdrawals'] ?? 0,
                          color: Colors.redAccent,
                        ),
                        _buildTransactionSummaryChip(
                          label: l10n.bankScreenSummarySent,
                          value: _transactionSummary['transfersSent'] ?? 0,
                          color: const Color(0xFFD4AF37),
                        ),
                        _buildTransactionSummaryChip(
                          label: l10n.bankScreenSummaryReceived,
                          value: _transactionSummary['transfersReceived'] ?? 0,
                          color: Colors.lightBlueAccent,
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
                                l10n.bankScreenNoTransactions,
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
                                final counterpartyLabel =
                                    _transactionCounterpartyLabel(
                                  l10n,
                                  transaction,
                                );
                                final description = _transactionDescription(
                                  transaction,
                                );
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
                                                  ? l10n.bankScreenTxnDeposit
                                                  : isWithdraw
                                                  ? l10n.bankScreenTxnWithdraw
                                                  : isTransferSent
                                                  ? l10n.bankScreenTxnTransferSent
                                                  : l10n
                                                        .bankScreenTxnTransferReceived,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            if (counterpartyLabel != null) ...[
                                              const SizedBox(height: 2),
                                              Text(
                                                counterpartyLabel,
                                                style: const TextStyle(
                                                  color: Color(0xFFD4AF37),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                            if (description != null) ...[
                                              const SizedBox(height: 2),
                                              Text(
                                                description,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 12,
                                                  fontStyle: FontStyle.italic,
                                                ),
                                              ),
                                            ],
                                            const SizedBox(height: 2),
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
                                child: Text(l10n.bankScreenPrevious),
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
                                child: Text(l10n.bankScreenNext),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l10n.bankScreenPageOf(_currentPage, _totalPages),
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

  Widget _buildTransactionSummaryChip({
    required String label,
    required int value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(0.6)),
      ),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextSpan(
              text: '$value',
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
