# Aviation Protocol

## Scope
Privévliegtuigen kopen, beheren en inzetten als reisvoertuig en smokkelkanaal.

Spelers die de school aviation-track hebben voltooid kunnen privévliegtuigen kopen. Een eigen vliegtuig verlaagt internationale reistijden en vermindert risico bij smokkeloperaties. Vrachtcapaciteit en voordelen zijn afhankelijk van het vliegtuigtype.

Dit protocol omvat ook het **eigen-voertuig smokkelkanaal** voor alle vervoerstypen (vliegtuig, auto, motor, boot). Zie ook smuggling.md en travel.md.

## Primary Frontend Entry
- `client/lib/screens/aviation_screen.dart` (catalogus + bezit + licenties)
- Web dashboard Aviation hides the inner AppBar title. The screen uses a noir hangar hero (school level, flight certs, paid license, owned count), compact license rows with gold actions, and catalog cards with price/rank/speed/cargo/license chips.

## Primary Backend Entry
- `GET  /aviation/catalog`        — beschikbare vliegtuigtypes met prijs, slots, bonus, piloot-gate status
- `GET  /aviation/my-aircraft`    — bezeten vliegtuigen van de ingelogde speler
- `POST /aviation/buy`            — vliegtuig kopen (gate + balance check server-side)
- `POST /aviation/sell/:id`       — vliegtuig verkopen (50% restwaarde)

## Aircraft Catalogus

| id           | Naam                   | Prijs          | Aviation level vereist | Certif. vereist  | Cargo-slots | Reistijdbonus | Smokkelrisico-reductie |
|--------------|------------------------|----------------|------------------------|------------------|-------------|---------------|------------------------|
| cessna       | Cessna 172             | €250.000       | 2                      | flight_basic     | 20          | −15%          | −10%                   |
| king_air     | Beechcraft King Air    | €750.000       | 3                      | —                | 50          | −25%          | −15%                   |
| gulfstream   | Gulfstream G200        | €2.500.000     | 4                      | flight_commercial| 80          | −35%          | −20%                   |
| cargo_737    | Boeing 737 Cargo       | €10.000.000    | 5                      | —                | 200         | −30%          | −25%                   |

> Heeft een speler meerdere vliegtuigen, geldt het **beste** voordeel (niet cumulatief).
> De Boeing 737 heeft iets minder reistijdbonus dan de Gulfstream omdat vrachtrouting meer voorbereiding kost, maar compenseert met enorme cargo-capaciteit.

## Pilot Education Gate (Aviation Track)

De bestaande school `aviation` track (maxLevel 5) is een **harde server-side voorwaarde** voor licentie- én vliegtuigkoop.

Regel:
- Licentie kopen/upgraden én vliegtuigkoop zijn pas toegestaan als de speler **alle pilot-opleidingen** heeft afgerond:
  - `aviation` level = `maxLevel` (momenteel 5)
  - alle aviation-certificeringen behaald (`flight_basic` + `flight_commercial`)

## Paid Aviation License (aparte aankoop)

School 5/5 alleen is **niet** genoeg. Op het Aviation-scherm moet de speler een **betaalde vlieglicentie** kopen (`POST /aviation/buy-license`) vóór een vliegtuig:

| licenseType | Prijs | Min rank | Ontgrendelt aircraft.type |
|-------------|-------|----------|---------------------------|
| basic | €100.000 | 20 | `light_aircraft`, `turboprop` |
| commercial | €500.000 | 30 | + `business_jet`, `luxury_jet` |
| cargo | €1.000.000 | 40 | + `cargo_jet`, `super_heavy_cargo` |

- Hogere tier mag lagere vliegtuigen kopen.
- Upgrade naar hogere tier is toegestaan (volledige prijs van de nieuwe tier); downgrade/same → `ALREADY_HAS_LICENSE`.
- UI: licentie-aanbod + koop/upgrade-knoppen bovenaan `aviation_screen.dart` (niet alleen een tekstregel).

Deze checks draaien in backend tijdens `purchaseLicense` / `purchaseAircraft` en mogen nooit alleen client-side afgedwongen worden.

## Cargo Slot Systeem

Elk vliegtuig heeft een vast aantal cargo-slots. Items nemen een bepaald aantal slots in per stuk. Backend valideert de cargo-manifest totaal server-side.

| Item-type             | Slots per stuk | Past in vliegtuig? | Past in boot (smokkel)? |
|-----------------------|----------------|--------------------|-------------------------|
| Auto (car)            | 10             | ✅ ja              | ✅ ja                   |
| Motor (motorcycle)    | 5              | ✅ ja (2 = 1 auto) | ✅ ja                   |
| Boot (boat)           | ∞              | ❌ nee             | n.v.t.                  |
| Drugspakket           | 1              | ✅ ja              | ✅ ja                   |
| Handelswaar klein     | 1              | ✅ ja              | ✅ ja                   |
| Handelswaar groot/zwaar | 2            | ✅ ja              | ✅ ja                   |
| Wapen                 | 1              | ✅ ja              | ✅ ja                   |

**Voorbeelden:**
- Cessna 172 (20 slots): 2 auto's OF 4 motoren OF 20 drugspakketten OF 1 auto + 2 motoren (10+10)
- Gulfstream G200 (80 slots): 8 auto's OF 16 motoren OF 80 drugspakketten OF gemixte lading
- Boeing 737 (200 slots): 20 auto's OF 40 motoren OF 200 drugspakketten OF combinaties

## Reistijdbonus (Travel Integration)

- Backend haalt bij `POST /travel/start-journey` het beste vliegtuig van de speler op.
- Reistijd wordt vermenigvuldigd met `(1 − bestAircraftBonus)`.
  - Voorbeeld: 4 uur vlucht + Gulfstream (−35%) → `4 × 0.65 = 2.6 uur`
- Geldt voor alle internationale luchtroutetijden.
- Het bonus-voordeel is zichtbaar in het Travel-scherm vóór vertrek (toon: "Eigen vliegtuig: −X% reistijd").
- Afhankelijkheid: `travelService.ts` roept `aviationService.getBestAircraftBonus(playerId)` aan.
- Geen vliegtuig → geen bonus (reistijd ongewijzigd, geen regressie).

## Eigen Voertuig Smokkelkanaal

Bij smokkeloperaties kiest de speler: **Commercieel kanaal** (bestaand) of **Eigen voertuig** (nieuw).

### Beschikbare eigen voertuigen voor smokkel

| Voertuig-type | Cargo-slots              | Risico-reductie | Confiscatie bij mislukking |
|---------------|--------------------------|-----------------|---------------------------|
| Vliegtuig     | Zie catalogus boven      | Zie catalogus   | 30% kans                  |
| Auto          | 10 slots per voertuig    | −5%             | 15% kans                  |
| Motor         | 5 slots per voertuig     | −8%             | 15% kans                  |
| Boot          | 30 slots per voertuig    | −7%             | 25% kans                  |

- De boot kan ook auto's en motoren vervoeren (past wel in ruim); vliegtuig kan geen boot vervoeren.
- Risico-berekening: `effectiefRisico = baseSmokkelRisico × (1 − voertuigRisicoreductie)`
- Bij mislukte smokkeloperatie met eigen voertuig: er wordt een confiscatie-kans gegooid.
  - Als confiscatie slaagt: voertuig wordt verwijderd uit bezit (PlayerAircraft / garage / marina).
  - Confiscatie-uitkomst altijd duidelijk tonen in de smokkelresultaat-melding.
- Backend selecteert voertuigen uit: `PlayerAircraft`, `garage` (auto/motor), `marina` (boot).
- Cargo-manifest validatie server-side: teveel slots → `400 CARGO_OVERFLOW`.

## Backend Schema (Prisma — nieuw model)

```prisma
model PlayerAircraft {
  id          Int      @id @default(autoincrement())
  playerId    Int
  aircraftId  String   // 'cessna' | 'king_air' | 'gulfstream' | 'cargo_737'
  purchasedAt DateTime @default(now())
  country     String   // huidige locatie van het vliegtuig

  player      Player   @relation(fields: [playerId], references: [id])

  @@index([playerId])
}
```

SQL-migratiebestand: `backend/add-aviation-tables.sql`

## Images (Leonardo.ai API)

- Vliegtuigafbeeldingen worden gegenereerd via de Leonardo.ai API.
- Script: `backend/scripts/generate_aircraft_images_leonardo.py`
- Opslag: externe runtime image mount `runtime/client-images/aircraft/`
- Nginx route: `/images/aircraft/*` → `/mnt/external-images/aircraft/`
- Client laadt via: `WebAssetHelper.image('aircraft/{aircraftId}.png')`
- Bestandsnamen: `cessna.png`, `king_air.png`, `gulfstream.png`, `cargo_737.png`
- Stijlrichtlijn prompt (per vliegtuig): cinematic zij-aanzicht of 3/4-perspectief, donkere avondlucht/runway achtergrond, game-art stijl, hoge contrast, transparante PNG 1024×1024
- Bij ontbrekende afbeelding: `errorBuilder` fallback naar vliegtuig-icoon (geen broken tile)
- Na genereren: `rsync -av runtime/client-images/aircraft/ runtime/client-images/aircraft/` naar VPS-mount uitvoeren

## Content Bestand

Catalogus staten in `backend/content/aircraft.json`:

```json
{
  "aircraft": [
    { "id": "cessna",     "name": "Cessna 172",          "price": 250000,    "requiredAviationLevel": 2, "requiredCertification": "flight_basic",     "cargoSlots": 20,  "travelBonus": 0.15, "smuggleRiskReduction": 0.10 },
    { "id": "king_air",   "name": "Beechcraft King Air", "price": 750000,    "requiredAviationLevel": 3, "requiredCertification": null,               "cargoSlots": 50,  "travelBonus": 0.25, "smuggleRiskReduction": 0.15 },
    { "id": "gulfstream", "name": "Gulfstream G200",     "price": 2500000,   "requiredAviationLevel": 4, "requiredCertification": "flight_commercial", "cargoSlots": 80,  "travelBonus": 0.35, "smuggleRiskReduction": 0.20 },
    { "id": "cargo_737",  "name": "Boeing 737 Cargo",    "price": 10000000,  "requiredAviationLevel": 5, "requiredCertification": null,               "cargoSlots": 200, "travelBonus": 0.30, "smuggleRiskReduction": 0.25 }
  ]
}
```

## Change Rules
- Pilot-gate mag nooit alleen client-side worden afgedwongen. Backend `educationService.checkGate` is leidend.
- Cargo-manifest totaal wordt altijd server-side gevalideerd tegen `cargoSlots`.
- Boot past nooit in een vliegtuig; auto/motor passen nooit in een boot-smokkel (boot heeft eigen cargo-systeem).
- Houd NL/EN copy synchroon op alle feedback-meldingen.
- Verkoopprijs is altijd 50% van de aankoopprijs; nooit meer.
- Vliegtuiglocatie (`country`) schaalt mee als de speler reist.

## Cross-Module Dependencies
- Aviation → School/Education (`aviation` track gates, `flight_basic` + `flight_commercial` certificaten)
- Aviation → Travel (reistijdbonus via `travelService.getBestAircraftBonus`)
- Aviation → Smuggling (eigen vliegtuig als smokkelkanaal + cargo-validatie)
- Aviation → Garage/Motor (eigen auto/motor als alternatieven in smokkelkanaal)
- Aviation → Marina (eigen boot als alternatief in smokkelkanaal)
- Aviation → Admin (aankoop/verkoop loggen als player activity `AIRCRAFT_PURCHASE`, `AIRCRAFT_SOLD`)
- Aviation → Prisma schema (`PlayerAircraft` model, migratiebestand vereist)

## Must Preserve
- Gate-status (vergrendeld/beschikbaar) altijd zichtbaar in catalogus, incl. welk level nog benodigd is.
- Cargo-slots gebruikt/vrij zichtbaar in smokkel-manifest UI.
- Reistijdbonus zichtbaar in Travel scherm vóór vertrek ("Eigen vliegtuig: −X% reistijd").
- Confiscatie-kans bij eigen voertuig smokkel altijd expliciet communiceren vóór bevestiging.
- Correct omgaan met ontbrekende aviation track (level 0 = alles vergrendeld, geen errors).

## Backend Contract Guardrails
- `npx prisma validate` + `npx prisma generate` na toevoeging `PlayerAircraft` model.
- `aviationService.getBestAircraftBonus(playerId)` retourneert `0` als speler geen vliegtuig bezit (geen null/undefined drift).
- Cargo-overflow geeft `400 CARGO_OVERFLOW`, nooit een silent fail.
- Confiscatie-verwijdering in een Prisma transaction samen met smokkelpoging-registratie.

## QA Checklist
1. Koop Cessna met aviation level 2 + flight_basic → succesvol, saldo daalt, vliegtuig zichtbaar in bezit.
2. Koop poging met te laag level → 403 + melding "Vereist: Aviation niveau X".
3. Koop poging zonder saldo → 402/400 + melding "Onvoldoende saldo".
4. Reistijdbonus zichtbaar in Travel scherm na aankoop Gulfstream.
5. Smokkel via eigen Cessna met cargo-manifest dat past (≤20 slots) → succesvol.
6. Smokkel via eigen Cessna met te zware lading (>20 slots) → 400 CARGO_OVERFLOW.
7. Smokkel via boot met auto in lading → past (auto 10 slots, boot 30 slots).
8. Smokkel via vliegtuig met boot in lading → 400 BOAT_CANNOT_FIT.
9. Mislukte smokkel met eigen vliegtuig → confiscatie-kans gegooid, resultaat getoond.
10. Afbeeldingen laden via WebAssetHelper, errorBuilder toont icoon bij 404.
11. Mobile + desktop: cataloguskaarten correct, slots-teller leesbaar.
13. On web dashboard Aviation, verify there is no extra “Luchtvaart” AppBar title, hero chips match school/license/owned state, and buy buttons stay disabled with a reason when rank, cash or license is missing.
12. Backend logs: geen PrismaClientValidationError.

## i18n and Messaging
- "Vliegtuig gekocht" / "Aircraft purchased"
- "Vliegtuig verkocht" / "Aircraft sold"
- "Vereist: Aviation niveau X" / "Requires: Aviation level X"
- "Vereist: Vliegbrevet (flight_basic)" / "Requires: Basic Flight License"
- "Onvoldoende saldo" / "Insufficient balance"
- "Cargo-capaciteit overschreden" / "Cargo capacity exceeded"
- "Boot past niet in vliegtuig" / "Boat cannot fit in aircraft"
- "Gesmokkeld via [naam voertuig]" / "Smuggled via [vehicle name]"
- "Voertuig in beslag genomen!" / "Vehicle confiscated!"
- "Eigen vliegtuig: −X% reistijd" / "Own aircraft: −X% travel time"

## When To Update This File
Update bij: nieuw vliegtuigtype, aanpassing cargo-slots, wijziging eigen-voertuig smokkelkanaal, gating-aanpassing, confiscatie-logica of gewijzigde education gates.
