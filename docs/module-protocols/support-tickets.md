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
- Keep the full round-trip intact: player report -> admin reply -> player inbox + push -> player follow-up in the Support screen.
- Never break existing direct-message inbox behavior while extending support messaging.
- Keep ticket + todo state recoverable after refresh and navigation.
- The Support screen remains the canonical player reply surface; inbox and push are notifications, not the only place where the conversation can continue.
- Dashboard Support badge must reflect unseen player-relevant ticket activity since the last Support visit, including public admin replies and admin-driven status changes.

## Data Contract Requirements
- Ticket create payload must include: category, subject, message, plus optional sourceModule, referenceCode, clientPlatform and appLocale.
- Ticket summary payload must include: status, priority, assignedAdminId or assignedAdminUsername, updatedAt, ageHours and lastMessageBy.
- Ticket detail payload must include: messages, todos, attachments and all admin workflow metadata needed for triage.
- Todo payload must support: status, priority, assignedAdminId, dueAt, moduleKey and comment history.
- Public admin replies must write to ticket history and trigger a player inbox message; internal notes must stay admin-only.

## Admin Workflow Requirements
- Use the richer lifecycle consistently: new, triage, in_progress, waiting_player, blocked, resolved, closed, archived.
- Assignment, priority and archive actions must be editable without losing ticket history.
- Reply templates must stay language-aware and may only auto-message players on public replies.
- Ticket-linked todos and global support todos must use the same status and priority semantics.
- Todo comments are internal operational notes and must never leak into player-facing flows.

## i18n and Messaging
- All player-facing copy in ticket create/reply flow must be NL + EN.
- Admin reply wording in inbox notifications must be language-aware by player preference.
- Keep status labels clear and consistent across player and admin UI.

## Push + Inbox Rules
- Public admin reply should always create an inbox message for the player.
- Push notification should be sent through existing notification service pipeline.
- Internal notes must not create player inbox or push traffic.
- Do not block ticket reply flow if push dispatch fails.

## QA Checklist
- Player creates ticket successfully (bug/question/feedback/other).
- Player can include optional module context, reference code and screenshot.
- Player sees existing tickets in Support and can reopen a thread after refresh/navigation.
- Support menu badge appears after a new admin reply or ticket status change and clears after the player opens Support.
- Admin sees ticket, triage metadata, attachments, assignee and priority.
- Admin can post both public replies and internal notes.
- Player receives public admin reply in inbox and push notification.
- Player can post follow-up reply in ticket thread.
- Admin can add todo item, assign it, set priority and due date, add internal todo comments and mark todo done or open.
- Ticket status transitions and archive state reflect correctly in admin while player UX stays minimal.

## When To Update This File
Update when ticket status model changes, todo workflow changes, inbox/push coupling changes, or new participant roles are added.
