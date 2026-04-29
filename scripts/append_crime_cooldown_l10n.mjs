#!/usr/bin/env node
/**
 * Appends crime screen, crime card, cooldown overlay, connection error, and
 * weapon display name keys to app_en.arb (idempotent).
 */
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const enPath = path.join(__dirname, '..', 'client', 'lib', 'l10n', 'app_en.arb');

const additions = {
  "connectionErrorGeneric": "Connection error",
  "crimeWeaponSectionTitle": "Crime weapon",
  "crimeWeaponInstruction":
    "Choose which carried weapon you use by default for crimes that require one.",
  "crimeWeaponEmptyInventoryHelp":
    "Buy or move a usable weapon into your carried inventory first.",
  "crimeWeaponSelectHint": "Select a weapon for crimes",
  "crimeWeaponNoSelectionNote":
    "Without a selection, weapon-based crimes will not start.",
  "crimeWeaponSelectedStatus": "Selected: {weaponLine}. Some crimes still require a matching weapon type on top of that.",
  "@crimeWeaponSelectedStatus": {
    "placeholders": { "weaponLine": { "type": "String" } }
  },
  "crimeSetWeaponFailed": "Failed to set crime weapon.",
  "crimeChooseWeaponBeforeCommit":
    "Choose a crime weapon at the top of this screen or via Inventory first.",
  "crimeWeaponFooterNote":
    "Weapon-based crimes use the selected crime weapon above.",
  "crimeCriminalRecordWipeDesc":
    "Forge court files and wipe your full criminal record if the operation succeeds.",
  "crimeCardSuccessChance": "{percent}% success chance",
  "@crimeCardSuccessChance": {
    "placeholders": { "percent": { "type": "int" } }
  },
  "cooldownTimeLeft": "Time left",
  "cooldownMustWaitExplanation":
    "You must wait before you can perform this action again.",
  "cooldownAlreadyFinished": "Cooldown already finished.",
  "cooldownNotEnoughCredits": "Not enough credits.",
  "cooldownNoActiveToReset": "No active cooldown to reset.",
  "cooldownNotAvailableNow": "Not available right now.",
  "cooldownRedeemFailed": "Failed to speed up with credits.",
  "cooldownFinishedInstantly": "Cooldown finished instantly.",
  "cooldownSpeedUpNow": "Speed up now (-{cost} credits)",
  "@cooldownSpeedUpNow": { "placeholders": { "cost": { "type": "int" } } },
  "cooldownCreditBalanceLine": "Balance: {balance} credits",
  "@cooldownCreditBalanceLine": { "placeholders": { "balance": { "type": "int" } } },
  "cooldownLoadingCreditOptions": "Loading credit options…",
  "cooldownWaitCrime": "The heat is too high…",
  "cooldownWaitJob": "Taking a rest before you can work again",
  "cooldownWaitTravel": "Next flight departs in",
  "cooldownWaitHeist": "Planning the heist…",
  "cooldownWaitAppeal": "Court is busy…",
  "cooldownWaitDefault": "Please wait…",
  "weaponLabelKnife": "Knife",
  "weaponLabelHandgun9mm": "Pistol (9mm)",
  "weaponLabelHandgunHeavy": "Heavy Pistol (.45)",
  "weaponLabelSmgCompact": "Compact SMG",
  "weaponLabelShotgunPump": "Shotgun (pump)",
  "weaponLabelMolotov": "Molotov cocktail",
  "weaponLabelSmgSuppressed": "Suppressed SMG",
  "weaponLabelShotgunTactical": "Tactical Shotgun",
  "weaponLabelAssaultRifle": "Assault rifle (AK-47)",
  "weaponLabelGrenadeFlash": "Flash grenade",
  "weaponLabelGrenadeFrag": "Fragmentation grenade",
  "weaponLabelSniperStandard": "Sniper rifle",
  "weaponLabelAssaultRifleVip": "Elite assault rifle",
  "weaponLabelSniperVip": "Elite sniper rifle",
  "cooldownTitleCrime": "Crime cooldown",
  "cooldownTitleJob": "Job cooldown",
  "cooldownTitleTravel": "Travel cooldown",
  "cooldownTitleHeist": "Heist cooldown",
  "cooldownTitleAppeal": "Appeal cooldown",
  "cooldownTitleSchool": "School cooldown",
  "cooldownTitleGeneric": "Cooldown"
};

const en = JSON.parse(fs.readFileSync(enPath, 'utf8'));
let n = 0;
for (const [k, v] of Object.entries(additions)) {
  if (!(k in en)) {
    en[k] = v;
    n += 1;
  }
}
fs.writeFileSync(enPath, JSON.stringify(en, null, 2) + '\n', 'utf8');
console.log(`append_crime_cooldown_l10n: +${n} keys`);
