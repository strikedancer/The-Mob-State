# Meertaligheid (l10n) — migratie-notities

## Toestand na uitbreiding (player UI)

- Ondersteunde taalcodes staan centraal in:
  - [client/lib/config/supported_languages.dart](../client/lib/config/supported_languages.dart)
  - [backend/src/config/supportedLanguages.ts](../backend/src/config/supportedLanguages.ts)
- ARB’s voor `de`, `fr`, `es`, `it`, `pl`, `pt` worden gevuld vanuit `app_en.arb` met het script `scripts/translate_app_arb_from_en.mjs` (Google Translate via `google-translate-api-x`, gedeeld cache-bestand `scripts/.translate_cache.json`, niet gecommit). Review game-terminologie desgewenst handmatig.
- Terminologie wordt na vertaling conservatief bijgestuurd via `scripts/terminology.mjs` (bijv. `Crew`, `Nightclub`, `VIP`).
- **Admin**-UI-teksten: `npm run build-admin-i18n` in `scripts/` schrijft `admin/src/i18n/translations.ts` en `inlineMessages.ts` (zelfde MT-stack).
- ARB-pariteit controleren: `node scripts/verify_arb_parity.mjs` (vanaf repo root).
- Nieuwe locale toevoegen: `node scripts/sync_arb_from_en.mjs <code>`, daarna `flutter gen-l10n` in `client/`, en de allowlists in client + backend (plus `ADMIN_LANGUAGE_OPTIONS` in `admin/src/App.tsx`) uitbreiden.

## Legacy patroon: `_isNl` / `_isDutch` / `languageCode == 'nl'`

Er zijn nog veel plekken in de client die **twee takken** gebruiken (Nederlands vs. “alles anders meestal Engels”). Voor spelers met **Duits/Frans/…** valt die tweede tak nu op de **Engelse** tekst — consistent zolang de ARB-strings voor die taal nog Engels zijn.

### Aanbevolen richting

- Nieuwe of gewijzigde UI: voorkeur voor **AppLocalizations**-keys in de ARB’s, geen handmatige tweetalige strings.
- Bestaande schermen: gefaseerd refactoren waar `_isNl` puur voor een tweede string zorgt.
- Concreet: dashboard navigatie + quick-actions labels zijn een hotspot; als die hardcoded blijven, zien spelers met `es/de/fr/...` veel Engels.
- Voeg bij dashboard-topbar/menus alleen nieuwe teksten toe via ARB keys (bijv. knoppen als “View offer”), zodat EU-locales niet terugvallen op EN.
- Let op scope: gebruik `AppLocalizations.of(ctx)` binnen `showDialog`/`builder` i.p.v. een outer `l10n` die daar niet zichtbaar is.
- De dashboard center cards (stats/economy/ops) bevatten veel labels en zijn een tweede hotspot voor “NL/EN leakage”; vertaal die via ARB keys i.p.v. `_tr(...)`.
- Daily/weekly goals komen uit de backend met `titleNl/titleEn`. Voor EU-locales is dat te beperkt: map `goal.key` (bv. `crime_3`, `weekly_vehicle_theft_5`) naar ARB-keys in de client en formatteer de reward-string (`Reward: +{cash} …`) ook via ARB.
- Vehicle Ops in het dashboard heeft veel kleine labels (Heat/Rep/trends/chips). Als die hardcoded blijven, zie je Engels zelfs wanneer menu’s al vertaald zijn.
- De instellingenpagina is een aparte hotspot: push permission status, “Enable push”, crypto push/in-app toggles en foutmeldingen moeten via ARB keys (niet NL/EN strings).

### Inventaris (indicatief)

Zoek naar `_isNl`, `_isDutch`, `languageCode == 'nl'` in `client/lib` — tientallen bestanden; geen blocker voor extra locales, wel technische schuld voor volledige authentieke vertaling per scherm.

## Server-teksten (e-mail, sommige templates)

- Transactionele HTML-mail (verificatie, reset, vriendschap, crew, casino-waarschuwing) gebruikt `translationService.getTranslations(preferredLanguage)`: **NL** en **EN** in [translationService.ts](../backend/src/services/translationService.ts), **de / fr / es / it / pl / pt** in [playerEmailBundlesExtra.ts](../backend/src/i18n/playerEmailBundlesExtra.ts) (merge in `getTranslations`, zelfde shape als EN).
- Registratie-mail gebruikt de taal meegegeven bij register; wachtwoord-reset gebruikt `player.preferredLanguage` uit de database.
