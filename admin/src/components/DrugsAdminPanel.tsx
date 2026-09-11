import { useEffect, useMemo, useState } from "react";
import {
  adminService,
  type DrugRuntimeConfigView,
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

function valuesFromView(view: DrugRuntimeConfigView): Record<string, string> {
  const next: Record<string, string> = {};
  for (const field of ALL_FIELDS) {
    next[field.key] = runtimeValueFor(view, field.key);
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
      (field) => (values[field.key] ?? "") !== runtimeValueFor(view, field.key),
    ).map((field) => field.key);
  }, [values, view]);

  const invalidKeys = useMemo(
    () => ALL_FIELDS.filter((field) => isInvalidAmount(values[field.key] ?? "")).map(
      (field) => field.key,
    ),
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
      <AdminPageIntro
        kicker={tr(locale, "Economie · live runtime", "Economy · live runtime")}
        description={tr(
          locale,
          "Stuur groothandel, heat, raids, darkweb en nightclub zonder deploy. Police-pressure en Clearing House blijven op hun eigen tabs.",
          "Tune wholesale, heat, raids, darkweb and nightclub without a deploy. Police pressure and Clearing House stay on their own tabs.",
        )}
      />

      {error && <div className="alert alert-danger">{error}</div>}
      {message && <div className="alert alert-success">{message}</div>}

      <RuntimeKpiGrid>
        {kpis.map((kpi) => {
          const field = kpiField(kpi.key);
          return (
            <RuntimeKpi
              key={kpi.key}
              label={tr(locale, kpi.labelNl, kpi.labelEn)}
              value={
                field
                  ? formatAmount(locale, field.kind, values[kpi.key] ?? "")
                  : "—"
              }
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
                      saved={runtimeValueFor(view, field.key)}
                      fallback={view ? String(view.defaults[field.key] ?? "") : ""}
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
      </div>
    </section>
  );
}
