import express, { Response } from 'express';
import { authenticate, AuthRequest } from '../middleware/authenticate';
import { smugglingService, SmugglingCategory } from '../services/smugglingService';
import { gameEventService } from '../services/gameEventService';

const router = express.Router();

router.get('/catalog', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const networkScope = req.query.networkScope;
    const scope = networkScope === 'crew' ? 'crew' : 'personal';
    const result = await smugglingService.getCatalog(req.player!.id, scope);
    return res.json(result);
  } catch (error) {
    console.error('Error loading smuggling catalog:', error);
    return res.status(500).json({ success: false, message: 'Server error' });
  }
});

router.post('/send', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const { category, itemKey, quantity, destinationCountry, metadata, channel, networkScope } = req.body;

    const categoryNormalized = String(category ?? '').toLowerCase() as SmugglingCategory;
    const allowed: SmugglingCategory[] = ['drug', 'trade', 'vehicle', 'weapon', 'ammo'];
    if (!allowed.includes(categoryNormalized)) {
      return res.status(400).json({ success: false, message: 'Ongeldige smokkelcategorie' });
    }

    if (!itemKey || !destinationCountry || !quantity || Number(quantity) < 1) {
      return res.status(400).json({ success: false, message: 'Onvolledige zending data' });
    }

    const result = await smugglingService.sendShipment(req.player!.id, {
      category: categoryNormalized,
      itemKey: String(itemKey),
      quantity: Number(quantity),
      destinationCountry: String(destinationCountry),
         channel,
         networkScope,
      metadata: metadata ?? {},
    });

    if (result.success) {
      return res.json(result);
    }

    return res.status(400).json(result);
  } catch (error) {
    console.error('Error sending smuggling shipment:', error);
    return res.status(500).json({ success: false, message: 'Server error' });
  }
});

router.post('/quote', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const { category, itemKey, quantity, destinationCountry, metadata, channel, networkScope } = req.body;

    const categoryNormalized = String(category ?? '').toLowerCase() as SmugglingCategory;
    const allowed: SmugglingCategory[] = ['drug', 'trade', 'vehicle', 'weapon', 'ammo'];
    if (!allowed.includes(categoryNormalized)) {
      return res.status(400).json({ success: false, message: 'Ongeldige smokkelcategorie' });
    }

    if (!itemKey || !destinationCountry || !quantity || Number(quantity) < 1) {
      return res.status(400).json({ success: false, message: 'Onvolledige quote data' });
    }

    const result = await smugglingService.quoteShipment(req.player!.id, {
      category: categoryNormalized,
      itemKey: String(itemKey),
      quantity: Number(quantity),
      destinationCountry: String(destinationCountry),
      channel,
      networkScope,
      metadata: metadata ?? {},
    });

    if (result.success) {
      gameEventService.recordContribution(req.player!.id, 'smuggling', Number(quantity)).catch(() => {});
      return res.json(result);
    }

    return res.status(400).json(result);
  } catch (error) {
    console.error('Error calculating smuggling quote:', error);
    return res.status(500).json({ success: false, message: 'Server error' });
  }
});

router.get('/overview', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const result = await smugglingService.getOverview(
      req.player!.id,
      req.player!.currentCountry || 'netherlands'
    );
    return res.json(result);
  } catch (error) {
    console.error('Error loading smuggling overview:', error);
    return res.status(500).json({ success: false, message: 'Server error' });
  }
});

router.post('/claim-current', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const scope = req.body?.scope;
    const result = await smugglingService.claimCurrentDepot(req.player!.id, scope);
    if (result.success) {
      return res.json(result);
    }
    return res.status(400).json(result);
  } catch (error) {
    console.error('Error claiming depot shipments:', error);
    return res.status(500).json({ success: false, message: 'Server error' });
  }
});

export default router;
