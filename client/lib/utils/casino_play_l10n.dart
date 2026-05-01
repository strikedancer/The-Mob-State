import '../l10n/app_localizations.dart';

String mapCasinoPlayError(
  AppLocalizations l10n,
  String? reason, {
  required String fallback,
}) {
  switch (reason) {
    case 'CASINO_NOT_FOUND':
      return l10n.casinoErrCasinoNotFound;
    case 'INSUFFICIENT_FUNDS':
      return l10n.casinoErrInsufficientFunds;
    case 'INSUFFICIENT_BANKROLL':
      return l10n.casinoErrInsufficientBankrollPayout;
    default:
      if (reason != null && reason.isNotEmpty) return reason;
      return fallback;
  }
}

String localizedCasinoGameName(AppLocalizations l10n, String gameId) {
  switch (gameId) {
    case 'slots':
      return l10n.casinoGameSlotsName;
    case 'blackjack':
      return l10n.casinoGameBlackjackName;
    case 'roulette':
      return l10n.casinoGameRouletteName;
    case 'dice':
      return l10n.casinoGameDiceName;
    case 'baccarat':
      return l10n.casinoGameBaccaratName;
    case 'video_poker':
      return l10n.casinoGameVideoPokerName;
    default:
      return gameId;
  }
}
