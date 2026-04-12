# Release Checklist

Gebruik dit bestand om wijzigingen te bundelen en later in 1 productie-deploy uit te rollen.

## Status
- Release mode: **Batched deploy**
- Laatste update: 2026-04-11

## Pending Changes (nog NIET live)

### Backend
- [ ] Register endpoint hardening: expliciete server logging toegevoegd voor `/auth/register` failures + inputvalidatie voor e-mailformat
  - Bestanden: `backend/src/routes/auth.ts`, `backend/src/services/authService.ts`
- [ ] Subscriptions route opgeschoond: dubbele legacy Stripe-tail verwijderd uit Mollie-routebestand om duplicate exports/declarations te voorkomen
  - Bestand: `backend/src/routes/subscriptions.ts`
- [ ] Mollie premium foundation: Stripe checkout-route vervangen door Mollie player/crew VIP + one-time checkout, webhook-fulfillment, payment transaction logging, credits-overview en credit redemption endpoints
  - Bestanden: `backend/src/routes/subscriptions.ts`, `backend/src/services/premiumCreditsService.ts`, `backend/src/app.ts`, `backend/package.json`
- [ ] Premium schema uitgebreid voor Mollie + credits-wallet + entitlements + credit catalogus
  - Bestanden: `backend/prisma/schema.prisma`, `backend/add-mollie-premium-foundation.sql`
- [ ] Hitlist respecteert premium moordbescherming via `hitProtectionExpiresAt`
  - Bestanden: `backend/src/services/hitlistService.ts`, `backend/src/routes/hitlist.ts`
- [ ] Crypto prijs-cron hardening: scheduled price updates gebruiken nu asset-bounds + mean reversion zodat `crypto_assets.current_price` niet meer uit `DECIMAL(24,8)` kan lopen en ontspoorde dev-prijzen automatisch terug binnen bandbreedte worden gezet
  - Bestand: `backend/src/services/cryptoService.ts`
- [ ] Crypto notificatie hardening: in-app crypto world events serialiseren `params` nu als JSON-string zodat price/regime/news/order/mission/leaderboard notificaties geen Prisma schemafouten meer geven
  - Bestand: `backend/src/services/notificationService.ts`
- [ ] Register flow fix: `auth.session.login` world event schrijft `params` nu als JSON-string zodat nieuwe spelerregistratie niet meer 500't na succesvolle player-create
  - Bestand: `backend/src/services/authService.ts`
- [ ] Rechtbank backend geactiveerd: nieuwe `/trial` endpoints voor huidige straf, strafblad, hoger beroep en omkoping, plus compatibele `judgeService` op huidige `crime_attempts`/`jailRelease` model
  - Bestanden: `backend/src/routes/trial.ts`, `backend/src/services/judgeService.ts`, `backend/src/app.ts`
- [ ] Crypto buy/sell fix: `world_events.params` nu als JSON-string opgeslagen zodat trade world events de transactie niet meer rollbacken bij kopen/verkopen
  - Bestand: `backend/src/services/cryptoService.ts`
- [ ] Crypto transaction history fix: `/crypto/transactions` summary gebruikt nu geldige JS aggregatie i.p.v. Dart-achtige `.where().fold()` zodat coin-popup details niet meer 500'en
  - Bestand: `backend/src/services/cryptoService.ts`
- [ ] Vehicle theft uitgebreid: reputatie bij auto/motor/boot diefstal (success/fail/arrest) + response bevat `reputation`; daarnaast motor-diefstal achievements toegevoegd en unlocked feedback in theft response
  - Bestanden: `backend/src/services/vehicleService.ts`, `backend/src/routes/vehicles.ts`, `backend/src/services/achievementService.ts`, `backend/src/utils/rankSystem.ts`
- [ ] Profiel API uitgebreid met gevraagde zichtbare velden: crewnaam, rank, reputatie, status (levend/dood), online-status + tijd sinds laatst gezien, startdatum, VIP, likes, contant geld, bankgeld, aantal hoeren en aantal woningen
  - Bestand: `backend/src/routes/player.ts`
- [ ] Reputatie uitgebreid over modules: crimes + FBI arrest, heists, trade sell-profit, crew join/kick, hitlist claim en police raids; centrale `reputationService` toegevoegd
  - Bestanden: `backend/src/routes/crimes.ts`, `backend/src/routes/heists.ts`, `backend/src/routes/trade.ts`, `backend/src/routes/crews.ts`, `backend/src/routes/hitlist.ts`, `backend/src/services/policeRaidService.ts`, `backend/src/services/reputationService.ts`, `backend/src/utils/rankSystem.ts`
- [ ] Achievement rewards uitgebreid met reputatie-toekenning + NL/EN inboxregel
  - Bestand: `backend/src/services/achievementService.ts`
- [ ] Reputatie-systeem activeren: `calculateReputationChange()` aangeroepen na each crime (gepakt=-10, clean success=+5, failed-niet-gepakt=-2), DB-update via `GREATEST(0, reputation+delta)`, nieuw `reputation` veld in crime-response
  - Bestand: `backend/src/routes/crimes.ts`
- [ ] Profiel API privacy hardening: geen `currentCountry` lekken in publiek profiel + like-statistiek velden toegevoegd (`likesCount`, `viewerHasLiked`)
  - Bestand: `backend/src/routes/player.ts`
- [ ] Profiel endpoint hardening: geldige `playerId` check, 404 bij niet-bestaande speler i.p.v. 500, likes-fallback bij queryfout
  - Bestand: `backend/src/routes/player.ts`
- [ ] Nieuw endpoint: `POST /player/:playerId/profile/like` met 1x-like per spelerpaar
  - Bestanden: `backend/src/routes/player.ts`, `backend/prisma/schema.prisma`, `backend/add-profile-likes.sql`
- [ ] Fix `untouchable` achievement logica (7 dagen niet busted)
  - Bestand: `backend/src/services/achievementService.ts
- [ ] Achievement unlocks loggen als speleractie in admin-overzicht
  - Bestanden: `backend/src/services/achievementService.ts`, `backend/src/services/activityService.ts`
- [ ] Achievement unlocks sturen inbox-bericht met beloning via system-thread
  - Bestanden: `backend/src/services/achievementService.ts`, `backend/src/services/directMessageService.ts`, `backend/src/routes/messages.ts`
- [ ] Register flow: geen auto-login/token meer bij e-mail registratie (verificatie vereist)
  - Bestanden: `backend/src/services/authService.ts`, `backend/src/routes/auth.ts`
- [ ] Login blokkeren voor accounts met onbevestigde e-mail
  - Bestanden: `backend/src/services/authService.ts`, `backend/src/routes/auth.ts`
- [ ] E-mail links via env-config i.p.v. `localhost` (`API_BASE_URL` / `APP_BASE_URL`)
  - Bestanden: `backend/src/services/emailService.ts`, `backend/src/config/index.ts`, `backend/.env.example`
- [ ] Fix tool aankoop 500 (FK `player_tools.toolId`): sync `tools.json` tool naar `crime_tools` vóór aankoop
  - Bestanden: `backend/src/services/toolService.ts`, `backend/src/routes/tools.ts`
- [ ] Startup safeguard: synchroniseer alle tools uit `tools.json` naar `crime_tools` bij service-start
  - Bestand: `backend/src/services/toolService.ts`
- [ ] Jobs endpoint hardening: laat jobs niet falen door nevenfouten (world events/activity/achievement side-effects) + extra route logging
  - Bestanden: `backend/src/services/jobService.ts`, `backend/src/routes/jobs.ts`
- [ ] Systeemfout logging: automatische persistente `system.error` logs via `console.error`/process handlers voor admin inzage
  - Bestanden: `backend/src/services/systemLogService.ts`, `backend/src/index.ts`
- [ ] Admin API: nieuwe endpoints voor system logs en admin account beheer (list/create/update)
  - Bestand: `backend/src/routes/admin.ts`
- [ ] Achievement jobs tellen alleen succesvolle jobs (geen failures) voor unlock criteria
  - Bestand: `backend/src/services/achievementService.ts`
- [ ] Achievement inboxbericht taal consistent gemaakt (geen ENG/NL mix)
  - Bestand: `backend/src/services/achievementService.ts`
- [ ] Onterecht vrijgespeelde job achievements automatisch opschonen op basis van actuele success-only criteria
  - Bestand: `backend/src/services/achievementService.ts`
- [ ] Berichten unread endpoint gestandaardiseerd (`count` + `unreadCount`) voor consistente client badges
  - Bestand: `backend/src/routes/messages.ts`
- [ ] Push notificaties ook voor systeem-thread/inbox berichten
  - Bestand: `backend/src/services/directMessageService.ts`
- [ ] Single-session login enforced: nieuwe login maakt oudere JWT sessies ongeldig
  - Bestanden: `backend/src/services/authService.ts`, `backend/src/middleware/authenticate.ts`
- [ ] Red Light District herstel: idempotente auto-seed toegevoegd voor alle actieve landen zodat lege/missende `red_light_districts` data automatisch wordt aangevuld bij district reads/purchase
  - Bestand: `backend/src/services/redLightDistrictService.ts`

### Client (game)
- [ ] Web asset-path fix: login/rechtbank backgrounds gebruiken weer `assets/images/...` (Flutter bundle key) + nginx-compat alias toegevoegd voor legacy `/assets/images/*` en typo `/assets/image/*` routes
  - Bestanden: `client/lib/screens/login_screen.dart`, `client/lib/screens/court_screen.dart`, `client/docker/nginx.conf`
- [ ] Login background rendering hardened: fallback-keten toegevoegd (`assets/images/...` -> `images/...` -> directe `/assets/images/...` URL -> gradient) zodat mobile login-screen niet meer zwart wordt bij asset-key drift/cache
  - Bestand: `client/lib/screens/login_screen.dart`
- [ ] HTTPS hardening client-nginx: CSP (`upgrade-insecure-requests; block-all-mixed-content`) + HSTS + `X-Content-Type-Options` toegevoegd om mixed-content meldingen te voorkomen
  - Bestand: `client/docker/nginx.conf`
- [ ] Premium kaart voorbereid op Mollie-fase 1: player VIP prijs naar €4,99/mnd en cataloguslabels tonen nu ook credits/event boosts
  - Bestand: `client/lib/screens/crew_screen.dart`
- [ ] Plesk Docker productie-stack toegevoegd: backend, client, admin, MariaDB en Redis draaien via `docker-compose.plesk.yml` met Plesk als reverse proxy/SSL-laag
  - Bestanden: `docker-compose.plesk.yml`, `.env.docker.example`, `backend/Dockerfile`, `client/Dockerfile`, `admin/Dockerfile`
  - Docker fix: backend image verwacht geen gecommit `firebase-service-account.json` meer; Firebase initialisatie blijft optioneel via env/path op runtime.
- [ ] Rechtbank UI compleet gemaakt: echte sentence/record data uit `/trial/*` met acties voor hoger beroep en omkoping, inclusief pull-to-refresh en foutstatussen
  - Bestand: `client/lib/screens/court_screen.dart`
- [ ] Rechtbank UI polish: professionele, beter leesbare layout met cinematic achtergrond (landscape + mobile portrait), contrast-overlay, responsive max-width, partial API rendering en backend-consistente beroep-copy (dynamische kosten + 20-40% reductie)
  - Bestanden: `client/lib/screens/court_screen.dart`, `client/assets/images/backgrounds/courtroom_background.png`, `client/assets/images/backgrounds/courtroom_background_mobile.png`
- [ ] Rechtbank help-content gesynchroniseerd met actuele gameplay (hoger beroep + omkoping, NL/EN parity)
  - Bestand: `client/lib/data/help_content.dart`
- [ ] Drugs productie UX-optimalisatie: bij succesvol ophalen wordt alleen de betreffende actieve productie-card lokaal verwijderd en facility/productie counters op de achtergrond gesynchroniseerd (geen full-screen reload)
  - Bestand: `client/lib/screens/drug_production_screen.dart`
- [ ] Achievements crashfix: `achievementData` parser accepteert nu zowel Map als String payload (incl. single-quote varianten) om TypeError te voorkomen
  - Bestand: `client/lib/models/achievement.dart`
- [ ] Motor-achievement badges genereren via Leonardo API: two_wheel_bandit en bike_cartel (transparante PNG, 1024 source voor mobile/tablet/desktop scherpte)
  - Bestanden: `client/assets/images/achievements/badges/vehicles/two_wheel_bandit.png`, `client/assets/images/achievements/badges/vehicles/bike_cartel.png`, `backend/scripts/generate_motor_achievement_badges_leonardo.py`
- [ ] Spelerprofiel UI toont volledige overzichtsvelden (crew, rank, reputatie, status, online, startdatum, VIP, likes, cash, bank, hoeren, woningen)
  - Bestand: `client/lib/screens/player_profile_screen.dart`
- [ ] Spelerprofiel UI heringedeeld in compacte secties `Identiteit` en `Economie` voor snellere scanbaarheid in embedded bottom sheet
  - Bestand: `client/lib/screens/player_profile_screen.dart`
- [ ] Profiel UI herbouwd naar compacte game-stijl met embedded modus voor contextschermen
  - Bestand: `client/lib/screens/player_profile_screen.dart`
- [ ] Hitlist profielopen werkt als embedded bottom sheet i.p.v. fullpage navigatie
  - Bestand: `client/lib/screens/hitlist_screen.dart`
- [ ] Profiel bevat 1x-like actie voor andere spelers met live tellerweergave
  - Bestand: `client/lib/screens/player_profile_screen.dart`
- [ ] 6 crypto shield badges genereren en valideren via Leonardo.ai API flow (transparante PNG + alpha QA)
  - Bestanden: `generate_crypto_badges_leonardo.py`, `LEONARDO_IMAGE_GENERATION_PROTOCOL.md`
- [ ] Achievement badge asset pad gefixt naar `assets/images/...`
  - Bestand: `client/lib/screens/achievements_screen.dart`
- [ ] Unlock notificaties tonen badge-afbeeldingen met fallback
  - Bestand: `client/lib/utils/achievement_notifier.dart`
- [ ] Registratieflow aangepast voor “verificatie vereist” zonder dashboard redirect
  - Bestanden: `client/lib/services/auth_service.dart`, `client/lib/providers/auth_provider.dart`, `client/lib/screens/login_screen.dart`
- [ ] Inbox system-thread zichtbaar in berichten en niet beantwoordbaar
  - Bestand: `client/lib/screens/chat_screen.dart`
- [ ] Inbox system-thread krijgt visuele achievement/systeem-markering in lijst en chat-header
  - Bestanden: `client/lib/widgets/conversation_card.dart`, `client/lib/screens/chat_screen.dart`
- [ ] Berichten unread badge op avatar toegevoegd (web + mobile topbar)
  - Bestand: `client/lib/screens/dashboard_screen.dart`
- [ ] Dashboard unread teller gebruikt dedicated `/messages/unread` endpoint (sneller/stabieler)
  - Bestand: `client/lib/screens/dashboard_screen.dart`
- [ ] Auth-state logout propagatie verbeterd bij 401/403 (forced logout na sessie-vervanging)
  - Bestanden: `client/lib/services/auth_service.dart`, `client/lib/providers/auth_provider.dart`
- [ ] Admin UI: tab “System Logs” toegevoegd voor runtime backend fouten
  - Bestanden: `admin/src/App.tsx`, `admin/src/services/adminService.ts`
- [ ] Admin UI: “System Logs” uitgebreid met filters op bron + zoekveld (melding/details)
  - Bestand: `admin/src/App.tsx`
- [ ] Admin UI: “System Logs” uitgebreid met datumfilter (24u/7d/30d/all)
  - Bestand: `admin/src/App.tsx`
- [ ] Admin UI: tab “Admins” toegevoegd voor admin aanmaken/rol wijzigen/activeren-deactiveren
  - Bestanden: `admin/src/App.tsx`, `admin/src/services/adminService.ts`

## Deploy Plan (wanneer we live gaan)

### 1) API deploy
1. Push wijzigingen naar GitHub.
2. SSH naar VPS, ga naar repo-root en run: `git pull`
3. Maak `.env` aan op basis van `.env.docker.example` en vul productie-waarden in.
4. Run: `docker compose -f docker-compose.plesk.yml up -d --build`
5. Run: `docker compose -f docker-compose.plesk.yml exec backend npx prisma migrate deploy`

### 2) Client deploy
1. Geen lokale build of FTP meer nodig; client en admin bouwen mee in `docker compose -f docker-compose.plesk.yml up -d --build`.
2. Zet in Plesk reverse proxy targets naar `127.0.0.1:8080` voor `themobstate.com`, `127.0.0.1:3000` voor `api.themobstate.com` en `127.0.0.1:8081` voor `admin.themobstate.com`.

### 3) Post-deploy checks
- [ ] Hard refresh / service worker cache refresh
- [ ] Nieuwe speler test: `untouchable` mag niet direct unlocken
- [ ] Achievement scherm toont custom badges (geen emoji fallback)
- [ ] Achievement unlock popup toont badge image
- [ ] Register met e-mail: géén auto-login, melding om e-mail te verifiëren
- [ ] Verify-link in mail wijst naar `https://api.themobstate.com/auth/verify-email?...`
- [ ] Login vóór verificatie geeft correcte blokkade/melding
- [ ] Tool shop test: `POST /tools/buy/bolt_cutter` geeft geen 500 meer en aankoop slaagt
- [ ] Achievement unlock verschijnt in admin bij “Recente handelingen” met type `ACHIEVEMENT`
- [ ] Achievement unlock maakt inbox-bericht aan met titel/beloning
- [ ] System-thread in berichten is leesbaar maar niet replybaar
- [ ] System-thread toont trophy/system styling in inboxlijst en detailvenster
- [ ] Achievement inbox-bericht start met duidelijke titelregel `🏆 Achievement Unlocked`
- [ ] Jobs test: `POST /jobs/:jobId/work` geeft geen 500 meer door side-effect fouten en retourneert consistente `job.completed` / `job.failed`
- [ ] Admin test: in “System Logs” verschijnen backend fouten met bron/melding/timestamp
- [ ] Admin test: in “System Logs” werken source filter en tekstzoeker op melding/details
- [ ] Admin test: in “System Logs” werkt datumfilter correct voor 24u/7d/30d/all
- [ ] Admin test: als SUPER_ADMIN kan je admin aanmaken, rol wijzigen en account activeren/deactiveren
- [ ] Achievement test: 5-job achievement unlockt niet meer op mislukte jobs
- [ ] Achievement inbox test: bericht bevat consistente taal (geen gemixte labels)
- [ ] Berichtentest: nieuw bericht toont direct unread badge bij menu-item + avatar badge (web en mobile)
- [ ] Push test: nieuw systeem- of direct bericht triggert push notificatie op geregistreerd device
- [ ] Single-session test: inloggen op mobiel terwijl laptop actief is => laptop sessie wordt bij eerstvolgende API-call uitgelogd (`SESSION_REPLACED`)
- [ ] RLD test: `/red-light-districts/country/{currentCountry}` geeft district terug (geen 404 bij verse/lege DB)
- [ ] RLD test: in RLD-scherm verschijnt weer koopoptie voor niet-gekocht district in huidig land
- [ ] Drugs productie test: bij `Ophalen/Collect` verdwijnt alleen de juiste productiecard direct, zonder globale spinner/volledige content reload
- [ ] Register test: `POST /auth/register` geeft token + player terug en maakt geen backend 500 meer na player-create
- [ ] Crypto test: scheduled prijsupdate verwerkt alle assets zonder `Out of range value for column 'current_price'` in backend logs
- [ ] Crypto test: ontspoorde `current_price` waarden worden teruggebracht binnen geloofwaardige asset-bandbreedte en marktdata blijft bruikbaar in crypto-scherm
- [ ] Crypto test: in-app crypto notificaties schrijven geen `Expected String, provided Object` fouten meer naar `world_events.params`
- [ ] Rechtbank test: `/trial/current-sentence` geeft actieve straf terug (of `sentence: null`) zonder 500
- [ ] Rechtbank test: `/trial/record` toont veroordelingenhistorie in UI (ook wanneer speler niet vastzit)
- [ ] Rechtbank test: hoger beroep verwerkt kosten + cooldown en past resterende straf alleen aan bij succes
- [ ] Rechtbank test: omkoping trekt bedrag altijd af en laat speler alleen bij succes direct vrij
- [ ] Rechtbank UI test: nieuwe background + overlay blijft goed leesbaar op mobile en desktop
- [ ] Rechtbank UI test: portrait/landscape wissel kiest automatisch juiste background variant zonder layout regressie

## Notes
- Bestaande foutief ontgrendelde achievements in DB blijven bestaan totdat handmatig opgeschoond.
- Voeg vanaf nu elke nieuwe wijziging toe onder “Pending Changes”.
- Protocol bootstrap uitgevoerd voor nieuw betaalsysteem: `docs/module-protocols/payments.md` toegevoegd en index/master geüpdatet.
- Lokale QA uitgevoerd op 2026-04-11 (dev):
  - `/trial/current-sentence` gaf zowel `sentence: null` (niet vast) als actieve sentence zonder 500.
  - `/trial/record` gaf stabiele payload met historiekvelden.
  - `POST /trial/appeal` verwerkte kosten en gaf cooldown blokkade op directe retry (`429`).
  - `POST /trial/bribe` gaf zowel success- als failure-uitkomst en saldo daalde in beide paden.
  - Web build validatie: beide courtroom backgrounds gebundeld in output (`courtroom_background.png` + `courtroom_background_mobile.png`).
- Lokale QA uitgevoerd op 2026-04-11 (payments foundation):
  - `npx prisma validate` en `npx prisma generate` succesvol na Mollie/credits schema-uitbreiding.
  - `npm run build` succesvol voor backend na vervanging van Stripe-route door Mollie-route.
  - Runtime payment-flow nog niet end-to-end geverifieerd tegen Mollie webhook omdat dit een geldige `MOLLIE_API_KEY` en publiek bereikbare `MOLLIE_WEBHOOK_URL` vereist.
- Deployment basis voorbereid voor Plesk + Docker zonder FTP-workflow; domeinen kunnen nu via Plesk reverse proxy naar localhost-containers wijzen.
