import 'dart:convert';

import './api_client.dart';

class CryptoService {
  final ApiClient _apiClient = ApiClient();

  Future<Map<String, dynamic>> getMarket() async {
    try {
      final response = await _apiClient.get('/crypto/market');
      return json.decode(response.body) as Map<String, dynamic>;
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  Future<Map<String, dynamic>> getPortfolio() async {
    try {
      final response = await _apiClient.get('/crypto/portfolio');
      return json.decode(response.body) as Map<String, dynamic>;
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  Future<Map<String, dynamic>> getOrders() async {
    try {
      final response = await _apiClient.get('/crypto/orders');
      return json.decode(response.body) as Map<String, dynamic>;
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  Future<Map<String, dynamic>> placeOrder({
    required String symbol,
    required String orderType,
    required String side,
    required double quantity,
    required double targetPrice,
  }) async {
    try {
      final response = await _apiClient.post('/crypto/orders', {
        'symbol': symbol,
        'orderType': orderType,
        'side': side,
        'quantity': quantity,
        'targetPrice': targetPrice,
      });
      return json.decode(response.body) as Map<String, dynamic>;
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  Future<Map<String, dynamic>> cancelOrder({required int orderId}) async {
    try {
      final response = await _apiClient.post(
        '/crypto/orders/$orderId/cancel',
        {},
      );
      return json.decode(response.body) as Map<String, dynamic>;
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  Future<Map<String, dynamic>> getHistory({
    required String symbol,
    int points = 180,
    int hours = 24,
  }) async {
    try {
      final safeSymbol = Uri.encodeQueryComponent(symbol.trim().toUpperCase());
      final safePoints = points < 20 ? 20 : points;
      final safeHours = hours <= 0 ? 0 : hours;
      final response = await _apiClient.get(
        '/crypto/history?symbol=$safeSymbol&points=$safePoints&hours=$safeHours',
      );
      return json.decode(response.body) as Map<String, dynamic>;
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  Future<Map<String, dynamic>> getTransactions({
    required String symbol,
    int limit = 15,
  }) async {
    try {
      final safeSymbol = Uri.encodeQueryComponent(symbol.trim().toUpperCase());
      final safeLimit = limit < 5 ? 5 : limit;
      final response = await _apiClient.get(
        '/crypto/transactions?symbol=$safeSymbol&limit=$safeLimit',
      );
      return json.decode(response.body) as Map<String, dynamic>;
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  Future<Map<String, dynamic>> buy({
    required String symbol,
    required double quantity,
  }) async {
    try {
      final response = await _apiClient.post('/crypto/buy', {
        'symbol': symbol,
        'quantity': quantity,
      });
      return json.decode(response.body) as Map<String, dynamic>;
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  Future<Map<String, dynamic>> sell({
    required String symbol,
    required double quantity,
  }) async {
    try {
      final response = await _apiClient.post('/crypto/sell', {
        'symbol': symbol,
        'quantity': quantity,
      });
      return json.decode(response.body) as Map<String, dynamic>;
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }
}
