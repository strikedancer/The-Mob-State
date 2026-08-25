import { Response } from 'express';

interface SSEClient {
  id: string;
  playerId: number | null;
  response: Response;
}

class EventBroadcaster {
  private clients: Map<string, SSEClient> = new Map();
  private clientsByPlayer: Map<number, Set<string>> = new Map();

  /**
   * Add a new SSE client (optionally scoped to a player for personal feeds).
   */
  addClient(id: string, response: Response, playerId?: number | null): void {
    const scopedPlayerId =
      typeof playerId === 'number' && Number.isFinite(playerId) ? playerId : null;
    this.clients.set(id, { id, response, playerId: scopedPlayerId });
    if (scopedPlayerId != null) {
      const set = this.clientsByPlayer.get(scopedPlayerId) ?? new Set<string>();
      set.add(id);
      this.clientsByPlayer.set(scopedPlayerId, set);
    }
    console.log(
      `📡 SSE client connected: ${id} player=${scopedPlayerId ?? 'anon'} (total: ${this.clients.size})`,
    );

    this.sendToClient(id, {
      event: 'connection.established',
      params: { clientId: id },
    });
  }

  /**
   * Remove an SSE client
   */
  removeClient(id: string): void {
    const client = this.clients.get(id);
    if (client?.playerId != null) {
      const set = this.clientsByPlayer.get(client.playerId);
      if (set) {
        set.delete(id);
        if (set.size === 0) this.clientsByPlayer.delete(client.playerId);
      }
    }
    this.clients.delete(id);
    console.log(`📡 SSE client disconnected: ${id} (total: ${this.clients.size})`);
  }

  /**
   * Broadcast event to all connected clients (legacy / rare global signals).
   */
  broadcast(eventData: { event: string; params: Record<string, unknown> }): void {
    const message = `data: ${JSON.stringify(eventData)}\n\n`;

    this.clients.forEach((client) => {
      try {
        client.response.write(message);
      } catch (error) {
        console.error(`Failed to send to client ${client.id}:`, error);
        this.removeClient(client.id);
      }
    });
  }

  /**
   * Send event only to SSE clients registered for this player.
   */
  sendToPlayer(
    playerId: number,
    eventData: { event: string; params: Record<string, unknown> },
  ): void {
    const clientIds = this.clientsByPlayer.get(playerId);
    if (!clientIds || clientIds.size === 0) return;

    for (const clientId of [...clientIds]) {
      this.sendToClient(clientId, eventData);
    }
  }

  private sendToClient(
    id: string,
    eventData: { event: string; params: Record<string, unknown> },
  ): void {
    const client = this.clients.get(id);
    if (client) {
      const message = `data: ${JSON.stringify(eventData)}\n\n`;
      try {
        client.response.write(message);
      } catch (error) {
        console.error(`Failed to send to client ${id}:`, error);
        this.removeClient(id);
      }
    }
  }

  getClientCount(): number {
    return this.clients.size;
  }
}

export const eventBroadcaster = new EventBroadcaster();
