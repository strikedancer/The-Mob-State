#!/usr/bin/env node
/**
 * Fills app_<lang>.arb from app_en.arb using google-translate-api-x (same cache as build_admin_i18n).
 * Preserves {placeholders} in strings. Keeps @metadata blocks identical to English.
 *
 * Usage: node scripts/translate_app_arb_from_en.mjs
 *        node scripts/translate_app_arb_from_en.mjs --langs=de,fr,it,pl,pt
 * (Omit `es` and `nl` if those ARBs are hand-curated; this overwrites the whole target file.)
 *
 * Env: optional — uses scripts/.translate_cache.json
 */
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import { translate } from 'google-translate-api-x';
import { applyTerminology } from './terminology.mjs';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const root = path.join(__dirname, '..');
const l10nDir = path.join(root, 'client', 'lib', 'l10n');
const templatePath = path.join(l10nDir, 'app_en.arb');
const cachePath = path.join(__dirname, '.translate_cache.json');

const defaultTargets = ['de', 'fr', 'es', 'it', 'pl', 'pt'];
const langsArg = process.argv.find((a) => a.startsWith('--langs='));
const TARGETS = langsArg
  ? langsArg
      .split('=')[1]
      .split(',')
      .map((c) => c.trim().toLowerCase())
      .filter((c) => /^[a-z]{2}$/.test(c))
  : defaultTargets;
const DELAY_MS = 120;

const sleep = (ms) => new Promise((r) => setTimeout(r, ms));

function loadCache() {
  try {
    return JSON.parse(fs.readFileSync(cachePath, 'utf8'));
  } catch {
    return {};
  }
}
let cache = loadCache();
function saveCache() {
  fs.writeFileSync(cachePath, JSON.stringify(cache, null, 2), 'utf8');
}
function cacheKey(from, to, text) {
  return `${from}|${to}|${text}`;
}

function maskPlaceholders(s) {
  const ph = [];
  const masked = s.replace(/\{[^{}]+\}/g, (m) => {
    ph.push(m);
    return `⟦${ph.length - 1}⟧`;
  });
  return { masked, ph };
}
function unmask(s, ph) {
  let out = s;
  for (let i = 0; i < ph.length; i++) {
    out = out.replace(`⟦${i}⟧`, ph[i]);
  }
  return out;
}

async function trText(text, to) {
  if (!text || !String(text).trim()) return text;
  const k = cacheKey('en', to, text);
  if (cache[k]) return cache[k];
  const { masked, ph } = maskPlaceholders(text);
  let lastErr;
  for (let attempt = 0; attempt < 8; attempt++) {
    try {
      await sleep(DELAY_MS + attempt * 100);
      const r = await translate(masked, {
        from: 'en',
        to,
        forceBatch: false,
        rejectOnPartialFail: false,
      });
      const raw = r.text ?? masked;
      const out = applyTerminology(to, unmask(raw, ph));
      cache[k] = out;
      if (Object.keys(cache).length % 50 === 0) saveCache();
      return out;
    } catch (e) {
      lastErr = e;
    }
  }
  throw lastErr;
}

async function main() {
  if (TARGETS.length === 0) {
    console.error('No valid --langs= codes (expected e.g. de,fr,it,pl,pt).');
    process.exit(1);
  }
  console.log('translate_app_arb_from_en: target locales:', TARGETS.join(', '));
  const en = JSON.parse(fs.readFileSync(templatePath, 'utf8'));
  const keys = Object.keys(en);

  for (const lang of TARGETS) {
    const out = { [`@@locale`]: lang };
    let n = 0;
    const strKeys = keys.filter(
      (k) => !k.startsWith('@') && typeof en[k] === 'string',
    );
    for (const k of keys) {
      if (k === '@@locale') continue;
      if (k.startsWith('@') && k !== '@@locale') {
        out[k] = en[k];
        continue;
      }
      if (typeof en[k] === 'string') {
        n++;
        process.stdout.write(`\r[app_${lang}.arb] ${n}/${strKeys.length}   `);
        out[k] = await trText(en[k], lang);
      }
    }
    process.stdout.write('\n');
    const outPath = path.join(l10nDir, `app_${lang}.arb`);
    fs.writeFileSync(outPath, JSON.stringify(out, null, 2) + '\n', 'utf8');
    console.log('Wrote', outPath);
  }
  saveCache();
  console.log('Cache entries:', Object.keys(cache).length);
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
