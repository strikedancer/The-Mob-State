import prisma from '../lib/prisma';

/**
 * Apply tool degradation after crime use
 */
export async function degradeTool(
  playerId: number,
  toolId: string,
  damageSustained: number
): Promise<{ durability: number; broke: boolean }> {
  const playerTool = await prisma.playerTools.findFirst({
    where: {
      playerId,
      toolId,
    },
  });
  
  if (!playerTool) {
    throw new Error(`Tool ${toolId} not found for player ${playerId}`);
  }
  
  const newDurability = Math.max(0, playerTool.durability - damageSustained);
  const broke = newDurability === 0;
  
  if (broke) {
    // Tool broke completely - delete it
    await prisma.playerTools.delete({
      where: { id: playerTool.id },
    });
  } else {
    // Update durability
    await prisma.playerTools.update({
      where: { id: playerTool.id },
      data: { durability: newDurability },
    });
  }
  
  return { durability: newDurability, broke };
}

/**
 * Apply vehicle degradation after crime use
 */
export async function degradeVehicle(
  vehicleId: number,
  conditionLoss: number,
  fuelUsed: number
): Promise<{ condition: number; fuel: number; broke: boolean }> {
  const vehicle = await prisma.vehicle.findUnique({
    where: { id: vehicleId },
  });
  
  if (!vehicle) {
    throw new Error(`Vehicle ${vehicleId} not found`);
  }
  
  const newCondition = Math.max(0, vehicle.condition - conditionLoss);
  const newFuel = Math.max(0, vehicle.fuel - fuelUsed);
  const broke = newCondition === 0;
  
  await prisma.vehicle.update({
    where: { id: vehicleId },
    data: {
      condition: newCondition,
      fuel: newFuel,
      isBroken: broke,
    },
  });
  
  return { condition: newCondition, fuel: newFuel, broke };
}

/**
 * Get player's selected vehicle for crimes
 */
export async function getPlayerCrimeVehicle(playerId: number) {
  const selection = await prisma.playerSelectedVehicle.findUnique({
    where: { playerId },
    include: {
      vehicle: true,
    },
  });
  
  return selection?.vehicle;
}

/**
 * Get player's tool for crime
 */
export async function getPlayerTool(playerId: number, toolId: string) {
  return await prisma.playerTools.findFirst({
    where: {
      playerId,
      toolId,
      location: 'carried', // Only tools being carried
    },
  });
}

/**
 * Set player's selected vehicle for crimes
 */
export async function setPlayerCrimeVehicle(
  playerId: number,
  vehicleId: number
): Promise<void> {
  // Check if vehicle exists and belongs to player
  const vehicle = await prisma.vehicle.findFirst({
    where: {
      id: vehicleId,
      playerId,
    },
  });
  
  if (!vehicle) {
    throw new Error('Vehicle not found or does not belong to player');
  }
  
  // Upsert selection
  await prisma.playerSelectedVehicle.upsert({
    where: { playerId },
    create: {
      playerId,
      vehicleId,
      selectedFor: 'crimes',
    },
    update: {
      vehicleId,
      selectedAt: new Date(),
    },
  });
}

/**
 * Repair vehicle (costs money)
 */
export async function repairVehicle(
  vehicleId: number,
  repairPercent: number = 100
): Promise<{ cost: number; newCondition: number }> {
  const vehicle = await prisma.vehicle.findUnique({
    where: { id: vehicleId },
  });
  
  if (!vehicle) {
    throw new Error('Vehicle not found');
  }
  
  const conditionToRestore = Math.min(repairPercent, 100 - vehicle.condition);
  const cost = Math.floor(conditionToRestore * 500); // $500 per 1% condition
  
  const newCondition = Math.min(100, vehicle.condition + conditionToRestore);
  
  await prisma.vehicle.update({
    where: { id: vehicleId },
    data: {
      condition: newCondition,
      isBroken: newCondition < 10,
    },
  });
  
  return { cost, newCondition };
}

/**
 * Refuel vehicle
 */
export async function refuelVehicle(
  vehicleId: number,
  fuelAmount: number
): Promise<{ cost: number; newFuel: number }> {
  const vehicle = await prisma.vehicle.findUnique({
    where: { id: vehicleId },
  });
  
  if (!vehicle) {
    throw new Error('Vehicle not found');
  }
  
  const fuelToAdd = Math.min(fuelAmount, vehicle.maxFuel - vehicle.fuel);
  const cost = Math.floor(fuelToAdd * 2); // $2 per liter
  
  const newFuel = Math.min(vehicle.maxFuel, vehicle.fuel + fuelToAdd);
  
  await prisma.vehicle.update({
    where: { id: vehicleId },
    data: { fuel: newFuel },
  });
  
  return { cost, newFuel };
}

/**
 * Clear player's selected crime vehicle (used when traveling to different country)
 */
export async function clearPlayerCrimeVehicle(playerId: number): Promise<void> {
  await prisma.playerSelectedVehicle.deleteMany({
    where: { playerId },
  });
}
