import '../l10n/app_localizations.dart';

/// Service to render backend events with localized messages
/// Takes eventKey and params, returns user-friendly localized string
class EventRenderer {
  final AppLocalizations l10n;

  EventRenderer(this.l10n);

  /// Render an event with its parameters
  String renderEvent(String eventKey, Map<String, dynamic> params) {
    // Check locale and use appropriate language
    if (l10n.localeName == 'nl') {
      return _renderEventNL(eventKey, params);
    }
    return _renderEventEN(eventKey, params);
  }

  /// Render event with English localization
  String _renderEventEN(String eventKey, Map<String, dynamic> params) {
    // Return formatted string based on eventKey
    switch (eventKey) {
      // Connection events
      case 'connection.established':
        return 'Connected to event stream';

      // Auth events
      case 'auth.registered':
        return 'Account successfully created!';
      case 'auth.login':
        return 'Welcome back!';

      // Crime events
      case 'crime.success':
        final reward = params['reward'] as int?;
        final xpGained = params['xpGained'] as int?;
        final crimeName = params['crimeName'] as String?;
        final jailed = params['jailed'] as bool? ?? false;
        final jailTime = params['jailTime'] as int?; // in MINUTES

        if (jailed && jailTime != null && jailTime > 0) {
          final minutes = jailTime;
          return 'Successfully completed $crimeName! +EUR ${reward ?? 0}, +${xpGained ?? 0} XP - BUT CAUGHT! Jailed for $minutes minute${minutes != 1 ? 's' : ''}!';
        }
        return 'Successfully completed $crimeName! +EUR ${reward ?? 0}, +${xpGained ?? 0} XP';

      case 'crime.failed':
        final crimeName = params['crimeName'] as String?;
        final jailed = params['jailed'] as bool? ?? false;
        final jailTime = params['jailTime'] as int?; // in MINUTES
        final arrested = params['arrested'] as bool? ?? false;
        final arrestingAuthority = params['arrestingAuthority'] as String?;
        final vehicleConfiscated =
            params['vehicleConfiscated'] as bool? ?? false;
        final vehicleChaseDamage = params['vehicleChaseDamage'] as int?;

        String message = '';

        if (arrested && arrestingAuthority != null) {
          message =
              'Arrested by $arrestingAuthority during $crimeName attempt!';
        } else if (jailed && jailTime != null && jailTime > 0) {
          final minutes = jailTime;
          message =
              'Caught during $crimeName! Jailed for $minutes minute${minutes != 1 ? 's' : ''}!';
        } else {
          message = 'Failed to complete $crimeName';
        }

        // Add vehicle consequences
        if (vehicleConfiscated) {
          message += ' Your vehicle was seized by police!';
        } else if (vehicleChaseDamage != null && vehicleChaseDamage > 0) {
          message +=
              ' Your vehicle took $vehicleChaseDamage% damage during the chase!';
        }

        return message;

      case 'crime.jailed':
      case 'crime.caught':
        final crimeName = params['crimeName'] as String?;
        final jailTime = params['jailTime'] as int?; // in MINUTES
        final minutes = jailTime != null && jailTime > 0 ? jailTime : 0;
        return 'Caught during $crimeName! Jailed for $minutes minute${minutes != 1 ? 's' : ''}';

      // Job events
      case 'job.completed':
      case 'job.success':
        final earnings = params['earnings'] as int?;
        final xpGained = params['xpGained'] as int?;
        final jobName = params['jobName'] as String?;
        final jobId = params['jobId'] as String?;
        final educationBonusPercent =
            (params['educationBonusPercent'] as num?)?.toInt() ?? 0;
        final displayName = jobName ?? jobId ?? 'job';
        final baseMessage =
            'Completed work as $displayName! +€${earnings ?? 0}, +${xpGained ?? 0} XP';
        if (educationBonusPercent > 0) {
          return '$baseMessage (Education bonus +$educationBonusPercent%)';
        }
        return baseMessage;

      case 'job.failed':
        final jobName = params['jobName'] as String?;
        final jobId = params['jobId'] as String?;
        final xpLost = (params['xpLost'] as num?)?.toInt() ?? 0;
        final displayName = jobName ?? jobId ?? 'job';
        if (xpLost > 0) {
          return 'Failed to complete job as $displayName. -$xpLost XP';
        }
        return 'Failed to complete job as $displayName';

      case 'job.error':
        final reason = params['reason'] as String?;
        final minutesRemaining = params['minutesRemaining'] as int?;

        switch (reason) {
          case 'INVALID_JOB_ID':
            return 'Invalid job';
          case 'LEVEL_TOO_LOW':
            return 'Your rank is too low for this job';
          case 'ON_COOLDOWN':
            return 'This job is on cooldown. Wait ${minutesRemaining ?? 0} more minutes';
          default:
            return 'Job error: ${reason ?? 'unknown'}';
        }

      // Travel events
      case 'travel.departed':
        final destination = params['destination'] as String?;
        final cost = params['cost'] as int?;
        return 'Flying to $destination... -€${cost ?? 0}';

      case 'travel.arrived':
        final country = params['country'] as String?;
        return 'Arrived in $country!';

      // Bank events
      case 'bank.deposit':
        final amount = params['amount'] as int?;
        return 'Deposited €${amount ?? 0} to bank account';

      case 'bank.withdraw':
        final amount = params['amount'] as int?;
        return 'Withdrew €${amount ?? 0} from bank account';

      // Crypto events
      case 'crypto.buy':
        final symbol = params['symbol'] as String? ?? 'UNKNOWN';
        final quantity = _asNumber(params['quantity']);
        final totalCost = _asNumber(params['totalCost']);
        return 'Bought ${_fmt(quantity, 8)} $symbol for €${_fmt(totalCost, 2)}';

      case 'crypto.sell':
        final symbol = params['symbol'] as String? ?? 'UNKNOWN';
        final quantity = _asNumber(params['quantity']);
        final totalValue = _asNumber(params['totalValue']);
        final realizedProfit = _asNumber(params['realizedProfit']);
        return 'Sold ${_fmt(quantity, 8)} $symbol for €${_fmt(totalValue, 2)} (PnL €${_fmt(realizedProfit, 2)})';

      case 'crypto.alert.price':
        final symbol = params['symbol'] as String? ?? 'UNKNOWN';
        final currentPrice = _asNumber(params['currentPrice']);
        final changePct = _asNumber(params['changePct']);
        return '$symbol alert: €${_fmt(currentPrice, 8)} (${_fmt(changePct, 2)}% 24h)';

      case 'crypto.order.filled':
        final symbol = params['symbol'] as String? ?? 'UNKNOWN';
        final orderType = params['orderType'] as String? ?? 'LIMIT';
        final side = params['side'] as String? ?? 'BUY';
        final quantity = _asNumber(params['quantity']);
        final fillPrice = _asNumber(params['fillPrice']);
        return '$orderType $side filled: ${_fmt(quantity, 8)} $symbol at €${_fmt(fillPrice, 8)}';

      case 'crypto.order.triggered':
        final symbol = params['symbol'] as String? ?? 'UNKNOWN';
        final triggerType = params['triggerType'] as String? ?? 'STOP_LOSS';
        final triggerPrice = _asNumber(params['triggerPrice']);
        return '$triggerType triggered for $symbol at €${_fmt(triggerPrice, 8)}';

      case 'crypto.market.regime':
        final regime = params['regime'] as String? ?? 'SIDEWAYS';
        final marketMovePct = _asNumber(params['marketMovePct']);
        return 'Market regime changed to ${_regimeLabelEn(regime)} (${_fmt(marketMovePct, 2)}% 24h)';

      case 'crypto.market.news':
        final impact = params['impact'] as String? ?? 'NEUTRAL';
        final headline = params['headline'] as String? ?? 'No headline';
        return '${_impactLabelEn(impact)} news: $headline';

      case 'crypto.mission.completed':
        final missionType = params['missionType'] as String? ?? 'DAILY';
        final missionTitle =
            params['missionTitle'] as String? ?? 'Crypto mission';
        final rewardMoney = _asNumber(params['rewardMoney']);
        final prefix = missionType == 'WEEKLY'
            ? 'Weekly mission'
            : 'Daily mission';
        return '$prefix complete: $missionTitle (+EUR ${_fmt(rewardMoney, 2)})';

      case 'crypto.leaderboard.reward':
        final rank = params['rank']?.toString() ?? '-';
        final rewardMoney = _asNumber(params['rewardMoney']);
        return 'Crypto leaderboard reward: #$rank (+EUR ${_fmt(rewardMoney, 2)})';

      // Property events
      case 'property.purchased':
        final propertyName = params['propertyName'] as String?;
        final cost = params['cost'] as int?;
        return 'Purchased $propertyName for €${cost ?? 0}';

      // Crew events
      case 'crew.created':
        final crewName = params['crewName'] as String?;
        return 'Created crew: $crewName';

      case 'crew.joined':
        final crewName = params['crewName'] as String?;
        return 'Joined crew: $crewName';

      // Heist events
      case 'heist.success':
        final money = params['money'] as int?;
        final heistName = params['heistName'] as String?;
        return 'Heist "$heistName" successful! +€${money ?? 0}';

      case 'heist.failed':
        final heistName = params['heistName'] as String?;
        return 'Heist "$heistName" failed!';

      // Hospital events
      case 'hospital.healed':
        final cost = params['cost'] as int?;
        final healthGained = params['healthGained'] as int?;
        return 'Healed at hospital! +${healthGained ?? 0} health, -€${cost ?? 0}';

      // Police events
      case 'police.arrested':
        final jailTime = params['jailTime'] as int?;
        return 'Arrested! Jailed for ${jailTime ?? 0} minutes';

      case 'police.escaped':
        return 'Escaped from police!';

      // FBI events
      case 'fbi.raided':
        return 'Raided by FBI! Lost property and money';

      // Error events
      case 'error.insufficient_funds':
        return 'Insufficient funds';

      case 'error.insufficient_health':
        return 'Not enough health to perform this action';

      case 'error.insufficient_rank':
        final requiredRank = params['requiredRank'] as int?;
        return 'Requires rank ${requiredRank ?? 0}';

      case 'error.jailed':
        final remainingTime = params['remainingTime'] as int?;
        final minutes = remainingTime != null && remainingTime > 0
            ? (remainingTime / 60).ceil()
            : 0;
        return 'You are in jail for $minutes more minute${minutes != 1 ? 's' : ''}';

      case 'error.noHealth':
        final message = params['message'] as String?;
        return message ?? 'You need to rest and recover your health';

      // Crime error events
      case 'crime.error':
        final reason = params['reason'] as String?;
        final message = params['message'] as String?;

        // If backend provides a custom message, use it
        if (message != null && message.isNotEmpty) {
          return message;
        }

        switch (reason) {
          case 'TOOL_REQUIRED':
            final tools = params['tools'] as String? ?? 'gereedschap';
            return l10n.crimeErrorToolRequired(tools);
          case 'TOOL_IN_STORAGE':
            final tools = params['tools'] as String? ?? 'gereedschap';
            return l10n.crimeErrorToolInStorage(tools);
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
          case 'INVALID_CRIME_ID':
            return l10n.crimeErrorInvalidCrimeId;
          case 'WEAPON_REQUIRED':
            return l10n.crimeErrorWeaponRequired;
          case 'WEAPON_SELECTION_REQUIRED':
            return 'Select a weapon in Inventory before committing this crime';
          case 'WEAPON_NOT_SUITABLE':
            final suitableTypes = params['suitableTypes'] as String? ?? '';
            final weaponNames = _translateWeaponTypes(suitableTypes, false);
            return 'You need a suitable weapon: $weaponNames';
          case 'WEAPON_BROKEN':
            return l10n.crimeErrorWeaponBroken;
          case 'NO_AMMO':
            return l10n.crimeErrorNoAmmo;
          case 'DRUGS_REQUIRED':
            final minDrugQuantity =
                (params['minDrugQuantity'] as num?)?.toInt() ?? 1;
            final requiredDrugs =
                (params['requiredDrugs'] as List<dynamic>?)
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

      case 'error.cooldown':
        final remainingSeconds = params['remainingSeconds'] as int? ?? 0;
        return 'Wait $remainingSeconds seconds before trying again';

      case 'error.rescuer_jailed':
        return 'You cannot rescue others while in jail';

      case 'error.target_not_jailed':
        return 'Target player is not in jail';

      case 'error.cannot_rescue_self':
        return 'You cannot rescue yourself';

      // Jailbreak events
      case 'jailbreak.success':
        return '🎉 Jailbreak successful! Player freed!';

      case 'jailbreak.failed':
        return '❌ Jailbreak failed! Player still in jail.';

      case 'jailbreak.caught':
        final jailTime = params['rescuerJailTime'] as int?;
        return '🚔 Jailbreak failed! You got caught and jailed for ${jailTime ?? 0} minutes!';

      case 'bail.paid':
        final amount = params['amount'] as int?;
        return '💰 Bail paid: €${amount ?? 0}. You are free!';

      case 'error.internal':
        return 'An error occurred. Please try again';

      // Test events
      case 'test.broadcast':
        final message = params['message'] as String?;
        return '🧪 TEST: ${message ?? 'Test event received'}';

      // Default fallback
      default:
        return eventKey; // Return raw key if no translation found
    }
  }

  /// Render event with Dutch localization
  String _renderEventNL(String eventKey, Map<String, dynamic> params) {
    switch (eventKey) {
      // Connection events
      case 'connection.established':
        return 'Verbonden met event stream';

      // Auth events
      case 'auth.registered':
        return 'Account succesvol aangemaakt!';
      case 'auth.login':
        return 'Welkom terug!';

      // Crime events
      case 'crime.success':
        final reward = params['reward'] as int?;
        final xpGained = params['xpGained'] as int?;
        final crimeName = params['crimeName'] as String?;
        final jailed = params['jailed'] as bool? ?? false;
        final jailTime = params['jailTime'] as int?; // in MINUTES

        if (jailed && jailTime != null && jailTime > 0) {
          final minutes = jailTime;
          final minuteLabel = minutes == 1 ? 'minuut' : 'minuten';
          return 'Succesvol $crimeName gepleegd! +€${reward ?? 0}, +${xpGained ?? 0} XP - MAAR GEPAKT! $minutes $minuteLabel!';
        }
        return 'Succesvol $crimeName gepleegd! +€${reward ?? 0}, +${xpGained ?? 0} XP';

      case 'crime.failed':
        final crimeName = params['crimeName'] as String?;
        final jailed = params['jailed'] as bool? ?? false;
        final jailTime = params['jailTime'] as int?; // in MINUTES
        final arrested = params['arrested'] as bool? ?? false;
        final arrestingAuthority = params['arrestingAuthority'] as String?;
        final vehicleConfiscated =
            params['vehicleConfiscated'] as bool? ?? false;
        final vehicleChaseDamage = params['vehicleChaseDamage'] as int?;

        String message = '';

        if (arrested && arrestingAuthority != null) {
          final authority = arrestingAuthority == 'FBI' ? 'FBI' : 'politie';
          message = 'Gearresteerd door $authority tijdens $crimeName poging!';
        } else if (jailed && jailTime != null && jailTime > 0) {
          final minutes = jailTime;
          final minuteLabel = minutes == 1 ? 'minuut' : 'minuten';
          message = 'Gepakt tijdens $crimeName! $minutes $minuteLabel!';
        } else {
          message = 'Misdrijf $crimeName mislukt';
        }

        // Add vehicle consequences
        if (vehicleConfiscated) {
          message += ' Je voertuig is in beslag genomen door de politie!';
        } else if (vehicleChaseDamage != null && vehicleChaseDamage > 0) {
          message +=
              ' Je voertuig heeft $vehicleChaseDamage% schade opgelopen tijdens de achtervolging!';
        }

        return message;

      case 'crime.jailed':
      case 'crime.caught':
        final crimeName = params['crimeName'] as String?;
        final jailTime = params['jailTime'] as int?; // in MINUTES
        final minutes = jailTime != null && jailTime > 0 ? jailTime : 0;
        final minuteLabel = minutes == 1 ? 'minuut' : 'minuten';
        return 'Gepakt tijdens $crimeName! $minutes $minuteLabel!';

      // Job events
      case 'job.completed':
      case 'job.success':
        final earnings = params['earnings'] as int?;
        final xpGained = params['xpGained'] as int?;
        final jobName = params['jobName'] as String?;
        final jobId = params['jobId'] as String?;
        final educationBonusPercent =
            (params['educationBonusPercent'] as num?)?.toInt() ?? 0;
        final displayName = jobName ?? jobId ?? 'werk';
        final baseMessage =
            'Werk als $displayName voltooid! +€${earnings ?? 0}, +${xpGained ?? 0} XP';
        if (educationBonusPercent > 0) {
          return '$baseMessage (Opleidingsbonus +$educationBonusPercent%)';
        }
        return baseMessage;

      case 'job.failed':
        final jobName = params['jobName'] as String?;
        final jobId = params['jobId'] as String?;
        final xpLost = (params['xpLost'] as num?)?.toInt() ?? 0;
        final displayName = jobName ?? jobId ?? 'werk';
        if (xpLost > 0) {
          return 'Werk als $displayName mislukt. -$xpLost XP';
        }
        return 'Werk als $displayName mislukt';

      case 'job.error':
        final reason = params['reason'] as String?;
        final minutesRemaining = params['minutesRemaining'] as int?;

        switch (reason) {
          case 'INVALID_JOB_ID':
            return 'Ongeldig werk';
          case 'LEVEL_TOO_LOW':
            return 'Je rank is te laag voor dit werk';
          case 'ON_COOLDOWN':
            return 'Dit werk heeft cooldown. Wacht nog ${minutesRemaining ?? 0} minuten';
          default:
            return 'Werk fout: ${reason ?? 'onbekend'}';
        }

      // Travel events
      case 'travel.departed':
        final destination = params['destination'] as String?;
        final cost = params['cost'] as int?;
        return 'Vliegt naar $destination... -€${cost ?? 0}';

      case 'travel.arrived':
        final country = params['country'] as String?;
        return 'Aangekomen in $country!';

      // Bank events
      case 'bank.deposit':
        final amount = params['amount'] as int?;
        return '€${amount ?? 0} gestort op bankrekening';

      case 'bank.withdraw':
        final amount = params['amount'] as int?;
        return '€${amount ?? 0} opgenomen van bankrekening';

      // Crypto events
      case 'crypto.buy':
        final symbol = params['symbol'] as String? ?? 'ONBEKEND';
        final quantity = _asNumber(params['quantity']);
        final totalCost = _asNumber(params['totalCost']);
        return 'Kocht ${_fmt(quantity, 8)} $symbol voor €${_fmt(totalCost, 2)}';

      case 'crypto.sell':
        final symbol = params['symbol'] as String? ?? 'ONBEKEND';
        final quantity = _asNumber(params['quantity']);
        final totalValue = _asNumber(params['totalValue']);
        final realizedProfit = _asNumber(params['realizedProfit']);
        return 'Verkocht ${_fmt(quantity, 8)} $symbol voor €${_fmt(totalValue, 2)} (Resultaat €${_fmt(realizedProfit, 2)})';

      case 'crypto.alert.price':
        final symbol = params['symbol'] as String? ?? 'ONBEKEND';
        final currentPrice = _asNumber(params['currentPrice']);
        final changePct = _asNumber(params['changePct']);
        return '$symbol alert: €${_fmt(currentPrice, 8)} (${_fmt(changePct, 2)}% 24u)';

      case 'crypto.order.filled':
        final symbol = params['symbol'] as String? ?? 'ONBEKEND';
        final orderType = params['orderType'] as String? ?? 'LIMIT';
        final side = params['side'] as String? ?? 'BUY';
        final quantity = _asNumber(params['quantity']);
        final fillPrice = _asNumber(params['fillPrice']);
        return '$orderType $side uitgevoerd: ${_fmt(quantity, 8)} $symbol op €${_fmt(fillPrice, 8)}';

      case 'crypto.order.triggered':
        final symbol = params['symbol'] as String? ?? 'ONBEKEND';
        final triggerType = params['triggerType'] as String? ?? 'STOP_LOSS';
        final triggerPrice = _asNumber(params['triggerPrice']);
        return '$triggerType geactiveerd voor $symbol op €${_fmt(triggerPrice, 8)}';

      case 'crypto.market.regime':
        final regime = params['regime'] as String? ?? 'SIDEWAYS';
        final marketMovePct = _asNumber(params['marketMovePct']);
        return 'Marktregime gewijzigd naar ${_regimeLabelNl(regime)} (${_fmt(marketMovePct, 2)}% 24u)';

      case 'crypto.market.news':
        final impact = params['impact'] as String? ?? 'NEUTRAL';
        final headline = params['headline'] as String? ?? 'Geen kopregel';
        return '${_impactLabelNl(impact)} nieuws: $headline';

      case 'crypto.mission.completed':
        final missionType = params['missionType'] as String? ?? 'DAILY';
        final missionTitle =
            params['missionTitle'] as String? ?? 'Crypto missie';
        final rewardMoney = _asNumber(params['rewardMoney']);
        final prefix = missionType == 'WEEKLY'
            ? 'Wekelijkse missie'
            : 'Dagelijkse missie';
        return '$prefix voltooid: $missionTitle (+EUR ${_fmt(rewardMoney, 2)})';

      case 'crypto.leaderboard.reward':
        final rank = params['rank']?.toString() ?? '-';
        final rewardMoney = _asNumber(params['rewardMoney']);
        return 'Crypto leaderboard beloning: #$rank (+EUR ${_fmt(rewardMoney, 2)})';

      // Property events
      case 'property.purchased':
        final propertyName = params['propertyName'] as String?;
        final cost = params['cost'] as int?;
        return '$propertyName gekocht voor €${cost ?? 0}';

      // Crew events
      case 'crew.created':
        final crewName = params['crewName'] as String?;
        return 'Crew aangemaakt: $crewName';

      case 'crew.joined':
        final crewName = params['crewName'] as String?;
        return 'Crew binnengekomen: $crewName';

      // Heist events
      case 'heist.success':
        final money = params['money'] as int?;
        final heistName = params['heistName'] as String?;
        return 'Overval "$heistName" geslaagd! +€${money ?? 0}';

      case 'heist.failed':
        final heistName = params['heistName'] as String?;
        return 'Overval "$heistName" mislukt!';

      // Hospital events
      case 'hospital.healed':
        final cost = params['cost'] as int?;
        final healthGained = params['healthGained'] as int?;
        return 'Genezen in ziekenhuis! +${healthGained ?? 0} gezondheid, -€${cost ?? 0}';

      // Police events
      case 'police.arrested':
        final jailTime = params['jailTime'] as int?;
        return 'Gearresteerd! ${jailTime ?? 0} minuten cel';

      case 'police.escaped':
        return 'Ontsnapt van de politie!';

      // FBI events
      case 'fbi.raided':
        return 'FBI inval! Bezittingen en geld verloren';

      // Error events
      case 'error.insufficient_funds':
        return 'Onvoldoende geld';

      case 'error.insufficient_health':
        return 'Niet genoeg gezondheid voor deze actie';

      case 'error.insufficient_rank':
        final requiredRank = params['requiredRank'] as int?;
        return 'Vereist rank ${requiredRank ?? 0}';

      case 'error.jailed':
        final remainingTime = params['remainingTime'] as int?;
        final minutes = remainingTime != null && remainingTime > 0
            ? (remainingTime / 60).ceil()
            : 0;
        final minuteLabel = minutes == 1 ? 'minuut' : 'minuten';
        return 'Je zit nog $minutes $minuteLabel in de cel';

      case 'error.noHealth':
        return 'Je moet rusten en je gezondheid herstellen';

      // Crime error events (Dutch)
      case 'crime.error':
        final reason = params['reason'] as String?;
        final message = params['message'] as String?;

        // If backend provides a custom message, use it
        if (message != null && message.isNotEmpty) {
          return message;
        }

        switch (reason) {
          case 'TOOL_REQUIRED':
            final tools = params['tools'] as String? ?? 'gereedschap';
            return l10n.crimeErrorToolRequired(tools);
          case 'TOOL_IN_STORAGE':
            final tools = params['tools'] as String? ?? 'gereedschap';
            return l10n.crimeErrorToolInStorage(tools);
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
          case 'INVALID_CRIME_ID':
            return l10n.crimeErrorInvalidCrimeId;
          case 'WEAPON_REQUIRED':
            return l10n.crimeErrorWeaponRequired;
          case 'WEAPON_SELECTION_REQUIRED':
            return 'Selecteer eerst een wapen in Inventory voordat je deze misdaad pleegt';
          case 'WEAPON_NOT_SUITABLE':
            final suitableTypes = params['suitableTypes'] as String? ?? '';
            final weaponNames = _translateWeaponTypes(suitableTypes, true);
            return 'Je hebt een geschikt wapen nodig: $weaponNames';
          case 'WEAPON_BROKEN':
            return l10n.crimeErrorWeaponBroken;
          case 'NO_AMMO':
            return l10n.crimeErrorNoAmmo;
          case 'DRUGS_REQUIRED':
            final minDrugQuantity =
                (params['minDrugQuantity'] as num?)?.toInt() ?? 1;
            final requiredDrugs =
                (params['requiredDrugs'] as List<dynamic>?)
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

      case 'error.cooldown':
        final remainingSeconds = params['remainingSeconds'] as int? ?? 0;
        return 'Wacht $remainingSeconds seconden voordat je het opnieuw probeert';

      case 'error.rescuer_jailed':
        return 'Je kunt anderen niet bevrijden terwijl je in de cel zit';

      case 'error.target_not_jailed':
        return 'Deze speler zit niet in de cel';

      case 'error.cannot_rescue_self':
        return 'Je kunt jezelf niet bevrijden';

      // Jailbreak events
      case 'jailbreak.success':
        return '🎉 Uitbraak geslaagd! Speler bevrijd!';

      case 'jailbreak.failed':
        return '❌ Uitbraak mislukt! Speler zit nog in de cel.';

      case 'jailbreak.caught':
        final jailTime = params['rescuerJailTime'] as int?;
        return '🚔 Uitbraak mislukt! Je bent gepakt en zit ${jailTime ?? 0} minuten in de cel!';

      case 'bail.paid':
        final amount = params['amount'] as int?;
        return '💰 Borg betaald: €${amount ?? 0}. Je bent vrij!';

      case 'error.internal':
        return 'Er is een fout opgetreden. Probeer opnieuw';

      // Test events
      case 'test.broadcast':
        final message = params['message'] as String?;
        return '🧪 TEST: ${message ?? 'Test event received'}';

      default:
        return eventKey;
    }
  }

  /// Translate weapon type IDs to readable names
  /// Returns comma-separated list of weapon names
  String _translateWeaponTypes(String types, bool isDutch) {
    if (types.isEmpty) return '';

    final typeList = types.split(',');
    final Map<String, String> weaponNamesEN = {
      'knife': 'knife',
      'handgun': 'handgun/pistol',
      'shotgun': 'shotgun',
      'rifle': 'rifle',
      'sniper': 'sniper rifle',
      'smg': 'submachine gun',
    };

    final Map<String, String> weaponNamesNL = {
      'knife': 'mes',
      'handgun': 'pistool',
      'shotgun': 'jachtgeweer',
      'rifle': 'geweer',
      'sniper': 'sluipschuttersgeweer',
      'smg': 'automatisch pistool',
    };

    final names = typeList.map((type) {
      final cleanType = type.trim();
      return isDutch
          ? (weaponNamesNL[cleanType] ?? cleanType)
          : (weaponNamesEN[cleanType] ?? cleanType);
    }).toList();

    if (names.length == 1) {
      return names[0];
    } else if (names.length == 2) {
      return isDutch
          ? '${names[0]} of ${names[1]}'
          : '${names[0]} or ${names[1]}';
    } else {
      final lastItem = names.removeLast();
      final joined = names.join(', ');
      return isDutch ? '$joined of $lastItem' : '$joined or $lastItem';
    }
  }

  double _asNumber(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  String _regimeLabelEn(String regime) {
    switch (regime.toUpperCase()) {
      case 'BULL':
        return 'bullish';
      case 'BEAR':
        return 'bearish';
      default:
        return 'sideways';
    }
  }

  String _regimeLabelNl(String regime) {
    switch (regime.toUpperCase()) {
      case 'BULL':
        return 'stijgend';
      case 'BEAR':
        return 'dalend';
      default:
        return 'zijwaarts';
    }
  }

  String _impactLabelEn(String impact) {
    switch (impact.toUpperCase()) {
      case 'BULLISH':
        return 'Bullish';
      case 'BEARISH':
        return 'Bearish';
      default:
        return 'Neutral';
    }
  }

  String _impactLabelNl(String impact) {
    switch (impact.toUpperCase()) {
      case 'BULLISH':
        return 'Positief';
      case 'BEARISH':
        return 'Negatief';
      default:
        return 'Neutraal';
    }
  }

  String _fmt(double value, int decimals) => value.toStringAsFixed(decimals);
}
