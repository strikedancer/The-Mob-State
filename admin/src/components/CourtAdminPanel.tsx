import { useEffect, useMemo, useState } from "react";
import {
  adminService,
  type CourtRuntimeConfigView,
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
  isSuperAdmin: boolean;
};

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

const CONFIRM_PHRASE = "WIPE_ALL_RECORDS";

const PROMO_PREVIEW_NL =
  "Ieders strafblad is zojuist gewist. Iedereen start opnieuw met een schoon blad.\n\nHoud het nu bij via Rechtbank. Hoe eerder je regels wegkoopt, hoe beter het lukt — weinig regels maakt wissen een stuk makkelijker.";

const SECTIONS: SectionDef[] = [
  {
    id: "expunge",
    icon: "ph-eraser",
    titleNl: "Strafblad wissen (petitie)",
    titleEn: "Criminal-record wipe (petition)",
    blurbNl:
      "Betaalde petitie op het Rechtbank-scherm. Kosten, kans, Don-bonussen en cooldown zonder deploy.",
    blurbEn:
      "Paid petition on the Court screen. Cost, odds, Don bonuses and cooldown without a deploy.",
    fields: [
      {
        key: "COURT_EXPUNGE_BASE_COST",
        kind: "euro",
        labelNl: "Basiskosten",
        labelEn: "Base cost",
        helpNl: "Cash voor de eerste zichtbare veroordeling.",
        helpEn: "Cash for the first visible conviction.",
      },
      {
        key: "COURT_EXPUNGE_COST_PER_EXTRA",
        kind: "euro",
        labelNl: "Extra per veroordeling",
        labelEn: "Extra per conviction",
        helpNl: "Bijkomend bedrag voor elke extra zichtbare veroordeling.",
        helpEn: "Added amount for each extra visible conviction.",
      },
      {
        key: "COURT_EXPUNGE_BASE_PERCENT",
        kind: "percent",
        labelNl: "Basiskans",
        labelEn: "Base chance",
        helpNl: "Startkans vóór record-, recente-arrest- en reputatie-modifiers.",
        helpEn: "Starting chance before record, recency and reputation modifiers.",
      },
      {
        key: "COURT_EXPUNGE_MIN_PERCENT",
        kind: "percent",
        labelNl: "Minimumkans",
        labelEn: "Minimum chance",
        helpNl: "Hard vloot — kans zakt hier nooit onder.",
        helpEn: "Hard floor — chance never drops below this.",
      },
      {
        key: "COURT_EXPUNGE_MAX_PERCENT",
        kind: "percent",
        labelNl: "Maximumkans",
        labelEn: "Maximum chance",
        helpNl: "Hard plafond — kans stijgt hier nooit boven.",
        helpEn: "Hard ceiling — chance never rises above this.",
      },
      {
        key: "COURT_EXPUNGE_DON_JUDGE_PERCENT",
        kind: "percent",
        labelNl: "Don-rechterbonus",
        labelEn: "Don judge bonus",
        helpNl: "Extra kans als de speler de rechter in dit land sponsort.",
        helpEn: "Extra chance when the player sponsors the judge in this country.",
      },
      {
        key: "COURT_EXPUNGE_DON_COMMISSIONER_PERCENT",
        kind: "percent",
        labelNl: "Don-commissarisbonus",
        labelEn: "Don commissioner bonus",
        helpNl: "Extra kans bij actieve commissaris-patronage.",
        helpEn: "Extra chance with active commissioner patronage.",
      },
      {
        key: "COURT_EXPUNGE_DON_ALDERMAN_PERCENT",
        kind: "percent",
        labelNl: "Don-wethouderbonus",
        labelEn: "Don alderman bonus",
        helpNl: "Extra kans bij actieve wethouder-patronage.",
        helpEn: "Extra chance with active alderman patronage.",
      },
      {
        key: "COURT_EXPUNGE_COOLDOWN_SECONDS",
        kind: "int",
        labelNl: "Cooldown (seconden)",
        labelEn: "Cooldown (seconds)",
        helpNl: "Wachttijd tussen petities. Standaard 43200 = 12 uur.",
        helpEn: "Wait between petitions. Default 43200 = 12 hours.",
      },
      {
        key: "COURT_EXPUNGE_FRESH_ARREST_HOURS",
        kind: "hours",
        labelNl: "Verse-arrestvenster",
        labelEn: "Fresh-arrest window",
        helpNl: "Uren na laatste arrest waarin de zware −15% straft geldt.",
        helpEn: "Hours after last arrest when the heavy −15% penalty applies.",
      },
    ],
  },
  {
    id: "appeal",
    icon: "ph-scales",
    titleNl: "Hoger beroep",
    titleEn: "Appeal",
    blurbNl:
      "Kans en kosten voor één beroep per celstraf. Law-school en Don-rechter stapelen tot het plafond.",
    blurbEn:
      "Odds and cost for one appeal per sentence. Law school and Don judge stack up to the ceiling.",
    fields: [
      {
        key: "COURT_APPEAL_BASE_PERCENT",
        kind: "percent",
        labelNl: "Basiskans",
        labelEn: "Base chance",
        helpNl: "Startkans vóór law-, prior-, wanted- en FBI-modifiers.",
        helpEn: "Starting chance before law, prior, wanted and FBI modifiers.",
      },
      {
        key: "COURT_APPEAL_LAW_BONUS_PER_LEVEL_PERCENT",
        kind: "percent",
        labelNl: "Law-bonus per niveau",
        labelEn: "Law bonus per level",
        helpNl: "Extra kans per law-schoolniveau (0–5).",
        helpEn: "Extra chance per law-school level (0–5).",
      },
      {
        key: "COURT_APPEAL_LAW_BONUS_CAP_PERCENT",
        kind: "percent",
        labelNl: "Law-bonusplafond",
        labelEn: "Law bonus cap",
        helpNl: "Maximum bonus uit law-school, ongeacht niveau.",
        helpEn: "Maximum bonus from law school regardless of level.",
      },
      {
        key: "COURT_APPEAL_WANTED_THRESHOLD",
        kind: "int",
        labelNl: "Wanted-drempel",
        labelEn: "Wanted threshold",
        helpNl: "Wanted strikt boven deze waarde activeert de wanted-straf.",
        helpEn: "Wanted strictly above this value triggers the wanted penalty.",
      },
      {
        key: "COURT_APPEAL_WANTED_PENALTY_PERCENT",
        kind: "percent",
        labelNl: "Wanted-straf",
        labelEn: "Wanted penalty",
        helpNl: "Aftrek van de beroepskans bij te hoge wanted.",
        helpEn: "Subtracted from appeal chance when wanted is too high.",
      },
      {
        key: "COURT_APPEAL_FBI_THRESHOLD",
        kind: "int",
        labelNl: "FBI-heat-drempel",
        labelEn: "FBI heat threshold",
        helpNl: "FBI-heat strikt boven deze waarde activeert de FBI-straf.",
        helpEn: "FBI heat strictly above this value triggers the FBI penalty.",
      },
      {
        key: "COURT_APPEAL_FBI_PENALTY_PERCENT",
        kind: "percent",
        labelNl: "FBI-straf",
        labelEn: "FBI penalty",
        helpNl: "Aftrek van de beroepskans bij te hoge FBI-heat.",
        helpEn: "Subtracted from appeal chance when FBI heat is too high.",
      },
      {
        key: "COURT_APPEAL_MIN_PERCENT",
        kind: "percent",
        labelNl: "Minimumkans",
        labelEn: "Minimum chance",
        helpNl: "Hard vloot voor hoger beroep.",
        helpEn: "Hard floor for appeal chance.",
      },
      {
        key: "COURT_APPEAL_MAX_PERCENT",
        kind: "percent",
        labelNl: "Maximumkans",
        labelEn: "Maximum chance",
        helpNl: "Hard plafond voor hoger beroep.",
        helpEn: "Hard ceiling for appeal chance.",
      },
      {
        key: "COURT_APPEAL_COST_PER_MINUTE",
        kind: "euro",
        labelNl: "Kosten per celminuut",
        labelEn: "Cost per jail minute",
        helpNl: "Beroepskosten = celminuten × dit bedrag, geklemd tussen min/max.",
        helpEn: "Appeal cost = jail minutes × this amount, clamped between min/max.",
      },
      {
        key: "COURT_APPEAL_COST_MIN",
        kind: "euro",
        labelNl: "Minimumkosten",
        labelEn: "Minimum cost",
        helpNl: "Laagste cash-bedrag voor een beroep.",
        helpEn: "Lowest cash amount for an appeal.",
      },
      {
        key: "COURT_APPEAL_COST_MAX",
        kind: "euro",
        labelNl: "Maximumkosten",
        labelEn: "Maximum cost",
        helpNl: "Hoogste cash-bedrag voor een beroep.",
        helpEn: "Highest cash amount for an appeal.",
      },
      {
        key: "DON_JUDGE_APPEAL_BONUS_PERCENT",
        kind: "percent",
        labelNl: "Don-rechter beroepbonus",
        labelEn: "Don judge appeal bonus",
        helpNl:
          "Gedeelde Don-runtime key. Extra beroepskans bij rechter-patronage (vóór clamp).",
        helpEn:
          "Shared Don runtime key. Extra appeal chance with judge patronage (before clamp).",
      },
    ],
  },
];

const ALL_FIELDS = SECTIONS.flatMap((section) => section.fields);

const tr = (locale: AdminLanguage, nl: string, en: string) =>
  getAdminTr(locale, nl, en);

function valuesFromView(view: CourtRuntimeConfigView): Record<string, string> {
  const next: Record<string, string> = {};
  for (const field of ALL_FIELDS) {
    next[field.key] = runtimeValueFor(view, field.key);
  }
  return next;
}

export function CourtAdminPanel({ locale, isSuperAdmin }: Props) {
  const [view, setView] = useState<CourtRuntimeConfigView | null>(null);
  const [loading, setLoading] = useState(false);
  const [saving, setSaving] = useState(false);
  const [values, setValues] = useState<Record<string, string>>({});
  const [message, setMessage] = useState<string | null>(null);
  const [error, setError] = useState<string | null>(null);

  const [confirmText, setConfirmText] = useState("");
  const [amnestyBusy, setAmnestyBusy] = useState(false);
  const [lastResult, setLastResult] = useState<{
    playersCleared: number;
    recordsCleared: number;
    announcementId: number | null;
  } | null>(null);

  const load = async () => {
    try {
      setLoading(true);
      setError(null);
      const next = await adminService.getCourtRuntimeConfig();
      setView(next);
      setValues(valuesFromView(next));
    } catch (err) {
      setError(
        tr(
          locale,
          "Rechtbank-configuratie laden mislukt.",
          "Failed to load court configuration.",
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
      (field) => (values[field.key] ?? "") !== runtimeValueFor(view, field.key),
    ).map((field) => field.key);
  }, [values, view]);

  const invalidKeys = useMemo(
    () =>
      ALL_FIELDS.filter((field) =>
        isInvalidAmount(values[field.key] ?? ""),
      ).map((field) => field.key),
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
      const updated = await adminService.updateCourtRuntimeConfig(values);
      setView(updated);
      setValues(valuesFromView(updated));
      setMessage(
        tr(
          locale,
          "Rechtbank-runtime opgeslagen. Wijzigingen gelden direct.",
          "Court runtime saved. Changes apply immediately.",
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

  const canRunAmnesty =
    isSuperAdmin && confirmText.trim() === CONFIRM_PHRASE && !amnestyBusy;

  const runAmnesty = async () => {
    if (!canRunAmnesty) return;
    if (
      !window.confirm(
        tr(
          locale,
          "Dit wist het zichtbare strafblad van ALLE spelers en plaatst een wereldchat-promo met afbeelding. Doorgaan?",
          "This wipes the visible criminal record for ALL players and posts a world-chat promo with image. Continue?",
        ),
      )
    ) {
      return;
    }

    setAmnestyBusy(true);
    setError(null);
    setMessage(null);
    try {
      const result = await adminService.runCourtRecordAmnesty();
      setLastResult({
        playersCleared: result.playersCleared,
        recordsCleared: result.recordsCleared,
        announcementId: result.announcementId,
      });
      setMessage(
        tr(
          locale,
          `Amnesty gedaan: ${result.playersCleared} spelers, ${result.recordsCleared} records. Wereldchat-promo geplaatst.`,
          `Amnesty done: ${result.playersCleared} players, ${result.recordsCleared} records. World-chat promo posted.`,
        ),
      );
      setConfirmText("");
    } catch (err) {
      console.error(err);
      setError(
        err instanceof Error
          ? err.message
          : tr(locale, "Amnesty mislukt.", "Amnesty failed."),
      );
    } finally {
      setAmnestyBusy(false);
    }
  };

  const kpiField = (key: string) => ALL_FIELDS.find((field) => field.key === key);

  const kpis = [
    {
      key: "COURT_EXPUNGE_BASE_COST",
      labelNl: "Petitie basis",
      labelEn: "Petition base",
    },
    {
      key: "COURT_EXPUNGE_BASE_PERCENT",
      labelNl: "Petitie kans",
      labelEn: "Petition chance",
    },
    {
      key: "COURT_APPEAL_BASE_PERCENT",
      labelNl: "Beroep kans",
      labelEn: "Appeal chance",
    },
    {
      key: "COURT_EXPUNGE_COOLDOWN_SECONDS",
      labelNl: "Petitie cooldown",
      labelEn: "Petition cooldown",
    },
  ];

  return (
    <section className="runtime-console">
      <AdminPageIntro
        kicker={tr(locale, "Rechtbank · live runtime", "Court · live runtime")}
        description={tr(
          locale,
          "Stuur hoger beroep, strafblad-petitie en Don-rechterbonus zonder deploy. Globale amnesty blijft onderaan voor SUPER_ADMIN.",
          "Tune appeal, criminal-record petition and Don judge bonus without a deploy. Global amnesty stays below for SUPER_ADMIN.",
        )}
      />

      {error ? <div className="alert alert-danger">{error}</div> : null}
      {message ? <div className="alert alert-success">{message}</div> : null}

      <RuntimeKpiGrid>
        {kpis.map((kpi) => {
          const field = kpiField(kpi.key);
          const raw = values[kpi.key] ?? "";
          let display = field
            ? formatAmount(locale, field.kind, raw)
            : "—";
          if (kpi.key === "COURT_EXPUNGE_COOLDOWN_SECONDS") {
            const seconds = Number(raw);
            if (Number.isFinite(seconds) && seconds >= 0) {
              const hours = seconds / 3600;
              display =
                locale === "nl"
                  ? `${hours.toLocaleString("nl-NL", { maximumFractionDigits: 1 })} u`
                  : `${hours.toLocaleString("en-GB", { maximumFractionDigits: 1 })} h`;
            }
          }
          return (
            <RuntimeKpi
              key={kpi.key}
              label={tr(locale, kpi.labelNl, kpi.labelEn)}
              value={display}
            />
          );
        })}
      </RuntimeKpiGrid>

      <RuntimeToolbar
        locale={locale}
        loading={loading}
        saving={saving}
        dirtyCount={dirtyKeys.length}
        disabled={!view}
        onRefresh={() => void load()}
        onDiscard={discard}
        onSave={() => void save()}
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
                      value={values[field.key] ?? ""}
                      saved={
                        view
                          ? runtimeValueFor(view, field.key)
                          : (values[field.key] ?? "")
                      }
                      fallback={
                        view ? String(view.defaults[field.key] ?? "") : ""
                      }
                      disabled={!view || saving}
                      onChange={(next) =>
                        setValues((prev) => ({ ...prev, [field.key]: next }))
                      }
                      onReset={() => resetField(field.key)}
                    />
                  </div>
                ))}
              </div>
            </div>
          </div>
        ))}

        <div className="card border-danger">
          <div className="card-header d-flex align-items-start gap-3">
            <i className="ph-warning-octagon runtime-section-icon fs-4 text-danger" />
            <div>
              <h2 className="h5 mb-1">
                {tr(
                  locale,
                  "Globale amnesty",
                  "Global amnesty",
                )}
              </h2>
              <p className="text-muted small mb-0">
                {tr(
                  locale,
                  "Wist zichtbare strafbladen voor iedereen en plaatst de wereldchat-promo. Alleen SUPER_ADMIN.",
                  "Wipes visible criminal records for everyone and posts the world-chat promo. SUPER_ADMIN only.",
                )}
              </p>
            </div>
          </div>
          <div className="card-body">
            {!isSuperAdmin ? (
              <p className="text-muted mb-0">
                {tr(
                  locale,
                  "Alleen SUPER_ADMIN mag de globale strafblad-amnesty starten.",
                  "Only SUPER_ADMIN can run the global criminal-record amnesty.",
                )}
              </p>
            ) : (
              <>
                <p>
                  {tr(
                    locale,
                    "Schrijft voor elke speler een trial.record_expunged-marker (source: amnesty). Nieuwe veroordelingen daarna tellen weer normaal. Spelers komen niet vrij uit de cel.",
                    "Writes a trial.record_expunged marker per player (source: amnesty). New convictions after that count normally. Players are not released from jail.",
                  )}
                </p>

                <div className="border rounded p-3 mb-3 bg-body-tertiary">
                  <h3 className="h6">
                    {tr(locale, "Promo-voorbeeld", "Promo preview")}
                  </h3>
                  <p className="mb-1">
                    <strong>Rechtbank</strong>
                  </p>
                  <pre
                    className="mb-2"
                    style={{
                      whiteSpace: "pre-wrap",
                      fontFamily: "inherit",
                    }}
                  >
                    {PROMO_PREVIEW_NL}
                  </pre>
                  <p className="small text-muted mb-0">
                    {tr(locale, "Afbeelding", "Image")}:{" "}
                    <code>promo/court_record_wipe.png</code>
                  </p>
                </div>

                <label className="form-label">
                  {tr(
                    locale,
                    `Typ ter bevestiging exact: ${CONFIRM_PHRASE}`,
                    `Type exactly to confirm: ${CONFIRM_PHRASE}`,
                  )}
                </label>
                <div className="d-flex flex-wrap gap-2 align-items-center">
                  <input
                    className="form-control"
                    style={{ maxWidth: 320 }}
                    type="text"
                    value={confirmText}
                    onChange={(event) => setConfirmText(event.target.value)}
                    placeholder={CONFIRM_PHRASE}
                    autoComplete="off"
                    spellCheck={false}
                  />
                  <button
                    type="button"
                    className="btn btn-danger"
                    disabled={!canRunAmnesty}
                    onClick={() => void runAmnesty()}
                  >
                    {amnestyBusy
                      ? tr(locale, "Bezig…", "Working…")
                      : tr(
                          locale,
                          "Strafbladen wissen + promo",
                          "Wipe records + promo",
                        )}
                  </button>
                </div>

                {lastResult ? (
                  <p className="small text-muted mt-3 mb-0">
                    {tr(locale, "Laatste run", "Last run")}:{" "}
                    {lastResult.playersCleared}{" "}
                    {tr(locale, "spelers", "players")} ·{" "}
                    {lastResult.recordsCleared}{" "}
                    {tr(locale, "records", "records")}
                    {lastResult.announcementId != null
                      ? ` · chat #${lastResult.announcementId}`
                      : ""}
                  </p>
                ) : null}
              </>
            )}
          </div>
        </div>
      </div>
    </section>
  );
}
