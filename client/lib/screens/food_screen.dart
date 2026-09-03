import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../providers/auth_provider.dart';
import '../services/api_client.dart';
import '../utils/top_right_notification.dart';

class FoodScreen extends StatefulWidget {
  const FoodScreen({super.key});

  @override
  State<FoodScreen> createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen> {
  final ApiClient _apiClient = ApiClient();
  bool _isLoading = true;
  List<dynamic> _foodItems = [];
  List<dynamic> _drinkItems = [];
  double? _hunger;
  double? _thirst;

  @override
  void initState() {
    super.initState();
    _loadMenu();
  }

  Future<void> _loadMenu() async {
    setState(() => _isLoading = true);

    try {
      final response = await _apiClient.get('/food/menu');
      final data = jsonDecode(response.body);

      if (data['event'] == 'food.menu') {
        setState(() {
          _foodItems = data['params']['food'] ?? [];
          _drinkItems = data['params']['drinks'] ?? [];
          _hunger = (data['params']['hunger'] as num?)?.toDouble();
          _thirst = (data['params']['thirst'] as num?)?.toDouble();
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
          showTopRightFromSnackBar(
            context,
            SnackBar(
              content: Text('${l10n.unexpectedResponse}: ${data['event']}'),
            ),
          );
        }
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('${l10n.errorLoadingMenu}: $e')));
      }
    }
  }

  void _applyNeedsFromParams(Map<String, dynamic> params) {
    setState(() {
      _hunger = (params['hunger'] as num?)?.toDouble() ?? _hunger;
      _thirst = (params['thirst'] as num?)?.toDouble() ?? _thirst;
    });
  }

  Future<void> _buyFood(String itemName) async {
    try {
      final response = await _apiClient.post('/food/buy-food', {
        'itemName': itemName,
      });
      final data = jsonDecode(response.body);

      if (data['event'] == 'food.purchased') {
        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
          final authProvider = Provider.of<AuthProvider>(
            context,
            listen: false,
          );
          final params = (data['params'] as Map?)?.cast<String, dynamic>() ?? {};

          authProvider.updatePlayerStats(
            money: params['newMoney'] as int?,
          );
          _applyNeedsFromParams(params);

          showTopRightFromSnackBar(
            context,
            SnackBar(
              content: Text(l10n.purchased),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else if (data['event']?.startsWith('error.') == true) {
        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
          final event = data['event'] as String? ?? '';
          final errorMessage = event == 'error.insufficientFunds'
              ? l10n.notEnoughMoney
              : event == 'error.invalidItem'
              ? l10n.invalidItem
              : l10n.unknownError;

          showTopRightFromSnackBar(
            context,
            SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(l10n.unknownError),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _buyDrink(String itemName) async {
    try {
      final response = await _apiClient.post('/food/buy-drink', {
        'itemName': itemName,
      });
      final data = jsonDecode(response.body);

      if (data['event'] == 'drink.purchased') {
        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
          final authProvider = Provider.of<AuthProvider>(
            context,
            listen: false,
          );
          final params = (data['params'] as Map?)?.cast<String, dynamic>() ?? {};

          authProvider.updatePlayerStats(
            money: params['newMoney'] as int?,
          );
          _applyNeedsFromParams(params);

          showTopRightFromSnackBar(
            context,
            SnackBar(
              content: Text(l10n.purchased),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else if (data['event']?.startsWith('error.') == true) {
        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
          final event = data['event'] as String? ?? '';
          final errorMessage = event == 'error.insufficientFunds'
              ? l10n.notEnoughMoney
              : event == 'error.invalidItem'
              ? l10n.invalidItem
              : l10n.unknownError;

          showTopRightFromSnackBar(
            context,
            SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(l10n.unknownError),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _localizedFoodName(String name, AppLocalizations l10n) {
    switch (name) {
      case 'Broodje':
        return l10n.foodBroodje;
      case 'Pizza':
        return l10n.foodPizza;
      case 'Burger':
        return l10n.foodBurger;
      case 'Steak':
        return l10n.foodSteak;
      default:
        return name;
    }
  }

  String _localizedDrinkName(String name, AppLocalizations l10n) {
    switch (name) {
      case 'Water':
        return l10n.drinkWater;
      case 'Frisdrank':
        return l10n.drinkSoda;
      case 'Koffie':
        return l10n.drinkCoffee;
      case 'Bier':
        return l10n.drinkBeer;
      default:
        return name;
    }
  }

  Widget _buildNeedsBar({
    required String label,
    required double? value,
    required Color color,
  }) {
    final amount = (value ?? 100).clamp(0, 100);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700))),
            Text('${amount.round()} / 100'),
          ],
        ),
        const SizedBox(height: 6),
        LinearProgressIndicator(
          value: amount / 100,
          minHeight: 10,
          borderRadius: BorderRadius.circular(999),
          color: color,
          backgroundColor: Colors.white12,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.foodAndDrink)),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildNeedsBar(
                            label: l10n.foodHunger,
                            value: _hunger,
                            color: Colors.orange,
                          ),
                          const SizedBox(height: 14),
                          _buildNeedsBar(
                            label: l10n.foodThirst,
                            value: _thirst,
                            color: Colors.lightBlue,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            l10n.foodNeedsHint,
                            style: const TextStyle(color: Colors.white70, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    l10n.food,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.orange[700],
                    ),
                  ),
                  const SizedBox(height: 12),
                  ..._foodItems.map((item) => _buildFoodCard(item)),
                  const SizedBox(height: 24),
                  Text(
                    l10n.drink,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[700],
                    ),
                  ),
                  const SizedBox(height: 12),
                  ..._drinkItems.map((item) => _buildDrinkCard(item)),
                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }

  Widget _buildFoodCard(dynamic item) {
    final l10n = AppLocalizations.of(context)!;
    final name = item['name'] ?? '';
    final cost = item['cost'] ?? 0;
    final effect = (item['effectValue'] as num?)?.toInt() ?? 0;
    final displayName = _localizedFoodName(name, l10n);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.orange[100],
          child: const Icon(Icons.lunch_dining, color: Colors.orange),
        ),
        title: Text(
          displayName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(l10n.foodRestoresHunger(effect)),
        trailing: ElevatedButton(
          onPressed: () => _buyFood(name),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange[700],
            foregroundColor: Colors.white,
          ),
          child: Text('€$cost'),
        ),
      ),
    );
  }

  Widget _buildDrinkCard(dynamic item) {
    final l10n = AppLocalizations.of(context)!;
    final name = item['name'] ?? '';
    final cost = item['cost'] ?? 0;
    final effect = (item['effectValue'] as num?)?.toInt() ?? 0;
    final displayName = _localizedDrinkName(name, l10n);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: const Icon(Icons.local_drink, color: Colors.blue),
        ),
        title: Text(
          displayName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(l10n.foodRestoresThirst(effect)),
        trailing: ElevatedButton(
          onPressed: () => _buyDrink(name),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[700],
            foregroundColor: Colors.white,
          ),
          child: Text('€$cost'),
        ),
      ),
    );
  }
}
