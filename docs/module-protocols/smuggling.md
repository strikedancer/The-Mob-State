# Smuggling Protocol

## Scope
Shipment routing, quotes, depots, channels, destinations and risk handling.

Vehicle movement between countries also belongs here when cars or boats are relocated through the smuggling network.

## Primary Frontend Entry
- client/lib/screens/smuggling_screen.dart

## Drug inventory contract

`DrugInventory` is unique on **`playerId + drugType + quality`** (geen landkolom). Smokkel (`smugglingService` / `drugSmugglingService`) mag **niet** de oude Prisma-key `playerId_country_drugType_quality` gebruiken — dat veroorzaakt 500 `Server error` bij quote/send van drugs.

## Crew + trade goods

Crew-netwerk + handelswaren gebruikt `CrewTradeInventory` + `CrewTradeStorageBuilding` (spiegel van drugsopslag). Catalog/send/claim lezen en schrijven crew-trade rows. Stort vanuit persoonlijke handelswaren via `POST /crews/:id/storage/trade/deposit`. De trade-chip blijft aan bij crew-netwerk.

Persoonlijke én crew-handelswaren behouden bij smokkel hun **inkoopprijs** (`purchasePrice` / `averagePurchasePrice`) en **conditie** in shipment-metadata; claim merge’t die gewogen terug in inventory zodat winst = verkoop − inkoop klopt.

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
- If the change touches cross-country vehicle movement, has the corresponding Garage/Marina protocol been reviewed too?

## Must Preserve
- Clear success and failure feedback for the player.
- Accurate state refresh after an action completes.
- Consistent formatting for money, timers, percentages and labels.
- Responsive usability without pushing critical actions off-screen.
- De speler moet expliciet kunnen zien of een quote via commercieel kanaal of eigen transport loopt.
- Cargo-capaciteit en confiscatierisico van eigen transport moeten zichtbaar en server-side leidend blijven.

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
- Verify owned cars, motorcycles, boats and aircraft appear as selectable transport when available.
- Verify `BOAT_CANNOT_FIT` and `CARGO_OVERFLOW` are surfaced clearly from the live quote and send flow.
- Verify failed owned-transport shipments can mark the transport asset as confiscated in the shipment result data.

## Eigen Voertuig Smokkelkanaal

Naast het commerciële kanaal kunnen spelers eigen voertuigen inzetten voor smokkeloperaties.Zie aviation.md voor volledig cargo-slot systeem en risicowaarden.

**Beschikbare eigen voertuigen:**

| Voertuig-type | Cargo-slots           | Risico-reductie | Confiscatie bij mislukking |
|---------------|-----------------------|-----------------|---------------------------|
| Vliegtuig     | Zie aviation.md       | −10% t/m −25%  | 30% kans                  |
| Auto          | 10 slots per voertuig | −5%             | 15% kans                  |
| Motor         | 5 slots per voertuig  | −8%             | 15% kans                  |
| Boot          | 30 slots per voertuig | −7%             | 25% kans                  |

**Regels:**
- Cargo-manifest validatie altijd server-side (nooit alleen client).
- Boot kan auto's en motoren vervoeren; vliegtuig kan geen boot vervoeren.
- Bij confiscatie: voertuig verwijderd uit bezit (PlayerAircraft / garage / marina) in dezelfde Prisma-transactie.
- `400 CARGO_OVERFLOW` als cargo-slots worden overschreden.
- `400 BOAT_CANNOT_FIT` als boot in vliegtuig-lading zit.
- NL/EN confiscatie-melding altijd tonen in smokkelresultaat.

## Cross-Module Dependencies
- Smuggling → Aviation (`aviationService`, `PlayerAircraft` voor vliegtuig-smokkel)
- Smuggling → Garage/Motor (eigen auto/motor ophalen voor smokkelkanaal)
- Smuggling → Marina (eigen boot ophalen voor smokkelkanaal)

## When To Update This File
Update this protocol when the module gains a new subflow, new dependency, new notification path, major UX change or new QA risk.
