// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get appTitle => 'Mafia Spel';

  @override
  String get login => 'Inloggen';

  @override
  String get register => 'Registreren';

  @override
  String get username => 'Gebruikersnaam';

  @override
  String get password => 'Wachtwoord';

  @override
  String get usernameLabel => 'GEBRUIKERSNAAM';

  @override
  String get passwordLabel => 'WACHTWOORD';

  @override
  String get usernamePlaceholder => 'Gebruikersnaam';

  @override
  String get passwordPlaceholder => 'Wachtwoord';

  @override
  String get loginButton => 'INLOGGEN';

  @override
  String get registerButton => 'REGISTREREN';

  @override
  String get forgotPassword => 'Wachtwoord vergeten?';

  @override
  String get usernameRequired => 'Voer een gebruikersnaam in';

  @override
  String get passwordRequired => 'Voer een wachtwoord in';

  @override
  String get passwordTooShort => 'Wachtwoord moet minimaal 6 tekens zijn';

  @override
  String get invalidCredentials => 'Onjuiste gebruikersnaam of wachtwoord';

  @override
  String get loginSuccessful => 'Succesvol ingelogd!';

  @override
  String get registrationSuccessful => 'Registratie gelukt!';

  @override
  String get loginFailed => 'Inloggen mislukt';

  @override
  String get emailLabel => 'E-MAIL';

  @override
  String get emailPlaceholder => 'E-mailadres';

  @override
  String get emailRequired => 'Voer een e-mailadres in';

  @override
  String get emailInvalid => 'Voer een geldig e-mailadres in';

  @override
  String get forgotPasswordTitle => 'Wachtwoord Herstellen';

  @override
  String get forgotPasswordDescription =>
      'Voer uw e-mailadres in en we sturen u een link om uw wachtwoord te herstellen.';

  @override
  String get resetPasswordButton => 'VERSTUUR HERSTELLINK';

  @override
  String get emailSent => 'Herstellink verzonden! Controleer uw e-mail.';

  @override
  String get backToLogin => 'Terug naar Inloggen';

  @override
  String welcome(String username) {
    return 'Welkom, $username!';
  }

  @override
  String get dashboardTimeouts => 'Timers';

  @override
  String get dashboardTimeoutCrime => 'Misdaad';

  @override
  String get dashboardTimeoutJob => 'Werk';

  @override
  String get dashboardTimeoutTravel => 'Reizen';

  @override
  String get dashboardTimeoutVehicleTheft => 'Auto stelen';

  @override
  String get dashboardTimeoutBoatTheft => 'Boot stelen';

  @override
  String get dashboardTimeoutNightclubSeason => 'Nachtclub seizoen';

  @override
  String get dashboardTimeoutAmmo => 'Kogels kopen';

  @override
  String get dashboardTimeoutShootingRange => 'Schietschool';

  @override
  String get dashboardTimeoutGym => 'Sportschool';

  @override
  String get dashboardInfoDrugsGrams => 'Drugs (gram)';

  @override
  String get dashboardInfoNightclubs => 'Nachtclubs';

  @override
  String get dashboardInfoNightclubRevenue => 'Nachtclub omzet';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get crimes => 'Misdaden';

  @override
  String get errorLoadingCrimes => 'Fout bij laden misdaden';

  @override
  String connectionError(String error) {
    return 'Verbindingsfout: $error';
  }

  @override
  String payRange(String min, String max) {
    return 'Opbrengst: €$min - €$max';
  }

  @override
  String requiresRank(String rank) {
    return 'Vereist rang $rank';
  }

  @override
  String get requiresVehicle => 'Voertuig vereist';

  @override
  String get federalCrimeWarning => '⚠️ Federale misdaad - FBI Heat';

  @override
  String get crimePickpocketName => 'Zakkenrollen';

  @override
  String get crimePickpocketDesc => 'Steel portemonnees van voorbijgangers';

  @override
  String get crimeShopliftName => 'Winkeldiefstal';

  @override
  String get crimeShopliftDesc => 'Steel goederen uit een winkel';

  @override
  String get crimeStealBikeName => 'Fiets Stelen';

  @override
  String get crimeStealBikeDesc => 'Steel een fiets van een rek';

  @override
  String get crimeCarTheftName => 'Auto Diefstal';

  @override
  String get crimeCarTheftDesc => 'Steel een geparkeerde auto';

  @override
  String get crimeBurglaryName => 'Inbraak';

  @override
  String get crimeBurglaryDesc => 'Breek in bij een woning';

  @override
  String get crimeRobStoreName => 'Winkel Overvallen';

  @override
  String get crimeRobStoreDesc => 'Overval een kleine winkel';

  @override
  String get crimeMugPersonName => 'Beroving';

  @override
  String get crimeMugPersonDesc => 'Beroof iemand op straat';

  @override
  String get crimeStealCarPartsName => 'Autoonderdelen Stelen';

  @override
  String get crimeStealCarPartsDesc =>
      'Steel onderdelen van geparkeerde auto\'s';

  @override
  String get crimeHijackTruckName => 'Vrachtwagen Kapen';

  @override
  String get crimeHijackTruckDesc => 'Kaap een vrachtwagen met goederen';

  @override
  String get crimeAtmTheftName => 'Geldautomaat Kraken';

  @override
  String get crimeAtmTheftDesc => 'Kraak een geldautomaat';

  @override
  String get crimeJewelryHeistName => 'Juwelier Overval';

  @override
  String get crimeJewelryHeistDesc => 'Overval een juwelier';

  @override
  String get crimeVandalismName => 'Vandalisme';

  @override
  String get crimeVandalismDesc => 'Vernietig eigendommen voor geld';

  @override
  String get crimeGraffitiName => 'Graffiti Spuiten';

  @override
  String get crimeGraffitiDesc => 'Spuit graffiti voor lokale gangs';

  @override
  String get crimeDrugDealSmallName => 'Kleine Drugsdeal';

  @override
  String get crimeDrugDealSmallDesc => 'Verkoop kleine hoeveelheid drugs';

  @override
  String get crimeDrugDealLargeName => 'Grote Drugsdeal';

  @override
  String get crimeDrugDealLargeDesc => 'Verkoop grote hoeveelheid drugs';

  @override
  String get crimeExtortionName => 'Afpersing';

  @override
  String get crimeExtortionDesc => 'Pers geld af van lokale ondernemers';

  @override
  String get crimeKidnappingName => 'Ontvoering';

  @override
  String get crimeKidnappingDesc => 'Ontvoer iemand voor losgeld';

  @override
  String get crimeArsonName => 'Brandstichting';

  @override
  String get crimeArsonDesc => 'Steek een gebouw in brand';

  @override
  String get crimeSmugglingName => 'Smokkel';

  @override
  String get crimeSmugglingDesc => 'Smokkel goederen over de grens';

  @override
  String get crimeAssassinationName => 'Huurmoord';

  @override
  String get crimeAssassinationDesc => 'Voer een huurmoord uit';

  @override
  String get crimeHackAccountName => 'Account Hacken';

  @override
  String get crimeHackAccountDesc => 'Hack een bankrekening';

  @override
  String get crimeCounterfeitMoneyName => 'Geld Vervalsen';

  @override
  String get crimeCounterfeitMoneyDesc => 'Maak vals geld';

  @override
  String get crimeIdentityTheftName => 'Identiteitsdiefstal';

  @override
  String get crimeIdentityTheftDesc => 'Steel iemands identiteit voor fraude';

  @override
  String get crimeRobArmoredTruckName => 'Geldwagen Overvallen';

  @override
  String get crimeRobArmoredTruckDesc => 'Overval een geldtransport';

  @override
  String get crimeArtTheftName => 'Kunstdiefstal';

  @override
  String get crimeArtTheftDesc => 'Steel waardevolle kunstwerken';

  @override
  String get crimeProtectionRacketName => 'Beschermingsgeld';

  @override
  String get crimeProtectionRacketDesc =>
      'Laat ondernemers beschermingsgeld betalen';

  @override
  String get crimeCasinoHeistName => 'Casino Overval';

  @override
  String get crimeCasinoHeistDesc => 'Overval een casino';

  @override
  String get crimeBankRobberyName => 'Bankoverval';

  @override
  String get crimeBankRobberyDesc => 'Overval een bank';

  @override
  String get crimeStealYachtName => 'Jacht Stelen';

  @override
  String get crimeStealYachtDesc => 'Steel een luxe jacht';

  @override
  String get crimeCorruptOfficialName => 'Ambtenaar Omkopen';

  @override
  String get crimeCorruptOfficialDesc => 'Koop een ambtenaar om voor gunsten';

  @override
  String get crimeEliminateWitnessName => 'Getuige elimineren';

  @override
  String get crimeEliminateWitnessDesc =>
      'Elimineer een getuige voor een proces';

  @override
  String get crimeDiamondHeistName => 'Diamanttransport-overval';

  @override
  String get crimeDiamondHeistDesc =>
      'Kaap een transport met onbewerkte diamanten';

  @override
  String get crimeEvidenceRoomHeistName => 'Bewijsarchief-overval';

  @override
  String get crimeEvidenceRoomHeistDesc =>
      'Steel bewijs uit een federale opslagfaciliteit';

  @override
  String get crimeMuseumHeistName => 'Museumoverval';

  @override
  String get crimeMuseumHeistDesc =>
      'Steel waardevolle artefacten uit een museum';

  @override
  String get crimeBossAssassinationName => 'Rivaliserende boss vermoorden';

  @override
  String get crimeBossAssassinationDesc =>
      'Elimineer de leider van een rivaliserende organisatie';

  @override
  String get crimeCriminalRecordWipeName => 'Strafblad wissen';

  @override
  String get tooltipCrimeRequiresTools => 'Gereedschap vereist';

  @override
  String get tooltipCrimeRequiresVehicle => 'Voertuig vereist';

  @override
  String get tooltipCrimeRequiresDrugs => 'Drugs vereist';

  @override
  String get tooltipCrimeHighValue => 'Hoge prioriteit operatie';

  @override
  String get tooltipCrimeRequiresViolence => 'Geweld vereist';

  @override
  String get tooltipCrimeRequiresWeapon => 'Wapen vereist';

  @override
  String get tooltipCrimeRequirementsHeading => 'Vereist:';

  @override
  String get crimeCriminalRecordWipeTooltip =>
      'Wist je volledige strafblad bij succes. Alleen zinvol als je al veroordelingen hebt.';

  @override
  String crimeErrorDrugsRequired(String quantity, String drugs) {
    return 'Je hebt minimaal ${quantity}g nodig van: $drugs';
  }

  @override
  String get jobs => 'Banen';

  @override
  String get errorLoadingJobs => 'Fout bij laden jobs';

  @override
  String get jobNewspaperDeliveryName => 'Krant Bezorgen';

  @override
  String get jobNewspaperDeliveryDesc => 'Bezorg kranten in de vroege ochtend';

  @override
  String get jobCarWashName => 'Auto Wassen';

  @override
  String get jobCarWashDesc => 'Was auto\'s bij de wasstraat';

  @override
  String get jobGroceryBaggerName => 'Vakkenvuller';

  @override
  String get jobGroceryBaggerDesc => 'Vul schappen in de supermarkt';

  @override
  String get jobDishwasherName => 'Afwasser';

  @override
  String get jobDishwasherDesc => 'Was af in een restaurant';

  @override
  String get jobStreetSweeperName => 'Straatveger';

  @override
  String get jobStreetSweeperDesc => 'Veeg straten schoon';

  @override
  String get jobPizzaDeliveryName => 'Pizza Bezorger';

  @override
  String get jobPizzaDeliveryDesc => 'Bezorg pizza\'s in de stad';

  @override
  String get jobTaxiDriverName => 'Taxichauffeur';

  @override
  String get jobTaxiDriverDesc => 'Rij taxi door de stad';

  @override
  String get jobWarehouseWorkerName => 'Magazijnmedewerker';

  @override
  String get jobWarehouseWorkerDesc => 'Werk in een magazijn';

  @override
  String get jobConstructionWorkerName => 'Bouwvakker';

  @override
  String get jobConstructionWorkerDesc => 'Werk op de bouw';

  @override
  String get jobBartenderName => 'Barkeeper';

  @override
  String get jobBartenderDesc => 'Tap bier en mix cocktails';

  @override
  String get jobSecurityGuardName => 'Beveiliger';

  @override
  String get jobSecurityGuardDesc => 'Bewaak een gebouw';

  @override
  String get jobTruckDriverName => 'Vrachtwagenchauffeur';

  @override
  String get jobTruckDriverDesc => 'Rij vrachtwagen over lange afstanden';

  @override
  String get jobMechanicName => 'Monteur';

  @override
  String get jobMechanicDesc => 'Repareer auto\'s in een garage';

  @override
  String get jobElectricianName => 'Elektricien';

  @override
  String get jobElectricianDesc =>
      'Installeer en repareer elektrische systemen';

  @override
  String get jobPlumberName => 'Loodgieter';

  @override
  String get jobPlumberDesc => 'Repareer leidingen en sanitair';

  @override
  String get jobChefName => 'Kok';

  @override
  String get jobChefDesc => 'Kook in een restaurant';

  @override
  String get jobParamedicName => 'Ambulanceverpleegkundige';

  @override
  String get jobParamedicDesc => 'Help mensen in nood';

  @override
  String get jobProgrammerName => 'Programmeur';

  @override
  String get jobProgrammerDesc => 'Schrijf software voor bedrijven';

  @override
  String get jobAccountantName => 'Accountant';

  @override
  String get jobAccountantDesc => 'Beheer financien voor bedrijven';

  @override
  String get jobLawyerName => 'Advocaat';

  @override
  String get jobLawyerDesc => 'Verdedig clienten in rechtszaken';

  @override
  String get jobRealEstateAgentName => 'Makelaar';

  @override
  String get jobRealEstateAgentDesc => 'Verkoop huizen en gebouwen';

  @override
  String get jobStockbrokerName => 'Effectenmakelaar';

  @override
  String get jobStockbrokerDesc => 'Handel in aandelen';

  @override
  String get jobDoctorName => 'Dokter';

  @override
  String get jobDoctorDesc => 'Behandel patienten in het ziekenhuis';

  @override
  String get jobAirlinePilotName => 'Piloot';

  @override
  String get jobAirlinePilotDesc => 'Vlieg passagiersvliegtuigen';

  @override
  String get travel => 'Reizen';

  @override
  String get errorLoadingCountries => 'Fout bij laden landen';

  @override
  String get currentLocation => 'Huidige locatie';

  @override
  String get current => 'Huidig';

  @override
  String get travelTo => 'Reis';

  @override
  String travelCost(String amount) {
    return 'Kosten: €$amount';
  }

  @override
  String get travelJourneyTitle => 'Reis starten?';

  @override
  String get travelRouteLabel => 'Route:';

  @override
  String travelLegsLabel(String count) {
    return 'Etappes: $count';
  }

  @override
  String travelCostPerLeg(String amount) {
    return 'Kosten per etappe: €$amount';
  }

  @override
  String travelTotalCost(String amount) {
    return 'Totale kosten: €$amount';
  }

  @override
  String travelCooldownPerLeg(String minutes) {
    return 'Cooldown: $minutes min per etappe';
  }

  @override
  String get travelRiskPerLeg =>
      'Risico: per etappe (je kunt gepakt worden en alles kwijt raken)';

  @override
  String get travelStart => 'Begin';

  @override
  String travelInTransitTo(String country) {
    return 'Onderweg naar $country';
  }

  @override
  String travelLegProgress(String current, String total) {
    return 'Etappe $current/$total';
  }

  @override
  String travelNextStop(String country) {
    return 'Volgende stop: $country';
  }

  @override
  String get travelContinue => 'Verder';

  @override
  String get travelCancelJourney => 'Reis annuleren';

  @override
  String get travelJourneyCanceled => 'Reis geannuleerd';

  @override
  String get travelDirect => 'Direct';

  @override
  String travelVia(String countries) {
    return 'via $countries';
  }

  @override
  String travelLegsCount(String count) {
    return '$count etappes';
  }

  @override
  String jailRemainingMinutes(String minutes) {
    return 'Je zit nog $minutes minuten in de cel';
  }

  @override
  String travelSuccessTo(String country) {
    return 'Gereisd naar $country!';
  }

  @override
  String travelConfiscated(String quantity, String item) {
    return '🚨 $quantity items $item in beslag genomen!';
  }

  @override
  String travelDamaged(String item, String percent) {
    return '⚠️ $item beschadigd ($percent% waardeverlies)!';
  }

  @override
  String get countryNetherlands => 'Nederland';

  @override
  String get countryBelgium => 'België';

  @override
  String get countryGermany => 'Duitsland';

  @override
  String get countryFrance => 'Frankrijk';

  @override
  String get countrySpain => 'Spanje';

  @override
  String get countryItaly => 'Italië';

  @override
  String get countryUk => 'Verenigd Koninkrijk';

  @override
  String get countrySwitzerland => 'Zwitserland';

  @override
  String get crew => 'Bemanning';

  @override
  String get profile => 'Profiel';

  @override
  String get logout => 'Uitloggen';

  @override
  String get logOut => 'Uitloggen';

  @override
  String get menu => 'Menu';

  @override
  String get account => 'Rekening';

  @override
  String get messages => 'Berichten';

  @override
  String get noDirectMessagesYet => 'Nog geen berichten';

  @override
  String get sendMessageToFriendsHint => 'Stuur een bericht naar je vrienden!';

  @override
  String errorLoadingConversations(String error) {
    return 'Fout bij laden gesprekken: $error';
  }

  @override
  String get messageSystemBadge => 'SYSTEEM';

  @override
  String get messageSystemInboxPreview => 'Achievements en systeemberichten';

  @override
  String get messageSystemThreadSubtitle => 'Achievements en systeemberichten';

  @override
  String get messageSystemThreadEmptyDetail =>
      'Achievement- en systeemberichten verschijnen hier automatisch.';

  @override
  String get messageSendFirst => 'Stuur het eerste bericht!';

  @override
  String chatFriendRankLine(int rank) {
    return '★ Rang $rank';
  }

  @override
  String errorLoadingMessages(String error) {
    return 'Fout bij laden berichten: $error';
  }

  @override
  String get messageDeleteOwnOnly =>
      'Je kunt alleen je eigen berichten verwijderen';

  @override
  String get messageDeleteTitle => 'Bericht verwijderen';

  @override
  String get messageDeleteBody => 'Dit bericht wordt permanent verwijderd.';

  @override
  String get messageSendFailed => 'Versturen mislukt';

  @override
  String get messageDeleteFailed => 'Verwijderen mislukt';

  @override
  String get investigationWindowExpired =>
      'Onderzoeksvenster verlopen (24 uur).';

  @override
  String get investigationStartedInboxHint =>
      'Onderzoek gestart. Check je inbox voor het detective-rapport.';

  @override
  String get investigationAlreadyInProgress =>
      'Dit onderzoek loopt al of is al afgerond.';

  @override
  String investigationStartFailed(String error) {
    return 'Onderzoek starten mislukt: $error';
  }

  @override
  String get investigationExpired => 'Onderzoek verlopen';

  @override
  String get investigationStarted => 'Onderzoek gestart';

  @override
  String get investigationStarting => 'Bezig...';

  @override
  String get startMurderInvestigation => 'Start moordonderzoek';

  @override
  String get systemMessagesReadOnlyHint =>
      'Systeemberichten kunnen niet beantwoord worden';

  @override
  String get helpAndGuide => 'Hulp & gids';

  @override
  String get quickActions => 'Snelle acties';

  @override
  String get liveEvents => 'Live events';

  @override
  String get support => 'Steun';

  @override
  String get events => 'Evenementen';

  @override
  String get aviation => 'Luchtvaart';

  @override
  String get premiumAndCredits => 'Premium & credits';

  @override
  String get bank => 'Bank';

  @override
  String get tradeGoods => 'Zwarte markt';

  @override
  String get drugs => 'Geneesmiddelen';

  @override
  String get nightclub => 'Nachtclub';

  @override
  String get crypto => 'Crypto';

  @override
  String get smuggling => 'Smokkelen';

  @override
  String get tools => 'gereedschap';

  @override
  String get vehicleHeist => 'Voertuig stelen';

  @override
  String get vehicleHeistTitle => 'Voertuig stelen';

  @override
  String get vehicleHeistTabSubtitleCar =>
      'Steel auto\'s voor cash en onderdelen.';

  @override
  String get vehicleHeistTabSubtitleMotorcycle =>
      'Steel motoren voor cash en onderdelen.';

  @override
  String get vehicleHeistTabSubtitleBoat =>
      'Steel boten voor cash en onderdelen.';

  @override
  String get vehicleHeistReady => 'Klaar';

  @override
  String get vehicleHeistMotorStorage => 'Motorstalling';

  @override
  String get vehicleHeistCapacityPolicyCar =>
      'Autocapaciteit wordt gedeeld over alle auto-heists.';

  @override
  String get vehicleHeistCapacityPolicyMotorcycle =>
      'Motorcapaciteit wordt gedeeld over alle motor-heists.';

  @override
  String get vehicleHeistCapacityPolicyBoat =>
      'Bootcapaciteit wordt gedeeld over alle boot-heists.';

  @override
  String vehicleHeistRankRequired(String rank) {
    return 'Rank vereist: $rank';
  }

  @override
  String vehicleHeistCapacityLine(String stored, String total, String level) {
    return 'Opslag: $stored/$total (baan lvl $level)';
  }

  @override
  String get vehicleHeistStealCar => 'Steel auto';

  @override
  String get vehicleHeistStealMotorcycle => 'Steel motor';

  @override
  String get vehicleHeistStealBoat => 'Steel boot';

  @override
  String get vehicleHeistGenericVehicle => 'voertuig';

  @override
  String vehicleHeistSuccessStolen(String vehicle) {
    return 'Gelukt: $vehicle gestolen.';
  }

  @override
  String vehicleHeistCooldownActive(String duration) {
    return 'Cooldown actief: $duration';
  }

  @override
  String vehicleHeistArrested(String minutes) {
    return 'Je bent gearresteerd ($minutes min gevangenis).';
  }

  @override
  String get vehicleHeistUntil => 'tot';

  @override
  String get vehicleHeistRegionalLockActive => 'Regionale lock actief.';

  @override
  String get vehicleHeistStealFailed => 'Stelen mislukt.';

  @override
  String get vehicleHeistUpgradeCompleted => 'Upgrade voltooid.';

  @override
  String get vehicleHeistUpgradeFailed => 'Upgrade mislukt.';

  @override
  String get vehicleHeistCatalogTitleCars => 'Beschikbare auto\'s';

  @override
  String get vehicleHeistCatalogTitleMotorcycles => 'Beschikbare motoren';

  @override
  String get vehicleHeistCatalogTitleBoats => 'Beschikbare boten';

  @override
  String get vehicleHeistCatalogEmpty => 'Geen voertuigen in deze catalogus.';

  @override
  String get vehicleHeistRarityCommon => 'Gewoon';

  @override
  String get vehicleHeistRarityUncommon => 'Ongewoon';

  @override
  String get vehicleHeistRarityRare => 'Zeldzaam';

  @override
  String get vehicleHeistRarityEpic => 'Episch';

  @override
  String get vehicleHeistRarityLegendary => 'Legendarisch';

  @override
  String get vehicleHeistEventOnlyTag => 'Alleen event';

  @override
  String vehicleHeistCatalogValue(String value) {
    return 'Waarde: $value';
  }

  @override
  String vehicleHeistCatalogRank(String rank) {
    return 'Rang: $rank';
  }

  @override
  String vehicleHeistCatalogInGameAvailability(String label) {
    return 'In-game beschikbaarheid: $label';
  }

  @override
  String vehicleHeistCatalogMostCommonIn(String country) {
    return 'Meest voorkomend in: $country';
  }

  @override
  String vehicleHeistCatalogCountries(String countries) {
    return 'Landen: $countries';
  }

  @override
  String vehicleHeistUpgradeCost(String cost) {
    return 'Upgraden ($cost)';
  }

  @override
  String vehicleHeistUpgradeRankRequired(String rank) {
    return 'Upgrade geblokkeerd: rank $rank vereist';
  }

  @override
  String get vehicleHeistUpgradeLocked => 'Upgrade geblokkeerd';

  @override
  String vehicleHeistSpeedUpWithCredits(String credits) {
    return 'Versnel voor $credits credits';
  }

  @override
  String get vehicleHeistSpeedUpWithCreditsNextScreen =>
      'Versnel (volgend scherm)';

  @override
  String get vehicleHeistExpand => 'Openen';

  @override
  String get vehicleHeistCollapse => 'Sluiten';

  @override
  String get vehicleHeistActive => 'ACTIEF';

  @override
  String get vehicleHeistOff => 'uit';

  @override
  String get catalog => 'Catalogus';

  @override
  String get vehicleHeistOpsHotspotRunButton => 'Hotspot-run';

  @override
  String get vehicleHeistOpsHotspotRunTitle => 'Hotspot-run';

  @override
  String vehicleHeistOpsHotspotSuccess(String reward) {
    return 'Hotspot-run voltooid: +$reward';
  }

  @override
  String vehicleHeistOpsHotspotCooldownActive(String duration) {
    return 'Hotspot cooldown actief ($duration)';
  }

  @override
  String get vehicleHeistOpsHotspotFailedHeatIncreased =>
      'Hotspot mislukt. Hitte verhoogd.';

  @override
  String get vehicleHeistOpsCrewOpButton => 'Crew-actie';

  @override
  String get vehicleHeistOpsCrewOpTitle => 'Crew-actie';

  @override
  String vehicleHeistOpsCrewSuccess(String reward) {
    return 'Crew-actie voltooid: jij verdiende $reward';
  }

  @override
  String get vehicleHeistOpsCrewRequired => 'Crew vereist.';

  @override
  String vehicleHeistOpsCrewCooldownActive(String duration) {
    return 'Crew cooldown actief ($duration)';
  }

  @override
  String get vehicleHeistOpsCrewFailed => 'Crew-actie mislukt.';

  @override
  String get vehicleHeistOpsCrewJoinToUnlock =>
      'Join een crew om crew-acties te ontgrendelen';

  @override
  String get vehicleHeistOpsCrewRequiredYes => 'Crew vereist: ja';

  @override
  String get vehicleHeistOpsCrewRequiredNoJoinFirst =>
      'Crew vereist: nee (join eerst een crew)';

  @override
  String get vehicleHeistOpsBuyPartsButton => 'Koop onderdelen';

  @override
  String get vehicleHeistOpsBuyPartsTitle => 'Koop onderdelen';

  @override
  String vehicleHeistOpsBuyPartsPrompt(String type) {
    return 'Welke onderdelen kopen? ($type)';
  }

  @override
  String vehicleHeistOpsPartsPurchased(String cost) {
    return 'Onderdelen gekocht: -$cost';
  }

  @override
  String get vehicleHeistOpsPartsPurchaseFailed =>
      'Onderdelen aankoop mislukt.';

  @override
  String get vehicleHeistOpsClaimContractButton => 'Claim contract';

  @override
  String get vehicleHeistOpsClaimContractTitle => 'Contract claimen';

  @override
  String vehicleHeistOpsChopContractCompleted(String reward) {
    return 'Contract afgerond: +$reward';
  }

  @override
  String get vehicleHeistOpsChopNoEligibleVehicle =>
      'Geen geschikt voertuig in je inventaris voor dit contract.';

  @override
  String vehicleHeistOpsChopContractCooldownActive(String duration) {
    return 'Contract cooldown actief ($duration)';
  }

  @override
  String get vehicleHeistOpsChopContractClaimFailed =>
      'Contract claim mislukt.';

  @override
  String get vehicleHeistOpsInsuranceButton => 'Verzekering';

  @override
  String get vehicleHeistOpsInsuranceTitle => 'Smokkelverzekering';

  @override
  String get vehicleHeistOpsInsuranceBody =>
      'Kies een dekking voor deze voertuigcategorie.';

  @override
  String get vehicleHeistOpsInsuranceTierBasic => 'Basis';

  @override
  String get vehicleHeistOpsInsuranceTierPro => 'Pro';

  @override
  String vehicleHeistOpsInsuranceActive(String tier, String price) {
    return 'Verzekering actief ($tier) voor $price.';
  }

  @override
  String get vehicleHeistOpsInsurancePurchaseFailed =>
      'Verzekering aankopen mislukt.';

  @override
  String get vehicleHeistOpsCrewMatchButton => 'Crew-duel';

  @override
  String vehicleHeistOpsCrewMatchWon(String reward) {
    return 'Crew match gewonnen: +$reward';
  }

  @override
  String vehicleHeistOpsCrewMatchLost(String reward) {
    return 'Crew match verloren: +$reward troost';
  }

  @override
  String get vehicleHeistOpsCrewMatchFailed => 'Crew matchmaking mislukt.';

  @override
  String get vehicleHeistOpsCounterButton => 'Tegenactie';

  @override
  String vehicleHeistOpsCounterSuccess(String reward) {
    return 'Counter-intercept geslaagd: +$reward';
  }

  @override
  String get vehicleHeistOpsCounterFailed =>
      'Tegenintercept niet beschikbaar of mislukt.';

  @override
  String get vehicleHeistOpsOpsContractButton => 'Ops-contract';

  @override
  String get vehicleHeistOpsOpsContractTitle => 'Ops-contract';

  @override
  String vehicleHeistOpsContractCompleted(String reward) {
    return 'Ops contract afgerond: +$reward';
  }

  @override
  String get vehicleHeistOpsContractFailedOrCooldown =>
      'Ops contract mislukt of op cooldown.';

  @override
  String get vehicleHeistOpsClaimDisputeButton => 'Claim betwisten';

  @override
  String get vehicleHeistOpsNoOpenClaims => 'Geen open verzekeringsclaims.';

  @override
  String get vehicleHeistOpsNoValidClaimFound => 'Geen geldige claim gevonden.';

  @override
  String vehicleHeistOpsClaimApproved(String amount) {
    return 'Claim goedgekeurd: +$amount';
  }

  @override
  String vehicleHeistOpsClaimRejected(String amount) {
    return 'Claim afgewezen: -$amount';
  }

  @override
  String get vehicleHeistOpsClaimResolutionFailed =>
      'Claim-afhandeling mislukt.';

  @override
  String get vehicleHeistOpsIntelTitle => 'Voertuig Ops Inlichtingen';

  @override
  String get vehicleHeistOpsIntelRefreshTooltip => 'Ververs inlichtingen';

  @override
  String get vehicleHeistOpsIntelTapToExpand =>
      'Tik om te openen en alle acties te zien.';

  @override
  String vehicleHeistOpsIntelHeatPill(String current, String level) {
    return 'Hitte $current ($level)';
  }

  @override
  String vehicleHeistOpsIntelPolicePill(String name) {
    return 'Politie: $name';
  }

  @override
  String vehicleHeistOpsIntelRepPill(String level) {
    return 'Reputatie lvl $level';
  }

  @override
  String vehicleHeistOpsIntelPartsMarketPill(String trend) {
    return 'Onderdelenmarkt: $trend';
  }

  @override
  String vehicleHeistOpsIntelHotspotLine(String name) {
    return 'Hotspot: $name';
  }

  @override
  String vehicleHeistOpsIntelHotspotRewardLine(String min, String max) {
    return 'Beloning: $min - $max';
  }

  @override
  String get vehicleHeistOpsIntelWhyCashLine =>
      'Waarom krijg je geld: succesvolle ops-acties betalen direct uit op zakgeld.';

  @override
  String vehicleHeistOpsIntelCashRangePayout(String min, String max) {
    return 'Contant: $min - $max';
  }

  @override
  String vehicleHeistOpsIntelYouCashRangePayout(String min, String max) {
    return 'Jij: $min - $max';
  }

  @override
  String vehicleHeistOpsIntelCashPayout(String amount) {
    return 'Contant: $amount';
  }

  @override
  String vehicleHeistOpsIntelContractsPayout(String count, String fromPart) {
    return 'Contracten: $count$fromPart';
  }

  @override
  String vehicleHeistOpsIntelContractsFrom(String amount) {
    return ' | vanaf $amount';
  }

  @override
  String vehicleHeistOpsIntelPartsPricesLine(
    String car,
    String motorcycle,
    String boat,
  ) {
    return 'Partsprijzen (auto/motor/boot): $car / $motorcycle / $boat';
  }

  @override
  String vehicleHeistOpsIntelPartsMarketRefreshLine(String cooldown) {
    return 'Onderdelenmarkt refresh: $cooldown';
  }

  @override
  String vehicleHeistOpsIntelCrewLine(String name, String size) {
    return 'Crew: $name ($size leden)';
  }

  @override
  String vehicleHeistOpsIntelChopRewardLine(String reward) {
    return 'Chop-contract beloning: $reward';
  }

  @override
  String vehicleHeistOpsIntelInterceptWindowLine(String status) {
    return 'Intercept-venster: $status';
  }

  @override
  String vehicleHeistOpsIntelBlacklistLine(String reason) {
    return 'Zwarte lijst: $reason';
  }

  @override
  String get vehicleHeistOpsIntelBlacklistNoneLine => 'Blacklist: geen';

  @override
  String vehicleHeistOpsIntelInsuranceActiveLine(String tier) {
    return 'Verzekering: $tier actief';
  }

  @override
  String get vehicleHeistOpsIntelInsuranceInactiveLine =>
      'Verzekering: niet actief';

  @override
  String vehicleHeistOpsIntelCountryModifierLine(
    String name,
    String multiplier,
  ) {
    return 'Landmodifier: $name (${multiplier}x)';
  }

  @override
  String vehicleHeistOpsIntelCrewSeasonLine(String season, String points) {
    return 'Crew-seizoen: $season | punten $points';
  }

  @override
  String vehicleHeistOpsIntelContractsCooldownLine(
    String count,
    String cooldown,
  ) {
    return 'Contracten: $count | cooldown $cooldown';
  }

  @override
  String vehicleHeistOpsIntelCounterCooldownLine(
    String cooldown,
    String claims,
  ) {
    return 'Tegenactie cooldown: $cooldown | open claims: $claims';
  }

  @override
  String get tuneShop => 'Tuning shop';

  @override
  String get tuneShopIntro =>
      'Sloop voertuigen voor onderdelen en upgrade snelheid, stealth en pantser. Onderdelen zijn per categorie gedeeld (auto/motor/boot), dus je kunt elk voertuig binnen dezelfde categorie tunen.';

  @override
  String get tuneShopCarPartsLabel => 'Auto-onderdelen';

  @override
  String get tuneShopMotorcyclePartsLabel => 'Motor-onderdelen';

  @override
  String get tuneShopBoatPartsLabel => 'Boot-onderdelen';

  @override
  String get tuneShopEmptyTitle => 'Geen voertuigen om te tunen';

  @override
  String get tuneShopEmptyBody =>
      'Steel eerst voertuigen en sloop er een paar voor onderdelen.';

  @override
  String get tuneShopVehicleTypeCar => 'Auto';

  @override
  String get tuneShopVehicleTypeMotorcycle => 'Motor';

  @override
  String get tuneShopVehicleTypeBoat => 'Boot';

  @override
  String get tuneShopStatSpeed => 'Snelheid';

  @override
  String get tuneShopStatStealth => 'Stealth';

  @override
  String get tuneShopStatArmor => 'Pantser';

  @override
  String get tuneShopValueMultiplierPrefix => 'Waarde x';

  @override
  String get tuneShopUpgradeButton => 'Upgraden';

  @override
  String get tuneShopMaxLabel => 'MAX';

  @override
  String get tuneShopPartsAbbrev => 'ond';

  @override
  String get tuneShopUpgradeCompleted => 'Upgrade voltooid';

  @override
  String get tuneShopUpgradeFailed => 'Upgrade mislukt';

  @override
  String get tuneShopLockedVehicleInTransit =>
      'Tuning geblokkeerd: voertuig is onderweg.';

  @override
  String get tuneShopLockedVehicleInRepair =>
      'Tuning geblokkeerd: voertuig is in reparatie.';

  @override
  String tuneShopLockedCooldownActive(String duration) {
    return 'Tuning cooldown actief: nog $duration.';
  }

  @override
  String get tuneShopErrorVehicleNotFound => 'Voertuig niet gevonden';

  @override
  String get tuneShopErrorNotOwner => 'Je bezit dit voertuig niet';

  @override
  String get tuneShopErrorVehicleInTransit =>
      'Tuning geblokkeerd: voertuig is onderweg.';

  @override
  String get tuneShopErrorVehicleInRepair =>
      'Tuning geblokkeerd: voertuig is in reparatie.';

  @override
  String get tuneShopErrorInsufficientFunds => 'Niet genoeg geld';

  @override
  String get tuneShopErrorInsufficientParts => 'Niet genoeg onderdelen';

  @override
  String get tuneShopErrorStatMaxed => 'Dit tuningniveau is maximaal';

  @override
  String tuneShopErrorCooldownActive(String duration) {
    return 'Tuning cooldown actief: nog $duration.';
  }

  @override
  String tuneShopErrorConcurrencyLimit(String max, String active) {
    return 'Limiet bereikt: max $max tuning tegelijk, momenteel $active.';
  }

  @override
  String get tuneShopErrorInvalidStat => 'Ongeldige tuning-stat';

  @override
  String get territory => 'Territorium';

  @override
  String get achievements => 'Prestaties';

  @override
  String get menuCrackVault => 'Kraak de Kluis';

  @override
  String get vaultHeroTagline => 'Raad de code en win flinke prijzen.';

  @override
  String vaultSeasonLabel(String range) {
    return 'Ronde: $range';
  }

  @override
  String get vaultYourCredits => 'Jouw credits';

  @override
  String get vaultChooseStake => 'Kies je inzet';

  @override
  String vaultStakeCredits(int stake) {
    String _temp0 = intl.Intl.pluralLogic(
      stake,
      locale: localeName,
      other: '$stake credits',
      one: '$stake credit',
    );
    return '$_temp0';
  }

  @override
  String vaultExpectedPrize(int reward) {
    return 'Verwachte prijs: +$reward credits';
  }

  @override
  String get vaultCodeLabel => 'Code';

  @override
  String get vaultSubmitStake => 'Inzet';

  @override
  String get vaultWrongCodesTitle => 'Foute codes (deze maand)';

  @override
  String get vaultShowWrongCodes => 'Toon';

  @override
  String get vaultHideWrongCodes => 'Verberg';

  @override
  String get vaultNoWrongCodesYet => 'Nog geen foute codes opgeslagen.';

  @override
  String get couldNotLoadVaultStatus => 'Kon status niet laden.';

  @override
  String get vaultEnterFourDigitCode => 'Voer een 4-cijferige code in.';

  @override
  String get vaultAttemptSuccessGeneric => 'Gelukt.';

  @override
  String get vaultAttemptFailedGeneric => 'Mislukt.';

  @override
  String get vaultAttemptFailedRetry => 'Mislukt. Probeer opnieuw.';

  @override
  String dashboardNewMessagesCount(int count) {
    return '$count nieuwe berichten';
  }

  @override
  String get rankProgress => 'Rangvoortgang';

  @override
  String get cash => 'Geld';

  @override
  String get sessionRecap => 'Sessie-overzicht';

  @override
  String get nameLabel => 'Naam';

  @override
  String get countryLabel => 'Land';

  @override
  String get wantedLevel => 'Gezocht Niveau';

  @override
  String get fbiHeat => 'FBI-heat';

  @override
  String get properties => 'Eigendommen';

  @override
  String get vehicles => 'Voertuigen';

  @override
  String get netWorth => 'Netto waarde';

  @override
  String get securityLabel => 'Beveiliging';

  @override
  String get noSecurity => 'Geen beveiliging';

  @override
  String get weaponLabel => 'Wapen';

  @override
  String get vehicleLabel => 'Voertuig';

  @override
  String get none => 'Geen';

  @override
  String get statistics => 'Statistieken';

  @override
  String get breakouts => 'Uitbraken';

  @override
  String get murders => 'Moorden';

  @override
  String get hitlistContracts => 'Hitlist-contracten';

  @override
  String get carsStolen => 'Auto\'s gestolen';

  @override
  String get boatsStolen => 'Boten gestolen';

  @override
  String get crimeAttempts => 'Misdaadpogingen';

  @override
  String get successful => 'Geslaagd';

  @override
  String get jobAttempts => 'Werkpogingen';

  @override
  String get streetProstitutes => 'Straatprostituees';

  @override
  String get rldProstitutes => 'RLD-prostituees';

  @override
  String get travels => 'Reizen';

  @override
  String get bullets => 'Kogels';

  @override
  String get moneyStatusLabel => 'Geldstatus';

  @override
  String get moneyStatusPoor => 'Arm';

  @override
  String get moneyStatusRising => 'Stijgend';

  @override
  String get moneyStatusRich => 'Rijk';

  @override
  String get moneyStatusMultimillionaire => 'Multimiljonair';

  @override
  String get rankBeginner => 'Beginner';

  @override
  String get rankCriminal => 'Crimineel';

  @override
  String get rankGangster => 'Gangster';

  @override
  String get rankMafioso => 'Maffioso';

  @override
  String get rankGodfather => 'Peetvader';

  @override
  String get dailyGoalTitle_crime_3 => 'Pleeg 3 misdaden';

  @override
  String get dailyGoalTitle_job_2 => 'Werk 2 keer';

  @override
  String get dailyGoalTitle_vehicle_theft_1 => 'Steel 1 voertuig';

  @override
  String get dailyGoalTitle_travel_1 => 'Maak 1 reis';

  @override
  String get dailyGoalTitle_weekly_crime_20 => 'Week: 20 misdaden';

  @override
  String get dailyGoalTitle_weekly_job_10 => 'Week: 10× werken';

  @override
  String get dailyGoalTitle_weekly_vehicle_theft_5 =>
      'Week: steel 5 voertuigen';

  @override
  String get dailyGoalTitle_weekly_travel_3 => 'Week: 3 reizen';

  @override
  String dailyGoalReward(String cash, String xp) {
    return 'Beloning: +$cash en +$xp XP';
  }

  @override
  String get justNow => 'Zojuist';

  @override
  String secondsAgo(String seconds) {
    return '${seconds}s geleden';
  }

  @override
  String minutesAgo(String count) {
    return '$count minuten geleden';
  }

  @override
  String hoursAgo(String count) {
    return '$count uur geleden';
  }

  @override
  String get last10EventsLive => 'Laatste 10 events (live).';

  @override
  String get noEventsYetSession => 'Nog geen events in deze sessie.';

  @override
  String get clearRecap => 'Recap wissen';

  @override
  String get weeklyGoalClaimed => 'Weekdoel geclaimd!';

  @override
  String get dailyGoalClaimed => 'Dagdoel geclaimd!';

  @override
  String get failed => 'Mislukt.';

  @override
  String get failedPleaseTryAgain => 'Mislukt. Probeer opnieuw.';

  @override
  String get dailyGoals => 'Dagdoelen';

  @override
  String get weeklyGoals => 'Weekdoelen';

  @override
  String get claimed => 'Geclaimd';

  @override
  String get ready => 'Klaar';

  @override
  String get claim => 'Claim';

  @override
  String readyToClaim(String count) {
    return '$count klaar om te claimen';
  }

  @override
  String completedOutOfTotal(String completed, String total) {
    return '$completed/$total voltooid';
  }

  @override
  String get noPlayerData => 'Geen spelerdata';

  @override
  String get economy24h => 'Economie 24u';

  @override
  String get grossIncome => 'Bruto inkomsten';

  @override
  String get propertySpend => 'Vastgoed kosten';

  @override
  String get netCashflow => 'Netto cashflow';

  @override
  String get trendVsPrevious => 'Trend t.o.v. vorige';

  @override
  String get activity7d => 'Activiteit 7d';

  @override
  String get vehicleThefts => 'Voertuig diefstallen';

  @override
  String get opsOverview => 'Ops overzicht';

  @override
  String get activeCooldowns => 'Actieve cooldowns';

  @override
  String get longestTimer => 'Langste timer';

  @override
  String get activeProduction => 'Actieve productie';

  @override
  String get productionReadyIn => 'Productie klaar over';

  @override
  String get nightclubEvents => 'Nachtclubevenementen';

  @override
  String get nextEventStartsIn => 'Volgende event start over';

  @override
  String get vehiclesActiveListedTransit =>
      'Voertuigen actief/te koop/onderweg';

  @override
  String get livePlayerEvents => 'Live speler-events';

  @override
  String get openEvents => 'Open events';

  @override
  String get notificationsAndRisk => 'Notificaties & risico';

  @override
  String get unreadDm => 'Ongelezen DM';

  @override
  String get supportWaitingOnYou => 'Support wacht op jou';

  @override
  String get eventsLast24h => 'Events laatste 24u';

  @override
  String get riskScore => 'Risicoscore';

  @override
  String get recruitProstitute => 'Rekruteer prostituee';

  @override
  String get free => 'GRATIS';

  @override
  String get crewWars => 'Crew-oorlogen';

  @override
  String get status => 'Status';

  @override
  String get canDeclare => 'Kan verklaren';

  @override
  String get yes => 'Ja';

  @override
  String get no => 'Nee';

  @override
  String get type => 'Type';

  @override
  String get opponent => 'Tegenstander';

  @override
  String get crewPoints => 'Crew punten';

  @override
  String get warRank => 'Oorlogsrang';

  @override
  String get seasonRank => 'Seizoensrang';

  @override
  String get openTargets => 'Openstaande doelen';

  @override
  String get phaseEndsIn => 'Fase eindigt over';

  @override
  String get crewTerritory => 'Crewterritorium';

  @override
  String get regions => 'Regio\'s';

  @override
  String get countriesCaptured => 'Landen veroverd';

  @override
  String get payout => 'Uitbetaling';

  @override
  String get earningPerHour => 'Opbrengst per uur (nu)';

  @override
  String get earningPerDay => 'Opbrengst per dag (nu)';

  @override
  String get totalEarned => 'Totaal verdiend';

  @override
  String get crewBank => 'Crewbank';

  @override
  String get dashboardEconomy24h => 'Economie 24u';

  @override
  String get dashboardGrossIncome => 'Bruto inkomsten';

  @override
  String get dashboardPropertySpend => 'Vastgoed kosten';

  @override
  String get dashboardNetCashflow => 'Netto cashflow';

  @override
  String get dashboardTrendVsPrevious => 'Trend t.o.v. vorige';

  @override
  String get dashboardActivity7d => 'Activiteit 7d';

  @override
  String get dashboardVehicleThefts => 'Voertuig diefstallen';

  @override
  String get dashboardOpsOverview => 'Ops overzicht';

  @override
  String get dashboardActiveCooldowns => 'Actieve cooldowns';

  @override
  String get dashboardLongestTimer => 'Langste timer';

  @override
  String get dashboardActiveProduction => 'Actieve productie';

  @override
  String get dashboardProductionReadyIn => 'Productie klaar over';

  @override
  String get dashboardNightclubEvents => 'Nachtclubevenementen';

  @override
  String get dashboardNextEventStartsIn => 'Volgende event start over';

  @override
  String get dashboardVehiclesActiveListedTransit =>
      'Voertuigen actief/te koop/onderweg';

  @override
  String get dashboardLivePlayerEvents => 'Live speler-events';

  @override
  String get dashboardOpenEvents => 'Open events';

  @override
  String get dashboardNotificationsAndRisk => 'Notificaties & risico';

  @override
  String get dashboardUnreadDm => 'Ongelezen DM';

  @override
  String get dashboardSupportWaitingOnYou => 'Support wacht op jou';

  @override
  String get dashboardEventsLast24h => 'Events laatste 24u';

  @override
  String get dashboardRiskScore => 'Risicoscore';

  @override
  String get dashboardRecruitProstitute => 'Rekruteer prostituee';

  @override
  String get dashboardCrewWars => 'Crew-oorlogen';

  @override
  String get dashboardStatusLabel => 'Status';

  @override
  String get dashboardCanDeclare => 'Kan verklaren';

  @override
  String get dashboardTypeLabel => 'Type';

  @override
  String get dashboardOpponent => 'Tegenstander';

  @override
  String get dashboardCrewPoints => 'Crew punten';

  @override
  String get dashboardWarRank => 'Oorlogsrang';

  @override
  String get dashboardSeasonRank => 'Seizoensrang';

  @override
  String get dashboardOpenTargets => 'Openstaande doelen';

  @override
  String get dashboardPhaseEndsIn => 'Fase eindigt over';

  @override
  String dashboardJailStatusIn(String duration) {
    return 'In de gevangenis ($duration)';
  }

  @override
  String get dashboardCrewWarStatusPreparing => 'Voorbereiden';

  @override
  String get dashboardCrewWarStatusActive => 'Actief';

  @override
  String get dashboardCrewWarStatusLockdown => 'Lockdown';

  @override
  String get dashboardCrewWarStatusResolved => 'Opgelost';

  @override
  String get dashboardCrewWarStatusArchived => 'Gearchiveerd';

  @override
  String get dashboardCrewWarStatusCancelled => 'Geannuleerd';

  @override
  String get dashboardCrewWarStatusNone => 'Geen actieve oorlog';

  @override
  String get dashboardCrewWarTypeKill => 'Dood de oorlog';

  @override
  String get dashboardCrewWarTypeEconomy => 'Economie Oorlog';

  @override
  String get dashboardCrewWarTypeTerritory => 'Territoriumoorlog';

  @override
  String get dashboardCrewWarTypeTotal => 'Totale oorlog';

  @override
  String get dashboardTerritoryIncomeNotConfigured => 'niet geconfigureerd';

  @override
  String dashboardTerritoryIncomeEveryHours(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: 'every $hours hours',
      one: 'every hour',
    );
    return '$_temp0';
  }

  @override
  String dashboardTerritoryIncomeEveryMinutes(int minutes) {
    return 'elke $minutes min';
  }

  @override
  String get dashboardCrewTerritory => 'Crewterritorium';

  @override
  String get dashboardRegions => 'Regio\'s';

  @override
  String get dashboardCountriesCaptured => 'Landen veroverd';

  @override
  String get dashboardPayout => 'Uitbetaling';

  @override
  String get dashboardEarningPerHour => 'Opbrengst per uur (nu)';

  @override
  String get dashboardEarningPerDay => 'Opbrengst per dag (nu)';

  @override
  String get dashboardTotalEarned => 'Totaal verdiend';

  @override
  String get dashboardVehicleOps => 'Voertuigoperaties';

  @override
  String get dashboardKillProgress => 'Moordvoortgang';

  @override
  String get vehicleOpsHeat => 'Hitte';

  @override
  String get vehicleOpsHeatLevelLow => 'Laag';

  @override
  String get vehicleOpsHeatLevelMedium => 'Middel';

  @override
  String get vehicleOpsHeatLevelHigh => 'Hoog';

  @override
  String get vehicleOpsReputation => 'Reputatie';

  @override
  String get vehicleOpsPartsTrendUp => 'onderdelenmarkt stijgt';

  @override
  String get vehicleOpsPartsTrendDown => 'onderdelenmarkt daalt';

  @override
  String get vehicleOpsPartsTrendStable => 'onderdelenmarkt stabiel';

  @override
  String get vehicleOpsBlacklistActive => 'Zwarte lijst actief';

  @override
  String get vehicleOpsNoBlacklist => 'Geen zwarte lijst';

  @override
  String get prisonTitle => 'Gevangenis';

  @override
  String get prisonLoadFailed => 'Kon gevangenen niet laden';

  @override
  String get prisonNoPrisonersFound => 'Geen gevangenen gevonden';

  @override
  String prisonRankLine(String rank) {
    return 'Rang: $rank';
  }

  @override
  String prisonRankYouLine(String rank) {
    return 'Rank: $rank · Jij';
  }

  @override
  String prisonRemainingTimeLine(String duration) {
    return 'Resterende tijd: $duration';
  }

  @override
  String prisonBailLine(String amount) {
    return 'Borg: €$amount';
  }

  @override
  String get prisonPayBailButton => 'Betaal borg';

  @override
  String get prisonBuyOutButton => 'Uitkopen';

  @override
  String get prisonAttemptEscapeButton => 'Probeer uitbraak';

  @override
  String get prisonJailbreakButton => 'Uitbreken';

  @override
  String get prisonActionFailed => '❌ Actie mislukt';

  @override
  String prisonBuyoutSuccess(String username, String amount) {
    return '✅ $username is vrijgekocht voor €$amount';
  }

  @override
  String prisonPaidBailSuccess(String amount) {
    return '✅ Je bent vrijgekocht voor €$amount';
  }

  @override
  String get prisonEscapeSuccess => '✅ Ontsnapping gelukt! Je bent vrij.';

  @override
  String prisonEscapeFailed(String penalty) {
    return '❌ Ontsnapping mislukt. Straf verlengd met $penalty.';
  }

  @override
  String prisonCooldownActive(String duration) {
    return '⏱️ Cooldown actief: wacht nog $duration';
  }

  @override
  String get prisonEscapeGenericFailure => '❌ Uitbraak mislukt';

  @override
  String get prisonErrorInsufficientFunds => '❌ Onvoldoende geld';

  @override
  String get prisonErrorTargetNotJailed =>
      '❌ Doelwit zit niet meer in de gevangenis';

  @override
  String get prisonErrorCannotBuyoutSelf => '❌ Je kunt jezelf niet uitkopen';

  @override
  String get prisonErrorPlayerNotFound => '❌ Speler niet gevonden';

  @override
  String get prisonJailbreakSuccess => '✅ Uitbraak gelukt! Gevangene is vrij.';

  @override
  String prisonJailbreakCaught(String minutes) {
    return '🚔 Uitbraak mislukt, je bent gepakt ($minutes min cel).';
  }

  @override
  String get prisonJailbreakFailed =>
      '❌ Uitbraak mislukt. Gevangene zit nog vast.';

  @override
  String get prisonErrorRescuerJailed => '❌ Jij zit zelf in de cel';

  @override
  String get prisonJailbreakGenericFailure => '❌ Uitbraak mislukt';

  @override
  String get crewJailbreakTitle => '🚔 Gevangen Crew';

  @override
  String get crewJailbreakLoadFailed => 'Kon crew gevangenen niet laden';

  @override
  String get crewJailbreakEmptyTitle => '🎉 Niemand in de cel!';

  @override
  String get crewJailbreakEmptyBody => 'Alle crew members zijn vrij';

  @override
  String crewJailbreakAttemptFor(String username) {
    return 'Uitbraakpoging voor $username:';
  }

  @override
  String get crewJailbreakRiskSuccess => 'Bij succes: Speler vrij!';

  @override
  String get crewJailbreakRiskFailChance => 'Bij mislukking: 60% kans gepakt';

  @override
  String get crewJailbreakRiskCaughtPenalty =>
      'Gepakt: 30-60 min cel + wanted +10';

  @override
  String get crewJailbreakTip => 'Succes kans verhoogt met rank en crew bonus!';

  @override
  String get crewJailbreakAttemptButton => 'Probeer uitbraak';

  @override
  String get crewJailbreakActionFailed => '❌ Actie mislukt';

  @override
  String crewJailbreakMemberJailTimeLine(String minutes) {
    return '⏱️ $minutes minuten cel';
  }

  @override
  String get crewJailbreakRescueButton => 'Bevrijd';

  @override
  String get crewRoleLeader => 'Leider';

  @override
  String get crewRoleCoLeader => 'Co-leider';

  @override
  String get crewRoleMember => 'Lid';

  @override
  String get vehicleOpsHotspot => 'Hotspot';

  @override
  String get vehicleOpsCrew => 'Bemanning';

  @override
  String get vehicleOpsCrewMatch => 'Crew-match';

  @override
  String get vehicleOpsChop => 'Sloperij';

  @override
  String get vehicleOpsContract => 'Contract';

  @override
  String get vehicleOpsCounter => 'Tegenactie';

  @override
  String get vehicleOpsContracts => 'Contracten';

  @override
  String get vehicleOpsClaims => 'Schadeclaims';

  @override
  String get vehicleOpsSeason => 'Seizoen';

  @override
  String get dashboardCar => 'Auto';

  @override
  String get dashboardMotorcycle => 'Motor';

  @override
  String get dashboardBoat => 'Boot';

  @override
  String get dashboardCrewAccess => 'Crew-toegang';

  @override
  String get dashboardCrewRole => 'Crew-rol';

  @override
  String get dashboardUnavailable => 'niet beschikbaar';

  @override
  String get vehicleOps => 'Voertuigoperaties';

  @override
  String get car => 'Auto';

  @override
  String get motorcycle => 'Motor';

  @override
  String get boat => 'Boot';

  @override
  String get crewAccess => 'Crew-toegang';

  @override
  String get crewRole => 'Crew-rol';

  @override
  String get unavailable => 'niet beschikbaar';

  @override
  String get quickActionsCrimesSubtitle => 'Pleeg misdaden';

  @override
  String get quickActionsVehicleHeistSubtitle => 'Auto, motor en boot';

  @override
  String get quickActionsTuneShopSubtitle => 'Onderdelen en upgrades';

  @override
  String get quickActionsEventsSubtitle => 'Actieve en aankomende events';

  @override
  String get quickActionsJobsSubtitle => 'Verdien legaal geld';

  @override
  String get quickActionsCasinoSubtitle => 'Gok met je geld';

  @override
  String get quickActionsBankSubtitle => 'Beheer je globale saldo';

  @override
  String money(String amount) {
    return '€$amount';
  }

  @override
  String get health => 'Gezondheid';

  @override
  String get rank => 'Rang';

  @override
  String get xp => 'XP';

  @override
  String get settings => 'Instellingen';

  @override
  String get avatar => 'Avatar';

  @override
  String get avatarUpdated => 'Avatar bijgewerkt!';

  @override
  String get avatarChangeFailed => 'Kan de avatar niet wijzigen';

  @override
  String error(String error) {
    return 'Fout: $error';
  }

  @override
  String get changeLanguage => 'Taal / Language';

  @override
  String get languageChanged => 'Taal gewijzigd naar Nederlands';

  @override
  String languageChangeFailed(String code) {
    return 'Taal wijzigen mislukt ($code)';
  }

  @override
  String get chooseLanguage => 'Taal Kiezen / Choose Language';

  @override
  String get dutch => 'Nederlands';

  @override
  String get english => 'Engels';

  @override
  String get cancel => 'Annuleren';

  @override
  String get changeUsername => 'Gebruikersnaam Wijzigen';

  @override
  String get usernameHint => '3-20 karakters';

  @override
  String get change => 'Wijzigen';

  @override
  String get minChars => 'Minimaal 3 karakters';

  @override
  String get usernameUpdated => 'Gebruikersnaam bijgewerkt!';

  @override
  String get usernameTaken => 'Gebruikersnaam al in gebruik';

  @override
  String get usernameChangeFailed => 'Kan gebruikersnaam niet wijzigen';

  @override
  String get oncePerMonth => '1x per maand wijzigen';

  @override
  String get privacy => 'Privacy';

  @override
  String get allowMessages => 'Berichten toestaan';

  @override
  String get allowMessagesDesc => 'Andere spelers kunnen je berichten sturen';

  @override
  String get settingsSystemNotificationsTitle => 'Systeemmeldingen voor app';

  @override
  String get settingsPushPermissionAllowedLinked =>
      'Toestemming: toegestaan, apparaat gekoppeld';

  @override
  String get settingsPushPermissionAllowedRelinking =>
      'Toestemming: toegestaan, apparaat wordt opnieuw gekoppeld';

  @override
  String get settingsPushPermissionProvisionalLinked =>
      'Toestemming: voorlopig, apparaat gekoppeld';

  @override
  String get settingsPushPermissionProvisionalRelinking =>
      'Toestemming: voorlopig, apparaat wordt opnieuw gekoppeld';

  @override
  String get settingsPushPermissionDenied => 'Toestemming: geweigerd';

  @override
  String get settingsPushPermissionNotRequested =>
      'Toestemming: nog niet aangevraagd';

  @override
  String get settingsPushPermissionUnknown => 'Toestemming: onbekend';

  @override
  String get settingsDeviceTokenRegistered =>
      'Apparaattoken geregistreerd op de server';

  @override
  String get settingsDeviceTokenNotRegistered =>
      'Er is nog geen apparaattoken geregistreerd';

  @override
  String get settingsPushHelpText =>
      'Met deze knop kunt u opnieuw browser/iPhone-toestemming aanvragen en uw pushtoken registreren.';

  @override
  String get working => 'Werken...';

  @override
  String get settingsEnablePush => 'Schakel push in';

  @override
  String get settingsPushEnabledToast =>
      'Pushmeldingen ingeschakeld. Er worden nu nieuwe meldingen ontvangen.';

  @override
  String get settingsPushDisabledInSystem =>
      'Push is uitgeschakeld in uw browser-/iPhone-instellingen. Schakel meldingen in voor deze app.';

  @override
  String settingsEnablePushFailed(String error) {
    return 'Kan pushmeldingen niet inschakelen: $error';
  }

  @override
  String get settingsPlayerEventsTitle => 'Speler evenementen';

  @override
  String get settingsPushLivePlayerEventsTitle =>
      'Push: live spelersevenementen';

  @override
  String get settingsPushLivePlayerEventsSubtitle =>
      'Begin en einde van terugkerende competitie-evenementen (bijvoorbeeld topscorerondes).';

  @override
  String get settingsCryptoNotificationsTitle => 'Crypto-meldingen';

  @override
  String get settingsCryptoPushTradesTitle => 'Push: transacties';

  @override
  String get settingsCryptoPushTradesSubtitle =>
      'Pushmelding voor koop-/verkooptransacties';

  @override
  String get settingsCryptoPushPriceAlertsTitle => 'Push: prijswaarschuwingen';

  @override
  String get settingsCryptoPushPriceAlertsSubtitle =>
      'Pushmelding voor relevante prijsbewegingen';

  @override
  String get settingsCryptoPushOrdersTitle => 'Push: bestellingen';

  @override
  String get settingsCryptoPushOrdersSubtitle =>
      'Pushmelding wanneer de bestelling wordt geactiveerd of gevuld';

  @override
  String get settingsCryptoPushMissionsTitle => 'Push: missies';

  @override
  String get settingsCryptoPushMissionsSubtitle =>
      'Pushmelding wanneer een cryptomissie is voltooid';

  @override
  String get settingsCryptoPushLeaderboardTitle => 'Push: klassement';

  @override
  String get settingsCryptoPushLeaderboardSubtitle =>
      'Pushmelding voor crypto-leaderboard-beloningen';

  @override
  String get settingsCryptoInAppTradesTitle => 'In-app: transacties';

  @override
  String get settingsCryptoInAppTradesSubtitle =>
      'Toon handelsevenementen in uw evenementenfeed';

  @override
  String get settingsCryptoInAppPriceAlertsTitle =>
      'In-app: prijswaarschuwingen';

  @override
  String get settingsCryptoInAppPriceAlertsSubtitle =>
      'Toon prijswaarschuwingsgebeurtenissen in uw evenementenfeed';

  @override
  String get settingsCryptoInAppOrdersTitle => 'In-app: bestellingen';

  @override
  String get settingsCryptoInAppOrdersSubtitle =>
      'Toon bestelgebeurtenissen in uw evenementenfeed';

  @override
  String get settingsCryptoInAppMissionsTitle => 'In-app: missies';

  @override
  String get settingsCryptoInAppMissionsSubtitle =>
      'Toon voltooide missies in je evenementenfeed';

  @override
  String get settingsCryptoInAppLeaderboardTitle => 'In-app: klassement';

  @override
  String get settingsCryptoInAppLeaderboardSubtitle =>
      'Toon klassementbeloningen in uw evenementenfeed';

  @override
  String get settingsAvatarChangeWeeklyLimit =>
      'Je kunt je avatar slechts één keer per week wijzigen';

  @override
  String get settingsUsernameChangeMonthlyLimit =>
      'U kunt uw gebruikersnaam slechts één keer per maand wijzigen';

  @override
  String get settingsSaved => 'Instellingen opgeslagen';

  @override
  String get vipStatus => 'VIP-status';

  @override
  String activeUntil(String date) {
    return 'Actief tot $date';
  }

  @override
  String get unknown => 'Onbekend';

  @override
  String get chooseAvatar => 'Kies een Avatar';

  @override
  String get freeAvatars => 'Gratis Avatars';

  @override
  String get vipAvatars => 'VIP-avatars';

  @override
  String get vip => 'VIP';

  @override
  String get notLoggedIn => 'Niet ingelogd';

  @override
  String get refresh => 'Vernieuwen';

  @override
  String get foodAndDrink => 'Eten & Drinken';

  @override
  String get invalidItem => 'Dit item bestaat niet';

  @override
  String get foodBroodje => 'Broodje';

  @override
  String get foodPizza => 'Pizza';

  @override
  String get foodBurger => 'Hamburger';

  @override
  String get foodSteak => 'Steak';

  @override
  String get drinkWater => 'Water';

  @override
  String get drinkSoda => 'Frisdrank';

  @override
  String get drinkCoffee => 'Koffie';

  @override
  String get drinkBeer => 'Bier';

  @override
  String get foodInfo3 =>
      '• Koop eten en drinken om je stats op peil te houden';

  @override
  String get friends => 'Vrienden';

  @override
  String get friendActivity => 'Vriend Activiteit';

  @override
  String get propertiesAvailable => 'Beschikbaar';

  @override
  String get myProperties => 'Mijn Eigendommen';

  @override
  String get errorLoadingMyProperties => 'Fout bij laden mijn eigendommen';

  @override
  String get errorBuyingProperty => 'Fout bij kopen';

  @override
  String get errorCollectingIncome => 'Fout bij verzamelen';

  @override
  String get noAvailableProperties => 'Geen beschikbare eigendommen';

  @override
  String get noOwnedProperties => 'Je hebt nog geen eigendommen';

  @override
  String get buyFirstPropertyHint =>
      'Koop je eerste eigendom in de \"Beschikbaar\" tab';

  @override
  String buyPropertyConfirm(String name, String price) {
    return 'Wil je $name kopen voor €$price?';
  }

  @override
  String get propertyPrice => 'Prijs';

  @override
  String get propertyMinLevel => 'Vereist level';

  @override
  String get propertyIncomePerHour => 'Inkomen/uur';

  @override
  String get propertyMaxLevel => 'Maximaal niveau';

  @override
  String get propertyUniquePerCountry => '⚠️ Uniek - 1 per land';

  @override
  String get propertyIncomeReady => '✅ Inkomen klaar om te verzamelen!';

  @override
  String propertyNextIncome(String duration) {
    return '⏱️ Volgende inkomen over $duration';
  }

  @override
  String get propertyBuyAction => 'Koop Eigendom';

  @override
  String get propertyCollectAction => 'Verzamel';

  @override
  String get propertyUpgradeAction => 'Upgraden';

  @override
  String get propertyMax => 'MAX';

  @override
  String propertyLevel(String level) {
    return 'Niveau $level';
  }

  @override
  String durationHoursMinutes(String hours, String minutes) {
    return '${hours}u ${minutes}m';
  }

  @override
  String durationMinutes(String minutes) {
    return '${minutes}m';
  }

  @override
  String get propertyTypeHouse => 'Huis';

  @override
  String get propertyTypeWarehouse => 'Magazijn';

  @override
  String get propertyTypeCasino => 'Casino';

  @override
  String get propertyTypeHotel => 'Hotel';

  @override
  String get propertyTypeFactory => 'Fabriek';

  @override
  String get propertyTypeBusiness => 'Bedrijf';

  @override
  String get propertyCasinoName => 'Casino';

  @override
  String get propertyWarehouseName => 'Magazijn';

  @override
  String get propertyNightclubName => 'Nachtclub';

  @override
  String get propertyHouseName => 'Huis';

  @override
  String get propertyApartmentName => 'Appartement';

  @override
  String get propertyShopName => 'Winkel';

  @override
  String get blackMarket => 'Zwarte Markt';

  @override
  String get garage => 'Garage';

  @override
  String get garageCapacity => 'Garage Capaciteit';

  @override
  String garageVehiclesCount(String current, String total) {
    return '$current / $total voertuigen';
  }

  @override
  String garageUpgradeWithCost(String cost) {
    return 'Upgraden (€$cost)';
  }

  @override
  String get garageMaxLevel => 'Maximaal niveau';

  @override
  String garageLevelRemaining(String level, String spots) {
    return 'Level $level | $spots plekken over';
  }

  @override
  String get noCarsInGarage => 'Geen auto\'s in je garage';

  @override
  String get stealCarsToStart => 'Steel wat auto\'s om te beginnen!';

  @override
  String get stealFailed => 'Stelen mislukt';

  @override
  String get garageUpgradeFailed => 'Upgrade garage mislukt';

  @override
  String get saleFailed => 'Verkoop mislukt';

  @override
  String get vehicleTransported => 'Voertuig succesvol getransporteerd!';

  @override
  String get vehicleTransportFailed => 'Transport mislukt';

  @override
  String get listOnMarket => 'Plaats op markt';

  @override
  String marketValue(String amount) {
    return 'Marktwaarde: €$amount';
  }

  @override
  String get askingPrice => 'Vraagprijs (€)';

  @override
  String get enterPrice => 'Voer prijs in';

  @override
  String get list => 'Plaats';

  @override
  String get invalidPrice => 'Ongeldige prijs';

  @override
  String get vehicleListed => 'Voertuig op de markt gezet!';

  @override
  String get listVehicleFailed => 'Plaatsen mislukt';

  @override
  String get marina => 'Jachthaven';

  @override
  String get hospital => 'Ziekenhuis';

  @override
  String get court => 'Rechtbank';

  @override
  String get casino => 'Casino';

  @override
  String get errorLoadingCasinoStatus => 'Kon casino status niet controleren';

  @override
  String get errorLoadingCasinoGames => 'Kon casino spellen niet laden';

  @override
  String casinoPrice(String amount) {
    return 'Prijs: €$amount';
  }

  @override
  String get startingCapital => 'Startkapitaal';

  @override
  String get bankrollHelper => 'Dit wordt de casino kas';

  @override
  String get casinoOwnershipInfoTitle => 'Over casino eigendom:';

  @override
  String get casinoClosedTitle => 'CASINO GESLOTEN';

  @override
  String get casinoOwnedByLabel => 'Dit casino is eigendom van:';

  @override
  String get casinoNoOwner => 'Dit casino heeft nog geen eigenaar';

  @override
  String get casinoPurchasePriceLabel => 'Aankoopprijs:';

  @override
  String get casinoOwnerInfo =>
      'Als eigenaar beheer je de casino bankroll en verdien je geld wanneer spelers verliezen!';

  @override
  String get casinoGameSlotsName => 'Gokautomaat';

  @override
  String get casinoGameSlotsDesc => 'Draai de rollen en win tot 100x je inzet!';

  @override
  String get casinoGameBlackjackName => 'Blackjack';

  @override
  String get casinoGameBlackjackDesc =>
      'Versla de dealer en win tot 2x je inzet!';

  @override
  String get casinoGameRouletteName => 'Roulette';

  @override
  String get casinoGameRouletteDesc =>
      'Kies je nummer en win tot 35x je inzet!';

  @override
  String get casinoGameDiceName => 'Dobbelstenen';

  @override
  String get casinoGameDiceDesc =>
      'Gooi de dobbelstenen en win tot 6x je inzet!';

  @override
  String get difficultyEasy => 'MAKKELIJK';

  @override
  String get difficultyMedium => 'GEMIDDELD';

  @override
  String get difficultyHard => 'MOEILIJK';

  @override
  String get casinoDepositTitle => 'Geld Storten';

  @override
  String get casinoWithdrawTitle => 'Geld Opnemen';

  @override
  String get amount => 'Bedrag';

  @override
  String get deposit => 'Storten';

  @override
  String get withdraw => 'Opnemen';

  @override
  String casinoDepositSuccess(String amount) {
    return '€$amount gestort in casino kas';
  }

  @override
  String casinoWithdrawSuccess(String amount) {
    return '€$amount opgenomen uit casino kas';
  }

  @override
  String get casinoDepositError => 'Fout bij storten';

  @override
  String get casinoWithdrawError => 'Fout bij opnemen';

  @override
  String get casinoMinBankroll => 'Minimaal €10.000 moet in de kas blijven';

  @override
  String casinoMaxWithdraw(String amount) {
    return 'Maximaal: €$amount';
  }

  @override
  String get casinoManagementTitle => 'Casino Beheer';

  @override
  String casinoBankruptWarning(String amount) {
    return 'WAARSCHUWING: Casino kas te laag!\nStort minimaal €$amount om faillissement te voorkomen.';
  }

  @override
  String get casinoBankroll => 'Casino Kas';

  @override
  String get casinoStatsTitle => 'Statistieken';

  @override
  String get casinoTotalReceived => 'Totaal Ontvangen:';

  @override
  String get casinoTotalPaidOut => 'Totaal Uitbetaald:';

  @override
  String get casinoNetProfit => 'Netto Winst:';

  @override
  String casinoProfitMargin(String percent) {
    return 'Winstmarge: $percent%';
  }

  @override
  String get casinoManagementInfoTitle => 'Casino Beheer Info';

  @override
  String get casinoManagementInfo5 =>
      '• Je kunt op elk moment geld storten of opnemen';

  @override
  String get casinoHubChooseGameHint => 'Kies een spel en plaats je inzet';

  @override
  String get casinoPlayButton => 'Spelen';

  @override
  String get casinoGameBaccaratName => 'Baccarat';

  @override
  String get casinoGameBaccaratDesc =>
      'Zet in op speler, bankier of gelijkspel met strategische odds.';

  @override
  String get casinoGameVideoPokerName => 'Video Poker';

  @override
  String get casinoGameVideoPokerDesc =>
      'Trek 5 kaarten en maak combinaties tot Royal Flush.';

  @override
  String get casinoBuyCasinoLockedTitle =>
      'Casino kopen (vereisten niet gehaald)';

  @override
  String get casinoErrGenericPlay => 'Er ging iets mis';

  @override
  String get casinoErrSpinFailed => 'Fout bij draaien';

  @override
  String get casinoErrBetFailed => 'Fout bij inzet';

  @override
  String get casinoErrGambleFailed => 'Fout bij gokken';

  @override
  String get casinoErrThrowFailed => 'Fout bij gooien';

  @override
  String get casinoErrCasinoNotFound =>
      'Casino niet gevonden. Zorg dat het casino in dit land is gekocht.';

  @override
  String get casinoErrInsufficientFunds => 'Niet genoeg geld';

  @override
  String get casinoErrInsufficientBankrollPayout =>
      'Casino kas te laag voor deze uitbetaling';

  @override
  String casinoErrNetwork(String error) {
    return 'Netwerkfout: $error';
  }

  @override
  String get casinoResultYouWon => 'Gewonnen!';

  @override
  String get casinoResultYouLost => 'Verloren';

  @override
  String get casinoResultYouWonCelebrate => '🎉 Gewonnen!';

  @override
  String casinoWonEuroAmount(String amount) {
    return 'Je hebt €$amount gewonnen!';
  }

  @override
  String casinoLostEuroAmount(String amount) {
    return 'Je hebt €$amount verloren';
  }

  @override
  String get casinoYouLostPlain => 'Je hebt verloren';

  @override
  String casinoBlackjackWinAmount(String amount) {
    return 'Je hebt €$amount gewonnen!';
  }

  @override
  String casinoBlackjackCelebrate(String amount) {
    return 'BLACKJACK! €$amount';
  }

  @override
  String get casinoAgain => 'Opnieuw';

  @override
  String get casinoBankruptTitle => 'Casino failliet!';

  @override
  String get casinoBankruptBody =>
      'Het casino is failliet gegaan!\n\nDe eigenaar had niet genoeg geld in de kas om alle uitbetalingen te dekken.\n\nHet casino is nu gesloten en kan opnieuw gekocht worden.';

  @override
  String get casinoBackToCasino => 'Terug naar casino';

  @override
  String casinoRouletteNumberColor(String number, String color) {
    return 'Nummer: $number ($color)';
  }

  @override
  String get casinoColorGreen => 'groen';

  @override
  String get casinoColorRed => 'rood';

  @override
  String get casinoColorBlack => 'zwart';

  @override
  String get casinoRoulettePickBet => 'Kies je inzet';

  @override
  String get casinoRouletteBetRed => 'Rood';

  @override
  String get casinoRouletteBetBlack => 'Zwart';

  @override
  String get casinoRouletteBetEven => 'Even';

  @override
  String get casinoRouletteBetOdd => 'Oneven';

  @override
  String get casinoRouletteSpinButton => 'DRAAI!';

  @override
  String casinoRouletteLastResult(String number) {
    return 'Laatste resultaat: $number';
  }

  @override
  String get casinoBetLabel => 'Inzet';

  @override
  String get casinoBlackjackPlayButton => 'SPELEN!';

  @override
  String get casinoSlotSpinButton => 'SPIN!';

  @override
  String get casinoDiceRollButton => 'GOOI!';

  @override
  String get casinoBlackjackYourCards => 'Jouw kaarten';

  @override
  String get casinoBlackjackDealerCards => 'Dealer kaarten';

  @override
  String casinoBlackjackDealerTotal(String total) {
    return 'Dealer: $total';
  }

  @override
  String casinoBlackjackYouTotal(String total) {
    return 'Jij: $total';
  }

  @override
  String casinoDiceTotalShowing(String total) {
    return 'Totaal: $total';
  }

  @override
  String get casinoDicePredictTitle => 'Voorspel';

  @override
  String get casinoDiceLowLabel => 'Laag (2-6)';

  @override
  String get casinoDiceHighLabel => 'Hoog (8-12)';

  @override
  String get casinoDiceOddsHint =>
      'Laag/Hoog betaalt 2x • Exacte score betaalt 6x';

  @override
  String get casinoSlotPayoutTableTitle => 'Uitbetalingstabel';

  @override
  String get casinoBaccaratPlayer => 'Speler';

  @override
  String get casinoBaccaratBanker => 'Bankier';

  @override
  String get casinoBaccaratTieBet => 'Gelijk';

  @override
  String casinoWinnerPrefix(String who) {
    return 'Winnaar: $who';
  }

  @override
  String casinoPayoutEuro(String amount) {
    return 'Uitbetaling: €$amount';
  }

  @override
  String get casinoNoPayout => 'Geen uitbetaling';

  @override
  String casinoResultEuro(String amount) {
    return 'Resultaat: €$amount';
  }

  @override
  String get casinoDealing => 'Delen…';

  @override
  String get casinoDealCaps => 'DEAL';

  @override
  String get casinoVideoPokerDrawCards => 'TREK KAARTEN';

  @override
  String get casinoVideoPokerDrawHint => 'Trek je hand';

  @override
  String get casinoVideoPokerRoyalFlush => 'Royal Flush';

  @override
  String get casinoVideoPokerStraightFlush => 'Straight Flush';

  @override
  String get casinoVideoPokerFourKind => 'Four of a Kind';

  @override
  String get casinoVideoPokerFullHouse => 'Full House';

  @override
  String get casinoVideoPokerFlush => 'Flush';

  @override
  String get casinoVideoPokerStraight => 'Straight';

  @override
  String get casinoVideoPokerThreeKind => 'Three of a Kind';

  @override
  String get casinoVideoPokerTwoPair => 'Two Pair';

  @override
  String get casinoVideoPokerJacksOrBetter => 'Jacks or Better';

  @override
  String get casinoVideoPokerNoWinningHand => 'Geen winnende hand';

  @override
  String get casinoVideoPokerPayoutTableLong =>
      'Uitbetalingstabel: Jacks+ 1x • Two Pair 2x • Trips 3x • Straight 4x • Flush 6x • Full House 9x • Four 25x • Straight Flush 50x • Royal 250x';

  @override
  String get retry => 'Opnieuw proberen';

  @override
  String get doAction => 'Doe';

  @override
  String get pay => 'Betaling';

  @override
  String get success => 'Succes';

  @override
  String get jail => 'Gevangenis';

  @override
  String get cooldown => 'Afkoelen';

  @override
  String get requiredRank => 'Vereiste speler rank';

  @override
  String get playerRankLabel => 'Speler rank';

  @override
  String get loading => 'Laden...';

  @override
  String get trade => 'Handel';

  @override
  String get buy => 'Kopen';

  @override
  String get sell => 'Verkopen';

  @override
  String get price => 'Prijs';

  @override
  String get total => 'Totaal';

  @override
  String available(String count) {
    return 'Beschikbaar: $count';
  }

  @override
  String get notEnoughMoney => 'Je hebt niet genoeg geld!';

  @override
  String get confirm => 'Bevestigen';

  @override
  String get close => 'Sluiten';

  @override
  String get viewOffer => 'Bekijk aanbieding';

  @override
  String get unexpectedResponse => 'Onverwachte API response';

  @override
  String get errorLoadingMenu => 'Fout bij laden menu';

  @override
  String get unknownError => 'Onbekende fout';

  @override
  String get food => 'Eten';

  @override
  String get drink => 'Drinken';

  @override
  String get work => 'Werk';

  @override
  String cooldownMinutes(String minutes) {
    return 'Afkoelperiode: $minutes min';
  }

  @override
  String xpReward(String amount) {
    return 'XP: +$amount';
  }

  @override
  String get fly => 'Vliegen';

  @override
  String get purchased => 'Gekocht!';

  @override
  String get sold => 'Verkocht!';

  @override
  String get errorBuying => 'Fout bij kopen';

  @override
  String get errorSelling => 'Fout bij verkopen';

  @override
  String get goods => 'Goederen';

  @override
  String get marketplace => 'Marktplaats';

  @override
  String get myListings => 'Mijn Advertenties';

  @override
  String get inventory => 'Inventaris';

  @override
  String get backpacks => 'Rugzakken';

  @override
  String get materials => 'Materialen';

  @override
  String get production => 'Productie';

  @override
  String get stock => 'Voorraad';

  @override
  String get retryAgain => 'Opnieuw proberen';

  @override
  String get noVehiclesAvailable => 'Geen voertuigen beschikbaar';

  @override
  String get noListings => 'Geen advertenties';

  @override
  String get condition => 'Conditie';

  @override
  String get yourHealth => 'Je Gezondheid';

  @override
  String get criticalHealthWarning =>
      '⚠️ KRITIEK! Je moet direct naar het ziekenhuis!';

  @override
  String get lowHealthWarning => '⚠️ Lage gezondheid! Wees voorzichtig.';

  @override
  String get information => 'Informatie';

  @override
  String get contrabandFlowersName => 'Bloemen';

  @override
  String get contrabandFlowersDesc =>
      'Nederlandse tulpen en andere bloemen voor internationale handel';

  @override
  String get contrabandElectronicsName => 'Elektronica';

  @override
  String get contrabandElectronicsDesc =>
      'Geavanceerde elektronica en computeronderdelen';

  @override
  String get contrabandDiamondsName => 'Diamanten';

  @override
  String get contrabandDiamondsDesc => 'Onbewerkte en geslepen diamanten';

  @override
  String get contrabandWeaponsName => 'Wapens';

  @override
  String get contrabandWeaponsDesc => 'Illegale wapens en munitie';

  @override
  String get contrabandPharmaceuticalsName => 'Farmaceutica';

  @override
  String get contrabandPharmaceuticalsDesc =>
      'Zeldzame farmaceutische producten';

  @override
  String get multiplier => 'Vermenigvuldiger';

  @override
  String get sellPrice => 'Verkoopprijs';

  @override
  String get boughtFor => 'Gekocht voor';

  @override
  String get profit => 'Winst';

  @override
  String get loss => 'Verlies';

  @override
  String ownedQuantity(String quantity) {
    return 'In bezit: $quantity';
  }

  @override
  String spoilsInHours(String hours) {
    return '⚠️ Bederft over ${hours}u';
  }

  @override
  String get spoiledWorthless => '💀 BEDORVEN - Waardeloos';

  @override
  String get vehicleBought => 'Voertuig succesvol gekocht!';

  @override
  String get purchaseFailed => 'Aankoop mislukt';

  @override
  String get listingRemoved => 'Advertentie verwijderd';

  @override
  String get noItemsInInventory => 'Geen items in inventaris';

  @override
  String get buyItemsInBuyTab => 'Koop items in het Kopen-tabblad';

  @override
  String errorLoadingMarketData(String error) {
    return 'Fout bij laden marktgegevens: $error';
  }

  @override
  String get appeal => 'Hoger Beroep';

  @override
  String get submitAppeal => 'Beroep indienen';

  @override
  String get bribeJudge => 'Rechter omkopen';

  @override
  String get bribe => 'Omkopen';

  @override
  String get courtLoadFailed =>
      'Kon rechtbankgegevens niet laden. Probeer opnieuw.';

  @override
  String get courtAppealDialogIntro =>
      'Wil je hoger beroep indienen voor deze veroordeling?';

  @override
  String courtCostLine(String amount) {
    return 'Kosten: $amount';
  }

  @override
  String courtJudgeNamed(String name) {
    return 'Rechter: $name';
  }

  @override
  String courtCorruptibilityPercent(String percent) {
    return 'Corruptibiliteit: $percent%';
  }

  @override
  String get courtAppealSuccessHint =>
      'Bij succes: ongeveer 20-40% strafvermindering';

  @override
  String courtAppealGrantedMinutes(String minutes) {
    return 'Hoger beroep geslaagd. Nieuwe straf: $minutes minuten.';
  }

  @override
  String get courtAppealDenied => 'Hoger beroep afgewezen.';

  @override
  String get courtBribeOfferIntro =>
      'Bied een bedrag aan. Het bedrag wordt altijd afgeschreven, ook bij mislukking.';

  @override
  String courtBribeAmountFormatted(String amount) {
    return 'Omkoopsom: $amount';
  }

  @override
  String courtBribeSliderLabel(String thousands) {
    return '€${thousands}k';
  }

  @override
  String courtEstimatedSuccessChance(String percent) {
    return 'Geschatte slagingskans: ~$percent%';
  }

  @override
  String get courtBribeSuccessReleased =>
      'Rechter omgekocht. Je bent direct vrij.';

  @override
  String get courtBribeFailedDebited =>
      'Omkoping mislukt. Bedrag is wel afgeschreven.';

  @override
  String get courtRecordActive => 'Actief';

  @override
  String get courtRecordServed => 'Afgerond';

  @override
  String courtHistoryAppealGranted(String fromMinutes, String toMinutes) {
    return 'Hoger beroep toegekend: $fromMinutes → $toMinutes minuten';
  }

  @override
  String courtHistoryAppealDenied(String minutes) {
    return 'Hoger beroep afgewezen: $minutes minuten bleef staan';
  }

  @override
  String courtHistoryBribeFailedPaid(String amount) {
    return 'Omkoping mislukt: $amount betaald';
  }

  @override
  String courtHistoryConvictedMinutes(String minutes) {
    return 'Veroordeeld tot $minutes minuten';
  }

  @override
  String get courtPartialLoadWarning =>
      'Let op: een deel van de rechtbankdata kon niet laden. Trek omlaag om opnieuw te proberen.';

  @override
  String get courtNoActiveSentence => 'Geen actieve straf';

  @override
  String get courtNotJailedHint =>
      'Je zit momenteel niet vast. Je strafblad blijft hieronder zichtbaar.';

  @override
  String get courtActiveSentenceTitle => 'Actieve veroordeling';

  @override
  String get courtDelictLabel => 'Delict';

  @override
  String courtTotalSentenceMinutes(String minutes) {
    return 'Totale straf: $minutes minuten';
  }

  @override
  String courtRemainingMinutes(String minutes) {
    return 'Resterend: $minutes minuten';
  }

  @override
  String courtAppealCostCurrent(String amount) {
    return 'Beroepskosten nu: $amount';
  }

  @override
  String get courtButtonAppeal => 'Hoger beroep';

  @override
  String get courtButtonBribeJudge => 'Rechter omkopen';

  @override
  String get courtUnknownCrime => 'Onbekend';

  @override
  String courtSentenceMinutesOnly(String minutes) {
    return 'Straf: $minutes minuten';
  }

  @override
  String courtSentenceReducedMinutes(String original, String reduced) {
    return 'Straf: $original → $reduced minuten';
  }

  @override
  String courtDateLabeled(String datetime) {
    return 'Datum: $datetime';
  }

  @override
  String get courtHistoryHeading => 'Rechtbankhistorie';

  @override
  String get courtAppealSubmitted => 'Beroep ingediend';

  @override
  String get courtCriminalRecordTitle => 'Strafblad';

  @override
  String courtTotalConvictions(String count) {
    return 'Totaal aantal veroordelingen: $count';
  }

  @override
  String get courtRecordBribeNote =>
      'Vorige veroordelingen blijven zichtbaar. Een geslaagde rechteromkoping wist alleen die ene actuele zaak.';

  @override
  String get courtNoConvictionsYet => 'Nog geen veroordelingen geregistreerd.';

  @override
  String get treated => 'Behandeld!';

  @override
  String healthRestored(String hp, String cost) {
    return '+$hp HP voor €$cost';
  }

  @override
  String get treatmentOptions => 'Behandelopties';

  @override
  String get youAreDead => 'Je bent dood! Game over.';

  @override
  String get emergencyOnly =>
      'Spoedeisende hulp is alleen beschikbaar bij <10 HP';

  @override
  String emergencyTreatment(String hp) {
    return 'Spoedeisende hulp! Gratis +$hp HP';
  }

  @override
  String get byValue => 'Op Waarde';

  @override
  String get byCondition => 'Op Conditie';

  @override
  String get byFuel => 'Op Brandstof';

  @override
  String get byName => 'Op Naam';

  @override
  String get stealCar => 'Steel Auto';

  @override
  String get stealBoat => 'Steel Boot';

  @override
  String get sellVehicle => 'Voertuig Verkopen';

  @override
  String get sellBoat => 'Boot Verkopen';

  @override
  String get confirmSellVehicle =>
      'Weet je zeker dat je dit voertuig wilt verkopen?';

  @override
  String get confirmSellBoat => 'Weet je zeker dat je deze boot wilt verkopen?';

  @override
  String get carStolen => 'Auto succesvol gestolen!';

  @override
  String get boatStolen => 'Boot succesvol gestolen!';

  @override
  String get vehicleTypeCar => 'Auto';

  @override
  String get vehicleTypeBoat => 'Boot';

  @override
  String stolenVehicleTitle(String vehicleType) {
    return '$vehicleType gestolen!';
  }

  @override
  String unknownVehicleType(String vehicleType) {
    return 'Onbekende $vehicleType';
  }

  @override
  String get vehicleStatSpeed => 'Snelheid';

  @override
  String get vehicleStatFuel => 'Brandstof';

  @override
  String get vehicleStatCargo => 'Lading';

  @override
  String get vehicleStatStealth => 'Stealth';

  @override
  String get continueAction => 'Verder';

  @override
  String get vehicleSold => 'Voertuig succesvol verkocht!';

  @override
  String get boatSold => 'Boot succesvol verkocht!';

  @override
  String get garageUpgraded => 'Garage geüpgraded!';

  @override
  String get marinaUpgraded => 'Haven succesvol geüpgraded!';

  @override
  String get marinaCapacity => 'Marina Capaciteit';

  @override
  String marinaBoatsCount(String current, String total) {
    return '$current / $total boten';
  }

  @override
  String marinaUpgradeWithCost(String cost) {
    return 'Upgraden (€$cost)';
  }

  @override
  String get marinaMaxLevel => 'Maximaal niveau';

  @override
  String marinaLevelRemaining(String level, String remaining) {
    return 'Level $level | $remaining plekken over';
  }

  @override
  String get noBoatsInMarina => 'Geen boten in je marina';

  @override
  String get stealBoatsToStart => 'Steel wat boten om te beginnen!';

  @override
  String get marinaUpgradeFailed => 'Haven upgraden mislukt';

  @override
  String get boatShipped => 'Boot succesvol verscheept!';

  @override
  String get boatShipFailed => 'Boot verschepen mislukt';

  @override
  String get buyProperty => 'Eigendom Kopen';

  @override
  String propertyBought(String name) {
    return '$name gekocht!';
  }

  @override
  String propertyUpgraded(String level) {
    return 'Eigendom geüpgraded naar level $level!';
  }

  @override
  String get errorLoadingProperties => 'Fout bij laden eigenschappen';

  @override
  String get errorUpgrading => 'Fout bij upgraden';

  @override
  String networkError(String error) {
    return 'Netwerkfout: $error';
  }

  @override
  String get unknownResponse => 'Onbekende response';

  @override
  String incomeCollected(String amount) {
    return '€$amount verzameld!';
  }

  @override
  String get buyCasino => 'Casino Kopen';

  @override
  String get manageCasino => 'Beheer Casino';

  @override
  String get casinoBought => 'Casino succesvol gekocht! 🎰';

  @override
  String get errorBuyCasino =>
      'Er is een fout opgetreden bij het kopen van het casino';

  @override
  String minimumDeposit(String amount) {
    return 'Minimale storting is €$amount';
  }

  @override
  String get casinoInfo1 => 'Spelers wedden tegen de casino kas';

  @override
  String get casinoInfo2 => 'Winsten worden uit de kas betaald';

  @override
  String get casinoInfo3 => 'Je kunt geld storten en opnemen';

  @override
  String get casinoInfo4 => 'Minimaal €10.000 in kas vereist';

  @override
  String get casinoInfo5 => 'Bij lagere kas: faillissement';

  @override
  String get members => 'Leden';

  @override
  String get location => 'Locatie';

  @override
  String get level => 'Niveau';

  @override
  String get alreadyFullHealth => 'Je bent al op volle gezondheid!';

  @override
  String get errorTreatment => 'Fout bij behandeling';

  @override
  String waitMinutes(String minutes) {
    return 'Je moet nog $minutes minuten wachten voor de volgende behandeling!';
  }

  @override
  String get emergencyHelp => 'Spoedeisende Hulp';

  @override
  String onlyNeedHp(String hp) {
    return '(Je hebt maar $hp HP nodig)';
  }

  @override
  String get emergencyInfo =>
      '• 🊘 Spoedeisende Hulp is GRATIS bij <10 HP (+20 HP)';

  @override
  String get hospitalInfo1 => '• Gezondheid daalt bij het plegen van misdaden';

  @override
  String get hospitalInfo2 => '• Bij 0 HP kun je geen misdaden meer plegen';

  @override
  String hospitalInfo3(String cost) {
    return '• De behandeling kost €$cost per keer';
  }

  @override
  String hospitalInfo4(String amount) {
    return '• Je kunt maximaal $amount HP herstellen per behandeling';
  }

  @override
  String get hospitalInfo5 => '• ⏱️ 1 uur cooldown tussen behandelingen';

  @override
  String get hospitalInfo6 =>
      '• 💚 Passief herstel: +5 HP per 5 minuten (als HP > 0)';

  @override
  String get medicalTreatment => 'Medische Behandeling';

  @override
  String get restoreCritical => 'Herstel +20 HP (kritieke toestand)';

  @override
  String get hospitalCooldownTitle => 'Behandeling in herstelperiode';

  @override
  String hospitalCooldownNextAvailable(String duration) {
    return 'Volgende behandeling beschikbaar over: $duration';
  }

  @override
  String get hospitalMedicalStatusTitle => 'Medische Status';

  @override
  String hospitalIcuRemaining(String duration) {
    return 'ICU: $duration';
  }

  @override
  String hospitalHpLine(String hp) {
    return 'PK $hp/100';
  }

  @override
  String get hospitalIcuTriageTitle => 'ICU & triage overzicht';

  @override
  String hospitalIcuPatientRemaining(String duration) {
    return 'Patiënt ligt op IC. Resterende tijd: $duration';
  }

  @override
  String get hospitalCriticalStatusDetected =>
      'Kritieke status gedetecteerd. Spoedhulp is aanbevolen.';

  @override
  String get hospitalStableStatus =>
      'Stabiel. Reguliere behandeling beschikbaar.';

  @override
  String get hospitalRefreshMedicalRecord => 'Ververs medisch dossier';

  @override
  String get hospitalStandardTreatmentTitle => 'Standaard behandeling';

  @override
  String hospitalStandardTreatmentSubtitle(String amount) {
    return 'Betaalbaar • herstel tot $amount HP';
  }

  @override
  String get hospitalIntensiveTreatmentTitle => 'Intensieve behandeling';

  @override
  String hospitalIntensiveTreatmentSubtitle(String amount) {
    return 'Sneller herstellen • tot $amount HP';
  }

  @override
  String hospitalIntensiveTreatmentInfoLine(String cost, String amount) {
    return '• Intensieve behandeling: €$cost voor tot $amount HP herstel.';
  }

  @override
  String restoreUp(String amount) {
    return 'Herstel tot $amount HP';
  }

  @override
  String get cost => 'Kosten';

  @override
  String crimeErrorToolRequired(String tools) {
    return '⚒️ Je hebt $tools nodig voor deze misdaad';
  }

  @override
  String crimeErrorToolInStorage(String tools) {
    return '⚒️ Je hebt wel $tools, maar die ligt thuis! Ga naar Inventaris → Transfer';
  }

  @override
  String get crimeErrorVehicleRequired =>
      '🚗 Deze misdaad vereist een voertuig';

  @override
  String get crimeErrorVehicleNotFound => '🚗 Voertuig niet gevonden';

  @override
  String get crimeErrorNotVehicleOwner => '🚗 Je bezit dit voertuig niet';

  @override
  String get crimeErrorVehicleBroken =>
      '🚗 Je voertuig is kapot en moet gerepareerd worden';

  @override
  String get crimeErrorNoFuel => '⛽ Je voertuig heeft geen brandstof meer';

  @override
  String get crimeErrorLevelTooLow => '⭐ Je level is te laag voor deze misdaad';

  @override
  String get crimeErrorInvalidCrimeId => '❌ Ongeldige misdaad';

  @override
  String get crimeErrorWeaponRequired =>
      '🔫 Je hebt een wapen nodig voor deze misdaad';

  @override
  String get crimeErrorWeaponBroken =>
      '🔫 Je wapen is kapot en moet gerepareerd worden';

  @override
  String get crimeErrorNoAmmo => '🔫 Je hebt geen munitie meer';

  @override
  String get crimeErrorGeneric => '❌ Er is iets misgegaan bij deze misdaad';

  @override
  String get inventoryFull =>
      '🎒 Je inventaris is vol! Sla gereedschap op in een property';

  @override
  String get storageFull => '📦 Property opslag is vol';

  @override
  String transferSuccess(String tool, String location) {
    return '✅ $tool verplaatst naar $location';
  }

  @override
  String get carried => 'Bij je';

  @override
  String get storage => 'Opslag';

  @override
  String get property => 'Eigendom';

  @override
  String inventorySlots(int used, int max) {
    return '$used / $max slots';
  }

  @override
  String get loadouts => 'Uitrustingen';

  @override
  String get createLoadout => 'Maak Loadout';

  @override
  String get equipLoadout => 'Uitrusten';

  @override
  String get loadoutEquipped => '✅ Loadout uitgerust';

  @override
  String get loadoutMaxReached => '❌ Maximum loadouts bereikt (5)';

  @override
  String loadoutMissingTools(String tools) {
    return '❌ Missende tools: $tools';
  }

  @override
  String get backpackUpgrade => 'Rugzak Upgrade';

  @override
  String get backpackBasic => 'Basis Rugzak (+5 slots)';

  @override
  String get backpackTactical => 'Tactische Vest (+10 slots)';

  @override
  String get backpackCargo => 'Cargo Broek (+3 slots)';

  @override
  String get upgradeInventory => 'Upgrade Inventaris';

  @override
  String get noToolsCarried => 'Geen gereedschap bij je';

  @override
  String get visitShopToBuyTools => 'Bezoek de winkel om gereedschap te kopen';

  @override
  String get noProperties => 'Geen properties';

  @override
  String get buyPropertyForStorage =>
      'Koop een property om gereedschap op te slaan';

  @override
  String get noToolsInStorage => 'Geen gereedschap in opslag';

  @override
  String get selectProperty => 'Selecteer property';

  @override
  String get slotsRemaining => 'slots over';

  @override
  String get noLoadouts => 'Geen loadouts';

  @override
  String get createLoadoutToStart => 'Maak een loadout om te beginnen';

  @override
  String get deleteLoadout => 'Verwijder Loadout';

  @override
  String get confirmDeleteLoadout =>
      'Weet je zeker dat je deze loadout wilt verwijderen?';

  @override
  String get loadoutDeleted => 'Loadout verwijderd';

  @override
  String get edit => 'Bewerk';

  @override
  String get delete => 'Verwijder';

  @override
  String get active => 'Actief';

  @override
  String get durability => 'Duurzaamheid';

  @override
  String get quantity => 'Aantal';

  @override
  String get slotSize => 'Slot grootte';

  @override
  String get repairCost => 'Reparatie kosten';

  @override
  String get wearPerUse => 'Slijtage per gebruik';

  @override
  String get loseChance => 'Kans om te verliezen';

  @override
  String get requiredFor => 'Vereist voor';

  @override
  String get lowDurability => 'Lage duurzaamheid';

  @override
  String get transfer => 'Verplaats';

  @override
  String get toolDetails => 'Gereedschap Details';

  @override
  String get transferTool => 'Verplaats Gereedschap';

  @override
  String get selectQuantity => 'Selecteer aantal';

  @override
  String get destination => 'Bestemming';

  @override
  String get from => 'Van';

  @override
  String get to => 'Naar';

  @override
  String get editLoadout => 'Bewerk Loadout';

  @override
  String get loadoutName => 'Loadout Naam';

  @override
  String get description => 'Beschrijving';

  @override
  String get optional => 'optioneel';

  @override
  String get selectedTools => 'Geselecteerd gereedschap';

  @override
  String get noToolsAvailable => 'Geen gereedschap beschikbaar';

  @override
  String get create => 'Aanmaken';

  @override
  String get save => 'Opslaan';

  @override
  String get pleaseEnterName => 'Voer een naam in';

  @override
  String get pleaseSelectTools => 'Selecteer minimaal 1 gereedschap';

  @override
  String get loadoutCreated => 'Loadout aangemaakt';

  @override
  String get loadoutUpdated => 'Loadout bijgewerkt';

  @override
  String get goToInventory => 'Naar Inventaris';

  @override
  String get slots => 'slots';

  @override
  String get backpackShop => 'Rugzak Shop';

  @override
  String get yourBackpack => 'Je rugzak';

  @override
  String get availableUpgrades => 'Upgrades beschikbaar';

  @override
  String get otherBackpacks => 'Andere rugzakken';

  @override
  String get youHaveBestBackpack => 'Je hebt de beste rugzak!';

  @override
  String get backpackPurchased => 'Rugzak gekocht!';

  @override
  String get backpackUpgraded => 'Rugzak geupgrade!';

  @override
  String get buyBackpack => 'Kopen';

  @override
  String get upgradeBackpack => 'Upgraden';

  @override
  String get backpackPrice => 'Prijs';

  @override
  String get extraSlots => 'Extra sleuven';

  @override
  String get totalSlots => 'Totaal slots';

  @override
  String get vipOnly => 'Alleen VIP';

  @override
  String get tradeInValue => 'Inruilwaarde';

  @override
  String get upgradeCost => 'Upgrade kosten';

  @override
  String rankRequired(Object rank) {
    return 'Rank $rank vereist';
  }

  @override
  String insufficientFunds(String needed, String have) {
    return 'Je hebt €$needed nodig. Je hebt €$have';
  }

  @override
  String get alreadyHasBackpack => 'Je hebt al een rugzak';

  @override
  String get backpackNotFound => 'Rugzak niet gevonden';

  @override
  String get playerNotFound => 'Speler niet gevonden';

  @override
  String get notAnUpgrade => 'Dit is geen upgrade';

  @override
  String backpackPurchasedEvent(Object name, Object slots) {
    return 'Je hebt $name gekocht! +$slots slots.';
  }

  @override
  String backpackUpgradedEvent(Object newName, Object upgradeSlots) {
    return 'Geupgrade naar $newName! +$upgradeSlots extra slots.';
  }

  @override
  String get backpackPurchaseFailedNotFound => 'Rugzak niet gevonden';

  @override
  String get backpackPurchaseFailedAlready =>
      'Je hebt al een rugzak. Je kunt maar één tegelijk gebruiken.';

  @override
  String backpackPurchaseFailedRank(Object current, Object required) {
    return 'Je hebt rank $required nodig (je bent rank $current)';
  }

  @override
  String backpackPurchaseFailedFunds(Object have, Object needed) {
    return 'Je hebt €$needed nodig. Je hebt €$have';
  }

  @override
  String get backpackPurchaseFailedVip =>
      'Deze rugzak is alleen voor VIP leden';

  @override
  String get backpackUpgradeFailedNo => 'Je hebt geen rugzak om te upgraden';

  @override
  String get backpackUpgradeFailedNotUpgrade =>
      'Dit is geen upgrade. Kies een grotere rugzak.';

  @override
  String backpackUpgradeFailedRank(Object current, Object required) {
    return 'Je hebt rank $required nodig (je bent rank $current)';
  }

  @override
  String backpackUpgradeFailedFunds(Object have, Object needed) {
    return 'Je hebt €$needed nodig. Je hebt €$have';
  }

  @override
  String get backpackUpgradeFailedVip => 'Deze rugzak is alleen voor VIP leden';

  @override
  String get backpackPurchaseFailedGeneric => 'Aankoop is niet gelukt.';

  @override
  String get backpackUpgradeFailedGeneric => 'Upgrade is niet gelukt.';

  @override
  String get backpackUnknownEvent => 'Onbekende actie';

  @override
  String get backpackLoadFailedGeneric => 'Er is iets misgegaan';

  @override
  String get backpackOwnedBadge => 'Bezit';

  @override
  String get availableBackpacks => 'Beschikbare rugzakken';

  @override
  String backpackDialogCurrentLine(String name, int slots) {
    return 'Huidig: $name (+$slots slots)';
  }

  @override
  String backpackDialogNewLine(String name, int slots) {
    return 'Nieuw: $name (+$slots slots)';
  }

  @override
  String backpackDialogUpgradeDelta(int delta) {
    return 'Upgrade: +$delta slots';
  }

  @override
  String backpackDialogTotalCapacity(int totalSlots) {
    return 'Totaal: $totalSlots slots';
  }

  @override
  String get notLoggedInTokenStorageHint =>
      '(opslagprobleem — probeer opnieuw in te loggen)';

  @override
  String get blackMarketTabBackpacks => 'Rugzakken';

  @override
  String get bmHubAdjustFiltersHint => 'Try adjusting your filters';

  @override
  String get bmHubEmptyMyListingsHint =>
      'Go to Garage or Marina to list vehicles';

  @override
  String get bmHubSellerLabel => 'Seller';

  @override
  String get bmHubAskingPriceLabel => 'Asking price';

  @override
  String get bmHubMarketValueShort => 'Market value';

  @override
  String get bmHubBuyNow => 'Buy now';

  @override
  String get bmHubListedFor => 'Listed for';

  @override
  String get bmHubEditPrice => 'Edit price';

  @override
  String get bmHubDelist => 'Delist';

  @override
  String get bmHubFilterListingsTitle => 'Filter listings';

  @override
  String get bmHubLabelCountry => 'Country';

  @override
  String get bmHubAllCountries => 'All countries';

  @override
  String get bmHubLabelVehicleType => 'Vehicle type';

  @override
  String get bmHubAllTypes => 'All types';

  @override
  String get bmHubCars => 'Cars';

  @override
  String get bmHubBoats => 'Boats';

  @override
  String get bmHubPriceRange => 'Price range';

  @override
  String get bmHubClearFilters => 'Clear filters';

  @override
  String get bmHubApply => 'Apply';

  @override
  String get bmHubBuyVehicleTitle => 'Buy vehicle';

  @override
  String bmHubBuyVehicleForConfirm(String name, String price) {
    return 'Buy $name for $price?';
  }

  @override
  String get bmHubVehiclePurchased => 'Vehicle purchased successfully!';

  @override
  String get bmHubVehiclePurchaseFailed => 'Failed to buy vehicle';

  @override
  String get bmHubNewPriceEuro => 'New price (€)';

  @override
  String get bmHubEnterNewPriceHint => 'Enter new price';

  @override
  String get bmHubCurrentPrice => 'Current price';

  @override
  String get bmHubPriceUpdated => 'Price updated successfully!';

  @override
  String get bmHubPriceUpdateFailed => 'Failed to update price';

  @override
  String get bmHubUpdateButton => 'Update';

  @override
  String get bmHubDelistVehicleTitle => 'Delist vehicle';

  @override
  String bmHubRemoveFromMarketConfirm(String name) {
    return 'Remove $name from the market?';
  }

  @override
  String get bmHubVehicleDelisted => 'Vehicle delisted successfully!';

  @override
  String get bmHubDelistFailed => 'Failed to delist vehicle';

  @override
  String get bmHubLocationUnknown => 'UNKNOWN';

  @override
  String get arrested => 'Gearresteerd!';

  @override
  String get jailMessage =>
      'Je bent gearresteerd tijdens je reis en alle goederen zijn in beslag genomen!';

  @override
  String get confirmAction => 'Weet je het zeker?';

  @override
  String get ok => 'OK';

  @override
  String get travelContinueConfirmTitle => 'Doorgaan naar de volgende etappe?';

  @override
  String get travelContinueConfirmBody =>
      'Grenscontroles zijn actief. Wil je doorgaan?';

  @override
  String get travelJourneyCompleteTitle => 'Reis voltooid';

  @override
  String get travelJourneyCompleteBody =>
      'Je bent veilig op je bestemming aangekomen.';

  @override
  String get hitlist => 'Moordlijst';

  @override
  String hitlistLoadError(String error) {
    return 'Fout bij laden van moordlijst: $error';
  }

  @override
  String get noActiveHits => 'Geen actieve moorden geplaatst';

  @override
  String get selectTarget => 'Selecteer doelwit';

  @override
  String get searchPlayer => 'Zoek speler...';

  @override
  String get placeHitTitle => 'Moord plaatsen';

  @override
  String get minimumBounty => 'Minimale bounty: €50.000';

  @override
  String get bountyAmount => 'Bounty bedrag';

  @override
  String get place => 'Plaatsen';

  @override
  String hitPlaced(String amount) {
    return 'Moord geplaatst voor €$amount';
  }

  @override
  String hitError(String error) {
    return 'Fout: $error';
  }

  @override
  String get hitDifferentCountry =>
      'Je moet in hetzelfde land zijn als het doelwit';

  @override
  String get hitlistErrMissingBounty => 'Bountybedrag is verplicht';

  @override
  String get hitlistErrBountyTooLow => 'Minimale bounty is €50.000';

  @override
  String get hitlistErrCannotHitYourself =>
      'Je kunt jezelf niet op de moordlijst zetten';

  @override
  String get hitlistErrHitAlreadyExists =>
      'Je hebt al een actieve hit op deze speler';

  @override
  String get hitlistErrInsufficientMoney => 'Je hebt niet genoeg geld';

  @override
  String get hitlistErrMissingCounterBounty => 'Tegen-bod bedrag is verplicht';

  @override
  String get hitlistErrHitNotFound => 'Hit niet gevonden';

  @override
  String get hitlistErrNotTarget =>
      'Alleen het doelwit kan een tegen-bod plaatsen';

  @override
  String get hitlistErrHitNotActive => 'Hit is niet actief';

  @override
  String get hitlistErrCounterBountyMustBeHigher =>
      'Tegen-bod moet hoger zijn dan de originele bounty';

  @override
  String get hitlistErrMissingWeapon => 'Wapen is vereist';

  @override
  String get hitlistErrWeaponNotFound => 'Wapen niet gevonden';

  @override
  String get hitlistErrWeaponNotOwned =>
      'Je bezit dit wapen niet of het is kapot';

  @override
  String get hitlistErrWeaponBroken =>
      'Je geselecteerde wapen is kapot. Repareer het eerst.';

  @override
  String get hitlistErrInsufficientAmmo => 'Je hebt niet genoeg munitie';

  @override
  String get hitlistErrInvalidAmmoHit => 'Ongeldige hoeveelheid munitie';

  @override
  String get hitlistErrTargetUnderHitProtection =>
      'Doelwit heeft actieve moordbescherming';

  @override
  String get hitlistErrInvalidInvestigationTier => 'Ongeldig onderzoekstype';

  @override
  String get hitlistErrInvestigationAlreadyPending =>
      'Er loopt al een onderzoek voor deze hit. Wacht op je detectivebericht.';

  @override
  String get hitlistErrInvalidCaseId => 'Ongeldig dossiernummer';

  @override
  String get hitlistErrMurderCaseNotFound => 'Dossier niet gevonden';

  @override
  String get hitlistErrMurderCaseExpired =>
      'Onderzoeksvenster verlopen (24 uur)';

  @override
  String get hitlistErrMurderCaseAlreadyRequested =>
      'Onderzoek voor dit dossier is al gestart';

  @override
  String get hitlistErrNotPlacer => 'Alleen de plaatser kan de hit annuleren';

  @override
  String get hitlistInvestigationOptions => 'Onderzoek opties';

  @override
  String get hitlistInvestigationChooseSpeedPrice => 'Kies snelheid en prijs:';

  @override
  String get hitlistInvestigationQuick => 'Snel onderzoek (€1.000.000 • 1 uur)';

  @override
  String get hitlistInvestigationStandard =>
      'Gemiddeld onderzoek (€500.000 • 6 uur)';

  @override
  String get hitlistInvestigationSlow =>
      'Langzaam onderzoek (€250.000 • 24 uur)';

  @override
  String hitlistInvestigationQueued(
    String cost,
    String etaMinutes,
    String resolveAt,
  ) {
    return 'Onderzoek gestart. Kosten $cost. ETA: $etaMinutes min. Rapport komt via Detective Bureau berichten (rond $resolveAt).';
  }

  @override
  String get hitlistInvestigationFailedGeneric => 'Onderzoek mislukt';

  @override
  String get hitlistInvestigationCouldNotComplete =>
      'Onderzoek kon niet worden uitgevoerd';

  @override
  String hitlistHitSuccessWithLoot(String cash, String items) {
    return 'Moord gelukt! Bounty en buit ontvangen: cash $cash, gedragen items $items.';
  }

  @override
  String get hitlistAttemptTimeout => 'Moordpoging timeout. Probeer opnieuw.';

  @override
  String get hitlistNoUsableWeapons =>
      'Je hebt geen bruikbare wapens in je inventaris. Koop of repareer eerst een wapen.';

  @override
  String hitlistWeaponsInventoryLoadError(String error) {
    return 'Fout bij laden wapens: $error';
  }

  @override
  String hitlistPlayersLoadError(String error) {
    return 'Fout bij laden spelers: $error';
  }

  @override
  String get hitlistRelativeOneDayAgo => '1 dag geleden';

  @override
  String hitlistRelativeDaysAgo(String count) {
    return '$count dagen geleden';
  }

  @override
  String get counterBountyTitle => 'Tegen-bod plaatsen';

  @override
  String minimumAmount(String amount) {
    return 'Minimaal bedrag: €$amount';
  }

  @override
  String get counterBountyAmount => 'Tegen-bod bedrag';

  @override
  String counterBountyPlaced(String amount) {
    return 'Tegen-bod van €$amount geplaatst';
  }

  @override
  String get cancelHitConfirmTitle => 'Moord annuleren?';

  @override
  String get cancelHitConfirmBody => 'Je bounty zal worden terugbetaald.';

  @override
  String get hitCancelled => 'Moord geannuleerd';

  @override
  String get target => 'Doelwit';

  @override
  String get placer => 'Plaatser';

  @override
  String get bounty => 'Bounty';

  @override
  String get counterBid => 'Tegen-bod';

  @override
  String get counterBidPlaced =>
      'Tegen-bod geplaatst! Het contract is omgekeerd.';

  @override
  String get attemptHit => 'Moord uitvoeren';

  @override
  String get selectWeapon => 'Selecteer het wapen en munitie voor deze moord';

  @override
  String get youAreTargeted => 'Je bent op de moordlijst';

  @override
  String get security => 'Beveiliging';

  @override
  String get currentDefense => 'Huidige Verdediging';

  @override
  String get totalDefense => 'Totale Verdediging';

  @override
  String get currentArmor => 'Huidige Armor';

  @override
  String get bodyguards => 'Lijfwachten';

  @override
  String get buyBodyguards => 'Koop Lijfwachten';

  @override
  String get bodyguardPrice => 'Prijs per Lijfwacht';

  @override
  String get armor => 'Pantser';

  @override
  String get protectorsFollow => 'Beschermers die je volgen';

  @override
  String get eachGivesDefense => 'Elk geeft +10 verdediging';

  @override
  String get lightArmor => 'Lichte Armor';

  @override
  String get basicProtection => 'Basis bescherming';

  @override
  String get heavyArmor => 'Zware Armor';

  @override
  String get strongProtection => 'Sterke bescherming';

  @override
  String get bulletproofVest => 'Kogelvrij Vest';

  @override
  String get veryStrongProtection => 'Zeer sterke bescherming';

  @override
  String get tacticalSuit => 'Tactische Outfit';

  @override
  String get premiumProtection => 'Premium bescherming';

  @override
  String get defense => 'Verdediging';

  @override
  String defenseIncrease(String armor, String defense) {
    return '$armor gekocht! +$defense verdediging';
  }

  @override
  String get worn => 'Gedragen';

  @override
  String get replaceArmor => 'Vervangen';

  @override
  String get bodyguardProductName => 'Lijfwacht';

  @override
  String securityLoadError(String error) {
    return 'Fout bij laden beveiliging: $error';
  }

  @override
  String get securityStatusLoadFailed => 'Kon beveiligingsstatus niet laden.';

  @override
  String armorConditionLine(String percent, String base) {
    return 'Conditie $percent% · basis $base';
  }

  @override
  String dailyWageAmount(String amount) {
    return 'Dagloon $amount';
  }

  @override
  String dailySystemCostLine(String amount) {
    return 'Dagelijkse systeemkost: $amount';
  }

  @override
  String nextPayrollAt(String datetime) {
    return 'Volgende afschrijving: $datetime';
  }

  @override
  String get bodyguardsLeaveIfUnpaid =>
      'Kun je het dagloon niet betalen, dan lopen alle lijfwachten weg.';

  @override
  String get armorOneAtATimeHint =>
      'Je kunt maar 1 pantser tegelijk dragen. Een nieuw vest vervangt altijd je huidige vest.';

  @override
  String armorDefenseNowAtCondition(String defense, String percent) {
    return 'Nu +$defense bij $percent%';
  }

  @override
  String get couldNotBuyBodyguard => 'Lijfwacht kopen mislukt';

  @override
  String get couldNotBuyArmor => 'Pantser kopen mislukt';

  @override
  String get armorAlreadyEquippedLong =>
      'Je draagt dit vest al. Je kunt maar 1 pantser tegelijk dragen.';

  @override
  String get securityErrorArmorNotFound => 'Pantser niet gevonden';

  @override
  String get securityErrorMinQuantity => 'Hoeveelheid moet minimaal 1 zijn';

  @override
  String get hit => 'MOORD';

  @override
  String get counterBidLabel => 'TEGEN-BOD';

  @override
  String daysAgo(String count, String plural) {
    return '$count dag$plural geleden';
  }

  @override
  String get justPlaced => 'Net geplaatst';

  @override
  String get youAreTheTarget => 'Je bent het doelwit';

  @override
  String get youAreThePlacer => 'Je bent de plaatser';

  @override
  String get onlyTargetCanCounterBid =>
      'Alleen het doelwit kan een tegen-bod plaatsen';

  @override
  String get executeHit => 'Moord uitvoeren';

  @override
  String get moneyNotEnough => 'Je hebt niet genoeg geld';

  @override
  String get securityScreen => 'Beveiliging';

  @override
  String get currentDefenseStatus => 'Huidige Verdedigingsstatus';

  @override
  String get noWeapons => 'Je hebt geen wapens in je inventaris';

  @override
  String get ammoQuantity => 'Munitie Hoeveelheid';

  @override
  String get noAmmoRequired => 'Geen munitie vereist voor dit wapen';

  @override
  String get weaponStats => 'Wapen Statistieken';

  @override
  String get damage => 'Schade';

  @override
  String get intimidation => 'Intimidatie';

  @override
  String get execute => 'Uitvoeren';

  @override
  String get hitExecuted => 'Moord succesvol uitgevoerd!';

  @override
  String get invalidAmmo => 'Vul alstublieft een geldige munitiehoeveelheid in';

  @override
  String get weaponsMarket => 'Wapenmarkt';

  @override
  String get ammoMarket => 'Munitiemarkt';

  @override
  String get shootingRange => 'Schietbaan';

  @override
  String get ammoFactory => 'Munitiefabriek';

  @override
  String get weaponShop => 'Wapenwinkel';

  @override
  String get myWeapons => 'Mijn Wapens';

  @override
  String get weaponPurchased => 'Wapen gekocht';

  @override
  String weaponRankRequired(String rank) {
    return 'Rang vereist: $rank';
  }

  @override
  String get buyWeapon => 'Kopen';

  @override
  String get ammoShop => 'Munitiemarkt';

  @override
  String get myAmmo => 'Mijn Munitie';

  @override
  String get ammoPurchased => 'Munitie gekocht';

  @override
  String get purchaseCooldown =>
      'Je moet wachten voordat je opnieuw kunt kopen';

  @override
  String get insufficientStock => 'Niet genoeg voorraad beschikbaar';

  @override
  String get maxInventoryReached => 'Maximale inventaris capaciteit bereikt';

  @override
  String get invalidQuantity => 'Ongeldige hoeveelheid';

  @override
  String get nextAmmoPurchase => 'Volgende aankoop beschikbaar over';

  @override
  String get ammoBoxes => 'Aantal dozen';

  @override
  String ammoRoundsPerBox(String rounds) {
    return '$rounds kogels per doos';
  }

  @override
  String ammoYouWillReceive(String rounds) {
    return 'Je krijgt: $rounds kogels';
  }

  @override
  String ammoTotalCost(String cost) {
    return 'Totale kosten: €$cost';
  }

  @override
  String get ammoRounds => 'kogels';

  @override
  String get ammoGeneric => 'Munitie';

  @override
  String get ammoPerCrimeSuffix => 'per misdaad';

  @override
  String get ammoBoxesUnit => 'dozen';

  @override
  String get ammoStock => 'Voorraad';

  @override
  String get ammoQuality => 'Kwaliteit';

  @override
  String get factoryBought => 'Fabriek gekocht';

  @override
  String get factoryProduced => 'Productie bijgewerkt';

  @override
  String get factorySessionStarted =>
      'Productie gestart: 8 uur actief, claim elke 10 minuten';

  @override
  String get ammoFactoryTitle => 'Munitiefabriek';

  @override
  String get ammoFactoryIntro =>
      'Werkt in batches; je kunt elke 10 minuten productie innen (tot 8 uur backlog per sessie).';

  @override
  String get ammoFactoryWhatYouCanDo => 'Wat je kunt doen:';

  @override
  String get ammoFactoryActionBuy => 'Koop een fabriek in je huidige land';

  @override
  String get ammoFactoryActionProduce =>
      'Incasseer productie (interval: 10 minuten, max backlog: 8 uur per sessie)';

  @override
  String get ammoFactoryActionOutput =>
      'Upgrade output tot level 5 voor meer patronen per claim';

  @override
  String get ammoFactoryActionQuality =>
      'Upgrade kwaliteit voor sterkere marktprijzen';

  @override
  String get ammoFactoryBlackMarketTitle => 'Munitie te koop';

  @override
  String get ammoFactoryBlackMarketBody =>
      'De munitiefabriek verkoopt geen kogels rechtstreeks vanuit dit scherm. Voor kopen en verkopen van munitie gebruik je de Zwarte Markt.';

  @override
  String get ammoFactoryActionBlackMarket =>
      'Koop en verkoop munitie via de Zwarte Markt, niet rechtstreeks via de fabriek.';

  @override
  String get ammoFactoryErrCountryRequired => 'Land is verplicht';

  @override
  String get ammoFactoryErrPlayerNotFound => 'Speler niet gevonden';

  @override
  String get ammoFactoryErrWrongCountry =>
      'Je moet in hetzelfde land zijn om deze fabriek te kopen';

  @override
  String get ammoFactoryErrCouldNotPurchase =>
      'Fabriek kon niet worden gekocht';

  @override
  String get ammoFactoryErrAlreadyOwned => 'Fabriek heeft al een eigenaar';

  @override
  String get ammoFactoryErrInsufficientMoneyBuy =>
      'Niet genoeg geld om de fabriek te kopen';

  @override
  String get ammoFactoryErrCouldNotProduce => 'Kon geen munitie produceren';

  @override
  String get ammoFactoryErrNotOwned => 'Je bezit geen fabriek';

  @override
  String get ammoFactoryErrOnCooldown => 'Fabriek heeft nog afkoeltijd';

  @override
  String get ammoFactoryErrInactive =>
      'Fabrikeigendom verloren door inactiviteit';

  @override
  String get ammoFactoryErrCouldNotUpgrade => 'Kon fabriek niet upgraden';

  @override
  String get ammoFactoryErrInsufficientMoneyUpgrade =>
      'Niet genoeg geld om te upgraden';

  @override
  String get ammoFactoryErrMaxLevel => 'Fabriek heeft al het maximale niveau';

  @override
  String get ammoFactoryErrInvalidUpgradeType =>
      'Upgrade-type moet output of quality zijn';

  @override
  String get ammoFactoryErrEducationNotMet => 'Opleidingseisen niet voldaan';

  @override
  String get factoryUpgradeOutputSuccess => 'Output geupgrade';

  @override
  String get factoryUpgradeQualitySuccess => 'Kwaliteit geupgrade';

  @override
  String get myFactory => 'Mijn Fabriek';

  @override
  String get noFactoryOwned => 'Je bezit geen fabriek';

  @override
  String get factoryCountry => 'Land';

  @override
  String get factoryOutputLevel => 'Output niveau';

  @override
  String get factoryQualityLevel => 'Kwaliteit niveau';

  @override
  String get factoryLastProduced => 'Laatst geproduceerd';

  @override
  String get factoryProduceStatusLabel => 'Produceerstatus';

  @override
  String get factoryProduceStatusReady => 'Klaar';

  @override
  String get factoryProduceStatusCooldown => 'Afkoelen';

  @override
  String get factorySessionActive =>
      'Productie venster: actief (10 min interval)';

  @override
  String get factorySessionStopped =>
      'Productie venster: gestopt (klik Produce om opnieuw 8 uur te starten)';

  @override
  String factorySessionEndsIn(String duration) {
    return 'Venster eindigt over: $duration';
  }

  @override
  String get factoryNextProductionReady =>
      'Volgende productie: nu beschikbaar (druk op Produce om te innen)';

  @override
  String factoryNextProductionIn(String duration) {
    return 'Volgende productie over: $duration';
  }

  @override
  String get factoryProduce => 'Produceren';

  @override
  String get factoryUpgradeOutput => 'Upgrade-uitvoer';

  @override
  String get factoryUpgradeQuality => 'Upgrade Kwaliteit';

  @override
  String get factoryList => 'Fabrieken per land';

  @override
  String get factoryUnowned => 'Beschikbaar';

  @override
  String factoryOwnedBy(String owner) {
    return 'Eigenaar: $owner';
  }

  @override
  String get factoryBuy => 'Kopen';

  @override
  String get shootingIntro =>
      'Verbeter je precisie en verhoog je slagingskans bij misdaden';

  @override
  String get shootingTrainSuccess => 'Training voltooid';

  @override
  String get shootingMaxSessionsReached =>
      'Maximum aantal trainingssessies bereikt';

  @override
  String get shootingTrainingProgressTitle => 'Training Voortgang';

  @override
  String get shootingSessionsCompletedLabel => 'Sessies voltooid:';

  @override
  String get shootingProgressCompleteSuffix => 'compleet';

  @override
  String get shootingCurrentBonusTitle => 'Huidige Bonus';

  @override
  String get shootingAccuracyBonusLabel => 'Precisie Bonus';

  @override
  String get shootingMaximumLabel => 'Maximaal';

  @override
  String get shootingBonusAppliedToCrimes =>
      'Deze bonus wordt toegepast op al je misdaadpogingen';

  @override
  String get shootingReadyToTrain => 'Klaar om te trainen';

  @override
  String get shootingTrainingCooldownTitle => 'Cooldown trainen';

  @override
  String shootingCooldownLabel(String time) {
    return 'Volgende sessie om: $time';
  }

  @override
  String get shootingCooldownHint =>
      'Je moet 1 uur wachten tussen trainingssessies';

  @override
  String get shootingTrainingInProgress => 'Bezig met trainen...';

  @override
  String get shootingHowItWorksTitle => 'Hoe werkt het?';

  @override
  String get shootingHowItWorksBullet1 =>
      '• Train elk uur voor een precisieboost';

  @override
  String get shootingHowItWorksBullet2 => '• Elke sessie geeft +0.1% bonus';

  @override
  String get shootingHowItWorksBullet3 =>
      '• Maximum van 100 sessies (+10% totaal)';

  @override
  String get shootingHowItWorksBullet4 =>
      '• Verhoogt je slagingskans bij misdaden';

  @override
  String get shootingHowItWorksBullet5 => '• Blijvende bonus; elke sessie telt';

  @override
  String shootingSessions(String count) {
    return 'Sessies: $count/100';
  }

  @override
  String shootingAccuracyBonus(String bonus) {
    return 'Nauwkeurigheidsbonus: $bonus%';
  }

  @override
  String shootingCooldown(String time) {
    return 'Volgende sessie om $time';
  }

  @override
  String get shootingTrain => 'Trainen';

  @override
  String get gym => 'Sportschool';

  @override
  String get gymIntro =>
      'Train je kracht en verhoog je slagingskans bij misdaden';

  @override
  String get gymTrainSuccess => 'Training voltooid';

  @override
  String get gymMaxSessionsReached => 'Maximum aantal sessies bereikt';

  @override
  String get gymTrainingProgressTitle => 'Training Voortgang';

  @override
  String get gymSessionsCompletedLabel => 'Sessies voltooid:';

  @override
  String get gymProgressCompleteSuffix => 'compleet';

  @override
  String get gymCurrentBonusTitle => 'Huidige Bonus';

  @override
  String gymSessions(String count) {
    return 'Sessies: $count/100';
  }

  @override
  String get gymStrengthBonusLabel => 'Kracht Bonus';

  @override
  String get gymMaximumLabel => 'Maximaal';

  @override
  String gymStrengthBonus(String bonus) {
    return 'Kracht bonus: $bonus%';
  }

  @override
  String get gymBonusAppliedToCrimes =>
      'Deze bonus wordt toegepast op al je misdaadpogingen';

  @override
  String get gymReadyToTrain => 'Klaar om te trainen';

  @override
  String get gymTrainingCooldownTitle => 'Cooldown trainen';

  @override
  String gymCooldown(String time) {
    return 'Volgende sessie om $time';
  }

  @override
  String get gymCooldownHint => 'Je moet 1 uur wachten tussen trainingssessies';

  @override
  String get gymTrain => 'Trainen';

  @override
  String get gymTrainingInProgress => 'Bezig met trainen...';

  @override
  String get gymHowItWorksTitle => 'Hoe werkt het?';

  @override
  String get gymHowItWorksBullet1 => '• Train elk uur voor een krachtboost';

  @override
  String get gymHowItWorksBullet2 => '• Elke sessie geeft +0.08% bonus';

  @override
  String get gymHowItWorksBullet3 => '• Maximum van 100 sessies (+8% totaal)';

  @override
  String get gymHowItWorksBullet4 => '• Verhoogt je slagingskans bij misdaden';

  @override
  String get gymHowItWorksBullet5 => '• Blijvende bonus; elke sessie telt';

  @override
  String get buyAmmo => 'Munitie Kopen';

  @override
  String factoryPurchaseCost(String cost) {
    return 'Aankoopkosten: €$cost';
  }

  @override
  String factoryProductionOutput(String amount) {
    return 'Output per cyclus: $amount units';
  }

  @override
  String factoryQualityMultiplier(String multiplier) {
    return 'Kwaliteit Multiplier: ${multiplier}x';
  }

  @override
  String upgradeOutputCost(String cost, String nextAmount) {
    return 'Upgrade Output - Kosten: €$cost, Volgende Output: $nextAmount';
  }

  @override
  String upgradeQualityCost(String cost, String nextQuality) {
    return 'Upgrade Kwaliteit - Kosten: €$cost, Volgende Kwaliteit: ${nextQuality}x';
  }

  @override
  String get factoryCostLabel => 'Kosten';

  @override
  String get factoryCurrentOutput => 'Huidige Output';

  @override
  String get factoryNextOutput => 'Volgende Output';

  @override
  String get factoryCurrentQuality => 'Huidige Kwaliteit';

  @override
  String get factoryNextQuality => 'Volgende Kwaliteit';

  @override
  String get factoryUnitsPerCycle => 'units/8u max';

  @override
  String get factoryUnitsPerHour => 'units/uur';

  @override
  String get factoryUpgradeMaxLevel => 'Fabriek bereikt maximale niveau';

  @override
  String get countryUsa => 'VS';

  @override
  String get countryMexico => 'Mexico';

  @override
  String get countryColombia => 'Colombia';

  @override
  String get countryBrazil => 'Brazilië';

  @override
  String get countryArgentina => 'Argentinië';

  @override
  String get countryJapan => 'Japan';

  @override
  String get countryChina => 'China';

  @override
  String get countryRussia => 'Rusland';

  @override
  String get countryIndia => 'Indië';

  @override
  String get countryAustralia => 'Australië';

  @override
  String get countrySouthAfrica => 'Zuid-Afrika';

  @override
  String get countryCanada => 'Canada';

  @override
  String get countryPortugal => 'Portugal';

  @override
  String get countryIreland => 'Ierland';

  @override
  String get countryLuxembourg => 'Luxemburg';

  @override
  String get countryAustria => 'Oostenrijk';

  @override
  String get countryDenmark => 'Denemarken';

  @override
  String get countrySweden => 'Zweden';

  @override
  String get countryNorway => 'Noorwegen';

  @override
  String get countryFinland => 'Finland';

  @override
  String get countryPoland => 'Polen';

  @override
  String get countryCzechia => 'Tsjechië';

  @override
  String get countryGreece => 'Griekenland';

  @override
  String get countryTurkey => 'Turkije';

  @override
  String get countryUae => 'Verenigde Arabische Emiraten';

  @override
  String get countryDubai => 'Dubai';

  @override
  String get toolBoltCutter => 'Betonschaar';

  @override
  String get toolCarTheftTools => 'Auto Diefstalpakket';

  @override
  String get toolBurglaryKit => 'Inbraak Kit';

  @override
  String get toolToolbox => 'Gereedschapskist';

  @override
  String get toolCrowbar => 'Koevoet';

  @override
  String get toolGlassCutter => 'Glassnijder';

  @override
  String get toolSprayPaint => 'Spuiten';

  @override
  String get toolJerryCan => 'Jerrycan';

  @override
  String get toolFakeDocuments => 'Vervalste Documenten';

  @override
  String get toolHackingLaptop => 'Laptop hacken';

  @override
  String get toolCounterfeitingKit => 'Vervalsings Kit';

  @override
  String get toolRope => 'Touw';

  @override
  String get toolSilencer => 'Geluiddemper';

  @override
  String get toolNightVision => 'Nachtbril';

  @override
  String get toolGpsJammer => 'GPS-stoorzender';

  @override
  String get toolBurnerPhone => 'Wegwerp Telefoon';

  @override
  String get toolThermalDrill => 'Thermische boor';

  @override
  String get toolCategoryBoltCutter => 'Betonschaar';

  @override
  String get toolCategoryBurglaryKit => 'Inbrekersset';

  @override
  String get toolCategoryCarTools => 'Autodiefstalgereedschap';

  @override
  String get toolCategoryJerryCan => 'Jerrycan';

  @override
  String get toolCategorySprayPaint => 'Spuitbusverf';

  @override
  String get toolCategoryCrowbar => 'Koevoet';

  @override
  String get toolCategoryGlassCutter => 'Glassnijder';

  @override
  String get toolCategoryLaptop => 'Laptop';

  @override
  String get toolCategoryCounterfeiting => 'Vervalsing';

  @override
  String get toolCategoryToolbox => 'Gereedschapskist';

  @override
  String get toolCategoryRope => 'Touw';

  @override
  String get toolCategorySilencer => 'Geluiddemper';

  @override
  String get toolCategoryFakeDocs => 'Valse documenten';

  @override
  String get toolCategoryNightVision => 'Nachtkijker';

  @override
  String get toolCategoryBurnerPhone => 'Wegwerptelefoon';

  @override
  String get toolCategoryGpsJammer => 'GPS-stoorzender';

  @override
  String get toolCategoryThermalDrill => 'Thermische boor';

  @override
  String get toolsScreenTitle => 'Zwarte markt – Gereedschap';

  @override
  String get toolsTabBuy => 'Kopen';

  @override
  String get toolsTabMyTools => 'Mijn gereedschap';

  @override
  String get toolsNoToolsAvailable => 'Geen gereedschap beschikbaar';

  @override
  String get toolsEmptyInventoryTitle => 'Je hebt nog geen gereedschap';

  @override
  String get toolsEmptyInventoryHint => 'Koop gereedschap in de winkel';

  @override
  String get toolsNotEnoughMoney => 'Je hebt niet genoeg geld!';

  @override
  String get toolsNotEnoughMoneyRepair =>
      'Je hebt niet genoeg geld voor reparatie!';

  @override
  String get toolsBuyError => 'Fout bij kopen';

  @override
  String get toolsRepairError => 'Fout bij reparatie';

  @override
  String toolsPurchased(String toolName) {
    return '$toolName gekocht!';
  }

  @override
  String toolsRepaired(String toolName, String cost) {
    return '$toolName gerepareerd voor €$cost';
  }

  @override
  String get toolsBadgeInventoryFull => 'VOL';

  @override
  String get toolsBadgeBroken => 'KAPOT';

  @override
  String get toolsBadgeRepair => 'REPAREER';

  @override
  String toolsLoadError(String error) {
    return 'Gereedschap laden mislukt: $error';
  }

  @override
  String get toolsErrToolNotFound => 'Gereedschap niet gevonden.';

  @override
  String get toolsErrInventoryFullBuy =>
      'Je inventaris is vol. Berg gereedschap op of vergroot capaciteit.';

  @override
  String get toolsErrPurchaseServer =>
      'Aankoop mislukt door een serverprobleem.';

  @override
  String get toolsErrToolNotOwned => 'Je bezit dit gereedschap niet.';

  @override
  String get toolsErrAlreadyMaxDurability =>
      'Gereedschap heeft al maximale duurzaamheid.';

  @override
  String get toolsErrRepairServer =>
      'Reparatie mislukt door een serverprobleem.';

  @override
  String toolsNetworkError(String error) {
    return 'Netwerkfout: $error';
  }

  @override
  String get crimeOutcomeSuccess => 'Misdaad geslaagd!';

  @override
  String get crimeOutcomeCaught => 'Gepakt door de politie';

  @override
  String get crimeOutcomeVehicleBreakdownBefore =>
      'Je auto is kapot gegaan voordat je de locatie bereikte';

  @override
  String get crimeOutcomeVehicleBreakdownDuring =>
      'Auto kapot tijdens vlucht - meeste buit achtergelaten';

  @override
  String get crimeOutcomeOutOfFuel =>
      'Brandstof opgeraakt tijdens vlucht - te voet gevlucht, buit en auto verloren';

  @override
  String get crimeOutcomeToolBroke =>
      'Je gereedschap brak tijdens de misdaad en liet bewijs achter';

  @override
  String get crimeOutcomeFledNoLoot => 'Gevlucht zonder buit';

  @override
  String get crimeResultMoneyLabel => 'Geld';

  @override
  String get crimeResultXpLabel => 'XP';

  @override
  String get crimeOutcomeRowReward => 'Beloning:';

  @override
  String get crimeOutcomeRowXp => 'XP:';

  @override
  String get crimeOutcomeRowTools => 'Gereedschap:';

  @override
  String crimeOutcomeToolDurabilityValue(int percent) {
    return '-$percent% duurzaamheid';
  }

  @override
  String get icuIntensiveCareTitle => 'Intensieve zorg';

  @override
  String get icuInjuredLine =>
      'Je bent ernstig gewond geraakt tijdens je criminele activiteiten.';

  @override
  String get icuUnconsciousLine =>
      'Je ligt op de intensive care en bent buiten bewustzijn.';

  @override
  String get icuRecoveryTimeLabel => 'Herstel tijd:';

  @override
  String get icuWakeHp => 'Je komt bij met 10 HP';

  @override
  String get icuNoActionsHint =>
      'Tijdens deze tijd kun je geen acties uitvoeren.\nWees voorzichtiger met je gezondheid!';

  @override
  String jailBailPaidSnackbar(int amount) {
    return '🎉 Je bent vrij! Borg betaald: €$amount';
  }

  @override
  String jailInsufficientBail(int amount) {
    return 'Niet genoeg geld voor borg (€$amount)';
  }

  @override
  String jailCooldownWait(int seconds) {
    return 'Wacht nog ${seconds}s';
  }

  @override
  String get jailEscapeSuccess => '🎉 Ontsnapping gelukt! Je bent vrij.';

  @override
  String jailEscapeFailed(String penalty) {
    return 'Ontsnapping mislukt. Straf verlengd met $penalty.';
  }

  @override
  String get jailEscapeGenericFailure => 'Uitbraak mislukt';

  @override
  String jailErrorPrefix(String message) {
    return 'Fout: $message';
  }

  @override
  String get jailTimeLeft => 'Resterende tijd';

  @override
  String jailPayBail(int amount) {
    return 'Betaal borg (€$amount)';
  }

  @override
  String get jailCannotActWhileIn =>
      'Je kunt geen misdaden plegen, werken of reizen tijdens je celstraf.';

  @override
  String get jailAttemptEscape => 'Probeer uitbraak';

  @override
  String get jailYouAreInJail => 'Je zit in de cel';

  @override
  String get vehicleCondition => 'Conditie';

  @override
  String get vehicleFuel => 'Brandstof';

  @override
  String get vehicleSpeed => 'Snelheid';

  @override
  String get vehicleArmor => 'Pantser';

  @override
  String get vehicleStealth => 'Stealth';

  @override
  String get vehicleCargo => 'Lading';

  @override
  String get vehicleRepair => 'Repareren';

  @override
  String get vehicleRefuel => 'Tanken';

  @override
  String get selectCrimeVehicle => 'Selecteer Voertuig voor Misdaden';

  @override
  String get noVehicleSelected => 'Geen voertuig geselecteerd';

  @override
  String get selectedVehicle => 'Misdaad Voertuig';

  @override
  String get changeVehicle => 'Voertuig Wijzigen';

  @override
  String get selectVehicle => 'Voertuig Selecteren';

  @override
  String get vehicleConditionLow => 'Voertuig Conditie Laag';

  @override
  String get vehicleFuelLow => 'Voertuig Brandstof Laag';

  @override
  String get vehicleSelectedForCrimes => 'Voertuig geselecteerd voor misdaden!';

  @override
  String get vehicleDeselectedForCrimes =>
      'Voertuig gedeselecteerd voor misdaden!';

  @override
  String get vehicleWrongCountry =>
      'Voertuig moet in hetzelfde land zijn als jij';

  @override
  String get failedSelectVehicle => 'Fout bij selecteren voertuig';

  @override
  String get failedDeselectVehicle => 'Fout bij deselecteren voertuig';

  @override
  String get selectedForCrimesBadge => 'Geselecteerd voor misdaden';

  @override
  String get selectedButton => 'Geselecteerd';

  @override
  String get selectButton => 'Selecteer';

  @override
  String get deselectButton => 'Deselecteer';

  @override
  String get prostitutionTitle => 'Prostitutie';

  @override
  String get prostitutionTotal => 'Totaal';

  @override
  String get prostitutionStreet => 'Op Straat';

  @override
  String get prostitutionRedLight => 'Rood licht';

  @override
  String get prostitutionPotentialEarnings => 'Inkomsten';

  @override
  String get prostitutionCollect => 'Ophalen';

  @override
  String get prostitutionRecruit => 'Werven';

  @override
  String get prostitutionMyProstitutes => 'Mijn Prostituees';

  @override
  String get prostitutionRedLightDistricts => 'Rosse buurten';

  @override
  String get prostitutionNoProstitutes => 'Nog geen prostituees geworven';

  @override
  String get prostitutionLocation => 'Locatie';

  @override
  String get prostitutionMoveToRedLight => 'Naar rosse buurt';

  @override
  String get prostitutionMoveToRldShort => 'Naar RLD';

  @override
  String get prostitutionMoveToStreet => 'Verplaats naar Straat';

  @override
  String get prostitutionViewDistricts => 'Bekijk Districts';

  @override
  String get prostitutionAvailable => 'Beschikbaar';

  @override
  String get prostitutionMyDistricts => 'Mijn Districts';

  @override
  String get prostitutionCurrentRLD => 'Huidig RLD';

  @override
  String get prostitutionMyRLDs => 'Mijn RLD\'s';

  @override
  String get prostitutionNoAvailableDistricts => 'Geen districts beschikbaar';

  @override
  String get prostitutionNoOwnedDistricts => 'Je bezit nog geen districts';

  @override
  String get prostitutionRooms => 'kamers';

  @override
  String get prostitutionOccupancy => 'Bezetting';

  @override
  String get prostitutionIncome => 'Inkomsten';

  @override
  String get prostitutionTenants => 'Huurders';

  @override
  String get prostitutionBuy => 'Kopen';

  @override
  String get prostitutionManage => 'Beheren';

  @override
  String get prostitutionPurchaseConfirmTitle => 'District Kopen';

  @override
  String prostitutionPurchaseConfirmMessage(String country, int price) {
    return 'Weet je zeker dat je het Red Light District in $country wilt kopen voor €$price?';
  }

  @override
  String get prostitutionPurchase => 'Kopen';

  @override
  String get prostitutionPurchaseSuccess => 'District succesvol gekocht!';

  @override
  String get prostitutionPurchaseFailed => 'Aankoop mislukt';

  @override
  String get prostitutionDistrictManagement => 'District Beheer';

  @override
  String get prostitutionDistrictNotFound => 'District niet gevonden';

  @override
  String get prostitutionDistrictOwnedBadge => 'In eigendom';

  @override
  String get prostitutionOwnerLabel => 'Eigenaar:';

  @override
  String get prostitutionForSale => 'Te koop';

  @override
  String get prostitutionRoomsLabel => 'Kamers:';

  @override
  String get prostitutionRoomsRented => 'verhuurd';

  @override
  String prostitutionRldAppBarTitle(String country) {
    return 'Rosse buurt ($country)';
  }

  @override
  String get prostitutionOccupiedShort => 'Bezet';

  @override
  String get prostitutionNotApplicable => 'N.v.t.';

  @override
  String get back => 'Terug';

  @override
  String prostitutionMoveToStreetConfirm(String name) {
    return 'Weet je zeker dat je $name van het Red Light District naar de straat wilt verplaatsen?';
  }

  @override
  String get prostitutionMoveSuccess => 'Succesvol verplaatst';

  @override
  String get prostitutionMoveFailed => 'Verplaatsing mislukt';

  @override
  String get prostitutionNoStreetProstitutes =>
      'Geen prostituees op straat beschikbaar';

  @override
  String get prostitutionSelectProstitute => 'Selecteer Prostituee';

  @override
  String get prostitutionOnStreet => 'Op straat';

  @override
  String get prostitutionRoom => 'Kamer';

  @override
  String get prostitutionInRedLight => 'In de Wallen';

  @override
  String get prostitutionEarnings => 'Inkomsten';

  @override
  String get prostitutionRent => 'Huur';

  @override
  String get prostitutionNetIncome => 'Netto Inkomsten';

  @override
  String get prostitutionLevel => 'Niveau';

  @override
  String get prostitutionXpToNext => 'XP tot volgend level';

  @override
  String get prostitutionBusted => 'GEPAKT';

  @override
  String get prostitutionBustedCount => 'Aantal keer gepakt';

  @override
  String get prostitutionLevelBonus => 'Niveaubonus';

  @override
  String get prostitutionVipBonus => 'VIP bonus: +50% inkomsten';

  @override
  String get prostitutionUpgradeTier => 'Tier Upgraden';

  @override
  String get prostitutionUpgradeSecurity => 'Beveiliging Upgraden';

  @override
  String get prostitutionTier => 'Laag';

  @override
  String get prostitutionSecurity => 'Beveiliging';

  @override
  String get prostitutionTierBasic => 'Basis';

  @override
  String get prostitutionTierLuxury => 'Luxe';

  @override
  String get prostitutionTierVip => 'VIP';

  @override
  String get prostitutionSecurityLevel => 'Beveiligingsniveau';

  @override
  String get prostitutionRaidChance => 'Raid Kans';

  @override
  String get prostitutionMaxTier => 'Max tier bereikt';

  @override
  String get prostitutionMaxSecurity => 'Max beveiliging bereikt';

  @override
  String get prostitutionUpgradeSuccess => 'Upgrade succesvol!';

  @override
  String get prostitutionUpgradeFailed => 'Upgrade mislukt';

  @override
  String get vipEventsTitle => 'VIP-evenementen';

  @override
  String get vipEventsTabTitle => 'VIP-evenementen';

  @override
  String get vipEventsDescription =>
      'Wijs prostituees toe aan VIP events voor bonus inkomsten!';

  @override
  String get vipEventsActive => 'Actieve Events';

  @override
  String get vipEventsUpcoming => 'Aankomende Events';

  @override
  String get vipEventsMyParticipations => 'Mijn Actieve Deelnames';

  @override
  String get vipEventTypeTitle => 'VIP-evenement';

  @override
  String get vipEventCelebrity => 'Celebrity Bezoek';

  @override
  String get vipEventBachelor => 'Vrijgezellenfeest';

  @override
  String get vipEventConvention => 'Conferentie';

  @override
  String get vipEventFestival => 'Festival';

  @override
  String get vipEventBonus => 'BONUS';

  @override
  String get vipEventSpots => 'plekken';

  @override
  String get vipEventParticipants => 'Deelnemers';

  @override
  String get vipEventFull => 'EVENT VOL';

  @override
  String get vipEventRequires => 'Vereist';

  @override
  String get vipEventLevel => 'Niveau';

  @override
  String get vipEventLocation => 'Locatie';

  @override
  String get vipEventEndsIn => 'Eindigt over';

  @override
  String get vipEventStartsIn => 'Begint over';

  @override
  String get vipEventNoActive => 'Geen actieve events op dit moment';

  @override
  String get vipEventNoUpcoming => 'Geen aankomende events';

  @override
  String get vipEventAssignProstitute => 'Wijs Prostituee Toe';

  @override
  String get vipEventAssignDialogTitle => 'Wijs toe aan';

  @override
  String vipEventNoEligible(int level, String country) {
    return 'Geen geschikte prostituees. Vereist level $level+ in $country';
  }

  @override
  String get vipEventJoinSuccess => 'Deelgenomen aan event!';

  @override
  String get vipEventJoinFailed => 'Deelname mislukt';

  @override
  String get vipEventLeave => 'Event Verlaten';

  @override
  String get vipEventLeaveSuccess => 'Event verlaten';

  @override
  String get vipEventLeaveFailed => 'Kon event niet verlaten';

  @override
  String get vipEventAssigned => 'Toegewezen';

  @override
  String get vipEventPerHour => '/uur';

  @override
  String get vipEventEarnings => 'Verdiensten';

  @override
  String get prostitutionLeaderboardTitle => 'Prostitutie Leaderboard';

  @override
  String get prostitutionLeaderboardWeekly => 'Wekelijks';

  @override
  String get prostitutionLeaderboardMonthly => 'Maandelijks';

  @override
  String get prostitutionLeaderboardAllTime => 'Altijd';

  @override
  String get prostitutionLeaderboardYourRank => 'Jouw Wekelijkse Rang';

  @override
  String get prostitutionLeaderboardUnranked => 'Niet gerankt';

  @override
  String get prostitutionLeaderboardNoData => 'Nog geen leaderboard data';

  @override
  String get prostitutionLeaderboardButton => 'Leiderbord';

  @override
  String get prostitutionRivalryButton => 'Rivaliteit';

  @override
  String get prostitutionLeaderboardAchievements => 'Prestaties';

  @override
  String get prostitutionLeaderboardLoadFailed => 'Kon leaderboard niet laden';

  @override
  String get achievementsTitle => 'Prestaties';

  @override
  String achievementsProgress(int unlocked, int total) {
    return '$unlocked van $total ontgrendeld';
  }

  @override
  String get achievementsCategoryAll => 'Alle';

  @override
  String get achievementsCategoryProgression => 'Vooruitgang';

  @override
  String get achievementsCategoryWealth => 'Rijkdom';

  @override
  String get achievementsCategoryPower => 'Macht';

  @override
  String get achievementsCategorySocial => 'Sociaal';

  @override
  String get achievementsCategoryMastery => 'Meesterschap';

  @override
  String get achievementLocked => 'Vergrendeld';

  @override
  String get achievementReward => 'Beloning';

  @override
  String get achievementUnlocked => 'Ontgrendeld';

  @override
  String get achievementNoData => 'Geen prestaties gevonden';

  @override
  String get achievementLoadFailed => 'Kon prestaties niet laden';

  @override
  String achievementsMoney(String amount) {
    return '€$amount';
  }

  @override
  String achievementsXp(String xp) {
    return '$xp XP';
  }

  @override
  String achievementsUnlockedDate(String date) {
    return 'Ontgrendeld op $date';
  }

  @override
  String achievementsDetailProgress(int current, int required) {
    return 'Voortgang: $current/$required';
  }

  @override
  String get achievementsNoRewardConfigured => 'Nog geen reward ingesteld';

  @override
  String get achievementsRewardOnUnlock =>
      'Je ontvangt deze reward zodra de achievement is ontgrendeld.';

  @override
  String get achievementsDateToday => 'Vandaag';

  @override
  String get achievementsDateYesterday => 'Gisteren';

  @override
  String achievementsDateDaysAgo(int days) {
    return '$days dagen geleden';
  }

  @override
  String get achievementsDetails => 'Details';

  @override
  String get achievementsCategory => 'Categorie';

  @override
  String get achievementsSectionProgress => 'Voortgang';

  @override
  String achievementsPercentComplete(int percent) {
    return '$percent% voltooid';
  }

  @override
  String get achievementsCategoryNameProstitution => 'Prostitutie';

  @override
  String get achievementsCategoryNameRld => 'RLD';

  @override
  String get achievementsCategoryNameCrimes => 'Misdaden';

  @override
  String get achievementsCategoryNameJobs => 'Werk';

  @override
  String get achievementsCategoryNameSchool => 'School';

  @override
  String get achievementsCategoryNameVehicles => 'Voertuigen';

  @override
  String get achievementsCategoryNameTravel => 'Reizen';

  @override
  String get achievementsCategoryNameDrugs => 'Geneesmiddelen';

  @override
  String get achievementsCategoryNameTrade => 'Handel';

  @override
  String get achievementsCategoryNameGeneral => 'Algemeen';

  @override
  String get achievementJobItSpecialistTitle => 'IT-specialist';

  @override
  String get achievementJobItSpecialistDescription =>
      'Voltooi je eerste shift als Programmeur';

  @override
  String get achievementJobLawyerTitle => 'Straatadvocaat';

  @override
  String get achievementJobLawyerDescription =>
      'Voltooi je eerste shift als Advocaat';

  @override
  String get achievementJobDoctorTitle => 'Ondergrondse Dokter';

  @override
  String get achievementJobDoctorDescription =>
      'Voltooi je eerste shift als Dokter';

  @override
  String get achievementSchoolCertifiedTitle => 'Gecertificeerde Student';

  @override
  String get achievementSchoolCertifiedDescription =>
      'Behaal 3 schoolcertificaten';

  @override
  String get achievementSchoolMultiCertifiedTitle => 'Multi-Gecertificeerd';

  @override
  String get achievementSchoolMultiCertifiedDescription =>
      'Behaal 6 schoolcertificaten';

  @override
  String get achievementSchoolTrackSpecialistTitle => 'Spoorspecialist';

  @override
  String get achievementSchoolTrackSpecialistDescription =>
      'Max 3 school-tracks';

  @override
  String get schoolMenuLabel => 'School';

  @override
  String get schoolMenuSubtitle => 'Level je opleidingen en certificaten';

  @override
  String get schoolTitle => 'School & Opleiding';

  @override
  String get schoolIntro =>
      'Ontgrendel jobs en assets via levels en certificaten.';

  @override
  String get schoolTracksTitle => 'Beschikbare opleidingen';

  @override
  String get schoolUnlockableContentTitle => 'Vergrendelde opleidingen';

  @override
  String schoolOverallLevelLabel(int level) {
    return 'Schoolniveau: $level';
  }

  @override
  String schoolLoadError(String error) {
    return 'Kon schoolgegevens niet laden: $error';
  }

  @override
  String schoolTrackLevelLabel(int current, int max) {
    return 'Niveau $current/$max';
  }

  @override
  String schoolXpLabel(int xp) {
    return 'XP: $xp';
  }

  @override
  String schoolCertificationRequiredLevel(String name, int level) {
    return '$name (Lv $level)';
  }

  @override
  String get schoolGateStatusOpen => 'OPEN';

  @override
  String get schoolGateStatusLocked => 'GESLOTEN';

  @override
  String schoolGateRankProgress(int current, int required) {
    return 'Spelerrang: $current/$required';
  }

  @override
  String schoolGateTrackLevelProgress(String track, int current, int required) {
    return '$track niveau: $current/$required';
  }

  @override
  String schoolGateJobTarget(String target) {
    return 'Taak: $target';
  }

  @override
  String get schoolGateAssetCasinoPurchase => 'Asset: Casino aankoop';

  @override
  String get schoolGateAssetAmmoFactoryPurchase =>
      'Asset: Munitiefabriek aankoop';

  @override
  String get schoolGateAssetAmmoOutputUpgrade =>
      'Asset: Munitiefabriek output upgrade';

  @override
  String get schoolGateAssetAmmoQualityUpgrade =>
      'Asset: Munitiefabriek quality upgrade';

  @override
  String get schoolGateAssetDrugFacilitySlotsTier1 =>
      'Asset: Drugsfaciliteit slot-upgrade I';

  @override
  String get schoolGateAssetDrugFacilitySlotsTier2 =>
      'Asset: Drugsfaciliteit slot-upgrade II';

  @override
  String get schoolGateAssetDrugFacilitySlotsTier3 =>
      'Asset: Drugsfaciliteit slot-upgrade III';

  @override
  String get schoolGateAssetDrugFacilitySlotsTier4 =>
      'Asset: Drugsfaciliteit slot-upgrade IV';

  @override
  String get schoolGateAssetDrugFacilityEquipmentTier1 =>
      'Asset: Drugsfaciliteit apparatuur-upgrade I';

  @override
  String get schoolGateAssetDrugFacilityEquipmentTier2 =>
      'Asset: Drugsfaciliteit apparatuur-upgrade II';

  @override
  String get schoolGateAssetDrugFacilityEquipmentTier3 =>
      'Asset: Drugsfaciliteit apparatuur-upgrade III';

  @override
  String schoolGateAssetGeneric(String target) {
    return 'Activa: $target';
  }

  @override
  String schoolGateSystemGeneric(String type, String target) {
    return '$type: $target';
  }

  @override
  String get educationDialogDefaultTitle => '🔒 Opleiding vereist';

  @override
  String get educationDialogFallbackMessage =>
      'Vereisten niet gehaald. Voltooi opleidingseisen om verder te gaan.';

  @override
  String get educationDialogClose => 'Sluiten';

  @override
  String get educationLockedJobsSectionTitle =>
      '🔒 Vergrendelde jobs (opleiding vereist)';

  @override
  String get educationAmmoOutputUpgradeLockedTitle =>
      '🔒 Output upgrade vergrendeld';

  @override
  String get educationAmmoQualityUpgradeLockedTitle =>
      '🔒 Kwaliteit upgrade vergrendeld';

  @override
  String get educationAmmoFactoryPurchaseLockedTitle =>
      '🔒 Fabriek aankoop vergrendeld';

  @override
  String educationRequirementRankProgress(int requiredRank, int currentRank) {
    return 'Nodig: spelerrang $requiredRank · Huidig: spelerrang $currentRank';
  }

  @override
  String get educationRequirementTrackLevelTitle => 'Opleidingsniveau';

  @override
  String educationRequirementTrackLevelProgress(
    String trackName,
    int requiredLevel,
    int currentLevel,
  ) {
    return '$trackName level $requiredLevel vereist · Huidig $currentLevel';
  }

  @override
  String get educationRequirementCertificationTitle => 'Certificaat vereist';

  @override
  String get educationRequirementGenericTitle => 'Voorwaarde';

  @override
  String get educationRequirementUnknown => 'Onbekende vereiste';

  @override
  String get educationTrackNameAviation => 'Luchtvaart';

  @override
  String get educationTrackNameLaw => 'Rechten';

  @override
  String get educationTrackNameMedicine => 'Geneeskunde';

  @override
  String get educationTrackNameFinance => 'Financiën';

  @override
  String get educationTrackNameEngineering => 'Techniek';

  @override
  String get educationTrackNameIt => 'HET';

  @override
  String get educationTrackNameNarcotics => 'Narcoticatechnologie';

  @override
  String get schoolTrackDescriptionAviation =>
      'Vliegtheorie, navigatie en vliegtuigbediening.';

  @override
  String get schoolTrackDescriptionLaw =>
      'Strafrecht, procedures en praktijk in de rechtszaal.';

  @override
  String get schoolTrackDescriptionMedicine =>
      'Spoedzorg, diagnostiek en medische praktijk.';

  @override
  String get schoolTrackDescriptionFinance =>
      'Boekhouding, investeringen en bedrijfsvoering.';

  @override
  String get schoolTrackDescriptionEngineering =>
      'Mechanische systemen, industriële veiligheid en productie.';

  @override
  String get schoolTrackDescriptionIt =>
      'Softwareontwikkeling, systemen en netwerkbeheer.';

  @override
  String get schoolTrackDescriptionNarcotics =>
      'Gecontroleerde teelt, proces-elektra en geavanceerde chemische productie.';

  @override
  String schoolTrackCooldownActive(int seconds) {
    return 'Cooldown actief: nog ${seconds}s';
  }

  @override
  String get schoolTrackMaxLevelReached => 'Track is al max level';

  @override
  String get schoolTrackStartFailed => 'Opleiding starten mislukt';

  @override
  String get educationCertHydroponicSpecialist =>
      'Hydroponics specialist certificaat';

  @override
  String get educationCertProcessElectricsSpecialist =>
      'Proceselektrica specialist certificaat';

  @override
  String get educationCertClandestineChemist =>
      'Clandestien chemicus certificaat';

  @override
  String get educationCertNarcoGridArchitect =>
      'Narco grid architect certificaat';

  @override
  String get educationCertSoftwareEngineer => 'Software Engineer Certificaat';

  @override
  String get educationCertBarExam => 'Advocatenexamen';

  @override
  String get educationCertMedicalLicense => 'Medische Licentie';

  @override
  String get educationCertFlightCommercial => 'Commerciële Vlieglicentie';

  @override
  String get educationCertFlightBasic => 'Basis Vlieglicentie';

  @override
  String get educationCertIndustrialSafety => 'Industrieveiligheid Certificaat';

  @override
  String get educationCertFinancialAnalyst => 'Financieel Analist Certificaat';

  @override
  String get educationCertCasinoManagement => 'Casino Management Certificaat';

  @override
  String get educationCertParamedic => 'Paramedic Certificaat';

  @override
  String get prostitutionLeaderboardProstitutesUnit => 'prostituees';

  @override
  String get prostitutionLeaderboardDistrictsUnit => 'districten';

  @override
  String get rivalryTitle => 'Rivaliteit';

  @override
  String get rivalryChallengeTitle => 'Daag speler uit';

  @override
  String get rivalryChallengeHint =>
      'Voer een speler-ID in om een rivaliteit te starten.';

  @override
  String get rivalryPlayerIdHint => 'Speler-ID';

  @override
  String get rivalryStartButton => 'Begin';

  @override
  String get rivalryNoActive => 'Nog geen actieve rivaliteiten.';

  @override
  String get rivalryActiveTitle => 'Actieve rivalen';

  @override
  String get rivalryScoreLabel => 'Rivaliteitsscore';

  @override
  String get rivalryRecentActivity => 'Recente activiteit';

  @override
  String get rivalryNoActivity => 'Nog geen sabotage-activiteit';

  @override
  String get rivalryCooldownReady => 'Sabotage beschikbaar';

  @override
  String rivalryCooldownIn(String duration) {
    return 'Afkoelperiode: $duration';
  }

  @override
  String get rivalryActionTipPolice => 'Tip politie (€5k)';

  @override
  String get rivalryActionStealCustomer => 'Steel klant (€3k)';

  @override
  String get rivalryActionDamageReputation => 'Schade reputatie (€10k)';

  @override
  String get rivalryActionBribeEmployee => 'Omkopen medewerker (€8k)';

  @override
  String get rivalryUpdateMessage => 'Rivaliteit bijgewerkt';

  @override
  String get rivalrySabotageExecuted => 'Sabotage uitgevoerd';

  @override
  String get rivalryConfirmTitle => 'Bevestig sabotage';

  @override
  String rivalryConfirmTarget(String username) {
    return 'Doelwit: $username';
  }

  @override
  String rivalryConfirmAction(String action) {
    return 'Actie: $action';
  }

  @override
  String rivalryConfirmCost(int amount) {
    return 'Kosten: €$amount';
  }

  @override
  String rivalryConfirmEffect(String effect) {
    return 'Effect: $effect';
  }

  @override
  String get rivalryConfirmWarning =>
      'Succes is niet gegarandeerd en je kunt geld verliezen.';

  @override
  String get rivalryExecuteButton => 'Uitvoeren';

  @override
  String get rivalryEffectTipPolice => 'Verhoog politiedruk op rivaal';

  @override
  String get rivalryEffectStealCustomer =>
      'Steel een deel van rivaliserende inkomsten';

  @override
  String get rivalryEffectDamageReputation =>
      'Verlaag voortgang van rivaliserende prostituees';

  @override
  String get rivalryEffectBribeEmployee =>
      'Zet één rivaliserende prostituee op busted';

  @override
  String get prostitutionUnderAttackTitle => 'Je imperium ligt onder aanval';

  @override
  String prostitutionUnderAttackBody(String attacker, String action) {
    return '$attacker gebruikte $action tegen jou in de afgelopen 24u.';
  }

  @override
  String get prostitutionUnderAttackAction => 'Open rivaliteit';

  @override
  String get prostitutionBetrayalDefaultMessage =>
      'Verraad! Je nightclub werd getroffen door een informatielek.';

  @override
  String get prostitutionLoadError => 'Fout bij laden van gegevens';

  @override
  String get prostitutionNoDistrictInCountry =>
      'Geen Red Light District in dit land';

  @override
  String get prostitutionMovedToStreet => 'Verplaatst naar straat';

  @override
  String get prostitutionArrestedCannotAssign =>
      'Deze hoer is gearresteerd en kan niet worden toegewezen.';

  @override
  String get prostitutionNoNightclubVenue =>
      'Je hebt nog geen nightclub-locatie om personeel toe te wijzen.';

  @override
  String get prostitutionNightclubVenueName => 'Nachtclub';

  @override
  String prostitutionNightclubVenueNumbered(int id) {
    return 'Nachtclub #$id';
  }

  @override
  String get prostitutionAssignedNightclub => 'Toegewezen aan nightclub';

  @override
  String get prostitutionArrestedCannotWork =>
      'Deze hoer is gearresteerd en kan niet werken.';

  @override
  String prostitutionShiftRestNeeded(String duration) {
    return 'Nog $duration rust nodig voor de volgende shift.';
  }

  @override
  String get prostitutionWorkShiftCompleted => 'Dienst afgerond';

  @override
  String get prostitutionNoWorkersToAssign =>
      'Geen beschikbare hoeren om te laten werken.';

  @override
  String prostitutionWorkAllSentCount(int count) {
    return '$count hoeren naar werk gestuurd.';
  }

  @override
  String prostitutionWorkAllPartial(int success, int failed) {
    return '$success naar werk gestuurd, $failed mislukt.';
  }

  @override
  String get prostitutionRecruitedDefault => 'Geworven!';

  @override
  String get prostitutionRecruitFailed => 'Werving mislukt';

  @override
  String get prostitutionRecruitConnectionError =>
      'Werving mislukt door een verbindingsfout';

  @override
  String get prostitutionEventUpdate => 'Evenement bijgewerkt';

  @override
  String get prostitutionBuyPropertyFirst =>
      'Koop eerst een huis of appartement';

  @override
  String prostitutionWorkAll(int count) {
    return 'Alle laten werken ($count)';
  }

  @override
  String get prostitutionNoHousingForRecruit =>
      'Geen vrije huisvestingsslot. Koop of upgrade een huis of appartement voordat je meer hoeren werft.';

  @override
  String get prostitutionHousingTitle => 'Huisvesting';

  @override
  String prostitutionHousingRentRule(int days) {
    return 'Elke hoer moet minimaal één shift per $days dagen werken om de huur te betalen.';
  }

  @override
  String get prostitutionHousingSlots => 'Plekken';

  @override
  String get prostitutionHousingFree => 'Vrij';

  @override
  String get prostitutionHousingHomes => 'Woningen';

  @override
  String get prostitutionHousingAvgUpgrade => 'Gem. upgrade';

  @override
  String get prostitutionHousingHappinessBonus => 'Gelukbonus';

  @override
  String get prostitutionHousingWeeklyRent => 'Weekhuur';

  @override
  String get prostitutionHousingAtRisk => 'In gevaar';

  @override
  String get prostitutionHousingSafe => 'Veilig';

  @override
  String prostitutionBetrayalActiveDetail(int grams, int licenses) {
    return 'Verraad geactiveerd: ${grams}g drugs in beslag genomen, $licenses nightclublicentie(s) ingetrokken.';
  }

  @override
  String get prostitutionEarningsInsightTitle =>
      'Inzicht verdiensten (actieve hoeren)';

  @override
  String prostitutionEarningsStreetDetail(int count, int euros) {
    return 'Straat: $count • €$euros/uur';
  }

  @override
  String prostitutionEarningsRldDetail(int count, int euros) {
    return 'RLD: $count • €$euros/uur';
  }

  @override
  String prostitutionEarningsNightclubDetail(int count, int euros) {
    return 'Nightclub: $count • €$euros/uur';
  }

  @override
  String prostitutionEarningsTotalDetail(int euros) {
    return 'Totaal: €$euros/uur';
  }

  @override
  String get prostitutionHappinessEcstatic => 'Extatisch';

  @override
  String get prostitutionHappinessHappy => 'Blij';

  @override
  String get prostitutionHappinessStable => 'Stabiel';

  @override
  String get prostitutionHappinessStressed => 'Gestrest';

  @override
  String get prostitutionHappinessMiserable => 'Miserabel';

  @override
  String get prostitutionHousingExpired => 'Verlopen';

  @override
  String prostitutionHousingDaysLeft(int days) {
    return 'nog $days d';
  }

  @override
  String get prostitutionHousingLessThanOneDay => 'Minder dan 1 dag';

  @override
  String get prostitutionNightclubShort => 'Nachtclub';

  @override
  String get prostitutionMoveToStreetButton => 'Naar straat';

  @override
  String get prostitutionMoveToNightclubButton => 'Naar nightclub';

  @override
  String prostitutionEuroPerHour(String amount) {
    return '€$amount/uur';
  }

  @override
  String prostitutionHappinessDetail(String label, int score, String bonus) {
    return 'Geluk $label ($score%) • Opbrengst $bonus';
  }

  @override
  String prostitutionHousingStatus(String status) {
    return 'Huisvesting: $status';
  }

  @override
  String prostitutionWeeklyRentEuro(int amount) {
    return 'Weekhuur €$amount';
  }

  @override
  String get prostitutionWork8h => 'Werk 8 uur';

  @override
  String prostitutionRestFor(String duration) {
    return 'Rust $duration';
  }

  @override
  String prostitutionNextShiftIn(String duration) {
    return 'Volgende shift over $duration';
  }

  @override
  String prostitutionTimeHoursMinutes(int hours, int minutes) {
    return '$hours u $minutes m';
  }

  @override
  String get rivalryProtectionTitle => 'Beschermingsverzekering';

  @override
  String get rivalryProtectionDescription =>
      'Vermindert inkomende sabotage-impact met 30% voor 7 dagen.';

  @override
  String get rivalryProtectionInactive => 'Geen actieve bescherming';

  @override
  String rivalryProtectionActive(String date) {
    return 'Actief tot: $date';
  }

  @override
  String get rivalryProtectionBuy => 'Koop bescherming (€25k/week)';

  @override
  String get rivalryProtectionActivated =>
      'Beschermingsverzekering geactiveerd';

  @override
  String get achievementTitle_first_steps => 'Eerste Stappen';

  @override
  String get achievementDescription_first_steps => 'Recruit je eerste hoer';

  @override
  String get achievementTitle_growing_empire => 'Groeiend Imperium';

  @override
  String get achievementDescription_growing_empire => 'Recruit 5 hoeren';

  @override
  String get achievementTitle_first_district => 'Eerste District';

  @override
  String get achievementDescription_first_district =>
      'Koop je eerste red light district';

  @override
  String get achievementTitle_empire_builder => 'Imperiumbouwer';

  @override
  String get achievementDescription_empire_builder =>
      'Bezitt 5 red light districts';

  @override
  String get achievementTitle_district_master => 'District Meester';

  @override
  String get achievementDescription_district_master =>
      'Bezitt 10 red light districts';

  @override
  String get achievementTitle_leveling_master => 'Level Meester';

  @override
  String get achievementDescription_leveling_master =>
      'Breng een hoer naar level 10';

  @override
  String get achievementTitle_untouchable => 'Onaantastbaar';

  @override
  String get achievementDescription_untouchable =>
      'Word 7 dagen op rij niet busted';

  @override
  String get achievementTitle_millionaire => 'Miljonair';

  @override
  String get achievementDescription_millionaire =>
      'Verdien in totaal €1.000.000';

  @override
  String get achievementTitle_high_roller => 'Hoge rol';

  @override
  String get achievementDescription_high_roller =>
      'Verdien in totaal €5.000.000';

  @override
  String get achievementTitle_vip_service => 'VIP-service';

  @override
  String get achievementDescription_vip_service => 'Voltooi 10 VIP-events';

  @override
  String get achievementTitle_event_enthusiast => 'Event Enthousiast';

  @override
  String get achievementDescription_event_enthusiast => 'Voltooi 25 VIP-events';

  @override
  String get achievementTitle_security_expert => 'Beveiligingsexpert';

  @override
  String get achievementDescription_security_expert =>
      'Maximaliseer security op al je districten';

  @override
  String get achievementTitle_luxury_provider => 'Luxe Aanbieder';

  @override
  String get achievementDescription_luxury_provider =>
      'Upgrade 3 districten naar VIP-tier';

  @override
  String get achievementTitle_rivalry_victor => 'Rivaliteit Overwinnaar';

  @override
  String get achievementDescription_rivalry_victor =>
      'Saboteer rivalen 10 keer succesvol';

  @override
  String get achievementTitle_untouchable_rival => 'Onaantastbare Rivaal';

  @override
  String get achievementDescription_untouchable_rival =>
      'Verdedig 20 sabotagepogingen';

  @override
  String get achievementTitle_crime_first_blood => 'Eerste Bloed';

  @override
  String get achievementDescription_crime_first_blood =>
      'Voltooi je eerste misdaad succesvol';

  @override
  String get achievementTitle_crime_hustler => 'Misdaad Hustler';

  @override
  String get achievementDescription_crime_hustler =>
      'Voltooi 5 misdaden succesvol';

  @override
  String get achievementTitle_crime_novice => 'Misdaad Beginner';

  @override
  String get achievementDescription_crime_novice =>
      'Voltooi 10 misdaden succesvol';

  @override
  String get achievementTitle_crime_operator => 'Misdaad Operator';

  @override
  String get achievementDescription_crime_operator =>
      'Voltooi 25 misdaden succesvol';

  @override
  String get achievementTitle_crime_wave => 'Misdaadgolf';

  @override
  String get achievementDescription_crime_wave =>
      'Voltooi 50 misdaden succesvol';

  @override
  String get achievementTitle_crime_mastermind => 'Misdaad Mastermind';

  @override
  String get achievementDescription_crime_mastermind =>
      'Voltooi 100 misdaden succesvol';

  @override
  String get achievementTitle_the_godfather => 'De peetvader';

  @override
  String get achievementDescription_the_godfather =>
      'Voltooi 250 misdaden succesvol';

  @override
  String get achievementTitle_crime_emperor => 'Misdaad Keizer';

  @override
  String get achievementDescription_crime_emperor =>
      'Voltooi 500 misdaden succesvol';

  @override
  String get achievementTitle_crime_legend => 'Misdaad Legende';

  @override
  String get achievementDescription_crime_legend =>
      'Voltooi 1000 misdaden succesvol';

  @override
  String get achievementTitle_crime_getaway_driver => 'Vluchtauto Chauffeur';

  @override
  String get achievementDescription_crime_getaway_driver =>
      'Voltooi je eerste misdaad met voertuig';

  @override
  String get achievementTitle_crime_armed_and_ready => 'Gewapend en Klaar';

  @override
  String get achievementDescription_crime_armed_and_ready =>
      'Voltooi je eerste misdaad met wapenvereiste';

  @override
  String get achievementTitle_crime_full_loadout => 'Volledige Uitrusting';

  @override
  String get achievementDescription_crime_full_loadout =>
      'Voltooi een misdaad met voertuig, wapen en tools';

  @override
  String get achievementTitle_crime_completionist => 'Misdaad Completionist';

  @override
  String get achievementDescription_crime_completionist =>
      'Voltooi elk misdaadtype minstens één keer';

  @override
  String get achievementTitle_job_first_shift => 'Eerste Shift';

  @override
  String get achievementDescription_job_first_shift =>
      'Voltooi je eerste job succesvol';

  @override
  String get achievementTitle_job_hustler => 'Werk Hustler';

  @override
  String get achievementDescription_job_hustler => 'Voltooi 5 jobs succesvol';

  @override
  String get achievementTitle_job_starter => 'Werk Starter';

  @override
  String get achievementDescription_job_starter => 'Voltooi 10 jobs succesvol';

  @override
  String get achievementTitle_job_operator => 'Werk Operator';

  @override
  String get achievementDescription_job_operator => 'Voltooi 25 jobs succesvol';

  @override
  String get achievementTitle_job_grinder => 'Werk Grinder';

  @override
  String get achievementDescription_job_grinder => 'Voltooi 50 jobs succesvol';

  @override
  String get achievementTitle_job_master => 'Werk Master';

  @override
  String get achievementDescription_job_master => 'Voltooi 100 jobs succesvol';

  @override
  String get achievementTitle_job_expert => 'Werk Expert';

  @override
  String get achievementDescription_job_expert => 'Voltooi 250 jobs succesvol';

  @override
  String get achievementTitle_job_elite => 'Werk Elite';

  @override
  String get achievementDescription_job_elite => 'Voltooi 500 jobs succesvol';

  @override
  String get achievementTitle_job_legend => 'Werk Legende';

  @override
  String get achievementDescription_job_legend => 'Voltooi 1000 jobs succesvol';

  @override
  String get achievementTitle_job_completionist => 'Werk Completionist';

  @override
  String get achievementDescription_job_completionist =>
      'Voltooi elk jobtype minstens één keer';

  @override
  String get achievementTitle_job_educated_worker => 'Opgeleide Werker';

  @override
  String get achievementDescription_job_educated_worker =>
      'Voltooi 1 job met opleidingseisen';

  @override
  String get achievementTitle_job_certified_hustler =>
      'Gecertificeerde Hustler';

  @override
  String get achievementDescription_job_certified_hustler =>
      'Voltooi 25 jobs met opleidingseisen';

  @override
  String get achievementTitle_job_education_completionist =>
      'Educatie Job Completionist';

  @override
  String get achievementDescription_job_education_completionist =>
      'Voltooi elk education-gated jobtype minstens één keer';

  @override
  String get achievementTitle_job_it_specialist => 'IT-specialist';

  @override
  String get achievementDescription_job_it_specialist =>
      'Voltooi je eerste shift als Programmeur';

  @override
  String get achievementTitle_job_lawyer => 'Straatadvocaat';

  @override
  String get achievementDescription_job_lawyer =>
      'Voltooi je eerste shift als Advocaat';

  @override
  String get achievementTitle_job_doctor => 'Ondergrondse Dokter';

  @override
  String get achievementDescription_job_doctor =>
      'Voltooi je eerste shift als Dokter';

  @override
  String get achievementTitle_school_certified => 'Gecertificeerde Student';

  @override
  String get achievementDescription_school_certified =>
      'Behaal 3 schoolcertificaten';

  @override
  String get achievementTitle_school_multi_certified => 'Multi-Gecertificeerd';

  @override
  String get achievementDescription_school_multi_certified =>
      'Behaal 6 schoolcertificaten';

  @override
  String get achievementTitle_school_track_specialist => 'Spoorspecialist';

  @override
  String get achievementDescription_school_track_specialist =>
      'Max 3 school-tracks';

  @override
  String get achievementTitle_school_freshman => 'Schooleerstejaars';

  @override
  String get achievementDescription_school_freshman => 'Bereik schoollevel 1';

  @override
  String get achievementTitle_school_scholar => 'Schoolgeleerde';

  @override
  String get achievementDescription_school_scholar => 'Bereik schoollevel 3';

  @override
  String get achievementTitle_school_graduate => 'Schoolafgestudeerd';

  @override
  String get achievementDescription_school_graduate => 'Bereik schoollevel 5';

  @override
  String get achievementTitle_school_mastermind => 'Academische Mastermind';

  @override
  String get achievementDescription_school_mastermind =>
      'Bereik schoollevel 10';

  @override
  String get achievementTitle_school_doctorate => 'Straatdoctoraat';

  @override
  String get achievementDescription_school_doctorate => 'Bereik schoollevel 20';

  @override
  String get achievementTitle_road_bandit => 'Weg Bandiet';

  @override
  String get achievementDescription_road_bandit => 'Steel 5 auto\'s';

  @override
  String get achievementTitle_grand_theft_fleet => 'Grote Diefstalvloot';

  @override
  String get achievementDescription_grand_theft_fleet => 'Steel 25 auto\'s';

  @override
  String get achievementTitle_sea_raider => 'Zee Rover';

  @override
  String get achievementDescription_sea_raider => 'Steel 3 boten';

  @override
  String get achievementTitle_captain_of_smugglers =>
      'Kapitein van Smokkelaars';

  @override
  String get achievementDescription_captain_of_smugglers => 'Steel 12 boten';

  @override
  String get achievementTitle_globe_trotter => 'Wereldreiziger';

  @override
  String get achievementDescription_globe_trotter => 'Voltooi 5 reizen';

  @override
  String get achievementTitle_jet_setter => 'Jetsetter';

  @override
  String get achievementDescription_jet_setter => 'Voltooi 25 reizen';

  @override
  String get achievementTitle_chemist_apprentice => 'Chemie Leerling';

  @override
  String get achievementDescription_chemist_apprentice =>
      'Voltooi 10 drugsproducties';

  @override
  String get achievementTitle_narco_chemist => 'Narco Chemicus';

  @override
  String get achievementDescription_narco_chemist =>
      'Voltooi 100 drugsproducties';

  @override
  String get achievementTitle_street_merchant => 'Straathandelaar';

  @override
  String get achievementDescription_street_merchant => 'Voltooi 25 trades';

  @override
  String get achievementTitle_trade_tycoon => 'Handel Tycoon';

  @override
  String get achievementDescription_trade_tycoon => 'Voltooi 150 trades';

  @override
  String get achievementTitle_prostitute_lineup => 'Opgesteld';

  @override
  String get achievementDescription_prostitute_lineup => 'Recruit 10 hoeren';

  @override
  String get achievementTitle_prostitute_network => 'Straat Netwerk';

  @override
  String get achievementDescription_prostitute_network => 'Recruit 25 hoeren';

  @override
  String get achievementTitle_prostitute_syndicate => 'Syndicaat';

  @override
  String get achievementDescription_prostitute_syndicate => 'Recruit 50 hoeren';

  @override
  String get achievementTitle_prostitute_dynasty => 'Dynastie';

  @override
  String get achievementDescription_prostitute_dynasty => 'Recruit 100 hoeren';

  @override
  String get achievementTitle_prostitute_empire_250 => 'Imperium 250';

  @override
  String get achievementDescription_prostitute_empire_250 =>
      'Recruit 250 hoeren';

  @override
  String get achievementTitle_prostitute_cartel_500 => 'Kartel 500';

  @override
  String get achievementDescription_prostitute_cartel_500 =>
      'Recruit 500 hoeren';

  @override
  String get achievementTitle_prostitute_legend_1000 => 'Legende 1000';

  @override
  String get achievementDescription_prostitute_legend_1000 =>
      'Recruit 1000 hoeren';

  @override
  String get achievementTitle_vip_prostitute_level_10 => 'VIP-beginner';

  @override
  String get achievementDescription_vip_prostitute_level_10 =>
      'Bereik level 3 met een VIP-hoer';

  @override
  String get achievementTitle_vip_prostitute_level_25 => 'VIP-headliner';

  @override
  String get achievementDescription_vip_prostitute_level_25 =>
      'Bereik level 5 met een VIP-hoer';

  @override
  String get achievementTitle_vip_prostitute_level_50 => 'VIP Icoon';

  @override
  String get achievementDescription_vip_prostitute_level_50 =>
      'Bereik level 7 met een VIP-hoer';

  @override
  String get achievementTitle_vip_prostitute_level_100 => 'VIP Legende';

  @override
  String get achievementDescription_vip_prostitute_level_100 =>
      'Bereik level 10 met een VIP-hoer';

  @override
  String get achievementTitle_nightclub_opening_night => 'Openingsnacht';

  @override
  String get achievementDescription_nightclub_opening_night =>
      'Open je eerste nightclub venue';

  @override
  String get achievementTitle_nightclub_headliner => 'Headliner Boeker';

  @override
  String get achievementDescription_nightclub_headliner =>
      'Boek 10 DJ-shifts voor je nightclub-imperium';

  @override
  String get achievementTitle_nightclub_full_house => 'Vol Huis';

  @override
  String get achievementDescription_nightclub_full_house =>
      'Breng een nightclub crowd naar 90% capaciteit';

  @override
  String get achievementTitle_nightclub_cash_machine => 'Geldautomaat';

  @override
  String get achievementDescription_nightclub_cash_machine =>
      'Verdien in totaal €250.000 nightclub-omzet';

  @override
  String get achievementTitle_nightclub_empire => 'Nightlife Imperium';

  @override
  String get achievementDescription_nightclub_empire =>
      'Verdien in totaal €1.000.000 nightclub-omzet';

  @override
  String get achievementTitle_nightclub_staffing_boss => 'Personeelsbaas';

  @override
  String get achievementDescription_nightclub_staffing_boss =>
      'Laat 3 actieve nightclub-crewmembers tegelijk draaien';

  @override
  String get achievementTitle_nightclub_vip_room => 'VIP-kamer';

  @override
  String get achievementDescription_nightclub_vip_room =>
      'Wijs 2 VIP-crewmembers toe aan je nightclub';

  @override
  String get achievementTitle_nightclub_head_of_security => 'Hoofd Beveiliging';

  @override
  String get achievementDescription_nightclub_head_of_security =>
      'Huur 10 beveiligingsshifts voor je nightclub';

  @override
  String get achievementTitle_nightclub_podium_finish => 'Podiumplek';

  @override
  String get achievementDescription_nightclub_podium_finish =>
      'Eindig in de top 3 van een wekelijkse nightclub-season';

  @override
  String get achievementTitle_nightclub_season_champion => 'Season Kampioen';

  @override
  String get achievementDescription_nightclub_season_champion =>
      'Win een wekelijkse nightclub-season';

  @override
  String get nightclubManagementTitle => 'Nachtclub Beheer';

  @override
  String get nightclubRealtimeStatus => 'Realtime status actief';

  @override
  String get nightclubRefresh => 'Vernieuwen';

  @override
  String get nightclubEmptyTitle => 'Nog geen nachtclub gevonden';

  @override
  String get nightclubEmptyBody =>
      'Koop eerst een nachtclub in Eigendommen om dit systeem te activeren.';

  @override
  String get nightclubLocationTitle => 'Nachtclub Locatie';

  @override
  String get nightclubSelectVenue => 'Selecteer venue';

  @override
  String get nightclubLiveStatistics => 'Live Statistieken';

  @override
  String get nightclubKpiCrowd => 'Menigte';

  @override
  String get nightclubKpiVibe => 'Stemming';

  @override
  String get nightclubKpiToday => 'Vandaag';

  @override
  String get nightclubKpiAllTime => 'Altijd';

  @override
  String get nightclubKpiStock => 'Voorraad';

  @override
  String get nightclubKpiDj => 'DJ';

  @override
  String get nightclubKpiThefts => 'Diefstallen';

  @override
  String get nightclubKpiStaff => 'Personeel';

  @override
  String get nightclubKpiSalesBoost => 'Verkoopboost';

  @override
  String get nightclubKpiPriceBoost => 'Prijsverhoging';

  @override
  String get nightclubKpiVipBonus => 'VIP-bonus';

  @override
  String get nightclubStatusActive => 'Actief';

  @override
  String get nightclubStatusOff => 'Uit';

  @override
  String get nightclubStatusActiveLower => 'actief';

  @override
  String get nightclubRevenueTrend => 'Omzet Trend (live)';

  @override
  String get nightclubLeaderboardTitle => 'Topnachtclubs';

  @override
  String get nightclubLeaderboardCountry => 'Land';

  @override
  String get nightclubLeaderboardGlobal => 'Wereld';

  @override
  String get nightclubLeaderboardEmpty => 'Nog geen leaderboard data';

  @override
  String get nightclubLeaderboardRevenue24h => '24h omzet';

  @override
  String get nightclubSeasonProcessing => 'wordt verwerkt...';

  @override
  String get nightclubSeasonTitle => 'Wekelijkse seizoensranglijst';

  @override
  String get nightclubSeasonResetIn => 'Reset over';

  @override
  String get nightclubSeasonYourRewards => 'Jouw season rewards';

  @override
  String get nightclubSeasonCurrentTop5 => 'Huidige week top 5';

  @override
  String get nightclubSeasonEmpty => 'Nog geen season data';

  @override
  String get nightclubSeasonWeekRevenue => 'Week omzet';

  @override
  String get nightclubSeasonScore => 'Scoren';

  @override
  String get nightclubSeasonRecentPayouts => 'Recente payouts';

  @override
  String get nightclubSeasonNoPayouts => 'Nog geen payouts';

  @override
  String get nightclubSalesTitle => 'Recente Verkopen';

  @override
  String get nightclubSalesEmpty => 'Nog geen verkoopdata';

  @override
  String get nightclubTheftTitle => 'Diefstal Log';

  @override
  String get nightclubTheftEmpty => 'Geen diefstallen geregistreerd';

  @override
  String get nightclubTheftLoss => 'Verlies';

  @override
  String get nightclubStaffTitle => 'Pooierploeg in Club';

  @override
  String get nightclubStaffVipExtraActive => ' (VIP +2 actief)';

  @override
  String nightclubStaffCapacity(String assigned, String cap, String vipSuffix) {
    return 'Capaciteit: $assigned/$cap$vipSuffix';
  }

  @override
  String nightclubStaffBoostMix(
    String sales,
    String price,
    String vibe,
    String security,
    String vipPlayer,
    String vipStaff,
    String vipAssigned,
  ) {
    return 'Boost mix: sales x$sales | prijs x$price | vibe x$vibe | security x$security | vip speler x$vipPlayer | vip dames x$vipStaff ($vipAssigned)';
  }

  @override
  String get nightclubSelectCrewMember => 'Selecteer crewlid';

  @override
  String get nightclubAssignShift => 'Zet in nightclub shift';

  @override
  String get nightclubTabActive => 'Actief';

  @override
  String get nightclubTabHistory => 'Historie';

  @override
  String get nightclubNoCrewAssigned => 'Nog geen crew toegewezen';

  @override
  String get nightclubCrewBoostDescription =>
      'Verhoogt vraag en marge in je club';

  @override
  String get nightclubRemove => 'Verwijder';

  @override
  String get nightclubNoStaffHistory => 'Nog geen staffing historie';

  @override
  String get nightclubFrom => 'Van';

  @override
  String get nightclubTo => 'Tot';

  @override
  String get nightclubRevenueImpact => 'Omzet impact';

  @override
  String get nightclubSalesCountLabel => 'verkopen';

  @override
  String get nightclubDjTitle => 'DJ Inhuren';

  @override
  String get nightclubChooseDj => 'Kies DJ';

  @override
  String get nightclubShiftLength => 'Duur shift';

  @override
  String get nightclubHireDj => 'Huur DJ';

  @override
  String get nightclubSecurityTitle => 'Beveiliging';

  @override
  String get nightclubChooseSecurity => 'Kies beveiliging';

  @override
  String get nightclubHireSecurity => 'Huur beveiliging';

  @override
  String get nightclubStoreTitle => 'Drugs Opslaan';

  @override
  String get nightclubChooseStock => 'Kies voorraad';

  @override
  String get nightclubAmountGrams => 'Aantal gram';

  @override
  String get nightclubStoreButton => 'Opslaan in nightclub';

  @override
  String get nightclubHireDjSuccess => 'DJ ingehuurd';

  @override
  String get nightclubHireSecuritySuccess => 'Beveiliging ingehuurd';

  @override
  String get nightclubAssignCrewSuccess => 'Crewlid toegewezen';

  @override
  String get nightclubRemoveCrewSuccess => 'Crewlid verwijderd';

  @override
  String get nightclubStoreDrugsSuccess => 'Drugs opgeslagen';

  @override
  String get nightclubSeasonPayoutDialogTitle => 'Season-uitbetaling ontvangen';

  @override
  String nightclubSeasonPayoutDialogBody(String rank) {
    return 'Je nightclub eindigde deze week op plek #$rank.';
  }

  @override
  String nightclubSeasonPayoutDialogReward(String amount) {
    return 'Beloning: $amount';
  }

  @override
  String nightclubSeasonPayoutDialogRevenue(String amount) {
    return 'Weekomzet: $amount';
  }

  @override
  String nightclubSeasonPayoutDialogLoss(String amount) {
    return 'Diefstalverlies: $amount';
  }

  @override
  String get nightclubSeasonPayoutDialogAction => 'Sluiten';

  @override
  String get nightclubVibeChill => 'Chill';

  @override
  String get nightclubVibeNormal => 'Normaal';

  @override
  String get nightclubVibeWild => 'Wild';

  @override
  String get nightclubVibeRaging => 'Woedend';

  @override
  String get nightclubTheftTypeCustomer => 'Klantdiefstal';

  @override
  String get nightclubTheftTypeEmployee => 'Medewerker-heist';

  @override
  String get nightclubTheftTypeRival => 'Rivaal-sabotage';

  @override
  String nightclubErrorLoading(String error) {
    return 'Fout bij laden nightclub: $error';
  }

  @override
  String get nightclubServiceErrorStats =>
      'Kon nightclub-statistieken niet laden';

  @override
  String get nightclubServiceErrorLeaderboard => 'Kon leaderboard niet laden';

  @override
  String get nightclubServiceErrorSeason => 'Kon seizoensranking niet laden';

  @override
  String nightclubErrorWithDetail(String detail) {
    return 'Fout: $detail';
  }

  @override
  String get nightclubResidentDjContractFailed =>
      'Resident DJ-contract mislukt';

  @override
  String get nightclubScheduleEventFailed => 'Event plannen mislukt';

  @override
  String get nightclubMarketingUpgradeFailed => 'Marketing-upgrade mislukt';

  @override
  String get nightclubUpgradeFailed => 'Upgrade mislukt';

  @override
  String get nightclubIncidentResponseFailed => 'Incidentrespons mislukt';

  @override
  String get nightclubRivalActionFailed => 'Rivaalactie mislukt';

  @override
  String get nightclubSupplierContractFailed => 'Suppliercontract mislukt';

  @override
  String get nightclubPromoterFailed => 'Promoter mislukt';

  @override
  String get nightclubHeatCooldownFailed => 'Heat-cooldown mislukt';

  @override
  String get nightclubSmugglingFailed => 'Smokkelroute mislukt';

  @override
  String get nightclubCounterIntelFailed => 'Counter-intel mislukt';

  @override
  String get nightclubHospitalityStockFailed => 'Horeca-voorraad mislukt';

  @override
  String get nightclubHospitalityPricingFailed => 'Horeca-prijzen mislukt';

  @override
  String nightclubCurrentVisitorsPct(String pct) {
    return 'Huidige bezoekers: $pct%';
  }

  @override
  String get nightclubCommandDeckTitle => 'Nightclub Command Deck';

  @override
  String get nightclubOpsDeckRevenueToday => 'Omzet vandaag';

  @override
  String get nightclubStockValueLabel => 'Stockwaarde';

  @override
  String get nightclubCrewOccupancy => 'Crew bezetting';

  @override
  String get nightclubOperationalRisk => 'Operationeel risico';

  @override
  String nightclubIncidents24h(String count) {
    return '$count incidenten (24u)';
  }

  @override
  String get nightclubActiveCrewShifts => 'Actieve crew-shifts';

  @override
  String get nightclubRecentCrewHistory => 'Recente crew-historie';

  @override
  String get nightclubBadgeVip => 'VIP';

  @override
  String get nightclubBadgeStandard => 'STANDAARD';

  @override
  String get nightclubActiveDj => 'Actieve DJ';

  @override
  String get nightclubActiveDjNone => 'Actieve DJ: geen';

  @override
  String nightclubUntilTime(String time) {
    return 'tot $time';
  }

  @override
  String get nightclubActiveSecurity => 'Actieve beveiliging';

  @override
  String get nightclubActiveSecurityNone => 'Actieve beveiliging: geen';

  @override
  String get nightclubNoDjsLoaded =>
      'Geen DJ\'s beschikbaar geladen. Ververs het scherm.';

  @override
  String get nightclubNoSecurityLoaded =>
      'Geen beveiliging beschikbaar geladen. Ververs het scherm.';

  @override
  String get nightclubCrowdBoost => 'Crowd boost';

  @override
  String get nightclubCostPerHour => 'Kosten';

  @override
  String get nightclubReputationLabel => 'Reputatie';

  @override
  String get nightclubSpecialtyLabel => 'Specialiteit';

  @override
  String get nightclubTheftReduction => 'Diefstalreductie';

  @override
  String get nightclubShiftCost => 'Shift kosten';

  @override
  String get nightclubSelectedStock => 'Geselecteerd';

  @override
  String get nightclubAvailableGrams => 'Beschikbaar';

  @override
  String get nightclubMaxChip => 'MAX';

  @override
  String get nightclubStoredInNightclub => 'Opgeslagen in nightclub';

  @override
  String nightclubCurrentStockGrams(String grams) {
    return 'Huidige voorraad: ${grams}g';
  }

  @override
  String get nightclubNoStoredDrugs => 'Nog geen opgeslagen drugs.';

  @override
  String get nightclubStockZeroSoldOut =>
      'Voorraad is momenteel 0g (alles is verkocht).';

  @override
  String nightclubQualityWithValue(String value) {
    return 'Kwaliteit: $value';
  }

  @override
  String nightclubGramsStock(String grams) {
    return '${grams}g voorraad';
  }

  @override
  String get nightclubOperationsLabTitle => 'Operations Lab (11 systemen)';

  @override
  String get nightclubSectionResidentDjContract => '1) Resident DJ-contract';

  @override
  String get nightclubContractDiscount => 'Contract korting';

  @override
  String get nightclubContractDuration => 'Contract duur';

  @override
  String nightclubContractDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dagen',
      one: '$count dag',
    );
    return '$_temp0';
  }

  @override
  String get nightclubStartResidentContract => 'Start resident contract';

  @override
  String get nightclubSectionEventCalendar => '2) Dynamic event kalender';

  @override
  String get nightclubRecommendedToday => 'Aanbevolen vandaag';

  @override
  String get nightclubEventTemplate => 'Event template';

  @override
  String get nightclubScheduleEventFiveMin => 'Plan event (+5 min)';

  @override
  String get nightclubUpcomingEvents => 'Komende events';

  @override
  String get nightclubSectionUpgradeTree => '3) Upgrade tree';

  @override
  String get nightclubUpgradeSoundRig => 'Sound rig';

  @override
  String get nightclubUpgradeVipLounge => 'VIP lounge';

  @override
  String get nightclubUpgradeSurveillance => 'Surveillance';

  @override
  String nightclubUpgradeWithCost(String name, String cost) {
    return '$name ($cost)';
  }

  @override
  String get nightclubChooseUpgrade => 'Kies upgrade';

  @override
  String get nightclubUpgradeAlreadyMaxMessage =>
      'Deze upgrade zit al op max level.';

  @override
  String get nightclubUpgradeAlreadyMaxed => 'Upgrade al maximaal';

  @override
  String get nightclubUpgradeNow => 'Upgrade nu';

  @override
  String get nightclubMarketingInvestment => 'Marketing investering';

  @override
  String get nightclubInvestMarketing => 'Investeer in marketing';

  @override
  String get nightclubSectionPoliceHeat => '4) Police heat & incidenten';

  @override
  String get nightclubHeatLabel => 'Heat';

  @override
  String get nightclubRaidRisk => 'Raid risico';

  @override
  String get nightclubCooldownLabel => 'Cooldown';

  @override
  String get nightclubStartHeatCooldown => 'Start heat cooldown';

  @override
  String get nightclubBribe => 'Omkopen';

  @override
  String get nightclubLockdown => 'Lockdown';

  @override
  String get nightclubCounterIntelShort => 'Counter-intel';

  @override
  String get nightclubSectionStaffMorale => '5) Staff fatigue & morale';

  @override
  String get nightclubMorale => 'Morale';

  @override
  String get nightclubFatigue => 'Fatigue';

  @override
  String get nightclubStaffing => 'Bezetting';

  @override
  String get nightclubSectionSupplierPromoter => '6) Supplier & promoter';

  @override
  String get nightclubSupplierContract => 'Supplier contract';

  @override
  String get nightclubActivateSupplier => 'Activeer supplier';

  @override
  String get nightclubPromoterProfile => 'Promoter profiel';

  @override
  String get nightclubHirePromoter => 'Huur promoter';

  @override
  String get nightclubSectionVipClientele => '7) VIP clientele & staff traits';

  @override
  String get nightclubVipShare => 'VIP share';

  @override
  String get nightclubSpendMultiplier => 'Spend x';

  @override
  String get nightclubTier => 'Tier';

  @override
  String get nightclubSectionSmugglingRoutes => '8) Smokkelroutes';

  @override
  String get nightclubReady => 'Klaar';

  @override
  String get nightclubRoute => 'Route';

  @override
  String get nightclubStartRoute => 'Start route';

  @override
  String get nightclubLastRoute => 'Laatste route';

  @override
  String nightclubRouteLockUntil(String date) {
    return 'Route-lock actief tot $date';
  }

  @override
  String get nightclubSectionBarKitchen => '9) Bar & Kitchen management';

  @override
  String get nightclubServiceLevel => 'Service level';

  @override
  String get nightclubStockStatus => 'Stock status';

  @override
  String get nightclubSpoilageRisk => 'Bederfrisico';

  @override
  String get nightclubDrinksFoodStock => 'Drank/Food voorraad';

  @override
  String get nightclubBuyStock => 'Voorraad inkopen';

  @override
  String get nightclubMenuPricingMode => 'Menu pricing mode';

  @override
  String get nightclubApplyPricing => 'Pricing toepassen';

  @override
  String get nightclubSectionRivals => '10) Rival clubs + counter-intel';

  @override
  String get nightclubSearchPlayerName => 'Zoek spelernaam';

  @override
  String get nightclubTargetName => 'Doelwit (naam)';

  @override
  String nightclubRivalCrowdLine(String name, String country, String pct) {
    return '$name • $country • crowd $pct%';
  }

  @override
  String get nightclubSabotage => 'Sabotage';

  @override
  String get nightclubPromoWar => 'Promo war';

  @override
  String get nightclubCounterIntelSweep => 'Counter-intel sweep';

  @override
  String get nightclubMitigation => 'Mitigatie';

  @override
  String get nightclubSectionTimeline => '11) Operations timeline';

  @override
  String get nightclubNoTimelineEvents => 'Geen timeline events.';

  @override
  String get nightclubOperationsAlerts => 'Operations alerts';

  @override
  String get nightclubNoCriticalAlerts => 'Geen kritieke alerts.';

  @override
  String get nightclubQuickAction => 'Quick action';

  @override
  String get nightclubMgmtCrewTitle => 'Crew & diensten';

  @override
  String get nightclubMgmtCrewSubtitle =>
      'Bezetting, prestaties en shift-historie.';

  @override
  String get nightclubMgmtDrugsTitle => 'Drugsopslag';

  @override
  String get nightclubMgmtDrugsSubtitle =>
      'Voorraad in grammen beheren en verplaatsen.';

  @override
  String get nightclubMgmtDjTitle => 'DJ Command';

  @override
  String get nightclubMgmtDjSubtitle =>
      'Kies DJ, shiftduur en live crowd-boost.';

  @override
  String get nightclubMgmtSecurityTitle => 'Security Unit';

  @override
  String get nightclubMgmtSecuritySubtitle =>
      'Diefstalreductie, kosten en actieve beveiliging.';

  @override
  String get nightclubMgmtOpsLabTitle => 'Ops Lab';

  @override
  String nightclubMgmtOpsLabSubtitleAlert(String alerts, String smuggling) {
    return 'Live alerts: $alerts | Smuggling: $smuggling';
  }

  @override
  String get nightclubMgmtOpsLabSubtitleDefault =>
      '11 systemen voor events, upgrades, routes en rivalen.';

  @override
  String get nightclubManagementPanelTitle => 'Nachtclub Beheer';

  @override
  String get nightclubChooseZoneHint =>
      'Kies een managementzone en beheer alles zonder losse inner-scroll.';

  @override
  String get nightclubChipCrew => 'Crew';

  @override
  String get nightclubChipStorage => 'Opslag';

  @override
  String get nightclubChipDjShift => 'DJ shift';

  @override
  String get nightclubChipSecurity => 'Security';

  @override
  String get nightclubChipOpsAlerts => 'Ops alerts';

  @override
  String get nightclubNone => 'Geen';

  @override
  String get nightclubIntelligenceCardTitle => 'Nightclub Intelligence';

  @override
  String get nightclubSeasonStatus => 'Seizoen status';

  @override
  String nightclubSeasonCountdown(String days, String hours, String minutes) {
    return '${days}d ${hours}u ${minutes}m';
  }

  @override
  String nightclubShiftHours(String hours) {
    return '$hours u';
  }

  @override
  String nightclubTimeMinutes(String minutes) {
    return '$minutes min';
  }

  @override
  String nightclubTimeHoursOnly(String hours) {
    return '$hours uur';
  }

  @override
  String nightclubTimeHoursMinutes(String hours, String minutes) {
    return '${hours}u ${minutes}m';
  }

  @override
  String get theftCooldownRedeemTitle => 'Stelen-cooldown overslaan?';

  @override
  String theftCooldownRedeemMessage(int cost, int balance) {
    return 'Weet je zeker dat je $cost credits wilt uitgeven om de voertuigdiefstal-cooldown nu te beëindigen? Je saldo: $balance.';
  }

  @override
  String get theftCooldownRedeemDontShowAgain => 'Dit scherm niet meer tonen';

  @override
  String theftCooldownRedeemConfirmAction(int credits) {
    return 'Gebruik $credits credits';
  }

  @override
  String get theftCooldownRedeemNotAvailable =>
      'Versnellen met credits is nu niet beschikbaar voor deze cooldown.';

  @override
  String get theftCooldownRedeemNoActiveCooldown =>
      'Geen actieve stelen-cooldown om te resetten.';

  @override
  String get theftCooldownRedeemInsufficientCredits => 'Onvoldoende credits.';

  @override
  String get theftCooldownRedeemFailed =>
      'Kon credits niet toepassen op de cooldown.';

  @override
  String get theftCooldownRedeemSuccess => 'Cooldown beëindigd.';

  @override
  String get settingsTheftCooldownConfirmTitle => 'Stelen-cooldown (credits)';

  @override
  String get settingsTheftCooldownConfirmSubtitle =>
      'Vraag bevestiging voordat je credits uitgeeft om de voertuigdiefstal-cooldown over te slaan. Zet uit om in één tik te verzilveren (bliksem naast de timer).';

  @override
  String get supportTicketsScreenTitle => 'Supporttickets';

  @override
  String get supportLoadTicketsFailed => 'Tickets laden mislukt';

  @override
  String get supportLoadTicketFailed => 'Ticket laden mislukt';

  @override
  String get supportPickImageFailed => 'Afbeelding kiezen mislukt';

  @override
  String get supportSubjectMessageMinLength =>
      'Vul onderwerp en bericht in (min. 3 tekens).';

  @override
  String get supportTicketCreated => 'Ticket aangemaakt.';

  @override
  String get supportCreateTicketFailed => 'Ticket aanmaken mislukt';

  @override
  String get supportReplySent => 'Reactie verstuurd.';

  @override
  String get supportReplySendFailed => 'Reactie versturen mislukt';

  @override
  String get supportDeleteTicketTitle => 'Ticket verwijderen';

  @override
  String get supportDeleteTicketBody =>
      'Weet je zeker dat je dit ticket wilt verwijderen? Deze actie kan niet ongedaan worden gemaakt.';

  @override
  String get supportTicketDeleted => 'Ticket verwijderd.';

  @override
  String get supportDeleteTicketFailed => 'Ticket verwijderen mislukt';

  @override
  String get supportUnknownError => 'Onbekende fout';

  @override
  String get supportStatusNew => 'Nieuw';

  @override
  String get supportStatusTriage => 'Triage';

  @override
  String get supportStatusInProgress => 'In behandeling';

  @override
  String get supportStatusWaitingPlayer => 'Wacht op speler';

  @override
  String get supportStatusBlocked => 'Geblokkeerd';

  @override
  String get supportStatusResolved => 'Opgelost';

  @override
  String get supportStatusClosed => 'Gesloten';

  @override
  String get supportStatusArchived => 'Gearchiveerd';

  @override
  String get supportCategoryBug => 'Beestje';

  @override
  String get supportCategoryQuestion => 'Vraag';

  @override
  String get supportCategoryFeedback => 'Feedback';

  @override
  String get supportCategoryOther => 'Overig';

  @override
  String get supportPriorityLow => 'Laag';

  @override
  String get supportPriorityHigh => 'Hoog';

  @override
  String get supportPriorityUrgent => 'Dringend';

  @override
  String get supportPriorityNormal => 'Normaal';

  @override
  String supportTimeDaysAgo(int count) {
    return '${count}d geleden';
  }

  @override
  String supportTimeHoursAgo(int count) {
    return '${count}u geleden';
  }

  @override
  String supportTimeMinutesAgo(int count) {
    return '${count}m geleden';
  }

  @override
  String get supportTimeJustNow => 'zojuist';

  @override
  String get supportSenderSupport => 'Steun';

  @override
  String get supportSenderYou => 'Jij';

  @override
  String get supportImageLoadFailed => 'Afbeelding laden mislukt.';

  @override
  String get supportMyTickets => 'Mijn tickets';

  @override
  String get supportMyTicketsIntro =>
      'Support reageert voortaan rechtstreeks in dit scherm. Je kunt optioneel nog wel een pushmelding krijgen als er een update op je ticket is.';

  @override
  String get supportNoTicketsYet =>
      'Je hebt nog geen tickets. Maak hieronder een nieuwe melding aan.';

  @override
  String get supportSelectTicketPrompt =>
      'Selecteer een ticket om het gesprek te openen.';

  @override
  String get supportConversation => 'Gesprek';

  @override
  String get supportNoMessagesYet => 'Nog geen berichten.';

  @override
  String get supportAttachments => 'Bijlagen';

  @override
  String get supportReplyToTicket => 'Reageer op dit ticket';

  @override
  String get supportReplyFieldHint =>
      'Gebruik dit veld als support meer informatie vraagt of als je een update wilt doorgeven. Inbox en push blijven alleen meldingen van nieuwe supportreacties.';

  @override
  String get supportYourReply => 'Jouw reactie';

  @override
  String get supportSendReply => 'Reactie versturen';

  @override
  String get supportNewTicket => 'Nieuw ticket';

  @override
  String get supportNewTicketIntro =>
      'Maak hier een nieuwe melding aan. Support kan daarna antwoorden via inbox/push en in dit scherm, zodat je het gesprek op 1 plek kunt voortzetten.';

  @override
  String get supportTicketReceivedBanner => 'Ticket ontvangen';

  @override
  String supportTicketNumberLine(int id) {
    return 'Ticketnummer: #$id';
  }

  @override
  String get supportTicketReceivedDetail =>
      'Het ticket staat nu direct bovenin je lijst. Nieuwe supportreacties komen ook als inboxbericht en pushmelding binnen.';

  @override
  String get supportFieldCategory => 'Categorie';

  @override
  String get supportFieldModule => 'Onderdeel';

  @override
  String get supportFieldSubject => 'Onderwerp';

  @override
  String get supportFieldMessage => 'Bericht';

  @override
  String get supportReferenceOptional => 'Referentie (optioneel)';

  @override
  String get supportReferenceHint =>
      'Bijv. order-id, schermnaam, land of korte context';

  @override
  String get supportAddScreenshot => 'Screenshot toevoegen';

  @override
  String get supportSubmit => 'Versturen';

  @override
  String get supportLastMessagePrefix => 'Laatste: ';

  @override
  String get supportReferenceLabel => 'Referentie';

  @override
  String get supportMod_support => 'Algemeen support';

  @override
  String get supportMod_dashboard => 'Dashboard';

  @override
  String get supportMod_messages => 'Berichten / inbox';

  @override
  String get supportMod_notifications => 'Meldingen / push';

  @override
  String get supportMod_payments => 'Betalingen / premium';

  @override
  String get supportMod_bank => 'Bank';

  @override
  String get supportMod_crypto => 'Crypto';

  @override
  String get supportMod_travel => 'Reizen';

  @override
  String get supportMod_properties => 'Eigendommen';

  @override
  String get supportMod_inventory => 'Inventory / opslag';

  @override
  String get supportMod_loadouts => 'Loadouts / uitrusting';

  @override
  String get supportMod_crimes => 'Misdaden';

  @override
  String get supportMod_jobs => 'Werk / banen';

  @override
  String get supportMod_vehicles => 'Auto / motor / boot diefstal';

  @override
  String get supportMod_garage => 'Garage';

  @override
  String get supportMod_marina => 'Jachthaven';

  @override
  String get supportMod_aviation => 'Luchtvaart';

  @override
  String get supportMod_smuggling => 'Smokkelen';

  @override
  String get supportMod_drugs => 'Geneesmiddelen';

  @override
  String get supportMod_nightclub => 'Nachtclub';

  @override
  String get supportMod_prostitution => 'Prostitutie';

  @override
  String get supportMod_crew => 'Bemanning';

  @override
  String get supportMod_friends => 'Vrienden / spelers';

  @override
  String get supportMod_hitlist => 'Hitlijst';

  @override
  String get supportMod_security => 'Beveiliging / FBI';

  @override
  String get supportMod_prison => 'Gevangenis / rechtbank';

  @override
  String get supportMod_casino => 'Casino';

  @override
  String get supportMod_school => 'School/opleiding';

  @override
  String get supportMod_achievements => 'Prestaties';

  @override
  String get supportMod_profile => 'Profiel';

  @override
  String get supportMod_settings => 'Instellingen';

  @override
  String get supportMod_events => 'Evenementen / klassement';

  @override
  String get supportMod_other => 'Overig';

  @override
  String get gameEventDefaultTitle => 'Evenement';

  @override
  String get gameEventStatusActive => 'Actief';

  @override
  String get gameEventStatusScheduled => 'Gepland';

  @override
  String get gameEventStatusCompleted => 'Afgerond';

  @override
  String get gameEventStatusDraft => 'Concept';

  @override
  String get gameEventTmplWeeklyVehicleTheftHuntTitle =>
      'Wekelijkse Diefstaljacht';

  @override
  String get gameEventTmplWeeklyVehicleTheftHuntDesc =>
      'Steel zoveel mogelijk voertuigen tijdens het eventvenster.';

  @override
  String get gameEventTmplSmugglingSurgeTitle => 'Smokkelgolf';

  @override
  String get gameEventTmplSmugglingSurgeDesc =>
      'Beweeg zoveel mogelijk smokkel in deze ronde.';

  @override
  String get gameEventTmplLabOutputChallengeTitle => 'Lab-output Uitdaging';

  @override
  String get gameEventTmplLabOutputChallengeDesc =>
      'Produceer de meeste productie tijdens het event.';

  @override
  String get gameEventTmplStreetCrimeSpreeTitle => 'Straat Crime Spree';

  @override
  String get gameEventTmplStreetCrimeSpreeDesc =>
      'Pleg zoveel mogelijk misdaden in het actieve venster.';

  @override
  String get gameScreenLoadError => 'Events konden niet geladen worden.';

  @override
  String get gameScreenDetailsLoadError =>
      'Eventdetails konden niet geladen worden.';

  @override
  String get gameScreenSectionLive => 'Live events';

  @override
  String get gameScreenNoActive => 'Er zijn nu geen actieve events.';

  @override
  String get gameScreenSectionUpcoming => 'Aankomende events';

  @override
  String get gameScreenNoUpcoming => 'Er zijn geen geplande events.';

  @override
  String gameScreenStatusPrefix(String value) {
    return 'Status: $value';
  }

  @override
  String gameScreenStartLine(String date) {
    return 'Begin: $date';
  }

  @override
  String gameScreenEndLine(String date) {
    return 'Einde: $date';
  }

  @override
  String get gameScreenYourProgress => 'Jouw voortgang';

  @override
  String gameScreenScore(String value) {
    return 'Score: $value';
  }

  @override
  String gameScreenRank(String value) {
    return 'Rang: $value';
  }

  @override
  String get gameScreenLeaderboard => 'Leiderbord (top 10)';

  @override
  String get gameScreenNoLeaderboard => 'Nog geen leaderboard data.';

  @override
  String get gameScreenUnknownPlayer => 'Onbekend';

  @override
  String get gameCardActive => 'Actief';

  @override
  String get gameCardScheduled => 'Gepland';

  @override
  String gameCardYourScore(String value) {
    return 'Jouw score: $value';
  }

  @override
  String gameCardYourRank(String value) {
    return 'Jouw rank: $value';
  }

  @override
  String get gameCardTapDetails => 'Tik voor details en leaderboard';

  @override
  String get eventFeedDisconnected => 'Geen verbinding met de event stream';

  @override
  String get eventFeedReconnecting => 'Opnieuw verbinden...';

  @override
  String get eventFeedConnectedWaiting => 'Verbonden — wachten op events…';

  @override
  String get eventFeedConnecting => 'Verbinden met de event stream…';

  @override
  String get evStreamConnectionEstablished => 'Verbonden met event stream';

  @override
  String get evStreamAuthRegistered => 'Account succesvol aangemaakt.';

  @override
  String get evStreamAuthLogin => 'Welkom terug.';

  @override
  String evStreamCrimeSuccess(
    String crimeName,
    String reward,
    String xpGained,
  ) {
    return 'Succesvol $crimeName gepleegd! +EUR $reward, +$xpGained XP';
  }

  @override
  String evStreamCrimeSuccessJailed(
    String crimeName,
    String reward,
    String xpGained,
    int minutes,
  ) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minuten',
      one: '1 minuut',
    );
    return 'Succesvol $crimeName gepleegd! +EUR $reward, +$xpGained XP — maar gepakt! $_temp0 detentie.';
  }

  @override
  String get evStreamCrimeSeizedVehicle =>
      ' Je voertuig is in beslag genomen door de politie.';

  @override
  String get evStreamCrimeSeizedWeapon =>
      ' Je wapen is in beslag genomen door de politie.';

  @override
  String evStreamCrimeSuccessCleared(
    String crimeName,
    int count,
    String xpGained,
  ) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count veroordelingen',
      one: '1 veroordeling',
    );
    return 'Succesvol $crimeName gepleegd! Strafblad gewist: $_temp0. +$xpGained XP';
  }

  @override
  String evStreamCrimeFailedArrested(String authority, String crimeName) {
    return 'Gearresteerd door $authority tijdens een $crimeName-poging.';
  }

  @override
  String evStreamCrimeFailedJailed(String crimeName, int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minuten',
      one: '1 minuut',
    );
    return 'Gepakt tijdens $crimeName! $_temp0 detentie.';
  }

  @override
  String evStreamCrimeFailedBase(String crimeName) {
    return 'Misdrijf $crimeName mislukt';
  }

  @override
  String evStreamChaseDamage(String pct) {
    return ' Je voertuig kreeg $pct% schade tijdens de achtervolging.';
  }

  @override
  String evStreamCrimeJailed(String crimeName, int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minuten',
      one: '1 minuut',
    );
    return 'Gepakt tijdens $crimeName! $_temp0 detentie.';
  }

  @override
  String evStreamJobSuccess(String jobName, String earnings, String xpGained) {
    return 'Werk als $jobName voltooid! +€$earnings, +$xpGained XP';
  }

  @override
  String evStreamJobSuccessEdu(String pct) {
    return ' (Opleidingsbonus +$pct%)';
  }

  @override
  String evStreamJobFailedXp(String jobName, String xpLost) {
    return 'Werk als $jobName mislukt. −$xpLost XP';
  }

  @override
  String evStreamJobFailed(String jobName) {
    return 'Werk als $jobName mislukt';
  }

  @override
  String get evStreamJobErrorInvalid => 'Ongeldig werk';

  @override
  String get evStreamJobErrorLevel => 'Je rank is te laag voor dit werk';

  @override
  String evStreamJobErrorCooldown(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'nog $minutes minuten',
      one: 'nog 1 minuut',
    );
    return 'Dit werk heeft cooldown. Wacht $_temp0';
  }

  @override
  String evStreamJobErrorGeneric(String reason) {
    return 'Werkfout: $reason';
  }

  @override
  String evStreamTravelDeparted(String dest, String cost) {
    return 'Vliegt naar $dest… −€$cost';
  }

  @override
  String evStreamTravelArrived(String country) {
    return 'Aangekomen in $country.';
  }

  @override
  String evStreamBankDeposit(String amount) {
    return '€$amount gestort op de bankrekening';
  }

  @override
  String evStreamBankWithdraw(String amount) {
    return '€$amount opgenomen van de bankrekening';
  }

  @override
  String evStreamCryptoBuy(String quantity, String symbol, String total) {
    return 'Kocht $quantity $symbol voor €$total';
  }

  @override
  String evStreamCryptoSell(
    String quantity,
    String symbol,
    String total,
    String pnl,
  ) {
    return 'Verkocht $quantity $symbol voor €$total (resultaat €$pnl)';
  }

  @override
  String evStreamCryptoAlert(String symbol, String price, String chg) {
    return '$symbol alert: €$price ($chg% 24u)';
  }

  @override
  String evStreamCryptoOrderFilled(
    String order,
    String side,
    String quantity,
    String symbol,
    String price,
  ) {
    return '$order $side uitgevoerd: $quantity $symbol op €$price';
  }

  @override
  String evStreamCryptoOrderTriggered(
    String trig,
    String symbol,
    String price,
  ) {
    return '$trig geactiveerd voor $symbol op €$price';
  }

  @override
  String evStreamCryptoRegime(String regime, String move) {
    return 'Marktregime: $regime ($move% 24u)';
  }

  @override
  String evStreamCryptoNews(String sentiment, String headline) {
    return '$sentiment nieuws: $headline';
  }

  @override
  String evStreamCryptoMissionDaily(String title, String reward) {
    return 'Dagmissie voltooid: $title (+EUR $reward)';
  }

  @override
  String evStreamCryptoMissionWeekly(String title, String reward) {
    return 'Weekmissie voltooid: $title (+EUR $reward)';
  }

  @override
  String evStreamCryptoLeaderboard(String rank, String reward) {
    return 'Crypto leaderboard-beloning: #$rank (+EUR $reward)';
  }

  @override
  String get evStreamRegimeBull => 'stijgend';

  @override
  String get evStreamRegimeBear => 'dalend';

  @override
  String get evStreamRegimeSideways => 'zijwaarts';

  @override
  String get evStreamImpactBull => 'Positief';

  @override
  String get evStreamImpactBear => 'Negatief';

  @override
  String get evStreamImpactNeutral => 'Neutraal';

  @override
  String evStreamPropertyBought(String name, String cost) {
    return '$name gekocht voor €$cost';
  }

  @override
  String evStreamCrewCreated(String name) {
    return 'Crew aangemaakt: $name';
  }

  @override
  String evStreamCrewJoined(String name) {
    return 'Bij crew gegaan: $name';
  }

  @override
  String evStreamCrewWarDeclared(String a, String b, String type) {
    return 'Crew-oorlog verklaard: #$a vs #$b ($type)';
  }

  @override
  String evStreamCrewWarStarted(String a, String b) {
    return 'Crew-oorlog gestart: #$a vs #$b';
  }

  @override
  String evStreamCrewLockdown(String id) {
    return 'Crew-oorlog #$id zit in lockdown';
  }

  @override
  String evStreamCrewResolved(String id, String winner) {
    return 'Crew-oorlog #$id afgerond. Winnaar: crew #$winner';
  }

  @override
  String evStreamCrewAction(String action, String points) {
    return 'Crew-oorlog actie: $action (+$points ptn)';
  }

  @override
  String evStreamHeistOk(String name, String money) {
    return 'Overval “$name” geslaagd! +€$money';
  }

  @override
  String evStreamHeistFail(String name) {
    return 'Overval “$name” mislukt.';
  }

  @override
  String evStreamHospital(String hp, String cost) {
    return 'Genezen in ziekenhuis! +$hp gezondheid, −€$cost';
  }

  @override
  String evStreamPoliceArrested(String mins) {
    return 'Gearresteerd! $mins minuten cel';
  }

  @override
  String get evStreamPoliceEscaped => 'Je bent ontsnapt aan de politie.';

  @override
  String get evStreamFbiRaid => 'FBI-inval! Je verloor bezit en geld.';

  @override
  String get evStreamErrInsufficientFunds => 'Onvoldoende geld';

  @override
  String get evStreamErrInsufficientHealth =>
      'Onvoldoende gezondheid voor deze actie';

  @override
  String evStreamErrInsufficientRank(String rank) {
    return 'Vereist rank $rank';
  }

  @override
  String evStreamErrJailed(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minuten',
      one: '1 minuut',
    );
    return 'Je zit nog $_temp0 in de cel';
  }

  @override
  String get evStreamErrNoHealthDefault =>
      'Je moet rusten en gezondheid herstellen';

  @override
  String evStreamErrCooldown(int seconds) {
    String _temp0 = intl.Intl.pluralLogic(
      seconds,
      locale: localeName,
      other: '$seconds seconden',
      one: '1 seconde',
    );
    return 'Wacht $_temp0 voordat je opnieuw probeert';
  }

  @override
  String get evStreamErrRescuerJailed =>
      'Je kunt anderen niet bevrijden in de cel';

  @override
  String get evStreamErrTargetNotJailed => 'Deze speler zit niet in de cel';

  @override
  String get evStreamErrCannotRescueSelf => 'Je kunt jezelf niet bevrijden';

  @override
  String get evStreamJailbreakOk => 'Uitbraak geslaagd! De speler is vrij.';

  @override
  String get evStreamJailbreakFail =>
      'Uitbraak mislukt! De speler zit nog in de cel.';

  @override
  String evStreamJailbreakCaught(String mins) {
    return 'Uitbraak mislukt! Je bent gepakt: $mins minuten cel.';
  }

  @override
  String evStreamBailPaid(String amount) {
    return 'Borg betaald: €$amount. Je bent vrij.';
  }

  @override
  String get evStreamErrInternal => 'Er ging iets mis. Probeer opnieuw.';

  @override
  String evStreamTest(String msg) {
    return 'Test: $msg';
  }

  @override
  String get evStreamNoCriminalRecord => 'Je hebt geen strafblad om te wissen';

  @override
  String get evStreamWeaponSelectRequired => 'Kies eerst een misdaad-wapen';

  @override
  String evStreamWeaponNotSuitable(String types) {
    return 'Je hebt een geschikt wapen nodig: $types';
  }

  @override
  String get evStreamJobFallbackName => 'werk';

  @override
  String evStreamUnknownKey(String key) {
    return '$key';
  }

  @override
  String get connectionErrorGeneric => 'Verbindingsfout';

  @override
  String get crimeWeaponSectionTitle => 'Crime-wapen';

  @override
  String get crimeWeaponInstruction =>
      'Kies hier welk gedragen wapen je standaard gebruikt voor crimes die een wapen vereisen.';

  @override
  String get crimeWeaponEmptyInventoryHelp =>
      'Koop of verplaats eerst een bruikbaar wapen naar je carried inventory.';

  @override
  String get crimeWeaponSelectHint => 'Selecteer een wapen voor crimes';

  @override
  String get crimeWeaponNoSelectionNote =>
      'Zonder selectie starten gewapende crimes niet.';

  @override
  String crimeWeaponSelectedStatus(String weaponLine) {
    return 'Geselecteerd: $weaponLine. Sommige crimes eisen daarnaast nog een passend wapentype.';
  }

  @override
  String get crimeSetWeaponFailed => 'Instellen van crime-wapen mislukt.';

  @override
  String get crimeChooseWeaponBeforeCommit =>
      'Kies eerst een crime-wapen bovenaan dit scherm of via Inventaris.';

  @override
  String get crimeWeaponFooterNote =>
      'Gewapende crimes gebruiken het geselecteerde crime-wapen hierboven.';

  @override
  String get crimeCriminalRecordWipeDesc =>
      'Verval dossiers en wis je volledige strafblad als de operatie slaagt.';

  @override
  String crimeCardSuccessChance(int percent) {
    return '$percent% kans';
  }

  @override
  String get cooldownTimeLeft => 'Resterende tijd';

  @override
  String get cooldownMustWaitExplanation =>
      'Je moet wachten voordat je deze actie opnieuw kunt uitvoeren.';

  @override
  String get cooldownAlreadyFinished => 'Cooldown is al klaar.';

  @override
  String get cooldownNotEnoughCredits => 'Onvoldoende credits.';

  @override
  String get cooldownNoActiveToReset => 'Geen actieve cooldown om te resetten.';

  @override
  String get cooldownNotAvailableNow => 'Nu niet beschikbaar.';

  @override
  String get cooldownRedeemFailed => 'Versnellen met credits mislukt.';

  @override
  String get cooldownFinishedInstantly => 'Cooldown direct afgerond.';

  @override
  String cooldownSpeedUpNow(int cost) {
    return 'Versnel nu (-$cost credits)';
  }

  @override
  String cooldownCreditBalanceLine(int balance) {
    return 'Saldo: $balance credits';
  }

  @override
  String get cooldownLoadingCreditOptions => 'Credits-opties laden...';

  @override
  String get cooldownWaitCrime => 'De heat is te hoog...';

  @override
  String get cooldownWaitJob => 'Neemt rust voordat je weer kan werken';

  @override
  String get cooldownWaitTravel => 'Volgende vlucht vertrekt over';

  @override
  String get cooldownWaitHeist => 'Plan wordt voorbereid...';

  @override
  String get cooldownWaitAppeal => 'Rechtbank is bezet...';

  @override
  String get cooldownWaitSchool => 'Haal even adem voor de volgende les…';

  @override
  String get cooldownWaitDefault => 'Even geduld...';

  @override
  String get weaponLabelKnife => 'Mes';

  @override
  String get weaponLabelHandgun9mm => 'Pistool (9mm)';

  @override
  String get weaponLabelHandgunHeavy => 'Zwaar Pistool (.45)';

  @override
  String get weaponLabelSmgCompact => 'Compacte SMG';

  @override
  String get weaponLabelShotgunPump => 'Shotgun (Pump)';

  @override
  String get weaponLabelMolotov => 'Molotovcocktail';

  @override
  String get weaponLabelSmgSuppressed => 'SMG (Suppressor)';

  @override
  String get weaponLabelShotgunTactical => 'Tactische Shotgun';

  @override
  String get weaponLabelAssaultRifle => 'Aanvalsgeweer (AK-47)';

  @override
  String get weaponLabelGrenadeFlash => 'Flashbang';

  @override
  String get weaponLabelGrenadeFrag => 'Fragmentatiegranaat';

  @override
  String get weaponLabelSniperStandard => 'Sluipschuttersgeweer';

  @override
  String get weaponLabelAssaultRifleVip => 'Aanvalsgeweer Elite';

  @override
  String get weaponLabelSniperVip => 'Sluipschutter Elite';

  @override
  String get cooldownTitleCrime => 'Misdaad cooldown';

  @override
  String get cooldownTitleJob => 'Werk cooldown';

  @override
  String get cooldownTitleTravel => 'Reizen cooldown';

  @override
  String get cooldownTitleHeist => 'Overval cooldown';

  @override
  String get cooldownTitleAppeal => 'Hoger beroep cooldown';

  @override
  String get cooldownTitleSchool => 'Opleiding cooldown';

  @override
  String get cooldownTitleGeneric => 'Afkoelen';

  @override
  String get crimeOutcomeDefaultTitle => 'Crime-resultaat';

  @override
  String get territoryContestStatusPreparing => 'Voorbereiding';

  @override
  String get territoryContestStatusActive => 'Actief';

  @override
  String get territoryContestStatusLockdown => 'Lockdown';

  @override
  String get territoryContestStatusResolved => 'Afgerond';

  @override
  String get territoryContestStatusCancelled => 'Geannuleerd';

  @override
  String get territoryContestHintPreparing =>
      'De contest loopt nu in voorbereiding. Zodra de prep-tijd voorbij is, wordt dit gebied automatisch actief en kun je acties uitvoeren.';

  @override
  String get territoryContestHintLockdown =>
      'Deze contest zit in lockdown. Er kunnen nu geen nieuwe acties meer worden gedaan; de uitkomst volgt automatisch.';

  @override
  String get territoryNow => 'Nu';

  @override
  String get territoryRoleAttacker => 'Aanvaller';

  @override
  String get territoryRoleDefender => 'Verdediger';

  @override
  String get territoryValueLow => 'Laag';

  @override
  String get territoryValueAverage => 'Gemiddeld';

  @override
  String get territoryValueHigh => 'Hoog';

  @override
  String get territoryValueTop => 'Bovenkant';

  @override
  String get territoryTagCapital => 'Bestuurlijk centrum';

  @override
  String get territoryTagHarbor => 'Haven';

  @override
  String get territoryTagIndustry => 'Industrie';

  @override
  String get territoryTagBorder => 'Grensregio';

  @override
  String get territoryTagLogistics => 'Logistiek knooppunt';

  @override
  String get territoryActionPatrol => 'Patrouille';

  @override
  String get territoryActionIntelScan => 'Intel-scan';

  @override
  String get territoryActionSabotage => 'Sabotage';

  @override
  String get territoryActionSupplyRun => 'Bevoorrading';

  @override
  String get territoryActionRaid => 'Inval';

  @override
  String get territoryActionDefense => 'Verdedigen';

  @override
  String get territoryBonusStrategicRegion => 'Strategische regio';

  @override
  String get territoryBonusAdjacentSupport => 'Aangrenzende steun';

  @override
  String get territoryBonusWarPressure => 'Oorlogsdruk';

  @override
  String get territoryBonusHqLevel => 'HQ-niveau';

  @override
  String get territoryBonusCrewMissionLevel => 'Crew missielevel';

  @override
  String get territoryBonusCrewBuildings => 'Crew bijgebouwen';

  @override
  String get territoryBonusOther => 'Overig';

  @override
  String territoryPointsLogicLine(
    int basePoints,
    int bonusPoints,
    int totalPoints,
  ) {
    return 'basis $basePoints + bonus $bonusPoints = $totalPoints contestpunten';
  }

  @override
  String get territoryErrorNotInCrew =>
      'Je moet eerst in een crew zitten om territorium aan te vallen.';

  @override
  String get territoryErrorContestAlreadyActive =>
      'Voor dit gebied loopt al een contest. De kaart wordt ververst met de actuele status.';

  @override
  String get territoryErrorCrewContestLimit =>
      'Je crew heeft al het maximum aantal gelijktijdige contests bereikt.';

  @override
  String get territoryErrorRegionsCap =>
      'Je crew bezit al het maximum aantal gebieden.';

  @override
  String get territoryErrorContestNotActive =>
      'Deze contest is nog niet actief. Wacht tot de voorbereidingsfase voorbij is.';

  @override
  String get territoryErrorActionCooldown =>
      'Je moet even wachten voor je opnieuw een territory-actie kunt doen.';

  @override
  String get territoryErrorActionRoleMismatch =>
      'Deze actie hoort bij de andere kant van de contest.';

  @override
  String get territoryErrorHqLevelRequired =>
      'Je HQ-level is nog te laag voor deze territory-actie.';

  @override
  String get territoryErrorDailyCap =>
      'Je hebt je dagelijkse limiet voor territory-acties bereikt.';

  @override
  String get territoryErrorWrongCountry =>
      'Je kunt alle landen bekijken, maar territory-acties werken alleen in het land waar je nu bent.';

  @override
  String get territoryErrorUnknown => 'Onbekende territory-fout.';

  @override
  String get territoryLegendUnderContest => 'In strijd';

  @override
  String get territoryLegendNeutral => 'Neutraal';

  @override
  String get territoryTabMap => 'Kaart';

  @override
  String get territoryTabLeaderboard => 'Ranglijst';

  @override
  String get territoryTabSeason => 'Seizoen';

  @override
  String get territorySelectCountryTooltip => 'Kies land';

  @override
  String get territoryUnavailableMessage =>
      'Territorium is momenteel niet beschikbaar.';

  @override
  String get territoryMapHintTapMain =>
      'Tik op een gebied op de kaart om gebiedsinformatie en de aanvalsknop in een modal te openen.';

  @override
  String get territoryMapHintTapPanel =>
      'Klik op een gebied om direct de modal met gebiedsinformatie en aanvalsacties te openen.';

  @override
  String get territoryMapHintMobile =>
      'Op mobiel kun je met twee vingers in- en uitzoomen en de ingezoomde kaart direct verslepen voor kleine gebieden.';

  @override
  String get territoryMapHintColors =>
      'Regio-kleuren tonen eigendom; oranje = actieve contest.';

  @override
  String territoryMapOverviewTitle(String country) {
    return '$country kaart (crew controle)';
  }

  @override
  String get territoryLegendTitle => 'Legenda';

  @override
  String territoryYourCrewLine(String name) {
    return 'Jouw crew: $name';
  }

  @override
  String get territoryDetailRegionPreviewTitle => 'Gebiedsweergave';

  @override
  String get territoryDetailRegionPreviewSubtitle =>
      'Alleen het aangeklikte gebied, zonder de rest van de kaart.';

  @override
  String get territoryNeutralTerritory => 'Neutraal gebied';

  @override
  String get territoryDetailOwner => 'Eigenaar';

  @override
  String get territoryDetailNeutral => 'Neutraal';

  @override
  String get territoryDetailStability => 'Stabiliteit';

  @override
  String get territoryDetailEffectiveStability => 'Effectieve stabiliteit';

  @override
  String get territoryDetailControl => 'Controle';

  @override
  String get territoryDetailValueTier => 'Waarde';

  @override
  String get territoryDetailPayout => 'Uitbetaling';

  @override
  String get territoryDetailStrategicRole => 'Strategische rol';

  @override
  String get territoryDetailAdjacentOwned => 'Aangrenzende eigen regio\'s';

  @override
  String get territoryDetailActionBonuses => 'Actiebonussen';

  @override
  String get territoryDetailBonusInfo => 'Bonus uitleg';

  @override
  String get territoryDetailBonusInfoBody =>
      'Deze bonussen verhogen alleen je contestpunten per actie. De €-uitbetaling van het gebied blijft gelijk.';

  @override
  String get territoryDetailWarPressure => 'Oorlogsdruk';

  @override
  String get territoryDetailAttackPressure => 'aanvalsdruk';

  @override
  String get territoryDetailStabilityWord => 'stabiliteit';

  @override
  String get territoryWarRoleTheater => 'theater-regio';

  @override
  String get territoryWarRoleAdjacent => 'aangrenzende regio';

  @override
  String get territoryWarRoleTarget => 'doelregio';

  @override
  String get territoryWarPressureEndsIn => 'War pressure eindigt over';

  @override
  String get territoryDetailIncomeHour => 'Opbrengst per uur';

  @override
  String get territoryDetailIncomeDay => 'Opbrengst per dag';

  @override
  String get territoryDetailYourCrew => 'Jouw crew';

  @override
  String get territoryDetailContestStatus => 'Wedstrijdstatus';

  @override
  String get territoryDetailYourRole => 'Jouw rol';

  @override
  String get territoryDetailYourHqLevel => 'Jouw HQ level';

  @override
  String get territoryDetailActionsUnlockIn => 'Acties starten over';

  @override
  String get territoryDetailActionsCloseIn => 'Acties sluiten over';

  @override
  String get territoryDetailContestEndsIn => 'Contest eindigt over';

  @override
  String get territoryDetailCooldownPerAction => 'Cooldown per actie';

  @override
  String get territoryDetailYourCooldown => 'Jouw cooldown';

  @override
  String get territoryNoticeCrewOnly =>
      'Territorium is alleen speelbaar voor crewleden. Maak eerst een crew aan of sluit je bij een crew aan, daarna kun je neutrale gebieden aanvallen.';

  @override
  String territoryNoticeWrongCountry(
    String viewingCountry,
    String playerCountry,
  ) {
    return 'Je bekijkt $viewingCountry, maar je bent nu in $playerCountry. Je kunt deze kaart wel bekijken, alleen aanvallen en contest-acties zijn pas beschikbaar zodra je naar dit land reist.';
  }

  @override
  String get territoryNoticeOwnRegion => 'Je crew controleert dit gebied al.';

  @override
  String get territoryNoticeDefenderPrep =>
      'Jouw crew verdedigt dit gebied. Zodra de actieve fase start, krijg je alleen verdedigende acties te zien.';

  @override
  String get territoryConfirmDefense => 'Verdediging bevestigen';

  @override
  String get territoryAttack => 'Aanvallen';

  @override
  String get territoryAttackerActions => 'Aanvalsacties';

  @override
  String get territoryDefenderActions => 'Verdedigingsacties';

  @override
  String get territoryContestActions => 'Contestacties';

  @override
  String get territoryIntelShort => 'Intel';

  @override
  String get territoryRequiresHqShort => 'vereist HQ';

  @override
  String territoryHqLockedNotice(String actions) {
    return 'Vereist hoger HQ-level voor: $actions.';
  }

  @override
  String get territoryNotInContestNotice =>
      'Je zit niet aan deze contest gekoppeld, dus je kunt hier geen acties uitvoeren.';

  @override
  String territoryContestOtherCountryNotice(String country) {
    return 'Deze contest loopt in een ander land. Je kunt hem volgen, maar pas meedoen zodra je fysiek in $country bent.';
  }

  @override
  String get territoryLeaderboardEmpty => 'Nog geen territorium gecontroleerd.';

  @override
  String territoryLeaderboardRegionsCount(int count) {
    return '$count regio\'s';
  }

  @override
  String get territorySeasonNone => 'Geen actief seizoen gevonden.';

  @override
  String get territorySeasonCurrent => 'Huidig seizoen';

  @override
  String get territorySeasonKey => 'Sleutel';

  @override
  String get territorySeasonStatus => 'Status';

  @override
  String get territorySeasonStart => 'Begin';

  @override
  String get territorySeasonEnd => 'Einde';

  @override
  String get territoryDialogAttackTitle => 'Aanvallen?';

  @override
  String territoryDialogAttackBody(String regionKey) {
    return 'Wil je een contest starten voor $regionKey?';
  }

  @override
  String get territorySnackJoinCrewFirst =>
      'Sluit je eerst aan bij een crew om territorium aan te vallen.';

  @override
  String territorySnackContestStarted(String status) {
    return 'Contest gestart. Status: $status. Wacht tot de voorbereidingsfase voorbij is voor acties.';
  }

  @override
  String territorySnackContestAlreadyLive(String status) {
    return 'De contest is al gestart en de kaart is ververst. Status: $status.';
  }

  @override
  String territoryPointsDelta(String points) {
    return '+$points punten!';
  }

  @override
  String get territorySnackDefenseConfirmed =>
      'Verdediging bevestigd. Zodra de actieve fase start, kun je verdedigingsacties uitvoeren.';

  @override
  String get territorySnackContestRefreshed =>
      'De conteststatus is ververst. Je ziet nu direct de actuele verdedigingsfase.';

  @override
  String territoryHqTooltipLocked(int required, int current) {
    return 'Vereist HQ level $required. Huidig HQ level: $current.';
  }

  @override
  String territoryHqButtonLocked(String label, int level) {
    return '$label (vereist HQ $level)';
  }

  @override
  String get smugglingHubTitle => 'Smokkel Hub';

  @override
  String get smugglingHubSubtitle =>
      'Eén systeem voor drugs, handelswaar, voertuigen, wapens en munitie. Reis leeg en claim veilig uit depot.';

  @override
  String get smugglingClaimPersonal => 'Claim persoonlijk';

  @override
  String get smugglingClaimCrew => 'Claim crew';

  @override
  String get smugglingNewShipment => 'Nieuwe zending';

  @override
  String get smugglingCategoryDrug => 'Drugs';

  @override
  String get smugglingCategoryTrade => 'Handelswaar';

  @override
  String get smugglingCategoryVehicle => 'Voertuigen';

  @override
  String get smugglingCategoryWeapon => 'Wapens';

  @override
  String get smugglingCategoryAmmo => 'Munitie';

  @override
  String get smugglingNoItemsInCategory =>
      'Geen beschikbare items in deze categorie.';

  @override
  String get smugglingFieldItem => 'Item';

  @override
  String get smugglingFieldDestination => 'Bestemming';

  @override
  String get smugglingTransport => 'Transport';

  @override
  String get smugglingCommercialChannel => 'Commercieel kanaal';

  @override
  String get smugglingOwnedVehicleAircraft => 'Eigen voertuig / vliegtuig';

  @override
  String get smugglingNoOwnedTransportInCountry =>
      'Je hebt in dit land geen eigen voertuig of vliegtuig beschikbaar voor smokkel.';

  @override
  String get smugglingOwnedTransportFieldLabel => 'Eigen transport';

  @override
  String smugglingOwnedTransportCapacityLine(int slots, String percent) {
    return 'Capaciteit: $slots slots • Inbeslagname bij mislukking: $percent%';
  }

  @override
  String smugglingOwnedTransportDropdownRow(
    String label,
    int slots,
    String riskReduction,
  ) {
    return '$label • $slots slots • -$riskReduction%';
  }

  @override
  String get smugglingNetwork => 'Netwerk';

  @override
  String get smugglingPersonal => 'Persoonlijk';

  @override
  String get smugglingCrew => 'Crew';

  @override
  String get smugglingChannelField => 'Smokkelkanaal';

  @override
  String get smugglingQuantity => 'Hoeveelheid';

  @override
  String get smugglingVehiclesOneByOne => 'Voertuigen gaan per stuk';

  @override
  String smugglingMaxQuantity(int max) {
    return 'Max: $max';
  }

  @override
  String get smugglingStartSmuggling => 'Start smokkel';

  @override
  String get smugglingSelectItemDestination => 'Selecteer item en bestemming';

  @override
  String get smugglingCrewTradeNotAvailable =>
      'Crew-smokkel voor handelswaar is nog niet beschikbaar';

  @override
  String get smugglingSelectOwnedTransportFirst =>
      'Kies eerst een eigen voertuig of vliegtuig';

  @override
  String get smugglingInvalidQuantity => 'Ongeldige hoeveelheid';

  @override
  String get smugglingActionProcessed => 'Actie verwerkt';

  @override
  String smugglingQuoteSummaryLine(String fee, int etaMinutes, String risk) {
    return '€$fee • $etaMinutes min • $risk% risico';
  }

  @override
  String smugglingSeizureRiskPercent(String percent) {
    return '$percent% risico';
  }

  @override
  String get smugglingQuotePrompt =>
      'Selecteer item en bestemming voor een live quote.';

  @override
  String get smugglingQuoteLiveTitle => 'Live quote';

  @override
  String smugglingOwnedTransportCaption(String label) {
    return 'Eigen transport: $label';
  }

  @override
  String smugglingCargoSlotsLine(int required, int available) {
    return 'Cargo-slots: $required / $available';
  }

  @override
  String smugglingCooldownActive(String duration) {
    return 'Cooldown actief: $duration';
  }

  @override
  String smugglingRecommendedChannel(String channel) {
    return 'Aanbevolen kanaal: $channel';
  }

  @override
  String get smugglingInsufficientCash => 'Onvoldoende cash voor deze zending';

  @override
  String get smugglingDepotsTitle => 'Depots per land';

  @override
  String get smugglingDepotsEmpty => 'Geen pakketten klaar in depots.';

  @override
  String smugglingDepotLine(int packages, int totalQuantity) {
    return '$packages pakketten • $totalQuantity eenheden';
  }

  @override
  String get smugglingClaimHere => 'Hier ophalen';

  @override
  String get smugglingStatusTitle => 'Smokkelstatus';

  @override
  String get smugglingNoShipmentsYet => 'Nog geen zendingen.';

  @override
  String get smugglingStatusInTransit => 'Onderweg';

  @override
  String get smugglingStatusReady => 'Klaar';

  @override
  String get smugglingStatusSeized => 'In beslag';

  @override
  String get smugglingStatusClaimed => 'Opgehaald';

  @override
  String get smugglingStatusUnknown => 'Onbekend';

  @override
  String get smugglingChannelPackage => 'Pakket';

  @override
  String get smugglingChannelCourier => 'Koerier';

  @override
  String get smugglingChannelContainer => 'Container';

  @override
  String get smugglingChannelOwned => 'Eigen transport';

  @override
  String get smugglingHintOwnedTransport =>
      'Eigen transport verlaagt de kosten en het risico, maar kan bij mislukking in beslag genomen worden.';

  @override
  String get smugglingHintVehiclesChannel =>
      'Tip: voertuigen werken het best met Koerier of Container.';

  @override
  String get smugglingHintWeaponsChannel =>
      'Tip: grote wapenladingen beter via Container.';

  @override
  String get smugglingHintAmmoChannel =>
      'Tip: veel munitie via Container voor lager risico.';

  @override
  String get smugglingHintDrugsChannel =>
      'Tip: kleine batches via Pakket, bulk via Container.';

  @override
  String get smugglingHintCompareChannels =>
      'Tip: test kanaalkeuze met live quote.';

  @override
  String get smugglingQuoteBoatCannotFit =>
      'Een boot past niet in een vliegtuig.';

  @override
  String get smugglingQuoteCargoOverflow =>
      'De cargo-capaciteit van je eigen transport is te klein.';

  @override
  String get smugglingQuoteUnavailable => 'Quote niet beschikbaar';

  @override
  String get smugglingApiInvalidChannel => 'Ongeldig smokkelkanaal';

  @override
  String get smugglingApiInvalidNetwork => 'Ongeldige netwerkkeuze';

  @override
  String get smugglingApiInvalidQuantity => 'Ongeldige hoeveelheid';

  @override
  String get smugglingApiInvalidDestination => 'Bestemmingsland bestaat niet';

  @override
  String get smugglingApiPlayerNotFound => 'Speler niet gevonden';

  @override
  String get smugglingApiSameCountryInventory =>
      'Gebruik lokale inventory voor hetzelfde land';

  @override
  String get smugglingApiNotInCrew => 'Je zit niet in een crew';

  @override
  String get smugglingApiCrewTradeUnavailable =>
      'Crew-smokkel voor handelswaar is nog niet beschikbaar';

  @override
  String get smugglingApiOwnedVehiclesPersonalOnly =>
      'Eigen voertuigen werken alleen voor persoonlijke smokkel';

  @override
  String get smugglingApiChooseOwnedTransport =>
      'Kies een eigen voertuig of vliegtuig';

  @override
  String get smugglingApiChosenOwnedTransportUnavailable =>
      'Gekozen eigen voertuig is niet beschikbaar';

  @override
  String get smugglingApiSameVehicleCargoConflict =>
      'Je kunt hetzelfde voertuig niet als vracht en transport gebruiken';

  @override
  String get smugglingApiCarCannotCarryOtherVehicle =>
      'Auto of motor kan geen ander voertuig vervoeren';

  @override
  String get smugglingApiVehiclesCannotUsePackageChannel =>
      'Voertuigen kunnen niet via pakketkanaal';

  @override
  String get smugglingApiBoatCannotFit =>
      'Een boot past niet in een vliegtuig.';

  @override
  String get smugglingApiCargoOverflow =>
      'De cargo-capaciteit van je eigen transport is te klein.';

  @override
  String smugglingApiCooldownWait(int seconds, String channel) {
    return 'Wacht ${seconds}s voor een nieuwe $channel-zending';
  }

  @override
  String get smugglingApiInsufficientMoney =>
      'Niet genoeg geld voor smokkelkosten';

  @override
  String get smugglingApiInsufficientDrugsCrew =>
      'Niet genoeg drugs in crew inventory';

  @override
  String get smugglingApiInsufficientDrugs => 'Niet genoeg drugs in inventory';

  @override
  String get smugglingApiInsufficientTradeGoods =>
      'Niet genoeg handelswaar in inventory';

  @override
  String get smugglingApiInsufficientWeaponsCrew =>
      'Niet genoeg wapens in crew inventory';

  @override
  String get smugglingApiInsufficientWeapons =>
      'Niet genoeg wapens in inventory';

  @override
  String get smugglingApiInsufficientAmmoCrew =>
      'Niet genoeg munitie in crew inventory';

  @override
  String get smugglingApiInsufficientAmmo => 'Niet genoeg munitie in inventory';

  @override
  String get smugglingApiInvalidCrewVehicle => 'Ongeldig crew-voertuig';

  @override
  String get smugglingApiCrewBoatUnavailable =>
      'Crew-boot niet beschikbaar voor smokkel';

  @override
  String get smugglingApiCrewMotorcycleUnavailable =>
      'Crew-motor niet beschikbaar voor smokkel';

  @override
  String get smugglingApiCrewCarUnavailable =>
      'Crew-auto niet beschikbaar voor smokkel';

  @override
  String get smugglingApiInvalidVehicleKey => 'Ongeldig voertuig';

  @override
  String get smugglingApiVehicleUnavailableForSmuggling =>
      'Voertuig niet beschikbaar voor smokkel';

  @override
  String get smugglingApiInsufficientStockForShipment =>
      'Onvoldoende voorraad voor deze zending';

  @override
  String get smugglingApiDepotNoShipmentsReady =>
      'Geen zendingen klaar in dit landdepot';

  @override
  String smugglingApiQuantityTooHighForChannel(String channel, int max) {
    return 'Hoeveelheid te hoog voor $channel. Max: $max';
  }

  @override
  String smugglingApiShipmentStarted(String channel, String destination) {
    return 'Smokkelzending ($channel) naar $destination gestart';
  }

  @override
  String smugglingApiClaimedPersonal(int count, String country) {
    return '$count zending(en) opgehaald in $country';
  }

  @override
  String smugglingApiClaimedCrew(int count, String country) {
    return '$count crew-zending(en) opgehaald in $country';
  }

  @override
  String get smugglingClientShipmentFailed => 'Zending mislukt';

  @override
  String get smugglingClientQuoteFailed => 'Quote mislukt';

  @override
  String get smugglingClientClaimFailed => 'Ophalen mislukt';

  @override
  String smugglingClientErrorPrefix(String detail) {
    return 'Fout: $detail';
  }

  @override
  String get cryptoMarketNoData => 'Geen crypto marktdata beschikbaar';

  @override
  String get cryptoMarketTitle => 'Crypto markt';

  @override
  String cryptoMarketOpenOrdersCount(int count) {
    return 'Open orders: $count';
  }

  @override
  String get cryptoRegimeBull => 'Bullmarkt';

  @override
  String get cryptoRegimeBear => 'Bearmarkt';

  @override
  String get cryptoRegimeSideways => 'Zijwaarts';

  @override
  String cryptoOwnedAmountLine(String amount) {
    return 'In bezit: $amount';
  }

  @override
  String get cryptoPortfolioTitle => 'Portfolio';

  @override
  String get cryptoLabelValue => 'Waarde';

  @override
  String get cryptoLabelCostBasis => 'Inleg';

  @override
  String get cryptoLabelUnrealized => 'Ongerealiseerd';

  @override
  String get cryptoLabelRealized => 'Gerealiseerd';

  @override
  String get cryptoNoPositionsYet => 'Nog geen posities';

  @override
  String get cryptoChartDataUnavailable => 'Grafiekdata niet beschikbaar';

  @override
  String get cryptoUnknownTime => 'Onbekend';

  @override
  String get cryptoOrderTypeStopLoss => 'Stop-loss';

  @override
  String get cryptoOrderTypeTakeProfit => 'Take-profit';

  @override
  String get cryptoOrderTypeLimit => 'Limit';

  @override
  String get cryptoSideBuy => 'Koop';

  @override
  String get cryptoSideSell => 'Verkoop';

  @override
  String get cryptoInvalidQuantity => 'Ongeldige hoeveelheid';

  @override
  String get cryptoPurchaseCompleted => 'Aankoop voltooid';

  @override
  String get cryptoSaleCompleted => 'Verkoop voltooid';

  @override
  String get cryptoActionProcessed => 'Actie verwerkt';

  @override
  String get cryptoInvalidTargetPrice => 'Ongeldige doelprijs';

  @override
  String get cryptoCannotSellMoreThanOwned =>
      'Je kunt niet meer verkopen dan je bezit.';

  @override
  String get cryptoOpenOrderPlaced => 'Open order geplaatst';

  @override
  String get cryptoOpenOrderFailed => 'Order plaatsen mislukt';

  @override
  String get cryptoOrderCancelled => 'Order geannuleerd';

  @override
  String get cryptoCancelOrderFailed => 'Order annuleren mislukt';

  @override
  String get cryptoDirectTradeTitle => 'Direct handelen';

  @override
  String get cryptoLabelQuantity => 'Hoeveelheid';

  @override
  String cryptoDirectTradeHelperWithAvgAndAll(
    String currentPrice,
    String avgBuy,
  ) {
    return 'Huidige prijs: €$currentPrice • Gem. gekocht: €$avgBuy\nGebruik ALL om je volledige positie direct te verkopen.';
  }

  @override
  String cryptoDirectTradeHelperWithAvgOnly(
    String currentPrice,
    String avgBuy,
  ) {
    return 'Huidige prijs: €$currentPrice • Gem. gekocht: €$avgBuy';
  }

  @override
  String cryptoDirectTradeHelperPriceAndAll(String currentPrice) {
    return 'Huidige prijs: €$currentPrice\nGebruik ALL om je volledige positie direct te verkopen.';
  }

  @override
  String cryptoDirectTradeHelperPriceOnly(String currentPrice) {
    return 'Huidige prijs: €$currentPrice';
  }

  @override
  String cryptoYourHistoryForSymbol(String symbol) {
    return 'Jouw historie voor $symbol';
  }

  @override
  String get cryptoLabelAvgBuy => 'Gem. gekocht';

  @override
  String get cryptoLabelLastBuy => 'Laatste koop';

  @override
  String get cryptoLabelBuyVolume => 'Koopvolume';

  @override
  String get cryptoLabelSellVolume => 'Verkoopvolume';

  @override
  String cryptoLastBuyAt(String when) {
    return 'Laatste koop op $when';
  }

  @override
  String get cryptoNoTradesForCoinYet => 'Nog geen trades voor deze coin.';

  @override
  String cryptoOpenOrdersForSymbol(String symbol) {
    return 'Open orders voor $symbol';
  }

  @override
  String get cryptoOpenOrdersSectionHint =>
      'Open orders gebruiken hun eigen hoeveelheid hieronder. Vul in deze sectie zowel hoeveelheid als doelprijs in.';

  @override
  String get cryptoLabelOrderType => 'Ordertype';

  @override
  String get cryptoLabelSide => 'Richting';

  @override
  String get cryptoLabelOrderQuantity => 'Order hoeveelheid';

  @override
  String cryptoOrderQtyHelperOwned(String quantity) {
    return 'Voor deze order verkoop je vanuit je huidige positie. In bezit: $quantity';
  }

  @override
  String get cryptoOrderQtyHelperStandalone =>
      'Deze hoeveelheid staat los van direct handelen hierboven.';

  @override
  String get cryptoLabelTargetPrice => 'Doelprijs';

  @override
  String get cryptoTargetPriceHelperLimit =>
      'Limit buy onder prijs, limit sell boven prijs';

  @override
  String get cryptoTargetPriceHelperStopLoss =>
      'Wordt uitgevoerd als prijs daalt tot dit niveau';

  @override
  String get cryptoTargetPriceHelperTakeProfit =>
      'Wordt uitgevoerd als prijs stijgt tot dit niveau';

  @override
  String get cryptoPlaceOpenOrder => 'Plaats open order';

  @override
  String get cryptoNoOpenOrdersYet =>
      'Je hebt nog geen open orders voor deze coin.';

  @override
  String get cryptoLabelCancel => 'Annuleer';

  @override
  String cryptoDetailsTitleWithSymbol(String symbol) {
    return 'Crypto details • $symbol';
  }

  @override
  String get cryptoLabelCoin => 'Coin';

  @override
  String get cryptoLabelPrice => 'Prijs';

  @override
  String get cryptoLabelOwned => 'In bezit';

  @override
  String get cryptoLabelOpenOrders => 'Open orders';

  @override
  String get cryptoNotEnoughHistory => 'Nog te weinig historiek';

  @override
  String get cryptoChartPointsWord => 'punten';

  @override
  String get cryptoChartHourAbbrev => 'u';

  @override
  String cryptoChartDataCaptionFullHistory(int count, String points) {
    return '$count $points • volledige historie';
  }

  @override
  String cryptoChartDataCaptionHours(int count, String points, String hours) {
    return '$count $points • $hours';
  }

  @override
  String get cryptoChartRange1h => '1u';

  @override
  String get cryptoChartRange4h => '4u';

  @override
  String get cryptoChartRange8h => '8u';

  @override
  String get cryptoChartRange24h => '24u';

  @override
  String get cryptoChartRange7d => '7d';

  @override
  String get cryptoChartRange30d => '30d';

  @override
  String get cryptoChartRangeAll => 'Alles';

  @override
  String get cryptoChartLive1h => 'Live • laatste 1u';

  @override
  String get cryptoChartLive4h => 'Live • laatste 4u';

  @override
  String get cryptoChartLive8h => 'Live • laatste 8u';

  @override
  String get cryptoChartLive24h => 'Live • laatste 24u';

  @override
  String get cryptoChartLive7d => 'Live • laatste 7 dagen';

  @override
  String get cryptoChartLive30d => 'Live • laatste 30 dagen';

  @override
  String get cryptoChartLiveAll => 'Live • volledige historie';

  @override
  String get cryptoLabelTotal => 'Totaal';

  @override
  String get cryptoApiCouldNotLoadMarket => 'Kon crypto markt niet laden.';

  @override
  String get cryptoApiAssetNotFound => 'Crypto niet gevonden.';

  @override
  String get cryptoApiCouldNotLoadChart => 'Kon crypto grafiekdata niet laden.';

  @override
  String get cryptoApiNotLoggedIn => 'Niet ingelogd.';

  @override
  String get cryptoApiCouldNotLoadPortfolio => 'Kon portfolio niet laden.';

  @override
  String get cryptoApiCouldNotLoadTransactions =>
      'Kon crypto transactiehistorie niet laden.';

  @override
  String get cryptoApiInvalidQuantity => 'Ongeldige hoeveelheid.';

  @override
  String get cryptoApiInsufficientFunds => 'Niet genoeg geld.';

  @override
  String get cryptoApiPurchaseFailed => 'Aankoop mislukt.';

  @override
  String get cryptoApiNotEnoughCrypto => 'Niet genoeg crypto in bezit.';

  @override
  String get cryptoApiSellFailed => 'Verkoop mislukt.';

  @override
  String get cryptoApiCouldNotLoadOrders => 'Kon crypto orders niet laden.';

  @override
  String get cryptoApiInvalidTargetPrice => 'Ongeldige doelprijs.';

  @override
  String get cryptoApiInvalidOrderType => 'Ongeldig ordertype.';

  @override
  String get cryptoApiInvalidOrderSide => 'Ongeldige orderrichting.';

  @override
  String get cryptoApiInvalidOrderCombination =>
      'Deze combinatie van ordertype en richting is niet toegestaan.';

  @override
  String get cryptoApiPlaceOrderFailed => 'Order plaatsen mislukt.';

  @override
  String get cryptoApiPlayerNotFound => 'Speler niet gevonden.';

  @override
  String get cryptoApiInvalidOrderId => 'Ongeldig order-id.';

  @override
  String get cryptoApiOrderNotFoundOrClosed =>
      'Order niet gevonden of niet meer actief.';

  @override
  String get cryptoApiCancelOrderFailed => 'Order annuleren mislukt.';

  @override
  String cryptoApiBuySuccess(String quantity, String symbol, String total) {
    return 'Je kocht $quantity $symbol voor €$total.';
  }

  @override
  String cryptoApiSellSuccess(String quantity, String symbol, String total) {
    return 'Je verkocht $quantity $symbol voor €$total.';
  }

  @override
  String cryptoApiOrderPlaced(
    String side,
    String quantity,
    String symbol,
    String price,
  ) {
    return 'Order geplaatst: $side $quantity $symbol @ $price.';
  }

  @override
  String cryptoApiOrderCancelledDetail(int orderId) {
    return 'Order $orderId geannuleerd.';
  }

  @override
  String cryptoClientErrorPrefix(String detail) {
    return 'Fout: $detail';
  }

  @override
  String drugsClientErrorLoading(String error) {
    return 'Fout bij laden: $error';
  }

  @override
  String drugsFacilitiesErrorLoading(String error) {
    return 'Fout bij laden faciliteiten: $error';
  }

  @override
  String get drugsInvTitle => 'Drugsvoorraad';

  @override
  String get drugsInvKpiGramsLabel => 'voorraad';

  @override
  String get drugsCutQualityDCannotCut =>
      'Kwaliteit D kan niet verder worden gesneden.';

  @override
  String get drugsCutFailed => 'Snijden mislukt';

  @override
  String get drugsSellFailed => 'Verkoop mislukt';

  @override
  String drugsSellDialogTitle(String name) {
    return 'Verkoop $name';
  }

  @override
  String drugsInvAvailableQty(String qty) {
    return 'Beschikbaar: $qty g';
  }

  @override
  String drugsQualityWithGrade(String grade) {
    return 'Kwaliteit: $grade';
  }

  @override
  String drugsCurrentPricePerGram(String price) {
    return 'Huidige prijs: €$price per gram';
  }

  @override
  String get drugsPricesByCountry => 'Prijzen per land:';

  @override
  String get drugsQuantityGramsField => 'Hoeveelheid (gram)';

  @override
  String drugsInvTotalLine(String amount) {
    return 'Totaal: €$amount';
  }

  @override
  String get drugsInvalidQuantity => 'Ongeldige hoeveelheid';

  @override
  String get drugsSellAction => 'Verkopen';

  @override
  String get drugsInvEmptyTitle => 'Geen drugs in voorraad';

  @override
  String get drugsInvEmptySubtitle => 'Start productie om drugs te maken';

  @override
  String get drugsInvSectionHeader => 'Voorraad & distributie';

  @override
  String get drugsInvSectionBody =>
      'Verkoop drugs per kwaliteit en gebruik prijsverschillen tussen landen.';

  @override
  String drugsInvCurrentLocation(String place) {
    return 'Huidige locatie: $place';
  }

  @override
  String drugsInvStockLine(String qty) {
    return 'Voorraad: $qty g';
  }

  @override
  String drugsInvCurrentValue(String amount) {
    return 'Huidige waarde: €$amount';
  }

  @override
  String drugsInvMarketLine(String emoji, String pct) {
    return 'Markt: $emoji $pct%';
  }

  @override
  String get drugsCutDialogTitle => 'Drugs snijden';

  @override
  String drugsCutQualityBanner(String fromQ, String toQ, String pct) {
    return 'Kwaliteit $fromQ → $toQ: +$pct% meer eenheden';
  }

  @override
  String drugsCutResultLine(
    String qty,
    String qFrom,
    String result,
    String qTo,
  ) {
    return 'Resultaat: $qty g $qFrom → $result g $qTo';
  }

  @override
  String get drugsCutAction => 'Snijden';

  @override
  String get drugsSlotsLabel => 'slots';

  @override
  String get drugsFacilitiesTitle => 'Drugsfaciliteiten';

  @override
  String get drugsFacilitiesHeroTitle => 'Beheer je drugsfaciliteiten';

  @override
  String get drugsFacilitiesHeroBody =>
      'Faciliteiten zoals kas, paddenstoelenkwekerij, drugslab, crackkeuken en darkweb-winkel bepalen welke drugs je kunt produceren, hoeveel slots je hebt en hoe sterk kwaliteit, opbrengst en snelheid zijn.';

  @override
  String get drugsFacCurrentProductions => 'Lopende producties';

  @override
  String get drugsFacUnknownFacility => 'Onbekende faciliteit';

  @override
  String get drugsFacUnknownMessage => 'Onbekend bericht';

  @override
  String get drugsFacUpgradeLockedTitle => '🔒 Drugsupgrade vergrendeld';

  @override
  String get drugsFacUpgradeLockedBody =>
      'Je hebt eerst de juiste Narcotica-opleidingsniveaus en certificaten nodig.';

  @override
  String get drugsFacEquipLockedTitle => '🔒 Apparatuur-upgrade vergrendeld';

  @override
  String get drugsFacEquipLockedBody =>
      'Train eerst je Narcotica-track om het volgende upgradeniveau te ontgrendelen.';

  @override
  String get drugsFacBuy => 'Kopen';

  @override
  String get drugsFacOwned => 'In bezit';

  @override
  String get drugsFacPrice => 'Prijs';

  @override
  String get drugsFacRank => 'Rank';

  @override
  String get drugsFacDrugTypes => 'Drugs';

  @override
  String get drugsFacSlots => 'Slots';

  @override
  String get drugsFacQuality => 'Kwaliteit';

  @override
  String get drugsFacYield => 'Opbrengst';

  @override
  String get drugsFacSpeed => 'Snelheid';

  @override
  String get drugsFacMaxSlots => 'Max. slots';

  @override
  String drugsFacUpgradeSlots(String cost) {
    return 'Slots upgraden (€$cost)';
  }

  @override
  String get drugsFacEquipmentUpgrades => 'Apparatuur-upgrades';

  @override
  String get drugsFacMax => 'Max';

  @override
  String drugsFacLvlPrice(String level, String price) {
    return 'Lvl $level (€$price)';
  }

  @override
  String get drugsHubTitle => 'Drugsomgeving';

  @override
  String get drugsSubviewProduction => 'Drugsproductie';

  @override
  String get drugsSubviewFacilities => 'Drugsfaciliteiten';

  @override
  String get drugsSubviewInventory => 'Drugsvoorraad';

  @override
  String get drugsTagUndergroundOps => 'Ondergrondse operaties';

  @override
  String get drugsTagMobileOptimized => 'Mobiel geoptimaliseerd';

  @override
  String get drugsTagQualityDriven => 'Kwaliteitsgedreven';

  @override
  String get drugsEmpireTitle => 'Drugsimperium';

  @override
  String get drugsHubIntro =>
      'Beheer hier productie, faciliteiten en voorraad. Koop grondstoffen op de zwarte markt terwijl de rest in je eigen drugsomgeving draait.';

  @override
  String get drugsStatMaterialFlow => 'Materiaalstroom';

  @override
  String get drugsStatBlackMarket => 'Zwarte markt';

  @override
  String get drugsStatProductionChain => 'Productieketen';

  @override
  String get drugsStatProductionChainValue => 'Kas + lab + keuken + darkweb';

  @override
  String get drugsStatSalesModel => 'Verkoopmodel';

  @override
  String get drugsStatPerQuality => 'Per kwaliteit';

  @override
  String get drugsMetricActiveBatches => 'Actieve batches';

  @override
  String get drugsMetricSlotUsage => 'Slotgebruik';

  @override
  String get drugsMetricInventoryValue => 'Voorraadwaarde';

  @override
  String get drugsMetricInventoryGrams => 'Voorraad (gram)';

  @override
  String get drugsMetricEfficiency => 'Efficiëntie';

  @override
  String get drugsMetricPoliceHeat => 'Politiehitte';

  @override
  String get drugsSectionOperations => 'Operaties';

  @override
  String get drugsSectionOperationsSubtitle =>
      'Kies een poot van je drugsimperium';

  @override
  String get drugsCardFacilitiesEyebrow => 'Infrastructuur';

  @override
  String get drugsCardFacilitiesTitle => 'Faciliteiten';

  @override
  String get drugsCardFacilitiesBody =>
      'Koop en upgrade kas, drugslab, crackkeuken en darkweb-winkel voor meer slots, snelheid en kwaliteit.';

  @override
  String get drugsCardProductionEyebrow => 'Pijplijn';

  @override
  String get drugsCardProductionTitle => 'Productie';

  @override
  String get drugsCardProductionBody =>
      'Start batches, volg timers en verzamel output met kwaliteitsrolls.';

  @override
  String get drugsCardInventoryEyebrow => 'Distributie';

  @override
  String get drugsCardInventoryTitle => 'Voorraad';

  @override
  String get drugsCardInventoryBody =>
      'Bekijk stapels per kwaliteit en verkoop tegen de beste marktwaarde.';

  @override
  String get drugsQualityDistribution => 'Kwaliteitsverdeling';

  @override
  String get drugsQualityGradeSuperior => 'Superieur';

  @override
  String get drugsQualityGradeHigh => 'Hoog';

  @override
  String get drugsQualityGradeStandardPlus => 'Standaard+';

  @override
  String get drugsQualityGradeStandard => 'Standaard';

  @override
  String get drugsQualityGradeLow => 'Laag';

  @override
  String get drugsHeatLevelLow => 'Laag';

  @override
  String get drugsHeatLevelMedium => 'Gemiddeld';

  @override
  String get drugsHeatLevelHigh => 'Hoog';

  @override
  String get drugsHeatLevelCritical => 'Kritiek';

  @override
  String get drugsProdTitle => 'Drugsproductie';

  @override
  String get drugsProdLineTitle => 'Productielijn';

  @override
  String get drugsProdLineSubtitle =>
      'Start batches, monitor slotcapaciteit en stuur kwaliteit bij via kas- en lab-upgrades.';

  @override
  String get drugsProdActiveProductions => 'Actieve producties';

  @override
  String get drugsProdIncidentLegend => 'Incidentlegenda';

  @override
  String get drugsProdHide => 'Verbergen';

  @override
  String get drugsProdShow => 'Tonen';

  @override
  String get drugsProdLegendDelay => 'Vertraging';

  @override
  String get drugsProdLegendContamination => 'Besmetting';

  @override
  String get drugsProdLegendYieldLoss => 'Opbrengstverlies';

  @override
  String get drugsProdLegendInstability => 'Instabiliteit';

  @override
  String get drugsProdLegendCombined => 'Gecombineerd probleem';

  @override
  String get drugsProdCollect => 'Ophalen';

  @override
  String get drugsProdAvailableDrugs => 'Beschikbare drugs';

  @override
  String get drugsProdNoDrugs => 'Geen drugs beschikbaar';

  @override
  String get drugsProdAutoCollectOn => 'Auto-oogst aan (VIP)';

  @override
  String get drugsProdAutoCollectOff => 'Auto-oogst uit (VIP)';

  @override
  String get drugsProdVipMaterialsOk => 'Alle materialen beschikbaar';

  @override
  String get drugsProdVipBuyMissing =>
      'VIP: ontbrekende materialen in één klik kopen';

  @override
  String drugsProdTimeYieldLine(String time, String yield) {
    return 'Tijd: $time | Opbrengst: $yield g';
  }

  @override
  String drugsProdSlotsUsedLine(String facility, String used, String total) {
    return '$facility: $used/$total slots in gebruik';
  }

  @override
  String drugsProdFacilityRequired(String facility) {
    return '$facility vereist';
  }

  @override
  String drugsProdRankRequired(String rank) {
    return 'Rank $rank vereist';
  }

  @override
  String get drugsProdNoFreeSlot => 'Geen vrije productieslot beschikbaar';

  @override
  String get drugsProdOpenFacilities => 'Open faciliteiten';

  @override
  String get drugsProdStartProduction => 'Start productie';

  @override
  String get drugsProdAutoCollectUpdated => 'Auto-oogst bijgewerkt';

  @override
  String get drugsProdKpiActive => 'actief';

  @override
  String get drugsProdKpiReady => 'klaar';

  @override
  String drugsProdYieldGrams(String qty) {
    return 'Opbrengst: $qty gram';
  }

  @override
  String get drugsTimeMinSuffix => 'min';

  @override
  String drugsFmtMinutes(String minutes) {
    return '$minutes min';
  }

  @override
  String drugsFmtHoursOnly(String hours) {
    return '$hours uur';
  }

  @override
  String drugsFmtHoursMinutes(String hours, String minutes) {
    return '$hours uur $minutes min';
  }

  @override
  String get drugsTimeHourEn => 'u';

  @override
  String get drugsProdConfirmTitle => 'Weet je het zeker?';

  @override
  String drugsProdConfirmBody(String drugName) {
    return '$drugName-productie starten?';
  }

  @override
  String drugsProdTimeLine(String time) {
    return 'Tijd: $time';
  }

  @override
  String drugsProdYieldLine(String yield) {
    return 'Opbrengst: $yield gram';
  }

  @override
  String get drugsProdRiskNote =>
      'Productie kan soms tegenslag krijgen. Betere upgrades verlagen het risico, hoge drugshitte verhoogt het.';

  @override
  String get drugsProdRequiredMaterialsHeader => 'Benodigde materialen:';

  @override
  String get drugsProdStartProductionButton => 'Start productie';

  @override
  String get drugsProdFailed => 'Productie mislukt';

  @override
  String get drugsProdCollectFailed => 'Oogsten mislukt';

  @override
  String drugsProdNeedRank(String rank) {
    return 'Je hebt rank $rank nodig';
  }

  @override
  String get drugsProdMissingPrefix => 'Ontbreekt';

  @override
  String get drugsFacilityGreenhouse => 'Kas';

  @override
  String get drugsFacilityCrackKitchen => 'Crackkeuken';

  @override
  String get drugsFacilityDarkweb => 'Darkweb-winkel';

  @override
  String get drugsFacilityMushroomFarm => 'Paddenstoelenkwekerij';

  @override
  String get drugsFacilityDrugLab => 'Drugslab';

  @override
  String get drugsVipQuickBuyTitle => 'VIP-snelaankoop';

  @override
  String drugsVipAlreadyEnough(String name) {
    return 'Je hebt al genoeg materialen voor $name';
  }

  @override
  String drugsVipBuyPrompt(String name) {
    return 'Alle ontbrekende materialen voor $name in één klik kopen?';
  }

  @override
  String drugsVipTotal(String amount) {
    return 'Totaal: €$amount';
  }

  @override
  String get drugsPurchaseCompleted => 'Aankoop voltooid';

  @override
  String get drugsPurchaseFailed => 'Aankoop mislukt';

  @override
  String get drugsServiceErrorGeneric => 'Fout';

  @override
  String get drugsApiFailedBuyMaterial => 'Materiaal kopen mislukt';

  @override
  String get drugsApiFailedStartProduction => 'Productie starten mislukt';

  @override
  String get drugsApiFailedCollect => 'Productie oogsten mislukt';

  @override
  String get drugsApiFailedSell => 'Drugs verkopen mislukt';

  @override
  String get drugsApiFailedCut => 'Drugs snijden mislukt';

  @override
  String get drugsApiFailedShipment => 'Zending versturen mislukt';

  @override
  String get drugsApiFailedClaim => 'Depotzendingen claimen mislukt';
}
