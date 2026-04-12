import express, { Application } from 'express';
import cors from 'cors';
import config from './config';
import fs from 'fs';
import healthRouter from './routes/health';
import authRouter from './routes/auth';
import playerRouter from './routes/player';
import hospitalRouter from './routes/hospital';
import icuRouter from './routes/icu';
import eventsRouter from './routes/events';
import gameEventsRouter from './routes/gameEvents';
import vehiclesRouter from './routes/vehicles';
import crimesRouter from './routes/crimes';
import jobsRouter from './routes/jobs';
import propertiesRouter from './routes/properties';
import crewsRouter from './routes/crews';
import friendsRouter from './routes/friends';
import messagesRouter from './routes/messages';
import activitiesRouter from './routes/activities';
import heistsRouter from './routes/heists';
import policeRouter from './routes/police';
import fbiRouter from './routes/fbi';
import trialRouter from './routes/trial';
import bankRouter from './routes/bank';
import travelRouter from './routes/travel';
import tradeRouter from './routes/trade';
import aviationRouter from './routes/aviation';
import casinoRouter from './routes/casino';
import weaponsRouter from './routes/weapons';
import ammoRouter from './routes/ammo';
import ammoFactoriesRouter from './routes/ammoFactories';
import shootingRangeRouter from './routes/shootingRange';
import gymRouter from './routes/gym';
import toolsRouter from './routes/tools';
import loadoutsRouter from './routes/loadouts';
import backpacksRouter from './routes/backpackRoutes';
import foodRouter from './routes/food';
import drugsRouter from './routes/drugs';
import drugFacilitiesRouter from './routes/drugFacilities';
import nightclubRouter from './routes/nightclubRoutes';
import garageRouter from './routes/garage';
import marketRouter from './routes/market';
import smugglingRouter from './routes/smuggling';
import settingsRouter from './routes/settings';
import adminAuthRouter from './routes/admin-auth';
import adminRouter from './routes/admin';
import notificationsRouter from './routes/notifications';
import adminFixRouter from './routes/admin-fix';
import adminNPCsRouter from './routes/admin/npcs';
import adminGameEventsRouter from './routes/admin/gameEvents';
import hitlistRouter from './routes/hitlist';
import prostitutesRouter from './routes/prostitutes';
import redLightDistrictsRouter from './routes/redLightDistricts';
import policeRaidsRouter from './routes/policeRaids';
import vipEventsRouter from './routes/vipEvents';
import leaderboardsRouter from './routes/leaderboards';
import rivalriesRouter from './routes/rivalries';
import achievementsRouter from './routes/achievements';
import educationRouter from './routes/education';
import subscriptionsRouter from './routes/subscriptions';
import cryptoRouter from './routes/crypto';
import { errorHandler, notFoundHandler } from './middleware/errorHandler';
import { globalRateLimiter } from './middleware/rateLimit';
import path from 'path';

const app: Application = express();

// Payment webhook — raw JSON requests must be registered before express.json()
app.use('/subscriptions/webhook', express.raw({ type: 'application/json' }));

// Middleware
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Serve Flutter web app static files
const clientBuildPath = path.join(__dirname, '../../client/build/web');
app.use(express.static(clientBuildPath));

const dockerClientImagesPath = '/client/images';
const localClientImagesPath = path.join(__dirname, '../../client/images');
const clientImagesPath = fs.existsSync(dockerClientImagesPath)
  ? dockerClientImagesPath
  : localClientImagesPath;

app.use('/assets/images', express.static(clientImagesPath));

// CORS configuration - allow all origins in development
app.use(
  cors({
    origin: config.nodeEnv === 'development' 
      ? (origin, callback) => {
          console.log(`[CORS] Request from origin: ${origin}`);
          callback(null, origin || '*'); // Allow the requesting origin or wildcard
        }
      : config.allowedOrigins,
    credentials: true, // Always allow credentials for Flutter web
    methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
    allowedHeaders: ['Content-Type', 'Authorization', 'Cache-Control', 'X-Requested-With'],
    exposedHeaders: ['Content-Type', 'Cache-Control'],
  })
);

// Global rate limiter (if Redis is available)
app.use(globalRateLimiter);

// Request logging (development only)
if (config.nodeEnv === 'development') {
  app.use((req, _res, next) => {
    console.log(`[${new Date().toISOString()}] ${req.method} ${req.url}`);
    next();
  });
}

// Routes
app.use('/health', healthRouter);
app.use('/auth', authRouter);
app.use('/player', playerRouter);
app.use('/hospital', hospitalRouter);
app.use('/icu', icuRouter);
app.use('/events', eventsRouter);
app.use('/game-events', gameEventsRouter);
app.use('/vehicles', vehiclesRouter);
app.use('/crimes', crimesRouter);
app.use('/jobs', jobsRouter);
app.use('/properties', propertiesRouter);
app.use('/crews', crewsRouter);
app.use('/friends', friendsRouter);
app.use('/messages', messagesRouter);
app.use('/activities', activitiesRouter);
app.use('/heists', heistsRouter);
app.use('/police', policeRouter);
app.use('/fbi', fbiRouter);
app.use('/notifications', notificationsRouter);
app.use('/trial', trialRouter);
app.use('/bank', bankRouter);
app.use('/travel', travelRouter);
app.use('/trade', tradeRouter);
app.use('/aviation', aviationRouter);
app.use('/casino', casinoRouter);
app.use('/weapons', weaponsRouter);
app.use('/ammo', ammoRouter);
app.use('/ammo-factories', ammoFactoriesRouter);
app.use('/shooting-range', shootingRangeRouter);
app.use('/gym', gymRouter);
app.use('/tools', toolsRouter);
app.use('/loadouts', loadoutsRouter);
app.use('/backpacks', backpacksRouter);
app.use('/food', foodRouter);
app.use('/drugs', drugsRouter);
app.use('/drug-facilities', drugFacilitiesRouter);
app.use('/nightclub', nightclubRouter);
app.use('/garage', garageRouter);
app.use('/market', marketRouter);
app.use('/smuggling', smugglingRouter);
app.use('/settings', settingsRouter);
app.use('/hitlist', hitlistRouter);
app.use('/security', hitlistRouter);
app.use('/prostitutes', prostitutesRouter);
app.use('/red-light-districts', redLightDistrictsRouter);
app.use('/police-raids', policeRaidsRouter);
app.use('/vip-events', vipEventsRouter);
app.use('/leaderboards', leaderboardsRouter);
app.use('/rivalries', rivalriesRouter);
app.use('/achievements', achievementsRouter);
app.use('/education', educationRouter);
app.use('/subscriptions', subscriptionsRouter);
app.use('/crypto', cryptoRouter);
app.use('/admin/auth', adminAuthRouter);
app.use('/admin', adminRouter);
app.use('/admin-fix', adminFixRouter);
app.use('/admin/npcs', adminNPCsRouter);
app.use('/admin/game-events', adminGameEventsRouter);

// 404 handler
app.use(notFoundHandler);

// Error handler (must be last)
app.use(errorHandler);

export default app;
