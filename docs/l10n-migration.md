# Meertaligheid (l10n) — migratie-notities

## Toestand na uitbreiding (player UI)

- Ondersteunde taalcodes staan centraal in:
  - [client/lib/config/supported_languages.dart](../client/lib/config/supported_languages.dart)
  - [backend/src/config/supportedLanguages.ts](../backend/src/config/supportedLanguages.ts)
- Nieuwe ARB-bestanden zijn gesynchroniseerd met `app_en.arb` (template). Vertalingen voor `de`, `fr`, `es`, `it`, `pl`, `pt` starten als **Engelse tekst** tot er professionele vertaling is.
- ARB-pariteit controleren: `node scripts/verify_arb_parity.mjs` (vanaf repo root).
- Nieuwe locale toevoegen: `node scripts/sync_arb_from_en.mjs <code>`, daarna `flutter gen-l10n` in `client/`, en de allowlists in client + backend uitbreiden.

## Legacy patroon: `_isNl` / `_isDutch` / `languageCode == 'nl'`

Er zijn nog veel plekken in de client die **twee takken** gebruiken (Nederlands vs. “alles anders meestal Engels”). Voor spelers met **Duits/Frans/…** valt die tweede tak nu op de **Engelse** tekst — consistent zolang de ARB-strings voor die taal nog Engels zijn.

### Aanbevolen richting

- Nieuwe of gewijzigde UI: voorkeur voor **AppLocalizations**-keys in de ARB’s, geen handmatige tweetalige strings.
- Bestaande schermen: gefaseerd refactoren waar `_isNl` puur voor een tweede string zorgt.

### Inventaris (indicatief)

Zoek naar `_isNl`, `_isDutch`, `languageCode == 'nl'` in `client/lib` — tientallen bestanden; geen blocker voor extra locales, wel technische schuld voor volledige authentieke vertaling per scherm.

## Server-teksten (e-mail, sommige templates)

- [backend/src/services/translationService.ts](../backend/src/services/translationService.ts) blijft primair **NL + EN** voor volledige mailtemplates.
- `getPlayerLanguage` mapt elke niet-NL spelerstaal naar **EN** voor die templates, tot er uitbreiding per taal is.
