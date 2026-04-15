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
- Push dispatch failures mogen hoofdflows niet rollbacken.

## Backend Guardrails
- Voor cooldown-expiry meldingen: voeg nieuwe cooldown-actions toe in zowel `notificationService.sendCooldownExpiredNotification(...)` als de notifier-registratie in `cooldownService` of een gelijkwaardige scheduler.
- Bankoverschrijvingen sturen altijd een pushmelding naar de ontvanger via de bestaande notification pipeline en blijven fire-and-forget.
- Web-only notificaties gebruiken een data-only payload; native clients mogen het `notification` veld blijven gebruiken als dat nodig is.

## Frontend Guardrails
- Settings moet een expliciete action bevatten die browser/iOS permission requests via user gesture kan starten.
- Service worker fallbacktekst moet `payload.data` kunnen lezen als `payload.notification` ontbreekt.
- Bij app-refresh, PWA-herstart of nieuwe client-build moet een eerder toegestane push-permissie automatisch opnieuw aan het actuele FCM token worden gekoppeld; de speler mag push niet handmatig opnieuw hoeven inschakelen na elke deploy of page refresh.

## QA Checklist
1. Verifieer permissie-aanvraag vanaf Settings op web/PWA.
2. Verifieer dat web geen dubbele notificaties toont voor dezelfde FCM payload.
3. Verifieer dat Safari/iOS PWA niet terugvalt op generieke notification copy.
4. Verifieer dat cooldown-expiry notificaties voor ondersteunde actions nog steeds aankomen.
5. Verifieer dat pushfouten hoofdflows niet blokkeren.

## When To Update This File
Update bij nieuwe notificatiekanalen, FCM/service-worker gedrag, permission flows, cooldown-signalen of inbox/push koppelingen.