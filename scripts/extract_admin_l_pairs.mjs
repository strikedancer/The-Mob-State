#!/usr/bin/env node
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const txt = fs.readFileSync(path.join(__dirname, '../admin/src/App.tsx'), 'utf8');
const re =
  /\bl\(\s*"((?:[^"\\]|\\.)*)"\s*,\s*"((?:[^"\\]|\\.)*)"\s*\)/g;
let m;
const pairs = [];
const seen = new Set();
while ((m = re.exec(txt))) {
  const key = m[1] + '|||' + m[2];
  if (!seen.has(key)) {
    seen.add(key);
    pairs.push({ nl: JSON.parse('"' + m[1].replace(/\\(.)/g, '$1') + '"'), en: JSON.parse('"' + m[2].replace(/\\(.)/g, '$1') + '"') });
  }
}
console.log('unique pairs', pairs.length);
