You are my lead engineer. I want you to fully flesh out a complete build plan and persistent TODO checklist for my project.

Project:
- Multiplayer text-based mafia game
- Clients: Flutter (Android/iOS/Web) single codebase
- Admin: Web dashboard (separate app)
- Backend: Node.js + TypeScript, server-authoritative
- Local dev on Windows with XAMPP (MariaDB)
- Deployment on Linux VPS (Strato) using Docker
- Must be multilingual: all server events store eventKey + params; clients render localized strings from ARB files

Constraints:
- Avoid high memory usage and slow dev: keep clients thin, keep logic server-side, avoid heavy frameworks unless needed.
- Keep everything content-driven: actions/items/assets are JSON content packs.
- No hardcoded balancing values outside backend config.
- Provide deterministic testing using a time provider/clock injection.

Your task:
1) Create a persistent master TODO checklist file at /TODO.md with phases and checkboxes. It must be designed to stay open during development and debugging.
2) For each TODO item, include:
   - brief explanation
   - which files/modules are expected to exist when done
   - how to verify it (command + expected output)
   - common failure + fix
3) Create a “dev health” checklist at /DEBUG_CHECKLIST.md with repeated checks to run after every step (no client logic, config-only numbers, performance hints).
4) Create scripts in backend/package.json to support:
   - dev, build, start
   - lint, format
   - test
   - check: runs lint+test+typecheck
5) Add a root-level “monorepo” scripts suggestion (optional) explaining how to run backend and Flutter web together.
6) Add a deployment plan at /DEPLOY.md:
   - Docker compose dev + prod for backend + MariaDB + Nginx
   - Environment variables
   - Steps to deploy to Strato VPS
7) Add a multilingual plan at /I18N.md:
   - eventKey+params patterns
   - ARB file structure
   - translation workflow
8) Add an assets plan at /ASSETS.md:
   - complete list of base images and overlay PNGs
   - naming convention
   - recommended sizes and formats
9) Provide a “Copilot usage protocol” at /COPILOT_PROTOCOL.md:
   - How to prompt per phase
   - How to keep changes small
   - How to request audits after each phase
10) Ensure the generated TODO phases cover:
   - backend skeleton + /health
   - prisma + Player model + migrations
   - WorldEvents feed with SSE/WS
   - hunger/thirst + injury + hospital
   - vehicles + fuel + escape breakdown
   - content-driven actions (30 crime + 24 jobs)
   - properties/business upgrades + overlay keys in API
   - crews + trust + sabotage + heists + liquidations (public)
   - police/FBI/judges with ratio + guideline enforcement + appeals
   - banks + robberies impacting depositors
   - 8 countries + trade + abstract contraband/alcohol
   - aviation endgame with caps + licensing + public flight alerts
   - flutter app for web + android (iOS later)
   - flutter i18n with nl+en, rendering eventKey+params
   - admin dashboard with RBAC + audit logs
   - performance hardening (Redis optional, queues, DB indexes)
   - docker deployment

Output:
- Write the contents of each file (TODO.md, DEBUG_CHECKLIST.md, DEPLOY.md, I18N.md, ASSETS.md, COPILOT_PROTOCOL.md) directly.
- Keep it practical, command-based, and suitable for Windows dev + Linux deploy.
- Do not include any illegal real-world instructions (e.g., drug manufacturing). Keep contraband fictional/abstract.
