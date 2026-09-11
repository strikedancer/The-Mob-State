import { useEffect, useState } from "react";
import { createPortal } from "react-dom";
import type { AdminLanguage } from "../i18n/translations";
import { getAdminTr } from "../i18n/inlineMessages";
import { catalogPublicImageUrl } from "../services/adminService";

type ThumbProps = {
  locale: AdminLanguage;
  folder?: "vehicles" | "aircraft";
  file?: string | null;
  alt: string;
  caption?: string;
};

export function AdminImageThumb({
  locale,
  folder = "vehicles",
  file,
  alt,
  caption,
}: ThumbProps) {
  const t = (nl: string, en: string) => getAdminTr(locale, nl, en);
  const src = catalogPublicImageUrl(folder, file);
  const [open, setOpen] = useState(false);
  const [broken, setBroken] = useState(false);

  useEffect(() => {
    setBroken(false);
  }, [src]);

  useEffect(() => {
    if (!open) return;
    const onKey = (event: KeyboardEvent) => {
      if (event.key === "Escape") setOpen(false);
    };
    window.addEventListener("keydown", onKey);
    return () => window.removeEventListener("keydown", onKey);
  }, [open]);

  if (!src || broken) {
    return (
      <span className="text-muted" title={file || undefined}>
        —
      </span>
    );
  }

  return (
    <>
      <button
        type="button"
        className="admin-image-thumb"
        title={file || alt}
        onClick={() => setOpen(true)}
      >
        <img src={src} alt={alt} onError={() => setBroken(true)} />
      </button>
      {open
        ? createPortal(
            <div
              className="modal-overlay"
              role="presentation"
              onClick={() => setOpen(false)}
            >
              <div
                className="admin-image-lightbox"
                role="dialog"
                aria-modal="true"
                aria-label={alt}
                onClick={(event) => event.stopPropagation()}
              >
                <img src={src} alt={alt} />
                {caption ? (
                  <p className="small text-muted mb-0 mt-2">{caption}</p>
                ) : null}
                <button
                  type="button"
                  className="btn btn-sm btn-outline-secondary mt-3"
                  onClick={() => setOpen(false)}
                >
                  {t("Sluiten", "Close")}
                </button>
              </div>
            </div>,
            document.body,
          )
        : null}
    </>
  );
}

type VehicleRow = {
  id: string;
  name: string;
  type: string;
  image?: string;
  imageNew?: string;
  imageDirty?: string;
  imageDamaged?: string;
  requiredRank: number;
};

type TableProps = {
  locale: AdminLanguage;
  title: string;
  items: VehicleRow[];
  deleteLabel: string;
  onDelete: (id: string) => void;
};

export function VehicleCatalogTable({
  locale,
  title,
  items,
  deleteLabel,
  onDelete,
}: TableProps) {
  const t = (nl: string, en: string) => getAdminTr(locale, nl, en);
  return (
    <>
      <h2>{title}</h2>
      <div className="table-container" style={{ marginBottom: "1rem" }}>
        <table className="data-table vehicle-catalog-table">
          <thead>
            <tr>
              <th>{t("ID", "ID")}</th>
              <th>{t("Naam", "Name")}</th>
              <th>{t("Type", "Type")}</th>
              <th>{t("Nieuw", "New")}</th>
              <th>{t("Vies", "Dirty")}</th>
              <th>{t("Defect", "Damaged")}</th>
              <th>{t("Rang", "Rank")}</th>
              <th>{t("Acties", "Actions")}</th>
            </tr>
          </thead>
          <tbody>
            {items.map((vehicle) => (
              <tr key={vehicle.id}>
                <td>{vehicle.id}</td>
                <td>{vehicle.name}</td>
                <td>{vehicle.type}</td>
                <td>
                  <AdminImageThumb
                    locale={locale}
                    file={vehicle.imageNew || vehicle.image}
                    alt={`${vehicle.name} — ${t("nieuw", "new")}`}
                    caption={`${vehicle.name} · ${t("Nieuw", "New")}`}
                  />
                </td>
                <td>
                  <AdminImageThumb
                    locale={locale}
                    file={vehicle.imageDirty}
                    alt={`${vehicle.name} — ${t("vies", "dirty")}`}
                    caption={`${vehicle.name} · ${t("Vies", "Dirty")}`}
                  />
                </td>
                <td>
                  <AdminImageThumb
                    locale={locale}
                    file={vehicle.imageDamaged}
                    alt={`${vehicle.name} — ${t("defect", "damaged")}`}
                    caption={`${vehicle.name} · ${t("Defect", "Damaged")}`}
                  />
                </td>
                <td>{vehicle.requiredRank}</td>
                <td>
                  <button
                    className="btn-small btn-danger"
                    onClick={() => onDelete(vehicle.id)}
                  >
                    {deleteLabel}
                  </button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </>
  );
}
