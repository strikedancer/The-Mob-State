## Test Push Notification Fix

**Probleem**: strikedancer op Android ontvangt geen push notificaties wanneer testuser2 een bericht stuurt.

**Root cause**: Import statements voor NotificationService en translationService ontbraken in directMessageService.ts, waardoor de notificatie code niet werkte.

**Fix toegepast**:
1. Added missing imports in `backend/src/services/directMessageService.ts`:
   ```typescript
   import { NotificationService } from './notificationService';
   import { translationService } from './translationService';
   ```

2. Backend herstart

**Test nu**:
1. testuser2 (in Chrome) stuurt een bericht naar strikedancer
2. Backend zou notificatie moeten sturen
3. strikedancer's Android device zou notificatie moeten ontvangen

**Verify logs**:
```bash
docker logs mafia-backend -f | Select-String -Pattern "DirectMessage|Notification"
```

**Status**: Backend fix applied, waiting for user to test by sending a message.
