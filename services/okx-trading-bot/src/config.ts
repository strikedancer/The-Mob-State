import "dotenv/config";

function envString(name: string, fallback: string): string {
  const v = process.env[name];
  return v != null && v.trim() !== "" ? v.trim() : fallback;
}

function envInt(name: string, fallback: number): number {
  const v = process.env[name];
  if (v == null || v === "") return fallback;
  const n = parseInt(v, 10);
  return Number.isFinite(n) ? n : fallback;
}

function envFloat(name: string, fallback: number): number {
  const v = process.env[name];
  if (v == null || v === "") return fallback;
  const n = parseFloat(v);
  return Number.isFinite(n) ? n : fallback;
}

export const config = {
  port: envInt("PORT", 3847),
  adminToken: envString("BOT_ADMIN_TOKEN", ""),
  corsOrigins: envString("CORS_ORIGINS", "*"),
  okxBaseUrl: envString("OKX_BASE_URL", "https://www.okx.com").replace(/\/$/, ""),
  instId: envString("OKX_INST_ID", "BTC-USDT"),
  bar: envString("OKX_BAR", "15m"),
  candleLimit: Math.min(300, Math.max(20, envInt("OKX_CANDLE_LIMIT", 120))),
  tradingMode: envString("TRADING_MODE", "paper") as "paper" | "live",
  paperInitialUsdt: envFloat("PAPER_INITIAL_USDT", 10_000),
  paperPositionFraction: Math.min(1, Math.max(0.01, envFloat("PAPER_POSITION_FRACTION", 0.2))),
  tickIntervalMs: Math.max(5_000, envInt("TICK_INTERVAL_MS", 60_000)),
  dataDir: envString("OKX_BOT_DATA_DIR", ".data"),
};

export function assertConfig(): void {
  if (!config.adminToken || config.adminToken === "change-me-to-a-long-random-secret") {
    console.warn(
      "[okx-trading-bot] Warning: set BOT_ADMIN_TOKEN in .env to a strong secret before exposing this service.",
    );
  }
}
