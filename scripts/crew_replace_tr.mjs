#!/usr/bin/env node
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const dartPath = path.join(__dirname, '..', 'client', 'lib', 'screens', 'crew_screen.dart');
const mapPath = path.join(__dirname, '_crew_tr_mapping.json');
const keyByEnNl = JSON.parse(fs.readFileSync(mapPath, 'utf8'));

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
  if (s.startsWith('locale', i)) i += 'locale'.length;
  else if (s.startsWith('l10n', i)) i += 'l10n'.length;
  else return null;
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
  return { start, end: i, nl: nl.value, en: en.value };
}


let s = fs.readFileSync(dartPath, 'utf8');
const hits = [];
for (let i = 0; i < s.length; i++) {
  if (s[i] === '_' && s.startsWith('_tr(', i)) {
    const p = parseTrAt(s, i);
    if (p) {
      hits.push(p);
      i = p.end - 1;
    }
  }
}

const replacements = [];
for (const p of hits) {
  const keyId = keyByEnNl[p.en + '\0' + p.nl];
  if (!keyId) {
    console.error('Missing mapping for EN:', JSON.stringify(p.en.slice(0, 60)));
    console.error('NL:', JSON.stringify(p.nl.slice(0, 60)));
    process.exit(1);
  }
  replacements.push({ start: p.start, end: p.end, text: `l10n.${keyId}` });
}
replacements.sort((a, b) => b.start - a.start);
for (const { start, end, text } of replacements) {
  s = s.slice(0, start) + text + s.slice(end);
}
fs.writeFileSync(dartPath, s, 'utf8');
console.log('Replaced', replacements.length, '_tr calls');
