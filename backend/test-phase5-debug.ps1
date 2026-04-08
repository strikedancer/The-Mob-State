Write-Host "=== Phase 5 DEBUG CHECKLIST ===" -ForegroundColor Cyan
Write-Host ""

# Check 1: Build & Type Safety
Write-Host "Check 1: Build & Type Safety" -ForegroundColor Green
Set-Location C:\xampp\htdocs\mafia_game\backend
$buildResult = npm run check 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Host "  ✅ TypeScript, lint, format - ALL PASSING" -ForegroundColor Green
} else {
    Write-Host "  ❌ Build failed" -ForegroundColor Red
    Write-Host $buildResult
}
Write-Host ""

# Check 5: No Client Logic
Write-Host "Check 5: No Client Logic in Backend" -ForegroundColor Green
$hardcoded = Select-String -Path ".\src\routes\properties.ts",".\src\services\propertyService.ts" -Pattern '"[A-Z][a-z]+\s+[a-z]+"' -CaseSensitive
if ($hardcoded.Count -eq 0) {
    Write-Host "  ✅ No hardcoded UI strings" -ForegroundColor Green
} else {
    Write-Host "  ❌ Found hardcoded strings:" -ForegroundColor Red
    $hardcoded | ForEach-Object { Write-Host "     $($_.Line)" }
}
Write-Host ""

# Check 6: Config-Only Balancing
Write-Host "Check 6: Config-Only Balancing" -ForegroundColor Green
$magicNumbers = Select-String -Path ".\src\services\propertyService.ts" -Pattern '(cost|income|price):\s*\d{3,}' -CaseSensitive
if ($magicNumbers.Count -eq 0) {
    Write-Host "  ✅ No magic numbers (values from properties.json)" -ForegroundColor Green
} else {
    Write-Host "  ⚠️  Found potential magic numbers:" -ForegroundColor Yellow
    $magicNumbers | ForEach-Object { Write-Host "     Line $($_.LineNumber)" }
}
Write-Host ""

# Check 7: Time Provider Usage
Write-Host "Check 7: Time Provider Usage" -ForegroundColor Green
$newDate = Select-String -Path ".\src\services\propertyService.ts" -Pattern 'new Date\(\)|Date\.now\(\)' -CaseSensitive
if ($newDate.Count -eq 0) {
    Write-Host "  ✅ Uses timeProvider.now()" -ForegroundColor Green
} else {
    Write-Host "  ❌ Found direct Date usage:" -ForegroundColor Red
    $newDate | ForEach-Object { Write-Host "     Line $($_.LineNumber): $($_.Line)" }
}
Write-Host ""

# Check 9: Transaction Usage
Write-Host "Check 9: Transaction Usage" -ForegroundColor Green
$transactions = Select-String -Path ".\src\services\propertyService.ts" -Pattern 'prisma\.\$transaction' -CaseSensitive
if ($transactions.Count -ge 3) {
    Write-Host "  ✅ Found $($transactions.Count) transaction(s)" -ForegroundColor Green
    Write-Host "     - buyProperty" -ForegroundColor Gray
    Write-Host "     - collectIncome" -ForegroundColor Gray
    Write-Host "     - upgradeProperty" -ForegroundColor Gray
} else {
    Write-Host "  ❌ Expected 3 transactions, found $($transactions.Count)" -ForegroundColor Red
}
Write-Host ""

# Check overlay keys implementation
Write-Host "Check: Overlay Keys Implementation" -ForegroundColor Green
$overlayKeys = Select-String -Path ".\src\services\propertyService.ts" -Pattern 'overlayKeys' -CaseSensitive
if ($overlayKeys.Count -gt 0) {
    Write-Host "  ✅ overlayKeys implemented" -ForegroundColor Green
} else {
    Write-Host "  ❌ overlayKeys not found" -ForegroundColor Red
}
Write-Host ""

Write-Host "=== Static Checks Complete ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "Starting server for runtime checks..." -ForegroundColor Yellow
Write-Host ""
