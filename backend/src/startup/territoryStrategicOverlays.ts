/**
 * Curated strategic tags (+ optional tier/neighbors) for auto-seeded territory regions.
 * Keys are SVG element ids as used in territoryRegionSeeds (matched case-insensitively).
 * Applied on top of empty auto-region defaults so non-NL maps get real strategic identity.
 */

export type TerritoryStrategicOverlay = {
  strategicTags: string[];
  /** When set, overrides the default auto-region value tier (usually 2). */
  valueTier?: number;
  /** Optional neighbor regionKeys (normalized from SVG ids). */
  neighbors?: string[];
};

/** Overlay keyed by lowercase SVG element id. */
export const TERRITORY_STRATEGIC_OVERLAYS_BY_SVG: Record<string, TerritoryStrategicOverlay> = {
  // ── Belgium ──────────────────────────────────────────────────────────────
  'be-bru': { strategicTags: ['capital', 'logistics', 'airhub'], valueTier: 3, neighbors: ['be-vbr', 'be-wbr'] },
  'be-van': { strategicTags: ['harbor', 'industry', 'logistics'], valueTier: 3, neighbors: ['be-vov', 'be-vli'] },
  'be-vwv': { strategicTags: ['harbor', 'border'], valueTier: 2, neighbors: ['be-vov'] },
  'be-vov': { strategicTags: ['industry', 'logistics'], valueTier: 2, neighbors: ['be-van', 'be-vwv', 'be-vbr'] },
  'be-vli': { strategicTags: ['border', 'industry'], valueTier: 2, neighbors: ['be-van', 'be-vbr', 'be-wlg'] },
  'be-vbr': { strategicTags: ['logistics'], valueTier: 2, neighbors: ['be-bru', 'be-vov', 'be-vli', 'be-wbr'] },
  'be-wbr': { strategicTags: ['logistics'], valueTier: 2, neighbors: ['be-bru', 'be-vbr', 'be-wna', 'be-wht'] },
  'be-wht': { strategicTags: ['industry', 'border'], valueTier: 2, neighbors: ['be-wbr', 'be-wna'] },
  'be-wlg': { strategicTags: ['industry', 'border'], valueTier: 2, neighbors: ['be-vli', 'be-wna', 'be-wlx'] },
  'be-wna': { strategicTags: ['border'], valueTier: 1, neighbors: ['be-wbr', 'be-wht', 'be-wlg', 'be-wlx'] },
  'be-wlx': { strategicTags: ['border'], valueTier: 1, neighbors: ['be-wlg', 'be-wna'] },

  // ── Germany ──────────────────────────────────────────────────────────────
  'de-be': { strategicTags: ['capital', 'logistics', 'airhub'], valueTier: 3, neighbors: ['de-bb'] },
  'de-hh': { strategicTags: ['harbor', 'logistics', 'airhub'], valueTier: 3, neighbors: ['de-sh', 'de-ni'] },
  'de-hb': { strategicTags: ['harbor', 'logistics'], valueTier: 2, neighbors: ['de-ni'] },
  'de-nw': { strategicTags: ['industry', 'logistics'], valueTier: 3, neighbors: ['de-ni', 'de-he', 'de-rp'] },
  'de-by': { strategicTags: ['industry', 'border'], valueTier: 3, neighbors: ['de-bw', 'de-th', 'de-sn'] },
  'de-bw': { strategicTags: ['industry', 'border'], valueTier: 3, neighbors: ['de-by', 'de-rp', 'de-he'] },
  'de-sn': { strategicTags: ['industry', 'border'], valueTier: 2, neighbors: ['de-by', 'de-th', 'de-bb', 'de-st'] },
  'de-sl': { strategicTags: ['border', 'industry'], valueTier: 1, neighbors: ['de-rp'] },
  'de-sh': { strategicTags: ['harbor', 'border'], valueTier: 2, neighbors: ['de-hh', 'de-mv', 'de-ni'] },
  'de-mv': { strategicTags: ['harbor', 'border'], valueTier: 1, neighbors: ['de-sh', 'de-bb', 'de-ni'] },
  'de-ni': { strategicTags: ['logistics'], valueTier: 2, neighbors: ['de-hh', 'de-hb', 'de-sh', 'de-nw', 'de-he', 'de-st', 'de-mv'] },
  'de-he': { strategicTags: ['logistics', 'airhub'], valueTier: 2, neighbors: ['de-nw', 'de-rp', 'de-bw', 'de-by', 'de-th', 'de-ni'] },
  'de-rp': { strategicTags: ['border', 'logistics'], valueTier: 2, neighbors: ['de-nw', 'de-he', 'de-bw', 'de-sl'] },
  'de-bb': { strategicTags: ['logistics'], valueTier: 2, neighbors: ['de-be', 'de-mv', 'de-st', 'de-sn'] },
  'de-st': { strategicTags: ['industry'], valueTier: 1, neighbors: ['de-ni', 'de-bb', 'de-sn', 'de-th'] },
  'de-th': { strategicTags: ['industry'], valueTier: 1, neighbors: ['de-he', 'de-by', 'de-sn', 'de-st'] },

  // ── France ───────────────────────────────────────────────────────────────
  'fr-idf': { strategicTags: ['capital', 'logistics', 'airhub'], valueTier: 3, neighbors: ['fr-hdf', 'fr-nor', 'fr-cvl', 'fr-ges', 'fr-bfc'] },
  'fr-pac': { strategicTags: ['harbor', 'border'], valueTier: 3, neighbors: ['fr-occ', 'fr-ara', 'fr-cor'] },
  'fr-naq': { strategicTags: ['harbor', 'border'], valueTier: 2, neighbors: ['fr-occ', 'fr-pdl', 'fr-cvl'] },
  'fr-bre': { strategicTags: ['harbor'], valueTier: 2, neighbors: ['fr-pdl', 'fr-nor'] },
  'fr-hdf': { strategicTags: ['harbor', 'border', 'industry'], valueTier: 2, neighbors: ['fr-idf', 'fr-nor', 'fr-ges'] },
  'fr-ges': { strategicTags: ['border', 'industry'], valueTier: 2, neighbors: ['fr-idf', 'fr-hdf', 'fr-bfc'] },
  'fr-ara': { strategicTags: ['industry', 'border'], valueTier: 3, neighbors: ['fr-bfc', 'fr-pac', 'fr-occ', 'fr-cvl'] },
  'fr-occ': { strategicTags: ['border'], valueTier: 2, neighbors: ['fr-pac', 'fr-ara', 'fr-naq'] },
  'fr-nor': { strategicTags: ['harbor', 'logistics'], valueTier: 2, neighbors: ['fr-bre', 'fr-hdf', 'fr-idf', 'fr-pdl'] },
  'fr-pdl': { strategicTags: ['logistics'], valueTier: 2, neighbors: ['fr-bre', 'fr-nor', 'fr-cvl', 'fr-naq'] },
  'fr-cvl': { strategicTags: ['logistics'], valueTier: 1, neighbors: ['fr-idf', 'fr-pdl', 'fr-naq', 'fr-ara', 'fr-bfc'] },
  'fr-bfc': { strategicTags: ['industry'], valueTier: 1, neighbors: ['fr-idf', 'fr-ges', 'fr-ara', 'fr-cvl'] },
  'fr-cor': { strategicTags: ['harbor', 'border'], valueTier: 1, neighbors: ['fr-pac'] },

  // ── Italy ────────────────────────────────────────────────────────────────
  'it-62': { strategicTags: ['capital', 'logistics'], valueTier: 3, neighbors: ['it-57', 'it-55', 'it-65', 'it-72'] }, // Lazio
  'it-25': { strategicTags: ['industry', 'logistics', 'airhub'], valueTier: 3, neighbors: ['it-21', 'it-34', 'it-45'] }, // Lombardia
  'it-42': { strategicTags: ['harbor', 'border'], valueTier: 2, neighbors: ['it-21', 'it-45', 'it-52'] }, // Liguria
  'it-34': { strategicTags: ['harbor', 'industry'], valueTier: 2, neighbors: ['it-25', 'it-32', 'it-36', 'it-45'] }, // Veneto
  'it-82': { strategicTags: ['harbor', 'border'], valueTier: 2, neighbors: ['it-78'] }, // Sicilia
  'it-88': { strategicTags: ['harbor'], valueTier: 1, neighbors: [] }, // Sardegna
  'it-72': { strategicTags: ['harbor', 'industry'], valueTier: 2, neighbors: ['it-62', 'it-67', 'it-65', 'it-75'] }, // Campania
  'it-36': { strategicTags: ['border', 'harbor'], valueTier: 2, neighbors: ['it-34', 'it-32'] }, // Friuli
  'it-32': { strategicTags: ['border'], valueTier: 1, neighbors: ['it-34', 'it-36', 'it-25'] }, // Trentino
  'it-21': { strategicTags: ['industry', 'border'], valueTier: 2, neighbors: ['it-25', 'it-42', 'it-23'] }, // Piemonte
  'it-45': { strategicTags: ['industry', 'logistics'], valueTier: 2, neighbors: ['it-25', 'it-34', 'it-42', 'it-52', 'it-57'] }, // Emilia
  'it-52': { strategicTags: ['logistics'], valueTier: 2, neighbors: ['it-42', 'it-45', 'it-55', 'it-57'] }, // Toscana

  // ── Spain ────────────────────────────────────────────────────────────────
  'es-md': { strategicTags: ['capital', 'logistics', 'airhub'], valueTier: 3, neighbors: ['es-cm', 'es-cl'] },
  'es-ct': { strategicTags: ['harbor', 'industry', 'border'], valueTier: 3, neighbors: ['es-ar', 'es-vc'] },
  'es-an': { strategicTags: ['harbor', 'border'], valueTier: 2, neighbors: ['es-ex', 'es-cm', 'es-mc'] },
  'es-vc': { strategicTags: ['harbor', 'industry'], valueTier: 2, neighbors: ['es-ct', 'es-cm', 'es-mc'] },
  'es-pv': { strategicTags: ['industry', 'border', 'harbor'], valueTier: 2, neighbors: ['es-nc', 'es-ri', 'es-cb'] },
  'es-ga': { strategicTags: ['harbor', 'border'], valueTier: 2, neighbors: ['es-as', 'es-cl'] },
  'es-cn': { strategicTags: ['harbor', 'airhub'], valueTier: 2, neighbors: [] },
  'es-ib': { strategicTags: ['harbor'], valueTier: 1, neighbors: [] },
  'es-ex': { strategicTags: ['border'], valueTier: 1, neighbors: ['es-an', 'es-cm', 'es-cl'] },

  // ── United Kingdom / Ireland map ─────────────────────────────────────────
  'gb-uki': { strategicTags: ['capital', 'logistics', 'airhub'], valueTier: 3, neighbors: ['gb-ukj', 'gb-ukh'] },
  'gb-ukd': { strategicTags: ['harbor', 'industry'], valueTier: 2, neighbors: ['gb-ukc', 'gb-uke', 'gb-ukg', 'gb-wls'] },
  'gb-uke': { strategicTags: ['industry', 'harbor'], valueTier: 2, neighbors: ['gb-ukc', 'gb-ukd', 'gb-ukf'] },
  'gb-ukg': { strategicTags: ['industry', 'logistics'], valueTier: 2, neighbors: ['gb-ukd', 'gb-ukf', 'gb-ukj', 'gb-wls'] },
  'gb-ukj': { strategicTags: ['logistics', 'harbor'], valueTier: 2, neighbors: ['gb-uki', 'gb-ukg', 'gb-ukk', 'gb-ukh'] },
  'gb-ukk': { strategicTags: ['harbor'], valueTier: 2, neighbors: ['gb-ukj', 'gb-ukg', 'gb-wls'] },
  'gb-sct': { strategicTags: ['harbor', 'border'], valueTier: 2, neighbors: ['gb-ukc'] },
  'gb-wls': { strategicTags: ['border', 'harbor'], valueTier: 2, neighbors: ['gb-ukd', 'gb-ukg', 'gb-ukk'] },
  'gb-nir': { strategicTags: ['border', 'harbor'], valueTier: 1, neighbors: ['ie'] },
  'ie': { strategicTags: ['harbor', 'capital', 'airhub'], valueTier: 2, neighbors: ['gb-nir'] },
  'gb-ukc': { strategicTags: ['harbor', 'industry'], valueTier: 1, neighbors: ['gb-sct', 'gb-ukd', 'gb-uke'] },

  // ── United States (key hubs) ─────────────────────────────────────────────
  'us-dc': { strategicTags: ['capital', 'logistics'], valueTier: 3, neighbors: ['us-md', 'us-va'] },
  'us-ny': { strategicTags: ['capital', 'harbor', 'logistics', 'airhub'], valueTier: 3, neighbors: ['us-nj', 'us-pa', 'us-ct', 'us-ma'] },
  'us-ca': { strategicTags: ['harbor', 'industry', 'airhub', 'border'], valueTier: 3, neighbors: ['us-or', 'us-nv', 'us-az'] },
  'us-fl': { strategicTags: ['harbor', 'airhub'], valueTier: 3, neighbors: ['us-ga', 'us-al'] },
  'us-tx': { strategicTags: ['industry', 'border', 'harbor'], valueTier: 3, neighbors: ['us-nm', 'us-ok', 'us-ar', 'us-la'] },
  'us-il': { strategicTags: ['logistics', 'industry', 'airhub'], valueTier: 3, neighbors: ['us-wi', 'us-in', 'us-mo', 'us-ia'] },
  'us-wa': { strategicTags: ['harbor', 'border', 'airhub'], valueTier: 2, neighbors: ['us-or', 'us-id'] },
  'us-mi': { strategicTags: ['industry', 'border'], valueTier: 2, neighbors: ['us-oh', 'us-in', 'us-wi'] },
  'us-la': { strategicTags: ['harbor', 'industry'], valueTier: 2, neighbors: ['us-tx', 'us-ar', 'us-ms'] },
  'us-ak': { strategicTags: ['border', 'harbor'], valueTier: 1, neighbors: [] },
  'us-hi': { strategicTags: ['harbor', 'airhub'], valueTier: 1, neighbors: [] },
};

export function lookupTerritoryStrategicOverlay(svgElementId: string): TerritoryStrategicOverlay | null {
  const key = svgElementId.trim().toLowerCase();
  return TERRITORY_STRATEGIC_OVERLAYS_BY_SVG[key] ?? null;
}
