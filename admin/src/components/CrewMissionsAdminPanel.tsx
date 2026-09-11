import { useEffect, useMemo, useState } from "react";
import {
  adminService,
  type CrewMissionRuntimeConfigView,
} from "../services/adminService";
import type { AdminLanguage } from "../i18n/translations";
import { getAdminTr } from "../i18n/inlineMessages";
import {
  AdminPageIntro,
  RuntimeField,
  RuntimeKpi,
  RuntimeKpiGrid,
  RuntimeToolbar,
  formatAmount,
  isInvalidAmount,
  runtimeValueFor,
  type FieldKind,
} from "./adminChrome";

type Props = {
  locale: AdminLanguage;
};

const CLEARING_HOUSE_KEY = "CREW_MISSION_CLEARING_HOUSE_MIN_MISSION_LEVEL";
const PHASE2_ON_LEVEL = 3;

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
    id: "credits",
    icon: "ph-coins",
    titleNl: "Credits per minuut",
    titleEn: "Credits per minute",
    blurbNl: "Pacing van missie-credits per tier.",
    blurbEn: "Mission credit pacing per tier.",
    fields: [
      {
        key: "CREW_MISSION_T1_CREDITS_PER_MINUTE",
        kind: "int",
        labelNl: "Tier 1",
        labelEn: "Tier 1",
        helpNl: "Bereik 1–20.",
        helpEn: "Range 1–20.",
      },
      {
        key: "CREW_MISSION_T2_CREDITS_PER_MINUTE",
        kind: "int",
        labelNl: "Tier 2",
        labelEn: "Tier 2",
        helpNl: "Bereik 1–20.",
        helpEn: "Range 1–20.",
      },
      {
        key: "CREW_MISSION_T3_CREDITS_PER_MINUTE",
        kind: "int",
        labelNl: "Tier 3",
        labelEn: "Tier 3",
        helpNl: "Bereik 1–20.",
        helpEn: "Range 1–20.",
      },
    ],
  },
  {
    id: "repeat",
    icon: "ph-repeat",
    titleNl: "Repeat diminishing",
    titleEn: "Repeat diminishing",
    blurbNl: "Kortere herhaling levert minder op.",
    blurbEn: "Repeating sooner pays less.",
    fields: [
      {
        key: "CREW_MISSION_REPEAT_WINDOW_MINUTES",
        kind: "minutes",
        labelNl: "Repeat-venster",
        labelEn: "Repeat window",
        helpNl: "15–360 minuten.",
        helpEn: "15–360 minutes.",
      },
      {
        key: "CREW_MISSION_REPEAT_2_MULTIPLIER",
        kind: "multiplier",
        labelNl: "Tweede run",
        labelEn: "Second run",
        helpNl: "0.5–1.",
        helpEn: "0.5–1.",
      },
      {
        key: "CREW_MISSION_REPEAT_3_MULTIPLIER",
        kind: "multiplier",
        labelNl: "Derde run",
        labelEn: "Third run",
        helpNl: "0.5–1.",
        helpEn: "0.5–1.",
      },
      {
        key: "CREW_MISSION_REPEAT_4_MULTIPLIER",
        kind: "multiplier",
        labelNl: "Vierde+ run",
        labelEn: "Fourth+ run",
        helpNl: "0.5–1.",
        helpEn: "0.5–1.",
      },
    ],
  },
  {
    id: "crew-level",
    icon: "ph-trend-up",
    titleNl: "Crew-level",
    titleEn: "Crew level",
    blurbNl: "XP-curve en cashbonus-plafond.",
    blurbEn: "XP curve and cash bonus cap.",
    fields: [
      {
        key: "CREW_MISSION_CREW_LEVEL_BASE_XP",
        kind: "int",
        labelNl: "Basis-XP",
        labelEn: "Base XP",
        helpNl: "100–20000.",
        helpEn: "100–20000.",
      },
      {
        key: "CREW_MISSION_CREW_LEVEL_STEP_XP",
        kind: "int",
        labelNl: "Stap-XP",
        labelEn: "Step XP",
        helpNl: "10–5000.",
        helpEn: "10–5000.",
      },
      {
        key: "CREW_MISSION_CREW_LEVEL_CASH_BONUS_PER_LEVEL_PCT",
        kind: "percent",
        labelNl: "Cashbonus per level",
        labelEn: "Cash bonus per level",
        helpNl: "0–10%.",
        helpEn: "0–10%.",
      },
      {
        key: "CREW_MISSION_CREW_LEVEL_CASH_BONUS_CAP_PCT",
        kind: "percent",
        labelNl: "Cashbonus-plafond",
        labelEn: "Cash bonus cap",
        helpNl: "0–100%.",
        helpEn: "0–100%.",
      },
    ],
  },
];

const ALL_FIELDS = SECTIONS.flatMap((section) => section.fields);
const tr = (locale: AdminLanguage, nl: string, en: string) =>
  getAdminTr(locale, nl, en);

function valuesFromView(
  view: CrewMissionRuntimeConfigView,
): Record<string, string> {
  const next: Record<string, string> = {};
  for (const field of ALL_FIELDS) {
    next[field.key] = runtimeValueFor(view, field.key);
  }
  return next;
}

export function CrewMissionsAdminPanel({ locale }: Props) {
  const [view, setView] = useState<CrewMissionRuntimeConfigView | null>(null);
  const [loading, setLoading] = useState(false);
  const [savingGate, setSavingGate] = useState(false);
  const [savingOther, setSavingOther] = useState(false);
  const [gateEnabled, setGateEnabled] = useState(false);
  const [gateLevel, setGateLevel] = useState(String(PHASE2_ON_LEVEL));
  const [otherValues, setOtherValues] = useState<Record<string, string>>({});
  const [message, setMessage] = useState<string | null>(null);
  const [error, setError] = useState<string | null>(null);

  const load = async () => {
    try {
      setLoading(true);
      setError(null);
      const next = await adminService.getCrewMissionRuntimeConfig();
      setView(next);
      const current = Number(runtimeValueFor(next, CLEARING_HOUSE_KEY) || 0);
      setGateEnabled(current > 0);
      setGateLevel(String(current > 0 ? current : PHASE2_ON_LEVEL));
      setOtherValues(valuesFromView(next));
    } catch (err) {
      setError(
        tr(
          locale,
          "Crew mission-configuratie laden mislukt.",
          "Failed to load crew mission configuration.",
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

  const liveLevel = useMemo(
    () => Number(runtimeValueFor(view, CLEARING_HOUSE_KEY) || 0),
    [view],
  );
  const liveEnabled = liveLevel > 0;

  const dirtyKeys = useMemo(() => {
    if (!view) return [] as string[];
    return ALL_FIELDS.filter(
      (field) =>
        (otherValues[field.key] ?? "") !== runtimeValueFor(view, field.key),
    ).map((field) => field.key);
  }, [otherValues, view]);

  const saveGate = async () => {
    const level = gateEnabled ? Number.parseInt(gateLevel, 10) : 0;
    if (gateEnabled && (!Number.isFinite(level) || level < 1 || level > 50)) {
      setError(
        tr(
          locale,
          "Missieniveau moet tussen 1 en 50 liggen als de gate aan staat.",
          "Mission level must be between 1 and 50 when the gate is on.",
        ),
      );
      return;
    }

    try {
      setSavingGate(true);
      setError(null);
      setMessage(null);
      const updated = await adminService.updateCrewMissionRuntimeConfig({
        [CLEARING_HOUSE_KEY]: gateEnabled ? level : 0,
      });
      setView(updated);
      const nextLevel = Number(runtimeValueFor(updated, CLEARING_HOUSE_KEY) || 0);
      setGateEnabled(nextLevel > 0);
      setGateLevel(String(nextLevel > 0 ? nextLevel : PHASE2_ON_LEVEL));
      setMessage(
        nextLevel > 0
          ? tr(
              locale,
              `Clearing House gate AAN (min. missieniveau ${nextLevel}).`,
              `Clearing House gate ON (min. mission level ${nextLevel}).`,
            )
          : tr(locale, "Clearing House gate UIT.", "Clearing House gate OFF."),
      );
    } catch (err) {
      setError(
        tr(
          locale,
          "Opslaan van Clearing House gate mislukt.",
          "Failed to save Clearing House gate.",
        ),
      );
      console.error(err);
    } finally {
      setSavingGate(false);
    }
  };

  const saveOther = async () => {
    if (ALL_FIELDS.some((field) => isInvalidAmount(otherValues[field.key] ?? ""))) {
      setError(
        tr(
          locale,
          "Corrigeer ongeldige pacing-waarden voor je opslaat.",
          "Fix invalid pacing values before saving.",
        ),
      );
      return;
    }
    try {
      setSavingOther(true);
      setError(null);
      setMessage(null);
      const updated =
        await adminService.updateCrewMissionRuntimeConfig(otherValues);
      setView(updated);
      setOtherValues(valuesFromView(updated));
      setMessage(
        tr(locale, "Crew mission pacing opgeslagen.", "Crew mission pacing saved."),
      );
    } catch (err) {
      setError(
        tr(
          locale,
          "Opslaan van pacing-instellingen mislukt (check bereiken).",
          "Failed to save pacing settings (check ranges).",
        ),
      );
      console.error(err);
    } finally {
      setSavingOther(false);
    }
  };

  const discard = () => {
    if (!view) return;
    setOtherValues(valuesFromView(view));
    setError(null);
    setMessage(null);
  };

  return (
    <section className="runtime-console">
      <AdminPageIntro
        kicker={tr(locale, "Crew · live runtime", "Crew · live runtime")}
        description={tr(
          locale,
          "Clearing House-gate en missie-pacing. Wijzigingen gelden direct, zonder deploy.",
          "Clearing House gate and mission pacing. Changes apply live, without a deploy.",
        )}
      />
      {error && <div className="alert alert-danger">{error}</div>}
      {message && <div className="alert alert-success">{message}</div>}
      <RuntimeKpiGrid>
        <RuntimeKpi
          label={tr(locale, "Clearing House", "Clearing House")}
          value={
            liveEnabled
              ? tr(locale, `Aan (≥${liveLevel})`, `On (≥${liveLevel})`)
              : tr(locale, "Uit", "Off")
          }
        />
        <RuntimeKpi
          label={tr(locale, "T3 credits/min", "T3 credits/min")}
          value={formatAmount(
            locale,
            "int",
            otherValues.CREW_MISSION_T3_CREDITS_PER_MINUTE ?? "",
          )}
        />
        <RuntimeKpi
          label={tr(locale, "Repeat-venster", "Repeat window")}
          value={formatAmount(
            locale,
            "minutes",
            otherValues.CREW_MISSION_REPEAT_WINDOW_MINUTES ?? "",
          )}
        />
        <RuntimeKpi
          label={tr(locale, "Cashbonus-cap", "Cash bonus cap")}
          value={formatAmount(
            locale,
            "percent",
            otherValues.CREW_MISSION_CREW_LEVEL_CASH_BONUS_CAP_PCT ?? "",
          )}
        />
      </RuntimeKpiGrid>

      <div className="card mb-3">
        <div className="card-header d-flex align-items-start gap-3">
          <i className="ph-lock-key runtime-section-icon fs-4" />
          <div className="flex-grow-1">
            <div className="d-flex align-items-center justify-content-between gap-2 flex-wrap">
              <h2 className="h5 mb-1">
                {tr(
                  locale,
                  "Clearing House Phase-2 gate",
                  "Clearing House Phase-2 gate",
                )}
              </h2>
              <span
                className={`badge ${liveEnabled ? "bg-warning text-dark" : "bg-secondary"}`}
              >
                {liveEnabled
                  ? tr(locale, `Live: AAN (≥${liveLevel})`, `Live: ON (≥${liveLevel})`)
                  : tr(locale, "Live: UIT", "Live: OFF")}
              </span>
            </div>
            <p className="text-muted small mb-0">
              {tr(
                locale,
                "Extra lock op de Kluisrun: crew.missionLevel moet ≥ dit niveau zijn. Tier-3 HQ/leden-eisen blijven altijd gelden.",
                "Extra lock on the Vault Run: crew.missionLevel must be ≥ this level. Tier-3 HQ/member requirements still always apply.",
              )}
            </p>
          </div>
        </div>
        <div className="card-body">
          <div className="form-check form-switch mb-3">
            <input
              className="form-check-input"
              type="checkbox"
              id="clearing-house-gate"
              checked={gateEnabled}
              onChange={(e) => {
                setGateEnabled(e.target.checked);
                if (e.target.checked && (!gateLevel || gateLevel === "0")) {
                  setGateLevel(String(PHASE2_ON_LEVEL));
                }
              }}
            />
            <label className="form-check-label" htmlFor="clearing-house-gate">
              {tr(
                locale,
                "Gate inschakelen (min. missieniveau)",
                "Enable gate (min. mission level)",
              )}
            </label>
          </div>
          <div className="row g-3 align-items-end">
            <div className="col-12 col-md-4">
              <label className="form-label">
                {tr(locale, "Minimum missieniveau", "Minimum mission level")}
              </label>
              <input
                type="number"
                min={1}
                max={50}
                className="form-control"
                disabled={!gateEnabled}
                value={gateLevel}
                onChange={(e) => setGateLevel(e.target.value)}
              />
              <div className="form-text">
                {tr(
                  locale,
                  `Aanbevolen Phase-2 waarde: ${PHASE2_ON_LEVEL}. 0 = uit.`,
                  `Recommended Phase-2 value: ${PHASE2_ON_LEVEL}. 0 = off.`,
                )}
              </div>
            </div>
            <div className="col-12 col-md-auto">
              <button
                type="button"
                className="btn btn-primary"
                disabled={savingGate || loading}
                onClick={() => void saveGate()}
              >
                {savingGate
                  ? tr(locale, "Opslaan…", "Saving…")
                  : tr(locale, "Gate opslaan", "Save gate")}
              </button>
            </div>
          </div>
        </div>
      </div>

      <RuntimeToolbar
        locale={locale}
        loading={loading}
        saving={savingOther}
        dirtyCount={dirtyKeys.length}
        disabled={!view}
        onRefresh={() => void load()}
        onDiscard={discard}
        onSave={() => void saveOther()}
        saveLabel={tr(locale, "Pacing opslaan", "Save pacing")}
      />

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
                {section.fields.map((field) => (
                  <div className="col-lg-6" key={field.key}>
                    <RuntimeField
                      locale={locale}
                      label={tr(locale, field.labelNl, field.labelEn)}
                      help={tr(locale, field.helpNl, field.helpEn)}
                      fieldKey={field.key}
                      kind={field.kind}
                      value={otherValues[field.key] ?? ""}
                      saved={runtimeValueFor(view, field.key)}
                      fallback={
                        view ? String(view.defaults[field.key] ?? "") : ""
                      }
                      disabled={!view || savingOther}
                      onChange={(next) =>
                        setOtherValues((prev) => ({
                          ...prev,
                          [field.key]: next,
                        }))
                      }
                      onReset={() =>
                        setOtherValues((prev) => ({
                          ...prev,
                          [field.key]: String(view?.defaults[field.key] ?? ""),
                        }))
                      }
                    />
                  </div>
                ))}
              </div>
            </div>
          </div>
        ))}
      </div>
    </section>
  );
}
