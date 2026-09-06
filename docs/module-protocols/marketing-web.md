# Marketing web (landing, rankings, juridisch)

## Doel
Publieke, game-styled entry voor niet-ingelogde bezoekers (Flutter web), met top-spelers/top-crews en links naar privacy- en digital-goods-beleid. Juridische volledige teksten leven in ARB (git-versiebeheer), entiteit in copy: **The Mob State**.

## Client
- `client/lib/screens/landing_screen.dart` — hero = **ARB-titel** + **ondertitel** (tekst gecentreerd in een **smalle kolom** die op brede schermen **naar rechts inspringt**, zodat copy niet over de grote titel in de achtergrond valt); op smalle breedte een **semi-transparant paneel** rond de copy voor leesbaarheid. **Inloggen / Account** rechtsboven naast elkaar (`FittedBox`): ze openen een **modal dialog** met het gedeelde auth-scherm (`LoginScreen`, `embeddedModal`) i.p.v. naar `/login` of `/register` te pushen. Na geslaagde login sluit die dialog automatisch (ook op mobiel); het kruisje is alleen nodig om te annuleren. **footer vast onderaan**. Geen Flutter-logo-image in de hero.
- **Publieke rankings:** `GET /public/home` met basis-URL `AppConfig.apiBaseUrl` (apex `themobstate.com` / `themobstate.nl` → `api.themobstate.com` zonder dart-define; zie `app_config.dart` + Docker `WEB_API_BASE_URL`).
- `client/lib/main.dart` — `_resolveHome` + `routes` voor `/`, `/login`, `/register`, `/privacy`, `/terms`, `/digital-goods`; `AuthWrapper` toont `LandingScreen` zonder sessie.
- `client/lib/providers/locale_provider.dart` — `initGuestLocale`, `persistGuestLocale` (geen `PUT /player/language` voor gasten).

## Backend
- `backend/src/routes/publicMarketing.ts` — `GET /public/home` (read-only, geen auth), rate limit.
- `backend/src/app.ts` — router op `/public`; SPA-fallback: GET naar onbekende niet-API-paden levert `client/build/web/index.html` wanneer aanwezig (deep links). Gebruik `app.use` met GET-gate i.p.v. `app.get('*', …)` (Express 5 / path-to-regexp v8).

## i18n
- Keys: `landing*` (o.a. `landingFooterTerms`), `legalPrivacy*`, `legalTerms*`, `registerTerms*` (registratie-akkoord), `legalDigitalGoods*` in alle `app_*.arb`-bestanden.
- Na nieuwe keys: `node scripts/merge_arb_missing_all_from_en.mjs`, eventueel `node scripts/translate_arb_english_fallback.mjs --langs=de,fr,es,it,pl,pt --prefix=landing,legalPrivacy,legalTerms,registerTerms,legalDigitalGoods`, daarna `flutter gen-l10n` en `node scripts/verify_arb_parity.mjs`.

## QA (kort)
- Footer-links privacy / terms / digital goods openen een **modal** (zelfde ARB-tekst als de routes). Deep links `/privacy`, `/terms`, `/digital-goods` laden nog steeds **volledige** juridische schermen; gasttaal wisselt mee.
- Zonder token: `/public/home` retourneert JSON; geen e-mail of andere PII in het payload.
- Cross-origin van `themobstate.com` of `themobstate.nl` → `api.themobstate.com`: backend **CORS** (shell-origins + `.env` union in `config/index.ts`; `cors` vóór Prisma in `app.ts` zodat 503’s nog leesbare CORS-headers hebben).
