import prisma from '../lib/prisma';
import { getCrewMemberCapForCrew, getCrewStorageCapacity } from './crewBuildingService';

interface CreateCrewInput {
  name: string;
  leaderId: number;
}

interface JoinCrewInput {
  crewId: number;
  playerId: number;
}

interface CrewWithMembers {
  id: number;
  name: string;
  bankBalance: number;
  createdAt: Date;
  hqStyle?: string | null;
  hqLevel?: number | null;
  members: Array<{
    id: number;
    playerId: number;
    role: string;
    joinedAt: Date;
  }>;
  memberCount: number;
}

interface CrewJoinRequestWithPlayer {
  id: number;
  crewId: number;
  playerId: number;
  status: string;
  createdAt: Date;
  player: {
    id: number;
    username: string;
    rank: number;
  };
  crew: {
    name: string;
  };
}

/**
 * Create a new crew with the given player as leader
 */
export async function createCrew(input: CreateCrewInput): Promise<CrewWithMembers> {
  const { name, leaderId } = input;

  // Validate name length
  if (name.length < 3 || name.length > 50) {
    throw new Error('INVALID_CREW_NAME');
  }

  // Check if player already in a crew
  const existingMembership = await prisma.crewMember.findFirst({
    where: { playerId: leaderId },
  });

  if (existingMembership) {
    throw new Error('ALREADY_IN_CREW');
  }

  // Check if crew name already exists
  const existingCrew = await prisma.crew.findUnique({
    where: { name },
  });

  if (existingCrew) {
    throw new Error('CREW_NAME_TAKEN');
  }

  // Create crew and add leader as member in transaction
  const crew = await prisma.$transaction(async (tx: any) => {
    const newCrew = await tx.crew.create({
      data: {
        name,
        bankBalance: 0,
      },
    });

    await tx.crewMember.create({
      data: {
        crewId: newCrew.id,
        playerId: leaderId,
        role: 'leader',
      },
    });

    await tx.crewHqBuilding.create({
      data: {
        crewId: newCrew.id,
        style: 'camping',
        level: 0,
      },
    });

    return newCrew;
  });

  // Get crew with members
  return getCrewById(crew.id);
}

/**
 * Player joins an existing crew
 */
export async function joinCrew(input: JoinCrewInput): Promise<CrewWithMembers> {
  const { crewId, playerId } = input;

  // Check if crew exists
  const crew = await prisma.crew.findUnique({
    where: { id: crewId },
  });

  if (!crew) {
    throw new Error('CREW_NOT_FOUND');
  }

  // Check if player already in a crew
  const existingMembership = await prisma.crewMember.findFirst({
    where: { playerId },
  });

  if (existingMembership) {
    throw new Error('ALREADY_IN_CREW');
  }

  // Add player as member
  await prisma.crewMember.create({
    data: {
      crewId,
      playerId,
      role: 'member',
    },
  });

  return getCrewById(crewId);
}

/**
 * Create a join request for a crew (pending approval)
 */
export async function requestJoinCrew(
  crewId: number,
  playerId: number
): Promise<CrewJoinRequestWithPlayer> {
  const crew = await prisma.crew.findUnique({ where: { id: crewId } });
  if (!crew) {
    throw new Error('CREW_NOT_FOUND');
  }

  const existingMembership = await prisma.crewMember.findFirst({
    where: { playerId },
  });
  if (existingMembership) {
    throw new Error('ALREADY_IN_CREW');
  }

  const existingRequest = await prisma.crewJoinRequest.findFirst({
    where: { crewId, playerId, status: 'pending' },
  });
  if (existingRequest) {
    throw new Error('REQUEST_ALREADY_PENDING');
  }

  return prisma.crewJoinRequest.create({
    data: {
      crewId,
      playerId,
      status: 'pending',
    },
    include: {
      crew: {
        select: {
          name: true,
        },
      },
      player: {
        select: {
          id: true,
          username: true,
          rank: true,
        },
      },
    },
  }) as Promise<CrewJoinRequestWithPlayer>;
}

/**
 * List pending join requests for a crew (leader only)
 */
export async function getJoinRequests(
  crewId: number
): Promise<CrewJoinRequestWithPlayer[]> {
  return prisma.crewJoinRequest.findMany({
    where: {
      crewId,
      status: 'pending',
    },
    include: {
      player: {
        select: { id: true, username: true, rank: true },
      },
    },
    orderBy: { createdAt: 'asc' },
  }) as Promise<CrewJoinRequestWithPlayer[]>;
}

/**
 * Approve a join request (leader only)
 */
export async function approveJoinRequest(
  crewId: number,
  requestId: number
): Promise<CrewWithMembers> {
  const request = await prisma.crewJoinRequest.findFirst({
    where: { id: requestId, crewId },
  });

  if (!request) {
    throw new Error('REQUEST_NOT_FOUND');
  }

  if (request.status !== 'pending') {
    throw new Error('REQUEST_NOT_PENDING');
  }

  return prisma.$transaction(async (tx: any) => {
    const memberCap = await getCrewMemberCapForCrew(crewId);
    const memberCount = await tx.crewMember.count({
      where: { crewId },
    });

    if (memberCap > 0 && memberCount >= memberCap) {
      throw new Error('CREW_FULL');
    }

    const existingMembership = await tx.crewMember.findFirst({
      where: { playerId: request.playerId },
    });
    if (existingMembership) {
      throw new Error('ALREADY_IN_CREW');
    }

    await tx.crewMember.create({
      data: {
        crewId,
        playerId: request.playerId,
        role: 'member',
      },
    });

    await tx.crewJoinRequest.update({
      where: { id: request.id },
      data: { status: 'approved' },
    });

    return getCrewById(crewId);
  });
}

/**
 * Reject a join request (leader only)
 */
export async function rejectJoinRequest(
  crewId: number,
  requestId: number
): Promise<void> {
  const request = await prisma.crewJoinRequest.findFirst({
    where: { id: requestId, crewId },
  });

  if (!request) {
    throw new Error('REQUEST_NOT_FOUND');
  }

  if (request.status !== 'pending') {
    throw new Error('REQUEST_NOT_PENDING');
  }

  await prisma.crewJoinRequest.update({
    where: { id: request.id },
    data: { status: 'rejected' },
  });
}

/**
 * Player leaves their current crew
 */
export async function leaveCrew(playerId: number): Promise<void> {
  const membership = await prisma.crewMember.findFirst({
    where: { playerId },
    include: {
      crew: {
        include: {
          members: true,
        },
      },
    },
  });

  if (!membership) {
    throw new Error('NOT_IN_CREW');
  }

  // If player is leader and there are other members, cannot leave
  if (membership.role === 'leader' && membership.crew.members.length > 1) {
    throw new Error('LEADER_CANNOT_LEAVE');
  }

  await prisma.$transaction(async (tx: any) => {
    // Remove membership
    await tx.crewMember.delete({
      where: { id: membership.id },
    });

    // If leader and last member, delete crew
    if (membership.role === 'leader' && membership.crew.members.length === 1) {
      await tx.crew.delete({
        where: { id: membership.crewId },
      });
    }
  });
}

/**
 * Get crew by ID with all members
 */
export async function getCrewById(crewId: number): Promise<CrewWithMembers> {
  const crew = await prisma.crew.findUnique({
    where: { id: crewId },
    include: {
      hqBuilding: {
        select: {
          style: true,
          level: true,
        },
      },
      members: {
        include: {
          player: {
            select: {
              id: true,
              username: true,
              rank: true,
            },
          },
        },
        orderBy: {
          joinedAt: 'asc',
        },
      },
    },
  });

  if (!crew) {
    throw new Error('CREW_NOT_FOUND');
  }

  return {
    id: crew.id,
    name: crew.name,
    bankBalance: crew.bankBalance,
    createdAt: crew.createdAt,
    hqStyle: crew.hqBuilding?.style ?? null,
    hqLevel: crew.hqBuilding?.level ?? null,
    members: crew.members,
    memberCount: crew.members.length,
  };
}

/**
 * Get player's current crew
 */
export async function getPlayerCrew(playerId: number): Promise<CrewWithMembers | null> {
  const membership = await prisma.crewMember.findFirst({
    where: { playerId },
  });

  if (!membership) {
    return null;
  }

  return getCrewById(membership.crewId);
}

/**
 * Get all crews (for listing)
 */
export async function getAllCrews(): Promise<CrewWithMembers[]> {
  const crews = await prisma.crew.findMany({
    include: {
      hqBuilding: {
        select: {
          style: true,
          level: true,
        },
      },
      members: {
        include: {
          player: {
            select: {
              id: true,
              username: true,
              rank: true,
            },
          },
        },
        orderBy: {
          joinedAt: 'asc',
        },
      },
    },
    orderBy: {
      createdAt: 'desc',
    },
  });

  return crews.map((crew: any) => ({
    id: crew.id,
    name: crew.name,
    bankBalance: crew.bankBalance,
    createdAt: crew.createdAt,
    hqStyle: crew.hqBuilding?.style ?? null,
    hqLevel: crew.hqBuilding?.level ?? null,
    members: crew.members,
    memberCount: crew.members.length,
  }));
}

/**
 * Check if player is crew leader
 */
export async function isCrewLeader(playerId: number, crewId: number): Promise<boolean> {
  const membership = await prisma.crewMember.findFirst({
    where: {
      playerId,
      crewId,
      role: 'leader',
    },
  });

  return membership !== null;
}

/**
 * Check if player is in crew
 */
export async function isCrewMember(playerId: number, crewId: number): Promise<boolean> {
  const membership = await prisma.crewMember.findFirst({
    where: {
      playerId,
      crewId,
    },
  });

  return membership !== null;
}

/**
 * Kick a member from the crew (leader only)
 */
export async function kickMember(crewId: number, targetPlayerId: number): Promise<void> {
  const membership = await prisma.crewMember.findFirst({
    where: { crewId, playerId: targetPlayerId },
  });

  if (!membership) {
    throw new Error('MEMBER_NOT_FOUND');
  }

  if (membership.role === 'leader') {
    throw new Error('CANNOT_KICK_LEADER');
  }

  await prisma.crewMember.delete({
    where: { id: membership.id },
  });
}

/**
 * Change crew member role (leader only)
 */
export async function changeMemberRole(
  crewId: number,
  targetPlayerId: number,
  role: 'member' | 'co_leader'
): Promise<void> {
  const membership = await prisma.crewMember.findFirst({
    where: { crewId, playerId: targetPlayerId },
  });

  if (!membership) {
    throw new Error('MEMBER_NOT_FOUND');
  }

  if (membership.role === 'leader') {
    throw new Error('CANNOT_CHANGE_LEADER');
  }

  await prisma.crewMember.update({
    where: { id: membership.id },
    data: { role },
  });
}

/**
 * Deposit money to crew bank (members allowed)
 */
export async function depositToCrewBank(
  crewId: number,
  playerId: number,
  amount: number
): Promise<{ crewBalance: number; playerMoney: number }> {
  if (amount <= 0) {
    throw new Error('INVALID_AMOUNT');
  }

  const cashCapacity = await getCrewStorageCapacity(crewId, 'cash_storage');
  if (cashCapacity <= 0) {
    throw new Error('CASH_STORAGE_NOT_OWNED');
  }

  return prisma.$transaction(async (tx) => {
    const player = await tx.player.findUnique({
      where: { id: playerId },
      select: { money: true },
    });

    if (!player || player.money < amount) {
      throw new Error('INSUFFICIENT_FUNDS');
    }

    await tx.player.update({
      where: { id: playerId },
      data: { money: { decrement: amount } },
    });

    const currentCrew = await tx.crew.findUnique({
      where: { id: crewId },
      select: { bankBalance: true },
    });

    if (!currentCrew) {
      throw new Error('CREW_NOT_FOUND');
    }

    if (cashCapacity > 0 && currentCrew.bankBalance + amount > cashCapacity) {
      throw new Error('CASH_STORAGE_FULL');
    }

    const crew = await tx.crew.update({
      where: { id: crewId },
      data: { bankBalance: { increment: amount } },
      select: { bankBalance: true },
    });

    return { crewBalance: crew.bankBalance, playerMoney: player.money - amount };
  });
}

/**
 * Delete crew (leader only)
 */
export async function deleteCrew(crewId: number): Promise<void> {
  await prisma.crew.delete({
    where: { id: crewId },
  });
}

/**
 * Withdraw money from crew bank (leader only)
 */
export async function withdrawFromCrewBank(
  crewId: number,
  playerId: number,
  amount: number
): Promise<{ crewBalance: number; playerMoney: number }> {
  if (amount <= 0) {
    throw new Error('INVALID_AMOUNT');
  }

  const cashCapacity = await getCrewStorageCapacity(crewId, 'cash_storage');
  if (cashCapacity <= 0) {
    throw new Error('CASH_STORAGE_NOT_OWNED');
  }

  return prisma.$transaction(async (tx) => {
    const crew = await tx.crew.findUnique({
      where: { id: crewId },
      select: { bankBalance: true },
    });

    if (!crew || crew.bankBalance < amount) {
      throw new Error('INSUFFICIENT_CREW_FUNDS');
    }

    await tx.crew.update({
      where: { id: crewId },
      data: { bankBalance: { decrement: amount } },
    });

    const player = await tx.player.update({
      where: { id: playerId },
      data: { money: { increment: amount } },
      select: { money: true },
    });

    return { crewBalance: crew.bankBalance - amount, playerMoney: player.money };
  });
}

/**
 * Get crew stats
 */
export async function getCrewStats(crewId: number): Promise<{
  totalCrimes: number;
  heistsAttempted: number;
  heistsCompleted: number;
}> {
  const members = await prisma.crewMember.findMany({
    where: { crewId },
    select: { playerId: true },
  });

  const memberIds = members.map((m) => m.playerId);

  const totalCrimes = memberIds.length
    ? await prisma.crimeAttempt.count({
        where: { playerId: { in: memberIds } },
      })
    : 0;

  const heistsAttempted = await prisma.crewHeistAttempt.count({
    where: { crewId },
  });

  const heistsCompleted = await prisma.crewHeistAttempt.count({
    where: { crewId, success: true },
  });

  return { totalCrimes, heistsAttempted, heistsCompleted };
}

/**
 * Adjust trust score for a crew member
 * @param crewId - Crew ID
 * @param playerId - Player whose trust to adjust
 * @param amount - Amount to adjust (positive or negative)
 * @returns Updated trust score
 */
export async function adjustTrust(
  crewId: number,
  playerId: number,
  amount: number
): Promise<number> {
  const membership = await prisma.crewMember.findFirst({
    where: { crewId, playerId },
  });

  if (!membership) {
    throw new Error('MEMBER_NOT_FOUND');
  }

  // Calculate new trust score and clamp between 0-100
  const newTrust = Math.max(0, Math.min(100, membership.trustScore + amount));

  await prisma.crewMember.update({
    where: { id: membership.id },
    data: { trustScore: newTrust },
  });

  return newTrust;
}

/**
 * Check if sabotage occurs based on trust score
 * Lower trust = higher sabotage chance
 * @param trustScore - Member's trust score (0-100)
 * @returns true if sabotage occurs
 */
export function checkSabotage(trustScore: number): boolean {
  // Clamp trust between 0-100
  const clampedTrust = Math.max(0, Math.min(100, trustScore));

  // Calculate sabotage chance: 0% at trust 100, 50% at trust 0
  const sabotageChance = (100 - clampedTrust) / 2;

  // Roll dice
  const roll = Math.random() * 100;

  return roll < sabotageChance;
}

/**
 * Get crew member trust score
 */
export async function getMemberTrust(crewId: number, playerId: number): Promise<number> {
  const membership = await prisma.crewMember.findFirst({
    where: { crewId, playerId },
  });

  if (!membership) {
    throw new Error('MEMBER_NOT_FOUND');
  }

  return membership.trustScore;
}

/**
 * Liquidate a crew (disband, seize assets)
 * Requirements: Attacker must be higher level than crew leader with minimum 5 level difference
 */
export async function liquidateCrew(
  crewId: number,
  attackerId: number
): Promise<{
  crewName: string;
  assetsSeized: number;
  memberCount: number;
  leaderName: string;
}> {
  // Get crew with members
  const crew = await prisma.crew.findUnique({
    where: { id: crewId },
    include: {
      members: true,
    },
  });

  if (!crew) {
    throw new Error('CREW_NOT_FOUND');
  }

  // Get attacker details
  const attacker = await prisma.player.findUnique({
    where: { id: attackerId },
    select: { id: true, username: true, rank: true, money: true },
  });

  if (!attacker) {
    throw new Error('ATTACKER_NOT_FOUND');
  }

  // Check if attacker is in the target crew
  const attackerInCrew = crew.members.some((m: any) => m.playerId === attackerId);
  if (attackerInCrew) {
    throw new Error('CANNOT_LIQUIDATE_OWN_CREW');
  }

  // Find crew leader
  const leaderMembership = crew.members.find((m: any) => m.role === 'leader');
  if (!leaderMembership) {
    throw new Error('CREW_HAS_NO_LEADER');
  }

  // Get leader player info
  const leader = await prisma.player.findUnique({
    where: { id: leaderMembership.playerId },
    select: { username: true, rank: true },
  });

  if (!leader) {
    throw new Error('LEADER_NOT_FOUND');
  }

  // Check power requirements: attacker must be at least 5 levels higher than crew leader
  const minLevelDifference = 5;
  const levelDifference = attacker.rank - leader.rank;

  if (levelDifference < minLevelDifference) {
    throw new Error('INSUFFICIENT_POWER');
  }

  const assetsSeized = crew.bankBalance;
  const crewName = crew.name;
  const memberCount = crew.members.length;
  const leaderName = leader.username;

  // Execute liquidation in transaction
  await prisma.$transaction(async (tx) => {
    // Transfer crew bank to attacker
    if (assetsSeized > 0) {
      await tx.player.update({
        where: { id: attackerId },
        data: { money: { increment: assetsSeized } },
      });
    }

    // Delete all crew members
    await tx.crewMember.deleteMany({
      where: { crewId },
    });

    // Delete the crew
    await tx.crew.delete({
      where: { id: crewId },
    });
  });

  return {
    crewName,
    assetsSeized,
    memberCount,
    leaderName,
  };
}
