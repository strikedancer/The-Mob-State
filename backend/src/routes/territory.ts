import { Router, Response, NextFunction } from 'express';
import { z } from 'zod';
import { authenticate, AuthRequest } from '../middleware/authenticate';
import { adminAuthMiddleware, type AdminRequest } from '../middleware/adminAuth';
import * as territoryService from '../services/territoryService';
import * as crewService from '../services/crewService';

const router = Router();

// ── Input Schemas ────────────────────────────────────────────────────────────

const startContestSchema = z.object({
  regionKey: z.string().min(2).max(60),
});

const actionSchema = z.object({
  contestId: z.number().int().positive(),
  actionType: z.enum(['patrol', 'intel_scan', 'sabotage', 'supply_run', 'raid', 'defense']),
});

const defendSchema = z.object({
  contestId: z.number().int().positive(),
});

const adminAssignSchema = z.object({
  regionKey: z.string().min(2).max(60),
  crewId: z.number().int().positive().nullable(),
});

const adminResetSchema = z.object({
  regionKey: z.string().min(2).max(60),
});

const adminResolveSchema = z.object({
  contestId: z.number().int().positive(),
});

const adminSeasonSchema = z.object({
  seasonKey: z.string().min(4).max(64),
  startsAt: z.string().datetime(),
  endsAt: z.string().datetime(),
});

const adminCloseSeasonSchema = z.object({
  seasonKey: z.string().min(4).max(64),
});

// ── Error Mapper ─────────────────────────────────────────────────────────────

function mapTerritoryError(error: unknown, res: Response, next: NextFunction) {
  if (!(error instanceof Error)) return next(error);

  const map: Record<string, [number, string]> = {
    TERRITORY_DISABLED:             [403, 'territory.disabled'],
    COUNTRY_NOT_FOUND:              [404, 'territory.country_not_found'],
    REGION_NOT_FOUND:               [404, 'territory.region_not_found'],
    ACTION_OUTSIDE_CURRENT_COUNTRY: [403, 'territory.action_outside_current_country'],
    CONTEST_ALREADY_ACTIVE:         [409, 'territory.contest_already_active'],
    CREW_CONTEST_LIMIT_REACHED:     [429, 'territory.crew_contest_limit_reached'],
    REGIONS_CAP_REACHED:            [429, 'territory.regions_cap_reached'],
    CONTEST_NOT_FOUND:              [404, 'territory.contest_not_found'],
    CONTEST_NOT_ACTIVE:             [409, 'territory.contest_not_active'],
    CONTEST_NOT_JOINABLE:           [409, 'territory.contest_not_joinable'],
    NOT_IN_CONTEST:                 [403, 'territory.not_in_contest'],
    ACTION_ROLE_MISMATCH:           [403, 'territory.action_role_mismatch'],
    HQ_LEVEL_REQUIRED:              [403, 'territory.hq_level_required'],
    ACTION_COOLDOWN:                [429, 'territory.action_cooldown'],
    DAILY_CAP_REACHED:              [429, 'territory.daily_cap_reached'],
    INVALID_ACTION_TYPE:            [400, 'territory.invalid_action_type'],
    NOT_IN_CREW:                    [400, 'error.not_in_crew'],
    CONTEST_NOT_FOUND_OR_ALREADY_RESOLVED: [409, 'territory.contest_already_resolved'],
    PROJECT_HQ_LEVEL_REQUIRED:      [403, 'territory.project_hq_level_required'],
    PROJECT_NOT_OWNER:              [403, 'territory.project_not_owner'],
    PROJECT_ALREADY_EXISTS:         [409, 'territory.project_already_exists'],
    PROJECT_NOT_FOUND:              [404, 'territory.project_not_found'],
    PROJECT_DESTROYED:              [409, 'territory.project_destroyed'],
    PROJECT_ALREADY_ACTIVE:         [409, 'territory.project_already_active'],
    PROJECT_CONTRIBUTE_COOLDOWN:    [429, 'territory.project_contribute_cooldown'],
    SEASON_NOT_FOUND:               [404, 'territory.season_not_found'],
  };

  const entry = map[error.message];
  if (entry) {
    return res.status(entry[0]).json({ event: entry[1], params: {} });
  }
  return next(error);
}

async function requireCrew(req: AuthRequest, res: Response): Promise<number | null> {
  const playerId = req.player?.id;
  if (!playerId) {
    res.status(401).json({ event: 'auth.unauthorized', params: { reason: 'MISSING_PLAYER_CONTEXT' } });
    return null;
  }

  const crew = await crewService.getPlayerCrew(playerId);
  if (!crew?.id) {
    res.status(400).json({ event: 'error.not_in_crew', params: {} });
    return null;
  }

  return crew.id;
}

// ── Player Endpoints ─────────────────────────────────────────────────────────

/**
 * GET /territory/countries
 * List all enabled countries.
 */
router.get('/countries', authenticate, async (_req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    const countries = await territoryService.getCountries();
    return res.json({ event: 'territory.countries', params: { countries } });
  } catch (error) {
    return mapTerritoryError(error, res, next);
  }
});

/**
 * GET /territory/map/:countryCode
 * Full map data for a country: regions, ownership, contest status.
 */
router.get('/map/:countryCode', authenticate, async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    const countryCode = req.params.countryCode.toLowerCase();
    const viewerPlayerId = req.player?.id ?? null;
    const viewerCrew = viewerPlayerId ? await crewService.getPlayerCrew(viewerPlayerId) : null;
    const data = await territoryService.getMapData(countryCode, {
      viewerPlayerId,
      viewerCrewId: viewerCrew?.id ?? null,
    });
    return res.json({ event: 'territory.map', params: data });
  } catch (error) {
    return mapTerritoryError(error, res, next);
  }
});

/**
 * GET /territory/overview
 * Global overview: config settings snapshot, active season, leaderboard top 10.
 */
router.get('/overview', authenticate, async (_req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    const overview = await territoryService.getOverview();
    return res.json({ event: 'territory.overview', params: overview });
  } catch (error) {
    return mapTerritoryError(error, res, next);
  }
});

/**
 * POST /territory/contest/start
 * Start a new contest for a region.
 */
router.post('/contest/start', authenticate, async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    const crewId = await requireCrew(req, res);
    if (!crewId) return;
    const body = startContestSchema.parse(req.body);
    const result = await territoryService.startContest(
      req.player!.id,
      crewId,
      body.regionKey,
      req.player?.currentCountry,
    );
    return res.json({
      event: 'territory.contest_started',
      params: {
        ...result,
        contestId: Number(result.contestId),
      },
    });
  } catch (error) {
    if (error instanceof z.ZodError) {
      return res.status(400).json({ event: 'error.validation', params: { issues: error.issues } });
    }
    return mapTerritoryError(error, res, next);
  }
});

/**
 * POST /territory/action
 * Perform an action in an active contest.
 */
router.post('/action', authenticate, async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    const crewId = await requireCrew(req, res);
    if (!crewId) return;
    const body = actionSchema.parse(req.body);
    const result = await territoryService.doAction(
      req.player!.id,
      crewId,
      body.contestId,
      body.actionType,
      req.player?.currentCountry,
    );
    return res.json({ event: 'territory.action_done', params: result });
  } catch (error) {
    if (error instanceof z.ZodError) {
      return res.status(400).json({ event: 'error.validation', params: { issues: error.issues } });
    }
    return mapTerritoryError(error, res, next);
  }
});

/**
 * POST /territory/contest/defend
 * Join a contest as defender.
 */
router.post('/contest/defend', authenticate, async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    const crewId = await requireCrew(req, res);
    if (!crewId) return;
    const body = defendSchema.parse(req.body);
    await territoryService.defendContest(
      req.player!.id,
      crewId,
      body.contestId,
      req.player?.currentCountry,
    );
    return res.json({ event: 'territory.defend_joined', params: {} });
  } catch (error) {
    if (error instanceof z.ZodError) {
      return res.status(400).json({ event: 'error.validation', params: { issues: error.issues } });
    }
    return mapTerritoryError(error, res, next);
  }
});

const regionProjectSchema = z.object({
  regionKey: z.string().min(2).max(60),
});

/**
 * POST /territory/projects/start
 * Start a safehouse network project on an owned region (HQ-gated).
 */
router.post('/projects/start', authenticate, async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    const crewId = await requireCrew(req, res);
    if (!crewId) return;
    const body = regionProjectSchema.parse(req.body);
    const project = await territoryService.startRegionProject(
      req.player!.id,
      crewId,
      body.regionKey,
      req.player?.currentCountry,
    );
    return res.json({ event: 'territory.project_started', params: { project } });
  } catch (error) {
    if (error instanceof z.ZodError) {
      return res.status(400).json({ event: 'error.validation', params: { issues: error.issues } });
    }
    return mapTerritoryError(error, res, next);
  }
});

/**
 * POST /territory/projects/contribute
 * Advance/repair a region project outside an active contest.
 */
router.post('/projects/contribute', authenticate, async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    const crewId = await requireCrew(req, res);
    if (!crewId) return;
    const body = regionProjectSchema.parse(req.body);
    const project = await territoryService.contributeRegionProject(
      req.player!.id,
      crewId,
      body.regionKey,
      req.player?.currentCountry,
    );
    return res.json({ event: 'territory.project_contributed', params: { project } });
  } catch (error) {
    if (error instanceof z.ZodError) {
      return res.status(400).json({ event: 'error.validation', params: { issues: error.issues } });
    }
    return mapTerritoryError(error, res, next);
  }
});

/**
 * GET /territory/crew/:crewId
 * Territory overview for a specific crew.
 */
router.get('/crew/:crewId', authenticate, async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    const crewId = parseInt(req.params.crewId, 10);
    if (isNaN(crewId)) return res.status(400).json({ event: 'error.invalid_crew_id', params: {} });
    const data = await territoryService.getCrewTerritory(crewId);
    return res.json({ event: 'territory.crew', params: data });
  } catch (error) {
    return mapTerritoryError(error, res, next);
  }
});

/**
 * GET /territory/leaderboard
 * Top crews by regions owned.
 */
router.get('/leaderboard', authenticate, async (_req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    const leaderboard = await territoryService.getLeaderboard();
    return res.json({ event: 'territory.leaderboard', params: { leaderboard } });
  } catch (error) {
    return mapTerritoryError(error, res, next);
  }
});

// ── Admin Endpoints ───────────────────────────────────────────────────────────

/**
 * GET /territory/admin/overview
 */
router.get('/admin/overview', adminAuthMiddleware, async (_req: AdminRequest, res: Response, next: NextFunction) => {
  try {
    const overview = await territoryService.getAdminOverview();
    return res.json({ event: 'territory.admin.overview', params: overview });
  } catch (error) {
    return mapTerritoryError(error, res, next);
  }
});

/**
 * POST /territory/admin/contest/resolve
 */
router.post('/admin/contest/resolve', adminAuthMiddleware, async (req: AdminRequest, res: Response, next: NextFunction) => {
  try {
    const body = adminResolveSchema.parse(req.body);
    const result = await territoryService.resolveContest(body.contestId);
    return res.json({ event: 'territory.admin.resolved', params: result });
  } catch (error) {
    if (error instanceof z.ZodError) {
      return res.status(400).json({ event: 'error.validation', params: { issues: error.issues } });
    }
    return mapTerritoryError(error, res, next);
  }
});

/**
 * POST /territory/admin/region/assign
 */
router.post('/admin/region/assign', adminAuthMiddleware, async (req: AdminRequest, res: Response, next: NextFunction) => {
  try {
    const body = adminAssignSchema.parse(req.body);
    await territoryService.adminAssignRegion(body.regionKey, body.crewId);
    return res.json({ event: 'territory.admin.assigned', params: {} });
  } catch (error) {
    if (error instanceof z.ZodError) {
      return res.status(400).json({ event: 'error.validation', params: { issues: error.issues } });
    }
    return mapTerritoryError(error, res, next);
  }
});

/**
 * POST /territory/admin/region/reset
 */
router.post('/admin/region/reset', adminAuthMiddleware, async (req: AdminRequest, res: Response, next: NextFunction) => {
  try {
    const body = adminResetSchema.parse(req.body);
    await territoryService.adminResetRegion(body.regionKey);
    return res.json({ event: 'territory.admin.reset', params: {} });
  } catch (error) {
    if (error instanceof z.ZodError) {
      return res.status(400).json({ event: 'error.validation', params: { issues: error.issues } });
    }
    return mapTerritoryError(error, res, next);
  }
});

/**
 * POST /territory/admin/season/start
 */
router.post('/admin/season/start', adminAuthMiddleware, async (req: AdminRequest, res: Response, next: NextFunction) => {
  try {
    const body = adminSeasonSchema.parse(req.body);
    await territoryService.adminStartSeason(body.seasonKey, new Date(body.startsAt), new Date(body.endsAt));
    return res.json({ event: 'territory.admin.season_started', params: {} });
  } catch (error) {
    if (error instanceof z.ZodError) {
      return res.status(400).json({ event: 'error.validation', params: { issues: error.issues } });
    }
    return next(error);
  }
});

/**
 * POST /territory/admin/season/close
 */
router.post('/admin/season/close', adminAuthMiddleware, async (req: AdminRequest, res: Response, next: NextFunction) => {
  try {
    const body = adminCloseSeasonSchema.parse(req.body);
    const result = await territoryService.adminCloseSeason(body.seasonKey);
    return res.json({ event: 'territory.admin.season_closed', params: result });
  } catch (error) {
    if (error instanceof z.ZodError) {
      return res.status(400).json({ event: 'error.validation', params: { issues: error.issues } });
    }
    return mapTerritoryError(error, res, next);
  }
});

export default router;
