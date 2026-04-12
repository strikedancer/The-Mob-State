# Game Systems Documentation

Deze map bevat **centrale gamemechanica documentatie** - de spelregels en systeem-architectuur op hoog niveau.

Voor **specifieke implementatie-details**, zie the bijbehorende [module-protocols](../module-protocols/).

---

## 📘 Beschikbare Game Systems

### Core Gameplay
- [GAMEPLAY.md](GAMEPLAY.md) - Centrale spelregels, progression, verdiensmodellen
  - Lees dit eerst voordat je feature-werk doet!
  - Linkt naar alle module-protocols

### Economy & Trading
- [TRADE_RISK_MECHANICS.md](TRADE_RISK_MECHANICS.md) - Zwarte markt risico's, volatiliteit, spoilage
  - Module-protocols: [trade.md](../module-protocols/trade.md), [travel.md](../module-protocols/travel.md)
  
### Nightlife & Entertainment  
- [NIGHTCLUB_SYSTEM.md](NIGHTCLUB_SYSTEM.md) - Venue management, staff (hoeren/DJ/beveilging), drug inventory
  - Module-protocols: [nightclub.md](../module-protocols/nightclub.md), [prostitution.md](../module-protocols/prostitution.md), [drugs.md](../module-protocols/drugs.md)
  
- [VIP_MANAGEMENT.md](VIP_MANAGEMENT.md) - VIP staff recruitment & special features
  - Module-protocols: [prostitution.md](../module-protocols/prostitution.md)

### Progression & Properties
- [HQ_PROGRESSION_GUIDE.md](HQ_PROGRESSION_GUIDE.md) - Property ownership, crew HQ upgrades, space management
  - Module-protocols: [properties.md](../module-protocols/properties.md), [crew.md](../module-protocols/crew.md)

- [VIP_LEVELS_SYSTEM.md](VIP_LEVELS_SYSTEM.md) - VIP-exclusive building levels 10-14 + crew perks
  - Module-protocols: [crew.md](../module-protocols/crew.md), [properties.md](../module-protocols/properties.md)

### Combat & Hitlist
- [HITLIST_SYSTEM.md](HITLIST_SYSTEM.md) - Hitlist/bounties, murder mechanics, detective investigations
  - Module-protocols: [hitlist.md](../module-protocols/hitlist.md), [crimes.md](../module-protocols/crimes.md), [security.md](../module-protocols/security.md)

---

## 🔗 Workflow bij Wijzigingen

**Stap 1:** Start altijd met [PROTOCOL_MASTER.md](../module-protocols/PROTOCOL_MASTER.md)
```
Attachment: docs/module-protocols/PROTOCOL_MASTER.md
```

**Stap 2:** Bepaal welke module je aanraakt
- Nightclub wijzigen? → Lees NIGHTCLUB_SYSTEM.md
- Properties upgrade? → Lees HQ_PROGRESSION_GUIDE.md  
- Zwarte markt? → Lees TRADE_RISK_MECHANICS.md

**Stap 3:** Open bijbehorende module-protocol
- Via de links hierboven
- Of via [docs/module-protocols/README.md](../module-protocols/README.md)

**Stap 4:** Check cross-module dependencies
- PROTOCOL_MASTER.md toont welke andere modules raken dezelfde data

**Stap 5:** Implementeer + QA

---

## 📋 Game Systems → Module Protocols Matrix

| Game System | Primary Modules | Features |
|---|---|---|
| **GAMEPLAY.md** | Alle modules | Core rules |
| **NIGHTCLUB_SYSTEM.md** | nightclub, prostitution, drugs | Venue setup, staff, inventory, sales |
| **VIP_MANAGEMENT.md** | prostitution | VIP recruitment + salaries |
| **VIP_LEVELS_SYSTEM.md** | crew, properties | Exclusive building upgrades |
| **HQ_PROGRESSION_GUIDE.md** | properties, crew | Property ownership, HQ strategy |
| **TRADE_RISK_MECHANICS.md** | trade, travel | Volatility, spoilage, confiscation |

---

## ❗ Belangrijk!

- **Vóór je iets wijzigt:** lees relevante game-system UIT deze map
- **Implementatie details:** zie module-protocol in docs/module-protocols/
- **Cross-checks:** gebruik PROTOCOL_MASTER.md dependency map
- **QA:** voer minimale checklist uit (happy flow + 1 error path)

---

## 📚 Gerelateerde Documentatie

- [docs/module-protocols/PROTOCOL_MASTER.md](../module-protocols/PROTOCOL_MASTER.md) - **Attachmentpunt voor alle taken**
- [docs/module-protocols/README.md](../module-protocols/README.md) - All module protocol index
- [docs/operations/](../operations/) - Deployment & release procedures
- [GAMEPLAY.md](GAMEPLAY.md) - **Start hier voor nieuwe contributors**
