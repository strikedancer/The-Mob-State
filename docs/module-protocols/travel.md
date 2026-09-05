# Travel Protocol

## Scope
Country movement, route costs, legs, confiscation risk and travel cooldowns.

## Primary Frontend Entry
- client/lib/screens/travel_screen.dart

## Change Rules
- Preserve the core player loop and avoid hidden behavior changes.
- Keep Dutch and English copy in sync for any user-visible change.
- Keep layout usable on mobile, tablet and desktop if this module is reachable in the dashboard shell.
- Web dashboard Travel hides the inner AppBar title; keep the shared status bar. The screen uses a noir hero (current country, destination count, Wanted/FBI) and compact destination cards. The current country is pinned to the top of the list.
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
- Directe routes (1 etappe) mogen nooit in een in-transit state blijven hangen; na cooldown moet de reis als afgerond gelden zonder extra "Verder"/"Annuleren" stap.
- Travel cooldown-copy moet exact gelijk lopen met de backend cooldown (momenteel 60 minuten per vlieg-etappe) en mag niet hardcoded afwijken.
- Travel cooldown moet ondersteund zijn door Premium/Credits `ACTION_COOLDOWN_RESET` met `actionType=travel`, inclusief correcte `canRedeemNow` status op actieve cooldown.

## i18n and Messaging
- Any new labels, warnings, helper text or dialogs must exist in both Dutch and English.
- If this module emits notifications, push messages or inbox events, keep the wording aligned across all channels.
- If player behavior changes, update the player help entry for this module.
- If travel copy references carried drugs or weight, describe those quantities as grams so the UI matches inventory semantics.

## QA Checklist
- Open the module on mobile width, tablet width and desktop width.
- On web dashboard Travel, verify there is no extra “Reizen” AppBar title, the current country sits first with a green “here” treatment, and destination rows stay one compact card with cost/legs/Reis.
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
