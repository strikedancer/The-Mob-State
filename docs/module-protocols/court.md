# Court Protocol

## Scope
Judicial recovery, sentence handling and legal consequence flows.

## Primary Frontend Entry
- client/lib/screens/court_screen.dart

## Active Backend Endpoints
- GET `/trial/current-sentence`
- GET `/trial/record`
- POST `/trial/appeal`
- POST `/trial/bribe`

## Current System Contract
- Court screen must load sentence and criminal record independently and remain usable when one part is empty.
- Active sentence state must show: crime, total sentence, remaining time, judge profile and action buttons.
- Appeal can be submitted once per crime attempt and follows appeal cooldown rules.
- Bribe always deducts offered money and can either release player immediately or fail without release.
- Criminal record must remain visible both while jailed and while free.

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
- Verify `/trial/current-sentence` and `/trial/record` both return stable payloads and client handles `sentence: null`.
- Verify `POST /trial/appeal` returns cooldown block on rapid retry and updates remaining sentence on success.
- Verify `POST /trial/bribe` deducts balance in both success and failure paths.

## When To Update This File
Update this protocol when the module gains a new subflow, new dependency, new notification path, major UX change or new QA risk.
