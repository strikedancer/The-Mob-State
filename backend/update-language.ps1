Write-Host "Pushing schema to database..." -ForegroundColor Cyan
Set-Location "C:\xampp\htdocs\mafia_game\backend"
npx prisma db push --skip-generate

Write-Host "`nUpdating all existing players to Dutch..." -ForegroundColor Cyan
$updateQuery = @"
UPDATE players SET preferredLanguage = 'nl' WHERE preferredLanguage = 'en';
SELECT id, username, preferredLanguage FROM players;
"@

$updateQuery | npx prisma db execute --stdin

Write-Host "`nDone!" -ForegroundColor Green
