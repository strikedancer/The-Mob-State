import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const s = fs.readFileSync(path.join(__dirname, '..', 'client', 'lib', 'screens', 'crew_screen.dart'), 'utf8');

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
  return { start, end: i };
}

let n = 0;
for (let i = 0; i < s.length; i++) {
  if (s[i] === '_' && s.startsWith('_tr(', i)) {
    const p = parseTrAt(s, i);
    if (p) {
      n++;
      i = p.end - 1;
    }
  }
}
console.log('parsed', n);
