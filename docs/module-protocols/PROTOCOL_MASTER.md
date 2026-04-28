# Master Protocol (Single Attachment)

Gebruik dit bestand als enige protocol-bijlage in nieuwe taken.

Doel:
- 1 bestand toevoegen in Copilot
- Vanuit 1 startpunt alle relevante protocollen verplicht meenemen
- Consistente QA, i18n en data-contract checks afdwingen

## Standaard Workflow

1. Voeg alleen dit bestand toe: `docs/module-protocols/PROTOCOL_MASTER.md`.
2. Bepaal welke module(s) primair geraakt worden.
3. Open verplicht alle bijbehorende module-protocollen uit `docs/module-protocols/`.
4. Doe een cross-module impact scan en open ook alle afhankelijke protocollen.
5. Voer QA uit op primaire en afhankelijke modules.
6. Als gedrag voor spelers verandert: update help-content en release-notes.
7. **Afronding (code + docs wijzigen):** commit, push en bij live/VPS de standaard deploy (zie *Commit/Push/Deploy Standaardflow* hieronder). De AI-agent wacht hier niet op een aparte opdracht tenzij jij expliciet lokaal-only vroeg; projectregel staat in `.cursor/rules/commit-push-deploy.mdc`.

## Verplichte Protocol-Resolutie

Dit bestand is de enige bijlage, maar niet de enige bron.

Verplichte regel:
- Bij elke taak moeten alle relevante module-protocollen gelezen worden, inclusief afhankelijkheden.
- Bij nieuwe systemen of modules is het verplicht om actief alle bestaande protocollen te scannen op mogelijke koppelingen, afhankelijkheden, overlap en regressierisico's; een nieuw systeem is niet klaar zonder expliciete protocol-impactcheck.
- Bij elke wijziging aan progression, economy, rewards, cooldowns, premium credits of monetization is `docs/module-protocols/balance-economy.md` verplicht en mag deze nooit worden overgeslagen.
- Bij elke wijziging aan gameplay loops, cooldowns, economy, notifications, crew/ops-systemen of nieuwe module-acties is `docs/module-protocols/dashboard.md` verplicht en moet dashboard-impact expliciet worden gecontroleerd (API + UI + Help & Uitleg).

Minimum output bij implementatie:
- Noem welke protocollen zijn toegepast.
- Noem welke cross-module checks uitgevoerd zijn.
- Bevestig expliciet dat alle nieuwe en gewijzigde tekst, labels, meldingen en flows meertalig zijn uitgewerkt (minimaal NL + EN).
- Bevestig expliciet dat `Help & Uitleg` is gecontroleerd en waar nodig is bijgewerkt voor de wijziging of nieuwe module.

## Nieuw Systeem: Auto Protocol Bootstrap (Verplicht)

Bij elk nieuw systeem of nieuwe module moet direct een protocol worden aangemaakt en gekoppeld.

Verplichte acties:
1. Maak een nieuw protocolbestand in `docs/module-protocols/` op basis van `PROTOCOL_TEMPLATE.md`.
2. Voeg het nieuwe protocol toe aan de index in `docs/module-protocols/README.md`.
3. Update in dit bestand de Cross-Module Dependency Map als er nieuwe koppelingen zijn.
4. Loop actief alle bestaande relevante protocollen langs om te controleren welke modules of cross-cutting regels door het nieuwe systeem geraakt kunnen worden en welke regressies voorkomen moeten worden.
5. Controleer of `Help & Uitleg` voor het nieuwe systeem of de nieuwe module moet worden uitgebreid en werk dit direct mee bij.
6. Vermeld in de delivery-output dat protocol bootstrap is uitgevoerd en welke protocol-koppelingen zijn nagekeken.

Acceptatie-eis:
- Een nieuw systeem is niet "done" zonder bijbehorend protocol en index-verwijzing.
- Een nieuw systeem is niet "done" zonder expliciete controle van protocol-koppelingen en regressierisico's voor bestaande modules.

## Cross-Module Dependency Map (Minimaal)

- Drugs -> Facilities, Production, Inventory, Dashboard, Admin
- Properties -> Drugs, Dashboard, Admin
- Nightclub -> Drugs, Prostitution, Dashboard, Admin
- Territory -> Crew, Crew Wars, Dashboard, Notifications, Travel, Admin
- Crimes/Vehicle Theft -> Garage, Inventory, Prison, Security, Court, Crew, Friends, Notifications, Admin
- Hitlist -> Crimes, Security, Crew, Dashboard, Admin
- Crew Wars -> Crew, Hitlist, Crimes, Dashboard, Notifications, Payments, Achievements, Admin
- Crew Missions -> Crew, Crew Wars, Territory, Crimes, Jobs, Travel, Notifications, Payments, Inventory, Admin
- Payments/Premium -> Crew, Hitlist/Security, Garage, TuneShop, Events, Dashboard, Admin
- Economy/Progression wijzigingen -> Balance & Economy, Payments, Crimes, Hitlist, Dashboard, Admin
- Travel -> Properties, Drugs, Nightclub, Smuggling, Admin
- Admin -> Alle gameplay modules met logs, assets of economy-impact
- Player-facing lists/avatars/namen -> Player Profile
- Flutter Web/Mobile/PWA shell behavior -> Frontend Platform, Notifications

## Wat Hier Wel En Niet Hoort

Dit bestand is de orchestrator, niet de detail-specificatie van een module.

Wel hier houden:
- workflow voor protocol-resolutie
- cross-module dependency map
- generieke backend-, QA-, i18n- en UX-guardrails die voor meerdere modules gelden
- regels voor het aanmaken en koppelen van nieuwe protocollen

Niet hier houden:
- module-specifieke lifecycle-regels
- scherm-specifieke UX-beslissingen
- endpoint- of datacontractdetails van één feature
- tijdelijke projectbesluiten die al een logische plek hebben in een module-protocol

Voorbeelden:
- Support workflow-regels horen in `support-tickets.md`
- Security lifecycle-regels horen in `security.md`
- Player profile/privacy/navigation regels horen in `player-profile.md`
- Flutter/web/mobile/PWA shell-, asset- en cache-regels horen in `frontend-platform.md`
- Push/inbox/service-worker regels horen in `notifications.md`
- Dashboard/Properties/Nightclub/Drugs details horen in hun eigen module-protocol

Als een wijziging meerdere modules raakt, lees en combineer je nog steeds alle relevante module-protocollen tegelijk.

## Verplicht Bij Backend Wijzigingen

- Controleer Prisma relaties bij nested includes.
- Controleer dat alle queryvelden echt in schema staan.
- Als een module (tijdelijk) losse SQL-updates buiten Prisma migraties gebruikt, borg dan dat productie die schema-stap ook echt uitvoert (startup bootstrap of expliciete deploy-stap), anders lokaal/online drift met 500-fouten.
- Als route/state data in `String`-kolommen wordt opgeslagen (zoals travel routes), serialiseer/parset dit expliciet als JSON om runtime type-drift tussen lokaal en productie te voorkomen.
- Als geschiedenis-, feed- of transactieschermen hun data uit gelogde events lezen, moet event-payload parsing expliciet en consistent gebeuren en moeten lijstdata en samenvattingstellers op dezelfde bronlogica gebaseerd zijn; voorkom dat JSON-string payloads stilzwijgend als object worden behandeld of dat tellers een ander beeld geven dan de lijst.
- Log interne fouten met context op kritieke auth-routes (`/auth/register`, `/auth/login`) zodat productie-500's direct herleidbaar zijn.
- Log auth-401 redenen met routecontext op sessie-kritieke endpoints zoals `/player/me`, zodat spontane logout-meldingen achteraf herleidbaar zijn naar `TOKEN_EXPIRED`, `SESSION_REPLACED`, `INVALID_TOKEN` of ontbrekende credentials.
- Auth recovery-flows zijn pas done als zowel de aanvraagstap als de vervolgroute echt werken: een `forgot password` scherm mag geen fake succes simuleren, moet de echte backend-endpoint aanroepen, en reset-/verify-links uit e-mail moeten op web/mobile naar een afhandelbaar scherm of route landen.
- Auth/session handling mag spelers alleen lokaal uitloggen bij expliciete auth-redenen zoals `TOKEN_EXPIRED`, `INVALID_TOKEN`, `SESSION_REPLACED` of ontbrekende credentials; tijdelijke `/player/me` netwerk- of backendfouten mogen een geldige sessie niet stil weggooien.
- Draai Prisma checks:
  - `npx prisma validate`
  - `npx prisma generate`
- Test exact de endpoints die door het scherm worden gebruikt.

Extra harde eis:
- Geen `PrismaClientValidationError` in backend logs na wijziging.

## Verplicht Bij Dashboard / Multi-API Schermen

- Laat 1 falende API-call niet het hele scherm leeg maken.
- Gebruik fallbacks (`[]`, `{}`, `null`) of aparte try/catch per kritieke sectie.
- Verifieer dat kerninformatie zichtbaar blijft (bijv. actieve producties, eigendom, timers).
- Admin diagnose- en logschermen die tijdens live QA gebruikt worden, moeten korte tijdvensters (zoals 1 uur) en gerichte clear-acties voor de huidige filterselectie ondersteunen zodat regressies zonder ruis van oudere testlogs beoordeeld kunnen worden.
- Voor web dashboard-navigatie is de sidebar-sectie (`_buildWebMenuItems` + `_WebSection` switch in `dashboard_screen.dart`) de primaire en leidende bron; wijzigingen aan zichtbare modules moeten daar altijd worden doorgevoerd.
- Het oude tegel-grid geldt als legacy/fallback en is niet leidend voor web-navigatie; alleen een tegel toevoegen zonder sidebar-update geldt niet als done.

Implementatievoorkeur:
- Gebruik partial rendering boven "alles of niets" loading.

## i18n en UX Basisregels

- Multilanguage is een harde eis voor alles wat nieuw wordt gemaakt of aangepast en tekst of UX-signalen bevat (minimaal NL + EN).
- Daarnaast ondersteunt de **player client** een uitbreidbare set **Europese UI-talen** (codes en allowlist staan centraal in `client/lib/config/supported_languages.dart` + `backend/src/config/supportedLanguages.ts`). Nieuwe talen: ARB-key-pariteit met `app_en.arb`, `flutter gen-l10n`, allowlist uitbreiden, en (totdat er echte vertaling is) mogen stringwaarden tijdelijk gelijk zijn aan EN.
- E-mail- en sommige server-side templates kunnen nog beperkt zijn tot **NL + EN**; andere voorkeurstalen vallen terug op **EN** totdat `translationService` wordt uitgebreid (zie `docs/l10n-migration.md`).
- Geen enkele wijziging is "done" als nieuwe of gewijzigde labels, knoppen, foutmeldingen, succesmeldingen, dialogs, help-content, notificaties of admin/player UI-tekst maar in 1 taal aanwezig zijn (minimaal NL + EN; voor elke **officieel geactiveerde** extra UI-taal geldt dezelfde volledigheid voor nieuwe/gewijzigde keys in de ARB’s).
- Nieuwe features en refactors mogen geen bestaande NL/EN pariteit breken; werk ontbrekende vertalingen direct mee bij in dezelfde wijziging.
- Bij aanpassingen of nieuwe modules is het verplicht om te controleren of `Help & Uitleg` nog klopt; als player-gedrag, flows, uitleg of terminologie verandert, moet de help-content in dezelfde wijziging worden bijgewerkt.
- NL en EN tekst altijd synchroon houden (en elke andere **actieve** ARB-locale synchroon qua keys met `app_en.arb`).
- Geen regressies op mobiel, tablet, desktop.
- Alle nieuwe en aangepaste overlays, dialogs, modals en full-screen lock states moeten expliciet responsive zijn voor mobiel, tablet en desktop; vaste breedtes/hoogtes zonder clamp, scrollfallback of safe-area-afhandeling gelden niet als done.
- Gebruik voor gedeelde overlays/dialogs een centraal responsive patroon of helper in plaats van losse one-off layoutlogica per scherm.
- Op mobiel mag een sticky topbar of statusheader blijven staan, maar daaronder moet player-facing content altijd via precies één primaire verticale scrollflow bruikbaar blijven; losse ingebedde scrollvensters of verborgen inner-scrollgebieden gelden niet als done.
- Duidelijke feedback voor succes/foutstatus behouden.
- Geen kritieke actieknoppen verstoppen achter hover-only styling.
- Bij lange beheerpagina's: groepeer secties in tabs i.p.v. eindeloze verticale stapels.
- Gebruik waar mogelijk visuele selectiekaarten (images) voor entities zoals staff/items; altijd met icon-fallback.
- Gebruik responsive/clamped hoogtes voor tabpanelen i.p.v. één vaste hoogte.
- In overlays/dialogs moeten info- en statistiekblokken altijd leesbaar blijven met expliciete contrastborging (achtergrond, border en tekstkleur), onafhankelijk van light/dark theme of transparante/glass achtergronden.
- Bij member-gebonden systemen met lifecycle-events moet notificatiedekking expliciet worden gevalideerd voor alle betrokken gebruikers, inclusief leiders/eigenaren waar van toepassing; handmatige admin-acties en automatische statusovergangen mogen geen stille bypass vormen voor push of inbox.
- Voor cross-cutting Flutter/web/mobile/PWA shell-, asset- en embedded-view regels: zie `frontend-platform.md`.
- Voor push-, inbox- en FCM/service-worker regels: zie `notifications.md`.
- Voor profielprivacy, profielnavigatie en profielinteracties: zie `player-profile.md`.
- Bij wijzigingen aan web/PWA deploy, nginx caching, service workers of push bootstrap moet de QA expliciet beide service workers meenemen: `flutter_service_worker.js` én `firebase-messaging-sw.js`; een deploy is niet done als één van beide nog onder stale/immutable caching kan vallen.

## Minimale QA Checklist (Altijd Draaien)

1. Happy flow van de wijziging (succespad).
2. Minimaal 1 foutpad of locked state.
3. Refresh/navigatie terug en check of state correct blijft.
4. Controle op mobile en desktop layout.
5. Backend logs checken op runtime errors tijdens die flow.
6. Verifieer cross-module gedrag (minimaal 1 gekoppelde module testen).
7. Verifieer dat Admin/logging de wijziging correct weergeeft als die module-impact heeft.
8. Verifieer dat alle nieuwe/gewijzigde player-facing teksten in NL en EN aanwezig zijn, en voor elke andere **actieve** ARB-locale dat dezelfde keys aanwezig zijn (pariteit met `app_en.arb`; `node scripts/verify_arb_parity.mjs`).
9. Verifieer dat `Help & Uitleg` nog klopt voor de gewijzigde of nieuw toegevoegde module/flow.
10. Bij nieuwe systemen of modules: bevestig dat alle relevante bestaande protocollen op koppelingen en regressierisico's zijn nagelopen.
11. Bij economy/progression/monetization wijzigingen: bevestig expliciet dat `balance-economy.md` is toegepast en dat telemetry + runtime keys zijn meegecontroleerd.
12. Bij module-uitbreidingen met nieuwe acties/timers/rewards: bevestig expliciet dat dashboarddekking is bijgewerkt of bewust niet van toepassing is (met reden), inclusief NL/EN helptekst.

## Flutter Analyze Hang Recovery (Windows)

Als `flutter analyze` of `dart analyze` blijft hangen zonder output:

1. Stop alle oude Flutter/Dart processen.
2. Verwijder lokale analyzer state in `client/.dart_tool/`.
3. Run `flutter pub get` opnieuw in `client/`.
4. Run daarna gericht: `flutter analyze --no-pub lib/...`.
5. Als de terminal nog blijft hangen: gebruik de VS Code Problems-validatie als tijdelijke fallback en log dit in de release-checklist notes.

Doel:
- Voorkom dat één vastgelopen analyzer-run QA blokkeert.

## Bronnen

- Centrale index: `docs/module-protocols/README.md`
- Moduleprotocollen: `docs/module-protocols/*.md`
- **Live spelerevents (presets, deploy-checklist, dashboard, push):** `docs/module-protocols/events.md` — verplicht lezen bij taken die `gameEventService`, cron, Mollie Event Pass, dashboard-events of FCM-broadcasts raken.

## AI Keys & One-Shot Leonardo Workflow (Lokaal + VPS)

Basisregels:
- Gebruik altijd key `LEONARDO_API_KEY`.
- Commit nooit API keys in repository-bestanden.
- Generatie-scripts met `*leonardo*` lezen eerst runtime env vars en daarna fallback env files.

Ondersteunde env bronnen (in volgorde):
1. Proces environment (`LEONARDO_API_KEY` al gezet in shell/container)
2. `.env.local`
3. `.env` (project root)
4. `backend/.env`
5. `.env.docker`

Lokale Leonardo-key voor scripts (`generate_*leonardo*.py`): zet die in **`backend/.env.local`** (gitignored via `.env.*`). Nooit in getrackte Markdown, issues of chat plakken als je hem als productiesecret beschouwt; roteer na lekken.

### VPS Docker Compose standaard (aanbevolen)

Voor productie/VPS runs hoort de key via compose naar de backend-container te gaan.

Verplicht:
- Voeg `LEONARDO_API_KEY=${LEONARDO_API_KEY}` toe aan backend `environment` in `docker-compose.plesk.yml`.
- Zet de echte waarde in een server-side env-bestand dat niet in git staat, bij voorkeur `.env.plesk`, en gebruik dat bestand expliciet via `docker compose --env-file .env.plesk -f docker-compose.plesk.yml ...`.
- Productiesecrets of service-account payloads mogen nooit inline in een getrackte `docker-compose.plesk.yml` blijven staan; tracked compose-files zijn alleen voor placeholders en variabeleverwijzingen.

One-shot runbook (volgende keer in 1 keer uitvoeren):
1. `git pull origin main`
2. Verifieer key aanwezigheid: `docker compose config | Select-String LEONARDO_API_KEY`
3. Herstart backend met nieuwe env: `docker compose restart backend`
4. Run generator in backend-context (waar env beschikbaar is)
5. Controleer dat alle doelbestanden zijn gegenereerd (8/8 voor school narcotics set)
6. Doe pas daarna de smoke test van de school/drugs flow

### PuTTY / Plesk Update Runbook (Verplicht)

Als de gebruiker vraagt om "geef command voor PuTTY om te updaten" op de VPS/Plesk stack, gebruik dan voortaan deze veilige standaardvolgorde en wijk daar niet licht van af:

1. Maak eerst server-backups van `docker-compose.plesk.yml` en `.env.plesk`.
2. Doe `git pull origin main` voordat secrets of compose-regels handmatig worden aangepast.
3. Houd secrets uitsluitend in server-side `.env.plesk`, nooit inline in `docker-compose.plesk.yml`.
4. Valideer altijd eerst met `docker compose --env-file .env.plesk -f docker-compose.plesk.yml config`.
5. Rebuild daarna alleen de doelservice (`backend`, `client` of `admin`) met `--no-deps` waar passend, niet direct de hele stack als dat niet nodig is.
6. Controleer direct de service-logs na deploy en bevestig expliciet de verwachte bootstrapregel bij kritieke integraties zoals Firebase Admin.
7. Als een oude `.env` nog op de server staat na migratie naar `.env.plesk`, hernoem die naar een backupbestand zodat operators niet per ongeluk zonder `--env-file .env.plesk` blijven deployen.

Standaardcommandoblok voor backend-updates via PuTTY:

```bash
cd /var/www/vhosts/themobstate.com/apps/mafia_game
cp docker-compose.plesk.yml docker-compose.plesk.yml.bak-$(date +%F-%H%M)
cp .env.plesk .env.plesk.bak-$(date +%F-%H%M)
git pull origin main
docker compose --env-file .env.plesk -f docker-compose.plesk.yml config
docker compose --env-file .env.plesk -f docker-compose.plesk.yml up -d --build --no-deps backend
docker compose --env-file .env.plesk -f docker-compose.plesk.yml logs --tail=120 backend
```

Acceptatie-eis voor dit runbook:
- Een PuTTY update-instructie is niet done zonder expliciete `--env-file .env.plesk` compose-commands.
- Een productie-update is niet done zonder config-validatie en post-deploy logcheck.

### VPS snelpad (Windows: Pageant + PuTTY plink) — aanbevolen

Gebruik dit **volgende keer eerst**; het voert dezelfde stappen uit als het bash-blok hierboven (backup compose + `.env.plesk`, `git pull`, `docker compose … config`, rebuild **backend** + **client**, backend-logs), maar dan **vanaf je Windows-pc** via **PuTTY `plink`** met je opgeslagen sessie.

**Voorwaarden**

1. **Pageant** draait en je private key is geladen.
2. PuTTY **Saved Session** exact zoals opgeslagen (vaak **`server vps`**; niet verwarren met een andere naam).
3. SSH-login **`root`** (script zet **`-l root`**; sessie mag leeg Auto-login user hebben).
4. Eerste keer of na hostkey-wissel: één keer **interactief** dezelfde sessie in PuTTY openen zodat host key / proxy akkoord staat; daarna werkt het ook vanuit **PowerShell** / agent.
5. Voer deploy uit in een **normaal PowerShell-venster** (niet elke geïsoleerde terminal geeft prompts goed door).

**Eén commando (lokaal, vanuit repo-root)**

```powershell
cd C:\xampp\htdocs\mafia_game
.\scripts\vps_pull_and_build.ps1 -PuttySession "server vps"
```

- Standaard projectpad op de VPS: `/var/www/vhosts/themobstate.com/apps/mafia_game` (aanpasbaar met `-ProjectDir`).
- Als `HostName` niet uit de PuTTY-registry te lezen is: `-SshHost "jouw.host.of.ip"`.
- Script gebruikt **geen** `plink -batch`, zodat **HTTP-proxy- of andere PuTTY-prompts** beantwoord kunnen worden.

**Crew-mission / externe images** naar dezelfde mount als compose (`CLIENT_EXTERNAL_IMAGES_PATH` → `runtime/client-images` op de server):

```powershell
.\scripts\upload_crew_mission_images_to_vps.ps1 -PuttySession "server vps"
```

Zie ook: `docs/game-systems/CREW_MISSIONS_EXPANSION_2026-04-26.md` (paden + uitleg).

**Crew mission kaarten (zelfde afbeelding bug):** ontbrekende `images/crew_missions/cards/<key>.png` op de externe mount laat de client op de **default** fallback in `_crewMissionFallbackImagePath` vallen — daardoor zagen meerdere nieuwe missies dezelfde plaat. Oplossing: (1) PNG’s genereren met `backend/scripts/generate_crew_missions_images_leonardo.py` (`LEONARDO_API_KEY`), (2) uploaden met `scripts/upload_crew_mission_images_to_vps.ps1`, (3) per nieuwe `missionKey` een eigen fallback in `crew_screen.dart` tot de assets live staan (zie `crew-missions.md` Image Pipeline).

**Agent / Cursor**

- Zelfde PowerShell-aanroep kan vanuit de agent **als** Pageant op die machine draait en netwerk/proxy het toelaten.
- **`docker compose … config`** schrijft resolved env naar stdout — **deel die log-output niet** (bevat secrets). Bij twijfel alleen `logs --tail` delen of lokaal bekijken.

### Live Online Test Workflow (Verplicht Bij VPS-Only QA)

Als de actuele bron van waarheid online/VPS is en niet lokaal, dan hoort de agent na relevante codewijzigingen niet te stoppen bij alleen lokale edits of een commit.

Verplicht workflowpatroon:
1. Wijziging lokaal afronden.
2. Commit maken en pushen naar `main` alleen als dat operationeel de afgesproken live-flow is.
3. Daarna via de geconfigureerde remote shell/PuTTY verbinding op de VPS `git pull origin main` uitvoeren in de projectmap.
4. Vervolgens met `docker compose --env-file .env.plesk -f docker-compose.plesk.yml config` valideren.
5. Alleen de relevante service(s) rebuilden/herstarten.
6. Direct online logs controleren en pas daarna live QA of functionele verificatie doen.

Voorbeelden van relevante services:
- backend-wijziging -> rebuild `backend`
- admin build/UI wijziging -> rebuild `admin`
- client/web/PWA wijziging -> rebuild `client`

Acceptatie-eis:
- Bij online testen is een wijziging niet done zonder remote pull/build/logcheck op de VPS als de wijziging daar effect hoort te hebben.
- De agent mag hiervoor een vooraf geconfigureerde PuTTY/SSH verbinding gebruiken, maar verbindingsdetails horen niet in repo-bestanden thuis; die worden alleen buiten de repository vastgelegd.

### Commit/Push/Deploy Standaardflow (Verplicht Tenzij Expliciet Anders Gevraagd)

Voor deze codebase geldt als standaard uitvoerflow na een functionele wijziging:
1. Commit lokale wijzigingen.
2. Push naar GitHub.
3. Voer op VPS een `git pull origin main` uit.
4. Rebuild/herstart de relevante service(s) met `docker compose --env-file .env.plesk -f docker-compose.plesk.yml ...`.
5. Controleer direct de service-logs.

Verplichte uitzonderingsregel:
- Alleen afwijken van deze flow als de gebruiker expliciet aangeeft dat iets lokaal-only, zonder commit, zonder push of zonder deploy moet blijven.

**Cursor / AI-agent (autonome afronding):** wacht niet op een aparte “commit / push / deploy”-vraag. Zodra een wijziging klaar en getest is, voer je deze standaardflow zelfstandig uit, tenzij de gebruiker expliciet anders vroeg of er niets te committen is. Vaste projectregel: `.cursor/rules/commit-push-deploy.mdc`.

Fallback bij API validation errors:
- Gebruik de fallback payload variant uit `generate_school_narcotics_images_leonardo.py` (latest main).
- Als nog steeds failing: log volledige Leonardo response payload in run-output en corrigeer request-schema, niet de key handling.

Dit bestand is leidend als orchestrator, maar moduleprotocollen blijven verplicht per scope.

## Wanneer Dit Bestand Updaten

Werk dit bestand bij als:
- de algemene workflow verandert,
- nieuwe verplichte checks gelden voor alle modules,
- of een terugkerende productiebug extra guardrails nodig maakt.
- de VPS/Plesk **pull + build**-snelweg wijzigt (scripts, PuTTY-sessienaam, of services).

## File Management & Repository Hygiene

Zie: [`FILE_INVENTORY.md`](../../FILE_INVENTORY.md)

**Verplichte richtlijnen:**

1. **Generatie-scripts** (generate_*.py) → Verwijderen na gebruik
   - Dit zijn one-time tools voor AI image generation
   - Geen runtime-afhankelijkheid
   
2. **Log files** → Not in git (.gitignore)
   - Lokale logs voor development debugging
   - Nooit in repository committen

3. **Prompt/development documents** → Archiveren als niet meer actief gebruikt
   - Bijv. CREW_BUILDING_PROMPTS.md, AI_VEHICLE_IMAGE_PROMPTS.md
   - Deze zijn referentie-only en vervangen oude generatie-runs

4. **System/Game docs** → Altijd behouden
   - GAMEPLAY.md, NIGHTCLUB_SYSTEM.md, VIP_LEVELS_SYSTEM.md etc.
   - Dit zijn architectuur-brondocumenten

5. **Historische completion reports** → Archiveren
   - PHASE_*_REPORT.md, DELIVERY_SUMMARY.md, etc.
   - Houden als referentie maar niet in active root

**Nieuwe files checklist:**
- Vraag jezelf af: "Is dit nodig voor deployment of development van de game?"
  - ✅ Ja → root directory
  - ❌ Nee → `_archived/` of verwijder

Repository cleanliness helpt:
- Sneller git clonen/pushen
- Minder verwarring welke files actief zijn
- Duidelijker wat essentieel is vs. development artefact

Zie FILE_INVENTORY.md voor volledige lijst van verwijderde/archiveerde files.

### Documentation Organization (Centraal: PROTOCOL_MASTER.md)

**Alles begint hier. Altijd PROTOCOL_MASTER.md bijvoegen, nergens anders.**

```
PROTOCOL_MASTER.md (JIJ BENT HIER)
    ├── docs/module-protocols/ (gameplay rules & data contracts)
    │   ├── drugs.md → Game-system: docs/game-systems/GAMEPLAY.md
    │   ├── nightclub.md → Game-systems: NIGHTCLUB_SYSTEM.md + TRADE_RISK_MECHANICS.md
    │   ├── trade.md → Game-system: TRADE_RISK_MECHANICS.md
    │   ├── prostitution.md → Game-system: NIGHTCLUB_SYSTEM.md + VIP_MANAGEMENT.md
    │   ├── crew.md → Game-system: VIP_LEVELS_SYSTEM.md + HQ_PROGRESSION_GUIDE.md
    │   └── [andere modules...]
    │
    ├── docs/game-systems/ (mechanics & system documentation)
    │   ├── GAMEPLAY.md → Centrale game regels
    │   ├── NIGHTCLUB_SYSTEM.md → Nightclub + prostitution mechanics
    │   ├── TRADE_RISK_MECHANICS.md → Trade volatility & risk
    │   ├── VIP_MANAGEMENT.md → VIP staff features
    │   ├── VIP_LEVELS_SYSTEM.md → Crew VIP progression
    │   └── HQ_PROGRESSION_GUIDE.md → Property ownership & progression
    │
    ├── docs/operations/ (deployment & operational)
    │   ├── DEPLOY.md → Production deployment
    │   ├── FIREBASE_SETUP.md → Firebase configuration
    │   └── RELEASE_CHECKLIST.md → Pre-release QA
    │
    └── Root Level (project-wide standards)
        ├── I18N.md → Internationalization (NL/EN)
        ├── COPILOT_PROTOCOL.md → AI assistance guidelines
        ├── GIT_WORKFLOW.md → Git branching standards
        └── TODO.md → Active tasks
```

**Workflow bij wijziging:**

1. **Open PROTOCOL_MASTER.md** (dit bestand)
2. **Bepaal primaire module** (bijv. nightclub_screen.dart wijzigen → nightclub module)
3. **Open module-protocol** uit docs/module-protocols/ (nightclub.md)
4. **Open gerelateerde game-systems:**
   - nightclub.md gebruikt → nightclub_system.md + trade_risk_mechanics.md lezen
   - drugs.md gebruikt → drugs protocol → GAMEPLAY.md lezen
5. **Controleer cross-module dependencies** in PROTOCOL_MASTER.md:
   - Nightclub → Drugs, Prostitution, Dashboard, Admin (alle checken!)
6. **Voer wijziging uit** volgens module-protocol rules
7. **QA checklist** uitvoeren (minimaal happy flow + 1 error path)

**Koppelingsmatrix Game-Systems ↔ Module-Protocols:**

| Game-System | Module-Protocols | Functies |
|---|---|---|
| GAMEPLAY.md | alle modules | Basis game regels |
| NIGHTCLUB_SYSTEM.md | nightclub.md, prostitution.md, drugs.md | Venue setup, staff, inventory |
| VIP_MANAGEMENT.md | prostitution.md | VIP staff recruitment & salaries |
| VIP_LEVELS_SYSTEM.md | crew.md, properties.md | Building upgrades level 10-14 |
| HQ_PROGRESSION_GUIDE.md | properties.md, crew.md | Property ownership, HQ strategy |
| TRADE_RISK_MECHANICS.md | trade.md, travel.md | Goods volatility, spoilage, confiscation |
| HITLIST_SYSTEM.md | hitlist.md, crimes.md, security.md, crew.md | Bounties, murders, detective, protection |

**Verplicht controleren bij aanpassingen:**
- ✅ Module-protocol lezen (spelregels)
- ✅ Game-systems lezen (mechanica details)
- ✅ Cross-module dependencies checken
- ✅ QA checklist uitvoeren
- ✅ NL/EN parity in help_content.dart
- ✅ Mobile/tablet/desktop responsiveness
