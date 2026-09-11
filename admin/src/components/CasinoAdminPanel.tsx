import { useEffect, useMemo, useState } from "react";
import {
  adminService,
  type CasinoRuntimeConfigView,
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
    id: "floors",
    icon: "ph-stairs",
    titleNl: "Verdiepingen",
    titleEn: "Floors",
    blurbNl: "Maximale inzet per zaal.",
    blurbEn: "Maximum bet per floor.",
    fields: [
      {
        key: "CASINO_FLOOR_MAX_BET_1",
        kind: "euro",
        labelNl: "Public — max inzet",
        labelEn: "Public — max bet",
        helpNl: "Verdieping 1, openbare zaal.",
        helpEn: "Floor 1, public room.",
      },
      {
        key: "CASINO_FLOOR_MAX_BET_2",
        kind: "euro",
        labelNl: "VIP — max inzet",
        labelEn: "VIP — max bet",
        helpNl: "Verdieping 2.",
        helpEn: "Floor 2.",
      },
      {
        key: "CASINO_FLOOR_MAX_BET_3",
        kind: "euro",
        labelNl: "Private — max inzet",
        labelEn: "Private — max bet",
        helpNl: "Verdieping 3.",
        helpEn: "Floor 3.",
      },
    ],
  },
  {
    id: "rake",
    icon: "ph-percent",
    titleNl: "Rake",
    titleEn: "Rake",
    blurbNl: "Huisvoordeel per verdieping, in basispunten.",
    blurbEn: "House take per floor, in basis points.",
    fields: [
      {
        key: "CASINO_RAKE_BPS_1",
        kind: "bps",
        labelNl: "Public rake",
        labelEn: "Public rake",
        helpNl: "200 bps = 2%.",
        helpEn: "200 bps = 2%.",
      },
      {
        key: "CASINO_RAKE_BPS_2",
        kind: "bps",
        labelNl: "VIP rake",
        labelEn: "VIP rake",
        helpNl: "350 bps = 3,5%.",
        helpEn: "350 bps = 3.5%.",
      },
      {
        key: "CASINO_RAKE_BPS_3",
        kind: "bps",
        labelNl: "Private rake",
        labelEn: "Private rake",
        helpNl: "500 bps = 5%.",
        helpEn: "500 bps = 5%.",
      },
    ],
  },
  {
    id: "upgrades",
    icon: "ph-arrow-circle-up",
    titleNl: "Upgrades",
    titleEn: "Upgrades",
    blurbNl: "Speler-cash om een verdieping te ontgrendelen.",
    blurbEn: "Player cash to unlock a floor.",
    fields: [
      {
        key: "CASINO_FLOOR_UPGRADE_2",
        kind: "euro",
        labelNl: "Upgrade naar VIP",
        labelEn: "Upgrade to VIP",
        helpNl: "Kosten van public naar VIP.",
        helpEn: "Cost from public to VIP.",
      },
      {
        key: "CASINO_FLOOR_UPGRADE_3",
        kind: "euro",
        labelNl: "Upgrade naar private",
        labelEn: "Upgrade to private",
        helpNl: "Kosten van VIP naar private.",
        helpEn: "Cost from VIP to private.",
      },
    ],
  },
  {
    id: "security",
    icon: "ph-shield",
    titleNl: "Ledger-raid & security",
    titleEn: "Ledger raid & security",
    blurbNl: "Hoe hard een raid de bankroll raakt, en hoeveel staf dat dempt.",
    blurbEn: "How hard a raid hits the bankroll, and how much staff reduces that.",
    fields: [
      {
        key: "CASINO_RAID_DRAIN_PCT",
        kind: "percent",
        labelNl: "Raid drain",
        labelEn: "Raid drain",
        helpNl: "Basispercentage van de bankroll.",
        helpEn: "Base percentage of bankroll.",
      },
      {
        key: "CASINO_SECURITY_DRAIN_REDUCTION_BPS",
        kind: "bps",
        labelNl: "Security-schaal",
        labelEn: "Security scale",
        helpNl: "10000 bps = 100% staff-defense.",
        helpEn: "10000 bps = 100% staff defense.",
      },
    ],
  },
];

const ALL_FIELDS = SECTIONS.flatMap((section) => section.fields);
const tr = (locale: AdminLanguage, nl: string, en: string) =>
  getAdminTr(locale, nl, en);

function valuesFromView(view: CasinoRuntimeConfigView): Record<string, string> {
  const next: Record<string, string> = {};
  for (const field of ALL_FIELDS) {
    next[field.key] = runtimeValueFor(view, field.key);
  }
  return next;
}

export function CasinoAdminPanel({ locale }: Props) {
  const [view, setView] = useState<CasinoRuntimeConfigView | null>(null);
  const [loading, setLoading] = useState(false);
  const [saving, setSaving] = useState(false);
  const [values, setValues] = useState<Record<string, string>>({});
  const [message, setMessage] = useState<string | null>(null);
  const [error, setError] = useState<string | null>(null);

  const load = async () => {
    try {
      setLoading(true);
      setError(null);
      const next = await adminService.getCasinoRuntimeConfig();
      setView(next);
      setValues(valuesFromView(next));
    } catch (err) {
      setError(
        tr(
          locale,
          "Casino-configuratie laden mislukt.",
          "Failed to load casino configuration.",
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
      ALL_FIELDS.filter((field) => isInvalidAmount(values[field.key] ?? "")).map(
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
      const updated = await adminService.updateCasinoRuntimeConfig(values);
      setView(updated);
      setValues(valuesFromView(updated));
      setMessage(
        tr(
          locale,
          "Casino-runtime opgeslagen. Wijzigingen gelden direct.",
          "Casino runtime saved. Changes apply immediately.",
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

  return (
    <section className="runtime-console">
      <AdminPageIntro
        kicker={tr(locale, "Economie · live runtime", "Economy · live runtime")}
        description={tr(
          locale,
          "Stuur inzetten, rake, upgrades en ledger-raids zonder deploy.",
          "Tune bets, rake, upgrades and ledger raids without a deploy.",
        )}
      />
      {error && <div className="alert alert-danger">{error}</div>}
      {message && <div className="alert alert-success">{message}</div>}
      <RuntimeKpiGrid>
        <RuntimeKpi
          label={tr(locale, "Public max", "Public max")}
          value={formatAmount(locale, "euro", values.CASINO_FLOOR_MAX_BET_1 ?? "")}
        />
        <RuntimeKpi
          label={tr(locale, "VIP rake", "VIP rake")}
          value={formatAmount(locale, "bps", values.CASINO_RAKE_BPS_2 ?? "")}
        />
        <RuntimeKpi
          label={tr(locale, "Upgrade VIP", "VIP upgrade")}
          value={formatAmount(locale, "euro", values.CASINO_FLOOR_UPGRADE_2 ?? "")}
        />
        <RuntimeKpi
          label={tr(locale, "Raid drain", "Raid drain")}
          value={formatAmount(locale, "percent", values.CASINO_RAID_DRAIN_PCT ?? "")}
        />
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
      </div>
    </section>
  );
}
