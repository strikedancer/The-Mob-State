# Hitlist Protocol

## Scope
Hit placement, bounties, detective investigations, combat mechanics, counter-bounties, crew hits and security lifecycle management.

**Core Game Loop:**
1. Speler plaatst bounty op enemy (geld afgetrokken)
2. Potentiële assassins huren detective voor locatie
3. Assassin wacht op moment + staat in land op
4. Combat (attacker vs defender)
5. Bounty uitbetaald aan winner

## Primary Frontend Entry
- client/lib/screens/hitlist_screen.dart
- client/lib/screens/enemies_screen.dart (hit placement context)
- client/lib/components/hit_card_list.dart

## Primary Backend
- backend/src/services/hitlistService.ts
- backend/src/services/detectiveService.ts (NEW)
- backend/src/routes/hitlist.ts
- backend/src/routes/detective.ts (NEW)
- Prisma models: hitList, detective, playerSecurity, playerInsurance

## Change Rules
- Preserve hit economcis: €50K minimum, €50M maximum
- Avoid hidden bounty changes without notification
- Counter-bounty reversal must be atomic (prevent exploit)
- Detective reports must respect 3-hour window after delivery
- All bounty payouts must be transaction-safe
- Keep Dutch and English copy in sync for notifications
- Keep layout usable on mobile, tablet and desktop
- Web dashboard Hitlist hides the inner AppBar title; the sidebar already names the page. Keep the shared status bar above the content card. The screen uses the same noir/gold header + contract cards as Crimes/Jobs.
- Never allow permanent "hunted" without escape option

## Check Before Editing
- What is the attacker trying to achieve? (stealth, public, economic drain?)
- Which timers, locks or protection modes affect the flow?
- Does this module emit notifications, inbox messages, achievements?
- Does detective report need location accuracy validation?
- Are combat calculations symmetrical (no one-sided builds)?
- Is bounty payout atomic and transaction-safe?

## Must Preserve
- Accurate bounty math (attacker power vs target defense)
- Clear success/failure statuses (ACTIVE, COMPLETED, CANCELLED, REVERSED)
- Accurate kill counts and reputation tracking
- Protection options (Insurance, Witness Protection, Safe House, Premium Protection)
- Detective window (3-hour expiry after report)
- Counter-bounty reversal (must reverse attacker AND target roles)
- Consistent formatting for money, timers, bounty amounts
- Responsive usability without hiding critical actions
- Loot reward percentages must be runtime-configurable via admin settings (`HITLIST_LOOT_CASH_PERCENT`, `HITLIST_LOOT_ITEM_PERCENT`) and not hardcoded in code or file-only env workflow
- On successful hit, kill-reset behavior must branch by VIP status:
- Active Player VIP: victim keeps bank + crypto + education + achievements, rank is halved, on-hand cash resets to a fixed restart amount, and assets/inventory/drugs are wiped.
- No active Player VIP: victim receives a full progression reset (including bank/crypto/education/achievements) to baseline.
- Killer loot remains limited to a configurable share of victim on-hand cash and carried inventory, never bank balance.
- Tijdelijke premium/combat boosts blijven side-grade: capped attack/defense modifiers zonder permanente statinflatie of pay-to-win top-tier power.

## Data Contract Requirements

### hitList Table
```sql
- id (int, PK)
- placedById (int, FK→players)
- targetId (int, FK→players)
- targetCrewId (int, FK→crews) [nullable; if set, crew hit]
- bounty (decimal)
- counterBounty (decimal) [nullable]
- status (ACTIVE, COMPLETED, CANCELLED, REVERSED)
- createdAt (datetime)
- completedAt (datetime) [nullable]
- completedBy (int, FK→players) [nullable; who completed]
- isAnonymous (bool)
- useContractManager (bool)
```

### detective Table (NEW)
```sql
- id (int, PK)
- hirerId (int, FK→players)
- targetId (int, FK→players)
- reportedLocation (varchar; country)
- reportedRegion (varchar; region/city)
- reportedAt (datetime)
- expiresAt (datetime) [+3 hours from reportedAt]
- cost (decimal)
```

### playerSecurity Table
```sql
- playerId (int, PK, FK)
- bodyguards (int, default 0)
- armor (varchar; 'kevlar'|'combat'|'tactical')
- armorDurability (decimal 0-100; degrades -5% per 24h)
- premiumProtectionUntil (datetime) [nullable]
- insuranceUntil (datetime) [nullable]
```

### playerInsurance Table (NEW)
```sql
- id (int, PK)
- playerId (int, FK, UNIQUE)
- insuranceLevel (int; 1=basic, 2=premium)
- paidUntil (datetime)
- autoRenew (bool)
- claimsUsed (int)
```

## i18n and Messaging

### Victim Murder Notification + Killer Investigation
- Bij succesvolle hit krijgt het slachtoffer direct een inbox-bericht + push van `Moordlijst Bureau` / `Hitlist Bureau`.
- Dit bericht bevat een in-app actieknop om een detective-onderzoek te starten.
- Deze knop is maximaal 24 uur beschikbaar na de moord.
- Na starten stuurt `Detective Bureau` een follow-up inbox/push rapport met variabele wachttijd (niet instant):
  - snel aangevraagd na de moord -> kortere wachttijd
  - laat aangevraagd binnen het 24-uurs venster -> langere wachttijd omdat de dader meer tijd heeft om sporen te wissen en zich te verplaatsen
  - bij succes: gebruikersnaam van de moordenaar
  - bij falen: melding dat de dader niet met zekerheid vastgesteld kon worden
- Een murder case kan maar eenmaal onderzocht worden en kan niet heropend worden.

### Hit Placed Notification Coverage
- Zodra een speler op de hitlist wordt gezet, ontvangt het doelwit direct een inbox-bericht + push van `Moordlijst Bureau` / `Hitlist Bureau` met minimaal bounty-bedrag en waarschuwing.
- Deze notificatie is onderdeel van de verplichte lifecycle-notificaties voor hitlist-events en mag niet stil wegvallen bij succesvolle hit-creatie.
- Push voor `hit placed` moet via een dedicated notificatietype (`hitlist_placed`) lopen; gebruik niet uitsluitend de generieke direct-message pushroute voor deze kritieke lifecycle-melding.

### Notifications (Push + Inbox)

**Hit Placed ON ME:**
```nl
"🎯 Er is een moordslooptocht op je gezet!"
"Bedrag: €XXX.XXX door [Name|Anonymous]"
"Opties: Bescherming kopen / Counter-hit plaatsen"
```

```en
"🎯 A hit has been placed on you!"
"Amount: €XXX,XXX by [Name|Anonymous]"
"Options: Buy protection / Place counter-hit"
```

**Detective Report Received:**
```nl
"🔍 Detective rapport ontvangen"
"Locatie van [Target]: [Country] - [Region]"
"Geldig tot: [Time remaining]"
```

```en
"🔍 Detective report received"
"Location of [Target]: [Country] - [Region]"
"Valid until: [Time remaining]"
```

**Hit Success (Killer Loot Notification):**
- Na een succesvolle kill ontvangt de moordenaar direct een inbox-bericht + push van `Moordlijst Bureau` / `Hitlist Bureau` met bounty-bedrag, buit-geld (€ en %) en aantal buit-items.
- Bericht is meertalig (NL/EN) op basis van `preferredLanguage` van de aanvaller.

```nl
"💀 Moordslooptocht voltooid!"
"Je verdiende: €XXX.XXX"
"Contant geld buit: €YY.YYY (60% van €ZZ.ZZZ)"
"Items buit: N voorwerp(en) overgenomen."
```

```en
"💀 Hit completed!"
"You earned: €XXX,XXX"
"Cash looted: €YY,YYY (60% of €ZZ,ZZZ)"
"Items looted: N item(s) transferred to your inventory."
```

**Hit Failed:**
```nl
"❌ Aanval mislukt — doelwit overleefde"
"Contract blijft open"
"Lijfwachten en HP geraakt; volgende poging over 10 minuten"
```

```en
"❌ Attack failed — target survived"
"Contract stays open"
"Bodyguards and HP were hit; next attempt in 10 minutes"
```

**Counter-Bounty Reversal:**
```nl
"⚠️ Counter-moordslooptocht geplaatst!"
"Je bent NU het doelwit: €XXX.XXX"
"Annuleer met €YYY.YYY of accepteer het risico"
```

```en
"⚠️ Counter-hit placed!"
"YOU are now the target: €XXX,XXX"
"Cancel for €YYY,YYY or accept the risk"
```

**Protection Modes:**

*Premium Protection (Betaalde Dienst):*
```nl
"🛡️ PREMIUM BESCHERMING ACTIEF"
"24 uur volledig beschermd tegen moordpogingen"
"Vervalt: [TIME] (niet verlengbaar)"
```

```en
"🛡️ PREMIUM PROTECTION ACTIVE"
"24 hours fully protected against assassination attempts"
"Expires: [TIME] (not extendable)"
```

*Regular Protection Mode (verzekeringen):*
```nl
"🛡️ Je bent beschermd via insurance"
"Tegels betaalt je dekking"
```

```en
"🛡️ You are protected via insurance"
"Tegelz covers your bounties"
```

## Backend Data Validations

### Hit Placement
- ✅ bounty >= €50K
- ✅ bounty <= €50M (or €500M for crew hits)
- ✅ playerId !== targetId
- ✅ Player has bounty amount in account
- ✅ No more than 5 active hits per placer
- ✅ Target exists (or crew exists if crew hit)

### Detective Hiring
- ✅ tiered cost based on speed and delay: quick €1M (1h), standard €500K (6h), deep €250K (24h)
- ✅ hirerId has funds
- ✅ No duplicate detective on same target
- ✅ Target exists
- ✅ Report arrives asynchronously (not instant) and expires after 3 hours post-delivery
- ✅ Target bodyguards can cloud or block the report (Quick is weakest vs guards). Slow always leaks country; after 48h offline intel steps up, after 7 days the report is full. Killer bodyguards lower murder-case identify chance (floor 20%), with the same offline decay.

### Attack Attempt
- ✅ Attacker and target in same country
- ✅ Attacker has a usable weapon in inventory (weaponId present, quantity > 0, condition > 0) + enough ammo
- ✅ Broken weapon returns explicit repair-required feedback (no generic "not owned" fallback)
- ✅ Client inventory parsing must tolerate numeric fields arriving as numbers or numeric strings; hitlist UI may not false-block attack flow because `quantity`/`condition` serialization differs per environment
- ✅ Client inventory-fed attack dialogs must normalize decoded JSON maps to string-keyed maps before filtering or rendering; runtime `Map<dynamic, dynamic>` payloads may not collapse valid weapon lists to empty
- ✅ Target defense queries may only request schema-valid Prisma fields; do not select removed legacy fields (e.g. `player.weapon`) in hit combat flow
- ✅ Shared combat services must keep import/export contracts stable (named/default) so runtime weapon definition resolution cannot become `undefined`
- ✅ On successful hit, target receives a hard progress reset (inventory, tools, properties, productions, crypto, cooldowns and key progress fields reset to baseline), while bank balance and crew leadership are preserved; attacker receives configured loot share on top of bounty
- ✅ Target is not in Premium Protection mode
- ✅ Attacker not in global cooldown (24h after fail)
- ✅ Hit is ACTIVE status
- ✅ Combat power calculation is atomic

### Counter-Bounty
- ✅ Only target can place
- ✅ counterBounty > original bounty
- ✅ Target has funds for difference
- ✅ Hit is ACTIVE status
- ✅ Reversal is atomic (both players updated together)
### Premium Protection Mechanic (Betaalde Feature)

**Implementatie:**
```typescript
interface PremiumProtection {
  playerId: int;
  purchasedAt: datetime;
  expiresAt: datetime; // +24h from purchase
  paymentId: string; // Stripe/payment processor ID
  status: 'ACTIVE' | 'EXPIRED' | 'REFUNDED';
  cost: decimal; // €4.99
}
```

**Backend Validations:**
- ✅ paymentId exists & verified (niet in-game geld!)
- ✅ Only one active per player (exclusive)
- ✅ Expires exactly 24h (not extendable)
- ✅ Cooldown check (7 days min between purchases)
- ✅ Attack attempts fail with "TARGET_PREMIUM_PROTECTED" error
- ✅ Refund logic if < 1 min used

**UI Indicators:**
- "🛡️ PREMIUM PROTECTED" badge on profile
- Countdown timer (24h format)
- "Cannot attack: Target has premium protection"
- Cannot be combined with other protections
## Combat Mechanics

### Power Calculation
```typescript
// Attacker
shootingAccuracy = min(0.9, 0.5 + (shootingSessions/100)*0.4);
hitChance = max(0.2, shootingAccuracy); // min 20% hit rate
weaponDamage = weapon.damage * ammo.quality * hitChance;
attackerPower = weaponDamage * ammoCount;

// Target
armorDefense = getCombatArmor(security, attack) + bodyguardDefense(roster);
# roster = street/standard/elite counts; see security.md / securityEconomy.ts
weaponDefense = target.weapon.damage * 5; // assume 5 ammo
targetPower = weaponDefense + armorDefense;

// Win Chance
winChance = attackerPower / (attackerPower + targetPower);
roll = random(0-1);
attackerWins = roll < winChance;
// Attempt responses include `combat` (armorDefense, bodyguardDefense, winChancePercent, vestMatch).
// Failed hits that resolved combat set `defended: true`, stay ACTIVE, apply guard/HP/vest attrition
// to both attacker and target, and set lastCombatAt (10 minute retry lock). They do not refund the bounty.
// A successful kill still applies lighter attacker attrition.
```

### Atomic Transactions
```typescript
await prisma.$transaction([
  // If attacker wins:
  hitList.update(...status: COMPLETED),
  player.update(...playerId: attacker, money: +bounty, killCount: +1),
  player.update(...id: target, health: 0, hitCount: +1),
  // Log achievement
], { isolationLevel: 'Serializable' });
```

## QA Checklist
- ✅ Open hitlist screen on mobile, tablet, desktop widths
- ✅ On web dashboard, verify there is no extra “Moordlijst” AppBar title, the hero shows open-count + security, and hit cards stay readable on the dark panel
- ✅ Place hit (€50K, €500K, €5M) - check money deducted
- ✅ Hire detective (all 3 cost tiers) - check queue response is immediate but report delivery happens in 1h/6h/24h via Detective Bureau inbox message
- ✅ View detective report - check 3-hour expiry countdown
- ✅ Attempt hit (success + failure) - success pays bounty; failure keeps the contract, cuts guards/HP, wears vest, and locks retries for 10 minutes
- ✅ Place counter-bounty - check reversal atomicity (role swap)
- ✅ Buy bodyguards/armor - check defense bonus applies
- ✅ Buy Premium Protection - check 24h immunity + can't be attacked
- ✅ Buy Insurance - check hit payout covers bounty instead of death
- ✅ Refresh page mid-attack - check state persists correctly
- ✅ Check notifications (push + inbox) - NL/EN both present
- ✅ Verify no text overflow on hit cards
- ✅ Verify cooldowns are enforced (24h after fail, 6h after success)
- ✅ Test crew hits (hit multiple crew members, track bounty distribution)
- ✅ Verify hit escalation (auto +5% after 72h)
- ✅ Check admin logs show all hit activities with timestamps

## Known Risks & Mitigations

**Risk:** Attacker + Target collude to "farm" bounty
*Mitigation:* Attacker gets -10 reputation + loses 50% bounty if same attacker wins repeatedly against same target

**Risk:** Detective reveals target forever (not 3h)
*Mitigation:* Report is deleted from DB after 3h expiry; target can shift country

**Risk:** Counter-bounty reversal is not atomic (half-update)
*Mitigation:* Wrap both player + hitList updates in prisma.$transaction()

**Risk:** Bodyguard spam makes all attacks impossible
*Mitigation:* Bodyguard cost scales (2x per 10 guards); DIM returns decrease

**Risk:** Premium Protection is "pay to never lose"
*Mitigation:* High cost (€500K) + 7-day cooldown + 24h duration only

## When To Update This File
- When hit economcs change (costs, bounties, rewards)
- When detective timing/accuracy changes
- When combat mechanics change
- When new protection modes added
- When crew hit rules change
- When major QA risks emerge

## Related Protocols
- [crimes.md](crimes.md) - Murder as crime category
- [security.md](security.md) - Armor/bodyguard mechanics
- [crew.md](crew.md) - Crew hit mechanics
