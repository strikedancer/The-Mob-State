import prisma from '../lib/prisma';
import * as crewService from './crewService';
import { worldEventService } from './worldEventService';
import { activityService } from './activityService';
import * as bankRobberyService from './bankRobberyService';
import { playerService } from './playerService';
import { emailService } from './emailService';
import { notificationService } from './notificationService';
import { translationService } from './translationService';
import heists from '../../content/heists.json';
import { timeProvider } from '../utils/timeProvider';
import config from '../config';

interface Heist {
  id: string;
  name: string;
  description: string;
  requiredMembers: number;
  minCrewLevel: number;
  basePayout: number;
  xpReward: number;
  duration: number;
  successRate: number;
  jailTimeOnFailure: number;
  difficulty: string;
}

interface HeistResult {
  success: boolean;
  payout?: number;
  xpGained?: number;
  xpLost?: number;
  sabotaged: boolean;
  sabotagedBy?: number;
  jailTime?: number;
  participants: number[];
}

async function notifyCrewHeistResult(
  crewId: number,
  crewName: string,
  heistName: string,
  success: boolean
): Promise<void> {
  try {
    const members = await prisma.crewMember.findMany({
      where: { crewId },
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

    for (const member of members) {
      const language = translationService.getPlayerLanguage(member.player);
      if (member.player.email) {
        await emailService.sendCrewHeistResultEmail(
          member.player.email,
          member.player.username,
          crewName,
          heistName,
          success,
          language
        );
      }

      await notificationService.sendCrewHeistResultNotification(
        member.player.id,
        crewName,
        heistName,
        success,
        language
      );
    }
  } catch (error) {
    console.error('[HeistService] Failed to notify crew heist result:', error);
  }
}

/**
 * Get all available heists
 */
export function getAvailableHeists(): Heist[] {
  return heists as Heist[];
}

/**
 * Get heist by ID
 */
export function getHeistById(heistId: string): Heist | undefined {
  return heists.find((h) => h.id === heistId) as Heist | undefined;
}

/**
 * Get heists available for a crew based on average member level
 */
export async function getHeistsForCrew(crewId: number): Promise<Heist[]> {
  const crew = await crewService.getCrewById(crewId);

  // Calculate average crew level
  const memberIds = crew.members.map((m) => m.playerId);
  const players = await prisma.player.findMany({
    where: { id: { in: memberIds } },
    select: { rank: true },
  });

  const avgLevel = players.reduce((sum, p) => sum + p.rank, 0) / players.length;

  return heists.filter((h) => h.minCrewLevel <= avgLevel) as Heist[];
}

/**
 * Start a heist with the crew
 */
export async function startHeist(
  heistId: string,
  crewId: number,
  leaderId: number
): Promise<HeistResult> {
  const heist = getHeistById(heistId);
  if (!heist) {
    throw new Error('HEIST_NOT_FOUND');
  }

  // Verify leader
  const isLeader = await crewService.isCrewLeader(leaderId, crewId);
  if (!isLeader) {
    throw new Error('NOT_CREW_LEADER');
  }

  // Get crew with members
  const crew = await crewService.getCrewById(crewId);

  // Check if crew has enough members
  if (crew.memberCount < heist.requiredMembers) {
    throw new Error('INSUFFICIENT_CREW_MEMBERS');
  }

  // Get all member details
  const memberIds = crew.members.map((m) => m.playerId);

  // Check if any member is currently in jail
  // For each member, get their most recent jail attempt and check if still active
  const now = timeProvider.now();

  for (const memberId of memberIds) {
    const latestJailAttempt = await prisma.crimeAttempt.findFirst({
      where: {
        playerId: memberId,
        jailed: true,
      },
      orderBy: {
        createdAt: 'desc',
      },
      select: {
        createdAt: true,
        jailTime: true,
      },
    });

    if (latestJailAttempt) {
      // Calculate release time: createdAt + jailTime (in minutes)
      const releaseTime = new Date(
        latestJailAttempt.createdAt.getTime() + latestJailAttempt.jailTime * 60 * 1000
      );

      // If release time is in the future, player is still jailed
      if (releaseTime > now) {
        throw new Error('CREW_MEMBER_IN_JAIL');
      }
    }
  }

  // Check for sabotage from low-trust members
  let sabotaged = false;
  let sabotagedBy: number | undefined;

  for (const member of crew.members) {
    const memberData = await prisma.crewMember.findFirst({
      where: {
        playerId: member.playerId,
        crewId: crewId,
      },
    });
    if (memberData) {
      const willSabotage = crewService.checkSabotage(memberData.trustScore);
      if (willSabotage) {
        sabotaged = true;
        sabotagedBy = member.playerId;
        break;
      }
    }
  }

  // Calculate success
  let finalSuccessRate = heist.successRate;
  if (sabotaged) {
    finalSuccessRate = finalSuccessRate * 0.3; // Sabotage reduces success by 70%
  }

  const roll = Math.random() * 100;
  const success = roll < finalSuccessRate;

  const result: HeistResult = {
    success,
    sabotaged,
    sabotagedBy,
    participants: memberIds,
  };

  if (success) {
    await prisma.crewHeistAttempt.create({
      data: {
        crewId,
        heistId,
        success: true,
      },
    });

    // Success - split rewards among all participants
    const payoutPerMember = Math.floor(heist.basePayout / crew.memberCount);
    const xpPerMember = Math.floor(heist.xpReward / crew.memberCount);

    // Update all members in a transaction
    await prisma.$transaction(async (tx: any) => {
      for (const playerId of memberIds) {
        await tx.player.update({
          where: { id: playerId },
          data: {
            money: { increment: payoutPerMember },
            xp: { increment: xpPerMember },
          },
        });
      }

      // Update crew bank balance
      await tx.crew.update({
        where: { id: crewId },
        data: {
          bankBalance: { increment: Math.floor(heist.basePayout * 0.1) }, // 10% to crew bank
        },
      });
    });

    result.payout = payoutPerMember;
    result.xpGained = xpPerMember;

    // If this is a bank heist, impact depositors
    if (heist.id === 'bank_heist') {
      const robberyResult = await bankRobberyService.executeBankRobbery(heist.basePayout);
      console.log(
        `💰 Bank heist impacted ${robberyResult.depositorCount} depositors (€${robberyResult.totalStolen.toLocaleString()} stolen)`
      );
    }

    // Create world event
    await worldEventService.createEvent(sabotaged ? 'heist.success_sabotaged' : 'heist.success', {
      heistName: heist.name,
      crewName: crew.name,
      payout: heist.basePayout,
      sabotaged,
    });

    // Log activity for each crew member
    for (const member of crew.members) {
      await activityService.logActivity(
        member.playerId,
        'HEIST',
        `Completed ${heist.name} with crew ${crew.name} and earned €${Math.floor(heist.basePayout / crew.members.length).toLocaleString()}`,
        {
          heistName: heist.name,
          crewName: crew.name,
          totalPayout: heist.basePayout,
          sabotaged,
        },
        true
      );
    }

    // Increase trust for all members on success (unless sabotaged)
    if (!sabotaged) {
      for (const member of crew.members) {
        await crewService.adjustTrust(crewId, member.playerId, 5);
      }
    } else if (sabotagedBy) {
      // Decrease trust for saboteur
      await crewService.adjustTrust(crewId, sabotagedBy, -20);
    }

    await notifyCrewHeistResult(crewId, crew.name, heist.name, true);
  } else {
    await prisma.crewHeistAttempt.create({
      data: {
        crewId,
        heistId,
        success: false,
      },
    });

    // Failure - everyone goes to jail AND loses XP
    const xpLossPerMember = Math.floor(
      config.xpLoss.heistFailed.min +
      Math.random() * (config.xpLoss.heistFailed.max - config.xpLoss.heistFailed.min)
    );

    await prisma.$transaction(async (tx: any) => {
      for (const playerId of memberIds) {
        // Create jail record
        await tx.crimeAttempt.create({
          data: {
            playerId,
            crimeId: heistId,
            success: false,
            reward: 0,
            xpGained: 0,
            jailed: true,
            jailTime: heist.jailTimeOnFailure,
          },
        });
        
        // Apply XP loss
        if (xpLossPerMember > 0) {
          await playerService.loseXP(playerId, xpLossPerMember);
        }
      }
    });

    result.jailTime = heist.jailTimeOnFailure;
    result.xpLost = xpLossPerMember;

    // Create world event
    await worldEventService.createEvent(sabotaged ? 'heist.failure_sabotaged' : 'heist.failure', {
      heistName: heist.name,
      crewName: crew.name,
      jailTime: heist.jailTimeOnFailure,
      sabotaged,
      xpLost: xpLossPerMember,
    });

    for (const member of crew.members) {
      await activityService.logActivity(
        member.playerId,
        'ARREST',
        `Arrested after failed heist ${heist.name} for ${heist.jailTimeOnFailure} minutes`,
        {
          authority: 'Police',
          source: 'HEIST',
          heistId: heist.id,
          heistName: heist.name,
          crewId,
          crewName: crew.name,
          jailTime: heist.jailTimeOnFailure,
          xpLost: xpLossPerMember,
          sabotaged,
        },
        true
      );
    }

    // Decrease trust for all members on failure
    for (const member of crew.members) {
      await crewService.adjustTrust(crewId, member.playerId, -3);
    }

    // Extra trust penalty AND extra XP loss for saboteur
    if (sabotaged && sabotagedBy) {
      await crewService.adjustTrust(crewId, sabotagedBy, -15);
      
      // Saboteur loses an additional 500 XP
      const sabotageXPLoss = config.xpLoss.heistSabotage;
      if (sabotageXPLoss > 0) {
        await playerService.loseXP(sabotagedBy, sabotageXPLoss);
      }
    }

    await notifyCrewHeistResult(crewId, crew.name, heist.name, false);
  }

  return result;
}
