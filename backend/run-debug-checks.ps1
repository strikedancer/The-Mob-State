Write-Host "=== DEBUG CHECKLIST - Checks 3-10 ===" -ForegroundColor Cyan
Write-Host ""

# Start server in background
Write-Host "Starting server..." -ForegroundColor Yellow
$job = Start-Job -ScriptBlock { 
    Set-Location C:\xampp\htdocs\mafia_game\backend
    npm run dev 
}
Start-Sleep -Seconds 6

# Check 3: Health endpoint
Write-Host "Check 3: Health Endpoint" -ForegroundColor Green
try {
    $response = Invoke-RestMethod -Uri "http://localhost:3000/health" -Method Get
    Write-Host "  ✅ Status: $($response.status)" -ForegroundColor Green
    Write-Host ""
} catch {
    Write-Host "  ❌ Failed: $_" -ForegroundColor Red
    Write-Host ""
}

# Check 5: No client logic (hardcoded messages)
Write-Host "Check 5: No Client Logic in Backend" -ForegroundColor Green
$hardcodedMessages = Select-String -Path ".\src\routes\properties.ts",".\src\services\propertyService.ts" -Pattern '"[A-Z][a-z]+\s+[a-z]+"' -CaseSensitive
if ($hardcodedMessages.Count -eq 0) {
    Write-Host "  ✅ No hardcoded UI strings found" -ForegroundColor Green
} else {
    Write-Host "  ❌ Found hardcoded strings:" -ForegroundColor Red
    $hardcodedMessages | ForEach-Object { Write-Host "     Line $($_.LineNumber): $($_.Line.Trim())" }
}
Write-Host ""

# Check 6: Config-only balancing (magic numbers)
Write-Host "Check 6: Config-Only Balancing" -ForegroundColor Green
$magicNumbers = Select-String -Path ".\src\services\propertyService.ts" -Pattern '(cost|income|price).*:\s*\d{3,}' -CaseSensitive
if ($magicNumbers.Count -eq 0) {
    Write-Host "  ✅ No magic numbers found in service (values from JSON)" -ForegroundColor Green
} else {
    Write-Host "  ⚠️  Found potential magic numbers:" -ForegroundColor Yellow
    $magicNumbers | ForEach-Object { Write-Host "     Line $($_.LineNumber): $($_.Line.Trim())" }
}
Write-Host ""

# Check 7: Time provider usage
Write-Host "Check 7: Time Provider Usage" -ForegroundColor Green
$newDate = Select-String -Path ".\src\services\propertyService.ts" -Pattern 'new Date\(\)|Date\.now\(\)' -CaseSensitive
if ($newDate.Count -eq 0) {
    Write-Host "  ✅ Uses timeProvider.now() instead of new Date()" -ForegroundColor Green
} else {
    Write-Host "  ❌ Found direct Date usage:" -ForegroundColor Red
    $newDate | ForEach-Object { Write-Host "     Line $($_.LineNumber): $($_.Line.Trim())" }
}
Write-Host ""

# Check 8: API Response Format
Write-Host "Check 8: API Response Format" -ForegroundColor Green
try {
    # Register test user
    $registerBody = @{
        username = "debugtest_$((Get-Random))"
        password = "test123"
    } | ConvertTo-Json
    
    $registerResponse = Invoke-RestMethod -Uri "http://localhost:3000/auth/register" -Method Post -Body $registerBody -ContentType "application/json"
    
    if ($registerResponse.event -and $registerResponse.params) {
        Write-Host "  ✅ Response format: {event, params, ...}" -ForegroundColor Green
        Write-Host "     Event: $($registerResponse.event)" -ForegroundColor Gray
    } else {
        Write-Host "  ❌ Invalid response format" -ForegroundColor Red
    }
} catch {
    Write-Host "  ⚠️  Could not test (user might exist): $($_.Exception.Message)" -ForegroundColor Yellow
}
Write-Host ""

# Check 9: Transaction usage
Write-Host "Check 9: Transaction Usage" -ForegroundColor Green
$transactions = Select-String -Path ".\src\services\propertyService.ts" -Pattern 'prisma\.\$transaction' -CaseSensitive
if ($transactions.Count -gt 0) {
    Write-Host "  ✅ Found $($transactions.Count) transaction(s) for atomic operations" -ForegroundColor Green
    $transactions | ForEach-Object { Write-Host "     Line $($_.LineNumber): $($_.Line.Trim())" -ForegroundColor Gray }
} else {
    Write-Host "  ❌ No transactions found (money operations should use transactions)" -ForegroundColor Red
}
Write-Host ""

# Check 10: Error handling
Write-Host "Check 10: Error Handling" -ForegroundColor Green
try {
    # Try invalid login
    $loginBody = @{
        username = "nonexistent_user_xyz"
        password = "wrongpassword"
    } | ConvertTo-Json
    
    $errorResponse = Invoke-RestMethod -Uri "http://localhost:3000/auth/login" -Method Post -Body $loginBody -ContentType "application/json" -ErrorAction Stop
    Write-Host "  ❌ Should have returned error" -ForegroundColor Red
} catch {
    $statusCode = $_.Exception.Response.StatusCode.value__
    if ($statusCode -eq 401) {
        Write-Host "  ✅ Returns proper error code (401)" -ForegroundColor Green
    } else {
        Write-Host "  ⚠️  Got status code: $statusCode" -ForegroundColor Yellow
    }
}
Write-Host ""

# Cleanup
Write-Host "Stopping server..." -ForegroundColor Yellow
Stop-Job $job
Remove-Job $job

Write-Host ""
Write-Host "=== DEBUG CHECKLIST COMPLETE ===" -ForegroundColor Cyan
