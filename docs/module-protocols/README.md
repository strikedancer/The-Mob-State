# Module Protocols (Bijlage: Altijd PROTOCOL_MASTER.md gebruiken!)

**Gebruik altijd [PROTOCOL_MASTER.md](PROTOCOL_MASTER.md) als enige attachment.**

De master protocol zorgt ervoor dat je:
- Alle relevante module-protocols opent
- Game-systems en data-contracts checkt
- Cross-module dependencies valideert
- Nooit een module aanraakt zonder context

## Standaard Workflow

1. **Bijlage:** `docs/module-protocols/PROTOCOL_MASTER.md` (enige bestand toevoegen)
2. **Lees PROTOCOL_MASTER.md** → bepaal je primaire module
3. **Open module-protocol** uit onderstaande lijst (bijv. nightclub.md)
4. **Open gerelateerde game-systems:**
   - PROTOCOL_MASTER.md toont koppelingsmatrix
   - Iedere module linkt naar relevante game-systems in docs/game-systems/
5. **Controleer cross-module dependencies** (listed in PROTOCOL_MASTER.md)
6. **Implementeer + QA** volgens module protocol rules

## beschikbare Module Protocols

### Shared Cross-Cutting Protocols
- [Balance & Economy](balance-economy.md) - Progression pacing, cooldown balancing, premium sinks en non-pay-to-win guardrails
- [Frontend Platform](frontend-platform.md) - Flutter web/mobile/PWA shells, assets, embedded views en cachegedrag
- [Marketing web](marketing-web.md) - Publieke landing, `GET /public/home`, gast-locale, juridische ARB-schermen, SPA-fallback
- [Notifications & Push](notifications.md) - Push pipeline, FCM/service worker en cooldown-signalen
- [Player Profile](player-profile.md) - Profielnavigatie, privacy en profielinteracties
- [Player Portraits (selfie)](player-portraits.md) - Premium selfie→gangster portretten, bibliotheek, Leonardo, runtime images

### Core Systems
- [Dashboard](dashboard.md) - UI voor alle stats/overview
- [Crew Management](crew.md) - Groep eigendom + upgrades (HQ_PROGRESSION_GUIDE.md)
- [Crew Missions](crew-missions.md) - Co-op missie loops, planning, role-based objectives, rewards en cooldown pacing
- [Crew Wars](crew-wars.md) - Crew-vs-crew wars, scoring, rewards en seasons
- [Territory](territory.md) - Crew territoriumcontrole per land met SVG maps, contests en seizoenen
- [Properties](properties.md) - Huizen/appartementen/magazijnen (HQ_PROGRESSION_GUIDE.md)
- [Friends & Messages](friends.md) & [Messages](messages.md)
- [Support Tickets](support-tickets.md) - Player reports, admin opvolging en todo-tracking
- [Inventory](inventory.md) - Item opslag en management

### Economy & Trading
- [Drug Production & Sales](drugs.md) - Productie facilities (part of GAMEPLAY.md)
- [Trade Goods](trade.md) - Zwarte markt + volatility (TRADE_RISK_MECHANICS.md)
- [Bank](bank.md) - Geld beheer
- [Casino](casino.md) - Gokken & winsten
- [Black Market](black-market.md) - Illegals trading
- [Payments & Premium](payments.md) - Mollie checkout, VIP, credits en premium catalogus
- [Live game events (player)](events.md) - Preset terugkerende events, beloningen, Event Pass, admin toggles
- [Balance & Economy](balance-economy.md) - Cross-loop balancing, runtime tuning en telemetry

### Activities & Crime
- [Jobs](jobs.md) - Legale inkomsten
- [Crimes & Robberies](crimes.md) - Diefstal + strafen
- [Travel & Countries](travel.md) - Internationale reizen (TRADE_RISK_MECHANICS.md)
- [Prison & Hospital](prison.md) & [Hospital](hospital.md)

### Nightlife & Entertainment
- [Nightclub System](nightclub.md) - Venue management (NIGHTCLUB_SYSTEM.md)
- [Prostitution](prostitution.md) - Staff assignment (VIP_MANAGEMENT.md, NIGHTCLUB_SYSTEM.md)
- [Casino Advanced](casino.md)

### Crime & Violence
- [Crimes & Robberies](crimes.md) - Diefstal, inbraken, geweld (GAMEPLAY.md)
- [Court & Legal](court.md) - Rechtszaken + straffen
- [Hitlist & Contracts](hitlist.md) - Moordcontracten

### Vehicles & Transportation
- [Garage & Vehicles](garage.md) - Auto's & motorcycles
- [Motor & Bikes](motor.md) - Motorfiets specifiek
- [Travel & Countries](travel.md) - Internationale reizen (TRADE_RISK_MECHANICS.md)
- [Steel Vehicle System](steel_voertuig.md) - Auto theft
- [Aviation & Aircraft](aviation.md) - Privévliegtuigen kopen, reistijdbonus en eigen-voertuig smokkelen

### Leisure & Training
- [Gym & Training](gym.md) - Stats improvement
- [Shooting Range & Weapons](shooting-range.md) - Schiet training
- [School & Education](school.md) - Skill learning
- [Marina & Boats](marina.md) - Zeilboten

### Settings & Advanced
- [Settings & Preferences](settings.md) - Player preferences
- [Smuggling & Contraband](smuggling.md) - Smokkel operaties
- [Crypto & Digital Assets](crypto.md) - Cryptocurrency trading
- [Tuneshop & Customization](tuneshop.md) - Auto aanpassingen

---

## Data Contract Validation (Verplicht bij Backend Changes)

Wanneer je schema.prisma of service-code wijzigt:

1. Controleer Prisma relaties bij nested includes
2. Voer uit:
   ```bash
   npx prisma validate
   npx prisma generate
   ```
3. Test exact de endpoints die door het scherm gebruikt worden
4. **ZERO** `PrismaClientValidationError` in backend logs!

## Dashboard Resilience (Multi-API Screens)

Voor schermen die meerdere API calls doen:
- Laat 1 failing API-call niet het hele scherm leegmaken
- Gebruik fallbacks of separate try/catch per kritieke sectie
- Kerninfo (actieve producties, eigendom, timers) moet zichtbaar blijven

## i18n & UX Basisregels

- NL en EN tekst altijd synchroon
- Geen regressies op mobile, tablet, desktop
- Duidelijke feedback voor succes/fout
- Geen kritieke knoppen verstopt achter hover-only styling
- Tab layout voor lange beheerpagina's (i.p.v. eindeloze scrolls)
- Visuele selectiekaarten (images) voor entities met icon-fallback
- Responsive tab-hoogte (viewport % met clamps)

---

## Zie Ook

- [PROTOCOL_MASTER.md](PROTOCOL_MASTER.md) - Workflow & Cross-Module Map
- [Balance & Economy](balance-economy.md)
- [docs/game-systems/](../game-systems/) - Game mechanics & system documentation
- [PROTOCOL_TEMPLATE.md](PROTOCOL_TEMPLATE.md) - Template voor nieuwe modules
- [Frontend Platform](frontend-platform.md)
- [Notifications & Push](notifications.md)
- [Player Profile](player-profile.md)
- [Crew Wars](crew-wars.md)
- [Crew Missions](crew-missions.md)
- [Territory](territory.md)
- [Drugs](drugs.md)
- [Nightclub](nightclub.md)
- [Crypto](crypto.md)
- [Smuggling](smuggling.md)
- [Tools](tools.md)
- [Court](court.md)
- [Payments & Premium](payments.md)
- [Hitlist](hitlist.md)
- [Security](security.md)
- [Hospital](hospital.md)
- [Prison](prison.md)
- [Steel Voertuig](steel_voertuig.md)
- [Garage](garage.md)
- [Motor](motor.md)
- [Marina](marina.md)
- [TuneShop](tuneshop.md)
- [Shooting Range](shooting-range.md)
- [Gym](gym.md)
- [Ammo Factory](ammo-factory.md)
- [School](school.md)
- [Prostitution](prostitution.md)
- [Red Light Districts](red-light-districts.md)
- [Achievements](achievements.md)
- [Settings](settings.md)
- [Support Tickets](support-tickets.md)
