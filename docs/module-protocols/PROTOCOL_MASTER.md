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

## Verplichte Protocol-Resolutie

Dit bestand is de enige bijlage, maar niet de enige bron.

Verplichte regel:
- Bij elke taak moeten alle relevante module-protocollen gelezen worden, inclusief afhankelijkheden.

Minimum output bij implementatie:
- Noem welke protocollen zijn toegepast.
- Noem welke cross-module checks uitgevoerd zijn.

## Nieuw Systeem: Auto Protocol Bootstrap (Verplicht)

Bij elk nieuw systeem of nieuwe module moet direct een protocol worden aangemaakt en gekoppeld.

Verplichte acties:
1. Maak een nieuw protocolbestand in `docs/module-protocols/` op basis van `PROTOCOL_TEMPLATE.md`.
2. Voeg het nieuwe protocol toe aan de index in `docs/module-protocols/README.md`.
3. Update in dit bestand de Cross-Module Dependency Map als er nieuwe koppelingen zijn.
4. Vermeld in de delivery-output dat protocol bootstrap is uitgevoerd.

Acceptatie-eis:
- Een nieuw systeem is niet "done" zonder bijbehorend protocol en index-verwijzing.

## Cross-Module Dependency Map (Minimaal)

- Drugs -> Facilities, Production, Inventory, Dashboard, Admin
- Properties -> Drugs, Dashboard, Admin
- Nightclub -> Drugs, Prostitution, Dashboard, Admin
- Crimes/Vehicle Theft -> Garage, Prison, Security, Admin
- Hitlist -> Crimes, Security, Crew, Dashboard, Admin
- Payments/Premium -> Crew, Hitlist/Security, Garage, TuneShop, Events, Dashboard, Admin
- Travel -> Properties, Drugs, Nightclub, Smuggling, Admin
- Admin -> Alle gameplay modules met logs, assets of economy-impact

Als een module niet in deze lijst staat maar wel geraakt wordt, voeg die altijd toe aan de scope.

## Module Richtlijnen (Ingebouwd)

- Dashboard: kritieke kaarten en statussen moeten zichtbaar blijven bij partial failure.
- Drugs: actieve producties en eigendom/upgrades moeten zichtbaar blijven na refresh, navigatie en travel.
- Properties: eigendom moet direct terugkomen in UI voor de eigenschappenstroom (house/apartment/warehouse) en mag geen nightclub/shop items tonen.
- Nightclub: draait als eigen systeem met idempotente venue setup en mag niet afhankelijk zijn van zichtbaarheid in de algemene Properties-module.
- Admin: player activity logging moet complete details tonen (type, bron, duur/tijd).

Als een wijziging meerdere modules raakt, gelden alle relevante bullets tegelijk.

## Verplicht Bij Backend Wijzigingen

- Controleer Prisma relaties bij nested includes.
- Controleer dat alle queryvelden echt in schema staan.
- Als een module (tijdelijk) losse SQL-updates buiten Prisma migraties gebruikt, borg dan dat productie die schema-stap ook echt uitvoert (startup bootstrap of expliciete deploy-stap), anders lokaal/online drift met 500-fouten.
- Als route/state data in `String`-kolommen wordt opgeslagen (zoals travel routes), serialiseer/parset dit expliciet als JSON om runtime type-drift tussen lokaal en productie te voorkomen.
- Log interne fouten met context op kritieke auth-routes (`/auth/register`, `/auth/login`) zodat productie-500's direct herleidbaar zijn.
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

Implementatievoorkeur:
- Gebruik partial rendering boven "alles of niets" loading.

## i18n en UX Basisregels

- Multilanguage is verplicht voor alle player-facing tekst (minimaal NL + EN).
- NL en EN tekst altijd synchroon houden.
- Geen regressies op mobiel, tablet, desktop.
- Duidelijke feedback voor succes/foutstatus behouden.
- Geen kritieke actieknoppen verstoppen achter hover-only styling.
- Bij lange beheerpagina's: groepeer secties in tabs i.p.v. eindeloze verticale stapels.
- Gebruik waar mogelijk visuele selectiekaarten (images) voor entities zoals staff/items; altijd met icon-fallback.
- Gebruik responsive/clamped hoogtes voor tabpanelen i.p.v. één vaste hoogte.
- Voor web/iOS homescreen push: zorg altijd voor een expliciete in-app permissie-entrypoint (bijv. in Settings) die `requestPermission` triggert op user gesture; vertrouw niet alleen op login/startup-init.
- Web push FCM payload: stuur naar web-tokens altijd een **data-only** bericht (geen `notification`-key). FCM toont anders automatisch een melding én de service worker (`onBackgroundMessage`) doet dat ook → dubbele notificatie. De service worker leest `payload.data.title` en `payload.data.body` als fallback. Native (Android/iOS) tokens blijven het `notification`-veld ontvangen.
- Safari/iOS PWA (homescreen-app) verwijdert het `notification`-veld uit FCM-berichten voordat ze bij de service worker komen (`onBackgroundMessage` ontvangt `payload.notification === undefined`). Dit levert "you have a new notification" op als de service worker geen `payload.data.body` fallback heeft. Oplossing: verplicht `title` en `body` ook in `payload.data` meesturen — wat de data-only web-aanpak al afdwing.
- Crypto marktmeldingen (`crypto.market.regime`, `crypto.market.news`) worden alleen verstuurd naar spelers met een actieve positie (`quantity > 0` in `crypto_holdings`). Stuur marktmeldingen nooit naar alle spelers tegelijk — filter altijd op actief portfolio via `getActiveCryptoPlayerIds()`.
- Bij profiel-like functionaliteit: zorg dat `profile_likes` runtime idempotent gebootstrapt kan worden (of expliciet als deploy-stap), zodat schema-drift niet leidt tot player-facing 500-fouten op `/player/:id/profile/like`.
- Cooldown-expiry pushmeldingen worden gepland via `setTimeout` direct na het instellen van de cooldown. Dit geldt voor: `crime` (90s), `job` (900s), `vehicle_theft` (300s), `boat_theft` (600s), `prostitute_recruit` (300s). Meldingen overleven geen server-restart — dit is acceptabel bij korte cooldowns. Voeg nieuwe cooldown-types toe in **zowel** `notificationService.sendCooldownExpiredNotification` (`actionNames`-map) **als** de `NOTIFY_ACTIONS`-set in `cooldownService.setCooldown()` (of een equivalente `setTimeout` in de eigen service).
- Bankoverschrijvingen: de ontvanger krijgt altijd een pushmelding via `notificationService.sendBankTransferReceivedNotification(...)` na de `bank.transfer_received` worldevent. Fire-and-forget (`.catch(() => {})`), nooit blocking.
- Bij jail/bail flows: na succesvolle borgbetaling altijd opnieuw jail+cooldown state ophalen (geen losse crimes-refresh), zodat overgang van jail overlay naar cooldown overlay betrouwbaar blijft.
- Overlay UX mobile: jail/cooldown overlays moeten compacte responsive header-typografie gebruiken en feedback via zichtbare snackbar/toast tonen, zodat meldingen niet buiten viewport vallen.
- Dashboard web-navigatie: klik op dezelfde sectie moet een expliciete remount/refresh triggeren (zelfde pagina opnieuw laden i.p.v. no-op).

## Flutter Web Asset Pad Conventie (Verplicht)

- Voor runtime `Image.asset(...)` in Flutter web gebruik standaard keys onder `assets/images/...` (dit matcht de bestaande bundle-layout).
- Let op web output-pad: assets onder `assets/images/...` worden in `build/web` fysiek onder `assets/assets/images/...` geplaatst; directe URL-fallbacks moeten daarom dit canonical pad ondersteunen.
- Vermijd nieuwe `images/...` keys in gameplay-schermen; die leiden in productie snel tot 404-routes op `/assets/images/*`.
- Login/landing/rechtbank backgrounds vallen ook onder deze regel; gebruik dus `assets/images/backgrounds/...` in `Image.asset(...)`.
- Voor kritieke visuals (zoals login achtergrond) implementeer altijd een fallback-keten: primaire asset key -> legacy key -> directe `/assets/images/...` URL -> visuele fallback.
- Bij URL-resolving helpers voor web-assets: gebruik base-relative paden (geen root-absolute `/assets/...`), zodat deployments op subpaths ook correct assets laden.
- Voor login/landing backgrounds op Flutter web: houd ook een static public fallback beschikbaar onder `web/images/backgrounds/*` en gebruik indien nodig een directe network fallback naar `images/backgrounds/*`.
- Voor brede gameplay image-loading op web: gebruik een centrale `/images/*` runtime-route (via helper + nginx alias naar Flutter bundle) zodat crimes/jobs/avatars/badges op alle omgevingen hetzelfde pad gebruiken.
- Voor productie-deploys met veel beeldmateriaal: images worden **niet** gebundeld in het Docker-image. De client Dockerfile verwijdert `build/web/assets/assets/images/` na de Flutter build. `AssetManifest.json` blijft intact zodat Flutter web HTTP-requests blijft maken die nginx afhandelt via de externe mount.
- Alle image-routes (`/images/*`, `/assets/assets/images/*`, `/assets/images/*`) verwijzen uitsluitend naar de externe runtime mount (`/mnt/external-images`). Er is geen bundled fallback — ontbrekende images resulteren in een `404` die de `errorBuilder` in Flutter triggert.
- Als `client/.dockerignore` `assets/images/` uitsluit, moet de client Docker build vóór `flutter build web` alle in `pubspec.yaml` gedeclareerde asset-directories (`flutter.assets`) aanmaken (stub dirs). Zonder die bootstrap faalt Flutter met `unable to find directory entry in pubspec.yaml`.
- Voor gameplay-schermen met dynamische afbeeldingen (drugs, facilities, voertuigen, black market, garage, marina, catalogi): gebruik op web altijd `WebAssetHelper.image(...)`, **nooit** losse `Image.asset(...)`. Dit geldt ook voor de interne `Image.asset`-aanroepen in `OverlayImage` — die widget gebruikt intern al `WebAssetHelper` (gefixed). Gebruik `OverlayImageBuilder()` voor voertuig-afbeeldingen met conditionele overlays; dit is web-safe.
- Voor achtergrondafbeeldingen in schermen (bijv. garage, marina): gebruik `Stack(fit: StackFit.expand, children: [Positioned.fill(child: Opacity(opacity: 0.3, child: WebAssetHelper.image(...))), Scaffold(...)])` in plaats van `Container(decoration: BoxDecoration(image: DecorationImage(image: AssetImage(...))))`. `AssetImage` in `DecorationImage` ondersteunt geen network fallback.
- Na refactors van `Container(decoration: BoxDecoration(image: ...))` naar `Stack(children: [...])`: controleer expliciet de sluitende `]` van `children` en draai minimaal `flutter analyze` of een web build vóór push; een missende bracket geeft pas bij build een harde compile-fout.
- Scope van runtime external storage is **alle** assets onder `client/assets/images/**`. Houd de runtime map-structuur gelijk aan de repository-structuur (rsync).
- Na server-deploy: altijd `rsync -av --delete client/assets/images/ runtime/client-images/` uitvoeren voordat de container herbouwd wordt, anders zijn alle afbeeldingen leeg.
- Bij runtime image updates zonder rebuild: hanteer versie-bestandsnamen (`*.v2.png`) of expliciete cache-invalidering om stale image caches te voorkomen.
- Voor kaarten/lijsten met dynamische image-bestanden (zoals jobs/crimes): implementeer altijd een visuele `errorBuilder` fallback zodat ontbrekende assets niet als lege/broken tiles eindigen.
- In gedeelde web image helpers: hanteer `Image.asset(...)` als primaire renderpad en gebruik network-URL alleen als fallback, zodat hosting/proxy variaties minder snel alle visuals breken.
- Voor web image helpers met network fallback: probeer meerdere compatibele URL-routes in volgorde (`images/...` -> `assets/assets/images/...` -> `assets/images/...`) voordat een icon-fallback wordt getoond, zodat reverse-proxy/nginx routeverschillen geen complete voertuig/drugs-catalogi breken.
- Normaliseer runtime image-strings altijd in de helper vóór render/fallback (bijv. varianten zoals `vehicles/foo.png`, `assets/images/vehicles/foo.png`, `/assets/assets/images/vehicles/foo.png` en dubbele segmenten zoals `vehicles/vehicles/...`). Zo blijven catalogi en market kaarten werken bij gemixte dataformaten.
- Voor Properties-data contracten: lever `maxLevel` expliciet vanuit backend (of leid deze server-side af uit `upgradeOptions`) zodat client-level badges/upgrade-knoppen nooit `3/3` tonen terwijl upgrades nog mogelijk zijn.
- Voor residentiële properties (house/apartment): bewaak economische volgorde in balans-updates; een appartement hoort niet duurder geprijsd te zijn dan een huis tenzij dit expliciet als designwijziging is vastgelegd in release-notes.
- Voor Inventory (op zak): tools, wapens en munitie moeten in dezelfde refresh zichtbaar blijven; gebruik robuuste parse-fallbacks op weapon-inventory responses en slik API-parsefouten niet stil weg als dat hele secties leeg trekt.
- Voor property-opslag van wapens (house/apartment): storage-detail payload moet altijd een stabiele withdraw-key bevatten (`weaponId`), en client moet fallback kunnen lezen op `id`/`drugType` voor legacy data zodat opgeslagen wapens altijd zichtbaar en opneembaar blijven.
- Voor mobiele schermen met filters + contentlijsten (zoals Inventory/Storage en Help/Uitleg): gebruik bij voorkeur één doorlopende verticale scrollcontainer in compacte layout. Vermijd combinaties van vaste header + geneste `Expanded`/interne lijst die scroll kunnen blokkeren op kleine schermen.
  - **KRITIEK**: Als een scherm in `Expanded` context ingebed is (bijv. dashboard web-views): **gebruik `ListView` (niet `SingleChildScrollView`)**. ListView accepteert oneindige hoogte en scrolle correct; SingleChildScrollView past zich aan content-hoogte aan en blokkeert scroll als content in viewport past.
  - Pattern: `ScrollConfiguration(...dragDevices...) { child: ListView(physics: AlwaysScrollableScrollPhysics(), children: [...]) }`
- Voor TabBar + TabBarView schermen (bijv. Inventory): plaats de vaste header (weapon selector, tabs) boven het TabBarView in een Column, stel TabBarView physics in op `NeverScrollableScrollPhysics()`, en laat elke tab-content zelf scroll afhandelen (storage_tab met ListView, etc.). Dit vermijdt nested scroll conflicts tussen TabBarView en ListView.
- Voor Flutter web/PWA embedded views: forceer waar nodig `ScrollConfiguration(...dragDevices...)` op section-containers zodat touch-drag scroll op mobiel niet wordt geblokkeerd door platform-defaults of geneste shells.
- Voor kritieke web-assets die structureel issues geven (avatars, crime-art, login backgrounds) gebruik bij voorkeur een gedeelde helper die op web direct naar de publieke HTTPS asset-URL resolvet in plaats van losse `AssetImage` aanroepen te verspreiden.
- Bij helper-refactors over meerdere schermen: verifieer expliciet imports op alle aangepaste screens voordat een web build wordt gedeployed.
- Productie-nginx mag compat-aliases bevatten voor legacy paden (`/assets/images/*` en `/assets/image/*`) zodat oude clients niet direct breken.
- Voor nginx-routes naar external images (`/images/*`, `/assets/assets/images/*`, `/assets/images/*`, `/assets/image/*`): gebruik `alias /mnt/external-images/;` op prefix-locaties (`location ^~ ...`) en vermijd `try_files /mnt/external-images/...` patronen. Verkeerde `try_files` padresolutie geeft globale 404 op alle web-afbeeldingen.
- Na elke productie client-update met image-wijzigingen: voer `git lfs pull --include="client/assets/**,client/images/**"` + `git lfs checkout` uit op de server vóór `docker compose ... --build`.
- Post-deploy cache-eis: hard refresh verplicht; bij visuele regressies eerst Service Worker unregisteren en opnieuw laden voordat code als “stuk” wordt beschouwd.
- Voor iOS homescreen/PWA updates: serve `index.html`, `manifest.json`, `flutter_bootstrap.js`, `flutter_service_worker.js` en `main.dart.js` altijd met `Cache-Control: no-cache, must-revalidate` (of no-store voor service worker) zodat nieuwe releases zonder app-herinstallatie zichtbaar worden.

## Minimale QA Checklist (Altijd Draaien)

1. Happy flow van de wijziging (succespad).
2. Minimaal 1 foutpad of locked state.
3. Refresh/navigatie terug en check of state correct blijft.
4. Controle op mobile en desktop layout.
5. Backend logs checken op runtime errors tijdens die flow.
6. Verifieer cross-module gedrag (minimaal 1 gekoppelde module testen).
7. Verifieer dat Admin/logging de wijziging correct weergeeft als die module-impact heeft.
8. Verifieer dat alle nieuwe/gewijzigde player-facing teksten in NL en EN aanwezig zijn.

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

## Lokale AI Keys (Leonardo)

- Sla Leonardo API keys lokaal op in `backend/.env.local` met key `LEONARDO_API_KEY`.
- Commit nooit API keys in repository-bestanden.
- Generatie-scripts met `*leonardo*` lezen eerst env vars en daarna `backend/.env.local`.

Dit bestand is leidend als orchestrator, maar moduleprotocollen blijven verplicht per scope.

## Wanneer Dit Bestand Updaten

Werk dit bestand bij als:
- de algemene workflow verandert,
- nieuwe verplichte checks gelden voor alle modules,
- of een terugkerende productiebug extra guardrails nodig maakt.

## Spelerprofiel Navigatie Standaard (Verplicht)

Elke screen die een andere speler toont (naam, avatar, rank) **moet** navigatie naar diens profiel bieden.

### Verplicht patroon

```dart
// 1. Import bovenaan
import 'player_profile_screen.dart';

// 2. Methode in de State-klasse
void _openPlayerProfile(int playerId, String username) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => PlayerProfileScreen(playerId: playerId, username: username),
    ),
  );
}

// 3. Wrappen van avatar- en naam-widgets
GestureDetector(
  onTap: () => _openPlayerProfile(playerId, username),
  child: /* Text(username) of CircleAvatar */,
)
```

### Richtlijnen
- Gebruik `color: Colors.lightBlue` op de naam-Text om klikbaarheid te signaleren.
- Bewak altijd op nullable `playerId`: alleen klikbaar maken als `playerId != null` (of `> 0`).
- Geldt voor: avatars, namen, leaderboard-rijen, gevangenenlijsten, eigenaarstekst, crew-leden, etc.

### Profiel Privacy & Context (Verplicht)
- Toon op een publiek spelersprofiel **geen live locatieveld** zoals huidig land/reislocatie als dat gameplay-intel lekt (o.a. hitlist/onderzoek).
- In context-screens (zoals hitlist) moet profielweergave standaard als embedded content/modal tonen en niet de hoofdschermnavigatie doorbreken.

### Screens waar dit is geïmplementeerd (✅)
| Screen | Avatar | Naam |
|---|---|---|
| `crew_screen.dart` | ✅ | ✅ |
| `friends_screen.dart` | ✅ | ✅ |
| `activity_feed_screen.dart` | ✅ | ✅ |
| `direct_messages_screen.dart` | ✅ | ✅ |
| `dashboard_screen.dart` | ✅ eigen avatar | — |
| `hitlist_screen.dart` | ✅ via callback | ✅ |
| `trade_screen.dart` | ✅ | ✅ |
| `chat_screen.dart` | ✅ | — |
| `prison_screen.dart` | — | ✅ gevangenenlijst |
| `prostitution_leaderboard_screen.dart` | — | ✅ leaderboard-rijen |
| `red_light_districts_screen.dart` | — | ✅ eigenaarsnaam |

### Screens nog te checken (❓)
- `nightclub_screen.dart` — leaderboard heeft `ownerUsername` maar nog geen `ownerId` in API response
- `events_screen.dart` — `player['username']` aanwezig, `player['id']` te verifiëren

---

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
