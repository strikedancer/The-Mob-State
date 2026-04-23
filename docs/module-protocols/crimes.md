# Crimes Protocol

## Scope
Illegal action loop with rewards, failures, jail risk, cooldowns and supporting tools.

## Primary Frontend Entry
- client/lib/screens/crime_screen.dart

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
- No auto-playing video overlays in the crimes loop.
- Arrest feedback should be immediate message-first, optionally with a static image/icon indicator.
- Accurate state refresh after an action completes.
- Consistent formatting for money, timers, percentages and labels.
- Responsive usability without pushing critical actions off-screen.
- Crime pacing is reward-tier based, not flat-rate; low-reward crimes stay fast while high-reward crimes must pick up meaningfully longer cooldowns.
- Reward-tier cooldown changes must stay aligned between backend enforcement, player help copy and any cooldown-reset premium items that reference the crime loop.
- Drug requirement thresholds must stay aligned with gram-based drug inventory quantities; do not surface legacy `x` units in requirement feedback.
- Requirement failures for vehicle, weapon selection, weapon suitability and ammo must surface the concrete reason instead of collapsing into a generic internal error.
- If a crime requires a weapon, the player must be able to see and change the active crime-weapon selection directly from the crime flow or through an explicit nearby CTA.
- When a player is arrested after a weapon-based crime, the used crime weapon must be confiscated consistently with the arrest consequences shown to the player; if that was the last copy, the saved crime-weapon selection must no longer remain active.
- A crime that ends in arrest may not still surface as a clean success result in the UI; if police/FBI catch the player after the attempt, the final response must resolve as an arrest outcome with consistent vehicle/weapon confiscation messaging.
- Crime-specific special effects must be explicit in player feedback; if a crime wipes or alters judicial history, the success message must state that effect clearly.
- Wanneer een crime eindigt in arrestatie moet de social notification pipeline voor vrienden/crew worden getriggerd zonder de crime-respons te blokkeren.
- Munitie mag pas worden verbruikt nadat alle harde startvoorwaarden van de crime geldig zijn; een preflight requirement failure mag geen kogels kosten.

## i18n and Messaging
- Any new labels, warnings, helper text or dialogs must exist in both Dutch and English.
- If this module emits notifications, push messages or inbox events, keep the wording aligned across all channels.
- If player behavior changes, update the player help entry for this module.

## QA Checklist
- Open the module on mobile width, tablet width and desktop width.
- Run through the main success path and at least one failure or locked-state path.
- Verify the screen refreshes correctly after actions.
- Verify cooldowns, counters, balances or progress bars remain accurate.
- Verify crime cooldown duration matches the configured reward tier after a successful attempt.
- Verify no text overflows or clipped buttons appear.
- Verify weapon-required crimes clearly show which weapon is selected, block cleanly when no weapon is selected, and stay synced with Inventory after refresh/navigation.
- Verify vehicle-required crimes only accept the selected crime vehicle when that vehicle is actually available in the player's current country and not in transit or market-listed.
- Verify an arrest during a weapon-based crime confiscates the used weapon, clears the saved selection when no copy remains, and tells the player about the confiscation in the crime result feedback.
- Verify a crime that initially succeeds but ends in a police/FBI arrest no longer shows a success state, actually puts the player in jail, and applies the matching confiscation consequences.
- Verify a failed start caused by missing vehicle, unsuitable weapon or missing ammo does not consume ammunition.
- If a crime has a court-side effect, verify the linked court record updates after cooldown refresh and only the intended convictions are affected.

## When To Update This File
Update this protocol when the module gains a new subflow, new dependency, new notification path, major UX change or new QA risk.
