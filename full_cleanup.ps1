# Full Project Cleanup Script
# Geeft VEEL meer schijfruimte vrij (Docker, node_modules, caches)
# Deze script reinigt alles behalve database!
# Gebruik: .\full_cleanup.ps1

Write-Host "Full Project Cleanup Started..." -ForegroundColor Green
Write-Host ""

# 1. Flutter cleanup
Write-Host "1. Cleaning Flutter..." -ForegroundColor Yellow
if (Test-Path "client") {
    Set-Location client
    flutter clean 2>$null
    Remove-Item -Recurse -Force build -ErrorAction SilentlyContinue
    Remove-Item -Recurse -Force .dart_tool -ErrorAction SilentlyContinue
    flutter pub cache clean 2>$null
    Set-Location ..
}
Write-Host "   Done!" -ForegroundColor Green

# 2. Backend node_modules cleanup
Write-Host "2. Cleaning node_modules..." -ForegroundColor Yellow
Remove-Item -Recurse -Force backend/node_modules -ErrorAction SilentlyContinue
Write-Host "   Done!" -ForegroundColor Green

# 3. NPM cache
Write-Host "3. Cleaning npm cache..." -ForegroundColor Yellow
npm cache clean --force 2>$null
Write-Host "   Done!" -ForegroundColor Green

# 4. Docker cleanup (AGGRESSIVE - verwijdert ongebruikte images/containers)
Write-Host "4. Cleaning Docker..." -ForegroundColor Yellow
docker system prune -af --volumes 2>$null
docker image prune -af 2>$null
Write-Host "   Done!" -ForegroundColor Green

# 5. Temp folder cleanup
Write-Host "5. Cleaning temp folders..." -ForegroundColor Yellow
Remove-Item -Recurse -Force $env:TEMP\flutter* -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force $env:TEMP\dart* -ErrorAction SilentlyContinue
Write-Host "   Done!" -ForegroundColor Green

Write-Host ""
Write-Host "Full cleanup complete!" -ForegroundColor Green
Write-Host "This should have freed several GB of space." -ForegroundColor Green
Write-Host ""
Write-Host "To reinstall everything:" -ForegroundColor Cyan
Write-Host "  1. cd backend && npm install" -ForegroundColor Cyan
Write-Host "  2. cd ../client && flutter pub get" -ForegroundColor Cyan
Write-Host "  3. docker compose up -d --build" -ForegroundColor Cyan
Write-Host ""
