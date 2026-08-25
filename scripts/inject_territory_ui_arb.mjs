#!/usr/bin/env node
/**
 * Merges scripts/territory_ui_l10n_data.json into app_en.arb and patches app_nl.arb values.
 * Run: node scripts/inject_territory_ui_arb.mjs
 * Then: node scripts/merge_arb_missing_from_en.mjs app_de.arb (etc.) && flutter gen-l10n
 * Keys die in de/fr/es/it/pl/pt nog Engels zijn (zelfde string als EN): vanaf scripts/
 *   node translate_arb_english_fallback.mjs --langs=de,fr,es,it,pl,pt --prefix=territory
 */
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const root = path.join(__dirname, '..');
const l10nDir = path.join(root, 'client', 'lib', 'l10n');
const dataPath = path.join(__dirname, 'territory_ui_l10n_data.json');

const META = {
  territoryPointsLogicLine: {
    placeholders: {
      basePoints: { type: 'int' },
      bonusPoints: { type: 'int' },
      totalPoints: { type: 'int' },
    },
  },
  territoryMapOverviewTitle: {
    placeholders: { country: { type: 'String' } },
  },
  territoryYourCrewLine: {
    placeholders: { name: { type: 'String' } },
  },
  territoryNoticeWrongCountry: {
    placeholders: {
      viewingCountry: { type: 'String' },
      playerCountry: { type: 'String' },
    },
  },
  territoryHqLockedNotice: {
    placeholders: { actions: { type: 'String' } },
  },
  territoryContestOtherCountryNotice: {
    placeholders: { country: { type: 'String' } },
  },
  territoryLeaderboardRegionsCount: {
    placeholders: { count: { type: 'int' } },
  },
  territoryDialogAttackBody: {
    placeholders: { regionKey: { type: 'String' } },
  },
  territorySnackContestStarted: {
    placeholders: { status: { type: 'String' } },
  },
  territorySnackContestAlreadyLive: {
    placeholders: { status: { type: 'String' } },
  },
  territoryPointsDelta: {
    placeholders: { points: { type: 'String' } },
  },
  territoryHqTooltipLocked: {
    placeholders: {
      required: { type: 'int' },
      current: { type: 'int' },
    },
  },
  territoryHqButtonLocked: {
    placeholders: {
      label: { type: 'String' },
      level: { type: 'int' },
    },
  },
  territoryContestHudScore: {
    placeholders: {
      attacker: { type: 'int' },
      defender: { type: 'int' },
    },
  },
  territoryProjectLockedHq: {
    placeholders: { level: { type: 'int' } },
  },
  territoryLeaderboardStatsLine: {
    placeholders: {
      won: { type: 'int' },
      defended: { type: 'int' },
      lost: { type: 'int' },
      hold: { type: 'String' },
    },
  },
  territoryHoldDurationDaysHours: {
    placeholders: {
      days: { type: 'int' },
      hours: { type: 'int' },
    },
  },
  territoryHoldDurationHoursMinutes: {
    placeholders: {
      hours: { type: 'int' },
      minutes: { type: 'int' },
    },
  },
  territoryHoldDurationMinutes: {
    placeholders: { minutes: { type: 'int' } },
  },
};

const data = JSON.parse(fs.readFileSync(dataPath, 'utf8'));

function injectIntoArb(fileName, stringMap) {
  const p = path.join(l10nDir, fileName);
  const arb = JSON.parse(fs.readFileSync(p, 'utf8'));
  for (const [k, v] of Object.entries(stringMap)) {
    if (typeof v !== 'string') continue;
    arb[k] = v;
  }
  if (fileName === 'app_en.arb' || fileName === 'app_nl.arb') {
    for (const [baseKey, meta] of Object.entries(META)) {
      arb[`@${baseKey}`] = meta;
    }
  }
  fs.writeFileSync(p, `${JSON.stringify(arb, null, 2)}\n`, 'utf8');
  console.log(`inject_territory_ui_arb: updated ${fileName}`);
}

injectIntoArb('app_en.arb', data.en);
injectIntoArb('app_nl.arb', { ...data.en, ...data.nl });
