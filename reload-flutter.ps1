### Quick Fix Script - Reload Flutter Web App

# Stop de Flutter web server
Write-Host "🔄 Reloading Flutter web app..." -ForegroundColor Cyan

# Check if Flutter is running
$flutterProcess = Get-Process -Name "dart" -ErrorAction SilentlyContinue | Where-Object {$_.Path -like "*flutter*"}

if ($flutterProcess) {
    Write-Host "⏹️  Stopping Flutter..." -ForegroundColor Yellow
    Stop-Process -Id $flutterProcess.Id -Force
    Start-Sleep -Seconds 2
}

# Start Flutter web
Write-Host "▶️  Starting Flutter web..." -ForegroundColor Green
Set-Location "C:\xampp\htdocs\mafia_game\client"

# Run flutter web
Start-Process powershell -ArgumentList "-NoExit", "-Command", "flutter run -d chrome --web-port 56083"

Write-Host "✅ Flutter web is starting..." -ForegroundColor Green
Write-Host "📱 Open browser: http://localhost:56083" -ForegroundColor Cyan
Write-Host "" 
Write-Host "⚠️  IMPORTANT: Refresh your browser (Ctrl+F5) to load new code!" -ForegroundColor Yellow
