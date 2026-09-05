# VIP Management System

Handige tools om VIP status te beheren voor spelers.

## ðŸš€ Quick Start (PowerShell - Aanbevolen)

Vanaf de project root:

```powershell
# 7 dagen VIP (standaard)
.\grant-vip.ps1 testuser2

# 30 dagen VIP
.\grant-vip.ps1 testuser2 30

# VIP intrekken
.\grant-vip.ps1 testuser2 revoke
```

## ðŸ³ Via Docker (Direct)

```bash
# 7 dagen VIP
docker compose exec backend npx ts-node grant-vip.ts testuser2 7

# 30 dagen VIP
docker compose exec backend npx ts-node grant-vip.ts testuser2 30

# VIP intrekken
docker compose exec backend npx ts-node grant-vip.ts testuser2 revoke
```

## ðŸ”§ Via Database (Direct - als backend niet draait)

```bash
docker compose exec -T mysql mariadb -uroot mafia_game -e "UPDATE players SET isVip = 1, vipExpiresAt = DATE_ADD(NOW(), INTERVAL 7 DAY) WHERE username = 'testuser2';"
```

## Admin UI (spelerbeheer)

Op Admin → speler → Beheer: vink **VIP actief**, vul **VIP dagen** (1–365) en een beheerreden (min. 5 tekens). Enabling VIP vraagt daarna `CONFIRM`.

Alleen gewijzigde VIP-velden gaan mee; geld/rank/land worden niet opnieuw gepost. De server verlengt via `grantPlayerVipDays` (vanaf nu of huidige expiry) en telt `vipLifetimeDays`. Max 365 dagen per grant.

## Via API (Admin Endpoint)

### Grant VIP
```bash
POST /api/admin/players/vip/grant
Content-Type: application/json
Authorization: Bearer <admin-token>

{
  "username": "testuser2",
  "days": 7
}
```

### Revoke VIP
```bash
POST /api/admin/players/vip/revoke
Content-Type: application/json
Authorization: Bearer <admin-token>

{
  "username": "testuser2"
}
```

### List all VIP players
```bash
GET /api/admin/players/vip/list
Authorization: Bearer <admin-token>
```

## ðŸ’Ž VIP Benefits

- **40% kans** om VIP prostituees te recruiten (â‚¬60/h in plaats van â‚¬40/h)
- **50% bonus** op earnings van VIP prostituees (â‚¬90/h totaal)
- **Drugs Productie QoL**: VIP spelers krijgen een 1-klik bliksemknop op productiekaarten om ontbrekende materialen direct te kopen na kostenbevestiging.
- Exclusieve VIP features (toekomstig)

## ðŸ“Š VIP Status Checken

```sql
-- Check VIP status
SELECT username, isVip, vipExpiresAt 
FROM players 
WHERE isVip = 1 
ORDER BY vipExpiresAt;

-- Check voor specifieke speler
SELECT username, isVip, vipExpiresAt 
FROM players 
WHERE username = 'testuser2';
```

## ðŸ” Troubleshooting

### Script not found
Zorg dat je in de project root (`mafia_game/`) staat.

### Docker not running
Start eerst de containers:
```bash
docker compose up -d
```

### Permission denied (PowerShell)
```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
.\grant-vip.ps1 testuser2 7
```

## ðŸ“ Audit Logging

Alle VIP acties via de API worden automatisch gelogd in de `audit_logs` tabel met:
- Admin user die actie uitvoerde
- Tijdstip
- Target player
- Actie type (`GRANT_VIP` of `REVOKE_VIP`)
