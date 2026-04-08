import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';

/// Service to connect to SSE endpoint and stream real-time events
class EventStreamService {
  final String _url = '${AppConfig.apiBaseUrl}/events/stream';
  StreamController<Map<String, dynamic>>? _controller;
  http.Client? _client;
  http.StreamedResponse? _response;
  bool _isConnected = false;
  int _reconnectAttempts = 0;
  static const int _maxReconnectAttempts = 10;
  static const Duration _initialReconnectDelay = Duration(seconds: 1);

  /// Get event stream
  Stream<Map<String, dynamic>> get eventStream {
    if (_controller == null || _controller!.isClosed) {
      _controller = StreamController<Map<String, dynamic>>.broadcast(
        onListen: _connect,
        onCancel: _disconnect,
      );
    }
    return _controller!.stream;
  }

  /// Check if currently connected
  bool get isConnected => _isConnected;

  /// Connect to SSE endpoint
  Future<void> _connect() async {
    if (_isConnected) {
      print('[EventStream] Already connected');
      return;
    }

    try {
      print('[EventStream] Connecting to $_url...');
      _client = http.Client();

      final request = http.Request('GET', Uri.parse(_url));
      request.headers['Accept'] = 'text/event-stream';
      request.headers['Cache-Control'] = 'no-cache';

      _response = await _client!.send(request);

      if (_response!.statusCode == 200) {
        _isConnected = true;
        _reconnectAttempts = 0;
        print('[EventStream] Connected! Status: ${_response!.statusCode}');

        // Listen to stream
        _response!.stream
            .transform(utf8.decoder)
            .transform(const LineSplitter())
            .listen(
          _handleData,
          onError: _handleError,
          onDone: _handleDone,
          cancelOnError: false,
        );
      } else {
        print('[EventStream] Connection failed: ${_response!.statusCode}');
        _scheduleReconnect();
      }
    } catch (error) {
      print('[EventStream] Connection error: $error');
      _scheduleReconnect();
    }
  }

  /// Handle incoming SSE data
  void _handleData(String line) {
    if (line.isEmpty) return;

    // SSE format: "data: {json}\n\n"
    if (line.startsWith('data: ')) {
      final jsonString = line.substring(6); // Remove "data: " prefix
      try {
        final eventData = jsonDecode(jsonString) as Map<String, dynamic>;
        print('[EventStream] Event received: ${eventData['event']}');
        _controller?.add(eventData);
      } catch (error) {
        print('[EventStream] Failed to parse event: $error');
      }
    }
  }

  /// Handle stream errors
  void _handleError(dynamic error) {
    print('[EventStream] Stream error: $error');
    _isConnected = false;
    _scheduleReconnect();
  }

  /// Handle stream closure
  void _handleDone() {
    print('[EventStream] Stream closed');
    _isConnected = false;
    _scheduleReconnect();
  }

  /// Schedule reconnection with exponential backoff
  void _scheduleReconnect() {
    if (_reconnectAttempts >= _maxReconnectAttempts) {
      print('[EventStream] Max reconnect attempts reached, giving up');
      _controller?.addError('Max reconnection attempts exceeded');
      return;
    }

    _reconnectAttempts++;
    final delay = _initialReconnectDelay * (1 << (_reconnectAttempts - 1));
    final cappedDelay = delay > Duration(seconds: 30) 
        ? Duration(seconds: 30) 
        : delay;

    print('[EventStream] Reconnecting in ${cappedDelay.inSeconds}s (attempt $_reconnectAttempts/$_maxReconnectAttempts)');

    Future.delayed(cappedDelay, () {
      if (_controller != null && !_controller!.isClosed) {
        _connect();
      }
    });
  }

  /// Disconnect from SSE endpoint
  void _disconnect() {
    print('[EventStream] Disconnecting...');
    _isConnected = false;
    _response = null;
    _client?.close();
    _client = null;
  }

  /// Dispose resources
  void dispose() {
    _disconnect();
    _controller?.close();
    _controller = null;
  }
}
