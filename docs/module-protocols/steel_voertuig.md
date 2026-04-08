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

## Core Rules
- Behoud één consistente spelersloop over alle tabs: stelen -> beheren -> repareren/verkoop/sloop.
- Tuning-loop blijft gekoppeld: sloop -> onderdelen -> TuneShop upgrades -> hogere voertuigwaarde en performance.
- Onderdelen zijn categorie-gepoold (auto/motor/boot): gesloopte onderdelen mogen op elk voertuig binnen dezelfde categorie worden besteed.
- Tune-upgrades hebben een verplichte timer per voertuig om spam-upgrades te voorkomen.
- Houd NL en EN tekst parity op alle zichtbare teksten.
- Houd layout bruikbaar op mobiel, tablet en desktop.
- Toon per tab een catalogus met waarde, zeldzaamheid, landen en world-cap status.
- Gebruik timed repairs; geen instant click-pay-complete gedrag.
- World-cap rotatie moet correct blijven: verkoop of sloop opent opnieuw beschikbaarheid voor die voertuigsoort.
- Transport hoort niet meer in deze module; cross-country verplaatsing loopt via Smuggling Hub.

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