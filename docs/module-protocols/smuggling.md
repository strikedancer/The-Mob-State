# Smuggling Protocol

## Scope
Shipment routing, quotes, depots, channels, destinations and risk handling.

Vehicle movement between countries also belongs here when cars or boats are relocated through the smuggling network.

**Hub UX (Phase 1):** noir/gold mafia panels, stepped send flow (Cargo → Route → Transport → Confirm), ETA countdown on shipment cards, and a result overlay for successful send/claim.

## Primary Frontend Entry
- client/lib/screens/smuggling_screen.dart
- client/lib/widgets/smuggling_result_overlay.dart

## Drug inventory contract

`DrugInventory` is unique on **`playerId + drugType + quality`** (geen landkolom). Smokkel (`smugglingService` / `drugSmugglingService`) mag **niet** de oude Prisma-key `playerId_country_drugType_quality` gebruiken — dat veroorzaakt 500 `Server error` bij quote/send van drugs.

## Crew + trade goods

Crew-netwerk + handelswaren gebruikt `CrewTradeInventory` + `CrewTradeStorageBuilding` (spiegel van drugsopslag). Catalog/send/claim lezen en schrijven crew-trade rows. Stort vanuit persoonlijke handelswaren via `POST /crews/:id/storage/trade/deposit`. De trade-chip blijft aan bij crew-netwerk.

Persoonlijke handelswaren liggen per land (`inventory.country`). Catalog/send debit alleen het **huidige land**; claim crediteert het **bestemmingsland**. Crew-handelswaren blijven gedeeld (`CrewTradeInventory`, geen landkolom).

Persoonlijke én crew-handelswaren behouden bij smokkel hun **inkoopprijs** (`purchasePrice` / `averagePurchasePrice`) en **conditie** in shipment-metadata; claim merge’t die gewogen terug in inventory zodat winst = verkoop − inkoop klopt.

Succesvolle **depot-claim** geeft **kleine XP** aan de claimende speler (per zending, max 60 per actie).

## Change Rules
- Preserve the core player loop and avoid hidden behavior changes.
- Keep Dutch and English copy in sync for any user-visible change.
- Keep layout usable on mobile, tablet and desktop if this module is reachable in the dashboard shell.
- Initial load failure must show retry (`MobileLoadError`), not an empty hub or an infinite spinner.
- Do not silently remove existing rewards, cooldowns or risk gates without updating help and release notes.

## Check Before Editing
- What is the player trying to achieve in this screen or loop?
- Which timers, locks, rank gates or country rules affect the flow?
- Does this module send notifications, inbox messages, rewards or achievements?
- Does this module depend on assets, videos, icons or generated media?
- If the change touches cross-country vehicle movement, has the corresponding Garage/Marina protocol been reviewed too?

## Must Preserve
- Clear success and failure feedback for the player (result overlay on send/claim success; snackbar on failure).
- Accurate state refresh after an action completes.
- Consistent formatting for money, timers, percentages and labels (including live ETA countdown from `etaAt`).
- Responsive usability without pushing critical actions off-screen.
- De speler moet expliciet kunnen zien of een quote via commercieel kanaal of eigen transport loopt.
- Cargo-capaciteit en confiscatierisico van eigen transport moeten zichtbaar en server-side leidend blijven.
- Hub blijft noir/gold panel styling met stepped send wizard; API-logica en message-localisatie helpers niet stil breken.

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

## Territory harbor bonus

If the player's crew owns a region with the `harbor` strategic tag in the current country, quote and send apply a modest route bonus:

- ETA −10%
- seizure chance −5% (still clamped)

The live quote surfaces this as `harborBonus: true` so the hub can show a harbor caption. Personal shipments also receive the bonus when the player is in that crew.

## Drug wholesale (sell-on-arrival)
NPC wholesale export from the drugs hub reuses `smuggling_shipments` with `metadata_json.wholesale = true`, channel `container`. Personal export uses the personal network; crew export uses `networkScope=crew`, `CrewDrugLot` stock, and `feePayer=crew_bank`. Arrival is settled on tick (and on drugs quote/list): ready → locked `payout` cash + `claimed`; seized → no cash. Do not credit wholesale rows back into inventory via depot claim. Player entry is Inventory **Exporteren**; crew entry is the crew storage lot list. See `drugs.md`.

## Cross-Module Dependencies
- Smuggling → Aviation (`aviationService`, `PlayerAircraft` voor vliegtuig-smokkel)
- Smuggling → Garage/Motor (eigen auto/motor ophalen voor smokkelkanaal)
- Smuggling → Marina (eigen boot ophalen voor smokkelkanaal)
- Smuggling → Territory (`territory_control` + `harbor` tag in the current country)
- Smuggling → Drugs (wholesale export settle-on-arrival; do not claim wholesale into inventory)

## When To Update This File
Update this protocol when the module gains a new subflow, new dependency, new notification path, major UX change or new QA risk.
