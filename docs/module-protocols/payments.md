# Payments & Premium

## Scope
Deze module dekt externe betalingen, VIP-abonnementen, premium catalogus, premium credits en credit-redemptions. Scope omvat checkout, webhook-fulfillment, wallet/ledger, entitlement-status en admin-beheer van catalogusdata. Niet in scope: generieke bank/economieflows zonder premium-relatie.

## Primary Frontend Entry
- `client/lib/screens/crew_screen.dart`
- Eventuele toekomstige premium/credits schermen in `client/lib/screens/`

## Primary Backend Entry
- `backend/src/routes/subscriptions.ts`
- `backend/src/routes/admin.ts` voor catalogusbeheer
- `backend/prisma/schema.prisma`

## Change Rules
- Gebruik provider-idempotentie: webhook-verwerking mag rewards nooit dubbel uitkeren.
- Bewaar betaalstatus, wallet-mutaties en entitlements apart zodat support/admin incidenten reproduceerbaar blijven.
- Houd player-facing prijzen, benefit-copy en backend-fulfillment exact synchroon.
- Bij nieuwe premium producten altijd kiezen tussen: directe grant, tijdsgebonden entitlement of credits. Geen impliciete side-effects.

## Cross-Module Dependencies
- Payments -> Crew (crew VIP entitlement en perks)
- Payments -> Hitlist/Security (kill-protection credits)
- Payments -> Garage/TuneShop (repair/tune versnellen)
- Payments -> Vault (Kraak de Kluis: credit inzet + prize payouts)
- Payments -> Events (event boosts en tijdelijke multipliers)
- Payments -> Admin (catalogusbeheer, transactiesupport, audit)
- Payments -> Dashboard/Notifications (premium status en betaalresultaten zichtbaar maken)

## Must Preserve
- VIP-status moet na succesvolle betaling direct consistent zijn in backend en client.
- Credits-balance moet altijd herleidbaar zijn via ledger-mutaties.
- Admin moet premium credits veilig handmatig kunnen toekennen voor support/correcties, met role-checks, limieten en audit trail.
- Checkout failure of webhook-delay mag geen halve grants of negatieve saldo's veroorzaken.
- Bestaande gameplay-perks mogen niet gratis bereikbaar worden door premium regressies.
- Player premium toegang hoort via een dedicated Premium & Credits scherm beschikbaar te zijn, niet alleen via verborgen crew-subflows.
- Externe betaalredirects moeten na checkout terug landen in de ingesloten game-shell op de Premium & Credits sectie; een losse fullpage premium-route is geen voorkeursflow voor web/PWA.
- Player VIP en Crew VIP prijzen moeten runtime-config-gestuurd blijven zodat admin ze live kan aanpassen zonder backend deploy.
- Player VIP voordelen met economy-impact (zoals cooldown-reductie of periodieke credit grants) moeten via backendregels afdwingbaar blijven en in de player copy expliciet vermeld worden.
- Als Player VIP nieuwe module-specifieke QoL-perks krijgt (zoals VIP one-click ontbrekende materials kopen in Drugs Productie), moet die benefit expliciet in de VIP aankoop- en info-copy staan (NL+EN).
- Wekelijkse Player VIP-credit grants moeten ledger-traceerbaar zijn via `player_credit_transactions` (reasonKey + metadata), zodat support/admin uitbetaling kan herleiden.
- Credit koopbundels en credit-redemption costs moeten admin-beheerbaar zijn via de premium adminflow en niet hardcoded in player UI.
- Default creditbundels mogen server-side ge-seed worden voor een lege catalogus, maar key, prijs, credit-amount en beeldpad moeten stabiel en idempotent blijven.
- Legacy offers met verouderde prijsstelling (zoals 1000 credits voor 1,99) mogen niet meer in de actieve player-catalogus of checkout terechtkomen; blokkeer of deactiveer deze server-side.
- Premium/Credits tegelafbeeldingen blijven extern gehost onder `images/premium_tiles/...`; generator, backend-catalogus en client mapping moeten dezelfde vaste bestandsnamen delen.
- Voor `ACTION_COOLDOWN_RESET` items geldt dynamische prijsstelling op basis van resterende cooldown en action-value; expose deze altijd als runtime `effectiveCreditCost` in de overview.
- Dynamische cooldown-prijsstelling moet progressief maar mild blijven: korte cooldowns (zoals crime ~1-2 minuten) horen geen disproportioneel hoge creditprijs te krijgen.
- Cooldown-reset redemptions moeten blokkeren zonder actieve cooldown (`ACTION_COOLDOWN_NOT_ACTIVE`) om creditverlies te voorkomen.
- Ondersteunde gameplay-timeout overlays (crime, jobs, school, voertuig- en bootdiefstal, en andere actieve cooldown-schermen met matchende actionType) moeten een directe credit speed-up knop tonen; speler mag niet geforceerd worden eerst terug te navigeren naar `Premium & Credits`.
- Voor `VEHICLE_REPAIR_FINISH` moet op beschadigde voertuigkaarten (garage/marina) een contextuele credits-knop zichtbaar zijn; de flow start indien nodig eerst reparatie en rondt daarna direct af via dezelfde redeem-flow met `vehicleInventoryId`.
- Het instant-repair icoon op voertuigkaarten gebruikt een gecombineerde visual (steeksleutel + bliksem) zodat de actie herkenbaar blijft als reparatie én instant effect.
- Tijdelijke `EVENT_BOOST` credit-items moeten capped side-grade boosts blijven; geen permanente statstacking of pay-to-win power creep.
- Minigames met credits-inzet (zoals **Kraak de Kluis**) moeten credits **transactioneel** afschrijven (REDEEM) en prijzen **traceerbaar** uitbetalen (ledger + metadata: seasonKey, stakeTier). Als een VIP-prijs niet toepasbaar is (speler is al VIP), moet de prijs **consequent** worden omgezet naar credits (geen provider-jargon in UI).

## Backend Contract Guardrails
- Nieuwe provider-velden en transaction-modellen moeten ook in Prisma bestaan vóór gebruik.
- Webhook-code moet status server-side ophalen bij Mollie; vertrouw nooit alleen request-body.
- Gebruik unieke provider payment-id opslag voor idempotente fulfillment.
- Redemptions die gameplay-data aanpassen moeten ownership en actieve state valideren.
- Bij meldingen zoals `Unknown column players.mollieCustomerId` eerst migration drift oplossen (latest Prisma migrations deployen) vóór verdere code-debugging.

## Frontend Loading Guardrails
- Premium catalogus, VIP-status en credits-overzicht moeten los kunnen falen zonder het hele premiumblok leeg te trekken.
- Toon duidelijke feedback voor open/cancelled/paid checkout-terugkeer.
- Houd mobile cards compact; prijzen en benefits moeten zonder horizontale overflow leesbaar blijven.

## QA Checklist
1. Player VIP checkout opent Mollie en paid webhook activeert VIP.
2. One-time purchase grant wordt exact één keer fulfilled.
3. Credit purchase verhoogt wallet en schrijft ledger-regel.
4. Credit redeem verlaagt wallet en past effect alleen toe bij geldige target/state.
5. Webhook retry veroorzaakt geen dubbele grant.
6. Admin/cataloguswijziging wordt correct teruggeleverd in player catalog endpoint.
7. Crew, hitlist/security en vehicle flows blijven correct na premium effect.
8. Een lege premium-catalogus krijgt automatisch de verwachte default creditbundels (250 / 500 / 1000 / 2500) zonder duplicaten.
9. Premium tiles laden op web correct via de externe runtime-route en tonen na een refresh de actuele cache-bust versie.
10. Admin player-management kan premium credits set/add uitvoeren met correcte permissies (viewer blok, moderator limiet, super admin volledige limiet).

## i18n and Messaging
- Prijslabels en benefit-teksten in NL en EN synchroon houden.
- Gebruik onderscheid tussen abonnement, losse aankoop en credit redemption in copy.
- Vermijd provider-jargon in player UI; gebruik heldere termen als `betaalpagina`, `abonnement`, `credits`.
- Redirect-feedback voor `paid`, `success`, `cancelled`, `failed` en `expired` moet player-facing meertalig zijn en semantisch kloppen voor VIP versus losse aankoop/credits.

## When To Update This File
Update bij nieuwe betaalproviders, nieuwe premium-producttypes, nieuwe entitlement-effecten, webhook- of refund-flows en admin-support uitbreidingen.
