# Marketing web (landing, rankings, juridisch)

## Doel
Publieke, game-styled entry voor niet-ingelogde bezoekers (Flutter web), met top-spelers/top-crews en links naar privacy- en digital-goods-beleid. Juridische volledige teksten leven in ARB (git-versiebeheer), entiteit in copy: **The Mob State**.

## Client
- `client/lib/screens/landing_screen.dart` — hero met **logo** (`assets/images/logo.png`, web-fallbacks), **ondertitel direct onder het logo**, **Inloggen / Account** rechtsboven, scrollbare middenkolom (about + rankings), **footer vast onderaan** (privacy, digital goods, taal, copyright; niet in de scroll).
- Publieke rankings: `GET /public/home` (client: `AppConfig.apiBaseUrl`).
- `client/lib/main.dart` — `_resolveHome` + `routes` voor `/`, `/login`, `/register`, `/privacy`, `/digital-goods`; `AuthWrapper` toont `LandingScreen` zonder sessie.
- `client/lib/providers/locale_provider.dart` — `initGuestLocale`, `persistGuestLocale` (geen `PUT /player/language` voor gasten).

## Backend
- `backend/src/routes/publicMarketing.ts` — `GET /public/home` (read-only, geen auth), rate limit.
- `backend/src/app.ts` — router op `/public`; SPA-fallback: GET naar onbekende niet-API-paden levert `client/build/web/index.html` wanneer aanwezig (deep links).

## i18n
- Keys: `landing*`, `legalPrivacy*`, `legalDigitalGoods*` in alle `app_*.arb`-bestanden.
- Na nieuwe keys: `node scripts/merge_arb_missing_all_from_en.mjs`, eventueel `node scripts/translate_arb_english_fallback.mjs --langs=de,fr,es,it,pl,pt --prefix=landing,legalPrivacy,legalDigitalGoods`, daarna `flutter gen-l10n` en `node scripts/verify_arb_parity.mjs`.

## QA (kort)
- Deep link `/privacy` laadt juridisch scherm; gasttaal wisselt mee.
- Zonder token: `/public/home` retourneert JSON; geen e-mail of andere PII in het payload.
