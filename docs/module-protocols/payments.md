# Payments & Premium

## Scope
Deze module dekt externe betalingen, VIP-abonnementen, premium catalogus, premium credits en credit-redemptions. Scope omvat checkout, webhook-fulfillment, wallet/ledger, entitlement-status en admin-beheer van catalogusdata. Niet in scope: generieke bank/economieflows zonder premium-relatie.

## Primary Frontend Entry
- `client/lib/screens/premium_screen.dart` (VIP tab: buy/extend, gift, cancel auto-renew, prestige KPI; Credits tab: credit packs + in-game cash)
- `client/lib/screens/dashboard_screen.dart` (HUD VIP-cel: actief/nee + resterende tijd, tik naar Premium)
- `client/lib/screens/crew_screen.dart` (crew VIP checkout entry)

## Primary Backend Entry
- `backend/src/routes/subscriptions.ts`
- `backend/src/services/vipBenefitsService.ts` (VIP grant helpers, prestige tiers, expiry sweep)
- `backend/src/routes/admin.ts` voor catalogusbeheer / VIP grant (`POST /admin/players/vip/grant` en `POST /admin/players/manage`)
- `backend/prisma/schema.prisma`
- Startup: `ensureVipPrestigeSchema.ts` (`players.vipLifetimeDays`, `crews.vipLifetimeDays`)

## VIP polish (P6)
- **Auto-renew:** Na eerste betaalde Player/Crew VIP checkout maakt de webhook een Mollie-subscription (`interval: 1 month`, `startDate` ≈ `vipExpiresAt`). Recurring charges verlengen VIP +30 dagen. Mislukte renew-payments wissen VIP/subscription-id **niet** meer (betaalde periode blijft tot `vipExpiresAt`; stoppen alleen via `POST /subscriptions/vip/cancel`). Fulfillment is idempotent per Mollie payment id. Metadata-fallback via `mollieSubscriptionId` als renew-payment metadata mist.
- **Gift Player VIP:** `POST /subscriptions/checkout/gift-player-vip` met `recipientUsername`; webhook type `player_vip_gift` verlengt VIP van ontvanger (geen auto-renew). Premium UI toont eenmalige prijs uit `giftPrices.playerVipEur`.
- **Gift Crew VIP:** `POST /subscriptions/checkout/gift-crew-vip` met `recipientCrewName`; webhook type `crew_vip_gift` verlengt crew VIP 30 dagen (geen auto-renew). Iedere speler mag cadeau doen (niet alleen leaders). UI toont `giftPrices.crewVipEur`.
- **Crew VIP-pot:** elk crewlid kan `POST /subscriptions/checkout/crew-vip-donate` (`amountEur` in €1 / €2.50 / €5 / restbedrag / maandprijs). Webhook `crew_vip_donate` telt euro-cents op `crews.vipFundCents`; bij een volle maandprijs volgt +30 dagen zonder Mollie-subscription. `GET /subscriptions/crew-vip-fund` voedt Crew-overzicht en Premium.
- **Crew VIP-abonnement:** `POST /subscriptions/checkout/crew-vip` mag elk lid starten (niet alleen de leader). Als de crew al `mollieSubscriptionId` heeft, is extra betaling een eenmalige maand zonder tweede subscription.
- Prestige KPI toont lifetime days + dagen tot volgende tier (bronze 30 / silver 180 / gold 365; display-only).
- **Prestige (display-only):** lifetime VIP-dagen → tiers bronze/silver/gold (30/180/365); geen gameplay power.
- Cron `vipExpirySweep` zet verlopen `isVip` uit (crew buildings downgraden).
- **Admin player manage VIP:** `POST /admin/players/manage` stuurt VIP alleen mee als de admin VIP echt wijzigt (niet bij elke geld/rank-save). Max **365 dagen** per grant. Enabling VIP is een kritieke wijziging (reden ≥5 tekens + `CONFIRM`). Lege/`null` set-velden worden genegeerd. Enabling gebruikt `grantPlayerVipDays` (verlengt vanaf nu of huidige expiry, telt `vipLifetimeDays`).

## Admin VIP grant (UI)
- Admin → spelerdetail → Beheer: knop **VIP-dagen toekennen** stuurt alleen `{ vip: { enabled: true, days } }` + reden. Verlengt bestaande VIP. Geen `CONFIRM`-typeplicht; wel reden (min. 5) en een ja/nee-bevestiging.
- **Opslaan alle wijzigingen** + vink **VIP actief** blijft de kritieke pad (reden + `CONFIRM`) voor het grote formulier.
- Moderator mag VIP-dagen toekennen, maar niet VIP uitzetten of rank wijzigen.
- `POST /admin/players/vip/grant` zoekt username case-insensitive.
- Slaat niet meer de hele stat-formulier mee als alleen VIP wijzigt; dat voorkwam `Invalid input` (NaN/`null` money/health/country).
- Help-topic `premium` (Help & Uitleg) dekt cancel/gift/prestige; sync via `scripts/_help_topics_extracted.json`.

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
- Payments -> Admin (catalogusbeheer, transactiesupport, audit, volledige speler-reset met behoud van VIP/betaalde credits)
- Payments -> Dashboard/Notifications (premium status en betaalresultaten zichtbaar maken)

## Must Preserve
- VIP-status moet na succesvolle betaling direct consistent zijn in backend en client.
- Credits-balance moet altijd herleidbaar zijn via ledger-mutaties.
- Admin moet premium credits veilig handmatig kunnen toekennen voor support/correcties, met role-checks, limieten en audit trail.
- Checkout failure of webhook-delay mag geen halve grants of negatieve saldo's veroorzaken.
- Bestaande gameplay-perks mogen niet gratis bereikbaar worden door premium regressies.
- Player premium toegang hoort via **Winkel** onder Dashboard beschikbaar te zijn, niet alleen via verborgen crew-subflows. VIP en Credits zijn tabs op die ene pagina. Cooldown/time-skip credit-sinks horen op het actiescherm, niet op deze aankooppagina.
- Externe betaalredirects moeten na checkout terug landen in de ingesloten game-shell op VIP of Credits; een losse fullpage premium-route is geen voorkeursflow voor web/PWA.
- In-game cash one-time offers (`rewardType: money`) horen in de Credits-tab zichtbaar te zijn. `ensureDefaultMoneyBundleOffers` seedt `money_small` / `money_large` / `money_stack` / `money_chest` idempotent.
- Credit→cash (`CASH_BUNDLE`, 25 credits → €2.000) mag nooit meer in-game cash per euro opleveren dan de euro-cashpacks. Credits zijn utility; cashpacks zijn de cash-winkel.
- Player VIP en Crew VIP prijzen moeten runtime-config-gestuurd blijven zodat admin ze live kan aanpassen zonder backend deploy.
- Player VIP voordelen met economy-impact (zoals cooldown-reductie of periodieke credit grants) moeten via backendregels afdwingbaar blijven en in de player copy expliciet vermeld worden.
- Als Player VIP nieuwe module-specifieke QoL-perks krijgt (zoals VIP one-click ontbrekende materials kopen in Drugs Productie), moet die benefit expliciet in de VIP aankoop- en info-copy staan (NL+EN).
- Wekelijkse Player VIP-credit grants moeten ledger-traceerbaar zijn via `player_credit_transactions` (reasonKey + metadata), zodat support/admin uitbetaling kan herleiden.
- Admin full player reset (`POST /admin/players/:playerId/reset` en `reset-all`) mag VIP/abonnementvelden (`isVip`, `vipExpiresAt`, `vipLifetimeDays`, Mollie/Stripe customer/subscription ids) nooit wissen. Credits mogen alleen terug naar het restant van **betaalde** pack-aankopen (ledger `PURCHASE`/`REFUND` met `premium_checkout`); VIP-stipend, event rewards en vault-prijzen tellen niet als betaald.
- Credit koopbundels en credit-redemption costs moeten admin-beheerbaar zijn via de premium adminflow en niet hardcoded in player UI.
- Creditbundel-checkout (`POST /subscriptions/checkout/one-time`) mag `quantity` 1–20 meenemen voor `rewardType === 'credits'`. Prijs en credit-grant schalen lineair (`unit × quantity`). Event Pass, ammo, money en andere one-time producten blijven altijd quantity 1, ook als de client een hoger getal stuurt. Mollie metadata bewaart `quantity` als string; webhook-fulfillment vertrouwt die waarde van de payment, niet een tweede clientcall.
- Default creditbundels mogen server-side ge-seed worden voor een lege catalogus, maar key, prijs, credit-amount en beeldpad moeten stabiel en idempotent blijven. `ensureDefaultCreditCatalog` upserts retry MariaDB 1020 so concurrent credits-overview loads do not 500.
- Legacy offers met verouderde prijsstelling (zoals 1000 credits voor 1,99) mogen niet meer in de actieve player-catalogus of checkout terechtkomen; blokkeer of deactiveer deze server-side.
- Premium/Credits tegelafbeeldingen blijven extern gehost onder `images/premium_tiles/...`; generator, backend-catalogus en client mapping moeten dezelfde vaste bestandsnamen delen.
- Voor `ACTION_COOLDOWN_RESET` items geldt dynamische prijsstelling op basis van resterende cooldown en action-value; expose deze altijd als runtime `effectiveCreditCost` in de overview.
- Dynamische cooldown-prijsstelling moet progressief maar mild blijven: korte cooldowns (zoals crime ~1-2 minuten) horen geen disproportioneel hoge creditprijs te krijgen.
- Cooldown-reset redemptions moeten blokkeren zonder actieve cooldown (`ACTION_COOLDOWN_NOT_ACTIVE`) om creditverlies te voorkomen.
- Ondersteunde gameplay-timeout overlays (crime, jobs, school, voertuig- en bootdiefstal, en andere actieve cooldown-schermen met matchende actionType) moeten een directe credit speed-up knop tonen; speler mag niet geforceerd worden eerst terug te navigeren naar VIP of Credits.
- Voor `VEHICLE_REPAIR_FINISH` moet op beschadigde voertuigkaarten (garage/marina) een contextuele credits-knop zichtbaar zijn; de flow start indien nodig eerst reparatie en rondt daarna direct af via dezelfde redeem-flow met `vehicleInventoryId`.
- Drug production speedup gebruikt een dedicated drugs-API (`/drugs/productions/:id/speedup-quote` + `/speedup`) met ledger `reasonKey=drug_production_speedup`; geen catalog-item in de premium shop.
- Het instant-repair icoon op voertuigkaarten gebruikt een gecombineerde visual (steeksleutel + bliksem) zodat de actie herkenbaar blijft als reparatie én instant effect.
- Tijdelijke `EVENT_BOOST` credit-items moeten capped side-grade boosts blijven; geen permanente statstacking of pay-to-win power creep.
- Cosmetische credit-sinks (zoals `estate_gold_fence`) mogen geen combat-power toevoegen. Eerst meten of iemand credits skip’t; geen verplichte paywall.
- Minigames met credits-inzet (zoals **Kraak de Kluis**) moeten credits **transactioneel** afschrijven (REDEEM) en prijzen **traceerbaar** uitbetalen (ledger + metadata: seasonKey, stakeTier). Als een VIP-prijs niet toepasbaar is (speler is al VIP), moet de prijs **consequent** worden omgezet naar credits (geen provider-jargon in UI).

## Backend Contract Guardrails
- Nieuwe provider-velden en transaction-modellen moeten ook in Prisma bestaan vóór gebruik.
- Productie-deploys mogen niet stil afhankelijk zijn van handmatig gedraaide DB-migraties: voor kritieke premium/gameplay tabellen mag een startup `ensure*Schema` bootstrap bestaan die ontbrekende tabellen/kolommen veilig aanmaakt (idempotent), zodat endpoints niet 500'en na deploy.
- Webhook-code moet status server-side ophalen bij Mollie; vertrouw nooit alleen request-body.
- Gebruik unieke provider payment-id opslag voor idempotente fulfillment.
- Redemptions die gameplay-data aanpassen moeten ownership en actieve state valideren.
- Bij meldingen zoals `Unknown column players.mollieCustomerId` eerst migration drift oplossen (latest Prisma migrations deployen) vóór verdere code-debugging.

## Frontend Loading Guardrails
- Premium catalogus, VIP-status en credits-overzicht moeten los kunnen falen zonder het hele premiumblok leeg te trekken.
- Toon duidelijke feedback voor open/cancelled/paid checkout-terugkeer.
- Houd mobile cards compact; prijzen en benefits moeten zonder horizontale overflow leesbaar blijven. De store gebruikt compacte rijen, geen vierkante fototegels.
- In-game cash (`rewardType=money`) hoort in de Credits-tab zichtbaar en checkoutbaar te zijn. Default packs: €50k / €120k / €400k / €1m.

## QA Checklist
1. Player VIP checkout opent Mollie en paid webhook activeert VIP.
2. One-time purchase grant wordt exact één keer fulfilled.
3. Credit purchase verhoogt wallet en schrijft ledger-regel.
3b. Creditbundel met quantity 3 rekent 3× de pakketprijs af en grant 3× de pack-credits in één fulfillment; quantity 0/negatief/niet-numeriek valt terug op 1; quantity >20 wordt 20. Event Pass blijft 1 pack ongeacht quantity.
4. Credit redeem verlaagt wallet en past effect alleen toe bij geldige target/state.
5. Webhook retry veroorzaakt geen dubbele grant.
6. Admin/cataloguswijziging wordt correct teruggeleverd in player catalog endpoint.
7. Crew, hitlist/security en vehicle flows blijven correct na premium effect.
8. Een lege premium-catalogus krijgt automatisch de verwachte default creditbundels (250 / 500 / 1000 / 2500) zonder duplicaten.
9. Premium tiles laden op web correct via de externe runtime-route en tonen na een refresh de actuele cache-bust versie.
10. Admin player-management kan premium credits set/add uitvoeren met correcte permissies (viewer blok, moderator limiet, super admin volledige limiet).
11. Admin full player reset houdt VIP/auto-renew intact en zet `premiumCredits` op het restant van gekochte packs (niet op 0, niet inclusief stipend/event/vault).

## i18n and Messaging
- Prijslabels en benefit-teksten in NL en EN synchroon houden.
- Gebruik onderscheid tussen abonnement, losse aankoop en credit redemption in copy.
- Vermijd provider-jargon in player UI; gebruik heldere termen als `betaalpagina`, `abonnement`, `credits`.
- Redirect-feedback voor `paid`, `success`, `cancelled`, `failed` en `expired` moet player-facing meertalig zijn en semantisch kloppen voor VIP versus losse aankoop/credits.

## When To Update This File
Update bij nieuwe betaalproviders, nieuwe premium-producttypes, nieuwe entitlement-effecten, webhook- of refund-flows en admin-support uitbreidingen.
