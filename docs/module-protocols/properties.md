# Properties Protocol

## Scope
Property buying, upgrading, utility and ownership rules.

Scope-afbakening:
- Shop valt buiten deze module en wordt hier niet getoond of geclaimd.
- Nightclub is wél koopbaar via deze module (aankoop start het nachtclub-systeem); beheer van de nachtclub zelf vindt echter plaats in de aparte Nightclub-module.
- Deze module richt zich op house/apartment/warehouse/nightclub (en eventuele toekomstige property types die expliciet aan deze flow gekoppeld zijn).
- **Development (v1):** permanente income-boost per eigendom via bank-spend (`developmentLevel` / `lastDevelopAt`), los van warehouse capacity upgrades.

## Primary Frontend Entry
- client/lib/screens/property_screen.dart
- client/lib/widgets/property_card.dart (Develop-actie)

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
- Backend en frontend moeten dezelfde zichtbaarheid hanteren voor property types (geen verborgen type dat toch via API claimbaar blijft).
- Property development: bank-only cost, max level + cooldown via runtime keys, income multiplier applies consistently in passive income calc.
- Develop UI: confirm dialog, mapped errors, cooldown remaining on `/properties/mine` + 429 params, and card stats for level/bonus/income.

## i18n and Messaging
- Any new labels, warnings, helper text or dialogs must exist in both Dutch and English.
- If this module emits notifications, push messages or inbox events, keep the wording aligned across all channels.
- If player behavior changes, update the player help entry for this module.

## Development Runtime Keys
- `PROPERTY_DEVELOP_ENABLED`
- `PROPERTY_DEVELOP_MAX_LEVEL` (default 5)
- `PROPERTY_DEVELOP_COST_PERCENT_OF_PURCHASE` (default 25; cost scales with next level)
- `PROPERTY_DEVELOP_INCOME_BONUS_PERCENT_PER_LEVEL` (default 8)
- `PROPERTY_DEVELOP_COOLDOWN_SECONDS` (default 3600)

Endpoint: `POST /properties/:id/develop`

## QA Checklist
- Open the module on mobile width, tablet width and desktop width.
- Run through the main success path and at least one failure or locked-state path.
- Verify the screen refreshes correctly after actions.
- Verify cooldowns, counters, balances or progress bars remain accurate.
- Verify no text overflows or clipped buttons appear.
- Verify shop is not returned in properties list endpoints and cannot be claimed via properties flow.
- Verify nightclub is visible in properties list and can be purchased (creating a nightclubVenue record).
- Verify develop spends bank, raises `developmentLevel`, and increases passive income display/calc.

## When To Update This File
Update this protocol when the module gains a new subflow, new dependency, new notification path, major UX change or new QA risk.
