import { config } from "../config.js";
import { logLine } from "../logger.js";
import { fetchCandles, fetchTicker } from "../okx/client.js";
import { computeSignal } from "../strategy/signals.js";
import { applyPaperTick, markToMarketEquity } from "../paper/engine.js";
import { getOrInitState } from "../paper/store.js";
import { getSnapshot, setSnapshot, type BotSnapshot } from "./state.js";

let interval: ReturnType<typeof setInterval> | null = null;

export async function runOneTick(): Promise<BotSnapshot | null> {
  const instId = config.instId;
  try {
    const [ticker, candles] = await Promise.all([
      fetchTicker(instId),
      fetchCandles(instId, config.bar, config.candleLimit),
    ]);
    const signal = computeSignal(candles);
    let paperState = getOrInitState(instId, config.paperInitialUsdt);
    let actions: string[] = [];
    if (config.tradingMode === "paper") {
      const r = applyPaperTick(instId, ticker.last, signal);
      paperState = r.state;
      actions = r.actions;
    } else {
      logLine("bot", "LIVE mode: order routing not enabled in this build; snapshot only");
    }

    const equity = markToMarketEquity(paperState, ticker.last);
    const snap: BotSnapshot = {
      at: new Date().toISOString(),
      instId,
      mode: config.tradingMode,
      ticker,
      candles: candles.slice(-60),
      signal,
      paper: { state: paperState, equity, actions },
    };
    setSnapshot(snap);
    logLine("bot", "tick", {
      last: ticker.last,
      direction: signal.direction,
      equity,
    });
    return snap;
  } catch (e) {
    logLine("bot", "tick failed", { error: e instanceof Error ? e.message : String(e) });
    return getSnapshot();
  }
}

export function startBotLoop(): void {
  if (interval) return;
  void runOneTick();
  interval = setInterval(() => {
    void runOneTick();
  }, config.tickIntervalMs);
  logLine("bot", `loop started every ${config.tickIntervalMs}ms`);
}

export function stopBotLoop(): void {
  if (interval) {
    clearInterval(interval);
    interval = null;
  }
}
