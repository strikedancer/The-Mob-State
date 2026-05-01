# Marketing web (landing, rankings, juridisch)

## Doel
Publieke, game-styled entry voor niet-ingelogde bezoekers (Flutter web), met top-spelers/top-crews en links naar privacy- en digital-goods-beleid. Juridische volledige teksten leven in ARB (git-versiebeheer), entiteit in copy: **The Mob State**.

## Client
- `client/lib/screens/landing_screen.dart` — hero = **ARB-titel** + **ondertitel** (tekst gecentreerd in een **smalle kolom** die op brede schermen **naar rechts inspringt**, zodat copy niet over de grote titel in de achtergrond valt); op smalle breedte een **semi-transparant paneel** rond de copy voor leesbaarheid. **Inloggen / Account** rechtsboven naast elkaar (`FittedBox`). **footer vast onderaan**. Geen Flutter-logo-image in de hero.
- **Publieke rankings:** `GET /public/home` met basis-URL `AppConfig.apiBaseUrl` (apex `themobstate.com` → `api.themobstate.com` zonder dart-define; zie `app_config.dart` + Docker `WEB_API_BASE_URL`).
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
- Cross-origin van `themobstate.com` → `api.themobstate.com`: backend **CORS** (shell-origins + `.env` union in `config/index.ts`; `cors` vóór Prisma in `app.ts` zodat 503’s nog leesbare CORS-headers hebben).
