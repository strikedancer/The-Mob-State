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
- Bij nieuwe systemen of modules is het verplicht om actief alle bestaande protocollen te scannen op mogelijke koppelingen, afhankelijkheden, overlap en regressierisico's; een nieuw systeem is niet klaar zonder expliciete protocol-impactcheck.

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
- Crimes/Vehicle Theft -> Garage, Inventory, Prison, Security, Court, Crew, Friends, Notifications, Admin
- Hitlist -> Crimes, Security, Crew, Dashboard, Admin
- Crew Wars -> Crew, Hitlist, Crimes, Dashboard, Notifications, Payments, Achievements, Admin
- Payments/Premium -> Crew, Hitlist/Security, Garage, TuneShop, Events, Dashboard, Admin
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
- Auth recovery-flows zijn pas done als zowel de aanvraagstap als de vervolgroute echt werken: een `forgot password` scherm mag geen fake succes simuleren, moet de echte backend-endpoint aanroepen, en reset-/verify-links uit e-mail moeten op web/mobile naar een afhandelbaar scherm of route landen.
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

Implementatievoorkeur:
- Gebruik partial rendering boven "alles of niets" loading.

## i18n en UX Basisregels

- Multilanguage is een harde eis voor alles wat nieuw wordt gemaakt of aangepast en tekst of UX-signalen bevat (minimaal NL + EN).
- Geen enkele wijziging is "done" als nieuwe of gewijzigde labels, knoppen, foutmeldingen, succesmeldingen, dialogs, help-content, notificaties of admin/player UI-tekst maar in 1 taal aanwezig zijn.
- Nieuwe features en refactors mogen geen bestaande NL/EN pariteit breken; werk ontbrekende vertalingen direct mee bij in dezelfde wijziging.
- Bij aanpassingen of nieuwe modules is het verplicht om te controleren of `Help & Uitleg` nog klopt; als player-gedrag, flows, uitleg of terminologie verandert, moet de help-content in dezelfde wijziging worden bijgewerkt.
- NL en EN tekst altijd synchroon houden.
- Geen regressies op mobiel, tablet, desktop.
- Alle nieuwe en aangepaste overlays, dialogs, modals en full-screen lock states moeten expliciet responsive zijn voor mobiel, tablet en desktop; vaste breedtes/hoogtes zonder clamp, scrollfallback of safe-area-afhandeling gelden niet als done.
- Gebruik voor gedeelde overlays/dialogs een centraal responsive patroon of helper in plaats van losse one-off layoutlogica per scherm.
- Op mobiel mag een sticky topbar of statusheader blijven staan, maar daaronder moet player-facing content altijd via precies één primaire verticale scrollflow bruikbaar blijven; losse ingebedde scrollvensters of verborgen inner-scrollgebieden gelden niet als done.
- Duidelijke feedback voor succes/foutstatus behouden.
- Geen kritieke actieknoppen verstoppen achter hover-only styling.
- Bij lange beheerpagina's: groepeer secties in tabs i.p.v. eindeloze verticale stapels.
- Gebruik waar mogelijk visuele selectiekaarten (images) voor entities zoals staff/items; altijd met icon-fallback.
- Gebruik responsive/clamped hoogtes voor tabpanelen i.p.v. één vaste hoogte.
- Bij member-gebonden systemen met lifecycle-events moet notificatiedekking expliciet worden gevalideerd voor alle betrokken gebruikers, inclusief leiders/eigenaren waar van toepassing; handmatige admin-acties en automatische statusovergangen mogen geen stille bypass vormen voor push of inbox.
- Voor cross-cutting Flutter/web/mobile/PWA shell-, asset- en embedded-view regels: zie `frontend-platform.md`.
- Voor push-, inbox- en FCM/service-worker regels: zie `notifications.md`.
- Voor profielprivacy, profielnavigatie en profielinteracties: zie `player-profile.md`.

## Minimale QA Checklist (Altijd Draaien)

1. Happy flow van de wijziging (succespad).
2. Minimaal 1 foutpad of locked state.
3. Refresh/navigatie terug en check of state correct blijft.
4. Controle op mobile en desktop layout.
5. Backend logs checken op runtime errors tijdens die flow.
6. Verifieer cross-module gedrag (minimaal 1 gekoppelde module testen).
7. Verifieer dat Admin/logging de wijziging correct weergeeft als die module-impact heeft.
8. Verifieer dat alle nieuwe/gewijzigde player-facing teksten in NL en EN aanwezig zijn.
9. Verifieer dat `Help & Uitleg` nog klopt voor de gewijzigde of nieuw toegevoegde module/flow.
10. Bij nieuwe systemen of modules: bevestig dat alle relevante bestaande protocollen op koppelingen en regressierisico's zijn nagelopen.

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

### VPS Docker Compose standaard (aanbevolen)

Voor productie/VPS runs hoort de key via compose naar de backend-container te gaan.

Verplicht:
- Voeg `LEONARDO_API_KEY=${LEONARDO_API_KEY}` toe aan backend `environment` in `docker-compose.plesk.yml`.
- Zet de echte waarde in de server-side `.env` die compose gebruikt (niet in git).

One-shot runbook (volgende keer in 1 keer uitvoeren):
1. `git pull origin main`
2. Verifieer key aanwezigheid: `docker compose config | Select-String LEONARDO_API_KEY`
3. Herstart backend met nieuwe env: `docker compose restart backend`
4. Run generator in backend-context (waar env beschikbaar is)
5. Controleer dat alle doelbestanden zijn gegenereerd (8/8 voor school narcotics set)
6. Doe pas daarna de smoke test van de school/drugs flow

Fallback bij API validation errors:
- Gebruik de fallback payload variant uit `generate_school_narcotics_images_leonardo.py` (latest main).
- Als nog steeds failing: log volledige Leonardo response payload in run-output en corrigeer request-schema, niet de key handling.

Dit bestand is leidend als orchestrator, maar moduleprotocollen blijven verplicht per scope.

## Wanneer Dit Bestand Updaten

Werk dit bestand bij als:
- de algemene workflow verandert,
- nieuwe verplichte checks gelden voor alle modules,
- of een terugkerende productiebug extra guardrails nodig maakt.

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
