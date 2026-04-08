# Firebase Push Notificaties Installatie - Stap voor Stap

## ✅ Al Klaar (Geen Actie Nodig)
- ✅ Backend code voor notificaties
- ✅ Flutter NotificationService
- ✅ Database tabellen
- ✅ Email notificaties werken al
- ✅ firebase-admin geïnstalleerd in backend

## 🔧 Wat Je Moet Doen

### Stap 1: Firebase Project Aanmaken (5 minuten)

1. **Open Firebase Console**
   - Ga naar: https://console.firebase.google.com
   - Klik op "Add project" of "Create a project"

2. **Project Instellingen**
   - Project naam: `The Mob State` (of jouw app naam)
   - Google Analytics: Kun je aanzetten (optioneel)
   - Klik "Create project"
   - Wacht tot project klaar is

### Stap 2: Firebase Service Account voor Backend (5 minuten)

1. **Service Account Key Genereren**
   - In Firebase Console, klik op tandwiel ⚙️ → Project settings
   - Ga naar tab "Service accounts"
   - Klik "Generate new private key"
   - Klik "Generate key" in popup
   - JSON bestand wordt gedownload

2. **Bestand Plaatsen**
   ```
   Download bestand → hernoem naar: firebase-service-account.json
   Plaats in map: C:\xampp\htdocs\mafia_game\backend\
   ```

3. **Beveiliging (BELANGRIJK!)**
   - Voeg toe aan `.gitignore`:
   ```
   # Firebase
   firebase-service-account.json
   ```
   - Deel dit bestand NOOIT (bevat geheime keys!)

### Stap 3: Android App Toevoegen aan Firebase (10 minuten)

1. **Android App Registreren**
   - Firebase Console → klik op Android icoon
   - Android package name: `com.mobstate.mafia_game_client`
   - App nickname: `Mafia Game Android` (optioneel)
   - SHA-1 certificate: Kun je skippen voor nu
   - Klik "Register app"

2. **google-services.json Downloaden**
   - Download `google-services.json`
   - Plaats in: `C:\xampp\htdocs\mafia_game\client\android\app\google-services.json`

3. **Verifieer Package Name**
   ```
   Open: client/android/app/build.gradle
   Zoek naar: applicationId "..."
   Moet zijn: "com.mobstate.mafia_game_client"
   ```

### Stap 4: Web App Toevoegen aan Firebase (5 minuten)

1. **Web App Registreren**
   - Firebase Console → klik op Web icoon (</>)
   - App nickname: `Mafia Game Web` (optioneel)
   - Firebase Hosting: Niet aanvinken (nog niet nodig)
   - Klik "Register app"

2. **VAPID Key Kopiëren**
   - Scroll naar "Cloud Messaging" sectie
   - Kopieer de **Web Push certificates** key (begint met "B...")
   - Of ga naar: Project Settings → Cloud Messaging → Web configuration
   - Kopieer "Key pair" / "Web Push certificates"

3. **VAPID Key in Code Zetten**
   ```
   Open: client/lib/services/notification_service.dart
   Zoek regel ~40:
   
   // WAS:
   vapidKey: 'YOUR_VAPID_KEY_HERE',
   
   // WORDT:
   vapidKey: 'BAbCdEfGhI...jouw_echte_vapid_key_hier',
   ```

### Stap 5: FlutterFire CLI Installeren en Configureren (10 minuten)

1. **FlutterFire CLI Installeren**
   ```powershell
   # Open PowerShell in client folder
   cd C:\xampp\htdocs\mafia_game\client
   
   # Installeer FlutterFire CLI
   dart pub global activate flutterfire_cli
   ```

2. **FlutterFire Configureren**
   ```powershell
   # Nog steeds in client folder
   flutterfire configure
   ```
   
   Dit commando:
   - Vraagt om in te loggen bij Firebase
   - Toont lijst van je Firebase projecten
   - Selecteer "The Mob State" project
   - Selecteer platforms: Web, Android (en iOS als je die hebt)
   - Genereert automatisch `lib/firebase_options.dart`

3. **Packages Installeren**
   ```powershell
   flutter pub get
   ```

### Stap 6: Firebase Initialiseren in Flutter App (5 minuten)

1. **main.dart Aanpassen**
   ```
   Open: client/lib/main.dart
   ```
   
   Voeg toe BOVENAAN:
   ```dart
   import 'package:firebase_core/firebase_core.dart';
   import 'firebase_options.dart';
   ```
   
   Verander `main()` functie naar:
   ```dart
   void main() async {
     WidgetsFlutterBinding.ensureInitialized();
     
     // Initialize Firebase
     await Firebase.initializeApp(
       options: DefaultFirebaseOptions.currentPlatform,
     );
     
     runApp(
       ChangeNotifierProvider(
         create: (_) => AuthService(),
         child: const MyApp(),
       ),
     );
   }
   ```

### Stap 7: NotificationService Starten na Login (5 minuten)

1. **auth_service.dart Aanpassen**
   ```
   Open: client/lib/services/auth_service.dart
   ```
   
   Zoek de `login()` functie, na succesvolle login (waar `_currentPlayer` wordt gezet), voeg toe:
   ```dart
   // Initialize push notifications
   try {
     await NotificationService().initialize();
     print('✅ Push notifications initialized');
   } catch (e) {
     print('⚠️ Push notifications failed: $e');
     // Don't fail login if notifications fail
   }
   ```

### Stap 8: Backend Firebase Admin Initialiseren (5 minuten)

1. **index.js Aanpassen**
   ```
   Open: backend/dist/index.js
   ```
   
   Voeg toe NA de `startServer()` functie wordt aangeroepen (rond regel 40-50):
   ```javascript
   const { notificationService } = require('./services/notificationService');
   const path = require('path');
   
   // Initialize Firebase Admin SDK
   const serviceAccountPath = path.join(__dirname, '../firebase-service-account.json');
   notificationService.initialize(serviceAccountPath);
   ```

2. **Backend Herstarten**
   ```powershell
   # Stop backend (Ctrl+C in terminal waar het draait)
   # Of kill all Node processes:
   taskkill /F /IM node.exe
   
   # Start opnieuw
   cd C:\xampp\htdocs\mafia_game\backend
   node dist/index.js
   ```
   
   Je zou moeten zien:
   ```
   [NotificationService] Firebase Admin SDK initialized
   ```

### Stap 9: Testen (10 minuten)

1. **Flutter App Starten**
   ```powershell
   cd C:\xampp\htdocs\mafia_game\client
   flutter run -d chrome
   ```

2. **Inloggen**
   - Log in als testuser2
   - Check browser console voor:
     ```
     ✅ Push notifications initialized
     ```

3. **Database Checken**
   ```sql
   -- Check of token is geregistreerd
   SELECT * FROM player_devices WHERE playerId = 2;
   ```

4. **Friend Request Sturen**
   - Open tweede browser (incognito)
   - Log in als strikedancer
   - Stuur friend request naar testuser2
   - testuser2 zou notificatie moeten krijgen!

5. **Backend Logs Checken**
   ```
   [Notifications] Registered web device for player 2
   [NotificationService] Sent notification to player 2: 1 succeeded, 0 failed
   ```

## 🌐 Lokaal vs Online

**GOED NIEUWS**: Je kunt dit NU al doen tijdens lokale development!

### Wat werkt lokaal:
- ✅ Firebase initialisatie in Flutter app (localhost)
- ✅ Firebase Admin SDK in backend (localhost)
- ✅ Push notifications naar browser (Chrome localhost)
- ✅ Push notifications naar Android device (via USB debugging)
- ✅ FCM token registratie bij backend API

### Hoe het werkt:
```
Flutter App (localhost:port) 
    ↓ Initialize Firebase
Firebase Servers (cloud)
    ↓ Send FCM token
Backend API (localhost:3000)
    ↓ Store in database
    ↓ Send notification via Firebase Admin SDK
Firebase Cloud Messaging (cloud)
    ↓ Deliver notification
Your Device/Browser (receives notification)
```

### Je hoeft NIET online te zijn voor:
- ❌ Backend deployment (kan lokaal draaien)
- ❌ Flutter web hosting (kan via `flutter run` lokaal)
- ❌ Domain name
- ❌ SSL certificaat

### Je HEBT WEL nodig:
- ✅ Firebase project (gratis, cloud-based)
- ✅ Internet verbinding (voor Firebase communicatie)
- ✅ google-services.json en VAPID key
- ✅ firebase-service-account.json

## 🤖 Gemini Prompt voor Hulp

```
Ik ben een Flutter developer en werk aan een mafia game. Ik moet Firebase Cloud Messaging (FCM) push notifications toevoegen voor friend requests. Ik heb al de volgende code klaar:

BACKEND:
- NotificationService class met Firebase Admin SDK
- /notifications/register-token endpoint
- player_devices database tabel
- Integratie in friendService

FLUTTER:
- NotificationService class met FCM initialisatie
- Firebase dependencies: firebase_core, firebase_messaging, flutter_local_notifications
- Token registratie met backend

WAT IK NOG MOET DOEN:
1. Firebase project aanmaken
2. Service account JSON downloaden en plaatsen
3. Android app registreren en google-services.json downloaden
4. Web app registreren en VAPID key krijgen
5. FlutterFire CLI configureren
6. Firebase initialiseren in main.dart
7. NotificationService starten na login
8. Firebase Admin initialiseren in backend

Kun je mij stap voor stap begeleiden door:
- Het aanmaken van het Firebase project
- Het correct plaatsen van alle config files
- Het updaten van de code met de juiste keys
- Het testen of alles werkt

Ik werk lokaal met:
- Backend: Node.js op localhost:3000
- Frontend: Flutter web op Chrome via `flutter run`
- Database: MariaDB

Belangrijke vragen:
1. Hoe krijg ik de VAPID key voor web push?
2. Where exactly moet ik de service account JSON plaatsen?
3. Hoe test ik of Firebase Admin SDK correct geïnitialiseerd is?
4. Wat moet ik zien in de console als het werkt?
```

## ❓ Veelgestelde Vragen

### Kan ik dit lokaal testen?
**Ja!** Firebase werkt prima met localhost. Je backend kan op `localhost:3000` draaien en toch Firebase gebruiken.

### Moet mijn app online staan?
**Nee!** Je kunt ontwikkelen en testen met `flutter run` en `node dist/index.js` lokaal.

### Kosten Firebase notificaties geld?
**Nee!** Firebase Cloud Messaging is gratis voor onbeperkte notificaties.

### Werken web notificaties in alle browsers?
Chrome, Firefox, Edge: **Ja**  
Safari: **Beperkt** (iOS Safari ondersteunt geen web push)

### Wat als Firebase Admin niet initialiseert?
Check dat:
- `firebase-service-account.json` in backend folder staat
- JSON bestand juiste Firebase project is
- `npm install firebase-admin` is uitgevoerd
- Path in code correct is: `path.join(__dirname, '../firebase-service-account.json')`

### Hoe weet ik of het werkt?
Je zou moeten zien:
```
Backend logs:
[NotificationService] Firebase Admin SDK initialized
[Notifications] Registered web device for player 2
[NotificationService] Sent notification to player 2: 1 succeeded

Browser console:
✅ Push notifications initialized
FCM Token: eAbCd123...

Database:
SELECT * FROM player_devices; -- Should show your token
```

## 📞 Hulp Nodig?

1. **Firebase Console Issues**: https://firebase.google.com/support
2. **FlutterFire Docs**: https://firebase.flutter.dev/
3. **FCM Docs**: https://firebase.google.com/docs/cloud-messaging

## ⏱️ Geschatte Tijd
- Eerste keer setup: **~1 uur**
- Volgende keer (met ervaring): **~20 minuten**
- Alleen testen (als al geconfigureerd): **~5 minuten**

**Start met Stap 1 en werk je door de lijst!** Veel succes! 🚀
