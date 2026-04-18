# School Narcotics Images - External Hosting Guide

Dit document voorkomt dubbel werk bij image generation. Volg exact deze checklist.

## Doel
- Nieuwe Narcotica-track en gates visueel toevoegen.
- Afbeeldingen extern hosten (client bundle klein houden).
- Eenmalige generatie zonder tweede ronde door naam/path mismatch.

## Stap 1 - Externe image base instellen
Gebruik runtime build-flag in Flutter:

- `SCHOOL_IMAGE_BASE_URL=https://jouw-server.nl/game-assets/school`

Voorbeeld web build:

```bash
flutter build web --dart-define=SCHOOL_IMAGE_BASE_URL=https://cdn.jouwdomein.nl/game-assets/school
```

De app verwacht daarna automatisch deze URL-structuur:
- `https://.../game-assets/school/tracks/<file>.png`
- `https://.../game-assets/school/gates/<file>.png`

Belangrijk:
- Geen submap `assets/images/school` op je server gebruiken.
- Alleen `tracks/` en `gates/` onder de ingestelde base URL.

## Stap 2 - Exacte bestandsnamen (NIET wijzigen)
Genereer precies deze 8 bestanden.

Tracks:
1. `narcotics_track.png`

Gates:
1. `asset_drug_facility_upgrade_slots_tier_1_gate.png`
2. `asset_drug_facility_upgrade_slots_tier_2_gate.png`
3. `asset_drug_facility_upgrade_slots_tier_3_gate.png`
4. `asset_drug_facility_upgrade_slots_tier_4_gate.png`
5. `asset_drug_facility_upgrade_equipment_tier_1_gate.png`
6. `asset_drug_facility_upgrade_equipment_tier_2_gate.png`
7. `asset_drug_facility_upgrade_equipment_tier_3_gate.png`

## Stap 3 - Leonardo prompt specs (één stijl)
Gebruik voor alle afbeeldingen dezelfde basis stijl-instellingen:

- Aspect ratio: `16:9`
- Resolution: `1536x864` (of hoger met exact 16:9 verhouding)
- Style: cinematic realistic, gritty crime-economy game UI backdrop
- No text, no logos, no watermarks
- Strong center composition for UI overlays and labels

Negative prompt (voor alle 8):

`text, logo, watermark, letters, numbers, blurry, low detail, cartoon, anime, oversaturated neon, distorted anatomy, frame, border`

### Prompt A - Track image
Bestand: `narcotics_track.png`

Prompt:
`Cinematic narcotics operations control room, controlled cultivation and clandestine chemistry theme, hydroponic racks, process electric panels, glass reactors, stainless equipment, amber and cyan practical lighting, moody but readable, realistic textures, high detail, centered composition for game card header, no characters in foreground`

### Prompt B - Slot tier 1 gate
Bestand: `asset_drug_facility_upgrade_slots_tier_1_gate.png`

Prompt:
`Narcotics facility expansion tier 1, clean hydroponic starter bay, modular grow racks, beginner industrial setup, subtle blueprint overlays in environment lighting only, cinematic realistic, centered focal point`

### Prompt C - Slot tier 2 gate
Bestand: `asset_drug_facility_upgrade_slots_tier_2_gate.png`

Prompt:
`Narcotics facility expansion tier 2, larger controlled cultivation hall, advanced irrigation lines, denser infrastructure, realistic industrial environment, cinematic depth, centered composition`

### Prompt D - Slot tier 3 gate
Bestand: `asset_drug_facility_upgrade_slots_tier_3_gate.png`

Prompt:
`Narcotics facility expansion tier 3, high-capacity clandestine production floor, reinforced modular sections, advanced climate controls, premium industrial realism, dramatic controlled lighting`

### Prompt E - Slot tier 4 gate
Bestand: `asset_drug_facility_upgrade_slots_tier_4_gate.png`

Prompt:
`Narcotics facility expansion tier 4, elite full-scale narco grid architecture, massive synchronized production bays, top-tier secure infrastructure, cinematic realism, luxurious industrial detail`

### Prompt F - Equipment tier 1 gate
Bestand: `asset_drug_facility_upgrade_equipment_tier_1_gate.png`

Prompt:
`Drug facility equipment upgrade tier 1, entry-level process electrics and instrumentation, hydroponic monitoring devices, clean technical workbench, realistic lighting, centered focus`

### Prompt G - Equipment tier 2 gate
Bestand: `asset_drug_facility_upgrade_equipment_tier_2_gate.png`

Prompt:
`Drug facility equipment upgrade tier 2, improved electric control arrays, mid-tier laboratory instrumentation, organized cables and panels, cinematic industrial realism`

### Prompt H - Equipment tier 3 gate
Bestand: `asset_drug_facility_upgrade_equipment_tier_3_gate.png`

Prompt:
`Drug facility equipment upgrade tier 3, clandestine chemist advanced lab, precision reactors, high-end control systems, secure pharmaceutical-grade environment, dark cinematic realism`

## Stap 4 - Upload map op server
Upload exact naar:

- `/game-assets/school/tracks/narcotics_track.png`
- `/game-assets/school/gates/asset_drug_facility_upgrade_slots_tier_1_gate.png`
- `/game-assets/school/gates/asset_drug_facility_upgrade_slots_tier_2_gate.png`
- `/game-assets/school/gates/asset_drug_facility_upgrade_slots_tier_3_gate.png`
- `/game-assets/school/gates/asset_drug_facility_upgrade_slots_tier_4_gate.png`
- `/game-assets/school/gates/asset_drug_facility_upgrade_equipment_tier_1_gate.png`
- `/game-assets/school/gates/asset_drug_facility_upgrade_equipment_tier_2_gate.png`
- `/game-assets/school/gates/asset_drug_facility_upgrade_equipment_tier_3_gate.png`

## Stap 5 - Verificatie (voordat je opnieuw genereert)
Check deze URL's in browser:

1. `https://<jouw-host>/game-assets/school/tracks/narcotics_track.png`
2. `https://<jouw-host>/game-assets/school/gates/asset_drug_facility_upgrade_slots_tier_1_gate.png`
3. `https://<jouw-host>/game-assets/school/gates/asset_drug_facility_upgrade_equipment_tier_3_gate.png`

Als deze 3 OK zijn, zijn path + naming correct en hoef je niets opnieuw te renderen.

## Veelgemaakte fout (vorige keer)
Niet doen:
- andere bestandsnamen gebruiken zoals `narcotics-track.png` of `tier1.png`
- uploaden onder `/assets/images/school/...`
- extra submap (`/school/school/tracks/...`)

Wel doen:
- exact de 8 namen hierboven
- exact `tracks/` en `gates/` onder je base URL
- build draaien met `--dart-define=SCHOOL_IMAGE_BASE_URL=...`
