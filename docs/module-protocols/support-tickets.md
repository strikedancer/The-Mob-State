# Support Tickets Protocol

## Scope
Player support intake, admin ticket handling, reply loop, todo tracking and inbox/push follow-up.

## Primary Frontend Entries
- client/lib/screens/help_screen.dart
- client/lib/screens/support_tickets_screen.dart
- admin/src/App.tsx (tickets tab)

## Primary Backend Entries
- backend/src/routes/tickets.ts
- backend/src/routes/admin.ts (admin ticket endpoints)
- backend/src/services/supportTicketService.ts
- backend/src/services/directMessageService.ts
- backend/src/services/notificationService.ts

## Change Rules
- Keep the full round-trip intact: player report -> admin reply -> player inbox + push -> player follow-up.
- Never break existing direct-message inbox behavior while extending support messaging.
- Keep ticket + todo state recoverable after refresh and navigation.

## Data Contract Requirements
- Ticket payload must include: category, subject, status, updatedAt.
- Ticket detail payload must include: messages and todos.
- Admin replies must write to ticket history and trigger a player inbox message.

## i18n and Messaging
- All player-facing copy in ticket create/reply flow must be NL + EN.
- Admin reply wording in inbox notifications must be language-aware by player preference.
- Keep status labels clear and consistent across player and admin UI.

## Push + Inbox Rules
- Admin reply should always create an inbox message for the player.
- Push notification should be sent through existing notification service pipeline.
- Do not block ticket reply flow if push dispatch fails.

## QA Checklist
- Player creates ticket successfully (bug/question/feedback/other).
- Admin sees ticket and can reply.
- Player receives admin reply in inbox and push notification.
- Player can post follow-up reply in ticket thread.
- Admin can add todo item and mark todo done/open.
- Ticket status transitions reflect correctly in both UIs.

## When To Update This File
Update when ticket status model changes, todo workflow changes, inbox/push coupling changes, or new participant roles are added.
