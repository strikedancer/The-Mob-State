# Smoke Test - Narcotics Education Gates

Doel: snel valideren dat drugs-upgrades correct achter opleidingseisen zitten.

## Pre-check
1. Backend draait en build is recent.
2. Je testaccount heeft toegang tot Drugs + School.
3. Je hebt minimaal 1 drugsfaciliteit in huidig land.

## Test 1 - Lock behavior slot tier 1
1. Zorg dat speler GEEN `hydroponic_specialist` heeft en narcotics level < 2.
2. Open Drugs -> Faciliteiten.
3. Klik op `Upgrade slots` naar 2.

Expected:
- Geen upgrade uitgevoerd.
- Education requirements dialog opent.
- Dialog toont minimaal TRACK_LEVEL/CERTIFICATION missing.

## Test 2 - Unlock slot tier 1
1. Train school track `narcotics` tot level 2 en behaal `hydroponic_specialist`.
2. Probeer opnieuw slot-upgrade naar 2.

Expected:
- Upgrade slaagt.
- Slots verhogen van 1 -> 2.
- Geen education dialog.

## Test 3 - Slot tier 2 lock
1. Zorg dat level 2 wel gehaald is, maar level 3 of `process_electrics_specialist` nog niet.
2. Probeer slots van 2 -> 3.

Expected:
- Geblokkeerd met education dialog.
- Missing toont level 3 en/of certificaat.

## Test 4 - Equipment tier 1 lock
1. Pak een faciliteit met equipment op level 1.
2. Zorg dat `hydroponic_specialist` ontbreekt.
3. Klik op equipment-upgrade naar level 2.

Expected:
- Geen upgrade uitgevoerd.
- Education requirements dialog opent.

## Test 5 - Equipment tier 1 unlock
1. Zorg voor narcotics level 2 + `hydroponic_specialist`.
2. Herhaal equipment-upgrade naar level 2.

Expected:
- Upgrade slaagt.
- Equipment level 1 -> 2.

## Test 6 - Higher tiers
1. Tier 2 vereist: level 3 + `process_electrics_specialist`.
2. Tier 3 vereist: level 4 + `clandestine_chemist`.
3. Tier 4 (slots) vereist: level 5 + `narco_grid_architect`.

Expected:
- Elke tier blokkeert zolang requirement ontbreekt.
- Elke tier unlockt direct zodra requirement gehaald is.

## Test 7 - School gates visibility
1. Open School scherm.
2. Controleer dat Narcotics track zichtbaar is.
3. Controleer dat nieuwe gate-cards zichtbaar zijn met juiste labels.

Expected:
- Track zichtbaar met juiste naam/omschrijving.
- Gates zichtbaar met status OPEN/LOCKED.

## Test 8 - External image hosting
1. Start client met:
   - `--dart-define=SCHOOL_IMAGE_BASE_URL=https://<jouw-host>/game-assets/school`
2. Plaats minimaal 1 track image en 1 gate image op die server.
3. Open School scherm.

Expected:
- Externe image laadt eerst.
- Bij 404 valt UI terug op lokale asset en anders emoji.
- Geen crash of leeg vlak.

## Test 9 - i18n
1. Zet app op NL en EN.
2. Trigger lock-dialog bij een gate.

Expected:
- UI blijft leesbaar in beide talen.
- Nieuwe termen sluiten logisch aan bij bestaande school/drugs labels.

## Test 10 - Regression quick pass
1. Casino/ammo education locks nog intact.
2. Drugs facility kopen en productie starten nog intact.

Expected:
- Geen regressie op bestaande education-gated systemen.
