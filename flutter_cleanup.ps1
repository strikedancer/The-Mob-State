# Flutter Cleanup Script
# Geeft schijfruimte vrij en reinigt Flutter/Dart caches
# Gebruik: .\flutter_cleanup.ps1

Write-Host "Flutter Cleanup Started..." -ForegroundColor Green
Write-Host ""

# Change to client directory
if (Test-Path "client") {
    Set-Location client
    Write-Host "Navigated to client directory" -ForegroundColor Cyan
} else {
    Write-Host "client directory not found. Run from project root." -ForegroundColor Red
    exit 1
}

# Clean Flutter build artifacts
Write-Host "Cleaning Flutter build artifacts..." -ForegroundColor Yellow
flutter clean 2>$null
Remove-Item -Recurse -Force build -ErrorAction SilentlyContinue | Out-Null
Remove-Item -Recurse -Force .dart_tool -ErrorAction SilentlyContinue | Out-Null

# Clean pub cache
Write-Host "Cleaning pub package cache..." -ForegroundColor Yellow
flutter pub cache clean 2>$null

# Reinstall dependencies
Write-Host "Reinstalling dependencies..." -ForegroundColor Yellow
flutter pub get 2>$null

Write-Host ""
Write-Host "Cleanup complete!" -ForegroundColor Green
Write-Host "Disk space has been freed successfully." -ForegroundColor Green
Write-Host ""

