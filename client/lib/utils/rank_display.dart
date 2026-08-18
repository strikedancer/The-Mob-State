import '../l10n/app_localizations.dart';

/// Localized rank titles and icons.
///
/// Bands must stay in sync with `backend/src/utils/rankSystem.ts` (`RANK_TITLES`).
class RankDisplay {
  RankDisplay._();

  static String title(AppLocalizations l10n, int rank) {
    if (rank >= 120 && rank <= 150) return l10n.rankLegend;
    if (rank >= 90 && rank <= 119) return l10n.rankOverlord;
    if (rank >= 75 && rank <= 89) return l10n.rankDon;
    if (rank >= 60 && rank <= 74) return l10n.rankGodfather;
    if (rank >= 50 && rank <= 59) return l10n.rankDrugLord;
    if (rank >= 45 && rank <= 49) return l10n.rankChief;
    if (rank >= 40 && rank <= 44) return l10n.rankLocalChief;
    if (rank >= 35 && rank <= 39) return l10n.rankAssassin;
    if (rank >= 30 && rank <= 34) return l10n.rankSwindler;
    if (rank >= 25 && rank <= 29) return l10n.rankSoldier;
    if (rank >= 20 && rank <= 24) return l10n.rankCadet;
    if (rank >= 15 && rank <= 19) return l10n.rankAssociate;
    if (rank >= 10 && rank <= 14) return l10n.rankThief;
    if (rank >= 7 && rank <= 9) return l10n.rankPickpocket;
    if (rank >= 5 && rank <= 6) return l10n.rankShoplifter;
    if (rank >= 3 && rank <= 4) return l10n.rankPicciotto;
    if (rank == 2) return l10n.rankDeliveryBoy;
    if (rank == 1) return l10n.rankEmptySuit;
    return l10n.rankUnknown;
  }

  static String icon(int rank) {
    if (rank >= 120 && rank <= 150) return '🏆';
    if (rank >= 90 && rank <= 119) return '⚡';
    if (rank >= 75 && rank <= 89) return '💎';
    if (rank >= 60 && rank <= 74) return '👨‍💼';
    if (rank >= 50 && rank <= 59) return '💊';
    if (rank >= 45 && rank <= 49) return '👑';
    if (rank >= 40 && rank <= 44) return '⭐';
    if (rank >= 35 && rank <= 39) return '🎯';
    if (rank >= 30 && rank <= 34) return '🎰';
    if (rank >= 25 && rank <= 29) return '💪';
    if (rank >= 20 && rank <= 24) return '📋';
    if (rank >= 15 && rank <= 19) return '🤐';
    if (rank >= 10 && rank <= 14) return '🔓';
    if (rank >= 7 && rank <= 9) return '👜';
    if (rank >= 5 && rank <= 6) return '🛍️';
    if (rank >= 3 && rank <= 4) return '🤝';
    if (rank == 2) return '🚚';
    if (rank == 1) return '🎩';
    return '❓';
  }

  static String withIcon(AppLocalizations l10n, int rank) =>
      '${icon(rank)} ${title(l10n, rank)}';
}
