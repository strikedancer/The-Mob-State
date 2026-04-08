import prisma from '../lib/prisma';
import { readFileSync } from 'fs';
import { join } from 'path';
import backpackService from './backpackService';

const { getPlayerCarryingCapacity } = backpackService;

interface ToolDefinition {
  id: string;
  name: string;
  type: string;
  basePrice: number;
  maxDurability: number;
  loseChance: number;
  wearPerUse: number;
  requiredFor: string[];
}

interface ToolsData {
  tools: ToolDefinition[];
}

const PROPERTY_STORAGE_RULES: Record<string, string[]> = {
  warehouse: ['tools'],
  nightclub: ['drugs'],
  house: ['weapons', 'cash'],
  apartment: ['weapons', 'cash'],
  mansion: ['weapons', 'cash'],
  penthouse: ['weapons', 'cash'],
  safehouse: ['weapons', 'cash'],
};

class ToolService {
  private tools: ToolDefinition[] = [];

  constructor() {
    this.loadTools();
    this.syncToolsToDatabaseOnStartup();
  }

  private loadTools() {
    const toolsPath = join(__dirname, '../../data/tools.json');
    const toolsData = readFileSync(toolsPath, 'utf-8');
    const data: ToolsData = JSON.parse(toolsData);
    this.tools = data.tools;
  }

  private syncToolsToDatabaseOnStartup() {
    void (async () => {
      try {
        for (const tool of this.tools) {
          await this.ensureCrimeToolExists(tool);
        }
        console.log(`[ToolService] Synced ${this.tools.length} tools to crime_tools`);
      } catch (error) {
        console.error('[ToolService] Failed to sync tools to crime_tools on startup:', error);
      }
    })();
  }

  /**
   * Get all tool definitions
   */
  getAllTools(): ToolDefinition[] {
    return this.tools;
  }

  /**
   * Get a specific tool definition by ID
   */
  getToolDefinition(toolId: string): ToolDefinition | undefined {
    return this.tools.find((t) => t.id === toolId);
  }

  getAllowedStorageCategories(propertyType: string): string[] {
    return PROPERTY_STORAGE_RULES[propertyType] ?? [];
  }

  private async ensureCrimeToolExists(tool: ToolDefinition): Promise<void> {
    const requiredFor = JSON.stringify(tool.requiredFor ?? []);

    await prisma.crimeTool.upsert({
      where: { id: tool.id },
      update: {
        name: tool.name,
        type: tool.type,
        basePrice: tool.basePrice,
        maxDurability: tool.maxDurability,
        loseChance: tool.loseChance,
        wearPerUse: tool.wearPerUse,
        requiredFor,
      },
      create: {
        id: tool.id,
        name: tool.name,
        type: tool.type,
        basePrice: tool.basePrice,
        maxDurability: tool.maxDurability,
        loseChance: tool.loseChance,
        wearPerUse: tool.wearPerUse,
        requiredFor,
      },
    });
  }

  /**
   * Get player's tool inventory with definitions
   */
  async getPlayerTools(playerId: number) {
    const inventory = await prisma.playerTools.findMany({
      where: { playerId },
      orderBy: { createdAt: 'desc' },
    });

    return inventory.map((item) => {
      const definition = this.getToolDefinition(item.toolId);
      return {
        ...definition,  // Tool definition first
        ...item,         // Player tool data (keeps numeric id)
        isBroken: item.durability <= 0,
        needsRepair: item.durability < 50,
      };
    });
  }

  /**
   * Buy a tool from the black market
   */
  async buyTool(
    playerId: number,
    toolId: string
  ): Promise<{ success: boolean; error?: string; tool?: any }> {
    const tool = this.getToolDefinition(toolId);

    if (!tool) {
      return { success: false, error: 'TOOL_NOT_FOUND' };
    }

    const player = await prisma.player.findUnique({
      where: { id: playerId },
    });

    if (!player) {
      return { success: false, error: 'PLAYER_NOT_FOUND' };
    }

    // Check if player has enough money
    if (player.money < tool.basePrice) {
      return { success: false, error: 'INSUFFICIENT_MONEY' };
    }

    try {
      await this.ensureCrimeToolExists(tool);

      // Check inventory capacity
      const canCarry = await this.canCarryTool(playerId, toolId, 1);
      if (!canCarry) {
        return { success: false, error: 'INVENTORY_FULL' };
      }

      // Check if player already has this tool in carried inventory
      const existing = await prisma.playerTools.findFirst({
        where: {
          playerId,
          toolId,
          location: 'carried',
        },
      });

      if (existing) {
        // Tool already exists in carried - increment quantity
        await prisma.playerTools.update({
          where: { id: existing.id },
          data: {
            quantity: existing.quantity + 1,
            durability: tool.maxDurability, // Reset durability for new purchase
          },
        });

        // Update player money and inventory usage
        const inventoryUsage = await this.calculateInventoryUsage(playerId);
        await prisma.player.update({
          where: { id: playerId },
          data: {
            money: player.money - tool.basePrice,
            inventory_slots_used: inventoryUsage,
          },
        });

        return {
          success: true,
          tool: {
            ...tool,
            ...existing,
            durability: tool.maxDurability,
            isBroken: false,
            needsRepair: false
          }
        };
      }

      // Buy new tool
      const newTool = await prisma.playerTools.create({
        data: {
          playerId,
          toolId,
          durability: tool.maxDurability,
          location: 'carried',
          quantity: 1,
        },
      });

      // Update player money and inventory usage
      const inventoryUsage = await this.calculateInventoryUsage(playerId);
      await prisma.player.update({
        where: { id: playerId },
        data: {
          money: player.money - tool.basePrice,
          inventory_slots_used: inventoryUsage,
        },
      });

      return {
        success: true,
        tool: {
          ...tool,
          ...newTool,
          isBroken: false,
          needsRepair: false
        }
      };
    } catch (error) {
      console.error('[ToolService] buyTool error:', error);
      return { success: false, error: 'DATABASE_ERROR' };
    }
  }

  /**
   * Check if player has a working tool in CARRIED inventory (durability > 0)
   */
  async hasWorkingTool(playerId: number, toolId: string): Promise<boolean> {
    const tool = await prisma.playerTools.findFirst({
      where: {
        playerId,
        toolId,
        location: 'carried',  // Only check carried inventory
        durability: { gt: 0 }
      },
    });

    return tool !== null;
  }

  /**
   * Use a tool (reduce durability, possibly lose it)
   * Returns true if tool was lost, false otherwise
   */
  async useTool(playerId: number, toolId: string): Promise<boolean> {
    const toolDef = this.getToolDefinition(toolId);
    if (!toolDef) {
      throw new Error(`Tool definition not found: ${toolId}`);
    }

    const tool = await prisma.playerTools.findFirst({
      where: {
        playerId,
        toolId,
        location: 'carried',
      },
    });

    if (!tool) {
      throw new Error(`Player does not have tool: ${toolId}`);
    }

    if (tool.durability <= 0) {
      throw new Error(`Tool is broken: ${toolId}`);
    }

    // Calculate new durability
    const newDurability = Math.max(0, tool.durability - toolDef.wearPerUse);

    // Check if tool is lost (random chance)
    const isLost = Math.random() < toolDef.loseChance;

    if (isLost || newDurability <= 0) {
      // Tool is lost or broken - delete it
      await prisma.playerTools.delete({
        where: { id: tool.id },
      });
      return true; // Tool was lost
    } else {
      // Tool still exists - update durability
      await prisma.playerTools.update({
        where: { id: tool.id },
        data: { durability: newDurability },
      });
      return false; // Tool still exists
    }
  }

  /**
   * Confiscate all tools from player (when caught by police)
   * Removes all carried tools regardless of durability
   */
  async confiscateTools(playerId: number, toolIds: string[]): Promise<number> {
    let confiscatedCount = 0;

    for (const toolId of toolIds) {
      const tool = await prisma.playerTools.findFirst({
        where: {
          playerId,
          toolId,
          location: 'carried',
        },
      });

      if (tool) {
        await prisma.playerTools.delete({
          where: { id: tool.id },
        });
        confiscatedCount++;
      }
    }

    return confiscatedCount;
  }

  /**
   * Repair a tool to maximum durability
   */
  async repairTool(
    playerId: number,
    toolId: string
  ): Promise<{ success: boolean; error?: string; cost?: number }> {
    const toolDef = this.getToolDefinition(toolId);
    if (!toolDef) {
      return { success: false, error: 'TOOL_NOT_FOUND' };
    }

    const tool = await prisma.playerTools.findFirst({
      where: {
        playerId,
        toolId,
        location: 'carried',
      },
    });

    if (!tool) {
      return { success: false, error: 'TOOL_NOT_OWNED' };
    }

    if (tool.durability >= toolDef.maxDurability) {
      return { success: false, error: 'TOOL_ALREADY_MAX' };
    }

    // Repair cost is 50% of base price
    const repairCost = Math.floor(toolDef.basePrice * 0.5);

    const player = await prisma.player.findUnique({
      where: { id: playerId },
    });

    if (!player) {
      return { success: false, error: 'PLAYER_NOT_FOUND' };
    }

    if (player.money < repairCost) {
      return { success: false, error: 'INSUFFICIENT_MONEY' };
    }

    // Repair tool
    await prisma.playerTools.update({
      where: { id: tool.id },
      data: { durability: toolDef.maxDurability },
    });

    await prisma.player.update({
      where: { id: playerId },
      data: { money: player.money - repairCost },
    });

    return { success: true, cost: repairCost };
  }

  /**
   * Get required tools for a crime
   */
  getRequiredToolsForCrime(crimeId: string): string[] {
    return this.tools
      .filter((tool) => tool.requiredFor.includes(crimeId))
      .map((tool) => tool.id);
  }

  /**
   * Check if player has all required tools for a crime
   * Only checks carried inventory (location = 'carried')
   */
  async hasRequiredToolsForCrime(
    playerId: number,
    crimeId: string
  ): Promise<{ hasAll: boolean; missingTools: string[]; toolsInStorage: string[] }> {
    const requiredTools = this.getRequiredToolsForCrime(crimeId);

    if (requiredTools.length === 0) {
      return { hasAll: true, missingTools: [], toolsInStorage: [] };
    }

    const missingTools: string[] = [];
    const toolsInStorage: string[] = [];

    for (const toolId of requiredTools) {
      const hasTool = await this.hasWorkingTool(playerId, toolId);
      if (!hasTool) {
        // Check if tool exists in storage
        const inStorage = await this.hasToolInStorage(playerId, toolId);
        if (inStorage) {
          toolsInStorage.push(toolId);
        } else {
          missingTools.push(toolId);
        }
      }
    }

    return {
      hasAll: missingTools.length === 0 && toolsInStorage.length === 0,
      missingTools,
      toolsInStorage,
    };
  }

  /**
   * Get only tools in carried inventory
   */
  async getCarriedTools(playerId: number) {
    const tools = await prisma.playerTools.findMany({
      where: { 
        playerId,
        location: 'carried'
      },
      orderBy: { createdAt: 'desc' },
    });

    return tools.map((item) => {
      const definition = this.getToolDefinition(item.toolId);
      return {
        ...definition,
        ...item,
        isBroken: item.durability <= 0,
        needsRepair: item.durability < 50,
      };
    });
  }

  /**
   * Get tools stored in a specific property
   */
  async getPropertyStorage(playerId: number, propertyId: number) {
    const tools = await prisma.playerTools.findMany({
      where: { 
        playerId,
        location: `property_${propertyId}`
      },
      orderBy: { createdAt: 'desc' },
    });

    return tools.map((item) => {
      const definition = this.getToolDefinition(item.toolId);
      return {
        ...definition,
        ...item,
        isBroken: item.durability <= 0,
        needsRepair: item.durability < 50,
      };
    });
  }

  /**
   * Check if player has tool in ANY storage location (not carried)
   */
  async hasToolInStorage(playerId: number, toolId: string): Promise<boolean> {
    const tool = await prisma.playerTools.findFirst({
      where: {
        playerId,
        toolId,
        location: { not: 'carried' },
        durability: { gt: 0 }
      },
    });

    return tool !== null;
  }

  /**
   * Calculate current inventory usage
   */
  async calculateInventoryUsage(playerId: number): Promise<number> {
    const carriedTools = await prisma.playerTools.findMany({
      where: { 
        playerId,
        location: 'carried'
      },
    });

    const weaponInventory = await prisma.weaponInventory.findMany({
      where: { playerId },
      select: { quantity: true },
    });

    let totalSlots = 0;
    for (const tool of carriedTools) {
      const def = this.getToolDefinition(tool.toolId);
      if (def) {
        const slotSize = (def as any).slotSize || 1;
        totalSlots += slotSize * tool.quantity;
      }
    }

    const weaponSlots = weaponInventory.reduce(
      (sum, item) => sum + (item.quantity || 0),
      0,
    );

    totalSlots += weaponSlots;

    return totalSlots;
  }

  /**
   * Check if player can carry more tools
   */
  async canCarryTool(playerId: number, toolId: string, quantity: number = 1): Promise<boolean> {
    // Get player's total carrying capacity (base + backpack)
    const maxSlots = await getPlayerCarryingCapacity(playerId);

    const currentUsage = await this.calculateInventoryUsage(playerId);
    const toolDef = this.getToolDefinition(toolId);
    if (!toolDef) return false;

    const slotSize = (toolDef as any).slotSize || 1;
    const requiredSlots = slotSize * quantity;

    return (currentUsage + requiredSlots) <= maxSlots;
  }

  /**
   * Transfer tool between locations
   */
  async transferTool(
    playerId: number,
    toolId: string,
    fromLocation: string,
    toLocation: string,
    quantity: number = 1
  ): Promise<{ success: boolean; error?: string }> {
    // Validate locations
    if (fromLocation === toLocation) {
      return { success: false, error: 'SAME_LOCATION' };
    }

    // Find the tool in source location
    const tool = await prisma.playerTools.findFirst({
      where: {
        playerId,
        toolId,
        location: fromLocation,
      },
    });

    if (!tool) {
      return { success: false, error: 'TOOL_NOT_FOUND_IN_SOURCE' };
    }

    if (tool.quantity < quantity) {
      return { success: false, error: 'INSUFFICIENT_QUANTITY' };
    }

    // If transferring TO carried inventory, check capacity
    if (toLocation === 'carried') {
      const canCarry = await this.canCarryTool(playerId, toolId, quantity);
      if (!canCarry) {
        return { success: false, error: 'INVENTORY_FULL' };
      }
    }

    // If transferring TO property, verify player owns it
    if (toLocation.startsWith('property_')) {
      const propertyId = parseInt(toLocation.split('_')[1]);
      const ownsProperty = await prisma.property.findFirst({
        where: { id: propertyId, playerId },
      });

      if (!ownsProperty) {
        return { success: false, error: 'NOT_PROPERTY_OWNER' };
      }

      const player = await prisma.player.findUnique({
        where: { id: playerId },
        select: { currentCountry: true },
      });

      if (!player || player.currentCountry !== ownsProperty.countryId) {
        return { success: false, error: 'WRONG_COUNTRY' };
      }

      const allowedCategories = this.getAllowedStorageCategories(
        ownsProperty.propertyType,
      );

      if (!allowedCategories.includes('tools')) {
        return { success: false, error: 'STORAGE_TYPE_NOT_ALLOWED' };
      }

      // Check property storage capacity
      const storageUsage = await this.getPropertyStorageUsage(playerId, propertyId);
      const capacity = await this.getPropertyStorageCapacity(ownsProperty.propertyType);
      
      const toolDef = this.getToolDefinition(toolId);
      const slotSize = (toolDef as any)?.slotSize || 1;
      const requiredSlots = slotSize * quantity;

      if (storageUsage + requiredSlots > capacity) {
        return { success: false, error: 'STORAGE_FULL' };
      }
    }

    if (fromLocation.startsWith('property_')) {
      const propertyId = parseInt(fromLocation.split('_')[1]);
      const ownsProperty = await prisma.property.findFirst({
        where: { id: propertyId, playerId },
      });

      if (!ownsProperty) {
        return { success: false, error: 'NOT_PROPERTY_OWNER' };
      }

      const player = await prisma.player.findUnique({
        where: { id: playerId },
        select: { currentCountry: true },
      });

      if (!player || player.currentCountry !== ownsProperty.countryId) {
        return { success: false, error: 'WRONG_COUNTRY' };
      }
    }

    // Check if tool already exists in destination
    const existingInDest = await prisma.playerTools.findFirst({
      where: {
        playerId,
        toolId,
        location: toLocation,
      },
    });

    if (existingInDest) {
      // Update quantity in destination
      await prisma.playerTools.update({
        where: { id: existingInDest.id },
        data: { quantity: existingInDest.quantity + quantity },
      });
    } else {
      // Create new entry in destination
      await prisma.playerTools.create({
        data: {
          playerId,
          toolId,
          location: toLocation,
          durability: tool.durability,
          quantity,
        },
      });
    }

    // Update source quantity or delete if none left
    if (tool.quantity === quantity) {
      await prisma.playerTools.delete({
        where: { id: tool.id },
      });
    } else {
      await prisma.playerTools.update({
        where: { id: tool.id },
        data: { quantity: tool.quantity - quantity },
      });
    }

    // Log the transfer
    await prisma.toolTransfers.create({
      data: {
        playerId,
        toolId,
        fromLocation,
        toLocation,
        quantity,
        durability: tool.durability,
      },
    });

    // Update inventory_slots_used if transferring to/from carried
    if (fromLocation === 'carried' || toLocation === 'carried') {
      const newUsage = await this.calculateInventoryUsage(playerId);
      await prisma.player.update({
        where: { id: playerId },
        data: { inventory_slots_used: newUsage },
      });
    }

    return { success: true };
  }

  /**
   * Get property storage capacity by type
   */
  async getPropertyStorageCapacity(propertyType: string): Promise<number> {
    const capacity = await prisma.propertyStorageCapacity.findUnique({
      where: { propertyType },
    });

    return capacity?.maxSlots || 20; // Default to 20
  }

  /**
   * Get property storage usage
   */
  async getPropertyStorageUsage(playerId: number, propertyId: number): Promise<number> {
    const tools = await prisma.playerTools.findMany({
      where: { 
        playerId,
        location: `property_${propertyId}`
      },
    });

    let totalSlots = 0;
    for (const tool of tools) {
      const def = this.getToolDefinition(tool.toolId);
      if (def) {
        const slotSize = (def as any).slotSize || 1;
        totalSlots += slotSize * tool.quantity;
      }
    }

    return totalSlots;
  }

  /**
   * Get storage overview for all player properties
   */
  async getStorageOverview(playerId: number) {
    const properties = await prisma.property.findMany({
      where: { playerId },
    });

    const overview = [];

    for (const property of properties) {
      const allowedCategories = this.getAllowedStorageCategories(property.propertyType);
      const supportsTools = allowedCategories.includes('tools');
      const usage = supportsTools
        ? await this.getPropertyStorageUsage(playerId, property.id)
        : 0;
      const capacity = await this.getPropertyStorageCapacity(property.propertyType);
      const tools = supportsTools
        ? await this.getPropertyStorage(playerId, property.id)
        : [];

      overview.push({
        propertyId: property.id,
        propertyType: property.propertyType,
        propertyCountry: property.country,
        allowedCategories,
        usage,
        capacity,
        percentFull: capacity > 0 ? Math.round((usage / capacity) * 100) : 0,
        toolCount: tools.length,
        tools,
      });
    }

    return overview;
  }
}

export default new ToolService();
