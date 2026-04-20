# Dashboard Protocol

## Scope
Global player overview, navigation shell, timers, live events and quick access.

## Primary Frontend Entry
- client/lib/screens/dashboard_screen.dart

## Change Rules
- Preserve the core player loop and avoid hidden behavior changes.
- Keep Dutch and English copy in sync for any user-visible change.
- Keep layout usable on mobile, tablet and desktop if this module is reachable in the dashboard shell.
- Do not silently remove existing rewards, cooldowns or risk gates without updating help and release notes.
- Web dashboard navigation is sidebar-first: add or change module navigation via the sidebar source (`_buildWebMenuItems` + `_WebSection` content switch) and not only via the legacy tile grid.

## Check Before Editing
- What is the player trying to achieve in this screen or loop?
- Which timers, locks, rank gates or country rules affect the flow?
- Does this module send notifications, inbox messages, rewards or achievements?
- Does this module depend on assets, videos, icons or generated media?

## Must Preserve
- Clear success and failure feedback for the player.
- Accurate state refresh after an action completes.
- Consistent formatting for money, timers, percentages and labels.
- Dashboard statistiekblokken mogen geen hardcoded nul-placeholders tonen wanneer er al echte backendtellers of bestaande spelerstats beschikbaar zijn.
- Responsive usability without pushing critical actions off-screen.
- In web/dashboard-shell context moet klik op dezelfde sectie een expliciete remount of refresh kunnen triggeren wanneer dat scherm anders vastloopt op stale state.
- Info- en statistiekblokken in dashboard/admin views moeten ook bij subtiele backgrounds en in dark mode expliciete contrasten voor tekst, border en hover/focus-state behouden.
- Admin image-management flows voor extern gehoste server-assets moeten zowel toevoegen als vervangen ondersteunen zonder handmatige shell-stappen; mapnavigatie en bestandsfeedback (preview/pad/grootte/update-tijd) blijven verplicht zichtbaar.
- Admin image-management moet ook modulegerichte discovery ondersteunen: operators moeten per module (zoals drugs/school/vehicles) afbeeldingen kunnen filteren en op bestandsnaam/pad kunnen zoeken.
- Deploys met externe image-opslag moeten een expliciete image-root voor admin upload/listing instellen (bijv. `IMAGE_LIBRARY_ROOT_PATH`), zodat beheer niet afhankelijk is van toevallige container paden.
- Runtime image-serving (`/assets/images`) moet dezelfde rootconfig gebruiken als admin image-management (`IMAGE_LIBRARY_ROOT_PATH`) zodat uploaden, vervangen en direct renderen altijd dezelfde storage aanspreken.

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
- Verify new dashboard navigation entries are visible and clickable in the web sidebar; treat tile-grid visibility as secondary fallback only.
- Verifieer in admin image-management dat uploaden en vervangen werkt voor dezelfde storage-root die door runtime `/assets/images` wordt geserveerd.
- Verifieer dat modulefilter + zoekresultaten overeenkomen met de daadwerkelijke serverbestanden per module.

## When To Update This File
Update this protocol when the module gains a new subflow, new dependency, new notification path, major UX change or new QA risk.
