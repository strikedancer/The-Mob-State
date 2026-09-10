# Inventory Protocol

## Scope
Carried items, storage, loadouts and equipment used by multiple modules.

## Primary Frontend Entry
- client/lib/screens/inventory_screen.dart — two tabs: paper-doll (default) and Loadouts. Dashboard web uses `embedded: true` (no own Scaffold/AppBar; stays in the dashboard content card). **Open storage** from a property switches the dashboard section instead of pushing a fullscreen route.
- client/lib/screens/inventory_paper_doll_tab.dart
- Same screen opens from a house/warehouse via **Open storage** (`InventoryScreen(initialPropertyId: …)`)

## Paper-doll inventory
- Center: player avatar, crime-weapon slot (`GET/POST /weapons/crime-weapon`), second-weapon slot (`GET/POST /weapons/secondary-weapon`) and worn vest (`GET /security/status`).
- A player can wear two weapons at once (for example a handgun and a rifle). When a crime is committed, both worn slots are compared and the best eligible weapon for that crime is used automatically.
- Worn weapons are hidden from the backpack grid and do not count toward backpack capacity. Unequipped extra copies still do.
- Backpack grid shows `capacity` squares from `GET /tools/carried` slot meter, filled with carried tools, unequipped weapons, ammo, materials, **finished drugs** and **trade goods**.
- The Inventory **menu** shows paper-doll + backpack only. There is no remote house dropdown and no unplaced-stock grid. To stash or withdraw, the player goes to **Properties → that building → Open storage**, which opens this screen with that property selected.
- Property grid (right on desktop, below on mobile) appears **only** when opened via Open storage on a house/apartment/warehouse **in the current country**. Other-country houses stay hidden until the player travels there (`inventoryOtherCountryStashHint`). Backpack squares match `GET /tools/carried` capacity (no 8-slot floor).
  - House / apartment / mansion / penthouse / safehouse: weapons, ammo, armor, cash, **materials, finished drugs, trade goods**. Safer on arrest. Slot count comes from `properties.json` `storageCapacity` at the building's upgrade level (house 10→95, apartment 5→38), not the legacy `property_storage_capacity` row.
  - Warehouse: tools plus the same stash types. Police/FBI search this building in the arrest country (~40% seize, including materials/drugs/trade).
  - Buy/collect credits the **backpack** (`DrugInventory`, `inventory.country = _carried_`, materials `_carried_`). The player must visit a house or warehouse to place stock, and withdraw to the backpack before selling, smuggling or flying. Flying with backpack goods is self-smuggling; commercial travel and hangar Fly can confiscate carried drugs/trade/materials. Police/FBI arrest seizes ~40% of the backpack.
  - Slot costs in property grids: materials `ceil(qty/5)`, drugs **50g/slot**, trade **1 unit = 1 slot**.
- Drag on desktop/web; tap-select then tap-target everywhere (mobile fallback). Each drop is one API call; no optimistic client move.
- Stacks with quantity > 1 (ammo, materials, stacked weapons/tools) open a quantity dialog: move 1, move all, or a custom amount.
- Transfers: weapons `POST /properties/storage/:id/weapons/deposit|withdraw` (house-to-body may send `equip: true`), body slots `POST/DELETE /weapons/crime-weapon` and `/weapons/secondary-weapon`, tools `POST /tools/transfer`, materials/drugs/trade `POST /properties/storage/:id/materials|drugs|trade/deposit|withdraw` (backpack ↔ that property only), ammo/armor `POST /properties/storage/:id/ammo|armor/deposit|withdraw`.
- Invalid drop surfaces the server reason (`INVENTORY_FULL`, `STORAGE_FULL`, `WRONG_COUNTRY`, `STORAGE_TYPE_NOT_ALLOWED`, `ARMOR_ALREADY_EQUIPPED`).
- Out of scope here: nightclub venue stock (unprefixed `drugs` keys), crew storage, garage vehicles, cash-drag.

## Change Rules
- Preserve the core player loop and avoid hidden behavior changes.
- Keep Dutch and English copy in sync for any user-visible change.
- Keep layout usable on mobile, tablet and desktop if this module is reachable in the dashboard shell.
- Inventory TabBar matches the Empire hub: text-only labels, `isScrollable: true`, gold indicator. Compact photo hero scrolls away; gold `i` lives in the hero.
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
- Shared equipment choices that other modules depend on, such as worn weapon slots, must stay visible and must remain in sync with the consuming gameplay screen.
- Inventory storage is **current-country only** and only the building opened via **Open storage**. Do not show a house picker or unplaced-stock grid on the Inventory menu.
- Paper-doll property grids use catalog capacity by upgrade level. A new house is **10** slots, not 100.
- The two paper-doll weapon slots are the only weapons Crimes considers. Dropping a weapon from backpack or house storage onto a slot wears it. Taking it off (to backpack or house) unequips that slot. Moving a weapon only between backpack and storage does not change worn slots.
- The second-weapon slot uses `POST/DELETE /weapons/secondary-weapon` the same way. Crimes compare both worn slots at attempt time and pick the best match; wearing a weapon on the second slot is enough for it to be considered. The same `weaponId` cannot occupy both body slots (moving it switches slot). Withdrawing a weapon from a house onto a body slot may send `equip: true` so a full backpack does not block wearing it.
- Backpack upgrade visibility stays progression-clean: after buying a better backpack, lower or equal backpack tiers should no longer be shown as selectable shop options; only real upgrades remain visible. Higher catalog tiers stay listed even when rank or VIP is not met yet; buy stays locked until those gates pass.
- Catalog in `backend/content/backpacks.json`: small +5, medium +10, large +20, military +35, VIP tactical +50 (VIP, rank 25), **travel suitcase +70** (rank 30, not VIP-only). Capacity = 5 base + backpack slots. One owned bag at a time; suitcase is the current top upgrade.

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
- Verify a player can wear two different weapons at once (crime slot + second slot) and that worn weapons do not consume backpack capacity.
- Verify drag and tap-to-move between backpack and the Open-storage property grid, including materials/drugs/trade and a rejected drop (full, wrong country).
- Verify Open storage from a house or warehouse opens this screen with that property selected, and that the Inventory menu itself does not offer a house dropdown.
- Verify leftover country-depot materials still exist for production, but new buys go to the backpack.
- Verify a newly bought house shows 10 storage squares (not 100). An apartment starts at 5; a warehouse at 100.

## When To Update This File
Update this protocol when the module gains a new subflow, new dependency, new notification path, major UX change or new QA risk.
