# Hospital Protocol

## Scope
Health recovery, ICU state, heal cooldowns and medical lock handling.

The hospital is the **paid, immediate reset** when crimes or hits drop HP. Waiting is free (+5 HP per game tick) but you keep a crime-success penalty until 70+ HP. Hitting 0 HP is ICU (3 hours, no crimes/jobs, release at 10 HP).

## Strategy (player loop)
- Crimes cost ~5–15 HP (vest/bodyguards cut up to ~55%). Hits also cost HP.
- **Fit (≥70):** no crime penalty.
- **Wounded (<70 / <40 / <20):** −4% / −8% / −12% crime success (already in the listed % on crime cards).
- **Paid heal:** standard €10k / +30 HP, intensive €20k / +75 HP, shared 60 min cooldown (VIP −10%).
- **Emergency Help:** player-pressed button only below 10 HP, free +20 HP, no cooldown. Not automatic.
- **ICU:** automatic at 0 HP for 180 minutes. `checkICUStatus` returns remaining **minutes**.
- There is no school-medicine discount and no crew-medic heal outside this screen.

## Related APIs
- `GET /hospital/info` includes `injuryRules`, `icuMinutes`, `passiveHealPerTick`, `emergencyHealAmount`.
- Crime list `GET /crimes` `params.healthPenaltyPercent` drives the wounded banner.

## Primary Frontend Entry
- client/lib/screens/hospital_screen.dart

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

## When To Update This File
Update this protocol when the module gains a new subflow, new dependency, new notification path, major UX change or new QA risk.
