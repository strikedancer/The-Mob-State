#!/usr/bin/env node
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const dartPath = path.join(__dirname, '..', 'client', 'lib', 'screens', 'crew_screen.dart');
let s = fs.readFileSync(dartPath, 'utf8');

if (!s.includes("import '../l10n/app_localizations.dart';")) {
  s = s.replace(
    "import '../utils/web_asset_helper.dart';",
    "import '../utils/web_asset_helper.dart';\nimport '../l10n/app_localizations.dart';",
  );
}

const i18nStart = s.indexOf('  static const Map<String, Map<String, String>> _crewI18n = {');
const buildingLine = '\n  static const Map<String, List<int>> _buildingCapacityByLevel';
const i18nEnd = s.indexOf(buildingLine, i18nStart);
if (i18nStart < 0 || i18nEnd < 0) throw new Error('Could not find _crewI18n block');

const switchBody = fs.readFileSync(path.join(__dirname, '_crew_ui_switch_fragment.txt'), 'utf8');
const insertLookup =
  switchBody
    .trim()
    .split('\n')
    .map((line) => (line.length ? '  ' + line : line))
    .join('\n') + '\n\n';

s = s.slice(0, i18nStart) + insertLookup + s.slice(i18nEnd);

s = s.replace(
  /String _t\(String locale, String key\) \{\s*final lang = locale == 'nl' \? 'nl' : 'en';\s*return _crewI18n\[key\]\?\[lang\] \?\? key;\s*\}/,
  'String _t(AppLocalizations l10n, String key) => _crewMapLookup(l10n, key);',
);

s = s.replace(
  /String _tParam\(String locale, String key, Map<String, String> params\) \{\s*var text = _t\(locale, key\);/,
  'String _tParam(AppLocalizations l10n, String key, Map<String, String> params) {\n    var text = _crewMapLookup(l10n, key, params);',
);

s = s.replace(
  /String _tr\(String locale, String nl, String en\) => locale == 'nl' \? nl : en;\s*/,
  '',
);

s = s.replace(/String _buildingActionErrorMessage\(String locale, /g, 'String _buildingActionErrorMessage(AppLocalizations l10n, ');
s = s.replace(/String _crewMissionErrorMessage\(String locale, /g, 'String _crewMissionErrorMessage(AppLocalizations l10n, ');

s = s.replace(/_buildingActionErrorMessage\(locale,/g, '_buildingActionErrorMessage(l10n,');
s = s.replace(/_crewMissionErrorMessage\(locale,/g, '_crewMissionErrorMessage(l10n,');

s = s.replace(/_t\(locale,/g, '_t(l10n,');

fs.writeFileSync(dartPath, s, 'utf8');
console.log('crew_dart_patch applied');
