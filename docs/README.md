# 📚 Documentatie - Mafia Game

Centrale documentatie-hub met protocollen, spelregels en operationele procedures. 

**Beginnen met:** Lees eerst dit bestand, dan kies je pad hieronder.

---

## 🎯 Naar Wat Zoek je?

### 👨‍💻 Ik wil Features Bouwen / Wijzigingen Doen
→ **Start met [module-protocols/PROTOCOL_MASTER.md](module-protocols/PROTOCOL_MASTER.md)**
- Dit is de enige bijlage die je nodig hebt
- PROTOCOL_MASTER.md vertelt je welke andere files te lezen
- Zorgt ervoor je niks breekt

### 🎮 Ik wil Game-Regels Begrijpen
→ **[game-systems/](game-systems/README.md)**
- Mechanica & economy details
- Progression systemen
- Nightclub, trading, properties

### 🚀 Ik Wil Deployeren / Releasen
→ **[operations/](operations/README.md)**
- Deployment procedures
- Release checklists
- Firebase setup

### 📖 Ik Wil een Specifieke Module Snappen
→ **[module-protocols/README.md](module-protocols/README.md)**
- Alle module-protocols (games, systems, etc)
- Data contracts & API details
- QA requirements per module

---

## 📁 Folder Structuur

```
docs/
├── README.md (JIJ BENT HIER)
│
├── module-protocols/
│   ├── PROTOCOL_MASTER.md ⭐ (ENIGE ATTACHMENT NODIG!)
│   ├── README.md (Index van alle 40+ modules)
│   ├── PROTOCOL_TEMPLATE.md (Template voor nieuwe modules)
│   │
│   └── [40+ module files]
│       ├── nightclub.md
│       ├── drugs.md
│       ├── properties.md
│       ├── prostitution.md
│       ├── crew.md
│       ├── crimes.md
│       ├── trade.md
│       └── [... meer ...]
│
├── game-systems/
│   ├── README.md (Overzicht van game mechanics)
│   │
│   ├── GAMEPLAY.md (Centrale spel-regels) ⭐ START HIER
│   ├── NIGHTCLUB_SYSTEM.md
│   ├── VIP_MANAGEMENT.md
│   ├── VIP_LEVELS_SYSTEM.md
│   ├── HQ_PROGRESSION_GUIDE.md
│   └── TRADE_RISK_MECHANICS.md
│
└── operations/
    ├── README.md (Release & deployment procedures)
    │
    ├── DEPLOY.md (Production deployment)
    ├── RELEASE_CHECKLIST.md (Pre-release QA)
    └── FIREBASE_SETUP.md (Configuration)
```

---

## 🔄 Workflow voor Verschillende Rollen

### Developer (Nieuwe Feature)
1. Open [module-protocols/PROTOCOL_MASTER.md](module-protocols/PROTOCOL_MASTER.md)
2. Lees "Standaard Workflow" sectie
3. PROTOCOL_MASTER.md vertelt je rest

### Game Designer (System Balance)
1. Start met [game-systems/GAMEPLAY.md](game-systems/GAMEPLAY.md)
2. Navigeer naar relevante game-system file
3. Check module-protocols voor implementation details

### DevOps / Release Manager
1. Open [operations/RELEASE_CHECKLIST.md](operations/RELEASE_CHECKLIST.md)
2. Volg alle items
3. Use [operations/DEPLOY.md](operations/DEPLOY.md) voor deployment

### QA / Tester
1. Lees relevante [module-protocols/](module-protocols/README.md)
2. Volg "Minimale QA Checklist" in PROTOCOL_MASTER.md
3. Check i18n + responsiveness

---

## ⭐ Most Important Files

```
⭐ PROTOCOL_MASTER.md
  - Dit is alles wat je moet attachen
  - Vertelt je welke protocol/game-system files te lezen
  - Cross-module dependencies checklist

⭐ game-systems/GAMEPLAY.md  
  - Game rules & economy
  - Welke systems hangen samen
  - Lees dit voor context

⭐ operations/RELEASE_CHECKLIST.md
  - Voordat je gaat releasen
  - Minimale QA checklist
  - Cross-module validation
```

---

## 📋 Snelle Links

| Wat | Waar |
|---|---|
| Nieuwe feature bouwen | [PROTOCOL_MASTER.md](module-protocols/PROTOCOL_MASTER.md) |
| Game regels lezen | [game-systems/GAMEPLAY.md](game-systems/GAMEPLAY.md) |
| Module protocols | [module-protocols/README.md](module-protocols/README.md) |
| Deployeren | [operations/DEPLOY.md](operations/DEPLOY.md) |
| Pre-release checks | [operations/RELEASE_CHECKLIST.md](operations/RELEASE_CHECKLIST.md) |
| Nightclub systeem | [game-systems/NIGHTCLUB_SYSTEM.md](game-systems/NIGHTCLUB_SYSTEM.md) |
| Hitlist & moordslooptochten | [game-systems/HITLIST_SYSTEM.md](game-systems/HITLIST_SYSTEM.md) |
| Properties & HQ | [game-systems/HQ_PROGRESSION_GUIDE.md](game-systems/HQ_PROGRESSION_GUIDE.md) |
| Trading & risk | [game-systems/TRADE_RISK_MECHANICS.md](game-systems/TRADE_RISK_MECHANICS.md) |

---

## 🚀 Eerste Stappen

**Nieuw in het project?**
1. Lees [game-systems/GAMEPLAY.md](game-systems/GAMEPLAY.md) (30 minuten)
2. Lees [module-protocols/PROTOCOL_MASTER.md](module-protocols/PROTOCOL_MASTER.md) (10 minuten)
3. Kies je module → lees bijbehorende [module-protocols/](module-protocols/) file

**Wil je iets wijzigen?**
1. Voeg ENKEL toe: [module-protocols/PROTOCOL_MASTER.md](module-protocols/PROTOCOL_MASTER.md)
2. Volg "Standaard Workflow" in PROTOCOL_MASTER
3. PROTOCOL_MASTER vertelt je rest

---

## ❓ FAQs

**Q: Welk bestand moet ik als attachment bijvoegen?**
A: **Altijd** [PROTOCOL_MASTER.md](module-protocols/PROTOCOL_MASTER.md). Niets anders.

**Q: Ik snap module X niet. Waar start ik?**
A: [game-systems/GAMEPLAY.md](game-systems/GAMEPLAY.md) → relevante game-system → relevant module-protocol

**Q: Ik wil twee modules wijzigen. Wat nu?**
A: Open PROTOCOL_MASTER.md → beide module-protocols → use cross-module dependency map

**Q: Hoe release ik?**
A: [operations/RELEASE_CHECKLIST.md](operations/RELEASE_CHECKLIST.md) → [operations/DEPLOY.md](operations/DEPLOY.md)

---

## 📞 Support

- Fragen over workflow? → Lees PROTOCOL_MASTER.md
- Fragen over game design? → Lees GAMEPLAY.md
- Deployment vragen? → Lees operations/DEPLOY.md
- Specifieke module? → Lees module-protocols/README.md
