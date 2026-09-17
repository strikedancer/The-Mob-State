# Player Almanac (wiki.themobstate.com)

## Scope
Public, read-only player almanac generated from `backend/content/*.json` and served at `https://wiki.themobstate.com`. Pages are regenerated automatically when those catalogs (or wiki templates) change on the VPS. Noir/gold static HTML in all player locales (`nl`, `en`, `de`, `fr`, `es`, `it`, `pl`, `pt`). Original game images come from the same `runtime/client-images` mount as the Flutter client (`/images/...`). Home titles/descriptions name **The Mob State** plus a local “text-based mafia game” phrase (`seoDocumentTitle` / `seoDocumentDescription` in `wiki/src/i18n.mjs`). Sitemap: `https://wiki.themobstate.com/sitemap.xml` (also listed from `themobstate.com/robots.txt`). Search Console: aparte URL-prefix property — zie `docs/seo.md`.

This is a catalogue and typical-relative guide, not live Black Market quotes. Street prices still move in-game. The **Handleiding** chapter (`/{lang}/guide/`) publishes the full in-game Help & Uitleg, including **Don**, **Midnight Races**, **Profiel & avatar**, **Prostitutie** and **Red Light Districts**. Search in the header uses `/{lang}/search.json` and matches every generated page, not only the cards on the current screen. A bottom-right **Ask the Almanac** panel answers player questions from that same index (handbook first); it is not a live-price bot and does not call the game API.

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
- Almanac -> Prostitution / Red Light Districts (`/{lang}/guide/prostitution/` and `/{lang}/guide/red-light-districts/`): room upgrades, occupancy heat, events, steal/reclaim, contest phases. Those sentences must land in `/{lang}/search.json` so header search and Ask the Almanac find them.
- Almanac -> Territory / Crew (`/{lang}/guide/territory/` and `/{lang}/guide/crew/`): HQ reserve vs frontline arms cache, ammo spend, weapon wear, type match, long supply tax, loot/burn on region loss, personal inventory does not count. Those sentences must land in `/{lang}/search.json` so header search and Ask the Almanac find them. `writeSearchIndexes` keeps handbook `answer` (8000) and page `text` (24000); Ask the Almanac scores snippet + answer + text. Do not shrink those slices without checking that `/guide/territory/` still matches “wapendepot” / “frontline arsenal”.
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
8. `/{lang}/guide/` lists every Help topic; `/guide/don/` covers rackets, loans, officials and contracts; `/guide/profile/` covers public profile, preset avatars and selfie portraits.
9. Header search on any page finds Don, handbook topics (including Red Light District rooms, occupancy heat, events, steal/reclaim and contest, plus Territory arsenal / crew ammo feeding Territory) and catalog items via `/{lang}/search.json`. After changing `wiki/src/client.js` or `theme.css`, bump `ASSET_V` in `layout.mjs` so browsers skip the 7-day static cache.
10. The Ask the Almanac button answers “how does Don work?”-style questions from `search.json` (handbook pages ranked first) and links to the matching page. It must not invent live prices or account state.

## i18n and Messaging
- Wiki UI: `wiki/src/i18n.mjs`
- Client CTA keys: `landingFooterAlmanac`, `helpAlmanacOpen`, `helpAlmanacBlurb` in all ARBs.

## When To Update This File
Catalog chapters added/removed, subdomain/port changes, or a decision to expose live prices (should stay no).
