import express, { Response } from 'express';
import { authenticate, AuthRequest } from '../middleware/authenticate';
import { smugglingService, SmugglingCategory } from '../services/smugglingService';
import { gameEventService } from '../services/gameEventService';

const router = express.Router();

const SMUGGLING_CATEGORIES: SmugglingCategory[] = ['drug', 'trade', 'vehicle', 'weapon', 'ammo'];

function resolveSmugglingCategory(category: unknown, itemKey: unknown): SmugglingCategory | null {
  const key = String(itemKey ?? '');
  let normalized = String(category ?? '').toLowerCase() as SmugglingCategory;
  // Trade lots always use contraband_* keys; a stale client default of "drug" must not hide stock.
  if (key.startsWith('contraband_')) {
    normalized = 'trade';
  }
  return SMUGGLING_CATEGORIES.includes(normalized) ? normalized : null;
}

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
    const { category, itemKey, quantity, destinationCountry, metadata, channel, networkScope, transportMode, ownedTransportKey } = req.body;

    const categoryNormalized = resolveSmugglingCategory(category, itemKey);
    if (!categoryNormalized) {
      return res.status(200).json({ success: false, message: 'Ongeldige smokkelcategorie' });
    }

    if (!itemKey || !destinationCountry || !quantity || Number(quantity) < 1) {
      return res.status(200).json({ success: false, message: 'Onvolledige zending data' });
    }

    const result = await smugglingService.sendShipment(req.player!.id, {
      category: categoryNormalized,
      itemKey: String(itemKey),
      quantity: Number(quantity),
      destinationCountry: String(destinationCountry),
         channel,
         networkScope,
      transportMode,
      ownedTransportKey,
      metadata: metadata ?? {},
    });

    if (result.success) {
      gameEventService.recordContribution(req.player!.id, 'smuggling', Number(quantity)).catch(() => {});
    } else {
      console.warn('[Smuggling] send failed', {
        playerId: req.player!.id,
        category: categoryNormalized,
        itemKey,
        quantity,
        destinationCountry,
        message: result.message,
      });
    }
    return res.json(result);
  } catch (error) {
    console.error('Error sending smuggling shipment:', error);
    return res.status(500).json({ success: false, message: 'Server error' });
  }
});

router.post('/quote', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const { category, itemKey, quantity, destinationCountry, metadata, channel, networkScope, transportMode, ownedTransportKey } = req.body;

    const categoryNormalized = resolveSmugglingCategory(category, itemKey);
    if (!categoryNormalized) {
      return res.status(200).json({ success: false, message: 'Ongeldige smokkelcategorie' });
    }

    if (!itemKey || !destinationCountry || !quantity || Number(quantity) < 1) {
      return res.status(200).json({ success: false, message: 'Onvolledige quote data' });
    }

    const result = await smugglingService.quoteShipment(req.player!.id, {
      category: categoryNormalized,
      itemKey: String(itemKey),
      quantity: Number(quantity),
      destinationCountry: String(destinationCountry),
      channel,
      networkScope,
      transportMode,
      ownedTransportKey,
      metadata: metadata ?? {},
    });

    if (!result.success) {
      console.warn('[Smuggling] quote failed', {
        playerId: req.player!.id,
        category: categoryNormalized,
        itemKey,
        quantity,
        destinationCountry,
        message: result.message,
      });
    }
    return res.json(result);
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
