import 'dart:async';
import 'package:flutter/foundation.dart';
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
    return WorldEvent(
      eventKey: json['event'] as String? ?? 'unknown',
      params: json['params'] as Map<String, dynamic>? ?? {},
      timestamp: DateTime.now(),
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

  /// Start listening to events
  void connect() {
    if (_subscription != null) {
      print('[EventProvider] Already subscribed');
      return;
    }

    print('[EventProvider] Starting event stream subscription...');

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
