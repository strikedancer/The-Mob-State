# Plesk Batch Deploy Runbook (Mafia Game)

Deze runbook is voor jullie setup: zelfde domein/login, maar verschillende mappen voor game, admin en API.

## Belangrijk verschil

- **Admin + Client**: upload van build-output is meestal genoeg.
- **Backend/API**: upload van bronbestanden is **niet** genoeg; op server moet je nog build + restart doen.

## Voorbereiding (lokaal)

1. Build backend check:
	- In `backend` run: `npm run build`
2. Build admin:
	- In `admin` run: `set VITE_ADMIN_API_URL=https://api.themobstate.com && npm run build`
	- PowerShell variant: `$env:VITE_ADMIN_API_URL="https://api.themobstate.com"; npm run build`
3. Build client:
	- In `client` run: `flutter build web --release --dart-define=WEB_API_BASE_URL=https://api.themobstate.com`

## Upload via Plesk/FTP/SFTP

Gebruik 3 remote paden (zelfde host/login, andere map):

- **Client live map** (game website document root)
  - Upload inhoud van `client/build/web/`
- **Admin live map** (admin document root)
  - Upload inhoud van `admin/dist/`
- **Backend app map** (Node.js app root in Plesk)
  - Upload gewijzigde backend bestanden (src/content/config/package files)

## Backend live maken in Plesk

In Plesk -> domain -> **Node.js** (of Terminal in de backend map):

1. Dependencies updaten:
	- `npm install` (of `npm ci` als lockfile en workflow dat toelaten)
2. Build draaien:
	- `npm run build`
3. Prisma deploy (alleen als schema/migrations zijn gewijzigd):
	- `npx prisma migrate deploy`
4. Node app herstarten:
	- Plesk Node.js: **Restart App**

## Aanbevolen deploy-volgorde

1. Backend upload + `npm install` + `npm run build` + restart
2. Admin build upload
3. Client build upload
4. Hard refresh browser (cache/service worker)

## Snelle smoke tests na deploy

- Job uitvoeren: geen 500 errors meer
- Admin login werkt
- Admin -> System Logs toont entries
- Admin -> Admins tab toont accounts en kan create/update uitvoeren
- Register/login verificatieflow werkt (email confirm)

## Veelgemaakte fout

Alleen frontend builds uploaden en denken dat backend features live zijn.

Nieuwe API routes (zoals admin system logs/admin management) worden pas actief ná backend build + restart.

