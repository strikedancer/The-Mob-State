# Deployment Guide

This guide covers deploying the Mafia Game to a Linux VPS (Strato) using Docker.

## Plesk Secrets (Required)

Gebruik voor `docker-compose.plesk.yml` een server-side `.env.plesk` bestand dat niet in git staat.

Eenmalig op de server:

```bash
cp .env.plesk.example .env.plesk
nano .env.plesk
```

Zet production secrets zoals `MYSQL_PASSWORD`, `JWT_SECRET`, `LEONARDO_API_KEY` en `FIREBASE_SERVICE_ACCOUNT_BASE64` in `.env.plesk`, niet inline in `docker-compose.plesk.yml`.

Gebruik Plesk compose commands daarna consequent zo:

```bash
docker compose --env-file .env.plesk -f docker-compose.plesk.yml up -d --build backend
docker compose --env-file .env.plesk -f docker-compose.plesk.yml logs -f backend
```

Doel:
- secrets blijven server-side persistent staan;
- `git pull` overschrijft geen noodpatches meer in `docker-compose.plesk.yml`;
- Firebase/Mollie/Leonardo blijven actief na volgende deploys.

## iOS PWA Update Consistency (Required)

Voor iPhone users die de webapp op het beginscherm installeren, moet de client-nginx cache-policy strikt gescheiden zijn:

- App shell / update-critical bestanden: `index.html`, `manifest.json`, `flutter_bootstrap.js`, `flutter_service_worker.js`, `firebase-messaging-sw.js`, `main.dart.js`, `version.json`, `AssetManifest.json`, `FontManifest.json`
  - Header: `Cache-Control: no-cache, must-revalidate` (voor `flutter_service_worker.js` en `firebase-messaging-sw.js`: `no-cache, no-store, must-revalidate`).
- Gehashte/static assets onder `assets/` en image-routes mogen `public, immutable` houden.

Doel:
- Nieuwe release wordt door homescreen-app opgehaald zonder app te verwijderen en opnieuw toe te voegen.

Post-deploy verificatie:

```bash
curl -I https://your-domain/index.html
curl -I https://your-domain/flutter_bootstrap.js
curl -I https://your-domain/flutter_service_worker.js
curl -I https://your-domain/firebase-messaging-sw.js
curl -I https://your-domain/main.dart.js
```

Controleer dat bovenstaande bestanden `no-cache`/`must-revalidate` headers hebben.

Zelfherstellende build-update:

- De web shell controleert nu zelf op een gewijzigde build-fingerprint op basis van `version.json`, `flutter_bootstrap.js`, `main.dart.js`, `flutter_service_worker.js` en `firebase-messaging-sw.js`.
- Bij een echte buildwissel wist de client precies één keer de runtime web caches (`CacheStorage`) en unregistert hij actieve service workers voordat de app hard herlaadt.
- Dit is bedoeld om iPhone/mobile PWA sessies sneller naar een nieuwe build te trekken zonder dat spelers handmatig DevTools hoeven te openen.

## Runtime External Images (No Rebuild For Image Updates)

Doel:
- Gameplay afbeeldingen buiten de client build houden.
- Nieuwe/gewijzigde images uploaden zonder `docker compose ... --build`.

Implementatie in deze repo:
- `docker-compose.plesk.yml` mount externe map in client container op `/mnt/external-images`.
- `client/docker/nginx.conf` route `/images/*` probeert eerst `/mnt/external-images/*`, daarna bundled fallback `/usr/share/nginx/html/assets/assets/images/*`.

### Eenmalig online instellen

```bash
cd /var/www/vhosts/themobstate.com/apps/mafia_game
mkdir -p runtime/client-images
```

Belangrijk:
- Dit geldt voor **alle** afbeeldingen onder `client/assets/images/**`.
- Je hoeft dus niet alleen `backgrounds/avatars/crimes` te gebruiken; de volledige subfolderstructuur wordt ondersteund.

Controleer of `CLIENT_EXTERNAL_IMAGES_PATH` gewenst is in `.env` (optioneel):

```env
CLIENT_EXTERNAL_IMAGES_PATH=/var/www/vhosts/themobstate.com/apps/mafia_game/runtime/client-images
```

Daarna 1x deploy/rebuild zodat volume + nginx-regels actief zijn:

```bash
git pull origin main
docker compose -f docker-compose.plesk.yml up -d --build client
```

Optioneel maar aanbevolen: mirror alle huidige repo-images direct naar runtime map

```bash
rsync -av --delete client/assets/images/ runtime/client-images/
```

Als `rsync` niet beschikbaar is:

```bash
cp -a client/assets/images/. runtime/client-images/
```

### Vanaf nu images updaten zonder rebuild

1. Upload files naar runtime map (voorbeeld):

```bash
cp /tmp/login_background.png /var/www/vhosts/themobstate.com/apps/mafia_game/runtime/client-images/backgrounds/login_background.png
```

Volledige update van alle images in 1x (zonder rebuild):

```bash
cd /var/www/vhosts/themobstate.com/apps/mafia_game
rsync -av --delete client/assets/images/ runtime/client-images/
```

2. Test direct via browser URL:

```bash
curl -I https://jouwdomein/images/backgrounds/login_background.png
```

3. Eventueel client hard refresh (service worker cache kan oud bestand tonen).

### Belangrijke cache-regel

- Voor images die je soms overschrijft met dezelfde bestandsnaam: gebruik bij voorkeur versie-bestandsnamen, bv `login_background.v2.png`.
- Voor nieuwe assets: update alleen de bestandsreferentie in app-code als de bestandsnaam verandert.

Route-gedrag:
- `/images/*` -> extern-first fallback
- `/assets/assets/images/*` (Flutter `Image.asset` runtime pad) -> extern-first fallback

Hierdoor geldt de externe image-opslag ook voor schermen die nog directe `Image.asset(...)` gebruiken.

### Wanneer nog wel rebuild nodig is

- Codewijziging in Flutter/TS/Node.
- Nginx/config wijziging.
- Nieuwe route of helperlogica.

Alleen image-bestanden in runtime map wijzigen vereist geen rebuild.

---

## Architecture Overview

```
[Internet] → [Nginx] → [Backend API (Node.js)]
                    ↓
                [Client (Flutter Web)]
                [Admin (Web Dashboard)]
                    ↓
              [MariaDB]
              [Redis (optional)]
```

---

## Environment Variables

### Backend (.env.production)

Create `backend/.env.production` (do NOT commit to git):

```env
NODE_ENV=production
PORT=3000
DATABASE_URL="mysql://mafia_user:STRONG_PASSWORD@mariadb:3306/mafia_game"
REDIS_URL="redis://redis:6379"

# JWT
JWT_SECRET="GENERATE_STRONG_SECRET_HERE"
JWT_EXPIRES_IN="7d"

# CORS
ALLOWED_ORIGINS="https://yourdomain.com,https://admin.yourdomain.com"

# Game Config
TICK_INTERVAL_MINUTES=5
POLICE_RATIO=10
MAX_FLIGHTS_PER_DAY=100

# Optional: Email/SMS for notifications
SMTP_HOST=""
SMTP_PORT=""
SMTP_USER=""
SMTP_PASS=""
```

### Client (Flutter Web)

Create `client/.env.production`:

```env
API_BASE_URL=https://yourdomain.com/api
WS_URL=wss://yourdomain.com/ws
```

### Admin Dashboard

Create `admin/.env.production`:

```env
VITE_API_BASE_URL=https://yourdomain.com/api
```

---

## Dockerfiles

### Backend Dockerfile

`backend/Dockerfile`:

```dockerfile
# Build stage
FROM node:20-alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN npm ci --only=production

COPY . .
RUN npm run build

# Production stage
FROM node:20-alpine

WORKDIR /app

# Copy node_modules from builder
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/package.json ./
COPY prisma ./prisma
COPY content ./content

# Generate Prisma Client
RUN npx prisma generate

EXPOSE 3000

CMD ["npm", "start"]
```

### Client Dockerfile (Flutter Web)

`client/Dockerfile`:

```dockerfile
# Build stage
FROM debian:latest AS builder

RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa \
    && rm -rf /var/lib/apt/lists/*

# Install Flutter
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"
RUN flutter doctor -v
RUN flutter channel stable
RUN flutter upgrade

WORKDIR /app
COPY . .

# Get dependencies and build
RUN flutter pub get
RUN flutter build web --release --web-renderer canvaskit

# Production stage - serve with nginx
FROM nginx:alpine

COPY --from=builder /app/build/web /usr/share/nginx/html
COPY nginx/client.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
```

`nginx/client.conf`:

```nginx
server {
    listen 80;
    server_name localhost;
    
    root /usr/share/nginx/html;
    index index.html;
    
    # Flutter web routing
    location / {
        try_files $uri $uri/ /index.html;
    }
    
    # Cache static assets
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}
```

### Admin Dockerfile

`admin/Dockerfile`:

```dockerfile
# Build stage
FROM node:20-alpine AS builder

WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Production stage
FROM nginx:alpine

COPY --from=builder /app/dist /usr/share/nginx/html
COPY nginx/admin.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
```

---

## Docker Compose Files

### Development (docker-compose.dev.yml)

```yaml
version: '3.8'

services:
  mariadb:
    image: mariadb:11
    environment:
      MYSQL_ROOT_PASSWORD: root
      MYSQL_DATABASE: mafia_game
      MYSQL_USER: mafia_user
      MYSQL_PASSWORD: dev_password
    ports:
      - "3306:3306"
    volumes:
      - mariadb_data:/var/lib/mysql

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"

  backend:
    build:
      context: ./backend
      dockerfile: Dockerfile
    ports:
      - "3000:3000"
    volumes:
      - ./backend/src:/app/src
      - ./backend/content:/app/content
    environment:
      NODE_ENV: development
      DATABASE_URL: mysql://mafia_user:dev_password@mariadb:3306/mafia_game
      REDIS_URL: redis://redis:6379
      JWT_SECRET: dev_secret_change_in_production
    depends_on:
      - mariadb
      - redis
    command: npm run dev

volumes:
  mariadb_data:
```

Run dev environment:
```powershell
docker-compose -f docker-compose.dev.yml up
```

---

### Production (docker-compose.prod.yml)

```yaml
version: '3.8'

services:
  mariadb:
    image: mariadb:11
    environment:
      MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
      MYSQL_DATABASE: mafia_game
      MYSQL_USER: mafia_user
      MYSQL_PASSWORD: ${MYSQL_PASSWORD}
    volumes:
      - mariadb_data:/var/lib/mysql
    restart: unless-stopped
    networks:
      - backend

  redis:
    image: redis:7-alpine
    restart: unless-stopped
    networks:
      - backend

  backend:
    build:
      context: ./backend
      dockerfile: Dockerfile
    environment:
      NODE_ENV: production
      DATABASE_URL: mysql://mafia_user:${MYSQL_PASSWORD}@mariadb:3306/mafia_game
      REDIS_URL: redis://redis:6379
      JWT_SECRET: ${JWT_SECRET}
      ALLOWED_ORIGINS: ${ALLOWED_ORIGINS}
    depends_on:
      - mariadb
      - redis
    restart: unless-stopped
    networks:
      - backend

  client:
    build:
      context: ./client
      dockerfile: Dockerfile
    restart: unless-stopped
    networks:
      - frontend

  admin:
    build:
      context: ./admin
      dockerfile: Dockerfile
    restart: unless-stopped
    networks:
      - frontend

  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx/nginx.conf:/etc/nginx/nginx.conf
      - ./nginx/ssl:/etc/nginx/ssl
    depends_on:
      - backend
      - client
      - admin
    restart: unless-stopped
    networks:
      - frontend
      - backend

volumes:
  mariadb_data:

networks:
  frontend:
  backend:
```

---

### Nginx Configuration (nginx/nginx.conf)

```nginx
events {
    worker_connections 1024;
}

http {
    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    # Rate limiting
    limit_req_zone $binary_remote_addr zone=api_limit:10m rate=10r/s;

    upstream backend {
        server backend:3000;
    }

    upstream client {
        server client:80;
    }

    upstream admin {
        server admin:80;
    }

    # Redirect HTTP to HTTPS
    server {
        listen 80;
        server_name yourdomain.com admin.yourdomain.com;
        return 301 https://$host$request_uri;
    }

    # Main client (Flutter web)
    server {
        listen 443 ssl http2;
        server_name yourdomain.com;

        ssl_certificate /etc/nginx/ssl/cert.pem;
        ssl_certificate_key /etc/nginx/ssl/key.pem;

        # API proxy
        location /api/ {
            limit_req zone=api_limit burst=20 nodelay;
            
            proxy_pass http://backend/;
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection 'upgrade';
            proxy_set_header Host $host;
            proxy_cache_bypass $http_upgrade;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        }

        # SSE endpoint (longer timeout)
        location /api/events/stream {
            proxy_pass http://backend/events/stream;
            proxy_http_version 1.1;
            proxy_set_header Connection '';
            proxy_buffering off;
            proxy_cache off;
            proxy_read_timeout 24h;
        }

        # Flutter web client
        location / {
            proxy_pass http://client/;
            proxy_set_header Host $host;
        }
    }

    # Admin dashboard
    server {
        listen 443 ssl http2;
        server_name admin.yourdomain.com;

        ssl_certificate /etc/nginx/ssl/cert.pem;
        ssl_certificate_key /etc/nginx/ssl/key.pem;

        # API proxy (same as client)
        location /api/ {
            limit_req zone=api_limit burst=20 nodelay;
            proxy_pass http://backend/;
            proxy_http_version 1.1;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
        }

        # Admin UI
        location / {
            proxy_pass http://admin/;
            proxy_set_header Host $host;
        }
    }
}
```

---

## Deployment Steps

### 1. Prepare VPS

SSH to your Strato VPS:

```bash
ssh user@your-vps-ip
```

Install Docker and Docker Compose:

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Add user to docker group
sudo usermod -aG docker $USER

# Install Docker Compose
sudo apt install docker-compose-plugin

# Verify
docker --version
docker compose version
```

### 2. Clone Repository

```bash
cd /opt
sudo mkdir mafia_game
sudo chown $USER:$USER mafia_game
cd mafia_game

git clone https://github.com/yourusername/mafia_game.git .
```

### 3. Configure Environment

```bash
# Create production env file
cp backend/.env.example backend/.env.production

# Edit with production values
nano backend/.env.production
```

**IMPORTANT:** Generate strong secrets:

```bash
# Generate JWT secret
openssl rand -base64 32

# Generate MySQL password
openssl rand -base64 24
```

Create `.env` in root for docker-compose:

```bash
nano .env
```

```env
MYSQL_ROOT_PASSWORD=your_root_password
MYSQL_PASSWORD=your_user_password
JWT_SECRET=your_jwt_secret
ALLOWED_ORIGINS=https://yourdomain.com,https://admin.yourdomain.com
```

### 4. SSL Certificates

Get Let's Encrypt certificate:

```bash
sudo apt install certbot

# Get certificate
sudo certbot certonly --standalone -d yourdomain.com -d admin.yourdomain.com

# Copy to nginx folder
sudo mkdir -p nginx/ssl
sudo cp /etc/letsencrypt/live/yourdomain.com/fullchain.pem nginx/ssl/cert.pem
sudo cp /etc/letsencrypt/live/yourdomain.com/privkey.pem nginx/ssl/key.pem
sudo chown -R $USER:$USER nginx/ssl
```

### 5. Build and Run

```bash
# Build images
docker compose -f docker-compose.prod.yml build

# Run database migrations
docker compose -f docker-compose.prod.yml run --rm backend npx prisma migrate deploy

# Start services
docker compose -f docker-compose.prod.yml up -d

# Check logs
docker compose -f docker-compose.prod.yml logs -f
```

### 6. Verify Deployment

```bash
# Check all containers running
docker compose -f docker-compose.prod.yml ps

# Test health endpoint
curl https://yourdomain.com/api/health

# Check nginx serving client
curl https://yourdomain.com/
```

### 7. Configure Firewall

```bash
# Allow HTTP/HTTPS
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

# Allow SSH (if not already)
sudo ufw allow 22/tcp

# Enable firewall
sudo ufw enable

# Check status
sudo ufw status
```

---

## Updates & Maintenance

### Update Application

```bash
cd /opt/mafia_game

# Pull latest code
git pull

# IMPORTANT: hydrate Git LFS tracked assets (images/videos) before build
git lfs install --force
git lfs pull --include="client/assets/**,client/images/**"
git lfs checkout

# Rebuild and restart
docker compose -f docker-compose.prod.yml up -d --build

# Run new migrations if any
docker compose -f docker-compose.prod.yml run --rm backend npx prisma migrate deploy
```

### Post-Deploy Web Cache & Asset Validation (Required)

After each client deploy, validate image serving and clear stale browser state.

```bash
# Verify representative assets respond correctly
curl -I https://yourdomain.com/images/crimes/pickpocket_crime.png
```

---

## Live Testing & Error Monitoring

When testing changes live on production or staging (via `docker-compose.plesk.yml`), always monitor system errors.

### 1. Check Real-Time System Error Logs

During or immediately after live testing, fetch system errors from the admin API:

```bash
# Get last 10 system error logs (requires admin access)
curl -s "https://admin.themobstate.com/api/admin/system-logs?limit=10" \
  -H "Authorization: Bearer YOUR_ADMIN_TOKEN" | jq .
```

**What to look for:**
- `[CRON ERROR]` - Background job failures (e.g., crypto processor)
- `[AUTH] Login/Register error` - Authentication issues
- `[ERROR] 500` - API endpoint crashes
- `PrismaClientKnownRequestError` - Database errors (P2024 = connection limit, P2010 = data validation)
- `Cannot read properties of undefined` - Uninitialized services or missing null-checks

### 2. Critical Runtime Errors & Fixes

| Error Type | Cause | Fix |
|-----------|-------|-----|
| `P2024: Too many connections` | Prisma connection pool exhausted | Increase pool in `DATABASE_URL` query params: `?connection_limit=200&pool_timeout=10` |
| `Cannot read properties of undefined (reading 'findUnique')` | Missing null-check on Prisma client | Add `await waitForPrisma()` in route initialization or middleware |
| `PrismaClientValidationError` | Schema mismatch between code and database | Run `npx prisma generate` and `npx prisma validate` |
| `Out of range value for column` | Numeric overflow in database column | Check field width (decimal/int) and adjust calculation or column type |
| `ZodError: Invalid input` | Request validation failure | Log full request body and Zod error details before returning 500 |

### 3. Enable Debug Logging During Live Testing

Temporarily increase logging in `.env` during testing:

```env
NODE_ENV=production
DEBUG=true  # Add this temporarily
LOG_LEVEL=debug
PRISMA_LOG_LEVEL=debug  # Log all Prisma queries
```

Then restart affected containers:

```bash
docker compose -f docker-compose.plesk.yml restart backend admin
docker compose -f docker-compose.plesk.yml logs -f backend
```

### 4. Quick Health Check During Live Testing

```bash
# Backend alive?
curl -s https://api.themobstate.com/api/health | jq .

# Admin panel responds?
curl -s -I https://admin.themobstate.com/ | head -5

# Client (Flutter web) loads?
curl -s https://themobstate.com/ | head -20

# Database connected?
curl -s https://api.themobstate.com/api/admin/overview | jq '.alerts' 2>/dev/null || echo "Admin endpoint not responding"
```

### 5. Common Testing Workflows

**Testing a single feature (e.g., Crew Wars endpoint):**

```bash
# 1. Make code change locally
# 2. Rebuild and deploy to staging
docker compose -f docker-compose.plesk.yml up -d --build backend

# 3. Monitor logs real-time
docker compose -f docker-compose.plesk.yml logs -f backend | grep -E "(ERROR|WARN|crew|war)"

# 4. Call endpoint and watch for errors
curl -X POST https://api.themobstate.com/crew-wars/declare \
  -H "Authorization: Bearer TEST_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"targetCrewId": 123}'

# 5. Check system error logs immediately
curl -s "https://admin.themobstate.com/api/admin/system-logs?limit=5" | jq '.'
```

**Testing database migrations:**

```bash
# 1. Deploy code with new Prisma schema
docker compose -f docker-compose.plesk.yml up -d --build backend

# 2. Run migration in container
docker compose -f docker-compose.plesk.yml run --rm backend npx prisma migrate deploy

# 3. Check for schema validation errors
docker compose -f docker-compose.plesk.yml run --rm backend npx prisma validate

# 4. Monitor backend for any connection errors
docker compose -f docker-compose.plesk.yml logs backend | tail -30
```

### 6. Post-Testing Checklist (Before Merging)

- [ ] No new `system.error` events logged in the last 5 minutes
- [ ] All admin dashboard alerts are green (no "Recent system errors")
- [ ] Backend CPU/memory stable (no memory leak signs)
- [ ] Response times normal (check admin `/api/admin/overview` trends)
- [ ] No `PrismaClientValidationError` or `PrismaClientKnownRequestError` in logs
- [ ] All player-facing endpoints tested (login, profile, actions, notifications)
- [ ] Cross-module integration tested (if change touches multiple modules)

---

## Docker Compose Debugging (Plesk/Production)

### Restart Individual Services

```bash
# Restart backend only
docker compose -f docker-compose.plesk.yml restart backend

# Restart client (nginx)
docker compose -f docker-compose.plesk.yml restart client

# Restart admin dashboard
docker compose -f docker-compose.plesk.yml restart admin

# Full restart
docker compose -f docker-compose.plesk.yml down && docker compose -f docker-compose.plesk.yml up -d
```

### View Real-Time Logs

```bash
# All services
docker compose -f docker-compose.plesk.yml logs -f

# Single service (e.g., backend)
docker compose -f docker-compose.plesk.yml logs -f backend

# Last 50 lines + follow
docker compose -f docker-compose.plesk.yml logs -f --tail=50 backend

# Search for specific error
docker compose -f docker-compose.plesk.yml logs backend | grep "ERROR\|WARN"
```

### Check Resource Usage

```bash
# See container stats (CPU, memory, network)
docker stats

# Check disk space
df -h /var/www/vhosts/themobstate.com/apps/mafia_game/

# Check container size
docker ps -a --format "table {{.Names}}\t{{.Size}}"
```

### Force Container Rebuild (after code changes)

```bash
# Rebuild and restart backend
docker compose -f docker-compose.plesk.yml up -d --build --no-deps backend

# Rebuild and restart client
docker compose -f docker-compose.plesk.yml up -d --build --no-deps client

# Full rebuild (all services)
docker compose -f docker-compose.plesk.yml up -d --build
```

---

## Prisma Connection Pool Tuning

If `P2024: Too many connections` errors occur frequently:

**In `.env`:**
```env
# Increase connection pool
DATABASE_URL="mysql://user:pass@localhost:3306/mafia_game?connection_limit=200&pool_timeout=10"

# Tune Prisma client settings
PRISMA_CLIENT_ENGINE_TYPE=binary
```

**In `backend/src/lib/prisma.ts`:**
```typescript
const prisma = new PrismaClient({
  log: process.env.NODE_ENV === 'development' ? ['query', 'error', 'warn'] : ['error'],
  // Optional: timeouts per query
  // errorFormat: 'pretty',
});
```

Monitor connection usage:
```bash
# Check active MySQL connections
docker compose -f docker-compose.plesk.yml exec mariadb mysql -u root -p$MYSQL_ROOT_PASSWORD -e "SHOW PROCESSLIST;" | wc -l
```
curl -I https://yourdomain.com/images/avatars/default_1.png

# Optional: check a known-missing file returns 404 (sanity check)
curl -I https://yourdomain.com/images/jobs/beggar_job.png
```

Expected:
- Existing assets return `200` with realistic image sizes (not tiny LFS pointer-sized payloads).
- Known-missing assets return `404` and UI should show fallback icon/image.

Browser step (required after client deploy):
- Hard refresh once (`Ctrl+F5`) and, if visuals still look stale, unregister Service Worker in DevTools (`Application` -> `Service Workers` -> `Unregister`) and reload.

### Database Backup

Create backup script `scripts/backup.sh`:

```bash
#!/bin/bash
BACKUP_DIR="/opt/backups/mafia_game"
DATE=$(date +%Y%m%d_%H%M%S)

mkdir -p $BACKUP_DIR

# Backup database
docker compose -f docker-compose.prod.yml exec -T mariadb \
  mysqldump -u root -p$MYSQL_ROOT_PASSWORD mafia_game \
  > $BACKUP_DIR/db_backup_$DATE.sql

# Keep only last 7 days
find $BACKUP_DIR -name "db_backup_*.sql" -mtime +7 -delete

echo "Backup completed: $BACKUP_DIR/db_backup_$DATE.sql"
```

Run daily via cron:

```bash
crontab -e
```

Add:
```
0 2 * * * /opt/mafia_game/scripts/backup.sh
```

### View Logs

```bash
# All services
docker compose -f docker-compose.prod.yml logs -f

# Specific service
docker compose -f docker-compose.prod.yml logs -f backend

# Last 100 lines
docker compose -f docker-compose.prod.yml logs --tail=100 backend
```

### Restart Service

```bash
# Restart backend only
docker compose -f docker-compose.prod.yml restart backend

# Restart all
docker compose -f docker-compose.prod.yml restart
```

### Scale Backend (Optional)

If you need multiple backend instances:

```bash
# Scale to 3 instances
docker compose -f docker-compose.prod.yml up -d --scale backend=3

# Update nginx upstream to load balance
```

---

## Monitoring (Optional)

### Add Prometheus + Grafana

Create `docker-compose.monitoring.yml`:

```yaml
version: '3.8'

services:
  prometheus:
    image: prom/prometheus
    volumes:
      - ./monitoring/prometheus.yml:/etc/prometheus/prometheus.yml
      - prometheus_data:/prometheus
    ports:
      - "9090:9090"
    networks:
      - backend

  grafana:
    image: grafana/grafana
    volumes:
      - grafana_data:/var/lib/grafana
    ports:
      - "3001:3000"
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=admin
    networks:
      - backend

volumes:
  prometheus_data:
  grafana_data:

networks:
  backend:
    external: true
```

Run:
```bash
docker compose -f docker-compose.monitoring.yml up -d
```

---

## Troubleshooting

### Images Missing In Production But Fine Locally

Most common causes are stale Service Worker cache or Git LFS pointers instead of hydrated files.

```bash
# 1) Verify LFS files are hydrated
git lfs ls-files | head -n 20
head -n 3 client/assets/images/crimes/pickpocket_crime.png

# If first line starts with "version https://git-lfs.github.com/spec/v1",
# run LFS pull/checkout again:
git lfs pull --include="client/assets/**,client/images/**"
git lfs checkout

# 2) Rebuild client
docker compose -f docker-compose.prod.yml up -d --build client
```

Then do Service Worker unregister + hard refresh in browser.

### Container Won't Start

```bash
# Check logs
docker compose -f docker-compose.prod.yml logs backend

# Check container status
docker compose -f docker-compose.prod.yml ps

# Restart
docker compose -f docker-compose.prod.yml restart backend
```

### Database Connection Error

```bash
# Check MariaDB running
docker compose -f docker-compose.prod.yml ps mariadb

# Test connection
docker compose -f docker-compose.prod.yml exec backend sh
# Inside container:
npx prisma db push
```

### Out of Memory

```bash
# Check resource usage
docker stats

# Limit backend memory in docker-compose.prod.yml:
services:
  backend:
    deploy:
      resources:
        limits:
          memory: 512M
```

### SSL Certificate Renewal

```bash
# Renew Let's Encrypt
sudo certbot renew

# Copy new certs
sudo cp /etc/letsencrypt/live/yourdomain.com/fullchain.pem nginx/ssl/cert.pem
sudo cp /etc/letsencrypt/live/yourdomain.com/privkey.pem nginx/ssl/key.pem

# Restart nginx
docker compose -f docker-compose.prod.yml restart nginx
```

---

## Rollback Procedure

If deployment fails:

```bash
# Stop current deployment
docker compose -f docker-compose.prod.yml down

# Checkout previous version
git log --oneline
git checkout <previous-commit-hash>

# Rebuild and start
docker compose -f docker-compose.prod.yml up -d --build

# If database migration issue, restore backup
docker compose -f docker-compose.prod.yml exec -T mariadb \
  mysql -u root -p$MYSQL_ROOT_PASSWORD mafia_game < /opt/backups/mafia_game/db_backup_20260127_020000.sql
```

---

## Security Checklist

- [ ] Strong passwords for all services
- [ ] JWT secret is random and secure
- [ ] SSL/TLS enabled (HTTPS only)
- [ ] Firewall configured (only 80, 443, 22 open)
- [ ] Database not exposed to internet
- [ ] Regular backups configured
- [ ] Docker images updated regularly
- [ ] Rate limiting enabled in nginx
- [ ] CORS configured correctly
- [ ] Admin dashboard on separate subdomain with stricter auth

---

**Next Steps:**
- Set up monitoring (Prometheus/Grafana)
- Configure log aggregation (e.g., Loki)
- Set up alerts (email/SMS on errors)
- Performance tuning (connection pools, caching)
