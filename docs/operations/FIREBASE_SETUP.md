# Firebase Push Notifications Setup

## Prerequisites

1. Create a Firebase project at https://console.firebase.google.com
2. Install Firebase Admin SDK: `npm install firebase-admin`

## Backend Setup

### 1. Generate Service Account Key

1. Go to Firebase Console → Project Settings → Service Accounts
2. Click "Generate New Private Key"
3. Save the JSON file as `firebase-service-account.json` in `backend/` directory
4. **IMPORTANT**: Add `firebase-service-account.json` to `.gitignore`

### 2. Initialize Firebase Admin

Production/VPS voorkeur:

Gebruik geen gecommit `firebase-service-account.json` in de container-image. Geef de service-account runtime mee via een van deze paden:

1. `FIREBASE_SERVICE_ACCOUNT_JSON` met de volledige JSON in 1 env var
2. `FIREBASE_SERVICE_ACCOUNT_BASE64` met base64 van de volledige JSON
3. Losse env vars `FIREBASE_PROJECT_ID`, `FIREBASE_CLIENT_EMAIL`, `FIREBASE_PRIVATE_KEY`
4. Alleen als fallback: een echt beschikbaar bestandspad via `FIREBASE_SERVICE_ACCOUNT_PATH`

Voor `docker-compose.plesk.yml` hoort minimaal een van bovenstaande env-varianten aan de backend-service te worden doorgegeven. Alleen `FIREBASE_SERVICE_ACCOUNT_PATH=firebase-service-account.json` zetten zonder file-mount of env payload is onvoldoende en laat push live stil uitstaan.

In `backend/src/index.ts`, add after app initialization:

```typescript
import { notificationService } from './services/notificationService';
import path from 'path';

// Initialize Firebase Admin SDK
const serviceAccountPath = path.join(__dirname, '../firebase-service-account.json');
notificationService.initialize(serviceAccountPath);
```

## Flutter Client Setup

### 1. Add Firebase to Android

1. In Firebase Console, add an Android app
2. Package name: `com.mobstate.mafia_game_client` (or your app's package name)
3. Download `google-services.json`
4. Place it in `client/android/app/google-services.json`

### 2. Add Firebase to iOS

1. In Firebase Console, add an iOS app
2. Bundle ID: `com.mobstate.mafiaGameClient` (or your app's bundle ID)
3. Download `GoogleService-Info.plist`
4. Place it in `client/ios/Runner/GoogleService-Info.plist`

### 3. Add Firebase to Web

1. In Firebase Console, add a Web app
2. Copy the **Web Push certificate (VAPID key)**
3. Update `client/lib/services/notification_service.dart`:

```dart
_fcmToken = await _messaging.getToken(
  vapidKey: 'YOUR_VAPID_KEY_HERE',  // Replace with actual VAPID key
);
```

### 4. Install Flutter Packages

Run in `client/` directory:

```bash
flutter pub get
```

### 5. Configure Firebase Options

Install FlutterFire CLI:

```bash
dart pub global activate flutterfire_cli
```

Run from `client/` directory:

```bash
flutterfire configure
```

This will generate `lib/firebase_options.dart` automatically.

### 6. Initialize Firebase in Flutter

Update `client/lib/main.dart`:

```dart
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(MyApp());
}
```

### 7. Initialize NotificationService

In `client/lib/services/auth_service.dart`, after successful login:

```dart
// Initialize push notifications
try {
  await NotificationService().initialize();
} catch (e) {
  print('Failed to initialize notifications: $e');
}
```

## Testing

### Test Backend Endpoint

```bash
# Register a device token (requires valid JWT token)
curl -X POST http://localhost:3000/notifications/register-token \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -d '{"token":"test_device_token_123","deviceType":"web"}'
```

### Test Friend Request Notification

1. Login as user A
2. Send friend request to user B (who should have FCM token registered)
3. User B should receive push notification on their device

## Database Schema

The `player_devices` table stores FCM tokens:

```sql
CREATE TABLE player_devices (
  id INT AUTO_INCREMENT PRIMARY KEY,
  playerId INT NOT NULL,
  deviceToken VARCHAR(500) NOT NULL,
  deviceType ENUM('android', 'ios', 'web') NOT NULL,
  createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
  updatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (playerId) REFERENCES players(id) ON DELETE CASCADE,
  UNIQUE KEY unique_device_token (deviceToken(255))
);
```

## Notification Preferences

Users can control notifications via database columns:

- `notifyFriendRequest` - Enable/disable push notifications for friend requests
- `notifyFriendAccepted` - Enable/disable push notifications when request accepted
- `emailFriendRequest` - Enable/disable email notifications for friend requests
- `emailFriendAccepted` - Enable/disable email notifications when request accepted

All default to `true` (enabled).

## Troubleshooting

### Push notifications not working

1. Check Firebase Admin is initialized (backend logs should show `[NotificationService] Firebase Admin SDK initialized`)
2. If admin system logs show `Firebase Admin not initialized for push send`, verify the backend container actually receives one of `FIREBASE_SERVICE_ACCOUNT_JSON`, `FIREBASE_SERVICE_ACCOUNT_BASE64`, or the split Firebase env vars, or that the configured `FIREBASE_SERVICE_ACCOUNT_PATH` exists inside the container.
2. Verify device token is registered (`SELECT * FROM player_devices WHERE playerId = X`)
3. Check FCM token is valid (Firebase Console → Cloud Messaging → Send test message)
4. Ensure notification preferences are enabled (`notifyFriendRequest = 1`)

### Android notifications not showing

1. Check notification permissions are granted
2. Verify `google-services.json` is in correct location
3. Ensure notification channel is created (handled by FlutterLocalNotificationsPlugin)

### iOS notifications not showing

1. Check notification permissions are granted in app settings
2. Verify `GoogleService-Info.plist` is in correct location
3. Ensure APNs certificate is configured in Firebase Console

### Web notifications not showing

1. Check browser supports notifications (Chrome, Firefox, Edge)
2. Verify VAPID key is correct
3. Check notification permission is granted (browser will prompt)
4. Ensure HTTPS is used (required for service workers)

## Security Notes

- **Never commit** `firebase-service-account.json` to version control
- Keep VAPID key secure (not critical but recommended)
- Device tokens should be automatically cleaned up when invalid
- Consider rate limiting notification sending to prevent abuse
