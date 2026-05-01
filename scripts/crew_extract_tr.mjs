#!/usr/bin/env node
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const p = path.join(__dirname, '..', 'client', 'lib', 'screens', 'crew_screen.dart');
let s = fs.readFileSync(p, 'utf8');
const pairs = [];
let i = 0;
while (i < s.length) {
  const j = s.indexOf('_tr(', i);
  if (j < 0) break;
  let pos = j + '_tr('.length;
  while (pos < s.length && /\s/.test(s[pos])) pos++;
  if (s.slice(pos, pos + 7) !== 'locale,') {
    i = j + 1;
    continue;
  }
  pos += 'locale,'.length;
  while (pos < s.length && /\s/.test(s[pos])) pos++;
  if (s[pos] !== "'") {
    i = j + 1;
    continue;
  }
  pos++;
  let nl = '';
  while (pos < s.length) {
    const c = s[pos];
    if (c === '\\') {
      const n = s[pos + 1];
      if (n === 'n') {
        nl += '\n';
        pos += 2;
        continue;
      }
      nl += n;
      pos += 2;
      continue;
    }
    if (c === "'") {
      pos++;
      break;
    }
    nl += c;
    pos++;
  }
  while (pos < s.length && /[\s,]/.test(s[pos])) pos++;
  if (s[pos] !== "'") {
    i = j + 1;
    continue;
  }
  pos++;
  let en = '';
  while (pos < s.length) {
    const c = s[pos];
    if (c === '\\') {
      const n = s[pos + 1];
      if (n === 'n') {
        en += '\n';
        pos += 2;
        continue;
      }
      en += n;
      pos += 2;
      continue;
    }
    if (c === "'") {
      pos++;
      break;
    }
    en += c;
    pos++;
  }
  pairs.push({ nl, en, at: j });
  i = pos;
}

const uniq = new Map();
for (const { nl, en } of pairs) {
  const k = en + '\0' + nl;
  if (!uniq.has(k)) uniq.set(k, { nl, en, count: 0 });
  uniq.get(k).count++;
}
console.log('total _tr calls', pairs.length);
console.log('unique', uniq.size);

let idx = 0;
const arb = [];
const keyByEnNl = new Map();
for (const { nl, en } of uniq.values()) {
  const key = `crewUiTr${idx}`;
  idx++;
  keyByEnNl.set(en + '\0' + nl, key);
  const esc = (t) => t.replace(/\\/g, '\\\\').replace(/"/g, '\\"').replace(/\n/g, '\\n');
  arb.push(`  "${key}": "${esc(en)}",`);
}
const outDir = path.join(__dirname, '..', 'scripts');
fs.writeFileSync(path.join(outDir, '_crew_tr_en_arb.txt'), arb.join('\n') + '\n', 'utf8');
fs.writeFileSync(
  path.join(outDir, '_crew_tr_mapping.json'),
  JSON.stringify(Object.fromEntries(keyByEnNl), null, 2),
  'utf8',
);
console.log('Wrote _crew_tr_en_arb.txt and _crew_tr_mapping.json');
