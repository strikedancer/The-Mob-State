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
- If a crime requires a weapon, the player must be able to see and change the active crime-weapon selection directly from the crime flow or through an explicit nearby CTA.
- Crime-specific special effects must be explicit in player feedback; if a crime wipes or alters judicial history, the success message must state that effect clearly.
- Wanneer een crime eindigt in arrestatie moet de social notification pipeline voor vrienden/crew worden getriggerd zonder de crime-respons te blokkeren.

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
- Verify weapon-required crimes clearly show which weapon is selected, block cleanly when no weapon is selected, and stay synced with Inventory after refresh/navigation.
- If a crime has a court-side effect, verify the linked court record updates after cooldown refresh and only the intended convictions are affected.

## When To Update This File
Update this protocol when the module gains a new subflow, new dependency, new notification path, major UX change or new QA risk.
