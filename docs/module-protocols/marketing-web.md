# Marketing web (landing, rankings, juridisch)

## Doel
Publieke, game-styled entry voor niet-ingelogde bezoekers (Flutter web), met top-spelers/top-crews en links naar privacy- en digital-goods-beleid. In-game juridische teksten leven in ARB; `/privacy` en `/terms` zijn daarnaast statische HTML voor crawlers. Entiteit in copy: **The Mob State**.

## Client
- `client/lib/screens/landing_screen.dart` — hero = **ARB-titel** + **ondertitel** (tekst gecentreerd in een **smalle kolom** die op brede schermen **naar rechts inspringt**, zodat copy niet over de grote titel in de achtergrond valt); op smalle breedte een **semi-transparant paneel** rond de copy voor leesbaarheid. **Inloggen / Account** rechtsboven naast elkaar (`FittedBox`): ze openen een **modal dialog** met het gedeelde auth-scherm (`LoginScreen`, `embeddedModal`) i.p.v. naar `/login` of `/register` te pushen. Na geslaagde login sluit die dialog automatisch (ook op mobiel); het kruisje is alleen nodig om te annuleren. **footer vast onderaan**. Geen Flutter-logo-image in de hero.
- **Facebook Login (web):** knop op login/register als `GET /auth/facebook/status` `loginEnabled` is. OAuth verlaat de pagina naar Facebook en landt terug op `/login?fb=ok|pending|error` (niet in de landing-modal). Nieuwe Facebook-spelers ronden username/gender/voorwaarden af op dat scherm. Details: `facebook.md`.
- **Google Sign-In (web):** zelfde patroon via `GET /auth/google/status` en terugkomst op `/login?g=ok|pending|error`. Details: `google.md`.
- **Discord Sign-In (web):** zelfde patroon via `GET /auth/discord/status` en terugkomst op `/login?d=ok|pending|error`. Community-invite via `GET /public/community` / `data.discordInviteUrl` op `/public/home`. Details: `discord.md`.
- **Publieke rankings:** `GET /public/home` met basis-URL `AppConfig.apiBaseUrl` (apex `themobstate.com` / `themobstate.nl` → `api.themobstate.com` zonder dart-define; zie `app_config.dart` + Docker `WEB_API_BASE_URL`).
- `client/lib/main.dart` — `_resolveHome` + `routes` voor `/`, `/login`, `/register`, `/privacy`, `/terms`, `/digital-goods`; `AuthWrapper` toont `LandingScreen` zonder sessie. Query `?ref=` op `/`, `/login` of `/register` wordt bewaard tot registratie (deel-link). Zie [referrals.md](referrals.md).
- `client/lib/providers/locale_provider.dart` — pre-init default is **`en`** (geen NL-flash voor internationale gasten). `initGuestLocale` / `persistGuestLocale` winnen daarna (browser of opgeslagen keuze; geen `PUT /player/language` voor gasten).
- Landing hero: korte first-hour hook (`landingHeroSubtitle`) plus fair-play regel (`landingFairPlay`: VIP verkort wachttijden, koopt geen winst).

## Backend
- `backend/src/routes/publicMarketing.ts` — `GET /public/home` (read-only, geen auth), rate limit. Elke hit telt een bezoek (`site_visitors`: totaal hits + unieke IP). Admin dashboard toont die cijfers plus een IP-tabel.
- `backend/src/app.ts` — router op `/public`; SPA-fallback: GET naar onbekende niet-API-paden levert `client/build/web/index.html` wanneer aanwezig (deep links). Gebruik `app.use` met GET-gate i.p.v. `app.get('*', …)` (Express 5 / path-to-regexp v8).

## i18n
- Keys: `landing*` (o.a. `landingFooterTerms`, `landingFooterDiscord`), `discord*`, `legalPrivacy*`, `legalTerms*`, `registerTerms*` (registratie-akkoord), `legalDigitalGoods*` in alle `app_*.arb`-bestanden.
- Na nieuwe keys: `node scripts/merge_arb_missing_all_from_en.mjs`, eventueel `node scripts/translate_arb_english_fallback.mjs --langs=de,fr,es,it,pl,pt --prefix=landing,legalPrivacy,legalTerms,registerTerms,legalDigitalGoods,discord`, daarna `flutter gen-l10n` en `node scripts/verify_arb_parity.mjs`.

## QA (kort)
- Op telefoon/tablet toont de landing een **PWA-banner** (ARB `pwaInstall*`) om de site als app-icoon op het beginscherm te zetten. Chrome opent het install-sheet; iOS toont stappen. Zie `frontend-platform.md`.
- Footer-links privacy / terms / digital goods openen een **modal** (ARB). **Almanak** opent `https://wiki.themobstate.com/{lang}/` in een nieuw tabblad. **Discord** opent de permanente invite (`DISCORD_INVITE_URL`) wanneer gezet. Deep links `/privacy` en `/terms` zijn **statische HTML** (`client/web/seo/privacy.html`, `terms.html`) zodat Meta-crawlers de tekst zien. **SEO-landings** `/{lang}/text-based-mafia-game` (NL zonder prefix) noemen de appnaam + text-based mafia game; generator `scripts/generate_seo_landings.mjs`. `/digital-goods` blijft het Flutter-scherm; gasttaal wisselt mee.
- Zonder token: `/public/home` retourneert JSON; geen e-mail of andere PII in het payload.
- Cross-origin van `themobstate.com` of `themobstate.nl` → `api.themobstate.com`: backend **CORS** (shell-origins + `.env` union in `config/index.ts`; `cors` vóór Prisma in `app.ts` zodat 503’s nog leesbare CORS-headers hebben).
