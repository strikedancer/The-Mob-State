# Drugs Protocol

## Scope
Drug empire hub with facilities, production, inventory, heat and progression.

## Primary Frontend Entry
- client/lib/screens/drug_environment_screen.dart
- Materials buy / transfer: `client/lib/screens/materials_shop_screen.dart` (also via Black Market → Materials)
- Material icons: `client/assets/images/materials/<id>.png` (filename = `drugs.json` material `id`). Generate/repair via `backend/scripts/generate_material_images_leonardo.py` (transparent PNG + rembg). Shop thumbs use `WebAssetHelper` on a dark plate so missing/white plates do not flash.

## Production materials: country depot + backpack (2026-08)

### Player rules
1. **Buy** → stock goes into the **depot of the player's current country** (not the backpack).
2. **Production** in country X consumes **depot(X) first**, then **backpack** (`_carried_`).
3. **Transfer** (`POST /drugs/materials/transfer`): `to_backpack` | `to_depot` for the current country only.
4. **Backpack capacity**: materials use slots (`ceil(qty / 5)` per stack) together with tools/weapons (`toolService.calculateInventoryUsage`). Upgrade backpacks to carry more.
5. **Travel**:
   - Country depots are **safe** (not wiped on arrest).
   - Backpack materials raise **arrest chance** and can be **partially confiscated** per leg.
   - Full arrest still wipes trade inventory + finished drugs + **carried materials only**.

### Data model
- `production_materials.country`: country id **or** sentinel `_carried_` for backpack.
- Unique: `(playerId, country, materialId)`.
- Migration: `20260829120000_production_materials_country_depot` backfills existing rows to the player's `currentCountry`.

### API
- `GET /drugs/my-materials` → `{ materials, depot, carried, currentCountry, backpack }`
- `POST /drugs/materials/buy/:materialId` → depot only
- `POST /drugs/materials/transfer` `{ materialId, quantity, direction }`
- VIP `buy-missing` also credits the **current-country depot**
- `GET /drugs/productions/:productionId/speedup-quote` → credit cost to finish an in-progress batch early
- `POST /drugs/productions/:productionId/speedup` → spend premium credits; sets `finishesAt = now` (player still collects normally)
- `GET /drug-facilities` → owned facilities + `catalog` (price, rank, owned, next-upgrade education)
- `POST /drugs/heat/cool` `{ action: cash | low_profile }`
- `POST /drugs/raids/:id/resolve` `{ choice: lose | downtime | cash }`
- `POST /drug-facilities/:id/auto-sale` `{ enabled }` (darkweb storefront only, default off)
- `POST /drugs/crew-storage/deposit` / `withdraw` — quality `DrugInventory` lots to crew `drug_storage`
- `GET /drugs/wholesale/quote` — dest street vs B2B €/g, fee, ETA, seizure, heat preview (`scope=personal|crew`)
- `POST /drugs/wholesale/export` — container send; `scope=personal` uses personal inventory, `scope=crew` uses `CrewDrugLot` + crew smuggle network + crew bank freight
- `GET /drugs/wholesale/shipments` — personal wholesale rows plus the player's crew wholesale rows (settles due first)

### NPC wholesale export (sell-on-arrival)
- Player stays in the origin country. Min grams via `DRUG_WHOLESALE_MIN_GRAMS` (default 250). Other country required.
- Price = dest street (`countryPricing × quality`) × (1 − spread) × (1 + volume bonus) × (1 − scarcity). Always below dest street.
- Freight/ETA/seizure = existing container pricing + origin `harbor` bonus.
- Metadata lock: `wholesale`, `unitPrice`, `payout`, `destinationCountry`, `drugType`, `quality`, `quantity`, `settledAt`.
- Tick + quote/list settle due rows. Ready wholesale is paid immediately; seized pays nothing.
- Heat on send (`DRUG_WHOLESALE_DRUG_HEAT`, includes smuggle +2). FBI heat per kg on successful arrival. Country police `drug_wholesale` (origin on send, dest on success) only if pressure flag is already on.
- Admin → Drugs runtime tab. Do not flip Clearing House or `COUNTRY_POLICE_PRESSURE_ENABLED` here.
- Client entry: Inventory **Exporteren** (personal). Crew storage tab lists quality lots with **Exporteren** (`scope=crew`). Hub shows a short shipment strip (crew rows prefixed). Smuggling Hub stays general cargo; do not add a second wholesale wizard.

### Crew wholesale
- Same sell-on-arrival loop. Source is `CrewDrugLot` (quality lots from Inventory **Naar crew-opslag**), not legacy `crewDrugInventory`.
- Requires owned `drug_storage`. Any crew member may export. Freight is charged to the crew bank. Payout goes to the crew bank minus `DRUG_WHOLESALE_CREW_RUNNER_BPS` (default 500 = 5%) to the named runner. Cash-storage overflow also goes to the runner (proceeds are never dropped).
- Heat/FBI/police stay on the sending player. Crew smuggling catalog/quote/send debit quality lots first, then legacy `crewDrugInventory`. Optional `feePayer: crew_bank` on smuggle send (crew network only).

### Credit speedup (production timer)
- Utility sink only: shortens wait time, does **not** bypass materials, slots, heat, education or collect.
- Pricing: `ceil(remainingMinutes * 2)`, clamped to **8–150** credits.
- Ledger: `playerCreditTransaction` with `reasonKey=drug_production_speedup`.
- Client: confirm dialog on Production cards (`Versnellen met credits` / bolt button).

### Helper module
- `backend/src/services/productionMaterialStock.ts`

### Dashboard activity (Mijn activiteit)
- Start: `drugs.production_started` (`drugName`, `minutes`, …)
- Collect: `drugs.production_collected` (`quantity`, `drugName`, `qualityLabel`, …)
- Wholesale settle: `drugs.wholesale_sold` / `drugs.wholesale_seized` (push + inbox)
- Emitted from `drugService` via `worldEventService` (player-scoped). Client copy: `evStreamDrugsProduction*`.

## Change Rules
- Preserve the core player loop and avoid hidden behavior changes.
- Keep Dutch and English copy in sync for any user-visible change.
- Keep layout usable on mobile, tablet and desktop if this module is reachable in the dashboard shell.
- Do not silently remove existing rewards, cooldowns or risk gates without updating help and release notes.

## Check Before Editing
- What is the player trying to achieve in this screen or loop?
- Which timers, locks, rank gates or country rules affect the flow?
- Does this module send notifications, inbox messages, rewards or achievements?
- Does this module depend on assets, videos, icons or generated media?

## Must Preserve
- Clear success and failure feedback for the player.
- Accurate state refresh after an action completes.
- Consistent formatting for money, timers, percentages and labels.
- Responsive usability without pushing critical actions off-screen.
- Drug inventory and storage quantities are gram-based; capacity checks, weight totals and user-visible messages must stay aligned to grams.
- Visibility of current productions in both Production flow and Facility context when players expect that summary.
- Finished but uncollected productions must remain visible in the Production flow and still count against their facility slot until they are actually collected.
- VIP auto-collect must be backed by a real background automation path; a toggle without server-side execution is not sufficient.
- VIP quick-buy material shortcuts in production cards must remain confirm-first (cost modal with explicit Buy/Cancel actions before purchase) and server-enforced on active VIP status.
- Collect UX should not force a full-screen reload; after successful collect, remove only the relevant production card and sync dependent counters in background.
- Credit speedup for an in-progress batch must quote remaining time server-side, confirm before spend, refuse when already ready/collected, and only move `finishesAt` forward (no auto-inventory grant).
- Facility ownership or type (including darkweb storefront) must not imply silent auto-sale of finished drug output. Darkweb auto-sale is **opt-in**, default **off**, with an explicit fee/heat disclaimer.
- Collect raids must become a pending player choice before loot (`lose` / `downtime` / `cash`); never instant confiscation.
- Batch-ready notifications (`drugs.production_ready`) are cron-driven and idempotent via `readyNotifiedAt`.
- Credit temp-slot and heat shield are time/risk/utility only (no extra yield).
- Crew quality-lot deposit uses `CrewDrugLot` (type+quality+grams) and shares `drug_storage` capacity with trade-good drug rows.
- Nightclub own-production margin bonus is capped via `DRUG_NIGHTCLUB_OWN_PROD_BONUS_PERCENT`.
- NPC wholesale export (sell-on-arrival) reuses `smuggling_shipments` + `metadata_json.wholesale`; cash is paid on tick/quote/list settle, never via depot claim. Crew wholesale uses `crewWholesale`, crew bank freight/payout, and `CrewDrugLot` debit.
- Education-gated drug facility progression: slot/equipment upgrades that are locked behind school gates must return structured requirement details (`gateId`, `gateLabelKey`, `missing`) so the client can render the education requirements dialog instead of a generic error.
- Materials bought into a country depot must not silently become backpack cargo; travel risk applies only to `_carried_` stock.

## Backend Contract Guardrails (Drugs)
- If drugs services use Prisma nested `include` (example: production -> facility -> upgrades), relation fields must exist in `schema.prisma`.
- Do not query non-existent model fields (example: filtering inventory by a field not present in `DrugInventory`).
- After relation/query changes: regenerate Prisma client and verify `/drugs/productions`, `/drug-facilities`, and `/drugs/inventory` all return success.
- Production list helpers must stay runtime-safe JavaScript/TypeScript; do not introduce Dart-style collection calls or other non-JS APIs in server-side mapping logic, because `/drugs/productions` is used during live play and admin error monitoring.
- When `/drugs/productions` throws, preserve actionable `Error` details in backend system logs so Admin -> System Logs shows message and stack instead of empty `{}` payloads.
- **Achievements (server):** `checkAndUnlockAchievements` must run when drug production data changes for progression (`completed` set by batch completion cron and on collect), not only from unrelated modules (e.g. nightclub responses). Otherwise players only see drug-related unlocks the next time a screen that happens to call the achievement check loads.

## Frontend Loading Guardrails (Drugs)
- Drug dashboards often load multiple endpoints in parallel. One failure may hide all cards if not guarded.
- Ensure failures in optional sections do not hide active productions or owned facilities.
- Prefer partial rendering with fallbacks over full-screen empty states when some API calls succeed.

## i18n and Messaging
- Any new labels, warnings, helper text or dialogs must exist in both Dutch and English.
- If this module emits notifications, push messages or inbox events, keep the wording aligned across all channels.
- If player behavior changes, update the player help entry for this module.
- Avoid legacy `x` or implicit unit wording for drug amounts in player-facing copy; use grams when referring to quantities.
- If drugs upgrade gates change, keep School and Drugs terminology aligned in both Dutch and English (track/certification naming and gate labels).

## QA Checklist
- Open the module on mobile width, tablet width and desktop width.
- Run through the main success path and at least one failure or locked-state path.
- Verify the screen refreshes correctly after actions.
- Verify cooldowns, counters, balances or progress bars remain accurate.
- Verify no text overflows or clipped buttons appear.
- Verify active productions remain visible after starting a batch and navigating back to facilities.
- Verify ready-but-uncollected productions remain visible after timer completion and still appear in facility context until collected.
- Verify VIP auto-collect actually collects ready batches without opening the screen manually.
- Verify owned facilities remain visible and upgrade options stay available after travel or refresh.
- Verify no Prisma validation errors appear in backend logs while loading drugs screens.
- Verify collect action removes only the collected production card without showing global loading spinner or reloading unrelated content blocks.
- Verify credit speedup quote + confirm flow on an in-progress batch; insufficient credits and already-ready batches return clear errors; after success the batch becomes collectable without granting inventory automatically.
- Buy materials in country A → stock only in depot A; production in A works; travel without loading backpack leaves depot A intact.
- Transfer to backpack → slots increase; travel can confiscate/arrest carried stock; depot elsewhere untouched.
- Unload backpack into depot of current country after travel.
- Wholesale export: quote shows dest street vs B2B, fee, ETA, seizure; send stays in origin; tick pays locked payout or seizes with no cash.

## When To Update This File
Update this protocol when the module gains a new subflow, new dependency, new notification path, major UX change or new QA risk.
