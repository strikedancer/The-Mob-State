# Security Protocol

## Scope
Armor, defense level and survivability settings for conflict-heavy gameplay.

## Primary Frontend Entry
- `client/lib/screens/black_market_screen.dart` — shop **Security** (`BlackMarketScreen.tabSecurity`)
- `client/lib/screens/security_screen.dart` — embedded vest/bodyguard body (`embedded: true`)
- Named route `/security` opens the Black Market Security shop.

## Change Rules
- Preserve the core player loop and avoid hidden behavior changes.
- Keep Dutch and English copy in sync for any user-visible change.
- Keep layout usable on mobile, tablet and desktop if this module is reachable in the dashboard shell.
- Do not silently remove existing rewards, cooldowns or risk gates without updating help and release notes.
- Bodyguard upkeep must be explicit: recurring cost, next charge moment and dismissal-on-nonpayment must remain visible in both logic and UI.
- Armor effectiveness must reflect wear: damaged armor gives less defense and disappears when fully destroyed.
- Armor remains a single active slot: players can wear only one vest at a time, and replacement UX must make that explicit.
- A vest may sit in residential property storage (`armor:{type}` + condition). Equipping from the house or dropping onto the avatar wears it; depositing the worn vest stores it and clears `armorType`. A second worn vest is refused (`ARMOR_ALREADY_EQUIPPED`). Without a vest, `armorType` is empty.
- Shop catalog lives in `backend/content/security.json` (`shop: true`). Current buyable types: `stab_vest` (€7,500, stab only), `bulletproof_vest` (€50,000, regular bullets), `bulletproof_vest_premium` (€125,000, stronger regular bullets), `ceramic_ap_vest` (€280,000, stab + bullets + armor-piercing). Legacy IDs (`light_armor`, `heavy_armor`, `tactical_suit`) stay wearable if already owned but are not sold.
- Combat uses type match, not only raw armor: melee checks `resistsStab`, regular ammo checks `resistsBallistic`, and `556mm` / `762mm` / `308` (`armorPiercing` in `ammo.json`) check `resistsArmorPiercing`. A mismatch keeps only a fraction of the vest defense.
- Personal vest + bodyguards apply in **hitlist murder combat** (win chance) and **crime HP loss** (each attempt, cap 55% reduction). They do **not** replace crew/territory, nightclub or red-light district security. Hit attempts return a `combat` breakdown (`armorDefense`, `bodyguardDefense`, `winChancePercent`, `vestMatch`); a failed hit sets `defended: true`, keeps the contract **ACTIVE**, kills roughly 25–55% of remaining guards (elite first), drops target HP (floor 1) and wears the vest. `hit_list.lastCombatAt` blocks the next attempt for 10 minutes (`HIT_COMBAT_COOLDOWN`).
- Detective intel on a live hit uses bodyguard defense vs tier pierce (Quick 40 / Standard 90 / Deep 160): full report, partial (country only, counts hidden), or blocked (no country). **Deep never fully blocks** — a Slow report always leaks country, even against a paid max elite stack (10×22 = 220). After 48h offline (`player.lastTickAt`) intel steps up one clarity level; after 7 days the report is always full. After a kill, the killer's remaining bodyguards lower murder-case identify chance (`murderCaseSolveChance`, floor 20%); that penalty halves after 48h offline and drops after 7 days. Paid upkeep still runs while offline, so combat protection can stay until cash runs out — only intel and murder-case ID decay.
- Worn-vest **repair** is `POST /security/repair-armor`. Cost is 50% of catalog price × missing condition (`securityEconomy.armorRepairCost`). Repair restores condition to 100% and keeps the same vest. A 100% vest cannot be repaired (`ARMOR_NOT_DAMAGED`).
- Buying a **different** vest applies a **trade-in**: 40% of the old vest price × current condition (`securityEconomy.armorTradeInCredit`). The player pays `max(0, newPrice - credit)` and does not get cash back. Buying the same damaged vest is a full-price replace; the shop shows Repair instead.
- Bodyguards have three hire types and a shared cap of **10**: street (€6,000, +8, €4,000/day), standard (€10,000, +10, €10,000/day, stored in `bodyguards`), elite (€35,000, +22, €18,000/day). Existing counts above the cap stay, but hiring is blocked until the player is under the cap. `POST /security/dismiss-bodyguards` removes one of a type. Combined daily upkeep still dismisses **all** types on non-payment.
- Shop thumbs live in `client/assets/images/security/<armorId>.png`. The status payload includes `bodyguardCounts`, `bodyguardDefense`, `bodyguardCatalog`, `armorRepairCost`, `armorTradeInCredit`, `armorWeaknesses` and per-catalog `netPrice` / `repairCost`.

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
- Attack resolution, investigation reports and the Security screen must all use the same effective armor/bodyguard numbers.
- Mobile-width layouts must keep the security status summary readable without row overflow or clipped stats.

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
- Verify bodyguard upkeep deducts every 24 hours and dismisses guards when the player cannot pay.
- Verify armor purchase succeeds, armor condition drops after an attack, and destroyed armor no longer contributes defense.
- Verify storing the worn vest in a house unequips it, and withdrawing it equips it only when no vest is already worn.
- Verify a damaged vest shows Repair (not full-price Replace) and restores 100% condition.
- Verify buying a different vest subtracts the shown trade-in and replaces the worn vest.
- Verify street/standard/elite hire, dismiss, and the 10-guard cap; over-cap players cannot hire more.

## When To Update This File
Update this protocol when the module gains a new subflow, new dependency, new notification path, major UX change or new QA risk.
