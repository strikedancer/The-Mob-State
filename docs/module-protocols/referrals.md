# Referrals (share link)

## Scope
Personal invite URLs from **Friends → Deel link**. A recruit who registers with `?ref=` gets starter cash and an accepted friendship. The referrer is paid after the recruit’s first successful crime or job. No Facebook friend-list import.

## Primary Frontend Entry
- `client/lib/screens/friends_screen.dart` — share / copy / Facebook sharer
- `client/lib/utils/referral_invite_store.dart` — keeps `ref` across landing, login and OAuth return
- `client/lib/screens/login_screen.dart` + `client/lib/main.dart` — capture `?ref=`
- Auth register / Facebook complete / Google complete send `referralCode`

## Primary Backend Entry
- `GET /friends/invite` — `{ code, url, referrerCash, recruitCash, dailyCap, rewardedToday, qualifiedCount }`
- `referralService.attachOnRegister` on password + Facebook + Google new accounts
- `referralService.qualifyFromGameplay` after a successful crime or job
- Services: `backend/src/services/referralService.ts`

## Change Rules
- Pay cash only, never premium credits.
- Do not reward a share click. Reward a new account + first successful crime/job.
- Self-referral is ignored (`referralCode` of the same player).
- Daily referrer payout cap (`REFERRAL_DAILY_CAP`, default 5). Overflow waits for the next UTC day.
- Auto-friend only for this invite pair, not for Facebook graph matches.
- Keep NL/EN player copy in sync. Inbox notices follow the player language (NL or EN fallback).

## Cross-Module Dependencies
- Friends → invite UI, auto-accepted friendship
- Auth / Facebook / Google → `referralCode` on new accounts only
- Crimes / Jobs → qualify hook
- Messages → system inbox + optional push to the referrer
- Dashboard → cash HUD updates after payout
- Balance & Economy → runtime cash amounts and daily cap
- Marketing web → `/register?ref=` must stay a Flutter deep link

## Must Preserve
- Register still succeeds if the referral attach fails
- Existing friend request / block flows stay unchanged
- Hidden inbox rules stay per-player; invite notices are new system rows

## Runtime Keys
- `REFERRAL_REFERRER_CASH` (default 5000)
- `REFERRAL_RECRUIT_CASH` (default 2000)
- `REFERRAL_DAILY_CAP` (default 5)

## QA Checklist
1. Friends → Deel link shows URL, copy, share, Facebook sharer
2. Open `/register?ref=CODE` (or landing `?ref=`), register → recruit cash + friend
3. Password, Facebook complete and Google complete all keep the stored code
4. First successful crime or job pays the referrer once; second action does not
5. Own code does not attach; invalid code is ignored
6. Sixth qualified recruit in one UTC day waits until the next day
7. Help & Uitleg Friends mentions the share link

## i18n and Messaging
Player ARB prefix `friendsInvite*`. Help keys `helpTopicFriendsHow` / `helpTopicFriendsTips`.

## When To Update This File
Update when payout rules, qualify actions, or share surfaces change.
