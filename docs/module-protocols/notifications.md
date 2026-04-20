# Notifications Protocol

## Scope
Pushnotificaties, inbox-signalen, web/native FCM gedrag, permission entrypoints en cooldown-/event-notificaties.

## Primary Frontend Entry
- client/lib/services/notification_service.dart
- client/lib/screens/settings_screen.dart
- client/web/firebase-messaging-sw.js

## Primary Backend Entry
- backend/src/services/notificationService.ts
- backend/src/services/cooldownService.ts

## Change Rules
- Push en inbox-signalen mogen primaire gameplayflows nooit blokkeren.
- Platformgedrag voor web, PWA en native moet expliciet zijn; vertrouw niet op implicit defaults.
- Nieuwe notificatietypes moeten zowel dispatch als client-rendering volledig meenemen.

## Cross-Module Dependencies
- Settings -> Notifications (permission entrypoint)
- Messages/Support/Bank/Crypto -> Notifications (player-facing signalering)
- Cooldown-gedreven modules -> Notifications (expiry meldingen)

## Must Preserve
- Expliciete in-app permissie-entrypoint voor web/iOS homescreen push, doorgaans via Settings.
- Web FCM berichten voor web-tokens blijven data-only om dubbele notificaties te voorkomen.
- Safari/iOS PWA moet `payload.data.title/body` fallback houden wanneer `payload.notification` ontbreekt.
- `firebase-messaging-sw.js` moet als update-kritieke service worker altijd met `no-cache, no-store, must-revalidate` worden geserveerd; een nieuwe deploy mag nooit op een oude push-service-worker blijven hangen.
- Push dispatch failures mogen hoofdflows niet rollbacken.

## Backend Guardrails
- Voor cooldown-expiry meldingen: voeg nieuwe cooldown-actions toe in zowel `notificationService.sendCooldownExpiredNotification(...)` als de notifier-registratie in `cooldownService` of een gelijkwaardige scheduler.
- Cooldown-expiry push voor crimes, jobs en vehicle/boat theft mag nooit alleen op in-memory `setTimeout` vertrouwen; de effectieve cooldownduur en notificatiestatus moeten persistent reconstrueerbaar zijn zodat backend restarts, deploys of container-restarts geen expiry-pushes verliezen.
- Admin moet een handmatige, auditeerbare test-push naar een specifieke speler kunnen sturen voor live QA; zo'n testactie moet device-count terugkoppelen zodat deliveryproblemen onderscheidbaar blijven van ontbrekende tokenregistratie.
- Push-delivery fouten, ontbrekende device-registraties en admin test-push diagnosepaden moeten ook in het bestaande Admin > System Logs scherm landen met voldoende context (`source`, playerId, device-count, FCM error codes); console-only logging is onvoldoende voor live QA.
- Firebase Admin bootstrap mag productie niet alleen van een lokaal bestandspad laten afhangen; de backend moet runtime credentials kunnen lezen via env payload (`FIREBASE_SERVICE_ACCOUNT_JSON` / `FIREBASE_SERVICE_ACCOUNT_BASE64` of split env vars) met bestandspad alleen als fallback, anders vallen live pushes stil uit na container builds zonder ge-mount service-accountbestand.
- Bankoverschrijvingen sturen altijd een pushmelding naar de ontvanger via de bestaande notification pipeline en blijven fire-and-forget.
- Web-only notificaties gebruiken een data-only payload; native clients mogen het `notification` veld blijven gebruiken als dat nodig is.
- Arrestatie-alerts voor vrienden of crewleden moeten via dezelfde fire-and-forget pipeline lopen, ontvangers dedupliceren als iemand zowel vriend als crewlid is, en mogen arrest-/jailflows nooit rollbacken.

## Frontend Guardrails
- Settings moet een expliciete action bevatten die browser/iOS permission requests via user gesture kan starten.
- Service worker fallbacktekst moet `payload.data` kunnen lezen als `payload.notification` ontbreekt.
- Bij app-refresh, PWA-herstart of nieuwe client-build moet een eerder toegestane push-permissie automatisch opnieuw aan het actuele FCM token worden gekoppeld; de speler mag push niet handmatig opnieuw hoeven inschakelen na elke deploy of page refresh.
- Token-registratie moet idempotent zijn: hernieuwde register-calls moeten dezelfde token kunnen verversen en oude tokens voor dezelfde speler/platform mogen niet blijven domineren.
- Web push mag niet alleen op de service worker vertrouwen: als de gamewebapp actief of gefocust is, moet de foreground-web path dezelfde `payload.data.title/body` kunnen tonen en moet de app bij resume of terugkeer naar foreground zijn geautoriseerde pushsessie opnieuw kunnen syncen om stale tokens weg te werken.

## QA Checklist
1. Verifieer permissie-aanvraag vanaf Settings op web/PWA.
2. Verifieer dat web geen dubbele notificaties toont voor dezelfde FCM payload.
3. Verifieer dat Safari/iOS PWA niet terugvalt op generieke notification copy.
4. Verifieer na refresh of nieuwe deploy dat zowel `flutter_service_worker.js` als `firebase-messaging-sw.js` nieuwe headers/scriptinhoud oppakken en dat een eerder geautoriseerde web/PWA sessie zichzelf zonder handmatige re-enable opnieuw registreert.
5. Verifieer dat cooldown-expiry notificaties voor ondersteunde actions nog steeds aankomen.
6. Verifieer expliciet dat een cooldown-expiry push nog steeds aankomt na een backend restart terwijl de cooldown al liep.
7. Verifieer dat een admin test-push naar een gekozen speler succesvol queued en dat de UI het aantal geregistreerde devices teruggeeft.
8. Verifieer op web zowel een background/service-worker push als een foreground/in-focus push; beide moeten zichtbaar zijn met de verwachte titel/body.
9. Verifieer bij mislukte test-pushes of ontbrekende devices dat Admin > System Logs een bruikbare foutregel met pushcontext toont.
10. Verifieer dat pushfouten hoofdflows niet blokkeren.
11. Verifieer dat arrestaties van een speler precies de relevante vrienden en crewleden signaleren, zonder dubbele push voor overlap-ontvangers.

## When To Update This File
Update bij nieuwe notificatiekanalen, FCM/service-worker gedrag, permission flows, cooldown-signalen of inbox/push koppelingen.