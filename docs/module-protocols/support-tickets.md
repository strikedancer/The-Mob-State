# Support Tickets Protocol

## Scope
Player support intake, admin ticket handling, reply loop, todo tracking and push follow-up.

## Primary Frontend Entries
- client/lib/screens/help_screen.dart
- client/lib/screens/support_tickets_screen.dart
- admin/src/App.tsx (tickets tab)

## Primary Backend Entries
- backend/src/routes/tickets.ts
- backend/src/routes/admin.ts (admin ticket endpoints)
- backend/src/services/supportTicketService.ts
- backend/src/services/notificationService.ts

## Change Rules
- Keep the full round-trip intact: player report -> admin reply -> player push/support badge -> player follow-up in the Support screen.
- Support replies must stay inside the Support screen itself and may not create player inbox/direct-message entries.
- Keep ticket + todo state recoverable after refresh and navigation.
- The Support screen remains the canonical player reply surface; push and the Support badge are notifications, not separate conversation surfaces.
- Dashboard Support badge must reflect unseen player-relevant ticket activity since the last Support visit, including public admin replies and admin-driven status changes.
- Archived tickets must disappear from the player Support overview and detail flow; closed tickets automatically move to archived after 3 days.
- Tickets may only move to resolved, closed or archived after every linked support todo is done.

## Data Contract Requirements
- Ticket create payload must include: category, subject, message, plus optional sourceModule, referenceCode, clientPlatform and appLocale.
- Ticket summary payload must include: status, priority, assignedAdminId or assignedAdminUsername, updatedAt, ageHours and lastMessageBy.
- Ticket detail payload must include: messages, todos, attachments and all admin workflow metadata needed for triage.
- Todo payload must support: status, priority, assignedAdminId, dueAt, moduleKey and comment history.
- Public admin replies must write to ticket history and may trigger a player push notification, but must never create a player inbox/direct-message entry; internal notes must stay admin-only.

## Admin Workflow Requirements
- Use the richer lifecycle consistently: new, triage, in_progress, waiting_player, blocked, resolved, closed, archived.
- Assignment, priority and archive actions must be editable without losing ticket history.
- Admins must be able to save assignment, priority and status changes without being forced to send an extra public reply.
- Reply templates must stay language-aware and may only auto-message players on public replies.
- Ticket-linked todos and global support todos must use the same status and priority semantics.
- Unfinished linked todos must block terminal ticket statuses in both admin reply flow and ticket settings flow.
- Todo comments are internal operational notes and must never leak into player-facing flows.

## i18n and Messaging
- All player-facing copy in ticket create/reply flow must be NL + EN.
- Support push notification wording must be language-aware by player preference.
- Keep status labels clear and consistent across player and admin UI.
- Category label `supportCategoryBug` must stay the software term **Bug** (do not machine-translate as insect: NL Beestje / DE Insekt / IT Insetto).

## Push + Inbox Rules
- Public admin reply should never create an inbox/direct-message entry for the player.
- Push notification should be sent through the existing notification service pipeline.
- Internal notes must not create player-facing push traffic.
- Do not block ticket reply flow if push dispatch fails.

## QA Checklist
- Player creates ticket successfully (bug/question/feedback/other).
- Player can include optional module context, reference code and screenshot.
- Player sees existing tickets in Support and can reopen a thread after refresh/navigation.
- Support menu badge appears after a new admin reply or ticket status change and clears after the player opens Support.
- Admin sees ticket, triage metadata, attachments, assignee and priority.
- Admin can post both public replies and internal notes.
- Player receives public admin replies directly in the Support thread without a new inbox message; push remains optional notification only.
- Player can post follow-up reply in ticket thread.
- Admin can add todo item, assign it, set priority and due date, add internal todo comments and mark todo done or open.
- Ticket status transitions and archive state reflect correctly in admin while player UX stays minimal.
- Closing a ticket without a new reply, archiving it later, and auto-archiving after 3 days must all persist correctly after refresh.
- Ticket close/archive attempts with linked open todos must be blocked with clear admin feedback.

## When To Update This File
Update when ticket status model changes, todo workflow changes, inbox/push coupling changes, or new participant roles are added.
