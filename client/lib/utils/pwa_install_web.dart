// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:async';
import 'dart:html' as html;
import 'dart:js' as js;

js.JsObject? _bridge() {
  final value = js.context['__mobstatePwa'];
  if (value is js.JsObject) return value;
  return null;
}

bool pwaIsStandalone() {
  try {
    if (html.window.matchMedia('(display-mode: standalone)').matches) {
      return true;
    }
  } catch (_) {}
  final nav = js.context['navigator'];
  if (nav is js.JsObject) {
    return nav['standalone'] == true;
  }
  return false;
}

bool pwaIsIosSafari() {
  final bridge = _bridge();
  if (bridge != null) {
    return bridge.callMethod('isIos') == true;
  }
  final ua = html.window.navigator.userAgent.toLowerCase();
  return ua.contains('iphone') || ua.contains('ipad') || ua.contains('ipod');
}

bool pwaCanNativePrompt() {
  final bridge = _bridge();
  if (bridge == null) return false;
  return bridge.callMethod('canPrompt') == true;
}

void pwaListenForNativePrompt(void Function() onReady) {
  final bridge = _bridge();
  if (bridge == null) return;
  bridge.callMethod('onReady', [onReady]);
}

Future<String> pwaPromptNativeInstall() {
  final bridge = _bridge();
  if (bridge == null) return Future.value('unavailable');
  final completer = Completer<String>();
  bridge.callMethod('promptInstall', [
    (Object? outcome) {
      if (!completer.isCompleted) {
        completer.complete(outcome?.toString() ?? 'dismissed');
      }
    },
  ]);
  return completer.future;
}
