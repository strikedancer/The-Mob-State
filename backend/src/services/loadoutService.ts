import prisma from '../lib/prisma';

export interface Loadout {
  id: number;
  playerId: number;
  name: string;
  description?: string;
  isActive: boolean;
  createdAt: Date;
  updatedAt: Date;
}

export interface LoadoutWithTools extends Loadout {
  tools: Array<{
    toolId: string;
    slotPosition: number;
  }>;
}

class LoadoutService {
  /**
   * Get all loadouts for a player
   */
  async getPlayerLoadouts(playerId: number): Promise<LoadoutWithTools[]> {
    const loadouts = await prisma.toolLoadouts.findMany({
      where: { playerId },
      include: {
        tools: {
          orderBy: { slotPosition: 'asc' },
        },
      },
      orderBy: { createdAt: 'desc' },
    });

    return loadouts.map((loadout) => ({
      id: loadout.id,
      playerId: loadout.playerId,
      name: loadout.name,
      description: loadout.description || undefined,
      isActive: loadout.isActive,
      createdAt: loadout.createdAt,
      updatedAt: loadout.updatedAt,
      tools: loadout.tools.map((tool: any) => ({
        toolId: tool.toolId,
        slotPosition: tool.slotPosition,
      })),
    }));
  }

  /**
   * Get active loadout for a player
   */
  async getActiveLoadout(playerId: number): Promise<LoadoutWithTools | null> {
    const loadout = await prisma.toolLoadouts.findFirst({
      where: { 
        playerId,
        isActive: true
      },
      include: {
        tools: {
          orderBy: { slotPosition: 'asc' },
        },
      },
    });

    if (!loadout) return null;

    return {
      id: loadout.id,
      playerId: loadout.playerId,
      name: loadout.name,
      description: loadout.description || undefined,
      isActive: loadout.isActive,
      createdAt: loadout.createdAt,
      updatedAt: loadout.updatedAt,
      tools: loadout.tools.map((tool: any) => ({
        toolId: tool.toolId,
        slotPosition: tool.slotPosition,
      })),
    };
  }

  /**
   * Create a new loadout
   */
  async createLoadout(
    playerId: number,
    name: string,
    description: string | undefined,
    toolIds: string[]
  ): Promise<{ success: boolean; error?: string; loadout?: LoadoutWithTools }> {
    // Check max loadouts (limit to 5)
    const count = await prisma.toolLoadouts.count({
      where: { playerId },
    });

    if (count >= 5) {
      return { success: false, error: 'MAX_LOADOUTS_REACHED' };
    }

    // Create loadout
    const loadout = await prisma.toolLoadouts.create({
      data: {
        playerId,
        name,
        description,
        isActive: false,
      },
    });

    // Add tools
    for (let i = 0; i < toolIds.length; i++) {
      await prisma.loadoutTools.create({
        data: {
          loadoutId: loadout.id,
          toolId: toolIds[i],
          slotPosition: i,
        },
      });
    }

    const fullLoadout = await this.getLoadoutById(loadout.id);
    return { success: true, loadout: fullLoadout || undefined };
  }

  /**
   * Update a loadout
   */
  async updateLoadout(
    loadoutId: number,
    playerId: number,
    name?: string,
    description?: string,
    toolIds?: string[]
  ): Promise<{ success: boolean; error?: string }> {
    // Verify ownership
    const loadout = await prisma.toolLoadouts.findFirst({
      where: { id: loadoutId, playerId },
    });

    if (!loadout) {
      return { success: false, error: 'LOADOUT_NOT_FOUND' };
    }

    // Update loadout info
    await prisma.toolLoadouts.update({
      where: { id: loadoutId },
      data: {
        name: name || loadout.name,
        description: description !== undefined ? description : loadout.description,
      },
    });

    // Update tools if provided
    if (toolIds) {
      // Delete existing tools
      await prisma.loadoutTools.deleteMany({
        where: { loadoutId },
      });

      // Add new tools
      for (let i = 0; i < toolIds.length; i++) {
        await prisma.loadoutTools.create({
          data: {
            loadoutId,
            toolId: toolIds[i],
            slotPosition: i,
          },
        });
      }
    }

    return { success: true };
  }

  /**
   * Delete a loadout
   */
  async deleteLoadout(
    loadoutId: number,
    playerId: number
  ): Promise<{ success: boolean; error?: string }> {
    const loadout = await prisma.toolLoadouts.findFirst({
      where: { id: loadoutId, playerId },
    });

    if (!loadout) {
      return { success: false, error: 'LOADOUT_NOT_FOUND' };
    }

    await prisma.toolLoadouts.delete({
      where: { id: loadoutId },
    });

    return { success: true };
  }

  /**
   * Equip a loadout (transfer tools to carried inventory)
   */
  async equipLoadout(
    loadoutId: number,
    playerId: number
  ): Promise<{ success: boolean; error?: string; missingTools?: string[] }> {
    const loadout = await prisma.toolLoadouts.findFirst({
      where: { id: loadoutId, playerId },
      include: { tools: true },
    });

    if (!loadout) {
      return { success: false, error: 'LOADOUT_NOT_FOUND' };
    }

    // Get player inventory capacity
    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { max_inventory_slots: true },
    });

    if (!player) {
      return { success: false, error: 'PLAYER_NOT_FOUND' };
    }

    const missingTools: string[] = [];
    const toolsToTransfer: Array<{ toolId: string; fromLocation: string }> = [];

    // Check if player has all tools in loadout
    for (const tool of loadout.tools) {
      // Check if in carried
      const inCarried = await prisma.playerTools.findFirst({
        where: { 
          playerId, 
          toolId: tool.toolId, 
          location: 'carried',
          durability: { gt: 0 }
        },
      });

      if (!inCarried) {
        // Check if in storage
        const inStorage = await prisma.playerTools.findFirst({
          where: { 
            playerId, 
            toolId: tool.toolId, 
            location: { not: 'carried' },
            durability: { gt: 0 }
          },
        });

        if (inStorage) {
          toolsToTransfer.push({ 
            toolId: tool.toolId, 
            fromLocation: inStorage.location 
          });
        } else {
          missingTools.push(tool.toolId);
        }
      }
    }

    if (missingTools.length > 0) {
      return { success: false, error: 'MISSING_TOOLS', missingTools };
    }

    // Transfer all tools to carried inventory
    const toolService = (await import('./toolService')).default;

    for (const { toolId, fromLocation } of toolsToTransfer) {
      const result = await toolService.transferTool(
        playerId,
        toolId,
        fromLocation,
        'carried',
        1
      );

      if (!result.success) {
        return { success: false, error: result.error };
      }
    }

    // Set as active loadout
    await prisma.toolLoadouts.updateMany({
      where: { playerId },
      data: { isActive: false },
    });

    await prisma.toolLoadouts.update({
      where: { id: loadoutId },
      data: { isActive: true },
    });

    return { success: true };
  }

  /**
   * Get loadout by ID
   */
  private async getLoadoutById(loadoutId: number): Promise<LoadoutWithTools | null> {
    const loadout = await prisma.toolLoadouts.findUnique({
      where: { id: loadoutId },
      include: {
        tools: {
          orderBy: { slotPosition: 'asc' },
        },
      },
    });

    if (!loadout) return null;

    return {
      id: loadout.id,
      playerId: loadout.playerId,
      name: loadout.name,
      description: loadout.description || undefined,
      isActive: loadout.isActive,
      createdAt: loadout.createdAt,
      updatedAt: loadout.updatedAt,
      tools: loadout.tools.map((tool: any) => ({
        toolId: tool.toolId,
        slotPosition: tool.slotPosition,
      })),
    };
  }
}

export default new LoadoutService();
