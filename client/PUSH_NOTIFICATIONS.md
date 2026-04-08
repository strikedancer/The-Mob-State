# Push Notifications Setup

## ✅ Status
- **Web (Chrome/Firefox)**: ✅ WERKEND
- **Android**: ✅ GECONFIGUREERD (Testen vereist)
- **iOS**: ✅ GECONFIGUREERD (Extra stappen vereist)

## Platform-specifieke configuratie

### 🌐 Web
**Status**: Volledig werkend ✅

**Vereisten**:
- Service Worker geregistreerd (`firebase-messaging-sw.js`)
- VAPID key geconfigureerd in NotificationService
- Browser moet notifications toestaan

**Testen**:
```bash
cd client
flutter run -d chrome
```

**Gedrag**:
- **Foreground**: Notifications verschijnen ook als tab actief is
- **Background**: Service Worker toont notifications (rechtsonder in Windows)
- **Minimized**: Windows toast notifications verschijnen

---

### 🤖 Android
**Status**: Geconfigureerd, klaar om te testen ✅

**Wat is geconfigureerd**:
1. ✅ Google Services plugin toegevoegd (`build.gradle.kts`)
2. ✅ Package name aangepast naar `com.mobstate.mafia_game_client`
3. ✅ Push notification permissions in AndroidManifest
4. ✅ Firebase Cloud Messaging metadata
5. ✅ Notification channel (high_importance_channel)
6. ✅ google-services.json met correcte package name

**Testen op Android device/emulator**:
```bash
cd client
flutter run -d <device-id>
```

**Gedrag**:
- **Foreground**: Local notification verschijnt via FlutterLocalNotificationsPlugin
- **Background**: FCM toont automatisch notification in system tray
- **Terminated**: FCM toont notification, app opent bij tap

**Debug logs checken**:
```bash
flutter logs
```

Zoek naar:
```
[NotificationService] FCM Token: <android-token>
[NotificationService] Token registered with backend
```

---

### 🍎 iOS
**Status**: Geconfigureerd, extra stappen vereist ⚠️

**Wat is geconfigureerd**:
1. ✅ GoogleService-Info.plist aanwezig
2. ✅ NotificationService vraagt iOS permissions

**Extra vereiste stappen**:
1. **Apple Developer Account** nodig
2. **APNs certificaat** genereren in Firebase Console
3. **Push Notifications capability** inschakelen in Xcode:
   - Open `ios/Runner.xcworkspace` in Xcode
   - Selecteer Runner target
   - Ga naar "Signing & Capabilities"
   - Klik "+ Capability"
   - Voeg "Push Notifications" toe
   - Voeg "Background Modes" toe
   - Enable "Remote notifications"

4. **Provisioning profile** met push notifications

**Testen op iOS simulator** (beperkt):
```bash
cd client
flutter run -d <ios-simulator>
```
⚠️ **Let op**: iOS Simulator ondersteunt GEEN push notifications. Je moet een echt device gebruiken.

**Testen op iOS device**:
```bash
flutter run -d <ios-device>
```

**Gedrag**:
- **Foreground**: Notification banner verschijnt (iOS 14+)
- **Background**: iOS toont notification in Notification Center
- **Terminated**: iOS toont notification, app opent bij tap

---

## Backend ondersteuning

De backend (`/notifications/register-token`) accepteert alle platforms:
- `deviceType: 'web'` ✅
- `deviceType: 'android'` ✅
- `deviceType: 'ios'` ✅

Tokens worden opgeslagen in `player_devices` tabel.

**Notificaties versturen**:
Backend gebruikt Firebase Admin SDK om notifications te versturen:
```typescript
await admin.messaging().send({
  token: device.deviceToken,
  notification: {
    title: 'New Friend Request',
    body: 'strikedancer wants to connect with you'
  },
  data: {
    type: 'friend_request',
    senderUsername: 'strikedancer'
  }
});
```

Dit werkt voor alle platforms (web/android/ios).

---

## Troubleshooting

### Android: Notification verschijnt niet
1. Check logcat: `flutter logs`
2. Verify token registration in backend logs
3. Check notification channel in Android settings
4. Ensure `google-services.json` package name matches `build.gradle.kts`

### iOS: Notification verschijnt niet
1. Check dat je een echt device gebruikt (geen simulator)
2. Verify APNs certificaat in Firebase Console
3. Check iOS notification settings: Settings > Notifications > Mafia Game
4. Verify Push Notifications capability in Xcode

### Web: Service worker niet geregistreerd
1. Check browser console: `navigator.serviceWorker.getRegistrations()`
2. Hard reload: Ctrl+Shift+R
3. Check `firebase-messaging-sw.js` in `/web/` folder

---

## Testing Checklist

### Web ✅
- [x] Service worker geregistreerd
- [x] Token registration succesvol (geen 500 error)
- [x] Foreground notifications werken
- [x] Background notifications werken
- [x] Notification click handler werkt

### Android 
- [ ] Build succesvol zonder errors
- [ ] Token registration succesvol
- [ ] Foreground notifications werken
- [ ] Background notifications werken
- [ ] Notification tap opent app
- [ ] Notification icon zichtbaar

### iOS 
- [ ] Push Notifications capability toegevoegd in Xcode
- [ ] APNs certificaat geconfigureerd in Firebase
- [ ] Token registration succesvol
- [ ] Foreground notifications werken
- [ ] Background notifications werken
- [ ] Notification tap opent app

---

## Next Steps

1. **Test op Android device/emulator**:
   ```bash
   flutter run -d <android-device>
   ```

2. **Setup iOS Push Notifications**:
   - Open `ios/Runner.xcworkspace` in Xcode
   - Add Push Notifications capability
   - Generate APNs certificate in Firebase Console
   - Upload APNs key to Firebase

3. **Test end-to-end**:
   - Login on device
   - Send friend request from another account
   - Verify notification appears

4. **Monitor logs**:
   ```bash
   # Backend logs
   cd backend && npm run dev
   
   # Flutter logs
   cd client && flutter logs
   ```
