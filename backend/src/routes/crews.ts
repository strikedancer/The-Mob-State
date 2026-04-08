import { Router, Response, NextFunction } from 'express';
import { authenticate, AuthRequest } from '../middleware/authenticate';
import * as crewService from '../services/crewService';
import * as crewStorageService from '../services/crewStorageService';
import {
  getCrewBuildingStatus,
  purchaseCrewBuilding,
  upgradeCrewBuilding,
  type CrewBuildingType,
} from '../services/crewBuildingService';
import { crewChatService } from '../services/crewChatService';
import { worldEventService } from '../services/worldEventService';
import { emailService } from '../services/emailService';
import { notificationService } from '../services/notificationService';
import { translationService } from '../services/translationService';
import prisma from '../lib/prisma';
import { z } from 'zod';

const router = Router();

// Validation schemas
const createCrewSchema = z.object({
  name: z.string().min(3).max(50),
});
const crewBankSchema = z.object({
  amount: z.number().int().positive(),
});

function getRoleLabel(role: string, language: 'en' | 'nl'): string {
  const labels = {
    en: { leader: 'Leader', co_leader: 'Co-Leader', member: 'Member' },
    nl: { leader: 'Leader', co_leader: 'Co-Leider', member: 'Lid' },
  };

  const langLabels = labels[language] ?? labels.en;
  return langLabels[role as keyof typeof langLabels] ?? role;
}

/**
 * POST /crews/create
 * Create a new crew with the authenticated player as leader
 */
router.post(
  '/create',
  authenticate,
  async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const { name } = createCrewSchema.parse(req.body);
      const playerId = req.player!.id;

      const crew = await crewService.createCrew({
        name,
        leaderId: playerId,
      });

      return res.status(201).json({
        event: 'crew.created',
        params: { crew },
      });
    } catch (error: unknown) {
      if (error instanceof Error) {
        if (error.message === 'INVALID_CREW_NAME') {
          return res.status(400).json({
            event: 'error.invalid_crew_name',
            params: {},
          });
        }
        if (error.message === 'ALREADY_IN_CREW') {
          return res.status(400).json({
            event: 'error.already_in_crew',
            params: {},
          });
        }
        if (error.message === 'CREW_NAME_TAKEN') {
          return res.status(400).json({
            event: 'error.crew_name_taken',
            params: {},
          });
        }
      }
      return next(error);
    }
  }
);

/**
 * POST /crews/:id/join
 * Join an existing crew
 */
router.post(
  '/:id/join',
  authenticate,
  async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const crewId = parseInt(req.params.id as string);
      if (isNaN(crewId)) {
        return res.status(400).json({
          event: 'error.invalid_crew_id',
          params: {},
        });
      }

      const playerId = req.player!.id;

      const request = await crewService.requestJoinCrew(crewId, playerId);

      const leaders = await prisma.crewMember.findMany({
        where: { crewId, role: 'leader' },
        include: {
          player: {
            select: {
              id: true,
              username: true,
              email: true,
              preferredLanguage: true,
            },
          },
        },
      });

      for (const leader of leaders) {
        const language = translationService.getPlayerLanguage(leader.player);
        if (leader.player.email) {
          await emailService.sendCrewJoinRequestEmail(
            leader.player.email,
            leader.player.username,
            request.player.username,
            request.crew.name,
            language
          );
        }

        await notificationService.sendCrewJoinRequestNotification(
          leader.player.id,
          request.player.username,
          request.crew.name,
          language
        );
      }

      return res.json({
        event: 'crew.join_requested',
        params: { request },
      });
    } catch (error: unknown) {
      if (error instanceof Error) {
        if (error.message === 'CREW_NOT_FOUND') {
          return res.status(404).json({
            event: 'error.crew_not_found',
            params: {},
          });
        }
        if (error.message === 'ALREADY_IN_CREW') {
          return res.status(400).json({
            event: 'error.already_in_crew',
            params: {},
          });
        }
        if (error.message === 'REQUEST_ALREADY_PENDING') {
          return res.status(400).json({
            event: 'error.request_already_pending',
            params: {},
          });
        }
      }
      return next(error);
    }
  }
);

/**
 * POST /crews/leave
 * Leave current crew
 */
router.post('/leave', authenticate, async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    const playerId = req.player!.id;

    await crewService.leaveCrew(playerId);

    return res.json({
      event: 'crew.left',
      params: {},
    });
  } catch (error: unknown) {
    if (error instanceof Error) {
      if (error.message === 'NOT_IN_CREW') {
        return res.status(400).json({
          event: 'error.not_in_crew',
          params: {},
        });
      }
      if (error.message === 'LEADER_CANNOT_LEAVE') {
        return res.status(400).json({
          event: 'error.leader_cannot_leave',
          params: {},
        });
      }
    }
    return next(error);
  }
});

/**
 * DELETE /crews/:id
 * Delete crew (leader only)
 */
router.delete(
  '/:id',
  authenticate,
  async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const crewId = parseInt(req.params.id as string);
      const currentPlayerId = req.player!.id;

      if (isNaN(crewId)) {
        return res.status(400).json({
          event: 'error.invalid_crew_id',
          params: {},
        });
      }

      const isLeader = await crewService.isCrewLeader(currentPlayerId, crewId);
      if (!isLeader) {
        return res.status(403).json({
          event: 'error.not_crew_leader',
          params: {},
        });
      }

      await crewService.deleteCrew(crewId);

      return res.json({
        event: 'crew.deleted',
        params: {},
      });
    } catch (error: unknown) {
      return next(error);
    }
  }
);

/**
 * GET /crews/mine
 * Get player's current crew
 */
router.get('/mine', authenticate, async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    const playerId = req.player!.id;
    const crew = await crewService.getPlayerCrew(playerId);

    if (!crew) {
      return res.json({
        event: 'crew.none',
        params: { crew: null },
      });
    }

    return res.json({
      event: 'crew.mine',
      params: { crew },
    });
  } catch (error: unknown) {
    return next(error);
  }
});

/**
 * GET /crews/:id
 * Get crew by ID
 */
router.get('/:id', async (req, res: Response, next: NextFunction) => {
  try {
    const crewId = parseInt(req.params.id as string);
    if (isNaN(crewId)) {
      return res.status(400).json({
        event: 'error.invalid_crew_id',
        params: {},
      });
    }

    const crew = await crewService.getCrewById(crewId);

    return res.json({
      event: 'crew.info',
      params: { crew },
    });
  } catch (error: unknown) {
    if (error instanceof Error) {
      if (error.message === 'CREW_NOT_FOUND') {
        return res.status(404).json({
          event: 'error.crew_not_found',
          params: {},
        });
      }
    }
    return next(error);
  }
});

/**
 * GET /crews
 * Get all crews
 */
router.get('/', async (_req, res: Response, next: NextFunction) => {
  try {
    const crews = await crewService.getAllCrews();

    return res.json({
      event: 'crews.list',
      params: { crews },
    });
  } catch (error: unknown) {
    return next(error);
  }
});

/**
 * GET /crews/:id/requests
 * List pending join requests (leader only)
 */
router.get(
  '/:id/requests',
  authenticate,
  async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const crewId = parseInt(req.params.id as string);
      const currentPlayerId = req.player!.id;

      if (isNaN(crewId)) {
        return res.status(400).json({
          event: 'error.invalid_crew_id',
          params: {},
        });
      }

      const isLeader = await crewService.isCrewLeader(currentPlayerId, crewId);
      if (!isLeader) {
        return res.status(403).json({
          event: 'error.not_crew_leader',
          params: {},
        });
      }

      const requests = await crewService.getJoinRequests(crewId);

      return res.json({
        event: 'crew.join_requests',
        params: { requests },
      });
    } catch (error: unknown) {
      return next(error);
    }
  }
);

/**
 * POST /crews/:id/requests/:requestId/approve
 * Approve join request (leader only)
 */
router.post(
  '/:id/requests/:requestId/approve',
  authenticate,
  async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const crewId = parseInt(req.params.id as string);
      const requestId = parseInt(req.params.requestId as string);
      const currentPlayerId = req.player!.id;

      if (isNaN(crewId) || isNaN(requestId)) {
        return res.status(400).json({
          event: 'error.invalid_input',
          params: {},
        });
      }

      const isLeader = await crewService.isCrewLeader(currentPlayerId, crewId);
      if (!isLeader) {
        return res.status(403).json({
          event: 'error.not_crew_leader',
          params: {},
        });
      }

      const request = await prisma.crewJoinRequest.findUnique({
        where: { id: requestId },
        include: {
          player: {
            select: { id: true, username: true, email: true, preferredLanguage: true },
          },
          crew: { select: { name: true } },
        },
      });

      const crew = await crewService.approveJoinRequest(crewId, requestId);

      if (request) {
        const language = translationService.getPlayerLanguage(request.player);
        if (request.player.email) {
          await emailService.sendCrewJoinApprovedEmail(
            request.player.email,
            request.player.username,
            request.crew.name,
            language
          );
        }

        await notificationService.sendCrewJoinApprovedNotification(
          request.player.id,
          request.crew.name,
          language
        );
      }

      return res.json({
        event: 'crew.join_approved',
        params: { crew },
      });
    } catch (error: unknown) {
      if (error instanceof Error) {
        if (error.message === 'REQUEST_NOT_FOUND') {
          return res.status(404).json({
            event: 'error.request_not_found',
            params: {},
          });
        }
        if (error.message === 'REQUEST_NOT_PENDING') {
          return res.status(400).json({
            event: 'error.request_not_pending',
            params: {},
          });
        }
        if (error.message === 'ALREADY_IN_CREW') {
          return res.status(400).json({
            event: 'error.already_in_crew',
            params: {},
          });
        }
        if (error.message === 'CREW_FULL') {
          return res.status(400).json({
            event: 'error.crew_full',
            params: {},
          });
        }
      }
      return next(error);
    }
  }
);

/**
 * POST /crews/:id/requests/:requestId/reject
 * Reject join request (leader only)
 */
router.post(
  '/:id/requests/:requestId/reject',
  authenticate,
  async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const crewId = parseInt(req.params.id as string);
      const requestId = parseInt(req.params.requestId as string);
      const currentPlayerId = req.player!.id;

      if (isNaN(crewId) || isNaN(requestId)) {
        return res.status(400).json({
          event: 'error.invalid_input',
          params: {},
        });
      }

      const isLeader = await crewService.isCrewLeader(currentPlayerId, crewId);
      if (!isLeader) {
        return res.status(403).json({
          event: 'error.not_crew_leader',
          params: {},
        });
      }

      const request = await prisma.crewJoinRequest.findUnique({
        where: { id: requestId },
        include: {
          player: {
            select: { id: true, username: true, email: true, preferredLanguage: true },
          },
          crew: { select: { name: true } },
        },
      });

      await crewService.rejectJoinRequest(crewId, requestId);

      if (request) {
        const language = translationService.getPlayerLanguage(request.player);
        if (request.player.email) {
          await emailService.sendCrewJoinRejectedEmail(
            request.player.email,
            request.player.username,
            request.crew.name,
            language
          );
        }

        await notificationService.sendCrewJoinRejectedNotification(
          request.player.id,
          request.crew.name,
          language
        );
      }

      return res.json({
        event: 'crew.join_rejected',
        params: { requestId },
      });
    } catch (error: unknown) {
      if (error instanceof Error) {
        if (error.message === 'REQUEST_NOT_FOUND') {
          return res.status(404).json({
            event: 'error.request_not_found',
            params: {},
          });
        }
        if (error.message === 'REQUEST_NOT_PENDING') {
          return res.status(400).json({
            event: 'error.request_not_pending',
            params: {},
          });
        }
      }
      return next(error);
    }
  }
);

/**
 * POST /crews/:id/members/:playerId/kick
 * Kick member (leader only)
 */
router.post(
  '/:id/members/:playerId/kick',
  authenticate,
  async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const crewId = parseInt(req.params.id as string);
      const targetPlayerId = parseInt(req.params.playerId as string);
      const currentPlayerId = req.player!.id;

      if (isNaN(crewId) || isNaN(targetPlayerId)) {
        return res.status(400).json({
          event: 'error.invalid_input',
          params: {},
        });
      }

      const isLeader = await crewService.isCrewLeader(currentPlayerId, crewId);
      if (!isLeader) {
        return res.status(403).json({
          event: 'error.not_crew_leader',
          params: {},
        });
      }

      const targetMembership = await prisma.crewMember.findFirst({
        where: { crewId, playerId: targetPlayerId },
        include: {
          player: { select: { id: true, username: true, email: true, preferredLanguage: true } },
          crew: { select: { name: true } },
        },
      });

      await crewService.kickMember(crewId, targetPlayerId);

      if (targetMembership) {
        const language = translationService.getPlayerLanguage(targetMembership.player);
        if (targetMembership.player.email) {
          await emailService.sendCrewKickedEmail(
            targetMembership.player.email,
            targetMembership.player.username,
            targetMembership.crew.name,
            language
          );
        }

        await notificationService.sendCrewKickedNotification(
          targetMembership.player.id,
          targetMembership.crew.name,
          language
        );
      }

      return res.json({
        event: 'crew.member_kicked',
        params: { playerId: targetPlayerId },
      });
    } catch (error: unknown) {
      if (error instanceof Error) {
        if (error.message === 'MEMBER_NOT_FOUND') {
          return res.status(404).json({
            event: 'error.member_not_found',
            params: {},
          });
        }
        if (error.message === 'CANNOT_KICK_LEADER') {
          return res.status(400).json({
            event: 'error.cannot_kick_leader',
            params: {},
          });
        }
      }
      return next(error);
    }
  }
);

/**
 * POST /crews/:id/members/:playerId/promote
 * Promote member to co-leader (leader only)
 */
router.post(
  '/:id/members/:playerId/promote',
  authenticate,
  async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const crewId = parseInt(req.params.id as string);
      const targetPlayerId = parseInt(req.params.playerId as string);
      const currentPlayerId = req.player!.id;

      if (isNaN(crewId) || isNaN(targetPlayerId)) {
        return res.status(400).json({
          event: 'error.invalid_input',
          params: {},
        });
      }

      const isLeader = await crewService.isCrewLeader(currentPlayerId, crewId);
      if (!isLeader) {
        return res.status(403).json({
          event: 'error.not_crew_leader',
          params: {},
        });
      }

      const targetMembership = await prisma.crewMember.findFirst({
        where: { crewId, playerId: targetPlayerId },
        include: {
          player: { select: { id: true, username: true, email: true, preferredLanguage: true } },
          crew: { select: { name: true } },
        },
      });

      await crewService.changeMemberRole(crewId, targetPlayerId, 'co_leader');

      if (targetMembership) {
        const language = translationService.getPlayerLanguage(targetMembership.player);
        const roleLabel = getRoleLabel('co_leader', language);
        if (targetMembership.player.email) {
          await emailService.sendCrewRoleChangedEmail(
            targetMembership.player.email,
            targetMembership.player.username,
            targetMembership.crew.name,
            roleLabel,
            language
          );
        }

        await notificationService.sendCrewRoleChangedNotification(
          targetMembership.player.id,
          targetMembership.crew.name,
          roleLabel,
          language
        );
      }

      return res.json({
        event: 'crew.member_promoted',
        params: { playerId: targetPlayerId },
      });
    } catch (error: unknown) {
      if (error instanceof Error) {
        if (error.message === 'MEMBER_NOT_FOUND') {
          return res.status(404).json({
            event: 'error.member_not_found',
            params: {},
          });
        }
        if (error.message === 'CANNOT_CHANGE_LEADER') {
          return res.status(400).json({
            event: 'error.cannot_change_leader',
            params: {},
          });
        }
      }
      return next(error);
    }
  }
);

/**
 * POST /crews/:id/members/:playerId/demote
 * Demote co-leader to member (leader only)
 */
router.post(
  '/:id/members/:playerId/demote',
  authenticate,
  async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const crewId = parseInt(req.params.id as string);
      const targetPlayerId = parseInt(req.params.playerId as string);
      const currentPlayerId = req.player!.id;

      if (isNaN(crewId) || isNaN(targetPlayerId)) {
        return res.status(400).json({
          event: 'error.invalid_input',
          params: {},
        });
      }

      const isLeader = await crewService.isCrewLeader(currentPlayerId, crewId);
      if (!isLeader) {
        return res.status(403).json({
          event: 'error.not_crew_leader',
          params: {},
        });
      }

      const targetMembership = await prisma.crewMember.findFirst({
        where: { crewId, playerId: targetPlayerId },
        include: {
          player: { select: { id: true, username: true, email: true, preferredLanguage: true } },
          crew: { select: { name: true } },
        },
      });

      await crewService.changeMemberRole(crewId, targetPlayerId, 'member');

      if (targetMembership) {
        const language = translationService.getPlayerLanguage(targetMembership.player);
        const roleLabel = getRoleLabel('member', language);
        if (targetMembership.player.email) {
          await emailService.sendCrewRoleChangedEmail(
            targetMembership.player.email,
            targetMembership.player.username,
            targetMembership.crew.name,
            roleLabel,
            language
          );
        }

        await notificationService.sendCrewRoleChangedNotification(
          targetMembership.player.id,
          targetMembership.crew.name,
          roleLabel,
          language
        );
      }

      return res.json({
        event: 'crew.member_demoted',
        params: { playerId: targetPlayerId },
      });
    } catch (error: unknown) {
      if (error instanceof Error) {
        if (error.message === 'MEMBER_NOT_FOUND') {
          return res.status(404).json({
            event: 'error.member_not_found',
            params: {},
          });
        }
        if (error.message === 'CANNOT_CHANGE_LEADER') {
          return res.status(400).json({
            event: 'error.cannot_change_leader',
            params: {},
          });
        }
      }
      return next(error);
    }
  }
);

/**
 * POST /crews/:id/bank/deposit
 * Deposit to crew bank (members allowed)
 */
router.post(
  '/:id/bank/deposit',
  authenticate,
  async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const crewId = parseInt(req.params.id as string);
      const currentPlayerId = req.player!.id;

      if (isNaN(crewId)) {
        return res.status(400).json({
          event: 'error.invalid_crew_id',
          params: {},
        });
      }

      const isMember = await crewService.isCrewMember(currentPlayerId, crewId);
      if (!isMember) {
        return res.status(403).json({
          event: 'error.not_in_crew',
          params: {},
        });
      }

      const { amount } = crewBankSchema.parse(req.body);
      const result = await crewService.depositToCrewBank(crewId, currentPlayerId, amount);

      return res.json({
        event: 'crew.bank_deposit',
        params: result,
      });
    } catch (error: unknown) {
      if (error instanceof Error) {
        if (error.message === 'INVALID_AMOUNT') {
          return res.status(400).json({
            event: 'error.invalid_amount',
            params: {},
          });
        }
        if (error.message === 'INSUFFICIENT_FUNDS') {
          return res.status(400).json({
            event: 'error.insufficient_funds',
            params: {},
          });
        }
        if (error.message === 'CASH_STORAGE_NOT_OWNED') {
          return res.status(400).json({
            event: 'error.cash_storage_not_owned',
            params: {},
          });
        }
        if (error.message === 'CASH_STORAGE_FULL') {
          return res.status(400).json({
            event: 'error.cash_storage_full',
            params: {},
          });
        }
      }
      return next(error);
    }
  }
);

/**
 * POST /crews/:id/bank/withdraw
 * Withdraw from crew bank (leader only)
 */
router.post(
  '/:id/bank/withdraw',
  authenticate,
  async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const crewId = parseInt(req.params.id as string);
      const currentPlayerId = req.player!.id;

      if (isNaN(crewId)) {
        return res.status(400).json({
          event: 'error.invalid_crew_id',
          params: {},
        });
      }

      const isLeader = await crewService.isCrewLeader(currentPlayerId, crewId);
      if (!isLeader) {
        return res.status(403).json({
          event: 'error.not_crew_leader',
          params: {},
        });
      }

      const { amount } = crewBankSchema.parse(req.body);
      const result = await crewService.withdrawFromCrewBank(crewId, currentPlayerId, amount);

      return res.json({
        event: 'crew.bank_withdraw',
        params: result,
      });
    } catch (error: unknown) {
      if (error instanceof Error) {
        if (error.message === 'INVALID_AMOUNT') {
          return res.status(400).json({
            event: 'error.invalid_amount',
            params: {},
          });
        }
        if (error.message === 'CASH_STORAGE_NOT_OWNED') {
          return res.status(400).json({
            event: 'error.cash_storage_not_owned',
            params: {},
          });
        }
        if (error.message === 'INSUFFICIENT_CREW_FUNDS') {
          return res.status(400).json({
            event: 'error.insufficient_crew_funds',
            params: {},
          });
        }
      }
      return next(error);
    }
  }
);

/**
 * GET /crews/:id/buildings
 * Get crew building status
 */
router.get(
  '/:id/buildings',
  authenticate,
  async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const crewId = parseInt(req.params.id as string);
      const currentPlayerId = req.player!.id;

      if (isNaN(crewId)) {
        return res.status(400).json({
          event: 'error.invalid_crew_id',
          params: {},
        });
      }

      const isMember = await crewService.isCrewMember(currentPlayerId, crewId);
      if (!isMember) {
        return res.status(403).json({
          event: 'error.not_in_crew',
          params: {},
        });
      }

      const buildings = await getCrewBuildingStatus(crewId);

      return res.json({
        event: 'crew.buildings',
        params: { buildings },
      });
    } catch (error: unknown) {
      return next(error);
    }
  }
);

/**
 * POST /crews/:id/buildings/:type/purchase
 * Purchase crew building (leader only)
 */
router.post(
  '/:id/buildings/:type/purchase',
  authenticate,
  async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const crewId = parseInt(req.params.id as string);
      const currentPlayerId = req.player!.id;
      const type = req.params.type as CrewBuildingType;
      const { style } = req.body as { style?: string };

      if (isNaN(crewId)) {
        return res.status(400).json({
          event: 'error.invalid_crew_id',
          params: {},
        });
      }

      const isLeader = await crewService.isCrewLeader(currentPlayerId, crewId);
      if (!isLeader) {
        return res.status(403).json({
          event: 'error.not_crew_leader',
          params: {},
        });
      }

      const result = await purchaseCrewBuilding(crewId, currentPlayerId, type, style ?? 'camping');

      return res.json({
        event: 'crew.building_purchased',
        params: { type, level: result.level, style: result.style, cost: result.cost },
      });
    } catch (error: unknown) {
      if (error instanceof Error) {
        if (error.message === 'INVALID_BUILDING_STYLE') {
          return res.status(400).json({
            event: 'error.invalid_building_style',
            params: {},
          });
        }
        if (error.message === 'BUILDING_ALREADY_OWNED') {
          return res.status(400).json({
            event: 'error.building_already_owned',
            params: {},
          });
        }
        if (error.message === 'HQ_STYLE_LOCKED') {
          return res.status(400).json({
            event: 'error.hq_style_locked',
            params: {},
          });
        }
        if (error.message === 'HQ_STYLE_MAX') {
          return res.status(400).json({
            event: 'error.hq_style_max',
            params: {},
          });
        }
        if (error.message === 'HQ_VIP_REQUIRED') {
          return res.status(400).json({
            event: 'error.hq_vip_required',
            params: {},
          });
        }
        if (error.message === 'HQ_SIDE_BUILDINGS_INCOMPLETE') {
          return res.status(400).json({
            event: 'error.hq_side_buildings_incomplete',
            params: {},
          });
        }
        if (error.message === 'INSUFFICIENT_CREW_FUNDS') {
          return res.status(400).json({
            event: 'error.insufficient_crew_funds',
            params: {},
          });
        }
      }
      return next(error);
    }
  }
);

/**
 * POST /crews/:id/buildings/:type/upgrade
 * Upgrade crew building (leader only)
 */
router.post(
  '/:id/buildings/:type/upgrade',
  authenticate,
  async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const crewId = parseInt(req.params.id as string);
      const currentPlayerId = req.player!.id;
      const type = req.params.type as CrewBuildingType;

      if (isNaN(crewId)) {
        return res.status(400).json({
          event: 'error.invalid_crew_id',
          params: {},
        });
      }

      const isLeader = await crewService.isCrewLeader(currentPlayerId, crewId);
      if (!isLeader) {
        return res.status(403).json({
          event: 'error.not_crew_leader',
          params: {},
        });
      }

      const result = await upgradeCrewBuilding(crewId, currentPlayerId, type);

      return res.json({
        event: 'crew.building_upgraded',
        params: { type, level: result.level, style: result.style, cost: result.cost },
      });
    } catch (error: unknown) {
      if (error instanceof Error) {
        if (error.message === 'BUILDING_NOT_OWNED') {
          return res.status(400).json({
            event: 'error.building_not_owned',
            params: {},
          });
        }
        if (error.message === 'BUILDING_MAX_LEVEL') {
          return res.status(400).json({
            event: 'error.building_max_level',
            params: {},
          });
        }
        if (error.message === 'HQ_LEVEL_TOO_LOW') {
          return res.status(400).json({
            event: 'error.hq_level_too_low',
            params: {},
          });
        }
        if (error.message === 'BUILDING_VIP_REQUIRED') {
          return res.status(400).json({
            event: 'error.building_vip_required',
            params: {},
          });
        }
        if (error.message === 'HQ_SIDE_BUILDINGS_INCOMPLETE') {
          return res.status(400).json({
            event: 'error.hq_side_buildings_incomplete',
            params: {},
          });
        }
        if (error.message === 'HQ_VIP_REQUIRED') {
          return res.status(400).json({
            event: 'error.hq_vip_required',
            params: {},
          });
        }
        if (error.message === 'INSUFFICIENT_CREW_FUNDS') {
          return res.status(400).json({
            event: 'error.insufficient_crew_funds',
            params: {},
          });
        }
      }
      return next(error);
    }
  }
);

/**
 * GET /crews/:id/storage
 * Get crew storage summary
 */
router.get(
  '/:id/storage',
  authenticate,
  async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const crewId = parseInt(req.params.id as string);
      const currentPlayerId = req.player!.id;

      if (isNaN(crewId)) {
        return res.status(400).json({
          event: 'error.invalid_crew_id',
          params: {},
        });
      }

      const isMember = await crewService.isCrewMember(currentPlayerId, crewId);
      if (!isMember) {
        return res.status(403).json({
          event: 'error.not_in_crew',
          params: {},
        });
      }

      const storage = await crewStorageService.getCrewStorageSummary(crewId);

      return res.json({
        event: 'crew.storage',
        params: { storage },
      });
    } catch (error: unknown) {
      return next(error);
    }
  }
);

/**
 * POST /crews/:id/storage/cars/deposit
 * Deposit car to crew storage
 */
router.post(
  '/:id/storage/cars/deposit',
  authenticate,
  async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const crewId = parseInt(req.params.id as string);
      const currentPlayerId = req.player!.id;
      const { vehicleInventoryId } = req.body as { vehicleInventoryId?: number };

      if (isNaN(crewId) || !vehicleInventoryId) {
        return res.status(400).json({
          event: 'error.invalid_input',
          params: {},
        });
      }

      const isMember = await crewService.isCrewMember(currentPlayerId, crewId);
      if (!isMember) {
        return res.status(403).json({
          event: 'error.not_in_crew',
          params: {},
        });
      }

      await crewStorageService.depositCrewCar(crewId, currentPlayerId, vehicleInventoryId);

      return res.json({
        event: 'crew.storage_car_deposit',
        params: {},
      });
    } catch (error: unknown) {
      if (error instanceof Error) {
        if (error.message === 'CAR_STORAGE_NOT_OWNED') {
          return res.status(400).json({
            event: 'error.car_storage_not_owned',
            params: {},
          });
        }
        if (error.message === 'CAR_STORAGE_FULL') {
          return res.status(400).json({
            event: 'error.car_storage_full',
            params: {},
          });
        }
        if (error.message === 'VEHICLE_NOT_FOUND') {
          return res.status(404).json({
            event: 'error.vehicle_not_found',
            params: {},
          });
        }
        if (error.message === 'NOT_OWNER') {
          return res.status(403).json({
            event: 'error.not_owner',
            params: {},
          });
        }
        if (error.message === 'VEHICLE_IN_TRANSIT') {
          return res.status(400).json({
            event: 'error.vehicle_in_transit',
            params: {},
          });
        }
      }
      return next(error);
    }
  }
);

/**
 * POST /crews/:id/storage/boats/deposit
 * Deposit boat to crew storage
 */
router.post(
  '/:id/storage/boats/deposit',
  authenticate,
  async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const crewId = parseInt(req.params.id as string);
      const currentPlayerId = req.player!.id;
      const { vehicleInventoryId } = req.body as { vehicleInventoryId?: number };

      if (isNaN(crewId) || !vehicleInventoryId) {
        return res.status(400).json({
          event: 'error.invalid_input',
          params: {},
        });
      }

      const isMember = await crewService.isCrewMember(currentPlayerId, crewId);
      if (!isMember) {
        return res.status(403).json({
          event: 'error.not_in_crew',
          params: {},
        });
      }

      await crewStorageService.depositCrewBoat(crewId, currentPlayerId, vehicleInventoryId);

      return res.json({
        event: 'crew.storage_boat_deposit',
        params: {},
      });
    } catch (error: unknown) {
      if (error instanceof Error) {
        if (error.message === 'BOAT_STORAGE_NOT_OWNED') {
          return res.status(400).json({
            event: 'error.boat_storage_not_owned',
            params: {},
          });
        }
        if (error.message === 'BOAT_STORAGE_FULL') {
          return res.status(400).json({
            event: 'error.boat_storage_full',
            params: {},
          });
        }
        if (error.message === 'VEHICLE_NOT_FOUND') {
          return res.status(404).json({
            event: 'error.vehicle_not_found',
            params: {},
          });
        }
        if (error.message === 'NOT_OWNER') {
          return res.status(403).json({
            event: 'error.not_owner',
            params: {},
          });
        }
        if (error.message === 'VEHICLE_IN_TRANSIT') {
          return res.status(400).json({
            event: 'error.vehicle_in_transit',
            params: {},
          });
        }
      }
      return next(error);
    }
  }
);

/**
 * POST /crews/:id/storage/weapons/deposit
 * Deposit weapons to crew storage
 */
router.post(
  '/:id/storage/weapons/deposit',
  authenticate,
  async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const crewId = parseInt(req.params.id as string);
      const currentPlayerId = req.player!.id;
      const { weaponId, quantity } = req.body as { weaponId?: string; quantity?: number };

      if (isNaN(crewId) || !weaponId || !quantity) {
        return res.status(400).json({
          event: 'error.invalid_input',
          params: {},
        });
      }

      const isMember = await crewService.isCrewMember(currentPlayerId, crewId);
      if (!isMember) {
        return res.status(403).json({
          event: 'error.not_in_crew',
          params: {},
        });
      }

      await crewStorageService.depositCrewWeapon(crewId, currentPlayerId, weaponId, quantity);

      return res.json({
        event: 'crew.storage_weapon_deposit',
        params: {},
      });
    } catch (error: unknown) {
      if (error instanceof Error) {
        if (error.message === 'WEAPON_STORAGE_NOT_OWNED') {
          return res.status(400).json({
            event: 'error.weapon_storage_not_owned',
            params: {},
          });
        }
        if (error.message === 'WEAPON_STORAGE_FULL') {
          return res.status(400).json({
            event: 'error.weapon_storage_full',
            params: {},
          });
        }
        if (error.message === 'INSUFFICIENT_WEAPONS') {
          return res.status(400).json({
            event: 'error.insufficient_weapons',
            params: {},
          });
        }
        if (error.message === 'INVALID_QUANTITY') {
          return res.status(400).json({
            event: 'error.invalid_quantity',
            params: {},
          });
        }
      }
      return next(error);
    }
  }
);

/**
 * POST /crews/:id/storage/ammo/deposit
 * Deposit ammo to crew storage
 */
router.post(
  '/:id/storage/ammo/deposit',
  authenticate,
  async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const crewId = parseInt(req.params.id as string);
      const currentPlayerId = req.player!.id;
      const { ammoType, quantity } = req.body as { ammoType?: string; quantity?: number };

      if (isNaN(crewId) || !ammoType || !quantity) {
        return res.status(400).json({
          event: 'error.invalid_input',
          params: {},
        });
      }

      const isMember = await crewService.isCrewMember(currentPlayerId, crewId);
      if (!isMember) {
        return res.status(403).json({
          event: 'error.not_in_crew',
          params: {},
        });
      }

      await crewStorageService.depositCrewAmmo(crewId, currentPlayerId, ammoType, quantity);

      return res.json({
        event: 'crew.storage_ammo_deposit',
        params: {},
      });
    } catch (error: unknown) {
      if (error instanceof Error) {
        if (error.message === 'AMMO_STORAGE_NOT_OWNED') {
          return res.status(400).json({
            event: 'error.ammo_storage_not_owned',
            params: {},
          });
        }
        if (error.message === 'AMMO_STORAGE_FULL') {
          return res.status(400).json({
            event: 'error.ammo_storage_full',
            params: {},
          });
        }
        if (error.message === 'INSUFFICIENT_AMMO') {
          return res.status(400).json({
            event: 'error.insufficient_ammo',
            params: {},
          });
        }
        if (error.message === 'INVALID_QUANTITY') {
          return res.status(400).json({
            event: 'error.invalid_quantity',
            params: {},
          });
        }
      }
      return next(error);
    }
  }
);

/**
 * POST /crews/:id/storage/drugs/deposit
 * Deposit drugs to crew storage
 */
router.post(
  '/:id/storage/drugs/deposit',
  authenticate,
  async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const crewId = parseInt(req.params.id as string);
      const currentPlayerId = req.player!.id;
      const { goodType, quantity } = req.body as { goodType?: string; quantity?: number };

      if (isNaN(crewId) || !goodType || !quantity) {
        return res.status(400).json({
          event: 'error.invalid_input',
          params: {},
        });
      }

      const isMember = await crewService.isCrewMember(currentPlayerId, crewId);
      if (!isMember) {
        return res.status(403).json({
          event: 'error.not_in_crew',
          params: {},
        });
      }

      await crewStorageService.depositCrewDrugs(crewId, currentPlayerId, goodType, quantity);

      return res.json({
        event: 'crew.storage_drug_deposit',
        params: {},
      });
    } catch (error: unknown) {
      if (error instanceof Error) {
        if (error.message === 'DRUG_STORAGE_NOT_OWNED') {
          return res.status(400).json({
            event: 'error.drug_storage_not_owned',
            params: {},
          });
        }
        if (error.message === 'DRUG_STORAGE_FULL') {
          return res.status(400).json({
            event: 'error.drug_storage_full',
            params: {},
          });
        }
        if (error.message === 'INSUFFICIENT_DRUGS') {
          return res.status(400).json({
            event: 'error.insufficient_drugs',
            params: {},
          });
        }
        if (error.message === 'INVALID_QUANTITY') {
          return res.status(400).json({
            event: 'error.invalid_quantity',
            params: {},
          });
        }
      }
      return next(error);
    }
  }
);

/**
 * GET /crews/:id/stats
 * Get crew stats
 */
router.get(
  '/:id/stats',
  authenticate,
  async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const crewId = parseInt(req.params.id as string);

      if (isNaN(crewId)) {
        return res.status(400).json({
          event: 'error.invalid_crew_id',
          params: {},
        });
      }

      const stats = await crewService.getCrewStats(crewId);

      return res.json({
        event: 'crew.stats',
        params: { stats },
      });
    } catch (error: unknown) {
      return next(error);
    }
  }
);

/**
 * POST /crews/:id/members/:playerId/trust
 * Adjust trust score for a crew member (leader only)
 */
router.post(
  '/:id/members/:playerId/trust',
  authenticate,
  async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const crewId = parseInt(req.params.id as string);
      const targetPlayerId = parseInt(req.params.playerId as string);
      const currentPlayerId = req.player!.id;

      if (isNaN(crewId) || isNaN(targetPlayerId)) {
        return res.status(400).json({
          event: 'error.invalid_input',
          params: {},
        });
      }

      // Check if current player is leader
      const isLeader = await crewService.isCrewLeader(currentPlayerId, crewId);
      if (!isLeader) {
        return res.status(403).json({
          event: 'error.not_crew_leader',
          params: {},
        });
      }

      // Parse adjustment amount
      const { amount } = z.object({ amount: z.number().int() }).parse(req.body);

      const newTrust = await crewService.adjustTrust(crewId, targetPlayerId, amount);

      return res.json({
        event: 'crew.trust_adjusted',
        params: { playerId: targetPlayerId, trustScore: newTrust },
      });
    } catch (error: unknown) {
      if (error instanceof Error) {
        if (error.message === 'MEMBER_NOT_FOUND') {
          return res.status(404).json({
            event: 'error.member_not_found',
            params: {},
          });
        }
      }
      return next(error);
    }
  }
);

/**
 * GET /crews/:id/members/:playerId/trust
 * Get trust score for a crew member
 */
router.get('/:id/members/:playerId/trust', async (req, res: Response, next: NextFunction) => {
  try {
    const crewId = parseInt(req.params.id as string);
    const playerId = parseInt(req.params.playerId as string);

    if (isNaN(crewId) || isNaN(playerId)) {
      return res.status(400).json({
        event: 'error.invalid_input',
        params: {},
      });
    }

    const trustScore = await crewService.getMemberTrust(crewId, playerId);

    return res.json({
      event: 'crew.member_trust',
      params: { playerId, trustScore },
    });
  } catch (error: unknown) {
    if (error instanceof Error) {
      if (error.message === 'MEMBER_NOT_FOUND') {
        return res.status(404).json({
          event: 'error.member_not_found',
          params: {},
        });
      }
    }
    return next(error);
  }
});

/**
 * POST /crews/:id/liquidate
 * Liquidate a crew (disband, seize assets)
 * Requires attacker to be at least 5 levels higher than crew leader
 */
router.post(
  '/:id/liquidate',
  authenticate,
  async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const crewId = parseInt(req.params.id as string);
      const attackerId = req.player!.id;

      if (isNaN(crewId)) {
        return res.status(400).json({
          event: 'error.invalid_crew_id',
          params: {},
        });
      }

      const result = await crewService.liquidateCrew(crewId, attackerId);

      // Create world event for liquidation
      await worldEventService.createEvent('crew.liquidated', {
        attackerName: req.player!.username,
        crewName: result.crewName,
        assetsSeized: result.assetsSeized,
        memberCount: result.memberCount,
        leaderName: result.leaderName,
      });

      return res.json({
        event: 'crew.liquidated',
        params: result,
      });
    } catch (error: unknown) {
      if (error instanceof Error) {
        if (error.message === 'CREW_NOT_FOUND') {
          return res.status(404).json({
            event: 'error.crew_not_found',
            params: {},
          });
        }
        if (error.message === 'CANNOT_LIQUIDATE_OWN_CREW') {
          return res.status(400).json({
            event: 'error.cannot_liquidate_own_crew',
            params: {},
          });
        }
        if (error.message === 'INSUFFICIENT_POWER') {
          return res.status(403).json({
            event: 'error.insufficient_power',
            params: { required: 'Must be at least 5 levels higher than crew leader' },
          });
        }
      }
      return next(error);
    }
  }
);

/**
 * GET /crews/:id/messages
 * Get messages for a crew
 */
router.get(
  '/:id/messages',
  authenticate,
  async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const crewId = parseInt(req.params.id);
      const playerId = req.player!.id;
      const limit = req.query.limit ? parseInt(req.query.limit as string) : 50;

      if (isNaN(crewId)) {
        return res.status(400).json({
          event: 'error.invalid_crew_id',
          params: {},
        });
      }

      const messages = await crewChatService.getMessages(crewId, playerId, limit);

      return res.json({
        event: 'crew.messages',
        params: { messages },
      });
    } catch (error: any) {
      if (error.message === 'You are not a member of this crew') {
        return res.status(403).json({
          event: 'error.not_crew_member',
          params: {},
        });
      }
      return next(error);
    }
  }
);

/**
 * POST /crews/:id/messages
 * Send a message to crew chat
 */
router.post(
  '/:id/messages',
  authenticate,
  async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const crewId = parseInt(req.params.id);
      const playerId = req.player!.id;
      const { message } = req.body;

      if (isNaN(crewId)) {
        return res.status(400).json({
          event: 'error.invalid_crew_id',
          params: {},
        });
      }

      if (!message || typeof message !== 'string') {
        return res.status(400).json({
          event: 'error.invalid_message',
          params: {},
        });
      }

      const crewMessage = await crewChatService.sendMessage(crewId, playerId, message);

      return res.status(201).json({
        event: 'crew.message_sent',
        params: { message: crewMessage },
      });
    } catch (error: any) {
      if (error.message === 'You are not a member of this crew') {
        return res.status(403).json({
          event: 'error.not_crew_member',
          params: {},
        });
      }
      if (error.message === 'Message cannot be empty') {
        return res.status(400).json({
          event: 'error.empty_message',
          params: {},
        });
      }
      if (error.message === 'Message too long (max 500 characters)') {
        return res.status(400).json({
          event: 'error.message_too_long',
          params: { maxLength: 500 },
        });
      }
      return next(error);
    }
  }
);

/**
 * DELETE /crews/:id/messages/:messageId
 * Delete a crew message
 */
router.delete(
  '/:id/messages/:messageId',
  authenticate,
  async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const messageId = parseInt(req.params.messageId);
      const playerId = req.player!.id;

      if (isNaN(messageId)) {
        return res.status(400).json({
          event: 'error.invalid_message_id',
          params: {},
        });
      }

      await crewChatService.deleteMessage(messageId, playerId);

      return res.json({
        event: 'crew.message_deleted',
        params: { messageId },
      });
    } catch (error: any) {
      if (error.message === 'Message not found') {
        return res.status(404).json({
          event: 'error.message_not_found',
          params: {},
        });
      }
      if (error.message === 'Only the message sender or crew leader can delete messages') {
        return res.status(403).json({
          event: 'error.not_authorized',
          params: {},
        });
      }
      return next(error);
    }
  }
);

export default router;
