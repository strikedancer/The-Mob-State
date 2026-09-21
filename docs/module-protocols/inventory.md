# Inventory Protocol

## Scope
Carried items, storage, loadouts and equipment used by multiple modules.

## Primary Frontend Entry
- client/lib/screens/inventory_screen.dart — two tabs: paper-doll (default) and Loadouts. Dashboard web uses `embedded: true` (no own Scaffold/AppBar; stays in the dashboard content card). **Open storage** from a property switches the dashboard section instead of pushing a fullscreen route.
- client/lib/screens/inventory_paper_doll_tab.dart
- Same screen opens from a house/warehouse via **Open storage** (`InventoryScreen(initialPropertyId: …)`)

## Paper-doll inventory
- Center: player avatar, crime-weapon slot (`GET/POST /weapons/crime-weapon`), second-weapon slot (`GET/POST /weapons/secondary-weapon`), worn vest (`GET /security/status`) and crime-car slot (`GET/POST/DELETE /garage/crime-vehicle`). The crime car is chosen here, not on garage car cards. Only cars in the current country that are not in repair, in transit or listed for sale can be selected.
- A player can wear two weapons at once (for example a handgun and a rifle). When a crime is committed, both worn slots are compared and the best eligible weapon for that crime is used automatically. Worn SMGs (catalog type `automatic`) count for crimes that ask for `smg`.
- Worn weapons are hidden from the backpack grid and do not count toward backpack capacity. Unequipped extra copies still do.
- Backpack grid shows `capacity` squares from `GET /tools/carried` slot meter, filled with carried tools, unequipped weapons, ammo, materials, **finished drugs** and **trade goods**. Occupied stacks split into physical cells the same way as property storage (trade uses per-good `unitsPerTile` from `tradableGoods.json`, e.g. perfume/diamonds **10 per square**, coffee **5**), so 19 perfume fill two backpack squares (10 + 9).
- The Inventory **menu** shows paper-doll + backpack only. There is no remote house dropdown and no unplaced-stock grid. To stash or withdraw, the player goes to **Properties → that building → Open storage**, which opens this screen with that property selected.
- Property grid (right on desktop, below on mobile) appears **only** when opened via Open storage on a house/apartment/warehouse **in the current country**. Other-country houses stay hidden until the player travels there (`inventoryOtherCountryStashHint`). Backpack squares match `GET /tools/carried` capacity (no 8-slot floor).
  - House / apartment / mansion / penthouse / safehouse: **tools**, weapons, ammo, armor, cash, **materials, finished drugs, trade goods**. Safer on arrest. Slot count comes from `properties.json` `storageCapacity` at the building's upgrade level (house 10→95, apartment 5→38), not the legacy `property_storage_capacity` row. The property grid always shows `capacity` squares (empty house = 10). Occupied stacks are split into physical cells (145g drugs = 100 + 45). A partial cell of the same type can be topped up to a full slot.
  - Warehouse: the same stash types. Police/FBI search this building in the arrest country (~40% seize, including materials/drugs/trade).
- Buy/collect credits the **backpack** (`DrugInventory`, `inventory.country = _carried_`, materials `_carried_`). Collect never auto-sends drugs to a nightclub. Storing from the backpack into an owned nightclub (`POST /nightclub/:id/drugs/store` or `store-all`) must delete/decrement `DrugInventory` and refresh `inventory_slots_used` so the next harvest can fit. Nightclub stock does **not** consume backpack slots. The player must visit a house or warehouse to place other stock, and withdraw to the backpack before selling, smuggling or flying. Flying with backpack goods is self-smuggling; commercial travel and hangar Fly can confiscate carried drugs/trade/materials. Police/FBI arrest seizes ~40% of the backpack. Leftover current-country trade lots (legacy country rows) stay sellable here but do **not** consume backpack slots.
- Slot costs in property grids: materials `ceil(qty/5)`, drugs **100g/slot per quality**, ammo **50 rounds/slot**, trade **`ceil(qty / unitsPerTile(goodType))`** (catalog `unitsPerTile`, derived from `weight`: 1→10, 2→5, 3→3, 4+→2). Same packing applies to crew trade/drug/ammo bays and owned smuggle cargo. Same quality first fills that leftover cell (45g C + 55g C = 100). A different quality (61g B) stays on its own cells. The grid shows a quality letter and transfer dialogs name the quality so B is not mistaken for C. Almanac trade pages show **Per tile** (`unitsPerTile`).
- Server backpack usage (`calculateInventoryUsage` / `GET /tools/carried`) counts carried tools, unequipped weapons, carried materials, drugs, **carried trade** and **ammo** (50 rounds/slot). Ammo buy checks backpack slots. Weapon/ammo deposit refreshes `inventory_slots_used`. Partial house deposits return the stored quantity so the client can say leftover stayed in the backpack.
- Drag on desktop/web; tap-select then tap-target everywhere (mobile fallback). Each drop is one API call; no optimistic client move.
- Stacks with quantity > 1 (ammo, materials, stacked weapons/tools) open a quantity dialog: move 1, move all, or a custom amount.
- Transfers: weapons `POST /properties/storage/:id/weapons/deposit|withdraw` (house-to-body may send `equip: true`), body slots `POST/DELETE /weapons/crime-weapon` and `/weapons/secondary-weapon`, tools `POST /tools/transfer`, materials/drugs/trade `POST /properties/storage/:id/materials|drugs|trade/deposit|withdraw` (backpack ↔ that property only), ammo/armor `POST /properties/storage/:id/ammo|armor/deposit|withdraw`.
- Invalid drop surfaces the server reason (`INVENTORY_FULL`, `STORAGE_FULL`, `WRONG_COUNTRY`, `STORAGE_TYPE_NOT_ALLOWED`, `ARMOR_ALREADY_EQUIPPED`).
- Out of scope here: nightclub venue stock (unprefixed `drugs` keys), crew storage, garage vehicle management (steal/repair/sell), cash-drag. Crime-car selection lives on the paper doll.

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
- Shared equipment choices that other modules depend on, such as worn weapon slots and the crime-car slot, must stay visible and must remain in sync with the consuming gameplay screen.
- Inventory storage is **current-country only** and only the building opened via **Open storage**. Do not show a house picker or unplaced-stock grid on the Inventory menu.
- `refreshInventorySlotUsage` retries MariaDB 1020 on `player.update` so backpack seize/travel/trade can finish when another request touched the same player row.
- Paper-doll property grids use catalog capacity by upgrade level. A new house is **10** slots, not 100. The grid always has `capacity` squares; multi-slot stacks occupy one icon per slot. The backpack grid uses the same split against `GET /tools/carried` capacity.
- Houses accept tools. Warehouse search on arrest still only hits warehouses.
- The two paper-doll weapon slots are the only weapons Crimes considers. Dropping a weapon from backpack or house storage onto a slot wears it. Taking it off (to backpack or house) unequips that slot. Moving a weapon only between backpack and storage does not change worn slots.
- The second-weapon slot uses `POST/DELETE /weapons/secondary-weapon` the same way. Crimes compare both worn slots at attempt time and pick the best match; wearing a weapon on the second slot is enough for it to be considered. The same `weaponId` cannot occupy both body slots (moving it switches slot). Withdrawing a weapon from a house onto a body slot may send `equip: true` so a full backpack does not block wearing it.
- Backpack upgrade visibility stays progression-clean: after buying a better backpack, lower or equal backpack tiers should no longer be shown as selectable shop options; only real upgrades remain visible. Higher catalog tiers stay listed even when rank or VIP is not met yet; buy stays locked until those gates pass.
- Catalog in `backend/content/backpacks.json`: small +5, medium +10, large +20, military +35, VIP tactical +50 (VIP, rank 25), **travel suitcase +70** (VIP, rank 30). Capacity = 5 base + backpack slots. One owned bag at a time; suitcase is the current top upgrade. VIP-only bags use `isVipStatusActive` (`isVip` + `vipExpiresAt`); Player has no `vipStatus` field.
- Storing drugs from the backpack into a nightclub deletes empty `DrugInventory` rows and refreshes `inventory_slots_used`.

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
- Verify the crime-car slot on the paper doll sets `POST /garage/crime-vehicle` and that garage car cards no longer show Select/Deselect.
- Verify a player can wear two different weapons at once (crime slot + second slot) and that worn weapons do not consume backpack capacity.
- Verify drag and tap-to-move between backpack and the Open-storage property grid, including materials/drugs/trade and a rejected drop (full, wrong country).
- Verify Open storage from a house or warehouse opens this screen with that property selected, and that the Inventory menu itself does not offer a house dropdown.
- Verify leftover country-depot materials still exist for production, but new buys go to the backpack.
- Verify leftover current-country trade lots remain sellable but do not fill backpack slots or block new black-market buys after the player stores `_carried_` goods in a house.
- Verify a newly bought empty house shows 10 free squares (not 100). After storing 145g of one drug, the house shows two cells (100 + 45) and the leftover 45g cell can be topped up to 100g without using a new slot. An apartment starts at 5; a warehouse at 100.
- Verify 19 backpack perfume occupy two squares (10 + 9) while `Rugzak` reads the matching used/max.
- Verify tools can be stored in a house/apartment as well as a warehouse.
- Verify an active VIP can buy/upgrade VIP Tactical (rank 25) and the suitcase (rank 30); `vip_only` must not fire when `isVip` is true and not expired.
- Verify nightclub store-all empties backpack drug lots and the next harvest fits if other carried items leave room.

## When To Update This File
Update this protocol when the module gains a new subflow, new dependency, new notification path, major UX change or new QA risk.
