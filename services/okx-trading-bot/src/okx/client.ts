import { config } from "../config.js";
import { logLine } from "../logger.js";

export type OkxTicker = {
  instId: string;
  last: number;
  bid?: number;
  ask?: number;
  ts: number;
};

export type Candle = {
  ts: number;
  open: number;
  high: number;
  low: number;
  close: number;
  volume: number;
};

type OkxRestResponse<T> = { code: string; msg: string; data: T };

async function getJson<T>(path: string, params: Record<string, string>): Promise<T> {
  const url = new URL(path, config.okxBaseUrl);
  for (const [k, v] of Object.entries(params)) {
    url.searchParams.set(k, v);
  }
  const res = await fetch(url.toString(), {
    headers: { Accept: "application/json" },
  });
  if (!res.ok) {
    throw new Error(`OKX_HTTP_${res.status}`);
  }
  const body = (await res.json()) as OkxRestResponse<T>;
  if (body.code !== "0") {
    throw new Error(`OKX_API_${body.code}: ${body.msg}`);
  }
  return body.data;
}

/** Latest traded price (last). */
export async function fetchTicker(instId: string): Promise<OkxTicker> {
  const data = await getJson<Array<Record<string, string>>>(
    "/api/v5/market/ticker",
    { instId },
  );
  const row = data[0];
  if (!row) throw new Error("OKX_EMPTY_TICKER");
  const last = parseFloat(row.last ?? row.idxPx ?? "0");
  if (!Number.isFinite(last) || last <= 0) {
    throw new Error("OKX_BAD_LAST_PRICE");
  }
  const ts = parseInt(row.ts ?? "0", 10) || Date.now();
  return {
    instId: row.instId ?? instId,
    last,
    bid: row.bidPx ? parseFloat(row.bidPx) : undefined,
    ask: row.askPx ? parseFloat(row.askPx) : undefined,
    ts,
  };
}

/**
 * OKX candles: [ts, o, h, l, c, vol, volCcy, volCcyQuote, confirm]
 * docs: https://www.okx.com/docs-v5/en/#order-book-trading-market-data-get-candlesticks
 */
export async function fetchCandles(
  instId: string,
  bar: string,
  limit: number,
): Promise<Candle[]> {
  const lim = Math.min(300, Math.max(5, limit));
  const data = await getJson<string[][]>("/api/v5/market/candles", {
    instId,
    bar,
    limit: String(lim),
  });
  const candles: Candle[] = [];
  for (const row of data) {
    if (!row || row.length < 6) continue;
    const ts = parseInt(row[0]!, 10);
    const open = parseFloat(row[1]!);
    const high = parseFloat(row[2]!);
    const low = parseFloat(row[3]!);
    const close = parseFloat(row[4]!);
    const volume = parseFloat(row[5]!);
    if (!Number.isFinite(ts) || !Number.isFinite(close)) continue;
    candles.push({ ts, open, high, low, close, volume });
  }
  candles.sort((a, b) => a.ts - b.ts);
  logLine("okx", `candles ${instId} ${bar}`, { count: candles.length });
  return candles;
}

export async function fetchTickerWithFallback(instId: string): Promise<OkxTicker> {
  try {
    return await fetchTicker(instId);
  } catch (e) {
    logLine("okx", `ticker failed ${instId}`, {
      error: e instanceof Error ? e.message : String(e),
    });
    throw e;
  }
}
