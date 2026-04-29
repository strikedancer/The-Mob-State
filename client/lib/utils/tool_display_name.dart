import '../l10n/app_localizations.dart';

/// Localized tool name (overrides API / `tools.json` display strings).
String localizedToolName(
  AppLocalizations l10n,
  String toolId,
  String? apiName,
) {
  switch (toolId) {
    case 'bolt_cutter':
      return l10n.toolBoltCutter;
    case 'burglary_kit':
      return l10n.toolBurglaryKit;
    case 'car_theft_tools':
      return l10n.toolCarTheftTools;
    case 'jerry_can':
      return l10n.toolJerryCan;
    case 'spray_paint':
      return l10n.toolSprayPaint;
    case 'crowbar':
      return l10n.toolCrowbar;
    case 'glass_cutter':
      return l10n.toolGlassCutter;
    case 'hacking_laptop':
      return l10n.toolHackingLaptop;
    case 'counterfeiting_kit':
      return l10n.toolCounterfeitingKit;
    case 'toolbox':
      return l10n.toolToolbox;
    case 'rope':
      return l10n.toolRope;
    case 'silencer':
      return l10n.toolSilencer;
    case 'fake_documents':
      return l10n.toolFakeDocuments;
    case 'night_vision':
      return l10n.toolNightVision;
    case 'burner_phone':
      return l10n.toolBurnerPhone;
    case 'gps_jammer':
      return l10n.toolGpsJammer;
    case 'thermal_drill':
      return l10n.toolThermalDrill;
    default:
      final n = apiName?.trim();
      return n != null && n.isNotEmpty ? n : toolId;
  }
}

/// Localized tool category line (from `tools.json` `type` field, e.g. BOLT_CUTTER).
String localizedToolCategory(AppLocalizations l10n, String? rawType) {
  final t = (rawType ?? '').toUpperCase().trim();
  switch (t) {
    case 'BOLT_CUTTER':
      return l10n.toolCategoryBoltCutter;
    case 'BURGLARY_KIT':
      return l10n.toolCategoryBurglaryKit;
    case 'CAR_TOOLS':
      return l10n.toolCategoryCarTools;
    case 'JERRY_CAN':
      return l10n.toolCategoryJerryCan;
    case 'SPRAY_PAINT':
      return l10n.toolCategorySprayPaint;
    case 'CROWBAR':
      return l10n.toolCategoryCrowbar;
    case 'GLASS_CUTTER':
      return l10n.toolCategoryGlassCutter;
    case 'LAPTOP':
    case 'HACKING_LAPTOP':
      return l10n.toolCategoryLaptop;
    case 'COUNTERFEITING':
      return l10n.toolCategoryCounterfeiting;
    case 'TOOLBOX':
      return l10n.toolCategoryToolbox;
    case 'ROPE':
      return l10n.toolCategoryRope;
    case 'SILENCER':
      return l10n.toolCategorySilencer;
    case 'FAKE_DOCS':
      return l10n.toolCategoryFakeDocs;
    case 'NIGHT_VISION':
      return l10n.toolCategoryNightVision;
    case 'BURNER_PHONE':
      return l10n.toolCategoryBurnerPhone;
    case 'GPS_JAMMER':
      return l10n.toolCategoryGpsJammer;
    case 'THERMAL_DRILL':
      return l10n.toolCategoryThermalDrill;
    default:
      if (t.isEmpty) return '';
      return t
          .replaceAll('_', ' ')
          .toLowerCase()
          .split(' ')
          .map((p) {
            if (p.isEmpty) return p;
            return '${p[0].toUpperCase()}${p.substring(1)}';
          })
          .join(' ');
  }
}
