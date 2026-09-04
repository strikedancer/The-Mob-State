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
- Web dashboard navigation is sidebar-first: add or change module navigation via the sidebar source (`_buildWebMenuItems` + `_WebSection` content switch) and not only via the legacy tile grid. Sidebar and hamburger menu are grouped (Acties / Wereld / Sociaal / Economie / Empire / Assets / Meer) and have a search field.
- Dealer shops live on **Economie → Zwarte Markt** (trade goods, weapons, ammo, tools, security, materials, backpacks, plus player market). Do not add separate sidebar entries for Tools or Security; search aliases may still open those shops.
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
- Dashboard shell en hoofdpanelen moeten visueel aansluiten op de game-identiteit (noir/gold), met nadruk op leesbaar contrast, subtiele gradients en duidelijke scheiding tussen navigatie en content in plaats van vlakke donkere blokken.
- Op **Misdaden** (web) verdwijnt de losse compacte statusbalk boven de contentkaart; dezelfde HUD zit in de crimes-header (`CrimeScreen.statusHeader`) zodat status, paginatitel en landelijke politie één blok vormen.
- Dashboard statistiekblokken mogen geen hardcoded nul-placeholders tonen wanneer er al echte backendtellers of bestaande spelerstats beschikbaar zijn.
- Dashboard moet een complete baseline blijven tonen voor: economy (cash/bank/crypto/stocks/property/vehicle portfolio/net worth), cooldown-operaties, risicosignalen, notificaties en 24u/7d trendstatistieken; nieuwe modules die deze domeinen raken moeten hierop inhaken.
- Stock Market en Crypto horen bereikbaar te zijn via de zijbalk, het hamburger-menu en de sticky footer (niet alleen via legacy tile fallback).
- “Wat nu?” is optioneel; als we het tonen moet het compact blijven en mag het nooit primaire statistiekpanelen blokkeren of verstoppen. Als we het niet tonen, moeten doelen/recap nog steeds logisch vindbaar blijven.
- Voor reward-gevoel en transparantie mag het dashboard een compacte **sessie recap** tonen (laatste events in deze sessie) zodat spelers direct zien wat acties opleverden. Dit mag de primaire loop niet onderbreken en moet optioneel/openklapbaar blijven.
- Plaats de **Start-kaart** (alleen nieuwe spelers) bovenaan. **Dagdoelen** staan **één keer** in de gestylede paneelkaart (progress + cash/XP), op web bij het speler/economie-blok en op mobiel onder Start. Niet nog een tweede platte lijst bovenaan. Na Claim verschijnt rechtsboven wat je kreeg. De weekdoelen-minikaart mag naast/onder die kaart blijven. Featured daily mag `vehicle_theft_1` niet pushen onder rank 5.
- Dashboard toont een compacte **Markt**-tegel (actieve listings + CTA) en dezelfde **EventFeed** op web als op mobiel, gehydrateerd via `GET /events?limit=50` (auth). Geen locatie-intel.
- De feed heet **Mijn activiteit**: alleen events van de ingelogde speler (API + SSE scoped op `playerId`). Geen wereldwijde feed van andere spelers.
- Chat-events (`direct_message.*`) komen wél via SSE (berichtenbadge/chat) maar **niet** in Mijn activiteit.
- Travel-regels in de feed gebruiken `toCountry`/`destination` (gelokaliseerde landnaam); niet alleen het legacy-veld `country`.
- Weekdoelen moeten claimbaar zijn wanneer ze als “klaar”/“ready” worden getoond; zorg dat weekly-claims dezelfde window/key gebruiken als de weekdoelen-status (week start maandag UTC) zodat “1 klaar om te claimen” nooit in een claim-fout resulteert.
- Claims en beloningen mogen niet falen door DB transaction timeouts: doe alleen de noodzakelijke DB-writes in de transaction en schrijf activity/world events best-effort ná commit.
- Gekoppelde moduledata zoals Crew Wars mag dashboardstatistieken nooit als alles-of-niets dependency blokkeren; als een secundaire hub-call faalt moet het dashboard met veilige fallbackdata blijven renderen in plaats van 500 of nul-collaps van alle statistiekkaarten.
- Vehicle Heist/Ops data (crew-acties, cooldowns, heat/reputatie, contracts/claims) moet als compacte dashboardsamenvatting zichtbaar blijven met live countdowns, inclusief veilige fallback per voertuigtype. Theft-cooldown na stelen blijft correct zichtbaar: API levert `cooldownRemainingSeconds` in steal-responses; embedded Vehicle Heist toont feedback rechtsboven in lijn met dashboard-notificatiepatroon.
- Responsive usability without pushing critical actions off-screen.
- Op mobiel (onder de tablet-breakpoint) blijft een sticky footer met Misdaden, Voertuig stelen, Werken, Bank en Crew altijd in beeld. Op Misdaden/Stelen/Werken toont een gouden stip dat de cooldown klaar is (`GET /player/action-cooldowns`). Overige onderdelen blijven in het gegroepeerde, doorzoekbare hamburger-menu / de zijbalk.
- De hoofdbalk-avatar opent een gebruikersmenu met **Mijn profiel**, berichten, hulp, instellingen en uitloggen. Mijn profiel toont het publieke profiel van de ingelogde speler.
- Rangtitels op dashboard en publiek profiel gebruiken dezelfde ladder als `backend/src/utils/rankSystem.ts` (`client/lib/utils/rank_display.dart`). Rang 21+ is niet automatisch Peetvader; Peetvader is rang 60–74, Soldaat is rang 25–29.
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
- Verifieer op smalle breedte de sticky footer (Misdaden, Stelen, Werken, Bank, Crew), klaar-stippen na cooldown, en dat zoeken in het hamburger-menu groepen filtert.
- Verifieer dat de avatar-knop **Mijn profiel** opent en het eigen publieke profiel toont.
- Verify new dashboard navigation entries are visible and clickable in the web sidebar; treat tile-grid visibility as secondary fallback only.
- Verifieer dat nieuwe accounts een Start-kaart met één CTA zien (crime → daily/job → crew) en dat rank 3+ of afgeronde onboarding die kaart niet meer ziet.
- Verifieer dat dagdoelen **één keer** in de gestylede paneelkaart staan (niet dubbel bovenaan), dat elke regel cash + XP toont, dat Claim een toast met bedragen geeft, en dat autodiefstal niet featured is onder rank 5.
- Verifieer dat de rangtitel op het dashboard dezelfde ladder volgt als het publieke profiel (Soldaat op 25–29, Peetvader op 60–74).
- Verifieer in admin image-management dat uploaden en vervangen werkt voor dezelfde storage-root die door runtime `/assets/images` wordt geserveerd.
- Verifieer dat modulefilter + zoekresultaten overeenkomen met de daadwerkelijke serverbestanden per module.

## Dashboard Completeness Gate
- Elke modulewijziging die nieuwe cooldowns, payouts, risico-indicatoren, notificatie-events of operationele loops toevoegt/verandert, moet in dezelfde PR ook het dashboardcontract (`/player/dashboard-stats`), dashboardweergave en `Help & Uitleg` controleren en indien nodig bijwerken.
- "Done" is pas geldig als de nieuwe module-impact zichtbaar of expliciet gemotiveerd afwezig is in dashboard-economy, dashboard-operaties en dashboard-notificaties.

## When To Update This File
Update this protocol when the module gains a new subflow, new dependency, new notification path, major UX change or new QA risk.
