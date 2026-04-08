# VIP Management Helper

# Grant VIP (7 days default)
param(
    [Parameter(Mandatory=$true, Position=0)]
    [string]$Username,
    
    [Parameter(Mandatory=$false, Position=1)]
    [string]$Action = "7"
)

$ErrorActionPreference = "Stop"

Write-Host "🎭 VIP Management Script" -ForegroundColor Cyan
Write-Host ""

if ($Action -eq "revoke") {
    Write-Host "Revoking VIP from $Username..." -ForegroundColor Yellow
} else {
    $days = [int]$Action
    Write-Host "Granting VIP to $Username for $days days..." -ForegroundColor Green
}

# Run inside Docker container
docker compose exec -T backend npx ts-node grant-vip.ts $Username $Action

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "✅ Operation completed successfully!" -ForegroundColor Green
} else {
    Write-Host ""
    Write-Host "❌ Operation failed!" -ForegroundColor Red
}
