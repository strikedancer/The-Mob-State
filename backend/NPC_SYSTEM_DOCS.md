# NPC Systeem Documentatie

## Overzicht

Het NPC (Non-Player Character) systeem simuleert AI-gestuurde spelers die automatisch crimes en jobs uitvoeren. NPCs hebben verschillende activiteitsniveaus en bouwen statistieken op die kunnen worden geanalyseerd.

## NPC Types

### 1. MATIG (Matige Speler)
**Beschrijving:** Een speler die af en toe online komt, weinig actief

**Kenmerken:**
- **Crimes per uur:** 1-2
- **Jobs per uur:** 0.5-1
- **Level up speed:** Langzaam
- **Crew participatie:** 10%
- **Heist participatie:** 5%

**Activiteitenpatroon:**
- Ochtend (06:00-12:00): 20% actief
- Middag (12:00-18:00): 30% actief
- Avond (18:00-00:00): 50% actief
- Nacht (00:00-06:00): 10% actief

**Crime voorkeuren:**
- Pickpocket: 40%
- Shoplifting: 30%
- Bike theft: 20%
- Vandalism: 10%

**Job voorkeuren:**
- Cleaner: 50%
- Delivery driver: 30%
- Warehouse worker: 20%

**Starting stats:**
- Money: €5,000
- Rank: 1
- XP: 0

---

### 2. GEMIDDELD (Gemiddelde Speler)
**Beschrijving:** Een speler die regelmatig online is, normaal actief

**Kenmerken:**
- **Crimes per uur:** 3-5
- **Jobs per uur:** 1-2
- **Level up speed:** Normaal
- **Crew participatie:** 40%
- **Heist participatie:** 20%

**Activiteitenpatroon:**
- Ochtend (06:00-12:00): 30% actief
- Middag (12:00-18:00): 40% actief
- Avond (18:00-00:00): 70% actief
- Nacht (00:00-06:00): 20% actief

**Crime voorkeuren:**
- Pickpocket: 20%
- Shoplifting: 15%
- Bike theft: 15%
- Burglary: 15%
- Auto theft: 15%
- Small drug deal: 10%
- Vandalism: 10%

**Job voorkeuren:**
- Delivery driver: 30%
- Warehouse worker: 20%
- Construction worker: 20%
- Office clerk: 15%
- Salesperson: 15%

**Starting stats:**
- Money: €10,000
- Rank: 3
- XP: 500

---

### 3. CONTINU (Continue Speler)
**Beschrijving:** Een zeer actieve speler die bijna altijd online is

**Kenmerken:**
- **Crimes per uur:** 10-20
- **Jobs per uur:** 3-5
- **Level up speed:** Snel
- **Crew participatie:** 80%
- **Heist participatie:** 60%

**Activiteitenpatroon:**
- Ochtend (06:00-12:00): 70% actief
- Middag (12:00-18:00): 80% actief
- Avond (18:00-00:00): 90% actief
- Nacht (00:00-06:00): 60% actief

**Crime voorkeuren:**
- Pickpocket: 5%
- Shoplifting: 5%
- Bike theft: 5%
- Burglary: 15%
- Auto theft: 20%
- Store heist: 15%
- Small drug deal: 10%
- Large drug deal: 10%
- Mugging: 10%
- Bank robbery: 5%

**Job voorkeuren:**
- Office clerk: 15%
- Salesperson: 15%
- Programmer: 20%
- Accountant: 15%
- Manager: 15%
- Engineer: 10%
- Lawyer: 5%
- Doctor: 5%

**Starting stats:**
- Money: €25,000
- Rank: 5
- XP: 2,000

---

## Database Schema

### NPCPlayer
```prisma
model NPCPlayer {
  id              Int      @id @default(autoincrement())
  playerId        Int      @unique
  npcType         NPCType
  isActive        Boolean  @default(true)
  lastActivityAt  DateTime @default(now())
  createdAt       DateTime @default(now())
  
  // Statistics
  totalCrimes     Int      @default(0)
  totalJobs       Int      @default(0)
  totalMoneyEarned BigInt  @default(0)
  totalXpEarned   Int      @default(0)
  totalArrests    Int      @default(0)
  totalJailTime   Int      @default(0)
  crimesPerHour   Float    @default(0)
  jobsPerHour     Float    @default(0)
  simulatedOnlineHours Float @default(0)
  
  activityLogs    NPCActivityLog[]
}
```

### NPCActivityLog
```prisma
model NPCActivityLog {
  id          Int      @id @default(autoincrement())
  npcId       Int
  activityType String
  details     Json
  success     Boolean
  moneyEarned Int      @default(0)
  xpEarned    Int      @default(0)
  timestamp   DateTime @default(now())
  
  npc         NPCPlayer @relation(...)
}
```

---

## API Endpoints

### Create NPC
```
POST /admin/npcs
Authorization: Bearer <admin_token>

Body:
{
  "username": "NPC_TestUser",
  "npcType": "GEMIDDELD"
}

Response:
{
  "success": true,
  "npc": { ... },
  "player": { ... }
}
```

### Get All NPCs
```
GET /admin/npcs
Authorization: Bearer <admin_token>

Response:
{
  "success": true,
  "npcs": [...],
  "count": 3
}
```

### Get NPC Statistics
```
GET /admin/npcs/:npcId/stats
Authorization: Bearer <admin_token>

Response:
{
  "success": true,
  "npc": { ... },
  "player": { ... },
  "stats": {
    "totalCrimes": 150,
    "totalJobs": 50,
    "totalMoneyEarned": 50000,
    "totalXpEarned": 2500,
    "totalArrests": 10,
    "crimesPerHour": 3.5,
    "jobsPerHour": 1.2,
    "successRate": 93.3
  },
  "activityBreakdown": {
    "CRIME": 150,
    "JOB": 50
  },
  "recentActivities": [...]
}
```

### Simulate NPC Activity
```
POST /admin/npcs/:npcId/simulate
Authorization: Bearer <admin_token>

Body:
{
  "hours": 2
}

Response:
{
  "success": true,
  "result": {
    "npcId": 1,
    "activitiesPerformed": 12,
    "moneyEarned": 8500,
    "xpEarned": 450,
    "arrests": 0
  }
}
```

### Simulate All NPCs
```
POST /admin/npcs/simulate-all/run
Authorization: Bearer <admin_token>

Body:
{
  "hours": 1
}

Response:
{
  "success": true,
  "totalNPCs": 3,
  "results": [...],
  "totalActivities": 25,
  "totalMoneyEarned": 15000,
  "totalXpEarned": 800,
  "totalArrests": 2
}
```

### Activate/Deactivate NPC
```
POST /admin/npcs/:npcId/activate
POST /admin/npcs/:npcId/deactivate
Authorization: Bearer <admin_token>

Response:
{
  "success": true,
  "message": "NPC activated"
}
```

### Delete NPC
```
DELETE /admin/npcs/:npcId
Authorization: Bearer <admin_token>

Response:
{
  "success": true,
  "message": "NPC deleted"
}
```

---

## Automatische Simulatie

Het NPC systeem heeft een **automatische scheduler** die elke 5 minuten draait:

1. **NPCScheduler** start automatisch bij server startup
2. Simuleert activiteit voor alle actieve NPCs
3. Activiteit is gebaseerd op tijd van de dag en NPC type
4. Logs alle activiteiten in `NPCActivityLog`

### Configuratie

Configuratie in `content/npcBehaviors.json`:

```json
{
  "simulationSettings": {
    "tickIntervalMinutes": 5,
    "maxActivitiesPerTick": 3,
    "arrestChanceMultiplier": 0.8,
    "successChanceMultiplier": 1.0
  }
}
```

---

## Statistieken

NPCs bouwen automatisch de volgende statistieken op:

### Basis Statistieken
- **Total Crimes:** Totaal aantal gepleegde crimes
- **Total Jobs:** Totaal aantal uitgevoerde jobs
- **Total Money Earned:** Totaal verdiend geld
- **Total XP Earned:** Totaal verdiende XP
- **Total Arrests:** Aantal keer gearresteerd
- **Total Jail Time:** Totale tijd in jail (minuten)

### Berekende Statistieken
- **Crimes per Hour:** Gemiddeld aantal crimes per uur
- **Jobs per Hour:** Gemiddeld aantal jobs per uur
- **Money per Hour:** Gemiddeld verdiensten per uur
- **XP per Hour:** Gemiddelde XP per uur
- **Success Rate:** Percentage succesvolle activiteiten

### Activity Breakdown
Verdeling van activiteiten per type (CRIME, JOB, etc.)

---

## Setup & Testing

### 1. Database Migratie
```powershell
cd backend
npx prisma migrate dev --name add_npc_system
npx prisma generate
```

### 2. NPCs Creëren (Automated)
```powershell
.\setup-npcs.ps1
```

Dit script:
- Draait de database migratie
- Genereert Prisma client
- Creëert 3 test NPCs (één van elk type)
- Simuleert 1 uur activiteit
- Toont statistieken

### 3. Manual Testing
```powershell
npx ts-node test-npcs.ts
```

### 4. Server Restart
```powershell
# Restart backend om NPCScheduler te activeren
docker-compose restart backend
```

---

## Use Cases

### 1. Test Environment Population
Gebruik NPCs om een test omgeving te vullen met actieve spelers:
- Leaderboards testen
- Crew interacties testen
- Economy balancing
- Crime success rates valideren

### 2. Game Balance Analysis
Analyse van NPC statistieken geeft inzicht in:
- Gemiddelde verdiensten per uur
- Crime success rates
- Arrestatie percentages
- Rank progressie snelheid

### 3. World Event Generation
NPCs zorgen voor constante activiteit in de game world:
- World events worden gegenereerd
- Leaderboards blijven actief
- Crews blijven actief

### 4. Player Interaction
NPCs kunnen dienen als:
- Targets voor hits (kill list)
- Concurrent op leaderboards
- Crew members
- Trade partners

---

## Best Practices

### 1. NPC Management
- **Matige NPCs:** Gebruik voor basis populatie (5-10 per 100 real players)
- **Gemiddelde NPCs:** Gebruik voor normale populatie (3-5 per 100 real players)
- **Continue NPCs:** Gebruik spaarzaam (1-2 per 100 real players)

### 2. Resource Monitoring
- Monitor database grootte (NPCActivityLog kan groot worden)
- Overweeg oude activity logs te archiveren/verwijderen
- Monitor CPU gebruik tijdens simulaties

### 3. Balance
- Pas `arrestChanceMultiplier` aan om NPC arrests te controleren
- Pas `successChanceMultiplier` aan voor crime success rates
- Test impact op game economy

### 4. Deactivation
- Deactiveer NPCs tijdens grote events
- Deactiveer bij server performance problemen
- Deactiveer tijdens backend maintenance

---

## Configuratie Aanpassen

### Crime Voorkeuren Wijzigen
Edit `content/npcBehaviors.json`:

```json
{
  "behaviors": {
    "GEMIDDELD": {
      "crimePreferences": {
        "pickpocket": 0.3,
        "auto_theft": 0.4,
        "burglary": 0.3
      }
    }
  }
}
```

### Activiteit Snelheid Wijzigen
```json
{
  "behaviors": {
    "CONTINU": {
      "crimesPerHour": {
        "min": 15,
        "max": 30
      }
    }
  }
}
```

### Scheduler Interval Wijzigen
```json
{
  "simulationSettings": {
    "tickIntervalMinutes": 10
  }
}
```

---

## Troubleshooting

### NPCs doen geen activiteiten
1. Check of NPCs actief zijn: `GET /admin/npcs`
2. Check of scheduler draait (zie console logs)
3. Verificeer `isActive` status in database

### Te veel arrests
Verlaag `arrestChanceMultiplier` in config:
```json
{
  "simulationSettings": {
    "arrestChanceMultiplier": 0.5
  }
}
```

### NPCs level niet op
- Check XP earnings in statistics
- Verhoog `crimesPerHour` voor snellere progressie
- Check of crimes succesvol zijn

### Activity logs te groot
Implementeer cleanup job:
```sql
DELETE FROM npc_activity_logs 
WHERE timestamp < NOW() - INTERVAL 30 DAY;
```

---

## Future Enhancements

### Mogelijke Uitbreidingen:
1. **NPC Crews:** NPCs die crews vormen
2. **NPC Heists:** NPCs die heists doen
3. **NPC Trading:** NPCs die handelen op markets
4. **NPC Properties:** NPCs die properties kopen
5. **NPC Rivalries:** NPCs die elkaar aanvallen
6. **Smart NPCs:** Machine learning voor realistischer gedrag
7. **NPC Events:** Speciale events waar NPCs aan meedoen
8. **NPC Dialogue:** NPCs die berichten sturen in chat

---

## Conclusie

Het NPC systeem biedt een complete oplossing voor het simuleren van AI-spelers met verschillende activiteitsniveaus. Door gebruik te maken van configureerbare behavior patterns, automatische simulatie en uitgebreide statistieken tracking, kunnen NPCs realistisch spelergedrag nabootsen en de game world levend houden.
