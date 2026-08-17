// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appTitle => 'Gra mafijna';

  @override
  String get login => 'Login';

  @override
  String get register => 'Rejestr';

  @override
  String get username => 'Nazwa użytkownika';

  @override
  String get password => 'Hasło';

  @override
  String get usernameLabel => 'NAZWA UŻYTKOWNIKA';

  @override
  String get passwordLabel => 'HASŁO';

  @override
  String get usernamePlaceholder => 'Nazwa użytkownika';

  @override
  String get passwordPlaceholder => 'Hasło';

  @override
  String get loginButton => 'LOGIN';

  @override
  String get registerButton => 'REJESTR';

  @override
  String get forgotPassword => 'Zapomniałeś hasła?';

  @override
  String get usernameRequired => 'Proszę wprowadzić nazwę użytkownika';

  @override
  String get passwordRequired => 'Proszę wprowadzić hasło';

  @override
  String get passwordTooShort => 'Hasło musi mieć co najmniej 6 znaków';

  @override
  String get invalidCredentials => 'Nieprawidłowa nazwa użytkownika lub hasło';

  @override
  String get loginSuccessful => 'Zaloguj się pomyślnie!';

  @override
  String get registrationSuccessful => 'Rejestracja pomyślna!';

  @override
  String get registerGenderTitle => 'Your character';

  @override
  String get registerGenderSubtitle =>
      'Tap a portrait — this sets your starter look and is saved to your account.';

  @override
  String get registerGenderMale => 'Male gangster';

  @override
  String get registerGenderFemale => 'Female gangster';

  @override
  String get genderRequired => 'Choose male or female to continue.';

  @override
  String get loginFailed => 'Logowanie nie powiodło się';

  @override
  String get emailLabel => 'E-MAIL';

  @override
  String get emailPlaceholder => 'E-mail';

  @override
  String get emailRequired => 'Proszę podać adres e-mail';

  @override
  String get emailInvalid => 'Proszę podać prawidłowy adres e-mail';

  @override
  String get forgotPasswordTitle => 'Zresetuj hasło';

  @override
  String get forgotPasswordDescription =>
      'Wpisz swój adres e-mail, a my wyślemy Ci link umożliwiający zresetowanie hasła.';

  @override
  String get resetPasswordButton => 'WYŚLIJ LINK RESETUJĄCY';

  @override
  String get emailSent => 'Zresetuj link wysłany! Sprawdź swój e-mail.';

  @override
  String get backToLogin => 'Powrót do logowania';

  @override
  String welcome(String username) {
    return 'Witamy, $username!';
  }

  @override
  String get dashboardTimeouts => 'Limity czasu';

  @override
  String get dashboardTimeoutCrime => 'Przestępczość';

  @override
  String get dashboardTimeoutJob => 'Praca';

  @override
  String get dashboardTimeoutTravel => 'Podróż';

  @override
  String get dashboardTimeoutVehicleTheft => 'Ukraść samochód';

  @override
  String get dashboardTimeoutBoatTheft => 'Ukraść łódź';

  @override
  String get dashboardTimeoutNightclubSeason => 'Sezon klubów nocnych';

  @override
  String get dashboardTimeoutAmmo => 'Kup naboje';

  @override
  String get dashboardTimeoutShootingRange => 'Strzelnica';

  @override
  String get dashboardTimeoutGym => 'Siłownia';

  @override
  String get dashboardInfoDrugsGrams => 'Narkotyki (gramy)';

  @override
  String get dashboardInfoNightclubs => 'Kluby nocne';

  @override
  String get dashboardInfoNightclubRevenue => 'Przychody klubu nocnego';

  @override
  String get dashboard => 'Panel';

  @override
  String get crimes => 'Zbrodnie';

  @override
  String get errorLoadingCrimes => 'Nie udało się wczytać przestępstw';

  @override
  String connectionError(String error) {
    return 'Błąd połączenia: $error';
  }

  @override
  String payRange(String min, String max) {
    return 'Zapłata: $min € - $max';
  }

  @override
  String requiresRank(String rank) {
    return 'Wymaga rangi $rank';
  }

  @override
  String get requiresVehicle => 'Wymaga pojazdu';

  @override
  String get federalCrimeWarning => '⚠️ Przestępczość Federalna – FBI Heat';

  @override
  String get crimePickpocketName => 'Kradzież kieszonkowa';

  @override
  String get crimePickpocketDesc => 'Kradnij portfele przechodniom';

  @override
  String get crimeShopliftName => 'Kradzieże w sklepach';

  @override
  String get crimeShopliftDesc => 'Ukraść towar ze sklepu';

  @override
  String get crimeStealBikeName => 'Ukraść rower';

  @override
  String get crimeStealBikeDesc => 'Ukraść rower ze stojaka';

  @override
  String get crimeCarTheftName => 'Kradzież samochodu';

  @override
  String get crimeCarTheftDesc => 'Ukraść zaparkowany samochód';

  @override
  String get crimeBurglaryName => 'Włamanie';

  @override
  String get crimeBurglaryDesc => 'Włamać się do domu';

  @override
  String get crimeRobStoreName => 'Napad na sklep';

  @override
  String get crimeRobStoreDesc => 'Okraść mały sklep';

  @override
  String get crimeMugPersonName => 'Rabunek';

  @override
  String get crimeMugPersonDesc => 'Obrabuj kogoś na ulicy';

  @override
  String get crimeStealCarPartsName => 'Kradnij części samochodowe';

  @override
  String get crimeStealCarPartsDesc =>
      'Kradnij części z zaparkowanych samochodów';

  @override
  String get crimeHijackTruckName => 'Porwanie ciężarówki';

  @override
  String get crimeHijackTruckDesc => 'Porwij ciężarówkę przewożącą towary';

  @override
  String get crimeAtmTheftName => 'Kradzież bankomatu';

  @override
  String get crimeAtmTheftDesc => 'Włamać się do bankomatu';

  @override
  String get crimeJewelryHeistName => 'Napad na biżuterię';

  @override
  String get crimeJewelryHeistDesc => 'Okraść jubilera';

  @override
  String get crimeVandalismName => 'Wandalizm';

  @override
  String get crimeVandalismDesc => 'Zniszczyć majątek za pieniądze';

  @override
  String get crimeGraffitiName => 'Graffiti';

  @override
  String get crimeGraffitiDesc => 'Rozpylaj graffiti dla lokalnych gangów';

  @override
  String get crimeDrugDealSmallName => 'Mały handel narkotykami';

  @override
  String get crimeDrugDealSmallDesc => 'Sprzedaj niewielką ilość narkotyków';

  @override
  String get crimeDrugDealLargeName => 'Duży handel narkotykami';

  @override
  String get crimeDrugDealLargeDesc => 'Sprzedaj dużą ilość narkotyków';

  @override
  String get crimeExtortionName => 'Wymuszenie';

  @override
  String get crimeExtortionDesc => 'Wyłudzaj pieniądze od lokalnych firm';

  @override
  String get crimeKidnappingName => 'Porwanie';

  @override
  String get crimeKidnappingDesc => 'Porwać kogoś dla okupu';

  @override
  String get crimeArsonName => 'Podpalenie';

  @override
  String get crimeArsonDesc => 'Podpalić budynek';

  @override
  String get crimeSmugglingName => 'Przemyt';

  @override
  String get crimeSmugglingDesc => 'Przemycaj towary przez granicę';

  @override
  String get crimeAssassinationName => 'Zamach';

  @override
  String get crimeAssassinationDesc => 'Dokonaj zabójstwa na zlecenie';

  @override
  String get crimeHackAccountName => 'Włamać się na konto';

  @override
  String get crimeHackAccountDesc => 'Włamać się na konto bankowe';

  @override
  String get crimeCounterfeitMoneyName => 'Fałszywe pieniądze';

  @override
  String get crimeCounterfeitMoneyDesc => 'Zarabiaj fałszywe pieniądze';

  @override
  String get crimeIdentityTheftName => 'Kradzież tożsamości';

  @override
  String get crimeIdentityTheftDesc =>
      'Ukraść czyjąś tożsamość w celu oszustwa';

  @override
  String get crimeRobArmoredTruckName => 'Napad na ciężarówkę opancerzoną';

  @override
  String get crimeRobArmoredTruckDesc => 'Obrabuj opancerzoną ciężarówkę';

  @override
  String get crimeArtTheftName => 'Kradzież dzieł sztuki';

  @override
  String get crimeArtTheftDesc => 'Kradnij cenne dzieła sztuki';

  @override
  String get crimeProtectionRacketName => 'Rakieta ochronna';

  @override
  String get crimeProtectionRacketDesc =>
      'Spraw, aby firmy płaciły pieniądze za ochronę';

  @override
  String get crimeCasinoHeistName => 'Napad na kasyno';

  @override
  String get crimeCasinoHeistDesc => 'Obrabować kasyno';

  @override
  String get crimeBankRobberyName => 'Napad na bank';

  @override
  String get crimeBankRobberyDesc => 'Obrabować bank';

  @override
  String get crimeStealYachtName => 'Ukraść jacht';

  @override
  String get crimeStealYachtDesc => 'Ukraść luksusowy jacht';

  @override
  String get crimeCorruptOfficialName => 'Urzędnik łapówek';

  @override
  String get crimeCorruptOfficialDesc => 'Przekupić urzędnika za przysługi';

  @override
  String get crimeEliminateWitnessName => 'Wyeliminuj świadka';

  @override
  String get crimeEliminateWitnessDesc => 'Wyeliminuj świadka przed rozprawą';

  @override
  String get crimeDiamondHeistName => 'Napad na diamentowy transport';

  @override
  String get crimeDiamondHeistDesc => 'Porwij transport surowca diamentowego';

  @override
  String get crimeEvidenceRoomHeistName => 'Napad na pokój z dowodami';

  @override
  String get crimeEvidenceRoomHeistDesc =>
      'Ukradnij dowody z federalnego magazynu';

  @override
  String get crimeMuseumHeistName => 'Napad na muzeum';

  @override
  String get crimeMuseumHeistDesc => 'Ukradnij cenne artefakty z muzeum';

  @override
  String get crimeBossAssassinationName => 'Zabójstwo rywalizującego bossa';

  @override
  String get crimeBossAssassinationDesc =>
      'Wyeliminuj przywódcę konkurencyjnej organizacji';

  @override
  String get crimeCriminalRecordWipeName => 'Wyczyść rejestr karny';

  @override
  String get tooltipCrimeRequiresTools => 'Wymagane narzędzia';

  @override
  String get tooltipCrimeRequiresVehicle => 'Wymagany pojazd';

  @override
  String get tooltipCrimeRequiresDrugs => 'Wymagane leki';

  @override
  String get tooltipCrimeHighValue => 'Operacja o wysokiej wartości';

  @override
  String get tooltipCrimeRequiresViolence => 'Wymagana przemoc';

  @override
  String get tooltipCrimeRequiresWeapon => 'Wymagana broń';

  @override
  String get tooltipCrimeRequirementsHeading => 'Wymagany:';

  @override
  String get crimeCriminalRecordWipeTooltip =>
      'Jeśli się powiedzie, wymazuje całą twoją kartotekę kryminalną. Dostępne tylko wtedy, gdy masz już wyroki skazujące.';

  @override
  String crimeErrorDrugsRequired(String quantity, String drugs) {
    return 'Potrzebujesz co najmniej ${quantity}g: $drugs';
  }

  @override
  String get jobs => 'Praca';

  @override
  String get errorLoadingJobs => 'Nie udało się załadować zadań';

  @override
  String get jobNewspaperDeliveryName => 'Dostawa gazet';

  @override
  String get jobNewspaperDeliveryDesc => 'Dostarczaj gazety wcześnie rano';

  @override
  String get jobCarWashName => 'Myjnia samochodowa';

  @override
  String get jobCarWashDesc => 'Myj samochody na myjni samochodowej';

  @override
  String get jobGroceryBaggerName => 'Bagażnik artykułów spożywczych';

  @override
  String get jobGroceryBaggerDesc => 'Półki magazynowe w supermarkecie';

  @override
  String get jobDishwasherName => 'Pomywaczka';

  @override
  String get jobDishwasherDesc => 'Zmywanie naczyń w restauracji';

  @override
  String get jobStreetSweeperName => 'Zamiatacz ulic';

  @override
  String get jobStreetSweeperDesc => 'Zamiataj ulice w czystości';

  @override
  String get jobPizzaDeliveryName => 'Dostawa pizzy';

  @override
  String get jobPizzaDeliveryDesc => 'Dostarczaj pizzę w mieście';

  @override
  String get jobTaxiDriverName => 'Taksówkarz';

  @override
  String get jobTaxiDriverDesc => 'Jedź taksówką po mieście';

  @override
  String get jobWarehouseWorkerName => 'Pracownik magazynu';

  @override
  String get jobWarehouseWorkerDesc => 'Praca w magazynie';

  @override
  String get jobConstructionWorkerName => 'Pracownik budowlany';

  @override
  String get jobConstructionWorkerDesc => 'Praca na budowie';

  @override
  String get jobBartenderName => 'Barman';

  @override
  String get jobBartenderDesc => 'Wlać piwo i wymieszać koktajle';

  @override
  String get jobSecurityGuardName => 'Strażnik';

  @override
  String get jobSecurityGuardDesc => 'Strzeż budynku';

  @override
  String get jobTruckDriverName => 'Kierowca ciężarówki';

  @override
  String get jobTruckDriverDesc => 'Prowadź ciężarówkę na długich dystansach';

  @override
  String get jobMechanicName => 'Mechanik';

  @override
  String get jobMechanicDesc => 'Naprawiaj samochody w garażu';

  @override
  String get jobElectricianName => 'Elektryk';

  @override
  String get jobElectricianDesc =>
      'Montujemy i naprawiamy instalacje elektryczne';

  @override
  String get jobPlumberName => 'Hydraulik';

  @override
  String get jobPlumberDesc => 'Napraw rury i hydraulikę';

  @override
  String get jobChefName => 'Szef kuchni';

  @override
  String get jobChefDesc => 'Gotuj w restauracji';

  @override
  String get jobParamedicName => 'Sanitariusz';

  @override
  String get jobParamedicDesc => 'Pomóż potrzebującym';

  @override
  String get jobProgrammerName => 'Programista';

  @override
  String get jobProgrammerDesc => 'Pisanie oprogramowania dla firm';

  @override
  String get jobAccountantName => 'Księgowy';

  @override
  String get jobAccountantDesc => 'Zarządzaj finansami firm';

  @override
  String get jobLawyerName => 'Prawnik';

  @override
  String get jobLawyerDesc => 'Broń klientów w sądzie';

  @override
  String get jobRealEstateAgentName => 'Agent nieruchomości';

  @override
  String get jobRealEstateAgentDesc => 'Sprzedam domy i budynki';

  @override
  String get jobStockbrokerName => 'Makler giełdowy';

  @override
  String get jobStockbrokerDesc => 'Handluj akcjami';

  @override
  String get jobDoctorName => 'Lekarz';

  @override
  String get jobDoctorDesc => 'Leczyć pacjentów w szpitalu';

  @override
  String get jobAirlinePilotName => 'Pilot';

  @override
  String get jobAirlinePilotDesc => 'Latać samolotami pasażerskimi';

  @override
  String jobSuccessChancePercent(String percent) {
    return '$percent% szans';
  }

  @override
  String jobXpRewardShort(String xp) {
    return '+$xp PD';
  }

  @override
  String jobPayRangeEuro(String min, String max) {
    return '€$min-€$max';
  }

  @override
  String get travel => 'Podróż';

  @override
  String get errorLoadingCountries => 'Nie udało się wczytać krajów';

  @override
  String get currentLocation => 'Aktualna lokalizacja';

  @override
  String get current => 'Aktualny';

  @override
  String get travelTo => 'Podróż';

  @override
  String travelCost(String amount) {
    return 'Koszt: $amount €';
  }

  @override
  String get travelJourneyTitle => 'Rozpocząć podróż?';

  @override
  String get travelRouteLabel => 'Trasa:';

  @override
  String travelLegsLabel(String count) {
    return 'Nogi: $count';
  }

  @override
  String travelCostPerLeg(String amount) {
    return 'Koszt za nogę: $amount €';
  }

  @override
  String travelTotalCost(String amount) {
    return 'Całkowity koszt: $amount €';
  }

  @override
  String travelCooldownPerLeg(String minutes) {
    return 'Czas odnowienia: $minutes min na nogę';
  }

  @override
  String get travelRiskPerLeg =>
      'Ryzyko: na nogę (może zostać uwięziony i utracić wszystkie dobra)';

  @override
  String get travelStart => 'Start';

  @override
  String travelInTransitTo(String country) {
    return 'W drodze do $country';
  }

  @override
  String travelLegProgress(String current, String total) {
    return 'Noga $current/$total';
  }

  @override
  String travelNextStop(String country) {
    return 'Następny przystanek: $country';
  }

  @override
  String get travelContinue => 'Kontynuować';

  @override
  String get travelCancelJourney => 'Anuluj podróż';

  @override
  String get travelJourneyCanceled => 'Podróż odwołana';

  @override
  String get travelNotInTransit => 'Nie jesteś w podróży.';

  @override
  String get travelDirect => 'Bezpośredni';

  @override
  String travelVia(String countries) {
    return 'przez $countries';
  }

  @override
  String travelLegsCount(String count) {
    return '$count nóg';
  }

  @override
  String jailRemainingMinutes(String minutes) {
    return 'Jesteś w więzieniu jeszcze przez $minutes minut';
  }

  @override
  String travelSuccessTo(String country) {
    return 'Podróż do $country!';
  }

  @override
  String travelConfiscated(String quantity, String item) {
    return '🚨 $quantity przedmiotów $item skonfiskowane!';
  }

  @override
  String travelDamaged(String item, String percent) {
    return '⚠️ $item uszkodzone ($percent% utraty wartości)!';
  }

  @override
  String get countryNetherlands => 'Niderlandy';

  @override
  String get countryBelgium => 'Belgia';

  @override
  String get countryGermany => 'Niemcy';

  @override
  String get countryFrance => 'Francja';

  @override
  String get countrySpain => 'Hiszpania';

  @override
  String get countryItaly => 'Włochy';

  @override
  String get countryUk => 'Zjednoczone Królestwo';

  @override
  String get countrySwitzerland => 'Szwajcaria';

  @override
  String get crew => 'Załoga';

  @override
  String get profile => 'Profil';

  @override
  String get logout => 'Wyloguj się';

  @override
  String get logOut => 'Wyloguj się';

  @override
  String get menu => 'Menu';

  @override
  String get account => 'Konto';

  @override
  String get userAccountMenuTooltip => 'Menu konta';

  @override
  String get messages => 'Wiadomości';

  @override
  String get noDirectMessagesYet => 'Nie ma jeszcze żadnych wiadomości';

  @override
  String get sendMessageToFriendsHint => 'Wyślij wiadomość do znajomych!';

  @override
  String errorLoadingConversations(String error) {
    return 'Błąd ładowania rozmów: $error';
  }

  @override
  String get messageSystemBadge => 'SYSTEM';

  @override
  String get messageSystemInboxPreview => 'Osiągnięcia i komunikaty systemowe';

  @override
  String get messageSystemThreadSubtitle =>
      'Osiągnięcia i komunikaty systemowe';

  @override
  String get messageSystemThreadEmptyDetail =>
      'Osiągnięcia i komunikaty systemowe pojawiają się tutaj automatycznie.';

  @override
  String get messageSendFirst => 'Wyślij pierwszą wiadomość!';

  @override
  String chatFriendRankLine(int rank) {
    return '★ Ranga $rank';
  }

  @override
  String errorLoadingMessages(String error) {
    return 'Błąd ładowania wiadomości: $error';
  }

  @override
  String get messageDeleteOwnOnly => 'Możesz usuwać tylko własne wiadomości';

  @override
  String get messageDeleteTitle => 'Usuń wiadomość';

  @override
  String get messageDeleteBody => 'Ta wiadomość zostanie trwale usunięta.';

  @override
  String get messageSendFailed => 'Nie udało się wysłać wiadomości';

  @override
  String get messageDeleteFailed => 'Nie udało się usunąć wiadomości';

  @override
  String get investigationWindowExpired =>
      'Upłynął okres dochodzenia (24 godziny).';

  @override
  String get investigationStartedInboxHint =>
      'Rozpoczęło się śledztwo. Sprawdź swoją skrzynkę odbiorczą, aby otrzymać raport detektywa.';

  @override
  String get investigationAlreadyInProgress =>
      'Dochodzenie to jest już w toku lub zostało zakończone.';

  @override
  String investigationStartFailed(String error) {
    return 'Nie udało się rozpocząć dochodzenia: $error';
  }

  @override
  String get investigationExpired => 'Dochodzenie wygasło';

  @override
  String get investigationStarted => 'Rozpoczęło się śledztwo';

  @override
  String get investigationStarting => 'Startowy...';

  @override
  String get startMurderInvestigation =>
      'Rozpocznij śledztwo w sprawie morderstwa';

  @override
  String get systemMessagesReadOnlyHint =>
      'Na wiadomości systemowe nie można odpowiedzieć';

  @override
  String get helpAndGuide => 'Pomoc i przewodnik';

  @override
  String get helpUiManualTitle => 'Instrukcja gry';

  @override
  String get helpUiSearchHint =>
      'Szukaj według modułu, wyjaśnienia lub wskazówki';

  @override
  String get helpUiTopicLabel => 'Temat';

  @override
  String get helpUiAllChip => 'Wszystko';

  @override
  String get helpUiNoResultsTitle => 'Nie znaleziono tematów';

  @override
  String get helpUiNoResultsBody =>
      'Zmień wyszukiwanie lub kategorię, aby ponownie zobaczyć wyniki.';

  @override
  String get helpUiHowItWorks => 'Jak to działa';

  @override
  String get helpUiTips => 'Porady';

  @override
  String get quickActions => 'Szybkie działania';

  @override
  String get liveEvents => 'Wydarzenia na żywo';

  @override
  String get support => 'Wsparcie';

  @override
  String get events => 'Wydarzenia';

  @override
  String get aviation => 'Lotnictwo';

  @override
  String get premiumAndCredits => 'Premie i kredyty';

  @override
  String get bank => 'Bank';

  @override
  String get tradeGoods => 'Towary handlowe';

  @override
  String get drugs => 'Narkotyki';

  @override
  String get nightclub => 'Klub nocny';

  @override
  String get crypto => 'Krypto';

  @override
  String get smuggling => 'Przemyt';

  @override
  String get tools => 'narzędzia';

  @override
  String get vehicleHeist => 'Napad na pojazd';

  @override
  String get vehicleHeistTitle => 'Napad na pojazd';

  @override
  String get vehicleHeistTabSubtitleCar =>
      'Kradnij samochody za gotówkę i części.';

  @override
  String get vehicleHeistTabSubtitleMotorcycle =>
      'Kradnij motocykle za gotówkę i części.';

  @override
  String get vehicleHeistTabSubtitleBoat =>
      'Kradnij łodzie w zamian za gotówkę i części.';

  @override
  String get vehicleHeistReady => 'Gotowy';

  @override
  String get vehicleHeistMotorStorage => 'Przechowywanie motocykli';

  @override
  String get vehicleHeistCapacityPolicyCar =>
      'Pojemność samochodu jest wspólna dla wszystkich napadów na samochody.';

  @override
  String get vehicleHeistCapacityPolicyMotorcycle =>
      'Pojemność motocykli jest wspólna dla wszystkich napadów na motocykle.';

  @override
  String get vehicleHeistCapacityPolicyBoat =>
      'Pojemność łodzi jest wspólna dla wszystkich napadów na łodzie.';

  @override
  String vehicleHeistRankRequired(String rank) {
    return 'Wymagana ranga: $rank';
  }

  @override
  String vehicleHeistCapacityLine(String stored, String total, String level) {
    return 'Przechowywanie: $stored/$total (poziom linii $level)';
  }

  @override
  String get vehicleHeistStealCar => 'Ukraść samochód';

  @override
  String get vehicleHeistStealMotorcycle => 'Ukraść motocykl';

  @override
  String get vehicleHeistStealBoat => 'Ukraść łódź';

  @override
  String get vehicleHeistGenericVehicle => 'pojazd';

  @override
  String vehicleHeistSuccessStolen(String vehicle) {
    return 'Sukces: $vehicle skradzione.';
  }

  @override
  String vehicleHeistCooldownActive(String duration) {
    return 'Aktywny czas odnowienia: $duration';
  }

  @override
  String vehicleHeistArrested(String minutes) {
    return 'Zostałeś aresztowany ($minutes min więzienia).';
  }

  @override
  String get vehicleHeistUntil => 'dopóki';

  @override
  String get vehicleHeistRegionalLockActive => 'Blokada regionalna aktywna.';

  @override
  String get vehicleHeistStealFailed => 'Akcja kradzieży nie powiodła się.';

  @override
  String get vehicleHeistUpgradeCompleted => 'Aktualizacja zakończona.';

  @override
  String get vehicleHeistUpgradeFailed => 'Aktualizacja nie powiodła się.';

  @override
  String get vehicleHeistCatalogTitleCars => 'Dostępne samochody';

  @override
  String get vehicleHeistCatalogTitleMotorcycles => 'Dostępne motocykle';

  @override
  String get vehicleHeistCatalogTitleBoats => 'Dostępne łodzie';

  @override
  String get vehicleHeistCatalogEmpty => 'Brak pojazdów w tym katalogu.';

  @override
  String get vehicleHeistRarityCommon => 'Wspólny';

  @override
  String get vehicleHeistRarityUncommon => 'Niezwykły';

  @override
  String get vehicleHeistRarityRare => 'Rzadki';

  @override
  String get vehicleHeistRarityEpic => 'Epicki';

  @override
  String get vehicleHeistRarityLegendary => 'Legendarny';

  @override
  String get vehicleHeistEventOnlyTag => 'Tylko wydarzenie';

  @override
  String vehicleHeistCatalogValue(String value) {
    return 'Wartość: $value';
  }

  @override
  String vehicleHeistCatalogRank(String rank) {
    return 'Ranga: $rank';
  }

  @override
  String vehicleHeistCatalogInGameAvailability(String label) {
    return 'Dostępność w grze: $label';
  }

  @override
  String vehicleHeistCatalogMostCommonIn(String country) {
    return 'Najczęściej w: $country';
  }

  @override
  String vehicleHeistCatalogCountries(String countries) {
    return 'Kraje: $countries';
  }

  @override
  String vehicleHeistUpgradeCost(String cost) {
    return 'Uaktualnij ($cost)';
  }

  @override
  String vehicleHeistUpgradeRankRequired(String rank) {
    return 'Uaktualnienie zablokowane: wymagana ranga $rank';
  }

  @override
  String get vehicleHeistUpgradeLocked => 'Aktualizacja zablokowana';

  @override
  String vehicleHeistSpeedUpWithCredits(String credits) {
    return 'Przyspiesz za $credits kredytów';
  }

  @override
  String get vehicleHeistSpeedUpWithCreditsNextScreen =>
      'Przyspieszenie (następny ekran)';

  @override
  String get vehicleHeistExpand => 'Zwiększać';

  @override
  String get vehicleHeistCollapse => 'Zawalić się';

  @override
  String get vehicleHeistActive => 'AKTYWNY';

  @override
  String get vehicleHeistOff => 'wyłączony';

  @override
  String get catalog => 'Katalog';

  @override
  String get vehicleHeistOpsHotspotRunButton => 'Uruchom Hotspot';

  @override
  String get vehicleHeistOpsHotspotRunTitle => 'Bieg z hotspotem';

  @override
  String vehicleHeistOpsHotspotSuccess(String reward) {
    return 'Zakończono uruchamianie hotspotu: +$reward';
  }

  @override
  String vehicleHeistOpsHotspotCooldownActive(String duration) {
    return 'Aktywny czas odnowienia hotspotu ($duration)';
  }

  @override
  String get vehicleHeistOpsHotspotFailedHeatIncreased =>
      'Hotspot nie powiódł się. Zwiększone ciepło.';

  @override
  String get vehicleHeistOpsCrewOpButton => 'Crew op';

  @override
  String get vehicleHeistOpsCrewOpTitle => 'Crew op';

  @override
  String vehicleHeistOpsCrewSuccess(String reward) {
    return 'Operacja załogi zakończona: zdobyłeś $reward';
  }

  @override
  String get vehicleHeistOpsCrewRequired => 'Wymagana Crew.';

  @override
  String vehicleHeistOpsCrewCooldownActive(String duration) {
    return 'Aktywny czas odnowienia operacji załogi ($duration)';
  }

  @override
  String get vehicleHeistOpsCrewFailed => 'Operacja załogi nie powiodła się.';

  @override
  String get vehicleHeistOpsCrewJoinToUnlock =>
      'Dołącz do załogi, aby odblokować działania załogi';

  @override
  String get vehicleHeistOpsCrewRequiredYes => 'Wymagana Crew: tak';

  @override
  String get vehicleHeistOpsCrewRequiredNoJoinFirst =>
      'Wymagana Crew: nie (najpierw dołącz do załogi)';

  @override
  String get vehicleHeistOpsBuyPartsButton => 'Kup części';

  @override
  String get vehicleHeistOpsBuyPartsTitle => 'Kup części';

  @override
  String vehicleHeistOpsBuyPartsPrompt(String type) {
    return 'Kupić jakie części? ($type)';
  }

  @override
  String vehicleHeistOpsPartsPurchased(String cost) {
    return 'Zakupione części: -$cost';
  }

  @override
  String get vehicleHeistOpsPartsPurchaseFailed =>
      'Zakup części nie powiódł się.';

  @override
  String get vehicleHeistOpsClaimContractButton => 'Umowa reklamacyjna';

  @override
  String get vehicleHeistOpsClaimContractTitle => 'Umowa reklamacyjna';

  @override
  String vehicleHeistOpsChopContractCompleted(String reward) {
    return 'Ukończony kontrakt: +$reward';
  }

  @override
  String get vehicleHeistOpsChopNoEligibleVehicle =>
      'Brak kwalifikującego się pojazdu w ofercie dla tego kontraktu.';

  @override
  String vehicleHeistOpsChopContractCooldownActive(String duration) {
    return 'Aktywny czas odnowienia kontraktu ($duration)';
  }

  @override
  String get vehicleHeistOpsChopContractClaimFailed =>
      'Roszczenie z umowy nie powiodło się.';

  @override
  String get vehicleHeistOpsInsuranceButton => 'Ubezpieczenie';

  @override
  String get vehicleHeistOpsInsuranceTitle => 'Ubezpieczenie kontrabandy';

  @override
  String get vehicleHeistOpsInsuranceBody =>
      'Wybierz poziom ubezpieczenia dla tej kategorii pojazdu.';

  @override
  String get vehicleHeistOpsInsuranceTierBasic => 'Podstawowy';

  @override
  String get vehicleHeistOpsInsuranceTierPro => 'Zawodowiec';

  @override
  String vehicleHeistOpsInsuranceActive(String tier, String price) {
    return 'Ubezpieczenie aktywne ($tier) przez $price.';
  }

  @override
  String get vehicleHeistOpsInsurancePurchaseFailed =>
      'Zakup ubezpieczenia nie powiódł się.';

  @override
  String get vehicleHeistOpsCrewMatchButton => 'Mecz załogi';

  @override
  String vehicleHeistOpsCrewMatchWon(String reward) {
    return 'Wygrany mecz załogi: +$reward';
  }

  @override
  String vehicleHeistOpsCrewMatchLost(String reward) {
    return 'Przegrany mecz załogi: +$reward pocieszenia';
  }

  @override
  String get vehicleHeistOpsCrewMatchFailed =>
      'Dobieranie załogi nie powiodło się.';

  @override
  String get vehicleHeistOpsCounterButton => 'Lada';

  @override
  String vehicleHeistOpsCounterSuccess(String reward) {
    return 'Sukces w kontrataku: +$reward';
  }

  @override
  String get vehicleHeistOpsCounterFailed =>
      'Kontraprzechwyt jest niedostępny lub nie powiódł się.';

  @override
  String get vehicleHeistOpsOpsContractButton => 'Umowa op';

  @override
  String get vehicleHeistOpsOpsContractTitle => 'Umowa op';

  @override
  String vehicleHeistOpsContractCompleted(String reward) {
    return 'Ukończono kontrakt operacyjny: +$reward';
  }

  @override
  String get vehicleHeistOpsContractFailedOrCooldown =>
      'Kontrakt operacyjny nie powiódł się lub jest w trakcie odnowienia.';

  @override
  String get vehicleHeistOpsClaimDisputeButton => 'Spór dotyczący roszczenia';

  @override
  String get vehicleHeistOpsNoOpenClaims =>
      'Brak otwartych roszczeń ubezpieczeniowych.';

  @override
  String get vehicleHeistOpsNoValidClaimFound =>
      'Nie znaleziono ważnego roszczenia.';

  @override
  String vehicleHeistOpsClaimApproved(String amount) {
    return 'Roszczenie uznane: +$amount';
  }

  @override
  String vehicleHeistOpsClaimRejected(String amount) {
    return 'Roszczenie odrzucone: -$amount';
  }

  @override
  String get vehicleHeistOpsClaimResolutionFailed =>
      'Rozpatrzenie roszczenia nie powiodło się.';

  @override
  String get vehicleHeistOpsIntelTitle => 'Dane wywiadowcze pojazdów';

  @override
  String get vehicleHeistOpsIntelRefreshTooltip => 'Odśwież inteligencję';

  @override
  String get vehicleHeistOpsIntelTapToExpand =>
      'Kliknij, aby rozwinąć i wyświetlić wszystkie działania.';

  @override
  String vehicleHeistOpsIntelHeatPill(String current, String level) {
    return 'Ciepło $current ($level)';
  }

  @override
  String vehicleHeistOpsIntelPolicePill(String name) {
    return 'Policja: $name';
  }

  @override
  String vehicleHeistOpsIntelRepPill(String level) {
    return 'Poziom reprezentacji $level';
  }

  @override
  String vehicleHeistOpsIntelPartsMarketPill(String trend) {
    return 'Rynek części: $trend';
  }

  @override
  String vehicleHeistOpsIntelHotspotLine(String name) {
    return 'Hotspot: $name';
  }

  @override
  String vehicleHeistOpsIntelHotspotRewardLine(String min, String max) {
    return 'Nagroda: $min - $max';
  }

  @override
  String get vehicleHeistOpsIntelWhyCashLine =>
      'Dlaczego otrzymujesz gotówkę: udane akcje operacyjne wypłacają pieniądze bezpośrednio do portfela.';

  @override
  String vehicleHeistOpsIntelCashRangePayout(String min, String max) {
    return 'Gotówka: $min - $max';
  }

  @override
  String vehicleHeistOpsIntelYouCashRangePayout(String min, String max) {
    return 'Ty: $min - $max';
  }

  @override
  String vehicleHeistOpsIntelCashPayout(String amount) {
    return 'Gotówka: $amount';
  }

  @override
  String vehicleHeistOpsIntelContractsPayout(String count, String fromPart) {
    return 'Kontrakty: $count$fromPart';
  }

  @override
  String vehicleHeistOpsIntelContractsFrom(String amount) {
    return '| od $amount';
  }

  @override
  String vehicleHeistOpsIntelPartsPricesLine(
    String car,
    String motorcycle,
    String boat,
  ) {
    return 'Ceny części (samochód/motocykl/łódka): $car / $motorcycle / $boat';
  }

  @override
  String vehicleHeistOpsIntelPartsMarketRefreshLine(String cooldown) {
    return 'Odświeżenie rynku części: $cooldown';
  }

  @override
  String vehicleHeistOpsIntelCrewLine(String name, String size) {
    return 'Crew: $name ($size członków)';
  }

  @override
  String vehicleHeistOpsIntelChopRewardLine(String reward) {
    return 'Nagroda za kontrakt Chop: $reward';
  }

  @override
  String vehicleHeistOpsIntelInterceptWindowLine(String status) {
    return 'Okno przechwytujące: $status';
  }

  @override
  String vehicleHeistOpsIntelBlacklistLine(String reason) {
    return 'Czarna lista: $reason';
  }

  @override
  String get vehicleHeistOpsIntelBlacklistNoneLine => 'Czarna lista: brak';

  @override
  String vehicleHeistOpsIntelInsuranceActiveLine(String tier) {
    return 'Ubezpieczenie: $tier aktywne';
  }

  @override
  String get vehicleHeistOpsIntelInsuranceInactiveLine =>
      'Ubezpieczenie: nieaktywne';

  @override
  String vehicleHeistOpsIntelCountryModifierLine(
    String name,
    String multiplier,
  ) {
    return 'Modyfikator kraju: $name (${multiplier}x)';
  }

  @override
  String vehicleHeistOpsIntelCrewSeasonLine(String season, String points) {
    return 'Sezon załogi: $season | punkty $points';
  }

  @override
  String vehicleHeistOpsIntelContractsCooldownLine(
    String count,
    String cooldown,
  ) {
    return 'Kontrakty: $count | czas odnowienia $cooldown';
  }

  @override
  String vehicleHeistOpsIntelCounterCooldownLine(
    String cooldown,
    String claims,
  ) {
    return 'Czas odnowienia licznika: $cooldown | otwarte roszczenia: $claims';
  }

  @override
  String get tuneShop => 'Sklep tuningowy';

  @override
  String get tuneShopIntro =>
      'Złomuj pojazdy na części i ulepszaj prędkość, niewidzialność i pancerz. Części są podzielone według kategorii (samochód/motocykl/łódka), dzięki czemu możesz dostroić dowolny pojazd w tej samej kategorii.';

  @override
  String get tuneShopCarPartsLabel => 'Części samochodowe';

  @override
  String get tuneShopMotorcyclePartsLabel => 'Części motocyklowe';

  @override
  String get tuneShopBoatPartsLabel => 'Części łodzi';

  @override
  String get tuneShopEmptyTitle => 'Brak pojazdów do tuningu';

  @override
  String get tuneShopEmptyBody =>
      'Najpierw ukradnij kilka pojazdów, a kilka zezłomuj na części.';

  @override
  String get tuneShopVehicleTypeCar => 'Samochód';

  @override
  String get tuneShopVehicleTypeMotorcycle => 'Motocykl';

  @override
  String get tuneShopVehicleTypeBoat => 'Łódź';

  @override
  String get tuneShopStatSpeed => 'Prędkość';

  @override
  String get tuneShopStatStealth => 'Podstęp';

  @override
  String get tuneShopStatArmor => 'Zbroja';

  @override
  String get tuneShopValueMultiplierPrefix => 'Wartość x';

  @override
  String get tuneShopUpgradeButton => 'Aktualizacja';

  @override
  String get tuneShopMaxLabel => 'MAKS';

  @override
  String get tuneShopPartsAbbrev => 'pkt';

  @override
  String get tuneShopUpgradeCompleted => 'Aktualizacja zakończona';

  @override
  String get tuneShopUpgradeFailed => 'Aktualizacja nie powiodła się';

  @override
  String get tuneShopLockedVehicleInTransit =>
      'Strojenie zablokowane: pojazd jest w transporcie.';

  @override
  String get tuneShopLockedVehicleInRepair =>
      'Strojenie zablokowane: pojazd jest w naprawie.';

  @override
  String tuneShopLockedCooldownActive(String duration) {
    return 'Aktywny czas odnowienia strojenia: pozostało $duration.';
  }

  @override
  String get tuneShopErrorVehicleNotFound => 'Nie znaleziono pojazdu';

  @override
  String get tuneShopErrorNotOwner => 'Nie jesteś właścicielem tego pojazdu';

  @override
  String get tuneShopErrorVehicleInTransit =>
      'Strojenie zablokowane: pojazd jest w transporcie.';

  @override
  String get tuneShopErrorVehicleInRepair =>
      'Strojenie zablokowane: pojazd jest w naprawie.';

  @override
  String get tuneShopErrorInsufficientFunds => 'Za mało pieniędzy';

  @override
  String get tuneShopErrorInsufficientParts => 'Za mało części';

  @override
  String get tuneShopErrorStatMaxed => 'Ten poziom strojenia jest maksymalny';

  @override
  String tuneShopErrorCooldownActive(String duration) {
    return 'Aktywny czas odnowienia strojenia: pozostało $duration.';
  }

  @override
  String tuneShopErrorConcurrencyLimit(String max, String active) {
    return 'Osiągnięto limit: maks. $max jednoczesne strojenie, obecnie $active.';
  }

  @override
  String get tuneShopErrorInvalidStat => 'Nieprawidłowa statystyka strojenia';

  @override
  String get territory => 'Terytorium';

  @override
  String get achievements => 'Osiągnięcia';

  @override
  String get menuCrackVault => 'Złam skarbiec';

  @override
  String get vaultHeroTagline => 'Odgadnij kod i wygraj duże nagrody.';

  @override
  String vaultSeasonLabel(String range) {
    return 'Sezon: $range';
  }

  @override
  String get vaultYourCredits => 'Twoje kredyty';

  @override
  String get vaultChooseStake => 'Wybierz swoją stawkę';

  @override
  String vaultStakeCredits(int stake) {
    String _temp0 = intl.Intl.pluralLogic(
      stake,
      locale: localeName,
      other: '$stake kredytów',
      one: '$stake kredyt',
    );
    return '$_temp0';
  }

  @override
  String vaultExpectedPrize(int reward) {
    return 'Oczekiwana nagroda: +$reward kredytów';
  }

  @override
  String get vaultCodeLabel => 'Kod';

  @override
  String get vaultSubmitStake => 'Prześlij stawkę';

  @override
  String get vaultWrongCodesTitle => 'Błędne kody (w tym miesiącu)';

  @override
  String get vaultShowWrongCodes => 'Pokaż';

  @override
  String get vaultHideWrongCodes => 'Ukryj';

  @override
  String get vaultNoWrongCodesYet =>
      'Nie zapisano jeszcze żadnych błędnych kodów.';

  @override
  String get couldNotLoadVaultStatus => 'Nie udało się wczytać stanu.';

  @override
  String get vaultEnterFourDigitCode => 'Wprowadź 4-cyfrowy kod.';

  @override
  String get vaultAttemptSuccessGeneric => 'Sukces.';

  @override
  String get vaultAttemptFailedGeneric => 'Niepowodzenie.';

  @override
  String get vaultAttemptFailedRetry => 'Niepowodzenie. Spróbuj ponownie.';

  @override
  String dashboardNewMessagesCount(int count) {
    return '$count nowe wiadomości';
  }

  @override
  String get rankProgress => 'Postęp w rankingu';

  @override
  String get cash => 'Gotówka';

  @override
  String get sessionRecap => 'Podsumowanie sesji';

  @override
  String get nameLabel => 'Nazwa';

  @override
  String get countryLabel => 'Kraj';

  @override
  String get wantedLevel => 'Poszukiwany poziom';

  @override
  String get fbiHeat => 'Temperatura FBI';

  @override
  String get properties => 'Właściwości';

  @override
  String get vehicles => 'Pojazdy';

  @override
  String get netWorth => 'Wartość netto';

  @override
  String get securityLabel => 'Bezpieczeństwo';

  @override
  String get noSecurity => 'Brak zabezpieczeń';

  @override
  String get weaponLabel => 'Broń';

  @override
  String get vehicleLabel => 'Pojazd';

  @override
  String get none => 'Nic';

  @override
  String get statistics => 'Statystyka';

  @override
  String get breakouts => 'Wypryski';

  @override
  String get murders => 'Morderstwa';

  @override
  String get hitlistContracts => 'Umowy z listą przebojów';

  @override
  String get carsStolen => 'Kradzież samochodów';

  @override
  String get boatsStolen => 'Skradziono łodzie';

  @override
  String get crimeAttempts => 'Próby przestępcze';

  @override
  String get successful => 'Udany';

  @override
  String get jobAttempts => 'Próby pracy';

  @override
  String get streetProstitutes => 'Prostytutki uliczne';

  @override
  String get rldProstitutes => 'prostytutki RLD';

  @override
  String get travels => 'Podróże';

  @override
  String get bullets => 'Kule';

  @override
  String get moneyStatusLabel => 'Stan pieniędzy';

  @override
  String get moneyStatusPoor => 'Słaby';

  @override
  String get moneyStatusRising => 'Rosnący';

  @override
  String get moneyStatusRich => 'Bogaty';

  @override
  String get moneyStatusMultimillionaire => 'Multimilioner';

  @override
  String get rankBeginner => 'Początkujący';

  @override
  String get rankCriminal => 'Przestępca';

  @override
  String get rankGangster => 'Gangster';

  @override
  String get rankMafioso => 'Mafioso';

  @override
  String get rankGodfather => 'Ojciec chrzestny';

  @override
  String get dailyGoalTitle_crime_3 => 'Dokonaj 3 przestępstw';

  @override
  String get dailyGoalTitle_job_2 => 'Pracuj 2 razy';

  @override
  String get dailyGoalTitle_vehicle_theft_1 => 'Ukradnij 1 pojazd';

  @override
  String get dailyGoalTitle_travel_1 => 'Ukończ 1 podróż';

  @override
  String get dailyGoalTitle_weekly_crime_20 => 'Tygodniowo: 20 przestępstw';

  @override
  String get dailyGoalTitle_weekly_job_10 => 'Tygodniowo: pracuj 10 razy';

  @override
  String get dailyGoalTitle_weekly_vehicle_theft_5 =>
      'Co tydzień: ukradnij 5 pojazdów';

  @override
  String get dailyGoalTitle_weekly_travel_3 => 'Tygodniowo: 3 podróże';

  @override
  String dailyGoalReward(String cash, String xp) {
    return 'Nagroda: +$cash i +$xp XP';
  }

  @override
  String get justNow => 'Właśnie';

  @override
  String secondsAgo(String seconds) {
    return '$seconds temu';
  }

  @override
  String minutesAgo(String count) {
    return '$count minut temu';
  }

  @override
  String hoursAgo(String count) {
    return '$count godzin temu';
  }

  @override
  String get last10EventsLive => 'Ostatnie 10 wydarzeń (na żywo).';

  @override
  String get noEventsYetSession => 'Brak wydarzeń w tej sesji.';

  @override
  String get clearRecap => 'Wyczyść podsumowanie';

  @override
  String get weeklyGoalClaimed => 'Tygodniowy cel osiągnięty!';

  @override
  String get dailyGoalClaimed => 'Dzienny cel osiągnięty!';

  @override
  String get failed => 'Przegrany.';

  @override
  String get failedPleaseTryAgain => 'Przegrany. Spróbuj ponownie.';

  @override
  String get dailyGoals => 'Codzienne cele';

  @override
  String get weeklyGoals => 'Tygodniowe cele';

  @override
  String get claimed => 'Zgłoszono';

  @override
  String get ready => 'Gotowy';

  @override
  String get claim => 'Prawo';

  @override
  String readyToClaim(String count) {
    return '$count gotowy do odbioru';
  }

  @override
  String completedOutOfTotal(String completed, String total) {
    return '$completed/$total zakończone';
  }

  @override
  String get noPlayerData => 'Brak danych gracza';

  @override
  String get economy24h => 'Ekonomiczna 24h';

  @override
  String get grossIncome => 'Dochód brutto';

  @override
  String get propertySpend => 'Wydatki na nieruchomość';

  @override
  String get netCashflow => 'Przepływy pieniężne netto';

  @override
  String get trendVsPrevious => 'Trend vs poprzedni';

  @override
  String get activity7d => 'Ćwiczenie 7d';

  @override
  String get vehicleThefts => 'Kradzieże pojazdów';

  @override
  String get opsOverview => 'Przegląd operacji';

  @override
  String get activeCooldowns => 'Aktywne czasy odnowienia';

  @override
  String get longestTimer => 'Najdłuższy timer';

  @override
  String get activeProduction => 'Aktywna produkcja';

  @override
  String get productionReadyIn => 'Produkcja gotowa w';

  @override
  String get nightclubEvents => 'Imprezy w klubach nocnych';

  @override
  String get nextEventStartsIn => 'Następne wydarzenie rozpoczyna się za';

  @override
  String get vehiclesActiveListedTransit =>
      'Pojazdy aktywne/wystawione/przejeżdżające';

  @override
  String get livePlayerEvents => 'Wydarzenia dla graczy na żywo';

  @override
  String get openEvents => 'Otwarte wydarzenia';

  @override
  String get notificationsAndRisk => 'Powiadomienia i ryzyko';

  @override
  String get unreadDm => 'Nieprzeczytany DM';

  @override
  String get supportWaitingOnYou => 'Wsparcie czeka na Ciebie';

  @override
  String get eventsLast24h => 'Wydarzenia trwają 24h';

  @override
  String get riskScore => 'Ocena ryzyka';

  @override
  String get recruitProstitute => 'Rekrutuj prostytutkę';

  @override
  String get free => 'BEZPŁATNY';

  @override
  String get crewWars => 'Wojny załóg';

  @override
  String get status => 'Status';

  @override
  String get canDeclare => 'Można zadeklarować';

  @override
  String get yes => 'Tak';

  @override
  String get no => 'NIE';

  @override
  String get type => 'Typ';

  @override
  String get opponent => 'Przeciwnik';

  @override
  String get crewPoints => 'Punkty załogi';

  @override
  String get warRank => 'Stopień wojenny';

  @override
  String get seasonRank => 'Ranking sezonu';

  @override
  String get openTargets => 'Otwarte cele';

  @override
  String get phaseEndsIn => 'Faza kończy się w';

  @override
  String get crewTerritory => 'Terytorium załogi';

  @override
  String get regions => 'Regiony';

  @override
  String get countriesCaptured => 'Kraje zdobyte';

  @override
  String get payout => 'Wypłata';

  @override
  String get earningPerHour => 'Zarabianie teraz na godzinę';

  @override
  String get earningPerDay => 'Zarabianie teraz dziennie';

  @override
  String get totalEarned => 'Łącznie zarobione';

  @override
  String get crewBank => 'Bank załogi';

  @override
  String get dashboardEconomy24h => 'Gospodarka 24 h';

  @override
  String get dashboardGrossIncome => 'Dochód brutto';

  @override
  String get dashboardPropertySpend => 'Wydatki na nieruchomości';

  @override
  String get dashboardNetCashflow => 'Przepływ netto';

  @override
  String get dashboardTrendVsPrevious => 'Trend vs poprzedni okres';

  @override
  String get dashboardActivity7d => 'Aktywność (7 dni)';

  @override
  String get dashboardVehicleThefts => 'Kradzieże pojazdów';

  @override
  String get dashboardOpsOverview => 'Przegląd operacji';

  @override
  String get dashboardActiveCooldowns => 'Aktywne cooldowny';

  @override
  String get dashboardLongestTimer => 'Najdłuższy licznik';

  @override
  String get dashboardActiveProduction => 'Aktywna produkcja';

  @override
  String get dashboardProductionReadyIn => 'Produkcja gotowa za';

  @override
  String get dashboardNightclubEvents => 'Wydarzenia w klubach';

  @override
  String get dashboardNextEventStartsIn => 'Następne wydarzenie za';

  @override
  String get dashboardVehiclesActiveListedTransit =>
      'Pojazdy aktywne/wystawione/w drodze';

  @override
  String get dashboardLivePlayerEvents => 'Wydarzenia graczy na żywo';

  @override
  String get dashboardOpenEvents => 'Otwarte wydarzenia';

  @override
  String get dashboardNotificationsAndRisk => 'Powiadomienia i ryzyko';

  @override
  String get dashboardUnreadDm => 'Nieprzeczytane DM';

  @override
  String get dashboardSupportWaitingOnYou => 'Wsparcie czeka na Ciebie';

  @override
  String get dashboardEventsLast24h => 'Zdarzenia: ostatnie 24 h';

  @override
  String get dashboardRiskScore => 'Ocena ryzyka';

  @override
  String get dashboardRecruitProstitute => 'Rekrutuj prostytutkę';

  @override
  String get dashboardWarTheater => 'War theater';

  @override
  String get dashboardHotRegions => 'Hot regions';

  @override
  String get dashboardCrewWars => 'Wojny crew';

  @override
  String get dashboardStatusLabel => 'Status';

  @override
  String get dashboardCanDeclare => 'Można wypowiedzieć wojnę';

  @override
  String get dashboardTypeLabel => 'Typ';

  @override
  String get dashboardOpponent => 'Przeciwnik';

  @override
  String get dashboardCrewPoints => 'Punkty crew';

  @override
  String get dashboardWarRank => 'Ranga wojenna';

  @override
  String get dashboardSeasonRank => 'Ranking sezonu';

  @override
  String get dashboardOpenTargets => 'Otwarte cele';

  @override
  String get dashboardPhaseEndsIn => 'Faza kończy się za';

  @override
  String dashboardJailStatusIn(String duration) {
    return 'W więzieniu ($duration)';
  }

  @override
  String get dashboardCrewWarStatusPreparing => 'Przygotowanie';

  @override
  String get dashboardCrewWarStatusActive => 'Aktywna';

  @override
  String get dashboardCrewWarStatusLockdown => 'Blokada';

  @override
  String get dashboardCrewWarStatusResolved => 'Zakończona';

  @override
  String get dashboardCrewWarStatusArchived => 'Zarchiwizowana';

  @override
  String get dashboardCrewWarStatusCancelled => 'Anulowana';

  @override
  String get dashboardCrewWarStatusNone => 'Brak aktywnej wojny';

  @override
  String get dashboardCrewWarTypeKill => 'Wojna eliminacyjna';

  @override
  String get dashboardCrewWarTypeEconomy => 'Wojna gospodarcza';

  @override
  String get dashboardCrewWarTypeTerritory => 'Wojna terytorialna';

  @override
  String get dashboardCrewWarTypeTotal => 'Wojna totalna';

  @override
  String get dashboardClicks => 'Kliknięcia';

  @override
  String get dashboardValueNotAvailable => '—';

  @override
  String get dashboardPremiumOfferDefaultTitle => 'Oferta specjalna';

  @override
  String get dashboardCrewWarTypeUnknown => '—';

  @override
  String get dashboardTerritoryIncomeNotConfigured => 'nie skonfigurowano';

  @override
  String dashboardTerritoryIncomeEveryHours(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: 'co $hours godz.',
      one: 'co godzinę',
    );
    return '$_temp0';
  }

  @override
  String dashboardTerritoryIncomeEveryMinutes(int minutes) {
    return 'co $minutes min';
  }

  @override
  String get dashboardCrewTerritory => 'Terytorium crew';

  @override
  String get dashboardRegions => 'Regiony';

  @override
  String get dashboardCountriesCaptured => 'Podbite kraje';

  @override
  String get dashboardPayout => 'Wypłata';

  @override
  String get dashboardEarningPerHour => 'Bieżące zarobki / godz.';

  @override
  String get dashboardEarningPerDay => 'Bieżące zarobki / dzień';

  @override
  String get dashboardTotalEarned => 'Łącznie zarobione';

  @override
  String get dashboardVehicleOps => 'Operacje pojazdów';

  @override
  String get dashboardKillProgress => 'Postęp eliminacji';

  @override
  String get vehicleOpsHeat => 'Ciepło';

  @override
  String get vehicleOpsHeatLevelLow => 'Niski';

  @override
  String get vehicleOpsHeatLevelMedium => 'Średni';

  @override
  String get vehicleOpsHeatLevelHigh => 'Wysoki';

  @override
  String get vehicleOpsReputation => 'Rozpustnik';

  @override
  String get vehicleOpsPartsTrendUp => 'rośnie rynek części';

  @override
  String get vehicleOpsPartsTrendDown => 'spadek rynku części';

  @override
  String get vehicleOpsPartsTrendStable => 'Rynek części stabilny';

  @override
  String get vehicleOpsBlacklistActive => 'Czarna lista aktywna';

  @override
  String get vehicleOpsNoBlacklist => 'Brak czarnej listy';

  @override
  String get prisonTitle => 'Więzienie';

  @override
  String get prisonLoadFailed => 'Nie udało się załadować więźniów';

  @override
  String get prisonNoPrisonersFound => 'Nie znaleziono więźniów';

  @override
  String prisonRankLine(String rank) {
    return 'Ranga: $rank';
  }

  @override
  String prisonRankYouLine(String rank) {
    return 'Ranga: $rank · Ty';
  }

  @override
  String prisonRemainingTimeLine(String duration) {
    return 'Pozostały czas: $duration';
  }

  @override
  String prisonBailLine(String amount) {
    return 'Kaucja: $amount €';
  }

  @override
  String get prisonPayBailButton => 'Zapłać kaucję';

  @override
  String get prisonBuyOutButton => 'Wykup';

  @override
  String get prisonAttemptEscapeButton => 'Próba ucieczki';

  @override
  String get prisonJailbreakButton => 'Jailbreak';

  @override
  String get prisonActionFailed => '❌ Akcja nie powiodła się';

  @override
  String prisonBuyoutSuccess(String username, String amount) {
    return '✅ Wykupiony $username za $amount';
  }

  @override
  String prisonPaidBailSuccess(String amount) {
    return '✅ Zapłaciłeś kaucję w wysokości $amount € i jesteś bezpłatny';
  }

  @override
  String get prisonEscapeSuccess => '✅Ucieczka się powiodła! Jesteś wolny.';

  @override
  String prisonEscapeFailed(String penalty) {
    return '❌ Ucieczka nie powiodła się. Zdanie przedłużone o $penalty.';
  }

  @override
  String prisonCooldownActive(String duration) {
    return '⏱️ Aktywny czas odnowienia: czekaj $duration';
  }

  @override
  String get prisonEscapeGenericFailure => '❌ Ucieczka nie powiodła się';

  @override
  String get prisonErrorInsufficientFunds => '❌ Za mało pieniędzy';

  @override
  String get prisonErrorTargetNotJailed =>
      '❌ Target nie przebywa już w więzieniu';

  @override
  String get prisonErrorCannotBuyoutSelf => '❌ Nie możesz się przekupić';

  @override
  String get prisonErrorPlayerNotFound => '❌ Nie znaleziono gracza';

  @override
  String get prisonJailbreakSuccess =>
      '✅ Jailbreak powiódł się! Więzień jest wolny.';

  @override
  String prisonJailbreakCaught(String minutes) {
    return '🚔 Jailbreak nie powiódł się, zostałeś złapany ($minutes min więzienia).';
  }

  @override
  String get prisonJailbreakFailed =>
      '❌ Jailbreak nie powiódł się. Więzień nadal przebywa w zamknięciu.';

  @override
  String get prisonErrorRescuerJailed => '❌ Sam jesteś w więzieniu';

  @override
  String get prisonJailbreakGenericFailure => '❌ Jailbreak nie powiódł się';

  @override
  String get crewJailbreakTitle => '🚔 Uwięziona Crew';

  @override
  String get crewJailbreakLoadFailed =>
      'Nie udało się załadować uwięzionych członków';

  @override
  String get crewJailbreakEmptyTitle => '🎉 Nikt nie siedzi w więzieniu!';

  @override
  String get crewJailbreakEmptyBody => 'Wszyscy członkowie załogi są wolni';

  @override
  String crewJailbreakAttemptFor(String username) {
    return 'Próba jailbreaka dla $username:';
  }

  @override
  String get crewJailbreakRiskSuccess =>
      'Jeśli się powiedzie: Gracz uwolniony!';

  @override
  String get crewJailbreakRiskFailChance =>
      'W przypadku niepowodzenia: 60% szans na złapanie';

  @override
  String get crewJailbreakRiskCaughtPenalty =>
      'Złapany: 30-60 min więzienia + poszukiwany +10';

  @override
  String get crewJailbreakTip =>
      'Szansa na sukces wzrasta wraz z rangą i premią dla załogi!';

  @override
  String get crewJailbreakAttemptButton => 'Próba jailbreaku';

  @override
  String get crewJailbreakActionFailed => '❌ Akcja nie powiodła się';

  @override
  String crewJailbreakMemberJailTimeLine(String minutes) {
    return '⏱️ $minutes minut w więzieniu';
  }

  @override
  String get crewJailbreakRescueButton => 'Ratunek';

  @override
  String get crewRoleLeader => 'Lider';

  @override
  String get crewRoleCoLeader => 'Współlider';

  @override
  String get crewRoleMember => 'Członek';

  @override
  String get vehicleOpsHotspot => 'Hotspot';

  @override
  String get vehicleOpsCrew => 'Załoga';

  @override
  String get vehicleOpsCrewMatch => 'Mecz załogi';

  @override
  String get vehicleOpsChop => 'Siekać';

  @override
  String get vehicleOpsContract => 'Umowa';

  @override
  String get vehicleOpsCounter => 'Lada';

  @override
  String get vehicleOpsContracts => 'Umowy';

  @override
  String get vehicleOpsClaims => 'Roszczenia';

  @override
  String get vehicleOpsSeason => 'Sezon';

  @override
  String get dashboardCar => 'Samochód';

  @override
  String get dashboardMotorcycle => 'Motocykl';

  @override
  String get dashboardBoat => 'Łódź';

  @override
  String get dashboardCrewAccess => 'Dostęp załogi';

  @override
  String get dashboardCrewRole => 'Rola załogi';

  @override
  String get dashboardUnavailable => 'nie płynny';

  @override
  String get vehicleOps => 'Operacje pojazdów';

  @override
  String get car => 'Samochód';

  @override
  String get motorcycle => 'Motocykl';

  @override
  String get boat => 'Łódź';

  @override
  String get crewAccess => 'Dostęp załogi';

  @override
  String get crewRole => 'Rola załogi';

  @override
  String get unavailable => 'nie płynny';

  @override
  String get quickActionsCrimesSubtitle => 'Dokonuj czynów przestępczych';

  @override
  String get quickActionsVehicleHeistSubtitle => 'Samochód, motocykl i łódź';

  @override
  String get quickActionsTuneShopSubtitle => 'Części i ulepszenia';

  @override
  String get quickActionsEventsSubtitle => 'Aktywne i nadchodzące wydarzenia';

  @override
  String get quickActionsJobsSubtitle => 'Zarabiaj legalne pieniądze';

  @override
  String get quickActionsCasinoSubtitle => 'Graj swoimi pieniędzmi';

  @override
  String get quickActionsBankSubtitle => 'Zarządzaj swoim globalnym saldem';

  @override
  String money(String amount) {
    return '€$amount';
  }

  @override
  String get health => 'Zdrowie';

  @override
  String get rank => 'Stopień';

  @override
  String get xp => 'XP';

  @override
  String get settings => 'Ustawienia';

  @override
  String get avatar => 'Awatara';

  @override
  String get avatarUpdated => 'Awatar zaktualizowany!';

  @override
  String get avatarChangeFailed => 'Nie udało się zmienić awatara';

  @override
  String get settingsMyPortraits => 'My portraits';

  @override
  String get settingsPortraitFromSelfieTitle => 'Portret z selfie';

  @override
  String settingsPortraitFromSelfieSubtitle(int credits) {
    return 'Zamień selfie w portret w stylu gangsterskim. $credits kredytów każdy.';
  }

  @override
  String settingsPortraitUploadConfirm(int credits) {
    return 'Kosztuje to $credits kredytów. Kontynuować?';
  }

  @override
  String get settingsPortraitConsentLabel =>
      'Zgadzam się, że moje zdjęcie może zostać przetworzone w stylizowany portret w grze (patrz Regulamin). Nie mam mniej niż 13 lat.';

  @override
  String settingsPortraitInsufficientCredits(int need, int have) {
    return 'Za mało kredytów (potrzebujesz $need, masz $have).';
  }

  @override
  String get settingsPortraitCreated => 'Portret dodany do Twojej biblioteki!';

  @override
  String get settingsPortraitGenerationFailed =>
      'Nie można utworzyć portretu. Spróbuj innego zdjęcia.';

  @override
  String get settingsPortraitSelectActive => 'Użyj jako awatara';

  @override
  String get settingsPortraitDelete => 'Usuń portret';

  @override
  String settingsPortraitLimitReached(int max) {
    return 'Osiągnięto limit portretów ($max).';
  }

  @override
  String get settingsPortraitUsingCustom => 'Aktywny portret niestandardowy';

  @override
  String get settingsPresetAvatars => 'Wstępnie ustawione awatary';

  @override
  String get settingsPortraitDeleteConfirm =>
      'Usunąć ten portret ze swojej biblioteki?';

  @override
  String get settingsPortraitGenerating =>
      'Creating your portrait… This may take a few minutes. Please wait.';

  @override
  String get settingsPortraitDeleteHint =>
      'Tap a portrait to use it as your avatar. Tap the trash icon to remove it.';

  @override
  String get settingsPortraitDownloadFailed =>
      'Could not download the portrait. Check your connection and try again.';

  @override
  String get settingsPortraitDownloadTooltip =>
      'Pobierz ten portret jako plik PNG';

  @override
  String get settingsPortraitDeleteTooltip =>
      'Usuń ten portret ze swojej biblioteki';

  @override
  String get settingsPortraitStyleSection => 'Portrait look';

  @override
  String get settingsPortraitStyleHint =>
      'Generation uses your account gender from registration. All styles stay appropriate for the game.';

  @override
  String get settingsPortraitStyleClassicNoir => 'Classic noir';

  @override
  String get settingsPortraitStyleStreetCasual => 'Street casual';

  @override
  String get settingsPortraitStyleSharpSuit => 'Sharp suit';

  @override
  String get settingsPortraitStyleVelvetCharm => 'Evening glamour';

  @override
  String error(String error) {
    return 'Błąd: $error';
  }

  @override
  String get changeLanguage => 'Język / Taal';

  @override
  String get languageChanged => 'Język zmieniony na angielski';

  @override
  String languageChangeFailed(String code) {
    return 'Zmiana języka nie powiodła się ($code)';
  }

  @override
  String get chooseLanguage => 'Wybierz język / Taal Kiezen';

  @override
  String get dutch => 'Holandia';

  @override
  String get english => 'angielski';

  @override
  String get cancel => 'Anulować';

  @override
  String get changeUsername => 'Zmień nazwę użytkownika';

  @override
  String get usernameHint => '3-20 znaków';

  @override
  String get change => 'Zmiana';

  @override
  String get minChars => 'Minimum 3 znaki';

  @override
  String get usernameUpdated => 'Nazwa użytkownika zaktualizowana!';

  @override
  String get usernameTaken => 'Nazwa użytkownika jest już zajęta';

  @override
  String get usernameChangeFailed => 'Nie udało się zmienić nazwy użytkownika';

  @override
  String get oncePerMonth => 'Zmieniaj raz na miesiąc';

  @override
  String get privacy => 'Prywatność';

  @override
  String get allowMessages => 'Zezwalaj na wiadomości';

  @override
  String get allowMessagesDesc => 'Inni gracze mogą wysyłać Ci wiadomości';

  @override
  String get settingsSystemNotificationsTitle =>
      'Powiadomienia systemowe dla aplikacji';

  @override
  String get settingsPushPermissionAllowedLinked =>
      'Pozwolenie: dozwolone, urządzenie połączone';

  @override
  String get settingsPushPermissionAllowedRelinking =>
      'Pozwolenie: dozwolone, urządzenie ponownie się łączy';

  @override
  String get settingsPushPermissionProvisionalLinked =>
      'Zezwolenie: tymczasowe, urządzenie połączone';

  @override
  String get settingsPushPermissionProvisionalRelinking =>
      'Zezwolenie: tymczasowe, urządzenie ponownie się łączy';

  @override
  String get settingsPushPermissionDenied => 'Pozwolenie: odrzucone';

  @override
  String get settingsPushPermissionNotRequested =>
      'Pozwolenie: jeszcze nie wymagane';

  @override
  String get settingsPushPermissionUnknown => 'Zezwolenie: nieznane';

  @override
  String get settingsDeviceTokenRegistered =>
      'Token urządzenia zarejestrowany na serwerze';

  @override
  String get settingsDeviceTokenNotRegistered =>
      'Nie zarejestrowano jeszcze żadnego tokena urządzenia';

  @override
  String get settingsPushHelpText =>
      'Użyj tego przycisku, aby ponownie poprosić o pozwolenie przeglądarki/iPhone\'a i zarejestrować swój token push.';

  @override
  String get working => 'Pracujący...';

  @override
  String get settingsEnablePush => 'Włącz push';

  @override
  String get settingsPushEnabledToast =>
      'Powiadomienia push włączone. Nowe powiadomienia będą teraz odbierane.';

  @override
  String get settingsPushDisabledInSystem =>
      'Funkcja Push jest wyłączona w ustawieniach przeglądarki/iPhone\'a. Włącz powiadomienia dla tej aplikacji.';

  @override
  String settingsEnablePushFailed(String error) {
    return 'Nie udało się włączyć powiadomień push: $error';
  }

  @override
  String get settingsPlayerEventsTitle => 'Wydarzenia graczy';

  @override
  String get settingsPushLivePlayerEventsTitle =>
      'Push: wydarzenia dla graczy na żywo';

  @override
  String get settingsPushLivePlayerEventsSubtitle =>
      'Początek i koniec powtarzających się wydarzeń konkursowych (np. rundy z najlepszymi wynikami).';

  @override
  String get settingsCryptoNotificationsTitle =>
      'Powiadomienia kryptograficzne';

  @override
  String get settingsCryptoPushTradesTitle => 'Push: Handel';

  @override
  String get settingsCryptoPushTradesSubtitle =>
      'Powiadomienia push dotyczące transakcji kupna/sprzedaży';

  @override
  String get settingsCryptoPushPriceAlertsTitle => 'Push: Alerty cenowe';

  @override
  String get settingsCryptoPushPriceAlertsSubtitle =>
      'Powiadomienia push dotyczące odpowiednich zmian cen';

  @override
  String get settingsCryptoPushOrdersTitle => 'Naciśnij: Rozkazy';

  @override
  String get settingsCryptoPushOrdersSubtitle =>
      'Powiadomienie push o uruchomieniu lub wypełnieniu zamówienia';

  @override
  String get settingsCryptoPushMissionsTitle => 'Naciśnij: Misje';

  @override
  String get settingsCryptoPushMissionsSubtitle =>
      'Powiadomienie push po zakończeniu misji kryptograficznej';

  @override
  String get settingsCryptoPushLeaderboardTitle => 'Push: Tabela liderów';

  @override
  String get settingsCryptoPushLeaderboardSubtitle =>
      'Powiadomienia push dotyczące nagród w rankingach kryptowalut';

  @override
  String get settingsCryptoInAppTradesTitle => 'W aplikacji: Transakcje';

  @override
  String get settingsCryptoInAppTradesSubtitle =>
      'Pokaż wydarzenia handlowe w swoim kanale wydarzeń';

  @override
  String get settingsCryptoInAppPriceAlertsTitle =>
      'W aplikacji: Alerty cenowe';

  @override
  String get settingsCryptoInAppPriceAlertsSubtitle =>
      'Pokaż zdarzenia alertów cenowych w swoim kanale wydarzeń';

  @override
  String get settingsCryptoInAppOrdersTitle => 'W aplikacji: Zamówienia';

  @override
  String get settingsCryptoInAppOrdersSubtitle =>
      'Pokaż zdarzenia dotyczące zamówień w swoim kanale wydarzeń';

  @override
  String get settingsCryptoInAppMissionsTitle => 'W aplikacji: Misje';

  @override
  String get settingsCryptoInAppMissionsSubtitle =>
      'Pokaż ukończone misje w swoim kanale wydarzeń';

  @override
  String get settingsCryptoInAppLeaderboardTitle =>
      'W aplikacji: Tablica wyników';

  @override
  String get settingsCryptoInAppLeaderboardSubtitle =>
      'Pokaż nagrody z tabeli liderów w swoim kanale wydarzeń';

  @override
  String get settingsAvatarChangeWeeklyLimit =>
      'Możesz zmienić swój awatar tylko raz w tygodniu';

  @override
  String get settingsUsernameChangeMonthlyLimit =>
      'Nazwę użytkownika możesz zmienić tylko raz w miesiącu';

  @override
  String get settingsSaved => 'Ustawienia zostały zapisane';

  @override
  String get vipStatus => 'Status VIP-a';

  @override
  String activeUntil(String date) {
    return 'Aktywny do $date';
  }

  @override
  String get unknown => 'Nieznany';

  @override
  String get chooseAvatar => 'Wybierz awatara';

  @override
  String get freeAvatars => 'Darmowe awatary';

  @override
  String get vipAvatars => 'Avatary VIP';

  @override
  String get vip => 'VIP-a';

  @override
  String get notLoggedIn => 'Nie zalogowany';

  @override
  String get refresh => 'Odświeżać';

  @override
  String get foodAndDrink => 'Jedzenie i napoje';

  @override
  String get invalidItem => 'Ten element nie istnieje';

  @override
  String get foodBroodje => 'Kanapka';

  @override
  String get foodPizza => 'Pizza';

  @override
  String get foodBurger => 'Burger';

  @override
  String get foodSteak => 'Stek';

  @override
  String get drinkWater => 'Woda';

  @override
  String get drinkSoda => 'Soda';

  @override
  String get drinkCoffee => 'Kawa';

  @override
  String get drinkBeer => 'Piwo';

  @override
  String get foodInfo3 =>
      '• Kupuj jedzenie i napoje, aby utrzymać swoje statystyki';

  @override
  String get friends => 'Przyjaciele';

  @override
  String get friendActivity => 'Aktywność przyjaciela';

  @override
  String get friendsUiTabActivity => 'Działalność';

  @override
  String get friendsUiTabRequests => 'Upraszanie';

  @override
  String get friendsUiTabSearch => 'Szukaj';

  @override
  String get friendsUiEmptyListTitle => 'Nie ma jeszcze żadnych przyjaciół';

  @override
  String get friendsUiEmptyListSubtitle =>
      'Wyszukaj graczy i dodaj ich do znajomych!';

  @override
  String get friendsUiNoRequests => 'Żadnych próśb';

  @override
  String friendsUiLineRank(String rank) {
    return 'Ranga: $rank';
  }

  @override
  String friendsUiLineLocation(String location) {
    return 'Lokalizacja: $location';
  }

  @override
  String friendsUiLineHealth(String percent) {
    return 'Zdrowie: $percent%';
  }

  @override
  String friendsUiLineFriendsSince(String date) {
    return 'Przyjaciele od: $date';
  }

  @override
  String get friendsUiRemoveDialogTitle => 'Usuń znajomego';

  @override
  String get friendsUiRemoveDialogBody =>
      'Czy na pewno chcesz usunąć tego znajomego?';

  @override
  String get friendsUiRemoveConfirm => 'Usunąć';

  @override
  String get friendsUiBlockDialogTitle => 'Zablokuj gracza';

  @override
  String friendsUiBlockDialogBody(String username) {
    return 'Czy na pewno chcesz zablokować $username? Nie będziesz mógł wysyłać ani odbierać wiadomości.';
  }

  @override
  String get friendsUiBlockButton => 'Blok';

  @override
  String get friendsUiSnackRequestSent =>
      'Wysłano zaproszenie do grona znajomych';

  @override
  String get friendsUiSnackRequestAccepted =>
      'Zaproszenie do grona znajomych zaakceptowane';

  @override
  String get friendsUiSnackRequestRejected =>
      'Prośba o dodanie do znajomych odrzucona';

  @override
  String get friendsUiSnackFriendRemoved => 'Przyjaciel usunięty';

  @override
  String get friendsUiSnackPlayerBlocked => 'Gracz zablokowany';

  @override
  String friendsUiSnackError(String details) {
    return 'Błąd: $details';
  }

  @override
  String get friendsUiSearchLabel => 'Wyszukaj gracza';

  @override
  String get friendsUiSearchHint => 'Wpisz co najmniej 2 znaki';

  @override
  String get friendsUiSearchMinChars =>
      'Wpisz co najmniej 2 znaki, aby wyszukać';

  @override
  String get friendsUiNoPlayersFound => 'Nie znaleziono graczy';

  @override
  String get friendsUiMenuBlock => 'Blok';

  @override
  String get friendsUiMenuRemove => 'Usunąć';

  @override
  String get friendsUiChipFriend => 'Przyjaciel';

  @override
  String get friendsUiChipPending => 'Aż do';

  @override
  String get friendsUiAccept => 'Przyjąć';

  @override
  String get friendsUiReject => 'Odrzucić';

  @override
  String get friendsUiActivityEmpty => 'Brak aktywności znajomych';

  @override
  String friendsUiActivityLevel(String level) {
    return 'Poziom $level';
  }

  @override
  String friendsUiLineCrew(String name) {
    return 'Crew: $name';
  }

  @override
  String get crewUiAppCrews => 'Załogi';

  @override
  String get crewUiTabMyCrew => 'Przegląd';

  @override
  String get crewUiTabCrewHq => 'Siedziba i ulepszenia';

  @override
  String get crewUiTabStorageHub => 'Składowanie';

  @override
  String get crewUiTabMembers => 'Członkowie';

  @override
  String get crewUiTabWarRoom => 'Pokój wojenny';

  @override
  String get crewUiTabCrewMissions => 'Misje załogi';

  @override
  String get crewUiTabCarStorage => 'Przechowywanie samochodów/motocykli';

  @override
  String get crewUiTabBoatStorage => 'Przechowywanie łodzi';

  @override
  String get crewUiTabWeaponStorage => 'Przechowywanie broni';

  @override
  String get crewUiTabAmmoStorage => 'Magazyn amunicji';

  @override
  String get crewUiTabDrugStorage => 'Przechowywanie leków';

  @override
  String get crewUiTabCashStorage => 'Przechowywanie gotówki';

  @override
  String get crewUiTabAllCrews => 'Załogi';

  @override
  String get crewUiTabChat => 'Pogawędzić';

  @override
  String get crewUiActionCreateCrewShort => 'Utwórz załogę (50 tys. euro)';

  @override
  String get crewUiStateNotInCrewYet => 'Nie jesteś jeszcze w załodze';

  @override
  String get crewUiActionCreateCrew => 'Utwórz załogę (50 000 EUR)';

  @override
  String get crewUiLabelCrewBank => 'Bank załogi:';

  @override
  String get crewUiLabelDeposit => 'Depozyt';

  @override
  String get crewUiLabelWithdraw => 'Wycofać';

  @override
  String get crewUiLabelMyTrustScore => 'Mój wynik zaufania:';

  @override
  String get crewUiActionDeleteCrew => 'Usuń załogę';

  @override
  String get crewUiLabelCrewStats => 'Statystyki załogi:';

  @override
  String get crewUiActionLeaveCrew => 'Opuść załogę';

  @override
  String get crewUiSectionBuildings => 'Siedziba i ulepszenia';

  @override
  String get crewUiHintBuildingsTabs =>
      'Otwórz kwaterę główną i ulepszenia, aby zarządzać kwaterą główną i wszystkimi budynkami załogi z jednego miejsca.';

  @override
  String get crewUiSectionCrewStorage => 'Magazyn załogi';

  @override
  String get crewUiStateNoStorageData =>
      'Nie załadowano żadnych danych pamięci';

  @override
  String get crewUiActionAddCar => 'Dodaj samochód/motocykl';

  @override
  String get crewUiActionAddBoat => 'Dodaj łódź';

  @override
  String get crewUiActionAddWeapon => 'Dodaj broń';

  @override
  String get crewUiActionAddAmmo => 'Dodaj amunicję';

  @override
  String get crewUiActionAddDrugs => 'Dodaj leki';

  @override
  String get crewUiSectionMembersOverview => 'Przegląd członków';

  @override
  String get crewUiHintMembersTab =>
      'Otwórz zakładkę Członkowie powyżej, aby wyświetlić listę członków i prośby o dołączenie.';

  @override
  String get crewUiActionGoToMembers => 'Przejdź do członków';

  @override
  String get crewUiLabelCrewHq => 'Siedziba załogi';

  @override
  String get crewUiActionGoToCrewHq => 'Idź do siedziby załogi';

  @override
  String get crewUiActionGoToStorage => 'Przejdź do Magazynu';

  @override
  String get crewUiStateJoinCrewFirst => 'Najpierw utwórz lub dołącz do załogi';

  @override
  String get crewUiStateJoinRequests => 'Dołącz do próśb';

  @override
  String get crewUiStateNoJoinRequests => 'Brak oczekujących żądań';

  @override
  String get crewUiStateNoCrewsFound => 'Nie znaleziono żadnej załogi';

  @override
  String get crewUiLabelMemberCount => 'Członkowie';

  @override
  String get crewUiBadgeMyCrew => 'Moja Crew';

  @override
  String get crewUiActionJoin => 'Dołączyć';

  @override
  String get crewUiStateNotInCrew => 'Nie jesteś w załodze';

  @override
  String get crewUiHintChatJoinCrew =>
      'Utwórz lub dołącz do załogi, aby porozmawiać!';

  @override
  String get crewUiStatusNotOwned => 'Nie jest własnością';

  @override
  String get crewUiLabelLevel => 'Poziom';

  @override
  String get crewUiLabelCapacity => 'Pojemność';

  @override
  String get crewUiLabelMemberCap => 'Limit członkowski';

  @override
  String get crewUiLabelParking => 'Parking';

  @override
  String get crewUiActionPurchase => 'Zakup';

  @override
  String get crewUiActionUpgrade => 'Aktualizacja';

  @override
  String get crewUiActionDetails => 'Bliższe dane';

  @override
  String get crewUiHelpCapsTitle => 'Przegląd poziomów';

  @override
  String get crewUiHelpLevel => 'Poziom';

  @override
  String get crewUiHelpCapacity => 'Czapka';

  @override
  String get crewUiHelpUpgradeCost => 'Koszt';

  @override
  String get crewUiHelpClose => 'Zamknąć';

  @override
  String get crewUiHelpShowCaps => 'Pokaż czapki';

  @override
  String get crewUiSectionUpgradeHub => 'Siedziba i ulepszenia';

  @override
  String get crewUiSectionStorageHub => 'Centrum przechowywania';

  @override
  String get crewUiHintStorageTab =>
      'Użyj zakładki Przechowywanie do depozytów, sald i szybkich akcji magazynowania.';

  @override
  String get crewUiHintUpgradeHub =>
      'Zarządzaj kwaterą główną i wszystkimi ulepszeniami załogi z jednego miejsca.';

  @override
  String get crewUiSectionCrewMissions => 'Misje załogi';

  @override
  String get crewUiStateCrewMissionsEmpty =>
      'Nie są jeszcze dostępne żadne misje załogi';

  @override
  String get crewUiStateCrewMissionNoCrew =>
      'Dołącz lub utwórz załogę, aby rozpocząć misje.';

  @override
  String get crewUiActionStartMission => 'Rozpocznij misję';

  @override
  String get crewUiActionConfigureAndStartMission => 'Skonfiguruj i rozpocznij';

  @override
  String get crewUiActionResolveMission => 'Rozwiąż misję';

  @override
  String get crewUiActionClaimRewards => 'Odbieraj nagrody';

  @override
  String get crewUiActionSpeedupCooldown => 'Przyspiesz regenerację';

  @override
  String get crewUiActionConfirmSpeedupCooldown => 'Potwierdź przyspieszenie';

  @override
  String get crewUiLabelActiveMission => 'Aktywna misja';

  @override
  String get crewUiLabelRecentMissions => 'Ostatnie misje';

  @override
  String get crewUiLabelMissionDuration => 'Czas trwania';

  @override
  String get crewUiLabelMissionCooldown => 'Czas odnowienia';

  @override
  String get crewUiLabelMissionTier => 'Szczebel';

  @override
  String get crewUiLabelMissionRewards => 'Nagrody';

  @override
  String get crewUiLabelCrewMissionProgress => 'Postęp misji załogi';

  @override
  String get crewUiLabelCrewMissionXp => 'XP za misję załogi';

  @override
  String get crewUiLabelCrewMissionLevelBonus => 'Bonus pieniężny dla załogi';

  @override
  String get crewUiLabelCrewMissionNextLevelBonus => 'Bonus następnego poziomu';

  @override
  String get crewUiLabelMissionStatus => 'Status';

  @override
  String get crewUiLabelCooldownActive => 'Aktywny czas odnowienia';

  @override
  String get crewUiLabelRoleContributions => 'Wkłady ról';

  @override
  String get crewUiLabelContribution => 'składka';

  @override
  String get crewUiLabelMultiplier => 'mnożnik';

  @override
  String get crewUiStatusMissionLocked => 'Zamknięty';

  @override
  String get crewUiStatusInProgress => 'W toku';

  @override
  String get crewUiStatusCompleted => 'Zakończony';

  @override
  String get crewUiStatusReady => 'Gotowy';

  @override
  String get crewUiStatusRewardsClaimed => 'Nagrody odebrane';

  @override
  String get crewUiStateMissionActionBusy => 'Akcja jest przetwarzana...';

  @override
  String get crewUiHintMissionLeaderOnly =>
      'Tylko lider/współlider może rozpoczynać i rozwiązywać misje.';

  @override
  String get crewUiDialogRoleAssignTitle => 'Przypisz role';

  @override
  String get crewUiDialogRoleAssignSubtitle =>
      'Wybierz rolę w misji dla każdego członka załogi.';

  @override
  String get crewUiLabelRoleNone => 'Nie przydzielono';

  @override
  String get crewUiLabelRolePlanner => 'Planista';

  @override
  String get crewUiLabelRoleEnforcer => 'Egzekutor';

  @override
  String get crewUiLabelRoleLogistics => 'Logistyka';

  @override
  String get crewUiLabelRoleTech => 'Tech';

  @override
  String get crewUiHintRoleBonus =>
      'Każda unikalna rola: +3% szansy na sukces, -2% czasu trwania (maks. +12% / -8%).';

  @override
  String get crewUiStateRoleAssignNoMembers =>
      'Nie znaleziono członków załogi.';

  @override
  String get crewUiStateRoleAssignPickOne => 'Wybierz co najmniej 1 rolę.';

  @override
  String get crewUiHintMissionLockedTier2 =>
      'Poziom 2 wymaga członków HQ 5+ i 2+.';

  @override
  String get crewUiHintMissionLockedTier3 =>
      'Poziom 3 wymaga członków HQ 9+ i 3+.';

  @override
  String get crewUiHintMissionLockedDefault => 'Misja jest nadal zamknięta.';

  @override
  String get crewUiMessageMissionOverviewLoadFailed =>
      'Nie udało się załadować misji załogi.';

  @override
  String get crewUiMessageMissionStarted => 'Misja rozpoczęta';

  @override
  String get crewUiMessageMissionResolved => 'Misja rozwiązana';

  @override
  String get crewUiMessageMissionRewardsClaimed => 'Nagrody odebrane';

  @override
  String get crewUiMessageMissionCooldownSpedUp =>
      'Czas odnowienia przyspieszył';

  @override
  String get crewUiMessageMissionSpeedupQuoteFailed =>
      'Nie można wczytać ceny przyspieszenia.';

  @override
  String get crewUiDialogSpeedupTitle => 'Przyspieszyć regenerację?';

  @override
  String crewUiDialogSpeedupBody(String credits, String minutes) {
    return 'Natychmiastowe zakończenie kosztuje $credits kredytów (pozostało $minutes min).';
  }

  @override
  String get crewUiLabelCredits => 'kredyty';

  @override
  String get crewUiStateLoadingPrice => 'Ładuję cenę...';

  @override
  String get crewUiActionCancel => 'Anulować';

  @override
  String crewUiHqUpgradeSideBuildingsMessage(String level, String missing) {
    return 'Najpierw ulepsz wszystkie budynki boczne co najmniej do poziomu $level. \n\nBrakuje: \n$missing';
  }

  @override
  String get crewUiFormatRemainingUnderOneMinute => '<1min';

  @override
  String crewUiFormatRemainingMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get crewUiMissionNoHistory => 'Nie ma jeszcze historii.';

  @override
  String get crewUiBuildingHq => 'Siedziba załogi';

  @override
  String get crewUiBuildingCarStorage => 'Przechowywanie samochodów/motocykli';

  @override
  String get crewUiBuildingBoatStorage => 'Przechowywanie łodzi';

  @override
  String get crewUiBuildingWeaponStorage => 'Przechowywanie broni';

  @override
  String get crewUiBuildingAmmoStorage => 'Magazyn amunicji';

  @override
  String get crewUiBuildingDrugStorage => 'Przechowywanie leków';

  @override
  String get crewUiBuildingCashStorage => 'Przechowywanie gotówki';

  @override
  String get crewUiWarActionKill => 'Zabić';

  @override
  String get crewUiWarActionMug => 'Kubek';

  @override
  String get crewUiWarActionSabotage => 'Sabotaż';

  @override
  String get crewUiWarActionIntel => 'Intela';

  @override
  String get crewUiWarActionRaid => 'Nalot';

  @override
  String get crewUiWarActionShield => 'Tarcza';

  @override
  String get crewUiWarActionBoost => 'Zwiększyć';

  @override
  String get crewUiWarActionTerritory => 'Terytorium';

  @override
  String crewUiWarTargetCrewSubtitle(String name, int count) {
    return '$name ($count członków)';
  }

  @override
  String crewChatErrorLoadingMessages(String error) {
    return 'Błąd ładowania wiadomości: $error';
  }

  @override
  String get crewChatMessageTooLong =>
      'Wiadomość jest za długa (maks. 500 znaków)';

  @override
  String crewChatErrorSending(String error) {
    return 'Błąd podczas wysyłania wiadomości: $error';
  }

  @override
  String crewChatErrorDelete(String error) {
    return 'Nie można usunąć wiadomości: $error';
  }

  @override
  String get crewChatDeleteTitle => 'Usunąć wiadomość?';

  @override
  String get crewChatDeleteBody => 'Ta wiadomość zostanie trwale usunięta.';

  @override
  String get crewChatCancel => 'Anulować';

  @override
  String get crewChatDelete => 'Usuwać';

  @override
  String get crewChatNoMessages => 'Nie ma jeszcze żadnych wiadomości';

  @override
  String get crewChatEmptyHint => 'Wyślij pierwszą wiadomość do swojej załogi!';

  @override
  String get aviationUiBuyConfirmTitle => 'Kupić samolot?';

  @override
  String aviationUiBuyConfirmBody(String name, String price) {
    return 'Chcesz kupić $name za $price?';
  }

  @override
  String get aviationUiPurchaseFailed => 'Zakup nie powiódł się.';

  @override
  String get aviationUiPurchasedSuccess => 'Samolot zakupiony.';

  @override
  String aviationUiLicenseActiveBlurb(String type) {
    return 'Licencja aktywna ($type). W razie potrzeby modernizuj dla cięższych samolotów. Wymagane jest również pełne przeszkolenie pilota (Aviation 5 + certyfikaty).';
  }

  @override
  String get aviationUiLicenseMissingBlurb =>
      'Sama szkoła lotnictwa 5/5 nie wystarczy: kup tutaj płatną licencję lotniczą, zanim będziesz mógł kupić samolot.';

  @override
  String get aviationUiLicensesTitle => 'Licencje lotnicze';

  @override
  String get aviationUiLicenseBasic => 'Podstawowy (lekki / turbośmigłowy)';

  @override
  String get aviationUiLicenseCommercial =>
      'Komercyjne (biznesowe/luksusowe odrzutowce)';

  @override
  String get aviationUiLicenseCargo => 'Cargo (ładunek i ciężkie frachtowce)';

  @override
  String aviationUiLicenseMinRank(int rank) {
    return 'Minimalna ranga $rank';
  }

  @override
  String get aviationUiBuyLicense => 'Kup licencję';

  @override
  String get aviationUiUpgradeLicense => 'Uaktualnij licencję';

  @override
  String get aviationUiLicenseBuyConfirmTitle => 'Kupić licencję lotniczą?';

  @override
  String aviationUiLicenseBuyConfirmBody(String name, String price) {
    return 'Kupić $name za $price? Wymagana ukończona szkoła lotnicza (poziom 5 + certyfikaty).';
  }

  @override
  String get aviationUiLicensePurchaseFailed =>
      'Zakup licencji nie powiódł się.';

  @override
  String get aviationUiLicensePurchasedSuccess =>
      'Zakupiono licencję lotniczą.';

  @override
  String get aviationUiYourAircraft => 'Twój samolot';

  @override
  String get aviationUiNoOwnedAircraft =>
      'Nie posiadasz jeszcze żadnego samolotu.';

  @override
  String get aviationUiAvailableAircraft => 'Dostępne samoloty';

  @override
  String aviationUiFuelLabel(int fuel, int max) {
    return 'Paliwo: $fuel / $max';
  }

  @override
  String aviationUiPriceLabel(String price) {
    return 'Cena: $price';
  }

  @override
  String aviationUiMinRank(int rank) {
    return 'Minimalna ranga: $rank';
  }

  @override
  String aviationUiSpeedMultiplier(String value) {
    return 'Prędkość x$value';
  }

  @override
  String aviationUiCargoCapacity(int amount) {
    return 'Ładunek: $amount';
  }

  @override
  String get aviationUiDefaultAircraftName => 'Samolot';

  @override
  String aviationUiLoadError(String error) {
    return 'Nie można załadować danych lotniczych: $error';
  }

  @override
  String get crewUiTr0 => 'Wymagania dotyczące aktualizacji centrali';

  @override
  String get crewUiTr1 =>
      'Ulepsz swój obecny styl HQ do maksymalnego poziomu, aby odblokować następny styl';

  @override
  String get crewUiTr2 => 'Osiągnięto ostateczny styl kwatery głównej';

  @override
  String get crewUiTr3 => 'Siedziba VIP wymagana na poziomie 11-15';

  @override
  String get crewUiTr4 =>
      'Najpierw ulepsz wszystkie budynki boczne do poziomu wymaganego dla tego stylu Kwatery Głównej';

  @override
  String get crewUiTr5 => 'Budynek już posiadany';

  @override
  String get crewUiTr6 => 'Niewystarczające środki w banku załogi';

  @override
  String get crewUiTr7 =>
      'Postęp w sztabie jest zbyt niski dla tego ulepszenia';

  @override
  String get crewUiTr8 => 'VIP załogi wymagany na poziomie 11+';

  @override
  String get crewUiTr9 =>
      'Osiągnięto depozyt startowy. Kup najpierw miejsce na gotówkę, aby odblokować więcej miejsca w banku załogi.';

  @override
  String get crewUiTr10 => 'Akcja nie powiodła się';

  @override
  String get crewUiTr11 => 'Istnieje już aktywna misja załogowa.';

  @override
  String get crewUiTr12 =>
      'Czas odnowienia misji jest nadal aktywny. Poczekaj aż się zakończy lub przyśpiesz go kredytami.';

  @override
  String get crewUiTr13 => 'Nie znaleziono misji.';

  @override
  String get crewUiTr14 => 'Ten poziom jest nadal zablokowany.';

  @override
  String get crewUiTr15 => 'Nie znaleziono przebiegu misji.';

  @override
  String get crewUiTr16 => 'Misja została już rozwiązana.';

  @override
  String get crewUiTr17 => 'Misja nie jest jeszcze ukończona.';

  @override
  String get crewUiTr18 => 'Brak aktywnego czasu odnowienia.';

  @override
  String get crewUiTr19 => 'Niewystarczające kredyty.';

  @override
  String get crewUiTr20 => 'Nie udało się rozpocząć misji.';

  @override
  String get crewUiTr21 => 'Nie udało się rozwiązać misji.';

  @override
  String get crewUiTr22 => 'Nie udało się odebrać nagród.';

  @override
  String get crewUiTr23 => 'Nie udało się przyspieszyć czasu odnowienia.';

  @override
  String get crewUiTr24 => 'Nie jesteś w załodze.';

  @override
  String get crewUiTr25 => 'Może to zrobić tylko dowódca załogi.';

  @override
  String get crewUiTr26 => 'Nie znaleziono docelowej załogi.';

  @override
  String get crewUiTr27 => 'Ta Crew jest już w stanie wojny.';

  @override
  String get crewUiTr28 => 'Wymaganych jest co najmniej 3 członków załogi.';

  @override
  String get crewUiTr29 => 'Nie znaleziono wojny.';

  @override
  String get crewUiTr30 => 'Ta wojna nie jest aktywna.';

  @override
  String get crewUiTr31 => 'Nie możesz teraz dołączyć do tej wojny.';

  @override
  String get crewUiTr32 => 'Ta akcja wymaga gracza docelowego.';

  @override
  String get crewUiTr33 => 'Blokada przeciw farmie: wybierz inny cel.';

  @override
  String get crewUiTr34 => 'Do tej akcji wymagany jest gracz VIP.';

  @override
  String get crewUiTr35 => 'Do tej akcji wymagana jest Crew VIP.';

  @override
  String get crewUiTr36 => 'Osiągnięto limit działań.';

  @override
  String crewUiTr37(String remaining) {
    return 'Aktywny czas odnowienia: poczekaj jeszcze $remaining minut.';
  }

  @override
  String get crewUiTr38 => 'Wybrano nieprawidłowe terytorium.';

  @override
  String get crewUiTr39 => 'Akcja wojenna załogi nie powiodła się.';

  @override
  String get crewUiTr40 => 'Gracz docelowy';

  @override
  String get crewUiTr41 => 'Zabija';

  @override
  String get crewUiTr42 => 'Zgony';

  @override
  String get crewUiTr43 => 'Anulować';

  @override
  String get crewUiTr44 => 'Potwierdzać';

  @override
  String get crewUiTr45 => 'Lider';

  @override
  String get crewUiTr46 => 'Współlider';

  @override
  String get crewUiTr47 => 'Członek';

  @override
  String get crewUiTr48 => 'Kapitał';

  @override
  String get crewUiTr49 => 'Port';

  @override
  String get crewUiTr50 => 'Przemysł';

  @override
  String get crewUiTr51 => 'Granica';

  @override
  String get crewUiTr52 => 'Logistyka';

  @override
  String get crewUiTr53 => 'Prawo';

  @override
  String get crewUiTr54 => 'Kleszcz';

  @override
  String get crewUiTr55 => 'Wybierz terytorium';

  @override
  String get crewUiTr56 => 'Najpierw wybierz docelową załogę.';

  @override
  String get crewUiTr57 => 'Wypowiedzona wojna załogi.';

  @override
  String get crewUiTr58 => 'Nie udało się wypowiedzieć wojny załodze.';

  @override
  String get crewUiTr59 => 'Dołączyłeś do wojny.';

  @override
  String get crewUiTr60 => 'Nie udało się dołączyć do wojny.';

  @override
  String get crewUiTr61 => 'Akcja wojenna załogi zakończona.';

  @override
  String get crewUiTr62 => 'Zabij wojnę';

  @override
  String get crewUiTr63 => 'Wojna gospodarcza';

  @override
  String get crewUiTr64 => 'Wojna terytorialna';

  @override
  String get crewUiTr65 => 'Totalna wojna';

  @override
  String get crewUiTr66 => 'Przygotowanie';

  @override
  String get crewUiTr67 => 'Aktywny';

  @override
  String get crewUiTr68 => 'Izolacja';

  @override
  String get crewUiTr69 => 'Rozwiązany';

  @override
  String get crewUiTr70 => 'Zarchiwizowane';

  @override
  String get crewUiTr71 => 'Odwołany';

  @override
  String get crewUiTr72 => 'Crew VIP';

  @override
  String get crewUiTr73 => '9,99 €/mies';

  @override
  String get crewUiTr74 => '4,99 €/mies';

  @override
  String get crewUiTr75 => 'Jednorazowe zakupy';

  @override
  String get crewUiTr76 => 'Tylko lider może kupić VIP-a dla załogi';

  @override
  String get crewUiTr77 => 'Nieprawidłowy produkt';

  @override
  String get crewUiTr78 => 'Błąd podczas otwierania strony płatności';

  @override
  String get crewUiTr79 => 'Czy jesteś pewien?';

  @override
  String get crewUiTr80 => 'Opuść załogę';

  @override
  String get crewUiTr81 => 'Czy na pewno chcesz opuścić załogę?';

  @override
  String get crewUiTr82 => 'Wyjechać';

  @override
  String get crewUiTr83 => 'Opuściła załogę';

  @override
  String get crewUiTr84 => 'Wpłata do banku załogi';

  @override
  String get crewUiTr85 => 'Wycofaj się z banku załogi';

  @override
  String get crewUiTr86 => 'Kwota';

  @override
  String get crewUiTr87 => 'Nieprawidłowa kwota';

  @override
  String get crewUiTr88 => 'Za mało gotówki pod ręką';

  @override
  String get crewUiTr89 => 'Kup najpierw magazyn gotówki dla banku załogi';

  @override
  String get crewUiTr90 => 'Magazyn gotówki załogi jest pełny';

  @override
  String get crewUiTr91 => 'Usuń załogę';

  @override
  String get crewUiTr92 =>
      'Czy na pewno chcesz usunąć tę załogę? Tego nie można cofnąć.';

  @override
  String get crewUiTr93 => 'Usuwać';

  @override
  String get crewUiTr94 => 'Następny poziom';

  @override
  String get crewUiTr95 => 'Koszt';

  @override
  String get crewUiTr96 => 'Osiągnięto maksymalny poziom';

  @override
  String get crewUiTr97 => 'Budynek nie będący własnością';

  @override
  String get crewUiTr98 => 'Dodaj samochód/motocykl';

  @override
  String get crewUiTr99 => 'Dodaj łódź';

  @override
  String get crewUiTr100 => 'Motocykl';

  @override
  String get crewUiTr101 => 'Łódź';

  @override
  String get crewUiTr102 => 'Samochód';

  @override
  String get crewUiTr103 => 'Wybierać';

  @override
  String get crewUiTr104 => 'Dodać';

  @override
  String get crewUiTr105 => 'Dodaj broń';

  @override
  String get crewUiTr106 => 'Broń';

  @override
  String get crewUiTr107 => 'Ilość';

  @override
  String get crewUiTr108 => 'Dodaj amunicję';

  @override
  String get crewUiTr109 => 'Rodzaj amunicji';

  @override
  String get crewUiTr110 => 'Dodaj towar';

  @override
  String get crewUiTr111 => 'Rodzaj towaru';

  @override
  String get crewUiTr112 =>
      'Najpierw dołącz do załogi, aby móc korzystać z Crew Wars.';

  @override
  String get crewUiTr113 =>
      'Żaden członek załogi przeciwnika nie jest dostępny do namierzenia.';

  @override
  String get crewUiTr114 => 'Wybierz docelowego gracza';

  @override
  String get crewUiTr115 => 'Przegląd sezonu';

  @override
  String get crewUiTr116 => 'Aktywny sezon';

  @override
  String get crewUiTr117 => 'Moja rola';

  @override
  String get crewUiTr118 => 'Crew może zadeklarować';

  @override
  String get crewUiTr119 => 'Tak';

  @override
  String get crewUiTr120 => 'NIE';

  @override
  String get crewUiTr121 => 'Wypowiedz nową wojnę';

  @override
  String get crewUiTr122 => 'Docelowa Crew';

  @override
  String get crewUiTr123 => 'Typ wojny';

  @override
  String get crewUiTr124 => 'Wypowiedz wojnę';

  @override
  String get crewUiTr125 => 'Terytoria wojenne';

  @override
  String get crewUiTr126 => 'Neutralny';

  @override
  String get crewUiTr127 => 'Crew przeciwnika';

  @override
  String get crewUiTr128 => 'Aktywny od';

  @override
  String get crewUiTr129 => 'Dołącz do wojny';

  @override
  String get crewUiTr130 => 'Tabele';

  @override
  String get crewUiTr131 => 'Terytoria';

  @override
  String get crewUiTr132 => 'Ostatnie działania';

  @override
  String get crewUiTr133 => 'Nie ma jeszcze żadnych działań wojennych.';

  @override
  String get crewUiTr134 => 'vs';

  @override
  String get crewUiTr135 => 'Tabela liderów sezonu';

  @override
  String get crewUiTr136 => 'Nie ma jeszcze punktów sezonowych.';

  @override
  String get crewUiTr137 => 'Łup';

  @override
  String get crewUiTr138 => 'Ostatnie wojny';

  @override
  String get crewUiTr139 => 'Nie ma jeszcze niedawnych wojen.';

  @override
  String get crewUiTr140 => 'Tylko lider może kupować lub ulepszać';

  @override
  String get crewUiTr141 =>
      'Zablokowano aktualizację HQ: budynki boczne najpierw do L\$requiredSideLevel';

  @override
  String get crewUiTr142 => 'Następna aktualizacja nie jest jeszcze dostępna';

  @override
  String get crewUiTr143 => 'Postęp w sztabie jest zbyt niski';

  @override
  String get crewUiTr144 =>
      'Poziom centrali jest zbyt niski do następnej aktualizacji';

  @override
  String get premiumUiLoadError => 'Nie udało się wczytać danych premium.';

  @override
  String get premiumUiRedirectPaidOneTime =>
      'Zakup otrzymany. Odświeżam Twoje kredyty i przegląd premium.';

  @override
  String get premiumUiRedirectPaidCrewVip =>
      'Otrzymano płatność VIP dla załogi. Odświeżam przegląd premium.';

  @override
  String get premiumUiRedirectPaidVip =>
      'Otrzymano płatność VIP. Odświeżam przegląd premium.';

  @override
  String get premiumUiRedirectCancelledOneTime => 'Zakup anulowany.';

  @override
  String get premiumUiRedirectCancelledSubscription => 'Płatność anulowana.';

  @override
  String get premiumUiRedirectFailedOneTime =>
      'Zakup nie powiódł się lub wygasł.';

  @override
  String get premiumUiRedirectFailedSubscription =>
      'Płatność nie powiodła się lub wygasła.';

  @override
  String get premiumUiCheckoutOpenFailed =>
      'Nie udało się otworzyć strony płatności.';

  @override
  String get premiumUiRedeemNeedsVehicle =>
      'Ten przedmiot wymaga wyboru pojazdu i zostanie aktywowany na ekranie pojazdu.';

  @override
  String get premiumUiRedeemSuccessDefault => 'Kredyty wykorzystane.';

  @override
  String get premiumUiRedeemFailed => 'Nie udało się wykorzystać środków.';

  @override
  String get premiumUiPerMonthShort => 'mo';

  @override
  String get premiumUiCreditThemeCashBoost => 'Zastrzyk gotówki';

  @override
  String get premiumUiCreditThemeSecurity => 'Bezpieczeństwo';

  @override
  String get premiumUiCreditThemeGarage => 'Garaż';

  @override
  String get premiumUiCreditThemeTuneShop => 'Sklep tuningowy';

  @override
  String premiumUiCreditThemeCooldown(String actionType) {
    return 'Czas odnowienia: $actionType';
  }

  @override
  String get premiumUiCreditThemeCooldownReset => 'Reset czasu odnowienia';

  @override
  String get premiumUiCreditThemeEvents => 'Wydarzenia';

  @override
  String get premiumUiCreditThemePremium => 'Premia';

  @override
  String get premiumUiKpiPlayerVip => 'Gracz VIP';

  @override
  String get premiumUiKpiCrewVip => 'Crew VIP';

  @override
  String get premiumUiCreditsLabel => 'Kredyty';

  @override
  String get premiumUiStatusActive => 'Aktywny';

  @override
  String get premiumUiStatusInactive => 'Nieaktywny';

  @override
  String get premiumUiNoCrew => 'Brak załogi';

  @override
  String get premiumUiSectionVipTitle => 'Subskrypcje VIP';

  @override
  String get premiumUiSectionVipSubtitle =>
      'Profesjonalne kafelki VIP z jasnymi cenami, statusem i korzyściami.';

  @override
  String get premiumUiPlayerVipSubtitle =>
      'Ekskluzywne korzyści z konta, odblokowanie awatarów i premium QoL.';

  @override
  String premiumUiActiveUntil(String date) {
    return 'Aktywny do $date';
  }

  @override
  String get premiumUiBadgeVip => 'VIP-a';

  @override
  String get premiumUiExtendVip => 'Przedłuż VIP-a';

  @override
  String get premiumUiBuyVip => 'Kup VIP-a';

  @override
  String get premiumUiPlayerVipBenefitsTitle => 'Korzyści VIP dla graczy';

  @override
  String get premiumUiPlayerVipBenefitsBody =>
      'Korzyści VIP dla graczy: \n- 10% krótsze limity czasu akcji/odnowienia (czas więzienia pozostaje niezmieniony). \n- W Produkcji Leków na każdej karcie produkcji otrzymasz przycisk błyskawicy VIP, dzięki któremu jednym kliknięciem kupisz brakujące materiały (po potwierdzeniu kosztów). \n- W przypadku śmierci tracisz dostępne środki pieniężne, ale zaczynasz od nowa z kwotą 500 000 EUR. \n- Twoja ranga zostanie zmniejszona o połowę zamiast pełnego resetu. \n- Postępy w edukacji i odblokowane osiągnięcia zostają zachowane. \n- Saldo bankowe i kryptowaluta zostają zachowane. \n- Właściwości, pojazdy, prostytutki, przewożony ekwipunek i przechowywane przedmioty zostaną usunięte. \n- Postęp leków i zapasy leków zostały zresetowane. \n- Otrzymujesz 100 kredytów premium tygodniowo, gdy VIP jest aktywny.';

  @override
  String get premiumUiCrewVipSubtitleNoCrew =>
      'Aby móc aktywować VIP-a dla załogi, musisz należeć do załogi.';

  @override
  String get premiumUiCrewVipSubtitleInCrew =>
      'Do ulepszeń załogi, budynków bocznych na poziomie 11-15 i wspólnych korzyści.';

  @override
  String get premiumUiBadgeCrewNeeded => 'Potrzebna Crew';

  @override
  String get premiumUiBadgeCrewVipLabel => 'Crew VIP';

  @override
  String get premiumUiCtaCrewRequired => 'Wymagana Crew';

  @override
  String get premiumUiExtendCrewVip => 'Przedłuż VIP-a załogi';

  @override
  String get premiumUiBuyCrewVip => 'Kup Crew VIP';

  @override
  String get premiumUiCrewVipBenefitsTitle => 'Korzyści VIP dla załogi';

  @override
  String get premiumUiCrewVipBenefitsNoCrewBody =>
      'Przed zakupem Crew VIP musisz dołączyć do załogi. VIP dla załogi odblokowuje korzyści skupione na załodze i wyższy postęp ulepszeń.';

  @override
  String get premiumUiCrewVipBenefitsInCrewBody =>
      'Crew VIP zapewnia dostęp do dodatkowych ulepszeń załogi i wspólnych korzyści premium dla przepływu załogi. Po zakupie status aktywny i data ważności są natychmiast aktualizowane.';

  @override
  String get premiumUiSectionBuyCreditsTitle => 'Kup kredyty';

  @override
  String get premiumUiSectionBuyCreditsSubtitle =>
      'Wybierz pakiet za pomocą kafelków wizualnych. Popularna opcja 1000 kredytów zyskuje własne światło.';

  @override
  String get premiumUiNoCreditBundles =>
      'W tej chwili nie ma aktywnych pakietów kredytów.';

  @override
  String get premiumUiCreditBundleFallbackTitle => 'Pakiet kredytowy';

  @override
  String get premiumUiCreditBundleFallbackDescription =>
      'Natychmiastowe środki do Twojego portfela premium.';

  @override
  String premiumUiBuyCredits(int amount) {
    return 'Kup $amount kredytów';
  }

  @override
  String premiumUiCreditsCount(int count) {
    return '$count kredytów';
  }

  @override
  String get premiumUiBadgeUltraDeal => 'Ultra okazja';

  @override
  String get premiumUiBadgeTopDeal => 'Najlepsza oferta';

  @override
  String get premiumUiBadgeCredits => 'Kredyty';

  @override
  String premiumUiCreditOfferInfo(
    String buyLine,
    String price,
    String description,
  ) {
    return '$buyLine dla $price. \n\n$description';
  }

  @override
  String get premiumUiSectionShopTitle => 'Sklep kredytowy';

  @override
  String get premiumUiSectionShopSubtitle =>
      'Do każdego przedmiotu przypisana jest płytka tematyczna zależna od efektu, który kupujesz.';

  @override
  String get premiumUiShopItemFallbackTitle => 'Przedmiot premium';

  @override
  String get premiumUiShopItemFallbackDescription =>
      'Bezpośredni dodatek premium.';

  @override
  String get premiumUiShopNoActiveCooldown => 'Brak aktywnego czasu odnowienia';

  @override
  String get premiumUiShopNotEnoughCredits => 'Za mało kredytów';

  @override
  String get premiumUiShopRedeem => 'Odkupić';

  @override
  String premiumUiShopItemInfo(String description, String theme, int cost) {
    return '$description \n\nTemat: $theme \nKoszt: $cost kredytów';
  }

  @override
  String get premiumUiBadgeShop => 'Sklep';

  @override
  String get premiumUiActiveEffectsTitle => 'Aktywne efekty premium';

  @override
  String get premiumUiIntroSubtitle =>
      'Gracze zarządzają tutaj subskrypcjami VIP, pakietami kredytów i przedmiotami w sklepie kredytów.';

  @override
  String premiumUiEntitlementChip(String key, String date) {
    return '$key - $date';
  }

  @override
  String get propertiesAvailable => 'Dostępny';

  @override
  String get myProperties => 'Moje właściwości';

  @override
  String get errorLoadingMyProperties =>
      'Błąd podczas ładowania moich właściwości';

  @override
  String get errorBuyingProperty => 'Błąd podczas zakupu nieruchomości';

  @override
  String get errorCollectingIncome => 'Błąd podczas zbierania dochodu';

  @override
  String get noAvailableProperties => 'Brak dostępnych obiektów';

  @override
  String get noOwnedProperties => 'Nie posiadasz jeszcze żadnych nieruchomości';

  @override
  String get buyFirstPropertyHint =>
      'Kup swoją pierwszą nieruchomość w zakładce „Dostępne”.';

  @override
  String buyPropertyConfirm(String name, String price) {
    return 'Chcesz kupić $name za $price?';
  }

  @override
  String get propertyPrice => 'Cena';

  @override
  String get propertyMinLevel => 'Wymagany poziom';

  @override
  String get propertyIncomePerHour => 'Dochód/godz';

  @override
  String get propertyMaxLevel => 'Maksymalny poziom';

  @override
  String get propertyUniquePerCountry => '⚠️ Unikalne - 1 na kraj';

  @override
  String get propertyIncomeReady => '✅Dochód gotowy do odbioru!';

  @override
  String propertyNextIncome(String duration) {
    return '⏱️ Następny dochód za $duration';
  }

  @override
  String get propertyBuyAction => 'Kup nieruchomość';

  @override
  String get propertyCollectAction => 'Zbierać';

  @override
  String get propertyUpgradeAction => 'Aktualizacja';

  @override
  String get propertyMax => 'MAKS';

  @override
  String propertyLevel(String level) {
    return 'Poziom $level';
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
  String get propertyTypeHouse => 'Dom';

  @override
  String get propertyTypeWarehouse => 'Magazyn';

  @override
  String get propertyTypeCasino => 'Kasyno';

  @override
  String get propertyTypeHotel => 'Hotel';

  @override
  String get propertyTypeFactory => 'Fabryka';

  @override
  String get propertyTypeBusiness => 'Biznes';

  @override
  String get propertyCasinoName => 'Kasyno';

  @override
  String get propertyWarehouseName => 'Magazyn';

  @override
  String get propertyNightclubName => 'Klub nocny';

  @override
  String get propertyHouseName => 'Dom';

  @override
  String get propertyApartmentName => 'Apartament';

  @override
  String get propertyShopName => 'Sklep';

  @override
  String get propertiesConfirmPurchaseTitle => 'Czy jesteś pewien?';

  @override
  String get propertyTypeApartment => 'Apartament';

  @override
  String get propertyTypeNightclub => 'Klub nocny';

  @override
  String get propertyTypeShop => 'Sklep';

  @override
  String get propertyStatStorageLabel => '📦 Przechowywanie';

  @override
  String propertyStatStorageSlotsRange(int from, int to) {
    return '$from → $to slotów';
  }

  @override
  String get propertyStatHousingCapacityLabel => '👩 Pojemność mieszkania';

  @override
  String propertyStatHousingWorkersRange(int from, int to) {
    return '$from → $to pracowników';
  }

  @override
  String propertyStatStorageAmountSlots(int amount) {
    return '$amount slotów';
  }

  @override
  String propertyHousingCapacityWithMax(int current, int max, int level) {
    return '$current pracowników (maks. $max na poziomie $level)';
  }

  @override
  String propertyHousingCapacityMaxReached(int current) {
    return '$current pracowników • max';
  }

  @override
  String propertyVipExtraSlots(int count) {
    return 'VIP +$count dodatkowe miejsca';
  }

  @override
  String get propertyManageNightclub => 'Zarządzaj klubem nocnym';

  @override
  String get blackMarket => 'Czarny rynek';

  @override
  String get garage => 'Garaż';

  @override
  String get garageCapacity => 'Pojemność garażu';

  @override
  String garageVehiclesCount(String current, String total) {
    return '$current / $total pojazdów';
  }

  @override
  String garageUpgradeWithCost(String cost) {
    return 'Uaktualnij ($cost €)';
  }

  @override
  String get garageMaxLevel => 'Maksymalny poziom';

  @override
  String garageLevelRemaining(String level, String spots) {
    return 'Poziom $level | Pozostało $spots miejsc';
  }

  @override
  String get noCarsInGarage => 'Żadnych samochodów w twoim garażu';

  @override
  String get stealCarsToStart => 'Na początek ukradnij kilka samochodów!';

  @override
  String get stealFailed => 'Kradzież nie powiodła się';

  @override
  String get garageUpgradeFailed => 'Nie udało się ulepszyć garażu';

  @override
  String get saleFailed => 'Sprzedaż nie powiodła się';

  @override
  String get vehicleTransported => 'Pojazd przetransportowany pomyślnie!';

  @override
  String get vehicleTransportFailed =>
      'Nie udało się przetransportować pojazdu';

  @override
  String get listOnMarket => 'Lista na rynku';

  @override
  String marketValue(String amount) {
    return 'Wartość rynkowa: €$amount';
  }

  @override
  String get askingPrice => 'Cena wywoławcza (€)';

  @override
  String get enterPrice => 'Wprowadź cenę';

  @override
  String get list => 'Lista';

  @override
  String get invalidPrice => 'Nieprawidłowa cena';

  @override
  String get vehicleListed => 'Pojazd wystawiony na rynku!';

  @override
  String get listVehicleFailed => 'Nie udało się wyświetlić listy pojazdów';

  @override
  String get marina => 'Marina';

  @override
  String get hospital => 'Szpital';

  @override
  String get court => 'Sąd';

  @override
  String get casino => 'Kasyno';

  @override
  String get errorLoadingCasinoStatus => 'Nie można sprawdzić statusu kasyna';

  @override
  String get errorLoadingCasinoGames => 'Nie można załadować gier kasynowych';

  @override
  String casinoPrice(String amount) {
    return 'Cena: $amount €';
  }

  @override
  String get startingCapital => 'Kapitał początkowy';

  @override
  String get bankrollHelper => 'To będzie budżet kasyna';

  @override
  String get casinoOwnershipInfoTitle => 'O własności kasyna:';

  @override
  String get casinoClosedTitle => 'KASYNO ZAMKNIĘTE';

  @override
  String get casinoOwnedByLabel => 'Właścicielem tego kasyna jest:';

  @override
  String get casinoNoOwner => 'To kasyno nie ma jeszcze właściciela';

  @override
  String get casinoPurchasePriceLabel => 'Cena zakupu:';

  @override
  String get casinoOwnerInfo =>
      'Jako właściciel zarządzasz bankrollem kasyna i zarabiasz pieniądze, gdy gracze przegrywają!';

  @override
  String get casinoGameSlotsName => 'Automat';

  @override
  String get casinoGameSlotsDesc =>
      'Zakręć bębnami i wygraj nawet 100-krotność swojego zakładu!';

  @override
  String get casinoGameBlackjackName => 'Maczuga';

  @override
  String get casinoGameBlackjackDesc =>
      'Pokonaj krupiera i wygraj nawet dwukrotnie większą kwotę zakładu!';

  @override
  String get casinoGameRouletteName => 'Ruletka';

  @override
  String get casinoGameRouletteDesc =>
      'Wybierz swój numer i wygraj aż do 35-krotności swojego zakładu!';

  @override
  String get casinoGameDiceName => 'Kostka do gry';

  @override
  String get casinoGameDiceDesc =>
      'Rzuć kostką i wygraj aż do 6-krotności swojego zakładu!';

  @override
  String get difficultyEasy => 'ŁATWY';

  @override
  String get difficultyMedium => 'ŚREDNI';

  @override
  String get difficultyHard => 'TWARDY';

  @override
  String get casinoDepositTitle => 'Wpłać pieniądze';

  @override
  String get casinoWithdrawTitle => 'Wypłacić pieniądze';

  @override
  String get amount => 'Kwota';

  @override
  String get deposit => 'Depozyt';

  @override
  String get withdraw => 'Wycofać';

  @override
  String casinoDepositSuccess(String amount) {
    return '$amount € zdeponowane w bankrollu kasyna';
  }

  @override
  String casinoWithdrawSuccess(String amount) {
    return '€$amount wycofane z bankrolla kasyna';
  }

  @override
  String get casinoDepositError => 'Błąd podczas składania depozytu';

  @override
  String get casinoWithdrawError => 'Błąd podczas wycofywania';

  @override
  String get casinoMinBankroll =>
      'W bankrollu musi pozostać co najmniej 10 000 euro';

  @override
  String casinoMaxWithdraw(String amount) {
    return 'Maksymalnie: $amount €';
  }

  @override
  String get casinoManagementTitle => 'Zarządzanie kasynem';

  @override
  String casinoBankruptWarning(String amount) {
    return 'OSTRZEŻENIE: Bankroll kasyna jest zbyt niski! \nWpłać co najmniej $amount €, aby uniknąć bankructwa.';
  }

  @override
  String get casinoBankroll => 'Bankroll kasyna';

  @override
  String get casinoStatsTitle => 'Statystyka';

  @override
  String get casinoTotalReceived => 'Łącznie otrzymane:';

  @override
  String get casinoTotalPaidOut => 'Całkowita wypłacona kwota:';

  @override
  String get casinoNetProfit => 'Zysk netto:';

  @override
  String casinoProfitMargin(String percent) {
    return 'Marża zysku: $percent%';
  }

  @override
  String get casinoManagementInfoTitle => 'Informacje o zarządzaniu kasynem';

  @override
  String get casinoManagementInfo5 =>
      '• Możesz wpłacić lub wypłacić pieniądze w dowolnym momencie';

  @override
  String get casinoHubChooseGameHint => 'Wybierz grę i postaw zakład';

  @override
  String get casinoPlayButton => 'Grać';

  @override
  String get casinoGameBaccaratName => 'Bakarat';

  @override
  String get casinoGameBaccaratDesc =>
      'Postaw zakład na gracza, bankiera lub remis ze strategicznymi kursami.';

  @override
  String get casinoGameVideoPokerName => 'Wideopoker';

  @override
  String get casinoGameVideoPokerDesc =>
      'Dobierz 5 kart i uderzaj kombinacjami aż do pokera królewskiego.';

  @override
  String get casinoBuyCasinoLockedTitle => 'Kup kasyno (zablokowane)';

  @override
  String get casinoErrGenericPlay => 'Coś poszło nie tak';

  @override
  String get casinoErrSpinFailed => 'Błąd podczas wirowania';

  @override
  String get casinoErrBetFailed => 'Błąd podczas obstawiania';

  @override
  String get casinoErrGambleFailed => 'Błąd podczas gry';

  @override
  String get casinoErrThrowFailed => 'Błąd podczas toczenia';

  @override
  String get casinoErrCasinoNotFound =>
      'Nie znaleziono kasyna. Upewnij się, że kasyno zostało zakupione w tym kraju.';

  @override
  String get casinoErrInsufficientFunds => 'Za mało pieniędzy';

  @override
  String get casinoErrInsufficientBankrollPayout =>
      'Bankroll kasyna jest zbyt niski dla tej wypłaty';

  @override
  String casinoErrNetwork(String error) {
    return 'Błąd sieci: $error';
  }

  @override
  String get casinoResultYouWon => 'Wygrałeś!';

  @override
  String get casinoResultYouLost => 'Zaginiony';

  @override
  String get casinoResultYouWonCelebrate => '🎉 Wygrałeś!';

  @override
  String casinoWonEuroAmount(String amount) {
    return 'Wygrałeś $amount €!';
  }

  @override
  String casinoLostEuroAmount(String amount) {
    return 'Straciłeś $amount €';
  }

  @override
  String get casinoYouLostPlain => 'Przegrałeś';

  @override
  String casinoBlackjackWinAmount(String amount) {
    return 'Wygrałeś $amount €!';
  }

  @override
  String casinoBlackjackCelebrate(String amount) {
    return 'MACZUGA! €$amount';
  }

  @override
  String get casinoAgain => 'Ponownie';

  @override
  String get casinoBankruptTitle => 'Kasyno upadłe!';

  @override
  String get casinoBankruptBody =>
      'Kasyno zbankrutowało! \n\nWłaściciel nie miał wystarczającej ilości gotówki na koncie, aby pokryć wszystkie wypłaty. \n\nKasyno jest teraz zamknięte i można je kupić ponownie.';

  @override
  String get casinoBackToCasino => 'Powrót do kasyna';

  @override
  String casinoRouletteNumberColor(String number, String color) {
    return 'Liczba: $number ($color)';
  }

  @override
  String get casinoColorGreen => 'zielony';

  @override
  String get casinoColorRed => 'czerwony';

  @override
  String get casinoColorBlack => 'czarny';

  @override
  String get casinoRoulettePickBet => 'Wybierz swój zakład';

  @override
  String get casinoRouletteBetRed => 'Czerwony';

  @override
  String get casinoRouletteBetBlack => 'Czarny';

  @override
  String get casinoRouletteBetEven => 'Nawet';

  @override
  String get casinoRouletteBetOdd => 'Dziwne';

  @override
  String get casinoRouletteSpinButton => 'KRĘCIĆ SIĘ!';

  @override
  String casinoRouletteLastResult(String number) {
    return 'Ostatni wynik: $number';
  }

  @override
  String get casinoBetLabel => 'Zakład';

  @override
  String get casinoBlackjackPlayButton => 'GRAĆ!';

  @override
  String get casinoSlotSpinButton => 'KRĘCIĆ SIĘ!';

  @override
  String get casinoDiceRollButton => 'ROLKA!';

  @override
  String get casinoBlackjackYourCards => 'Twoje karty';

  @override
  String get casinoBlackjackDealerCards => 'Karty dealera';

  @override
  String casinoBlackjackDealerTotal(String total) {
    return 'Dealer: $total';
  }

  @override
  String casinoBlackjackYouTotal(String total) {
    return 'Ty: $total';
  }

  @override
  String casinoDiceTotalShowing(String total) {
    return 'Razem: $total';
  }

  @override
  String get casinoDicePredictTitle => 'Przewidywać';

  @override
  String get casinoDiceLowLabel => 'Niski (2-6)';

  @override
  String get casinoDiceHighLabel => 'Wysoka (8-12)';

  @override
  String get casinoDiceOddsHint =>
      'Niski/Wysoki płaci 2x • Dokładna suma płaci 6x';

  @override
  String get casinoSlotPayoutTableTitle => 'Tabela wypłat';

  @override
  String get casinoBaccaratPlayer => 'Odtwarzacz';

  @override
  String get casinoBaccaratBanker => 'Bankier';

  @override
  String get casinoBaccaratTieBet => 'Krawat';

  @override
  String casinoWinnerPrefix(String who) {
    return 'Zwycięzca: $who';
  }

  @override
  String casinoPayoutEuro(String amount) {
    return 'Wypłata: €$amount';
  }

  @override
  String get casinoNoPayout => 'Brak wypłaty';

  @override
  String casinoResultEuro(String amount) {
    return 'Wynik: $amount €';
  }

  @override
  String get casinoDealing => 'Postępowanie…';

  @override
  String get casinoDealCaps => 'UMOWA';

  @override
  String get casinoVideoPokerDrawCards => 'DOBIERZ KARTY';

  @override
  String get casinoVideoPokerDrawHint => 'Narysuj rękę';

  @override
  String get casinoVideoPokerRoyalFlush => 'Poker królewski';

  @override
  String get casinoVideoPokerStraightFlush => 'Poker';

  @override
  String get casinoVideoPokerFourKind => 'Czwórka';

  @override
  String get casinoVideoPokerFullHouse => 'Pełna sala';

  @override
  String get casinoVideoPokerFlush => 'Spłukać';

  @override
  String get casinoVideoPokerStraight => 'Prosty';

  @override
  String get casinoVideoPokerThreeKind => 'Trójka w swoim rodzaju';

  @override
  String get casinoVideoPokerTwoPair => 'Dwie pary';

  @override
  String get casinoVideoPokerJacksOrBetter => 'Jacks or Better';

  @override
  String get casinoVideoPokerNoWinningHand => 'Żadnej zwycięskiej ręki';

  @override
  String get casinoVideoPokerPayoutTableLong =>
      'Tabela wypłat: Walety+ 1x • Dwie pary 2x • Tripy 3x • Strój 4x • Kolor 6x • Full House 9x • Cztery 25x • Poker prosty 50x • Królewski 250x';

  @override
  String get bankScreenLoadFailed => 'Nie udało się załadować banku';

  @override
  String bankScreenErrNetwork(String details) {
    return 'Błąd sieci: $details';
  }

  @override
  String bankScreenCounterpartyTo(String username) {
    return 'Do: $username';
  }

  @override
  String bankScreenCounterpartyFrom(String username) {
    return 'Od: $username';
  }

  @override
  String get bankScreenDepositSuccess => 'Wpłata pomyślna';

  @override
  String get bankScreenDepositFailed => 'Wpłata nie powiodła się';

  @override
  String bankScreenDailyDepositQuota(String remaining, String cap) {
    return 'Wolne depozyty pozostały dzisiaj: $remaining z $cap. Większe ilości należy wyprać.';
  }

  @override
  String get bankScreenDailyDepositCapReached =>
      'Dzisiejszy limit darmowych wpłat został wyczerpany. Wypierz pozostałą gotówkę lub poczekaj do jutra (UTC).';

  @override
  String bankScreenDepositCapError(String remaining) {
    return 'To przekracza pozostałą kwotę dzisiejszego bezpłatnego depozytu ($remaining). Wpłać do tej kwoty lub skorzystaj z prania brudnych pieniędzy.';
  }

  @override
  String get bankScreenWithdrawSuccess => 'Wypłata powiodła się';

  @override
  String get bankScreenWithdrawFailed => 'Wypłata nie powiodła się';

  @override
  String bankScreenTransferSuccess(String amount, String recipient) {
    return '€$amount przeniesione do $recipient';
  }

  @override
  String get bankScreenTransferFailed => 'Transfer nie powiódł się';

  @override
  String get bankScreenErrRecipientNotFound => 'Nie znaleziono gracza';

  @override
  String get bankScreenErrCannotTransferToSelf =>
      'Nie możesz przenieść się do siebie';

  @override
  String get bankScreenErrInsufficientBalance =>
      'Niewystarczające saldo bankowe';

  @override
  String get bankScreenErrInvalidAmount => 'Nieprawidłowa kwota';

  @override
  String get bankScreenTryAgain => 'Spróbuj ponownie';

  @override
  String get bankScreenWorldwideSubtitle => 'Bank (dostępny na całym świecie)';

  @override
  String bankScreenCashOnHand(int amount) {
    return 'Gotówka w kasie: €$amount';
  }

  @override
  String bankScreenBalanceLine(int amount) {
    return 'Saldo bankowe: €$amount';
  }

  @override
  String get bankScreenAmountLabel => 'Kwota';

  @override
  String get bankScreenDescriptionOptional => 'Opis (opcjonalnie)';

  @override
  String get bankScreenDescriptionDepositHint =>
      'Będą przechowywane wraz z Twoim depozytem lub wypłatą w transakcjach.';

  @override
  String get bankScreenDepositButton => 'Depozyt';

  @override
  String get bankScreenWithdrawButton => 'Wycofać';

  @override
  String get bankScreenTransferSectionTitle => 'Transfer do gracza';

  @override
  String get bankScreenRecipientUsername => 'Nazwa użytkownika odbiorcy';

  @override
  String get bankScreenRecentRecipients => 'Niedawni odbiorcy';

  @override
  String get bankScreenDescriptionTransferHint =>
      'Odbiorca zobaczy ten opis także w transakcjach.';

  @override
  String get bankScreenTransferButton => 'Przenosić';

  @override
  String get bankScreenTransactionsTitle => 'Transakcje';

  @override
  String bankScreenTransactionsTotal(int count) {
    return '$count łącznie';
  }

  @override
  String get bankScreenSummaryDeposits => 'Depozyty';

  @override
  String get bankScreenSummaryWithdrawals => 'Wypłaty';

  @override
  String get bankScreenSummarySent => 'Wysłano';

  @override
  String get bankScreenSummaryReceived => 'Otrzymane';

  @override
  String get bankScreenNoTransactions => 'Nie ma jeszcze żadnych transakcji';

  @override
  String get bankScreenTxnDeposit => 'Depozyt';

  @override
  String get bankScreenTxnWithdraw => 'Wycofanie';

  @override
  String get bankScreenTxnTransferSent => 'Przelew wysłany';

  @override
  String get bankScreenTxnTransferReceived => 'Przelew otrzymany';

  @override
  String get bankScreenPrevious => 'Poprzedni';

  @override
  String get bankScreenNext => 'Następny';

  @override
  String bankScreenPageOf(int current, int total) {
    return 'Strona $current z $total';
  }

  @override
  String bankScreenRankLabel(String rank) {
    return 'Ranga $rank';
  }

  @override
  String get retry => 'Spróbować ponownie';

  @override
  String get doAction => 'Do';

  @override
  String get pay => 'Płacić';

  @override
  String get success => 'Sukces';

  @override
  String get jail => 'Więzienie';

  @override
  String get cooldown => 'Czas odnowienia';

  @override
  String get requiredRank => 'Wymagana ranga gracza';

  @override
  String get playerRankLabel => 'Ranga gracza';

  @override
  String get loading => 'Załadunek...';

  @override
  String get trade => 'Handel';

  @override
  String get buy => 'Kupić';

  @override
  String get sell => 'Sprzedać';

  @override
  String get price => 'Cena';

  @override
  String get total => 'Całkowity';

  @override
  String available(String count) {
    return 'Dostępne: $count';
  }

  @override
  String get notEnoughMoney => 'Nie masz dość pieniędzy!';

  @override
  String get confirm => 'Potwierdzać';

  @override
  String get close => 'Zamknąć';

  @override
  String get viewOffer => 'Zobacz ofertę';

  @override
  String get unexpectedResponse => 'Nieoczekiwana odpowiedź interfejsu API';

  @override
  String get errorLoadingMenu => 'Błąd ładowania menu';

  @override
  String get unknownError => 'Nieznany błąd';

  @override
  String get food => 'Żywność';

  @override
  String get drink => 'Drink';

  @override
  String get work => 'Praca';

  @override
  String cooldownMinutes(String minutes) {
    return 'Czas odnowienia: $minutes min';
  }

  @override
  String xpReward(String amount) {
    return 'XP: +$amount';
  }

  @override
  String get fly => 'Latać';

  @override
  String get purchased => 'Kupiony!';

  @override
  String get sold => 'Sprzedany!';

  @override
  String get errorBuying => 'Błąd podczas zakupu';

  @override
  String get errorSelling => 'Błąd podczas sprzedaży';

  @override
  String get goods => 'Towary';

  @override
  String get marketplace => 'Rynek';

  @override
  String get myListings => 'Moje zestawienia';

  @override
  String get inventory => 'Spis';

  @override
  String get backpacks => 'Plecaki';

  @override
  String get materials => 'Przybory';

  @override
  String get production => 'Produkcja';

  @override
  String get stock => 'Magazyn';

  @override
  String get retryAgain => 'Spróbować ponownie';

  @override
  String get noVehiclesAvailable => 'Brak dostępnych pojazdów';

  @override
  String get noListings => 'Brak ofert';

  @override
  String get condition => 'Stan';

  @override
  String get yourHealth => 'Twoje zdrowie';

  @override
  String get criticalHealthWarning =>
      '⚠️KRYTYCZNE! Musisz natychmiast jechać do szpitala!';

  @override
  String get lowHealthWarning => '⚠️ Niskie zdrowie! Bądź ostrożny.';

  @override
  String get information => 'Informacja';

  @override
  String get contrabandFlowersName => 'Kwiaty';

  @override
  String get contrabandFlowersDesc =>
      'Holenderskie tulipany i inne kwiaty przeznaczone do handlu międzynarodowego';

  @override
  String get contrabandElectronicsName => 'Elektronika';

  @override
  String get contrabandElectronicsDesc =>
      'Zaawansowana elektronika i podzespoły komputerowe';

  @override
  String get contrabandDiamondsName => 'Diamenty';

  @override
  String get contrabandDiamondsDesc => 'Szorstkie i oszlifowane diamenty';

  @override
  String get contrabandWeaponsName => 'Broń';

  @override
  String get contrabandWeaponsDesc => 'Nielegalna broń i amunicja';

  @override
  String get contrabandPharmaceuticalsName => 'Farmaceutyki';

  @override
  String get contrabandPharmaceuticalsDesc => 'Rzadkie produkty farmaceutyczne';

  @override
  String get multiplier => 'Mnożnik';

  @override
  String get sellPrice => 'Cena sprzedaży';

  @override
  String get boughtFor => 'Kupiony dla';

  @override
  String get profit => 'Zysk';

  @override
  String get loss => 'Strata';

  @override
  String ownedQuantity(String quantity) {
    return 'Posiadane: $quantity';
  }

  @override
  String spoilsInHours(String hours) {
    return '⚠️ Łupy za ${hours}h';
  }

  @override
  String get spoiledWorthless => '💀 Zepsute - Bezwartościowe';

  @override
  String get vehicleBought => 'Pojazd pomyślnie kupiony!';

  @override
  String get purchaseFailed => 'Zakup nie powiódł się';

  @override
  String get listingRemoved => 'Lista została usunięta';

  @override
  String get noItemsInInventory => 'Brak pozycji w ekwipunku';

  @override
  String get buyItemsInBuyTab => 'Kupuj przedmioty w zakładce Kup';

  @override
  String errorLoadingMarketData(String error) {
    return 'Błąd podczas ładowania danych rynkowych: $error';
  }

  @override
  String get tradeLoadGoodsFailed => 'Nie można załadować katalogu towarów';

  @override
  String get tradeLoadPricesFailed => 'Nie udało się wczytać aktualnych cen';

  @override
  String get tradeLoadInventoryFailed =>
      'Nie można załadować Twojego ekwipunku handlowego';

  @override
  String get tradePartialDataBanner =>
      'Nie udało się odświeżyć niektórych danych rynkowych. Pociągnij w dół, aby spróbować ponownie.';

  @override
  String get tradeMarketLoadAllFailed =>
      'Nie udało się załadować rynku. Pociągnij w dół, aby spróbować ponownie.';

  @override
  String get tradeNoGoodsLoaded => 'W tej chwili nie ma żadnych towarów.';

  @override
  String get tradeRiskPanelTitle => 'Ryzyko związane z podróżami i rynkiem';

  @override
  String get tradeRiskPanelSubtitle =>
      'Każdy towar wykazuje oznaki zepsucia, wahań cen, szkód spowodowanych podróżą lub konfiskaty, jeśli ma to zastosowanie.';

  @override
  String get tradeRiskInsightBody =>
      'KWIATY: zepsuć po upływie czasu od zakupu — sprzedać w terminie. \nDIAMENTY: ceny kupna wahają się w zależności od zmienności; zaplanuj, gdzie będziesz sprzedawać za granicą. \nELEKTRONIKA: może stracić stan przy każdej podróży, co obniża wartość odsprzedaży. \nBROŃ i FARMACEUTYKI: podczas podróży może nastąpić częściowe zatrzymanie — trzymaj niski poziom poszukiwanego i zapoznaj się z przepisami dotyczącymi przemytu. \nCeny na tym ekranie zawierają już mnożnik Twojego aktualnego kraju.';

  @override
  String tradeRiskSpoilageHours(String hours) {
    return '${hours}h okno zepsucia';
  }

  @override
  String tradeRiskVolatilityPct(String pct) {
    return '±$pct% wahań cen';
  }

  @override
  String tradeRiskConfiscationPct(String pct) {
    return '$pct% ryzyka napadów na podróż';
  }

  @override
  String tradeRiskDamageTripPct(String pct) {
    return '$pct% szans na obrażenia na podróż';
  }

  @override
  String get appeal => 'Odwołanie';

  @override
  String get submitAppeal => 'Prześlij odwołanie';

  @override
  String get bribeJudge => 'Sędzia łapówkowy';

  @override
  String get bribe => 'Przekupić';

  @override
  String get courtLoadFailed =>
      'Nie udało się załadować danych sądowych. Spróbuj ponownie.';

  @override
  String get courtAppealDialogIntro =>
      'Czy chcesz złożyć apelację od tego wyroku?';

  @override
  String courtCostLine(String amount) {
    return 'Koszt: $amount';
  }

  @override
  String courtJudgeNamed(String name) {
    return 'Sędzia: $name';
  }

  @override
  String courtCorruptibilityPercent(String percent) {
    return 'Zepsucie: $percent%';
  }

  @override
  String get courtAppealSuccessHint =>
      'W przypadku powodzenia: redukcja wyroku o około 20–40%.';

  @override
  String courtAppealGrantedMinutes(String minutes) {
    return 'Odwołanie uznane. Nowe zdanie: $minutes minut.';
  }

  @override
  String get courtAppealDenied => 'Odwołanie odrzucone.';

  @override
  String get courtBribeOfferIntro =>
      'Zaproponuj kwotę. Kwota jest zawsze potrącana, nawet w przypadku niepowodzenia.';

  @override
  String courtBribeAmountFormatted(String amount) {
    return 'Kwota łapówki: $amount';
  }

  @override
  String courtBribeSliderLabel(String thousands) {
    return '€$thousands tys';
  }

  @override
  String courtEstimatedSuccessChance(String percent) {
    return 'Szacowana szansa na sukces: ~$percent%';
  }

  @override
  String get courtBribeSuccessReleased =>
      'Sędzia przekupiony. Jesteś natychmiast zwolniony.';

  @override
  String get courtBribeFailedDebited =>
      'Przekupstwo nie powiodło się. Kwota została w dalszym ciągu odliczona.';

  @override
  String get courtRecordActive => 'Aktywny';

  @override
  String get courtRecordServed => 'Podawane';

  @override
  String courtHistoryAppealGranted(String fromMinutes, String toMinutes) {
    return 'Apelacja uwzględniona: $fromMinutes → $toMinutes minut';
  }

  @override
  String courtHistoryAppealDenied(String minutes) {
    return 'Odwołanie odrzucone: pozostało $minutes minut';
  }

  @override
  String courtHistoryBribeFailedPaid(String amount) {
    return 'Łapówka nie powiodła się: $amount zapłacono';
  }

  @override
  String courtHistoryConvictedMinutes(String minutes) {
    return 'Skazany na $minutes minut';
  }

  @override
  String get courtPartialLoadWarning =>
      'Uwaga: nie udało się załadować części danych sądowych. Pociągnij, aby odświeżyć i spróbować ponownie.';

  @override
  String get courtNoActiveSentence => 'Brak aktywnego zdania';

  @override
  String get courtNotJailedHint =>
      'Obecnie nie przebywasz w więzieniu. Twoja przeszłość kryminalna pozostaje widoczna poniżej.';

  @override
  String get courtActiveSentenceTitle => 'Aktywne zdanie';

  @override
  String get courtDelictLabel => 'Przestępczość';

  @override
  String courtTotalSentenceMinutes(String minutes) {
    return 'Łączne zdanie: $minutes minut';
  }

  @override
  String courtRemainingMinutes(String minutes) {
    return 'Pozostało: $minutes minut';
  }

  @override
  String courtAppealCostCurrent(String amount) {
    return 'Aktualny koszt odwołania: $amount';
  }

  @override
  String get courtButtonAppeal => 'Odwołanie';

  @override
  String get courtButtonBribeJudge => 'Łapówka sędzia';

  @override
  String get courtUnknownCrime => 'Nieznany';

  @override
  String courtSentenceMinutesOnly(String minutes) {
    return 'Zdanie: $minutes minut';
  }

  @override
  String courtSentenceReducedMinutes(String original, String reduced) {
    return 'Zdanie: $original → $reduced minut';
  }

  @override
  String courtDateLabeled(String datetime) {
    return 'Data: $datetime';
  }

  @override
  String get courtHistoryHeading => 'Historia sądu';

  @override
  String get courtAppealSubmitted => 'Odwołanie złożone';

  @override
  String get courtCriminalRecordTitle => 'Rejestr karny';

  @override
  String courtTotalConvictions(String count) {
    return 'Całkowita liczba wyroków skazujących: $count';
  }

  @override
  String get courtRecordBribeNote =>
      'Przeszłe przekonania pozostają widoczne. Skuteczna łapówka dla sędziego rozwiązuje tylko jedną aktywną sprawę.';

  @override
  String get courtNoConvictionsYet =>
      'Nie odnotowano jeszcze żadnych wyroków skazujących.';

  @override
  String get treated => 'Leczony!';

  @override
  String healthRestored(String hp, String cost) {
    return '+$hp HP za $cost €';
  }

  @override
  String get treatmentOptions => 'Opcje leczenia';

  @override
  String get youAreDead => 'Nie żyjesz! Koniec gry.';

  @override
  String get emergencyOnly => 'Leczenie awaryjne dostępne tylko poniżej 10 HP';

  @override
  String emergencyTreatment(String hp) {
    return 'Leczenie doraźne! Darmowe +$hp HP';
  }

  @override
  String get byValue => 'Według wartości';

  @override
  String get byCondition => 'Według warunku';

  @override
  String get byFuel => 'Paliwem';

  @override
  String get byName => 'Według nazwy';

  @override
  String get stealCar => 'Ukraść samochód';

  @override
  String get stealBoat => 'Ukraść łódź';

  @override
  String get sellVehicle => 'Sprzedaj pojazd';

  @override
  String get sellBoat => 'Sprzedaj łódź';

  @override
  String get confirmSellVehicle => 'Czy na pewno chcesz sprzedać ten pojazd?';

  @override
  String get confirmSellBoat => 'Czy na pewno chcesz sprzedać tę łódź?';

  @override
  String get carStolen => 'Skutecznie skradziono samochód!';

  @override
  String get boatStolen => 'Skradziono łódź!';

  @override
  String get vehicleTypeCar => 'Samochód';

  @override
  String get vehicleTypeBoat => 'Łódź';

  @override
  String stolenVehicleTitle(String vehicleType) {
    return '$vehicleType skradzione!';
  }

  @override
  String unknownVehicleType(String vehicleType) {
    return 'Nieznany $vehicleType';
  }

  @override
  String get vehicleStatSpeed => 'Prędkość';

  @override
  String get vehicleStatFuel => 'Paliwo';

  @override
  String get vehicleStatCargo => 'Ładunek';

  @override
  String get vehicleStatStealth => 'Podstęp';

  @override
  String get continueAction => 'Kontynuować';

  @override
  String get vehicleSold => 'Pojazd sprzedany pomyślnie!';

  @override
  String get boatSold => 'Łódź pomyślnie sprzedana!';

  @override
  String get garageUpgraded => 'Garaż zmodernizowany!';

  @override
  String get marinaUpgraded => 'Marina została pomyślnie zmodernizowana!';

  @override
  String get marinaCapacity => 'Pojemność Mariny';

  @override
  String marinaBoatsCount(String current, String total) {
    return '$current / $total łodzie';
  }

  @override
  String marinaUpgradeWithCost(String cost) {
    return 'Uaktualnij ($cost €)';
  }

  @override
  String get marinaMaxLevel => 'Maksymalny poziom';

  @override
  String marinaLevelRemaining(String level, String remaining) {
    return 'Poziom $level | Pozostało $remaining miejsc';
  }

  @override
  String get noBoatsInMarina => 'Brak łodzi w Twojej marinie';

  @override
  String get stealBoatsToStart => 'Na początek ukradnij kilka łodzi!';

  @override
  String get marinaUpgradeFailed => 'Modernizacja mariny nie powiodła się';

  @override
  String get boatShipped => 'Łódź została wysłana pomyślnie!';

  @override
  String get boatShipFailed => 'Wysyłka łodzią nie powiodła się';

  @override
  String get buyProperty => 'Kup nieruchomość';

  @override
  String propertyBought(String name) {
    return '$name zakupione!';
  }

  @override
  String propertyUpgraded(String level) {
    return 'Nieruchomość podniesiona do poziomu $level!';
  }

  @override
  String get errorLoadingProperties => 'Błąd ładowania właściwości';

  @override
  String get errorUpgrading => 'Błąd aktualizacji';

  @override
  String networkError(String error) {
    return 'Błąd sieci: $error';
  }

  @override
  String get unknownResponse => 'Nieznana odpowiedź';

  @override
  String incomeCollected(String amount) {
    return 'Zebrano $amount €!';
  }

  @override
  String get buyCasino => 'Kup kasyno';

  @override
  String get manageCasino => 'Zarządzaj kasynem';

  @override
  String get casinoBought => 'Kasyno pomyślnie kupione! 🎰';

  @override
  String get errorBuyCasino => 'Wystąpił błąd podczas zakupu kasyna';

  @override
  String minimumDeposit(String amount) {
    return 'Minimalny depozyt wynosi €$amount';
  }

  @override
  String get casinoInfo1 =>
      'Gracze stawiają zakłady przeciwko bankrollowi kasyna';

  @override
  String get casinoInfo2 => 'Wygrane są wypłacane z bankrolla';

  @override
  String get casinoInfo3 => 'Możesz wpłacać i wypłacać pieniądze';

  @override
  String get casinoInfo4 => 'Wymagany minimalny kapitał w wysokości 10 000 EUR';

  @override
  String get casinoInfo5 => 'Poniżej: upadłość';

  @override
  String get members => 'Członkowie';

  @override
  String get location => 'Lokalizacja';

  @override
  String get level => 'Poziom';

  @override
  String get alreadyFullHealth => 'Jesteś już w pełni zdrowia!';

  @override
  String get errorTreatment => 'Błąd podczas leczenia';

  @override
  String waitMinutes(String minutes) {
    return 'Na kolejny zabieg musisz poczekać $minutes minut więcej!';
  }

  @override
  String get emergencyHelp => 'Pomoc w nagłych wypadkach';

  @override
  String onlyNeedHp(String hp) {
    return '(Potrzebujesz tylko $hp HP)';
  }

  @override
  String get emergencyInfo =>
      '• 🊘 Pomoc w nagłych wypadkach jest BEZPŁATNA poniżej 10 KM (+20 KM)';

  @override
  String get hospitalInfo1 =>
      '• Zdrowie spada w przypadku popełniania przestępstw';

  @override
  String get hospitalInfo2 => '• Przy 0 HP nie możesz popełniać przestępstw';

  @override
  String hospitalInfo3(String cost) {
    return '• Koszt leczenia wynosi $cost € za czas';
  }

  @override
  String hospitalInfo4(String amount) {
    return '• Możesz przywrócić maksymalnie $amount HP na zabieg';
  }

  @override
  String get hospitalInfo5 => '• ⏱️ 1 godzina przerwy pomiędzy zabiegami';

  @override
  String get hospitalInfo6 =>
      '• 💚 Leczenie pasywne: +5 HP na 5 minut (jeśli HP > 0)';

  @override
  String get medicalTreatment => 'Leczenie medyczne';

  @override
  String get restoreCritical => 'Przywróć +20 HP (stan krytyczny)';

  @override
  String get hospitalCooldownTitle => 'Leczenie w okresie rekonwalescencji';

  @override
  String hospitalCooldownNextAvailable(String duration) {
    return 'Następny zabieg dostępny za: $duration';
  }

  @override
  String get hospitalMedicalStatusTitle => 'Stan zdrowia';

  @override
  String hospitalIcuRemaining(String duration) {
    return 'OIOM: $duration';
  }

  @override
  String hospitalHpLine(String hp) {
    return 'HP $hp/100';
  }

  @override
  String get hospitalIcuTriageTitle => 'Przegląd OIOM-u i segregacji pacjentów';

  @override
  String hospitalIcuPatientRemaining(String duration) {
    return 'Pacjent na OIT. Pozostały czas: $duration';
  }

  @override
  String get hospitalCriticalStatusDetected =>
      'Wykryto stan krytyczny. Zalecana opieka w nagłych przypadkach.';

  @override
  String get hospitalStableStatus =>
      'Stabilny. Możliwość regularnego leczenia.';

  @override
  String get hospitalRefreshMedicalRecord => 'Odśwież dokumentację medyczną';

  @override
  String get hospitalStandardTreatmentTitle => 'Standardowe leczenie';

  @override
  String hospitalStandardTreatmentSubtitle(String amount) {
    return 'Niedrogi • przywraca do $amount HP';
  }

  @override
  String get hospitalIntensiveTreatmentTitle => 'Intensywne leczenie';

  @override
  String hospitalIntensiveTreatmentSubtitle(String amount) {
    return 'Szybsza regeneracja • do $amount HP';
  }

  @override
  String hospitalIntensiveTreatmentInfoLine(String cost, String amount) {
    return '• Intensywne leczenie: $cost € za regenerację do $amount HP.';
  }

  @override
  String restoreUp(String amount) {
    return 'Przywróć do $amount HP';
  }

  @override
  String get cost => 'Koszt';

  @override
  String crimeErrorToolRequired(String tools) {
    return '⚒️ Do tego przestępstwa potrzebujesz $tools';
  }

  @override
  String crimeErrorToolInStorage(String tools) {
    return '⚒️ Masz $tools, ale w domu! Przejdź do Zapasy → Transfer';
  }

  @override
  String get crimeErrorVehicleRequired =>
      '🚗 Do tego przestępstwa potrzebny jest pojazd';

  @override
  String get crimeErrorVehicleNotFound => '🚗 Nie znaleziono pojazdu';

  @override
  String get crimeErrorNotVehicleOwner =>
      '🚗 Nie jesteś właścicielem tego pojazdu';

  @override
  String get crimeErrorVehicleBroken =>
      '🚗 Twój pojazd jest zepsuty i wymaga naprawy';

  @override
  String get crimeErrorNoFuel => '⛽ W Twoim pojeździe nie ma paliwa';

  @override
  String get crimeErrorLevelTooLow =>
      '⭐ Twój poziom jest zbyt niski dla tego przestępstwa';

  @override
  String get crimeErrorInvalidCrimeId => '❌ Nieprawidłowe przestępstwo';

  @override
  String get crimeErrorWeaponRequired =>
      '🔫 Do tego przestępstwa potrzebujesz broni';

  @override
  String get crimeErrorWeaponBroken =>
      '🔫 Twoja broń jest zepsuta i wymaga naprawy';

  @override
  String get crimeErrorNoAmmo => '🔫 Nie masz amunicji';

  @override
  String get crimeErrorGeneric => '❌ Coś poszło nie tak z tą zbrodnią';

  @override
  String get inventoryFull =>
      '🎒 Twój ekwipunek jest pełny! Przechowuj narzędzia w obiekcie';

  @override
  String get storageFull => '📦 Magazyn nieruchomości jest pełny';

  @override
  String get inventoryCrimeWeaponTitle => 'Wybrana broń zbrodni';

  @override
  String get inventoryCrimeWeaponHint => 'Wybierz broń do zbrodni';

  @override
  String get inventoryCrimeWeaponHelp =>
      'Wybierz tutaj swoją broń zbrodni. Ekran przestępstw natychmiast użyje tego wyboru.';

  @override
  String get inventoryCrimeWeaponEmpty =>
      'Brak użytecznej broni w ekwipunku. Najpierw kup lub przenieś broń do przenoszonych przedmiotów.';

  @override
  String get inventoryCarriedEmpty =>
      'Nie masz przy sobie żadnych narzędzi, broni ani amunicji.';

  @override
  String get inventorySectionTools => 'Narzędzia';

  @override
  String get inventorySectionWeapons => 'Broń';

  @override
  String get inventorySectionAmmo => 'Amunicja';

  @override
  String get inventoryWeaponFallbackName => 'Broń';

  @override
  String get inventoryAmmoFallbackName => 'Amunicja';

  @override
  String inventoryWeaponSubtitle(String condition, String qty) {
    return 'Warunek: $condition% • Ilość: $qty';
  }

  @override
  String inventoryAmmoQuantity(String qty) {
    return 'Ilość: $qty';
  }

  @override
  String inventoryQuantityValue(int qty) {
    return 'Ilość: $qty';
  }

  @override
  String inventoryWithdrawDialogTitle(String itemName) {
    return 'Wycofaj z magazynu: $itemName';
  }

  @override
  String inventoryMaxShort(int max) {
    return 'Maks.: $max';
  }

  @override
  String get inventoryInvalidQuantity => 'Nieprawidłowa ilość';

  @override
  String get inventorySnackWeaponStored => 'Broń przechowywana';

  @override
  String get inventorySnackWeaponWithdrawn => 'Broń wycofana';

  @override
  String get inventorySnackCashStored => 'Gotówka wpłacona';

  @override
  String get inventorySnackCashWithdrawn => 'Wycofano gotówkę';

  @override
  String get inventorySnackDrugsWithdrawn => 'Leki wycofane';

  @override
  String get inventoryActionFailed => 'Akcja nie powiodła się';

  @override
  String get inventoryStorageNoCategory => 'Brak typu przechowywania';

  @override
  String get inventoryCountsWeapons => 'Broń';

  @override
  String get inventoryCountsDrugs => 'Narkotyki';

  @override
  String get inventoryCountsCash => 'Gotówka';

  @override
  String inventoryStorageCountsLine(
    String weapons,
    int weaponCount,
    String drugs,
    int drugCount,
    String cash,
    int cashAmount,
  ) {
    return '$weapons: $weaponCount • $drugs: $drugCount • $cash: $cashAmount €';
  }

  @override
  String get inventoryStorageWrongCountry =>
      'Jesteś w innym kraju. Tutaj nie możesz uzyskać dostępu do tego magazynu.';

  @override
  String get inventoryWeaponStorageTitle => 'Przechowywanie broni';

  @override
  String get inventoryStoreWeapons => 'Sklep';

  @override
  String get inventoryInStorage => 'W magazynie';

  @override
  String get inventoryUnknownWeapon => 'Nieznana broń';

  @override
  String get inventoryTakeOne => 'Weź 1';

  @override
  String get inventoryNoWeaponsInStorage => 'W tym magazynie nie ma broni.';

  @override
  String get inventoryCashStorageTitle => 'Przechowywanie gotówki';

  @override
  String get inventoryDepositCash => 'Wpłać gotówkę';

  @override
  String get inventoryWithdrawCash => 'Wypłacić gotówkę';

  @override
  String get inventoryDrugStorageTitle => 'Przechowywanie leków';

  @override
  String get inventoryNoDrugsInStorage => 'Brak leków w magazynie.';

  @override
  String get inventoryNotForTools =>
      'Ta właściwość nie jest przeznaczona do przechowywania narzędzi. Wykorzystaj magazyn na narzędzia.';

  @override
  String get inventoryCategoryTools => 'Narzędzia';

  @override
  String get inventoryCategoryDrugs => 'Narkotyki';

  @override
  String get inventoryCategoryWeapons => 'Broń';

  @override
  String get inventoryCategoryCash => 'Gotówka';

  @override
  String inventoryStorageSlotsDetail(int used, int max, String percent) {
    return '$used/$max slotów ($percent%)';
  }

  @override
  String get inventoryStorageAccessibleHere => 'Dostępne w bieżącym kraju';

  @override
  String get inventoryStorageNotAccessibleHere => 'Niedostępne w tym kraju';

  @override
  String get loadoutEquipFailed => 'Nie udało się wyposażyć wyposażenia';

  @override
  String get loadoutDeleteFailed => 'Nie udało się usunąć wyposażenia';

  @override
  String transferSuccess(String tool, String location) {
    return '✅ $tool przeniesiono do $location';
  }

  @override
  String get carried => 'Przewieziony';

  @override
  String get storage => 'Składowanie';

  @override
  String get property => 'Nieruchomość';

  @override
  String inventorySlots(int used, int max) {
    return '$used / $max slotów';
  }

  @override
  String get loadouts => 'Ładunki';

  @override
  String get createLoadout => 'Utwórz zestaw';

  @override
  String get equipLoadout => 'Wyposażyć';

  @override
  String get loadoutEquipped => '✅ Wyposażenie wyposażone';

  @override
  String get loadoutMaxReached => '❌ Osiągnięto maksymalne obciążenie (5)';

  @override
  String loadoutMissingTools(String tools) {
    return '❌ Brakujące narzędzia: $tools';
  }

  @override
  String get backpackUpgrade => 'Ulepszenie plecaka';

  @override
  String get backpackBasic => 'Podstawowy plecak (+5 miejsc)';

  @override
  String get backpackTactical => 'Kamizelka taktyczna (+10 miejsc)';

  @override
  String get backpackCargo => 'Spodnie cargo (+3 miejsca)';

  @override
  String get upgradeInventory => 'Uaktualnij ekwipunek';

  @override
  String get noToolsCarried => 'Żadnych narzędzi';

  @override
  String get visitShopToBuyTools => 'Odwiedź sklep, aby kupić narzędzia';

  @override
  String get noProperties => 'Brak właściwości';

  @override
  String get buyPropertyForStorage =>
      'Kup nieruchomość do przechowywania narzędzi';

  @override
  String get noToolsInStorage => 'Brak narzędzi w magazynie';

  @override
  String get selectProperty => 'Wybierz nieruchomość';

  @override
  String get slotsRemaining => 'pozostałe sloty';

  @override
  String get noLoadouts => 'Żadnych załadunków';

  @override
  String get createLoadoutToStart => 'Aby rozpocząć, utwórz zestaw wyposażenia';

  @override
  String get deleteLoadout => 'Usuń wyposażenie';

  @override
  String get confirmDeleteLoadout =>
      'Czy na pewno chcesz usunąć to wyposażenie?';

  @override
  String get loadoutDeleted => 'Ładunek usunięty';

  @override
  String get edit => 'Redagować';

  @override
  String get delete => 'Usuwać';

  @override
  String get active => 'Aktywny';

  @override
  String get durability => 'Trwałość';

  @override
  String get quantity => 'Ilość';

  @override
  String get slotSize => 'Rozmiar gniazda';

  @override
  String get repairCost => 'Koszt naprawy';

  @override
  String get wearPerUse => 'Nosić według użycia';

  @override
  String get loseChance => 'Szansa na stratę';

  @override
  String get requiredFor => 'Wymagane dla';

  @override
  String get lowDurability => 'Niska trwałość';

  @override
  String get transfer => 'Przenosić';

  @override
  String get toolDetails => 'Szczegóły narzędzia';

  @override
  String get transferTool => 'Narzędzie do przenoszenia';

  @override
  String get selectQuantity => 'Wybierz ilość';

  @override
  String get destination => 'Miejsce docelowe';

  @override
  String get from => 'Z';

  @override
  String get to => 'Do';

  @override
  String get editLoadout => 'Edytuj wyposażenie';

  @override
  String get loadoutName => 'Nazwa ładunku';

  @override
  String get description => 'Opis';

  @override
  String get optional => 'fakultatywny';

  @override
  String get selectedTools => 'Wybrane narzędzia';

  @override
  String get noToolsAvailable => 'Brak dostępnych narzędzi';

  @override
  String get create => 'Tworzyć';

  @override
  String get save => 'Ratować';

  @override
  String get pleaseEnterName => 'Proszę wpisać nazwę';

  @override
  String get pleaseSelectTools => 'Proszę wybrać co najmniej 1 narzędzie';

  @override
  String get loadoutCreated => 'Utworzono obciążenie';

  @override
  String get loadoutUpdated => 'Ładunek zaktualizowany';

  @override
  String get goToInventory => 'Przejdź do Zapasów';

  @override
  String get slots => 'szczeliny';

  @override
  String get backpackShop => 'Sklep z plecakami';

  @override
  String get yourBackpack => 'Twój plecak';

  @override
  String get availableUpgrades => 'Dostępne aktualizacje';

  @override
  String get otherBackpacks => 'Inne plecaki';

  @override
  String get youHaveBestBackpack => 'Masz najlepszy plecak!';

  @override
  String get backpackPurchased => 'Plecak zakupiony!';

  @override
  String get backpackUpgraded => 'Ulepszony plecak!';

  @override
  String get buyBackpack => 'Kupić';

  @override
  String get upgradeBackpack => 'Aktualizacja';

  @override
  String get backpackPrice => 'Cena';

  @override
  String get extraSlots => 'Dodatkowe sloty';

  @override
  String get totalSlots => 'Łączna liczba slotów';

  @override
  String get vipOnly => 'Tylko dla VIP-ów';

  @override
  String get tradeInValue => 'Wartość handlowa';

  @override
  String get upgradeCost => 'Koszt aktualizacji';

  @override
  String rankRequired(Object rank) {
    return 'Wymagana ranga $rank';
  }

  @override
  String insufficientFunds(String needed, String have) {
    return 'Potrzebujesz €$needed. Masz $have €';
  }

  @override
  String get alreadyHasBackpack => 'Masz już plecak';

  @override
  String get backpackNotFound => 'Nie znaleziono plecaka';

  @override
  String get playerNotFound => 'Nie znaleziono gracza';

  @override
  String get notAnUpgrade => 'To nie jest aktualizacja';

  @override
  String backpackPurchasedEvent(Object name, Object slots) {
    return 'Kupiłeś $name! +$slots slotów.';
  }

  @override
  String backpackUpgradedEvent(Object newName, Object upgradeSlots) {
    return 'Uaktualniono do $newName! +$upgradeSlots dodatkowe miejsca.';
  }

  @override
  String get backpackPurchaseFailedNotFound => 'Nie znaleziono plecaka';

  @override
  String get backpackPurchaseFailedAlready =>
      'Masz już plecak. Można używać tylko jednego na raz.';

  @override
  String backpackPurchaseFailedRank(Object current, Object required) {
    return 'Potrzebujesz rangi $required (masz rangę $current)';
  }

  @override
  String backpackPurchaseFailedFunds(Object have, Object needed) {
    return 'Potrzebujesz €$needed. Masz $have €';
  }

  @override
  String get backpackPurchaseFailedVip =>
      'Ten plecak jest przeznaczony wyłącznie dla członków VIP';

  @override
  String get backpackUpgradeFailedNo => 'Nie masz plecaka do ulepszenia';

  @override
  String get backpackUpgradeFailedNotUpgrade =>
      'To nie jest aktualizacja. Wybierz większy plecak.';

  @override
  String backpackUpgradeFailedRank(Object current, Object required) {
    return 'Potrzebujesz rangi $required (masz rangę $current)';
  }

  @override
  String backpackUpgradeFailedFunds(Object have, Object needed) {
    return 'Potrzebujesz €$needed. Masz $have €';
  }

  @override
  String get backpackUpgradeFailedVip =>
      'Ten plecak jest przeznaczony wyłącznie dla członków VIP';

  @override
  String get backpackPurchaseFailedGeneric => 'Nie można sfinalizować zakupu.';

  @override
  String get backpackUpgradeFailedGeneric => 'Nie można ukończyć aktualizacji.';

  @override
  String get backpackUnknownEvent => 'Nieznana akcja';

  @override
  String get backpackLoadFailedGeneric => 'Coś poszło nie tak';

  @override
  String get backpackOwnedBadge => 'Posiadany';

  @override
  String get availableBackpacks => 'Dostępne plecaki';

  @override
  String backpackDialogCurrentLine(String name, int slots) {
    return 'Aktualnie: $name (+$slots miejsc)';
  }

  @override
  String backpackDialogNewLine(String name, int slots) {
    return 'Nowość: $name (+$slots miejsc)';
  }

  @override
  String backpackDialogUpgradeDelta(int delta) {
    return 'Ulepszenie: +$delta miejsc';
  }

  @override
  String backpackDialogTotalCapacity(int totalSlots) {
    return 'Razem: $totalSlots miejsc';
  }

  @override
  String get notLoggedInTokenStorageHint =>
      '(problem z pamięcią — spróbuj zalogować się ponownie)';

  @override
  String get blackMarketTabBackpacks => 'Plecaki';

  @override
  String get bmHubAdjustFiltersHint => 'Spróbuj dostosować filtry';

  @override
  String get bmHubEmptyMyListingsHint =>
      'Pojazdy przez garaż/przystań, lub narzędzia przy sobie przez Sprzedaj przedmiot';

  @override
  String get bmHubSellerLabel => 'Sprzedający';

  @override
  String get bmHubAskingPriceLabel => 'Cena wywoławcza';

  @override
  String get bmHubMarketValueShort => 'Wartość rynkowa';

  @override
  String get bmHubBuyNow => 'Kup teraz';

  @override
  String get bmHubListedFor => 'Wystawione dla';

  @override
  String get bmHubEditPrice => 'Edytuj cenę';

  @override
  String get bmHubDelist => 'Usuń';

  @override
  String get bmHubFilterListingsTitle => 'Filtruj oferty';

  @override
  String get bmHubLabelCountry => 'Kraj';

  @override
  String get bmHubAllCountries => 'Wszystkie kraje';

  @override
  String get bmHubLabelVehicleType => 'Typ pojazdu';

  @override
  String get bmHubAllTypes => 'Wszystkie typy';

  @override
  String get bmHubCars => 'Samochody';

  @override
  String get bmHubBoats => 'Łodzie';

  @override
  String get bmHubPriceRange => 'Przedział cenowy';

  @override
  String get bmHubClearFilters => 'Wyczyść filtry';

  @override
  String get bmHubApply => 'Stosować';

  @override
  String get bmHubBuyVehicleTitle => 'Kup pojazd';

  @override
  String bmHubBuyVehicleForConfirm(String name, String price) {
    return 'Kupić $name za $price?';
  }

  @override
  String get bmHubVehiclePurchased => 'Pojazd zakupiony pomyślnie!';

  @override
  String get bmHubVehiclePurchaseFailed => 'Nie udało się kupić pojazdu';

  @override
  String get bmHubNewPriceEuro => 'Nowa cena (€)';

  @override
  String get bmHubEnterNewPriceHint => 'Wprowadź nową cenę';

  @override
  String get bmHubCurrentPrice => 'Aktualna cena';

  @override
  String get bmHubPriceUpdated => 'Cena została pomyślnie zaktualizowana!';

  @override
  String get bmHubPriceUpdateFailed => 'Nie udało się zaktualizować ceny';

  @override
  String get bmHubUpdateButton => 'Aktualizacja';

  @override
  String get bmHubDelistVehicleTitle => 'Usuń pojazd z listy';

  @override
  String bmHubRemoveFromMarketConfirm(String name) {
    return 'Usunąć $name z rynku?';
  }

  @override
  String get bmHubVehicleDelisted => 'Pojazd został usunięty z listy!';

  @override
  String get bmHubDelistFailed => 'Nie udało się usunąć pojazdu z listy';

  @override
  String get bmHubLocationUnknown => 'NIEZNANY';

  @override
  String get bmHubNoMarketListingsTitle => 'Brak ogłoszeń';

  @override
  String get bmHubNoMarketListingsBody =>
      'Nic nie pasuje do filtrów. Możesz wystawić narzędzia przy sobie przez Sprzedaj przedmiot.';

  @override
  String get bmHubSellKindTool => 'Tool';

  @override
  String get bmHubSellKindDrug => 'Drugs';

  @override
  String get bmHubSellKindCrypto => 'Crypto';

  @override
  String get bmHubSellKindTrade => 'Trade goods';

  @override
  String get bmHubQuantityEvent => 'Quantity';

  @override
  String get bmHubListEventItemTitle => 'Sell event item';

  @override
  String get bmHubNoEventItemsToSell => 'No event items to sell';

  @override
  String get bmHubSellKindEvent => 'Event items';

  @override
  String get bmHubNoDrugsToSell => 'No drugs to sell';

  @override
  String get bmHubNoCryptoToSell => 'No crypto to sell';

  @override
  String get bmHubNoTradeGoodsToSell => 'No trade goods to sell';

  @override
  String get bmHubListDrugTitle => 'List drugs';

  @override
  String get bmHubListDrugSelectLabel => 'Drug stack';

  @override
  String get bmHubListCryptoTitle => 'List crypto';

  @override
  String get bmHubListCryptoSelectLabel => 'Asset';

  @override
  String get bmHubListTradeTitle => 'List trade goods';

  @override
  String get bmHubListTradeSelectLabel => 'Good';

  @override
  String get bmHubQuantityGrams => 'Quantity (g)';

  @override
  String get bmHubQuantityCrypto => 'Quantity';

  @override
  String get bmHubQuantityUnits => 'Quantity';

  @override
  String get bmHubSellCarriedItem => 'Sprzedaj przedmiot';

  @override
  String bmHubToolQtyDurability(int qty, int pct) {
    return 'Szt. $qty • $pct% stan';
  }

  @override
  String bmHubToolBaseValue(int price) {
    return 'Orientacja €$price';
  }

  @override
  String get bmHubBuyToolTitle => 'Kup przedmiot';

  @override
  String bmHubBuyToolConfirm(String name, String price) {
    return 'Kupić $name za $price?';
  }

  @override
  String get bmHubToolPurchased => 'Przedmiot kupiony';

  @override
  String get bmHubToolPurchaseFailed => 'Nie udało się kupić';

  @override
  String get bmHubDelistToolTitle => 'Usuń ogłoszenie';

  @override
  String bmHubDelistToolConfirm(String name) {
    return 'Usunąć $name z rynku?';
  }

  @override
  String get bmHubToolDelisted => 'Ogłoszenie usunięte';

  @override
  String get bmHubListToolTitle => 'Wystaw przedmiot na rynek';

  @override
  String get bmHubListToolSelectLabel => 'Przedmiot przy sobie';

  @override
  String get bmHubListToolSubmit => 'Wystaw';

  @override
  String get bmHubToolListedMessage => 'Przedmiot wystawiony';

  @override
  String get bmHubListToolFailed => 'Nie udało się wystawić';

  @override
  String get bmHubLoadCarriedToolsFailed => 'Nie udało się wczytać ekwipunku';

  @override
  String get bmHubNoCarriedToolsToSell =>
      'Brak przedmiotów (lub już wystawione)';

  @override
  String get bmHubInvalidToolPrice => 'Podaj poprawną cenę';

  @override
  String get arrested => 'Aresztowany!';

  @override
  String get jailMessage =>
      'Zostałeś aresztowany podczas podróży i skonfiskowano cały towar!';

  @override
  String get confirmAction => 'Czy jesteś pewien?';

  @override
  String get ok => 'OK';

  @override
  String get travelContinueConfirmTitle => 'Przejść do następnego etapu?';

  @override
  String get travelContinueConfirmBody =>
      'Kontrole graniczne są aktywne. Kontynuować podróż?';

  @override
  String get travelJourneyCompleteTitle => 'Podróż zakończona';

  @override
  String get travelJourneyCompleteBody => 'Dotarłeś bezpiecznie do celu.';

  @override
  String get hitlist => 'Lista hitów';

  @override
  String hitlistLoadError(String error) {
    return 'Błąd podczas ładowania listy trafień: $error';
  }

  @override
  String get noActiveHits => 'Brak aktywnych trafień';

  @override
  String get selectTarget => 'Wybierz Cel';

  @override
  String get searchPlayer => 'Wyszukaj gracza...';

  @override
  String get placeHitTitle => 'Umieść trafienie';

  @override
  String get minimumBounty => 'Minimalna nagroda: 50 000 euro';

  @override
  String get bountyAmount => 'Wysokość nagrody';

  @override
  String get place => 'Miejsce';

  @override
  String hitPlaced(String amount) {
    return 'Trafienie za $amount €';
  }

  @override
  String hitError(String error) {
    return 'Błąd: $error';
  }

  @override
  String get hitDifferentCountry =>
      'Musisz znajdować się w tym samym kraju co cel';

  @override
  String get hitlistErrMissingBounty => 'Wymagana jest kwota nagrody';

  @override
  String get hitlistErrBountyTooLow => 'Minimalna nagroda wynosi 50 000 euro';

  @override
  String get hitlistErrCannotHitYourself => 'Nie możesz zadać sobie ciosu';

  @override
  String get hitlistErrHitAlreadyExists =>
      'Masz już aktywne trafienie na tego gracza';

  @override
  String get hitlistErrInsufficientMoney => 'Nie masz dość pieniędzy';

  @override
  String get hitlistErrMissingCounterBounty =>
      'Wymagana jest kwota przeciwnej nagrody';

  @override
  String get hitlistErrHitNotFound => 'Nie znaleziono trafienia';

  @override
  String get hitlistErrNotTarget => 'Tylko cel może złożyć kontrofertę';

  @override
  String get hitlistErrHitNotActive => 'Hit nie jest aktywny';

  @override
  String get hitlistErrCounterBountyMustBeHigher =>
      'Nagroda za kontr-nagrodę musi być wyższa niż pierwotna nagroda';

  @override
  String get hitlistErrMissingWeapon => 'Wymagana jest broń';

  @override
  String get hitlistErrWeaponNotFound => 'Nie znaleziono broni';

  @override
  String get hitlistErrWeaponNotOwned =>
      'Nie jesteś właścicielem tej broni lub jest ona uszkodzona';

  @override
  String get hitlistErrWeaponBroken =>
      'Wybrana przez Ciebie broń jest uszkodzona. Najpierw to napraw.';

  @override
  String get hitlistErrInsufficientAmmo =>
      'Nie masz wystarczającej ilości amunicji';

  @override
  String get hitlistErrInvalidAmmoHit => 'Nieprawidłowa ilość amunicji';

  @override
  String get hitlistErrTargetUnderHitProtection =>
      'Cel ma aktywną ochronę przed trafieniem';

  @override
  String get hitlistErrInvalidInvestigationTier =>
      'Nieprawidłowy typ dochodzenia';

  @override
  String get hitlistErrInvestigationAlreadyPending =>
      'W sprawie tego trafienia toczy się już śledztwo. Poczekaj na wiadomość detektywistyczną.';

  @override
  String get hitlistErrInvalidCaseId => 'Nieprawidłowy numer akt sprawy';

  @override
  String get hitlistErrMurderCaseNotFound => 'Nie znaleziono akt sprawy';

  @override
  String get hitlistErrMurderCaseExpired =>
      'Upłynął okres dochodzenia (24 godziny)';

  @override
  String get hitlistErrMurderCaseAlreadyRequested =>
      'Dochodzenie w tej sprawie zostało już rozpoczęte';

  @override
  String get hitlistErrNotPlacer =>
      'Tylko umieszczający może anulować trafienie';

  @override
  String get hitlistInvestigationOptions => 'Opcje dochodzenia';

  @override
  String get hitlistInvestigationChooseSpeedPrice => 'Wybierz prędkość i cenę:';

  @override
  String get hitlistInvestigationQuick =>
      'Szybkie dochodzenie (1 000 000 EUR • 1 godzina)';

  @override
  String get hitlistInvestigationStandard =>
      'Dochodzenie standardowe (500 000 euro • 6 godzin)';

  @override
  String get hitlistInvestigationSlow =>
      'Powolne dochodzenie (250 000 euro • 24 godziny)';

  @override
  String hitlistInvestigationQueued(
    String cost,
    String etaMinutes,
    String resolveAt,
  ) {
    return 'Śledztwo w kolejce. Koszt $cost. ETA: $etaMinutes min. Raport zostanie przesłany za pośrednictwem wiadomości z Biura Detektywistycznego (około ⟦ 2⟧).';
  }

  @override
  String get hitlistInvestigationFailedGeneric =>
      'Dochodzenie nie powiodło się';

  @override
  String get hitlistInvestigationCouldNotComplete =>
      'Dochodzenie nie mogło zostać ukończone';

  @override
  String hitlistHitSuccessWithLoot(String cash, String items) {
    return 'Hit udany! Otrzymane nagrody i łupy: gotówka $cash, przenoszone przedmioty $items.';
  }

  @override
  String get hitlistAttemptTimeout =>
      'Upłynął limit czasu próby trafienia. Spróbuj ponownie.';

  @override
  String get hitlistNoUsableWeapons =>
      'Nie masz w ekwipunku żadnej użytecznej broni. Najpierw kup lub napraw broń.';

  @override
  String hitlistWeaponsInventoryLoadError(String error) {
    return 'Błąd ładowania broni: $error';
  }

  @override
  String hitlistPlayersLoadError(String error) {
    return 'Błąd ładowania graczy: $error';
  }

  @override
  String get hitlistRelativeOneDayAgo => '1 dzień temu';

  @override
  String hitlistRelativeDaysAgo(String count) {
    return '$count dni temu';
  }

  @override
  String get counterBountyTitle => 'Umieść kontr-nagrodę';

  @override
  String minimumAmount(String amount) {
    return 'Minimalna kwota: €$amount';
  }

  @override
  String get counterBountyAmount => 'Kwota kontr-nagrody';

  @override
  String counterBountyPlaced(String amount) {
    return 'Umieszczona przeciwnagroda w wysokości $amount €';
  }

  @override
  String get cancelHitConfirmTitle => 'Anulować trafienie?';

  @override
  String get cancelHitConfirmBody => 'Twoja nagroda zostanie zwrócona.';

  @override
  String get hitCancelled => 'Hit anulowany';

  @override
  String get target => 'Cel';

  @override
  String get placer => 'Pakowacz';

  @override
  String get bounty => 'Hojność';

  @override
  String get counterBid => 'KONTR-LICYTACJA';

  @override
  String get counterBidPlaced =>
      'Kontroferta złożona! Umowa została odwrócona.';

  @override
  String get attemptHit => 'Próba trafienia';

  @override
  String get selectWeapon => 'Wybierz Broń i amunicja';

  @override
  String get youAreTargeted => 'Jesteś na liście przebojów';

  @override
  String get security => 'Bezpieczeństwo';

  @override
  String get currentDefense => 'Aktualna obrona';

  @override
  String get totalDefense => 'Całkowita obrona';

  @override
  String get currentArmor => 'Obecna zbroja';

  @override
  String get bodyguards => 'Ochroniarze';

  @override
  String get buyBodyguards => 'Kup Ochroniarze';

  @override
  String get bodyguardPrice => 'Cena za ochroniarza';

  @override
  String get armor => 'Zbroja';

  @override
  String get protectorsFollow => 'Obrońcy, którzy podążają za tobą';

  @override
  String get eachGivesDefense => 'Każdy daje +10 obrony';

  @override
  String get lightArmor => 'Lekka zbroja';

  @override
  String get basicProtection => 'Podstawowa ochrona';

  @override
  String get heavyArmor => 'Ciężka zbroja';

  @override
  String get strongProtection => 'Silna ochrona';

  @override
  String get bulletproofVest => 'Kamizelka kuloodporna';

  @override
  String get veryStrongProtection => 'Bardzo silna ochrona';

  @override
  String get tacticalSuit => 'Strój taktyczny';

  @override
  String get premiumProtection => 'Ochrona premium';

  @override
  String get defense => 'Obrona';

  @override
  String defenseIncrease(String armor, String defense) {
    return 'Kupiłeś $armor! +$defense obrona';
  }

  @override
  String get worn => 'Noszony';

  @override
  String get replaceArmor => 'Zastępować';

  @override
  String get bodyguardProductName => 'Goryl';

  @override
  String securityLoadError(String error) {
    return 'Błąd podczas ładowania zabezpieczeń: $error';
  }

  @override
  String get securityStatusLoadFailed =>
      'Nie można wczytać stanu zabezpieczeń.';

  @override
  String armorConditionLine(String percent, String base) {
    return 'Warunek $percent% · podstawa $base';
  }

  @override
  String dailyWageAmount(String amount) {
    return 'Dzienna stawka $amount';
  }

  @override
  String dailySystemCostLine(String amount) {
    return 'Dzienny koszt systemu: $amount';
  }

  @override
  String nextPayrollAt(String datetime) {
    return 'Następna lista płac: $datetime';
  }

  @override
  String get bodyguardsLeaveIfUnpaid =>
      'Jeśli nie możesz zapłacić dziennej pensji, wszyscy ochroniarze odchodzą.';

  @override
  String get armorOneAtATimeHint =>
      'Możesz nosić tylko 1 zbroję na raz. Nowa zbroja zawsze zastępuje obecną.';

  @override
  String armorDefenseNowAtCondition(String defense, String percent) {
    return 'Teraz +$defense przy $percent%';
  }

  @override
  String get couldNotBuyBodyguard => 'Nie udało się kupić ochroniarza';

  @override
  String get couldNotBuyArmor => 'Nie można było kupić zbroi';

  @override
  String get armorAlreadyEquippedLong =>
      'Już nosisz tę zbroję. Możesz nosić tylko 1 zbroję na raz.';

  @override
  String get securityErrorArmorNotFound => 'Nie znaleziono zbroi';

  @override
  String get securityErrorMinQuantity => 'Ilość musi wynosić co najmniej 1';

  @override
  String get hit => 'UDERZYĆ';

  @override
  String get counterBidLabel => 'KONTR-LICYTACJA';

  @override
  String daysAgo(String count, String plural) {
    return '$count dzień$plural temu';
  }

  @override
  String get justPlaced => 'Właśnie umieszczone';

  @override
  String get youAreTheTarget => 'Jesteś celem';

  @override
  String get youAreThePlacer => 'Jesteś umieszczaczem';

  @override
  String get onlyTargetCanCounterBid => 'Tylko cel może złożyć kontrofertę';

  @override
  String get executeHit => 'Wykonaj uderzenie';

  @override
  String get moneyNotEnough => 'Nie masz dość pieniędzy';

  @override
  String get securityScreen => 'Bezpieczeństwo';

  @override
  String get currentDefenseStatus => 'Obecny stan obrony';

  @override
  String get noWeapons => 'Nie masz broni w swoim ekwipunku';

  @override
  String get ammoQuantity => 'Ilość amunicji';

  @override
  String get noAmmoRequired => 'Do tej broni nie jest wymagana amunicja';

  @override
  String get weaponStats => 'Statystyki broni';

  @override
  String get damage => 'Szkoda';

  @override
  String get intimidation => 'Zastraszenie';

  @override
  String get execute => 'Wykonać';

  @override
  String get hitExecuted => 'Trafienie wykonane pomyślnie!';

  @override
  String get invalidAmmo => 'Proszę podać prawidłową ilość amunicji';

  @override
  String get weaponsMarket => 'Rynek broni';

  @override
  String get ammoMarket => 'Rynek amunicji';

  @override
  String get shootingRange => 'Strzelnica';

  @override
  String get ammoFactory => 'Fabryka Amunicji';

  @override
  String get weaponShop => 'Sklep z bronią';

  @override
  String get myWeapons => 'Moja broń';

  @override
  String get weaponPurchased => 'Broń zakupiona';

  @override
  String weaponRankRequired(String rank) {
    return 'Wymagana ranga: $rank';
  }

  @override
  String get buyWeapon => 'Kupić';

  @override
  String get ammoShop => 'Rynek amunicji';

  @override
  String get myAmmo => 'Moja amunicja';

  @override
  String get ammoPurchased => 'Amunicja zakupiona';

  @override
  String get purchaseCooldown => 'Trzeba poczekać do następnego zakupu';

  @override
  String get insufficientStock => 'Za mało dostępnych zapasów';

  @override
  String get maxInventoryReached => 'Osiągnięto maksymalną pojemność magazynu';

  @override
  String get invalidQuantity => 'Nieprawidłowa ilość';

  @override
  String get nextAmmoPurchase => 'Następny zakup dostępny w';

  @override
  String get ammoBoxes => 'Pudełka';

  @override
  String ammoRoundsPerBox(String rounds) {
    return '$rounds nabojów w pudełku';
  }

  @override
  String ammoYouWillReceive(String rounds) {
    return 'Otrzymasz: $rounds rund';
  }

  @override
  String ammoTotalCost(String cost) {
    return 'Całkowity koszt: $cost €';
  }

  @override
  String get ammoRounds => 'rundy';

  @override
  String get ammoGeneric => 'Amunicja';

  @override
  String get ammoPerCrimeSuffix => 'za przestępstwo';

  @override
  String get ammoBoxesUnit => 'pudełka';

  @override
  String get ammoStock => 'Magazyn';

  @override
  String get ammoQuality => 'Jakość';

  @override
  String get factoryBought => 'Kupiony fabrycznie';

  @override
  String get factoryProduced => 'Produkcja zaktualizowana';

  @override
  String get factorySessionStarted =>
      'Rozpoczęto produkcję: aktywna przez 8 godzin, odbiór co 20 minut';

  @override
  String get ammoFactoryTitle => 'Fabryka Amunicji';

  @override
  String get ammoFactoryIntro =>
      'Produkuje partiami; odbierasz co 20 minut (do 8 godzin zaległości na sesję).';

  @override
  String get ammoFactoryWhatYouCanDo => 'Co możesz zrobić:';

  @override
  String get ammoFactoryActionBuy => 'Kup fabrykę w swoim obecnym kraju';

  @override
  String get ammoFactoryActionProduce =>
      'Produkcja roszczeń (interwał: 20 minut, maksymalne zaległości: 8 godzin na sesję)';

  @override
  String get ammoFactoryActionOutput =>
      'Ulepsz wyjście do poziomu 5, aby uzyskać więcej rund na roszczenie';

  @override
  String get ammoFactoryActionQuality =>
      'Ulepsz jakość, aby uzyskać wyższe ceny rynkowe';

  @override
  String get ammoFactoryBlackMarketTitle => 'Sprzedam amunicję';

  @override
  String get ammoFactoryBlackMarketBody =>
      'Fabryka amunicji nie sprzedaje naboi bezpośrednio z tego ekranu. Korzystaj z Czarnego Rynku, aby kupować i sprzedawać amunicję.';

  @override
  String get ammoFactoryActionBlackMarket =>
      'Kupuj i sprzedawaj amunicję na Czarnym Rynku, a nie bezpośrednio z fabryki.';

  @override
  String get ammoFactoryErrCountryRequired => 'Kraj jest wymagany';

  @override
  String get ammoFactoryErrPlayerNotFound => 'Nie znaleziono gracza';

  @override
  String get ammoFactoryErrWrongCountry =>
      'Aby kupić tę fabrykę, musisz znajdować się w tym samym kraju';

  @override
  String get ammoFactoryErrCouldNotPurchase => 'Nie udało się kupić fabryki';

  @override
  String get ammoFactoryErrAlreadyOwned => 'Fabryka jest już własnością';

  @override
  String get ammoFactoryErrInsufficientMoneyBuy =>
      'Za mało pieniędzy na zakup fabryki';

  @override
  String get ammoFactoryErrCouldNotProduce =>
      'Nie udało się wyprodukować amunicji';

  @override
  String get ammoFactoryErrNotOwned => 'Nie jesteś właścicielem fabryki';

  @override
  String get ammoFactoryErrOnCooldown => 'Fabryka jest w fazie odnowienia';

  @override
  String get ammoFactoryErrInactive =>
      'Własność fabryki utracona z powodu bezczynności';

  @override
  String get ammoFactoryErrCouldNotUpgrade => 'Nie można uaktualnić fabryki';

  @override
  String get ammoFactoryErrInsufficientMoneyUpgrade =>
      'Za mało pieniędzy na modernizację fabryki';

  @override
  String get ammoFactoryErrMaxLevel =>
      'Fabryka jest już na maksymalnym poziomie';

  @override
  String get ammoFactoryErrInvalidUpgradeType =>
      'Typ uaktualnienia musi być wyjściowy lub jakościowy';

  @override
  String get ammoFactoryErrEducationNotMet =>
      'Niespełnione wymagania edukacyjne';

  @override
  String get factoryUpgradeOutputSuccess => 'Wyjście ulepszone';

  @override
  String get factoryUpgradeQualitySuccess => 'Jakość poprawiona';

  @override
  String get myFactory => 'Moja fabryka';

  @override
  String get noFactoryOwned => 'Nie jesteś właścicielem fabryki';

  @override
  String get factoryCountry => 'Kraj';

  @override
  String get factoryOutputLevel => 'Poziom wyjściowy';

  @override
  String get factoryQualityLevel => 'Poziom jakości';

  @override
  String get factoryLastProduced => 'Ostatnio wyprodukowany';

  @override
  String get factoryProduceStatusLabel => 'Stan produkcji';

  @override
  String get factoryProduceStatusReady => 'Gotowy';

  @override
  String get factoryProduceStatusCooldown => 'Czas odnowienia';

  @override
  String get factorySessionActive =>
      'Okno produkcyjne: aktywne (przerwa 20 min)';

  @override
  String get factorySessionStopped =>
      'Okno produkcyjne: zatrzymane (kliknij przycisk Produkuj, aby rozpocząć nowe 8-godzinne okno)';

  @override
  String factorySessionEndsIn(String duration) {
    return 'Okno kończy się za: $duration';
  }

  @override
  String get factoryNextProductionReady =>
      'Następna produkcja: dostępna już teraz (naciśnij przycisk Produkuj, aby odebrać)';

  @override
  String factoryNextProductionIn(String duration) {
    return 'Następna produkcja za: $duration';
  }

  @override
  String get factoryProduce => 'Wytwarzać';

  @override
  String get factoryUpgradeOutput => 'Uaktualnij wyjście';

  @override
  String get factoryUpgradeQuality => 'Ulepsz jakość';

  @override
  String get factoryList => 'Fabryki według kraju';

  @override
  String get factoryUnowned => 'Dostępny';

  @override
  String factoryOwnedBy(String owner) {
    return 'Właściciel: $owner';
  }

  @override
  String get factoryBuy => 'Kupić';

  @override
  String get shootingIntro =>
      'Popraw swoją dokładność i zwiększ skuteczność przestępstw';

  @override
  String get shootingTrainSuccess => 'Szkolenie zakończone';

  @override
  String get shootingMaxSessionsReached =>
      'Osiągnięto maksymalną liczbę sesji szkoleniowych';

  @override
  String get shootingTrainingProgressTitle => 'Postęp szkoleniowy';

  @override
  String get shootingSessionsCompletedLabel => 'Ukończone sesje:';

  @override
  String get shootingProgressCompleteSuffix => 'kompletny';

  @override
  String get shootingCurrentBonusTitle => 'Aktualny bonus';

  @override
  String get shootingAccuracyBonusLabel => 'Premia za dokładność';

  @override
  String get shootingMaximumLabel => 'Maksymalny';

  @override
  String get shootingBonusAppliedToCrimes =>
      'Bonus ten jest stosowany do wszystkich prób popełnienia przestępstwa';

  @override
  String get shootingReadyToTrain => 'Gotowy do treningu';

  @override
  String get shootingTrainingCooldownTitle => 'Czas odnowienia treningu';

  @override
  String shootingCooldownLabel(String time) {
    return 'Następna sesja o: $time';
  }

  @override
  String get shootingCooldownHint =>
      'Pomiędzy sesjami treningowymi należy odczekać 1 godzinę';

  @override
  String get shootingTrainingInProgress => 'Szkolenie...';

  @override
  String get shootingHowItWorksTitle => 'Jak to działa?';

  @override
  String get shootingHowItWorksBullet1 =>
      '• Trenuj co godzinę, aby zwiększyć dokładność';

  @override
  String get shootingHowItWorksBullet2 => '• Każda sesja daje premię +0,1%.';

  @override
  String get shootingHowItWorksBullet3 =>
      '• Maksymalnie 100 sesji (łącznie +10%)';

  @override
  String get shootingHowItWorksBullet4 =>
      '• Zwiększa wskaźnik powodzenia przestępstwa';

  @override
  String get shootingHowItWorksBullet5 =>
      '• Stały bonus, liczy się każda sesja';

  @override
  String shootingSessions(String count) {
    return 'Sesje: $count/100';
  }

  @override
  String shootingAccuracyBonus(String bonus) {
    return 'Premia do celności: $bonus%';
  }

  @override
  String shootingCooldown(String time) {
    return 'Następna sesja o $time';
  }

  @override
  String get shootingTrain => 'Trenuj';

  @override
  String get trainingHubMenuLabel => 'Szkolenie';

  @override
  String get trainingHubTitle => 'Centrum szkoleniowe';

  @override
  String get trainingHubSubtitle =>
      'Buduj siłę na siłowni i dokładność na strzelnicy. Każda ścieżka składa się z maksymalnie 100 sesji z 1-godzinnym czasem odnowienia i zwiększa szansę na powodzenie przestępstwa.';

  @override
  String get trainingHubSectionGym => 'Sala gimnastyczna';

  @override
  String get trainingHubSectionShooting => 'Strzelnica';

  @override
  String get trainingHubRefreshStatus => 'Odświeżać';

  @override
  String get trainingHubRefreshTooltip => 'Załaduj ponownie status z serwera';

  @override
  String get trainingHubOpenCrimes => 'Otwarte zbrodnie';

  @override
  String get trainingHubOpenCrimesHint =>
      'Aktywne bonusy pojawiają się na ekranie Zbrodni.';

  @override
  String get trainingHubMoreInfoTitle => 'Więcej informacji i opcji';

  @override
  String get trainingHubMoreInfoCombo =>
      'Ten sam dzień kalendarzowy UTC: ukończ co najmniej jedną sesję na siłowni i jedną sesję na strzelnicy, aby uzyskać niewielką dodatkową premię za sukces w przestępstwie (+0,5%).';

  @override
  String get trainingHubMoreInfoSeparate =>
      'Siłownia i strzelnica mają własny 1-godzinny czas odnowienia i limit 100 sesji.';

  @override
  String get trainingHubMoreInfoHitlist =>
      'Postęp strzelnicy zasila również obliczenia listy trafień na serwerze.';

  @override
  String trainingHubComboChip(String pct) {
    return 'Kombinacja aktywna: +$pct% do przestępstw';
  }

  @override
  String get gym => 'Sala gimnastyczna';

  @override
  String get gymIntro =>
      'Trenuj swoją siłę i zwiększ wskaźnik skuteczności przestępstw';

  @override
  String get gymTrainSuccess => 'Szkolenie zakończone';

  @override
  String get gymMaxSessionsReached => 'Osiągnięto maksymalną liczbę sesji';

  @override
  String get gymTrainingProgressTitle => 'Postęp szkoleniowy';

  @override
  String get gymSessionsCompletedLabel => 'Ukończone sesje:';

  @override
  String get gymProgressCompleteSuffix => 'kompletny';

  @override
  String get gymCurrentBonusTitle => 'Aktualny bonus';

  @override
  String gymSessions(String count) {
    return 'Sesje: $count/100';
  }

  @override
  String get gymStrengthBonusLabel => 'Bonus za siłę';

  @override
  String get gymMaximumLabel => 'Maksymalny';

  @override
  String gymStrengthBonus(String bonus) {
    return 'Bonus do siły: $bonus%';
  }

  @override
  String get gymBonusAppliedToCrimes =>
      'Bonus ten jest stosowany do wszystkich prób popełnienia przestępstwa';

  @override
  String get gymReadyToTrain => 'Gotowy do treningu';

  @override
  String get gymTrainingCooldownTitle => 'Czas odnowienia treningu';

  @override
  String gymCooldown(String time) {
    return 'Następna sesja o $time';
  }

  @override
  String get gymCooldownHint =>
      'Pomiędzy sesjami treningowymi należy odczekać 1 godzinę';

  @override
  String get gymTrain => 'Pociąg';

  @override
  String get gymTrainingInProgress => 'Szkolenie...';

  @override
  String get gymHowItWorksTitle => 'Jak to działa?';

  @override
  String get gymHowItWorksBullet1 => '• Trenuj co godzinę, aby zwiększyć siłę';

  @override
  String get gymHowItWorksBullet2 => '• Każda sesja daje premię +0,08%.';

  @override
  String get gymHowItWorksBullet3 => '• Maksymalnie 100 sesji (łącznie +8%)';

  @override
  String get gymHowItWorksBullet4 =>
      '• Zwiększa wskaźnik powodzenia przestępstwa';

  @override
  String get gymHowItWorksBullet5 => '• Stały bonus, liczy się każda sesja';

  @override
  String get buyAmmo => 'Kup amunicję';

  @override
  String factoryPurchaseCost(String cost) {
    return 'Koszt zakupu: €$cost';
  }

  @override
  String factoryProductionOutput(String amount) {
    return 'Wydajność na cykl: $amount jednostek';
  }

  @override
  String factoryQualityMultiplier(String multiplier) {
    return 'Mnożnik jakości: ${multiplier}x';
  }

  @override
  String upgradeOutputCost(String cost, String nextAmount) {
    return 'Ulepsz wyjście - koszt: $cost €, następny wynik: $nextAmount';
  }

  @override
  String upgradeQualityCost(String cost, String nextQuality) {
    return 'Ulepsz jakość - koszt: $cost €, następna jakość: ${nextQuality}x';
  }

  @override
  String get factoryCostLabel => 'Koszt';

  @override
  String get factoryCurrentOutput => 'Prąd wyjściowy';

  @override
  String get factoryNextOutput => 'Następne wyjście';

  @override
  String get factoryCurrentQuality => 'Aktualna jakość';

  @override
  String get factoryNextQuality => 'Następna jakość';

  @override
  String get factoryUnitsPerCycle => 'jednostek/8h maks';

  @override
  String get factoryUnitsPerHour => 'jednostki/godzinę';

  @override
  String get factoryUpgradeMaxLevel => 'Fabryka jest na maksymalnym poziomie';

  @override
  String get countryUsa => 'USA';

  @override
  String get countryMexico => 'Meksyk';

  @override
  String get countryColombia => 'Kolumbia';

  @override
  String get countryBrazil => 'Brazylia';

  @override
  String get countryArgentina => 'Argentyna';

  @override
  String get countryJapan => 'Japonia';

  @override
  String get countryChina => 'Chiny';

  @override
  String get countryRussia => 'Rosja';

  @override
  String get countryIndia => 'Indie';

  @override
  String get countryAustralia => 'Australia';

  @override
  String get countrySouthAfrica => 'Republika Południowej Afryki';

  @override
  String get countryCanada => 'Kanada';

  @override
  String get countryPortugal => 'Portugalia';

  @override
  String get countryIreland => 'Irlandia';

  @override
  String get countryLuxembourg => 'Luksemburg';

  @override
  String get countryAustria => 'Austria';

  @override
  String get countryDenmark => 'Dania';

  @override
  String get countrySweden => 'Szwecja';

  @override
  String get countryNorway => 'Norwegia';

  @override
  String get countryFinland => 'Finlandia';

  @override
  String get countryPoland => 'Polska';

  @override
  String get countryCzechia => 'Czechy';

  @override
  String get countryGreece => 'Grecja';

  @override
  String get countryTurkey => 'Indyk';

  @override
  String get countryUae => 'Emiraty Arabskie';

  @override
  String get countryDubai => 'Dubai';

  @override
  String get toolBoltCutter => 'Obcinak do śrub';

  @override
  String get toolCarTheftTools => 'Narzędzia do kradzieży samochodów';

  @override
  String get toolBurglaryKit => 'Zestaw antywłamaniowy';

  @override
  String get toolToolbox => 'Skrzynka narzędziowa';

  @override
  String get toolCrowbar => 'Łom';

  @override
  String get toolGlassCutter => 'Przecinarka do szkła';

  @override
  String get toolSprayPaint => 'Farba w sprayu';

  @override
  String get toolJerryCan => 'Jerry Can';

  @override
  String get toolFakeDocuments => 'Fałszywe dokumenty';

  @override
  String get toolHackingLaptop => 'Włamanie do laptopa';

  @override
  String get toolCounterfeitingKit => 'Zestaw do podrabiania';

  @override
  String get toolRope => 'Lina';

  @override
  String get toolSilencer => 'Tłumik';

  @override
  String get toolNightVision => 'Nocna wizja';

  @override
  String get toolGpsJammer => 'Zagłuszacz GPS';

  @override
  String get toolBurnerPhone => 'Telefon Palnika';

  @override
  String get toolThermalDrill => 'Wiertarka termiczna';

  @override
  String get toolCategoryBoltCutter => 'Przecinarki do śrub';

  @override
  String get toolCategoryBurglaryKit => 'Zestaw antywłamaniowy';

  @override
  String get toolCategoryCarTools => 'Narzędzia do kradzieży samochodu';

  @override
  String get toolCategoryJerryCan => 'Jerry może';

  @override
  String get toolCategorySprayPaint => 'Farba w sprayu';

  @override
  String get toolCategoryCrowbar => 'Łom';

  @override
  String get toolCategoryGlassCutter => 'Przecinarka do szkła';

  @override
  String get toolCategoryLaptop => 'Laptopa';

  @override
  String get toolCategoryCounterfeiting => 'Podrabianie';

  @override
  String get toolCategoryToolbox => 'Skrzynka narzędziowa';

  @override
  String get toolCategoryRope => 'Lina';

  @override
  String get toolCategorySilencer => 'Tłumik';

  @override
  String get toolCategoryFakeDocs => 'Fałszywe dokumenty';

  @override
  String get toolCategoryNightVision => 'Widzenie w nocy';

  @override
  String get toolCategoryBurnerPhone => 'Telefon do palnika';

  @override
  String get toolCategoryGpsJammer => 'Zagłuszacz GPS';

  @override
  String get toolCategoryThermalDrill => 'Wiertarka termiczna';

  @override
  String get toolsScreenTitle => 'Czarny rynek – narzędzia';

  @override
  String get toolsTabBuy => 'Kupić';

  @override
  String get toolsTabMyTools => 'Moje narzędzia';

  @override
  String get toolsNoToolsAvailable => 'Brak dostępnych narzędzi';

  @override
  String get toolsEmptyInventoryTitle => 'Nie masz jeszcze żadnych narzędzi';

  @override
  String get toolsEmptyInventoryHint => 'Kup narzędzia w sklepie';

  @override
  String get toolsNotEnoughMoney => 'Nie masz dość pieniędzy!';

  @override
  String get toolsNotEnoughMoneyRepair => 'Nie masz dość pieniędzy na naprawę!';

  @override
  String get toolsBuyError => 'Błąd podczas zakupu';

  @override
  String get toolsRepairError => 'Błąd podczas naprawy';

  @override
  String toolsPurchased(String toolName) {
    return '$toolName zakupione!';
  }

  @override
  String toolsRepaired(String toolName, String cost) {
    return '$toolName naprawiony za $cost €';
  }

  @override
  String get toolsBadgeInventoryFull => 'PEŁNY';

  @override
  String get toolsBadgeBroken => 'ZŁAMANY';

  @override
  String get toolsBadgeRepair => 'NAPRAWA';

  @override
  String toolsLoadError(String error) {
    return 'Nie można załadować narzędzi: $error';
  }

  @override
  String get toolsErrToolNotFound => 'Nie znaleziono narzędzia.';

  @override
  String get toolsErrInventoryFullBuy =>
      'Twój ekwipunek jest pełny. Przechowuj trochę narzędzi lub zwiększ pojemność.';

  @override
  String get toolsErrPurchaseServer =>
      'Zakup narzędzia nie powiódł się z powodu problemu z serwerem.';

  @override
  String get toolsErrToolNotOwned => 'Nie jesteś właścicielem tego narzędzia.';

  @override
  String get toolsErrAlreadyMaxDurability =>
      'Narzędzie ma już maksymalną trwałość.';

  @override
  String get toolsErrRepairServer =>
      'Naprawa narzędzia nie powiodła się z powodu problemu z serwerem.';

  @override
  String toolsNetworkError(String error) {
    return 'Błąd sieci: $error';
  }

  @override
  String get crimeOutcomeSuccess => 'Kryminał udany!';

  @override
  String get crimeOutcomeCaught => 'Złapany przez policję';

  @override
  String get crimeOutcomeVehicleBreakdownBefore =>
      'Twój pojazd zepsuł się przed dotarciem na miejsce zbrodni';

  @override
  String get crimeOutcomeVehicleBreakdownDuring =>
      'Pojazd zepsuł się podczas ucieczki – porzucił większość łupów';

  @override
  String get crimeOutcomeOutOfFuel =>
      'Podczas ucieczki skończyło się paliwo – uciekł pieszo, zgubił łup i pojazd';

  @override
  String get crimeOutcomeToolBroke =>
      'Twoje narzędzie zepsuło się podczas przestępstwa, pozostawiając dowód';

  @override
  String get crimeOutcomeFledNoLoot => 'Uciekł z miejsca zdarzenia bez łupów';

  @override
  String get crimeResultMoneyLabel => 'Pieniądze';

  @override
  String get crimeResultXpLabel => 'XP';

  @override
  String get crimeOutcomeRowReward => 'Nagroda:';

  @override
  String get crimeOutcomeRowXp => 'PD:';

  @override
  String get crimeOutcomeRowTools => 'Narzędzia:';

  @override
  String crimeOutcomeToolDurabilityValue(int percent) {
    return '-$percent% trwałości';
  }

  @override
  String get icuIntensiveCareTitle => 'Intensywna terapia';

  @override
  String get icuInjuredLine =>
      'W trakcie działalności przestępczej odniosłeś poważne obrażenia.';

  @override
  String get icuUnconsciousLine =>
      'Jesteś teraz na oddziale intensywnej terapii i jesteś nieprzytomny.';

  @override
  String get icuRecoveryTimeLabel => 'Czas regeneracji:';

  @override
  String get icuWakeHp => 'Budzisz się z 10 HP';

  @override
  String get icuNoActionsHint =>
      'W tym czasie nie można wykonywać żadnych czynności. \nUważaj bardziej na swoje zdrowie!';

  @override
  String jailBailPaidSnackbar(int amount) {
    return '🎉 Jesteś wolny! Zapłacona kaucja: $amount €';
  }

  @override
  String jailInsufficientBail(int amount) {
    return 'Za mało pieniędzy na kaucję ($amount €)';
  }

  @override
  String jailCooldownWait(int seconds) {
    return 'Proszę czekać: $seconds s';
  }

  @override
  String get jailEscapeSuccess => 'Ucieczka się powiodła! Jesteś wolny.';

  @override
  String jailEscapeFailed(String penalty) {
    return 'Ucieczka nie powiodła się. Zdanie przedłużone o $penalty.';
  }

  @override
  String get jailEscapeGenericFailure => 'Ucieczka nie powiodła się';

  @override
  String jailErrorPrefix(String message) {
    return 'Błąd: $message';
  }

  @override
  String get jailTimeLeft => 'Pozostał czas';

  @override
  String jailPayBail(int amount) {
    return 'Zapłać kaucję ($amount €)';
  }

  @override
  String get jailCannotActWhileIn =>
      'Podczas odbywania kary nie możesz popełniać przestępstw, pracować ani podróżować.';

  @override
  String get jailAttemptEscape => 'Próba ucieczki';

  @override
  String get jailYouAreInJail => 'Jesteś w więzieniu';

  @override
  String get vehicleCondition => 'Stan';

  @override
  String get vehicleFuel => 'Paliwo';

  @override
  String get vehicleSpeed => 'Prędkość';

  @override
  String get vehicleArmor => 'Zbroja';

  @override
  String get vehicleStealth => 'Podstęp';

  @override
  String get vehicleCargo => 'Ładunek';

  @override
  String get vehicleRepair => 'Naprawa';

  @override
  String get vehicleRefuel => 'Zatankować';

  @override
  String get selectCrimeVehicle => 'Wybierz pojazd do przestępstw';

  @override
  String get noVehicleSelected => 'Nie wybrano pojazdu';

  @override
  String get selectedVehicle => 'Pojazd kryminalny';

  @override
  String get changeVehicle => 'Zmień pojazd';

  @override
  String get selectVehicle => 'Wybierz Pojazd';

  @override
  String get vehicleConditionLow => 'Stan pojazdu niski';

  @override
  String get vehicleFuelLow => 'Niski poziom paliwa w pojeździe';

  @override
  String get vehicleSelectedForCrimes => 'Pojazd wybrany do przestępstw!';

  @override
  String get vehicleDeselectedForCrimes =>
      'Pojazd odznaczono pod kątem przestępstw!';

  @override
  String get vehicleWrongCountry =>
      'Pojazd musi znajdować się w tym samym kraju co Ty';

  @override
  String get failedSelectVehicle => 'Nie udało się wybrać pojazdu';

  @override
  String get failedDeselectVehicle => 'Nie udało się odznaczyć pojazdu';

  @override
  String get selectedForCrimesBadge => 'Wybrany za przestępstwa';

  @override
  String get selectedButton => 'Wybrany';

  @override
  String get selectButton => 'Wybierać';

  @override
  String get deselectButton => 'Odznacz';

  @override
  String get prostitutionTitle => 'Prostytucja';

  @override
  String get prostitutionTotal => 'Całkowity';

  @override
  String get prostitutionStreet => 'Na ulicy';

  @override
  String get prostitutionRedLight => 'Czerwone światło';

  @override
  String get prostitutionPotentialEarnings => 'Zyski';

  @override
  String get prostitutionCollect => 'Zbierać';

  @override
  String get prostitutionRecruit => 'Rekrut';

  @override
  String get prostitutionMyProstitutes => 'Moje prostytutki';

  @override
  String get prostitutionRedLightDistricts => 'Dzielnice czerwonych latarni';

  @override
  String get prostitutionNoProstitutes =>
      'Nie zatrudniono jeszcze żadnych prostytutek';

  @override
  String get prostitutionLocation => 'Lokalizacja';

  @override
  String get prostitutionMoveToRedLight =>
      'Przenieś do dzielnicy czerwonych latarni';

  @override
  String get prostitutionMoveToRldShort => 'Do RLD';

  @override
  String get prostitutionMoveToStreet => 'Przenieś się na ul';

  @override
  String get prostitutionViewDistricts => 'Zobacz dzielnice';

  @override
  String get prostitutionAvailable => 'Dostępny';

  @override
  String get prostitutionMyDistricts => 'Moje dzielnice';

  @override
  String get prostitutionCurrentRLD => 'Obecny RLD';

  @override
  String get prostitutionMyRLDs => 'Moje RLD';

  @override
  String get prostitutionNoAvailableDistricts => 'Brak dostępnych dzielnic';

  @override
  String get prostitutionNoOwnedDistricts =>
      'Nie posiadasz jeszcze żadnych dzielnic';

  @override
  String get prostitutionRooms => 'pokoje';

  @override
  String get prostitutionOccupancy => 'Okupacja';

  @override
  String get prostitutionIncome => 'Dochód';

  @override
  String get prostitutionTenants => 'Najemcy';

  @override
  String get prostitutionBuy => 'Kupić';

  @override
  String get prostitutionManage => 'Zarządzać';

  @override
  String get prostitutionPurchaseConfirmTitle => 'Kup Dystrykt';

  @override
  String prostitutionPurchaseConfirmMessage(String country, int price) {
    return 'Czy na pewno chcesz kupić Dzielnicę Czerwonych Latarni w $country za $price?';
  }

  @override
  String get prostitutionPurchase => 'Kupić';

  @override
  String get prostitutionPurchaseSuccess => 'Dzielnica zakupiona pomyślnie!';

  @override
  String get prostitutionPurchaseFailed => 'Zakup nie powiódł się';

  @override
  String get prostitutionDistrictManagement => 'Zarząd Okręgowy';

  @override
  String get prostitutionDistrictNotFound => 'Nie znaleziono dzielnicy';

  @override
  String get prostitutionDistrictOwnedBadge => 'Posiadany';

  @override
  String get prostitutionOwnerLabel => 'Właściciel:';

  @override
  String get prostitutionForSale => 'Na sprzedaż';

  @override
  String get prostitutionRoomsLabel => 'Pokoje:';

  @override
  String get prostitutionRoomsRented => 'wynajęty';

  @override
  String prostitutionRldAppBarTitle(String country) {
    return 'Dzielnica czerwonych latarni ($country)';
  }

  @override
  String get prostitutionOccupiedShort => 'Zajęty';

  @override
  String get prostitutionNotApplicable => 'Nie dotyczy';

  @override
  String get back => 'Z powrotem';

  @override
  String prostitutionMoveToStreetConfirm(String name) {
    return 'Czy na pewno chcesz przenieść $name z Dzielnicy Czerwonych Latarni na ulicę?';
  }

  @override
  String get prostitutionMoveSuccess => 'Pomyślnie przeniesiono';

  @override
  String get prostitutionMoveFailed => 'Przeniesienie nie powiodło się';

  @override
  String get prostitutionNoStreetProstitutes => 'Na ulicy nie ma prostytutek';

  @override
  String get prostitutionSelectProstitute => 'Wybierz Prostytutka';

  @override
  String get prostitutionOnStreet => 'Na ulicy';

  @override
  String get prostitutionRoom => 'Pokój';

  @override
  String get prostitutionInRedLight => 'W dzielnicy czerwonych latarni';

  @override
  String get prostitutionEarnings => 'Zyski';

  @override
  String get prostitutionRent => 'Wynajem';

  @override
  String get prostitutionNetIncome => 'Dochód netto';

  @override
  String get prostitutionLevel => 'Poziom';

  @override
  String get prostitutionXpToNext => 'XP do następnego poziomu';

  @override
  String get prostitutionBusted => 'PRZYPADKOWANY';

  @override
  String get prostitutionBustedCount => 'Czasy się popsuły';

  @override
  String get prostitutionLevelBonus => 'Bonus za poziom';

  @override
  String get prostitutionVipBonus => 'Bonus VIP: +50% zarobków';

  @override
  String get prostitutionUpgradeTier => 'Uaktualnij poziom';

  @override
  String get prostitutionUpgradeSecurity => 'Uaktualnij zabezpieczenia';

  @override
  String get prostitutionTier => 'Szczebel';

  @override
  String get prostitutionSecurity => 'Bezpieczeństwo';

  @override
  String get prostitutionTierBasic => 'Podstawowy';

  @override
  String get prostitutionTierLuxury => 'Luksus';

  @override
  String get prostitutionTierVip => 'VIP-a';

  @override
  String get prostitutionSecurityLevel => 'Poziom bezpieczeństwa';

  @override
  String get prostitutionRaidChance => 'Szansa na napad';

  @override
  String get prostitutionMaxTier => 'Osiągnięto maksymalny poziom';

  @override
  String get prostitutionMaxSecurity => 'Osiągnięto maksymalne bezpieczeństwo';

  @override
  String get prostitutionUpgradeSuccess => 'Aktualizacja powiodła się!';

  @override
  String get prostitutionUpgradeFailed => 'Aktualizacja nie powiodła się';

  @override
  String get prostitutionTabWorkers => 'Pracownicy';

  @override
  String get prostitutionTabRld => 'RLD';

  @override
  String get prostitutionTabEvents => 'Wydarzenia';

  @override
  String get prostitutionTabSocial => 'Społeczny';

  @override
  String get prostitutionRecruitCeremonyTitle => 'Nowy rekrut';

  @override
  String prostitutionCollectConfirm(String amount) {
    return 'Zbierz $amount oczekujących zarobków?';
  }

  @override
  String get prostitutionCollectEmpty =>
      'Brak zarobków do zebrania w tej chwili.';

  @override
  String prostitutionCollectSuccess(String amount) {
    return 'Zebrano $amount €.';
  }

  @override
  String get prostitutionCollectFailed => 'Nie udało się zebrać zarobków.';

  @override
  String get prostitutionWorkersKpi => 'Pracownicy (S/RLD/NC)';

  @override
  String get prostitutionHourlyKpi => '€/godz';

  @override
  String get prostitutionRecruitReady => 'Gotowy';

  @override
  String get prostitutionRetry => 'Spróbować ponownie';

  @override
  String get prostitutionMove => 'Przenosić';

  @override
  String get prostitutionFbiHeat => 'Temperatura FBI';

  @override
  String get prostitutionRaidStatsTitle => 'Ryzyko napadu';

  @override
  String get prostitutionRaidStatsDistricts => 'Dzielnice';

  @override
  String get prostitutionRaidStatsBusted => 'Obecnie złapany';

  @override
  String prostitutionUpgradeTierConfirm(String tier, String cost) {
    return 'Uaktualnić poziom do $tier za $cost?';
  }

  @override
  String prostitutionUpgradeSecurityConfirm(String level, String cost) {
    return 'Uaktualnić bezpieczeństwo do poziomu $level za $cost?';
  }

  @override
  String prostitutionRoomsOccupied(String occupied, String total) {
    return '$occupied/$total pokoi';
  }

  @override
  String prostitutionNextEarnings(String net) {
    return 'Dalej: €$net/h netto';
  }

  @override
  String prostitutionCurrentEarningsNet(String net) {
    return 'Teraz: $net/h netto';
  }

  @override
  String prostitutionRaidReduction(String pct) {
    return 'Redukcja nalotów: $pct';
  }

  @override
  String get vipEventsTitle => 'Wydarzenia VIP';

  @override
  String get vipEventsTabTitle => 'Wydarzenia VIP';

  @override
  String get vipEventsDescription =>
      'Przydzielaj prostytutki do wydarzeń VIP, aby uzyskać dodatkowe zarobki!';

  @override
  String get vipEventsActive => 'Aktywne wydarzenia';

  @override
  String get vipEventsUpcoming => 'Nadchodzące wydarzenia';

  @override
  String get vipEventsMyParticipations => 'Moje aktywne uczestnictwo';

  @override
  String get vipEventTypeTitle => 'Wydarzenie VIP';

  @override
  String get vipEventCelebrity => 'Wizyta gwiazd';

  @override
  String get vipEventBachelor => 'Wieczór kawalerski';

  @override
  String get vipEventConvention => 'Konwencja';

  @override
  String get vipEventFestival => 'Festiwal';

  @override
  String get vipEventBonus => 'PREMIA';

  @override
  String get vipEventSpots => 'grochy';

  @override
  String get vipEventParticipants => 'Uczestnicy';

  @override
  String get vipEventFull => 'WYDARZENIE PEŁNE';

  @override
  String get vipEventRequires => 'Wymaga';

  @override
  String get vipEventLevel => 'Poziom';

  @override
  String get vipEventLocation => 'Lokalizacja';

  @override
  String get vipEventEndsIn => 'Kończy się w';

  @override
  String get vipEventStartsIn => 'Zaczyna się w';

  @override
  String get vipEventNoActive => 'Brak aktywnych wydarzeń w tej chwili';

  @override
  String get vipEventNoUpcoming => 'Brak nadchodzących wydarzeń';

  @override
  String get vipEventAssignProstitute => 'Przypisz prostytutkę';

  @override
  String get vipEventAssignDialogTitle => 'Przypisz do';

  @override
  String vipEventNoEligible(int level, String country) {
    return 'Brak odpowiednich prostytutek. Potrzebujesz poziomu $level+ w $country';
  }

  @override
  String get vipEventJoinSuccess => 'Dołączono do wydarzenia!';

  @override
  String get vipEventJoinFailed => 'Nie udało się dołączyć do wydarzenia';

  @override
  String get vipEventLeave => 'Opuść wydarzenie';

  @override
  String get vipEventLeaveSuccess => 'Opuścił wydarzenie';

  @override
  String get vipEventLeaveFailed => 'Nie można opuścić wydarzenia';

  @override
  String get vipEventAssigned => 'Przydzielony';

  @override
  String get vipEventPerHour => '/godzina';

  @override
  String get vipEventEarnings => 'Zyski';

  @override
  String get prostitutionLeaderboardTitle => 'Tablica liderów prostytucji';

  @override
  String get prostitutionLeaderboardWeekly => 'Tygodnik';

  @override
  String get prostitutionLeaderboardMonthly => 'Miesięczny';

  @override
  String get prostitutionLeaderboardAllTime => 'Wszechczasów';

  @override
  String get prostitutionLeaderboardYourRank => 'Twój ranking tygodniowy';

  @override
  String get prostitutionLeaderboardUnranked => 'Nierankingowe';

  @override
  String get prostitutionLeaderboardNoData =>
      'Brak jeszcze danych o tabeli liderów';

  @override
  String get prostitutionLeaderboardButton => 'Tabela liderów';

  @override
  String get prostitutionRivalryButton => 'Rywalizacja';

  @override
  String get prostitutionLeaderboardAchievements => 'Osiągnięcia';

  @override
  String get prostitutionLeaderboardLoadFailed =>
      'Nie udało się załadować tabeli liderów';

  @override
  String get achievementsTitle => 'Osiągnięcia';

  @override
  String achievementsProgress(int unlocked, int total) {
    return '$unlocked z $total odblokowane';
  }

  @override
  String get achievementsCategoryAll => 'Wszystko';

  @override
  String get achievementsCategoryProgression => 'Postęp';

  @override
  String get achievementsCategoryWealth => 'Bogactwo';

  @override
  String get achievementsCategoryPower => 'Moc';

  @override
  String get achievementsCategorySocial => 'Społeczny';

  @override
  String get achievementsCategoryMastery => 'Mistrzostwo';

  @override
  String get achievementLocked => 'Zamknięty';

  @override
  String get achievementReward => 'Nagroda';

  @override
  String get achievementUnlocked => 'Odblokowany';

  @override
  String get achievementNoData => 'Nie znaleziono żadnych osiągnięć';

  @override
  String get achievementLoadFailed => 'Nie udało się wczytać osiągnięć';

  @override
  String achievementsMoney(String amount) {
    return '€$amount';
  }

  @override
  String achievementsXp(String xp) {
    return '$xp PD';
  }

  @override
  String achievementsUnlockedDate(String date) {
    return 'Odblokowano $date';
  }

  @override
  String achievementsDetailProgress(int current, int required) {
    return 'Postęp: $current/$required';
  }

  @override
  String get achievementsNoRewardConfigured =>
      'Nie skonfigurowano jeszcze żadnej nagrody';

  @override
  String get achievementsRewardOnUnlock =>
      'Otrzymasz tę nagrodę po odblokowaniu osiągnięcia.';

  @override
  String get achievementsDateToday => 'Dzisiaj';

  @override
  String get achievementsDateYesterday => 'Wczoraj';

  @override
  String achievementsDateDaysAgo(int days) {
    return '$days dni temu';
  }

  @override
  String get achievementsDetails => 'Bliższe dane';

  @override
  String get achievementsCategory => 'Kategoria';

  @override
  String get achievementsSectionProgress => 'Postęp';

  @override
  String achievementsPercentComplete(int percent) {
    return '$percent% ukończone';
  }

  @override
  String get achievementsCategoryNameProstitution => 'Prostytucja';

  @override
  String get achievementsCategoryNameRld => 'RLD';

  @override
  String get achievementsCategoryNameCrimes => 'Przestępstwa';

  @override
  String get achievementsCategoryNameJobs => 'Prace';

  @override
  String get achievementsCategoryNameSchool => 'Szkoła';

  @override
  String get achievementsCategoryNameVehicles => 'Pojazdy';

  @override
  String get achievementsCategoryNameTravel => 'Podróże';

  @override
  String get achievementsCategoryNameDrugs => 'Narkotyki';

  @override
  String get achievementsCategoryNameTrade => 'Handel';

  @override
  String get achievementsCategoryNameGeneral => 'Ogólne';

  @override
  String get achievementJobItSpecialistTitle => 'Specjalista IT';

  @override
  String get achievementJobItSpecialistDescription =>
      'Ukończ swoją pierwszą zmianę jako Programista';

  @override
  String get achievementJobLawyerTitle => 'Uliczny prawnik';

  @override
  String get achievementJobLawyerDescription =>
      'Ukończ swoją pierwszą zmianę jako prawnik';

  @override
  String get achievementJobDoctorTitle => 'Podziemny lekarz';

  @override
  String get achievementJobDoctorDescription =>
      'Ukończ swoją pierwszą zmianę jako lekarz';

  @override
  String get achievementSchoolCertifiedTitle => 'Certyfikowany student';

  @override
  String get achievementSchoolCertifiedDescription =>
      'Zdobądź 3 certyfikaty szkolne';

  @override
  String get achievementSchoolMultiCertifiedTitle => 'Wielocertyfikowany';

  @override
  String get achievementSchoolMultiCertifiedDescription =>
      'Zdobądź 6 certyfikatów szkolnych';

  @override
  String get achievementSchoolTrackSpecialistTitle => 'Specjalista od torów';

  @override
  String get achievementSchoolTrackSpecialistDescription =>
      'Maksymalnie 3 tory szkolne';

  @override
  String get schoolMenuLabel => 'Szkoła';

  @override
  String get schoolMenuSubtitle => 'Wyrównaj swoje wykształcenie i certyfikaty';

  @override
  String get schoolTitle => 'Szkoła i edukacja';

  @override
  String get schoolIntro =>
      'Odblokuj zadania i zasoby poprzez poziomy i certyfikaty.';

  @override
  String get schoolTracksTitle => 'Dostępne wykształcenie';

  @override
  String get schoolUnlockableContentTitle => 'Zablokowana edukacja';

  @override
  String schoolOverallLevelLabel(int level) {
    return 'Poziom szkoły: $level';
  }

  @override
  String schoolLoadError(String error) {
    return 'Nie można załadować danych szkoły: $error';
  }

  @override
  String schoolTrackLevelLabel(int current, int max) {
    return 'Poziom $current/$max';
  }

  @override
  String schoolXpLabel(int xp) {
    return 'XP: $xp';
  }

  @override
  String schoolTrainBonusLevels(int count) {
    return '+$count poz.';
  }

  @override
  String schoolTrainBonusCerts(int count) {
    return '+$count cert.';
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
    return '$name (Poz. $level)';
  }

  @override
  String get schoolGateStatusOpen => 'OTWARTE';

  @override
  String get schoolGateStatusLocked => 'ZAMKNIĘTY';

  @override
  String schoolGateRankProgress(int current, int required) {
    return 'Ranga gracza: $current/$required';
  }

  @override
  String schoolGateTrackLevelProgress(String track, int current, int required) {
    return '$track poziom: $current/$required';
  }

  @override
  String schoolGateJobTarget(String target) {
    return 'Praca: $target';
  }

  @override
  String get schoolGateAssetCasinoPurchase => 'Zasób: zakup kasyna';

  @override
  String get schoolGateAssetAmmoFactoryPurchase =>
      'Zasób: Zakup fabryki amunicji';

  @override
  String get schoolGateAssetAmmoOutputUpgrade =>
      'Zasób: ulepszenie produkcji amunicji';

  @override
  String get schoolGateAssetAmmoQualityUpgrade =>
      'Zasób: Ulepszenie jakości amunicji';

  @override
  String get schoolGateAssetDrugFacilitySlotsTier1 =>
      'Zasób: ulepszenie miejsca w placówce narkotykowej I';

  @override
  String get schoolGateAssetDrugFacilitySlotsTier2 =>
      'Zasób: Ulepszenie miejsca w placówce narkotykowej II';

  @override
  String get schoolGateAssetDrugFacilitySlotsTier3 =>
      'Zasób: Ulepszenie miejsca w placówce narkotykowej III';

  @override
  String get schoolGateAssetDrugFacilitySlotsTier4 =>
      'Zasób: ulepszenie miejsca w placówce narkotykowej IV';

  @override
  String get schoolGateAssetDrugFacilityEquipmentTier1 =>
      'Zasób: Ulepszenie wyposażenia placówki farmaceutycznej I';

  @override
  String get schoolGateAssetDrugFacilityEquipmentTier2 =>
      'Zasób: Ulepszenie wyposażenia placówki farmaceutycznej II';

  @override
  String get schoolGateAssetDrugFacilityEquipmentTier3 =>
      'Zasób: Ulepszenie wyposażenia placówki farmaceutycznej III';

  @override
  String schoolGateAssetGeneric(String target) {
    return 'Zasób: $target';
  }

  @override
  String schoolGateSystemGeneric(String type, String target) {
    return '$type: $target';
  }

  @override
  String get educationDialogDefaultTitle => '🔒 Wymagane wykształcenie';

  @override
  String get educationDialogFallbackMessage =>
      'Wymagania nie zostały spełnione. Aby kontynuować, spełnij wymagania edukacyjne.';

  @override
  String get educationDialogClose => 'Zamknąć';

  @override
  String get educationLockedJobsSectionTitle =>
      '🔒 Zablokowane prace (wymagane wykształcenie)';

  @override
  String get educationAmmoOutputUpgradeLockedTitle =>
      '🔒 Aktualizacja wyjścia zablokowana';

  @override
  String get educationAmmoQualityUpgradeLockedTitle =>
      '🔒 Aktualizacja jakości zablokowana';

  @override
  String get educationAmmoFactoryPurchaseLockedTitle =>
      '🔒 Zakup fabryczny zablokowany';

  @override
  String educationRequirementRankProgress(int requiredRank, int currentRank) {
    return 'Potrzebujesz rangi gracza $requiredRank · Aktualna ranga gracza $currentRank';
  }

  @override
  String get educationRequirementTrackLevelTitle => 'Poziom edukacji';

  @override
  String educationRequirementTrackLevelProgress(
    String trackName,
    int requiredLevel,
    int currentLevel,
  ) {
    return 'wymagany $trackName poziom $requiredLevel · Obecny $currentLevel';
  }

  @override
  String get educationRequirementCertificationTitle => 'Wymagana certyfikacja';

  @override
  String get educationRequirementGenericTitle => 'Wymóg';

  @override
  String get educationRequirementUnknown => 'Nieznane wymaganie';

  @override
  String get educationTrackNameAviation => 'Lotnictwo';

  @override
  String get educationTrackNameLaw => 'Prawo';

  @override
  String get educationTrackNameMedicine => 'Medycyna';

  @override
  String get educationTrackNameFinance => 'Finanse';

  @override
  String get educationTrackNameEngineering => 'Inżynieria';

  @override
  String get educationTrackNameIt => 'IT';

  @override
  String get educationTrackNameNarcotics => 'Inżynieria Narkotyków';

  @override
  String get schoolTrackDescriptionAviation =>
      'Teoria lotu, nawigacja i obsługa samolotów.';

  @override
  String get schoolTrackDescriptionLaw =>
      'Prawo karne, procedura i praktyka na sali sądowej.';

  @override
  String get schoolTrackDescriptionMedicine =>
      'Reagowanie w sytuacjach kryzysowych, diagnostyka i praktyka lekarska.';

  @override
  String get schoolTrackDescriptionFinance =>
      'Księgowość, inwestycje i operacje biznesowe.';

  @override
  String get schoolTrackDescriptionEngineering =>
      'Systemy mechaniczne, bezpieczeństwo przemysłowe i produkcja.';

  @override
  String get schoolTrackDescriptionIt =>
      'Tworzenie oprogramowania, systemów i operacji sieciowych.';

  @override
  String get schoolTrackDescriptionNarcotics =>
      'Kontrolowana uprawa, elektryka procesowa i zaawansowana produkcja chemiczna.';

  @override
  String schoolTrackCooldownActive(int seconds) {
    return 'Aktywny czas odnowienia: pozostało $seconds s';
  }

  @override
  String get schoolTrackMaxLevelReached =>
      'Tor jest już na maksymalnym poziomie';

  @override
  String get schoolTrackStartFailed => 'Nie udało się rozpocząć treningu';

  @override
  String get educationCertHydroponicSpecialist =>
      'Certyfikat specjalisty hydroponiki';

  @override
  String get educationCertProcessElectricsSpecialist =>
      'Certyfikat Specjalisty Elektryki Procesowej';

  @override
  String get educationCertClandestineChemist => 'Certyfikat Tajnego Chemika';

  @override
  String get educationCertNarcoGridArchitect =>
      'Certyfikat architekta Narco Grid';

  @override
  String get educationCertSoftwareEngineer =>
      'Certyfikat Inżyniera Oprogramowania';

  @override
  String get educationCertBarExam => 'Egzamin adwokacki';

  @override
  String get educationCertMedicalLicense => 'Licencja lekarska';

  @override
  String get educationCertFlightCommercial => 'Licencja na lot komercyjny';

  @override
  String get educationCertFlightBasic => 'Podstawowa licencja lotnicza';

  @override
  String get educationCertIndustrialSafety =>
      'Certyfikat Bezpieczeństwa Przemysłowego';

  @override
  String get educationCertFinancialAnalyst =>
      'Certyfikat analityka finansowego';

  @override
  String get educationCertCasinoManagement => 'Certyfikat zarządzania kasynem';

  @override
  String get educationCertParamedic => 'Certyfikat ratownika medycznego';

  @override
  String get prostitutionLeaderboardProstitutesUnit => 'prostytutki';

  @override
  String get prostitutionLeaderboardDistrictsUnit => 'dzielnice';

  @override
  String get rivalryTitle => 'Rywalizacja';

  @override
  String get rivalryChallengeTitle => 'Rzuć wyzwanie graczowi';

  @override
  String get rivalryChallengeHint =>
      'Wpisz nazwę gracza (lub ID), aby rozpocząć rywalizację.';

  @override
  String get rivalryPlayerIdHint => 'Nazwa gracza lub ID';

  @override
  String get rivalryStartButton => 'Start';

  @override
  String get rivalryNoActive => 'Nie ma jeszcze aktywnych rywalizacji.';

  @override
  String get rivalryActiveTitle => 'Aktywni rywale';

  @override
  String get rivalryScoreLabel => 'Wynik rywalizacji';

  @override
  String get rivalryRecentActivity => 'Ostatnia aktywność';

  @override
  String get rivalryNoActivity => 'Nie ma jeszcze żadnych działań sabotażowych';

  @override
  String get rivalryCooldownReady => 'Sabotaż gotowy';

  @override
  String rivalryCooldownIn(String duration) {
    return 'Czas odnowienia: $duration';
  }

  @override
  String get rivalryActionTipPolice => 'Napiwek Policja (5 tys. euro)';

  @override
  String get rivalryActionStealCustomer => 'Ukradnij klienta (3 tys. €)';

  @override
  String get rivalryActionDamageReputation =>
      'Uszkodzona reputacja (10 tys. euro)';

  @override
  String get rivalryActionBribeEmployee => 'Łapówka pracownika (8 tys. euro)';

  @override
  String get rivalryUpdateMessage => 'Rywalizacja zaktualizowana';

  @override
  String get rivalrySabotageExecuted => 'Dokonano sabotażu';

  @override
  String get rivalryConfirmTitle => 'Potwierdź sabotaż';

  @override
  String rivalryConfirmTarget(String username) {
    return 'Cel: $username';
  }

  @override
  String rivalryConfirmAction(String action) {
    return 'Akcja: $action';
  }

  @override
  String rivalryConfirmCost(int amount) {
    return 'Koszt: $amount €';
  }

  @override
  String rivalryConfirmEffect(String effect) {
    return 'Efekt: $effect';
  }

  @override
  String get rivalryConfirmWarning =>
      'Sukces nie jest gwarantowany i możesz stracić pieniądze.';

  @override
  String get rivalryExecuteButton => 'Wykonać';

  @override
  String get rivalryEffectTipPolice => 'Zwiększ presję policji na rywala';

  @override
  String get rivalryEffectStealCustomer =>
      'Ukradnij część przepływów pieniężnych konkurencji';

  @override
  String get rivalryEffectDamageReputation =>
      'Niższy postęp konkurencyjnej prostytutki';

  @override
  String get rivalryEffectBribeEmployee =>
      'Zmuś jedną z konkurencyjnych prostytutek do stanu rozkładu';

  @override
  String get prostitutionUnderAttackTitle => 'Twoje imperium jest atakowane';

  @override
  String prostitutionUnderAttackBody(String attacker, String action) {
    return '$attacker użył $action przeciwko tobie w ciągu ostatnich 24 godzin.';
  }

  @override
  String get prostitutionUnderAttackAction => 'Otwarta rywalizacja';

  @override
  String get prostitutionBetrayalDefaultMessage =>
      'Zdrada! Twój Nightclub został uderzony wyciekiem informacji.';

  @override
  String get prostitutionLoadError => 'Błąd ładowania danych';

  @override
  String get prostitutionNoDistrictInCountry =>
      'Brak dzielnicy czerwonych latarni w tym kraju';

  @override
  String get prostitutionMovedToStreet => 'Przeniesiona na ulicę';

  @override
  String get prostitutionArrestedCannotAssign =>
      'Ta prostytutka jest aresztowana i nie może zostać przydzielona.';

  @override
  String get prostitutionNoNightclubVenue =>
      'Nie masz jeszcze lokalu Nightclub, aby przydzielić personel.';

  @override
  String get prostitutionNightclubVenueName => 'Klub nocny';

  @override
  String prostitutionNightclubVenueNumbered(int id) {
    return 'Nightclub #$id';
  }

  @override
  String get prostitutionAssignedNightclub => 'Przydzielono do Nightclub';

  @override
  String get prostitutionArrestedCannotWork =>
      'Ta prostytutka jest aresztowana i nie może pracować.';

  @override
  String prostitutionShiftRestNeeded(String duration) {
    return 'Potrzeba jeszcze $duration odpoczynku przed następną zmianą.';
  }

  @override
  String get prostitutionWorkShiftCompleted => 'Zmiana zakończona';

  @override
  String get prostitutionNoWorkersToAssign =>
      'Brak dostępnych prostytutek do wysłania do pracy.';

  @override
  String prostitutionWorkAllSentCount(int count) {
    return '$count prostytutek wysłano do pracy.';
  }

  @override
  String prostitutionWorkAllPartial(int success, int failed) {
    return '$success wysłano do pracy, $failed nieudanych.';
  }

  @override
  String get prostitutionRecruitedDefault => 'Zrekrutowano!';

  @override
  String get prostitutionRecruitFailed => 'Rekrutacja nie powiodła się';

  @override
  String get prostitutionRecruitConnectionError =>
      'Rekrutacja nie powiodła się z powodu błędu połączenia';

  @override
  String get prostitutionEventUpdate => 'Wydarzenie zaktualizowane';

  @override
  String get prostitutionBuyPropertyFirst => 'Najpierw kup dom lub mieszkanie';

  @override
  String prostitutionWorkAll(int count) {
    return 'Wyślij wszystkie do pracy ($count)';
  }

  @override
  String get prostitutionNoHousingForRecruit =>
      'Brak wolnego miejsca w zakwaterowaniu. Kup lub ulepsz dom lub mieszkanie przed rekrutacją kolejnych prostytutek.';

  @override
  String get prostitutionHousingTitle => 'Zakwaterowanie';

  @override
  String prostitutionHousingRentRule(int days) {
    return 'Każda prostytutka musi odrobić co najmniej jedną zmianę co $days dni, aby pokryć czynsz.';
  }

  @override
  String get prostitutionHousingSlots => 'Miejsca';

  @override
  String get prostitutionHousingFree => 'Wolne';

  @override
  String get prostitutionHousingHomes => 'Domy';

  @override
  String get prostitutionHousingAvgUpgrade => 'Śr. ulepszenie';

  @override
  String get prostitutionHousingHappinessBonus => 'Bonus szczęścia';

  @override
  String get prostitutionHousingWeeklyRent => 'Czynsz tygodniowy';

  @override
  String get prostitutionHousingAtRisk => 'Zagrożone';

  @override
  String get prostitutionHousingSafe => 'Bezpieczne';

  @override
  String prostitutionBetrayalActiveDetail(int grams, int licenses) {
    return 'Aktywowano zdradę: skonfiskowano $grams g narkotyków, cofnięto $licenses licencję(-e) Nightclub.';
  }

  @override
  String get prostitutionEarningsInsightTitle =>
      'Podsumowanie zarobków (aktywne prostytutki)';

  @override
  String prostitutionEarningsStreetDetail(int count, int euros) {
    return 'Ulica: $count • €$euros/h';
  }

  @override
  String prostitutionEarningsRldDetail(int count, int euros) {
    return 'Dzielnica czerwonych latarni: $count • €$euros/h';
  }

  @override
  String prostitutionEarningsNightclubDetail(int count, int euros) {
    return 'Nightclub: $count • €$euros/h';
  }

  @override
  String prostitutionEarningsTotalDetail(int euros) {
    return 'Łącznie: €$euros/h';
  }

  @override
  String get prostitutionHappinessEcstatic => 'Ekstatyczna';

  @override
  String get prostitutionHappinessHappy => 'Szczęśliwa';

  @override
  String get prostitutionHappinessStable => 'Stabilna';

  @override
  String get prostitutionHappinessStressed => 'Zestresowana';

  @override
  String get prostitutionHappinessMiserable => 'Nieszczęśliwa';

  @override
  String get prostitutionHousingExpired => 'Wygasło';

  @override
  String prostitutionHousingDaysLeft(int days) {
    return 'zostało $days d.';
  }

  @override
  String get prostitutionHousingLessThanOneDay => 'Mniej niż 1 dzień';

  @override
  String get prostitutionNightclubShort => 'Klub nocny';

  @override
  String get prostitutionMoveToStreetButton => 'Na ulicę';

  @override
  String get prostitutionMoveToNightclubButton => 'Do Nightclub';

  @override
  String prostitutionEuroPerHour(String amount) {
    return '€$amount/h';
  }

  @override
  String prostitutionHappinessDetail(String label, int score, String bonus) {
    return 'Szczęście $label ($score%) • Zysk $bonus';
  }

  @override
  String prostitutionHousingStatus(String status) {
    return 'Zakwaterowanie: $status';
  }

  @override
  String prostitutionWeeklyRentEuro(int amount) {
    return 'Czynsz tygodniowy €$amount';
  }

  @override
  String get prostitutionWork8h => 'Pracuj 8 h';

  @override
  String prostitutionRestFor(String duration) {
    return 'Odpoczywaj $duration';
  }

  @override
  String prostitutionNextShiftIn(String duration) {
    return 'Następna zmiana za $duration';
  }

  @override
  String prostitutionTimeHoursMinutes(int hours, int minutes) {
    return '$hours h $minutes min';
  }

  @override
  String get rivalryProtectionTitle => 'Ubezpieczenie ochronne';

  @override
  String get rivalryProtectionDescription =>
      'Zmniejsza wpływ nadchodzącego sabotażu o 30% na 7 dni.';

  @override
  String get rivalryProtectionInactive => 'Brak aktywnej ochrony';

  @override
  String rivalryProtectionActive(String date) {
    return 'Aktywny do: $date';
  }

  @override
  String get rivalryProtectionBuy => 'Kup ochronę (25 tys. €/tydzień)';

  @override
  String get rivalryProtectionActivated => 'Aktywowano ubezpieczenie ochronne';

  @override
  String get achievementTitle_first_steps => 'Pierwsze kroki';

  @override
  String get achievementDescription_first_steps =>
      'Zrekrutuj swoją pierwszą prostytutkę';

  @override
  String get achievementTitle_growing_empire => 'Rosnące Imperium';

  @override
  String get achievementDescription_growing_empire => 'Zrekrutuj 5 prostytutek';

  @override
  String get achievementTitle_first_district => 'Pierwsza dzielnica';

  @override
  String get achievementDescription_first_district =>
      'Kup swoją pierwszą dzielnicę czerwonych latarni';

  @override
  String get achievementTitle_empire_builder => 'Budowniczy Imperium';

  @override
  String get achievementDescription_empire_builder =>
      'Posiadaj 5 dzielnic czerwonych latarni';

  @override
  String get achievementTitle_district_master => 'Mistrz Okręgowy';

  @override
  String get achievementDescription_district_master =>
      'Posiadaj 10 dzielnic czerwonych latarni';

  @override
  String get achievementTitle_leveling_master => 'Mistrz poziomowania';

  @override
  String get achievementDescription_leveling_master =>
      'Wymaksuj prostytutkę do poziomu 10';

  @override
  String get achievementTitle_untouchable => 'Niedotykalny';

  @override
  String get achievementDescription_untouchable =>
      'Nigdy nie daj się złapać przez 7 kolejnych dni';

  @override
  String get achievementTitle_millionaire => 'Milioner';

  @override
  String get achievementDescription_millionaire =>
      'Zgromadź łączne zarobki w wysokości 1 000 000 EUR';

  @override
  String get achievementTitle_high_roller => 'Wysoki Roller';

  @override
  String get achievementDescription_high_roller =>
      'Zgromadź łączne zarobki w wysokości 5 000 000 EUR';

  @override
  String get achievementTitle_vip_service => 'Obsługa VIP-ów';

  @override
  String get achievementDescription_vip_service => 'Ukończ 10 wydarzeń VIP';

  @override
  String get achievementTitle_event_enthusiast => 'Entuzjasta wydarzeń';

  @override
  String get achievementDescription_event_enthusiast =>
      'Ukończ 25 wydarzeń VIP';

  @override
  String get achievementTitle_security_expert => 'Ekspert ds. bezpieczeństwa';

  @override
  String get achievementDescription_security_expert =>
      'Maksymalizuj poziom bezpieczeństwa we wszystkich posiadanych dzielnicach';

  @override
  String get achievementTitle_luxury_provider => 'Dostawca luksusu';

  @override
  String get achievementDescription_luxury_provider =>
      'Ulepsz 3 dzielnice do poziomu VIP';

  @override
  String get achievementTitle_rivalry_victor => 'Wiktor Rywalizacja';

  @override
  String get achievementDescription_rivalry_victor =>
      'Pomyślnie sabotuj rywali 10 razy';

  @override
  String get achievementTitle_untouchable_rival => 'Nietykalny rywal';

  @override
  String get achievementDescription_untouchable_rival =>
      'Obroń się przed 20 próbami sabotażu';

  @override
  String get achievementTitle_crime_first_blood => 'Zbrodnia Pierwsza Krew';

  @override
  String get achievementDescription_crime_first_blood =>
      'Pomyślnie ukończ swoje pierwsze przestępstwo';

  @override
  String get achievementTitle_crime_hustler => 'Miłośnik kryminałów';

  @override
  String get achievementDescription_crime_hustler =>
      'Pomyślnie wykonaj 5 przestępstw';

  @override
  String get achievementTitle_crime_novice => 'Nowicjusz kryminalny';

  @override
  String get achievementDescription_crime_novice =>
      'Pomyślnie wykonaj 10 przestępstw';

  @override
  String get achievementTitle_crime_operator => 'Operator kryminalny';

  @override
  String get achievementDescription_crime_operator =>
      'Pomyślnie wykonaj 25 przestępstw';

  @override
  String get achievementTitle_crime_wave => 'Fala zbrodni';

  @override
  String get achievementDescription_crime_wave =>
      'Pomyślnie wykonaj 50 przestępstw';

  @override
  String get achievementTitle_crime_mastermind => 'Mistrz zbrodni';

  @override
  String get achievementDescription_crime_mastermind =>
      'Pomyślnie wykonaj 100 przestępstw';

  @override
  String get achievementTitle_the_godfather => 'Ojciec chrzestny';

  @override
  String get achievementDescription_the_godfather =>
      'Wykonaj pomyślnie 250 przestępstw';

  @override
  String get achievementTitle_crime_emperor => 'Cesarz zbrodni';

  @override
  String get achievementDescription_crime_emperor =>
      'Pomyślnie wykonaj 500 przestępstw';

  @override
  String get achievementTitle_crime_legend => 'Legenda kryminału';

  @override
  String get achievementDescription_crime_legend =>
      'Pomyślnie wykonaj 1000 przestępstw';

  @override
  String get achievementTitle_crime_getaway_driver => 'Kierowca ucieczki';

  @override
  String get achievementDescription_crime_getaway_driver =>
      'Pomyślnie wykonaj swoje pierwsze przestępstwo z użyciem pojazdu';

  @override
  String get achievementTitle_crime_armed_and_ready => 'Uzbrojony i gotowy';

  @override
  String get achievementDescription_crime_armed_and_ready =>
      'Pomyślnie ukończ swoje pierwsze przestępstwo wymagające użycia broni';

  @override
  String get achievementTitle_crime_full_loadout => 'Pełne wyposażenie';

  @override
  String get achievementDescription_crime_full_loadout =>
      'Pomyślnie ukończ przestępstwo wymagające pojazdu, broni i narzędzi';

  @override
  String get achievementTitle_crime_completionist => 'Kompletator kryminałów';

  @override
  String get achievementDescription_crime_completionist =>
      'Pomyślnie ukończ każdy rodzaj przestępstwa przynajmniej raz';

  @override
  String get achievementTitle_job_first_shift => 'Pierwsza zmiana';

  @override
  String get achievementDescription_job_first_shift =>
      'Pomyślnie ukończ swoją pierwszą pracę';

  @override
  String get achievementTitle_job_hustler => 'Joba Hustlera';

  @override
  String get achievementDescription_job_hustler => 'Pomyślnie ukończ 5 zadań';

  @override
  String get achievementTitle_job_starter => 'Rozrusznik pracy';

  @override
  String get achievementDescription_job_starter => 'Pomyślnie ukończ 10 zadań';

  @override
  String get achievementTitle_job_operator => 'Operator pracy';

  @override
  String get achievementDescription_job_operator => 'Pomyślnie ukończ 25 zadań';

  @override
  String get achievementTitle_job_grinder => 'Szlifierka pracy';

  @override
  String get achievementDescription_job_grinder => 'Pomyślnie ukończ 50 zadań';

  @override
  String get achievementTitle_job_master => 'Mistrz pracy';

  @override
  String get achievementDescription_job_master => 'Pomyślnie ukończ 100 zadań';

  @override
  String get achievementTitle_job_expert => 'Ekspert pracy';

  @override
  String get achievementDescription_job_expert => 'Pomyślnie ukończ 250 zadań';

  @override
  String get achievementTitle_job_elite => 'Elita pracy';

  @override
  String get achievementDescription_job_elite => 'Pomyślnie ukończ 500 zadań';

  @override
  String get achievementTitle_job_legend => 'Legenda pracy';

  @override
  String get achievementDescription_job_legend => 'Pomyślnie ukończ 1000 zadań';

  @override
  String get achievementTitle_job_completionist => 'Kompletator pracy';

  @override
  String get achievementDescription_job_completionist =>
      'Pomyślnie ukończ każdy rodzaj zadania przynajmniej raz';

  @override
  String get achievementTitle_job_educated_worker => 'Wykształcony pracownik';

  @override
  String get achievementDescription_job_educated_worker =>
      'Wykonaj 1 pracę, która ma wymagania dotyczące wykształcenia';

  @override
  String get achievementTitle_job_certified_hustler => 'Certyfikowany Hustler';

  @override
  String get achievementDescription_job_certified_hustler =>
      'Ukończ 25 zawodów z wymaganiami edukacyjnymi';

  @override
  String get achievementTitle_job_education_completionist =>
      'Osoba kończąca pracę w edukacji';

  @override
  String get achievementDescription_job_education_completionist =>
      'Ukończ każdy rodzaj pracy związany z edukacją co najmniej raz';

  @override
  String get achievementTitle_job_it_specialist => 'Specjalista IT';

  @override
  String get achievementDescription_job_it_specialist =>
      'Ukończ swoją pierwszą zmianę jako Programista';

  @override
  String get achievementTitle_job_lawyer => 'Uliczny prawnik';

  @override
  String get achievementDescription_job_lawyer =>
      'Ukończ swoją pierwszą zmianę jako prawnik';

  @override
  String get achievementTitle_job_doctor => 'Podziemny lekarz';

  @override
  String get achievementDescription_job_doctor =>
      'Ukończ swoją pierwszą zmianę jako lekarz';

  @override
  String get achievementTitle_school_certified => 'Certyfikowany student';

  @override
  String get achievementDescription_school_certified =>
      'Zdobądź 3 certyfikaty szkolne';

  @override
  String get achievementTitle_school_multi_certified => 'Wielocertyfikowany';

  @override
  String get achievementDescription_school_multi_certified =>
      'Zdobądź 6 certyfikatów szkolnych';

  @override
  String get achievementTitle_school_track_specialist => 'Specjalista od torów';

  @override
  String get achievementDescription_school_track_specialist =>
      'Maksymalnie 3 tory szkolne';

  @override
  String get achievementTitle_school_freshman => 'Pierwszoklasista szkoły';

  @override
  String get achievementDescription_school_freshman =>
      'Osiągnij poziom wykształcenia 1';

  @override
  String get achievementTitle_school_scholar => 'Uczony szkolny';

  @override
  String get achievementDescription_school_scholar =>
      'Osiągnij poziom wykształcenia 3';

  @override
  String get achievementTitle_school_graduate => 'Absolwent szkoły';

  @override
  String get achievementDescription_school_graduate =>
      'Osiągnij poziom wykształcenia 5';

  @override
  String get achievementTitle_school_mastermind => 'Akademicki geniusz';

  @override
  String get achievementDescription_school_mastermind =>
      'Osiągnij poziom wykształcenia 10';

  @override
  String get achievementTitle_school_doctorate => 'Doktorat uliczny';

  @override
  String get achievementDescription_school_doctorate =>
      'Osiągnij poziom wykształcenia 20';

  @override
  String get achievementTitle_road_bandit => 'Drogowy bandyta';

  @override
  String get achievementDescription_road_bandit => 'Ukradnij 5 samochodów';

  @override
  String get achievementTitle_grand_theft_fleet => 'Flota Wielkiej Kradzieży';

  @override
  String get achievementDescription_grand_theft_fleet =>
      'Ukradnij 25 samochodów';

  @override
  String get achievementTitle_sea_raider => 'Morski Najeźdźca';

  @override
  String get achievementDescription_sea_raider => 'Ukradnij 3 łodzie';

  @override
  String get achievementTitle_captain_of_smugglers => 'Kapitan przemytników';

  @override
  String get achievementDescription_captain_of_smugglers => 'Ukradnij 12 łodzi';

  @override
  String get achievementTitle_globe_trotter => 'Globowy Kłusak';

  @override
  String get achievementDescription_globe_trotter => 'Ukończ 5 podróży';

  @override
  String get achievementTitle_jet_setter => 'Seter odrzutowy';

  @override
  String get achievementDescription_jet_setter => 'Ukończ 25 podróży';

  @override
  String get achievementTitle_chemist_apprentice => 'Uczeń chemika';

  @override
  String get achievementDescription_chemist_apprentice =>
      'Ukończ 10 produkcji narkotyków';

  @override
  String get achievementTitle_narco_chemist => 'Narcochemik';

  @override
  String get achievementDescription_narco_chemist =>
      'Ukończ 100 produkcji leków';

  @override
  String get achievementTitle_street_merchant => 'Sprzedawca uliczny';

  @override
  String get achievementDescription_street_merchant => 'Wykonaj 25 transakcji';

  @override
  String get achievementTitle_trade_tycoon => 'Potentat handlowy';

  @override
  String get achievementDescription_trade_tycoon => 'Wykonaj 150 transakcji';

  @override
  String get achievementTitle_prostitute_lineup => 'Skład zbudowany';

  @override
  String get achievementDescription_prostitute_lineup =>
      'Zrekrutuj 10 prostytutek';

  @override
  String get achievementTitle_prostitute_network => 'Sieć Uliczna';

  @override
  String get achievementDescription_prostitute_network =>
      'Zrekrutuj 25 prostytutek';

  @override
  String get achievementTitle_prostitute_syndicate => 'Konsorcjum';

  @override
  String get achievementDescription_prostitute_syndicate =>
      'Zrekrutuj 50 prostytutek';

  @override
  String get achievementTitle_prostitute_dynasty => 'Dynastia';

  @override
  String get achievementDescription_prostitute_dynasty =>
      'Zrekrutuj 100 prostytutek';

  @override
  String get achievementTitle_prostitute_empire_250 => 'Imperium 250';

  @override
  String get achievementDescription_prostitute_empire_250 =>
      'Zrekrutuj 250 prostytutek';

  @override
  String get achievementTitle_prostitute_cartel_500 => 'Kartel 500';

  @override
  String get achievementDescription_prostitute_cartel_500 =>
      'Zrekrutuj 500 prostytutek';

  @override
  String get achievementTitle_prostitute_legend_1000 => 'Legenda 1000';

  @override
  String get achievementDescription_prostitute_legend_1000 =>
      'Zrekrutuj 1000 prostytutek';

  @override
  String get achievementTitle_vip_prostitute_level_10 => 'Początkujący VIP-a';

  @override
  String get achievementDescription_vip_prostitute_level_10 =>
      'Osiągnij poziom 3 z prostytutką VIP';

  @override
  String get achievementTitle_vip_prostitute_level_25 => 'Głowa VIP-a';

  @override
  String get achievementDescription_vip_prostitute_level_25 =>
      'Osiągnij poziom 5 z prostytutką VIP';

  @override
  String get achievementTitle_vip_prostitute_level_50 => 'Ikona VIP-a';

  @override
  String get achievementDescription_vip_prostitute_level_50 =>
      'Osiągnij poziom 7 z prostytutką VIP';

  @override
  String get achievementTitle_vip_prostitute_level_100 => 'Legenda VIP-a';

  @override
  String get achievementDescription_vip_prostitute_level_100 =>
      'Osiągnij poziom 10 z prostytutką VIP';

  @override
  String get achievementTitle_nightclub_opening_night => 'Wieczór otwarcia';

  @override
  String get achievementDescription_nightclub_opening_night =>
      'Otwórz swój pierwszy klub nocny';

  @override
  String get achievementTitle_nightclub_headliner => 'Headliner Booker';

  @override
  String get achievementDescription_nightclub_headliner =>
      'Zarezerwuj 10 zmian DJ-skich dla swojego imperium klubu nocnego';

  @override
  String get achievementTitle_nightclub_full_house => 'Pełna sala';

  @override
  String get achievementDescription_nightclub_full_house =>
      'Zwiększ pojemność klubu nocnego do 90%.';

  @override
  String get achievementTitle_nightclub_cash_machine => 'Bankomat';

  @override
  String get achievementDescription_nightclub_cash_machine =>
      'Zarób 250 000 euro całkowitego dochodu z klubu nocnego';

  @override
  String get achievementTitle_nightclub_empire => 'Imperium życia nocnego';

  @override
  String get achievementDescription_nightclub_empire =>
      'Zarób 1 000 000 euro całkowitego dochodu z klubu nocnego';

  @override
  String get achievementTitle_nightclub_staffing_boss => 'Szef kadr';

  @override
  String get achievementDescription_nightclub_staffing_boss =>
      'Prowadź jednocześnie 3 aktywnych członków załogi klubu nocnego';

  @override
  String get achievementTitle_nightclub_vip_room => 'Pokój VIP';

  @override
  String get achievementDescription_nightclub_vip_room =>
      'Przypisz 2 członków załogi VIP do swojego klubu nocnego';

  @override
  String get achievementTitle_nightclub_head_of_security =>
      'Szef Bezpieczeństwa';

  @override
  String get achievementDescription_nightclub_head_of_security =>
      'Zatrudnię ochronę klubu nocnego na 10 zmian';

  @override
  String get achievementTitle_nightclub_podium_finish => 'Finisz na podium';

  @override
  String get achievementDescription_nightclub_podium_finish =>
      'Zajmij miejsce w pierwszej trójce cotygodniowego sezonu klubów nocnych';

  @override
  String get achievementTitle_nightclub_season_champion => 'Mistrz sezonu';

  @override
  String get achievementDescription_nightclub_season_champion =>
      'Wygraj cotygodniowy sezon klubu nocnego';

  @override
  String get nightclubManagementTitle => 'Zarządzanie klubem nocnym';

  @override
  String get nightclubRealtimeStatus => 'Stan w czasie rzeczywistym aktywny';

  @override
  String get nightclubRefresh => 'Odświeżać';

  @override
  String get nightclubEmptyTitle =>
      'Nie znaleziono jeszcze żadnego klubu nocnego';

  @override
  String get nightclubEmptyBody =>
      'Najpierw kup klub nocny w Właściwości, aby aktywować ten system.';

  @override
  String get nightclubLocationTitle => 'Lokalizacja klubu nocnego';

  @override
  String get nightclubSelectVenue => 'Wybierz miejsce';

  @override
  String get nightclubLiveStatistics => 'Statystyki na żywo';

  @override
  String get nightclubKpiCrowd => 'Tłum';

  @override
  String get nightclubKpiVibe => 'Wibracja';

  @override
  String get nightclubKpiToday => 'Dzisiaj';

  @override
  String get nightclubKpiAllTime => 'Wszechczasów';

  @override
  String get nightclubKpiStock => 'Magazyn';

  @override
  String get nightclubKpiDj => 'DJ';

  @override
  String get nightclubKpiThefts => 'Kradzieże';

  @override
  String get nightclubKpiStaff => 'Personel';

  @override
  String get nightclubKpiSalesBoost => 'Zwiększenie sprzedaży';

  @override
  String get nightclubKpiPriceBoost => 'Podwyżka cen';

  @override
  String get nightclubKpiVipBonus => 'Bonus VIP-owski';

  @override
  String get nightclubStatusActive => 'Aktywny';

  @override
  String get nightclubStatusOff => 'Wyłączony';

  @override
  String get nightclubStatusActiveLower => 'aktywny';

  @override
  String get nightclubRevenueTrend => 'Trend przychodów (na żywo)';

  @override
  String get nightclubLeaderboardTitle => 'Najlepsze kluby nocne';

  @override
  String get nightclubLeaderboardCountry => 'Kraj';

  @override
  String get nightclubLeaderboardGlobal => 'Światowy';

  @override
  String get nightclubLeaderboardEmpty =>
      'Brak jeszcze danych o tabeli liderów';

  @override
  String get nightclubLeaderboardRevenue24h => 'Przychód 24h';

  @override
  String get nightclubSeasonProcessing => 'przetwarzanie...';

  @override
  String get nightclubSeasonTitle => 'Cotygodniowy ranking sezonu';

  @override
  String get nightclubSeasonResetIn => 'Zresetuj w';

  @override
  String get nightclubSeasonYourRewards => 'Twoje nagrody sezonowe';

  @override
  String get nightclubSeasonCurrentTop5 => 'Top 5 bieżącego tygodnia';

  @override
  String get nightclubSeasonEmpty => 'Nie ma jeszcze danych o sezonie';

  @override
  String get nightclubSeasonWeekRevenue => 'Tygodniowe przychody';

  @override
  String get nightclubSeasonScore => 'Wynik';

  @override
  String get nightclubSeasonRecentPayouts => 'Ostatnie wypłaty';

  @override
  String get nightclubSeasonNoPayouts => 'Nie ma jeszcze wypłat';

  @override
  String get nightclubSalesTitle => 'Ostatnie wyprzedaże';

  @override
  String get nightclubSalesEmpty => 'Nie ma jeszcze danych o sprzedaży';

  @override
  String get nightclubTheftTitle => 'Dziennik kradzieży';

  @override
  String get nightclubTheftEmpty => 'Nie odnotowano żadnych kradzieży';

  @override
  String get nightclubTheftLoss => 'Strata';

  @override
  String get nightclubStaffTitle => 'Załoga Pimp w klubie';

  @override
  String get nightclubStaffVipExtraActive => '(VIP +2 aktywny)';

  @override
  String nightclubStaffCapacity(String assigned, String cap, String vipSuffix) {
    return 'Pojemność: $assigned/$cap$vipSuffix';
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
    return 'Boost mix: sprzedaż x$sales | cena x$price | klimat x$vibe | bezpieczeństwo x$security | gracz VIP x$vipPlayer | personel VIP x$vipStaff ($vipAssigned)';
  }

  @override
  String get nightclubSelectCrewMember => 'Wybierz członka załogi';

  @override
  String get nightclubAssignShift => 'Przydziel do zmiany w nocnym klubie';

  @override
  String get nightclubTabActive => 'Aktywny';

  @override
  String get nightclubTabHistory => 'Historia';

  @override
  String get nightclubNoCrewAssigned =>
      'Nie przydzielono jeszcze żadnej załogi';

  @override
  String get nightclubCrewBoostDescription =>
      'Zwiększa popyt i marżę w Twoim klubie';

  @override
  String get nightclubRemove => 'Usunąć';

  @override
  String get nightclubNoStaffHistory => 'Nie ma jeszcze historii zatrudnienia';

  @override
  String get nightclubFrom => 'Z';

  @override
  String get nightclubTo => 'Do';

  @override
  String get nightclubRevenueImpact => 'Wpływ na przychody';

  @override
  String get nightclubSalesCountLabel => 'obroty';

  @override
  String get nightclubDjTitle => 'Zatrudnij DJ-a';

  @override
  String get nightclubChooseDj => 'Wybierz DJ-a';

  @override
  String get nightclubShiftLength => 'Długość zmiany';

  @override
  String get nightclubHireDj => 'Zatrudnij DJ-a';

  @override
  String get nightclubSecurityTitle => 'Bezpieczeństwo';

  @override
  String get nightclubChooseSecurity => 'Wybierz bezpieczeństwo';

  @override
  String get nightclubHireSecurity => 'Zatrudnij ochronę';

  @override
  String get nightclubStoreTitle => 'Przechowuj leki';

  @override
  String get nightclubChooseStock => 'Wybierz zapasy';

  @override
  String get nightclubAmountGrams => 'Ilość w gramach';

  @override
  String get nightclubStoreButton => 'Przechowywać w nocnym klubie';

  @override
  String get nightclubHireDjSuccess => 'Zatrudniony DJ';

  @override
  String get nightclubHireSecuritySuccess => 'Zatrudniono ochronę';

  @override
  String get nightclubAssignCrewSuccess => 'Przydzielony członek załogi';

  @override
  String get nightclubRemoveCrewSuccess => 'Członek załogi usunięty';

  @override
  String get nightclubStoreDrugsSuccess => 'Leki przechowywane';

  @override
  String get nightclubSeasonPayoutDialogTitle => 'Otrzymano wypłatę za sezon';

  @override
  String nightclubSeasonPayoutDialogBody(String rank) {
    return 'Twój klub nocny zajął w tym tygodniu pozycję #$rank.';
  }

  @override
  String nightclubSeasonPayoutDialogReward(String amount) {
    return 'Nagroda: $amount';
  }

  @override
  String nightclubSeasonPayoutDialogRevenue(String amount) {
    return 'Tygodniowe przychody: $amount';
  }

  @override
  String nightclubSeasonPayoutDialogLoss(String amount) {
    return 'Strata w wyniku kradzieży: $amount';
  }

  @override
  String get nightclubSeasonPayoutDialogAction => 'Zamknąć';

  @override
  String get nightclubVibeChill => 'Chłod';

  @override
  String get nightclubVibeNormal => 'Normalna';

  @override
  String get nightclubVibeWild => 'Dziki';

  @override
  String get nightclubVibeRaging => 'Wściekły';

  @override
  String get nightclubTheftTypeCustomer => 'Kradzież klienta';

  @override
  String get nightclubTheftTypeEmployee => 'Napad na pracownika';

  @override
  String get nightclubTheftTypeRival => 'Sabotaż rywala';

  @override
  String nightclubErrorLoading(String error) {
    return 'Błąd ładowania klubu nocnego: $error';
  }

  @override
  String get nightclubServiceErrorStats =>
      'Nie udało się wczytać statystyk klubu nocnego';

  @override
  String get nightclubServiceErrorLeaderboard =>
      'Nie udało się załadować tabeli liderów';

  @override
  String get nightclubServiceErrorSeason => 'Nie można wczytać rankingu sezonu';

  @override
  String nightclubErrorWithDetail(String detail) {
    return 'Błąd: $detail';
  }

  @override
  String get nightclubResidentDjContractFailed =>
      'Umowa z rezydentem DJ-em nie powiodła się';

  @override
  String get nightclubScheduleEventFailed =>
      'Nie udało się zaplanować wydarzenia';

  @override
  String get nightclubMarketingUpgradeFailed =>
      'Aktualizacja oprogramowania marketingowego nie powiodła się';

  @override
  String get nightclubUpgradeFailed => 'Aktualizacja nie powiodła się';

  @override
  String get nightclubIncidentResponseFailed =>
      'Reakcja na incydent nie powiodła się';

  @override
  String get nightclubRivalActionFailed => 'Akcja rywala nie powiodła się';

  @override
  String get nightclubSupplierContractFailed =>
      'Umowa z dostawcą nie powiodła się';

  @override
  String get nightclubPromoterFailed => 'Promotor poniósł porażkę';

  @override
  String get nightclubHeatCooldownFailed =>
      'Nie udało się ochłodzić ogrzewania';

  @override
  String get nightclubSmugglingFailed => 'Przemyt się nie powiódł';

  @override
  String get nightclubCounterIntelFailed => 'Kontrwywiad zawiódł';

  @override
  String get nightclubHospitalityStockFailed =>
      'Zasoby hotelarskie nie powiodły się';

  @override
  String get nightclubHospitalityPricingFailed =>
      'Ceny usług hotelarskich nie powiodły się';

  @override
  String nightclubCurrentVisitorsPct(String pct) {
    return 'Obecni odwiedzający: $pct%';
  }

  @override
  String get nightclubCommandDeckTitle => 'Talia dowodzenia klubem nocnym';

  @override
  String get nightclubOpsDeckRevenueToday => 'Przychody dzisiaj';

  @override
  String get nightclubStockValueLabel => 'Wartość zapasów';

  @override
  String get nightclubCrewOccupancy => 'Obłożenie załogi';

  @override
  String get nightclubOperationalRisk => 'Ryzyko operacyjne';

  @override
  String nightclubIncidents24h(String count) {
    return '$count incydentów (24h)';
  }

  @override
  String get nightclubActiveCrewShifts => 'Aktywne zmiany załogi';

  @override
  String get nightclubRecentCrewHistory => 'Najnowsza historia załogi';

  @override
  String get nightclubBadgeVip => 'VIP-a';

  @override
  String get nightclubBadgeStandard => 'STANDARD';

  @override
  String get nightclubActiveDj => 'Aktywny DJ';

  @override
  String get nightclubActiveDjNone => 'Aktywny DJ: brak';

  @override
  String nightclubUntilTime(String time) {
    return 'do $time';
  }

  @override
  String get nightclubActiveSecurity => 'Aktywne bezpieczeństwo';

  @override
  String get nightclubActiveSecurityNone => 'Aktywne zabezpieczenia: brak';

  @override
  String get nightclubNoDjsLoaded =>
      'Nie załadowano żadnych DJ-ów. Odśwież ekran.';

  @override
  String get nightclubNoSecurityLoaded =>
      'Brak załadowanych zabezpieczeń. Odśwież ekran.';

  @override
  String get nightclubCrowdBoost => 'Zwiększenie tłumu';

  @override
  String get nightclubCostPerHour => 'Koszt';

  @override
  String get nightclubReputationLabel => 'Reputacja';

  @override
  String get nightclubSpecialtyLabel => 'Specjalność';

  @override
  String get nightclubTheftReduction => 'Redukcja kradzieży';

  @override
  String get nightclubShiftCost => 'Koszt zmiany';

  @override
  String get nightclubSelectedStock => 'Wybrany';

  @override
  String get nightclubAvailableGrams => 'Dostępny';

  @override
  String get nightclubMaxChip => 'MAKS';

  @override
  String get nightclubStoredInNightclub => 'Przechowywany w nocnym klubie';

  @override
  String nightclubCurrentStockGrams(String grams) {
    return 'Aktualne zapasy: ${grams}g';
  }

  @override
  String get nightclubNoStoredDrugs => 'Nie ma jeszcze przechowywanych leków.';

  @override
  String get nightclubStockZeroSoldOut =>
      'Aktualny stan magazynowy to 0g (wszystko zostało sprzedane).';

  @override
  String nightclubQualityWithValue(String value) {
    return 'Jakość: $value';
  }

  @override
  String nightclubGramsStock(String grams) {
    return '${grams}g zapasów';
  }

  @override
  String get nightclubOperationsLabTitle =>
      'Laboratorium Operacyjne (11 systemów)';

  @override
  String get nightclubSectionResidentDjContract =>
      '1) Umowa z DJ-em-rezydentem';

  @override
  String get nightclubContractDiscount => 'Rabat kontraktowy';

  @override
  String get nightclubContractDuration => 'Czas trwania umowy';

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
  String get nightclubStartResidentContract => 'Rozpocznij umowę rezydenta';

  @override
  String get nightclubSectionEventCalendar =>
      '2) Dynamiczny kalendarz wydarzeń';

  @override
  String get nightclubRecommendedToday => 'Polecane dzisiaj';

  @override
  String get nightclubEventTemplate => 'Szablon wydarzenia';

  @override
  String get nightclubScheduleEventFiveMin => 'Zaplanuj wydarzenie (+5 min)';

  @override
  String get nightclubUpcomingEvents => 'Nadchodzące wydarzenia';

  @override
  String get nightclubSectionUpgradeTree => '3) Drzewo ulepszeń';

  @override
  String get nightclubUpgradeSoundRig => 'Zestaw dźwiękowy';

  @override
  String get nightclubUpgradeVipLounge => 'Salon VIP';

  @override
  String get nightclubUpgradeSurveillance => 'Nadzór';

  @override
  String nightclubUpgradeWithCost(String name, String cost) {
    return '$name ($cost)';
  }

  @override
  String get nightclubChooseUpgrade => 'Wybierz aktualizację';

  @override
  String get nightclubUpgradeAlreadyMaxMessage =>
      'To ulepszenie ma już maksymalny poziom.';

  @override
  String get nightclubUpgradeAlreadyMaxed => 'Aktualizacja już maksymalna';

  @override
  String get nightclubUpgradeNow => 'Uaktualnij teraz';

  @override
  String get nightclubMarketingInvestment => 'Inwestycja marketingowa';

  @override
  String get nightclubInvestMarketing => 'Inwestuj w marketing';

  @override
  String get nightclubSectionPoliceHeat => '4) Policyjne upały i incydenty';

  @override
  String get nightclubHeatLabel => 'Ciepło';

  @override
  String get nightclubRaidRisk => 'Ryzyko napadu';

  @override
  String get nightclubCooldownLabel => 'Czas odnowienia';

  @override
  String get nightclubStartHeatCooldown => 'Rozpocznij schładzanie ciepła';

  @override
  String get nightclubBribe => 'Przekupić';

  @override
  String get nightclubLockdown => 'Izolacja';

  @override
  String get nightclubCounterIntelShort => 'Kontrwywiad';

  @override
  String get nightclubSectionStaffMorale => '5) Zmęczenie i morale personelu';

  @override
  String get nightclubMorale => 'Morale';

  @override
  String get nightclubFatigue => 'Zmęczenie';

  @override
  String get nightclubStaffing => 'Personel';

  @override
  String get nightclubSectionSupplierPromoter => '6) Dostawca i promotor';

  @override
  String get nightclubSupplierContract => 'Umowa dostawcy';

  @override
  String get nightclubActivateSupplier => 'Aktywuj dostawcę';

  @override
  String get nightclubPromoterProfile => 'Profil promotora';

  @override
  String get nightclubHirePromoter => 'Zatrudnij promotora';

  @override
  String get nightclubSectionVipClientele =>
      '7) Cechy klientów VIP i personelu';

  @override
  String get nightclubVipShare => 'Udział VIP-a';

  @override
  String get nightclubSpendMultiplier => 'Wydaj x';

  @override
  String get nightclubTier => 'Szczebel';

  @override
  String get nightclubSectionSmugglingRoutes => '8) Szlaki przemytu';

  @override
  String get nightclubReady => 'Gotowy';

  @override
  String get nightclubRoute => 'Trasa';

  @override
  String get nightclubStartRoute => 'Rozpocznij trasę';

  @override
  String get nightclubLastRoute => 'Ostatnia trasa';

  @override
  String nightclubRouteLockUntil(String date) {
    return 'Blokada trasy aktywna do $date';
  }

  @override
  String get nightclubSectionBarKitchen => '9) Zarządzanie barem i kuchnią';

  @override
  String get nightclubServiceLevel => 'Poziom usług';

  @override
  String get nightclubStockStatus => 'Stan zapasów';

  @override
  String get nightclubSpoilageRisk => 'Ryzyko zepsucia';

  @override
  String get nightclubDrinksFoodStock => 'Zapasy napojów/żywności';

  @override
  String get nightclubBuyStock => 'Kup akcje';

  @override
  String get nightclubMenuPricingMode => 'Tryb cenowy menu';

  @override
  String get nightclubApplyPricing => 'Zastosuj ceny';

  @override
  String get nightclubSectionRivals => '10) Wrogie kluby + kontrwywiad';

  @override
  String get nightclubSearchPlayerName => 'Wyszukaj nazwę gracza';

  @override
  String get nightclubTargetName => 'Cel (nazwa)';

  @override
  String nightclubRivalCrowdLine(String name, String country, String pct) {
    return '$name • $country • tłum $pct%';
  }

  @override
  String get nightclubSabotage => 'Sabotaż';

  @override
  String get nightclubPromoWar => 'Wojna promocyjna';

  @override
  String get nightclubCounterIntelSweep => 'Akcja kontrwywiadowcza';

  @override
  String get nightclubMitigation => 'Łagodzenie';

  @override
  String get nightclubSectionTimeline => '11) Harmonogram operacji';

  @override
  String get nightclubNoTimelineEvents => 'Brak wydarzeń na osi czasu.';

  @override
  String get nightclubOperationsAlerts => 'Alerty operacyjne';

  @override
  String get nightclubNoCriticalAlerts => 'Brak krytycznych alertów.';

  @override
  String get nightclubQuickAction => 'Szybka akcja';

  @override
  String get nightclubMgmtCrewTitle => 'Crew i zmiany';

  @override
  String get nightclubMgmtCrewSubtitle =>
      'Personel, wydajność i historia zmian.';

  @override
  String get nightclubMgmtDrugsTitle => 'Przechowywanie leków';

  @override
  String get nightclubMgmtDrugsSubtitle =>
      'Zarządzaj i przesyłaj zapasy w gramach.';

  @override
  String get nightclubMgmtDjTitle => 'Komenda DJ-a';

  @override
  String get nightclubMgmtDjSubtitle =>
      'Wybierz DJ-a, długość zmiany i wzmocnienie tłumu na żywo.';

  @override
  String get nightclubMgmtSecurityTitle => 'Jednostka bezpieczeństwa';

  @override
  String get nightclubMgmtSecuritySubtitle =>
      'Redukcja kradzieży, kosztów i aktywne bezpieczeństwo.';

  @override
  String get nightclubMgmtOpsLabTitle => 'Laboratorium operacyjne';

  @override
  String nightclubMgmtOpsLabSubtitleAlert(String alerts, String smuggling) {
    return 'Alerty na żywo: $alerts | Przemyt: $smuggling';
  }

  @override
  String get nightclubMgmtOpsLabSubtitleDefault =>
      '11 systemów dla wydarzeń, ulepszeń, tras i rywali.';

  @override
  String get nightclubManagementPanelTitle => 'Zarządzanie klubem nocnym';

  @override
  String get nightclubChooseZoneHint =>
      'Wybierz strefę zarządzania i kontroluj wszystko bez zagnieżdżonego przewijania wewnętrznego.';

  @override
  String get nightclubChipCrew => 'Załoga';

  @override
  String get nightclubChipStorage => 'Składowanie';

  @override
  String get nightclubChipDjShift => 'Zmiana DJ-a';

  @override
  String get nightclubChipSecurity => 'Bezpieczeństwo';

  @override
  String get nightclubChipOpsAlerts => 'Alerty operacyjne';

  @override
  String get nightclubNone => 'Nic';

  @override
  String get nightclubIntelligenceCardTitle => 'Inteligencja klubu nocnego';

  @override
  String get nightclubSeasonStatus => 'Stan sezonu';

  @override
  String nightclubSeasonCountdown(String days, String hours, String minutes) {
    return '${days}d ${hours}h ${minutes}m';
  }

  @override
  String nightclubShiftHours(String hours) {
    return '$hours godz';
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
  String get theftCooldownRedeemTitle => 'Pominąć czas odnowienia kradzieży?';

  @override
  String theftCooldownRedeemMessage(int cost, int balance) {
    return 'Wydać teraz $cost kredytów, aby wyczyścić czas odnowienia kradzieży pojazdu? Twoje saldo: $balance.';
  }

  @override
  String get theftCooldownRedeemDontShowAgain =>
      'Nie pokazuj więcej tego potwierdzenia';

  @override
  String theftCooldownRedeemConfirmAction(int credits) {
    return 'Użyj $credits kredytów';
  }

  @override
  String get theftCooldownRedeemNotAvailable =>
      'Przyspieszenie kredytu nie jest obecnie dostępne dla tego czasu odnowienia.';

  @override
  String get theftCooldownRedeemNoActiveCooldown =>
      'Brak aktywnego czasu odnowienia kradzieży do zresetowania.';

  @override
  String get theftCooldownRedeemInsufficientCredits => 'Za mało kredytów.';

  @override
  String get theftCooldownRedeemFailed =>
      'Nie można zastosować kredytów do czasu odnowienia.';

  @override
  String get theftCooldownRedeemSuccess => 'Czas odnowienia został usunięty.';

  @override
  String get settingsTheftCooldownConfirmTitle =>
      'Czas odnowienia kradzieży (kredyty)';

  @override
  String get settingsTheftCooldownConfirmSubtitle =>
      'Poproś o potwierdzenie przed wydaniem kredytów, aby pominąć czas odnowienia kradzieży pojazdu. Wyłącz, aby zrealizować jednym dotknięciem (ikona błyskawicy obok minutnika).';

  @override
  String get supportTicketsScreenTitle => 'Bilety wsparcia';

  @override
  String get supportLoadTicketsFailed => 'Nie udało się załadować biletów';

  @override
  String get supportLoadTicketFailed => 'Nie udało się załadować biletu';

  @override
  String get supportPickImageFailed => 'Nie udało się wybrać obrazu';

  @override
  String get supportSubjectMessageMinLength =>
      'Wpisz temat i wiadomość (min. 3 znaki).';

  @override
  String get supportTicketCreated => 'Utworzono bilet.';

  @override
  String get supportCreateTicketFailed => 'Nie udało się utworzyć biletu';

  @override
  String get supportReplySent => 'Odpowiedź wysłana.';

  @override
  String get supportReplySendFailed => 'Nie udało się wysłać odpowiedzi';

  @override
  String get supportDeleteTicketTitle => 'Usuń bilet';

  @override
  String get supportDeleteTicketBody =>
      'Czy na pewno chcesz usunąć ten bilet? Tej akcji nie można cofnąć.';

  @override
  String get supportTicketDeleted => 'Bilet został usunięty.';

  @override
  String get supportDeleteTicketFailed => 'Nie udało się usunąć biletu';

  @override
  String get supportUnknownError => 'Nieznany błąd';

  @override
  String get supportStatusNew => 'Nowy';

  @override
  String get supportStatusTriage => 'Ocena stanu zdrowia rannych';

  @override
  String get supportStatusInProgress => 'W toku';

  @override
  String get supportStatusWaitingPlayer => 'Czekam na gracza';

  @override
  String get supportStatusBlocked => 'Zablokowany';

  @override
  String get supportStatusResolved => 'Rozwiązany';

  @override
  String get supportStatusClosed => 'Zamknięte';

  @override
  String get supportStatusArchived => 'Zarchiwizowane';

  @override
  String get supportCategoryBug => 'Błąd';

  @override
  String get supportCategoryQuestion => 'Pytanie';

  @override
  String get supportCategoryFeedback => 'Informacja zwrotna';

  @override
  String get supportCategoryOther => 'Inny';

  @override
  String get supportPriorityLow => 'Niski';

  @override
  String get supportPriorityHigh => 'Wysoki';

  @override
  String get supportPriorityUrgent => 'Pilny';

  @override
  String get supportPriorityNormal => 'Normalna';

  @override
  String supportTimeDaysAgo(int count) {
    return '${count}d temu';
  }

  @override
  String supportTimeHoursAgo(int count) {
    return '${count}h temu';
  }

  @override
  String supportTimeMinutesAgo(int count) {
    return '$count m temu';
  }

  @override
  String get supportTimeJustNow => 'właśnie';

  @override
  String get supportSenderSupport => 'Wsparcie';

  @override
  String get supportSenderYou => 'Ty';

  @override
  String get supportImageLoadFailed => 'Nie udało się załadować obrazu.';

  @override
  String get supportMyTickets => 'Moje bilety';

  @override
  String supportTicketsCountInList(String count) {
    return '$count';
  }

  @override
  String get supportMyTicketsIntro =>
      'Wsparcie odpowiada teraz bezpośrednio na tym ekranie. Nadal możesz opcjonalnie otrzymać powiadomienie push, gdy Twój bilet zostanie zaktualizowany.';

  @override
  String get supportNoTicketsYet =>
      'Nie masz jeszcze żadnych biletów. Utwórz nowy raport poniżej.';

  @override
  String get supportSelectTicketPrompt =>
      'Wybierz zgłoszenie, aby otworzyć rozmowę.';

  @override
  String get supportConversation => 'Rozmowa';

  @override
  String get supportNoMessagesYet => 'Nie ma jeszcze żadnych wiadomości.';

  @override
  String get supportAttachments => 'Załączniki';

  @override
  String get supportReplyToTicket => 'Odpowiedz na to zgłoszenie';

  @override
  String get supportReplyFieldHint =>
      'Użyj tego pola, gdy wsparcie poprosi o więcej informacji lub gdy chcesz udostępnić aktualizację. Skrzynka odbiorcza i push pozostają kanałami powiadomień o nowych odpowiedziach pomocy technicznej.';

  @override
  String get supportYourReply => 'Twoja odpowiedź';

  @override
  String get supportSendReply => 'Wyślij odpowiedź';

  @override
  String get supportNewTicket => 'Nowy bilet';

  @override
  String get supportNewTicketIntro =>
      'Utwórz tutaj nowy raport. Zespół pomocy może następnie odpowiedzieć za pośrednictwem skrzynki odbiorczej/push i na tym ekranie, dzięki czemu możesz kontynuować rozmowę w jednym miejscu.';

  @override
  String get supportTicketReceivedBanner => 'Otrzymano bilet';

  @override
  String supportTicketNumberLine(int id) {
    return 'Numer biletu: #$id';
  }

  @override
  String get supportTicketReceivedDetail =>
      'Bilet pojawi się teraz bezpośrednio na liście powyżej. Nowe odpowiedzi pomocy technicznej pojawiają się także w postaci wiadomości w skrzynce odbiorczej i powiadomień push.';

  @override
  String get supportFieldCategory => 'Kategoria';

  @override
  String get supportFieldModule => 'Moduł';

  @override
  String get supportFieldSubject => 'Temat';

  @override
  String get supportFieldMessage => 'Wiadomość';

  @override
  String get supportReferenceOptional => 'Odniesienie (opcjonalnie)';

  @override
  String get supportReferenceHint =>
      'Na przykład identyfikator zamówienia, nazwa ekranowa, kraj lub krótki kontekst';

  @override
  String get supportAddScreenshot => 'Dodaj zrzut ekranu';

  @override
  String get supportSubmit => 'Składać';

  @override
  String get supportLastMessagePrefix => 'Ostatni:';

  @override
  String get supportReferenceLabel => 'Odniesienie';

  @override
  String get supportMod_support => 'Ogólne wsparcie';

  @override
  String get supportMod_dashboard => 'Panel';

  @override
  String get supportMod_messages => 'Wiadomości / skrzynka odbiorcza';

  @override
  String get supportMod_notifications => 'Powiadomienia / push';

  @override
  String get supportMod_payments => 'Płatności / składki';

  @override
  String get supportMod_bank => 'Bank';

  @override
  String get supportMod_crypto => 'Krypto';

  @override
  String get supportMod_travel => 'Podróż';

  @override
  String get supportMod_properties => 'Właściwości';

  @override
  String get supportMod_inventory => 'Zapasy / magazynowanie';

  @override
  String get supportMod_loadouts => 'Ładunki / wyposażenie';

  @override
  String get supportMod_crimes => 'Zbrodnie';

  @override
  String get supportMod_jobs => 'Praca/praca';

  @override
  String get supportMod_vehicles => 'Kradzież samochodu / roweru / łodzi';

  @override
  String get supportMod_garage => 'Garaż';

  @override
  String get supportMod_marina => 'Marina';

  @override
  String get supportMod_aviation => 'Lotnictwo';

  @override
  String get supportMod_smuggling => 'Przemyt';

  @override
  String get supportMod_drugs => 'Narkotyki';

  @override
  String get supportMod_nightclub => 'Klub nocny';

  @override
  String get supportMod_prostitution => 'Prostytucja';

  @override
  String get supportMod_crew => 'Załoga';

  @override
  String get supportMod_friends => 'Przyjaciele / gracze';

  @override
  String get supportMod_hitlist => 'Lista hitów';

  @override
  String get supportMod_security => 'Bezpieczeństwo / FBI';

  @override
  String get supportMod_prison => 'Więzienie / sąd';

  @override
  String get supportMod_casino => 'Kasyno';

  @override
  String get supportMod_school => 'Szkoła / szkolenie';

  @override
  String get supportMod_achievements => 'Osiągnięcia';

  @override
  String get supportMod_profile => 'Profil';

  @override
  String get supportMod_settings => 'Ustawienia';

  @override
  String get supportMod_events => 'Wydarzenia / tabela wyników';

  @override
  String get supportMod_other => 'Inny';

  @override
  String get gameEventDefaultTitle => 'Wydarzenie';

  @override
  String get gameEventStatusActive => 'Aktywny';

  @override
  String get gameEventStatusScheduled => 'Zaplanowany';

  @override
  String get gameEventStatusCompleted => 'Zakończony';

  @override
  String get gameEventStatusDraft => 'Projekt';

  @override
  String get gameEventTmplWeeklyVehicleTheftHuntTitle =>
      'Cotygodniowe polowanie na kradzieże';

  @override
  String get gameEventTmplWeeklyVehicleTheftHuntDesc =>
      'Ukradnij jak najwięcej pojazdów w oknie wydarzenia.';

  @override
  String get gameEventTmplSmugglingSurgeTitle => 'Fala przemytu';

  @override
  String get gameEventTmplSmugglingSurgeDesc =>
      'Przenieś w tej rundzie najczęściej przemycaną kontrabandę.';

  @override
  String get gameEventTmplLabOutputChallengeTitle =>
      'Wyzwanie dotyczące wyników laboratorium';

  @override
  String get gameEventTmplLabOutputChallengeDesc =>
      'Wytwórz jak najwięcej wyników podczas trwania wydarzenia.';

  @override
  String get gameEventTmplStreetCrimeSpreeTitle =>
      'Uliczny szał przestępczości';

  @override
  String get gameEventTmplStreetCrimeSpreeDesc =>
      'Dokonaj jak największej liczby przestępstw w oknie na żywo.';

  @override
  String get gameScreenLoadError => 'Nie udało się wczytać wydarzeń.';

  @override
  String get gameScreenDetailsLoadError =>
      'Nie udało się wczytać szczegółów wydarzenia.';

  @override
  String get gameScreenSectionLive => 'Wydarzenia na żywo';

  @override
  String get gameScreenNoActive =>
      'W tej chwili nie ma żadnych aktywnych wydarzeń.';

  @override
  String get gameScreenSectionUpcoming => 'Nadchodzące wydarzenia';

  @override
  String get gameScreenNoUpcoming => 'Brak zaplanowanych wydarzeń.';

  @override
  String gameScreenStatusPrefix(String value) {
    return 'Stan: $value';
  }

  @override
  String gameScreenStartLine(String date) {
    return 'Początek: $date';
  }

  @override
  String gameScreenEndLine(String date) {
    return 'Koniec: $date';
  }

  @override
  String get gameScreenYourProgress => 'Twój postęp';

  @override
  String gameScreenScore(String value) {
    return 'Wynik: $value';
  }

  @override
  String gameScreenRank(String value) {
    return 'Ranga: $value';
  }

  @override
  String get gameScreenLeaderboard => 'Tabela liderów (top 10)';

  @override
  String get gameScreenNoLeaderboard => 'Brak jeszcze danych o tabeli liderów.';

  @override
  String get gameScreenUnknownPlayer => 'Nieznany';

  @override
  String get gameScreenDash => '—';

  @override
  String get gameCardActive => 'Aktywny';

  @override
  String get gameCardScheduled => 'Planowany';

  @override
  String gameCardYourScore(String value) {
    return 'Twój wynik: $value';
  }

  @override
  String gameCardYourRank(String value) {
    return 'Twoja ranga: $value';
  }

  @override
  String get gameCardTapDetails =>
      'Kliknij, aby wyświetlić szczegóły i tabelę wyników';

  @override
  String get eventFeedDisconnected => 'Odłączono od strumienia zdarzeń';

  @override
  String get eventFeedReconnecting => 'Ponowne łączenie...';

  @override
  String get eventFeedConnectedWaiting => 'Połączono — czekam na wydarzenia…';

  @override
  String get eventFeedConnecting => 'Łączę ze strumieniem wydarzeń…';

  @override
  String get evStreamConnectionEstablished =>
      'Połączono ze strumieniem zdarzeń';

  @override
  String get evStreamAuthRegistered => 'Konto utworzone pomyślnie.';

  @override
  String get evStreamAuthLogin => 'Witamy z powrotem.';

  @override
  String evStreamCrimeSuccess(
    String crimeName,
    String reward,
    String xpGained,
  ) {
    return 'Pomyślnie ukończono $crimeName! +EUR $reward, +$xpGained PD';
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
      other: '$minutes minut',
      many: '$minutes minut',
      few: '$minutes minuty',
      one: '1 minuta',
    );
    return 'Ukończono $crimeName! +$reward EUR, +$xpGained PD — złapany! Wyrok: $_temp0.';
  }

  @override
  String get evStreamCrimeSeizedVehicle =>
      'Twój pojazd został zatrzymany przez policję.';

  @override
  String get evStreamCrimeSeizedWeapon =>
      'Twoja broń została skonfiskowana przez policję.';

  @override
  String evStreamCrimeSuccessCleared(
    String crimeName,
    int count,
    String xpGained,
  ) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count wyroki skazujące',
      one: '1 conviction',
    );
    return 'Pomyślnie ukończono $crimeName! Rejestr karny oczyszczony: usunięto $_temp0. +$xpGained PD';
  }

  @override
  String evStreamCrimeFailedArrested(String authority, String crimeName) {
    return 'Zatrzymany przez $authority podczas próby $crimeName.';
  }

  @override
  String evStreamCrimeFailedJailed(String crimeName, int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minut',
      many: '$minutes minut',
      few: '$minutes minuty',
      one: '1 minuta',
    );
    return 'Złapany podczas $crimeName! Wyrok: $_temp0.';
  }

  @override
  String evStreamCrimeFailedBase(String crimeName) {
    return 'Nie udało się ukończyć $crimeName';
  }

  @override
  String evStreamChaseDamage(String pct) {
    return 'Twój pojazd odniósł $pct% uszkodzeń podczas pościgu.';
  }

  @override
  String evStreamCrimeJailed(String crimeName, int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minut',
      many: '$minutes minut',
      few: '$minutes minuty',
      one: '1 minuta',
    );
    return 'Złapany podczas $crimeName! Wyrok: $_temp0.';
  }

  @override
  String evStreamJobSuccess(String jobName, String earnings, String xpGained) {
    return 'Ukończono pracę jako $jobName! +€$earnings, +$xpGained PD';
  }

  @override
  String evStreamJobSuccessEdu(String pct) {
    return '(Premia edukacyjna +$pct%)';
  }

  @override
  String evStreamJobFailedXp(String jobName, String xpLost) {
    return 'Nie udało się ukończyć zadania jako $jobName. −$xpLost PD';
  }

  @override
  String evStreamJobFailed(String jobName) {
    return 'Nie udało się ukończyć zadania jako $jobName';
  }

  @override
  String get evStreamJobErrorInvalid => 'Nieprawidłowa praca';

  @override
  String get evStreamJobErrorLevel =>
      'Twoja ranga jest zbyt niska dla tej pracy';

  @override
  String evStreamJobErrorCooldown(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'jeszcze $minutes minut',
      many: 'jeszcze $minutes minut',
      few: 'jeszcze $minutes minuty',
      one: 'jeszcze 1 minutę',
    );
    return 'Ta praca ma cooldown. Czekaj $_temp0';
  }

  @override
  String evStreamJobErrorGeneric(String reason) {
    return 'Błąd zadania: $reason';
  }

  @override
  String evStreamTravelDeparted(String dest, String cost) {
    return 'Lecę do $dest… −€$cost';
  }

  @override
  String evStreamTravelArrived(String country) {
    return 'Przybył w $country.';
  }

  @override
  String evStreamBankDeposit(String amount) {
    return 'Wpłacił $amount € do banku';
  }

  @override
  String evStreamBankWithdraw(String amount) {
    return 'Wypłacił z banku $amount €';
  }

  @override
  String evStreamCryptoBuy(String quantity, String symbol, String total) {
    return 'Kupiłem $quantity $symbol za $total €';
  }

  @override
  String evStreamCryptoSell(
    String quantity,
    String symbol,
    String total,
    String pnl,
  ) {
    return 'Sprzedano $quantity $symbol za $total € (zysk i straty $pnl €)';
  }

  @override
  String evStreamCryptoAlert(String symbol, String price, String chg) {
    return '$symbol alert: $price € ($chg% 24h)';
  }

  @override
  String evStreamCryptoOrderFilled(
    String order,
    String side,
    String quantity,
    String symbol,
    String price,
  ) {
    return '$order $side wypełnione: $quantity $symbol przy cenie $price';
  }

  @override
  String evStreamCryptoOrderTriggered(
    String trig,
    String symbol,
    String price,
  ) {
    return '$trig aktywowane za $symbol przy cenie $price';
  }

  @override
  String evStreamCryptoRegime(String regime, String move) {
    return 'Reżim rynkowy zmieniony na $regime ($move% 24h)';
  }

  @override
  String evStreamCryptoNews(String sentiment, String headline) {
    return '$sentiment aktualności: $headline';
  }

  @override
  String evStreamCryptoMissionDaily(String title, String reward) {
    return 'Ukończenie misji dziennej: $title (+ $reward EUR)';
  }

  @override
  String evStreamCryptoMissionWeekly(String title, String reward) {
    return 'Tygodniowe ukończenie misji: $title (+EUR $reward)';
  }

  @override
  String evStreamCryptoLeaderboard(String rank, String reward) {
    return 'Nagroda za ranking kryptowalut: #$rank (+EUR $reward)';
  }

  @override
  String get evStreamRegimeBull => 'zwyżkowy';

  @override
  String get evStreamRegimeBear => 'niedźwiedzi';

  @override
  String get evStreamRegimeSideways => 'bokiem';

  @override
  String get evStreamImpactBull => 'Zwyżkowy';

  @override
  String get evStreamImpactBear => 'Niedźwiedzi';

  @override
  String get evStreamImpactNeutral => 'Neutralny';

  @override
  String evStreamPropertyBought(String name, String cost) {
    return 'Kupiono $name za $cost €';
  }

  @override
  String evStreamCrewCreated(String name) {
    return 'Utworzona Crew: $name';
  }

  @override
  String evStreamCrewJoined(String name) {
    return 'Dołączył do załogi: $name';
  }

  @override
  String evStreamCrewWarDeclared(String a, String b, String type) {
    return 'Wypowiedzona wojna załogi: #$a kontra #$b ($type)';
  }

  @override
  String evStreamCrewWarStarted(String a, String b) {
    return 'Rozpoczęła się wojna załóg: #$a kontra #$b';
  }

  @override
  String evStreamCrewLockdown(String id) {
    return 'Wojna załogowa #$id jest zamknięta';
  }

  @override
  String evStreamCrewResolved(String id, String winner) {
    return 'Wojna załogi nr $id rozwiązana. Zwycięzca: Crew #$winner';
  }

  @override
  String evStreamCrewAction(String action, String points) {
    return 'Akcja wojenna załogi: $action (+$points pkt)';
  }

  @override
  String evStreamHeistOk(String name, String money) {
    return 'Napad „$name” udany! +€$money';
  }

  @override
  String evStreamHeistFail(String name) {
    return 'Napad „$name” nie powiódł się.';
  }

  @override
  String evStreamHospital(String hp, String cost) {
    return 'Leczony w szpitalu! +$hp zdrowia, −€$cost';
  }

  @override
  String evStreamPoliceArrested(String mins) {
    return 'Aresztowany! Uwięziony na $mins minut';
  }

  @override
  String get evStreamPoliceEscaped => 'Uciekłeś policji.';

  @override
  String get evStreamFbiRaid => 'Nalot FBI! Straciłeś majątek i pieniądze.';

  @override
  String get evStreamErrInsufficientFunds => 'Za mało pieniędzy';

  @override
  String get evStreamErrInsufficientHealth => 'Za mało zdrowia na tę akcję';

  @override
  String evStreamErrInsufficientRank(String rank) {
    return 'Wymaga rangi $rank';
  }

  @override
  String evStreamErrJailed(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minut',
      many: '$minutes minut',
      few: '$minutes minuty',
      one: '1 minutę',
    );
    return 'Jesteś w więzieniu jeszcze $_temp0';
  }

  @override
  String get evStreamErrNoHealthDefault => 'Musisz odpocząć i odzyskać zdrowie';

  @override
  String evStreamErrCooldown(int seconds) {
    String _temp0 = intl.Intl.pluralLogic(
      seconds,
      locale: localeName,
      other: '$seconds sekund',
      many: '$seconds sekund',
      few: '$seconds sekundy',
      one: '1 sekundę',
    );
    return 'Poczekaj $_temp0, zanim spróbujesz ponownie';
  }

  @override
  String get evStreamErrRescuerJailed =>
      'Będąc w więzieniu, nie możesz pomagać innym';

  @override
  String get evStreamErrTargetNotJailed => 'Ten gracz nie przebywa w więzieniu';

  @override
  String get evStreamErrCannotRescueSelf => 'Nie możesz się uwolnić';

  @override
  String get evStreamJailbreakOk => 'Pomyślny jailbreak! Gracz jest wolny.';

  @override
  String get evStreamJailbreakFail =>
      'Nie udało się jailbreakować! Gracz nadal przebywa w więzieniu.';

  @override
  String evStreamJailbreakCaught(String mins) {
    return 'Nie udało się jailbreakować! Zostałeś złapany i osadzony w więzieniu na $mins minut.';
  }

  @override
  String evStreamBailPaid(String amount) {
    return 'Zapłacona kaucja: $amount €. Jesteś wolny.';
  }

  @override
  String get evStreamErrInternal => 'Coś poszło nie tak. Spróbuj ponownie.';

  @override
  String evStreamTest(String msg) {
    return 'Test: $msg';
  }

  @override
  String get evStreamNoCriminalRecord =>
      'Nie masz żadnej karalności do oczyszczenia';

  @override
  String get evStreamWeaponSelectRequired =>
      'Wybierz broń przestępstwa przed popełnieniem tego przestępstwa';

  @override
  String evStreamWeaponNotSuitable(String types) {
    return 'Potrzebujesz odpowiedniej broni: $types';
  }

  @override
  String get evStreamJobFallbackName => 'stanowisko';

  @override
  String evStreamUnknownKey(String key) {
    return '$key';
  }

  @override
  String get connectionErrorGeneric => 'Błąd połączenia';

  @override
  String get crimeWeaponSectionTitle => 'Broń zbrodni';

  @override
  String get crimeWeaponInstruction =>
      'Wybierz, której broni używasz domyślnie w przypadku przestępstw, które jej wymagają.';

  @override
  String get crimeWeaponEmptyInventoryHelp =>
      'Najpierw kup lub przenieś użyteczną broń do swojego ekwipunku.';

  @override
  String get crimeWeaponSelectHint => 'Wybierz broń do zbrodni';

  @override
  String get crimeWeaponNoSelectionNote =>
      'Bez selekcji przestępstwa z użyciem broni nie zostaną rozpoczęte.';

  @override
  String crimeWeaponSelectedStatus(String weaponLine) {
    return 'Wybrano: $weaponLine. Niektóre przestępstwa nadal wymagają dodatkowo odpowiedniego rodzaju broni.';
  }

  @override
  String get crimeSetWeaponFailed => 'Nie udało się ustawić broni zbrodni.';

  @override
  String get crimeChooseWeaponBeforeCommit =>
      'Wybierz broń zbrodni na górze tego ekranu lub najpierw w Inwentarzu.';

  @override
  String get crimeWeaponFooterNote =>
      'Przestępstwa z użyciem broni wykorzystują wybraną powyżej broń przestępczą.';

  @override
  String crimeTrainingBonusStrip(String strengthPct, String accuracyPct) {
    return 'Training bonuses on success chance: +$strengthPct% strength, +$accuracyPct% accuracy.';
  }

  @override
  String crimeTrainingComboStrip(String pct) {
    return 'Kombinacja tego samego dnia (siłownia + strzelnica, kalendarz UTC): +$pct% dodatkowej szansy na powodzenie przestępstwa.';
  }

  @override
  String get crimeCriminalRecordWipeDesc =>
      'Sfałszuj akta sądowe i wyczyść całą kartotekę karną, jeśli operacja się powiedzie.';

  @override
  String crimeCardSuccessChance(int percent) {
    return '$percent% szans na sukces';
  }

  @override
  String crimeRequirementDrugsFull(
    String drugsRequired,
    String quantity,
    String names,
  ) {
    return '💊 $drugsRequired (min ${quantity}g): $names';
  }

  @override
  String get crimeCommitUnexpectedError =>
      'Coś poszło nie tak. Spróbuj ponownie.';

  @override
  String get cooldownTimeLeft => 'Pozostał czas';

  @override
  String get cooldownMustWaitExplanation =>
      'Musisz poczekać, zanim będziesz mógł ponownie wykonać tę akcję.';

  @override
  String get cooldownAlreadyFinished => 'Ochłodzenie już się skończyło.';

  @override
  String get cooldownNotEnoughCredits => 'Za mało kredytów.';

  @override
  String get cooldownNoActiveToReset =>
      'Brak aktywnego czasu odnowienia do zresetowania.';

  @override
  String get cooldownNotAvailableNow => 'Niedostępne w tej chwili.';

  @override
  String get cooldownRedeemFailed =>
      'Nie udało się przyspieszyć za pomocą kredytów.';

  @override
  String get cooldownFinishedInstantly => 'Cooldown zakończył się natychmiast.';

  @override
  String cooldownSpeedUpNow(int cost) {
    return 'Przyspiesz teraz (-$cost kredytów)';
  }

  @override
  String cooldownCreditBalanceLine(int balance) {
    return 'Saldo: $balance kredytów';
  }

  @override
  String get cooldownLoadingCreditOptions => 'Ładowanie opcji kredytowych…';

  @override
  String get cooldownWaitCrime => 'Upał jest zbyt wysoki…';

  @override
  String get cooldownWaitJob =>
      'Odpocznij, zanim będziesz mógł ponownie pracować';

  @override
  String get cooldownWaitTravel => 'Następny lot odlatuje za';

  @override
  String get cooldownWaitHeist => 'Planowanie napadu…';

  @override
  String get cooldownWaitAppeal => 'Sąd jest zajęty…';

  @override
  String get cooldownWaitSchool => 'Złap oddech przed kolejną lekcją…';

  @override
  String get cooldownWaitDefault => 'Proszę czekać…';

  @override
  String get weaponLabelKnife => 'Nóż';

  @override
  String get weaponLabelHandgun9mm => 'Pistolet (9mm)';

  @override
  String get weaponLabelHandgunHeavy => 'Ciężki pistolet (.45)';

  @override
  String get weaponLabelSmgCompact => 'Kompaktowy pistolet maszynowy';

  @override
  String get weaponLabelShotgunPump => 'Strzelba (pompa)';

  @override
  String get weaponLabelMolotov => 'Koktajl Mołotowa';

  @override
  String get weaponLabelSmgSuppressed => 'Stłumiony pistolet maszynowy';

  @override
  String get weaponLabelShotgunTactical => 'Strzelba taktyczna';

  @override
  String get weaponLabelAssaultRifle => 'Karabin szturmowy (AK-47)';

  @override
  String get weaponLabelGrenadeFlash => 'Granat błyskowy';

  @override
  String get weaponLabelGrenadeFrag => 'Granat odłamkowy';

  @override
  String get weaponLabelSniperStandard => 'Karabin snajperski';

  @override
  String get weaponLabelAssaultRifleVip => 'Elitarny karabin szturmowy';

  @override
  String get weaponLabelSniperVip => 'Elitarny karabin snajperski';

  @override
  String get cooldownTitleCrime => 'Umorzenie przestępczości';

  @override
  String get cooldownTitleJob => 'Czas odnowienia pracy';

  @override
  String get cooldownTitleTravel => 'Czas odnowienia podróży';

  @override
  String get cooldownTitleHeist => 'Czas odnowienia napadu';

  @override
  String get cooldownTitleAppeal => 'Odwołaj się do czasu odnowienia';

  @override
  String get cooldownTitleSchool => 'Odmłodzenie szkoły';

  @override
  String get cooldownTitleGeneric => 'Czas odnowienia';

  @override
  String get crimeOutcomeDefaultTitle => 'Wynik przestępstwa';

  @override
  String get territoryContestStatusPreparing => 'Przygotowanie';

  @override
  String get territoryContestStatusActive => 'Aktywny';

  @override
  String get territoryContestStatusLockdown => 'Izolacja';

  @override
  String get territoryContestStatusResolved => 'Rozwiązany';

  @override
  String get territoryContestStatusCancelled => 'Odwołany';

  @override
  String get territoryContestHintPreparing =>
      'Konkurs ten jest obecnie w przygotowaniu. Po upływie czasu przygotowań region automatycznie staje się aktywny, a akcje odblokowują się.';

  @override
  String get territoryContestHintLockdown =>
      'Ten konkurs jest zamknięty. Nie można teraz podjąć żadnych nowych działań; wynik zostanie rozstrzygnięty automatycznie.';

  @override
  String get territoryNow => 'Teraz';

  @override
  String get territoryRoleAttacker => 'Napastnik';

  @override
  String get territoryRoleDefender => 'Obrońca';

  @override
  String get territoryValueLow => 'Niski';

  @override
  String get territoryValueAverage => 'Przeciętny';

  @override
  String get territoryValueHigh => 'Wysoki';

  @override
  String get territoryValueTop => 'Szczyt';

  @override
  String get territoryTagCapital => 'Centrum administracyjne';

  @override
  String get territoryTagHarbor => 'Port';

  @override
  String get territoryTagIndustry => 'Przemysł';

  @override
  String get territoryTagBorder => 'Region przygraniczny';

  @override
  String get territoryTagLogistics => 'Centrum logistyczne';

  @override
  String get territoryActionPatrol => 'Patrol';

  @override
  String get territoryActionIntelScan => 'Skan Intela';

  @override
  String get territoryActionSabotage => 'Sabotaż';

  @override
  String get territoryActionSupplyRun => 'Bieg zaopatrzeniowy';

  @override
  String get territoryActionRaid => 'Nalot';

  @override
  String get territoryActionDefense => 'Obrona';

  @override
  String get territoryBonusStrategicRegion => 'Region strategiczny';

  @override
  String get territoryBonusAdjacentSupport => 'Sąsiednie wsparcie';

  @override
  String get territoryBonusWarPressure => 'Presja wojenna';

  @override
  String get territoryBonusHqLevel => 'Poziom centrali';

  @override
  String get territoryBonusCrewMissionLevel => 'Poziom misji załogi';

  @override
  String get territoryBonusCrewBuildings => 'Budynki od strony załogi';

  @override
  String get territoryBonusOther => 'Inny';

  @override
  String territoryPointsLogicLine(
    int basePoints,
    int bonusPoints,
    int totalPoints,
  ) {
    return 'podstawa $basePoints + premia $bonusPoints = $totalPoints punktów konkursowych';
  }

  @override
  String get territoryErrorNotInCrew =>
      'Zanim będziesz mógł zaatakować terytorium, musisz dołączyć do załogi.';

  @override
  String get territoryErrorContestAlreadyActive =>
      'Dla tego regionu trwa już konkurs. Odświeżanie mapy do najnowszego stanu.';

  @override
  String get territoryErrorCrewContestLimit =>
      'Twoja Crew osiągnęła już limit równoczesnych zawodów.';

  @override
  String get territoryErrorRegionsCap =>
      'Twoja Crew posiada już maksymalną liczbę regionów.';

  @override
  String get territoryErrorContestNotActive =>
      'Ten konkurs nie jest jeszcze aktywny. Poczekaj, aż zakończy się faza przygotowawcza.';

  @override
  String get territoryErrorActionCooldown =>
      'Musisz poczekać zanim wykonasz kolejną akcję terytorialną.';

  @override
  String get territoryErrorActionRoleMismatch =>
      'Ta akcja należy do drugiej strony rywalizacji.';

  @override
  String get territoryErrorHqLevelRequired =>
      'Twój poziom Sztabu jest zbyt niski dla tej akcji dotyczącej terytorium.';

  @override
  String get territoryErrorDailyCap =>
      'Osiągnąłeś dzienny limit działań dotyczących terytorium.';

  @override
  String get territoryErrorWrongCountry =>
      'Możesz wyświetlić każdy kraj, ale działania terytorialne działają tylko w kraju, w którym się aktualnie znajdujesz.';

  @override
  String get territoryErrorUnknown => 'Błąd nieznanego terytorium.';

  @override
  String get territoryLegendUnderContest => 'W ramach konkursu';

  @override
  String get territoryLegendNeutral => 'Neutralny';

  @override
  String get territoryTabMap => 'Mapa';

  @override
  String get territoryTabLeaderboard => 'Tabela liderów';

  @override
  String get territoryTabSeason => 'Sezon';

  @override
  String get territorySelectCountryTooltip => 'Wybierz kraj';

  @override
  String get territoryUnavailableMessage =>
      'Terytorium jest obecnie niedostępne.';

  @override
  String get territoryMapHintTapMain =>
      'Kliknij region na mapie, aby w trybie modalnym wyświetlić informacje o terytorium i przycisk ataku.';

  @override
  String get territoryMapHintTapPanel =>
      'Stuknij region, aby bezpośrednio otworzyć moduł z informacjami o terytorium i akcjami ataku.';

  @override
  String get territoryMapHintMobile =>
      'Na urządzeniu mobilnym możesz przybliżać i oddalać dwa palce, a także przeciągać powiększoną mapę bezpośrednio do mniejszych regionów.';

  @override
  String get territoryMapHintColors =>
      'Kolory regionów pokazują własność; pomarańczowy = aktywny konkurs.';

  @override
  String territoryMapOverviewTitle(String country) {
    return '$country mapa (kontrola załogi)';
  }

  @override
  String get territoryLegendTitle => 'Legenda';

  @override
  String territoryYourCrewLine(String name) {
    return 'Twoja Crew: $name';
  }

  @override
  String get territoryDetailRegionPreviewTitle => 'Podgląd regionu';

  @override
  String get territoryDetailRegionPreviewSubtitle =>
      'Tylko wybrany region, bez reszty mapy.';

  @override
  String get territoryNeutralTerritory => 'Terytorium neutralne';

  @override
  String get territoryDetailOwner => 'Właściciel';

  @override
  String get territoryDetailNeutral => 'Neutralny';

  @override
  String get territoryDetailStability => 'Stabilność';

  @override
  String get territoryDetailEffectiveStability => 'Efektywna stabilność';

  @override
  String get territoryDetailControl => 'Kontrola';

  @override
  String get territoryDetailValueTier => 'Poziom wartości';

  @override
  String get territoryDetailPayout => 'Wypłata';

  @override
  String get territoryDetailStrategicRole => 'Rola strategiczna';

  @override
  String get territoryDetailAdjacentOwned =>
      'Sąsiadujące regiony będące własnością';

  @override
  String get territoryDetailActionBonuses => 'Bonusy akcji';

  @override
  String get territoryDetailBonusInfo => 'Informacje bonusowe';

  @override
  String get territoryDetailBonusInfoBody =>
      'Te premie jedynie zwiększają Twoje punkty konkursowe za każdą akcję. Region wypłaty w € pozostaje taki sam.';

  @override
  String get territoryDetailWarPressure => 'Presja wojenna';

  @override
  String get territoryDetailAttackPressure => 'ciśnienie ataku';

  @override
  String get territoryDetailStabilityWord => 'stabilność';

  @override
  String get territoryWarRoleTheater => 'rejon teatralny';

  @override
  String get territoryWarRoleAdjacent => 'sąsiedni region';

  @override
  String get territoryWarRoleTarget => 'region docelowy';

  @override
  String get territoryWarPressureEndsIn => 'Presja wojenna kończy się w';

  @override
  String get territoryDetailIncomeHour => 'Dochód na godzinę';

  @override
  String get territoryDetailIncomeDay => 'Dochód dziennie';

  @override
  String get territoryDetailYourCrew => 'Twoja Crew';

  @override
  String get territoryDetailContestStatus => 'Stan konkursu';

  @override
  String get territoryDetailYourRole => 'Twoja rola';

  @override
  String get territoryDetailYourHqLevel => 'Twój poziom centrali';

  @override
  String get territoryDetailActionsUnlockIn => 'Akcje odblokowują się w';

  @override
  String get territoryDetailActionsCloseIn => 'Akcje się zbliżają';

  @override
  String get territoryDetailContestEndsIn => 'Konkurs kończy się za';

  @override
  String get territoryDetailCooldownPerAction => 'Czas odnowienia na akcję';

  @override
  String get territoryDetailYourCooldown => 'Twój czas odnowienia';

  @override
  String get territoryNoticeCrewOnly =>
      'Na terytorium można grać tylko dla członków załogi. Najpierw utwórz lub dołącz do załogi, a następnie możesz atakować neutralne regiony.';

  @override
  String territoryNoticeWrongCountry(
    String viewingCountry,
    String playerCountry,
  ) {
    return 'Oglądasz $viewingCountry, ale obecnie jesteś w $playerCountry. Możesz przeglądać tę mapę, ale ataki i akcje konkursowe odblokowują się dopiero po podróży do tego kraju.';
  }

  @override
  String get territoryNoticeOwnRegion =>
      'Twoja Crew kontroluje już ten region.';

  @override
  String get territoryNoticeDefenderPrep =>
      'Twoja Crew broni tego regionu. Gdy rozpocznie się faza aktywna, zobaczysz tylko akcje obronne.';

  @override
  String get territoryConfirmDefense => 'Potwierdź obronę';

  @override
  String get territoryAttack => 'Atak';

  @override
  String get territoryAttackerActions => 'Działania atakującego';

  @override
  String get territoryDefenderActions => 'Działania obrońców';

  @override
  String get territoryContestActions => 'Działania konkursowe';

  @override
  String get territoryIntelShort => 'Skan Intela';

  @override
  String get territoryRequiresHqShort => 'wymaga centrali';

  @override
  String territoryHqLockedNotice(String actions) {
    return 'Wyższy poziom HQ wymagany dla: $actions.';
  }

  @override
  String get territoryNotInContestNotice =>
      'Nie bierzesz udziału w tym konkursie, więc nie możesz tutaj wykonywać żadnych działań.';

  @override
  String territoryContestOtherCountryNotice(String country) {
    return 'Konkurs odbywa się w innym kraju. Możesz go śledzić, ale możesz dołączyć dopiero wtedy, gdy fizycznie znajdziesz się w $country.';
  }

  @override
  String get territoryLeaderboardEmpty =>
      'Żadne terytorium nie jest jeszcze kontrolowane.';

  @override
  String territoryLeaderboardRegionsCount(int count) {
    return '$count regionów';
  }

  @override
  String get territorySeasonNone => 'Nie znaleziono aktywnego sezonu.';

  @override
  String get territorySeasonCurrent => 'Aktualny sezon';

  @override
  String get territorySeasonKey => 'Klawisz';

  @override
  String get territorySeasonStatus => 'Status';

  @override
  String get territorySeasonStart => 'Start';

  @override
  String get territorySeasonEnd => 'Koniec';

  @override
  String get territoryDialogAttackTitle => 'Atak?';

  @override
  String territoryDialogAttackBody(String regionKey) {
    return 'Rozpocząć konkurs na $regionKey?';
  }

  @override
  String get territorySnackJoinCrewFirst =>
      'Dołącz do załogi, która jako pierwsza zaatakuje terytorium.';

  @override
  String territorySnackContestStarted(String status) {
    return 'Konkurs rozpoczęty. Stan: $status. Przed podjęciem działań poczekaj na zakończenie fazy przygotowawczej.';
  }

  @override
  String territorySnackContestAlreadyLive(String status) {
    return 'Konkurs już się rozpoczął, a mapa została odświeżona. Stan: $status.';
  }

  @override
  String territoryPointsDelta(String points) {
    return '+$points punktów!';
  }

  @override
  String get territorySnackDefenseConfirmed =>
      'Obrona potwierdzona. Po rozpoczęciu fazy aktywnej możesz wykonywać akcje obronne.';

  @override
  String get territorySnackContestRefreshed =>
      'Stan konkursu został odświeżony. Możesz teraz natychmiast zobaczyć aktualną fazę obrony.';

  @override
  String territoryHqTooltipLocked(int required, int current) {
    return 'Wymaga poziomu HQ $required. Obecny poziom centrali: $current.';
  }

  @override
  String territoryHqButtonLocked(String label, int level) {
    return '$label (wymaga centrali $level)';
  }

  @override
  String get smugglingHubTitle => 'Centrum przemytu';

  @override
  String get smugglingHubSubtitle =>
      'Jeden system dla narkotyków, towarów handlowych, pojazdów, broni i amunicji. Podróżuj pusty i odbieraj bezpiecznie z magazynu.';

  @override
  String get smugglingClaimPersonal => 'Roszczenie osobiste';

  @override
  String get smugglingClaimCrew => 'Zgłoś załogę';

  @override
  String get smugglingNewShipment => 'Nowa dostawa';

  @override
  String get smugglingCategoryDrug => 'Narkotyki';

  @override
  String get smugglingCategoryTrade => 'Towary handlowe';

  @override
  String get smugglingCategoryVehicle => 'Pojazdy';

  @override
  String get smugglingCategoryWeapon => 'Broń';

  @override
  String get smugglingCategoryAmmo => 'Amunicja';

  @override
  String get smugglingNoItemsInCategory =>
      'Brak dostępnych pozycji w tej kategorii.';

  @override
  String get smugglingFieldItem => 'Przedmiot';

  @override
  String get smugglingFieldDestination => 'Miejsce docelowe';

  @override
  String get smugglingTransport => 'Transport';

  @override
  String get smugglingCommercialChannel => 'Kanał komercyjny';

  @override
  String get smugglingOwnedVehicleAircraft => 'Posiadany pojazd/samolot';

  @override
  String get smugglingNoOwnedTransportInCountry =>
      'Nie posiadasz własnego pojazdu ani samolotu, który mógłby zostać przemycony w tym kraju.';

  @override
  String get smugglingOwnedTransportFieldLabel => 'Własny transport';

  @override
  String smugglingOwnedTransportCapacityLine(int slots, String percent) {
    return 'Pojemność: $slots miejsc • Konfiskata w przypadku niepowodzenia: $percent%';
  }

  @override
  String smugglingOwnedTransportDropdownRow(
    String label,
    int slots,
    String riskReduction,
  ) {
    return '$label • $slots slotów • -$riskReduction%';
  }

  @override
  String get smugglingNetwork => 'Sieć';

  @override
  String get smugglingPersonal => 'Osobisty';

  @override
  String get smugglingCrew => 'Załoga';

  @override
  String get smugglingChannelField => 'Kanał przemytniczy';

  @override
  String get smugglingQuantity => 'Ilość';

  @override
  String get smugglingVehiclesOneByOne => 'Pojazdy wysyłane są pojedynczo';

  @override
  String smugglingMaxQuantity(int max) {
    return 'Maks.: $max';
  }

  @override
  String get smugglingStartSmuggling => 'Rozpocznij przemyt';

  @override
  String get smugglingSelectItemDestination =>
      'Wybierz element i miejsce docelowe';

  @override
  String get smugglingCrewTradeNotAvailable =>
      'Przemyt załogi w celu zdobycia towarów handlowych nie jest jeszcze dostępny';

  @override
  String get smugglingSelectOwnedTransportFirst =>
      'Najpierw wybierz posiadany pojazd lub samolot';

  @override
  String get smugglingInvalidQuantity => 'Nieprawidłowa ilość';

  @override
  String get smugglingActionProcessed => 'Akcja przetworzona';

  @override
  String smugglingQuoteSummaryLine(String fee, int etaMinutes, String risk) {
    return '€$fee • $etaMinutes min • $risk% ryzyka';
  }

  @override
  String smugglingSeizureRiskPercent(String percent) {
    return '$percent% ryzyka';
  }

  @override
  String get smugglingQuotePrompt =>
      'Wybierz przedmiot i miejsce docelowe wyceny na żywo.';

  @override
  String get smugglingQuoteLiveTitle => 'Cytat na żywo';

  @override
  String smugglingOwnedTransportCaption(String label) {
    return 'Posiadany transport: $label';
  }

  @override
  String smugglingCargoSlotsLine(int required, int available) {
    return 'Miejsca na ładunki: $required / $available';
  }

  @override
  String smugglingCooldownActive(String duration) {
    return 'Aktywny czas odnowienia: $duration';
  }

  @override
  String smugglingRecommendedChannel(String channel) {
    return 'Polecany kanał: $channel';
  }

  @override
  String get smugglingInsufficientCash =>
      'Niewystarczająca ilość gotówki na tę przesyłkę';

  @override
  String get smugglingDepotsTitle => 'Składy krajowe';

  @override
  String get smugglingDepotsEmpty => 'Brak gotowych paczek w magazynach.';

  @override
  String smugglingDepotLine(int packages, int totalQuantity) {
    return '$packages pakiety • $totalQuantity jednostki';
  }

  @override
  String get smugglingClaimHere => 'Złóż wniosek tutaj';

  @override
  String get smugglingStatusTitle => 'Stan przemytu';

  @override
  String get smugglingNoShipmentsYet => 'Nie ma jeszcze żadnych przesyłek.';

  @override
  String get smugglingStatusInTransit => 'W transporcie';

  @override
  String get smugglingStatusReady => 'Gotowy';

  @override
  String get smugglingStatusSeized => 'Schwytany';

  @override
  String get smugglingStatusClaimed => 'Zgłoszono';

  @override
  String get smugglingStatusUnknown => 'Nieznany';

  @override
  String get smugglingChannelPackage => 'Pakiet';

  @override
  String get smugglingChannelCourier => 'Kurier';

  @override
  String get smugglingChannelContainer => 'Pojemnik';

  @override
  String get smugglingChannelOwned => 'Własny transport';

  @override
  String get smugglingHintOwnedTransport =>
      'Własny transport obniża koszty i ryzyko, ale może zostać skonfiskowany w przypadku nieudanego przejazdu.';

  @override
  String get smugglingHintVehiclesChannel =>
      'Wskazówka: pojazdy najlepiej współpracują z firmą kurierską lub kontenerową.';

  @override
  String get smugglingHintWeaponsChannel =>
      'Wskazówka: większe ładunki broni są lepsze w kontenerze.';

  @override
  String get smugglingHintAmmoChannel =>
      'Wskazówka: amunicja zbiorcza w kontenerze, aby zmniejszyć ryzyko.';

  @override
  String get smugglingHintDrugsChannel =>
      'Wskazówka: małe partie w pakiecie, luzem w kontenerze.';

  @override
  String get smugglingHintCompareChannels =>
      'Wskazówka: porównaj kanały z wyceną na żywo.';

  @override
  String get smugglingQuoteBoatCannotFit =>
      'Łódź nie może zmieścić się w samolocie.';

  @override
  String get smugglingQuoteCargoOverflow =>
      'Posiadany przez Ciebie ładunek transportowy jest za mały.';

  @override
  String get smugglingQuoteUnavailable => 'Cytat niedostępny';

  @override
  String get smugglingApiInvalidChannel => 'Nieprawidłowy kanał przemytu';

  @override
  String get smugglingApiInvalidNetwork => 'Nieprawidłowy wybór sieci';

  @override
  String get smugglingApiInvalidQuantity => 'Nieprawidłowa ilość';

  @override
  String get smugglingApiInvalidDestination => 'Kraj docelowy nie istnieje';

  @override
  String get smugglingApiPlayerNotFound => 'Nie znaleziono gracza';

  @override
  String get smugglingApiSameCountryInventory =>
      'Użyj lokalnego asortymentu dla tego samego kraju';

  @override
  String get smugglingApiNotInCrew => 'Nie jesteś w załodze';

  @override
  String get smugglingApiCrewTradeUnavailable =>
      'Przemyt załogi w celu zdobycia towarów handlowych nie jest jeszcze dostępny';

  @override
  String get smugglingApiOwnedVehiclesPersonalOnly =>
      'Posiadane pojazdy służą wyłącznie do przemytu osobistego';

  @override
  String get smugglingApiChooseOwnedTransport =>
      'Wybierz posiadany pojazd lub samolot';

  @override
  String get smugglingApiChosenOwnedTransportUnavailable =>
      'Wybrany posiadany pojazd jest niedostępny';

  @override
  String get smugglingApiSameVehicleCargoConflict =>
      'Nie można używać tego samego pojazdu jako ładunku i środka transportu';

  @override
  String get smugglingApiCarCannotCarryOtherVehicle =>
      'Samochód lub motocykl nie może przewozić innego pojazdu';

  @override
  String get smugglingApiVehiclesCannotUsePackageChannel =>
      'Pojazdy nie mogą korzystać z kanału pakietowego';

  @override
  String get smugglingApiBoatCannotFit =>
      'Łódź nie może zmieścić się w samolocie.';

  @override
  String get smugglingApiCargoOverflow =>
      'Posiadany przez Ciebie ładunek transportowy jest za mały.';

  @override
  String smugglingApiCooldownWait(int seconds, String channel) {
    return 'Poczekaj $seconds s przed kolejną $channel wysyłką';
  }

  @override
  String get smugglingApiInsufficientMoney =>
      'Za mało pieniędzy na opłaty za przemyt';

  @override
  String get smugglingApiInsufficientDrugsCrew =>
      'Za mało narkotyków w ekwipunku załogi';

  @override
  String get smugglingApiInsufficientDrugs => 'Za mało leków w magazynie';

  @override
  String get smugglingApiInsufficientTradeGoods =>
      'Za mało towarów handlowych w ekwipunku';

  @override
  String get smugglingApiInsufficientWeaponsCrew =>
      'Za mało broni w ekwipunku załogi';

  @override
  String get smugglingApiInsufficientWeapons => 'Za mało broni w ekwipunku';

  @override
  String get smugglingApiInsufficientAmmoCrew =>
      'Za mało amunicji w ekwipunku załogi';

  @override
  String get smugglingApiInsufficientAmmo => 'Za mało amunicji w ekwipunku';

  @override
  String get smugglingApiInvalidCrewVehicle => 'Nieprawidłowy pojazd załogi';

  @override
  String get smugglingApiCrewBoatUnavailable =>
      'Łódź załogowa nie nadaje się do przemytu';

  @override
  String get smugglingApiCrewMotorcycleUnavailable =>
      'Motocykl załogi nie nadaje się do przemytu';

  @override
  String get smugglingApiCrewCarUnavailable =>
      'Samochód załogowy niedostępny do przemytu';

  @override
  String get smugglingApiInvalidVehicleKey => 'Nieprawidłowy pojazd';

  @override
  String get smugglingApiVehicleUnavailableForSmuggling =>
      'Pojazd niedostępny do przemytu';

  @override
  String get smugglingApiInsufficientStockForShipment =>
      'Za mało towaru dla tej przesyłki';

  @override
  String get smugglingApiDepotNoShipmentsReady =>
      'Brak gotowych przesyłek w magazynie w tym kraju';

  @override
  String smugglingApiQuantityTooHighForChannel(String channel, int max) {
    return 'Ilość za duża dla $channel. Maks.: $max';
  }

  @override
  String smugglingApiShipmentStarted(String channel, String destination) {
    return 'Rozpoczęto przemyt ($channel) do $destination';
  }

  @override
  String smugglingApiClaimedPersonal(int count, String country) {
    return 'Odebrano $count przesyłek w $country';
  }

  @override
  String smugglingApiClaimedCrew(int count, String country) {
    return 'Odebrano $count przesyłek załogi w $country';
  }

  @override
  String get smugglingClientShipmentFailed => 'Wysyłka nie powiodła się';

  @override
  String get smugglingClientQuoteFailed => 'Cytat nie powiódł się';

  @override
  String get smugglingClientClaimFailed => 'Reklamacja nie powiodła się';

  @override
  String smugglingClientErrorPrefix(String detail) {
    return 'Błąd: $detail';
  }

  @override
  String get cryptoMarketNoData =>
      'Brak dostępnych danych dotyczących rynku kryptowalut';

  @override
  String get cryptoMarketTitle => 'Rynek kryptowalut';

  @override
  String cryptoMarketOpenOrdersCount(int count) {
    return 'Otwarte zamówienia: $count';
  }

  @override
  String get cryptoRegimeBull => 'Rynek byka';

  @override
  String get cryptoRegimeBear => 'Rynek niedźwiedzia';

  @override
  String get cryptoRegimeSideways => 'Bokiem';

  @override
  String cryptoOwnedAmountLine(String amount) {
    return 'Posiadane: $amount';
  }

  @override
  String get cryptoPortfolioTitle => 'Teczka';

  @override
  String get cryptoLabelValue => 'Wartość';

  @override
  String get cryptoLabelCostBasis => 'Podstawa kosztów';

  @override
  String get cryptoLabelUnrealized => 'Niedoszły';

  @override
  String get cryptoLabelRealized => 'Realizowany';

  @override
  String get cryptoNoPositionsYet => 'Nie ma jeszcze żadnych stanowisk';

  @override
  String get cryptoChartDataUnavailable => 'Dane wykresu niedostępne';

  @override
  String get cryptoUnknownTime => 'Nieznany';

  @override
  String get cryptoOrderTypeStopLoss => 'Stop-loss';

  @override
  String get cryptoOrderTypeTakeProfit => 'Czerp zysk';

  @override
  String get cryptoOrderTypeLimit => 'Limit';

  @override
  String get cryptoSideBuy => 'Kupić';

  @override
  String get cryptoSideSell => 'Sprzedać';

  @override
  String get cryptoInvalidQuantity => 'Nieprawidłowa ilość';

  @override
  String get cryptoPurchaseCompleted => 'Zakup zakończony';

  @override
  String get cryptoSaleCompleted => 'Sprzedaż zakończona';

  @override
  String get cryptoActionProcessed => 'Akcja przetworzona';

  @override
  String get cryptoInvalidTargetPrice => 'Nieprawidłowa cena docelowa';

  @override
  String get cryptoCannotSellMoreThanOwned =>
      'Nie możesz sprzedać więcej niż posiadasz.';

  @override
  String get cryptoOpenOrderPlaced => 'Złożone zamówienie otwarte';

  @override
  String get cryptoOpenOrderFailed => 'Nie udało się złożyć zamówienia';

  @override
  String get cryptoOrderCancelled => 'Zamówienie anulowane';

  @override
  String get cryptoCancelOrderFailed => 'Nie udało się anulować zamówienia';

  @override
  String get cryptoDirectTradeTitle => 'Handel bezpośredni';

  @override
  String get cryptoLabelQuantity => 'Ilość';

  @override
  String cryptoDirectTradeHelperWithAvgAndAll(
    String currentPrice,
    String avgBuy,
  ) {
    return 'Obecna cena: $currentPrice € • Średni zakup: $avgBuy \nUżyj opcji ALL, aby natychmiast sprzedać całą swoją pozycję.';
  }

  @override
  String cryptoDirectTradeHelperWithAvgOnly(
    String currentPrice,
    String avgBuy,
  ) {
    return 'Obecna cena: $currentPrice € • Średni zakup: $avgBuy';
  }

  @override
  String cryptoDirectTradeHelperPriceAndAll(String currentPrice) {
    return 'Aktualna cena: $currentPrice € \nUżyj opcji ALL, aby natychmiast sprzedać całą swoją pozycję.';
  }

  @override
  String cryptoDirectTradeHelperPriceOnly(String currentPrice) {
    return 'Aktualna cena: $currentPrice €';
  }

  @override
  String cryptoYourHistoryForSymbol(String symbol) {
    return 'Twoja historia przez $symbol';
  }

  @override
  String get cryptoLabelAvgBuy => 'Średni zakup';

  @override
  String get cryptoLabelLastBuy => 'Ostatni zakup';

  @override
  String get cryptoLabelBuyVolume => 'Kup objętość';

  @override
  String get cryptoLabelSellVolume => 'Sprzedawaj wolumen';

  @override
  String cryptoLastBuyAt(String when) {
    return 'Ostatni zakup o $when';
  }

  @override
  String get cryptoNoTradesForCoinYet =>
      'Nie ma jeszcze żadnych transakcji na tę monetę.';

  @override
  String cryptoOpenOrdersForSymbol(String symbol) {
    return 'Otwarte zamówienia na $symbol';
  }

  @override
  String get cryptoOpenOrdersSectionHint =>
      'Otwarte zamówienia korzystają z własnej ilości poniżej. W tej sekcji wpisz ilość i cenę docelową.';

  @override
  String get cryptoLabelOrderType => 'Typ zamówienia';

  @override
  String get cryptoLabelSide => 'Strona';

  @override
  String get cryptoLabelOrderQuantity => 'Ilość zamówienia';

  @override
  String cryptoOrderQtyHelperOwned(String quantity) {
    return 'To zamówienie sprzedaje z Twojej obecnej pozycji. Posiadane: $quantity';
  }

  @override
  String get cryptoOrderQtyHelperStandalone =>
      'Ilość ta jest odrębna od powyższego handlu bezpośredniego.';

  @override
  String get cryptoLabelTargetPrice => 'Cena docelowa';

  @override
  String get cryptoTargetPriceHelperLimit =>
      'Limit kupna poniżej ceny, limit sprzedaży powyżej ceny';

  @override
  String get cryptoTargetPriceHelperStopLoss =>
      'Wykonuje się, gdy cena spadnie do tego poziomu';

  @override
  String get cryptoTargetPriceHelperTakeProfit =>
      'Wykonuje się, gdy cena wzrośnie do tego poziomu';

  @override
  String get cryptoPlaceOpenOrder => 'Złóż otwarte zamówienie';

  @override
  String get cryptoNoOpenOrdersYet =>
      'Nie masz jeszcze żadnych otwartych zamówień na tę monetę.';

  @override
  String get cryptoLabelCancel => 'Anulować';

  @override
  String cryptoDetailsTitleWithSymbol(String symbol) {
    return 'Szczegóły kryptowaluty • $symbol';
  }

  @override
  String get cryptoLabelCoin => 'Moneta';

  @override
  String get cryptoLabelPrice => 'Cena';

  @override
  String get cryptoLabelOwned => 'Posiadany';

  @override
  String get cryptoLabelOpenOrders => 'Otwórz zamówienia';

  @override
  String get cryptoNotEnoughHistory => 'Jeszcze za mało historii';

  @override
  String get cryptoChartPointsWord => 'zwrotnica';

  @override
  String get cryptoChartHourAbbrev => 'H';

  @override
  String cryptoChartDataCaptionFullHistory(int count, String points) {
    return '$count $points • pełna historia';
  }

  @override
  String cryptoChartDataCaptionHours(int count, String points, String hours) {
    return '$count $points • $hours';
  }

  @override
  String get cryptoChartRange1h => '1 godz';

  @override
  String get cryptoChartRange4h => '4h';

  @override
  String get cryptoChartRange8h => '8h';

  @override
  String get cryptoChartRange24h => '24h';

  @override
  String get cryptoChartRange7d => '7d';

  @override
  String get cryptoChartRange30d => '30d';

  @override
  String get cryptoChartRangeAll => 'Wszystko';

  @override
  String get cryptoChartLive1h => 'Na żywo • ostatnie 1 godz';

  @override
  String get cryptoChartLive4h => 'Na żywo • ostatnie 4 godziny';

  @override
  String get cryptoChartLive8h => 'Na żywo • ostatnie 8h';

  @override
  String get cryptoChartLive24h => 'Na żywo • ostatnie 24h';

  @override
  String get cryptoChartLive7d => 'Na żywo • ostatnie 7 dni';

  @override
  String get cryptoChartLive30d => 'Na żywo • ostatnie 30 dni';

  @override
  String get cryptoChartLiveAll => 'Na żywo • pełna historia';

  @override
  String get cryptoLabelTotal => 'Całkowity';

  @override
  String get cryptoApiCouldNotLoadMarket =>
      'Nie można załadować rynku kryptowalut.';

  @override
  String get cryptoApiAssetNotFound => 'Nie znaleziono kryptowaluty.';

  @override
  String get cryptoApiCouldNotLoadChart =>
      'Nie można załadować danych wykresu kryptograficznego.';

  @override
  String get cryptoApiNotLoggedIn => 'Nie zalogowany.';

  @override
  String get cryptoApiCouldNotLoadPortfolio =>
      'Nie udało się wczytać portfolio.';

  @override
  String get cryptoApiCouldNotLoadTransactions =>
      'Nie można wczytać historii transakcji kryptowalutowych.';

  @override
  String get cryptoApiInvalidQuantity => 'Nieprawidłowa ilość.';

  @override
  String get cryptoApiInsufficientFunds => 'Za mało pieniędzy.';

  @override
  String get cryptoApiPurchaseFailed => 'Zakup nie powiódł się.';

  @override
  String get cryptoApiNotEnoughCrypto => 'Za mało trzymanych kryptowalut.';

  @override
  String get cryptoApiSellFailed => 'Sprzedaż nie powiodła się.';

  @override
  String get cryptoApiCouldNotLoadOrders =>
      'Nie można wczytać zamówień kryptowalutowych.';

  @override
  String get cryptoApiInvalidTargetPrice => 'Nieprawidłowa cena docelowa.';

  @override
  String get cryptoApiInvalidOrderType => 'Nieprawidłowy typ zamówienia.';

  @override
  String get cryptoApiInvalidOrderSide => 'Nieprawidłowa strona zamówienia.';

  @override
  String get cryptoApiInvalidOrderCombination =>
      'Ta kombinacja rodzaju zamówienia i strony jest niedozwolona.';

  @override
  String get cryptoApiPlaceOrderFailed => 'Nie udało się złożyć zamówienia.';

  @override
  String get cryptoApiPlayerNotFound => 'Nie znaleziono gracza.';

  @override
  String get cryptoApiInvalidOrderId =>
      'Nieprawidłowy identyfikator zamówienia.';

  @override
  String get cryptoApiOrderNotFoundOrClosed =>
      'Nie znaleziono zamówienia lub jest ono już nieaktywne.';

  @override
  String get cryptoApiCancelOrderFailed => 'Nie udało się anulować zamówienia.';

  @override
  String cryptoApiBuySuccess(String quantity, String symbol, String total) {
    return 'Kupiłeś $quantity $symbol za $total.';
  }

  @override
  String cryptoApiSellSuccess(String quantity, String symbol, String total) {
    return 'Sprzedałeś $quantity $symbol za $total.';
  }

  @override
  String cryptoApiOrderPlaced(
    String side,
    String quantity,
    String symbol,
    String price,
  ) {
    return 'Zamówienie złożone: $side $quantity $symbol @ $price.';
  }

  @override
  String cryptoApiOrderCancelledDetail(int orderId) {
    return 'Zamówienie $orderId anulowane.';
  }

  @override
  String cryptoClientErrorPrefix(String detail) {
    return 'Błąd: $detail';
  }

  @override
  String drugsClientErrorLoading(String error) {
    return 'Błąd podczas ładowania: $error';
  }

  @override
  String drugsFacilitiesErrorLoading(String error) {
    return 'Błąd podczas ładowania obiektów: $error';
  }

  @override
  String get drugsInvTitle => 'Inwentarz leków';

  @override
  String get drugsInvKpiGramsLabel => 'spis';

  @override
  String get drugsCutQualityDCannotCut => 'Gatunek D nie może być dalej cięty.';

  @override
  String get drugsCutFailed => 'Cięcie nie powiodło się';

  @override
  String get drugsSellFailed => 'Sprzedaż nie powiodła się';

  @override
  String drugsSellDialogTitle(String name) {
    return 'Sprzedaj $name';
  }

  @override
  String drugsInvAvailableQty(String qty) {
    return 'Dostępne: $qty g';
  }

  @override
  String drugsQualityWithGrade(String grade) {
    return 'Jakość: $grade';
  }

  @override
  String drugsCurrentPricePerGram(String price) {
    return 'Obecna cena: $price € za gram';
  }

  @override
  String get drugsPricesByCountry => 'Ceny według kraju:';

  @override
  String get drugsQuantityGramsField => 'Ilość (gramy)';

  @override
  String drugsInvTotalLine(String amount) {
    return 'Razem: $amount €';
  }

  @override
  String get drugsInvalidQuantity => 'Nieprawidłowa ilość';

  @override
  String get drugsSellAction => 'Sprzedać';

  @override
  String get drugsInvEmptyTitle => 'Brak leków w magazynie';

  @override
  String get drugsInvEmptySubtitle => 'Rozpocznij produkcję, aby stworzyć leki';

  @override
  String get drugsInvSectionHeader => 'Zapasy i dystrybucja';

  @override
  String get drugsInvSectionBody =>
      'Sprzedawaj leki według jakości i różnic cenowych pomiędzy krajami.';

  @override
  String drugsInvCurrentLocation(String place) {
    return 'Aktualna lokalizacja: $place';
  }

  @override
  String drugsInvStockLine(String qty) {
    return 'Zapasy: $qty g';
  }

  @override
  String drugsInvCurrentValue(String amount) {
    return 'Aktualna wartość: €$amount';
  }

  @override
  String drugsInvMarketLine(String emoji, String pct) {
    return 'Rynek: $emoji $pct%';
  }

  @override
  String get drugsCutDialogTitle => 'Odetnij narkotyki';

  @override
  String drugsCutQualityBanner(String fromQ, String toQ, String pct) {
    return 'Jakość $fromQ → $toQ: +$pct% więcej jednostek';
  }

  @override
  String drugsCutResultLine(
    String qty,
    String qFrom,
    String result,
    String qTo,
  ) {
    return 'Wynik: $qty g $qFrom → $result g $qTo';
  }

  @override
  String get drugsCutAction => 'Cięcie';

  @override
  String get drugsSlotsLabel => 'szczeliny';

  @override
  String get drugsFacilitiesTitle => 'Placówki narkotykowe';

  @override
  String get drugsFacilitiesHeroTitle =>
      'Zarządzaj swoimi placówkami farmaceutycznymi';

  @override
  String get drugsFacilitiesHeroBody =>
      'Obiekty takie jak szklarnia, pieczarkarnia, laboratorium narkotykowe, kuchnia z crackiem i witryna sklepowa w ciemnej sieci określają, jakie leki możesz produkować, ile masz miejsc oraz jak wysoka jest Twoja jakość, wydajność i szybkość.';

  @override
  String get drugsFacCurrentProductions => 'Aktualne produkcje';

  @override
  String get drugsFacUnknownFacility => 'Nieznany obiekt';

  @override
  String get drugsFacUnknownMessage => 'Nieznana wiadomość';

  @override
  String get drugsFacUpgradeLockedTitle => '🔒 Aktualizacja leku zablokowana';

  @override
  String get drugsFacUpgradeLockedBody =>
      'Najpierw potrzebujesz odpowiedniego poziomu wykształcenia i certyfikatów w zakresie narkotyków.';

  @override
  String get drugsFacEquipLockedTitle =>
      '🔒 Aktualizacja wyposażenia zablokowana';

  @override
  String get drugsFacEquipLockedBody =>
      'Najpierw trenuj swoją ścieżkę Narkotyków, aby odblokować kolejny poziom ulepszenia.';

  @override
  String get drugsFacBuy => 'Kupić';

  @override
  String get drugsFacOwned => 'Posiadany';

  @override
  String get drugsFacPrice => 'Cena';

  @override
  String get drugsFacRank => 'Stopień';

  @override
  String get drugsFacDrugTypes => 'Narkotyki';

  @override
  String get drugsFacSlots => 'Sloty';

  @override
  String get drugsFacQuality => 'Jakość';

  @override
  String get drugsFacYield => 'Dawać';

  @override
  String get drugsFacSpeed => 'Prędkość';

  @override
  String get drugsFacMaxSlots => 'Maksymalna liczba slotów';

  @override
  String drugsFacUpgradeSlots(String cost) {
    return 'Miejsca na ulepszenia ($cost €)';
  }

  @override
  String get drugsFacEquipmentUpgrades => 'Ulepszenia sprzętu';

  @override
  String get drugsFacMax => 'Maks';

  @override
  String drugsFacLvlPrice(String level, String price) {
    return 'Poziom $level ($price €)';
  }

  @override
  String get drugsHubTitle => 'Środowisko narkotykowe';

  @override
  String get drugsSubviewProduction => 'Produkcja narkotyków';

  @override
  String get drugsSubviewFacilities => 'Placówki narkotykowe';

  @override
  String get drugsSubviewInventory => 'Inwentarz leków';

  @override
  String get drugsTagUndergroundOps => 'Operacje podziemne';

  @override
  String get drugsTagMobileOptimized =>
      'Zoptymalizowany pod kątem urządzeń mobilnych';

  @override
  String get drugsTagQualityDriven => 'Nastawa na jakość';

  @override
  String get drugsEmpireTitle => 'Imperium narkotykowe';

  @override
  String get drugsHubIntro =>
      'Zarządzaj tutaj produkcją, obiektami i zapasami. Kupuj materiały na Czarnym Rynku, a reszta odbywa się w Twoim własnym środowisku narkotykowym.';

  @override
  String get drugsStatMaterialFlow => 'Przepływ materiału';

  @override
  String get drugsStatBlackMarket => 'Czarny rynek';

  @override
  String get drugsStatProductionChain => 'Łańcuch produkcyjny';

  @override
  String get drugsStatProductionChainValue =>
      'Szklarnia + laboratorium + kuchnia + Darkweb';

  @override
  String get drugsStatSalesModel => 'Model sprzedaży';

  @override
  String get drugsStatPerQuality => 'Według jakości';

  @override
  String get drugsMetricActiveBatches => 'Aktywne partie';

  @override
  String get drugsMetricSlotUsage => 'Wykorzystanie gniazda';

  @override
  String get drugsMetricInventoryValue => 'Wartość zapasów';

  @override
  String get drugsMetricInventoryGrams => 'Gram zapasów';

  @override
  String get drugsMetricEfficiency => 'Efektywność';

  @override
  String get drugsMetricPoliceHeat => 'Policyjny upał';

  @override
  String get drugsSectionOperations => 'Operacje';

  @override
  String get drugsSectionOperationsSubtitle =>
      'Wybierz gałąź swojego imperium narkotykowego';

  @override
  String get drugsCardFacilitiesEyebrow => 'Infrastruktura';

  @override
  String get drugsCardFacilitiesTitle => 'Udogodnienia';

  @override
  String get drugsCardFacilitiesBody =>
      'Kupuj i ulepszaj szklarnię, laboratorium narkotykowe, kuchnię crackową i witrynę sklepową w ciemnej sieci, aby uzyskać więcej miejsc, szybkość i jakość.';

  @override
  String get drugsCardProductionEyebrow => 'Rurociąg';

  @override
  String get drugsCardProductionTitle => 'Produkcja';

  @override
  String get drugsCardProductionBody =>
      'Rozpoczynaj partie, śledź liczniki czasu i zbieraj wydruki za pomocą wysokiej jakości rolek.';

  @override
  String get drugsCardInventoryEyebrow => 'Dystrybucja';

  @override
  String get drugsCardInventoryTitle => 'Spis';

  @override
  String get drugsCardInventoryBody =>
      'Przeglądaj stosy według jakości i sprzedawaj po najlepszej wartości rynkowej.';

  @override
  String get drugsQualityDistribution => 'Dystrybucja jakości';

  @override
  String get drugsQualityGradeSuperior => 'Znakomity';

  @override
  String get drugsQualityGradeHigh => 'Wysoki';

  @override
  String get drugsQualityGradeStandardPlus => 'Standardowy+';

  @override
  String get drugsQualityGradeStandard => 'Standard';

  @override
  String get drugsQualityGradeLow => 'Niski';

  @override
  String get drugsHeatLevelLow => 'Niski';

  @override
  String get drugsHeatLevelMedium => 'Średni';

  @override
  String get drugsHeatLevelHigh => 'Wysoki';

  @override
  String get drugsHeatLevelCritical => 'Krytyczny';

  @override
  String get drugsProdTitle => 'Produkcja narkotyków';

  @override
  String get drugsProdLineTitle => 'Linia produkcyjna';

  @override
  String get drugsProdLineSubtitle =>
      'Rozpoczynaj partie, monitoruj pojemność gniazd i dostosowuj jakość poprzez modernizację szklarni i laboratoriów.';

  @override
  String get drugsProdActiveProductions => 'Aktywne produkcje';

  @override
  String get drugsProdIncidentLegend => 'Legenda o wydarzeniu';

  @override
  String get drugsProdHide => 'Ukrywać';

  @override
  String get drugsProdShow => 'Pokazywać';

  @override
  String get drugsProdLegendDelay => 'Opóźnienie';

  @override
  String get drugsProdLegendContamination => 'Zanieczyszczenie';

  @override
  String get drugsProdLegendYieldLoss => 'Utrata plonów';

  @override
  String get drugsProdLegendInstability => 'Niestabilność';

  @override
  String get drugsProdLegendCombined => 'Połączony problem';

  @override
  String get drugsProdCollect => 'Zbierać';

  @override
  String get drugsProdAvailableDrugs => 'Dostępne leki';

  @override
  String get drugsProdNoDrugs => 'Brak dostępnych leków';

  @override
  String get drugsProdAutoCollectOn => 'Odbiór automatyczny włączony (VIP)';

  @override
  String get drugsProdAutoCollectOff =>
      'Wyłączenie automatycznego odbioru (VIP)';

  @override
  String get drugsProdVipMaterialsOk => 'Dostępne wszystkie materiały';

  @override
  String get drugsProdVipBuyMissing =>
      'VIP: kup brakujące materiały jednym kliknięciem';

  @override
  String drugsProdTimeYieldLine(String time, String yield) {
    return 'Czas: $time | Wydajność: ${yield}g';
  }

  @override
  String drugsProdSlotsUsedLine(String facility, String used, String total) {
    return '$facility: $used/$total wykorzystanych miejsc';
  }

  @override
  String drugsProdFacilityRequired(String facility) {
    return 'wymagane $facility';
  }

  @override
  String drugsProdRankRequired(String rank) {
    return 'Wymagana ranga $rank';
  }

  @override
  String get drugsProdNoFreeSlot => 'Brak wolnego miejsca produkcyjnego';

  @override
  String get drugsProdOpenFacilities => 'Otwarte obiekty';

  @override
  String get drugsProdStartProduction => 'Rozpocznij produkcję';

  @override
  String get drugsProdAutoCollectUpdated =>
      'Zaktualizowano automatyczne zbieranie';

  @override
  String get drugsProdKpiActive => 'aktywny';

  @override
  String get drugsProdKpiReady => 'gotowy';

  @override
  String drugsProdYieldGrams(String qty) {
    return 'Wydajność: $qty gramów';
  }

  @override
  String get drugsTimeMinSuffix => 'min';

  @override
  String drugsFmtMinutes(String minutes) {
    return '$minutes min';
  }

  @override
  String drugsFmtHoursOnly(String hours) {
    return '$hours godz';
  }

  @override
  String drugsFmtHoursMinutes(String hours, String minutes) {
    return '$hours godz. $minutes min';
  }

  @override
  String get drugsTimeHourEn => 'godz';

  @override
  String get drugsProdConfirmTitle => 'Czy jesteś pewien?';

  @override
  String drugsProdConfirmBody(String drugName) {
    return 'Rozpocząć produkcję $drugName?';
  }

  @override
  String drugsProdTimeLine(String time) {
    return 'Czas: $time';
  }

  @override
  String drugsProdYieldLine(String yield) {
    return 'Wydajność: $yield gramów';
  }

  @override
  String get drugsProdRiskNote =>
      'Produkcja może czasami ponieść niepowodzenia. Lepsze ulepszenia zmniejszają ryzyko, wysoka temperatura leku je zwiększa.';

  @override
  String get drugsProdRequiredMaterialsHeader => 'Wymagane materiały:';

  @override
  String get drugsProdStartProductionButton => 'Rozpocznij produkcję';

  @override
  String get drugsProdFailed => 'Produkcja nie powiodła się';

  @override
  String get drugsProdCollectFailed => 'Zbieranie nie powiodło się';

  @override
  String drugsProdNeedRank(String rank) {
    return 'Potrzebujesz rangi $rank';
  }

  @override
  String get drugsProdMissingPrefix => 'Zaginiony';

  @override
  String get drugsFacilityGreenhouse => 'Szklarnia';

  @override
  String get drugsFacilityCrackKitchen => 'Pęknięta Kuchnia';

  @override
  String get drugsFacilityDarkweb => 'Witryna sklepu Darkweb';

  @override
  String get drugsFacilityMushroomFarm => 'Farma Grzybów';

  @override
  String get drugsFacilityDrugLab => 'Laboratorium narkotykowe';

  @override
  String get drugsVipQuickBuyTitle => 'Szybki zakup VIP';

  @override
  String drugsVipAlreadyEnough(String name) {
    return 'Masz już wystarczającą ilość materiałów na $name';
  }

  @override
  String drugsVipBuyPrompt(String name) {
    return 'Kupić wszystkie brakujące materiały za $name jednym kliknięciem?';
  }

  @override
  String drugsVipTotal(String amount) {
    return 'Razem: $amount €';
  }

  @override
  String get drugsPurchaseCompleted => 'Zakup zakończony';

  @override
  String get drugsPurchaseFailed => 'Zakup nie powiódł się';

  @override
  String get drugsServiceErrorGeneric => 'Błąd';

  @override
  String get drugsApiFailedBuyMaterial => 'Nie udało się kupić materiału';

  @override
  String get drugsApiFailedStartProduction =>
      'Nie udało się rozpocząć produkcji';

  @override
  String get drugsApiFailedCollect => 'Nie udało się pobrać produkcji';

  @override
  String get drugsApiFailedSell => 'Nie udało się sprzedać narkotyków';

  @override
  String get drugsApiFailedCut => 'Nie udało się odstawić narkotyków';

  @override
  String get drugsApiFailedShipment => 'Nie udało się wysłać przesyłki';

  @override
  String get drugsApiFailedClaim =>
      'Nie udało się odebrać przesyłek z magazynu';

  @override
  String get helpTopicDashboardCategory => 'Rdzeń';

  @override
  String get helpTopicDashboardTitle => 'Panel';

  @override
  String get helpTopicDashboardSummary =>
      'Twój centralny przegląd wszystkich statystyk, aktywnych czasów odnowienia, wydarzeń na żywo i skrótów do każdej części gry.';

  @override
  String get helpTopicDashboardHow =>
      'Górny pasek pokazuje: Gotówkę, Rangę, Zdrowie (0-100 HP), Poziom poszukiwanego (0-100) i FBI Heat (0-100). \nCo 5 minut uruchamia się automatyczny kleszcz: głód spada o -2, pragnienie -3, leczysz pasywnie +5 HP (jeśli HP > 0), poziom poszukiwanego spada nieznacznie poniżej 10 (odsetki bankowe są obecnie wyłączone). \nJeśli głód lub pragnienie osiągną poziom 0, umierasz i spędzasz 3 godziny na oddziale intensywnej terapii. Jedz i pij na czas! \nBloki szybkiej akcji po prawej stronie to skróty do przestępstw, kradzieży samochodów, kradzieży łodzi, pracy, kasyna, banku i szkoły. \nLiczniki czasu odnowienia w każdej sekcji pokazują, ile czasu pozostało do następnej akcji. Timer dostosowuje się, aby pokazać najbardziej odpowiednią jednostkę: minuty, godziny lub dni. \nKarta statystyk wykorzystuje teraz rzeczywiste liczniki na żywo dla ucieczek, morderstw, kontraktów na listę hitów, podróży i kul, zamiast stałych zerowych symboli zastępczych. \nPulpit nawigacyjny ma teraz również rozszerzoną sekcję ekonomiczną z gotówką, bankami, kryptowalutami, wartością pojazdu, wartością nieruchomości, wartością netto i 24-godzinnym trendem przepływu środków pieniężnych. \nBlok operacji pokazuje teraz aktywną produkcję, najdłuższy czas odnowienia, status pojazdu (aktywny/wystawiony/przejazd) i liczniki czasu następnej produkcji/wydarzenia. \nGdy wydarzenia graczy są na żywo (np. cotygodniowe zawody), ten sam panel po prawej stronie zawiera krótką listę ich tytułów i linki do strony wydarzeń. Możesz włączyć lub wyłączyć funkcję push rozpoczęcia/zakończenia rundy w Ustawieniach → Wydarzenia gracza (oprócz uprawnień urządzenia i innych kategorii push). \nPowiadomienia i ryzyko obejmują teraz nieprzeczytane wiadomości prywatne, zgłoszenia do pomocy technicznej oczekujące na Twoją odpowiedź, zdarzenia z ostatnich 24 godzin oraz kompaktowy wynik ryzyka (poszukiwany + FBI). \nKiedy twoja Crew bierze udział w Crew Wars, na pulpicie nawigacyjnym wyświetlane jest także podsumowanie Crew Wars ze statusem, przeciwnikiem, punktami załogi, rangą sezonu i pozostałym czasem w bieżącej fazie. \nPanel kontrolny zawiera teraz także przegląd operacji pojazdu dla każdego samochodu/motocykla/łodzi z żetonami czasu odnowienia na żywo (Hotspot, Crew, Mecz załogi, Chop, Kontrakt i Licznik), a także ciepło/reputację, liczbę kontraktów i roszczeń oraz punkty sezonowe. \nWydarzenia na żywo pojawiają się, gdy inni gracze wykonują ważne akcje, gdy zostaniesz zaatakowany lub gdy nastąpią ruchy na globalnym rynku. \nPlakietka wiadomości pokazuje nieprzeczytane wiadomości systemowe i wiadomości osobiste. \nLewe menu nawigacyjne zapewnia dostęp do wszystkich sekcji gry pogrupowanych według kategorii: Akcje, Świat, Społeczność, Ekonomia, Imperium i Zasoby.';

  @override
  String get helpTopicDashboardTips =>
      'Otwórz pulpit nawigacyjny po każdym logowaniu, aby zobaczyć, co zmieniło się podczas Twojej nieobecności. \nUtrzymuj poziom poszukiwanego poniżej 10, aby automatyczny zanik działał, a ryzyko aresztowania pozostało niskie. \nZanim podejmiesz ryzykowne działania, sprawdź nieprzeczytane wiadomości: nagrody, zrealizowane zamówienia i zdarzenia systemowe pojawią się w Twojej skrzynce odbiorczej.';

  @override
  String get helpTopicCrimesCategory => 'Działania';

  @override
  String get helpTopicCrimesTitle => 'Zbrodnie';

  @override
  String get helpTopicCrimesSummary =>
      'Podejmuj nielegalne działania, aby zdobyć gotówkę i PD, ale każda próba wiąże się z ryzykiem obrażeń, aresztowania lub dodatkowego poziomu poszukiwanego. Przestępstwo Wipe Criminal Record w późnej fazie gry powoduje, że po sukcesie usuwasz całą przeszłość kryminalną, ale wymaga ciężkich narzędzi i wiąże się z wysokim ryzykiem federalnym.';

  @override
  String get helpTopicCrimesHow =>
      'Czasy odnowienia przestępstw skalują się teraz wraz z potencjalną wypłatą: przestępstwa o niskim zysku pozostają szybkie, podczas gdy przestępstwa o wysokim zysku mają wyraźnie dłuższy czas odnowienia. \nWytyczne według poziomu nagrody: do 500 € ≈ 1,5 min, do 2000 € ≈ 5 min, do 10 000 € ≈ 15 min, do 30 000 € ≈ 30 min, powyżej tego ≈ 60 min. \nNie ma sztywnego dziennego limitu przestępstw; aktywni gracze mogą grać dalej, o ile zarządzają czasami odnowienia, ryzykiem i zasobami. \nPrzestępstwa z „wymaganą bronią” wykorzystują wybraną broń przestępczą. Możesz teraz wybrać go bezpośrednio u góry ekranu Zbrodni lub w Inwentarzu. \nAktywne bonusy z siłowni i strzelnicy (do +8% każdy) są widoczne na ekranie Zbrodni; zwiększają szansę powodzenia tak, jak oblicza je serwer (trenuj dalej w Centrum szkoleniowym / sala gimnastyczna + strzelnica). \nJeśli tego samego dnia kalendarza UTC ukończysz co najmniej jedną sesję na siłowni i jedną na strzelnicy, serwer doda +0,5% dodatkowej szansy powodzenia przestępstw. Ekran Zbrodni pokazuje, kiedy combo jest aktywne. \nW przypadku przestępstw wymagających pojazdu użyj wybranego pojazdu przestępczego z garażu lub przystani. Liczy się tylko pojazd, który faktycznie znajduje się w Twoim obecnym kraju i nie jest w transporcie ani nie jest wystawiony na sprzedaż. \nZapotrzebowanie na narkotyki w przestępstwach jest podawane w gramach i odpowiada takim samym ilościom, jak stan zapasów i przechowywania narkotyków. \nJeśli przestępstwo nie może się rozpocząć z powodu braku pojazdu, niewłaściwej broni lub brakującej amunicji, komunikat o błędzie powinien teraz pokazywać prawdziwą przyczynę, a nie zwykłą ponowną próbę. \nKażda próba przestępstwa: otrzymujesz 5-15 HP obrażeń, a Poziom Pościgu wzrasta o 1-4 punkty w zależności od sukcesu lub porażki. \nSzansa na aresztowanie szybko rośnie wraz z poziomem poszukiwanego: Poszukiwany 5 = 25%, Poszukiwany 10 = 50%, Poszukiwany 18+ = maksymalnie 90%. \nPo aresztowaniu idziesz do więzienia. Zdanie = max (pożądany poziom × 10, 5) minut. Kaucja = wysokość poszukiwanego × 1000 EUR. Nawet jeśli na początku przestępstwo wydaje się zakończone sukcesem, ale zaraz potem zostaniesz złapany, ostateczny wynik nadal liczy się jako aresztowanie: wymagane narzędzia zostaną skonfiskowane, użyte narzędzie zbrodni zaginie, a pojazdy będą mogły zostać skonfiskowane. \nNiektóre przestępstwa wymagają pojazdu, narzędzia lub minimalnej rangi. Ich brak zapobiegnie rozpoczęciu przestępstwa. \nZdobyte XP podnosi Twoją rangę, odblokowując lepsze przestępstwa i wyższe nagrody. \nFBI Heat rośnie wraz z cięższymi przestępstwami. Powyżej 50 stopni FBI staje się aktywne i stwarza jeszcze większe szanse na aresztowanie.';

  @override
  String get helpTopicCrimesTips =>
      'Używaj szybkich przestępstw dla początkujących, aby zdobywać XP, czekając na duże czasy odnowienia. \nZawsze uciekaj, jeśli Twój poziom poszukiwanego jest wysoki – siedzenie w więzieniu blokuje wszystkie Twoje pętle. \nUtrzymuj HP powyżej 30 przed rozpoczęciem przestępstwa: każda próba kosztuje HP, a przy 0 HP spędzasz 3 godziny na oddziale intensywnej terapii.';

  @override
  String get helpTopicJobsCategory => 'Działania';

  @override
  String get helpTopicJobsTitle => 'Praca';

  @override
  String get helpTopicJobsSummary =>
      'Zarabiaj legalne pieniądze bez ryzyka związanego z poziomem poszukiwanym. Praca jest bezpieczniejsza niż przestępstwa, ale zapewnia niższe wypłaty.';

  @override
  String get helpTopicJobsHow =>
      'Dostępne zawody skalują się wraz z rangą i wykształceniem: lepsze zawody są droższe, ale mają też dłuższy czas odnowienia. \nCzasy odnowienia zadań skalują się w zależności od maksymalnej wypłaty: zadania niskiego poziomu około 3-5 minut, średniego poziomu około 8-12 minut, najwyższego poziomu około 17-22 minut. \nZawody mają wysoki, ale nie doskonały wskaźnik sukcesu; w przypadku niepowodzenia nie tracisz pieniędzy ani HP, ale tracisz część XP. \nWymagania na stanowisko: minimum 10 HP, głód > 20, pragnienie > 20, nie w więzieniu, nie na OIOM-ie. \nNie ma sztywnego dziennego limitu stanowisk; postęp jest sterowany przez czas odnowienia, szansę i wypłatę, a nie codzienną blokadę. \nPłaca różni się w zależności od rodzaju stanowiska i rangi. Edukacja (szkoła) może odblokować wyższe stanowiska. \nZarabiasz także XP za każde zadanie, choć mniej niż w przypadku porównywalnych przestępstw. \nWykorzystaj pracę jako niezawodną bazę przepływu środków pieniężnych, zwłaszcza gdy Twój poziom poszukiwanego jest zbyt wysoki, aby można było bezpiecznie popełnić przestępstwo.';

  @override
  String get helpTopicJobsTips =>
      'Połącz pracę i szkołę: edukacja otwiera lepsze miejsca pracy i wyższe wypłaty. \nKiedy poziom poszukiwanego przekracza 8 lub wracasz do zdrowia po oddziale intensywnej terapii, używaj zawodów zamiast przestępstw. \nPilnuj, aby głód i pragnienie nie spadły zbyt nisko: praca ze statystykami poniżej 20 po prostu się nie rozpocznie.';

  @override
  String get helpTopicTravelCategory => 'Świat';

  @override
  String get helpTopicTravelTitle => 'Podróż';

  @override
  String get helpTopicTravelSummary =>
      'Przemieszczaj się między krajami, aby uzyskać lepsze ceny rynkowe, wyjątkowe możliwości i dostęp do systemów międzynarodowych.';

  @override
  String get helpTopicTravelHow =>
      'Dostępne kraje: Holandia (start), Belgia, Niemcy, Francja, Wielka Brytania, Hiszpania, Włochy, Szwajcaria, USA, Meksyk, Kolumbia, Brazylia. \nKoszty podróży: kraj sąsiadujący 500-2000 euro, Europa → Ameryka 5000-10 000 euro, podróż międzymiastowa 10 000-20 000 euro. \nWymagania dotyczące podróży: nie w więzieniu, nie na oddziale intensywnej terapii, minimum 20 HP, dostępne fundusze na podróż. \nIlości narkotyków znajdujące się w Twoim ekwipunku są liczone jako rzeczywiste gramy na potrzeby kontroli wagi i podróży; 500 oznacza 500g, a nie 50kg. \nKażdy kraj ma inne ceny rynkowe (różnica cenowa do 300%), różne wypłaty za przestępstwa i unikalne przedmioty handlowe. \nRyzyko w transporcie: policja może zająć towar na podstawie poziomu poszukiwanego (szansa = poszukiwany × 2%, maksymalnie 80%). FBI może przejąć wszystko na arenie międzynarodowej, jeśli panuje wysoka temperatura. \nInspekcja celna ma 10% szans bazowych. Możesz przekupić (1000-5000 €) lub zostać przyłapanym na utracie 50% towarów. \nPo przybyciu na miejsce wszystkie akcje są od razu dostępne w nowym kraju. Rynki i prędkość przestępczości różnią się w zależności od lokalizacji.';

  @override
  String get helpTopicTravelTips =>
      'Zawsze łącz podróż z handlem, narkotykami lub przemytem – pusta podróż to strata pieniędzy. \nObniż poziom poszukiwanej osoby przed wyjazdem: wysoka kara znacznie zwiększa ryzyko konfiskaty na trasie. \nZaplanuj podróż powrotną z wyprzedzeniem, aby wiedzieć, co zabrać ze sobą po przyjeździe.';

  @override
  String get helpTopicCrewCategory => 'Społeczny';

  @override
  String get helpTopicCrewTitle => 'Załoga';

  @override
  String get helpTopicCrewSummary =>
      'Załóż ekipę lub dołącz do istniejących graczy, aby wspólnie dokonywać napadów, dzielić się magazynem i stać się silniejszym jako jednostka.';

  @override
  String get helpTopicCrewHow =>
      'Utworzenie załogi kosztuje 10 000 euro. Siedziba załogi określa, ilu członków może pomieścić Crew i skaluje się do 150 członków. Lider może zapraszać, kopać i rozpoczynać napady. \nKorzyści dla załogi: dostęp do dużych napadów, współdzielone miejsce do przechowywania, premia za pracę zespołową (+10% sukcesu na dodatkowego członka, maksymalnie +30%) i czat grupowy. \nNowe załogi zaczynają teraz od Kwatery Głównej załogi na poziomie 1 i wszystkich budynków magazynowych na poziomie 1, w tym magazynu gotówki, więc bank załogi i wspólny magazyn działają natychmiast. \nMagazyn samochodów załogi obsługuje teraz także motocykle, więc pojazdami lądowymi można zarządzać wspólnie z tego samego wspólnego magazynu załogi. \nKiedy członek załogi zostaje aresztowany, otrzymuje teraz powiadomienie push, że gracz jest zamknięty i czeka na pomoc. \nEkran załogi jest teraz pogrupowany w Przegląd, Kwatera główna i ulepszenia, Magazyn, Członkowie, Pokój wojenny, Misje załogi, Załogi i Czat, dzięki czemu zarządzanie jest spokojniejsze i bardziej profesjonalne. \nMisje załogi pokazują szablony poziomów, kartę aktywnego biegu i ostatnie rundy. Liderzy/współliderzy mogą rozpoczynać i rozwiązywać problemy; Odbieranie nagród i przyspieszanie czasu odnowienia odbywa się w tej samej zakładce. \nIstnieją dodatkowe misje załogi z operacjami o tematyce bankowej (nocny depozyt, sieć przeglądania, trasa pancerna, skarbiec pomocniczy, skarbiec rezerwowy i izba rozliczeniowa). Nie ma drugiej misji załogi kasyna obok Casino Ledger Raid. \nNagrody za misje załogi pochodzą z ekonomii misji po stronie serwera; Salda bankowe innych graczy nie są obciążane tymi wypłatami. \nRozpoczynając misję, możesz teraz przypisać rolę każdemu członkowi załogi (planista, egzekutor, logistyka, technik) w celu uzyskania premii zespołowych. \nKarty aktywnych i ostatnich misji pokazują teraz także wkład poszczególnych graczy wraz z wynikami i mnożnikiem wypłat. \nCzłonkowie załogi otrzymują teraz także powiadomienia push/w aplikacji dotyczące rozpoczęcia misji, wyniku misji oraz momentu, w którym czas odnowienia misji będzie ponownie gotowy. \nKiedy czas odnowienia misji jest aktywny, nie możesz rozpocząć nowej misji; najpierw poczekaj na pozostały czas odnowienia lub przyspiesz go kredytami. \nAby przyspieszyć czas odnowienia, najpierw zobaczysz dokładny koszt kredytu i pozostałe minuty, zanim potwierdzisz. \nWojny Załogów mają własną zakładkę Pokoju Wojennego na ekranie załogi. Tylko przywódcy mogą wypowiedzieć wojnę i wymagane jest uczestnictwo co najmniej 3 członków załogi. \nRodzaje wojen: Wojna zabijania, Wojna ekonomiczna, Wojna terytorialna i Wojna totalna. Każda wojna przechodzi przez etap przygotowania, fazę aktywną, zamknięcie i rozwiązanie. \nPodczas aktywnej wojny uczestnicy mogą wykonywać akcje, takie jak zabójstwa, napady, sabotaż, informacje wywiadowcze, najazdy, tarcze, wzmocnienia i przejmowanie terytoriów. Ukierunkowane akcje pozwalają teraz wybierać bezpośrednio z listy członków załogi przeciwnika, zamiast ręcznie wpisywać identyfikator gracza. \nPunkty sezonowe są sumowane w tabeli liderów Crew Wars. Pokój Wojenny pokazuje także rankingi, ostatnie akcje i ostatnie wojny Twojej załogi. \nW Territory War i Total War przejmujesz teraz prawdziwe regiony Terytoriów z systemu terytoriów, zamiast ogólnych celów zastępczych. \nTe regiony wojenne pokazują teraz także swoją wartość strategiczną w Pokoju Wojennym: bonusy za zdobycie, punkty kontrolne i znaczniki, takie jak port, stolica lub logistyka. Dzięki temu od razu staje się jasne, które regiony są warte więcej niż zwykła zamiana własności. \nCrew Wars nie wybiera już celów terytorialnych wyłącznie na podstawie poziomu wartości, ale także na podstawie znaczników strategicznych i sąsiadującego nacisku ze strony atakującego lub obrońcy. To sprawia, że ​​Wojna Terytorialna i Total War bardziej przypominają prawdziwą linię frontu niż trzy przypadkowe roszczenia. \nNapady: Mały bank (2 graczy, 40%, 10 000–30 000 euro, 30 min odnowienia), Jubiler (3 graczy, 35%, 20 000–50 000 euro, 45 min), Napad na kasyno (4 graczy, 25%, 50 000–150 000 euro, 2 godz.), Rezerwa Federalna (5 graczy, 15%, 100 000–500 000 euro, 6 godzin, +20 ciepła FBI). \nAby dokonać napadu, wszyscy członkowie muszą być online na początku. Jeśli ktoś jest nieobecny, napad kończy się niepowodzeniem. \nNieudany napad: kara więzienia dla wszystkich, poziom poszukiwanego +5, brak nagrody. \nNagroda za napad jest dzielona równo pomiędzy wszystkich uczestniczących członków. \nCzat załogi jest dostępny w celu szybkiej koordynacji. \nPostęp w sztabie załogi: im dłuższa i bardziej aktywna Crew, tym więcej wspólnych ulepszeń i wzmocnień zostaje odblokowanych.';

  @override
  String get helpTopicCrewTips =>
      'Nowe załogi mogą od razu wpłacać pieniądze i korzystać ze wspólnego magazynu; następnie skup się na ulepszeniach zapewniających większą pojemność, zamiast na oddzielnym zakupie początkowym. \nNajpierw sprawdź Pokój Wojenny, aby zobaczyć, czy twoja Crew nadal znajduje się w fazie odnowienia, zanim spróbujesz wypowiedzieć nową wojnę. \nKoordynuj wezwania do celów na czacie załogi, aby nie farmić tego samego przeciwnika i nie potrącić strażnika przeciw farmie. \nKoordynuj godziny rozpoczęcia napadów na czacie załogi, aby wszyscy byli online i nikt nie był w więzieniu. \nWybierz załogę w tej samej strefie czasowej lub schemacie aktywności, aby zwiększyć skuteczność napadów. \nSkorzystaj ze wspólnego magazynu załogi, aby oddzielić ryzykowne towary od osobistego ekwipunku.';

  @override
  String get helpTopicFriendsCategory => 'Społeczny';

  @override
  String get helpTopicFriendsTitle => 'Przyjaciele';

  @override
  String get helpTopicFriendsSummary =>
      'Zarządzaj listą znajomych, aby przyspieszyć koordynację, przeglądanie profili i opinie społecznościowe.';

  @override
  String get helpTopicFriendsHow =>
      'Strona znajomych wyświetla trzy listy: aktualnych znajomych, wysłane prośby i otrzymane prośby. \nOd znajomego możesz bezpośrednio wysłać wiadomość, wyświetlić jego profil lub rozpocząć współpracę. \nMożesz zobaczyć, kiedy znajomi są aktywni w grze, co pomaga w planowaniu napadów lub transakcji. \nZaproszenia do znajomych nie wygasają automatycznie; utrzymuj listę w porządku, aby oczekujące prośby nie rozpraszały Cię. \nPrzyjaciele spoza twojej załogi są cenni w ucieczce z więzienia (znajomy może pomóc ci się wydostać) i dzieleniu się informacjami. \nKiedy znajomy zostanie aresztowany, zaakceptowani znajomi otrzymają teraz również powiadomienie push, że gracz czeka na pomoc w więzieniu.';

  @override
  String get helpTopicFriendsTips =>
      'Dodaj znajomych, którzy podzielają Twój styl gry: partnerów do napadów, sieci handlarzy lub wsparcie przestępczości. \nPrzyjaciel, który ucieknie z więzienia, za sukces otrzyma nagrodę w wysokości 500–2000 euro. Zorganizuj to na wypadek sytuacji awaryjnych.';

  @override
  String get helpTopicMessagesCategory => 'Społeczny';

  @override
  String get helpTopicMessagesTitle => 'Wiadomości';

  @override
  String get helpTopicMessagesSummary =>
      'Twoja skrzynka odbiorcza z osobistymi wiadomościami graczy i wiadomościami systemowymi dotyczącymi nagród, zamówień i wydarzeń w grze.';

  @override
  String get helpTopicMessagesHow =>
      'Wiadomości są podzielone na rozmowy osobiste i wątek systemowy The Mob State. \nWiadomości systemowe są wysyłane automatycznie w przypadku: transakcji kryptowalutowych, realizacji zamówień, wypłat w rankingach, wyników napadów, ucieczek z więzienia i odznak za osiągnięcia. \nMożesz wysyłać wiadomości do innych graczy, jeśli pozwalają na to ich ustawienia prywatności. \nNieprzeczytane wiadomości pojawiają się jako plakietka na ikonie wiadomości i są widoczne na pulpicie nawigacyjnym. \nWiadomości nie tracą ważności i są przechowywane jako historyczny dziennik zdarzeń na koncie. \nSkorzystaj z dziennika skrzynki odbiorczej, jeśli masz wątpliwości dotyczące wypłaty, nie zrealizowanego zamówienia lub nieoczekiwanej zmiany salda.';

  @override
  String get helpTopicMessagesTips =>
      'Sprawdź swoją skrzynkę odbiorczą po długich okresach offline: nagrody, zrealizowane zamówienia i wydarzenia są tam rejestrowane. \nSkonfiguruj preferencje powiadomień w Ustawieniach, aby otrzymywać powiadomienia push tylko o naprawdę ważnych wydarzeniach.';

  @override
  String get helpTopicInventoryCategory => 'Kierownictwo';

  @override
  String get helpTopicInventoryTitle => 'Spis';

  @override
  String get helpTopicInventorySummary =>
      'Zarządzaj wszystkim, co nosisz, przechowujesz i wyposażasz: bronią, narzędziami, pojazdami, narkotykami i towarami handlowymi.';

  @override
  String get helpTopicInventoryHow =>
      'Zapasy są podzielone na przedmioty przenoszone (na tobie), przedmioty przechowywane (magazyn/przechowywanie załogi) i aktywne wyposażenie. \nWaga określa nośność. Niektóre przestępstwa lub blokady podróżne, jeśli jesteś przeciążony. \nNarkotyki są przechowywane i pokazywane w ekwipunku i magazynie w gramach; 351 oznacza 351g. \nStan przedmiotu pogarsza się wraz z użytkowaniem. Broń w złym stanie działa gorzej, a narzędzia mogą się zepsuć. \nNa górze Ekwipunku możesz także wybrać domyślną broń zbrodni. W przypadku tego wyboru liczy się tylko niesiona, użyteczna broń. \nZestawy wyposażenia pozwalają szybko przełączać się pomiędzy zestawem kryminalnym (narzędzie + broń) a zestawem podróżnym (lekkie, minimalne przedmioty wartościowe). \nPo aresztowaniu policja może skonfiskować przedmioty. Nie noś kosztowności z wysokim poziomem poszukiwanego. \nNarkotyki w inwentarzu zwiększają szansę na interwencję FBI podczas podróży międzynarodowych. \nMagazyn załogi to bezpieczne miejsce, w którym można przechowywać przedmioty, których nie ponosisz osobiście.';

  @override
  String get helpTopicInventoryTips =>
      'Trzymaj lekki ładunek podczas podróży lub prowadzenia szału przestępczego obarczonego wysokim ryzykiem aresztowań. \nKorzystaj z zestawów wyposażenia, aby zawsze mieć odpowiedni sprzęt do każdego scenariusza. \nRegularnie sprawdzaj stan przedmiotu: zepsute narzędzia po cichu blokują przestępstwa bez wyraźnego komunikatu o błędzie.';

  @override
  String get helpTopicPropertiesCategory => 'Gospodarka';

  @override
  String get helpTopicPropertiesTitle => 'Właściwości';

  @override
  String get helpTopicPropertiesSummary =>
      'Kupuj nieruchomości, aby zwiększyć pojemność magazynową, pojemność mieszkań i dostęp do niektórych systemów, takich jak Nightclub.';

  @override
  String get helpTopicPropertiesHow =>
      'Każda nieruchomość ma swoją rolę: powierzchnię magazynową, pojemność mieszkaniową czy dostęp do modułu uzupełniającego, takiego jak Nightclub. \nUlepszenia magazynu zwiększają pojemność magazynu dla przedmiotów i innych zapasów. \nDomy i mieszkania zwiększają pojemność mieszkaniową; Oprócz tego gracze VIP otrzymują dodatkowe miejsca. \nNiektóre nieruchomości są unikalne lub mają blokadę krajową: aby je kupić lub zarządzać nimi, musisz znajdować się w odpowiednim kraju. \nSprzedaż daje 70% ceny zakupu. Sprzedaż nie wymaga czasu odnowienia, sprzedaż jest natychmiastowa. \nZakupiony Nightclub otwiera oddzielny ekran zarządzania klubem nocnym; moduł ten obsługuje zarządzanie i przychody, a nie przegląd właściwości.';

  @override
  String get helpTopicPropertiesTips =>
      'Jeśli potrzebujesz więcej miejsca na inne systemy, zainwestuj w magazyn już wcześniej. \nWybierz domy i mieszkania, jeśli chcesz zbudować więcej mieszkań dla powiązanych systemów rozgrywki. \nNie sprzedawaj zbyt szybko: 70% oznacza poważną obniżkę ceny zakupu.';

  @override
  String get helpTopicBankCategory => 'Gospodarka';

  @override
  String get helpTopicBankTitle => 'Bank';

  @override
  String get helpTopicBankSummary =>
      'Wpłacaj gotówkę roboczą bezpłatnie do limitu dziennego. Większe uliczne pieniądze muszą zostać wyprane za opłatą, opóźnieniem i ryzykiem przejęcia przez FBI.';

  @override
  String get helpTopicBankHow =>
      'Darmowe depozyty są natychmiastowe i nie wiążą się z żadnymi opłatami, ale tylko do dziennego limitu, który skaluje się wraz z Twoją rangą (dzień UTC). Wypłaty pozostają bezpłatne i nieograniczone. \nPasywne oprocentowanie banku jest obecnie wyłączone. \nPieniądze w banku są chronione przed konfiskatą policyjną. Podczas aresztowania można utracić jedynie gotówkę, którą mamy pod ręką. \nHistoria transakcji pokazuje wszystkie przepływy przychodzące i wychodzące ze znacznikiem czasu, kwotą, kontrahentem przelewu i opcjonalnymi opisami. \nPranie brudnych pieniędzy: wpłać do swojego banku gotówkę powyżej darmowego limitu dziennego za opłatą i opóźnieniem. Każde pranie ma minimum i maksimum, pokazane na ekranie banku. Wyższa temperatura FBI zwiększa szansę na przejęcie; sukces nieznacznie obniża temperaturę. \nPrzestępstwo związane z napadem na bank: udaje się przy 30% i kradnie 10-30% losowego salda bankowego innego gracza. Ryzyko wysokiego poziomu poszukiwanego. \nMożliwe jest przesyłanie pieniędzy innym graczom. Opcjonalnie możesz dodać opis, a odbiorca zobaczy go także w transakcjach. Przed potwierdzeniem dokładnie sprawdź kwotę i odbiorcę.';

  @override
  String get helpTopicBankTips =>
      'Skorzystaj z bezpłatnego depozytu dziennego na niewielką gotówkę roboczą, aby była zabezpieczona przed konfiskatą.\nPraj większą gotówkę uliczną, gdy zaakceptujesz opłatę i przejmiesz ryzyko; niższa temperatura jest bezpieczniejsza.\nZachowaj niewielki kapitał obrotowy w postaci gotówki na bezpośrednie wydatki (kaucja, podróże, narzędzia).';

  @override
  String get helpTopicCasinoCategory => 'Gospodarka';

  @override
  String get helpTopicCasinoTitle => 'Kasyno';

  @override
  String get helpTopicCasinoSummary =>
      'Graj za gotówkę na automatach, blackjacku, ruletce, kościach, bakaracie i pokerze wideo. Wysoka wariancja: możesz szybko wygrać lub przegrać duże kwoty.';

  @override
  String get helpTopicCasinoHow =>
      'Dostępne gry: Automaty (niska stawka, losowa wypłata), Blackjack (liczy się strategia), Ruletka (zakłady zewnętrzne/wewnętrzne z własnymi kursami), Kości (wysoka wariancja), Bakarat (gracz/bankier/remis), Video Poker (wypłaty 5-kartowe według kolejności rąk). \nKażda gra ma minimalny zakład. Współczynniki wypłat różnią się w zależności od rodzaju gry (np. ruletka poza zakładem ~1,97x, pojedynczy numer 35x). \nKasyno używa wyłącznie gotówki, a nie salda bankowego. Zanim zaczniesz grać, upewnij się, że masz gotówkę. \nPomiędzy rundami nie ma czasu odnowienia: możesz grać tak szybko, jak chcesz. \nDuże wygrane powyżej progu mogą wywołać wydarzenie widoczne dla innych graczy. \nPrzegrane zakłady znikają na zawsze; nie ma ubezpieczenia ani wykupu.';

  @override
  String get helpTopicCasinoTips =>
      'Zawsze ustalaj limit bankrolla sesji: nigdy nie więcej niż 10% całkowitej gotówki na sesję. \nBlackjack ma najlepsze szanse dla doświadczonego gracza. Naucz się podstawowej strategii, zanim obstawisz duże zakłady. \nTraktuj kasyno jako rozrywkę, a nie dochód: przewaga kasyna zapewnia długoterminową stratę.';

  @override
  String get helpTopicBlackMarketCategory => 'Gospodarka';

  @override
  String get helpTopicBlackMarketTitle => 'Czarny rynek';

  @override
  String get helpTopicBlackMarketSummary =>
      'Jedno centrum: najpierw towary przemytnicze (kwiaty, elektronika, diamenty, broń, farmaceutyki), następnie zakładka Rynek z pojazdami między graczami, przewożonymi narzędziami, partiami narkotyków, partiami kryptowalut, stosami towarów handlowych i zbywalnymi przedmiotami wydarzeń, a także plecakami, materiałami, rynkiem broni i amunicją.';

  @override
  String get helpTopicBlackMarketHow =>
      'Zakładka Towary handlowe: jedno ciągłe przewijanie — najpierw pięć linii kontrabandy (ceny, limity, żetony ryzyka: psucie się, zmienność, obrażenia spowodowane potknięciem, zajęcie), a następnie zapasy, z których można sprzedać. Kup/sprzedaj używa interfejsu API /trade; awarie częściowego obciążenia wyświetlają baner ostrzegawczy. \nCzarny rynek dzieli się na podrynki: Materiały (surowce), Broń (broń palna i noże), Amunicja (amunicja według kalibru), Pojazdy (pojazdy nielegalne). \nCeny i dostępność różnią się znacznie w zależności od kraju i czasu. Oferta może szybko się wyprzedać. \nTransakcje na czarnym rynku nie pozostawiają oficjalnego śladu, ale zwiększają temperaturę FBI w przypadku dużych zakupów. \nBroń kupioną tutaj można wykorzystać w przestępstwach, PvP i bezpieczeństwie. Lepsza broń daje większe obrażenia i szansę na sukces. \nFiltry według kategorii (rodzaj, kraj, cena, dostępność) pomagają szybko znaleźć właściwą ofertę. \nJako sprzedający możesz publikować własne oferty, w tym cenę i ilość. Inni gracze kupują od Ciebie. \nAukcje wygasają po pewnym czasie, jeśli nie zostaną sprzedane. Monitoruj swoje oferty za pośrednictwem swojego profilu. \nKarta Rynek: transakcje gotówkowe typu peer-to-player. Jeden kanał pokazuje pojazdy oraz listy graczy dotyczące przewożonych narzędzi, stosów narkotyków (gramy + jakość), zasobów kryptowalut i zapasów towarów handlowych. Użyj opcji Sprzedaj, aby wybrać rodzaj, ustawić ilość i cenę. Moje aukcje obejmują Twoje aktywne ogłoszenia. Nie możesz kupić własnej reklamy. Escrow usuwa zapasy do czasu zakupu lub wycofania z listy.';

  @override
  String get helpTopicBlackMarketTips =>
      'Zakładka Handel: pociągnij, aby odświeżyć, jeśli segment się nie powiedzie; oglądaj ryzykowne żetony i Poszukiwany przed ryzykownym przemytem. \nKupuj broń i amunicję hurtowo, gdy ceny są niskie: dostępność jest tymczasowa. \nUnikaj dużych zakupów na czarnym rynku, gdy FBI Heat ma już powyżej 30 lat. \nRynek: odśwież po wystawieniu aukcji; wymień tylko to, co posiadasz — narzędzia muszą być przyniesione, narkotyki/krypto/towary handlowe pochodzą z Twojego ekwipunku/zasobów. Delist przywraca depozyt.';

  @override
  String get helpTopicDrugsCategory => 'Imperium';

  @override
  String get helpTopicDrugsTitle => 'Narkotyki';

  @override
  String get helpTopicDrugsSummary =>
      'Zbuduj kompletną operację leku od surowców po gotowy produkt. Prowadź łańcuchy produkcyjne, zarządzaj magazynami i sprzedawaj z wysoką marżą, ale poważnym ryzykiem.';

  @override
  String get helpTopicDrugsHow =>
      'System leków składa się z: Hubu (przegląd i statystyki), Obiektów (ulepszenie mocy produkcyjnych), Produkcji (aktywne linie produkcyjne z timerem) i Zapasów (gotowe produkty i surowce). \nKupuj surowce na czarnym rynku lub handluj. Połącz je w zakładzie produkującym leki. \nLiczniki produkcji działają, gdy jesteś offline. Nie ma potrzeby aktywnego klikania: sprawdź ponownie, gdy skończy się czas. \nUkończony produkt pozostaje widoczny w Produkcji i zajmuje miejsce w placówce, dopóki go nie odbierzesz; Funkcja automatycznego zbierania VIP przetwarza gotowe dane wyjściowe automatycznie w tle. \nPojemność magazynu jest ograniczona w zależności od obiektu. Kiedy magazyn jest pełny, produkcja zatrzymuje się automatycznie. \nSklep w ciemnej sieci lub inny obiekt nie sprzedaje automatycznie gotowych produktów: sprzedaż nadal odbywa się ręcznie, zgodnie z zamierzonym przepływem sprzedaży. \nSprzedawaj leki na czarnym rynku, w Kolumbii lub w innych specjalnych punktach sprzedaży, aby uzyskać najwyższą marżę. \nFBI Heat zwiększa każdy cykl produkcyjny i dodatkowo w przypadku dużej sprzedaży. Wysoka temperatura prowadzi do nalotów, które mogą przerwać Twoją działalność. \nModernizacje obiektów skracają czas produkcji, zwiększają wydajność i zwiększają pojemność magazynową. \nGracze VIP otrzymują przycisk błyskawicy na kartach produkcyjnych: po potwierdzeniu możesz kupić wszystkie brakujące materiały wsadowe jednym kliknięciem. \nZaawansowane ulepszenia slotów i wyposażenia są powiązane z nową ścieżką edukacyjną Narkotyki (Specjalista w dziedzinie hydroponiki, Specjalista w dziedzinie elektryki procesowej, Tajny chemik). Bez wymaganego poziomu/certyfikatu nie można przejść do następnego poziomu uaktualnienia. \nNarkotyki znajdujące się w zapasach zwiększają ryzyko konfiskaty podczas podróży i kontroli policyjnych.';

  @override
  String get helpTopicDrugsTips =>
      'Zmodernizuj pamięć masową przed rozpoczęciem produkcji: zapełnienie pamięci masowej wstrzymuje produkcję, a Ty tracisz czas produkcji. \nUtrzymuj FBI Heat poniżej 50: powyżej tego progu jesteś aktywnie ścigany z dużymi szansami na naloty, które wszystko zamykają. \nPołącz sprzedaż leków z przemytem, ​​aby uzyskać wyższe marże i rozproszone ryzyko.';

  @override
  String get helpTopicNightclubCategory => 'Imperium';

  @override
  String get helpTopicNightclubTitle => 'Klub nocny';

  @override
  String get helpTopicNightclubSummary =>
      'Prowadź Nightclub jako część swojego przestępczego imperium. Zarządzaj personelem, bezpieczeństwem i dostawami, aby uzyskać pasywny i aktywny dochód za pomocą dedykowanej tabeli liderów sezonu.';

  @override
  String get helpTopicNightclubHow =>
      'Na dole znajduje się teraz Centrum Dowodzenia Zarządzaniem Klubem Nocnym ze strefami dla załogi, przechowywania leków, dowództwa DJ-a, jednostki ochrony i laboratorium operacyjnego; wszystkie strefy działają w ramach jednego, ciągłego przepływu stron, bez dodatkowego przewijania wewnętrznego. \nEkran klubu nocnego zawiera teraz jedną centralną sekcję Intelligence, łączącą przegląd, trendy przychodów i dzienniki ryzyka bez konieczności przełączania zakładek. \nOps Lab obejmuje teraz 11 systemów: DJ-ów-rezydentów, dynamiczny kalendarz wydarzeń, drzewo ulepszeń, policyjna reakcja na upały/incydenty, kontrakty z dostawcami, profile promotorów, klientela VIP + cechy personelu, trasy przemytu, zarządzanie barem i kuchnią (napoje/jedzenie) z cenami, sabotażem konkurencji + kontrwywiadem oraz harmonogramem operacji. \nTrasy przemytu mają teraz czas odnowienia (port 60 min, lądowisko 90 min, granica 120 min), wymuszając planowanie ryzyka/czasu zamiast nieskończonego spamu. \nDrzewo ulepszeń jest interaktywne: wybierz Sound Rig, VIP Lounge lub Surveillance i kup bezpośrednio następny poziom z widocznymi kosztami ulepszeń. \nPrzychód generowany jest na każdy tick w oparciu o jakość DJ-a, obłożenie i dostępność dostaw. Brakująca podaż bezpośrednio zmniejsza dochód. \nUmowy z DJ-ami kończą się automatycznie o skonfigurowanej godzinie zakończenia; po tym czasie musisz zarezerwować ponownie, aby uzyskać nowe wzmocnienia. \nW przypadku niewystarczającego bezpieczeństwa mogą wystąpić zdarzenia (bójki, kradzieże). To szkodzi punktacji i dochodom odwiedzających. \nKażdy sezon ma tabelę liderów. Gracze z najwyższymi łącznymi przychodami z klubu nocnego wygrywają nagrody sezonowe. \nSynergia z lekami: własna produkcja leków może służyć jako podaż, podnosząc marże. \nPrzechowywanie leków opiera się na gramach: przy każdym wyborze wyświetlana jest dostępna gramatura przed przeniesieniem zapasów do magazynu klubu nocnego. \nDziałania rywali opierają się na nazwie: przed wybraniem akcji wyszukujesz rywalizujące kluby według nazwy gracza (nie jest wymagany identyfikator gracza). \nSynergia z prostytucją: połączone wydarzenia zapewniają dodatkową odwiedzalność i wyższe przychody. \nUlepszenia zwiększają pojemność, miejsce do przechowywania zapasów oraz maksymalną liczbę DJ-ów i strażników, których możesz rozmieścić.';

  @override
  String get helpTopicNightclubTips =>
      'Zawsze dbaj o zapasy: jeden znacznik braku podaży może spowodować spadek liczby odwiedzających, po którym trudno będzie się odbudować. \nZarezerwuj najlepszego DJ-a, na jakiego Cię stać: jakość DJ-a ma największy bezpośredni wpływ na przychody na tik. \nCodziennie sprawdzaj tabelę liderów sezonu i zwiększaj podaż oraz DJ-ów, jeśli chcesz znaleźć się w pierwszej dziesiątce.';

  @override
  String get helpTopicCryptoCategory => 'Gospodarka';

  @override
  String get helpTopicCryptoTitle => 'Krypto';

  @override
  String get helpTopicCryptoSummary =>
      'Handluj 30 prawdziwymi kryptowalutami. Kupuj i sprzedawaj bezpośrednio lub automatyzuj za pomocą zleceń z limitem, stop-loss i take-profit. Ceny podążają teraz za kotwicami rynku na żywo z dodatkowymi systemami i wiadomościami w grze, a wyskakujące okienko monety wykorzystuje oddzielne pola dla transakcji bezpośrednich i otwartych zleceń.';

  @override
  String get helpTopicCryptoHow =>
      'Lista kryptowalut pokazuje 30 monet z aktualną ceną, 24-godzinnym procentem i bieżącym stanem posiadania każdej monety. Baza cenowa opiera się na bieżących danych rynkowych, ale nadal mają na nią wpływ reżimy w grach i aktualności. \nKliknij monetę, aby otworzyć wyskakujące okienko z: wykresem na żywo (filtry czasowe 1h, 4h, 8h, 24h, 7d, 30d, All), historią zakupów, średnią ceną zakupu i formularzem kupna/sprzedaży. \nHandel bezpośredni: wprowadź ilość i kliknij Kup lub Sprzedaj. Podczas sprzedaży możesz nacisnąć „WSZYSTKO”, aby natychmiast wypełnić całą pozycję. Realizacja następuje natychmiast po aktualnej cenie rynkowej. \nZlecenia otwarte: Limit (kupno/sprzedaż po dokładnej cenie docelowej), Stop-loss (automatyczna sprzedaż, gdy cena spadnie do progu), Take-profit (automatyczna sprzedaż, gdy cena wzrośnie do docelowej). Ta sekcja ma teraz własne pole ilości i własne pole ceny docelowej. \nOtwarte zlecenia są realizowane automatycznie przez backend, gdy tylko cena rynkowa osiągnie cel. Nie musisz być online. \nReżimy rynkowe (byk/niedźwiedź/boki) i wydarzenia informacyjne wpływają na ruchy cen. Otrzymujesz powiadomienia systemowe za pośrednictwem push, gdy są włączone. \nCotygodniowa tabela liderów kryptowalut: gracz z najwyższym zrealizowanym zyskiem w tym tygodniu wygrywa nagrodę pieniężną. \nMisje dzienne i cotygodniowe (np. 3 dochodowe transakcje, dywersyfikacja w ramach 5 monet) dają dodatkowe nagrody po ukończeniu. \nPrzegląd portfela pokazuje: całkowitą wartość, zainwestowaną kwotę, niezrealizowany i zrealizowany zysk/stratę.';

  @override
  String get helpTopicCryptoTips =>
      'Przed złożeniem zlecenia sprzedaży sprawdź swoją historię zakupów: wyskakujące okienko pokazuje średnią cenę zakupu, dzięki czemu przypadkowo nie sprzedasz ze stratą. \nUżywaj zleceń stop-loss na każdej pozycji, której aktywnie nie obserwujesz: chronią Cię automatycznie, gdy jesteś offline. \nPrzełącz filtry czasu na wykresie: 1h i 4h pokazują trend krótkoterminowy, 7d i 30d pokazują szerszy obraz.';

  @override
  String get helpTopicSmugglingCategory => 'Imperium';

  @override
  String get helpTopicSmugglingTitle => 'Przemyt';

  @override
  String get helpTopicSmugglingSummary =>
      'Przemieszczaj nielegalne towary i pojazdy między krajami. Wybierz kanał komercyjny lub skorzystaj z własnego pojazdu lub samolotu, aby obniżyć koszty i zwiększyć ryzyko konfiskaty.';

  @override
  String get helpTopicSmugglingHow =>
      'Wybierz kategorię, konkretny przedmiot, miejsce docelowe, a następnie zdecyduj pomiędzy kanałem komercyjnym lub własnym transportem. \nPosiadane samochody, motocykle, łodzie i samoloty wyświetlają teraz wycenę na żywo z miejscami na ładunek, niższymi kosztami i redukcją ryzyka. \nŁódź może przewozić samochody i motocykle; samolot nie może przewozić łodzi i natychmiast zwróci błąd. \nSzansa na sukces zależy od wybranego kanału lub posiadanego transportu, aktualnego Poziomu Poszukiwania i wielkości przesyłki. \nW przypadku niepowodzenia tracisz całą przesyłkę. Brak zwrotu pieniędzy. Zniknęły koszty ładunku i transportu. \nJeżeli korzystasz z własnego transportu, a przejazd się nie powiedzie, sam środek transportu również może zostać skonfiskowany. \nAktywne przesyłki są śledzone na żywo w formie przeglądu. Po przybyciu na miejsce ładunek pojawia się w magazynie gotowy do odbioru. \nSieć załogi pozostaje dostępna dla komercyjnych przesyłek załogi, ale posiadany transport jest wyłącznie osobisty.';

  @override
  String get helpTopicSmugglingTips =>
      'Nigdy nie wysyłaj całego towaru w jednej przesyłce: podziel go na wiele mniejszych ładunków, aby ograniczyć katastrofalne straty. \nObniż poziom listu gończego i temperaturę FBI do minimum, zanim rozpoczniesz duży przemyt. \nDo kosztownych rejsów używaj najlepszego samolotu lub łodzi: niższy koszt pomaga, ale o ryzyku nadal decydują miejsca na ładunek i ryzyko konfiskaty. \nZawsze zbieraj aktywne magazyny tak szybko, jak to możliwe: zawartość przeterminowanych magazynów zostanie trwale utracona.';

  @override
  String get helpTopicToolsCategory => 'Kierownictwo';

  @override
  String get helpTopicToolsTitle => 'Narzędzia';

  @override
  String get helpTopicToolsSummary =>
      'Kupuj narzędzia potrzebne do określonych przestępstw i zarządzaj nimi. Dobre narzędzia zwiększają szansę na sukces, zużyte narzędzia ją zmniejszają.';

  @override
  String get helpTopicToolsHow =>
      'W narzędziowni wyświetlane są wszystkie dostępne przedmioty wraz z ceną, stanem i rodzajem przestępstwa, do jakiego są potrzebne. \nKażda kategoria przestępstw ma preferowane narzędzia: włamanie wymaga łomu lub kilofa, kradzież samochodu wymaga zestawu do podłączenia gorącego drutu, rabunek wymaga broni palnej. \nNarzędzia mają ocenę stanu (0-100%). Każde udane lub nieudane przestępstwo obniża stan o kilka procent. \nPoniżej 20% warunku premia za szansę powodzenia narzędzia drastycznie spada. Poniżej 5% narzędzie nie ma prawie żadnego efektu. \nNaprawione narzędzia w warsztacie kosztują ułamek ceny zakupu. Wymiana jest czasami tańsza niż naprawa mocno zużytych narzędzi. \nNarzędzia widoczne są w zakładce ekwipunku. Możesz zachować wiele kopii tego samego typu co kopia zapasowa.';

  @override
  String get helpTopicToolsTips =>
      'Kupuj narzędzia hurtowo, gdy są tanie na czarnym rynku: oszczędzasz w porównaniu do sklepu. \nUstaw osobisty próg: zawsze wymieniaj narzędzia, gdy stan spadnie poniżej 25%, aby utrzymać stabilne szanse na sukces.';

  @override
  String get helpTopicCourtCategory => 'Ryzyko';

  @override
  String get helpTopicCourtTitle => 'Sąd';

  @override
  String get helpTopicCourtSummary =>
      'W trakcie odbywania kary możesz złożyć apelację lub spróbować przekupić sędziego, aby mógł szybciej wyjść na wolność.';

  @override
  String get helpTopicCourtHow =>
      'Kiedy przebywasz w więzieniu, ekran sądu pokazuje Twój aktywny wyrok skazujący wraz z pozostałym czasem, przestępstwem i profilem sędziego. \nApelacja kosztuje, biorąc pod uwagę aktualną długość wyroku. Jeśli zostanie przyznany, Twoja kara jest zwykle zmniejszana o około 20-40%. \nMożesz odwołać się tylko raz na dany wyrok, a w przypadku szybkich ponownych prób obowiązuje okres odnowienia. \nPrzekupstwo wykorzystuje kwotę wybraną przez gracza. Kwota ta jest zawsze odejmowana, nawet jeśli próba się nie powiedzie. \nWyższa kwota łapówki zwiększa szansę na sukces. W przypadku powodzenia zostajesz natychmiast zwolniony. \nW Twojej kartotece karnej znajdują się wcześniejsze wyroki skazujące wraz z datami i szczegółami historii sądowej, nawet jeśli nie przebywasz już w więzieniu. \nSkuteczna łapówka dla sędziego powoduje usunięcie z rejestru karnego tylko aktualnego wyroku skazującego. \nJeśli chcesz wymazać swój pełny rejestr karny, musisz to zrobić poza sądem, korzystając z przestępstwa Wyczyść rejestr karny w późnej fazie gry.';

  @override
  String get helpTopicCourtTips =>
      'Odwołaj się najpierw w przypadku długich wyroków: tam oczekiwana oszczędność czasu jest najwyższa. \nUżywaj przekupstwa tylko przy wystarczającym buforze gotówkowym, ponieważ płatność jest zawsze potrącana.';

  @override
  String get helpTopicHitlistCategory => 'Ryzyko';

  @override
  String get helpTopicHitlistTitle => 'Lista hitów';

  @override
  String get helpTopicHitlistSummary =>
      'Wyznacz nagrodę za wroga lub zaakceptuj kontrakt na trafienie. Wyeliminuj swój cel w tym samym kraju, aby uzyskać pełną wypłatę.';

  @override
  String get helpTopicHitlistHow =>
      'Za pomocą listy trafień dodajesz gracza, ustalając nagrodę. Minimalna nagroda wynosi 5000 €. Płatnik natychmiast traci te pieniądze. \nJeśli wyznaczona zostanie nagroda, natychmiast otrzymasz powiadomienie push i wiadomość w skrzynce odbiorczej z Biura Hitlist. \nAktywne trafienia są widoczne dla wszystkich graczy. Im wyższa nagroda, tym większą uwagę przyciąga kontrakt. \nDochodzenia detektywistyczne nie zwracają już natychmiastowych informacji: raporty docierają później za pośrednictwem wiadomości z Biura Detektywistycznego (szybka 1 godzina 1 000 000 euro, standardowa 6 godzin 500 000 euro, powolna 24 godziny 250 000 euro). \nJeśli zginiesz przez listę trafień, otrzymasz wiadomość od Biura Hitlist z przyciskiem umożliwiającym rozpoczęcie śledztwa w sprawie zabójcy w ciągu 24 godzin. \nJeśli złożysz wniosek o dochodzenie szybko po morderstwie, raport detektywistyczny dotrze szybciej. Dłuższe oczekiwanie oznacza większe opóźnienie raportu. \nAby wykonać trafienie, musisz znajdować się w tym samym kraju, co cel. Atakujesz poprzez profil gracza. \nWalka jest obliczana automatycznie na podstawie: broni, pancerza, statystyk (siła, refleks), bonusów załogi i poziomu aktywności. \nPo pomyślnej eliminacji otrzymasz pełną nagrodę. Jeśli atak się nie powiedzie, tracisz HP, a cel przeżyje. \nPo udanym trafieniu cel otrzymuje twardy reset postępu konta: zasoby i postępy zostają zresetowane do stanu bazowego, podczas gdy saldo bankowe i przywództwo załogi zostają zachowane. Oprócz nagrody otrzymujesz część dostępnego łupu. \nPo udanym zabiciu natychmiast otrzymasz wiadomość od Biura Hitlist z wyszczególnieniem nagród i łupów (gotówka + przedmioty). \nCele z aktywnym ochroniarzem lub ochroną są trudniejsze do trafienia. \nMożesz usunąć swoje imię i nazwisko z listy trafień, płacąc umieszczającemu lub samodzielnie wykupując nagrodę.';

  @override
  String get helpTopicHitlistTips =>
      'Codziennie sprawdzaj listę hitów: wysokie nagrody za słabych graczy to szybki zysk, jeśli jesteś w tym samym kraju. \nWyznaczaj nagrodę za gracza tylko wtedy, gdy masz powody sądzić, że jest on offline lub ma mało HP.';

  @override
  String get helpTopicSecurityCategory => 'Ryzyko';

  @override
  String get helpTopicSecurityTitle => 'Bezpieczeństwo';

  @override
  String get helpTopicSecuritySummary =>
      'Chroń swoją postać i imperium za pomocą zbroi, ochroniarzy i zabezpieczeń instalacji. Lepsze bezpieczeństwo oznacza mniejsze obrażenia odniesione podczas ataków.';

  @override
  String get helpTopicSecurityHow =>
      'Rodzaje zbroi o rosnącej sile: Lekki pancerz → Ciężki pancerz → Kamizelka kuloodporna → Strój taktyczny. \nMożesz nosić tylko 1 zbroję na raz; jeśli kupisz inną kamizelkę, natychmiast zastąpi ona twoją obecną zbroję. \nKażda klasa pancerza zmniejsza otrzymywane obrażenia przy ataku o ustalony procent. Lepszy pancerz = większe przeżycie w PvP i rajdach. \nPancerz ulega uszkodzeniu po ataku i traci skuteczność. Im niższy stan, tym mniejszą ochronę zapewnia twój obecny pancerz. \nPrzy 100% obrażeń twój pancerz ulega zniszczeniu i całkowicie znika; aby odzyskać ochronę, musisz kupić nowy zestaw. \nOchroniarze dają każdemu ochroniarzowi +10 do obrony, ale co 24 godziny pobierają 10 000 euro dziennej pensji za ochroniarza. \nJeśli nie jesteś w stanie zapłacić dziennej pensji ochroniarza, wszyscy oni odejdą, a ty natychmiast stracisz ich ochronę. \nBezpieczeństwo instalacji (Nightclub, apteka itp.) zmniejsza ryzyko nalotu i incydentu w tej konkretnej lokalizacji. \nIm wyższy poziom Poszukiwanego, tym częściej jesteś atakowany lub napadany. Lepsze bezpieczeństwo rekompensuje to bezpośrednio. \nCzłonkowie załogi mogą dzielić role zabezpieczeń, aby jednocześnie obsługiwać wiele lokalizacji.';

  @override
  String get helpTopicSecurityTips =>
      'Zawsze noś co najmniej lekką zbroję, gdy poziom poszukiwania wynosi 2 lub więcej: oszczędności na rachunkach szpitalnych szybko rekompensują cenę zakupu. \nSprawdzaj stan swojego pancerza po każdym ataku: uszkodzona kamizelka zapewnia tylko część swojej pierwotnej ochrony. \nZatrzymaj tylko tylu ochroniarzy, na ilu cię jutro będzie stać; duże zespoły szybko stają się kosztowne w codziennym utrzymaniu.';

  @override
  String get helpTopicHospitalCategory => 'Powrót do zdrowia';

  @override
  String get helpTopicHospitalTitle => 'Szpital';

  @override
  String get helpTopicHospitalSummary =>
      'Odzyskuj HP po walkach, nieudanych przestępstwach lub najazdach. Szpital oferuje bezpłatną opiekę w nagłych przypadkach i płatne zabiegi umożliwiające szybszy powrót do zdrowia.';

  @override
  String get helpTopicHospitalHow =>
      'Jeśli spadniesz poniżej 10 HP, zostaniesz automatycznie przyjęty na pogotowie (ER). Jest to bezpłatne, ale trwa dłużej. \nPłatne leczenie kosztuje 10 000 € za sesję i przywraca +30 HP. Czas odnowienia: 60 minut pomiędzy płatnymi zabiegami. \nOIOM (Intensywna Terapia) to najcięższa metoda leczenia krytycznych uszkodzeń. Czas odnowienia: 180 minut. Koszty są wyższe, ale powrót do zdrowia jest pełniejszy. \nMając wyższe HP (50+) nadal możesz wykonywać akcje, ale jesteś bardziej podatny na ataki. \nPodczas Twojego pobytu w więzieniu leczenie szpitalne jest zablokowane. Najpierw wyjdź, a potem szukaj leczenia. \nŚwiadectwo ukończenia szkoły medycznej obniża koszty leczenia w szpitalu i przyspiesza czas rekonwalescencji. \nMedycy załogi lub umiejętności medyczne mogą przywrócić HP poza szpitalem w ramach awaryjnego odzyskiwania.';

  @override
  String get helpTopicHospitalTips =>
      'Nigdy nie wracaj do zdrowia w połowie drogi: poczekaj na pełne HP, zanim podejmiesz PvP lub przestępstwa wysokiego ryzyka. \nZabiegi płatne czasowo w okresie odnowienia: rozpocznij leczenie tuż przed przejściem w tryb offline, aby wrócić do trybu online z pełnym HP.';

  @override
  String get helpTopicPrisonCategory => 'Powrót do zdrowia';

  @override
  String get helpTopicPrisonTitle => 'Więzienie';

  @override
  String get helpTopicPrisonSummary =>
      'Odbądź karę pozbawienia wolności, zapłać kaucję lub spróbuj uciec. Im wyższy poziom Wanted, tym dłuższy i droższy wyrok.';

  @override
  String get helpTopicPrisonHow =>
      'Po aresztowaniu rozpoczyna się odliczanie czasu w zależności od poziomu poszukiwanego. Poszukiwany stopień 1 = krótki wyrok (w minutach), Poszukiwany stopień 5+ = godziny więzienia. \nKaucja jest skalowana wraz z pozostałym wyrokiem i nigdy nie spada poniżej poziomu poszukiwanego × 1000 EUR. Dłuższe wyroki są zatem droższe w przypadku natychmiastowego wykupienia. \nUcieczka: możesz podjąć próbę ucieczki z więzienia, ale szansa na sukces jest niska. Niepowodzenie przedłuża karę o stałą kwotę. \nNa liście więzień i nakładce więzienia możesz zawsze zapłacić własną kaucję, a także podjąć próbę własnej ucieczki, będąc jeszcze w więzieniu. \nCzłonkowie załogi mogą cię odwiedzać i zapewniać drobne korzyści (statystyki, morale), gdy jesteś zamknięty. \nPo aresztowaniu Twoi przyjaciele i członkowie załogi otrzymają teraz powiadomienie push, że zostałeś złapany i czekasz na pomoc. \nBroń i zbroje są konfiskowane w momencie aresztowania, jeśli nie masz dla nich ochrony prawnej. \nOpcja sądowa: zwrócić się do sądu o zmniejszenie kary za pośrednictwem prawnika (patrz Sąd). \nPo zablokowaniu liczniki produkcji (leki, fabryka amunicji) działają. Twoje imperium działa bez ciebie. \nW zamknięciu nie można odwiedzać szpitala. Odzyskiwanie HP czeka, aż będziesz wolny.';

  @override
  String get helpTopicPrisonTips =>
      'Sprawdź kaucję natychmiast po aresztowaniu: przycisk powinien pozostać widoczny tak długo, jak długo przebywasz w więzieniu, nawet jeśli Twój poziom ścigania już spadł. \nWłącz liczniki czasu produkcji tuż przed wykonaniem przestępstwa obarczonego wysokim ryzykiem: jeśli zostaniesz złapany, produkcja i tak będzie kontynuowana.';

  @override
  String get helpTopicVaultCategory => 'Wydarzenia';

  @override
  String get helpTopicVaultTitle => 'Złam skarbiec';

  @override
  String get helpTopicVaultSummary =>
      'Miesięczny sezon skarbca: wprowadź 4-cyfrowy kod i przyznaj środki, aby zyskać szansę na duże nagrody.';

  @override
  String get helpTopicVaultHow =>
      'Każdego miesiąca nowy sezon rozpoczyna się pierwszego i kończy ostatniego dnia miesiąca. \nWybierz stawkę (np. 1/3/5 kredytów) i wprowadź 4-cyfrowy kod. \nKod można również wprowadzić za pomocą klawiatury ekranowej (przyciski cyfrowe). \nKażda próba kosztuje kredyty. Jeśli odgadniesz poprawnie, wygrasz nagrodę. \nWyższe stawki oznaczają większe nagrody; czasami nagroda VIP może spaść. \nJeśli jesteś już VIPem, nagroda VIP zostanie zamieniona na kredyty. \nMożesz zobaczyć swoje błędne kody z tego miesiąca. Lista resetuje się automatycznie wraz z nowym miesiącem.';

  @override
  String get helpTopicVaultTips =>
      'Wybierz stawkę odpowiadającą Twojemu saldu kredytowemu: możesz próbować nieograniczoną liczbę razy, ale każda próba kosztuje kredyty. \nUżyj listy błędnych kodów, aby uniknąć ponownego wypróbowania tego samego kodu.';

  @override
  String get helpTopicGarageCategory => 'Aktywa';

  @override
  String get helpTopicGarageTitle => 'Garaż';

  @override
  String get helpTopicGarageSummary =>
      'Kradnij i zarządzaj samochodami i motocyklami w celach przestępczych i przemytu. Garaż zajmuje się własnością, naprawami terminowymi, sprzedażą i złomowaniem; transport przebiega przez Hub Przemytu.';

  @override
  String get helpTopicGarageHow =>
      'Twój garaż pokazuje samochody i motocykle ze stanem (0-100%), paliwem, wartością rynkową, rzadkością i statusem światowej czołówki. \nPrzechowalnie samochodów i motocykli są teraz oddzielone: ​​samochody wykorzystują pojemność garażu, motocykle korzystają z przestrzeni przechowywania motocykli. \nUlepszenia miejsca do przechowywania samochodów i motocykli są niezależne w zależności od kraju: ulepszanie samochodów nie zwiększa pojemności motocykli (i odwrotnie). Ulepszenia są zależne od rangi; gdy twoja ranga jest zbyt niska, zobaczysz blokadę/podpowiedź. Na poziomie 5 przycisk aktualizacji jest ukryty. \nZa pomocą przycisku katalogu możesz wyświetlić wszystkie samochody i motocykle, które można ukraść, w tym ich najpopularniejsze kraje i pełną listę krajów odrodzenia. \nKradzież dotyczy pojazdu z wymaganiami dotyczącymi rangi i czasem odnowienia. Im droższe i rzadsze, tym mniejsza szansa na sukces. \nJeśli limit świata modelu jest pełny, nie możesz tymczasowo ukraść tego modelu. Kiedy kopia zostanie sprzedana lub zezłomowana, 1 miejsce zostaje natychmiast ponownie otwarte. \nNieudana kradzież zwiększa poziom poszukiwanego i może spowodować aresztowanie. Jeśli policja złapie Cię podczas ucieczki, trafisz do więzienia, a skradziony pojazd zostanie natychmiast skonfiskowany. \nNaprawa odbywa się w określonym czasie: płacisz z góry, pojazd zostaje przydzielony do naprawy i wraca dopiero po upływie określonego czasu. \nJednoczesne naprawy są ograniczone łącznie do samochodu, motocykla i łodzi: bez aktywnego VIP max 1, z aktywnym VIP max 2. \nZłomowanie jest alternatywą dla sprzedaży: otrzymujesz wartość z odzysku (35% wartości bazowej), skalowaną według stanu i premię za ulepszenie garażu. \nVehicle Ops Intelligence dodaje 6 dodatkowych opcji. W skrócie: \n1) Bieg w Hotspot: szybka akcja pozwalająca uzyskać bezpośrednią gotówkę, z własnym czasem odnowienia i dodatkowym ryzykiem. \n2) Rynek części: ceny części czynnych według typu (samochód/motocykl/łódź) do tuningu; ceny odświeżają się okresowo. \n3) Operacja załogi: akcja w trybie współpracy z załogą w celu uzyskania dodatkowych korzyści/przewag (tylko jeśli jesteś w załodze). \n4) Ciepło: według typu (samochód/motocykl/łódka) licznik „uwagi”; wyższa temperatura sprawia, że ​​działania są bardziej ryzykowne i zmniejszają szansę na sukces. Ciepło zanika powoli. \n5) Kontrakt Chop: oddaj kwalifikujący się pojazd ze swojego ekwipunku, aby otrzymać stałą wypłatę w ramach kontraktu. \n6) Schemat działania policji: pory dnia mogą zwiększyć liczbę kontroli; wpływa to na ryzyko (np. strajk w porcie/blokada statków). \nW napadzie na pojazd samochód/motocykl/łódka korzystają teraz z jednego poziomu poleceń: wybierz kategorię za pomocą trzech kart pasów u góry, bez drugiego dodatkowego rzędu zakładek. \nKażda karta linii zawiera bezpośrednie, szybkie akcje umożliwiające kradzież i ulepszenia magazynu, więc nie musisz najpierw przewijać do oddzielnych przycisków podrzędnych. \nGdy trwa czas odnowienia kradzieży, obok licznika czasu pojawia się ikona błyskawicy: dotknij jej, aby wydać kredyty i wyczyścić czas odnowienia. Możesz wyłączyć okno dialogowe potwierdzenia; włącz go ponownie w Ustawieniach w obszarze Czas odnowienia kradzieży (kredyty). \nKarty pasów pokazują teraz także bezpośrednio pojemność według typu (wykorzystana/całkowita + poziom ulepszenia). \nSkradzione pojazdy są teraz renderowane jako karty responsywne: telefon komórkowy wyświetla jedną w rzędzie, tablet/komputer stacjonarny wyświetla wiele kart obok siebie. \nNowa warstwa operacji: okna przechwytywania PvP dla hotspotów, premie za rolę załogi w operacjach załogi, odblokowanie reputacji według typu pojazdu, regionalne wydarzenia na czarnej liście i umowy ubezpieczenia kontrabandy. \nNowe rozszerzenia Operacji Pojazdowych: misje KontrPrzechwytywania, dobieranie członków załogi z sezonową drabinką, modyfikatory kraju (inflacja/korupcja/strajk w porcie) oraz tablica kontraktów z cotygodniowymi legendarnymi kontraktami. \nOps pokazuje teraz na żywo czas odnowienia każdej akcji. Timery odliczają w widoczny sposób i odświeżają się automatycznie. \nAkcje załogi (operacja załogi i mecz załogi) są dostępne tylko wtedy, gdy należysz do załogi; bez załogi otrzymasz wyraźną wskazówkę dotyczącą odblokowania. \nUdane akcje operacyjne wpłacają gotówkę bezpośrednio do Twojego portfela. Przegląd akcji pokazuje oczekiwany rodzaj wypłaty na przycisk. \nRoszczenia ubezpieczeniowe są teraz rozpatrywane w pierwszej kolejności; korzystanie ze sporu dotyczącego roszczeń umożliwia ubieganie się o dodatkową wypłatę z ryzykiem odrzucenia. \nCiepło wyższej kategorii zmniejsza szanse powodzenia kradzieży i zwiększa ryzyko hotspotu. Ciepło zanika stopniowo co godzinę. \nKontrakty Chop-Shop wymagają kwalifikującego się pojazdu z Twojego magazynu; składający wniosek zużywa ten pojazd i wypłaca gotówkę wynikającą z umowy. \nTransport pojazdów nie odbywa się już w garażu; skorzystaj z przepływu centrum przemytu. \nOdsprzedaż i złomowanie uwalnia pojemność samochodu lub motocykla i może ponownie otworzyć miejsca na świecie dla tego modelu. \nPojazdy przeznaczone wyłącznie na wydarzenie, takie jak policyjne przechwytywacze, pozostają zamknięte poza oknami wydarzenia.';

  @override
  String get helpTopicGarageTips =>
      'Aktywnie kradnij pojazdy, gdy poziom Poszukiwania jest niski: wyższy Poszukiwany = większa szansa niepowodzenia podczas kradzieży. \nZawsze utrzymuj co najmniej jeden niezawodny pojazd w dobrym stanie na potrzeby przemytu: zepsuty pojazd zmniejsza o połowę Twoje szanse na sukces. \nUżyj złomowania mocno uszkodzonych pojazdów jako szybkiego resetu wydajności; sprzedaż jest często lepsza w dobrym stanie.';

  @override
  String get helpTopicMarinaCategory => 'Aktywa';

  @override
  String get helpTopicMarinaTitle => 'Marina';

  @override
  String get helpTopicMarinaSummary =>
      'Zarządzaj łodziami o rzadkości, limitach światowych i licznikach czasu napraw dla morskich szlaków przemytniczych. Marina koncentruje się na własności, konserwacji, sprzedaży i złomowaniu; transport przebiega przez Hub Przemytu.';

  @override
  String get helpTopicMarinaHow =>
      'Marina pokazuje Twoje łodzie ze stanem, paliwem, wartością rynkową, rzadkością i statusem światowej czołówki każdego modelu. \nZa pomocą przycisku katalogu możesz wyświetlić wszystkie łodzie, które można ukraść, w tym najpopularniejsze kraje i pełną listę krajów odrodzenia. \nKradzież łodzi ma swoje własne bramy rang i czasy odnowienia. Droższe łodzie są trudniejsze do kradzieży, ale mogą być bardziej opłacalne. \nJeśli limit świata modelu łodzi jest pełny, tymczasowo znika z dostępnej listy. Sprzedaż/złomowanie ponownie otwiera miejsca. \nNaprawa odbywa się w określonym czasie: płacisz z góry, a łódź jest niedostępna do czasu zakończenia odliczania czasu. \nJednoczesne naprawy są ograniczone łącznie do samochodu, motocykla i łodzi: bez aktywnego VIP max 1, z aktywnym VIP max 2. \nZłomowanie zapewnia wartość odzysku (35% wartości bazowej), skalowaną z premią za stan i ulepszenie mariny. \nMarina zarządza wyłącznie własnością i konserwacją; Rzeczywista trasa transportu odbywa się w Hubie Przemytu. \nŁodzie policyjne przeznaczone wyłącznie na imprezy są przeznaczone na imprezy tymczasowe i pozostają zamknięte poza oknami wydarzeń.';

  @override
  String get helpTopicMarinaTips =>
      'Zainwestuj w marinę, jeśli Twoje szlaki przemytnicze regularnie prowadzą przez wodę: mniejsze zainteresowanie policji może znacznie zwiększyć szansę na sukces. \nUtrzymuj łódź motorową w dobrym stanie jako szybką alternatywę, gdy lądowe drogi ewakuacyjne są zablokowane. \nZłomuj mocno uszkodzone łodzie o niskiej wartości odsprzedaży, aby szybciej zwolnić miejsce na górze świata i pojemność mariny.';

  @override
  String get helpTopicTuneshopCategory => 'Aktywa';

  @override
  String get helpTopicTuneshopTitle => 'Sklep tuningowy';

  @override
  String get helpTopicTuneshopSummary =>
      'Użyj odzyskanych części, aby ulepszyć pojazdy według kategorii. Popraw prędkość, niewidzialność i pancerz dzięki kosztom poziomów skalowania i czasom odnowienia kategorii.';

  @override
  String get helpTopicTuneshopHow =>
      'Części zdobywasz poprzez złomowanie pojazdów: części samochodowe, części motocyklowe i części łodzi. \nCzęści są łączone w kategoriach: każdy pojazd w tej samej kategorii korzysta z tego samego zapasu części. \nKażde ulepszenie kosztuje części i pieniądze. Koszty pieniężne zależą od kategorii i rosną wraz z poziomem dostrojenia. \nMożesz ulepszyć trzy statystyki: prędkość, ukrywanie się i zbroję. \nStrojenie odbywa się dla każdego pojazdu w Twoim ekwipunku. Nowe pojazdy ponownie zaczynają od poziomu 0. \nPo każdej melodii następuje czas odnowienia dla każdego pojazdu: samochód 180 s, motocykl 120 s, łódź 240 s. \nJednoczesne strojenie jest ograniczone: bez VIP-a maksymalnie 1 aktywny pojazd w tuningu, z VIP-em maksymalnie 5. \nDostrojone pojazdy zapewniają wyższą wartość sprzedaży i odzysku. \nStrojenie jest zablokowane podczas naprawy lub transportu pojazdu.';

  @override
  String get helpTopicTuneshopTips =>
      'Najpierw złomuj mocno uszkodzone pojazdy, aby szybko zbudować części. \nZainwestuj w stealth już na wczesnym etapie, aby zmniejszyć ryzyko przechwycenia podczas ryzykownych wypraw. \nUżywaj ulepszeń pancerza w pojazdach, które wielokrotnie rozmieszczasz w niebezpiecznych pętlach.';

  @override
  String get helpTopicShootingRangeCategory => 'Szkolenie';

  @override
  String get helpTopicShootingRangeTitle => 'Strzelnica';

  @override
  String get helpTopicShootingRangeSummary =>
      'Popraw swoją celność i umiejętności posługiwania się bronią poprzez ustrukturyzowane ćwiczenia strzeleckie. Wyższe statystyki zwiększają obrażenia i szansę na trafienie w PvP i przestępstwach.';

  @override
  String get helpTopicShootingRangeHow =>
      'Strzelnica oferuje wiele dyscyplin: pistolet, karabin, strzelbę i ogień automatyczny. Każdy trenuje odrębną umiejętność związaną z bronią. \nKażda sesja treningowa ma czas odnowienia wynoszący 30 minut. Nie da się trenować w nieskończoność dziennie. \nWyższa celność zwiększa szansę na trafienie w walkach PvP i zmniejsza ryzyko, że sam zostaniesz trafiony. \nUmiejętność broni określa również, jakiej broni możesz skutecznie używać: karabin snajperski wymaga pewnych umiejętności, zanim uzyskasz pełną premię. \nWyniki treningu kumulują się. Nie ma resetu, chyba że otrzymasz surową karę za pośrednictwem sądu. \nŚwiadectwo ukończenia szkoły wojskowej daje stały bonus do każdej sesji na strzelnicy.';

  @override
  String get helpTopicShootingRangeTips =>
      'Trenuj strzelnicę codziennie: małe skumulowane premie stają się zauważalne w wynikach PvP w ciągu tygodnia. \nTrenuj typ broni, którego najczęściej używasz w przestępstwach i PvP, aby uzyskać maksymalny zwrot z inwestycji.';

  @override
  String get helpTopicGymCategory => 'Szkolenie';

  @override
  String get helpTopicGymTitle => 'Sala gimnastyczna';

  @override
  String get helpTopicGymSummary =>
      'Trenuj siłę, szybkość i wytrzymałość, aby uzyskać lepsze statystyki w PvP, przestępstwach i puli HP. Codzienny trening jest kluczem do szybkiego wzrostu statystyk.';

  @override
  String get helpTopicGymHow =>
      'Siłownia oferuje trzy kategorie treningu: Siła (więcej obrażeń na atak), Szybkość (wyższy refleks, mniej zadawanych trafień), Wytrzymałość (wyższe maksymalne HP). \nKażdy trening ma 1 godzinę czasu odnowienia. Maksymalnie 6-8 sesji dziennie, w zależności od świadectwa szkolnego. \nSiła zwiększa bezpośrednie obrażenia zarówno w PvP, jak i w niektórych typach przestępstw (napad, bójka). \nSzybkość zwiększa szansę na uniknięcie ataku i zmniejsza ryzyko złapania w przypadku niepowodzenia przestępstwa. \nWytrzymałość zwiększa maksymalną pulę HP. Więcej HP = dłuższe przeżycie w PvP i więcej miejsca na ryzykowne przestępstwa. \nŚwiadectwo ukończenia szkoły Trening fizyczny daje premię +15% do wszystkich sesji na siłowni.';

  @override
  String get helpTopicGymTips =>
      'Nadaj priorytet treningowi wytrzymałości: wyższa pula HP poprawia wszystkie inne systemy, ponieważ dłużej pozostajesz aktywny. \nPołącz siłownię ze strzelnicą: Siła + Celność to najsilniejsza kombinacja PvP.';

  @override
  String get helpTopicAmmoFactoryCategory => 'Imperium';

  @override
  String get helpTopicAmmoFactoryTitle => 'Fabryka Amunicji';

  @override
  String get helpTopicAmmoFactorySummary =>
      'Produkuj amunicję na własny użytek i zarządzaj produkcją z fabryki. Kupno i sprzedaż amunicji odbywa się na Czarnym Rynku, a nie bezpośrednio z ekranu fabryki.';

  @override
  String get helpTopicAmmoFactoryHow =>
      'Fabryka amunicji ma poziomy produkcji (od poziomu 1 do 5). Wyższy poziom = więcej rund na roszczenie i lepsza jakość. \nPodczas aktywnej sesji przejmujesz produkcję mniej więcej co 20 minut (do 8 godzin zaległości w tej sesji). \nProdukcja stale rośnie, gdy jesteś offline: po powrocie możesz zgłaszać roszczenia wielokrotnie, aż do nadrobienia zaległości. \nSamo obejrzenie fabryki amunicji lub podróżowanie tam i z powrotem nie może zmienić właściciela; fabryka nie powinna przełączać się na komunikat „na sprzedaż” tylko dlatego, że ekran został otwarty. \nWyprodukowana amunicja jest wykorzystywana osobiście w przestępstwach i PvP. Aby kupować i sprzedawać amunicję, przejdź przez Czarny Rynek; sam ekran fabryczny nie sprzedaje bezpośrednio naboi. \nUlepszenia wyjściowe zwiększają liczbę rund na roszczenie; ulepszenia jakości zwiększają wartość rynkową. \nCena rynkowa amunicji zmienia się w zależności od popytu. Gromadź zapasy, gdy ceny są niskie i sprzedawaj, gdy ceny są wysokie. \nPodczas nalotu na fabrykę tracisz część zmagazynowanej produkcji. Bezpieczeństwo zmniejsza to ryzyko.';

  @override
  String get helpTopicAmmoFactoryTips =>
      'Jak najszybciej ulepsz swoją fabrykę do poziomu 3: podwojona produkcja w porównaniu z poziomem 1 sprawia, że ​​jest ona samowystarczalna pod względem amunicji. \nZawsze trzymaj 2-3 rundy produkcyjne w rezerwie jako bufor, aby nigdy nie zabrakło Ci amunicji podczas PvP.';

  @override
  String get helpTopicSchoolCategory => 'Szkolenie';

  @override
  String get helpTopicSchoolTitle => 'Szkoła';

  @override
  String get helpTopicSchoolSummary =>
      'Kontynuuj kursy na wielu ścieżkach, aby odblokować bonusy, obniżyć koszty i otworzyć nowe systemy. Szkoła wzmacnia wszystko, co robisz.';

  @override
  String get helpTopicSchoolHow =>
      'Szkoła oferuje ścieżki w poszczególnych domenach: Kryminalny (lepsze statystyki przestępczości), Ekonomiczny (niższe koszty handlu i banku), Wojskowy (premie bojowe), Medycyna (niższe koszty szpitala), Prawo (niższe koszty prawnika), Techniczny (lepsza fabryka i produkcja leków). \nKażda lekcja trwa od 15 do 60 minut, w zależności od poziomu. Wyższe poziomy trwają dłużej. \nPo ukończeniu lekcji otrzymasz certyfikat na dany poziom ścieżki. Certyfikat ten jest trwały i przyznaje natychmiastową premię. \nMożesz uczestniczyć tylko w jednej lekcji na raz. Starannie zaplanuj studia, gdy pilnie potrzebujesz konkretnego certyfikatu. \nKoszty szkoły rosną z każdym poziomem. Szkolnictwo wyższe wymaga ukończenia wcześniejszych poziomów tej samej ścieżki. \nNiektóre zaawansowane funkcje gry są zablokowane za świadectwem szkolnym: np. dostęp do niektórych stanowisk pracy, wyższych poziomów fabrycznych, wydarzeń w klubach nocnych VIP i wyższych poziomów ulepszeń placówki farmaceutycznej. \nCertyfikaty nigdy nie są resetowane, chyba że na Twoje konto zostanie nałożona surowa kara.';

  @override
  String get helpTopicSchoolTips =>
      'Zawsze zaczynaj od ścieżki kryminalnej: premie do szans na sukces w przestępstwie zwracają koszty nauki w ciągu kilku sesji. \nZaplanuj długie studia (60 min+) przed pójściem spać: budzisz się z nowym certyfikatem, nie tracąc aktywnego czasu.';

  @override
  String get helpTopicTerritoryCategory => 'Imperium';

  @override
  String get helpTopicTerritoryTitle => 'Terytorium';

  @override
  String get helpTopicTerritorySummary =>
      'Zdobądź i kontroluj regiony geograficzne, aby uzyskać pasywny dochód, prestiż załogi i strategiczne premie regionalne. Terytorium łączy kontrolę nad mapą z konkursami i nagrodami sezonowymi.';

  @override
  String get helpTopicTerritoryHow =>
      'Przegląd terytorium pokazuje wszystkie dostępne kraje i regiony według kraju. Kliknij kraj, aby wyświetlić interaktywną mapę. \nWszystkie obsługiwane kraje można teraz w pełni przeglądać za pomocą tych samych interaktywnych map, co w Holandii. \nKliknij region na interaktywnej mapie, aby otworzyć moduł z informacjami o terytorium i przyciskiem ataku. Oddzielne karty regionów pod mapą nie są już potrzebne. \nOglądanie jest dozwolone wszędzie, ale ataki, dołączenia do obrony i akcje konkursowe działają tylko w kraju, w którym aktualnie znajduje się Twoja postać. \nNa urządzeniach mobilnych możesz teraz przybliżać i oddalać dwa palce oraz bezpośrednio przeciągać powiększoną mapę, dzięki czemu łatwiej jest dotykać mniejszych regionów bez dodatkowych przycisków na mapie. \nTerytorium opiera się na załodze: musisz stworzyć załogę lub dołączyć do niej, zanim przycisk ataku stanie się dostępny dla regionów neutralnych lub wrogich. \nKażdy region może być kontrolowany przez maksymalnie jedną załogę na raz. Własność zapewnia pasywny dochód na godzinę, ale Terytorium przestaje wpłacać pieniądze do banku załogi po osiągnięciu limitu przechowywania gotówki. \nRozpocznij konkurs w nieodebranym regionie za pomocą przycisku konkursu. Konkurs automatycznie przechodzi przez etap przygotowania (czas przygotowania), etap aktywny (akcje) i zamknięcie (rozwiązanie). \nPodczas aktywnego konkursu moduł regionu pokazuje teraz także, kiedy akcje się odblokowują, kiedy kończy się konkurs, jaki jest czas odnowienia każdej akcji oraz rzeczywista kwota gotówki, którą region płaci za wypłatę, za godzinę i dzień. \nRegiony pełnią obecnie także strategiczne role, takie jak port, przemysł, stolica, region przygraniczny czy węzeł logistyczny. Rola ta określa, które akcje pozwolą Ci zdobyć dodatkowe punkty. \nSąsiednie regiony, które już należą do twojej załogi, zapewniają teraz dodatkowe wsparcie podczas akcji konkursowych. Modal regionu pokazuje, które bonusy strategiczne są aktywne i ile wsparcia ma Twoja Crew na tym obszarze. \nPremie do akcji mogą teraz pochodzić również z postępu załogi: poziomu sztabu, poziomu misji załogi i odpowiednich budynków bocznych (broń/amunicja/samochód/łódź/magazyn leków). Premie te zwiększają jedynie punkty konkursowe, a nie pasywną gotówkę regionu. \nNiektóre zaawansowane akcje konkursowe są kontrolowane przez centralę: jeśli poziom twojej centrali jest zbyt niski, na przycisku akcji pojawi się komunikat „wymaga natychmiastowego poziomu X”. \nTerytorium nie stosuje już domyślnie sztywnego dziennego limitu akcji (limit czasu działania 0 = wyłączony). Równowaga pozostaje pod kontrolą poprzez czasy odnowienia, wybory dotyczące działań przeciw farmom i działań strategicznych. \nWygrana w wojnie terytorialnej lub wojnie totalnej może teraz wywrzeć tymczasowy nacisk wojenny na rzeczywiste regiony terytoriów wokół tej linii frontu. Modal regionu pokazuje, która Crew utrzymuje presję, w jakim stopniu zmniejsza się efektywna stabilność i kiedy wygasają następstwa. \nKiedy konkurs właśnie się rozpoczął lub w starszym konkursie nadal brakowało pól czasu, ekran natychmiast wypełnia te liczniki i odświeża modal do najnowszego stanu konkursu, bez konieczności wcześniejszej nawigacji. \nAtakujący widzą tylko akcje atakującego (wywiad, sabotaż, najazd), a obrońcy widzą tylko akcje obrońcy (patrol, bieg zaopatrzenia, obrona), więc modal nie wyświetla już mylących, mieszanych przycisków. \nRegion pokazuje teraz także rzeczywisty dochód z terytorium. Liderzy załogi widzą także na pulpicie nawigacyjnym, ile regionów i krajów kontroluje ich Crew, ile obecnie zarabia Crew i ile łącznie zarobiło do tej pory Terytorium. \nKonkursy skutkują przeniesieniem własności i nagrodami (gotówką, XP, prestiżem). Przegrani otrzymają również częściowe PD za udział. \nDuże regiony (porty, stolice) dają więcej pasywnego dochodu, ale także powodują więcej przeciwników i prób najazdów. \nWydarzenia sezonowe zapewniają dodatkowe nagrody i specjalne wyzwania w każdej grupie regionów. \nZapobiegaj zastojom: Twoja Crew nie może od razu zaatakować tego samego przeciwnika po przegranej; poczekaj na ochłodzenie. \nKontrole zapobiegające nadużyciom zapobiegają wielokrotnemu atakowi jednej załogi na ten sam cel w krótkich oknach czasowych.';

  @override
  String get helpTopicTerritoryTips =>
      'Zacznij od zrównoważonego kraju ze średnimi regionami: mniejsza konkurencja niż w dużych krajach, ale rozsądny dochód pasywny. \nSkoncentruj się najpierw na jednym kraju, w którym Twoja Crew jest silna: lepsza wiedza prowadzi do lepszej strategii zawodów niż płytka kontrola w wielu krajach. \nWykorzystaj pory roku jako strategiczne resety: jeśli przegrasz w porze suchej, zawsze nadejdzie lepszy sezon na powrót.';

  @override
  String get helpTopicProstitutionCategory => 'Imperium';

  @override
  String get helpTopicProstitutionTitle => 'Prostytucja';

  @override
  String get helpTopicProstitutionSummary =>
      'Zbuduj sieć prostytucji z rekrutami, wydarzeniami i klientami VIP. Dobrze zarządzana sieć generuje pasywny dochód, ale wymaga aktywnego zarządzania, aby kontrolować rywalizację i uwagę policji.';

  @override
  String get helpTopicProstitutionHow =>
      'Centrum Imperium Prostytucji składa się z czterech zakładek: Pracownicy, RLD, Wydarzenia i Społeczności.\nZarządzasz rekrutami, każdy za pomocą własnych statystyk (doświadczenie, popularność, dostępność). Więcej rekrutów = wyższy dochód pasywny.\nUżyj opcji Collect, aby rozliczyć oczekujące zarobki pokazane na pasku KPI.\nPraca zmianowa trwa 8 godzin na rekruta: po zmianie rekrut potrzebuje czasu na odpoczynek, zanim będzie mógł zacząć od nowa.\nZarządzanie lokalizacjami jest elastyczne: przenoś rekrutów pomiędzy ulicą, Dzielnicą Czerwonych Latarni i klubem nocnym za pomocą menu Ruchu na każdej karcie pracownika.\nWydarzenia to tymczasowe wzmocnienia: specjalne pokazy, noce VIP i imprezy zwiększają dochód za każdy tik przez cały czas trwania wydarzenia.\nRywalizacja: inni gracze lub konkurenci NPC mogą kłusować na twoich rekrutów lub sabotować wydarzenia. Wyższe bezpieczeństwo zmniejsza to ryzyko.\nKlienci VIP płacą znacznie więcej, ale wymagają rekrutów o dużej popularności (80+) i bezpiecznej lokalizacji.\nUwaga policji (gorąco) wzrasta w przypadku dużych transakcji i nalotów. Wysoka temperatura prowadzi do konfiskaty dochodów lub tymczasowego przestoju.\nPołączenie z klubem nocnym: Nightclub zapewnia prawną ochronę działań powodujących wolniejszy wzrost temperatury.\nSkorzystaj z panelu analizy zarobków u góry, aby szybko porównać godzinowe wyniki dla ulicy, RLD i klubu nocnego.\nTabela liderów: najwyższy łączny tygodniowy obrót zapewnia cotygodniową nagrodę pieniężną i odznakę.';

  @override
  String get helpTopicProstitutionTips =>
      'Zainwestuj w bezpieczeństwo już na wczesnym etapie: atak rywalizacyjny, podczas którego kradniesz najlepszego rekruta, kosztuje więcej niż inwestycja w bezpieczeństwo. \nOrganizuj wydarzenia VIP tylko wtedy, gdy popularność rekrutów przekracza 80: poniżej tego progu klienci VIP płacą po prostu standardową stawkę.';

  @override
  String get helpTopicRedLightDistrictsCategory => 'Imperium';

  @override
  String get helpTopicRedLightDistrictsTitle => 'Dzielnice czerwonych latarni';

  @override
  String get helpTopicRedLightDistrictsSummary =>
      'Zgłaszaj i zarządzaj okręgami terytorialnymi w każdym kraju. Posiadanie dzielnicy daje pasywny dochód i kontrolę nad działalnością prostytucyjną w tym regionie.';

  @override
  String get helpTopicRedLightDistrictsHow =>
      'W każdym kraju istnieje jedna lub więcej dzielnic czerwonych latarni, do których można się zgłosić. Zdobądź dzielnicę, płacąc ustaloną kwotę zakupu.\nJako właściciel dzielnicy otrzymujesz procent wszystkich dochodów z prostytucji w tym kraju – w tym od innych graczy tam działających.\nInni gracze mogą zaatakować Twoją dzielnicę, aby przejąć ją na własność. Wyższe bezpieczeństwo zmniejsza szansę na atak.\nW szczegółach dzielnicy możesz podnieść poziom (zarobki) i bezpieczeństwo (ryzyko nalotu) oraz przeglądać statystyki najazdów na żywo (wyciek FBI, szansa na nalot). Wyższe bezpieczeństwo zmniejsza szansę na napad.\nMożesz posiadać maksymalnie 3 dzielnice jednocześnie. Niezbędny jest strategiczny wybór kraju.\nNajbardziej ruchliwe kraje (Kolumbia, Dubaj, Japonia) zapewniają najwyższy dochód pasywny, ale są też najbardziej sporne.\nUtrata dzielnicy nie zwraca ceny zakupu: zostaje ona trwale utracona, jeśli wróg pomyślnie ją przejmie.';

  @override
  String get helpTopicRedLightDistrictsTips =>
      'Zacznij od mniej popularnego kraju w swojej pierwszej dzielnicy: mniejsza presja ataków daje czas na ulepszenie zabezpieczeń przed prawdziwą konkurencją. \nZwiększ bezpieczeństwo każdej dzielnicy natychmiast po zakupie: pierwsze 24 godziny są najbardziej podatne na przejęcie.';

  @override
  String get helpTopicAchievementsCategory => 'Meta';

  @override
  String get helpTopicAchievementsTitle => 'Osiągnięcia';

  @override
  String get helpTopicAchievementsSummary =>
      'Zdobywaj odznaki, osiągając kamienie milowe we wszystkich systemach gier. Osiągnięcia zapewniają nagrody, podnoszą Twój profil statusu i pokazują postępy w poszczególnych kategoriach.';

  @override
  String get helpTopicAchievementsHow =>
      'Osiągnięcia są pogrupowane w kategorie: Zbrodnie, Imperium, PvP, Ekonomia, Szkolenie, Społeczność i Meta. \nKażde osiągnięcie ma kilka poziomów (brązowy, srebrny, złoty, platynowy). Każdy poziom zapewnia wyższą nagrodę i bardziej imponującą odznakę. \nNagrody za osiągnięcie obejmują: gotówkę, XP, przedmioty specjalne, stałe bonusy lub unikalne tytuły dla Twojego profilu. \nPostęp jest śledzony automatycznie. Nie musisz niczego aktywować: osiągnij próg, a odznaka zostanie przyznana natychmiast. \nNiektóre osiągnięcia są ukryte, dopóki nie uda Ci się ich częściowo ukończyć — wtedy pojawiają się wraz z ich prawdziwą nazwą i wymaganiami. \nOdznaki za osiągnięcia są widoczne w Twoim profilu publicznym. Pokazują innym graczom Twoje specjalizacje i doświadczenie. \nOsiągnięcia łańcuchowe: niektóre odznaki są połączone w łańcuch. Złoto wymaga zdobycia Srebra. Planuj wcześniej, aby uzyskać wyższe poziomy.';

  @override
  String get helpTopicAchievementsTips =>
      'Codziennie sprawdzaj swoje prawie ukończone osiągnięcia: niewielki dodatkowy wysiłek może zapewnić odznakę i nagrodę pieniężną, która w przeciwnym razie byłaby opóźniona o miesiące. \nSkoncentruj się już na kategoriach Ekonomia i Przestępczość: te zapewniają najwięcej nagród pieniężnych i najłatwiej je połączyć z normalną rozgrywką.';

  @override
  String get helpTopicSupportTicketsCategory => 'Wsparcie';

  @override
  String get helpTopicSupportTicketsTitle => 'Raporty i bilety';

  @override
  String get helpTopicSupportTicketsSummary =>
      'Zgłaszaj błędy, pytania lub opinie za pośrednictwem systemu zgłoszeń. Wsparcie i administratorzy mogą odpowiadać, zarządzać wewnętrznymi działaniami następczymi i wysyłać aktualizacje za pośrednictwem samej rozmowy z pomocą techniczną i opcjonalnych powiadomień push.';

  @override
  String get helpTopicSupportTicketsHow =>
      'Otwórz osobną pozycję menu „Wsparcie”, aby sprawdzić swoje zgłoszenia lub utworzyć nowe. \nWybierz kategorię (błąd, pytanie, opinia lub inna), w razie potrzeby wybierz powiązany moduł i opisz swój problem tak szczegółowo, jak to możliwe. \nOpcjonalnie możesz dodać odniesienie, takie jak identyfikator zamówienia, nazwa ekranowa lub krótki kontekst, a także zrzut ekranu, jeśli to pomoże. \nPo przesłaniu natychmiast otrzymasz numer zgłoszenia, a Twoje zgłoszenie pojawi się w przeglądzie wsparcia, gdzie zespół wsparcia może odpowiedzieć i utworzyć wewnętrzne zadania do wykonania. \nKiedy odpowiedzi na pomoc techniczną lub status zgłoszenia się zmienią, zobaczysz to bezpośrednio w tej samej rozmowie z pomocą techniczną i opcjonalnie możesz otrzymać powiadomienie push (jeśli powiadomienia są włączone). \nPozycja menu Wsparcie wyświetla plakietkę, gdy tylko zgłoszenie otrzyma nową odpowiedź pomocy technicznej lub aktualizację statusu od Twojej ostatniej wizyty w przeglądzie pomocy technicznej. \nWsparcie wykorzystuje statusy takie jak nowy, selekcja, w toku, oczekiwanie na gracza, zablokowany i rozwiązany, aby wewnętrznie śledzić Twoje zgłoszenie.';

  @override
  String get helpTopicSupportTicketsTips =>
      'Zawsze podawaj swój kraj, działanie i dokładny komunikat o błędzie; przyspiesza to wprowadzanie poprawek dla programistów. \nUżyj jednego biletu na każdy rodzaj problemu, aby lista rzeczy do zrobienia i działania następcze pozostały przejrzyste.';

  @override
  String get helpTopicSettingsCategory => 'Rdzeń';

  @override
  String get helpTopicSettingsTitle => 'Ustawienia';

  @override
  String get helpTopicSettingsSummary =>
      'Zarządzaj wszystkimi ustawieniami konta: językiem, awatarem, prywatnością, preferencjami powiadomień dla poszczególnych systemów i opcjami bezpieczeństwa. Ustawienia mają bezpośredni wpływ na wrażenia z gry.';

  @override
  String get helpTopicSettingsHow =>
      'Język: przełączanie pomiędzy holenderskim i angielskim. Wszystkie teksty interfejsu użytkownika, komunikaty systemowe i powiadomienia są aktualizowane natychmiast. \nAwatar: prześlij lub wybierz zdjęcie profilowe widoczne dla innych graczy na Twoim profilu publicznym i na listach załogi. \nPrywatność: ustaw, kto może zobaczyć Twój status online, lokalizację (bieżący kraj) i statystyki — tylko Ty, Crew, przyjaciele lub wszyscy. \nPowiadomienia push: przełączanie w zależności od systemu. Kategorie: Przestępstwa, Handel kryptowalutami, Alerty cenowe, Zamówienia, wydarzenia dla graczy na żywo (konkurencja), Reżim rynkowy, Napad, Nightclub, wiadomości ogólne. \nJeśli funkcja push była już dozwolona, ​​wersja web/PWA automatycznie ponownie połączy się z bieżącym tokenem urządzenia po odświeżeniu lub aktualizacji; wystarczy ponownie włączyć ją w Ustawieniach, gdy sama przeglądarka blokuje powiadomienia. \nPreferencje powiadomień o kryptowalutach pozostają zapisane po opuszczeniu Ustawień i ponownym otwarciu ich później. \nPowiadomienia w aplikacji: konfigurowalne niezależnie od powiadomień push. W aplikacji wyświetla alerty w aplikacji bez wysyłania powiadomienia systemowego. \nBezpieczeństwo: zmień hasło, skonfiguruj uwierzytelnianie dwuskładnikowe i przeglądaj aktywne sesje. \nPreferencje dotyczące powiadomień dla poszczególnych systemów: dostosuj, aby nie otrzymywać burzy powiadomień z systemów, w których aktywnie nie grasz.';

  @override
  String get helpTopicSettingsTips =>
      'Włącz powiadomienia push dla zamówień kryptograficznych i zdarzeń napadów: są to systemy, w których liczy się czas i szybkość reakcji. \nUstaw prywatność lokalizacji na tylko dla załogi, gdy jesteś aktywny na liście trafień: w przeciwnym razie inni gracze będą mogli Cię dokładnie wskazać.';

  @override
  String get helpTopicPremiumCategory => 'Rdzeń';

  @override
  String get helpTopicPremiumTitle => 'Premie i kredyty';

  @override
  String get helpTopicPremiumSummary =>
      'Kupuj i zarządzaj tutaj VIP-ami Gracza, VIP-ami załogi i pakietami kredytów. Przegląd ten pokazuje również saldo kredytu i wszystkie dostępne pozycje kredytu, z których możesz skorzystać bezpośrednio lub kontekstowo.';

  @override
  String get helpTopicPremiumHow =>
      'Otwórz oddzielną stronę „Premium i kredyty” w bocznym menu, aby wyświetlić swój status VIP, daty wygaśnięcia, saldo środków i opcje zakupu. \nNa każdym kafelku zakupu dotknij/kliknij ikonę „i” w lewym górnym rogu, aby uzyskać szczegółowe informacje i korzyści; sam kafelek celowo pokazuje tylko krótkie podstawowe informacje i przycisk zakupu. \nGracz VIP jest osobisty. VIP dla załogi dotyczy Twojej załogi i ma wartość tylko wtedy, gdy jesteś już w załodze. \nGracz VIP zapewnia o 10% krótsze czasy działania (czas więzienia pozostaje niezmieniony), 100 tygodniowych kredytów, przycisk VIP do zakupu jednym kliknięciem brakujących materiałów w produkcji narkotyków (po potwierdzeniu kosztów) oraz łagodniejszy reset po śmierci: bank/krypto/edukacja/osiągnięcia pozostają, podczas gdy aktywa, ekwipunek i zapasy leków są usuwane. \nKasa VIP otwiera stronę płatności, a następnie powraca do sekcji „Premium i kredyty” w grze, dzięki czemu od razu widzisz, czy zakup się powiódł i jak długo ważny jest Twój VIP. \nPakiety kredytów kupuje się za prawdziwe pieniądze. Po pomyślnej płatności środki natychmiast pojawią się w przeglądzie Twojego portfela. \nKarnet na wydarzenie (7 dni, prawdziwe pieniądze) jest wymieniony w siatce ofert jednorazowych: +10% wyniku w wydarzeniach dla graczy na żywo oraz niewielki bonus kredytowy po zakupie. Jest to poziom poboczny: nie jest to bezpośrednia walka ani wzmocnienie PvP; pomaga głównie w wynikach rankingów podczas wydarzeń biegowych. \nW przypadku pozycji kredytowych wykorzystywane są środki z portfela zamiast euro. Pomyśl o ochronie przed trafieniami, resetowaniu czasu odnowienia, wzmocnieniach wydarzeń lub pakietach pieniężnych, w zależności od tego, co administrator aktualnie włączył na żywo. \nNa obsługiwanych ekranach limitów czasu (takich jak przestępstwa, praca, kradzież pojazdu/łodzi i szkoła) dostępny jest także bezpośredni przycisk przyspieszenia dla aktywnych czasów odnowienia, dzięki czemu nie musisz najpierw wracać do konta premium i kredytów. \nNiektóre pozycje kredytowe działają bezpośrednio z tego ekranu. Zamiast tego elementy powiązane z kontekstem, takie jak określone akcje pojazdu, są używane na ekranie odpowiedniego pojazdu lub garażu (uszkodzone pojazdy mają przycisk natychmiastowej naprawy bezpośrednio na karcie). \nW przypadku przycisków kontekstowych, takich jak przyspieszenie naprawy, bieżący koszt kredytu jest wyświetlany bezpośrednio na przycisku/etykiecie narzędzia. \nCeny i dostępne produkty są zarządzane na żywo w panelu administracyjnym. Oznacza to, że ceny VIP, koszty kredytu i dostępna oferta mogą ulec zmianie bez aktualizacji aplikacji.';

  @override
  String get helpTopicPremiumTips =>
      'Przed ponownym zakupem sprawdź saldo kredytu i datę jego wygaśnięcia; przedłużanie jest często lepsze niż układanie na ślepo. \nWykorzystuj kredyty głównie na krytyczne czasowo wzmocnienia lub ochronę, a nie automatycznie na każdym małym skrócie. \nJeśli nie jesteś jeszcze w załodze, zacznij od Gracza VIP lub pakietu kredytów przed Crew VIP.';

  @override
  String get landingHeroTitle => 'Państwo tłumu';

  @override
  String get landingHeroSubtitle =>
      'Głęboko tekstowa gra strategiczna kryminalna w przeglądarce. Zbuduj swoje imperium, zarządzaj załogami, handluj, walcz o terytorium – i wspinaj się po szczeblach kariery.';

  @override
  String get landingAboutTitle => 'Co Cię czeka';

  @override
  String get landingAboutBody =>
      'Zarządzaj firmami, wykonuj zlecenia i napady, rozwijaj swoją postać poprzez świadectwa szkolne, rywalizuj w wydarzeniach na żywo i koordynuj działania ze swoją załogą na mapie świata. Uczciwe zasady konkurencji, długoterminowy rozwój i regularne aktualizacje treści.';

  @override
  String get landingTopPlayersTitle => 'Najlepsi gracze';

  @override
  String get landingTopCrewsTitle => 'Najlepsze załogi (terytorium)';

  @override
  String get landingRankLabel => 'Stopień';

  @override
  String get landingRegionsLabel => 'Regiony';

  @override
  String get landingLoadError => 'Nie można teraz wczytać rankingów.';

  @override
  String get landingEmptyLeaderboard => 'Nie ma jeszcze żadnych wpisów.';

  @override
  String get landingCtaLogin => 'Zaloguj się';

  @override
  String get landingCtaRegister => 'Utwórz konto';

  @override
  String get landingFooterPrivacy => 'Polityka prywatności';

  @override
  String get landingFooterTerms => 'Regulamin';

  @override
  String get landingFooterDigitalGoods => 'Zakup towarów cyfrowych';

  @override
  String get landingFooterLanguage => 'Język';

  @override
  String landingCopyright(int year) {
    return '© $year Państwo mafii. Wszelkie prawa zastrzeżone.';
  }

  @override
  String get legalPrivacyTitle => 'Polityka prywatności';

  @override
  String get legalPrivacyLastUpdated => 'Ostatnia aktualizacja: maj 2026 r';

  @override
  String get legalPrivacyIntro =>
      'Niniejsza Polityka prywatności wyjaśnia, w jaki sposób The Mob State („my”, „nas”) obchodzi się z danymi osobowymi podczas korzystania z naszej witryny internetowej, gry internetowej i powiązanych usług. Grając lub przeglądając, wyrażasz zgodę na tę politykę, jeśli pozwala na to obowiązujące prawo.';

  @override
  String get legalPrivacySection01Title => 'Kim jesteśmy';

  @override
  String get legalPrivacySection01Body =>
      'The Mob State to gra internetowa obsługiwana jako usługa cyfrowa. W przypadku wniosków dotyczących prywatności możesz skontaktować się z nami za pośrednictwem systemu zgłoszeń do pomocy technicznej w grze po rejestracji lub za pośrednictwem oficjalnych kanałów kontaktowych na stronie internetowej, jeśli są one opublikowane.';

  @override
  String get legalPrivacySection02Title => 'Dane, które zbieramy';

  @override
  String get legalPrivacySection02Body =>
      'Możemy przetwarzać dane konta (nazwa użytkownika, adres e-mail, jeśli został podany, zaszyfrowane hasło), dane dotyczące rozgrywki i postępów, dzienniki techniczne (adres IP, typ urządzenia/przeglądarki, znaczniki czasu), referencje dotyczące płatności od naszych dostawców usług płatniczych (nie przechowujemy pełnych numerów kart) oraz komunikację wysyłaną do wsparcia.';

  @override
  String get legalPrivacySection03Title => 'Cele';

  @override
  String get legalPrivacySection03Body =>
      'Używamy danych w celu zapewnienia gry, zabezpieczenia kont, zapobiegania nadużyciom i oszustwom, przetwarzania zakupów, poprawy wydajności, przekazywania komunikatów usługowych i wypełniania obowiązków prawnych.';

  @override
  String get legalPrivacySection04Title =>
      'Podstawa prawna (EOG/Wielka Brytania)';

  @override
  String get legalPrivacySection04Body =>
      'Tam, gdzie obowiązuje RODO, opieramy się na wykonaniu umowy (dostarczenie gry), uzasadnionych interesach (bezpieczeństwo, analityka, ulepszanie produktu w powiązaniu z Twoimi prawami), zgodzie, jeśli jest to wymagane (np. niektóre marketingowe pliki cookie lub opcjonalna komunikacja) i zobowiązaniach prawnych.';

  @override
  String get legalPrivacySection05Title => 'Pliki cookie i pamięć lokalna';

  @override
  String get legalPrivacySection05Body =>
      'Używamy plików cookie i podobnych technologii, aby zapewnić Ci zalogowanie, zapamiętywać preferencje, mierzyć podstawowe wykorzystanie i zapewniać niezbędną funkcjonalność. Wiele plików cookie możesz kontrolować za pomocą ustawień swojej przeglądarki.';

  @override
  String get legalPrivacySection06Title => 'Zatrzymanie';

  @override
  String get legalPrivacySection06Body =>
      'Przechowujemy informacje tak długo, jak jest to konieczne do świadczenia usługi oraz spełnienia wymogów prawnych, podatkowych i księgowych. Niektóre dzienniki mogą być przechowywane przez ograniczony okres bezpieczeństwa. Kiedy dane nie są już potrzebne, o ile to możliwe, usuwamy je lub anonimizujemy.';

  @override
  String get legalPrivacySection07Title => 'Partycypujący';

  @override
  String get legalPrivacySection07Body =>
      'Udostępniamy dane infrastrukturze i podmiotom przetwarzającym płatności wyłącznie w zakresie niezbędnym do realizacji usługi, na mocy odpowiednich umów. Nie sprzedajemy Twoich danych osobowych. Możemy ujawnić informacje, jeśli jest to wymagane przez prawo lub w celu ochrony praw i bezpieczeństwa.';

  @override
  String get legalPrivacySection08Title => 'Transfery międzynarodowe';

  @override
  String get legalPrivacySection08Body =>
      'Twoje dane mogą być przetwarzane na terenie Europejskiego Obszaru Gospodarczego i/lub innych regionów, w których działamy my lub nasi dostawcy. Tam, gdzie jest to wymagane, stosujemy zabezpieczenia takie jak standardowe klauzule umowne.';

  @override
  String get legalPrivacySection09Title => 'Twoje prawa';

  @override
  String get legalPrivacySection09Body =>
      'W zależności od Twojej lokalizacji możesz mieć prawo dostępu, poprawiania, usuwania, ograniczania lub sprzeciwu wobec określonego przetwarzania i przenoszenia danych. Możesz wnieść skargę do organu nadzorczego. Skontaktuj się z nami za pośrednictwem wsparcia, aby skorzystać z praw; być może będziemy musieli zweryfikować Twoją tożsamość.';

  @override
  String get legalPrivacySection10Title => 'Dzieci';

  @override
  String get legalPrivacySection10Body =>
      'Gra nie jest przeznaczona dla dzieci poniżej wieku, w którym w Twoim regionie wymagana jest zgoda rodziców na przetwarzanie. Jeśli uważasz, że dziecko przekazało dane w sposób nieprawidłowy, skontaktuj się z nami, a my podejmiemy odpowiednie kroki.';

  @override
  String get legalDigitalGoodsTitle => 'Zakup towarów cyfrowych';

  @override
  String get legalDigitalGoodsLastUpdated =>
      'Ostatnia aktualizacja: maj 2026 r';

  @override
  String get legalDigitalGoodsIntro =>
      'Niniejsza polityka opisuje zakupy treści i usług cyfrowych w The Mob State (na przykład kredyty premium, czas VIP lub inne przedmioty wirtualne). Dokonując zakupu, wyrażasz zgodę na niniejsze warunki oraz wszelkie warunki realizacji transakcji pokazane przy płatności.';

  @override
  String get legalDigitalGoodsSection01Title => 'Charakter zakupów cyfrowych';

  @override
  String get legalDigitalGoodsSection01Body =>
      'Wszystkie zakupy stanowią płatność za dostęp do dodatkowych funkcji online i wirtualnych przedmiotów w The Mob State. Są one dostarczane cyfrowo w grze i nie mają formy fizycznej.';

  @override
  String get legalDigitalGoodsSection02Title =>
      'Natychmiastowa dostawa i wypłata (Wielka Brytania/UE)';

  @override
  String get legalDigitalGoodsSection02Body =>
      'Jeżeli mają zastosowanie przepisy dotyczące umów konsumenckich z 2013 r. (Wielka Brytania) lub równoważne przepisy UE, przyjmujesz do wiadomości, że treści cyfrowe są dostarczane natychmiast po zakupie i, jeśli prawo na to pozwala, możesz utracić ustawowe 14-dniowe prawo do odstąpienia od umowy po rozpoczęciu dostawy za Twoją uprzednią wyraźną zgodą.';

  @override
  String get legalDigitalGoodsSection03Title =>
      'Zwroty środków i obciążenia zwrotne';

  @override
  String get legalDigitalGoodsSection03Body =>
      'Towary cyfrowe zasadniczo nie podlegają zwrotowi po dostarczeniu, chyba że obowiązkowe prawo konsumenckie stanowi inaczej. Obciążenia zwrotne lub spory dotyczące płatności po dostawie mogą prowadzić do zawieszenia lub zamknięcia powiązanych kont; najpierw skontaktuj się z pomocą techniczną, abyśmy mogli pomóc w rozwiązaniu problemów z rozliczeniami.';

  @override
  String get legalDigitalGoodsSection04Title => 'Pozwolenie i wiek';

  @override
  String get legalDigitalGoodsSection04Body =>
      'Musisz mieć uprawnienia do korzystania z wybranej metody płatności. Jeśli nie masz ukończonych 18 lat, aby dokonywać zakupów lub korzystać z usług płatnych, potrzebujesz zgody rodzica lub opiekuna.';

  @override
  String get legalDigitalGoodsSection05Title => 'Kanały płatności i opłaty';

  @override
  String get legalDigitalGoodsSection05Body =>
      'Ceny mogą być wyświetlane w euro lub walucie dostawcy. Operatorzy komórkowi lub platformy płatnicze mogą dodawać własne opłaty; skontaktuj się ze swoim dostawcą przed potwierdzeniem płatności u operatora lub w portfelu.';

  @override
  String get legalDigitalGoodsSection06Title => 'Dostępność';

  @override
  String get legalDigitalGoodsSection06Body =>
      'Płatne funkcje są dostarczane wirtualnie za pośrednictwem naszych serwerów i mogą z czasem ulegać zmianom. Możemy dostosować, zawiesić lub wycofać określone przedmioty, pakiety lub ceny, aby zrównoważyć grę lub z powodów technicznych.';

  @override
  String get legalDigitalGoodsSection07Title =>
      'Brak wartości pieniężnej w świecie rzeczywistym';

  @override
  String get legalDigitalGoodsSection07Body =>
      'Wirtualne przedmioty i waluty nie mają wartości pieniężnej poza grą, nie można ich przenieść na prawdziwe pieniądze i mogą zostać zmienione lub usunięte w ramach aktualizacji, egzekwowania prawa konta lub zaprzestania świadczenia usług, chyba że prawo wymaga odszkodowania.';

  @override
  String get legalDigitalGoodsSection08Title =>
      'Zabronione wykorzystanie komercyjne';

  @override
  String get legalDigitalGoodsSection08Body =>
      'Nie możesz używać The Mob State do prowadzenia nieautoryzowanego handlu prawdziwymi pieniędzmi, w tym kupna lub sprzedaży kont, waluty w grze, kodów lub aktywów wirtualnych w zamian za gotówkę lub usługi zewnętrzne poza naszymi oficjalnymi przepływami płatności.';

  @override
  String get legalDigitalGoodsSection09Title => 'Zmiany w serwisie';

  @override
  String get legalDigitalGoodsSection09Body =>
      'Możemy aktualizować tę politykę i opisy zakupów w grze. Dalsze korzystanie po zmianach oznacza akceptację zmienionych warunków, jeśli jest to dozwolone przez prawo.';

  @override
  String get legalDigitalGoodsSection10Title => 'Obowiązujące prawo';

  @override
  String get legalDigitalGoodsSection10Body =>
      'O ile obowiązkowe prawo lokalne nie stanowi inaczej, niniejsza polityka podlega prawu Anglii i Walii, a spory będą podlegać wyłącznej jurysdykcji sądów Anglii i Walii.';

  @override
  String get registerTermsRequired =>
      'You must accept the Terms of Service to register.';

  @override
  String get registerTermsPrefix => 'I agree to the ';

  @override
  String get registerTermsLink => 'Terms of Service';

  @override
  String get registerTermsSuffix => '.';

  @override
  String get legalTermsTitle => 'Terms of Service';

  @override
  String get legalTermsLastUpdated => 'Last updated: May 2026';

  @override
  String get legalTermsIntro =>
      'These Terms of Service (\"Terms\") govern your access to and use of The Mob State website, web game and related services (\"Service\"). By creating an account or using the Service you agree to these Terms together with our Privacy Policy and, where applicable, our digital goods purchase policy.';

  @override
  String get legalTermsSection01Title => 'Eligibility and account';

  @override
  String get legalTermsSection01Body =>
      'You must meet any minimum age shown at registration for your region. You are responsible for providing accurate registration information and keeping your credentials confidential. You are responsible for activity under your account unless you notify us promptly via support if you suspect unauthorised access.';

  @override
  String get legalTermsSection02Title => 'Licence to use the Service';

  @override
  String get legalTermsSection02Body =>
      'We grant you a personal, non-exclusive, non-transferable, revocable licence to access and use the Service for entertainment in line with these Terms. All rights not expressly granted are reserved.';

  @override
  String get legalTermsSection03Title => 'Acceptable use';

  @override
  String get legalTermsSection03Body =>
      'You agree not to cheat, exploit bugs for unfair advantage, harass others, distribute malware, scrape or overload our systems without permission, impersonate staff, or use the Service for unlawful purposes. We may investigate reports and apply sanctions including warnings, suspensions or termination.';

  @override
  String get legalTermsSection04Title => 'Virtual items and payments';

  @override
  String get legalTermsSection04Body =>
      'Optional purchases may be available for virtual goods or features. Such purchases are subject to our Purchase of Digital Goods policy and checkout terms. Virtual items have no real-world cash value outside the Service except where mandatory law says otherwise.';

  @override
  String get legalTermsSection05Title => 'User content';

  @override
  String get legalTermsSection05Body =>
      'Where the Service allows you to submit text, images or other material, you retain ownership you already hold but grant us a licence to host, display and moderate that content as needed to operate the Service. You must have rights to anything you submit and must not upload unlawful or infringing material.';

  @override
  String get legalTermsSection06Title => 'Availability and changes';

  @override
  String get legalTermsSection06Body =>
      'We strive to keep the Service available but do not guarantee uninterrupted access. We may modify, suspend or discontinue features for maintenance, balance, legal or security reasons. We may update these Terms; continued use after notice where permitted by law constitutes acceptance of material changes.';

  @override
  String get legalTermsSection07Title => 'Disclaimer and liability';

  @override
  String get legalTermsSection07Body =>
      'The Service is provided \"as is\" to the fullest extent permitted by law. We exclude liability for indirect or consequential loss where allowed. Nothing in these Terms limits liability that cannot be limited under applicable mandatory consumer law.';

  @override
  String get legalTermsSection08Title => 'Termination';

  @override
  String get legalTermsSection08Body =>
      'You may stop using the Service at any time. We may suspend or terminate access if you breach these Terms, if required by law, or to protect the Service or other users. Provisions that by nature should survive will survive termination.';

  @override
  String get legalTermsSection09Title => 'Governing law';

  @override
  String get legalTermsSection09Body =>
      'Unless mandatory local law provides otherwise, these Terms are governed by the laws of England and Wales and disputes shall be subject to the exclusive jurisdiction of the courts of England and Wales.';

  @override
  String get legalTermsSection10Title => 'Contact';

  @override
  String get legalTermsSection10Body =>
      'For questions about these Terms, contact us through the in-game support ticket system after registration, or via official website contact channels if published.';

  @override
  String get helpTopicTrainingHubCategory => 'Szkolenie';

  @override
  String get helpTopicTrainingHubTitle => 'Centrum szkoleniowe';

  @override
  String get helpTopicTrainingHubSummary =>
      'Siłownia (siła) i strzelnica (celność) w jednym miejscu. Obydwa bonusy zwiększają Twoją szansę na powodzenie w przestępstwie; dokładność strzelania jest również wykorzystywana w akcjach na listach trafień. Każdy utwór ma swój własny czas odnowienia i limit 100 sesji.';

  @override
  String get helpTopicTrainingHubHow =>
      'Siłownia: każda sesja zwiększa twoją stałą premię do siły łącznie do +8% (100 sesji). Czas odnowienia pomiędzy sesjami wynosi 1 godzinę (VIP może go skrócić).\nZasięg strzelania: każda sesja zwiększa stałą premię do celności łącznie do +10% (100 sesji). Czas odnowienia pomiędzy sesjami wynosi 1 godzinę (VIP może go skrócić).\nObydwa bonusy są dodawane przez serwer do obliczeń sukcesu przestępstwa.\nTrenujesz każdy tor osobno: dwa liczniki czasu i dwa przyciski pociągu — jeden ekran.\nPostęp nie zostanie zresetowany, chyba że personel zastosuje surową karę.';

  @override
  String get helpTopicTrainingHubTips =>
      'Zaplanuj codziennie obie ścieżki: małe kroki łączą się w wyraźną przewagę nad przestępczością.\nPrzejrzyj przestępstwa, w których zawodzisz najbardziej: siła i celność uzupełniają się – to nie ta sama statystyka.';

  @override
  String territoryCapsLine(
    int owned,
    int maxRegions,
    int active,
    int maxContests,
  ) {
    return 'Regions $owned/$maxRegions · Contests $active/$maxContests';
  }

  @override
  String territoryCapsRegionsChip(int owned, int max) {
    return 'Regions $owned/$max';
  }

  @override
  String territoryCapsContestsChip(int active, int max) {
    return 'Contests $active/$max';
  }

  @override
  String get territoryDetailProject => 'Region project';

  @override
  String get territoryProjectSafehouse => 'Safehouse network';

  @override
  String get territoryProjectStatusBuilding => 'Building';

  @override
  String get territoryProjectStatusActive => 'Active';

  @override
  String get territoryProjectStatusDamaged => 'Damaged';

  @override
  String get territoryProjectStatusDestroyed => 'Destroyed';

  @override
  String get territoryProjectProgress => 'Progress';

  @override
  String get territoryProjectHp => 'Integrity';

  @override
  String territoryProjectIncomeBonusPct(int percent) {
    return '+$percent% passive income';
  }

  @override
  String get territoryProjectStart => 'Start safehouse project';

  @override
  String get territoryProjectContribute => 'Supply project';

  @override
  String territoryProjectHqRequired(int level) {
    return 'Requires HQ level $level';
  }

  @override
  String get territoryProjectHint =>
      'A safehouse network boosts passive income. Sabotage damages it in contests; supply runs repair or advance it.';

  @override
  String get territorySnackProjectStarted => 'Safehouse project started.';

  @override
  String get territorySnackProjectContributed => 'Project updated.';

  @override
  String get territoryErrorProjectHq =>
      'Higher HQ level required to start this project.';

  @override
  String get territoryErrorProjectNotOwner =>
      'Only the controlling crew can manage this project.';

  @override
  String get territoryErrorProjectExists =>
      'This region already has a project.';

  @override
  String get territoryErrorProjectNotFound =>
      'No project found for this region.';

  @override
  String get territoryErrorProjectDestroyed =>
      'Project destroyed - start a new one.';

  @override
  String get territoryErrorProjectActive => 'Project is already active.';

  @override
  String get territoryErrorProjectCooldown => 'Project supply is on cooldown.';

  @override
  String get territoryDramaTitle => 'Territory drama';

  @override
  String get territoryDramaHotContests => 'Hot contests';

  @override
  String get territoryDramaRecentCaptures => 'Recent captures';

  @override
  String get territoryDramaRisingCrews => 'Rising crews';

  @override
  String get territoryDramaWarTheaters => 'War theaters';

  @override
  String get territoryDramaRegionEvents => 'Region events';

  @override
  String get territoryDramaEmpty => 'No live territory drama right now.';

  @override
  String get territoryDetailRegionEvent => 'Region event';

  @override
  String get territoryEventPoliceOffensive => 'Police offensive';

  @override
  String get territoryEventHarborStrike => 'Harbor strike';

  @override
  String get territoryEventBlackoutRumor => 'Blackout rumor';

  @override
  String get launderSectionTitle => 'Money laundering';

  @override
  String launderSectionHint(int feePercent, int durationMinutes) {
    return 'Wash cash into your bank with a $feePercent% fee. Takes about $durationMinutes minutes. Higher FBI heat means higher seize risk.';
  }

  @override
  String get launderSectionCapHint =>
      'Użyj tego, aby wydać gotówkę na ulicy powyżej dzisiejszego limitu bezpłatnych wpłat.';

  @override
  String launderSeizeChance(String chance) {
    return 'Estimated seize chance: $chance%';
  }

  @override
  String launderActiveJob(String amount) {
    return 'Wash in progress. Bank payout if successful: €$amount';
  }

  @override
  String launderJobCountdown(String time) {
    return 'Completes in $time';
  }

  @override
  String launderCooldownCountdown(String time) {
    return 'Available again in $time';
  }

  @override
  String launderPreviewFee(int feePercent, String fee) {
    return 'Fee ($feePercent%): €$fee';
  }

  @override
  String launderPreviewPayout(String payout) {
    return 'Bank payout if successful: €$payout';
  }

  @override
  String get launderAmountLabel => 'Amount to wash';

  @override
  String launderAmountRange(String min, String max) {
    return 'Min. $min · Maks. $max na pranie.';
  }

  @override
  String get launderStartButton => 'Start wash';

  @override
  String get launderStartedSuccess => 'Laundering started.';

  @override
  String get launderErrorCooldown => 'Laundering is on cooldown.';

  @override
  String get launderErrorActive => 'A wash job is already running.';

  @override
  String launderErrorTooLow(String min) {
    return 'Kwota jest poniżej minimum ($min).';
  }

  @override
  String launderErrorTooHigh(String max) {
    return 'Kwota przekracza maksimum ($max).';
  }

  @override
  String get launderErrorInsufficientCash => 'Not enough cash on hand.';

  @override
  String get launderErrorDisabled => 'Money laundering is disabled.';

  @override
  String get launderErrorUnknown => 'Could not start laundering.';

  @override
  String get stockMarketTitle => 'Stock market';

  @override
  String get stockMarketHint =>
      'Trade with bank money. Prices move slowly — separate from crypto.';

  @override
  String get stockBankBalance => 'Bank balance';

  @override
  String get stockPortfolioValue => 'Portfolio value';

  @override
  String get stockQuantity => 'Quantity';

  @override
  String get stockPrice => 'Price';

  @override
  String get stockHolding => 'Holding';

  @override
  String get stockValue => 'Value';

  @override
  String get stockBuy => 'Buy';

  @override
  String get stockSell => 'Sell';

  @override
  String get stockTradeSuccess => 'Trade completed.';

  @override
  String get stockErrorInsufficientBalance => 'Not enough bank balance.';

  @override
  String get stockErrorInsufficientShares => 'Not enough shares.';

  @override
  String get stockErrorPositionLimit => 'Position limit reached.';

  @override
  String get stockErrorDisabled => 'Stock market is disabled.';

  @override
  String get stockErrorUnknown => 'Trade failed.';

  @override
  String get stockMarketLoadError => 'Could not load the stock market.';

  @override
  String get stockMarketEmpty => 'No tickers available right now.';

  @override
  String get stockMarketRetry => 'Retry';

  @override
  String stockPositionsOpen(int count) {
    return 'Open positions: $count';
  }

  @override
  String stockCashAvailable(String amount) {
    return 'Available to invest: €$amount';
  }

  @override
  String get propertyDevelopAction => 'Develop';

  @override
  String get propertyDevelopedSuccess => 'Property development complete.';

  @override
  String propertyDevelopedSuccessLevel(int level) {
    return 'Development complete — level $level.';
  }

  @override
  String get propertyDevelopConfirmTitle => 'Develop property?';

  @override
  String propertyDevelopConfirmBody(String cost, int level, int bonusPercent) {
    return 'Spend €$cost from your bank to raise development to level $level. Each level adds +$bonusPercent% passive income.';
  }

  @override
  String get propertyDevelopLevel => 'Development';

  @override
  String get propertyDevelopIncomeBonusLabel => 'Dev income bonus';

  @override
  String propertyDevelopIncomeBonus(int percent) {
    return '+$percent%';
  }

  @override
  String get propertyDevelopIncomeLabel => 'Passive income';

  @override
  String propertyDevelopActionCost(String cost, int level) {
    return 'Develop · €$cost → L$level';
  }

  @override
  String propertyDevelopCooldown(String duration) {
    return 'Develop available in $duration';
  }

  @override
  String propertyDevelopErrorCooldown(String duration) {
    return 'Development cooldown: $duration';
  }

  @override
  String get propertyDevelopErrorCooldownGeneric =>
      'Development is on cooldown.';

  @override
  String get propertyDevelopErrorMaxLevel =>
      'This property is already at max development.';

  @override
  String get propertyDevelopErrorDisabled =>
      'Property development is disabled.';

  @override
  String get propertyDevelopInsufficientBalance => 'Not enough bank balance.';

  @override
  String get propertyDevelopErrorUnknown => 'Could not develop this property.';

  @override
  String get helpTopicStockMarketCategory => 'Economy';

  @override
  String get helpTopicStockMarketTitle => 'Stock market';

  @override
  String get helpTopicStockMarketSummary =>
      'Trade slow-moving stocks with bank money. Separate system from crypto.';

  @override
  String get helpTopicStockMarketHow =>
      'Open Stock market from the dashboard. You see tickers, current price, your holdings and bank balance.\nBuy and sell execute immediately at the server price and debit/credit your bank — not cash.\nPrices tick slowly (about every minute) with light random drift and mean reversion; there is no external live feed.\nThere is a maximum number of open positions. Crypto orders, regimes and leaderboards are not part of this module.';

  @override
  String get helpTopicStockMarketTips =>
      'Keep bank reserve for crimes/travel — stocks are not emergency cash.\nDo not diversify blindly across every ticker: the position limit is tight.';

  @override
  String get premiumUiAutoRenewActive => 'Auto-renews monthly';

  @override
  String get premiumUiAutoRenewOff => 'No auto-renewal';

  @override
  String get premiumUiCancelRenewal => 'Cancel renewal';

  @override
  String premiumUiCancelRenewalConfirm(String date) {
    return 'Stop future VIP charges? Your current VIP stays active until $date.';
  }

  @override
  String get premiumUiCancelRenewalSuccess => 'Auto-renewal cancelled.';

  @override
  String get premiumUiCancelRenewalFailed => 'Could not cancel auto-renewal.';

  @override
  String get premiumUiGiftVip => 'Gift VIP';

  @override
  String get premiumUiGiftVipHint =>
      'Buy 30 days of Player VIP for another player.';

  @override
  String premiumUiGiftVipPrice(String price) {
    return 'One-time price: $price (30 days, no auto-renew).';
  }

  @override
  String get premiumUiGiftVipUsername => 'Recipient username';

  @override
  String get premiumUiGiftVipConfirm => 'Continue to checkout';

  @override
  String get premiumUiGiftVipFailed => 'Could not start VIP gift checkout.';

  @override
  String get premiumUiPrestigeLabel => 'VIP prestige';

  @override
  String get premiumUiPrestigeNone => 'None';

  @override
  String get premiumUiPrestigeBronze => 'Bronze';

  @override
  String get premiumUiPrestigeSilver => 'Silver';

  @override
  String get premiumUiPrestigeGold => 'Gold';

  @override
  String premiumUiPrestigeDays(int days) {
    return '$days lifetime days';
  }

  @override
  String premiumUiPrestigeNext(int days, String tier) {
    return '$days days to $tier';
  }

  @override
  String get premiumUiPrestigeMax => 'Max prestige reached';

  @override
  String get premiumUiGiftCrewVip => 'Gift Crew VIP';

  @override
  String get premiumUiGiftCrewVipHint =>
      'Buy 30 days of Crew VIP for any crew by name. One-time gift — no auto-renew for that crew.';

  @override
  String get premiumUiGiftCrewVipName => 'Crew name';

  @override
  String get premiumUiGiftCrewVipFailed =>
      'Could not start Crew VIP gift checkout.';
}
