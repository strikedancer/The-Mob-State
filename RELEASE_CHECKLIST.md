# Release Checklist

Gebruik dit bestand om wijzigingen te bundelen en later in 1 productie-deploy uit te rollen.

## Status
- Release mode: **Batched deploy**
- Laatste update: 2026-03-24

## Pending Changes (nog NIET live)

### Backend
- [ ] Fix `untouchable` achievement logica (7 dagen niet busted)
  - Bestand: `backend/src/services/achievementService.ts`
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

### Client (game)
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
1. Upload gewijzigde backend bestanden naar productie.
2. SSH naar API root.
3. Run: `npm run build`
4. Restart API (Plesk Node / PM2 / Docker)

### 2) Client deploy
1. Lokaal run: `flutter build web --release --dart-define=WEB_API_BASE_URL=https://api.themobstate.com`
2. Upload inhoud van `client/build/web` naar game `httpdocs`

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

## Notes
- Bestaande foutief ontgrendelde achievements in DB blijven bestaan totdat handmatig opgeschoond.
- Voeg vanaf nu elke nieuwe wijziging toe onder “Pending Changes”.
