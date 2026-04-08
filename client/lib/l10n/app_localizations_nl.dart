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
  String get dashboardTimeouts => 'Timeouts';

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
  String crimeErrorDrugsRequired(String quantity, String drugs) {
    return 'Je hebt minimaal ${quantity}x nodig van: $drugs';
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
  String get travelStart => 'Start';

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
  String get crew => 'Crew';

  @override
  String get profile => 'Profiel';

  @override
  String get logout => 'Uitloggen';

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
  String get english => 'English';

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
  String get oncePerMonth => '1x per maand wijzigen';

  @override
  String get privacy => 'Privacy';

  @override
  String get allowMessages => 'Berichten toestaan';

  @override
  String get allowMessagesDesc => 'Andere spelers kunnen je berichten sturen';

  @override
  String get settingsSaved => 'Instellingen opgeslagen';

  @override
  String get vipStatus => 'VIP Status';

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
  String get vipAvatars => 'VIP Avatars';

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
  String get foodBurger => 'Burger';

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
  String get properties => 'Eigendommen';

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
  String get propertyMaxLevel => 'Max Level';

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
  String get propertyUpgradeAction => 'Upgrade';

  @override
  String get propertyMax => 'MAX';

  @override
  String propertyLevel(String level) {
    return 'Level $level';
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
    return 'Upgrade (€$cost)';
  }

  @override
  String get garageMaxLevel => 'Max Level';

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
  String get wantedLevel => 'Gezocht Niveau';

  @override
  String get cooldown => 'Cooldown';

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
    return 'Cooldown: $minutes min';
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
  String get vehicles => 'Voertuigen';

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
  String get free => 'GRATIS';

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
  String get multiplier => 'Multiplier';

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
    return 'Upgrade (€$cost)';
  }

  @override
  String get marinaMaxLevel => 'Max Level';

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
  String get level => 'Level';

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
  String get property => 'Property';

  @override
  String inventorySlots(int used, int max) {
    return '$used / $max slots';
  }

  @override
  String get loadouts => 'Loadouts';

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
  String get tools => 'gereedschap';

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
  String get extraSlots => 'Extra slots';

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
  String get arrested => 'Gearresteerd!';

  @override
  String get jailMessage =>
      'Je bent gearresteerd tijdens je reis en alle goederen zijn in beslag genomen!';

  @override
  String get confirmAction => 'Weet je het zeker?';

  @override
  String get yes => 'Ja';

  @override
  String get no => 'Nee';

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
  String get security => 'Veiligheid';

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
  String get armor => 'Armor';

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
  String get hit => 'MOORD';

  @override
  String daysAgo(String count, String plural) {
    return '$count dag$plural geleden';
  }

  @override
  String hoursAgo(String count) {
    return '$count uur geleden';
  }

  @override
  String minutesAgo(String count) {
    return '$count minuten geleden';
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
  String get securityScreen => 'Veiligheid';

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
      'Productie gestart: 8 uur actief, elke 5 minuten nieuwe munitie';

  @override
  String get ammoFactoryTitle => 'Munitiefabriek';

  @override
  String get ammoFactoryIntro =>
      'Produceert automatisch elke 5 minuten. Je kunt tot 8 uur achterstallige productie innen.';

  @override
  String get ammoFactoryWhatYouCanDo => 'Wat je kunt doen:';

  @override
  String get ammoFactoryActionBuy => 'Koop een fabriek in je huidige land';

  @override
  String get ammoFactoryActionProduce =>
      'Incasseer productie (interval: 5 minuten, max backlog: 8 uur)';

  @override
  String get ammoFactoryActionOutput =>
      'Upgrade output tot level 5 (max ±3200 per 8u / ±400 per uur)';

  @override
  String get ammoFactoryActionQuality =>
      'Upgrade kwaliteit voor sterkere marktprijzen';

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
  String get factoryProduceStatusLabel => 'Produce status';

  @override
  String get factoryProduceStatusReady => 'Klaar';

  @override
  String get factoryProduceStatusCooldown => 'Cooldown';

  @override
  String get factorySessionActive =>
      'Productie venster: actief (5 min interval)';

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
  String get factoryUpgradeOutput => 'Upgrade Output';

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
  String get shootingTrainSuccess => 'Training voltooid';

  @override
  String shootingSessions(String count) {
    return 'Sessies: $count/100';
  }

  @override
  String shootingAccuracyBonus(String bonus) {
    return 'Accuracy bonus: $bonus%';
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
  String get gymTrainSuccess => 'Training voltooid';

  @override
  String gymSessions(String count) {
    return 'Sessies: $count/100';
  }

  @override
  String gymStrengthBonus(String bonus) {
    return 'Kracht bonus: $bonus%';
  }

  @override
  String gymCooldown(String time) {
    return 'Volgende sessie om $time';
  }

  @override
  String get gymTrain => 'Trainen';

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
  String get countryUsa => 'USA';

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
  String get countryIndia => 'India';

  @override
  String get countryAustralia => 'Australië';

  @override
  String get countrySouthAfrica => 'Zuid-Afrika';

  @override
  String get countryCanada => 'Canada';

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
  String get toolHackingLaptop => 'Hacking Laptop';

  @override
  String get toolCounterfeitingKit => 'Vervalsings Kit';

  @override
  String get toolRope => 'Touw';

  @override
  String get toolSilencer => 'Geluiddemper';

  @override
  String get toolNightVision => 'Nachtbril';

  @override
  String get toolGpsJammer => 'GPS Jammer';

  @override
  String get toolBurnerPhone => 'Wegwerp Telefoon';

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
  String get prostitutionRedLight => 'Red Light';

  @override
  String get prostitutionPotentialEarnings => 'Inkomsten';

  @override
  String get prostitutionCollect => 'Ophalen';

  @override
  String get prostitutionRecruit => 'Werven';

  @override
  String get prostitutionMyProstitutes => 'Mijn Prostituees';

  @override
  String get prostitutionRedLightDistricts => 'Red Light Districts';

  @override
  String get prostitutionNoProstitutes => 'Nog geen prostituees geworven';

  @override
  String get prostitutionLocation => 'Locatie';

  @override
  String get prostitutionMoveToRedLight => 'Verplaats naar Red Light';

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
  String get prostitutionInRedLight => 'In Red Light District';

  @override
  String get prostitutionEarnings => 'Inkomsten';

  @override
  String get prostitutionRent => 'Huur';

  @override
  String get prostitutionNetIncome => 'Netto Inkomsten';

  @override
  String get prostitutionLevel => 'Level';

  @override
  String get prostitutionXpToNext => 'XP tot volgend level';

  @override
  String get prostitutionBusted => 'GEPAKT';

  @override
  String get prostitutionBustedCount => 'Aantal keer gepakt';

  @override
  String get prostitutionLevelBonus => 'Level bonus';

  @override
  String get prostitutionVipBonus => 'VIP bonus: +50% inkomsten';

  @override
  String get prostitutionUpgradeTier => 'Tier Upgraden';

  @override
  String get prostitutionUpgradeSecurity => 'Beveiliging Upgraden';

  @override
  String get prostitutionTier => 'Tier';

  @override
  String get prostitutionSecurity => 'Beveiliging';

  @override
  String get prostitutionTierBasic => 'Basic';

  @override
  String get prostitutionTierLuxury => 'Luxury';

  @override
  String get prostitutionTierVip => 'VIP';

  @override
  String get prostitutionSecurityLevel => 'Security Level';

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
  String get vipEventsTitle => 'VIP Events';

  @override
  String get vipEventsTabTitle => 'VIP Events';

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
  String get vipEventTypeTitle => 'VIP Event';

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
  String get vipEventLevel => 'Level';

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
  String get prostitutionLeaderboardAllTime => 'All-Time';

  @override
  String get prostitutionLeaderboardYourRank => 'Jouw Wekelijkse Rang';

  @override
  String get prostitutionLeaderboardUnranked => 'Niet gerankt';

  @override
  String get prostitutionLeaderboardNoData => 'Nog geen leaderboard data';

  @override
  String get prostitutionLeaderboardButton => 'Leaderboard';

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
  String get achievementJobItSpecialistTitle => 'IT Specialist';

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
  String get achievementSchoolTrackSpecialistTitle => 'Track Specialist';

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
    return 'Lv $current/$max';
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
  String get schoolGateStatusLocked => 'LOCKED';

  @override
  String schoolGateRankProgress(int current, int required) {
    return 'Speler rank: $current/$required';
  }

  @override
  String schoolGateTrackLevelProgress(String track, int current, int required) {
    return '$track level: $current/$required';
  }

  @override
  String schoolGateJobTarget(String target) {
    return 'Job: $target';
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
  String schoolGateAssetGeneric(String target) {
    return 'Asset: $target';
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
    return 'Nodig: speler rank $requiredRank · Huidig: speler rank $currentRank';
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
  String get educationTrackNameFinance => 'Finance';

  @override
  String get educationTrackNameEngineering => 'Techniek';

  @override
  String get educationTrackNameIt => 'IT';

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
  String schoolTrackCooldownActive(int seconds) {
    return 'Cooldown actief: nog ${seconds}s';
  }

  @override
  String get schoolTrackMaxLevelReached => 'Track is al max level';

  @override
  String get schoolTrackStartFailed => 'Opleiding starten mislukt';

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
  String get rivalryStartButton => 'Start';

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
    return 'Cooldown: $duration';
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
  String get achievementTitle_high_roller => 'High Roller';

  @override
  String get achievementDescription_high_roller =>
      'Verdien in totaal €5.000.000';

  @override
  String get achievementTitle_vip_service => 'VIP Service';

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
  String get achievementTitle_the_godfather => 'The Godfather';

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
  String get achievementTitle_job_it_specialist => 'IT Specialist';

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
  String get achievementTitle_school_track_specialist => 'Track Specialist';

  @override
  String get achievementDescription_school_track_specialist =>
      'Max 3 school-tracks';

  @override
  String get achievementTitle_school_freshman => 'School Freshman';

  @override
  String get achievementDescription_school_freshman => 'Bereik schoollevel 1';

  @override
  String get achievementTitle_school_scholar => 'School Scholar';

  @override
  String get achievementDescription_school_scholar => 'Bereik schoollevel 3';

  @override
  String get achievementTitle_school_graduate => 'School Graduate';

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
  String get achievementTitle_grand_theft_fleet => 'Grand Theft Fleet';

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
  String get achievementTitle_jet_setter => 'Jet Setter';

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
  String get achievementTitle_prostitute_cartel_500 => 'Cartel 500';

  @override
  String get achievementDescription_prostitute_cartel_500 =>
      'Recruit 500 hoeren';

  @override
  String get achievementTitle_prostitute_legend_1000 => 'Legende 1000';

  @override
  String get achievementDescription_prostitute_legend_1000 =>
      'Recruit 1000 hoeren';

  @override
  String get achievementTitle_vip_prostitute_level_10 => 'VIP Beginner';

  @override
  String get achievementDescription_vip_prostitute_level_10 =>
      'Bereik level 3 met een VIP-hoer';

  @override
  String get achievementTitle_vip_prostitute_level_25 => 'VIP Headliner';

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
  String get achievementTitle_nightclub_headliner => 'Headliner Booker';

  @override
  String get achievementDescription_nightclub_headliner =>
      'Boek 10 DJ-shifts voor je nightclub-imperium';

  @override
  String get achievementTitle_nightclub_full_house => 'Vol Huis';

  @override
  String get achievementDescription_nightclub_full_house =>
      'Breng een nightclub crowd naar 90% capaciteit';

  @override
  String get achievementTitle_nightclub_cash_machine => 'Cash Machine';

  @override
  String get achievementDescription_nightclub_cash_machine =>
      'Verdien in totaal €250.000 nightclub-omzet';

  @override
  String get achievementTitle_nightclub_empire => 'Nightlife Imperium';

  @override
  String get achievementDescription_nightclub_empire =>
      'Verdien in totaal €1.000.000 nightclub-omzet';

  @override
  String get achievementTitle_nightclub_staffing_boss => 'Staffing Boss';

  @override
  String get achievementDescription_nightclub_staffing_boss =>
      'Laat 3 actieve nightclub-crewmembers tegelijk draaien';

  @override
  String get achievementTitle_nightclub_vip_room => 'VIP Room';

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
  String get nightclubKpiCrowd => 'Crowd';

  @override
  String get nightclubKpiVibe => 'Vibe';

  @override
  String get nightclubKpiToday => 'Vandaag';

  @override
  String get nightclubKpiAllTime => 'All-time';

  @override
  String get nightclubKpiStock => 'Voorraad';

  @override
  String get nightclubKpiDj => 'DJ';

  @override
  String get nightclubKpiThefts => 'Diefstallen';

  @override
  String get nightclubKpiStaff => 'Staff';

  @override
  String get nightclubKpiSalesBoost => 'Sales boost';

  @override
  String get nightclubKpiPriceBoost => 'Price boost';

  @override
  String get nightclubKpiVipBonus => 'VIP bonus';

  @override
  String get nightclubStatusActive => 'Actief';

  @override
  String get nightclubStatusOff => 'Uit';

  @override
  String get nightclubStatusActiveLower => 'actief';

  @override
  String get nightclubRevenueTrend => 'Omzet Trend (live)';

  @override
  String get nightclubLeaderboardTitle => 'Top Nightclubs';

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
  String get nightclubSeasonTitle => 'Weekly Season Ranking';

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
  String get nightclubSeasonScore => 'Score';

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
  String get nightclubStaffTitle => 'Pimp Crew in Club';

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
  String get nightclubVibeRaging => 'Raging';

  @override
  String get nightclubTheftTypeCustomer => 'Klantdiefstal';

  @override
  String get nightclubTheftTypeEmployee => 'Medewerker-heist';

  @override
  String get nightclubTheftTypeRival => 'Rivaal-sabotage';
}
