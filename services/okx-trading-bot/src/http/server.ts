import express from "express";
import cors from "cors";
import path from "path";
import { fileURLToPath } from "url";
import { config } from "../config.js";
import { getRecentLogs } from "../logger.js";
import { getSnapshot } from "../bot/state.js";
import { recentOrders } from "../paper/store.js";

const __dirname = path.dirname(fileURLToPath(import.meta.url));

function authMiddleware(req: express.Request, res: express.Response, next: express.NextFunction) {
  const token = config.adminToken;
  if (!token) {
    res.status(503).json({ error: "BOT_ADMIN_TOKEN not configured" });
    return;
  }
  const hdr = req.headers.authorization;
  const bearer = hdr?.startsWith("Bearer ") ? hdr.slice(7) : undefined;
  const q = typeof req.query.token === "string" ? req.query.token : undefined;
  if (bearer === token || q === token) {
    next();
    return;
  }
  res.status(401).json({ error: "Unauthorized" });
}

export function createServer(): express.Application {
  const app = express();
  const origins = config.corsOrigins.split(",").map((s) => s.trim());
  app.use(
    cors({
      origin: origins[0] === "*" ? true : origins,
      credentials: true,
    }),
  );
  app.use(express.json());

  const publicDir = path.join(__dirname, "..", "..", "public");
  app.use(express.static(publicDir));

  app.get("/health", (_req, res) => {
    res.json({ ok: true, instId: config.instId, mode: config.tradingMode });
  });

  app.get("/api/status", authMiddleware, (_req, res) => {
    res.json({ snapshot: getSnapshot(), logsTail: getRecentLogs().slice(-80) });
  });

  app.get("/api/orders", authMiddleware, (req, res) => {
    const limit = Math.min(200, Math.max(5, parseInt(String(req.query.limit ?? "50"), 10) || 50));
    res.json({ orders: recentOrders(config.instId, limit) });
  });

  app.get("/dashboard", (_req, res) => {
    res.sendFile(path.join(publicDir, "index.html"));
  });

  app.get("/", (_req, res) => {
    res.redirect(302, "/dashboard");
  });

  return app;
}

export function listenApp(app: express.Application): ReturnType<express.Application["listen"]> {
  return app.listen(config.port, () => {
    console.log(`[okx-trading-bot] listening on :${config.port}`);
  });
}
