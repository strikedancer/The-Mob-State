# 🎲 Trade Risk Mechanics - Feature Documentation

## Overzicht
De zwarte markt heeft nu realistische risico's en prijsfluctuaties toegevoegd die handel strategischer maken.

## 🌷 Bloemen - Bederf Mechanisme
- **Spoilage Time**: 48 uur vanaf aankoop
- **Waarschuwing**: Oranje waarschuwing verschijnt 12 uur voor bederf
- **Effect**: Bedorven bloemen zijn waardeloos en kunnen niet verkocht worden
- **Strategie**: Koop bloemen alleen als je snel kunt reizen naar een land met hoge multiplier

### Implementatie Details
- `purchasedAt` timestamp opgeslagen bij aankoop
- Backend checkt bij verkoop en inventory display
- Frontend toont countdown en "BEDORVEN" status
- Bedorven items verschijnen doorgestreept met grijze achtergrond

## 💎 Diamanten - Prijs Volatiliteit
- **Volatility**: ±25% random prijs fluctuatie
- **Effect**: Prijs kan €1500-€2500 zijn (base €2000)
- **Strategie**: Hoge risico, hoge beloning - kan grote winsten of verliezen opleveren

### Andere Volatiliteiten
- **Elektronics**: ±10%
- **Farmaceutica**: ±12%
- **Wapens**: ±8%
- **Bloemen**: ±5%

## 💊 Farmaceutica & 🔫 Wapens - Confiscatie
- **Farmaceutica Confiscation**: 15% kans per reis
- **Wapens Confiscation**: 20% kans per reis
- **Effect**: 30-70% van de goederen wordt in beslag genomen
- **Notification**: Rode melding bij reizen: "🚨 X items in beslag genomen!"
- **Strategie**: Gevaarlijk maar winstgevend - hogere risico's vergen betere planning

## 📱 Elektronica - Schade Mechanisme
- **Damage Chance**: 15% per reis
- **Damage Range**: 20-40% conditieverlies
- **Effect**: Verkoopprijs vermindert met condition percentage
  - 100% conditie = 100% prijs
  - 60% conditie = 60% van verkoopprijs
  - 20% conditie = 20% van verkoopprijs
- **Display**: Oranje/rode conditie indicator bij items
- **Notification**: "⚠️ elektronica beschadigd (X% waardeverlies)!"
- **Strategie**: Minimaliseer aantal reizen, verkoop voordat conditie te laag wordt

## 🎯 Strategische Impact

### Risk/Reward Matrix
1. **Laag Risico**: Bloemen (alleen tijdsdruk)
2. **Medium Risico**: Diamanten (prijs volatiliteit), Elektronica (schade)
3. **Hoog Risico**: Wapens, Farmaceutica (confiscatie + volatiliteit)

### Optimale Trade Routes
**Bloemen Express Route** (Laag risico, snelle omzet):
- Koop in Duitsland (€90, 0.9x)
- Reis naar Italië (€130, 1.3x) binnen 48u
- Verkoop met spread: €117 (€27 winst per unit)

**Diamanten Gamble** (Hoog risico, hoge beloning):
- Koop in België bij lage volatility (€1950)
- Wacht op hoge volatility in Zwitserland (€3750)
- Verkoop met spread: €3375 (€1425 winst per unit)
- Risico: Kan ook €750 verlies zijn bij slechte volatility

**Wapens Smuggling** (Zeer hoog risico):
- Koop €1500 in Nederland
- 20% kans om 30-70% te verliezen bij reizen
- Als je aankomt in Zwitserland (1.5x): €2025 verkoop per unit
- Winst: €525 per unit... als je niet gepakt wordt

## 📊 Database Schema
```sql
ALTER TABLE inventory 
ADD COLUMN purchasedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN `condition` INT DEFAULT 100;
```

## 🔧 API Changes
### GET /trade/inventory
Response nu inclusief:
```json
{
  "goodType": "contraband_electronics",
  "quantity": 10,
  "purchasePrice": 500,
  "condition": 75,
  "spoiled": false,
  "purchasedAt": "2026-01-29T12:00:00Z"
}
```

### POST /travel/:countryId
Response nu inclusief:
```json
{
  "success": true,
  "confiscatedGoods": [
    { "goodType": "contraband_weapons", "quantity": 15 }
  ],
  "damagedGoods": [
    { "goodType": "contraband_electronics", "damagePercent": 25 }
  ]
}
```

### POST /trade/sell
Nieuwe error: `GOODS_SPOILED` als bloemen bedorven zijn

## 🎨 UI Features
- ⏰ Countdown timer voor bloemen (12u waarschuwing)
- ⚙️ Conditie percentage indicator (oranje < 80%, rood < 50%)
- 💀 BEDORVEN status voor spoiled items
- 🚨 Confiscatie notificaties bij reizen
- ⚠️ Schade notificaties bij reizen
- Color-coded risk indicators

## 🧪 Testing Tips
```bash
# Test bloem bederf (set timestamp 49 uur terug)
UPDATE inventory SET purchasedAt = DATE_SUB(NOW(), INTERVAL 49 HOUR) WHERE goodType = 'contraband_flowers';

# Test elektronica schade
UPDATE inventory SET `condition` = 45 WHERE goodType = 'contraband_electronics';

# Test confiscatie probability
# Reis meerdere keren met wapens/farmaceutica
```

## 🚀 Game Balance
Deze mechanics maken handel dynamischer:
- **Tijdsdruk**: Bloemen forceren snelle beslissingen
- **Prijs Gambling**: Diamanten add element of chance
- **Reisplanning**: Confiscatie/schade discouragen te veel reizen
- **Strategic Depth**: Spelers moeten risico vs reward afwegen

**Balancing Notes**:
- 10% sell spread voorkomt free storage
- Volatility verhoogt excitement zonder gameplay te breken
- Confiscatie/schade rates hoog genoeg om meaningful te zijn, maar niet frustrerend
- Bloemen spoilage geeft casual players nog 2 dagen tijd
