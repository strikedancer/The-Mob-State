import { Response } from 'express';

interface SSEClient {
  id: string;
  response: Response;
}

class EventBroadcaster {
  private clients: Map<string, SSEClient> = new Map();

  /**
   * Add a new SSE client
   */
  addClient(id: string, response: Response): void {
    this.clients.set(id, { id, response });
    console.log(`📡 SSE client connected: ${id} (total: ${this.clients.size})`);

    // Send initial connection event
    this.sendToClient(id, {
      event: 'connection.established',
      params: { clientId: id },
    });
  }

  /**
   * Remove an SSE client
   */
  removeClient(id: string): void {
    this.clients.delete(id);
    console.log(`📡 SSE client disconnected: ${id} (total: ${this.clients.size})`);
  }

  /**
   * Broadcast event to all connected clients
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
   * Send event to specific client
   */
  private sendToClient(
    id: string,
    eventData: { event: string; params: Record<string, unknown> }
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

  /**
   * Get number of connected clients
   */
  getClientCount(): number {
    return this.clients.size;
  }
}

// Export singleton instance
export const eventBroadcaster = new EventBroadcaster();
