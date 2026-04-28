#!/usr/bin/env node
/**
 * Add any keys present in app_en.arb but missing in another ARB (same values as EN).
 * Preserves extra keys in the target (e.g. legacy-only keys in nl).
 *
 * Usage: node scripts/merge_arb_missing_from_en.mjs app_nl.arb
 */
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const root = path.join(__dirname, '..');
const l10nDir = path.join(root, 'client', 'lib', 'l10n');
const enPath = path.join(l10nDir, 'app_en.arb');

const targetName = process.argv[2];
if (!targetName || !/^app_[a-z]{2}\.arb$/.test(targetName)) {
  console.error('Usage: node scripts/merge_arb_missing_from_en.mjs app_nl.arb');
  process.exit(1);
}

const en = JSON.parse(fs.readFileSync(enPath, 'utf8'));
const targetPath = path.join(l10nDir, targetName);
const target = JSON.parse(fs.readFileSync(targetPath, 'utf8'));

let added = 0;
for (const k of Object.keys(en)) {
  if (!(k in target)) {
    target[k] = en[k];
    added += 1;
  }
}

if (target['@@locale'] == null && en['@@locale'] != null) {
  // keep target locale if present
}
if (!target['@@locale']) {
  const m = targetName.match(/^app_([a-z]{2})\.arb$/);
  if (m) target['@@locale'] = m[1];
}

fs.writeFileSync(targetPath, `${JSON.stringify(target, null, 2)}\n`, 'utf8');
console.log(`merge_arb_missing_from_en: ${targetName} +${added} keys (from app_en.arb).`);
