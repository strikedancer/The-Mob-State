// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:html' as html;
import 'dart:js' as js;

bool showBrowserNotification(
  String title,
  String body,
  Map<String, dynamic> data,
) {
  if (!html.Notification.supported) {
    return false;
  }

  if (html.Notification.permission != 'granted') {
    return false;
  }

  final notificationConstructor = js.context['Notification'];
  if (notificationConstructor == null) {
    return false;
  }

  final options = js.JsObject.jsify({
    'body': body,
    'tag': data['id']?.toString() ?? data['type']?.toString() ?? 'notification',
    'icon': '/icons/Icon-192.png',
  });

  js.JsObject(notificationConstructor, [title, options]);

  return true;
}