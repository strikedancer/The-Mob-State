import { Router, Response, NextFunction } from 'express';
import { z } from 'zod';
import { authenticate, AuthRequest } from '../middleware/authenticate';
import * as crewWarService from '../services/crewWarService';

const router = Router();

const declareWarSchema = z.object({
  targetCrewId: z.number().int().positive(),
  warType: z.enum(['kill_war', 'economy_war', 'territory_war', 'total_war']),
});

const actionSchema = z.object({
  actionType: z.enum(['attack_kill', 'attack_mug', 'attack_sabotage', 'defense_success', 'intel_scan', 'raid', 'crew_shield', 'war_boost', 'territory_claim']),
  targetPlayerId: z.number().int().positive().optional(),
  territoryKey: z.string().min(2).max(50).optional(),
  lootTarget: z.enum(['cash', 'car', 'boat', 'weapon', 'ammo', 'drug', 'trade']).optional(),
  sabotageBuilding: z.enum(['car_storage', 'boat_storage', 'weapon_storage', 'ammo_storage', 'drug_storage', 'trade_storage', 'cash_storage']).optional(),
});

function mapWarError(error: unknown, res: Response, next: NextFunction) {
  if (!(error instanceof Error)) {
    return next(error);
  }

  if (error.message === 'NOT_IN_CREW') {
    return res.status(400).json({ event: 'error.not_in_crew', params: {} });
  }
  if (error.message === 'NOT_CREW_LEADER') {
    return res.status(403).json({ event: 'error.not_crew_leader', params: {} });
  }
  if (error.message === 'TARGET_CREW_NOT_FOUND') {
    return res.status(404).json({ event: 'error.target_crew_not_found', params: {} });
  }
  if (error.message === 'CREW_ALREADY_IN_WAR') {
    return res.status(409).json({ event: 'error.crew_already_in_war', params: {} });
  }
  if (error.message === 'CREW_WAR_COOLDOWN') {
    return res.status(409).json({ event: 'error.crew_war_cooldown', params: {} });
  }
  if (error.message === 'NOT_ENOUGH_CREW_MEMBERS') {
    return res.status(400).json({ event: 'error.not_enough_crew_members', params: {} });
  }
  if (error.message === 'WAR_NOT_FOUND') {
    return res.status(404).json({ event: 'error.war_not_found', params: {} });
  }
  if (error.message === 'WAR_NOT_ACTIVE') {
    return res.status(409).json({ event: 'error.war_not_active', params: {} });
  }
  if (error.message === 'WAR_NOT_JOINABLE') {
    return res.status(409).json({ event: 'error.war_not_joinable', params: {} });
  }
  if (error.message === 'WAR_TARGET_REQUIRED') {
    return res.status(400).json({ event: 'error.war_target_required', params: {} });
  }
  if (error.message === 'WAR_REPEATED_TARGET_BLOCKED') {
    return res.status(429).json({ event: 'error.war_repeated_target_blocked', params: {} });
  }
  if (error.message === 'VIP_PLAYER_REQUIRED') {
    return res.status(403).json({ event: 'error.vip_player_required', params: {} });
  }
  if (error.message === 'VIP_CREW_REQUIRED') {
    return res.status(403).json({ event: 'error.vip_crew_required', params: {} });
  }
  if (error.message === 'WAR_ACTION_LIMIT_REACHED') {
    return res.status(429).json({ event: 'error.war_action_limit_reached', params: {} });
  }
  if (error.message.startsWith('WAR_ACTION_COOLDOWN:')) {
    const remainingMinutes = Number(error.message.split(':')[1] ?? 0);
    return res.status(429).json({ event: 'error.war_action_cooldown', params: { remainingMinutes } });
  }
  if (error.message === 'WAR_TERRITORY_UNAVAILABLE' || error.message === 'INVALID_TERRITORY') {
    return res.status(400).json({ event: 'error.invalid_war_territory', params: {} });
  }
  if (error.message === 'RAID_NOTHING_TO_STEAL') {
    return res.status(409).json({ event: 'error.raid_nothing_to_steal', params: {} });
  }
  if (error.message === 'RAID_NO_CAPACITY') {
    return res.status(409).json({ event: 'error.raid_no_capacity', params: {} });
  }
  if (error.message === 'WAR_BUILDING_REQUIRED') {
    return res.status(400).json({ event: 'error.war_building_required', params: {} });
  }
  if (error.message === 'SABOTAGE_MIN_LEVEL') {
    return res.status(409).json({ event: 'error.sabotage_min_level', params: {} });
  }
  if (error.message === 'SABOTAGE_ALREADY_DONE') {
    return res.status(409).json({ event: 'error.sabotage_already_done', params: {} });
  }

  return next(error);
}

router.get('/hub', authenticate, async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    const hub = await crewWarService.getWarHubForPlayer(req.player!.id);
    return res.json({ event: 'crew_wars.hub', params: { hub } });
  } catch (error) {
    return next(error);
  }
});

router.get('/:id', authenticate, async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    const warId = Number(req.params.id);
    if (Number.isNaN(warId)) {
      return res.status(400).json({ event: 'error.invalid_war_id', params: {} });
    }
    const war = await crewWarService.getWarDetailForPlayer(req.player!.id, warId);
    return res.json({ event: 'crew_wars.detail', params: { war } });
  } catch (error) {
    return mapWarError(error, res, next);
  }
});

router.post('/declare', authenticate, async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    const { targetCrewId, warType } = declareWarSchema.parse(req.body);
    const war = await crewWarService.declareWar(req.player!.id, targetCrewId, warType);
    return res.status(201).json({ event: 'crew_wars.declared', params: { war } });
  } catch (error) {
    return mapWarError(error, res, next);
  }
});

router.post('/:id/join', authenticate, async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    const warId = Number(req.params.id);
    if (Number.isNaN(warId)) {
      return res.status(400).json({ event: 'error.invalid_war_id', params: {} });
    }
    const war = await crewWarService.joinWar(req.player!.id, warId);
    return res.json({ event: 'crew_wars.joined', params: { war } });
  } catch (error) {
    return mapWarError(error, res, next);
  }
});

router.post('/:id/actions', authenticate, async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    const warId = Number(req.params.id);
    if (Number.isNaN(warId)) {
      return res.status(400).json({ event: 'error.invalid_war_id', params: {} });
    }
    const { actionType, targetPlayerId, territoryKey, lootTarget, sabotageBuilding } = actionSchema.parse(req.body);
    const war = await crewWarService.performWarAction(
      req.player!.id,
      warId,
      actionType,
      targetPlayerId,
      territoryKey,
      lootTarget,
      sabotageBuilding,
    );
    return res.json({ event: 'crew_wars.action_completed', params: { war } });
  } catch (error) {
    return mapWarError(error, res, next);
  }
});

export default router;