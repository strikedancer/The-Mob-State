# Crime Outcome System - Test Script (PowerShell)
# Tests all 6 crime scenarios via API calls
# Prerequisites:
#   - Backend running on localhost:3000
#   - Valid JWT token (update $token variable)
#   - Player with vehicles and tools

$ErrorActionPreference = "Stop"

# Configuration
$api_base = "http://localhost:3000"
$player_id = 1  # Update this to your test player ID
$crime_id = "robbery"  # Test with robbery crime
$token = "YOUR_JWT_TOKEN_HERE"  # Update with actual token

# Colors
$colors = @{
    "Red" = [ConsoleColor]::Red
    "Green" = [ConsoleColor]::Green
    "Yellow" = [ConsoleColor]::Yellow
    "Cyan" = [ConsoleColor]::Cyan
    "Blue" = [ConsoleColor]::Blue
}

function Write-Colored {
    param(
        [string]$Text,
        [ConsoleColor]$Color = [ConsoleColor]::White
    )
    Write-Host $Text -ForegroundColor $Color
}

function Invoke-ApiRequest {
    param(
        [string]$Method,
        [string]$Endpoint,
        $Body = $null
    )
    
    $headers = @{
        "Authorization" = "Bearer $token"
        "Content-Type" = "application/json"
    }
    
    if ($Body) {
        $bodyJson = $Body | ConvertTo-Json
        return Invoke-RestMethod -Method $Method -Uri "$api_base$endpoint" `
            -Headers $headers -Body $bodyJson
    } else {
        return Invoke-RestMethod -Method $Method -Uri "$api_base$endpoint" `
            -Headers $headers
    }
}

# Main test execution
Write-Colored "╔════════════════════════════════════════════╗" Blue
Write-Colored "║  Crime Outcome System - Test Suite         ║" Blue
Write-Colored "╚════════════════════════════════════════════╝" Blue
Write-Host ""

# Test 1: Get player's vehicles
Write-Colored "📋 Fetching player vehicles..." Yellow
try {
    $vehicles = Invoke-ApiRequest -Method Get -Endpoint "/garage/vehicles"
    
    if ($vehicles -and $vehicles.Count -gt 0) {
        Write-Colored "✅ Found $($vehicles.Count) vehicles" Green
        $vehicles | Select-Object -First 3 | ForEach-Object {
            Write-Host "  • $($_.vehicleType): Condition=$($_.condition)% Fuel=$($_.fuel)/$($_.maxFuel)"
        }
    } else {
        Write-Colored "❌ No vehicles found" Red
        exit 1
    }
    
    $vehicleId = $vehicles[0].id
    Write-Colored "Using vehicle ID: $vehicleId" Yellow
    
} catch {
    Write-Colored "❌ Error fetching vehicles: $_" Red
    exit 1
}

Write-Host ""

# Test 2: Set vehicle as crime vehicle
Write-Colored "🚗 Setting vehicle for crimes..." Yellow
try {
    $selectResult = Invoke-ApiRequest -Method Post -Endpoint "/garage/crime-vehicle" `
        -Body @{ vehicleId = $vehicleId }
    Write-Colored "✅ Vehicle selected" Green
} catch {
    Write-Colored "❌ Error setting vehicle: $_" Red
    exit 1
}

Write-Host ""

# Test 3: Attempt crime
Write-Colored "🎯 Attempting $crime_id crime..." Yellow
try {
    $crimeResult = Invoke-ApiRequest -Method Post -Endpoint "/crimes/attempt" `
        -Body @{ crimeId = $crime_id }
    
    Write-Colored "Crime Result:" Blue
    Write-Host "  • Outcome: $($crimeResult.outcome)"
    Write-Host "  • Success: $($crimeResult.success)"
    Write-Host "  • Reward: €$($crimeResult.reward)"
    Write-Host "  • Message: $($crimeResult.outcomeMessage)"
    
    if ($crimeResult.vehicleConditionLoss) {
        Write-Host "  • Vehicle Condition Loss: $($crimeResult.vehicleConditionLoss.ToString('F2'))%"
    }
    if ($crimeResult.toolDamageSustained) {
        Write-Host "  • Tool Damage: $($crimeResult.toolDamageSustained)%"
    }
    
} catch {
    Write-Colored "❌ Error attempting crime: $_" Red
    exit 1
}

Write-Host ""
Write-Colored "═══════════════════════════════════════════" Blue
Write-Host ""

$outcome = $crimeResult.outcome

switch ($outcome) {
    "success" {
        Write-Colored "✅ SUCCESS - Crime completed successfully" Green
    }
    "caught" {
        Write-Colored "🚨 CAUGHT - Arrested by police" Red
    }
    "out_of_fuel" {
        Write-Colored "⛽ OUT OF FUEL - Fled on foot, lost loot and vehicle" Yellow
    }
    "vehicle_breakdown_before" {
        Write-Colored "🔧 BREAKDOWN - Vehicle broke before reaching crime scene" Yellow
    }
    "vehicle_breakdown_during" {
        Write-Colored "🔧 BREAKDOWN - Vehicle broke during escape, lost 70% loot" Yellow
    }
    "tool_broke" {
        Write-Colored "🔨 TOOL BROKE - Tool failed, left evidence" Yellow
    }
    "fled_no_loot" {
        Write-Colored "💨 FLED - Escaped without loot" Yellow
    }
    default {
        Write-Colored "❓ UNKNOWN OUTCOME: $outcome" Red
    }
}

Write-Host ""
Write-Colored "═══════════════════════════════════════════" Blue
Write-Host ""
Write-Colored "✨ Test completed!" Yellow
Write-Host ""
Write-Colored "To verify database changes, run:" Yellow
Write-Colored "SELECT * FROM crime_attempts WHERE playerId = $player_id ORDER BY createdAt DESC LIMIT 1;" Blue
Write-Host ""

# Optional: Show recent crime attempts
Write-Colored "📊 Recent Crime Attempts:" Yellow
try {
    $history = Invoke-ApiRequest -Method Get -Endpoint "/crimes/history?limit=3"
    $history | ForEach-Object {
        $status = if ($_.success) { "✅" } else { "❌" }
        Write-Host "$status $($_.crimeName): Reward=$($_.reward) XP=$($_.xpGained)"
    }
} catch {
    # Silently fail if endpoint doesn't exist
}
