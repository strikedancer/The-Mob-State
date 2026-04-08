import { Router, Response } from 'express';
import { authenticate, AuthRequest } from '../middleware/authenticate';
import loadoutService from '../services/loadoutService';

const router = Router();

/**
 * GET /loadouts
 * Get all loadouts for the authenticated player
 */
router.get('/', authenticate, async (req: AuthRequest, res: Response) => {
  const loadouts = await loadoutService.getPlayerLoadouts(req.player!.id);

  return res.status(200).json({
    event: 'loadouts.list',
    params: {},
    loadouts,
  });
});

/**
 * GET /loadouts/active
 * Get currently active loadout
 */
router.get('/active', authenticate, async (req: AuthRequest, res: Response) => {
  const loadout = await loadoutService.getActiveLoadout(req.player!.id);

  if (!loadout) {
    return res.status(404).json({
      event: 'error.loadout_not_found',
      params: {
        message: 'No active loadout',
      },
    });
  }

  return res.status(200).json({
    event: 'loadouts.active',
    params: {},
    loadout,
  });
});

/**
 * POST /loadouts/create
 * Create a new loadout
 */
router.post('/create', authenticate, async (req: AuthRequest, res: Response) => {
  const { name, description, toolIds } = req.body;

  if (!name || !toolIds || !Array.isArray(toolIds)) {
    return res.status(400).json({
      event: 'error.invalid_request',
      params: {
        message: 'name and toolIds (array) are required',
      },
    });
  }

  const result = await loadoutService.createLoadout(
    req.player!.id,
    name,
    description,
    toolIds
  );

  if (!result.success) {
    let message = 'Could not create loadout';
    let statusCode = 400;

    if (result.error === 'MAX_LOADOUTS_REACHED') {
      message = 'Maximum loadouts reached (5). Delete one to create a new loadout';
      statusCode = 403;
    }

    return res.status(statusCode).json({
      event: 'error.loadout_create',
      params: {
        reason: result.error,
        message,
      },
    });
  }

  return res.status(200).json({
    event: 'loadouts.created',
    params: {},
    loadout: result.loadout,
  });
});

/**
 * PUT /loadouts/:loadoutId
 * Update a loadout
 */
router.put('/:loadoutId', authenticate, async (req: AuthRequest, res: Response) => {
  const loadoutId = parseInt(req.params.loadoutId);
  const { name, description, toolIds } = req.body;

  const result = await loadoutService.updateLoadout(
    loadoutId,
    req.player!.id,
    name,
    description,
    toolIds
  );

  if (!result.success) {
    return res.status(404).json({
      event: 'error.loadout_not_found',
      params: {
        message: 'Loadout not found or not owned by you',
      },
    });
  }

  return res.status(200).json({
    event: 'loadouts.updated',
    params: {
      loadoutId,
    },
  });
});

/**
 * DELETE /loadouts/:loadoutId
 * Delete a loadout
 */
router.delete('/:loadoutId', authenticate, async (req: AuthRequest, res: Response) => {
  const loadoutId = parseInt(req.params.loadoutId);

  const result = await loadoutService.deleteLoadout(loadoutId, req.player!.id);

  if (!result.success) {
    return res.status(404).json({
      event: 'error.loadout_not_found',
      params: {
        message: 'Loadout not found or not owned by you',
      },
    });
  }

  return res.status(200).json({
    event: 'loadouts.deleted',
    params: {
      loadoutId,
    },
  });
});

/**
 * POST /loadouts/:loadoutId/equip
 * Equip a loadout (transfer tools to carried inventory)
 */
router.post('/:loadoutId/equip', authenticate, async (req: AuthRequest, res: Response) => {
  const loadoutId = parseInt(req.params.loadoutId);

  const result = await loadoutService.equipLoadout(loadoutId, req.player!.id);

  if (!result.success) {
    let message = 'Could not equip loadout';
    let statusCode = 400;

    switch (result.error) {
      case 'LOADOUT_NOT_FOUND':
        message = 'Loadout not found';
        statusCode = 404;
        break;
      case 'MISSING_TOOLS':
        message = `Missing tools: ${result.missingTools?.join(', ')}. Buy them first`;
        statusCode = 403;
        break;
      case 'INVENTORY_FULL':
        message = 'Your inventory is full. Store some tools first';
        statusCode = 403;
        break;
    }

    return res.status(statusCode).json({
      event: 'error.loadout_equip',
      params: {
        reason: result.error,
        message,
        missingTools: result.missingTools,
      },
    });
  }

  return res.status(200).json({
    event: 'loadouts.equipped',
    params: {
      loadoutId,
    },
  });
});

export default router;
