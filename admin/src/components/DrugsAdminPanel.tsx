import { useEffect, useMemo, useState } from "react";
import {
  adminService,
  type DrugRuntimeConfigView,
} from "../services/adminService";
import type { AdminLanguage } from "../i18n/translations";
import { getAdminTr } from "../i18n/inlineMessages";

type Props = {
  locale: AdminLanguage;
};

type FieldKind = "int" | "bps" | "percent" | "euro" | "hours" | "grams";

type FieldDef = {
  key: string;
  kind: FieldKind;
  labelNl: string;
  labelEn: string;
  helpNl: string;
  helpEn: string;
};

type SectionDef = {
  id: string;
  icon: string;
  titleNl: string;
  titleEn: string;
  blurbNl: string;
  blurbEn: string;
  fields: FieldDef[];
};

const SECTIONS: SectionDef[] = [
  {
    id: "wholesale",
    icon: "ph-package",
    titleNl: "Groothandel-export",
    titleEn: "Wholesale export",
    blurbNl:
      "B2B-prijs blijft onder de straatprijs van de bestemming. Spread, volume en schaarste stapelen op.",
    blurbEn:
      "B2B price stays under destination street. Spread, volume and scarcity stack.",
    fields: [
      {
        key: "DRUG_WHOLESALE_MIN_GRAMS",
        kind: "grams",
        labelNl: "Minimumzending",
        labelEn: "Minimum shipment",
        helpNl: "Kleinste groothandel-export per zending.",
        helpEn: "Smallest wholesale export per shipment.",
      },
      {
        key: "DRUG_WHOLESALE_SPREAD_BPS",
        kind: "bps",
        labelNl: "B2B-spread onder straatprijs",
        labelEn: "B2B spread under street price",
        helpNl: "Basis korting t.o.v. straatprijs op bestemming.",
        helpEn: "Base discount versus destination street price.",
      },
      {
        key: "DRUG_WHOLESALE_VOLUME_BONUS_BPS_PER_KG",
        kind: "bps",
        labelNl: "Volumebonus per kg",
        labelEn: "Volume bonus per kg",
        helpNl: "Extra prijs per extra kilogram.",
        helpEn: "Extra price per additional kilogram.",
      },
      {
        key: "DRUG_WHOLESALE_VOLUME_BONUS_CAP_BPS",
        kind: "bps",
        labelNl: "Volumebonus-plafond",
        labelEn: "Volume bonus cap",
        helpNl: "Maximum volumebonus, ongeacht zendinggrootte.",
        helpEn: "Maximum volume bonus regardless of shipment size.",
      },
      {
        key: "DRUG_WHOLESALE_SCARCITY_WINDOW_H",
        kind: "hours",
        labelNl: "Schaarste-venster",
        labelEn: "Scarcity window",
        helpNl: "Hoe ver terug recente groothandel-grams in de bestemming tellen.",
        helpEn: "How far back recent wholesale grams in the destination count.",
      },
      {
        key: "DRUG_WHOLESALE_SCARCITY_CAP_BPS",
        kind: "bps",
        labelNl: "Schaarste-plafond",
        labelEn: "Scarcity cap",
        helpNl: "Maximum extra korting door recente dumps.",
        helpEn: "Maximum extra discount from recent dumps.",
      },
      {
        key: "DRUG_WHOLESALE_FBI_HEAT_PER_KG",
        kind: "int",
        labelNl: "FBI-heat per kg bij aankomst",
        labelEn: "FBI heat per kg on arrival",
        helpNl: "Alleen bij succesvolle uitbetaling.",
        helpEn: "Successful payout only.",
      },
      {
        key: "DRUG_WHOLESALE_DRUG_HEAT",
        kind: "int",
        labelNl: "Drug-heat bij verzenden",
        labelEn: "Drug heat on send",
        helpNl: "Inclusief bestaande smokkel +2.",
        helpEn: "Includes existing smuggle +2.",
      },
      {
        key: "DRUG_WHOLESALE_CREW_RUNNER_BPS",
        kind: "bps",
        labelNl: "Crew-loper aandeel",
        labelEn: "Crew runner cut",
        helpNl: "Deel van de crew-payout dat naar de genoemde loper gaat.",
        helpEn: "Share of the crew payout that goes to the named runner.",
      },
    ],
  },
  {
    id: "heat",
    icon: "ph-flame",
    titleNl: "Heat & afkoelen",
    titleEn: "Heat & cooling",
    blurbNl: "Spelers kunnen heat cashen of tijdelijk low-profile gaan.",
    blurbEn: "Players can cash-cool heat or go low-profile for a while.",
    fields: [
      {
        key: "DRUG_HEAT_CASH_COOL_COST_PER_POINT",
        kind: "euro",
        labelNl: "Cash-cool per heat-punt",
        labelEn: "Cash-cool per heat point",
        helpNl: "Speler-cash per punt dat je afkoelt.",
        helpEn: "Player cash per point cooled.",
      },
      {
        key: "DRUG_HEAT_CASH_COOL_POINTS",
        kind: "int",
        labelNl: "Punten per cash-cool",
        labelEn: "Points per cash-cool",
        helpNl: "Hoeveel heat één cash-actie wegneemt.",
        helpEn: "How much heat one cash action removes.",
      },
      {
        key: "DRUG_HEAT_LOW_PROFILE_HOURS",
        kind: "hours",
        labelNl: "Low-profile duur",
        labelEn: "Low-profile duration",
        helpNl: "Hoe lang de low-profile status actief blijft.",
        helpEn: "How long low-profile stays active.",
      },
      {
        key: "DRUG_HEAT_LOW_PROFILE_COOLDOWN_HOURS",
        kind: "hours",
        labelNl: "Low-profile cooldown",
        labelEn: "Low-profile cooldown",
        helpNl: "Wachttijd voordat low-profile opnieuw kan.",
        helpEn: "Wait before low-profile can be used again.",
      },
    ],
  },
  {
    id: "raids",
    icon: "ph-siren",
    titleNl: "Raids",
    titleEn: "Raids",
    blurbNl: "Straf wanneer een facility wordt geraid.",
    blurbEn: "Penalty when a facility is raided.",
    fields: [
      {
        key: "DRUG_RAID_DOWNTIME_HOURS",
        kind: "hours",
        labelNl: "Downtime",
        labelEn: "Downtime",
        helpNl: "Productie stilligt zolang dit duurt.",
        helpEn: "Production stays down for this long.",
      },
      {
        key: "DRUG_RAID_CASH_FINE_PERCENT",
        kind: "percent",
        labelNl: "Cashboete",
        labelEn: "Cash fine",
        helpNl: "Percentage van cash bij de cash-keuze.",
        helpEn: "Percentage of cash on the cash choice.",
      },
    ],
  },
  {
    id: "darkweb",
    icon: "ph-globe",
    titleNl: "Darkweb auto-sale",
    titleEn: "Darkweb auto-sale",
    blurbNl: "Automatische verkoop via de darkweb-storefront.",
    blurbEn: "Automatic sales through the darkweb storefront.",
    fields: [
      {
        key: "DRUG_DARKWEB_AUTOSALE_FEE_PERCENT",
        kind: "percent",
        labelNl: "Fee",
        labelEn: "Fee",
        helpNl: "Aandeel dat de storefront inhoudt.",
        helpEn: "Share kept by the storefront.",
      },
      {
        key: "DRUG_DARKWEB_AUTOSALE_HEAT",
        kind: "int",
        labelNl: "Heat per auto-sale",
        labelEn: "Heat per auto-sale",
        helpNl: "Drug-heat bij elke automatische verkoop.",
        helpEn: "Drug heat on each automatic sale.",
      },
      {
        key: "DRUG_DARKWEB_AUTOSALE_SHARE_PERCENT",
        kind: "percent",
        labelNl: "Speler-aandeel",
        labelEn: "Player share",
        helpNl: "Percentage van de opbrengst naar de speler.",
        helpEn: "Percentage of proceeds paid to the player.",
      },
    ],
  },
  {
    id: "nightclub",
    icon: "ph-music-notes",
    titleNl: "Nightclub",
    titleEn: "Nightclub",
    blurbNl: "Bonus als de club eigen productie slijt.",
    blurbEn: "Bonus when the club sells own production.",
    fields: [
      {
        key: "DRUG_NIGHTCLUB_OWN_PROD_BONUS_PERCENT",
        kind: "percent",
        labelNl: "Eigen-productiebonus",
        labelEn: "Own-production bonus",
        helpNl: "Extra marge op drugs uit eigen productie.",
        helpEn: "Extra margin on drugs from own production.",
      },
    ],
  },
];

const ALL_FIELDS = SECTIONS.flatMap((section) => section.fields);

const tr = (locale: AdminLanguage, nl: string, en: string) =>
  getAdminTr(locale, nl, en);

function valueFor(view: DrugRuntimeConfigView | null, key: string): string {
  if (!view) return "";
  const raw = view.values[key] ?? view.defaults[key] ?? "";
  return String(raw);
}

function parseAmount(raw: string): number | null {
  const normalized = raw.trim().replace(",", ".");
  if (!normalized) return null;
  const value = Number(normalized);
  return Number.isFinite(value) ? value : null;
}

function formatAmount(
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
  return value.toLocaleString(nf);
}

function unitLabel(locale: AdminLanguage, kind: FieldKind): string {
  if (kind === "bps") return "bps";
  if (kind === "percent") return "%";
  if (kind === "euro") return "€";
  if (kind === "grams") return "g";
  if (kind === "hours") return locale === "nl" ? "u" : "h";
  return "";
}

function valuesFromView(view: DrugRuntimeConfigView): Record<string, string> {
  const next: Record<string, string> = {};
  for (const field of ALL_FIELDS) {
    next[field.key] = valueFor(view, field.key);
  }
  return next;
}

export function DrugsAdminPanel({ locale }: Props) {
  const [view, setView] = useState<DrugRuntimeConfigView | null>(null);
  const [loading, setLoading] = useState(false);
  const [saving, setSaving] = useState(false);
  const [values, setValues] = useState<Record<string, string>>({});
  const [message, setMessage] = useState<string | null>(null);
  const [error, setError] = useState<string | null>(null);

  const load = async () => {
    try {
      setLoading(true);
      setError(null);
      const next = await adminService.getDrugRuntimeConfig();
      setView(next);
      setValues(valuesFromView(next));
    } catch (err) {
      setError(
        tr(
          locale,
          "Drugs-configuratie laden mislukt.",
          "Failed to load drugs configuration.",
        ),
      );
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    void load();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  const dirtyKeys = useMemo(() => {
    if (!view) return [] as string[];
    return ALL_FIELDS.filter(
      (field) => (values[field.key] ?? "") !== valueFor(view, field.key),
    ).map((field) => field.key);
  }, [values, view]);

  const invalidKeys = useMemo(
    () =>
      ALL_FIELDS.filter((field) => {
        const amount = parseAmount(values[field.key] ?? "");
        return amount === null || amount < 0;
      }).map((field) => field.key),
    [values],
  );

  const save = async () => {
    if (invalidKeys.length > 0) {
      setError(
        tr(
          locale,
          "Corrigeer ongeldige waarden (getal ≥ 0) voor je opslaat.",
          "Fix invalid values (number ≥ 0) before saving.",
        ),
      );
      return;
    }
    setSaving(true);
    setError(null);
    setMessage(null);
    try {
      const updated = await adminService.updateDrugRuntimeConfig(values);
      setView(updated);
      setValues(valuesFromView(updated));
      setMessage(
        tr(
          locale,
          "Drugs-runtime opgeslagen. Wijzigingen gelden direct.",
          "Drugs runtime saved. Changes apply immediately.",
        ),
      );
    } catch (err) {
      setError(tr(locale, "Opslaan mislukt.", "Save failed."));
      console.error(err);
    } finally {
      setSaving(false);
    }
  };

  const discard = () => {
    if (!view) return;
    setValues(valuesFromView(view));
    setError(null);
    setMessage(null);
  };

  const resetField = (key: string) => {
    if (!view) return;
    setValues((prev) => ({
      ...prev,
      [key]: String(view.defaults[key] ?? prev[key] ?? ""),
    }));
  };

  const kpiField = (key: string) => ALL_FIELDS.find((field) => field.key === key);

  const kpis = [
    {
      key: "DRUG_WHOLESALE_MIN_GRAMS",
      labelNl: "Min. zending",
      labelEn: "Min. shipment",
    },
    {
      key: "DRUG_WHOLESALE_SPREAD_BPS",
      labelNl: "B2B-spread",
      labelEn: "B2B spread",
    },
    {
      key: "DRUG_HEAT_CASH_COOL_COST_PER_POINT",
      labelNl: "Cash-cool",
      labelEn: "Cash-cool",
    },
    {
      key: "DRUG_RAID_DOWNTIME_HOURS",
      labelNl: "Raid downtime",
      labelEn: "Raid downtime",
    },
  ];

  return (
    <section className="runtime-console">
      <span className="admin-kicker">
        {tr(locale, "Economie · live runtime", "Economy · live runtime")}
      </span>
      <p className="text-muted mb-3">
        {tr(
          locale,
          "Stuur groothandel, heat, raids, darkweb en nightclub zonder deploy. Police-pressure en Clearing House blijven op hun eigen tabs.",
          "Tune wholesale, heat, raids, darkweb and nightclub without a deploy. Police pressure and Clearing House stay on their own tabs.",
        )}
      </p>

      {error && <div className="alert alert-danger">{error}</div>}
      {message && <div className="alert alert-success">{message}</div>}

      <div className="runtime-kpi-grid">
        {kpis.map((kpi) => {
          const field = kpiField(kpi.key);
          return (
            <div className="runtime-kpi" key={kpi.key}>
              <div className="runtime-kpi-label">
                {tr(locale, kpi.labelNl, kpi.labelEn)}
              </div>
              <div className="runtime-kpi-value">
                {field
                  ? formatAmount(locale, field.kind, values[kpi.key] ?? "")
                  : "—"}
              </div>
            </div>
          );
        })}
      </div>

      <div className="runtime-toolbar">
        <div>
          <div className="fw-semibold">
            {tr(locale, "Runtime-configuratie", "Runtime configuration")}
          </div>
          <div className="small text-muted">
            {loading
              ? tr(locale, "Laden…", "Loading…")
              : dirtyKeys.length > 0
                ? tr(
                    locale,
                    `${dirtyKeys.length} niet-opgeslagen wijziging${dirtyKeys.length === 1 ? "" : "en"}`,
                    `${dirtyKeys.length} unsaved change${dirtyKeys.length === 1 ? "" : "s"}`,
                  )
                : tr(locale, "Alles opgeslagen", "All changes saved")}
          </div>
        </div>
        <div className="d-flex flex-wrap gap-2">
          <button
            type="button"
            className="btn btn-outline-secondary btn-sm"
            onClick={() => void load()}
            disabled={loading || saving}
          >
            <i className="ph-arrows-clockwise me-1" />
            {tr(locale, "Ververs", "Refresh")}
          </button>
          <button
            type="button"
            className="btn btn-outline-secondary btn-sm"
            onClick={discard}
            disabled={!view || saving || dirtyKeys.length === 0}
          >
            {tr(locale, "Annuleren", "Discard")}
          </button>
          <button
            type="button"
            className="btn btn-primary btn-sm"
            disabled={!view || saving || dirtyKeys.length === 0}
            onClick={() => void save()}
          >
            {saving
              ? tr(locale, "Opslaan…", "Saving…")
              : tr(locale, "Opslaan", "Save")}
          </button>
        </div>
      </div>

      <div className="d-flex flex-column gap-3">
        {SECTIONS.map((section) => (
          <div className="card" key={section.id}>
            <div className="card-header d-flex align-items-start gap-3">
              <i className={`${section.icon} runtime-section-icon fs-4`} />
              <div>
                <h2 className="h5 mb-1">
                  {tr(locale, section.titleNl, section.titleEn)}
                </h2>
                <p className="text-muted small mb-0">
                  {tr(locale, section.blurbNl, section.blurbEn)}
                </p>
              </div>
            </div>
            <div className="card-body">
              <div className="row g-3">
                {section.fields.map((field) => {
                  const current = values[field.key] ?? "";
                  const saved = valueFor(view, field.key);
                  const fallback = view ? String(view.defaults[field.key] ?? "") : "";
                  const dirty = current !== saved;
                  const custom = saved !== fallback && fallback !== "";
                  const invalid = invalidKeys.includes(field.key);
                  const unit = unitLabel(locale, field.kind);
                  return (
                    <div className="col-lg-6" key={field.key}>
                      <div
                        className={`runtime-field ${dirty ? "is-dirty" : ""} ${invalid ? "is-invalid" : ""}`}
                      >
                        <div className="d-flex align-items-start justify-content-between gap-2 mb-1">
                          <label className="form-label fw-semibold mb-0">
                            {tr(locale, field.labelNl, field.labelEn)}
                          </label>
                          <div className="d-flex flex-wrap gap-1">
                            {dirty && (
                              <span className="badge bg-warning text-dark">
                                {tr(locale, "Niet opgeslagen", "Unsaved")}
                              </span>
                            )}
                            {!dirty && custom && (
                              <span className="badge bg-secondary">
                                {tr(locale, "Afwijkend", "Custom")}
                              </span>
                            )}
                          </div>
                        </div>
                        <div className="input-group">
                          <input
                            className={`form-control ${invalid ? "is-invalid" : ""}`}
                            inputMode="decimal"
                            value={current}
                            onChange={(event) =>
                              setValues((prev) => ({
                                ...prev,
                                [field.key]: event.target.value,
                              }))
                            }
                            disabled={!view || saving}
                            aria-label={tr(locale, field.labelNl, field.labelEn)}
                          />
                          {unit ? (
                            <span className="input-group-text">{unit}</span>
                          ) : null}
                          <button
                            type="button"
                            className="btn btn-outline-secondary"
                            title={tr(
                              locale,
                              "Terug naar standaard",
                              "Reset to default",
                            )}
                            disabled={!view || saving || current === fallback}
                            onClick={() => resetField(field.key)}
                          >
                            <i className="ph-arrow-counter-clockwise" />
                          </button>
                        </div>
                        <div className="runtime-field-meta">
                          <span>
                            {tr(locale, "Live", "Live")}:{" "}
                            {formatAmount(locale, field.kind, current)}
                          </span>
                          <span>
                            {tr(locale, "Standaard", "Default")}:{" "}
                            {formatAmount(locale, field.kind, fallback)}
                          </span>
                        </div>
                        <div className="small text-muted mt-1">
                          {tr(locale, field.helpNl, field.helpEn)}
                        </div>
                        <code className="runtime-key">{field.key}</code>
                      </div>
                    </div>
                  );
                })}
              </div>
            </div>
          </div>
        ))}
      </div>
    </section>
  );
}
