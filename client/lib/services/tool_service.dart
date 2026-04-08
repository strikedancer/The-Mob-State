import 'dart:convert';
import 'api_client.dart';
import '../models/crime_tool.dart';
import '../models/player_tool.dart';

class ToolService {
  final ApiClient _apiClient;

  ToolService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  /// Get all available tool definitions
  Future<List<CrimeTool>> getAllTools() async {
    try {
      final response = await _apiClient.get('/tools');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final toolsList = data['tools'] as List;
        return toolsList.map((json) => CrimeTool.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load tools');
      }
    } catch (e) {
      print('[ToolService] Error loading tools: $e');
      rethrow;
    }
  }

  /// Get player's tool inventory
  Future<List<PlayerTool>> getInventory() async {
    try {
      final response = await _apiClient.get('/tools/inventory');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final toolsList = data['tools'] as List;
        return toolsList.map((json) => PlayerTool.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load tool inventory');
      }
    } catch (e) {
      print('[ToolService] Error loading inventory: $e');
      rethrow;
    }
  }

  /// Buy a tool from the black market
  Future<ToolPurchaseResult> buyTool(String toolId) async {
    try {
      final response = await _apiClient.post('/tools/buy/$toolId', {});

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final toolData = data['tool'];
        final tool = PlayerTool.fromJson(toolData);
        return ToolPurchaseResult(
          success: true,
          tool: tool,
        );
      } else {
        String errorMessage = 'Could not buy tool';
        if (data['params'] != null && data['params']['message'] != null) {
          errorMessage = data['params']['message'];
        }

        return ToolPurchaseResult(
          success: false,
          error: errorMessage,
        );
      }
    } catch (e) {
      print('[ToolService] Error buying tool: $e');
      return ToolPurchaseResult(
        success: false,
        error: 'Network error: $e',
      );
    }
  }

  /// Repair a tool to maximum durability
  Future<ToolRepairResult> repairTool(String toolId) async {
    try {
      final response = await _apiClient.post('/tools/repair/$toolId', {});

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final cost = data['params']['cost'] as int;
        return ToolRepairResult(
          success: true,
          cost: cost,
        );
      } else {
        String errorMessage = 'Could not repair tool';
        if (data['params'] != null && data['params']['message'] != null) {
          errorMessage = data['params']['message'];
        }

        return ToolRepairResult(
          success: false,
          error: errorMessage,
        );
      }
    } catch (e) {
      print('[ToolService] Error repairing tool: $e');
      return ToolRepairResult(
        success: false,
        error: 'Network error: $e',
      );
    }
  }
}

class ToolPurchaseResult {
  final bool success;
  final PlayerTool? tool;
  final String? error;

  ToolPurchaseResult({
    required this.success,
    this.tool,
    this.error,
  });
}

class ToolRepairResult {
  final bool success;
  final int? cost;
  final String? error;

  ToolRepairResult({
    required this.success,
    this.cost,
    this.error,
  });
}
