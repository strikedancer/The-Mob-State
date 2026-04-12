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
- Payments -> Events (event boosts en tijdelijke multipliers)
- Payments -> Admin (catalogusbeheer, transactiesupport, audit)
- Payments -> Dashboard/Notifications (premium status en betaalresultaten zichtbaar maken)

## Must Preserve
- VIP-status moet na succesvolle betaling direct consistent zijn in backend en client.
- Credits-balance moet altijd herleidbaar zijn via ledger-mutaties.
- Checkout failure of webhook-delay mag geen halve grants of negatieve saldo's veroorzaken.
- Bestaande gameplay-perks mogen niet gratis bereikbaar worden door premium regressies.

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

## i18n and Messaging
- Prijslabels en benefit-teksten in NL en EN synchroon houden.
- Gebruik onderscheid tussen abonnement, losse aankoop en credit redemption in copy.
- Vermijd provider-jargon in player UI; gebruik heldere termen als `betaalpagina`, `abonnement`, `credits`.

## When To Update This File
Update bij nieuwe betaalproviders, nieuwe premium-producttypes, nieuwe entitlement-effecten, webhook- of refund-flows en admin-support uitbreidingen.