#!/usr/bin/env node
/**
 * Ensure every app_*.arb under client/lib/l10n has the same key set as app_en.arb (template).
 * Exit 1 on mismatch.
 *
 * Usage: node scripts/verify_arb_parity.mjs
 */
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const root = path.join(__dirname, '..');
const l10nDir = path.join(root, 'client', 'lib', 'l10n');

const templateName = 'app_en.arb';
const templatePath = path.join(l10nDir, templateName);
const template = JSON.parse(fs.readFileSync(templatePath, 'utf8'));
const templateKeys = new Set(Object.keys(template));

const files = fs
  .readdirSync(l10nDir)
  .filter((f) => /^app_[a-z]{2}\.arb$/.test(f) && f !== templateName)
  .sort();

let failed = false;
for (const f of files) {
  const p = path.join(l10nDir, f);
  const data = JSON.parse(fs.readFileSync(p, 'utf8'));
  const keys = new Set(Object.keys(data));
  const missing = [...templateKeys].filter((k) => !keys.has(k));
  const extra = [...keys].filter((k) => !templateKeys.has(k));
  if (missing.length || extra.length) {
    failed = true;
    console.error(`[verify_arb_parity] ${f}:`);
    if (missing.length) console.error('  missing keys:', missing.slice(0, 20), missing.length > 20 ? '...' : '');
    if (extra.length) console.error('  extra keys:', extra.slice(0, 20), extra.length > 20 ? '...' : '');
  }
}

if (failed) {
  process.exit(1);
}
console.log(`[verify_arb_parity] OK: ${templateName} compared to ${files.length} locale file(s).`);
