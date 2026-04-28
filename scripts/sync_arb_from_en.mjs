#!/usr/bin/env node
/**
 * Clone client/lib/l10n/app_en.arb into app_<lang>.arb with the same keys/strings.
 * Use when adding a new locale: strings start as English until professional translation.
 *
 * Usage (from repo root):
 *   node scripts/sync_arb_from_en.mjs de fr es it pl pt
 */
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const root = path.join(__dirname, '..');
const enPath = path.join(root, 'client', 'lib', 'l10n', 'app_en.arb');

const targets = process.argv.slice(2);
if (targets.length === 0) {
  console.error('Usage: node scripts/sync_arb_from_en.mjs <lang> [<lang> ...]');
  process.exit(1);
}

const enRaw = fs.readFileSync(enPath, 'utf8');
const en = JSON.parse(enRaw);

for (const code of targets) {
  if (!/^[a-z]{2}$/.test(code)) {
    console.error(`Invalid language code (expected two-letter a-z): ${code}`);
    process.exit(1);
  }
  const { '@@locale': _ignored, ...rest } = en;
  const out = {
    '@@locale': code,
    ...rest,
  };
  const outPath = path.join(root, 'client', 'lib', 'l10n', `app_${code}.arb`);
  fs.writeFileSync(outPath, `${JSON.stringify(out, null, 2)}\n`, 'utf8');
  console.log('Wrote', path.relative(root, outPath));
}
