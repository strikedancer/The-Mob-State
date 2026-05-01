#!/usr/bin/env node
/**
 * For every app_<lang>.arb in client/lib/l10n (except app_en.arb), add keys
 * that exist in app_en.arb but are missing in the target. New keys copy the
 * English value (same behavior as merge_arb_missing_from_en.mjs per file).
 *
 * Does NOT overwrite existing keys — changing EN copy for an existing key
 * must be done per locale (or via prefix scripts) so hand translations are kept.
 *
 * Usage (repo root):
 *   node scripts/merge_arb_missing_all_from_en.mjs
 */
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const root = path.join(__dirname, '..');
const l10nDir = path.join(root, 'client', 'lib', 'l10n');
const enPath = path.join(l10nDir, 'app_en.arb');

const en = JSON.parse(fs.readFileSync(enPath, 'utf8'));

const files = fs
  .readdirSync(l10nDir)
  .filter((f) => /^app_[a-z]{2}\.arb$/.test(f) && f !== 'app_en.arb')
  .sort();

if (files.length === 0) {
  console.error('[merge_arb_missing_all_from_en] No locale ARB files found beside app_en.arb');
  process.exit(1);
}

let totalAdded = 0;
for (const targetName of files) {
  const targetPath = path.join(l10nDir, targetName);
  const target = JSON.parse(fs.readFileSync(targetPath, 'utf8'));
  let added = 0;
  for (const k of Object.keys(en)) {
    if (!(k in target)) {
      target[k] = en[k];
      added += 1;
    }
  }
  if (!target['@@locale']) {
    const m = targetName.match(/^app_([a-z]{2})\.arb$/);
    if (m) target['@@locale'] = m[1];
  }
  fs.writeFileSync(targetPath, `${JSON.stringify(target, null, 2)}\n`, 'utf8');
  console.log(`merge_arb_missing_all_from_en: ${targetName} +${added} keys`);
  totalAdded += added;
}
console.log(`[merge_arb_missing_all_from_en] done: ${files.length} file(s), +${totalAdded} key placements total`);
