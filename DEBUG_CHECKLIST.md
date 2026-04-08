nee want nog niet alles werkt zeg je net # Dev Health Checklist

**Run these checks after EVERY development step to catch issues early.**

---

## 1. Build & Type Safety

```powershell
cd backend
npm run check
```

**Expected:** ✅ No TypeScript errors, no lint errors, all tests pass

**If Fails:**
- TypeScript error → Fix type mismatches, add missing types
- Lint error → Run `npm run format`, fix remaining issues
- Test failure → Check test, update if behavior changed intentionally

---

## 2. Server Startup

```powershell
cd backend
npm run dev
```

**Expected:** ✅ Server starts, logs "Server running on port 3000"

**If Fails:**
- Port in use → Stop other process or change PORT in .env
- Module not found → Run `npm install`
- Database connection error → Check MariaDB running, verify DATABASE_URL

---

## 3. Health Endpoint

```powershell
curl http://localhost:3000/health
```

**Expected:** ✅ `{"status":"ok","timestamp":"..."}`

**If Fails:**
- 404 → Check route registered in app.ts
- 500 → Check error logs, likely database issue
- No response → Server not running or wrong port

---

## 4. Database Connection

```powershell
cd backend
npx prisma studio
```

**Expected:** ✅ Prisma Studio opens, shows all tables

**If Fails:**
- Connection error → Check MariaDB running in XAMPP
- Table missing → Run `npx prisma migrate dev`
- Schema mismatch → Run `npx prisma generate`

---

## 5. No Client Logic in Backend

**Manual Check:**
- [ ] Search backend code for UI strings (Dutch/English text)
- [ ] Ensure all responses use eventKey + params pattern
- [ ] No hardcoded error messages (use error codes)

**How to Check:**
```powershell
cd backend
# Search for hardcoded strings (example)
grep -r "You have" src/
```

**Expected:** ✅ No UI strings found, only eventKeys like "crime.success"

**If Found:** Replace with eventKey + params

---

## 6. Config-Only Balancing

**Manual Check:**
- [ ] Search for magic numbers in service code
- [ ] Ensure all balancing values loaded from content JSON or config

**How to Check:**
```powershell
cd backend
# Example: search for hardcoded numbers in crime logic
grep -E "reward.*[0-9]+" src/services/crimeService.ts
```

**Expected:** ✅ Values come from `content/crimes.json` or config

**If Found:** Move to content file

---

## 7. Time Provider Usage (for Determinism)

**Manual Check:**
- [ ] Search for `new Date()` or `Date.now()` usage
- [ ] Ensure services use injected timeProvider

**How to Check:**
```powershell
cd backend
grep -r "new Date()" src/services/
grep -r "Date.now()" src/services/
```

**Expected:** ✅ Only found in timeProvider.ts, all services use `timeProvider.now()`

**If Found:** Replace with injected timeProvider

---

## 8. API Response Format

**Manual Check:**
Test a few endpoints, ensure response shape consistent:

```powershell
curl -X POST http://localhost:3000/auth/register -H "Content-Type: application/json" -d "{\"username\":\"test\",\"password\":\"test123\"}"
```

**Expected:** ✅ `{"event":"auth.registered","params":{...},"player":{...}}`

**If Different:** Standardize response format across all endpoints

---

## 9. Database Transaction Usage

**Manual Check:**
- [ ] Check critical operations use transactions (money transfers, crew heists, etc.)

**How to Check:**
```typescript
// Look for prisma.$transaction in money-related code
```

**Expected:** ✅ All multi-step DB updates wrapped in transaction

**If Missing:** Add transaction to prevent data inconsistency

---

## 10. Error Handling

**Manual Check:**
Test error cases:

```powershell
# Invalid credentials
curl -X POST http://localhost:3000/auth/login -H "Content-Type: application/json" -d "{\"username\":\"fake\",\"password\":\"wrong\"}"
```

**Expected:** ✅ `{"error":"auth.invalid_credentials"}` with appropriate status code (401)

**If Fails:** Add error handling middleware, standardize error responses

---

## 11. CORS Configuration

**Manual Check:**
Test from Flutter web (different port):

```javascript
// In Flutter web console
fetch('http://localhost:3000/health').then(r => r.json()).then(console.log)
```

**Expected:** ✅ Response received, no CORS error

**If Fails:** Update CORS config in backend to allow client origin

---

## 12. Performance Check (Quick)

```powershell
# Use curl with timing
curl -w "\nTime: %{time_total}s\n" http://localhost:3000/events?limit=100
```

**Expected:** ✅ Response < 200ms for read endpoints

**If Slow:**
- Check for missing database indexes
- Check for N+1 queries
- Add select to fetch only needed fields

---

## 13. Memory Usage (Dev)

**Windows Task Manager:**
- Open Task Manager
- Find Node.js process
- Check memory usage

**Expected:** ✅ < 200MB for dev server at idle

**If High:**
- Check for memory leaks (unclosed connections)
- Check for large objects held in memory
- Use heap profiling: `node --inspect`

---

## 14. Test Coverage (After Writing Tests)

```powershell
cd backend
npm run test:coverage
```

**Expected:** ✅ > 70% coverage for services

**If Low:** Add tests for critical paths (auth, money transfers, etc.)

---

## 15. Content Validation

**Manual Check:**
Validate all JSON content files have correct schema:

```powershell
cd backend
# If you have a schema validator:
node scripts/validate-content.js
```

**Expected:** ✅ All content files valid

**If Invalid:** Fix JSON syntax, ensure required fields present

---

## 16. Environment Variables

**Manual Check:**
- [ ] .env has all required vars
- [ ] .env.example exists and up to date
- [ ] No secrets committed to git

**How to Check:**

---

## 17. Prisma Include/Relation Validation

**Manual Check:**
- [ ] Every Prisma `include: { ... }` relation used in services exists in `schema.prisma`
- [ ] Relation is defined on both linked models (bidirectional)

**How to Check:**
```powershell
cd backend
npx prisma validate
npx prisma generate
```

**Expected:** ✅ No validation errors, no `PrismaClientValidationError` at runtime

**If Fails:**
- Add missing relation fields in schema models
- Regenerate Prisma client
- Re-test the exact endpoint that uses `include`

---

## 18. Dashboard Resilience (Future.wait)

**Manual Check:**
- [ ] Screens using `Future.wait([...])` still render partial data when one endpoint fails
- [ ] API service methods return safe fallback values (`[]`, `{}`, `null`) where appropriate

**How to Check:**
```text
Temporarily force one API call in a dashboard to fail (500) and verify the rest of the screen still renders.
```

**Expected:** ✅ No fully blank dashboard due to a single failing request

**If Fails:**
- Split critical dashboard requests into separate try/catch blocks
- Or wrap each future with fallback handling before `Future.wait`
```powershell
# Check .env exists
ls .env

# Check .gitignore includes .env
cat .gitignore | grep ".env"
```

**Expected:** ✅ .env exists, .gitignore includes it

---

## 17. Logs (No Sensitive Data)

**Manual Check:**
Run any endpoint, check logs don't contain:
- Passwords
- Full JWT tokens
- Credit card numbers (if applicable)

**Expected:** ✅ Only safe data logged (usernames, IDs, error codes)

**If Found:** Sanitize logs, use [REDACTED] for sensitive fields

---

## 18. Git Status (Clean Working Tree)

```powershell
git status
```

**Expected:** ✅ Either all changes committed OR intentionally working on feature

**If Untracked Files:** Add to .gitignore or commit

---

## 19. Flutter Web Build (If Client Changed)

```powershell
cd client
flutter build web
```

**Expected:** ✅ Build succeeds, no errors

**If Fails:**
- Syntax error → Fix Dart code
- Missing dependency → Run `flutter pub get`

---

## 20. Docker Build Test (Before Deployment)

```powershell
docker build -t mafia-backend ./backend
```

**Expected:** ✅ Image builds successfully

**If Fails:**
- Missing file → Check .dockerignore not excluding needed files
- Dependency error → Update Dockerfile to install deps

---

## Quick Verification Script (Optional)

Create `backend/scripts/health-check.sh` (or .ps1 for Windows):

```powershell
# health-check.ps1
Write-Host "Running dev health checks..."

# 1. TypeCheck
Write-Host "`n[1/5] TypeScript check..."
npm run typecheck
if ($LASTEXITCODE -ne 0) { exit 1 }

# 2. Lint
Write-Host "`n[2/5] Lint check..."
npm run lint
if ($LASTEXITCODE -ne 0) { exit 1 }

# 3. Tests
Write-Host "`n[3/5] Running tests..."
npm test
if ($LASTEXITCODE -ne 0) { exit 1 }

# 4. Build
Write-Host "`n[4/5] Build check..."
npm run build
if ($LASTEXITCODE -ne 0) { exit 1 }

# 5. Health endpoint
Write-Host "`n[5/5] Health endpoint check..."
$response = Invoke-WebRequest -Uri http://localhost:3000/health
if ($response.StatusCode -ne 200) { exit 1 }

Write-Host "`n✅ All checks passed!"
```

Run it:
```powershell
cd backend
.\scripts\health-check.ps1
```

---

**TIP:** Keep this checklist open in a second monitor or print it. Check items after every significant change!
