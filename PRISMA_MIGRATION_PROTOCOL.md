# Prisma Migration Protocol

## Goal

Zorg dat Prisma migrations voorspelbaar, reproduceerbaar en shadow-database-safe blijven.

Dit protocol is verplicht voor alle toekomstige databasewijzigingen.

---

## Kernregels

1. Gebruik altijd `npx prisma migrate dev --name <timestamped_feature_name>` of laat Prisma de timestamped map genereren.
2. Maak nooit handmatig migrations met vrije mapnamen zoals `foo_update` of `rename_bar`.
3. Gebruik forward-only migrations. Voeg nieuwe migrations toe in plaats van oude functioneel te herschrijven.
4. Gebruik raw SQL alleen als Prisma SQL onvoldoende is, en maak die SQL idempotent.
5. Elke migration moet toepasbaar zijn op een lege shadow database vanaf migration 1 tot head.

---

## Verplichte Naamgeving

Elke migrationmap moet beginnen met een timestamp in oplopende volgorde, bijvoorbeeld:

1. `20260404193000_add_game_event_platform_foundation`
2. `20260404201500_add_event_rewards`

Niet toegestaan:

1. `stripe_to_mollie_rename`
2. `add_crew_vip_status`
3. losse `.sql` files buiten een timestamped migrationmap

Reden:

Prisma verwerkt migrations op mapnaamvolgorde. Niet-timestamped namen kunnen later in de keten terechtkomen dan bedoeld en daardoor shadow database failures veroorzaken.

---

## Verplichte Workflow

### Voor elke schemawijziging

1. Werk `schema.prisma` bij.
2. Run `npx prisma format`.
3. Run `npx prisma migrate dev --name <descriptive_name>`.
4. Run `npx prisma generate`.
5. Run `npx prisma migrate status`.
6. Start of test de backend zodat Prisma-client types en runtime queries gecontroleerd worden.

### Voor raw SQL migrations

Controleer expliciet:

1. Bestaat kolom al?
2. Bestaat tabel al?
3. Bestaat index al?
4. Is de operatie veilig als shadow database op een andere intermediate state zit?

Gebruik bij raw SQL zo veel mogelijk conditionele checks via `information_schema` en `DATABASE()`.

---

## Shadow Database Regels

Een migration is pas geldig als hij op een schone shadow database werkt.

Dat betekent:

1. Geen afhankelijkheid van handmatige databasefixes.
2. Geen afhankelijkheid van kolommen die alleen in production bestaan maar niet uit eerdere migrations volgen.
3. Geen aannames over rename-volgorde als foldernamen niet strikt oplopend zijn.

Als `prisma migrate dev` faalt op shadow DB:

1. Zoek eerst de eerste migration die op shadow faalt.
2. Bepaal of de fout komt door volgorde, rename assumptions of non-idempotent SQL.
3. Repareer de migrationketen zo dat een fresh replay werkt.
4. Pas daarna pas de nieuwe feature migration toe.

---

## Wat Wel En Niet Mag Bij Legacy Reparaties

### Wel

1. Een oude migration idempotent maken als dat nodig is om de keten opnieuw afspeelbaar te maken.
2. Comments toevoegen die uitleggen waarom de migration shadow-safe gemaakt is.
3. Een follow-up repair migration toevoegen als een oud bestand niet veilig te wijzigen is.

### Niet

1. Stilzwijgend oude migrations herschrijven zonder reden.
2. Historische intentie veranderen als de live database al afhankelijk is van een bepaald eindresultaat.
3. Raw SQL toevoegen die alleen werkt op de huidige lokale database en niet op een fresh replay.

---

## Checklist Voor Rename Migrations

Bij kolom- of tabelrenames moet de migration defensief zijn.

Controleer:

1. Als oude naam bestaat en nieuwe naam niet bestaat: rename uitvoeren.
2. Als nieuwe naam al bestaat: no-op.
3. Als geen van beide bestaat maar de eindschema-kolom verplicht is: expliciete add overwegen.
4. Als oude en nieuwe naam allebei bestaan: geen impliciete destructieve actie uitvoeren zonder aparte cleanup migration.

---

## Checklist Voor Nieuwe Event Migrations

Voor het nieuwe event-platform geldt extra:

1. Templates, schedules, live events, progress, rewards en snapshots krijgen aparte tabellen.
2. JSON-velden moeten backward-compatible uitbreidbaar blijven.
3. Admin-relaties gebruiken `SetNull` waar een admin verwijderd of gedeactiveerd kan worden.
4. Player-relaties gebruiken alleen cascade waar data functioneel eigendom is van de speler.

---

## Repository Hygiene Regels

1. Geen losse `.sql` migrations buiten Prisma timestamp-mappen voor schema-evolutie.
2. Eén migration per samenhangende wijziging.
3. Grote features mogen meerdere migrations hebben als de rollout in slices gebeurt.
4. `prisma migrate status` moet schoon zijn voor merge.

---

## Required Verification Commands

Voer minimaal dit uit voor elke DB change:

```powershell
cd backend
npx prisma format
npx prisma migrate dev --name <name>
npx prisma generate
npx prisma migrate status
```

Bij problemen:

```powershell
cd backend
npx prisma migrate status
npx prisma migrate dev
```

---

## Root Cause Van De Huidige Fout

De huidige repository had legacy migrations met vrije mapnamen zoals:

1. `stripe_to_mollie_rename`
2. `add_crew_vip_status`

Daardoor kon Prisma op shadow databases een latere timestamped migration uitvoeren voordat een oudere niet-timestamped rename migration aan de beurt kwam.

Gevolg:

1. rename migration verwachtte `mollieCustomerId`
2. die kolom bestond nog niet in shadow replay
3. `prisma migrate dev` faalde met `P3006/P3018`

Dit protocol voorkomt dat scenario in de toekomst.