import 'package:flutter/widgets.dart';

/// Picks `message{Locale}` from API [params] (e.g. messageDe), then fallbacks.
String? localizedApiMessage(BuildContext context, Map<String, dynamic> params) {
  final code = Localizations.localeOf(context).languageCode.toLowerCase();
  final suffix = code.isEmpty
      ? 'En'
      : '${code[0].toUpperCase()}${code.length > 1 ? code.substring(1) : ''}';

  String? pick(String key) {
    final raw = params[key]?.toString().trim();
    return (raw == null || raw.isEmpty) ? null : raw;
  }

  return pick('message$suffix') ??
      pick('messageEn') ??
      pick('messageNl') ??
      pick('messageDe') ??
      pick('messageEs') ??
      pick('messageFr') ??
      pick('messageIt') ??
      pick('messagePl') ??
      pick('messagePt');
}
