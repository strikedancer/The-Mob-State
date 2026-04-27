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
- Premium & Credits is a first-class dashboard destination when premium purchases or wallet actions are exposed to players; wire it into the sidebar and keep direct route entry (`/premium`) working for payment return flows.

## Check Before Editing
- What is the player trying to achieve in this screen or loop?
- Which timers, locks, rank gates or country rules affect the flow?
- Does this module send notifications, inbox messages, rewards or achievements?
- Does this module depend on assets, videos, icons or generated media?

## Must Preserve
- Clear success and failure feedback for the player.
- Accurate state refresh after an action completes.
- Consistent formatting for money, timers, percentages and labels.
- Dashboard shell en hoofdpanelen moeten visueel aansluiten op de game-identiteit (noir/gold), met nadruk op leesbaar contrast, subtiele gradients en duidelijke scheiding tussen navigatie, content en quick actions in plaats van vlakke donkere blokken.
- Dashboard statistiekblokken mogen geen hardcoded nul-placeholders tonen wanneer er al echte backendtellers of bestaande spelerstats beschikbaar zijn.
- Dashboard moet een complete baseline blijven tonen voor: economy (cash/bank/portfolio/net worth), cooldown-operaties, risicosignalen, notificaties en 24u/7d trendstatistieken; nieuwe modules die deze domeinen raken moeten hierop inhaken.
- “Wat nu?” is optioneel; als we het tonen moet het compact blijven en mag het nooit primaire statistiekpanelen blokkeren of verstoppen. Als we het niet tonen, moeten doelen/recap nog steeds logisch vindbaar blijven.
- Voor reward-gevoel en transparantie mag het dashboard een compacte **sessie recap** tonen (laatste events in deze sessie) zodat spelers direct zien wat acties opleverden. Dit mag de primaire loop niet onderbreken en moet optioneel/openklapbaar blijven.
- Plaats **Dagdoelen/Weekdoelen** bij voorkeur **onderaan de linker kolom** (onder het speler/economie paneel) zodat de kerninformatie eerst scanbaar blijft; op compact scherm mag dit direct onder de eerste kaart of onder de laatste hoofdkaart als extra sectie.
- Weekdoelen moeten claimbaar zijn wanneer ze als “klaar”/“ready” worden getoond; zorg dat weekly-claims dezelfde window/key gebruiken als de weekdoelen-status (week start maandag UTC) zodat “1 klaar om te claimen” nooit in een claim-fout resulteert.
- Claims en beloningen mogen niet falen door DB transaction timeouts: doe alleen de noodzakelijke DB-writes in de transaction en schrijf activity/world events best-effort ná commit.
- Gekoppelde moduledata zoals Crew Wars mag dashboardstatistieken nooit als alles-of-niets dependency blokkeren; als een secundaire hub-call faalt moet het dashboard met veilige fallbackdata blijven renderen in plaats van 500 of nul-collaps van alle statistiekkaarten.
- Vehicle Heist/Ops data (crew-acties, cooldowns, heat/reputatie, contracts/claims) moet als compacte dashboardsamenvatting zichtbaar blijven met live countdowns, inclusief veilige fallback per voertuigtype. Theft-cooldown na stelen blijft correct zichtbaar: API levert `cooldownRemainingSeconds` in steal-responses; embedded Vehicle Heist toont feedback rechtsboven in lijn met dashboard-notificatiepatroon.
- Responsive usability without pushing critical actions off-screen.
- In web/dashboard-shell context moet klik op dezelfde sectie een expliciete remount of refresh kunnen triggeren wanneer dat scherm anders vastloopt op stale state.
- Info- en statistiekblokken in dashboard/admin views moeten ook bij subtiele backgrounds en in dark mode expliciete contrasten voor tekst, border en hover/focus-state behouden.
- Admin image-management flows voor extern gehoste server-assets moeten zowel toevoegen als vervangen ondersteunen zonder handmatige shell-stappen; mapnavigatie en bestandsfeedback (preview/pad/grootte/update-tijd) blijven verplicht zichtbaar.
- Admin image-management moet ook modulegerichte discovery ondersteunen: operators moeten per module (zoals drugs/school/vehicles) afbeeldingen kunnen filteren en op bestandsnaam/pad kunnen zoeken.
- Deploys met externe image-opslag moeten een expliciete image-root voor admin upload/listing instellen (bijv. `IMAGE_LIBRARY_ROOT_PATH`), zodat beheer niet afhankelijk is van toevallige container paden.
- Runtime image-serving (`/assets/images`) moet dezelfde rootconfig gebruiken als admin image-management (`IMAGE_LIBRARY_ROOT_PATH`) zodat uploaden, vervangen en direct renderen altijd dezelfde storage aanspreken.
- Economy balanspanelen in admin moeten ratio-metrics (payout/min, fail-rate, jail-rate, cooldown-skips) tonen en runtime tuning controls direct aan dezelfde backend-config keys koppelen.

## i18n and Messaging
- Any new labels, warnings, helper text or dialogs must exist in both Dutch and English.
- If this module emits notifications, push messages or inbox events, keep the wording aligned across all channels.
- If player behavior changes, update the player help entry for this module.

## QA Checklist
- Open the module on mobile width, tablet width and desktop width.
- Run through the main success path and at least one failure or locked-state path.
- Verify the screen refreshes correctly after actions.
- Verify cooldowns, counters, balances or progress bars remain accurate.
- Verifieer dat economy/operations/risk/notification dashboardsecties gevuld blijven met echte backenddata en geen lege defaults bij normale accounts.
- Verifieer dat een fout in een gekoppelde submodule zoals Crew Wars de dashboard-statistieken niet volledig leeg of op nul laat terugvallen.
- Verifieer dat Vehicle Ops-data per voertuigtype (auto/motor/boot) op dashboard blijft renderen, ook als één type tijdelijk geen intelligence payload teruggeeft.
- Verify no text overflows or clipped buttons appear.
- Verify new dashboard navigation entries are visible and clickable in the web sidebar; treat tile-grid visibility as secondary fallback only.
- Verifieer in admin image-management dat uploaden en vervangen werkt voor dezelfde storage-root die door runtime `/assets/images` wordt geserveerd.
- Verifieer dat modulefilter + zoekresultaten overeenkomen met de daadwerkelijke serverbestanden per module.

## Dashboard Completeness Gate
- Elke modulewijziging die nieuwe cooldowns, payouts, risico-indicatoren, notificatie-events of operationele loops toevoegt/verandert, moet in dezelfde PR ook het dashboardcontract (`/player/dashboard-stats`), dashboardweergave en `Help & Uitleg` controleren en indien nodig bijwerken.
- "Done" is pas geldig als de nieuwe module-impact zichtbaar of expliciet gemotiveerd afwezig is in dashboard-economy, dashboard-operaties en dashboard-notificaties.

## When To Update This File
Update this protocol when the module gains a new subflow, new dependency, new notification path, major UX change or new QA risk.
