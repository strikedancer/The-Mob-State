# Properties Protocol

## Scope
Property buying, upgrading, utility and ownership rules.

Scope-afbakening:
- Shop valt buiten deze module en wordt hier niet getoond of geclaimd.
- Nightclub is wél koopbaar via deze module (aankoop start het nachtclub-systeem); beheer van de nachtclub zelf vindt echter plaats in de aparte Nightclub-module.
- Deze module richt zich op house/apartment/warehouse/nightclub/casino plus de drie voertuigcollecties (shop blijft verborgen). Casino is unique per land. Warehouse is 1 per speler per land (geen landelijk slotplafond). Nightclub heeft beperkte landslots (UI toont vrij/max). Upgrade-max is 6 (showrooms: 5).
- **Showrooms (`car_showroom`, `motorcycle_showroom`, `boat_harbor`):** `unique_per_player` — één van elk per account wereldwijd, te koop in elk land, gebonden aan het aankoop-land. Collectie, geen tweede garage. Plaatsen: zelfde land, 100% conditie, één per model, slotcap per upgrade (8 → 20 → 40 → 80 → alle types van die categorie). Getoonde voertuigen zijn vergrendeld en tellen niet in garage/haven. Beheer: `GET/POST /properties/:id/showroom`, `.../place`, `.../remove`. Politie/FBI doorzoekt de vitrine bij aanhouding in dat land (~40% per voertuig). Geen PvP-diefstal, geen waakhonden.
- **Development (v1):** permanente income-boost per eigendom via bank-spend (`developmentLevel` / `lastDevelopAt`), los van warehouse capacity upgrades. Alleen op panden met passief inkomen (magazijn, nachtclub, casino, showrooms) — niet op huis/appartement.
- **Sell:** `POST /properties/:id/sell` keert 70% van `purchasePrice` contant uit. Vereist hetzelfde land, lege property-storage (en lege nachtclubvoorraad / lege showroomcollectie). Direct, geen cooldown.
- Residential storage (house/apartment/mansion/penthouse/safehouse): `weapons, cash, ammo, armor`. Warehouse: `tools, weapons, cash, ammo, armor` (geen drugs; die blijven nachtclub). Nightclub drugs stay on the nightclub module.
- **Warehouse arrest search:** bij politie/FBI-arrestatie wordt het magazijn in het huidige land doorzocht (~40% van tools/wapens/ammo/vesten/cash). Huizen worden niet doorzocht. Bankcash blijft beschermd.
- **Open storage** on a house or warehouse opens Inventory with that property selected. Access still requires the same country (`accessibleInCurrentCountry` / `WRONG_COUNTRY`).

## Primary Frontend Entry
- client/lib/screens/property_screen.dart
- client/lib/widgets/property_card.dart (Develop-actie)
- Compact photo hero (`house.png`) scrolls away; Available / My properties stay pinned. No extra AppBar in the embedded Empire shell. Gold `i` lives in the hero.

## Change Rules
- Preserve the core player loop and avoid hidden behavior changes.
- Keep Dutch and English copy in sync for any user-visible change.
- Keep layout usable on mobile, tablet and desktop if this module is reachable in the dashboard shell.
- Property TabBar is scrollable under ~420px so long locale labels do not overflow.
- Do not silently remove existing rewards, cooldowns or risk gates without updating help and release notes.

## Check Before Editing
- What is the player trying to achieve in this screen or loop?
- Which timers, locks, rank gates or country rules affect the flow?
- Does this module send notifications, inbox messages, rewards or achievements?
- Does this module depend on assets, videos, icons or generated media?

## Must Preserve
- Owned en available kaarten gebruiken dezelfde catalogusfoto (`house.png`, `apartment.png`, `warehouse.png`, `nightclub.png`, `car_showroom.png`, `motorcycle_showroom.png`, `boat_harbor.png`) via `WebAssetHelper`. Geen `EstateLotView` op dit scherm of op het publieke profiel. Deploy kopieert `properties/` naar `runtime/client-images`.
- Default tab is **My properties**. Lege owned-staat heeft een CTA naar Available. Available heeft type-chips, cash/rank-lock op kopen, en geformatteerde confirm voor buy + upgrade. Fouten zijn per tab; een refresh wist geen bestaande lijst.
- Brede schermen (≥720px twee kolommen, ≥1180px drie). Mobiel blijft één kolom. Elke kaart heeft een info-knop met type-uitleg + stats.
- Clear success and failure feedback for the player.
- Accurate state refresh after an action completes.
- Consistent formatting for money, timers, percentages and labels.
- Responsive usability without pushing critical actions off-screen.
- Backend en frontend moeten dezelfde zichtbaarheid hanteren voor property types (geen verborgen type dat toch via API claimbaar blijft).
- Property development: bank-only cost, max level + cooldown via runtime keys, income multiplier applies consistently in passive income calc.
- Develop UI: confirm dialog, mapped errors, cooldown remaining on `/properties/mine` + 429 params, and card stats for level/bonus/income. Hide Develop when `canDevelop` is false.
- Upgrade UI: confirm + next storage/housing/income preview; cash-lock like buy.
- Sell UI: confirm with 70% cash, mapped empty-storage / wrong-country / nightclub-stock / showroom-collection errors.
- Tick forfeiture (dood of >24u resterende celstraf) loopt via `checkForfeituresForEligibleOwners`: alleen kandidaten, max. 200 per tick, op zowel queue- als interval-ticks. Geen scan van alle eigenaren.

## i18n and Messaging
- Any new labels, warnings, helper text or dialogs must exist in both Dutch and English.
- If this module emits notifications, push messages or inbox events, keep the wording aligned across all channels.
- If player behavior changes, update the player help entry for this module.

## Development Runtime Keys
- `PROPERTY_DEVELOP_ENABLED`
- `PROPERTY_DEVELOP_MAX_LEVEL` (default 5)
- `PROPERTY_DEVELOP_COST_PERCENT_OF_PURCHASE` (default 25; cost scales with next level)
- `PROPERTY_DEVELOP_INCOME_BONUS_PERCENT_PER_LEVEL` (default 8)
- `PROPERTY_DEVELOP_COOLDOWN_SECONDS` (default 3600)

Endpoint: `POST /properties/:id/develop`

## QA Checklist
- Open the module on mobile width, tablet width and desktop width. Confirm 1 / 2 / 3 columns and that the info popup opens per property type.
- Run through the main success path and at least one failure or locked-state path.
- Verify the screen refreshes correctly after actions.
- Verify cooldowns, counters, balances or progress bars remain accurate.
- Verify no text overflows or clipped buttons appear.
- Verify shop is not returned in properties list endpoints and cannot be claimed via properties flow.
- Verify nightclub is visible in properties list and can be purchased (creating a nightclubVenue record).
- Verify develop spends bank, raises `developmentLevel`, and increases passive income display/calc.
- Verify a house can store weapons, ammo and a vest, and that a warehouse accepts tools plus weapons, ammo, armor and cash.
- Verify a player can own only one warehouse per country, and that a second buy is locked.
- Verify an arrest in that country seizes part of warehouse stock and leaves house storage intact.
- Verify a player can own only one of each showroom worldwide, that it binds to the purchase country, and that placing requires same-country + 100% condition + unique model + slot cap.
- Verify exhibited vehicles disappear from garage/marina counts and cannot be used, sold, scrapped or smuggled until removed.
- Verify an arrest in the showroom country can seize displayed vehicles (~40%) and leaves garage vehicles intact.
- Verify sell pays 70% cash, blocks when storage, nightclub stock or showroom collection is not empty, and frees a country slot.
- Verify casino is unique per country and nightclub shows remaining country slots.
- Verify Open storage from a property opens Inventory with that building selected, and a property in another country stays locked.

## When To Update This File
Update this protocol when the module gains a new subflow, new dependency, new notification path, major UX change or new QA risk.
