# Security Protocol

## Scope
Armor, defense level and survivability settings for conflict-heavy gameplay.

## Primary Frontend Entry
- client/lib/screens/security_screen.dart

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

## When To Update This File
Update this protocol when the module gains a new subflow, new dependency, new notification path, major UX change or new QA risk.
