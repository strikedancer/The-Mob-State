# Copilot Usage Protocol

**How to effectively work with GitHub Copilot on this project.**

---

## General Principles

1. **Small, incremental changes** - Don't ask Copilot to build entire systems at once
2. **One task at a time** - Focus on single TODO item before moving to next
3. **Verify after each step** - Run checks from DEBUG_CHECKLIST.md after every change
4. **Commit frequently** - Commit after each completed TODO item
5. **Request audits** - Ask Copilot to review code for issues after each phase

---

## Phase-by-Phase Prompting Strategy

### Phase 0: Setup

**Goal:** Get basic backend running with health endpoint

**Prompts:**

```
1. "Create a basic Express TypeScript app in backend/src with a /health endpoint"
2. "Add error handling middleware to backend/src/app.ts"
3. "Create a config loader in backend/src/config that reads from .env"
4. "Add a TimeProvider interface in backend/src/utils/timeProvider.ts for dependency injection"
5. "Update package.json scripts: dev (ts-node-dev), build (tsc), start (node dist/index.js)"
```

**Verify:**
```powershell
cd backend
npm run dev
curl http://localhost:3000/health
```

**Audit Prompt:**
```
"Review backend/src for:
- Are all errors handled?
- Is the TimeProvider injectable?
- Are there any hardcoded values that should be in config?"
```

---

### Phase 1: Database

**Goal:** Prisma setup with Player model

**Prompts:**

```
1. "Install Prisma and initialize with MariaDB provider"
2. "Create a Player model in schema.prisma with: id, username, passwordHash, money, health, hunger, thirst, rank, createdAt"
3. "Generate the first migration named 'init'"
4. "Create a prisma client instance in backend/src/lib/prisma.ts"
```

**Verify:**
```powershell
npx prisma studio
```

**Audit Prompt:**
```
"Review schema.prisma:
- Are indexes added for frequently queried fields (username)?
- Are default values set correctly?
- Is createdAt/updatedAt handled?"
```

---

### Phase 2: Authentication

**Goal:** Register and login endpoints with JWT

**Prompts:**

```
1. "Create authService.ts with register(username, password) that hashes password and creates Player"
2. "Add login(username, password) that verifies password and returns JWT"
3. "Create auth routes in backend/src/routes/auth.ts for POST /auth/register and /auth/login"
4. "Create authenticate middleware that verifies JWT and attaches player to request"
```

**Verify:**
```powershell
curl -X POST http://localhost:3000/auth/register -H "Content-Type: application/json" -d '{"username":"test","password":"test123"}'
curl -X POST http://localhost:3000/auth/login -H "Content-Type: application/json" -d '{"username":"test","password":"test123"}'
```

**Audit Prompt:**
```
"Review authentication code:
- Is password hashing using bcrypt with sufficient rounds?
- Is JWT secret loaded from env?
- Are passwords never logged or returned in responses?
- Is there rate limiting on auth endpoints?"
```

---

### Phase 3: World Events

**Goal:** Store and retrieve game events

**Prompts:**

```
1. "Create WorldEvent model in schema.prisma with: id, eventKey, params (JSON), playerId, isPublic, createdAt"
2. "Add migration for WorldEvent"
3. "Create worldEventService.ts with createEvent(eventKey, params, playerId, isPublic)"
4. "Create GET /events route that returns recent events (paginated, limit 100)"
```

**Verify:**
```powershell
# Trigger an event (e.g., login)
curl http://localhost:3000/events?limit=10
```

**Audit Prompt:**
```
"Review event system:
- Are all events using eventKey + params pattern?
- Is pagination efficient with proper indexes?
- Are private events filtered correctly?"
```

---

### Phase 4: Hunger/Thirst Tick

**Goal:** Periodic tick that depletes stats

**Prompts:**

```
1. "Create tickService.ts that runs every N minutes (from config) and decreases hunger/thirst for all players"
2. "Add playerService.applyTick(playerId) that decreases hunger/thirst by config amount"
3. "Add playerService.checkDeath(playerId) that kills player if both hunger and thirst reach 0"
4. "Start tick service in index.ts on server startup"
```

**Verify:**
```typescript
// In test or manually:
// Set player hunger to 10, wait tick interval, check it decreased
```

**Audit Prompt:**
```
"Review tick system:
- Is tickService a singleton?
- Are tick intervals configurable?
- Is TimeProvider used instead of new Date()?
- Are database updates batched for performance?"
```

---

### Phase 5-14: Repeat Pattern

For each subsequent phase (crimes, vehicles, crews, etc.):

**1. Define Content (if applicable)**
```
"Create content/crimes.json with 5 crime definitions including risk, reward, xp, requiredLevel"
```

**2. Create Service Logic**
```
"Create crimeService.ts with attemptCrime(playerId, crimeId) that:
- Loads crime definition from JSON
- Calculates success based on risk and player level
- Awards money and xp on success, emits crime.success event
- Deducts money and emits crime.failed event on failure"
```

**3. Create Routes**
```
"Create POST /crimes/:crimeId/attempt route that calls crimeService and returns event"
```

**4. Add Tests**
```
"Create crimeService.test.ts with tests for:
- Successful crime attempt
- Failed crime attempt
- Insufficient level check
- Cooldown enforcement"
```

**5. Verify & Audit**
```powershell
npm test
curl -X POST http://localhost:3000/crimes/pickpocket/attempt -H "Authorization: Bearer <token>"
```

```
"Audit crime system:
- Are all values from JSON, no hardcoded numbers?
- Is RNG deterministic in tests?
- Are events emitted for all outcomes?
- Is money updated atomically?"
```

---

## Keeping Changes Small

---

## Data Contract Safety (Mandatory)

When changing backend Prisma models or service includes, always verify the contract end-to-end.

### 1. Prisma Relation Contract

If service code uses `include: { relationName: true }` (or nested includes), the relation must exist in `schema.prisma` on BOTH sides.

**Checklist:**

```text
- Added/updated relation field in model A
- Added/updated relation field in model B
- `npx prisma generate` runs clean
- Runtime query with include works (no PrismaClientValidationError)
```

### 2. Schema/Query Alignment

Never query fields that are not present in the Prisma model (example: filtering on `country` when the model has no `country` field).

**Verification prompt for Copilot:**

```text
"Check all Prisma `where` clauses in this feature against schema.prisma fields and list mismatches before coding fixes."
```

### 3. Fail-Open Dashboard Loading

For Flutter screens using `Future.wait([...])`, one failing request can blank the whole page.

Prefer partial loading for dashboards:

```text
- Critical card requests in separate try/catch blocks, OR
- Use `Future.wait` on wrapped futures that return safe fallbacks
```

This avoids "everything disappears" when one endpoint fails.

### ✅ Good Prompts (Small Scope)

```
"Add a Vehicle model to schema.prisma with fields: id, playerId, vehicleType, fuel, isBroken"
"Create a helper function in backend/src/utils/random.ts that generates seeded random numbers"
"Add a cooldown check middleware in backend/src/middleware/checkCooldown.ts"
```

### ❌ Bad Prompts (Too Large)

```
"Build the entire vehicle system with purchase, fuel, breakdown, and repair"
"Implement all 30 crimes at once"
"Create the complete Flutter app with all screens"
```

**Why?** Large prompts lead to:
- Copilot missing details
- Code that's hard to verify
- Difficult to debug if something breaks
- Lost work if you need to redo

**Solution:** Break into 5-10 small prompts instead.

---

## Requesting Audits

After completing a TODO item or phase, ask Copilot to audit the code.

### Audit Checklist Prompts

**Security Audit:**
```
"Review all backend code for:
- SQL injection vulnerabilities
- JWT token leaks in logs
- Unvalidated user input
- Missing authentication checks on protected routes"
```

**Performance Audit:**
```
"Review backend code for:
- N+1 query problems
- Missing database indexes
- Unoptimized loops
- Large objects held in memory"
```

**Architecture Audit:**
```
"Review backend code for:
- Is business logic in services, not routes?
- Are all dependencies injected (not hardcoded)?
- Is TimeProvider used everywhere instead of Date()?
- Are all config values loaded from .env or content JSON?"
```

**Testing Audit:**
```
"Review test coverage:
- Are all critical paths tested?
- Are tests deterministic (no random failures)?
- Are external dependencies mocked?
- Is test data isolated (not affecting other tests)?"
```

---

## Flutter Client Prompts

When building the client, use similar incremental approach.

### Example Flow

**1. Setup**
```
"Initialize a Flutter project in /client folder"
"Add http and flutter_secure_storage dependencies to pubspec.yaml"
```

**2. API Client**
```
"Create lib/services/api_client.dart with:
- Base URL from environment
- Method for GET/POST with JWT auth header
- Error handling for 401, 500"
```

**3. Auth Service**
```
"Create lib/services/auth_service.dart with:
- login(username, password) that calls /auth/login and stores token
- logout() that clears token
- isLoggedIn getter"
```

**4. First Screen**
```
"Create lib/screens/login_screen.dart with:
- Username and password text fields
- Login button that calls authService.login()
- Navigation to dashboard on success"
```

**5. Verify & Iterate**
```
flutter run -d chrome
# Test login flow
```

---

## Working with Content JSON

When creating content files (crimes, jobs, vehicles):

**1. Define Schema First**
```
"Create a JSON schema for crimes in backend/content/schemas/crime.schema.json with required fields: id, nameKey, risk, minReward, maxReward, xp, requiredLevel"
```

**2. Create Sample Content**
```
"Create backend/content/crimes.json with 5 example crimes following the schema"
```

**3. Add Validation**
```
"Create backend/src/utils/validateContent.ts that validates all JSON files against their schemas on startup"
```

**4. Use in Service**
```
"Update crimeService.ts to load crimes from crimes.json and validate on startup"
```

---

## Debugging with Copilot

When something breaks:

**1. Describe the Error**
```
"I'm getting 'Cannot find module prisma/client' when running npm run dev. How do I fix this?"
```

**2. Share Context**
```
"The /crimes/pickpocket/attempt endpoint returns 500. Here's the error log: [paste error]. What's wrong?"
```

**3. Request Step-by-Step Fix**
```
"My Player model is missing the hunger field. Walk me through adding it:
1. Update schema
2. Create migration
3. Regenerate client"
```

---

## Code Review Prompts

Before committing, ask Copilot to review:

```
"Review the code I just wrote in crimeService.ts and tell me:
1. Are there any bugs?
2. Is error handling complete?
3. Are there edge cases I missed?
4. Can performance be improved?"
```

---

## Migration from Dev to Production

When deploying:

**1. Environment Check**
```
"Review all .env variables and tell me which ones need to be changed for production"
```

**2. Security Hardening**
```
"What security improvements should I make before deploying to production?"
```

**3. Performance Optimization**
```
"Suggest database indexes and caching strategies for production load"
```

---

## Best Practices Summary

### DO:
- ✅ Break tasks into small steps
- ✅ Verify after each change
- ✅ Commit after each TODO item
- ✅ Request audits after each phase
- ✅ Use descriptive prompts with context
- ✅ Ask for explanations if unsure
- ✅ Follow the TODO.md sequence

### DON'T:
- ❌ Ask for entire features at once
- ❌ Skip verification steps
- ❌ Ignore audit recommendations
- ❌ Commit untested code
- ❌ Use vague prompts like "make it work"
- ❌ Accept generated code without understanding it
- ❌ Jump ahead in TODO.md

---

## Example Session Workflow

**Session 1: Backend Skeleton**
1. Prompt: "Create basic Express TypeScript app with /health endpoint"
2. Verify: `npm run dev` + `curl /health`
3. Prompt: "Add error handling middleware"
4. Verify: Test with invalid route
5. Prompt: "Create config loader"
6. Verify: Check .env values loaded
7. Commit: "Phase 0.2 complete: Backend skeleton"
8. Audit: "Review error handling and config loading"
9. Update TODO.md: Check off item 0.2

**Session 2: Database Setup**
1. Prompt: "Install Prisma and create Player model"
2. Verify: `npx prisma studio`
3. Prompt: "Add indexes to username field"
4. Verify: Check migration file
5. Commit: "Phase 0.3 complete: Prisma setup"
6. Audit: "Review schema.prisma for best practices"
7. Update TODO.md: Check off item 0.3

**Continue this pattern for all phases...**

---

## Getting Unstuck

If Copilot suggests code that doesn't work:

1. **Simplify the prompt** - Ask for one specific thing
2. **Provide more context** - Show error messages, file structure
3. **Ask for explanation** - "Explain how this code works"
4. **Request alternatives** - "Give me 3 different approaches to solve this"
5. **Check TODO.md** - Ensure prerequisites are complete

---

## Measuring Progress

After each session:

1. Count TODO items checked off
2. Run `npm run check` - should pass
3. Run `npm test` - should pass
4. Check git status - changes committed
5. Update progress notes in TODO.md

---

## Final Deployment Checklist Prompt

Before deploying:

```
"I'm ready to deploy to production. Review the entire codebase and give me a checklist of:
1. Security issues to fix
2. Performance optimizations needed
3. Missing error handling
4. Hardcoded values that should be config
5. Missing tests for critical paths
6. Documentation that needs updating"
```

---

**Keep this protocol open while working. Refer to it when planning each session.**

This approach ensures steady progress, high code quality, and minimal debugging time.
