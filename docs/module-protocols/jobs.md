# Jobs Protocol

## Scope
Legal work loop with payouts, requirements and cooldown-based progression.

## Primary Frontend Entry
- client/lib/screens/jobs_screen.dart
- Client loads via `GET /jobs/available` (available + education-locked jobs; includes active job `cooldown` when present).

## Change Rules
- Preserve the core player loop and avoid hidden behavior changes.
- Keep Dutch and English copy in sync for any user-visible change.
- Keep layout usable on mobile, tablet and desktop if this module is reachable in the dashboard shell.
- Web dashboard Jobs hides the inner AppBar title (“Banen” / “Jobs”); the sidebar already shows the section. Keep the AppBar on standalone / mobile push routes.
- Do not silently remove existing rewards, cooldowns or risk gates without updating help and release notes.

## Check Before Editing
- What is the player trying to achieve in this screen or loop?
- Which timers, locks, rank gates or country rules affect the flow?
- Does this module send notifications, inbox messages, rewards or achievements?
- Does this module depend on assets, videos, icons or generated media?

## Must Preserve
- Clear success and failure feedback for the player.
- After a successful job, show the same style of earnings result overlay as crimes before the cooldown screen (money + XP, then Continue).
- Accurate state refresh after an action completes.
- Consistent formatting for money, timers, percentages and labels.
- Responsive usability without pushing critical actions off-screen.
- Job pacing is reward-tier based; higher-paying jobs may not reuse a flat global cooldown if backend pacing has moved to dynamic cooldown seconds.
- Soft balancing via sessieblokken (diminishing returns) mag alleen payout-rate afvlakken en mag nooit eindeloze progressieloops vervangen door harde caps.
- Job success/failure semantics in help copy must match the actual backend logic; do not document jobs as guaranteed success if the service can still fail.
- Jobs require health, not jail, and not ICU. There is no hunger/thirst gate.
- Success chance scales by payout tier (entry ~92%, mid ~85%, elite ~78%), with school-track bonuses on gated jobs and a penalty for repeating the same job consecutively.
- Education gates apply to mechanic, paramedic, accountant, programmer, lawyer, doctor, and airline pilot.
- Job flavor events (tips, failed shift stories) and street-intel inbox drops can fire on work attempts; intel jobs: taxi, security, bartender, pizza delivery, truck driver.
- Admin NPCs must call `jobService.workJob` with the current job IDs and education gates, not a parallel payout path.

## i18n and Messaging
- Any new labels, warnings, helper text or dialogs must exist in both Dutch and English.
- If this module emits notifications, push messages or inbox events, keep the wording aligned across all channels.
- If player behavior changes, update the player help entry for this module.

## QA Checklist
- Open the module on mobile width, tablet width and desktop width.
- On web dashboard Jobs, verify there is no extra “Banen”/“Jobs” title above the honest-work hero; the shared status bar stays.
- Run through the main success path and at least one failure or locked-state path.
- Verify the screen refreshes correctly after actions.
- Verify cooldowns, counters, balances or progress bars remain accurate.
- Verify low-, mid- and high-tier jobs receive the expected cooldown duration based on max payout.
- Verify failed jobs still return coherent player feedback and do not silently deduct money or health.
- Verify no text overflows or clipped buttons appear.

## When To Update This File
Update this protocol when the module gains a new subflow, new dependency, new notification path, major UX change or new QA risk.
