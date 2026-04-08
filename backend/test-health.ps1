Write-Host "Testing health endpoint..."
try {
    $response = Invoke-RestMethod -Uri http://localhost:3000/health
    Write-Host "✅ Health check successful!" -ForegroundColor Green
    Write-Host ($response | ConvertTo-Json -Depth 10)
} catch {
    Write-Host "❌ Health check failed: $_" -ForegroundColor Red
}
