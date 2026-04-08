import { Router } from 'express';
import { friendService } from '../services/friendService';
import { authenticate } from '../middleware/authenticate';
import { worldEventService } from '../services/worldEventService';

const router = Router();

/**
 * POST /friends/request
 * Send a friend request
 */
router.post('/request', authenticate, async (req, res) => {
  try {
    const playerId = req.player!.id;
    const { addresseeId } = req.body;

    if (!addresseeId || typeof addresseeId !== 'number') {
      return res.status(400).json({
        event: 'error.invalid_request',
        params: { reason: 'INVALID_REQUEST', message: 'addresseeId is required and must be a number' },
      });
    }

    const friendship = await friendService.sendFriendRequest(playerId, addresseeId);

    return res.status(200).json({
      event: 'friend.request_sent',
      params: { friendship },
    });
  } catch (error: any) {
    return res.status(500).json({
      event: 'error.friend_request_failed',
      params: { reason: 'FRIEND_REQUEST_FAILED', message: error.message },
    });
  }
});

/**
 * POST /friends/:id/accept
 * Accept a friend request
 */
router.post('/:id/accept', authenticate, async (req, res) => {
  try {
    const playerId = req.player!.id;
    const friendshipId = parseInt(req.params.id);
    console.log(`🔵 [friends/accept] Player ${playerId} accepting friendship ${friendshipId}`);

    if (isNaN(friendshipId)) {
      console.log(`❌ [friends/accept] Invalid friendship ID: ${req.params.id}`);
      return res.status(400).json({
        event: 'error.invalid_request',
        params: { reason: 'INVALID_REQUEST', message: 'Invalid friendship ID' },
      });
    }

    const friendship = await friendService.acceptFriendRequest(friendshipId, playerId);
    console.log(`✅ [friends/accept] Friendship accepted:`, friendship);

    return res.status(200).json({
      event: 'friend.request_accepted',
      params: { friendship },
    });
  } catch (error: any) {
    console.error(`❌ [friends/accept] Error:`, error);
    return res.status(500).json({
      event: 'error.accept_failed',
      params: { reason: 'ACCEPT_FAILED', message: error.message },
    });
  }
});

/**
 * POST /friends/:id/reject
 * Reject a friend request
 */
router.post('/:id/reject', authenticate, async (req, res) => {
  try {
    const playerId = req.player!.id;
    const friendshipId = parseInt(req.params.id);

    if (isNaN(friendshipId)) {
      return res.status(400).json({
        event: 'error.invalid_request',
        params: { reason: 'INVALID_REQUEST', message: 'Invalid friendship ID' },
      });
    }

    await friendService.rejectFriendRequest(friendshipId, playerId);

    return res.status(200).json({
      event: 'friend.request_rejected',
      params: {},
    });
  } catch (error: any) {
    return res.status(500).json({
      event: 'error.reject_failed',
      params: { reason: 'REJECT_FAILED', message: error.message },
    });
  }
});

/**
 * DELETE /friends/:id
 * Remove a friend (unfriend)
 */
router.delete('/:id', authenticate, async (req, res) => {
  try {
    const playerId = req.player!.id;
    const friendshipId = parseInt(req.params.id);

    console.log(`🔵 [friends/delete] Player ${playerId} removing friendship ${friendshipId}`);

    if (isNaN(friendshipId)) {
      console.log(`❌ [friends/delete] Invalid friendship ID`);
      return res.status(400).json({ error: 'Invalid friendship ID' });
    }

    await friendService.removeFriend(friendshipId, playerId);
    console.log(`✅ [friends/delete] Friendship ${friendshipId} removed`);

    res.json({ success: true, message: 'Friend removed' });
  } catch (error: any) {
    console.error(`❌ [friends/delete] Error:`, error);
    res.status(500).json({ error: error.message });
  }
});

/**
 * GET /friends
 * Get all friends (accepted friendships)
 */
router.get('/', authenticate, async (req, res) => {
  try {
    const playerId = req.player!.id;
    const friends = await friendService.getFriends(playerId);

    return res.status(200).json({
      event: 'friends.list',
      params: { friends },
    });
  } catch (error: any) {
    return res.status(500).json({
      event: 'error.fetch_failed',
      params: { reason: 'FETCH_FAILED', message: error.message },
    });
  }
});

/**
 * GET /friends/pending
 * Get pending friend requests (received)
 */
router.get('/pending', authenticate, async (req, res) => {
  try {
    const playerId = req.player!.id;
    console.log(`🔍 [friends/pending] Getting pending requests for player ${playerId}`);
    const requests = await friendService.getPendingRequests(playerId);
    console.log(`🔍 [friends/pending] Found ${requests.length} pending requests:`, requests);

    return res.status(200).json({
      event: 'friends.pending_requests',
      params: { requests },
    });
  } catch (error: any) {
    console.error(`❌ [friends/pending] Error:`, error);
    return res.status(500).json({
      event: 'error.fetch_failed',
      params: { reason: 'FETCH_FAILED', message: error.message },
    });
  }
});

/**
 * GET /friends/sent
 * Get sent friend requests (still pending)
 */
router.get('/sent', authenticate, async (req, res) => {
  try {
    const playerId = req.player!.id;
    const requests = await friendService.getSentRequests(playerId);

    return res.status(200).json({
      event: 'friends.sent_requests',
      params: { requests },
    });
  } catch (error: any) {
    return res.status(500).json({
      event: 'error.fetch_failed',
      params: { reason: 'FETCH_FAILED', message: error.message },
    });
  }
});

/**
 * GET /friends/search
 * Search for players by username
 */
router.get('/search', authenticate, async (req, res) => {
  try {
    const playerId = req.player!.id;
    const query = req.query.q as string;

    if (!query) {
      return res.status(400).json({
        event: 'error.invalid_request',
        params: { reason: 'INVALID_REQUEST', message: 'Search query (q) is required' },
      });
    }

    const results = await friendService.searchPlayers(query, playerId);

    return res.status(200).json({
      event: 'friends.search_results',
      params: { results },
    });
  } catch (error: any) {
    console.error('Search error:', error);
    return res.status(500).json({
      event: 'error.search_failed',
      params: { reason: 'SEARCH_FAILED', message: error.message },
    });
  }
});

/**
 * POST /friends/:playerId/block
 * Block a player
 */
router.post('/:playerId/block', authenticate, async (req, res) => {
  try {
    const requesterId = req.player!.id;
    const addresseeId = parseInt(req.params.playerId);

    if (isNaN(addresseeId)) {
      return res.status(400).json({
        event: 'error.invalid_request',
        params: { reason: 'INVALID_REQUEST', message: 'Invalid player ID' },
      });
    }

    const friendship = await friendService.blockPlayer(requesterId, addresseeId);

    return res.status(200).json({
      event: 'friend.blocked',
      params: { friendship },
    });
  } catch (error: any) {
    return res.status(500).json({
      event: 'error.block_failed',
      params: { reason: 'BLOCK_FAILED', message: error.message },
    });
  }
});

/**
 * POST /friends/:playerId/unblock
 * Unblock a player
 */
router.post('/:playerId/unblock', authenticate, async (req, res) => {
  try {
    const requesterId = req.player!.id;
    const addresseeId = parseInt(req.params.playerId);

    if (isNaN(addresseeId)) {
      return res.status(400).json({
        event: 'error.invalid_request',
        params: { reason: 'INVALID_REQUEST', message: 'Invalid player ID' },
      });
    }

    await friendService.unblockPlayer(requesterId, addresseeId);

    return res.status(200).json({
      event: 'friend.unblocked',
      params: { message: 'Player unblocked successfully' },
    });
  } catch (error: any) {
    return res.status(500).json({
      event: 'error.unblock_failed',
      params: { reason: 'UNBLOCK_FAILED', message: error.message },
    });
  }
});

/**
 * GET /friends/blocked
 * Get list of blocked players
 */
router.get('/blocked', authenticate, async (req, res) => {
  try {
    const playerId = req.player!.id;
    const blocked = await friendService.getBlockedPlayers(playerId);

    return res.status(200).json({
      event: 'friends.blocked_list',
      params: { blocked },
    });
  } catch (error: any) {
    return res.status(500).json({
      event: 'error.fetch_failed',
      params: { reason: 'FETCH_FAILED', message: error.message },
    });
  }
});

export default router;
