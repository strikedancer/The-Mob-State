import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../services/auth_service.dart';
import '../services/event_stream_service.dart';

/// World event model
class WorldEvent {
  final String eventKey;
  final Map<String, dynamic> params;
  final DateTime timestamp;

  WorldEvent({
    required this.eventKey,
    required this.params,
    required this.timestamp,
  });

  factory WorldEvent.fromJson(Map<String, dynamic> json) {
    final rawParams = json['params'];
    Map<String, dynamic> params = {};
    if (rawParams is Map<String, dynamic>) {
      params = rawParams;
    } else if (rawParams is String && rawParams.isNotEmpty) {
      try {
        final decoded = jsonDecode(rawParams);
        if (decoded is Map<String, dynamic>) params = decoded;
      } catch (_) {}
    }
    final createdAt = json['createdAt'] as String?;
    return WorldEvent(
      eventKey: json['event'] as String? ?? json['eventKey'] as String? ?? 'unknown',
      params: params,
      timestamp: createdAt != null ? DateTime.tryParse(createdAt) ?? DateTime.now() : DateTime.now(),
    );
  }
}

/// Provider for real-time event stream
class EventProvider with ChangeNotifier {
  final EventStreamService _eventStreamService = EventStreamService();
  final List<WorldEvent> _events = [];
  StreamSubscription? _subscription;
  bool _isConnected = false;
  String? _error;

  /// Get list of recent events (newest first)
  List<WorldEvent> get events => List.unmodifiable(_events);

  /// Get event stream service
  EventStreamService get eventStreamService => _eventStreamService;

  /// Check if connected to SSE stream
  bool get isConnected => _isConnected;

  /// Get error message if any
  String? get error => _error;

  Future<void> hydrateFromApi() async {
    try {
      final response = await AuthService().apiClient.get('/events?limit=50');
      if (response.statusCode != 200) return;
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final rows = (data['events'] as List?) ?? const [];
      final hydrated = rows
          .whereType<Map>()
          .map((row) => WorldEvent.fromJson(Map<String, dynamic>.from(row)))
          .where((event) => event.eventKey != 'player.activity')
          .toList();
      if (hydrated.isEmpty) return;
      _events
        ..clear()
        ..addAll(hydrated);
      notifyListeners();
    } catch (e) {
      print('[EventProvider] Hydrate failed: $e');
    }
  }

  /// Start listening to events
  void connect() {
    if (_subscription != null) {
      print('[EventProvider] Already subscribed');
      return;
    }

    print('[EventProvider] Starting event stream subscription...');
    unawaited(hydrateFromApi());

    _subscription = _eventStreamService.eventStream.listen(
      _onEvent,
      onError: _onError,
      onDone: _onDone,
      cancelOnError: false,
    );

    _isConnected = true;
    _error = null;
    notifyListeners();
  }

  /// Handle incoming event
  void _onEvent(Map<String, dynamic> eventData) {
    try {
      final event = WorldEvent.fromJson(eventData);
      final eventKey = event.eventKey;
      
      // Skip connection events (they're not real game events)
      if (eventKey == 'connection.established') {
        print('[EventProvider] Skipping connection event');
        return;
      }
      
      print('[EventProvider] Event: $eventKey');

      // Add to beginning (newest first)
      _events.insert(0, event);

      // Keep only last 100 events
      if (_events.length > 100) {
        _events.removeRange(100, _events.length);
      }

      _isConnected = true;
      _error = null;
      notifyListeners();
    } catch (e) {
      print('[EventProvider] Error processing event: $e');
    }
  }

  /// Handle stream errors
  void _onError(dynamic error) {
    print('[EventProvider] Stream error: $error');
    _isConnected = false;
    _error = error.toString();
    notifyListeners();
  }

  /// Handle stream closure
  void _onDone() {
    print('[EventProvider] Stream closed');
    _isConnected = false;
    notifyListeners();
  }

  /// Disconnect from event stream
  void disconnect() {
    print('[EventProvider] Disconnecting...');
    _subscription?.cancel();
    _subscription = null;
    _isConnected = false;
    notifyListeners();
  }

  /// Clear all events
  void clearEvents() {
    _events.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    disconnect();
    _eventStreamService.dispose();
    super.dispose();
  }
}
