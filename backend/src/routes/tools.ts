import { Router, Response } from 'express';
import { authenticate, AuthRequest } from '../middleware/authenticate';
import toolService from '../services/toolService';
import backpackService from '../services/backpackService';
import prisma from '../lib/prisma';

const { getPlayerCarryingCapacity } = backpackService;

const router = Router();

/**
 * GET /tools
 * Get all tool definitions
 */
router.get('/', async (_, res: Response) => {
  const tools = toolService.getAllTools();
  console.log('[DEBUG] GET /tools - Returning tools:', JSON.stringify(tools).substring(0, 200));

  return res.status(200).json({
    event: 'tools.list',
    params: {},
    tools,
  });
});

/**
 * GET /tools/inventory
 * Get player's tool inventory
 */
router.get('/inventory', authenticate, async (req: AuthRequest, res: Response) => {
  const tools = await toolService.getPlayerTools(req.player!.id);
  console.log('[DEBUG] GET /tools/inventory - Returning tools:', JSON.stringify(tools).substring(0, 300));

  return res.status(200).json({
    event: 'tools.inventory',
    params: {},
    tools,
  });
});

/**
 * POST /tools/buy/:toolId
 * Buy a tool from the black market
 */
router.post('/buy/:toolId', authenticate, async (req: AuthRequest, res: Response) => {
  const { toolId } = req.params;

  const result = await toolService.buyTool(req.player!.id, String(toolId));

  if (!result.success) {
    let message = 'Could not buy tool';
    let statusCode = 400;

    switch (result.error) {
      case 'TOOL_NOT_FOUND':
        message = 'Tool not found';
        statusCode = 404;
        break;
      case 'INSUFFICIENT_MONEY':
        message = 'You don\'t have enough money to buy this tool';
        statusCode = 403;
        break;
      case 'INVENTORY_FULL':
        message = 'Your inventory is full. Store some tools or upgrade capacity';
        statusCode = 403;
        break;
      case 'DATABASE_ERROR':
        message = 'Tool purchase failed due to a server issue';
        statusCode = 500;
        break;
    }

    return res.status(statusCode).json({
      event: 'error.tool_purchase',
      params: {
        reason: result.error,
        message,
      },
    });
  }

  return res.status(200).json({
    event: 'tools.purchased',
    params: {
      toolId,
    },
    tool: result.tool,
  });
});

/**
 * POST /tools/repair/:toolId
 * Repair a tool to maximum durability
 */
router.post('/repair/:toolId', authenticate, async (req: AuthRequest, res: Response) => {
  const { toolId } = req.params;

  const result = await toolService.repairTool(req.player!.id, String(toolId));

  if (!result.success) {
    let message = 'Could not repair tool';
    let statusCode = 400;

    switch (result.error) {
      case 'TOOL_NOT_FOUND':
        message = 'Tool not found';
        statusCode = 404;
        break;
      case 'TOOL_NOT_OWNED':
        message = 'You don\'t own this tool';
        statusCode = 403;
        break;
      case 'TOOL_ALREADY_MAX':
        message = 'Tool is already at maximum durability';
        statusCode = 400;
        break;
      case 'INSUFFICIENT_MONEY':
        message = 'You don\'t have enough money to repair this tool';
        statusCode = 403;
        break;
    }

    return res.status(statusCode).json({
      event: 'error.tool_repair',
      params: {
        reason: result.error,
        message,
      },
    });
  }

  return res.status(200).json({
    event: 'tools.repaired',
    params: {
      toolId,
      cost: result.cost,
    },
  });
});

/**
 * GET /tools/carried
 * Get only tools in carried inventory
 */
router.get('/carried', authenticate, async (req: AuthRequest, res: Response) => {
  const tools = await toolService.getCarriedTools(req.player!.id);
  console.log('[DEBUG] GET /tools/carried - Returning tools:', JSON.stringify(tools).substring(0, 300));
  const maxSlots = await getPlayerCarryingCapacity(req.player!.id);
  const slotsUsed = await toolService.calculateInventoryUsage(req.player!.id);

  await prisma.player.update({
    where: { id: req.player!.id },
    data: { inventory_slots_used: slotsUsed },
  });

  return res.status(200).json({
    event: 'tools.carried',
    params: {
      slotsUsed,
      maxSlots: maxSlots,
    },
    tools,
  });
});

/**
 * GET /tools/storage/:propertyId
 * Get tools stored in a specific property
 */
router.get('/storage/:propertyId', authenticate, async (req: AuthRequest, res: Response) => {
  const propertyId = parseInt(req.params.propertyId);

  // Verify ownership
  const property = await prisma.property.findFirst({
    where: { id: propertyId, playerId: req.player!.id },
  });

  if (!property) {
    return res.status(404).json({
      event: 'error.property_not_found',
      params: {
        message: 'Property not found or not owned by you',
      },
    });
  }

  const tools = await toolService.getPropertyStorage(req.player!.id, propertyId);
  const usage = await toolService.getPropertyStorageUsage(req.player!.id, propertyId);
  const capacity = await toolService.getPropertyStorageCapacity(property.propertyType);

  return res.status(200).json({
    event: 'tools.storage',
    params: {
      propertyId,
      propertyType: property.propertyType,
      usage,
      capacity,
      percentFull: capacity > 0 ? Math.round((usage / capacity) * 100) : 0,
    },
    tools,
  });
});

/**
 * GET /tools/storage-overview
 * Get storage overview for all player properties
 */
router.get('/storage-overview', authenticate, async (req: AuthRequest, res: Response) => {
  const overview = await toolService.getStorageOverview(req.player!.id);

  return res.status(200).json({
    event: 'tools.storage_overview',
    params: {},
    storage: overview,
  });
});

/**
 * POST /tools/transfer
 * Transfer tool between locations
 */
router.post('/transfer', authenticate, async (req: AuthRequest, res: Response) => {
  const { toolId, fromLocation, toLocation, quantity } = req.body;

  if (!toolId || !fromLocation || !toLocation) {
    return res.status(400).json({
      event: 'error.invalid_request',
      params: {
        message: 'toolId, fromLocation, and toLocation are required',
      },
    });
  }

  const result = await toolService.transferTool(
    req.player!.id,
    toolId,
    fromLocation,
    toLocation,
    quantity || 1
  );

  if (!result.success) {
    let message = 'Could not transfer tool';
    let statusCode = 400;

    switch (result.error) {
      case 'SAME_LOCATION':
        message = 'Source and destination are the same';
        break;
      case 'TOOL_NOT_FOUND_IN_SOURCE':
        message = 'Tool not found in source location';
        statusCode = 404;
        break;
      case 'INSUFFICIENT_QUANTITY':
        message = 'Not enough tools to transfer';
        break;
      case 'INVENTORY_FULL':
        message = 'Your inventory is full. Store some tools or upgrade capacity';
        statusCode = 403;
        break;
      case 'NOT_PROPERTY_OWNER':
        message = 'You do not own this property';
        statusCode = 403;
        break;
      case 'STORAGE_FULL':
        message = 'Property storage is full';
        statusCode = 403;
        break;
      case 'STORAGE_TYPE_NOT_ALLOWED':
        message = 'This property does not support tool storage';
        statusCode = 403;
        break;
      case 'WRONG_COUNTRY':
        message = 'You must be in the same country as the property';
        statusCode = 403;
        break;
    }

    return res.status(statusCode).json({
      event: 'error.tool_transfer',
      params: {
        reason: result.error,
        message,
      },
    });
  }

  return res.status(200).json({
    event: 'tools.transferred',
    params: {
      toolId,
      fromLocation,
      toLocation,
      quantity: quantity || 1,
    },
  });
});

export default router;
