# Gym Protocol

> **Player UI:** Gym and shooting range are combined in the **training hub** (`client/lib/screens/training_hub_screen.dart`). See [training-hub.md](training-hub.md).

## Scope
Physical stat training, gym status, training cooldown and long-term combat growth.

## Three tracks (server)
- **Strength / speed / stamina:** separate session counters (`sessionsCompleted`, `speedSessionsCompleted`, `staminaSessionsCompleted`), last-train timestamps and **1h** cooldowns per track (VIP reduction unchanged). Each track caps at **100** sessions.
- **Crime bonus:** `gymService.computeAggregateGymBonus` — at full progress **+4% + 2% + 2% = +8%** success chance from gym alone; stored aggregate on `gym_stats.strengthBonus` for `crimeService`.
- **Train:** `POST /gym/train` body `{ "track": "strength" | "speed" | "stamina" }` (omit or invalid → strength). Legacy clients that post without `track` still train strength only.
- **Migration `20260503140000_gym_three_tracks`:** copies legacy `sessionsCompleted` into speed and stamina counters and recomputes `strengthBonus` so totals match the old single-track formula until the player diverges.

## Primary Frontend Entry
- `client/lib/screens/training_hub_screen.dart` (gym section; API `/gym`)

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
