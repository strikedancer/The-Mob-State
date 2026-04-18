# Drug Facility Equipment Images - External Hosting Guide

Dit document fixeert naming + pad voor apparatuur-afbeeldingen in Drugs Faciliteiten.

## Doel
- Alle apparatuur-upgrades visueel maken met echte afbeeldingen.
- Extern hosten zodat Flutter bundle klein blijft.
- Eén vaste Leonardo-run zonder naamconflicten.

## Stap 1 - Externe base URL
Gebruik runtime build-flag in Flutter:

- `DRUG_FACILITY_IMAGE_BASE_URL=https://jouw-server.nl/game-assets/facilities`

Voorbeeld web build:

```bash
flutter build web --dart-define=DRUG_FACILITY_IMAGE_BASE_URL=https://cdn.jouwdomein.nl/game-assets/facilities
```

Fallback gedrag:
- Als de define niet is gezet op web, gebruikt de app automatisch `${origin}/game-assets/facilities`.
- Als een afbeelding ontbreekt, valt de UI terug op een Material icon.

## Stap 2 - Exacte bestandsnamen (15)
Map:
- `/game-assets/facilities/equipment/`

Bestanden:
1. `greenhouse_lighting.png`
2. `greenhouse_substrate.png`
3. `greenhouse_climate_control.png`
4. `mushroom_farm_humidity_control.png`
5. `mushroom_farm_substrate_mix.png`
6. `mushroom_farm_temperature_control.png`
7. `drug_lab_extraction_equipment.png`
8. `drug_lab_pill_press.png`
9. `drug_lab_lab_chemistry.png`
10. `crack_kitchen_reactor_control.png`
11. `crack_kitchen_batch_tanks.png`
12. `crack_kitchen_cookline_automation.png`
13. `darkweb_storefront_opsec_stack.png`
14. `darkweb_storefront_order_router.png`
15. `darkweb_storefront_crypto_settlement.png`

## Stap 3 - Leonardo script
Script:
- `backend/scripts/generate_drug_facility_equipment_images_leonardo.py`

Estimate-only check:

```bash
python backend/scripts/generate_drug_facility_equipment_images_leonardo.py --estimate-only
```

Echte run:

```bash
python backend/scripts/generate_drug_facility_equipment_images_leonardo.py --confirm-batch YES
```

Forceren opnieuw renderen:

```bash
python backend/scripts/generate_drug_facility_equipment_images_leonardo.py --confirm-batch YES --force
```

## Stap 4 - Upload
Upload exact naar:
- `/game-assets/facilities/equipment/<bestandsnaam>.png`

Belangrijk:
- Geen extra submap gebruiken zoals `/assets/images/facilities/`.
- Geen bestandsnamen hernoemen.

## Stap 5 - Verificatie
Check minimaal deze URLs:
1. `https://<host>/game-assets/facilities/equipment/greenhouse_lighting.png`
2. `https://<host>/game-assets/facilities/equipment/drug_lab_extraction_equipment.png`
3. `https://<host>/game-assets/facilities/equipment/darkweb_storefront_crypto_settlement.png`

Als deze laden, zijn path + naming correct en pakt de UI de images automatisch op.
