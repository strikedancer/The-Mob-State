import '../l10n/app_localizations.dart';
import '../models/judge.dart';

class CourtLocalization {
  CourtLocalization._();

  static final _titlePrefixes = <String>[
    'Rechter ',
    'Judge ',
    'Richter ',
    'Juge ',
    'Juez ',
    'Giudice ',
    'Sędzia ',
    'Juiz ',
  ];

  static String judgeFamilyName(Judge judge) {
    var name = judge.name.trim();
    for (final prefix in _titlePrefixes) {
      if (name.startsWith(prefix)) {
        name = name.substring(prefix.length).trim();
        break;
      }
    }
    return name;
  }

  static String judgeNamed(Judge judge, AppLocalizations l10n) {
    return l10n.courtJudgeNamed(judgeFamilyName(judge));
  }

  static String judgeSpecialty(Judge judge, AppLocalizations l10n) {
    switch (judge.specialtyKey) {
      case 'violence':
        return l10n.courtJudgeSpecialtyViolence;
      case 'financial':
        return l10n.courtJudgeSpecialtyFinancial;
      case 'drugs':
        return l10n.courtJudgeSpecialtyDrugs;
      case 'white_collar':
        return l10n.courtJudgeSpecialtyWhiteCollar;
      case 'organized':
        return l10n.courtJudgeSpecialtyOrganized;
      default:
        return judge.specialty.isNotEmpty ? judge.specialty : '';
    }
  }
}
