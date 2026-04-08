# Mafia Game - Backend

Node.js + TypeScript backend voor het Mafia Game project.

## 🚀 Quick Start

```powershell
# Installeer dependencies
npm install

# Start development server
npm run dev

# Server draait op http://localhost:3000
```

## 📋 Beschikbare Scripts

- `npm run dev` - Start development server met hot reload
- `npm run build` - Compileer TypeScript naar JavaScript
- `npm start` - Start productie server
- `npm run lint` - Run ESLint
- `npm run format` - Format code met Prettier
- `npm run typecheck` - Check TypeScript types
- `npm run check` - Run typecheck + lint

## 🏥 Health Check

Test of de server draait:

```powershell
# In PowerShell
Invoke-RestMethod http://localhost:3000/health

# Of gebruik de test script
.\test-health.ps1
```

Expected response:
```json
{
  "status": "ok",
  "timestamp": "2026-01-27T16:00:00.000Z",
  "uptime": 123.456,
  "environment": "development"
}
```

## 📁 Project Structuur

```
backend/
├── src/
│   ├── index.ts              # Entry point
│   ├── app.ts                # Express app setup
│   ├── config/
│   │   └── index.ts          # Configuration loader
│   ├── middleware/
│   │   └── errorHandler.ts  # Error handling middleware
│   ├── routes/
│   │   └── health.ts         # Health check endpoint
│   └── utils/
│       └── timeProvider.ts   # Tijd provider voor deterministische tests
├── .env                      # Omgevingsvariabelen (niet committen!)
├── .env.example              # Voorbeeld omgevingsvariabelen
├── package.json
└── tsconfig.json
```

## ⚙️ Configuratie

Kopieer `.env.example` naar `.env` en pas aan:

```env
NODE_ENV=development
PORT=3000
DATABASE_URL="mysql://user:password@localhost:3306/mafia_game"
JWT_SECRET="your_secret_here"
```

## 🛠️ Development

### Code Formatteren

```powershell
npm run format
```

### Code Linting

```powershell
npm run lint
```

### Type Checking

```powershell
npm run typecheck
```

### Alles Checken

```powershell
npm run check
```

## 📦 Dependencies

### Production
- `express` - Web framework
- `cors` - CORS middleware
- `dotenv` - Environment variables
- `zod` - Schema validation

### Development
- `typescript` - TypeScript compiler
- `ts-node-dev` - Development server met hot reload
- `eslint` - Code linter
- `prettier` - Code formatter
- `@types/*` - TypeScript type definitions

## 🎯 Volgende Stappen

Zie [TODO.md](../TODO.md) voor de volgende development stappen:
- Phase 0.3: Database Setup (Prisma + MariaDB)
- Phase 1: Core Player Systems
- Phase 2: World Events & Real-time Updates

## 🐛 Troubleshooting

### Port Already in Use

```powershell
# Windows: Find process using port 3000
netstat -ano | findstr :3000

# Kill process by PID
taskkill /PID <PID> /F
```

### TypeScript Errors

```powershell
# Regenereer TypeScript configuratie
npx tsc --init

# Check TypeScript versie
npx tsc --version
```

### Module Not Found

```powershell
# Herinstalleer dependencies
Remove-Item -Recurse -Force node_modules
npm install
```

## 📚 Resources

- [Express Documentation](https://expressjs.com/)
- [TypeScript Documentation](https://www.typescriptlang.org/)
- [Node.js Documentation](https://nodejs.org/)
