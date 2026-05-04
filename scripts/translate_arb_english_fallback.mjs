#!/usr/bin/env node
/**
 * Vertaalt alleen ARB-keys waar de waarde nog exact gelijk is aan app_en.arb
 * (typisch na merge_arb_missing_from_en). Handmatige vertalingen blijven staan.
 *
 * Dekking: geldt voor alle UI die al via AppLocalizations + app_en.arb loopt — dus ook
 * alle schermen uit het zijmenu (dashboard_screen.dart → _buildWebContent).
 *
 * Gebruik:
 *   cd scripts && npm ci   (eenmalig, voor google-translate-api-x)
 *   cd scripts && node translate_arb_english_fallback.mjs --report
 *   cd scripts && node translate_arb_english_fallback.mjs --langs=de,nl,es,fr,it,pl,pt
 *   cd scripts && node translate_arb_english_fallback.mjs --max=100
 *   cd scripts && node translate_arb_english_fallback.mjs --langs=de,fr,it,pl,pt --prefix=territory
 *     (alleen keys die met "territory" beginnen; handige batch voor één scherm)
 *   cd scripts && node translate_arb_english_fallback.mjs --langs=de,fr,es,it,pl,pt --prefix=school,education,achievementSchool,achievementTitle_school_,achievementDescription_school_,supportMod_school
 *     (komma's = meerdere prefixes; key matcht als hij met één ervan begint)
 *   cd scripts && node translate_arb_english_fallback.mjs --langs=de,fr,es,it,pl,pt --prefix=ammoFactory
 *     (Munitiefabriek-scherm: black market infotekst + API-foutcodes)
 *   cd scripts && node translate_arb_english_fallback.mjs --langs=de,fr,es,it,pl,pt --prefix=helpTopicBlackMarket --force
 *     (Help & Uitleg: herschrijf een key-cluster vanaf actuele EN, ook als de locale nog een oude vertaling had)
 *
 * `--force` vereist `--prefix=...` (één of meerdere komma-gescheiden prefixes). Zonder force blijven keys
 * waar target ≠ EN ongemoeid (handmatige of verouderde vertaling).
 *
 * Zie ook: translate_app_arb_from_en.mjs (volledige ARB overschrijven) en verify_arb_parity.mjs.
 */
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import { translate } from 'google-translate-api-x';
import { applyTerminology } from './terminology.mjs';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const root = path.join(__dirname, '..');
const l10nDir = path.join(root, 'client', 'lib', 'l10n');
const enPath = path.join(l10nDir, 'app_en.arb');
const cachePath = path.join(__dirname, '.translate_cache.json');

const args = process.argv.slice(2);
const REPORT = args.includes('--report');
const maxArg = args.find((a) => a.startsWith('--max='));
const MAX = maxArg ? parseInt(maxArg.split('=')[1], 10) : Infinity;
const langsArg = args.find((a) => a.startsWith('--langs='));
const LANG_FILTER = langsArg
  ? new Set(
      langsArg
        .split('=')[1]
        .split(',')
        .map((c) => c.trim().toLowerCase())
        .filter((c) => /^[a-z]{2}$/.test(c)),
    )
  : null;

const prefixArg = args.find((a) => a.startsWith('--prefix='));
const KEY_PREFIXES = prefixArg
  ? prefixArg
      .split('=')[1]
      .split(',')
      .map((p) => p.trim())
      .filter(Boolean)
  : null;

const FORCE = args.includes('--force');
if (FORCE && (!KEY_PREFIXES || KEY_PREFIXES.length === 0)) {
  console.error('translate_arb_english_fallback: --force requires --prefix=... (comma-separated allowed).');
  process.exit(1);
}

function keyMatchesPrefixes(key) {
  if (!KEY_PREFIXES || KEY_PREFIXES.length === 0) return true;
  return KEY_PREFIXES.some((prefix) => key.startsWith(prefix));
}

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

function stringKeys(en) {
  return Object.keys(en).filter(
    (k) =>
      k !== '@@locale' &&
      !k.startsWith('@') &&
      typeof en[k] === 'string',
  );
}

/** Do not machine-translate ICU plural/select strings (MT corrupts syntax). */
function isIcuSelectOrPlural(s) {
  return /,\s*plural\s*,/.test(s) || /,\s*select\s*,/.test(s);
}

function keysForTranslation(en, target) {
  const keys = [];
  for (const k of stringKeys(en)) {
    if (!keyMatchesPrefixes(k)) continue;
    if (target[k] === undefined) continue;
    if (isIcuSelectOrPlural(en[k])) continue;
    if (!FORCE && target[k] !== en[k]) continue;
    keys.push(k);
  }
  return keys;
}

async function main() {
  const en = JSON.parse(fs.readFileSync(enPath, 'utf8'));
  const arbFiles = fs
    .readdirSync(l10nDir)
    .filter((f) => /^app_[a-z]{2}\.arb$/.test(f) && f !== 'app_en.arb')
    .sort();

  let totalReport = 0;
  for (const f of arbFiles) {
    const code = f.replace(/^app_/, '').replace(/\.arb$/, '');
    if (LANG_FILTER && !LANG_FILTER.has(code)) continue;

    const p = path.join(l10nDir, f);
    const target = JSON.parse(fs.readFileSync(p, 'utf8'));
    const keys = keysForTranslation(en, target);

    if (REPORT) {
      totalReport += keys.length;
      console.log(`[${f}] English-fallback keys: ${keys.length}`);
      continue;
    }

    if (keys.length === 0) continue;

    let done = 0;
    const toTranslate = keys.slice(0, MAX);
    for (const k of toTranslate) {
      done++;
      process.stdout.write(`\r[${f}] ${done}/${toTranslate.length}   `);
      target[k] = await trText(en[k], code);
    }
    process.stdout.write('\n');
    if (keys.length > toTranslate.length) {
      console.warn(
        `[${f}] Stopped at --max=${MAX}; ${keys.length - toTranslate.length} keys left.`,
      );
    }
    fs.writeFileSync(p, JSON.stringify(target, null, 2) + '\n', 'utf8');
    console.log('Wrote', p);
  }

  saveCache();
  if (REPORT) {
    console.log(`\nTotal English-fallback string keys (all listed locales): ${totalReport}`);
    console.log('Run without --report to translate (requires network).');
  }
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
