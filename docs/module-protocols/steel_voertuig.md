# Steel Voertuig Protocol

## Scope

Gecombineerde voertuigmodule voor Auto, Motor en Boot binnen één schermflow: diefstal, inventory, reparatie, verkoop/sloop, catalogus, event-only politievoertuigen en world-cap rotatie.
Onderdeel hiervan is TuneShop: onderdelen-economie via sloop en upgrades voor speed/stealth/armor.

## Primary Frontend Entry

- client/lib/screens/vehicle_heist_screen.dart

## Tabs

- Auto: ondersteund door Garage-flow
- Motor: ondersteund door Motor-flow
- Boot: ondersteund door Marina-flow

## Boot-diefstal (balans)

- **Content:** alle boten in `vehicles.json` hebben relatief hoge `baseValue` (bv. goedkoopste vaak €35k+), waardoor dezelfde succes-tier-tabel als auto’s boten structureel **moeilijker** maakte dan een goedkope auto.
- **Server (`vehicleService.stealVehicle`):** na heat/patroon/rep wordt voor `vehicleType === 'boat'` een **+6%** succesbonus toegepast (cap 95%). **Haven lockdown** (UTC 04:00–09:00, dynamisch patroon `port_lockdown`) gebruikt voor boten multiplier **1.10** i.p.v. een zwaardere waarde, zodat vroege havencontroles merkbaar blijven maar niet frusterend.
- **Arrest na poging:** bij mislukte stal stijgt wanted; `checkArrest` (`policeService`) kan daarna alsnog gevangenis geven — dat is **los** van de “gesnapt”-mislukking en schaalt met wanted × `POLICE_RATIO`.

## Core Rules

- Behoud één consistente spelersloop over alle tabs: stelen -> beheren -> repareren/verkoop/sloop.
- Tuning-loop blijft gekoppeld: sloop -> onderdelen -> TuneShop upgrades -> hogere voertuigwaarde en performance.
- Onderdelen zijn categorie-gepoold (auto/motor/boot): gesloopte onderdelen mogen op elk voertuig binnen dezelfde categorie worden besteed.
- Tune-upgrades hebben een verplichte timer per voertuig om spam-upgrades te voorkomen.
- Houd NL en EN tekst parity op alle zichtbare teksten.
- Ops-panel labels, knoppen en statusregels moeten volledig gelokaliseerd zijn; NL-weergave mag geen Engelse fallbacklabels tonen.
- Houd layout bruikbaar op mobiel, tablet en desktop.
- Houd Auto, Motor en Boot als drie duidelijk gescheiden componenten in de UI, met eigen opslagcontext en duidelijke labels.
- In de gecombineerde Vehicle Heist shell mag geen dubbele categorie-navigatie bestaan: gebruik één primaire categorie-selector (lane cards) en vermijd een tweede redundante tab-rij met dezelfde drie categorieën.
- Lane cards in Vehicle Heist tonen ook opslagcapaciteit per type (opslag gebruikt/totaal + upgradelevel), zodat spelers niet hoeven te scrollen naar losse capaciteitsbalken.
- Vehicle Ops uitbreidingen (hotspots, parts market, crew ops, category heat, chop contracts, dynamic police patterns) moeten per voertuigcategorie duidelijk zichtbaar en uitlegbaar blijven.
- Advanced Vehicle Ops uitbreidingen (hotspot intercept windows, crew role-bonussen, ops-reputatie unlocks, regionale blacklist-events, contraband insurance, ops-telemetry) moeten coherent blijven met balance-economy guardrails.
- Vehicle Ops omvat nu ook Counter-Intercept missies, Crew Matchmaking met seizoensladder, country modifiers (inflatie/corruptie/havenstaking), contracts board met weekly legendary contracts en insurance dispute-resolutie.
- Vehicle Ops moet live cooldowns per hoofdactie zichtbaar tonen met actieve countdown, niet alleen statische secondenwaarden na handmatige refresh.
- Op de Vehicle Heist lane cards (en embedded garage/marina): bij actieve theft-cooldown toont een **bliksem-icoon** naast de timer; tikken opent bevestiging om credits te besteden (`vehicle_theft` / `motorcycle_theft` / `boat_theft` via dezelfde redeem-API). Geen full-screen `CooldownOverlay` meer; “bevestiging niet meer tonen” is lokaal + terug te zetten onder Instellingen.
- Cooldowninformatie in Vehicle Ops hoort op 1 primaire plek te staan (actiekaarten); vermijd dubbele cooldownsamenvattingen in losse tekstregels.
- Dashboard moet een compacte Vehicle Ops-samenvatting tonen (per auto/motor/boot) met live cooldowns, heat/reputatie en kernstatus van crew/contract/claims zonder dat 1 falende categorie de volledige dashboardweergave breekt.
- Crew-only ops-acties (crew-run en crew-matchmaking) mogen alleen zichtbaar of bruikbaar zijn als de speler daadwerkelijk in een crew zit; zonder crew moet een duidelijke unlock-hint worden getoond.
- Ops-actiekaarten moeten payout-context expliciet tonen (waarom cash toeneemt na klik), zodat reward-herkomst voor spelers traceerbaar is.
- Toon per tab een catalogus met waarde, zeldzaamheid, landen en world-cap status.
- In embedded garage/marina-weergave moet de gestolen-voertuigenlijst kaartgebaseerd en responsief blijven (mobiel 1 kolom, grotere schermen meerdere kolommen), zonder uitgerekte full-width rijen als default.
- Embedded voertuigkaarten moeten natuurlijke (auto) hoogte gebruiken; forceer geen hoge vaste grid-cel die lege onderruimte in kaarten veroorzaakt.
- Op grote schermen moet de embedded kaartlay-out kunnen opschalen tot 4 kolommen wanneer ruimte dit toelaat.
- Gebruik een dynamische kolomberekening op basis van minimale kaartbreedte in plaats van alleen harde viewport-breakpoints, zodat 4 kolommen ook op veel laptop-layouts haalbaar zijn.
- In Vehicle Heist embedded mode hoort de losse capaciteitsbalk boven de voertuigen verborgen te blijven; capaciteit wordt daar in de lane cards getoond.
- Gebruik timed repairs; geen instant click-pay-complete gedrag.
- World-cap rotatie moet correct blijven: verkoop of sloop opent opnieuw beschikbaarheid voor die voertuigsoort.
- Transport hoort niet meer in deze module; cross-country verplaatsing loopt via Smuggling Hub.
- Balance-aanpassingen voor deze loop gebruiken soft pacing (bijv. sessie-diminishing) in plaats van harde actiecaps, en moeten zichtbaar blijven in economy-telemetrie.

## Event Rules

- Politievoertuigen zijn event-only en moeten buiten actieve eventvensters niet stealbaar zijn.
- Tijdens actieve eventvensters zijn politie auto, politie motor en politie boot tegelijk beschikbaar.
- Event-caps voor politievoertuigen moeten hoger dan 1 blijven voor gezonde roulatie.
- Rank-gate voor event-politievoertuigen is rank 15 (auto, motor en boot).

## Assets

- Volg de centrale beeldregels in [LEONARDO_IMAGE_GENERATION_PROTOCOL.md](../LEONARDO_IMAGE_GENERATION_PROTOCOL.md).
- Per voertuig minimaal 3 states: new, dirty, damaged.
- Voor elke state responsive varianten: mobile, tablet, desktop.

## Child Protocols

- [Garage](garage.md)
- [Motor](motor.md)
- [Marina](marina.md)
- [TuneShop](tuneshop.md)

## QA Checklist

- Tab-switching werkt zonder state-verlies of visuele glitches.
- Catalogusknop is zichtbaar en correct per tab.
- Event-only politievoertuigen verschijnen alleen tijdens actieve events.
- Timed repairs en timers blijven correct na refresh.
- Verkoop en sloop verlagen inventory en laten world-cap correct roteren.
