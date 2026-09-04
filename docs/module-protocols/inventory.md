# Inventory Protocol

## Scope
Carried items, storage, loadouts and equipment used by multiple modules.

## Primary Frontend Entry
- client/lib/screens/inventory_screen.dart — two tabs: paper-doll (default) and Loadouts. Dashboard web uses `embedded: true` (no own Scaffold/AppBar; stays in the dashboard content card). **Open storage** from a property switches the dashboard section instead of pushing a fullscreen route.
- client/lib/screens/inventory_paper_doll_tab.dart
- Same screen opens from a house/warehouse via **Open storage** (`InventoryScreen(initialPropertyId: …)`)

## Paper-doll inventory
- Center: player avatar, crime-weapon slot (`GET/POST /weapons/crime-weapon`) and worn vest (`GET /security/status`).
- Backpack grid shows `capacity` squares from `GET /tools/carried` slot meter, filled with carried tools, weapons, ammo and materials.
- Context grid (right on desktop, below on mobile): materials depot, or an owned property in the current country.
  - House / apartment / mansion / penthouse / safehouse: weapons, ammo, armor + cash buttons (no cash drag).
  - Warehouse: tools.
  - Materials stay in the country depot (`POST /drugs/materials/transfer`), not in a house.
- Drag on desktop/web; tap-select then tap-target everywhere (mobile fallback). Each drop is one API call; no optimistic client move.
- Stacks with quantity > 1 (ammo, materials, stacked weapons/tools) open a quantity dialog: move 1, move all, or a custom amount.
- Transfers: weapons `POST /properties/storage/:id/weapons/deposit|withdraw`, tools `POST /tools/transfer`, materials depot API, ammo/armor `POST /properties/storage/:id/ammo|armor/deposit|withdraw`.
- Invalid drop surfaces the server reason (`INVENTORY_FULL`, `STORAGE_FULL`, `WRONG_COUNTRY`, `STORAGE_TYPE_NOT_ALLOWED`, `ARMOR_ALREADY_EQUIPPED`).
- Out of scope here: drugs/nightclub, crew storage, garage vehicles, cash-drag.

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
- Shared equipment choices that other modules depend on, such as the selected crime weapon, must stay visible and must remain in sync with the consuming gameplay screen.
- The crime-weapon slot on the paper doll is the same selection Crimes uses. Dropping a weapon from backpack or house storage onto that slot sets `POST /weapons/crime-weapon`. Taking it off the slot (to backpack or house) clears the selection with `DELETE /weapons/crime-weapon`; Crimes then has no crime weapon. Moving a weapon only between backpack and storage does not change the crime-weapon selection.
- Backpack upgrade visibility stays progression-clean: after buying a better backpack, lower or equal backpack tiers should no longer be shown as selectable shop options; only real upgrades remain visible.

## i18n and Messaging
- Any new labels, warnings, helper text or dialogs must exist in both Dutch and English.
- If this module emits notifications, push messages or inbox events, keep the wording aligned across all channels.
- If player behavior changes, update the player help entry for this module.

## QA Checklist
- Open the module on mobile width, tablet width and desktop width.
- Run through the main success path and at least one failure or locked-state path.
- Verify the screen refreshes correctly after actions.
- Verify cooldowns, counters, balances or progress bars remain accurate.
- Verify no text overflows or clipped buttons appear.
- Verify the selected crime weapon shown in Inventory matches the selection used on the Crimes screen and survives refresh/navigation correctly.
- Verify drag and tap-to-move between backpack and house/warehouse/depot, including a rejected drop (full, wrong country, wrong type).
- Verify Open storage from a house or warehouse opens this screen with that property selected.

## When To Update This File
Update this protocol when the module gains a new subflow, new dependency, new notification path, major UX change or new QA risk.
