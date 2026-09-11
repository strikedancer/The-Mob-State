# Player Almanac (wiki.themobstate.com)

## Scope
Public, read-only player almanac generated from `backend/content/*.json` and served at `https://wiki.themobstate.com`. Pages are regenerated automatically when those catalogs (or wiki templates) change on the VPS. Noir/gold static HTML in all player locales (`nl`, `en`, `de`, `fr`, `es`, `it`, `pl`, `pt`). Original game images come from the same `runtime/client-images` mount as the Flutter client (`/images/...`).

This is a catalogue and typical-relative guide, not live Black Market quotes. Street prices still move in-game. The **Handleiding** chapter (`/{lang}/guide/`) publishes the full in-game Help & Uitleg, including **Profiel & avatar** (preset swap + selfie→portrait).

## Primary Frontend Entry
- Generator: `wiki/src/build.mjs` (one-shot), `wiki/src/watch.mjs` (rebuild on file change) and `wiki/src/guides.mjs` (Help handbook)
- Theme/nav: `wiki/src/theme.css`, `wiki/src/layout.mjs`, `wiki/src/i18n.mjs`
- Docker: `wiki/Dockerfile` + `wiki/nginx.conf` + `wiki/docker-entrypoint.sh` (port **8082**)
- In-game links: Help (`helpAlmanacOpen`) and landing/login footer (`landingFooterAlmanac`) → `AppConfig.wikiHomeUrl`

## Primary Backend Entry
- None. The almanac does not call the API. Catalog JSON is bind-mounted from `backend/content` (`/content` in the wiki container). HTML is generated at container start and rebuilt when those JSON files or `wiki/src` templates change.

## Change Rules
- Catalog or copy changes in `backend/content/`, Help ARBs (`client/lib/l10n/app_*.arb`) and `wiki/src/` refresh the live almanac after they land on the VPS (`git pull` / standard deploy). No extra `wiki/content` copy is required.
- Chapter-tile PNGs still need the usual copy into `runtime/client-images/wiki/hubs/` (the deploy script already does this).
- Country pages show typical trade factor plus **cars, motorcycles and boats** as separate vehicle environments (do not lump motorcycles into boats).
- Keep UI chrome translated in `wiki/src/i18n.mjs` for every SupportedLanguages code.
- Item names fall back to catalog `name` / `name_en` / `descriptionEn`.
- Images must be the game originals on item pages (vehicles, weapons, drugs, materials, trade cards, properties, aircraft). **Chapter tiles** on the almanac home use dedicated art in `client/assets/images/wiki/hubs/<key>.png` (runtime `/images/wiki/hubs/`), generated with `backend/scripts/generate_wiki_hub_tiles_leonardo.py`. Do not reuse unrelated backgrounds for those tiles.
- Plesk: `wiki.themobstate.com` reverse-proxies to `127.0.0.1:8082` with ACME `ProxyPass !` like admin/api.

## Cross-Module Dependencies
- Almanac -> Trade, Travel, Vehicles, Weapons, Drugs, Materials, Properties, Aviation, Inventory/backpacks, Crimes, Jobs, Crew buildings, School (catalog display only)
- Almanac -> Frontend Platform (same image library mount)
- Almanac -> Marketing web (footer + SEO subdomain)
- Almanac -> Help & Uitleg (CTA + published handbook pages from `app_*.arb` / `help_content.dart`)
- Almanac -> Player Profile / Player Portraits (guide topic `profile`)
- Almanac -> Balance & Economy (do not leak live economy; typical factors only)

## Must Preserve
- One owned-bag / live-price gameplay stays in the client, not on the wiki.
- Help & Uitleg remains the in-game “how this screen works” layer; the almanac publishes the same handbook plus catalogues.

## QA Checklist
1. `node wiki/src/build.mjs --content backend/content --out wiki/dist` completes.
2. Home, a trade good, a vehicle, a weapon, a drug and a country page render with heroes.
3. Language switch keeps the same chapter path.
4. `/images/logo.png` and catalog images load via the runtime mount.
5. `wiki.themobstate.com` serves HTTPS after Plesk subdomain + LE.
6. Help button and landing footer open the matching locale home.
7. Changing a file under `backend/content/` on the VPS rebuilds HTML without a wiki image rebuild (container logs show `wiki: rebuilding`).
8. `/{lang}/guide/` lists every Help topic; `/guide/profile/` covers public profile, preset avatars and selfie portraits.

## i18n and Messaging
- Wiki UI: `wiki/src/i18n.mjs`
- Client CTA keys: `landingFooterAlmanac`, `helpAlmanacOpen`, `helpAlmanacBlurb` in all ARBs.

## When To Update This File
Catalog chapters added/removed, subdomain/port changes, or a decision to expose live prices (should stay no).
