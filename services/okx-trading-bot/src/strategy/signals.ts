import type { Candle } from "../okx/client.js";

export type SignalDirection = "UP" | "DOWN" | "NEUTRAL";

export type SignalResult = {
  direction: SignalDirection;
  score: number;
  confidence: number;
  reasons: string[];
  smaShort?: number;
  smaLong?: number;
  rsi?: number;
};

function sma(values: number[], period: number): number | undefined {
  if (values.length < period) return undefined;
  let sum = 0;
  for (let i = values.length - period; i < values.length; i++) {
    sum += values[i]!;
  }
  return sum / period;
}

function rsi(closes: number[], period: number): number | undefined {
  if (closes.length < period + 1) return undefined;
  let gains = 0;
  let losses = 0;
  for (let i = closes.length - period; i < closes.length; i++) {
    const ch = closes[i]! - closes[i - 1]!;
    if (ch >= 0) gains += ch;
    else losses -= ch;
  }
  const avgGain = gains / period;
  const avgLoss = losses / period;
  if (avgLoss === 0) return 100;
  const rs = avgGain / avgLoss;
  return 100 - 100 / (1 + rs);
}

/**
 * Simple trend + momentum: short SMA vs long SMA + RSI band.
 * Score in [-1, 1] rough directional bias.
 */
export function computeSignal(candles: Candle[]): SignalResult {
  const reasons: string[] = [];
  if (candles.length < 40) {
    return {
      direction: "NEUTRAL",
      score: 0,
      confidence: 0,
      reasons: ["insufficient_candles"],
    };
  }

  const closes = candles.map((c) => c.close);
  const shortP = 8;
  const longP = 21;
  const sShort = sma(closes, shortP);
  const sLong = sma(closes, longP);
  const rsiVal = rsi(closes, 14);

  if (sShort === undefined || sLong === undefined) {
    return {
      direction: "NEUTRAL",
      score: 0,
      confidence: 0,
      reasons: ["sma_undefined"],
      smaShort: sShort,
      smaLong: sLong,
      rsi: rsiVal,
    };
  }

  const spreadPct = (sShort - sLong) / sLong;
  let score = Math.max(-1, Math.min(1, spreadPct * 50));

  if (rsiVal !== undefined) {
    if (rsiVal < 30) {
      reasons.push("rsi_oversold");
      score += 0.15;
    } else if (rsiVal > 70) {
      reasons.push("rsi_overbought");
      score -= 0.15;
    }
  }

  score = Math.max(-1, Math.min(1, score));

  let direction: SignalDirection = "NEUTRAL";
  if (score > 0.12) direction = "UP";
  else if (score < -0.12) direction = "DOWN";

  const confidence = Math.min(1, Math.abs(score) * 1.2);

  reasons.push(`sma${shortP}_vs_${longP}:${spreadPct.toFixed(5)}`);
  if (rsiVal !== undefined) reasons.push(`rsi14:${rsiVal.toFixed(1)}`);

  return {
    direction,
    score,
    confidence,
    reasons,
    smaShort: sShort,
    smaLong: sLong,
    rsi: rsiVal,
  };
}
