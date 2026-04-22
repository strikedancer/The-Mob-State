# Travel Protocol

## Scope
Country movement, route costs, legs, confiscation risk and travel cooldowns.

## Primary Frontend Entry
- client/lib/screens/travel_screen.dart

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
- Overweight and travel-blocking checks must use the real carried drug quantity in grams; do not reintroduce legacy `quantity * 100` conversions.

## i18n and Messaging
- Any new labels, warnings, helper text or dialogs must exist in both Dutch and English.
- If this module emits notifications, push messages or inbox events, keep the wording aligned across all channels.
- If player behavior changes, update the player help entry for this module.
- If travel copy references carried drugs or weight, describe those quantities as grams so the UI matches inventory semantics.

## QA Checklist
- Open the module on mobile width, tablet width and desktop width.
- Run through the main success path and at least one failure or locked-state path.
- Verify the screen refreshes correctly after actions.
- Verify cooldowns, counters, balances or progress bars remain accurate.
- Verify no text overflows or clipped buttons appear.

## Aircraft Reistijdbonus

Als een speler een privévliegtuig bezit, wordt de internationale reistijd korter:

| Vliegtuig         | Reistijdbonus |
|-------------------|---------------|
| Cessna 172        | −15%          |
| Beechcraft King Air | −25%        |
| Gulfstream G200   | −35%          |
| Boeing 737 Cargo  | −30%          |

- Backend loadt het beste vliegtuig van de speler in `travelService` via `aviationService.getBestAircraftBonus(playerId)`.
- Reistijd = `baseReistijd × (1 − bonus)`. Geen vliegtuig = geen bonus (geen regressie).
- Bonus moet zichtbaar zijn in het Travel scherm vóór vertrek: "Eigen vliegtuig: −X% reistijd" / "Own aircraft: −X% travel time".
- De bonus geldt voor alle luchtroutes. Waterroutes zijn niet beïnvloed door een vliegtuig.
- Afhankelijkheid: `aviationService.ts` (nieuw bestand).

## When To Update This File
Update this protocol when the module gains a new subflow, new dependency, new notification path, major UX change or new QA risk.
