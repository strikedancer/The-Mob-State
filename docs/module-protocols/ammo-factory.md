# Ammo Factory Protocol

## Scope
Factory ownership, production, market stock, upgrades and ammo economy balance.

## Primary Frontend Entry
- client/lib/screens/ammo_factory_screen.dart

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

## Balance / pacing
- Production throughput is driven by `PRODUCTION_INTERVAL_MINUTES` and per-tick output multipliers in `backend/src/services/ammoFactoryService.ts`. Player-facing copy (NL/EN) must stay aligned with the server interval when it changes (Help & Uitleg, factory screen, ARB fallbacks).
- **Aug 2026 pacing:** claim interval **20 minutes** (`PRODUCTION_INTERVAL_MINUTES`), `BASE_ROUNDS_PER_TICK=3` (was 10 min / 5 rounds). Combined ~70% lower market fill vs prior values. Client estimate constants in `ammo_factory_screen.dart` must match.
- Cross-cutting economy rules: `docs/module-protocols/balance-economy.md` (small steps, avoid multiple curve shifts at once).

## Must Preserve
- Clear success and failure feedback for the player.
- Accurate state refresh after an action completes.
- Consistent formatting for money, timers, percentages and labels.
- Responsive usability without pushing critical actions off-screen.
- The Ammo Factory screen is for ownership, upgrades and production status; direct ammo buy/sell flows belong to the Black Market and should be linked there instead of being embedded here.
- Read-only ownership/status loads must not mutate factory ownership; inactivity forfeiture may only be resolved by an owner action or a contested purchase flow, never by simply opening the screen after travel.

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
- Verify the factory screen no longer offers direct ammo market trading and instead routes the player clearly to the Black Market ammo tab.
- Verify traveling away and back, then reopening Ammo Factory, does not silently turn an owned factory into `for sale` just because the screen was viewed.

## When To Update This File
Update this protocol when the module gains a new subflow, new dependency, new notification path, major UX change or new QA risk.
