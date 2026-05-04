import type { OkxTicker, Candle } from "../okx/client.js";
import type { SignalResult } from "../strategy/signals.js";
import type { PaperState } from "../paper/store.js";

export type BotSnapshot = {
  at: string;
  instId: string;
  mode: "paper" | "live";
  ticker: OkxTicker;
  candles: Candle[];
  signal: SignalResult;
  paper: {
    state: PaperState;
    equity: number;
    actions: string[];
  };
};

let snapshot: BotSnapshot | null = null;

export function setSnapshot(s: BotSnapshot): void {
  snapshot = s;
}

export function getSnapshot(): BotSnapshot | null {
  return snapshot;
}
