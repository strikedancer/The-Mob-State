import '../l10n/app_localizations.dart';
import '../utils/country_helper.dart';

/// Renders backend event stream keys with [AppLocalizations] (all player locales).
class EventRenderer {
  final AppLocalizations l10n;

  EventRenderer(this.l10n);

  String _travelCountryLabel(Map<String, dynamic> params) {
    final raw = params['country'] ??
        params['toCountry'] ??
        params['destination'] ??
        params['destinationCountry'];
    final code = raw?.toString().trim() ?? '';
    if (code.isEmpty) return '—';
    return CountryHelper.getLocalizedCountryName(code, l10n, fallbackName: code);
  }

  String renderEvent(String eventKey, Map<String, dynamic> params) {
    switch (eventKey) {
      case 'connection.established':
        return l10n.evStreamConnectionEstablished;
      case 'auth.registered':
        return l10n.evStreamAuthRegistered;
      case 'auth.login':
        return l10n.evStreamAuthLogin;

      case 'crime.success':
        return _crimeSuccess(params);
      case 'crime.failed':
        return _crimeFailed(params);
      case 'crime.jailed':
      case 'crime.caught':
        return _crimeJailedShort(params);

      case 'job.completed':
      case 'job.success':
        return _jobSuccess(params);
      case 'job.failed':
        return _jobFailed(params);
      case 'job.error':
        return _jobError(params);

      case 'travel.departed':
      case 'travel.journey_started':
        return l10n.evStreamTravelDeparted(
          _travelCountryLabel(params),
          '${params['cost'] ?? params['travelCost'] ?? 0}',
        );
      case 'travel.arrived':
      case 'travel.journey_complete':
      case 'travel.leg_completed':
        return l10n.evStreamTravelArrived(_travelCountryLabel(params));

      case 'bank.deposit':
        return l10n.evStreamBankDeposit('${params['amount'] ?? 0}');
      case 'bank.withdraw':
        return l10n.evStreamBankWithdraw('${params['amount'] ?? 0}');

      case 'crypto.buy':
        return l10n.evStreamCryptoBuy(
          _fmt(_asNumber(params['quantity']), 8),
          params['symbol']?.toString() ?? '—',
          _fmt(_asNumber(params['totalCost']), 2),
        );
      case 'crypto.sell':
        return l10n.evStreamCryptoSell(
          _fmt(_asNumber(params['quantity']), 8),
          params['symbol']?.toString() ?? '—',
          _fmt(_asNumber(params['totalValue']), 2),
          _fmt(_asNumber(params['realizedProfit']), 2),
        );
      case 'crypto.alert.price':
        return l10n.evStreamCryptoAlert(
          params['symbol']?.toString() ?? '—',
          _fmt(_asNumber(params['currentPrice']), 8),
          _fmt(_asNumber(params['changePct']), 2),
        );
      case 'crypto.order.filled':
        return l10n.evStreamCryptoOrderFilled(
          params['orderType']?.toString() ?? 'LIMIT',
          params['side']?.toString() ?? 'BUY',
          _fmt(_asNumber(params['quantity']), 8),
          params['symbol']?.toString() ?? '—',
          _fmt(_asNumber(params['fillPrice']), 8),
        );
      case 'crypto.order.triggered':
        return l10n.evStreamCryptoOrderTriggered(
          params['triggerType']?.toString() ?? 'STOP_LOSS',
          params['symbol']?.toString() ?? '—',
          _fmt(_asNumber(params['triggerPrice']), 8),
        );
      case 'crypto.market.regime':
        final regime = params['regime']?.toString() ?? 'SIDEWAYS';
        return l10n.evStreamCryptoRegime(
          _regimeLabel(regime),
          _fmt(_asNumber(params['marketMovePct']), 2),
        );
      case 'crypto.market.news':
        return l10n.evStreamCryptoNews(
          _impactLabel(params['impact']?.toString() ?? 'NEUTRAL'),
          params['headline']?.toString() ?? '—',
        );
      case 'crypto.mission.completed':
        final missionType = params['missionType']?.toString() ?? 'DAILY';
        final title = params['missionTitle']?.toString() ?? '—';
        final reward = _fmt(_asNumber(params['rewardMoney']), 2);
        return missionType == 'WEEKLY'
            ? l10n.evStreamCryptoMissionWeekly(title, reward)
            : l10n.evStreamCryptoMissionDaily(title, reward);
      case 'crypto.leaderboard.reward':
        return l10n.evStreamCryptoLeaderboard(
          params['rank']?.toString() ?? '—',
          _fmt(_asNumber(params['rewardMoney']), 2),
        );

      case 'property.purchased':
        return l10n.evStreamPropertyBought(
          params['propertyName']?.toString() ?? '—',
          '${params['cost'] ?? 0}',
        );

      case 'crew.created':
        return l10n.evStreamCrewCreated(
          params['crewName']?.toString() ?? '—',
        );
      case 'crew.joined':
        return l10n.evStreamCrewJoined(
          params['crewName']?.toString() ?? '—',
        );
      case 'crew.war_declared':
        return l10n.evStreamCrewWarDeclared(
          params['attackerCrewId']?.toString() ?? '—',
          params['defenderCrewId']?.toString() ?? '—',
          params['warType']?.toString() ?? '—',
        );
      case 'crew.war_started':
        return l10n.evStreamCrewWarStarted(
          params['attackerCrewId']?.toString() ?? '—',
          params['defenderCrewId']?.toString() ?? '—',
        );
      case 'crew.war_lockdown':
        return l10n.evStreamCrewLockdown(
          params['warId']?.toString() ?? '—',
        );
      case 'crew.war_resolved':
        return l10n.evStreamCrewResolved(
          params['warId']?.toString() ?? '—',
          params['winnerCrewId']?.toString() ?? '—',
        );
      case 'crew.war_action':
        return l10n.evStreamCrewAction(
          params['actionType']?.toString() ?? 'action',
          params['pointsAwarded']?.toString() ?? '0',
        );

      case 'heist.success':
        return l10n.evStreamHeistOk(
          params['heistName']?.toString() ?? '—',
          '${params['money'] ?? 0}',
        );
      case 'heist.failed':
        return l10n.evStreamHeistFail(
          params['heistName']?.toString() ?? '—',
        );

      case 'hospital.healed':
        return l10n.evStreamHospital(
          '${params['healthGained'] ?? 0}',
          '${params['cost'] ?? 0}',
        );

      case 'police.arrested':
        return l10n.evStreamPoliceArrested('${params['jailTime'] ?? 0}');
      case 'police.escaped':
        return l10n.evStreamPoliceEscaped;
      case 'fbi.raided':
        return l10n.evStreamFbiRaid;

      case 'error.insufficient_funds':
        return l10n.evStreamErrInsufficientFunds;
      case 'error.insufficient_health':
        return l10n.evStreamErrInsufficientHealth;
      case 'error.insufficient_rank':
        return l10n.evStreamErrInsufficientRank('${params['requiredRank'] ?? 0}');
      case 'error.jailed':
        return l10n.evStreamErrJailed(
          (() {
            final t = (params['remainingTime'] as num?)?.toInt() ?? 0;
            if (t <= 0) {
              return 0;
            }
            return (t / 60).ceil();
          })(),
        );
      case 'error.noHealth':
        final m = params['message'] as String?;
        if (m != null && m.isNotEmpty) {
          return m;
        }
        return l10n.evStreamErrNoHealthDefault;

      case 'crime.error':
        return _crimeError(params);
      case 'error.cooldown':
        return l10n.evStreamErrCooldown(
          (params['remainingSeconds'] as int?) ?? 0,
        );
      case 'error.rescuer_jailed':
        return l10n.evStreamErrRescuerJailed;
      case 'error.target_not_jailed':
        return l10n.evStreamErrTargetNotJailed;
      case 'error.cannot_rescue_self':
        return l10n.evStreamErrCannotRescueSelf;

      case 'jailbreak.success':
        return l10n.evStreamJailbreakOk;
      case 'jailbreak.failed':
        return l10n.evStreamJailbreakFail;
      case 'jailbreak.caught':
        return l10n.evStreamJailbreakCaught(
          '${(params['rescuerJailTime'] as int?) ?? 0}',
        );
      case 'bail.paid':
        return l10n.evStreamBailPaid('${params['amount'] ?? 0}');
      case 'error.internal':
        return l10n.evStreamErrInternal;
      case 'test.broadcast':
        return l10n.evStreamTest(
          params['message']?.toString() ?? '—',
        );

      default:
        return l10n.evStreamUnknownKey(eventKey);
    }
  }

  String _withActor(Map<String, dynamic> params, String message) {
    final username = params['username']?.toString().trim();
    if (username == null || username.isEmpty) return message;
    return l10n.evStreamActorPrefix(username, message);
  }

  String _crimeSuccess(Map<String, dynamic> params) {
    final reward = (params['reward'] as num?)?.toInt() ?? 0;
    final xpGained = (params['xpGained'] as num?)?.toInt() ?? 0;
    final crimeName = params['crimeName']?.toString() ?? '—';
    final jailed = params['jailed'] as bool? ?? false;
    final jailTime = (params['jailTime'] as num?)?.toInt();
    final vehicleConfiscated = params['vehicleConfiscated'] as bool? ?? false;
    final weaponConfiscated = params['weaponConfiscated'] as bool? ?? false;
    final clearedRecordCount = (params['clearedRecordCount'] as num?)?.toInt() ?? 0;

    if (jailed && jailTime != null && jailTime > 0) {
      var s = l10n.evStreamCrimeSuccessJailed(
        crimeName,
        reward.toString(),
        xpGained.toString(),
        jailTime,
      );
      if (vehicleConfiscated) {
        s += l10n.evStreamCrimeSeizedVehicle;
      }
      if (weaponConfiscated) {
        s += l10n.evStreamCrimeSeizedWeapon;
      }
      return _withActor(params, s);
    }
    if (clearedRecordCount > 0) {
      return _withActor(
        params,
        l10n.evStreamCrimeSuccessCleared(
          crimeName,
          clearedRecordCount,
          xpGained.toString(),
        ),
      );
    }
    return _withActor(
      params,
      l10n.evStreamCrimeSuccess(
        crimeName,
        reward.toString(),
        xpGained.toString(),
      ),
    );
  }

  String _crimeFailed(Map<String, dynamic> params) {
    final crimeName = params['crimeName']?.toString() ?? '—';
    final jailed = params['jailed'] as bool? ?? false;
    final jailTime = (params['jailTime'] as num?)?.toInt();
    final arrested = params['arrested'] as bool? ?? false;
    final vehicleConfiscated = params['vehicleConfiscated'] as bool? ?? false;
    final weaponConfiscated = params['weaponConfiscated'] as bool? ?? false;
    final vehicleChaseDamage = (params['vehicleChaseDamage'] as num?)?.toInt();

    String message;
    if (arrested && params['arrestingAuthority'] != null) {
      final auth = params['arrestingAuthority']?.toString() ?? 'police';
      final authority = auth == 'FBI' ? 'FBI' : auth;
      message = l10n.evStreamCrimeFailedArrested(authority, crimeName);
    } else if (jailed && jailTime != null && jailTime > 0) {
      message = l10n.evStreamCrimeFailedJailed(crimeName, jailTime);
    } else {
      message = l10n.evStreamCrimeFailedBase(crimeName);
    }
    if (vehicleConfiscated) {
      message += l10n.evStreamCrimeSeizedVehicle;
    } else if (vehicleChaseDamage != null && vehicleChaseDamage > 0) {
      message += l10n.evStreamChaseDamage(vehicleChaseDamage.toString());
    }
    if (weaponConfiscated) {
      message += l10n.evStreamCrimeSeizedWeapon;
    }
    return message;
  }

  String _crimeJailedShort(Map<String, dynamic> params) {
    final crimeName = params['crimeName']?.toString() ?? '—';
    final minutes = (params['jailTime'] as num?)?.toInt() ?? 0;
    return l10n.evStreamCrimeJailed(crimeName, minutes);
  }

  String _jobSuccess(Map<String, dynamic> params) {
    final jobName = params['jobName'] as String? ??
        params['jobId'] as String? ??
        l10n.evStreamJobFallbackName;
    final earnings = '${params['earnings'] ?? 0}';
    final xpGained = '${params['xpGained'] ?? 0}';
    final educationBonusPercent =
        (params['educationBonusPercent'] as num?)?.toInt() ?? 0;
    var base = l10n.evStreamJobSuccess(jobName, earnings, xpGained);
    if (educationBonusPercent > 0) {
      base += l10n.evStreamJobSuccessEdu(educationBonusPercent.toString());
    }
    return _withActor(params, base);
  }

  String _jobFailed(Map<String, dynamic> params) {
    final jobName = params['jobName'] as String? ??
        params['jobId'] as String? ??
        l10n.evStreamJobFallbackName;
    final xpLost = (params['xpLost'] as num?)?.toInt() ?? 0;
    if (xpLost > 0) {
      return l10n.evStreamJobFailedXp(jobName, xpLost.toString());
    }
    return l10n.evStreamJobFailed(jobName);
  }

  String _jobError(Map<String, dynamic> params) {
    final reason = params['reason'] as String?;
    final minutesRemaining = params['minutesRemaining'] as int?;
    switch (reason) {
      case 'INVALID_JOB_ID':
        return l10n.evStreamJobErrorInvalid;
      case 'LEVEL_TOO_LOW':
        return l10n.evStreamJobErrorLevel;
      case 'ON_COOLDOWN':
        return l10n.evStreamJobErrorCooldown(minutesRemaining ?? 0);
      default:
        return l10n.evStreamJobErrorGeneric(reason ?? 'unknown');
    }
  }

  String _crimeError(Map<String, dynamic> params) {
    final message = params['message'] as String?;
    if (message != null && message.isNotEmpty) {
      return message;
    }
    final reason = params['reason'] as String?;
    final useNlWeaponNames = l10n.localeName.toLowerCase().startsWith('nl');
    switch (reason) {
      case 'TOOL_REQUIRED':
        return l10n.crimeErrorToolRequired(
          params['tools'] as String? ?? 'tools',
        );
      case 'TOOL_IN_STORAGE':
        return l10n.crimeErrorToolInStorage(
          params['tools'] as String? ?? 'tools',
        );
      case 'VEHICLE_REQUIRED':
        return l10n.crimeErrorVehicleRequired;
      case 'VEHICLE_NOT_FOUND':
        return l10n.crimeErrorVehicleNotFound;
      case 'NOT_VEHICLE_OWNER':
        return l10n.crimeErrorNotVehicleOwner;
      case 'VEHICLE_BROKEN':
        return l10n.crimeErrorVehicleBroken;
      case 'NO_FUEL':
        return l10n.crimeErrorNoFuel;
      case 'LEVEL_TOO_LOW':
        return l10n.crimeErrorLevelTooLow;
      case 'NO_CRIMINAL_RECORD':
        return l10n.evStreamNoCriminalRecord;
      case 'INVALID_CRIME_ID':
        return l10n.crimeErrorInvalidCrimeId;
      case 'WEAPON_REQUIRED':
        return l10n.crimeErrorWeaponRequired;
      case 'WEAPON_SELECTION_REQUIRED':
        return l10n.evStreamWeaponSelectRequired;
      case 'WEAPON_NOT_SUITABLE':
        final st = params['suitableTypes'] as String? ?? '';
        return l10n.evStreamWeaponNotSuitable(
          _weaponTypesList(st, useNlWeaponNames),
        );
      case 'WEAPON_BROKEN':
        return l10n.crimeErrorWeaponBroken;
      case 'NO_AMMO':
        return l10n.crimeErrorNoAmmo;
      case 'DRUGS_REQUIRED':
        final minDrugQuantity = (params['minDrugQuantity'] as num?)?.toInt() ?? 1;
        final requiredDrugs = (params['requiredDrugs'] as List<dynamic>?)
                ?.map((d) => d.toString().replaceAll('_', ' '))
                .join(', ') ??
            'drugs';
        return l10n.crimeErrorDrugsRequired(
          minDrugQuantity.toString(),
          requiredDrugs,
        );
      default:
        return l10n.crimeErrorGeneric;
    }
  }

  String _regimeLabel(String regime) {
    switch (regime.toUpperCase()) {
      case 'BULL':
        return l10n.evStreamRegimeBull;
      case 'BEAR':
        return l10n.evStreamRegimeBear;
      default:
        return l10n.evStreamRegimeSideways;
    }
  }

  String _impactLabel(String impact) {
    switch (impact.toUpperCase()) {
      case 'BULLISH':
        return l10n.evStreamImpactBull;
      case 'BEARISH':
        return l10n.evStreamImpactBear;
      default:
        return l10n.evStreamImpactNeutral;
    }
  }

  String _weaponTypesList(String types, bool dutch) {
    if (types.isEmpty) return '';
    const en = {
      'knife': 'knife',
      'handgun': 'handgun/pistol',
      'shotgun': 'shotgun',
      'rifle': 'rifle',
      'sniper': 'sniper rifle',
      'smg': 'submachine gun',
    };
    const nl = {
      'knife': 'mes',
      'handgun': 'pistool',
      'shotgun': 'jachtgeweer',
      'rifle': 'geweer',
      'sniper': 'sluipschuttersgeweer',
      'smg': 'automatisch pistool',
    };
    final m = dutch ? nl : en;
    final names = types
        .split(',')
        .map((t) => m[t.trim()] ?? t.trim())
        .toList();
    if (names.isEmpty) {
      return '';
    }
    if (names.length == 1) {
      return names[0];
    }
    if (names.length == 2) {
      return dutch
          ? '${names[0]} of ${names[1]}'
          : '${names[0]} or ${names[1]}';
    }
    final last = names.removeLast();
    final join = names.join(', ');
    return dutch ? '$join of $last' : '$join or $last';
  }

  static double _asNumber(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  String _fmt(double value, int decimals) => value.toStringAsFixed(decimals);
}
