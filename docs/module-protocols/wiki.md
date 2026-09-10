# Player Almanac (wiki.themobstate.com)

## Scope
Public, read-only player almanac generated from `backend/content/*.json` and served at `https://wiki.themobstate.com`. Noir/gold static HTML in all player locales (`nl`, `en`, `de`, `fr`, `es`, `it`, `pl`, `pt`). Original game images come from the same `runtime/client-images` mount as the Flutter client (`/images/...`).

This is a catalogue and typical-relative guide, not live Black Market quotes. Street prices still move in-game.

## Primary Frontend Entry
- Generator: `wiki/src/build.mjs`
- Theme/nav: `wiki/src/theme.css`, `wiki/src/layout.mjs`, `wiki/src/i18n.mjs`
- Docker: `wiki/Dockerfile` + `wiki/nginx.conf` (port **8082**)
- In-game links: Help (`helpAlmanacOpen`) and landing/login footer (`landingFooterAlmanac`) → `AppConfig.wikiHomeUrl`

## Primary Backend Entry
- None. The almanac does not call the API. Catalog JSON is copied into the image at build time (`wiki/content` from `backend/content`).

## Change Rules
- Rebuild the wiki service whenever `backend/content/` catalogs or wiki templates change.
- Do not publish live tick prices or a ranked “best money route” ladder. Country **tradeBonuses** may be shown as a typical factor (lower = typically cheaper to buy).
- Keep UI chrome translated in `wiki/src/i18n.mjs` for every SupportedLanguages code.
- Item names fall back to catalog `name` / `name_en` / `descriptionEn`.
- Images must be the game originals (vehicles, weapons, drugs, materials, trade cards, properties, aircraft). Missing files hide via CSS empty background; do not ship placeholders that look like new art.
- Plesk: `wiki.themobstate.com` reverse-proxies to `127.0.0.1:8082` with ACME `ProxyPass !` like admin/api.

## Cross-Module Dependencies
- Almanac -> Trade, Travel, Vehicles, Weapons, Drugs, Materials, Properties, Aviation, Inventory/backpacks, Crimes, Jobs, Crew buildings, School (catalog display only)
- Almanac -> Frontend Platform (same image library mount)
- Almanac -> Marketing web (footer + SEO subdomain)
- Almanac -> Help & Uitleg (CTA)
- Almanac -> Balance & Economy (do not leak live economy; typical factors only)

## Must Preserve
- One owned-bag / live-price gameplay stays in the client, not on the wiki.
- Help & Uitleg remains the in-game “how this screen works” layer; the almanac is “what exists and where”.

## QA Checklist
1. `node wiki/src/build.mjs --content backend/content --out wiki/dist` completes.
2. Home, a trade good, a vehicle, a weapon, a drug and a country page render with heroes.
3. Language switch keeps the same chapter path.
4. `/images/logo.png` and catalog images load via the runtime mount.
5. `wiki.themobstate.com` serves HTTPS after Plesk subdomain + LE.
6. Help button and landing footer open the matching locale home.

## i18n and Messaging
- Wiki UI: `wiki/src/i18n.mjs`
- Client CTA keys: `landingFooterAlmanac`, `helpAlmanacOpen`, `helpAlmanacBlurb` in all ARBs.

## When To Update This File
Catalog chapters added/removed, subdomain/port changes, or a decision to expose live prices (should stay no).
