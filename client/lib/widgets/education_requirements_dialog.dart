import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class EducationRequirementsDialog extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final List<dynamic> missingRequirements;

  const EducationRequirementsDialog({
    super.key,
    this.title,
    this.subtitle,
    required this.missingRequirements,
  });

  static Future<void> show(
    BuildContext context, {
    String? title,
    String? subtitle,
    required List<dynamic> missingRequirements,
  }) {
    return showDialog<void>(
      context: context,
      builder: (context) => EducationRequirementsDialog(
        title: title,
        subtitle: subtitle,
        missingRequirements: missingRequirements,
      ),
    );
  }

  String _trackName(String trackId, AppLocalizations l10n) {
    switch (trackId) {
      case 'aviation':
        return l10n.educationTrackNameAviation;
      case 'law':
        return l10n.educationTrackNameLaw;
      case 'medicine':
        return l10n.educationTrackNameMedicine;
      case 'finance':
        return l10n.educationTrackNameFinance;
      case 'engineering':
        return l10n.educationTrackNameEngineering;
      case 'it':
        return l10n.educationTrackNameIt;
      default:
        return trackId;
    }
  }

  String _certName(String certificationId, AppLocalizations l10n) {
    switch (certificationId) {
      case 'software_engineer':
        return l10n.educationCertSoftwareEngineer;
      case 'bar_exam':
        return l10n.educationCertBarExam;
      case 'medical_license':
        return l10n.educationCertMedicalLicense;
      case 'flight_commercial':
        return l10n.educationCertFlightCommercial;
      case 'flight_basic':
        return l10n.educationCertFlightBasic;
      case 'industrial_safety':
        return l10n.educationCertIndustrialSafety;
      case 'financial_analyst':
        return l10n.educationCertFinancialAnalyst;
      case 'casino_management':
        return l10n.educationCertCasinoManagement;
      case 'paramedic_cert':
        return l10n.educationCertParamedic;
      default:
        return certificationId;
    }
  }

  ({IconData icon, String title, String subtitle}) _formatRequirement(
    BuildContext context,
    Map<String, dynamic> requirement,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final code = requirement['code']?.toString() ?? '';
    final params =
        (requirement['params'] as Map?)?.cast<String, dynamic>() ??
        <String, dynamic>{};

    if (code == 'RANK_REQUIRED') {
      final requiredRank = (params['requiredRank'] as num?)?.toInt() ?? 0;
      final currentRank = (params['currentRank'] as num?)?.toInt() ?? 0;
      return (
        icon: Icons.workspace_premium,
        title: l10n.requiredRank,
        subtitle: l10n.educationRequirementRankProgress(
          requiredRank,
          currentRank,
        ),
      );
    }

    if (code == 'TRACK_LEVEL_REQUIRED') {
      final trackId = params['trackId']?.toString() ?? '';
      final requiredLevel = (params['requiredLevel'] as num?)?.toInt() ?? 0;
      final currentLevel = (params['currentLevel'] as num?)?.toInt() ?? 0;
      final trackName = _trackName(trackId, l10n);
      return (
        icon: Icons.school,
        title: l10n.educationRequirementTrackLevelTitle,
        subtitle: l10n.educationRequirementTrackLevelProgress(
          trackName,
          requiredLevel,
          currentLevel,
        ),
      );
    }

    if (code == 'CERTIFICATION_REQUIRED') {
      final certificationId = params['certificationId']?.toString() ?? '';
      final certName = _certName(certificationId, l10n);
      return (
        icon: Icons.verified,
        title: l10n.educationRequirementCertificationTitle,
        subtitle: certName,
      );
    }

    return (
      icon: Icons.info,
      title: l10n.educationRequirementGenericTitle,
      subtitle:
          requirement['reasonKey']?.toString() ??
          l10n.educationRequirementUnknown,
    );
  }

  Widget _buildRequirementTile(
    BuildContext context,
    Map<String, dynamic> requirement,
  ) {
    final formatted = _formatRequirement(context, requirement);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.blueGrey[900]?.withOpacity(0.65),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFFFFC107).withOpacity(0.75),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(formatted.icon, color: const Color(0xFFFFC107), size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  formatted.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  formatted.subtitle,
                  style: TextStyle(color: Colors.grey[300], fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final safeList = missingRequirements
        .whereType<Map>()
        .map((e) => e.cast<String, dynamic>())
        .toList(growable: false);

    return AlertDialog(
      backgroundColor: Colors.grey[900],
      title: Text(
        title ?? l10n.educationDialogDefaultTitle,
        style: const TextStyle(color: Colors.white),
      ),
      content: SizedBox(
        width: 460,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (subtitle != null && subtitle!.trim().isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  subtitle!,
                  style: TextStyle(color: Colors.grey[300], fontSize: 12),
                ),
              ),
            if (safeList.isEmpty)
              Text(
                l10n.educationDialogFallbackMessage,
                style: TextStyle(color: Colors.grey[300]),
              )
            else
              ...safeList.map(
                (requirement) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _buildRequirementTile(context, requirement),
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.educationDialogClose),
        ),
      ],
    );
  }
}
