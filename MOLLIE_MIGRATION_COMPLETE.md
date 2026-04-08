# Stripe to Mollie Payment System Migration - COMPLETED ✅

## Summary
Successfully migrated the mafia_game backend payment system from Stripe to Mollie Payment Provider.

## Database Changes
✅ **Created columns:**
- `players.mollieCustomerId` (VARCHAR 255) - Stores Mollie customer ID for recurring billing
- `crews.mollieSubscriptionId` (VARCHAR 255) - Stores Mollie subscription ID for crew VIP

✅ **Migration applied:** `stripe_to_mollie_rename` 
- File: `/backend/prisma/migrations/stripe_to_mollie_rename/migration.sql`
- Status: Applied successfully via `prisma migrate deploy`

## Code Changes

### 1. Dependencies (`package.json`)
- **Removed:** `"stripe": "^20.4.1"`
- **Added:** `"@mollie/api-client": "^4.2.0"`
- Status: ✅ Installed successfully

### 2. Prisma Schema (`schema.prisma`)
- Updated Player model: `stripeCustomerId` → `mollieCustomerId`
- Updated Crew model: `stripeSubscriptionId` → `mollieSubscriptionId`
- Also removed references to old Stripe fields
- Status: ✅ Schema synchronized with database

### 3. Subscriptions Routes (`src/routes/subscriptions.ts`)
Complete API rewrite with Mollie integration:

**Endpoints:**
- `POST /checkout/player-vip` - Player VIP: €6.99/month
- `POST /checkout/crew-vip` - Crew VIP: €9.99/month (leader-only)
- `GET /subscriptions/status` - Check VIP status
- `POST /webhook` - Mollie webhook handler

**Key Features:**
- Automatic Mollie customer creation per player
- Monthly recurring subscription with auto-renewal
- Metadata tracking (playerId, crewId, subscription type)
- VIP status activation/deactivation with `activateVip()` and `deactivateVip()`
- Building downgrade on cancellation (HQ from Villa→VIP, storage levels capped at 10 for non-VIP)
- Webhook handling for `subscription.status === 'active|canceled'`

**Technical Details:**
- Amount format: `{ currency: 'EUR', value: '6.99' }`
- Subscription interval: `'1 month'`
- No limit on renewal times (removed `times: undefined`)
- Checkout URL from subscription `_links.checkout.href`

### 4. App Middleware (`src/app.ts`)
- Webhook middleware: Changed to `express.json()` instead of `express.raw()`
- Mollie sends JSON payloads (not raw buffer)

## Verification

### TypeScript Compilation
✅ All 22 previous Mollie-related TypeScript errors resolved
✅ `subscriptions.ts` compiles with zero errors
✅ Prisma types correctly include `mollieCustomerId` and `mollieSubscriptionId`

### Database State
✅ Both Mollie columns verified present in database:
- `players.mollieCustomerId`
- `crews.mollieSubscriptionId`

### Migration Track Record
✅ All 17 Prisma migrations applied successfully:
1. 20260127162658_init
2. 20260127182741_add_world_events
3. 20260127184431_add_vehicles
4. 20260127190427_add_vehicle_breakdown
5. 20260127194051_add_crime_attempts
6. 20260127195742_add_job_attempts
7. 20260127201253_add_properties
8. 20260127210000_add_crews
9. 20260127220000_add_trust_score
10. 20260129105932_update_property_fields
11. 20260224051915_add_travel_journey_tracking
12. 20260224210000_add_property_drug_storage
13. 20260225160000_add_hitlist_system
14. 20260226190000_add_weapon_shop_and_ammo_factories
15. 20260228111806_add_ammo_purchase_cooldown
16. add_crew_vip_status
17. **stripe_to_mollie_rename** (NEW)

## Environment Configuration Required
The backend requires the following environment variable to be set:
```
MOLLIE_API_KEY=live_xxxxxxxxxxxxxxxxxxxx  # or test_yyyy... for testing
```

## Frontend Status
✅ No changes required to Flutter frontend (`client/`)
- Checkout flow remains identical
- POST to `/subscriptions/checkout/{type}` returns `{ url: '...' }`
- Frontend launches checkout URL in external browser

## Testing Checklist
Before going live, test:
- [ ] Create player VIP subscription (€6.99/month)
- [ ] Create crew VIP subscription (€9.99/month, leader-only)
- [ ] Verify Mollie customer is created automatically
- [ ] Complete payment in Mollie test environment
- [ ] Verify webhook receives subscription status updates
- [ ] Verify VIP flags and expiration dates are set correctly
- [ ] Test subscription cancellation and building downgrades
- [ ] Verify checkout URLs are valid and clickable

## Build Status
✅ Project ready for deployment
- All dependencies installed
- Database schema synchronized
- TypeScript compilation successful
- No blocking errors

## Rollback Instructions
If needed to revert:
1. Restore old `package.json` with Stripe
2. Restore old `schema.prisma` with stripe* fields
3. Restore old `src/routes/subscriptions.ts`
4. Restore old `src/app.ts`
5. Run `npm install && npx prisma db push`
