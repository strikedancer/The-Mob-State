# File Inventory & Cleanup Reference

**Last Updated:** April 8, 2026  
**Purpose:** Track which files are required for runtime vs. development/historical artifacts

---

## REQUIRED FILES (Keep - Runtime Essential)

### Core Application
- `docker-compose.yml` - Container orchestration
- `backend/` - Node.js/TypeScript backend service
- `client/` - Flutter/Dart mobile application
- `admin/` - Admin panel (if actively used)
- `tools/` - Utility tools for operations
- `package-lock.json` - Dependency lock file
- `.git/`, `.gitattributes`, `.githooks/`, `.github/`, `.gitignore` - Version control

### Essential Documentation (Game Rules & System)

**Root Level:**
- `I18N.md` - Internationalization system (NL/EN)
- `EVENT_SYSTEM_PROTOCOL.md` - Event system architecture
- `ASSETS.md` - Asset reference and management
- `GIT_WORKFLOW.md` - Git branching/workflow standards
- `COPILOT_PROTOCOL.md` - AI/automation guidelines
- `TODO.md` - Active task tracking (if maintained)

**Game Systems Docs** (`docs/game-systems/`):
- `GAMEPLAY.md` - Game mechanics and ruleset
- `NIGHTCLUB_SYSTEM.md` - Nightclub module documentation
- `HQ_PROGRESSION_GUIDE.md` - Player progression systems
- `VIP_LEVELS_SYSTEM.md` - VIP tier mechanics
- `VIP_MANAGEMENT.md` - VIP staff management
- `TRADE_RISK_MECHANICS.md` - Trading and risk systems

**Operations Docs** (`docs/operations/`):
- `DEPLOY.md` - Deployment procedures
- `FIREBASE_SETUP.md` - Active Firebase configuration
- `RELEASE_CHECKLIST.md` - Pre-release QA checklist

### Protocol & Architecture Docs
- `docs/module-protocols/` - All active module protocols
- `docs/module-protocols/PROTOCOL_MASTER.md` - Master protocol (required in all tasks)
- `docs/module-protocols/README.md` - Protocol index

---

## OPTIONAL FILES (Keep Clean - Reference/Context)

These can stay but aren't essential for runtime:
- `MOLLIE_MIGRATION_COMPLETE.md` - Payment migration reference (archived completion)
- `backup.sql` - Database backup (store separately if possible)

---

## ARCHIVED/REDUNDANT (Can Be Removed)

### Generation Scripts (One-Time Use Only)
```
generate_arrest_video.py
generate_badges_fix.py
generate_badges_simple.py
generate_crime_images.py
generate_crime_video_test.py
generate_crypto_badges_gpt_image.py
generate_crypto_badges_leonardo.py
generate_crypto_icons_leonardo.py
generate_crypto_responsive_images.py
generate_drug_badges_leonardo.py
generate_drug_environment_backgrounds.py
generate_drug_facilities.py
generate_drug_item_images.py
generate_drug_subscreen_backgrounds.py
generate_flux_crime_videos.py
generate_flux_crime_videos_from_images.py
generate_flux_images.py
generate_flux_images_v2.py
generate_flux_jobs_images.py
generate_flux_tools_images.py
generate_jail_cooldown.py
generate_jail_cooldown_replicate.py
generate_nightclub_achievement_badges.py
generate_nightclub_responsive_images.py
generate_prostitution_seedream_images.py
generate_realistic_images.py
generate_real_crime_images.py
generate_seedream_boats.py
generate_seedream_vehicle_variants.py
generate_smuggling_assets_leonardo.py
generate_smuggling_responsive_images.py
generate_tuneshop_images.py
```

### Utility & Test Scripts (Development Only)
```
create_cooldown_postHeist.py
create_job_placeholders.py
create_test_video.py
run_badge_generation.py
transform_jail_image.py
test_rank_calc.js
flux_crime_images.py
optimize_nightclub_images.py
get_version.py
```

### PowerShell Utilities (One-Time Setup/Cleanup)
```
flutter_cleanup.ps1
full_cleanup.ps1
reload-flutter.ps1
grant-vip.ps1
```

### Log Files (All Transient)
```
backend-log.txt
badge_generation.log
badge_generation_debug.log
flux_gen.log
flux_generation.log
flux_output.log
flux_run.log
gen.log
output.log
```

### AI Prompt/Reference Docs (Development Artifacts)
```
AI_VEHICLE_IMAGE_PROMPTS.md
AI_VEHICLE_IMAGE_PROMPTS_EXISTING.md
AVATAR_PROMPTS.md
CREW_BUILDING_PROMPTS.md
CREW_BUILDING_PROMPTS_RAPHAEL.md
CRYPTO_BADGES_LEONARDO_PROMPTS.md
CRYPTO_SCREEN_IMAGES_LEONARDO_PROMPTS.md
DRUG_BADGES_LEONARDO_PROMPTS.md
DRUG_ITEM_IMAGES_LEONARDO.md
PROSTITUTION_IMAGE_PROMPTS.md
IMAGE_PROMPTS_AMMO_AND_BACKGROUNDS.md
KNIFE_IMAGE_PROMPT.md
LEONARDO_IMAGE_GENERATION_PROTOCOL.md
```

### Setup/Migration Documents (Completed Actions)
```
FIREBASE_SETUP_STAPPEN.md
FIREBASE_VOLTOOIING.md
BUILDING_IMAGES_SETUP.md
PLESK_BATCH_DEPLOY_RUNBOOK.md
PRISMA_MIGRATION_PROTOCOL.md
SMUGGLING_PHASE3_SMOKE_TEST.md
```

### Historical Planning/Status (Superseded)
```
PHASE_2_PLAN.md
PHASE7_COMPLETION_REPORT.md
PHASE_12_COMPLETION_REPORT.md
COPILOT_MASTER_PLAN.md
DEBUG_CHECKLIST.md
DELIVERY_SUMMARY.md
FRONTEND_INTEGRATION_COMPLETE.md
FRONTEND_INTEGRATION_GUIDE.md
NEXTTODO.md
PHASE11_VERIFICATION.md
PUSH_NOTIFICATIONS_STATUS.md
VEHICLE_CRIME_SYSTEM_STATUS.md
CHAT_IMPLEMENTATION.md
```

---

## Cleanup Statistics

| Category | Count | Action |
|----------|-------|--------|
| Generation Scripts | 32 | Remove |
| Utility Scripts | 10 | Remove |
| PowerShell Utilities | 4 | Remove |
| Log Files | 8 | Remove |
| AI Prompt Docs | 13 | Remove |
| Setup Docs | 6 | Remove |
| Historical Docs | 13 | Remove |
| **Total Removable** | **86** | **Archive/Delete** |

---

## Recommended Cleanup Process

1. **Archive** non-essential files to a separate folder (e.g., `_archived/`) before deletion
2. **Keep** this FILE_INVENTORY.md in root for future reference
3. **Update** PROTOCOL_MASTER.md to reference this inventory
4. **Commit** to git after cleanup ("docs: archive unnecessary dev files")

---

## Future Maintenance

When adding new files:
- ✅ System docs → Keep in root
- ✅ Game mechanics → Keep in root  
- ✅ Deployment guides → Keep in root
- ❌ One-time generation scripts → Remove after use
- ❌ Temporary logs → Exclude from git (.gitignore)
- ❌ Development prompts → Store externally or in `_assets/prompts/` if needed
