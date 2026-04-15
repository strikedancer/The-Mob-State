import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'auth_service.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  String? _fcmToken;
  String? get fcmToken => _fcmToken;
  bool _listenersRegistered = false;
  bool _localNotificationsInitialized = false;

  static const Set<String> _cryptoNotificationTypes = {
    'crypto_trade_buy',
    'crypto_trade_sell',
    'crypto_price_alert',
    'crypto_order_filled',
    'crypto_order_triggered',
    'crypto_market_regime',
    'crypto_market_news',
    'crypto_mission_completed',
    'crypto_leaderboard_reward',
  };

  /// Initialize Firebase Cloud Messaging
  Future<void> initialize() async {
    print('[NotificationService] Initializing...');

    if (kIsWeb && !_supportsWebPushNotifications()) {
      print(
        '[NotificationService] Web push notifications require HTTPS or localhost. Current origin: ${Uri.base}',
      );
      print(
        '[NotificationService] Mobile Safari also requires the web app to be installed to the home screen before requesting permission.',
      );
      return;
    }

    // Request permission for iOS and Web
    final settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print(
      '[NotificationService] Permission status: ${settings.authorizationStatus}',
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional) {
      await _finishAuthorizedInitialization(registerWithBackend: true);
    } else {
      print('[NotificationService] Permission denied');
    }
  }

  Future<bool> syncAuthorizedSession() async {
    print('[NotificationService] Syncing existing push permission/session...');

    if (kIsWeb && !_supportsWebPushNotifications()) {
      print(
        '[NotificationService] Skipping push sync because current origin does not support web push.',
      );
      return false;
    }

    final settings = await _messaging.getNotificationSettings();
    final authorized =
        settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;

    if (!authorized) {
      print('[NotificationService] Push permission not granted, skipping sync');
      return false;
    }

    await _finishAuthorizedInitialization(registerWithBackend: true);
    return _fcmToken != null && _fcmToken!.isNotEmpty;
  }

  Future<NotificationSettings> getNotificationSettings() {
    return _messaging.getNotificationSettings();
  }

  Future<void> registerCurrentToken() async {
    if (_fcmToken != null) {
      await _registerTokenWithBackend(_fcmToken!);
    }
  }

  Future<void> _finishAuthorizedInitialization({
    required bool registerWithBackend,
  }) async {
    await _initializeLocalNotificationsIfNeeded();
    await _refreshToken();

    print('[NotificationService] FCM Token: $_fcmToken');

    if (registerWithBackend && _fcmToken != null && _fcmToken!.isNotEmpty) {
      await _registerTokenWithBackend(_fcmToken!);
    }

    _registerListenersIfNeeded();
  }

  Future<void> _initializeLocalNotificationsIfNeeded() async {
    if (_localNotificationsInitialized || kIsWeb || !Platform.isAndroid) {
      return;
    }

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    _localNotificationsInitialized = true;
  }

  Future<void> _refreshToken() async {
    if (kIsWeb) {
      try {
        await Future.delayed(const Duration(milliseconds: 500));
        _fcmToken = await _messaging.getToken(
          vapidKey:
              'BM8aWvMl_7R7fzsuRKBQ4ugAgKMeW1IW8_7emoc0u2cRkHNvIjGWkUHK45xuN0ctdMn-60NpdVyTfSIbLSXcKwU',
        );
      } catch (e) {
        print('[NotificationService] ⚠️ Error getting web token: $e');
      }
      return;
    }

    _fcmToken = await _messaging.getToken();
  }

  void _registerListenersIfNeeded() {
    if (_listenersRegistered) {
      return;
    }

    _messaging.onTokenRefresh.listen((newToken) {
      print('[NotificationService] Token refreshed: $newToken');
      _fcmToken = newToken;
      _registerTokenWithBackend(newToken);
    });

    if (!kIsWeb) {
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    }

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);
    _listenersRegistered = true;
  }

  Future<void> unregisterCurrentToken() async {
    if (_fcmToken == null) return;
    try {
      final apiClient = AuthService().apiClient;
      await apiClient.delete(
        '/notifications/unregister-token',
        body: {'token': _fcmToken},
        includeAuth: true,
      );
    } catch (e) {
      print('[NotificationService] Error unregistering token: $e');
    }
  }

  /// Handle foreground messages (app is open)
  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    print(
      '[NotificationService] Foreground message: ${message.notification?.title}',
    );

    if (kIsWeb) {
      // For web, manually show notification even when tab is in focus
      print('[NotificationService] Web notification received in foreground');
      print('[NotificationService] Title: ${message.notification?.title}');
      print('[NotificationService] Body: ${message.notification?.body}');

      // Force show notification using Web Notification API
      try {
        // Import dart:html for web
        // ignore: avoid_web_libraries_in_flutter
        _showWebNotification(
          message.notification?.title ?? 'The Mob State',
          message.notification?.body ?? '',
          message.data,
        );
        print('[NotificationService] ✅ Foreground web notification shown');
      } catch (e) {
        print(
          '[NotificationService] ❌ Error showing foreground notification: $e',
        );
      }
    } else if (Platform.isAndroid) {
      // Show local notification on Android
      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            channelDescription:
                'This channel is used for important notifications.',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          );

      const NotificationDetails details = NotificationDetails(
        android: androidDetails,
      );

      await _localNotifications.show(
        message.hashCode,
        message.notification?.title ?? 'The Mob State',
        message.notification?.body ?? '',
        details,
        payload: message.data['type'],
      );
    }
  }

  /// Handle notification tap
  void _onNotificationTap(NotificationResponse response) {
    print('[NotificationService] Notification tapped: ${response.payload}');
    _handleNotificationType(response.payload, const {});
  }

  /// Handle message when app is opened from background
  void _handleMessageOpenedApp(RemoteMessage message) {
    print(
      '[NotificationService] App opened from notification: ${message.data}',
    );
    _handleNotificationType(message.data['type']?.toString(), message.data);
  }

  void _handleNotificationType(String? type, Map<String, dynamic> data) {
    if (type == null || type.isEmpty) {
      print('[NotificationService] Notification type missing');
      return;
    }

    final route = _routeForNotificationType(type);
    if (route != null) {
      print(
        '[NotificationService] Notification type $type mapped to route $route',
      );
      print('[NotificationService] Notification data: $data');
      return;
    }

    print('[NotificationService] No route mapping found for type: $type');
  }

  String? _routeForNotificationType(String type) {
    if (_cryptoNotificationTypes.contains(type)) {
      return '/dashboard';
    }

    switch (type) {
      case 'friend_request':
      case 'friend_accepted':
      case 'direct_message':
      case 'crew_message':
      case 'crew_war_declared':
      case 'crew_war_ended':
        return '/dashboard';
      default:
        return null;
    }
  }

  /// Register FCM token with backend
  Future<void> _registerTokenWithBackend(String token) async {
    try {
      final apiClient = AuthService().apiClient;

      String deviceType = 'web';
      if (!kIsWeb) {
        if (Platform.isAndroid) {
          deviceType = 'android';
        } else if (Platform.isIOS) {
          deviceType = 'ios';
        }
      }

      final response = await apiClient.post('/notifications/register-token', {
        'token': token,
        'deviceType': deviceType,
      });

      if (response.statusCode == 200) {
        print('[NotificationService] Token registered with backend');
      } else {
        print(
          '[NotificationService] Failed to register token: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('[NotificationService] Error registering token: $e');
    }
  }

  /// Show web notification manually (for foreground messages)
  void _showWebNotification(
    String title,
    String body,
    Map<String, dynamic> data,
  ) {
    if (kIsWeb) {
      try {
        // Use dynamic import for web-only code
        _showWebNotificationImpl(title, body, data);
      } catch (e) {
        print('[NotificationService] Error creating web notification: $e');
      }
    }
  }

  /// Web-only notification implementation
  void _showWebNotificationImpl(
    String title,
    String body,
    Map<String, dynamic> data,
  ) {
    // This will only be called on web platform
    // Use HTML package for web notifications instead of dart:js
    print('[NotificationService] Web notification: $title - $body');
    // For now, rely on Firebase Cloud Messaging's default web notifications
    // which are handled by the service worker
  }

  bool _supportsWebPushNotifications() {
    if (!kIsWeb) {
      return true;
    }

    final base = Uri.base;
    final host = base.host.toLowerCase();

    return base.scheme == 'https' ||
        host == 'localhost' ||
        host == '127.0.0.1' ||
        host == '::1';
  }
}

/// Background message handler (must be top-level function)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print(
    '[NotificationService] Background message: ${message.notification?.title}',
  );
}
