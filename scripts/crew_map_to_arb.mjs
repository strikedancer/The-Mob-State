#!/usr/bin/env node
/**
 * Extract _crewI18n from crew_screen.dart → app_en.arb keys crewUi* + list of keys for Dart switch.
 * Run from repo root: node scripts/crew_map_to_arb.mjs
 */
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const root = path.join(__dirname, '..');
const dartPath = path.join(root, 'client', 'lib', 'screens', 'crew_screen.dart');
let text = fs.readFileSync(dartPath, 'utf8');
text = text.replace(/\r\n/g, '\n');

const startMarker = '  static const Map<String, Map<String, String>> _crewI18n = {';
const endMarker = '\n  };\n\n  static const Map<String, List<int>> _buildingCapacityByLevel';
const i0 = text.indexOf(startMarker);
const i1 = text.indexOf(endMarker, i0);
if (i0 < 0 || i1 < 0) throw new Error('Could not find _crewI18n block');
const block = text.slice(i0 + startMarker.length, i1);

function dotKeyToArbKey(dotKey) {
  const parts = dotKey.split('.').map((p) => p.charAt(0).toUpperCase() + p.slice(1));
  return 'crewUi' + parts.join('');
}

/** Parse 'nl' / 'en' string values after a position; handles multiline and escaped quotes poorly — good enough for this file */
function parseLangMap(from) {
  const out = { nl: '', en: '' };
  for (const lang of ['nl', 'en']) {
    const re = new RegExp(`'${lang}':\\s*`, 'm');
    const m = re.exec(from);
    if (!m) throw new Error('missing ' + lang);
    let pos = m.index + m[0].length;
    while (/\s/.test(from[pos])) pos++;
    if (from[pos] !== "'") throw new Error('expected quote for ' + lang);
    pos++;
    let s = '';
    while (pos < from.length) {
      const c = from[pos];
      if (c === '\\') {
        const n = from[pos + 1];
        if (n === 'n') {
          s += '\n';
          pos += 2;
          continue;
        }
        s += n;
        pos += 2;
        continue;
      }
      if (c === "'") {
        pos++;
        break;
      }
      s += c;
      pos++;
    }
    out[lang] = s;
  }
  return { values: out, endPos: 0 };
}

const entries = [];
let i = 0;
while (i < block.length) {
  const km = /'([^']+)':\s*\{/.exec(block.slice(i));
  if (!km) break;
  const dotKey = km[1];
  const subStart = i + km.index + km[0].length;
  const sub = block.slice(subStart);
  const { values } = parseLangMap(sub);
  entries.push({ dotKey, en: values.en, nl: values.nl });
  // advance: find closing `},` for this entry
  let depth = 1;
  let j = 0;
  for (; j < sub.length; j++) {
    if (sub[j] === '{') depth++;
    else if (sub[j] === '}') {
      depth--;
      if (depth === 0) {
        j++;
        while (j < sub.length && /[,\s]/.test(sub[j])) j++;
        break;
      }
    }
  }
  i = subStart + j;
}

function escapeArb(s) {
  return s.replace(/\\/g, '\\\\').replace(/"/g, '\\"').replace(/\n/g, '\\n');
}

const arbLines = [];
for (const { dotKey, en } of entries) {
  const ak = dotKeyToArbKey(dotKey);
  const hasCredits = en.includes('{credits}') && en.includes('{minutes}');
  if (hasCredits) {
    arbLines.push(`  "${ak}": "${escapeArb(en)}",`);
    arbLines.push(`  "@${ak}": {`);
    arbLines.push(`    "placeholders": {`);
    arbLines.push(`      "credits": {"type": "String"},`);
    arbLines.push(`      "minutes": {"type": "String"}`);
    arbLines.push(`    }`);
    arbLines.push(`  },`);
  } else {
    arbLines.push(`  "${ak}": "${escapeArb(en)}",`);
  }
}

const outPath = path.join(root, 'scripts', '_crew_ui_en_arb_fragment.txt');
fs.writeFileSync(outPath, arbLines.join('\n') + '\n', 'utf8');
console.log('Wrote', outPath, 'entries:', entries.length);

const switchLines = entries.map(({ dotKey }) => {
  const ak = dotKeyToArbKey(dotKey);
  const hasPh = dotKey === 'dialog.speedupBody';
  if (hasPh) {
    return `      case '${dotKey}': return l10n.${ak}(params!['credits']!, params!['minutes']!);`;
  }
  return `      case '${dotKey}': return l10n.${ak};`;
});
const switchPath = path.join(root, 'scripts', '_crew_ui_switch_fragment.txt');
fs.writeFileSync(
  switchPath,
  `String _crewMapLookup(AppLocalizations l10n, String key, [Map<String, String>? params]) {\n    switch (key) {\n${switchLines.join('\n')}\n      default: return key;\n    }\n  }\n`,
  'utf8',
);
console.log('Wrote', switchPath);
