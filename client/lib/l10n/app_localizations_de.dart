// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Mafia-Spiel';

  @override
  String get login => 'Login';

  @override
  String get register => 'Registrieren';

  @override
  String get username => 'Benutzername';

  @override
  String get password => 'Passwort';

  @override
  String get usernameLabel => 'BENUTZERNAME';

  @override
  String get passwordLabel => 'PASSWORT';

  @override
  String get usernamePlaceholder => 'Benutzername';

  @override
  String get passwordPlaceholder => 'Passwort';

  @override
  String get loginButton => 'LOGIN';

  @override
  String get registerButton => 'REGISTRIEREN';

  @override
  String get forgotPassword => 'Passwort vergessen?';

  @override
  String get usernameRequired => 'Bitte geben Sie einen Benutzernamen ein';

  @override
  String get passwordRequired => 'Bitte geben Sie ein Passwort ein';

  @override
  String get passwordTooShort =>
      'Das Passwort muss mindestens 6 Zeichen lang sein';

  @override
  String get invalidCredentials => 'Falscher Benutzername oder Passwort';

  @override
  String get loginSuccessful => 'Anmeldung erfolgreich!';

  @override
  String get registrationSuccessful => 'Registrierung erfolgreich!';

  @override
  String get loginFailed => 'Fehler bei der Anmeldung';

  @override
  String get emailLabel => 'E-MAIL';

  @override
  String get emailPlaceholder => 'E-Mail';

  @override
  String get emailRequired => 'Bitte geben Sie eine E-Mail-Adresse ein';

  @override
  String get emailInvalid => 'Bitte geben Sie eine gültige E-Mail-Adresse ein';

  @override
  String get forgotPasswordTitle => 'Passwort zurücksetzen';

  @override
  String get forgotPasswordDescription =>
      'Geben Sie Ihre E-Mail-Adresse ein und wir senden Ihnen einen Link zum Zurücksetzen Ihres Passworts.';

  @override
  String get resetPasswordButton => 'RESET-LINK SENDEN';

  @override
  String get emailSent =>
      'Link zum Zurücksetzen gesendet! Überprüfen Sie Ihre E-Mails.';

  @override
  String get backToLogin => 'Zurück zum Anmelden';

  @override
  String welcome(String username) {
    return 'Willkommen, $username!';
  }

  @override
  String get dashboardTimeouts => 'Auszeiten';

  @override
  String get dashboardTimeoutCrime => 'Verbrechen';

  @override
  String get dashboardTimeoutJob => 'Arbeiten';

  @override
  String get dashboardTimeoutTravel => 'Reisen';

  @override
  String get dashboardTimeoutVehicleTheft => 'Auto stehlen';

  @override
  String get dashboardTimeoutBoatTheft => 'Boot stehlen';

  @override
  String get dashboardTimeoutNightclubSeason => 'Nachtclub-Saison';

  @override
  String get dashboardTimeoutAmmo => 'Kaufen Sie Kugeln';

  @override
  String get dashboardTimeoutShootingRange => 'Schießstand';

  @override
  String get dashboardTimeoutGym => 'Fitnessstudio';

  @override
  String get dashboardInfoDrugsGrams => 'Drogen (Gramm)';

  @override
  String get dashboardInfoNightclubs => 'Nachtclubs';

  @override
  String get dashboardInfoNightclubRevenue => 'Einnahmen aus Nachtclubs';

  @override
  String get dashboard => 'Armaturenbrett';

  @override
  String get crimes => 'Verbrechen';

  @override
  String get errorLoadingCrimes => 'Verbrechen konnten nicht geladen werden';

  @override
  String connectionError(String error) {
    return 'Verbindungsfehler: $error';
  }

  @override
  String payRange(String min, String max) {
    return 'Bezahlung: $min – €$max';
  }

  @override
  String requiresRank(String rank) {
    return 'Erfordert Rang $rank';
  }

  @override
  String get requiresVehicle => 'Erfordert Fahrzeug';

  @override
  String get federalCrimeWarning => '⚠️ Federal Crime – FBI Heat';

  @override
  String get crimePickpocketName => 'Taschendiebstahl';

  @override
  String get crimePickpocketDesc => 'Stehlen Sie Geldbörsen von Passanten';

  @override
  String get crimeShopliftName => 'Ladendiebstahl';

  @override
  String get crimeShopliftDesc => 'Waren aus einem Geschäft stehlen';

  @override
  String get crimeStealBikeName => 'Fahrrad stehlen';

  @override
  String get crimeStealBikeDesc => 'Ein Fahrrad vom Gepäckträger stehlen';

  @override
  String get crimeCarTheftName => 'Autodiebstahl';

  @override
  String get crimeCarTheftDesc => 'Ein geparktes Auto stehlen';

  @override
  String get crimeBurglaryName => 'Einbruch';

  @override
  String get crimeBurglaryDesc => 'In ein Haus einbrechen';

  @override
  String get crimeRobStoreName => 'Ladenraub';

  @override
  String get crimeRobStoreDesc => 'Raub einen kleinen Laden aus';

  @override
  String get crimeMugPersonName => 'Überfall';

  @override
  String get crimeMugPersonDesc => 'Jemanden auf der Straße überfallen';

  @override
  String get crimeStealCarPartsName => 'Autoteile stehlen';

  @override
  String get crimeStealCarPartsDesc => 'Teile aus geparkten Autos stehlen';

  @override
  String get crimeHijackTruckName => 'Entführungs-LKW';

  @override
  String get crimeHijackTruckDesc => 'Entführen Sie einen Lastwagen mit Gütern';

  @override
  String get crimeAtmTheftName => 'Diebstahl von Geldautomaten';

  @override
  String get crimeAtmTheftDesc => 'Brechen Sie in einen Geldautomaten ein';

  @override
  String get crimeJewelryHeistName => 'Schmuckraub';

  @override
  String get crimeJewelryHeistDesc => 'Raub einen Juwelier aus';

  @override
  String get crimeVandalismName => 'Vandalismus';

  @override
  String get crimeVandalismDesc => 'Sachbeschädigung für Geld';

  @override
  String get crimeGraffitiName => 'Graffiti';

  @override
  String get crimeGraffitiDesc => 'Sprühen Sie Graffiti für lokale Banden';

  @override
  String get crimeDrugDealSmallName => 'Kleiner Drogendeal';

  @override
  String get crimeDrugDealSmallDesc =>
      'Verkaufen Sie eine kleine Menge Medikamente';

  @override
  String get crimeDrugDealLargeName => 'Großer Drogendeal';

  @override
  String get crimeDrugDealLargeDesc =>
      'Verkaufen Sie eine große Menge Medikamente';

  @override
  String get crimeExtortionName => 'Erpressung';

  @override
  String get crimeExtortionDesc => 'Erpressen Sie Geld von lokalen Unternehmen';

  @override
  String get crimeKidnappingName => 'Entführung';

  @override
  String get crimeKidnappingDesc =>
      'Jemanden entführen, um Lösegeld zu erpressen';

  @override
  String get crimeArsonName => 'Brandstiftung';

  @override
  String get crimeArsonDesc => 'Ein Gebäude in Brand setzen';

  @override
  String get crimeSmugglingName => 'Schmuggel';

  @override
  String get crimeSmugglingDesc => 'Waren über die Grenze schmuggeln';

  @override
  String get crimeAssassinationName => 'Ermordung';

  @override
  String get crimeAssassinationDesc => 'Führen Sie einen Auftragsmord durch';

  @override
  String get crimeHackAccountName => 'Hack-Konto';

  @override
  String get crimeHackAccountDesc => 'Hacken Sie ein Bankkonto';

  @override
  String get crimeCounterfeitMoneyName => 'Falschgeld';

  @override
  String get crimeCounterfeitMoneyDesc => 'Verdienen Sie Falschgeld';

  @override
  String get crimeIdentityTheftName => 'Identitätsdiebstahl';

  @override
  String get crimeIdentityTheftDesc =>
      'Die Identität einer Person wegen Betrugs stehlen';

  @override
  String get crimeRobArmoredTruckName =>
      'Überfall auf einen gepanzerten Lastwagen';

  @override
  String get crimeRobArmoredTruckDesc => 'Raub einen gepanzerten Lastwagen aus';

  @override
  String get crimeArtTheftName => 'Kunstdiebstahl';

  @override
  String get crimeArtTheftDesc => 'Stehlen Sie wertvolle Kunstwerke';

  @override
  String get crimeProtectionRacketName => 'Schutzschläger';

  @override
  String get crimeProtectionRacketDesc =>
      'Lassen Sie Unternehmen Schutzgelder zahlen';

  @override
  String get crimeCasinoHeistName => 'Casino-Überfall';

  @override
  String get crimeCasinoHeistDesc => 'Ein Casino ausrauben';

  @override
  String get crimeBankRobberyName => 'Bankraub';

  @override
  String get crimeBankRobberyDesc => 'Eine Bank ausrauben';

  @override
  String get crimeStealYachtName => 'Yacht stehlen';

  @override
  String get crimeStealYachtDesc => 'Stehlen Sie eine Luxusyacht';

  @override
  String get crimeCorruptOfficialName => 'Bestechungsbeamter';

  @override
  String get crimeCorruptOfficialDesc =>
      'Bestechen Sie einen Beamten für einen Gefallen';

  @override
  String get tooltipCrimeRequiresTools => 'Erforderliche Werkzeuge';

  @override
  String get tooltipCrimeRequiresVehicle => 'Fahrzeug erforderlich';

  @override
  String get tooltipCrimeRequiresDrugs => 'Medikamente erforderlich';

  @override
  String get tooltipCrimeHighValue => 'Hochwertiger Betrieb';

  @override
  String get tooltipCrimeRequiresViolence => 'Gewalt erforderlich';

  @override
  String crimeErrorDrugsRequired(String quantity, String drugs) {
    return 'Sie benötigen mindestens ${quantity}g von: $drugs';
  }

  @override
  String get jobs => 'Jobs';

  @override
  String get errorLoadingJobs => 'Jobs konnten nicht geladen werden';

  @override
  String get jobNewspaperDeliveryName => 'Zeitungszustellung';

  @override
  String get jobNewspaperDeliveryDesc =>
      'Liefern Sie Zeitungen früh am Morgen aus';

  @override
  String get jobCarWashName => 'Waschanlage';

  @override
  String get jobCarWashDesc => 'Autos in der Autowaschanlage waschen';

  @override
  String get jobGroceryBaggerName => 'Lebensmitteleinpacker';

  @override
  String get jobGroceryBaggerDesc => 'Lagerregale im Supermarkt';

  @override
  String get jobDishwasherName => 'Spülmaschine';

  @override
  String get jobDishwasherDesc => 'Geschirr in einem Restaurant spülen';

  @override
  String get jobStreetSweeperName => 'Straßenfeger';

  @override
  String get jobStreetSweeperDesc => 'Fegen Sie die Straßen sauber';

  @override
  String get jobPizzaDeliveryName => 'Pizza-Lieferung';

  @override
  String get jobPizzaDeliveryDesc => 'Liefern Sie Pizzen in der Stadt';

  @override
  String get jobTaxiDriverName => 'Taxifahrer';

  @override
  String get jobTaxiDriverDesc => 'Fahren Sie mit dem Taxi durch die Stadt';

  @override
  String get jobWarehouseWorkerName => 'Lagerarbeiter';

  @override
  String get jobWarehouseWorkerDesc => 'Arbeite in einem Lager';

  @override
  String get jobConstructionWorkerName => 'Bauarbeiter';

  @override
  String get jobConstructionWorkerDesc => 'Arbeiten Sie auf einer Baustelle';

  @override
  String get jobBartenderName => 'Barfrau';

  @override
  String get jobBartenderDesc => 'Bier einschenken und Cocktails mixen';

  @override
  String get jobSecurityGuardName => 'Sicherheitsbeamter';

  @override
  String get jobSecurityGuardDesc => 'Bewachen Sie ein Gebäude';

  @override
  String get jobTruckDriverName => 'LKW-Fahrer';

  @override
  String get jobTruckDriverDesc => 'Fahren Sie einen LKW über weite Strecken';

  @override
  String get jobMechanicName => 'Mechanikerin';

  @override
  String get jobMechanicDesc => 'Reparieren Sie Autos in einer Garage';

  @override
  String get jobElectricianName => 'Elektrikerin';

  @override
  String get jobElectricianDesc =>
      'Elektrische Anlagen installieren und reparieren';

  @override
  String get jobPlumberName => 'Klempnerin';

  @override
  String get jobPlumberDesc => 'Reparieren Sie Rohre und Rohrleitungen';

  @override
  String get jobChefName => 'Köchin';

  @override
  String get jobChefDesc => 'Kochen Sie in einem Restaurant';

  @override
  String get jobParamedicName => 'Sanitäterin';

  @override
  String get jobParamedicDesc => 'Helfen Sie Menschen in Not';

  @override
  String get jobProgrammerName => 'Programmiererin';

  @override
  String get jobProgrammerDesc => 'Schreiben Sie Software für Unternehmen';

  @override
  String get jobAccountantName => 'Buchhalterin';

  @override
  String get jobAccountantDesc => 'Verwalten Sie die Finanzen für Unternehmen';

  @override
  String get jobLawyerName => 'Rechtsanwältin';

  @override
  String get jobLawyerDesc => 'Verteidigen Sie Mandanten vor Gericht';

  @override
  String get jobRealEstateAgentName => 'Immobilienmakler';

  @override
  String get jobRealEstateAgentDesc => 'Verkaufen Sie Häuser und Gebäude';

  @override
  String get jobStockbrokerName => 'Börsenmaklerin';

  @override
  String get jobStockbrokerDesc => 'Handeln Sie mit Aktien';

  @override
  String get jobDoctorName => 'Ärztin';

  @override
  String get jobDoctorDesc => 'Behandeln Sie Patienten im Krankenhaus';

  @override
  String get jobAirlinePilotName => 'Pilotin';

  @override
  String get jobAirlinePilotDesc => 'Fliegen Sie Passagierflugzeuge';

  @override
  String get travel => 'Reisen';

  @override
  String get errorLoadingCountries => 'Länder konnten nicht geladen werden';

  @override
  String get currentLocation => 'Aktueller Standort';

  @override
  String get current => 'Aktuell';

  @override
  String get travelTo => 'Reisen';

  @override
  String travelCost(String amount) {
    return 'Kosten: $amount €';
  }

  @override
  String get travelJourneyTitle => 'Reise beginnen?';

  @override
  String get travelRouteLabel => 'Route:';

  @override
  String travelLegsLabel(String count) {
    return 'Beine: $count';
  }

  @override
  String travelCostPerLeg(String amount) {
    return 'Kosten pro Strecke: $amount';
  }

  @override
  String travelTotalCost(String amount) {
    return 'Gesamtkosten: $amount';
  }

  @override
  String travelCooldownPerLeg(String minutes) {
    return 'Abklingzeit: $minutes Min. pro Bein';
  }

  @override
  String get travelRiskPerLeg =>
      'Risiko: pro Bein (kann eingesperrt werden und alle Waren verlieren)';

  @override
  String get travelStart => 'Start';

  @override
  String travelInTransitTo(String country) {
    return 'Auf dem Weg nach $country';
  }

  @override
  String travelLegProgress(String current, String total) {
    return 'Bein $current/$total';
  }

  @override
  String travelNextStop(String country) {
    return 'Nächster Halt: $country';
  }

  @override
  String get travelContinue => 'Weitermachen';

  @override
  String get travelCancelJourney => 'Reise abbrechen';

  @override
  String get travelJourneyCanceled => 'Reise abgesagt';

  @override
  String get travelDirect => 'Direkt';

  @override
  String travelVia(String countries) {
    return 'über $countries';
  }

  @override
  String travelLegsCount(String count) {
    return '$count Beine';
  }

  @override
  String jailRemainingMinutes(String minutes) {
    return 'Du bist noch $minutes Minuten im Gefängnis';
  }

  @override
  String travelSuccessTo(String country) {
    return 'Bin nach $country gereist!';
  }

  @override
  String travelConfiscated(String quantity, String item) {
    return '🚨 $quantity Gegenstände $item beschlagnahmt!';
  }

  @override
  String travelDamaged(String item, String percent) {
    return '⚠️ $item beschädigt ($percent% Wertverlust)!';
  }

  @override
  String get countryNetherlands => 'Niederlande';

  @override
  String get countryBelgium => 'Belgien';

  @override
  String get countryGermany => 'Deutschland';

  @override
  String get countryFrance => 'Frankreich';

  @override
  String get countrySpain => 'Spanien';

  @override
  String get countryItaly => 'Italien';

  @override
  String get countryUk => 'Vereinigtes Königreich';

  @override
  String get countrySwitzerland => 'Schweiz';

  @override
  String get crew => 'Crew';

  @override
  String get profile => 'Profil';

  @override
  String get logout => 'Abmelden';

  @override
  String get logOut => 'Abmelden';

  @override
  String get menu => 'Speisekarte';

  @override
  String get account => 'Konto';

  @override
  String get messages => 'Nachrichten';

  @override
  String get helpAndGuide => 'Hilfe und Anleitung';

  @override
  String get quickActions => 'Schnelle Aktionen';

  @override
  String get liveEvents => 'Live-Events';

  @override
  String get support => 'Unterstützung';

  @override
  String get events => 'Veranstaltungen';

  @override
  String get aviation => 'Luftfahrt';

  @override
  String get premiumAndCredits => 'Prämie und Credits';

  @override
  String get bank => 'Bank';

  @override
  String get tradeGoods => 'Handelswaren';

  @override
  String get drugs => 'Drogen';

  @override
  String get nightclub => 'Nachtclub';

  @override
  String get crypto => 'Krypto';

  @override
  String get smuggling => 'Schmuggel';

  @override
  String get tools => 'Werkzeuge';

  @override
  String get vehicleHeist => 'Fahrzeugraub';

  @override
  String get tuneShop => 'Tune-Shop';

  @override
  String get territory => 'Gebiet';

  @override
  String get achievements => 'Erfolge';

  @override
  String get menuCrackVault => 'Knacke den Tresor';

  @override
  String get quickActionsCrimesSubtitle => 'Straftaten begehen';

  @override
  String get quickActionsVehicleHeistSubtitle => 'Auto, Motorrad und Boot';

  @override
  String get quickActionsTuneShopSubtitle => 'Teile und Upgrades';

  @override
  String get quickActionsEventsSubtitle =>
      'Aktive und bevorstehende Veranstaltungen';

  @override
  String get quickActionsJobsSubtitle => 'Verdienen Sie legal Geld';

  @override
  String get quickActionsCasinoSubtitle => 'Setzen Sie Ihr Geld aufs Spiel';

  @override
  String get quickActionsBankSubtitle => 'Verwalten Sie Ihr globales Guthaben';

  @override
  String money(String amount) {
    return '$amount €';
  }

  @override
  String get health => 'Gesundheit';

  @override
  String get rank => 'Rang';

  @override
  String get xp => 'XP';

  @override
  String get settings => 'Einstellungen';

  @override
  String get avatar => 'Avatar';

  @override
  String get avatarUpdated => 'Avatar aktualisiert!';

  @override
  String error(String error) {
    return 'Fehler: $error';
  }

  @override
  String get changeLanguage => 'Sprache / Taal';

  @override
  String get languageChanged => 'Die Sprache wurde auf Englisch geändert';

  @override
  String languageChangeFailed(String code) {
    return 'Sprachänderung fehlgeschlagen ($code)';
  }

  @override
  String get chooseLanguage => 'Wählen Sie Sprache / Taal Kiezen';

  @override
  String get dutch => 'Niederlande';

  @override
  String get english => 'Englisch';

  @override
  String get cancel => 'Stornieren';

  @override
  String get changeUsername => 'Benutzernamen ändern';

  @override
  String get usernameHint => '3-20 Zeichen';

  @override
  String get change => 'Ändern';

  @override
  String get minChars => 'Mindestens 3 Zeichen';

  @override
  String get usernameUpdated => 'Benutzername aktualisiert!';

  @override
  String get usernameTaken => 'Benutzername bereits vergeben';

  @override
  String get oncePerMonth => 'Wechsel einmal im Monat';

  @override
  String get privacy => 'Privatsphäre';

  @override
  String get allowMessages => 'Nachrichten zulassen';

  @override
  String get allowMessagesDesc =>
      'Andere Spieler können dir Nachrichten senden';

  @override
  String get settingsSaved => 'Einstellungen gespeichert';

  @override
  String get vipStatus => 'VIP-Status';

  @override
  String activeUntil(String date) {
    return 'Aktiv bis $date';
  }

  @override
  String get unknown => 'Unbekannt';

  @override
  String get chooseAvatar => 'Wähle einen Avatar';

  @override
  String get freeAvatars => 'Kostenlose Avatare';

  @override
  String get vipAvatars => 'VIP-Avatare';

  @override
  String get vip => 'VIP';

  @override
  String get notLoggedIn => 'Nicht angemeldet';

  @override
  String get refresh => 'Aktualisieren';

  @override
  String get foodAndDrink => 'Essen & Trinken';

  @override
  String get invalidItem => 'Dieser Artikel existiert nicht';

  @override
  String get foodBroodje => 'Sandwich';

  @override
  String get foodPizza => 'Pizza';

  @override
  String get foodBurger => 'Burger';

  @override
  String get foodSteak => 'Steak';

  @override
  String get drinkWater => 'Wasser';

  @override
  String get drinkSoda => 'Soda';

  @override
  String get drinkCoffee => 'Kaffee';

  @override
  String get drinkBeer => 'Bier';

  @override
  String get foodInfo3 =>
      '• Kaufen Sie Essen und Trinken, um Ihre Werte aufrechtzuerhalten';

  @override
  String get friends => 'Freundinnen';

  @override
  String get friendActivity => 'Freundesaktivität';

  @override
  String get properties => 'Eigenschaften';

  @override
  String get propertiesAvailable => 'Verfügbar';

  @override
  String get myProperties => 'Meine Eigenschaften';

  @override
  String get errorLoadingMyProperties =>
      'Fehler beim Laden meiner Eigenschaften';

  @override
  String get errorBuyingProperty => 'Fehler beim Immobilienkauf';

  @override
  String get errorCollectingIncome => 'Fehler beim Sammeln der Einkünfte';

  @override
  String get noAvailableProperties => 'Keine verfügbaren Eigenschaften';

  @override
  String get noOwnedProperties => 'Sie besitzen noch keine Immobilien';

  @override
  String get buyFirstPropertyHint =>
      'Kaufen Sie Ihre erste Immobilie im Reiter „Verfügbar“.';

  @override
  String buyPropertyConfirm(String name, String price) {
    return 'Möchten Sie $name für $price € kaufen?';
  }

  @override
  String get propertyPrice => 'Preis';

  @override
  String get propertyMinLevel => 'Erforderliches Niveau';

  @override
  String get propertyIncomePerHour => 'Einkommen/Stunde';

  @override
  String get propertyMaxLevel => 'Maximales Level';

  @override
  String get propertyUniquePerCountry => '⚠️ Einzigartig – 1 pro Land';

  @override
  String get propertyIncomeReady => '✅ Einkommen zum Sammeln bereit!';

  @override
  String propertyNextIncome(String duration) {
    return '⏱️ Nächstes Einkommen in $duration';
  }

  @override
  String get propertyBuyAction => 'Immobilien kaufen';

  @override
  String get propertyCollectAction => 'Sammeln';

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
    return '${hours}h ${minutes}m';
  }

  @override
  String durationMinutes(String minutes) {
    return '${minutes}m';
  }

  @override
  String get propertyTypeHouse => 'Haus';

  @override
  String get propertyTypeWarehouse => 'Lager';

  @override
  String get propertyTypeCasino => 'Kasino';

  @override
  String get propertyTypeHotel => 'Hotel';

  @override
  String get propertyTypeFactory => 'Fabrik';

  @override
  String get propertyTypeBusiness => 'Geschäft';

  @override
  String get propertyCasinoName => 'Kasino';

  @override
  String get propertyWarehouseName => 'Lager';

  @override
  String get propertyNightclubName => 'Nachtclub';

  @override
  String get propertyHouseName => 'Haus';

  @override
  String get propertyApartmentName => 'Wohnung';

  @override
  String get propertyShopName => 'Geschäft';

  @override
  String get blackMarket => 'Schwarzmarkt';

  @override
  String get garage => 'Garage';

  @override
  String get garageCapacity => 'Garagenkapazität';

  @override
  String garageVehiclesCount(String current, String total) {
    return '$current / $total Fahrzeuge';
  }

  @override
  String garageUpgradeWithCost(String cost) {
    return 'Upgrade (€$cost)';
  }

  @override
  String get garageMaxLevel => 'Maximales Level';

  @override
  String garageLevelRemaining(String level, String spots) {
    return 'Stufe $level | $spots Plätze frei';
  }

  @override
  String get noCarsInGarage => 'Keine Autos in Ihrer Garage';

  @override
  String get stealCarsToStart => 'Stehlen Sie ein paar Autos, um loszulegen!';

  @override
  String get stealFailed => 'Der Diebstahl ist fehlgeschlagen';

  @override
  String get garageUpgradeFailed =>
      'Die Garage konnte nicht aktualisiert werden';

  @override
  String get saleFailed => 'Der Verkauf ist fehlgeschlagen';

  @override
  String get vehicleTransported => 'Fahrzeug erfolgreich transportiert!';

  @override
  String get vehicleTransportFailed => 'Transport des Fahrzeugs fehlgeschlagen';

  @override
  String get listOnMarket => 'Liste auf dem Markt';

  @override
  String marketValue(String amount) {
    return 'Marktwert: $amount';
  }

  @override
  String get askingPrice => 'Angebotspreis (€)';

  @override
  String get enterPrice => 'Geben Sie den Preis ein';

  @override
  String get list => 'Liste';

  @override
  String get invalidPrice => 'Ungültiger Preis';

  @override
  String get vehicleListed => 'Fahrzeug auf dem Markt gelistet!';

  @override
  String get listVehicleFailed => 'Fahrzeug konnte nicht aufgelistet werden';

  @override
  String get marina => 'Yachthafen';

  @override
  String get hospital => 'Krankenhaus';

  @override
  String get court => 'Gericht';

  @override
  String get casino => 'Kasino';

  @override
  String get errorLoadingCasinoStatus =>
      'Der Casino-Status konnte nicht überprüft werden';

  @override
  String get errorLoadingCasinoGames =>
      'Casinospiele konnten nicht geladen werden';

  @override
  String casinoPrice(String amount) {
    return 'Preis: $amount €';
  }

  @override
  String get startingCapital => 'Startkapital';

  @override
  String get bankrollHelper => 'Dies wird das Casino-Guthaben sein';

  @override
  String get casinoOwnershipInfoTitle => 'Über Casino-Besitz:';

  @override
  String get casinoClosedTitle => 'CASINO GESCHLOSSEN';

  @override
  String get casinoOwnedByLabel => 'Dieses Casino gehört:';

  @override
  String get casinoNoOwner => 'Dieses Casino hat noch keinen Besitzer';

  @override
  String get casinoPurchasePriceLabel => 'Kaufpreis:';

  @override
  String get casinoOwnerInfo =>
      'Als Eigentümer verwalten Sie das Casino-Guthaben und verdienen Geld, wenn Spieler verlieren!';

  @override
  String get casinoGameSlotsName => 'Spielautomat';

  @override
  String get casinoGameSlotsDesc =>
      'Drehen Sie die Walzen und gewinnen Sie bis zum 100-fachen Ihres Einsatzes!';

  @override
  String get casinoGameBlackjackName => 'Blackjack';

  @override
  String get casinoGameBlackjackDesc =>
      'Schlagen Sie den Dealer und gewinnen Sie bis zum Doppelten Ihres Einsatzes!';

  @override
  String get casinoGameRouletteName => 'Roulette';

  @override
  String get casinoGameRouletteDesc =>
      'Wählen Sie Ihre Zahl und gewinnen Sie bis zum 35-fachen Ihres Einsatzes!';

  @override
  String get casinoGameDiceName => 'Würfel';

  @override
  String get casinoGameDiceDesc =>
      'Lassen Sie die Würfel rollen und gewinnen Sie bis zum 6-fachen Ihres Einsatzes!';

  @override
  String get difficultyEasy => 'EINFACH';

  @override
  String get difficultyMedium => 'MEDIUM';

  @override
  String get difficultyHard => 'HART';

  @override
  String get casinoDepositTitle => 'Geld einzahlen';

  @override
  String get casinoWithdrawTitle => 'Geld abheben';

  @override
  String get amount => 'Menge';

  @override
  String get deposit => 'Kaution';

  @override
  String get withdraw => 'Zurückziehen';

  @override
  String casinoDepositSuccess(String amount) {
    return '$amount € auf das Casino-Guthaben eingezahlt';
  }

  @override
  String casinoWithdrawSuccess(String amount) {
    return '$amount € vom Casino-Guthaben abgehoben';
  }

  @override
  String get casinoDepositError => 'Fehler beim Einzahlen';

  @override
  String get casinoWithdrawError => 'Fehler beim Zurückziehen';

  @override
  String get casinoMinBankroll =>
      'Es müssen mindestens 10.000 € auf dem Guthaben verbleiben';

  @override
  String casinoMaxWithdraw(String amount) {
    return 'Maximal: $amount €';
  }

  @override
  String get casinoManagementTitle => 'Casino-Management';

  @override
  String casinoBankruptWarning(String amount) {
    return 'ACHTUNG: Casino-Guthaben zu niedrig! \nZahlen Sie mindestens $amount € ein, um eine Insolvenz zu vermeiden.';
  }

  @override
  String get casinoBankroll => 'Casino-Bankroll';

  @override
  String get casinoStatsTitle => 'Statistiken';

  @override
  String get casinoTotalReceived => 'Insgesamt erhalten:';

  @override
  String get casinoTotalPaidOut => 'Gesamtauszahlung:';

  @override
  String get casinoNetProfit => 'Reingewinn:';

  @override
  String casinoProfitMargin(String percent) {
    return 'Gewinnspanne: $percent%';
  }

  @override
  String get casinoManagementInfoTitle => 'Informationen zur Casino-Verwaltung';

  @override
  String get casinoManagementInfo5 =>
      '• Sie können jederzeit Geld einzahlen oder abheben';

  @override
  String get retry => 'Wiederholen';

  @override
  String get doAction => 'Tun';

  @override
  String get pay => 'Zahlen';

  @override
  String get success => 'Erfolg';

  @override
  String get jail => 'Gefängnis';

  @override
  String get wantedLevel => 'Gesuchtes Level';

  @override
  String get cooldown => 'Abklingzeit';

  @override
  String get requiredRank => 'Erforderlicher Spielerrang';

  @override
  String get playerRankLabel => 'Spielerrang';

  @override
  String get loading => 'Laden...';

  @override
  String get trade => 'Handel';

  @override
  String get buy => 'Kaufen';

  @override
  String get sell => 'Verkaufen';

  @override
  String get price => 'Preis';

  @override
  String get total => 'Gesamt';

  @override
  String available(String count) {
    return 'Verfügbar: $count';
  }

  @override
  String get notEnoughMoney => 'Du hast nicht genug Geld!';

  @override
  String get confirm => 'Bestätigen';

  @override
  String get close => 'Schließen';

  @override
  String get unexpectedResponse => 'Unerwartete API-Antwort';

  @override
  String get errorLoadingMenu => 'Fehler beim Laden des Menüs';

  @override
  String get unknownError => 'Unbekannter Fehler';

  @override
  String get food => 'Essen';

  @override
  String get drink => 'Trinken';

  @override
  String get work => 'Arbeiten';

  @override
  String cooldownMinutes(String minutes) {
    return 'Abklingzeit: $minutes Min';
  }

  @override
  String xpReward(String amount) {
    return 'XP: +$amount';
  }

  @override
  String get fly => 'Fliegen';

  @override
  String get purchased => 'Gekauft!';

  @override
  String get sold => 'Verkauft!';

  @override
  String get errorBuying => 'Fehler beim Kauf';

  @override
  String get errorSelling => 'Fehler beim Verkauf';

  @override
  String get goods => 'Waren';

  @override
  String get marketplace => 'Marktplatz';

  @override
  String get myListings => 'Meine Einträge';

  @override
  String get inventory => 'Inventar';

  @override
  String get vehicles => 'Fahrzeuge';

  @override
  String get backpacks => 'Rucksäcke';

  @override
  String get materials => 'Materialien';

  @override
  String get production => 'Produktion';

  @override
  String get stock => 'Aktie';

  @override
  String get retryAgain => 'Wiederholen';

  @override
  String get noVehiclesAvailable => 'Keine Fahrzeuge verfügbar';

  @override
  String get noListings => 'Keine Einträge';

  @override
  String get condition => 'Zustand';

  @override
  String get yourHealth => 'Ihre Gesundheit';

  @override
  String get criticalHealthWarning =>
      '⚠️ KRITISCH! Sie müssen sofort ins Krankenhaus gehen!';

  @override
  String get lowHealthWarning => '⚠️ Geringe Gesundheit! Seien Sie vorsichtig.';

  @override
  String get free => 'FREI';

  @override
  String get information => 'Information';

  @override
  String get contrabandFlowersName => 'Blumen';

  @override
  String get contrabandFlowersDesc =>
      'Niederländische Tulpen und andere Blumen für den internationalen Handel';

  @override
  String get contrabandElectronicsName => 'Elektronik';

  @override
  String get contrabandElectronicsDesc =>
      'Fortschrittliche Elektronik- und Computerkomponenten';

  @override
  String get contrabandDiamondsName => 'Diamanten';

  @override
  String get contrabandDiamondsDesc =>
      'Rohdiamanten und geschliffene Diamanten';

  @override
  String get contrabandWeaponsName => 'Waffen';

  @override
  String get contrabandWeaponsDesc => 'Illegale Waffen und Munition';

  @override
  String get contrabandPharmaceuticalsName => 'Arzneimittel';

  @override
  String get contrabandPharmaceuticalsDesc =>
      'Seltene pharmazeutische Produkte';

  @override
  String get multiplier => 'Multiplikator';

  @override
  String get sellPrice => 'Verkaufspreis';

  @override
  String get boughtFor => 'Gekauft für';

  @override
  String get profit => 'Profitieren';

  @override
  String get loss => 'Verlust';

  @override
  String ownedQuantity(String quantity) {
    return 'Besitz: $quantity';
  }

  @override
  String spoilsInHours(String hours) {
    return '⚠️ Verwöhnt in ${hours}h';
  }

  @override
  String get spoiledWorthless => '💀 VERWÖHNT – Wertlos';

  @override
  String get vehicleBought => 'Fahrzeug erfolgreich gekauft!';

  @override
  String get purchaseFailed => 'Der Kauf ist fehlgeschlagen';

  @override
  String get listingRemoved => 'Eintrag entfernt';

  @override
  String get noItemsInInventory => 'Keine Artikel im Inventar';

  @override
  String get buyItemsInBuyTab =>
      'Kaufen Sie Artikel auf der Registerkarte „Kaufen“.';

  @override
  String errorLoadingMarketData(String error) {
    return 'Fehler beim Laden der Marktdaten: $error';
  }

  @override
  String get appeal => 'Appellieren';

  @override
  String get submitAppeal => 'Einspruch einreichen';

  @override
  String get bribeJudge => 'Bestechungsrichter';

  @override
  String get bribe => 'Bestechen';

  @override
  String get treated => 'Behandelt!';

  @override
  String healthRestored(String hp, String cost) {
    return '+$hp HP für $cost €';
  }

  @override
  String get treatmentOptions => 'Behandlungsmöglichkeiten';

  @override
  String get youAreDead => 'Du bist tot! Spiel vorbei.';

  @override
  String get emergencyOnly => 'Notfallbehandlung nur unter 10 PS möglich';

  @override
  String emergencyTreatment(String hp) {
    return 'Notfallbehandlung! Kostenlos +$hp HP';
  }

  @override
  String get byValue => 'Nach Wert';

  @override
  String get byCondition => 'Nach Bedingung';

  @override
  String get byFuel => 'Durch Treibstoff';

  @override
  String get byName => 'Mit Namen';

  @override
  String get stealCar => 'Auto stehlen';

  @override
  String get stealBoat => 'Boot stehlen';

  @override
  String get sellVehicle => 'Fahrzeug verkaufen';

  @override
  String get sellBoat => 'Boot verkaufen';

  @override
  String get confirmSellVehicle =>
      'Sind Sie sicher, dass Sie dieses Fahrzeug verkaufen möchten?';

  @override
  String get confirmSellBoat =>
      'Sind Sie sicher, dass Sie dieses Boot verkaufen möchten?';

  @override
  String get carStolen => 'Auto erfolgreich gestohlen!';

  @override
  String get boatStolen => 'Boot erfolgreich gestohlen!';

  @override
  String get vehicleTypeCar => 'Auto';

  @override
  String get vehicleTypeBoat => 'Boot';

  @override
  String stolenVehicleTitle(String vehicleType) {
    return '$vehicleType gestohlen!';
  }

  @override
  String unknownVehicleType(String vehicleType) {
    return 'Unbekannt $vehicleType';
  }

  @override
  String get vehicleStatSpeed => 'Geschwindigkeit';

  @override
  String get vehicleStatFuel => 'Kraftstoff';

  @override
  String get vehicleStatCargo => 'Ladung';

  @override
  String get vehicleStatStealth => 'Heimlichkeit';

  @override
  String get continueAction => 'Weitermachen';

  @override
  String get vehicleSold => 'Fahrzeug erfolgreich verkauft!';

  @override
  String get boatSold => 'Boot erfolgreich verkauft!';

  @override
  String get garageUpgraded => 'Garage modernisiert!';

  @override
  String get marinaUpgraded => 'Marina wurde erfolgreich aktualisiert!';

  @override
  String get marinaCapacity => 'Kapazität des Yachthafens';

  @override
  String marinaBoatsCount(String current, String total) {
    return '$current / $total Boote';
  }

  @override
  String marinaUpgradeWithCost(String cost) {
    return 'Upgrade (€$cost)';
  }

  @override
  String get marinaMaxLevel => 'Maximales Level';

  @override
  String marinaLevelRemaining(String level, String remaining) {
    return 'Stufe $level | $remaining Plätze frei';
  }

  @override
  String get noBoatsInMarina => 'Keine Boote in Ihrem Yachthafen';

  @override
  String get stealBoatsToStart => 'Stehlen Sie ein paar Boote, um loszulegen!';

  @override
  String get marinaUpgradeFailed =>
      'Das Upgrade des Jachthafens ist fehlgeschlagen';

  @override
  String get boatShipped => 'Boot erfolgreich versendet!';

  @override
  String get boatShipFailed => 'Die Bootsschifffahrt scheiterte';

  @override
  String get buyProperty => 'Immobilien kaufen';

  @override
  String propertyBought(String name) {
    return '$name gekauft!';
  }

  @override
  String propertyUpgraded(String level) {
    return 'Eigentum auf Level $level aufgewertet!';
  }

  @override
  String get errorLoadingProperties => 'Fehler beim Laden der Eigenschaften';

  @override
  String get errorUpgrading => 'Fehler beim Upgrade';

  @override
  String networkError(String error) {
    return 'Netzwerkfehler: $error';
  }

  @override
  String get unknownResponse => 'Unbekannte Antwort';

  @override
  String incomeCollected(String amount) {
    return '$amount € gesammelt!';
  }

  @override
  String get buyCasino => 'Casino kaufen';

  @override
  String get manageCasino => 'Casino verwalten';

  @override
  String get casinoBought => 'Casino erfolgreich gekauft! 🎰';

  @override
  String get errorBuyCasino =>
      'Beim Kauf des Casinos ist ein Fehler aufgetreten';

  @override
  String minimumDeposit(String amount) {
    return 'Die Mindesteinzahlung beträgt $amount €';
  }

  @override
  String get casinoInfo1 => 'Die Spieler wetten gegen das Casino-Guthaben';

  @override
  String get casinoInfo2 => 'Gewinne werden aus dem Guthaben ausgezahlt';

  @override
  String get casinoInfo3 => 'Sie können Geld einzahlen und abheben';

  @override
  String get casinoInfo4 => 'Mindestens 10.000 € Guthaben erforderlich';

  @override
  String get casinoInfo5 => 'Darunter: Insolvenz';

  @override
  String get members => 'Mitglieder';

  @override
  String get location => 'Standort';

  @override
  String get level => 'Ebene';

  @override
  String get alreadyFullHealth => 'Sie sind bereits bei bester Gesundheit!';

  @override
  String get errorTreatment => 'Fehler während der Behandlung';

  @override
  String waitMinutes(String minutes) {
    return 'Sie müssen $minutes weitere Minuten auf die nächste Behandlung warten!';
  }

  @override
  String get emergencyHelp => 'Notfallhilfe';

  @override
  String onlyNeedHp(String hp) {
    return '(Sie benötigen nur $hp HP)';
  }

  @override
  String get emergencyInfo =>
      '• 🊘 Notfallhilfe ist unter 10 HP (+20 HP) KOSTENLOS.';

  @override
  String get hospitalInfo1 =>
      '• Die Gesundheit nimmt ab, wenn man Straftaten begeht';

  @override
  String get hospitalInfo2 => '• Bei 0 HP können Sie keine Verbrechen begehen';

  @override
  String hospitalInfo3(String cost) {
    return '• Die Behandlung kostet $cost € pro Behandlungstermin';
  }

  @override
  String hospitalInfo4(String amount) {
    return '• Sie können maximal $amount HP pro Behandlung wiederherstellen';
  }

  @override
  String get hospitalInfo5 =>
      '• ⏱️ 1 Stunde Abklingzeit zwischen den Behandlungen';

  @override
  String get hospitalInfo6 =>
      '• 💚 Passive Heilung: +5 HP alle 5 Minuten (wenn HP > 0)';

  @override
  String get medicalTreatment => 'Medizinische Behandlung';

  @override
  String get restoreCritical => 'Stellt +20 HP wieder her (kritischer Zustand)';

  @override
  String restoreUp(String amount) {
    return 'Stellen Sie bis zu $amount HP wieder her';
  }

  @override
  String get cost => 'Kosten';

  @override
  String crimeErrorToolRequired(String tools) {
    return '⚒️ Für dieses Verbrechen benötigen Sie $tools';
  }

  @override
  String crimeErrorToolInStorage(String tools) {
    return '⚒️ Du hast $tools, aber es ist zu Hause! Gehen Sie zu Inventar → Übertragen';
  }

  @override
  String get crimeErrorVehicleRequired =>
      '🚗 Für dieses Verbrechen ist ein Fahrzeug erforderlich';

  @override
  String get crimeErrorVehicleNotFound => '🚗 Fahrzeug nicht gefunden';

  @override
  String get crimeErrorNotVehicleOwner => '🚗 Dieses Fahrzeug gehört dir nicht';

  @override
  String get crimeErrorVehicleBroken =>
      '🚗 Ihr Fahrzeug ist kaputt und muss repariert werden';

  @override
  String get crimeErrorNoFuel => '⛽ Ihr Fahrzeug hat keinen Kraftstoff';

  @override
  String get crimeErrorLevelTooLow =>
      '⭐ Dein Level ist für dieses Verbrechen zu niedrig';

  @override
  String get crimeErrorInvalidCrimeId => '❌ Ungültiges Verbrechen';

  @override
  String get crimeErrorWeaponRequired =>
      '🔫 Für dieses Verbrechen braucht man eine Waffe';

  @override
  String get crimeErrorWeaponBroken =>
      '🔫 Deine Waffe ist kaputt und muss repariert werden';

  @override
  String get crimeErrorNoAmmo => '🔫 Du hast keine Munition';

  @override
  String get crimeErrorGeneric =>
      '❌Bei diesem Verbrechen ist etwas schief gelaufen';

  @override
  String get inventoryFull =>
      '🎒 Ihr Inventar ist voll! Lagern Sie Werkzeuge in einer Immobilie';

  @override
  String get storageFull => '📦 Der Immobilienspeicher ist voll';

  @override
  String transferSuccess(String tool, String location) {
    return '✅ $tool verschoben nach $location';
  }

  @override
  String get carried => 'Getragen';

  @override
  String get storage => 'Lagerung';

  @override
  String get property => 'Eigentum';

  @override
  String inventorySlots(int used, int max) {
    return '$used / $max Steckplätze';
  }

  @override
  String get loadouts => 'Ladungen';

  @override
  String get createLoadout => 'Loadout erstellen';

  @override
  String get equipLoadout => 'Ausrüsten';

  @override
  String get loadoutEquipped => '✅ Loadout ausgestattet';

  @override
  String get loadoutMaxReached => '❌ Maximale Auslastung erreicht (5)';

  @override
  String loadoutMissingTools(String tools) {
    return '❌ Fehlende Werkzeuge: $tools';
  }

  @override
  String get backpackUpgrade => 'Rucksack-Upgrade';

  @override
  String get backpackBasic => 'Einfacher Rucksack (+5 Plätze)';

  @override
  String get backpackTactical => 'Taktische Weste (+10 Plätze)';

  @override
  String get backpackCargo => 'Cargohose (+3 Plätze)';

  @override
  String get upgradeInventory => 'Upgrade-Inventar';

  @override
  String get noToolsCarried => 'Kein Werkzeug mitgeführt';

  @override
  String get visitShopToBuyTools =>
      'Besuchen Sie den Shop, um Werkzeuge zu kaufen';

  @override
  String get noProperties => 'Keine Eigenschaften';

  @override
  String get buyPropertyForStorage =>
      'Kaufen Sie eine Immobilie zur Aufbewahrung von Werkzeugen';

  @override
  String get noToolsInStorage => 'Keine Werkzeuge im Lager';

  @override
  String get selectProperty => 'Eigenschaft auswählen';

  @override
  String get slotsRemaining => 'verbleibende Slots';

  @override
  String get noLoadouts => 'Keine Loadouts';

  @override
  String get createLoadoutToStart => 'Erstellen Sie ein Loadout, um loszulegen';

  @override
  String get deleteLoadout => 'Loadout löschen';

  @override
  String get confirmDeleteLoadout =>
      'Sind Sie sicher, dass Sie dieses Loadout löschen möchten?';

  @override
  String get loadoutDeleted => 'Loadout gelöscht';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get delete => 'Löschen';

  @override
  String get active => 'Aktiv';

  @override
  String get durability => 'Haltbarkeit';

  @override
  String get quantity => 'Menge';

  @override
  String get slotSize => 'Steckplatzgröße';

  @override
  String get repairCost => 'Reparaturkosten';

  @override
  String get wearPerUse => 'Tragen Sie es pro Gebrauch';

  @override
  String get loseChance => 'Chance zu verlieren';

  @override
  String get requiredFor => 'Erforderlich für';

  @override
  String get lowDurability => 'Geringe Haltbarkeit';

  @override
  String get transfer => 'Überweisen';

  @override
  String get toolDetails => 'Werkzeugdetails';

  @override
  String get transferTool => 'Übertragungstool';

  @override
  String get selectQuantity => 'Menge auswählen';

  @override
  String get destination => 'Ziel';

  @override
  String get from => 'Aus';

  @override
  String get to => 'Zu';

  @override
  String get editLoadout => 'Loadout bearbeiten';

  @override
  String get loadoutName => 'Loadout-Name';

  @override
  String get description => 'Beschreibung';

  @override
  String get optional => 'optional';

  @override
  String get selectedTools => 'Ausgewählte Werkzeuge';

  @override
  String get noToolsAvailable => 'Keine Werkzeuge vorhanden';

  @override
  String get create => 'Erstellen';

  @override
  String get save => 'Speichern';

  @override
  String get pleaseEnterName => 'Bitte geben Sie einen Namen ein';

  @override
  String get pleaseSelectTools => 'Bitte wählen Sie mindestens 1 Werkzeug aus';

  @override
  String get loadoutCreated => 'Loadout erstellt';

  @override
  String get loadoutUpdated => 'Ausrüstung aktualisiert';

  @override
  String get goToInventory => 'Gehen Sie zu Inventar';

  @override
  String get slots => 'Slots';

  @override
  String get backpackShop => 'Rucksackladen';

  @override
  String get yourBackpack => 'Dein Rucksack';

  @override
  String get availableUpgrades => 'Verfügbare Upgrades';

  @override
  String get otherBackpacks => 'Andere Rucksäcke';

  @override
  String get youHaveBestBackpack => 'Du hast den besten Rucksack!';

  @override
  String get backpackPurchased => 'Rucksack gekauft!';

  @override
  String get backpackUpgraded => 'Rucksack aufgewertet!';

  @override
  String get buyBackpack => 'Kaufen';

  @override
  String get upgradeBackpack => 'Upgrade';

  @override
  String get backpackPrice => 'Preis';

  @override
  String get extraSlots => 'Zusätzliche Steckplätze';

  @override
  String get totalSlots => 'Gesamtzahl der Slots';

  @override
  String get vipOnly => 'Nur VIP';

  @override
  String get tradeInValue => 'Eintauschwert';

  @override
  String get upgradeCost => 'Upgrade-Kosten';

  @override
  String rankRequired(Object rank) {
    return 'Rang $rank erforderlich';
  }

  @override
  String insufficientFunds(String needed, String have) {
    return 'Sie benötigen $needed €. Sie haben $have';
  }

  @override
  String get alreadyHasBackpack => 'Du hast bereits einen Rucksack';

  @override
  String get backpackNotFound => 'Rucksack nicht gefunden';

  @override
  String get playerNotFound => 'Spieler nicht gefunden';

  @override
  String get notAnUpgrade => 'Dies ist kein Upgrade';

  @override
  String backpackPurchasedEvent(Object name, Object slots) {
    return 'Sie haben $name gekauft! +$slots Slots.';
  }

  @override
  String backpackUpgradedEvent(Object newName, Object upgradeSlots) {
    return 'Auf $newName aktualisiert! +$upgradeSlots zusätzliche Slots.';
  }

  @override
  String get backpackPurchaseFailedNotFound => 'Rucksack nicht gefunden';

  @override
  String get backpackPurchaseFailedAlready =>
      'Du hast bereits einen Rucksack. Sie können jeweils nur eines verwenden.';

  @override
  String backpackPurchaseFailedRank(Object current, Object required) {
    return 'Sie benötigen Rang $required (Sie sind Rang $current)';
  }

  @override
  String backpackPurchaseFailedFunds(Object have, Object needed) {
    return 'Sie benötigen $needed €. Sie haben $have';
  }

  @override
  String get backpackPurchaseFailedVip =>
      'Dieser Rucksack ist nur für VIP-Mitglieder';

  @override
  String get backpackUpgradeFailedNo =>
      'Sie haben keinen Rucksack zum Aufrüsten';

  @override
  String get backpackUpgradeFailedNotUpgrade =>
      'Dies ist kein Upgrade. Wählen Sie einen größeren Rucksack.';

  @override
  String backpackUpgradeFailedRank(Object current, Object required) {
    return 'Sie benötigen Rang $required (Sie sind Rang $current)';
  }

  @override
  String backpackUpgradeFailedFunds(Object have, Object needed) {
    return 'Sie benötigen $needed €. Sie haben $have';
  }

  @override
  String get backpackUpgradeFailedVip =>
      'Dieser Rucksack ist nur für VIP-Mitglieder';

  @override
  String get arrested => 'Verhaftet!';

  @override
  String get jailMessage =>
      'Sie wurden während Ihrer Reise verhaftet und alle Waren wurden beschlagnahmt!';

  @override
  String get confirmAction => 'Bist du sicher?';

  @override
  String get yes => 'Ja';

  @override
  String get no => 'NEIN';

  @override
  String get ok => 'OK';

  @override
  String get travelContinueConfirmTitle =>
      'Mit der nächsten Etappe fortfahren?';

  @override
  String get travelContinueConfirmBody =>
      'Grenzkontrollen sind aktiv. Ihre Reise fortsetzen?';

  @override
  String get travelJourneyCompleteTitle => 'Reise abgeschlossen';

  @override
  String get travelJourneyCompleteBody => 'Sie haben Ihr Ziel sicher erreicht.';

  @override
  String get hitlist => 'Trefferliste';

  @override
  String hitlistLoadError(String error) {
    return 'Fehler beim Laden der Trefferliste: $error';
  }

  @override
  String get noActiveHits => 'Keine aktiven Treffer platziert';

  @override
  String get selectTarget => 'Wählen Sie Ziel aus';

  @override
  String get searchPlayer => 'Spieler suchen...';

  @override
  String get placeHitTitle => 'Platzieren Sie Treffer';

  @override
  String get minimumBounty => 'Mindestprämie: 50.000 €';

  @override
  String get bountyAmount => 'Kopfgeldbetrag';

  @override
  String get place => 'Ort';

  @override
  String hitPlaced(String amount) {
    return 'Treffer für ⟦0€⟧ platziert';
  }

  @override
  String hitError(String error) {
    return 'Fehler: $error';
  }

  @override
  String get hitDifferentCountry =>
      'Sie müssen sich im selben Land wie das Ziel befinden';

  @override
  String get counterBountyTitle => 'Platziere Gegenprämie';

  @override
  String minimumAmount(String amount) {
    return 'Mindestbetrag: $amount €';
  }

  @override
  String get counterBountyAmount => 'Betrag der Gegenprämie';

  @override
  String counterBountyPlaced(String amount) {
    return 'Gegenprämie von $amount € platziert';
  }

  @override
  String get cancelHitConfirmTitle => 'Treffer abbrechen?';

  @override
  String get cancelHitConfirmBody => 'Ihr Kopfgeld wird zurückerstattet.';

  @override
  String get hitCancelled => 'Treffer abgebrochen';

  @override
  String get target => 'Ziel';

  @override
  String get placer => 'Placer';

  @override
  String get bounty => 'Kopfgeld';

  @override
  String get counterBid => 'GEGENGEBOT';

  @override
  String get counterBidPlaced =>
      'Gegengebot abgegeben! Der Vertrag wurde rückgängig gemacht.';

  @override
  String get attemptHit => 'Trefferversuch';

  @override
  String get selectWeapon => 'Wählen Sie Waffe und Munition';

  @override
  String get youAreTargeted => 'Sie stehen auf der Abschussliste';

  @override
  String get security => 'Sicherheit';

  @override
  String get currentDefense => 'Aktuelle Verteidigung';

  @override
  String get totalDefense => 'Totale Verteidigung';

  @override
  String get currentArmor => 'Aktuelle Rüstung';

  @override
  String get bodyguards => 'Leibwächterinnen';

  @override
  String get buyBodyguards => 'Kaufen Sie Leibwächter';

  @override
  String get bodyguardPrice => 'Preis pro Bodyguard';

  @override
  String get armor => 'Rüstung';

  @override
  String get protectorsFollow => 'Beschützer, die dir folgen';

  @override
  String get eachGivesDefense => 'Jeder gibt +10 Verteidigung';

  @override
  String get lightArmor => 'Leichte Rüstung';

  @override
  String get basicProtection => 'Grundschutz';

  @override
  String get heavyArmor => 'Schwere Rüstung';

  @override
  String get strongProtection => 'Starker Schutz';

  @override
  String get bulletproofVest => 'Kugelsichere Weste';

  @override
  String get veryStrongProtection => 'Sehr starker Schutz';

  @override
  String get tacticalSuit => 'Taktisches Outfit';

  @override
  String get premiumProtection => 'Premium-Schutz';

  @override
  String get defense => 'Verteidigung';

  @override
  String defenseIncrease(String armor, String defense) {
    return 'Sie haben $armor gekauft! +$defense Verteidigung';
  }

  @override
  String get worn => 'Getragen';

  @override
  String get hit => 'SCHLAG';

  @override
  String get counterBidLabel => 'GEGENGEBOT';

  @override
  String daysAgo(String count, String plural) {
    return 'Vor $count Tag$plural';
  }

  @override
  String hoursAgo(String count) {
    return 'Vor $count Stunden';
  }

  @override
  String minutesAgo(String count) {
    return 'Vor $count Minuten';
  }

  @override
  String get justPlaced => 'Gerade platziert';

  @override
  String get youAreTheTarget => 'Du bist das Ziel';

  @override
  String get youAreThePlacer => 'Du bist der Placer';

  @override
  String get onlyTargetCanCounterBid =>
      'Nur das Ziel kann ein Gegengebot abgeben';

  @override
  String get executeHit => 'Treffer ausführen';

  @override
  String get moneyNotEnough => 'Du hast nicht genug Geld';

  @override
  String get securityScreen => 'Sicherheit';

  @override
  String get currentDefenseStatus => 'Aktueller Verteidigungsstatus';

  @override
  String get noWeapons => 'Sie haben keine Waffen in Ihrem Inventar';

  @override
  String get ammoQuantity => 'Munitionsmenge';

  @override
  String get noAmmoRequired =>
      'Für diese Waffe ist keine Munition erforderlich';

  @override
  String get weaponStats => 'Waffenstatistiken';

  @override
  String get damage => 'Schaden';

  @override
  String get intimidation => 'Einschüchterung';

  @override
  String get execute => 'Ausführen';

  @override
  String get hitExecuted => 'Treffer erfolgreich ausgeführt!';

  @override
  String get invalidAmmo => 'Bitte geben Sie eine gültige Munitionsmenge ein';

  @override
  String get weaponsMarket => 'Waffenmarkt';

  @override
  String get ammoMarket => 'Munitionsmarkt';

  @override
  String get shootingRange => 'Schießstand';

  @override
  String get ammoFactory => 'Munitionsfabrik';

  @override
  String get weaponShop => 'Waffenladen';

  @override
  String get myWeapons => 'Meine Waffen';

  @override
  String get weaponPurchased => 'Waffe gekauft';

  @override
  String weaponRankRequired(String rank) {
    return 'Erforderlicher Rang: $rank';
  }

  @override
  String get buyWeapon => 'Kaufen';

  @override
  String get ammoShop => 'Munitionsmarkt';

  @override
  String get myAmmo => 'Meine Munition';

  @override
  String get ammoPurchased => 'Munition gekauft';

  @override
  String get purchaseCooldown => 'Sie müssen mit dem nächsten Kauf warten';

  @override
  String get insufficientStock => 'Nicht genügend Lagerbestand vorhanden';

  @override
  String get maxInventoryReached => 'Maximale Lagerkapazität erreicht';

  @override
  String get invalidQuantity => 'Ungültige Menge';

  @override
  String get nextAmmoPurchase => 'Nächster Kauf verfügbar in';

  @override
  String get ammoBoxes => 'Boxen';

  @override
  String ammoRoundsPerBox(String rounds) {
    return '$rounds Runden pro Box';
  }

  @override
  String ammoYouWillReceive(String rounds) {
    return 'Sie erhalten: $rounds Runden';
  }

  @override
  String ammoTotalCost(String cost) {
    return 'Gesamtkosten: $cost';
  }

  @override
  String get ammoRounds => 'Runden';

  @override
  String get ammoBoxesUnit => 'Boxen';

  @override
  String get ammoStock => 'Aktie';

  @override
  String get ammoQuality => 'Qualität';

  @override
  String get factoryBought => 'Fabrik gekauft';

  @override
  String get factoryProduced => 'Produktion aktualisiert';

  @override
  String get factorySessionStarted =>
      'Produktion gestartet: 8 Stunden aktiv, Anspruch alle 10 Minuten';

  @override
  String get ammoFactoryTitle => 'Munitionsfabrik';

  @override
  String get ammoFactoryIntro =>
      'Produziert in Chargen; Sie beanspruchen alle 10 Minuten (bis zu 8 Stunden Rückstand pro Sitzung).';

  @override
  String get ammoFactoryWhatYouCanDo => 'Was Sie tun können:';

  @override
  String get ammoFactoryActionBuy =>
      'Kaufen Sie eine Fabrik in Ihrem aktuellen Land';

  @override
  String get ammoFactoryActionProduce =>
      'Anspruchserstellung (Intervall: 10 Minuten, maximaler Rückstand: 8 Stunden pro Sitzung)';

  @override
  String get ammoFactoryActionOutput =>
      'Verbessere die Leistung auf Stufe 5, um mehr Runden pro Anspruch zu erhalten';

  @override
  String get ammoFactoryActionQuality =>
      'Verbessern Sie die Qualität für höhere Marktpreise';

  @override
  String get factoryUpgradeOutputSuccess => 'Ausgabe aktualisiert';

  @override
  String get factoryUpgradeQualitySuccess => 'Qualität verbessert';

  @override
  String get myFactory => 'Meine Fabrik';

  @override
  String get noFactoryOwned => 'Sie besitzen keine Fabrik';

  @override
  String get factoryCountry => 'Land';

  @override
  String get factoryOutputLevel => 'Ausgangspegel';

  @override
  String get factoryQualityLevel => 'Qualitätsniveau';

  @override
  String get factoryLastProduced => 'Zuletzt produziert';

  @override
  String get factoryProduceStatusLabel => 'Produktionsstatus';

  @override
  String get factoryProduceStatusReady => 'Bereit';

  @override
  String get factoryProduceStatusCooldown => 'Abklingzeit';

  @override
  String get factorySessionActive =>
      'Produktionsfenster: aktiv (10-Minuten-Intervall)';

  @override
  String get factorySessionStopped =>
      'Produktionsfenster: gestoppt (klicken Sie auf „Produzieren“, um ein neues 8-Stunden-Fenster zu starten)';

  @override
  String factorySessionEndsIn(String duration) {
    return 'Fenster endet mit: $duration';
  }

  @override
  String get factoryNextProductionReady =>
      'Nächste Produktion: jetzt verfügbar (klicken Sie auf „Produzieren“, um Anspruch zu erheben)';

  @override
  String factoryNextProductionIn(String duration) {
    return 'Nächste Produktion in: $duration';
  }

  @override
  String get factoryProduce => 'Produzieren';

  @override
  String get factoryUpgradeOutput => 'Ausgabe aktualisieren';

  @override
  String get factoryUpgradeQuality => 'Qualität verbessern';

  @override
  String get factoryList => 'Fabriken nach Ländern';

  @override
  String get factoryUnowned => 'Verfügbar';

  @override
  String factoryOwnedBy(String owner) {
    return 'Besitzer: $owner';
  }

  @override
  String get factoryBuy => 'Kaufen';

  @override
  String get shootingTrainSuccess => 'Ausbildung abgeschlossen';

  @override
  String shootingSessions(String count) {
    return 'Sitzungen: $count/100';
  }

  @override
  String shootingAccuracyBonus(String bonus) {
    return 'Genauigkeitsbonus: $bonus%';
  }

  @override
  String shootingCooldown(String time) {
    return 'Nächste Sitzung um $time';
  }

  @override
  String get shootingTrain => 'Zug';

  @override
  String get gym => 'Fitnessstudio';

  @override
  String get gymTrainSuccess => 'Ausbildung abgeschlossen';

  @override
  String gymSessions(String count) {
    return 'Sitzungen: $count/100';
  }

  @override
  String gymStrengthBonus(String bonus) {
    return 'Stärkebonus: $bonus %';
  }

  @override
  String gymCooldown(String time) {
    return 'Nächste Sitzung um $time';
  }

  @override
  String get gymTrain => 'Zug';

  @override
  String get buyAmmo => 'Kaufen Sie Munition';

  @override
  String factoryPurchaseCost(String cost) {
    return 'Kaufpreis: $cost €';
  }

  @override
  String factoryProductionOutput(String amount) {
    return 'Ausgabe pro Zyklus: $amount Einheiten';
  }

  @override
  String factoryQualityMultiplier(String multiplier) {
    return 'Qualitätsmultiplikator: ${multiplier}x';
  }

  @override
  String upgradeOutputCost(String cost, String nextAmount) {
    return 'Upgrade-Ausgabe – Kosten: $cost, nächste Ausgabe: $nextAmount';
  }

  @override
  String upgradeQualityCost(String cost, String nextQuality) {
    return 'Upgrade-Qualität – Kosten: $cost, nächste Qualität: ${nextQuality}x';
  }

  @override
  String get factoryCostLabel => 'Kosten';

  @override
  String get factoryCurrentOutput => 'Aktueller Ausgang';

  @override
  String get factoryNextOutput => 'Nächste Ausgabe';

  @override
  String get factoryCurrentQuality => 'Aktuelle Qualität';

  @override
  String get factoryNextQuality => 'Nächste Qualität';

  @override
  String get factoryUnitsPerCycle => 'Einheiten/8h max';

  @override
  String get factoryUnitsPerHour => 'Einheiten/Stunde';

  @override
  String get factoryUpgradeMaxLevel => 'Die Fabrik ist auf maximalem Niveau';

  @override
  String get countryUsa => 'USA';

  @override
  String get countryMexico => 'Mexiko';

  @override
  String get countryColombia => 'Kolumbien';

  @override
  String get countryBrazil => 'Brasilien';

  @override
  String get countryArgentina => 'Argentinien';

  @override
  String get countryJapan => 'Japan';

  @override
  String get countryChina => 'China';

  @override
  String get countryRussia => 'Russland';

  @override
  String get countryIndia => 'Indien';

  @override
  String get countryAustralia => 'Australien';

  @override
  String get countrySouthAfrica => 'Südafrika';

  @override
  String get countryCanada => 'Kanada';

  @override
  String get toolBoltCutter => 'Bolzenschneider';

  @override
  String get toolCarTheftTools => 'Werkzeuge für Autodiebstahl';

  @override
  String get toolBurglaryKit => 'Einbruchset';

  @override
  String get toolToolbox => 'Werkzeugkasten';

  @override
  String get toolCrowbar => 'Brecheisen';

  @override
  String get toolGlassCutter => 'Glasschneider';

  @override
  String get toolSprayPaint => 'Sprühfarbe';

  @override
  String get toolJerryCan => 'Jerry Can';

  @override
  String get toolFakeDocuments => 'Gefälschte Dokumente';

  @override
  String get toolHackingLaptop => 'Laptop hacken';

  @override
  String get toolCounterfeitingKit => 'Fälschungsset';

  @override
  String get toolRope => 'Seil';

  @override
  String get toolSilencer => 'Schalldämpfer';

  @override
  String get toolNightVision => 'Nachtsicht';

  @override
  String get toolGpsJammer => 'GPS-Störsender';

  @override
  String get toolBurnerPhone => 'Brennertelefon';

  @override
  String get crimeOutcomeSuccess => 'Krimi erfolgreich!';

  @override
  String get crimeOutcomeCaught => 'Von der Polizei erwischt';

  @override
  String get crimeOutcomeVehicleBreakdownBefore =>
      'Ihr Fahrzeug hatte eine Panne, bevor es den Tatort erreichte';

  @override
  String get crimeOutcomeVehicleBreakdownDuring =>
      'Das Fahrzeug hatte während der Flucht eine Panne – die meiste Beute wurde zurückgelassen';

  @override
  String get crimeOutcomeOutOfFuel =>
      'Während der Flucht ging der Treibstoff aus – zu Fuß geflohen, Beute und Fahrzeug verloren';

  @override
  String get crimeOutcomeToolBroke =>
      'Ihr Werkzeug ist während der Tat kaputt gegangen und hat Spuren hinterlassen';

  @override
  String get crimeOutcomeFledNoLoot => 'Ohne Beute vom Tatort geflohen';

  @override
  String get vehicleCondition => 'Zustand';

  @override
  String get vehicleFuel => 'Kraftstoff';

  @override
  String get vehicleSpeed => 'Geschwindigkeit';

  @override
  String get vehicleArmor => 'Rüstung';

  @override
  String get vehicleStealth => 'Heimlichkeit';

  @override
  String get vehicleCargo => 'Ladung';

  @override
  String get vehicleRepair => 'Reparieren';

  @override
  String get vehicleRefuel => 'Tanken';

  @override
  String get selectCrimeVehicle => 'Wählen Sie Fahrzeug für Verbrechen';

  @override
  String get noVehicleSelected => 'Kein Fahrzeug ausgewählt';

  @override
  String get selectedVehicle => 'Kriminalfahrzeug';

  @override
  String get changeVehicle => 'Fahrzeug wechseln';

  @override
  String get selectVehicle => 'Wählen Sie Fahrzeug';

  @override
  String get vehicleConditionLow => 'Fahrzeugzustand niedrig';

  @override
  String get vehicleFuelLow => 'Kraftstoffverbrauch des Fahrzeugs niedrig';

  @override
  String get vehicleSelectedForCrimes => 'Fahrzeug für Straftaten ausgewählt!';

  @override
  String get vehicleDeselectedForCrimes =>
      'Fahrzeug wegen Straftaten abgewählt!';

  @override
  String get vehicleWrongCountry =>
      'Das Fahrzeug muss sich im selben Land wie Sie befinden';

  @override
  String get failedSelectVehicle => 'Fahrzeug konnte nicht ausgewählt werden';

  @override
  String get failedDeselectVehicle =>
      'Die Auswahl des Fahrzeugs konnte nicht aufgehoben werden';

  @override
  String get selectedForCrimesBadge => 'Ausgewählt wegen Verbrechen';

  @override
  String get selectedButton => 'Ausgewählt';

  @override
  String get selectButton => 'Wählen';

  @override
  String get deselectButton => 'Abwählen';

  @override
  String get prostitutionTitle => 'Prostitution';

  @override
  String get prostitutionTotal => 'Gesamt';

  @override
  String get prostitutionStreet => 'Auf der Straße';

  @override
  String get prostitutionRedLight => 'Rotlicht';

  @override
  String get prostitutionPotentialEarnings => 'Ergebnis';

  @override
  String get prostitutionCollect => 'Sammeln';

  @override
  String get prostitutionRecruit => 'Rekrutieren';

  @override
  String get prostitutionMyProstitutes => 'Meine Prostituierten';

  @override
  String get prostitutionRedLightDistricts => 'Rotlichtviertel';

  @override
  String get prostitutionNoProstitutes =>
      'Es wurden noch keine Prostituierten rekrutiert';

  @override
  String get prostitutionLocation => 'Standort';

  @override
  String get prostitutionMoveToRedLight => 'Gehen Sie zur roten Ampel';

  @override
  String get prostitutionMoveToRldShort => 'Zu RLD';

  @override
  String get prostitutionMoveToStreet => 'Gehen Sie zur Straße';

  @override
  String get prostitutionViewDistricts => 'Bezirke anzeigen';

  @override
  String get prostitutionAvailable => 'Verfügbar';

  @override
  String get prostitutionMyDistricts => 'Meine Bezirke';

  @override
  String get prostitutionCurrentRLD => 'Aktuelle RLD';

  @override
  String get prostitutionMyRLDs => 'Meine RLDs';

  @override
  String get prostitutionNoAvailableDistricts => 'Keine Bezirke verfügbar';

  @override
  String get prostitutionNoOwnedDistricts => 'Sie besitzen noch keine Bezirke';

  @override
  String get prostitutionRooms => 'Zimmer';

  @override
  String get prostitutionOccupancy => 'Belegung';

  @override
  String get prostitutionIncome => 'Einkommen';

  @override
  String get prostitutionTenants => 'Mieterinnen';

  @override
  String get prostitutionBuy => 'Kaufen';

  @override
  String get prostitutionManage => 'Verwalten';

  @override
  String get prostitutionPurchaseConfirmTitle => 'Bezirk kaufen';

  @override
  String prostitutionPurchaseConfirmMessage(String country, int price) {
    return 'Sind Sie sicher, dass Sie das Rotlichtviertel in $country für $price € kaufen möchten?';
  }

  @override
  String get prostitutionPurchase => 'Kaufen';

  @override
  String get prostitutionPurchaseSuccess => 'Bezirk erfolgreich gekauft!';

  @override
  String get prostitutionPurchaseFailed => 'Der Kauf ist fehlgeschlagen';

  @override
  String get prostitutionDistrictManagement => 'Bezirksleitung';

  @override
  String get prostitutionDistrictNotFound => 'Bezirk nicht gefunden';

  @override
  String get back => 'Zurück';

  @override
  String prostitutionMoveToStreetConfirm(String name) {
    return 'Sind Sie sicher, dass Sie $name vom Rotlichtviertel auf die Straße umziehen möchten?';
  }

  @override
  String get prostitutionMoveSuccess => 'Erfolgreich verschoben';

  @override
  String get prostitutionMoveFailed => 'Der Umzug ist fehlgeschlagen';

  @override
  String get prostitutionNoStreetProstitutes =>
      'Auf der Straße gibt es keine Prostituierten';

  @override
  String get prostitutionSelectProstitute => 'Wählen Sie Prostituierte';

  @override
  String get prostitutionOnStreet => 'Auf der Straße';

  @override
  String get prostitutionRoom => 'Zimmer';

  @override
  String get prostitutionInRedLight => 'Im Rotlichtviertel';

  @override
  String get prostitutionEarnings => 'Ergebnis';

  @override
  String get prostitutionRent => 'Mieten';

  @override
  String get prostitutionNetIncome => 'Nettoeinkommen';

  @override
  String get prostitutionLevel => 'Ebene';

  @override
  String get prostitutionXpToNext => 'XP zum nächsten Level';

  @override
  String get prostitutionBusted => 'ERWISCHT';

  @override
  String get prostitutionBustedCount => 'Die Zeiten sind kaputt';

  @override
  String get prostitutionLevelBonus => 'Levelbonus';

  @override
  String get prostitutionVipBonus => 'VIP-Bonus: +50 % Verdienst';

  @override
  String get prostitutionUpgradeTier => 'Upgrade-Stufe';

  @override
  String get prostitutionUpgradeSecurity => 'Aktualisieren Sie die Sicherheit';

  @override
  String get prostitutionTier => 'Stufe';

  @override
  String get prostitutionSecurity => 'Sicherheit';

  @override
  String get prostitutionTierBasic => 'Basic';

  @override
  String get prostitutionTierLuxury => 'Luxus';

  @override
  String get prostitutionTierVip => 'VIP';

  @override
  String get prostitutionSecurityLevel => 'Sicherheitsstufe';

  @override
  String get prostitutionRaidChance => 'Raid-Chance';

  @override
  String get prostitutionMaxTier => 'Maximale Stufe erreicht';

  @override
  String get prostitutionMaxSecurity => 'Maximale Sicherheit erreicht';

  @override
  String get prostitutionUpgradeSuccess => 'Upgrade erfolgreich!';

  @override
  String get prostitutionUpgradeFailed => 'Das Upgrade ist fehlgeschlagen';

  @override
  String get vipEventsTitle => 'VIP-Events';

  @override
  String get vipEventsTabTitle => 'VIP-Events';

  @override
  String get vipEventsDescription =>
      'Weisen Sie Prostituierte VIP-Events zu, um Bonuseinnahmen zu erzielen!';

  @override
  String get vipEventsActive => 'Aktive Ereignisse';

  @override
  String get vipEventsUpcoming => 'Kommende Veranstaltungen';

  @override
  String get vipEventsMyParticipations => 'Meine aktiven Teilnahmen';

  @override
  String get vipEventTypeTitle => 'VIP-Event';

  @override
  String get vipEventCelebrity => 'Prominenter Besuch';

  @override
  String get vipEventBachelor => 'Junggesellenabschied';

  @override
  String get vipEventConvention => 'Konvention';

  @override
  String get vipEventFestival => 'Festival';

  @override
  String get vipEventBonus => 'BONUS';

  @override
  String get vipEventSpots => 'Flecken';

  @override
  String get vipEventParticipants => 'Teilnehmer';

  @override
  String get vipEventFull => 'VERANSTALTUNG VOLL';

  @override
  String get vipEventRequires => 'Erfordert';

  @override
  String get vipEventLevel => 'Ebene';

  @override
  String get vipEventLocation => 'Standort';

  @override
  String get vipEventEndsIn => 'Endet in';

  @override
  String get vipEventStartsIn => 'Beginnt in';

  @override
  String get vipEventNoActive => 'Zur Zeit keine aktiven Veranstaltungen';

  @override
  String get vipEventNoUpcoming => 'Keine bevorstehenden Veranstaltungen';

  @override
  String get vipEventAssignProstitute => 'Prostituierte zuweisen';

  @override
  String get vipEventAssignDialogTitle => 'Zuordnen zu';

  @override
  String vipEventNoEligible(int level, String country) {
    return 'Keine geeigneten Prostituierten. Benötige Level $level+ in $country';
  }

  @override
  String get vipEventJoinSuccess => 'Beigetretene Veranstaltung!';

  @override
  String get vipEventJoinFailed =>
      'Der Veranstaltung konnte nicht beigetreten werden';

  @override
  String get vipEventLeave => 'Veranstaltung verlassen';

  @override
  String get vipEventLeaveSuccess => 'Linkes Ereignis';

  @override
  String get vipEventLeaveFailed =>
      'Die Veranstaltung konnte nicht verlassen werden';

  @override
  String get vipEventAssigned => 'Zugewiesen';

  @override
  String get vipEventPerHour => '/Stunde';

  @override
  String get vipEventEarnings => 'Ergebnis';

  @override
  String get prostitutionLeaderboardTitle => 'Prostitutions-Rangliste';

  @override
  String get prostitutionLeaderboardWeekly => 'Wöchentlich';

  @override
  String get prostitutionLeaderboardMonthly => 'Monatlich';

  @override
  String get prostitutionLeaderboardAllTime => 'Allzeit';

  @override
  String get prostitutionLeaderboardYourRank => 'Ihr wöchentlicher Rang';

  @override
  String get prostitutionLeaderboardUnranked => 'Ohne Rang';

  @override
  String get prostitutionLeaderboardNoData => 'Noch keine Bestenlistendaten';

  @override
  String get prostitutionLeaderboardButton => 'Bestenliste';

  @override
  String get prostitutionRivalryButton => 'Rivalität';

  @override
  String get prostitutionLeaderboardAchievements => 'Erfolge';

  @override
  String get prostitutionLeaderboardLoadFailed =>
      'Die Bestenliste konnte nicht geladen werden';

  @override
  String get achievementsTitle => 'Erfolge';

  @override
  String achievementsProgress(int unlocked, int total) {
    return '$unlocked von $total freigeschaltet';
  }

  @override
  String get achievementsCategoryAll => 'Alle';

  @override
  String get achievementsCategoryProgression => 'Progression';

  @override
  String get achievementsCategoryWealth => 'Reichtum';

  @override
  String get achievementsCategoryPower => 'Leistung';

  @override
  String get achievementsCategorySocial => 'Sozial';

  @override
  String get achievementsCategoryMastery => 'Meisterschaft';

  @override
  String get achievementLocked => 'Gesperrt';

  @override
  String get achievementReward => 'Belohnen';

  @override
  String get achievementUnlocked => 'Entsperrt';

  @override
  String get achievementNoData => 'Keine Erfolge gefunden';

  @override
  String get achievementLoadFailed => 'Erfolge konnten nicht geladen werden';

  @override
  String achievementsMoney(String amount) {
    return '$amount €';
  }

  @override
  String achievementsXp(String xp) {
    return '$xp XP';
  }

  @override
  String achievementsUnlockedDate(String date) {
    return 'Entsperrt am $date';
  }

  @override
  String achievementsDetailProgress(int current, int required) {
    return 'Fortschritt: $current/$required';
  }

  @override
  String get achievementsNoRewardConfigured =>
      'Noch keine Belohnung konfiguriert';

  @override
  String get achievementsRewardOnUnlock =>
      'Sie erhalten diese Belohnung, sobald der Erfolg freigeschaltet ist.';

  @override
  String get achievementsDateToday => 'Heute';

  @override
  String get achievementsDateYesterday => 'Gestern';

  @override
  String achievementsDateDaysAgo(int days) {
    return 'Vor $days Tagen';
  }

  @override
  String get achievementsDetails => 'Einzelheiten';

  @override
  String get achievementsCategory => 'Kategorie';

  @override
  String get achievementJobItSpecialistTitle => 'IT-Spezialist';

  @override
  String get achievementJobItSpecialistDescription =>
      'Absolvieren Sie Ihre erste Schicht als Programmierer';

  @override
  String get achievementJobLawyerTitle => 'Straßenanwalt';

  @override
  String get achievementJobLawyerDescription =>
      'Absolvieren Sie Ihre erste Schicht als Anwalt';

  @override
  String get achievementJobDoctorTitle => 'Untergrundarzt';

  @override
  String get achievementJobDoctorDescription =>
      'Absolvieren Sie Ihre erste Schicht als Arzt';

  @override
  String get achievementSchoolCertifiedTitle => 'Zertifizierter Student';

  @override
  String get achievementSchoolCertifiedDescription =>
      'Verdienen Sie 3 Schulabschlüsse';

  @override
  String get achievementSchoolMultiCertifiedTitle => 'Mehrfach zertifiziert';

  @override
  String get achievementSchoolMultiCertifiedDescription =>
      'Verdienen Sie 6 Schulabschlüsse';

  @override
  String get achievementSchoolTrackSpecialistTitle => 'Streckenspezialist';

  @override
  String get achievementSchoolTrackSpecialistDescription =>
      'Maximiere 3 Schulgleise';

  @override
  String get schoolMenuLabel => 'Schule';

  @override
  String get schoolMenuSubtitle =>
      'Verbessern Sie Ihre Ausbildung und Zertifizierungen';

  @override
  String get schoolTitle => 'Schule & Bildung';

  @override
  String get schoolIntro =>
      'Schalten Sie Jobs und Vermögenswerte durch Levels und Zertifizierungen frei.';

  @override
  String get schoolTracksTitle => 'Verfügbare Ausbildungen';

  @override
  String get schoolUnlockableContentTitle => 'Gesperrte Ausbildungen';

  @override
  String schoolOverallLevelLabel(int level) {
    return 'Schulniveau: $level';
  }

  @override
  String schoolLoadError(String error) {
    return 'Schuldaten konnten nicht geladen werden: $error';
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
  String get schoolGateStatusOpen => 'OFFEN';

  @override
  String get schoolGateStatusLocked => 'GESPERRT';

  @override
  String schoolGateRankProgress(int current, int required) {
    return 'Spielerrang: $current/$required';
  }

  @override
  String schoolGateTrackLevelProgress(String track, int current, int required) {
    return '$track Level: $current/$required';
  }

  @override
  String schoolGateJobTarget(String target) {
    return 'Beruf: $target';
  }

  @override
  String get schoolGateAssetCasinoPurchase => 'Vermögenswert: Casino-Kauf';

  @override
  String get schoolGateAssetAmmoFactoryPurchase =>
      'Vermögenswert: Kauf einer Munitionsfabrik';

  @override
  String get schoolGateAssetAmmoOutputUpgrade =>
      'Vorteil: Munitionsleistungs-Upgrade';

  @override
  String get schoolGateAssetAmmoQualityUpgrade =>
      'Vorteil: Verbesserung der Munitionsqualität';

  @override
  String schoolGateAssetGeneric(String target) {
    return 'Vermögenswert: $target';
  }

  @override
  String schoolGateSystemGeneric(String type, String target) {
    return '$type: $target';
  }

  @override
  String get educationDialogDefaultTitle => '🔒 Ausbildung erforderlich';

  @override
  String get educationDialogFallbackMessage =>
      'Anforderungen nicht erfüllt. Erfüllen Sie die Bildungsvoraussetzungen, um fortfahren zu können.';

  @override
  String get educationDialogClose => 'Schließen';

  @override
  String get educationLockedJobsSectionTitle =>
      '🔒 Gesperrte Arbeitsplätze (Bildung erforderlich)';

  @override
  String get educationAmmoOutputUpgradeLockedTitle =>
      '🔒 Ausgabe-Upgrade gesperrt';

  @override
  String get educationAmmoQualityUpgradeLockedTitle =>
      '🔒 Qualitäts-Upgrade gesperrt';

  @override
  String get educationAmmoFactoryPurchaseLockedTitle => '🔒 Werkskauf gesperrt';

  @override
  String educationRequirementRankProgress(int requiredRank, int currentRank) {
    return 'Benötigt Spielerrang $requiredRank · Aktueller Spielerrang $currentRank';
  }

  @override
  String get educationRequirementTrackLevelTitle => 'Bildungsniveau';

  @override
  String educationRequirementTrackLevelProgress(
    String trackName,
    int requiredLevel,
    int currentLevel,
  ) {
    return '$trackName Level $requiredLevel erforderlich · Aktuell $currentLevel';
  }

  @override
  String get educationRequirementCertificationTitle =>
      'Zertifizierung erforderlich';

  @override
  String get educationRequirementGenericTitle => 'Erfordernis';

  @override
  String get educationRequirementUnknown => 'Unbekannte Anforderung';

  @override
  String get educationTrackNameAviation => 'Luftfahrt';

  @override
  String get educationTrackNameLaw => 'Gesetz';

  @override
  String get educationTrackNameMedicine => 'Medizin';

  @override
  String get educationTrackNameFinance => 'Finanzen';

  @override
  String get educationTrackNameEngineering => 'Maschinenbau';

  @override
  String get educationTrackNameIt => 'ES';

  @override
  String get schoolTrackDescriptionAviation =>
      'Flugtheorie, Navigation und Flugzeugbetrieb.';

  @override
  String get schoolTrackDescriptionLaw =>
      'Strafrecht, Verfahren und Gerichtspraxis.';

  @override
  String get schoolTrackDescriptionMedicine =>
      'Notfallmaßnahmen, Diagnostik und medizinische Praxis.';

  @override
  String get schoolTrackDescriptionFinance =>
      'Buchhaltung, Investitionen und Geschäftsbetrieb.';

  @override
  String get schoolTrackDescriptionEngineering =>
      'Mechanische Systeme, Arbeitssicherheit und Fertigung.';

  @override
  String get schoolTrackDescriptionIt =>
      'Softwareentwicklung, Systeme und Netzwerkbetrieb.';

  @override
  String schoolTrackCooldownActive(int seconds) {
    return 'Abklingzeit aktiv: ${seconds}s verbleibend';
  }

  @override
  String get schoolTrackMaxLevelReached =>
      'Der Track ist bereits auf maximalem Niveau';

  @override
  String get schoolTrackStartFailed =>
      'Das Training konnte nicht gestartet werden';

  @override
  String get educationCertSoftwareEngineer =>
      'Zertifizierung als Software Engineer';

  @override
  String get educationCertBarExam => 'Anwaltsprüfung';

  @override
  String get educationCertMedicalLicense => 'Ärztliche Lizenz';

  @override
  String get educationCertFlightCommercial => 'Kommerzielle Fluglizenz';

  @override
  String get educationCertFlightBasic => 'Grundfluglizenz';

  @override
  String get educationCertIndustrialSafety =>
      'Zertifizierung der Arbeitssicherheit';

  @override
  String get educationCertFinancialAnalyst =>
      'Zertifizierung zum Finanzanalysten';

  @override
  String get educationCertCasinoManagement =>
      'Casino-Management-Zertifizierung';

  @override
  String get educationCertParamedic => 'Zertifizierung als Rettungssanitäter';

  @override
  String get prostitutionLeaderboardProstitutesUnit => 'Prostituierte';

  @override
  String get prostitutionLeaderboardDistrictsUnit => 'Bezirke';

  @override
  String get rivalryTitle => 'Rivalität';

  @override
  String get rivalryChallengeTitle => 'Fordern Sie den Spieler heraus';

  @override
  String get rivalryChallengeHint =>
      'Geben Sie eine Spieler-ID ein, um eine Rivalität zu starten.';

  @override
  String get rivalryPlayerIdHint => 'Spieler-ID';

  @override
  String get rivalryStartButton => 'Start';

  @override
  String get rivalryNoActive => 'Noch keine aktiven Rivalitäten.';

  @override
  String get rivalryActiveTitle => 'Aktive Rivalen';

  @override
  String get rivalryScoreLabel => 'Rivalitätsergebnis';

  @override
  String get rivalryRecentActivity => 'Letzte Aktivität';

  @override
  String get rivalryNoActivity => 'Noch keine Sabotageaktivität';

  @override
  String get rivalryCooldownReady => 'Sabotage bereit';

  @override
  String rivalryCooldownIn(String duration) {
    return 'Abklingzeit: $duration';
  }

  @override
  String get rivalryActionTipPolice => 'Trinkgeld Polizei (5.000 €)';

  @override
  String get rivalryActionStealCustomer => 'Kunden stehlen (3.000 €)';

  @override
  String get rivalryActionDamageReputation => 'Schadensreputation (10.000 €)';

  @override
  String get rivalryActionBribeEmployee =>
      'Bestechung eines Mitarbeiters (8.000 €)';

  @override
  String get rivalryUpdateMessage => 'Rivalität aktualisiert';

  @override
  String get rivalrySabotageExecuted => 'Sabotage ausgeführt';

  @override
  String get rivalryConfirmTitle => 'Sabotage bestätigen';

  @override
  String rivalryConfirmTarget(String username) {
    return 'Ziel: $username';
  }

  @override
  String rivalryConfirmAction(String action) {
    return 'Aktion: $action';
  }

  @override
  String rivalryConfirmCost(int amount) {
    return 'Kosten: $amount €';
  }

  @override
  String rivalryConfirmEffect(String effect) {
    return 'Wirkung: $effect';
  }

  @override
  String get rivalryConfirmWarning =>
      'Der Erfolg ist nicht garantiert und Sie können Geld verlieren.';

  @override
  String get rivalryExecuteButton => 'Ausführen';

  @override
  String get rivalryEffectTipPolice =>
      'Erhöhen Sie den Druck der rivalisierenden Polizei';

  @override
  String get rivalryEffectStealCustomer =>
      'Stehlen Sie einen Teil des Cashflows der Konkurrenz';

  @override
  String get rivalryEffectDamageReputation =>
      'Geringerer Fortschritt bei konkurrierenden Prostituierten';

  @override
  String get rivalryEffectBribeEmployee =>
      'Zwinge eine rivalisierende Prostituierte in den Zustand der Ermordung';

  @override
  String get prostitutionUnderAttackTitle => 'Ihr Imperium wird angegriffen';

  @override
  String prostitutionUnderAttackBody(String attacker, String action) {
    return '$attacker hat in den letzten 24 Stunden $action gegen dich eingesetzt.';
  }

  @override
  String get prostitutionUnderAttackAction => 'Offene Rivalität';

  @override
  String get rivalryProtectionTitle => 'Schutzversicherung';

  @override
  String get rivalryProtectionDescription =>
      'Reduziert die Auswirkungen eingehender Sabotage 7 Tage lang um 30 %.';

  @override
  String get rivalryProtectionInactive => 'Kein aktiver Schutz';

  @override
  String rivalryProtectionActive(String date) {
    return 'Aktiv bis: $date';
  }

  @override
  String get rivalryProtectionBuy => 'Schutz kaufen (25.000 €/Woche)';

  @override
  String get rivalryProtectionActivated => 'Schutzversicherung aktiviert';

  @override
  String get achievementTitle_first_steps => 'Erste Schritte';

  @override
  String get achievementDescription_first_steps =>
      'Rekrutiere deine erste Prostituierte';

  @override
  String get achievementTitle_growing_empire => 'Wachsendes Imperium';

  @override
  String get achievementDescription_growing_empire =>
      'Rekrutiere 5 Prostituierte';

  @override
  String get achievementTitle_first_district => 'Erster Bezirk';

  @override
  String get achievementDescription_first_district =>
      'Kaufen Sie Ihr erstes Rotlichtviertel';

  @override
  String get achievementTitle_empire_builder => 'Empire Builder';

  @override
  String get achievementDescription_empire_builder =>
      'Besitze 5 Rotlichtviertel';

  @override
  String get achievementTitle_district_master => 'Bezirksmeister';

  @override
  String get achievementDescription_district_master =>
      'Besitze 10 Rotlichtviertel';

  @override
  String get achievementTitle_leveling_master => 'Level-Meister';

  @override
  String get achievementDescription_leveling_master =>
      'Bringe eine Prostituierte auf Level 10';

  @override
  String get achievementTitle_untouchable => 'Unantastbar';

  @override
  String get achievementDescription_untouchable =>
      'Lassen Sie sich niemals an 7 aufeinanderfolgenden Tagen festnehmen';

  @override
  String get achievementTitle_millionaire => 'Millionärin';

  @override
  String get achievementDescription_millionaire =>
      'Sammeln Sie einen Gesamtverdienst von 1.000.000 €';

  @override
  String get achievementTitle_high_roller => 'High Roller';

  @override
  String get achievementDescription_high_roller =>
      'Sammeln Sie einen Gesamtverdienst von 5.000.000 €';

  @override
  String get achievementTitle_vip_service => 'VIP-Service';

  @override
  String get achievementDescription_vip_service => 'Schließe 10 VIP-Events ab';

  @override
  String get achievementTitle_event_enthusiast => 'Event-Enthusiast';

  @override
  String get achievementDescription_event_enthusiast =>
      'Schließe 25 VIP-Events ab';

  @override
  String get achievementTitle_security_expert => 'Sicherheitsexperte';

  @override
  String get achievementDescription_security_expert =>
      'Maximieren Sie das Sicherheitsniveau in allen eigenen Bezirken';

  @override
  String get achievementTitle_luxury_provider => 'Luxusanbieter';

  @override
  String get achievementDescription_luxury_provider =>
      'Werte 3 Bezirke auf die VIP-Stufe auf';

  @override
  String get achievementTitle_rivalry_victor => 'Rivalitätssieger';

  @override
  String get achievementDescription_rivalry_victor =>
      'Sabotieren Sie Rivalen 10 Mal erfolgreich';

  @override
  String get achievementTitle_untouchable_rival => 'Unberührbarer Rivale';

  @override
  String get achievementDescription_untouchable_rival =>
      'Verteidige dich gegen 20 Sabotageversuche';

  @override
  String get achievementTitle_crime_first_blood => 'Verbrechen geht vor';

  @override
  String get achievementDescription_crime_first_blood =>
      'Schließe dein erstes Verbrechen erfolgreich ab';

  @override
  String get achievementTitle_crime_hustler => 'Krimi-Hustler';

  @override
  String get achievementDescription_crime_hustler =>
      'Schließe 5 Verbrechen erfolgreich ab';

  @override
  String get achievementTitle_crime_novice => 'Kriminal-Neuling';

  @override
  String get achievementDescription_crime_novice =>
      'Schließe 10 Verbrechen erfolgreich ab';

  @override
  String get achievementTitle_crime_operator => 'Kriminalitätsvermittler';

  @override
  String get achievementDescription_crime_operator =>
      'Schließe 25 Verbrechen erfolgreich ab';

  @override
  String get achievementTitle_crime_wave => 'Verbrechenswelle';

  @override
  String get achievementDescription_crime_wave =>
      'Schließe 50 Verbrechen erfolgreich ab';

  @override
  String get achievementTitle_crime_mastermind => 'Krimi-Mastermind';

  @override
  String get achievementDescription_crime_mastermind =>
      'Schließe 100 Verbrechen erfolgreich ab';

  @override
  String get achievementTitle_the_godfather => 'Der Pate';

  @override
  String get achievementDescription_the_godfather =>
      'Schließe 250 Verbrechen erfolgreich ab';

  @override
  String get achievementTitle_crime_emperor => 'Verbrechenskaiser';

  @override
  String get achievementDescription_crime_emperor =>
      'Schließe 500 Verbrechen erfolgreich ab';

  @override
  String get achievementTitle_crime_legend => 'Kriminallegende';

  @override
  String get achievementDescription_crime_legend =>
      'Schließe 1000 Verbrechen erfolgreich ab';

  @override
  String get achievementTitle_crime_getaway_driver => 'Fluchtfahrer';

  @override
  String get achievementDescription_crime_getaway_driver =>
      'Schließe dein erstes Verbrechen mit einem Fahrzeug erfolgreich ab';

  @override
  String get achievementTitle_crime_armed_and_ready => 'Bewaffnet und bereit';

  @override
  String get achievementDescription_crime_armed_and_ready =>
      'Beende erfolgreich dein erstes Verbrechen, für das eine Waffe erforderlich ist';

  @override
  String get achievementTitle_crime_full_loadout => 'Vollständige Ausstattung';

  @override
  String get achievementDescription_crime_full_loadout =>
      'Schließe ein Verbrechen erfolgreich ab, für das ein Fahrzeug, eine Waffe und Werkzeuge erforderlich sind';

  @override
  String get achievementTitle_crime_completionist => 'Kriminalkomplettierer';

  @override
  String get achievementDescription_crime_completionist =>
      'Schließe jede Verbrechensart mindestens einmal erfolgreich ab';

  @override
  String get achievementTitle_job_first_shift => 'Erste Schicht';

  @override
  String get achievementDescription_job_first_shift =>
      'Schließen Sie Ihren ersten Job erfolgreich ab';

  @override
  String get achievementTitle_job_hustler => 'Job Hustler';

  @override
  String get achievementDescription_job_hustler =>
      'Schließe 5 Jobs erfolgreich ab';

  @override
  String get achievementTitle_job_starter => 'Jobstarter';

  @override
  String get achievementDescription_job_starter =>
      'Schließe 10 Jobs erfolgreich ab';

  @override
  String get achievementTitle_job_operator => 'Job-Operator';

  @override
  String get achievementDescription_job_operator =>
      'Schließe 25 Jobs erfolgreich ab';

  @override
  String get achievementTitle_job_grinder => 'Job Grinder';

  @override
  String get achievementDescription_job_grinder =>
      'Schließe 50 Jobs erfolgreich ab';

  @override
  String get achievementTitle_job_master => 'Job-Meister';

  @override
  String get achievementDescription_job_master =>
      'Schließe 100 Jobs erfolgreich ab';

  @override
  String get achievementTitle_job_expert => 'Jobexperte';

  @override
  String get achievementDescription_job_expert =>
      'Schließe 250 Jobs erfolgreich ab';

  @override
  String get achievementTitle_job_elite => 'Job-Elite';

  @override
  String get achievementDescription_job_elite =>
      'Schließe 500 Jobs erfolgreich ab';

  @override
  String get achievementTitle_job_legend => 'Job-Legende';

  @override
  String get achievementDescription_job_legend =>
      'Schließe 1000 Jobs erfolgreich ab';

  @override
  String get achievementTitle_job_completionist => 'Job-Completionist';

  @override
  String get achievementDescription_job_completionist =>
      'Schließe jeden Jobtyp mindestens einmal erfolgreich ab';

  @override
  String get achievementTitle_job_educated_worker => 'Gebildeter Arbeiter';

  @override
  String get achievementDescription_job_educated_worker =>
      'Schließe 1 Job ab, für den eine Ausbildung erforderlich ist';

  @override
  String get achievementTitle_job_certified_hustler => 'Zertifizierter Hustler';

  @override
  String get achievementDescription_job_certified_hustler =>
      'Erledige 25 Jobs mit Bildungsanforderungen';

  @override
  String get achievementTitle_job_education_completionist =>
      'Abschlussarbeiter im Bildungsbereich';

  @override
  String get achievementDescription_job_education_completionist =>
      'Erledigen Sie jeden bildungsbezogenen Jobtyp mindestens einmal';

  @override
  String get achievementTitle_job_it_specialist => 'IT-Spezialist';

  @override
  String get achievementDescription_job_it_specialist =>
      'Absolvieren Sie Ihre erste Schicht als Programmierer';

  @override
  String get achievementTitle_job_lawyer => 'Straßenanwalt';

  @override
  String get achievementDescription_job_lawyer =>
      'Absolvieren Sie Ihre erste Schicht als Anwalt';

  @override
  String get achievementTitle_job_doctor => 'Untergrundarzt';

  @override
  String get achievementDescription_job_doctor =>
      'Absolvieren Sie Ihre erste Schicht als Arzt';

  @override
  String get achievementTitle_school_certified => 'Zertifizierter Student';

  @override
  String get achievementDescription_school_certified =>
      'Verdienen Sie 3 Schulabschlüsse';

  @override
  String get achievementTitle_school_multi_certified => 'Mehrfach zertifiziert';

  @override
  String get achievementDescription_school_multi_certified =>
      'Verdienen Sie 6 Schulabschlüsse';

  @override
  String get achievementTitle_school_track_specialist => 'Streckenspezialist';

  @override
  String get achievementDescription_school_track_specialist =>
      'Maximiere 3 Schulgleise';

  @override
  String get achievementTitle_school_freshman => 'Schulanfänger';

  @override
  String get achievementDescription_school_freshman =>
      'Erreiche Bildungsniveau 1';

  @override
  String get achievementTitle_school_scholar => 'Schulgelehrter';

  @override
  String get achievementDescription_school_scholar =>
      'Erreiche Bildungsniveau 3';

  @override
  String get achievementTitle_school_graduate => 'Schulabsolvent';

  @override
  String get achievementDescription_school_graduate =>
      'Erreiche Bildungsniveau 5';

  @override
  String get achievementTitle_school_mastermind => 'Akademischer Vordenker';

  @override
  String get achievementDescription_school_mastermind =>
      'Erreiche Bildungsniveau 10';

  @override
  String get achievementTitle_school_doctorate => 'Straßendoktorat';

  @override
  String get achievementDescription_school_doctorate =>
      'Erreiche Bildungsniveau 20';

  @override
  String get achievementTitle_road_bandit => 'Straßenbandit';

  @override
  String get achievementDescription_road_bandit => 'Stehlen Sie 5 Autos';

  @override
  String get achievementTitle_grand_theft_fleet => 'Grand Theft-Flotte';

  @override
  String get achievementDescription_grand_theft_fleet => 'Stehlen Sie 25 Autos';

  @override
  String get achievementTitle_sea_raider => 'Sea Raider';

  @override
  String get achievementDescription_sea_raider => 'Stehlen Sie 3 Boote';

  @override
  String get achievementTitle_captain_of_smugglers =>
      'Hauptmann der Schmuggler';

  @override
  String get achievementDescription_captain_of_smugglers =>
      'Stehlen Sie 12 Boote';

  @override
  String get achievementTitle_globe_trotter => 'Globetrotter';

  @override
  String get achievementDescription_globe_trotter => 'Schließe 5 Reisen ab';

  @override
  String get achievementTitle_jet_setter => 'Jetsetter';

  @override
  String get achievementDescription_jet_setter => 'Schließe 25 Reisen ab';

  @override
  String get achievementTitle_chemist_apprentice => 'Chemikerlehrling';

  @override
  String get achievementDescription_chemist_apprentice =>
      'Schließe 10 Drogenproduktionen ab';

  @override
  String get achievementTitle_narco_chemist => 'Narco-Chemiker';

  @override
  String get achievementDescription_narco_chemist =>
      'Schließe 100 Arzneimittelproduktionen ab';

  @override
  String get achievementTitle_street_merchant => 'Straßenhändler';

  @override
  String get achievementDescription_street_merchant => 'Schließe 25 Trades ab';

  @override
  String get achievementTitle_trade_tycoon => 'Handelsmagnat';

  @override
  String get achievementDescription_trade_tycoon => 'Schließe 150 Trades ab';

  @override
  String get achievementTitle_prostitute_lineup => 'Aufstellung aufgebaut';

  @override
  String get achievementDescription_prostitute_lineup =>
      'Rekrutiere 10 Prostituierte';

  @override
  String get achievementTitle_prostitute_network => 'Straßennetz';

  @override
  String get achievementDescription_prostitute_network =>
      'Rekrutiere 25 Prostituierte';

  @override
  String get achievementTitle_prostitute_syndicate => 'Syndikat';

  @override
  String get achievementDescription_prostitute_syndicate =>
      'Rekrutiere 50 Prostituierte';

  @override
  String get achievementTitle_prostitute_dynasty => 'Dynastie';

  @override
  String get achievementDescription_prostitute_dynasty =>
      'Rekrutiere 100 Prostituierte';

  @override
  String get achievementTitle_prostitute_empire_250 => 'Imperium 250';

  @override
  String get achievementDescription_prostitute_empire_250 =>
      'Rekrutiere 250 Prostituierte';

  @override
  String get achievementTitle_prostitute_cartel_500 => 'Kartell 500';

  @override
  String get achievementDescription_prostitute_cartel_500 =>
      'Rekrutiere 500 Prostituierte';

  @override
  String get achievementTitle_prostitute_legend_1000 => 'Legende 1000';

  @override
  String get achievementDescription_prostitute_legend_1000 =>
      'Rekrutiere 1000 Prostituierte';

  @override
  String get achievementTitle_vip_prostitute_level_10 => 'VIP-Anfänger';

  @override
  String get achievementDescription_vip_prostitute_level_10 =>
      'Erreiche Level 3 mit einer VIP-Prostituierten';

  @override
  String get achievementTitle_vip_prostitute_level_25 => 'VIP-Headliner';

  @override
  String get achievementDescription_vip_prostitute_level_25 =>
      'Erreiche Level 5 mit einer VIP-Prostituierten';

  @override
  String get achievementTitle_vip_prostitute_level_50 => 'VIP-Symbol';

  @override
  String get achievementDescription_vip_prostitute_level_50 =>
      'Erreiche Level 7 mit einer VIP-Prostituierten';

  @override
  String get achievementTitle_vip_prostitute_level_100 => 'VIP-Legende';

  @override
  String get achievementDescription_vip_prostitute_level_100 =>
      'Erreiche Level 10 mit einer VIP-Prostituierten';

  @override
  String get achievementTitle_nightclub_opening_night => 'Eröffnungsabend';

  @override
  String get achievementDescription_nightclub_opening_night =>
      'Eröffnen Sie Ihren ersten Nachtclub';

  @override
  String get achievementTitle_nightclub_headliner => 'Headliner-Booker';

  @override
  String get achievementDescription_nightclub_headliner =>
      'Buchen Sie 10 DJ-Schichten für Ihr Nachtclubimperium';

  @override
  String get achievementTitle_nightclub_full_house => 'Volles Haus';

  @override
  String get achievementDescription_nightclub_full_house =>
      'Erhöhen Sie die Kapazität eines Nachtclubs auf 90 %';

  @override
  String get achievementTitle_nightclub_cash_machine => 'Geldautomat';

  @override
  String get achievementDescription_nightclub_cash_machine =>
      'Verdienen Sie einen Gesamtumsatz von 250.000 € im Nachtclub';

  @override
  String get achievementTitle_nightclub_empire => 'Nachtleben-Imperium';

  @override
  String get achievementDescription_nightclub_empire =>
      'Verdienen Sie einen Gesamtumsatz von 1.000.000 € im Nachtclub';

  @override
  String get achievementTitle_nightclub_staffing_boss => 'Personalchef';

  @override
  String get achievementDescription_nightclub_staffing_boss =>
      'Führen Sie gleichzeitig 3 aktive Nachtclub-Crewmitglieder';

  @override
  String get achievementTitle_nightclub_vip_room => 'VIP-Raum';

  @override
  String get achievementDescription_nightclub_vip_room =>
      'Weisen Sie Ihrem Nachtclub 2 VIP-Crew-Mitglieder zu';

  @override
  String get achievementTitle_nightclub_head_of_security => 'Leiter Sicherheit';

  @override
  String get achievementDescription_nightclub_head_of_security =>
      'Mieten Sie einen Nachtclub-Sicherheitsdienst für 10 Schichten';

  @override
  String get achievementTitle_nightclub_podium_finish => 'Podiumsplatz';

  @override
  String get achievementDescription_nightclub_podium_finish =>
      'Erreichen Sie die Top 3 einer wöchentlichen Nachtclub-Saison';

  @override
  String get achievementTitle_nightclub_season_champion => 'Saisonmeister';

  @override
  String get achievementDescription_nightclub_season_champion =>
      'Gewinnen Sie eine wöchentliche Nachtclub-Saison';

  @override
  String get nightclubManagementTitle => 'Nachtclub-Management';

  @override
  String get nightclubRealtimeStatus => 'Echtzeitstatus aktiv';

  @override
  String get nightclubRefresh => 'Aktualisieren';

  @override
  String get nightclubEmptyTitle => 'Noch kein Nachtclub gefunden';

  @override
  String get nightclubEmptyBody =>
      'Kaufen Sie zunächst einen Nachtclub in Immobilien, um dieses System zu aktivieren.';

  @override
  String get nightclubLocationTitle => 'Nachtclub-Standort';

  @override
  String get nightclubSelectVenue => 'Veranstaltungsort auswählen';

  @override
  String get nightclubLiveStatistics => 'Live-Statistiken';

  @override
  String get nightclubKpiCrowd => 'Menge';

  @override
  String get nightclubKpiVibe => 'Stimmung';

  @override
  String get nightclubKpiToday => 'Heute';

  @override
  String get nightclubKpiAllTime => 'Allzeit';

  @override
  String get nightclubKpiStock => 'Aktie';

  @override
  String get nightclubKpiDj => 'DJ';

  @override
  String get nightclubKpiThefts => 'Diebstähle';

  @override
  String get nightclubKpiStaff => 'Mitarbeiterin';

  @override
  String get nightclubKpiSalesBoost => 'Verkaufsschub';

  @override
  String get nightclubKpiPriceBoost => 'Preiserhöhung';

  @override
  String get nightclubKpiVipBonus => 'VIP-Bonus';

  @override
  String get nightclubStatusActive => 'Aktiv';

  @override
  String get nightclubStatusOff => 'Aus';

  @override
  String get nightclubStatusActiveLower => 'aktiv';

  @override
  String get nightclubRevenueTrend => 'Umsatztrend (live)';

  @override
  String get nightclubLeaderboardTitle => 'Top-Nachtclubs';

  @override
  String get nightclubLeaderboardCountry => 'Land';

  @override
  String get nightclubLeaderboardGlobal => 'Global';

  @override
  String get nightclubLeaderboardEmpty => 'Noch keine Bestenlistendaten';

  @override
  String get nightclubLeaderboardRevenue24h => '24-Stunden-Umsatz';

  @override
  String get nightclubSeasonProcessing => 'Verarbeitung...';

  @override
  String get nightclubSeasonTitle => 'Wöchentliches Saisonranking';

  @override
  String get nightclubSeasonResetIn => 'Zurücksetzen in';

  @override
  String get nightclubSeasonYourRewards => 'Deine Saisonbelohnungen';

  @override
  String get nightclubSeasonCurrentTop5 => 'Top 5 der aktuellen Woche';

  @override
  String get nightclubSeasonEmpty => 'Noch keine Saisondaten';

  @override
  String get nightclubSeasonWeekRevenue => 'Wochenumsatz';

  @override
  String get nightclubSeasonScore => 'Punktzahl';

  @override
  String get nightclubSeasonRecentPayouts => 'Aktuelle Auszahlungen';

  @override
  String get nightclubSeasonNoPayouts => 'Noch keine Auszahlungen';

  @override
  String get nightclubSalesTitle => 'Aktuelle Verkäufe';

  @override
  String get nightclubSalesEmpty => 'Noch keine Verkaufsdaten';

  @override
  String get nightclubTheftTitle => 'Diebstahlprotokoll';

  @override
  String get nightclubTheftEmpty => 'Es wurden keine Diebstähle registriert';

  @override
  String get nightclubTheftLoss => 'Verlust';

  @override
  String get nightclubStaffTitle => 'Zuhälter-Crew im Club';

  @override
  String get nightclubStaffVipExtraActive => '(VIP +2 aktiv)';

  @override
  String nightclubStaffCapacity(String assigned, String cap, String vipSuffix) {
    return 'Kapazität: $assigned/$cap$vipSuffix';
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
    return 'Boost-Mix: Umsatz x$sales | Preis x$price | Stimmung x$vibe | Sicherheit x$security | VIP-Spieler x$vipPlayer | VIP-Stab x$vipStaff ($vipAssigned)';
  }

  @override
  String get nightclubSelectCrewMember => 'Besatzungsmitglied auswählen';

  @override
  String get nightclubAssignShift => 'Zuweisen zur Nachtclub-Schicht';

  @override
  String get nightclubTabActive => 'Aktiv';

  @override
  String get nightclubTabHistory => 'Geschichte';

  @override
  String get nightclubNoCrewAssigned => 'Noch keine Besatzung zugewiesen';

  @override
  String get nightclubCrewBoostDescription =>
      'Steigert die Nachfrage und Marge in Ihrem Club';

  @override
  String get nightclubRemove => 'Entfernen';

  @override
  String get nightclubNoStaffHistory => 'Noch keine Personalhistorie';

  @override
  String get nightclubFrom => 'Aus';

  @override
  String get nightclubTo => 'Zu';

  @override
  String get nightclubRevenueImpact => 'Auswirkungen auf den Umsatz';

  @override
  String get nightclubSalesCountLabel => 'Verkäufe';

  @override
  String get nightclubDjTitle => 'Mieten Sie einen DJ';

  @override
  String get nightclubChooseDj => 'Wählen Sie DJ';

  @override
  String get nightclubShiftLength => 'Schichtlänge';

  @override
  String get nightclubHireDj => 'Mieten Sie einen DJ';

  @override
  String get nightclubSecurityTitle => 'Sicherheit';

  @override
  String get nightclubChooseSecurity => 'Wählen Sie Sicherheit';

  @override
  String get nightclubHireSecurity => 'Mieten Sie Sicherheit';

  @override
  String get nightclubStoreTitle => 'Lagern Sie Medikamente';

  @override
  String get nightclubChooseStock => 'Wählen Sie Lagerbestand';

  @override
  String get nightclubAmountGrams => 'Menge in Gramm';

  @override
  String get nightclubStoreButton => 'Im Nachtclub aufbewahren';

  @override
  String get nightclubHireDjSuccess => 'DJ engagiert';

  @override
  String get nightclubHireSecuritySuccess => 'Sicherheitsdienst angeheuert';

  @override
  String get nightclubAssignCrewSuccess => 'Besatzungsmitglied zugewiesen';

  @override
  String get nightclubRemoveCrewSuccess => 'Besatzungsmitglied entfernt';

  @override
  String get nightclubStoreDrugsSuccess => 'Medikamente gelagert';

  @override
  String get nightclubSeasonPayoutDialogTitle => 'Saisonauszahlung erhalten';

  @override
  String nightclubSeasonPayoutDialogBody(String rank) {
    return 'Ihr Nachtclub landete diese Woche auf Platz #$rank.';
  }

  @override
  String nightclubSeasonPayoutDialogReward(String amount) {
    return 'Belohnung: $amount';
  }

  @override
  String nightclubSeasonPayoutDialogRevenue(String amount) {
    return 'Wöchentlicher Umsatz: $amount';
  }

  @override
  String nightclubSeasonPayoutDialogLoss(String amount) {
    return 'Diebstahlschaden: $amount';
  }

  @override
  String get nightclubSeasonPayoutDialogAction => 'Schließen';

  @override
  String get nightclubVibeChill => 'Kühlen';

  @override
  String get nightclubVibeNormal => 'Normal';

  @override
  String get nightclubVibeWild => 'Wild';

  @override
  String get nightclubVibeRaging => 'Wütend';

  @override
  String get nightclubTheftTypeCustomer => 'Kundendiebstahl';

  @override
  String get nightclubTheftTypeEmployee => 'Mitarbeiterraub';

  @override
  String get nightclubTheftTypeRival => 'Rivalisierende Sabotage';

  @override
  String get theftCooldownRedeemTitle =>
      'Abklingzeit bei Diebstahl überspringen?';

  @override
  String theftCooldownRedeemMessage(int cost, int balance) {
    return 'Jetzt $cost Credits ausgeben, um die Abklingzeit des Fahrzeugdiebstahls zu beenden? Ihr Guthaben: $balance.';
  }

  @override
  String get theftCooldownRedeemDontShowAgain =>
      'Diese Bestätigung nicht noch einmal anzeigen';

  @override
  String theftCooldownRedeemConfirmAction(int credits) {
    return 'Verwenden Sie $credits Credits';
  }

  @override
  String get theftCooldownRedeemNotAvailable =>
      'Für diese Abklingzeit ist derzeit keine Kreditbeschleunigung verfügbar.';

  @override
  String get theftCooldownRedeemNoActiveCooldown =>
      'Keine aktive Diebstahl-Abklingzeit zum Zurücksetzen.';

  @override
  String get theftCooldownRedeemInsufficientCredits =>
      'Nicht genügend Credits.';

  @override
  String get theftCooldownRedeemFailed =>
      'Credits konnten nicht auf die Abklingzeit angewendet werden.';

  @override
  String get theftCooldownRedeemSuccess => 'Abklingzeit gelöscht.';

  @override
  String get settingsTheftCooldownConfirmTitle =>
      'Abklingzeit bei Diebstahl (Credits)';

  @override
  String get settingsTheftCooldownConfirmSubtitle =>
      'Bitten Sie um eine Bestätigung, bevor Sie Credits ausgeben, um die Abklingzeit bei Fahrzeugdiebstahl zu überspringen. Schalten Sie es aus, um es mit einem Fingertipp einzulösen (Blitzsymbol neben dem Timer).';
}
