# Dashboard Protocol

## Scope
Global player overview, navigation shell, timers, live events and quick access.

## Primary Frontend Entry
- client/lib/screens/dashboard_screen.dart

## Change Rules
- Preserve the core player loop and avoid hidden behavior changes.
- Keep Dutch and English copy in sync for any user-visible change.
- Keep layout usable on mobile, tablet and desktop if this module is reachable in the dashboard shell.
- The compact status-bar health meter opens Hospital. Crimes shows a wounded banner (`hospitalGoHeal`) when HP is below 70.
- Do not silently remove existing rewards, cooldowns or risk gates without updating help and release notes.
- Web dashboard navigation is sidebar-first: add or change module navigation via the sidebar source (`_buildWebMenuItems` + `_WebSection` content switch) and not only via the legacy tile grid. Sidebar and hamburger menu are grouped (Acties / Wereld / Sociaal / Economie / Empire / Assets / Meer) and have a search field.
- Don lives under **Empire** next to properties (`_WebSection.don` → `don_screen.dart`). Keep the mobile extra-tile entry in sync. See [don.md](don.md). Don collect/office/loan/contract timers stay on the Don hub (per racket / per job), not as a single Home footer cooldown.
- Midnight Races live under **Empire** (`_WebSection.races` → `race_screen.dart`). See [races.md](races.md). Settle/refund writes `race.settled` / `race.refunded` to the personal activity feed plus inbox + push.
- Drugs live under **Empire** (`_WebSection.drugs` → `drug_environment_screen.dart`) with the same photo-hero + tab pattern as Don. Page-info `i` lives in the Drugs hero, not the HUD. See [drugs.md](drugs.md).
- Nightclub, Properties, Prostitution / Red Light Districts and Ammo Factory use the shared `EmpirePageHero` (scroll-away photo header). Page-info `i` lives in that hero, not the HUD. Embedded Empire-shell skips the extra AppBar.
- Overige spelersecties (o.a. bank, casino, crew, zwarte markt, vault, travel, training, events) gebruiken dezelfde `EmpireHubScaffold`. Page-info `i` leeft in de hero. Dashboard-home, Help en Instellingen blijven zonder foto-hero.
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
- Web-chrome is een operations-console (`dashboard_chrome.dart`): gecentreerd logo in de topbar (desktop min. 60px / max. 100px; op mobiel kleiner ~36–48px zodat de HUD-ruimte overblijft), platte zijbalk met gouden selectiebalk, HUD-statusrij (cash/rang/HP/wanted/FBI/land) en homepanelen met sectietitels. Onder de tablet-breakpoint (~900px) stapelt de statusbalk in **twee rijen van drie** (geld/rang/HP, daarna wanted/FBI/land). Wanted en FBI zijn allebei 0–100 en tonen `n%` (zelfde notatie; niet het oude 5-sterrenplafond). Geen `FittedBox` in HUD-cellen (Flutter web kan daarop vastlopen). Geen gameplay-wijziging.
- Op **Misdaden** (web) blijft de compacte statusbalk boven de contentkaart staan, hetzelfde als op andere secties. Paginatitel, landelijke politie, training en gedragen wapens zitten in één header **in** de contentkaart.
- **Gevangenis** opent in de web-shell embedded (geen extra AppBar); de lijst moet op mobiel retry/pull-to-refresh houden.
- Dashboard statistiekblokken mogen geen hardcoded nul-placeholders tonen wanneer er al echte backendtellers of bestaande spelerstats beschikbaar zijn.
- Dashboard moet een complete baseline blijven tonen voor: economy (cash/bank/crypto/stocks/property/vehicle portfolio/net worth), cooldown-operaties, risicosignalen, notificaties en 24u/7d trendstatistieken; nieuwe modules die deze domeinen raken moeten hierop inhaken.
- Stock Market en Crypto horen bereikbaar te zijn via de zijbalk, het hamburger-menu en de sticky footer (niet alleen via legacy tile fallback).
- “Wat nu?” is optioneel; als we het tonen moet het compact blijven en mag het nooit primaire statistiekpanelen blokkeren of verstoppen. Als we het niet tonen, moeten doelen/recap nog steeds logisch vindbaar blijven.
- Voor reward-gevoel en transparantie mag het dashboard een compacte **sessie recap** tonen (laatste events in deze sessie) zodat spelers direct zien wat acties opleverden. Dit mag de primaire loop niet onderbreken en moet optioneel/openklapbaar blijven.
- Plaats de **Start-kaart** (alleen nieuwe spelers) bovenaan. **Dagdoelen** staan **één keer** in de gestylede paneelkaart (progress + cash/XP), op web bij het speler/economie-blok en op mobiel onder Start. Niet nog een tweede platte lijst bovenaan. Na Claim verschijnt rechtsboven wat je kreeg. De weekdoelen-minikaart mag naast/onder die kaart blijven. Featured daily mag `vehicle_theft_1` niet pushen onder rank 5.
- Dashboard toont een compacte **Markt**-tegel (actieve listings + CTA). Geen locatie-intel. Op web opent de tegel **Zwarte Markt → Marktplaats** in de dashboard-content (`_openBlackMarket(tabMarketplace)`), niet als fullscreen-route. Recente eigen acties staan **niet** als vaste **Mijn activiteit**-lijst op Home: open **Sessie-overzicht** (rechtsboven op web, AppBar op native). Dezelfde sheet (`showSessionRecapSheet`) dekt beide. Data blijft `GET /events?limit=50` + SSE (scoped op `playerId`).
- Home toont **geen** Trainingscircuit-balk. Circuit blijft in de zijbalk onder Acties; bonussen staan op Misdaden.
- **Live event rail** (rechtsonder, niet op Events-sectie): foto-avatar + resterende-tijd-badge; Monthly Empire altijd zichtbaar (dichtst bij de duim); tap opent dezelfde event-detailpopup als Events (maandevent: dezelfde Event Pass-lijst als Evenementen). Rode claim-cijfer alleen op het maandevent (Event Pass), nooit op week-avatars en nooit voor dashboard dag-/weekdoelen. Zie `events.md`.
- Sessie-overzicht toont alleen events van de ingelogde speler (API + SSE scoped op `playerId`). Geen wereldwijde feed van andere spelers.
- Chat-events (`direct_message.*`) komen wél via SSE (berichtenbadge/chat) maar **niet** in Sessie-overzicht.
- **Berichten / postvak:** de badge (`GET /messages/unread`) mag nooit groener zijn dan de inbox-lijst. `GET /messages/conversations` blijft één gebatchte query; bij laadfout retry, geen lege “geen berichten”-staat.
- Travel-regels in de feed gebruiken `toCountry`/`destination` (gelokaliseerde landnaam); niet alleen het legacy-veld `country`.
- Weekdoelen moeten claimbaar zijn wanneer ze als “klaar”/“ready” worden getoond; zorg dat weekly-claims dezelfde window/key gebruiken als de weekdoelen-status (week start maandag UTC) zodat “1 klaar om te claimen” nooit in een claim-fout resulteert.
- Claims en beloningen mogen niet falen door DB transaction timeouts: doe alleen de noodzakelijke DB-writes in de transaction en schrijf activity/world events best-effort ná commit.
- Gekoppelde moduledata zoals Crew Wars mag dashboardstatistieken nooit als alles-of-niets dependency blokkeren; als een secundaire hub-call faalt moet het dashboard met veilige fallbackdata blijven renderen in plaats van 500 of nul-collaps van alle statistiekkaarten.
- **`GET /player/dashboard-stats`** laadt de baseline in **één parallelle query-ronde** (plus één korte ronde voor crypto-prijzen / territory-leader). Geen sequentiële lifetime-counts of drie volle Vehicle Ops intelligence-payloads op Home. Vehicle Ops op het dashboard komt uit `getVehicleOpsDashboardSummaries` (gedeelde heat/profile/season/claims). Per-request `console.log` van de stats-blob hoort niet op dit pad.
- Vehicle Heist/Ops data (crew-acties, cooldowns, heat/reputatie, contracts/claims) moet als compacte dashboardsamenvatting zichtbaar blijven met live countdowns, inclusief veilige fallback per voertuigtype. Theft-cooldown na stelen blijft correct zichtbaar: API levert `cooldownRemainingSeconds` in steal-responses; embedded Vehicle Heist toont feedback rechtsboven in lijn met dashboard-notificatiepatroon.
- Responsive usability without pushing critical actions off-screen.
- Op mobiel (onder de tablet-breakpoint) blijft een sticky footer met Misdaden, Voertuig stelen, Werken, Bank en Crew altijd in beeld. Op Misdaden/Stelen/Werken toont een gouden stip dat de cooldown klaar is. Remaining komt uit `GET /player/action-cooldowns` bij load/navigatie/na actie en tikt daarna lokaal; geen 10/30s-poll. Home-statistiek-countdowns (timeouts, jail, vehicle-ops, war-phase) tikken via dezelfde `ValueNotifier`-aanpak: niet elke seconde `setState` op de hele home-tree. Overige onderdelen blijven in het gegroepeerde, doorzoekbare hamburger-menu / de zijbalk.
- Elke spelerssectie toont een gouden `i` met de uitgebreide pagina-uitleg uit Help & Uitleg. Web: geen overlay over de contentkaart — in de foto-hero voor de meeste secties, of in de compacte statusbalk alleen op dashboard-home / Help / Instellingen. Don, Midnight Races en Help & Uitleg zelf zijn uitgezonderd van een tweede `i`. Op mobiel dashboard-home staat de `i` in de AppBar.
- **Eten & Drinken is verwijderd.** Geen menu-item, geen `/food`-API, geen honger/dorst-tick. Nightclub bar & kitchen blijft (clubvoorraad, niet spelerhonger).
- De hoofdbalk-avatar opent een gebruikersmenu met **Mijn profiel**, berichten, hulp, instellingen en uitloggen. Mijn profiel toont het publieke profiel van de ingelogde speler **in de dashboard-content** (niet als fullscreen-route).
- Rangtitels op dashboard en publiek profiel gebruiken dezelfde ladder als `backend/src/utils/rankSystem.ts` (`client/lib/utils/rank_display.dart`). De compacte statusbalk toont **titel + rangnummer + voortgangs-%** (bijv. `Cadet (21) 39%`), niet alleen de titel. Rang 21+ is niet automatisch Peetvader; Peetvader is rang 60–74, Soldaat is rang 25–29.
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
- Verifieer dat Home-countdowns (timeouts, jail, vehicle-ops chips, war-phase) elke seconde blijven lopen zonder dat de rest van de home-kaart (doelen, economy-cijfers) meerebuildt.
- Verifieer dat een fout in een gekoppelde submodule zoals Crew Wars de dashboard-statistieken niet volledig leeg of op nul laat terugvallen.
- Verifieer dat Vehicle Ops-data per voertuigtype (auto/motor/boot) op dashboard blijft renderen, ook als één type tijdelijk geen intelligence payload teruggeeft.
- Verify no text overflows or clipped buttons appear.
- Verifieer op smalle breedte de sticky footer (Misdaden, Stelen, Werken, Bank, Crew), klaar-stippen na cooldown, en dat zoeken in het hamburger-menu groepen filtert.
- Verifieer dat de avatar-knop **Mijn profiel** het eigen publieke profiel in de content-pane toont (sidebar blijft zichtbaar).
- Verify new dashboard navigation entries are visible and clickable in the web sidebar; treat tile-grid visibility as secondary fallback only.
- Verifieer dat nieuwe accounts een Start-kaart met één CTA zien (crime → daily/job → crew) en dat rank 3+ of afgeronde onboarding die kaart niet meer ziet.
- Verifieer dat dagdoelen **één keer** in de gestylede paneelkaart staan (niet dubbel bovenaan), dat elke regel cash + XP toont, dat Claim een toast met bedragen geeft, en dat autodiefstal niet featured is onder rank 5.
- Verifieer dat **Eten & Drinken** nergens meer in zijbalk of hamburger-menu staat.
- Verifieer dat een klaar dag- of weekdoel **geen** rood cijfer op weekevent-avatars zet. Alleen het maandelijkse Empire-avatar mag een Event Pass-claimcijfer tonen.
- Verifieer dat de rangtitel op het dashboard dezelfde ladder volgt als het publieke profiel (Soldaat op 25–29, Peetvader op 60–74).
- Verifieer in admin image-management dat uploaden en vervangen werkt voor dezelfde storage-root die door runtime `/assets/images` wordt geserveerd.
- Verifieer dat modulefilter + zoekresultaten overeenkomen met de daadwerkelijke serverbestanden per module.

## Dashboard Completeness Gate
- Elke modulewijziging die nieuwe cooldowns, payouts, risico-indicatoren, notificatie-events of operationele loops toevoegt/verandert, moet in dezelfde PR ook het dashboardcontract (`/player/dashboard-stats`), dashboardweergave en `Help & Uitleg` controleren en indien nodig bijwerken.
- Warehouse arrest-search is geen extra dashboard-meter: het hangt aan bestaande arrestatie-events. Help & Uitleg (Eigendommen + Inventaris) moet het risico noemen.
- Nightclub player-supply is geen extra dashboard-meter: het hangt aan Inventaris (Aan club) + Nightclub Ops Lab + inbox naar de clubbaas. Help & Uitleg (Drugs + Nightclub) moet de flow noemen.
- "Done" is pas geldig als de nieuwe module-impact zichtbaar of expliciet gemotiveerd afwezig is in dashboard-economy, dashboard-operaties en dashboard-notificaties.

## When To Update This File
Update this protocol when the module gains a new subflow, new dependency, new notification path, major UX change or new QA risk.
