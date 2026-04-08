# Push Notifications Implementation - Status Report

## ✅ Completed (Backend Ready)

### Database
- ✅ Created `player_devices` table with FCM token storage
- ✅ Added `PlayerDevice` model to Prisma schema
- ✅ Generated Prisma client with new model
- ✅ Notification preference columns already exist in `players` table

### Backend Services
- ✅ Created `NotificationService` class with FCM integration
  - Sends multicast messages to all user devices
  - Automatically removes invalid tokens
  - Handles errors gracefully (won't break friend requests)
  
- ✅ Created `/notifications` API routes
  - `POST /notifications/register-token` - Register device FCM token
  - `DELETE /notifications/unregister-token` - Remove token on logout
  
- ✅ Integrated push notifications in `friendService`
  - Sends notification on friend request (if `notifyFriendRequest = 1`)
  - Sends notification on friend accepted (if `notifyFriendAccepted = 1`)
  - Works alongside existing email notifications

### Flutter Client
- ✅ Added Firebase dependencies to pubspec.yaml
  - firebase_core: ^3.8.1
  - firebase_messaging: ^15.1.5
  - flutter_local_notifications: ^18.0.1
  
- ✅ Created `NotificationService` class
  - Requests notification permissions
  - Gets FCM token from device
  - Registers token with backend API
  - Handles foreground notifications (Android)
  - Handles background notifications (all platforms)
  - Listens for token refresh

## ⚠️ To Be Configured (Firebase Setup Required)

### 1. Install firebase-admin on Backend

```bash
cd backend
npm install firebase-admin
```

### 2. Create Firebase Project

1. Go to https://console.firebase.google.com
2. Create new project: "The Mob State"
3. Enable Google Analytics (optional)

### 3. Get Firebase Service Account (Backend)

1. In Firebase Console → Project Settings → Service Accounts
2. Click "Generate New Private Key"
3. Save as `backend/firebase-service-account.json`
4. **IMPORTANT**: Add to `.gitignore`

### 4. Initialize Firebase Admin in Backend

Edit `backend/src/index.ts` (or `backend/dist/index.js` if TypeScript broken):

```javascript
const { notificationService } = require('./services/notificationService');
const path = require('path');

// After app initialization, before server.listen():
const serviceAccountPath = path.join(__dirname, '../firebase-service-account.json');
notificationService.initialize(serviceAccountPath);
```

### 5. Add Android App to Firebase

1. Firebase Console → Add app → Android
2. Package name: `com.mobstate.mafia_game_client`
3. Download `google-services.json`
4. Place in `client/android/app/google-services.json`

### 6. Add iOS App to Firebase

1. Firebase Console → Add app → iOS
2. Bundle ID: `com.mobstate.mafiaGameClient`
3. Download `GoogleService-Info.plist`
4. Place in `client/ios/Runner/GoogleService-Info.plist`

### 7. Add Web App to Firebase

1. Firebase Console → Add app → Web
2. Copy the **Web Push certificate (VAPID key)**
3. Edit `client/lib/services/notification_service.dart`:

```dart
// Line ~40, replace with actual VAPID key
_fcmToken = await _messaging.getToken(
  vapidKey: 'YOUR_VAPID_KEY_FROM_FIREBASE_CONSOLE',
);
```

### 8. Configure Firebase in Flutter

```bash
cd client

# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase (generates firebase_options.dart)
flutterfire configure

# Install packages
flutter pub get
```

### 9. Initialize Firebase in Flutter App

Edit `client/lib/main.dart`:

```dart
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(MyApp());
}
```

### 10. Initialize NotificationService After Login

Edit `client/lib/services/auth_service.dart` (in the login method):

```dart
// After successful login, before returning player data:
try {
  await NotificationService().initialize();
  print('Push notifications initialized');
} catch (e) {
  print('Failed to initialize push notifications: $e');
  // Don't fail login if notifications fail
}
```

## 📝 How It Works

### Friend Request Flow

1. User A sends friend request to User B
2. Backend creates friendship record (status: pending)
3. **Email**: If User B has `emailFriendRequest = 1`, sends styled email
4. **Push**: If User B has `notifyFriendRequest = 1`, sends FCM notification to all User B's devices
5. User B receives notification on Android/iOS/Web
6. Tapping notification opens app (handled by NotificationService)

### Friend Accept Flow

1. User B accepts User A's friend request
2. Backend updates friendship (status: accepted)
3. **Email**: If User A has `emailFriendAccepted = 1`, sends styled email
4. **Push**: If User A has `notifyFriendAccepted = 1`, sends FCM notification to all User A's devices
5. User A receives notification on all their devices

### Token Management

- FCM tokens are stored in `player_devices` table
- One player can have multiple devices (web, Android, iOS)
- Tokens are automatically refreshed when they expire
- Invalid tokens are automatically removed after failed send attempts
- Tokens are registered on login, can be unregistered on logout

## 🧪 Testing (After Firebase Setup)

### 1. Test Device Registration

```bash
# Login as testuser2
# Check if token was registered
mysql -u root mafia_game -e "SELECT * FROM player_devices WHERE playerId = 2;"
```

### 2. Test Friend Request Notification

1. Login as strikedancer (ID: 15)
2. Send friend request to testuser2 (ID: 2)
3. Backend should log:
   ```
   [Notifications] Registered web device for player 2
   [NotificationService] Sent notification to player 2: 1 succeeded, 0 failed
   ```
4. testuser2 should receive push notification

### 3. Test Friend Accept Notification

1. Login as testuser2
2. Accept strikedancer's friend request
3. strikedancer should receive push notification

## 🔐 Security & Privacy

- Users can disable notifications via database columns (UI pending):
  - `notifyFriendRequest` - Enable/disable push notifications for requests
  - `notifyFriendAccepted` - Enable/disable push notifications for accepts
  - `emailFriendRequest` - Enable/disable email notifications for requests
  - `emailFriendAccepted` - Enable/disable email notifications for accepts

- All notifications respect user preferences
- Failed notifications don't block main operations
- Invalid tokens are automatically cleaned up
- Firebase service account should NEVER be committed to git

## 📚 Documentation

Full setup instructions: `FIREBASE_SETUP.md`

## 🚀 Next Steps (Priority Order)

1. **HIGH**: Install `npm install firebase-admin` in backend
2. **HIGH**: Create Firebase project and get service account JSON
3. **HIGH**: Initialize Firebase Admin in backend/src/index.ts
4. **MEDIUM**: Add Android/iOS/Web apps to Firebase project
5. **MEDIUM**: Run `flutterfire configure` in client folder
6. **MEDIUM**: Initialize Firebase in client/lib/main.dart
7. **MEDIUM**: Initialize NotificationService after login
8. **LOW**: Create settings UI for notification preferences
9. **LOW**: Test on real Android/iOS devices (requires Firebase setup)

## ⚡ Current State

**Ready to use** - Just needs Firebase configuration:
- ✅ Database schema
- ✅ Backend API endpoints
- ✅ Backend notification service
- ✅ Flutter notification service
- ✅ Integration in friendService
- ✅ Email notifications (already working)
- ⏳ Firebase project setup (user needs to do this)
- ⏳ FCM tokens (will work after Firebase setup)

**Without Firebase setup**, the system will:
- ✅ Continue to send email notifications (working)
- ✅ Accept friend requests/deletes normally
- ⚠️ Log warning: "Firebase Admin not initialized"
- ⚠️ Skip push notifications silently (no errors)
