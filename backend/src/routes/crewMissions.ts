import { Router } from 'express';
import { z } from 'zod';
import { authenticate, AuthRequest } from '../middleware/authenticate';
import { crewMissionService } from '../services/crewMissionService';

const router = Router();

const startMissionSchema = z.object({
  missionKey: z.string().trim().min(2).max(80),
  assignments: z
    .array(
      z.object({
        playerId: z.number().int().positive(),
        roleKey: z.string().trim().min(2).max(30),
      }),
    )
    .max(8)
    .optional(),
});

const resolveMissionSchema = z.object({
  outcome: z.enum(['success', 'partial', 'fail']).optional(),
  progressPct: z.number().int().min(0).max(100).optional(),
});

function mapMissionErrorToResponse(error: unknown, res: any): boolean {
  if (!(error instanceof Error)) return false;
  const message = error.message;
  if (message === 'NOT_IN_CREW') {
    res.status(403).json({ event: 'error.not_in_crew', params: {} });
    return true;
  }
  if (message === 'MISSION_PERMISSION_DENIED') {
    res.status(403).json({ event: 'error.mission_permission_denied', params: {} });
    return true;
  }
  if (message === 'MISSION_ALREADY_IN_PROGRESS') {
    res.status(400).json({ event: 'error.mission_already_in_progress', params: {} });
    return true;
  }
  if (message === 'MISSION_COOLDOWN_ACTIVE') {
    res.status(400).json({ event: 'error.mission_cooldown_active', params: {} });
    return true;
  }
  if (message === 'MISSION_TEMPLATE_NOT_FOUND') {
    res.status(404).json({ event: 'error.mission_template_not_found', params: {} });
    return true;
  }
  if (message === 'MISSION_TIER_LOCKED') {
    res.status(400).json({ event: 'error.mission_tier_locked', params: {} });
    return true;
  }
  if (message === 'MISSION_CLEARING_HOUSE_LOCKED') {
    res.status(400).json({
      event: 'error.mission_clearing_house_locked',
      params: { reason: 'CLEARING_HOUSE_REQUIRES_MISSION_LEVEL' },
    });
    return true;
  }
  if (message === 'MISSION_TRADE_REQUIREMENTS_NOT_MET') {
    res.status(400).json({ event: 'error.mission_trade_requirements_not_met', params: {} });
    return true;
  }
  if (message === 'MISSION_START_FAILED') {
    res.status(500).json({ event: 'error.mission_start_failed', params: {} });
    return true;
  }
  if (message === 'MISSION_RUN_NOT_FOUND') {
    res.status(404).json({ event: 'error.mission_run_not_found', params: {} });
    return true;
  }
  if (message === 'MISSION_ALREADY_RESOLVED') {
    res.status(400).json({ event: 'error.mission_already_resolved', params: {} });
    return true;
  }
  if (message === 'MISSION_NOT_COMPLETED') {
    res.status(400).json({ event: 'error.mission_not_completed', params: {} });
    return true;
  }
  if (message === 'MISSION_REWARDS_ALREADY_CLAIMED') {
    res.status(400).json({ event: 'error.mission_rewards_already_claimed', params: {} });
    return true;
  }
  if (message === 'MISSION_COOLDOWN_NOT_ACTIVE') {
    res.status(400).json({ event: 'error.mission_cooldown_not_active', params: {} });
    return true;
  }
  if (message === 'INSUFFICIENT_CREDITS') {
    res.status(400).json({ event: 'error.insufficient_credits', params: {} });
    return true;
  }
  return false;
}

router.get('/overview', authenticate, async (req: AuthRequest, res) => {
  try {
    const overview = await crewMissionService.getOverview(req.player!.id);
    return res.json({
      event: 'crew_missions.overview',
      params: {},
      ...overview,
    });
  } catch (error) {
    if (mapMissionErrorToResponse(error, res)) return;
    console.error('[Crew Missions] overview error:', error);
    return res.status(500).json({ event: 'error.internal', params: {} });
  }
});

router.get('/templates', authenticate, async (req: AuthRequest, res) => {
  try {
    const overview = await crewMissionService.getOverview(req.player!.id);
    return res.json({
      event: 'crew_missions.templates',
      params: {},
      templates: overview.templates,
      hqGlobalLevel: overview.hqGlobalLevel,
      memberCount: overview.memberCount,
      crewId: overview.crewId,
    });
  } catch (error) {
    if (mapMissionErrorToResponse(error, res)) return;
    console.error('[Crew Missions] templates error:', error);
    return res.status(500).json({ event: 'error.internal', params: {} });
  }
});

router.post('/start', authenticate, async (req: AuthRequest, res) => {
  try {
    const payload = startMissionSchema.parse(req.body);
    const run = await crewMissionService.startMission(
      req.player!.id,
      payload.missionKey,
      payload.assignments ?? [],
    );
    return res.status(201).json({
      event: 'crew_missions.started',
      params: { runId: run.id },
      run,
    });
  } catch (error) {
    if (error instanceof z.ZodError) {
      return res.status(400).json({ event: 'error.validation_failed', params: { issues: error.flatten() } });
    }
    if (mapMissionErrorToResponse(error, res)) return;
    console.error('[Crew Missions] start error:', error);
    return res.status(500).json({ event: 'error.internal', params: {} });
  }
});

router.post('/runs/:id/resolve', authenticate, async (req: AuthRequest, res) => {
  try {
    const runId = Number.parseInt(String(req.params.id), 10);
    if (!Number.isFinite(runId)) {
      return res.status(400).json({ event: 'error.invalid_run_id', params: {} });
    }

    const payload = resolveMissionSchema.parse(req.body ?? {});
    const run = await crewMissionService.resolveMission(req.player!.id, runId, payload);
    return res.json({
      event: 'crew_missions.resolved',
      params: { runId },
      run,
    });
  } catch (error) {
    if (error instanceof z.ZodError) {
      return res.status(400).json({ event: 'error.validation_failed', params: { issues: error.flatten() } });
    }
    if (mapMissionErrorToResponse(error, res)) return;
    console.error('[Crew Missions] resolve error:', error);
    return res.status(500).json({ event: 'error.internal', params: {} });
  }
});

router.post('/runs/:id/claim', authenticate, async (req: AuthRequest, res) => {
  try {
    const runId = Number.parseInt(String(req.params.id), 10);
    if (!Number.isFinite(runId)) {
      return res.status(400).json({ event: 'error.invalid_run_id', params: {} });
    }
    const run = await crewMissionService.claimRewards(req.player!.id, runId);
    return res.json({
      event: 'crew_missions.rewards_claimed',
      params: { runId },
      run,
    });
  } catch (error) {
    if (mapMissionErrorToResponse(error, res)) return;
    console.error('[Crew Missions] claim error:', error);
    return res.status(500).json({ event: 'error.internal', params: {} });
  }
});

router.get('/runs/:id/speedup-quote', authenticate, async (req: AuthRequest, res) => {
  try {
    const runId = Number.parseInt(String(req.params.id), 10);
    if (!Number.isFinite(runId)) {
      return res.status(400).json({ event: 'error.invalid_run_id', params: {} });
    }
    const quote = await crewMissionService.getSpeedupQuote(req.player!.id, runId);
    return res.json({
      event: 'crew_missions.cooldown_speedup_quote',
      params: { runId, credits: quote.credits },
      ...quote,
    });
  } catch (error) {
    if (mapMissionErrorToResponse(error, res)) return;
    console.error('[Crew Missions] speedup quote error:', error);
    return res.status(500).json({ event: 'error.internal', params: {} });
  }
});

router.post('/runs/:id/speedup', authenticate, async (req: AuthRequest, res) => {
  try {
    const runId = Number.parseInt(String(req.params.id), 10);
    if (!Number.isFinite(runId)) {
      return res.status(400).json({ event: 'error.invalid_run_id', params: {} });
    }
    const result = await crewMissionService.speedupCooldown(req.player!.id, runId);
    return res.json({
      event: 'crew_missions.cooldown_sped_up',
      params: { runId, creditsSpent: result.creditsSpent },
      ...result,
    });
  } catch (error) {
    if (mapMissionErrorToResponse(error, res)) return;
    console.error('[Crew Missions] speedup error:', error);
    return res.status(500).json({ event: 'error.internal', params: {} });
  }
});

export default router;
