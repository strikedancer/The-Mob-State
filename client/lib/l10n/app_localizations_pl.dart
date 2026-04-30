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
  String get dashboardTimeoutGym => 'Sala gimnastyczna';

  @override
  String get dashboardInfoDrugsGrams => 'Leki (gramy)';

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
  String get tuneShop => 'Sklep tuningowy';

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
  String get vaultShowWrongCodes => 'Pokazywać';

  @override
  String get vaultHideWrongCodes => 'Ukrywać';

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
  String get vaultAttemptFailedGeneric => 'Przegrany.';

  @override
  String get vaultAttemptFailedRetry => 'Przegrany. Spróbuj ponownie.';

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
  String get dashboardEconomy24h => 'Ekonomiczna 24h';

  @override
  String get dashboardGrossIncome => 'Dochód brutto';

  @override
  String get dashboardPropertySpend => 'Wydatki na nieruchomość';

  @override
  String get dashboardNetCashflow => 'Przepływy pieniężne netto';

  @override
  String get dashboardTrendVsPrevious => 'Trend vs poprzedni';

  @override
  String get dashboardActivity7d => 'Ćwiczenie 7d';

  @override
  String get dashboardVehicleThefts => 'Kradzieże pojazdów';

  @override
  String get dashboardOpsOverview => 'Przegląd operacji';

  @override
  String get dashboardActiveCooldowns => 'Aktywne czasy odnowienia';

  @override
  String get dashboardLongestTimer => 'Najdłuższy timer';

  @override
  String get dashboardActiveProduction => 'Aktywna produkcja';

  @override
  String get dashboardProductionReadyIn => 'Produkcja gotowa w';

  @override
  String get dashboardNightclubEvents => 'Imprezy w klubach nocnych';

  @override
  String get dashboardNextEventStartsIn =>
      'Następne wydarzenie rozpoczyna się za';

  @override
  String get dashboardVehiclesActiveListedTransit =>
      'Pojazdy aktywne/wystawione/przejeżdżające';

  @override
  String get dashboardLivePlayerEvents => 'Wydarzenia dla graczy na żywo';

  @override
  String get dashboardOpenEvents => 'Otwarte wydarzenia';

  @override
  String get dashboardNotificationsAndRisk => 'Powiadomienia i ryzyko';

  @override
  String get dashboardUnreadDm => 'Nieprzeczytany DM';

  @override
  String get dashboardSupportWaitingOnYou => 'Wsparcie czeka na Ciebie';

  @override
  String get dashboardEventsLast24h => 'Wydarzenia trwają 24h';

  @override
  String get dashboardRiskScore => 'Ocena ryzyka';

  @override
  String get dashboardRecruitProstitute => 'Rekrutuj prostytutkę';

  @override
  String get dashboardCrewWars => 'Wojny załóg';

  @override
  String get dashboardStatusLabel => 'Status';

  @override
  String get dashboardCanDeclare => 'Można zadeklarować';

  @override
  String get dashboardTypeLabel => 'Typ';

  @override
  String get dashboardOpponent => 'Przeciwnik';

  @override
  String get dashboardCrewPoints => 'Punkty załogi';

  @override
  String get dashboardWarRank => 'Stopień wojenny';

  @override
  String get dashboardSeasonRank => 'Ranking sezonu';

  @override
  String get dashboardOpenTargets => 'Otwarte cele';

  @override
  String get dashboardPhaseEndsIn => 'Faza kończy się w';

  @override
  String dashboardJailStatusIn(String duration) {
    return 'W więzieniu ($duration)';
  }

  @override
  String get dashboardCrewWarStatusPreparing => 'Przygotowanie';

  @override
  String get dashboardCrewWarStatusActive => 'Aktywny';

  @override
  String get dashboardCrewWarStatusLockdown => 'Izolacja';

  @override
  String get dashboardCrewWarStatusResolved => 'Rozwiązany';

  @override
  String get dashboardCrewWarStatusArchived => 'Zarchiwizowane';

  @override
  String get dashboardCrewWarStatusCancelled => 'Odwołany';

  @override
  String get dashboardCrewWarStatusNone => 'Brak aktywnej wojny';

  @override
  String get dashboardCrewWarTypeKill => 'Zabij wojnę';

  @override
  String get dashboardCrewWarTypeEconomy => 'Wojna gospodarcza';

  @override
  String get dashboardCrewWarTypeTerritory => 'Wojna terytorialna';

  @override
  String get dashboardCrewWarTypeTotal => 'Totalna wojna';

  @override
  String get dashboardTerritoryIncomeNotConfigured => 'nie skonfigurowany';

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
    return 'co $minutes min';
  }

  @override
  String get dashboardCrewTerritory => 'Terytorium załogi';

  @override
  String get dashboardRegions => 'Regiony';

  @override
  String get dashboardCountriesCaptured => 'Kraje zdobyte';

  @override
  String get dashboardPayout => 'Wypłata';

  @override
  String get dashboardEarningPerHour => 'Zarabianie teraz na godzinę';

  @override
  String get dashboardEarningPerDay => 'Zarabianie teraz dziennie';

  @override
  String get dashboardTotalEarned => 'Łącznie zarobione';

  @override
  String get dashboardVehicleOps => 'Operacje pojazdów';

  @override
  String get dashboardKillProgress => 'Zabij Postęp';

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
  String get appeal => 'Odwołanie';

  @override
  String get submitAppeal => 'Prześlij odwołanie';

  @override
  String get bribeJudge => 'Sędzia łapówkowy';

  @override
  String get bribe => 'Przekupić';

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
      'Rozpoczęto produkcję: aktywna przez 8 godzin, odbiór co 10 minut';

  @override
  String get ammoFactoryTitle => 'Fabryka Amunicji';

  @override
  String get ammoFactoryIntro =>
      'Produkuje partiami; odbierasz co 10 minut (do 8 godzin zaległości na sesję).';

  @override
  String get ammoFactoryWhatYouCanDo => 'Co możesz zrobić:';

  @override
  String get ammoFactoryActionBuy => 'Kup fabrykę w swoim obecnym kraju';

  @override
  String get ammoFactoryActionProduce =>
      'Produkcja roszczeń (interwał: 10 minut, maksymalne zaległości: 8 godzin na sesję)';

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
      'Okno produkcyjne: aktywne (przerwa 10 min)';

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
  String get educationTrackNameIt => 'TO';

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
      'Wprowadź identyfikator gracza, aby rozpocząć rywalizację.';

  @override
  String get rivalryPlayerIdHint => 'Identyfikator gracza';

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
  String get crimeCriminalRecordWipeDesc =>
      'Sfałszuj akta sądowe i wyczyść całą kartotekę karną, jeśli operacja się powiedzie.';

  @override
  String crimeCardSuccessChance(int percent) {
    return '$percent% szans na sukces';
  }

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
  String get cooldownWaitSchool => 'Catch your breath before the next lesson…';

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
}
