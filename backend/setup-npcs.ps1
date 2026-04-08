# NPC System Setup Script

Write-Host "🤖 Setting up NPC System..." -ForegroundColor Cyan
Write-Host ""

# Run Prisma migration
Write-Host "📦 Running Prisma migration..." -ForegroundColor Yellow
npx prisma migrate dev --name add_npc_system

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Migration failed!" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Migration complete!" -ForegroundColor Green
Write-Host ""

# Generate Prisma client
Write-Host "🔧 Generating Prisma client..." -ForegroundColor Yellow
npx prisma generate

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Prisma generate failed!" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Prisma client generated!" -ForegroundColor Green
Write-Host ""

# Run test script
Write-Host "🧪 Creating test NPCs..." -ForegroundColor Yellow
npx ts-node test-npcs.ts

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Test script failed!" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "✅ NPC System setup complete!" -ForegroundColor Green
Write-Host ""
Write-Host "📝 Next steps:" -ForegroundColor Cyan
Write-Host "   1. Restart the backend server to enable NPC scheduler"
Write-Host "   2. NPCs will automatically simulate activity every 5 minutes"
Write-Host "   3. Use admin panel to manage NPCs and view statistics"
Write-Host ""
Write-Host "🔗 Admin API Endpoints:" -ForegroundColor Cyan
Write-Host "   GET    /admin/npcs                    - List all NPCs"
Write-Host "   POST   /admin/npcs                    - Create new NPC"
Write-Host "   GET    /admin/npcs/:id/stats          - Get NPC statistics"
Write-Host "   POST   /admin/npcs/:id/simulate       - Simulate NPC activity"
Write-Host "   POST   /admin/npcs/simulate-all/run   - Simulate all NPCs"
Write-Host "   POST   /admin/npcs/:id/activate       - Activate NPC"
Write-Host "   POST   /admin/npcs/:id/deactivate     - Deactivate NPC"
Write-Host "   DELETE /admin/npcs/:id                - Delete NPC"
Write-Host ""
