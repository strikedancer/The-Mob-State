# Drugs Protocol

## Scope
Drug empire hub with facilities, production, inventory, heat and progression.

## Primary Frontend Entry
- client/lib/screens/drug_environment_screen.dart
- Materials buy / transfer: `client/lib/screens/materials_shop_screen.dart` (also via Black Market → Materials)

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

### Helper module
- `backend/src/services/productionMaterialStock.ts`

### Dashboard activity (Mijn activiteit)
- Start: `drugs.production_started` (`drugName`, `minutes`, …)
- Collect: `drugs.production_collected` (`quantity`, `drugName`, `qualityLabel`, …)
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
- Facility ownership or type (including darkweb storefront) must not imply silent auto-sale of finished drug output unless a dedicated sale feature explicitly exists and is documented.
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
- Buy materials in country A → stock only in depot A; production in A works; travel without loading backpack leaves depot A intact.
- Transfer to backpack → slots increase; travel can confiscate/arrest carried stock; depot elsewhere untouched.
- Unload backpack into depot of current country after travel.

## When To Update This File
Update this protocol when the module gains a new subflow, new dependency, new notification path, major UX change or new QA risk.
