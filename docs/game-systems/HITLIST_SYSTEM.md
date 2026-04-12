# 🎯 Moorlijst Systeem (Hitlist)

## Overzicht

Het moorlijst systeem stelt spelers en crews in staat om elkaar op een "hit" list te zetten. Dit is een ernstig risico-systeem met hoge economische stakes, combat mechanics en strategie-diepte.

**Centrale idee:** Spelers kunnen geld inzetten op het vermoorden van anderen, maar doelwit kan zich verdedigen of beschermen.

---

## 📋 Basismechanica

### Hit Plaatsen

**Wat:** Een speler plaatst een hitbounty op iemand anders
**Hoe:** 
- Openbaar hitlist scherm of via Private/Enemies liste
- Selecteer target (speler of crew)
- Voer bounty in (minimaal €50.000)
- Geld wordt onmiddellijk afgetrokken

**Gevolgen:**
- Target krijgt notification: "X plaatste een hit op jou voor €Y"
- Target is voortaan "HUNTED" (iedereen kan attack)
- Hit verschijnt op globale hitlist (anoniem, tenzij je naam wilt tonen)
- Hit kan tot 6 maanden actief blijven (tenzij gecanceld/compleet)

### The Poging (Murder Attempt)

**Wat:** Speler probeert target in hetzelfde land te vermoorden

**Requirements:**
- Beide spelers in HETZELFDE land
- Attacker moet genoeg ammo hebben
- Target moet "ontschuldigd" zijn (niet in bedrijf, reis, etc)
- Weapon moet beschikbaar zijn

**Combat Systeem:**
```
Attacker Power = Weapon Damage × Ammo × Accuracy × Ammo Quality
Target Defense = Armor + (Bodyguards × 10) + Escape Chance
Win Chance = Attacker Power / (Attacker Power + Target Defense)
```

**Uitkomsten:**
- **Attacker Wins:** Target sterft, attacker krijgt bounty
- **Target Wins:** Hit geannuleerd, attacker krijgt negatieve rep

### Bescherming

**Bodyguards (€10.000/stuk)**
- Verhoogt defence power (+10 per bodyguard)
- Kunnen ook gebruikt worden voor crew security

**Armor (€25.000-€100.000)**
- Verhoogt defense armor rating
- Verschillende typen: Kevlar (light), Combat (medium), Tactical (heavy)
- Slijtage -5% per 24 uur (vervangingskosten)

**Premium Protection (Betaalde Dienst - €4.99 voor 24 uur)**
- ENKEL MET ECHT GELD - niet in-game geld
- Volledige immuniteit tegen hits
- Target kan niet aangevallen worden
- Toon als "PREMIUM PROTECTED" status
- Cooldown 7 dagen tussen purchases
- Automatisch verval na 24h (geen reminder nodig)
- Refundable: 100% geld terug als niet gebruikt

---

## 🔍 Detective Mechanic (Nieuw!)

### Hoe het Werkt

**Detective Inhuren:**
- Kosten: €100.000 per "investigation"
- Je ziet target's locatie NA bepaalde verstreken tijd:
  - 1 uur: €100K (snelle scan)
  - 6 uur: €50K (goedkoper, langer wachten)
  - 24 uur: €25K (gratis locatie info, maar vaste time)

**Wat je Leert:**
```
Detective Report:
- Target's actual country: [NIEUW]
- Target's exact city/region: [Region niveau]
- Target's activity status (online/offline/last seen)
- Target's current protection level (bodyguards, armor)
- Target's estimated weapon/ammo
```

**Timing:**
- Report verschijnt in je inbox nadat tijd verstreken is
- Je hebt DAN nog 3 uur om target in dat land op te zoeken
- Na 3 uur kan target zijn locatie veranderen

**Restrictions:**
- Je kunt niet twee investigators tegelijk op dezelfde target sturen
- Als target in "Premium Protection", detective ziet alleen "PROTECTED"
- Detective report verdwijnt na 3 uur (niet permanent)

---

## 🛡️ Beschermingssysteem (Uitgebracht)

### Hit Insurance

**Kosten: €200.000/maand**
- Automatische coverage tegen alle hits
- Bounty wordt door insurance betaald (jij sterft niet)
- Max 3 maanden vooruitbetaling

### Witness Protection (Escape Option)

**Kosten: €300.000 voor 48 uur**
- Target kan zich "schuilen" voor 48 uur
- Kan niet aangevallen worden
- Kan wel geld verdienen / jobs doen (offline activity)
- Naam verdwijnt van hitlist (anoniem)

### Safe House Mode

**Kosten: Gratis voor 1 uur, daarna €10K/uur**
- Je bent veilig in je safehouse (niet aanvalbaar)
- Kan niet reizen of criminaliteit plegen (gefocust mode)
- Max 6 uur per dag

---

## 💰 Bounty Mechanics

### Initiële Bounty

Je plaatst: €50K - €10M
- Hoe meer geld, hoe meer exposure (meer attackers weten van hit)
- Kleine bounties: 1-3 potentiële assassins
- Grote bounties: 10+ potentiële assassins

### Counter-Bounty (Target Response)

**Target kan verhogen:**
- Minimaal: Original bounty + €10K
- Effect: Hit reverses (nu is HIT PLAATSER het doelwit!)
- Plaatser krijgt notification "TARGET PLACED COUNTER-HIT ON YOU!"
- Plaatser kan dan afbouwen of accepteren

**Scenario:**
```
Alice plaatst €200K hit op Bob
Bob plaatst €300K counter-hit

Nu is ALICE het doelwit voor €300K
Alice kan:
1. Cancel: Verliest €200K (om uit te stappen)
2. Verhogen naar €400K: Omgekeerd weer
3. Accepteren: Fight speelt zich af voor €300K bounty
```

### Automatic Bounty Escalation

**Na 72 uur inactief:**
- Bounty stijgt automatisch +5%
- Per 24 uur daarna: +3% (cap op 50% increase)
- Dit motiveert assassins om eindelijk actie te nemen

**Notifiation:** Plaatser en assassins beide notification

---

## 👥 Crew Hits (Uitgebracht)

### Crew-op-Crew Hits

**Wat:** Crew A plaatst hit op Crew B

**Opzet:**
- Hit plaatsen: €500K - €50M (veel groter scale)
- Target: Heel crew (alle members kunnen aangevallen worden)
- Hit completion: Als 3+ crew members dood zijn OF leader dood
- Bounty: Verdeeld onder diegenen die crew-members killden

**Strategic Element:**
- Crew A kan andere crews erbij betrekken
- Crew B kan allies inhuren
- Soort "gang war" economie

---

## ⚠️ Failure Penalties & Rep Hit

### Mislukte Aanval Gevolgen

**Attacker loses:**
- €10K-€50K "repair costs" voor gewapend conflict
- -5 reputation (slachtoffer verspreidt verhaal)
- Target krijgt notification who tried + kan counter-hit

**Attacker benefits:**
- Niemand anders weet (alleen target)
- Attacker kan opnieuw proberen na 24 uur cooldown

### Public Failure (Witnesses)

**Bepaalde crime activities veroorzaken "witnesses":**
- Failed hit in crowded city region
- Police spot combat scenario
- Result: Hit wordt PUBLIC (hitlist show attacker's name)

---

## 🎌 Contract Manager (Anonymous Hitman)

### Het Systeem

Je wilt anoniem een hit plaatsen? Gebruik Contract Manager:

**Kosten:** +30% op bounty (intermediair fee)
```
Directe hit: €100K
Via Contract Manager: €130K (€30K fee)
```

**Voordelen:**
- Plaatser is anoniem (target ziet "ANONYMOUS HIT")
- Attacker weet niet wie plaatste
- Extra strategie layer (verdacht spel)

**Nadelen:**
- 30% duurder
- Manager kan "betaald" worden om hit te "mislopen" (bribery risk)

---

## 📊 Progression & Achievements

### Killer Stats
- **Kill Count:** Totale murders gepleegd
- **Bounty Earned:** Totale geld verdiend via hits
- **Survival Rank:** Hoe veel keer je overleefde

### Titles
- "The Cleaner" (50+ kills)
- "Untouchable" (100+ survived hits)
- "Godfather" (250+ kills)
- "Ghost" (50+ anonymous hits)

### Achievements
- "First Blood" (eerste kill)
- "Back Against the Wall" (3x counter-bounty scenario)
- "Lone Wolf" (50 kills samen)
- "Army" (crew kills 10+ members in 1 week)

---

## 🚨 Safety & Cooldowns

### Cooldowns
- **Attack cooldown:** 24 uur na fail
- **Same target cooldown:** 6 uur na success
- **Change country:** 2 uur (moet reizen naar target)
- **Detective hire:** Max 1 per target tegelijk

### Limits
- **Max bounties plaatsen:** 5 tegelijk (prevent spam)
- **Max bounties op jOU:** Onbeperkt (maar stijgt met tijd)
- **Max allies:** 3 crews kunnen samenkomen op 1 hit

---

## 💯 Balancing Considerations

### Cost Curve
```
Entry Level (Sollowaalder): €50K-€100K
Mid Tier: €100K-€500K  
High Stakes: €500K-€5M
Mega Hits: €5M-€50M (crew wars)
```

### Success Rate by Power
- Underdog win (>80% chance): €200K bonus (risk reward)
- Fair fight (40-60%): Normal bounty
- Overdog win (<20% chance): Only 50% bounty (nerf stomp)

### Insurance Costs (Anti-Spam)
- If many hits open: Price scales up 2x-10x
- Prevents hitlist becoming "pay to win"

---

## 🎮 Endgame Strategy

### Common Tactics

1. **The Trap:** Plaats small bounty → target plays casual → Detective + Counter-Bounty reversal
2. **Gang War:** Crew coordinated hits on rival crew
3. **Economic Attrition:** Constant small bounties drain target's money
4. **Reputation Warfare:** Anonymous hits to embarrass targets
5. **Bodyguard Standoff:** Both sides hire so many guards neither can win (stalemate)

### Counters
- Insurance prevents trap
- Witness Protection forces attacker to wait
- Counter-hit turns table
- Contract Manager adds mystery

---

## 📱 UI/UX Components

### Hitlist View
- Global list (open bounties)
- Personal list (hits on me)
- My Contracts (hits i've placed)
- Kill History (achievements)

### Hit Card
```
[Target Name] [Level X]
└─ Bounty: €XXX,XXX
└─ Placed by: [Anonymous|Name]
└─ Created: 2d 14h ago
└─ Status: ACTIVE | HUNTED | PROTECTED
└─ Detective Available: ✓ (€25K-€100K)
└─ Kill History: 2 attempts (both failed)

[Attack Button] [Counter-Hit] [Detective Button]
```

### Detective Report
```
📋 Detective Report Received!
Target: [Name]
Location: [Country / Region]
Status: Online (Last seen: 2m ago)
Security: 3 Bodyguards + Kevlar Armor
Window: 3 hours remaining
```

---

## ✅ QA & Balance checklist

- Hit system nie exploitable door crew-coordination
- Detective timing prevents "permanent hunted" state
- Counter-bounty actually reverses (niet farming)
- Protection costs prevent casual buy-forever
- Insurance costs prevent spam
- Failed hits have social consequence (reputation)
- Kill counts accurately tracked
- Bounty payouts correct (no database exploits)
- Crew hits scale properly with membership
- Experience gains logged for audit

---

## Zie Ook

- [GAMEPLAY.md](GAMEPLAY.md) - Centrale spelregels
- [hitlist.md protocol](../module-protocols/hitlist.md) - Implementation details
- [crimes.md protocol](../module-protocols/crimes.md) - Combat mechanics
- [security.md protocol](../module-protocols/security.md) - Armor/bodyguard system
