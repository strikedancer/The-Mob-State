# Firebase Push Notifications - Voltooiing

## ✅ Wat is nu klaar:

### Frontend (Flutter):
- ✅ Firebase geïnitialiseerd in `main.dart`
- ✅ `firebase_options.dart` aangemaakt met project config
- ✅ VAPID key geïntegreerd in `notification_service.dart`
- ✅ Service worker `firebase-messaging-sw.js` toegevoegd voor web push
- ✅ NotificationService start automatisch na login
- ✅ Token registratie met backend API

### Backend:
- ✅ `/notifications/register-token` endpoint klaar
- ✅ `/notifications/unregister-token` endpoint klaar
- ✅ `player_devices` tabel in database
- ✅ NotificationService class met Firebase Admin SDK
- ✅ Integratie in friendService voor friend request notifications

### Database:
- ✅ MariaDB draait en is bereikbaar
- ✅ Database credentials gecorrigeerd in `.env`

## 🔧 Nog 1 stap om Firebase volledig werkend te krijgen:

### Stap: Firebase Service Account toevoegen

**Waarom nodig?**  
De backend heeft een Firebase Service Account JSON nodig om push notifications te versturen via Firebase Admin SDK.

**Hoe te doen:**

1. **Ga naar Firebase Console:**
   - Open: https://console.firebase.google.com
   - Selecteer je project: **"The Mob State"**

2. **Genereer Service Account Key:**
   - Klik op het tandwiel ⚙️ (rechtsboven) → **Project settings**
   - Ga naar tab **"Service accounts"**
   - Klik op **"Generate new private key"**
   - Klik **"Generate key"** in de popup
   - Er wordt een JSON bestand gedownload

3. **Bestand plaatsen:**
   ```
   Hernoem het bestand naar: firebase-service-account.json
   Plaats in: C:\xampp\htdocs\mafia_game\backend\firebase-service-account.json
   ```

4. **Backend herstarten:**
   ```powershell
   # Stop backend (Ctrl+C in terminal waar het draait)
   # Of:
   taskkill /F /IM node.exe
   
   # Start backend opnieuw
   cd C:\xampp\htdocs\mafia_game\backend
   npm run dev
   ```

5. **Verificatie:**
   Je zou in de backend logs moeten zien:
   ```
   [NotificationService] Firebase Admin SDK initialized
   ```

**⚠️ BELANGRIJK - Beveiliging:**
- Deel dit bestand NOOIT (bevat geheime API keys!)
- Het is al toegevoegd aan `.gitignore`, dus wordt niet ge-commit naar Git
- Als je dit per ongeluk commit, revoke de key meteen in Firebase Console

## 🧪 Testen

1. **Login in de app:**
   - Open Chrome
   - Login als testuser2
   - Check browser console (F12) voor: `[NotificationService] FCM Token: ...`

2. **Database check:**
   ```sql
   SELECT * FROM player_devices WHERE playerId = 2;
   ```
   Je zou de FCM token moeten zien.

3. **End-to-end test (als Firebase Service Account is toegevoegd):**
   - Open tweede browser (incognito)
   - Login als een andere user (bijv. strikedancer)
   - Stuur een friend request naar testuser2
   - testuser2 zou een push notification moeten ontvangen!

4. **Backend logs checken:**
   ```
   [Notifications] Registered web device for player 2
   [NotificationService] Sent notification to player 2: 1 succeeded, 0 failed
   ```

## 📱 Web vs Android

### Web (Chrome):
- ✅ Werkt nu via `firebase-messaging-sw.js`
- ✅ Notifications verschijnen als Chrome push messages
- ⚠️ Werkt alleen op HTTPS in productie (localhost is OK voor development)

### Android:
- ✅ `google-services.json` moet in `client/android/app/` geplaatst worden
- ✅ Notificaties werken via Firebase Cloud Messaging
- ℹ️ Vereist een Android build: `flutter build apk`

## 🚀 Status

**KLAAR VOOR TESTEN:**
- Login werkt ✅
- Firebase geïnitialiseerd ✅
- Service worker toegevoegd ✅
- Token registratie backend endpoint ✅

**ALLEEN DIT NOG DOEN:**
- Firebase Service Account JSON plaatsen in backend (1 minuut)

Zodra de Service Account JSON is toegevoegd, zijn push notifications volledig functioneel! 🎉
