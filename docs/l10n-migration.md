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

### Inventaris (indicatief)

Zoek naar `_isNl`, `_isDutch`, `languageCode == 'nl'` in `client/lib` — tientallen bestanden; geen blocker voor extra locales, wel technische schuld voor volledige authentieke vertaling per scherm.

## Server-teksten (e-mail, sommige templates)

- [backend/src/services/translationService.ts](../backend/src/services/translationService.ts) blijft primair **NL + EN** voor volledige mailtemplates.
- `getPlayerLanguage` mapt elke niet-NL spelerstaal naar **EN** voor die templates, tot er uitbreiding per taal is.
