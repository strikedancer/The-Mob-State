import fs from "fs";
import path from "path";
import Database from "better-sqlite3";
import { config } from "../config.js";

let dbSingleton: Database.Database | null = null;

export function getDb(): Database.Database {
  if (dbSingleton) return dbSingleton;
  const dir = path.resolve(process.cwd(), config.dataDir);
  fs.mkdirSync(dir, { recursive: true });
  const dbPath = path.join(dir, "paper.sqlite");
  dbSingleton = new Database(dbPath);
  dbSingleton.exec(`
    CREATE TABLE IF NOT EXISTS paper_state (
      inst_id TEXT PRIMARY KEY,
      cash_usdt REAL NOT NULL,
      position_qty REAL NOT NULL DEFAULT 0,
      avg_entry REAL NOT NULL DEFAULT 0,
      updated_at TEXT NOT NULL
    );
    CREATE TABLE IF NOT EXISTS paper_orders (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      inst_id TEXT NOT NULL,
      side TEXT NOT NULL,
      qty REAL NOT NULL,
      status TEXT NOT NULL,
      fill_price REAL,
      created_at TEXT NOT NULL,
      filled_at TEXT
    );
    CREATE INDEX IF NOT EXISTS idx_orders_inst ON paper_orders(inst_id);
  `);
  return dbSingleton;
}

export type PaperState = {
  instId: string;
  cashUsdt: number;
  positionQty: number;
  avgEntry: number;
  updatedAt: string;
};

export function getOrInitState(instId: string, initialCash: number): PaperState {
  const db = getDb();
  const row = db
    .prepare("SELECT inst_id, cash_usdt, position_qty, avg_entry, updated_at FROM paper_state WHERE inst_id = ?")
    .get(instId) as
    | { inst_id: string; cash_usdt: number; position_qty: number; avg_entry: number; updated_at: string }
    | undefined;
  if (row) {
    return {
      instId: row.inst_id,
      cashUsdt: row.cash_usdt,
      positionQty: row.position_qty,
      avgEntry: row.avg_entry,
      updatedAt: row.updated_at,
    };
  }
  const now = new Date().toISOString();
  db.prepare(
    "INSERT INTO paper_state (inst_id, cash_usdt, position_qty, avg_entry, updated_at) VALUES (?, ?, 0, 0, ?)",
  ).run(instId, initialCash, now);
  return {
    instId,
    cashUsdt: initialCash,
    positionQty: 0,
    avgEntry: 0,
    updatedAt: now,
  };
}

export function saveState(s: PaperState): void {
  const db = getDb();
  db.prepare(
    "UPDATE paper_state SET cash_usdt = ?, position_qty = ?, avg_entry = ?, updated_at = ? WHERE inst_id = ?",
  ).run(s.cashUsdt, s.positionQty, s.avgEntry, s.updatedAt, s.instId);
}

export type OrderRow = {
  id: number;
  inst_id: string;
  side: string;
  qty: number;
  status: string;
  fill_price: number | null;
  created_at: string;
  filled_at: string | null;
};

export function insertOrder(
  instId: string,
  side: "BUY" | "SELL",
  qty: number,
  status: "FILLED" | "REJECTED",
  fillPrice: number | null,
): number {
  const db = getDb();
  const now = new Date().toISOString();
  const filledAt = status === "FILLED" ? now : null;
  const r = db
    .prepare(
      `INSERT INTO paper_orders (inst_id, side, qty, status, fill_price, created_at, filled_at)
       VALUES (?, ?, ?, ?, ?, ?, ?)`,
    )
    .run(instId, side, qty, status, fillPrice, now, filledAt);
  return Number(r.lastInsertRowid);
}

export function recentOrders(instId: string, limit: number): OrderRow[] {
  const db = getDb();
  return db
    .prepare(
      "SELECT id, inst_id, side, qty, status, fill_price, created_at, filled_at FROM paper_orders WHERE inst_id = ? ORDER BY id DESC LIMIT ?",
    )
    .all(instId, limit) as OrderRow[];
}
