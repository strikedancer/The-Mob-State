import { NPCType } from '@prisma/client';
import bcrypt from 'bcrypt';
import npcBehaviors from '../../content/npcBehaviors.json';
import countries from '../../content/countries.json';
import prisma from '../lib/prisma';
import { getXPForRank } from '../config';
import { runNpcLiveCycle } from './npcActionDriver';

interface NPCCreationOptions {
  username: string;
  npcType: NPCType;
  gender?: 'male' | 'female';
}

interface NPCActivityResult {
  npcId: number;
  activitiesPerformed: number;
  moneyEarned: number;
  xpEarned: number;
  arrests: number;
  purchases?: {
    vehicles?: number;
    weapons?: number;
    properties?: number;
  };
  survival?: {
    foodBought?: number;
    drinksBought?: number;
    hospitalVisits?: number;
  };
  heatManagement?: {
    bailsPaid?: number;
    wantedLevelReduced?: number;
  };
  actions?: string[];
}

export class NPCService {
  /**
   * Create a new NPC player
   */
  static async createNPC(options: NPCCreationOptions) {
    const { username, npcType } = options;
    const gender = options.gender === 'female' ? 'female' : 'male';

    const existing = await prisma.player.findUnique({ where: { username } });
    if (existing) {
      throw new Error('USERNAME_TAKEN');
    }

    // Get initial stats based on NPC type
    const initialStats = npcBehaviors.initialStats[npcType];
    const startingRank = initialStats.startingRank;
    const startingXp = getXPForRank(startingRank);
    const startCountry = countries[Math.floor(Math.random() * countries.length)];

    // Create player account
    const hashedPassword = await bcrypt.hash('npc_password_' + Math.random(), 10);
    
    const player = await prisma.player.create({
      data: {
        username,
        passwordHash: hashedPassword,
        email: `${username}@npc.local`,
        emailVerified: true,
        gender,
        avatar: gender === 'female' ? 'default_2' : 'default_1',
        money: initialStats.startingMoney,
        rank: startingRank,
        xp: startingXp,
        currentCountry: startCountry.id,
      },
    });

    // Create NPC record
    const npc = await prisma.nPCPlayer.create({
      data: {
        playerId: player.id,
        npcType,
        isActive: true,
      },
    });

    return { player, npc };
  }

  /**
   * Get all NPCs with their player data
   */
  static async getAllNPCs() {
    try {
      if (!prisma) {
        console.error('Prisma client is not initialized');
        return [];
      }

      const npcs = await prisma.nPCPlayer.findMany({
        include: {
          activityLogs: {
            orderBy: { timestamp: 'desc' },
            take: 10,
          },
        },
      });

      const npcData = await Promise.all(
        npcs.map(async (npc) => {
          try {
            const player = await prisma.player.findUnique({
              where: { id: npc.playerId },
              select: {
                id: true,
                username: true,
                money: true,
                rank: true,
                xp: true,
                health: true,
                currentCountry: true,
                wantedLevel: true,
                jailRelease: true,
              },
            });

            // Calculate hourly stats safely
            const hoursActive = Number(npc.simulatedOnlineHours) || 1;
            const crimesPerHour = Number(npc.totalCrimes) / hoursActive;
            const jobsPerHour = Number(npc.totalJobs) / hoursActive;
            const moneyPerHour = Number(npc.totalMoneyEarned) / hoursActive;
            const xpPerHour = Number(npc.totalXpEarned) / hoursActive;

            return {
              id: npc.id,
              username: player?.username || 'Unknown',
              activityLevel: npc.npcType,
              stats: {
                totalCrimes: Number(npc.totalCrimes),
                successfulCrimes: Number(npc.totalCrimes) - Number(npc.totalArrests),
                failedCrimes: Number(npc.totalArrests),
                totalJobs: Number(npc.totalJobs),
                totalMoneyEarned: Number(npc.totalMoneyEarned),
                totalXpEarned: Number(npc.totalXpEarned),
                totalJailTime: Number(npc.totalJailTime),
                arrests: Number(npc.totalArrests),
                crimesPerHour,
                jobsPerHour,
                moneyPerHour,
                xpPerHour,
              },
              npcPlayer: {
                money: Number(player?.money || 0),
                rank: Number(player?.rank || 0),
                health: Number(player?.health || 100),
                currentCountry: String(player?.currentCountry || 'netherlands'),
              },
              isActive: Boolean(npc.isActive),
              createdAt: npc.createdAt.toISOString(),
            };
          } catch (error) {
            console.error(`Error processing NPC ${npc.id}:`, error);
            return null;
          }
        })
      );

      // Filter out any null values from failed NPC processing
      return npcData.filter(npc => npc !== null);
    } catch (error) {
      console.error('Error in getAllNPCs:', error);
      return [];
    }
  }

  /**
   * Get NPC statistics
   */
  static async getNPCStats(npcId: number) {
    const npc = await prisma.nPCPlayer.findUnique({
      where: { id: npcId },
      include: {
        activityLogs: {
          orderBy: { timestamp: 'desc' },
          take: 100,
        },
      },
    });

    if (!npc) {
      throw new Error('NPC not found');
    }

    const player = await prisma.player.findUnique({
      where: { id: npc.playerId },
    });

    // Calculate hourly stats
    const hoursActive = Number(npc.simulatedOnlineHours) || 1;
    const actualCrimesPerHour = Number(npc.totalCrimes) / hoursActive;
    const actualJobsPerHour = Number(npc.totalJobs) / hoursActive;
    const moneyPerHour = Number(npc.totalMoneyEarned) / hoursActive;
    const xpPerHour = Number(npc.totalXpEarned) / hoursActive;

    // Activity breakdown
    const activityBreakdown = npc.activityLogs.reduce((acc, log) => {
      acc[log.activityType] = (acc[log.activityType] || 0) + 1;
      return acc;
    }, {} as Record<string, number>);

    // Convert activity logs to safe format
    const safeActivityLogs = npc.activityLogs.slice(0, 20).map(log => ({
      id: Number(log.id),
      activityType: log.activityType,
      details: log.details,
      success: log.success,
      moneyEarned: Number(log.moneyEarned),
      xpEarned: Number(log.xpEarned),
      timestamp: log.timestamp.toISOString(),
    }));

    return {
      npcInfo: {
        id: Number(npc.id),
        playerId: Number(npc.playerId),
        npcType: npc.npcType,
        isActive: npc.isActive,
        createdAt: npc.createdAt.toISOString(),
        lastActivityAt: npc.lastActivityAt?.toISOString() || null,
      },
      playerInfo: player ? {
        id: Number(player.id),
        username: player.username,
        money: Number(player.money),
        rank: Number(player.rank),
        xp: Number(player.xp),
        health: Number(player.health),
        currentCountry: player.currentCountry,
        wantedLevel: Number(player.wantedLevel),
      } : null,
      stats: {
        totalCrimes: Number(npc.totalCrimes),
        totalJobs: Number(npc.totalJobs),
        totalMoneyEarned: Number(npc.totalMoneyEarned),
        totalXpEarned: Number(npc.totalXpEarned),
        totalArrests: Number(npc.totalArrests),
        totalJailTime: Number(npc.totalJailTime),
        simulatedOnlineHours: Number(npc.simulatedOnlineHours),
        crimesPerHour: actualCrimesPerHour,
        jobsPerHour: actualJobsPerHour,
        moneyPerHour,
        xpPerHour,
        successRate: Number(npc.totalCrimes) > 0 
          ? ((Number(npc.totalCrimes) - Number(npc.totalArrests)) / Number(npc.totalCrimes)) * 100 
          : 0,
      },
      activityBreakdown,
      recentActivities: safeActivityLogs,
    };
  }

  /**
   * Simulate NPC activity through the live player services.
   */
  static async simulateActivity(npcId: number, hours: number = 1): Promise<NPCActivityResult> {
    const npc = await prisma.nPCPlayer.findUnique({
      where: { id: npcId },
    });

    if (!npc || !npc.isActive) {
      throw new Error('NPC not found or inactive');
    }

    const player = await prisma.player.findUnique({
      where: { id: npc.playerId },
    });

    if (!player) {
      throw new Error('Player not found for NPC');
    }

    const cycles = Math.max(1, Math.min(8, Math.ceil(hours)));
    let activitiesPerformed = 0;
    let totalMoneyEarned = 0;
    let totalXpEarned = 0;
    let arrests = 0;
    const actions: string[] = [];

    for (let i = 0; i < cycles; i++) {
      const cycle = await runNpcLiveCycle(npc.id, npc.playerId, npc.npcType);
      activitiesPerformed += cycle.activitiesPerformed;
      totalMoneyEarned += cycle.moneyEarned;
      totalXpEarned += cycle.xpEarned;
      arrests += cycle.arrests;
      actions.push(...cycle.actions);
    }

    await prisma.nPCPlayer.update({
      where: { id: npcId },
      data: {
        totalCrimes: { increment: actions.filter((action) => action === 'crime').length },
        totalJobs: { increment: actions.filter((action) => action === 'job').length },
        totalMoneyEarned: { increment: Math.max(0, totalMoneyEarned) },
        totalXpEarned: { increment: Math.max(0, totalXpEarned) },
        totalArrests: { increment: arrests },
        simulatedOnlineHours: { increment: hours },
        lastActivityAt: new Date(),
      },
    });

    return {
      npcId,
      activitiesPerformed,
      moneyEarned: totalMoneyEarned,
      xpEarned: totalXpEarned,
      arrests,
      actions,
    };
  }

  /**
   * Deactivate an NPC
   */
  static async deactivateNPC(npcId: number) {
    await prisma.nPCPlayer.update({
      where: { id: npcId },
      data: { isActive: false },
    });
  }

  /**
   * Activate an NPC
   */
  static async activateNPC(npcId: number) {
    await prisma.nPCPlayer.update({
      where: { id: npcId },
      data: { isActive: true },
    });
  }

  /**
   * Delete an NPC and its player account
   */
  static async deleteNPC(npcId: number) {
    const npc = await prisma.nPCPlayer.findUnique({
      where: { id: npcId },
    });

    if (!npc) {
      throw new Error('NPC not found');
    }

    // Delete activity logs first
    await prisma.nPCActivityLog.deleteMany({
      where: { npcId },
    });

    // Delete NPC record
    await prisma.nPCPlayer.delete({
      where: { id: npcId },
    });

    // Delete player account
    await prisma.player.delete({
      where: { id: npc.playerId },
    });
  }

  /**
   * Simulate all active NPCs
   */
  static async simulateAllNPCs(hours: number = 1) {
    try {
      if (!prisma) {
        console.error('Prisma client is not initialized in simulateAllNPCs');
        return {
          totalNPCs: 0,
          results: [],
          totalActivities: 0,
          totalMoneyEarned: 0,
          totalXpEarned: 0,
          totalArrests: 0,
        };
      }

      const activeNPCs = await prisma.nPCPlayer.findMany({
        where: { isActive: true },
      });

      const results = await Promise.all(
        activeNPCs.map(npc => this.simulateActivity(npc.id, hours).catch(err => {
          console.error(`Failed to simulate NPC ${npc.id}:`, err);
          return {
            npcId: npc.id,
            activitiesPerformed: 0,
            moneyEarned: 0,
            xpEarned: 0,
            arrests: 0,
          };
        }))
      );

      return {
        totalNPCs: activeNPCs.length,
        results,
        totalActivities: results.reduce((sum, r) => sum + r.activitiesPerformed, 0),
        totalMoneyEarned: results.reduce((sum, r) => sum + r.moneyEarned, 0),
        totalXpEarned: results.reduce((sum, r) => sum + r.xpEarned, 0),
        totalArrests: results.reduce((sum, r) => sum + r.arrests, 0),
      };
    } catch (error) {
      console.error('Error in simulateAllNPCs:', error);
      return {
        totalNPCs: 0,
        results: [],
        totalActivities: 0,
        totalMoneyEarned: 0,
        totalXpEarned: 0,
        totalArrests: 0,
      };
    }
  }
}
