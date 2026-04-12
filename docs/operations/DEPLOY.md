# Deployment Guide

This guide covers deploying the Mafia Game to a Linux VPS (Strato) using Docker.

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

# Rebuild and restart
docker compose -f docker-compose.prod.yml up -d --build

# Run new migrations if any
docker compose -f docker-compose.prod.yml run --rm backend npx prisma migrate deploy
```

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
