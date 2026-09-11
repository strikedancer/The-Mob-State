import { useEffect, useState } from "react";
import { adminService } from "../services/adminService";
import type { AdminLanguage } from "../i18n/translations";
import { getAdminTr } from "../i18n/inlineMessages";

const CHIP_KEYS = [
  { key: "event_chip_bronze", nl: "Brons", en: "Bronze" },
  { key: "event_chip_silver", nl: "Zilver", en: "Silver" },
  { key: "event_chip_gold", nl: "Goud", en: "Gold" },
] as const;

type Props = {
  locale: AdminLanguage;
  defaultPlayerId?: number;
};

export function EventChipGrantCard({ locale, defaultPlayerId }: Props) {
  const l = (nl: string, en: string) => getAdminTr(locale, nl, en);
  const [playerId, setPlayerId] = useState(
    defaultPlayerId ? String(defaultPlayerId) : "",
  );
  const [itemKey, setItemKey] = useState<(typeof CHIP_KEYS)[number]["key"]>(
    "event_chip_gold",
  );
  const [quantity, setQuantity] = useState("1");
  const [busy, setBusy] = useState(false);
  const [message, setMessage] = useState<string | null>(null);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    if (defaultPlayerId) setPlayerId(String(defaultPlayerId));
  }, [defaultPlayerId]);

  const submit = async () => {
    const id = parseInt(playerId, 10);
    const qty = parseInt(quantity, 10);
    if (!Number.isFinite(id) || id < 1 || !Number.isFinite(qty) || qty < 1) {
      setError(l("Vul een geldige speler-ID en aantal in.", "Enter a valid player ID and quantity."));
      return;
    }
    setBusy(true);
    setError(null);
    setMessage(null);
    try {
      await adminService.grantEventItem(id, itemKey, qty);
      setMessage(l("Event-item toegekend.", "Event item granted."));
    } catch (err) {
      setError(
        err instanceof Error
          ? err.message
          : l("Toekennen mislukt.", "Grant failed."),
      );
    } finally {
      setBusy(false);
    }
  };

  return (
    <div className="card mb-3">
      <div className="card-header">
        <h5 className="mb-0">
          {l("Event-chips toekennen", "Grant event chips")}
        </h5>
      </div>
      <div className="card-body">
        <p className="text-muted small">
          {l(
            "Alleen SUPER_ADMIN. Gebonden badges (rival) blijven buiten deze QA-flow.",
            "SUPER_ADMIN only. Bound badges (rival) stay out of this QA flow.",
          )}
        </p>
        {error && <div className="alert alert-danger py-2">{error}</div>}
        {message && <div className="alert alert-success py-2">{message}</div>}
        <div className="form-grid">
          <div className="form-group">
            <label>{l("Speler-ID", "Player ID")}</label>
            <input
              className="form-control"
              value={playerId}
              onChange={(e) => setPlayerId(e.target.value)}
            />
          </div>
          <div className="form-group">
            <label>{l("Chip", "Chip")}</label>
            <select
              className="form-select"
              value={itemKey}
              onChange={(e) =>
                setItemKey(e.target.value as (typeof CHIP_KEYS)[number]["key"])
              }
            >
              {CHIP_KEYS.map((row) => (
                <option key={row.key} value={row.key}>
                  {l(row.nl, row.en)}
                </option>
              ))}
            </select>
          </div>
          <div className="form-group">
            <label>{l("Aantal", "Quantity")}</label>
            <input
              className="form-control"
              type="number"
              min={1}
              max={1000}
              value={quantity}
              onChange={(e) => setQuantity(e.target.value)}
            />
          </div>
        </div>
        <button
          type="button"
          className="btn btn-primary mt-3"
          disabled={busy}
          onClick={() => void submit()}
        >
          {busy ? l("Bezig…", "Working…") : l("Toekennen", "Grant")}
        </button>
      </div>
    </div>
  );
}
