import type { ReactNode } from "react";
import type { AdminLanguage } from "../i18n/translations";
import { getAdminTr } from "../i18n/inlineMessages";

export type FieldKind =
  | "int"
  | "bps"
  | "percent"
  | "euro"
  | "hours"
  | "grams"
  | "minutes"
  | "multiplier";

export type RuntimeConfigView = {
  defaults: Record<string, string>;
  values: Record<string, string | number>;
};

type PageIntroProps = {
  kicker: string;
  description: string;
  note?: string;
};

export function AdminPageIntro({ kicker, description, note }: PageIntroProps) {
  return (
    <div className="admin-page-intro">
      <span className="admin-kicker">{kicker}</span>
      <p className="text-muted mb-0">{description}</p>
      {note ? <p className="small text-muted mt-2 mb-0">{note}</p> : null}
    </div>
  );
}

type ToolbarProps = {
  locale: AdminLanguage;
  loading?: boolean;
  saving?: boolean;
  dirtyCount: number;
  disabled?: boolean;
  onRefresh?: () => void;
  onDiscard?: () => void;
  onSave?: () => void;
  saveLabel?: string;
};

export function RuntimeToolbar({
  locale,
  loading,
  saving,
  dirtyCount,
  disabled,
  onRefresh,
  onDiscard,
  onSave,
  saveLabel,
}: ToolbarProps) {
  const t = (nl: string, en: string) => getAdminTr(locale, nl, en);
  return (
    <div className="runtime-toolbar">
      <div>
        <div className="fw-semibold">
          {t("Runtime-configuratie", "Runtime configuration")}
        </div>
        <div className="small text-muted">
          {loading
            ? t("Laden…", "Loading…")
            : dirtyCount > 0
              ? t(
                  `${dirtyCount} niet-opgeslagen wijziging${dirtyCount === 1 ? "" : "en"}`,
                  `${dirtyCount} unsaved change${dirtyCount === 1 ? "" : "s"}`,
                )
              : t("Alles opgeslagen", "All changes saved")}
        </div>
      </div>
      <div className="d-flex flex-wrap gap-2">
        {onRefresh ? (
          <button
            type="button"
            className="btn btn-outline-secondary btn-sm"
            onClick={onRefresh}
            disabled={loading || saving || disabled}
          >
            <i className="ph-arrows-clockwise me-1" />
            {t("Ververs", "Refresh")}
          </button>
        ) : null}
        {onDiscard ? (
          <button
            type="button"
            className="btn btn-outline-secondary btn-sm"
            onClick={onDiscard}
            disabled={saving || disabled || dirtyCount === 0}
          >
            {t("Annuleren", "Discard")}
          </button>
        ) : null}
        {onSave ? (
          <button
            type="button"
            className="btn btn-primary btn-sm"
            disabled={saving || disabled || dirtyCount === 0}
            onClick={onSave}
          >
            {saving
              ? t("Opslaan…", "Saving…")
              : (saveLabel ?? t("Opslaan", "Save"))}
          </button>
        ) : null}
      </div>
    </div>
  );
}

export function RuntimeKpiGrid({ children }: { children: ReactNode }) {
  return <div className="runtime-kpi-grid">{children}</div>;
}

export function RuntimeKpi({
  label,
  value,
  hint,
}: {
  label: string;
  value: string;
  hint?: string;
}) {
  return (
    <div className="runtime-kpi">
      <div className="runtime-kpi-label">{label}</div>
      <div className="runtime-kpi-value">{value}</div>
      {hint ? <div className="small text-muted mt-1">{hint}</div> : null}
    </div>
  );
}

type FieldProps = {
  locale: AdminLanguage;
  label: string;
  help: string;
  fieldKey: string;
  kind: FieldKind;
  value: string;
  saved: string;
  fallback: string;
  disabled?: boolean;
  onChange: (next: string) => void;
  onReset?: () => void;
};

export function RuntimeField({
  locale,
  label,
  help,
  fieldKey,
  kind,
  value,
  saved,
  fallback,
  disabled,
  onChange,
  onReset,
}: FieldProps) {
  const t = (nl: string, en: string) => getAdminTr(locale, nl, en);
  const amount = parseAmount(value);
  const invalid = amount === null || amount < 0;
  const dirty = value !== saved;
  const custom = saved !== fallback && fallback !== "";
  const unit = unitLabel(locale, kind);

  return (
    <div
      className={`runtime-field ${dirty ? "is-dirty" : ""} ${invalid ? "is-invalid" : ""}`}
    >
      <div className="d-flex align-items-start justify-content-between gap-2 mb-1">
        <label className="form-label fw-semibold mb-0">{label}</label>
        <div className="d-flex flex-wrap gap-1">
          {dirty ? (
            <span className="badge bg-warning text-dark">
              {t("Niet opgeslagen", "Unsaved")}
            </span>
          ) : null}
          {!dirty && custom ? (
            <span className="badge bg-secondary">
              {t("Afwijkend", "Custom")}
            </span>
          ) : null}
        </div>
      </div>
      <div className="input-group">
        <input
          className={`form-control ${invalid ? "is-invalid" : ""}`}
          inputMode="decimal"
          value={value}
          onChange={(event) => onChange(event.target.value)}
          disabled={disabled}
          aria-label={label}
        />
        {unit ? <span className="input-group-text">{unit}</span> : null}
        {onReset ? (
          <button
            type="button"
            className="btn btn-outline-secondary"
            title={t("Terug naar standaard", "Reset to default")}
            disabled={disabled || value === fallback}
            onClick={onReset}
          >
            <i className="ph-arrow-counter-clockwise" />
          </button>
        ) : null}
      </div>
      <div className="runtime-field-meta">
        <span>
          {t("Live", "Live")}: {formatAmount(locale, kind, value)}
        </span>
        <span>
          {t("Standaard", "Default")}: {formatAmount(locale, kind, fallback)}
        </span>
      </div>
      <div className="small text-muted mt-1">{help}</div>
      <code className="runtime-key">{fieldKey}</code>
    </div>
  );
}

export function runtimeValueFor(
  view: RuntimeConfigView | null,
  key: string,
): string {
  if (!view) return "";
  const raw = view.values[key] ?? view.defaults[key] ?? "";
  return String(raw);
}

export function parseAmount(raw: string): number | null {
  const normalized = raw.trim().replace(",", ".");
  if (!normalized) return null;
  const value = Number(normalized);
  return Number.isFinite(value) ? value : null;
}

export function formatAmount(
  locale: AdminLanguage,
  kind: FieldKind,
  raw: string,
): string {
  const value = parseAmount(raw);
  if (value === null) return "—";
  const nf = locale === "nl" ? "nl-NL" : "en-GB";
  if (kind === "bps") {
    return `${(value / 100).toLocaleString(nf, {
      maximumFractionDigits: 2,
    })}%`;
  }
  if (kind === "percent") {
    return `${value.toLocaleString(nf, { maximumFractionDigits: 2 })}%`;
  }
  if (kind === "euro") {
    return `€${value.toLocaleString(nf)}`;
  }
  if (kind === "grams") {
    return `${value.toLocaleString(nf)} g`;
  }
  if (kind === "hours") {
    return locale === "nl"
      ? `${value.toLocaleString(nf)} u`
      : `${value.toLocaleString(nf)} h`;
  }
  if (kind === "minutes") {
    return locale === "nl"
      ? `${value.toLocaleString(nf)} min`
      : `${value.toLocaleString(nf)} min`;
  }
  if (kind === "multiplier") {
    return `×${value.toLocaleString(nf, { maximumFractionDigits: 3 })}`;
  }
  return value.toLocaleString(nf);
}

export function unitLabel(locale: AdminLanguage, kind: FieldKind): string {
  if (kind === "bps") return "bps";
  if (kind === "percent") return "%";
  if (kind === "euro") return "€";
  if (kind === "grams") return "g";
  if (kind === "hours") return locale === "nl" ? "u" : "h";
  if (kind === "minutes") return "min";
  if (kind === "multiplier") return "×";
  return "";
}

export function isInvalidAmount(raw: string): boolean {
  const amount = parseAmount(raw);
  return amount === null || amount < 0;
}
