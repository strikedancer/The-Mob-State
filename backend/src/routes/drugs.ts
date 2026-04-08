import express, { Response } from 'express';
import { authenticate, AuthRequest } from '../middleware/authenticate';
import drugService from '../services/drugService';
import { drugSmugglingService } from '../services/drugSmugglingService';
import { gameEventService } from '../services/gameEventService';

const router = express.Router();

/**
 * @route   GET /drugs/catalog
 * @desc    Get all available drugs
 * @access  Private
 */
router.get('/catalog', authenticate, (_req: AuthRequest, res: Response) => {
  try {
    const drugs = drugService.getAllDrugs();
    res.json({ success: true, drugs });
  } catch (error: any) {
    console.error('Error fetching drug catalog:', error);
    res.status(500).json({ success: false, message: 'Server error' });
  }
});

/**
 * @route   GET /drugs/materials
 * @desc    Get all production materials
 * @access  Private
 */
router.get('/materials', authenticate, (_req: AuthRequest, res: Response) => {
  try {
    const materials = drugService.getAllMaterials();
    res.json({ success: true, materials });
  } catch (error: any) {
    console.error('Error fetching materials:', error);
    res.status(500).json({ success: false, message: 'Server error' });
  }
});

/**
 * @route   GET /drugs/my-materials
 * @desc    Get player's material inventory
 * @access  Private
 */
router.get('/my-materials', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const materials = await drugService.getPlayerMaterials(req.player!.id);
    res.json({ success: true, materials });
  } catch (error: any) {
    console.error('Error fetching player materials:', error);
    res.status(500).json({ success: false, message: 'Server error' });
  }
});

/**
 * @route   POST /drugs/materials/buy/:materialId
 * @desc    Buy production materials
 * @access  Private
 */
router.post('/materials/buy/:materialId', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const { materialId } = req.params;
    const { quantity } = req.body;

    if (!quantity || quantity < 1) {
      return res.status(400).json({ success: false, message: 'Ongeldige hoeveelheid' });
    }

    const result = await drugService.buyMaterial(
      req.player!.id,
      materialId,
      typeof quantity === 'string' ? parseInt(quantity) : quantity
    );
    
    if (result.success) {
      return res.json(result);
    } else {
      return res.status(400).json(result);
    }
  } catch (error: any) {
    console.error('Error buying material:', error);
    return res.status(500).json({ success: false, message: 'Server error' });
  }
});

/**
 * @route   POST /drugs/start-production
 * @desc    Start drug production
 * @access  Private
 */
router.post('/start-production', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const { drugId, propertyId } = req.body;

    if (!drugId) {
      return res.status(400).json({ success: false, message: 'Drug type vereist' });
    }

    const result = await drugService.startProduction(
      req.player!.id,
      drugId,
      propertyId ? parseInt(propertyId) : undefined
    );

    if (result.success) {
      return res.json(result);
    } else {
      return res.status(400).json(result);
    }
  } catch (error: any) {
    console.error('Error starting production:', error);
    return res.status(500).json({ success: false, message: 'Server error' });
  }
});

/**
 * @route   GET /drugs/productions
 * @desc    Get active productions
 * @access  Private
 */
router.get('/productions', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const productions = await drugService.getActiveProductions(req.player!.id);
    res.json({ success: true, productions });
  } catch (error: any) {
    console.error('Error fetching productions:', error);
    res.status(500).json({ success: false, message: 'Server error' });
  }
});

/**
 * @route   POST /drugs/collect/:productionId
 * @desc    Collect finished production
 * @access  Private
 */
router.post('/collect/:productionId', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const { productionId } = req.params;

    const result = await drugService.collectProduction(
      req.player!.id,
      typeof productionId === 'string' ? parseInt(productionId) : parseInt(productionId[0])
    );

    if (result.success) {
      return res.json(result);
    } else {
      return res.status(400).json(result);
    }
  } catch (error: any) {
    console.error('Error collecting production:', error);
    return res.status(500).json({ success: false, message: 'Server error' });
  }
});

/**
 * @route   GET /drugs/inventory
 * @desc    Get player's drug inventory
 * @access  Private
 */
router.get('/inventory', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const inventory = await drugService.getDrugInventory(req.player!.id);
    res.json({ success: true, inventory });
  } catch (error: any) {
    console.error('Error fetching drug inventory:', error);
    res.status(500).json({ success: false, message: 'Server error' });
  }
});

/**
 * @route   POST /drugs/sell
 * @desc    Sell drugs
 * @access  Private
 */
router.post('/sell', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const { drugType, quantity, quality = 'C' } = req.body;

    if (!drugType || !quantity || quantity < 1) {
      return res.status(400).json({ success: false, message: 'Drug type en hoeveelheid vereist' });
    }

    const result = await drugService.sellDrugs(
      req.player!.id,
      drugType,
      typeof quantity === 'string' ? parseInt(quantity) : quantity,
      quality
    );

    if (result.success) {
      return res.json(result);
    } else {
      return res.status(400).json(result);
    }
  } catch (error: any) {
    console.error('Error selling drugs:', error);
    return res.status(500).json({ success: false, message: 'Server error' });
  }
});

/**
 * @route   GET /drugs/storage/:propertyId
 * @desc    Get drugs stored in a property
 * @access  Private
 */
router.get('/storage/:propertyId', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const { propertyId } = req.params;
    const result = await drugService.getPropertyStorage(
      req.player!.id,
      parseInt(propertyId)
    );
    res.json(result);
  } catch (error: any) {
    console.error('Error fetching property storage:', error);
    return res.status(500).json({ success: false, message: 'Server error' });
  }
});

/**
 * @route   POST /drugs/store
 * @desc    Store drugs in a property
 * @access  Private
 */
router.post('/store', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const { propertyId, drugType, quantity } = req.body;

    if (!propertyId || !drugType || !quantity || quantity < 1) {
      return res.status(400).json({ success: false, message: 'Property ID, drug type en hoeveelheid vereist' });
    }

    const result = await drugService.storeDrugs(
      req.player!.id,
      parseInt(propertyId),
      drugType,
      typeof quantity === 'string' ? parseInt(quantity) : quantity
    );

    if (result.success) {
      const qty = typeof quantity === 'string' ? parseInt(quantity, 10) : (quantity as number);
      gameEventService.recordContribution(req.player!.id, 'drugs', qty).catch(() => {});
      return res.json(result);
    } else {
      return res.status(400).json(result);
    }
  } catch (error: any) {
    console.error('Error storing drugs:', error);
    return res.status(500).json({ success: false, message: 'Server error' });
  }
});

/**
 * @route   POST /drugs/retrieve
 * @desc    Retrieve drugs from a property
 * @access  Private
 */
router.post('/retrieve', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const { propertyId, drugType, quantity } = req.body;

    if (!propertyId || !drugType || !quantity || quantity < 1) {
      return res.status(400).json({ success: false, message: 'Property ID, drug type en hoeveelheid vereist' });
    }

    const result = await drugService.retrieveDrugs(
      req.player!.id,
      parseInt(propertyId),
      drugType,
      typeof quantity === 'string' ? parseInt(quantity) : quantity
    );

    if (result.success) {
      return res.json(result);
    } else {
      return res.status(400).json(result);
    }
  } catch (error: any) {
    console.error('Error retrieving drugs:', error);
    return res.status(500).json({ success: false, message: 'Server error' });
  }
});

/**
 * @route   GET /drugs/market-prices
 * @desc    Get daily market price multipliers for all drugs
 * @access  Private
 */
router.get('/market-prices', authenticate, (_req: AuthRequest, res: Response) => {
  try {
    const prices = drugService.getAllMarketPrices();
    res.json({ success: true, prices });
  } catch (error: any) {
    console.error('Error fetching market prices:', error);
    res.status(500).json({ success: false, message: 'Server error' });
  }
});

/**
 * @route   GET /drugs/heat
 * @desc    Get player drug heat level
 * @access  Private
 */
router.get('/heat', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const heat = await drugService.getDrugHeat(req.player!.id);
    res.json({ success: true, ...heat });
  } catch (error: any) {
    console.error('Error fetching heat:', error);
    res.status(500).json({ success: false, message: 'Server error' });
  }
});

/**
 * @route   GET /drugs/stats
 * @desc    Get player drug analytics
 * @access  Private
 */
router.get('/stats', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const stats = await drugService.getDrugStats(req.player!.id);
    res.json({ success: true, stats });
  } catch (error: any) {
    console.error('Error fetching drug stats:', error);
    res.status(500).json({ success: false, message: 'Server error' });
  }
});

/**
 * @route   POST /drugs/cut
 * @desc    Cut drugs (reduce quality for more units)
 * @access  Private
 */
router.post('/cut', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const { drugType, quality, quantity } = req.body;

    if (!drugType || !quality || !quantity || quantity < 1) {
      return res.status(400).json({ success: false, message: 'Drug type, kwaliteit en hoeveelheid vereist' });
    }

    const result = await drugService.cutDrugs(
      req.player!.id,
      drugType,
      quality,
      typeof quantity === 'string' ? parseInt(quantity) : quantity
    );

    if (result.success) {
      return res.json(result);
    } else {
      return res.status(400).json(result);
    }
  } catch (error: any) {
    console.error('Error cutting drugs:', error);
    return res.status(500).json({ success: false, message: 'Server error' });
  }
});

/**
 * @route   POST /drugs/auto-collect-toggle
 * @desc    Toggle VIP auto-collect setting
 * @access  Private
 */
router.post('/auto-collect-toggle', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const result = await drugService.toggleAutoCollect(req.player!.id);
    if (result.success) {
      return res.json(result);
    } else {
      return res.status(400).json(result);
    }
  } catch (error: any) {
    console.error('Error toggling auto-collect:', error);
    return res.status(500).json({ success: false, message: 'Server error' });
  }
});

/**
 * @route   POST /drugs/smuggling/send
 * @desc    Send drug shipment to a foreign depot
 * @access  Private
 */
router.post('/smuggling/send', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const { destinationCountry, drugType, quantity, quality = 'C' } = req.body;

    if (!destinationCountry || !drugType || !quantity || quantity < 1) {
      return res.status(400).json({ success: false, message: 'Bestemming, drug type en hoeveelheid vereist' });
    }

    const result = await drugSmugglingService.sendShipment(
      req.player!.id,
      destinationCountry,
      drugType,
      typeof quantity === 'string' ? parseInt(quantity) : quantity,
      quality
    );

    if (result.success) {
      return res.json(result);
    }

    return res.status(400).json(result);
  } catch (error: any) {
    console.error('Error sending smuggling shipment:', error);
    return res.status(500).json({ success: false, message: 'Server error' });
  }
});

/**
 * @route   GET /drugs/smuggling/overview
 * @desc    Get shipments + depot status for all countries
 * @access  Private
 */
router.get('/smuggling/overview', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const player = req.player!;
    const result = await drugSmugglingService.getOverview(player.id, player.currentCountry || 'netherlands');
    return res.json(result);
  } catch (error: any) {
    console.error('Error fetching smuggling overview:', error);
    return res.status(500).json({ success: false, message: 'Server error' });
  }
});

/**
 * @route   POST /drugs/smuggling/claim-current
 * @desc    Claim all ready shipments from current-country depot
 * @access  Private
 */
router.post('/smuggling/claim-current', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const result = await drugSmugglingService.claimReadyInCurrentCountry(req.player!.id);
    if (result.success) {
      return res.json(result);
    }

    return res.status(400).json(result);
  } catch (error: any) {
    console.error('Error claiming current depot shipments:', error);
    return res.status(500).json({ success: false, message: 'Server error' });
  }
});

export default router;
