# Prostitution Protocol

## Scope
Recruitment, event participation, rivalry, cooldowns and prostitution income loop.

Belangrijke configuratieknoppen (Admin Config):
- PROSTITUTION_BALANCE_PROFILE
- VIP_HOUSING_BONUS_PER_PROPERTY
- PROSTITUTION_HOUSING_RENT_STANDARD_PER_DAY
- PROSTITUTION_HOUSING_RENT_VIP_PER_DAY

Deze waarden sturen housing capaciteit/risico en weekhuur in de prostitutieflow.

## Primary Frontend Entry
- client/lib/screens/prostitution_screen.dart — **Empire hub** tabs: Workers | RLD | Events | Social
- Shared widgets: `client/lib/widgets/prostitution/` (KPI strip, section header, empty/error, social tab)
- Deep-links: `/prostitution` with `tabIndex` args or `?tab=rld|events|social`; `/prostitution-leaderboard` and `/prostitution-rivalry` remain

## Change Rules
- Preserve the core player loop and avoid hidden behavior changes.
- Keep Dutch and English copy in sync for any user-visible change.
- Keep layout usable on mobile, tablet and desktop if this module is reachable in the dashboard shell.
- Do not silently remove existing rewards, cooldowns or risk gates without updating help and release notes.
- UI surfaces (Collect earnings, recruit ceremony, rivalry history labels) must not invent new gameplay rules — only present existing APIs.

## Check Before Editing
- What is the player trying to achieve in this screen or loop?
- Which timers, locks, rank gates or country rules affect the flow?
- Does this module send notifications, inbox messages, rewards or achievements?
- Does this module depend on assets, videos, icons or generated media?

## Must Preserve
- Collect-label is “Nu ophalen” / “Collect now” en toont een last-settle hint. Tick blijft automatisch verrekenen.
- Clear success and failure feedback for the player.
- Accurate state refresh after an action completes.
- Consistent formatting for money, timers, percentages and labels.
- Responsive usability without pushing critical actions off-screen.
- Weekly housing rent weergave moet overeenkomen met backend-config (standaard/VIP dagtarief x 7).
- Rivaliteit starten accepteert **spelersnaam of numeriek ID** (`POST /rivalries/start` met `rivalUsername` en/of `rivalPlayerId`); het challenge-veld mag geen puur-numeriek toetsenbord forceren.
- 8u work / 8u rest shifts; earnings verschillen per locatie (street / RLD / nightclub).
- Worker cards: hoogte volgt content (geen bottom-clip op web/tablet/desktop).

## Empire hub IA
- Tab 0 Workers: KPI strip (workers S/RLD/NC, €/h, collectable, housing, recruit CD), Collect → `settleEarnings`, recruit result via **`CrimeResultOverlay`** (same pattern as jobs/crimes; success + fail), Move menu + Work primary.
- Tab 1 RLD: embedded `RedLightDistrictsScreen` (mobile RLD-menu and web sidebar deep-link hierheen, niet VIP Events).
- Tab 2 Events: dark VIP event cards with participate/leave.
- Tab 3 Social: Rivalry + Leaderboard segments (no nested chaos beyond existing period tabs).

## i18n and Messaging
- Any new labels, warnings, helper text or dialogs must exist in both Dutch and English.
- If this module emits notifications, push messages or inbox events, keep the wording aligned across all channels.
- If player behavior changes, update the player help entry for this module.
- Rivalry challenge copy (`rivalryChallengeHint`, `rivalryPlayerIdHint`) must mention name (and optional ID), not ID-only.

## QA Checklist
- Open the module on mobile width, tablet width and desktop width.
- Run through the main success path and at least one failure or locked-state path.
- Verify the screen refreshes correctly after actions.
- Verify cooldowns, counters, balances or progress bars remain accurate.
- Verify no text overflows or clipped buttons appear.
- Verify prostitute cards in Workers are never bottom-clipped; card height must follow content (auto height) on web/tablet/desktop.
- Verify Collect settles pending earnings and refreshes KPI; empty collect shows empty copy.
- Verify mobile “Red Light Districts” opens hub tab RLD (index 1), not Events.

## When To Update This File
Update this protocol when the module gains a new subflow, new dependency, new notification path, major UX change or new QA risk.
