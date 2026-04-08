import { NPCType } from '@prisma/client';
import bcrypt from 'bcrypt';
import npcBehaviors from '../../content/npcBehaviors.json';
import crimesData from '../../content/crimes.json';
import jobsData from '../../content/jobs.json';
import vehiclesData from '../../content/vehicles.json';
import weaponsData from '../../content/weapons.json';
import propertiesData from '../../content/properties.json';
import prisma from '../lib/prisma';
import { hospitalService } from './hospitalService';
import * as policeService from './policeService';
import config from '../config';

const crimes = crimesData.crimes;
const jobs = jobsData;
const cars = vehiclesData.cars;
const boats = vehiclesData.boats;
const allVehicles = [...cars, ...boats];
const weapons = weaponsData.weapons;
const properties = propertiesData.properties;

interface NPCCreationOptions {
  username: string;
  npcType: NPCType;
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
}

export class NPCService {
  /**
   * Create a new NPC player
   */
  static async createNPC(options: NPCCreationOptions) {
    const { username, npcType } = options;

    // Get initial stats based on NPC type
    const initialStats = npcBehaviors.initialStats[npcType];

    // Create player account
    const hashedPassword = await bcrypt.hash('npc_password_' + Math.random(), 10);
    
    const player = await prisma.player.create({
      data: {
        username,
        passwordHash: hashedPassword,
        email: `${username}@npc.local`,
        emailVerified: true,
        money: initialStats.startingMoney,
        rank: initialStats.startingRank,
        xp: initialStats.startingXP,
        currentCountry: 'netherlands',
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
   * Simulate NPC activity for a given time period
   */
  static async simulateActivity(npcId: number, hours: number = 1): Promise<NPCActivityResult> {
    const npc = await prisma.nPCPlayer.findUnique({
      where: { id: npcId },
    });

    if (!npc || !npc.isActive) {
      throw new Error('NPC not found or inactive');
    }

    let player = await prisma.player.findUnique({
      where: { id: npc.playerId },
    });

    if (!player) {
      throw new Error('Player not found for NPC');
    }

    const behavior = npcBehaviors.behaviors[npc.npcType];
    
    // Determine time of day activity level
    const hour = new Date().getHours();
    let activityMultiplier = 1.0;
    if (hour >= 6 && hour < 12) activityMultiplier = behavior.activityPatterns.morningActive;
    else if (hour >= 12 && hour < 18) activityMultiplier = behavior.activityPatterns.afternoonActive;
    else if (hour >= 18 && hour < 24) activityMultiplier = behavior.activityPatterns.eveningActive;
    else activityMultiplier = behavior.activityPatterns.nightActive;

    console.log('[NPC Simulate] NPC Type:', npc.npcType);
    console.log('[NPC Simulate] Hours:', hours);
    console.log('[NPC Simulate] Activity Multiplier:', activityMultiplier);
    console.log('[NPC Simulate] Crimes/hour range:', behavior.crimesPerHour);

    // Calculate how many activities to perform
    const crimesToDo = Math.floor(
      (Math.random() * (behavior.crimesPerHour.max - behavior.crimesPerHour.min + 1) 
      + behavior.crimesPerHour.min) * hours * activityMultiplier
    );

    const jobsToDo = Math.floor(
      (Math.random() * (behavior.jobsPerHour.max - behavior.jobsPerHour.min + 1) 
      + behavior.jobsPerHour.min) * hours * activityMultiplier
    );

    console.log('[NPC Simulate] Crimes to do:', crimesToDo);
    console.log('[NPC Simulate] Jobs to do:', jobsToDo);

    let totalMoneyEarned = 0;
    let totalXpEarned = 0;
    let arrests = 0;
    let activitiesPerformed = 0;
    let purchases = { vehicles: 0, weapons: 0, properties: 0 };
    let survival = { foodBought: 0, drinksBought: 0, hospitalVisits: 0 };
    let heatManagement = { bailsPaid: 0, wantedLevelReduced: 0 };

    // Check and manage heat BEFORE crimes
    const beforeCrimesPlayer = await prisma.player.findUnique({
      where: { id: npc.playerId },
    });
    
    if (beforeCrimesPlayer) {
      const heatResult = await this.manageHeat(npc, beforeCrimesPlayer);
      heatManagement.bailsPaid = heatResult.bailsPaid;
      heatManagement.wantedLevelReduced = heatResult.wantedLevelReduced;
      
      // Refresh player after heat management
      player = await prisma.player.findUnique({
        where: { id: npc.playerId },
      }) || player;
    }

    // Perform crimes (adjust based on wanted level - higher wanted = fewer crimes)
    console.log('[NPC Simulate] Starting crime loop, player in jail:', player.jailRelease !== null, 'wanted level:', player.wantedLevel);
    const wantedPenalty = Math.max(0, 1 - (player.wantedLevel / 20)); // Reduce crimes if wanted level high
    const adjustedCrimes = Math.floor(crimesToDo * wantedPenalty);
    console.log('[NPC Simulate] Crimes adjusted for heat:', crimesToDo, '->', adjustedCrimes);
    
    for (let i = 0; i < adjustedCrimes && player.jailRelease === null; i++) {
      console.log('[NPC Simulate] Crime attempt', i + 1, 'of', adjustedCrimes);
      const crimeResult = await this.performRandomCrime(npc, player, behavior);
      console.log('[NPC Simulate] Crime result:', crimeResult);
      if (crimeResult) {
        totalMoneyEarned += crimeResult.moneyEarned;
        totalXpEarned += crimeResult.xpEarned;
        if (crimeResult.arrested) arrests++;
        activitiesPerformed++;

        // If arrested, stop activities
        if (crimeResult.arrested) break;
      }

      // Random chance to steal a vehicle during criminal activities (10% per crime)
      if (!crimeResult?.arrested && Math.random() < 0.1) {
        const vehicleStolen = await this.stealVehicleForNPC(npc, player);
        if (vehicleStolen) purchases.vehicles++;
      }

      // Refresh player to check wanted level
      player = await prisma.player.findUnique({
        where: { id: npc.playerId },
      }) || player;
    }

    // Perform jobs (if not in jail)
    const updatedPlayer = await prisma.player.findUnique({
      where: { id: npc.playerId },
    });

    if (updatedPlayer && updatedPlayer.jailRelease === null) {
      for (let i = 0; i < jobsToDo; i++) {
        const jobResult = await this.performRandomJob(npc, updatedPlayer, behavior);
        if (jobResult) {
          totalMoneyEarned += jobResult.moneyEarned;
          totalXpEarned += jobResult.xpEarned;
          activitiesPerformed++;
        }
      }
    }

    // Handle survival needs FIRST (health) - can be done from jail
    const survivalPlayer = await prisma.player.findUnique({
      where: { id: npc.playerId },
    });
    
    if (survivalPlayer) {
      console.log('[NPC Simulate] Checking survival needs - Health:', survivalPlayer.health);
      const survivalResults = await this.handleSurvivalNeeds(npc, survivalPlayer);
      survival.foodBought = survivalResults.foodBought;
      survival.drinksBought = survivalResults.drinksBought;
      survival.hospitalVisits = survivalResults.hospitalVisits;
      console.log('[NPC Simulate] Survival actions:', survival);
    }

    // Make smart purchases based on money management settings (can buy even from jail)
    const finalPlayer = await prisma.player.findUnique({
      where: { id: npc.playerId },
    });
    
    if (finalPlayer) {
      console.log('[NPC Simulate] Checking purchases for NPC', npc.id, 'with money:', finalPlayer.money, 'in jail:', finalPlayer.jailRelease !== null);
      const morePurchases = await this.makeSmartPurchases(npc, finalPlayer, behavior);
      purchases.weapons += morePurchases.weapons;
      purchases.properties += morePurchases.properties;
      console.log('[NPC Simulate] Total purchases:', purchases);
    }

    // Update NPC statistics
    await prisma.nPCPlayer.update({
      where: { id: npcId },
      data: {
        totalCrimes: { increment: Math.floor(crimesToDo) },
        totalJobs: { increment: Math.floor(jobsToDo) },
        totalMoneyEarned: { increment: totalMoneyEarned },
        totalXpEarned: { increment: totalXpEarned },
        totalArrests: { increment: arrests },
        simulatedOnlineHours: { increment: hours },
        lastActivityAt: new Date(),
        crimesPerHour: (npc.totalCrimes + crimesToDo) / (npc.simulatedOnlineHours + hours),
        jobsPerHour: (npc.totalJobs + jobsToDo) / (npc.simulatedOnlineHours + hours),
      },
    });

    return {
      npcId,
      activitiesPerformed,
      moneyEarned: totalMoneyEarned,
      xpEarned: totalXpEarned,
      arrests,
      purchases: (purchases.vehicles + purchases.weapons + purchases.properties > 0) ? purchases : undefined,
      survival: (survival.foodBought + survival.drinksBought + survival.hospitalVisits > 0) ? survival : undefined,
      heatManagement: (heatManagement.bailsPaid + heatManagement.wantedLevelReduced > 0) ? heatManagement : undefined,
    };
  }

  /**
   * Perform a random crime based on NPC's preferences
   */
  private static async performRandomCrime(npc: any, player: any, behavior: any) {
    console.log('[performRandomCrime] Starting for NPC:', npc.id, 'Player rank:', player.rank);
    
    // Select crime based on preferences
    const crimePrefs = behavior.crimePreferences;
    const random = Math.random();
    let cumulative = 0;
    let selectedCrime = null;

    console.log('[performRandomCrime] Crime preferences:', crimePrefs);
    console.log('[performRandomCrime] Random value:', random);

    for (const [crimeId, probability] of Object.entries(crimePrefs)) {
      cumulative += probability as number;
      if (random <= cumulative) {
        selectedCrime = crimes.find((c: any) => c.id === crimeId);
        console.log('[performRandomCrime] Selected crime ID:', crimeId, 'Found:', !!selectedCrime);
        break;
      }
    }

    if (!selectedCrime) {
      selectedCrime = crimes[0]; // Fallback to first crime
      console.log('[performRandomCrime] Using fallback crime:', selectedCrime);
    }

    // Check if crime is available for player's rank
    if (selectedCrime.minLevel && player.rank < selectedCrime.minLevel) {
      console.log('[performRandomCrime] Rank too low. Required:', selectedCrime.minLevel, 'Player:', player.rank);
      return null; // Skip if rank too low
    }

    // Simulate crime attempt
    const successChance = selectedCrime.baseSuccessChance * npcBehaviors.simulationSettings.successChanceMultiplier;
    const success = Math.random() < successChance;

    let moneyEarned = 0;
    let xpEarned = 0;
    let arrested = false;

    if (success) {
      // Calculate reward
      const baseReward = (selectedCrime.minReward + selectedCrime.maxReward) / 2;
      const variance = 0.3;
      const varianceFactor = 1 + (Math.random() * variance * 2 - variance);
      moneyEarned = Math.floor(baseReward * varianceFactor);
      const minXp = selectedCrime.minXpReward ?? selectedCrime.xpReward ?? 0;
      const maxXp = selectedCrime.maxXpReward ?? selectedCrime.xpReward ?? 0;
      const safeMinXp = Math.min(minXp, maxXp);
      const safeMaxXp = Math.max(minXp, maxXp);
      xpEarned = Math.floor(Math.random() * (safeMaxXp - safeMinXp + 1)) + safeMinXp;

      // Update player
      await prisma.player.update({
        where: { id: player.id },
        data: {
          money: { increment: moneyEarned },
          xp: { increment: xpEarned },
        },
      });

      // Check for rank up
      await this.checkRankUp(player.id);
    } else {
      // Failed - increase wanted level and check if arrested
      await policeService.increaseWantedLevel(player.id, 1);
      
      const arrestChance = (1 - selectedCrime.baseSuccessChance) * 0.3 * npcBehaviors.simulationSettings.arrestChanceMultiplier;
      arrested = Math.random() < arrestChance;

      if (arrested) {
        // Send to jail
        const jailTime = Math.floor(Math.random() * 60) + 30; // 30-90 minutes
        const jailRelease = new Date();
        jailRelease.setMinutes(jailRelease.getMinutes() + jailTime);

        await prisma.player.update({
          where: { id: player.id },
          data: {
            jailRelease,
            wantedLevel: 0, // Wanted level reset when jailed
          },
        });

        await prisma.nPCPlayer.update({
          where: { id: npc.id },
          data: {
            totalJailTime: { increment: jailTime },
          },
        });
        
        console.log(`[NPC Crime] ${npc.id} arrested and sent to jail for ${jailTime} minutes`);
      } else {
        console.log(`[NPC Crime] ${npc.id} failed crime but escaped arrest (wanted level increased)`);
      }
    }

    // Log activity
    await prisma.nPCActivityLog.create({
      data: {
        npcId: npc.id,
        activityType: 'CRIME',
        details: {
          crimeId: selectedCrime.id,
          crimeName: selectedCrime.name,
        },
        success,
        moneyEarned,
        xpEarned,
      },
    });

    return {
      success,
      moneyEarned,
      xpEarned,
      arrested,
    };
  }

  /**
   * Perform a random job based on NPC's preferences
   */
  private static async performRandomJob(npc: any, player: any, behavior: any) {
    // Select job based on preferences
    const jobPrefs = behavior.jobPreferences;
    const random = Math.random();
    let cumulative = 0;
    let selectedJob = null;

    for (const [jobId, probability] of Object.entries(jobPrefs)) {
      cumulative += probability as number;
      if (random <= cumulative) {
        selectedJob = jobs.find((j: any) => j.id === jobId);
        break;
      }
    }

    if (!selectedJob) {
      selectedJob = jobs[0]; // Fallback to first job
    }

    // Check if job is available for player's rank
    if (selectedJob.minLevel && player.rank < selectedJob.minLevel) {
      return null; // Skip if rank too low
    }

    // Calculate earnings
    const earnings = Math.floor(
      Math.random() * (selectedJob.maxEarnings - selectedJob.minEarnings + 1) + selectedJob.minEarnings
    );
    const xpEarned = selectedJob.xpReward || 5;

    // Update player
    await prisma.player.update({
      where: { id: player.id },
      data: {
        money: { increment: earnings },
        xp: { increment: xpEarned },
      },
    });

    // Check for rank up
    await this.checkRankUp(player.id);

    // Log activity
    await prisma.nPCActivityLog.create({
      data: {
        npcId: npc.id,
        activityType: 'JOB',
        details: {
          jobId: selectedJob.id,
          jobName: selectedJob.name,
        },
        success: true,
        moneyEarned: earnings,
        xpEarned,
      },
    });

    return {
      success: true,
      moneyEarned: earnings,
      xpEarned,
    };
  }

  /**
   * Make smart purchases based on available money and behavior settings
   */
  private static async makeSmartPurchases(npc: any, player: any, behavior: any): Promise<{vehicles: number, weapons: number, properties: number}> {
    const purchases = { vehicles: 0, weapons: 0, properties: 0 };
    
    // Get money management settings
    const moneyMgmt = behavior.moneyManagement;
    const availableMoney = player.money;
    
    console.log('[makeSmartPurchases] NPC:', npc.id, 'Money:', availableMoney, 'Savings rate:', moneyMgmt.savingsRate);
    
    // Don't spend if player has less than a threshold
    if (availableMoney < 5000) {
      console.log('[makeSmartPurchases] Not enough money (< 5000), skipping');
      return purchases;
    }

    // Calculate spending budgets (keep savings rate)
    const spendableMoney = Math.floor(availableMoney * (1 - moneyMgmt.savingsRate));
    const weaponBudget = Math.floor(spendableMoney * moneyMgmt.spendOnWeapons);
    const propertyBudget = Math.floor(spendableMoney * moneyMgmt.spendOnProperty);

    console.log('[makeSmartPurchases] Budgets - Weapon:', weaponBudget, 'Property:', propertyBudget);

    // Try to buy a weapon if budget allows
    if (weaponBudget > 0) {
      const weaponBought = await this.buyWeaponForNPC(npc, player, weaponBudget);
      if (weaponBought) purchases.weapons++;
    }

    // Try to buy property if budget allows
    if (propertyBudget > 0) {
      const propertyBought = await this.buyPropertyForNPC(npc, player, propertyBudget);
      if (propertyBought) purchases.properties++;
    }

    return purchases;
  }

  /**
   * Check and update player rank based on current XP (exponential system)
   */
  private static async checkRankUp(playerId: number): Promise<number | null> {
    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { id: true, xp: true, rank: true },
    });

    if (!player) return null;

    // Use exponential XP system
    const { getRankFromXP } = await import('../config');
    const newRank = getRankFromXP(player.xp);
    
    if (newRank > player.rank) {
      await prisma.player.update({
        where: { id: playerId },
        data: { rank: newRank },
      });
      
      console.log(`[NPC Rank Up] Player ${playerId} advanced to rank ${newRank} (XP: ${player.xp})`);
      return newRank;
    }

    return null;
  }

  /**
   * Manage heat (wanted level and FBI heat)
   */
  private static async manageHeat(npc: any, player: any): Promise<{
    bailsPaid: number;
    wantedLevelReduced: number;
  }> {
    let bailsPaid = 0;
    let wantedLevelReduced = 0;

    // If NPC is in jail AND can afford bail, pay it to get out
    if (player.jailRelease && new Date(player.jailRelease) > new Date()) {
      const bail = policeService.calculateBail(player.wantedLevel || 1); // Use 1 if wanted level is 0
      const affordableBail = player.money * 0.8;
      
      if (bail <= affordableBail) {
        try {
          const oldWantedLevel = player.wantedLevel || 0;
          await policeService.payBail(player.id);
          const newWantedLevel = Math.floor(oldWantedLevel / 2);
          wantedLevelReduced = oldWantedLevel - newWantedLevel;
          bailsPaid++;
          
          console.log(`[NPC Heat Management] ${npc.id} paid bail €${bail} to get out of jail (wanted ${oldWantedLevel} -> ${newWantedLevel})`);
          
          await prisma.nPCActivityLog.create({
            data: {
              npcId: npc.id,
              activityType: 'HEAT_MANAGEMENT',
              details: {
                action: 'pay_bail_jail_release',
                cost: bail,
                oldWantedLevel,
                newWantedLevel,
                releasedFromJail: true,
              },
              success: true,
              moneyEarned: -bail,
              xpEarned: 0,
            },
          });
        } catch (error) {
          console.error('[NPC Heat Management] Jail bail payment failed:', error);
        }
      } else {
        console.log(`[NPC Heat Management] ${npc.id} stuck in jail - cannot afford bail €${bail} (has €${player.money})`);
      }
      
      return { bailsPaid, wantedLevelReduced };
    }

    // If wanted level is high (>= 5), consider paying bail proactively
    if (player.wantedLevel >= 5) {
      const bail = policeService.calculateBail(player.wantedLevel);
      
      // NPC will pay bail if they have enough money and it's worth it
      // They keep a reserve of 20% of their money
      const affordableBail = player.money * 0.8;
      
      if (bail <= affordableBail) {
        try {
          const oldWantedLevel = player.wantedLevel;
          await policeService.payBail(player.id);
          const newWantedLevel = Math.floor(oldWantedLevel / 2);
          wantedLevelReduced = oldWantedLevel - newWantedLevel;
          bailsPaid++;
          
          console.log(`[NPC Heat Management] ${npc.id} paid bail €${bail} to reduce wanted level from ${oldWantedLevel} to ${newWantedLevel}`);
          
          // Log activity
          await prisma.nPCActivityLog.create({
            data: {
              npcId: npc.id,
              activityType: 'HEAT_MANAGEMENT',
              details: {
                action: 'pay_bail',
                cost: bail,
                oldWantedLevel,
                newWantedLevel,
              },
              success: true,
              moneyEarned: -bail,
              xpEarned: 0,
            },
          });
        } catch (error) {
          console.error('[NPC Heat Management] Bail payment failed:', error);
        }
      } else {
        console.log(`[NPC Heat Management] ${npc.id} cannot afford bail €${bail} (has €${player.money})`);
      }
    }

    return { bailsPaid, wantedLevelReduced };
  }

  /**
   * Handle survival needs: health
   */
  private static async handleSurvivalNeeds(npc: any, player: any): Promise<{
    foodBought: number;
    drinksBought: number;
    hospitalVisits: number;
  }> {
    let foodBought = 0;
    let drinksBought = 0;
    let hospitalVisits = 0;

    // Check if NPC needs hospital (health < 30)
    if (player.health < 30 && player.money >= config.hospitalHealCost) {
      try {
        // Check cooldown
        const canVisitHospital = !player.lastHospitalVisit || 
          (Date.now() - player.lastHospitalVisit.getTime()) >= (config.hospitalCooldownMinutes * 60 * 1000);
        
        if (canVisitHospital) {
          await hospitalService.heal(player.id);
          hospitalVisits++;
          console.log(`[NPC Survival] ${npc.id} visited hospital (health was ${player.health})`);
          
          // Log activity
          await prisma.nPCActivityLog.create({
            data: {
              npcId: npc.id,
              activityType: 'SURVIVAL',
              details: {
                action: 'hospital',
                healthBefore: player.health,
                cost: config.hospitalHealCost,
              },
              success: true,
              moneyEarned: -config.hospitalHealCost,
              xpEarned: 0,
            },
          });
        }
      } catch (error) {
        console.error('[NPC Survival] Hospital visit failed:', error);
      }
    }

    // Refresh player data after hospital
    const updatedPlayer = await prisma.player.findUnique({
      where: { id: player.id },
    });
    if (!updatedPlayer) return { foodBought, drinksBought, hospitalVisits };

    // Survival mechanics beyond health are disabled for NPCs

    return { foodBought, drinksBought, hospitalVisits };
  }

  /**
   * Steal a vehicle (car or boat) for NPC (randomly during simulation)
   */
  private static async stealVehicleForNPC(npc: any, player: any): Promise<boolean> {
    // Get vehicles NPC doesn't own yet
    const ownedVehicles = await prisma.vehicleInventory.findMany({
      where: { playerId: player.id },
      select: { vehicleId: true },
    });
    const ownedIds = ownedVehicles.map(v => v.vehicleId);

    // Filter stealable vehicles (rank appropriate, not owned)
    const stealableVehicles = allVehicles.filter(v => 
      v.requiredRank <= player.rank + 2 && // Can steal slightly above rank
      !ownedIds.includes(v.id)
    );

    if (stealableVehicles.length === 0) return false;

    // Random vehicle weighted by difficulty (cheaper = easier to steal)
    const sortedByPrice = stealableVehicles.sort((a, b) => a.baseValue - b.baseValue);
    const randomIndex = Math.floor(Math.random() * Math.min(5, sortedByPrice.length)); // Pick from cheapest 5
    const vehicle = sortedByPrice[randomIndex];

    // Determine if it's a car or boat
    const isCar = cars.some(c => c.id === vehicle.id);
    const vehicleType = isCar ? 'car' : 'boat';

    try {
      // Add to inventory
      await prisma.vehicleInventory.create({
        data: {
          playerId: player.id,
          vehicleType,
          vehicleId: vehicle.id,
          stolenInCountry: player.currentCountry || 'netherlands',
          currentLocation: player.currentCountry || 'netherlands',
          condition: Math.floor(Math.random() * 40) + 60, // 60-100% condition
          fuelLevel: Math.floor(Math.random() * 50) + 50, // 50-100% fuel
        },
      });

      // Log activity
      await prisma.nPCActivityLog.create({
        data: {
          npcId: npc.id,
          activityType: 'VEHICLE_THEFT',
          details: {
            itemType: vehicleType,
            itemId: vehicle.id,
            itemName: vehicle.name,
          },
          success: true,
          moneyEarned: 0,
          xpEarned: 0,
        },
      });

      console.log(`[NPC Vehicle Theft] ${npc.id} stole ${vehicleType}: ${vehicle.name}`);
      return true;
    } catch (error) {
      console.error('[NPC Vehicle Theft] Failed:', error);
      return false;
    }
  }

  /**
   * Buy a weapon for NPC within budget
   */
  private static async buyWeaponForNPC(npc: any, player: any, budget: number): Promise<boolean> {
    console.log('[buyWeaponForNPC] Starting - Budget:', budget, 'Player rank:', player.rank);
    
    // Get weapons NPC doesn't own yet
    const ownedWeapons = await prisma.weaponInventory.findMany({
      where: { playerId: player.id },
      select: { weaponId: true },
    });
    const ownedIds = ownedWeapons.map(w => w.weaponId);
    console.log('[buyWeaponForNPC] Owned weapons:', ownedIds.length);

    // Filter affordable weapons player doesn't have
    const affordableWeapons = weapons.filter(w => 
      w.price <= budget && 
      w.requiredRank <= player.rank &&
      !ownedIds.includes(w.id)
    );

    console.log('[buyWeaponForNPC] Affordable weapons:', affordableWeapons.length);
    if (affordableWeapons.length > 0) {
      console.log('[buyWeaponForNPC] First 3:', affordableWeapons.slice(0, 3).map(w => ({id: w.id, price: w.price, rank: w.requiredRank})));
    }

    if (affordableWeapons.length === 0) return false;

    // Sort by price (buy best affordable)
    affordableWeapons.sort((a, b) => b.price - a.price);
    const weapon = affordableWeapons[0];

    try {
      // Deduct money
      await prisma.player.update({
        where: { id: player.id },
        data: { money: { decrement: weapon.price } },
      });

      // Add to inventory
      await prisma.weaponInventory.create({
        data: {
          playerId: player.id,
          weaponId: weapon.id,
          quantity: 1,
          condition: 100,
        },
      });

      // Log activity
      await prisma.nPCActivityLog.create({
        data: {
          npcId: npc.id,
          activityType: 'PURCHASE',
          details: {
            itemType: 'weapon',
            itemId: weapon.id,
            itemName: weapon.name,
            price: weapon.price,
          },
          success: true,
          moneyEarned: -weapon.price,
          xpEarned: 0,
        },
      });

      console.log(`[NPC Purchase] ${npc.id} bought weapon: ${weapon.name} for €${weapon.price}`);
      return true;
    } catch (error) {
      console.error('[NPC Purchase] Weapon buy failed:', error);
      return false;
    }
  }

  /**
   * Buy a property for NPC within budget
   */
  private static async buyPropertyForNPC(npc: any, player: any, budget: number): Promise<boolean> {
    console.log('[buyPropertyForNPC] Starting - Budget:', budget, 'Player rank:', player.rank);
    
    // Get properties NPC owns
    const ownedProperties = await prisma.property.findMany({
      where: { playerId: player.id },
      select: { propertyType: true },
    });
    const ownedTypes = ownedProperties.map(p => p.propertyType);
    console.log('[buyPropertyForNPC] Owned properties:', ownedTypes.length);

    // Filter affordable properties player doesn't have
    const affordableProperties = properties.filter(p => 
      p.basePrice <= budget && 
      p.minLevel <= player.rank &&
      !ownedTypes.includes(p.id)
    );

    if (affordableProperties.length === 0) return false;

    // Sort by income potential (ROI)
    affordableProperties.sort((a, b) => {
      const roiA = a.baseIncome / a.basePrice;
      const roiB = b.baseIncome / b.basePrice;
      return roiB - roiA;
    });
    const property = affordableProperties[0];

    try {
      // Check if property is unique and already owned
      const existingProperty = await prisma.property.findFirst({
        where: {
          propertyType: property.id,
          countryId: player.currentCountry || 'netherlands',
        },
      });

      if (existingProperty && property.type === 'unique_per_country') {
        return false; // Already owned by someone
      }

      // Deduct money
      await prisma.player.update({
        where: { id: player.id },
        data: { money: { decrement: property.basePrice } },
      });

      // Create unique property ID
      const propertyId = `${property.id}_${player.currentCountry || 'netherlands'}_${player.id}_${Date.now()}`;

      // Add to properties
      await prisma.property.create({
        data: {
          playerId: player.id,
          propertyId,
          countryId: player.currentCountry || 'netherlands',
          propertyType: property.id,
          purchasePrice: property.basePrice,
          upgradeLevel: 1,
        },
      });

      // Log activity
      await prisma.nPCActivityLog.create({
        data: {
          npcId: npc.id,
          activityType: 'PURCHASE',
          details: {
            itemType: 'property',
            itemId: property.id,
            itemName: property.name,
            price: property.basePrice,
          },
          success: true,
          moneyEarned: -property.basePrice,
          xpEarned: 0,
        },
      });

      console.log(`[NPC Purchase] ${npc.id} bought property: ${property.name} for €${property.basePrice}`);
      return true;
    } catch (error) {
      console.error('[NPC Purchase] Property buy failed:', error);
      return false;
    }
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
