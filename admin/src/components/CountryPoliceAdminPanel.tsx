import { useEffect, useState } from "react";
import {
  adminService,
  type CountryPoliceRuntimeConfigView,
} from "../services/adminService";
import type { AdminLanguage } from "../i18n/translations";
import { getAdminTr } from "../i18n/inlineMessages";
import {
  AdminPageIntro,
  RuntimeKpi,
  RuntimeKpiGrid,
  runtimeValueFor,
} from "./adminChrome";

type Props = {
  locale: AdminLanguage;
};

const tr = (locale: AdminLanguage, nl: string, en: string) =>
  getAdminTr(locale, nl, en);

export function CountryPoliceAdminPanel({ locale }: Props) {
  const [view, setView] = useState<CountryPoliceRuntimeConfigView | null>(null);
  const [saving, setSaving] = useState(false);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [message, setMessage] = useState<string | null>(null);

  const load = async () => {
    setLoading(true);
    setError(null);
    try {
      setView(await adminService.getCountryPoliceRuntimeConfig());
    } catch (err) {
      setError(
        tr(
          locale,
          "Landelijke politie laden mislukt.",
          "Failed to load country police.",
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

  const enabled =
    runtimeValueFor(view, "COUNTRY_POLICE_PRESSURE_ENABLED") === "1";

  const toggleEnabled = async () => {
    setSaving(true);
    setError(null);
    setMessage(null);
    try {
      const updated = await adminService.updateCountryPoliceRuntimeConfig({
        COUNTRY_POLICE_PRESSURE_ENABLED: enabled ? "0" : "1",
      });
      setView(updated);
      const nextOn =
        runtimeValueFor(updated, "COUNTRY_POLICE_PRESSURE_ENABLED") === "1";
      setMessage(
        nextOn
          ? tr(
              locale,
              "Landelijke druk staat AAN. Succes- en arrestkans volgen nu de land-multiplier.",
              "Country pressure is ON. Success and arrest chance now follow the country multiplier.",
            )
          : tr(
              locale,
              "Landelijke druk staat UIT. Bestaande crime/arrest-math blijft gelden.",
              "Country pressure is OFF. Existing crime/arrest math stays in effect.",
            ),
      );
    } catch (err) {
      setError(tr(locale, "Opslaan mislukt.", "Save failed."));
      console.error(err);
    } finally {
      setSaving(false);
    }
  };

  return (
    <section className="runtime-console">
      <AdminPageIntro
        kicker={tr(locale, "Security · live runtime", "Security · live runtime")}
        description={tr(
          locale,
          "Eén schakelaar voor landelijke politiedruk. Geen code-default: uit = huidige crime/arrest-math.",
          "One switch for country police pressure. Not a code default: off = current crime/arrest math.",
        )}
        note={tr(
          locale,
          "QA-oppervlakken: dashboard-strip, crimes-strip, travel-badges en disrupt. Clearing House en drugs-runtime blijven elders.",
          "QA surfaces: dashboard strip, crimes strip, travel badges and disrupt. Clearing House and drugs runtime stay elsewhere.",
        )}
      />
      {error && <div className="alert alert-danger">{error}</div>}
      {message && <div className="alert alert-success">{message}</div>}
      <RuntimeKpiGrid>
        <RuntimeKpi
          label={tr(locale, "Live status", "Live status")}
          value={
            loading
              ? tr(locale, "Laden…", "Loading…")
              : enabled
                ? tr(locale, "Aan", "On")
                : tr(locale, "Uit", "Off")
          }
        />
        <RuntimeKpi
          label={tr(locale, "Code-default", "Code default")}
          value={tr(locale, "Uit (0)", "Off (0)")}
        />
      </RuntimeKpiGrid>
      <div className="card">
        <div className="card-header d-flex align-items-start gap-3">
          <i className="ph-shield-warning runtime-section-icon fs-4" />
          <div>
            <h2 className="h5 mb-1">
              {tr(locale, "Landelijke druk", "Country pressure")}
            </h2>
            <p className="text-muted small mb-0">
              COUNTRY_POLICE_PRESSURE_ENABLED
            </p>
          </div>
          <span
            className={`badge ms-auto ${enabled ? "bg-warning text-dark" : "bg-secondary"}`}
          >
            {enabled
              ? tr(locale, "Live: AAN", "Live: ON")
              : tr(locale, "Live: UIT", "Live: OFF")}
          </span>
        </div>
        <div className="card-body d-flex align-items-center justify-content-between gap-3 flex-wrap">
          <div className="form-check form-switch mb-0">
            <input
              className="form-check-input"
              type="checkbox"
              id="country-police-pressure"
              checked={enabled}
              disabled={saving || !view || loading}
              onChange={() => void toggleEnabled()}
            />
            <label className="form-check-label" htmlFor="country-police-pressure">
              {tr(locale, "Druk actief", "Pressure enabled")}
            </label>
          </div>
          <button
            type="button"
            className="btn btn-outline-secondary btn-sm"
            disabled={loading || saving}
            onClick={() => void load()}
          >
            <i className="ph-arrows-clockwise me-1" />
            {tr(locale, "Ververs", "Refresh")}
          </button>
        </div>
      </div>
    </section>
  );
}
