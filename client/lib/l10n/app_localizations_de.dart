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
  String get registerGenderTitle => 'Dein Charakter';

  @override
  String get registerGenderSubtitle =>
      'Tippen Sie auf ein Porträt – dadurch wird Ihr Start-Look festgelegt und in Ihrem Konto gespeichert.';

  @override
  String get registerGenderMale => 'Männlicher Gangster';

  @override
  String get registerGenderFemale => 'Weiblicher Gangster';

  @override
  String get genderRequired =>
      'Wählen Sie männlich oder weiblich, um fortzufahren.';

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
  String get dashboardTimeoutAmmo => 'Munition kaufen';

  @override
  String get dashboardTimeoutShootingRange => 'Schießstand';

  @override
  String get dashboardTimeoutGym => 'Fitnessstudio';

  @override
  String get dashboardTimeoutGymStrength => 'Gym: strength';

  @override
  String get dashboardTimeoutGymSpeed => 'Gym: speed';

  @override
  String get dashboardTimeoutGymStamina => 'Gym: stamina';

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
  String get crimeEliminateWitnessName => 'Zeuge eliminieren';

  @override
  String get crimeEliminateWitnessDesc =>
      'Eliminieren Sie einen Zeugen vor dem Prozess';

  @override
  String get crimeDiamondHeistName =>
      'Raubüberfall auf den Diamantentransporter';

  @override
  String get crimeDiamondHeistDesc =>
      'Kapern Sie einen Transport voller Rohdiamanten';

  @override
  String get crimeEvidenceRoomHeistName => 'Raubüberfall auf den Beweisraum';

  @override
  String get crimeEvidenceRoomHeistDesc =>
      'Diebstahl von Beweismitteln aus einem Bundeslager';

  @override
  String get crimeMuseumHeistName => 'Museumsraub';

  @override
  String get crimeMuseumHeistDesc =>
      'Stehlen Sie wertvolle Artefakte aus einem Museum';

  @override
  String get crimeBossAssassinationName => 'Rivalisierender Boss-Attentat';

  @override
  String get crimeBossAssassinationDesc =>
      'Eliminieren Sie den Anführer einer rivalisierenden Organisation';

  @override
  String get crimeCriminalRecordWipeName => 'Strafregister löschen';

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
  String get tooltipCrimeRequiresWeapon => 'Waffe erforderlich';

  @override
  String get tooltipCrimeRequirementsHeading => 'Erforderlich:';

  @override
  String get crimeCriminalRecordWipeTooltip =>
      'Löscht bei Erfolg Ihr gesamtes Strafregister. Nur verfügbar, wenn Sie bereits vorbestraft sind.';

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
  String jobSuccessChancePercent(String percent) {
    return '$percent% Chance';
  }

  @override
  String jobXpRewardShort(String xp) {
    return '+$xp XP';
  }

  @override
  String jobPayRangeEuro(String min, String max) {
    return '$min-€$max';
  }

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
  String get travelNotInTransit => 'Du bist nicht auf einer Reise.';

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
  String get userAccountMenuTooltip => 'Kontomenü';

  @override
  String get myProfile => 'Mein Profil';

  @override
  String get messages => 'Nachrichten';

  @override
  String get noDirectMessagesYet => 'Noch keine Nachrichten';

  @override
  String get sendMessageToFriendsHint =>
      'Senden Sie eine Nachricht an Ihre Freunde!';

  @override
  String errorLoadingConversations(String error) {
    return 'Fehler beim Laden von Konversationen: $error';
  }

  @override
  String get messageSystemBadge => 'SYSTEM';

  @override
  String get messageSystemInboxPreview => 'Erfolge und Systemmeldungen';

  @override
  String get messageSystemThreadSubtitle => 'Erfolge und Systemmeldungen';

  @override
  String get messageSystemThreadEmptyDetail =>
      'Erfolge und Systemmeldungen erscheinen hier automatisch.';

  @override
  String get messageSendFirst => 'Senden Sie die erste Nachricht!';

  @override
  String chatFriendRankLine(int rank) {
    return '★ Rang $rank';
  }

  @override
  String errorLoadingMessages(String error) {
    return 'Fehler beim Laden der Nachrichten: $error';
  }

  @override
  String get messageDeleteOwnOnly =>
      'Sie können nur Ihre eigenen Nachrichten löschen';

  @override
  String get messageDeleteTitle => 'Nachricht löschen';

  @override
  String get messageDeleteBody => 'Diese Nachricht wird dauerhaft gelöscht.';

  @override
  String get messageSendFailed => 'Nachricht konnte nicht gesendet werden';

  @override
  String get messageDeleteFailed => 'Nachricht konnte nicht gelöscht werden';

  @override
  String get investigationWindowExpired =>
      'Das Untersuchungsfenster ist abgelaufen (24 Stunden).';

  @override
  String get investigationStartedInboxHint =>
      'Die Ermittlungen wurden eingeleitet. Überprüfen Sie Ihren Posteingang auf den Detektivbericht.';

  @override
  String get investigationAlreadyInProgress =>
      'Diese Untersuchung ist bereits im Gange oder abgeschlossen.';

  @override
  String investigationStartFailed(String error) {
    return 'Untersuchung konnte nicht gestartet werden: $error';
  }

  @override
  String get investigationExpired => 'Die Untersuchung ist abgelaufen';

  @override
  String get investigationStarted => 'Die Ermittlungen wurden eingeleitet';

  @override
  String get investigationStarting => 'Beginnt...';

  @override
  String get startMurderInvestigation => 'Beginnen Sie mit der Mordermittlung';

  @override
  String get systemMessagesReadOnlyHint =>
      'Systemnachrichten können nicht beantwortet werden';

  @override
  String get helpAndGuide => 'Hilfe und Anleitung';

  @override
  String get helpUiManualTitle => 'Spielhandbuch';

  @override
  String get helpUiSearchHint => 'Suche nach Modul, Erklärung oder Tipp';

  @override
  String get helpUiTopicLabel => 'Thema';

  @override
  String get helpUiAllChip => 'Alle';

  @override
  String get helpUiNoResultsTitle => 'Keine Themen gefunden';

  @override
  String get helpUiNoResultsBody =>
      'Ändern Sie Ihre Suche oder Kategorie, um erneut Ergebnisse anzuzeigen.';

  @override
  String get helpUiHowItWorks => 'Wie es funktioniert';

  @override
  String get helpUiTips => 'Tipps';

  @override
  String get quickActions => 'Schnelle Aktionen';

  @override
  String get mobileNavCrimes => 'Verbrechen';

  @override
  String get mobileNavSteal => 'Stehlen';

  @override
  String get mobileNavWork => 'Arbeiten';

  @override
  String get mobileNavBank => 'Bank';

  @override
  String get mobileNavCrew => 'Crew';

  @override
  String get mobileNavReady => 'Bereit';

  @override
  String get menuSearchHint => 'Suchmenü';

  @override
  String get menuSearchNoResults => 'Keine passenden Seiten';

  @override
  String get menuNavCategoryActions => 'Aktionen';

  @override
  String get menuNavCategoryWorld => 'Welt';

  @override
  String get menuNavCategorySocial => 'Sozial';

  @override
  String get menuNavCategoryEconomy => 'Wirtschaft';

  @override
  String get menuNavCategoryEmpire => 'Reich';

  @override
  String get menuNavCategoryAssets => 'Vermögenswerte';

  @override
  String get menuNavCategoryMore => 'Mehr';

  @override
  String get liveEvents => 'Meine Aktivität';

  @override
  String get worldFeedHint => 'Nur deine letzten Aktionen.';

  @override
  String get support => 'Unterstützung';

  @override
  String get events => 'Veranstaltungen';

  @override
  String get liveEventRailOpenEvents => 'Open events';

  @override
  String seasonPassTitle(String season) {
    return 'Season Pass $season';
  }

  @override
  String get seasonPassSubtitle =>
      '56 monatliche Ziele: Verbrechen, Fahrzeuge, Schmuggel, Drogen, verdientes Geld, XP und Prostitutions-Rekrutierung. Gratis Event-Preis und Event-Pass-Bonus (Premium) pro Zeile.';

  @override
  String seasonPassGoalProstitution(int count) {
    return 'Rekrutiere $count Arbeiterinnen';
  }

  @override
  String seasonPassGoalsProgress(String completed, String total) {
    return '$completed / $total goals reached';
  }

  @override
  String get seasonPassColumnGoal => 'Goal';

  @override
  String get seasonPassColumnEvent => 'Event';

  @override
  String get seasonPassColumnPremium => 'Pass';

  @override
  String seasonPassGoalCrime(int count) {
    return 'Complete $count crimes';
  }

  @override
  String seasonPassGoalVehicles(int count) {
    return 'Steal $count vehicles';
  }

  @override
  String seasonPassGoalSmuggling(int count) {
    return 'Smuggle $count units';
  }

  @override
  String seasonPassGoalDrugs(int count) {
    return 'Produce $count drugs';
  }

  @override
  String seasonPassGoalMoney(String amount) {
    return 'Earn $amount cash';
  }

  @override
  String seasonPassGoalXp(int count) {
    return 'Gain $count XP';
  }

  @override
  String seasonPassGoalGeneric(int count) {
    return 'Reach $count';
  }

  @override
  String seasonPassGoalProgress(int current, int remaining) {
    return '$current done · $remaining to go';
  }

  @override
  String seasonPassGoalRatio(int current, int target) {
    return '$current/$target';
  }

  @override
  String seasonPassScore(String score) {
    return 'Pass XP: $score';
  }

  @override
  String seasonPassNextLevel(String level, String remaining) {
    return 'Next level $level: $remaining XP to go';
  }

  @override
  String get seasonPassBuyCta => 'Unlock premium · €7.99';

  @override
  String get seasonPassPremiumActive => 'Premium';

  @override
  String get seasonPassFreeTrack => 'Free';

  @override
  String get seasonPassTrackFree => 'Free';

  @override
  String get seasonPassTrackPremium => 'Premium';

  @override
  String seasonPassLevelLabel(String level, String score) {
    return 'Level $level · $score XP';
  }

  @override
  String get seasonPassClaim => 'Claim';

  @override
  String get seasonPassClaimed => 'Claimed';

  @override
  String get seasonPassLocked => 'Locked';

  @override
  String get seasonPassClaimSuccess => 'Season Pass reward claimed';

  @override
  String get seasonPassClaimSuccessFree => 'Free event prize claimed';

  @override
  String get seasonPassClaimSuccessPremium =>
      'Premium Event Pass reward claimed';

  @override
  String get seasonPassClaimFailed => 'Could not claim reward';

  @override
  String get seasonPassRewardAmmo => 'Ammo';

  @override
  String get seasonPassRewardAmmoWith => '+ ammo';

  @override
  String get seasonPassRewardVehicle => 'Rare vehicle';

  @override
  String get seasonPassRewardWeapon => 'Weapon';

  @override
  String get seasonPassRewardParts => 'Parts';

  @override
  String get seasonPassRewardPartsWith => '+ parts';

  @override
  String get seasonPassRewardBundle => 'Reward pack';

  @override
  String get seasonPassRewardXp => 'XP boost';

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
  String get vehicleHeistTitle => 'Fahrzeugraub';

  @override
  String get vehicleHeistHeroSubtitle =>
      'Steal cars, motorcycles and boats. Upgrade storage lanes and climb the weekly theft hunt.';

  @override
  String vehicleHeistLiveEventActive(String title) {
    return 'Live event: $title';
  }

  @override
  String vehicleHeistLiveEventProgress(
    String score,
    String rank,
    String timeLeft,
  ) {
    return 'Score $score · Rank $rank · $timeLeft';
  }

  @override
  String get vehicleHeistOpenEvents => 'Tap for event details';

  @override
  String get vehicleHeistStolenHeadline => 'Vehicle secured';

  @override
  String get vehicleHeistTabSubtitleCar =>
      'Stehlen Sie Autos für Bargeld und Teile.';

  @override
  String get vehicleHeistTabSubtitleMotorcycle =>
      'Stehlen Sie Motorräder für Bargeld und Teile.';

  @override
  String get vehicleHeistTabSubtitleBoat =>
      'Stehlen Sie Boote für Bargeld und Teile.';

  @override
  String get vehicleHeistReady => 'Bereit';

  @override
  String get vehicleHeistMotorStorage => 'Motorradlager';

  @override
  String get vehicleHeistCapacityPolicyCar =>
      'Die Fahrzeugkapazität wird auf alle Autodiebstähle aufgeteilt.';

  @override
  String get vehicleHeistCapacityPolicyMotorcycle =>
      'Die Motorradkapazität wird auf alle Motorraddiebstähle aufgeteilt.';

  @override
  String get vehicleHeistCapacityPolicyBoat =>
      'Die Bootskapazität wird auf alle Bootsraubüberfälle verteilt.';

  @override
  String vehicleHeistRankRequired(String rank) {
    return 'Erforderlicher Rang: $rank';
  }

  @override
  String vehicleHeistCapacityLine(String stored, String total, String level) {
    return 'Lagerung: $stored/$total (Lane-Level $level)';
  }

  @override
  String get vehicleHeistStealCar => 'Auto stehlen';

  @override
  String get vehicleHeistStealMotorcycle => 'Motorrad stehlen';

  @override
  String get vehicleHeistStealBoat => 'Boot stehlen';

  @override
  String get vehicleHeistGenericVehicle => 'Fahrzeug';

  @override
  String vehicleHeistSuccessStolen(String vehicle) {
    return 'Erfolg: $vehicle gestohlen.';
  }

  @override
  String vehicleHeistCooldownActive(String duration) {
    return 'Abklingzeit aktiv: $duration';
  }

  @override
  String vehicleHeistArrested(String minutes) {
    return 'Du wurdest verhaftet ($minutes min. Gefängnis).';
  }

  @override
  String get vehicleHeistUntil => 'bis';

  @override
  String get vehicleHeistRegionalLockActive => 'Regionalsperre aktiv.';

  @override
  String get vehicleHeistStealFailed =>
      'Die Diebstahlaktion ist fehlgeschlagen.';

  @override
  String get vehicleHeistUpgradeCompleted => 'Upgrade abgeschlossen.';

  @override
  String get vehicleHeistUpgradeFailed => 'Das Upgrade ist fehlgeschlagen.';

  @override
  String get vehicleHeistCatalogTitleCars => 'Verfügbare Autos';

  @override
  String get vehicleHeistCatalogTitleMotorcycles => 'Verfügbare Motorräder';

  @override
  String get vehicleHeistCatalogTitleBoats => 'Verfügbare Boote';

  @override
  String get vehicleHeistCatalogEmpty => 'Keine Fahrzeuge in diesem Katalog.';

  @override
  String get vehicleHeistRarityCommon => 'Gemeinsam';

  @override
  String get vehicleHeistRarityUncommon => 'Ungewöhnlich';

  @override
  String get vehicleHeistRarityRare => 'Selten';

  @override
  String get vehicleHeistRarityEpic => 'Epos';

  @override
  String get vehicleHeistRarityLegendary => 'Legendär';

  @override
  String get vehicleHeistEventOnlyTag => 'Nur für Veranstaltungen';

  @override
  String vehicleHeistCatalogValue(String value) {
    return 'Wert: $value';
  }

  @override
  String vehicleHeistCatalogRank(String rank) {
    return 'Rang: $rank';
  }

  @override
  String vehicleHeistCatalogInGameAvailability(String label) {
    return 'Verfügbarkeit im Spiel: $label';
  }

  @override
  String vehicleHeistCatalogMostCommonIn(String country) {
    return 'Am häufigsten in: $country';
  }

  @override
  String vehicleHeistCatalogCountries(String countries) {
    return 'Länder: $countries';
  }

  @override
  String get vehicleHeistCatalogFilterAll => 'All vehicles';

  @override
  String get vehicleHeistCatalogFilterAvailable => 'World stock available';

  @override
  String get vehicleHeistCatalogFilterEvent => 'Event only';

  @override
  String get vehicleHeistCatalogSortLabel => 'Sort';

  @override
  String get vehicleHeistCatalogSortValue => 'Value';

  @override
  String get vehicleHeistCatalogSortRank => 'Rank required';

  @override
  String get vehicleHeistCatalogSortRarity => 'Rarity';

  @override
  String get vehicleHeistCatalogSortName => 'Name';

  @override
  String get vehicleHeistOpsPrimaryActions => 'Quick ops';

  @override
  String get vehicleHeistOpsAdvancedActions => 'Advanced ops';

  @override
  String get vehicleHeistOpsShowDetails => 'Show intel details';

  @override
  String get vehicleHeistOpsHideDetails => 'Hide intel details';

  @override
  String get vehicleGarageStealMotorcycle => 'Steal motorcycle';

  @override
  String get vehicleGarageNoMotorcyclesInGarage => 'No motorcycles in garage';

  @override
  String get vehicleGarageHeistMotorcycleTitle => 'Vehicle Heist — Motorcycle';

  @override
  String vehicleGarageCreditBoltWithCost(String cost) {
    return 'Speed up with credits ($cost credits)';
  }

  @override
  String get vehicleGarageCreditBoltGeneric =>
      'Speed up with credits — cost shown on the next screen';

  @override
  String get vehicleGarageRepairSpeedUpUnavailable =>
      'Repair speed-up is currently unavailable.';

  @override
  String get vehicleGarageInsufficientCreditsRepairSpeedUp =>
      'Not enough credits for repair speed-up.';

  @override
  String get vehicleGarageRepairJobNotFound =>
      'This repair is already completed or no longer active.';

  @override
  String get vehicleGarageRepairSpeedUpFailed => 'Failed to speed up repair.';

  @override
  String get vehicleGarageRepairCompletedInstant =>
      'Vehicle repair completed instantly.';

  @override
  String get vehicleGarageVehicleNotDamaged => 'Vehicle is not damaged.';

  @override
  String get vehicleGarageRepairStartFailed => 'Failed to start repair.';

  @override
  String vehicleGarageRepairInstantWithCost(String cost) {
    return 'Repair instantly for $cost credits';
  }

  @override
  String get vehicleGarageRepairInstantGeneric =>
      'Repair instantly with credits';

  @override
  String get vehicleGarageMotorStorageCapacity => 'Motorcycle storage capacity';

  @override
  String vehicleGarageMotorcyclesStored(String current, String total) {
    return 'Motorcycles stored: $current/$total';
  }

  @override
  String get vehicleGarageStealVehiclesToStart =>
      'Steal vehicles to get started';

  @override
  String get vehicleGarageMotorcycleStolen => 'Motorcycle stolen';

  @override
  String vehicleGarageStealOutcomeXp(String xp) {
    return 'XP: +$xp';
  }

  @override
  String vehicleGarageStealOutcomeWanted(String level) {
    return 'Wanted: $level';
  }

  @override
  String vehicleGarageStealOutcomeJail(String minutes) {
    return 'Jail: $minutes min';
  }

  @override
  String vehicleGarageStealOutcomeBail(String amount) {
    return 'Bail: $amount';
  }

  @override
  String get vehicleGarageStealEscapedPolice =>
      'You were spotted by the police, but you managed to escape.';

  @override
  String get vehicleGarageScrapConfirm =>
      'Scrap this vehicle for parts? This cannot be undone.';

  @override
  String get vehicleGarageScrapAction => 'Scrap';

  @override
  String get vehicleGarageScrapFailed => 'Scrap failed';

  @override
  String vehicleGarageScrapSuccess(String parts, String type) {
    return 'Vehicle scrapped — +$parts $type parts';
  }

  @override
  String get vehicleGaragePartsTypeCar => 'car';

  @override
  String get vehicleGaragePartsTypeMotorcycle => 'motorcycle';

  @override
  String get vehicleGaragePartsTypeBoat => 'boat';

  @override
  String get vehicleGarageNoFuelTank => 'This vehicle has no fuel tank';

  @override
  String get vehicleGarageTankFull => 'Tank is already full';

  @override
  String get vehicleGarageRefuelTitle => 'Refuel vehicle';

  @override
  String vehicleGarageRefuelCurrent(String current, String max) {
    return 'Current fuel: ${current}L / ${max}L';
  }

  @override
  String vehicleGarageRefuelNeeded(String needed) {
    return 'Required fuel: ${needed}L';
  }

  @override
  String vehicleGarageRefuelCost(String cost) {
    return 'Cost: $cost';
  }

  @override
  String get vehicleGarageRefuelConfirmQuestion =>
      'Do you want to fully refuel this vehicle?';

  @override
  String get vehicleGarageRefuelSuccess => 'Vehicle refueled!';

  @override
  String get vehicleGarageRefuelFailed => 'Refueling failed';

  @override
  String get vehicleGarageRepairAlreadyInProgress =>
      'This vehicle is already being repaired';

  @override
  String get vehicleGarageRepairTitle => 'Repair vehicle';

  @override
  String vehicleGarageRepairCurrentCondition(String condition) {
    return 'Current condition: $condition%';
  }

  @override
  String vehicleGarageRepairDamagePercent(String percent) {
    return 'Damage: $percent%';
  }

  @override
  String vehicleGarageRepairCostLine(String cost) {
    return 'Repair cost: $cost';
  }

  @override
  String vehicleGarageRepairEstimatedTime(String duration) {
    return 'Estimated repair time: $duration';
  }

  @override
  String get vehicleGarageRepairTimerNote =>
      'Repair starts immediately, but only completes after the timer ends.';

  @override
  String get vehicleGarageRepairStartedUnavailable =>
      'Repair started. The vehicle is temporarily unavailable.';

  @override
  String get vehicleGarageRepairFailed => 'Repair failed';

  @override
  String vehicleGaragePoliceEventActive(String timeLeft) {
    return 'Police vehicle event active — $timeLeft left';
  }

  @override
  String vehicleGaragePoliceEventNext(String timeLeft) {
    return 'Next police vehicle event starts in $timeLeft';
  }

  @override
  String get vehicleGarageNoVehiclesInCountry =>
      'There are currently no vehicles available in this country.';

  @override
  String get vehicleGarageUntil => 'until';

  @override
  String get vehicleCardFuelLabel => 'Fuel';

  @override
  String get vehicleCardValueLabel => 'Value:';

  @override
  String get vehicleCardLocationLabel => 'Location:';

  @override
  String get vehicleCardInTransit => 'In transit';

  @override
  String vehicleHeistUpgradeCost(String cost) {
    return 'Upgrade ($cost)';
  }

  @override
  String vehicleHeistUpgradeRankRequired(String rank) {
    return 'Upgrade gesperrt: Rang $rank erforderlich';
  }

  @override
  String get vehicleHeistUpgradeLocked => 'Upgrade gesperrt';

  @override
  String vehicleHeistSpeedUpWithCredits(String credits) {
    return 'Beschleunigen Sie für $credits Credits';
  }

  @override
  String get vehicleHeistSpeedUpWithCreditsNextScreen =>
      'Beschleunigen (nächster Bildschirm)';

  @override
  String get vehicleHeistExpand => 'Expandieren';

  @override
  String get vehicleHeistCollapse => 'Zusammenbruch';

  @override
  String get vehicleHeistActive => 'AKTIV';

  @override
  String get vehicleHeistOff => 'aus';

  @override
  String get catalog => 'Katalog';

  @override
  String get vehicleHeistOpsHotspotRunButton => 'Hotspot ausführen';

  @override
  String get vehicleHeistOpsHotspotRunTitle => 'Hotspot-Lauf';

  @override
  String vehicleHeistOpsHotspotSuccess(String reward) {
    return 'Hotspot-Lauf abgeschlossen: +$reward';
  }

  @override
  String vehicleHeistOpsHotspotCooldownActive(String duration) {
    return 'Hotspot-Abklingzeit aktiv ($duration)';
  }

  @override
  String get vehicleHeistOpsHotspotFailedHeatIncreased =>
      'Hotspot ist fehlgeschlagen. Die Hitze nahm zu.';

  @override
  String get vehicleHeistOpsCrewOpButton => 'Crew Op';

  @override
  String get vehicleHeistOpsCrewOpTitle => 'Crew op';

  @override
  String vehicleHeistOpsCrewSuccess(String reward) {
    return 'Besatzungseinsatz abgeschlossen: Du hast $reward verdient';
  }

  @override
  String get vehicleHeistOpsCrewRequired => 'Crew erforderlich.';

  @override
  String vehicleHeistOpsCrewCooldownActive(String duration) {
    return 'Abklingzeit der Besatzungsoperation aktiv ($duration)';
  }

  @override
  String get vehicleHeistOpsCrewFailed =>
      'Der Besatzungseinsatz ist fehlgeschlagen.';

  @override
  String get vehicleHeistOpsCrewJoinToUnlock =>
      'Treten Sie einer Crew bei, um Crew-Aktionen freizuschalten';

  @override
  String get vehicleHeistOpsCrewRequiredYes => 'Crew erforderlich: ja';

  @override
  String get vehicleHeistOpsCrewRequiredNoJoinFirst =>
      'Crew erforderlich: nein (zuerst einer Crew beitreten)';

  @override
  String get vehicleHeistOpsBuyPartsButton => 'Teile kaufen';

  @override
  String get vehicleHeistOpsBuyPartsTitle => 'Teile kaufen';

  @override
  String vehicleHeistOpsBuyPartsPrompt(String type) {
    return 'Welche Teile kaufen? ($type)';
  }

  @override
  String vehicleHeistOpsPartsPurchased(String cost) {
    return 'Gekaufte Teile: -$cost';
  }

  @override
  String get vehicleHeistOpsPartsPurchaseFailed =>
      'Der Teilekauf ist fehlgeschlagen.';

  @override
  String get vehicleHeistOpsClaimContractButton => 'Anspruchsvertrag';

  @override
  String get vehicleHeistOpsClaimContractTitle => 'Anspruchsvertrag';

  @override
  String vehicleHeistOpsChopContractCompleted(String reward) {
    return 'Vertrag abgeschlossen: +$reward';
  }

  @override
  String get vehicleHeistOpsChopNoEligibleVehicle =>
      'Für diesen Vertrag ist kein geeignetes Fahrzeug im Bestand.';

  @override
  String vehicleHeistOpsChopContractCooldownActive(String duration) {
    return 'Vertragsabklingzeit aktiv ($duration)';
  }

  @override
  String get vehicleHeistOpsChopContractClaimFailed =>
      'Vertragsanspruch gescheitert.';

  @override
  String get vehicleHeistOpsInsuranceButton => 'Versicherung';

  @override
  String get vehicleHeistOpsInsuranceTitle => 'Schmuggelversicherung';

  @override
  String get vehicleHeistOpsInsuranceBody =>
      'Wählen Sie eine Deckungsstufe für diese Fahrzeugkategorie.';

  @override
  String get vehicleHeistOpsInsuranceTierBasic => 'Basic';

  @override
  String get vehicleHeistOpsInsuranceTierPro => 'Profi';

  @override
  String vehicleHeistOpsInsuranceActive(String tier, String price) {
    return 'Versicherung aktiv ($tier) für $price.';
  }

  @override
  String get vehicleHeistOpsInsurancePurchaseFailed =>
      'Der Versicherungskauf ist fehlgeschlagen.';

  @override
  String get vehicleHeistOpsCrewMatchButton => 'Crew-Match';

  @override
  String vehicleHeistOpsCrewMatchWon(String reward) {
    return 'Crew-Match gewonnen: +$reward';
  }

  @override
  String vehicleHeistOpsCrewMatchLost(String reward) {
    return 'Crew-Match verloren: +$reward Trost';
  }

  @override
  String get vehicleHeistOpsCrewMatchFailed =>
      'Das Crew-Matchmaking ist fehlgeschlagen.';

  @override
  String get vehicleHeistOpsCounterButton => 'Schalter';

  @override
  String vehicleHeistOpsCounterSuccess(String reward) {
    return 'Erfolg beim Gegenabfangen: +$reward';
  }

  @override
  String get vehicleHeistOpsCounterFailed =>
      'Gegenabfang nicht verfügbar oder fehlgeschlagen.';

  @override
  String get vehicleHeistOpsOpsContractButton => 'Ops-Vertrag';

  @override
  String get vehicleHeistOpsOpsContractTitle => 'Ops-Vertrag';

  @override
  String vehicleHeistOpsContractCompleted(String reward) {
    return 'Ops-Vertrag abgeschlossen: +$reward';
  }

  @override
  String get vehicleHeistOpsContractFailedOrCooldown =>
      'Der Ops-Vertrag ist fehlgeschlagen oder befindet sich in der Abklingzeit.';

  @override
  String get vehicleHeistOpsClaimDisputeButton => 'Anspruchsstreit';

  @override
  String get vehicleHeistOpsNoOpenClaims =>
      'Keine offenen Versicherungsansprüche.';

  @override
  String get vehicleHeistOpsNoValidClaimFound =>
      'Kein gültiger Anspruch gefunden.';

  @override
  String vehicleHeistOpsClaimApproved(String amount) {
    return 'Anspruch genehmigt: +$amount';
  }

  @override
  String vehicleHeistOpsClaimRejected(String amount) {
    return 'Anspruch abgelehnt: -$amount';
  }

  @override
  String get vehicleHeistOpsClaimResolutionFailed =>
      'Die Schadensregulierung ist fehlgeschlagen.';

  @override
  String get vehicleHeistOpsIntelTitle => 'Vehicle Ops Intelligence';

  @override
  String get vehicleHeistOpsIntelRefreshTooltip => 'Informationen auffrischen';

  @override
  String get vehicleHeistOpsIntelTapToExpand =>
      'Tippen Sie hier, um alle Aktionen zu erweitern und anzuzeigen.';

  @override
  String vehicleHeistOpsIntelHeatPill(String current, String level) {
    return 'Hitze $current ($level)';
  }

  @override
  String vehicleHeistOpsIntelPolicePill(String name) {
    return 'Polizei: $name';
  }

  @override
  String vehicleHeistOpsIntelRepPill(String level) {
    return 'Rep-Stufe $level';
  }

  @override
  String vehicleHeistOpsIntelPartsMarketPill(String trend) {
    return 'Teilemarkt: $trend';
  }

  @override
  String vehicleHeistOpsIntelHotspotLine(String name) {
    return 'Hotspot: $name';
  }

  @override
  String vehicleHeistOpsIntelHotspotRewardLine(String min, String max) {
    return 'Belohnung: $min - $max';
  }

  @override
  String get vehicleHeistOpsIntelWhyCashLine =>
      'Warum Sie Bargeld erhalten: Erfolgreiche Ops-Aktionen werden direkt in das Wallet-Bargeld ausgezahlt.';

  @override
  String vehicleHeistOpsIntelCashRangePayout(String min, String max) {
    return 'Bargeld: $min - $max';
  }

  @override
  String vehicleHeistOpsIntelYouCashRangePayout(String min, String max) {
    return 'Sie: $min - $max';
  }

  @override
  String vehicleHeistOpsIntelCashPayout(String amount) {
    return 'Bargeld: $amount';
  }

  @override
  String vehicleHeistOpsIntelContractsPayout(String count, String fromPart) {
    return 'Verträge: $count$fromPart';
  }

  @override
  String vehicleHeistOpsIntelContractsFrom(String amount) {
    return '| ab $amount';
  }

  @override
  String vehicleHeistOpsIntelPartsPricesLine(
    String car,
    String motorcycle,
    String boat,
  ) {
    return 'Teilepreise (Auto/Motorrad/Boot): $car / $motorcycle / $boat';
  }

  @override
  String vehicleHeistOpsIntelPartsMarketRefreshLine(String cooldown) {
    return 'Aktualisierung des Ersatzteilmarktes: $cooldown';
  }

  @override
  String vehicleHeistOpsIntelCrewLine(String name, String size) {
    return 'Crew: $name ($size Mitglieder)';
  }

  @override
  String vehicleHeistOpsIntelChopRewardLine(String reward) {
    return 'Vertragsbelohnung hacken: $reward';
  }

  @override
  String vehicleHeistOpsIntelInterceptWindowLine(String status) {
    return 'Abfangfenster: $status';
  }

  @override
  String vehicleHeistOpsIntelBlacklistLine(String reason) {
    return 'Schwarze Liste: $reason';
  }

  @override
  String get vehicleHeistOpsIntelBlacklistNoneLine => 'Schwarze Liste: keine';

  @override
  String vehicleHeistOpsIntelInsuranceActiveLine(String tier) {
    return 'Versicherung: $tier aktiv';
  }

  @override
  String get vehicleHeistOpsIntelInsuranceInactiveLine =>
      'Versicherung: inaktiv';

  @override
  String vehicleHeistOpsIntelCountryModifierLine(
    String name,
    String multiplier,
  ) {
    return 'Ländermodifikator: $name (${multiplier}x)';
  }

  @override
  String vehicleHeistOpsIntelCrewSeasonLine(String season, String points) {
    return 'Crew-Saison: $season | Punkte $points';
  }

  @override
  String vehicleHeistOpsIntelContractsCooldownLine(
    String count,
    String cooldown,
  ) {
    return 'Verträge: $count | Abklingzeit $cooldown';
  }

  @override
  String vehicleHeistOpsIntelCounterCooldownLine(
    String cooldown,
    String claims,
  ) {
    return 'Abklingzeit des Konters: $cooldown | offene Forderungen: $claims';
  }

  @override
  String get tuneShop => 'Tune-Shop';

  @override
  String get tuneShopIntro =>
      'Verschrotte Fahrzeuge für Teile und verbessere Geschwindigkeit, Tarnung und Panzerung. Teile werden pro Kategorie (Auto/Motorrad/Boot) gemeinsam genutzt, sodass Sie jedes Fahrzeug innerhalb derselben Kategorie tunen können.';

  @override
  String get tuneShopCarPartsLabel => 'Autoteile';

  @override
  String get tuneShopMotorcyclePartsLabel => 'Motorradteile';

  @override
  String get tuneShopBoatPartsLabel => 'Bootsteile';

  @override
  String get tuneShopEmptyTitle => 'Keine Fahrzeuge zum Tuning verfügbar';

  @override
  String get tuneShopEmptyBody =>
      'Stehlen Sie zuerst einige Fahrzeuge und verschrotten Sie einige, um Ersatzteile zu erhalten.';

  @override
  String get tuneShopVehicleTypeCar => 'Auto';

  @override
  String get tuneShopVehicleTypeMotorcycle => 'Motorrad';

  @override
  String get tuneShopVehicleTypeBoat => 'Boot';

  @override
  String get tuneShopStatSpeed => 'Geschwindigkeit';

  @override
  String get tuneShopStatStealth => 'Heimlichkeit';

  @override
  String get tuneShopStatArmor => 'Rüstung';

  @override
  String get tuneShopValueMultiplierPrefix => 'Wert x';

  @override
  String get tuneShopUpgradeButton => 'Upgrade';

  @override
  String get tuneShopMaxLabel => 'MAX';

  @override
  String get tuneShopPartsAbbrev => 'Punkte';

  @override
  String get tuneShopUpgradeCompleted => 'Upgrade abgeschlossen';

  @override
  String get tuneShopUpgradeFailed => 'Das Upgrade ist fehlgeschlagen';

  @override
  String get tuneShopLockedVehicleInTransit =>
      'Tuning gesperrt: Fahrzeug ist unterwegs.';

  @override
  String get tuneShopLockedVehicleInRepair =>
      'Tuning gesperrt: Fahrzeug wird repariert.';

  @override
  String tuneShopLockedCooldownActive(String duration) {
    return 'Tuning-Abklingzeit aktiv: $duration verbleibend.';
  }

  @override
  String get tuneShopErrorVehicleNotFound => 'Fahrzeug nicht gefunden';

  @override
  String get tuneShopErrorNotOwner =>
      'Sie sind nicht Eigentümer dieses Fahrzeugs';

  @override
  String get tuneShopErrorVehicleInTransit =>
      'Tuning gesperrt: Fahrzeug ist unterwegs.';

  @override
  String get tuneShopErrorVehicleInRepair =>
      'Tuning gesperrt: Fahrzeug wird repariert.';

  @override
  String get tuneShopErrorInsufficientFunds => 'Nicht genug Geld';

  @override
  String get tuneShopErrorInsufficientParts => 'Nicht genügend Teile';

  @override
  String get tuneShopErrorStatMaxed => 'Diese Tuning-Stufe ist maximal';

  @override
  String tuneShopErrorCooldownActive(String duration) {
    return 'Tuning-Abklingzeit aktiv: $duration verbleibend.';
  }

  @override
  String tuneShopErrorConcurrencyLimit(String max, String active) {
    return 'Grenzwert erreicht: max. $max gleichzeitiges Tuning, derzeit $active.';
  }

  @override
  String get tuneShopErrorInvalidStat => 'Ungültige Tuning-Statistik';

  @override
  String get territory => 'Gebiet';

  @override
  String get achievements => 'Erfolge';

  @override
  String get menuCrackVault => 'Knacke den Tresor';

  @override
  String get vaultHeroTagline =>
      'Erraten Sie den Code und gewinnen Sie tolle Preise.';

  @override
  String vaultSeasonLabel(String range) {
    return 'Saison: $range';
  }

  @override
  String get vaultYourCredits => 'Ihre Credits';

  @override
  String get vaultChooseStake => 'Wählen Sie Ihren Einsatz';

  @override
  String vaultStakeCredits(int stake) {
    String _temp0 = intl.Intl.pluralLogic(
      stake,
      locale: localeName,
      other: '$stake Credits',
      one: '$stake Credit',
    );
    return '$_temp0';
  }

  @override
  String vaultExpectedPrize(int reward) {
    return 'Erwarteter Preis: +$reward Credits';
  }

  @override
  String get vaultCodeLabel => 'Code';

  @override
  String get vaultSubmitStake => 'Einsatz setzen';

  @override
  String get vaultWrongCodesTitle => 'Falsche Codes (diesen Monat)';

  @override
  String get vaultShowWrongCodes => 'Anzeigen';

  @override
  String get vaultHideWrongCodes => 'Ausblenden';

  @override
  String get vaultNoWrongCodesYet =>
      'Es wurden noch keine falschen Codes gespeichert.';

  @override
  String get couldNotLoadVaultStatus => 'Status konnte nicht geladen werden.';

  @override
  String get vaultEnterFourDigitCode => 'Geben Sie einen 4-stelligen Code ein.';

  @override
  String get vaultAttemptSuccessGeneric => 'Erfolg.';

  @override
  String get vaultAttemptFailedGeneric => 'Fehlgeschlagen.';

  @override
  String get vaultAttemptFailedRetry =>
      'Fehlgeschlagen. Bitte versuchen Sie es erneut.';

  @override
  String dashboardNewMessagesCount(int count) {
    return '$count neue Nachrichten';
  }

  @override
  String get rankProgress => 'Rangfortschritt';

  @override
  String get cash => 'Kasse';

  @override
  String get sessionRecap => 'Zusammenfassung der Sitzung';

  @override
  String get nameLabel => 'Name';

  @override
  String get countryLabel => 'Land';

  @override
  String get wantedLevel => 'Gesuchtes Level';

  @override
  String get fbiHeat => 'FBI-Hitze';

  @override
  String get properties => 'Eigenschaften';

  @override
  String get vehicles => 'Fahrzeuge';

  @override
  String get netWorth => 'Nettovermögen';

  @override
  String get securityLabel => 'Sicherheit';

  @override
  String get noSecurity => 'Keine Sicherheit';

  @override
  String get weaponLabel => 'Waffe';

  @override
  String get vehicleLabel => 'Fahrzeug';

  @override
  String get none => 'Keiner';

  @override
  String get statistics => 'Statistiken';

  @override
  String get breakouts => 'Ausbrüche';

  @override
  String get murders => 'Morde';

  @override
  String get hitlistContracts => 'Hitlist-Verträge';

  @override
  String get carsStolen => 'Autos gestohlen';

  @override
  String get boatsStolen => 'Boote gestohlen';

  @override
  String get crimeAttempts => 'Kriminalversuche';

  @override
  String get successful => 'Erfolgreich';

  @override
  String get jobAttempts => 'Arbeitsversuche';

  @override
  String get streetProstitutes => 'Straßenprostituierte';

  @override
  String get rldProstitutes => 'RLD-Prostituierte';

  @override
  String get travels => 'Reisen';

  @override
  String get bullets => 'Kugeln';

  @override
  String get moneyStatusLabel => 'Geldstatus';

  @override
  String get moneyStatusPoor => 'Arm';

  @override
  String get moneyStatusRising => 'Aufstand';

  @override
  String get moneyStatusRich => 'Reich';

  @override
  String get moneyStatusMultimillionaire => 'Multimillionär';

  @override
  String get rankBeginner => 'Anfängerin';

  @override
  String get rankCriminal => 'Kriminell';

  @override
  String get rankGangster => 'Gangster';

  @override
  String get rankMafioso => 'Mafioso';

  @override
  String get rankEmptySuit => 'Leerer Anzug';

  @override
  String get rankDeliveryBoy => 'Bote';

  @override
  String get rankPicciotto => 'Picciotto';

  @override
  String get rankShoplifter => 'Ladendieb';

  @override
  String get rankPickpocket => 'Taschendieb';

  @override
  String get rankThief => 'Dieb';

  @override
  String get rankAssociate => 'Assoziieren';

  @override
  String get rankCadet => 'Kadett';

  @override
  String get rankSoldier => 'Soldat';

  @override
  String get rankSwindler => 'Schwindler';

  @override
  String get rankAssassin => 'Attentäter';

  @override
  String get rankLocalChief => 'Lokaler Chef';

  @override
  String get rankChief => 'Chef';

  @override
  String get rankDrugLord => 'Drogenboss';

  @override
  String get rankGodfather => 'Pate';

  @override
  String get rankDon => 'Don';

  @override
  String get rankOverlord => 'Oberherr';

  @override
  String get rankLegend => 'Legende';

  @override
  String get rankUnknown => 'Unbekannt';

  @override
  String get dailyGoalTitle_crime_3 => 'Begehen Sie 3 Verbrechen';

  @override
  String get dailyGoalTitle_job_2 => '2 Mal arbeiten';

  @override
  String get dailyGoalTitle_vehicle_theft_1 => 'Stehlen Sie 1 Fahrzeug';

  @override
  String get dailyGoalTitle_travel_1 => 'Schließe 1 Reise ab';

  @override
  String get dailyGoalTitle_training_combo_1 =>
      'Train gym + shooting range (same day)';

  @override
  String get dailyGoalTitle_weekly_crime_20 => 'Wöchentlich: 20 Verbrechen';

  @override
  String get dailyGoalTitle_weekly_job_10 => 'Wöchentlich: 10 Mal arbeiten';

  @override
  String get dailyGoalTitle_weekly_vehicle_theft_5 =>
      'Wöchentlich: 5 Fahrzeuge stehlen';

  @override
  String get dailyGoalTitle_weekly_travel_3 => 'Wöchentlich: 3 Reisen';

  @override
  String dailyGoalReward(String cash, String xp) {
    return 'Belohnung: +$cash und +$xp XP';
  }

  @override
  String get justNow => 'Soeben';

  @override
  String secondsAgo(String seconds) {
    return 'Vor ${seconds}s';
  }

  @override
  String minutesAgo(String count) {
    return 'Vor $count Minuten';
  }

  @override
  String hoursAgo(String count) {
    return 'Vor $count Stunden';
  }

  @override
  String get last10EventsLive => 'Die letzten 10 Ereignisse (live).';

  @override
  String get noEventsYetSession =>
      'In dieser Sitzung gibt es noch keine Ereignisse.';

  @override
  String get clearRecap => 'Klare Zusammenfassung';

  @override
  String get weeklyGoalClaimed => 'Wochenziel erreicht!';

  @override
  String get dailyGoalClaimed => 'Tagesziel erreicht!';

  @override
  String get failed => 'Fehlgeschlagen.';

  @override
  String get failedPleaseTryAgain =>
      'Fehlgeschlagen. Bitte versuchen Sie es erneut.';

  @override
  String get dailyGoals => 'Tägliche Ziele';

  @override
  String get weeklyGoals => 'Wöchentliche Ziele';

  @override
  String get claimed => 'Behauptet';

  @override
  String get ready => 'Bereit';

  @override
  String get claim => 'Beanspruchen';

  @override
  String readyToClaim(String count) {
    return '$count bereit zur Inanspruchnahme';
  }

  @override
  String completedOutOfTotal(String completed, String total) {
    return '$completed/$total abgeschlossen';
  }

  @override
  String get noPlayerData => 'Keine Spielerdaten';

  @override
  String get economy24h => 'Wirtschaft 24h';

  @override
  String get grossIncome => 'Bruttoeinkommen';

  @override
  String get propertySpend => 'Immobilienausgaben';

  @override
  String get netCashflow => 'Netto-Cashflow';

  @override
  String get trendVsPrevious => 'Trend vs. Vorheriger';

  @override
  String get activity7d => 'Aktivität 7d';

  @override
  String get vehicleThefts => 'Fahrzeugdiebstähle';

  @override
  String get opsOverview => 'Ops-Übersicht';

  @override
  String get activeCooldowns => 'Aktive Abklingzeiten';

  @override
  String get longestTimer => 'Längster Timer';

  @override
  String get activeProduction => 'Aktive Produktion';

  @override
  String get productionReadyIn => 'Die Produktion ist fertig';

  @override
  String get nightclubEvents => 'Nightclub-Events';

  @override
  String get nextEventStartsIn => 'Die nächste Veranstaltung beginnt in';

  @override
  String get vehiclesActiveListedTransit =>
      'Fahrzeuge aktiv/gelistet/im Transit';

  @override
  String get livePlayerEvents => 'Live-Spielerevents';

  @override
  String get openEvents => 'Offene Veranstaltungen';

  @override
  String get notificationsAndRisk => 'Benachrichtigungen und Risiko';

  @override
  String get unreadDm => 'Ungelesene DM';

  @override
  String get supportWaitingOnYou => 'Der Support wartet auf Sie';

  @override
  String get eventsLast24h => 'Die Veranstaltungen dauern 24 Stunden';

  @override
  String get riskScore => 'Risikobewertung';

  @override
  String get recruitProstitute => 'Prostituierte rekrutieren';

  @override
  String get free => 'FREI';

  @override
  String get crewWars => 'Besatzungskriege';

  @override
  String get status => 'Status';

  @override
  String get canDeclare => 'Kann erklären';

  @override
  String get yes => 'Ja';

  @override
  String get no => 'NEIN';

  @override
  String get type => 'Typ';

  @override
  String get opponent => 'Gegnerin';

  @override
  String get crewPoints => 'Besatzungspunkte';

  @override
  String get warRank => 'Kriegsrang';

  @override
  String get seasonRank => 'Saisonrang';

  @override
  String get openTargets => 'Offene Ziele';

  @override
  String get phaseEndsIn => 'Phase endet in';

  @override
  String get crewTerritory => 'Besatzungsgebiet';

  @override
  String get regions => 'Regionen';

  @override
  String get countriesCaptured => 'Länder erobert';

  @override
  String get payout => 'Auszahlung';

  @override
  String get earningPerHour => 'Jetzt pro Stunde verdienen';

  @override
  String get earningPerDay => 'Jetzt pro Tag verdienen';

  @override
  String get totalEarned => 'Insgesamt verdient';

  @override
  String get crewBank => 'Mannschaftsbank';

  @override
  String get dashboardEconomy24h => 'Wirtschaft 24 h';

  @override
  String get dashboardGrossIncome => 'Bruttoeinkommen';

  @override
  String get dashboardPropertySpend => 'Immobilienausgaben';

  @override
  String get dashboardNetCashflow => 'Netto-Cashflow';

  @override
  String get dashboardTrendVsPrevious => 'Trend vs. Vorperiode';

  @override
  String get dashboardActivity7d => 'Aktivität (7 Tage)';

  @override
  String get dashboardVehicleThefts => 'Fahrzeugdiebstähle';

  @override
  String get dashboardOpsOverview => 'Operationsübersicht';

  @override
  String get dashboardActiveCooldowns => 'Aktive Abklingzeiten';

  @override
  String get dashboardLongestTimer => 'Längster Timer';

  @override
  String get dashboardActiveProduction => 'Aktive Produktion';

  @override
  String get dashboardProductionReadyIn => 'Produktion fertig in';

  @override
  String get dashboardNightclubEvents => 'Nachtclub-Events';

  @override
  String get dashboardNextEventStartsIn => 'Nächstes Event beginnt in';

  @override
  String get dashboardVehiclesActiveListedTransit =>
      'Fahrzeuge aktiv/inseriert/unterwegs';

  @override
  String get dashboardLivePlayerEvents => 'Live-Spieler-Events';

  @override
  String get dashboardOpenEvents => 'Offene Events';

  @override
  String get dashboardNotificationsAndRisk => 'Benachrichtigungen & Risiko';

  @override
  String get dashboardUnreadDm => 'Ungelesene DMs';

  @override
  String get dashboardSupportWaitingOnYou => 'Support wartet auf dich';

  @override
  String get dashboardEventsLast24h => 'Events der letzten 24 Std.';

  @override
  String get dashboardRiskScore => 'Risikowert';

  @override
  String get dashboardRecruitProstitute => 'Prostituierte rekrutieren';

  @override
  String get dashboardWarTheater => 'Kriegstheater';

  @override
  String get dashboardHotRegions => 'Heiße Regionen';

  @override
  String get dashboardCrewWars => 'Crew-Kriege';

  @override
  String get dashboardStatusLabel => 'Status';

  @override
  String get dashboardCanDeclare => 'Kriegserklärung möglich';

  @override
  String get dashboardTypeLabel => 'Typ';

  @override
  String get dashboardOpponent => 'Gegner';

  @override
  String get dashboardCrewPoints => 'Crew-Punkte';

  @override
  String get dashboardWarRank => 'Kriegsrang';

  @override
  String get dashboardSeasonRank => 'Saisonrang';

  @override
  String get dashboardOpenTargets => 'Offene Ziele';

  @override
  String get dashboardPhaseEndsIn => 'Phase endet in';

  @override
  String dashboardJailStatusIn(String duration) {
    return 'Im Gefängnis ($duration)';
  }

  @override
  String get dashboardCrewWarStatusPreparing => 'In Vorbereitung';

  @override
  String get dashboardCrewWarStatusActive => 'Aktiv';

  @override
  String get dashboardCrewWarStatusLockdown => 'Sperre';

  @override
  String get dashboardCrewWarStatusResolved => 'Beendet';

  @override
  String get dashboardCrewWarStatusArchived => 'Archiviert';

  @override
  String get dashboardCrewWarStatusCancelled => 'Abgebrochen';

  @override
  String get dashboardCrewWarStatusNone => 'Kein aktiver Krieg';

  @override
  String get dashboardCrewWarTypeKill => 'Eliminationskrieg';

  @override
  String get dashboardCrewWarTypeEconomy => 'Wirtschaftskrieg';

  @override
  String get dashboardCrewWarTypeTerritory => 'Territorialkrieg';

  @override
  String get dashboardCrewWarTypeTotal => 'Totaler Krieg';

  @override
  String get dashboardClicks => 'Klicks';

  @override
  String get dashboardValueNotAvailable => '—';

  @override
  String get dashboardPremiumOfferDefaultTitle => 'Sonderangebot';

  @override
  String get dashboardCrewWarTypeUnknown => '—';

  @override
  String get dashboardTerritoryIncomeNotConfigured => 'nicht konfiguriert';

  @override
  String dashboardTerritoryIncomeEveryHours(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: 'alle $hours Stunden',
      one: 'stündlich',
    );
    return '$_temp0';
  }

  @override
  String dashboardTerritoryIncomeEveryMinutes(int minutes) {
    return 'alle $minutes Min';
  }

  @override
  String get dashboardCrewTerritory => 'Crew-Territorium';

  @override
  String get dashboardRegions => 'Regionen';

  @override
  String get dashboardCountriesCaptured => 'Eroberte Länder';

  @override
  String get dashboardPayout => 'Auszahlung';

  @override
  String get dashboardEarningPerHour => 'Verdienst pro Stunde (aktuell)';

  @override
  String get dashboardEarningPerDay => 'Verdienst pro Tag (aktuell)';

  @override
  String get dashboardTotalEarned => 'Gesamt verdient';

  @override
  String get dashboardVehicleOps => 'Fahrzeug-Ops';

  @override
  String get dashboardKillProgress => 'Kill-Fortschritt';

  @override
  String get vehicleOpsHeat => 'Hitze';

  @override
  String get vehicleOpsHeatLevelLow => 'Niedrig';

  @override
  String get vehicleOpsHeatLevelMedium => 'Mittel';

  @override
  String get vehicleOpsHeatLevelHigh => 'Hoch';

  @override
  String get vehicleOpsReputation => 'Rep';

  @override
  String get vehicleOpsPartsTrendUp => 'Teilemarkt steigt';

  @override
  String get vehicleOpsPartsTrendDown => 'Teilemarkt sinkt';

  @override
  String get vehicleOpsPartsTrendStable => 'Teilemarkt stabil';

  @override
  String get vehicleOpsBlacklistActive => 'Blacklist aktiv';

  @override
  String get vehicleOpsNoBlacklist => 'Keine schwarze Liste';

  @override
  String get prisonTitle => 'Gefängnis';

  @override
  String get prisonLoadFailed => 'Gefangene konnten nicht geladen werden';

  @override
  String get prisonNoPrisonersFound => 'Keine Gefangenen gefunden';

  @override
  String prisonRankLine(String rank) {
    return 'Rang: $rank';
  }

  @override
  String prisonRankYouLine(String rank) {
    return 'Rang: $rank · Du';
  }

  @override
  String prisonRemainingTimeLine(String duration) {
    return 'Verbleibende Zeit: $duration';
  }

  @override
  String prisonBailLine(String amount) {
    return 'Kaution: $amount €';
  }

  @override
  String get prisonPayBailButton => 'Kaution zahlen';

  @override
  String get prisonBuyOutButton => 'Auskaufen';

  @override
  String get prisonAttemptEscapeButton => 'Fluchtversuch';

  @override
  String get prisonJailbreakButton => 'Jailbreak';

  @override
  String get prisonActionFailed => '❌ Aktion fehlgeschlagen';

  @override
  String prisonBuyoutSuccess(String username, String amount) {
    return '✅ Ausgekauft $username für ⟦1€⟧';
  }

  @override
  String prisonPaidBailSuccess(String amount) {
    return '✅ Sie haben eine Kaution in Höhe von ⟦0 €⟧ bezahlt und sind frei';
  }

  @override
  String get prisonEscapeSuccess => '✅ Flucht gelungen! Du bist frei.';

  @override
  String prisonEscapeFailed(String penalty) {
    return '❌ Flucht fehlgeschlagen. Satz um $penalty verlängert.';
  }

  @override
  String prisonCooldownActive(String duration) {
    return '⏱️ Abklingzeit aktiv: warten $duration';
  }

  @override
  String get prisonEscapeGenericFailure => '❌ Flucht fehlgeschlagen';

  @override
  String get prisonErrorInsufficientFunds => '❌ Nicht genug Geld';

  @override
  String get prisonErrorTargetNotJailed => '❌ Ziel ist nicht mehr im Gefängnis';

  @override
  String get prisonErrorCannotBuyoutSelf => '❌ Du kannst dich nicht auskaufen';

  @override
  String get prisonErrorPlayerNotFound => '❌ Spieler nicht gefunden';

  @override
  String get prisonJailbreakSuccess =>
      '✅ Jailbreak gelungen! Der Gefangene ist frei.';

  @override
  String prisonJailbreakCaught(String minutes) {
    return '🚔 Der Jailbreak ist fehlgeschlagen, Sie wurden erwischt ($minutes Min. Gefängnis).';
  }

  @override
  String get prisonJailbreakFailed =>
      '❌ Jailbreak fehlgeschlagen. Der Gefangene ist immer noch eingesperrt.';

  @override
  String get prisonErrorRescuerJailed => '❌Du bist selbst im Gefängnis';

  @override
  String get prisonJailbreakGenericFailure => '❌ Jailbreak fehlgeschlagen';

  @override
  String get crewJailbreakTitle => '🚔 Inhaftierte Crew';

  @override
  String get crewJailbreakLoadFailed =>
      'Inhaftierte Mitglieder konnten nicht geladen werden';

  @override
  String get crewJailbreakEmptyTitle => '🎉 Niemand im Gefängnis!';

  @override
  String get crewJailbreakEmptyBody => 'Alle Besatzungsmitglieder sind frei';

  @override
  String crewJailbreakAttemptFor(String username) {
    return 'Jailbreak-Versuch für $username:';
  }

  @override
  String get crewJailbreakRiskSuccess => 'Bei Erfolg: Spieler befreit!';

  @override
  String get crewJailbreakRiskFailChance =>
      'Bei Fehlschlag: 60 % Chance, erwischt zu werden';

  @override
  String get crewJailbreakRiskCaughtPenalty =>
      'Gefangen: 30-60 Minuten Gefängnis + gesucht +10';

  @override
  String get crewJailbreakTip =>
      'Die Erfolgschance erhöht sich mit dem Rang- und Besatzungsbonus!';

  @override
  String get crewJailbreakAttemptButton => 'Versuchen Sie einen Jailbreak';

  @override
  String get crewJailbreakActionFailed => '❌ Aktion fehlgeschlagen';

  @override
  String crewJailbreakMemberJailTimeLine(String minutes) {
    return '⏱️ $minutes Minuten im Gefängnis';
  }

  @override
  String get crewJailbreakRescueButton => 'Rettung';

  @override
  String get crewRoleLeader => 'Führerin';

  @override
  String get crewRoleCoLeader => 'Co-Leiter';

  @override
  String get crewRoleMember => 'Mitglied';

  @override
  String get vehicleOpsHotspot => 'Hotspot';

  @override
  String get vehicleOpsCrew => 'Crew';

  @override
  String get vehicleOpsCrewMatch => 'Crew-Match';

  @override
  String get vehicleOpsChop => 'Hacken';

  @override
  String get vehicleOpsContract => 'Vertrag';

  @override
  String get vehicleOpsCounter => 'Schalter';

  @override
  String get vehicleOpsContracts => 'Verträge';

  @override
  String get vehicleOpsClaims => 'Ansprüche';

  @override
  String get vehicleOpsSeason => 'Jahreszeit';

  @override
  String get dashboardCar => 'Auto';

  @override
  String get dashboardMotorcycle => 'Motorrad';

  @override
  String get dashboardBoat => 'Boot';

  @override
  String get dashboardCrewAccess => 'Zugang für die Crew';

  @override
  String get dashboardCrewRole => 'Crew-Rolle';

  @override
  String get dashboardUnavailable => 'nicht verfügbar';

  @override
  String get vehicleOps => 'Fahrzeugbetrieb';

  @override
  String get car => 'Auto';

  @override
  String get motorcycle => 'Motorrad';

  @override
  String get boat => 'Boot';

  @override
  String get crewAccess => 'Zugang für die Crew';

  @override
  String get crewRole => 'Crew-Rolle';

  @override
  String get unavailable => 'nicht verfügbar';

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
  String get avatarChangeFailed => 'Avatar konnte nicht geändert werden';

  @override
  String get settingsMyPortraits => 'Meine Porträts';

  @override
  String get settingsPortraitFromSelfieTitle => 'Porträt vom Selfie';

  @override
  String settingsPortraitFromSelfieSubtitle(int credits) {
    return 'Verwandeln Sie ein Selfie in ein Porträt im Gangster-Stil. Jeweils $credits Credits.';
  }

  @override
  String settingsPortraitUploadConfirm(int credits) {
    return 'Dies kostet $credits Credits. Weitermachen?';
  }

  @override
  String get settingsPortraitConsentLabel =>
      'Ich bin damit einverstanden, dass mein Foto zu einem stilisierten Porträt im Spiel verarbeitet wird (siehe Nutzungsbedingungen). Ich bin nicht unter 13.';

  @override
  String settingsPortraitInsufficientCredits(int need, int have) {
    return 'Nicht genügend Credits (Sie benötigen $need, Sie haben $have).';
  }

  @override
  String get settingsPortraitCreated =>
      'Porträt zu Ihrer Bibliothek hinzugefügt!';

  @override
  String get settingsPortraitGenerationFailed =>
      'Porträt konnte nicht erstellt werden. Versuchen Sie es mit einem anderen Foto.';

  @override
  String get settingsPortraitSelectActive => 'Als Avatar verwenden';

  @override
  String get settingsPortraitDelete => 'Porträt entfernen';

  @override
  String settingsPortraitLimitReached(int max) {
    return 'Porträtlimit erreicht ($max).';
  }

  @override
  String get settingsPortraitUsingCustom => 'Benutzerdefiniertes Porträt aktiv';

  @override
  String get settingsPresetAvatars => 'Voreingestellte Avatare';

  @override
  String get settingsPortraitDeleteConfirm =>
      'Dieses Porträt aus Ihrer Bibliothek entfernen?';

  @override
  String get settingsPortraitGenerating =>
      'Erstellen Ihres Porträts… Dies kann einige Minuten dauern. Bitte warten.';

  @override
  String get settingsPortraitDeleteHint =>
      'Tap a portrait to use it as your avatar. Tap the trash icon to remove it.';

  @override
  String get settingsPortraitDownloadFailed =>
      'Das Porträt konnte nicht heruntergeladen werden. Überprüfen Sie Ihre Verbindung und versuchen Sie es erneut.';

  @override
  String get settingsPortraitDownloadTooltip =>
      'Laden Sie dieses Porträt als PNG herunter';

  @override
  String get settingsPortraitDeleteTooltip =>
      'Entfernen Sie dieses Porträt aus Ihrer Bibliothek';

  @override
  String get settingsPortraitStyleSection => 'Porträt-Look';

  @override
  String get settingsPortraitStyleHint =>
      'Bei der Generierung wird das Geschlecht Ihres Kontos aus der Registrierung verwendet. Alle Stile bleiben dem Spiel angemessen.';

  @override
  String get settingsPortraitStyleClassicNoir => 'Klassischer Noir';

  @override
  String get settingsPortraitStyleStreetCasual => 'Straßenlässig';

  @override
  String get settingsPortraitStyleSharpSuit => 'Scharfer Anzug';

  @override
  String get settingsPortraitStyleVelvetCharm => 'Abendlicher Glamour';

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
  String get usernameChangeFailed =>
      'Benutzername konnte nicht geändert werden';

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
  String get settingsSystemNotificationsTitle =>
      'Systembenachrichtigungen für App';

  @override
  String get settingsPushPermissionAllowedLinked =>
      'Berechtigung: erlaubt, Gerät verknüpft';

  @override
  String get settingsPushPermissionAllowedRelinking =>
      'Berechtigung: erlaubt, Gerät verbindet sich erneut';

  @override
  String get settingsPushPermissionProvisionalLinked =>
      'Erlaubnis: vorläufig, Gerät verknüpft';

  @override
  String get settingsPushPermissionProvisionalRelinking =>
      'Erlaubnis: vorläufig, Gerät verbindet sich erneut';

  @override
  String get settingsPushPermissionDenied => 'Zugriff verweigert';

  @override
  String get settingsPushPermissionNotRequested =>
      'Erlaubnis: noch nicht beantragt';

  @override
  String get settingsPushPermissionUnknown => 'Erlaubnis: unbekannt';

  @override
  String get settingsDeviceTokenRegistered =>
      'Auf dem Server registriertes Geräte-Token';

  @override
  String get settingsDeviceTokenNotRegistered =>
      'Noch kein Geräte-Token registriert';

  @override
  String get settingsPushHelpText =>
      'Über diese Schaltfläche können Sie die Browser-/iPhone-Berechtigung erneut anfordern und Ihren Push-Token registrieren.';

  @override
  String get working => 'Arbeiten...';

  @override
  String get settingsEnablePush => 'Push aktivieren';

  @override
  String get settingsPushEnabledToast =>
      'Push-Benachrichtigungen aktiviert. Es werden nun neue Benachrichtigungen entgegengenommen.';

  @override
  String get settingsPushDisabledInSystem =>
      'Push ist in Ihren Browser-/iPhone-Einstellungen deaktiviert. Aktivieren Sie Benachrichtigungen für diese App.';

  @override
  String settingsEnablePushFailed(String error) {
    return 'Push-Benachrichtigungen konnten nicht aktiviert werden: $error';
  }

  @override
  String get settingsPlayerEventsTitle => 'Spielerereignisse';

  @override
  String get settingsPushLivePlayerEventsTitle => 'Push: Live-Spielerevents';

  @override
  String get settingsPushLivePlayerEventsSubtitle =>
      'Beginn und Ende wiederkehrender Wettkampfveranstaltungen (z. B. Wertungsrunden).';

  @override
  String get settingsCryptoNotificationsTitle => 'Krypto-Benachrichtigungen';

  @override
  String get settingsCryptoPushTradesTitle => 'Push: Trades';

  @override
  String get settingsCryptoPushTradesSubtitle =>
      'Push-Benachrichtigung für Kauf-/Verkaufsgeschäfte';

  @override
  String get settingsCryptoPushPriceAlertsTitle => 'Push: Preisalarme';

  @override
  String get settingsCryptoPushPriceAlertsSubtitle =>
      'Push-Benachrichtigung für relevante Preisbewegungen';

  @override
  String get settingsCryptoPushOrdersTitle => 'Push: Befehle';

  @override
  String get settingsCryptoPushOrdersSubtitle =>
      'Push-Benachrichtigung, wenn eine Bestellung ausgelöst oder ausgeführt wird';

  @override
  String get settingsCryptoPushMissionsTitle => 'Push: Missionen';

  @override
  String get settingsCryptoPushMissionsSubtitle =>
      'Push-Benachrichtigung, wenn eine Krypto-Mission abgeschlossen ist';

  @override
  String get settingsCryptoPushLeaderboardTitle => 'Push: Bestenliste';

  @override
  String get settingsCryptoPushLeaderboardSubtitle =>
      'Push-Benachrichtigung für Krypto-Bestenlisten-Belohnungen';

  @override
  String get settingsCryptoInAppTradesTitle => 'In-App: Trades';

  @override
  String get settingsCryptoInAppTradesSubtitle =>
      'Zeigen Sie Fachveranstaltungen in Ihrem Event-Feed an';

  @override
  String get settingsCryptoInAppPriceAlertsTitle => 'In-App: Preisalarme';

  @override
  String get settingsCryptoInAppPriceAlertsSubtitle =>
      'Zeigen Sie Preisalarm-Ereignisse in Ihrem Ereignis-Feed an';

  @override
  String get settingsCryptoInAppOrdersTitle => 'In-App: Bestellungen';

  @override
  String get settingsCryptoInAppOrdersSubtitle =>
      'Zeigen Sie Bestellereignisse in Ihrem Ereignis-Feed an';

  @override
  String get settingsCryptoInAppMissionsTitle => 'In-App: Missionen';

  @override
  String get settingsCryptoInAppMissionsSubtitle =>
      'Zeigen Sie Missionsabschlüsse in Ihrem Event-Feed an';

  @override
  String get settingsCryptoInAppLeaderboardTitle => 'In-App: Bestenliste';

  @override
  String get settingsCryptoInAppLeaderboardSubtitle =>
      'Zeigen Sie Bestenlistenbelohnungen in Ihrem Event-Feed an';

  @override
  String get settingsAvatarChangeWeeklyLimit =>
      'Sie können Ihren Avatar nur einmal pro Woche ändern';

  @override
  String get settingsUsernameChangeMonthlyLimit =>
      'Sie können Ihren Benutzernamen nur einmal pro Monat ändern';

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
  String get foodHunger => 'Hunger';

  @override
  String get foodThirst => 'Thirst';

  @override
  String foodRestoresHunger(int value) {
    return '+$value hunger';
  }

  @override
  String foodRestoresThirst(int value) {
    return '+$value thirst';
  }

  @override
  String get foodNeedsHint =>
      'Hunger und Durst sinken langsam. Iss und trink rechtzeitig.';

  @override
  String get friends => 'Freundinnen';

  @override
  String get friendActivity => 'Freundesaktivität';

  @override
  String get friendsUiTabActivity => 'Aktivität';

  @override
  String get friendsUiTabRequests => 'Anfragen';

  @override
  String get friendsUiTabSearch => 'Suchen';

  @override
  String get friendsUiEmptyListTitle => 'Noch keine Freunde';

  @override
  String get friendsUiEmptyListSubtitle =>
      'Suchen Sie nach Spielern und fügen Sie sie als Freunde hinzu!';

  @override
  String get friendsUiNoRequests => 'Keine Anfragen';

  @override
  String friendsUiLineRank(String rank) {
    return 'Rang: $rank';
  }

  @override
  String friendsUiLineLocation(String location) {
    return 'Standort: $location';
  }

  @override
  String friendsUiLineHealth(String percent) {
    return 'Gesundheit: $percent %';
  }

  @override
  String friendsUiLineFriendsSince(String date) {
    return 'Freunde seit: $date';
  }

  @override
  String get friendsUiRemoveDialogTitle => 'Freund entfernen';

  @override
  String get friendsUiRemoveDialogBody =>
      'Möchten Sie diesen Freund wirklich entfernen?';

  @override
  String get friendsUiRemoveConfirm => 'Entfernen';

  @override
  String get friendsUiBlockDialogTitle => 'Spieler blockieren';

  @override
  String friendsUiBlockDialogBody(String username) {
    return 'Sind Sie sicher, dass Sie $username blockieren möchten? Sie können keine Nachrichten senden oder empfangen.';
  }

  @override
  String get friendsUiBlockButton => 'Block';

  @override
  String get friendsUiSnackRequestSent => 'Freundschaftsanfrage gesendet';

  @override
  String get friendsUiSnackRequestAccepted => 'Freundschaftsanfrage angenommen';

  @override
  String get friendsUiSnackRequestRejected => 'Freundschaftsanfrage abgelehnt';

  @override
  String get friendsUiSnackFriendRemoved => 'Freund entfernt';

  @override
  String get friendsUiSnackPlayerBlocked => 'Spieler blockiert';

  @override
  String friendsUiSnackError(String details) {
    return 'Fehler: $details';
  }

  @override
  String get friendsUiSearchLabel => 'Spieler suchen';

  @override
  String get friendsUiSearchHint => 'Geben Sie mindestens 2 Zeichen ein';

  @override
  String get friendsUiSearchMinChars =>
      'Geben Sie für die Suche mindestens 2 Zeichen ein';

  @override
  String get friendsUiNoPlayersFound => 'Keine Spieler gefunden';

  @override
  String get friendsUiMenuBlock => 'Block';

  @override
  String get friendsUiMenuRemove => 'Entfernen';

  @override
  String get friendsUiChipFriend => 'Freundin';

  @override
  String get friendsUiChipPending => 'Ausstehend';

  @override
  String get friendsUiAccept => 'Akzeptieren';

  @override
  String get friendsUiReject => 'Ablehnen';

  @override
  String get friendsUiActivityEmpty => 'Noch keine Freundesaktivität';

  @override
  String friendsUiActivityLevel(String level) {
    return 'Level $level';
  }

  @override
  String friendsUiLineCrew(String name) {
    return 'Crew: $name';
  }

  @override
  String get crewUiAppCrews => 'Besatzungen';

  @override
  String get crewUiTabMyCrew => 'Überblick';

  @override
  String get crewUiTabCrewHq => 'Hauptquartier und Upgrades';

  @override
  String get crewUiTabStorageHub => 'Lagerung';

  @override
  String get crewUiTabMembers => 'Mitglieder';

  @override
  String get crewUiTabWarRoom => 'Kriegsraum';

  @override
  String get crewUiTabCrewMissions => 'Crew-Missionen';

  @override
  String get crewUiTabCarStorage => 'Auto-/Motorradaufbewahrung';

  @override
  String get crewUiTabBoatStorage => 'Bootslagerung';

  @override
  String get crewUiTabWeaponStorage => 'Waffenlagerung';

  @override
  String get crewUiTabAmmoStorage => 'Munitionslager';

  @override
  String get crewUiTabDrugStorage => 'Arzneimittellagerung';

  @override
  String get crewUiTabCashStorage => 'Bargeldaufbewahrung';

  @override
  String get crewUiTabAllCrews => 'Besatzungen';

  @override
  String get crewUiTabChat => 'Chatten';

  @override
  String get crewUiActionCreateCrewShort => 'Crew erstellen (50.000 €)';

  @override
  String get crewUiStateNotInCrewYet => 'Du bist noch nicht in einer Crew';

  @override
  String get crewUiActionCreateCrew => 'Crew erstellen (50.000 €)';

  @override
  String get crewUiLabelCrewBank => 'Crew-Bank:';

  @override
  String get crewUiLabelDeposit => 'Kaution';

  @override
  String get crewUiLabelWithdraw => 'Zurückziehen';

  @override
  String get crewUiLabelMyTrustScore => 'Mein Vertrauenswert:';

  @override
  String get crewUiActionDeleteCrew => 'Crew löschen';

  @override
  String get crewUiLabelCrewStats => 'Besatzungsstatistiken:';

  @override
  String get crewUiActionLeaveCrew => 'Verlassen Sie die Crew';

  @override
  String get crewUiSectionBuildings => 'Hauptquartier und Upgrades';

  @override
  String get crewUiHintBuildingsTabs =>
      'Öffnen Sie „HQ & Upgrades“, um das Hauptquartier und alle Mannschaftsgebäude von einem Ort aus zu verwalten.';

  @override
  String get crewUiSectionCrewStorage => 'Mannschaftslager';

  @override
  String get crewUiStateNoStorageData => 'Keine Speicherdaten geladen';

  @override
  String get crewUiActionAddCar => 'Auto/Motorrad hinzufügen';

  @override
  String get crewUiActionAddBoat => 'Boot hinzufügen';

  @override
  String get crewUiActionAddWeapon => 'Waffe hinzufügen';

  @override
  String get crewUiActionAddAmmo => 'Munition hinzufügen';

  @override
  String get crewUiActionAddDrugs => 'Medikamente hinzufügen';

  @override
  String get crewUiSectionMembersOverview => 'Mitgliederübersicht';

  @override
  String get crewUiHintMembersTab =>
      'Öffnen Sie oben die Registerkarte „Mitglieder“, um eine Mitgliederliste und Beitrittsanfragen anzuzeigen.';

  @override
  String get crewUiActionGoToMembers => 'Gehen Sie zu Mitglieder';

  @override
  String get crewUiLabelCrewHq => 'Mannschaftshauptquartier';

  @override
  String get crewUiActionGoToCrewHq => 'Gehen Sie zum Crew-Hauptquartier';

  @override
  String get crewUiActionGoToStorage => 'Gehen Sie zu Speicher';

  @override
  String get crewUiStateJoinCrewFirst =>
      'Erstellen Sie zunächst eine Crew oder treten Sie einer bei';

  @override
  String get crewUiStateJoinRequests => 'Beitrittsanfragen';

  @override
  String get crewUiStateNoJoinRequests => 'Keine ausstehenden Anfragen';

  @override
  String get crewUiStateNoCrewsFound => 'Keine Besatzungen gefunden';

  @override
  String get crewUiLabelMemberCount => 'Mitglieder';

  @override
  String get crewUiBadgeMyCrew => 'Meine Crew';

  @override
  String get crewUiActionJoin => 'Verbinden';

  @override
  String get crewUiStateNotInCrew => 'Du bist nicht Teil einer Crew';

  @override
  String get crewUiHintChatJoinCrew =>
      'Erstellen Sie eine Crew oder treten Sie einer bei, um zu chatten!';

  @override
  String get crewUiStatusNotOwned => 'Nicht im Besitz';

  @override
  String get crewUiLabelLevel => 'Ebene';

  @override
  String get crewUiLabelCapacity => 'Kapazität';

  @override
  String get crewUiLabelMemberCap => 'Mitgliederobergrenze';

  @override
  String get crewUiLabelParking => 'Parken';

  @override
  String get crewUiActionPurchase => 'Kaufen';

  @override
  String get crewUiActionUpgrade => 'Upgrade';

  @override
  String get crewUiActionDetails => 'Einzelheiten';

  @override
  String get crewUiHelpCapsTitle => 'Levelübersicht';

  @override
  String get crewUiHelpLevel => 'Ebene';

  @override
  String get crewUiHelpCapacity => 'Kappe';

  @override
  String get crewUiHelpUpgradeCost => 'Kosten';

  @override
  String get crewUiHelpClose => 'Schließen';

  @override
  String get crewUiHelpShowCaps => 'Kappen anzeigen';

  @override
  String get crewUiSectionUpgradeHub => 'Hauptquartier und Upgrades';

  @override
  String get crewUiSectionStorageHub => 'Speicher-Hub';

  @override
  String get crewUiHintStorageTab =>
      'Verwenden Sie die Registerkarte „Speicher“ für Einzahlungen, Salden und schnelle Speicheraktionen.';

  @override
  String get crewUiHintUpgradeHub =>
      'Verwalten Sie hier das Hauptquartier und alle Crew-Upgrades von einem Ort aus.';

  @override
  String get crewUiSectionCrewMissions => 'Crew-Missionen';

  @override
  String get crewUiStateCrewMissionsEmpty =>
      'Noch keine Crew-Missionen verfügbar';

  @override
  String get crewUiStateCrewMissionNoCrew =>
      'Treten Sie einer Crew bei oder erstellen Sie eine, um Missionen zu starten.';

  @override
  String get crewUiActionStartMission => 'Mission starten';

  @override
  String get crewUiActionConfigureAndStartMission => 'Konfigurieren & starten';

  @override
  String get crewUiActionResolveMission => 'Mission lösen';

  @override
  String get crewUiActionClaimRewards => 'Fordern Sie Prämien an';

  @override
  String get crewUiActionSpeedupCooldown => 'Beschleunigen Sie die Abklingzeit';

  @override
  String get crewUiActionConfirmSpeedupCooldown =>
      'Bestätigen Sie die Beschleunigung';

  @override
  String get crewUiLabelActiveMission => 'Aktive Mission';

  @override
  String get crewUiLabelRecentMissions => 'Aktuelle Missionen';

  @override
  String get crewUiLabelMissionDuration => 'Dauer';

  @override
  String get crewUiLabelMissionCooldown => 'Abklingzeit';

  @override
  String get crewUiLabelMissionTier => 'Stufe';

  @override
  String get crewUiLabelMissionRewards => 'Belohnungen';

  @override
  String get crewUiLabelMissionTradeCargo => 'Handelsware (Crew-Lager)';

  @override
  String get crewUiHintMissionTradeCargo =>
      'Lege die aufgeführten Waren vor dem Start ins Crew-Lager ein.';

  @override
  String get crewUiErrorMissionTradeRequirementsNotMet =>
      'Nicht genug Handelswaren im Crew-Lager für diese Mission.';

  @override
  String get crewUiLabelCrewMissionProgress =>
      'Fortschritt der Besatzungsmission';

  @override
  String get crewUiLabelCrewMissionXp => 'Besatzungsmission XP';

  @override
  String get crewUiLabelCrewMissionLevelBonus => 'Bargeldbonus für die Crew';

  @override
  String get crewUiLabelCrewMissionNextLevelBonus => 'Bonus der nächsten Stufe';

  @override
  String get crewUiLabelMissionStatus => 'Status';

  @override
  String get crewUiLabelCooldownActive => 'Abklingzeit aktiv';

  @override
  String get crewUiLabelRoleContributions => 'Rollenbeiträge';

  @override
  String get crewUiLabelContribution => 'Beitrag';

  @override
  String get crewUiLabelMultiplier => 'Multiplikator';

  @override
  String get crewUiStatusMissionLocked => 'Gesperrt';

  @override
  String get crewUiStatusInProgress => 'Im Gange';

  @override
  String get crewUiStatusCompleted => 'Vollendet';

  @override
  String get crewUiStatusReady => 'Bereit';

  @override
  String get crewUiStatusRewardsClaimed => 'Belohnungen beansprucht';

  @override
  String get crewUiStateMissionActionBusy => 'Aktion wird bearbeitet...';

  @override
  String get crewUiHintMissionLeaderOnly =>
      'Nur der Anführer/Co-Anführer kann Missionen starten und lösen.';

  @override
  String get crewUiDialogRoleAssignTitle => 'Rollen zuweisen';

  @override
  String get crewUiDialogRoleAssignSubtitle =>
      'Wählen Sie eine Missionsrolle pro Besatzungsmitglied.';

  @override
  String get crewUiLabelRoleNone => 'Nicht zugewiesen';

  @override
  String get crewUiLabelRolePlanner => 'Planerin';

  @override
  String get crewUiLabelRoleEnforcer => 'Vollstrecker';

  @override
  String get crewUiLabelRoleLogistics => 'Logistik';

  @override
  String get crewUiLabelRoleTech => 'Techn';

  @override
  String get crewUiHintRoleBonus =>
      'Jede einzigartige Rolle: +3 % Erfolgschance, -2 % Dauer (maximal +12 % / -8 %).';

  @override
  String get crewUiStateRoleAssignNoMembers =>
      'Keine Besatzungsmitglieder gefunden.';

  @override
  String get crewUiStateRoleAssignPickOne =>
      'Wählen Sie mindestens eine Rolle aus.';

  @override
  String get crewUiHintMissionLockedTier2 =>
      'Stufe 2 erfordert HQ 5+ und 2+ Mitglieder.';

  @override
  String get crewUiHintMissionLockedTier3 =>
      'Stufe 3 erfordert HQ 9+ und 3+ Mitglieder.';

  @override
  String get crewUiHintMissionLockedDefault =>
      'Die Mission ist immer noch gesperrt.';

  @override
  String get crewUiMessageMissionOverviewLoadFailed =>
      'Crew-Missionen konnten nicht geladen werden.';

  @override
  String get crewUiMessageMissionStarted => 'Mission gestartet';

  @override
  String get crewUiMessageMissionResolved => 'Mission gelöst';

  @override
  String get crewUiMessageMissionRewardsClaimed => 'Belohnungen beansprucht';

  @override
  String get crewUiMessageMissionCooldownSpedUp =>
      'Die Abklingzeit wurde beschleunigt';

  @override
  String get crewUiMessageMissionSpeedupQuoteFailed =>
      'Beschleunigungspreis konnte nicht geladen werden.';

  @override
  String get crewUiDialogSpeedupTitle => 'Abklingzeit beschleunigen?';

  @override
  String crewUiDialogSpeedupBody(String credits, String minutes) {
    return 'Der sofortige Abschluss kostet $credits Credits (verbleibende $minutes Minute).';
  }

  @override
  String get crewUiLabelCredits => 'Credits';

  @override
  String get crewUiStateLoadingPrice => 'Preis wird geladen...';

  @override
  String get crewUiActionCancel => 'Stornieren';

  @override
  String get crewUiHintMissionUnlockCta =>
      'Höhere Missionstiers öffnen sich, wenn HQ und Crew wachsen. Upgrade das HQ oder werbe Mitglieder für Tier 2+.';

  @override
  String get crewUiActionGoToHqForMissions => 'Open crew HQ';

  @override
  String get crewUiActionGoToTradeMarket => 'Buy trade goods';

  @override
  String crewUiMissionTradeHeldNeed(String name, int held, int need) {
    return '$name: $held/$need';
  }

  @override
  String get crewUiHintMissionPrepReady => 'Cargo is ready in crew storage.';

  @override
  String get crewUiHintMissionPrepShort =>
      'Not enough cargo in crew storage yet.';

  @override
  String get crewUiHintMissionLevelProgress =>
      'Complete missions to raise crew mission level and cash rewards.';

  @override
  String crewUiHqUpgradeSideBuildingsMessage(String level, String missing) {
    return 'Verbessere zuerst alle Nebengebäude auf mindestens Level $level. \n\nFehlt: \n$missing';
  }

  @override
  String get crewUiFormatRemainingUnderOneMinute => '<1 Min';

  @override
  String crewUiFormatRemainingMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get crewUiMissionNoHistory => 'Noch keine Geschichte.';

  @override
  String get crewUiBuildingHq => 'Mannschaftshauptquartier';

  @override
  String get crewUiBuildingCarStorage => 'Auto-/Motorradaufbewahrung';

  @override
  String get crewUiBuildingBoatStorage => 'Bootslagerung';

  @override
  String get crewUiBuildingWeaponStorage => 'Waffenlagerung';

  @override
  String get crewUiBuildingAmmoStorage => 'Munitionslager';

  @override
  String get crewUiBuildingDrugStorage => 'Arzneimittellagerung';

  @override
  String get crewUiBuildingCashStorage => 'Bargeldaufbewahrung';

  @override
  String get crewUiWarActionKill => 'Töten';

  @override
  String get crewUiWarActionMug => 'Becher';

  @override
  String get crewUiWarActionSabotage => 'Sabotage';

  @override
  String get crewUiWarActionIntel => 'Intel';

  @override
  String get crewUiWarActionRaid => 'Überfall';

  @override
  String get crewUiWarActionShield => 'Schild';

  @override
  String get crewUiWarActionBoost => 'Schub';

  @override
  String get crewUiWarActionTerritory => 'Gebiet';

  @override
  String crewUiWarTargetCrewSubtitle(String name, int count) {
    return '$name ($count Mitglieder)';
  }

  @override
  String crewChatErrorLoadingMessages(String error) {
    return 'Fehler beim Laden der Nachrichten: $error';
  }

  @override
  String get crewChatMessageTooLong =>
      'Nachricht zu lang (maximal 500 Zeichen)';

  @override
  String crewChatErrorSending(String error) {
    return 'Fehler beim Senden der Nachricht: $error';
  }

  @override
  String crewChatErrorDelete(String error) {
    return 'Nachricht konnte nicht gelöscht werden: $error';
  }

  @override
  String get crewChatDeleteTitle => 'Nachricht löschen?';

  @override
  String get crewChatDeleteBody => 'Diese Nachricht wird dauerhaft gelöscht.';

  @override
  String get crewChatCancel => 'Stornieren';

  @override
  String get crewChatDelete => 'Löschen';

  @override
  String get crewChatNoMessages => 'Noch keine Nachrichten';

  @override
  String get crewChatEmptyHint =>
      'Senden Sie die erste Nachricht an Ihre Crew!';

  @override
  String get aviationUiBuyConfirmTitle => 'Flugzeug kaufen?';

  @override
  String aviationUiBuyConfirmBody(String name, String price) {
    return 'Möchten Sie $name für $price kaufen?';
  }

  @override
  String get aviationUiPurchaseFailed => 'Der Kauf ist fehlgeschlagen.';

  @override
  String get aviationUiPurchasedSuccess => 'Flugzeug gekauft.';

  @override
  String aviationUiLicenseActiveBlurb(String type) {
    return 'Lizenz aktiv ($type). Bei Bedarf Upgrade für schwerere Flugzeuge. Eine vollständige Pilotenausbildung (Aviation 5 + Zertifikate) ist ebenfalls erforderlich.';
  }

  @override
  String get aviationUiLicenseMissingBlurb =>
      'School Aviation 5/5 allein reicht nicht aus: Kaufen Sie hier eine kostenpflichtige Fluglizenz, bevor Sie Flugzeuge kaufen können.';

  @override
  String get aviationUiLicensesTitle => 'Luftfahrtlizenzen';

  @override
  String get aviationUiLicenseBasic => 'Basic (leicht / Turboprop)';

  @override
  String get aviationUiLicenseCommercial => 'Kommerziell (Business-/Luxusjets)';

  @override
  String get aviationUiLicenseCargo => 'Fracht (Fracht und schwere Frachter)';

  @override
  String aviationUiLicenseMinRank(int rank) {
    return 'Min. Rang $rank';
  }

  @override
  String get aviationUiBuyLicense => 'Lizenz kaufen';

  @override
  String get aviationUiUpgradeLicense => 'Upgrade-Lizenz';

  @override
  String get aviationUiLicenseBuyConfirmTitle => 'Fluglizenz kaufen?';

  @override
  String aviationUiLicenseBuyConfirmBody(String name, String price) {
    return '$name für $price kaufen? Erfordert eine abgeschlossene Flugschule (Stufe 5 + Zertifizierungen).';
  }

  @override
  String get aviationUiLicensePurchaseFailed =>
      'Der Lizenzkauf ist fehlgeschlagen.';

  @override
  String get aviationUiLicensePurchasedSuccess => 'Fluglizenz erworben.';

  @override
  String get aviationUiYourAircraft => 'Ihr Flugzeug';

  @override
  String get aviationUiNoOwnedAircraft => 'Sie besitzen noch kein Flugzeug.';

  @override
  String get aviationUiAvailableAircraft => 'Verfügbare Flugzeuge';

  @override
  String aviationUiFuelLabel(int fuel, int max) {
    return 'Kraftstoff: $fuel / $max';
  }

  @override
  String aviationUiPriceLabel(String price) {
    return 'Preis: $price';
  }

  @override
  String aviationUiMinRank(int rank) {
    return 'Min. Rang: $rank';
  }

  @override
  String aviationUiSpeedMultiplier(String value) {
    return 'Geschwindigkeit x$value';
  }

  @override
  String aviationUiCargoCapacity(int amount) {
    return 'Fracht: $amount';
  }

  @override
  String get aviationUiDefaultAircraftName => 'Flugzeug';

  @override
  String aviationUiLoadError(String error) {
    return 'Flugdaten konnten nicht geladen werden: $error';
  }

  @override
  String get crewUiTr0 => 'HQ-Upgrade-Anforderungen';

  @override
  String get crewUiTr1 =>
      'Verbessere deinen aktuellen HQ-Stil auf die maximale Stufe, um den nächsten Stil freizuschalten';

  @override
  String get crewUiTr2 => 'Endgültiger HQ-Stil erreicht';

  @override
  String get crewUiTr3 => 'VIP-Hauptquartier für Level 11–15 erforderlich';

  @override
  String get crewUiTr4 =>
      'Werte zunächst alle Nebengebäude auf das erforderliche Level für diesen HQ-Stil auf';

  @override
  String get crewUiTr5 => 'Gebäude bereits im Besitz';

  @override
  String get crewUiTr6 => 'Unzureichende Mittel der Mannschaftsbank';

  @override
  String get crewUiTr7 =>
      'Der HQ-Fortschritt ist für dieses Upgrade zu niedrig';

  @override
  String get crewUiTr8 => 'Crew-VIP erforderlich für Level 11+';

  @override
  String get crewUiTr9 =>
      'Startguthaben erreicht. Kaufen Sie zuerst einen Bargeldspeicher, um mehr Platz in der Mannschaftsbank freizuschalten.';

  @override
  String get crewUiTr10 => 'Aktion fehlgeschlagen';

  @override
  String get crewUiTr11 => 'Es gibt bereits eine aktive Crew-Mission.';

  @override
  String get crewUiTr12 =>
      'Die Abklingzeit einer Mission ist noch aktiv. Warten Sie, bis es fertig ist, oder beschleunigen Sie es mit Credits.';

  @override
  String get crewUiTr13 => 'Mission nicht gefunden.';

  @override
  String get crewUiTr14 => 'Diese Stufe ist noch gesperrt.';

  @override
  String get crewUiTr15 => 'Missionslauf nicht gefunden.';

  @override
  String get crewUiTr16 => 'Mission ist bereits gelöst.';

  @override
  String get crewUiTr17 => 'Die Mission ist noch nicht abgeschlossen.';

  @override
  String get crewUiTr18 => 'Keine aktive Abklingzeit.';

  @override
  String get crewUiTr19 => 'Unzureichende Credits.';

  @override
  String get crewUiTr20 => 'Mission konnte nicht gestartet werden.';

  @override
  String get crewUiTr21 => 'Mission konnte nicht gelöst werden.';

  @override
  String get crewUiTr22 => 'Prämien konnten nicht eingefordert werden.';

  @override
  String get crewUiTr23 => 'Die Abklingzeit konnte nicht beschleunigt werden.';

  @override
  String get crewUiTr24 => 'Du bist nicht Teil einer Crew.';

  @override
  String get crewUiTr25 => 'Dies kann nur der Mannschaftsführer tun.';

  @override
  String get crewUiTr26 => 'Zielmannschaft nicht gefunden.';

  @override
  String get crewUiTr27 => 'Diese Crew befindet sich bereits in einem Krieg.';

  @override
  String get crewUiTr28 =>
      'Es sind mindestens 3 Besatzungsmitglieder erforderlich.';

  @override
  String get crewUiTr29 => 'Krieg nicht gefunden.';

  @override
  String get crewUiTr30 => 'Dieser Krieg ist nicht aktiv.';

  @override
  String get crewUiTr31 => 'Sie können diesem Krieg im Moment nicht beitreten.';

  @override
  String get crewUiTr32 => 'Für diese Aktion ist ein Zielspieler erforderlich.';

  @override
  String get crewUiTr33 => 'Anti-Farm-Block: Wählen Sie ein anderes Ziel.';

  @override
  String get crewUiTr34 => 'Für diese Aktion ist ein VIP-Spieler erforderlich.';

  @override
  String get crewUiTr35 => 'Für diese Aktion ist eine VIP-Crew erforderlich.';

  @override
  String get crewUiTr36 => 'Aktionslimit vorerst erreicht.';

  @override
  String crewUiTr37(String remaining) {
    return 'Abklingzeit aktiv: $remaining weitere Minuten warten.';
  }

  @override
  String get crewUiTr38 => 'Ungültiges Gebiet ausgewählt.';

  @override
  String get crewUiTr39 => 'Die Kriegsaktion der Crew scheiterte.';

  @override
  String get crewUiTr40 => 'Zielspieler';

  @override
  String get crewUiTr41 => 'Tötet';

  @override
  String get crewUiTr42 => 'Todesfälle';

  @override
  String get crewUiTr43 => 'Stornieren';

  @override
  String get crewUiTr44 => 'Bestätigen';

  @override
  String get crewUiTr45 => 'Führerin';

  @override
  String get crewUiTr46 => 'Co-Leiter';

  @override
  String get crewUiTr47 => 'Mitglied';

  @override
  String get crewUiTr48 => 'Hauptstadt';

  @override
  String get crewUiTr49 => 'Hafen';

  @override
  String get crewUiTr50 => 'Industrie';

  @override
  String get crewUiTr51 => 'Grenze';

  @override
  String get crewUiTr52 => 'Logistik';

  @override
  String get crewUiTr53 => 'Beanspruchen';

  @override
  String get crewUiTr54 => 'Tick';

  @override
  String get crewUiTr55 => 'Gebiet auswählen';

  @override
  String get crewUiTr56 => 'Wählen Sie zunächst eine Zielmannschaft aus.';

  @override
  String get crewUiTr57 => 'Besatzungskrieg erklärt.';

  @override
  String get crewUiTr58 =>
      'Es ist fehlgeschlagen, der Crew den Krieg zu erklären.';

  @override
  String get crewUiTr59 => 'Du bist dem Krieg beigetreten.';

  @override
  String get crewUiTr60 => 'Es gelang ihm nicht, sich dem Krieg anzuschließen.';

  @override
  String get crewUiTr61 => 'Die Kriegsaktion der Crew ist abgeschlossen.';

  @override
  String get crewUiTr62 => 'Krieg töten';

  @override
  String get crewUiTr63 => 'Wirtschaftskrieg';

  @override
  String get crewUiTr64 => 'Territorialkrieg';

  @override
  String get crewUiTr65 => 'Totaler Krieg';

  @override
  String get crewUiTr66 => 'Vorbereiten';

  @override
  String get crewUiTr67 => 'Aktiv';

  @override
  String get crewUiTr68 => 'Sperrung';

  @override
  String get crewUiTr69 => 'Gelöst';

  @override
  String get crewUiTr70 => 'Archiviert';

  @override
  String get crewUiTr71 => 'Abgesagt';

  @override
  String get crewUiTr72 => 'Crew-VIP';

  @override
  String get crewUiTr73 => '9,99 €/Monat';

  @override
  String get crewUiTr74 => '4,99 €/Monat';

  @override
  String get crewUiTr75 => 'Einmalige Einkäufe';

  @override
  String get crewUiTr76 => 'Nur der Anführer kann Crew-VIP kaufen';

  @override
  String get crewUiTr77 => 'Ungültiges Produkt';

  @override
  String get crewUiTr78 => 'Fehler beim Öffnen der Zahlungsseite';

  @override
  String get crewUiTr79 => 'Bist du sicher?';

  @override
  String get crewUiTr80 => 'Verlassen Sie die Crew';

  @override
  String get crewUiTr81 =>
      'Sind Sie sicher, dass Sie die Crew verlassen möchten?';

  @override
  String get crewUiTr82 => 'Verlassen';

  @override
  String get crewUiTr83 => 'Linke Crew';

  @override
  String get crewUiTr84 => 'Einzahlung auf die Mannschaftsbank';

  @override
  String get crewUiTr85 => 'Aus der Mannschaftsbank zurückziehen';

  @override
  String get crewUiTr86 => 'Menge';

  @override
  String get crewUiTr87 => 'Ungültiger Betrag';

  @override
  String get crewUiTr88 => 'Nicht genügend Bargeld vorhanden';

  @override
  String get crewUiTr89 =>
      'Kaufen Sie zunächst einen Bargeldspeicher für die Mannschaftsbank';

  @override
  String get crewUiTr90 => 'Der Bargeldspeicher der Crew ist voll';

  @override
  String get crewUiTr91 => 'Crew löschen';

  @override
  String get crewUiTr92 =>
      'Sind Sie sicher, dass Sie diese Crew löschen möchten? Dies kann nicht rückgängig gemacht werden.';

  @override
  String get crewUiTr93 => 'Löschen';

  @override
  String get crewUiTr94 => 'Nächstes Level';

  @override
  String get crewUiTr95 => 'Kosten';

  @override
  String get crewUiTr96 => 'Maximales Level erreicht';

  @override
  String get crewUiTr97 => 'Gebäude nicht im Besitz';

  @override
  String get crewUiTr98 => 'Auto/Motorrad hinzufügen';

  @override
  String get crewUiTr99 => 'Boot hinzufügen';

  @override
  String get crewUiTr100 => 'Motorrad';

  @override
  String get crewUiTr101 => 'Boot';

  @override
  String get crewUiTr102 => 'Auto';

  @override
  String get crewUiTr103 => 'Wählen';

  @override
  String get crewUiTr104 => 'Hinzufügen';

  @override
  String get crewUiTr105 => 'Waffe hinzufügen';

  @override
  String get crewUiTr106 => 'Waffe';

  @override
  String get crewUiTr107 => 'Menge';

  @override
  String get crewUiTr108 => 'Munition hinzufügen';

  @override
  String get crewUiTr109 => 'Munitionstyp';

  @override
  String get crewUiTr110 => 'Waren hinzufügen';

  @override
  String get crewUiTr111 => 'Warenart';

  @override
  String get crewUiTr112 =>
      'Treten Sie zunächst einer Crew bei, um Crew Wars nutzen zu können.';

  @override
  String get crewUiTr113 =>
      'Es stehen keine gegnerischen Besatzungsmitglieder zum Zielen zur Verfügung.';

  @override
  String get crewUiTr114 => 'Zielspieler auswählen';

  @override
  String get crewUiTr115 => 'Saisonübersicht';

  @override
  String get crewUiTr116 => 'Aktive Saison';

  @override
  String get crewUiTr117 => 'Meine Rolle';

  @override
  String get crewUiTr118 => 'Die Crew kann sich anmelden';

  @override
  String get crewUiTr119 => 'Ja';

  @override
  String get crewUiTr120 => 'NEIN';

  @override
  String get crewUiTr121 => 'Erkläre einen neuen Krieg';

  @override
  String get crewUiTr122 => 'Zielmannschaft';

  @override
  String get crewUiTr123 => 'Kriegstyp';

  @override
  String get crewUiTr124 => 'Erklären Sie den Krieg';

  @override
  String get crewUiTr125 => 'Kriegsgebiete';

  @override
  String get crewUiTr126 => 'Neutral';

  @override
  String get crewUiTr127 => 'Gegnerische Crew';

  @override
  String get crewUiTr128 => 'Aktiv von';

  @override
  String get crewUiTr129 => 'Schließe dich dem Krieg an';

  @override
  String get crewUiTr130 => 'Rangliste';

  @override
  String get crewUiTr131 => 'Gebiete';

  @override
  String get crewUiTr132 => 'Aktuelle Aktionen';

  @override
  String get crewUiTr133 => 'Noch keine Kriegshandlungen.';

  @override
  String get crewUiTr134 => 'vs';

  @override
  String get crewUiTr135 => 'Saison-Rangliste';

  @override
  String get crewUiTr136 => 'Noch keine Saisonpunkte.';

  @override
  String get crewUiTr137 => 'Beute';

  @override
  String get crewUiTr138 => 'Aktuelle Kriege';

  @override
  String get crewUiTr139 => 'Noch keine aktuellen Kriege.';

  @override
  String get crewUiTr140 => 'Nur der Anführer kann kaufen oder upgraden';

  @override
  String get crewUiTr141 =>
      'HQ-Upgrade blockiert: Nebengebäude zuerst auf L\$requiredSideLevel';

  @override
  String get crewUiTr142 => 'Nächstes Upgrade noch nicht verfügbar';

  @override
  String get crewUiTr143 => 'HQ-Fortschritt zu niedrig';

  @override
  String get crewUiTr144 => 'HQ-Level zu niedrig für das nächste Upgrade';

  @override
  String get premiumUiLoadError =>
      'Premium-Daten konnten nicht geladen werden.';

  @override
  String get premiumUiRedirectPaidOneTime =>
      'Kauf erhalten. Aktualisierung Ihrer Guthaben- und Prämienübersicht.';

  @override
  String get premiumUiRedirectPaidCrewVip =>
      'VIP-Zahlung der Crew erhalten. Aktualisieren Sie Ihre Premium-Übersicht.';

  @override
  String get premiumUiRedirectPaidVip =>
      'VIP-Zahlung erhalten. Aktualisieren Sie Ihre Premium-Übersicht.';

  @override
  String get premiumUiRedirectCancelledOneTime => 'Kauf storniert.';

  @override
  String get premiumUiRedirectCancelledSubscription => 'Zahlung storniert.';

  @override
  String get premiumUiRedirectFailedOneTime =>
      'Der Kauf ist fehlgeschlagen oder abgelaufen.';

  @override
  String get premiumUiRedirectFailedSubscription =>
      'Die Zahlung ist fehlgeschlagen oder abgelaufen.';

  @override
  String get premiumUiCheckoutOpenFailed =>
      'Die Zahlungsseite konnte nicht geöffnet werden.';

  @override
  String get premiumUiRedeemNeedsVehicle =>
      'Dieser Artikel erfordert eine Fahrzeugauswahl und wird über den Fahrzeugbildschirm eingelöst.';

  @override
  String get premiumUiRedeemSuccessDefault => 'Credits eingelöst.';

  @override
  String get premiumUiRedeemFailed =>
      'Gutschriften konnten nicht eingelöst werden.';

  @override
  String get premiumUiPerMonthShort => 'Mo';

  @override
  String get premiumUiCreditThemeCashBoost => 'Bargeldschub';

  @override
  String get premiumUiCreditThemeSecurity => 'Sicherheit';

  @override
  String get premiumUiCreditThemeGarage => 'Garage';

  @override
  String get premiumUiCreditThemeTuneShop => 'Tune-Shop';

  @override
  String premiumUiCreditThemeCooldown(String actionType) {
    return 'Abklingzeit: $actionType';
  }

  @override
  String get premiumUiCreditThemeCooldownReset => 'Abklingzeit zurückgesetzt';

  @override
  String get premiumUiCreditThemeEvents => 'Veranstaltungen';

  @override
  String get premiumUiCreditThemePremium => 'Prämie';

  @override
  String get premiumUiKpiPlayerVip => 'Spieler-VIP';

  @override
  String get premiumUiKpiCrewVip => 'Crew-VIP';

  @override
  String get premiumUiCreditsLabel => 'Credits';

  @override
  String get premiumUiStatusActive => 'Aktiv';

  @override
  String get premiumUiStatusInactive => 'Inaktiv';

  @override
  String get premiumUiNoCrew => 'Keine Crew';

  @override
  String get premiumUiSectionVipTitle => 'VIP-Abonnements';

  @override
  String get premiumUiSectionVipSubtitle =>
      'Professionelle VIP-Kacheln mit klaren Preisen, Status und Vorteilen.';

  @override
  String get premiumUiPlayerVipSubtitle =>
      'Exklusive Kontovorteile, Avatar-Freischaltungen und Premium-QoL.';

  @override
  String premiumUiActiveUntil(String date) {
    return 'Aktiv bis $date';
  }

  @override
  String get premiumUiBadgeVip => 'VIP';

  @override
  String get premiumUiExtendVip => 'VIP verlängern';

  @override
  String get premiumUiBuyVip => 'VIP kaufen';

  @override
  String get premiumUiPlayerVipBenefitsTitle => 'VIP-Vorteile für Spieler';

  @override
  String get premiumUiPlayerVipBenefitsBody =>
      'VIP-Vorteile für Spieler: \n- 10 % kürzere Aktions-Timeouts/Abklingzeiten (die Gefängniszeit bleibt unverändert). \n– In der Arzneimittelproduktion erhalten Sie auf jeder Produktionskarte einen VIP-Blitz-Button, mit dem Sie fehlende Materialien mit einem Klick kaufen können (nach Kostenbestätigung). \n- Im Todesfall verlieren Sie das vorhandene Bargeld, können aber wieder mit 500.000 EUR Bargeld neu beginnen. \n- Ihr Rang wird halbiert, anstatt vollständig zurückgesetzt zu werden. \n- Bildungsfortschritte und freigeschaltete Erfolge bleiben erhalten. \n- Bankguthaben und Krypto bleiben erhalten. \n- Eigentum, Fahrzeuge, Prostituierte, mitgeführtes Inventar und gelagerte Gegenstände werden entfernt. \n- Medikamentenfortschritt und Medikamentenvorrat werden zurückgesetzt. \n- Während VIP aktiv ist, erhalten Sie wöchentlich 100 Premium-Credits.';

  @override
  String get premiumUiCrewVipSubtitleNoCrew =>
      'Sie müssen Mitglied einer Crew sein, bevor Sie Crew VIP aktivieren können.';

  @override
  String get premiumUiCrewVipSubtitleInCrew =>
      'Für Crew-Upgrades, Nebengebäude der Stufen 11–15 und gemeinsame Vorteile.';

  @override
  String get premiumUiBadgeCrewNeeded => 'Crew benötigt';

  @override
  String get premiumUiBadgeCrewVipLabel => 'Crew-VIP';

  @override
  String get premiumUiCtaCrewRequired => 'Crew erforderlich';

  @override
  String get premiumUiExtendCrewVip => 'Verlängern Sie den Crew-VIP';

  @override
  String get premiumUiBuyCrewVip => 'Kaufen Sie Crew VIP';

  @override
  String get premiumUiCrewVipBenefitsTitle => 'VIP-Vorteile für die Crew';

  @override
  String get premiumUiCrewVipBenefitsNoCrewBody =>
      'Sie müssen einer Crew beitreten, bevor Sie Crew VIP kaufen können. Crew-VIP schaltet Crew-spezifische Vorteile und einen höheren Upgrade-Fortschritt frei.';

  @override
  String get premiumUiCrewVipBenefitsInCrewBody =>
      'Crew-VIP gewährt Zugriff auf zusätzliche Crew-Upgrades und gemeinsame Premium-Vergünstigungen für Ihren Crew-Flow. Nach dem Kauf werden Aktivstatus und Ablauf sofort aktualisiert.';

  @override
  String get premiumUiSectionBuyCreditsTitle => 'Credits kaufen';

  @override
  String get premiumUiSectionBuyCreditsSubtitle =>
      'Wählen Sie über die visuellen Kacheln ein Bündel aus. Die beliebte 1000-Credit-Option erhält ein eigenes Rampenlicht.';

  @override
  String get premiumUiSectionPassesTitle => 'Season & event passes';

  @override
  String get premiumUiSectionPassesSubtitle =>
      'One-time unlocks for the monthly Season Pass premium track and short event boosts.';

  @override
  String get premiumUiBadgeSeasonPass => 'Season Pass';

  @override
  String get premiumUiBadgeEventPass => 'Event Pass';

  @override
  String get premiumUiSeasonPassFallbackTitle => 'Season Pass (this month)';

  @override
  String get premiumUiEventPassFallbackTitle => 'Event Pass';

  @override
  String premiumUiBuyPassCta(String price) {
    return 'Buy · $price';
  }

  @override
  String get premiumUiNoCreditBundles =>
      'Derzeit sind keine aktiven Kreditpakete vorhanden.';

  @override
  String get premiumUiCreditBundleFallbackTitle => 'Credit-Paket';

  @override
  String get premiumUiCreditBundleFallbackDescription =>
      'Sofortguthaben für Ihr Premium-Wallet.';

  @override
  String premiumUiBuyCredits(int amount) {
    return 'Kaufen Sie $amount Credits';
  }

  @override
  String premiumUiCreditsCount(int count) {
    return '$count Credits';
  }

  @override
  String get premiumUiBadgeUltraDeal => 'Ultra-Deal';

  @override
  String get premiumUiBadgeTopDeal => 'Top-Angebot';

  @override
  String get premiumUiBadgeCredits => 'Credits';

  @override
  String premiumUiCreditOfferInfo(
    String buyLine,
    String price,
    String description,
  ) {
    return '$buyLine für $price. \n\n$description';
  }

  @override
  String get premiumUiSectionShopTitle => 'Kreditshop';

  @override
  String get premiumUiSectionShopSubtitle =>
      'Jeder Artikel verwendet eine thematische Kachel, die auf dem von Ihnen gekauften Effekt basiert.';

  @override
  String get premiumUiShopItemFallbackTitle => 'Premium-Artikel';

  @override
  String get premiumUiShopItemFallbackDescription => 'Direkter Premiumvorteil.';

  @override
  String get premiumUiShopNoActiveCooldown => 'Keine aktive Abklingzeit';

  @override
  String get premiumUiShopNotEnoughCredits => 'Nicht genügend Credits';

  @override
  String get premiumUiShopRedeem => 'Tilgen';

  @override
  String premiumUiShopItemInfo(String description, String theme, int cost) {
    return '$description \n\nThema: $theme \nKosten: $cost Credits';
  }

  @override
  String get premiumUiBadgeShop => 'Geschäft';

  @override
  String get premiumUiActiveEffectsTitle => 'Aktive Premium-Effekte';

  @override
  String get premiumUiIntroSubtitle =>
      'Hier verwalten Spieler VIP-Abonnements, Credit-Bundles und Credit-Shop-Artikel.';

  @override
  String premiumUiEntitlementChip(String key, String date) {
    return '$key - $date';
  }

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
  String get propertiesConfirmPurchaseTitle => 'Bist du sicher?';

  @override
  String get propertyTypeApartment => 'Wohnung';

  @override
  String get propertyTypeNightclub => 'Nachtclub';

  @override
  String get propertyTypeShop => 'Geschäft';

  @override
  String get propertyStatStorageLabel => '📦 Lagerung';

  @override
  String propertyStatStorageSlotsRange(int from, int to) {
    return '$from → $to Steckplätze';
  }

  @override
  String get propertyStatHousingCapacityLabel => '👩 Wohnkapazität';

  @override
  String propertyStatHousingWorkersRange(int from, int to) {
    return '$from → $to Arbeiter';
  }

  @override
  String propertyStatStorageAmountSlots(int amount) {
    return '$amount Steckplätze';
  }

  @override
  String propertyHousingCapacityWithMax(int current, int max, int level) {
    return '$current Arbeiter (maximal $max auf Stufe $level)';
  }

  @override
  String propertyHousingCapacityMaxReached(int current) {
    return '$current Arbeiter • max';
  }

  @override
  String propertyVipExtraSlots(int count) {
    return 'VIP +$count zusätzliche Slots';
  }

  @override
  String get propertyManageNightclub => 'Nightclub verwalten';

  @override
  String get blackMarket => 'Schwarzmarkt';

  @override
  String get blackMarketShops => 'Läden';

  @override
  String get blackMarketPlayerMarket => 'Spielermarkt';

  @override
  String get blackMarketSubtitle =>
      'Kaufe beim Händler oder handle mit anderen Spielern.';

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
  String get casinoHubChooseGameHint =>
      'Wählen Sie ein Spiel und platzieren Sie Ihre Wette';

  @override
  String get casinoPlayButton => 'Spielen';

  @override
  String get casinoGameBaccaratName => 'Baccarat';

  @override
  String get casinoGameBaccaratDesc =>
      'Wetten Sie auf Spieler, Bank oder Unentschieden mit strategischen Quoten.';

  @override
  String get casinoGameVideoPokerName => 'Videopoker';

  @override
  String get casinoGameVideoPokerDesc =>
      'Ziehen Sie 5 Karten und treffen Sie Kombinationen bis zum Royal Flush.';

  @override
  String get casinoBuyCasinoLockedTitle => 'Casino kaufen (gesperrt)';

  @override
  String get casinoErrGenericPlay => 'Etwas ist schief gelaufen';

  @override
  String get casinoErrSpinFailed => 'Fehler beim Schleudern';

  @override
  String get casinoErrBetFailed => 'Fehler beim Wetten';

  @override
  String get casinoErrGambleFailed => 'Fehler beim Spielen';

  @override
  String get casinoErrThrowFailed => 'Fehler beim Rollen';

  @override
  String get casinoErrCasinoNotFound =>
      'Casino nicht gefunden. Stellen Sie sicher, dass das Casino in diesem Land gekauft wird.';

  @override
  String get casinoErrInsufficientFunds => 'Nicht genug Geld';

  @override
  String get casinoErrInsufficientBankrollPayout =>
      'Das Casino-Guthaben ist für diese Auszahlung zu niedrig';

  @override
  String casinoErrNetwork(String error) {
    return 'Netzwerkfehler: $error';
  }

  @override
  String get casinoResultYouWon => 'Du hast gewonnen!';

  @override
  String get casinoResultYouLost => 'Verloren';

  @override
  String get casinoResultYouWonCelebrate => '🎉 Du hast gewonnen!';

  @override
  String casinoWonEuroAmount(String amount) {
    return 'Du hast $amount € gewonnen!';
  }

  @override
  String casinoLostEuroAmount(String amount) {
    return 'Sie haben $amount € verloren';
  }

  @override
  String get casinoYouLostPlain => 'Du hast verloren';

  @override
  String casinoBlackjackWinAmount(String amount) {
    return 'Du hast $amount € gewonnen!';
  }

  @override
  String casinoBlackjackCelebrate(String amount) {
    return 'BLACKJACK! $amount €';
  }

  @override
  String get casinoAgain => 'Wieder';

  @override
  String get casinoBankruptTitle => 'Casino bankrott!';

  @override
  String get casinoBankruptBody =>
      'Das Casino ging bankrott! \n\nDer Eigentümer verfügte nicht über genügend Bargeld, um alle Auszahlungen abzudecken. \n\nDas Casino ist mittlerweile geschlossen und kann wieder erworben werden.';

  @override
  String get casinoBackToCasino => 'Zurück zum Casino';

  @override
  String casinoRouletteNumberColor(String number, String color) {
    return 'Nummer: $number ($color)';
  }

  @override
  String get casinoColorGreen => 'Grün';

  @override
  String get casinoColorRed => 'Rot';

  @override
  String get casinoColorBlack => 'Schwarz';

  @override
  String get casinoRoulettePickBet => 'Wählen Sie Ihre Wette';

  @override
  String get casinoRouletteBetRed => 'Rot';

  @override
  String get casinoRouletteBetBlack => 'Schwarz';

  @override
  String get casinoRouletteBetEven => 'Sogar';

  @override
  String get casinoRouletteBetOdd => 'Seltsam';

  @override
  String get casinoRouletteSpinButton => 'DREHEN!';

  @override
  String casinoRouletteLastResult(String number) {
    return 'Letztes Ergebnis: $number';
  }

  @override
  String get casinoBetLabel => 'Wette';

  @override
  String get casinoBlackjackPlayButton => 'SPIELEN!';

  @override
  String get casinoSlotSpinButton => 'DREHEN!';

  @override
  String get casinoDiceRollButton => 'ROLLEN!';

  @override
  String get casinoBlackjackYourCards => 'Ihre Karten';

  @override
  String get casinoBlackjackDealerCards => 'Händlerkarten';

  @override
  String casinoBlackjackDealerTotal(String total) {
    return 'Händler: $total';
  }

  @override
  String casinoBlackjackYouTotal(String total) {
    return 'Sie: $total';
  }

  @override
  String casinoDiceTotalShowing(String total) {
    return 'Gesamt: $total';
  }

  @override
  String get casinoDicePredictTitle => 'Vorhersagen';

  @override
  String get casinoDiceLowLabel => 'Niedrig (2-6)';

  @override
  String get casinoDiceHighLabel => 'Hoch (8-12)';

  @override
  String get casinoDiceOddsHint =>
      'Niedrig/Hoch zahlt 2x aus. • Exakte Summe zahlt 6x';

  @override
  String get casinoSlotPayoutTableTitle => 'Auszahlungstabelle';

  @override
  String get casinoBaccaratPlayer => 'Spieler';

  @override
  String get casinoBaccaratBanker => 'Bankerin';

  @override
  String get casinoBaccaratTieBet => 'Binden';

  @override
  String casinoWinnerPrefix(String who) {
    return 'Gewinner: $who';
  }

  @override
  String casinoPayoutEuro(String amount) {
    return 'Auszahlung: $amount';
  }

  @override
  String get casinoNoPayout => 'Keine Auszahlung';

  @override
  String casinoResultEuro(String amount) {
    return 'Ergebnis: $amount €';
  }

  @override
  String get casinoDealing => 'Handeln…';

  @override
  String get casinoDealCaps => 'HANDELN';

  @override
  String get casinoVideoPokerDrawCards => 'KARTEN ZIEHEN';

  @override
  String get casinoVideoPokerDrawHint => 'Zeichne deine Hand';

  @override
  String get casinoVideoPokerRoyalFlush => 'Royal Flush';

  @override
  String get casinoVideoPokerStraightFlush => 'Straight Flush';

  @override
  String get casinoVideoPokerFourKind => 'Vierling';

  @override
  String get casinoVideoPokerFullHouse => 'Volles Haus';

  @override
  String get casinoVideoPokerFlush => 'Spülen';

  @override
  String get casinoVideoPokerStraight => 'Gerade';

  @override
  String get casinoVideoPokerThreeKind => 'Drei Gleiche';

  @override
  String get casinoVideoPokerTwoPair => 'Zwei Paar';

  @override
  String get casinoVideoPokerJacksOrBetter => 'Jacks or Better';

  @override
  String get casinoVideoPokerNoWinningHand => 'Keine gewinnende Hand';

  @override
  String get casinoVideoPokerPayoutTableLong =>
      'Auszahlungstabelle: Jacks+ 1x • Two Pair 2x • Trips 3x • Straight 4x • Flush 6x • Full House 9x • Four 25x • Straight Flush 50x • Royal 250x';

  @override
  String get bankScreenLoadFailed => 'Bank konnte nicht geladen werden';

  @override
  String bankScreenErrNetwork(String details) {
    return 'Netzwerkfehler: $details';
  }

  @override
  String bankScreenCounterpartyTo(String username) {
    return 'An: $username';
  }

  @override
  String bankScreenCounterpartyFrom(String username) {
    return 'Von: $username';
  }

  @override
  String get bankScreenDepositSuccess => 'Einzahlung erfolgreich';

  @override
  String get bankScreenDepositFailed => 'Die Einzahlung ist fehlgeschlagen';

  @override
  String bankScreenDailyDepositQuota(String remaining, String cap) {
    return 'Heute verbleibende kostenlose Einzahlungen: $remaining von $cap. Größere Mengen müssen gewaschen werden.';
  }

  @override
  String get bankScreenDailyDepositCapReached =>
      'Das heutige Gratis-Einzahlungslimit ist aufgebraucht. Waschen Sie das verbleibende Bargeld oder warten Sie auf den UTC-Reset.';

  @override
  String bankScreenFillRemainingQuota(String amount) {
    return 'Verbleibende Füllung ($amount)';
  }

  @override
  String bankScreenDailyDepositResetsIn(String time) {
    return 'Kostenlose Einzahlungen werden um 00:00 UTC zurückgesetzt ($time übrig).';
  }

  @override
  String get bankScreenDailyDepositBelowLaunderMin =>
      'Bargeld, das unter dem Geldwäsche-Mindestbetrag liegt, kann nach dem UTC-Reset kostenlos eingezahlt werden.';

  @override
  String bankScreenDepositCapError(String remaining) {
    return 'Das übersteigt die verbleibende kostenlose Einzahlung heute ($remaining). Zahlen Sie bis zu diesem Betrag ein oder nutzen Sie Geldwäsche.';
  }

  @override
  String get bankScreenWithdrawSuccess => 'Auszahlung erfolgreich';

  @override
  String get bankScreenWithdrawFailed => 'Die Auszahlung ist fehlgeschlagen';

  @override
  String bankScreenTransferSuccess(String amount, String recipient) {
    return '$amount € überwiesen auf $recipient';
  }

  @override
  String get bankScreenTransferFailed => 'Die Übertragung ist fehlgeschlagen';

  @override
  String get bankScreenErrRecipientNotFound => 'Spieler nicht gefunden';

  @override
  String get bankScreenErrCannotTransferToSelf =>
      'Sie können nicht auf sich selbst übertragen';

  @override
  String get bankScreenErrInsufficientBalance => 'Unzureichendes Bankguthaben';

  @override
  String get bankScreenErrInvalidAmount => 'Ungültiger Betrag';

  @override
  String get bankScreenTryAgain => 'Versuchen Sie es erneut';

  @override
  String get bankScreenWorldwideSubtitle => 'Bank (weltweit erreichbar)';

  @override
  String bankScreenCashOnHand(int amount) {
    return 'Kassenbestand: $amount';
  }

  @override
  String bankScreenBalanceLine(int amount) {
    return 'Bankguthaben: $amount';
  }

  @override
  String get bankScreenAmountLabel => 'Menge';

  @override
  String get bankScreenDescriptionOptional => 'Beschreibung (optional)';

  @override
  String get bankScreenDescriptionDepositHint =>
      'Wird zusammen mit Ihrer Ein- oder Auszahlung bei Transaktionen gespeichert.';

  @override
  String get bankScreenDepositButton => 'Kaution';

  @override
  String get bankScreenWithdrawButton => 'Zurückziehen';

  @override
  String get bankScreenTransferSectionTitle => 'Transfer zum Spieler';

  @override
  String get bankScreenRecipientUsername => 'Benutzername des Empfängers';

  @override
  String get bankScreenRecentRecipients => 'Aktuelle Empfänger';

  @override
  String get bankScreenDescriptionTransferHint =>
      'Diese Beschreibung wird dem Empfänger auch in Transaktionen angezeigt.';

  @override
  String get bankScreenTransferButton => 'Überweisen';

  @override
  String get bankScreenTransactionsTitle => 'Transaktionen';

  @override
  String bankScreenTransactionsTotal(int count) {
    return '$count insgesamt';
  }

  @override
  String get bankScreenSummaryDeposits => 'Einlagen';

  @override
  String get bankScreenSummaryWithdrawals => 'Auszahlungen';

  @override
  String get bankScreenSummarySent => 'Gesendet';

  @override
  String get bankScreenSummaryReceived => 'Erhalten';

  @override
  String get bankScreenNoTransactions => 'Noch keine Transaktionen';

  @override
  String get bankScreenTxnDeposit => 'Kaution';

  @override
  String get bankScreenTxnWithdraw => 'Rückzug';

  @override
  String get bankScreenTxnTransferSent => 'Überweisung gesendet';

  @override
  String get bankScreenTxnTransferReceived => 'Überweisung erhalten';

  @override
  String get bankScreenPrevious => 'Vorherige';

  @override
  String get bankScreenNext => 'Nächste';

  @override
  String bankScreenPageOf(int current, int total) {
    return 'Seite $current von $total';
  }

  @override
  String bankScreenRankLabel(String rank) {
    return 'Rang $rank';
  }

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
  String get viewOffer => 'Angebot ansehen';

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
  String get backpacks => 'Rucksäcke';

  @override
  String get materials => 'Materialien';

  @override
  String get materialsShopTitle => 'Materials Shop';

  @override
  String get materialsShopRulesTitle => 'Local depot vs backpack';

  @override
  String get materialsShopRulesBody =>
      'Bought materials go into the depot of your current country and can only be used for production there. Load them into your upgradeable backpack to travel — border checks may confiscate part of your load or arrest you. Country depots stay safe.';

  @override
  String materialsShopBackpackSlots(String used, String capacity) {
    return 'Backpack slots: $used/$capacity';
  }

  @override
  String materialsShopCurrentCountry(String country) {
    return 'Current country: $country';
  }

  @override
  String materialsShopStockLine(int depot, int carried) {
    return 'Local depot: $depot · Backpack: $carried';
  }

  @override
  String get materialsShopBuy => 'Buy';

  @override
  String get materialsShopToBackpack => 'To backpack';

  @override
  String get materialsShopToDepot => 'To depot';

  @override
  String get materialsShopTransferToBackpackHint =>
      'Move from local depot into your backpack (counts toward slots; travel risk).';

  @override
  String get materialsShopTransferToDepotHint =>
      'Unload backpack into the depot of your current country.';

  @override
  String get materialsShopQuantity => 'Quantity';

  @override
  String materialsShopMaxQty(int max) {
    return 'Max: $max';
  }

  @override
  String materialsShopPriceEach(String price) {
    return 'Price: €$price each';
  }

  @override
  String materialsShopTotal(String total) {
    return 'Total: €$total';
  }

  @override
  String materialsShopNeedMoney(String amount) {
    return 'You need €$amount';
  }

  @override
  String get materialsShopBuyOk => 'Materials purchased into local depot';

  @override
  String get materialsShopBuyFailed => 'Purchase failed';

  @override
  String get materialsShopTransferOk => 'Materials moved';

  @override
  String get materialsShopTransferFailed => 'Transfer failed';

  @override
  String materialsShopLoadError(String error) {
    return 'Error while loading: $error';
  }

  @override
  String get materialsShopEmpty => 'No materials available';

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
  String get contrabandSpiritsName => 'Luxusspirituosen';

  @override
  String get contrabandSpiritsDesc =>
      'Geschmuggelter Whisky, Cognac und Premium-Liköre';

  @override
  String get contrabandTobaccoName => 'Tabak';

  @override
  String get contrabandTobaccoDesc =>
      'Unversteuerte Zigaretten und Schnupftabak';

  @override
  String get contrabandArtName => 'Kunst & Antiquitäten';

  @override
  String get contrabandArtDesc =>
      'Geschmuggelte Gemälde, Skulpturen und Antiquitäten';

  @override
  String get contrabandSpicesName => 'Gewürze';

  @override
  String get contrabandSpicesDesc => 'Exotische Kräuter und Gewürze in Säcken';

  @override
  String get contrabandCoffeeName => 'Kaffee';

  @override
  String get contrabandCoffeeDesc => 'Premium-Kaffeebohnen ohne Zertifikat';

  @override
  String get contrabandFurLeatherName => 'Pelz & Leder';

  @override
  String get contrabandFurLeatherDesc =>
      'Illegal gewonnener Pelz und exotisches Leder';

  @override
  String get contrabandPerfumeName => 'Parfum';

  @override
  String get contrabandPerfumeDesc => 'Geschmuggelte Designerparfums';

  @override
  String get contrabandCounterfeitCashName => 'Falschgeld';

  @override
  String get contrabandCounterfeitCashDesc =>
      'Hochwertige Fälschungen und Banknoten';

  @override
  String get contrabandRareWineName => 'Seltene Weine';

  @override
  String get contrabandRareWineDesc => 'Vintage-Weine und exklusive Sammlungen';

  @override
  String get contrabandLuxuryWatchesName => 'Luxusuhren';

  @override
  String get contrabandLuxuryWatchesDesc =>
      'Geschmuggelte Prestige-Uhren ohne Papiere';

  @override
  String get contrabandGoldName => 'Gold';

  @override
  String get contrabandGoldDesc =>
      'Geschmolzene Goldbarren und unmarkiertes Bullion';

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
  String get tradeLoadGoodsFailed =>
      'Der Warenkatalog konnte nicht geladen werden';

  @override
  String get tradeLoadPricesFailed =>
      'Aktuelle Preise konnten nicht geladen werden';

  @override
  String get tradeLoadInventoryFailed =>
      'Ihr Handelsinventar konnte nicht geladen werden';

  @override
  String get tradePartialDataBanner =>
      'Einige Marktdaten konnten nicht aktualisiert werden. Zum erneuten Versuch nach unten ziehen.';

  @override
  String get tradeMarketLoadAllFailed =>
      'Der Markt konnte nicht geladen werden. Zum erneuten Versuch nach unten ziehen.';

  @override
  String get tradeNoGoodsLoaded => 'Im Moment sind keine Waren verfügbar.';

  @override
  String get tradeRiskPanelTitle => 'Reise- und Marktrisiken';

  @override
  String get tradeRiskPanelSubtitle =>
      'Jede Ware weist gegebenenfalls Verderb, Preisschwankungen, Reiseschäden oder Beschlagnahmungen auf.';

  @override
  String get tradeRiskInsightBody =>
      'BLUMEN: Verderben nach Ablauf der Kaufzeit – rechtzeitig verkaufen. \nDIAMANTEN: Kaufpreise schwanken mit der Volatilität; Planen Sie, wo Sie im Ausland verkaufen. \nELEKTRONIK: kann bei jeder Fahrt ihren Zustand verlieren, was den Wiederverkaufswert senkt. \nWAFFEN und PHARMAZEUTIKA: Auf Reisen kann es zu teilweiser Beschlagnahmung kommen – halten Sie die Fahndung niedrig und lesen Sie die Schmuggelregeln. \nDie Preise auf diesem Bildschirm beinhalten bereits Ihren aktuellen Ländermultiplikator.';

  @override
  String tradeRiskSpoilageHours(String hours) {
    return '${hours}h Verderbfenster';
  }

  @override
  String tradeRiskVolatilityPct(String pct) {
    return '±$pct% Preisschwankung';
  }

  @override
  String tradeRiskConfiscationPct(String pct) {
    return '$pct % Anfallsrisiko pro Fahrt';
  }

  @override
  String tradeRiskDamageTripPct(String pct) {
    return '$pct % Schadenschance pro Fahrt';
  }

  @override
  String tradeRiskHeavyWeight(String weight) {
    return 'Schwer ($weight Gewicht)';
  }

  @override
  String get tradeGoodNotAvailableHere =>
      'Dieses Produkt ist in deinem aktuellen Land nicht käuflich. Reise in ein Quellenland.';

  @override
  String get tradeNoBuyableGoodsInCountry =>
      'In diesem Land gibt es keine käuflichen Handelswaren. Reise in ein Quellenland.';

  @override
  String get tradeUnavailableGoodsTitle => 'Hier nicht käuflich';

  @override
  String tradeUnavailableGoodsSubtitle(String count) {
    return '$count Produkte nur in Quellenländern';
  }

  @override
  String get tradeTravelToSourceHint =>
      'Nur in Quellenländern käuflich — reise zum Einkauf';

  @override
  String get tradeCategoryAll => 'Alle';

  @override
  String get tradeCategoryStarter => 'Starter';

  @override
  String get tradeCategoryBulk => 'Bulk';

  @override
  String get tradeCategoryLuxury => 'Luxus';

  @override
  String get tradeCategoryDangerous => 'Gefährlich';

  @override
  String get tradeFilterAvailableHere => 'Hier käuflich';

  @override
  String tradeMarketCatalogSummary(String total, String here) {
    return '$total Produkte · $here hier käuflich';
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
  String get courtLoadFailed =>
      'Gerichtsdaten konnten nicht geladen werden. Bitte versuchen Sie es erneut.';

  @override
  String get courtAppealDialogIntro =>
      'Möchten Sie gegen diese Verurteilung Berufung einlegen?';

  @override
  String courtCostLine(String amount) {
    return 'Kosten: $amount';
  }

  @override
  String courtJudgeNamed(String name) {
    return 'Richter: $name';
  }

  @override
  String courtCorruptibilityPercent(String percent) {
    return 'Verderblichkeit: $percent %';
  }

  @override
  String get courtAppealSuccessHint => 'Bei Erfolg: ca. 20–40 % Strafminderung';

  @override
  String courtAppealGrantedMinutes(String minutes) {
    return 'Berufung stattgegeben. Neuer Satz: $minutes Minuten.';
  }

  @override
  String get courtAppealDenied => 'Berufung abgelehnt.';

  @override
  String get courtBribeOfferIntro =>
      'Bieten Sie einen Betrag an. Der Betrag wird immer abgezogen, auch bei Scheitern.';

  @override
  String courtBribeAmountFormatted(String amount) {
    return 'Bestechungsbetrag: $amount';
  }

  @override
  String courtBribeSliderLabel(String thousands) {
    return '${thousands}Tsd. €';
  }

  @override
  String courtEstimatedSuccessChance(String percent) {
    return 'Geschätzte Erfolgschance: ~$percent%';
  }

  @override
  String get courtBribeSuccessReleased =>
      'Richter bestochen. Sie werden sofort freigelassen.';

  @override
  String get courtBribeFailedDebited =>
      'Bestechung gescheitert. Betrag wurde trotzdem abgezogen.';

  @override
  String get courtRecordActive => 'Aktiv';

  @override
  String get courtRecordServed => 'Serviert';

  @override
  String courtHistoryAppealGranted(String fromMinutes, String toMinutes) {
    return 'Der Berufung stattgegeben: $fromMinutes → $toMinutes Minuten';
  }

  @override
  String courtHistoryAppealDenied(String minutes) {
    return 'Einspruch abgelehnt: Es verbleiben noch $minutes Minuten';
  }

  @override
  String courtHistoryBribeFailedPaid(String amount) {
    return 'Bestechung fehlgeschlagen: $amount bezahlt';
  }

  @override
  String courtHistoryConvictedMinutes(String minutes) {
    return 'Verurteilt zu $minutes Minuten';
  }

  @override
  String get courtPartialLoadWarning =>
      'Achtung: Ein Teil der Gerichtsdaten konnte nicht geladen werden. Zum Aktualisieren ziehen und erneut versuchen.';

  @override
  String get courtNoActiveSentence => 'Kein aktiver Satz';

  @override
  String get courtNotJailedHint =>
      'Sie sind derzeit nicht im Gefängnis. Ihr Strafregister bleibt unten sichtbar.';

  @override
  String get courtActiveSentenceTitle => 'Aktiver Satz';

  @override
  String get courtDelictLabel => 'Verbrechen';

  @override
  String courtTotalSentenceMinutes(String minutes) {
    return 'Gesamtsatz: $minutes Minuten';
  }

  @override
  String courtRemainingMinutes(String minutes) {
    return 'Verbleibend: $minutes Minuten';
  }

  @override
  String courtAppealCostCurrent(String amount) {
    return 'Aktuelle Berufungskosten: $amount';
  }

  @override
  String get courtButtonAppeal => 'Appellieren';

  @override
  String get courtButtonBribeJudge => 'Bestechungsrichter';

  @override
  String get courtUnknownCrime => 'Unbekannt';

  @override
  String courtSentenceMinutesOnly(String minutes) {
    return 'Satz: $minutes Minuten';
  }

  @override
  String courtSentenceReducedMinutes(String original, String reduced) {
    return 'Satz: $original → $reduced Minuten';
  }

  @override
  String courtDateLabeled(String datetime) {
    return 'Datum: $datetime';
  }

  @override
  String get courtHistoryHeading => 'Gerichtsgeschichte';

  @override
  String get courtAppealSubmitted => 'Berufung eingereicht';

  @override
  String get courtCriminalRecordTitle => 'Strafregister';

  @override
  String courtTotalConvictions(String count) {
    return 'Gesamtzahl der Verurteilungen: $count';
  }

  @override
  String get courtRecordBribeNote =>
      'Vergangene Überzeugungen bleiben sichtbar. Eine erfolgreiche Richterbestechung klärt nur diesen einen aktiven Fall.';

  @override
  String get courtNoConvictionsYet =>
      'Es liegen noch keine Verurteilungen vor.';

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
  String get hospitalCooldownTitle => 'Behandlung in der Erholungsphase';

  @override
  String hospitalCooldownNextAvailable(String duration) {
    return 'Nächste Behandlung verfügbar in: $duration';
  }

  @override
  String get hospitalMedicalStatusTitle => 'Medizinischer Status';

  @override
  String hospitalIcuRemaining(String duration) {
    return 'Intensivstation: $duration';
  }

  @override
  String hospitalHpLine(String hp) {
    return 'PS $hp/100';
  }

  @override
  String get hospitalIcuTriageTitle =>
      'Übersicht über Intensivstation und Triage';

  @override
  String hospitalIcuPatientRemaining(String duration) {
    return 'Patient auf der Intensivstation. Verbleibende Zeit: $duration';
  }

  @override
  String get hospitalCriticalStatusDetected =>
      'Kritischer Status erkannt. Notfallversorgung empfohlen.';

  @override
  String get hospitalStableStatus => 'Stabil. Regelmäßige Behandlung möglich.';

  @override
  String get hospitalRefreshMedicalRecord => 'Krankenakte aktualisieren';

  @override
  String get hospitalStandardTreatmentTitle => 'Standardbehandlung';

  @override
  String hospitalStandardTreatmentSubtitle(String amount) {
    return 'Erschwinglich • Wiederherstellung von bis zu $amount HP';
  }

  @override
  String get hospitalIntensiveTreatmentTitle => 'Intensive Behandlung';

  @override
  String hospitalIntensiveTreatmentSubtitle(String amount) {
    return 'Schnellere Wiederherstellung • bis zu $amount HP';
  }

  @override
  String hospitalIntensiveTreatmentInfoLine(String cost, String amount) {
    return '• Intensivbehandlung: $cost € für bis zu $amount HP-Erholung.';
  }

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
  String get inventoryCrimeWeaponTitle => 'Ausgewählte Kriminalwaffe';

  @override
  String get inventoryCrimeWeaponHint => 'Wählen Sie eine Waffe für Verbrechen';

  @override
  String get inventoryCrimeWeaponHelp =>
      'Wählen Sie hier Ihre Kriminalwaffe. Die Verbrechensanzeige verwendet diese Auswahl sofort.';

  @override
  String get inventoryCrimeWeaponEmpty =>
      'Keine verwendbaren Waffen im Inventar. Kaufen Sie zuerst eine Waffe oder verschieben Sie sie in getragene Gegenstände.';

  @override
  String get inventoryPaperDoll => 'Ausrüstung';

  @override
  String get inventoryBackpackGrid => 'Rucksack';

  @override
  String get inventoryStorageGrid => 'Lagerung';

  @override
  String get inventoryMaterialsDepot => 'Materialdepot';

  @override
  String get inventoryEquipWeapon => 'Verbrechenswaffe';

  @override
  String get inventoryEquipSecondary => 'Zweite Waffe';

  @override
  String get inventoryEquipArmor => 'Weste';

  @override
  String get inventoryEmptySlot => 'Leerer Steckplatz';

  @override
  String inventorySelectHint(String name) {
    return 'Ausgewählt: $name. Tippen Sie auf einen gültigen Slot, um ihn zu verschieben.';
  }

  @override
  String get inventoryOpenStorage => 'Offener Speicher';

  @override
  String get inventoryTransferOk => 'Artikel verschoben';

  @override
  String get inventoryTransferFailed => 'Der Umzug ist fehlgeschlagen';

  @override
  String get inventoryWrongDrop => 'Dieser Tropfen ist hier nicht erlaubt';

  @override
  String get inventoryMoveOne => 'Zug 1';

  @override
  String get inventoryMoveAll => 'Alles bewegen';

  @override
  String inventorySlotUsage(int used, int max) {
    return 'Rucksack $used/$max';
  }

  @override
  String get inventoryCarriedEmpty =>
      'Sie tragen keine Werkzeuge, Waffen oder Munition.';

  @override
  String get inventorySectionTools => 'Werkzeuge';

  @override
  String get inventorySectionWeapons => 'Waffen';

  @override
  String get inventorySectionAmmo => 'Munition';

  @override
  String get inventoryWeaponFallbackName => 'Waffe';

  @override
  String get inventoryAmmoFallbackName => 'Munition';

  @override
  String inventoryWeaponSubtitle(String condition, String qty) {
    return 'Zustand: $condition % • Menge: $qty';
  }

  @override
  String inventoryAmmoQuantity(String qty) {
    return 'Menge: $qty';
  }

  @override
  String inventoryQuantityValue(int qty) {
    return 'Menge: $qty';
  }

  @override
  String inventoryWithdrawDialogTitle(String itemName) {
    return 'Aus dem Speicher entnehmen: $itemName';
  }

  @override
  String inventoryMaxShort(int max) {
    return 'Maximal: $max';
  }

  @override
  String get inventoryInvalidQuantity => 'Ungültige Menge';

  @override
  String get inventorySnackWeaponStored => 'Waffe aufbewahrt';

  @override
  String get inventorySnackWeaponWithdrawn => 'Waffe abgezogen';

  @override
  String get inventorySnackCashStored => 'Bargeld eingezahlt';

  @override
  String get inventorySnackCashWithdrawn => 'Bargeld abgehoben';

  @override
  String get inventorySnackDrugsWithdrawn => 'Drogenentzug';

  @override
  String get inventoryActionFailed => 'Aktion fehlgeschlagen';

  @override
  String get inventoryStorageNoCategory => 'Kein Speichertyp';

  @override
  String get inventoryCountsWeapons => 'Waffen';

  @override
  String get inventoryCountsDrugs => 'Drogen';

  @override
  String get inventoryCountsCash => 'Kasse';

  @override
  String inventoryStorageCountsLine(
    String weapons,
    int weaponCount,
    String drugs,
    int drugCount,
    String cash,
    int cashAmount,
  ) {
    return '$weapons: $weaponCount • $drugs: $drugCount • $cash: €$cashAmount';
  }

  @override
  String get inventoryStorageWrongCountry =>
      'Sie befinden sich in einem anderen Land. Auf diesen Speicher können Sie hier nicht zugreifen.';

  @override
  String get inventoryWeaponStorageTitle => 'Waffenlagerung';

  @override
  String get inventoryStoreWeapons => 'Speichern';

  @override
  String get inventoryInStorage => 'Im Lager';

  @override
  String get inventoryUnknownWeapon => 'Unbekannte Waffe';

  @override
  String get inventoryTakeOne => 'Nimm 1';

  @override
  String get inventoryNoWeaponsInStorage =>
      'In diesem Lager befinden sich keine Waffen.';

  @override
  String get inventoryCashStorageTitle => 'Bargeldaufbewahrung';

  @override
  String get inventoryDepositCash => 'Bargeld einzahlen';

  @override
  String get inventoryWithdrawCash => 'Bargeld abheben';

  @override
  String get inventoryDrugStorageTitle => 'Lagerung von Arzneimitteln';

  @override
  String get inventoryNoDrugsInStorage => 'Keine Medikamente im Lager.';

  @override
  String get inventoryNotForTools =>
      'Diese Eigenschaft dient nicht zur Werkzeugaufbewahrung. Nutzen Sie ein Lager für Werkzeuge.';

  @override
  String get inventoryCategoryTools => 'Werkzeuge';

  @override
  String get inventoryCategoryDrugs => 'Drogen';

  @override
  String get inventoryCategoryWeapons => 'Waffen';

  @override
  String get inventoryCategoryCash => 'Kasse';

  @override
  String inventoryStorageSlotsDetail(int used, int max, String percent) {
    return '$used/$max Slots ($percent%)';
  }

  @override
  String get inventoryStorageAccessibleHere => 'Im aktuellen Land verfügbar';

  @override
  String get inventoryStorageNotAccessibleHere =>
      'In diesem Land nicht zugänglich';

  @override
  String get loadoutEquipFailed => 'Ausrüstung konnte nicht ausgerüstet werden';

  @override
  String get loadoutDeleteFailed => 'Das Loadout konnte nicht gelöscht werden';

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
  String get backpackPurchaseFailedGeneric =>
      'Der Kauf konnte nicht abgeschlossen werden.';

  @override
  String get backpackUpgradeFailedGeneric =>
      'Das Upgrade konnte nicht abgeschlossen werden.';

  @override
  String get backpackUnknownEvent => 'Unbekannte Aktion';

  @override
  String get backpackLoadFailedGeneric => 'Etwas ist schief gelaufen';

  @override
  String get backpackOwnedBadge => 'Im Besitz';

  @override
  String get availableBackpacks => 'Verfügbare Rucksäcke';

  @override
  String backpackDialogCurrentLine(String name, int slots) {
    return 'Aktuell: $name (+$slots Slots)';
  }

  @override
  String backpackDialogNewLine(String name, int slots) {
    return 'Neu: $name (+$slots Slots)';
  }

  @override
  String backpackDialogUpgradeDelta(int delta) {
    return 'Upgrade: +$delta Slots';
  }

  @override
  String backpackDialogTotalCapacity(int totalSlots) {
    return 'Gesamt: $totalSlots Slots';
  }

  @override
  String get notLoggedInTokenStorageHint =>
      '(Speicherproblem – versuchen Sie erneut, sich anzumelden)';

  @override
  String get blackMarketTabBackpacks => 'Rucksäcke';

  @override
  String get bmHubAdjustFiltersHint => 'Versuchen Sie, Ihre Filter anzupassen';

  @override
  String get bmHubEmptyMyListingsHint =>
      'Fahrzeuge über Garage/Marina listen oder getragene Werkzeuge über „Item verkaufen“';

  @override
  String get bmHubSellerLabel => 'Verkäuferin';

  @override
  String get bmHubAskingPriceLabel => 'Preisvorstellung';

  @override
  String get bmHubMarketValueShort => 'Marktwert';

  @override
  String get bmHubBuyNow => 'Jetzt kaufen';

  @override
  String get bmHubListedFor => 'Gelistet für';

  @override
  String get bmHubEditPrice => 'Preis bearbeiten';

  @override
  String get bmHubDelist => 'Delistieren';

  @override
  String get bmHubFilterListingsTitle => 'Einträge filtern';

  @override
  String get bmHubLabelCountry => 'Land';

  @override
  String get bmHubAllCountries => 'Alle Länder';

  @override
  String get bmHubLabelVehicleType => 'Fahrzeugtyp';

  @override
  String get bmHubAllTypes => 'Alle Arten';

  @override
  String get bmHubCars => 'Autos';

  @override
  String get bmHubBoats => 'Boote';

  @override
  String get bmHubPriceRange => 'Preisklasse';

  @override
  String get bmHubClearFilters => 'Filter löschen';

  @override
  String get bmHubApply => 'Anwenden';

  @override
  String get bmHubBuyVehicleTitle => 'Fahrzeug kaufen';

  @override
  String bmHubBuyVehicleForConfirm(String name, String price) {
    return '$name für $price kaufen?';
  }

  @override
  String get bmHubVehiclePurchased => 'Fahrzeug erfolgreich gekauft!';

  @override
  String get bmHubVehiclePurchaseFailed => 'Fahrzeugkauf fehlgeschlagen';

  @override
  String get bmHubNewPriceEuro => 'Neuer Preis (€)';

  @override
  String get bmHubEnterNewPriceHint => 'Geben Sie einen neuen Preis ein';

  @override
  String get bmHubCurrentPrice => 'Aktueller Preis';

  @override
  String get bmHubPriceUpdated => 'Preis erfolgreich aktualisiert!';

  @override
  String get bmHubPriceUpdateFailed => 'Preis konnte nicht aktualisiert werden';

  @override
  String get bmHubUpdateButton => 'Aktualisieren';

  @override
  String get bmHubDelistVehicleTitle => 'Fahrzeug aus dem Angebot nehmen';

  @override
  String bmHubRemoveFromMarketConfirm(String name) {
    return '$name vom Markt nehmen?';
  }

  @override
  String get bmHubVehicleDelisted => 'Fahrzeug erfolgreich dekotiert!';

  @override
  String get bmHubDelistFailed =>
      'Fahrzeug konnte nicht aus dem Angebot genommen werden';

  @override
  String get bmHubLocationUnknown => 'UNBEKANNT';

  @override
  String get bmHubNoMarketListingsTitle => 'Keine Inserate';

  @override
  String get bmHubNoMarketListingsBody =>
      'Keine passenden Fahrzeuge oder Items. Du kannst getragene Werkzeuge über „Item verkaufen“ listen.';

  @override
  String get bmHubSellKindTool => 'Werkzeug';

  @override
  String get bmHubSellKindDrug => 'Drogen';

  @override
  String get bmHubSellKindCrypto => 'Krypto';

  @override
  String get bmHubSellKindTrade => 'Handelswaren';

  @override
  String get bmHubQuantityEvent => 'Menge';

  @override
  String get bmHubListEventItemTitle => 'Eventartikel verkaufen';

  @override
  String get bmHubNoEventItemsToSell => 'Keine Eventartikel zum Verkauf';

  @override
  String get bmHubSellKindEvent => 'Eventartikel';

  @override
  String get bmHubNoDrugsToSell => 'Keine Medikamente zum Verkaufen';

  @override
  String get bmHubNoCryptoToSell => 'Keine Kryptowährung zum Verkauf';

  @override
  String get bmHubNoTradeGoodsToSell => 'Keine Handelsware zum Verkauf';

  @override
  String get bmHubListDrugTitle => 'Listen Sie Medikamente auf';

  @override
  String get bmHubListDrugSelectLabel => 'Medikamentenstapel';

  @override
  String get bmHubListCryptoTitle => 'Krypto auflisten';

  @override
  String get bmHubListCryptoSelectLabel => 'Vermögenswert';

  @override
  String get bmHubListTradeTitle => 'Handelswaren auflisten';

  @override
  String get bmHubListTradeSelectLabel => 'Gut';

  @override
  String get bmHubQuantityGrams => 'Menge (g)';

  @override
  String get bmHubQuantityCrypto => 'Menge';

  @override
  String get bmHubQuantityUnits => 'Menge';

  @override
  String get bmHubSellCarriedItem => 'Item verkaufen';

  @override
  String bmHubToolQtyDurability(int qty, int pct) {
    return 'Menge $qty • $pct% Zustand';
  }

  @override
  String bmHubToolBaseValue(int price) {
    return 'Richtpreis €$price';
  }

  @override
  String get bmHubBuyToolTitle => 'Item kaufen';

  @override
  String bmHubBuyToolConfirm(String name, String price) {
    return '$name für $price kaufen?';
  }

  @override
  String get bmHubToolPurchased => 'Item gekauft';

  @override
  String get bmHubToolPurchaseFailed => 'Kauf fehlgeschlagen';

  @override
  String get bmHubDelistToolTitle => 'Inserat entfernen';

  @override
  String bmHubDelistToolConfirm(String name) {
    return '$name vom Markt nehmen?';
  }

  @override
  String get bmHubToolDelisted => 'Inserat entfernt';

  @override
  String get bmHubListToolTitle => 'Item auf dem Markt listen';

  @override
  String get bmHubListToolSelectLabel => 'Getragenes Item';

  @override
  String get bmHubListToolSubmit => 'Listen';

  @override
  String get bmHubToolListedMessage => 'Item ist jetzt gelistet';

  @override
  String get bmHubListToolFailed => 'Listen fehlgeschlagen';

  @override
  String get bmHubLoadCarriedToolsFailed =>
      'Inventar konnte nicht geladen werden';

  @override
  String get bmHubNoCarriedToolsToSell =>
      'Keine getragenen Items (oder bereits gelistet)';

  @override
  String get bmHubInvalidToolPrice => 'Gib einen gültigen Preis ein';

  @override
  String get arrested => 'Verhaftet!';

  @override
  String get jailMessage =>
      'Sie wurden während Ihrer Reise verhaftet und alle Waren wurden beschlagnahmt!';

  @override
  String get confirmAction => 'Bist du sicher?';

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
  String get hitlistErrMissingBounty =>
      'Es ist ein Kopfgeldbetrag erforderlich';

  @override
  String get hitlistErrBountyTooLow => 'Das Mindestprämie beträgt 50.000 €';

  @override
  String get hitlistErrCannotHitYourself =>
      'Sie können sich selbst keinen Schlag versetzen';

  @override
  String get hitlistErrHitAlreadyExists =>
      'Sie haben bereits einen aktiven Zugriff auf diesen Spieler';

  @override
  String get hitlistErrInsufficientMoney => 'Du hast nicht genug Geld';

  @override
  String get hitlistErrMissingCounterBounty =>
      'Gegenprämienbetrag ist erforderlich';

  @override
  String get hitlistErrHitNotFound => 'Treffer nicht gefunden';

  @override
  String get hitlistErrNotTarget => 'Nur das Ziel kann ein Gegengebot abgeben';

  @override
  String get hitlistErrHitNotActive => 'Hit ist nicht aktiv';

  @override
  String get hitlistErrCounterBountyMustBeHigher =>
      'Die Gegenprämie muss höher sein als die ursprüngliche Prämie';

  @override
  String get hitlistErrMissingWeapon => 'Waffe ist erforderlich';

  @override
  String get hitlistErrWeaponNotFound => 'Waffe nicht gefunden';

  @override
  String get hitlistErrWeaponNotOwned =>
      'Sie besitzen diese Waffe nicht oder sie ist kaputt';

  @override
  String get hitlistErrWeaponBroken =>
      'Ihre ausgewählte Waffe ist kaputt. Repariere es zuerst.';

  @override
  String get hitlistErrInsufficientAmmo => 'Sie haben nicht genug Munition';

  @override
  String get hitlistErrInvalidAmmoHit => 'Ungültige Munitionsmenge';

  @override
  String get hitlistErrTargetUnderHitProtection =>
      'Das Ziel verfügt über einen aktiven Trefferschutz';

  @override
  String get hitlistErrInvalidInvestigationTier =>
      'Ungültiger Untersuchungstyp';

  @override
  String get hitlistErrInvestigationAlreadyPending =>
      'Zu diesem Treffer läuft bereits eine Untersuchung. Warten Sie auf Ihre Detektivnachricht.';

  @override
  String get hitlistErrInvalidCaseId => 'Ungültige Fallaktennummer';

  @override
  String get hitlistErrMurderCaseNotFound => 'Falldatei nicht gefunden';

  @override
  String get hitlistErrMurderCaseExpired =>
      'Untersuchungsfenster abgelaufen (24 Stunden)';

  @override
  String get hitlistErrMurderCaseAlreadyRequested =>
      'Die Ermittlungen zu diesem Fall wurden bereits eingeleitet';

  @override
  String get hitlistErrNotPlacer =>
      'Nur der Placer kann den Treffer annullieren';

  @override
  String get hitlistInvestigationOptions => 'Untersuchungsmöglichkeiten';

  @override
  String get hitlistInvestigationChooseSpeedPrice =>
      'Wählen Sie Geschwindigkeit und Preis:';

  @override
  String get hitlistInvestigationQuick =>
      'Schnelle Untersuchung (1.000.000 € • 1 Stunde)';

  @override
  String get hitlistInvestigationStandard =>
      'Standarduntersuchung (500.000 € • 6 Stunden)';

  @override
  String get hitlistInvestigationSlow =>
      'Langsame Untersuchung (250.000 € • 24 Stunden)';

  @override
  String hitlistInvestigationQueued(
    String cost,
    String etaMinutes,
    String resolveAt,
  ) {
    return 'Die Ermittlungen sind in der Warteschlange. Kosten $cost. voraussichtliche Ankunftszeit: $etaMinutes min. Der Bericht wird über Nachrichten des Detektivbüros eingehen (ca. $resolveAt).';
  }

  @override
  String get hitlistInvestigationFailedGeneric =>
      'Die Ermittlungen scheiterten';

  @override
  String get hitlistInvestigationCouldNotComplete =>
      'Die Untersuchung konnte nicht abgeschlossen werden';

  @override
  String hitlistHitSuccessWithLoot(String cash, String items) {
    return 'Erfolgreich getroffen! Erhaltenes Kopfgeld und Beute: Bargeld $cash, getragene Gegenstände $items.';
  }

  @override
  String get hitlistAttemptTimeout =>
      'Zeitüberschreitung beim Trefferversuch. Bitte versuchen Sie es erneut.';

  @override
  String get hitlistNoUsableWeapons =>
      'Sie haben keine verwendbaren Waffen in Ihrem Inventar. Kaufen oder reparieren Sie zuerst eine Waffe.';

  @override
  String hitlistWeaponsInventoryLoadError(String error) {
    return 'Fehler beim Laden der Waffen: $error';
  }

  @override
  String hitlistPlayersLoadError(String error) {
    return 'Fehler beim Laden der Spieler: $error';
  }

  @override
  String get hitlistRelativeOneDayAgo => 'Vor 1 Tag';

  @override
  String hitlistRelativeDaysAgo(String count) {
    return 'Vor $count Tagen';
  }

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
  String eachGivesDefenseAmount(String defense) {
    return '+$defense Verteidigung';
  }

  @override
  String get repairArmor => 'Reparieren';

  @override
  String get armorRepaired => 'Weste repariert';

  @override
  String get couldNotRepairArmor => 'Weste konnte nicht repariert werden';

  @override
  String get couldNotDismissBodyguard =>
      'Leibwächter konnte nicht entlassen werden';

  @override
  String vestTradeInCredit(String amount) {
    return 'Inzahlungnahme $amount';
  }

  @override
  String get vestTradeInHint =>
      'Beim Kauf einer weiteren Weste erhalten Sie je nach Zustand einen Teil Ihrer aktuellen Weste gutgeschrieben. Die Reparatur einer abgenutzten Weste ist günstiger als der Austausch.';

  @override
  String get upgradeArmor => 'Upgrade';

  @override
  String get vestWeakVsStab => 'Schwach gegen Stich';

  @override
  String get vestWeakVsBullets => 'Schwach gegen Kugeln';

  @override
  String get vestWeakVsAp => 'Schwach gegen AP';

  @override
  String get bodyguardStreet => 'Straßenmuskel';

  @override
  String get bodyguardStreetDesc =>
      'Günstige zusätzliche Augen. Geringere Verteidigung, geringerer Tageslohn.';

  @override
  String get bodyguardStandard => 'Leibwächterin';

  @override
  String get bodyguardStandardDesc =>
      'Standardschutz. +10 Verteidigung und 10.000 € Tageslohn.';

  @override
  String get bodyguardElite => 'Elite-Leibwächter';

  @override
  String get bodyguardEliteDesc =>
      'Näher verhärtet. Höhere Verteidigung und ein höherer Tageslohn.';

  @override
  String get bodyguardDismiss => 'Zurückweisen';

  @override
  String bodyguardCapLine(String used, String cap) {
    return '$used / $cap Leibwächter';
  }

  @override
  String get bodyguardCapReached => 'Bodyguard-Limit erreicht';

  @override
  String bodyguardHired(String name) {
    return 'Angestellt $name';
  }

  @override
  String bodyguardDismissed(String name) {
    return 'Entlassen $name';
  }

  @override
  String armorConditionPercent(String percent) {
    return 'Zustand $percent%';
  }

  @override
  String get securityErrorNoArmor => 'Du trägst keine Weste';

  @override
  String get securityErrorArmorNotDamaged =>
      'Diese Weste ist bereits in vollem Zustand';

  @override
  String get securityErrorBodyguardCap =>
      'Sie haben bereits die maximale Anzahl an Leibwächtern';

  @override
  String get securityErrorInvalidBodyguardType => 'Ungültiger Bodyguard-Typ';

  @override
  String get securityErrorNotEnoughBodyguards =>
      'Es gibt nicht so viele Leibwächter dieser Art';

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
  String get stabVest => 'Stichweste';

  @override
  String get stabVestDesc => 'Schützt vor Messern. Schwach gegen Kugeln.';

  @override
  String get bulletproofVestDesc => 'Standardschutz gegen normale Munition.';

  @override
  String get bulletproofVestPremium => 'Kugelsichere Weste Premium';

  @override
  String get bulletproofVestPremiumDesc =>
      'Schwerere Platten gegen normale Schüsse.';

  @override
  String get ceramicApVest => 'AP-Plattenweste';

  @override
  String get ceramicApVestDesc =>
      'Keramikplatten gegen panzerbrechende Munition.';

  @override
  String get vestProtectsStab => 'Stich';

  @override
  String get vestProtectsBullets => 'Kugeln';

  @override
  String get vestProtectsAp => 'Panzerbrechend';

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
  String get replaceArmor => 'Ersetzen';

  @override
  String get bodyguardProductName => 'Leibwächterin';

  @override
  String securityLoadError(String error) {
    return 'Fehler beim Laden der Sicherheit: $error';
  }

  @override
  String get securityStatusLoadFailed =>
      'Der Sicherheitsstatus konnte nicht geladen werden.';

  @override
  String armorConditionLine(String percent, String base) {
    return 'Zustand $percent% · Basis $base';
  }

  @override
  String dailyWageAmount(String amount) {
    return 'Tageslohn $amount';
  }

  @override
  String dailySystemCostLine(String amount) {
    return 'Tägliche Systemkosten: $amount';
  }

  @override
  String nextPayrollAt(String datetime) {
    return 'Nächste Gehaltsabrechnung: $datetime';
  }

  @override
  String get bodyguardsLeaveIfUnpaid =>
      'Wenn Sie den Tageslohn nicht bezahlen können, gehen alle Leibwächter.';

  @override
  String get armorOneAtATimeHint =>
      'Sie können jeweils nur eine Weste tragen. Reparieren Sie eine beschädigte Weste oder kaufen Sie eine neue und erhalten Sie eine zustandsabhängige Inzahlungnahme der Weste, die Sie ersetzen.';

  @override
  String armorDefenseNowAtCondition(String defense, String percent) {
    return 'Jetzt +$defense bei $percent %';
  }

  @override
  String get couldNotBuyBodyguard => 'Bodyguard konnte nicht gekauft werden';

  @override
  String get couldNotBuyArmor => 'Rüstung konnte nicht gekauft werden';

  @override
  String get armorAlreadyEquippedLong =>
      'Du trägst diese Rüstung bereits. Du kannst jeweils nur 1 Rüstung tragen.';

  @override
  String get securityErrorArmorNotFound => 'Rüstung nicht gefunden';

  @override
  String get securityErrorMinQuantity => 'Die Menge muss mindestens 1 betragen';

  @override
  String get hit => 'SCHLAG';

  @override
  String get counterBidLabel => 'GEGENGEBOT';

  @override
  String daysAgo(String count, String plural) {
    return 'Vor $count Tag$plural';
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
  String get hitDefendedBySecurity =>
      'Das Ziel hat überlebt – der Vertrag bleibt offen. Leibwächter und HP wurden getroffen; Versuchen Sie es nach der Abklingzeit erneut.';

  @override
  String hitDefendedAttrition(String guards, String health) {
    return '$guards Leibwächter niedergeschlagen, Ziel -$health HP. Nächster Versuch in 10 Minuten.';
  }

  @override
  String hitCombatAttackerAttrition(String guards, String health) {
    return 'Du hast $guards Leibwächter und $health HP verloren.';
  }

  @override
  String hitlistErrCombatCooldown(String minutes) {
    return 'Das Ziel steht immer noch unter Beschuss. Versuchen Sie es in $minutes Minuten erneut.';
  }

  @override
  String hitCombatBreakdown(String armor, String guards, String chance) {
    return 'Weste +$armor · Leibwächter +$guards · deine Chance $chance%';
  }

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
    return '$rounds Schuss pro Box';
  }

  @override
  String ammoYouWillReceive(String rounds) {
    return 'Sie erhalten: $rounds Schuss';
  }

  @override
  String ammoTotalCost(String cost) {
    return 'Gesamtkosten: $cost';
  }

  @override
  String get ammoRounds => 'Schuss';

  @override
  String get ammoGeneric => 'Munition';

  @override
  String get ammoPerCrimeSuffix => 'pro Verbrechen';

  @override
  String get ammoBoxesUnit => 'Boxen';

  @override
  String get ammoStock => 'Vorrat';

  @override
  String get ammoQuality => 'Qualität';

  @override
  String get factoryBought => 'Fabrik gekauft';

  @override
  String get factoryProduced => 'Produktion aktualisiert';

  @override
  String get factorySessionStarted =>
      'Produktion gestartet: 8 Stunden aktiv, Anspruch alle 20 Minuten';

  @override
  String get ammoFactoryTitle => 'Munitionsfabrik';

  @override
  String get ammoFactoryIntro =>
      'Produziert in Chargen; Sie beanspruchen alle 20 Minuten (bis zu 8 Stunden Rückstand pro Sitzung).';

  @override
  String get ammoFactoryWhatYouCanDo => 'Was Sie tun können:';

  @override
  String get ammoFactoryActionBuy =>
      'Kaufen Sie eine Fabrik in Ihrem aktuellen Land';

  @override
  String get ammoFactoryActionProduce =>
      'Anspruchserstellung (Intervall: 20 Minuten, maximaler Rückstand: 8 Stunden pro Sitzung)';

  @override
  String get ammoFactoryActionOutput =>
      'Verbessere die Leistung auf Stufe 5, um mehr Runden pro Anspruch zu erhalten';

  @override
  String get ammoFactoryActionQuality =>
      'Verbessern Sie die Qualität für höhere Marktpreise';

  @override
  String get ammoFactoryBlackMarketTitle => 'Munition zu verkaufen';

  @override
  String get ammoFactoryBlackMarketBody =>
      'Die Munitionsfabrik verkauft über diesen Bildschirm keine Kugeln direkt. Nutzen Sie den Schwarzmarkt zum Kauf und Verkauf von Munition.';

  @override
  String get ammoFactoryActionBlackMarket =>
      'Kaufen und verkaufen Sie Munition über den Schwarzmarkt, nicht direkt in der Fabrik.';

  @override
  String get ammoFactoryPurchasePriceLabel => 'Purchase price';

  @override
  String get ammoFactoryRequirementsTitle => 'Requirements';

  @override
  String get ammoFactoryRequirementsComplete => 'All requirements met';

  @override
  String get ammoFactoryGoToSchool => 'Go to School';

  @override
  String ammoFactoryBuyFor(String price) {
    return 'Buy for $price';
  }

  @override
  String get ammoFactoryErrCountryRequired => 'Land ist erforderlich';

  @override
  String get ammoFactoryErrPlayerNotFound => 'Spieler nicht gefunden';

  @override
  String get ammoFactoryErrWrongCountry =>
      'Sie müssen im selben Land sein, um diese Fabrik zu kaufen';

  @override
  String get ammoFactoryErrCouldNotPurchase =>
      'Fabrik konnte nicht gekauft werden';

  @override
  String get ammoFactoryErrAlreadyOwned => 'Die Fabrik ist bereits im Besitz';

  @override
  String get ammoFactoryErrInsufficientMoneyBuy =>
      'Nicht genug Geld, um eine Fabrik zu kaufen';

  @override
  String get ammoFactoryErrCouldNotProduce =>
      'Es konnte keine Munition produziert werden';

  @override
  String get ammoFactoryErrNotOwned => 'Sie besitzen keine Fabrik';

  @override
  String get ammoFactoryErrOnCooldown => 'Die Fabrik befindet sich im Cooldown';

  @override
  String get ammoFactoryErrInactive =>
      'Das Eigentum an der Fabrik ging aufgrund von Inaktivität verloren';

  @override
  String get ammoFactoryErrCouldNotUpgrade =>
      'Die Fabrik konnte nicht aktualisiert werden';

  @override
  String get ammoFactoryErrInsufficientMoneyUpgrade =>
      'Nicht genug Geld, um die Fabrik zu modernisieren';

  @override
  String get ammoFactoryErrMaxLevel =>
      'Werksseitig ist bereits die maximale Stufe erreicht';

  @override
  String get ammoFactoryErrInvalidUpgradeType =>
      'Der Upgrade-Typ muss „Ausgabe“ oder „Qualität“ sein';

  @override
  String get ammoFactoryErrEducationNotMet =>
      'Bildungsvoraussetzungen nicht erfüllt';

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
      'Produktionsfenster: aktiv (20-Minuten-Intervall)';

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
  String get shootingIntro =>
      'Verbessern Sie Ihre Genauigkeit und erhöhen Sie Ihre Erfolgsquote bei Straftaten';

  @override
  String get shootingTrainSuccess => 'Ausbildung abgeschlossen';

  @override
  String get shootingMaxSessionsReached =>
      'Maximale Trainingseinheiten erreicht';

  @override
  String get shootingTrainingProgressTitle => 'Trainingsfortschritt';

  @override
  String get shootingSessionsCompletedLabel => 'Abgeschlossene Sitzungen:';

  @override
  String get shootingProgressCompleteSuffix => 'vollständig';

  @override
  String get shootingCurrentBonusTitle => 'Aktueller Bonus';

  @override
  String get shootingAccuracyBonusLabel => 'Genauigkeitsbonus';

  @override
  String get shootingMaximumLabel => 'Maximal';

  @override
  String get shootingBonusAppliedToCrimes =>
      'Dieser Bonus wird auf alle Ihre Kriminalitätsversuche angewendet';

  @override
  String get shootingReadyToTrain => 'Bereit zum Training';

  @override
  String get shootingTrainingCooldownTitle => 'Abklingzeit des Trainings';

  @override
  String shootingCooldownLabel(String time) {
    return 'Nächste Sitzung um: $time';
  }

  @override
  String get shootingCooldownHint =>
      'Zwischen den Trainingseinheiten müssen Sie 1 Stunde warten';

  @override
  String get shootingTrainingInProgress => 'Ausbildung...';

  @override
  String get shootingHowItWorksTitle => 'Wie funktioniert es?';

  @override
  String get shootingHowItWorksBullet1 =>
      '• Trainieren Sie jede Stunde, um die Genauigkeit zu steigern';

  @override
  String get shootingHowItWorksBullet2 =>
      '• Jede Sitzung bringt einen Bonus von +0,1 %';

  @override
  String get shootingHowItWorksBullet3 =>
      '• Maximal 100 Sitzungen (+10 % insgesamt)';

  @override
  String get shootingHowItWorksBullet4 =>
      '• Erhöht Ihre Erfolgsquote bei Straftaten';

  @override
  String get shootingHowItWorksBullet5 =>
      '• Permanenter Bonus, jede Sitzung zählt';

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
  String get shootingTrain => 'Trainieren';

  @override
  String get trainingHubMenuLabel => 'Ausbildung';

  @override
  String get trainingHubTitle => 'Schulungszentrum';

  @override
  String get trainingHubSubtitle =>
      'Trainieren Sie Kraft im Fitnessstudio und Genauigkeit am Schießstand. Jeder Track stapelt bis zu 100 Sitzungen mit einer Abklingzeit von 1 Stunde und erhöht Ihre Erfolgsaussichten bei einem Verbrechen.';

  @override
  String get trainingHubSectionGym => 'Fitnessstudio';

  @override
  String get trainingHubSectionShooting => 'Schießstand';

  @override
  String get trainingHubRefreshStatus => 'Aktualisieren';

  @override
  String get trainingHubRefreshTooltip => 'Status vom Server neu laden';

  @override
  String get trainingHubOpenCrimes => 'Offene Verbrechen';

  @override
  String get trainingHubOpenCrimesHint =>
      'Aktive Boni werden auf dem Bildschirm „Verbrechen“ angezeigt.';

  @override
  String get trainingHubMoreInfoTitle => 'Weitere Informationen und Optionen';

  @override
  String get trainingHubMoreInfoCombo =>
      'Gleicher UTC-Kalendertag: Absolvieren Sie mindestens eine Trainingseinheit im Fitnessstudio und eine Trainingseinheit auf dem Schießstand, um einen kleinen zusätzlichen Kriminalitätserfolgsbonus (+0,5 %) zu erhalten.';

  @override
  String get trainingHubMoreInfoSeparate =>
      'Fitnessstudio und Schießstand behalten jeweils ihre eigene Abklingzeit von 1 Stunde und die Obergrenze von 100 Sitzungen.';

  @override
  String get trainingHubMoreInfoHitlist =>
      'Der Fortschritt des Schießstandes fließt auch in die Trefferlistenberechnungen auf dem Server ein.';

  @override
  String trainingHubHitlistAccuracy(String pct) {
    return 'Hitlist accuracy: $pct%';
  }

  @override
  String get trainingSummaryTitle => 'Training circuit';

  @override
  String get trainingSummaryOpenHub => 'Open hub';

  @override
  String get trainingSummaryComboActive => 'Combo active today';

  @override
  String get trainingSummaryComboInactive =>
      'Train gym + range today for combo bonus';

  @override
  String trainingHubComboChip(String pct) {
    return 'Combo aktiv: +$pct % auf Verbrechen';
  }

  @override
  String get gym => 'Fitnessstudio';

  @override
  String get gymIntro =>
      'Trainieren Sie Ihre Kraft und erhöhen Sie Ihre Erfolgsquote bei Straftaten';

  @override
  String get gymTrainSuccess => 'Ausbildung abgeschlossen';

  @override
  String get gymMaxSessionsReached => 'Maximale Sitzungsanzahl erreicht';

  @override
  String get gymTrainingProgressTitle => 'Trainingsfortschritt';

  @override
  String get gymSessionsCompletedLabel => 'Abgeschlossene Sitzungen:';

  @override
  String get gymProgressCompleteSuffix => 'vollständig';

  @override
  String get gymCurrentBonusTitle => 'Aktueller Bonus';

  @override
  String gymSessions(String count) {
    return 'Sitzungen: $count/100';
  }

  @override
  String get gymStrengthBonusLabel => 'Stärkebonus';

  @override
  String get gymMaximumLabel => 'Maximal';

  @override
  String gymStrengthBonus(String bonus) {
    return 'Stärkebonus: $bonus %';
  }

  @override
  String get gymBonusAppliedToCrimes =>
      'Dieser Bonus wird auf alle Ihre Kriminalitätsversuche angewendet';

  @override
  String get gymReadyToTrain => 'Bereit zum Training';

  @override
  String get gymTrainingCooldownTitle => 'Abklingzeit des Trainings';

  @override
  String gymCooldown(String time) {
    return 'Nächste Sitzung um $time';
  }

  @override
  String get gymCooldownHint =>
      'Zwischen den Trainingseinheiten müssen Sie 1 Stunde warten';

  @override
  String get gymTrain => 'Zug';

  @override
  String get gymTrainingInProgress => 'Ausbildung...';

  @override
  String get gymHowItWorksTitle => 'Wie funktioniert es?';

  @override
  String get gymAggregateBonusTitle => 'Total gym crime bonus';

  @override
  String get gymTrackStrengthTitle => 'Strength';

  @override
  String get gymTrackSpeedTitle => 'Speed';

  @override
  String get gymTrackStaminaTitle => 'Stamina';

  @override
  String get gymTrackBonusLabel => 'Track bonus';

  @override
  String get gymSmartTrain => 'Smart train';

  @override
  String get gymSmartTrainHint =>
      'Trains the first track that is ready (strength, then speed, then stamina).';

  @override
  String get gymCountdownReady => 'Ready';

  @override
  String gymCountdownLabel(String time) {
    return 'Next in $time';
  }

  @override
  String get gymHowItWorksBullet1 =>
      '• Trainieren Sie jede Stunde für einen Kraftschub';

  @override
  String get gymHowItWorksBullet2 =>
      '• Jede Sitzung bringt einen Bonus von +0,08 %';

  @override
  String get gymHowItWorksBullet3 => '• Maximal 100 Sitzungen (+8 % insgesamt)';

  @override
  String get gymHowItWorksBullet4 =>
      '• Erhöht Ihre Erfolgsquote bei Straftaten';

  @override
  String get gymHowItWorksBullet5 => '• Permanenter Bonus, jede Sitzung zählt';

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
  String get countryPortugal => 'Portugal';

  @override
  String get countryIreland => 'Irland';

  @override
  String get countryLuxembourg => 'Luxemburg';

  @override
  String get countryAustria => 'Österreich';

  @override
  String get countryDenmark => 'Dänemark';

  @override
  String get countrySweden => 'Schweden';

  @override
  String get countryNorway => 'Norwegen';

  @override
  String get countryFinland => 'Finnland';

  @override
  String get countryPoland => 'Polen';

  @override
  String get countryCzechia => 'Tschechien';

  @override
  String get countryGreece => 'Griechenland';

  @override
  String get countryTurkey => 'Türkei';

  @override
  String get countryUae => 'Vereinigte Arabische Emirate';

  @override
  String get countryDubai => 'Dubai';

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
  String get toolThermalDrill => 'Thermobohrer';

  @override
  String get toolCategoryBoltCutter => 'Bolzenschneider';

  @override
  String get toolCategoryBurglaryKit => 'Einbruchset';

  @override
  String get toolCategoryCarTools => 'Werkzeuge für Autodiebstahl';

  @override
  String get toolCategoryJerryCan => 'Jerry kann';

  @override
  String get toolCategorySprayPaint => 'Sprühfarbe';

  @override
  String get toolCategoryCrowbar => 'Brecheisen';

  @override
  String get toolCategoryGlassCutter => 'Glasschneider';

  @override
  String get toolCategoryLaptop => 'Laptop';

  @override
  String get toolCategoryCounterfeiting => 'Fälschung';

  @override
  String get toolCategoryToolbox => 'Werkzeugkasten';

  @override
  String get toolCategoryRope => 'Seil';

  @override
  String get toolCategorySilencer => 'Schalldämpfer';

  @override
  String get toolCategoryFakeDocs => 'Gefälschte Dokumente';

  @override
  String get toolCategoryNightVision => 'Nachtsicht';

  @override
  String get toolCategoryBurnerPhone => 'Brennertelefon';

  @override
  String get toolCategoryGpsJammer => 'GPS-Störsender';

  @override
  String get toolCategoryThermalDrill => 'Thermobohrer';

  @override
  String get toolsScreenTitle => 'Schwarzmarkt – Werkzeuge';

  @override
  String get toolsTabBuy => 'Kaufen';

  @override
  String get toolsTabMyTools => 'Meine Werkzeuge';

  @override
  String get toolsNoToolsAvailable => 'Keine Werkzeuge vorhanden';

  @override
  String get toolsEmptyInventoryTitle => 'Sie haben noch kein Werkzeug';

  @override
  String get toolsEmptyInventoryHint => 'Kaufen Sie Werkzeuge im Shop';

  @override
  String get toolsNotEnoughMoney => 'Du hast nicht genug Geld!';

  @override
  String get toolsNotEnoughMoneyRepair =>
      'Sie haben nicht genug Geld für die Reparatur!';

  @override
  String get toolsBuyError => 'Fehler beim Kauf';

  @override
  String get toolsRepairError => 'Fehler beim Reparieren';

  @override
  String toolsPurchased(String toolName) {
    return '$toolName gekauft!';
  }

  @override
  String toolsRepaired(String toolName, String cost) {
    return '$toolName repariert für 1 €⟧';
  }

  @override
  String get toolsBadgeInventoryFull => 'VOLL';

  @override
  String get toolsBadgeBroken => 'GEBROCHEN';

  @override
  String get toolsBadgeRepair => 'REPARIEREN';

  @override
  String toolsLoadError(String error) {
    return 'Werkzeuge konnten nicht geladen werden: $error';
  }

  @override
  String get toolsErrToolNotFound => 'Werkzeug nicht gefunden.';

  @override
  String get toolsErrInventoryFullBuy =>
      'Ihr Inventar ist voll. Lagern Sie einige Werkzeuge oder erweitern Sie die Kapazität.';

  @override
  String get toolsErrPurchaseServer =>
      'Der Kauf des Tools ist aufgrund eines Serverproblems fehlgeschlagen.';

  @override
  String get toolsErrToolNotOwned => 'Sie besitzen dieses Tool nicht.';

  @override
  String get toolsErrAlreadyMaxDurability =>
      'Das Werkzeug hat bereits die maximale Haltbarkeit erreicht.';

  @override
  String get toolsErrRepairServer =>
      'Die Reparatur des Tools ist aufgrund eines Serverproblems fehlgeschlagen.';

  @override
  String toolsNetworkError(String error) {
    return 'Netzwerkfehler: $error';
  }

  @override
  String get crimeOutcomeSuccess => 'Krimi erfolgreich!';

  @override
  String get crimeOutcomeFailed => 'Krimi fehlgeschlagen';

  @override
  String get jobOutcomeSuccess => 'Arbeit erledigt!';

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
  String get crimeResultMoneyLabel => 'Geld';

  @override
  String get crimeResultXpLabel => 'XP';

  @override
  String crimeResultVehicleConditionLoss(int percent) {
    return 'Vehicle condition −$percent%';
  }

  @override
  String crimeResultVehicleFuelUsed(int percent) {
    return 'Fuel used −$percent%';
  }

  @override
  String get crewHeistsTitle => 'Crew heists';

  @override
  String get crewHeistsSubtitle =>
      'Plan a crew job. The leader\'s getaway vehicle takes wear and fuel.';

  @override
  String get crewHeistsRequiresVehicle => 'Getaway vehicle required (leader)';

  @override
  String get crewHeistsNoVehicle =>
      'Select a crime vehicle in your garage first.';

  @override
  String crewHeistsVehicleLine(String name, int condition, int fuel) {
    return '$name · $condition% condition · $fuel% fuel';
  }

  @override
  String get crewHeistsStart => 'Start heist';

  @override
  String get crewHeistsLeaderOnly => 'Only the crew leader can start heists.';

  @override
  String crewHeistsMembersRequired(int current, int required) {
    return '$current/$required members';
  }

  @override
  String crewHeistsSuccessRate(int rate) {
    return '$rate% success chance';
  }

  @override
  String get crewHeistsEmpty => 'No heists available for your crew level yet.';

  @override
  String get crewHeistsLoadError => 'Could not load crew heists.';

  @override
  String get crimeOutcomeRowReward => 'Belohnen:';

  @override
  String get crimeOutcomeRowXp => 'XP:';

  @override
  String get crimeOutcomeRowTools => 'Werkzeuge:';

  @override
  String crimeOutcomeToolDurabilityValue(int percent) {
    return '-$percent% Haltbarkeit';
  }

  @override
  String get icuIntensiveCareTitle => 'Intensivpflege';

  @override
  String get icuInjuredLine =>
      'Sie wurden bei Ihren kriminellen Aktivitäten schwer verletzt.';

  @override
  String get icuUnconsciousLine =>
      'Sie liegen jetzt auf der Intensivstation und sind bewusstlos.';

  @override
  String get icuRecoveryTimeLabel => 'Erholungszeit:';

  @override
  String get icuWakeHp => 'Du wachst mit 10 PS auf';

  @override
  String get icuNoActionsHint =>
      'Während dieser Zeit können Sie keine Aktionen ausführen.\nGehen Sie vorsichtiger mit Ihrer Gesundheit um!';

  @override
  String jailBailPaidSnackbar(int amount) {
    return '🎉 Du bist frei! Kaution bezahlt: $amount €';
  }

  @override
  String jailInsufficientBail(int amount) {
    return 'Nicht genug Geld für die Kaution ($amount)';
  }

  @override
  String jailCooldownWait(int seconds) {
    return 'Bitte warten: ${seconds}s';
  }

  @override
  String get jailEscapeSuccess => 'Flucht gelungen! Du bist frei.';

  @override
  String jailEscapeFailed(String penalty) {
    return 'Die Flucht ist fehlgeschlagen. Satz um $penalty verlängert.';
  }

  @override
  String get jailEscapeGenericFailure => 'Die Flucht ist fehlgeschlagen';

  @override
  String jailErrorPrefix(String message) {
    return 'Fehler: $message';
  }

  @override
  String get jailTimeLeft => 'Übrige Zeit';

  @override
  String jailPayBail(int amount) {
    return 'Kaution zahlen (€$amount)';
  }

  @override
  String get jailCannotActWhileIn =>
      'Während der Verbüßung Ihrer Strafe dürfen Sie keine Straftaten begehen, arbeiten oder reisen.';

  @override
  String get jailAttemptEscape => 'Fluchtversuch';

  @override
  String get jailYouAreInJail => 'Du bist im Gefängnis';

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
  String get prostitutionMoveToRedLight => 'Zum Rotlichtviertel';

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
  String get prostitutionDistrictOwnedBadge => 'Im Besitz';

  @override
  String get prostitutionOwnerLabel => 'Eigentümer:';

  @override
  String get prostitutionForSale => 'Zu verkaufen';

  @override
  String get prostitutionRoomsLabel => 'Zimmer:';

  @override
  String get prostitutionRoomsRented => 'vermietet';

  @override
  String prostitutionRldAppBarTitle(String country) {
    return 'Rotlichtviertel ($country)';
  }

  @override
  String get prostitutionOccupiedShort => 'Belegt';

  @override
  String get prostitutionNotApplicable => 'k. A.';

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
  String get prostitutionTabWorkers => 'Arbeiter';

  @override
  String get prostitutionTabRld => 'RLD';

  @override
  String get prostitutionTabEvents => 'Veranstaltungen';

  @override
  String get prostitutionTabSocial => 'Sozial';

  @override
  String get prostitutionRecruitCeremonyTitle => 'Neuer Rekrut';

  @override
  String prostitutionCollectConfirm(String amount) {
    return '$amount € an ausstehenden Einnahmen einsammeln?';
  }

  @override
  String get prostitutionCollectEmpty =>
      'Im Moment können keine Einnahmen erzielt werden.';

  @override
  String prostitutionCollectSuccess(String amount) {
    return '$amount € gesammelt.';
  }

  @override
  String get prostitutionCollectFailed =>
      'Einnahmen konnten nicht eingezogen werden.';

  @override
  String get prostitutionWorkersKpi => 'Arbeiter (S/RLD/NC)';

  @override
  String get prostitutionHourlyKpi => '€/Stunde';

  @override
  String get prostitutionRecruitReady => 'Bereit';

  @override
  String get prostitutionRetry => 'Wiederholen';

  @override
  String get prostitutionMove => 'Bewegen';

  @override
  String get prostitutionFbiHeat => 'FBI-Hitze';

  @override
  String get prostitutionRaidStatsTitle => 'Überfallrisiko';

  @override
  String get prostitutionRaidStatsDistricts => 'Bezirke';

  @override
  String get prostitutionRaidStatsBusted => 'Derzeit kaputt';

  @override
  String prostitutionUpgradeTierConfirm(String tier, String cost) {
    return 'Upgrade-Stufe auf $tier für $cost €?';
  }

  @override
  String prostitutionUpgradeSecurityConfirm(String level, String cost) {
    return 'Sicherheit auf Stufe $level für $cost € upgraden?';
  }

  @override
  String prostitutionRoomsOccupied(String occupied, String total) {
    return '$occupied/$total Räume';
  }

  @override
  String prostitutionNextEarnings(String net) {
    return 'Weiter: $net/h netto';
  }

  @override
  String prostitutionCurrentEarningsNet(String net) {
    return 'Jetzt: $net/h netto';
  }

  @override
  String prostitutionRaidReduction(String pct) {
    return 'Raid-Reduktion: $pct';
  }

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
  String get achievementsSectionProgress => 'Fortschritt';

  @override
  String achievementsPercentComplete(int percent) {
    return '$percent % abgeschlossen';
  }

  @override
  String get achievementsCategoryNameProstitution => 'Prostitution';

  @override
  String get achievementsCategoryNameRld => 'RLD';

  @override
  String get achievementsCategoryNameCrimes => 'Verbrechen';

  @override
  String get achievementsCategoryNameJobs => 'Jobs';

  @override
  String get achievementsCategoryNameSchool => 'Schule';

  @override
  String get achievementsCategoryNameVehicles => 'Fahrzeuge';

  @override
  String get achievementsCategoryNameTravel => 'Reisen';

  @override
  String get achievementsCategoryNameDrugs => 'Drogen';

  @override
  String get achievementsCategoryNameTrade => 'Handel';

  @override
  String get achievementsCategoryNameGeneral => 'Allgemein';

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
  String schoolTrainBonusLevels(int count) {
    return '+$count Lv';
  }

  @override
  String schoolTrainBonusCerts(int count) {
    return '+$count Zert.';
  }

  @override
  String schoolTrainSuccessToast(
    String trackName,
    int xpGain,
    String bonusSuffix,
    String cooldownLabel,
    String cooldown,
  ) {
    return '$trackName: +$xpGain XP$bonusSuffix · $cooldownLabel $cooldown';
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
  String get schoolGateAssetDrugFacilitySlotsTier1 =>
      'Aktivposten: Erweiterung des Steckplatzes für Arzneimitteleinrichtungen I';

  @override
  String get schoolGateAssetDrugFacilitySlotsTier2 =>
      'Aktivposten: Erweiterung des Steckplatzes für Arzneimitteleinrichtungen II';

  @override
  String get schoolGateAssetDrugFacilitySlotsTier3 =>
      'Aktivposten: Erweiterung des Steckplatzes für Arzneimitteleinrichtungen III';

  @override
  String get schoolGateAssetDrugFacilitySlotsTier4 =>
      'Aktivposten: Upgrade IV für den Arzneimitteleinrichtungsplatz';

  @override
  String get schoolGateAssetDrugFacilityEquipmentTier1 =>
      'Vermögenswert: Modernisierung der Ausrüstung der Arzneimitteleinrichtung I';

  @override
  String get schoolGateAssetDrugFacilityEquipmentTier2 =>
      'Vermögenswert: Modernisierung der Ausrüstung der Arzneimitteleinrichtung II';

  @override
  String get schoolGateAssetDrugFacilityEquipmentTier3 =>
      'Vermögenswert: Modernisierung der Ausrüstung der Arzneimitteleinrichtung III';

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
  String get educationTrackNameNarcotics => 'Betäubungsmitteltechnik';

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
  String get schoolTrackDescriptionNarcotics =>
      'Kontrollierter Anbau, Prozesselektrik und fortschrittliche chemische Produktion.';

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
  String get educationCertHydroponicSpecialist =>
      'Zertifizierung zum Hydroponik-Spezialisten';

  @override
  String get educationCertProcessElectricsSpecialist =>
      'Zertifizierung zum Prozesselektriker';

  @override
  String get educationCertClandestineChemist =>
      'Zertifizierung als Geheimchemiker';

  @override
  String get educationCertNarcoGridArchitect =>
      'Narco Grid Architect-Zertifizierung';

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
      'Gib einen Spielernamen (oder eine ID) ein, um eine Rivalität zu starten.';

  @override
  String get rivalryPlayerIdHint => 'Spielername oder ID';

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
  String get prostitutionBetrayalDefaultMessage =>
      'Verrat! Dein Nachtclub wurde durch ein Informationsleck getroffen.';

  @override
  String get prostitutionLoadError => 'Fehler beim Laden der Daten';

  @override
  String get prostitutionNoDistrictInCountry =>
      'In diesem Land gibt es kein Rotlichtviertel';

  @override
  String get prostitutionMovedToStreet => 'Auf die Straße verlegt';

  @override
  String get prostitutionArrestedCannotAssign =>
      'Diese Prostituierte ist verhaftet und kann nicht zugewiesen werden.';

  @override
  String get prostitutionNoNightclubVenue =>
      'Du hast noch keinen Nachtclub-Standort, um Personal zuzuweisen.';

  @override
  String get prostitutionNightclubVenueName => 'Nachtclub';

  @override
  String prostitutionNightclubVenueNumbered(int id) {
    return 'Nachtclub #$id';
  }

  @override
  String get prostitutionAssignedNightclub => 'Nachtclub zugewiesen';

  @override
  String get prostitutionArrestedCannotWork =>
      'Diese Prostituierte ist verhaftet und kann nicht arbeiten.';

  @override
  String prostitutionShiftRestNeeded(String duration) {
    return 'Noch $duration Pause bis zur nächsten Schicht.';
  }

  @override
  String get prostitutionWorkShiftCompleted => 'Schicht beendet';

  @override
  String get prostitutionNoWorkersToAssign =>
      'Keine verfügbaren Prostituierten zum Arbeiten schicken.';

  @override
  String prostitutionWorkAllSentCount(int count) {
    return '$count Prostituierte zur Arbeit geschickt.';
  }

  @override
  String prostitutionWorkAllPartial(int success, int failed) {
    return '$success zur Arbeit geschickt, $failed fehlgeschlagen.';
  }

  @override
  String get prostitutionRecruitedDefault => 'Angeworben!';

  @override
  String get prostitutionRecruitFailed => 'Anwerbung fehlgeschlagen';

  @override
  String get prostitutionRecruitConnectionError =>
      'Anwerbung fehlgeschlagen wegen eines Verbindungsfehlers';

  @override
  String get prostitutionEventUpdate => 'Event aktualisiert';

  @override
  String get prostitutionBuyPropertyFirst =>
      'Kaufe zuerst ein Haus oder eine Wohnung';

  @override
  String prostitutionWorkAll(int count) {
    return 'Alle arbeiten lassen ($count)';
  }

  @override
  String get prostitutionNoHousingForRecruit =>
      'Kein freier Wohnplatz. Kaufe oder upgrade ein Haus oder eine Wohnung, bevor du weitere Prostituierte anwirbst.';

  @override
  String get prostitutionHousingTitle => 'Unterkunft';

  @override
  String prostitutionHousingRentRule(int days) {
    return 'Jede Prostituierte muss mindestens eine Schicht alle $days Tage arbeiten, um die Miete zu zahlen.';
  }

  @override
  String get prostitutionHousingSlots => 'Plätze';

  @override
  String get prostitutionHousingFree => 'Frei';

  @override
  String get prostitutionHousingHomes => 'Häuser';

  @override
  String get prostitutionHousingAvgUpgrade => 'Ø-Upgrade';

  @override
  String get prostitutionHousingHappinessBonus => 'Glücks-Bonus';

  @override
  String get prostitutionHousingWeeklyRent => 'Wochenmiete';

  @override
  String get prostitutionHousingAtRisk => 'Gefährdet';

  @override
  String get prostitutionHousingSafe => 'Sicher';

  @override
  String prostitutionBetrayalActiveDetail(int grams, int licenses) {
    return 'Verrat ausgelöst: ${grams}g Drogen beschlagnahmt, $licenses Nachtclub-Lizenz(en) entzogen.';
  }

  @override
  String get prostitutionEarningsInsightTitle =>
      'Einnahmen-Überblick (aktive Prostituierte)';

  @override
  String prostitutionEarningsStreetDetail(int count, int euros) {
    return 'Straße: $count • €$euros/Std.';
  }

  @override
  String prostitutionEarningsRldDetail(int count, int euros) {
    return 'RLV: $count • €$euros/Std.';
  }

  @override
  String prostitutionEarningsNightclubDetail(int count, int euros) {
    return 'Nachtclub: $count • €$euros/Std.';
  }

  @override
  String prostitutionEarningsTotalDetail(int euros) {
    return 'Gesamt: €$euros/Std.';
  }

  @override
  String get prostitutionHappinessEcstatic => 'Ekstatisch';

  @override
  String get prostitutionHappinessHappy => 'Glücklich';

  @override
  String get prostitutionHappinessStable => 'Stabil';

  @override
  String get prostitutionHappinessStressed => 'Gestresst';

  @override
  String get prostitutionHappinessMiserable => 'Elend';

  @override
  String get prostitutionHousingExpired => 'Abgelaufen';

  @override
  String prostitutionHousingDaysLeft(int days) {
    return 'noch $days T.';
  }

  @override
  String get prostitutionHousingLessThanOneDay => 'Weniger als 1 Tag';

  @override
  String get prostitutionNightclubShort => 'Nachtclub';

  @override
  String get prostitutionMoveToStreetButton => 'Zur Straße';

  @override
  String get prostitutionMoveToNightclubButton => 'Zum Nachtclub';

  @override
  String prostitutionEuroPerHour(String amount) {
    return '€$amount/Std.';
  }

  @override
  String prostitutionHappinessDetail(String label, int score, String bonus) {
    return 'Glück $label ($score%) • Ertrag $bonus';
  }

  @override
  String prostitutionHousingStatus(String status) {
    return 'Unterkunft: $status';
  }

  @override
  String prostitutionWeeklyRentEuro(int amount) {
    return 'Wochenmiete €$amount';
  }

  @override
  String get prostitutionWork8h => '8 Std. arbeiten';

  @override
  String prostitutionRestFor(String duration) {
    return 'Pause $duration';
  }

  @override
  String prostitutionNextShiftIn(String duration) {
    return 'Nächste Schicht in $duration';
  }

  @override
  String prostitutionTimeHoursMinutes(int hours, int minutes) {
    return '$hours Std. $minutes Min.';
  }

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
  String nightclubErrorLoading(String error) {
    return 'Fehler beim Laden des Nachtclubs: $error';
  }

  @override
  String get nightclubServiceErrorStats =>
      'Nachtclubstatistiken konnten nicht geladen werden';

  @override
  String get nightclubServiceErrorLeaderboard =>
      'Die Bestenliste konnte nicht geladen werden';

  @override
  String get nightclubServiceErrorSeason =>
      'Das Saisonranking konnte nicht geladen werden';

  @override
  String nightclubErrorWithDetail(String detail) {
    return 'Fehler: $detail';
  }

  @override
  String get nightclubResidentDjContractFailed =>
      'Der Vertrag als Resident-DJ scheiterte';

  @override
  String get nightclubScheduleEventFailed =>
      'Ereignis konnte nicht geplant werden';

  @override
  String get nightclubMarketingUpgradeFailed =>
      'Das Marketing-Upgrade ist fehlgeschlagen';

  @override
  String get nightclubUpgradeFailed => 'Das Upgrade ist fehlgeschlagen';

  @override
  String get nightclubIncidentResponseFailed =>
      'Die Reaktion auf den Vorfall ist fehlgeschlagen';

  @override
  String get nightclubRivalActionFailed =>
      'Die rivalisierende Aktion scheiterte';

  @override
  String get nightclubSupplierContractFailed =>
      'Lieferantenvertrag gescheitert';

  @override
  String get nightclubPromoterFailed => 'Der Promoter ist gescheitert';

  @override
  String get nightclubHeatCooldownFailed => 'Hitze-Abklingzeit fehlgeschlagen';

  @override
  String get nightclubSmugglingFailed => 'Der Schmuggel ist gescheitert';

  @override
  String get nightclubCounterIntelFailed =>
      'Die Gegenspionage ist fehlgeschlagen';

  @override
  String get nightclubHospitalityStockFailed =>
      'Die Aktie des Gastgewerbes ist gescheitert';

  @override
  String get nightclubHospitalityPricingFailed =>
      'Die Preisgestaltung im Gastgewerbe ist gescheitert';

  @override
  String nightclubCurrentVisitorsPct(String pct) {
    return 'Aktuelle Besucher: $pct%';
  }

  @override
  String get nightclubCommandDeckTitle => 'Nightclub-Kommandodeck';

  @override
  String get nightclubOpsDeckRevenueToday => 'Umsatz heute';

  @override
  String get nightclubStockValueLabel => 'Lagerwert';

  @override
  String get nightclubCrewOccupancy => 'Besatzungsbelegung';

  @override
  String get nightclubOperationalRisk => 'Betriebsrisiko';

  @override
  String nightclubIncidents24h(String count) {
    return '$count Vorfälle (24h)';
  }

  @override
  String get nightclubActiveCrewShifts => 'Aktive Besatzungsschichten';

  @override
  String get nightclubRecentCrewHistory => 'Aktuelle Besatzungsgeschichte';

  @override
  String get nightclubBadgeVip => 'VIP';

  @override
  String get nightclubBadgeStandard => 'STANDARD';

  @override
  String get nightclubActiveDj => 'Aktiver DJ';

  @override
  String get nightclubActiveDjNone => 'Aktiver DJ: keiner';

  @override
  String nightclubUntilTime(String time) {
    return 'bis $time';
  }

  @override
  String get nightclubActiveSecurity => 'Aktive Sicherheit';

  @override
  String get nightclubActiveSecurityNone => 'Aktive Sicherheit: keine';

  @override
  String get nightclubNoDjsLoaded =>
      'Keine DJs geladen. Aktualisieren Sie den Bildschirm.';

  @override
  String get nightclubNoSecurityLoaded =>
      'Keine Sicherheit geladen. Aktualisieren Sie den Bildschirm.';

  @override
  String get nightclubCrowdBoost => 'Crowd-Boost';

  @override
  String get nightclubCostPerHour => 'Kosten';

  @override
  String get nightclubReputationLabel => 'Ruf';

  @override
  String get nightclubSpecialtyLabel => 'Spezialität';

  @override
  String get nightclubTheftReduction => 'Reduzierung von Diebstahl';

  @override
  String get nightclubShiftCost => 'Schichtkosten';

  @override
  String get nightclubSelectedStock => 'Ausgewählt';

  @override
  String get nightclubAvailableGrams => 'Verfügbar';

  @override
  String get nightclubMaxChip => 'MAX';

  @override
  String get nightclubStoredInNightclub => 'Im Nightclub gelagert';

  @override
  String nightclubCurrentStockGrams(String grams) {
    return 'Aktueller Lagerbestand: ${grams}g';
  }

  @override
  String get nightclubNoStoredDrugs => 'Noch keine eingelagerten Medikamente.';

  @override
  String get nightclubStockZeroSoldOut =>
      'Der aktuelle Lagerbestand beträgt 0g (alles wurde verkauft).';

  @override
  String nightclubQualityWithValue(String value) {
    return 'Qualität: $value';
  }

  @override
  String nightclubGramsStock(String grams) {
    return '${grams}g Vorrat';
  }

  @override
  String get nightclubOperationsLabTitle => 'Operations Lab (11 Systeme)';

  @override
  String get nightclubSectionResidentDjContract => '1) Resident-DJ-Vertrag';

  @override
  String get nightclubContractDiscount => 'Vertragsrabatt';

  @override
  String get nightclubContractDuration => 'Vertragsdauer';

  @override
  String nightclubContractDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '$count day',
    );
    return '$_temp0';
  }

  @override
  String get nightclubStartResidentContract => 'Bewohnervertrag abschließen';

  @override
  String get nightclubSectionEventCalendar =>
      '2) Dynamischer Veranstaltungskalender';

  @override
  String get nightclubRecommendedToday => 'Heute empfohlen';

  @override
  String get nightclubEventTemplate => 'Veranstaltungsvorlage';

  @override
  String get nightclubScheduleEventFiveMin => 'Veranstaltung planen (+5 Min.)';

  @override
  String get nightclubUpcomingEvents => 'Kommende Veranstaltungen';

  @override
  String get nightclubSectionUpgradeTree => '3) Upgrade-Baum';

  @override
  String get nightclubUpgradeSoundRig => 'Tonanlage';

  @override
  String get nightclubUpgradeVipLounge => 'VIP-Lounge';

  @override
  String get nightclubUpgradeSurveillance => 'Überwachung';

  @override
  String nightclubUpgradeWithCost(String name, String cost) {
    return '$name ($cost)';
  }

  @override
  String get nightclubChooseUpgrade => 'Wählen Sie Upgrade';

  @override
  String get nightclubUpgradeAlreadyMaxMessage =>
      'Dieses Upgrade hat bereits die maximale Stufe erreicht.';

  @override
  String get nightclubUpgradeAlreadyMaxed => 'Upgrade bereits ausgeschöpft';

  @override
  String get nightclubUpgradeNow => 'Jetzt upgraden';

  @override
  String get nightclubMarketingInvestment => 'Marketinginvestitionen';

  @override
  String get nightclubInvestMarketing => 'Investieren Sie in Marketing';

  @override
  String get nightclubSectionPoliceHeat => '4) Polizeihitze und Zwischenfälle';

  @override
  String get nightclubHeatLabel => 'Hitze';

  @override
  String get nightclubRaidRisk => 'Überfallrisiko';

  @override
  String get nightclubCooldownLabel => 'Abklingzeit';

  @override
  String get nightclubStartHeatCooldown => 'Wärmeabkühlung starten';

  @override
  String get nightclubBribe => 'Bestechen';

  @override
  String get nightclubLockdown => 'Sperrung';

  @override
  String get nightclubCounterIntelShort => 'Gegenspionage';

  @override
  String get nightclubSectionStaffMorale =>
      '5) Ermüdung und Moral des Personals';

  @override
  String get nightclubMorale => 'Moral';

  @override
  String get nightclubFatigue => 'Ermüdung';

  @override
  String get nightclubStaffing => 'Personalbesetzung';

  @override
  String get nightclubSectionSupplierPromoter =>
      '6) Lieferant und Veranstalter';

  @override
  String get nightclubSupplierContract => 'Lieferantenvertrag';

  @override
  String get nightclubActivateSupplier => 'Lieferant aktivieren';

  @override
  String get nightclubPromoterProfile => 'Promoterprofil';

  @override
  String get nightclubHirePromoter => 'Stellen Sie einen Promoter ein';

  @override
  String get nightclubSectionVipClientele =>
      '7) VIP-Kunden- und Personalmerkmale';

  @override
  String get nightclubVipShare => 'VIP-Anteil';

  @override
  String get nightclubSpendMultiplier => 'Verbringen Sie x';

  @override
  String get nightclubTier => 'Stufe';

  @override
  String get nightclubSectionSmugglingRoutes => '8) Schmuggelrouten';

  @override
  String get nightclubReady => 'Bereit';

  @override
  String get nightclubRoute => 'Route';

  @override
  String get nightclubStartRoute => 'Route starten';

  @override
  String get nightclubLastRoute => 'Letzte Route';

  @override
  String nightclubRouteLockUntil(String date) {
    return 'Streckensperre aktiv bis $date';
  }

  @override
  String get nightclubSectionBarKitchen => '9) Bar- und Küchenmanagement';

  @override
  String get nightclubServiceLevel => 'Serviceniveau';

  @override
  String get nightclubStockStatus => 'Lagerstatus';

  @override
  String get nightclubSpoilageRisk => 'Gefahr des Verderbens';

  @override
  String get nightclubDrinksFoodStock => 'Getränke-/Lebensmittelvorrat';

  @override
  String get nightclubBuyStock => 'Aktien kaufen';

  @override
  String get nightclubMenuPricingMode => 'Menüpreismodus';

  @override
  String get nightclubApplyPricing => 'Preise anwenden';

  @override
  String get nightclubSectionRivals =>
      '10) Rivalisierende Vereine + Gegeninformationen';

  @override
  String get nightclubSearchPlayerName => 'Spielernamen suchen';

  @override
  String get nightclubTargetName => 'Ziel (Name)';

  @override
  String nightclubRivalCrowdLine(String name, String country, String pct) {
    return '$name • $country • Menschenmenge $pct%';
  }

  @override
  String get nightclubSabotage => 'Sabotage';

  @override
  String get nightclubPromoWar => 'Promo-Krieg';

  @override
  String get nightclubCounterIntelSweep => 'Spionageabwehr';

  @override
  String get nightclubMitigation => 'Schadensbegrenzung';

  @override
  String get nightclubSectionTimeline => '11) Zeitplan für den Betrieb';

  @override
  String get nightclubNoTimelineEvents => 'Keine Timeline-Ereignisse.';

  @override
  String get nightclubOperationsAlerts => 'Betriebswarnungen';

  @override
  String get nightclubNoCriticalAlerts => 'Keine kritischen Warnungen.';

  @override
  String get nightclubQuickAction => 'Schnelle Aktion';

  @override
  String get nightclubMgmtCrewTitle => 'Crew & Schichten';

  @override
  String get nightclubMgmtCrewSubtitle =>
      'Personalbesetzung, Leistung und Schichtverlauf.';

  @override
  String get nightclubMgmtDrugsTitle => 'Lagerung von Arzneimitteln';

  @override
  String get nightclubMgmtDrugsSubtitle =>
      'Verwalten und übertragen Sie den Lagerbestand in Gramm.';

  @override
  String get nightclubMgmtDjTitle => 'DJ-Befehl';

  @override
  String get nightclubMgmtDjSubtitle =>
      'Wählen Sie DJ, Schichtlänge und Live-Crowd-Boost.';

  @override
  String get nightclubMgmtSecurityTitle => 'Sicherheitseinheit';

  @override
  String get nightclubMgmtSecuritySubtitle =>
      'Diebstahlreduzierung, Kosten und aktive Sicherheit.';

  @override
  String get nightclubMgmtOpsLabTitle => 'Ops-Labor';

  @override
  String nightclubMgmtOpsLabSubtitleAlert(String alerts, String smuggling) {
    return 'Live-Benachrichtigungen: $alerts | Schmuggel: $smuggling';
  }

  @override
  String get nightclubMgmtOpsLabSubtitleDefault =>
      '11 Systeme für Events, Upgrades, Routen und Rivalen.';

  @override
  String get nightclubManagementPanelTitle => 'Nachtclubmanagement';

  @override
  String get nightclubChooseZoneHint =>
      'Wählen Sie eine Verwaltungszone und steuern Sie alles ohne verschachtelten Inner-Scroll.';

  @override
  String get nightclubChipCrew => 'Crew';

  @override
  String get nightclubChipStorage => 'Lagerung';

  @override
  String get nightclubChipDjShift => 'DJ-Schicht';

  @override
  String get nightclubChipSecurity => 'Sicherheit';

  @override
  String get nightclubChipOpsAlerts => 'Betriebswarnungen';

  @override
  String get nightclubNone => 'Keiner';

  @override
  String get nightclubIntelligenceCardTitle => 'Nightclub-Intelligenz';

  @override
  String get nightclubSeasonStatus => 'Saisonstatus';

  @override
  String nightclubSeasonCountdown(String days, String hours, String minutes) {
    return '${days}d ${hours}h ${minutes}m';
  }

  @override
  String nightclubShiftHours(String hours) {
    return '$hours Uhr';
  }

  @override
  String nightclubTimeMinutes(String minutes) {
    return '$minutes min';
  }

  @override
  String nightclubTimeHoursOnly(String hours) {
    return '${hours}h';
  }

  @override
  String nightclubTimeHoursMinutes(String hours, String minutes) {
    return '${hours}h ${minutes}m';
  }

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

  @override
  String get supportTicketsScreenTitle => 'Support-Tickets';

  @override
  String get supportLoadTicketsFailed =>
      'Das Laden der Tickets ist fehlgeschlagen';

  @override
  String get supportLoadTicketFailed =>
      'Das Laden des Tickets ist fehlgeschlagen';

  @override
  String get supportPickImageFailed => 'Bild konnte nicht ausgewählt werden';

  @override
  String get supportSubjectMessageMinLength =>
      'Geben Sie den Betreff und die Nachricht ein (mindestens 3 Zeichen).';

  @override
  String get supportTicketCreated => 'Ticket erstellt.';

  @override
  String get supportCreateTicketFailed => 'Ticket konnte nicht erstellt werden';

  @override
  String get supportReplySent => 'Antwort gesendet.';

  @override
  String get supportReplySendFailed => 'Antwort konnte nicht gesendet werden';

  @override
  String get supportDeleteTicketTitle => 'Ticket löschen';

  @override
  String get supportDeleteTicketBody =>
      'Sind Sie sicher, dass Sie dieses Ticket löschen möchten? Diese Aktion kann nicht rückgängig gemacht werden.';

  @override
  String get supportTicketDeleted => 'Ticket gelöscht.';

  @override
  String get supportDeleteTicketFailed => 'Ticket konnte nicht gelöscht werden';

  @override
  String get supportUnknownError => 'Unbekannter Fehler';

  @override
  String get supportStatusNew => 'Neu';

  @override
  String get supportStatusTriage => 'Triage';

  @override
  String get supportStatusInProgress => 'Im Gange';

  @override
  String get supportStatusWaitingPlayer => 'Warten auf Spieler';

  @override
  String get supportStatusBlocked => 'Blockiert';

  @override
  String get supportStatusResolved => 'Gelöst';

  @override
  String get supportStatusClosed => 'Geschlossen';

  @override
  String get supportStatusArchived => 'Archiviert';

  @override
  String get supportCategoryBug => 'Insekt';

  @override
  String get supportCategoryQuestion => 'Frage';

  @override
  String get supportCategoryFeedback => 'Rückmeldung';

  @override
  String get supportCategoryOther => 'Andere';

  @override
  String get supportPriorityLow => 'Niedrig';

  @override
  String get supportPriorityHigh => 'Hoch';

  @override
  String get supportPriorityUrgent => 'Dringend';

  @override
  String get supportPriorityNormal => 'Normal';

  @override
  String supportTimeDaysAgo(int count) {
    return 'Vor ${count}d';
  }

  @override
  String supportTimeHoursAgo(int count) {
    return 'Vor ${count}h';
  }

  @override
  String supportTimeMinutesAgo(int count) {
    return 'Vor ${count}m';
  }

  @override
  String get supportTimeJustNow => 'soeben';

  @override
  String get supportSenderSupport => 'Unterstützung';

  @override
  String get supportSenderYou => 'Du';

  @override
  String get supportImageLoadFailed => 'Bild konnte nicht geladen werden.';

  @override
  String get supportMyTickets => 'Meine Tickets';

  @override
  String supportTicketsCountInList(String count) {
    return '$count';
  }

  @override
  String get supportMyTicketsIntro =>
      'Der Support antwortet jetzt direkt in diesem Bildschirm. Sie können optional weiterhin eine Push-Benachrichtigung erhalten, wenn Ihr Ticket aktualisiert wird.';

  @override
  String get supportNoTicketsYet =>
      'Sie haben noch keine Tickets. Erstellen Sie unten einen neuen Bericht.';

  @override
  String get supportSelectTicketPrompt =>
      'Wählen Sie ein Ticket aus, um die Konversation zu öffnen.';

  @override
  String get supportConversation => 'Gespräch';

  @override
  String get supportNoMessagesYet => 'Noch keine Nachrichten.';

  @override
  String get supportAttachments => 'Anhänge';

  @override
  String get supportReplyToTicket => 'Auf dieses Ticket antworten';

  @override
  String get supportReplyFieldHint =>
      'Verwenden Sie dieses Feld, wenn der Support weitere Informationen anfordert oder Sie ein Update bereitstellen möchten. Posteingang und Push bleiben Benachrichtigungskanäle für neue Support-Antworten.';

  @override
  String get supportYourReply => 'Ihre Antwort';

  @override
  String get supportSendReply => 'Antwort senden';

  @override
  String get supportNewTicket => 'Neues Ticket';

  @override
  String get supportNewTicketIntro =>
      'Erstellen Sie hier einen neuen Bericht. Der Support kann dann per Posteingang/Push und auf diesem Bildschirm antworten, sodass Sie das Gespräch an einem Ort fortsetzen können.';

  @override
  String get supportTicketReceivedBanner => 'Ticket erhalten';

  @override
  String supportTicketNumberLine(int id) {
    return 'Ticketnummer: #$id';
  }

  @override
  String get supportTicketReceivedDetail =>
      'Das Ticket erscheint nun direkt in Ihrer Liste oben. Neue Support-Antworten kommen auch als Posteingangsnachrichten und Push-Benachrichtigungen.';

  @override
  String get supportFieldCategory => 'Kategorie';

  @override
  String get supportFieldModule => 'Modul';

  @override
  String get supportFieldSubject => 'Thema';

  @override
  String get supportFieldMessage => 'Nachricht';

  @override
  String get supportReferenceOptional => 'Referenz (optional)';

  @override
  String get supportReferenceHint =>
      'Zum Beispiel Bestell-ID, Bildschirmname, Land oder kurzer Kontext';

  @override
  String get supportAddScreenshot => 'Screenshot hinzufügen';

  @override
  String get supportSubmit => 'Einreichen';

  @override
  String get supportLastMessagePrefix => 'Zuletzt:';

  @override
  String get supportReferenceLabel => 'Referenz';

  @override
  String get supportMod_support => 'Allgemeine Unterstützung';

  @override
  String get supportMod_dashboard => 'Armaturenbrett';

  @override
  String get supportMod_messages => 'Nachrichten / Posteingang';

  @override
  String get supportMod_notifications => 'Benachrichtigungen / Push';

  @override
  String get supportMod_payments => 'Zahlungen / Prämie';

  @override
  String get supportMod_bank => 'Bank';

  @override
  String get supportMod_crypto => 'Krypto';

  @override
  String get supportMod_travel => 'Reisen';

  @override
  String get supportMod_properties => 'Eigenschaften';

  @override
  String get supportMod_inventory => 'Inventar / Lagerung';

  @override
  String get supportMod_loadouts => 'Loadouts/Ausrüstung';

  @override
  String get supportMod_crimes => 'Verbrechen';

  @override
  String get supportMod_jobs => 'Arbeit / Jobs';

  @override
  String get supportMod_vehicles => 'Auto-/Fahrrad-/Bootsdiebstahl';

  @override
  String get supportMod_garage => 'Garage';

  @override
  String get supportMod_marina => 'Yachthafen';

  @override
  String get supportMod_aviation => 'Luftfahrt';

  @override
  String get supportMod_smuggling => 'Schmuggel';

  @override
  String get supportMod_drugs => 'Drogen';

  @override
  String get supportMod_nightclub => 'Nachtclub';

  @override
  String get supportMod_prostitution => 'Prostitution';

  @override
  String get supportMod_crew => 'Crew';

  @override
  String get supportMod_friends => 'Freunde / Spieler';

  @override
  String get supportMod_hitlist => 'Hitliste';

  @override
  String get supportMod_security => 'Sicherheit / FBI';

  @override
  String get supportMod_prison => 'Gefängnis / Gericht';

  @override
  String get supportMod_casino => 'Kasino';

  @override
  String get supportMod_school => 'Schule / Ausbildung';

  @override
  String get supportMod_achievements => 'Erfolge';

  @override
  String get supportMod_profile => 'Profil';

  @override
  String get supportMod_settings => 'Einstellungen';

  @override
  String get supportMod_events => 'Ereignisse / Bestenliste';

  @override
  String get supportMod_other => 'Andere';

  @override
  String get gameEventDefaultTitle => 'Ereignis';

  @override
  String get gameEventStatusActive => 'Aktiv';

  @override
  String get gameEventStatusScheduled => 'Geplant';

  @override
  String get gameEventStatusCompleted => 'Vollendet';

  @override
  String get gameEventStatusDraft => 'Entwurf';

  @override
  String get gameEventTmplWeeklyVehicleTheftHuntTitle =>
      'Wöchentliche Diebstahljagd';

  @override
  String get gameEventTmplWeeklyVehicleTheftHuntDesc =>
      'Stehlen Sie während des Eventfensters so viele Fahrzeuge wie möglich.';

  @override
  String get gameEventTmplSmugglingSurgeTitle => 'Schmuggelwelle';

  @override
  String get gameEventTmplSmugglingSurgeDesc =>
      'Bewegen Sie in dieser Runde die am meisten geschmuggelte Schmuggelware.';

  @override
  String get gameEventTmplLabOutputChallengeTitle =>
      'Lab-Output-Herausforderung';

  @override
  String get gameEventTmplLabOutputChallengeDesc =>
      'Produzieren Sie den größtmöglichen Output, während die Veranstaltung live ist.';

  @override
  String get gameEventTmplStreetCrimeSpreeTitle => 'Straßenkriminalität';

  @override
  String get gameEventTmplStreetCrimeSpreeDesc =>
      'Schließe so viele Verbrechen wie möglich im Live-Fenster ab.';

  @override
  String get gameEventTmplContrabandRushTitle => 'Schmuggel-Rush';

  @override
  String get gameEventTmplContrabandRushDesc =>
      'Verkaufe Schmuggelware mit Gewinn oder hole Schmuggelladungen ab — höchste Punktzahl gewinnt.';

  @override
  String get gameEventTmplMonthlyEmpireShowdownTitle =>
      'Monthly Empire Showdown';

  @override
  String get gameEventTmplMonthlyEmpireShowdownDesc =>
      'All-round monthly challenge: score via crimes, vehicles, drugs, smuggling and trade. Top ranks win rare vehicles, weapons, ammo and parts.';

  @override
  String get gameScreenLoadError => 'Ereignisse konnten nicht geladen werden.';

  @override
  String get gameScreenDetailsLoadError =>
      'Ereignisdetails konnten nicht geladen werden.';

  @override
  String get gameScreenSectionLive => 'Live-Events';

  @override
  String get gameScreenNoActive =>
      'Im Moment gibt es keine aktiven Veranstaltungen.';

  @override
  String get gameScreenSectionUpcoming => 'Kommende Veranstaltungen';

  @override
  String get gameScreenNoUpcoming => 'Es sind keine Veranstaltungen geplant.';

  @override
  String get gameScreenHeroTitle => 'Live events';

  @override
  String get gameScreenHeroSubtitle =>
      'Compete for cash, credits and event chips. Climb the board before the timer hits zero.';

  @override
  String gameScreenActiveCount(String count) {
    return '$count live';
  }

  @override
  String gameScreenUpcomingCount(String count) {
    return '$count upcoming';
  }

  @override
  String get gameScreenCountdownNow => 'now';

  @override
  String gameScreenCountdownDays(String days, String hours, String minutes) {
    return '${days}d $hours:$minutes';
  }

  @override
  String gameCardEndsIn(String time) {
    return 'Ends in $time';
  }

  @override
  String gameCardStartsIn(String time) {
    return 'Starts in $time';
  }

  @override
  String gameCardTopPrize(String prize) {
    return '1st place: $prize';
  }

  @override
  String get gameCardJoinCta => 'Join & view board';

  @override
  String get gameCardViewPrizes => 'View prize pool';

  @override
  String gameScreenStatusPrefix(String value) {
    return 'Status: $value';
  }

  @override
  String gameScreenStartLine(String date) {
    return 'Beginn: $date';
  }

  @override
  String gameScreenEndLine(String date) {
    return 'Ende: $date';
  }

  @override
  String get gameScreenYourProgress => 'Ihr Fortschritt';

  @override
  String gameScreenScore(String value) {
    return 'Punktzahl: $value';
  }

  @override
  String gameScreenRank(String value) {
    return 'Rang: $value';
  }

  @override
  String get gameScreenLeaderboard => 'Bestenliste (Top 10)';

  @override
  String get gameScreenNoLeaderboard => 'Noch keine Bestenlistendaten.';

  @override
  String get gameScreenPrizePool => 'Prize pool';

  @override
  String get gameScreenPrizePoolHint => 'Rewards are paid when the event ends.';

  @override
  String gameScreenPrizeRankSingle(String rank) {
    return 'Place $rank';
  }

  @override
  String gameScreenPrizeRankRange(String min, String max) {
    return 'Places $min–$max';
  }

  @override
  String gameScreenPrizeCredits(String amount) {
    return '$amount credits';
  }

  @override
  String gameScreenPrizeXp(String amount) {
    return '$amount XP';
  }

  @override
  String gameScreenPrizeItemLine(String name, String qty) {
    return '$name ×$qty';
  }

  @override
  String gameScreenPrizeAmmoLine(String type, String qty) {
    return 'Ammo $type ×$qty';
  }

  @override
  String gameScreenPrizeToolLine(String toolId, String qty) {
    return 'Tool: $toolId ×$qty';
  }

  @override
  String gameScreenPrizeWeaponLine(String weaponId, String qty) {
    return 'Weapon: $weaponId ×$qty';
  }

  @override
  String gameScreenPrizeVehicleLine(String vehicleId) {
    return 'Rare vehicle: $vehicleId';
  }

  @override
  String gameScreenPrizeCarParts(String qty) {
    return 'Car parts ×$qty';
  }

  @override
  String gameScreenPrizeMotorcycleParts(String qty) {
    return 'Motorcycle parts ×$qty';
  }

  @override
  String gameScreenPrizeBoatParts(String qty) {
    return 'Boat parts ×$qty';
  }

  @override
  String get gameScreenNoPrizes => 'No prize rules configured for this event.';

  @override
  String get gameCardPrizeHint => 'Prizes for top 10 — tap for details';

  @override
  String get eventItemName_event_chip_gold => 'Event chip (gold)';

  @override
  String get eventItemName_event_chip_silver => 'Event chip (silver)';

  @override
  String get eventItemName_event_chip_bronze => 'Event chip (bronze)';

  @override
  String get eventItemName_event_badge_rival => 'Rival badge (bound)';

  @override
  String get gameScreenUnknownPlayer => 'Unbekannt';

  @override
  String get gameScreenDash => '—';

  @override
  String get gameCardActive => 'Aktiv';

  @override
  String get gameCardScheduled => 'Geplant';

  @override
  String gameCardYourScore(String value) {
    return 'Ihr Punktestand: $value';
  }

  @override
  String gameCardYourRank(String value) {
    return 'Dein Rang: $value';
  }

  @override
  String get gameCardTapDetails => 'Für Details und Bestenliste tippen';

  @override
  String get eventFeedDisconnected => 'Vom Ereignisstrom getrennt';

  @override
  String get eventFeedReconnecting => 'Verbindung wird wieder hergestellt...';

  @override
  String get eventFeedConnectedWaiting => 'Verbunden – Warten auf Ereignisse…';

  @override
  String get eventFeedConnecting => 'Verbindung zum Event-Stream herstellen…';

  @override
  String get evStreamConnectionEstablished => 'Verbunden mit dem Event-Stream';

  @override
  String get evStreamAuthRegistered => 'Konto erfolgreich erstellt.';

  @override
  String get evStreamAuthLogin => 'Willkommen zurück.';

  @override
  String evStreamCrimeSuccess(
    String crimeName,
    String reward,
    String xpGained,
  ) {
    return 'Erfolgreich abgeschlossen $crimeName! +EUR $reward, +$xpGained XP';
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
      other: '$minutes Minuten',
      one: '1 Minute',
    );
    return 'Erfolgreich $crimeName abgeschlossen! +EUR $reward, +$xpGained XP – erwischt! Inhaftiert für $_temp0.';
  }

  @override
  String get evStreamCrimeSeizedVehicle =>
      'Ihr Fahrzeug wurde von der Polizei beschlagnahmt.';

  @override
  String get evStreamCrimeSeizedWeapon =>
      'Ihre Waffe wurde von der Polizei beschlagnahmt.';

  @override
  String evStreamCrimeSuccessCleared(
    String crimeName,
    int count,
    String xpGained,
  ) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Einträge',
      one: '1 Eintrag',
    );
    return 'Erfolgreich $crimeName abgeschlossen! Strafregister gelöscht: $_temp0 entfernt. +$xpGained XP';
  }

  @override
  String evStreamCrimeFailedArrested(String authority, String crimeName) {
    return 'Von $authority während eines $crimeName-Versuchs verhaftet.';
  }

  @override
  String evStreamCrimeFailedJailed(String crimeName, int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes Minuten',
      one: '1 Minute',
    );
    return 'Bei $crimeName erwischt! Inhaftiert für $_temp0.';
  }

  @override
  String evStreamCrimeFailedBase(String crimeName) {
    return '$crimeName konnte nicht abgeschlossen werden';
  }

  @override
  String evStreamChaseDamage(String pct) {
    return 'Ihr Fahrzeug hat während der Verfolgungsjagd $pct % Schaden erlitten.';
  }

  @override
  String evStreamCrimeJailed(String crimeName, int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes Minuten',
      one: '1 Minute',
    );
    return 'Bei $crimeName erwischt! Inhaftiert für $_temp0.';
  }

  @override
  String evStreamJobSuccess(String jobName, String earnings, String xpGained) {
    return 'Abgeschlossene Arbeit als $jobName! +€$earnings, +$xpGained XP';
  }

  @override
  String evStreamActorPrefix(String username, String message) {
    return '$username: $message';
  }

  @override
  String evStreamJobSuccessEdu(String pct) {
    return '(Bildungsbonus +$pct%)';
  }

  @override
  String evStreamJobFailedXp(String jobName, String xpLost) {
    return 'Auftrag konnte nicht abgeschlossen werden, da $jobName. −$xpLost XP';
  }

  @override
  String evStreamJobFailed(String jobName) {
    return 'Auftrag konnte nicht abgeschlossen werden, da $jobName';
  }

  @override
  String get evStreamJobErrorInvalid => 'Ungültiger Job';

  @override
  String get evStreamJobErrorLevel => 'Ihr Rang ist für diesen Job zu niedrig';

  @override
  String evStreamJobErrorCooldown(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes weitere Minuten',
      one: '1 weitere Minute',
    );
    return 'Dieser Job hat Abklingzeit. Warte $_temp0';
  }

  @override
  String evStreamJobErrorGeneric(String reason) {
    return 'Jobfehler: $reason';
  }

  @override
  String evStreamTravelDeparted(String dest, String cost) {
    return 'Flug nach $dest… −€$cost';
  }

  @override
  String evStreamTravelArrived(String country) {
    return 'Angekommen in $country.';
  }

  @override
  String evStreamBankDeposit(String amount) {
    return '$amount € bei der Bank eingezahlt';
  }

  @override
  String evStreamBankWithdraw(String amount) {
    return '$amount€ von der Bank abgehoben';
  }

  @override
  String evStreamCryptoBuy(String quantity, String symbol, String total) {
    return 'Gekauft $quantity $symbol für $total €';
  }

  @override
  String evStreamCryptoSell(
    String quantity,
    String symbol,
    String total,
    String pnl,
  ) {
    return 'Verkauft $quantity $symbol für $total € (GuV $pnl €)';
  }

  @override
  String evStreamCryptoAlert(String symbol, String price, String chg) {
    return '$symbol Alarm: $price € ($chg% 24h)';
  }

  @override
  String evStreamCryptoOrderFilled(
    String order,
    String side,
    String quantity,
    String symbol,
    String price,
  ) {
    return '$order $side gefüllt: $quantity $symbol zu $price €';
  }

  @override
  String evStreamCryptoOrderTriggered(
    String trig,
    String symbol,
    String price,
  ) {
    return '$trig ausgelöst für $symbol bei $price €';
  }

  @override
  String evStreamCryptoRegime(String regime, String move) {
    return 'Marktregime geändert auf $regime ($move% 24h)';
  }

  @override
  String evStreamCryptoNews(String sentiment, String headline) {
    return '$sentiment Nachrichten: $headline';
  }

  @override
  String evStreamCryptoMissionDaily(String title, String reward) {
    return 'Tägliche Mission abgeschlossen: $title (+EUR $reward)';
  }

  @override
  String evStreamCryptoMissionWeekly(String title, String reward) {
    return 'Wöchentliche Mission abgeschlossen: $title (+EUR $reward)';
  }

  @override
  String evStreamCryptoLeaderboard(String rank, String reward) {
    return 'Belohnung für die Krypto-Rangliste: #$rank (+EUR $reward)';
  }

  @override
  String get evStreamRegimeBull => 'bullisch';

  @override
  String get evStreamRegimeBear => 'bärisch';

  @override
  String get evStreamRegimeSideways => 'seitwärts';

  @override
  String get evStreamImpactBull => 'Bullisch';

  @override
  String get evStreamImpactBear => 'Bärisch';

  @override
  String get evStreamImpactNeutral => 'Neutral';

  @override
  String evStreamPropertyBought(String name, String cost) {
    return 'Gekauft $name für ⟦1€⟧';
  }

  @override
  String evStreamPropertyClaimed(String name, String country, String cost) {
    return 'Claimed property $name in $country for €$cost';
  }

  @override
  String evStreamDrugsProductionStarted(String drugName, String minutes) {
    return '$drugName Produktion begonnen – fertig in $minutes Min';
  }

  @override
  String evStreamDrugsProductionCollected(
    String quantity,
    String drugName,
    String quality,
  ) {
    return 'Gesammelt ${quantity}g $drugName ($quality)';
  }

  @override
  String evStreamDrugsProductionReady(
    String quantity,
    String drugName,
    String quality,
  ) {
    return '${quantity}g $drugName ($quality) is ready to collect';
  }

  @override
  String evStreamDrugsWholesaleSold(
    String quantity,
    String drugType,
    String destination,
    String payout,
  ) {
    return '${quantity}g $drugType in $destination verkauft (€$payout)';
  }

  @override
  String evStreamDrugsWholesaleSeized(
    String quantity,
    String drugType,
    String destination,
  ) {
    return '${quantity}g $drugType nach $destination abgefangen';
  }

  @override
  String evStreamVehicleRepairCompleted(
    String vehicleType,
    String vehicleName,
  ) {
    return '$vehicleType $vehicleName repair completed';
  }

  @override
  String evStreamSchoolTrackProgress(String xp, String track) {
    return 'School training: +$xp XP ($track)';
  }

  @override
  String evStreamSchoolLevelUp(String track, String level) {
    return 'School level up: $track → level $level';
  }

  @override
  String evStreamSchoolCertification(String cert, String track) {
    return 'School certificate earned: $cert ($track)';
  }

  @override
  String evStreamCrewCreated(String name) {
    return 'Erstellte Crew: $name';
  }

  @override
  String evStreamCrewJoined(String name) {
    return 'Beigetretene Crew: $name';
  }

  @override
  String evStreamCrewWarDeclared(String a, String b, String type) {
    return 'Besatzungskrieg erklärt: #$a gegen #$b ($type)';
  }

  @override
  String evStreamCrewWarStarted(String a, String b) {
    return 'Der Besatzungskrieg hat begonnen: #$a gegen #$b';
  }

  @override
  String evStreamCrewLockdown(String id) {
    return 'Crew War #$id ist gesperrt';
  }

  @override
  String evStreamCrewResolved(String id, String winner) {
    return 'Besatzungskrieg #$id gelöst. Gewinner: Crew #$winner';
  }

  @override
  String evStreamCrewAction(String action, String points) {
    return 'Kriegsaktion der Crew: $action (+$points Pkt)';
  }

  @override
  String evStreamHeistOk(String name, String money) {
    return 'Raubüberfall „$name“ erfolgreich! +€$money';
  }

  @override
  String evStreamHeistFail(String name) {
    return 'Der Raubüberfall „$name“ ist fehlgeschlagen.';
  }

  @override
  String evStreamHospital(String hp, String cost) {
    return 'Im Krankenhaus behandelt! +$hp Gesundheit, −€$cost';
  }

  @override
  String evStreamPoliceArrested(String mins) {
    return 'Verhaftet! $mins Minuten im Gefängnis';
  }

  @override
  String get evStreamPoliceEscaped => 'Du bist der Polizei entkommen.';

  @override
  String get evStreamFbiRaid =>
      'FBI-Razzia! Sie haben Eigentum und Geld verloren.';

  @override
  String get evStreamErrInsufficientFunds => 'Nicht genug Geld';

  @override
  String get evStreamErrInsufficientHealth =>
      'Nicht genügend Gesundheit für diese Aktion';

  @override
  String evStreamErrInsufficientRank(String rank) {
    return 'Erfordert Rang $rank';
  }

  @override
  String evStreamErrJailed(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes Minuten',
      one: '1 Minute',
    );
    return 'Du bist noch $_temp0 im Gefängnis';
  }

  @override
  String get evStreamErrNoHealthDefault =>
      'Sie müssen sich ausruhen und Ihre Gesundheit wiederherstellen';

  @override
  String evStreamErrCooldown(int seconds) {
    String _temp0 = intl.Intl.pluralLogic(
      seconds,
      locale: localeName,
      other: '$seconds Sekunden',
      one: '1 Sekunde',
    );
    return 'Warte $_temp0, bevor du es erneut versuchst';
  }

  @override
  String get evStreamErrRescuerJailed =>
      'Während Sie im Gefängnis sind, können Sie anderen nicht helfen';

  @override
  String get evStreamErrTargetNotJailed =>
      'Dieser Spieler ist nicht im Gefängnis';

  @override
  String get evStreamErrCannotRescueSelf =>
      'Du kannst dich nicht selbst befreien';

  @override
  String get evStreamJailbreakOk =>
      'Jailbreak erfolgreich! Der Spieler ist kostenlos.';

  @override
  String get evStreamJailbreakFail =>
      'Jailbreak fehlgeschlagen! Der Spieler sitzt immer noch im Gefängnis.';

  @override
  String evStreamJailbreakCaught(String mins) {
    return 'Jailbreak fehlgeschlagen! Sie wurden gefasst und für $mins Minuten eingesperrt.';
  }

  @override
  String evStreamBailPaid(String amount) {
    return 'Kaution bezahlt: $amount €. Du bist frei.';
  }

  @override
  String get evStreamErrInternal =>
      'Etwas ist schief gelaufen. Bitte versuchen Sie es erneut.';

  @override
  String evStreamTest(String msg) {
    return 'Test: $msg';
  }

  @override
  String get evStreamNoCriminalRecord =>
      'Sie haben kein Vorstrafenregister, das gelöscht werden muss';

  @override
  String get evStreamWeaponSelectRequired =>
      'Wählen Sie eine Verbrechenswaffe aus, bevor Sie dieses Verbrechen begehen';

  @override
  String evStreamWeaponNotSuitable(String types) {
    return 'Du brauchst eine passende Waffe: $types';
  }

  @override
  String get evStreamJobFallbackName => 'Arbeit';

  @override
  String evStreamUnknownKey(String key) {
    return '$key';
  }

  @override
  String get connectionErrorGeneric => 'Verbindungsfehler';

  @override
  String get crimeWeaponSectionTitle => 'Verbrechenswaffe';

  @override
  String get crimeWeaponInstruction =>
      'Wählen Sie aus, welche Waffe Sie standardmäßig bei Straftaten verwenden, für die eine solche Waffe erforderlich ist.';

  @override
  String get crimeWeaponEmptyInventoryHelp =>
      'Kaufen Sie zuerst eine verwendbare Waffe oder verschieben Sie sie in Ihr getragenes Inventar.';

  @override
  String get crimeWeaponSelectHint => 'Wählen Sie eine Waffe für Verbrechen';

  @override
  String get crimeWeaponNoSelectionNote =>
      'Ohne eine Selektion werden waffenbasierte Verbrechen nicht beginnen.';

  @override
  String get crimeWeaponSlotEmpty => 'leer';

  @override
  String crimeWeaponEquippedStatus(String slotOne, String slotTwo) {
    return 'Slot 1: $slotOne. Slot 2: $slotTwo.';
  }

  @override
  String crimeWeaponSelectedStatus(String weaponLine) {
    return 'Ausgewählt: $weaponLine. Für einige Verbrechen ist darüber hinaus noch ein passender Waffentyp erforderlich.';
  }

  @override
  String get crimeSetWeaponFailed =>
      'Tatwaffe konnte nicht eingestellt werden.';

  @override
  String get crimeChooseWeaponBeforeCommit =>
      'Wählen Sie oben auf diesem Bildschirm oder über das Inventar zunächst eine Kriminalwaffe aus.';

  @override
  String get crimeWeaponFooterNote =>
      'Bei waffenbasierten Straftaten wird die oben ausgewählte Straftatwaffe verwendet.';

  @override
  String crimeTrainingBonusStrip(String strengthPct, String accuracyPct) {
    return 'Trainingsboni auf Erfolgschance: +$strengthPct % Stärke, +$accuracyPct % Genauigkeit.';
  }

  @override
  String crimeTrainingComboStrip(String pct) {
    return 'Combo am selben Tag (Fitnessstudio + Schießstand, UTC-Kalender): +$pct% zusätzliche Erfolgschance bei Verbrechen.';
  }

  @override
  String get crimeTrainingOpenHub => 'Tap to open training hub';

  @override
  String get crimeScreenHeroTitle => 'Street crimes';

  @override
  String get crimeScreenHeroSubtitle =>
      'Pick your next score. Training bonuses and your weapon loadout apply to every attempt.';

  @override
  String get crimeScreenPrepTitle => 'Prep before you hit';

  @override
  String get crimeScreenFilterAll => 'All crimes';

  @override
  String get crimeScreenFilterAvailable => 'Available only';

  @override
  String get crimeScreenSortLabel => 'Sort';

  @override
  String get crimeScreenSortReward => 'Top reward';

  @override
  String get crimeScreenSortRank => 'Rank required';

  @override
  String get crimeScreenSortSuccess => 'Success chance';

  @override
  String crimeScreenLiveEventActive(String title) {
    return 'Live event: $title';
  }

  @override
  String crimeScreenLiveEventProgress(
    String score,
    String rank,
    String timeLeft,
  ) {
    return 'Score $score · Rank $rank · $timeLeft';
  }

  @override
  String get crimeScreenOpenEvents => 'Tap for event details';

  @override
  String get crimeScreenTrainingNudge =>
      'No training bonus yet — hit the gym and range for extra success chance.';

  @override
  String crimeCardRankRequired(int rank) {
    return 'Rank $rank+';
  }

  @override
  String crimeCardToolBannerNeeded(String tools) {
    return '$tools required';
  }

  @override
  String crimeCardToolBannerReady(String tools) {
    return '$tools ready';
  }

  @override
  String crimeCardToolBannerStorage(String tools) {
    return '$tools in storage';
  }

  @override
  String get crimeCardBlockerVehicle => 'Vehicle required';

  @override
  String get crimeCardBlockerDrugs => 'Drugs required';

  @override
  String get crimeCardBlockerWeapon => 'Weapon required';

  @override
  String get crimeCardBlockerAmmo => 'Ammo required';

  @override
  String get crimeCardBlockerCriminalRecord => 'No record';

  @override
  String get crimeCardWeaponBannerNeeded => 'Crime weapon required';

  @override
  String crimeCardWeaponBannerReady(String weapon) {
    return '$weapon selected';
  }

  @override
  String get crimeCardWeaponBannerAmmo => 'Ammo required';

  @override
  String get crimeCardTierLow => 'Petty';

  @override
  String get crimeCardTierMid => 'Serious';

  @override
  String get crimeCardTierHigh => 'Major';

  @override
  String get crimeScreenNoMatches => 'No crimes match this filter.';

  @override
  String get jobScreenHeroTitle => 'Honest work';

  @override
  String get jobScreenHeroSubtitle =>
      'Steady cash and XP without the heat. School certificates unlock higher-paying positions.';

  @override
  String get jobScreenPrepTitle => 'Career path';

  @override
  String jobScreenEducationStrip(int count) {
    return '$count jobs locked — complete school certificates to unlock them.';
  }

  @override
  String get jobScreenEducationNudge =>
      'Higher education opens better jobs with bigger payouts and longer cooldowns.';

  @override
  String get jobScreenOpenSchool => 'Tap to open school';

  @override
  String get jobScreenFilterAll => 'All jobs';

  @override
  String get jobScreenFilterAvailable => 'Available only';

  @override
  String get jobScreenSortLabel => 'Sort';

  @override
  String get jobScreenSortReward => 'Top pay';

  @override
  String get jobScreenSortRank => 'Rank required';

  @override
  String get jobScreenSortSuccess => 'Success chance';

  @override
  String get jobScreenNoMatches => 'No jobs match this filter.';

  @override
  String get jobCardTierLow => 'Entry';

  @override
  String get jobCardTierMid => 'Skilled';

  @override
  String get jobCardTierHigh => 'Executive';

  @override
  String get jobCardEducationRequired => 'School req.';

  @override
  String jobCardSuccessChance(int percent) {
    return '$percent% success chance';
  }

  @override
  String jobCardEducationPayBonus(int percent) {
    return '+$percent% school pay bonus';
  }

  @override
  String get jobOutcomeFailed => 'Shift didn\'t pay off';

  @override
  String get jobResultXpLostLabel => 'XP lost';

  @override
  String get jobScreenRepeatPenaltyHint =>
      'Repeating the same job back-to-back lowers your success chance. Rotate work or train at school for better odds on pro jobs.';

  @override
  String get jobFlavorRegularShift =>
      'Solid shift — nothing flashy, but the paycheck cleared.';

  @override
  String get jobFlavorOvertimeShift =>
      'Overtime approved — extra hours on the clock.';

  @override
  String get jobFlavorCashTip => 'Cash tip landed under the table.';

  @override
  String get jobFlavorBigClient => 'A big client kept you busy all shift.';

  @override
  String get jobFlavorUnderCounterTip =>
      'Someone slid a tip under the counter.';

  @override
  String get jobFlavorTaxiNightFare =>
      'Late-night fare paid double — no questions asked.';

  @override
  String get jobFlavorSecuritySideGig =>
      'Off-the-books security gig on the side.';

  @override
  String get jobFlavorWarehouseFind =>
      'Found unclaimed goods in the warehouse.';

  @override
  String get jobFlavorIntelPickup =>
      'You picked up useful street chatter on the job.';

  @override
  String get jobFlavorClientStiffed =>
      'Client stiffed you — no pay this round.';

  @override
  String get jobFlavorBossCaughtSlacking =>
      'Boss caught you slacking — shift ended early.';

  @override
  String get jobFlavorRegisterShort =>
      'Register came up short — you took the blame.';

  @override
  String get jobFlavorEquipmentFailure => 'Equipment failure killed the shift.';

  @override
  String get jobFlavorShiftCutShort => 'Shift cut short with no payout.';

  @override
  String get jobResultFlavorLabel => 'What happened';

  @override
  String get jobResultIntelInbox => 'Street intel sent to your inbox.';

  @override
  String jobResultTipBonus(String amount) {
    return '+€$amount tip bonus';
  }

  @override
  String get jobCardIntelChance => 'Street intel';

  @override
  String get crimeCriminalRecordWipeDesc =>
      'Fälschen Sie Gerichtsakten und löschen Sie Ihr gesamtes Strafregister, wenn die Operation erfolgreich ist.';

  @override
  String crimeCardSuccessChance(int percent) {
    return '$percent% Erfolgschance';
  }

  @override
  String crimeRequirementDrugsFull(
    String drugsRequired,
    String quantity,
    String names,
  ) {
    return '💊 $drugsRequired (min. ${quantity}g): $names';
  }

  @override
  String get crimeCommitUnexpectedError =>
      'Etwas ist schief gelaufen. Bitte versuchen Sie es erneut.';

  @override
  String get cooldownTimeLeft => 'Übrige Zeit';

  @override
  String get cooldownMustWaitExplanation =>
      'Sie müssen warten, bevor Sie diese Aktion erneut ausführen können.';

  @override
  String get cooldownAlreadyFinished => 'Abklingzeit bereits beendet.';

  @override
  String get cooldownNotEnoughCredits => 'Nicht genügend Credits.';

  @override
  String get cooldownNoActiveToReset =>
      'Keine aktive Abklingzeit zum Zurücksetzen.';

  @override
  String get cooldownNotAvailableNow => 'Momentan nicht verfügbar.';

  @override
  String get cooldownRedeemFailed =>
      'Die Beschleunigung mit Credits ist fehlgeschlagen.';

  @override
  String get cooldownFinishedInstantly => 'Die Abklingzeit ist sofort beendet.';

  @override
  String cooldownSpeedUpNow(int cost) {
    return 'Beschleunigen Sie jetzt (-$cost Credits)';
  }

  @override
  String cooldownCreditBalanceLine(int balance) {
    return 'Guthaben: $balance Credits';
  }

  @override
  String get cooldownLoadingCreditOptions => 'Kreditoptionen werden geladen…';

  @override
  String get cooldownWaitCrime => 'Die Hitze ist zu hoch...';

  @override
  String get cooldownWaitJob =>
      'Machen Sie eine Pause, bevor Sie wieder arbeiten können';

  @override
  String get cooldownWaitTravel => 'Der nächste Flug startet in';

  @override
  String get cooldownWaitHeist => 'Den Raubüberfall planen …';

  @override
  String get cooldownWaitAppeal => 'Das Gericht ist beschäftigt...';

  @override
  String get cooldownWaitSchool =>
      'Atmen Sie vor der nächsten Unterrichtsstunde durch...';

  @override
  String get cooldownWaitDefault => 'Bitte warten…';

  @override
  String get weaponLabelKnife => 'Messer';

  @override
  String get weaponLabelHandgun9mm => 'Pistole (9mm)';

  @override
  String get weaponLabelHandgunHeavy => 'Schwere Pistole (.45)';

  @override
  String get weaponLabelSmgCompact => 'Kompakte Maschinenpistole';

  @override
  String get weaponLabelShotgunPump => 'Schrotflinte (Pumpe)';

  @override
  String get weaponLabelMolotov => 'Molotowcocktail';

  @override
  String get weaponLabelSmgSuppressed => 'Unterdrückte Maschinenpistole';

  @override
  String get weaponLabelShotgunTactical => 'Taktische Schrotflinte';

  @override
  String get weaponLabelAssaultRifle => 'Sturmgewehr (AK-47)';

  @override
  String get weaponLabelGrenadeFlash => 'Blitzgranate';

  @override
  String get weaponLabelGrenadeFrag => 'Splittergranate';

  @override
  String get weaponLabelSniperStandard => 'Scharfschützengewehr';

  @override
  String get weaponLabelAssaultRifleVip => 'Elite-Sturmgewehr';

  @override
  String get weaponLabelSniperVip => 'Elite-Scharfschützengewehr';

  @override
  String get cooldownTitleCrime => 'Abklingzeit für Kriminalität';

  @override
  String get cooldownTitleJob => 'Abklingzeit des Jobs';

  @override
  String get cooldownTitleTravel => 'Reise-Abklingzeit';

  @override
  String get cooldownTitleHeist => 'Abklingzeit des Raubüberfalls';

  @override
  String get cooldownTitleAppeal => 'Abklingzeit des Einspruchs';

  @override
  String get cooldownTitleSchool => 'Abklingzeit in der Schule';

  @override
  String get cooldownTitleGeneric => 'Abklingzeit';

  @override
  String get crimeOutcomeDefaultTitle => 'Kriminalitätsergebnis';

  @override
  String get territoryContestStatusPreparing => 'Vorbereitung';

  @override
  String get territoryContestStatusActive => 'Aktiv';

  @override
  String get territoryContestStatusLockdown => 'Sperrung';

  @override
  String get territoryContestStatusResolved => 'Gelöst';

  @override
  String get territoryContestStatusCancelled => 'Abgesagt';

  @override
  String get territoryContestHintPreparing =>
      'Dieser Wettbewerb ist derzeit in Vorbereitung. Sobald die Vorbereitungszeit abgelaufen ist, wird die Region automatisch aktiv und Aktionen werden freigeschaltet.';

  @override
  String get territoryContestHintLockdown =>
      'Dieser Wettbewerb ist gesperrt. Derzeit können keine neuen Maßnahmen ergriffen werden; Das Ergebnis wird automatisch aufgelöst.';

  @override
  String get territoryNow => 'Jetzt';

  @override
  String get territoryRoleAttacker => 'Angreiferin';

  @override
  String get territoryRoleDefender => 'Verteidigerin';

  @override
  String get territoryValueLow => 'Niedrig';

  @override
  String get territoryValueAverage => 'Durchschnitt';

  @override
  String get territoryValueHigh => 'Hoch';

  @override
  String get territoryValueTop => 'Spitze';

  @override
  String get territoryTagCapital => 'Verwaltungszentrum';

  @override
  String get territoryTagHarbor => 'Hafen';

  @override
  String get territoryTagIndustry => 'Industrie';

  @override
  String get territoryTagBorder => 'Grenzregion';

  @override
  String get territoryTagLogistics => 'Logistikdrehscheibe';

  @override
  String get territoryActionPatrol => 'Patrouillieren';

  @override
  String get territoryActionIntelScan => 'Intel-Scan';

  @override
  String get territoryActionSabotage => 'Sabotage';

  @override
  String get territoryActionSupplyRun => 'Versorgungslauf';

  @override
  String get territoryActionRaid => 'Überfall';

  @override
  String get territoryActionDefense => 'Verteidigung';

  @override
  String get territoryBonusStrategicRegion => 'Strategische Region';

  @override
  String get territoryBonusAdjacentSupport => 'Angrenzende Unterstützung';

  @override
  String get territoryBonusWarPressure => 'Kriegsdruck';

  @override
  String get territoryBonusHqLevel => 'HQ-Ebene';

  @override
  String get territoryBonusCrewMissionLevel => 'Level der Besatzungsmission';

  @override
  String get territoryBonusCrewBuildings => 'Mannschaftsnebengebäude';

  @override
  String get territoryBonusOther => 'Andere';

  @override
  String territoryPointsLogicLine(
    int basePoints,
    int bonusPoints,
    int totalPoints,
  ) {
    return 'Basis $basePoints + Bonus $bonusPoints = $totalPoints Wettbewerbspunkte';
  }

  @override
  String get territoryErrorNotInCrew =>
      'Sie müssen sich einer Crew anschließen, bevor Sie Territorium angreifen können.';

  @override
  String get territoryErrorContestAlreadyActive =>
      'Für diese Region läuft bereits ein Wettbewerb. Aktualisieren der Karte auf den neuesten Stand.';

  @override
  String get territoryErrorCrewContestLimit =>
      'Ihre Crew hat bereits das Limit für gleichzeitige Wettbewerbe erreicht.';

  @override
  String get territoryErrorRegionsCap =>
      'Ihre Crew besitzt bereits die maximale Anzahl an Regionen.';

  @override
  String get territoryErrorContestNotActive =>
      'Dieser Wettbewerb ist noch nicht aktiv. Warten Sie, bis die Vorbereitungsphase abgeschlossen ist.';

  @override
  String get territoryErrorActionCooldown =>
      'Sie müssen warten, bevor Sie eine weitere Gebietsaktion durchführen.';

  @override
  String get territoryErrorActionRoleMismatch =>
      'Diese Aktion gehört zur anderen Seite des Wettbewerbs.';

  @override
  String get territoryErrorHqLevelRequired =>
      'Ihr HQ-Level ist für diese Gebietsaktion zu niedrig.';

  @override
  String get territoryErrorDailyCap =>
      'Sie haben Ihr Tageslimit für Gebietsaktionen erreicht.';

  @override
  String get territoryErrorWrongCountry =>
      'Sie können jedes Land anzeigen, Gebietsaktionen funktionieren jedoch nur in dem Land, in dem Sie sich gerade befinden.';

  @override
  String get territoryErrorUnknown => 'Fehler wegen unbekanntem Gebiet.';

  @override
  String get territoryLegendUnderContest => 'Im Wettbewerb';

  @override
  String get territoryLegendNeutral => 'Neutral';

  @override
  String get territoryTabMap => 'Karte';

  @override
  String get territoryTabLeaderboard => 'Bestenliste';

  @override
  String get territoryTabSeason => 'Jahreszeit';

  @override
  String get territorySelectCountryTooltip => 'Land auswählen';

  @override
  String get territoryUnavailableMessage =>
      'Das Gebiet ist derzeit nicht verfügbar.';

  @override
  String get territoryMapHintTapMain =>
      'Tippen Sie auf eine Region auf der Karte, um Gebietsinformationen und die Angriffsschaltfläche in einem Modal zu öffnen.';

  @override
  String get territoryMapHintTapPanel =>
      'Tippen Sie auf eine Region, um das Modal mit Gebietsinformationen und Angriffsaktionen direkt zu öffnen.';

  @override
  String get territoryMapHintMobile =>
      'Auf Mobilgeräten können Sie mit zwei Fingern hinein- und herausziehen und die gezoomte Karte direkt für kleinere Regionen ziehen.';

  @override
  String get territoryMapHintColors =>
      'Die Farben der Region zeigen den Besitz an; Orange = aktiver Wettbewerb.';

  @override
  String territoryMapOverviewTitle(String country) {
    return '$country Karte (Besatzungskontrolle)';
  }

  @override
  String get territoryLegendTitle => 'Legende';

  @override
  String territoryYourCrewLine(String name) {
    return 'Ihre Crew: $name';
  }

  @override
  String get territoryDetailRegionPreviewTitle => 'Regionsvorschau';

  @override
  String get territoryDetailRegionPreviewSubtitle =>
      'Nur die ausgewählte Region, ohne den Rest der Karte.';

  @override
  String get territoryNeutralTerritory => 'Neutrales Territorium';

  @override
  String get territoryDetailOwner => 'Eigentümer';

  @override
  String get territoryDetailNeutral => 'Neutral';

  @override
  String get territoryDetailStability => 'Stabilität';

  @override
  String get territoryDetailEffectiveStability => 'Effektive Stabilität';

  @override
  String get territoryDetailControl => 'Kontrolle';

  @override
  String get territoryDetailValueTier => 'Wertstufe';

  @override
  String get territoryDetailPayout => 'Auszahlung';

  @override
  String get territoryDetailStrategicRole => 'Strategische Rolle';

  @override
  String get territoryDetailAdjacentOwned => 'Angrenzende Eigentumsregionen';

  @override
  String get territoryDetailActionBonuses => 'Aktionsboni';

  @override
  String get territoryDetailBonusInfo => 'Bonusinfo';

  @override
  String get territoryDetailBonusInfoBody =>
      'Diese Boni erhöhen nur Ihre Wettbewerbspunkte pro Aktion. Die Auszahlung der Region € bleibt gleich.';

  @override
  String get territoryDetailWarPressure => 'Kriegsdruck';

  @override
  String get territoryDetailAttackPressure => 'Angriffsdruck';

  @override
  String get territoryDetailStabilityWord => 'Stabilität';

  @override
  String get territoryWarRoleTheater => 'Theaterregion';

  @override
  String get territoryWarRoleAdjacent => 'angrenzende Region';

  @override
  String get territoryWarRoleTarget => 'Zielregion';

  @override
  String get territoryWarPressureEndsIn => 'Der Kriegsdruck endet in';

  @override
  String get territoryDetailIncomeHour => 'Einkommen pro Stunde';

  @override
  String get territoryDetailIncomeDay => 'Einkommen pro Tag';

  @override
  String get territoryDetailYourCrew => 'Ihre Crew';

  @override
  String get territoryDetailContestStatus => 'Wettbewerbsstatus';

  @override
  String get territoryDetailYourRole => 'Deine Rolle';

  @override
  String get territoryDetailYourHqLevel => 'Ihr HQ-Level';

  @override
  String get territoryDetailActionsUnlockIn => 'Aktionen werden freigeschaltet';

  @override
  String get territoryDetailActionsCloseIn => 'Die Aktionen stehen vor der Tür';

  @override
  String get territoryDetailContestEndsIn => 'Der Wettbewerb endet in';

  @override
  String get territoryDetailCooldownPerAction => 'Abklingzeit pro Aktion';

  @override
  String get territoryDetailYourCooldown => 'Deine Abklingzeit';

  @override
  String get territoryNoticeCrewOnly =>
      'Territory ist nur für Besatzungsmitglieder spielbar. Erstellen Sie zunächst eine Crew oder treten Sie einer bei, dann können Sie neutrale Regionen angreifen.';

  @override
  String territoryNoticeWrongCountry(
    String viewingCountry,
    String playerCountry,
  ) {
    return 'Sie sehen $viewingCountry, aber Sie befinden sich derzeit in $playerCountry. Sie können diese Karte durchsuchen, Angriffe und Wettbewerbsaktionen werden jedoch erst freigeschaltet, nachdem Sie in dieses Land gereist sind.';
  }

  @override
  String get territoryNoticeOwnRegion =>
      'Ihre Crew kontrolliert diese Region bereits.';

  @override
  String get territoryNoticeDefenderPrep =>
      'Ihre Crew verteidigt diese Region. Sobald die aktive Phase beginnt, werden Ihnen nur noch defensive Aktionen angezeigt.';

  @override
  String get territoryConfirmDefense => 'Verteidigung bestätigen';

  @override
  String get territoryAttack => 'Angriff';

  @override
  String get territoryAttackerActions => 'Aktionen des Angreifers';

  @override
  String get territoryDefenderActions => 'Aktionen des Verteidigers';

  @override
  String get territoryContestActions => 'Wettbewerbsaktionen';

  @override
  String get territoryIntelShort => 'Intel-Scan';

  @override
  String get territoryRequiresHqShort => 'erfordert HQ';

  @override
  String territoryHqLockedNotice(String actions) {
    return 'Höhere HQ-Stufe erforderlich für: $actions.';
  }

  @override
  String get territoryNotInContestNotice =>
      'Sie nehmen nicht an diesem Wettbewerb teil und können daher hier keine Aktionen durchführen.';

  @override
  String territoryContestOtherCountryNotice(String country) {
    return 'Dieser Wettbewerb findet in einem anderen Land statt. Du kannst ihm folgen, aber erst beitreten, wenn du dich physisch in $country befindest.';
  }

  @override
  String get territoryLeaderboardEmpty => 'Noch kein Territorium kontrolliert.';

  @override
  String territoryLeaderboardRegionsCount(int count) {
    return '$count Regionen';
  }

  @override
  String get territorySeasonNone => 'Keine aktive Saison gefunden.';

  @override
  String get territorySeasonCurrent => 'Aktuelle Saison';

  @override
  String get territorySeasonKey => 'Schlüssel';

  @override
  String get territorySeasonStatus => 'Status';

  @override
  String get territorySeasonStart => 'Start';

  @override
  String get territorySeasonEnd => 'Ende';

  @override
  String get territoryDialogAttackTitle => 'Angriff?';

  @override
  String territoryDialogAttackBody(String regionKey) {
    return 'Einen Wettbewerb für $regionKey starten?';
  }

  @override
  String get territorySnackJoinCrewFirst =>
      'Schließen Sie sich zunächst einer Crew an, um das Territorium anzugreifen.';

  @override
  String territorySnackContestStarted(String status) {
    return 'Der Wettbewerb hat begonnen. Status: $status. Warten Sie, bis die Vorbereitungsphase abgeschlossen ist, bevor Sie Maßnahmen ergreifen.';
  }

  @override
  String territorySnackContestAlreadyLive(String status) {
    return 'Der Wettbewerb hat bereits begonnen und die Karte wurde aktualisiert. Status: $status.';
  }

  @override
  String territoryPointsDelta(String points) {
    return '+$points Punkte!';
  }

  @override
  String get territorySnackDefenseConfirmed =>
      'Verteidigung bestätigt. Sobald die aktive Phase beginnt, können Sie Verteidigungsaktionen durchführen.';

  @override
  String get territorySnackContestRefreshed =>
      'Der Wettbewerbsstatus wurde aktualisiert. Sie können nun sofort die aktuelle Verteidigungsphase sehen.';

  @override
  String territoryHqTooltipLocked(int required, int current) {
    return 'Erfordert HQ-Level $required. Aktuelle HQ-Stufe: $current.';
  }

  @override
  String territoryHqButtonLocked(String label, int level) {
    return '$label (erfordert HQ $level)';
  }

  @override
  String get smugglingHubTitle => 'Schmuggelzentrum';

  @override
  String get smugglingHubSubtitle =>
      'Ein System für Drogen, Handelsgüter, Fahrzeuge, Waffen und Munition. Leer reisen und sicher im Depot abholen.';

  @override
  String get smugglingClaimPersonal => 'Anspruch persönlich';

  @override
  String get smugglingClaimCrew => 'Crew beanspruchen';

  @override
  String get smugglingNewShipment => 'Neue Lieferung';

  @override
  String get smugglingCategoryDrug => 'Drogen';

  @override
  String get smugglingCategoryTrade => 'Handelswaren';

  @override
  String get smugglingCategoryVehicle => 'Fahrzeuge';

  @override
  String get smugglingCategoryWeapon => 'Waffen';

  @override
  String get smugglingCategoryAmmo => 'Munition';

  @override
  String get smugglingNoItemsInCategory =>
      'In dieser Kategorie sind keine Artikel verfügbar.';

  @override
  String get smugglingFieldItem => 'Artikel';

  @override
  String get smugglingFieldDestination => 'Ziel';

  @override
  String get smugglingTransport => 'Transport';

  @override
  String get smugglingCommercialChannel => 'Kommerzieller Kanal';

  @override
  String get smugglingOwnedVehicleAircraft => 'Eigenes Fahrzeug/Flugzeug';

  @override
  String get smugglingNoOwnedTransportInCountry =>
      'Sie verfügen in diesem Land nicht über ein eigenes Fahrzeug oder Flugzeug zum Schmuggel.';

  @override
  String get smugglingOwnedTransportFieldLabel => 'Eigener Transport';

  @override
  String smugglingOwnedTransportCapacityLine(int slots, String percent) {
    return 'Kapazität: $slots Slots • Beschlagnahmung bei Misserfolg: $percent %';
  }

  @override
  String smugglingOwnedTransportDropdownRow(
    String label,
    int slots,
    String riskReduction,
  ) {
    return '$label • $slots Slots • -$riskReduction%';
  }

  @override
  String get smugglingNetwork => 'Netzwerk';

  @override
  String get smugglingPersonal => 'Persönlich';

  @override
  String get smugglingCrew => 'Crew';

  @override
  String get smugglingChannelField => 'Schmuggelkanal';

  @override
  String get smugglingQuantity => 'Menge';

  @override
  String get smugglingVehiclesOneByOne =>
      'Die Fahrzeuge werden einzeln versendet';

  @override
  String smugglingMaxQuantity(int max) {
    return 'Maximal: $max';
  }

  @override
  String get smugglingStartSmuggling => 'Fangen Sie an zu schmuggeln';

  @override
  String get smugglingSelectItemDestination =>
      'Wählen Sie Artikel und Ziel aus';

  @override
  String get smugglingCrewTradeNotAvailable =>
      'Mannschaftsschmuggel für Handelsgüter ist noch nicht verfügbar';

  @override
  String get smugglingSelectOwnedTransportFirst =>
      'Wählen Sie zunächst ein eigenes Fahrzeug oder Flugzeug aus';

  @override
  String get smugglingInvalidQuantity => 'Ungültige Menge';

  @override
  String get smugglingActionProcessed => 'Aktion verarbeitet';

  @override
  String smugglingQuoteSummaryLine(String fee, int etaMinutes, String risk) {
    return '$fee € • $etaMinutes min. • $risk% Risiko';
  }

  @override
  String smugglingSeizureRiskPercent(String percent) {
    return '$percent% Risiko';
  }

  @override
  String get smugglingQuotePrompt =>
      'Wählen Sie Artikel und Ziel für ein Live-Angebot aus.';

  @override
  String get smugglingQuoteLiveTitle => 'Live-Zitat';

  @override
  String smugglingOwnedTransportCaption(String label) {
    return 'Eigener Transport: $label';
  }

  @override
  String get smugglingHarborBonus =>
      'Hafenbonus: schnellere Route und niedrigeres Beschlagnahmerisiko (Crew-Hafen in diesem Land).';

  @override
  String smugglingCargoSlotsLine(int required, int available) {
    return 'Frachtplätze: $required / $available';
  }

  @override
  String smugglingCooldownActive(String duration) {
    return 'Abklingzeit aktiv: $duration';
  }

  @override
  String smugglingRecommendedChannel(String channel) {
    return 'Empfohlener Kanal: $channel';
  }

  @override
  String get smugglingInsufficientCash =>
      'Für diese Sendung ist nicht genügend Bargeld vorhanden';

  @override
  String get smugglingDepotsTitle => 'Länderdepots';

  @override
  String get smugglingDepotsEmpty => 'Keine Pakete in den Depots bereit.';

  @override
  String smugglingDepotLine(int packages, int totalQuantity) {
    return '$packages Pakete • $totalQuantity Einheiten';
  }

  @override
  String get smugglingClaimHere => 'Hier einfordern';

  @override
  String get smugglingStatusTitle => 'Schmuggelstatus';

  @override
  String get smugglingNoShipmentsYet => 'Noch keine Lieferungen.';

  @override
  String get smugglingStatusInTransit => 'Unterwegs';

  @override
  String get smugglingStatusReady => 'Bereit';

  @override
  String get smugglingStatusSeized => 'Beschlagnahmt';

  @override
  String get smugglingStatusClaimed => 'Behauptet';

  @override
  String get smugglingStatusUnknown => 'Unbekannt';

  @override
  String get smugglingChannelPackage => 'Paket';

  @override
  String get smugglingChannelCourier => 'Kurierin';

  @override
  String get smugglingChannelContainer => 'Container';

  @override
  String get smugglingChannelOwned => 'Eigener Transport';

  @override
  String get smugglingHintOwnedTransport =>
      'Eigene Transportmittel senken die Kosten und das Risiko, können aber bei einem fehlgeschlagenen Transport beschlagnahmt werden.';

  @override
  String get smugglingHintVehiclesChannel =>
      'Tipp: Fahrzeuge funktionieren am besten mit Kurier oder Container.';

  @override
  String get smugglingHintWeaponsChannel =>
      'Tipp: Größere Waffenladungen sind besser per Container.';

  @override
  String get smugglingHintAmmoChannel =>
      'Tipp: Massenmunition per Container für geringeres Risiko.';

  @override
  String get smugglingHintDrugsChannel =>
      'Tipp: Kleinmengen per Paket, Großmengen per Container.';

  @override
  String get smugglingHintCompareChannels =>
      'Tipp: Sender mit dem Live-Angebot vergleichen.';

  @override
  String get smugglingQuoteBoatCannotFit =>
      'Ein Boot passt nicht in ein Flugzeug.';

  @override
  String get smugglingQuoteCargoOverflow =>
      'Ihre eigene Transportkapazität ist zu gering.';

  @override
  String get smugglingQuoteUnavailable => 'Angebot nicht verfügbar';

  @override
  String get smugglingApiInvalidChannel => 'Ungültiger Schmuggelkanal';

  @override
  String get smugglingApiInvalidNetwork => 'Ungültige Netzwerkauswahl';

  @override
  String get smugglingApiInvalidQuantity => 'Ungültige Menge';

  @override
  String get smugglingApiInvalidDestination => 'Zielland existiert nicht';

  @override
  String get smugglingApiPlayerNotFound => 'Spieler nicht gefunden';

  @override
  String get smugglingApiSameCountryInventory =>
      'Verwenden Sie lokales Inventar für dasselbe Land';

  @override
  String get smugglingApiNotInCrew => 'Du bist nicht Teil einer Crew';

  @override
  String get smugglingApiCrewTradeUnavailable =>
      'Mannschaftsschmuggel für Handelsgüter ist noch nicht verfügbar';

  @override
  String get smugglingApiOwnedVehiclesPersonalOnly =>
      'Eigene Fahrzeuge funktionieren nur für den Personenschmuggel';

  @override
  String get smugglingApiChooseOwnedTransport =>
      'Wählen Sie ein eigenes Fahrzeug oder Flugzeug';

  @override
  String get smugglingApiChosenOwnedTransportUnavailable =>
      'Das ausgewählte eigene Fahrzeug ist nicht verfügbar';

  @override
  String get smugglingApiSameVehicleCargoConflict =>
      'Sie können nicht dasselbe Fahrzeug sowohl als Fracht als auch als Transportmittel verwenden';

  @override
  String get smugglingApiCarCannotCarryOtherVehicle =>
      'Ein Auto oder Motorrad kann kein anderes Fahrzeug transportieren';

  @override
  String get smugglingApiVehiclesCannotUsePackageChannel =>
      'Fahrzeuge können den Paketkanal nicht nutzen';

  @override
  String get smugglingApiBoatCannotFit =>
      'Ein Boot passt nicht in ein Flugzeug.';

  @override
  String get smugglingApiCargoOverflow =>
      'Ihre eigene Transportkapazität ist zu gering.';

  @override
  String smugglingApiCooldownWait(int seconds, String channel) {
    return 'Warten Sie ${seconds}s, bevor Sie eine weitere $channel-Sendung durchführen';
  }

  @override
  String get smugglingApiInsufficientMoney =>
      'Nicht genug Geld für Schmuggelgebühren';

  @override
  String get smugglingApiInsufficientDrugsCrew =>
      'Nicht genügend Medikamente im Inventar der Crew';

  @override
  String get smugglingApiInsufficientDrugs =>
      'Nicht genügend Medikamente im Bestand';

  @override
  String get smugglingApiInsufficientTradeGoods =>
      'Nicht genügend Handelswaren im Lagerbestand';

  @override
  String get smugglingApiInsufficientWeaponsCrew =>
      'Nicht genügend Waffen im Inventar der Crew';

  @override
  String get smugglingApiInsufficientWeapons =>
      'Nicht genügend Waffen im Inventar';

  @override
  String get smugglingApiInsufficientAmmoCrew =>
      'Nicht genügend Munition im Mannschaftsinventar';

  @override
  String get smugglingApiInsufficientAmmo =>
      'Nicht genügend Munition im Inventar';

  @override
  String get smugglingApiInvalidCrewVehicle => 'Ungültiges Mannschaftsfahrzeug';

  @override
  String get smugglingApiCrewBoatUnavailable =>
      'Mannschaftsboot für Schmuggel nicht verfügbar';

  @override
  String get smugglingApiCrewMotorcycleUnavailable =>
      'Mannschaftsmotorrad nicht zum Schmuggel verfügbar';

  @override
  String get smugglingApiCrewCarUnavailable =>
      'Mannschaftswagen für Schmuggel nicht verfügbar';

  @override
  String get smugglingApiInvalidVehicleKey => 'Ungültiges Fahrzeug';

  @override
  String get smugglingApiVehicleUnavailableForSmuggling =>
      'Fahrzeug steht nicht zum Schmuggel zur Verfügung';

  @override
  String get smugglingApiInsufficientStockForShipment =>
      'Der Lagerbestand für diese Lieferung reicht nicht aus';

  @override
  String get smugglingApiDepotNoShipmentsReady =>
      'In diesem Länderdepot sind keine Sendungen bereit';

  @override
  String smugglingApiQuantityTooHighForChannel(String channel, int max) {
    return 'Menge zu hoch für $channel. Maximal: $max';
  }

  @override
  String smugglingApiShipmentStarted(String channel, String destination) {
    return 'Schmuggellieferung ($channel) nach $destination hat begonnen';
  }

  @override
  String smugglingApiClaimedPersonal(int count, String country) {
    return '$count Sendung(en) in $country abgeholt';
  }

  @override
  String smugglingApiClaimedCrew(int count, String country) {
    return '$count Crew-Sendung(en) in $country abgeholt';
  }

  @override
  String get smugglingClientShipmentFailed => 'Der Versand ist fehlgeschlagen';

  @override
  String get smugglingClientQuoteFailed => 'Angebot fehlgeschlagen';

  @override
  String get smugglingClientClaimFailed => 'Anspruch gescheitert';

  @override
  String smugglingClientErrorPrefix(String detail) {
    return 'Fehler: $detail';
  }

  @override
  String get smugglingStepCargo => 'Cargo';

  @override
  String get smugglingStepRoute => 'Route';

  @override
  String get smugglingStepTransport => 'Transport';

  @override
  String get smugglingStepConfirm => 'Confirm';

  @override
  String get smugglingNextStep => 'Next';

  @override
  String get smugglingBackStep => 'Back';

  @override
  String get smugglingEmptyCargoTitle => 'Nothing to ship';

  @override
  String get smugglingEmptyCargoHint =>
      'Buy trade goods, drugs or gear first, then return here.';

  @override
  String get smugglingEmptyShipmentsTitle => 'No active runs';

  @override
  String get smugglingEmptyShipmentsHint =>
      'Start a shipment above. Travel light and claim from the depot.';

  @override
  String get smugglingEmptyDepotsTitle => 'Depots empty';

  @override
  String get smugglingEmptyDepotsHint =>
      'Ready packages appear here when a shipment arrives.';

  @override
  String get smugglingResultSendTitle => 'Shipment underway';

  @override
  String get smugglingResultClaimTitle => 'Depot claimed';

  @override
  String get smugglingResultFeeLabel => 'Fee';

  @override
  String get smugglingResultEtaLabel => 'ETA';

  @override
  String get smugglingResultXpLabel => 'XP';

  @override
  String get smugglingResultRiskLabel => 'Risk';

  @override
  String get smugglingEtaReady => 'Arrived';

  @override
  String smugglingEtaMinutesLeft(int minutes) {
    return '${minutes}m left';
  }

  @override
  String smugglingEtaSecondsLeft(int seconds) {
    return '${seconds}s left';
  }

  @override
  String get smugglingActiveFilter => 'Active';

  @override
  String get smugglingShowAllFilter => 'All';

  @override
  String get smugglingClaimThisDepot => 'Claim depot';

  @override
  String get cryptoMarketNoData => 'Keine Kryptomarktdaten verfügbar';

  @override
  String get cryptoMarketTitle => 'Kryptomarkt';

  @override
  String cryptoMarketOpenOrdersCount(int count) {
    return 'Offene Bestellungen: $count';
  }

  @override
  String get cryptoRegimeBull => 'Hausse';

  @override
  String get cryptoRegimeBear => 'Baisse';

  @override
  String get cryptoRegimeSideways => 'Seitwärts';

  @override
  String cryptoOwnedAmountLine(String amount) {
    return 'Besitz: $amount';
  }

  @override
  String get cryptoPortfolioTitle => 'Portfolio';

  @override
  String get cryptoLabelValue => 'Wert';

  @override
  String get cryptoLabelCostBasis => 'Kostenbasis';

  @override
  String get cryptoLabelUnrealized => 'Unrealisiert';

  @override
  String get cryptoLabelRealized => 'Realisiert';

  @override
  String get cryptoNoPositionsYet => 'Noch keine Stellen';

  @override
  String get cryptoChartDataUnavailable => 'Kartendaten nicht verfügbar';

  @override
  String get cryptoUnknownTime => 'Unbekannt';

  @override
  String get cryptoOrderTypeStopLoss => 'Stop-Loss';

  @override
  String get cryptoOrderTypeTakeProfit => 'Take-Profit';

  @override
  String get cryptoOrderTypeLimit => 'Limit';

  @override
  String get cryptoSideBuy => 'Kaufen';

  @override
  String get cryptoSideSell => 'Verkaufen';

  @override
  String get cryptoInvalidQuantity => 'Ungültige Menge';

  @override
  String get cryptoPurchaseCompleted => 'Kauf abgeschlossen';

  @override
  String get cryptoSaleCompleted => 'Verkauf abgeschlossen';

  @override
  String get cryptoActionProcessed => 'Aktion verarbeitet';

  @override
  String get cryptoInvalidTargetPrice => 'Ungültiger Zielpreis';

  @override
  String get cryptoCannotSellMoreThanOwned =>
      'Sie können nicht mehr verkaufen, als Sie besitzen.';

  @override
  String get cryptoOpenOrderPlaced => 'Offene Bestellung aufgegeben';

  @override
  String get cryptoOpenOrderFailed =>
      'Bestellung konnte nicht aufgegeben werden';

  @override
  String get cryptoOrderCancelled => 'Bestellung storniert';

  @override
  String get cryptoCancelOrderFailed =>
      'Bestellung konnte nicht storniert werden';

  @override
  String get cryptoDirectTradeTitle => 'Direkter Handel';

  @override
  String get cryptoLabelQuantity => 'Menge';

  @override
  String cryptoDirectTradeHelperWithAvgAndAll(
    String currentPrice,
    String avgBuy,
  ) {
    return 'Aktueller Preis: $currentPrice € • Durchschnittlicher Kauf: $avgBuy \nVerwenden Sie ALL, um Ihre gesamte Position sofort zu verkaufen.';
  }

  @override
  String cryptoDirectTradeHelperWithAvgOnly(
    String currentPrice,
    String avgBuy,
  ) {
    return 'Aktueller Preis: $currentPrice € • Durchschnittlicher Kauf: $avgBuy';
  }

  @override
  String cryptoDirectTradeHelperPriceAndAll(String currentPrice) {
    return 'Aktueller Preis: $currentPrice \nVerwenden Sie ALL, um Ihre gesamte Position sofort zu verkaufen.';
  }

  @override
  String cryptoDirectTradeHelperPriceOnly(String currentPrice) {
    return 'Aktueller Preis: $currentPrice';
  }

  @override
  String cryptoYourHistoryForSymbol(String symbol) {
    return 'Ihr Verlauf für $symbol';
  }

  @override
  String get cryptoLabelAvgBuy => 'Durchschnittlicher Kauf';

  @override
  String get cryptoLabelLastBuy => 'Letzter Kauf';

  @override
  String get cryptoLabelBuyVolume => 'Volumen kaufen';

  @override
  String get cryptoLabelSellVolume => 'Verkaufsvolumen';

  @override
  String cryptoLastBuyAt(String when) {
    return 'Letzter Kauf um $when';
  }

  @override
  String get cryptoNoTradesForCoinYet => 'Noch keine Trades für diese Münze.';

  @override
  String cryptoOpenOrdersForSymbol(String symbol) {
    return 'Offene Bestellungen für $symbol';
  }

  @override
  String get cryptoOpenOrdersSectionHint =>
      'Offene Bestellungen verwenden unten ihre eigene Menge. Geben Sie in diesem Abschnitt sowohl die Menge als auch den Zielpreis ein.';

  @override
  String get cryptoLabelOrderType => 'Auftragsart';

  @override
  String get cryptoLabelSide => 'Seite';

  @override
  String get cryptoLabelOrderQuantity => 'Bestellmenge';

  @override
  String cryptoOrderQtyHelperOwned(String quantity) {
    return 'Diese Bestellung wird ab Ihrer aktuellen Position verkauft. Besitz: $quantity';
  }

  @override
  String get cryptoOrderQtyHelperStandalone =>
      'Diese Menge ist vom oben genannten Direkthandel unabhängig.';

  @override
  String get cryptoLabelTargetPrice => 'Zielpreis';

  @override
  String get cryptoTargetPriceHelperLimit =>
      'Begrenzen Sie den Kauf unter dem Preis, begrenzen Sie den Verkauf über dem Preis';

  @override
  String get cryptoTargetPriceHelperStopLoss =>
      'Wird ausgeführt, wenn der Preis auf dieses Niveau fällt';

  @override
  String get cryptoTargetPriceHelperTakeProfit =>
      'Wird ausgeführt, wenn der Preis auf dieses Niveau steigt';

  @override
  String get cryptoPlaceOpenOrder => 'Offene Bestellung aufgeben';

  @override
  String get cryptoNoOpenOrdersYet =>
      'Sie haben noch keine offenen Bestellungen für diese Münze.';

  @override
  String get cryptoLabelCancel => 'Stornieren';

  @override
  String cryptoDetailsTitleWithSymbol(String symbol) {
    return 'Kryptodetails • $symbol';
  }

  @override
  String get cryptoLabelCoin => 'Münze';

  @override
  String get cryptoLabelPrice => 'Preis';

  @override
  String get cryptoLabelOwned => 'Im Besitz';

  @override
  String get cryptoLabelOpenOrders => 'Offene Bestellungen';

  @override
  String get cryptoNotEnoughHistory => 'Noch nicht genug Geschichte';

  @override
  String get cryptoChartPointsWord => 'Punkte';

  @override
  String get cryptoChartHourAbbrev => 'H';

  @override
  String cryptoChartDataCaptionFullHistory(int count, String points) {
    return '$count $points • vollständiger Verlauf';
  }

  @override
  String cryptoChartDataCaptionHours(int count, String points, String hours) {
    return '$count $points • $hours';
  }

  @override
  String get cryptoChartRange1h => '1h';

  @override
  String get cryptoChartRange4h => '4h';

  @override
  String get cryptoChartRange8h => '8h';

  @override
  String get cryptoChartRange24h => '24h';

  @override
  String get cryptoChartRange7d => '7d';

  @override
  String get cryptoChartRange30d => '30 Tage';

  @override
  String get cryptoChartRangeAll => 'Alle';

  @override
  String get cryptoChartLive1h => 'Live • letzte 1 Stunde';

  @override
  String get cryptoChartLive4h => 'Live • letzte 4 Stunden';

  @override
  String get cryptoChartLive8h => 'Live • letzte 8h';

  @override
  String get cryptoChartLive24h => 'Live • letzte 24 Stunden';

  @override
  String get cryptoChartLive7d => 'Live • letzte 7 Tage';

  @override
  String get cryptoChartLive30d => 'Live • letzte 30 Tage';

  @override
  String get cryptoChartLiveAll => 'Live • vollständige Geschichte';

  @override
  String get cryptoLabelTotal => 'Gesamt';

  @override
  String get cryptoApiCouldNotLoadMarket =>
      'Der Kryptomarkt konnte nicht geladen werden.';

  @override
  String get cryptoApiAssetNotFound => 'Krypto nicht gefunden.';

  @override
  String get cryptoApiCouldNotLoadChart =>
      'Krypto-Chartdaten konnten nicht geladen werden.';

  @override
  String get cryptoApiNotLoggedIn => 'Nicht angemeldet.';

  @override
  String get cryptoApiCouldNotLoadPortfolio =>
      'Portfolio konnte nicht geladen werden.';

  @override
  String get cryptoApiCouldNotLoadTransactions =>
      'Der Krypto-Transaktionsverlauf konnte nicht geladen werden.';

  @override
  String get cryptoApiInvalidQuantity => 'Ungültige Menge.';

  @override
  String get cryptoApiInsufficientFunds => 'Nicht genug Geld.';

  @override
  String get cryptoApiPurchaseFailed => 'Der Kauf ist fehlgeschlagen.';

  @override
  String get cryptoApiNotEnoughCrypto =>
      'Es werden nicht genügend Kryptowährungen gehalten.';

  @override
  String get cryptoApiSellFailed => 'Der Verkauf ist fehlgeschlagen.';

  @override
  String get cryptoApiCouldNotLoadOrders =>
      'Kryptoaufträge konnten nicht geladen werden.';

  @override
  String get cryptoApiInvalidTargetPrice => 'Ungültiger Zielpreis.';

  @override
  String get cryptoApiInvalidOrderType => 'Ungültiger Bestelltyp.';

  @override
  String get cryptoApiInvalidOrderSide => 'Ungültige Bestellseite.';

  @override
  String get cryptoApiInvalidOrderCombination =>
      'Diese Kombination aus Bestellart und Beilage ist nicht zulässig.';

  @override
  String get cryptoApiPlaceOrderFailed =>
      'Bestellung konnte nicht aufgegeben werden.';

  @override
  String get cryptoApiPlayerNotFound => 'Spieler nicht gefunden.';

  @override
  String get cryptoApiInvalidOrderId => 'Ungültige Bestell-ID.';

  @override
  String get cryptoApiOrderNotFoundOrClosed =>
      'Bestellung nicht gefunden oder nicht mehr aktiv.';

  @override
  String get cryptoApiCancelOrderFailed =>
      'Bestellung konnte nicht storniert werden.';

  @override
  String cryptoApiBuySuccess(String quantity, String symbol, String total) {
    return 'Sie haben $quantity $symbol für $total € gekauft.';
  }

  @override
  String cryptoApiSellSuccess(String quantity, String symbol, String total) {
    return 'Sie haben $quantity $symbol für $total € verkauft.';
  }

  @override
  String cryptoApiOrderPlaced(
    String side,
    String quantity,
    String symbol,
    String price,
  ) {
    return 'Bestellung aufgegeben: $side $quantity $symbol @ $price.';
  }

  @override
  String cryptoApiOrderCancelledDetail(int orderId) {
    return 'Bestellung $orderId storniert.';
  }

  @override
  String cryptoClientErrorPrefix(String detail) {
    return 'Fehler: $detail';
  }

  @override
  String drugsClientErrorLoading(String error) {
    return 'Fehler beim Laden: $error';
  }

  @override
  String drugsFacilitiesErrorLoading(String error) {
    return 'Fehler beim Laden der Einrichtungen: $error';
  }

  @override
  String get drugsInvTitle => 'Arzneimittelinventar';

  @override
  String get drugsInvKpiGramsLabel => 'Inventar';

  @override
  String get drugsCutQualityDCannotCut =>
      'Qualität D kann nicht weiter gekürzt werden.';

  @override
  String get drugsCutFailed => 'Das Schneiden ist fehlgeschlagen';

  @override
  String get drugsSellFailed => 'Der Verkauf ist fehlgeschlagen';

  @override
  String drugsSellDialogTitle(String name) {
    return 'Verkaufen $name';
  }

  @override
  String drugsInvAvailableQty(String qty) {
    return 'Verfügbar: $qty g';
  }

  @override
  String drugsQualityWithGrade(String grade) {
    return 'Qualität: $grade';
  }

  @override
  String drugsCurrentPricePerGram(String price) {
    return 'Aktueller Preis: $price € pro Gramm';
  }

  @override
  String get drugsPricesByCountry => 'Preise nach Ländern:';

  @override
  String get drugsQuantityGramsField => 'Menge (Gramm)';

  @override
  String drugsInvTotalLine(String amount) {
    return 'Gesamt: $amount €';
  }

  @override
  String get drugsInvalidQuantity => 'Ungültige Menge';

  @override
  String get drugsSellAction => 'Verkaufen';

  @override
  String get drugsExportAction => 'Exportieren';

  @override
  String drugsExportDialogTitle(String name) {
    return 'Export $name';
  }

  @override
  String get drugsExportDestLabel => 'Ziel';

  @override
  String drugsExportQuoteStreet(String amount) {
    return 'Straßenpreis Ziel: €$amount/g';
  }

  @override
  String drugsExportQuoteB2b(String amount) {
    return 'Großhandel: €$amount/g';
  }

  @override
  String drugsExportPayout(String amount) {
    return 'Auszahlung bei Ankunft: €$amount';
  }

  @override
  String drugsExportFee(String amount) {
    return 'Fracht: €$amount';
  }

  @override
  String drugsExportEta(String minutes) {
    return 'ETA: $minutes Min';
  }

  @override
  String drugsExportSeizure(String pct) {
    return 'Beschlagnahme: $pct%';
  }

  @override
  String drugsExportHeat(String heat, String fbi) {
    return 'Heat +$heat · FBI +$fbi';
  }

  @override
  String get drugsExportHarbor => 'Hafenbonus aktiv';

  @override
  String get drugsExportConfirm => 'Senden';

  @override
  String drugsExportMinHint(String grams) {
    return 'Mindestens ${grams}g';
  }

  @override
  String get drugsExportFailed => 'Export fehlgeschlagen';

  @override
  String get drugsExportStarted => 'Ladung unterwegs. Bargeld bei Ankunft.';

  @override
  String get drugsExportCannotAfford => 'Nicht genug Bargeld für die Fracht';

  @override
  String get drugsExportCrewFeeHint => 'Crewbank zahlt die Fracht';

  @override
  String drugsExportCrewPayout(String crew, String runner) {
    return 'Auszahlung: Crew €$crew · Läufer €$runner';
  }

  @override
  String get drugsExportCannotAffordCrew =>
      'Crewbank hat nicht genug für die Fracht';

  @override
  String get drugsHubExportCrewPrefix => 'Crew';

  @override
  String get drugsCrewLotsTitle => 'Crew-Qualitätslots';

  @override
  String get drugsCrewExportStarted =>
      'Crew-Ladung unterwegs. Bargeld bei Ankunft auf die Crewbank.';

  @override
  String get drugsHubExportsTitle => 'Großhandels-Sendungen';

  @override
  String get drugsHubExportInTransit => 'Unterwegs';

  @override
  String get drugsHubExportSold => 'Verkauft';

  @override
  String get drugsHubExportSeized => 'Abgefangen';

  @override
  String get drugsHubExportEmpty => 'Kein offener Export';

  @override
  String drugsHubExportLine(String qty, String dest, String status) {
    return '${qty}g → $dest · $status';
  }

  @override
  String get drugsInvEmptyTitle => 'Keine Medikamente im Inventar';

  @override
  String get drugsInvEmptySubtitle =>
      'Beginnen Sie mit der Produktion, um Medikamente herzustellen';

  @override
  String get drugsInvSectionHeader => 'Inventar und Vertrieb';

  @override
  String get drugsInvSectionBody =>
      'Verkaufe lokal oder exportiere eine Großhandelsladung in ein anderes Land. Straßenverkauf, Nachtclub, Darkweb und Marktplatz bleiben Einzelhandel.';

  @override
  String drugsInvCurrentLocation(String place) {
    return 'Aktueller Standort: $place';
  }

  @override
  String drugsInvStockLine(String qty) {
    return 'Inventar: $qty g';
  }

  @override
  String drugsInvCurrentValue(String amount) {
    return 'Aktueller Wert: $amount €';
  }

  @override
  String drugsInvMarketLine(String emoji, String pct) {
    return 'Markt: $emoji $pct%';
  }

  @override
  String get drugsCutDialogTitle => 'Reduzieren Sie Drogen';

  @override
  String drugsCutQualityBanner(String fromQ, String toQ, String pct) {
    return 'Qualität $fromQ → $toQ: +$pct% mehr Einheiten';
  }

  @override
  String drugsCutResultLine(
    String qty,
    String qFrom,
    String result,
    String qTo,
  ) {
    return 'Ergebnis: $qty g $qFrom → $result g $qTo';
  }

  @override
  String get drugsCutAction => 'Schneiden';

  @override
  String get drugsSlotsLabel => 'Slots';

  @override
  String get drugsFacilitiesTitle => 'Drogeneinrichtungen';

  @override
  String get drugsFacilitiesHeroTitle =>
      'Verwalten Sie Ihre Arzneimitteleinrichtungen';

  @override
  String get drugsFacilitiesHeroBody =>
      'Einrichtungen wie Gewächshaus, Pilzfarm, Drogenlabor, Crack-Küche und Darkweb-Storefront bestimmen, welche Medikamente Sie produzieren können, wie viele Slots Sie haben und wie stark Ihre Qualität, Ausbeute und Geschwindigkeit sind.';

  @override
  String get drugsFacCurrentProductions => 'Aktuelle Produktionen';

  @override
  String get drugsFacUnknownFacility => 'Unbekannte Einrichtung';

  @override
  String get drugsFacUnknownMessage => 'Unbekannte Nachricht';

  @override
  String get drugsFacUpgradeLockedTitle => '🔒 Medikamenten-Upgrade gesperrt';

  @override
  String get drugsFacUpgradeLockedBody =>
      'Sie benötigen zunächst die richtigen Ausbildungsniveaus und Zertifizierungen für Betäubungsmittel.';

  @override
  String get drugsFacEquipLockedTitle => '🔒 Ausrüstungs-Upgrade gesperrt';

  @override
  String get drugsFacEquipLockedBody =>
      'Trainiere zuerst deine Narcotics-Strecke, um die nächste Upgrade-Stufe freizuschalten.';

  @override
  String get drugsFacBuy => 'Kaufen';

  @override
  String get drugsFacOwned => 'Im Besitz';

  @override
  String get drugsFacPrice => 'Preis';

  @override
  String get drugsFacRank => 'Rang';

  @override
  String get drugsFacDrugTypes => 'Drogen';

  @override
  String get drugsFacSlots => 'Spielautomaten';

  @override
  String get drugsFacQuality => 'Qualität';

  @override
  String get drugsFacYield => 'Ertrag';

  @override
  String get drugsFacSpeed => 'Geschwindigkeit';

  @override
  String get drugsFacMaxSlots => 'Max. Slots';

  @override
  String drugsFacUpgradeSlots(String cost) {
    return 'Upgrade-Slots ($cost)';
  }

  @override
  String get drugsFacEquipmentUpgrades => 'Ausrüstungs-Upgrades';

  @override
  String get drugsFacMax => 'Max';

  @override
  String drugsFacLvlPrice(String level, String price) {
    return 'Lvl $level (€$price)';
  }

  @override
  String get drugsHubTitle => 'Drogenumfeld';

  @override
  String get drugsSubviewProduction => 'Arzneimittelproduktion';

  @override
  String get drugsSubviewFacilities => 'Drogeneinrichtungen';

  @override
  String get drugsSubviewInventory => 'Arzneimittelinventar';

  @override
  String get drugsTagUndergroundOps => 'Untergrundoperationen';

  @override
  String get drugsTagMobileOptimized => 'Für Mobilgeräte optimiert';

  @override
  String get drugsTagQualityDriven => 'Qualitätsorientiert';

  @override
  String get drugsEmpireTitle => 'Drogenimperium';

  @override
  String get drugsHubIntro =>
      'Verwalten Sie hier Produktion, Anlagen und Lagerbestände. Kaufen Sie Materialien auf dem Schwarzmarkt, während der Rest in Ihrer eigenen Drogenumgebung läuft.';

  @override
  String get drugsStatMaterialFlow => 'Materialfluss';

  @override
  String get drugsStatBlackMarket => 'Schwarzmarkt';

  @override
  String get drugsStatProductionChain => 'Produktionskette';

  @override
  String get drugsStatProductionChainValue =>
      'Gewächshaus + Labor + Küche + Darkweb';

  @override
  String get drugsStatSalesModel => 'Vertriebsmodell';

  @override
  String get drugsStatPerQuality => 'Pro Qualität';

  @override
  String get drugsMetricActiveBatches => 'Aktive Chargen';

  @override
  String get drugsMetricSlotUsage => 'Slot-Nutzung';

  @override
  String get drugsMetricInventoryValue => 'Inventarwert';

  @override
  String get drugsMetricInventoryGrams => 'Lagerbestand Gramm';

  @override
  String get drugsMetricEfficiency => 'Effizienz';

  @override
  String get drugsMetricPoliceHeat => 'Polizeihitze';

  @override
  String get drugsSectionOperations => 'Operationen';

  @override
  String get drugsSectionOperationsSubtitle =>
      'Wählen Sie einen Zweig Ihres Drogenimperiums';

  @override
  String get drugsCardOpenAction => 'Open';

  @override
  String drugsCardStepLabel(int step) {
    return 'Step $step';
  }

  @override
  String get drugsCardFacilitiesEyebrow => 'Infrastruktur';

  @override
  String get drugsCardFacilitiesTitle => 'Einrichtungen';

  @override
  String get drugsCardFacilitiesBody =>
      'Kaufen und aktualisieren Sie Gewächshaus, Drogenlabor, Crack-Küche und Darkweb-Storefront für mehr Slots, Geschwindigkeit und Qualität.';

  @override
  String get drugsCardProductionEyebrow => 'Pipeline';

  @override
  String get drugsCardProductionTitle => 'Produktion';

  @override
  String get drugsCardProductionBody =>
      'Starten Sie Chargen, verfolgen Sie Timer und sammeln Sie die Ausgabe mit Qualitätsrollen.';

  @override
  String get drugsCardInventoryEyebrow => 'Verteilung';

  @override
  String get drugsCardInventoryTitle => 'Inventar';

  @override
  String get drugsCardInventoryBody =>
      'Sehen Sie sich die Stapel nach Qualität an und verkaufen Sie sie zum besten Marktwert.';

  @override
  String get drugsHubStatsTitle => 'Overview';

  @override
  String get drugsCardFacilitiesBadgeNone => 'No facility yet';

  @override
  String drugsCardFacilitiesBadgeCount(int count) {
    return '$count owned';
  }

  @override
  String get drugsCardProductionBadgeNone => 'No active batches';

  @override
  String drugsCardProductionBadgeCount(int count) {
    return '$count active';
  }

  @override
  String get drugsCardInventoryBadgeNone => 'No stock';

  @override
  String drugsCardInventoryBadgeSummary(int grams, String value) {
    return '$grams g · €$value';
  }

  @override
  String get drugsQualityDistribution => 'Qualitätsverteilung';

  @override
  String get drugsQualityGradeSuperior => 'Vorgesetzter';

  @override
  String get drugsQualityGradeHigh => 'Hoch';

  @override
  String get drugsQualityGradeStandardPlus => 'Standard+';

  @override
  String get drugsQualityGradeStandard => 'Standard';

  @override
  String get drugsQualityGradeLow => 'Niedrig';

  @override
  String get drugsHeatLevelLow => 'Niedrig';

  @override
  String get drugsHeatLevelMedium => 'Medium';

  @override
  String get drugsHeatLevelHigh => 'Hoch';

  @override
  String get drugsHeatLevelCritical => 'Kritisch';

  @override
  String get drugsProdTitle => 'Arzneimittelproduktion';

  @override
  String get drugsProdLineTitle => 'Produktionslinie';

  @override
  String get drugsProdLineSubtitle =>
      'Starten Sie Chargen, überwachen Sie die Slot-Kapazität und optimieren Sie die Qualität durch Gewächshaus- und Labor-Upgrades.';

  @override
  String get drugsProdActiveProductions => 'Aktive Produktionen';

  @override
  String get drugsProdIncidentLegend => 'Vorfalllegende';

  @override
  String get drugsProdHide => 'Verstecken';

  @override
  String get drugsProdShow => 'Zeigen';

  @override
  String get drugsProdLegendDelay => 'Verzögerung';

  @override
  String get drugsProdLegendContamination => 'Kontamination';

  @override
  String get drugsProdLegendYieldLoss => 'Ertragsverlust';

  @override
  String get drugsProdLegendInstability => 'Instabilität';

  @override
  String get drugsProdLegendCombined => 'Kombiniertes Problem';

  @override
  String get drugsProdCollect => 'Sammeln';

  @override
  String get drugsProdSpeedupAction => 'Speed up with credits';

  @override
  String get drugsProdSpeedupTitle => 'Speed up production?';

  @override
  String drugsProdSpeedupBody(int credits, int minutes) {
    return 'Spend $credits credits to finish this batch now ($minutes min remaining).';
  }

  @override
  String get drugsProdSpeedupConfirm => 'Speed up';

  @override
  String drugsProdSpeedupSuccess(int credits) {
    return 'Production finished early (−$credits credits).';
  }

  @override
  String get drugsProdSpeedupFailed => 'Could not speed up production.';

  @override
  String get drugsProdSpeedupInsufficientCredits =>
      'Not enough credits to speed up this batch.';

  @override
  String get drugsProdSpeedupAlreadyReady =>
      'This batch is already ready to collect.';

  @override
  String get drugsProdSpeedupUnavailable =>
      'Speed-up is not available for this batch.';

  @override
  String get drugsProdAvailableDrugs => 'Verfügbare Medikamente';

  @override
  String get drugsProdNoDrugs => 'Keine Medikamente verfügbar';

  @override
  String get drugsProdAutoCollectOn => 'Automatische Abholung am (VIP)';

  @override
  String get drugsProdAutoCollectOff => 'Automatische Abholung (VIP)';

  @override
  String get drugsProdVipMaterialsOk => 'Alle Materialien vorhanden';

  @override
  String get drugsProdVipBuyMissing =>
      'VIP: Fehlende Materialien mit einem Klick kaufen';

  @override
  String drugsProdTimeYieldLine(String time, String yield) {
    return 'Zeit: $time | Ausbeute: ${yield}g';
  }

  @override
  String drugsProdSlotsUsedLine(String facility, String used, String total) {
    return '$facility: $used/$total Slots belegt';
  }

  @override
  String drugsProdFacilityRequired(String facility) {
    return '$facility erforderlich';
  }

  @override
  String drugsProdRankRequired(String rank) {
    return 'Rang $rank erforderlich';
  }

  @override
  String get drugsProdNoFreeSlot => 'Kein freier Produktionsslot verfügbar';

  @override
  String get drugsProdOpenFacilities => 'Offene Einrichtungen';

  @override
  String get drugsProdStartProduction => 'Starten Sie die Produktion';

  @override
  String get drugsProdAutoCollectUpdated =>
      'Automatische Sammlung aktualisiert';

  @override
  String get drugsProdKpiActive => 'aktiv';

  @override
  String get drugsProdKpiReady => 'bereit';

  @override
  String drugsProdYieldGrams(String qty) {
    return 'Ausbeute: $qty Gramm';
  }

  @override
  String get drugsTimeMinSuffix => 'min';

  @override
  String drugsFmtMinutes(String minutes) {
    return '$minutes min';
  }

  @override
  String drugsFmtHoursOnly(String hours) {
    return '$hours Std';
  }

  @override
  String drugsFmtHoursMinutes(String hours, String minutes) {
    return '$hours Std. $minutes Min';
  }

  @override
  String get drugsTimeHourEn => 'Std';

  @override
  String get drugsProdConfirmTitle => 'Bist du sicher?';

  @override
  String drugsProdConfirmBody(String drugName) {
    return '$drugName Produktion starten?';
  }

  @override
  String drugsProdTimeLine(String time) {
    return 'Zeit: $time';
  }

  @override
  String drugsProdYieldLine(String yield) {
    return 'Ausbeute: $yield Gramm';
  }

  @override
  String get drugsProdRiskNote =>
      'Die Produktion kann manchmal Rückschläge erleiden. Bessere Upgrades senken das Risiko, hohe Medikamenteneinwirkung erhöht es.';

  @override
  String get drugsProdRequiredMaterialsHeader => 'Benötigte Materialien:';

  @override
  String get drugsProdStartProductionButton => 'Starten Sie die Produktion';

  @override
  String get drugsProdFailed => 'Die Produktion scheiterte';

  @override
  String get drugsProdCollectFailed => 'Die Erfassung ist fehlgeschlagen';

  @override
  String drugsProdNeedRank(String rank) {
    return 'Du brauchst Rang $rank';
  }

  @override
  String get drugsProdMissingPrefix => 'Fehlen';

  @override
  String get drugsFacilityGreenhouse => 'Gewächshaus';

  @override
  String get drugsFacilityCrackKitchen => 'Crack-Küche';

  @override
  String get drugsFacilityDarkweb => 'Darkweb-Storefront';

  @override
  String get drugsFacilityMushroomFarm => 'Pilzfarm';

  @override
  String get drugsFacilityDrugLab => 'Drogenlabor';

  @override
  String get drugsVipQuickBuyTitle => 'VIP-Schnellkauf';

  @override
  String drugsVipAlreadyEnough(String name) {
    return 'Sie haben bereits genügend Materialien für $name';
  }

  @override
  String drugsVipBuyPrompt(String name) {
    return 'Alle fehlenden Materialien für $name mit einem Klick kaufen?';
  }

  @override
  String drugsVipTotal(String amount) {
    return 'Gesamt: $amount €';
  }

  @override
  String get drugsPurchaseCompleted => 'Kauf abgeschlossen';

  @override
  String get drugsPurchaseFailed => 'Der Kauf ist fehlgeschlagen';

  @override
  String get drugsServiceErrorGeneric => 'Fehler';

  @override
  String get drugsApiFailedBuyMaterial =>
      'Material konnte nicht gekauft werden';

  @override
  String get drugsApiFailedStartProduction =>
      'Die Produktion konnte nicht gestartet werden';

  @override
  String get drugsApiFailedCollect =>
      'Die Produktion konnte nicht erfasst werden';

  @override
  String get drugsApiFailedSell => 'Der Verkauf von Drogen ist fehlgeschlagen';

  @override
  String get drugsApiFailedCut => 'Medikamente konnten nicht reduziert werden';

  @override
  String get drugsApiFailedShipment => 'Sendung konnte nicht gesendet werden';

  @override
  String get drugsApiFailedClaim =>
      'Depotsendungen konnten nicht angefordert werden';

  @override
  String get helpTopicDashboardCategory => 'Kern';

  @override
  String get helpTopicDashboardTitle => 'Armaturenbrett';

  @override
  String get helpTopicDashboardSummary =>
      'Deine zentrale Übersicht mit all deinen Statistiken, aktiven Abklingzeiten, Live-Events und Verknüpfungen zu jedem Teil des Spiels.';

  @override
  String get helpTopicDashboardHow =>
      'Die obere Leiste zeigt: Bargeld, Rang, Gesundheit (0–100 HP), Fahndungslevel (0–100) und FBI-Heat (0–100). \nRangtitel folgen der gleichen Rangliste wie Ihr öffentliches Profil: zum Beispiel Soldat um Rang 25 und Pate erst ab Rang 60. \nAlle 5 Minuten wird ein automatischer Tick ausgelöst: Hunger sinkt um -2, Durst um -3, du heilst dich passiv um +5 HP (wenn HP > 0), Bankzinsen werden hinzugefügt (0,5 %) und das Fahndungslevel sinkt leicht, wenn es unter 10 liegt. \nWenn Hunger oder Durst 0 erreichen, sterben Sie und verbringen 3 Stunden auf der Intensivstation. Essen und trinken Sie pünktlich! \nAuf Mobilgeräten sorgt eine klebrige Fußzeile dafür, dass Verbrechen, Fahrzeugdiebstahl, Arbeit, Bank und Crew nur einen Fingertipp entfernt sind. Ein goldener Punkt auf „Verbrechen“, „Stehlen“ oder „Arbeit“ bedeutet, dass die Abklingzeit bereit ist. Alles andere finden Sie im Hamburger-Menü oder in der linken Seitenleiste; Dieses Menü ist gruppiert (Aktionen, Welt, Soziales, Wirtschaft, Imperium, Vermögenswerte) und durchsuchbar. \nCooldown-Timer pro Abschnitt zeigen an, wie lange es dauert, bis Ihre nächste Aktion verfügbar ist. Der Timer passt sich an, um die relevanteste Einheit anzuzeigen: Minuten, Stunden oder Tage. \nDie Statistikkarte verwendet jetzt echte Live-Zähler für Ausbrüche, Morde, Trefferlistenverträge, Reisen und Kugeln anstelle von festen Null-Platzhaltern. \nDas Dashboard verfügt jetzt auch über einen erweiterten Wirtschaftsbereich mit Bargeld, Bank, Krypto, Fahrzeugwert, Immobilienwert, Nettovermögen und einem 24-Stunden-Cashflow-Trend. \nDer Betriebsblock zeigt jetzt die aktive Produktion, die längste Abklingzeit, den Fahrzeugstatus (aktiv/gelistet/Transit) und die Timer für die nächste Produktion/das nächste Ereignis an. \nWenn Spielerevents live sind (z. B. wöchentliche Wettbewerbe), listet dasselbe rechte Feld kurz deren Titel und Links zur Seite „Events“ auf. Sie können Push für Rundenstart/-ende unter Einstellungen → Spielerereignisse ein- oder ausschalten (zusätzlich zu Geräteberechtigungen und anderen Push-Kategorien). \nBenachrichtigungen und Risiken umfassen jetzt ungelesene DMs, Support-Tickets, die auf Ihre Antwort warten, Ereignisse der letzten 24 Stunden und eine kompakte Risikobewertung (gesucht + FBI). \nWenn Ihre Crew an Crew Wars beteiligt ist, zeigt das Dashboard auch eine Crew Wars-Zusammenfassung mit Status, Gegner, Crewpunkten, Saisonrang und der verbleibenden Zeit in der aktuellen Phase an. \nDas Dashboard enthält jetzt auch eine Fahrzeug-Ops-Übersicht pro Auto/Motorrad/Boot mit Live-Cooldown-Chips (Hotspot, Crew, Crew-Match, Chop, Contract und Counter) sowie Hitze/Reputation, Vertrags- und Anspruchszahlen und Saisonpunkte. \nLive-Ereignisse treten auf, wenn andere Spieler wichtige Aktionen ausführen, wenn Sie angegriffen werden oder wenn es zu globalen Marktbewegungen kommt. \nDas Nachrichten-Badge zeigt ungelesene Systemnachrichten und persönliche Nachrichten an. \nDas Avatar-Menü oben rechts öffnet Mein Profil, Nachrichten, Hilfe, Einstellungen und Abmelden. \nDas linke Navigationsmenü gewährt Zugriff auf alle Spielabschnitte, gruppiert nach Kategorien: Aktionen, Welt, Soziales, Wirtschaft, Imperium und Vermögenswerte.';

  @override
  String get helpTopicDashboardTips =>
      'Öffnen Sie nach jedem Login zunächst das Dashboard, um zu sehen, was sich während Ihrer Abwesenheit geändert hat. \nHalten Sie den Fahndungslevel unter 10, damit der automatische Verfall funktioniert und die Wahrscheinlichkeit einer Verhaftung gering bleibt. \nÜberprüfen Sie ungelesene Nachrichten, bevor Sie riskante Aktionen starten: Belohnungen, Auftragserfüllungen und Systemereignisse werden alle in Ihrem Posteingang angezeigt.';

  @override
  String get helpTopicCrimesCategory => 'Aktionen';

  @override
  String get helpTopicCrimesTitle => 'Verbrechen';

  @override
  String get helpTopicCrimesSummary =>
      'Begehen Sie illegale Handlungen für Geld und XP, aber jeder Versuch riskiert Schaden, Verhaftung oder ein zusätzliches Fahndungslevel. Die Wipe Criminal Record-Kriminalität im späten Spielverlauf löscht bei Erfolg Ihr gesamtes Strafregister, erfordert jedoch umfangreiche Werkzeuge und birgt ein hohes Bundesrisiko.';

  @override
  String get helpTopicCrimesHow =>
      'Die Abklingzeiten von Verbrechen skalieren jetzt mit der potenziellen Auszahlung: Verbrechen mit geringer Ausbeute bleiben schnell, während Verbrechen mit hoher Ausbeute deutlich längere Abklingzeiten haben. \nRichtwert je Prämienstufe: bis 500 € ≈ 1,5 Min., bis 2.000 € ≈ 5 Min., bis 10.000 € ≈ 15 Min., bis 30.000 € ≈ 30 Min., darüber ≈ 60 Min. \nEs gibt keine feste tägliche Obergrenze für Verbrechen; Aktive Spieler können weiterspielen, solange sie Abklingzeiten, Risiken und Ressourcen verwalten. \nBei Verbrechen mit „erforderlicher Waffe“ werden beide abgenutzten Waffenplätze betrachtet und automatisch die beste Übereinstimmung für dieses Verbrechen verwendet. Tragen Sie die Waffen im Inventar. Eine Rucksackpistole zählt nicht. \nIhre aktiven Fitness- und Schießstandsboni (jeweils bis zu +8 %) werden auf dem Bildschirm „Verbrechen“ angezeigt. Sie erhöhen die Erfolgschancen, wie der Server berechnet (trainieren Sie mehr über den Trainings-Hub / Fitnessstudio + Bereich). \nWenn Sie am selben UTC-Kalendertag mindestens eine Trainingseinheit im Fitnessstudio und eine Schießstandseinheit absolvieren, fügt der Server eine kleine zusätzliche Erfolgschance bei einem Verbrechen hinzu (+0,5 %). Der Bildschirm „Verbrechen“ zeigt an, wann diese Kombination aktiv ist. \nFür Verbrechen mit Fahrzeugpflicht nutzen Sie Ihr ausgewähltes Verbrechensfahrzeug aus Garage oder Marina. Es zählt nur ein Fahrzeug, das sich tatsächlich in Ihrem aktuellen Land befindet und nicht im Transit ist oder zum Verkauf angeboten wird. \nDer Arzneimittelbedarf bei Straftaten wird in Gramm angegeben und folgt den gleichen Mengen wie Ihr Arzneimittelbestand und Ihre Arzneimittellagerung. \nWenn eine Straftat aufgrund eines fehlenden Fahrzeugs, der falschen Waffe oder fehlender Munition nicht gestartet werden kann, sollte die Fehlermeldung jetzt die wahre Ursache anstelle eines allgemeinen Wiederholungsversuchs anzeigen. \nBei jedem Verbrechensversuch erleiden Sie 5–15 Schadenspunkte, reduziert durch eine getragene Weste und Leibwächter (bis zu etwa der Hälfte). Je nach Erfolg oder Misserfolg steigt das Wanted-Level weiterhin um 1–4 Punkte. \nDie Verhaftungswahrscheinlichkeit skaliert schnell mit der Fahndungsstufe: Gesucht 5 = 25 %, Gesucht 10 = 50 %, Gesucht 18+ = maximal 90 %. \nBei einer Verhaftung kommt man ins Gefängnis. Satz = max(gewünschtes Level × 10, 5) Minuten. Kaution = Fahndungsniveau × 1.000 €. Auch wenn eine Straftat zunächst erfolgreich erscheint, man aber gleich danach erwischt wird, zählt das Endergebnis dennoch als Festnahme: Benötigtes Werkzeug wird beschlagnahmt, die gebrauchte Tatwaffe geht verloren und auch Fahrzeuge können beschlagnahmt werden. \nFür einige Straftaten sind ein Fahrzeug, ein Werkzeug oder ein Mindestdienstgrad erforderlich. Wenn diese fehlen, wird verhindert, dass die Straftat beginnt. \nVerdiente XP erhöhen Ihren Rang und schalten bessere Verbrechen und höhere Belohnungen frei. \nDer FBI-Hit steigt mit schwereren Verbrechen. Oberhalb von Hitze 50 wird das FBI aktiv und die Wahrscheinlichkeit einer Festnahme ist noch höher. \nWenn der Polizeidruck des Landes aktiviert ist, verringert ein gemeinsamer Wärmezähler pro Land den Erfolg von Straftaten und erhöht die Wahrscheinlichkeit einer Verhaftung an Ihrem Aufenthaltsort. Bandabzeichen für Reiseshows; Seltene Störeinsätze (Crew/Rang begrenzt) können die Straßen vorübergehend abkühlen.';

  @override
  String get helpTopicCrimesTips =>
      'Nutzen Sie schnelle Anfängerkriminalität, um EP zu sammeln, während Sie auf große Abklingzeiten warten. \nSteigen Sie immer aus, wenn Ihr Wanted-Level hoch ist – im Gefängnis zu sitzen blockiert alle Ihre Schleifen. \nTragen Sie bei Verbrechensausflügen eine Weste: Sie reduziert den Treffer von 5–15 PS und hält Sie länger von der Intensivstation fern. Halten Sie die HP über 30, bevor Sie einen Lauf starten.';

  @override
  String get helpTopicJobsCategory => 'Aktionen';

  @override
  String get helpTopicJobsTitle => 'Jobs';

  @override
  String get helpTopicJobsSummary =>
      'Verdienen Sie legal Geld ohne Wanted-Level-Risiko. Jobs sind sicherer als Straftaten, aber die Spitzenauszahlungen sind niedriger.';

  @override
  String get helpTopicJobsHow =>
      'Die verfügbaren Jobs skalieren mit Rang und Ausbildung: Bessere Jobs zahlen mehr, haben aber auch längere Abklingzeiten. \nDie Abklingzeiten der Jobs richten sich nach der maximalen Auszahlung: Jobs der unteren Stufe etwa 3–5 Minuten, Jobs der mittleren Stufe etwa 8–12 Minuten, Jobs der oberen Stufe etwa 17–22 Minuten. \nJobs haben eine hohe, aber nicht perfekte Erfolgsquote; Bei einem Misserfolg verlierst du weder Geld noch HP, aber du verlierst einige XP. \nAnforderungen pro Job: mindestens 10 PS, Hunger > 20, Durst > 20, nicht im Gefängnis, nicht auf der Intensivstation. \nEs gibt keine feste Tagesobergrenze für Arbeitsplätze; Der Fortschritt wird durch Abklingzeit, Chance und Auszahlung gesteuert, statt durch eine tägliche Sperre. \nDie Arbeitsvergütung variiert je nach Jobtyp und Rang. Bildung (Schule) kann höhere Positionen freischalten. \nSie verdienen auch XP pro Job, wenn auch weniger als bei vergleichbaren Verbrechen. \nNutzen Sie Jobs als verlässliche Cashflow-Basis, insbesondere wenn Ihr Wanted-Level zu hoch für sichere Straftaten ist.';

  @override
  String get helpTopicJobsTips =>
      'Kombinieren Sie Beruf und Schule: Bildung eröffnet bessere Arbeitsplätze mit höheren Gehältern. \nWenn die Fahndungsstufe über 8 liegt oder Sie sich von der Intensivstation erholen, verwenden Sie Jobs anstelle von Straftaten. \nVerhindern Sie, dass Hunger und Durst zu stark sinken: Ein Job mit Werten unter 20 startet einfach nicht.';

  @override
  String get helpTopicTravelCategory => 'Welt';

  @override
  String get helpTopicTravelTitle => 'Reisen';

  @override
  String get helpTopicTravelSummary =>
      'Wechseln Sie zwischen Ländern, um bessere Marktpreise, einzigartige Möglichkeiten und Zugang zu internationalen Systemen zu erhalten.';

  @override
  String get helpTopicTravelHow =>
      'Verfügbare Länder: Niederlande (Start), Belgien, Deutschland, Frankreich, Vereinigtes Königreich, Spanien, Italien, Schweiz, USA, Mexiko, Kolumbien, Brasilien. \nReisekosten: Nachbarland 500–2.000 €, Europa → Amerika 5.000–10.000 €, Fernreise 10.000–20.000 €. \nReisevoraussetzungen: nicht im Gefängnis, nicht auf der Intensivstation, mindestens 20 PS, Reisekosten vorhanden. \nMedikamentenmengen in Ihrem Inventar gelten für das Tragegewicht und für Reiseschecks als echte Gramm; 500 bedeutet 500g, nicht 50kg. \nJedes Land hat unterschiedliche Marktpreise (bis zu 300 % Preisunterschied), unterschiedliche Kriminalitätsauszahlungen und einzigartige Handelsgüter. \nTransportrisiko: Die Polizei kann Waren basierend auf der Fahndungsstufe beschlagnahmen (Chance = Fahndung × 2 %, max. 80 %). Wenn es heiß hergeht, kann das FBI international alles beschlagnahmen. \nDie Zollkontrolle hat eine Grundchance von 10 %. Sie können bestechen (1.000-5.000 €) oder dabei erwischt werden, wie Sie 50 % der Waren verlieren. \nNach der Ankunft sind alle Aktionen sofort im neuen Land verfügbar. Märkte und Kriminalitätsgeschwindigkeit variieren je nach Standort.';

  @override
  String get helpTopicTravelTips =>
      'Kombinieren Sie Reisen immer mit Handel, Drogen oder Schmuggel – Leerreisen verschwenden Geld. \nSenken Sie Ihren Fahndungslevel vor dem Abflug: Ein hoher Fahndungsstatus erhöht das Beschlagnahmungsrisiko unterwegs erheblich. \nPlanen Sie Ihre Rückreise im Voraus, damit Sie bereits wissen, was Sie bei Ihrer Ankunft mitbringen müssen.';

  @override
  String get helpTopicCrewCategory => 'Sozial';

  @override
  String get helpTopicCrewTitle => 'Crew';

  @override
  String get helpTopicCrewSummary =>
      'Bilden Sie eine Crew oder schließen Sie sich bestehenden Spielern an, um gemeinsam Raubüberfälle durchzuführen, Lager zu teilen und als Einheit stärker zu werden.';

  @override
  String get helpTopicCrewHow =>
      'Die Erstellung einer Crew kostet 10.000 €. Das Crew-Hauptquartier bestimmt, wie viele Mitglieder Ihre Crew aufnehmen kann, und skaliert auf bis zu 150 Mitglieder. Der Anführer kann Raubüberfälle einladen, treten und starten. \nVorteile für die Crew: Zugriff auf große Raubüberfälle, gemeinsamer Lagerraum, Teamwork-Bonus (+10 % Erfolg pro zusätzlichem Mitglied, max. +30 %) und Gruppenchat. \nNeue Crews beginnen jetzt mit Crew-Hauptquartier Level 1 und allen Lagergebäuden auf Level 1, einschließlich Bargeldlager, sodass die Crew-Bank und das gemeinsame Lager sofort funktionieren. \nDie Mannschaftswagenaufbewahrung nimmt jetzt auch Motorräder auf, so dass Landfahrzeuge gemeinsam von derselben gemeinsamen Mannschaftsaufbewahrung aus verwaltet werden können. \nWenn ein Besatzungsmitglied verhaftet wird, erhalten Besatzungsmitglieder jetzt eine Push-Benachrichtigung, dass der Spieler eingesperrt ist und auf Hilfe wartet. \nDer Crew-Bildschirm ist jetzt in „Übersicht“, „Hauptquartier & Upgrades“, „Lager“, „Mitglieder“, „War Room“, „Crew-Missionen“, „Crews“ und „Chat“ gruppiert, sodass sich die Verwaltung ruhiger und professioneller anfühlt. \nCrew Missions zeigt Stufenvorlagen, eine aktive Laufkarte und aktuelle Läufe an. Leiter/Co-Leiter können beginnen und Lösungen finden; Das Einfordern von Belohnungen und die Beschleunigung der Abklingzeit werden auf derselben Registerkarte verwaltet. \nEs gibt zusätzliche Besatzungsmissionen mit Operationen zum Thema Bank (Nachtdepot, Skim-Netzwerk, gepanzerte Route, Nebentresor, Reservetresor und Clearingstelle). Neben Casino Ledger Raid gibt es keine zweite Casino-Crew-Mission. \nDie Belohnungen für Besatzungsmissionen stammen aus der serverseitigen Missionsökonomie. Die Bankguthaben anderer Spieler werden für diese Auszahlungen nicht belastet. \nWenn Sie eine Mission starten, können Sie jetzt jedem Besatzungsmitglied eine Rolle zuweisen (Planer, Vollstrecker, Logistik, Techniker), um Teamboni zu erhalten. \nAktive und aktuelle Missionskarten zeigen jetzt auch die Rollenbeiträge pro Spieler mit Punktzahl und etwaigem Auszahlungsmultiplikator an. \nBesatzungsmitglieder erhalten jetzt auch Push-/In-App-Benachrichtigungen zum Missionsstart, zum Missionsergebnis und wenn die Abklingzeit einer Mission wieder bereit ist. \nWährend die Abklingzeit einer Mission aktiv ist, können Sie keine neue Mission starten; Warten Sie zunächst die verbleibende Abklingzeit ab oder beschleunigen Sie es mit Credits. \nZur Beschleunigung der Abklingzeit sehen Sie zunächst die genauen Kreditkosten und die verbleibenden Minuten, bevor Sie bestätigen. \nCrew Wars verfügt über eine eigene War Room-Registerkarte im Crew-Bildschirm. Nur Anführer können einen Krieg erklären und zur Teilnahme sind mindestens 3 Besatzungsmitglieder erforderlich. \nKriegsarten: Kill War, Economy War, Territory War und Total War. Jeder Krieg durchläuft Vorbereitung, aktive Phase, Abriegelung und Lösung. \nWährend eines aktiven Krieges können die Teilnehmer Aktionen wie Tötungen, Überfälle, Sabotage, Informationen, Überfälle, Schilde, Boosts und Gebietsansprüche durchführen. Durch gezielte Aktionen können Sie jetzt direkt aus einer Liste gegnerischer Besatzungsmitglieder auswählen, anstatt eine Spieler-ID manuell einzugeben. \nSaisonpunkte werden in der Crew Wars-Bestenliste zusammengefasst. Der Kriegsraum zeigt außerdem den Stand, die letzten Aktionen und die letzten Kriege Ihrer Crew an. \nIn Territory War und Total War beanspruchen Sie jetzt echte Territorialregionen aus dem Territorialsystem anstelle von generischen Platzhalterzielen. \nDiese Kriegsregionen zeigen jetzt auch ihren strategischen Wert im War Room an: Anspruchsbonus, Tick-Punkte und Tags wie Hafen, Hauptstadt oder Logistik. Dadurch wird sofort klar, welche Regionen mehr wert sind als ein einfacher Eigentümertausch. \nCrew Wars wählt Gebietsziele nicht mehr allein nach der Wertstufe aus, sondern auch nach strategischen Markierungen und angrenzendem Druck durch das Territorium des Angreifers oder Verteidigers. Dadurch wirken Territory War und Total War eher wie eine echte Frontlinie als wie drei zufällige Ansprüche. \nRaubüberfälle: Kleine Bank (2 Spieler, 40 %, 10.000–30.000 €, 30 Min. Abklingzeit), Juweliergeschäft (3 Spieler, 35 %, 20.000–50.000 €, 45 Min.), Casino-Überfall (4 Spieler, 25 %, 50.000–150.000 €, 2 Std.), Federal Reserve (5 Spieler, 15 %, 100.000-500.000 €, 6 Stunden, +20 FBI Heat). \nFür einen Raubüberfall müssen alle Mitglieder zu Beginn online sein. Wenn jemand abwesend ist, schlägt der Raub fehl. \nFehlgeschlagener Raubüberfall: Gefängnisstrafe für alle, Fahndungsstufe +5, keine Belohnung. \nDie Raubüberfallbelohnung wird zu gleichen Teilen unter allen teilnehmenden Mitgliedern aufgeteilt. \nFür eine schnelle Koordination steht ein Crew-Chat zur Verfügung. \nFortschritt im Crew-Hauptquartier: Je länger und aktiver die Crew, desto mehr gemeinsame Upgrades und Buffs werden freigeschaltet.';

  @override
  String get helpTopicCrewTips =>
      'Neue Besatzungen können sofort Geld einzahlen und den gemeinsamen Lagerraum nutzen; Konzentrieren Sie sich danach auf Upgrades für mehr Kapazität statt auf einen separaten Starterkauf. \nSchauen Sie zunächst im War Room nach, ob sich Ihre Crew noch in der Abklingzeit befindet, bevor Sie versuchen, einen neuen Krieg zu erklären. \nKoordinieren Sie Zielanrufe im Crew-Chat, damit Sie nicht ständig denselben Gegner farmen und den Anti-Farm-Wächter stolpern lassen. \nKoordinieren Sie die Startzeiten des Raubüberfalls im Crew-Chat, damit alle online sind und niemand im Gefängnis sitzt. \nWählen Sie eine Crew in derselben Zeitzone oder demselben Aktivitätsmuster, um bessere Erfolgsraten bei Raubüberfällen zu erzielen. \nNutzen Sie den gemeinsamen Lagerraum für die Crew, um riskante Güter von Ihrem persönlichen Inventar zu trennen.';

  @override
  String get helpTopicFriendsCategory => 'Sozial';

  @override
  String get helpTopicFriendsTitle => 'Freundinnen';

  @override
  String get helpTopicFriendsSummary =>
      'Verwalten Sie Ihre Freundesliste für eine schnellere Koordination, Profilsuche und soziales Feedback.';

  @override
  String get helpTopicFriendsHow =>
      'Auf der Seite „Freunde“ werden drei Listen angezeigt: aktuelle Freunde, gesendete Anfragen und empfangene Anfragen. \nVon einem Freund aus können Sie direkt eine Nachricht senden, sein Profil anzeigen oder eine Zusammenarbeit starten. \nSie können sehen, wann Freunde im Spiel aktiv sind, was bei der Planung von Raubüberfällen oder Tauschgeschäften hilfreich ist. \nFreundschaftsanfragen verfallen nicht automatisch; Halten Sie die Liste aufgeräumt, damit Sie durch ausstehende Anfragen nicht abgelenkt werden. \nFreunde außerhalb Ihrer Crew sind bei Gefängnisausbrüchen (ein Freund kann Ihnen beim Ausbruch helfen) und dem Informationsaustausch wertvoll. \nWenn ein Freund verhaftet wird, erhalten akzeptierte Freunde jetzt auch eine Push-Benachrichtigung, dass der Spieler im Gefängnis auf Hilfe wartet.';

  @override
  String get helpTopicFriendsTips =>
      'Fügen Sie Freunde hinzu, die Ihren Spielstil teilen: Raubüberfallpartner, Händlernetzwerke oder Kriminalitätsunterstützung. \nEin Freund, der einen Gefängnisausbruch durchführt, erhält bei Erfolg eine Belohnung von 500 bis 2.000 €. Vereinbaren Sie dies für Notfälle.';

  @override
  String get helpTopicMessagesCategory => 'Sozial';

  @override
  String get helpTopicMessagesTitle => 'Nachrichten';

  @override
  String get helpTopicMessagesSummary =>
      'Ihr Posteingang mit persönlichen Spielernachrichten und Systemnachrichten zu Belohnungen, Bestellungen und Spielereignissen.';

  @override
  String get helpTopicMessagesHow =>
      'Die Nachrichten sind in persönliche Gespräche und den The Mob State-Systemthread unterteilt. \nSystemnachrichten werden automatisch gesendet für: Krypto-Trades, Auftragsausführungen, Bestenlisten-Auszahlungen, Raubüberfall-Ergebnisse, Gefängnisausbrüche und Leistungsabzeichen. \nSie können Nachrichten an andere Spieler senden, sofern deren Datenschutzeinstellungen dies zulassen. \nUngelesene Nachrichten werden als Abzeichen auf dem Nachrichtensymbol angezeigt und sind im Dashboard sichtbar. \nNachrichten verfallen nicht und werden als historisches Protokoll der Kontoereignisse gespeichert. \nNutzen Sie das Posteingangsprotokoll, wenn Sie Zweifel an einer Auszahlung, einer versäumten Auftragsausführung oder einer unerwarteten Kontostandsänderung haben.';

  @override
  String get helpTopicMessagesTips =>
      'Überprüfen Sie nach längeren Offline-Zeiten Ihren Posteingang: Dort werden Belohnungen, Auftragsabwicklungen und Ereignisse erfasst. \nKonfigurieren Sie Benachrichtigungseinstellungen über die Einstellungen, sodass Sie Push-Benachrichtigungen nur bei wirklich wichtigen Ereignissen erhalten.';

  @override
  String get helpTopicInventoryCategory => 'Management';

  @override
  String get helpTopicInventoryTitle => 'Inventar';

  @override
  String get helpTopicInventorySummary =>
      'Verwalten Sie alles, was Sie transportieren, lagern und ausrüsten: Waffen, Werkzeuge, Fahrzeuge, Medikamente und Handelswaren.';

  @override
  String get helpTopicInventoryHow =>
      'Das Inventar wird als Papierpuppenansicht geöffnet: Ihr Avatar in der Mitte, ein Kriminalwaffen-Slot und ein Westen-Slot sowie quadratische Rucksack-Slots.\nZiehen Sie ein Element (oder tippen Sie darauf und dann auf ein gültiges Ziel), um es zu verschieben. Auf Telefonen ist das Tippen zum Auswählen zuverlässiger als das Ziehen.\nWenn ein Stapel mehr als eine Einheit enthält (Munition, Materialien, gestapelte Waffen oder Werkzeuge), wählen Sie, wie viele Sie verschieben möchten: 1, alle oder eine benutzerdefinierte Menge.\nDas rechte Raster stellt den aktuellen Kontext dar: ein Haus oder Lagerhaus in diesem Land oder das Materialdepot. Hier springt die Option „Lager öffnen auf einem Grundstück“ mit ausgewähltem Gebäude.\nIn Häusern werden Waffen, Munition, Westen und Bargeld aufbewahrt. Lagerhallen lagern Werkzeuge. Materialien bleiben im Landdepot, nicht in einem Haus. Bargeld verwendet Knöpfe, nicht Ziehen.\nSie können nur eine Weste tragen. Wenn Sie eine Weste auf den Avatar fallen lassen, wird dieser ausgerüstet; Wenn man es in einem Haus lagert, wird es entrüstet. Eine zweite getragene Weste wird abgelehnt.\nDer Platz für die Verbrechenswaffe bleibt mit dem Bildschirm „Verbrechen“ synchronisiert. Es zählen nur getragene, verwendbare Waffen.\nDie Kapazität des Rucksacks deckt Werkzeuge, Waffen und mitgeführte Materialien ab. Munition und die getragene Weste belegen keine Rucksackplätze. Der Server lehnt volle Pakete, falsches Land und falschen Eigenschaftstyp ab.\nLoadouts bleiben eine zweite Registerkarte für gespeicherte Kriminal- oder Reisesets.\nMedikamente werden gespeichert und in Gramm angezeigt; 351 bedeutet 351g. Der Mannschaftsraum bleibt ein separater, sicherer Versteck.\nBei einer Festnahme kann die Polizei Gegenstände beschlagnahmen. Drogen im Inventar erhöhen das FBI-Risiko auf internationalen Reisen.';

  @override
  String get helpTopicInventoryTips =>
      'Halten Sie Ihr Gepäck leicht, wenn Sie reisen oder eine Kriminalitätstour mit hohem Festnahmerisiko durchführen. \nVerwenden Sie Loadouts, damit Sie für jedes Szenario immer die richtige Ausrüstung haben. \nÜberprüfen Sie regelmäßig den Zustand des Artikels: Defekte Werkzeuge blockieren stillschweigend Straftaten ohne eindeutige Fehlermeldung.';

  @override
  String get helpTopicPropertiesCategory => 'Wirtschaft';

  @override
  String get helpTopicPropertiesTitle => 'Eigenschaften';

  @override
  String get helpTopicPropertiesSummary =>
      'Kaufen Sie Immobilien, um den Lagerraum, die Wohnkapazität und den Zugang zu bestimmten Systemen wie dem Nightclub zu erweitern.';

  @override
  String get helpTopicPropertiesHow =>
      'Jede Immobilie hat ihre eigene Rolle: Lagerraum, Wohnkapazität oder Zugang zu einem Folgemodul wie dem Nightclub.\nLager-Upgrades erhöhen Ihre Lagerkapazität für Artikel und andere Bestände.\nHäuser lagern Waffen, Munition, Westen und Bargeld; Lagerhallen lagern Werkzeuge. Wenn Sie „Lager“ in einem Haus oder Lagerhaus öffnen, wird die Inventar-Papierpuppe mit dem ausgewählten Gebäude geöffnet. Sie müssen sich im selben Land befinden.\nHäuser und Wohnungen erhöhen die Wohnkapazität; VIP-Spieler erhalten darüber hinaus zusätzliche Slots.\nEinige Immobilien sind einzigartig oder länderspezifisch: Sie müssen sich im richtigen Land befinden, um sie zu kaufen oder zu verwalten.\nDie Verkaufsrendite beträgt 70 % des Kaufpreises. Beim Verkauf gibt es keine Abklingzeit, der Verkauf erfolgt sofort.\nEin gekaufter Nightclub öffnet den separaten Nightclub-Verwaltungsbildschirm; Dieses Modul kümmert sich um die Verwaltung und den Umsatz, nicht um die Immobilienübersicht.\n„Entwickeln“ gibt Bankgelder aus: Jede Stufe erhöht dauerhaft das passive Einkommen dieser Immobilie (maximale Stufe und Abklingzeit sind serverabhängig).';

  @override
  String get helpTopicPropertiesTips =>
      'Investieren Sie frühzeitig in ein Lager, wenn Sie mehr Lagerraum für Ihre anderen Systeme benötigen. \nWählen Sie Häuser und Wohnungen, wenn Sie mehr Wohnkapazität für zugehörige Spielsysteme schaffen möchten. \nVerkaufen Sie nicht zu schnell: 70 % bedeuten einen erheblichen Abschlag vom Kaufpreis.';

  @override
  String get helpTopicBankCategory => 'Wirtschaft';

  @override
  String get helpTopicBankTitle => 'Bank';

  @override
  String get helpTopicBankSummary =>
      'Zahlen Sie Arbeitsgeld bis zu einer Tagesobergrenze kostenlos ein. Größeres Straßengeld muss mit einer Gebühr, Verzögerungen und dem Risiko einer Beschlagnahmung durch das FBI gewaschen werden.';

  @override
  String get helpTopicBankHow =>
      'Kostenlose Einzahlungen erfolgen sofort und sind gebührenfrei, jedoch nur bis zu einer Tagesobergrenze, die mit Ihrem Rang (UTC-Tag) skaliert. Abhebungen bleiben kostenlos und unbegrenzt. Über „Verbleibend füllen“ geben Sie die heutige verbleibende Quote ein. Wenn die Kappe aufgebraucht ist, wird auf dem Bildschirm der Countdown bis 00:00 UTC angezeigt.\nPassive Bankzinsen sind derzeit deaktiviert.\nDas Geld auf der Bank ist vor polizeilichen Beschlagnahmungen geschützt. Bei der Festnahme kann nur Bargeld verloren gehen.\nDer Transaktionsverlauf zeigt alle ein- und ausgehenden Bewegungen mit Zeitstempel, Betrag, Überweisungsgegenpartei und optionalen Beschreibungen.\nGeldwäsche: Waschen Sie Bargeld, das über der kostenlosen Tagesobergrenze liegt, gegen eine Gebühr und mit Verzögerung auf Ihr Bankkonto. Für jeden Waschgang gibt es ein Minimum und ein Maximum, die auf dem Bankbildschirm angezeigt werden. Höhere FBI-Hitze erhöht die Chance auf eine Beschlagnahmung; Erfolg senkt die Hitze etwas.\nBankraubkriminalität: Erfolgt bei 30 % und stiehlt 10–30 % des Bankguthabens eines zufälligen anderen Spielers. Hohes Wanted-Level-Risiko.\nEine Geldüberweisung an andere Spieler ist möglich. Optional können Sie eine Beschreibung hinzufügen, die dem Empfänger auch in Transaktionen angezeigt wird. Überprüfen Sie vor der Bestätigung sowohl den Betrag als auch den Empfänger.';

  @override
  String get helpTopicBankTips =>
      'Nutzen Sie die kostenlose tägliche Einzahlung für kleine Arbeitsgelder, damit diese vor der Beschlagnahmung geschützt sind.\nWaschen Sie größeres Straßengeld, wenn Sie die Gebühr akzeptieren und das Risiko übernehmen. Niedrigere Hitze ist sicherer.\nHalten Sie ein kleines Betriebskapital als Bargeld für direkte Ausgaben (Kaution, Reisen, Werkzeuge) bereit.';

  @override
  String get helpTopicCasinoCategory => 'Wirtschaft';

  @override
  String get helpTopicCasinoTitle => 'Kasino';

  @override
  String get helpTopicCasinoSummary =>
      'Setzen Sie Bargeld auf Slots, Blackjack, Roulette, Würfel, Baccarat und Videopoker. Das Haus hat drei Etagen (Public/VIP/Private) mit sichtbarem Rake und Maximaleinsatz. Hohe Varianz.';

  @override
  String get helpTopicCasinoHow =>
      'Verfügbare Spiele: Slots, Blackjack, Roulette, Würfel, Baccarat und Videopoker.\nJeder Tisch nutzt den Maximaleinsatz der Etage und einen sichtbaren Rake, der in der Owner-Bankroll bleibt.\nPublic / VIP / Private erhöhen Einsatzlimit und House-Rake. Besitzer stellen je einen Dealer, Security und Promoter ein. Dealer erhöht den Rake leicht; Promoter erhöht Max-Einsatz und Heat; Security senkt den casino_ledger_raid-Abfluss.\nGehälter kommen aus der Bankroll pro Game-Tick. Zu niedrig: der günstigste Hire fliegt.\nEin erfolgreicher Crew-casino_ledger_raid zieht Prozent von der Bankroll im Startland des Runs. Die Crew-Cash-Belohnung bleibt; das ist Extra-Druck, kein zweiter Cash-Print.\nNur Bargeld, kein Bankguthaben. Verlorene Einsätze sind weg.';

  @override
  String get helpTopicCasinoTips =>
      'Setzen Sie ein Session-Limit: nie mehr als 10% Ihres Bargelds.\nBlackjack hat die besten Chancen für Könner.\nBesitzer: Bankroll über €10.000 halten und Security holen, bevor rivalisierende Crews Ledger-Raids freischalten.\nCasino ist Unterhaltung — der House Edge gewinnt langfristig.';

  @override
  String get helpTopicBlackMarketCategory => 'Wirtschaft';

  @override
  String get helpTopicBlackMarketTitle => 'Schwarzmarkt';

  @override
  String get helpTopicBlackMarketSummary =>
      'Ein Hub: Zuerst Schmuggelwaren (Blumen, Elektronik, Diamanten, Waffen, Arzneimittel), dann die Registerkarte „Marktplatz“ für Spieler-zu-Spieler-Fahrzeuge, mitgeführte Werkzeuge, Drogenposten, Krypto-Lots, Handelswarenstapel und übertragbare Eventgegenstände sowie Rucksäcke, Materialien, Waffenmarkt und Munition.';

  @override
  String get helpTopicBlackMarketHow =>
      'Registerkarte „Handelswaren“: eine fortlaufende Schriftrolle – zuerst die fünf Schmuggellinien (Preise, Obergrenzen, Risikochips: Verderb, Volatilität, Reiseschaden, Beschlagnahme), dann Ihr Inventar, von dem aus verkauft werden soll. Kaufen/Verkaufen verwendet die /trade-API; Bei Teillastausfällen wird ein Warnbanner angezeigt. \nDer Schwarzmarkt ist in Teilmärkte unterteilt: Materialien (Rohstoffe), Waffen (Schusswaffen und Messer), Munition (Munition pro Kaliber), Fahrzeuge (illegale Fahrzeuge). \nPreise und Verfügbarkeit variieren stark je nach Land und Zeit. Ein Angebot kann schnell ausverkauft sein. \nSchwarzmarkttransaktionen hinterlassen keine offiziellen Spuren, erhöhen aber den Druck des FBI auf große Einkäufe. \nHier gekaufte Waffen können für Verbrechen, PvP und Sicherheit verwendet werden. Bessere Waffen erhöhen den Schaden und die Erfolgschance. \nFilter nach Kategorie (Typ, Land, Preis, Verfügbarkeit) helfen Ihnen, schnell das richtige Angebot zu finden. \nSie können als Verkäufer Ihre eigenen Angebote veröffentlichen, einschließlich Preis und Menge. Andere Spieler kaufen bei Ihnen. \nAngebote verfallen nach einer bestimmten Zeit, wenn sie nicht verkauft werden. Überwachen Sie Ihre eigenen Angebote über Ihr Profil. \nRegisterkarte „Marktplatz“: Peer-to-Player-Cash-Trades. Ein Feed zeigt Fahrzeuge und Spielerlisten für mitgeführte Werkzeuge, Medikamentenstapel (Gramm + Qualität), Kryptobestände und Handelswarenbestand. Verwenden Sie „Verkaufen“, um eine Sorte auszuwählen, die Menge und den Preis festzulegen. Meine Einträge umfassen Ihre aktiven Anzeigen. Sie können keine eigene Anzeige kaufen. Treuhandkonto entfernt Lagerbestände bis zum Kauf oder Delisting.';

  @override
  String get helpTopicBlackMarketTips =>
      'Registerkarte „Handel“: Zum Aktualisieren ziehen, wenn ein Segment ausfällt; Achten Sie auf Risikochips und Fahndung vor riskanten Schmuggelfahrten. \nKaufen Sie Waffen und Munition in großen Mengen, wenn die Preise niedrig sind: Die Verfügbarkeit ist nur vorübergehend. \nVermeiden Sie große Schwarzmarktkäufe, wenn der FBI Heat bereits über 30 liegt. \nMarktplatz: Nach Listung aktualisieren; Listen Sie nur auf, was Sie besitzen – Werkzeuge müssen mitgeführt werden, Medikamente/Kryptowährungen/Handelswaren stammen aus Ihrem Inventar/Beständen. Delist stellt Treuhandkonto wieder her.';

  @override
  String get helpTopicDrugsCategory => 'Reich';

  @override
  String get helpTopicDrugsTitle => 'Drogen';

  @override
  String get helpTopicDrugsSummary =>
      'Bauen Sie einen kompletten Arzneimittelbetrieb vom Rohstoff bis zum fertigen Produkt auf. Betreiben Sie Produktionsketten, verwalten Sie die Lagerung und verkaufen Sie mit hohen Margen, aber großen Risiken.';

  @override
  String get helpTopicDrugsHow =>
      'Das Arzneimittelsystem besteht aus: Hub (Übersicht und Statistiken), Einrichtungen (Produktionskapazität verbessern), Produktion (aktive Produktionslinien mit Timer) und Inventar (Fertigprodukte und Rohstoffe). \nKaufen Sie Rohstoffe auf dem Schwarzmarkt oder im Handel. Kombinieren Sie sie in einer Anlage zur Herstellung von Medikamenten. \nProduktionstimer laufen, während Sie offline sind. Kein aktives Klicken erforderlich: Überprüfen Sie es noch einmal, wenn der Timer abgelaufen ist. \nDie fertige Produktion bleibt in der Produktion sichtbar und der Anlagenplatz bleibt besetzt, bis Sie sie abholen. VIP Auto-Collect verarbeitet die fertige Ausgabe automatisch im Hintergrund. \nDie Lagerkapazität ist pro Einrichtung begrenzt. Wenn der Speicher voll ist, stoppt die Produktion automatisch. \nEine Darkweb-Storefront oder eine andere Einrichtung verkauft fertige Produkte nicht automatisch: Der Verkauf erfolgt immer noch manuell über den vorgesehenen Verkaufsablauf. \nVerkaufen Sie Medikamente mit höchster Marge über den Schwarzmarkt, Kolumbien oder andere spezielle Verkaufsstandorte. \nFBI Heat steigert jeden Produktionszyklus und bei großen Verkäufen zusätzlich. Hohe Hitze führt zu Überfällen, die Ihren Betrieb lahmlegen können. \nAnlagenmodernisierungen verkürzen die Produktionszeit, steigern die Produktion und erweitern die Lagerkapazität. \nVIP-Spieler erhalten einen Blitzknopf auf Produktionskarten: Nach einem Bestätigungsmodalitäten können Sie alle fehlenden Chargenmaterialien mit einem Klick kaufen. \nFortgeschrittene Slot- und Ausrüstungs-Upgrades sind mit dem neuen Narkotik-Ausbildungspfad (Hydroponik-Spezialist, Prozess-Elektrik-Spezialist, Geheimchemiker) verbunden. Ohne die erforderliche Stufe/Zertifizierung können Sie nicht zur nächsten Upgrade-Stufe aufsteigen. \nDrogen im Inventar erhöhen das Beschlagnahmungsrisiko bei Reisen und Polizeikontrollen.\nÜber das Inventar kannst du eine Großhandelsladung in ein anderes Land exportieren: du bleibst, zahlst Fracht und erhältst B2B-Cash am Ziel, wenn der Container ankommt. Bei Beschlagnahme kein Geld. Straßenverkauf, Nachtclub, Darkweb und Marktplatz bleiben Einzelhandel.';

  @override
  String get helpTopicDrugsTips =>
      'Erweitern Sie den Speicher vor der Produktion: Voller Speicher stoppt die Produktion und Sie verlieren Produktionszeit. \nHalten Sie die FBI-Hitze unter 50: Oberhalb dieses Schwellenwerts werden Sie aktiv gejagt, mit hohen Angriffschancen, die alles zum Erliegen bringen. \nKombinieren Sie Arzneimittelverkäufe mit Schmuggel, um höhere Margen und eine Risikoverteilung zu erzielen.\nExportiere nur, wenn du Fracht und Beschlagnahme akzeptierst; Reisen plus Straßenverkauf bleibt pro Gramm mehr wert.';

  @override
  String get helpTopicNightclubCategory => 'Reich';

  @override
  String get helpTopicNightclubTitle => 'Nachtclub';

  @override
  String get helpTopicNightclubSummary =>
      'Betreiben Sie einen Nightclub als Teil Ihres kriminellen Imperiums. Verwalten Sie Personal, Sicherheit und Versorgung für passives und aktives Einkommen mit einer speziellen Saison-Rangliste.';

  @override
  String get helpTopicNightclubHow =>
      'Unten nutzen Sie jetzt ein Nightclub-Management-Kommandozentrum mit Zonen für Crew, Drogenlager, DJ-Kommando, Sicherheitseinheit und Operationslabor; Alle Zonen werden in einem kontinuierlichen Seitenfluss ohne zusätzlichen inneren Bildlauf ausgeführt. \nDer Nightclub-Bildschirm enthält jetzt einen zentralen Intelligence-Bereich, der Übersicht, Umsatztrends und Risikoprotokolle ohne Tab-Wechsel vereint. \nOps Lab umfasst jetzt 11 Systeme: Resident-DJ, dynamischer Veranstaltungskalender, Upgrade-Baum, polizeiliche Reaktion auf Hitze und Vorfälle, Lieferantenverträge, Veranstalterprofile, VIP-Kundschaft + Personalmerkmale, Schmuggelrouten, Bar- und Küchenmanagement (Getränke/Essen) mit Preisen, Konkurrenzsabotage + Gegenspionage und einen Betriebszeitplan. \nSchmuggelrouten haben jetzt eine Abklingzeit (Hafen 60 Min., Landebahn 90 Min., Grenzlinie 120 Min.), was eine Risiko-/Zeitplanung anstelle von unendlichem Spam erzwingt. \nDer Upgrade-Baum ist interaktiv: Wählen Sie explizit Sound Rig, VIP Lounge oder Surveillance und kaufen Sie direkt das nächste Level mit sichtbaren Upgrade-Kosten. \nDer Umsatz wird pro Tick basierend auf DJ-Qualität, Auslastung und Verfügbarkeit generiert. Fehlendes Angebot schmälert direkt das Einkommen. \nDJ-Verträge enden automatisch zum konfigurierten Endzeitpunkt; Danach müssen Sie für neue Boosts erneut buchen. \nBei unzureichender Sicherheit kann es zu Zwischenfällen (Kämpfe, Diebstähle) kommen. Dies beeinträchtigt den Besucher-Score und das Einkommen. \nJede Saison hat eine Bestenliste. Spieler mit den höchsten Gesamteinnahmen im Nightclub gewinnen Saisonbelohnungen. \nSynergie mit Arzneimitteln: Die eigene Arzneimittelproduktion kann als Versorgung dienen und die Margen erhöhen. \nDie Medikamentenlagerung erfolgt grammbasiert: Bei jeder Auswahl werden die verfügbaren Gramm angezeigt, bevor Sie den Bestand in den Nachtclubbestand verschieben. \nRivalisierende Aktionen basieren auf Namen: Sie suchen rivalisierende Vereine nach Spielernamen, bevor Sie eine Aktion auswählen (keine Spieler-ID erforderlich). \nSynergie mit Prostitution: Kombinierte Veranstaltungsorte sorgen für mehr Besucher und höhere Einnahmen. \nUpgrades verbessern die Kapazität, den Vorratsspeicher und die maximale Anzahl an DJs und Wachen, die Sie einsetzen können.';

  @override
  String get helpTopicNightclubTips =>
      'Halten Sie stets Vorräte bereit: Ein Tick ohne Vorrat kann einen Besucherrückgang auslösen, von dem Sie sich nur schwer erholen können. \nBuchen Sie den besten DJ, den Sie sich leisten können: Die DJ-Qualität hat den größten direkten Einfluss auf den Umsatz pro Tick. \nSehen Sie sich täglich die Bestenliste der Saison an und erhöhen Sie das Angebot und die DJs, wenn Sie unter den Top 10 landen möchten.';

  @override
  String get helpTopicCryptoCategory => 'Wirtschaft';

  @override
  String get helpTopicCryptoTitle => 'Krypto';

  @override
  String get helpTopicCryptoSummary =>
      'Handeln Sie mit 30 echten Kryptowährungen. Kaufen und verkaufen Sie direkt oder automatisieren Sie über Limit-, Stop-Loss- und Take-Profit-Orders. Die Preise folgen jetzt den Live-Marktankern mit zusätzlichen Spielregimen und Neuigkeiten, und das Münz-Popup verwendet separate Felder für direkte Geschäfte und offene Aufträge.';

  @override
  String get helpTopicCryptoHow =>
      'Die Kryptoliste zeigt 30 Coins mit aktuellem Preis, 24-Stunden-Prozentsatz und Ihrem aktuellen Bestand pro Coin. Die Preisbasis folgt Live-Marktdaten, wird aber dennoch von Spielregimen und Nachrichten beeinflusst. \nKlicken Sie auf eine Münze, um das Popup mit Live-Chart (Zeitfilter 1h, 4h, 8h, 24h, 7d, 30d, Alle), Kaufhistorie, durchschnittlichem Kaufpreis und Kauf-/Verkaufsformular zu öffnen. \nDirekter Handel: Geben Sie die Menge ein und klicken Sie auf Kaufen oder Verkaufen. Beim Verkauf können Sie auf „ALLE“ klicken, um Ihre Position sofort vollständig zu besetzen. Die Ausführung erfolgt sofort zum aktuellen Marktpreis. \nOffene Aufträge: Limit (Kauf/Verkauf zu einem genauen Zielpreis), Stop-Loss (automatischer Verkauf, wenn der Preis auf einen Schwellenwert fällt), Take-Profit (automatischer Verkauf, wenn der Preis auf einen Zielwert steigt). Dieser Abschnitt verfügt nun über ein eigenes Mengenfeld und ein eigenes Richtpreisfeld. \nOffene Aufträge werden vom Backend automatisch ausgeführt, sobald der Marktpreis das Ziel erreicht. Sie müssen nicht online sein. \nMarktregime (Bull/Bear/Seitwärts) und Nachrichtenereignisse beeinflussen Preisbewegungen. Bei Aktivierung erhalten Sie Regimebenachrichtigungen per Push. \nWöchentliche Krypto-Rangliste: Der Spieler mit dem höchsten realisierten Gewinn in dieser Woche gewinnt eine Geldprämie. \nTägliche und wöchentliche Missionen (z. B. 3 profitable Trades, Diversifizierung auf 5 Münzen) gewähren bei Abschluss zusätzliche Belohnungen. \nDie Portfolioübersicht zeigt: Gesamtwert, investierter Betrag, nicht realisierter und realisierter Gewinn/Verlust.';

  @override
  String get helpTopicCryptoTips =>
      'Überprüfen Sie Ihre Kaufhistorie, bevor Sie einen Verkaufsauftrag erteilen: Das Popup zeigt Ihren durchschnittlichen Kaufpreis an, damit Sie nicht versehentlich mit Verlust verkaufen. \nVerwenden Sie Stop-Loss-Orders für jede Position, die Sie nicht aktiv beobachten: Sie schützen Sie automatisch, wenn Sie offline sind. \nWechseln Sie die Zeitfilter im Diagramm: 1h und 4h zeigen den kurzfristigen Trend, 7d und 30d zeigen das Gesamtbild.';

  @override
  String get helpTopicSmugglingCategory => 'Reich';

  @override
  String get helpTopicSmugglingTitle => 'Schmuggel';

  @override
  String get helpTopicSmugglingSummary =>
      'Bewegen Sie illegale Waren und Fahrzeuge zwischen Ländern. Wählen Sie einen kommerziellen Kanal oder nutzen Sie Ihr eigenes Fahrzeug oder Flugzeug, um die Kosten zu senken und das Risiko einer Beschlagnahme zu erhöhen.';

  @override
  String get helpTopicSmugglingHow =>
      'Wählen Sie eine Kategorie, den spezifischen Artikel, das Ziel und entscheiden Sie sich dann zwischen einem kommerziellen Kanal oder Ihrem eigenen Transport. \nFür eigene Autos, Motorräder, Boote und Flugzeuge wird jetzt ein Live-Angebot mit Frachtplätzen, geringeren Kosten und Risikominderung angezeigt. \nEin Boot kann Autos und Motorräder transportieren; Ein Flugzeug kann kein Boot transportieren und gibt sofort einen Fehler zurück. \nDie Erfolgsaussichten hängen vom ausgewählten Kanal oder eigenen Transportmittel, Ihrem aktuellen Wanted-Level und der Sendungsgröße ab. \nBei einem Misserfolg verlieren Sie die gesamte Sendung. Keine Rückerstattung. Fracht- und Transportkosten entfallen. \nWenn Sie eigene Transportmittel nutzen und die Fahrt fehlschlägt, kann auch das Transportgut selbst beschlagnahmt werden. \nAktive Sendungen werden in einer Übersicht live verfolgt. Nach der Ankunft steht die Ladung in einem Depot zur Abholung bereit. \nDas Crew-Netzwerk steht weiterhin für kommerzielle Crew-Transporte zur Verfügung, der eigene Transport erfolgt jedoch nur für Privatpersonen.';

  @override
  String get helpTopicSmugglingTips =>
      'Versenden Sie niemals Ihren gesamten Lagerbestand in einer Sendung: Teilen Sie ihn auf mehrere kleinere Ladungen auf, um katastrophale Verluste zu begrenzen. \nSenken Sie die Fahndungsstufe und die FBI-Hitze auf ein Minimum, bevor Sie eine große Schmuggeltour starten. \nNutzen Sie Ihr bestes Flugzeug oder Boot für teure Fahrten: Niedrigere Kosten helfen, aber Frachtplätze und Beschlagnahmungschancen entscheiden immer noch über das Risiko. \nSammeln Sie aktive Depots immer so schnell wie möglich ein: Abgelaufene Depotinhalte gehen dauerhaft verloren.';

  @override
  String get helpTopicToolsCategory => 'Management';

  @override
  String get helpTopicToolsTitle => 'Werkzeuge';

  @override
  String get helpTopicToolsSummary =>
      'Kaufen und verwalten Sie die für bestimmte Straftaten erforderlichen Werkzeuge. Gute Werkzeuge erhöhen Ihre Erfolgschancen, abgenutzte Werkzeuge verringern sie.';

  @override
  String get helpTopicToolsHow =>
      'In der Werkzeugwerkstatt werden alle verfügbaren Artikel mit Preis, Zustandsbewertung und der Kriminalitätsart angezeigt, für die sie benötigt werden. \nJede Kriminalitätskategorie hat bevorzugte Werkzeuge: Einbruch erfordert Brecheisen oder Spitzhacken, Autodiebstahl erfordert ein Hitzdrahtset, Raubüberfall erfordert eine Schusswaffe. \nWerkzeuge haben eine Zustandsbewertung (0-100 %). Jedes erfolgreiche oder misslungene Verbrechen senkt den Zustand um ein paar Prozent. \nBei einer Bedingung unter 20 % sinkt der Erfolgschancenbonus des Tools drastisch. Unter 5 % hat das Mittel nahezu keine Wirkung. \nReparierte Werkzeuge über die Werkstatt kosten einen Bruchteil des Kaufpreises. Bei stark verschlissenen Werkzeugen ist der Austausch manchmal günstiger als die Reparatur. \nWerkzeuge sind auf der Registerkarte „Inventar“ sichtbar. Sie können mehrere Kopien desselben Typs als Backup aufbewahren.';

  @override
  String get helpTopicToolsTips =>
      'Kaufen Sie Werkzeuge in großen Mengen, wenn sie auf dem Schwarzmarkt günstig sind: Sie sparen im Vergleich zum Laden. \nLegen Sie einen persönlichen Schwellenwert fest: Ersetzen Sie Werkzeuge immer, wenn der Zustand unter 25 % fällt, um die Erfolgsaussichten stabil zu halten.';

  @override
  String get helpTopicCourtCategory => 'Risiko';

  @override
  String get helpTopicCourtTitle => 'Gericht';

  @override
  String get helpTopicCourtSummary =>
      'Während Ihrer Haftstrafe können Sie Berufung einlegen oder versuchen, den Richter zu bestechen, um schneller freigelassen zu werden.';

  @override
  String get helpTopicCourtHow =>
      'Wenn Sie inhaftiert sind, zeigt der Gerichtsbildschirm Ihre aktive Verurteilung mit der verbleibenden Zeit, der Straftat und dem Richterprofil an. \nEine Berufung kostet Geld, basierend auf Ihrer aktuellen Straflänge. Im Falle einer Bewilligung wird Ihre Strafe in der Regel um etwa 20–40 % gekürzt. \nSie können pro Verurteilung nur einmal Berufung einlegen und bei schnellen Wiederholungsversuchen gilt eine Abklingzeit. \nFür Bestechung wird ein vom Spieler ausgewählter Betrag verwendet. Dieser Betrag wird immer abgezogen, auch wenn der Versuch fehlschlägt. \nEine höhere Bestechungssumme erhöht die Erfolgsaussichten. Bei Erfolg werden Sie sofort entlassen. \nIn Ihrem Strafregister werden frühere Verurteilungen mit Datum und Einzelheiten zur Gerichtsgeschichte gespeichert, auch wenn Sie nicht mehr inhaftiert sind. \nBei einer erfolgreichen Richterbestechung wird nur die aktuelle Verurteilung aus Ihrem Strafregister entfernt. \nWenn Sie Ihr gesamtes Vorstrafenregister löschen möchten, müssen Sie dies außerhalb des Gerichts über die Late-Game-Straftat „Wipe Criminal Record“ tun.';

  @override
  String get helpTopicCourtTips =>
      'Setzen Sie Einsprüche zunächst bei langen Sätzen ein: Dort ist die erwartete Zeitersparnis am höchsten. \nSetzen Sie Bestechung nur bei ausreichendem Bargeldpolster ein, da die Zahlung immer abgezogen wird.';

  @override
  String get helpTopicHitlistCategory => 'Risiko';

  @override
  String get helpTopicHitlistTitle => 'Hitliste';

  @override
  String get helpTopicHitlistSummary =>
      'Setze ein Kopfgeld auf einen Feind aus oder akzeptiere einen Trefferauftrag. Eliminieren Sie Ihr Ziel im selben Land, um die volle Auszahlung zu erhalten.';

  @override
  String get helpTopicHitlistHow =>
      'Über die Trefferliste fügen Sie einen Spieler hinzu, indem Sie ein Kopfgeld festlegen. Das Mindestprämie beträgt 5.000 €. Der Zahler verliert dieses Geld sofort. \nWenn ein Kopfgeld auf Sie ausgesetzt wird, erhalten Sie sofort eine Push-Benachrichtigung und eine Posteingangsnachricht vom Hitlist Bureau. \nAktive Treffer sind für alle Spieler sichtbar. Je höher die Prämie, desto mehr Aufmerksamkeit erregt der Vertrag. \nDetektivuntersuchungen liefern keine sofortigen Informationen mehr: Berichte kommen später über eine Nachricht des Detektivbüros an (Schnell 1 Stunde 1.000.000 €, Standard 6 Stunden 500.000 €, Langsam 24 Stunden 250.000 €). Gezielte Leibwächter können diesen Bericht trüben oder blockieren: Schnell lässt sich leicht stoppen. Slow verliert immer das Land, selbst gegen ein komplettes Eliteteam. Nach 48 Stunden offline wird die Deckung schwächer; Nach 7 Tagen ist der Bericht fertig. Nach einem Mord verringern die Leibwächter des Mörders auch die Chance, dass ein Kriminalbeamter ihn benennt, bis er für längere Zeit offline bleibt. \nWenn Sie über die Hitlist getötet werden, erhalten Sie eine Nachricht des Hitlist Bureau mit einer Schaltfläche, mit der Sie innerhalb von 24 Stunden eine Mordermittlung einleiten können. \nWenn Sie diese Untersuchung zeitnah nach dem Mord anfordern, kommt der Kriminalbericht schneller an. Längeres Warten bedeutet eine längere Berichtsverzögerung. \nUm einen Treffer auszuführen, müssen Sie sich im selben Land wie Ihr Ziel befinden. Sie greifen über das Spielerprofil an. \nDer Kampf wird automatisch berechnet, basierend auf: Waffen, Rüstung, Statistiken (Stärke, Reflexe), Besatzungsboni und aktivem Level. \nBei erfolgreicher Eliminierung erhalten Sie das volle Kopfgeld, können aber trotzdem HP, Leibwächter und Westenzustand verlieren. Wenn der Angriff fehlschlägt, bleibt der Vertrag offen: Beide Seiten verlieren Leibwächter und HP, und Sie können es nach 10 Minuten erneut versuchen. \nBei einem erfolgreichen Treffer erhält das Ziel einen harten Kontofortschritts-Reset: Vermögenswerte und Fortschritt werden auf den Ausgangsstatus zurückgesetzt, während Bankguthaben und Besatzungsführung erhalten bleiben. Zusätzlich zum Kopfgeld erhältst du einen Anteil der verfügbaren Beute. \nNach einem erfolgreichen Kill erhalten Sie sofort eine Posteingangsnachricht vom Hitlist Bureau mit einer Aufschlüsselung des Kopfgeldes und der Beute (Bargeld + Gegenstände). \nZiele mit aktivem Leibwächter oder Sicherheitsschutz sind schwerer zu treffen. \nSie können Ihren eigenen Namen von der Trefferliste entfernen, indem Sie den Placer bezahlen oder das Kopfgeld selbst auszahlen.';

  @override
  String get helpTopicHitlistTips =>
      'Überprüfen Sie täglich die Trefferliste: Hohe Kopfgelder auf schwache Spieler sind ein schneller Gewinn, wenn Sie im selben Land sind. \nSetzen Sie einem Spieler nur dann ein Kopfgeld aus, wenn Sie Grund zu der Annahme haben, dass er offline ist oder nur noch wenige HP hat. \nÜberspringen Sie günstige Quick-Informationen, wenn das Ziel über Elite-Leibwächter verfügt und in letzter Zeit gespielt hat. Ein Slow-Bericht zeigt immer das Land. Ein maximaler Panzer fällt selten auf einmal: Ein misslungener Treffer verringert immer noch die Wachen und HP auf beiden Seiten, und Sie können es nach 10 Minuten erneut versuchen.';

  @override
  String get helpTopicSecurityCategory => 'Risiko';

  @override
  String get helpTopicSecurityTitle => 'Sicherheit';

  @override
  String get helpTopicSecuritySummary =>
      'Schützen Sie Ihren Charakter und Ihr Imperium mit Rüstungen, Leibwächtern und Installationssicherheit. Höhere Sicherheit bedeutet weniger Schaden bei Angriffen.';

  @override
  String get helpTopicSecurityHow =>
      'Kaufen Sie Westen auf dem Schwarzmarkt → Sicherheit: Stichweste (7.500 €) → Kugelsichere Weste (50.000 €) → Premium kugelsichere Weste (125.000 €) → AP-Plattenweste (280.000 €). Die Gewehrkaliber 5,56, 7,62 und .308 durchdringen normale Westen, es sei denn, Sie tragen die AP-Plattenweste. \nSie können jeweils nur eine Weste tragen. Eine beschädigte Weste kann für die Hälfte des fehlenden Wertes repariert werden. Beim Kauf einer weiteren Weste wird die aktuelle Weste ersetzt und 40 % des alten Westenpreises, gestaffelt nach Zustand, gutgeschrieben. \nJeder Westentyp reduziert den eingehenden Schaden, wenn er zum Angriff passt: Stichwesten halten Messer ab, kugelsichere Westen halten normale Kugeln ab und die AP-Plattenweste stoppt auch panzerbrechende Geschosse. Bei einer Nichtübereinstimmung bleibt nur ein Bruchteil der Westenverteidigung erhalten. \nDie Rüstung wird nach einem Angriff beschädigt und verliert an Wirksamkeit. Je niedriger der Zustand, desto weniger Schutz bietet Ihre aktuelle Rüstung. \nBei einem Zustand von 0 % wird Ihre Rüstung zerstört und verschwindet vollständig; Sie müssen ein neues Set kaufen, um den Schutz wiederherzustellen. \nDie Zahl der Leibwächter ist insgesamt auf 10 in drei Qualitäten begrenzt: Street Muscle (+8 Verteidigung, 6.000 € Miete, 4.000 €/Tag), Standard (+10, 10.000 € Miete, 10.000 €/Tag) und Elite (+22, 35.000 € Miete, 18.000 €/Tag). Sie können sie jederzeit abweisen. \nWenn Sie den kombinierten Tageslohn nicht bezahlen können, gehen alle Leibwächter weg und Sie verlieren sofort ihren Schutz. \nWeste und Leibwächter reduzieren außerdem den kriminellen HP-Verlust (bei jedem Versuch etwa die Hälfte). Ein gescheiterter Mordversuch lässt Leibwächter und Ihre HP fallen und trägt Ihre Weste; Der Vertrag bleibt offen. Laut Detektivberichten können Leibwächter den Standort und die Stärke verbergen, während Sie kürzlich gespielt haben. Slow lässt immer das Land durchsickern, und nach einer Woche offline fällt die Abdeckung ab. Sie ersetzen nicht den Nightclub-, Rotlicht- oder Geländeschutz. \nDie Sicherheit von Installationen (für Nachtclubs, Drogeneinrichtungen usw.) verringert die Wahrscheinlichkeit von Überfällen und Zwischenfällen an diesem bestimmten Ort. \nJe höher Ihr Wanted-Level, desto häufiger werden Sie angegriffen oder überfallen. Eine bessere Sicherheit kompensiert dies direkt. \nBesatzungsmitglieder können ihre Sicherheitsrollen aufteilen, sodass mehrere Standorte gleichzeitig abgedeckt werden.';

  @override
  String get helpTopicSecurityTips =>
      'Tragen Sie bei Wanted Level 2 oder höher immer mindestens eine Stichweste: Einsparungen bei den Krankenhausrechnungen gleichen den Kaufpreis schnell aus. \nReparieren Sie eine beschädigte Weste, anstatt dieselbe noch einmal zu kaufen; Überprüfen Sie den Zustand nach jedem Angriff. \nGewehrmunition (5,56, 7,62, .308) durchschlägt normale Westen; Kaufen Sie die AP-Plattenweste, wenn diese Kaliber gegen Sie auftauchen. \nBehalten Sie nur so viele Leibwächter, wie Sie sich morgen noch leisten können; Elitewächter sind am härtesten betroffen, aber ihr Tageslohn summiert sich schnell. \nLeibwächter verbergen Ihr Land nicht, wenn Sie eine Woche lang offline bleiben; Langsam leckt das Land sowieso.';

  @override
  String get helpTopicHospitalCategory => 'Erholung';

  @override
  String get helpTopicHospitalTitle => 'Krankenhaus';

  @override
  String get helpTopicHospitalSummary =>
      'Stellen Sie HP nach Kämpfen, gescheiterten Verbrechen oder Überfällen wieder her. Das Krankenhaus bietet kostenlose Notfallversorgung und kostenpflichtige Behandlungen für eine schnellere Genesung.';

  @override
  String get helpTopicHospitalHow =>
      'Wenn Sie unter 10 HP fallen, werden Sie automatisch in die Notaufnahme (ER) eingeliefert. Dies ist kostenlos, dauert aber länger. \nDie kostenpflichtige Behandlung kostet 10.000 € pro Sitzung und stellt +30 HP wieder her. Abklingzeit: 60 Minuten zwischen den kostenpflichtigen Behandlungen. \nDie Intensivstation (Intensivstation) ist die schwerste Behandlung für kritische Schäden. Abklingzeit: 180 Minuten. Die Kosten sind höher, aber die Wiederherstellung ist vollständiger. \nMit höheren HP (50+) können Sie immer noch Aktionen ausführen, sind aber anfälliger für Angriffe. \nKrankenhausbehandlungen sind während Ihrer Haftzeit gesperrt. Gehen Sie zuerst raus und suchen Sie dann eine Behandlung auf. \nEin Schulabschluss in Medizin senkt die Krankenhauskosten und beschleunigt die Genesungszeit. \nCrew-Sanitäter oder Sanitäter-Fähigkeiten können HP außerhalb des Krankenhauses als Notfallwiederherstellung wiederherstellen.';

  @override
  String get helpTopicHospitalTips =>
      'Erholen Sie sich niemals auf halbem Weg: Warten Sie, bis die vollen HP erreicht sind, bevor Sie PvP oder risikoreiche Verbrechen begehen. \nZeitlich bezahlte Behandlungen rund um die Abklingzeit: Starten Sie eine Behandlung kurz bevor Sie offline gehen, damit Sie mit voller HP wieder online sind.';

  @override
  String get helpTopicPrisonCategory => 'Erholung';

  @override
  String get helpTopicPrisonTitle => 'Gefängnis';

  @override
  String get helpTopicPrisonSummary =>
      'Verbüßen Sie Ihre Gefängnisstrafe, zahlen Sie eine Kaution oder versuchen Sie zu fliehen. Je höher Ihr Wanted-Level, desto länger und teurer ist Ihre Strafe.';

  @override
  String get helpTopicPrisonHow =>
      'Nach der Festnahme startet ein Timer basierend auf der Fahndungsstufe. Fahndungsstufe 1 = kurze Haftstrafe (Minuten), Fahndungsstufe 5+ = Stunden Gefängnis. \nDie Kaution richtet sich nach der Reststrafe und fällt niemals unter die Fahndungsgrenze × 1.000 €. Längere Haftstrafen kosten daher mehr, wenn sie sofort freigekauft werden. \nFlucht: Sie können einen Gefängnisausbruch versuchen, aber die Erfolgsaussichten sind gering. Bei Misserfolg verlängert sich Ihre Strafe um einen festen Betrag. \nIn der Gefängnisliste und dem Gefängnis-Overlay können Sie jederzeit Ihre eigene Kaution bezahlen und auch einen eigenen Fluchtversuch unternehmen, während Sie noch im Gefängnis sind. \nBesatzungsmitglieder können Sie besuchen und kleine Vorteile (Statistiken, Moral) gewähren, während Sie eingesperrt sind. \nBei Ihrer Festnahme erhalten Ihre Freunde und Besatzungsmitglieder jetzt eine Push-Benachrichtigung, dass Sie erwischt wurden und auf Hilfe warten. \nWaffen und Rüstungen werden bei der Festnahme beschlagnahmt, wenn Sie keinen Rechtsschutz dafür haben. \nGerichtliche Option: Gehen Sie für eine Strafminderung über einen Anwalt vor Gericht (siehe Gericht). \nWährend der Sperre laufen die Produktionstimer (Drogen-, Munitionsfabrik) weiter. Dein Imperium funktioniert ohne dich. \nWährend Sie eingesperrt sind, können Sie das Krankenhaus nicht besuchen. HP Recovery wartet, bis Sie frei sind.';

  @override
  String get helpTopicPrisonTips =>
      'Überprüfen Sie die Kaution sofort nach der Festnahme: Die Schaltfläche sollte sichtbar bleiben, solange Sie noch im Gefängnis sind, auch wenn Ihr Fahndungslevel bereits gesunken ist. \nStarten Sie die Produktions-Timer, kurz bevor Sie einen Kriminallauf mit hohem Risiko durchführen: Wenn Sie erwischt werden, läuft die Produktion trotzdem weiter.';

  @override
  String get helpTopicVaultCategory => 'Veranstaltungen';

  @override
  String get helpTopicVaultTitle => 'Knacke den Tresor';

  @override
  String get helpTopicVaultSummary =>
      'Monatliche Tresorsaison: Geben Sie einen 4-stelligen Code und Einsatzguthaben ein, um die Chance auf große Preise zu erhalten.';

  @override
  String get helpTopicVaultHow =>
      'Jeden Monat beginnt eine neue Saison am 1. und endet am letzten Tag des Monats. \nWählen Sie einen Einsatz (z. B. 1/3/5 Credits) und geben Sie einen 4-stelligen Code ein. \nSie können den Code auch über die Bildschirmtastatur (Zifferntasten) eingeben. \nJeder Versuch kostet Credits. Wenn Sie richtig raten, gewinnen Sie einen Preis. \nHöhere Einsätze bedeuten größere Preise; Manchmal kann eine VIP-Belohnung fallen. \nWenn Sie bereits VIP sind, wird eine VIP-Prämie in Credits umgewandelt. \nSie können Ihre falschen Codes für diesen Monat einsehen. Die Liste wird automatisch mit dem neuen Monat zurückgesetzt.';

  @override
  String get helpTopicVaultTips =>
      'Wählen Sie einen Einsatz, der Ihrem Guthaben entspricht: Sie können es unbegrenzt oft versuchen, aber jeder Versuch kostet Credits. \nVerwenden Sie die Liste der falschen Codes, um zu vermeiden, dass Sie denselben Code erneut verwenden.';

  @override
  String get helpTopicGarageCategory => 'Vermögenswerte';

  @override
  String get helpTopicGarageTitle => 'Garage';

  @override
  String get helpTopicGarageSummary =>
      'Stehlen und verwalten Sie Autos und Motorräder für Verbrechen und Schmuggel. Die Garage kümmert sich um Eigentum, zeitgesteuerte Reparaturen, Verkauf und Verschrottung. Der Transport erfolgt über den Smuggling Hub.';

  @override
  String get helpTopicGarageHow =>
      'Ihre Garage zeigt Autos und Motorräder mit Zustand (0-100 %), Kraftstoff, Marktwert, Seltenheit und Weltranglistenstatus an. \nDie Unterbringung von Autos und Motorrädern ist jetzt getrennt: Autos nutzen die Garagenkapazität, Motorräder nutzen die Motorradlagerkapazität. \nDie Aufrüstung von Auto- und Motorradlagerplätzen ist je nach Land unabhängig: Die Aufrüstung von Autos führt nicht zu einer Erhöhung der Motorradkapazität (und umgekehrt). Upgrades sind rangbezogen; Wenn Ihr Rang zu niedrig ist, wird eine Sperre/ein Tooltip angezeigt. Auf Level 5 ist der Upgrade-Button ausgeblendet. \nMit der Schaltfläche „Katalog“ können Sie alle stiehlbaren Autos und Motorräder anzeigen, einschließlich ihres häufigsten Landes und der vollständigen Spawn-Länderliste. \nDer Diebstahl erfolgt pro Fahrzeug mit Ranganforderungen und Abklingzeiten. Je teurer und seltener, desto geringer sind Ihre Erfolgschancen. \nWenn die Weltobergrenze eines Modells voll ist, können Sie dieses Modell nicht vorübergehend stehlen. Wenn ein Exemplar verkauft oder verschrottet wird, wird 1 Platz sofort wieder geöffnet. \nEin gescheiterter Diebstahl erhöht die Fahndungsstufe und kann eine Verhaftung auslösen. Wenn die Polizei Sie während der Flucht erwischt, landen Sie im Gefängnis und das gerade gestohlene Fahrzeug wird sofort beschlagnahmt. \nReparaturen sind zeitlich begrenzt: Sie zahlen im Voraus, das Fahrzeug wird repariert und kehrt erst nach Ablauf des Timers zurück. \nGleichzeitige Reparaturen sind auf Auto, Motorrad und Boot zusammen beschränkt: ohne VIP max. 1 aktiv, mit VIP max. 2 aktiv. \nVerschrottung ist eine Alternative zum Verkauf: Sie erhalten einen Restwert (35 % des Basiswerts), gestaffelt nach Zustand und Garagen-Upgrade-Bonus. \nVehicle Ops Intelligence fügt 6 zusätzliche Optionen hinzu. Kurz gesagt: \n1) Hotspot-Run: eine schnelle Aktion für direktes Geld, mit eigener Abklingzeit und zusätzlichem Risiko. \n2) Teilemarkt: Live-Teilepreise pro Typ (Auto/Motorrad/Boot) für Tuning; Die Preise werden regelmäßig aktualisiert. \n3) Crew-Op: Eine Koop-Aktion mit Ihrer Crew für zusätzliche Gewinne/Vorteile (nur wenn Sie in einer Crew sind). \n4) Hitze: pro Typ (Auto/Motorrad/Boot) ein „Aufmerksamkeits“-Meter; Höhere Hitze macht Aktionen riskanter und verringert die Erfolgsaussichten. Hitze lässt langsam nach. \n5) Vertrag abtrennen: Geben Sie ein berechtigtes Fahrzeug aus Ihrem Bestand für eine feste Vertragsauszahlung ab. \n6) Polizeimuster: Tageszeitmuster können zu mehr Kontrollen führen; Dies wirkt sich auf Risiken aus (z. B. Hafenstreik/Sperre für Boote). \nBeim Fahrzeugraub verwenden Auto/Motorrad/Boot jetzt eine Befehlsebene: Wählen Sie die Kategorie über die drei Fahrspurkarten oben aus, ohne eine zweite zusätzliche Tab-Reihe. \nJede Lane-Karte enthält direkte Schnellaktionen zum Stehlen und Lageraufrüsten, sodass Sie nicht erst zu den einzelnen Unterschaltflächen scrollen müssen. \nWährend die Abklingzeit eines Diebstahls läuft, erscheint neben dem Timer ein Blitzsymbol: Tippen Sie darauf, um Credits auszugeben und die Abklingzeit zu löschen. Sie können den Bestätigungsdialog ausschalten; Schalten Sie es in den Einstellungen unter Diebstahl-Abklingzeit (Credits) wieder ein. \nLane-Karten zeigen jetzt auch direkt die Kapazität pro Typ an (verwendet/Gesamt + Upgrade-Level). \nGestohlene Fahrzeuge werden jetzt als responsive Karten dargestellt: Auf Mobilgeräten wird eine pro Reihe angezeigt, auf Tablets/Desktops werden mehrere Karten nebeneinander angezeigt. \nNeue Ops-Ebene: PvP-Abfangfenster für Hotspots, Crew-Rollenboni in Crew-Ops, Ruffreischaltungen pro Fahrzeugtyp, regionale Blacklist-Events und Schmuggelversicherungsverträge. \nNeue Fahrzeug-Ops-Erweiterungen: Counter-Intercept-Missionen, Crew-Matchmaking mit saisonaler Rangliste, Ländermodifikatoren (Inflation/Korruption/Hafenstreik) und eine Vertragstafel mit wöchentlichen legendären Verträgen. \nOps zeigt jetzt Live-Abklingzeiten pro Aktion an. Timer zählen sichtbar herunter und aktualisieren sich automatisch. \nCrew-Aktionen (Crew Op und Crew Match) sind nur verfügbar, wenn Sie Mitglied einer Crew sind; Ohne Crew erhalten Sie einen klaren Freischalthinweis. \nErfolgreiche Einsatzaktionen zahlen Bargeld direkt in Ihr Portemonnaie. In der Aktionsübersicht wird pro Button die voraussichtliche Auszahlungsart angezeigt. \nVersicherungsansprüche werden jetzt zuerst geprüft; Mithilfe der Anspruchsstreitigkeit können Sie eine zusätzliche Auszahlung mit Ablehnungsrisiko anfechten. \nEine höhere Hitzekategorie verringert die Erfolgsaussichten eines Diebstahls und erhöht das Hotspot-Risiko. Die Hitze lässt jede Stunde allmählich nach. \nFür Chop-Shop-Verträge ist ein berechtigtes Fahrzeug aus Ihrem Bestand erforderlich; Bei der Geltendmachung wird das Fahrzeug verbraucht und das Vertragsgeld ausgezahlt. \nDer Fahrzeugtransport findet nicht mehr in der Garage statt; Verwenden Sie den Smuggling Hub-Flow. \nDurch den Weiterverkauf und die Verschrottung wird entweder Auto- oder Motorradkapazität frei, und es können World-Cap-Slots für dieses Modell wieder frei werden. \nFahrzeuge, die nur für Veranstaltungen bestimmt sind, wie z. B. Abfangjäger der Polizei, bleiben außerhalb der Veranstaltungsfenster verschlossen.';

  @override
  String get helpTopicGarageTips =>
      'Fahrzeuge aktiv stehlen, wenn das Wanted-Level niedrig ist: höheres Wanted = höheres Misserfolgsrisiko beim Stehlen. \nHalten Sie immer mindestens ein zuverlässiges Fahrzeug in einem guten Zustand für den Schmuggel: Ein kaputtes Fahrzeug halbiert Ihre Erfolgsaussichten. \nNutzen Sie die Verschrottung stark beschädigter Fahrzeuge als schnelle Kapazitätswiederherstellung; Bei gutem Zustand ist der Verkauf oft besser.';

  @override
  String get helpTopicMarinaCategory => 'Vermögenswerte';

  @override
  String get helpTopicMarinaTitle => 'Yachthafen';

  @override
  String get helpTopicMarinaSummary =>
      'Verwalten Sie Boote mit Seltenheit, Weltgrenzen und Reparatur-Timern für maritime Schmuggelrouten. Marina konzentriert sich auf Eigentum, Wartung, Verkauf und Verschrottung; Der Transport erfolgt über den Smuggling Hub.';

  @override
  String get helpTopicMarinaHow =>
      'Der Yachthafen zeigt Ihre Boote mit Zustand, Treibstoff, Marktwert, Seltenheit und Weltklasse-Status pro Modell an. \nMit der Schaltfläche „Katalog“ können Sie alle stehbaren Boote anzeigen, einschließlich der häufigsten Länder und der vollständigen Spawn-Länderliste. \nBootsdiebstahl hat seine eigenen Rangtore und Abklingzeiten. Teurere Boote sind schwerer zu stehlen, können aber profitabler sein. \nWenn die Weltkapazität eines Bootsmodells voll ist, verschwindet es vorübergehend aus der verfügbaren Liste. Durch Verkauf/Verschrottung werden Slots wieder geöffnet. \nReparaturen sind zeitlich begrenzt: Sie zahlen im Voraus und das Boot ist nicht verfügbar, bis der Timer abgelaufen ist. \nGleichzeitige Reparaturen sind auf Auto, Motorrad und Boot zusammen beschränkt: ohne VIP max. 1 aktiv, mit VIP max. 2 aktiv. \nDas Verschrotten gewährt einen Bergungswert (35 % des Grundwerts), skaliert mit dem Zustand und dem Marina-Upgrade-Bonus. \nMarina verwaltet nur den Besitz und die Wartung; Die eigentliche Transportroute findet im Smuggling Hub statt. \nPolizeiboote, die nur für Veranstaltungen bestimmt sind, sind für vorübergehende Veranstaltungen bestimmt und bleiben außerhalb der Veranstaltungsfenster verschlossen.';

  @override
  String get helpTopicMarinaTips =>
      'Investieren Sie in den Yachthafen, wenn Ihre Schmuggelrouten regelmäßig über das Wasser verlaufen: Ein geringeres Interesse der Polizei kann die Erfolgsaussichten deutlich erhöhen. \nHalten Sie als schnelle Alternative ein Schnellboot auf Hochtouren, wenn die Fluchtwege an Land blockiert sind. \nVerschrotten Sie stark beschädigte Boote mit geringem Wiederverkaufswert, um schneller erstklassigen Platz und Marina-Kapazität freizugeben.';

  @override
  String get helpTopicTuneshopCategory => 'Vermögenswerte';

  @override
  String get helpTopicTuneshopTitle => 'Tune-Shop';

  @override
  String get helpTopicTuneshopSummary =>
      'Verwenden Sie geborgene Teile, um Fahrzeuge nach Kategorie aufzurüsten. Verbessern Sie Geschwindigkeit, Tarnung und Rüstung mit skalierbaren Levelkosten und Kategorieabklingzeiten.';

  @override
  String get helpTopicTuneshopHow =>
      'Durch die Verschrottung von Fahrzeugen verdienen Sie Teile: Autoteile, Motorradteile und Bootsteile. \nTeile werden in Kategorien zusammengefasst: Jedes Fahrzeug derselben Kategorie verwendet denselben Teilebestand. \nJedes Upgrade kostet Teile und Geld. Die Geldkosten sind kategoriebasiert und erhöhen sich je Tuning-Level. \nSie können drei Werte verbessern: Geschwindigkeit, Heimlichkeit und Rüstung. \nDas Tuning erfolgt pro Fahrzeug in Ihrem Bestand. Neue Fahrzeuge beginnen wieder bei Level 0. \nNach jeder Melodie gibt es eine Abklingzeit pro Fahrzeug: Auto 180 Sekunden, Motorrad 120 Sekunden, Boot 240 Sekunden. \nDas gleichzeitige Tuning ist begrenzt: ohne VIP maximal 1 aktives Fahrzeug in der Tuning-Abklingzeit, mit VIP maximal 5. \nGetunte Fahrzeuge erzielen einen höheren Verkaufs- und Restwert. \nWährend ein Fahrzeug repariert oder transportiert wird, ist das Tuning gesperrt.';

  @override
  String get helpTopicTuneshopTips =>
      'Schrotten Sie stark beschädigte Fahrzeuge zuerst ab, um schnell Teile zu bauen. \nInvestieren Sie frühzeitig in Tarnung, um das Erfassungsrisiko bei risikoreichen Läufen zu senken. \nNutzen Sie Panzerungsverbesserungen für Fahrzeuge, die Sie wiederholt in gefährlichen Schleifen einsetzen.';

  @override
  String get helpTopicShootingRangeCategory => 'Ausbildung';

  @override
  String get helpTopicShootingRangeTitle => 'Schießstand';

  @override
  String get helpTopicShootingRangeSummary =>
      'Verbessern Sie Ihre Genauigkeit und Waffenfähigkeiten durch strukturierte Schießübungen. Höhere Werte erhöhen den Schaden und die Trefferchance im PvP und bei Verbrechen.';

  @override
  String get helpTopicShootingRangeHow =>
      'Der Schießstand bietet mehrere Disziplinen: Pistole, Gewehr, Schrotflinte und automatisches Feuer. Jeder trainiert eine eigene Waffenfertigkeit. \nJede Trainingseinheit hat eine Abklingzeit von 30 Minuten. Sie können nicht endlos am Tag trainieren. \nEine höhere Genauigkeit erhöht deine Trefferchance in PvP-Kämpfen und verringert die Wahrscheinlichkeit, selbst getroffen zu werden. \nDie Waffenfertigkeit bestimmt auch, welche Waffen Sie effektiv einsetzen können: Ein Scharfschützengewehr erfordert eine bestimmte Fertigkeit, bevor Sie den vollen Bonus erhalten. \nTrainingsergebnisse werden kumulativ gestapelt. Es gibt keine Zurücksetzung, es sei denn, Sie erhalten vom Gericht eine hohe Strafe. \nDer Schulabschluss „Militärische Ausbildung“ gewährt einen dauerhaften Bonus auf jede Schießübungssitzung.';

  @override
  String get helpTopicShootingRangeTips =>
      'Trainieren Sie jeden Tag den Schießstand: Kleine kumulative Boni machen sich innerhalb einer Woche in den PvP-Ergebnissen bemerkbar. \nTrainieren Sie den Waffentyp, den Sie bei Verbrechen und PvP am häufigsten verwenden, um eine maximale Kapitalrendite zu erzielen.';

  @override
  String get helpTopicGymCategory => 'Ausbildung';

  @override
  String get helpTopicGymTitle => 'Fitnessstudio';

  @override
  String get helpTopicGymSummary =>
      'Trainiere Kraft, Geschwindigkeit und Ausdauer für bessere Statistiken im PvP, bei Verbrechen und im HP-Pool. Tägliches Training ist der Schlüssel zu einem schnellen Statistikwachstum.';

  @override
  String get helpTopicGymHow =>
      'Das Fitnessstudio bietet drei Trainingskategorien: Kraft (mehr Schaden pro Angriff), Geschwindigkeit (höhere Reflexe, weniger Treffer), Ausdauer (höhere maximale HP). \nJedes Training hat eine Abklingzeit von 1 Stunde. Je nach Schulabschluss maximal 6-8 Sitzungen pro Tag. \nStärke erhöht den direkten Schaden sowohl im PvP als auch bei bestimmten Verbrechensarten (Raub, Schlägerei). \nGeschwindigkeit erhöht die Chance, einem Angriff auszuweichen, und verringert die Wahrscheinlichkeit, bei einem Verbrechen erwischt zu werden. \nAusdauer erhöht deinen maximalen HP-Vorrat. Mehr HP = längeres Überleben im PvP und mehr Raum für riskante Verbrechen. \nDas Schulzertifikat „Physical Training“ gewährt einen Bonus von +15 % auf alle Trainingseinheiten im Fitnessstudio.';

  @override
  String get helpTopicGymTips =>
      'Priorisieren Sie Ausdauertraining: Ein höherer HP-Pool verbessert alle Ihre anderen Systeme, da Sie länger aktiv bleiben. \nKombinieren Sie Fitnessstudio mit Schießstand: Kraft + Genauigkeit ist die stärkste PvP-Kombination.';

  @override
  String get helpTopicAmmoFactoryCategory => 'Reich';

  @override
  String get helpTopicAmmoFactoryTitle => 'Munitionsfabrik';

  @override
  String get helpTopicAmmoFactorySummary =>
      'Produzieren Sie Munition für den persönlichen Gebrauch und verwalten Sie Ihre Produktion in der Fabrik. Der Kauf und Verkauf von Munition erfolgt über den Schwarzmarkt und nicht direkt über den Fabrikbildschirm.';

  @override
  String get helpTopicAmmoFactoryHow =>
      'Die Munitionsfabrik verfügt über Produktionsstufen (Stufe 1 bis 5). Höheres Level = mehr Runden pro Anspruch und bessere Qualität. \nWährend einer aktiven Sitzung beanspruchen Sie etwa alle 20 Minuten eine Produktion (bis zu 8 Stunden Rückstand innerhalb dieser Sitzung). \nAuch wenn Sie offline sind, steigt die Produktion weiter an: Wenn Sie zurückkommen, können Sie mehrere Ansprüche geltend machen, bis der Rückstand aufgeholt ist. \nEine bloße Besichtigung der Munitionsfabrik oder Hin- und Rückfahrt darf nicht den Besitzer wechseln; Eine Fabrik sollte nicht auf „zu verkaufen“ wechseln, nur weil der Bildschirm geöffnet wurde. \nProduzierte Munition wird persönlich für Verbrechen und PvP verwendet. Um Munition zu kaufen und zu verkaufen, gehen Sie über den Schwarzmarkt; Der Fabrikbildschirm selbst verkauft keine Kugeln direkt. \nLeistungsverbesserungen erhöhen die Anzahl der Runden pro Anspruch; Qualitätsverbesserungen steigern den Marktwert. \nDer Marktpreis für Munition schwankt je nach Nachfrage. Füllen Sie Vorräte auf, wenn die Preise niedrig sind, und verkaufen Sie, wenn die Preise hoch sind. \nBei einem Fabriküberfall verlierst du einen Teil der gespeicherten Produktion. Sicherheit senkt dieses Risiko.';

  @override
  String get helpTopicAmmoFactoryTips =>
      'Rüsten Sie Ihre Fabrik so schnell wie möglich auf Level 3 auf: Durch die verdoppelte Produktion im Vergleich zu Level 1 ist sie autark für Munition. \nHalten Sie immer 2-3 Produktionsrunden als Puffer in Reserve, damit Ihnen im PvP nie die Munition ausgeht.';

  @override
  String get helpTopicSchoolCategory => 'Ausbildung';

  @override
  String get helpTopicSchoolTitle => 'Schule';

  @override
  String get helpTopicSchoolSummary =>
      'Absolvieren Sie Kurse in mehreren Tracks, um Boni freizuschalten, Kosten zu senken und neue Systeme zu eröffnen. Die Schule ist ein Multiplikator für alles, was Sie tun.';

  @override
  String get helpTopicSchoolHow =>
      'Die Schule bietet Titel pro Domäne an: Kriminalität (bessere Kriminalitätsstatistiken), Wirtschaft (geringere Handels- und Bankkosten), Militär (Kampfprämien), Medizin (geringere Krankenhauskosten), Jura (geringere Anwaltskosten), Technik (bessere Fabrik- und Arzneimittelproduktion). \nDie Lernzeit für jede Lektion beträgt je nach Niveau 15–60 Minuten. Höhere Level dauern länger. \nNach Abschluss einer Unterrichtsstunde erhalten Sie ein Zertifikat für das entsprechende Kursniveau. Dieses Zertifikat ist dauerhaft und gewährt den Bonus sofort. \nSie können jeweils nur einer Lektion folgen. Planen Sie Ihr Studium sorgfältig, wenn Sie dringend ein bestimmtes Zertifikat benötigen. \nDie Schulkosten steigen pro Stufe. Für die Hochschulbildung ist der Abschluss früherer Stufen derselben Studienrichtung erforderlich. \nEinige erweiterte Spielfunktionen sind hinter einem Schulzertifikat verschlossen: z.B. Zugang zu bestimmten Jobs, höhere Fabrikstufen, VIP-Nightclub-Events und höhere Upgrade-Stufen für Drogeneinrichtungen. \nZertifikate werden niemals zurückgesetzt, es sei denn, Ihr Konto erhält eine hohe Strafe.';

  @override
  String get helpTopicSchoolTips =>
      'Beginnen Sie immer mit dem Kriminal-Track: Boni auf Kriminal-Erfolgschancen amortisieren die Studienkosten innerhalb weniger Sitzungen. \nPlanen Sie vor dem Schlafengehen langes Lernen (60 Min.+) ein: Sie wachen mit einem neuen Zertifikat auf, ohne aktive Zeit zu verpassen.';

  @override
  String get helpTopicTerritoryCategory => 'Reich';

  @override
  String get helpTopicTerritoryTitle => 'Gebiet';

  @override
  String get helpTopicTerritorySummary =>
      'Beanspruchen und kontrollieren Sie geografische Regionen für passives Einkommen, Crew-Prestige und strategische regionale Boni. Territory kombiniert Kartenkontrolle mit Wettbewerben und saisonalen Belohnungen.';

  @override
  String get helpTopicTerritoryHow =>
      'Die Gebietsübersicht zeigt alle verfügbaren Länder und Regionen nach Ländern geordnet. Klicken Sie auf ein Land, um die interaktive Karte anzuzeigen. \nAlle unterstützten Länder sind jetzt über denselben interaktiven Kartenfluss wie die Niederlande vollständig durchsuchbar. \nTippen Sie auf eine Region auf der interaktiven Karte, um ein Modal mit Gebietsinformationen und der Angriffsschaltfläche zu öffnen. Die separaten Regionskarten unterhalb der Karte werden nicht mehr benötigt. \nDas Ansehen ist überall erlaubt, Angriffe, Verteidigungsbeitritte und Wettbewerbsaktionen funktionieren jedoch nur in dem Land, in dem sich Ihr Charakter gerade befindet. \nAuf Mobilgeräten können Sie jetzt mit zwei Fingern hinein- und herausziehen und die gezoomte Karte direkt ziehen, sodass kleinere Regionen einfacher angetippt werden können, ohne dass zusätzliche Schaltflächen auf der Karte erforderlich sind. \nDas Territorium basiert auf der Crew: Sie müssen eine Crew erstellen oder einer beitreten, bevor die Angriffstaste für neutrale oder feindliche Regionen verfügbar wird. \nJede Region kann jeweils von höchstens einer Crew kontrolliert werden. Der Besitz gewährt ein passives Einkommen pro Stunde, aber Territory zahlt nicht mehr in die Mannschaftsbank ein, sobald die Obergrenze für die Bargeldspeicherung erreicht ist. \nStarten Sie einen Wettbewerb in einer nicht beanspruchten Region über die Wettbewerbsschaltfläche. Der Wettbewerb verläuft automatisch durch Vorbereitung (Vorbereitungszeit), aktiv (Aktionen) und Sperrung (Lösung). \nWenn die Vorbereitung endet, erhalten angreifende und verteidigende Besatzungsmitglieder eine Push-Benachrichtigung und eine Posteingangsnachricht, damit Sie wissen, dass Sie angreifen oder verteidigen können. Diese Warnung wird im Minutentakt gesendet, auch wenn niemand den Gebietsbildschirm geöffnet hat. \nWährend eines aktiven Wettbewerbs zeigt das Regionsmodal jetzt auch an, wann Aktionen freigeschaltet werden, wann der Wettbewerb endet, wie hoch die Abklingzeit pro Aktion ist und wie viel Geld die Region tatsächlich pro Auszahlung, pro Stunde und pro Tag zahlt. \nRegionen haben mittlerweile auch strategische Rollen wie Hafen, Industrie, Hauptstadt, Grenzregion oder Logistikdrehscheibe. Diese Rolle bestimmt, welche Aktionen dort Extrapunkte bringen können. \nAngrenzende Regionen, die Ihrer Crew bereits gehören, bieten jetzt zusätzliche Unterstützung bei Wettbewerbsaktionen. Das Regionsmodal zeigt an, welche strategischen Boni aktiv sind und wie viel angrenzende Unterstützung Ihre Crew in diesem Bereich hat. \nAktionsboni können jetzt auch durch den Fortschritt der Crew erzielt werden: HQ-Level, Crew-Missionslevel und relevante Nebengebäude (Waffen/Munition/Auto/Boot/Drogenlager). Diese Boni erhöhen nur die Wettbewerbspunkte, nicht das passive Regionsgeld. \nEinige fortgeschrittene Wettbewerbsaktionen sind HQ-geschützt: Wenn Ihr HQ-Level zu niedrig ist, wird auf der Aktionsschaltfläche sofort „HQ-Level X erforderlich“ angezeigt. \nDas Territorium verwendet standardmäßig keine feste tägliche Aktionsobergrenze mehr (Laufzeitobergrenze 0 = deaktiviert). Das Gleichgewicht bleibt durch Abklingzeiten, Anti-Farm und strategische Aktionsoptionen kontrolliert. \nDer Sieg in einem Territorialkrieg oder Total War kann nun vorübergehenden Kriegsdruck auf die echten Territorialregionen rund um diese Front ausüben. Das Regionsmodal zeigt, welche Crew dem Druck standhält, wie stark die effektive Stabilität reduziert wird und wann die Nachwirkungen ablaufen. \nWenn ein Wettbewerb gerade erst begonnen hat oder bei einem älteren Wettbewerb noch Zeitfelder fehlten, füllt der Bildschirm diese Timer jetzt sofort aus und aktualisiert das Modal auf den neuesten Wettbewerbsstatus, ohne dass Sie zuerst wegnavigieren müssen. \nAngreifer sehen nur Aktionen des Angreifers (Informationen, Sabotage, Überfall) und Verteidiger sehen nur Aktionen des Verteidigers (Patrouille, Versorgungslauf, Verteidigung), sodass im Modal keine verwirrenden gemischten Schaltflächen mehr angezeigt werden. \nEine Region zeigt jetzt auch den tatsächlichen Gebietsertrag an. Crew-Leiter sehen außerdem auf dem Dashboard, wie viele Regionen und Länder ihre Crew kontrolliert, wie viel die Crew derzeit verdient und wie viel Territory bisher insgesamt verdient hat. \nWettbewerbe führen zu Eigentumsübertragungen und Belohnungen (Geld, XP, Prestige). Verlierer erhalten außerdem Teil-XP für die Teilnahme. \nGroße Regionen (Häfen, Hauptstädte) bringen mehr passives Einkommen, lösen aber auch mehr Gegner und Überfallversuche aus. \nSaisonale Events bieten Bonusbelohnungen und besondere Herausforderungen pro Regionsgruppe. \nVerhindern Sie Blockaden: Ihre Crew kann nach einer Niederlage nicht sofort denselben Gegner angreifen; warte auf die Abklingzeit. \nAnti-Missbrauchskontrollen verhindern, dass eine Crew in kurzen Zeitfenstern wiederholt dasselbe Ziel angreift.';

  @override
  String get helpTopicTerritoryTips =>
      'Beginnen Sie in einem ausgeglichenen Land mit mittelgroßen Regionen: weniger Konkurrenz als große Länder, aber angemessenes passives Einkommen. \nKonzentrieren Sie sich zunächst auf ein Land, in dem Ihre Crew stark ist: Besseres Wissen führt in vielen Ländern zu einer besseren Wettkampfstrategie als oberflächliche Kontrolle. \nNutzen Sie Jahreszeiten als strategische Neustarts: Wenn Sie in einer Trockenzeit verlieren, folgt immer eine bessere Saison mit einem Comeback.';

  @override
  String get helpTopicProstitutionCategory => 'Reich';

  @override
  String get helpTopicProstitutionTitle => 'Prostitution';

  @override
  String get helpTopicProstitutionSummary =>
      'Bauen Sie ein Prostitutionsnetzwerk mit Rekruten, Events und VIP-Kunden auf. Ein gut geführtes Netzwerk generiert passives Einkommen, erfordert jedoch ein aktives Management, um Rivalität und polizeiliche Aufmerksamkeit zu kontrollieren.';

  @override
  String get helpTopicProstitutionHow =>
      'Der Hub „Prostitution Empire“ verfügt über vier Registerkarten: Arbeiter, RLD, Ereignisse und Soziales.\nSie verwalten die Rekruten jeweils mit ihren eigenen Statistiken (Erfahrung, Beliebtheit, Verfügbarkeit). Mehr Rekruten = höheres passives Einkommen.\nVerwenden Sie „Collect“, um ausstehende Einnahmen abzurechnen, die im KPI-Streifen angezeigt werden.\nDie Arbeitsschichten dauern pro Rekrut 8 Stunden: Nach einer Schicht benötigt dieser Rekrut Ruhezeit, bevor er wieder anfangen kann.\nDie Standortverwaltung ist flexibel: Verschieben Sie Rekruten über das Menü „Verschieben“ auf jeder Arbeiterkarte zwischen Straße, Rotlichtviertel und Nightclub.\nEvents sind vorübergehende Booster: Sondershows, VIP-Abende und Partys erhöhen die Einnahmen pro Tick für die Dauer der Veranstaltung.\nRivalität: Andere Spieler oder NPC-Konkurrenten können Ihre Rekruten abwerben oder Events sabotieren. Höhere Sicherheit verringert dieses Risiko.\nVIP-Kunden zahlen deutlich mehr, benötigen aber Rekruten mit hoher Beliebtheit (80+) und einem gesicherten Standort.\nBei Großtransaktionen und Razzien steigt die Aufmerksamkeit (Hitze) der Polizei. Hohe Hitze führt zur Beschlagnahme von Einkommen oder zur vorübergehenden Schließung.\nKombination mit Nightclub: Ein Nightclub bietet rechtlichen Schutz für Aktivitäten, die den Hitzeanstieg verlangsamen.\nNutzen Sie das Einnahmen-Einblicksfenster oben, um schnell die Stundenleistung für Straße, RLD und Nightclub zu vergleichen.\nBestenliste: Der höchste wöchentliche Gesamtumsatz gewinnt eine wöchentliche Geldprämie und ein Abzeichen.';

  @override
  String get helpTopicProstitutionTips =>
      'Investieren Sie frühzeitig in Sicherheit: Ein Rivalitätsangriff, der Ihren besten Rekruten abwirbt, kostet mehr als die Sicherheitsinvestition. \nOrganisieren Sie VIP-Events nur, wenn die Rekruten einen Beliebtheitsgrad von über 80 haben. Unter diesem Schwellenwert zahlen VIP-Kunden einfach den Standardpreis.';

  @override
  String get helpTopicRedLightDistrictsCategory => 'Reich';

  @override
  String get helpTopicRedLightDistrictsTitle => 'Rotlichtviertel';

  @override
  String get helpTopicRedLightDistrictsSummary =>
      'Beanspruchen und verwalten Sie Territorialbezirke pro Land. Der Besitz eines Bezirks verschafft passives Einkommen und Kontrolle über Prostitutionsaktivitäten in dieser Region.';

  @override
  String get helpTopicRedLightDistrictsHow =>
      'In jedem Land gibt es einen oder mehrere Rotlichtbezirke, die beansprucht werden können. Beanspruchen Sie einen Bezirk, indem Sie einen festgelegten Kaufbetrag bezahlen.\nAls Eigentümer eines Bezirks erhalten Sie einen Prozentsatz aller Prostitutionseinnahmen in diesem Land – auch von anderen dort tätigen Akteuren.\nAndere Spieler können Ihren Bezirk angreifen, um den Besitz zu übernehmen. Höhere Sicherheit verringert die Angriffswahrscheinlichkeit.\nIn den Bezirksdetails können Sie die Stufe (Einnahmen) und die Sicherheit (Überfallrisiko) verbessern und Live-Überfallstatistiken (FBI-Hitze, Überfallchance) anzeigen. Höhere Sicherheit verringert die Wahrscheinlichkeit von Überfällen.\nSie können bis zu 3 Bezirke gleichzeitig besitzen. Eine strategische Länderauswahl ist von entscheidender Bedeutung.\nDie geschäftigsten Länder (Kolumbien, Dubai, Japan) bieten das höchste passive Einkommen, sind aber auch die am stärksten umkämpften Länder.\nDurch den Verlust eines Bezirks wird der Kaufpreis nicht zurückerstattet: Er geht dauerhaft verloren, wenn ein Feind ihn erfolgreich beansprucht.';

  @override
  String get helpTopicRedLightDistrictsTips =>
      'Beginnen Sie für Ihren ersten Distrikt mit einem weniger beliebten Land: Ein geringerer Angriffsdruck gibt Ihnen Zeit, die Sicherheit vor der echten Konkurrenz zu verbessern. \nVerbessern Sie die Sicherheit jedes Bezirks sofort nach dem Kauf: Die ersten 24 Stunden sind am anfälligsten für eine Übernahme.';

  @override
  String get helpTopicAchievementsCategory => 'Meta';

  @override
  String get helpTopicAchievementsTitle => 'Erfolge';

  @override
  String get helpTopicAchievementsSummary =>
      'Verdienen Sie Abzeichen, indem Sie in allen Spielsystemen Meilensteine ​​erreichen. Erfolge geben Belohnungen, verbessern Ihr Statusprofil und zeigen Ihren Fortschritt pro Kategorie an.';

  @override
  String get helpTopicAchievementsHow =>
      'Erfolge sind in Kategorien eingeteilt: Verbrechen, Imperium, PvP, Wirtschaft, Training, Soziales und Meta. \nJeder Erfolg hat mehrere Stufen (Bronze, Silber, Gold, Platin). Jede Stufe bringt eine höhere Belohnung und ein beeindruckenderes Abzeichen. \nZu den Belohnungen pro Erfolg gehören: Bargeld, XP, besondere Gegenstände, permanente Boni oder einzigartige Titel für Ihr Profil. \nDer Fortschritt wird automatisch verfolgt. Sie müssen nichts aktivieren: Erreichen Sie den Schwellenwert und das Abzeichen wird sofort vergeben. \nEinige Erfolge werden ausgeblendet, bis Sie sie teilweise abschließen – sie werden dann mit ihrem richtigen Namen und den Anforderungen angezeigt. \nLeistungsabzeichen sind in Ihrem öffentlichen Profil sichtbar. Sie zeigen anderen Spielern Ihre Spezialisierungen und Erfahrungen. \nKettenerfolge: Einige Abzeichen sind in einer Kette verbunden. Für Gold muss bereits Silber erworben worden sein. Planen Sie frühzeitig für höhere Stufen.';

  @override
  String get helpTopicAchievementsTips =>
      'Überprüfen Sie täglich Ihre fast erreichten Erfolge: Ein kleiner zusätzlicher Aufwand kann zu einem Abzeichen und einer Geldprämie führen, die andernfalls um Monate verzögert würden. \nKonzentrieren Sie sich frühzeitig auf die Kategorien Wirtschaft und Kriminalität: Diese bieten die meisten Geldprämien und lassen sich am einfachsten mit Ihrem normalen Gameplay kombinieren.';

  @override
  String get helpTopicSupportTicketsCategory => 'Unterstützung';

  @override
  String get helpTopicSupportTicketsTitle => 'Berichte & Tickets';

  @override
  String get helpTopicSupportTicketsSummary =>
      'Melden Sie Fehler, Fragen oder Feedback über das Ticketsystem. Support und Administratoren können über das Support-Gespräch selbst und optionale Push-Benachrichtigungen antworten, interne Nachverfolgungen verwalten und Aktualisierungen zurücksenden.';

  @override
  String get helpTopicSupportTicketsHow =>
      'Öffnen Sie den separaten Menüpunkt „Support“, um Ihre Tickets zu überprüfen oder ein neues zu erstellen. \nWählen Sie eine Kategorie (Fehler, Frage, Feedback oder anderes), wählen Sie bei Bedarf das zugehörige Modul aus und beschreiben Sie Ihr Problem so konkret wie möglich. \nSie können optional eine Referenz wie eine Bestell-ID, einen Bildschirmnamen oder einen kurzen Kontext sowie einen Screenshot hinzufügen, falls dies hilfreich ist. \nNach dem Absenden erhalten Sie sofort eine Ticketnummer und Ihr Ticket erscheint in Ihrer Support-Übersicht, wo der Support antworten und interne Aufgaben erstellen kann. \nWenn der Support antwortet oder sich der Ticketstatus ändert, sehen Sie dies direkt in derselben Support-Konversation und können optional eine Push-Benachrichtigung erhalten (sofern Benachrichtigungen aktiviert sind). \nDer Menüpunkt „Support“ zeigt ein Abzeichen an, sobald ein Ticket seit Ihrem letzten Besuch der Support-Übersicht eine neue Support-Antwort oder ein Status-Update erhält. \nDer Support verwendet Status wie „Neu“, „Triage“, „In Bearbeitung“, „Warten auf Spieler“, „Blockiert“ und „Gelöst“, um Ihren Bericht intern zu verfolgen.';

  @override
  String get helpTopicSupportTicketsTips =>
      'Geben Sie immer Ihr Land, Ihre Aktion und die genaue Fehlermeldung an; Dies beschleunigt die Korrekturen für Entwickler. \nVerwenden Sie ein Ticket pro Problemtyp, damit die Aufgabenliste und die Nachverfolgung übersichtlich bleiben.';

  @override
  String get helpTopicSettingsCategory => 'Kern';

  @override
  String get helpTopicSettingsTitle => 'Einstellungen';

  @override
  String get helpTopicSettingsSummary =>
      'Verwalten Sie alle Kontoeinstellungen: Sprache, Avatar, Datenschutz, Benachrichtigungseinstellungen pro System und Sicherheitsoptionen. Die Einstellungen wirken sich direkt auf Ihr Spielerlebnis aus.';

  @override
  String get helpTopicSettingsHow =>
      'Sprache: Wechseln Sie zwischen Niederländisch und Englisch. Alle UI-Texte, Systemmeldungen und Benachrichtigungen werden sofort aktualisiert. \nAvatar: Laden Sie ein Profilbild hoch oder wählen Sie es aus, das für andere Spieler in Ihrem öffentlichen Profil und in Crewlisten sichtbar ist. \nDatenschutz: Legen Sie fest, wer Ihren Online-Status, Standort (aktuelles Land) und Statistiken sehen kann – nur Sie, Ihre Crew, Freunde oder alle. \nPush-Benachrichtigungen: je nach System umschalten. Kategorien: Verbrechen, Krypto-Handel, Preisalarme, Bestellungen, Live-Spieler-Events (Wettbewerb), Marktregime, Raubüberfall, Nightclub, allgemeine Nachrichten. \nWenn Push bereits erlaubt war, stellt die Web-/PWA-Version nach einer Aktualisierung oder Aktualisierung automatisch wieder eine Verbindung zu Ihrem aktuellen Geräte-Token her; Sie müssen es nur dann in den Einstellungen wieder aktivieren, wenn der Browser selbst Benachrichtigungen blockiert. \nDie Einstellungen für Krypto-Benachrichtigungen bleiben gespeichert, auch wenn Sie die Einstellungen verlassen und später erneut öffnen. \nIn-App-Benachrichtigungen: getrennt von Push konfigurierbar. In-App zeigt Warnungen innerhalb der App an, ohne eine Systembenachrichtigung zu senden. \nSicherheit: Passwort ändern, Zwei-Faktor-Authentifizierung einrichten und aktive Sitzungen anzeigen. \nSystemspezifische Benachrichtigungspräferenz: Feinabstimmung, damit Sie keinen Benachrichtigungssturm von Systemen erhalten, auf denen Sie nicht aktiv spielen.';

  @override
  String get helpTopicSettingsTips =>
      'Aktivieren Sie Push-Benachrichtigungen für Krypto-Bestellungen und Raubüberfälle: Hierbei handelt es sich um zeitkritische Systeme, bei denen es auf eine schnelle Reaktion ankommt. \nStellen Sie die Privatsphäre für den Standort auf „Nur Crew“ ein, wenn Sie auf der Trefferliste aktiv sind: Andere Spieler können Sie sonst genau lokalisieren.';

  @override
  String get helpTopicPremiumCategory => 'Kern';

  @override
  String get helpTopicPremiumTitle => 'Prämie und Credits';

  @override
  String get helpTopicPremiumSummary =>
      'Kaufen und verwalten Sie hier Spieler-VIP-, Crew-VIP- und Credit-Pakete. In dieser Übersicht werden auch Ihr Guthabenstand und alle verfügbaren Guthabenpositionen angezeigt, die Sie direkt oder kontextbezogen nutzen können.';

  @override
  String get helpTopicPremiumHow =>
      'Öffnen Sie im Seitenmenü die separate Seite „Premium & Credits“, um Ihren VIP-Status, Ablaufdaten, Guthaben und Kaufoptionen anzuzeigen. \nTippen/klicken Sie auf jeder Kaufkachel oben links auf das „i“-Symbol, um alle Details und Vorteile anzuzeigen. Die Kachel selbst zeigt bewusst nur kurze Kerninformationen und den Kaufen-Button. \nSpieler-VIP ist persönlich. Crew-VIP gilt für Ihre Crew und hat nur dann einen Wert, wenn Sie bereits Mitglied einer Crew sind. \nSpieler-VIP bietet 10 % kürzere Aktions-Timeouts (die Gefängniszeit bleibt unverändert), 100 wöchentliche Credits, eine VIP-Ein-Klick-Kaufschaltfläche für fehlende Materialien in der Arzneimittelproduktion (nach Kostenbestätigung) und einen sanfteren Todes-Reset: Bank/Krypto/Bildung/Erfolge bleiben bestehen, während Vermögenswerte, Inventar und Arzneimittelvorräte entfernt werden. \nBeim VIP-Checkout wird die Zahlungsseite geöffnet und dann zum Abschnitt „Premium & Credits“ im Spiel zurückgekehrt, sodass Sie sofort sehen, ob der Kauf erfolgreich war und wie lange Ihr VIP läuft. \nCredit-Pakete werden mit echtem Geld gekauft. Nach erfolgreicher Zahlung erscheint das Guthaben sofort in Ihrer Wallet-Übersicht. \nDer Event-Pass (7 Tage, Echtgeld) ist in der Liste der einmaligen Angebote aufgeführt: +10 % Punktestand bei Live-Spieler-Events, plus ein kleiner Kreditbonus nach dem Kauf. Es ist eine Nebenstufe: kein direkter Kampf oder PvP-Boost; Es hilft vor allem bei den Bestenlistenergebnissen bei Laufveranstaltungen. \nFür Guthabenartikel werden Wallet-Guthaben anstelle von Euro verwendet. Denken Sie an Trefferschutz, Cooldown-Resets, Event-Boosts oder Geldpakete, je nachdem, was der Administrator derzeit live aktiviert hat. \nAuf unterstützten Timeout-Bildschirmen (z. B. Verbrechen, Jobs, Fahrzeug-/Bootsdiebstahl und Schule) erhalten Sie außerdem eine direkte Beschleunigungstaste für aktive Abklingzeiten, sodass Sie nicht zuerst zu Premium & Credits zurückkehren müssen. \nEinige Guthabenpositionen funktionieren direkt über diesen Bildschirm. Kontextgebundene Elemente, wie z. B. bestimmte Fahrzeugaktionen, werden stattdessen vom richtigen Fahrzeug- oder Garagenbildschirm aus verwendet (beschädigte Fahrzeuge zeigen direkt auf der Karte eine Schaltfläche für die sofortige Reparatur an). \nBei kontextbezogenen Schaltflächen wie Reparaturbeschleunigung werden die aktuellen Kreditkosten direkt auf der Schaltfläche/im Tooltip angezeigt. \nPreise und verfügbare Artikel werden live im Admin verwaltet. Das bedeutet, dass sich VIP-Preise, Kreditkosten und das verfügbare Angebot ohne ein App-Update ändern können.';

  @override
  String get helpTopicPremiumTips =>
      'Überprüfen Sie Ihr Guthaben und das Ablaufdatum, bevor Sie erneut kaufen. Erweitern ist oft besser als blindes Stapeln. \nVerwenden Sie Credits hauptsächlich für zeitkritische Boosts oder Schutzmaßnahmen, nicht automatisch für jede kleine Abkürzung. \nWenn Sie noch keiner Crew angehören, beginnen Sie mit Spieler-VIP oder einem Credit-Paket vor Crew-VIP.';

  @override
  String get landingHeroTitle => 'Der Mob-Staat';

  @override
  String get landingHeroSubtitle =>
      'Ein tiefgründiges, textbasiertes Kriminalstrategiespiel in Ihrem Browser. Bauen Sie Ihr Imperium auf, leiten Sie Mannschaften, handeln Sie, kämpfen Sie um Territorien – und steigen Sie im Rang auf.';

  @override
  String get landingAboutTitle => 'Was erwartet Sie';

  @override
  String get landingAboutBody =>
      'Verwalten Sie Unternehmen, führen Sie Aufträge und Raubüberfälle aus, entwickeln Sie Ihren Charakter durch Schulzeugnisse, nehmen Sie an Live-Events teil und koordinieren Sie sich mit Ihrer Crew auf der Weltkarte. Faire Wettbewerbsregeln, langfristige Weiterentwicklung und regelmäßige Inhaltsaktualisierungen.';

  @override
  String get landingTopPlayersTitle => 'Top-Spieler';

  @override
  String get landingTopCrewsTitle => 'Top-Crews (Gebiet)';

  @override
  String get landingRankLabel => 'Rang';

  @override
  String get landingRegionsLabel => 'Regionen';

  @override
  String get landingLoadError =>
      'Die Rangliste konnte momentan nicht geladen werden.';

  @override
  String get landingEmptyLeaderboard => 'Noch keine Einträge.';

  @override
  String get landingCtaLogin => 'Einloggen';

  @override
  String get landingCtaRegister => 'Benutzerkonto erstellen';

  @override
  String get landingFooterPrivacy => 'Datenschutzrichtlinie';

  @override
  String get landingFooterTerms => 'Nutzungsbedingungen';

  @override
  String get landingFooterDigitalGoods => 'Kauf digitaler Waren';

  @override
  String get landingFooterLanguage => 'Sprache';

  @override
  String landingCopyright(int year) {
    return '© $year Der Mob State. Alle Rechte vorbehalten.';
  }

  @override
  String get legalPrivacyTitle => 'Datenschutzrichtlinie';

  @override
  String get legalPrivacyLastUpdated => 'Letzte Aktualisierung: Mai 2026';

  @override
  String get legalPrivacyIntro =>
      'In dieser Datenschutzrichtlinie wird erläutert, wie The Mob State („wir“, „uns“) mit personenbezogenen Daten umgeht, wenn Sie unsere Website, unser Webspiel und damit verbundene Dienste nutzen. Durch das Spielen oder Surfen stimmen Sie dieser Richtlinie zu, sofern geltendes Recht dies zulässt.';

  @override
  String get legalPrivacySection01Title => 'Wer wir sind';

  @override
  String get legalPrivacySection01Body =>
      'The Mob State ist ein Online-Spiel, das als digitaler Dienst betrieben wird. Für Datenschutzanfragen können Sie uns nach der Registrierung über das Support-Ticketsystem im Spiel oder über die offiziellen Kontaktkanäle der Website kontaktieren, sofern diese veröffentlicht wurden.';

  @override
  String get legalPrivacySection02Title => 'Daten, die wir sammeln';

  @override
  String get legalPrivacySection02Body =>
      'Wir können Kontodaten (Benutzername, E-Mail-Adresse, falls angegeben, gehashtes Passwort), Spiel- und Fortschrittsdaten, technische Protokolle (IP-Adresse, Geräte-/Browsertyp, Zeitstempel), zahlungsbezogene Referenzen unserer Zahlungsanbieter (wir speichern keine vollständigen Kartennummern) und Mitteilungen, die Sie an den Support senden, verarbeiten.';

  @override
  String get legalPrivacySection03Title => 'Zwecke';

  @override
  String get legalPrivacySection03Body =>
      'Wir verwenden Daten, um das Spiel bereitzustellen, Konten zu sichern, Missbrauch und Betrug zu verhindern, Einkäufe abzuwickeln, die Leistung zu verbessern, Servicenachrichten zu übermitteln und rechtliche Verpflichtungen einzuhalten.';

  @override
  String get legalPrivacySection04Title => 'Rechtsgrundlagen (EWR/UK)';

  @override
  String get legalPrivacySection04Body =>
      'Wo die DSGVO Anwendung findet, verlassen wir uns auf die Erfüllung eines Vertrags (Bereitstellung des Spiels), berechtigte Interessen (Sicherheit, Analyse, Produktverbesserung im Verhältnis zu Ihren Rechten), Einwilligung, sofern erforderlich (z. B. bestimmte Marketing-Cookies oder optionale Mitteilungen) und rechtliche Verpflichtungen.';

  @override
  String get legalPrivacySection05Title => 'Cookies und lokale Speicherung';

  @override
  String get legalPrivacySection05Body =>
      'Wir verwenden Cookies und ähnliche Technologien, um Sie angemeldet zu halten, Präferenzen zu speichern, die grundlegende Nutzung zu messen und wesentliche Funktionen bereitzustellen. Sie können viele Cookies über Ihre Browsereinstellungen steuern.';

  @override
  String get legalPrivacySection06Title => 'Zurückbehaltung';

  @override
  String get legalPrivacySection06Body =>
      'Wir bewahren Informationen so lange auf, wie es für den Betrieb des Dienstes und die Erfüllung gesetzlicher, steuerlicher und buchhalterischer Anforderungen erforderlich ist. Einige Protokolle werden möglicherweise für einen begrenzten Sicherheitszeitraum aufbewahrt. Wenn Daten nicht mehr benötigt werden, löschen oder anonymisieren wir sie, soweit möglich.';

  @override
  String get legalPrivacySection07Title => 'Teilen';

  @override
  String get legalPrivacySection07Body =>
      'Wir geben Daten nur dann an Infrastruktur- und Zahlungsabwickler weiter, wenn dies für die Ausführung des Dienstes im Rahmen entsprechender Vereinbarungen erforderlich ist. Wir verkaufen Ihre personenbezogenen Daten nicht. Wir können Informationen offenlegen, wenn dies gesetzlich vorgeschrieben ist oder um Rechte und Sicherheit zu schützen.';

  @override
  String get legalPrivacySection08Title => 'Internationale Überweisungen';

  @override
  String get legalPrivacySection08Body =>
      'Ihre Daten können im Europäischen Wirtschaftsraum und/oder anderen Regionen, in denen wir oder unsere Anbieter tätig sind, verarbeitet werden. Wo erforderlich, nutzen wir Schutzmaßnahmen wie Standardvertragsklauseln.';

  @override
  String get legalPrivacySection09Title => 'Ihre Rechte';

  @override
  String get legalPrivacySection09Body =>
      'Abhängig von Ihrem Standort haben Sie möglicherweise Rechte auf Zugriff, Berichtigung, Löschung, Einschränkung oder Einspruch gegen bestimmte Verarbeitungen sowie auf Datenübertragbarkeit. Sie können eine Beschwerde bei einer Aufsichtsbehörde einreichen. Kontaktieren Sie uns über den Support, um Ihre Rechte auszuüben; Möglicherweise müssen wir Ihre Identität überprüfen.';

  @override
  String get legalPrivacySection10Title => 'Kinder';

  @override
  String get legalPrivacySection10Body =>
      'Das Spiel richtet sich nicht an Kinder unter dem Alter, für dessen Verarbeitung in Ihrer Region die Zustimmung der Eltern erforderlich ist. Wenn Sie glauben, dass ein Kind Daten unrechtmäßig bereitgestellt hat, kontaktieren Sie uns und wir werden die entsprechenden Schritte einleiten.';

  @override
  String get legalDigitalGoodsTitle => 'Kauf digitaler Waren';

  @override
  String get legalDigitalGoodsLastUpdated => 'Letzte Aktualisierung: Mai 2026';

  @override
  String get legalDigitalGoodsIntro =>
      'Diese Richtlinie beschreibt den Kauf digitaler Inhalte und Dienste in The Mob State (z. B. Premium-Credits, VIP-Zeit oder andere virtuelle Gegenstände). Mit dem Abschluss eines Kaufs stimmen Sie diesen Bedingungen sowie allen bei der Zahlung angezeigten Checkout-Bedingungen zu.';

  @override
  String get legalDigitalGoodsSection01Title => 'Art digitaler Einkäufe';

  @override
  String get legalDigitalGoodsSection01Body =>
      'Bei allen Käufen handelt es sich um Zahlungen für den Zugang zu zusätzlichen Online-Funktionen und virtuellen Gegenständen innerhalb von The Mob State. Sie werden digital im Spiel bereitgestellt und haben keine physische Form.';

  @override
  String get legalDigitalGoodsSection02Title =>
      'Sofortige Lieferung und Widerruf (UK/EU)';

  @override
  String get legalDigitalGoodsSection02Body =>
      'Wenn die Consumer Contracts Regulations 2013 (UK) oder gleichwertige EU-Vorschriften gelten, erkennen Sie an, dass digitale Inhalte unmittelbar nach dem Kauf bereitgestellt werden und dass Sie, sofern gesetzlich zulässig, das gesetzliche 14-tägige Widerrufsrecht verlieren können, sobald mit der Lieferung mit Ihrer vorherigen ausdrücklichen Zustimmung begonnen wurde.';

  @override
  String get legalDigitalGoodsSection03Title =>
      'Rückerstattungen und Rückbuchungen';

  @override
  String get legalDigitalGoodsSection03Body =>
      'Bei digitalen Waren ist nach der Lieferung grundsätzlich keine Rückerstattung möglich, es sei denn, das zwingende Verbraucherrecht schreibt etwas anderes vor. Rückbuchungen oder Zahlungsstreitigkeiten nach der Lieferung können zur Sperrung oder Kündigung der entsprechenden Konten führen; Bitte wenden Sie sich zunächst an den Support, damit wir Ihnen bei der Lösung von Abrechnungsproblemen helfen können.';

  @override
  String get legalDigitalGoodsSection04Title => 'Erlaubnis und Alter';

  @override
  String get legalDigitalGoodsSection04Body =>
      'Für die Nutzung der gewählten Zahlungsart müssen Sie berechtigt sein. Wenn Sie unter 18 Jahre alt sind, benötigen Sie die Erlaubnis eines Elternteils oder Erziehungsberechtigten, um Einkäufe zu tätigen oder kostenpflichtige Dienste zu nutzen.';

  @override
  String get legalDigitalGoodsSection05Title => 'Zahlungskanäle und Gebühren';

  @override
  String get legalDigitalGoodsSection05Body =>
      'Die Preise können in Euro oder in der Währung Ihres Anbieters angezeigt werden. Mobilfunkanbieter oder Zahlungsplattformen können ihre eigenen Gebühren erheben; Erkundigen Sie sich bei Ihrem Anbieter, bevor Sie Zahlungen über den Mobilfunkanbieter oder das Wallet bestätigen.';

  @override
  String get legalDigitalGoodsSection06Title => 'Verfügbarkeit';

  @override
  String get legalDigitalGoodsSection06Body =>
      'Bezahlte Funktionen werden virtuell über unsere Server bereitgestellt und können sich im Laufe der Zeit ändern. Wir können bestimmte Artikel, Pakete oder Preise anpassen, aussetzen oder zurückziehen, um das Spiel auszugleichen oder aus technischen Gründen.';

  @override
  String get legalDigitalGoodsSection07Title => 'Kein realer Barwert';

  @override
  String get legalDigitalGoodsSection07Body =>
      'Virtuelle Gegenstände und Währungen haben außerhalb des Spiels keinen Geldwert, sind nicht gegen echtes Geld übertragbar und können im Rahmen von Aktualisierungen, Kontodurchsetzungen oder Diensteinstellung geändert oder entfernt werden, es sei denn, das Gesetz schreibt eine Entschädigung vor.';

  @override
  String get legalDigitalGoodsSection08Title =>
      'Verbotene kommerzielle Nutzung';

  @override
  String get legalDigitalGoodsSection08Body =>
      'Sie dürfen The Mob State nicht dazu nutzen, unbefugten Echtgeldhandel zu betreiben, einschließlich des Kaufs oder Verkaufs von Konten, Spielwährung, Codes oder virtuellen Vermögenswerten gegen Bargeld oder externe Dienstleistungen außerhalb unserer offiziellen Zahlungsströme.';

  @override
  String get legalDigitalGoodsSection09Title => 'Serviceänderungen';

  @override
  String get legalDigitalGoodsSection09Body =>
      'Wir können diese Richtlinie und Beschreibungen für In-Game-Käufe aktualisieren. Die fortgesetzte Nutzung nach Änderungen stellt die Annahme der überarbeiteten Bedingungen dar, sofern dies gesetzlich zulässig ist.';

  @override
  String get legalDigitalGoodsSection10Title => 'Geltendes Recht';

  @override
  String get legalDigitalGoodsSection10Body =>
      'Sofern nicht zwingendes lokales Recht etwas anderes vorsieht, unterliegt diese Richtlinie den Gesetzen von England und Wales und Streitigkeiten unterliegen der ausschließlichen Zuständigkeit der Gerichte von England und Wales.';

  @override
  String get registerTermsRequired =>
      'Um sich zu registrieren, müssen Sie die Nutzungsbedingungen akzeptieren.';

  @override
  String get registerTermsPrefix => 'Ich stimme dem zu';

  @override
  String get registerTermsLink => 'Nutzungsbedingungen';

  @override
  String get registerTermsSuffix => '.';

  @override
  String get legalTermsTitle => 'Nutzungsbedingungen';

  @override
  String get legalTermsLastUpdated => 'Letzte Aktualisierung: Mai 2026';

  @override
  String get legalTermsIntro =>
      'Diese Nutzungsbedingungen („Bedingungen“) regeln Ihren Zugriff auf und Ihre Nutzung der The Mob State-Website, des Webspiels und der damit verbundenen Dienste („Dienst“). Durch die Erstellung eines Kontos oder die Nutzung des Dienstes stimmen Sie diesen Bedingungen zusammen mit unserer Datenschutzrichtlinie und gegebenenfalls unserer Richtlinie zum Kauf digitaler Waren zu.';

  @override
  String get legalTermsSection01Title => 'Berechtigung und Konto';

  @override
  String get legalTermsSection01Body =>
      'Sie müssen das bei der Registrierung für Ihre Region angegebene Mindestalter erreichen. Sie sind dafür verantwortlich, korrekte Registrierungsinformationen anzugeben und Ihre Anmeldeinformationen vertraulich zu behandeln. Sie sind für die Aktivitäten unter Ihrem Konto verantwortlich, es sei denn, Sie benachrichtigen uns umgehend über den Support, wenn Sie einen unbefugten Zugriff vermuten.';

  @override
  String get legalTermsSection02Title => 'Lizenz zur Nutzung des Dienstes';

  @override
  String get legalTermsSection02Body =>
      'Wir gewähren Ihnen eine persönliche, nicht ausschließliche, nicht übertragbare und widerrufliche Lizenz für den Zugriff auf den Dienst und dessen Nutzung zu Unterhaltungszwecken im Einklang mit diesen Bedingungen. Alle nicht ausdrücklich gewährten Rechte bleiben vorbehalten.';

  @override
  String get legalTermsSection03Title => 'Akzeptable Verwendung';

  @override
  String get legalTermsSection03Body =>
      'Sie erklären sich damit einverstanden, nicht zu betrügen, Fehler zu unfairen Vorteilen auszunutzen, andere zu belästigen, Malware zu verbreiten, unsere Systeme ohne Erlaubnis zu manipulieren oder zu überlasten, sich als Mitarbeiter auszugeben oder den Dienst für rechtswidrige Zwecke zu nutzen. Wir können Meldungen untersuchen und Sanktionen verhängen, einschließlich Verwarnungen, Suspendierungen oder Kündigungen.';

  @override
  String get legalTermsSection04Title => 'Virtuelle Artikel und Zahlungen';

  @override
  String get legalTermsSection04Body =>
      'Für virtuelle Güter oder Funktionen sind möglicherweise optionale Käufe möglich. Für solche Käufe gelten unsere Richtlinien zum Kauf digitaler Waren und unsere Checkout-Bedingungen. Virtuelle Gegenstände haben außerhalb des Dienstes keinen realen Geldwert, sofern nicht zwingende Gesetze etwas anderes vorschreiben.';

  @override
  String get legalTermsSection05Title => 'Benutzerinhalte';

  @override
  String get legalTermsSection05Body =>
      'Wenn der Dienst Ihnen die Übermittlung von Texten, Bildern oder anderen Materialien ermöglicht, behalten Sie das Eigentumsrecht, das Sie bereits besitzen, gewähren uns jedoch eine Lizenz zum Hosten, Anzeigen und Moderieren dieser Inhalte, soweit dies für den Betrieb des Dienstes erforderlich ist. Sie müssen Rechte an allem haben, was Sie einreichen, und dürfen kein rechtswidriges oder rechtsverletzendes Material hochladen.';

  @override
  String get legalTermsSection06Title => 'Verfügbarkeit und Änderungen';

  @override
  String get legalTermsSection06Body =>
      'Wir bemühen uns, den Dienst verfügbar zu halten, garantieren jedoch keinen ununterbrochenen Zugriff. Wir können Funktionen aus Wartungs-, Balance-, rechtlichen oder Sicherheitsgründen ändern, aussetzen oder einstellen. Wir können diese Bedingungen aktualisieren; Die fortgesetzte Nutzung nach Benachrichtigung, soweit gesetzlich zulässig, stellt die Annahme wesentlicher Änderungen dar.';

  @override
  String get legalTermsSection07Title => 'Haftungsausschluss und Haftung';

  @override
  String get legalTermsSection07Body =>
      'Der Dienst wird „wie besehen“ im größtmöglichen gesetzlich zulässigen Umfang bereitgestellt. Sofern zulässig, schließen wir die Haftung für indirekte Schäden oder Folgeschäden aus. Nichts in diesen Bedingungen schränkt die Haftung ein, die nach geltendem zwingendem Verbraucherrecht nicht eingeschränkt werden kann.';

  @override
  String get legalTermsSection08Title => 'Beendigung';

  @override
  String get legalTermsSection08Body =>
      'Sie können die Nutzung des Dienstes jederzeit beenden. Wir können den Zugriff sperren oder beenden, wenn Sie gegen diese Bedingungen verstoßen, sofern dies gesetzlich vorgeschrieben ist oder um den Dienst oder andere Benutzer zu schützen. Bestimmungen, die von Natur aus fortbestehen sollten, überdauern auch die Beendigung.';

  @override
  String get legalTermsSection09Title => 'Geltendes Recht';

  @override
  String get legalTermsSection09Body =>
      'Sofern nicht zwingendes lokales Recht etwas anderes vorsieht, unterliegen diese Bedingungen den Gesetzen von England und Wales und Streitigkeiten unterliegen der ausschließlichen Zuständigkeit der Gerichte von England und Wales.';

  @override
  String get legalTermsSection10Title => 'Kontakt';

  @override
  String get legalTermsSection10Body =>
      'Bei Fragen zu diesen Bedingungen kontaktieren Sie uns nach der Registrierung über das Support-Ticketsystem im Spiel oder über die offiziellen Website-Kontaktkanäle, sofern veröffentlicht.';

  @override
  String get helpTopicTrainingHubCategory => 'Ausbildung';

  @override
  String get helpTopicTrainingHubTitle => 'Schulungszentrum';

  @override
  String get helpTopicTrainingHubSummary =>
      'Fitnessstudio (Kraft) und Schießstand (Präzision) an einem Ort. Beide Boni erhöhen Ihre Erfolgschance bei einem Verbrechen. Die Schussgenauigkeit wird auch bei Trefferlistenaktionen verwendet. Jeder Track hat seine eigene Abklingzeit und eine Obergrenze von 100 Sitzungen.';

  @override
  String get helpTopicTrainingHubHow =>
      'Fitnessstudio: Jede Sitzung erhöht Ihren permanenten Kraftbonus auf insgesamt bis zu +8 % (100 Sitzungen). Die Abklingzeit zwischen den Sitzungen beträgt 1 Stunde (VIP kann sie verkürzen).\nSchießstand: Jede Sitzung erhöht Ihren permanenten Genauigkeitsbonus auf insgesamt bis zu +10 % (100 Sitzungen). Die Abklingzeit zwischen den Sitzungen beträgt 1 Stunde (VIP kann sie verkürzen).\nBeide Boni werden vom Server in die Berechnung des Verbrechenserfolgs einbezogen.\nSie trainieren jede Strecke separat: zwei Timer und zwei Zugtasten – ein Bildschirm.\nDer Fortschritt wird nicht zurückgesetzt, es sei denn, das Personal verhängt eine schwere Strafe.';

  @override
  String get helpTopicTrainingHubTips =>
      'Planen Sie beide Tracks täglich: Kleine Schritte sorgen für einen klaren Vorsprung bei Verbrechen.\nÜberprüfen Sie Verbrechen, bei denen Sie am meisten scheitern: Stärke und Genauigkeit ergänzen sich – sie sind nicht derselbe Wert.';

  @override
  String territoryCapsLine(
    int owned,
    int maxRegions,
    int active,
    int maxContests,
  ) {
    return 'Regionen $owned/$maxRegions · Wettbewerbe $active/$maxContests';
  }

  @override
  String territoryCapsRegionsChip(int owned, int max) {
    return 'Regionen $owned/$max';
  }

  @override
  String territoryCapsContestsChip(int active, int max) {
    return 'Wettbewerbe $active/$max';
  }

  @override
  String get territoryDetailProject => 'Regionsprojekt';

  @override
  String get territoryProjectSafehouse => 'Safehouse-Netzwerk';

  @override
  String get territoryProjectStatusBuilding => 'Gebäude';

  @override
  String get territoryProjectStatusActive => 'Aktiv';

  @override
  String get territoryProjectStatusDamaged => 'Beschädigt';

  @override
  String get territoryProjectStatusDestroyed => 'Zerstört';

  @override
  String get territoryProjectProgress => 'Fortschritt';

  @override
  String get territoryProjectHp => 'Integrität';

  @override
  String territoryProjectIncomeBonusPct(int percent) {
    return '+$percent% passives Einkommen';
  }

  @override
  String get territoryProjectStart => 'Start safehouse project';

  @override
  String get territoryProjectContribute => 'Versorgungsprojekt';

  @override
  String territoryProjectHqRequired(int level) {
    return 'Erfordert HQ-Level $level';
  }

  @override
  String get territoryProjectHint =>
      'A safehouse network boosts passive income. Sabotage damages it in contests; supply runs repair or advance it.';

  @override
  String get territorySnackProjectStarted => 'Safehouse-Projekt gestartet.';

  @override
  String get territorySnackProjectContributed => 'Projekt aktualisiert.';

  @override
  String get territoryErrorProjectHq =>
      'Zum Starten dieses Projekts ist eine höhere HQ-Ebene erforderlich.';

  @override
  String get territoryErrorProjectNotOwner =>
      'Nur die steuernde Crew kann dieses Projekt verwalten.';

  @override
  String get territoryErrorProjectExists =>
      'Diese Region hat bereits ein Projekt.';

  @override
  String get territoryErrorProjectNotFound =>
      'Für diese Region wurde kein Projekt gefunden.';

  @override
  String get territoryErrorProjectDestroyed =>
      'Projekt zerstört – starten Sie ein neues.';

  @override
  String get territoryErrorProjectActive => 'Das Projekt ist bereits aktiv.';

  @override
  String get territoryErrorProjectCooldown =>
      'Der Projektvorrat befindet sich in der Abklingzeit.';

  @override
  String get territoryDramaTitle => 'Territorialdrama';

  @override
  String get territoryDramaHotContests => 'Heiße Wettbewerbe';

  @override
  String get territoryDramaRecentCaptures => 'Aktuelle Aufnahmen';

  @override
  String get territoryDramaRisingCrews => 'Aufsteigende Besatzungen';

  @override
  String get territoryDramaWarTheaters => 'Kriegsschauplätze';

  @override
  String get territoryDramaRegionEvents => 'Veranstaltungen in der Region';

  @override
  String get territoryDramaEmpty =>
      'Im Moment gibt es kein Live-Territoriumsdrama.';

  @override
  String get territoryDetailRegionEvent => 'Regionsveranstaltung';

  @override
  String get territoryEventPoliceOffensive => 'Offensive der Polizei';

  @override
  String get territoryEventHarborStrike => 'Hafenstreik';

  @override
  String get territoryEventBlackoutRumor => 'Blackout-Gerücht';

  @override
  String get launderSectionTitle => 'Geldwäsche';

  @override
  String launderSectionHint(int feePercent, int durationMinutes) {
    return 'Überweisen Sie Bargeld mit einer Gebühr von $feePercent % auf Ihre Bank. Dauert etwa $durationMinutes Minuten. Höhere FBI-Hitze bedeutet höheres Risiko einer Beschlagnahme.';
  }

  @override
  String get launderSectionCapHint =>
      'Verwenden Sie diese Option für Straßenbargeld über dem heutigen kostenlosen Einzahlungslimit.';

  @override
  String launderSeizeChance(String chance) {
    return 'Geschätzte Beschlagnahmungswahrscheinlichkeit: $chance %';
  }

  @override
  String launderActiveJob(String amount) {
    return 'Waschen läuft. Bankauszahlung bei Erfolg: $amount';
  }

  @override
  String launderJobCountdown(String time) {
    return 'Abgeschlossen in $time';
  }

  @override
  String launderCooldownCountdown(String time) {
    return 'Wieder verfügbar in $time';
  }

  @override
  String launderPreviewFee(int feePercent, String fee) {
    return 'Gebühr ($feePercent%): $fee €';
  }

  @override
  String launderPreviewPayout(String payout) {
    return 'Bankauszahlung bei Erfolg: $payout';
  }

  @override
  String get launderAmountLabel => 'Zu waschende Menge';

  @override
  String launderAmountRange(String min, String max) {
    return 'Min. $min · Max. $max pro Waschgang.';
  }

  @override
  String get launderStartButton => 'Beginnen Sie mit dem Waschen';

  @override
  String get launderStartedSuccess => 'Die Geldwäsche begann.';

  @override
  String get launderErrorCooldown => '„Geldwäsche“ ist in der Abklingzeit.';

  @override
  String get launderErrorActive => 'Ein Waschauftrag läuft bereits.';

  @override
  String launderErrorTooLow(String min) {
    return 'Der Betrag liegt unter dem Mindestwert ($min).';
  }

  @override
  String launderErrorTooHigh(String max) {
    return 'Betrag liegt über dem Höchstwert ($max).';
  }

  @override
  String get launderErrorInsufficientCash =>
      'Nicht genügend Bargeld vorhanden.';

  @override
  String get launderErrorDisabled => 'Geldwäsche ist deaktiviert.';

  @override
  String get launderErrorUnknown =>
      'Der Waschvorgang konnte nicht gestartet werden.';

  @override
  String get stockMarketTitle => 'Börse';

  @override
  String get stockMarketHint =>
      'Handeln Sie mit Bankgeld. Die Preise bewegen sich langsam – unabhängig von Krypto.';

  @override
  String get stockBankBalance => 'Kontostand';

  @override
  String get stockPortfolioValue => 'Portfoliowert';

  @override
  String get stockQuantity => 'Menge';

  @override
  String get stockPrice => 'Preis';

  @override
  String get stockHolding => 'Halten';

  @override
  String get stockValue => 'Wert';

  @override
  String get stockBuy => 'Kaufen';

  @override
  String get stockSell => 'Verkaufen';

  @override
  String get stockTradeSuccess => 'Handel abgeschlossen.';

  @override
  String get stockErrorInsufficientBalance => 'Nicht genügend Bankguthaben.';

  @override
  String get stockErrorInsufficientShares => 'Nicht genügend Aktien.';

  @override
  String get stockErrorPositionLimit => 'Positionslimit erreicht.';

  @override
  String get stockErrorDisabled => 'Der Aktienmarkt ist deaktiviert.';

  @override
  String get stockErrorUnknown => 'Der Handel ist gescheitert.';

  @override
  String get stockMarketLoadError =>
      'Der Aktienmarkt konnte nicht geladen werden.';

  @override
  String get stockMarketEmpty => 'Im Moment sind keine Ticker verfügbar.';

  @override
  String get stockMarketRetry => 'Wiederholen';

  @override
  String stockPositionsOpen(int count) {
    return 'Offene Stellen: $count';
  }

  @override
  String stockCashAvailable(String amount) {
    return 'Verfügbar zum Investieren: $amount';
  }

  @override
  String get propertyDevelopAction => 'Entwickeln';

  @override
  String get propertyDevelopedSuccess =>
      'Grundstückserschließung abgeschlossen.';

  @override
  String propertyDevelopedSuccessLevel(int level) {
    return 'Entwicklung abgeschlossen – Level $level.';
  }

  @override
  String get propertyDevelopConfirmTitle => 'Immobilie entwickeln?';

  @override
  String propertyDevelopConfirmBody(String cost, int level, int bonusPercent) {
    return 'Geben Sie $cost € von Ihrer Bank aus, um die Entwicklung auf Stufe $level zu erhöhen. Jede Stufe fügt +$bonusPercent % passives Einkommen hinzu.';
  }

  @override
  String get propertyDevelopLevel => 'Entwicklung';

  @override
  String get propertyDevelopIncomeBonusLabel => 'Entwickler-Einkommensbonus';

  @override
  String propertyDevelopIncomeBonus(int percent) {
    return '+$percent%';
  }

  @override
  String get propertyDevelopIncomeLabel => 'Passives Einkommen';

  @override
  String propertyDevelopActionCost(String cost, int level) {
    return 'Entwickeln · €$cost → L$level';
  }

  @override
  String propertyDevelopCooldown(String duration) {
    return 'Entwicklung verfügbar in $duration';
  }

  @override
  String propertyDevelopErrorCooldown(String duration) {
    return 'Abklingzeit der Entwicklung: $duration';
  }

  @override
  String get propertyDevelopErrorCooldownGeneric =>
      'Die Entwicklung befindet sich im Cooldown.';

  @override
  String get propertyDevelopErrorMaxLevel =>
      'Diese Immobilie befindet sich bereits in der maximalen Entwicklungsphase.';

  @override
  String get propertyDevelopErrorDisabled =>
      'Die Grundstückserschließung ist deaktiviert.';

  @override
  String get propertyDevelopInsufficientBalance =>
      'Nicht genügend Bankguthaben.';

  @override
  String get propertyDevelopErrorUnknown =>
      'Diese Immobilie konnte nicht bebaut werden.';

  @override
  String get helpTopicStockMarketCategory => 'Wirtschaft';

  @override
  String get helpTopicStockMarketTitle => 'Börse';

  @override
  String get helpTopicStockMarketSummary =>
      'Handeln Sie langsam laufende Aktien mit Bankgeld. Getrenntes System von Krypto.';

  @override
  String get helpTopicStockMarketHow =>
      'Öffnen Sie die Börse über das Dashboard. Sie sehen Ticker, den aktuellen Preis, Ihre Bestände und Ihren Kontostand. \nKaufen und verkaufen Sie sofort zum Serverpreis und belasten/kreditieren Sie Ihre Bank – nicht Bargeld. \nDie Preise bewegen sich langsam (ungefähr jede Minute) mit leichter zufälliger Drift und Mean-Reversion; Es gibt keinen externen Live-Feed. \nEs gibt eine maximale Anzahl offener Stellen. Krypto-Orders, -Regime und -Bestenlisten sind nicht Teil dieses Moduls.';

  @override
  String get helpTopicStockMarketTips =>
      'Halten Sie Reserven für Verbrechen/Reisen bereit – Aktien sind kein Notgeld. \nDiversifizieren Sie nicht blind über jeden Ticker hinweg: Das Positionslimit ist eng.';

  @override
  String get premiumUiAutoRenewActive => 'Automatische monatliche Verlängerung';

  @override
  String get premiumUiAutoRenewOff => 'Keine automatische Verlängerung';

  @override
  String get premiumUiCancelRenewal => 'Verlängerung abbrechen';

  @override
  String premiumUiCancelRenewalConfirm(String date) {
    return 'Zukünftige VIP-Gebühren stoppen? Ihr aktueller VIP bleibt bis $date aktiv.';
  }

  @override
  String get premiumUiCancelRenewalSuccess =>
      'Automatische Verlängerung abgebrochen.';

  @override
  String get premiumUiCancelRenewalFailed =>
      'Die automatische Verlängerung konnte nicht abgebrochen werden.';

  @override
  String get premiumUiGiftVip => 'Geschenk VIP';

  @override
  String get premiumUiGiftVipHint =>
      'Kaufen Sie 30 Tage Spieler-VIP für einen anderen Spieler.';

  @override
  String premiumUiGiftVipPrice(String price) {
    return 'Einmaliger Preis: $price (30 Tage, keine automatische Verlängerung).';
  }

  @override
  String get premiumUiGiftVipUsername => 'Benutzername des Empfängers';

  @override
  String get premiumUiGiftVipConfirm => 'Weiter zur Kasse';

  @override
  String get premiumUiGiftVipFailed =>
      'Der Checkout für VIP-Geschenke konnte nicht gestartet werden.';

  @override
  String get premiumUiPrestigeLabel => 'VIP-Prestige';

  @override
  String get premiumUiPrestigeNone => 'Keiner';

  @override
  String get premiumUiPrestigeBronze => 'Bronze';

  @override
  String get premiumUiPrestigeSilver => 'Silber';

  @override
  String get premiumUiPrestigeGold => 'Gold';

  @override
  String premiumUiPrestigeDays(int days) {
    return '$days lebenslange Tage';
  }

  @override
  String premiumUiPrestigeNext(int days, String tier) {
    return '$days Tage bis $tier';
  }

  @override
  String get premiumUiPrestigeMax => 'Maximales Prestige erreicht';

  @override
  String get premiumUiGiftCrewVip => 'Geschenk-Crew-VIP';

  @override
  String get premiumUiGiftCrewVipHint =>
      'Kaufen Sie 30 Tage Crew-VIP für eine beliebige Crew mit Namen. Einmaliges Geschenk – keine automatische Verlängerung für diese Crew.';

  @override
  String get premiumUiGiftCrewVipName => 'Name der Crew';

  @override
  String get premiumUiGiftCrewVipFailed =>
      'Der Checkout für Crew-VIP-Geschenke konnte nicht gestartet werden.';

  @override
  String get territoryOverlayContest => 'Wettbewerbsergebnisse';

  @override
  String get territoryOverlayProject => 'Projekte';

  @override
  String get territoryOverlayEvent => 'Veranstaltungen in der Region';

  @override
  String get territoryLegendPocket => 'Tasche (dünner Rand)';

  @override
  String get territoryLegendCluster => 'Cluster (dicker Rand)';

  @override
  String get territoryContestHudTitle => 'Wettbewerb';

  @override
  String territoryContestHudScore(int attacker, int defender) {
    return 'Punktzahl $attacker:$defender';
  }

  @override
  String get territoryProjectSurveillance => 'Überwachungsgitter';

  @override
  String get territoryProjectArmsCache => 'Waffenlager';

  @override
  String get territoryProjectPickTitle => 'Wählen Sie ein Regionsprojekt';

  @override
  String get territoryProjectPickSubtitle =>
      'Ein Projekt pro Region. Der Typ hängt von den strategischen Tags und der HQ-Ebene ab.';

  @override
  String get territoryProjectStartGeneric => 'Projekt starten';

  @override
  String get territoryProjectLockedTags =>
      'Benötigt passendes strategisches Tag';

  @override
  String territoryProjectLockedHq(int level) {
    return 'Erfordert HQ $level';
  }

  @override
  String get territoryProjectSafehouseDesc =>
      'Passiver Einkommensbonus in dieser Region.';

  @override
  String get territoryProjectSurveillanceDesc =>
      'Zusätzliche intel_scan-Punkte und kürzere Intel-Abklingzeit (Hafen/Airhub/Hauptstadt).';

  @override
  String get territoryProjectArmsCacheDesc =>
      'Zusätzliche Schlachtzugs- und Verteidigungspunkte (Industrie/Grenze).';

  @override
  String get territoryBonusRegionProject => 'Regionsprojekt';

  @override
  String get territoryErrorProjectInvalidType => 'Unbekannter Projekttyp.';

  @override
  String get territoryErrorProjectTagMismatch =>
      'Dieser Projekttyp passt nicht zu den strategischen Tags dieser Region.';

  @override
  String get territoryStatsTitle => 'Statistiken über Ihr Besatzungsgebiet';

  @override
  String get territoryStatsAllTime => 'Allzeit';

  @override
  String get territoryStatsSeason => 'Diese Saison';

  @override
  String get territoryStatsWon => 'Won';

  @override
  String get territoryStatsDefended => 'Verteidigt';

  @override
  String get territoryStatsLost => 'Verloren';

  @override
  String get territoryStatsContests => 'Wettbewerbe';

  @override
  String get territoryStatsHoldTotal => 'Haltezeit insgesamt';

  @override
  String get territoryStatsHoldCurrent => 'Aktueller Halt';

  @override
  String get territoryStatsOwnedNow => 'Jetzt im Besitz';

  @override
  String get territoryLeaderboardScopeAllTime => 'Allzeit';

  @override
  String get territoryLeaderboardScopeSeason => 'Jahreszeit';

  @override
  String territoryLeaderboardStatsLine(
    int won,
    int defended,
    int lost,
    String hold,
  ) {
    return 'W $won · D $defended · L $lost · halten $hold';
  }

  @override
  String territoryHoldDurationDaysHours(int days, int hours) {
    return '${days}d ${hours}h';
  }

  @override
  String territoryHoldDurationHoursMinutes(int hours, int minutes) {
    return '${hours}h ${minutes}m';
  }

  @override
  String territoryHoldDurationMinutes(int minutes) {
    return '${minutes}m';
  }

  @override
  String get countryPoliceStripTitle => 'Landespolizei';

  @override
  String get countryPoliceBandCalm => 'Ruhig';

  @override
  String get countryPoliceBandWatchful => 'Wachsam';

  @override
  String get countryPoliceBandHot => 'Heiß';

  @override
  String get countryPoliceBandLockdown => 'Lockdown';

  @override
  String countryPolicePressureValue(int pressure) {
    return '$pressure/100';
  }

  @override
  String countryPoliceEffectLine(int successPenalty, int arrestBonus) {
    return 'Crime-Erfolg −$successPenalty pp · Festnahme +$arrestBonus pp';
  }

  @override
  String get countryPoliceDisruptTitle => 'Polizeidruck stören';

  @override
  String get countryPoliceDisruptHint =>
      'Seltene Aktionen, die lokale Hitze kühlen. Fehlschlag erhöht Wanted und FBI-Hitze.';

  @override
  String get countryPoliceDisruptButton => 'Stören';

  @override
  String get countryPoliceDisruptCorruption => 'Korruption';

  @override
  String get countryPoliceDisruptCorruptionDesc =>
      'Schmiere Hände, um den Druck zu senken.';

  @override
  String get countryPoliceDisruptDistract => 'Ablenken';

  @override
  String get countryPoliceDisruptDistractDesc =>
      'Lenke die Stadt mit einem Ablenkungsmanöver ab.';

  @override
  String get countryPoliceDisruptRaid => 'Gegenrazzia';

  @override
  String get countryPoliceDisruptRaidDesc =>
      'Triff ein Depot, um ihre Reaktion zu stören.';

  @override
  String countryPoliceDisruptCost(String cost) {
    return 'Kosten €$cost';
  }

  @override
  String countryPoliceDisruptDropHint(int drop, int minutes) {
    return 'Druck −$drop · Cool ~${minutes}m';
  }

  @override
  String countryPoliceDisruptFailHint(int wanted, int fbi) {
    return 'Fehlschlag: +$wanted Wanted, +$fbi FBI';
  }

  @override
  String get countryPoliceDisruptSuccess =>
      'Druck gesunken. Die Straßen kühlen eine Weile ab.';

  @override
  String get countryPoliceDisruptFailed =>
      'Die Aktion scheiterte. Die Hitze stieg.';

  @override
  String get countryPoliceCoolActive => 'Abkühlung aktiv';

  @override
  String get countryPoliceDisabled => 'Landespolizei-Druck ist derzeit aus.';

  @override
  String drugsFacBuyFor(String price) {
    return 'Buy for $price';
  }

  @override
  String drugsFacRankLocked(String rank) {
    return 'You need rank $rank for this facility.';
  }

  @override
  String get drugsFacRankLockedShort => 'Rank too low';

  @override
  String get drugsFacNextUpgradeEducation =>
      'The next upgrade needs more Narcotics education.';

  @override
  String get drugsFacAutoSaleTitle => 'Darkweb auto-sale';

  @override
  String get drugsFacAutoSaleBody =>
      'Opt-in: periodically sells part of your storefront drugs for a fee plus heat. Off by default.';

  @override
  String get drugsFacAutoSaleOn => 'Auto-sale on';

  @override
  String get drugsFacAutoSaleOff => 'Auto-sale off';

  @override
  String get drugsOpenMaterials => 'Buy materials';

  @override
  String drugsHeatRaidHint(String percent) {
    return 'On collect there is a $percent% chance of a raid (you choose before loot).';
  }

  @override
  String get drugsHeatLowProfile => 'Low profile';

  @override
  String drugsHeatCashCool(String cost) {
    return 'Cool for $cost';
  }

  @override
  String get drugsHeatCoolDone => 'Heat cooled';

  @override
  String get drugsHeatCoolFailed => 'Cooling failed';

  @override
  String get drugsHeatShieldActive => 'Heat shield active';

  @override
  String get drugsHeatLowProfileActive => 'Low profile active';

  @override
  String get drugsRaidTitle => 'Police raid';

  @override
  String drugsRaidBody(String loss, String hours, String fine) {
    return 'Choose: lose $loss% of this batch, $hours hours of facility downtime, or a cash fine of €$fine.';
  }

  @override
  String get drugsRaidLose => 'Lose stock';

  @override
  String get drugsRaidDowntime => 'Shut the facility';

  @override
  String get drugsRaidCash => 'Pay the fine';

  @override
  String get drugsRaidResolved => 'Raid resolved';

  @override
  String get drugsRaidFailed => 'Raid choice failed';

  @override
  String drugsBestCountryHint(String country, String pct) {
    return 'Best price: $country ($pct%)';
  }

  @override
  String drugsNightclubBonusHint(String pct) {
    return 'Nightclub margin $pct%';
  }

  @override
  String get drugsCrewDepositAction => 'To crew storage';

  @override
  String get drugsCrewDepositDone => 'Moved to crew storage';

  @override
  String get drugsCrewDepositFailed => 'Crew deposit failed';

  @override
  String get drugsCutAllOneGrade => 'Cut all one grade down';

  @override
  String casinoErrMaxBet(String amount) {
    return 'Maximaleinsatz ist €$amount';
  }

  @override
  String get casinoFloorPublic => 'Public';

  @override
  String get casinoFloorVip => 'VIP';

  @override
  String get casinoFloorPrivate => 'Private';

  @override
  String casinoHouseRulesLine(String floor, String maxBet, String rake) {
    return '$floor · max. Einsatz €$maxBet · Rake $rake%';
  }

  @override
  String get casinoUpgradeFloor => 'Etage upgraden';

  @override
  String casinoUpgradeFloorTo(String floor, String cost) {
    return 'Upgrade auf $floor (€$cost)';
  }

  @override
  String get casinoUpgradeSuccess => 'Etage verbessert';

  @override
  String get casinoUpgradeFailed => 'Upgrade fehlgeschlagen';

  @override
  String get casinoStaffTitle => 'Personal';

  @override
  String get casinoStaffHire => 'Einstellen';

  @override
  String get casinoStaffFire => 'Entlassen';

  @override
  String get casinoStaffDealer => 'Dealer';

  @override
  String get casinoStaffSecurity => 'Security';

  @override
  String get casinoStaffPromoter => 'Promoter';

  @override
  String casinoStaffSalaryPerTick(String amount) {
    return 'Gehalt €$amount/Tick';
  }

  @override
  String get casinoStaffHireSuccess => 'Personal eingestellt';

  @override
  String get casinoStaffFireSuccess => 'Personal entlassen';

  @override
  String get casinoStaffHireFailed => 'Einstellung fehlgeschlagen';

  @override
  String get casinoStaffFireFailed => 'Entlassung fehlgeschlagen';

  @override
  String get casinoTotalRake => 'Gesamt-Rake:';

  @override
  String casinoLastRaid(String when) {
    return 'Letzter Raid: $when';
  }

  @override
  String casinoRaidDrain(String percent) {
    return 'Raid-Abfluss $percent%';
  }

  @override
  String casinoRaidDefense(String percent) {
    return 'Raid-Abwehr $percent%';
  }

  @override
  String get casinoNoStaffHired => 'Noch kein Personal';
}
