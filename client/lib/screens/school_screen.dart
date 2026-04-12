import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../providers/auth_provider.dart';
import '../services/api_client.dart';
import '../utils/formatters.dart';
import '../utils/top_right_notification.dart';
import '../widgets/cooldown_overlay.dart';

class SchoolScreen extends StatefulWidget {
  const SchoolScreen({super.key});

  @override
  State<SchoolScreen> createState() => _SchoolScreenState();
}

class _SchoolScreenState extends State<SchoolScreen> {
  String _formatCooldownSeconds(int seconds) {
    final localeName = AppLocalizations.of(context)?.localeName;
    return formatAdaptiveDurationFromSeconds(seconds, localeName: localeName);
  }

  final ApiClient _apiClient = ApiClient();

  bool _isLoading = true;
  String? _error;

  List<Map<String, dynamic>> _tracks = [];
  List<Map<String, dynamic>> _gates = [];
  Map<String, dynamic>? _profile;
  String? _trainingTrackId;
  String? _hoveredTrackId;
  String? _hoveredGateId;
  DateTime? _globalCooldownUntil;

  @override
  void initState() {
    super.initState();
    _loadSchoolData();
  }

  void _setGlobalCooldown(int seconds) {
    if (seconds <= 0) return;
    _globalCooldownUntil = DateTime.now().add(Duration(seconds: seconds));
  }

  int _remainingGlobalCooldownSeconds() {
    final until = _globalCooldownUntil;
    if (until == null) return 0;
    final remaining = until.difference(DateTime.now()).inSeconds;
    if (remaining <= 0) {
      _globalCooldownUntil = null;
      return 0;
    }
    return remaining;
  }

  Future<void> _loadSchoolData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final responses = await Future.wait([
        _apiClient.get('/education/tracks'),
        _apiClient.get('/education/gates'),
        _apiClient.get('/education/profile'),
      ]);

      final tracksData = jsonDecode(responses[0].body) as Map<String, dynamic>;
      final gatesData = jsonDecode(responses[1].body) as Map<String, dynamic>;
      final profileData = jsonDecode(responses[2].body) as Map<String, dynamic>;

      setState(() {
        _tracks = ((tracksData['tracks'] as List?) ?? const [])
            .whereType<Map>()
            .map((entry) => entry.cast<String, dynamic>())
            .toList(growable: false);

        _gates = ((gatesData['gates'] as List?) ?? const [])
            .whereType<Map>()
            .map((entry) => entry.cast<String, dynamic>())
            .toList(growable: false);

        _profile = (profileData['profile'] as Map?)?.cast<String, dynamic>();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  int _trackLevel(String trackId) {
    final tracksMap =
        (_profile?['tracks'] as Map?)?.cast<String, dynamic>() ??
        <String, dynamic>{};
    final trackData =
        (tracksMap[trackId] as Map?)?.cast<String, dynamic>() ??
        <String, dynamic>{};
    return (trackData['level'] as num?)?.toInt() ?? 0;
  }

  int _trackXp(String trackId) {
    final tracksMap =
        (_profile?['tracks'] as Map?)?.cast<String, dynamic>() ??
        <String, dynamic>{};
    final trackData =
        (tracksMap[trackId] as Map?)?.cast<String, dynamic>() ??
        <String, dynamic>{};
    return (trackData['xp'] as num?)?.toInt() ?? 0;
  }

  bool _hasCertification(String certificationId) {
    final certifications = ((_profile?['certifications'] as List?) ?? const [])
        .map((entry) => entry.toString())
        .toSet();
    return certifications.contains(certificationId);
  }

  Future<void> _trainTrack(Map<String, dynamic> track, int playerRank) async {
    final l10n = AppLocalizations.of(context)!;
    final trackId = track['id']?.toString() ?? '';
    final trackName = track['name']?.toString() ?? trackId;
    final minPlayerRank = (track['minPlayerRank'] as num?)?.toInt() ?? 1;

    if (trackId.isEmpty) {
      return;
    }

    final globalCooldown = _remainingGlobalCooldownSeconds();
    if (globalCooldown > 0) {
      if (!mounted) return;
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(
            '${l10n.cooldown}: ${_formatCooldownSeconds(globalCooldown)}',
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (playerRank < minPlayerRank) {
      if (!mounted) return;
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text('${l10n.requiredRank}: $minPlayerRank'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _trainingTrackId = trackId;
    });

    try {
      final response = await _apiClient.post(
        '/education/tracks/$trackId/train',
        {},
      );
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final params =
          (data['params'] as Map?)?.cast<String, dynamic>() ??
          <String, dynamic>{};

      if (!mounted) return;

      if (response.statusCode == 200) {
        final xpGain = (params['xpGain'] as num?)?.toInt() ?? 0;
        final levelUps = (params['levelUps'] as num?)?.toInt() ?? 0;
        final certificationsEarned =
            ((params['certificationsEarned'] as List?) ?? const []).length;

        final bonusParts = <String>[];
        if (levelUps > 0) {
          bonusParts.add('+$levelUps Lv');
        }
        if (certificationsEarned > 0) {
          bonusParts.add('+$certificationsEarned cert');
        }

        final suffix = bonusParts.isNotEmpty
            ? ' (${bonusParts.join(', ')})'
            : '';
        final cooldownSeconds =
            (params['cooldownSeconds'] as num?)?.toInt() ?? 0;

        if (cooldownSeconds > 0) {
          _setGlobalCooldown(cooldownSeconds);
        }

        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(
              '$trackName: +$xpGain XP$suffix · ${l10n.cooldown} ${_formatCooldownSeconds(cooldownSeconds)}',
            ),
            backgroundColor: Colors.green,
          ),
        );

        await _loadSchoolData();
      } else {
        final reason = params['reason']?.toString() ?? 'UNKNOWN';
        String message;
        if (reason == 'TRACK_RANK_TOO_LOW') {
          final requiredRank =
              (params['requiredRank'] as num?)?.toInt() ?? minPlayerRank;
          message = '${l10n.requiredRank}: $requiredRank';
        } else if (reason == 'TRACK_ON_COOLDOWN') {
          final remaining = (params['remainingSeconds'] as num?)?.toInt() ?? 0;
          _setGlobalCooldown(remaining);
          message = '${l10n.cooldown}: ${_formatCooldownSeconds(remaining)}';
        } else if (reason == 'TRACK_MAX_LEVEL_REACHED') {
          message = l10n.schoolTrackMaxLevelReached;
        } else {
          message = l10n.schoolTrackStartFailed;
        }

        showTopRightFromSnackBar(
          context,
          SnackBar(content: Text(message), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (!mounted) return;
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(l10n.connectionError(e.toString())),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _trainingTrackId = null;
        });
      }
    }
  }

  String _certDisplayName(String certificationId, AppLocalizations l10n) {
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

  String _trackDisplayName(
    String trackId,
    String fallback,
    AppLocalizations l10n,
  ) {
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
        return fallback;
    }
  }

  String _trackInfoText(
    String trackId,
    String fallback,
    AppLocalizations l10n,
  ) {
    switch (trackId) {
      case 'aviation':
        return l10n.schoolTrackDescriptionAviation;
      case 'law':
        return l10n.schoolTrackDescriptionLaw;
      case 'medicine':
        return l10n.schoolTrackDescriptionMedicine;
      case 'finance':
        return l10n.schoolTrackDescriptionFinance;
      case 'engineering':
        return l10n.schoolTrackDescriptionEngineering;
      case 'it':
        return l10n.schoolTrackDescriptionIt;
      default:
        return fallback;
    }
  }

  List<String> _gateMissingReasons(
    Map<String, dynamic> gate,
    int playerRank,
    AppLocalizations l10n,
  ) {
    final requirements =
        (gate['requirements'] as Map?)?.cast<String, dynamic>() ??
        <String, dynamic>{};
    final missing = <String>[];

    final trackId = requirements['trackId']?.toString();
    final requiredLevel = (requirements['level'] as num?)?.toInt();
    if (trackId != null && requiredLevel != null) {
      final currentLevel = _trackLevel(trackId);
      if (currentLevel < requiredLevel) {
        missing.add(
          l10n.educationRequirementTrackLevelProgress(
            trackId.toUpperCase(),
            requiredLevel,
            currentLevel,
          ),
        );
      }
    }

    final certs = ((requirements['certifications'] as List?) ?? const [])
        .map((entry) => entry.toString())
        .toList(growable: false);

    for (final certId in certs) {
      if (!_hasCertification(certId)) {
        final certName = _certDisplayName(certId, l10n);
        missing.add(
          '${l10n.educationRequirementCertificationTitle}: $certName',
        );
      }
    }

    return missing;
  }

  int _schoolOverallLevel() {
    if (_tracks.isEmpty) return 0;

    var maxLevel = 0;
    for (final track in _tracks) {
      final trackId = track['id']?.toString() ?? '';
      maxLevel = _trackLevel(trackId) > maxLevel
          ? _trackLevel(trackId)
          : maxLevel;
    }
    return maxLevel;
  }

  bool _gateUnlocked(Map<String, dynamic> gate, int playerRank) {
    final requirements =
        (gate['requirements'] as Map?)?.cast<String, dynamic>() ??
        <String, dynamic>{};

    final trackId = requirements['trackId']?.toString();
    final requiredLevel = (requirements['level'] as num?)?.toInt();
    if (trackId != null &&
        requiredLevel != null &&
        _trackLevel(trackId) < requiredLevel) {
      return false;
    }

    final requiredCerts =
        ((requirements['certifications'] as List?) ?? const [])
            .map((entry) => entry.toString())
            .toList(growable: false);
    for (final cert in requiredCerts) {
      if (!_hasCertification(cert)) {
        return false;
      }
    }

    return true;
  }

  String _gateTargetLabel(String targetType, String targetId) {
    final l10n = AppLocalizations.of(context)!;

    if (targetType == 'job') {
      return l10n.schoolGateJobTarget(targetId);
    }

    if (targetType == 'asset') {
      switch (targetId) {
        case 'casino_purchase':
          return l10n.schoolGateAssetCasinoPurchase;
        case 'ammo_factory_purchase':
          return l10n.schoolGateAssetAmmoFactoryPurchase;
        case 'ammo_factory_upgrade_output':
          return l10n.schoolGateAssetAmmoOutputUpgrade;
        case 'ammo_factory_upgrade_quality':
          return l10n.schoolGateAssetAmmoQualityUpgrade;
        default:
          return l10n.schoolGateAssetGeneric(targetId);
      }
    }

    return l10n.schoolGateSystemGeneric(targetType, targetId);
  }

  String _trackImageAsset(String trackId) {
    return 'assets/images/school/tracks/${trackId}_track.png';
  }

  String _gateImageAsset(String targetType, String targetId) {
    if (targetType == 'job') {
      return 'assets/images/school/gates/job_${targetId}_gate.png';
    }

    if (targetType == 'asset') {
      return 'assets/images/school/gates/asset_${targetId}_gate.png';
    }

    return 'assets/images/school/gates/system_${targetType}_${targetId}_gate.png';
  }

  String _trackFallbackEmoji(String trackId) {
    switch (trackId) {
      case 'aviation':
        return '✈️';
      case 'law':
        return '⚖️';
      case 'medicine':
        return '🩺';
      case 'finance':
        return '💹';
      case 'engineering':
        return '🛠️';
      case 'it':
        return '💻';
      default:
        return '🎓';
    }
  }

  String _gateFallbackEmoji(String targetType, String targetId) {
    if (targetType == 'job') {
      switch (targetId) {
        case 'programmer':
          return '💻';
        case 'lawyer':
          return '⚖️';
        case 'doctor':
          return '🩺';
        case 'airline_pilot':
          return '✈️';
        default:
          return '💼';
      }
    }

    if (targetType == 'asset') {
      switch (targetId) {
        case 'casino_purchase':
          return '🎰';
        case 'ammo_factory_purchase':
          return '🏭';
        case 'ammo_factory_upgrade_output':
        case 'ammo_factory_upgrade_quality':
          return '⚙️';
        default:
          return '📦';
      }
    }

    return '🔓';
  }

  Widget _buildTrackTile(Map<String, dynamic> track, int playerRank) {
    final l10n = AppLocalizations.of(context)!;
    final trackId = track['id']?.toString() ?? '';
    final trackNameRaw = track['name']?.toString() ?? trackId;
    final trackDescriptionRaw = track['description']?.toString() ?? '';
    final trackName = _trackDisplayName(trackId, trackNameRaw, l10n);
    final trackInfoText = _trackInfoText(trackId, trackDescriptionRaw, l10n);
    final minPlayerRank = (track['minPlayerRank'] as num?)?.toInt() ?? 1;
    final trackUnlockedByRank = playerRank >= minPlayerRank;
    final isTraining = _trainingTrackId == trackId;
    final remainingCooldownSeconds = _remainingGlobalCooldownSeconds();
    final isOnCooldown = remainingCooldownSeconds > 0;
    final maxLevel = (track['maxLevel'] as num?)?.toInt() ?? 5;
    final currentLevel = _trackLevel(trackId);
    final currentXp = _trackXp(trackId);
    final imageAsset = _trackImageAsset(trackId);
    final fallbackEmoji = _trackFallbackEmoji(trackId);
    final isHovered = _hoveredTrackId == trackId;

    final progress = maxLevel <= 0
        ? 0.0
        : (currentLevel / maxLevel).clamp(0.0, 1.0);

    final certifications = ((track['certifications'] as List?) ?? const [])
        .whereType<Map>()
        .map((entry) => entry.cast<String, dynamic>())
        .toList(growable: false);

    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredTrackId = trackId),
      onExit: (_) => setState(() => _hoveredTrackId = null),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: isHovered
              ? [
                  BoxShadow(
                    color: const Color(0xFFFFC107).withOpacity(0.22),
                    blurRadius: 10,
                    spreadRadius: 0,
                    offset: const Offset(0, 1),
                  ),
                ]
              : const [],
        ),
        child: Card(
          elevation: isHovered ? 4 : 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: isHovered
                  ? const Color(0xFFFFC107).withOpacity(0.75)
                  : Colors.transparent,
              width: isHovered ? 1.2 : 0,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: (!trackUnlockedByRank || isTraining || isOnCooldown)
                ? null
                : () => _trainTrack(track, playerRank),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 128,
                  width: double.infinity,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        imageAsset,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Container(
                          color: Colors.blueGrey[900]?.withOpacity(0.8),
                          alignment: Alignment.center,
                          child: Text(
                            fallbackEmoji,
                            style: const TextStyle(fontSize: 30),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.08),
                              Colors.black.withOpacity(0.65),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.55),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: const Color(0xFFFFC107).withOpacity(0.7),
                            ),
                          ),
                          child: Text(
                            l10n.schoolTrackLevelLabel(currentLevel, maxLevel),
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      if (!trackUnlockedByRank)
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.62),
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(
                                color: const Color(
                                  0xFFFFC107,
                                ).withOpacity(0.75),
                              ),
                            ),
                            child: Text(
                              '${l10n.requiredRank}: $minPlayerRank',
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                trackName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Tooltip(
                              message: trackInfoText,
                              preferBelow: false,
                              child: const Icon(
                                Icons.info_outline,
                                size: 16,
                                color: Color(0xFFFFC107),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (!trackUnlockedByRank)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(
                              '${l10n.requiredRank}: $minPlayerRank',
                              style: const TextStyle(
                                color: Colors.orangeAccent,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(999),
                          child: LinearProgressIndicator(
                            minHeight: 8,
                            value: progress,
                            backgroundColor: Colors.blueGrey[800],
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xFFFFC107),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.schoolXpLabel(currentXp),
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[300],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 5,
                          runSpacing: 5,
                          children: certifications
                              .map((cert) {
                                final certId = cert['id']?.toString() ?? '';
                                final certName =
                                    cert['name']?.toString() ?? certId;
                                final requiredLevel =
                                    (cert['requiredLevel'] as num?)?.toInt() ??
                                    0;
                                final unlocked = _hasCertification(certId);

                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 7,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: unlocked
                                        ? Colors.green.withOpacity(0.18)
                                        : Colors.blueGrey[900]?.withOpacity(
                                            0.55,
                                          ),
                                    borderRadius: BorderRadius.circular(999),
                                    border: Border.all(
                                      color: unlocked
                                          ? Colors.green.withOpacity(0.55)
                                          : const Color(
                                              0xFFFFC107,
                                            ).withOpacity(0.45),
                                    ),
                                  ),
                                  child: Text(
                                    unlocked
                                        ? '✓ $certName'
                                        : l10n.schoolCertificationRequiredLevel(
                                            certName,
                                            requiredLevel,
                                          ),
                                    style: TextStyle(
                                      fontSize: 9,
                                      color: unlocked
                                          ? Colors.greenAccent
                                          : Colors.grey[300],
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                );
                              })
                              .toList(growable: false),
                        ),
                        if (isTraining || isOnCooldown) ...[
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                isTraining ? Icons.hourglass_top : Icons.timer,
                                size: 14,
                                color: const Color(0xFFFFC107),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  isTraining
                                      ? l10n.loading
                                      : '${l10n.cooldown} ${_formatCooldownSeconds(remainingCooldownSeconds)}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFFFFC107),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGateTile(Map<String, dynamic> gate, int playerRank) {
    final l10n = AppLocalizations.of(context)!;
    final targetType = gate['targetType']?.toString() ?? '';
    final targetId = gate['targetId']?.toString() ?? '';
    final requirements =
        (gate['requirements'] as Map?)?.cast<String, dynamic>() ??
        <String, dynamic>{};

    final unlocked = _gateUnlocked(gate, playerRank);
    final imageAsset = _gateImageAsset(targetType, targetId);
    final fallbackEmoji = _gateFallbackEmoji(targetType, targetId);
    final trackId = requirements['trackId']?.toString();
    final requiredLevel = (requirements['level'] as num?)?.toInt();
    final certs = ((requirements['certifications'] as List?) ?? const [])
        .map((entry) => entry.toString())
        .toList(growable: false);
    final missingReasons = _gateMissingReasons(gate, playerRank, l10n);
    final gateId = gate['id']?.toString() ?? '${targetType}_$targetId';
    final isHovered = _hoveredGateId == gateId;

    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredGateId = gateId),
      onExit: (_) => setState(() => _hoveredGateId = null),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: isHovered
              ? [
                  BoxShadow(
                    color: const Color(0xFFFFC107).withOpacity(0.22),
                    blurRadius: 10,
                    spreadRadius: 0,
                    offset: const Offset(0, 1),
                  ),
                ]
              : const [],
        ),
        child: Card(
          elevation: isHovered ? 4 : 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: isHovered
                  ? const Color(0xFFFFC107).withOpacity(0.75)
                  : Colors.transparent,
              width: isHovered ? 1.2 : 0,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 112,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      imageAsset,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Container(
                        color: Colors.blueGrey[900]?.withOpacity(0.8),
                        alignment: Alignment.center,
                        child: Text(
                          fallbackEmoji,
                          style: const TextStyle(fontSize: 28),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.1),
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Icon(
                        unlocked ? Icons.lock_open : Icons.lock,
                        color: unlocked
                            ? Colors.greenAccent
                            : const Color(0xFFFFC107),
                        size: 18,
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Text(
                        unlocked
                            ? l10n.schoolGateStatusOpen
                            : l10n.schoolGateStatusLocked,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: unlocked
                              ? Colors.greenAccent
                              : const Color(0xFFFFC107),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 10,
                      right: 10,
                      bottom: 8,
                      child: Text(
                        _gateTargetLabel(targetType, targetId),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (trackId != null && requiredLevel != null)
                        Text(
                          l10n.schoolGateTrackLevelProgress(
                            trackId.toUpperCase(),
                            _trackLevel(trackId),
                            requiredLevel,
                          ),
                          style: TextStyle(
                            color: Colors.grey[300],
                            fontSize: 12,
                          ),
                        ),
                      if (certs.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: certs
                                .map((certId) {
                                  final hasCert = _hasCertification(certId);
                                  final certName = _certDisplayName(
                                    certId,
                                    l10n,
                                  );
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: hasCert
                                          ? Colors.green.withOpacity(0.18)
                                          : Colors.blueGrey[900]?.withOpacity(
                                              0.6,
                                            ),
                                      borderRadius: BorderRadius.circular(999),
                                      border: Border.all(
                                        color: hasCert
                                            ? Colors.green.withOpacity(0.55)
                                            : const Color(
                                                0xFFFFC107,
                                              ).withOpacity(0.45),
                                      ),
                                    ),
                                    child: Text(
                                      hasCert ? '✓ $certName' : certName,
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: hasCert
                                            ? Colors.greenAccent
                                            : Colors.grey[300],
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  );
                                })
                                .toList(growable: false),
                          ),
                        ),
                      if (!unlocked && missingReasons.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: missingReasons
                                .map(
                                  (reason) => Padding(
                                    padding: const EdgeInsets.only(bottom: 4),
                                    child: Text(
                                      '• $reason',
                                      style: const TextStyle(
                                        color: Colors.orangeAccent,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(growable: false),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authProvider = Provider.of<AuthProvider>(context);
    final playerRank = authProvider.currentPlayer?.rank ?? 1;
    final schoolLevel = _schoolOverallLevel();
    final globalCooldownSeconds = _remainingGlobalCooldownSeconds();

    if (globalCooldownSeconds > 0) {
      return CooldownOverlay(
        embedded: kIsWeb,
        actionType: 'school',
        remainingSeconds: globalCooldownSeconds,
        onExpired: () {
          if (!mounted) return;
          setState(() {
            _globalCooldownUntil = null;
          });
          _loadSchoolData();
        },
      );
    }

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            l10n.schoolLoadError(_error!),
            style: const TextStyle(color: Colors.redAccent),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/backgrounds/ammo_factory_bg.png'),
          fit: BoxFit.cover,
          opacity: 0.25,
        ),
      ),
      child: RefreshIndicator(
        onRefresh: _loadSchoolData,
        child: ListView(
          padding: const EdgeInsets.all(8),
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: const Color(0xFFFFC107).withOpacity(0.7),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    const Icon(
                      Icons.school,
                      color: Color(0xFFFFC107),
                      size: 24,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.schoolTitle,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l10n.schoolIntro,
                            style: TextStyle(
                              color: Colors.grey[300],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey[900]?.withOpacity(0.65),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: const Color(0xFFFFC107).withOpacity(0.55),
                        ),
                      ),
                      child: Text(
                        '${l10n.playerRankLabel} $playerRank',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey[900]?.withOpacity(0.65),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: const Color(0xFFFFC107).withOpacity(0.55),
                        ),
                      ),
                      child: Text(
                        l10n.schoolOverallLevelLabel(schoolLevel),
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              l10n.schoolTracksTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width < 480
                    ? 2
                    : MediaQuery.of(context).size.width < 900
                    ? 3
                    : 5,
                childAspectRatio: 0.78,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: _tracks.length,
              itemBuilder: (context, index) =>
                  _buildTrackTile(_tracks[index], playerRank),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.schoolUnlockableContentTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width < 480
                    ? 2
                    : MediaQuery.of(context).size.width < 900
                    ? 3
                    : 5,
                childAspectRatio: 0.82,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: _gates.length,
              itemBuilder: (context, index) =>
                  _buildGateTile(_gates[index], playerRank),
            ),
          ],
        ),
      ),
    );
  }
}
