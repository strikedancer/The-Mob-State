import 'dart:convert';

import 'api_client.dart';

class StockMarketService {
  final ApiClient _api = ApiClient();

  Future<Map<String, dynamic>> getMarket() async {
    final response = await _api.get('/stock/market');
    final data = json.decode(response.body) as Map<String, dynamic>;
    if (response.statusCode == 200) {
      return {
        'success': true,
        ...(data['params'] as Map<String, dynamic>? ?? {}),
      };
    }
    return {'success': false, 'event': data['event']};
  }

  Future<Map<String, dynamic>> trade({
    required String symbol,
    required String side,
    required int quantity,
  }) async {
    final response = await _api.post('/stock/trade', {
      'symbol': symbol,
      'side': side,
      'quantity': quantity,
    });
    final data = json.decode(response.body) as Map<String, dynamic>;
    if (response.statusCode == 200) {
      return {
        'success': true,
        ...(data['params'] as Map<String, dynamic>? ?? {}),
      };
    }
    return {'success': false, 'event': data['event']};
  }
}
