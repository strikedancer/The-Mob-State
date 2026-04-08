# Crime Rank Requirements - Verbetervoorstel

## 🎯 Doelstellingen
1. **Geleidelijke progressie**: Elke rank moet minimaal 1-2 crimes hebben
2. **Logische opbouw**: Simpel → Complex, Geweldloos → Gewelddadig
3. **Balans**: Reward moet matchen met risico en rank requirement
4. **Thematische clustering**: Gerelateerde crimes bij elkaar

## 📈 Voorgestelde Rank Progressie

### 🟢 BEGINNER TIER (Rank 1-5) - Leerfase
**Doel**: Kleine misdaden met lage risico's om basis mechanics te leren

**Rank 1** (Starter crimes - geen voertuig/wapen nodig):
- ✅ Zakkenrollen (€50-200, 10 XP)
- ✅ Winkeldiefstal (€100-300, 15 XP)
- ✅ Fiets stelen (€80-150, 12 XP)
- ✅ Vandalisme (€30-100, 8 XP)
- ✅ Graffiti (€20-80, 5 XP)

**Rank 2** (Eerste gewelddadige crime):
- ✅ Beroving (€200-600, 25 XP) - vereist wapen

**Rank 3** (First vehicle & drugs):
- ✅ Auto diefstal (€500-2000, 50 XP)
- ✅ Kleine drugsdeal (€300-800, 35 XP)

**Rank 4** (Vehicle based crimes):
- ✅ Autoonderdelen stelen (€400-1200, 40 XP)

**Rank 5** (Eerste serieuze crime):
- ✅ Inbraak (€800-3000, 80 XP) - vereist voertuig

---

### 🟡 INTERMEDIATE TIER (Rank 6-12) - Professionalisering
**Doel**: Overvallen en georganiseerde misdaad

**Rank 6** (Gewelddadige afpersing):
- ✅ Afpersing (€1000-3500, 100 XP)

**Rank 7** (Gewapende overvallen):
- ✅ Winkel overvallen (€1500-5000, 120 XP) - wapen + voertuig
- ✅ Beschermingsgeld (€1200-4000, 110 XP) - wapen vereist

**Rank 8** (Technische crimes):
- ✅ Geldautomaat kraken (€2000-6000, 150 XP)
- ✅ Grote drugsdeal (€2500-7000, 180 XP)

**Rank 9** (Internationale crimes):
- ✅ Smokkel (€2800-8500, 220 XP) - speciale voertuig vereisten

**Rank 10** (Zware gewelddadige crimes):
- ✅ Vrachtwagen kapen (€3000-8000, 200 XP)
- ✅ Brandstichting (€3500-10000, 250 XP)

**Rank 11** (Cyber crimes start):
- ✅ Account hacken (€4000-12000, 280 XP)

**Rank 12** (High-value targets):
- ✅ Juwelier overval (€5000-15000, 300 XP) - wapen + voertuig
- ✅ Ambtenaar omkopen (€5000-16000, 320 XP)

---

### 🟠 ADVANCED TIER (Rank 13-20) - Expert Crimineel
**Doel**: Complexe misdaden met hoge rewards en federal attention

**Rank 13** (Financial fraud):
- ✅ Geld vervalsen (€6000-18000, 350 XP) - **FEDERAL**

**Rank 14** (Advanced cyber):
- ✅ Identiteitsdiefstal (€7000-20000, 400 XP) - **FEDERAL**

**Rank 15** (Violent organized crime):
- ✅ Ontvoering (€10000-30000, 500 XP) - **FEDERAL**, wapen vereist

**Rank 16** (High-value theft):
- ✅ Kunstdiefstal (€12000-35000, 550 XP)

**Rank 17** (Luxury targets):
- ✅ Jacht stelen (€18000-45000, 600 XP)

**Rank 18** (Armed transport heists):
- ✅ Geldwagen overvallen (€15000-40000, 650 XP) - **FEDERAL**

**Rank 19** (NEW - Contract killing tier):
- 🆕 **VOORSTEL**: Verplaats "Huurmoord" hierheen (nu rank 20)
- 🆕 **VOORSTEL**: Nieuwe crime "Getuige Elimineren" (€15000-35000, 600 XP)

**Rank 20** (Elite heists):
- 🆕 **VOORSTEL**: "Diamant Transport Overval" (€22000-55000, 750 XP) - **FEDERAL**

---

### 🔴 EXPERT TIER (Rank 21+) - Maffia Boss
**Doel**: Ultieme heists die legendarisch zijn

**Rank 21** (NEW):
- 🆕 **VOORSTEL**: "Federale Evidence Room Overval" (€20000-50000, 800 XP) - **FEDERAL**

**Rank 22** (Major bank operations):
- ✅ Bankoverval (€25000-70000, 900 XP) - **FEDERAL**

**Rank 23** (NEW):
- 🆕 **VOORSTEL**: "Museum Heist" (€28000-75000, 950 XP)

**Rank 24** (NEW):
- 🆕 **VOORSTEL**: "Rival Boss Assassination" (€30000-80000, 1000 XP) - **FEDERAL**

**Rank 25** (Ultimate heist):
- ✅ Casino overval (€30000-80000, 1000 XP) - **FEDERAL**

**Rank 26+** (Toekomstige uitbreiding):
- 🆕 "FBI Server Hack" (rank 26)
- 🆕 "Presidential Convoy Heist" (rank 28)
- 🆕 "Fort Knox Overval" (rank 30)

---

## 🔄 Voorgestelde Aanpassingen

### Priority 1: Rank wijzigingen (Bestaande crimes verplaatsen)

```json
{
  "assassination": {
    "current_minLevel": 20,
    "proposed_minLevel": 19,
    "reason": "Huurmoord is minder complex dan bankoverval, hoort bij rank 19"
  }
}
```

### Priority 2: Nieuwe crimes toevoegen (Gaten opvullen)

**Rank 19**: Getuige Elimineren
```json
{
  "id": "eliminate_witness",
  "name": "Getuige Elimineren",
  "description": "Elimineer een getuige voor een proces",
  "minLevel": 19,
  "baseSuccessChance": 0.21,
  "minReward": 15000,
  "maxReward": 35000,
  "xpReward": 600,
  "jailTime": 220,
  "requiredVehicle": true,
  "breakdownChance": 0.44,
  "isFederal": true,
  "requiredWeapon": true,
  "suitableWeaponTypes": ["rifle", "sniper"],
  "minDamage": 75
}
```

**Rank 20**: Diamant Transport Overval
```json
{
  "id": "diamond_heist",
  "name": "Diamant Transport Overval",
  "description": "Kaap een transport met onbewerkte diamanten",
  "minLevel": 20,
  "baseSuccessChance": 0.19,
  "minReward": 22000,
  "maxReward": 55000,
  "xpReward": 750,
  "jailTime": 250,
  "requiredVehicle": true,
  "breakdownChance": 0.46,
  "isFederal": true,
  "requiredWeapon": true,
  "suitableWeaponTypes": ["rifle", "smg"],
  "minDamage": 68,
  "vehicleRequirements": {
    "minSpeed": 75,
    "minArmor": 50,
    "preferredTypes": ["speed", "armored"]
  }
}
```

**Rank 21**: Federale Evidence Room Overval
```json
{
  "id": "evidence_room_heist",
  "name": "Evidence Room Overval",
  "description": "Steel bewijs uit federale opslagfaciliteit",
  "minLevel": 21,
  "baseSuccessChance": 0.17,
  "minReward": 20000,
  "maxReward": 50000,
  "xpReward": 800,
  "jailTime": 260,
  "requiredVehicle": true,
  "breakdownChance": 0.47,
  "isFederal": true,
  "requiredWeapon": true,
  "suitableWeaponTypes": ["rifle", "smg"],
  "minDamage": 70
}
```

**Rank 23**: Museum Heist
```json
{
  "id": "museum_heist",
  "name": "Museum Overval",
  "description": "Steel waardevolle artefacten uit museum",
  "minLevel": 23,
  "baseSuccessChance": 0.16,
  "minReward": 28000,
  "maxReward": 75000,
  "xpReward": 950,
  "jailTime": 290,
  "requiredVehicle": true,
  "breakdownChance": 0.49,
  "requiredWeapon": true,
  "suitableWeaponTypes": ["rifle", "smg"],
  "minDamage": 72
}
```

**Rank 24**: Rival Boss Assassination
```json
{
  "id": "boss_assassination",
  "name": "Rivaliserende Boss Vermoorden",
  "description": "Elimineer de leider van een rivaliserende organisatie",
  "minLevel": 24,
  "baseSuccessChance": 0.15,
  "minReward": 30000,
  "maxReward": 80000,
  "xpReward": 1000,
  "jailTime": 295,
  "requiredVehicle": true,
  "breakdownChance": 0.5,
  "isFederal": true,
  "requiredWeapon": true,
  "suitableWeaponTypes": ["rifle", "sniper"],
  "minDamage": 85
}
```

---

## 📊 Balans Principes

### Reward Formule (Baseline):
```
Rank 1-5:   €100-500   per crime (learning phase)
Rank 6-10:  €1000-8000  per crime (professional)
Rank 11-15: €5000-20000 per crime (expert)
Rank 16-20: €15000-50000 per crime (elite)
Rank 21+:   €25000-80000 per crime (legendary)
```

### XP Formule:
```
XP = (minLevel × 10) + (difficulty_bonus)

difficulty_bonus:
- No vehicle/weapon: +0
- Vehicle required: +20
- Weapon required: +15
- Federal crime: +50
- Vehicle + Weapon + Federal: +100
```

### Success Rate Formule:
```
baseSuccessChance = 1.0 - (minLevel × 0.03)

Rank 1:  70-80% success
Rank 10: 35-45% success
Rank 25: 15-20% success
```

### Jail Time Formule:
```
jailTime (minutes) = minLevel × 12

Rank 1:  ~5-10 min
Rank 10: ~90-110 min
Rank 25: ~300 min (5 uur)
```

---

## ✅ Implementatie Checklist

- [ ] Review huidige crime balans
- [ ] Verplaats "Huurmoord" van rank 20 → rank 19
- [ ] Voeg 5 nieuwe crimes toe (ranks 19, 20, 21, 23, 24)
- [ ] Test balans in development
- [ ] Update NPC crime selection logic
- [ ] Test NPC progressie met nieuwe ranks
- [ ] Deploy naar productie

---

## 🎮 Impact op Gameplay

**Voor Spelers:**
- Elke rank unlock voelt meaningful (nieuwe crimes beschikbaar)
- Duidelijke progressie: rank up = meer power
- Federal crimes (rank 13+) zijn high risk/high reward

**Voor NPCs:**
- Logische ontwikkeling van kleine crimineel → maffia boss
- AI kan groeien van rank 1 crimes naar elite heists
- Realistische NPC economie

**Voor Balans:**
- Nieuwe spelers: veilige starter crimes (rank 1-5)
- Mid-game: diverse opties (rank 6-15)
- End-game: extreme challenges (rank 20+)
