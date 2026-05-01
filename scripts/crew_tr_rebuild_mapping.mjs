#!/usr/bin/env node
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const dartPath = path.join(__dirname, '..', 'client', 'lib', 'screens', 'crew_screen.dart');

function skipWs(s, i) {
  while (i < s.length && /\s/.test(s[i])) i++;
  return i;
}
function parseDartString(s, i) {
  if (i >= s.length || s[i] !== "'") return null;
  i++;
  let out = '';
  while (i < s.length) {
    const c = s[i];
    if (c === '\\') {
      const n = s[i + 1];
      if (n === 'n') {
        out += '\n';
        i += 2;
        continue;
      }
      if (n === undefined) return null;
      out += n;
      i += 2;
      continue;
    }
    if (c === "'") return { value: out, next: i + 1 };
    out += c;
    i++;
  }
  return null;
}
function parseTrAt(s, start) {
  if (!s.startsWith('_tr(', start)) return null;
  let i = start + '_tr('.length;
  i = skipWs(s, i);
  if (!s.startsWith('locale', i)) return null;
  i += 'locale'.length;
  i = skipWs(s, i);
  if (s[i] !== ',') return null;
  i++;
  i = skipWs(s, i);
  const nl = parseDartString(s, i);
  if (!nl) return null;
  i = skipWs(s, nl.next);
  if (s[i] !== ',') return null;
  i++;
  i = skipWs(s, i);
  const en = parseDartString(s, i);
  if (!en) return null;
  i = skipWs(s, en.next);
  if (s[i] === ',') {
    i++;
    i = skipWs(s, i);
  }
  if (s[i] !== ')') return null;
  i++;
  return { nl: nl.value, en: en.value, end: i };
}

const s = fs.readFileSync(dartPath, 'utf8');
const pairs = [];
for (let i = 0; i < s.length; i++) {
  if (s[i] === '_' && s.startsWith('_tr(', i)) {
    const p = parseTrAt(s, i);
    if (p) {
      pairs.push(p);
      i = p.end - 1;
    }
  }
}
const uniq = new Map();
let idx = 0;
for (const { nl, en } of pairs) {
  const k = en + '\0' + nl;
  if (!uniq.has(k)) uniq.set(k, `crewUiTr${idx++}`);
}
const arb = [];
for (const [k, id] of uniq) {
  const en = k.split('\0')[0];
  const esc = (t) => t.replace(/\\/g, '\\\\').replace(/"/g, '\\"').replace(/\n/g, '\\n');
  arb.push(`  "${id}": "${esc(en)}",`);
}
fs.writeFileSync(path.join(__dirname, '_crew_tr_en_arb.txt'), arb.join('\n') + '\n', 'utf8');
fs.writeFileSync(
  path.join(__dirname, '_crew_tr_mapping.json'),
  JSON.stringify(Object.fromEntries(uniq), null, 2),
  'utf8',
);
console.log('pairs', pairs.length, 'unique', uniq.size);
