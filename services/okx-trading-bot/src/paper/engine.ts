import { config } from "../config.js";
import { logLine } from "../logger.js";
import type { SignalResult } from "../strategy/signals.js";
import {
  getOrInitState,
  insertOrder,
  saveState,
  type PaperState,
} from "./store.js";

function round8(n: number): number {
  return Math.round(n * 1e8) / 1e8;
}

export type PaperTickResult = {
  state: PaperState;
  actions: string[];
  lastPrice: number;
  signal: SignalResult;
};

/**
 * Paper execution at last price: BUY uses fraction of cash; SELL flattens position.
 */
export function applyPaperTick(
  instId: string,
  lastPrice: number,
  signal: SignalResult,
): PaperTickResult {
  const actions: string[] = [];
  let state = getOrInitState(instId, config.paperInitialUsdt);

  if (!Number.isFinite(lastPrice) || lastPrice <= 0) {
    actions.push("skip_bad_price");
    return { state, actions, lastPrice, signal };
  }

  const minConf = 0.35;

  if (
    signal.direction === "UP" &&
    signal.confidence >= minConf &&
    state.positionQty <= 1e-12
  ) {
    const budget = state.cashUsdt * config.paperPositionFraction;
    const qty = round8(budget / lastPrice);
    const cost = qty * lastPrice;
    if (qty > 0 && cost <= state.cashUsdt + 1e-8) {
      state = {
        ...state,
        cashUsdt: round8(state.cashUsdt - cost),
        positionQty: qty,
        avgEntry: lastPrice,
        updatedAt: new Date().toISOString(),
      };
      insertOrder(instId, "BUY", qty, "FILLED", lastPrice);
      saveState(state);
      actions.push(`buy_qty_${qty}_@${lastPrice}`);
      logLine("paper", "sim BUY", { instId, qty, lastPrice, cash: state.cashUsdt });
    } else {
      actions.push("buy_skipped_insufficient");
    }
  } else if (
    signal.direction === "DOWN" &&
    signal.confidence >= minConf &&
    state.positionQty > 1e-12
  ) {
    const qty = state.positionQty;
    const proceeds = round8(qty * lastPrice);
    state = {
      ...state,
      cashUsdt: round8(state.cashUsdt + proceeds),
      positionQty: 0,
      avgEntry: 0,
      updatedAt: new Date().toISOString(),
    };
    insertOrder(instId, "SELL", qty, "FILLED", lastPrice);
    saveState(state);
    actions.push(`sell_qty_${qty}_@${lastPrice}`);
    logLine("paper", "sim SELL", { instId, qty, lastPrice, cash: state.cashUsdt });
  } else {
    actions.push("hold");
  }

  return { state, actions, lastPrice, signal };
}

export function markToMarketEquity(state: PaperState, lastPrice: number): number {
  if (state.positionQty <= 0) return state.cashUsdt;
  return state.cashUsdt + state.positionQty * lastPrice;
}
